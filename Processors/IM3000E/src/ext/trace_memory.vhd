library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gp_pkg.all;

entity trace_memory is
  
  generic (
    g_memory_type : memory_type_t := asic);
  port (
    address : in std_logic_vector(7 downto 0);
    ram_di  : in  std_logic_vector(31 downto 0);
    ram_do  : out std_logic_vector(31 downto 0);
    we_n    : in  std_logic;
    clk     : in  std_logic;
    cs_n    : in  std_logic);

end entity trace_memory;

architecture rtl of trace_memory is
component fpga_SY180_256X32X1CM4
  port(
      A0   : in  std_logic;
      A1   : in  std_logic;
      A2   : in  std_logic;
      A3   : in  std_logic;
      A4   : in  std_logic;
      A5   : in  std_logic;
      A6   : in  std_logic;
      A7   : in  std_logic;
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
      WEB  : in  std_logic;
      CK   : in  std_logic;
      CSB  : in  std_logic
      );
   end component;

  component SNPS_SP_HD_256x32
    port (
      Q        : out std_logic_vector(31 downto 0);
      ADR      : in  std_logic_vector(7 downto 0);
      D        : in  std_logic_vector(31 downto 0);
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

begin  -- architecture rtl

  -- Use memories from ASIC implementation
  g_asic_memory : if g_memory_type /= fpga generate

    trcmem_asic : SNPS_SP_HD_256x32
      port map (
        Q        => ram_do,
        ADR      => address,
        D        => ram_di,
        WE       => not we_n,
        ME       => not cs_n,
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

    -- Use simulation memory design for FPGA
  else generate

    trcmem_sim : fpga_SY180_256X32X1CM4
      port map (
        A0   => address(0),
        A1   => address(1),
        A2   => address(2),
        A3   => address(3),
        A4   => address(4),
        A5   => address(5),
        A6   => address(6),
        A7   => address(7),
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
        WEB  => we_n,
        CK   => clk,
        CSB  => cs_n
        );

  end generate g_asic_memory;
  

end architecture rtl;
