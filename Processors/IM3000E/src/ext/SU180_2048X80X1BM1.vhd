library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.all;

entity SU180_2048X80X1BM1 is
  generic (
    g_file_name : string := "mpram0.data");
  port (
    A0   : in  std_logic;
    A1   : in  std_logic;
    A2   : in  std_logic;
    A3   : in  std_logic;
    A4   : in  std_logic;
    A5   : in  std_logic;
    A6   : in  std_logic;
    A7   : in  std_logic;
    A8   : in  std_logic;
    A9   : in  std_logic;
    A10  : in  std_logic;
    DO0  : out std_logic;
    DO1  : out std_logic;
    DO2  : out std_logic;
    DO3  : out std_logic;
    DO4  : out std_logic;
    DO5  : out std_logic;
    DO6  : out std_logic;
    DO7  : out std_logic;
    DO8  : out std_logic;
    DO9  : out std_logic;
    DO10 : out std_logic;
    DO11 : out std_logic;
    DO12 : out std_logic;
    DO13 : out std_logic;
    DO14 : out std_logic;
    DO15 : out std_logic;
    DO16 : out std_logic;
    DO17 : out std_logic;
    DO18 : out std_logic;
    DO19 : out std_logic;
    DO20 : out std_logic;
    DO21 : out std_logic;
    DO22 : out std_logic;
    DO23 : out std_logic;
    DO24 : out std_logic;
    DO25 : out std_logic;
    DO26 : out std_logic;
    DO27 : out std_logic;
    DO28 : out std_logic;
    DO29 : out std_logic;
    DO30 : out std_logic;
    DO31 : out std_logic;
    DO32 : out std_logic;
    DO33 : out std_logic;
    DO34 : out std_logic;
    DO35 : out std_logic;
    DO36 : out std_logic;
    DO37 : out std_logic;
    DO38 : out std_logic;
    DO39 : out std_logic;
    DO40 : out std_logic;
    DO41 : out std_logic;
    DO42 : out std_logic;
    DO43 : out std_logic;
    DO44 : out std_logic;
    DO45 : out std_logic;
    DO46 : out std_logic;
    DO47 : out std_logic;
    DO48 : out std_logic;
    DO49 : out std_logic;
    DO50 : out std_logic;
    DO51 : out std_logic;
    DO52 : out std_logic;
    DO53 : out std_logic;
    DO54 : out std_logic;
    DO55 : out std_logic;
    DO56 : out std_logic;
    DO57 : out std_logic;
    DO58 : out std_logic;
    DO59 : out std_logic;
    DO60 : out std_logic;
    DO61 : out std_logic;
    DO62 : out std_logic;
    DO63 : out std_logic;
    DO64 : out std_logic;
    DO65 : out std_logic;
    DO66 : out std_logic;
    DO67 : out std_logic;
    DO68 : out std_logic;
    DO69 : out std_logic;
    DO70 : out std_logic;
    DO71 : out std_logic;
    DO72 : out std_logic;
    DO73 : out std_logic;
    DO74 : out std_logic;
    DO75 : out std_logic;
    DO76 : out std_logic;
    DO77 : out std_logic;
    DO78 : out std_logic;
    DO79 : out std_logic;
    DI0  : in  std_logic;
    DI1  : in  std_logic;
    DI2  : in  std_logic;
    DI3  : in  std_logic;
    DI4  : in  std_logic;
    DI5  : in  std_logic;
    DI6  : in  std_logic;
    DI7  : in  std_logic;
    DI8  : in  std_logic;
    DI9  : in  std_logic;
    DI10 : in  std_logic;
    DI11 : in  std_logic;
    DI12 : in  std_logic;
    DI13 : in  std_logic;
    DI14 : in  std_logic;
    DI15 : in  std_logic;
    DI16 : in  std_logic;
    DI17 : in  std_logic;
    DI18 : in  std_logic;
    DI19 : in  std_logic;
    DI20 : in  std_logic;
    DI21 : in  std_logic;
    DI22 : in  std_logic;
    DI23 : in  std_logic;
    DI24 : in  std_logic;
    DI25 : in  std_logic;
    DI26 : in  std_logic;
    DI27 : in  std_logic;
    DI28 : in  std_logic;
    DI29 : in  std_logic;
    DI30 : in  std_logic;
    DI31 : in  std_logic;
    DI32 : in  std_logic;
    DI33 : in  std_logic;
    DI34 : in  std_logic;
    DI35 : in  std_logic;
    DI36 : in  std_logic;
    DI37 : in  std_logic;
    DI38 : in  std_logic;
    DI39 : in  std_logic;
    DI40 : in  std_logic;
    DI41 : in  std_logic;
    DI42 : in  std_logic;
    DI43 : in  std_logic;
    DI44 : in  std_logic;
    DI45 : in  std_logic;
    DI46 : in  std_logic;
    DI47 : in  std_logic;
    DI48 : in  std_logic;
    DI49 : in  std_logic;
    DI50 : in  std_logic;
    DI51 : in  std_logic;
    DI52 : in  std_logic;
    DI53 : in  std_logic;
    DI54 : in  std_logic;
    DI55 : in  std_logic;
    DI56 : in  std_logic;
    DI57 : in  std_logic;
    DI58 : in  std_logic;
    DI59 : in  std_logic;
    DI60 : in  std_logic;
    DI61 : in  std_logic;
    DI62 : in  std_logic;
    DI63 : in  std_logic;
    DI64 : in  std_logic;
    DI65 : in  std_logic;
    DI66 : in  std_logic;
    DI67 : in  std_logic;
    DI68 : in  std_logic;
    DI69 : in  std_logic;
    DI70 : in  std_logic;
    DI71 : in  std_logic;
    DI72 : in  std_logic;
    DI73 : in  std_logic;
    DI74 : in  std_logic;
    DI75 : in  std_logic;
    DI76 : in  std_logic;
    DI77 : in  std_logic;
    DI78 : in  std_logic;
    DI79 : in  std_logic;
    WEB  : in  std_logic;
    CK   : in  std_logic;
    CS   : in  std_logic;
    OE   : in  std_logic);
