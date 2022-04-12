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
-- Title      : iopads
-- Project    : 
-------------------------------------------------------------------------------
-- File       : iopads.vhd
-- Author     : Ning Ma
-- Company    : 
-- Date       : 
-------------------------------------------------------------------------------
-- Description: iopads
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date                                 Version         Author  Description
-- 2012-07-11                           1.07            MN      iopads
-- 2013-01-17                           2.0             MN      for dual core 65 nm technology
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--library foa0a_o_t33_generic_cd_io;
--use foa0a_o_t33_generic_cd_io.VTABLES.all;
use work.all;

entity iopads is
  port (
    -- clocks and control signals   always on!!!!
    HCLK       : in  std_logic;         -- clk input
    MPMIC_CORE : out std_logic;
    MPMIC_IO   : out std_logic;
    --
    MRESET     : in  std_logic;         -- system reset               
    MIRQOUT    : out std_logic;         -- interrupt request output    
    MCKOUT0    : out std_logic;         --for trace adapter
    MCKOUT1    : out std_logic;
    MTEST      : in  std_logic;
    MBYPASS    : in  std_logic;
    MIRQ0      : in  std_logic;
    MIRQ1      : in  std_logic;
    -- SW debug                                                               
    MSDIN      : in  std_logic;         -- serial data in (debug)     
    MSDOUT     : out std_logic;         -- serial data out    

    -- SDRAM interface (41 bits)
    D_CLK : out   std_logic;                     --clock to SDRAM
    D_CS  : out   std_logic;                     -- CS to SDRAM
    D_RAS : out   std_logic;                     -- RAS to SDRAM
    D_CAS : out   std_logic;                     -- CAS to SDRAM
    D_WE  : out   std_logic;                     -- WE to SDRAM
    D_DQ  : inout std_logic_vector(7 downto 0);  -- Data
    D_DQM : out   std_logic_vector(7 downto 0);  -- Data
    D_A   : out   std_logic_vector(13 downto 0);
    D_BA  : out   std_logic_vector(1 downto 0);
    D_CKE : out   std_logic_vector(3 downto 0);

    -- Ports
    PA : inout std_logic_vector(7 downto 0);  -- port A 
    PB : inout std_logic_vector(7 downto 0);  -- port B 
    PC : inout std_logic_vector(7 downto 0);  -- port C 
    PD : inout std_logic_vector(7 downto 0);  -- port D /DDQM, connect to TYA(7..0) and to DDQM(7..0)
    PE : inout std_logic_vector(7 downto 0);
    PF : inout std_logic_vector(7 downto 0);  -- port F ethernet 1
    PG : inout std_logic_vector(7 downto 0);  -- added by HYX, 20141115
    PH : inout std_logic_vector(7 downto 0);  -- port H /DMA ctrl
    PI : inout std_logic_vector(7 downto 0);  -- port I /ID
    PJ : inout std_logic_vector(7 downto 0);  -- port J /I/O ctrl, UART1, connect to I/O ctrl, DRAS(3..0)

    --sdram interface
    sdram_en    : in  std_logic;        -- sdram enable
    sd_clk      : in  std_logic;        --clock to SDRAM
    sd_cs       : in  std_logic;        -- CS to SDRAM
    sd_ras      : in  std_logic;        -- RAS to SDRAM
    sd_cas      : in  std_logic;        -- CAS to SDRAM
    sd_we       : in  std_logic;        -- WE to SDRAM
    sd_dqi      : out std_logic_vector(7 downto 0);  -- Data in from SDRAM
    sd_dqo      : in  std_logic_vector(7 downto 0);  -- Data out to SDRAM
    sd_en_dqo   : in  std_logic;        -- Output enable to SDRAM data bus
    sd_dqm      : in  std_logic_vector(7 downto 0);
    sd_a        : in  std_logic_vector(13 downto 0);
    sd_ba       : in  std_logic_vector(1 downto 0);
    sd_cke      : in  std_logic_vector(3 downto 0);
    --test clock signals Output
    rtc_clk_tst : in  std_logic;
    clk_p_tst   : in  std_logic;
    clk_c_tst   : in  std_logic;
    clk_c2_tst  : in  std_logic;
    clk_e_tst   : in  std_logic;
    clk_c2a_tst : in  std_logic;
    clk_ea_tst  : in  std_logic;
    --to other module
    mreset_i    : out std_logic;
    mtest_i     : out std_logic;
    mirq0_i     : out std_logic;
    mirq1_i     : out std_logic;
    msdin_i     : out std_logic;

    mirqout_o    : in  std_logic;
    mckout0_o    : in  std_logic;
    mckout1_o    : in  std_logic;
    mckout1_o_en : in  std_logic;
    mbypass_i    : out std_logic;
    msdout_o     : in  std_logic;

    -- low power mode pad
    pmic_core_en : in  std_logic;
    pmic_io_en   : in  std_logic;
    io_iso       : in  std_logic;

    pa_i  : out std_logic_vector(7 downto 0);
    pa_en : in  std_logic_vector(7 downto 0);
    pa_o  : in  std_logic_vector(7 downto 0);
    pb_i  : out std_logic_vector(7 downto 0);
    pb_en : in  std_logic_vector(7 downto 0);
    pb_o  : in  std_logic_vector(7 downto 0);
    pc_i  : out std_logic_vector(7 downto 0);
    pc_en : in  std_logic_vector(7 downto 0);
    pc_o  : in  std_logic_vector(7 downto 0);
    pd_i  : out std_logic_vector(7 downto 0);
    pd_en : in  std_logic_vector(7 downto 0);
    pd_o  : in  std_logic_vector(7 downto 0);
    pe_i  : out std_logic_vector(7 downto 0);
    pe_en : in  std_logic_vector(7 downto 0);
    pe_o  : in  std_logic_vector(7 downto 0);
    pf_i  : out std_logic_vector(7 downto 0);
    pf_en : in  std_logic_vector(7 downto 0);
    pf_o  : in  std_logic_vector(7 downto 0);
    pg_i  : out std_logic_vector(7 downto 0);
    pg_en : in  std_logic_vector(7 downto 0);
    pg_o  : in  std_logic_vector(7 downto 0);
    ph_i  : out std_logic_vector(7 downto 0);
    ph_en : in  std_logic_vector(7 downto 0);
    ph_o  : in  std_logic_vector(7 downto 0);
    pi_i  : out std_logic_vector(7 downto 0);
    pi_en : in  std_logic_vector(7 downto 0);
    pi_o  : in  std_logic_vector(7 downto 0);
    pj_i  : out std_logic_vector(7 downto 0);
    pj_en : in  std_logic_vector(7 downto 0);
    pj_o  : in  std_logic_vector(7 downto 0);
    -- I/O cell configuration control outputs
    d_hi  : in  std_logic;  -- High drive on DRAM interface, now used for other outputs
    d_sr  : in  std_logic;              -- Slew rate limit on DRAM interface
    d_lo  : in  std_logic;              -- Low drive on DRAM interface
    p1_hi : in  std_logic;              -- High drive on port group 1 pins
    p1_sr : in  std_logic;              -- Slew rate limit on port group 1 pins
    p2_hi : in  std_logic;              -- High drive on port group 2 pins
    p2_sr : in  std_logic;              -- Slew rate limit on port group 2 pins
    p3_hi : in  std_logic;              -- High drive on port group 3 pins
    p3_sr : in  std_logic);             -- Slew rate limit on port group 3 pins



