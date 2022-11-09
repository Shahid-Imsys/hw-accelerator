
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
-- File       : top.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: Top level model which instantiates the core, memories
--              and other blocks as well as pad blocks.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version   Author  Description
-- 2005-11-28     2.18     CB      Created.
-- 2005-12-20     3.00     CB      Updated for GP3000.
-- 2006-02-01     3.01     CB      Added the ld_bmem signal.
-- 2006-02-15     3.02     CB      Removed en_eth port from clk_gen.
-- 2006-02-17     3.03     CB      Added soft drive strength and slew rate control.
-- 2006-03-09     3.04     CB      Changed pwr_on to pwr_ok, and en_bmem to
--                                 dis_bmem. Replaced port dac_bits on the
--                                 ANALOG block with dac0_bits, dac1_bits.
--                                 Removed adc_fb and dac_clk, added dac_en,
--                                 adc_en, adc_ref2v, adc_extref, adc_diff.
--                                 Removed VSEL, VEXT, added VREGEN. Renamed
--                                 VREFOUT to EXTREF, changed direction from out
--                                 to inout. Changed vdd_rtc to VCC18LP.
-- 2006-03-17     3.05     CB      Added test_pll.
-- 2006-03-21     3.06     CB      Removed the en_c signal and added sel_pll.
--                                 sel_pll now goes to the clk_gen block to
--                                 select source for clk_p instead of en_pll,
--                                 rst_cn controls clk_c gating instead of en_c.
--                                 Added rst_n from core to clk_gen, needed for
--                                 clock switching logic. Changed the PLL feed-
--                                 back from clk_p to pllout (since clk_p can
--                                 have XOSC frequency whil PLL is on).
-- 2006-04-03     3.07     CB      Removed 'freeze' and 'locked', PLL doesn't
--                                 support them.
-- 2012-06-14     4.0      MN      Add clk_in_off and clk_main_off
--                                 change sel_pll to en_pll to connect "sel_pll" pin in module clk_gen
-- 2012-07-10     5.0      MN      Add pad to the top module
-- 2014-07-22     6.0      MN      Add flash interface
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;
use work.gp_pkg.all;
--use work.processor_comp_pkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
-- uncomment below lines when using the top module for xilinx
--library UNISIM;
--use UNISIM.VComponents.all;

--LIBRARY dist_mem_gen_v8_0_13;

entity top is
  generic (
    g_memory_type     : memory_type_t := fpga;
    g_clock_frequency : integer       := 300  -- Frequency in MHz
    );
  port (
    -- clocks and control signals
    clk_p  : in std_logic;                    -- clk input
    clk_p_n: in std_logic;                    -- clk input
    clk_rx : in std_logic;
    clk_tx : in std_logic;

    MRESET     : in  std_logic;         -- system reset, active low
    rst_n      : in  std_logic;
    c1_wdog_n  : out std_logic;
    MRSTOUT    : out std_logic;         -- Reset output
    MIRQOUT    : out std_logic;         -- interrupt request output
    MCKOUT0    : out std_logic;         -- for trace adapter
    MCKOUT1    : out std_logic;         -- programable clock out
    mckout1_en : out std_logic;         -- Enable signal for MCKOUT1 pad.
    MTEST      : in  std_logic;         -- Active high
    MBYPASS    : in  std_logic;
    MIRQ0      : in  std_logic;         -- Active low
    MIRQ1      : in  std_logic;         -- Active low
    -- SW debug
    MSDIN      : in  std_logic;         -- serial data in (debug)
    MSDOUT     : out std_logic;         -- serial data out

    MWAKEUP_LP : in  std_logic;         -- Active high
    MLP_PWR_OK : in  std_logic;
    -- power management control
    --pwr_switch_on : out std_logic_vector(3 downto 0);
    MPMIC_CORE : out std_logic;
    MPMIC_IO   : out std_logic;

    -- Clok control signals
    clock_sel    : out std_logic;
    clock_in_off : out std_logic;

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

    -- IO-bus interface to NOC adapter
    ext_i_pos  : out std_logic;
    ext_ido    : in  std_logic_vector(7 downto 0);
    ext_iden   : in  std_logic;
    ext_idreq  : in  std_logic;
    ext_idack  : out std_logic;
    ext_ilioa  : out std_logic;
    ext_ildout : out std_logic;
    ext_inext  : out std_logic;
    ext_idi    : out std_logic_vector(7 downto 0);
    ext_irq    : in  std_logic;

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
    OSPI_Out    : out OSPI_InterfaceOut_t;
    OSPI_DQ_i   : in  std_logic_vector(7 downto 0);
    OSPI_DQ_o   : out std_logic_vector(7 downto 0);
    OSPI_DQ_e   : out std_logic;
    OSPI_RWDS_i : in  std_logic;
    OSPI_RWDS_o : out std_logic;
    OSPI_RWDS_e : out std_logic
    );
-- MPG RAM signals
end top;

architecture struct of top is

  -- pmem
  component SY180_2048X2X1CM8
    port(
      A0  : in  std_logic;
      A1  : in  std_logic;
      A2  : in  std_logic;
      A3  : in  std_logic;
      A4  : in  std_logic;
      A5  : in  std_logic;
      A6  : in  std_logic;
      A7  : in  std_logic;
      A8  : in  std_logic;
      A9  : in  std_logic;
      A10 : in  std_logic;
      DO0 : out std_logic;
      DO1 : out std_logic;
      DI0 : in  std_logic;
      DI1 : in  std_logic;
      WEB : in  std_logic;
      CK  : in  std_logic;
      CSB : in  std_logic
      );
  end component;

  component mprom_memory00 is
    generic (
      g_memory_type : memory_type_t := asic);
    port (
      address : in  std_logic_vector(11 downto 0);
      rom_do  : out std_logic_vector(79 downto 0);
      oe      : in  std_logic;
      clk_p   : in  std_logic;
      cs      : in  std_logic;
      -- test ports
      test1  : in  std_logic;
      rm  : in  std_logic_vector(3 downto 0);
      rme  : in  std_logic);
  end component;

  component mprom_memory11 is
    generic (
      g_memory_type : memory_type_t := asic);
    port (
      address : in  std_logic_vector(11 downto 0);
      rom_do  : out std_logic_vector(79 downto 0);
      oe      : in  std_logic;
      clk_p   : in  std_logic;
      cs      : in  std_logic;
      -- test ports
      test1  : in  std_logic;
      rm  : in  std_logic_vector(3 downto 0);
      rme  : in  std_logic);
  end component;

  component mpram_memory is
    generic (
      g_file_name   : string        := "mpram0.data";
      g_memory_type : memory_type_t := asic);
    port (
      address : in  std_logic_vector(10 downto 0);
      ram_di  : in  std_logic_vector(79 downto 0);
      ram_do  : out std_logic_vector(79 downto 0);
      we_n    : in  std_logic;
      clk     : in  std_logic;
      cs      : in  std_logic);
  end component mpram_memory;

  component trace_memory is
    generic (
      g_memory_type : memory_type_t := asic);
    port (
      address : in  std_logic_vector(7 downto 0);
      ram_di  : in  std_logic_vector(31 downto 0);
      ram_do  : out std_logic_vector(31 downto 0);
      we_n    : in  std_logic;
      clk     : in  std_logic;
      cs_n    : in  std_logic);
  end component;

  component ram_memory is
    generic (
      g_memory_type : memory_type_t := asic);
    port (
      address : in  std_logic_vector(13 downto 0);
      ram_di  : in  std_logic_vector(7 downto 0);
      ram_do  : out std_logic_vector(7 downto 0);
      we_n    : in  std_logic;
      clk     : in  std_logic;
      cs      : in  std_logic);
  end component;

  component memory_1024x8 is
    generic (
      g_memory_type : memory_type_t := asic);
    port (
      address : in  std_logic_vector(9 downto 0);
      ram_di  : in  std_logic_vector(7 downto 0);
      ram_do  : out std_logic_vector(7 downto 0);
      we_n    : in  std_logic;
      clk     : in  std_logic;
      cs      : in  std_logic);
  end component;

  -----------------------------------------------------------------------------
  -- Internal signals driven by (i.e. "output" from) each block
  -----------------------------------------------------------------------------
  signal msdin_i          : std_logic;
  signal ph_i_from_iopads : std_logic_vector(7 downto 0);
  signal mbypass_i        : std_logic;
  signal mtest_i          : std_logic;
  signal mirq0_i          : std_logic;
  signal mirq1_i          : std_logic;
