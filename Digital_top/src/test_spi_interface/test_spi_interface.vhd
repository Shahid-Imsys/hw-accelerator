library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.all;
use work.data_types_pack.all;
use work.project_settings.all;

entity test_spi_interface is
  port (
    rst_n        : in std_ulogic;
    sclk_int     : in std_ulogic;
    sclk_n       : in std_ulogic;
    cs_n         : in std_ulogic;
    mosi         : in std_ulogic;
    miso         : out std_ulogic;
    miso_oe_n    : out std_ulogic;
    pad_config   : out pad_config_record_t;
    pll_config   : out pll_registers_record_t;
    adpll_config : in adpll_registers_record_t
  );

end entity test_spi_interface;

architecture rtl of test_spi_interface is

  component spi_interface is
    generic (
      data_width_g           : natural   := 8;
      address_width_g        : natural   := 7;
      start_burst_adresses_g : natural   := 16#ff#;
      write_value_g          : std_logic := '0'
    );
    port (
      clk       : in std_ulogic; -- Clock from microcontroller spi
      nclk      : in std_ulogic; -- Invers clk
      spi_rst_n : in std_ulogic;
      cs_n      : in std_ulogic;
      mosi      : in std_ulogic;  -- Master output Slave input
      miso      : out std_ulogic; -- Master input Slave Output
      miso_oe_n : out std_ulogic;

      write_spi : out std_ulogic;
      enable    : out std_ulogic;
      address   : out unsigned(address_width_g - 1 downto 0);
      data_in   : in std_ulogic_vector(spi_data_width_c - 1 downto 0);
      data_out  : out std_ulogic_vector(spi_data_width_c - 1 downto 0);

      update_buffer_index : out std_ulogic
    );
  end component spi_interface;

  signal sub_word            : std_ulogic_vector(15 downto 0);
  signal write_data          : std_ulogic;
  signal address             : unsigned(spi_address_width_c - 1 downto 0);
  signal register_enable     : std_ulogic;
  signal register_data_in    : std_ulogic_vector(spi_data_width_c - 1 downto 0) := (others => '0');
  signal register_data_out   : std_ulogic_vector(spi_data_width_c - 1 downto 0) := (others => '0');
  signal update_buffer_index : std_ulogic;
  signal spi_rst_n           : std_ulogic;

  constant version_str : string := temp_version_spi_test(12 to 16);

