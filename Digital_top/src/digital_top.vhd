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

use work.gp_pkg.all;
use work.data_types_pack.all;

entity digital_top is

  generic (
    g_memory_type     : memory_type_t := asic;
    g_simulation      : boolean       := false;
    g_clock_frequency : integer       := 31);
  port (
    hclk          : in  std_logic;      -- clk input
    clk_noc       : in  std_logic;    
    pll_ref_clk   : in  std_logic;
    pll_locked    : in  std_logic;
    pre_spi_rst_n : in  std_logic;
    MRESET        : in  std_logic;      -- system reset, active low
    MRSTOUT       : out std_logic;
    MIRQOUT       : out std_logic;      -- interrupt request output
    MCKOUT0       : out std_logic;      -- for trace adapter
    MCKOUT1       : out std_logic;      -- programable clock out
    mckout1_en    : out std_logic;      -- Enable signal for MCKOUT1 pad.
    MTEST         : in  std_logic;      -- Active high
    MBYPASS       : in  std_logic;
    MIRQ0         : in  std_logic;      -- Active low
    MIRQ1         : in  std_logic;      -- Active low
    -- SW debug
    MSDIN         : in  std_logic;      -- serial data in (debug)
    MSDOUT        : out std_logic;      -- serial data out

    MWAKEUP_LP : in  std_logic;         -- Active high
    MLP_PWR_OK : in  std_logic;
    -- power management control
    MPMIC_CORE : out std_logic;
    MPMIC_IO   : out std_logic;

    -- Analog internal signals
    pwr_ok     : in  std_logic;  -- Power on detector output (active high)
    dis_bmem   : out std_logic;         -- Disable for vdd_bmem (active high)
    vdd_bmem   : in  std_logic;         -- Power for the BMEM block
    VCC18LP    : in  std_logic;         -- Power for the RTC block
    rxout      : in  std_logic;         -- RTC oscillator output
    ach_sel0   : out std_logic;         -- ADC channel select, bit 0
    ach_sel1   : out std_logic;         -- ADC channel select, bit 1
    ach_sel2   : out std_logic;         -- ADC channel select, bit 2
    adc_bits   : in  std_logic;  -- Bitstream from the analog part of ADC
    adc_ref2v  : out std_logic;  -- Select 2V internal ADC reference (1V)
    adc_extref : out std_logic;  -- Select external ADC reference (internal)
    adc_diff   : out std_logic;  -- Select differential ADC mode (single-ended)
    adc_en     : out std_logic;         -- Enable for the ADC
    dac0_bits  : out std_logic;         -- Bitstream to DAC0
    dac1_bits  : out std_logic;         -- Bitstream to DAC1
    dac0_en    : out std_logic;         -- Enable for DAC0
    dac1_en    : out std_logic;         -- Enable for DAC1
    clk_a      : out std_logic;         -- Clock to the DAC's and ADC

    -- Port A
    pa_i  : in  std_logic_vector(7 downto 0);
    pa_en : out std_logic_vector(7 downto 0);
    pa_o  : out std_logic_vector(7 downto 0);
    -- Port B
    pb_i  : in  std_logic_vector(7 downto 0);
    pb_en : out std_logic_vector(7 downto 0);
    pb_o  : out std_logic_vector(7 downto 0);
    -- Port C
    pc_i  : in  std_logic_vector(7 downto 0);
    pc_en : out std_logic_vector(7 downto 0);
    pc_o  : out std_logic_vector(7 downto 0);
    -- Port D
    pd_i  : in  std_logic_vector(7 downto 0);
    pd_en : out std_logic_vector(7 downto 0);
    pd_o  : out std_logic_vector(7 downto 0);
    -- Port E
    pe_i  : in  std_logic_vector(7 downto 0);
    pe_en : out std_logic_vector(7 downto 0);
    pe_o  : out std_logic_vector(7 downto 0);
    -- Port F
    pf_i  : in  std_logic_vector(7 downto 0);
    pf_en : out std_logic_vector(7 downto 0);
    pf_o  : out std_logic_vector(7 downto 0);
    -- Port G
    pg_i  : in  std_logic_vector(7 downto 0);
    pg_en : out std_logic_vector(7 downto 0);
    pg_o  : out std_logic_vector(7 downto 0);
    -- Port H
    ph_i  : in  std_logic_vector(7 downto 0);
    ph_en : out std_logic_vector(7 downto 0);
    ph_o  : out std_logic_vector(7 downto 0);
    -- Port I
    -- pi_i  : in  std_logic_vector(7 downto 0);
    -- pi_en : out std_logic_vector(7 downto 0);
    -- pi_o  : out std_logic_vector(7 downto 0);
    -- Port J
    pj_i  : in  std_logic_vector(7 downto 0);
    pj_en : out std_logic_vector(7 downto 0);
    pj_o  : out std_logic_vector(7 downto 0);
    -- I/O cell configuration control outputs
    -- d_hi        : out std_logic; -- High drive on DRAM interface, now used for other outputs
    -- d_sr        : out std_logic; -- Slew rate limit on DRAM interface
    d_lo  : out std_logic;              -- Low drive on DRAM interface
    p1_hi : out std_logic;              -- High drive on port group 1 pins
    p1_sr : out std_logic;              -- Slew rate limit on port group 1 pins
    p2_hi : out std_logic;              -- High drive on port group 2 pins
    p2_sr : out std_logic;              -- Slew rate limit on port group 2 pins
    p3_hi : out std_logic;              -- High drive on port group 3 pins
    p3_sr : out std_logic;              -- Slew rate limit on port group 3 pins

    -- OSPI interface
    ospi_cs_n        : out std_logic;
    ospi_ck_n        : out std_logic;
    ospi_ck_p        : out std_logic;
    ospi_reset_n     : out std_logic;
    ospi_dq_in       : in  std_logic_vector(7 downto 0);
    ospi_dq_out      : out std_logic_vector(7 downto 0);
    ospi_dq_enable   : out std_logic;
    ospi_rwds_in     : in  std_logic;
    ospi_rwds_out    : out std_logic;
    ospi_rwds_enable : out std_logic;
    
    led_clk : out std_logic;

    -- SPI, chip control interface
    spi_sclk      : in  std_logic;
    spi_cs_n      : in  std_logic;
    spi_mosi      : in  std_logic;
    spi_miso      : out std_logic;
    spi_miso_oe_n : out std_logic;
    pad_config    : out pad_config_record_t;
    pll_config    : out pll_registers_record_t;
    adpll_config  : in  adpll_registers_record_t
    );