--  signal mpordis_i    : std_logic;

-- PLL
  -- PLL
  signal tcko    : std_logic;
  signal const_0 : std_logic;
  --signal clk_p : std_logic;

  -- Core clock buffers
  signal even_c      : std_logic;
  signal clk_d       : std_logic;
  signal clk_d_pos   : std_logic;
  signal clk_da_pos  : std_logic;
  signal clk_c_en    : std_logic;
  --signal clk_c2_pos : std_logic;
  signal clk_s_pos   : std_logic;
  signal clk_u_pos   : std_logic;
  signal clk_i       : std_logic;
  signal clk_i_pos   : std_logic;
  signal clk_e_pos   : std_logic;
  signal clk_e_neg   : std_logic;
  signal clk_a_pos   : std_logic;
  signal clk_c2a_pos : std_logic;
  signal clk_ea_pos  : std_logic;
  --signal clk_ea_neg : std_logic;

  -- RTC block
  signal mrxout_o     : std_logic;
  signal rtc_data     : std_logic_vector(7 downto 0);
  signal dis_bmem_int : std_logic;

  signal halt_en         : std_logic;   --high active, will go to halt state
  signal nap_en          : std_logic;   --high active, will go to nap state
  signal poweron_finish  : std_logic;   --
  signal reset_iso       : std_logic;   -- to isolate the core reset
  signal reset_iso_clear : std_logic;   --clear reset isolate
  signal reset_core_n    : std_logic;   -- to reset core, low active
  signal io_iso          : std_logic;  -- to isolate the io signals in nap mode
  signal nap_rec         : std_logic;   -- will recover from nap mode


  -----------------------------------------------------------------------------
  -- core/peri driven signals
  -----------------------------------------------------------------------------
  -- Signals to other blocks
  signal pll_frange      : std_logic;
  signal pll_n           : std_logic_vector(5 downto 0);
  signal pll_m           : std_logic_vector(2 downto 0);
  signal en_xosc         : std_logic;
  signal en_pll          : std_logic;
  signal sel_pll         : std_logic;
  signal xout_selected   : std_logic;
  signal test_pll        : std_logic;
  -- signal pll_vcc18a   : std_logic;
  -- signal pll_gnd18a   : std_logic;
  -- signal pll_vcc18d   : std_logic;
  -- signal pll_gnd18d   : std_logic;
  -- signal pll_vcck     : std_logic;
  -- signal pll_gndk     : std_logic;
--  signal test_pll_temp     : std_logic;  --added by HYX
  signal pll_pdn         : std_logic;   --added by HYX,20141115
  signal erxclk          : std_logic;
  signal etxclk          : std_logic;
  --signal int_rst_n       : std_logic;
  signal rst_cn          : std_logic;
  signal en_d            : std_logic;
  signal fast_d          : std_logic;
  --signal din_e           : std_logic;
  signal din_ea          : std_logic;
  signal din_i           : std_logic;
  signal din_u           : std_logic;
  signal din_s           : std_logic;
  signal din_a           : std_logic;
  --add the following two signals by maning
  signal clk_in_off      : std_logic;
  signal clk_main_off    : std_logic;
  signal sdram_en        : std_logic;
  signal router_ido      : std_logic_vector(7 downto 0);
  signal core_idi        : std_logic_vector(7 downto 0);
  signal bmem_a8         : std_logic;
  signal bmem_d          : std_logic_vector(7 downto 0);
  signal bmem_ce_n       : std_logic;
  signal bmem_we_n       : std_logic;
--  signal ram_partition : std_logic_vector(3 downto 0);
  signal rst_rtc         : std_logic;
  signal en_fclk         : std_logic;
  signal fclk            : std_logic;
  signal ld_bmem         : std_logic;
  signal rtc_sel         : std_logic_vector(2 downto 0);
  signal ach_sel         : std_logic_vector(2 downto 0);
  signal adc_bits_int    : std_logic;   -- added by HYX, 20141205
  -- signal adc_ref2v    : std_logic; --delete by HYX, 20141205
  -- signal adc_extref   : std_logic; --delete by HYX, 20141205
  -- signal adc_diff     : std_logic; --delete by HYX, 20141205
  -- signal adc_en       : std_logic; --delete by HYX, 20141205
  signal dac_bits        : std_logic_vector(0 to 1);
  signal dac_en          : std_logic_vector(0 to 1);
  signal en_tstamp       : std_logic_vector(1 downto 0);
  signal tiu_tstamp      : std_logic;
  signal tstamp          : std_logic_vector(2 downto 0);
  signal mpll_tsto_o     : std_logic;
  signal adc_dac         : std_logic;
  --signals to core2
  signal c2_core2_en     : std_logic;   -- core2 enable
  signal c2_rsc_n        : std_logic;
  signal c2_clkreq_gen   : std_logic;
  --signal  c2_even_c     : std_logic;
  signal c2_crb_out      : std_logic_vector(7 downto 0);
  signal c2_crb_sel      : std_logic_vector(3 downto 0);
  signal c2_en_pmem      : std_logic;
  signal c2_en_wdog      : std_logic;
  signal c2_pup_clk      : std_logic;
  signal c2_pup_irq      : std_logic_vector(1 downto 0);
  signal c2_r_size       : std_logic_vector(1 downto 0);
  signal c2_c_size       : std_logic_vector(1 downto 0);
  signal c2_t_ras        : std_logic_vector(2 downto 0);
  signal c2_t_rcd        : std_logic_vector(1 downto 0);
  signal c2_t_rp         : std_logic_vector(1 downto 0);
