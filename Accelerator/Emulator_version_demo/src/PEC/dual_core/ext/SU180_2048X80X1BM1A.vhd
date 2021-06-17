library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.all;

entity SU180_256X128X1BM1A is
	port (
		A0		:	in	std_logic; 
		A1		:	in	std_logic; 
		A2		:	in	std_logic; 
		A3		:	in	std_logic; 
		A4		:	in	std_logic; 
		A5		:	in	std_logic; 
		A6		:	in	std_logic; 
		A7		:	in	std_logic; 
		--A8		:	in	std_logic; 
		--A9		:	in	std_logic; 
		--A10		:	in	std_logic;
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
		DO80	: out std_logic;
		DO81	: out std_logic;
		DO82	: out std_logic;
		DO83	: out std_logic;
		DO84	: out std_logic;
		DO85	: out std_logic;
		DO86	: out std_logic;
		DO87	: out std_logic;
		DO88	: out std_logic;
		DO89	: out std_logic;
		DO90	: out std_logic;
		DO91	: out std_logic;
		DO92	: out std_logic;
		DO93	: out std_logic;
		DO94	: out std_logic;
		DO95	: out std_logic;
		DO96	: out std_logic;
		DO97	: out std_logic;
		DO98	: out std_logic;
		DO99	: out std_logic;
		DO100	: out std_logic;
		DO101	: out std_logic;
		DO102	: out std_logic;
		DO103	: out std_logic;
		DO104	: out std_logic;
		DO105	: out std_logic;
		DO106	: out std_logic;
		DO107	: out std_logic;
		DO108	: out std_logic;
		DO109	: out std_logic;
		DO110	: out std_logic;
		DO111	: out std_logic;
		DO112	: out std_logic;
		DO113	: out std_logic;
		DO114	: out std_logic;
		DO115	: out std_logic;
		DO116	: out std_logic;
		DO117	: out std_logic;
		DO118	: out std_logic;
		DO119	: out std_logic;
		DO120	: out std_logic;
		DO121	: out std_logic;
		DO122	: out std_logic;
		DO123	: out std_logic;
		DO124	: out std_logic;
		DO125	: out std_logic;
		DO126	: out std_logic;
		DO127	: out std_logic;
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
		DI32	: in std_logic;
		DI33	: in std_logic;
		DI34	: in std_logic;
		DI35	: in std_logic;
		DI36	: in std_logic;
		DI37	: in std_logic;
		DI38	: in std_logic;
		DI39	: in std_logic;
		DI40	: in std_logic;
		DI41	: in std_logic;
		DI42	: in std_logic;
		DI43	: in std_logic;
		DI44	: in std_logic;
		DI45	: in std_logic;
		DI46	: in std_logic;
		DI47	: in std_logic;
		DI48	: in std_logic;
		DI49	: in std_logic;
		DI50	: in std_logic;
		DI51	: in std_logic;
		DI52	: in std_logic;
		DI53	: in std_logic;
		DI54	: in std_logic;
		DI55	: in std_logic;
		DI56	: in std_logic;
		DI57	: in std_logic;
		DI58	: in std_logic;
		DI59	: in std_logic;
		DI60	: in std_logic;
		DI61	: in std_logic;
		DI62	: in std_logic;
		DI63	: in std_logic;
		DI64	: in std_logic;
		DI65	: in std_logic;
		DI66	: in std_logic;
		DI67	: in std_logic;
		DI68	: in std_logic;
		DI69	: in std_logic;
		DI70	: in std_logic;
		DI71	: in std_logic;
		DI72	: in std_logic;
		DI73	: in std_logic;
		DI74	: in std_logic;
		DI75	: in std_logic;
		DI76	: in std_logic;
		DI77	: in std_logic;
		DI78	: in std_logic;
		DI79	: in std_logic;
		DI80	: in std_logic;
		DI81	: in std_logic;
		DI82	: in std_logic;
		DI83	: in std_logic;
		DI84	: in std_logic;
		DI85	: in std_logic;
		DI86	: in std_logic;
		DI87	: in std_logic;
		DI88	: in std_logic;
		DI89	: in std_logic;
		DI90	: in std_logic;
		DI91	: in std_logic;
		DI92	: in std_logic;
		DI93	: in std_logic;
		DI94	: in std_logic;
		DI95	: in std_logic;
		DI96	: in std_logic;
		DI97	: in std_logic;
		DI98	: in std_logic;
		DI99	: in std_logic;
		DI100	: in std_logic;
		DI101	: in std_logic;
		DI102	: in std_logic;
		DI103	: in std_logic;
		DI104	: in std_logic;
		DI105	: in std_logic;
		DI106	: in std_logic;
		DI107	: in std_logic;
		DI108	: in std_logic;
		DI109	: in std_logic;
		DI110	: in std_logic;
		DI111	: in std_logic;
		DI112	: in std_logic;
		DI113	: in std_logic;
		DI114	: in std_logic;
		DI115	: in std_logic;
		DI116	: in std_logic;
		DI117	: in std_logic;
		DI118	: in std_logic;
		DI119	: in std_logic;
		DI120	: in std_logic;
		DI121	: in std_logic;
		DI122	: in std_logic;
		DI123	: in std_logic;
		DI124	: in std_logic;
		DI125	: in std_logic;
		DI126	: in std_logic;
		DI127	: in std_logic;
		WEB	: in	std_logic;
		CK	: in	std_logic;
		CS	: in	std_logic;
		OE	: in	std_logic);
