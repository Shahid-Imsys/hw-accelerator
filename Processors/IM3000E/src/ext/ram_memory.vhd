library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

use work.gp_pkg.all;

entity ram_memory is
  generic (
    g_memory_type : memory_type_t := asic;
    initFile      : string        := "main_mem.mif";
    fpgaMemIndex  : integer       := 0 );
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
  
  component main_mem_p0
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p1
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p2
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p3
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p4
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p5
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p6
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p7
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p8
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p9
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p10
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p11
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p12
    port (
      clka  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(13 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

  component main_mem_p13
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
        initFile => initFile );
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

  elsif fpgaMemIndex = 0 generate

    fpga0 : main_mem_p0
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 1 generate

    fpga1 : main_mem_p1
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 2 generate

    fpga2 : main_mem_p2
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 3 generate

    fpga3 : main_mem_p3
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 4 generate

    fpga4 : main_mem_p4
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 5 generate

    fpga5 : main_mem_p5
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 6 generate

    fpga6 : main_mem_p6
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 7 generate

    fpga7 : main_mem_p7
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 8 generate

    fpga8 : main_mem_p8
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 9 generate

    fpga9 : main_mem_p9
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 10 generate

    fpga10 : main_mem_p10
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 11 generate

    fpga11 : main_mem_p11
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 12 generate

    fpga12 : main_mem_p12
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  elsif fpgaMemIndex = 13 generate

    fpga13 : main_mem_p13
      port map (
        clka  => clk,
        ena   => cs,
        wea   => wea_v,
        addra => address,
        dina  => ram_di,
        douta => ram_do
        );

  else generate

    fpgax : main_mem
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
