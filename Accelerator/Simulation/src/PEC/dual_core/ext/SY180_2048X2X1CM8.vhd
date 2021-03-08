library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity SY180_2048X2X1CM8 is
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
		DO0		: out std_logic;
		DO1		: out std_logic;
		DI0		: in std_logic;
		DI1		: in std_logic;
		WEB	: in	std_logic;
		CK	: in	std_logic;
		CSB	: in	std_logic);
end SY180_2048X2X1CM8;

architecture struct of SY180_2048X2X1CM8 is
	type ram_type is array (2047 downto 0) of std_logic_vector(1 downto 0);
	signal RAM	: ram_type;
	signal addr	: std_logic_vector(10 downto 0);
	signal di		: std_logic_vector(1 downto 0);
	signal do		: std_logic_vector(1 downto 0);
	attribute ram_style					: string;
	attribute ram_style of RAM	: signal is "block";

begin
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

	di(1)		<= DI1; 
	di(0)		<= DI0; 

	process (CK)
	begin
		if rising_edge(CK) then
			if CSB = '0' then
				if WEB = '0' then
					RAM(conv_integer(addr)) <= di;
				end if;
				do <= RAM(conv_integer(addr));
			end if;
		end if;
	end process;

	DO1		<= do(1);
	DO0		<= do(0);
end struct;

    














