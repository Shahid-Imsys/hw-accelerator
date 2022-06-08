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
    --
    MTEST      : in  std_logic;
    MBYPASS    : in  std_logic;
    MIRQ0      : in  std_logic;
    MIRQ1      : in  std_logic;
    -- SW debug                                                               
    MSDIN      : in  std_logic;         -- serial data in (debug) 

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
    mtest_i     : out std_logic;
    mirq0_i     : out std_logic;
    mirq1_i     : out std_logic;
    msdin_i     : out std_logic;

    mbypass_i    : out std_logic;

    -- low power mode pad
    io_iso       : in  std_logic;
   
    ph_i  : in  std_logic_vector(7 downto 0);
    ph_en : out std_logic_vector(7 downto 0);
    ph_o  : out std_logic_vector(7 downto 0);

    ph_i_from_iopads  : out std_logic_vector(7 downto 0);
    ph_en_to_iopads : in  std_logic_vector(7 downto 0);
    ph_o_to_iopads  : in  std_logic_vector(7 downto 0);

    -- I/O cell configuration control outputs
    d_hi  : in  std_logic;  -- High drive on DRAM interface, now used for other outputs
    d_sr  : in  std_logic              -- Slew rate limit on DRAM interface
 
    );


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
  
begin
  --input pads

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

--------------PH-----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

  ph_en(0) <= '1' when MTEST = '1' else ph_en_to_iopads(0);
  ph_en(1) <= '1' when MTEST = '1' else ph_en_to_iopads(1);
  ph_en(2) <= '1' when MTEST = '1' else ph_en_to_iopads(2);
  ph_en(3) <= '1' when MTEST = '1' else ph_en_to_iopads(3);
  ph_en(4) <= '1' when MTEST = '1' else ph_en_to_iopads(4);
  ph_en(5) <= '1' when MTEST = '1' else ph_en_to_iopads(5);
  ph_en(6) <= '1' when MTEST = '1' else ph_en_to_iopads(6);
  ph_en(7) <= '1' when MTEST = '1' else ph_en_to_iopads(7);  --modified by HYX, 20141115

  ph_o(0) <= rtc_clk_tst when MTEST = '1' else ph_o_to_iopads(0);
  ph_o(1) <= HCLK        when MTEST = '1' else ph_o_to_iopads(1);
  ph_o(2) <= clk_p_tst   when MTEST = '1' else ph_o_to_iopads(2);
  ph_o(3) <= clk_c_tst   when MTEST = '1' else ph_o_to_iopads(3);
  ph_o(4) <= clk_c2_tst  when MTEST = '1' else ph_o_to_iopads(4);
  ph_o(5) <= clk_e_tst   when MTEST = '1' else ph_o_to_iopads(5);
  ph_o(6) <= clk_c2a_tst when MTEST = '1' else ph_o_to_iopads(6);
  ph_o(7) <= clk_ea_tst  when MTEST = '1' else ph_o_to_iopads(7);  --modified by HYX, 20141115

  ph_i_from_iopads <= ph_i;
end;
