library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.temp_version_spi_test;
use work.project_settings.all;
use work.register_tb_definitions.all;

package register_tb_package is

  constant spi_test_version_str : string            := temp_version_spi_test(12 to 15);
  constant spi_test_version_nr  : std_ulogic_vector := str_to_stdUlogicVector(spi_test_version_str);

  constant spi_test_base : integer := 16#0#;

  constant tb_spi_test_version_address_c : integer := spi_test_base + 0;
  constant tb_spi_test_mclkout_address_c : integer := spi_test_base + 1;
  constant tb_spi_test_msdout_address_c : integer := spi_test_base + 2;
  constant tb_spi_test_utx_address_c : integer := spi_test_base + 3;
  constant tb_spi_test_mirqout_address_c : integer := spi_test_base + 4;
  constant tb_spi_test_msdin_address_c : integer := spi_test_base + 5;
  constant tb_spi_test_mirq0_address_c : integer := spi_test_base + 6;
  constant tb_spi_test_mirq1_address_c : integer := spi_test_base + 7;
  constant tb_spi_test_urx_address_c : integer := spi_test_base + 8;

  constant spi_test_version : register_record_t := (resize("version"), int_to_stdUlogicVector(16#1#, 8), int_to_stdUlogicVector(16#0#, 8), tb_spi_test_version_address_c, r);
  constant spi_test_mclkout : register_record_t := (resize("mclkout"), int_to_stdUlogicVector(16#28#, 8), int_to_stdUlogicVector(16#3F#, 8), tb_spi_test_mclkout_address_c, rw);
  constant spi_test_msdout : register_record_t := (resize("msdout"), int_to_stdUlogicVector(16#28#, 8), int_to_stdUlogicVector(16#3F#, 8), tb_spi_test_msdout_address_c, rw);
  constant spi_test_utx : register_record_t := (resize("utx"), int_to_stdUlogicVector(16#28#, 8), int_to_stdUlogicVector(16#3F#, 8), tb_spi_test_utx_address_c, rw);
  constant spi_test_mirqout : register_record_t := (resize("mirqout"), int_to_stdUlogicVector(16#28#, 8), int_to_stdUlogicVector(16#3F#, 8), tb_spi_test_mirqout_address_c, rw);
  constant spi_test_msdin : register_record_t := (resize("msdin"), int_to_stdUlogicVector(16#0#, 8), int_to_stdUlogicVector(16#F#, 8), tb_spi_test_msdin_address_c, rw);
  constant spi_test_mirq0 : register_record_t := (resize("mirq0"), int_to_stdUlogicVector(16#0#, 8), int_to_stdUlogicVector(16#F#, 8), tb_spi_test_mirq0_address_c, rw);
  constant spi_test_mirq1 : register_record_t := (resize("mirq1"), int_to_stdUlogicVector(16#0#, 8), int_to_stdUlogicVector(16#F#, 8), tb_spi_test_mirq1_address_c, rw);
  constant spi_test_urx : register_record_t := (resize("urx"), int_to_stdUlogicVector(16#0#, 8), int_to_stdUlogicVector(16#F#, 8), tb_spi_test_urx_address_c, rw);

  constant all_register_list : register_list_t := (
    spi_test_version, 
    spi_test_mclkout, 
    spi_test_msdout, 
    spi_test_utx, 
    spi_test_mirqout, 
    spi_test_msdin, 
    spi_test_mirq0, 
    spi_test_mirq1, 
    spi_test_urx);

  -- Test bench field value constants

  ---------------------------------------------------------------------------
  -- Register "version"

  -- Field "analog"
  constant tb_version_analog_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#F0#, register_t'length));

  -- Field "digital"
  constant tb_version_digital_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#0F#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "mclkout"

  -- Field "ds"
  constant tb_mclkout_ds_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#30#, register_t'length));

  -- Field "sr"
  constant tb_mclkout_sr_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#08#, register_t'length));

  -- Field "co"
  constant tb_mclkout_co_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#04#, register_t'length));

  -- Field "odp"
  constant tb_mclkout_odp_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "odn"
  constant tb_mclkout_odn_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "msdout"

  -- Field "ds"
  constant tb_msdout_ds_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#30#, register_t'length));

  -- Field "sr"
  constant tb_msdout_sr_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#08#, register_t'length));

  -- Field "co"
  constant tb_msdout_co_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#04#, register_t'length));

  -- Field "odp"
  constant tb_msdout_odp_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "odn"
  constant tb_msdout_odn_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "utx"

  -- Field "ds"
  constant tb_utx_ds_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#30#, register_t'length));

  -- Field "sr"
  constant tb_utx_sr_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#08#, register_t'length));

  -- Field "co"
  constant tb_utx_co_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#04#, register_t'length));

  -- Field "odp"
  constant tb_utx_odp_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "odn"
  constant tb_utx_odn_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "mirqout"

  -- Field "ds"
  constant tb_mirqout_ds_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#30#, register_t'length));

  -- Field "sr"
  constant tb_mirqout_sr_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#08#, register_t'length));

  -- Field "co"
  constant tb_mirqout_co_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#04#, register_t'length));

  -- Field "odp"
  constant tb_mirqout_odp_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "odn"
  constant tb_mirqout_odn_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "msdin"

  -- Field "ste"
  constant tb_msdin_ste_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#0C#, register_t'length));

  -- Field "pd"
  constant tb_msdin_pd_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "pu"
  constant tb_msdin_pu_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "mirq0"

  -- Field "ste"
  constant tb_mirq0_ste_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#0C#, register_t'length));

  -- Field "pd"
  constant tb_mirq0_pd_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "pu"
  constant tb_mirq0_pu_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "mirq1"

  -- Field "ste"
  constant tb_mirq1_ste_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#0C#, register_t'length));

  -- Field "pd"
  constant tb_mirq1_pd_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "pu"
  constant tb_mirq1_pu_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

  ---------------------------------------------------------------------------
  -- Register "urx"

  -- Field "ste"
  constant tb_urx_ste_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#0C#, register_t'length));

  -- Field "pd"
  constant tb_urx_pd_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#02#, register_t'length));

  -- Field "pu"
  constant tb_urx_pu_mask_c  : register_t := std_ulogic_vector(to_unsigned(16#01#, register_t'length));

end package register_tb_package;
