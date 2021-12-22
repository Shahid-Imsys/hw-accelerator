------------------------------------------------------------------
--
-- Projectname	: RX_ADR_MEM	
-- Filename		: RX_ADR_MEM_01.vhd
-- Title		: RX ADR 
-- Author		: Erik Henkel
-- Description	: In this block the processor can write 12 nibbles
--				of destination address to start filtration of FRAMES.
--				this block also detects PREAMBLE,BROADCAST,MULTICAST
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010123	1			Intial version
--	010504	1.01	Changed position of broadcast bit from bit 7 to bit 0
-- 
--
-------------------------------------------------------------------

--The IEEE standard 1164 package, declares std_logic, rising_edge(), etc.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--simulation of Spartan2 components: (remove during syntesis)
--library unisim;
--use unisim.vcomponents.all;

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity RX_ADR_MEM is
	port(
		clk_i		: in std_logic; --GP1000 CLK
		idi		: in std_logic_vector(7 downto 0); 
		rx_da_wr		: in std_logic; --write 12 nibbles of adr
		ilioa		: in std_logic; --adr strobe
		
		clk_rx		: in std_logic; --PHY CLK
		rxd			: in std_logic_vector(3 downto 0);
		find_adr	: in std_logic; --Find Adr..high for 12 nibbles...	
		c_11		: out std_logic; --12 nibbles gone by...	
		
		--status bits
		eqda		: out std_logic; --correct adr...
		eqff		: out std_logic; --broadcast...
		eqmc		: out std_logic; --multicast
		eqsfd		: out std_logic; --Start of Frame Delimiter found...
		
		reset		: in std_logic
		);
end entity RX_ADR_MEM;

architecture structure of RX_ADR_MEM is

	--store 12 nibbles of ADR
	type adr_array is array (11 downto 0) of std_logic_vector(3 downto 0);
	signal adr_mem : adr_array;
	signal w_adr	: std_logic_vector(3 downto 0);
	signal adr_data	: std_logic_vector(3 downto 0);
	
	--find SFD
	signal RXD_byte	: std_logic_vector(7 downto 0);
	signal rxd_reg	: std_logic_vector(3 downto 0);
	
	--general counter...
	signal count	: std_logic_vector(3 downto 0);
	
	signal EQDAn_ok,EQFFn_ok,eqmc_found	: std_logic;
	signal EQDAi,EQFFi,EQMCi			: std_logic; --internal signals	
	
begin
	-- Detect SFD in incoming data stream.
	process (clk_rx, reset)
	begin
		if reset = '1' then
			rxd_reg <= (others => '0');
		elsif rising_edge(clk_rx) then
			rxd_reg <= rxd;
		end if;
	end process;
	eqsfd <= '1' when rxd_reg & rxd = x"5D" else '0';

	-- Write address memory one nibble at a time.
	process (clk_i, ilioa, reset)
	begin
		if reset = '1' or ilioa = '0' then
			w_adr <= (others => '0');
		elsif rising_edge(clk_i) then
			if rx_da_wr = '1' then
				adr_mem(conv_integer(w_adr)) <= idi(3 downto 0);
				w_adr <= w_adr + 1;
			end if;
		end if;
	end process;

	find_adr <= '1' when rx_state = FIND_ADR else '0';

	-- Read address memory one nibble at a time during the
	-- FIND_ADR state. The c_11 signal marks the end of this
	-- state.
	process (clk_rx, reset, find_adr)
	begin
		if reset = '1' or find_adr = '0' then
			count <= (others => '0');
		elsif rising_edge(clk_rx) then
			if count = 11 then
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	c_11 <= '1' when count = 11 else '0';
	adr_data <= adr_mem(conv_integer(count));

	-- Broadcast, multicast or own address?
	process (clk_rx, reset, find_adr)
	begin
		if reset = '1' or find_adr = '0' then
			eqff_all <= '1';
			eqmc_1st <= '0';
			eqda_all <= '1';
		elsif rising_edge(clk_rx) then
			if eqff_this = '0' then
				eqff_all <= '0';
			end if;
			if eqmc_this then
				eqmc_1st <= '1';
			end if;
			if eqda_this = '0' then
				eqda_all <= '0';
			end if;
		end if;
	end process;
	eqff_this <= '1' when rxd = x"F" else '0';
	eqmc_this <= '1' when count = "0000" and rxd(0) = '1' else '0';
	eqda_this <= '1' when rxd = adr_data else '0';
	eqff <= find_adr and eqff_all and eqff_this;   
	eqmc <= find_adr and (eqmc_1st or eqmc_this);
	eqda <= find_adr and eqda_all and eqda_this;   
end architecture structure;
