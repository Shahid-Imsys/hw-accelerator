------------------------------------------------------------------
--
-- Projectname	: General Purpose Timer	
-- Filename		: TX_GPT_01.vhd
-- Title		: GPT
-- Author		: Erik Henkel	
-- Description	: A general purpose timer. Counts to 7/15 cycles
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

entity GPT is
	port(
		TX_CLK	: in std_logic;
		CLR		: in std_logic;
		
		GPT_7	: out std_logic; --7 cycles
		GPT_15	: out std_logic --15 cycles
		);
end entity GPT;

architecture structure of GPT is

	signal GPT_count : std_logic_vector(3 downto 0);
	
begin

GPT_7 	<=	'1' when GPT_count(3 downto 0) = "0111" else '0';
GPT_15 	<=	'1' when GPT_count(3 downto 0) = "1111" else '0';

process (TX_CLK,CLR) is

begin
	if rising_edge(TX_CLK) then
		if CLR = '1' then
			GPT_count <= (others => '0');
		else
			GPT_count <= GPT_count+1;
		end if;	
	end if;	
end process;

end architecture structure;
