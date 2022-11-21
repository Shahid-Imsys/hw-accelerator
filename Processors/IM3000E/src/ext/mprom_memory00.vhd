library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use work.gp_pkg.all;


entity mprom_memory00 is

  generic (
    g_memory_type : memory_type_t := asic);

  port (
    address : in  std_logic_vector(11 downto 0);
    rom_do  : out std_logic_vector(79 downto 0);
    oe      : in  std_logic;
    clk_p   : in  std_logic;
    cs      : in  std_logic;
    -- test ports
    test1  : in  std_logic;
    rm  : in  std_logic_vector(3 downto 0);
    rme  : in  std_logic);

end entity mprom_memory00;

architecture rtl of mprom_memory00 is
  component SP180_4096X80BM1A is   
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
      A11  : in  std_logic;
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
      CK   : in  std_logic;
      CS   : in  std_logic;
      OE   : in  std_logic);
  end component;

  component SNPS_ROM_4Kx80_mprom00
    generic (
      preloadfilename : string);
    port (
      q   : out std_logic_vector(79 downto 0);
      adr : in  std_logic_vector(11 downto 0);
      me  : in  std_logic;
      clk : in  std_logic;
      ls  : in  std_logic;
      test1  : in  std_logic;
      rm  : in  std_logic_vector(3 downto 0);
      rme  : in  std_logic
      );
  end component;
  
begin  -- architecture rtl

  g_rom00_asic: if g_memory_type /= fpga generate
  i_mprom00_asic : SNPS_ROM_4Kx80_mprom00
    generic map (
      preloadfilename => "../../../../IP/Synopsys/Embed-it_Integrator/compout/views/SNPS_ROM_4Kx80_mprom00/SNPS_ROM_4Kx80_mprom00.hex"
      )
    port map (
      q   => rom_do,
      adr => address,
      me  => cs,
      clk => clk_p,
      ls  => '0',
      test1  => test1,
      rm => rm,
      rme  => rme
      );
  else generate
    
  mprom00_fpga : SP180_4096X80BM1A
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
      A11  => address(11),
      DO0  => rom_do(0),
      DO1  => rom_do(1),
      DO2  => rom_do(2),
      DO3  => rom_do(3),
      DO4  => rom_do(4),
      DO5  => rom_do(5),
      DO6  => rom_do(6),
      DO7  => rom_do(7),
      DO8  => rom_do(8),
      DO9  => rom_do(9),
      DO10 => rom_do(10),
      DO11 => rom_do(11),
      DO12 => rom_do(12),
      DO13 => rom_do(13),
      DO14 => rom_do(14),
      DO15 => rom_do(15),
      DO16 => rom_do(16),
      DO17 => rom_do(17),
      DO18 => rom_do(18),
      DO19 => rom_do(19),
      DO20 => rom_do(20),
      DO21 => rom_do(21),
      DO22 => rom_do(22),
      DO23 => rom_do(23),
      DO24 => rom_do(24),
      DO25 => rom_do(25),
      DO26 => rom_do(26),
      DO27 => rom_do(27),
      DO28 => rom_do(28),
      DO29 => rom_do(29),
      DO30 => rom_do(30),
      DO31 => rom_do(31),
      DO32 => rom_do(32),
      DO33 => rom_do(33),
      DO34 => rom_do(34),
      DO35 => rom_do(35),
      DO36 => rom_do(36),
      DO37 => rom_do(37),
      DO38 => rom_do(38),
      DO39 => rom_do(39),
      DO40 => rom_do(40),
      DO41 => rom_do(41),
      DO42 => rom_do(42),
      DO43 => rom_do(43),
      DO44 => rom_do(44),
      DO45 => rom_do(45),
      DO46 => rom_do(46),
      DO47 => rom_do(47),
      DO48 => rom_do(48),
      DO49 => rom_do(49),
      DO50 => rom_do(50),
      DO51 => rom_do(51),
      DO52 => rom_do(52),
      DO53 => rom_do(53),
      DO54 => rom_do(54),
      DO55 => rom_do(55),
      DO56 => rom_do(56),
      DO57 => rom_do(57),
      DO58 => rom_do(58),
      DO59 => rom_do(59),
      DO60 => rom_do(60),
      DO61 => rom_do(61),
      DO62 => rom_do(62),
      DO63 => rom_do(63),
      DO64 => rom_do(64),
      DO65 => rom_do(65),
      DO66 => rom_do(66),
      DO67 => rom_do(67),
      DO68 => rom_do(68),
      DO69 => rom_do(69),
      DO70 => rom_do(70),
      DO71 => rom_do(71),
      DO72 => rom_do(72),
      DO73 => rom_do(73),
      DO74 => rom_do(74),
      DO75 => rom_do(75),
      DO76 => rom_do(76),
      DO77 => rom_do(77),
      DO78 => rom_do(78),
      DO79 => rom_do(79),
      CK   => clk_p,
      CS   => cs,
      OE   => oe
      );
  end generate g_rom00_asic;



end architecture rtl;
