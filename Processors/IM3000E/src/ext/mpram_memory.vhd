library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use work.gp_pkg.all;

entity mpram_memory is

  generic (
    g_file_name   : string        := "mpram0.data";
    g_memory_type : memory_type_t := asic);

  port (
    address : in  std_logic_vector(10 downto 0);
    ram_di  : in  std_logic_vector(79 downto 0);
    ram_do  : out std_logic_vector(79 downto 0);
    we_n    : in  std_logic;
    clk     : in  std_logic;
    cs      : in  std_logic);

end entity mpram_memory;

architecture str of mpram_memory is

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

  component mpram_mem is
    port (
      a       : in  std_logic_vector(10 downto 0);
      d       : in  std_logic_vector(79 downto 0);
      clk     : in  std_logic;
      we      : in  std_logic;
      i_ce    : in  std_logic;
      spo    : out std_logic_vector(79 downto 0));
  end component mpram_mem;
  
  component load_mpram is
    generic (
      initFile : string);
  end component load_mpram;

  signal ram_do_fpga : std_logic_vector(79 downto 0);

begin  -- architecture str

  -- Use memories from ASIC implementation
  g_asic_memory : if g_memory_type /= fpga generate

    -- pragma synthesis_off
    i_load_mpram : load_mpram
      generic map (
        initFile => g_file_name);
    -- pragma synthesis_on
    
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

  else generate -- fpga

    mpram_fpga : mpram_mem
      port map (
        a    => address,
        d    => ram_di,
        clk  => clk,
        we   => not we_n,
        i_ce => cs,
        spo  => ram_do
        );
  end generate;

end architecture str;
