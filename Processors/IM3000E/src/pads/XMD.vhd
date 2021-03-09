library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity XMD is
	port (
		O		: out   std_logic;
		I		: in    std_logic;
		PU	: in    std_logic;
		PD	: in    std_logic;
		SMT	: in    std_logic);
end XMD;

architecture struct of XMD is
begin
	O <= I;
end struct;

    














