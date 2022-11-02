library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use work.gp_pkg.all;

entity ram_memory is
  generic (
    g_memory_type : memory_type_t := asic);
  port (
    clk     : in  std_logic;
    address : in  std_logic_vector(13 downto 0);
    ram_di  : in  std_logic_vector(7 downto 0);
    ram_do  : out std_logic_vector(7 downto 0);
    we_n    : in  std_logic;
    cs      : in  std_logic
    );

end entity ram_memory;

    architecture str of ram_memory is

-- application and microprogram shared memory
  component SU180_16384X8X1BM8
    port(
      A0  : in  std_logic;
      A1  : in  std_logic;
      A2  : in  std_logic;
      A3  : in  std_logic;
      A4  : in  std_logic;
      A5  : in  std_logic;
      A6  : in  std_logic;
      A7  : in  std_logic;
      A8  : in  std_logic;
      A9  : in  std_logic;
      A10 : in  std_logic;
      A11 : in  std_logic;
      A12 : in  std_logic;
      A13 : in  std_logic;
      DO0 : out std_logic;
      DO1 : out std_logic;
      DO2 : out std_logic;
      DO3 : out std_logic;
      DO4 : out std_logic;
      DO5 : out std_logic;
      DO6 : out std_logic;
      DO7 : out std_logic;
      DI0 : in  std_logic;
      DI1 : in  std_logic;
      DI2 : in  std_logic;
      DI3 : in  std_logic;
      DI4 : in  std_logic;
      DI5 : in  std_logic;
      DI6 : in  std_logic;
      DI7 : in  std_logic;
      WEB : in  std_logic;
      CK  : in  std_logic;
      CS  : in  std_logic;
      OE  : in  std_logic
      );
  end component;

  component SNPS_SP_HD_16Kx8
    port (
      Q        : out std_logic_vector(7 downto 0);
      ADR      : in  std_logic_vector(13 downto 0);
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

  component main_mem
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component load_ram is
    generic (
      initFile : string);
  end component load_ram;
  
  signal wea_v : std_ulogic_vector(0 to 0);

begin  -- architecture str

  wea_v(0) <= not we_n;

  -- Use memories for ASIC implementation
  g_memory : if g_memory_type /= fpga generate
  
      -- pragma synthesis_off
    i_load_ram : load_ram
      generic map (
        initFile => "main_mem.mif");
    -- pragma synthesis_on
    
    ram0_asic : SNPS_SP_HD_16Kx8
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

  else generate -- if g_memory_type = fpga generate

    ram0 : main_mem
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

    end generate;

end architecture str;
