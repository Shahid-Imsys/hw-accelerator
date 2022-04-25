
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
    g_clock_frequency : integer       := 300 -- Frequency in MHz
    );
  port (
    -- clocks and control signals
    HCLK    : in  std_logic;            -- clk input   
    MRESET  : in  std_logic;            -- system reset, active low
    MRSTOUT : out std_logic;            -- Reset output
    MIRQOUT : out std_logic;            -- interrupt request output    
    MCKOUT0 : out std_logic;            -- for trace adapter
    MCKOUT1 : out std_logic;            -- programable clock out
    mckout1_en : out std_logic;         -- Enable signal for MCKOUT1 pad.
    MTEST   : in  std_logic;            -- Active high                 
    MBYPASS : in  std_logic;
    MIRQ0   : in  std_logic;            -- Active low
    MIRQ1   : in  std_logic;            -- Active low
    -- SW debug                                                               
    MSDIN   : in  std_logic;            -- serial data in (debug)     
    MSDOUT  : out std_logic;            -- serial data out    

    MWAKEUP_LP : in    std_logic;       -- Active high
    MLP_PWR_OK : in    std_logic;
    -- power management control
    --pwr_switch_on : out std_logic_vector(3 downto 0);
    MPMIC_CORE : out   std_logic;
    MPMIC_IO   : out   std_logic;
    -- SDRAM interface (41bits)
    D_CLK      : out   std_logic;       --clock to SDRAM
    D_CS       : out   std_logic;       -- CS to SDRAM
    D_RAS      : out   std_logic;       -- RAS to SDRAM
    D_CAS      : out   std_logic;       -- CAS to SDRAM
    D_WE       : out   std_logic;       -- WE to SDRAM
    D_DQM      : out   std_logic_vector(7 downto 0);  --data mask
    D_DQ       : inout std_logic_vector(7 downto 0);  --data
    D_A        : out   std_logic_vector(13 downto 0);
    D_BA       : out   std_logic_vector(1 downto 0);
    D_CKE      : out   std_logic_vector(3 downto 0);

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
    pa_i       : in  std_logic_vector(7 downto 0);
    pa_en      : out std_logic_vector(7 downto 0);
    pa_o       : out std_logic_vector(7 downto 0);
    -- Port B
    pb_i       : in  std_logic_vector(7 downto 0);
    pb_en      : out std_logic_vector(7 downto 0);
    pb_o       : out std_logic_vector(7 downto 0);
    -- Port C
    pc_i       : in  std_logic_vector(7 downto 0);
    pc_en      : out std_logic_vector(7 downto 0);
    pc_o       : out std_logic_vector(7 downto 0);
    -- Port D
    pd_i       : in  std_logic_vector(7 downto 0);
    pd_en      : out std_logic_vector(7 downto 0);
    pd_o       : out std_logic_vector(7 downto 0);
    -- Port E
    pe_i       : in  std_logic_vector(7 downto 0);
    pe_en      : out std_logic_vector(7 downto 0);
    pe_o       : out std_logic_vector(7 downto 0);
    -- Port F
    pf_i       : in  std_logic_vector(7 downto 0);
    pf_en      : out std_logic_vector(7 downto 0);
    pf_o       : out std_logic_vector(7 downto 0);
    -- Port G
    pg_i       : in  std_logic_vector(7 downto 0);
    pg_en      : out std_logic_vector(7 downto 0);
    pg_o       : out std_logic_vector(7 downto 0);
    -- Port H
    ph_i       : in  std_logic_vector(7 downto 0);
    ph_en      : out std_logic_vector(7 downto 0);
    ph_o       : out std_logic_vector(7 downto 0);
    -- Port I
    pi_i       : in  std_logic_vector(7 downto 0);
    pi_en      : out std_logic_vector(7 downto 0);
    pi_o       : out std_logic_vector(7 downto 0);
    -- Port J
    pj_i       : in  std_logic_vector(7 downto 0);
    pj_en      : out std_logic_vector(7 downto 0);
    pj_o       : out std_logic_vector(7 downto 0);
		-- I/O cell configuration control outputs
    -- d_hi        : out std_logic; -- High drive on DRAM interface, now used for other outputs
    -- d_sr        : out std_logic; -- Slew rate limit on DRAM interface
    d_lo        : out std_logic; -- Low drive on DRAM interface
    p1_hi       : out std_logic; -- High drive on port group 1 pins
    p1_sr       : out std_logic; -- Slew rate limit on port group 1 pins
    p2_hi       : out std_logic; -- High drive on port group 2 pins
    p2_sr       : out std_logic; -- Slew rate limit on port group 2 pins
    p3_hi       : out std_logic; -- High drive on port group 3 pins
    p3_sr       : out std_logic; -- Slew rate limit on port group 3 pins
    
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


--ROM0
  component SP180_4096X80BM1A
    port(
      A0   : in  std_logic;
      A1   : in  std_logic;
      A2   : in  std_logic;
      A3   : in  std_logic;
      A4   : in  std_logic;
      A5   : in  std_logic;
      A6   : in  std_logic;
      A7   : in  std_logic;
      A8   : in  std_logic;
      A9   : in  std_logic;
      A10  : in  std_logic;
      A11  : in  std_logic;
      DO0  : out std_logic;
      DO1  : out std_logic;
      DO2  : out std_logic;
      DO3  : out std_logic;
      DO4  : out std_logic;
      DO5  : out std_logic;
      DO6  : out std_logic;
      DO7  : out std_logic;
      DO8  : out std_logic;
      DO9  : out std_logic;
      DO10 : out std_logic;
      DO11 : out std_logic;
      DO12 : out std_logic;
      DO13 : out std_logic;
      DO14 : out std_logic;
      DO15 : out std_logic;
      DO16 : out std_logic;
      DO17 : out std_logic;
      DO18 : out std_logic;
      DO19 : out std_logic;
      DO20 : out std_logic;
      DO21 : out std_logic;
      DO22 : out std_logic;
      DO23 : out std_logic;
      DO24 : out std_logic;
      DO25 : out std_logic;
      DO26 : out std_logic;
      DO27 : out std_logic;
      DO28 : out std_logic;
      DO29 : out std_logic;
      DO30 : out std_logic;
      DO31 : out std_logic;
      DO32 : out std_logic;
      DO33 : out std_logic;
      DO34 : out std_logic;
      DO35 : out std_logic;
      DO36 : out std_logic;
      DO37 : out std_logic;
      DO38 : out std_logic;
      DO39 : out std_logic;
      DO40 : out std_logic;
      DO41 : out std_logic;
      DO42 : out std_logic;
      DO43 : out std_logic;
      DO44 : out std_logic;
      DO45 : out std_logic;
      DO46 : out std_logic;
      DO47 : out std_logic;
      DO48 : out std_logic;
      DO49 : out std_logic;
      DO50 : out std_logic;
      DO51 : out std_logic;
      DO52 : out std_logic;
      DO53 : out std_logic;
      DO54 : out std_logic;
      DO55 : out std_logic;
      DO56 : out std_logic;
      DO57 : out std_logic;
      DO58 : out std_logic;
      DO59 : out std_logic;
      DO60 : out std_logic;
      DO61 : out std_logic;
      DO62 : out std_logic;
      DO63 : out std_logic;
      DO64 : out std_logic;
      DO65 : out std_logic;
      DO66 : out std_logic;
      DO67 : out std_logic;
      DO68 : out std_logic;
      DO69 : out std_logic;
      DO70 : out std_logic;
      DO71 : out std_logic;
      DO72 : out std_logic;
      DO73 : out std_logic;
      DO74 : out std_logic;
      DO75 : out std_logic;
      DO76 : out std_logic;
      DO77 : out std_logic;
      DO78 : out std_logic;
      DO79 : out std_logic;
      CK   : in  std_logic;
      CS   : in  std_logic;
      OE   : in  std_logic
      );
  end component;


-- ROM1
  component SP180_4096X80BM1B
    port(
      A0   : in  std_logic;
      A1   : in  std_logic;
      A2   : in  std_logic;
      A3   : in  std_logic;
      A4   : in  std_logic;
      A5   : in  std_logic;
      A6   : in  std_logic;
      A7   : in  std_logic;
      A8   : in  std_logic;
      A9   : in  std_logic;
      A10  : in  std_logic;
      A11  : in  std_logic;
      DO0  : out std_logic;
      DO1  : out std_logic;
      DO2  : out std_logic;
      DO3  : out std_logic;
      DO4  : out std_logic;
      DO5  : out std_logic;
      DO6  : out std_logic;
      DO7  : out std_logic;
      DO8  : out std_logic;
      DO9  : out std_logic;
      DO10 : out std_logic;
      DO11 : out std_logic;
      DO12 : out std_logic;
      DO13 : out std_logic;
      DO14 : out std_logic;
      DO15 : out std_logic;
      DO16 : out std_logic;
      DO17 : out std_logic;
      DO18 : out std_logic;
      DO19 : out std_logic;
      DO20 : out std_logic;
      DO21 : out std_logic;
      DO22 : out std_logic;
      DO23 : out std_logic;
      DO24 : out std_logic;
      DO25 : out std_logic;
      DO26 : out std_logic;
      DO27 : out std_logic;
      DO28 : out std_logic;
      DO29 : out std_logic;
      DO30 : out std_logic;
      DO31 : out std_logic;
      DO32 : out std_logic;
      DO33 : out std_logic;
      DO34 : out std_logic;
      DO35 : out std_logic;
      DO36 : out std_logic;
      DO37 : out std_logic;
      DO38 : out std_logic;
      DO39 : out std_logic;
      DO40 : out std_logic;
      DO41 : out std_logic;
      DO42 : out std_logic;
      DO43 : out std_logic;
      DO44 : out std_logic;
      DO45 : out std_logic;
      DO46 : out std_logic;
      DO47 : out std_logic;
      DO48 : out std_logic;
      DO49 : out std_logic;
      DO50 : out std_logic;
      DO51 : out std_logic;
      DO52 : out std_logic;
      DO53 : out std_logic;
      DO54 : out std_logic;
      DO55 : out std_logic;
      DO56 : out std_logic;
      DO57 : out std_logic;
      DO58 : out std_logic;
      DO59 : out std_logic;
      DO60 : out std_logic;
      DO61 : out std_logic;
      DO62 : out std_logic;
      DO63 : out std_logic;
      DO64 : out std_logic;
      DO65 : out std_logic;
      DO66 : out std_logic;
      DO67 : out std_logic;
      DO68 : out std_logic;
      DO69 : out std_logic;
      DO70 : out std_logic;
      DO71 : out std_logic;
      DO72 : out std_logic;
      DO73 : out std_logic;
      DO74 : out std_logic;
      DO75 : out std_logic;
      DO76 : out std_logic;
      DO77 : out std_logic;
      DO78 : out std_logic;
      DO79 : out std_logic;
      CK   : in  std_logic;
      CS   : in  std_logic;
      OE   : in  std_logic
      );
  end component;

  component mpram_memory is
    generic (
      g_file_name   : string        := "mpram0.data";
      g_memory_type : memory_type_t := referens);
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
      g_memory_type : memory_type_t := referens);
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
      g_memory_type : memory_type_t := referens);
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
      g_memory_type : memory_type_t := referens);
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
  signal hclk_i    : std_logic;
  signal msdin_i   : std_logic;
  signal ph_i_from_iopads : std_logic_vector(7 downto 0);
  signal mbypass_i : std_logic;
  signal mreset_i  : std_logic;
  signal mtest_i   : std_logic;
  signal mirq0_i   : std_logic;
  signal mirq1_i   : std_logic;
