library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.project_settings.all;

package register_pack_spi_test is

  constant temp_version_spi_test : string := "$Revision: 0000 $";
  constant spi_test_base : integer := 16#0#;

  -- Register addresses

  constant version_address_c : integer := 16#00#;
  constant mclkout_address_c : integer := 16#01#;
  constant msdout_address_c  : integer := 16#02#;
  constant utx_address_c     : integer := 16#03#;
  constant mirqout_address_c : integer := 16#04#;
  constant msdin_address_c   : integer := 16#05#;
  constant mirq0_address_c   : integer := 16#06#;
  constant mirq1_address_c   : integer := 16#07#;
  constant urx_address_c     : integer := 16#08#;

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


          -- SPI Interface
          write_cmd : in  std_ulogic;
          enable    : in  std_ulogic;
          address   : in  std_ulogic_vector(3 downto 0);
          data_in   : in  std_ulogic_vector(7 downto 0);
          data_out  : out std_ulogic_vector(7 downto 0)
    );
  end component;

end register_pack_spi_test;
