-- NoC MUX Part of NoC simulation pkg
-- 
-- Design: Harald bergh
-- Implemented: Bengt Andersson
-- Revision 0


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.defines.all;



entity mux_2x64B is 
port (
	mux_in_a : in  std_logic_vector (511 downto 0);
	mux_in_b : in  std_logic_vector (511 downto 0);
	mux_sel  : in  std_logic;
	mux_out  : out std_logic_vector (511 downto 0)
);
end entity mux_2x64B;



architecture mux_2x64B_rtl of mux_2x64B is
begin
	process (mux_sel, mux_in_a, mux_in_b)
	begin		
		if mux_sel = '0' then
			mux_out <= mux_in_a;
		else 
			mux_out <= mux_in_b;
		end if;
	end process;
end architecture mux_2x64B_rtl;