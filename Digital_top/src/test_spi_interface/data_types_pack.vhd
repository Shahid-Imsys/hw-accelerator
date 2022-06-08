library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.all;

package data_types_pack is

  type output_pad_config_record_t is record
    ds  : mclkout_ds_t;
    sr  : mclkout_sr_t;
    co  : mclkout_co_t;
    odp : mclkout_odp_t;
    odn : mclkout_odn_t;
  end record output_pad_config_record_t;

  type input_pad_record is record
    ste : msdin_ste_t;
    pd  : msdin_pd_t;
    pu  : msdin_pu_t;
  end record input_pad_record;
  
  type pad_config_record_t is record
    mckout : output_pad_config_record_t;
    msdout : output_pad_config_record_t;
    utx : output_pad_config_record_t;
    mirqout : output_pad_config_record_t;
    msdin : input_pad_record;
    mirq0 : input_pad_record;
    mirq1 : input_pad_record;
    urx : input_pad_record;
  end record pad_config_record_t;
end package data_types_pack;