--  signal mpordis_i    : std_logic;                                                

-- PLL
  -- PLL 
  signal tcko    : std_logic;
  signal const_0 : std_logic;

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
  signal clk_p       : std_logic;
  signal clk_rx      : std_logic;
  signal clk_tx      : std_logic;
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
  signal clk_mux_out     : std_logic;


  -----------------------------------------------------------------------------
  -- core/peri driven signals
  -----------------------------------------------------------------------------
  -- Signals to other blocks
  signal pll_frange    : std_logic;
  signal pll_n         : std_logic_vector(5 downto 0);
  signal pll_m         : std_logic_vector(2 downto 0);
  signal en_xosc       : std_logic;
  signal en_pll        : std_logic;
  signal sel_pll       : std_logic;
  signal xout_selected : std_logic;
  signal test_pll      : std_logic;
  -- signal pll_vcc18a   : std_logic;
  -- signal pll_gnd18a   : std_logic;
  -- signal pll_vcc18d   : std_logic;
  -- signal pll_gnd18d   : std_logic;
  -- signal pll_vcck     : std_logic;
  -- signal pll_gndk     : std_logic;
--  signal test_pll_temp     : std_logic;  --added by HYX 
  signal pll_pdn       : std_logic;     --added by HYX,20141115
  signal erxclk        : std_logic;
  signal etxclk        : std_logic;
  signal rst_n         : std_logic;
  signal rst_cn        : std_logic;
  signal en_d          : std_logic;
  signal fast_d        : std_logic;
  --signal din_e        : std_logic;
  signal din_ea        : std_logic;
  signal din_i         : std_logic;
  signal din_u         : std_logic;
  signal din_s         : std_logic;
  signal din_a         : std_logic;
  --add the following two signals by maning
  signal clk_in_off    : std_logic;
  signal clk_main_off  : std_logic;
  signal sdram_en      : std_logic;
  signal out_line      : std_logic;
  signal hold_flash    : std_logic;
  signal hold_flash_d  : std_logic;
  signal flash_en      : std_logic;
  signal flash_mode    : std_logic_vector (3 downto 0);
  signal ld_dqi_flash  : std_logic;
  signal router_ido    : std_logic_vector(7 downto 0);
  signal core_idi      : std_logic_vector(7 downto 0);
  signal bmem_a8       : std_logic;
  signal bmem_d        : std_logic_vector(7 downto 0);
  signal bmem_ce_n     : std_logic;
  signal bmem_we_n     : std_logic;
