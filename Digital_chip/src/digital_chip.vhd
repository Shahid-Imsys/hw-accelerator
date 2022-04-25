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

entity digital_chip is

  port (
    -- PLL reference clock
    pll_ref_clk : in  std_logic;
    -- reset pins
    preset_n    : in  std_logic;  -- Power on reset
    mreset_n    : in  std_logic;  -- Functional reset
    mrstout_n   : out std_logic;  -- reset output for external components

    -- Ethernet Interface
    enet_mdio : inout std_logic;
    enet_mdc  : out   std_logic;
    enet_clk  : in    std_logic;
    enet_txen : out   std_logic;
    enet_txer : out   std_logic;
    enet_txd0 : out   std_logic;
    enet_txd1 : out   std_logic;
    enet_rxvd : in    std_logic;
    enet_rxer : in    std_logic;
    enet_rxdo : in    std_logic;
    enet_rxd1 : in    std_logic;

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

    -- SPI, chip control interface
    spi_sclk : in std_logic;
    spi_cs_n : in std_logic;
    spi_mosi : in std_logic;
    spi_miso : out std_logic;

    -- IM400 DEBUG interface
    mclkout : inout std_logic;
    msdin   : inout  std_logic;
    msdout  : inout std_logic;
    mirqout : inout std_logic;


    -- IM4000 Boot interface
    pa0_sin : inout std_logic;
    pa5_sin : inout std_logic;
    pa6_sin : inout std_logic;
    pa7_sin : inout std_logic;

    -- I/O bus

    -- DAC and ADC pins
    aout0 : out std_logic;
    aout1 : out std_logic;
    ach0  : in  std_logic;
    ach1  : in  std_logic;

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

    mtest  : in  std_logic;  -- port for testmode
    mwake  : in  std_logic;  -- Wake up signal, from what???
    mrxout : out std_logic;  -- RTC test signal/power supply wake up

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

  component ri_adpll_gf22fdx_2gmp_behavioral
    generic (
      ADPLL_STATUS_BITS : integer := 21);
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
      adpll_status_o         : out std_logic_vector(ADPLL_STATUS_BITS-1 downto 0);  --ADPLL status
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
  end component ri_adpll_gf22fdx_2gmp_behavioral;

  signal pll_locked : std_logic;
  signal dco_clk    : std_logic_vector(7 downto 0);

  signal mckout0, mckout1  : std_logic;
  signal msdin_in : std_logic;
  signal msdout_out : std_logic;
  signal mirqout_out : std_logic;

  signal mirq0, mirq1 : std_logic;

  signal vbias : std_logic;

  signal pa_o : std_logic_vector(7 downto 0);
  signal pa_i : std_logic_vector(7 downto 0);
  signal pa_en : std_logic_vector(7 downto 0);

  signal pg_o : std_logic_vector(7 downto 0);
  signal pg_i : std_logic_vector(7 downto 0);
  signal pg_en : std_logic_vector(7 downto 0);

  signal pj_o : std_logic_vector(7 downto 0);
  signal pj_i : std_logic_vector(7 downto 0);
  signal pj_en : std_logic_vector(7 downto 0);

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
  
begin  -- architecture rtl

  -- i_pll : ri_adpll_gf22fdx_2gmp_behavioral
  --   port map (
  --     ref_clk_i              => pll_ref_clk,
  --     scan_clk_i             => '0',
  --     reset_q_i              => preset_n,  --asynchronous reset
  --     en_adpll_ctrl_i        => '1',  --enable controller
  --     clk_core_o             => open,  --low speed core clock output
  --     pll_locked_o           => pll_locked,  --lock signal
  --     c_ci_i                 => "00100",  -- integral filter coefficient (alpha)
  --     c_cp_i                 => x"30",  -- proportional filter coefficient (beta)
  --     c_main_div_n1_i        => '1',  -- main loop divider N1 = 1
  --     c_main_div_n2_i        => "11",  -- main loop divider N2 = 5
  --     c_main_div_n3_i        => "00",  -- main loop divider N3 = 2
  --     c_main_div_n4_i        => "01",  -- main loop divider N4 = 2
  --     c_out_div_sel_i        => "00",  -- output divider select signal
  --     c_open_loop_i          => '0',  -- PLL starts without loop regulation
  --     c_ft_i                 => x"80",  -- fine tune signal for open loop
  --     c_divcore_sel_i        => "00",  -- divcore in Custom macro = 1
  --     c_coarse_i             => "001000",  -- Coarse Tune Value for open loop and Fast Fine Tune
  --     c_bist_mode_i          => '0',  -- BIST mode 1:BIST; 0: normal PLL usage
  --     c_auto_coarsetune_i    => '1',  -- automatic Coarse tune search
  --     c_enforce_lock_i       => '0',  -- overwrites lock bit
  --     c_pfd_select_i         => '0',  -- enables synchronizer for PFD
  --     c_lock_window_sel_i    => '0',  -- lock detection window: 1:short, 0:long
  --     c_div_core_mux_sel_i   => '0',  -- selects divider chain: 0: COREDIV, 1: OUTDIV + COREDIV
  --     c_filter_shift_i       => "10",  -- shift for CP/CI for fast lockin
  --     c_en_fast_lock_i       => '1',  -- enables fast fine tune lockin
  --     c_sar_limit_i          => "000",  -- limit for binary search in fast fine tune
  --     c_set_op_lock_i        => '0',  -- force lock bit to 1 in OP mode
  --     c_disable_lock_i       => '0',  -- force lock bit to 0
  --     c_ref_bypass_i         => '0',  --bypass reference clock to core clock output
  --     c_ct_compensation_i    => '0',  --in case of finetune underflow/overflow coarsetune will be increased/decreased
  --     adpll_status_o         => open,  --ADPLL status
  --     adpll_status_ack_o     => open,
  --     adpll_status_capture_i => '0',  --capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
  --     scan_in_i              => "000",
  --     scan_out_o             => open,
  --     scan_enable_i          => '0',
  --     testmode_i             => mtest,
  --     dco_clk_o              => dco_clk,
  --     clk_tx_o               => open,
  --     pfd_o                  => open,
  --     bist_busy_o            => open,  --1:BIST is still running; 0:BIST finished
  --     bist_fail_coarse_o     => open,  --1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
  --     bist_fail_fine_o       => open  --1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
  --     );

  i_digital_top : entity work.digital_top 
    generic map
      (
        g_clock_frequency => 31  -- system clock frequency in MHz
        )
      port map (
        HCLK    => pll_ref_clk,
        --HCLK    => dco_clk(0),
        MRESET  => mreset_n,
        MRSTOUT => mrstout_n,  -- Missing pad.
        MIRQOUT => mirqout_out,
        MCKOUT0 => mckout0,
        MCKOUT1 => MCKOUT1,
        MTEST   => MTEST,
        MIRQ0   => mirq0,
        MIRQ1   => mirq1,
        -- SW debug
        MSDIN   => msdin_in,
        MSDOUT  => msdout_out,

        -- Port A
        pa_i  => pa_i, --pa_i,
        pa_en => pa_en, --pa_en,
        pa_o  => pa_o, --pa_o,
        -- Port B
        pb_i  => x"00", --pb_i,
        pb_en => open, --pb_en,
        pb_o  => open, --pb_o,
        -- Port C
        pc_i  => x"00", --pc_i,
        pc_en => open, --pc_en,
        pc_o  => open, --pc_o,
        -- Port D
        pd_i  => x"00", --pd_i,
        pd_en => open, --pd_en,
        pd_o  => open, --pd_o,
        -- Port Eopen,
        pe_i  => x"00", --pe_i,
        pe_en => open, --pe_en,
        pe_o  => open, --pe_o,
        -- Port F
        pf_i  => x"00", --pf_i,
        pf_en => open, --pf_en,
        pf_o  => open, --pf_o,
        -- Port G
        pg_i  => x"00", --pg_i,
        pg_en => open, --pg_en,
        pg_o  => open, --pg_o,
        -- Port H
        ph_i  => x"00", --ph_i,
        ph_en => open, --ph_en,
        ph_o  => open, --ph_o,
        -- Port I
        pi_i  => x"00", --pi_i,
        pi_en => open, --pi_en,
        pi_o  => open, --pi_o,
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


        MBYPASS    => '0', --MBYPASS,
        MWAKEUP_LP => '0', --MWAKE,
        MLP_PWR_OK => mreset_n,  --MLP_PWR_OK,

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

        pwr_ok   => '1',
        vdd_bmem => '0',
        VCC18LP  => '1',
        rxout    => mrxout,
        adc_bits => '0' --adc_bits
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
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => '1',
        odp => '0',
        odn => '0'
        );

    i_msdin : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => msdin,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
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
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => '1',
        odp => '0',
        odn => '0'
        );

    i_mirqout_pad : entity work.output_pad  
      generic map (
        direction =>  horizontal)
      port map (
        -- PAD
        pad => mirqout,
        --GPIO
        do  => mirqout_out,
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => '1',
        odp => '0',
        odn => '0'
        );
    
    i_mirq0_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => mirq0_n,
        --GPI
        ie  => '1',
        ste => "00",
        pd  => '0',
        pu  => '0',
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
        ste => "00",
        pd  => '0',
        pu  => '0',
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
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => pj_en(0),
        odp => '0',
        odn => '0'
        );

    i_urx_pad : entity work.input_pad
      generic map (
        direction => horizontal)
      port map (
        -- PAD
        pad => urx,
        --GPI
        ie  => pj_en(1),
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pj_i(1)
        );

  pa_i(4 downto 1) <= "0101";
  
    i_pa0_sin_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa0_sin,
        -- GPIO
        do  => pa_o(0),
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => pa_en(0), 
        odp => '0',
        odn => '0',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pa_i(0)
        );

    i_pa5_cs_n_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa5_sin,
        -- GPIO
        do  => pa_o(5),
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => pa_en(5), 
        odp => '0',
        odn => '0',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pa_i(5)
        );

    i_pa6_sck_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa6_sin,
        -- GPIO
        do  => pa_o(6),
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => pa_en(6), 
        odp => '0',
        odn => '0',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pa_i(6)
        );

    i_pa7_sck_pad : entity work.inoutput_pad
      generic map (
        direction => vertical)
      port map (
        -- PAD
        pad => pa7_sin,
        -- GPIO
        do  => pa_o(7),
        ds  => "1000",
        sr  => '1',
        co  => '0',
        oe  => pa_en(7), 
        odp => '0',
        odn => '0',
        ste => "00",
        pd  => '0',
        pu  => '0',
        di  => pa_i(7)
        );

    --i_pg0_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg0,
    --    -- GPIO
    --    do  => pa_g(0),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(0), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(0)
    --    );

    --i_pg1_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg1,
    --    -- GPIO
    --    do  => pa_g(1),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(1), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(1)
    --    );

    --i_pg2_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg2,
    --    -- GPIO
    --    do  => pa_g(2),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(2), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(2)
    --    );

    --i_pg3_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg3,
    --    -- GPIO
    --    do  => pa_g(3),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(3), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(3)
    --    );

    --i_pg4_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg4,
    --    -- GPIO
    --    do  => pa_g(4),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(4), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(4)
    --    );

    --i_pg5_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg5,
    --    -- GPIO
    --    do  => pa_g(5),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(5), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(5)
    --    );

    --i_pg6_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg6,
    --    -- GPIO
    --    do  => pa_g(6),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(6), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(6)
    --    );

    --i_pg7_pad : entity work.inoutput_pad
    --  generic map (
    --    direction => vertical)
    --  port map (
    --    -- PAD
    --    pad => pg7,
    --    -- GPIO
    --    do  => pa_g(7),
    --    ds  => "1000",
    --    sr  => '1',
    --    co  => '0',
    --    oe  => pg_en(7), 
    --    odp => '0',
    --    odn => '0',
    --    ste => "00",
    --    pd  => '0',
    --    pu  => '0',
    --    di  => pa_i(7)
    --    );

    
    -- i_eme_d4_pad : RIIO_EG1D80V_GPIO_LVT28_H (
    --   port map (
    --     PAD_B => emem_d4,
    --     --GPIO
    --     DO_I 
    --     DS_I => "1000",
    --     SR_I => '1',
    --     CO_I => '0',
    --     OE_I => '1',
    --     ODP_I => '0',
    --     ODN_I => '0',
    --     IE_I => '1',
    --     STE_I => "00",
    --     PD_I => '0',
    --     PU_I => '0',
    --     DI_O

    --     VBIAS
    --     );


      end architecture rtl;