end SU180_256X128X1BM1A;

architecture struct of SU180_256X128X1BM1A is
	type ram_type is array (255 downto 0) of std_logic_vector(127 downto 0);
	type ram_type_b is array (255 downto 0) of bit_vector(127 downto 0);
		impure function init_ram_from_file (ram_file_name : in string) return ram_type is
		FILE ram_file : text is in ram_file_name;
		variable ram_file_line : line;
		variable RAM_B : ram_type_b;
		variable RAM :ram_type;
		begin
			--for i in rom_type'range loop
			for i in 0 to 255 loop
				readline(ram_file, ram_file_line);
				read(ram_file_line, RAM_B(i));
				RAM(i) := to_stdlogicvector(RAM_B(i));
			end loop;
		return RAM;
	    end function;
	    
	    
	signal RAM	: ram_type := init_ram_from_file("Test_fifo_and_send_req_BE_F.data");
	signal addr	: std_logic_vector(7 downto 0);
	signal di		: std_logic_vector(127 downto 0);
	signal do		: std_logic_vector(127 downto 0);
	attribute ram_style					: string;
	attribute ram_style of RAM	: signal is "block";

begin
	--addr(10)	<= A10; 
	--addr(9)		<= A9; 
	--addr(8)		<= A8; 
	addr(7)		<= A7; 
	addr(6)		<= A6; 
	addr(5)		<= A5; 
	addr(4)		<= A4; 
	addr(3)		<= A3; 
	addr(2)		<= A2; 
	addr(1)		<= A1; 
	addr(0)		<= A0; 

	 di(80)       <= DI80;    --CJ ADDED
     di(81)       <= DI81;    --CJ ADDED
     di(82)       <= DI82;    --CJ ADDED
     di(83)       <= DI83;    --CJ ADDED
     di(84)       <= DI84;    --CJ ADDED
     di(85)       <= DI85;    --CJ ADDED
     di(86)       <= DI86;    --CJ ADDED
     di(87)       <= DI87;    --CJ ADDED
     di(88)       <= DI88;    --CJ ADDED
     di(89)       <= DI89;    --CJ ADDED
     di(90)       <= DI90;    --CJ ADDED
     di(91)       <= DI91;    --CJ ADDED
     di(92)       <= DI92;    --CJ ADDED
     di(93)       <= DI93;    --CJ ADDED
     di(94)       <= DI94;    --CJ ADDED
     di(95)       <= DI95;    --CJ ADDED
     di(96)       <= DI96;    --CJ ADDED
     di(97)       <= DI97;    --CJ ADDED
     di(98)       <= DI98;    --CJ ADDED
     di(99)       <= DI99;    --CJ ADDED
     di(100)       <= DI100;  --CJ ADDED
     di(101)       <= DI101;  --CJ ADDED
     di(102)       <= DI102;  --CJ ADDED
     di(103)       <= DI103;  --CJ ADDED
     di(104)       <= DI104;  --CJ ADDED
     di(105)       <= DI105;  --CJ ADDED
     di(106)       <= DI106;  --CJ ADDED
     di(107)       <= DI107;  --CJ ADDED
     di(108)       <= DI108;  --CJ ADDED
     di(109)       <= DI109;  --CJ ADDED
     di(110)       <= DI110;  --CJ ADDED
     di(111)       <= DI111;  --CJ ADDED
     di(112)       <= DI112;  --CJ ADDED
     di(113)       <= DI113;  --CJ ADDED
     di(114)       <= DI114;  --CJ ADDED
     di(115)       <= DI115;  --CJ ADDED
     di(116)       <= DI116;  --CJ ADDED
     di(117)       <= DI117;  --CJ ADDED
     di(118)       <= DI118;  --CJ ADDED
     di(119)       <= DI119;  --CJ ADDED
     di(120)       <= DI120;  --CJ ADDED
     di(121)       <= DI121;  --CJ ADDED
     di(122)       <= DI122;  --CJ ADDED
     di(123)       <= DI123;  --CJ ADDED
     di(124)       <= DI124;  --CJ ADDED
     di(125)       <= DI125;  --CJ ADDED
     di(126)       <= DI126;  --CJ ADDED
     di(127)       <= DI127;  --CJ ADDED
	di(79)	<= DI79; 
	di(78)	<= DI78; 
	di(77)	<= DI77; 
	di(76)	<= DI76; 
	di(75)	<= DI75; 
	di(74)	<= DI74; 
	di(73)	<= DI73; 
	di(72)	<= DI72; 
	di(71)	<= DI71; 
	di(70)	<= DI70; 
	di(69)	<= DI69; 
	di(68)	<= DI68; 
	di(67)	<= DI67; 
	di(66)	<= DI66; 
	di(65)	<= DI65; 
	di(64)	<= DI64; 
	di(63)	<= DI63; 
	di(62)	<= DI62; 
	di(61)	<= DI61; 
	di(60)	<= DI60; 
	di(59)	<= DI59; 
	di(58)	<= DI58; 
	di(57)	<= DI57; 
	di(56)	<= DI56; 
	di(55)	<= DI55; 
	di(54)	<= DI54; 
	di(53)	<= DI53; 
	di(52)	<= DI52; 
	di(51)	<= DI51; 
	di(50)	<= DI50; 
	di(49)	<= DI49; 
	di(48)	<= DI48; 
	di(47)	<= DI47; 
	di(46)	<= DI46; 
	di(45)	<= DI45; 
	di(44)	<= DI44; 
	di(43)	<= DI43; 
	di(42)	<= DI42; 
	di(41)	<= DI41; 
	di(40)	<= DI40; 
	di(39)	<= DI39; 
	di(38)	<= DI38; 
	di(37)	<= DI37; 
	di(36)	<= DI36; 
	di(35)	<= DI35; 
	di(34)	<= DI34; 
	di(33)	<= DI33; 
	di(32)	<= DI32; 
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
			if CS = '1' then
				if WEB = '0' then
					RAM(conv_integer(addr)) <= di;
				end if;
				do <= RAM(conv_integer(addr));
			end if;
		end if;
	end process;
    DO80        <= do(80)  when OE = '1' else 'Z';
    DO81        <= do(81)  when OE = '1' else 'Z';
    DO82        <= do(82)  when OE = '1' else 'Z';
    DO83        <= do(83)  when OE = '1' else 'Z';
    DO84        <= do(84)  when OE = '1' else 'Z';
    DO85        <= do(85)  when OE = '1' else 'Z';
    DO86        <= do(86)  when OE = '1' else 'Z';
    DO87        <= do(87)  when OE = '1' else 'Z';
    DO88        <= do(88)  when OE = '1' else 'Z';
    DO89        <= do(89)  when OE = '1' else 'Z';
    DO90        <= do(90)  when OE = '1' else 'Z';
    DO91        <= do(91)  when OE = '1' else 'Z';
    DO92        <= do(92)  when OE = '1' else 'Z';
    DO93        <= do(93)  when OE = '1' else 'Z';
    DO94        <= do(94)  when OE = '1' else 'Z';
    DO95        <= do(95)  when OE = '1' else 'Z';
    DO96        <= do(96)  when OE = '1' else 'Z';
    DO97        <= do(97)  when OE = '1' else 'Z';
    DO98        <= do(98)  when OE = '1' else 'Z';
    DO99        <= do(99)  when OE = '1' else 'Z';
    DO100       <= do(100) when OE = '1' else 'Z';
    DO101       <= do(101) when OE = '1' else 'Z';
    DO102       <= do(102) when OE = '1' else 'Z';
    DO103       <= do(103) when OE = '1' else 'Z';
    DO104       <= do(104) when OE = '1' else 'Z';
    DO105       <= do(105) when OE = '1' else 'Z';
    DO106       <= do(106) when OE = '1' else 'Z';
    DO107       <= do(107) when OE = '1' else 'Z';
    DO108       <= do(108) when OE = '1' else 'Z';
    DO109       <= do(109) when OE = '1' else 'Z';
    DO110       <= do(110) when OE = '1' else 'Z';
    DO111       <= do(111) when OE = '1' else 'Z';
    DO112       <= do(112) when OE = '1' else 'Z';
    DO113       <= do(113) when OE = '1' else 'Z';
    DO114       <= do(114) when OE = '1' else 'Z';
    DO115       <= do(115) when OE = '1' else 'Z';
    DO116       <= do(116) when OE = '1' else 'Z';
    DO117       <= do(117) when OE = '1' else 'Z';
    DO118       <= do(118) when OE = '1' else 'Z';
    DO119       <= do(119) when OE = '1' else 'Z';
    DO120       <= do(120) when OE = '1' else 'Z';
    DO121       <= do(121) when OE = '1' else 'Z';
    DO122       <= do(122) when OE = '1' else 'Z';
    DO123       <= do(123) when OE = '1' else 'Z';
    DO124       <= do(124) when OE = '1' else 'Z';
    DO125       <= do(125) when OE = '1' else 'Z';
    DO126       <= do(126) when OE = '1' else 'Z';
    DO127       <= do(127) when OE = '1' else 'Z';

	DO79	<= do(79) when OE = '1' else 'Z';
	DO78	<= do(78) when OE = '1' else 'Z';
	DO77	<= do(77) when OE = '1' else 'Z';
	DO76	<= do(76) when OE = '1' else 'Z';
	DO75	<= do(75) when OE = '1' else 'Z';
	DO74	<= do(74) when OE = '1' else 'Z';
	DO73	<= do(73) when OE = '1' else 'Z';
	DO72	<= do(72) when OE = '1' else 'Z';
	DO71	<= do(71) when OE = '1' else 'Z';
	DO70	<= do(70) when OE = '1' else 'Z';
	DO69	<= do(69) when OE = '1' else 'Z';
	DO68	<= do(68) when OE = '1' else 'Z';
	DO67	<= do(67) when OE = '1' else 'Z';
	DO66	<= do(66) when OE = '1' else 'Z';
	DO65	<= do(65) when OE = '1' else 'Z';
	DO64	<= do(64) when OE = '1' else 'Z';
	DO63	<= do(63) when OE = '1' else 'Z';
	DO62	<= do(62) when OE = '1' else 'Z';
	DO61	<= do(61) when OE = '1' else 'Z';
	DO60	<= do(60) when OE = '1' else 'Z';
	DO59	<= do(59) when OE = '1' else 'Z';
	DO58	<= do(58) when OE = '1' else 'Z';
	DO57	<= do(57) when OE = '1' else 'Z';
	DO56	<= do(56) when OE = '1' else 'Z';
	DO55	<= do(55) when OE = '1' else 'Z';
	DO54	<= do(54) when OE = '1' else 'Z';
	DO53	<= do(53) when OE = '1' else 'Z';
	DO52	<= do(52) when OE = '1' else 'Z';
	DO51	<= do(51) when OE = '1' else 'Z';
	DO50	<= do(50) when OE = '1' else 'Z';
	DO49	<= do(49) when OE = '1' else 'Z';
	DO48	<= do(48) when OE = '1' else 'Z';
	DO47	<= do(47) when OE = '1' else 'Z';
	DO46	<= do(46) when OE = '1' else 'Z';
	DO45	<= do(45) when OE = '1' else 'Z';
	DO44	<= do(44) when OE = '1' else 'Z';
	DO43	<= do(43) when OE = '1' else 'Z';
	DO42	<= do(42) when OE = '1' else 'Z';
	DO41	<= do(41) when OE = '1' else 'Z';
	DO40	<= do(40) when OE = '1' else 'Z';
	DO39	<= do(39) when OE = '1' else 'Z';
	DO38	<= do(38) when OE = '1' else 'Z';
	DO37	<= do(37) when OE = '1' else 'Z';
	DO36	<= do(36) when OE = '1' else 'Z';
	DO35	<= do(35) when OE = '1' else 'Z';
	DO34	<= do(34) when OE = '1' else 'Z';
	DO33	<= do(33) when OE = '1' else 'Z';
	DO32	<= do(32) when OE = '1' else 'Z';
	DO31	<= do(31) when OE = '1' else 'Z';
	DO30	<= do(30) when OE = '1' else 'Z';
	DO29	<= do(29) when OE = '1' else 'Z';
	DO28	<= do(28) when OE = '1' else 'Z';
	DO27	<= do(27) when OE = '1' else 'Z';
	DO26	<= do(26) when OE = '1' else 'Z';
	DO25	<= do(25) when OE = '1' else 'Z';
	DO24	<= do(24) when OE = '1' else 'Z';
	DO23	<= do(23) when OE = '1' else 'Z';
	DO22	<= do(22) when OE = '1' else 'Z';
	DO21	<= do(21) when OE = '1' else 'Z';
	DO20	<= do(20) when OE = '1' else 'Z';
	DO19	<= do(19) when OE = '1' else 'Z';
	DO18	<= do(18) when OE = '1' else 'Z';
	DO17	<= do(17) when OE = '1' else 'Z';
	DO16	<= do(16) when OE = '1' else 'Z';
	DO15	<= do(15) when OE = '1' else 'Z';
	DO14	<= do(14) when OE = '1' else 'Z';
	DO13	<= do(13) when OE = '1' else 'Z';
	DO12	<= do(12) when OE = '1' else 'Z';
	DO11	<= do(11) when OE = '1' else 'Z';
	DO10	<= do(10) when OE = '1' else 'Z';
	DO9		<= do(9) when OE = '1' else 'Z';
	DO8		<= do(8) when OE = '1' else 'Z';
	DO7		<= do(7) when OE = '1' else 'Z';
	DO6		<= do(6) when OE = '1' else 'Z';
	DO5		<= do(5) when OE = '1' else 'Z';
	DO4		<= do(4) when OE = '1' else 'Z';
	DO3		<= do(3) when OE = '1' else 'Z';
	DO2		<= do(2) when OE = '1' else 'Z';
	DO1		<= do(1) when OE = '1' else 'Z';
	DO0		<= do(0) when OE = '1' else 'Z';
end struct;

    














