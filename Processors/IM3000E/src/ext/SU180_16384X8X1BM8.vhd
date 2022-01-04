library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity SU180_16384X8X1BM8 is
	port (
		A0		:	in	std_logic; 
		A1		:	in	std_logic; 
		A2		:	in	std_logic; 
		A3		:	in	std_logic; 
		A4		:	in	std_logic; 
		A5		:	in	std_logic; 
		A6		:	in	std_logic; 
		A7		:	in	std_logic; 
		A8		:	in	std_logic; 
		A9		:	in	std_logic; 
		A10		:	in	std_logic;
		A11		:	in	std_logic;
		A12		:	in	std_logic;
		A13		:	in	std_logic;
		DO0		: out std_logic;
		DO1		: out std_logic;
		DO2		: out std_logic;
		DO3		: out std_logic;
		DO4		: out std_logic;
		DO5		: out std_logic;
		DO6		: out std_logic;
		DO7		: out std_logic;
		DI0		: in std_logic;
		DI1		: in std_logic;
		DI2		: in std_logic;
		DI3		: in std_logic;
		DI4		: in std_logic;
		DI5		: in std_logic;
		DI6		: in std_logic;
		DI7		: in std_logic;
		WEB	: in	std_logic;
		CK	: in	std_logic;
		CS	: in	std_logic;
		OE	: in	std_logic);
end SU180_16384X8X1BM8;

architecture struct of SU180_16384X8X1BM8 is
	type ram_type is array (16383 downto 0) of std_logic_vector(7 downto 0);
	signal RAM	: ram_type;
	signal addr	: std_logic_vector(13 downto 0);
	signal di		: std_logic_vector(7 downto 0);
	signal do		: std_logic_vector(7 downto 0);
	attribute ram_style					: string;
	attribute ram_style of RAM	: signal is "block";

begin
	addr(13)	<= A13; 
	addr(12)	<= A12; 
	addr(11)	<= A11; 
	addr(10)	<= A10; 
	addr(9)		<= A9; 
	addr(8)		<= A8; 
	addr(7)		<= A7; 
	addr(6)		<= A6; 
	addr(5)		<= A5; 
	addr(4)		<= A4; 
	addr(3)		<= A3; 
	addr(2)		<= A2; 
	addr(1)		<= A1; 
	addr(0)		<= A0; 

	di(7)		<= DI7; 
	di(6)		<= DI6; 
	di(5)		<= DI5; 
	di(4)		<= DI4; 
	di(3)		<= DI3; 
	di(2)		<= DI2; 
	di(1)		<= DI1; 
	di(0)		<= DI0; 

	process (CK)
	begin
		if rising_edge(CK) then
			if CS = '1' then
				if WEB = '0' then
					RAM(conv_integer(addr)) <= di;
				end if;
				do <= RAM(conv_integer(addr));
			end if;
		end if;
	end process;

	DO7		<= do(7) when OE = '1' else '0';
	DO6		<= do(6) when OE = '1' else '0';
	DO5		<= do(5) when OE = '1' else '0';
	DO4		<= do(4) when OE = '1' else '0';
	DO3		<= do(3) when OE = '1' else '0';
	DO2		<= do(2) when OE = '1' else '0';
	DO1		<= do(1) when OE = '1' else '0';
	DO0		<= do(0) when OE = '1' else '0';
end struct;

    














