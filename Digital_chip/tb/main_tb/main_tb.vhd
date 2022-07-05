library ieee;
use ieee.std_logic_1164.all;
use work.all;
use work.digital_top_sim_pack.all;
use work.tb_components_pkg.all;

use work.gp_pkg.all;

entity main_tb is
end main_tb;

architecture tb of main_tb is

  type port_name_t is (A, B, C, D, E, F, G, H, I, J);

  type ports_t is array (A to J) of std_logic_vector(7 downto 0);

  signal pad              : ports_t;
  signal port_to_im4000   : ports_t;
  signal port_from_im4000 : ports_t;
  signal port_oe          : ports_t;


  constant HALF_CLK_C_CYCLE : time := 16000 ps;

  signal MX1_CK   : std_logic;
  signal MXOUT    : std_logic;
  signal MEXEC    : std_logic;
  signal MCKOUT0  : std_logic;
  signal MCKOUT1  : std_logic;
  signal MSDIN    : std_logic;
  signal MSDOUT   : std_logic;
  signal MIRQOUT  : std_logic;
  signal MRESET   : std_logic;
  signal preset_n : std_logic                    := '0';
  signal MRSTOUT  : std_logic;
  signal MTEST    : std_logic                    := '0';
  signal MIRQ0    : std_logic;
  signal MIRQ1    : std_logic;
  signal D_DQ     : std_logic_vector(7 downto 0) := (others => 'Z');

  signal pa_i  : std_logic_vector(7 downto 0);
  signal PB    : std_logic_vector(7 downto 0);
  signal PC    : std_logic_vector(7 downto 0);
  signal PD    : std_logic_vector(7 downto 0);
  signal PE    : std_logic_vector(7 downto 0);
  signal PF    : std_logic_vector(7 downto 0);
  signal PG    : std_logic_vector(7 downto 0);
  signal PH    : std_logic_vector(7 downto 0);
  signal PI    : std_logic_vector(7 downto 0);
  signal pi_i  : std_logic_vector(7 downto 0);
  signal pi_o  : std_logic_vector(7 downto 0);
  signal pi_en : std_logic_vector(7 downto 0);
  signal PJ    : std_logic_vector(7 downto 0);
  signal pj_i  : std_logic_vector(7 downto 0);
  signal pj_o  : std_logic_vector(7 downto 0);
  signal pj_en : std_logic_vector(7 downto 0);

  signal MBYPASS    : std_logic;
  signal MWAKE      : std_logic;
  signal MLP_PWR_OK : std_logic := '0';
  signal XTAL1      : std_logic;

  signal reg_to_block : reg_to_block_t;

  signal xtal1_int  : std_logic := '0';
  signal mx1_ck_int : std_logic := '0';

  signal OSPI_Out   : OSPI_InterfaceOut_t;
  signal OSPI_DQ    : std_logic_vector(7 downto 0);
  signal OSPI_RWDS  : std_logic;
  signal OSPI_rst_n : std_logic;

  signal spi_rst_n : std_logic := '0';
  signal spi_sclk : std_logic := '0';
  signal spi_cs_n : std_logic := '1';
  signal spi_mosi : std_logic := '0';

  signal enet_mdio : std_logic := 'Z';

