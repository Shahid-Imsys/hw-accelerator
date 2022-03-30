library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use work.gp_pkg.all;

entity mpram_memory is

  generic (
    g_file_name   : string        := "mpram0.data";
    g_memory_type : memory_type_t := referens);

  port (
    address : in  std_logic_vector(10 downto 0);
    ram_di  : in  std_logic_vector(79 downto 0);
    ram_do  : out std_logic_vector(79 downto 0);
    we_n    : in  std_logic;
    clk     : in  std_logic;
    cs      : in  std_logic);

end entity mpram_memory;

architecture str of mpram_memory is
  component SU180_2048X80X1BM1
    generic (
      g_file_name : string := "mpram0.data");
    port(
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
      OE   : in  std_logic
      );
  end component;

  component SNPS_SP_HD_2Kx80
    port (
      Q        : out std_logic_vector(79 downto 0);
      ADR      : in  std_logic_vector(10 downto 0);
      D        : in  std_logic_vector(79 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic
      );
  end component;

  component load_mpram is
    generic (
      initFile : string);
  end component load_mpram;

  signal ram_do_asic : std_logic_vector(79 downto 0);

begin  -- architecture str


  -- Use memories from ASIC implementation
  g_asic_memory : if g_memory_type = asic generate

    i_load_mpram : load_mpram
      generic map (
        initFile => g_file_name);

    mpram_asic : SNPS_SP_HD_2Kx80
      port map (
        Q        => ram_do,
        ADR      => address,
        D        => ram_di,
        WE       => not we_n,
        ME       => cs,
        CLK      => clk,
        TEST1    => '0',
        TEST_RNM => '0',
        RME      => '0',
        RM       => (others => '0'),
        WA       => (others => '0'),
        WPULSE   => (others => '0'),
        LS       => '0',
        BC0      => '0',
        BC1      => '0',
        BC2      => '0'
        );

    -- Use referens memory design for FPGA.
  else generate

    mpram_org : SU180_2048X80X1BM1
      generic map (
        g_file_name => g_file_name
        )
      port map (
        A0   => address(0),
        A1   => address(1),
        A2   => address(2),
        A3   => address(3),
        A4   => address(4),
        A5   => address(5),
        A6   => address(6),
        A7   => address(7),
        A8   => address(8),
        A9   => address(9),
        A10  => address(10),
        DO0  => ram_do(0),
        DO1  => ram_do(1),
        DO2  => ram_do(2),
        DO3  => ram_do(3),
        DO4  => ram_do(4),
        DO5  => ram_do(5),
        DO6  => ram_do(6),
        DO7  => ram_do(7),
        DO8  => ram_do(8),
        DO9  => ram_do(9),
        DO10 => ram_do(10),
        DO11 => ram_do(11),
        DO12 => ram_do(12),
        DO13 => ram_do(13),
        DO14 => ram_do(14),
        DO15 => ram_do(15),
        DO16 => ram_do(16),
        DO17 => ram_do(17),
        DO18 => ram_do(18),
        DO19 => ram_do(19),
        DO20 => ram_do(20),
        DO21 => ram_do(21),
        DO22 => ram_do(22),
        DO23 => ram_do(23),
        DO24 => ram_do(24),
        DO25 => ram_do(25),
        DO26 => ram_do(26),
        DO27 => ram_do(27),
        DO28 => ram_do(28),
        DO29 => ram_do(29),
        DO30 => ram_do(30),
        DO31 => ram_do(31),
        DO32 => ram_do(32),
        DO33 => ram_do(33),
        DO34 => ram_do(34),
        DO35 => ram_do(35),
        DO36 => ram_do(36),
        DO37 => ram_do(37),
        DO38 => ram_do(38),
        DO39 => ram_do(39),
        DO40 => ram_do(40),
        DO41 => ram_do(41),
        DO42 => ram_do(42),
        DO43 => ram_do(43),
        DO44 => ram_do(44),
        DO45 => ram_do(45),
        DO46 => ram_do(46),
        DO47 => ram_do(47),
        DO48 => ram_do(48),
        DO49 => ram_do(49),
        DO50 => ram_do(50),
        DO51 => ram_do(51),
        DO52 => ram_do(52),
        DO53 => ram_do(53),
        DO54 => ram_do(54),
        DO55 => ram_do(55),
        DO56 => ram_do(56),
        DO57 => ram_do(57),
        DO58 => ram_do(58),
        DO59 => ram_do(59),
        DO60 => ram_do(60),
        DO61 => ram_do(61),
        DO62 => ram_do(62),
        DO63 => ram_do(63),
        DO64 => ram_do(64),
        DO65 => ram_do(65),
        DO66 => ram_do(66),
        DO67 => ram_do(67),
        DO68 => ram_do(68),
        DO69 => ram_do(69),
        DO70 => ram_do(70),
        DO71 => ram_do(71),
        DO72 => ram_do(72),
        DO73 => ram_do(73),
        DO74 => ram_do(74),
        DO75 => ram_do(75),
        DO76 => ram_do(76),
        DO77 => ram_do(77),
        DO78 => ram_do(78),
        DO79 => ram_do(79),
        DI0  => ram_di(0),
        DI1  => ram_di(1),
        DI2  => ram_di(2),
        DI3  => ram_di(3),
        DI4  => ram_di(4),
        DI5  => ram_di(5),
        DI6  => ram_di(6),
        DI7  => ram_di(7),
        DI8  => ram_di(8),
        DI9  => ram_di(9),
        DI10 => ram_di(10),
        DI11 => ram_di(11),
        DI12 => ram_di(12),
        DI13 => ram_di(13),
        DI14 => ram_di(14),
        DI15 => ram_di(15),
        DI16 => ram_di(16),
        DI17 => ram_di(17),
        DI18 => ram_di(18),
        DI19 => ram_di(19),
        DI20 => ram_di(20),
        DI21 => ram_di(21),
        DI22 => ram_di(22),
        DI23 => ram_di(23),
        DI24 => ram_di(24),
        DI25 => ram_di(25),
        DI26 => ram_di(26),
        DI27 => ram_di(27),
        DI28 => ram_di(28),
        DI29 => ram_di(29),
        DI30 => ram_di(30),
        DI31 => ram_di(31),
        DI32 => ram_di(32),
        DI33 => ram_di(33),
        DI34 => ram_di(34),
        DI35 => ram_di(35),
        DI36 => ram_di(36),
        DI37 => ram_di(37),
        DI38 => ram_di(38),
        DI39 => ram_di(39),
        DI40 => ram_di(40),
        DI41 => ram_di(41),
        DI42 => ram_di(42),
        DI43 => ram_di(43),
        DI44 => ram_di(44),
        DI45 => ram_di(45),
        DI46 => ram_di(46),
        DI47 => ram_di(47),
        DI48 => ram_di(48),
        DI49 => ram_di(49),
        DI50 => ram_di(50),
        DI51 => ram_di(51),
        DI52 => ram_di(52),
        DI53 => ram_di(53),
        DI54 => ram_di(54),
        DI55 => ram_di(55),
        DI56 => ram_di(56),
        DI57 => ram_di(57),
        DI58 => ram_di(58),
        DI59 => ram_di(59),
        DI60 => ram_di(60),
        DI61 => ram_di(61),
        DI62 => ram_di(62),
        DI63 => ram_di(63),
        DI64 => ram_di(64),
        DI65 => ram_di(65),
        DI66 => ram_di(66),
        DI67 => ram_di(67),
        DI68 => ram_di(68),
        DI69 => ram_di(69),
        DI70 => ram_di(70),
        DI71 => ram_di(71),
        DI72 => ram_di(72),
        DI73 => ram_di(73),
        DI74 => ram_di(74),
        DI75 => ram_di(75),
        DI76 => ram_di(76),
        DI77 => ram_di(77),
        DI78 => ram_di(78),
        DI79 => ram_di(79),
        WEB  => we_n,
        CK   => clk,
        CS   => cs,
        OE   => '1');

  end generate g_asic_memory;
end architecture str;