--  signal  c2_en_mexec   : std_logic;
  -- to memories signals
  signal c1_mprom_a      : std_logic_vector(13 downto 0);
  signal c1_mprom_ce     : std_logic_vector(1 downto 0);
  signal c1_mprom_oe     : std_logic_vector(1 downto 0);
  signal c1_mpram_a      : std_logic_vector(13 downto 0);
  signal c1_mpram_d      : std_logic_vector(79 downto 0);
  signal c1_mpram_ce     : std_logic_vector(1 downto 0);
  signal c1_mpram_oe     : std_logic_vector(1 downto 0);
  signal c1_mpram_we_n   : std_logic;
  signal c1_gmem_a       : std_logic_vector(9 downto 0);
  signal c1_gmem_d       : std_logic_vector(7 downto 0);
  signal c1_gmem_ce_n    : std_logic;
  signal c1_gmem_we_n    : std_logic;
  signal iomem_a         : std_logic_vector(9 downto 0);
  signal iomem_d         : std_logic_vector(15 downto 0);
  signal iomem_ce_n      : std_logic_vector(1 downto 0);
  signal iomem_we_n      : std_logic;
  signal trcmem_a        : std_logic_vector(7 downto 0);
  signal trcmem_d        : std_logic_vector(31 downto 0);
  signal trcmem_ce_n     : std_logic;
  signal trcmem_we_n     : std_logic;
  signal c1_pmem_a       : std_logic_vector(10 downto 0);
  signal c1_pmem_d       : std_logic_vector(1 downto 0);
  signal c1_pmem_ce_n    : std_logic;
  signal c1_pmem_we_n    : std_logic;
  signal en_pmem2        : std_logic;
  signal short_cycle     : std_logic;
  -- to PADS
  signal mexec_o         : std_logic;
  --signal mxout_o       : std_logic;
  signal ddq_en          : std_logic;
  signal da_o            : std_logic_vector(13 downto 0);
  signal dba_o           : std_logic_vector(1 downto 0);
  signal dcke_o          : std_logic_vector(3 downto 0);
  signal ph_en_to_iopads : std_logic_vector(7 downto 0);
  signal ph_o_to_iopads  : std_logic_vector(7 downto 0);

  signal d_hi : std_logic;
  signal d_sr : std_logic;
  -- signal d_lo  : std_logic;
  -- signal p1_hi : std_logic;
  -- signal p1_sr : std_logic;
  -- signal p2_hi : std_logic;
  -- signal p2_sr : std_logic;
  -- signal p3_hi : std_logic;
  -- signal p3_sr : std_logic;
  -- signal pc_hi         : std_logic;
  -- signal pc_lo_n       : std_logic;
  -- signal ph_hi         : std_logic;
  -- signal ph_lo_n       : std_logic;
  -- signal pi_hi         : std_logic;
  -- signal pi_lo_n       : std_logic;
  -- signal pel_hi        : std_logic;
  -- signal peh_hi        : std_logic;
  -- signal pdll_hi       : std_logic;
  -- signal pdlh_hi       : std_logic;
  -- signal pdh_hi        : std_logic;
  -- signal pf_hi         : std_logic;
  -- signal pg_hi         : std_logic;

  -----------------------------------------------------------------------------
  -- signals between core and peri
  -----------------------------------------------------------------------------
  -- core driven
  signal dbus      : std_logic_vector(7 downto 0);
  signal rst_en    : std_logic;
  signal wdog2_n   : std_logic;
  --signal rst_en2     : std_logic;
  signal pd_s      : std_logic_vector(2 downto 0);
  signal aaddr     : std_logic_vector(4 downto 0);
  signal idack     : std_logic_vector(7 downto 0);
  signal ios_iden  : std_logic;
  signal ios_ido   : std_logic_vector(7 downto 0);
  signal ilioa     : std_logic;
  signal ildout    : std_logic;
  signal inext     : std_logic;
  signal iden      : std_logic;
  signal dqm_size  : std_logic_vector(1 downto 0);
  signal en_uart1  : std_logic;
  signal en_uart2  : std_logic;
  signal en_uart3  : std_logic;
  signal en_eth    : std_logic_vector(1 downto 0);
  signal en_iobus  : std_logic_vector(1 downto 0);
  signal ddqm      : std_logic_vector(7 downto 0);
  signal en_tiu    : std_logic;
  signal run_tiu   : std_logic;
  -- Peri driven
  signal dfp       : std_logic_vector(7 downto 0);
  signal idreq     : std_logic_vector(7 downto 0);
  signal idi       : std_logic_vector(7 downto 0);
  signal irq0      : std_logic;
  signal irq1      : std_logic;
  --- signal declrations for memory selector jameel--
  -- signal dout_rom0_sig : std_logic_vector(79 downto 0);
  -- signal dout_ram0_sig : std_logic_vector(79 downto 0);
  -- signal dout_rom1_sig : std_logic_vector(79 downto 0);
  -- signal dout_ram1_sig : std_logic_vector(79 downto 0);
  ------signal declaration end here------------------
  --signal proc_clk    : std_logic;
  -----------------------------------------------------------------------------
  -- Memory driven signals
  -----------------------------------------------------------------------------
  -- MPROM0, MPROM1, MPRAM0, MPRAM1
  signal c1_mp_q   : std_logic_vector(79 downto 0);
  signal c2_mp_q   : std_logic_vector(79 downto 0);
  -- GMEM
  signal c1_gmem_q : std_logic_vector(7 downto 0);
  signal c2_gmem_q : std_logic_vector(7 downto 0);
  -- IOMEM0, IOMEM1
  signal iomem_q   : std_logic_vector(15 downto 0);

  -- TRCMEM
  signal trcmem_q : std_logic_vector(31 downto 0);

  -- PMEM (Patch memory)
  signal c1_pmem_q : std_logic_vector(1 downto 0);
  signal c2_pmem_q : std_logic_vector(1 downto 0);
  -- BMEM (battery backed memory)
  signal bmem_q    : std_logic_vector(7 downto 0);

  signal rom0_addr_sig : std_logic_vector(11 downto 0);
  -- router related signals
--  signal router_en : STD_LOGIC;                                       --delete by HYX, 20141027
--  signal clk_i_r : STD_LOGIC;                                          --delete by HYX, 20141027
--  signal clk_p_r : STD_LOGIC;                                           --delete by HYX, 20141027
--      signal  north_ack_s_in          : STD_LOGIC_VECTOR (1 downto 0);         --delete by HYX, 20141027
--      signal  north_data_s_in         : STD_LOGIC_VECTOR (3 downto 0);          --delete by HYX, 20141027
--      signal  north_ack_s_out         :  STD_LOGIC_VECTOR (1 downto 0);          --delete by HYX, 20141027
--      signal  north_data_s_out        :  STD_LOGIC_VECTOR (3 downto 0);            --delete by HYX, 20141027
--      signal  south_ack_s_in          : STD_LOGIC_VECTOR (1 downto 0);             --delete by HYX, 20141027
--      signal  south_data_s_in         : STD_LOGIC_VECTOR (3 downto 0);           --delete by HYX, 20141027
--      signal  south_ack_s_out         :  STD_LOGIC_VECTOR (1 downto 0);        --delete by HYX, 20141027
--      signal  south_data_s_out        :  STD_LOGIC_VECTOR (3 downto 0);        --delete by HYX, 20141027
--      signal  west_ack_s_in           : STD_LOGIC_VECTOR (1 downto 0);         --delete by HYX, 20141027
--      signal  west_data_s_in          : STD_LOGIC_VECTOR (3 downto 0);           --delete by HYX, 20141027
--      signal  west_ack_s_out          :  STD_LOGIC_VECTOR (1 downto 0);        --delete by HYX, 20141027
--      signal  west_data_s_out         :  STD_LOGIC_VECTOR (3 downto 0);        --delete by HYX, 20141027
--      signal  east_ack_s_in           : STD_LOGIC_VECTOR (1 downto 0);         --delete by HYX, 20141027
--      signal  east_data_s_in          : STD_LOGIC_VECTOR (3 downto 0);           --delete by HYX, 20141027
--      signal  east_ack_s_out          :  STD_LOGIC_VECTOR (1 downto 0);          --delete by HYX, 20141027
--      signal  east_data_s_out         :  STD_LOGIC_VECTOR (3 downto 0);          --delete by HYX, 20141027
--      signal  rd_irq_n                                 : std_logic;                                         --delete by HYX, 20141027
-------------------------------------------------------------------------------
---------------dual core related----------------------------------------------------------
-------------------------------------------------------------------------------
  signal c1_d_addr     : std_logic_vector(31 downto 0);
  signal c1_d_cs       : std_logic;     -- CS to SDRAM
  signal c1_d_ras      : std_logic;     -- RAS to SDRAM
  signal c1_d_cas      : std_logic;     -- CAS to SDRAM
  signal c1_d_we       : std_logic;     -- WE to SDRAM
  signal c1_d_dqi      : std_logic_vector(7 downto 0);  -- Data in from processor
  signal c1_d_dqi_sd   : std_logic_vector(7 downto 0);  -- Data in from sdram
  signal c1_d_dqo      : std_logic_vector(7 downto 0);  -- Data out to processor
  signal c2_d_addr     : std_logic_vector(31 downto 0);
  signal c2_d_cs       : std_logic;     -- CS to SDRAM
  signal c2_d_ras      : std_logic;     -- RAS to SDRAM
  signal c2_d_cas      : std_logic;     -- CAS to SDRAM
  signal c2_d_we       : std_logic;     -- WE to SDRAM
  signal c2_d_dqi      : std_logic_vector(7 downto 0);  -- Data in from processor
  signal c2_d_dqo      : std_logic_vector(7 downto 0);  -- Data out to processor

  signal c2_mprom_a    : std_logic_vector(13 downto 0);
  signal c2_mprom_ce   : std_logic_vector(1 downto 0);
  signal c2_mprom_oe   : std_logic_vector(1 downto 0);
  signal c2_mpram_a    : std_logic_vector(13 downto 0);
  signal c2_mpram_d    : std_logic_vector(79 downto 0);
  signal c2_mpram_ce   : std_logic_vector(1 downto 0);
  signal c2_mpram_oe   : std_logic_vector(1 downto 0);
  signal c2_mpram_we_n : std_logic;
  signal c2_gmem_a     : std_logic_vector(9 downto 0);
  signal c2_gmem_d     : std_logic_vector(7 downto 0);
  signal c2_gmem_ce_n  : std_logic;
  signal c2_gmem_we_n  : std_logic;
  signal c2_pmem_a     : std_logic_vector(10 downto 0);
  signal c2_pmem_d     : std_logic_vector(1 downto 0);
  signal c2_pmem_ce_n  : std_logic;
  signal c2_pmem_we_n  : std_logic;

  signal mp_ROM0_DO : std_logic_vector (79 downto 0);
  signal mp_ROM0_A  : std_logic_vector (13 downto 0);
  signal mp_ROM0_CS : std_logic;
  signal mp_ROM0_OE : std_logic;
  signal mp_ROM1_DO : std_logic_vector (79 downto 0);
  signal mp_ROM1_A  : std_logic_vector (13 downto 0);
  signal mp_ROM1_CS : std_logic;
  signal mp_ROM1_OE : std_logic;
  signal mp_PM_DO   : std_logic_vector (1 downto 0);
  signal mp_PM_DI   : std_logic_vector (1 downto 0);
  signal mp_PM_A    : std_logic_vector (10 downto 0);
  signal mp_PM_WEB  : std_logic;
  signal mp_PM_CSB  : std_logic;

  signal mp_RAM0_DO  : std_logic_vector (79 downto 0);
  signal mp_RAM0_DI  : std_logic_vector (79 downto 0);
  signal mp_RAM0_A   : std_logic_vector (13 downto 0);
  signal mp_RAM0_WEB : std_logic;
  signal mp_RAM0_OE  : std_logic;
  signal mp_RAM0_CS  : std_logic;

  signal mp_RAM1_DO  : std_logic_vector (79 downto 0);
  signal mp_RAM1_DI  : std_logic_vector (79 downto 0);
  signal mp_RAM1_A   : std_logic_vector (13 downto 0);
  signal mp_RAM1_WEB : std_logic;
  signal mp_RAM1_CS  : std_logic;

  -- Ram memory
  signal ram_a   : main_ram_address_t;
  signal ram_di  : main_ram_data_t;
  signal ram_do  : main_ram_data_t;
  signal ram_cs  : main_ram_cs_t;
  signal ram_web : main_ram_web_t;

  attribute mark_debug : string;
  attribute mark_debug of c1_mprom_a: signal is "true";  
  attribute mark_debug of c1_mprom_ce: signal is "true";
  --attribute mark_debug of c1_mpram_a: signal is "true";  
  attribute mark_debug of c1_mpram_ce: signal is "true";
  --attribute mark_debug of c1_mpram_d: signal is "true";
  --attribute mark_debug of c2_mprom_a: signal is "true";  
  --attribute mark_debug of c2_mprom_ce: signal is "true";
  --attribute mark_debug of c2_mpram_a: signal is "true";  
  --attribute mark_debug of c2_mpram_ce: signal is "true";
  --attribute mark_debug of c2_mpram_d: signal is "true";
  --attribute mark_debug of c2_core2_en: signal is "true";
  --attribute mark_debug of c1_d_addr: signal is "true";
  --attribute mark_debug of c1_d_cs: signal is "true";  
  --attribute mark_debug of c1_d_we: signal is "true";  
  --attribute mark_debug of c1_d_dqo: signal is "true";
  --attribute mark_debug of c1_d_dqi: signal is "true";  
  
  


