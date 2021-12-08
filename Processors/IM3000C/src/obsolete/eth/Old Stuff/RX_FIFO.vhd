------------------------------------------------------------------
--
-- Projectname	: RX FIFO	
-- Filename		: RX_FIFO_01.vhd
-- Title		: RX FIFO
-- Author		: Erik Henkel
-- Description	: Store FRAME DATA, nibbles in, bytes out...
--				512 bytes of FRAME data can be stored.
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010123	1			Intial version
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
--use work.vcomponents.all;

--library virtex;
--use virtex.components.all;

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity RX_FIFO is
	port(
		--PHY interface
		clk_rx		: in std_logic; --PHY CLK
		start_rx_logic		: in std_logic; --RX_DV and SFD detected...
		rxd			: in std_logic_vector(3 downto 0); --nibble in...
				
		--GP1000 interface
		clk_i		: in std_logic; --GP1000 CLK
		idack_rx		: in std_logic; 
		idreq_rx		: out std_logic;
		req_en		: in std_logic; --turn of idreq_rx during ADR compare state
		
		--STATUS signals
		full		: out std_logic; --FIFO full
		empty		: out std_logic; --FIFO empty
		add_byte	: in std_logic; --ADD BYTE...
		
		--reset FIFO
		clear_rx_logic		: in std_logic --clear FIFO
		);
end entity RX_FIFO;

architecture structure of RX_FIFO is

	--BLOCK RAM component
	component RAMB4_S4_S8
		port(
			WEA		: in std_logic;
			ENA		: in std_logic;
			RSTA	: in std_logic;
			CLKA	: in std_logic;
			ADDRA	: in std_logic_vector(9 downto 0);
			DIA		: in std_logic_vector(3 downto 0);
			WEB		: in std_logic;
			ENB		: in std_logic;
			RSTB	: in std_logic;
			CLKB	: in std_logic;
			ADDRB	: in std_logic_vector(8 downto 0);
			DIB		: in std_logic_vector(7 downto 0);
			DOA		: out std_logic_vector(3 downto 0);
			DOB		: out std_logic_vector(7 downto 0)
			);
	end component;
	
	--BLOCK RAM signals
	signal dummy_bus	: std_logic_vector(7 downto 0);
	signal WEA,WEB		: std_logic;
	signal RST			: std_logic;
	signal EN			: std_logic;
	signal rxf_wctr		: std_logic_vector(rxf_size downto 0);
	signal rxf_rctr		: std_logic_vector(rxf_size-1 downto 0);
	signal rxf_count		: std_logic_vector(rxf_size downto 0);
	signal rxf_dout	: std_logic_vector(7 downto 0);
	
	--control signals
	signal wdack,rdack	: std_logic;
	signal w_mem		: std_logic;
	signal want_dma			: std_logic;
	signal new_req			: std_logic;
	signal old_req			: std_logic;
	signal dma_req_off	: std_logic;
	signal aempty : std_logic;
	signal one_byte_out	: std_logic;
	signal rxf_wctr_sync	: std_logic;	

begin

--BLOCK RAM component:
	FIFO1: RAMB4_S4_S8
		port map(
			WEA		=> WEA,
			ENA		=> EN,
			RSTA	=> RST,
			CLKA	=> clk_rx,
			ADDRA	=> rxf_wctr(9 downto 0),
			DIA		=> rxd,
			WEB		=> WEB,
			ENB		=> EN,
			RSTB	=> RST,
			CLKB	=> clk_i,
			ADDRB	=> rxf_rctr(8 downto 0),
			DIB		=> dummy_bus,
			DOA		=> open,
			DOB		=> rxf_dout
			);


	-- Write counter and fifo write.
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_wctr <= (others => '0');
		elsif rising_edge(clk_rx) then
			if start_rx_logic = '1' then
				rx_fifo(conv_integer(rxf_wctr)) <= rxd;
				rxf_wctr <= rxf_wctr+1;
			elsif add_byte = '1' then
				rxf_wctr <= rxf_wctr+2;
			end if;
		end if;
	end process;
	
	-- Read counter and fifo read.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_rctr <= (others => '0');
		elsif rising_edge(clk_i) then
			if idack_rx = '0' then
				rxf_rctr <= rxf_rctr+1;
			end if;
		end if;
	end process;
	rxf_dout <= rx_fifo(conv_integer(rxf_rctr & '0')) & rx_fifo(conv_integer(rxf_rctr & '1'));

	-- Level counter and fifo flags.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_count <= (others => '0');
		elsif rising_edge(clk_i) then
			if (w_cnt2_i xor w_cnt2_i2 xnor idack_rx) = '1' then 
				if idack_rx = '0' then
					rxf_count <= rxf_count-1;
				else
					rxf_count <= rxf_count+1;
				end if;
			end if;
			w_cnt2_i <= rxf_wctr(2);
			w_cnt2_i2 <= w_cnt2_i;
		end if;
	end process;
	full <= '1' when rxf_count(rxf_size) = '1' else '0';
	empty <= '1' when rxf_count = (others => '0') else '0';
	aempty <= '1' when rxf_count(rxf_size downto 1) = (others => '0') and rxf_count(0) = '1' else '0';

	-- DMA request logic.
	idreq_rx <= '1' when req_en = '0' else										-- No req when not enabled
							'1' when empty = '1' else											-- No req when fifo empty
							'1' when amepty = '1' and idack_rx = '0' else	-- No req when last byte already ack'ed
							'0';																					-- Otherwise, request
end architecture structure;
