library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.all;

entity SP180_8192X80BM1A is
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
		DO32	: out std_logic;
		DO33	: out std_logic;
		DO34	: out std_logic;
		DO35	: out std_logic;
		DO36	: out std_logic;
		DO37	: out std_logic;
		DO38	: out std_logic;
		DO39	: out std_logic;
		DO40	: out std_logic;
		DO41	: out std_logic;
		DO42	: out std_logic;
		DO43	: out std_logic;
		DO44	: out std_logic;
		DO45	: out std_logic;
		DO46	: out std_logic;
		DO47	: out std_logic;
		DO48	: out std_logic;
		DO49	: out std_logic;
		DO50	: out std_logic;
		DO51	: out std_logic;
		DO52	: out std_logic;
		DO53	: out std_logic;
		DO54	: out std_logic;
		DO55	: out std_logic;
		DO56	: out std_logic;
		DO57	: out std_logic;
		DO58	: out std_logic;
		DO59	: out std_logic;
		DO60	: out std_logic;
		DO61	: out std_logic;
		DO62	: out std_logic;
		DO63	: out std_logic;
		DO64	: out std_logic;
		DO65	: out std_logic;
		DO66	: out std_logic;
		DO67	: out std_logic;
		DO68	: out std_logic;
		DO69	: out std_logic;
		DO70	: out std_logic;
		DO71	: out std_logic;
		DO72	: out std_logic;
		DO73	: out std_logic;
		DO74	: out std_logic;
		DO75	: out std_logic;
		DO76	: out std_logic;
		DO77	: out std_logic;
		DO78	: out std_logic;
		DO79	: out std_logic;
		CK		:	in	std_logic;
		CS		:	in	std_logic;
		OE		:	in	std_logic);
end SP180_8192X80BM1A;

architecture struct of SP180_8192X80BM1A is
	type rom_type is array (8191 downto 0) of bit_vector(79 downto 0);

	impure function init_rom_from_file (rom_file_name : in string) return rom_type is
		FILE rom_file : text is in rom_file_name;
		variable rom_file_line : line;
		variable ROM : rom_type;
		begin
			for i in rom_type'range loop
				readline(rom_file, rom_file_line);
				read(rom_file_line, ROM(i));
			end loop;
		return ROM;
	end function;

	signal ROM	: rom_type := init_rom_from_file("mprom00.data");
	signal addr	: std_logic_vector(11 downto 0);
	signal data	: std_logic_vector(79 downto 0);
	attribute rom_style					: string;
	attribute rom_style of ROM	: signal is "block";