begin

  -- IO-bus signals to NOC adapter
  ext_i_pos  <= clk_i_pos;
  ext_ilioa  <= ilioa;
  ext_ildout <= ildout;
  ext_inext  <= inext;
  ext_idi    <= idi;

  -- Pads
  iopads_inst : entity work.iopads
    port map(
      -- clocks and control signals
      HCLK => clk_p,

      MTEST   => MTEST,
      MBYPASS => MBYPASS,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug
      MSDIN   => MSDIN,

      --sdram interface
      sdram_en  => sdram_en,
      sd_clk    => clk_d,
      sd_cs     => c1_d_cs,
      sd_ras    => c1_d_ras,
      sd_cas    => c1_d_cas,
      sd_we     => c1_d_we,
      sd_dqi    => c1_d_dqi_sd,
      sd_dqo    => c1_d_dqi,
      sd_en_dqo => ddq_en,
      sd_dqm    => ddqm,
      sd_a      => da_o,
      sd_ba     => dba_o,
      sd_cke    => dcke_o,
      --to other module

      mtest_i => mtest_i,
      mirq0_i => mirq0_i,
      mirq1_i => mirq1_i,
      msdin_i => msdin_i,

      mbypass_i => mbypass_i,

      io_iso => io_iso,

      rtc_clk_tst => mrxout_o,
      clk_p_tst   => clk_p,
      clk_c_tst   => clk_c_en,
      clk_c2_tst  => even_c,
      clk_e_tst   => clk_e_pos,
      clk_c2a_tst => even_c,
      clk_ea_tst  => clk_ea_pos,

      ph_i  => ph_i,
      ph_en => ph_en,
      ph_o  => ph_o,

      ph_i_from_iopads => ph_i_from_iopads,
      ph_en_to_iopads  => ph_en_to_iopads,
      ph_o_to_iopads   => ph_o_to_iopads,

      -- I/O cell configuration control outputs
      d_hi => d_hi,
      d_sr => d_sr
      );
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  rom0_addr_sig <= mp_ROM0_A(12) & mp_ROM0_A(10 downto 0);
  -----------------------------------------------------------------------------
  -- PLL
  -----------------------------------------------------------------------------

  tcko    <= '0';
  pll_pdn <= en_pll or (not xout_selected);  --pll can only be reset when pll is not selected (xout is selected)
  const_0 <= '0';

  -----------------------------------------------------------------------------
  -- Instantiation of memories
  -----------------------------------------------------------------------------

  -- mprom0, mprom1
  --  mprom00
  mprom00 : mprom_memory00
    generic map (
      g_memory_type => g_memory_type)
    port map (
      --address => mp_rom0_a(11 downto 0),
      address => rom0_addr_sig,
      rom_do  => mp_rom0_do,
      oe      => mp_rom0_oe,
      clk_p   => clk_p,
      cs      => mp_rom0_cs,
      test1   => '0',
      rm      => "0000",
      rme     => '0'
      );

  --  mprom11
  mprom11 : mprom_memory11
    generic map (
      g_memory_type => g_memory_type)
    port map (
      address => mp_rom1_a(11 downto 0),
      rom_do  => mp_rom1_do,
      oe      => mp_rom1_oe,
      clk_p   => clk_p,
      cs      => mp_rom1_cs,
      test1   => '0',
      rm      => "0000",
      rme     => '0'
      );

  mpram00 : mpram_memory
    generic map (
      g_file_name   => "mpram0.data",
      g_memory_type => g_memory_type
      )
    port map (
      address => mp_RAM0_A(10 downto 0),
      ram_di  => mp_RAM0_DI,
      ram_do  => mp_RAM0_DO,
      we_n    => mp_RAM0_WEB,
      clk     => clk_p,
      cs      => mp_RAM0_CS
      );

  mpram11 : mpram_memory
    generic map (
      g_file_name   => "mpram1.data",
      g_memory_type => g_memory_type
      )
    port map (
      address => mp_RAM1_A(10 downto 0),
      ram_di  => mp_RAM1_DI,
      ram_do  => mp_RAM1_DO,
      we_n    => mp_RAM1_WEB,
      clk     => clk_p,
      cs      => mp_RAM1_CS
      );

--  -- iomem0, iomem1
  --  iomem0
  iomem0 : memory_1024x8
    generic map (
      g_memory_type => g_memory_type
      )
    port map (
      address => iomem_a,
      ram_di  => iomem_d(7 downto 0),
      ram_do  => iomem_q(7 downto 0),
      we_n    => iomem_we_n,
      clk     => clk_p,
      cs      => iomem_ce_n(0)
      );

  --   iomem1:
  iomem1 : memory_1024x8
    generic map (
      g_memory_type => g_memory_type
      )
    port map (
      address => iomem_a,
      ram_di  => iomem_d(15 downto 8),
      ram_do  => iomem_q(15 downto 8),
      we_n    => iomem_we_n,
      clk     => clk_p,
      cs      => iomem_ce_n(1)
      );

