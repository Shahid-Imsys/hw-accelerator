-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : Top level
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : digital_core
-- Author     : Bengt Svantesson
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Core level block that instantiates the IM4000, Accelerator and
-- glue logic..
--              
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.pad_instance_package.all;
use work.data_types_pack.all;

use work.gp_pkg.all;

entity digital_chip is

  generic (
    g_memory_type     : memory_type_t := asic;
    g_simulation      : boolean       := false;
	ADPLL_STATUS_BITS : integer       := 21
    );
  port (
    -- PLL reference clock
    pll_ref_clk : inout  std_logic;
    -- reset pins
    spi_rst_n   : inout std_logic;  -- reset for spi-block.
    preset_n    : inout std_logic;  -- Power on reset
    mreset_n    : inout std_logic;  -- Functional reset
    mrstout_n   : inout std_logic;  -- reset output for external components
                                    -- also used for enet_rst_n pad to make digital_chip similar to fpga_top
    -- Ethernet Interface
    -- enet_rst_n : out std_logic;          -- connected with mrstout_n 

    enet_mdc   : out   std_logic;
    enet_mdio  : inout std_logic;
--    enet_txclk : inout std_logic;           -- Use RXCLK?
    enet_txen  : out   std_logic;           -- RMII TX_EN to TX_CTL -- enet_txctl in fpga
    enet_txd0  : out   std_logic;
    enet_txd1  : out   std_logic;
    --enet_txd2  : out   std_logic;         -- RMII Not used ( TODO GND or floating? )
    enet_txer  : out   std_logic;           -- RMII TX_ER to TXD3, enet_txd3 in fpga
    enet_clk : inout std_logic;             -- in fpga enet_rxclk
    enet_rxdv  : inout std_logic;            -- RMII DV to RX_CTL, enet_rxctl in fpga
    enet_rxd0  : inout std_logic;
    enet_rxd1  : inout std_logic;
    --enet_rxd2  : inout std_logic;         -- RMII Not used
    enet_rxer  : inout std_logic;           -- RMII RX_ER to RXD3
	
	
    -- Octal_spi
    emem_clk   : out   std_logic;
    emem_rst_n : out   std_logic;
    emem_cs_n  : out   std_logic;
    emem_rwds  : inout std_logic;
    emem_d0    : inout std_logic;
    emem_d1    : inout std_logic;
    emem_d2    : inout std_logic;
    emem_d3    : inout std_logic;
    emem_d4    : inout std_logic;
    emem_d5    : inout std_logic;
    emem_d6    : inout std_logic;
    emem_d7    : inout std_logic;
	
	--IO Interface, left open
	io_dack0_n    : inout std_logic;	
    io_dreq0_n    : out std_logic;	
    io_dack1_n    : inout std_logic;	
    io_dreq1_n    : out std_logic;
    io_dack2_n    : inout std_logic;	
    io_dreq2_n    : out std_logic;	
    io_dack3_n    : inout std_logic;	
    io_dreq3_n    : out std_logic;		
    
    io_d0    : inout std_logic;
    io_d1    : inout std_logic;
    io_d2    : inout std_logic;
    io_d3    : inout std_logic;
	io_d4    : inout std_logic;
    io_d5    : inout std_logic;	
    io_d6    : inout std_logic;	
    io_d7    : inout std_logic;	
    
    io_ldout_n    : out std_logic;	
    io_next_n     : out std_logic;	
    io_clk	      : out std_logic;  
    io_ioa_n	  : out std_logic;  
    
    
    
    -- SPI, chip control interface
    spi_sclk : inout std_logic;
    spi_cs_n : inout std_logic;
    spi_mosi : inout std_logic;
    spi_miso : inout std_logic;

    -- IM400 DEBUG interface
    mclkout : inout std_logic;
    msdin   : inout  std_logic;
    msdout  : inout std_logic;
    mirqout : inout std_logic;

    -- IM4000 Boot interface
    pa0_sin : inout std_logic;
    pa5_cs_n : inout std_logic;
    pa6_sck : inout std_logic;
    pa7_sout : inout std_logic;

    -- DAC pins
    aout0 : inout std_logic;
    aout1 : inout std_logic;
    
    -- ADC pin
    ach0  : inout  std_logic;

    -- UART
    utx : inout std_logic;
    urx : inout  std_logic;

    -- Msic. ports
    pg0 : inout std_logic;
    pg1 : inout std_logic;
    pg2 : inout std_logic;
    pg3 : inout std_logic;
    pg4 : inout std_logic;
    pg5 : inout std_logic;
    pg6 : inout std_logic;
    pg7 : inout std_logic;
    

    mtest  : inout std_logic;  -- port for testmode
    mwake  : inout std_logic;  -- Wake up signal, from what???
    mrxout : inout std_logic;  -- RTC test signal/power supply wake up

    -- interrupts
    mirq0_n : inout std_logic;
    mirq1_n : inout std_logic
    );

end entity digital_chip;