--  signal ram_partition : std_logic_vector(3 downto 0); 
  signal rst_rtc       : std_logic;
  signal en_fclk       : std_logic;
  signal fclk          : std_logic;
  signal ld_bmem       : std_logic;
  signal rtc_sel       : std_logic_vector(2 downto 0);
  signal ach_sel       : std_logic_vector(2 downto 0);
  signal adc_bits_int  : std_logic;     -- added by HYX, 20141205
  -- signal adc_ref2v    : std_logic; --delete by HYX, 20141205
  -- signal adc_extref   : std_logic; --delete by HYX, 20141205
  -- signal adc_diff     : std_logic; --delete by HYX, 20141205
  -- signal adc_en       : std_logic; --delete by HYX, 20141205
  signal dac_bits      : std_logic_vector(0 to 1);
  signal dac_en        : std_logic_vector(0 to 1);
  signal en_tstamp     : std_logic_vector(1 downto 0);
  signal tiu_tstamp    : std_logic;
  signal tstamp        : std_logic_vector(2 downto 0);
  signal mpll_tsto_o   : std_logic;
  signal adc_dac       : std_logic;
  --signals to core2
  signal c2_core2_en   : std_logic;     -- core2 enable
  signal c2_rsc_n      : std_logic;
  signal c2_clkreq_gen : std_logic;
  --signal  c2_even_c     : std_logic;
  signal c2_crb_out    : std_logic_vector(7 downto 0);
  signal c2_crb_sel    : std_logic_vector(3 downto 0);
  signal c2_en_pmem    : std_logic;
  signal c2_en_wdog    : std_logic;
  signal c2_pup_clk    : std_logic;
  signal c2_pup_irq    : std_logic_vector(1 downto 0);
  signal c2_r_size     : std_logic_vector(1 downto 0);
  signal c2_c_size     : std_logic_vector(1 downto 0);
  signal c2_t_ras      : std_logic_vector(2 downto 0);
  signal c2_t_rcd      : std_logic_vector(1 downto 0);
  signal c2_t_rp       : std_logic_vector(1 downto 0);
