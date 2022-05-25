library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.all;

package data_types_pack is

  type output_pad_config_record_t is record
    ds  : std_logic_vector(1 downto 0);
    sr  : std_logic;
    co  : std_logic;
    odp : std_logic;
    odn : std_logic;
  end record output_pad_config_record_t;

  type input_pad_config_record_t is record
    ste : std_logic_vector(1 downto 0);
    pd  : std_logic;
    pu  : std_logic;
  end record input_pad_config_record_t;
  
  type inoutput_pad_config_record_t is record
    ds  : std_logic_vector(1 downto 0);
    sr  : std_logic;
    co  : std_logic;
    odp : std_logic;
    odn : std_logic;
    ste : std_logic_vector(1 downto 0);
    pd  : std_logic;
    pu  : std_logic;
  end record inoutput_pad_config_record_t;

  type pad_config_record_t is record
    mclkout     : output_pad_config_record_t;
    msdin       : input_pad_config_record_t;
    msdout      : output_pad_config_record_t;
    mirqout     : output_pad_config_record_t;
    mirq0       : input_pad_config_record_t;
    mirq1       : input_pad_config_record_t;
    utx         : output_pad_config_record_t;
    urx         : input_pad_config_record_t;
    emem_d0     : inoutput_pad_config_record_t;
    emem_d1     : inoutput_pad_config_record_t;
    emem_d2     : inoutput_pad_config_record_t;
    emem_d3     : inoutput_pad_config_record_t;
    emem_d4     : inoutput_pad_config_record_t;
    emem_d5     : inoutput_pad_config_record_t;
    emem_d6     : inoutput_pad_config_record_t;
    emem_d7     : inoutput_pad_config_record_t;
    emem_clk    : output_pad_config_record_t;
    emem_rwds   : inoutput_pad_config_record_t;
    emem_cs_n   : inoutput_pad_config_record_t;
    emem_rst_n  : output_pad_config_record_t;
    aout0       : output_pad_config_record_t;
    aout1       : output_pad_config_record_t;
    ach0        : input_pad_config_record_t;
    enet_mdio   : inoutput_pad_config_record_t;
    enet_mdc    : output_pad_config_record_t;
    enet_txer   : output_pad_config_record_t;
    enet_txd0   : output_pad_config_record_t;
    enet_txd1   : output_pad_config_record_t;
    enet_txen   : output_pad_config_record_t;
    enet_clk    : input_pad_config_record_t;
    enet_rxdv   : input_pad_config_record_t;
    enet_rxd0   : input_pad_config_record_t;
    enet_rxd1   : input_pad_config_record_t;
    enet_rxer   : input_pad_config_record_t;
    spi_sclk    : input_pad_config_record_t;
    spi_cs_n    : input_pad_config_record_t;
    spi_mosi    : input_pad_config_record_t;
    spi_miso    : output_pad_config_record_t;
    pll_ref_clk : input_pad_config_record_t;
    preset_n    : input_pad_config_record_t;
    mreset_n    : input_pad_config_record_t;
    mrstout_n   : output_pad_config_record_t;
    pa0_sin     : inoutput_pad_config_record_t;
    pa5_cs_n    : inoutput_pad_config_record_t;
    pa6_sck     : inoutput_pad_config_record_t;
    pa7_sout    : inoutput_pad_config_record_t;
    pg0         : inoutput_pad_config_record_t;
    pg1         : inoutput_pad_config_record_t;
    pg2         : inoutput_pad_config_record_t;
    pg3         : inoutput_pad_config_record_t;
    pg4         : inoutput_pad_config_record_t;
    pg5         : inoutput_pad_config_record_t;
    pg6         : inoutput_pad_config_record_t;
    pg7         : inoutput_pad_config_record_t;
    mtest       : input_pad_config_record_t;
    mwake       : input_pad_config_record_t;
    mrxout      : output_pad_config_record_t;
  end record pad_config_record_t;
end package data_types_pack;
