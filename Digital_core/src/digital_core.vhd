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

entity digital_core is

  generic (
    g_memory_type     : memory_type_t := asic;
    g_clock_frequency : integer);

  port (
    clk_p_cpu : in std_logic;           -- clk input
    clk_rx    : in std_logic;
    clk_tx    : in std_logic;

    rst_n : in std_logic;

    MRESET     : in  std_logic;         -- system reset, active low
    MRSTOUT    : out std_logic;
    MIRQOUT    : out std_logic;         -- interrupt request output
    MCKOUT0    : out std_logic;         -- for trace adapter
    MCKOUT1    : out std_logic;         -- programable clock out
    mckout1_en : out std_logic;         -- Enable signal for MCKOUT1 pad.
    MTEST      : in  std_logic;         -- active high
    MBYPASS    : in  std_logic;
    MIRQ0      : in  std_logic;         -- active low
    MIRQ1      : in  std_logic;         -- active low
    -- SW debug
    MSDIN      : in  std_logic;         -- serial data in (debug)
    MSDOUT     : out std_logic;         -- serial data out

    MWAKEUP_LP : in  std_logic;         -- active high
    MLP_PWR_OK : in  std_logic;
    -- power management control
    MPMIC_CORE : out std_logic;
    MPMIC_IO   : out std_logic;

    clock_in_off : out std_logic;

    -- Analog internal signals
    pwr_ok     : in  std_logic;         -- Power on detector output (active high)
    dis_bmem   : out std_logic;         -- Disable for vdd_bmem (active high)
    vdd_bmem   : in  std_logic;         -- Power for the BMEM block
    VCC18LP    : in  std_logic;         -- Power for the RTC block
    rxout      : in  std_logic;         -- RTC oscillator output
    ach_sel0   : out std_logic;         -- ADC channel select, bit 0
    ach_sel1   : out std_logic;         -- ADC channel select, bit 1
    ach_sel2   : out std_logic;         -- ADC channel select, bit 2
    adc_bits   : in  std_logic;         -- Bitstream from the analog part of ADC
    adc_ref2v  : out std_logic;         -- Select 2V internal ADC reference (1V)
    adc_extref : out std_logic;         -- Select external ADC reference (internal)
    adc_diff   : out std_logic;         -- Select differential ADC mode (single-ended)
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
    pi_i  : in  std_logic_vector(7 downto 0);
    pi_en : out std_logic_vector(7 downto 0);
    pi_o  : out std_logic_vector(7 downto 0);
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
    ospi_out         : out OSPI_InterfaceOut_t;
    ospi_dq_in       : in  std_logic_vector(7 downto 0);
    ospi_dq_out      : out std_logic_vector(7 downto 0);
    ospi_dq_enable   : out std_logic;
    ospi_rwds_in     : in  std_logic;
    ospi_rwds_out    : out std_logic;
    ospi_rwds_enable : out std_logic);

end entity digital_core;

architecture rtl of digital_core is

  signal cpu_rst_n : std_logic;
begin  -- architecture rtl

  i_im4000_top : entity work.top
    generic map (
      g_memory_type     => g_memory_type,
      g_clock_frequency => 31           -- system clock frequency in MHz
      )
    port map (
      clk_p     => clk_p_cpu,
      clk_rx    => clk_rx,
      clk_tx    => clk_tx,
      MRESET    => MRESET,
      cpu_rst_n => cpu_rst_n,
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

      -- IO-bus interface to NOC adapter
      ext_i_pos  => open,
      ext_ido    => (others => '0'),
      ext_iden   => '1',
      ext_idreq  => '1',
      ext_idack  => open,
      ext_ilioa  => open,
      ext_ildout => open,
      ext_inext  => open,
      ext_idi    => open,

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
      pi_i  => pi_i,
      pi_en => pi_en,
      pi_o  => pi_o,
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

      OSPI_Out    => ospi_out,
      OSPI_DQ_i   => ospi_dq_in,
      OSPI_DQ_o   => ospi_dq_out,
      OSPI_DQ_e   => ospi_dq_enable,
      OSPI_RWDS_i => ospi_rwds_in,
      OSPI_RWDS_o => ospi_rwds_out,
      OSPI_RWDS_e => ospi_rwds_enable,

      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => rxout,
      adc_bits => adc_bits
      );

end architecture rtl;