architecture rtl of digital_chip is

  component RIIO_EG1D80V_GPIO_LVT28_V
    port (
      -- PAD
      PAD_B : inout std_logic;
      --GPIO
      DO_I  : in    std_logic;
      DS_I  : in    std_logic_vector(3 downto 0);
      SR_I  : in    std_logic;
      CO_I  : in    std_logic;
      OE_I  : in    std_logic;
      ODP_I : in    std_logic;
      ODN_I : in    std_logic;
      IE_I  : in    std_logic;
      STE_I : in    std_logic_vector(1 downto 0);
      PD_I  : in    std_logic;
      PU_I  : in    std_logic;
      DI_O  : out   std_logic;

      VBIAS : inout std_logic
      );
  end component;

  component output_pad
    port (
      -- PAD
      pad : inout std_logic;

      --GPO
      do  : in std_logic;
      ds  : in std_logic;
      sr  : in std_logic;
      co  : in std_logic;
      oe  : in std_logic;
      odp : in std_logic;
      odn : in std_logic
      );
  end component;

  component input_pad
    generic (
      direction : direction_t);
    port (
      pad : in  std_logic;
      ie  : in  std_logic;
      ste : in  std_logic_vector(1 downto 0);
      pd  : in  std_logic;
      pu  : in  std_logic;
      di  : out std_logic
      );
  end component;

  component ri_adpll_gf22fdx_2gmp
    port (
      ref_clk_i              : in  std_logic;
      scan_clk_i             : in  std_logic;  --scan clock input
      reset_q_i              : in  std_logic;  --asynchronous reset
      en_adpll_ctrl_i        : in  std_logic;  --enable controller
      clk_core_o             : out std_logic;  --low speed core clock output
      pll_locked_o           : out std_logic;  --lock signal
      c_ci_i                 : in  std_logic_vector(4 downto 0);  -- integral filter coefficient (alpha)
      c_cp_i                 : in  std_logic_vector(7 downto 0);  -- proportional filter coefficient (beta)
      c_main_div_n1_i        : in  std_logic;  -- main loop divider N1
      c_main_div_n2_i        : in  std_logic_vector(1 downto 0);  -- main loop divider N2
      c_main_div_n3_i        : in  std_logic_vector(1 downto 0);  -- main loop divider N3
      c_main_div_n4_i        : in  std_logic_vector(1 downto 0);  -- main loop divider N4
      c_out_div_sel_i        : in  std_logic_vector(1 downto 0);  -- output divider select signal
      c_open_loop_i          : in  std_logic;  -- PLL starts without loop regulation
      c_ft_i                 : in  std_logic_vector(7 downto 0);  -- fine tune signal for open loop
      c_divcore_sel_i        : in  std_logic_vector(1 downto 0);  -- divcore in Custom macro
      c_coarse_i             : in  std_logic_vector(5 downto 0);  -- Coarse Tune Value for open loop and Fast Fine Tune
      c_bist_mode_i          : in  std_logic;  -- BIST mode 1:BIST; 0: normal PLL usage
      c_auto_coarsetune_i    : in  std_logic;  -- automatic Coarse tune search
      c_enforce_lock_i       : in  std_logic;  -- overwrites lock bit
      c_pfd_select_i         : in  std_logic;  -- enables synchronizer for PFD
      c_lock_window_sel_i    : in  std_logic;  -- lock detection window: 1:short, 0:long
      c_div_core_mux_sel_i   : in  std_logic;  -- selects divider chain: 0: COREDIV, 1: OUTDIV + COREDIV
      c_filter_shift_i       : in  std_logic_vector(1 downto 0);  -- shift for CP/CI for fast lockin
      c_en_fast_lock_i       : in  std_logic;  -- enables fast fine tune lockin
      c_sar_limit_i          : in  std_logic_vector(2 downto 0);  -- limit for binary search in fast fine tune
      c_set_op_lock_i        : in  std_logic;  -- force lock bit to 1 in OP mode
      c_disable_lock_i       : in  std_logic;  -- force lock bit to 0
      c_ref_bypass_i         : in  std_logic;  --bypass reference clock to core clock output
      c_ct_compensation_i    : in  std_logic;  --in case of finetune underflow/overflow coarsetune will be increased/decreased
      adpll_status_o         : out std_logic_vector(21-1 downto 0);  --ADPLL status
      adpll_status_ack_o     : out std_logic;
      adpll_status_capture_i : in  std_logic;  --capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
      scan_in_i              : in  std_logic_vector(2 downto 0);
      scan_out_o             : out std_logic_vector(2 downto 0);
      scan_enable_i          : in  std_logic;
      testmode_i             : in  std_logic;
      dco_clk_o              : out std_logic_vector(7 downto 0);
      clk_tx_o               : out std_logic_vector(1 downto 0);
      pfd_o                  : out std_logic;
      bist_busy_o            : out std_logic;  --1:BIST is still running; 0:BIST finished
      bist_fail_coarse_o     : out std_logic;  --1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
      bist_fail_fine_o       : out std_logic  --
     --1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
      );
  end component ri_adpll_gf22fdx_2gmp;

  signal pll_locked : std_logic;
  signal dco_clk    : std_logic_vector(7 downto 0);

  signal pll_ref_clk_in : std_logic;

  signal pre_spi_rst_n : std_logic;
  signal mreset : std_logic;
  signal mrstout : std_logic;

  signal mckout0, mckout1  : std_logic;
  signal msdin_in : std_logic;
  signal msdout_out : std_logic;
  signal mirqout_out : std_logic;

  signal mirq0, mirq1 : std_logic;

  signal vbias : std_logic;

    -- Ports
  signal pa_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pb_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pc_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pd_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pe_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pf_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pg_i : std_logic_vector(7 downto 0) := (others => '0');
  signal ph_i : std_logic_vector(7 downto 0) := (others => '0');
--  signal pi_i : std_logic_vector(7 downto 0) := (others => '0');
  signal pj_i : std_logic_vector(7 downto 0) := (others => '0');

  signal pa_o : std_logic_vector(7 downto 0);
  signal pb_o : std_logic_vector(7 downto 0);
  signal pc_o : std_logic_vector(7 downto 0);
  signal pd_o : std_logic_vector(7 downto 0);
  signal pe_o : std_logic_vector(7 downto 0);
  signal pf_o : std_logic_vector(7 downto 0);
  signal pg_o : std_logic_vector(7 downto 0);
  signal ph_o : std_logic_vector(7 downto 0);
 -- signal pi_o : std_logic_vector(7 downto 0);
  signal pj_o : std_logic_vector(7 downto 0);

  signal pa_en : std_logic_vector(7 downto 0);
  signal pb_en : std_logic_vector(7 downto 0);
  signal pc_en : std_logic_vector(7 downto 0);
  signal pd_en : std_logic_vector(7 downto 0);
  signal pe_en : std_logic_vector(7 downto 0);
  signal pf_en : std_logic_vector(7 downto 0);
  signal pg_en : std_logic_vector(7 downto 0);
  signal ph_en : std_logic_vector(7 downto 0);
--  signal pi_en : std_logic_vector(7 downto 0);
  signal pj_en : std_logic_vector(7 downto 0);  
  
  signal mtest_in : std_logic;
  signal mwake_in : std_logic;
  signal mrxout_in : std_logic;

  signal d_lo : std_logic;
  signal p1_hi : std_logic;
  signal p1_sr : std_logic;
  signal p2_hi : std_logic;
  signal p2_sr : std_logic;
  signal p3_hi : std_logic;
  signal p3_sr : std_logic;

  signal ospi_cs_n        : std_logic;
  signal ospi_ck_n        : std_logic;
  signal ospi_ck_p        : std_logic;
  signal ospi_reset_n     : std_logic;
  signal ospi_dq_in       : std_logic_vector(7 downto 0);
  signal ospi_dq_out      : std_logic_vector(7 downto 0);
  signal ospi_dq_enable   : std_logic;
  signal ospi_rwds_in     : std_logic;
  signal ospi_rwds_out    : std_logic;
  signal ospi_rwds_enable : std_logic;
 
	--IO Interface, left open
/*
  signal io_dack0_n_in     : std_logic;	
  signal io_dreq0_n_out    : std_logic;	
  signal io_dack1_n_in     : std_logic;	
  signal io_dreq1_n_out    : std_logic;	
  signal io_dack2_n_in     : std_logic;	
  signal io_dreq2_n_out    : std_logic;	
  signal io_dack3_n_in     : std_logic;	
  signal io_dreq3_n_out    : std_logic;	
       
  signal io_d0_inout       : std_logic;
  signal io_d1_inout       : std_logic;
  signal io_d2_inout       : std_logic;
  signal io_d3_inout       : std_logic;
  signal io_d4_inout       : std_logic;
  signal io_d5_inout       : std_logic;	
  signal io_d6_inout       : std_logic;	
  signal io_d7_inout       : std_logic;	
  
  signal io_ldout_n_out    : std_logic;	
  signal io_next_n_out     : std_logic;	
  signal io_clk_out	       : std_logic;  

  signal io_ioa_n_out	   : std_logic; */  
           
  
--  signal enet_rst_n_out     : std_logic;
   
  signal enet_mdc_out       : std_logic;
  signal enet_mdio_in    : std_logic;
  signal enet_mdio_out    : std_logic;
  
   