--  signal  c2_en_mexec   : std_logic;
  -- to memories signals
  signal c1_mprom_a    : std_logic_vector(13 downto 0);
  signal c1_mprom_ce   : std_logic_vector(1 downto 0);
  signal c1_mprom_oe   : std_logic_vector(1 downto 0);
  signal c1_mpram_a    : std_logic_vector(13 downto 0);
  signal c1_mpram_d    : std_logic_vector(79 downto 0);
  signal c1_mpram_ce   : std_logic_vector(1 downto 0);
  signal c1_mpram_oe   : std_logic_vector(1 downto 0);
  signal c1_mpram_we_n : std_logic;
  signal c1_gmem_a     : std_logic_vector(9 downto 0);
  signal c1_gmem_d     : std_logic_vector(7 downto 0);
  signal c1_gmem_ce_n  : std_logic;
  signal c1_gmem_we_n  : std_logic;
  signal iomem_a       : std_logic_vector(9 downto 0);
  signal iomem_d       : std_logic_vector(15 downto 0);
  signal iomem_ce_n    : std_logic_vector(1 downto 0);
  signal iomem_we_n    : std_logic;
  signal trcmem_a      : std_logic_vector(7 downto 0);
  signal trcmem_d      : std_logic_vector(31 downto 0);
  signal trcmem_ce_n   : std_logic;
  signal trcmem_we_n   : std_logic;
  signal c1_pmem_a     : std_logic_vector(10 downto 0);
  signal c1_pmem_d     : std_logic_vector(1 downto 0);
  signal c1_pmem_ce_n  : std_logic;
  signal c1_pmem_we_n  : std_logic;
  signal en_pmem2      : std_logic;
  signal short_cycle   : std_logic;
  -- to PADS
  signal mexec_o       : std_logic;
  --signal mxout_o       : std_logic;
  signal ddq_en        : std_logic;
  signal da_o          : std_logic_vector(13 downto 0);
  signal dba_o         : std_logic_vector(1 downto 0);
  signal dcke_o        : std_logic_vector(3 downto 0);  
  signal ph_en_to_iopads         : std_logic_vector(7 downto 0);
  signal ph_o_to_iopads          : std_logic_vector(7 downto 0);

  signal d_hi  : std_logic;
  signal d_sr  : std_logic;
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

  signal f_addr_in  : std_logic_vector(16 downto 0);
  signal f_rd_in    : std_logic;        -- low active
  signal f_wr_in    : std_logic;        -- low active        
  signal f_data_in  : std_logic_vector(7 downto 0);  -- Data in from processor
  signal f_data_out : std_logic_vector(7 downto 0);  -- Data out to processor   
  signal f_CE       : std_logic;
  signal f_ADDR     : std_logic_vector(12 downto 0);
  signal f_WRONLY   : std_logic;
  signal f_PERASE   : std_logic;
  signal f_SERASE   : std_logic;
  signal f_MERASE   : std_logic;
  signal f_PROG     : std_logic;
  signal f_INF      : std_logic;
  signal f_POR      : std_logic;
  signal f_SAVEN    : std_logic;
  signal f_TM       : std_logic_vector(3 downto 0);
  signal f_DATA_WR  : std_logic_vector(31 downto 0);
  signal f0_ALE     : std_logic;
  signal f0_DATA_IN : std_logic_vector(31 downto 0);
  signal f0_RBB     : std_logic;
  signal f1_ALE     : std_logic;
  signal f1_DATA_IN : std_logic_vector(31 downto 0);
  signal f1_RBB     : std_logic;
  signal f2_ALE     : std_logic;
  signal f2_DATA_IN : std_logic_vector(31 downto 0);
  signal f2_RBB     : std_logic;
  signal f3_ALE     : std_logic;
  signal f3_DATA_IN : std_logic_vector(31 downto 0);
  signal f3_RBB     : std_logic;
  --RAM0 
  signal RAM0_DO    : std_logic_vector (7 downto 0);  -- modify flag, 2015lp
  signal RAM0_DI    : std_logic_vector (7 downto 0);
  signal RAM0_A     : std_logic_vector (13 downto 0);
  signal RAM0_WEB   : std_logic;
  signal RAM0_CS    : std_logic;
  --RAM1 
  signal RAM1_DO    : std_logic_vector (7 downto 0);
  signal RAM1_DI    : std_logic_vector (7 downto 0);
  signal RAM1_A     : std_logic_vector (13 downto 0);
  signal RAM1_WEB   : std_logic;
  signal RAM1_CS    : std_logic;
  --RAM2 
  signal RAM2_DO    : std_logic_vector (7 downto 0);
  signal RAM2_DI    : std_logic_vector (7 downto 0);
  signal RAM2_A     : std_logic_vector (13 downto 0);
  signal RAM2_WEB   : std_logic;
  signal RAM2_CS    : std_logic;
  --RAM3 
  signal RAM3_DO    : std_logic_vector (7 downto 0);
  signal RAM3_DI    : std_logic_vector (7 downto 0);
  signal RAM3_A     : std_logic_vector (13 downto 0);
  signal RAM3_WEB   : std_logic;
  signal RAM3_CS    : std_logic;
  --RAM4 
  signal RAM4_DO    : std_logic_vector (7 downto 0);
  signal RAM4_DI    : std_logic_vector (7 downto 0);
  signal RAM4_A     : std_logic_vector (13 downto 0);
  signal RAM4_WEB   : std_logic;
  signal RAM4_CS    : std_logic;

