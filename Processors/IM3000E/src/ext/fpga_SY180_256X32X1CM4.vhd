library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use work.all;

entity fpga_SY180_256X32X1CM4 is
	port (
		A0		:	in	std_logic; 
		A1		:	in	std_logic; 
		A2		:	in	std_logic; 
		A3		:	in	std_logic; 
		A4		:	in	std_logic; 
		A5		:	in	std_logic; 
		A6		:	in	std_logic; 
		A7		:	in	std_logic; 
		DO0		: out std_logic;
		DO1		: out std_logic;
		DO2		: out std_logic;
		DO3		: out std_logic;
		DO4		: out std_logic;
		DO5		: out std_logic;
		DO6		: out std_logic;
		DO7		: out std_logic;
		DO8		: out std_logic;
		DO9		: out std_logic;
		DO10	: out std_logic;
		DO11	: out std_logic;
		DO12	: out std_logic;
		DO13	: out std_logic;
		DO14	: out std_logic;
		DO15	: out std_logic;
		DO16	: out std_logic;
		DO17	: out std_logic;
		DO18	: out std_logic;
		DO19	: out std_logic;
		DO20	: out std_logic;
		DO21	: out std_logic;
		DO22	: out std_logic;
		DO23	: out std_logic;
		DO24	: out std_logic;
		DO25	: out std_logic;
		DO26	: out std_logic;
		DO27	: out std_logic;
		DO28	: out std_logic;
		DO29	: out std_logic;
		DO30	: out std_logic;
		DO31	: out std_logic;
		DI0		: in std_logic;
		DI1		: in std_logic;
		DI2		: in std_logic;
		DI3		: in std_logic;
		DI4		: in std_logic;
		DI5		: in std_logic;
		DI6		: in std_logic;
		DI7		: in std_logic;
		DI8		: in std_logic;
		DI9		: in std_logic;
		DI10	: in std_logic;
		DI11	: in std_logic;
		DI12	: in std_logic;
		DI13	: in std_logic;
		DI14	: in std_logic;
		DI15	: in std_logic;
		DI16	: in std_logic;
		DI17	: in std_logic;
		DI18	: in std_logic;
		DI19	: in std_logic;
		DI20	: in std_logic;
		DI21	: in std_logic;
		DI22	: in std_logic;
		DI23	: in std_logic;
		DI24	: in std_logic;
		DI25	: in std_logic;
		DI26	: in std_logic;
		DI27	: in std_logic;
		DI28	: in std_logic;
		DI29	: in std_logic;
		DI30	: in std_logic;
		DI31	: in std_logic;
		WEB	: in	std_logic;
		CK	: in	std_logic;
		CSB	: in	std_logic);
end fpga_SY180_256X32X1CM4;

architecture struct of fpga_SY180_256X32X1CM4 is
	type ram_type is array (255 downto 0) of std_logic_vector(31 downto 0);
	signal RAM	: ram_type;
	signal addr	: std_logic_vector(7 downto 0);
	signal di		: std_logic_vector(31 downto 0);
	signal do		: std_logic_vector(31 downto 0);
	attribute ram_style					: string;
	attribute ram_style of RAM	: signal is "block";

begin
	addr(7)		<= A7; 
	addr(6)		<= A6; 
	addr(5)		<= A5; 
	addr(4)		<= A4; 
	addr(3)		<= A3; 
	addr(2)		<= A2; 
	addr(1)		<= A1; 
	addr(0)		<= A0; 

	di(31)	<= DI31; 
	di(30)	<= DI30; 
	di(29)	<= DI29; 
	di(28)	<= DI28; 
	di(27)	<= DI27; 
	di(26)	<= DI26; 
	di(25)	<= DI25; 
	di(24)	<= DI24; 
	di(23)	<= DI23; 
	di(22)	<= DI22; 
	di(21)	<= DI21; 
	di(20)	<= DI20; 
	di(19)	<= DI19; 
	di(18)	<= DI18; 
	di(17)	<= DI17; 
	di(16)	<= DI16; 
	di(15)	<= DI15; 
	di(14)	<= DI14; 
	di(13)	<= DI13; 
	di(12)	<= DI12; 
	di(11)	<= DI11; 
	di(10)	<= DI10; 
	di(9)		<= DI9; 
	di(8)		<= DI8; 
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
			if CSB = '0' then
				if WEB = '0' then
					RAM(conv_integer(addr)) <= di;
				end if;
				do <= RAM(conv_integer(addr));
			end if;
		end if;
	end process;

	DO31	<= do(31);
	DO30	<= do(30);
	DO29	<= do(29);
	DO28	<= do(28);
	DO27	<= do(27);
	DO26	<= do(26);
	DO25	<= do(25);
	DO24	<= do(24);
	DO23	<= do(23);
	DO22	<= do(22);
	DO21	<= do(21);
	DO20	<= do(20);
	DO19	<= do(19);
	DO18	<= do(18);
	DO17	<= do(17);
	DO16	<= do(16);
	DO15	<= do(15);
	DO14	<= do(14);
	DO13	<= do(13);
	DO12	<= do(12);
	DO11	<= do(11);
	DO10	<= do(10);
	DO9		<= do(9);
	DO8		<= do(8);
	DO7		<= do(7);
	DO6		<= do(6);
	DO5		<= do(5);
	DO4		<= do(4);
	DO3		<= do(3);
	DO2		<= do(2);
	DO1		<= do(1);
	DO0		<= do(0);
end struct;

    














