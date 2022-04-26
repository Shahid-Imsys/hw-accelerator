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

entity digital_top is

  generic (
    g_clock_frequency : integer);

  port (
    hclk       : in  std_logic;         -- clk input   
    MRESET     : in  std_logic;  -- system reset               low active
    MRSTOUT    : out std_logic;
    MIRQOUT    : out std_logic;         -- interrupt request output    
    MCKOUT0    : out std_logic;         --for trace adapter
    MCKOUT1    : out std_logic;         --programable clock out
    mckout1_en : out std_logic;         -- Enable signal for MCKOUT1 pad.
    MTEST      : in  std_logic;  --                            high active                 
    MBYPASS    : in  std_logic;
    MIRQ0      : in  std_logic;  --                            low active
    MIRQ1      : in  std_logic;  --                            low active
    -- SW debug                                                               
    MSDIN      : in  std_logic;         -- serial data in (debug)     
    MSDOUT     : out std_logic;         -- serial data out    

    MWAKEUP_LP : in  std_logic;         --                          high active
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

    -- Ethernet interface
    enet_mdin  : in std_logic;
    enet_mdout : out std_logic;
    enet_mdc   : out   std_logic;
    enet_clk   : in    std_logic;
    enet_txen  : out   std_logic;
    enet_txer  : out   std_logic;
    enet_txd0  : out   std_logic;
    enet_txd1  : out   std_logic;
    enet_rxdv  : in    std_logic;
    enet_rxer  : in    std_logic;
    enet_rxd0  : in    std_logic;
    enet_rxd1  : in    std_logic);

end entity digital_top;

architecture rtl of digital_top is

begin  -- architecture rtl

  i_digital_core : entity work.digital_core
    generic map (
      g_memory_type     => asic,
      g_clock_frequency => g_clock_frequency  -- system clock frequency in MHz
      )
    port map (
      HCLK    => HCLK,
      MRESET  => MRESET,
      MRSTOUT => MRSTOUT,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      MCKOUT1 => MCKOUT1,
      MTEST   => MTEST,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug
      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,

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

      ospi_out.cs_n  => ospi_cs_n,
      ospi_out.ck_n  => ospi_ck_n,
      ospi_out.ck_p  => ospi_ck_p,
      ospi_out.reset_n => ospi_reset_n,
      ospi_dq_in  => ospi_dq_in,
      ospi_dq_out  => ospi_dq_out,
      ospi_dq_enable  => ospi_dq_enable,
      ospi_rwds_in => ospi_rwds_in,
      ospi_rwds_out => ospi_rwds_out,
      ospi_rwds_enable => ospi_rwds_enable,
      

      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => rxout,
      adc_bits => adc_bits

      );

end architecture rtl;
