library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity YA2GSD is
	port (
		O		: out   std_logic;
		I		: in    std_logic;
		E		: in    std_logic;
		E2	: in    std_logic;
		E4	: in    std_logic;
		E8	: in    std_logic;
		SR	: in    std_logic);
end YA2GSD;

architecture struct of YA2GSD is
begin
	O <= I;
end struct;

    














