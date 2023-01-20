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
  constant mrxout_out_address_c    : integer := 16#4C#;
  constant pll_1_address_c         : integer := 16#4D#;
  constant pll_2_address_c         : integer := 16#4E#;
  constant pll_cp_address_c        : integer := 16#4F#;
  constant pll_ft_address_c        : integer := 16#50#;
  constant pll_3_address_c         : integer := 16#51#;
  constant pll_4_address_c         : integer := 16#52#;
  constant pll_5_address_c         : integer := 16#53#;
  constant adpll_status0_address_c : integer := 16#54#;
  constant adpll_status1_address_c : integer := 16#55#;
  constant adpll_status2_address_c : integer := 16#56#;
  constant io_dack0_n_address_c    : integer := 16#57#;
  constant io_dreq0_n_address_c    : integer := 16#58#;
  constant io_dack1_n_address_c    : integer := 16#59#;
  constant io_dreq1_n_address_c    : integer := 16#5A#;
  constant io_dack2_n_address_c    : integer := 16#5B#;
  constant io_dreq2_n_address_c    : integer := 16#5C#;
  constant io_dack3_n_address_c    : integer := 16#5D#;
  constant io_dreq3_n_address_c    : integer := 16#5E#;
  constant io_d0_out_address_c     : integer := 16#5F#;
  constant io_d0_in_address_c      : integer := 16#60#;
  constant io_d1_out_address_c     : integer := 16#61#;
  constant io_d1_in_address_c      : integer := 16#62#;
  constant io_d2_out_address_c     : integer := 16#63#;
  constant io_d2_in_address_c      : integer := 16#64#;
  constant io_d3_out_address_c     : integer := 16#65#;
  constant io_d3_in_address_c      : integer := 16#66#;
  constant io_d4_out_address_c     : integer := 16#67#;
  constant io_d4_in_address_c      : integer := 16#68#;
  constant io_d5_out_address_c     : integer := 16#69#;
  constant io_d5_in_address_c      : integer := 16#6A#;
  constant io_d6_out_address_c     : integer := 16#6B#;
  constant io_d6_in_address_c      : integer := 16#6C#;
  constant io_d7_out_address_c     : integer := 16#6D#;
  constant io_d7_in_address_c      : integer := 16#6E#;
  constant io_ldout_n_address_c    : integer := 16#6F#;
  constant io_next_n_address_c     : integer := 16#70#;
  constant io_clk_address_c        : integer := 16#71#;
  constant io_ioa_n_address_c      : integer := 16#72#;
  constant mrxout_in_address_c     : integer := 16#73#;
  constant mreset_n_address_c      : integer := 16#74#;
  constant mrstout_n_address_c     : integer := 16#75#;

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
  constant mtest_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

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
  constant mtest_pd_reset_c : mtest_pd_t := '1';
  constant mtest_pd_scan_c  : mtest_pd_t := '1';

  -- Field "pu"
  constant mtest_pu_size_c  : integer := 1;
  constant mtest_pu_lsb_c   : integer := 0;
  constant mtest_pu_msb_c   : integer := 0;
  subtype mtest_pu_t is std_ulogic;
  constant mtest_pu_reset_c : mtest_pu_t := '0';
  constant mtest_pu_scan_c  : mtest_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mwake"
  constant mwake_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

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
  constant mwake_pd_reset_c : mwake_pd_t := '1';
  constant mwake_pd_scan_c  : mwake_pd_t := '1';

  -- Field "pu"
  constant mwake_pu_size_c  : integer := 1;
  constant mwake_pu_lsb_c   : integer := 0;
  constant mwake_pu_msb_c   : integer := 0;
  subtype mwake_pu_t is std_ulogic;
  constant mwake_pu_reset_c : mwake_pu_t := '0';
  constant mwake_pu_scan_c  : mwake_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mrxout_out"
  constant mrxout_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant mrxout_out_ds_size_c  : integer := 2;
  constant mrxout_out_ds_lsb_c   : integer := 4;
  constant mrxout_out_ds_msb_c   : integer := 5;
  subtype mrxout_out_ds_t is std_ulogic_vector(mrxout_out_ds_size_c - 1 downto 0);
  constant mrxout_out_ds_reset_c : mrxout_out_ds_t := std_ulogic_vector(to_unsigned(2, mrxout_out_ds_t'length));
  constant mrxout_out_ds_scan_c  : mrxout_out_ds_t := std_ulogic_vector(to_unsigned(2, mrxout_out_ds_t'length));

  -- Field "sr"
  constant mrxout_out_sr_size_c  : integer := 1;
  constant mrxout_out_sr_lsb_c   : integer := 3;
  constant mrxout_out_sr_msb_c   : integer := 3;
  subtype mrxout_out_sr_t is std_ulogic;
  constant mrxout_out_sr_reset_c : mrxout_out_sr_t := '1';
  constant mrxout_out_sr_scan_c  : mrxout_out_sr_t := '1';

  -- Field "co"
  constant mrxout_out_co_size_c  : integer := 1;
  constant mrxout_out_co_lsb_c   : integer := 2;
  constant mrxout_out_co_msb_c   : integer := 2;
  subtype mrxout_out_co_t is std_ulogic;
  constant mrxout_out_co_reset_c : mrxout_out_co_t := '0';
  constant mrxout_out_co_scan_c  : mrxout_out_co_t := '0';

  -- Field "odp"
  constant mrxout_out_odp_size_c  : integer := 1;
  constant mrxout_out_odp_lsb_c   : integer := 1;
  constant mrxout_out_odp_msb_c   : integer := 1;
  subtype mrxout_out_odp_t is std_ulogic;
  constant mrxout_out_odp_reset_c : mrxout_out_odp_t := '0';
  constant mrxout_out_odp_scan_c  : mrxout_out_odp_t := '0';

  -- Field "odn"
  constant mrxout_out_odn_size_c  : integer := 1;
  constant mrxout_out_odn_lsb_c   : integer := 0;
  constant mrxout_out_odn_msb_c   : integer := 0;
  subtype mrxout_out_odn_t is std_ulogic;
  constant mrxout_out_odn_reset_c : mrxout_out_odn_t := '0';
  constant mrxout_out_odn_scan_c  : mrxout_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "pll_1"
  constant pll_1_reset_c : register_t := std_ulogic_vector(to_unsigned(16#71#, register_t'length));

  -- Field "main_div_n1"
  constant pll_1_main_div_n1_size_c  : integer := 1;
  constant pll_1_main_div_n1_lsb_c   : integer := 6;
  constant pll_1_main_div_n1_msb_c   : integer := 6;
  subtype pll_1_main_div_n1_t is std_ulogic;
  constant pll_1_main_div_n1_reset_c : pll_1_main_div_n1_t := '1';
  constant pll_1_main_div_n1_scan_c  : pll_1_main_div_n1_t := '1';

  -- Field "main_div_n2"
  constant pll_1_main_div_n2_size_c  : integer := 2;
  constant pll_1_main_div_n2_lsb_c   : integer := 4;
  constant pll_1_main_div_n2_msb_c   : integer := 5;
  subtype pll_1_main_div_n2_t is std_ulogic_vector(pll_1_main_div_n2_size_c - 1 downto 0);
  constant pll_1_main_div_n2_reset_c : pll_1_main_div_n2_t := std_ulogic_vector(to_unsigned(3, pll_1_main_div_n2_t'length));
  constant pll_1_main_div_n2_scan_c  : pll_1_main_div_n2_t := std_ulogic_vector(to_unsigned(3, pll_1_main_div_n2_t'length));

  -- Field "main_div_n3"
  constant pll_1_main_div_n3_size_c  : integer := 2;
  constant pll_1_main_div_n3_lsb_c   : integer := 2;
  constant pll_1_main_div_n3_msb_c   : integer := 3;
  subtype pll_1_main_div_n3_t is std_ulogic_vector(pll_1_main_div_n3_size_c - 1 downto 0);
  constant pll_1_main_div_n3_reset_c : pll_1_main_div_n3_t := std_ulogic_vector(to_unsigned(0, pll_1_main_div_n3_t'length));
  constant pll_1_main_div_n3_scan_c  : pll_1_main_div_n3_t := std_ulogic_vector(to_unsigned(0, pll_1_main_div_n3_t'length));

  -- Field "main_div_n4"
  constant pll_1_main_div_n4_size_c  : integer := 2;
  constant pll_1_main_div_n4_lsb_c   : integer := 0;
  constant pll_1_main_div_n4_msb_c   : integer := 1;
  subtype pll_1_main_div_n4_t is std_ulogic_vector(pll_1_main_div_n4_size_c - 1 downto 0);
  constant pll_1_main_div_n4_reset_c : pll_1_main_div_n4_t := std_ulogic_vector(to_unsigned(1, pll_1_main_div_n4_t'length));
  constant pll_1_main_div_n4_scan_c  : pll_1_main_div_n4_t := std_ulogic_vector(to_unsigned(1, pll_1_main_div_n4_t'length));

  ---------------------------------------------------------------------------
  -- Register "pll_2"
  constant pll_2_reset_c : register_t := std_ulogic_vector(to_unsigned(16#04#, register_t'length));

  -- Field "open_loop"
  constant pll_2_open_loop_size_c  : integer := 1;
  constant pll_2_open_loop_lsb_c   : integer := 7;
  constant pll_2_open_loop_msb_c   : integer := 7;
  subtype pll_2_open_loop_t is std_ulogic;
  constant pll_2_open_loop_reset_c : pll_2_open_loop_t := '0';
  constant pll_2_open_loop_scan_c  : pll_2_open_loop_t := '0';

  -- Field "out_div_sel"
  constant pll_2_out_div_sel_size_c  : integer := 2;
  constant pll_2_out_div_sel_lsb_c   : integer := 5;
  constant pll_2_out_div_sel_msb_c   : integer := 6;
  subtype pll_2_out_div_sel_t is std_ulogic_vector(pll_2_out_div_sel_size_c - 1 downto 0);
  constant pll_2_out_div_sel_reset_c : pll_2_out_div_sel_t := std_ulogic_vector(to_unsigned(0, pll_2_out_div_sel_t'length));
  constant pll_2_out_div_sel_scan_c  : pll_2_out_div_sel_t := std_ulogic_vector(to_unsigned(0, pll_2_out_div_sel_t'length));

  -- Field "ci"
  constant pll_2_ci_size_c  : integer := 5;
  constant pll_2_ci_lsb_c   : integer := 0;
  constant pll_2_ci_msb_c   : integer := 4;
  subtype pll_2_ci_t is std_ulogic_vector(pll_2_ci_size_c - 1 downto 0);
  constant pll_2_ci_reset_c : pll_2_ci_t := std_ulogic_vector(to_unsigned(4, pll_2_ci_t'length));
  constant pll_2_ci_scan_c  : pll_2_ci_t := std_ulogic_vector(to_unsigned(4, pll_2_ci_t'length));

  ---------------------------------------------------------------------------
  -- Register "pll_cp"
  constant pll_cp_reset_c : register_t := std_ulogic_vector(to_unsigned(16#30#, register_t'length));

  -- Field "cp"
  constant pll_cp_cp_size_c  : integer := 8;
  constant pll_cp_cp_lsb_c   : integer := 0;
  constant pll_cp_cp_msb_c   : integer := 7;
  subtype pll_cp_cp_t is std_ulogic_vector(pll_cp_cp_size_c - 1 downto 0);
  constant pll_cp_cp_reset_c : pll_cp_cp_t := std_ulogic_vector(to_unsigned(16#30#, pll_cp_cp_t'length));
  constant pll_cp_cp_scan_c  : pll_cp_cp_t := std_ulogic_vector(to_unsigned(16#30#, pll_cp_cp_t'length));

  ---------------------------------------------------------------------------
  -- Register "pll_ft"
  constant pll_ft_reset_c : register_t := std_ulogic_vector(to_unsigned(16#80#, register_t'length));

  -- Field "ft"
  constant pll_ft_ft_size_c  : integer := 8;
  constant pll_ft_ft_lsb_c   : integer := 0;
  constant pll_ft_ft_msb_c   : integer := 7;
  subtype pll_ft_ft_t is std_ulogic_vector(pll_ft_ft_size_c - 1 downto 0);
  constant pll_ft_ft_reset_c : pll_ft_ft_t := std_ulogic_vector(to_unsigned(16#80#, pll_ft_ft_t'length));
  constant pll_ft_ft_scan_c  : pll_ft_ft_t := std_ulogic_vector(to_unsigned(16#80#, pll_ft_ft_t'length));

  ---------------------------------------------------------------------------
  -- Register "pll_3"
  constant pll_3_reset_c : register_t := std_ulogic_vector(to_unsigned(16#08#, register_t'length));

  -- Field "divcore_sel"
  constant pll_3_divcore_sel_size_c  : integer := 2;
  constant pll_3_divcore_sel_lsb_c   : integer := 6;
  constant pll_3_divcore_sel_msb_c   : integer := 7;
  subtype pll_3_divcore_sel_t is std_ulogic_vector(pll_3_divcore_sel_size_c - 1 downto 0);
  constant pll_3_divcore_sel_reset_c : pll_3_divcore_sel_t := std_ulogic_vector(to_unsigned(0, pll_3_divcore_sel_t'length));
  constant pll_3_divcore_sel_scan_c  : pll_3_divcore_sel_t := std_ulogic_vector(to_unsigned(0, pll_3_divcore_sel_t'length));

  -- Field "coarse"
  constant pll_3_coarse_size_c  : integer := 6;
  constant pll_3_coarse_lsb_c   : integer := 0;
  constant pll_3_coarse_msb_c   : integer := 5;
  subtype pll_3_coarse_t is std_ulogic_vector(pll_3_coarse_size_c - 1 downto 0);
  constant pll_3_coarse_reset_c : pll_3_coarse_t := std_ulogic_vector(to_unsigned(8, pll_3_coarse_t'length));
  constant pll_3_coarse_scan_c  : pll_3_coarse_t := std_ulogic_vector(to_unsigned(8, pll_3_coarse_t'length));

  ---------------------------------------------------------------------------
  -- Register "pll_4"
  constant pll_4_reset_c : register_t := std_ulogic_vector(to_unsigned(16#85#, register_t'length));

  -- Field "auto_coarsetune"
  constant pll_4_auto_coarsetune_size_c  : integer := 1;
  constant pll_4_auto_coarsetune_lsb_c   : integer := 7;
  constant pll_4_auto_coarsetune_msb_c   : integer := 7;
  subtype pll_4_auto_coarsetune_t is std_ulogic;
  constant pll_4_auto_coarsetune_reset_c : pll_4_auto_coarsetune_t := '1';
  constant pll_4_auto_coarsetune_scan_c  : pll_4_auto_coarsetune_t := '1';

  -- Field "enforce_lock"
  constant pll_4_enforce_lock_size_c  : integer := 1;
  constant pll_4_enforce_lock_lsb_c   : integer := 6;
  constant pll_4_enforce_lock_msb_c   : integer := 6;
  subtype pll_4_enforce_lock_t is std_ulogic;
  constant pll_4_enforce_lock_reset_c : pll_4_enforce_lock_t := '0';
  constant pll_4_enforce_lock_scan_c  : pll_4_enforce_lock_t := '0';

  -- Field "pfd_select"
  constant pll_4_pfd_select_size_c  : integer := 1;
  constant pll_4_pfd_select_lsb_c   : integer := 5;
  constant pll_4_pfd_select_msb_c   : integer := 5;
  subtype pll_4_pfd_select_t is std_ulogic;
  constant pll_4_pfd_select_reset_c : pll_4_pfd_select_t := '0';
  constant pll_4_pfd_select_scan_c  : pll_4_pfd_select_t := '0';

  -- Field "lock_window_sel"
  constant pll_4_lock_window_sel_size_c  : integer := 1;
  constant pll_4_lock_window_sel_lsb_c   : integer := 4;
  constant pll_4_lock_window_sel_msb_c   : integer := 4;
  subtype pll_4_lock_window_sel_t is std_ulogic;
  constant pll_4_lock_window_sel_reset_c : pll_4_lock_window_sel_t := '0';
  constant pll_4_lock_window_sel_scan_c  : pll_4_lock_window_sel_t := '0';

  -- Field "div_core_mux_sel"
  constant pll_4_div_core_mux_sel_size_c  : integer := 1;
  constant pll_4_div_core_mux_sel_lsb_c   : integer := 3;
  constant pll_4_div_core_mux_sel_msb_c   : integer := 3;
  subtype pll_4_div_core_mux_sel_t is std_ulogic;
  constant pll_4_div_core_mux_sel_reset_c : pll_4_div_core_mux_sel_t := '0';
  constant pll_4_div_core_mux_sel_scan_c  : pll_4_div_core_mux_sel_t := '0';

  -- Field "filter_shift"
  constant pll_4_filter_shift_size_c  : integer := 2;
  constant pll_4_filter_shift_lsb_c   : integer := 1;
  constant pll_4_filter_shift_msb_c   : integer := 2;
  subtype pll_4_filter_shift_t is std_ulogic_vector(pll_4_filter_shift_size_c - 1 downto 0);
  constant pll_4_filter_shift_reset_c : pll_4_filter_shift_t := std_ulogic_vector(to_unsigned(2, pll_4_filter_shift_t'length));
  constant pll_4_filter_shift_scan_c  : pll_4_filter_shift_t := std_ulogic_vector(to_unsigned(2, pll_4_filter_shift_t'length));

  -- Field "en_fast_lock"
  constant pll_4_en_fast_lock_size_c  : integer := 1;
  constant pll_4_en_fast_lock_lsb_c   : integer := 0;
  constant pll_4_en_fast_lock_msb_c   : integer := 0;
  subtype pll_4_en_fast_lock_t is std_ulogic;
  constant pll_4_en_fast_lock_reset_c : pll_4_en_fast_lock_t := '1';
  constant pll_4_en_fast_lock_scan_c  : pll_4_en_fast_lock_t := '1';

  ---------------------------------------------------------------------------
  -- Register "pll_5"
  constant pll_5_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "sar_limit"
  constant pll_5_sar_limit_size_c  : integer := 3;
  constant pll_5_sar_limit_lsb_c   : integer := 4;
  constant pll_5_sar_limit_msb_c   : integer := 6;
  subtype pll_5_sar_limit_t is std_ulogic_vector(pll_5_sar_limit_size_c - 1 downto 0);
  constant pll_5_sar_limit_reset_c : pll_5_sar_limit_t := std_ulogic_vector(to_unsigned(0, pll_5_sar_limit_t'length));
  constant pll_5_sar_limit_scan_c  : pll_5_sar_limit_t := std_ulogic_vector(to_unsigned(0, pll_5_sar_limit_t'length));

  -- Field "set_op_lock"
  constant pll_5_set_op_lock_size_c  : integer := 1;
  constant pll_5_set_op_lock_lsb_c   : integer := 3;
  constant pll_5_set_op_lock_msb_c   : integer := 3;
  subtype pll_5_set_op_lock_t is std_ulogic;
  constant pll_5_set_op_lock_reset_c : pll_5_set_op_lock_t := '0';
  constant pll_5_set_op_lock_scan_c  : pll_5_set_op_lock_t := '0';

  -- Field "disable_lock"
  constant pll_5_disable_lock_size_c  : integer := 1;
  constant pll_5_disable_lock_lsb_c   : integer := 2;
  constant pll_5_disable_lock_msb_c   : integer := 2;
  subtype pll_5_disable_lock_t is std_ulogic;
  constant pll_5_disable_lock_reset_c : pll_5_disable_lock_t := '0';
  constant pll_5_disable_lock_scan_c  : pll_5_disable_lock_t := '0';

  -- Field "ref_bypass"
  constant pll_5_ref_bypass_size_c  : integer := 1;
  constant pll_5_ref_bypass_lsb_c   : integer := 1;
  constant pll_5_ref_bypass_msb_c   : integer := 1;
  subtype pll_5_ref_bypass_t is std_ulogic;
  constant pll_5_ref_bypass_reset_c : pll_5_ref_bypass_t := '0';
  constant pll_5_ref_bypass_scan_c  : pll_5_ref_bypass_t := '0';

  -- Field "ct_compensation"
  constant pll_5_ct_compensation_size_c  : integer := 1;
  constant pll_5_ct_compensation_lsb_c   : integer := 0;
  constant pll_5_ct_compensation_msb_c   : integer := 0;
  subtype pll_5_ct_compensation_t is std_ulogic;
  constant pll_5_ct_compensation_reset_c : pll_5_ct_compensation_t := '0';
  constant pll_5_ct_compensation_scan_c  : pll_5_ct_compensation_t := '0';

  ---------------------------------------------------------------------------
  -- Register "adpll_status0"
  constant adpll_status0_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "adpll_status_0"
  constant adpll_status0_adpll_status_0_size_c  : integer := 8;
  constant adpll_status0_adpll_status_0_lsb_c   : integer := 0;
  constant adpll_status0_adpll_status_0_msb_c   : integer := 7;
  subtype adpll_status0_adpll_status_0_t is std_ulogic_vector(adpll_status0_adpll_status_0_size_c - 1 downto 0);
  constant adpll_status0_adpll_status_0_reset_c : adpll_status0_adpll_status_0_t := std_ulogic_vector(to_unsigned(0, adpll_status0_adpll_status_0_t'length));
  constant adpll_status0_adpll_status_0_scan_c  : adpll_status0_adpll_status_0_t := std_ulogic_vector(to_unsigned(0, adpll_status0_adpll_status_0_t'length));

  ---------------------------------------------------------------------------
  -- Register "adpll_status1"
  constant adpll_status1_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "adpll_status_1"
  constant adpll_status1_adpll_status_1_size_c  : integer := 8;
  constant adpll_status1_adpll_status_1_lsb_c   : integer := 0;
  constant adpll_status1_adpll_status_1_msb_c   : integer := 7;
  subtype adpll_status1_adpll_status_1_t is std_ulogic_vector(adpll_status1_adpll_status_1_size_c - 1 downto 0);
  constant adpll_status1_adpll_status_1_reset_c : adpll_status1_adpll_status_1_t := std_ulogic_vector(to_unsigned(0, adpll_status1_adpll_status_1_t'length));
  constant adpll_status1_adpll_status_1_scan_c  : adpll_status1_adpll_status_1_t := std_ulogic_vector(to_unsigned(0, adpll_status1_adpll_status_1_t'length));

  ---------------------------------------------------------------------------
  -- Register "adpll_status2"
  constant adpll_status2_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "adpll_status_2"
  constant adpll_status2_adpll_status_2_size_c  : integer := 5;
  constant adpll_status2_adpll_status_2_lsb_c   : integer := 0;
  constant adpll_status2_adpll_status_2_msb_c   : integer := 4;
  subtype adpll_status2_adpll_status_2_t is std_ulogic_vector(adpll_status2_adpll_status_2_size_c - 1 downto 0);
  constant adpll_status2_adpll_status_2_reset_c : adpll_status2_adpll_status_2_t := std_ulogic_vector(to_unsigned(0, adpll_status2_adpll_status_2_t'length));
  constant adpll_status2_adpll_status_2_scan_c  : adpll_status2_adpll_status_2_t := std_ulogic_vector(to_unsigned(0, adpll_status2_adpll_status_2_t'length));

  ---------------------------------------------------------------------------
  -- Register "io_dack0_n"
  constant io_dack0_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "ste"
  constant io_dack0_n_ste_size_c  : integer := 2;
  constant io_dack0_n_ste_lsb_c   : integer := 2;
  constant io_dack0_n_ste_msb_c   : integer := 3;
  subtype io_dack0_n_ste_t is std_ulogic_vector(io_dack0_n_ste_size_c - 1 downto 0);
  constant io_dack0_n_ste_reset_c : io_dack0_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack0_n_ste_t'length));
  constant io_dack0_n_ste_scan_c  : io_dack0_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack0_n_ste_t'length));

  -- Field "pd"
  constant io_dack0_n_pd_size_c  : integer := 1;
  constant io_dack0_n_pd_lsb_c   : integer := 1;
  constant io_dack0_n_pd_msb_c   : integer := 1;
  subtype io_dack0_n_pd_t is std_ulogic;
  constant io_dack0_n_pd_reset_c : io_dack0_n_pd_t := '1';
  constant io_dack0_n_pd_scan_c  : io_dack0_n_pd_t := '1';

  -- Field "pu"
  constant io_dack0_n_pu_size_c  : integer := 1;
  constant io_dack0_n_pu_lsb_c   : integer := 0;
  constant io_dack0_n_pu_msb_c   : integer := 0;
  subtype io_dack0_n_pu_t is std_ulogic;
  constant io_dack0_n_pu_reset_c : io_dack0_n_pu_t := '0';
  constant io_dack0_n_pu_scan_c  : io_dack0_n_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dreq0_n"
  constant io_dreq0_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_dreq0_n_ds_size_c  : integer := 2;
  constant io_dreq0_n_ds_lsb_c   : integer := 4;
  constant io_dreq0_n_ds_msb_c   : integer := 5;
  subtype io_dreq0_n_ds_t is std_ulogic_vector(io_dreq0_n_ds_size_c - 1 downto 0);
  constant io_dreq0_n_ds_reset_c : io_dreq0_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq0_n_ds_t'length));
  constant io_dreq0_n_ds_scan_c  : io_dreq0_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq0_n_ds_t'length));

  -- Field "sr"
  constant io_dreq0_n_sr_size_c  : integer := 1;
  constant io_dreq0_n_sr_lsb_c   : integer := 3;
  constant io_dreq0_n_sr_msb_c   : integer := 3;
  subtype io_dreq0_n_sr_t is std_ulogic;
  constant io_dreq0_n_sr_reset_c : io_dreq0_n_sr_t := '1';
  constant io_dreq0_n_sr_scan_c  : io_dreq0_n_sr_t := '1';

  -- Field "co"
  constant io_dreq0_n_co_size_c  : integer := 1;
  constant io_dreq0_n_co_lsb_c   : integer := 2;
  constant io_dreq0_n_co_msb_c   : integer := 2;
  subtype io_dreq0_n_co_t is std_ulogic;
  constant io_dreq0_n_co_reset_c : io_dreq0_n_co_t := '0';
  constant io_dreq0_n_co_scan_c  : io_dreq0_n_co_t := '0';

  -- Field "odp"
  constant io_dreq0_n_odp_size_c  : integer := 1;
  constant io_dreq0_n_odp_lsb_c   : integer := 1;
  constant io_dreq0_n_odp_msb_c   : integer := 1;
  subtype io_dreq0_n_odp_t is std_ulogic;
  constant io_dreq0_n_odp_reset_c : io_dreq0_n_odp_t := '0';
  constant io_dreq0_n_odp_scan_c  : io_dreq0_n_odp_t := '0';

  -- Field "odn"
  constant io_dreq0_n_odn_size_c  : integer := 1;
  constant io_dreq0_n_odn_lsb_c   : integer := 0;
  constant io_dreq0_n_odn_msb_c   : integer := 0;
  subtype io_dreq0_n_odn_t is std_ulogic;
  constant io_dreq0_n_odn_reset_c : io_dreq0_n_odn_t := '0';
  constant io_dreq0_n_odn_scan_c  : io_dreq0_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dack1_n"
  constant io_dack1_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "ste"
  constant io_dack1_n_ste_size_c  : integer := 2;
  constant io_dack1_n_ste_lsb_c   : integer := 2;
  constant io_dack1_n_ste_msb_c   : integer := 3;
  subtype io_dack1_n_ste_t is std_ulogic_vector(io_dack1_n_ste_size_c - 1 downto 0);
  constant io_dack1_n_ste_reset_c : io_dack1_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack1_n_ste_t'length));
  constant io_dack1_n_ste_scan_c  : io_dack1_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack1_n_ste_t'length));

  -- Field "pd"
  constant io_dack1_n_pd_size_c  : integer := 1;
  constant io_dack1_n_pd_lsb_c   : integer := 1;
  constant io_dack1_n_pd_msb_c   : integer := 1;
  subtype io_dack1_n_pd_t is std_ulogic;
  constant io_dack1_n_pd_reset_c : io_dack1_n_pd_t := '1';
  constant io_dack1_n_pd_scan_c  : io_dack1_n_pd_t := '1';

  -- Field "pu"
  constant io_dack1_n_pu_size_c  : integer := 1;
  constant io_dack1_n_pu_lsb_c   : integer := 0;
  constant io_dack1_n_pu_msb_c   : integer := 0;
  subtype io_dack1_n_pu_t is std_ulogic;
  constant io_dack1_n_pu_reset_c : io_dack1_n_pu_t := '0';
  constant io_dack1_n_pu_scan_c  : io_dack1_n_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dreq1_n"
  constant io_dreq1_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_dreq1_n_ds_size_c  : integer := 2;
  constant io_dreq1_n_ds_lsb_c   : integer := 4;
  constant io_dreq1_n_ds_msb_c   : integer := 5;
  subtype io_dreq1_n_ds_t is std_ulogic_vector(io_dreq1_n_ds_size_c - 1 downto 0);
  constant io_dreq1_n_ds_reset_c : io_dreq1_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq1_n_ds_t'length));
  constant io_dreq1_n_ds_scan_c  : io_dreq1_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq1_n_ds_t'length));

  -- Field "sr"
  constant io_dreq1_n_sr_size_c  : integer := 1;
  constant io_dreq1_n_sr_lsb_c   : integer := 3;
  constant io_dreq1_n_sr_msb_c   : integer := 3;
  subtype io_dreq1_n_sr_t is std_ulogic;
  constant io_dreq1_n_sr_reset_c : io_dreq1_n_sr_t := '1';
  constant io_dreq1_n_sr_scan_c  : io_dreq1_n_sr_t := '1';

  -- Field "co"
  constant io_dreq1_n_co_size_c  : integer := 1;
  constant io_dreq1_n_co_lsb_c   : integer := 2;
  constant io_dreq1_n_co_msb_c   : integer := 2;
  subtype io_dreq1_n_co_t is std_ulogic;
  constant io_dreq1_n_co_reset_c : io_dreq1_n_co_t := '0';
  constant io_dreq1_n_co_scan_c  : io_dreq1_n_co_t := '0';

  -- Field "odp"
  constant io_dreq1_n_odp_size_c  : integer := 1;
  constant io_dreq1_n_odp_lsb_c   : integer := 1;
  constant io_dreq1_n_odp_msb_c   : integer := 1;
  subtype io_dreq1_n_odp_t is std_ulogic;
  constant io_dreq1_n_odp_reset_c : io_dreq1_n_odp_t := '0';
  constant io_dreq1_n_odp_scan_c  : io_dreq1_n_odp_t := '0';

  -- Field "odn"
  constant io_dreq1_n_odn_size_c  : integer := 1;
  constant io_dreq1_n_odn_lsb_c   : integer := 0;
  constant io_dreq1_n_odn_msb_c   : integer := 0;
  subtype io_dreq1_n_odn_t is std_ulogic;
  constant io_dreq1_n_odn_reset_c : io_dreq1_n_odn_t := '0';
  constant io_dreq1_n_odn_scan_c  : io_dreq1_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dack2_n"
  constant io_dack2_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "ste"
  constant io_dack2_n_ste_size_c  : integer := 2;
  constant io_dack2_n_ste_lsb_c   : integer := 2;
  constant io_dack2_n_ste_msb_c   : integer := 3;
  subtype io_dack2_n_ste_t is std_ulogic_vector(io_dack2_n_ste_size_c - 1 downto 0);
  constant io_dack2_n_ste_reset_c : io_dack2_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack2_n_ste_t'length));
  constant io_dack2_n_ste_scan_c  : io_dack2_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack2_n_ste_t'length));

  -- Field "pd"
  constant io_dack2_n_pd_size_c  : integer := 1;
  constant io_dack2_n_pd_lsb_c   : integer := 1;
  constant io_dack2_n_pd_msb_c   : integer := 1;
  subtype io_dack2_n_pd_t is std_ulogic;
  constant io_dack2_n_pd_reset_c : io_dack2_n_pd_t := '1';
  constant io_dack2_n_pd_scan_c  : io_dack2_n_pd_t := '1';

  -- Field "pu"
  constant io_dack2_n_pu_size_c  : integer := 1;
  constant io_dack2_n_pu_lsb_c   : integer := 0;
  constant io_dack2_n_pu_msb_c   : integer := 0;
  subtype io_dack2_n_pu_t is std_ulogic;
  constant io_dack2_n_pu_reset_c : io_dack2_n_pu_t := '0';
  constant io_dack2_n_pu_scan_c  : io_dack2_n_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dreq2_n"
  constant io_dreq2_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_dreq2_n_ds_size_c  : integer := 2;
  constant io_dreq2_n_ds_lsb_c   : integer := 4;
  constant io_dreq2_n_ds_msb_c   : integer := 5;
  subtype io_dreq2_n_ds_t is std_ulogic_vector(io_dreq2_n_ds_size_c - 1 downto 0);
  constant io_dreq2_n_ds_reset_c : io_dreq2_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq2_n_ds_t'length));
  constant io_dreq2_n_ds_scan_c  : io_dreq2_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq2_n_ds_t'length));

  -- Field "sr"
  constant io_dreq2_n_sr_size_c  : integer := 1;
  constant io_dreq2_n_sr_lsb_c   : integer := 3;
  constant io_dreq2_n_sr_msb_c   : integer := 3;
  subtype io_dreq2_n_sr_t is std_ulogic;
  constant io_dreq2_n_sr_reset_c : io_dreq2_n_sr_t := '1';
  constant io_dreq2_n_sr_scan_c  : io_dreq2_n_sr_t := '1';

  -- Field "co"
  constant io_dreq2_n_co_size_c  : integer := 1;
  constant io_dreq2_n_co_lsb_c   : integer := 2;
  constant io_dreq2_n_co_msb_c   : integer := 2;
  subtype io_dreq2_n_co_t is std_ulogic;
  constant io_dreq2_n_co_reset_c : io_dreq2_n_co_t := '0';
  constant io_dreq2_n_co_scan_c  : io_dreq2_n_co_t := '0';

  -- Field "odp"
  constant io_dreq2_n_odp_size_c  : integer := 1;
  constant io_dreq2_n_odp_lsb_c   : integer := 1;
  constant io_dreq2_n_odp_msb_c   : integer := 1;
  subtype io_dreq2_n_odp_t is std_ulogic;
  constant io_dreq2_n_odp_reset_c : io_dreq2_n_odp_t := '0';
  constant io_dreq2_n_odp_scan_c  : io_dreq2_n_odp_t := '0';

  -- Field "odn"
  constant io_dreq2_n_odn_size_c  : integer := 1;
  constant io_dreq2_n_odn_lsb_c   : integer := 0;
  constant io_dreq2_n_odn_msb_c   : integer := 0;
  subtype io_dreq2_n_odn_t is std_ulogic;
  constant io_dreq2_n_odn_reset_c : io_dreq2_n_odn_t := '0';
  constant io_dreq2_n_odn_scan_c  : io_dreq2_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dack3_n"
  constant io_dack3_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "ste"
  constant io_dack3_n_ste_size_c  : integer := 2;
  constant io_dack3_n_ste_lsb_c   : integer := 2;
  constant io_dack3_n_ste_msb_c   : integer := 3;
  subtype io_dack3_n_ste_t is std_ulogic_vector(io_dack3_n_ste_size_c - 1 downto 0);
  constant io_dack3_n_ste_reset_c : io_dack3_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack3_n_ste_t'length));
  constant io_dack3_n_ste_scan_c  : io_dack3_n_ste_t := std_ulogic_vector(to_unsigned(0, io_dack3_n_ste_t'length));

  -- Field "pd"
  constant io_dack3_n_pd_size_c  : integer := 1;
  constant io_dack3_n_pd_lsb_c   : integer := 1;
  constant io_dack3_n_pd_msb_c   : integer := 1;
  subtype io_dack3_n_pd_t is std_ulogic;
  constant io_dack3_n_pd_reset_c : io_dack3_n_pd_t := '1';
  constant io_dack3_n_pd_scan_c  : io_dack3_n_pd_t := '1';

  -- Field "pu"
  constant io_dack3_n_pu_size_c  : integer := 1;
  constant io_dack3_n_pu_lsb_c   : integer := 0;
  constant io_dack3_n_pu_msb_c   : integer := 0;
  subtype io_dack3_n_pu_t is std_ulogic;
  constant io_dack3_n_pu_reset_c : io_dack3_n_pu_t := '0';
  constant io_dack3_n_pu_scan_c  : io_dack3_n_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_dreq3_n"
  constant io_dreq3_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_dreq3_n_ds_size_c  : integer := 2;
  constant io_dreq3_n_ds_lsb_c   : integer := 4;
  constant io_dreq3_n_ds_msb_c   : integer := 5;
  subtype io_dreq3_n_ds_t is std_ulogic_vector(io_dreq3_n_ds_size_c - 1 downto 0);
  constant io_dreq3_n_ds_reset_c : io_dreq3_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq3_n_ds_t'length));
  constant io_dreq3_n_ds_scan_c  : io_dreq3_n_ds_t := std_ulogic_vector(to_unsigned(2, io_dreq3_n_ds_t'length));

  -- Field "sr"
  constant io_dreq3_n_sr_size_c  : integer := 1;
  constant io_dreq3_n_sr_lsb_c   : integer := 3;
  constant io_dreq3_n_sr_msb_c   : integer := 3;
  subtype io_dreq3_n_sr_t is std_ulogic;
  constant io_dreq3_n_sr_reset_c : io_dreq3_n_sr_t := '1';
  constant io_dreq3_n_sr_scan_c  : io_dreq3_n_sr_t := '1';

  -- Field "co"
  constant io_dreq3_n_co_size_c  : integer := 1;
  constant io_dreq3_n_co_lsb_c   : integer := 2;
  constant io_dreq3_n_co_msb_c   : integer := 2;
  subtype io_dreq3_n_co_t is std_ulogic;
  constant io_dreq3_n_co_reset_c : io_dreq3_n_co_t := '0';
  constant io_dreq3_n_co_scan_c  : io_dreq3_n_co_t := '0';

  -- Field "odp"
  constant io_dreq3_n_odp_size_c  : integer := 1;
  constant io_dreq3_n_odp_lsb_c   : integer := 1;
  constant io_dreq3_n_odp_msb_c   : integer := 1;
  subtype io_dreq3_n_odp_t is std_ulogic;
  constant io_dreq3_n_odp_reset_c : io_dreq3_n_odp_t := '0';
  constant io_dreq3_n_odp_scan_c  : io_dreq3_n_odp_t := '0';

  -- Field "odn"
  constant io_dreq3_n_odn_size_c  : integer := 1;
  constant io_dreq3_n_odn_lsb_c   : integer := 0;
  constant io_dreq3_n_odn_msb_c   : integer := 0;
  subtype io_dreq3_n_odn_t is std_ulogic;
  constant io_dreq3_n_odn_reset_c : io_dreq3_n_odn_t := '0';
  constant io_dreq3_n_odn_scan_c  : io_dreq3_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d0_out"
  constant io_d0_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d0_out_ds_size_c  : integer := 2;
  constant io_d0_out_ds_lsb_c   : integer := 4;
  constant io_d0_out_ds_msb_c   : integer := 5;
  subtype io_d0_out_ds_t is std_ulogic_vector(io_d0_out_ds_size_c - 1 downto 0);
  constant io_d0_out_ds_reset_c : io_d0_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d0_out_ds_t'length));
  constant io_d0_out_ds_scan_c  : io_d0_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d0_out_ds_t'length));

  -- Field "sr"
  constant io_d0_out_sr_size_c  : integer := 1;
  constant io_d0_out_sr_lsb_c   : integer := 3;
  constant io_d0_out_sr_msb_c   : integer := 3;
  subtype io_d0_out_sr_t is std_ulogic;
  constant io_d0_out_sr_reset_c : io_d0_out_sr_t := '1';
  constant io_d0_out_sr_scan_c  : io_d0_out_sr_t := '1';

  -- Field "co"
  constant io_d0_out_co_size_c  : integer := 1;
  constant io_d0_out_co_lsb_c   : integer := 2;
  constant io_d0_out_co_msb_c   : integer := 2;
  subtype io_d0_out_co_t is std_ulogic;
  constant io_d0_out_co_reset_c : io_d0_out_co_t := '0';
  constant io_d0_out_co_scan_c  : io_d0_out_co_t := '0';

  -- Field "odp"
  constant io_d0_out_odp_size_c  : integer := 1;
  constant io_d0_out_odp_lsb_c   : integer := 1;
  constant io_d0_out_odp_msb_c   : integer := 1;
  subtype io_d0_out_odp_t is std_ulogic;
  constant io_d0_out_odp_reset_c : io_d0_out_odp_t := '0';
  constant io_d0_out_odp_scan_c  : io_d0_out_odp_t := '0';

  -- Field "odn"
  constant io_d0_out_odn_size_c  : integer := 1;
  constant io_d0_out_odn_lsb_c   : integer := 0;
  constant io_d0_out_odn_msb_c   : integer := 0;
  subtype io_d0_out_odn_t is std_ulogic;
  constant io_d0_out_odn_reset_c : io_d0_out_odn_t := '0';
  constant io_d0_out_odn_scan_c  : io_d0_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d0_in"
  constant io_d0_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d0_in_ste_size_c  : integer := 2;
  constant io_d0_in_ste_lsb_c   : integer := 2;
  constant io_d0_in_ste_msb_c   : integer := 3;
  subtype io_d0_in_ste_t is std_ulogic_vector(io_d0_in_ste_size_c - 1 downto 0);
  constant io_d0_in_ste_reset_c : io_d0_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d0_in_ste_t'length));
  constant io_d0_in_ste_scan_c  : io_d0_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d0_in_ste_t'length));

  -- Field "pd"
  constant io_d0_in_pd_size_c  : integer := 1;
  constant io_d0_in_pd_lsb_c   : integer := 1;
  constant io_d0_in_pd_msb_c   : integer := 1;
  subtype io_d0_in_pd_t is std_ulogic;
  constant io_d0_in_pd_reset_c : io_d0_in_pd_t := '0';
  constant io_d0_in_pd_scan_c  : io_d0_in_pd_t := '0';

  -- Field "pu"
  constant io_d0_in_pu_size_c  : integer := 1;
  constant io_d0_in_pu_lsb_c   : integer := 0;
  constant io_d0_in_pu_msb_c   : integer := 0;
  subtype io_d0_in_pu_t is std_ulogic;
  constant io_d0_in_pu_reset_c : io_d0_in_pu_t := '0';
  constant io_d0_in_pu_scan_c  : io_d0_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d1_out"
  constant io_d1_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d1_out_ds_size_c  : integer := 2;
  constant io_d1_out_ds_lsb_c   : integer := 4;
  constant io_d1_out_ds_msb_c   : integer := 5;
  subtype io_d1_out_ds_t is std_ulogic_vector(io_d1_out_ds_size_c - 1 downto 0);
  constant io_d1_out_ds_reset_c : io_d1_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d1_out_ds_t'length));
  constant io_d1_out_ds_scan_c  : io_d1_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d1_out_ds_t'length));

  -- Field "sr"
  constant io_d1_out_sr_size_c  : integer := 1;
  constant io_d1_out_sr_lsb_c   : integer := 3;
  constant io_d1_out_sr_msb_c   : integer := 3;
  subtype io_d1_out_sr_t is std_ulogic;
  constant io_d1_out_sr_reset_c : io_d1_out_sr_t := '1';
  constant io_d1_out_sr_scan_c  : io_d1_out_sr_t := '1';

  -- Field "co"
  constant io_d1_out_co_size_c  : integer := 1;
  constant io_d1_out_co_lsb_c   : integer := 2;
  constant io_d1_out_co_msb_c   : integer := 2;
  subtype io_d1_out_co_t is std_ulogic;
  constant io_d1_out_co_reset_c : io_d1_out_co_t := '0';
  constant io_d1_out_co_scan_c  : io_d1_out_co_t := '0';

  -- Field "odp"
  constant io_d1_out_odp_size_c  : integer := 1;
  constant io_d1_out_odp_lsb_c   : integer := 1;
  constant io_d1_out_odp_msb_c   : integer := 1;
  subtype io_d1_out_odp_t is std_ulogic;
  constant io_d1_out_odp_reset_c : io_d1_out_odp_t := '0';
  constant io_d1_out_odp_scan_c  : io_d1_out_odp_t := '0';

  -- Field "odn"
  constant io_d1_out_odn_size_c  : integer := 1;
  constant io_d1_out_odn_lsb_c   : integer := 0;
  constant io_d1_out_odn_msb_c   : integer := 0;
  subtype io_d1_out_odn_t is std_ulogic;
  constant io_d1_out_odn_reset_c : io_d1_out_odn_t := '0';
  constant io_d1_out_odn_scan_c  : io_d1_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d1_in"
  constant io_d1_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d1_in_ste_size_c  : integer := 2;
  constant io_d1_in_ste_lsb_c   : integer := 2;
  constant io_d1_in_ste_msb_c   : integer := 3;
  subtype io_d1_in_ste_t is std_ulogic_vector(io_d1_in_ste_size_c - 1 downto 0);
  constant io_d1_in_ste_reset_c : io_d1_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d1_in_ste_t'length));
  constant io_d1_in_ste_scan_c  : io_d1_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d1_in_ste_t'length));

  -- Field "pd"
  constant io_d1_in_pd_size_c  : integer := 1;
  constant io_d1_in_pd_lsb_c   : integer := 1;
  constant io_d1_in_pd_msb_c   : integer := 1;
  subtype io_d1_in_pd_t is std_ulogic;
  constant io_d1_in_pd_reset_c : io_d1_in_pd_t := '0';
  constant io_d1_in_pd_scan_c  : io_d1_in_pd_t := '0';

  -- Field "pu"
  constant io_d1_in_pu_size_c  : integer := 1;
  constant io_d1_in_pu_lsb_c   : integer := 0;
  constant io_d1_in_pu_msb_c   : integer := 0;
  subtype io_d1_in_pu_t is std_ulogic;
  constant io_d1_in_pu_reset_c : io_d1_in_pu_t := '0';
  constant io_d1_in_pu_scan_c  : io_d1_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d2_out"
  constant io_d2_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d2_out_ds_size_c  : integer := 2;
  constant io_d2_out_ds_lsb_c   : integer := 4;
  constant io_d2_out_ds_msb_c   : integer := 5;
  subtype io_d2_out_ds_t is std_ulogic_vector(io_d2_out_ds_size_c - 1 downto 0);
  constant io_d2_out_ds_reset_c : io_d2_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d2_out_ds_t'length));
  constant io_d2_out_ds_scan_c  : io_d2_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d2_out_ds_t'length));

  -- Field "sr"
  constant io_d2_out_sr_size_c  : integer := 1;
  constant io_d2_out_sr_lsb_c   : integer := 3;
  constant io_d2_out_sr_msb_c   : integer := 3;
  subtype io_d2_out_sr_t is std_ulogic;
  constant io_d2_out_sr_reset_c : io_d2_out_sr_t := '1';
  constant io_d2_out_sr_scan_c  : io_d2_out_sr_t := '1';

  -- Field "co"
  constant io_d2_out_co_size_c  : integer := 1;
  constant io_d2_out_co_lsb_c   : integer := 2;
  constant io_d2_out_co_msb_c   : integer := 2;
  subtype io_d2_out_co_t is std_ulogic;
  constant io_d2_out_co_reset_c : io_d2_out_co_t := '0';
  constant io_d2_out_co_scan_c  : io_d2_out_co_t := '0';

  -- Field "odp"
  constant io_d2_out_odp_size_c  : integer := 1;
  constant io_d2_out_odp_lsb_c   : integer := 1;
  constant io_d2_out_odp_msb_c   : integer := 1;
  subtype io_d2_out_odp_t is std_ulogic;
  constant io_d2_out_odp_reset_c : io_d2_out_odp_t := '0';
  constant io_d2_out_odp_scan_c  : io_d2_out_odp_t := '0';

  -- Field "odn"
  constant io_d2_out_odn_size_c  : integer := 1;
  constant io_d2_out_odn_lsb_c   : integer := 0;
  constant io_d2_out_odn_msb_c   : integer := 0;
  subtype io_d2_out_odn_t is std_ulogic;
  constant io_d2_out_odn_reset_c : io_d2_out_odn_t := '0';
  constant io_d2_out_odn_scan_c  : io_d2_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d2_in"
  constant io_d2_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d2_in_ste_size_c  : integer := 2;
  constant io_d2_in_ste_lsb_c   : integer := 2;
  constant io_d2_in_ste_msb_c   : integer := 3;
  subtype io_d2_in_ste_t is std_ulogic_vector(io_d2_in_ste_size_c - 1 downto 0);
  constant io_d2_in_ste_reset_c : io_d2_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d2_in_ste_t'length));
  constant io_d2_in_ste_scan_c  : io_d2_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d2_in_ste_t'length));

  -- Field "pd"
  constant io_d2_in_pd_size_c  : integer := 1;
  constant io_d2_in_pd_lsb_c   : integer := 1;
  constant io_d2_in_pd_msb_c   : integer := 1;
  subtype io_d2_in_pd_t is std_ulogic;
  constant io_d2_in_pd_reset_c : io_d2_in_pd_t := '0';
  constant io_d2_in_pd_scan_c  : io_d2_in_pd_t := '0';

  -- Field "pu"
  constant io_d2_in_pu_size_c  : integer := 1;
  constant io_d2_in_pu_lsb_c   : integer := 0;
  constant io_d2_in_pu_msb_c   : integer := 0;
  subtype io_d2_in_pu_t is std_ulogic;
  constant io_d2_in_pu_reset_c : io_d2_in_pu_t := '0';
  constant io_d2_in_pu_scan_c  : io_d2_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d3_out"
  constant io_d3_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d3_out_ds_size_c  : integer := 2;
  constant io_d3_out_ds_lsb_c   : integer := 4;
  constant io_d3_out_ds_msb_c   : integer := 5;
  subtype io_d3_out_ds_t is std_ulogic_vector(io_d3_out_ds_size_c - 1 downto 0);
  constant io_d3_out_ds_reset_c : io_d3_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d3_out_ds_t'length));
  constant io_d3_out_ds_scan_c  : io_d3_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d3_out_ds_t'length));

  -- Field "sr"
  constant io_d3_out_sr_size_c  : integer := 1;
  constant io_d3_out_sr_lsb_c   : integer := 3;
  constant io_d3_out_sr_msb_c   : integer := 3;
  subtype io_d3_out_sr_t is std_ulogic;
  constant io_d3_out_sr_reset_c : io_d3_out_sr_t := '1';
  constant io_d3_out_sr_scan_c  : io_d3_out_sr_t := '1';

  -- Field "co"
  constant io_d3_out_co_size_c  : integer := 1;
  constant io_d3_out_co_lsb_c   : integer := 2;
  constant io_d3_out_co_msb_c   : integer := 2;
  subtype io_d3_out_co_t is std_ulogic;
  constant io_d3_out_co_reset_c : io_d3_out_co_t := '0';
  constant io_d3_out_co_scan_c  : io_d3_out_co_t := '0';

  -- Field "odp"
  constant io_d3_out_odp_size_c  : integer := 1;
  constant io_d3_out_odp_lsb_c   : integer := 1;
  constant io_d3_out_odp_msb_c   : integer := 1;
  subtype io_d3_out_odp_t is std_ulogic;
  constant io_d3_out_odp_reset_c : io_d3_out_odp_t := '0';
  constant io_d3_out_odp_scan_c  : io_d3_out_odp_t := '0';

  -- Field "odn"
  constant io_d3_out_odn_size_c  : integer := 1;
  constant io_d3_out_odn_lsb_c   : integer := 0;
  constant io_d3_out_odn_msb_c   : integer := 0;
  subtype io_d3_out_odn_t is std_ulogic;
  constant io_d3_out_odn_reset_c : io_d3_out_odn_t := '0';
  constant io_d3_out_odn_scan_c  : io_d3_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d3_in"
  constant io_d3_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d3_in_ste_size_c  : integer := 2;
  constant io_d3_in_ste_lsb_c   : integer := 2;
  constant io_d3_in_ste_msb_c   : integer := 3;
  subtype io_d3_in_ste_t is std_ulogic_vector(io_d3_in_ste_size_c - 1 downto 0);
  constant io_d3_in_ste_reset_c : io_d3_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d3_in_ste_t'length));
  constant io_d3_in_ste_scan_c  : io_d3_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d3_in_ste_t'length));

  -- Field "pd"
  constant io_d3_in_pd_size_c  : integer := 1;
  constant io_d3_in_pd_lsb_c   : integer := 1;
  constant io_d3_in_pd_msb_c   : integer := 1;
  subtype io_d3_in_pd_t is std_ulogic;
  constant io_d3_in_pd_reset_c : io_d3_in_pd_t := '0';
  constant io_d3_in_pd_scan_c  : io_d3_in_pd_t := '0';

  -- Field "pu"
  constant io_d3_in_pu_size_c  : integer := 1;
  constant io_d3_in_pu_lsb_c   : integer := 0;
  constant io_d3_in_pu_msb_c   : integer := 0;
  subtype io_d3_in_pu_t is std_ulogic;
  constant io_d3_in_pu_reset_c : io_d3_in_pu_t := '0';
  constant io_d3_in_pu_scan_c  : io_d3_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d4_out"
  constant io_d4_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d4_out_ds_size_c  : integer := 2;
  constant io_d4_out_ds_lsb_c   : integer := 4;
  constant io_d4_out_ds_msb_c   : integer := 5;
  subtype io_d4_out_ds_t is std_ulogic_vector(io_d4_out_ds_size_c - 1 downto 0);
  constant io_d4_out_ds_reset_c : io_d4_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d4_out_ds_t'length));
  constant io_d4_out_ds_scan_c  : io_d4_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d4_out_ds_t'length));

  -- Field "sr"
  constant io_d4_out_sr_size_c  : integer := 1;
  constant io_d4_out_sr_lsb_c   : integer := 3;
  constant io_d4_out_sr_msb_c   : integer := 3;
  subtype io_d4_out_sr_t is std_ulogic;
  constant io_d4_out_sr_reset_c : io_d4_out_sr_t := '1';
  constant io_d4_out_sr_scan_c  : io_d4_out_sr_t := '1';

  -- Field "co"
  constant io_d4_out_co_size_c  : integer := 1;
  constant io_d4_out_co_lsb_c   : integer := 2;
  constant io_d4_out_co_msb_c   : integer := 2;
  subtype io_d4_out_co_t is std_ulogic;
  constant io_d4_out_co_reset_c : io_d4_out_co_t := '0';
  constant io_d4_out_co_scan_c  : io_d4_out_co_t := '0';

  -- Field "odp"
  constant io_d4_out_odp_size_c  : integer := 1;
  constant io_d4_out_odp_lsb_c   : integer := 1;
  constant io_d4_out_odp_msb_c   : integer := 1;
  subtype io_d4_out_odp_t is std_ulogic;
  constant io_d4_out_odp_reset_c : io_d4_out_odp_t := '0';
  constant io_d4_out_odp_scan_c  : io_d4_out_odp_t := '0';

  -- Field "odn"
  constant io_d4_out_odn_size_c  : integer := 1;
  constant io_d4_out_odn_lsb_c   : integer := 0;
  constant io_d4_out_odn_msb_c   : integer := 0;
  subtype io_d4_out_odn_t is std_ulogic;
  constant io_d4_out_odn_reset_c : io_d4_out_odn_t := '0';
  constant io_d4_out_odn_scan_c  : io_d4_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d4_in"
  constant io_d4_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d4_in_ste_size_c  : integer := 2;
  constant io_d4_in_ste_lsb_c   : integer := 2;
  constant io_d4_in_ste_msb_c   : integer := 3;
  subtype io_d4_in_ste_t is std_ulogic_vector(io_d4_in_ste_size_c - 1 downto 0);
  constant io_d4_in_ste_reset_c : io_d4_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d4_in_ste_t'length));
  constant io_d4_in_ste_scan_c  : io_d4_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d4_in_ste_t'length));

  -- Field "pd"
  constant io_d4_in_pd_size_c  : integer := 1;
  constant io_d4_in_pd_lsb_c   : integer := 1;
  constant io_d4_in_pd_msb_c   : integer := 1;
  subtype io_d4_in_pd_t is std_ulogic;
  constant io_d4_in_pd_reset_c : io_d4_in_pd_t := '0';
  constant io_d4_in_pd_scan_c  : io_d4_in_pd_t := '0';

  -- Field "pu"
  constant io_d4_in_pu_size_c  : integer := 1;
  constant io_d4_in_pu_lsb_c   : integer := 0;
  constant io_d4_in_pu_msb_c   : integer := 0;
  subtype io_d4_in_pu_t is std_ulogic;
  constant io_d4_in_pu_reset_c : io_d4_in_pu_t := '0';
  constant io_d4_in_pu_scan_c  : io_d4_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d5_out"
  constant io_d5_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d5_out_ds_size_c  : integer := 2;
  constant io_d5_out_ds_lsb_c   : integer := 4;
  constant io_d5_out_ds_msb_c   : integer := 5;
  subtype io_d5_out_ds_t is std_ulogic_vector(io_d5_out_ds_size_c - 1 downto 0);
  constant io_d5_out_ds_reset_c : io_d5_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d5_out_ds_t'length));
  constant io_d5_out_ds_scan_c  : io_d5_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d5_out_ds_t'length));

  -- Field "sr"
  constant io_d5_out_sr_size_c  : integer := 1;
  constant io_d5_out_sr_lsb_c   : integer := 3;
  constant io_d5_out_sr_msb_c   : integer := 3;
  subtype io_d5_out_sr_t is std_ulogic;
  constant io_d5_out_sr_reset_c : io_d5_out_sr_t := '1';
  constant io_d5_out_sr_scan_c  : io_d5_out_sr_t := '1';

  -- Field "co"
  constant io_d5_out_co_size_c  : integer := 1;
  constant io_d5_out_co_lsb_c   : integer := 2;
  constant io_d5_out_co_msb_c   : integer := 2;
  subtype io_d5_out_co_t is std_ulogic;
  constant io_d5_out_co_reset_c : io_d5_out_co_t := '0';
  constant io_d5_out_co_scan_c  : io_d5_out_co_t := '0';

  -- Field "odp"
  constant io_d5_out_odp_size_c  : integer := 1;
  constant io_d5_out_odp_lsb_c   : integer := 1;
  constant io_d5_out_odp_msb_c   : integer := 1;
  subtype io_d5_out_odp_t is std_ulogic;
  constant io_d5_out_odp_reset_c : io_d5_out_odp_t := '0';
  constant io_d5_out_odp_scan_c  : io_d5_out_odp_t := '0';

  -- Field "odn"
  constant io_d5_out_odn_size_c  : integer := 1;
  constant io_d5_out_odn_lsb_c   : integer := 0;
  constant io_d5_out_odn_msb_c   : integer := 0;
  subtype io_d5_out_odn_t is std_ulogic;
  constant io_d5_out_odn_reset_c : io_d5_out_odn_t := '0';
  constant io_d5_out_odn_scan_c  : io_d5_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d5_in"
  constant io_d5_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d5_in_ste_size_c  : integer := 2;
  constant io_d5_in_ste_lsb_c   : integer := 2;
  constant io_d5_in_ste_msb_c   : integer := 3;
  subtype io_d5_in_ste_t is std_ulogic_vector(io_d5_in_ste_size_c - 1 downto 0);
  constant io_d5_in_ste_reset_c : io_d5_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d5_in_ste_t'length));
  constant io_d5_in_ste_scan_c  : io_d5_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d5_in_ste_t'length));

  -- Field "pd"
  constant io_d5_in_pd_size_c  : integer := 1;
  constant io_d5_in_pd_lsb_c   : integer := 1;
  constant io_d5_in_pd_msb_c   : integer := 1;
  subtype io_d5_in_pd_t is std_ulogic;
  constant io_d5_in_pd_reset_c : io_d5_in_pd_t := '0';
  constant io_d5_in_pd_scan_c  : io_d5_in_pd_t := '0';

  -- Field "pu"
  constant io_d5_in_pu_size_c  : integer := 1;
  constant io_d5_in_pu_lsb_c   : integer := 0;
  constant io_d5_in_pu_msb_c   : integer := 0;
  subtype io_d5_in_pu_t is std_ulogic;
  constant io_d5_in_pu_reset_c : io_d5_in_pu_t := '0';
  constant io_d5_in_pu_scan_c  : io_d5_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d6_out"
  constant io_d6_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d6_out_ds_size_c  : integer := 2;
  constant io_d6_out_ds_lsb_c   : integer := 4;
  constant io_d6_out_ds_msb_c   : integer := 5;
  subtype io_d6_out_ds_t is std_ulogic_vector(io_d6_out_ds_size_c - 1 downto 0);
  constant io_d6_out_ds_reset_c : io_d6_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d6_out_ds_t'length));
  constant io_d6_out_ds_scan_c  : io_d6_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d6_out_ds_t'length));

  -- Field "sr"
  constant io_d6_out_sr_size_c  : integer := 1;
  constant io_d6_out_sr_lsb_c   : integer := 3;
  constant io_d6_out_sr_msb_c   : integer := 3;
  subtype io_d6_out_sr_t is std_ulogic;
  constant io_d6_out_sr_reset_c : io_d6_out_sr_t := '1';
  constant io_d6_out_sr_scan_c  : io_d6_out_sr_t := '1';

  -- Field "co"
  constant io_d6_out_co_size_c  : integer := 1;
  constant io_d6_out_co_lsb_c   : integer := 2;
  constant io_d6_out_co_msb_c   : integer := 2;
  subtype io_d6_out_co_t is std_ulogic;
  constant io_d6_out_co_reset_c : io_d6_out_co_t := '0';
  constant io_d6_out_co_scan_c  : io_d6_out_co_t := '0';

  -- Field "odp"
  constant io_d6_out_odp_size_c  : integer := 1;
  constant io_d6_out_odp_lsb_c   : integer := 1;
  constant io_d6_out_odp_msb_c   : integer := 1;
  subtype io_d6_out_odp_t is std_ulogic;
  constant io_d6_out_odp_reset_c : io_d6_out_odp_t := '0';
  constant io_d6_out_odp_scan_c  : io_d6_out_odp_t := '0';

  -- Field "odn"
  constant io_d6_out_odn_size_c  : integer := 1;
  constant io_d6_out_odn_lsb_c   : integer := 0;
  constant io_d6_out_odn_msb_c   : integer := 0;
  subtype io_d6_out_odn_t is std_ulogic;
  constant io_d6_out_odn_reset_c : io_d6_out_odn_t := '0';
  constant io_d6_out_odn_scan_c  : io_d6_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d6_in"
  constant io_d6_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d6_in_ste_size_c  : integer := 2;
  constant io_d6_in_ste_lsb_c   : integer := 2;
  constant io_d6_in_ste_msb_c   : integer := 3;
  subtype io_d6_in_ste_t is std_ulogic_vector(io_d6_in_ste_size_c - 1 downto 0);
  constant io_d6_in_ste_reset_c : io_d6_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d6_in_ste_t'length));
  constant io_d6_in_ste_scan_c  : io_d6_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d6_in_ste_t'length));

  -- Field "pd"
  constant io_d6_in_pd_size_c  : integer := 1;
  constant io_d6_in_pd_lsb_c   : integer := 1;
  constant io_d6_in_pd_msb_c   : integer := 1;
  subtype io_d6_in_pd_t is std_ulogic;
  constant io_d6_in_pd_reset_c : io_d6_in_pd_t := '0';
  constant io_d6_in_pd_scan_c  : io_d6_in_pd_t := '0';

  -- Field "pu"
  constant io_d6_in_pu_size_c  : integer := 1;
  constant io_d6_in_pu_lsb_c   : integer := 0;
  constant io_d6_in_pu_msb_c   : integer := 0;
  subtype io_d6_in_pu_t is std_ulogic;
  constant io_d6_in_pu_reset_c : io_d6_in_pu_t := '0';
  constant io_d6_in_pu_scan_c  : io_d6_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d7_out"
  constant io_d7_out_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_d7_out_ds_size_c  : integer := 2;
  constant io_d7_out_ds_lsb_c   : integer := 4;
  constant io_d7_out_ds_msb_c   : integer := 5;
  subtype io_d7_out_ds_t is std_ulogic_vector(io_d7_out_ds_size_c - 1 downto 0);
  constant io_d7_out_ds_reset_c : io_d7_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d7_out_ds_t'length));
  constant io_d7_out_ds_scan_c  : io_d7_out_ds_t := std_ulogic_vector(to_unsigned(2, io_d7_out_ds_t'length));

  -- Field "sr"
  constant io_d7_out_sr_size_c  : integer := 1;
  constant io_d7_out_sr_lsb_c   : integer := 3;
  constant io_d7_out_sr_msb_c   : integer := 3;
  subtype io_d7_out_sr_t is std_ulogic;
  constant io_d7_out_sr_reset_c : io_d7_out_sr_t := '1';
  constant io_d7_out_sr_scan_c  : io_d7_out_sr_t := '1';

  -- Field "co"
  constant io_d7_out_co_size_c  : integer := 1;
  constant io_d7_out_co_lsb_c   : integer := 2;
  constant io_d7_out_co_msb_c   : integer := 2;
  subtype io_d7_out_co_t is std_ulogic;
  constant io_d7_out_co_reset_c : io_d7_out_co_t := '0';
  constant io_d7_out_co_scan_c  : io_d7_out_co_t := '0';

  -- Field "odp"
  constant io_d7_out_odp_size_c  : integer := 1;
  constant io_d7_out_odp_lsb_c   : integer := 1;
  constant io_d7_out_odp_msb_c   : integer := 1;
  subtype io_d7_out_odp_t is std_ulogic;
  constant io_d7_out_odp_reset_c : io_d7_out_odp_t := '0';
  constant io_d7_out_odp_scan_c  : io_d7_out_odp_t := '0';

  -- Field "odn"
  constant io_d7_out_odn_size_c  : integer := 1;
  constant io_d7_out_odn_lsb_c   : integer := 0;
  constant io_d7_out_odn_msb_c   : integer := 0;
  subtype io_d7_out_odn_t is std_ulogic;
  constant io_d7_out_odn_reset_c : io_d7_out_odn_t := '0';
  constant io_d7_out_odn_scan_c  : io_d7_out_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_d7_in"
  constant io_d7_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#00#, register_t'length));

  -- Field "ste"
  constant io_d7_in_ste_size_c  : integer := 2;
  constant io_d7_in_ste_lsb_c   : integer := 2;
  constant io_d7_in_ste_msb_c   : integer := 3;
  subtype io_d7_in_ste_t is std_ulogic_vector(io_d7_in_ste_size_c - 1 downto 0);
  constant io_d7_in_ste_reset_c : io_d7_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d7_in_ste_t'length));
  constant io_d7_in_ste_scan_c  : io_d7_in_ste_t := std_ulogic_vector(to_unsigned(0, io_d7_in_ste_t'length));

  -- Field "pd"
  constant io_d7_in_pd_size_c  : integer := 1;
  constant io_d7_in_pd_lsb_c   : integer := 1;
  constant io_d7_in_pd_msb_c   : integer := 1;
  subtype io_d7_in_pd_t is std_ulogic;
  constant io_d7_in_pd_reset_c : io_d7_in_pd_t := '0';
  constant io_d7_in_pd_scan_c  : io_d7_in_pd_t := '0';

  -- Field "pu"
  constant io_d7_in_pu_size_c  : integer := 1;
  constant io_d7_in_pu_lsb_c   : integer := 0;
  constant io_d7_in_pu_msb_c   : integer := 0;
  subtype io_d7_in_pu_t is std_ulogic;
  constant io_d7_in_pu_reset_c : io_d7_in_pu_t := '0';
  constant io_d7_in_pu_scan_c  : io_d7_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_ldout_n"
  constant io_ldout_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_ldout_n_ds_size_c  : integer := 2;
  constant io_ldout_n_ds_lsb_c   : integer := 4;
  constant io_ldout_n_ds_msb_c   : integer := 5;
  subtype io_ldout_n_ds_t is std_ulogic_vector(io_ldout_n_ds_size_c - 1 downto 0);
  constant io_ldout_n_ds_reset_c : io_ldout_n_ds_t := std_ulogic_vector(to_unsigned(2, io_ldout_n_ds_t'length));
  constant io_ldout_n_ds_scan_c  : io_ldout_n_ds_t := std_ulogic_vector(to_unsigned(2, io_ldout_n_ds_t'length));

  -- Field "sr"
  constant io_ldout_n_sr_size_c  : integer := 1;
  constant io_ldout_n_sr_lsb_c   : integer := 3;
  constant io_ldout_n_sr_msb_c   : integer := 3;
  subtype io_ldout_n_sr_t is std_ulogic;
  constant io_ldout_n_sr_reset_c : io_ldout_n_sr_t := '1';
  constant io_ldout_n_sr_scan_c  : io_ldout_n_sr_t := '1';

  -- Field "co"
  constant io_ldout_n_co_size_c  : integer := 1;
  constant io_ldout_n_co_lsb_c   : integer := 2;
  constant io_ldout_n_co_msb_c   : integer := 2;
  subtype io_ldout_n_co_t is std_ulogic;
  constant io_ldout_n_co_reset_c : io_ldout_n_co_t := '0';
  constant io_ldout_n_co_scan_c  : io_ldout_n_co_t := '0';

  -- Field "odp"
  constant io_ldout_n_odp_size_c  : integer := 1;
  constant io_ldout_n_odp_lsb_c   : integer := 1;
  constant io_ldout_n_odp_msb_c   : integer := 1;
  subtype io_ldout_n_odp_t is std_ulogic;
  constant io_ldout_n_odp_reset_c : io_ldout_n_odp_t := '0';
  constant io_ldout_n_odp_scan_c  : io_ldout_n_odp_t := '0';

  -- Field "odn"
  constant io_ldout_n_odn_size_c  : integer := 1;
  constant io_ldout_n_odn_lsb_c   : integer := 0;
  constant io_ldout_n_odn_msb_c   : integer := 0;
  subtype io_ldout_n_odn_t is std_ulogic;
  constant io_ldout_n_odn_reset_c : io_ldout_n_odn_t := '0';
  constant io_ldout_n_odn_scan_c  : io_ldout_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_next_n"
  constant io_next_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_next_n_ds_size_c  : integer := 2;
  constant io_next_n_ds_lsb_c   : integer := 4;
  constant io_next_n_ds_msb_c   : integer := 5;
  subtype io_next_n_ds_t is std_ulogic_vector(io_next_n_ds_size_c - 1 downto 0);
  constant io_next_n_ds_reset_c : io_next_n_ds_t := std_ulogic_vector(to_unsigned(2, io_next_n_ds_t'length));
  constant io_next_n_ds_scan_c  : io_next_n_ds_t := std_ulogic_vector(to_unsigned(2, io_next_n_ds_t'length));

  -- Field "sr"
  constant io_next_n_sr_size_c  : integer := 1;
  constant io_next_n_sr_lsb_c   : integer := 3;
  constant io_next_n_sr_msb_c   : integer := 3;
  subtype io_next_n_sr_t is std_ulogic;
  constant io_next_n_sr_reset_c : io_next_n_sr_t := '1';
  constant io_next_n_sr_scan_c  : io_next_n_sr_t := '1';

  -- Field "co"
  constant io_next_n_co_size_c  : integer := 1;
  constant io_next_n_co_lsb_c   : integer := 2;
  constant io_next_n_co_msb_c   : integer := 2;
  subtype io_next_n_co_t is std_ulogic;
  constant io_next_n_co_reset_c : io_next_n_co_t := '0';
  constant io_next_n_co_scan_c  : io_next_n_co_t := '0';

  -- Field "odp"
  constant io_next_n_odp_size_c  : integer := 1;
  constant io_next_n_odp_lsb_c   : integer := 1;
  constant io_next_n_odp_msb_c   : integer := 1;
  subtype io_next_n_odp_t is std_ulogic;
  constant io_next_n_odp_reset_c : io_next_n_odp_t := '0';
  constant io_next_n_odp_scan_c  : io_next_n_odp_t := '0';

  -- Field "odn"
  constant io_next_n_odn_size_c  : integer := 1;
  constant io_next_n_odn_lsb_c   : integer := 0;
  constant io_next_n_odn_msb_c   : integer := 0;
  subtype io_next_n_odn_t is std_ulogic;
  constant io_next_n_odn_reset_c : io_next_n_odn_t := '0';
  constant io_next_n_odn_scan_c  : io_next_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_clk"
  constant io_clk_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_clk_ds_size_c  : integer := 2;
  constant io_clk_ds_lsb_c   : integer := 4;
  constant io_clk_ds_msb_c   : integer := 5;
  subtype io_clk_ds_t is std_ulogic_vector(io_clk_ds_size_c - 1 downto 0);
  constant io_clk_ds_reset_c : io_clk_ds_t := std_ulogic_vector(to_unsigned(2, io_clk_ds_t'length));
  constant io_clk_ds_scan_c  : io_clk_ds_t := std_ulogic_vector(to_unsigned(2, io_clk_ds_t'length));

  -- Field "sr"
  constant io_clk_sr_size_c  : integer := 1;
  constant io_clk_sr_lsb_c   : integer := 3;
  constant io_clk_sr_msb_c   : integer := 3;
  subtype io_clk_sr_t is std_ulogic;
  constant io_clk_sr_reset_c : io_clk_sr_t := '1';
  constant io_clk_sr_scan_c  : io_clk_sr_t := '1';

  -- Field "co"
  constant io_clk_co_size_c  : integer := 1;
  constant io_clk_co_lsb_c   : integer := 2;
  constant io_clk_co_msb_c   : integer := 2;
  subtype io_clk_co_t is std_ulogic;
  constant io_clk_co_reset_c : io_clk_co_t := '0';
  constant io_clk_co_scan_c  : io_clk_co_t := '0';

  -- Field "odp"
  constant io_clk_odp_size_c  : integer := 1;
  constant io_clk_odp_lsb_c   : integer := 1;
  constant io_clk_odp_msb_c   : integer := 1;
  subtype io_clk_odp_t is std_ulogic;
  constant io_clk_odp_reset_c : io_clk_odp_t := '0';
  constant io_clk_odp_scan_c  : io_clk_odp_t := '0';

  -- Field "odn"
  constant io_clk_odn_size_c  : integer := 1;
  constant io_clk_odn_lsb_c   : integer := 0;
  constant io_clk_odn_msb_c   : integer := 0;
  subtype io_clk_odn_t is std_ulogic;
  constant io_clk_odn_reset_c : io_clk_odn_t := '0';
  constant io_clk_odn_scan_c  : io_clk_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "io_ioa_n"
  constant io_ioa_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant io_ioa_n_ds_size_c  : integer := 2;
  constant io_ioa_n_ds_lsb_c   : integer := 4;
  constant io_ioa_n_ds_msb_c   : integer := 5;
  subtype io_ioa_n_ds_t is std_ulogic_vector(io_ioa_n_ds_size_c - 1 downto 0);
  constant io_ioa_n_ds_reset_c : io_ioa_n_ds_t := std_ulogic_vector(to_unsigned(2, io_ioa_n_ds_t'length));
  constant io_ioa_n_ds_scan_c  : io_ioa_n_ds_t := std_ulogic_vector(to_unsigned(2, io_ioa_n_ds_t'length));

  -- Field "sr"
  constant io_ioa_n_sr_size_c  : integer := 1;
  constant io_ioa_n_sr_lsb_c   : integer := 3;
  constant io_ioa_n_sr_msb_c   : integer := 3;
  subtype io_ioa_n_sr_t is std_ulogic;
  constant io_ioa_n_sr_reset_c : io_ioa_n_sr_t := '1';
  constant io_ioa_n_sr_scan_c  : io_ioa_n_sr_t := '1';

  -- Field "co"
  constant io_ioa_n_co_size_c  : integer := 1;
  constant io_ioa_n_co_lsb_c   : integer := 2;
  constant io_ioa_n_co_msb_c   : integer := 2;
  subtype io_ioa_n_co_t is std_ulogic;
  constant io_ioa_n_co_reset_c : io_ioa_n_co_t := '0';
  constant io_ioa_n_co_scan_c  : io_ioa_n_co_t := '0';

  -- Field "odp"
  constant io_ioa_n_odp_size_c  : integer := 1;
  constant io_ioa_n_odp_lsb_c   : integer := 1;
  constant io_ioa_n_odp_msb_c   : integer := 1;
  subtype io_ioa_n_odp_t is std_ulogic;
  constant io_ioa_n_odp_reset_c : io_ioa_n_odp_t := '0';
  constant io_ioa_n_odp_scan_c  : io_ioa_n_odp_t := '0';

  -- Field "odn"
  constant io_ioa_n_odn_size_c  : integer := 1;
  constant io_ioa_n_odn_lsb_c   : integer := 0;
  constant io_ioa_n_odn_msb_c   : integer := 0;
  subtype io_ioa_n_odn_t is std_ulogic;
  constant io_ioa_n_odn_reset_c : io_ioa_n_odn_t := '0';
  constant io_ioa_n_odn_scan_c  : io_ioa_n_odn_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mrxout_in"
  constant mrxout_in_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "ste"
  constant mrxout_in_ste_size_c  : integer := 2;
  constant mrxout_in_ste_lsb_c   : integer := 2;
  constant mrxout_in_ste_msb_c   : integer := 3;
  subtype mrxout_in_ste_t is std_ulogic_vector(mrxout_in_ste_size_c - 1 downto 0);
  constant mrxout_in_ste_reset_c : mrxout_in_ste_t := std_ulogic_vector(to_unsigned(0, mrxout_in_ste_t'length));
  constant mrxout_in_ste_scan_c  : mrxout_in_ste_t := std_ulogic_vector(to_unsigned(0, mrxout_in_ste_t'length));

  -- Field "pd"
  constant mrxout_in_pd_size_c  : integer := 1;
  constant mrxout_in_pd_lsb_c   : integer := 1;
  constant mrxout_in_pd_msb_c   : integer := 1;
  subtype mrxout_in_pd_t is std_ulogic;
  constant mrxout_in_pd_reset_c : mrxout_in_pd_t := '1';
  constant mrxout_in_pd_scan_c  : mrxout_in_pd_t := '1';

  -- Field "pu"
  constant mrxout_in_pu_size_c  : integer := 1;
  constant mrxout_in_pu_lsb_c   : integer := 0;
  constant mrxout_in_pu_msb_c   : integer := 0;
  subtype mrxout_in_pu_t is std_ulogic;
  constant mrxout_in_pu_reset_c : mrxout_in_pu_t := '0';
  constant mrxout_in_pu_scan_c  : mrxout_in_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mreset_n"
  constant mreset_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "ste"
  constant mreset_n_ste_size_c  : integer := 2;
  constant mreset_n_ste_lsb_c   : integer := 2;
  constant mreset_n_ste_msb_c   : integer := 3;
  subtype mreset_n_ste_t is std_ulogic_vector(mreset_n_ste_size_c - 1 downto 0);
  constant mreset_n_ste_reset_c : mreset_n_ste_t := std_ulogic_vector(to_unsigned(0, mreset_n_ste_t'length));
  constant mreset_n_ste_scan_c  : mreset_n_ste_t := std_ulogic_vector(to_unsigned(0, mreset_n_ste_t'length));

  -- Field "pd"
  constant mreset_n_pd_size_c  : integer := 1;
  constant mreset_n_pd_lsb_c   : integer := 1;
  constant mreset_n_pd_msb_c   : integer := 1;
  subtype mreset_n_pd_t is std_ulogic;
  constant mreset_n_pd_reset_c : mreset_n_pd_t := '1';
  constant mreset_n_pd_scan_c  : mreset_n_pd_t := '1';

  -- Field "pu"
  constant mreset_n_pu_size_c  : integer := 1;
  constant mreset_n_pu_lsb_c   : integer := 0;
  constant mreset_n_pu_msb_c   : integer := 0;
  subtype mreset_n_pu_t is std_ulogic;
  constant mreset_n_pu_reset_c : mreset_n_pu_t := '0';
  constant mreset_n_pu_scan_c  : mreset_n_pu_t := '0';

  ---------------------------------------------------------------------------
  -- Register "mrstout_n"
  constant mrstout_n_reset_c : register_t := std_ulogic_vector(to_unsigned(16#28#, register_t'length));

  -- Field "ds"
  constant mrstout_n_ds_size_c  : integer := 2;
  constant mrstout_n_ds_lsb_c   : integer := 4;
  constant mrstout_n_ds_msb_c   : integer := 5;
  subtype mrstout_n_ds_t is std_ulogic_vector(mrstout_n_ds_size_c - 1 downto 0);
  constant mrstout_n_ds_reset_c : mrstout_n_ds_t := std_ulogic_vector(to_unsigned(2, mrstout_n_ds_t'length));
  constant mrstout_n_ds_scan_c  : mrstout_n_ds_t := std_ulogic_vector(to_unsigned(2, mrstout_n_ds_t'length));

  -- Field "sr"
  constant mrstout_n_sr_size_c  : integer := 1;
  constant mrstout_n_sr_lsb_c   : integer := 3;
  constant mrstout_n_sr_msb_c   : integer := 3;
  subtype mrstout_n_sr_t is std_ulogic;
  constant mrstout_n_sr_reset_c : mrstout_n_sr_t := '1';
  constant mrstout_n_sr_scan_c  : mrstout_n_sr_t := '1';

  -- Field "co"
  constant mrstout_n_co_size_c  : integer := 1;
  constant mrstout_n_co_lsb_c   : integer := 2;
  constant mrstout_n_co_msb_c   : integer := 2;
  subtype mrstout_n_co_t is std_ulogic;
  constant mrstout_n_co_reset_c : mrstout_n_co_t := '0';
  constant mrstout_n_co_scan_c  : mrstout_n_co_t := '0';

  -- Field "odp"
  constant mrstout_n_odp_size_c  : integer := 1;
  constant mrstout_n_odp_lsb_c   : integer := 1;
  constant mrstout_n_odp_msb_c   : integer := 1;
  subtype mrstout_n_odp_t is std_ulogic;
  constant mrstout_n_odp_reset_c : mrstout_n_odp_t := '0';
  constant mrstout_n_odp_scan_c  : mrstout_n_odp_t := '0';

  -- Field "odn"
  constant mrstout_n_odn_size_c  : integer := 1;
  constant mrstout_n_odn_lsb_c   : integer := 0;
  constant mrstout_n_odn_msb_c   : integer := 0;
  subtype mrstout_n_odn_t is std_ulogic;
  constant mrstout_n_odn_reset_c : mrstout_n_odn_t := '0';
  constant mrstout_n_odn_scan_c  : mrstout_n_odn_t := '0';

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
          mrxout_out_ds : out mrxout_out_ds_t;
          mrxout_out_sr : out mrxout_out_sr_t;
          mrxout_out_co : out mrxout_out_co_t;
          mrxout_out_odp : out mrxout_out_odp_t;
          mrxout_out_odn : out mrxout_out_odn_t;
          pll_1_main_div_n1 : out pll_1_main_div_n1_t;
          pll_1_main_div_n2 : out pll_1_main_div_n2_t;
          pll_1_main_div_n3 : out pll_1_main_div_n3_t;
          pll_1_main_div_n4 : out pll_1_main_div_n4_t;
          pll_2_open_loop : out pll_2_open_loop_t;
          pll_2_out_div_sel : out pll_2_out_div_sel_t;
          pll_2_ci : out pll_2_ci_t;
          pll_cp_cp : out pll_cp_cp_t;
          pll_ft_ft : out pll_ft_ft_t;
          pll_3_divcore_sel : out pll_3_divcore_sel_t;
          pll_3_coarse : out pll_3_coarse_t;
          pll_4_auto_coarsetune : out pll_4_auto_coarsetune_t;
          pll_4_enforce_lock : out pll_4_enforce_lock_t;
          pll_4_pfd_select : out pll_4_pfd_select_t;
          pll_4_lock_window_sel : out pll_4_lock_window_sel_t;
          pll_4_div_core_mux_sel : out pll_4_div_core_mux_sel_t;
          pll_4_filter_shift : out pll_4_filter_shift_t;
          pll_4_en_fast_lock : out pll_4_en_fast_lock_t;
          pll_5_sar_limit : out pll_5_sar_limit_t;
          pll_5_set_op_lock : out pll_5_set_op_lock_t;
          pll_5_disable_lock : out pll_5_disable_lock_t;
          pll_5_ref_bypass : out pll_5_ref_bypass_t;
          pll_5_ct_compensation : out pll_5_ct_compensation_t;
          adpll_status0_adpll_status_0 : in  adpll_status0_adpll_status_0_t;
          adpll_status1_adpll_status_1 : in  adpll_status1_adpll_status_1_t;
          adpll_status2_adpll_status_2 : in  adpll_status2_adpll_status_2_t;
          io_dack0_n_ste : out io_dack0_n_ste_t;
          io_dack0_n_pd : out io_dack0_n_pd_t;
          io_dack0_n_pu : out io_dack0_n_pu_t;
          io_dreq0_n_ds : out io_dreq0_n_ds_t;
          io_dreq0_n_sr : out io_dreq0_n_sr_t;
          io_dreq0_n_co : out io_dreq0_n_co_t;
          io_dreq0_n_odp : out io_dreq0_n_odp_t;
          io_dreq0_n_odn : out io_dreq0_n_odn_t;
          io_dack1_n_ste : out io_dack1_n_ste_t;
          io_dack1_n_pd : out io_dack1_n_pd_t;
          io_dack1_n_pu : out io_dack1_n_pu_t;
          io_dreq1_n_ds : out io_dreq1_n_ds_t;
          io_dreq1_n_sr : out io_dreq1_n_sr_t;
          io_dreq1_n_co : out io_dreq1_n_co_t;
          io_dreq1_n_odp : out io_dreq1_n_odp_t;
          io_dreq1_n_odn : out io_dreq1_n_odn_t;
          io_dack2_n_ste : out io_dack2_n_ste_t;
          io_dack2_n_pd : out io_dack2_n_pd_t;
          io_dack2_n_pu : out io_dack2_n_pu_t;
          io_dreq2_n_ds : out io_dreq2_n_ds_t;
          io_dreq2_n_sr : out io_dreq2_n_sr_t;
          io_dreq2_n_co : out io_dreq2_n_co_t;
          io_dreq2_n_odp : out io_dreq2_n_odp_t;
          io_dreq2_n_odn : out io_dreq2_n_odn_t;
          io_dack3_n_ste : out io_dack3_n_ste_t;
          io_dack3_n_pd : out io_dack3_n_pd_t;
          io_dack3_n_pu : out io_dack3_n_pu_t;
          io_dreq3_n_ds : out io_dreq3_n_ds_t;
          io_dreq3_n_sr : out io_dreq3_n_sr_t;
          io_dreq3_n_co : out io_dreq3_n_co_t;
          io_dreq3_n_odp : out io_dreq3_n_odp_t;
          io_dreq3_n_odn : out io_dreq3_n_odn_t;
          io_d0_out_ds : out io_d0_out_ds_t;
          io_d0_out_sr : out io_d0_out_sr_t;
          io_d0_out_co : out io_d0_out_co_t;
          io_d0_out_odp : out io_d0_out_odp_t;
          io_d0_out_odn : out io_d0_out_odn_t;
          io_d0_in_ste : out io_d0_in_ste_t;
          io_d0_in_pd : out io_d0_in_pd_t;
          io_d0_in_pu : out io_d0_in_pu_t;
          io_d1_out_ds : out io_d1_out_ds_t;
          io_d1_out_sr : out io_d1_out_sr_t;
          io_d1_out_co : out io_d1_out_co_t;
          io_d1_out_odp : out io_d1_out_odp_t;
          io_d1_out_odn : out io_d1_out_odn_t;
          io_d1_in_ste : out io_d1_in_ste_t;
          io_d1_in_pd : out io_d1_in_pd_t;
          io_d1_in_pu : out io_d1_in_pu_t;
          io_d2_out_ds : out io_d2_out_ds_t;
          io_d2_out_sr : out io_d2_out_sr_t;
          io_d2_out_co : out io_d2_out_co_t;
          io_d2_out_odp : out io_d2_out_odp_t;
          io_d2_out_odn : out io_d2_out_odn_t;
          io_d2_in_ste : out io_d2_in_ste_t;
          io_d2_in_pd : out io_d2_in_pd_t;
          io_d2_in_pu : out io_d2_in_pu_t;
          io_d3_out_ds : out io_d3_out_ds_t;
          io_d3_out_sr : out io_d3_out_sr_t;
          io_d3_out_co : out io_d3_out_co_t;
          io_d3_out_odp : out io_d3_out_odp_t;
          io_d3_out_odn : out io_d3_out_odn_t;
          io_d3_in_ste : out io_d3_in_ste_t;
          io_d3_in_pd : out io_d3_in_pd_t;
          io_d3_in_pu : out io_d3_in_pu_t;
          io_d4_out_ds : out io_d4_out_ds_t;
          io_d4_out_sr : out io_d4_out_sr_t;
          io_d4_out_co : out io_d4_out_co_t;
          io_d4_out_odp : out io_d4_out_odp_t;
          io_d4_out_odn : out io_d4_out_odn_t;
          io_d4_in_ste : out io_d4_in_ste_t;
          io_d4_in_pd : out io_d4_in_pd_t;
          io_d4_in_pu : out io_d4_in_pu_t;
          io_d5_out_ds : out io_d5_out_ds_t;
          io_d5_out_sr : out io_d5_out_sr_t;
          io_d5_out_co : out io_d5_out_co_t;
          io_d5_out_odp : out io_d5_out_odp_t;
          io_d5_out_odn : out io_d5_out_odn_t;
          io_d5_in_ste : out io_d5_in_ste_t;
          io_d5_in_pd : out io_d5_in_pd_t;
          io_d5_in_pu : out io_d5_in_pu_t;
          io_d6_out_ds : out io_d6_out_ds_t;
          io_d6_out_sr : out io_d6_out_sr_t;
          io_d6_out_co : out io_d6_out_co_t;
          io_d6_out_odp : out io_d6_out_odp_t;
          io_d6_out_odn : out io_d6_out_odn_t;
          io_d6_in_ste : out io_d6_in_ste_t;
          io_d6_in_pd : out io_d6_in_pd_t;
          io_d6_in_pu : out io_d6_in_pu_t;
          io_d7_out_ds : out io_d7_out_ds_t;
          io_d7_out_sr : out io_d7_out_sr_t;
          io_d7_out_co : out io_d7_out_co_t;
          io_d7_out_odp : out io_d7_out_odp_t;
          io_d7_out_odn : out io_d7_out_odn_t;
          io_d7_in_ste : out io_d7_in_ste_t;
          io_d7_in_pd : out io_d7_in_pd_t;
          io_d7_in_pu : out io_d7_in_pu_t;
          io_ldout_n_ds : out io_ldout_n_ds_t;
          io_ldout_n_sr : out io_ldout_n_sr_t;
          io_ldout_n_co : out io_ldout_n_co_t;
          io_ldout_n_odp : out io_ldout_n_odp_t;
          io_ldout_n_odn : out io_ldout_n_odn_t;
          io_next_n_ds : out io_next_n_ds_t;
          io_next_n_sr : out io_next_n_sr_t;
          io_next_n_co : out io_next_n_co_t;
          io_next_n_odp : out io_next_n_odp_t;
          io_next_n_odn : out io_next_n_odn_t;
          io_clk_ds : out io_clk_ds_t;
          io_clk_sr : out io_clk_sr_t;
          io_clk_co : out io_clk_co_t;
          io_clk_odp : out io_clk_odp_t;
          io_clk_odn : out io_clk_odn_t;
          io_ioa_n_ds : out io_ioa_n_ds_t;
          io_ioa_n_sr : out io_ioa_n_sr_t;
          io_ioa_n_co : out io_ioa_n_co_t;
          io_ioa_n_odp : out io_ioa_n_odp_t;
          io_ioa_n_odn : out io_ioa_n_odn_t;
          mrxout_in_ste : out mrxout_in_ste_t;
          mrxout_in_pd : out mrxout_in_pd_t;
          mrxout_in_pu : out mrxout_in_pu_t;
          mreset_n_ste : out mreset_n_ste_t;
          mreset_n_pd : out mreset_n_pd_t;
          mreset_n_pu : out mreset_n_pu_t;
          mrstout_n_ds : out mrstout_n_ds_t;
          mrstout_n_sr : out mrstout_n_sr_t;
          mrstout_n_co : out mrstout_n_co_t;
          mrstout_n_odp : out mrstout_n_odp_t;
          mrstout_n_odn : out mrstout_n_odn_t;


          -- SPI Interface
          write_cmd : in  std_ulogic;
          enable    : in  std_ulogic;
          address   : in  std_ulogic_vector(6 downto 0);
          data_in   : in  std_ulogic_vector(7 downto 0);
          data_out  : out std_ulogic_vector(7 downto 0)
    );
  end component;

end register_pack_spi_test;