--  -- pmem
  --    mppmem
  mppmem : SY180_2048X2X1CM8
    port map (
      A0  => mp_PM_A(0),
      A1  => mp_PM_A(1),
      A2  => mp_PM_A(2),
      A3  => mp_PM_A(3),
      A4  => mp_PM_A(4),
      A5  => mp_PM_A(5),
      A6  => mp_PM_A(6),
      A7  => mp_PM_A(7),
      A8  => mp_PM_A(8),
      A9  => mp_PM_A(9),
      A10 => mp_PM_A(10),
      DO0 => mp_PM_DO(0),
      DO1 => mp_PM_DO(1),
      DI0 => mp_PM_DI(0),
      DI1 => mp_PM_DI(1),
      WEB => mp_PM_WEB,
      CK  => clk_p,
      CSB => mp_PM_CSB
      );

  -- trcmem
  trcmem : trace_memory
    generic map (
      g_memory_type => g_memory_type)
    port map (
      address => trcmem_a,
      ram_di  => trcmem_d,
      ram_do  => trcmem_q,
      we_n    => trcmem_we_n,
      clk     => clk_p,
      cs_n    => trcmem_ce_n
      );

  ram_g : for i in 0 to MEMNUM-1 generate
    ---application memories
    ram1 : ram_memory
      generic map (
        g_memory_type => g_memory_type)
      port map (
        clk     => clk_p,
        address => ram_a(i),
        ram_di  => ram_di(i),
        ram_do  => ram_do(i),
        we_n    => ram_web(i),
        cs      => ram_cs(i));
  end generate ram_g;

  -----------------------------------------------------------------------------
  -- Clock generation block
  -----------------------------------------------------------------------------
  clk_gen0 : entity work.clk_gen
    port map (
      rst_cn       => rst_cn,
      en_d         => en_d,
      fast_d       => fast_d,
      din_i        => din_i,
      din_u        => din_u,
      din_s        => din_s,
      din_a        => din_a,
      clk_in_off   => clk_in_off,
      clk_main_off => clk_main_off,
      hold_flash_d => '0',
      clk_p        => clk_p,
      clk_c_en     => clk_c_en,
      even_c       => even_c,
      clk_i        => clk_i,
      clk_i_pos    => clk_i_pos,
      clk_d        => clk_d,
      clk_d_pos    => clk_d_pos,
      clk_da_pos   => clk_da_pos,
      clk_u_pos    => clk_u_pos,
      clk_s        => MCKOUT0,
      clk_s_pos    => clk_s_pos,
      clk_a_pos    => clk_a_pos
      );
  clk_a <= clk_a_pos;
