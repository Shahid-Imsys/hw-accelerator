library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity ZMA2GSD is
	port (
		O  	: out   std_logic;
		I  	: in    std_logic;
		IO 	: inout std_logic;
		E  	: in    std_logic;
		E2 	: in    std_logic;
		E4 	: in    std_logic;
		E8 	: in    std_logic;
		SR 	: in    std_logic;
		PU 	: in    std_logic;
		PD 	: in    std_logic;
		SMT	: in    std_logic);
end ZMA2GSD;

architecture struct of ZMA2GSD is
begin
	O <= IO;
	IO <= I when E = '1' else 'Z';
end struct;

    