end iopads;

architecture struct of iopads is
  --pads added by HYX       
  --bi-directional   3.3V
  component ZMA2GSD
    port
      (
        O   : out   std_logic;
        I   : in    std_logic;
        IO  : inout std_logic;
        E   : in    std_logic;
        E2  : in    std_logic;
        E4  : in    std_logic;
        E8  : in    std_logic;
        SR  : in    std_logic;
        PU  : in    std_logic;
        PD  : in    std_logic;
        SMT : in    std_logic
        );
  end component;

  component YA2GSD
    port
      (
        O  : out std_logic;
        I  : in  std_logic;
        E  : in  std_logic;
        E2 : in  std_logic;
        E4 : in  std_logic;
        E8 : in  std_logic;
        SR : in  std_logic
        );
  end component;

  component XMD
    port
      (
        O   : out std_logic;
        I   : in  std_logic;
        PU  : in  std_logic;
        PD  : in  std_logic;
        SMT : in  std_logic
        );
  end component;

  signal sd_dqi_int    : std_logic_vector (7 downto 0);
  signal pa_oen        : std_logic_vector (7 downto 0);  --output enable
  signal pb_oen        : std_logic_vector (7 downto 0);
  signal pc_oen        : std_logic_vector (7 downto 0);
  signal pd_oen        : std_logic_vector (7 downto 0);
  signal pe_oen        : std_logic_vector (7 downto 0);
  signal pf_oen        : std_logic_vector (7 downto 0);
  signal pg_oen        : std_logic_vector (7 downto 0);
  signal ph_oen        : std_logic_vector (7 downto 0);
  signal pi_oen        : std_logic_vector (7 downto 0);
  signal pj_oen        : std_logic_vector (7 downto 0);
  signal pa_d_i        : std_logic_vector (7 downto 0);
  signal pa_d_o        : std_logic_vector (7 downto 0);
  signal pb_d_i        : std_logic_vector (7 downto 0);
  signal pb_d_o        : std_logic_vector (7 downto 0);
  signal pc_d_i        : std_logic_vector (7 downto 0);
  signal pc_d_o        : std_logic_vector (7 downto 0);
  signal pd_d_i        : std_logic_vector (7 downto 0);
  signal pd_d_o        : std_logic_vector (7 downto 0);
  signal pe_d_i        : std_logic_vector (7 downto 0);
  signal pe_d_o        : std_logic_vector (7 downto 0);
  signal pf_d_i        : std_logic_vector (7 downto 0);
  signal pf_d_o        : std_logic_vector (7 downto 0);
  signal pg_d_i        : std_logic_vector (7 downto 0);
  signal pg_d_o        : std_logic_vector (7 downto 0);
  signal ph_d_i        : std_logic_vector (7 downto 0);
  signal ph_d_o        : std_logic_vector (7 downto 0);
  signal pi_d_i        : std_logic_vector (7 downto 0);
  signal pi_d_o        : std_logic_vector (7 downto 0);
  signal pj_d_i        : std_logic_vector (7 downto 0);
  signal pj_d_o        : std_logic_vector (7 downto 0);