--  signal enet_txclk_in      : std_logic;      -- Use RXCLK?
  signal enet_txen_out      : std_logic;      -- RMII TX_EN to TX_CTL -- enet_txctl in fpga
  signal enet_txd0_out      : std_logic;
  signal enet_txd1_out      : std_logic;
  --signal enet_txd2_out    : std_logic;      -- RMII Not used ( TODO GND or floating? )
  signal enet_txer_out      : std_logic;      -- RMII TX_ER to TXD3, enet_txd3 in fpga
				            
  signal enet_rxclk_in      : std_logic;        -- in fpga_top enet_rxclk
  signal enet_rxdv_in       : std_logic;      -- RMII DV to RX_CTL, enet_rxctl in fpga
  signal enet_rxd0_in       : std_logic;
  signal enet_rxd1_in       : std_logic;
  --signal enet_rxd2_in       : std_logic;    -- RMII Not used
  signal enet_rxer_in       : std_logic;      -- RMII RX_ER to RXD3
    
					        
  signal spi_sclk_in        : std_logic;
  signal spi_cs_n_in        : std_logic;
  signal spi_mosi_in        : std_logic;
  signal spi_miso_out       : std_logic;
  signal spi_miso_oe        : std_logic;
  signal spi_miso_oe_n      : std_logic;
  signal pad_config         : pad_config_record_t;
  signal pll_config         : pll_registers_record_t;
  signal adpll_config       : adpll_registers_record_t;

  signal dac0_bits : std_logic;
  signal dac1_bits : std_logic;

  signal adc_bits : std_logic;

  signal pwr_ok : std_logic;
  


