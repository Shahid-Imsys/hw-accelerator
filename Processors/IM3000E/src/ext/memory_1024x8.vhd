library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use work.gp_pkg.all;

entity memory_1024x8 is
  generic (
    g_memory_type : memory_type_t := asic);
  port (
    clk     : in  std_logic;
    address : in  std_logic_vector(9 downto 0);
    ram_di  : in  std_logic_vector(7 downto 0);
    ram_do  : out std_logic_vector(7 downto 0);
    we_n    : in  std_logic;
    cs      : in  std_logic
    );

end entity memory_1024x8;

architecture rtl of memory_1024x8 is

  component SNPS_SP_HD_1024x8
    port (
      Q        : out std_logic_vector(7 downto 0);
      ADR      : in  std_logic_vector(9 downto 0);
      D        : in  std_logic_vector(7 downto 0);
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

   -- iomem
  component fpga_SY180_1024X8X1CM8     
    port(
      A0                         :   IN   std_logic;
      A1                         :   IN   std_logic;
      A2                         :   IN   std_logic;
      A3                         :   IN   std_logic;
      A4                         :   IN   std_logic;
      A5                         :   IN   std_logic;
      A6                         :   IN   std_logic;
      A7                         :   IN   std_logic;
      A8                         :   IN   std_logic;
      A9                         :   IN   std_logic;
      DO0                        :   OUT   std_logic;
      DO1                        :   OUT   std_logic;
      DO2                        :   OUT   std_logic;
      DO3                        :   OUT   std_logic;
      DO4                        :   OUT   std_logic;
      DO5                        :   OUT   std_logic;
      DO6                        :   OUT   std_logic;
      DO7                        :   OUT   std_logic;
      DI0                        :   IN   std_logic;
      DI1                        :   IN   std_logic;
      DI2                        :   IN   std_logic;
      DI3                        :   IN   std_logic;
      DI4                        :   IN   std_logic;
      DI5                        :   IN   std_logic;
      DI6                        :   IN   std_logic;
      DI7                        :   IN   std_logic;
      WEB                        :   IN   std_logic;
      CK                         :   IN   std_logic;
      CSB                        :   IN   std_logic
      );
  end component;

begin  -- architecture rtl

  -- Use memories for ASIC implementation (and simulation)
  g_asic_memory : if g_memory_type /= fpga generate
 io_mem_asic : SNPS_SP_HD_1024x8
    port map (
      Q        => ram_do,
      ADR      => address,
      D        => ram_di,
      WE       => not we_n,
      ME       => not cs,
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
  io_mem_sim: fpga_SY180_1024X8X1CM8
    port map (
        A0  => address(0),
        A1  => address(1),
        A2  => address(2),
        A3  => address(3),
        A4  => address(4),
        A5  => address(5),
        A6  => address(6),
        A7  => address(7),
        A8  => address(8),
        A9  => address(9),
        DO0 => ram_do(0),
        DO1 => ram_do(1),
        DO2 => ram_do(2),
        DO3 => ram_do(3),
        DO4 => ram_do(4),
        DO5 => ram_do(5),
        DO6 => ram_do(6),
        DO7 => ram_do(7),
        DI0 => ram_di(0),
        DI1 => ram_di(1),
        DI2 => ram_di(2),
        DI3 => ram_di(3),
        DI4 => ram_di(4),
        DI5 => ram_di(5),
        DI6 => ram_di(6),
        DI7 => ram_di(7),
        WEB => we_n,
        CK  => clk,
        CSB  => cs
        );
  end generate;
  

end architecture rtl;