begin
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

	process (CK)
	begin
		if rising_edge(CK) then
			if CS = '1' then
				data <= to_stdlogicvector(ROM(conv_integer(addr)));
			end if;
		end if;
	end process;

	DO79	<= data(79) when OE = '1' else 'Z';
	DO78	<= data(78) when OE = '1' else 'Z';
	DO77	<= data(77) when OE = '1' else 'Z';
	DO76	<= data(76) when OE = '1' else 'Z';
	DO75	<= data(75) when OE = '1' else 'Z';
	DO74	<= data(74) when OE = '1' else 'Z';
	DO73	<= data(73) when OE = '1' else 'Z';
	DO72	<= data(72) when OE = '1' else 'Z';
	DO71	<= data(71) when OE = '1' else 'Z';
	DO70	<= data(70) when OE = '1' else 'Z';
	DO69	<= data(69) when OE = '1' else 'Z';
	DO68	<= data(68) when OE = '1' else 'Z';
	DO67	<= data(67) when OE = '1' else 'Z';
	DO66	<= data(66) when OE = '1' else 'Z';
	DO65	<= data(65) when OE = '1' else 'Z';
	DO64	<= data(64) when OE = '1' else 'Z';
	DO63	<= data(63) when OE = '1' else 'Z';
	DO62	<= data(62) when OE = '1' else 'Z';
	DO61	<= data(61) when OE = '1' else 'Z';
	DO60	<= data(60) when OE = '1' else 'Z';
	DO59	<= data(59) when OE = '1' else 'Z';
	DO58	<= data(58) when OE = '1' else 'Z';
	DO57	<= data(57) when OE = '1' else 'Z';
	DO56	<= data(56) when OE = '1' else 'Z';
	DO55	<= data(55) when OE = '1' else 'Z';
	DO54	<= data(54) when OE = '1' else 'Z';
	DO53	<= data(53) when OE = '1' else 'Z';
	DO52	<= data(52) when OE = '1' else 'Z';
	DO51	<= data(51) when OE = '1' else 'Z';
	DO50	<= data(50) when OE = '1' else 'Z';
	DO49	<= data(49) when OE = '1' else 'Z';
	DO48	<= data(48) when OE = '1' else 'Z';
	DO47	<= data(47) when OE = '1' else 'Z';
	DO46	<= data(46) when OE = '1' else 'Z';
	DO45	<= data(45) when OE = '1' else 'Z';
	DO44	<= data(44) when OE = '1' else 'Z';
	DO43	<= data(43) when OE = '1' else 'Z';
	DO42	<= data(42) when OE = '1' else 'Z';
	DO41	<= data(41) when OE = '1' else 'Z';
	DO40	<= data(40) when OE = '1' else 'Z';
	DO39	<= data(39) when OE = '1' else 'Z';
	DO38	<= data(38) when OE = '1' else 'Z';
	DO37	<= data(37) when OE = '1' else 'Z';
	DO36	<= data(36) when OE = '1' else 'Z';
	DO35	<= data(35) when OE = '1' else 'Z';
	DO34	<= data(34) when OE = '1' else 'Z';
	DO33	<= data(33) when OE = '1' else 'Z';
	DO32	<= data(32) when OE = '1' else 'Z';
	DO31	<= data(31) when OE = '1' else 'Z';
	DO30	<= data(30) when OE = '1' else 'Z';
	DO29	<= data(29) when OE = '1' else 'Z';
	DO28	<= data(28) when OE = '1' else 'Z';
	DO27	<= data(27) when OE = '1' else 'Z';
	DO26	<= data(26) when OE = '1' else 'Z';
	DO25	<= data(25) when OE = '1' else 'Z';
	DO24	<= data(24) when OE = '1' else 'Z';
	DO23	<= data(23) when OE = '1' else 'Z';
	DO22	<= data(22) when OE = '1' else 'Z';
	DO21	<= data(21) when OE = '1' else 'Z';
	DO20	<= data(20) when OE = '1' else 'Z';
	DO19	<= data(19) when OE = '1' else 'Z';
	DO18	<= data(18) when OE = '1' else 'Z';
	DO17	<= data(17) when OE = '1' else 'Z';
	DO16	<= data(16) when OE = '1' else 'Z';
	DO15	<= data(15) when OE = '1' else 'Z';
	DO14	<= data(14) when OE = '1' else 'Z';
	DO13	<= data(13) when OE = '1' else 'Z';
	DO12	<= data(12) when OE = '1' else 'Z';
	DO11	<= data(11) when OE = '1' else 'Z';
	DO10	<= data(10) when OE = '1' else 'Z';
	DO9		<= data(9) when OE = '1' else 'Z';
	DO8		<= data(8) when OE = '1' else 'Z';
	DO7		<= data(7) when OE = '1' else 'Z';
	DO6		<= data(6) when OE = '1' else 'Z';
	DO5		<= data(5) when OE = '1' else 'Z';
	DO4		<= data(4) when OE = '1' else 'Z';
	DO3		<= data(3) when OE = '1' else 'Z';
	DO2		<= data(2) when OE = '1' else 'Z';
	DO1		<= data(1) when OE = '1' else 'Z';
	DO0		<= data(0) when OE = '1' else 'Z';
end struct;

    