begin


  --pads
  iopads_inst : entity work.iopads
    port map(
      -- clocks and control signals
      HCLK       => HCLK,
       
      MRESET  => MRESET,
      MTEST   => MTEST,
      MBYPASS => MBYPASS,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug                                                                
      MSDIN   => MSDIN,

      -- SDRAM
      D_CLK     => D_CLK,
      D_CS      => D_CS,
      D_RAS     => D_RAS,
      D_CAS     => D_CAS,
      D_WE      => D_WE,
      D_DQ      => D_DQ,
      D_DQM     => D_DQM,
      D_A       => D_A,
      D_BA      => D_BA,
      D_CKE     => D_CKE,
      -- Ports
      
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

      mreset_i => mreset_i,
      mtest_i  => mtest_i,
      mirq0_i  => mirq0_i,
      mirq1_i  => mirq1_i,
      msdin_i  => msdin_i,

      mbypass_i    => mbypass_i,
      
      io_iso       => io_iso,


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
           
      ph_i_from_iopads  => ph_i_from_iopads,
      ph_en_to_iopads => ph_en_to_iopads,
      ph_o_to_iopads  => ph_o_to_iopads,
      
      -- I/O cell configuration control outputs
      d_hi  => d_hi,
      d_sr  => d_sr
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
  mprom00 : SP180_4096X80BM1A
    port map (
      A0   => rom0_addr_sig(0),
      A1   => rom0_addr_sig(1),
      A2   => rom0_addr_sig(2),
      A3   => rom0_addr_sig(3),
      A4   => rom0_addr_sig(4),
      A5   => rom0_addr_sig(5),
      A6   => rom0_addr_sig(6),
      A7   => rom0_addr_sig(7),
      A8   => rom0_addr_sig(8),
      A9   => rom0_addr_sig(9),
      A10  => rom0_addr_sig(10),
      A11  => rom0_addr_sig(11),
      DO0  => mp_ROM0_DO(0),
      DO1  => mp_ROM0_DO(1),
      DO2  => mp_ROM0_DO(2),
      DO3  => mp_ROM0_DO(3),
      DO4  => mp_ROM0_DO(4),
      DO5  => mp_ROM0_DO(5),
      DO6  => mp_ROM0_DO(6),
      DO7  => mp_ROM0_DO(7),
      DO8  => mp_ROM0_DO(8),
      DO9  => mp_ROM0_DO(9),
      DO10 => mp_ROM0_DO(10),
      DO11 => mp_ROM0_DO(11),
      DO12 => mp_ROM0_DO(12),
      DO13 => mp_ROM0_DO(13),
      DO14 => mp_ROM0_DO(14),
      DO15 => mp_ROM0_DO(15),
      DO16 => mp_ROM0_DO(16),
      DO17 => mp_ROM0_DO(17),
      DO18 => mp_ROM0_DO(18),
      DO19 => mp_ROM0_DO(19),
      DO20 => mp_ROM0_DO(20),
      DO21 => mp_ROM0_DO(21),
      DO22 => mp_ROM0_DO(22),
      DO23 => mp_ROM0_DO(23),
      DO24 => mp_ROM0_DO(24),
      DO25 => mp_ROM0_DO(25),
      DO26 => mp_ROM0_DO(26),
      DO27 => mp_ROM0_DO(27),
      DO28 => mp_ROM0_DO(28),
      DO29 => mp_ROM0_DO(29),
      DO30 => mp_ROM0_DO(30),
      DO31 => mp_ROM0_DO(31),
      DO32 => mp_ROM0_DO(32),
      DO33 => mp_ROM0_DO(33),
      DO34 => mp_ROM0_DO(34),
      DO35 => mp_ROM0_DO(35),
      DO36 => mp_ROM0_DO(36),
      DO37 => mp_ROM0_DO(37),
      DO38 => mp_ROM0_DO(38),
      DO39 => mp_ROM0_DO(39),
      DO40 => mp_ROM0_DO(40),
      DO41 => mp_ROM0_DO(41),
      DO42 => mp_ROM0_DO(42),
      DO43 => mp_ROM0_DO(43),
      DO44 => mp_ROM0_DO(44),
      DO45 => mp_ROM0_DO(45),
      DO46 => mp_ROM0_DO(46),
      DO47 => mp_ROM0_DO(47),
      DO48 => mp_ROM0_DO(48),
      DO49 => mp_ROM0_DO(49),
      DO50 => mp_ROM0_DO(50),
      DO51 => mp_ROM0_DO(51),
      DO52 => mp_ROM0_DO(52),
      DO53 => mp_ROM0_DO(53),
      DO54 => mp_ROM0_DO(54),
      DO55 => mp_ROM0_DO(55),
      DO56 => mp_ROM0_DO(56),
      DO57 => mp_ROM0_DO(57),
      DO58 => mp_ROM0_DO(58),
      DO59 => mp_ROM0_DO(59),
      DO60 => mp_ROM0_DO(60),
      DO61 => mp_ROM0_DO(61),
      DO62 => mp_ROM0_DO(62),
      DO63 => mp_ROM0_DO(63),
      DO64 => mp_ROM0_DO(64),
      DO65 => mp_ROM0_DO(65),
      DO66 => mp_ROM0_DO(66),
      DO67 => mp_ROM0_DO(67),
      DO68 => mp_ROM0_DO(68),
      DO69 => mp_ROM0_DO(69),
      DO70 => mp_ROM0_DO(70),
      DO71 => mp_ROM0_DO(71),
      DO72 => mp_ROM0_DO(72),
      DO73 => mp_ROM0_DO(73),
      DO74 => mp_ROM0_DO(74),
      DO75 => mp_ROM0_DO(75),
      DO76 => mp_ROM0_DO(76),
      DO77 => mp_ROM0_DO(77),
      DO78 => mp_ROM0_DO(78),
      DO79 => mp_ROM0_DO(79),
      CK   => clk_p,
      CS   => mp_ROM0_CS,
      OE   => mp_ROM0_OE
      );



  --  mprom11
  mprom11 : SP180_4096X80BM1B
    port map (
      A0   => mp_ROM1_A(0),
      A1   => mp_ROM1_A(1),
      A2   => mp_ROM1_A(2),
      A3   => mp_ROM1_A(3),
      A4   => mp_ROM1_A(4),
      A5   => mp_ROM1_A(5),
      A6   => mp_ROM1_A(6),
      A7   => mp_ROM1_A(7),
      A8   => mp_ROM1_A(8),
      A9   => mp_ROM1_A(9),
      A10  => mp_ROM1_A(10),
      A11  => mp_ROM1_A(11),
      DO0  => mp_ROM1_DO(0),
      DO1  => mp_ROM1_DO(1),
      DO2  => mp_ROM1_DO(2),
      DO3  => mp_ROM1_DO(3),
      DO4  => mp_ROM1_DO(4),
      DO5  => mp_ROM1_DO(5),
      DO6  => mp_ROM1_DO(6),
      DO7  => mp_ROM1_DO(7),
      DO8  => mp_ROM1_DO(8),
      DO9  => mp_ROM1_DO(9),
      DO10 => mp_ROM1_DO(10),
      DO11 => mp_ROM1_DO(11),
      DO12 => mp_ROM1_DO(12),
      DO13 => mp_ROM1_DO(13),
      DO14 => mp_ROM1_DO(14),
      DO15 => mp_ROM1_DO(15),
      DO16 => mp_ROM1_DO(16),
      DO17 => mp_ROM1_DO(17),
      DO18 => mp_ROM1_DO(18),
      DO19 => mp_ROM1_DO(19),
      DO20 => mp_ROM1_DO(20),
      DO21 => mp_ROM1_DO(21),
      DO22 => mp_ROM1_DO(22),
      DO23 => mp_ROM1_DO(23),
      DO24 => mp_ROM1_DO(24),
      DO25 => mp_ROM1_DO(25),
      DO26 => mp_ROM1_DO(26),
      DO27 => mp_ROM1_DO(27),
      DO28 => mp_ROM1_DO(28),
      DO29 => mp_ROM1_DO(29),
      DO30 => mp_ROM1_DO(30),
      DO31 => mp_ROM1_DO(31),
      DO32 => mp_ROM1_DO(32),
      DO33 => mp_ROM1_DO(33),
      DO34 => mp_ROM1_DO(34),
      DO35 => mp_ROM1_DO(35),
      DO36 => mp_ROM1_DO(36),
      DO37 => mp_ROM1_DO(37),
      DO38 => mp_ROM1_DO(38),
      DO39 => mp_ROM1_DO(39),
      DO40 => mp_ROM1_DO(40),
      DO41 => mp_ROM1_DO(41),
      DO42 => mp_ROM1_DO(42),
      DO43 => mp_ROM1_DO(43),
      DO44 => mp_ROM1_DO(44),
      DO45 => mp_ROM1_DO(45),
      DO46 => mp_ROM1_DO(46),
      DO47 => mp_ROM1_DO(47),
      DO48 => mp_ROM1_DO(48),
      DO49 => mp_ROM1_DO(49),
      DO50 => mp_ROM1_DO(50),
      DO51 => mp_ROM1_DO(51),
      DO52 => mp_ROM1_DO(52),
      DO53 => mp_ROM1_DO(53),
      DO54 => mp_ROM1_DO(54),
      DO55 => mp_ROM1_DO(55),
      DO56 => mp_ROM1_DO(56),
      DO57 => mp_ROM1_DO(57),
      DO58 => mp_ROM1_DO(58),
      DO59 => mp_ROM1_DO(59),
      DO60 => mp_ROM1_DO(60),
      DO61 => mp_ROM1_DO(61),
      DO62 => mp_ROM1_DO(62),
      DO63 => mp_ROM1_DO(63),
      DO64 => mp_ROM1_DO(64),
      DO65 => mp_ROM1_DO(65),
      DO66 => mp_ROM1_DO(66),
      DO67 => mp_ROM1_DO(67),
      DO68 => mp_ROM1_DO(68),
      DO69 => mp_ROM1_DO(69),
      DO70 => mp_ROM1_DO(70),
      DO71 => mp_ROM1_DO(71),
      DO72 => mp_ROM1_DO(72),
      DO73 => mp_ROM1_DO(73),
      DO74 => mp_ROM1_DO(74),
      DO75 => mp_ROM1_DO(75),
      DO76 => mp_ROM1_DO(76),
      DO77 => mp_ROM1_DO(77),
      DO78 => mp_ROM1_DO(78),
      DO79 => mp_ROM1_DO(79),
      CK   => clk_p,
      CS   => mp_ROM1_CS,
      OE   => mp_ROM1_OE
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

---application memories
  ram1 : ram_memory
    generic map (
      g_memory_type => g_memory_type)
    port map (
      clk     => clk_p,
      address => RAM1_A,
      ram_di  => RAM1_DI,
      ram_do  => RAM1_DO,
      we_n    => RAM1_WEB,
      cs      => RAM1_CS);

  ram2 : ram_memory
    generic map (
      g_memory_type => g_memory_type)
    port map (
      clk     => clk_p,
      address => RAM2_A,
      ram_di  => RAM2_DI,
      ram_do  => RAM2_DO,
      we_n    => RAM2_WEB,
      cs      => RAM2_CS);

  ram3 : ram_memory
    generic map (
      g_memory_type => g_memory_type)
    port map (
      clk     => clk_p,
      address => RAM3_A,
      ram_di  => RAM3_DI,
      ram_do  => RAM3_DO,
      we_n    => RAM3_WEB,
      cs      => RAM3_CS);

  ram4 : ram_memory
    generic map (
      g_memory_type => g_memory_type)
    port map (
      clk     => clk_p,
      address => RAM4_A,
      ram_di  => RAM4_DI,
      ram_do  => RAM4_DO,
      we_n    => RAM4_WEB,
      cs      => RAM4_CS);

  -----------------------------------------------------------------------------
  -- Clock generation block
  -----------------------------------------------------------------------------
  clk_gen0 : entity work.clk_gen
    port map (
      --rst_n      => rst_n,
      rst_cn       => rst_cn,
      --pllout     => HCLK,
--      pllout     => tcko,   -- added by HYX, 20141115, for pll test
      --xout       => hclk_i, -- 16.7mhz clk
--      clk_mux_out => clk_mux_out,
      clk_mux_out  => HCLK,
      erxclk       => erxclk,
      etxclk       => etxclk,
--      en_eth     => en_eth,
      --sel_pll    => en_pll,--sel_pll,  to select ref oscillator change sel_pll to en_pll to select suitable clock by maning
      en_d         => en_d,
      fast_d       => fast_d,
      --din_e      => din_e,
      --din_ea     => din_ea,
      din_i        => din_i,
      din_u        => din_u,
      din_s        => din_s,
      din_a        => din_a,
      clk_in_off   => clk_in_off,
      clk_main_off => clk_main_off,
      hold_flash_d => hold_flash_d,
--        en_r          => router_clk_en,       --delete by HYX, 20141027
      clk_p        => clk_p,
      clk_c_en     => clk_c_en,
      even_c       => even_c,
      --clk_c2_pos => clk_c2_pos,
      --clk_e_pos  => clk_e_pos,
      --clk_e_neg  => clk_e_neg,
      --clk_c2a_pos => clk_c2a_pos,
      --clk_ea_pos     => clk_ea_pos,
      --clk_ea_neg     => clk_ea_neg,
      clk_i        => clk_i,
      clk_i_pos    => clk_i_pos,
--        clk_i_r       => clk_i_r,     --delete by HYX, 20141027
--        clk_p_r       => clk_p_r,     --delete by HYX, 20141027
      clk_d        => clk_d,
      clk_d_pos    => clk_d_pos,
      clk_da_pos   => clk_da_pos,
      clk_u_pos    => clk_u_pos,
      clk_s        => MCKOUT0,
      clk_s_pos    => clk_s_pos,
      clk_rx       => clk_rx,
      clk_tx       => clk_tx,
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
      xout          => HCLK,
      pllout        => HCLK,
      sel_pll       => sel_pll,
      xout_selected => xout_selected,
      lp_pwr_ok     => MLP_PWR_OK,
      rxout         => rxout,           -- 32KHz oscillator input         
      mrxout_o      => mrxout_o,  -- 32KHz oscillator output or external wake
      rst_rtc       => rst_rtc,         -- Reset RTC counter byte            
      en_fclk       => en_fclk,   -- Enable fast clocking of RTC counter byte
      fclk          => fclk,            -- Fast clock to RTC counter byte   
      ld_bmem       => ld_bmem,   -- Latch enable to the dis_bmem latch   
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
      clk_mux_out     => clk_mux_out,

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
      bmem_ce_n => bmem_ce_n,
      --RAM0 
      RAM0_DO   => RAM0_DO,
      RAM0_DI   => RAM0_DI,
      RAM0_A    => RAM0_A,
      RAM0_WEB  => RAM0_WEB,
      RAM0_CS   => RAM0_CS
      );

  -- Disable power to BMEM 
  dis_bmem <= dis_bmem_int;
  -----------------------------------------------------------------------------
  -- core
  -----------------------------------------------------------------------------
  core1 : entity work.core
    port map(
      -- Clocks to/from clock block
      clk_p        => clk_p,            --: in  std_logic;  -- PLL clock
      clk_c_en     => clk_c_en,         --: in  std_logic;  -- CP clock
      even_c       => even_c,
      --clk_c2_pos   => clk_c2_pos,  --: in  std_logic;  -- clk_c / 2 
      clk_e_pos    => clk_e_pos,        --: out  std_logic;  -- Execution clock
      clk_e_neg    => clk_e_neg,        --: out  std_logic;  -- Execution clock
      clk_i_pos    => clk_i_pos,        --: in  std_logic;  -- I/O clock
      clk_d_pos    => clk_d_pos,        --: in  std_logic;  -- DRAM clock
      clk_s_pos    => clk_s_pos,        --: in  std_logic;  -- SP clock
      -- Control outputs to the clock block
      rst_n        => rst_n,  --: out std_logic;  -- Asynchronous reset to clk_gen
      rst_cn       => rst_cn,  --: out std_logic;  -- Reset, will hold all clocks except c,rx,tx
      en_d         => en_d,             --: out std_logic;  -- Enable clk_d
      fast_d       => fast_d,  --: out std_logic;  -- clk_d speed select 
      --din_e       => din_e,   --: out std_logic;  -- D input to FF generating clk_e
      din_i        => din_i,  --: out std_logic;  -- D input to FF generating clk_i
      din_u        => din_u,  --: out std_logic;  -- D input to FF generating clk_u
      din_s        => din_s,  --: out std_logic;  -- D input to FF generating clk_s
      clk_in_off   => clk_in_off,
      clk_main_off => clk_main_off,
      sdram_en     => sdram_en,
      --flash Control   -coreflag
      out_line     => out_line,
      hold_flash   => hold_flash,
      hold_flash_d => hold_flash_d,
      flash_en     => flash_en,
      flash_mode   => flash_mode,
      ld_dqi_flash => ld_dqi_flash,
      -- Control signals to/from the oscillator and PLL
      pll_frange   => pll_frange,  --: out std_logic;  -- Frequency range select
      pll_n        => pll_n,  --: out std_logic_vector(5 downto 0);   -- Multiplier
      pll_m        => pll_m,  --: out std_logic_vector(2 downto 0);   -- Divider
      en_xosc      => en_xosc,          --: out std_logic;  -- Enable XOSC 
      en_pll       => en_pll,           --: out std_logic;  -- Enable PLL 
      sel_pll      => sel_pll,  --: out std_logic;  -- Select PLL as clock source
      test_pll     => test_pll,         --: out std_logic;  -- PLL in test mode
      xout         => HCLK,  --: in  std_logic;  -- XOSC ref. clock output -- 16.7 mhz clk
      -- Power on signal
      pwr_ok       => pwr_ok,  --pwr_ok,  --: in  std_logic;  -- Power is on --change by maning to '1'
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
      gmem_ce_n    => c1_gmem_ce_n,   --: out std_logic;                      
      gmem_we_n    => c1_gmem_we_n,   --: out std_logic;                      
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
      idi             => idi,   --: in  std_logic_vector(7 downto 0);     
      idack           => idack,  --: out std_logic_vector(7 downto 0);                   
      ios_iden        => ios_iden,      --: out std_logic;                   
      ios_ido         => ios_ido,  --: out std_logic_vector(7 downto 0);                  
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
      ddqm            => ddqm,  --: out std_logic_vector(7  downto 0);   
      irq0            => irq0,  --: in  std_logic;  -- Interrupt request 0   
      irq1            => irq1,  --: in  std_logic;  -- Interrupt request 1   
      adc_ref2v       => adc_ref2v,  --: out  std_logic;      -- Select 2V internal ADC reference (1V)
---------------------------------------------------------------------
      -- PADS
---------------------------------------------------------------------
      -- Misc. signals
      --mpordis_i     => '1',--MPORDIS, --: in  std_logic;  -- 'power on' from pad
      mreset_i        => mreset_i,  --: in  std_logic;  -- Asynchronous reset input 
      mirqout_o       => MIRQOUT,  --: out std_logic;  -- Interrupt  request output 
      mckout1_o       => MCKOUT1,  --: out std_logic;  -- Programmable clock out
      mckout1_o_en    => mckout1_en,
      msdin_i         => msdin_i,  --: in  std_logic;  -- Serial data in (debug) 
      msdout_o        => MSDOUT,      --: out std_logic;  -- Serial data out
      mrstout_o       => MRSTOUT,     --: out std_logic;  -- Reset out
      --mxout_o         => mxout_o,  --: out std_logic;  -- Oscillator test output
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
      ROM1_DO  => mp_ROM1_DO,   --: in  std_logic_vector (79 downto 0); 
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
      --ROM0
      f_addr_in   => f_addr_in,
      f_rd_in     => f_rd_in,
      f_wr_in     => f_wr_in,
      f_data_in   => f_data_in,
      f_data_out  => f_data_out,
      --SRAM interface
      --RAM0 
      RAM0_DO     => RAM0_DO,
      RAM0_DI     => RAM0_DI,
      RAM0_A      => RAM0_A,
      RAM0_WEB    => RAM0_WEB,
      RAM0_CS     => RAM0_CS,
      --RAM1        => --RAM1          ,
      RAM1_DO     => RAM1_DO,
      RAM1_DI     => RAM1_DI,
      RAM1_A      => RAM1_A,
      RAM1_WEB    => RAM1_WEB,
      RAM1_CS     => RAM1_CS,
      --RAM2        => --RAM2          ,
      RAM2_DO     => RAM2_DO,
      RAM2_DI     => RAM2_DI,
      RAM2_A      => RAM2_A,
      RAM2_WEB    => RAM2_WEB,
      RAM2_CS     => RAM2_CS,
      --RAM3        => --RAM3          ,
      RAM3_DO     => RAM3_DO,
      RAM3_DI     => RAM3_DI,
      RAM3_A      => RAM3_A,
      RAM3_WEB    => RAM3_WEB,
      RAM3_CS     => RAM3_CS,
      --RAM4        => --RAM4          --,
      RAM4_DO     => RAM4_DO,
      RAM4_DI     => RAM4_DI,
      RAM4_A      => RAM4_A,
      RAM4_WEB    => RAM4_WEB,
      RAM4_CS     => RAM4_CS
      );

  --flash interface
  flash_inf_inst : entity work.flash_inf
    port map(
      clk_p  => clk_p,
      even_c => even_c,
      rst_cn => rst_n,

      flash_en     => flash_en,
      flash_mode   => flash_mode,
      out_line     => out_line,
      hold_flash   => hold_flash,
      hold_flash_d => hold_flash_d,

      addr_in      => f_addr_in,
      rd_in        => f_rd_in,
      wr_in        => f_wr_in,
      data_in      => f_data_in,
      data_out     => f_data_out,
      ld_dqi_flash => ld_dqi_flash,

      CE         => f_CE,
      ADDR       => f_ADDR,
      WRONLY     => f_WRONLY,
      PERASE     => f_PERASE,
      SERASE     => f_SERASE,
      MERASE     => f_MERASE,
      PROG       => f_PROG,
      INF        => f_INF,
      POR        => f_POR,
      SAVEN      => f_SAVEN,
      TM         => f_TM,
      DATA_WR    => f_DATA_WR,
      f0_ALE     => f0_ALE,
      --f0_PVPP   => --f0_PVPP   ,
      f0_DATA_IN => f0_DATA_IN,
      f0_RBB     => f0_RBB,
      f1_ALE     => f1_ALE,
      --f1_PVPP   => --f1_PVPP   ,
      f1_DATA_IN => f1_DATA_IN,
      f1_RBB     => f1_RBB,
      f2_ALE     => f2_ALE,
      --f2_PVPP   => --f2_PVPP   ,
      f2_DATA_IN => f2_DATA_IN,
      f2_RBB     => f2_RBB,
      f3_ALE     => f3_ALE,
      --f3_PVPP   => --f3_PVPP   ,
      f3_DATA_IN => f3_DATA_IN,
      f3_RBB     => f3_RBB              --,
--        f4_ALE      => f4_ALE      ,
--        --f4_PVPP   => --f4_PVPP   ,
--        f4_DATA_IN  => f4_DATA_IN  ,       
--        f4_RBB      => f4_RBB      ,
--        f5_ALE      => f5_ALE      ,
--        --f5_PVPP   => --f5_PVPP   ,
--        f5_DATA_IN  => f5_DATA_IN  ,       
--        f5_RBB      => f5_RBB      ,
--        f6_ALE      => f6_ALE      ,
--        --f6_PVPP   => --f6_PVPP   ,
--        f6_DATA_IN  => f6_DATA_IN  ,       
--        f6_RBB      => f6_RBB      ,
--        f7_ALE      => f7_ALE      ,
--        --f7_PVPP   => --f7_PVPP   ,
--        f7_DATA_IN  => f7_DATA_IN  ,       
--        f7_RBB      => f7_RBB      

      );


  -----------------------------------------------------------------------------
  -- Peripherals
  -----------------------------------------------------------------------------

  peri01 : entity work.peri
    generic map (
      g_build_type => g_memory_type)
    port map(
      clk_p      => clk_p,
      clk_c_en   => clk_c_en,
      clk_e_pos  => clk_e_pos,
      clk_e_neg  => clk_e_neg,
      clk_i      => clk_i,
      clk_i_pos  => clk_i_pos,
      clk_u_pos  => clk_u_pos,
      clk_rx     => clk_rx,
      clk_tx     => clk_tx,
      clk_a_pos  => clk_a_pos,
      erxclk     => erxclk,
      etxclk     => etxclk,
      din_a      => din_a,
      dbus       => dbus,
      dfp        => dfp,
      rst_en     => rst_en,
      --rst_en2     => rst_en2,
      pl_pd      => pd_s,
      pl_aaddr   => aaddr,
      idack      => idack,
      ios_iden   => ios_iden,
      ios_ido    => ios_ido,
      ilioa      => ilioa,
      ildout     => ildout,
      inext      => inext,
      iden       => iden,
      --dqm_size      => dqm_size,
      en_uart1   => en_uart1,
      en_uart2   => en_uart2,
      en_uart3   => en_uart3,
      en_eth     => en_eth,
      en_tiu     => en_tiu,
      run_tiu    => run_tiu,
      en_iobus   => en_iobus,
      --ddqm          => ddqm,
      idreq      => idreq,
      idi        => idi,
      irq0       => irq0,
      irq1       => irq1,
      tstamp     => tstamp,
      tiu_tstamp => tiu_tstamp,
      ach_sel    => ach_sel,
      --adc_bits      => '0',--adc_bits,
      adc_bits   => adc_bits_int,       -- modified by HYX, 20141205
      adc_extref => adc_extref,
      adc_diff   => adc_diff,
      adc_en     => adc_en,
      dac_bits   => dac_bits,
      dac_en     => dac_en,
      mirq0_i    => mirq0_i,
      mirq1_i    => mirq1_i,
      pa_i       => pa_i,
      pa_en      => pa_en,
      pa_o       => pa_o,
      pb_i       => pb_i,
      pb_en      => pb_en,
      pb_o       => pb_o,
      pc_i       => pc_i,
      pc_en      => pc_en,
      pc_o       => pc_o,
      pd_i       => pd_i,
      pd_en      => pd_en,
      pd_o       => pd_o,
      pe_i       => pe_i,
      pe_en      => pe_en,
      pe_o       => pe_o,
      pf_i       => pf_i,
      pf_en      => pf_en,
      pf_o       => pf_o,
      pg_i       => pg_i,
      pg_en      => pg_en,
      pg_o       => pg_o,
      ph_i       => ph_i_from_iopads,
      ph_en      => ph_en_to_iopads,
      ph_o       => ph_o_to_iopads,
      pi_i       => pi_i,
      pi_en      => pi_en,
      pi_o       => pi_o,
      pj_i       => pj_i,
      pj_en      => pj_en,
      pj_o       => pj_o,
      OSPI_Out   => OSPI_Out,
      OSPI_DQ_i  => OSPI_DQ_i,
      OSPI_DQ_o  => OSPI_DQ_o,
      OSPI_DQ_e  => OSPI_DQ_e,
      OSPI_RWDS_i => OSPI_RWDS_i,
      OSPI_RWDS_o => OSPI_RWDS_o,
      OSPI_RWDS_e => OSPI_RWDS_e
      );

end;
