library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity ZMA2GSD is
	port (
		O  	: out   std_logic;
		I  	: in    std_logic;
		IO 	: inout std_logic;
		E  	: in    std_logic;
		E2 	: in    std_logic := '0';
		E4 	: in    std_logic := '0';
		E8 	: in    std_logic := '0';
		SR 	: in    std_logic := '0';
		PU 	: in    std_logic := '0';
		PD 	: in    std_logic := '0';
		SMT	: in    std_logic := '0');
end ZMA2GSD;

architecture struct of ZMA2GSD is
begin
	O <= IO;
	IO <= I when E = '1' else 'Z';
end struct;

    














