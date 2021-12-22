------------------------------------------------------------------
--
-- Projectname	: Register control to TX	
-- Filename		: TX_REG_01.vhd
-- Title		: 
-- Author		: Erik Henkel
-- Description	: TX REG handles the ctl/sts register to the TX logic...
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010118	1			Intial version
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

entity TX_REG is
	port (
		GP_DATA_I	: in	std_logic_vector(7 downto 0);
		GP_DATA_O	: out	std_logic_vector(7 downto 0);
		ICLK			: in	std_logic;
		TX_CLK		: in	std_logic;
		reset			: in	std_logic; --system reset
				
		--register enable signals
		TX_CTL		: in	std_logic;
		
		--CTL signals
		TX_RESET	: out	std_logic; --TX_GO = 0
		FULL_DPX	: out	std_logic; --full duplex
		ODD				: out	std_logic; --transmit ODD_FRAME
		DMA_EN		: out	std_logic;
		GO_TX			: out	std_logic; --TX logic in progress of transmitting a frame...
	
		--STS signals
		TX_DONE		: in	std_logic; --frame transmitted...
		COL				: in	std_logic; --collision
		LEGAL			: in	std_logic --frame size LEGAL (not to small not to big...just perfect)
		
		);
end entity TX_REG;

architecture structure of TX_REG is

	signal collision : std_logic; --status signal 
	signal start_sync1,start_sync2,start_sync3: std_logic;
	signal start_catch : std_logic;
	signal start	 : std_logic;
	signal ctl_reg   : std_logic_vector(7 downto 0);

	signal busy		 : std_logic;
	signal size_error: std_logic;
	signal tx_reset_int : std_logic;

begin

--set CTL register
process(ICLK,TX_CTL,reset,GP_DATA_I) is

begin
	if reset = '1' then
		ctl_reg(4) 	<= '0';
		ctl_reg(2) 	<= '0';
		DMA_EN		<= '0';
		start 		<= '0';
		tx_reset_int <= '1';		
	elsif rising_edge(ICLK) then
		if TX_CTL = '1' then
			tx_reset_int <= not GP_DATA_I(7);
			DMA_EN 		 <= GP_DATA_I(6);
			ctl_reg(4) 	 <= GP_DATA_I(4);
			ctl_reg(2) 	 <= GP_DATA_I(2);
			start 		 <= GP_DATA_I(7);		
		else			
			tx_reset_int <= '0';
			start <= '0';
		end if;
	end if;
end process;

TX_RESET 	<= tx_reset_int;

--set CTL bits:
--TX_RESET <= (not gp_data(7) and TX_CTL) or reset; 
FULL_DPX 	<= ctl_reg(4);
ODD 	<= ctl_reg(2);

--read STS register
GP_DATA_O <= ctl_reg;

--set sts bits
ctl_reg(7) <= busy;
ctl_reg(3) <= size_error;
ctl_reg(1) <= '0';
ctl_reg(6) <= collision;
ctl_reg(5) <= '0';
ctl_reg(0) <= '0';

--set collision bit...
process(ICLK,reset) is
begin
	if reset = '1' then
		collision <= '0';
	elsif rising_edge(ICLK) then
		if TX_CTL = '1' then
			collision <= '0';		
		elsif COL = '1' then
			collision <= '1';		
		end if;
	end if;
end process;

--set SIZE_ERROR
process(ICLK,tx_reset_int) is
begin
	if tx_reset_int = '1' then
		SIZE_ERROR <= '0';
	elsif rising_edge(ICLK) then
		if start = '1' and legal = '0' then
			size_error <= '1';
		end if;
	end if;
end process;

--set busy
process(ICLK,tx_reset_int,TX_DONE) is
begin
	if tx_reset_int = '1' or TX_DONE = '1' then
		busy <= '0';
	elsif rising_edge(ICLK) then
		if start = '1' and legal = '1' then
			busy <= '1';
		end if;
	end if;
end process;

--set busy
process(TX_CLK,tx_reset_int,TX_DONE) is
begin
	if tx_reset_int = '1' or TX_DONE = '1' then
		GO_TX <= '0';
	elsif rising_edge(TX_CLK) then
		GO_TX <= busy;
	end if;
end process;

end architecture structure;
		
		