begin  -- architecture rtl

  -- Ethernet
  --  enet_rst_n_out <= mrstout;              -- mrstout is going to pad mrstout_n

  enet_mdc_out   <= pb_o(2);
  enet_mdio_out  <= pb_o(1);
  pb_i(1)        <= enet_mdio_in;
  --
  -- pf_i(1)        <= enet_txclk_in;            -- Use RXCLK?
  enet_txen_out   <= pf_o(0);                   -- RMII TX_EN to TX_CTL -- enet_txctl in fpga
  enet_txd0_out  <= pf_o(2);                
  enet_txd1_out  <= pf_o(3);                
  -- enet_txd2_out  <= '0';                    -- RMII Not used ( TODO GND or floating? )
  enet_txer_out  <= pg_o(0);                  -- RMII TX_ER to TXD3, enet_txd3 in fpga
									        
  pg_i(1) <= enet_rxclk_in;                   -- enet_clk at port
  pf_i(4) <= enet_rxdv_in;                    -- RMII DV to RX_CTL, enet_rxctl in fpga
  pf_i(6) <= enet_rxd0_in;                     
  pf_i(7) <= enet_rxd1_in;                     
  --pg_i(6) <= enet_rxd2;                     -- RMII Not used
  pf_i(5) <= enet_rxer_in;                    -- RMII RX_ER to RXD3
  
  

  i_pll : ri_adpll_gf22fdx_2gmp
    port map (
      ref_clk_i                        => pll_ref_clk_in,
      scan_clk_i                       => '0',
      reset_q_i                        => pwr_ok,  --asynchronous reset
      en_adpll_ctrl_i                  => '1',  --enable controller
      clk_core_o                       => open,  --low speed core clock output
      pll_locked_o                     => pll_locked,  --lock signal
      c_ci_i                           => pll_config.ci,  -- integral filter coefficient (alpha)
      c_cp_i                           => pll_config.cp,  -- proportional filter coefficient (beta)
      c_main_div_n1_i                  => pll_config.main_div_n1,  -- main loop divider N1 = 1
      c_main_div_n2_i                  => pll_config.main_div_n2,  -- main loop divider N2 = 5
      c_main_div_n3_i                  => pll_config.main_div_n3,  -- main loop divider N3 = 2
      c_main_div_n4_i                  => pll_config.main_div_n4,  -- main loop divider N4 = 2
      c_out_div_sel_i                  => pll_config.out_div_sel,  -- output divider select signal
      c_open_loop_i                    => pll_config.open_loop,  -- PLL starts without loop regulation
      c_ft_i                           => pll_config.ft,  -- fine tune signal for open loop
      c_divcore_sel_i                  => pll_config.divcore_sel,  -- divcore in Custom macro = 1
      c_coarse_i                       => pll_config.coarse,  -- Coarse Tune Value for open loop and Fast Fine Tune
      c_bist_mode_i                    => '0',  -- BIST mode 1:BIST; 0: normal PLL usage
      c_auto_coarsetune_i              => pll_config.auto_coarsetune,  -- automatic Coarse tune search
      c_enforce_lock_i                 => pll_config.enforce_lock,  -- overwrites lock bit
      c_pfd_select_i                   => pll_config.pfd_select,  -- enables synchronizer for PFD
      c_lock_window_sel_i              => pll_config.lock_window_sel,  -- lock detection window: 1:short, 0:long
      c_div_core_mux_sel_i             => pll_config.div_core_mux_sel,  -- selects divider chain: 0: COREDIV, 1: OUTDIV + COREDIV
      c_filter_shift_i                 => pll_config.filter_shift,  -- shift for CP/CI for fast lockin
      c_en_fast_lock_i                 => pll_config.en_fast_lock,  -- enables fast fine tune lockin
      c_sar_limit_i                    => pll_config.sar_limit,  -- limit for binary search in fast fine tune
      c_set_op_lock_i                  => pll_config.set_op_lock,  -- force lock bit to 1 in OP mode
      c_disable_lock_i                 => pll_config.disable_lock,  -- force lock bit to 0
      c_ref_bypass_i                   => pll_config.ref_bypass,  --bypass reference clock to core clock output
      c_ct_compensation_i              => pll_config.ct_compensation,  --in case of finetune underflow/overflow coarsetune will be increased/decreased
      --adpll_status_o                   => open,  --ADPLL status
      adpll_status_o(7 downto 0)       => adpll_config.adpll_status_0,  --ADPLL status
      adpll_status_o(15 downto 8)      => adpll_config.adpll_status_1,
      adpll_status_o(20 downto 16)     => adpll_config.adpll_status_2,
      adpll_status_ack_o               => open,
      adpll_status_capture_i           => '0',  --capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
      scan_in_i                        => "000",
      scan_out_o                       => open,
      scan_enable_i                    => '0',
      testmode_i                       => mtest_in,
      dco_clk_o                        => dco_clk,
      clk_tx_o                         => open,
      pfd_o                            => open,
      bist_busy_o                      => open,  --1:BIST is still running; 0:BIST finished
      bist_fail_coarse_o               => open,  --1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
      bist_fail_fine_o                 => open  --1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
      );

  i_digital_top : entity work.digital_top 
    generic map
      (
        g_memory_type     => g_memory_type,
        g_clock_frequency => 31  -- system clock frequency in MHz
        )
      port map (
        hclk          => dco_clk(0),
        clk_p_acc     => dco_clk(0),
        pll_ref_clk   => pll_ref_clk_in,
        pll_locked    => pll_locked,
        pre_spi_rst_n => pre_spi_rst_n,



        MRESET        => mreset,
        MRSTOUT       => mrstout,  -- Missing pad.
        MIRQOUT       => mirqout_out,
        MCKOUT0       => mckout0,
        MCKOUT1       => MCKOUT1,
        mckout1_en    => open,
        MTEST         => mtest_in,
        MBYPASS       => '0', --MBYPASS,
        MIRQ0         => mirq0,
        MIRQ1         => mirq1,

        -- SW debug
        MSDIN         => msdin_in,
        MSDOUT        => msdout_out,

        MWAKEUP_LP    => '0',    -- MWAKE,
        MLP_PWR_OK    => mreset, -- MLP_PWR_OK,

        -- Analog internal signals
        pwr_ok     => pwr_ok,
        dis_bmem   => open,
        vdd_bmem   => '0',
        VCC18LP    => '1',
        rxout      => mrxout_in,
        ach_sel0   => open,
        ach_sel1   => open,
        ach_sel2   => open,
        adc_bits   => adc_bits,
        adc_ref2v  => open,
        adc_extref => open,
        adc_diff   => open,
        adc_en     => open,
        dac0_bits  => dac0_bits,
        dac1_bits  => dac1_bits,
        dac0_en    => open,
        dac1_en    => open,
        clk_a      => open,
              
        -- Port A
        pa_i  => pa_i,
        pa_en => pa_en,
        pa_o  => pa_o,
        -- Port B
        pb_i  => pb_i,   --x"00", --pb_i,
        pb_en => pb_en,  --open, --pb_en,
        pb_o  => pb_o,  --open, --pb_o,
        -- Port C
        pc_i  => pc_i, --x"00",--pc_i,
        pc_en => pc_en,--open, --pc_en,
        pc_o  => pc_o, --open, --pc_o,
        -- Port D
        pd_i  => pd_i, --x"00",--pd_i,
        pd_en => pd_en,--open, --pd_en,
        pd_o  => pd_o, --open, --pd_o,
        -- Port Eopen,
        pe_i  => pe_i,  --x"00",--pe_i,
        pe_en => pe_en, --open, --pe_en,
        pe_o  => pe_o,  --open, --pe_o,
        -- Port F
        pf_i  => pf_i,  --x"00",-- pf_i,
        pf_en => pf_en, --open, -- pf_en,
        pf_o  => pf_o,  --open, -- pf_o,
        -- Port G
        pg_i  => pg_i,
        pg_en => pg_en,
        pg_o  => pg_o,
        -- Port H
        ph_i  => ph_i,  --x"00",--ph_i,
        ph_en => ph_en, --open, --ph_en,
        ph_o  => ph_o,  -- open, --ph_o,
        -- Port I
        -- pi_i  => x"00", --pi_i,
        -- pi_en => open, --pi_en,
        -- pi_o  => open, --pi_o,
        -- Port J
        pj_i  => pj_i,
        pj_en => pj_en,
        pj_o  => pj_o,
        -- I/O cell configuration control outputs
        -- d_hi  => open,
        -- d_sr  => open,
        d_lo  => d_lo,
        p1_hi => p1_hi,
        p1_sr => p1_sr,
        p2_hi => p2_hi,
        p2_sr => p2_sr,
        p3_hi => p3_hi,
        p3_sr => p3_sr,

        ospi_cs_n  => ospi_cs_n,
        ospi_ck_n  => ospi_ck_n,
        ospi_ck_p  => ospi_ck_p,
        ospi_reset_n  => ospi_reset_n,
        ospi_dq_in  => ospi_dq_in,
        ospi_dq_out  => ospi_dq_out,
        ospi_dq_enable  => ospi_dq_enable,
        ospi_rwds_in => ospi_rwds_in,
        ospi_rwds_out => ospi_rwds_out,
        ospi_rwds_enable => ospi_rwds_enable,
        
        -- enet_mdin  => enet_mdin,
        -- enet_mdout => enet_mdout,
        -- enet_mdc   => enet_mdc_out,
        -- enet_clk   => enet_clk_in,
        -- enet_txen  => enet_txen_out,
        -- enet_txer  => enet_txer_out,
        -- enet_txd0  => enet_txd0_out,
        -- enet_txd1  => enet_txd1_out,
        -- enet_rxdv  => enet_rxdv_in,
        -- enet_rxer  => enet_rxer_in,
        -- enet_rxd0  => enet_rxd0_in,
        -- enet_rxd1  => enet_rxd1_in,
        
        spi_sclk      => spi_sclk_in,
        spi_cs_n      => spi_cs_n_in,
        spi_mosi      => spi_mosi_in,
        spi_miso      => spi_miso_out,
        spi_miso_oe_n => spi_miso_oe_n,
        pad_config    => pad_config,
        pll_config    => pll_config,
        adpll_config  => adpll_config
      );

    ---------------------------------------------------------------------------
    -- West side pads
    ---------------------------------------------------------------------------
    
    i_mclkout_pad : entity work.output_pad   
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => mclkout,
        --GPIO
        do  => mckout0,
        ds  => pad_config.mclkout.ds & "00",
        sr  => pad_config.mclkout.sr,
        co  => pad_config.mclkout.co,
        oe  => '1',
        odp => pad_config.mclkout.odp,
        odn => pad_config.mclkout.odn
        );

    i_msdin : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => msdin,
        --GPI
        ie  => '1',
        ste => pad_config.msdin.ste,
        pd  => pad_config.msdin.pd,
        pu  => pad_config.msdin.pu,
        di  => msdin_in
        );

    i_msdout_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => msdout,
        --GPIO
        do  => msdout_out,
        ds  => pad_config.msdout.ds & "00",
        sr  => pad_config.msdout.sr,
        co  => pad_config.msdout.co,
        oe  => '1',
        odp => pad_config.msdout.odp,
        odn => pad_config.msdout.odn
        );

    i_mirqout_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => mirqout,
        --GPIO
        do  => mirqout_out,
        ds  => pad_config.mirqout.ds & "00",
        sr  => pad_config.mirqout.sr,
        co  => pad_config.mirqout.co,
        oe  => '1',
        odp => pad_config.mirqout.odp,
        odn => pad_config.mirqout.odn
        );
    
    i_mirq0_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => mirq0_n,
        --GPI
        ie  => '1',
        ste => pad_config.mirq0.ste,
        pd  => pad_config.mirq0.pd,
        pu  => pad_config.mirq0.pd,
        di  => mirq0
        );
    
    i_mirq1_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => mirq1_n,
        --GPI
        ie  => '1',
        ste => pad_config.mirq1.ste,
        pd  => pad_config.mirq1.pd,
        pu  => pad_config.mirq1.pd,
        di  => mirq1
        );


  pj_i(0) <= pj_o(0);
  pj_i(7 downto 2) <= pj_o(7 downto 2);
  
    i_utx_pad : entity work.output_pad
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => utx,
        --GPIO
        do  => pj_o(0),
        ds  => pad_config.utx.ds & "00",
        sr  => pad_config.utx.sr,
        co  => pad_config.utx.co,
        oe  => pj_en(0),
        odp => pad_config.utx.odp,
        odn => pad_config.utx.odn
        );

    i_urx_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => urx,
        --GPI
        ie  => not pj_en(1),
        ste => pad_config.urx.ste,
        pd  => pad_config.urx.pd,
        pu  => pad_config.urx.pu,
        di  => pj_i(1)
        );

    i_emem_d0_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d0,
        -- GPIO
        do  => ospi_dq_out(0),
        ds  => pad_config.emem_d0.ds & "00",
        sr  => pad_config.emem_d0.sr,
        co  => pad_config.emem_d0.sr,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d0.odp,
        odn => pad_config.emem_d0.odn,
        ste => pad_config.emem_d0.ste,
        pd  => pad_config.emem_d0.pd,
        pu  => pad_config.emem_d0.pu,
        di  => ospi_dq_in(0)
        );

    i_emem_d1_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d1,
        -- GPIO
        do  => ospi_dq_out(1),
        ds  => pad_config.emem_d1.ds & "00",
        sr  => pad_config.emem_d1.sr,
        co  => pad_config.emem_d1.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d1.odp,
        odn => pad_config.emem_d1.odn,
        ste => pad_config.emem_d1.ste,
        pd  => pad_config.emem_d1.pd,
        pu  => pad_config.emem_d1.pu,
        di  => ospi_dq_in(1)
        );

    i_emem_d2_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d2,
        -- GPIO
        do  => ospi_dq_out(2),
        ds  => pad_config.emem_d2.ds & "00",
        sr  => pad_config.emem_d2.sr,
        co  => pad_config.emem_d2.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d2.odp,
        odn => pad_config.emem_d2.odn,
        ste => pad_config.emem_d2.ste,
        pd  => pad_config.emem_d2.pd,
        pu  => pad_config.emem_d2.pu,
        di  => ospi_dq_in(2)
        );

    i_emem_d3_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d3,
        -- GPIO
        do  => ospi_dq_out(3),
        ds  => pad_config.emem_d3.ds & "00",
        sr  => pad_config.emem_d3.sr,
        co  => pad_config.emem_d3.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d3.odp,
        odn => pad_config.emem_d3.odn,
        ste => pad_config.emem_d3.ste,
        pd  => pad_config.emem_d3.pd,
        pu  => pad_config.emem_d3.pu,
        di  => ospi_dq_in(3)
        );

    i_emem_d4_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d4,
        -- GPIO
        do  => ospi_dq_out(4),
        ds  => pad_config.emem_d4.ds & "00",
        sr  => pad_config.emem_d4.sr,
        co  => pad_config.emem_d4.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d4.odp,
        odn => pad_config.emem_d4.odn,
        ste => pad_config.emem_d4.ste,
        pd  => pad_config.emem_d4.pd,
        pu  => pad_config.emem_d4.pu,
        di  => ospi_dq_in(4)
        );

    i_emem_d5_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d5,
        -- GPIO
        do  => ospi_dq_out(5),
        ds  => pad_config.emem_d5.ds & "00",
        sr  => pad_config.emem_d5.sr,
        co  => pad_config.emem_d5.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d5.odp,
        odn => pad_config.emem_d5.odn,
        ste => pad_config.emem_d5.ste,
        pd  => pad_config.emem_d5.pd,
        pu  => pad_config.emem_d5.pu,
        di  => ospi_dq_in(5)
        );

    i_emem_d6_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d6,
        -- GPIO
        do  => ospi_dq_out(6),
        ds  => pad_config.emem_d6.ds & "00",
        sr  => pad_config.emem_d6.sr,
        co  => pad_config.emem_d6.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d6.odp,
        odn => pad_config.emem_d6.odn,
        ste => pad_config.emem_d6.ste,
        pd  => pad_config.emem_d6.pd,
        pu  => pad_config.emem_d6.pu,
        di  => ospi_dq_in(6)
        );

    i_emem_d7_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_d7,
        -- GPIO
        do  => ospi_dq_out(7),
        ds  => pad_config.emem_d7.ds & "00",
        sr  => pad_config.emem_d7.sr,
        co  => pad_config.emem_d7.co,
        oe  => ospi_dq_enable, 
        odp => pad_config.emem_d7.odp,
        odn => pad_config.emem_d7.odn,
        ste => pad_config.emem_d7.ste,
        pd  => pad_config.emem_d7.pd,
        pu  => pad_config.emem_d7.pu,
        di  => ospi_dq_in(7)
        );

    i_emem_clk_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => emem_clk,
        --GPIO
        do  => ospi_ck_p,
        ds  => pad_config.emem_clk.ds & "00",
        sr  => pad_config.emem_clk.sr,
        co  => pad_config.emem_clk.co,
        oe  => '1',
        odp => pad_config.emem_clk.odp,
        odn => pad_config.emem_clk.odn
        );

    --i_emem_clk_n_pad : entity work.output_pad  
    --  generic map (
    --    direction =>  horizontal)
    --  port map (
    --    -- PAD
    --    pad => emem_clk,
    --    --GPIO
    --    do  => ospi_ck_n,
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => '1',
    --    odp => '0',
    --    odn => '0'
    --    );

    i_emem_rwds_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => emem_rwds,
        -- GPIO
        do  => ospi_rwds_out,
        ds  => pad_config.emem_rwds.ds & "00",
        sr  => pad_config.emem_rwds.sr,
        co  => pad_config.emem_rwds.co,
        oe  => ospi_rwds_enable, 
        odp => pad_config.emem_rwds.odp,
        odn => pad_config.emem_rwds.odn,
        ste => pad_config.emem_rwds.ste,
        pd  => pad_config.emem_rwds.pd,
        pu  => pad_config.emem_rwds.pu,
        di  => ospi_rwds_in
        );

    i_emem_cs_n_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => emem_cs_n,
        --GPIO
        do  => ospi_cs_n,
        ds  => pad_config.emem_cs_n.ds & "00",
        sr  => pad_config.emem_cs_n.sr,
        co  => pad_config.emem_cs_n.co,
        oe  => '1',
        odp => pad_config.emem_cs_n.odp,
        odn => pad_config.emem_cs_n.odn
        );

    i_emem_rst_n_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => emem_rst_n,
        --GPIO
        do  => ospi_reset_n,
        ds  => pad_config.emem_rst_n.ds & "00",
        sr  => pad_config.emem_rst_n.sr,
        co  => pad_config.emem_rst_n.co,
        oe  => '1',
        odp => pad_config.emem_rst_n.odp,
        odn => pad_config.emem_rst_n.odn
        );

    ---------------------------------------------------------------------------
    -- South side pads
    ---------------------------------------------------------------------------
 
    i_io_dack0_n_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_dack0_n,
        --GPI
        ie  => '1',
        ste => pad_config.io_dack0_n.ste,
        pd  => pad_config.io_dack0_n.pd,
        pu  => pad_config.io_dack0_n.pu,
        di  => open --io_dack0_n_in --'0'
        );	
		
    o_io_dreq0_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_dreq0_n,
        --GPIO
        do  => '1',
        ds  => pad_config.io_dreq0_n.ds & "00",
        sr  => pad_config.io_dreq0_n.sr,
        co  => pad_config.io_dreq0_n.co,
        oe  => '1',       
        odp => pad_config.io_dreq0_n.odp,
        odn => pad_config.io_dreq0_n.odn
        );
		
    i_io_dack1_n_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_dack1_n,
        --GPI
        ie  => '1',
        ste => pad_config.io_dack1_n.ste,
        pd  => pad_config.io_dack1_n.pd,
        pu  => pad_config.io_dack1_n.pu,
        di  => open 
        );	
		
    o_io_dreq1_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_dreq1_n,
        --GPIO
        do  => '1',
        ds  => pad_config.io_dreq1_n.ds & "00",
        sr  => pad_config.io_dreq1_n.sr,
        co  => pad_config.io_dreq1_n.co,
        oe  => '1',       
        odp => pad_config.io_dreq1_n.odp,
        odn => pad_config.io_dreq1_n.odn
        );		
		
    i_io_dack2_n_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_dack2_n,
        --GPI
        ie  => '1',
        ste => pad_config.io_dack2_n.ste,
        pd  => pad_config.io_dack2_n.pd,
        pu  => pad_config.io_dack2_n.pu,
        di  => open--'1'
        );	
		
    o_io_dreq2_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_dreq2_n,
        --GPIO
        do  => '1',--open,
        ds  => pad_config.io_dreq2_n.ds & "00",
        sr  => pad_config.io_dreq2_n.sr,
        co  => pad_config.io_dreq2_n.co,
        oe  => '1',       
        odp => pad_config.io_dreq2_n.odp,
        odn => pad_config.io_dreq2_n.odn
        );	

    i_io_dack3_n_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_dack3_n,
        --GPI
        ie  => '1',
        ste => pad_config.io_dack3_n.ste,
        pd  => pad_config.io_dack3_n.pd,
        pu  => pad_config.io_dack3_n.pu,
        di  => open
        );	
		
    o_io_dreq3_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_dreq3_n,
        --GPIO
        do  => '1',
        ds  => pad_config.io_dreq3_n.ds & "00",
        sr  => pad_config.io_dreq3_n.sr,
        co  => pad_config.io_dreq3_n.co,
        oe  => '1',       
        odp => pad_config.io_dreq3_n.odp,
        odn => pad_config.io_dreq3_n.odn
        );		
		
    io_io_d0_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d0,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d0.ds & "00",
        sr  => pad_config.io_d0.sr,
        co  => pad_config.io_d0.co,
        oe  => '1',          
        odp => pad_config.io_d0.odp,
        odn => pad_config.io_d0.odn,
        ste => pad_config.io_d0.ste,
        pd  => pad_config.io_d0.pd,
        pu  => pad_config.io_d0.pu,
        di  => open
        );
	
    io_io_d1_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d1,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d1.ds & "00",
        sr  => pad_config.io_d1.sr,
        co  => pad_config.io_d1.co,
        oe  => '1',          
        odp => pad_config.io_d1.odp,
        odn => pad_config.io_d1.odn,
        ste => pad_config.io_d1.ste,
        pd  => pad_config.io_d1.pd,
        pu  => pad_config.io_d1.pu,
        di  => open
        );

    io_io_d2_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d2,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d2.ds & "00",
        sr  => pad_config.io_d2.sr,
        co  => pad_config.io_d2.co,
        oe  => '1',          
        odp => pad_config.io_d2.odp,
        odn => pad_config.io_d2.odn,
        ste => pad_config.io_d2.ste,
        pd  => pad_config.io_d2.pd,
        pu  => pad_config.io_d2.pu,
        di  => open
        );

    io_io_d3_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d3,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d3.ds & "00",
        sr  => pad_config.io_d3.sr,
        co  => pad_config.io_d3.co,
        oe  => '1',          
        odp => pad_config.io_d3.odp,
        odn => pad_config.io_d3.odn,
        ste => pad_config.io_d3.ste,
        pd  => pad_config.io_d3.pd,
        pu  => pad_config.io_d3.pu,
        di  => open
        );

    io_io_d4_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d4,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d4.ds & "00",
        sr  => pad_config.io_d4.sr,
        co  => pad_config.io_d4.co,
        oe  => '1',          
        odp => pad_config.io_d4.odp,
        odn => pad_config.io_d4.odn,
        ste => pad_config.io_d4.ste,
        pd  => pad_config.io_d4.pd,
        pu  => pad_config.io_d4.pu,
        di  => open
        );		

    io_io_d5_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d5,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d5.ds & "00",
        sr  => pad_config.io_d5.sr,
        co  => pad_config.io_d5.co,
        oe  => '1',          
        odp => pad_config.io_d5.odp,
        odn => pad_config.io_d5.odn,
        ste => pad_config.io_d5.ste,
        pd  => pad_config.io_d5.pd,
        pu  => pad_config.io_d5.pu,
        di  => open
        ); 
		
    io_io_d6_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d6,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d6.ds & "00",
        sr  => pad_config.io_d6.sr,
        co  => pad_config.io_d6.co,
        oe  => '1',          
        odp => pad_config.io_d6.odp,
        odn => pad_config.io_d6.odn,
        ste => pad_config.io_d6.ste,
        pd  => pad_config.io_d6.pd,
        pu  => pad_config.io_d6.pu,
        di  => open
        );		
		
    io_io_d7_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => io_d7,
        -- GPIO
        do  => '1',
        ds  => pad_config.io_d7.ds & "00",
        sr  => pad_config.io_d7.sr,
        co  => pad_config.io_d7.co,
        oe  => '1',          
        odp => pad_config.io_d7.odp,
        odn => pad_config.io_d7.odn,
        ste => pad_config.io_d7.ste,
        pd  => pad_config.io_d7.pd,
        pu  => pad_config.io_d7.pu,
        di  => open 
        );		
 
    o_io_ldout_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_ldout_n,
        --GPIO
        do  => '1',
        ds  => pad_config.io_ldout_n.ds & "00",
        sr  => pad_config.io_ldout_n.sr,
        co  => pad_config.io_ldout_n.co,
        oe  => '1',       
        odp => pad_config.io_ldout_n.odp,
        odn => pad_config.io_ldout_n.odn
        );	

    o_io_next_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_next_n,
        --GPIO
        do  => '1',
        ds  => pad_config.io_next_n.ds & "00",
        sr  => pad_config.io_next_n.sr,
        co  => pad_config.io_next_n.co,
        oe  => '1',       
        odp => pad_config.io_next_n.odp,
        odn => pad_config.io_next_n.odn
        );	

    o_io_clk_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_clk,
        --GPIO
        do  => '1',
        ds  => pad_config.io_clk.ds & "00",
        sr  => pad_config.io_clk.sr,
        co  => pad_config.io_clk.co,
        oe  => '1',       
        odp => pad_config.io_clk.odp,
        odn => pad_config.io_clk.odn
        );	

    o_io_ioa_n_pad : entity work.output_pad   
      generic map (
        direction =>  vertical)
      port map (
        -- PAD
        pad => io_ioa_n,
        --GPIO
        do  => '1',
        ds  => pad_config.io_ioa_n.ds & "00",
        sr  => pad_config.io_ioa_n.sr,
        co  => pad_config.io_ioa_n.co,
        oe  => '1',       
        odp => pad_config.io_ioa_n.odp,
        odn => pad_config.io_ioa_n.odn
        );			
    
	
    
	
    ---------------------------------------------------------------------------
    -- East side pads
    ---------------------------------------------------------------------------
    
    i_aout0_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => aout0,
        --GPIO
        do  => dac0_bits,
        ds  => pad_config.aout0.ds & "00",
        sr  => pad_config.aout0.sr,
        co  => pad_config.aout0.co,
        oe  => '1',
        odp => pad_config.aout0.odp,
        odn => pad_config.aout0.odn
        );

    i_aout1_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => aout1,
        --GPIO
        do  => dac1_bits,
        ds  => pad_config.aout1.ds & "00",
        sr  => pad_config.aout1.sr,
        co  => pad_config.aout1.co,
        oe  => '1',
        odp => pad_config.aout1.odp,
        odn => pad_config.aout1.odn
        );

    i_ach0_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => ach0,
        --GPI
        ie  => '1',
        ste => pad_config.ach0.ste,
        pd  => pad_config.ach0.pd,
        pu  => pad_config.ach0.pu,
        di  => adc_bits
        );
    
	 ---------------------------------------------------------
    --Ethernet Pad	
		
	/* o_enet_rst_n_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => enet_rst_n,
        --GPIO
        do  => enet_rst_n_out,
        ds  => pad_config.enet_rst_n.ds & "00",
        sr  => pad_config.enet_rst_n.sr,
        co  => pad_config.enet_rst_n.co,
        oe  => '1',       
        odp => pad_config.enet_rst_n.odp,
        odn => pad_config.enet_rst_n.odn
        ); */

    o_enet_mdc_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => enet_mdc,
        --GPIO
        do  => enet_mdc_out,
        ds  => pad_config.enet_mdc.ds & "00",
        sr  => pad_config.enet_mdc.sr,
        co  => pad_config.enet_mdc.co,
        oe  => pb_en(2), --'1',
        odp => pad_config.enet_mdc.odp,
        odn => pad_config.enet_mdc.odn
        );

    io_enet_mdio_pad : entity work.inoutput_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_mdio,
        -- GPIO
        do  => enet_mdio_out,
        ds  => pad_config.enet_mdio.ds & "00",
        sr  => pad_config.enet_mdio.sr,
        co  => pad_config.enet_mdio.co,
        oe  => pb_en(1),  --'1', 
        odp => pad_config.enet_mdio.odp,
        odn => pad_config.enet_mdio.odn,
        ste => pad_config.enet_mdio.ste,
        pd  => pad_config.enet_mdio.pd,
        pu  => pad_config.enet_mdio.pu,
        di  => enet_mdio_in
        );		
	
	
	/* i_enet_txclk_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_txclk,
        --GPI
        ie  => '1',
        ste => pad_config.enet_txclk.ste,
        pd  => pad_config.enet_txclk.pd,
        pu  => pad_config.enet_txclk.pu,
        di  => enet_txclk_in
        ); */
	 	
	o_enet_txen_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => enet_txen,
        --GPIO
        do  => enet_txen_out,
        ds  => pad_config.enet_txen.ds & "00",
        sr  => pad_config.enet_txen.sr,
        co  => pad_config.enet_txen.co,
        oe  => pf_en(0),
        odp => pad_config.enet_txen.odp,
        odn => pad_config.enet_txen.odn
        );
		
	
    o_enet_txd0_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => enet_txd0,
        --GPIO
        do  => enet_txd0_out,
        ds  => pad_config.enet_txd0.ds & "00",
        sr  => pad_config.enet_txd0.sr,
        co  => pad_config.enet_txd0.co,
        oe  => pf_en(2),
        odp => pad_config.enet_txd0.odp,
        odn => pad_config.enet_txd0.odn
        );

    o_enet_txd1_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => enet_txd1,
        --GPIO
        do  => enet_txd1_out,
        ds  => pad_config.enet_txd1.ds & "00",
        sr  => pad_config.enet_txd1.sr,
        co  => pad_config.enet_txd1.co,
        oe  => pf_en(3),
        odp => pad_config.enet_txd1.odp,
        odn => pad_config.enet_txd1.odn
        );

	
    i_enet_txer_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => enet_txer,
        --GPIO
        do  => enet_txer_out,
        ds  => pad_config.enet_txer.ds & "00",
        sr  => pad_config.enet_txer.sr,
        co  => pad_config.enet_txer.co,
        oe  => pg_en(0),  --'1',
        odp => pad_config.enet_txer.odp,
        odn => pad_config.enet_txer.odn
        );


    i_enet_clk_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_clk,
        --GPI
        ie  => '1',
        ste => pad_config.enet_clk.ste,
        pd  => pad_config.enet_clk.pd,
        pu  => pad_config.enet_clk.pu,
        di  => enet_rxclk_in
        );		
		
	i_enet_rxdv_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_rxdv,
        --GPI
        ie  => '1',
        ste => pad_config.enet_rxdv.ste,
        pd  => pad_config.enet_rxdv.pd,
        pu  => pad_config.enet_rxdv.pu,
        di  => enet_rxdv_in
        );
		
	i_enet_rxd0_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_rxd0,
        --GPI
        ie  => '1',
        ste => pad_config.enet_rxd0.ste,
        pd  => pad_config.enet_rxd0.pd,
        pu  => pad_config.enet_rxd0.pu,
        di  => enet_rxd0_in
        );

    i_enet_rxd1_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_rxd1,
        --GPI
        ie  => '1',
        ste => pad_config.enet_rxd1.ste,
        pd  => pad_config.enet_rxd1.pd,
        pu  => pad_config.enet_rxd1.pu,
        di  => enet_rxd1_in
        );	
		
	i_enet_rxer_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => enet_rxer,
        --GPI
        ie  => '1',
        ste => pad_config.enet_rxer.ste,
        pd  => pad_config.enet_rxer.pd,
        pu  => pad_config.enet_rxer.pu,
        di  => enet_rxer_in
        );	

		
	i_spi_reset_n_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => spi_rst_n,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pre_spi_rst_n
        );	

    i_spi_sclk_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => spi_sclk,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => spi_sclk_in
        );

    i_spi_cs_n_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => spi_cs_n,
        --GPI
        ie  => '1',
        ste => pad_config.spi_cs_n.ste,
        pd  => pad_config.spi_cs_n.pd,
        pu  => pad_config.spi_cs_n.pu,
        di  => spi_cs_n_in
        );

    i_spi_mosi_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => spi_mosi,
        --GPI
        ie  => '1',
        ste => pad_config.spi_mosi.ste,
        pd  => pad_config.spi_mosi.pd,
        pu  => pad_config.spi_mosi.pu,
        di  => spi_mosi_in
        );

    i_spi_miso_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => spi_miso,
        --GPIO
        do  => spi_miso_out,
        ds  => pad_config.spi_miso.ds & "00",
        sr  => pad_config.spi_miso.sr,
        co  => pad_config.spi_miso.co,
        oe  => spi_miso_oe,
        odp => pad_config.spi_miso.odp,
        odn => pad_config.spi_miso.odn
        );

    ---------------------------------------------------------------------------
    -- North side pads
    ---------------------------------------------------------------------------
    
    i_pll_ref_clk_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pll_ref_clk,
        --GPI
        ie  => '1',
        ste => pad_config.pll_ref_clk.ste,
        pd  => pad_config.pll_ref_clk.pd,
        pu  => pad_config.pll_ref_clk.pu,
        di  => pll_ref_clk_in
        );

    i_preset_n_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => preset_n,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pwr_ok
        );


    i_mreset_n_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => mreset_n,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => mreset
        );

     
	-- enet_rst_n pad to make digital_chip similar to fpga_top
	 i_mrst_out_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => mrstout_n,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => mrstout
        );  
		
	/* i_mrst_out_pad : entity work.output_pad  
      generic map (
        direction =>  veritical)
      port map (
        -- PAD
        pad => mrstout_n,
        --GPIO
        do  => mrstout,
        ds  => pad_config.mrstout_n.ds & "00",
        sr  => pad_config.mrstout_n.sr,
        co  => pad_config.mrstout_n.co,
        oe  => '1',
        odp => pad_config.mrstout_n.odp,
        odn => pad_config.mrstout_n.odn
        );	 */

    pa_i(4 downto 3) <= "00"; -- 00 = fcore / 2 (DataBook STO-DEV7026 R1.2 p.23)
    pa_i(2 downto 1) <= "01"; -- 01 =           (DataBook STO-DEV7026 R1.2 section 3.3.1)
  
    i_pa0_sin_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa0_sin,
        -- GPIO
        do  => pa_o(0),
        ds  => pad_config.pa0_sin.ds & "00",
        sr  => pad_config.pa0_sin.sr,
        co  => pad_config.pa0_sin.co,
        oe  => pa_en(0), 
        odp => pad_config.pa0_sin.odp,
        odn => pad_config.pa0_sin.odn,
        ste => pad_config.pa0_sin.ste,
        pd  => pad_config.pa0_sin.pd,
        pu  => pad_config.pa0_sin.pu,
        di  => pa_i(0)
        );

    i_pa5_cs_n_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa5_cs_n,
        -- GPIO
        do  => pa_o(5),
        ds  => pad_config.pa5_cs_n.ds & "00",
        sr  => pad_config.pa5_cs_n.sr,
        co  => pad_config.pa5_cs_n.co,
        oe  => pa_en(5), 
        odp => pad_config.pa5_cs_n.odp,
        odn => pad_config.pa5_cs_n.odn,
        ste => pad_config.pa5_cs_n.ste,
        pd  => pad_config.pa5_cs_n.pd,
        pu  => pad_config.pa5_cs_n.pu,
        di  => pa_i(5)
        );

    i_pa6_sck_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa6_sck,
        -- GPIO
        do  => pa_o(6),
        ds  => pad_config.pa6_sck.ds & "00",
        sr  => pad_config.pa6_sck.sr,
        co  => pad_config.pa6_sck.co,
        oe  => pa_en(6), 
        odp => pad_config.pa6_sck.odp,
        odn => pad_config.pa6_sck.odn,
        ste => pad_config.pa6_sck.ste,
        pd  => pad_config.pa6_sck.pd,
        pu  => pad_config.pa6_sck.pu,
        di  => pa_i(6)
        );

    i_pa7_sout_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa7_sout,
        -- GPIO
        do  => pa_o(7),
        ds  => pad_config.pa7_sout.ds & "00",
        sr  => pad_config.pa7_sout.sr,
        co  => pad_config.pa7_sout.co,
        oe  => pa_en(7), 
        odp => pad_config.pa7_sout.odp,
        odn => pad_config.pa7_sout.odn,
        ste => pad_config.pa7_sout.ste,
        pd  => pad_config.pa7_sout.pd,
        pu  => pad_config.pa7_sout.pu,
        di  => pa_i(7)
        );
    

    i_pg0_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg0,
        -- GPIO
        do  => pg_o(0),
        ds  => pad_config.pg0.ds & "00",
        sr  => pad_config.pg0.sr,
        co  => pad_config.pg0.co,
        oe  => pg_en(0), 
        odp => pad_config.pg0.odp,
        odn => pad_config.pg0.odn,
        ste => pad_config.pg0.ste,
        pd  => pad_config.pg0.pd,
        pu  => pad_config.pg0.pu,
        di  => pg_i(0)
        );

    i_pg1_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg1,
        -- GPIO
        do  => pg_o(1),
        ds  => pad_config.pg1.ds & "00",
        sr  => pad_config.pg1.sr,
        co  => pad_config.pg1.co,
        oe  => pg_en(1), 
        odp => pad_config.pg1.odp,
        odn => pad_config.pg1.odn,
        ste => pad_config.pg1.ste,
        pd  => pad_config.pg1.pd,
        pu  => pad_config.pg1.pu,
        di  => pg_i(1)
        );

    i_pg2_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg2,
        -- GPIO
        do  => pg_o(2),
        ds  => pad_config.pg2.ds & "00",
        sr  => pad_config.pg2.sr,
        co  => pad_config.pg2.co,
        oe  => pg_en(2), 
        odp => pad_config.pg2.odp,
        odn => pad_config.pg2.odn,
        ste => pad_config.pg2.ste,
        pd  => pad_config.pg2.pd,
        pu  => pad_config.pg2.pu,
        di  => pg_i(2)
        );

    i_pg3_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg3,
        -- GPIO
        do  => pg_o(3),
        ds  => pad_config.pg3.ds & "00",
        sr  => pad_config.pg3.sr,
        co  => pad_config.pg3.co,
        oe  => pg_en(3), 
        odp => pad_config.pg3.odp,
        odn => pad_config.pg3.odn,
        ste => pad_config.pg3.ste,
        pd  => pad_config.pg3.pd,
        pu  => pad_config.pg3.pu,
        di  => pg_i(3)
        );

    i_pg4_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg4,
        -- GPIO
        do  => pg_o(4),
        ds  => pad_config.pg4.ds & "00",
        sr  => pad_config.pg4.sr,
        co  => pad_config.pg4.co,
        oe  => pg_en(4), 
        odp => pad_config.pg4.odp,
        odn => pad_config.pg4.odn,
        ste => pad_config.pg4.ste,
        pd  => pad_config.pg4.pd,
        pu  => pad_config.pg4.pu,
        di  => pg_i(4)
        );

    i_pg5_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg5,
        -- GPIO
        do  => pg_o(5),
        ds  => pad_config.pg5.ds & "00",
        sr  => pad_config.pg5.sr,
        co  => pad_config.pg5.co,
        oe  => pg_en(5), 
        odp => pad_config.pg5.odp,
        odn => pad_config.pg5.odn,
        ste => pad_config.pg5.ste,
        pd  => pad_config.pg5.pd,
        pu  => pad_config.pg5.pu,
        di  => pg_i(5)
        );

    i_pg6_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg6,
        -- GPIO
        do  => pg_o(6),
        ds  => pad_config.pg6.ds & "00",
        sr  => pad_config.pg6.sr,
        co  => pad_config.pg6.co,
        oe  => pg_en(6), 
        odp => pad_config.pg6.odp,
        odn => pad_config.pg6.odn,
        ste => pad_config.pg6.ste,
        pd  => pad_config.pg6.pd,
        pu  => pad_config.pg6.pu,
        di  => pg_i(6)
        );

    i_pg7_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pg7,
        -- GPIO
        do  => pg_o(7),
        ds  => pad_config.pg7.ds & "00",
        sr  => pad_config.pg7.sr,
        co  => pad_config.pg7.co,
        oe  => pg_en(7), 
        odp => pad_config.pg7.odp,
        odn => pad_config.pg7.odn,
        ste => pad_config.pg7.ste,
        pd  => pad_config.pg7.pd,
        pu  => pad_config.pg7.pu,
        di  => pg_i(7)
        ); 

    i_mtest_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => mtest,
        --GPI
        ie  => '1',
        ste => pad_config.mtest.ste,
        pd  => pad_config.mtest.pd,
        pu  => pad_config.mtest.pu,
        di  => mtest_in
        );
    
    i_mwake_pad : entity work.input_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => mwake,
        --GPI
        ie  => '1',
        ste => pad_config.mwake.ste,
        pd  => pad_config.mwake.pd,
        pu  => pad_config.mwake.pu,
        di  => mwake_in
        );
    
      
    i_mrxout_pad : entity work.input_pad -- input in digital_top but output pad in excel-dok?
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => mrxout,
        --GPI
        ie  => '1',
        ste => (others => '0'),
        pd  => '0',
        pu  => '0',
        di  => mrxout_in
        );

     --i_eme_d4_pad : RIIO_EG1D80V_GPIO_LVT28_H (
     --  port map (
     --    PAD_B => emem_d4,
     --    --GPIO
     --    DO_I 
     --    DS_I => "1000",
     --    SR_I => '1',
     --    CO_I => '0',
     --    OE_I => '1',
     --    ODP_I => '0',
     --    ODN_I => '0',
     --    IE_I => '1',
     --    STE_I => "00",
     --    PD_I => '0',
     --    PU_I => '0',
     --    DI_O

     --    VBIAS
     --    );

      spi_miso_oe <= not spi_miso_oe_n;

end architecture rtl;