end entity digital_top;

architecture rtl of digital_top is

  component test_spi_interface is
    port (
      rst_n        : in  std_ulogic;
      sclk_int     : in  std_ulogic;
      sclk_n       : in  std_ulogic;
      cs_n         : in  std_ulogic;
      mosi         : in  std_ulogic;
      miso         : out std_ulogic;
      miso_oe_n    : out std_ulogic;
      pad_config   : out pad_config_record_t;
      pll_config   : out pll_registers_record_t;
      adpll_config : in  adpll_registers_record_t
      );
  end component;

  signal ospi_dq_out_int : std_logic_vector(7 downto 0);

  signal clk_p_cpu   : std_logic;
  signal clk_p_cpu_n : std_logic;
  signal clk_rx      : std_logic;
  signal clk_tx      : std_logic;

  signal sclk        : std_logic;
  signal sclk_n      : std_logic;

  signal spi_rst_n    : std_logic;
  signal cpu_rst_n    : std_logic;
  signal clock_in_off : std_logic;
  signal clock_sel    : std_logic;
  signal c1_wdog_n    : std_logic;

  signal pi_data : std_logic_vector(7 downto 0);

begin  -- architecture rtl

  ospi_dq_out <= ospi_dq_out_int;

  led_clk <= clk_p_cpu;

  clk_rst_asic_gen : if g_memory_type /= fpga generate

    i_clock_reset : entity work.clock_reset

      generic map (
        fpga_g => false )

      port map (
        pll_clk     => hclk,
        pll_ref_clk => pll_ref_clk,
        spi_sclk    => spi_sclk,

        pre_spi_rst_n => pre_spi_rst_n,
        mreset_n      => mreset,
        pwr_ok        => pwr_ok,
        c1_wdog_n     => c1_wdog_n,

        rst_n     => cpu_rst_n,
        spi_rst_n => spi_rst_n,

        clk_p   => clk_p_cpu,
        clk_p_n => clk_p_cpu_n,
        clk_rx  => clk_rx,
        clk_tx  => clk_tx,
        sclk    => sclk,
        sclk_n  => sclk_n,

        pg_1_i => pg_i(1),
        pf_1_i => pf_i(1),

        clock_in_off => clock_in_off,
        sel_pll      => clock_sel,
        spi_sel_pll  => '1',

        spi_override_pll_locked => '0',
        pll_locked              => pll_locked,

        scan_mode => mtest
        );
  end generate;

  clk_rst_fpga_gen : if g_memory_type = fpga generate

    i_clock_reset : entity work.fpga_clock_reset

      port map (
        clk_in                  => hclk,
        spi_sclk                => spi_sclk,
        --
        clk_p                   => clk_p_cpu,
        clk_p_n                 => clk_p_cpu_n,
        clk_rx                  => clk_rx,
        clk_tx                  => clk_tx,
        sclk                    => sclk,
        sclk_n                  => sclk_n,
        --
        pre_spi_rst_n           => pre_spi_rst_n,
        mreset_n                => mreset,
        pwr_ok                  => pwr_ok,
        c1_wdog_n               => c1_wdog_n,
        --  
        rst_n                   => cpu_rst_n,
        spi_rst_n               => spi_rst_n,
        --
        pg_1_i                  => pg_i(1),
        pf_1_i                  => pf_i(1),
        --
        clock_in_off            => clock_in_off,
        sel_pll                 => clock_sel,
        spi_sel_pll             => '1',
        --
        spi_override_pll_locked => '0',
        pll_locked              => pll_locked,
        --
        scan_mode               => mtest
        );
  end generate;

  i_digital_core : entity work.digital_core
    generic map (
      g_memory_type         => g_memory_type,
      ionoc_fifo_depth_bits => 5,
      g_clock_frequency     => g_clock_frequency  -- system clock frequency in MHz
      )
    port map (
      clk_p_cpu   => clk_p_cpu,
      clk_p_cpu_n => clk_p_cpu_n,
      clk_noc     => clk_noc,
      clk_rx      => clk_rx,
      clk_tx      => clk_tx,

      cpu_rst_n => cpu_rst_n,

      MRESET    => MRESET,
      c1_wdog_n => c1_wdog_n,
      MRSTOUT   => MRSTOUT,
      MIRQOUT   => MIRQOUT,
      MCKOUT0   => MCKOUT0,
      MCKOUT1   => MCKOUT1,
      MTEST     => MTEST,
      MIRQ0     => MIRQ0,
      MIRQ1     => MIRQ1,
      -- SW debug
      MSDIN     => MSDIN,
      MSDOUT    => MSDOUT,

      clock_in_off => clock_in_off,
      clock_sel    => clock_sel,

      -- Port A
      pa_i  => pa_i,
      pa_en => pa_en,
      pa_o  => pa_o,
      -- Port B
      pb_i  => pb_i,
      pb_en => pb_en,
      pb_o  => pb_o,
      -- Port C
      pc_i  => pc_i,
      pc_en => pc_en,
      pc_o  => pc_o,
      -- Port D
      pd_i  => pd_i,
      pd_en => pd_en,
      pd_o  => pd_o,
      -- Port Eopen,
      pe_i  => pe_i,
      pe_en => pe_en,
      pe_o  => pe_o,
      -- Port F
      pf_i  => pf_i,
      pf_en => pf_en,
      pf_o  => pf_o,
      -- Port G
      pg_i  => pg_i,
      pg_en => pg_en,
      pg_o  => pg_o,
      -- Port H
      ph_i  => ph_i,
      ph_en => ph_en,
      ph_o  => ph_o,
      -- Port I
      pi_i  => pi_data,
      pi_en => open,
      pi_o  => pi_data,
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


      MBYPASS    => MBYPASS,
      MWAKEUP_LP => MWAKEUP_LP,
      MLP_PWR_OK => MLP_PWR_OK,

      ospi_out.cs_n    => ospi_cs_n,
      ospi_out.ck_n    => ospi_ck_n,
      ospi_out.ck_p    => ospi_ck_p,
      ospi_out.reset_n => ospi_reset_n,
      ospi_dq_in       => ospi_dq_in,
      ospi_dq_out      => ospi_dq_out_int,
      ospi_dq_enable   => ospi_dq_enable,
      ospi_rwds_in     => ospi_rwds_in,
      ospi_rwds_out    => ospi_rwds_out,
      ospi_rwds_enable => ospi_rwds_enable,


      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => rxout,
      adc_bits => adc_bits
      );

  i_test_spi_interface : test_spi_interface
    port map
    (
      rst_n        => spi_rst_n,
      sclk_int     => sclk,
      sclk_n       => sclk_n,
      cs_n         => spi_cs_n,
      mosi         => spi_mosi,
      miso         => spi_miso,
      miso_oe_n    => spi_miso_oe_n,
      pad_config   => pad_config,
      pll_config   => pll_config,
      adpll_config => adpll_config
      );


end architecture rtl;