begin -- architecture rtl

  sub_word  <= str_to_stdUlogicVector (version_str);
  spi_rst_n <= not cs_n;

  i_register_block_spi_test : register_block_spi_test
  port map(
    clk             => sclk_n,
    rst_n           => rst_n,
    version_analog  => x"0",
    version_digital => x"1",

    mclkout_ds                   => pad_config.mclkout.ds,
    mclkout_sr                   => pad_config.mclkout.sr,
    mclkout_co                   => pad_config.mclkout.co,
    mclkout_odp                  => pad_config.mclkout.odp,
    mclkout_odn                  => pad_config.mclkout.odn,
    msdout_ds                    => pad_config.msdout.ds,
    msdout_sr                    => pad_config.msdout.sr,
    msdout_co                    => pad_config.msdout.co,
    msdout_odp                   => pad_config.msdout.odp,
    msdout_odn                   => pad_config.msdout.odn,
    utx_ds                       => pad_config.utx.ds,
    utx_sr                       => pad_config.utx.sr,
    utx_co                       => pad_config.utx.co,
    utx_odp                      => pad_config.utx.odp,
    utx_odn                      => pad_config.utx.odn,
    mirqout_ds                   => pad_config.mirqout.ds,
    mirqout_sr                   => pad_config.mirqout.sr,
    mirqout_co                   => pad_config.mirqout.co,
    mirqout_odp                  => pad_config.mirqout.odp,
    mirqout_odn                  => pad_config.mirqout.odn,
    msdin_ste                    => pad_config.msdin.ste,
    msdin_pd                     => pad_config.msdin.pd,
    msdin_pu                     => pad_config.msdin.pu,
    mirq0_ste                    => pad_config.mirq0.ste,
    mirq0_pd                     => pad_config.mirq0.pd,
    mirq0_pu                     => pad_config.mirq0.pu,
    mirq1_ste                    => pad_config.mirq1.ste,
    mirq1_pd                     => pad_config.mirq1.pd,
    mirq1_pu                     => pad_config.mirq1.pu,
    urx_ste                      => pad_config.urx.ste,
    urx_pd                       => pad_config.urx.pd,
    urx_pu                       => pad_config.urx.pu,
    emem_d0_out_ds               => pad_config.emem_d0.ds,
    emem_d0_out_sr               => pad_config.emem_d0.sr,
    emem_d0_out_co               => pad_config.emem_d0.co,
    emem_d0_out_odp              => pad_config.emem_d0.odp,
    emem_d0_out_odn              => pad_config.emem_d0.odn,
    emem_d0_in_ste               => pad_config.emem_d0.ste,
    emem_d0_in_pd                => pad_config.emem_d0.pd,
    emem_d0_in_pu                => pad_config.emem_d0.pu,
    emem_d1_out_ds               => pad_config.emem_d1.ds,
    emem_d1_out_sr               => pad_config.emem_d1.sr,
    emem_d1_out_co               => pad_config.emem_d1.co,
    emem_d1_out_odp              => pad_config.emem_d1.odp,
    emem_d1_out_odn              => pad_config.emem_d1.odn,
    emem_d1_in_ste               => pad_config.emem_d1.ste,
    emem_d1_in_pd                => pad_config.emem_d1.pd,
    emem_d1_in_pu                => pad_config.emem_d1.pu,
    emem_d2_out_ds               => pad_config.emem_d2.ds,
    emem_d2_out_sr               => pad_config.emem_d2.sr,
    emem_d2_out_co               => pad_config.emem_d2.co,
    emem_d2_out_odp              => pad_config.emem_d2.odp,
    emem_d2_out_odn              => pad_config.emem_d2.odn,
    emem_d2_in_ste               => pad_config.emem_d2.ste,
    emem_d2_in_pd                => pad_config.emem_d2.pd,
    emem_d2_in_pu                => pad_config.emem_d2.pu,
    emem_d3_out_ds               => pad_config.emem_d3.ds,
    emem_d3_out_sr               => pad_config.emem_d3.sr,
    emem_d3_out_co               => pad_config.emem_d3.co,
    emem_d3_out_odp              => pad_config.emem_d3.odp,
    emem_d3_out_odn              => pad_config.emem_d3.odn,
    emem_d3_in_ste               => pad_config.emem_d3.ste,
    emem_d3_in_pd                => pad_config.emem_d3.pd,
    emem_d3_in_pu                => pad_config.emem_d3.pu,
    emem_d4_out_ds               => pad_config.emem_d4.ds,
    emem_d4_out_sr               => pad_config.emem_d4.sr,
    emem_d4_out_co               => pad_config.emem_d4.co,
    emem_d4_out_odp              => pad_config.emem_d4.odp,
    emem_d4_out_odn              => pad_config.emem_d4.odn,
    emem_d4_in_ste               => pad_config.emem_d4.ste,
    emem_d4_in_pd                => pad_config.emem_d4.pd,
    emem_d4_in_pu                => pad_config.emem_d4.pu,
    emem_d5_out_ds               => pad_config.emem_d5.ds,
    emem_d5_out_sr               => pad_config.emem_d5.sr,
    emem_d5_out_co               => pad_config.emem_d5.co,
    emem_d5_out_odp              => pad_config.emem_d5.odp,
    emem_d5_out_odn              => pad_config.emem_d5.odn,
    emem_d5_in_ste               => pad_config.emem_d5.ste,
    emem_d5_in_pd                => pad_config.emem_d5.pd,
    emem_d5_in_pu                => pad_config.emem_d5.pu,
    emem_d6_out_ds               => pad_config.emem_d6.ds,
    emem_d6_out_sr               => pad_config.emem_d6.sr,
    emem_d6_out_co               => pad_config.emem_d6.co,
    emem_d6_out_odp              => pad_config.emem_d6.odp,
    emem_d6_out_odn              => pad_config.emem_d6.odn,
    emem_d6_in_ste               => pad_config.emem_d6.ste,
    emem_d6_in_pd                => pad_config.emem_d6.pd,
    emem_d6_in_pu                => pad_config.emem_d6.pu,
    emem_d7_out_ds               => pad_config.emem_d7.ds,
    emem_d7_out_sr               => pad_config.emem_d7.sr,
    emem_d7_out_co               => pad_config.emem_d7.co,
    emem_d7_out_odp              => pad_config.emem_d7.odp,
    emem_d7_out_odn              => pad_config.emem_d7.odn,
    emem_d7_in_ste               => pad_config.emem_d7.ste,
    emem_d7_in_pd                => pad_config.emem_d7.pd,
    emem_d7_in_pu                => pad_config.emem_d7.pu,
    emem_clk_ds                  => pad_config.emem_clk.ds,
    emem_clk_sr                  => pad_config.emem_clk.sr,
    emem_clk_co                  => pad_config.emem_clk.co,
    emem_clk_odp                 => pad_config.emem_clk.odp,
    emem_clk_odn                 => pad_config.emem_clk.odn,
    emem_clk_n_ds                => pad_config.emem_clk_n.ds,
    emem_clk_n_sr                => pad_config.emem_clk_n.sr,
    emem_clk_n_co                => pad_config.emem_clk_n.co,
    emem_clk_n_odp               => pad_config.emem_clk_n.odp,
    emem_clk_n_odn               => pad_config.emem_clk_n.odn,
    emem_rwds_out_ds             => pad_config.emem_rwds.ds,
    emem_rwds_out_sr             => pad_config.emem_rwds.sr,
    emem_rwds_out_co             => pad_config.emem_rwds.co,
    emem_rwds_out_odp            => pad_config.emem_rwds.odp,
    emem_rwds_out_odn            => pad_config.emem_rwds.odn,
    emem_rwds_in_ste             => pad_config.emem_rwds.ste,
    emem_rwds_in_pd              => pad_config.emem_rwds.pd,
    emem_rwds_in_pu              => pad_config.emem_rwds.pu,
    emem_cs_n_ds                 => pad_config.emem_cs_n.ds,
    emem_cs_n_sr                 => pad_config.emem_cs_n.sr,
    emem_cs_n_co                 => pad_config.emem_cs_n.co,
    emem_cs_n_odp                => pad_config.emem_cs_n.odp,
    emem_cs_n_odn                => pad_config.emem_cs_n.odn,
    emem_rst_n_ds                => pad_config.emem_rst_n.ds,
    emem_rst_n_sr                => pad_config.emem_rst_n.sr,
    emem_rst_n_co                => pad_config.emem_rst_n.co,
    emem_rst_n_odp               => pad_config.emem_rst_n.odp,
    emem_rst_n_odn               => pad_config.emem_rst_n.odn,
    aout0_ds                     => pad_config.aout0.ds,
    aout0_sr                     => pad_config.aout0.sr,
    aout0_co                     => pad_config.aout0.co,
    aout0_odp                    => pad_config.aout0.odp,
    aout0_odn                    => pad_config.aout0.odn,
    aout1_ds                     => pad_config.aout1.ds,
    aout1_sr                     => pad_config.aout1.sr,
    aout1_co                     => pad_config.aout1.co,
    aout1_odp                    => pad_config.aout1.odp,
    aout1_odn                    => pad_config.aout1.odn,
    ach0_ste                     => pad_config.ach0.ste,
    ach0_pd                      => pad_config.ach0.pd,
    ach0_pu                      => pad_config.ach0.pu,
    enet_mdio_out_ds             => pad_config.enet_mdio.ds,
    enet_mdio_out_sr             => pad_config.enet_mdio.sr,
    enet_mdio_out_co             => pad_config.enet_mdio.co,
    enet_mdio_out_odp            => pad_config.enet_mdio.odp,
    enet_mdio_out_odn            => pad_config.enet_mdio.odn,
    enet_mdio_in_ste             => pad_config.enet_mdio.ste,
    enet_mdio_in_pd              => pad_config.enet_mdio.pd,
    enet_mdio_in_pu              => pad_config.enet_mdio.pu,
    enet_mdc_ds                  => pad_config.enet_mdc.ds,
    enet_mdc_sr                  => pad_config.enet_mdc.sr,
    enet_mdc_co                  => pad_config.enet_mdc.co,
    enet_mdc_odp                 => pad_config.enet_mdc.odp,
    enet_mdc_odn                 => pad_config.enet_mdc.odn,
    enet_txer_ds                 => pad_config.enet_txer.ds,
    enet_txer_sr                 => pad_config.enet_txer.sr,
    enet_txer_co                 => pad_config.enet_txer.co,
    enet_txer_odp                => pad_config.enet_txer.odp,
    enet_txer_odn                => pad_config.enet_txer.odn,
    enet_txd0_ds                 => pad_config.enet_txd0.ds,
    enet_txd0_sr                 => pad_config.enet_txd0.sr,
    enet_txd0_co                 => pad_config.enet_txd0.co,
    enet_txd0_odp                => pad_config.enet_txd0.odp,
    enet_txd0_odn                => pad_config.enet_txd0.odn,
    enet_txd1_ds                 => pad_config.enet_txd1.ds,
    enet_txd1_sr                 => pad_config.enet_txd1.sr,
    enet_txd1_co                 => pad_config.enet_txd1.co,
    enet_txd1_odp                => pad_config.enet_txd1.odp,
    enet_txd1_odn                => pad_config.enet_txd1.odn,
    enet_txen_ds                 => pad_config.enet_txen.ds,
    enet_txen_sr                 => pad_config.enet_txen.sr,
    enet_txen_co                 => pad_config.enet_txen.co,
    enet_txen_odp                => pad_config.enet_txen.odp,
    enet_txen_odn                => pad_config.enet_txen.odn,
    enet_clk_ste                 => pad_config.enet_clk.ste,
    enet_clk_pd                  => pad_config.enet_clk.pd,
    enet_clk_pu                  => pad_config.enet_clk.pu,
    enet_rxdv_ste                => pad_config.enet_rxdv.ste,
    enet_rxdv_pd                 => pad_config.enet_rxdv.pd,
    enet_rxdv_pu                 => pad_config.enet_rxdv.pu,
    enet_rxd0_ste                => pad_config.enet_rxd0.ste,
    enet_rxd0_pd                 => pad_config.enet_rxd0.pd,
    enet_rxd0_pu                 => pad_config.enet_rxd0.pu,
    enet_rxd1_ste                => pad_config.enet_rxd1.ste,
    enet_rxd1_pd                 => pad_config.enet_rxd1.pd,
    enet_rxd1_pu                 => pad_config.enet_rxd1.pu,
    enet_rxer_ste                => pad_config.enet_rxer.ste,
    enet_rxer_pd                 => pad_config.enet_rxer.pd,
    enet_rxer_pu                 => pad_config.enet_rxer.pu,
    spi_sclk_ste                 => pad_config.spi_sclk.ste,
    spi_sclk_pd                  => pad_config.spi_sclk.pd,
    spi_sclk_pu                  => pad_config.spi_sclk.pu,
    spi_cs_n_ste                 => pad_config.spi_cs_n.ste,
    spi_cs_n_pd                  => pad_config.spi_cs_n.pd,
    spi_cs_n_pu                  => pad_config.spi_cs_n.pu,
    spi_mosi_ste                 => pad_config.spi_mosi.ste,
    spi_mosi_pd                  => pad_config.spi_mosi.pd,
    spi_mosi_pu                  => pad_config.spi_mosi.pu,
    spi_miso_ds                  => pad_config.spi_miso.ds,
    spi_miso_sr                  => pad_config.spi_miso.sr,
    spi_miso_co                  => pad_config.spi_miso.co,
    spi_miso_odp                 => pad_config.spi_miso.odp,
    spi_miso_odn                 => pad_config.spi_miso.odn,
    pll_ref_clk_ste              => pad_config.pll_ref_clk.ste,
    pll_ref_clk_pd               => pad_config.pll_ref_clk.pd,
    pll_ref_clk_pu               => pad_config.pll_ref_clk.pu,
    pa0_sin_out_ds               => pad_config.pa0_sin.ds,
    pa0_sin_out_sr               => pad_config.pa0_sin.sr,
    pa0_sin_out_co               => pad_config.pa0_sin.co,
    pa0_sin_out_odp              => pad_config.pa0_sin.odp,
    pa0_sin_out_odn              => pad_config.pa0_sin.odn,
    pa0_sin_in_ste               => pad_config.pa0_sin.ste,
    pa0_sin_in_pd                => pad_config.pa0_sin.pd,
    pa0_sin_in_pu                => pad_config.pa0_sin.pu,
    pa5_cs_n_out_ds              => pad_config.pa5_cs_n.ds,
    pa5_cs_n_out_sr              => pad_config.pa5_cs_n.sr,
    pa5_cs_n_out_co              => pad_config.pa5_cs_n.co,
    pa5_cs_n_out_odp             => pad_config.pa5_cs_n.odp,
    pa5_cs_n_out_odn             => pad_config.pa5_cs_n.odn,
    pa5_cs_n_in_ste              => pad_config.pa5_cs_n.ste,
    pa5_cs_n_in_pd               => pad_config.pa5_cs_n.pd,
    pa5_cs_n_in_pu               => pad_config.pa5_cs_n.pu,
    pa6_sck_out_ds               => pad_config.pa6_sck.ds,
    pa6_sck_out_sr               => pad_config.pa6_sck.sr,
    pa6_sck_out_co               => pad_config.pa6_sck.co,
    pa6_sck_out_odp              => pad_config.pa6_sck.odp,
    pa6_sck_out_odn              => pad_config.pa6_sck.odn,
    pa6_sck_in_ste               => pad_config.pa6_sck.ste,
    pa6_sck_in_pd                => pad_config.pa6_sck.pd,
    pa6_sck_in_pu                => pad_config.pa6_sck.pu,
    pa7_sout_out_ds              => pad_config.pa7_sout.ds,
    pa7_sout_out_sr              => pad_config.pa7_sout.sr,
    pa7_sout_out_co              => pad_config.pa7_sout.co,
    pa7_sout_out_odp             => pad_config.pa7_sout.odp,
    pa7_sout_out_odn             => pad_config.pa7_sout.odn,
    pa7_sout_in_ste              => pad_config.pa7_sout.ste,
    pa7_sout_in_pd               => pad_config.pa7_sout.pd,
    pa7_sout_in_pu               => pad_config.pa7_sout.pu,
    pg0_out_ds                   => pad_config.pg0.ds,
    pg0_out_sr                   => pad_config.pg0.sr,
    pg0_out_co                   => pad_config.pg0.co,
    pg0_out_odp                  => pad_config.pg0.odp,
    pg0_out_odn                  => pad_config.pg0.odn,
    pg0_in_ste                   => pad_config.pg0.ste,
    pg0_in_pd                    => pad_config.pg0.pd,
    pg0_in_pu                    => pad_config.pg0.pu,
    pg1_out_ds                   => pad_config.pg1.ds,
    pg1_out_sr                   => pad_config.pg1.sr,
    pg1_out_co                   => pad_config.pg1.co,
    pg1_out_odp                  => pad_config.pg1.odp,
    pg1_out_odn                  => pad_config.pg1.odn,
    pg1_in_ste                   => pad_config.pg1.ste,
    pg1_in_pd                    => pad_config.pg1.pd,
    pg1_in_pu                    => pad_config.pg1.pu,
    pg2_out_ds                   => pad_config.pg2.ds,
    pg2_out_sr                   => pad_config.pg2.sr,
    pg2_out_co                   => pad_config.pg2.co,
    pg2_out_odp                  => pad_config.pg2.odp,
    pg2_out_odn                  => pad_config.pg2.odn,
    pg2_in_ste                   => pad_config.pg2.ste,
    pg2_in_pd                    => pad_config.pg2.pd,
    pg2_in_pu                    => pad_config.pg2.pu,
    pg3_out_ds                   => pad_config.pg3.ds,
    pg3_out_sr                   => pad_config.pg3.sr,
    pg3_out_co                   => pad_config.pg3.co,
    pg3_out_odp                  => pad_config.pg3.odp,
    pg3_out_odn                  => pad_config.pg3.odn,
    pg3_in_ste                   => pad_config.pg3.ste,
    pg3_in_pd                    => pad_config.pg3.pd,
    pg3_in_pu                    => pad_config.pg3.pu,
    pg4_out_ds                   => pad_config.pg4.ds,
    pg4_out_sr                   => pad_config.pg4.sr,
    pg4_out_co                   => pad_config.pg4.co,
    pg4_out_odp                  => pad_config.pg4.odp,
    pg4_out_odn                  => pad_config.pg4.odn,
    pg4_in_ste                   => pad_config.pg4.ste,
    pg4_in_pd                    => pad_config.pg4.pd,
    pg4_in_pu                    => pad_config.pg4.pu,
    pg5_out_ds                   => pad_config.pg5.ds,
    pg5_out_sr                   => pad_config.pg5.sr,
    pg5_out_co                   => pad_config.pg5.co,
    pg5_out_odp                  => pad_config.pg5.odp,
    pg5_out_odn                  => pad_config.pg5.odn,
    pg5_in_ste                   => pad_config.pg5.ste,
    pg5_in_pd                    => pad_config.pg5.pd,
    pg5_in_pu                    => pad_config.pg5.pu,
    pg6_out_ds                   => pad_config.pg6.ds,
    pg6_out_sr                   => pad_config.pg6.sr,
    pg6_out_co                   => pad_config.pg6.co,
    pg6_out_odp                  => pad_config.pg6.odp,
    pg6_out_odn                  => pad_config.pg6.odn,
    pg6_in_ste                   => pad_config.pg6.ste,
    pg6_in_pd                    => pad_config.pg6.pd,
    pg6_in_pu                    => pad_config.pg6.pu,
    pg7_out_ds                   => pad_config.pg7.ds,
    pg7_out_sr                   => pad_config.pg7.sr,
    pg7_out_co                   => pad_config.pg7.co,
    pg7_out_odp                  => pad_config.pg7.odp,
    pg7_out_odn                  => pad_config.pg7.odn,
    pg7_in_ste                   => pad_config.pg7.ste,
    pg7_in_pd                    => pad_config.pg7.pd,
    pg7_in_pu                    => pad_config.pg7.pu,
    mtest_ste                    => pad_config.mtest.ste,
    mtest_pd                     => pad_config.mtest.pd,
    mtest_pu                     => pad_config.mtest.pu,
    mwake_ste                    => pad_config.mwake.ste,
    mwake_pd                     => pad_config.mwake.pd,
    mwake_pu                     => pad_config.mwake.pu,
    mrxout_out_ds                => pad_config.mrxout.ds,
    mrxout_out_sr                => pad_config.mrxout.sr,
    mrxout_out_co                => pad_config.mrxout.co,
    mrxout_out_odp               => pad_config.mrxout.odp,
    mrxout_out_odn               => pad_config.mrxout.odn,
    mrxout_in_ste                => pad_config.mrxout.ste,
    mrxout_in_pd                 => pad_config.mrxout.pd,
    mrxout_in_pu                 => pad_config.mrxout.pu,
    pll_1_main_div_n1            => pll_config.main_div_n1,
    pll_1_main_div_n2            => pll_config.main_div_n2,
    pll_1_main_div_n3            => pll_config.main_div_n3,
    pll_1_main_div_n4            => pll_config.main_div_n4,
    pll_2_open_loop              => pll_config.open_loop,
    pll_2_out_div_sel            => pll_config.out_div_sel,
    pll_2_ci                     => pll_config.ci,
    pll_cp_cp                    => pll_config.cp,
    pll_ft_ft                    => pll_config.ft,
    pll_3_divcore_sel            => pll_config.divcore_sel,
    pll_3_coarse                 => pll_config.coarse,
    pll_4_auto_coarsetune        => pll_config.auto_coarsetune,
    pll_4_enforce_lock           => pll_config.enforce_lock,
    pll_4_pfd_select             => pll_config.pfd_select,
    pll_4_lock_window_sel        => pll_config.lock_window_sel,
    pll_4_div_core_mux_sel       => pll_config.div_core_mux_sel,
    pll_4_filter_shift           => pll_config.filter_shift,
    pll_4_en_fast_lock           => pll_config.en_fast_lock,
    pll_5_sar_limit              => pll_config.sar_limit,
    pll_5_set_op_lock            => pll_config.set_op_lock,
    pll_5_disable_lock           => pll_config.disable_lock,
    pll_5_ref_bypass             => pll_config.ref_bypass,
    pll_5_ct_compensation        => pll_config.ct_compensation,
    adpll_status0_adpll_status_0 => adpll_config.adpll_status_0,
    adpll_status1_adpll_status_1 => adpll_config.adpll_status_1,
    adpll_status2_adpll_status_2 => adpll_config.adpll_status_2,
    io_dack0_n_ste               => pad_config.io_dack0_n.ste,
    io_dack0_n_pd                => pad_config.io_dack0_n.pd,
    io_dack0_n_pu                => pad_config.io_dack0_n.pu,
    io_dreq0_n_ds                => pad_config.io_dreq0_n.ds,
    io_dreq0_n_sr                => pad_config.io_dreq0_n.sr,
    io_dreq0_n_co                => pad_config.io_dreq0_n.co,
    io_dreq0_n_odp               => pad_config.io_dreq0_n.odp,
    io_dreq0_n_odn               => pad_config.io_dreq0_n.odn,
    io_dack1_n_ste               => pad_config.io_dack1_n.ste,
    io_dack1_n_pd                => pad_config.io_dack1_n.pd,
    io_dack1_n_pu                => pad_config.io_dack1_n.pu,
    io_dreq1_n_ds                => pad_config.io_dreq1_n.ds,
    io_dreq1_n_sr                => pad_config.io_dreq1_n.sr,
    io_dreq1_n_co                => pad_config.io_dreq1_n.co,
    io_dreq1_n_odp               => pad_config.io_dreq1_n.odp,
    io_dreq1_n_odn               => pad_config.io_dreq1_n.odn,
    io_dack2_n_ste               => pad_config.io_dack2_n.ste,
    io_dack2_n_pd                => pad_config.io_dack2_n.pd,
    io_dack2_n_pu                => pad_config.io_dack2_n.pu,
    io_dreq2_n_ds                => pad_config.io_dreq2_n.ds,
    io_dreq2_n_sr                => pad_config.io_dreq2_n.sr,
    io_dreq2_n_co                => pad_config.io_dreq2_n.co,
    io_dreq2_n_odp               => pad_config.io_dreq2_n.odp,
    io_dreq2_n_odn               => pad_config.io_dreq2_n.odn,
    io_dack3_n_ste               => pad_config.io_dack3_n.ste,
    io_dack3_n_pd                => pad_config.io_dack3_n.pd,
    io_dack3_n_pu                => pad_config.io_dack3_n.pu,
    io_dreq3_n_ds                => pad_config.io_dreq3_n.ds,
    io_dreq3_n_sr                => pad_config.io_dreq3_n.sr,
    io_dreq3_n_co                => pad_config.io_dreq3_n.co,
    io_dreq3_n_odp               => pad_config.io_dreq3_n.odp,
    io_dreq3_n_odn               => pad_config.io_dreq3_n.odn,
    io_d0_out_ds                 => pad_config.io_d0.ds,
    io_d0_out_sr                 => pad_config.io_d0.sr,
    io_d0_out_co                 => pad_config.io_d0.co,
    io_d0_out_odp                => pad_config.io_d0.odp,
    io_d0_out_odn                => pad_config.io_d0.odn,
    io_d0_in_ste                 => pad_config.io_d0.ste,
    io_d0_in_pd                  => pad_config.io_d0.pd,
    io_d0_in_pu                  => pad_config.io_d0.pu,
    io_d1_out_ds                 => pad_config.io_d1.ds,
    io_d1_out_sr                 => pad_config.io_d1.sr,
    io_d1_out_co                 => pad_config.io_d1.co,
    io_d1_out_odp                => pad_config.io_d1.odp,
    io_d1_out_odn                => pad_config.io_d1.odn,
    io_d1_in_ste                 => pad_config.io_d1.ste,
    io_d1_in_pd                  => pad_config.io_d1.pd,
    io_d1_in_pu                  => pad_config.io_d1.pu,
    io_d2_out_ds                 => pad_config.io_d2.ds,
    io_d2_out_sr                 => pad_config.io_d2.sr,
    io_d2_out_co                 => pad_config.io_d2.co,
    io_d2_out_odp                => pad_config.io_d2.odp,
    io_d2_out_odn                => pad_config.io_d2.odn,
    io_d2_in_ste                 => pad_config.io_d2.ste,
    io_d2_in_pd                  => pad_config.io_d2.pd,
    io_d2_in_pu                  => pad_config.io_d2.pu,
    io_d3_out_ds                 => pad_config.io_d3.ds,
    io_d3_out_sr                 => pad_config.io_d3.sr,
    io_d3_out_co                 => pad_config.io_d3.co,
    io_d3_out_odp                => pad_config.io_d3.odp,
    io_d3_out_odn                => pad_config.io_d3.odn,
    io_d3_in_ste                 => pad_config.io_d3.ste,
    io_d3_in_pd                  => pad_config.io_d3.pd,
    io_d3_in_pu                  => pad_config.io_d3.pu,
    io_d4_out_ds                 => pad_config.io_d4.ds,
    io_d4_out_sr                 => pad_config.io_d4.sr,
    io_d4_out_co                 => pad_config.io_d4.co,
    io_d4_out_odp                => pad_config.io_d4.odp,
    io_d4_out_odn                => pad_config.io_d4.odn,
    io_d4_in_ste                 => pad_config.io_d4.ste,
    io_d4_in_pd                  => pad_config.io_d4.pd,
    io_d4_in_pu                  => pad_config.io_d4.pu,
    io_d5_out_ds                 => pad_config.io_d5.ds,
    io_d5_out_sr                 => pad_config.io_d5.sr,
    io_d5_out_co                 => pad_config.io_d5.co,
    io_d5_out_odp                => pad_config.io_d5.odp,
    io_d5_out_odn                => pad_config.io_d5.odn,
    io_d5_in_ste                 => pad_config.io_d5.ste,
    io_d5_in_pd                  => pad_config.io_d5.pd,
    io_d5_in_pu                  => pad_config.io_d5.pu,
    io_d6_out_ds                 => pad_config.io_d6.ds,
    io_d6_out_sr                 => pad_config.io_d6.sr,
    io_d6_out_co                 => pad_config.io_d6.co,
    io_d6_out_odp                => pad_config.io_d6.odp,
    io_d6_out_odn                => pad_config.io_d6.odn,
    io_d6_in_ste                 => pad_config.io_d6.ste,
    io_d6_in_pd                  => pad_config.io_d6.pd,
    io_d6_in_pu                  => pad_config.io_d6.pu,
    io_d7_out_ds                 => pad_config.io_d7.ds,
    io_d7_out_sr                 => pad_config.io_d7.sr,
    io_d7_out_co                 => pad_config.io_d7.co,
    io_d7_out_odp                => pad_config.io_d7.odp,
    io_d7_out_odn                => pad_config.io_d7.odn,
    io_d7_in_ste                 => pad_config.io_d7.ste,
    io_d7_in_pd                  => pad_config.io_d7.pd,
    io_d7_in_pu                  => pad_config.io_d7.pu,
    io_ldout_n_ds                => pad_config.io_ldout_n.ds,
    io_ldout_n_sr                => pad_config.io_ldout_n.sr,
    io_ldout_n_co                => pad_config.io_ldout_n.co,
    io_ldout_n_odp               => pad_config.io_ldout_n.odp,
    io_ldout_n_odn               => pad_config.io_ldout_n.odn,
    io_next_n_ds                 => pad_config.io_next_n.ds,
    io_next_n_sr                 => pad_config.io_next_n.sr,
    io_next_n_co                 => pad_config.io_next_n.co,
    io_next_n_odp                => pad_config.io_next_n.odp,
    io_next_n_odn                => pad_config.io_next_n.odn,
    io_clk_ds                    => pad_config.io_clk.ds,
    io_clk_sr                    => pad_config.io_clk.sr,
    io_clk_co                    => pad_config.io_clk.co,
    io_clk_odp                   => pad_config.io_clk.odp,
    io_clk_odn                   => pad_config.io_clk.odn,
    io_ioa_n_ds                  => pad_config.io_ioa_n.ds,
    io_ioa_n_sr                  => pad_config.io_ioa_n.sr,
    io_ioa_n_co                  => pad_config.io_ioa_n.co,
    io_ioa_n_odp                 => pad_config.io_ioa_n.odp,
    io_ioa_n_odn                 => pad_config.io_ioa_n.odn,
    mreset_n_ste                 => pad_config.mreset_n.ste,
    mreset_n_pd                  => pad_config.mreset_n.pd,
    mreset_n_pu                  => pad_config.mreset_n.pu,
    mrstout_n_ds                 => pad_config.mrstout_n.ds,
    mrstout_n_sr                 => pad_config.mrstout_n.sr,
    mrstout_n_co                 => pad_config.mrstout_n.co,
    mrstout_n_odp                => pad_config.mrstout_n.odp,
    mrstout_n_odn                => pad_config.mrstout_n.odn,

    write_cmd => write_data,
    enable    => register_enable,
    address   => std_ulogic_vector(address(6 downto 0)),
    data_in   => register_data_in(7 downto 0),
    data_out  => register_data_out(7 downto 0)
  );

  i_spi_interface : spi_interface
  generic map(
    data_width_g           => spi_data_width_c,
    address_width_g        => spi_address_width_c,
    start_burst_adresses_g => 16#40#,
    write_value_g          => '0'
  )
  port map(
    clk                 => sclk_int,
    nclk                => sclk_n,
    spi_rst_n           => spi_rst_n,
    cs_n                => cs_n,
    mosi                => mosi,
    miso                => miso,
    miso_oe_n           => miso_oe_n,
    write_spi           => write_data,
    enable              => register_enable,
    address             => address,
    data_in             => register_data_out,
    data_out            => register_data_in,
    update_buffer_index => update_buffer_index);
end architecture rtl;