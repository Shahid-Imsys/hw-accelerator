library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.project_settings.all;

package register_pack_spi_test is

  constant temp_version_spi_test : string := "$Revision: 0000 $";
  constant spi_test_base : integer := 16#0#;

  -- Register addresses

  constant version_address_c       : integer := 16#00#;
  constant mclkout_address_c       : integer := 16#01#;
  constant msdout_address_c        : integer := 16#02#;
  constant utx_address_c           : integer := 16#03#;
  constant mirqout_address_c       : integer := 16#04#;
  constant msdin_address_c         : integer := 16#05#;
  constant mirq0_address_c         : integer := 16#06#;
  constant mirq1_address_c         : integer := 16#07#;
  constant urx_address_c           : integer := 16#08#;
  constant emem_d0_out_address_c   : integer := 16#09#;
  constant emem_d0_in_address_c    : integer := 16#0A#;
  constant emem_d1_out_address_c   : integer := 16#0B#;
  constant emem_d1_in_address_c    : integer := 16#0C#;
  constant emem_d2_out_address_c   : integer := 16#0D#;
  constant emem_d2_in_address_c    : integer := 16#0E#;
  constant emem_d3_out_address_c   : integer := 16#0F#;
  constant emem_d3_in_address_c    : integer := 16#10#;
  constant emem_d4_out_address_c   : integer := 16#11#;
  constant emem_d4_in_address_c    : integer := 16#12#;
  constant emem_d5_out_address_c   : integer := 16#13#;
  constant emem_d5_in_address_c    : integer := 16#14#;
  constant emem_d6_out_address_c   : integer := 16#15#;
  constant emem_d6_in_address_c    : integer := 16#16#;
  constant emem_d7_out_address_c   : integer := 16#17#;
  constant emem_d7_in_address_c    : integer := 16#18#;
  constant emem_clk_address_c      : integer := 16#19#;
  constant emem_rwds_out_address_c : integer := 16#1A#;
  constant emem_rwds_in_address_c  : integer := 16#1B#;
  constant emem_cs_n_address_c     : integer := 16#1C#;
  constant emem_rst_n_address_c    : integer := 16#1D#;
  constant aout0_address_c         : integer := 16#1E#;
  constant aout1_address_c         : integer := 16#1F#;
  constant ach0_address_c          : integer := 16#20#;
  constant enet_mdio_out_address_c : integer := 16#21#;
  constant enet_mdio_in_address_c  : integer := 16#22#;
  constant enet_mdc_address_c      : integer := 16#23#;
  constant enet_txer_address_c     : integer := 16#24#;
  constant enet_txd0_address_c     : integer := 16#25#;
  constant enet_txd1_address_c     : integer := 16#26#;
  constant enet_txen_address_c     : integer := 16#27#;
  constant enet_clk_address_c      : integer := 16#28#;
  constant enet_rxdv_address_c     : integer := 16#29#;
  constant enet_rxd0_address_c     : integer := 16#2A#;
  constant enet_rxd1_address_c     : integer := 16#2B#;
  constant enet_rxer_address_c     : integer := 16#2C#;
  constant spi_sclk_address_c      : integer := 16#2D#;
  constant spi_cs_n_address_c      : integer := 16#2E#;
  constant spi_mosi_address_c      : integer := 16#2F#;
  constant spi_miso_address_c      : integer := 16#30#;
  constant pll_ref_clk_address_c   : integer := 16#31#;
  constant pa0_sin_out_address_c   : integer := 16#32#;
  constant pa0_sin_in_address_c    : integer := 16#33#;
  constant pa5_cs_n_out_address_c  : integer := 16#34#;
  constant pa5_cs_n_in_address_c   : integer := 16#35#;
  constant pa6_sck_out_address_c   : integer := 16#36#;
  constant pa6_sck_in_address_c    : integer := 16#37#;
  constant pa7_sout_out_address_c  : integer := 16#38#;
  constant pa7_sout_in_address_c   : integer := 16#39#;
  constant pg0_out_address_c       : integer := 16#3A#;
  constant pg0_in_address_c        : integer := 16#3B#;
  constant pg1_out_address_c       : integer := 16#3C#;
  constant pg1_in_address_c        : integer := 16#3D#;
  constant pg2_out_address_c       : integer := 16#3E#;
  constant pg2_in_address_c        : integer := 16#3F#;
  constant pg3_out_address_c       : integer := 16#40#;
  constant pg3_in_address_c        : integer := 16#41#;
  constant pg4_out_address_c       : integer := 16#42#;
  constant pg4_in_address_c        : integer := 16#43#;
  constant pg5_out_address_c       : integer := 16#44#;
  constant pg5_in_address_c        : integer := 16#45#;
  constant pg6_out_address_c       : integer := 16#46#;
  constant pg6_in_address_c        : integer := 16#47#;
  constant pg7_out_address_c       : integer := 16#48#;
  constant pg7_in_address_c        : integer := 16#49#;
  constant mtest_address_c         : integer := 16#4A#;
  constant mwake_address_c         : integer := 16#4B#;
  constant mrxout_address_c        : integer := 16#4C#;

  -- Register and field constants

  ---------------------------------------------------------------------------
  -- Register "version"
  constant version_reset_c : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  -- Field "analog"
  constant version_analog_size_c  : integer := 4;
  constant version_analog_lsb_c   : integer := 4;
  constant version_analog_msb_c   : integer := 7;
  subtype version_analog_t is std_ulogic_vector(version_analog_size_c - 1 downto 0);
  constant version_analog_reset_c : version_analog_t := std_ulogic_vector(to_unsigned(0, version_analog_t'length));
  constant version_analog_scan_c  : version_analog_t := std_ulogic_vector(to_unsigned(0, version_analog_t'length));

  -- Field "digital"
  constant version_digital_size_c  : integer := 4;
  constant version_digital_lsb_c   : integer := 0;
  constant version_digital_msb_c   : integer := 3;
  subtype version_digital_t is std_ulogic_vector(version_digital_size_c - 1 downto 0);
  constant version_digital_reset_c : version_digital_t := std_ulogic_vector(to_unsigned(1, version_digital_t'length));
  constant version_digital_scan_c  : version_digital_t := std_ulogic_vector(to_unsigned(1, version_digital_t'length));

  ---------------------------------------------------------------------------
  -- Register "mclkout"
  constant mclkout_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant mclkout_ds_size_c  : integer := 2;
  constant mclkout_ds_lsb_c   : integer := 4;
  constant mclkout_ds_msb_c   : integer := 5;
  subtype mclkout_ds_t is std_ulogic_vector(mclkout_ds_size_c - 1 downto 0);
  constant mclkout_ds_reset_c : mclkout_ds_t := std_ulogic_vector(to_unsigned(2, mclkout_ds_t'length));
  constant mclkout_ds_scan_c  : mclkout_ds_t := std_ulogic_vector(to_unsigned(2, mclkout_ds_t'length));

  -- Field "sr"
  constant mclkout_sr_size_c  : integer := 1;
  constant mclkout_sr_lsb_c   : integer := 3;
  constant mclkout_sr_msb_c   : integer := 3;
  subtype mclkout_sr_t is std_ulogic;
  constant mclkout_sr_reset_c : mclkout_sr_t := '1';
  constant mclkout_sr_scan_c  : mclkout_sr_t := '1';

  -- Field "co"
  constant mclkout_co_size_c  : integer := 1;
  constant mclkout_co_lsb_c   : integer := 2;
  constant mclkout_co_msb_c   : integer := 2;
  subtype mclkout_co_t is std_ulogic;
  constant mclkout_co_reset_c : mclkout_co_t := '0';
  constant mclkout_co_scan_c  : mclkout_co_t := '0';

  -- Field "odp"
  constant mclkout_odp_size_c  : integer := 1;
  constant mclkout_odp_lsb_c   : integer := 1;
  constant mclkout_odp_msb_c   : integer := 1;
  subtype mclkout_odp_t is std_ulogic;
  constant mclkout_odp_reset_c : mclkout_odp_t := '0';
  constant mclkout_odp_scan_c  : mclkout_odp_t := '0';

  -- Field "odn"
  constant mclkout_odn_size_c  : integer := 1;
  constant mclkout_odn_lsb_c   : integer := 0;
  constant mclkout_odn_msb_c   : integer := 0;
  subtype mclkout_odn_t is std_ulogic;
  constant mclkout_odn_reset_c : mclkout_odn_t := '0';
  constant mclkout_odn_scan_c  : mclkout_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "msdout"
  constant msdout_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant msdout_ds_size_c  : integer := 2;
  constant msdout_ds_lsb_c   : integer := 4;
  constant msdout_ds_msb_c   : integer := 5;
  subtype msdout_ds_t is std_ulogic_vector(msdout_ds_size_c - 1 downto 0);
  constant msdout_ds_reset_c : msdout_ds_t := std_ulogic_vector(to_unsigned(2, msdout_ds_t'length));
  constant msdout_ds_scan_c  : msdout_ds_t := std_ulogic_vector(to_unsigned(2, msdout_ds_t'length));

  -- Field "sr"
  constant msdout_sr_size_c  : integer := 1;
  constant msdout_sr_lsb_c   : integer := 3;
  constant msdout_sr_msb_c   : integer := 3;
  subtype msdout_sr_t is std_ulogic;
  constant msdout_sr_reset_c : msdout_sr_t := '1';
  constant msdout_sr_scan_c  : msdout_sr_t := '1';

  -- Field "co"
  constant msdout_co_size_c  : integer := 1;
  constant msdout_co_lsb_c   : integer := 2;
  constant msdout_co_msb_c   : integer := 2;
  subtype msdout_co_t is std_ulogic;
  constant msdout_co_reset_c : msdout_co_t := '0';
  constant msdout_co_scan_c  : msdout_co_t := '0';

  -- Field "odp"
  constant msdout_odp_size_c  : integer := 1;
  constant msdout_odp_lsb_c   : integer := 1;
  constant msdout_odp_msb_c   : integer := 1;
  subtype msdout_odp_t is std_ulogic;
  constant msdout_odp_reset_c : msdout_odp_t := '0';
  constant msdout_odp_scan_c  : msdout_odp_t := '0';

  -- Field "odn"
  constant msdout_odn_size_c  : integer := 1;
  constant msdout_odn_lsb_c   : integer := 0;
  constant msdout_odn_msb_c   : integer := 0;
  subtype msdout_odn_t is std_ulogic;
  constant msdout_odn_reset_c : msdout_odn_t := '0';
  constant msdout_odn_scan_c  : msdout_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "utx"
  constant utx_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant utx_ds_size_c  : integer := 2;
  constant utx_ds_lsb_c   : integer := 4;
  constant utx_ds_msb_c   : integer := 5;
  subtype utx_ds_t is std_ulogic_vector(utx_ds_size_c - 1 downto 0);
  constant utx_ds_reset_c : utx_ds_t := std_ulogic_vector(to_unsigned(2, utx_ds_t'length));
  constant utx_ds_scan_c  : utx_ds_t := std_ulogic_vector(to_unsigned(2, utx_ds_t'length));

  -- Field "sr"
  constant utx_sr_size_c  : integer := 1;
  constant utx_sr_lsb_c   : integer := 3;
  constant utx_sr_msb_c   : integer := 3;
  subtype utx_sr_t is std_ulogic;
  constant utx_sr_reset_c : utx_sr_t := '1';
  constant utx_sr_scan_c  : utx_sr_t := '1';

  -- Field "co"
  constant utx_co_size_c  : integer := 1;
  constant utx_co_lsb_c   : integer := 2;
  constant utx_co_msb_c   : integer := 2;
  subtype utx_co_t is std_ulogic;
  constant utx_co_reset_c : utx_co_t := '0';
  constant utx_co_scan_c  : utx_co_t := '0';

  -- Field "odp"
  constant utx_odp_size_c  : integer := 1;
  constant utx_odp_lsb_c   : integer := 1;
  constant utx_odp_msb_c   : integer := 1;
  subtype utx_odp_t is std_ulogic;
  constant utx_odp_reset_c : utx_odp_t := '0';
  constant utx_odp_scan_c  : utx_odp_t := '0';

  -- Field "odn"
  constant utx_odn_size_c  : integer := 1;
  constant utx_odn_lsb_c   : integer := 0;
  constant utx_odn_msb_c   : integer := 0;
  subtype utx_odn_t is std_ulogic;
  constant utx_odn_reset_c : utx_odn_t := '0';
  constant utx_odn_scan_c  : utx_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mirqout"
  constant mirqout_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant mirqout_ds_size_c  : integer := 2;
  constant mirqout_ds_lsb_c   : integer := 4;
  constant mirqout_ds_msb_c   : integer := 5;
  subtype mirqout_ds_t is std_ulogic_vector(mirqout_ds_size_c - 1 downto 0);
  constant mirqout_ds_reset_c : mirqout_ds_t := std_ulogic_vector(to_unsigned(2, mirqout_ds_t'length));
  constant mirqout_ds_scan_c  : mirqout_ds_t := std_ulogic_vector(to_unsigned(2, mirqout_ds_t'length));

  -- Field "sr"
  constant mirqout_sr_size_c  : integer := 1;
  constant mirqout_sr_lsb_c   : integer := 3;
  constant mirqout_sr_msb_c   : integer := 3;
  subtype mirqout_sr_t is std_ulogic;
  constant mirqout_sr_reset_c : mirqout_sr_t := '1';
  constant mirqout_sr_scan_c  : mirqout_sr_t := '1';

  -- Field "co"
  constant mirqout_co_size_c  : integer := 1;
  constant mirqout_co_lsb_c   : integer := 2;
  constant mirqout_co_msb_c   : integer := 2;
  subtype mirqout_co_t is std_ulogic;
  constant mirqout_co_reset_c : mirqout_co_t := '0';
  constant mirqout_co_scan_c  : mirqout_co_t := '0';

  -- Field "odp"
  constant mirqout_odp_size_c  : integer := 1;
  constant mirqout_odp_lsb_c   : integer := 1;
  constant mirqout_odp_msb_c   : integer := 1;
  subtype mirqout_odp_t is std_ulogic;
  constant mirqout_odp_reset_c : mirqout_odp_t := '0';
  constant mirqout_odp_scan_c  : mirqout_odp_t := '0';

  -- Field "odn"
  constant mirqout_odn_size_c  : integer := 1;
  constant mirqout_odn_lsb_c   : integer := 0;
  constant mirqout_odn_msb_c   : integer := 0;
  subtype mirqout_odn_t is std_ulogic;
  constant mirqout_odn_reset_c : mirqout_odn_t := '0';
  constant mirqout_odn_scan_c  : mirqout_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "msdin"
  constant msdin_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant msdin_ste_size_c  : integer := 2;
  constant msdin_ste_lsb_c   : integer := 2;
  constant msdin_ste_msb_c   : integer := 3;
  subtype msdin_ste_t is std_ulogic_vector(msdin_ste_size_c - 1 downto 0);
  constant msdin_ste_reset_c : msdin_ste_t := std_ulogic_vector(to_unsigned(0, msdin_ste_t'length));
  constant msdin_ste_scan_c  : msdin_ste_t := std_ulogic_vector(to_unsigned(0, msdin_ste_t'length));

  -- Field "pd"
  constant msdin_pd_size_c  : integer := 1;
  constant msdin_pd_lsb_c   : integer := 1;
  constant msdin_pd_msb_c   : integer := 1;
  subtype msdin_pd_t is std_ulogic;
  constant msdin_pd_reset_c : msdin_pd_t := '0';
  constant msdin_pd_scan_c  : msdin_pd_t := '0';

  -- Field "pu"
  constant msdin_pu_size_c  : integer := 1;
  constant msdin_pu_lsb_c   : integer := 0;
  constant msdin_pu_msb_c   : integer := 0;
  subtype msdin_pu_t is std_ulogic;
  constant msdin_pu_reset_c : msdin_pu_t := '0';
  constant msdin_pu_scan_c  : msdin_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mirq0"
  constant mirq0_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant mirq0_ste_size_c  : integer := 2;
  constant mirq0_ste_lsb_c   : integer := 2;
  constant mirq0_ste_msb_c   : integer := 3;
  subtype mirq0_ste_t is std_ulogic_vector(mirq0_ste_size_c - 1 downto 0);
  constant mirq0_ste_reset_c : mirq0_ste_t := std_ulogic_vector(to_unsigned(0, mirq0_ste_t'length));
  constant mirq0_ste_scan_c  : mirq0_ste_t := std_ulogic_vector(to_unsigned(0, mirq0_ste_t'length));

  -- Field "pd"
  constant mirq0_pd_size_c  : integer := 1;
  constant mirq0_pd_lsb_c   : integer := 1;
  constant mirq0_pd_msb_c   : integer := 1;
  subtype mirq0_pd_t is std_ulogic;
  constant mirq0_pd_reset_c : mirq0_pd_t := '0';
  constant mirq0_pd_scan_c  : mirq0_pd_t := '0';

  -- Field "pu"
  constant mirq0_pu_size_c  : integer := 1;
  constant mirq0_pu_lsb_c   : integer := 0;
  constant mirq0_pu_msb_c   : integer := 0;
  subtype mirq0_pu_t is std_ulogic;
  constant mirq0_pu_reset_c : mirq0_pu_t := '0';
  constant mirq0_pu_scan_c  : mirq0_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mirq1"
  constant mirq1_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant mirq1_ste_size_c  : integer := 2;
  constant mirq1_ste_lsb_c   : integer := 2;
  constant mirq1_ste_msb_c   : integer := 3;
  subtype mirq1_ste_t is std_ulogic_vector(mirq1_ste_size_c - 1 downto 0);
  constant mirq1_ste_reset_c : mirq1_ste_t := std_ulogic_vector(to_unsigned(0, mirq1_ste_t'length));
  constant mirq1_ste_scan_c  : mirq1_ste_t := std_ulogic_vector(to_unsigned(0, mirq1_ste_t'length));

  -- Field "pd"
  constant mirq1_pd_size_c  : integer := 1;
  constant mirq1_pd_lsb_c   : integer := 1;
  constant mirq1_pd_msb_c   : integer := 1;
  subtype mirq1_pd_t is std_ulogic;
  constant mirq1_pd_reset_c : mirq1_pd_t := '0';
  constant mirq1_pd_scan_c  : mirq1_pd_t := '0';

  -- Field "pu"
  constant mirq1_pu_size_c  : integer := 1;
  constant mirq1_pu_lsb_c   : integer := 0;
  constant mirq1_pu_msb_c   : integer := 0;
  subtype mirq1_pu_t is std_ulogic;
  constant mirq1_pu_reset_c : mirq1_pu_t := '0';
  constant mirq1_pu_scan_c  : mirq1_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "urx"
  constant urx_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant urx_ste_size_c  : integer := 2;
  constant urx_ste_lsb_c   : integer := 2;
  constant urx_ste_msb_c   : integer := 3;
  subtype urx_ste_t is std_ulogic_vector(urx_ste_size_c - 1 downto 0);
  constant urx_ste_reset_c : urx_ste_t := std_ulogic_vector(to_unsigned(0, urx_ste_t'length));
  constant urx_ste_scan_c  : urx_ste_t := std_ulogic_vector(to_unsigned(0, urx_ste_t'length));

  -- Field "pd"
  constant urx_pd_size_c  : integer := 1;
  constant urx_pd_lsb_c   : integer := 1;
  constant urx_pd_msb_c   : integer := 1;
  subtype urx_pd_t is std_ulogic;
  constant urx_pd_reset_c : urx_pd_t := '0';
  constant urx_pd_scan_c  : urx_pd_t := '0';

  -- Field "pu"
  constant urx_pu_size_c  : integer := 1;
  constant urx_pu_lsb_c   : integer := 0;
  constant urx_pu_msb_c   : integer := 0;
  subtype urx_pu_t is std_ulogic;
  constant urx_pu_reset_c : urx_pu_t := '0';
  constant urx_pu_scan_c  : urx_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d0_out"
  constant emem_d0_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d0_out_ds_size_c  : integer := 2;
  constant emem_d0_out_ds_lsb_c   : integer := 4;
  constant emem_d0_out_ds_msb_c   : integer := 5;
  subtype emem_d0_out_ds_t is std_ulogic_vector(emem_d0_out_ds_size_c - 1 downto 0);
  constant emem_d0_out_ds_reset_c : emem_d0_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d0_out_ds_t'length));
  constant emem_d0_out_ds_scan_c  : emem_d0_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d0_out_ds_t'length));

  -- Field "sr"
  constant emem_d0_out_sr_size_c  : integer := 1;
  constant emem_d0_out_sr_lsb_c   : integer := 3;
  constant emem_d0_out_sr_msb_c   : integer := 3;
  subtype emem_d0_out_sr_t is std_ulogic;
  constant emem_d0_out_sr_reset_c : emem_d0_out_sr_t := '1';
  constant emem_d0_out_sr_scan_c  : emem_d0_out_sr_t := '1';

  -- Field "co"
  constant emem_d0_out_co_size_c  : integer := 1;
  constant emem_d0_out_co_lsb_c   : integer := 2;
  constant emem_d0_out_co_msb_c   : integer := 2;
  subtype emem_d0_out_co_t is std_ulogic;
  constant emem_d0_out_co_reset_c : emem_d0_out_co_t := '0';
  constant emem_d0_out_co_scan_c  : emem_d0_out_co_t := '0';

  -- Field "odp"
  constant emem_d0_out_odp_size_c  : integer := 1;
  constant emem_d0_out_odp_lsb_c   : integer := 1;
  constant emem_d0_out_odp_msb_c   : integer := 1;
  subtype emem_d0_out_odp_t is std_ulogic;
  constant emem_d0_out_odp_reset_c : emem_d0_out_odp_t := '0';
  constant emem_d0_out_odp_scan_c  : emem_d0_out_odp_t := '0';

  -- Field "odn"
  constant emem_d0_out_odn_size_c  : integer := 1;
  constant emem_d0_out_odn_lsb_c   : integer := 0;
  constant emem_d0_out_odn_msb_c   : integer := 0;
  subtype emem_d0_out_odn_t is std_ulogic;
  constant emem_d0_out_odn_reset_c : emem_d0_out_odn_t := '0';
  constant emem_d0_out_odn_scan_c  : emem_d0_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d0_in"
  constant emem_d0_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d0_in_ste_size_c  : integer := 2;
  constant emem_d0_in_ste_lsb_c   : integer := 2;
  constant emem_d0_in_ste_msb_c   : integer := 3;
  subtype emem_d0_in_ste_t is std_ulogic_vector(emem_d0_in_ste_size_c - 1 downto 0);
  constant emem_d0_in_ste_reset_c : emem_d0_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d0_in_ste_t'length));
  constant emem_d0_in_ste_scan_c  : emem_d0_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d0_in_ste_t'length));

  -- Field "pd"
  constant emem_d0_in_pd_size_c  : integer := 1;
  constant emem_d0_in_pd_lsb_c   : integer := 1;
  constant emem_d0_in_pd_msb_c   : integer := 1;
  subtype emem_d0_in_pd_t is std_ulogic;
  constant emem_d0_in_pd_reset_c : emem_d0_in_pd_t := '0';
  constant emem_d0_in_pd_scan_c  : emem_d0_in_pd_t := '0';

  -- Field "pu"
  constant emem_d0_in_pu_size_c  : integer := 1;
  constant emem_d0_in_pu_lsb_c   : integer := 0;
  constant emem_d0_in_pu_msb_c   : integer := 0;
  subtype emem_d0_in_pu_t is std_ulogic;
  constant emem_d0_in_pu_reset_c : emem_d0_in_pu_t := '0';
  constant emem_d0_in_pu_scan_c  : emem_d0_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d1_out"
  constant emem_d1_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d1_out_ds_size_c  : integer := 2;
  constant emem_d1_out_ds_lsb_c   : integer := 4;
  constant emem_d1_out_ds_msb_c   : integer := 5;
  subtype emem_d1_out_ds_t is std_ulogic_vector(emem_d1_out_ds_size_c - 1 downto 0);
  constant emem_d1_out_ds_reset_c : emem_d1_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d1_out_ds_t'length));
  constant emem_d1_out_ds_scan_c  : emem_d1_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d1_out_ds_t'length));

  -- Field "sr"
  constant emem_d1_out_sr_size_c  : integer := 1;
  constant emem_d1_out_sr_lsb_c   : integer := 3;
  constant emem_d1_out_sr_msb_c   : integer := 3;
  subtype emem_d1_out_sr_t is std_ulogic;
  constant emem_d1_out_sr_reset_c : emem_d1_out_sr_t := '1';
  constant emem_d1_out_sr_scan_c  : emem_d1_out_sr_t := '1';

  -- Field "co"
  constant emem_d1_out_co_size_c  : integer := 1;
  constant emem_d1_out_co_lsb_c   : integer := 2;
  constant emem_d1_out_co_msb_c   : integer := 2;
  subtype emem_d1_out_co_t is std_ulogic;
  constant emem_d1_out_co_reset_c : emem_d1_out_co_t := '0';
  constant emem_d1_out_co_scan_c  : emem_d1_out_co_t := '0';

  -- Field "odp"
  constant emem_d1_out_odp_size_c  : integer := 1;
  constant emem_d1_out_odp_lsb_c   : integer := 1;
  constant emem_d1_out_odp_msb_c   : integer := 1;
  subtype emem_d1_out_odp_t is std_ulogic;
  constant emem_d1_out_odp_reset_c : emem_d1_out_odp_t := '0';
  constant emem_d1_out_odp_scan_c  : emem_d1_out_odp_t := '0';

  -- Field "odn"
  constant emem_d1_out_odn_size_c  : integer := 1;
  constant emem_d1_out_odn_lsb_c   : integer := 0;
  constant emem_d1_out_odn_msb_c   : integer := 0;
  subtype emem_d1_out_odn_t is std_ulogic;
  constant emem_d1_out_odn_reset_c : emem_d1_out_odn_t := '0';
  constant emem_d1_out_odn_scan_c  : emem_d1_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d1_in"
  constant emem_d1_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d1_in_ste_size_c  : integer := 2;
  constant emem_d1_in_ste_lsb_c   : integer := 2;
  constant emem_d1_in_ste_msb_c   : integer := 3;
  subtype emem_d1_in_ste_t is std_ulogic_vector(emem_d1_in_ste_size_c - 1 downto 0);
  constant emem_d1_in_ste_reset_c : emem_d1_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d1_in_ste_t'length));
  constant emem_d1_in_ste_scan_c  : emem_d1_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d1_in_ste_t'length));

  -- Field "pd"
  constant emem_d1_in_pd_size_c  : integer := 1;
  constant emem_d1_in_pd_lsb_c   : integer := 1;
  constant emem_d1_in_pd_msb_c   : integer := 1;
  subtype emem_d1_in_pd_t is std_ulogic;
  constant emem_d1_in_pd_reset_c : emem_d1_in_pd_t := '0';
  constant emem_d1_in_pd_scan_c  : emem_d1_in_pd_t := '0';

  -- Field "pu"
  constant emem_d1_in_pu_size_c  : integer := 1;
  constant emem_d1_in_pu_lsb_c   : integer := 0;
  constant emem_d1_in_pu_msb_c   : integer := 0;
  subtype emem_d1_in_pu_t is std_ulogic;
  constant emem_d1_in_pu_reset_c : emem_d1_in_pu_t := '0';
  constant emem_d1_in_pu_scan_c  : emem_d1_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d2_out"
  constant emem_d2_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d2_out_ds_size_c  : integer := 2;
  constant emem_d2_out_ds_lsb_c   : integer := 4;
  constant emem_d2_out_ds_msb_c   : integer := 5;
  subtype emem_d2_out_ds_t is std_ulogic_vector(emem_d2_out_ds_size_c - 1 downto 0);
  constant emem_d2_out_ds_reset_c : emem_d2_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d2_out_ds_t'length));
  constant emem_d2_out_ds_scan_c  : emem_d2_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d2_out_ds_t'length));

  -- Field "sr"
  constant emem_d2_out_sr_size_c  : integer := 1;
  constant emem_d2_out_sr_lsb_c   : integer := 3;
  constant emem_d2_out_sr_msb_c   : integer := 3;
  subtype emem_d2_out_sr_t is std_ulogic;
  constant emem_d2_out_sr_reset_c : emem_d2_out_sr_t := '1';
  constant emem_d2_out_sr_scan_c  : emem_d2_out_sr_t := '1';

  -- Field "co"
  constant emem_d2_out_co_size_c  : integer := 1;
  constant emem_d2_out_co_lsb_c   : integer := 2;
  constant emem_d2_out_co_msb_c   : integer := 2;
  subtype emem_d2_out_co_t is std_ulogic;
  constant emem_d2_out_co_reset_c : emem_d2_out_co_t := '0';
  constant emem_d2_out_co_scan_c  : emem_d2_out_co_t := '0';

  -- Field "odp"
  constant emem_d2_out_odp_size_c  : integer := 1;
  constant emem_d2_out_odp_lsb_c   : integer := 1;
  constant emem_d2_out_odp_msb_c   : integer := 1;
  subtype emem_d2_out_odp_t is std_ulogic;
  constant emem_d2_out_odp_reset_c : emem_d2_out_odp_t := '0';
  constant emem_d2_out_odp_scan_c  : emem_d2_out_odp_t := '0';

  -- Field "odn"
  constant emem_d2_out_odn_size_c  : integer := 1;
  constant emem_d2_out_odn_lsb_c   : integer := 0;
  constant emem_d2_out_odn_msb_c   : integer := 0;
  subtype emem_d2_out_odn_t is std_ulogic;
  constant emem_d2_out_odn_reset_c : emem_d2_out_odn_t := '0';
  constant emem_d2_out_odn_scan_c  : emem_d2_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d2_in"
  constant emem_d2_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d2_in_ste_size_c  : integer := 2;
  constant emem_d2_in_ste_lsb_c   : integer := 2;
  constant emem_d2_in_ste_msb_c   : integer := 3;
  subtype emem_d2_in_ste_t is std_ulogic_vector(emem_d2_in_ste_size_c - 1 downto 0);
  constant emem_d2_in_ste_reset_c : emem_d2_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d2_in_ste_t'length));
  constant emem_d2_in_ste_scan_c  : emem_d2_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d2_in_ste_t'length));

  -- Field "pd"
  constant emem_d2_in_pd_size_c  : integer := 1;
  constant emem_d2_in_pd_lsb_c   : integer := 1;
  constant emem_d2_in_pd_msb_c   : integer := 1;
  subtype emem_d2_in_pd_t is std_ulogic;
  constant emem_d2_in_pd_reset_c : emem_d2_in_pd_t := '0';
  constant emem_d2_in_pd_scan_c  : emem_d2_in_pd_t := '0';

  -- Field "pu"
  constant emem_d2_in_pu_size_c  : integer := 1;
  constant emem_d2_in_pu_lsb_c   : integer := 0;
  constant emem_d2_in_pu_msb_c   : integer := 0;
  subtype emem_d2_in_pu_t is std_ulogic;
  constant emem_d2_in_pu_reset_c : emem_d2_in_pu_t := '0';
  constant emem_d2_in_pu_scan_c  : emem_d2_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d3_out"
  constant emem_d3_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d3_out_ds_size_c  : integer := 2;
  constant emem_d3_out_ds_lsb_c   : integer := 4;
  constant emem_d3_out_ds_msb_c   : integer := 5;
  subtype emem_d3_out_ds_t is std_ulogic_vector(emem_d3_out_ds_size_c - 1 downto 0);
  constant emem_d3_out_ds_reset_c : emem_d3_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d3_out_ds_t'length));
  constant emem_d3_out_ds_scan_c  : emem_d3_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d3_out_ds_t'length));

  -- Field "sr"
  constant emem_d3_out_sr_size_c  : integer := 1;
  constant emem_d3_out_sr_lsb_c   : integer := 3;
  constant emem_d3_out_sr_msb_c   : integer := 3;
  subtype emem_d3_out_sr_t is std_ulogic;
  constant emem_d3_out_sr_reset_c : emem_d3_out_sr_t := '1';
  constant emem_d3_out_sr_scan_c  : emem_d3_out_sr_t := '1';

  -- Field "co"
  constant emem_d3_out_co_size_c  : integer := 1;
  constant emem_d3_out_co_lsb_c   : integer := 2;
  constant emem_d3_out_co_msb_c   : integer := 2;
  subtype emem_d3_out_co_t is std_ulogic;
  constant emem_d3_out_co_reset_c : emem_d3_out_co_t := '0';
  constant emem_d3_out_co_scan_c  : emem_d3_out_co_t := '0';

  -- Field "odp"
  constant emem_d3_out_odp_size_c  : integer := 1;
  constant emem_d3_out_odp_lsb_c   : integer := 1;
  constant emem_d3_out_odp_msb_c   : integer := 1;
  subtype emem_d3_out_odp_t is std_ulogic;
  constant emem_d3_out_odp_reset_c : emem_d3_out_odp_t := '0';
  constant emem_d3_out_odp_scan_c  : emem_d3_out_odp_t := '0';

  -- Field "odn"
  constant emem_d3_out_odn_size_c  : integer := 1;
  constant emem_d3_out_odn_lsb_c   : integer := 0;
  constant emem_d3_out_odn_msb_c   : integer := 0;
  subtype emem_d3_out_odn_t is std_ulogic;
  constant emem_d3_out_odn_reset_c : emem_d3_out_odn_t := '0';
  constant emem_d3_out_odn_scan_c  : emem_d3_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d3_in"
  constant emem_d3_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d3_in_ste_size_c  : integer := 2;
  constant emem_d3_in_ste_lsb_c   : integer := 2;
  constant emem_d3_in_ste_msb_c   : integer := 3;
  subtype emem_d3_in_ste_t is std_ulogic_vector(emem_d3_in_ste_size_c - 1 downto 0);
  constant emem_d3_in_ste_reset_c : emem_d3_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d3_in_ste_t'length));
  constant emem_d3_in_ste_scan_c  : emem_d3_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d3_in_ste_t'length));

  -- Field "pd"
  constant emem_d3_in_pd_size_c  : integer := 1;
  constant emem_d3_in_pd_lsb_c   : integer := 1;
  constant emem_d3_in_pd_msb_c   : integer := 1;
  subtype emem_d3_in_pd_t is std_ulogic;
  constant emem_d3_in_pd_reset_c : emem_d3_in_pd_t := '0';
  constant emem_d3_in_pd_scan_c  : emem_d3_in_pd_t := '0';

  -- Field "pu"
  constant emem_d3_in_pu_size_c  : integer := 1;
  constant emem_d3_in_pu_lsb_c   : integer := 0;
  constant emem_d3_in_pu_msb_c   : integer := 0;
  subtype emem_d3_in_pu_t is std_ulogic;
  constant emem_d3_in_pu_reset_c : emem_d3_in_pu_t := '0';
  constant emem_d3_in_pu_scan_c  : emem_d3_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d4_out"
  constant emem_d4_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d4_out_ds_size_c  : integer := 2;
  constant emem_d4_out_ds_lsb_c   : integer := 4;
  constant emem_d4_out_ds_msb_c   : integer := 5;
  subtype emem_d4_out_ds_t is std_ulogic_vector(emem_d4_out_ds_size_c - 1 downto 0);
  constant emem_d4_out_ds_reset_c : emem_d4_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d4_out_ds_t'length));
  constant emem_d4_out_ds_scan_c  : emem_d4_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d4_out_ds_t'length));

  -- Field "sr"
  constant emem_d4_out_sr_size_c  : integer := 1;
  constant emem_d4_out_sr_lsb_c   : integer := 3;
  constant emem_d4_out_sr_msb_c   : integer := 3;
  subtype emem_d4_out_sr_t is std_ulogic;
  constant emem_d4_out_sr_reset_c : emem_d4_out_sr_t := '1';
  constant emem_d4_out_sr_scan_c  : emem_d4_out_sr_t := '1';

  -- Field "co"
  constant emem_d4_out_co_size_c  : integer := 1;
  constant emem_d4_out_co_lsb_c   : integer := 2;
  constant emem_d4_out_co_msb_c   : integer := 2;
  subtype emem_d4_out_co_t is std_ulogic;
  constant emem_d4_out_co_reset_c : emem_d4_out_co_t := '0';
  constant emem_d4_out_co_scan_c  : emem_d4_out_co_t := '0';

  -- Field "odp"
  constant emem_d4_out_odp_size_c  : integer := 1;
  constant emem_d4_out_odp_lsb_c   : integer := 1;
  constant emem_d4_out_odp_msb_c   : integer := 1;
  subtype emem_d4_out_odp_t is std_ulogic;
  constant emem_d4_out_odp_reset_c : emem_d4_out_odp_t := '0';
  constant emem_d4_out_odp_scan_c  : emem_d4_out_odp_t := '0';

  -- Field "odn"
  constant emem_d4_out_odn_size_c  : integer := 1;
  constant emem_d4_out_odn_lsb_c   : integer := 0;
  constant emem_d4_out_odn_msb_c   : integer := 0;
  subtype emem_d4_out_odn_t is std_ulogic;
  constant emem_d4_out_odn_reset_c : emem_d4_out_odn_t := '0';
  constant emem_d4_out_odn_scan_c  : emem_d4_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d4_in"
  constant emem_d4_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d4_in_ste_size_c  : integer := 2;
  constant emem_d4_in_ste_lsb_c   : integer := 2;
  constant emem_d4_in_ste_msb_c   : integer := 3;
  subtype emem_d4_in_ste_t is std_ulogic_vector(emem_d4_in_ste_size_c - 1 downto 0);
  constant emem_d4_in_ste_reset_c : emem_d4_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d4_in_ste_t'length));
  constant emem_d4_in_ste_scan_c  : emem_d4_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d4_in_ste_t'length));

  -- Field "pd"
  constant emem_d4_in_pd_size_c  : integer := 1;
  constant emem_d4_in_pd_lsb_c   : integer := 1;
  constant emem_d4_in_pd_msb_c   : integer := 1;
  subtype emem_d4_in_pd_t is std_ulogic;
  constant emem_d4_in_pd_reset_c : emem_d4_in_pd_t := '0';
  constant emem_d4_in_pd_scan_c  : emem_d4_in_pd_t := '0';

  -- Field "pu"
  constant emem_d4_in_pu_size_c  : integer := 1;
  constant emem_d4_in_pu_lsb_c   : integer := 0;
  constant emem_d4_in_pu_msb_c   : integer := 0;
  subtype emem_d4_in_pu_t is std_ulogic;
  constant emem_d4_in_pu_reset_c : emem_d4_in_pu_t := '0';
  constant emem_d4_in_pu_scan_c  : emem_d4_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d5_out"
  constant emem_d5_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d5_out_ds_size_c  : integer := 2;
  constant emem_d5_out_ds_lsb_c   : integer := 4;
  constant emem_d5_out_ds_msb_c   : integer := 5;
  subtype emem_d5_out_ds_t is std_ulogic_vector(emem_d5_out_ds_size_c - 1 downto 0);
  constant emem_d5_out_ds_reset_c : emem_d5_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d5_out_ds_t'length));
  constant emem_d5_out_ds_scan_c  : emem_d5_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d5_out_ds_t'length));

  -- Field "sr"
  constant emem_d5_out_sr_size_c  : integer := 1;
  constant emem_d5_out_sr_lsb_c   : integer := 3;
  constant emem_d5_out_sr_msb_c   : integer := 3;
  subtype emem_d5_out_sr_t is std_ulogic;
  constant emem_d5_out_sr_reset_c : emem_d5_out_sr_t := '1';
  constant emem_d5_out_sr_scan_c  : emem_d5_out_sr_t := '1';

  -- Field "co"
  constant emem_d5_out_co_size_c  : integer := 1;
  constant emem_d5_out_co_lsb_c   : integer := 2;
  constant emem_d5_out_co_msb_c   : integer := 2;
  subtype emem_d5_out_co_t is std_ulogic;
  constant emem_d5_out_co_reset_c : emem_d5_out_co_t := '0';
  constant emem_d5_out_co_scan_c  : emem_d5_out_co_t := '0';

  -- Field "odp"
  constant emem_d5_out_odp_size_c  : integer := 1;
  constant emem_d5_out_odp_lsb_c   : integer := 1;
  constant emem_d5_out_odp_msb_c   : integer := 1;
  subtype emem_d5_out_odp_t is std_ulogic;
  constant emem_d5_out_odp_reset_c : emem_d5_out_odp_t := '0';
  constant emem_d5_out_odp_scan_c  : emem_d5_out_odp_t := '0';

  -- Field "odn"
  constant emem_d5_out_odn_size_c  : integer := 1;
  constant emem_d5_out_odn_lsb_c   : integer := 0;
  constant emem_d5_out_odn_msb_c   : integer := 0;
  subtype emem_d5_out_odn_t is std_ulogic;
  constant emem_d5_out_odn_reset_c : emem_d5_out_odn_t := '0';
  constant emem_d5_out_odn_scan_c  : emem_d5_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d5_in"
  constant emem_d5_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d5_in_ste_size_c  : integer := 2;
  constant emem_d5_in_ste_lsb_c   : integer := 2;
  constant emem_d5_in_ste_msb_c   : integer := 3;
  subtype emem_d5_in_ste_t is std_ulogic_vector(emem_d5_in_ste_size_c - 1 downto 0);
  constant emem_d5_in_ste_reset_c : emem_d5_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d5_in_ste_t'length));
  constant emem_d5_in_ste_scan_c  : emem_d5_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d5_in_ste_t'length));

  -- Field "pd"
  constant emem_d5_in_pd_size_c  : integer := 1;
  constant emem_d5_in_pd_lsb_c   : integer := 1;
  constant emem_d5_in_pd_msb_c   : integer := 1;
  subtype emem_d5_in_pd_t is std_ulogic;
  constant emem_d5_in_pd_reset_c : emem_d5_in_pd_t := '0';
  constant emem_d5_in_pd_scan_c  : emem_d5_in_pd_t := '0';

  -- Field "pu"
  constant emem_d5_in_pu_size_c  : integer := 1;
  constant emem_d5_in_pu_lsb_c   : integer := 0;
  constant emem_d5_in_pu_msb_c   : integer := 0;
  subtype emem_d5_in_pu_t is std_ulogic;
  constant emem_d5_in_pu_reset_c : emem_d5_in_pu_t := '0';
  constant emem_d5_in_pu_scan_c  : emem_d5_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d6_out"
  constant emem_d6_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d6_out_ds_size_c  : integer := 2;
  constant emem_d6_out_ds_lsb_c   : integer := 4;
  constant emem_d6_out_ds_msb_c   : integer := 5;
  subtype emem_d6_out_ds_t is std_ulogic_vector(emem_d6_out_ds_size_c - 1 downto 0);
  constant emem_d6_out_ds_reset_c : emem_d6_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d6_out_ds_t'length));
  constant emem_d6_out_ds_scan_c  : emem_d6_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d6_out_ds_t'length));

  -- Field "sr"
  constant emem_d6_out_sr_size_c  : integer := 1;
  constant emem_d6_out_sr_lsb_c   : integer := 3;
  constant emem_d6_out_sr_msb_c   : integer := 3;
  subtype emem_d6_out_sr_t is std_ulogic;
  constant emem_d6_out_sr_reset_c : emem_d6_out_sr_t := '1';
  constant emem_d6_out_sr_scan_c  : emem_d6_out_sr_t := '1';

  -- Field "co"
  constant emem_d6_out_co_size_c  : integer := 1;
  constant emem_d6_out_co_lsb_c   : integer := 2;
  constant emem_d6_out_co_msb_c   : integer := 2;
  subtype emem_d6_out_co_t is std_ulogic;
  constant emem_d6_out_co_reset_c : emem_d6_out_co_t := '0';
  constant emem_d6_out_co_scan_c  : emem_d6_out_co_t := '0';

  -- Field "odp"
  constant emem_d6_out_odp_size_c  : integer := 1;
  constant emem_d6_out_odp_lsb_c   : integer := 1;
  constant emem_d6_out_odp_msb_c   : integer := 1;
  subtype emem_d6_out_odp_t is std_ulogic;
  constant emem_d6_out_odp_reset_c : emem_d6_out_odp_t := '0';
  constant emem_d6_out_odp_scan_c  : emem_d6_out_odp_t := '0';

  -- Field "odn"
  constant emem_d6_out_odn_size_c  : integer := 1;
  constant emem_d6_out_odn_lsb_c   : integer := 0;
  constant emem_d6_out_odn_msb_c   : integer := 0;
  subtype emem_d6_out_odn_t is std_ulogic;
  constant emem_d6_out_odn_reset_c : emem_d6_out_odn_t := '0';
  constant emem_d6_out_odn_scan_c  : emem_d6_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d6_in"
  constant emem_d6_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d6_in_ste_size_c  : integer := 2;
  constant emem_d6_in_ste_lsb_c   : integer := 2;
  constant emem_d6_in_ste_msb_c   : integer := 3;
  subtype emem_d6_in_ste_t is std_ulogic_vector(emem_d6_in_ste_size_c - 1 downto 0);
  constant emem_d6_in_ste_reset_c : emem_d6_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d6_in_ste_t'length));
  constant emem_d6_in_ste_scan_c  : emem_d6_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d6_in_ste_t'length));

  -- Field "pd"
  constant emem_d6_in_pd_size_c  : integer := 1;
  constant emem_d6_in_pd_lsb_c   : integer := 1;
  constant emem_d6_in_pd_msb_c   : integer := 1;
  subtype emem_d6_in_pd_t is std_ulogic;
  constant emem_d6_in_pd_reset_c : emem_d6_in_pd_t := '0';
  constant emem_d6_in_pd_scan_c  : emem_d6_in_pd_t := '0';

  -- Field "pu"
  constant emem_d6_in_pu_size_c  : integer := 1;
  constant emem_d6_in_pu_lsb_c   : integer := 0;
  constant emem_d6_in_pu_msb_c   : integer := 0;
  subtype emem_d6_in_pu_t is std_ulogic;
  constant emem_d6_in_pu_reset_c : emem_d6_in_pu_t := '0';
  constant emem_d6_in_pu_scan_c  : emem_d6_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d7_out"
  constant emem_d7_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_d7_out_ds_size_c  : integer := 2;
  constant emem_d7_out_ds_lsb_c   : integer := 4;
  constant emem_d7_out_ds_msb_c   : integer := 5;
  subtype emem_d7_out_ds_t is std_ulogic_vector(emem_d7_out_ds_size_c - 1 downto 0);
  constant emem_d7_out_ds_reset_c : emem_d7_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d7_out_ds_t'length));
  constant emem_d7_out_ds_scan_c  : emem_d7_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_d7_out_ds_t'length));

  -- Field "sr"
  constant emem_d7_out_sr_size_c  : integer := 1;
  constant emem_d7_out_sr_lsb_c   : integer := 3;
  constant emem_d7_out_sr_msb_c   : integer := 3;
  subtype emem_d7_out_sr_t is std_ulogic;
  constant emem_d7_out_sr_reset_c : emem_d7_out_sr_t := '1';
  constant emem_d7_out_sr_scan_c  : emem_d7_out_sr_t := '1';

  -- Field "co"
  constant emem_d7_out_co_size_c  : integer := 1;
  constant emem_d7_out_co_lsb_c   : integer := 2;
  constant emem_d7_out_co_msb_c   : integer := 2;
  subtype emem_d7_out_co_t is std_ulogic;
  constant emem_d7_out_co_reset_c : emem_d7_out_co_t := '0';
  constant emem_d7_out_co_scan_c  : emem_d7_out_co_t := '0';

  -- Field "odp"
  constant emem_d7_out_odp_size_c  : integer := 1;
  constant emem_d7_out_odp_lsb_c   : integer := 1;
  constant emem_d7_out_odp_msb_c   : integer := 1;
  subtype emem_d7_out_odp_t is std_ulogic;
  constant emem_d7_out_odp_reset_c : emem_d7_out_odp_t := '0';
  constant emem_d7_out_odp_scan_c  : emem_d7_out_odp_t := '0';

  -- Field "odn"
  constant emem_d7_out_odn_size_c  : integer := 1;
  constant emem_d7_out_odn_lsb_c   : integer := 0;
  constant emem_d7_out_odn_msb_c   : integer := 0;
  subtype emem_d7_out_odn_t is std_ulogic;
  constant emem_d7_out_odn_reset_c : emem_d7_out_odn_t := '0';
  constant emem_d7_out_odn_scan_c  : emem_d7_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_d7_in"
  constant emem_d7_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_d7_in_ste_size_c  : integer := 2;
  constant emem_d7_in_ste_lsb_c   : integer := 2;
  constant emem_d7_in_ste_msb_c   : integer := 3;
  subtype emem_d7_in_ste_t is std_ulogic_vector(emem_d7_in_ste_size_c - 1 downto 0);
  constant emem_d7_in_ste_reset_c : emem_d7_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d7_in_ste_t'length));
  constant emem_d7_in_ste_scan_c  : emem_d7_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_d7_in_ste_t'length));

  -- Field "pd"
  constant emem_d7_in_pd_size_c  : integer := 1;
  constant emem_d7_in_pd_lsb_c   : integer := 1;
  constant emem_d7_in_pd_msb_c   : integer := 1;
  subtype emem_d7_in_pd_t is std_ulogic;
  constant emem_d7_in_pd_reset_c : emem_d7_in_pd_t := '0';
  constant emem_d7_in_pd_scan_c  : emem_d7_in_pd_t := '0';

  -- Field "pu"
  constant emem_d7_in_pu_size_c  : integer := 1;
  constant emem_d7_in_pu_lsb_c   : integer := 0;
  constant emem_d7_in_pu_msb_c   : integer := 0;
  subtype emem_d7_in_pu_t is std_ulogic;
  constant emem_d7_in_pu_reset_c : emem_d7_in_pu_t := '0';
  constant emem_d7_in_pu_scan_c  : emem_d7_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_clk"
  constant emem_clk_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_clk_ds_size_c  : integer := 2;
  constant emem_clk_ds_lsb_c   : integer := 4;
  constant emem_clk_ds_msb_c   : integer := 5;
  subtype emem_clk_ds_t is std_ulogic_vector(emem_clk_ds_size_c - 1 downto 0);
  constant emem_clk_ds_reset_c : emem_clk_ds_t := std_ulogic_vector(to_unsigned(2, emem_clk_ds_t'length));
  constant emem_clk_ds_scan_c  : emem_clk_ds_t := std_ulogic_vector(to_unsigned(2, emem_clk_ds_t'length));

  -- Field "sr"
  constant emem_clk_sr_size_c  : integer := 1;
  constant emem_clk_sr_lsb_c   : integer := 3;
  constant emem_clk_sr_msb_c   : integer := 3;
  subtype emem_clk_sr_t is std_ulogic;
  constant emem_clk_sr_reset_c : emem_clk_sr_t := '1';
  constant emem_clk_sr_scan_c  : emem_clk_sr_t := '1';

  -- Field "co"
  constant emem_clk_co_size_c  : integer := 1;
  constant emem_clk_co_lsb_c   : integer := 2;
  constant emem_clk_co_msb_c   : integer := 2;
  subtype emem_clk_co_t is std_ulogic;
  constant emem_clk_co_reset_c : emem_clk_co_t := '0';
  constant emem_clk_co_scan_c  : emem_clk_co_t := '0';

  -- Field "odp"
  constant emem_clk_odp_size_c  : integer := 1;
  constant emem_clk_odp_lsb_c   : integer := 1;
  constant emem_clk_odp_msb_c   : integer := 1;
  subtype emem_clk_odp_t is std_ulogic;
  constant emem_clk_odp_reset_c : emem_clk_odp_t := '0';
  constant emem_clk_odp_scan_c  : emem_clk_odp_t := '0';

  -- Field "odn"
  constant emem_clk_odn_size_c  : integer := 1;
  constant emem_clk_odn_lsb_c   : integer := 0;
  constant emem_clk_odn_msb_c   : integer := 0;
  subtype emem_clk_odn_t is std_ulogic;
  constant emem_clk_odn_reset_c : emem_clk_odn_t := '0';
  constant emem_clk_odn_scan_c  : emem_clk_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_rwds_out"
  constant emem_rwds_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_rwds_out_ds_size_c  : integer := 2;
  constant emem_rwds_out_ds_lsb_c   : integer := 4;
  constant emem_rwds_out_ds_msb_c   : integer := 5;
  subtype emem_rwds_out_ds_t is std_ulogic_vector(emem_rwds_out_ds_size_c - 1 downto 0);
  constant emem_rwds_out_ds_reset_c : emem_rwds_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_rwds_out_ds_t'length));
  constant emem_rwds_out_ds_scan_c  : emem_rwds_out_ds_t := std_ulogic_vector(to_unsigned(2, emem_rwds_out_ds_t'length));

  -- Field "sr"
  constant emem_rwds_out_sr_size_c  : integer := 1;
  constant emem_rwds_out_sr_lsb_c   : integer := 3;
  constant emem_rwds_out_sr_msb_c   : integer := 3;
  subtype emem_rwds_out_sr_t is std_ulogic;
  constant emem_rwds_out_sr_reset_c : emem_rwds_out_sr_t := '1';
  constant emem_rwds_out_sr_scan_c  : emem_rwds_out_sr_t := '1';

  -- Field "co"
  constant emem_rwds_out_co_size_c  : integer := 1;
  constant emem_rwds_out_co_lsb_c   : integer := 2;
  constant emem_rwds_out_co_msb_c   : integer := 2;
  subtype emem_rwds_out_co_t is std_ulogic;
  constant emem_rwds_out_co_reset_c : emem_rwds_out_co_t := '0';
  constant emem_rwds_out_co_scan_c  : emem_rwds_out_co_t := '0';

  -- Field "odp"
  constant emem_rwds_out_odp_size_c  : integer := 1;
  constant emem_rwds_out_odp_lsb_c   : integer := 1;
  constant emem_rwds_out_odp_msb_c   : integer := 1;
  subtype emem_rwds_out_odp_t is std_ulogic;
  constant emem_rwds_out_odp_reset_c : emem_rwds_out_odp_t := '0';
  constant emem_rwds_out_odp_scan_c  : emem_rwds_out_odp_t := '0';

  -- Field "odn"
  constant emem_rwds_out_odn_size_c  : integer := 1;
  constant emem_rwds_out_odn_lsb_c   : integer := 0;
  constant emem_rwds_out_odn_msb_c   : integer := 0;
  subtype emem_rwds_out_odn_t is std_ulogic;
  constant emem_rwds_out_odn_reset_c : emem_rwds_out_odn_t := '0';
  constant emem_rwds_out_odn_scan_c  : emem_rwds_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_rwds_in"
  constant emem_rwds_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant emem_rwds_in_ste_size_c  : integer := 2;
  constant emem_rwds_in_ste_lsb_c   : integer := 2;
  constant emem_rwds_in_ste_msb_c   : integer := 3;
  subtype emem_rwds_in_ste_t is std_ulogic_vector(emem_rwds_in_ste_size_c - 1 downto 0);
  constant emem_rwds_in_ste_reset_c : emem_rwds_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_rwds_in_ste_t'length));
  constant emem_rwds_in_ste_scan_c  : emem_rwds_in_ste_t := std_ulogic_vector(to_unsigned(0, emem_rwds_in_ste_t'length));

  -- Field "pd"
  constant emem_rwds_in_pd_size_c  : integer := 1;
  constant emem_rwds_in_pd_lsb_c   : integer := 1;
  constant emem_rwds_in_pd_msb_c   : integer := 1;
  subtype emem_rwds_in_pd_t is std_ulogic;
  constant emem_rwds_in_pd_reset_c : emem_rwds_in_pd_t := '0';
  constant emem_rwds_in_pd_scan_c  : emem_rwds_in_pd_t := '0';

  -- Field "pu"
  constant emem_rwds_in_pu_size_c  : integer := 1;
  constant emem_rwds_in_pu_lsb_c   : integer := 0;
  constant emem_rwds_in_pu_msb_c   : integer := 0;
  subtype emem_rwds_in_pu_t is std_ulogic;
  constant emem_rwds_in_pu_reset_c : emem_rwds_in_pu_t := '0';
  constant emem_rwds_in_pu_scan_c  : emem_rwds_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_cs_n"
  constant emem_cs_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_cs_n_ds_size_c  : integer := 2;
  constant emem_cs_n_ds_lsb_c   : integer := 4;
  constant emem_cs_n_ds_msb_c   : integer := 5;
  subtype emem_cs_n_ds_t is std_ulogic_vector(emem_cs_n_ds_size_c - 1 downto 0);
  constant emem_cs_n_ds_reset_c : emem_cs_n_ds_t := std_ulogic_vector(to_unsigned(2, emem_cs_n_ds_t'length));
  constant emem_cs_n_ds_scan_c  : emem_cs_n_ds_t := std_ulogic_vector(to_unsigned(2, emem_cs_n_ds_t'length));

  -- Field "sr"
  constant emem_cs_n_sr_size_c  : integer := 1;
  constant emem_cs_n_sr_lsb_c   : integer := 3;
  constant emem_cs_n_sr_msb_c   : integer := 3;
  subtype emem_cs_n_sr_t is std_ulogic;
  constant emem_cs_n_sr_reset_c : emem_cs_n_sr_t := '1';
  constant emem_cs_n_sr_scan_c  : emem_cs_n_sr_t := '1';

  -- Field "co"
  constant emem_cs_n_co_size_c  : integer := 1;
  constant emem_cs_n_co_lsb_c   : integer := 2;
  constant emem_cs_n_co_msb_c   : integer := 2;
  subtype emem_cs_n_co_t is std_ulogic;
  constant emem_cs_n_co_reset_c : emem_cs_n_co_t := '0';
  constant emem_cs_n_co_scan_c  : emem_cs_n_co_t := '0';

  -- Field "odp"
  constant emem_cs_n_odp_size_c  : integer := 1;
  constant emem_cs_n_odp_lsb_c   : integer := 1;
  constant emem_cs_n_odp_msb_c   : integer := 1;
  subtype emem_cs_n_odp_t is std_ulogic;
  constant emem_cs_n_odp_reset_c : emem_cs_n_odp_t := '0';
  constant emem_cs_n_odp_scan_c  : emem_cs_n_odp_t := '0';

  -- Field "odn"
  constant emem_cs_n_odn_size_c  : integer := 1;
  constant emem_cs_n_odn_lsb_c   : integer := 0;
  constant emem_cs_n_odn_msb_c   : integer := 0;
  subtype emem_cs_n_odn_t is std_ulogic;
  constant emem_cs_n_odn_reset_c : emem_cs_n_odn_t := '0';
  constant emem_cs_n_odn_scan_c  : emem_cs_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "emem_rst_n"
  constant emem_rst_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant emem_rst_n_ds_size_c  : integer := 2;
  constant emem_rst_n_ds_lsb_c   : integer := 4;
  constant emem_rst_n_ds_msb_c   : integer := 5;
  subtype emem_rst_n_ds_t is std_ulogic_vector(emem_rst_n_ds_size_c - 1 downto 0);
  constant emem_rst_n_ds_reset_c : emem_rst_n_ds_t := std_ulogic_vector(to_unsigned(2, emem_rst_n_ds_t'length));
  constant emem_rst_n_ds_scan_c  : emem_rst_n_ds_t := std_ulogic_vector(to_unsigned(2, emem_rst_n_ds_t'length));

  -- Field "sr"
  constant emem_rst_n_sr_size_c  : integer := 1;
  constant emem_rst_n_sr_lsb_c   : integer := 3;
  constant emem_rst_n_sr_msb_c   : integer := 3;
  subtype emem_rst_n_sr_t is std_ulogic;
  constant emem_rst_n_sr_reset_c : emem_rst_n_sr_t := '1';
  constant emem_rst_n_sr_scan_c  : emem_rst_n_sr_t := '1';

  -- Field "co"
  constant emem_rst_n_co_size_c  : integer := 1;
  constant emem_rst_n_co_lsb_c   : integer := 2;
  constant emem_rst_n_co_msb_c   : integer := 2;
  subtype emem_rst_n_co_t is std_ulogic;
  constant emem_rst_n_co_reset_c : emem_rst_n_co_t := '0';
  constant emem_rst_n_co_scan_c  : emem_rst_n_co_t := '0';

  -- Field "odp"
  constant emem_rst_n_odp_size_c  : integer := 1;
  constant emem_rst_n_odp_lsb_c   : integer := 1;
  constant emem_rst_n_odp_msb_c   : integer := 1;
  subtype emem_rst_n_odp_t is std_ulogic;
  constant emem_rst_n_odp_reset_c : emem_rst_n_odp_t := '0';
  constant emem_rst_n_odp_scan_c  : emem_rst_n_odp_t := '0';

  -- Field "odn"
  constant emem_rst_n_odn_size_c  : integer := 1;
  constant emem_rst_n_odn_lsb_c   : integer := 0;
  constant emem_rst_n_odn_msb_c   : integer := 0;
  subtype emem_rst_n_odn_t is std_ulogic;
  constant emem_rst_n_odn_reset_c : emem_rst_n_odn_t := '0';
  constant emem_rst_n_odn_scan_c  : emem_rst_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "aout0"
  constant aout0_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant aout0_ds_size_c  : integer := 2;
  constant aout0_ds_lsb_c   : integer := 4;
  constant aout0_ds_msb_c   : integer := 5;
  subtype aout0_ds_t is std_ulogic_vector(aout0_ds_size_c - 1 downto 0);
  constant aout0_ds_reset_c : aout0_ds_t := std_ulogic_vector(to_unsigned(2, aout0_ds_t'length));
  constant aout0_ds_scan_c  : aout0_ds_t := std_ulogic_vector(to_unsigned(2, aout0_ds_t'length));

  -- Field "sr"
  constant aout0_sr_size_c  : integer := 1;
  constant aout0_sr_lsb_c   : integer := 3;
  constant aout0_sr_msb_c   : integer := 3;
  subtype aout0_sr_t is std_ulogic;
  constant aout0_sr_reset_c : aout0_sr_t := '1';
  constant aout0_sr_scan_c  : aout0_sr_t := '1';

  -- Field "co"
  constant aout0_co_size_c  : integer := 1;
  constant aout0_co_lsb_c   : integer := 2;
  constant aout0_co_msb_c   : integer := 2;
  subtype aout0_co_t is std_ulogic;
  constant aout0_co_reset_c : aout0_co_t := '0';
  constant aout0_co_scan_c  : aout0_co_t := '0';

  -- Field "odp"
  constant aout0_odp_size_c  : integer := 1;
  constant aout0_odp_lsb_c   : integer := 1;
  constant aout0_odp_msb_c   : integer := 1;
  subtype aout0_odp_t is std_ulogic;
  constant aout0_odp_reset_c : aout0_odp_t := '0';
  constant aout0_odp_scan_c  : aout0_odp_t := '0';

  -- Field "odn"
  constant aout0_odn_size_c  : integer := 1;
  constant aout0_odn_lsb_c   : integer := 0;
  constant aout0_odn_msb_c   : integer := 0;
  subtype aout0_odn_t is std_ulogic;
  constant aout0_odn_reset_c : aout0_odn_t := '0';
  constant aout0_odn_scan_c  : aout0_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "aout1"
  constant aout1_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant aout1_ds_size_c  : integer := 2;
  constant aout1_ds_lsb_c   : integer := 4;
  constant aout1_ds_msb_c   : integer := 5;
  subtype aout1_ds_t is std_ulogic_vector(aout1_ds_size_c - 1 downto 0);
  constant aout1_ds_reset_c : aout1_ds_t := std_ulogic_vector(to_unsigned(2, aout1_ds_t'length));
  constant aout1_ds_scan_c  : aout1_ds_t := std_ulogic_vector(to_unsigned(2, aout1_ds_t'length));

  -- Field "sr"
  constant aout1_sr_size_c  : integer := 1;
  constant aout1_sr_lsb_c   : integer := 3;
  constant aout1_sr_msb_c   : integer := 3;
  subtype aout1_sr_t is std_ulogic;
  constant aout1_sr_reset_c : aout1_sr_t := '1';
  constant aout1_sr_scan_c  : aout1_sr_t := '1';

  -- Field "co"
  constant aout1_co_size_c  : integer := 1;
  constant aout1_co_lsb_c   : integer := 2;
  constant aout1_co_msb_c   : integer := 2;
  subtype aout1_co_t is std_ulogic;
  constant aout1_co_reset_c : aout1_co_t := '0';
  constant aout1_co_scan_c  : aout1_co_t := '0';

  -- Field "odp"
  constant aout1_odp_size_c  : integer := 1;
  constant aout1_odp_lsb_c   : integer := 1;
  constant aout1_odp_msb_c   : integer := 1;
  subtype aout1_odp_t is std_ulogic;
  constant aout1_odp_reset_c : aout1_odp_t := '0';
  constant aout1_odp_scan_c  : aout1_odp_t := '0';

  -- Field "odn"
  constant aout1_odn_size_c  : integer := 1;
  constant aout1_odn_lsb_c   : integer := 0;
  constant aout1_odn_msb_c   : integer := 0;
  subtype aout1_odn_t is std_ulogic;
  constant aout1_odn_reset_c : aout1_odn_t := '0';
  constant aout1_odn_scan_c  : aout1_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "ach0"
  constant ach0_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant ach0_ste_size_c  : integer := 2;
  constant ach0_ste_lsb_c   : integer := 2;
  constant ach0_ste_msb_c   : integer := 3;
  subtype ach0_ste_t is std_ulogic_vector(ach0_ste_size_c - 1 downto 0);
  constant ach0_ste_reset_c : ach0_ste_t := std_ulogic_vector(to_unsigned(0, ach0_ste_t'length));
  constant ach0_ste_scan_c  : ach0_ste_t := std_ulogic_vector(to_unsigned(0, ach0_ste_t'length));

  -- Field "pd"
  constant ach0_pd_size_c  : integer := 1;
  constant ach0_pd_lsb_c   : integer := 1;
  constant ach0_pd_msb_c   : integer := 1;
  subtype ach0_pd_t is std_ulogic;
  constant ach0_pd_reset_c : ach0_pd_t := '0';
  constant ach0_pd_scan_c  : ach0_pd_t := '0';

  -- Field "pu"
  constant ach0_pu_size_c  : integer := 1;
  constant ach0_pu_lsb_c   : integer := 0;
  constant ach0_pu_msb_c   : integer := 0;
  subtype ach0_pu_t is std_ulogic;
  constant ach0_pu_reset_c : ach0_pu_t := '0';
  constant ach0_pu_scan_c  : ach0_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_mdio_out"
  constant enet_mdio_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant enet_mdio_out_ds_size_c  : integer := 2;
  constant enet_mdio_out_ds_lsb_c   : integer := 4;
  constant enet_mdio_out_ds_msb_c   : integer := 5;
  subtype enet_mdio_out_ds_t is std_ulogic_vector(enet_mdio_out_ds_size_c - 1 downto 0);
  constant enet_mdio_out_ds_reset_c : enet_mdio_out_ds_t := std_ulogic_vector(to_unsigned(2, enet_mdio_out_ds_t'length));
  constant enet_mdio_out_ds_scan_c  : enet_mdio_out_ds_t := std_ulogic_vector(to_unsigned(2, enet_mdio_out_ds_t'length));

  -- Field "sr"
  constant enet_mdio_out_sr_size_c  : integer := 1;
  constant enet_mdio_out_sr_lsb_c   : integer := 3;
  constant enet_mdio_out_sr_msb_c   : integer := 3;
  subtype enet_mdio_out_sr_t is std_ulogic;
  constant enet_mdio_out_sr_reset_c : enet_mdio_out_sr_t := '1';
  constant enet_mdio_out_sr_scan_c  : enet_mdio_out_sr_t := '1';

  -- Field "co"
  constant enet_mdio_out_co_size_c  : integer := 1;
  constant enet_mdio_out_co_lsb_c   : integer := 2;
  constant enet_mdio_out_co_msb_c   : integer := 2;
  subtype enet_mdio_out_co_t is std_ulogic;
  constant enet_mdio_out_co_reset_c : enet_mdio_out_co_t := '0';
  constant enet_mdio_out_co_scan_c  : enet_mdio_out_co_t := '0';

  -- Field "odp"
  constant enet_mdio_out_odp_size_c  : integer := 1;
  constant enet_mdio_out_odp_lsb_c   : integer := 1;
  constant enet_mdio_out_odp_msb_c   : integer := 1;
  subtype enet_mdio_out_odp_t is std_ulogic;
  constant enet_mdio_out_odp_reset_c : enet_mdio_out_odp_t := '0';
  constant enet_mdio_out_odp_scan_c  : enet_mdio_out_odp_t := '0';

  -- Field "odn"
  constant enet_mdio_out_odn_size_c  : integer := 1;
  constant enet_mdio_out_odn_lsb_c   : integer := 0;
  constant enet_mdio_out_odn_msb_c   : integer := 0;
  subtype enet_mdio_out_odn_t is std_ulogic;
  constant enet_mdio_out_odn_reset_c : enet_mdio_out_odn_t := '0';
  constant enet_mdio_out_odn_scan_c  : enet_mdio_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_mdio_in"
  constant enet_mdio_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant enet_mdio_in_ste_size_c  : integer := 2;
  constant enet_mdio_in_ste_lsb_c   : integer := 2;
  constant enet_mdio_in_ste_msb_c   : integer := 3;
  subtype enet_mdio_in_ste_t is std_ulogic_vector(enet_mdio_in_ste_size_c - 1 downto 0);
  constant enet_mdio_in_ste_reset_c : enet_mdio_in_ste_t := std_ulogic_vector(to_unsigned(0, enet_mdio_in_ste_t'length));
  constant enet_mdio_in_ste_scan_c  : enet_mdio_in_ste_t := std_ulogic_vector(to_unsigned(0, enet_mdio_in_ste_t'length));

  -- Field "pd"
  constant enet_mdio_in_pd_size_c  : integer := 1;
  constant enet_mdio_in_pd_lsb_c   : integer := 1;
  constant enet_mdio_in_pd_msb_c   : integer := 1;
  subtype enet_mdio_in_pd_t is std_ulogic;
  constant enet_mdio_in_pd_reset_c : enet_mdio_in_pd_t := '0';
  constant enet_mdio_in_pd_scan_c  : enet_mdio_in_pd_t := '0';

  -- Field "pu"
  constant enet_mdio_in_pu_size_c  : integer := 1;
  constant enet_mdio_in_pu_lsb_c   : integer := 0;
  constant enet_mdio_in_pu_msb_c   : integer := 0;
  subtype enet_mdio_in_pu_t is std_ulogic;
  constant enet_mdio_in_pu_reset_c : enet_mdio_in_pu_t := '0';
  constant enet_mdio_in_pu_scan_c  : enet_mdio_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_mdc"
  constant enet_mdc_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant enet_mdc_ds_size_c  : integer := 2;
  constant enet_mdc_ds_lsb_c   : integer := 4;
  constant enet_mdc_ds_msb_c   : integer := 5;
  subtype enet_mdc_ds_t is std_ulogic_vector(enet_mdc_ds_size_c - 1 downto 0);
  constant enet_mdc_ds_reset_c : enet_mdc_ds_t := std_ulogic_vector(to_unsigned(2, enet_mdc_ds_t'length));
  constant enet_mdc_ds_scan_c  : enet_mdc_ds_t := std_ulogic_vector(to_unsigned(2, enet_mdc_ds_t'length));

  -- Field "sr"
  constant enet_mdc_sr_size_c  : integer := 1;
  constant enet_mdc_sr_lsb_c   : integer := 3;
  constant enet_mdc_sr_msb_c   : integer := 3;
  subtype enet_mdc_sr_t is std_ulogic;
  constant enet_mdc_sr_reset_c : enet_mdc_sr_t := '1';
  constant enet_mdc_sr_scan_c  : enet_mdc_sr_t := '1';

  -- Field "co"
  constant enet_mdc_co_size_c  : integer := 1;
  constant enet_mdc_co_lsb_c   : integer := 2;
  constant enet_mdc_co_msb_c   : integer := 2;
  subtype enet_mdc_co_t is std_ulogic;
  constant enet_mdc_co_reset_c : enet_mdc_co_t := '0';
  constant enet_mdc_co_scan_c  : enet_mdc_co_t := '0';

  -- Field "odp"
  constant enet_mdc_odp_size_c  : integer := 1;
  constant enet_mdc_odp_lsb_c   : integer := 1;
  constant enet_mdc_odp_msb_c   : integer := 1;
  subtype enet_mdc_odp_t is std_ulogic;
  constant enet_mdc_odp_reset_c : enet_mdc_odp_t := '0';
  constant enet_mdc_odp_scan_c  : enet_mdc_odp_t := '0';

  -- Field "odn"
  constant enet_mdc_odn_size_c  : integer := 1;
  constant enet_mdc_odn_lsb_c   : integer := 0;
  constant enet_mdc_odn_msb_c   : integer := 0;
  subtype enet_mdc_odn_t is std_ulogic;
  constant enet_mdc_odn_reset_c : enet_mdc_odn_t := '0';
  constant enet_mdc_odn_scan_c  : enet_mdc_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_txer"
  constant enet_txer_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant enet_txer_ds_size_c  : integer := 2;
  constant enet_txer_ds_lsb_c   : integer := 4;
  constant enet_txer_ds_msb_c   : integer := 5;
  subtype enet_txer_ds_t is std_ulogic_vector(enet_txer_ds_size_c - 1 downto 0);
  constant enet_txer_ds_reset_c : enet_txer_ds_t := std_ulogic_vector(to_unsigned(2, enet_txer_ds_t'length));
  constant enet_txer_ds_scan_c  : enet_txer_ds_t := std_ulogic_vector(to_unsigned(2, enet_txer_ds_t'length));

  -- Field "sr"
  constant enet_txer_sr_size_c  : integer := 1;
  constant enet_txer_sr_lsb_c   : integer := 3;
  constant enet_txer_sr_msb_c   : integer := 3;
  subtype enet_txer_sr_t is std_ulogic;
  constant enet_txer_sr_reset_c : enet_txer_sr_t := '1';
  constant enet_txer_sr_scan_c  : enet_txer_sr_t := '1';

  -- Field "co"
  constant enet_txer_co_size_c  : integer := 1;
  constant enet_txer_co_lsb_c   : integer := 2;
  constant enet_txer_co_msb_c   : integer := 2;
  subtype enet_txer_co_t is std_ulogic;
  constant enet_txer_co_reset_c : enet_txer_co_t := '0';
  constant enet_txer_co_scan_c  : enet_txer_co_t := '0';

  -- Field "odp"
  constant enet_txer_odp_size_c  : integer := 1;
  constant enet_txer_odp_lsb_c   : integer := 1;
  constant enet_txer_odp_msb_c   : integer := 1;
  subtype enet_txer_odp_t is std_ulogic;
  constant enet_txer_odp_reset_c : enet_txer_odp_t := '0';
  constant enet_txer_odp_scan_c  : enet_txer_odp_t := '0';

  -- Field "odn"
  constant enet_txer_odn_size_c  : integer := 1;
  constant enet_txer_odn_lsb_c   : integer := 0;
  constant enet_txer_odn_msb_c   : integer := 0;
  subtype enet_txer_odn_t is std_ulogic;
  constant enet_txer_odn_reset_c : enet_txer_odn_t := '0';
  constant enet_txer_odn_scan_c  : enet_txer_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_txd0"
  constant enet_txd0_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant enet_txd0_ds_size_c  : integer := 2;
  constant enet_txd0_ds_lsb_c   : integer := 4;
  constant enet_txd0_ds_msb_c   : integer := 5;
  subtype enet_txd0_ds_t is std_ulogic_vector(enet_txd0_ds_size_c - 1 downto 0);
  constant enet_txd0_ds_reset_c : enet_txd0_ds_t := std_ulogic_vector(to_unsigned(2, enet_txd0_ds_t'length));
  constant enet_txd0_ds_scan_c  : enet_txd0_ds_t := std_ulogic_vector(to_unsigned(2, enet_txd0_ds_t'length));

  -- Field "sr"
  constant enet_txd0_sr_size_c  : integer := 1;
  constant enet_txd0_sr_lsb_c   : integer := 3;
  constant enet_txd0_sr_msb_c   : integer := 3;
  subtype enet_txd0_sr_t is std_ulogic;
  constant enet_txd0_sr_reset_c : enet_txd0_sr_t := '1';
  constant enet_txd0_sr_scan_c  : enet_txd0_sr_t := '1';

  -- Field "co"
  constant enet_txd0_co_size_c  : integer := 1;
  constant enet_txd0_co_lsb_c   : integer := 2;
  constant enet_txd0_co_msb_c   : integer := 2;
  subtype enet_txd0_co_t is std_ulogic;
  constant enet_txd0_co_reset_c : enet_txd0_co_t := '0';
  constant enet_txd0_co_scan_c  : enet_txd0_co_t := '0';

  -- Field "odp"
  constant enet_txd0_odp_size_c  : integer := 1;
  constant enet_txd0_odp_lsb_c   : integer := 1;
  constant enet_txd0_odp_msb_c   : integer := 1;
  subtype enet_txd0_odp_t is std_ulogic;
  constant enet_txd0_odp_reset_c : enet_txd0_odp_t := '0';
  constant enet_txd0_odp_scan_c  : enet_txd0_odp_t := '0';

  -- Field "odn"
  constant enet_txd0_odn_size_c  : integer := 1;
  constant enet_txd0_odn_lsb_c   : integer := 0;
  constant enet_txd0_odn_msb_c   : integer := 0;
  subtype enet_txd0_odn_t is std_ulogic;
  constant enet_txd0_odn_reset_c : enet_txd0_odn_t := '0';
  constant enet_txd0_odn_scan_c  : enet_txd0_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_txd1"
  constant enet_txd1_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant enet_txd1_ds_size_c  : integer := 2;
  constant enet_txd1_ds_lsb_c   : integer := 4;
  constant enet_txd1_ds_msb_c   : integer := 5;
  subtype enet_txd1_ds_t is std_ulogic_vector(enet_txd1_ds_size_c - 1 downto 0);
  constant enet_txd1_ds_reset_c : enet_txd1_ds_t := std_ulogic_vector(to_unsigned(2, enet_txd1_ds_t'length));
  constant enet_txd1_ds_scan_c  : enet_txd1_ds_t := std_ulogic_vector(to_unsigned(2, enet_txd1_ds_t'length));

  -- Field "sr"
  constant enet_txd1_sr_size_c  : integer := 1;
  constant enet_txd1_sr_lsb_c   : integer := 3;
  constant enet_txd1_sr_msb_c   : integer := 3;
  subtype enet_txd1_sr_t is std_ulogic;
  constant enet_txd1_sr_reset_c : enet_txd1_sr_t := '1';
  constant enet_txd1_sr_scan_c  : enet_txd1_sr_t := '1';

  -- Field "co"
  constant enet_txd1_co_size_c  : integer := 1;
  constant enet_txd1_co_lsb_c   : integer := 2;
  constant enet_txd1_co_msb_c   : integer := 2;
  subtype enet_txd1_co_t is std_ulogic;
  constant enet_txd1_co_reset_c : enet_txd1_co_t := '0';
  constant enet_txd1_co_scan_c  : enet_txd1_co_t := '0';

  -- Field "odp"
  constant enet_txd1_odp_size_c  : integer := 1;
  constant enet_txd1_odp_lsb_c   : integer := 1;
  constant enet_txd1_odp_msb_c   : integer := 1;
  subtype enet_txd1_odp_t is std_ulogic;
  constant enet_txd1_odp_reset_c : enet_txd1_odp_t := '0';
  constant enet_txd1_odp_scan_c  : enet_txd1_odp_t := '0';

  -- Field "odn"
  constant enet_txd1_odn_size_c  : integer := 1;
  constant enet_txd1_odn_lsb_c   : integer := 0;
  constant enet_txd1_odn_msb_c   : integer := 0;
  subtype enet_txd1_odn_t is std_ulogic;
  constant enet_txd1_odn_reset_c : enet_txd1_odn_t := '0';
  constant enet_txd1_odn_scan_c  : enet_txd1_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_txen"
  constant enet_txen_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant enet_txen_ds_size_c  : integer := 2;
  constant enet_txen_ds_lsb_c   : integer := 4;
  constant enet_txen_ds_msb_c   : integer := 5;
  subtype enet_txen_ds_t is std_ulogic_vector(enet_txen_ds_size_c - 1 downto 0);
  constant enet_txen_ds_reset_c : enet_txen_ds_t := std_ulogic_vector(to_unsigned(2, enet_txen_ds_t'length));
  constant enet_txen_ds_scan_c  : enet_txen_ds_t := std_ulogic_vector(to_unsigned(2, enet_txen_ds_t'length));

  -- Field "sr"
  constant enet_txen_sr_size_c  : integer := 1;
  constant enet_txen_sr_lsb_c   : integer := 3;
  constant enet_txen_sr_msb_c   : integer := 3;
  subtype enet_txen_sr_t is std_ulogic;
  constant enet_txen_sr_reset_c : enet_txen_sr_t := '1';
  constant enet_txen_sr_scan_c  : enet_txen_sr_t := '1';

  -- Field "co"
  constant enet_txen_co_size_c  : integer := 1;
  constant enet_txen_co_lsb_c   : integer := 2;
  constant enet_txen_co_msb_c   : integer := 2;
  subtype enet_txen_co_t is std_ulogic;
  constant enet_txen_co_reset_c : enet_txen_co_t := '0';
  constant enet_txen_co_scan_c  : enet_txen_co_t := '0';

  -- Field "odp"
  constant enet_txen_odp_size_c  : integer := 1;
  constant enet_txen_odp_lsb_c   : integer := 1;
  constant enet_txen_odp_msb_c   : integer := 1;
  subtype enet_txen_odp_t is std_ulogic;
  constant enet_txen_odp_reset_c : enet_txen_odp_t := '0';
  constant enet_txen_odp_scan_c  : enet_txen_odp_t := '0';

  -- Field "odn"
  constant enet_txen_odn_size_c  : integer := 1;
  constant enet_txen_odn_lsb_c   : integer := 0;
  constant enet_txen_odn_msb_c   : integer := 0;
  subtype enet_txen_odn_t is std_ulogic;
  constant enet_txen_odn_reset_c : enet_txen_odn_t := '0';
  constant enet_txen_odn_scan_c  : enet_txen_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_clk"
  constant enet_clk_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant enet_clk_ste_size_c  : integer := 2;
  constant enet_clk_ste_lsb_c   : integer := 2;
  constant enet_clk_ste_msb_c   : integer := 3;
  subtype enet_clk_ste_t is std_ulogic_vector(enet_clk_ste_size_c - 1 downto 0);
  constant enet_clk_ste_reset_c : enet_clk_ste_t := std_ulogic_vector(to_unsigned(0, enet_clk_ste_t'length));
  constant enet_clk_ste_scan_c  : enet_clk_ste_t := std_ulogic_vector(to_unsigned(0, enet_clk_ste_t'length));

  -- Field "pd"
  constant enet_clk_pd_size_c  : integer := 1;
  constant enet_clk_pd_lsb_c   : integer := 1;
  constant enet_clk_pd_msb_c   : integer := 1;
  subtype enet_clk_pd_t is std_ulogic;
  constant enet_clk_pd_reset_c : enet_clk_pd_t := '0';
  constant enet_clk_pd_scan_c  : enet_clk_pd_t := '0';

  -- Field "pu"
  constant enet_clk_pu_size_c  : integer := 1;
  constant enet_clk_pu_lsb_c   : integer := 0;
  constant enet_clk_pu_msb_c   : integer := 0;
  subtype enet_clk_pu_t is std_ulogic;
  constant enet_clk_pu_reset_c : enet_clk_pu_t := '0';
  constant enet_clk_pu_scan_c  : enet_clk_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_rxdv"
  constant enet_rxdv_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant enet_rxdv_ste_size_c  : integer := 2;
  constant enet_rxdv_ste_lsb_c   : integer := 2;
  constant enet_rxdv_ste_msb_c   : integer := 3;
  subtype enet_rxdv_ste_t is std_ulogic_vector(enet_rxdv_ste_size_c - 1 downto 0);
  constant enet_rxdv_ste_reset_c : enet_rxdv_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxdv_ste_t'length));
  constant enet_rxdv_ste_scan_c  : enet_rxdv_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxdv_ste_t'length));

  -- Field "pd"
  constant enet_rxdv_pd_size_c  : integer := 1;
  constant enet_rxdv_pd_lsb_c   : integer := 1;
  constant enet_rxdv_pd_msb_c   : integer := 1;
  subtype enet_rxdv_pd_t is std_ulogic;
  constant enet_rxdv_pd_reset_c : enet_rxdv_pd_t := '0';
  constant enet_rxdv_pd_scan_c  : enet_rxdv_pd_t := '0';

  -- Field "pu"
  constant enet_rxdv_pu_size_c  : integer := 1;
  constant enet_rxdv_pu_lsb_c   : integer := 0;
  constant enet_rxdv_pu_msb_c   : integer := 0;
  subtype enet_rxdv_pu_t is std_ulogic;
  constant enet_rxdv_pu_reset_c : enet_rxdv_pu_t := '0';
  constant enet_rxdv_pu_scan_c  : enet_rxdv_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_rxd0"
  constant enet_rxd0_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant enet_rxd0_ste_size_c  : integer := 2;
  constant enet_rxd0_ste_lsb_c   : integer := 2;
  constant enet_rxd0_ste_msb_c   : integer := 3;
  subtype enet_rxd0_ste_t is std_ulogic_vector(enet_rxd0_ste_size_c - 1 downto 0);
  constant enet_rxd0_ste_reset_c : enet_rxd0_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxd0_ste_t'length));
  constant enet_rxd0_ste_scan_c  : enet_rxd0_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxd0_ste_t'length));

  -- Field "pd"
  constant enet_rxd0_pd_size_c  : integer := 1;
  constant enet_rxd0_pd_lsb_c   : integer := 1;
  constant enet_rxd0_pd_msb_c   : integer := 1;
  subtype enet_rxd0_pd_t is std_ulogic;
  constant enet_rxd0_pd_reset_c : enet_rxd0_pd_t := '0';
  constant enet_rxd0_pd_scan_c  : enet_rxd0_pd_t := '0';

  -- Field "pu"
  constant enet_rxd0_pu_size_c  : integer := 1;
  constant enet_rxd0_pu_lsb_c   : integer := 0;
  constant enet_rxd0_pu_msb_c   : integer := 0;
  subtype enet_rxd0_pu_t is std_ulogic;
  constant enet_rxd0_pu_reset_c : enet_rxd0_pu_t := '0';
  constant enet_rxd0_pu_scan_c  : enet_rxd0_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_rxd1"
  constant enet_rxd1_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant enet_rxd1_ste_size_c  : integer := 2;
  constant enet_rxd1_ste_lsb_c   : integer := 2;
  constant enet_rxd1_ste_msb_c   : integer := 3;
  subtype enet_rxd1_ste_t is std_ulogic_vector(enet_rxd1_ste_size_c - 1 downto 0);
  constant enet_rxd1_ste_reset_c : enet_rxd1_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxd1_ste_t'length));
  constant enet_rxd1_ste_scan_c  : enet_rxd1_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxd1_ste_t'length));

  -- Field "pd"
  constant enet_rxd1_pd_size_c  : integer := 1;
  constant enet_rxd1_pd_lsb_c   : integer := 1;
  constant enet_rxd1_pd_msb_c   : integer := 1;
  subtype enet_rxd1_pd_t is std_ulogic;
  constant enet_rxd1_pd_reset_c : enet_rxd1_pd_t := '0';
  constant enet_rxd1_pd_scan_c  : enet_rxd1_pd_t := '0';

  -- Field "pu"
  constant enet_rxd1_pu_size_c  : integer := 1;
  constant enet_rxd1_pu_lsb_c   : integer := 0;
  constant enet_rxd1_pu_msb_c   : integer := 0;
  subtype enet_rxd1_pu_t is std_ulogic;
  constant enet_rxd1_pu_reset_c : enet_rxd1_pu_t := '0';
  constant enet_rxd1_pu_scan_c  : enet_rxd1_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "enet_rxer"
  constant enet_rxer_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant enet_rxer_ste_size_c  : integer := 2;
  constant enet_rxer_ste_lsb_c   : integer := 2;
  constant enet_rxer_ste_msb_c   : integer := 3;
  subtype enet_rxer_ste_t is std_ulogic_vector(enet_rxer_ste_size_c - 1 downto 0);
  constant enet_rxer_ste_reset_c : enet_rxer_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxer_ste_t'length));
  constant enet_rxer_ste_scan_c  : enet_rxer_ste_t := std_ulogic_vector(to_unsigned(0, enet_rxer_ste_t'length));

  -- Field "pd"
  constant enet_rxer_pd_size_c  : integer := 1;
  constant enet_rxer_pd_lsb_c   : integer := 1;
  constant enet_rxer_pd_msb_c   : integer := 1;
  subtype enet_rxer_pd_t is std_ulogic;
  constant enet_rxer_pd_reset_c : enet_rxer_pd_t := '0';
  constant enet_rxer_pd_scan_c  : enet_rxer_pd_t := '0';

  -- Field "pu"
  constant enet_rxer_pu_size_c  : integer := 1;
  constant enet_rxer_pu_lsb_c   : integer := 0;
  constant enet_rxer_pu_msb_c   : integer := 0;
  subtype enet_rxer_pu_t is std_ulogic;
  constant enet_rxer_pu_reset_c : enet_rxer_pu_t := '0';
  constant enet_rxer_pu_scan_c  : enet_rxer_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "spi_sclk"
  constant spi_sclk_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant spi_sclk_ste_size_c  : integer := 2;
  constant spi_sclk_ste_lsb_c   : integer := 2;
  constant spi_sclk_ste_msb_c   : integer := 3;
  subtype spi_sclk_ste_t is std_ulogic_vector(spi_sclk_ste_size_c - 1 downto 0);
  constant spi_sclk_ste_reset_c : spi_sclk_ste_t := std_ulogic_vector(to_unsigned(0, spi_sclk_ste_t'length));
  constant spi_sclk_ste_scan_c  : spi_sclk_ste_t := std_ulogic_vector(to_unsigned(0, spi_sclk_ste_t'length));

  -- Field "pd"
  constant spi_sclk_pd_size_c  : integer := 1;
  constant spi_sclk_pd_lsb_c   : integer := 1;
  constant spi_sclk_pd_msb_c   : integer := 1;
  subtype spi_sclk_pd_t is std_ulogic;
  constant spi_sclk_pd_reset_c : spi_sclk_pd_t := '0';
  constant spi_sclk_pd_scan_c  : spi_sclk_pd_t := '0';

  -- Field "pu"
  constant spi_sclk_pu_size_c  : integer := 1;
  constant spi_sclk_pu_lsb_c   : integer := 0;
  constant spi_sclk_pu_msb_c   : integer := 0;
  subtype spi_sclk_pu_t is std_ulogic;
  constant spi_sclk_pu_reset_c : spi_sclk_pu_t := '0';
  constant spi_sclk_pu_scan_c  : spi_sclk_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "spi_cs_n"
  constant spi_cs_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant spi_cs_n_ste_size_c  : integer := 2;
  constant spi_cs_n_ste_lsb_c   : integer := 2;
  constant spi_cs_n_ste_msb_c   : integer := 3;
  subtype spi_cs_n_ste_t is std_ulogic_vector(spi_cs_n_ste_size_c - 1 downto 0);
  constant spi_cs_n_ste_reset_c : spi_cs_n_ste_t := std_ulogic_vector(to_unsigned(0, spi_cs_n_ste_t'length));
  constant spi_cs_n_ste_scan_c  : spi_cs_n_ste_t := std_ulogic_vector(to_unsigned(0, spi_cs_n_ste_t'length));

  -- Field "pd"
  constant spi_cs_n_pd_size_c  : integer := 1;
  constant spi_cs_n_pd_lsb_c   : integer := 1;
  constant spi_cs_n_pd_msb_c   : integer := 1;
  subtype spi_cs_n_pd_t is std_ulogic;
  constant spi_cs_n_pd_reset_c : spi_cs_n_pd_t := '0';
  constant spi_cs_n_pd_scan_c  : spi_cs_n_pd_t := '0';

  -- Field "pu"
  constant spi_cs_n_pu_size_c  : integer := 1;
  constant spi_cs_n_pu_lsb_c   : integer := 0;
  constant spi_cs_n_pu_msb_c   : integer := 0;
  subtype spi_cs_n_pu_t is std_ulogic;
  constant spi_cs_n_pu_reset_c : spi_cs_n_pu_t := '0';
  constant spi_cs_n_pu_scan_c  : spi_cs_n_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "spi_mosi"
  constant spi_mosi_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant spi_mosi_ste_size_c  : integer := 2;
  constant spi_mosi_ste_lsb_c   : integer := 2;
  constant spi_mosi_ste_msb_c   : integer := 3;
  subtype spi_mosi_ste_t is std_ulogic_vector(spi_mosi_ste_size_c - 1 downto 0);
  constant spi_mosi_ste_reset_c : spi_mosi_ste_t := std_ulogic_vector(to_unsigned(0, spi_mosi_ste_t'length));
  constant spi_mosi_ste_scan_c  : spi_mosi_ste_t := std_ulogic_vector(to_unsigned(0, spi_mosi_ste_t'length));

  -- Field "pd"
  constant spi_mosi_pd_size_c  : integer := 1;
  constant spi_mosi_pd_lsb_c   : integer := 1;
  constant spi_mosi_pd_msb_c   : integer := 1;
  subtype spi_mosi_pd_t is std_ulogic;
  constant spi_mosi_pd_reset_c : spi_mosi_pd_t := '0';
  constant spi_mosi_pd_scan_c  : spi_mosi_pd_t := '0';

  -- Field "pu"
  constant spi_mosi_pu_size_c  : integer := 1;
  constant spi_mosi_pu_lsb_c   : integer := 0;
  constant spi_mosi_pu_msb_c   : integer := 0;
  subtype spi_mosi_pu_t is std_ulogic;
  constant spi_mosi_pu_reset_c : spi_mosi_pu_t := '0';
  constant spi_mosi_pu_scan_c  : spi_mosi_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "spi_miso"
  constant spi_miso_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant spi_miso_ds_size_c  : integer := 2;
  constant spi_miso_ds_lsb_c   : integer := 4;
  constant spi_miso_ds_msb_c   : integer := 5;
  subtype spi_miso_ds_t is std_ulogic_vector(spi_miso_ds_size_c - 1 downto 0);
  constant spi_miso_ds_reset_c : spi_miso_ds_t := std_ulogic_vector(to_unsigned(2, spi_miso_ds_t'length));
  constant spi_miso_ds_scan_c  : spi_miso_ds_t := std_ulogic_vector(to_unsigned(2, spi_miso_ds_t'length));

  -- Field "sr"
  constant spi_miso_sr_size_c  : integer := 1;
  constant spi_miso_sr_lsb_c   : integer := 3;
  constant spi_miso_sr_msb_c   : integer := 3;
  subtype spi_miso_sr_t is std_ulogic;
  constant spi_miso_sr_reset_c : spi_miso_sr_t := '1';
  constant spi_miso_sr_scan_c  : spi_miso_sr_t := '1';

  -- Field "co"
  constant spi_miso_co_size_c  : integer := 1;
  constant spi_miso_co_lsb_c   : integer := 2;
  constant spi_miso_co_msb_c   : integer := 2;
  subtype spi_miso_co_t is std_ulogic;
  constant spi_miso_co_reset_c : spi_miso_co_t := '0';
  constant spi_miso_co_scan_c  : spi_miso_co_t := '0';

  -- Field "odp"
  constant spi_miso_odp_size_c  : integer := 1;
  constant spi_miso_odp_lsb_c   : integer := 1;
  constant spi_miso_odp_msb_c   : integer := 1;
  subtype spi_miso_odp_t is std_ulogic;
  constant spi_miso_odp_reset_c : spi_miso_odp_t := '0';
  constant spi_miso_odp_scan_c  : spi_miso_odp_t := '0';

  -- Field "odn"
  constant spi_miso_odn_size_c  : integer := 1;
  constant spi_miso_odn_lsb_c   : integer := 0;
  constant spi_miso_odn_msb_c   : integer := 0;
  subtype spi_miso_odn_t is std_ulogic;
  constant spi_miso_odn_reset_c : spi_miso_odn_t := '0';
  constant spi_miso_odn_scan_c  : spi_miso_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pll_ref_clk"
  constant pll_ref_clk_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pll_ref_clk_ste_size_c  : integer := 2;
  constant pll_ref_clk_ste_lsb_c   : integer := 2;
  constant pll_ref_clk_ste_msb_c   : integer := 3;
  subtype pll_ref_clk_ste_t is std_ulogic_vector(pll_ref_clk_ste_size_c - 1 downto 0);
  constant pll_ref_clk_ste_reset_c : pll_ref_clk_ste_t := std_ulogic_vector(to_unsigned(0, pll_ref_clk_ste_t'length));
  constant pll_ref_clk_ste_scan_c  : pll_ref_clk_ste_t := std_ulogic_vector(to_unsigned(0, pll_ref_clk_ste_t'length));

  -- Field "pd"
  constant pll_ref_clk_pd_size_c  : integer := 1;
  constant pll_ref_clk_pd_lsb_c   : integer := 1;
  constant pll_ref_clk_pd_msb_c   : integer := 1;
  subtype pll_ref_clk_pd_t is std_ulogic;
  constant pll_ref_clk_pd_reset_c : pll_ref_clk_pd_t := '0';
  constant pll_ref_clk_pd_scan_c  : pll_ref_clk_pd_t := '0';

  -- Field "pu"
  constant pll_ref_clk_pu_size_c  : integer := 1;
  constant pll_ref_clk_pu_lsb_c   : integer := 0;
  constant pll_ref_clk_pu_msb_c   : integer := 0;
  subtype pll_ref_clk_pu_t is std_ulogic;
  constant pll_ref_clk_pu_reset_c : pll_ref_clk_pu_t := '0';
  constant pll_ref_clk_pu_scan_c  : pll_ref_clk_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa0_sin_out"
  constant pa0_sin_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pa0_sin_out_ds_size_c  : integer := 2;
  constant pa0_sin_out_ds_lsb_c   : integer := 4;
  constant pa0_sin_out_ds_msb_c   : integer := 5;
  subtype pa0_sin_out_ds_t is std_ulogic_vector(pa0_sin_out_ds_size_c - 1 downto 0);
  constant pa0_sin_out_ds_reset_c : pa0_sin_out_ds_t := std_ulogic_vector(to_unsigned(2, pa0_sin_out_ds_t'length));
  constant pa0_sin_out_ds_scan_c  : pa0_sin_out_ds_t := std_ulogic_vector(to_unsigned(2, pa0_sin_out_ds_t'length));

  -- Field "sr"
  constant pa0_sin_out_sr_size_c  : integer := 1;
  constant pa0_sin_out_sr_lsb_c   : integer := 3;
  constant pa0_sin_out_sr_msb_c   : integer := 3;
  subtype pa0_sin_out_sr_t is std_ulogic;
  constant pa0_sin_out_sr_reset_c : pa0_sin_out_sr_t := '1';
  constant pa0_sin_out_sr_scan_c  : pa0_sin_out_sr_t := '1';

  -- Field "co"
  constant pa0_sin_out_co_size_c  : integer := 1;
  constant pa0_sin_out_co_lsb_c   : integer := 2;
  constant pa0_sin_out_co_msb_c   : integer := 2;
  subtype pa0_sin_out_co_t is std_ulogic;
  constant pa0_sin_out_co_reset_c : pa0_sin_out_co_t := '0';
  constant pa0_sin_out_co_scan_c  : pa0_sin_out_co_t := '0';

  -- Field "odp"
  constant pa0_sin_out_odp_size_c  : integer := 1;
  constant pa0_sin_out_odp_lsb_c   : integer := 1;
  constant pa0_sin_out_odp_msb_c   : integer := 1;
  subtype pa0_sin_out_odp_t is std_ulogic;
  constant pa0_sin_out_odp_reset_c : pa0_sin_out_odp_t := '0';
  constant pa0_sin_out_odp_scan_c  : pa0_sin_out_odp_t := '0';

  -- Field "odn"
  constant pa0_sin_out_odn_size_c  : integer := 1;
  constant pa0_sin_out_odn_lsb_c   : integer := 0;
  constant pa0_sin_out_odn_msb_c   : integer := 0;
  subtype pa0_sin_out_odn_t is std_ulogic;
  constant pa0_sin_out_odn_reset_c : pa0_sin_out_odn_t := '0';
  constant pa0_sin_out_odn_scan_c  : pa0_sin_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa0_sin_in"
  constant pa0_sin_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pa0_sin_in_ste_size_c  : integer := 2;
  constant pa0_sin_in_ste_lsb_c   : integer := 2;
  constant pa0_sin_in_ste_msb_c   : integer := 3;
  subtype pa0_sin_in_ste_t is std_ulogic_vector(pa0_sin_in_ste_size_c - 1 downto 0);
  constant pa0_sin_in_ste_reset_c : pa0_sin_in_ste_t := std_ulogic_vector(to_unsigned(0, pa0_sin_in_ste_t'length));
  constant pa0_sin_in_ste_scan_c  : pa0_sin_in_ste_t := std_ulogic_vector(to_unsigned(0, pa0_sin_in_ste_t'length));

  -- Field "pd"
  constant pa0_sin_in_pd_size_c  : integer := 1;
  constant pa0_sin_in_pd_lsb_c   : integer := 1;
  constant pa0_sin_in_pd_msb_c   : integer := 1;
  subtype pa0_sin_in_pd_t is std_ulogic;
  constant pa0_sin_in_pd_reset_c : pa0_sin_in_pd_t := '0';
  constant pa0_sin_in_pd_scan_c  : pa0_sin_in_pd_t := '0';

  -- Field "pu"
  constant pa0_sin_in_pu_size_c  : integer := 1;
  constant pa0_sin_in_pu_lsb_c   : integer := 0;
  constant pa0_sin_in_pu_msb_c   : integer := 0;
  subtype pa0_sin_in_pu_t is std_ulogic;
  constant pa0_sin_in_pu_reset_c : pa0_sin_in_pu_t := '0';
  constant pa0_sin_in_pu_scan_c  : pa0_sin_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa5_cs_n_out"
  constant pa5_cs_n_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pa5_cs_n_out_ds_size_c  : integer := 2;
  constant pa5_cs_n_out_ds_lsb_c   : integer := 4;
  constant pa5_cs_n_out_ds_msb_c   : integer := 5;
  subtype pa5_cs_n_out_ds_t is std_ulogic_vector(pa5_cs_n_out_ds_size_c - 1 downto 0);
  constant pa5_cs_n_out_ds_reset_c : pa5_cs_n_out_ds_t := std_ulogic_vector(to_unsigned(2, pa5_cs_n_out_ds_t'length));
  constant pa5_cs_n_out_ds_scan_c  : pa5_cs_n_out_ds_t := std_ulogic_vector(to_unsigned(2, pa5_cs_n_out_ds_t'length));

  -- Field "sr"
  constant pa5_cs_n_out_sr_size_c  : integer := 1;
  constant pa5_cs_n_out_sr_lsb_c   : integer := 3;
  constant pa5_cs_n_out_sr_msb_c   : integer := 3;
  subtype pa5_cs_n_out_sr_t is std_ulogic;
  constant pa5_cs_n_out_sr_reset_c : pa5_cs_n_out_sr_t := '1';
  constant pa5_cs_n_out_sr_scan_c  : pa5_cs_n_out_sr_t := '1';

  -- Field "co"
  constant pa5_cs_n_out_co_size_c  : integer := 1;
  constant pa5_cs_n_out_co_lsb_c   : integer := 2;
  constant pa5_cs_n_out_co_msb_c   : integer := 2;
  subtype pa5_cs_n_out_co_t is std_ulogic;
  constant pa5_cs_n_out_co_reset_c : pa5_cs_n_out_co_t := '0';
  constant pa5_cs_n_out_co_scan_c  : pa5_cs_n_out_co_t := '0';

  -- Field "odp"
  constant pa5_cs_n_out_odp_size_c  : integer := 1;
  constant pa5_cs_n_out_odp_lsb_c   : integer := 1;
  constant pa5_cs_n_out_odp_msb_c   : integer := 1;
  subtype pa5_cs_n_out_odp_t is std_ulogic;
  constant pa5_cs_n_out_odp_reset_c : pa5_cs_n_out_odp_t := '0';
  constant pa5_cs_n_out_odp_scan_c  : pa5_cs_n_out_odp_t := '0';

  -- Field "odn"
  constant pa5_cs_n_out_odn_size_c  : integer := 1;
  constant pa5_cs_n_out_odn_lsb_c   : integer := 0;
  constant pa5_cs_n_out_odn_msb_c   : integer := 0;
  subtype pa5_cs_n_out_odn_t is std_ulogic;
  constant pa5_cs_n_out_odn_reset_c : pa5_cs_n_out_odn_t := '0';
  constant pa5_cs_n_out_odn_scan_c  : pa5_cs_n_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa5_cs_n_in"
  constant pa5_cs_n_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pa5_cs_n_in_ste_size_c  : integer := 2;
  constant pa5_cs_n_in_ste_lsb_c   : integer := 2;
  constant pa5_cs_n_in_ste_msb_c   : integer := 3;
  subtype pa5_cs_n_in_ste_t is std_ulogic_vector(pa5_cs_n_in_ste_size_c - 1 downto 0);
  constant pa5_cs_n_in_ste_reset_c : pa5_cs_n_in_ste_t := std_ulogic_vector(to_unsigned(0, pa5_cs_n_in_ste_t'length));
  constant pa5_cs_n_in_ste_scan_c  : pa5_cs_n_in_ste_t := std_ulogic_vector(to_unsigned(0, pa5_cs_n_in_ste_t'length));

  -- Field "pd"
  constant pa5_cs_n_in_pd_size_c  : integer := 1;
  constant pa5_cs_n_in_pd_lsb_c   : integer := 1;
  constant pa5_cs_n_in_pd_msb_c   : integer := 1;
  subtype pa5_cs_n_in_pd_t is std_ulogic;
  constant pa5_cs_n_in_pd_reset_c : pa5_cs_n_in_pd_t := '0';
  constant pa5_cs_n_in_pd_scan_c  : pa5_cs_n_in_pd_t := '0';

  -- Field "pu"
  constant pa5_cs_n_in_pu_size_c  : integer := 1;
  constant pa5_cs_n_in_pu_lsb_c   : integer := 0;
  constant pa5_cs_n_in_pu_msb_c   : integer := 0;
  subtype pa5_cs_n_in_pu_t is std_ulogic;
  constant pa5_cs_n_in_pu_reset_c : pa5_cs_n_in_pu_t := '0';
  constant pa5_cs_n_in_pu_scan_c  : pa5_cs_n_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa6_sck_out"
  constant pa6_sck_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pa6_sck_out_ds_size_c  : integer := 2;
  constant pa6_sck_out_ds_lsb_c   : integer := 4;
  constant pa6_sck_out_ds_msb_c   : integer := 5;
  subtype pa6_sck_out_ds_t is std_ulogic_vector(pa6_sck_out_ds_size_c - 1 downto 0);
  constant pa6_sck_out_ds_reset_c : pa6_sck_out_ds_t := std_ulogic_vector(to_unsigned(2, pa6_sck_out_ds_t'length));
  constant pa6_sck_out_ds_scan_c  : pa6_sck_out_ds_t := std_ulogic_vector(to_unsigned(2, pa6_sck_out_ds_t'length));

  -- Field "sr"
  constant pa6_sck_out_sr_size_c  : integer := 1;
  constant pa6_sck_out_sr_lsb_c   : integer := 3;
  constant pa6_sck_out_sr_msb_c   : integer := 3;
  subtype pa6_sck_out_sr_t is std_ulogic;
  constant pa6_sck_out_sr_reset_c : pa6_sck_out_sr_t := '1';
  constant pa6_sck_out_sr_scan_c  : pa6_sck_out_sr_t := '1';

  -- Field "co"
  constant pa6_sck_out_co_size_c  : integer := 1;
  constant pa6_sck_out_co_lsb_c   : integer := 2;
  constant pa6_sck_out_co_msb_c   : integer := 2;
  subtype pa6_sck_out_co_t is std_ulogic;
  constant pa6_sck_out_co_reset_c : pa6_sck_out_co_t := '0';
  constant pa6_sck_out_co_scan_c  : pa6_sck_out_co_t := '0';

  -- Field "odp"
  constant pa6_sck_out_odp_size_c  : integer := 1;
  constant pa6_sck_out_odp_lsb_c   : integer := 1;
  constant pa6_sck_out_odp_msb_c   : integer := 1;
  subtype pa6_sck_out_odp_t is std_ulogic;
  constant pa6_sck_out_odp_reset_c : pa6_sck_out_odp_t := '0';
  constant pa6_sck_out_odp_scan_c  : pa6_sck_out_odp_t := '0';

  -- Field "odn"
  constant pa6_sck_out_odn_size_c  : integer := 1;
  constant pa6_sck_out_odn_lsb_c   : integer := 0;
  constant pa6_sck_out_odn_msb_c   : integer := 0;
  subtype pa6_sck_out_odn_t is std_ulogic;
  constant pa6_sck_out_odn_reset_c : pa6_sck_out_odn_t := '0';
  constant pa6_sck_out_odn_scan_c  : pa6_sck_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa6_sck_in"
  constant pa6_sck_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pa6_sck_in_ste_size_c  : integer := 2;
  constant pa6_sck_in_ste_lsb_c   : integer := 2;
  constant pa6_sck_in_ste_msb_c   : integer := 3;
  subtype pa6_sck_in_ste_t is std_ulogic_vector(pa6_sck_in_ste_size_c - 1 downto 0);
  constant pa6_sck_in_ste_reset_c : pa6_sck_in_ste_t := std_ulogic_vector(to_unsigned(0, pa6_sck_in_ste_t'length));
  constant pa6_sck_in_ste_scan_c  : pa6_sck_in_ste_t := std_ulogic_vector(to_unsigned(0, pa6_sck_in_ste_t'length));

  -- Field "pd"
  constant pa6_sck_in_pd_size_c  : integer := 1;
  constant pa6_sck_in_pd_lsb_c   : integer := 1;
  constant pa6_sck_in_pd_msb_c   : integer := 1;
  subtype pa6_sck_in_pd_t is std_ulogic;
  constant pa6_sck_in_pd_reset_c : pa6_sck_in_pd_t := '0';
  constant pa6_sck_in_pd_scan_c  : pa6_sck_in_pd_t := '0';

  -- Field "pu"
  constant pa6_sck_in_pu_size_c  : integer := 1;
  constant pa6_sck_in_pu_lsb_c   : integer := 0;
  constant pa6_sck_in_pu_msb_c   : integer := 0;
  subtype pa6_sck_in_pu_t is std_ulogic;
  constant pa6_sck_in_pu_reset_c : pa6_sck_in_pu_t := '0';
  constant pa6_sck_in_pu_scan_c  : pa6_sck_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa7_sout_out"
  constant pa7_sout_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pa7_sout_out_ds_size_c  : integer := 2;
  constant pa7_sout_out_ds_lsb_c   : integer := 4;
  constant pa7_sout_out_ds_msb_c   : integer := 5;
  subtype pa7_sout_out_ds_t is std_ulogic_vector(pa7_sout_out_ds_size_c - 1 downto 0);
  constant pa7_sout_out_ds_reset_c : pa7_sout_out_ds_t := std_ulogic_vector(to_unsigned(2, pa7_sout_out_ds_t'length));
  constant pa7_sout_out_ds_scan_c  : pa7_sout_out_ds_t := std_ulogic_vector(to_unsigned(2, pa7_sout_out_ds_t'length));

  -- Field "sr"
  constant pa7_sout_out_sr_size_c  : integer := 1;
  constant pa7_sout_out_sr_lsb_c   : integer := 3;
  constant pa7_sout_out_sr_msb_c   : integer := 3;
  subtype pa7_sout_out_sr_t is std_ulogic;
  constant pa7_sout_out_sr_reset_c : pa7_sout_out_sr_t := '1';
  constant pa7_sout_out_sr_scan_c  : pa7_sout_out_sr_t := '1';

  -- Field "co"
  constant pa7_sout_out_co_size_c  : integer := 1;
  constant pa7_sout_out_co_lsb_c   : integer := 2;
  constant pa7_sout_out_co_msb_c   : integer := 2;
  subtype pa7_sout_out_co_t is std_ulogic;
  constant pa7_sout_out_co_reset_c : pa7_sout_out_co_t := '0';
  constant pa7_sout_out_co_scan_c  : pa7_sout_out_co_t := '0';

  -- Field "odp"
  constant pa7_sout_out_odp_size_c  : integer := 1;
  constant pa7_sout_out_odp_lsb_c   : integer := 1;
  constant pa7_sout_out_odp_msb_c   : integer := 1;
  subtype pa7_sout_out_odp_t is std_ulogic;
  constant pa7_sout_out_odp_reset_c : pa7_sout_out_odp_t := '0';
  constant pa7_sout_out_odp_scan_c  : pa7_sout_out_odp_t := '0';

  -- Field "odn"
  constant pa7_sout_out_odn_size_c  : integer := 1;
  constant pa7_sout_out_odn_lsb_c   : integer := 0;
  constant pa7_sout_out_odn_msb_c   : integer := 0;
  subtype pa7_sout_out_odn_t is std_ulogic;
  constant pa7_sout_out_odn_reset_c : pa7_sout_out_odn_t := '0';
  constant pa7_sout_out_odn_scan_c  : pa7_sout_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pa7_sout_in"
  constant pa7_sout_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pa7_sout_in_ste_size_c  : integer := 2;
  constant pa7_sout_in_ste_lsb_c   : integer := 2;
  constant pa7_sout_in_ste_msb_c   : integer := 3;
  subtype pa7_sout_in_ste_t is std_ulogic_vector(pa7_sout_in_ste_size_c - 1 downto 0);
  constant pa7_sout_in_ste_reset_c : pa7_sout_in_ste_t := std_ulogic_vector(to_unsigned(0, pa7_sout_in_ste_t'length));
  constant pa7_sout_in_ste_scan_c  : pa7_sout_in_ste_t := std_ulogic_vector(to_unsigned(0, pa7_sout_in_ste_t'length));

  -- Field "pd"
  constant pa7_sout_in_pd_size_c  : integer := 1;
  constant pa7_sout_in_pd_lsb_c   : integer := 1;
  constant pa7_sout_in_pd_msb_c   : integer := 1;
  subtype pa7_sout_in_pd_t is std_ulogic;
  constant pa7_sout_in_pd_reset_c : pa7_sout_in_pd_t := '0';
  constant pa7_sout_in_pd_scan_c  : pa7_sout_in_pd_t := '0';

  -- Field "pu"
  constant pa7_sout_in_pu_size_c  : integer := 1;
  constant pa7_sout_in_pu_lsb_c   : integer := 0;
  constant pa7_sout_in_pu_msb_c   : integer := 0;
  subtype pa7_sout_in_pu_t is std_ulogic;
  constant pa7_sout_in_pu_reset_c : pa7_sout_in_pu_t := '0';
  constant pa7_sout_in_pu_scan_c  : pa7_sout_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg0_out"
  constant pg0_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg0_out_ds_size_c  : integer := 2;
  constant pg0_out_ds_lsb_c   : integer := 4;
  constant pg0_out_ds_msb_c   : integer := 5;
  subtype pg0_out_ds_t is std_ulogic_vector(pg0_out_ds_size_c - 1 downto 0);
  constant pg0_out_ds_reset_c : pg0_out_ds_t := std_ulogic_vector(to_unsigned(2, pg0_out_ds_t'length));
  constant pg0_out_ds_scan_c  : pg0_out_ds_t := std_ulogic_vector(to_unsigned(2, pg0_out_ds_t'length));

  -- Field "sr"
  constant pg0_out_sr_size_c  : integer := 1;
  constant pg0_out_sr_lsb_c   : integer := 3;
  constant pg0_out_sr_msb_c   : integer := 3;
  subtype pg0_out_sr_t is std_ulogic;
  constant pg0_out_sr_reset_c : pg0_out_sr_t := '1';
  constant pg0_out_sr_scan_c  : pg0_out_sr_t := '1';

  -- Field "co"
  constant pg0_out_co_size_c  : integer := 1;
  constant pg0_out_co_lsb_c   : integer := 2;
  constant pg0_out_co_msb_c   : integer := 2;
  subtype pg0_out_co_t is std_ulogic;
  constant pg0_out_co_reset_c : pg0_out_co_t := '0';
  constant pg0_out_co_scan_c  : pg0_out_co_t := '0';

  -- Field "odp"
  constant pg0_out_odp_size_c  : integer := 1;
  constant pg0_out_odp_lsb_c   : integer := 1;
  constant pg0_out_odp_msb_c   : integer := 1;
  subtype pg0_out_odp_t is std_ulogic;
  constant pg0_out_odp_reset_c : pg0_out_odp_t := '0';
  constant pg0_out_odp_scan_c  : pg0_out_odp_t := '0';

  -- Field "odn"
  constant pg0_out_odn_size_c  : integer := 1;
  constant pg0_out_odn_lsb_c   : integer := 0;
  constant pg0_out_odn_msb_c   : integer := 0;
  subtype pg0_out_odn_t is std_ulogic;
  constant pg0_out_odn_reset_c : pg0_out_odn_t := '0';
  constant pg0_out_odn_scan_c  : pg0_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg0_in"
  constant pg0_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg0_in_ste_size_c  : integer := 2;
  constant pg0_in_ste_lsb_c   : integer := 2;
  constant pg0_in_ste_msb_c   : integer := 3;
  subtype pg0_in_ste_t is std_ulogic_vector(pg0_in_ste_size_c - 1 downto 0);
  constant pg0_in_ste_reset_c : pg0_in_ste_t := std_ulogic_vector(to_unsigned(0, pg0_in_ste_t'length));
  constant pg0_in_ste_scan_c  : pg0_in_ste_t := std_ulogic_vector(to_unsigned(0, pg0_in_ste_t'length));

  -- Field "pd"
  constant pg0_in_pd_size_c  : integer := 1;
  constant pg0_in_pd_lsb_c   : integer := 1;
  constant pg0_in_pd_msb_c   : integer := 1;
  subtype pg0_in_pd_t is std_ulogic;
  constant pg0_in_pd_reset_c : pg0_in_pd_t := '0';
  constant pg0_in_pd_scan_c  : pg0_in_pd_t := '0';

  -- Field "pu"
  constant pg0_in_pu_size_c  : integer := 1;
  constant pg0_in_pu_lsb_c   : integer := 0;
  constant pg0_in_pu_msb_c   : integer := 0;
  subtype pg0_in_pu_t is std_ulogic;
  constant pg0_in_pu_reset_c : pg0_in_pu_t := '0';
  constant pg0_in_pu_scan_c  : pg0_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg1_out"
  constant pg1_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg1_out_ds_size_c  : integer := 2;
  constant pg1_out_ds_lsb_c   : integer := 4;
  constant pg1_out_ds_msb_c   : integer := 5;
  subtype pg1_out_ds_t is std_ulogic_vector(pg1_out_ds_size_c - 1 downto 0);
  constant pg1_out_ds_reset_c : pg1_out_ds_t := std_ulogic_vector(to_unsigned(2, pg1_out_ds_t'length));
  constant pg1_out_ds_scan_c  : pg1_out_ds_t := std_ulogic_vector(to_unsigned(2, pg1_out_ds_t'length));

  -- Field "sr"
  constant pg1_out_sr_size_c  : integer := 1;
  constant pg1_out_sr_lsb_c   : integer := 3;
  constant pg1_out_sr_msb_c   : integer := 3;
  subtype pg1_out_sr_t is std_ulogic;
  constant pg1_out_sr_reset_c : pg1_out_sr_t := '1';
  constant pg1_out_sr_scan_c  : pg1_out_sr_t := '1';

  -- Field "co"
  constant pg1_out_co_size_c  : integer := 1;
  constant pg1_out_co_lsb_c   : integer := 2;
  constant pg1_out_co_msb_c   : integer := 2;
  subtype pg1_out_co_t is std_ulogic;
  constant pg1_out_co_reset_c : pg1_out_co_t := '0';
  constant pg1_out_co_scan_c  : pg1_out_co_t := '0';

  -- Field "odp"
  constant pg1_out_odp_size_c  : integer := 1;
  constant pg1_out_odp_lsb_c   : integer := 1;
  constant pg1_out_odp_msb_c   : integer := 1;
  subtype pg1_out_odp_t is std_ulogic;
  constant pg1_out_odp_reset_c : pg1_out_odp_t := '0';
  constant pg1_out_odp_scan_c  : pg1_out_odp_t := '0';

  -- Field "odn"
  constant pg1_out_odn_size_c  : integer := 1;
  constant pg1_out_odn_lsb_c   : integer := 0;
  constant pg1_out_odn_msb_c   : integer := 0;
  subtype pg1_out_odn_t is std_ulogic;
  constant pg1_out_odn_reset_c : pg1_out_odn_t := '0';
  constant pg1_out_odn_scan_c  : pg1_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg1_in"
  constant pg1_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg1_in_ste_size_c  : integer := 2;
  constant pg1_in_ste_lsb_c   : integer := 2;
  constant pg1_in_ste_msb_c   : integer := 3;
  subtype pg1_in_ste_t is std_ulogic_vector(pg1_in_ste_size_c - 1 downto 0);
  constant pg1_in_ste_reset_c : pg1_in_ste_t := std_ulogic_vector(to_unsigned(0, pg1_in_ste_t'length));
  constant pg1_in_ste_scan_c  : pg1_in_ste_t := std_ulogic_vector(to_unsigned(0, pg1_in_ste_t'length));

  -- Field "pd"
  constant pg1_in_pd_size_c  : integer := 1;
  constant pg1_in_pd_lsb_c   : integer := 1;
  constant pg1_in_pd_msb_c   : integer := 1;
  subtype pg1_in_pd_t is std_ulogic;
  constant pg1_in_pd_reset_c : pg1_in_pd_t := '0';
  constant pg1_in_pd_scan_c  : pg1_in_pd_t := '0';

  -- Field "pu"
  constant pg1_in_pu_size_c  : integer := 1;
  constant pg1_in_pu_lsb_c   : integer := 0;
  constant pg1_in_pu_msb_c   : integer := 0;
  subtype pg1_in_pu_t is std_ulogic;
  constant pg1_in_pu_reset_c : pg1_in_pu_t := '0';
  constant pg1_in_pu_scan_c  : pg1_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg2_out"
  constant pg2_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg2_out_ds_size_c  : integer := 2;
  constant pg2_out_ds_lsb_c   : integer := 4;
  constant pg2_out_ds_msb_c   : integer := 5;
  subtype pg2_out_ds_t is std_ulogic_vector(pg2_out_ds_size_c - 1 downto 0);
  constant pg2_out_ds_reset_c : pg2_out_ds_t := std_ulogic_vector(to_unsigned(2, pg2_out_ds_t'length));
  constant pg2_out_ds_scan_c  : pg2_out_ds_t := std_ulogic_vector(to_unsigned(2, pg2_out_ds_t'length));

  -- Field "sr"
  constant pg2_out_sr_size_c  : integer := 1;
  constant pg2_out_sr_lsb_c   : integer := 3;
  constant pg2_out_sr_msb_c   : integer := 3;
  subtype pg2_out_sr_t is std_ulogic;
  constant pg2_out_sr_reset_c : pg2_out_sr_t := '1';
  constant pg2_out_sr_scan_c  : pg2_out_sr_t := '1';

  -- Field "co"
  constant pg2_out_co_size_c  : integer := 1;
  constant pg2_out_co_lsb_c   : integer := 2;
  constant pg2_out_co_msb_c   : integer := 2;
  subtype pg2_out_co_t is std_ulogic;
  constant pg2_out_co_reset_c : pg2_out_co_t := '0';
  constant pg2_out_co_scan_c  : pg2_out_co_t := '0';

  -- Field "odp"
  constant pg2_out_odp_size_c  : integer := 1;
  constant pg2_out_odp_lsb_c   : integer := 1;
  constant pg2_out_odp_msb_c   : integer := 1;
  subtype pg2_out_odp_t is std_ulogic;
  constant pg2_out_odp_reset_c : pg2_out_odp_t := '0';
  constant pg2_out_odp_scan_c  : pg2_out_odp_t := '0';

  -- Field "odn"
  constant pg2_out_odn_size_c  : integer := 1;
  constant pg2_out_odn_lsb_c   : integer := 0;
  constant pg2_out_odn_msb_c   : integer := 0;
  subtype pg2_out_odn_t is std_ulogic;
  constant pg2_out_odn_reset_c : pg2_out_odn_t := '0';
  constant pg2_out_odn_scan_c  : pg2_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg2_in"
  constant pg2_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg2_in_ste_size_c  : integer := 2;
  constant pg2_in_ste_lsb_c   : integer := 2;
  constant pg2_in_ste_msb_c   : integer := 3;
  subtype pg2_in_ste_t is std_ulogic_vector(pg2_in_ste_size_c - 1 downto 0);
  constant pg2_in_ste_reset_c : pg2_in_ste_t := std_ulogic_vector(to_unsigned(0, pg2_in_ste_t'length));
  constant pg2_in_ste_scan_c  : pg2_in_ste_t := std_ulogic_vector(to_unsigned(0, pg2_in_ste_t'length));

  -- Field "pd"
  constant pg2_in_pd_size_c  : integer := 1;
  constant pg2_in_pd_lsb_c   : integer := 1;
  constant pg2_in_pd_msb_c   : integer := 1;
  subtype pg2_in_pd_t is std_ulogic;
  constant pg2_in_pd_reset_c : pg2_in_pd_t := '0';
  constant pg2_in_pd_scan_c  : pg2_in_pd_t := '0';

  -- Field "pu"
  constant pg2_in_pu_size_c  : integer := 1;
  constant pg2_in_pu_lsb_c   : integer := 0;
  constant pg2_in_pu_msb_c   : integer := 0;
  subtype pg2_in_pu_t is std_ulogic;
  constant pg2_in_pu_reset_c : pg2_in_pu_t := '0';
  constant pg2_in_pu_scan_c  : pg2_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg3_out"
  constant pg3_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg3_out_ds_size_c  : integer := 2;
  constant pg3_out_ds_lsb_c   : integer := 4;
  constant pg3_out_ds_msb_c   : integer := 5;
  subtype pg3_out_ds_t is std_ulogic_vector(pg3_out_ds_size_c - 1 downto 0);
  constant pg3_out_ds_reset_c : pg3_out_ds_t := std_ulogic_vector(to_unsigned(2, pg3_out_ds_t'length));
  constant pg3_out_ds_scan_c  : pg3_out_ds_t := std_ulogic_vector(to_unsigned(2, pg3_out_ds_t'length));

  -- Field "sr"
  constant pg3_out_sr_size_c  : integer := 1;
  constant pg3_out_sr_lsb_c   : integer := 3;
  constant pg3_out_sr_msb_c   : integer := 3;
  subtype pg3_out_sr_t is std_ulogic;
  constant pg3_out_sr_reset_c : pg3_out_sr_t := '1';
  constant pg3_out_sr_scan_c  : pg3_out_sr_t := '1';

  -- Field "co"
  constant pg3_out_co_size_c  : integer := 1;
  constant pg3_out_co_lsb_c   : integer := 2;
  constant pg3_out_co_msb_c   : integer := 2;
  subtype pg3_out_co_t is std_ulogic;
  constant pg3_out_co_reset_c : pg3_out_co_t := '0';
  constant pg3_out_co_scan_c  : pg3_out_co_t := '0';

  -- Field "odp"
  constant pg3_out_odp_size_c  : integer := 1;
  constant pg3_out_odp_lsb_c   : integer := 1;
  constant pg3_out_odp_msb_c   : integer := 1;
  subtype pg3_out_odp_t is std_ulogic;
  constant pg3_out_odp_reset_c : pg3_out_odp_t := '0';
  constant pg3_out_odp_scan_c  : pg3_out_odp_t := '0';

  -- Field "odn"
  constant pg3_out_odn_size_c  : integer := 1;
  constant pg3_out_odn_lsb_c   : integer := 0;
  constant pg3_out_odn_msb_c   : integer := 0;
  subtype pg3_out_odn_t is std_ulogic;
  constant pg3_out_odn_reset_c : pg3_out_odn_t := '0';
  constant pg3_out_odn_scan_c  : pg3_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg3_in"
  constant pg3_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg3_in_ste_size_c  : integer := 2;
  constant pg3_in_ste_lsb_c   : integer := 2;
  constant pg3_in_ste_msb_c   : integer := 3;
  subtype pg3_in_ste_t is std_ulogic_vector(pg3_in_ste_size_c - 1 downto 0);
  constant pg3_in_ste_reset_c : pg3_in_ste_t := std_ulogic_vector(to_unsigned(0, pg3_in_ste_t'length));
  constant pg3_in_ste_scan_c  : pg3_in_ste_t := std_ulogic_vector(to_unsigned(0, pg3_in_ste_t'length));

  -- Field "pd"
  constant pg3_in_pd_size_c  : integer := 1;
  constant pg3_in_pd_lsb_c   : integer := 1;
  constant pg3_in_pd_msb_c   : integer := 1;
  subtype pg3_in_pd_t is std_ulogic;
  constant pg3_in_pd_reset_c : pg3_in_pd_t := '0';
  constant pg3_in_pd_scan_c  : pg3_in_pd_t := '0';

  -- Field "pu"
  constant pg3_in_pu_size_c  : integer := 1;
  constant pg3_in_pu_lsb_c   : integer := 0;
  constant pg3_in_pu_msb_c   : integer := 0;
  subtype pg3_in_pu_t is std_ulogic;
  constant pg3_in_pu_reset_c : pg3_in_pu_t := '0';
  constant pg3_in_pu_scan_c  : pg3_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg4_out"
  constant pg4_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg4_out_ds_size_c  : integer := 2;
  constant pg4_out_ds_lsb_c   : integer := 4;
  constant pg4_out_ds_msb_c   : integer := 5;
  subtype pg4_out_ds_t is std_ulogic_vector(pg4_out_ds_size_c - 1 downto 0);
  constant pg4_out_ds_reset_c : pg4_out_ds_t := std_ulogic_vector(to_unsigned(2, pg4_out_ds_t'length));
  constant pg4_out_ds_scan_c  : pg4_out_ds_t := std_ulogic_vector(to_unsigned(2, pg4_out_ds_t'length));

  -- Field "sr"
  constant pg4_out_sr_size_c  : integer := 1;
  constant pg4_out_sr_lsb_c   : integer := 3;
  constant pg4_out_sr_msb_c   : integer := 3;
  subtype pg4_out_sr_t is std_ulogic;
  constant pg4_out_sr_reset_c : pg4_out_sr_t := '1';
  constant pg4_out_sr_scan_c  : pg4_out_sr_t := '1';

  -- Field "co"
  constant pg4_out_co_size_c  : integer := 1;
  constant pg4_out_co_lsb_c   : integer := 2;
  constant pg4_out_co_msb_c   : integer := 2;
  subtype pg4_out_co_t is std_ulogic;
  constant pg4_out_co_reset_c : pg4_out_co_t := '0';
  constant pg4_out_co_scan_c  : pg4_out_co_t := '0';

  -- Field "odp"
  constant pg4_out_odp_size_c  : integer := 1;
  constant pg4_out_odp_lsb_c   : integer := 1;
  constant pg4_out_odp_msb_c   : integer := 1;
  subtype pg4_out_odp_t is std_ulogic;
  constant pg4_out_odp_reset_c : pg4_out_odp_t := '0';
  constant pg4_out_odp_scan_c  : pg4_out_odp_t := '0';

  -- Field "odn"
  constant pg4_out_odn_size_c  : integer := 1;
  constant pg4_out_odn_lsb_c   : integer := 0;
  constant pg4_out_odn_msb_c   : integer := 0;
  subtype pg4_out_odn_t is std_ulogic;
  constant pg4_out_odn_reset_c : pg4_out_odn_t := '0';
  constant pg4_out_odn_scan_c  : pg4_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg4_in"
  constant pg4_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg4_in_ste_size_c  : integer := 2;
  constant pg4_in_ste_lsb_c   : integer := 2;
  constant pg4_in_ste_msb_c   : integer := 3;
  subtype pg4_in_ste_t is std_ulogic_vector(pg4_in_ste_size_c - 1 downto 0);
  constant pg4_in_ste_reset_c : pg4_in_ste_t := std_ulogic_vector(to_unsigned(0, pg4_in_ste_t'length));
  constant pg4_in_ste_scan_c  : pg4_in_ste_t := std_ulogic_vector(to_unsigned(0, pg4_in_ste_t'length));

  -- Field "pd"
  constant pg4_in_pd_size_c  : integer := 1;
  constant pg4_in_pd_lsb_c   : integer := 1;
  constant pg4_in_pd_msb_c   : integer := 1;
  subtype pg4_in_pd_t is std_ulogic;
  constant pg4_in_pd_reset_c : pg4_in_pd_t := '0';
  constant pg4_in_pd_scan_c  : pg4_in_pd_t := '0';

  -- Field "pu"
  constant pg4_in_pu_size_c  : integer := 1;
  constant pg4_in_pu_lsb_c   : integer := 0;
  constant pg4_in_pu_msb_c   : integer := 0;
  subtype pg4_in_pu_t is std_ulogic;
  constant pg4_in_pu_reset_c : pg4_in_pu_t := '0';
  constant pg4_in_pu_scan_c  : pg4_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg5_out"
  constant pg5_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg5_out_ds_size_c  : integer := 2;
  constant pg5_out_ds_lsb_c   : integer := 4;
  constant pg5_out_ds_msb_c   : integer := 5;
  subtype pg5_out_ds_t is std_ulogic_vector(pg5_out_ds_size_c - 1 downto 0);
  constant pg5_out_ds_reset_c : pg5_out_ds_t := std_ulogic_vector(to_unsigned(2, pg5_out_ds_t'length));
  constant pg5_out_ds_scan_c  : pg5_out_ds_t := std_ulogic_vector(to_unsigned(2, pg5_out_ds_t'length));

  -- Field "sr"
  constant pg5_out_sr_size_c  : integer := 1;
  constant pg5_out_sr_lsb_c   : integer := 3;
  constant pg5_out_sr_msb_c   : integer := 3;
  subtype pg5_out_sr_t is std_ulogic;
  constant pg5_out_sr_reset_c : pg5_out_sr_t := '1';
  constant pg5_out_sr_scan_c  : pg5_out_sr_t := '1';

  -- Field "co"
  constant pg5_out_co_size_c  : integer := 1;
  constant pg5_out_co_lsb_c   : integer := 2;
  constant pg5_out_co_msb_c   : integer := 2;
  subtype pg5_out_co_t is std_ulogic;
  constant pg5_out_co_reset_c : pg5_out_co_t := '0';
  constant pg5_out_co_scan_c  : pg5_out_co_t := '0';

  -- Field "odp"
  constant pg5_out_odp_size_c  : integer := 1;
  constant pg5_out_odp_lsb_c   : integer := 1;
  constant pg5_out_odp_msb_c   : integer := 1;
  subtype pg5_out_odp_t is std_ulogic;
  constant pg5_out_odp_reset_c : pg5_out_odp_t := '0';
  constant pg5_out_odp_scan_c  : pg5_out_odp_t := '0';

  -- Field "odn"
  constant pg5_out_odn_size_c  : integer := 1;
  constant pg5_out_odn_lsb_c   : integer := 0;
  constant pg5_out_odn_msb_c   : integer := 0;
  subtype pg5_out_odn_t is std_ulogic;
  constant pg5_out_odn_reset_c : pg5_out_odn_t := '0';
  constant pg5_out_odn_scan_c  : pg5_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg5_in"
  constant pg5_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg5_in_ste_size_c  : integer := 2;
  constant pg5_in_ste_lsb_c   : integer := 2;
  constant pg5_in_ste_msb_c   : integer := 3;
  subtype pg5_in_ste_t is std_ulogic_vector(pg5_in_ste_size_c - 1 downto 0);
  constant pg5_in_ste_reset_c : pg5_in_ste_t := std_ulogic_vector(to_unsigned(0, pg5_in_ste_t'length));
  constant pg5_in_ste_scan_c  : pg5_in_ste_t := std_ulogic_vector(to_unsigned(0, pg5_in_ste_t'length));

  -- Field "pd"
  constant pg5_in_pd_size_c  : integer := 1;
  constant pg5_in_pd_lsb_c   : integer := 1;
  constant pg5_in_pd_msb_c   : integer := 1;
  subtype pg5_in_pd_t is std_ulogic;
  constant pg5_in_pd_reset_c : pg5_in_pd_t := '0';
  constant pg5_in_pd_scan_c  : pg5_in_pd_t := '0';

  -- Field "pu"
  constant pg5_in_pu_size_c  : integer := 1;
  constant pg5_in_pu_lsb_c   : integer := 0;
  constant pg5_in_pu_msb_c   : integer := 0;
  subtype pg5_in_pu_t is std_ulogic;
  constant pg5_in_pu_reset_c : pg5_in_pu_t := '0';
  constant pg5_in_pu_scan_c  : pg5_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg6_out"
  constant pg6_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg6_out_ds_size_c  : integer := 2;
  constant pg6_out_ds_lsb_c   : integer := 4;
  constant pg6_out_ds_msb_c   : integer := 5;
  subtype pg6_out_ds_t is std_ulogic_vector(pg6_out_ds_size_c - 1 downto 0);
  constant pg6_out_ds_reset_c : pg6_out_ds_t := std_ulogic_vector(to_unsigned(2, pg6_out_ds_t'length));
  constant pg6_out_ds_scan_c  : pg6_out_ds_t := std_ulogic_vector(to_unsigned(2, pg6_out_ds_t'length));

  -- Field "sr"
  constant pg6_out_sr_size_c  : integer := 1;
  constant pg6_out_sr_lsb_c   : integer := 3;
  constant pg6_out_sr_msb_c   : integer := 3;
  subtype pg6_out_sr_t is std_ulogic;
  constant pg6_out_sr_reset_c : pg6_out_sr_t := '1';
  constant pg6_out_sr_scan_c  : pg6_out_sr_t := '1';

  -- Field "co"
  constant pg6_out_co_size_c  : integer := 1;
  constant pg6_out_co_lsb_c   : integer := 2;
  constant pg6_out_co_msb_c   : integer := 2;
  subtype pg6_out_co_t is std_ulogic;
  constant pg6_out_co_reset_c : pg6_out_co_t := '0';
  constant pg6_out_co_scan_c  : pg6_out_co_t := '0';

  -- Field "odp"
  constant pg6_out_odp_size_c  : integer := 1;
  constant pg6_out_odp_lsb_c   : integer := 1;
  constant pg6_out_odp_msb_c   : integer := 1;
  subtype pg6_out_odp_t is std_ulogic;
  constant pg6_out_odp_reset_c : pg6_out_odp_t := '0';
  constant pg6_out_odp_scan_c  : pg6_out_odp_t := '0';

  -- Field "odn"
  constant pg6_out_odn_size_c  : integer := 1;
  constant pg6_out_odn_lsb_c   : integer := 0;
  constant pg6_out_odn_msb_c   : integer := 0;
  subtype pg6_out_odn_t is std_ulogic;
  constant pg6_out_odn_reset_c : pg6_out_odn_t := '0';
  constant pg6_out_odn_scan_c  : pg6_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg6_in"
  constant pg6_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg6_in_ste_size_c  : integer := 2;
  constant pg6_in_ste_lsb_c   : integer := 2;
  constant pg6_in_ste_msb_c   : integer := 3;
  subtype pg6_in_ste_t is std_ulogic_vector(pg6_in_ste_size_c - 1 downto 0);
  constant pg6_in_ste_reset_c : pg6_in_ste_t := std_ulogic_vector(to_unsigned(0, pg6_in_ste_t'length));
  constant pg6_in_ste_scan_c  : pg6_in_ste_t := std_ulogic_vector(to_unsigned(0, pg6_in_ste_t'length));

  -- Field "pd"
  constant pg6_in_pd_size_c  : integer := 1;
  constant pg6_in_pd_lsb_c   : integer := 1;
  constant pg6_in_pd_msb_c   : integer := 1;
  subtype pg6_in_pd_t is std_ulogic;
  constant pg6_in_pd_reset_c : pg6_in_pd_t := '0';
  constant pg6_in_pd_scan_c  : pg6_in_pd_t := '0';

  -- Field "pu"
  constant pg6_in_pu_size_c  : integer := 1;
  constant pg6_in_pu_lsb_c   : integer := 0;
  constant pg6_in_pu_msb_c   : integer := 0;
  subtype pg6_in_pu_t is std_ulogic;
  constant pg6_in_pu_reset_c : pg6_in_pu_t := '0';
  constant pg6_in_pu_scan_c  : pg6_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg7_out"
  constant pg7_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant pg7_out_ds_size_c  : integer := 2;
  constant pg7_out_ds_lsb_c   : integer := 4;
  constant pg7_out_ds_msb_c   : integer := 5;
  subtype pg7_out_ds_t is std_ulogic_vector(pg7_out_ds_size_c - 1 downto 0);
  constant pg7_out_ds_reset_c : pg7_out_ds_t := std_ulogic_vector(to_unsigned(2, pg7_out_ds_t'length));
  constant pg7_out_ds_scan_c  : pg7_out_ds_t := std_ulogic_vector(to_unsigned(2, pg7_out_ds_t'length));

  -- Field "sr"
  constant pg7_out_sr_size_c  : integer := 1;
  constant pg7_out_sr_lsb_c   : integer := 3;
  constant pg7_out_sr_msb_c   : integer := 3;
  subtype pg7_out_sr_t is std_ulogic;
  constant pg7_out_sr_reset_c : pg7_out_sr_t := '1';
  constant pg7_out_sr_scan_c  : pg7_out_sr_t := '1';

  -- Field "co"
  constant pg7_out_co_size_c  : integer := 1;
  constant pg7_out_co_lsb_c   : integer := 2;
  constant pg7_out_co_msb_c   : integer := 2;
  subtype pg7_out_co_t is std_ulogic;
  constant pg7_out_co_reset_c : pg7_out_co_t := '0';
  constant pg7_out_co_scan_c  : pg7_out_co_t := '0';

  -- Field "odp"
  constant pg7_out_odp_size_c  : integer := 1;
  constant pg7_out_odp_lsb_c   : integer := 1;
  constant pg7_out_odp_msb_c   : integer := 1;
  subtype pg7_out_odp_t is std_ulogic;
  constant pg7_out_odp_reset_c : pg7_out_odp_t := '0';
  constant pg7_out_odp_scan_c  : pg7_out_odp_t := '0';

  -- Field "odn"
  constant pg7_out_odn_size_c  : integer := 1;
  constant pg7_out_odn_lsb_c   : integer := 0;
  constant pg7_out_odn_msb_c   : integer := 0;
  subtype pg7_out_odn_t is std_ulogic;
  constant pg7_out_odn_reset_c : pg7_out_odn_t := '0';
  constant pg7_out_odn_scan_c  : pg7_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pg7_in"
  constant pg7_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant pg7_in_ste_size_c  : integer := 2;
  constant pg7_in_ste_lsb_c   : integer := 2;
  constant pg7_in_ste_msb_c   : integer := 3;
  subtype pg7_in_ste_t is std_ulogic_vector(pg7_in_ste_size_c - 1 downto 0);
  constant pg7_in_ste_reset_c : pg7_in_ste_t := std_ulogic_vector(to_unsigned(0, pg7_in_ste_t'length));
  constant pg7_in_ste_scan_c  : pg7_in_ste_t := std_ulogic_vector(to_unsigned(0, pg7_in_ste_t'length));

  -- Field "pd"
  constant pg7_in_pd_size_c  : integer := 1;
  constant pg7_in_pd_lsb_c   : integer := 1;
  constant pg7_in_pd_msb_c   : integer := 1;
  subtype pg7_in_pd_t is std_ulogic;
  constant pg7_in_pd_reset_c : pg7_in_pd_t := '0';
  constant pg7_in_pd_scan_c  : pg7_in_pd_t := '0';

  -- Field "pu"
  constant pg7_in_pu_size_c  : integer := 1;
  constant pg7_in_pu_lsb_c   : integer := 0;
  constant pg7_in_pu_msb_c   : integer := 0;
  subtype pg7_in_pu_t is std_ulogic;
  constant pg7_in_pu_reset_c : pg7_in_pu_t := '0';
  constant pg7_in_pu_scan_c  : pg7_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mtest"
  constant mtest_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant mtest_ste_size_c  : integer := 2;
  constant mtest_ste_lsb_c   : integer := 2;
  constant mtest_ste_msb_c   : integer := 3;
  subtype mtest_ste_t is std_ulogic_vector(mtest_ste_size_c - 1 downto 0);
  constant mtest_ste_reset_c : mtest_ste_t := std_ulogic_vector(to_unsigned(0, mtest_ste_t'length));
  constant mtest_ste_scan_c  : mtest_ste_t := std_ulogic_vector(to_unsigned(0, mtest_ste_t'length));

  -- Field "pd"
  constant mtest_pd_size_c  : integer := 1;
  constant mtest_pd_lsb_c   : integer := 1;
  constant mtest_pd_msb_c   : integer := 1;
  subtype mtest_pd_t is std_ulogic;
  constant mtest_pd_reset_c : mtest_pd_t := '0';
  constant mtest_pd_scan_c  : mtest_pd_t := '0';

  -- Field "pu"
  constant mtest_pu_size_c  : integer := 1;
  constant mtest_pu_lsb_c   : integer := 0;
  constant mtest_pu_msb_c   : integer := 0;
  subtype mtest_pu_t is std_ulogic;
  constant mtest_pu_reset_c : mtest_pu_t := '0';
  constant mtest_pu_scan_c  : mtest_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mwake"
  constant mwake_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant mwake_ste_size_c  : integer := 2;
  constant mwake_ste_lsb_c   : integer := 2;
  constant mwake_ste_msb_c   : integer := 3;
  subtype mwake_ste_t is std_ulogic_vector(mwake_ste_size_c - 1 downto 0);
  constant mwake_ste_reset_c : mwake_ste_t := std_ulogic_vector(to_unsigned(0, mwake_ste_t'length));
  constant mwake_ste_scan_c  : mwake_ste_t := std_ulogic_vector(to_unsigned(0, mwake_ste_t'length));

  -- Field "pd"
  constant mwake_pd_size_c  : integer := 1;
  constant mwake_pd_lsb_c   : integer := 1;
  constant mwake_pd_msb_c   : integer := 1;
  subtype mwake_pd_t is std_ulogic;
  constant mwake_pd_reset_c : mwake_pd_t := '0';
  constant mwake_pd_scan_c  : mwake_pd_t := '0';

  -- Field "pu"
  constant mwake_pu_size_c  : integer := 1;
  constant mwake_pu_lsb_c   : integer := 0;
  constant mwake_pu_msb_c   : integer := 0;
  subtype mwake_pu_t is std_ulogic;
  constant mwake_pu_reset_c : mwake_pu_t := '0';
  constant mwake_pu_scan_c  : mwake_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mrxout"
  constant mrxout_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant mrxout_ds_size_c  : integer := 2;
  constant mrxout_ds_lsb_c   : integer := 4;
  constant mrxout_ds_msb_c   : integer := 5;
  subtype mrxout_ds_t is std_ulogic_vector(mrxout_ds_size_c - 1 downto 0);
  constant mrxout_ds_reset_c : mrxout_ds_t := std_ulogic_vector(to_unsigned(2, mrxout_ds_t'length));
  constant mrxout_ds_scan_c  : mrxout_ds_t := std_ulogic_vector(to_unsigned(2, mrxout_ds_t'length));

  -- Field "sr"
  constant mrxout_sr_size_c  : integer := 1;
  constant mrxout_sr_lsb_c   : integer := 3;
  constant mrxout_sr_msb_c   : integer := 3;
  subtype mrxout_sr_t is std_ulogic;
  constant mrxout_sr_reset_c : mrxout_sr_t := '1';
  constant mrxout_sr_scan_c  : mrxout_sr_t := '1';

  -- Field "co"
  constant mrxout_co_size_c  : integer := 1;
  constant mrxout_co_lsb_c   : integer := 2;
  constant mrxout_co_msb_c   : integer := 2;
  subtype mrxout_co_t is std_ulogic;
  constant mrxout_co_reset_c : mrxout_co_t := '0';
  constant mrxout_co_scan_c  : mrxout_co_t := '0';

  -- Field "odp"
  constant mrxout_odp_size_c  : integer := 1;
  constant mrxout_odp_lsb_c   : integer := 1;
  constant mrxout_odp_msb_c   : integer := 1;
  subtype mrxout_odp_t is std_ulogic;
  constant mrxout_odp_reset_c : mrxout_odp_t := '0';
  constant mrxout_odp_scan_c  : mrxout_odp_t := '0';

  -- Field "odn"
  constant mrxout_odn_size_c  : integer := 1;
  constant mrxout_odn_lsb_c   : integer := 0;
  constant mrxout_odn_msb_c   : integer := 0;
  subtype mrxout_odn_t is std_ulogic;
  constant mrxout_odn_reset_c : mrxout_odn_t := '0';
  constant mrxout_odn_scan_c  : mrxout_odn_t := '0';

  component register_block_spi_test

    port (
          clk   : in std_ulogic;
          rst_n : in std_ulogic;

          -- Registerfields
          version_analog : in  version_analog_t;
          version_digital : in  version_digital_t;
          mclkout_ds : out mclkout_ds_t;
          mclkout_sr : out mclkout_sr_t;
          mclkout_co : out mclkout_co_t;
          mclkout_odp : out mclkout_odp_t;
          mclkout_odn : out mclkout_odn_t;
          msdout_ds : out msdout_ds_t;
          msdout_sr : out msdout_sr_t;
          msdout_co : out msdout_co_t;
          msdout_odp : out msdout_odp_t;
          msdout_odn : out msdout_odn_t;
          utx_ds : out utx_ds_t;
          utx_sr : out utx_sr_t;
          utx_co : out utx_co_t;
          utx_odp : out utx_odp_t;
          utx_odn : out utx_odn_t;
          mirqout_ds : out mirqout_ds_t;
          mirqout_sr : out mirqout_sr_t;
          mirqout_co : out mirqout_co_t;
          mirqout_odp : out mirqout_odp_t;
          mirqout_odn : out mirqout_odn_t;
          msdin_ste : out msdin_ste_t;
          msdin_pd : out msdin_pd_t;
          msdin_pu : out msdin_pu_t;
          mirq0_ste : out mirq0_ste_t;
          mirq0_pd : out mirq0_pd_t;
          mirq0_pu : out mirq0_pu_t;
          mirq1_ste : out mirq1_ste_t;
          mirq1_pd : out mirq1_pd_t;
          mirq1_pu : out mirq1_pu_t;
          urx_ste : out urx_ste_t;
          urx_pd : out urx_pd_t;
          urx_pu : out urx_pu_t;
          emem_d0_out_ds : out emem_d0_out_ds_t;
          emem_d0_out_sr : out emem_d0_out_sr_t;
          emem_d0_out_co : out emem_d0_out_co_t;
          emem_d0_out_odp : out emem_d0_out_odp_t;
          emem_d0_out_odn : out emem_d0_out_odn_t;
          emem_d0_in_ste : out emem_d0_in_ste_t;
          emem_d0_in_pd : out emem_d0_in_pd_t;
          emem_d0_in_pu : out emem_d0_in_pu_t;
          emem_d1_out_ds : out emem_d1_out_ds_t;
          emem_d1_out_sr : out emem_d1_out_sr_t;
          emem_d1_out_co : out emem_d1_out_co_t;
          emem_d1_out_odp : out emem_d1_out_odp_t;
          emem_d1_out_odn : out emem_d1_out_odn_t;
          emem_d1_in_ste : out emem_d1_in_ste_t;
          emem_d1_in_pd : out emem_d1_in_pd_t;
          emem_d1_in_pu : out emem_d1_in_pu_t;
          emem_d2_out_ds : out emem_d2_out_ds_t;
          emem_d2_out_sr : out emem_d2_out_sr_t;
          emem_d2_out_co : out emem_d2_out_co_t;
          emem_d2_out_odp : out emem_d2_out_odp_t;
          emem_d2_out_odn : out emem_d2_out_odn_t;
          emem_d2_in_ste : out emem_d2_in_ste_t;
          emem_d2_in_pd : out emem_d2_in_pd_t;
          emem_d2_in_pu : out emem_d2_in_pu_t;
          emem_d3_out_ds : out emem_d3_out_ds_t;
          emem_d3_out_sr : out emem_d3_out_sr_t;
          emem_d3_out_co : out emem_d3_out_co_t;
          emem_d3_out_odp : out emem_d3_out_odp_t;
          emem_d3_out_odn : out emem_d3_out_odn_t;
          emem_d3_in_ste : out emem_d3_in_ste_t;
          emem_d3_in_pd : out emem_d3_in_pd_t;
          emem_d3_in_pu : out emem_d3_in_pu_t;
          emem_d4_out_ds : out emem_d4_out_ds_t;
          emem_d4_out_sr : out emem_d4_out_sr_t;
          emem_d4_out_co : out emem_d4_out_co_t;
          emem_d4_out_odp : out emem_d4_out_odp_t;
          emem_d4_out_odn : out emem_d4_out_odn_t;
          emem_d4_in_ste : out emem_d4_in_ste_t;
          emem_d4_in_pd : out emem_d4_in_pd_t;
          emem_d4_in_pu : out emem_d4_in_pu_t;
          emem_d5_out_ds : out emem_d5_out_ds_t;
          emem_d5_out_sr : out emem_d5_out_sr_t;
          emem_d5_out_co : out emem_d5_out_co_t;
          emem_d5_out_odp : out emem_d5_out_odp_t;
          emem_d5_out_odn : out emem_d5_out_odn_t;
          emem_d5_in_ste : out emem_d5_in_ste_t;
          emem_d5_in_pd : out emem_d5_in_pd_t;
          emem_d5_in_pu : out emem_d5_in_pu_t;
          emem_d6_out_ds : out emem_d6_out_ds_t;
          emem_d6_out_sr : out emem_d6_out_sr_t;
          emem_d6_out_co : out emem_d6_out_co_t;
          emem_d6_out_odp : out emem_d6_out_odp_t;
          emem_d6_out_odn : out emem_d6_out_odn_t;
          emem_d6_in_ste : out emem_d6_in_ste_t;
          emem_d6_in_pd : out emem_d6_in_pd_t;
          emem_d6_in_pu : out emem_d6_in_pu_t;
          emem_d7_out_ds : out emem_d7_out_ds_t;
          emem_d7_out_sr : out emem_d7_out_sr_t;
          emem_d7_out_co : out emem_d7_out_co_t;
          emem_d7_out_odp : out emem_d7_out_odp_t;
          emem_d7_out_odn : out emem_d7_out_odn_t;
          emem_d7_in_ste : out emem_d7_in_ste_t;
          emem_d7_in_pd : out emem_d7_in_pd_t;
          emem_d7_in_pu : out emem_d7_in_pu_t;
          emem_clk_ds : out emem_clk_ds_t;
          emem_clk_sr : out emem_clk_sr_t;
          emem_clk_co : out emem_clk_co_t;
          emem_clk_odp : out emem_clk_odp_t;
          emem_clk_odn : out emem_clk_odn_t;
          emem_rwds_out_ds : out emem_rwds_out_ds_t;
          emem_rwds_out_sr : out emem_rwds_out_sr_t;
          emem_rwds_out_co : out emem_rwds_out_co_t;
          emem_rwds_out_odp : out emem_rwds_out_odp_t;
          emem_rwds_out_odn : out emem_rwds_out_odn_t;
          emem_rwds_in_ste : out emem_rwds_in_ste_t;
          emem_rwds_in_pd : out emem_rwds_in_pd_t;
          emem_rwds_in_pu : out emem_rwds_in_pu_t;
          emem_cs_n_ds : out emem_cs_n_ds_t;
          emem_cs_n_sr : out emem_cs_n_sr_t;
          emem_cs_n_co : out emem_cs_n_co_t;
          emem_cs_n_odp : out emem_cs_n_odp_t;
          emem_cs_n_odn : out emem_cs_n_odn_t;
          emem_rst_n_ds : out emem_rst_n_ds_t;
          emem_rst_n_sr : out emem_rst_n_sr_t;
          emem_rst_n_co : out emem_rst_n_co_t;
          emem_rst_n_odp : out emem_rst_n_odp_t;
          emem_rst_n_odn : out emem_rst_n_odn_t;
          aout0_ds : out aout0_ds_t;
          aout0_sr : out aout0_sr_t;
          aout0_co : out aout0_co_t;
          aout0_odp : out aout0_odp_t;
          aout0_odn : out aout0_odn_t;
          aout1_ds : out aout1_ds_t;
          aout1_sr : out aout1_sr_t;
          aout1_co : out aout1_co_t;
          aout1_odp : out aout1_odp_t;
          aout1_odn : out aout1_odn_t;
          ach0_ste : out ach0_ste_t;
          ach0_pd : out ach0_pd_t;
          ach0_pu : out ach0_pu_t;
          enet_mdio_out_ds : out enet_mdio_out_ds_t;
          enet_mdio_out_sr : out enet_mdio_out_sr_t;
          enet_mdio_out_co : out enet_mdio_out_co_t;
          enet_mdio_out_odp : out enet_mdio_out_odp_t;
          enet_mdio_out_odn : out enet_mdio_out_odn_t;
          enet_mdio_in_ste : out enet_mdio_in_ste_t;
          enet_mdio_in_pd : out enet_mdio_in_pd_t;
          enet_mdio_in_pu : out enet_mdio_in_pu_t;
          enet_mdc_ds : out enet_mdc_ds_t;
          enet_mdc_sr : out enet_mdc_sr_t;
          enet_mdc_co : out enet_mdc_co_t;
          enet_mdc_odp : out enet_mdc_odp_t;
          enet_mdc_odn : out enet_mdc_odn_t;
          enet_txer_ds : out enet_txer_ds_t;
          enet_txer_sr : out enet_txer_sr_t;
          enet_txer_co : out enet_txer_co_t;
          enet_txer_odp : out enet_txer_odp_t;
          enet_txer_odn : out enet_txer_odn_t;
          enet_txd0_ds : out enet_txd0_ds_t;
          enet_txd0_sr : out enet_txd0_sr_t;
          enet_txd0_co : out enet_txd0_co_t;
          enet_txd0_odp : out enet_txd0_odp_t;
          enet_txd0_odn : out enet_txd0_odn_t;
          enet_txd1_ds : out enet_txd1_ds_t;
          enet_txd1_sr : out enet_txd1_sr_t;
          enet_txd1_co : out enet_txd1_co_t;
          enet_txd1_odp : out enet_txd1_odp_t;
          enet_txd1_odn : out enet_txd1_odn_t;
          enet_txen_ds : out enet_txen_ds_t;
          enet_txen_sr : out enet_txen_sr_t;
          enet_txen_co : out enet_txen_co_t;
          enet_txen_odp : out enet_txen_odp_t;
          enet_txen_odn : out enet_txen_odn_t;
          enet_clk_ste : out enet_clk_ste_t;
          enet_clk_pd : out enet_clk_pd_t;
          enet_clk_pu : out enet_clk_pu_t;
          enet_rxdv_ste : out enet_rxdv_ste_t;
          enet_rxdv_pd : out enet_rxdv_pd_t;
          enet_rxdv_pu : out enet_rxdv_pu_t;
          enet_rxd0_ste : out enet_rxd0_ste_t;
          enet_rxd0_pd : out enet_rxd0_pd_t;
          enet_rxd0_pu : out enet_rxd0_pu_t;
          enet_rxd1_ste : out enet_rxd1_ste_t;
          enet_rxd1_pd : out enet_rxd1_pd_t;
          enet_rxd1_pu : out enet_rxd1_pu_t;
          enet_rxer_ste : out enet_rxer_ste_t;
          enet_rxer_pd : out enet_rxer_pd_t;
          enet_rxer_pu : out enet_rxer_pu_t;
          spi_sclk_ste : out spi_sclk_ste_t;
          spi_sclk_pd : out spi_sclk_pd_t;
          spi_sclk_pu : out spi_sclk_pu_t;
          spi_cs_n_ste : out spi_cs_n_ste_t;
          spi_cs_n_pd : out spi_cs_n_pd_t;
          spi_cs_n_pu : out spi_cs_n_pu_t;
          spi_mosi_ste : out spi_mosi_ste_t;
          spi_mosi_pd : out spi_mosi_pd_t;
          spi_mosi_pu : out spi_mosi_pu_t;
          spi_miso_ds : out spi_miso_ds_t;
          spi_miso_sr : out spi_miso_sr_t;
          spi_miso_co : out spi_miso_co_t;
          spi_miso_odp : out spi_miso_odp_t;
          spi_miso_odn : out spi_miso_odn_t;
          pll_ref_clk_ste : out pll_ref_clk_ste_t;
          pll_ref_clk_pd : out pll_ref_clk_pd_t;
          pll_ref_clk_pu : out pll_ref_clk_pu_t;
          pa0_sin_out_ds : out pa0_sin_out_ds_t;
          pa0_sin_out_sr : out pa0_sin_out_sr_t;
          pa0_sin_out_co : out pa0_sin_out_co_t;
          pa0_sin_out_odp : out pa0_sin_out_odp_t;
          pa0_sin_out_odn : out pa0_sin_out_odn_t;
          pa0_sin_in_ste : out pa0_sin_in_ste_t;
          pa0_sin_in_pd : out pa0_sin_in_pd_t;
          pa0_sin_in_pu : out pa0_sin_in_pu_t;
          pa5_cs_n_out_ds : out pa5_cs_n_out_ds_t;
          pa5_cs_n_out_sr : out pa5_cs_n_out_sr_t;
          pa5_cs_n_out_co : out pa5_cs_n_out_co_t;
          pa5_cs_n_out_odp : out pa5_cs_n_out_odp_t;
          pa5_cs_n_out_odn : out pa5_cs_n_out_odn_t;
          pa5_cs_n_in_ste : out pa5_cs_n_in_ste_t;
          pa5_cs_n_in_pd : out pa5_cs_n_in_pd_t;
          pa5_cs_n_in_pu : out pa5_cs_n_in_pu_t;
          pa6_sck_out_ds : out pa6_sck_out_ds_t;
          pa6_sck_out_sr : out pa6_sck_out_sr_t;
          pa6_sck_out_co : out pa6_sck_out_co_t;
          pa6_sck_out_odp : out pa6_sck_out_odp_t;
          pa6_sck_out_odn : out pa6_sck_out_odn_t;
          pa6_sck_in_ste : out pa6_sck_in_ste_t;
          pa6_sck_in_pd : out pa6_sck_in_pd_t;
          pa6_sck_in_pu : out pa6_sck_in_pu_t;
          pa7_sout_out_ds : out pa7_sout_out_ds_t;
          pa7_sout_out_sr : out pa7_sout_out_sr_t;
          pa7_sout_out_co : out pa7_sout_out_co_t;
          pa7_sout_out_odp : out pa7_sout_out_odp_t;
          pa7_sout_out_odn : out pa7_sout_out_odn_t;
          pa7_sout_in_ste : out pa7_sout_in_ste_t;
          pa7_sout_in_pd : out pa7_sout_in_pd_t;
          pa7_sout_in_pu : out pa7_sout_in_pu_t;
          pg0_out_ds : out pg0_out_ds_t;
          pg0_out_sr : out pg0_out_sr_t;
          pg0_out_co : out pg0_out_co_t;
          pg0_out_odp : out pg0_out_odp_t;
          pg0_out_odn : out pg0_out_odn_t;
          pg0_in_ste : out pg0_in_ste_t;
          pg0_in_pd : out pg0_in_pd_t;
          pg0_in_pu : out pg0_in_pu_t;
          pg1_out_ds : out pg1_out_ds_t;
          pg1_out_sr : out pg1_out_sr_t;
          pg1_out_co : out pg1_out_co_t;
          pg1_out_odp : out pg1_out_odp_t;
          pg1_out_odn : out pg1_out_odn_t;
          pg1_in_ste : out pg1_in_ste_t;
          pg1_in_pd : out pg1_in_pd_t;
          pg1_in_pu : out pg1_in_pu_t;
          pg2_out_ds : out pg2_out_ds_t;
          pg2_out_sr : out pg2_out_sr_t;
          pg2_out_co : out pg2_out_co_t;
          pg2_out_odp : out pg2_out_odp_t;
          pg2_out_odn : out pg2_out_odn_t;
          pg2_in_ste : out pg2_in_ste_t;
          pg2_in_pd : out pg2_in_pd_t;
          pg2_in_pu : out pg2_in_pu_t;
          pg3_out_ds : out pg3_out_ds_t;
          pg3_out_sr : out pg3_out_sr_t;
          pg3_out_co : out pg3_out_co_t;
          pg3_out_odp : out pg3_out_odp_t;
          pg3_out_odn : out pg3_out_odn_t;
          pg3_in_ste : out pg3_in_ste_t;
          pg3_in_pd : out pg3_in_pd_t;
          pg3_in_pu : out pg3_in_pu_t;
          pg4_out_ds : out pg4_out_ds_t;
          pg4_out_sr : out pg4_out_sr_t;
          pg4_out_co : out pg4_out_co_t;
          pg4_out_odp : out pg4_out_odp_t;
          pg4_out_odn : out pg4_out_odn_t;
          pg4_in_ste : out pg4_in_ste_t;
          pg4_in_pd : out pg4_in_pd_t;
          pg4_in_pu : out pg4_in_pu_t;
          pg5_out_ds : out pg5_out_ds_t;
          pg5_out_sr : out pg5_out_sr_t;
          pg5_out_co : out pg5_out_co_t;
          pg5_out_odp : out pg5_out_odp_t;
          pg5_out_odn : out pg5_out_odn_t;
          pg5_in_ste : out pg5_in_ste_t;
          pg5_in_pd : out pg5_in_pd_t;
          pg5_in_pu : out pg5_in_pu_t;
          pg6_out_ds : out pg6_out_ds_t;
          pg6_out_sr : out pg6_out_sr_t;
          pg6_out_co : out pg6_out_co_t;
          pg6_out_odp : out pg6_out_odp_t;
          pg6_out_odn : out pg6_out_odn_t;
          pg6_in_ste : out pg6_in_ste_t;
          pg6_in_pd : out pg6_in_pd_t;
          pg6_in_pu : out pg6_in_pu_t;
          pg7_out_ds : out pg7_out_ds_t;
          pg7_out_sr : out pg7_out_sr_t;
          pg7_out_co : out pg7_out_co_t;
          pg7_out_odp : out pg7_out_odp_t;
          pg7_out_odn : out pg7_out_odn_t;
          pg7_in_ste : out pg7_in_ste_t;
          pg7_in_pd : out pg7_in_pd_t;
          pg7_in_pu : out pg7_in_pu_t;
          mtest_ste : out mtest_ste_t;
          mtest_pd : out mtest_pd_t;
          mtest_pu : out mtest_pu_t;
          mwake_ste : out mwake_ste_t;
          mwake_pd : out mwake_pd_t;
          mwake_pu : out mwake_pu_t;
          mrxout_ds : out mrxout_ds_t;
          mrxout_sr : out mrxout_sr_t;
          mrxout_co : out mrxout_co_t;
          mrxout_odp : out mrxout_odp_t;
          mrxout_odn : out mrxout_odn_t;


          -- SPI Interface
          write_cmd : in  std_ulogic;
          enable    : in  std_ulogic;
          address   : in  std_ulogic_vector(6 downto 0);
          data_in   : in  std_ulogic_vector(7 downto 0);
          data_out  : out std_ulogic_vector(7 downto 0)
    );
  end component;

end register_pack_spi_test;