begin
  --input pads

  --reset signal, PU
  mreset_i <= MRESET or io_iso;
  
  --test signal,  PD
    mtest_i <= MTEST and (not io_iso);
  --pll bypass signal
  mbypass_i <= MBYPASS and (not io_iso);
  --irq signal, PU
  mirq0_i <= MIRQ0 or io_iso;
  mirq1_i <= MIRQ1 or io_iso;
  --msdin signal, PU
  msdin_i <= MSDIN or io_iso;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  --output pads
  -----------------------------------------------------------------------------


  -- DRAM PADS 
  gen_sdram_pad_d_a : for i in 0 to 13 generate
    D_A_inst : YA2GSD port map
      (O => D_A(i), I => sd_a(i), E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);
  end generate gen_sdram_pad_d_a;

  gen_sdram_pad_d_ba : for i in 0 to 1 generate
    D_BA_inst : YA2GSD port map
      (O => D_BA(i), I => sd_ba(i), E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);
  end generate gen_sdram_pad_d_ba;

  gen_sdram_pad_d_cke : for i in 0 to 3 generate
    D_CKE_inst : YA2GSD port map
      (O => D_CKE(i), I => sd_cke(i), E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);
  end generate gen_sdram_pad_d_cke;

  gen_sdram_pad_d_dqm : for i in 0 to 7 generate
    D_DQM_inst : YA2GSD port map
      (O => D_DQM(i), I => sd_dqm(i), E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);
  end generate gen_sdram_pad_d_dqm;

  D_CLK_inst : YA2GSD port map
    (O => D_CLK, I => sd_clk, E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  D_CS_inst : YA2GSD port map
    (O => D_CS, I => sd_cs, E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  D_RAS_inst : YA2GSD port map
    (O => D_RAS, I => sd_ras, E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  D_CAS_inst : YA2GSD port map
    (O => D_CAS, I => sd_cas, E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  D_WE_inst : YA2GSD port map
    (O => D_WE, I => sd_we, E => sdram_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);
-- END DRAM_PADS

  MIRQOUT_inst : YA2GSD port map
    (O => MIRQOUT, I => mirqout_o, E => '1', E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  MCKOUT0_inst : YA2GSD port map
    (O => MCKOUT0, I => mckout0_o, E => '1', E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  MCKOUT1_inst : YA2GSD port map
    (O => MCKOUT1, I => mckout1_o, E => mckout1_o_en, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  MSDOUT_inst : YA2GSD port map
    (O => MSDOUT, I => msdout_o, E => '1', E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  MPMIC_CORE_inst : YA2GSD port map
    (O => MPMIC_CORE, I => pmic_core_en, E => '1', E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);

  MPMIC_IO_inst : YA2GSD port map
    (O => MPMIC_IO, I => pmic_io_en, E => '1', E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr);
  -- Ports
--------------PA-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------

--*****************************************************
  pa_oen(0) <= pa_en(0);                --modified by HYX, 20141027
  pa_oen(1) <= pa_en(1);
  pa_oen(2) <= pa_en(2);
  pa_oen(3) <= pa_en(3);
  pa_oen(4) <= pa_en(4);
  pa_oen(5) <= pa_en(5);
  pa_oen(6) <= pa_en(6);
  pa_oen(7) <= pa_en(7);

  pa_d_o(0) <= pa_o(0);
  pa_d_o(1) <= pa_o(1);
  pa_d_o(2) <= pa_o(2);
  pa_d_o(3) <= pa_o(3);
  pa_d_o(4) <= pa_o(4);
  pa_d_o(5) <= pa_o(5);
  pa_d_o(6) <= pa_o(6);                 --modified by HYX, 20141027
  pa_d_o(7) <= pa_o(7);                 --modified by HYX, 20141027
  --*****************************************************


  pa_i(0) <= pa_d_i(0);
  pa_i(1) <= pa_d_i(1);
  pa_i(2) <= pa_d_i(2);
  pa_i(3) <= pa_d_i(3);
  pa_i(4) <= pa_d_i(4);
  pa_i(5) <= pa_d_i(5);
  pa_i(6) <= pa_d_i(6);
  pa_i(7) <= pa_d_i(7);

------------PB--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------

--*****************************************************
  pb_oen(0) <= pb_en(0);                --modified by HYX, 20141115
  pb_oen(1) <= pb_en(1);
  pb_oen(2) <= pb_en(2);
  pb_oen(3) <= pb_en(3);
  pb_oen(4) <= pb_en(4);
  pb_oen(5) <= pb_en(5);
  pb_oen(6) <= pb_en(6);
  pb_oen(7) <= pb_en(7);

  pb_d_o(0) <= pb_o(0);
  pb_d_o(1) <= pb_o(1);
  pb_d_o(2) <= pb_o(2);
  pb_d_o(3) <= pb_o(3);
  pb_d_o(4) <= pb_o(4);
  pb_d_o(5) <= pb_o(5);
  pb_d_o(6) <= pb_o(6);
  pb_d_o(7) <= pb_o(7);
--*****************************************************

  pb_i(0) <= pb_d_i(0);
  pb_i(1) <= pb_d_i(1);
  pb_i(2) <= pb_d_i(2);
  pb_i(3) <= pb_d_i(3);
  pb_i(4) <= pb_d_i(4);
  pb_i(5) <= pb_d_i(5);
  pb_i(6) <= pb_d_i(6);
  pb_i(7) <= pb_d_i(7);

--------------PC-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--*****************************************************
  pc_oen(0) <= pc_en(0);                --modified by HYX, 20141115
  pc_oen(1) <= pc_en(1);
  pc_oen(2) <= pc_en(2);
  pc_oen(3) <= pc_en(3);
  pc_oen(4) <= pc_en(4);
  pc_oen(5) <= pc_en(5);
  pc_oen(6) <= pc_en(6);
  pc_oen(7) <= pc_en(7);

  pc_d_o(0) <= pc_o(0);                 --modified by HYX, 20141115
  pc_d_o(1) <= pc_o(1);
  pc_d_o(2) <= pc_o(2);
  pc_d_o(3) <= pc_o(3);
  pc_d_o(4) <= pc_o(4);
  pc_d_o(5) <= pc_o(5);
  pc_d_o(6) <= pc_o(6);
  pc_d_o(7) <= pc_o(7);
--*****************************************************

  pc_i(0)   <= pc_d_i(0);
  pc_i(1)   <= pc_d_i(1);
  pc_i(2)   <= pc_d_i(2);
  pc_i(3)   <= pc_d_i(3);
  pc_i(4)   <= pc_d_i(4);
  pc_i(5)   <= pc_d_i(5);
  pc_i(6)   <= pc_d_i(6);
  pc_i(7)   <= pc_d_i(7);
-------------PD--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--*****************************************************
  pd_oen(0) <= pd_en(0);                --modified by HYX, 20141027
  pd_oen(1) <= pd_en(1);
  pd_oen(2) <= pd_en(2);
  pd_oen(3) <= pd_en(3);
  pd_oen(4) <= pd_en(4);
  pd_oen(5) <= pd_en(5);
  pd_oen(6) <= pd_en(6);
  pd_oen(7) <= pd_en(7);

  pd_d_o(0) <= pd_o(0);                 --modified by HYX, 20141027
  pd_d_o(1) <= pd_o(1);
  pd_d_o(2) <= pd_o(2);
  pd_d_o(3) <= pd_o(3);
  pd_d_o(4) <= pd_o(4);
  pd_d_o(5) <= pd_o(5);
  pd_d_o(6) <= pd_o(6);
  pd_d_o(7) <= pd_o(7);
--*****************************************************

  pd_i(0)   <= pd_d_i(0);
  pd_i(1)   <= pd_d_i(1);
  pd_i(2)   <= pd_d_i(2);
  pd_i(3)   <= pd_d_i(3);
  pd_i(4)   <= pd_d_i(4);
  pd_i(5)   <= pd_d_i(5);
  pd_i(6)   <= pd_d_i(6);
  pd_i(7)   <= pd_d_i(7);
-------------PE--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--*****************************************************
  pe_oen(0) <= pe_en(0);                --modified by HYX, 20141115
  pe_oen(1) <= pe_en(1);
  pe_oen(2) <= pe_en(2);
  pe_oen(3) <= pe_en(3);
  pe_oen(4) <= pe_en(4);
  pe_oen(5) <= pe_en(5);
  pe_oen(6) <= pe_en(6);
  pe_oen(7) <= pe_en(7);

  pe_d_o(0) <= pe_o(0);
  pe_d_o(1) <= pe_o(1);
  pe_d_o(2) <= pe_o(2);
  pe_d_o(3) <= pe_o(3);
  pe_d_o(4) <= pe_o(4);
  pe_d_o(5) <= pe_o(5);
  pe_d_o(6) <= pe_o(6);
  pe_d_o(7) <= pe_o(7);
--***************************************************** 
  pe_i(0)   <= pe_d_i(0);
  pe_i(1)   <= pe_d_i(1);
  pe_i(2)   <= pe_d_i(2);
  pe_i(3)   <= pe_d_i(3);
  pe_i(4)   <= pe_d_i(4);
  pe_i(5)   <= pe_d_i(5);
  pe_i(6)   <= pe_d_i(6);
  pe_i(7)   <= pe_d_i(7);


--------------PF----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--*****************************************************
  pf_oen(0) <= pf_en(0);                --modified by HYX, 20141115
  pf_oen(1) <= pf_en(1);
  pf_oen(2) <= pf_en(2);
  pf_oen(3) <= pf_en(3);
  pf_oen(4) <= pf_en(4);
  pf_oen(5) <= pf_en(5);
  pf_oen(6) <= pf_en(6);
  pf_oen(7) <= pf_en(7);

  pf_d_o(0) <= pf_o(0);
  pf_d_o(1) <= pf_o(1);
  pf_d_o(2) <= pf_o(2);
  pf_d_o(3) <= pf_o(3);
  pf_d_o(4) <= pf_o(4);
  pf_d_o(5) <= pf_o(5);
  pf_d_o(6) <= pf_o(6);
  pf_d_o(7) <= pf_o(7);
--*****************************************************

  pf_i(0) <= pf_d_i(0);
  pf_i(1) <= pf_d_i(1);
  pf_i(2) <= pf_d_i(2);
  pf_i(3) <= pf_d_i(3);
  pf_i(4) <= pf_d_i(4);
  pf_i(5) <= pf_d_i(5);
  pf_i(6) <= pf_d_i(6);
  pf_i(7) <= pf_d_i(7);

--------------PG----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------  

--*****************************************************
  pg_oen(0) <= pg_en(0);                --added by HYX, 20141115
  pg_oen(1) <= pg_en(1);
  pg_oen(2) <= pg_en(2);
  pg_oen(3) <= pg_en(3);
  pg_oen(4) <= pg_en(4);
  pg_oen(5) <= pg_en(5);
  pg_oen(6) <= pg_en(6);
  pg_oen(7) <= pg_en(7);

  pg_d_o(0) <= pg_o(0);
  pg_d_o(1) <= pg_o(1);
  pg_d_o(2) <= pg_o(2);
  pg_d_o(3) <= pg_o(3);
  pg_d_o(4) <= pg_o(4);
  pg_d_o(5) <= pg_o(5);
  pg_d_o(6) <= pg_o(6);
  pg_d_o(7) <= pg_o(7);

--*****************************************************

  pg_i(0) <= pg_d_i(0);
  pg_i(1) <= pg_d_i(1);
  pg_i(2) <= pg_d_i(2);
  pg_i(3) <= pg_d_i(3);
  pg_i(4) <= pg_d_i(4);
  pg_i(5) <= pg_d_i(5);
  pg_i(6) <= pg_d_i(6);
  pg_i(7) <= pg_d_i(7);
--------------PH----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------

  ph_oen(0) <= '1' when MTEST = '1' else ph_en(0);
  ph_oen(1) <= '1' when MTEST = '1' else ph_en(1);
  ph_oen(2) <= '1' when MTEST = '1' else ph_en(2);
  ph_oen(3) <= '1' when MTEST = '1' else ph_en(3);
  ph_oen(4) <= '1' when MTEST = '1' else ph_en(4);
  ph_oen(5) <= '1' when MTEST = '1' else ph_en(5);
  ph_oen(6) <= '1' when MTEST = '1' else ph_en(6);
  ph_oen(7) <= '1' when MTEST = '1' else ph_en(7);  --modified by HYX, 20141115

  ph_d_o(0) <= rtc_clk_tst when MTEST = '1' else ph_o(0);
  ph_d_o(1) <= HCLK        when MTEST = '1' else ph_o(1);
  ph_d_o(2) <= clk_p_tst   when MTEST = '1' else ph_o(2);
  ph_d_o(3) <= clk_c_tst   when MTEST = '1' else ph_o(3);
  ph_d_o(4) <= clk_c2_tst  when MTEST = '1' else ph_o(4);
  ph_d_o(5) <= clk_e_tst   when MTEST = '1' else ph_o(5);
  ph_d_o(6) <= clk_c2a_tst when MTEST = '1' else ph_o(6);
  ph_d_o(7) <= clk_ea_tst  when MTEST = '1' else ph_o(7);  --modified by HYX, 20141115


  ph_i(0) <= ph_d_i(0);
  ph_i(1) <= ph_d_i(1);
  ph_i(2) <= ph_d_i(2);
  ph_i(3) <= ph_d_i(3);
  ph_i(4) <= ph_d_i(4);
  ph_i(5) <= ph_d_i(5);
  ph_i(6) <= ph_d_i(6);
  ph_i(7) <= ph_d_i(7);
--------------PI----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------

--***************************************************** 
  pi_oen(0) <= pi_en(0);                --modified by HYX, 20141027
  pi_oen(1) <= pi_en(1);
  pi_oen(2) <= pi_en(2);
  pi_oen(3) <= pi_en(3);
  pi_oen(4) <= pi_en(4);
  pi_oen(5) <= pi_en(5);
  pi_oen(6) <= pi_en(6);
  pi_oen(7) <= pi_en(7);

  pi_d_o(0) <= pi_o(0);                 --modified by HYX, 20141027
  pi_d_o(1) <= pi_o(1);
  pi_d_o(2) <= pi_o(2);
  pi_d_o(3) <= pi_o(3);
  pi_d_o(4) <= pi_o(4);
  pi_d_o(5) <= pi_o(5);
  pi_d_o(6) <= pi_o(6);
  pi_d_o(7) <= pi_o(7);
--*****************************************************

  pi_i(0)   <= pi_d_i(0);
  pi_i(1)   <= pi_d_i(1);
  pi_i(2)   <= pi_d_i(2);
  pi_i(3)   <= pi_d_i(3);
  pi_i(4)   <= pi_d_i(4);
  pi_i(5)   <= pi_d_i(5);
  pi_i(6)   <= pi_d_i(6);
  pi_i(7)   <= pi_d_i(7);
--------------PJ-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--*****************************************************
  pj_oen(0) <= pj_en(0);                --modified by HYX, 20141027
  pj_oen(1) <= pj_en(1);
  pj_oen(2) <= pj_en(2);
  pj_oen(3) <= pj_en(3);
  pj_oen(4) <= pj_en(4);
  pj_oen(5) <= pj_en(5);
  pj_oen(6) <= pj_en(6);
  pj_oen(7) <= pj_en(7);

  pj_d_o(0) <= pj_o(0);                 --modified by HYX, 20141027
  pj_d_o(1) <= pj_o(1);
  pj_d_o(2) <= pj_o(2);
  pj_d_o(3) <= pj_o(3);
  pj_d_o(4) <= pj_o(4);
  pj_d_o(5) <= pj_o(5);
  pj_d_o(6) <= pj_o(6);
  pj_d_o(7) <= pj_o(7);
--*****************************************************

  pj_i(0) <= pj_d_i(0);
  pj_i(1) <= pj_d_i(1);
  pj_i(2) <= pj_d_i(2);
  pj_i(3) <= pj_d_i(3);
  pj_i(4) <= pj_d_i(4);
  pj_i(5) <= pj_d_i(5);
  pj_i(6) <= pj_d_i(6);
  pj_i(7) <= pj_d_i(7);
---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
  gen_bi_io : for i in 0 to 7 generate

    PA_inst : ZMA2GSD port map
      (O => pa_d_i(i), I => pa_d_o(i), IO => PA(i), E => pa_oen(i), E2 => p2_hi, E4 => p2_hi, E8 => p2_hi, SR => p2_sr, PU => '0', PD => '0', SMT => '0');

    PB_inst : ZMA2GSD port map
      (O => pb_d_i(i), I => pb_d_o(i), IO => PB(i), E => pb_oen(i), E2 => p3_hi, E4 => p3_hi, E8 => p3_hi, SR => p3_sr, PU => '0', PD => '0', SMT => '0');

    PC_inst : ZMA2GSD port map
      (O => pc_d_i(i), I => pc_d_o(i), IO => PC(i), E => pc_oen(i), E2 => p1_hi, E4 => p1_hi, E8 => p1_hi, SR => p1_sr, PU => '0', PD => '0', SMT => '0');

    PD_inst : ZMA2GSD port map
      (O => pd_d_i(i), I => pd_d_o(i), IO => PD(i), E => pd_oen(i), E2 => p2_hi, E4 => p2_hi, E8 => p2_hi, SR => p2_sr, PU => '0', PD => '0', SMT => '0');

    PE_inst : ZMA2GSD port map
      (O => pe_d_i(i), I => pe_d_o(i), IO => PE(i), E => pe_oen(i), E2 => p2_hi, E4 => p2_hi, E8 => p2_hi, SR => p2_sr, PU => '0', PD => '0', SMT => '0');

    PF_inst : ZMA2GSD port map
      (O => pf_d_i(i), I => pf_d_o(i), IO => PF(i), E => pf_oen(i), E2 => p3_hi, E4 => p3_hi, E8 => p3_hi, SR => p3_sr, PU => '0', PD => '0', SMT => '0');

    PG_inst : ZMA2GSD port map
      (O => pg_d_i(i), I => pg_d_o(i), IO => PG(i), E => pg_oen(i), E2 => p3_hi, E4 => p3_hi, E8 => p3_hi, SR => p3_sr, PU => '0', PD => '0', SMT => '0');

    PH_inst : ZMA2GSD port map
      (O => ph_d_i(i), I => ph_d_o(i), IO => PH(i), E => ph_oen(i), E2 => p1_hi, E4 => p1_hi, E8 => p1_hi, SR => p1_sr, PU => '0', PD => '0', SMT => '0');

    PI_inst : ZMA2GSD port map
      (O => pi_d_i(i), I => pi_d_o(i), IO => PI(i), E => pi_oen(i), E2 => p1_hi, E4 => p1_hi, E8 => p1_hi, SR => p1_sr, PU => '0', PD => '0', SMT => '0');

    PJ_inst : ZMA2GSD port map
      (O => pj_d_i(i), I => pj_d_o(i), IO => PJ(i), E => pj_oen(i), E2 => p1_hi, E4 => p1_hi, E8 => p1_hi, SR => p1_sr, PU => '0', PD => '0', SMT => '0');

    D_DQ_inst : ZMA2GSD port map
      (O => sd_dqi(i), I => sd_dqo(i), IO => D_DQ(i), E => sd_en_dqo, E2 => d_hi, E4 => d_hi, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0');

  end generate gen_bi_io;


end;