begin  -- architecture tb


  dut : entity work.digital_chip
    generic map (
      g_simulation => true
      )
    port map (
      pll_ref_clk => MX1_CK,
      mreset_n    => MRESET,
      preset_n    => preset_n,
      mrstout_n   => MRSTOUT,
      --MCKOUT1 => MCKOUT1,
      mtest       => MTEST,
      mirq0_n     => MIRQ0,
      mirq1_n     => MIRQ1,
      -- SW debug
      msdin       => MSDIN,
      msdout      => MSDOUT,
      mirqout     => MIRQOUT,
      mclkout     => MCKOUT0,

      -- Port A
      pa0_sin  => pad(A)(0),
      pa5_cs_n => pad(A)(5),
      pa6_sck  => pad(A)(6),
      pa7_sout => pad(A)(7),

      -- Port G   
      pg0 => pad(G)(0),
      pg1 => pad(G)(1),
      pg2 => pad(G)(2),
      pg3 => pad(G)(3),
      pg4 => pad(G)(4),
      pg5 => pad(G)(5),
      pg6 => pad(G)(6),
      pg7 => pad(G)(7),

      -- Ethernet Interface
      enet_mdio => enet_mdio,
      enet_mdc  => open,
      enet_clk  => open,
      enet_txen => open,
      enet_txer => open,
      enet_txd0 => open,
      enet_txd1 => open,
      enet_rxdv => open,
      enet_rxer => open,
      enet_rxd0 => open,
      enet_rxd1 => open,


      -- UART
      utx => pad(J)(0),
      urx => pad(J)(1),

      --MBYPASS    => MBYPASS,
      mwake => MWAKE,
      --MLP_PWR_OK => MLP_PWR_OK,

      -- Octal_spi
      emem_cs_n  => OSPI_Out.CS_n,
      emem_clk   => OSPI_Out.CK_p,
      emem_rst_n => OSPI_rst_n,
      emem_rwds  => OSPI_RWDS,
      emem_d0    => OSPI_DQ(0),
      emem_d1    => OSPI_DQ(1),
      emem_d2    => OSPI_DQ(2),
      emem_d3    => OSPI_DQ(3),
      emem_d4    => OSPI_DQ(4),
      emem_d5    => OSPI_DQ(5),
      emem_d6    => OSPI_DQ(6),
      emem_d7    => OSPI_DQ(7),

      -- SPI, chip control interface
      spi_rst_n => spi_rst_n,
      spi_sclk => spi_sclk,
      spi_cs_n => spi_cs_n,
      spi_miso => open,
      spi_mosi => spi_mosi,

      -- DAC and ADC pins
      aout0 => open,
      aout1 => open,
      ach0  => open

      );

  mtest <= '0';

  pad(A)(7 downto 5) <= "LLL";  --"000";          -- This is read by ROM bootloader
  pad(A)(4 downto 3) <= "LH";  --"01";           -- Set SP communication at /2 speed
  pad(A)(2 downto 1) <= "LH";  --"01";           -- Set PLL multiplier to 4
  pad(A)(0)          <= 'L';   --'1';            -- Set PLL divider to 1

  -- Reset the circuit for 10 ns;
  MRESET   <= '0', '1' after 10 ns;
  preset_n <= '0', '1' after 5 ns;
  spi_rst_n <= '0', '1' after 7 ns;

  -- This emulates a 31.25 MHz crystal
  mx1_ck_int <= not mx1_ck_int after HALF_CLK_C_CYCLE;
  MX1_CK     <= mx1_ck_int;

  -- This emulates a 32768 Hz crystal connected to RXOSC
  --xtal1_int <= not xtal1_int after 15259 ns;
  xtal1_int <= not xtal1_int after 1 us;
  XTAL1     <= xtal1_int;

  -- Bypass disabled
  MBYPASS <= '0';

  -- Wake-up signal inactive
  MWAKE <= '0';

  MIRQ0 <= '1';
  MIRQ1 <= '1';

  -- Connect MLP_PWR_OK to reset for simlicity.
  MLP_PWR_OK <= MRESET;

  i_debug_interface_bfm : entity work.debug_interface_bfm
    port map (

      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      mrstout => MRSTOUT,

      reg_to_block   => reg_to_block,
      reg_from_block => open
      );

  i_uart : entity work.uart_tb
    port map (
      tx             => pad(J)(1),
      rx             => pad(J)(0),
      reg_to_block   => reg_to_block,
      reg_from_block => x"00"
      );

  i_octo_spi : entity work.octo_memory_bfm
    port map (
      ck      => OSPI_Out.CK_p,
      cs      => OSPI_Out.CS_n,
      rwds    => OSPI_RWDS,
      dq      => OSPI_DQ,
      reset_n => OSPI_rst_n
      );

  spiflash_bfm : entity work.spiflash_bfm
    port map (
      clk    => pad(A)(6),
      cs_n   => pad(A)(5),
      di     => pad(A)(7),
      do     => pad(A)(0),
      wp_n   => '0',
      hold_n => '1'
      );

end architecture tb;