end SU180_2048X80X1BM1;

architecture struct of SU180_2048X80X1BM1 is


  type ram_type is array (2047 downto 0) of std_logic_vector(79 downto 0);

  procedure init_ram_from_file (ram_file_name : in string; signal content : inout ram_type )is
    file ram_file          : text;
    variable status : file_open_status := status_error;
    variable ram_file_line : line;
    variable row : std_logic_vector(79 downto 0);
    variable bits : bit;
    variable l : line;
    variable ram           : ram_type := content;
    variable tst : integer;
  begin
    file_open(status, ram_file, ram_file_name, read_mode);
    if status /= open_ok then
      wait for 2 ns;
      write(l, string'("[SU80_2048X80X1BM1] file ") & ram_file_name & " not open ok");
      writeline(output, l);
      return;
    end if;
                              
    for i in 0 to 2047 loop
      readline(ram_file, ram_file_line);
      for i in row'range loop
        read(ram_file_line, bits);
        if bits = '1' then
          row(i) := '1';
        else
          row(i) := '0';
        end if;
      end loop;  -- i
      --read(ram_file_line, row);
      ram(i) := row;
      tst := i;
    end loop;

    file_close(ram_file);
    
    content <= ram;
  end procedure;

  signal RAM                 : ram_type;
  signal addr                : std_logic_vector(10 downto 0);
  signal di                  : std_logic_vector(79 downto 0);
  signal do                  : std_logic_vector(79 downto 0);
  attribute ram_style        : string;
  attribute ram_style of RAM : signal is "block";

begin
  addr(10) <= A10;
  addr(9)  <= A9;
  addr(8)  <= A8;
  addr(7)  <= A7;
  addr(6)  <= A6;
  addr(5)  <= A5;
  addr(4)  <= A4;
  addr(3)  <= A3;
  addr(2)  <= A2;
  addr(1)  <= A1;
  addr(0)  <= A0;

  di(79) <= DI79;
  di(78) <= DI78;
  di(77) <= DI77;
  di(76) <= DI76;
  di(75) <= DI75;
  di(74) <= DI74;
  di(73) <= DI73;
  di(72) <= DI72;
  di(71) <= DI71;
  di(70) <= DI70;
  di(69) <= DI69;
  di(68) <= DI68;
  di(67) <= DI67;
  di(66) <= DI66;
  di(65) <= DI65;
  di(64) <= DI64;
  di(63) <= DI63;
  di(62) <= DI62;
  di(61) <= DI61;
  di(60) <= DI60;
  di(59) <= DI59;
  di(58) <= DI58;
  di(57) <= DI57;
  di(56) <= DI56;
  di(55) <= DI55;
  di(54) <= DI54;
  di(53) <= DI53;
  di(52) <= DI52;
  di(51) <= DI51;
  di(50) <= DI50;
  di(49) <= DI49;
  di(48) <= DI48;
  di(47) <= DI47;
  di(46) <= DI46;
  di(45) <= DI45;
  di(44) <= DI44;
  di(43) <= DI43;
  di(42) <= DI42;
  di(41) <= DI41;
  di(40) <= DI40;
  di(39) <= DI39;
  di(38) <= DI38;
  di(37) <= DI37;
  di(36) <= DI36;
  di(35) <= DI35;
  di(34) <= DI34;
  di(33) <= DI33;
  di(32) <= DI32;
  di(31) <= DI31;
  di(30) <= DI30;
  di(29) <= DI29;
  di(28) <= DI28;
  di(27) <= DI27;
  di(26) <= DI26;
  di(25) <= DI25;
  di(24) <= DI24;
  di(23) <= DI23;
  di(22) <= DI22;
  di(21) <= DI21;
  di(20) <= DI20;
  di(19) <= DI19;
  di(18) <= DI18;
  di(17) <= DI17;
  di(16) <= DI16;
  di(15) <= DI15;
  di(14) <= DI14;
  di(13) <= DI13;
  di(12) <= DI12;
  di(11) <= DI11;
  di(10) <= DI10;
  di(9)  <= DI9;
  di(8)  <= DI8;
  di(7)  <= DI7;
  di(6)  <= DI6;
  di(5)  <= DI5;
  di(4)  <= DI4;
  di(3)  <= DI3;
  di(2)  <= DI2;
  di(1)  <= DI1;
  di(0)  <= DI0;

  process
  begin
    wait for 10 ps;
    init_ram_from_file(g_file_name, ram);

    loop  
      wait on ck until ck = '1'; -- rising_edge(CK) then
      if CS = '1' then
        if WEB = '0' then
          RAM(conv_integer(addr)) <= di;
        end if;
        do <= RAM(conv_integer(addr));
      end if;
    end loop;
  end process;

  DO79 <= do(79) when OE = '1' else 'Z';
  DO78 <= do(78) when OE = '1' else 'Z';
  DO77 <= do(77) when OE = '1' else 'Z';
  DO76 <= do(76) when OE = '1' else 'Z';
  DO75 <= do(75) when OE = '1' else 'Z';
  DO74 <= do(74) when OE = '1' else 'Z';
  DO73 <= do(73) when OE = '1' else 'Z';
  DO72 <= do(72) when OE = '1' else 'Z';
  DO71 <= do(71) when OE = '1' else 'Z';
  DO70 <= do(70) when OE = '1' else 'Z';
  DO69 <= do(69) when OE = '1' else 'Z';
  DO68 <= do(68) when OE = '1' else 'Z';
  DO67 <= do(67) when OE = '1' else 'Z';
  DO66 <= do(66) when OE = '1' else 'Z';
  DO65 <= do(65) when OE = '1' else 'Z';
  DO64 <= do(64) when OE = '1' else 'Z';
  DO63 <= do(63) when OE = '1' else 'Z';
  DO62 <= do(62) when OE = '1' else 'Z';
  DO61 <= do(61) when OE = '1' else 'Z';
  DO60 <= do(60) when OE = '1' else 'Z';
  DO59 <= do(59) when OE = '1' else 'Z';
  DO58 <= do(58) when OE = '1' else 'Z';
  DO57 <= do(57) when OE = '1' else 'Z';
  DO56 <= do(56) when OE = '1' else 'Z';
  DO55 <= do(55) when OE = '1' else 'Z';
  DO54 <= do(54) when OE = '1' else 'Z';
  DO53 <= do(53) when OE = '1' else 'Z';
  DO52 <= do(52) when OE = '1' else 'Z';
  DO51 <= do(51) when OE = '1' else 'Z';
  DO50 <= do(50) when OE = '1' else 'Z';
  DO49 <= do(49) when OE = '1' else 'Z';
  DO48 <= do(48) when OE = '1' else 'Z';
  DO47 <= do(47) when OE = '1' else 'Z';
  DO46 <= do(46) when OE = '1' else 'Z';
  DO45 <= do(45) when OE = '1' else 'Z';
  DO44 <= do(44) when OE = '1' else 'Z';
  DO43 <= do(43) when OE = '1' else 'Z';
  DO42 <= do(42) when OE = '1' else 'Z';
  DO41 <= do(41) when OE = '1' else 'Z';
  DO40 <= do(40) when OE = '1' else 'Z';
  DO39 <= do(39) when OE = '1' else 'Z';
  DO38 <= do(38) when OE = '1' else 'Z';
  DO37 <= do(37) when OE = '1' else 'Z';
  DO36 <= do(36) when OE = '1' else 'Z';
  DO35 <= do(35) when OE = '1' else 'Z';
  DO34 <= do(34) when OE = '1' else 'Z';
  DO33 <= do(33) when OE = '1' else 'Z';
  DO32 <= do(32) when OE = '1' else 'Z';
  DO31 <= do(31) when OE = '1' else 'Z';
  DO30 <= do(30) when OE = '1' else 'Z';
  DO29 <= do(29) when OE = '1' else 'Z';
  DO28 <= do(28) when OE = '1' else 'Z';
  DO27 <= do(27) when OE = '1' else 'Z';
  DO26 <= do(26) when OE = '1' else 'Z';
  DO25 <= do(25) when OE = '1' else 'Z';
  DO24 <= do(24) when OE = '1' else 'Z';
  DO23 <= do(23) when OE = '1' else 'Z';
  DO22 <= do(22) when OE = '1' else 'Z';
  DO21 <= do(21) when OE = '1' else 'Z';
  DO20 <= do(20) when OE = '1' else 'Z';
  DO19 <= do(19) when OE = '1' else 'Z';
  DO18 <= do(18) when OE = '1' else 'Z';
  DO17 <= do(17) when OE = '1' else 'Z';
  DO16 <= do(16) when OE = '1' else 'Z';
  DO15 <= do(15) when OE = '1' else 'Z';
  DO14 <= do(14) when OE = '1' else 'Z';
  DO13 <= do(13) when OE = '1' else 'Z';
  DO12 <= do(12) when OE = '1' else 'Z';
  DO11 <= do(11) when OE = '1' else 'Z';
  DO10 <= do(10) when OE = '1' else 'Z';
  DO9  <= do(9)  when OE = '1' else 'Z';
  DO8  <= do(8)  when OE = '1' else 'Z';
  DO7  <= do(7)  when OE = '1' else 'Z';
  DO6  <= do(6)  when OE = '1' else 'Z';
  DO5  <= do(5)  when OE = '1' else 'Z';
  DO4  <= do(4)  when OE = '1' else 'Z';
  DO3  <= do(3)  when OE = '1' else 'Z';
  DO2  <= do(2)  when OE = '1' else 'Z';
  DO1  <= do(1)  when OE = '1' else 'Z';
  DO0  <= do(0)  when OE = '1' else 'Z';
end struct;
















