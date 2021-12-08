------------------------------------------------------------------
--
-- Projectname	: RX CTL/STS Register	
-- Filename		: RX_REG_01.vhd
-- Title		: RX REG
-- Author		: Erik Henkel
-- Description	: RX CTL/STS register...
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

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity RX_REG is
	port(
		clk_i				: in	std_logic; --GP1000 CLK
		rx_ctl			: in	std_logic; --write register
		id_i		: in	std_logic_vector(7 downto 0);
		id_o		: out	std_logic_vector(7 downto 0);
		
		--CTL bits
		rx_go				: out	std_logic; --Start RX logic
		rx_reset		: out	std_logic; --Reset RX logic
		multicast		: out	std_logic; --accept multicast frames
		promiscuous	: out	std_logic; --accept all frames

		--STS bits
		fsv					: in	std_logic; --Frame Status Valid
		fsovr				: in	std_logic; --Frame Status FIFO OVERRUN
		tip					: in	std_logic; --transfer in progress
		early_er		: in	std_logic; --early MII ER flag
		
		--system reset
		reset				: in	std_logic
		);
end entity RX_REG;

architecture structure of RX_REG is

	signal ctl_reg : std_logic_vector(7 downto 4);
	signal sts_reg : std_logic_vector(3 downto 0);

begin

--WRITE CTL REG
process(clk_i,reset,rx_ctl,id_i) is

begin
	if reset = '1' then
		ctl_reg <= (others => '0');		
	elsif rising_edge(clk_i) then
		if rx_ctl = '1' then
			ctl_reg <= id_i(7 downto 4);
		end if;
	end if;
end process;

--set CTL bits
rx_go 		<= ctl_reg(7);
rx_reset 	<= ctl_reg(6);
multicast 	<= ctl_reg(5);
promiscuous <= ctl_reg(4);

--SET STS bits
sts_reg(3) <= fsv;
sts_reg(2) <= fsovr;
sts_reg(1) <= tip;
sts_reg(0) <= early_er;

--READ STS REG
id_o(7 downto 4) <= CTL_REG;
id_o(3 downto 0) <= STS_REG;

end architecture structure;
		
				