--  -----------------------------------------------------------------------------
--  -- Real time clock  !!! SEPARATELY POWERED !!!
--  -----------------------------------------------------------------------------
  rtc0 : entity work.rtc
    generic map (
      g_memory_type     => g_memory_type,
      g_clock_frequency => g_clock_frequency)
    port map(
      pllout        => clk_p,
      sel_pll       => sel_pll,
      xout_selected => xout_selected,
      lp_pwr_ok     => MLP_PWR_OK,
      rxout         => rxout,           -- 32KHz oscillator input
      mrxout_o      => mrxout_o,  -- 32KHz oscillator output or external wake
      rst_rtc       => rst_rtc,         -- Reset RTC counter byte
      en_fclk       => en_fclk,   -- Enable fast clocking of RTC counter byte
      fclk          => fclk,            -- Fast clock to RTC counter byte
      ld_bmem       => ld_bmem,         -- Latch enable to the dis_bmem latch
      rtc_sel       => rtc_sel,         -- RTC byte select
      rtc_data      => rtc_data,        -- RTC data
      dis_bmem      => dis_bmem_int,

      reset_iso_clear => reset_iso_clear,
      halt_en         => halt_en,
      nap_en          => nap_en,
      wakeup_lp       => MWAKEUP_LP,
      poweron_finish  => poweron_finish,
      reset_iso       => reset_iso,
      reset_core_n    => reset_core_n,
      io_iso          => io_iso,
      nap_rec         => nap_rec,
      pmic_core_en    => MPMIC_CORE,
      pmic_io_en      => MPMIC_IO,
      clk_mux_out     => open,

      --gmem1
      c1_gmem_a    => c1_gmem_a,
      c1_gmem_q    => c1_gmem_q,
      c1_gmem_d    => c1_gmem_d,
      c1_gmem_we_n => c1_gmem_we_n,
      c1_gmem_ce_n => c1_gmem_ce_n,

      --gmem2
      c2_gmem_a    => c2_gmem_a,
      c2_gmem_q    => c2_gmem_q,
      c2_gmem_d    => c2_gmem_d,
      c2_gmem_we_n => c2_gmem_we_n,
      c2_gmem_ce_n => c2_gmem_ce_n,

      --bmem
      dbus      => dbus,
      bmem_a8   => bmem_a8,
      bmem_q    => bmem_q,
      bmem_d    => bmem_d,
      bmem_we_n => bmem_we_n,
      bmem_ce_n => bmem_ce_n
      );

  -- Disable power to BMEM
  dis_bmem <= dis_bmem_int;

  clock_in_off <= clk_in_off;

  -----------------------------------------------------------------------------
  -- core
  -----------------------------------------------------------------------------
  core1 : entity work.core
    port map(
      -- Clocks to/from clock block
      clk_p        => clk_p,            --: in  std_logic;  -- PLL clock
      clk_p_n      => clk_p_n,          --: in  std_logic;  -- PLL clock
      clk_c_en     => clk_c_en,         --: in  std_logic;  -- CP clock
      even_c       => even_c,
      --clk_c2_pos   => clk_c2_pos,  --: in  std_logic;  -- clk_c / 2
      clk_e_pos    => clk_e_pos,        --: out  std_logic;  -- Execution clock
      clk_e_neg    => clk_e_neg,        --: out  std_logic;  -- Execution clock
      clk_i_pos    => clk_i_pos,        --: in  std_logic;  -- I/O clock
      clk_d_pos    => clk_d_pos,        --: in  std_logic;  -- DRAM clock
      clk_s_pos    => clk_s_pos,        --: in  std_logic;  -- SP clock
      -- Control outputs to the clock block
      --rst_n        => int_rst_n,  --: out std_logic;  -- Asynchronous reset to clk_gen
      rst_cn       => rst_cn,  --: out std_logic;  -- Reset, will hold all clocks except c,rx,tx
      en_d         => en_d,             --: out std_logic;  -- Enable clk_d
      fast_d       => fast_d,  --: out std_logic;  -- clk_d speed select
      --din_e       => din_e,   --: out std_logic;  -- D input to FF generating clk_e
      din_i        => din_i,  --: out std_logic;  -- D input to FF generating clk_i
      din_u        => din_u,  --: out std_logic;  -- D input to FF generating clk_u
      din_s        => din_s,  --: out std_logic;  -- D input to FF generating clk_s
      clk_in_off   => clk_in_off,
      clock_sel    => clock_sel,
      clk_main_off => clk_main_off,
      sdram_en     => sdram_en,
      --flash Control   -coreflag
      out_line     => open,
      hold_flash   => '0',
      hold_flash_d => '0',
      flash_en     => open,
      flash_mode   => open,
      ld_dqi_flash => '1',
      -- Control signals to/from the oscillator and PLL
      pll_frange   => pll_frange,  --: out std_logic;  -- Frequency range select
      pll_n        => pll_n,  --: out std_logic_vector(5 downto 0);   -- Multiplier
      pll_m        => pll_m,  --: out std_logic_vector(2 downto 0);   -- Divider
      en_xosc      => en_xosc,          --: out std_logic;  -- Enable XOSC
      en_pll       => en_pll,           --: out std_logic;  -- Enable PLL
      sel_pll      => sel_pll,  --: out std_logic;  -- Select PLL as clock source
      test_pll     => test_pll,         --: out std_logic;  -- PLL in test mode
      xout         => clk_p,  --: in  std_logic;  -- XOSC ref. clock output -- 16.7 mhz clk
      -- Power on signal
      pwr_ok       => pwr_ok,  --pwr_ok,  --: in  std_logic;  -- Power is on --change by maning to '1'
      core_wdog_n  => c1_wdog_n,
      ---------------------------------------------------------------------
      -- Memory signals
      ---------------------------------------------------------------------
      -- MPROM signals
      mprom_a      => c1_mprom_a,  --: out std_logic_vector(13 downto 0);-- Address
      mprom_ce     => c1_mprom_ce,  --: out std_logic_vector(1 downto 0); -- Chip enable(active high)
      mprom_oe     => c1_mprom_oe,  --: out std_logic_vector(1 downto 0); --Output enable(active high)
      -- MPRAM signals
      mpram_a      => c1_mpram_a,  --: out std_logic_vector(13 downto 0);-- Address
      mpram_d      => c1_mpram_d,  --: out std_logic_vector(79 downto 0);-- Data to memory
      mpram_ce     => c1_mpram_ce,  --: out std_logic_vector(1 downto 0); -- Chip enable(active high)
      mpram_oe     => c1_mpram_oe,  --: out std_logic_vector(1 downto 0); -- Output enable(active high)
      mpram_we_n   => c1_mpram_we_n,  --: out std_logic;                    -- Write enable(active low)
      -- MPROM/MPRAM data out bus
      mp_q         => c1_mp_q,  --: in  std_logic_vector(79 downto 0);-- Data from MPROM/MPRAM
      -- GMEM signals
      gmem_a       => c1_gmem_a,        --: out std_logic_vector(9 downto 0);
      gmem_d       => c1_gmem_d,        --: out std_logic_vector(7 downto 0);
      gmem_q       => c1_gmem_q,        --: in  std_logic_vector(7 downto 0);
      gmem_ce_n    => c1_gmem_ce_n,     --: out std_logic;
      gmem_we_n    => c1_gmem_we_n,     --: out std_logic;
      -- IOMEM signals
      iomem_a      => iomem_a,          --: out std_logic_vector(9 downto 0);
      iomem_d      => iomem_d,          --: out std_logic_vector(15 downto 0);
      iomem_q      => iomem_q,          --: in  std_logic_vector(15 downto 0);
      iomem_ce_n   => iomem_ce_n,       --: out std_logic_vector(1 downto 0);
      iomem_we_n   => iomem_we_n,       --: out std_logic;
      -- TRCMEM signals (Trace memory)
      trcmem_a     => trcmem_a,         --: out std_logic_vector(7 downto 0);
      trcmem_d     => trcmem_d,         --: out std_logic_vector(31 downto 0);
      trcmem_q     => trcmem_q,         --: in  std_logic_vector(31 downto 0);
      trcmem_ce_n  => trcmem_ce_n,      --: out std_logic;
      trcmem_we_n  => trcmem_we_n,      --: out std_logic;
      -- PMEM signals (Patch memory)
      pmem_a       => c1_pmem_a,        --: out std_logic_vector(10 downto 0);
      pmem_d       => c1_pmem_d,        --: out std_logic_vector(1  downto 0);
      pmem_q       => c1_pmem_q,        --: in  std_logic_vector(1  downto 0);
      pmem_ce_n    => c1_pmem_ce_n,     --: out std_logic;
      pmem_we_n    => c1_pmem_we_n,

      c2_core2_en     => c2_core2_en,
      c2_rsc_n        => c2_rsc_n,
      c2_clkreq_gen   => c2_clkreq_gen,
      --c2_even_c     => c2_even_c,
      c2_crb_sel      => c2_crb_sel,
      c2_crb_out      => c2_crb_out,
      c2_en_pmem      => c2_en_pmem,
      c2_en_wdog      => c2_en_wdog,
      c2_pup_clk      => c2_pup_clk,
      c2_pup_irq      => c2_pup_irq,
      c2_r_size       => c2_r_size,
      c2_c_size       => c2_c_size,
      c2_t_ras        => c2_t_ras,
      c2_t_rcd        => c2_t_rcd,
      c2_t_rp         => c2_t_rp,
--    c2_en_mexec   => c2_en_mexec   ,
      short_cycle     => short_cycle,
      -- BMEM block signals
      bmem_a8         => bmem_a8,       --: out  std_logic;
      bmem_q          => bmem_q,        --: in   std_logic_vector(7 downto 0);
      bmem_d          => bmem_d,        --: out  std_logic_vector(7 downto 0);
      bmem_ce_n       => bmem_ce_n,     --: out  std_logic;
      bmem_we_n       => bmem_we_n,
--        ram_partition => ram_partition,
--      router_ir_en  => router_ir_en ,     --delete by HYX, 20141027
--      north_en            => north_en  ,         --delete by HYX, 20141027
--      south_en            => south_en  ,         --delete by HYX, 20141027
--      west_en             => west_en           ,       --delete by HYX, 20141027
--      east_en             => east_en           ,       --delete by HYX, 20141027
--      router_clk_en => router_clk_en,  --delete by HYX, 20141027
      -- RTC block signals
      reset_core_n    => reset_core_n,
      reset_iso       => reset_iso,
      reset_iso_clear => reset_iso_clear,
      poweron_finish  => poweron_finish,
      nap_rec         => nap_rec,
      halt_en         => halt_en,
      nap_en          => nap_en,
      rst_rtc         => rst_rtc,  --: out std_logic;  -- Reset RTC counter byte
      en_fclk         => en_fclk,  --: out std_logic;  -- Enable fast clocking of RTC counter byte
      fclk            => fclk,  --: out std_logic;  -- Fast clock to RTC counter byte
      ld_bmem         => ld_bmem,  --: out std_logic;  -- Latch enable to the en_bmem latch
      rtc_sel         => rtc_sel,  --: out std_logic_vector(2 downto 0);   -- RTC byte select
      rtc_data        => rtc_data,  --: in  std_logic_vector(7 downto 0);   -- RTC data
      --  Signals to/from Peripheral block
      dfp             => dfp,           --: in  std_logic_vector(7 downto 0);
      dbus            => dbus,          --: out std_logic_vector(7 downto 0);
      rst_en          => rst_en,        --: out std_logic;
      --rst_en2     => rst_en2, --: out std_logic;
      pd              => pd_s,  --: out std_logic_vector(2 downto 0);  -- pl_pd
      aaddr           => aaddr,  --: out std_logic_vector(4 downto 0);  -- pl_aaddr
      idreq           => idreq,         --: in  std_logic_vector(7 downto 0);
      idi             => idi,           --: in  std_logic_vector(7 downto 0);
      idack           => idack,         --: out std_logic_vector(7 downto 0);
      ios_iden        => ios_iden,      --: out std_logic;
      ios_ido         => ios_ido,       --: out std_logic_vector(7 downto 0);
      ilioa           => ilioa,         --: out std_logic;
      ildout          => ildout,        --: out std_logic;
      inext           => inext,         --: out std_logic;
      iden            => iden,          --: in  std_logic;
      dqm_size        => dqm_size,      --: out std_logic_vector(1 downto 0);
      adc_dac         => adc_dac,       --: out std_logic;
      en_uart1        => en_uart1,      --: out std_logic;
      en_uart2        => en_uart2,      --: out std_logic;
      en_uart3        => en_uart3,      --: out std_logic;
      en_eth          => en_eth,        --: out std_logic_vector(1 downto 0);
      en_tiu          => en_tiu,        --: out std_logic;
      run_tiu         => run_tiu,       --: out std_logic;
      en_tstamp       => en_tstamp,     --: out std_logic_vector(1 downto 0);
      en_iobus        => en_iobus,      --: out std_logic_vector(1 downto 0);
      ddqm            => ddqm,          --: out std_logic_vector(7  downto 0);
      irq0            => irq0,  --: in  std_logic;  -- Interrupt request 0
      irq1            => irq1,  --: in  std_logic;  -- Interrupt request 1
      adc_ref2v       => adc_ref2v,  --: out  std_logic;      -- Select 2V internal ADC reference (1V)
---------------------------------------------------------------------
      -- PADS
---------------------------------------------------------------------
      -- Misc. signals
      --mpordis_i     => '1',--MPORDIS, --: in  std_logic;  -- 'power on' from pad
      mreset_i        => mreset,  --: in  std_logic;  -- Asynchronous reset input 
      mirqout_o       => MIRQOUT,  --: out std_logic;  -- Interrupt  request output
      mckout1_o       => MCKOUT1,  --: out std_logic;  -- Programmable clock out
      mckout1_o_en    => mckout1_en,
      msdin_i         => msdin_i,  --: in  std_logic;  -- Serial data in (debug) 
      msdout_o        => MSDOUT,        --: out std_logic;  -- Serial data out
      mrstout_o       => MRSTOUT,       --: out std_logic;  -- Reset out
      mexec_o         => mexec_o,  --: out std_logic;  -- clk_e test output
      mtest_i         => mtest_i,       --: in  std_logic;  -- Test mode---
      mbypass_i       => mbypass_i,     --: in  std_logic;  -- bypass PLL
      mwake_i         => '0',           --: in  std_logic;  -- wake up
      -- DRAM signals
      en_pmem2        => en_pmem2,
      d_addr          => c1_d_addr,     --to internal sram block
      dcs_o           => c1_d_cs,       --: out std_logic;  -- Chip select
      dras_o          => c1_d_ras,  --: out std_logic;  -- Row address strobe
      dcas_o          => c1_d_cas,  --: out std_logic;  -- Column address strobe
      dwe_o           => c1_d_we,       --: out std_logic;  -- Write enable
      ddq_i           => c1_d_dqo,  --: in  std_logic_vector(7 downto 0); -- Data input bus
      ddq_o           => c1_d_dqi,  --: out std_logic_vector(7 downto 0); -- Data output bus
      ddq_en          => ddq_en,  --: out std_logic;  -- Data output bus enable
      da_o            => da_o,  --: out std_logic_vector(13 downto 0);  -- Address
      dba_o           => dba_o,  --: out std_logic_vector(1 downto 0); -- Bank address
      dcke_o          => dcke_o,  --: out std_logic_vector(3 downto 0); -- Clock enable
      -- Port A
      pa_i            => pa_i(4 downto 0),  --: in  std_logic_vector(4 downto 0);
      --pl_out                    => pl_out,
      -- I/O cell configuration control outputs
      d_hi            => d_hi,  --: out std_logic; -- High drive on DRAM interface
      d_sr            => d_sr,  --: out std_logic; -- Slew rate limit on DRAM interface
      d_lo            => d_lo,  --: out std_logic; -- Low drive on DRAM interface
      p1_hi           => p1_hi,  --: out std_logic; -- High drive on port group 1 pins
      p1_sr           => p1_sr,  --: out std_logic; -- Slew rate limit on port group 1 pins
      p2_hi           => p2_hi,  --: out std_logic; -- High drive on port group 2 pins
      p2_sr           => p2_sr,  --: out std_logic; -- Slew rate limit on port group 2 pins
      p3_hi           => p3_hi,  --: out std_logic; -- High drive on port group 3 pins
      p3_sr           => p3_sr  --: out std_logic; -- Slew rate limit on port group 3 pins
     -- pc_hi      => pc_hi          ,   --: out std_logic;  -- High drive on port C pins
     -- pc_lo_n    => pc_lo_n        ,   --: out std_logic;  -- Not low drive port C pins
     -- ph_hi      => ph_hi          ,   --: out std_logic;  -- High drive on port H pins
     -- ph_lo_n    => ph_lo_n        ,   --: out std_logic;  -- Not low drive port H pins
     -- pi_hi      => pi_hi          ,   --: out std_logic;  -- High drive on port I pins
     -- pi_lo_n    => pi_lo_n        ,   --: out std_logic;  -- Not low drive port I pins
     -- pel_hi     => pel_hi         ,   --: out std_logic;  -- High drive on low half of port E pins
     -- peh_hi     => peh_hi         ,   --: out std_logic;  -- High drive on high half of port E pins
     -- pdll_hi    => pdll_hi        ,   --: out std_logic;  -- High drive low dibit, low half of port D
     -- pdlh_hi    => pdlh_hi        ,   --: out std_logic;  -- High drive high dibit, low half of port D
     -- pdh_hi     => pdh_hi         ,   --: out std_logic;  -- High drive on high half of port D pins
     -- pf_hi      => pf_hi          ,   --: out std_logic;  -- High drive on port F pins
     -- pg_hi      => pg_hi             --: out std_logic  -- High drive on port G pins
      );
  core2 : entity work.acore
    port map(
---------------------------------------------------------------------
      -- Signals to/from other blocks
---------------------------------------------------------------------
      -- Clocks to/from clock block
      clk_p       => clk_p,
      clk_c_en    => clk_c_en,
      even_c      => even_c,
      --clk_c2_pos  => clk_c2a_pos,
      clk_e_pos   => clk_ea_pos,
      --clk_e_neg   => clk_ea_neg,
      clk_d_pos   => clk_da_pos,
      -- Control outputs to the clock block
      --rst_n       : out std_logic;  -- Asynchronous reset to clk_gen
      --rst_cn      : out std_logic;  -- Reset, will hold all clocks except c,rx,tx
      --din_e       => din_ea,  -- D input to FF generating clk_e
      -- signals from the master core
      rst_cn      => c2_core2_en,       --reset core2 if disabled
      rsc_n       => c2_rsc_n,
      clkreq_gen  => '0',
      core2_en    => c2_core2_en,
      crb_out     => c2_crb_out,
      en_pmem     => c2_en_pmem,
      en_wdog     => c2_en_wdog,
      pup_clk     => c2_pup_clk,
      pup_irq     => c2_pup_irq,
      r_size      => c2_r_size,
      c_size      => c2_c_size,
      t_ras       => c2_t_ras,
      t_rcd       => c2_t_rcd,
      t_rp        => c2_t_rp,
--    en_mexec            => c2_en_mexec        ,
      dqm_size    => dqm_size,
      fast_d      => fast_d,
      short_cycle => short_cycle,

      crb_sel    => c2_crb_sel,
      --  Signals to/from Peripheral block
      --dfp           => dfp     -- BSV
      dfp        => "00100000",         -- BSV          ,
      wdog2_n    => wdog2_n,
      --dbus        : out std_logic_vector(7 downto 0);
      --rst_en      : out std_logic;
      --pd          : out std_logic_vector(2 downto 0);  -- pl_pd
      --aaddr       : out std_logic_vector(4 downto 0);  -- pl_aaddr
      ddqm       => open,
      irq0       => '1',                -- Interrupt request 0
      irq1       => '1',                -- Interrupt request 1
---------------------------------------------------------------------
      -- Memory signals
---------------------------------------------------------------------
      -- MPROM signals
      mprom_a    => c2_mprom_a,
      mprom_ce   => c2_mprom_ce,
      mprom_oe   => c2_mprom_oe,
      -- MPRAM signals
      mpram_a    => c2_mpram_a,         -- Address
      mpram_d    => c2_mpram_d,         -- Data to memory
      mpram_ce   => c2_mpram_ce,        -- Chip enable(active high)
      mpram_oe   => c2_mpram_oe,        -- Output enable(active high)
      mpram_we_n => c2_mpram_we_n,      -- Write enable(active low)
      -- MPROM/MPRAM data out bus
      mp_q       => c2_mp_q,            -- Data from MPROM/MPRAM
      -- GMEM signals
      gmem_a     => c2_gmem_a,
      gmem_d     => c2_gmem_d,
      gmem_q     => c2_gmem_q,
      gmem_ce_n  => c2_gmem_ce_n,
      gmem_we_n  => c2_gmem_we_n,
      -- PMEM signals (Patch memory)
      pmem_a     => c2_pmem_a,
      pmem_d     => c2_pmem_d,
      pmem_q     => c2_pmem_q,
      pmem_ce_n  => c2_pmem_ce_n,
      pmem_we_n  => c2_pmem_we_n,
---------------------------------------------------------------------
      -- PADS
---------------------------------------------------------------------
      -- DRAM signals
      d_addr     => c2_d_addr,
      dcs_o      => c2_d_cs,
      dras_o     => c2_d_ras,
      dcas_o     => c2_d_cas,
      dwe_o      => c2_d_we,
      ddq_i      => c2_d_dqo,           -- Data input bus
      ddq_o      => c2_d_dqi,  -- out std_logic_vector(7 downto 0); -- Data output bus
      ddq_en     => open,
      da_o       => open,
      dba_o      => open,
      dcke_o     => open                -- Clock enable

      );

  mpmem_inf_inst : entity work.mpmem_inf
    port map(

      -- MPROM signals
      -- clk_p    => clk_p,
      -- rst_cn   => rst_cn,
      -- clk_e_pos  => clk_e_pos,
      -- clk_ea_pos   => clk_ea_pos,
      c1_mprom_a    => c1_mprom_a,      -- Address
      c1_mprom_ce   => c1_mprom_ce,     -- Chip enable(active high)
      c1_mprom_oe   => c1_mprom_oe,     --Output enable(active high)
      -- MPRAM signals
      c1_mpram_a    => c1_mpram_a,      -- Address
      c1_mpram_d    => c1_mpram_d,      -- Data to memory
      c1_mpram_ce   => c1_mpram_ce,     -- Chip enable(active high)
      c1_mpram_oe   => c1_mpram_oe,     -- Output enable(active high)
      c1_mpram_we_n => c1_mpram_we_n,   -- Write enable(active low)
      -- PMEM signals (Patch memory)
      c1_pmem_a     => c1_pmem_a,
      c1_pmem_d     => c1_pmem_d,
      c1_pmem_q     => c1_pmem_q,
      c1_pmem_ce_n  => c1_pmem_ce_n,
      c1_pmem_we_n  => c1_pmem_we_n,

      c1_mp_q       => c1_mp_q,
      -- MPROM signals
      c2_mprom_a    => c2_mprom_a,      -- Address
      c2_mprom_ce   => c2_mprom_ce,     -- Chip enable(active high)
      c2_mprom_oe   => c2_mprom_oe,     --Output enable(active high)
      -- MPRAM signals
      c2_mpram_a    => c2_mpram_a,      -- Address
      c2_mpram_d    => c2_mpram_d,      -- Data to memory
      c2_mpram_ce   => c2_mpram_ce,     -- Chip enable(active high)
      c2_mpram_oe   => c2_mpram_oe,     -- Output enable(active high)
      c2_mpram_we_n => c2_mpram_we_n,   -- Write enable(active low)
      -- PMEM signals (Patch memory)
      c2_pmem_a     => c2_pmem_a,
      c2_pmem_d     => c2_pmem_d,
      c2_pmem_q     => c2_pmem_q,
      c2_pmem_ce_n  => c2_pmem_ce_n,
      c2_pmem_we_n  => c2_pmem_we_n,

      c2_mp_q  => c2_mp_q,
      --memory interface
      --ROM0
      ROM0_DO  => mp_ROM0_DO,           -- in  std_logic_vector (79 downto 0);
      ROM0_A   => mp_ROM0_A,            -- out std_logic_vector (13 downto 0);
      ROM0_CS  => mp_ROM0_CS,           -- out std_logic;
      ROM0_OE  => mp_ROM0_OE,           -- out std_logic;
      --ROM1
      ROM1_DO  => mp_ROM1_DO,           --: in  std_logic_vector (79 downto 0);
      ROM1_A   => mp_ROM1_A,            --: out std_logic_vector (13 downto 0);
      ROM1_CS  => mp_ROM1_CS,           --: out std_logic;
      ROM1_OE  => mp_ROM1_OE,           --: out std_logic;
      --patch memory
      PM_DO    => mp_PM_DO,             --: in  std_logic_vector (1 downto 0);
      PM_DI    => mp_PM_DI,             --: out std_logic_vector (1 downto 0);
      PM_A     => mp_PM_A,              --: out std_logic_vector (10 downto 0);
      PM_WEB   => mp_PM_WEB,            --: out std_logic;
      PM_CSB   => mp_PM_CSB,            --: out std_logic;
      --RAM0
      RAM0_DO  => mp_RAM0_DO,           --: in  std_logic_vector (79 downto 0);
      RAM0_DI  => mp_RAM0_DI,           --: out std_logic_vector (79 downto 0);
      RAM0_A   => mp_RAM0_A,            --: out std_logic_vector (13 downto 0);
      RAM0_WEB => mp_RAM0_WEB,          --: out std_logic;
      RAM0_OE  => mp_RAM0_OE,
      RAM0_CS  => mp_RAM0_CS,           --: out std_logic;
      ----RAM1                          -- not included in the low-power version, deleted 2015-6-22, by HYX
      RAM1_DO  => mp_RAM1_DO,           --: in  std_logic_vector (79 downto 0);
      RAM1_DI  => mp_RAM1_DI,           --: out std_logic_vector (79 downto 0);
      RAM1_A   => mp_RAM1_A,            --: out std_logic_vector (13 downto 0);
      RAM1_WEB => mp_RAM1_WEB,          --: out std_logic;
      RAM1_CS  => mp_RAM1_CS            --: out std_logic
      );


  sdram_inf_inst : entity work.sdram_inf
    port map(
      clk_p       => clk_p,
      clk_d_pos   => clk_d_pos,
      clk_da_pos  => clk_da_pos,
      rst_n       => rst_n,
      short_cycle => short_cycle,
      fast_d      => fast_d,
      -----core1 sdram interface
      c1_d_addr   => c1_d_addr,
      c1_d_cs     => c1_d_cs,
      c1_d_ras    => c1_d_ras,
      c1_d_cas    => c1_d_cas,
      c1_d_we     => c1_d_we,
      c1_d_dqi    => c1_d_dqi,
      c1_d_dqi_sd => c1_d_dqi_sd,
      c1_d_dqo    => c1_d_dqo,
      -----core2 sdram interface
      c2_d_addr   => c2_d_addr,
      c2_d_cs     => c2_d_cs,
      c2_d_ras    => c2_d_ras,
      c2_d_cas    => c2_d_cas,
      c2_d_we     => c2_d_we,
      c2_d_dqi    => c2_d_dqi,
      c2_d_dqo    => c2_d_dqo,
      --memory interface
      --SRAM interface
      ram_a       => ram_a,
      ram_di      => ram_di,
      ram_do      => ram_do,
      ram_cs      => ram_cs,
      ram_web     => ram_web
      );


  -----------------------------------------------------------------------------
  -- Peripherals
  -----------------------------------------------------------------------------

  peri01 : entity work.peri
    generic map (
      g_build_type => g_memory_type)
    port map(
      clk_p       => clk_p,
      clk_p_n     => clk_p_n,
      clk_c_en    => clk_c_en,
      clk_e_pos   => clk_e_pos,
      clk_e_neg   => clk_e_neg,
      clk_i       => clk_i,
      clk_i_pos   => clk_i_pos,
      clk_u_pos   => clk_u_pos,
      clk_rx      => clk_rx,
      clk_tx      => clk_tx,
      clk_a_pos   => clk_a_pos,
      erxclk      => erxclk,
      etxclk      => etxclk,
      din_a       => din_a,
      dbus        => dbus,
      dfp         => dfp,
      rst_en      => rst_en,
      wdog2_n     => wdog2_n,
      --rst_en2     => rst_en2,
      pl_pd       => pd_s,
      pl_aaddr    => aaddr,
      idack       => idack,
      ios_iden    => ios_iden,
      ios_ido     => ios_ido,
      ext_ido     => ext_ido,
      ext_iden    => ext_iden,
      ext_idreq   => ext_idreq,
      ext_idack   => ext_idack,
      ext_irq     => ext_irq,
      ilioa       => ilioa,
      ildout      => ildout,
      inext       => inext,
      iden        => iden,
      --dqm_size      => dqm_size,
      en_uart1    => en_uart1,
      en_uart2    => en_uart2,
      en_uart3    => en_uart3,
      en_eth      => en_eth,
      en_tiu      => en_tiu,
      run_tiu     => run_tiu,
      en_iobus    => en_iobus,
      --ddqm          => ddqm,
      idreq       => idreq,
      idi         => idi,
      irq0        => irq0,
      irq1        => irq1,
      tstamp      => tstamp,
      tiu_tstamp  => tiu_tstamp,
      ach_sel     => ach_sel,
      --adc_bits      => '0',--adc_bits,
      adc_bits    => adc_bits_int,      -- modified by HYX, 20141205
      adc_extref  => adc_extref,
      adc_diff    => adc_diff,
      adc_en      => adc_en,
      dac_bits    => dac_bits,
      dac_en      => dac_en,
      mirq0_i     => mirq0_i,
      mirq1_i     => mirq1_i,
      pa_i        => pa_i,
      pa_en       => pa_en,
      pa_o        => pa_o,
      pb_i        => pb_i,
      pb_en       => pb_en,
      pb_o        => pb_o,
      pc_i        => pc_i,
      pc_en       => pc_en,
      pc_o        => pc_o,
      pd_i        => pd_i,
      pd_en       => pd_en,
      pd_o        => pd_o,
      pe_i        => pe_i,
      pe_en       => pe_en,
      pe_o        => pe_o,
      pf_i        => pf_i,
      pf_en       => pf_en,
      pf_o        => pf_o,
      pg_i        => pg_i,
      pg_en       => pg_en,
      pg_o        => pg_o,
      ph_i        => ph_i_from_iopads,
      ph_en       => ph_en_to_iopads,
      ph_o        => ph_o_to_iopads,
      pi_i        => pi_i,
      pi_en       => pi_en,
      pi_o        => pi_o,
      pj_i        => pj_i,
      pj_en       => pj_en,
      pj_o        => pj_o,
      OSPI_Out    => OSPI_Out,
      OSPI_DQ_i   => OSPI_DQ_i,
      OSPI_DQ_o   => OSPI_DQ_o,
      OSPI_DQ_e   => OSPI_DQ_e,
      OSPI_RWDS_i => OSPI_RWDS_i,
      OSPI_RWDS_o => OSPI_RWDS_o,
      OSPI_RWDS_e => OSPI_RWDS_e
      );

end;
