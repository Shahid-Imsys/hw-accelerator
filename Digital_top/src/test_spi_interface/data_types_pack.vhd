library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.all;

package data_types_pack is

  type output_pad_config_record_t is record
    ds  : mclkout_ds_t;
    sr  : std_logic;
    co  : std_logic;
    odp : std_logic;
    odn : std_logic;
  end record output_pad_config_record_t;

  type input_pad_config_record_t is record
    ste : msdin_ste_t;
    pd  : std_logic;
    pu  : std_logic;
  end record input_pad_config_record_t;

  type inoutput_pad_config_record_t is record
    ds  : emem_d0_out_ds_t; -- Using d0 for d0..7 
    sr  : std_logic;
    co  : std_logic;
    odp : std_logic;
    odn : std_logic;
    ste : emem_d0_in_ste_t; -- Using d0 for d0..7 
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
    emem_cs_n   : output_pad_config_record_t;
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
	
    io_dack0_n  : input_pad_config_record_t;	
    io_dreq0_n  : output_pad_config_record_t;	
    io_dack1_n  : input_pad_config_record_t;	
    io_dreq1_n  : output_pad_config_record_t;
    io_dack2_n  : input_pad_config_record_t;	
    io_dreq2_n  : output_pad_config_record_t;
    io_dack3_n  : input_pad_config_record_t;	
    io_dreq3_n  : output_pad_config_record_t;	
    
    io_d0       : inoutput_pad_config_record_t;
    io_d1       : inoutput_pad_config_record_t;
    io_d2       : inoutput_pad_config_record_t;
    io_d3       : inoutput_pad_config_record_t;
	io_d4       : inoutput_pad_config_record_t;
    io_d5       : inoutput_pad_config_record_t;	
    io_d6       : inoutput_pad_config_record_t;	
    io_d7       : inoutput_pad_config_record_t;	
    
    io_ldout_n  : output_pad_config_record_t;	
    io_next_n   : output_pad_config_record_t;	
    io_clk	    : output_pad_config_record_t;  
    io_ioa_n    : output_pad_config_record_t;
	
  end record pad_config_record_t;

  type pll_registers_record_t is record
    main_div_n1      : pll_1_main_div_n1_t;
    main_div_n2      : pll_1_main_div_n2_t;
    main_div_n3      : pll_1_main_div_n3_t;
    main_div_n4      : pll_1_main_div_n4_t;
    open_loop        : pll_2_open_loop_t;
    out_div_sel      : pll_2_out_div_sel_t;
    ci               : pll_2_ci_t;
    cp               : pll_cp_cp_t;
    ft               : pll_ft_ft_t;
    divcore_sel      : pll_3_divcore_sel_t;
    coarse           : pll_3_coarse_t;
    auto_coarsetune  : pll_4_auto_coarsetune_t;
    enforce_lock     : pll_4_enforce_lock_t;
    pfd_select       : pll_4_pfd_select_t;
    lock_window_sel  : pll_4_lock_window_sel_t;
    div_core_mux_sel : pll_4_div_core_mux_sel_t;
    filter_shift     : pll_4_filter_shift_t;
    en_fast_lock     : pll_4_en_fast_lock_t;
    sar_limit        : pll_5_sar_limit_t;
    set_op_lock      : pll_5_set_op_lock_t;
    disable_lock     : pll_5_disable_lock_t;
    ref_bypass       : pll_5_ref_bypass_t;
    ct_compensation  : pll_5_ct_compensation_t;
  end record pll_registers_record_t;

  type adpll_registers_record_t is record
    adpll_status_0 : adpll_status0_adpll_status_0_t;
    adpll_status_1 : adpll_status1_adpll_status_1_t;
    adpll_status_2 : adpll_status2_adpll_status_2_t;
  end record adpll_registers_record_t;

end package data_types_pack;