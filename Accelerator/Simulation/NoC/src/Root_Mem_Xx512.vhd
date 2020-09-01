-- Part of NoC simulation pkg
-- 
-- Design: Imsys AB
-- Implemented: Bengt Andersson
-- Revision 0


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.defines.all;


entity Root_Mem is
	port (
		address	:in std_logic_vector (7 downto 0);
		DOut	: out std_logic_vector (511 downto 0);
		DIn		: in std_logic_vectorn(511 downto 0);
		clk	: in	std_logic;
		we	
		cs	: in	std_logic;
		oe	: in	std_logic);
end Root_Mem;

architecture struct of Root_Mem is
	type ram_type is array (255 downto 0) of std_logic_vector(511 downto 0);
	signal RAM	: ram_type;
	signal addr	: std_logic_vector(7 downto 0);
	signal di		: std_logic_vector(511 downto 0);
	signal do		: std_logic_vector(511 downto 0);
	attribute ram_style					: string;
	attribute ram_style of RAM	: signal is "block";

begin
	addr <= address; 
	di 	<= DIn; 

	process (clk)
	begin
		if rising_edge(clk) then
			if cs = '1' then
				if we = '0' then
					RAM(conv_integer(addr)) <= di;
				end if;
				do <= RAM(conv_integer(addr));
			end if;
		end if;
	end process;

	DOut <= do when oe = '1' else Z;
end struct;

    














