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
-- Title      : Real Time Clock counter
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : rtc.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The RTC counter is to provide battery powered time keeping
--              while the main power supply is turned off. The counter is
--              consisted of an async 47-bit ripple counter.
--              NOTE: The whole block is powered by Battery! 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date                                 Version         Author  Description
-- 2005-11-28           2.5                             CB                      Created
-- 2006-02-01           2.6                     CB                      Added the en_bmem latch, controlled by the
--                                                                                                                              new ld_bmem input port.
-- 2006-03-08           2.7                     CB                      Changed pwr_on to pwr_ok, en_bmem to dis_bmem.
-- 2006-05-11           2.8                     CB                      Added gate-offs with pwr_ok at all input signals.
-- 2006-05-12           2.9                     CB                      Moved gate-offs to a block of their own.
-- 2015-07-01       3.0             HYX         Add reset counter, isolation cells and power switch control
-- 2015-07-31       3.1             MN          Change output control signals to register
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity rtc is
  generic (
    asic : boolean := true);
  port (
    --gmem1
    c1_gmem_a    : in  std_logic_vector(9 downto 0);
    c1_gmem_q    : out std_logic_vector(7 downto 0);
    c1_gmem_d    : in  std_logic_vector(7 downto 0);
    c1_gmem_we_n : in  std_logic;
    c1_gmem_ce_n : in  std_logic;

    --gmem2
    c2_gmem_a    : in  std_logic_vector(9 downto 0);
    c2_gmem_q    : out std_logic_vector(7 downto 0);
    c2_gmem_d    : in  std_logic_vector(7 downto 0);
    c2_gmem_we_n : in  std_logic;
    c2_gmem_ce_n : in  std_logic;

    --bmem
    dbus      : in  std_logic_vector(7 downto 0);
    bmem_a8   : in  std_logic;
    bmem_q    : out std_logic_vector(7 downto 0);
    bmem_d    : in  std_logic_vector(7 downto 0);
    bmem_we_n : in  std_logic;
    bmem_ce_n : in  std_logic;

    --RAM0 
    RAM0_DO  : out std_logic_vector (7 downto 0);
    RAM0_DI  : in  std_logic_vector (7 downto 0);
    RAM0_A   : in  std_logic_vector (13 downto 0);
    RAM0_WEB : in  std_logic;
    RAM0_CS  : in  std_logic;

    xout          : in  std_logic;  -- external high frequency oscillator clock 
    pllout        : in  std_logic;
    sel_pll       : in  std_logic;
    xout_selected : out std_logic;
    lp_pwr_ok     : in  std_logic;  -- Core power indicator, controls mrxout_o   
    rxout         : in  std_logic;      -- 32KHz oscillator input         
    mrxout_o      : out std_logic;  -- 32KHz oscillator output or external wake        
    rst_rtc       : in  std_logic;      -- Reset RTC counter byte            
    en_fclk       : in  std_logic;  -- Enable fast clocking of RTC counter byte
    fclk          : in  std_logic;      -- Fast clock to RTC counter byte   
    ld_bmem       : in  std_logic;  -- Latch enable to the dis_bmem latch   
    rtc_sel       : in  std_logic_vector(2 downto 0);  -- RTC byte select
    rtc_data      : out std_logic_vector(7 downto 0);  -- RTC data             
    dis_bmem      : out std_logic;      -- Disable power to BMEM

    reset_iso_clear : in  std_logic;
    halt_en         : in  std_logic;    --high active, will go to halt state
    nap_en          : in  std_logic;    --high active, will go to nap state
    wakeup_lp       : in  std_logic;    -- From wakeup_lp input IO
    poweron_finish  : out std_logic;    -- 
    reset_iso       : out std_logic;    -- to isolate the core reset
    reset_core_n    : out std_logic;    -- to reset core, low active
    io_iso          : out std_logic;  -- to isolate the io signals in nap mode
    nap_rec         : out std_logic;    -- will recover from nap mode
    pmic_core_en    : out std_logic;
    pmic_io_en      : out std_logic;
    clk_mux_out     : out std_logic
    );
end rtc;

architecture rtl of rtc is
  signal cp : std_logic_vector(46 downto 0);
  signal qn : std_logic_vector(46 downto 0);

  -- These signals need to be kept through synthesis!

  -- gmem1
  signal c1_gmem_a_iso_0    : std_logic_vector(9 downto 0);
  signal c1_gmem_d_iso_0    : std_logic_vector(7 downto 0);
  signal c1_gmem_we_n_iso_1 : std_logic;
  signal c1_gmem_ce_n_iso_1 : std_logic;

  -- gmem2
  signal c2_gmem_a_iso_0    : std_logic_vector(9 downto 0);
  signal c2_gmem_d_iso_0    : std_logic_vector(7 downto 0);
  signal c2_gmem_we_n_iso_1 : std_logic;
  signal c2_gmem_ce_n_iso_1 : std_logic;

  -- bmem
  signal dbus_iso_0      : std_logic_vector(7 downto 0);
  signal bmem_a8_iso_0   : std_logic;
  signal bmem_d_iso_0    : std_logic_vector(7 downto 0);
  signal bmem_we_n_iso_1 : std_logic;
  signal bmem_ce_n_iso_1 : std_logic;

  -- RAM0
  signal RAM0_DI_iso_0  : std_logic_vector(7 downto 0);
  signal RAM0_A_iso_0   : std_logic_vector(13 downto 0);
  signal RAM0_CS_iso_0  : std_logic;
  signal RAM0_WEB_iso_1 : std_logic;


  signal clk_mux_out_iso_1 : std_logic;

  signal rst_rtc_iso_0         : std_logic;
  signal en_fclk_iso_0         : std_logic;
  signal fclk_iso_0            : std_logic;
  signal ld_bmem_iso_0         : std_logic;
  signal rtc_sel_iso_0         : std_logic_vector(2 downto 0);
  signal reset_iso_clear_iso_0 : std_logic;
  signal halt_en_iso_0         : std_logic;
  signal nap_en_iso_0          : std_logic;
  signal sel_pll_iso_0         : std_logic;
  signal pllout_iso_1          : std_logic;
  signal poweron_finish_int    : std_logic;
  signal pmic_en_int           : std_logic;
--  signal pwr_switch_on_int : std_logic_vector(3 downto 0);
  signal clk_mux_out_int       : std_logic;
  signal arst_n                : std_logic;
  signal lp_rst_cnt            : std_logic_vector(4 downto 0);
  signal core_iso              : std_logic;
  signal clk_iso               : std_logic;
  signal lp_rst_cnt_off_int    : std_logic;
  signal pwr_on_rst_n          : std_logic;

  type states is (INIT, ACT, HALTP, HALTP2, HALTPC, HALT, HALTR, NAPP, NAPP2, NAPPC, NAP, NAPR);
  signal next_state    : states;
  signal current_state : states;
--      
--  signal state  : std_logic_vector(1 downto 0);
--  signal next_state  : std_logic_vector(1 downto 0);
--  constant s0   : std_logic_vector(1 downto 0) := "00";
--  constant s1   : std_logic_vector(1 downto 0) := "01";
--  constant s2   : std_logic_vector(1 downto 0) := "10";
--  constant s3   : std_logic_vector(1 downto 0) := "11";

  --attribute syn_keep  : boolean;
  --attribute syn_keep of rst_rtc_ok    : signal is true;
  --attribute syn_keep of en_fclk_ok    : signal is true;
  --attribute syn_keep of fclk_ok                       : signal is true;
  --attribute syn_keep of ld_bmem_ok    : signal is true;
  --attribute syn_keep of rtc_sel_ok    : signal is true;

  -- Isolation cells for the rtc
  component rtc_iso
    port (
      iso             : in std_logic;  -- isolation controll signal, active high
      clk_iso         : in std_logic;  -- isolation controll signal, active high
      -- signals to be isolated
      reset_iso_clear : in std_logic;
      halt_en         : in std_logic;
      nap_en          : in std_logic;
      sel_pll         : in std_logic;
      pllout          : in std_logic;
      rst_rtc         : in std_logic;   -- Reset RTC counter byte            
      en_fclk         : in std_logic;  -- Enable fast clocking of RTC counter byte
      fclk            : in std_logic;   -- Fast clock to RTC counter byte   
      ld_bmem         : in std_logic;  -- Latch enable to the dis_bmem latch   
      rtc_sel         : in std_logic_vector(2 downto 0);  -- RTC byte select
      clk_mux_out     : in std_logic;

      --gmem1
      c1_gmem_a    : in std_logic_vector(9 downto 0);
      c1_gmem_d    : in std_logic_vector(7 downto 0);
      c1_gmem_we_n : in std_logic;
      c1_gmem_ce_n : in std_logic;

      --gmem2
      c2_gmem_a    : in std_logic_vector(9 downto 0);
      c2_gmem_d    : in std_logic_vector(7 downto 0);
      c2_gmem_we_n : in std_logic;
      c2_gmem_ce_n : in std_logic;

      --bmem
      dbus      : in std_logic_vector(7 downto 0);
      bmem_a8   : in std_logic;
      bmem_d    : in std_logic_vector(7 downto 0);
      bmem_we_n : in std_logic;
      bmem_ce_n : in std_logic;

      --RAM0
      RAM0_DI  : in std_logic_vector(7 downto 0);
      RAM0_A   : in std_logic_vector(13 downto 0);
      RAM0_WEB : in std_logic;
      RAM0_CS  : in std_logic;


      -- signals isolated to 0
      sel_pll_iso_0         : out std_logic;
      pllout_iso_1          : out std_logic;
      rst_rtc_iso_0         : out std_logic;
      en_fclk_iso_0         : out std_logic;
      fclk_iso_0            : out std_logic;
      ld_bmem_iso_0         : out std_logic;
      rtc_sel_iso_0         : out std_logic_vector(2 downto 0);
      reset_iso_clear_iso_0 : out std_logic;
      halt_en_iso_0         : out std_logic;
      nap_en_iso_0          : out std_logic;

      c1_gmem_a_iso_0 : out std_logic_vector(9 downto 0);
      c1_gmem_d_iso_0 : out std_logic_vector(7 downto 0);

      c2_gmem_a_iso_0 : out std_logic_vector(9 downto 0);
      c2_gmem_d_iso_0 : out std_logic_vector(7 downto 0);

      dbus_iso_0    : out std_logic_vector(7 downto 0);
      bmem_a8_iso_0 : out std_logic;
      bmem_d_iso_0  : out std_logic_vector(7 downto 0);

      RAM0_DI_iso_0 : out std_logic_vector(7 downto 0);
      RAM0_A_iso_0  : out std_logic_vector(13 downto 0);
      RAM0_CS_iso_0 : out std_logic;

      clk_mux_out_iso_1 : out std_logic;

      -- signals isolated to 1
      c1_gmem_we_n_iso_1 : out std_logic;
      c1_gmem_ce_n_iso_1 : out std_logic;
      c2_gmem_we_n_iso_1 : out std_logic;
      c2_gmem_ce_n_iso_1 : out std_logic;
      bmem_we_n_iso_1    : out std_logic;
      bmem_ce_n_iso_1    : out std_logic;
      RAM0_WEB_iso_1     : out std_logic
      );
  end component;

  -- gmem
  component SY180_1024X8X1CM8
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
      DO0 : out std_logic;
      DO1 : out std_logic;
      DO2 : out std_logic;
      DO3 : out std_logic;
      DO4 : out std_logic;
      DO5 : out std_logic;
      DO6 : out std_logic;
      DO7 : out std_logic;
      DI0 : in  std_logic;
      DI1 : in  std_logic;
      DI2 : in  std_logic;
      DI3 : in  std_logic;
      DI4 : in  std_logic;
      DI5 : in  std_logic;
      DI6 : in  std_logic;
      DI7 : in  std_logic;
      WEB : in  std_logic;
      CK  : in  std_logic;
      CSB : in  std_logic
      );
  end component;

  --BMEM
  component SY180_512X8X1CM8
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
      DO0 : out std_logic;
      DO1 : out std_logic;
      DO2 : out std_logic;
      DO3 : out std_logic;
      DO4 : out std_logic;
      DO5 : out std_logic;
      DO6 : out std_logic;
      DO7 : out std_logic;
      DI0 : in  std_logic;
      DI1 : in  std_logic;
      DI2 : in  std_logic;
      DI3 : in  std_logic;
      DI4 : in  std_logic;
      DI5 : in  std_logic;
      DI6 : in  std_logic;
      DI7 : in  std_logic;
      WEB : in  std_logic;
      CK  : in  std_logic;
      CSB : in  std_logic
      );
  end component;

-- application and microprogram shared memory
  component SU180_16384X8X1BM8
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
      A11 : in  std_logic;
      A12 : in  std_logic;
      A13 : in  std_logic;
      DO0 : out std_logic;
      DO1 : out std_logic;
      DO2 : out std_logic;
      DO3 : out std_logic;
      DO4 : out std_logic;
      DO5 : out std_logic;
      DO6 : out std_logic;
      DO7 : out std_logic;
      DI0 : in  std_logic;
      DI1 : in  std_logic;
      DI2 : in  std_logic;
      DI3 : in  std_logic;
      DI4 : in  std_logic;
      DI5 : in  std_logic;
      DI6 : in  std_logic;
      DI7 : in  std_logic;
      WEB : in  std_logic;
      CK  : in  std_logic;
      CS  : in  std_logic;
      OE  : in  std_logic
      );
  end component;



  component clk_mux
    port (
      clk1          : in  std_logic;
      clk2          : in  std_logic;
      sel           : in  std_logic;
      rst_n         : in  std_logic;
      clk1_selected : out std_logic;
      clk_mux_out   : out std_logic);
  end component;


begin  -- rtl

  rtc_iso0 : rtc_iso
    port map (
      iso             => core_iso,
      clk_iso         => clk_iso,
      reset_iso_clear => reset_iso_clear,
      halt_en         => halt_en,
      nap_en          => nap_en,
      sel_pll         => sel_pll,
      pllout          => pllout,
      rst_rtc         => rst_rtc,
      en_fclk         => en_fclk,
      fclk            => fclk,
      ld_bmem         => ld_bmem,
      rtc_sel         => rtc_sel,

      c1_gmem_a   => c1_gmem_a,
      c1_gmem_d   => c1_gmem_d,
      c2_gmem_a   => c2_gmem_a,
      c2_gmem_d   => c2_gmem_d,
      dbus        => dbus,
      bmem_a8     => bmem_a8,
      bmem_d      => bmem_d,
      clk_mux_out => clk_mux_out_int,

      c1_gmem_we_n => c1_gmem_we_n,
      c1_gmem_ce_n => c1_gmem_ce_n,
      c2_gmem_we_n => c2_gmem_we_n,
      c2_gmem_ce_n => c2_gmem_ce_n,
      bmem_we_n    => bmem_we_n,
      bmem_ce_n    => bmem_ce_n,


      RAM0_DI  => RAM0_DI,
      RAM0_A   => RAM0_A,
      RAM0_WEB => RAM0_WEB,
      RAM0_CS  => RAM0_CS,

      sel_pll_iso_0         => sel_pll_iso_0,
      pllout_iso_1          => pllout_iso_1,
      rst_rtc_iso_0         => rst_rtc_iso_0,
      en_fclk_iso_0         => en_fclk_iso_0,
      fclk_iso_0            => fclk_iso_0,
      ld_bmem_iso_0         => ld_bmem_iso_0,
      rtc_sel_iso_0         => rtc_sel_iso_0,
      reset_iso_clear_iso_0 => reset_iso_clear_iso_0,
      halt_en_iso_0         => halt_en_iso_0,
      nap_en_iso_0          => nap_en_iso_0,


      c1_gmem_a_iso_0   => c1_gmem_a_iso_0,
      c1_gmem_d_iso_0   => c1_gmem_d_iso_0,
      c2_gmem_a_iso_0   => c2_gmem_a_iso_0,
      c2_gmem_d_iso_0   => c2_gmem_d_iso_0,
      dbus_iso_0        => dbus_iso_0,
      bmem_a8_iso_0     => bmem_a8_iso_0,
      bmem_d_iso_0      => bmem_d_iso_0,
      clk_mux_out_iso_1 => clk_mux_out_iso_1,

      c1_gmem_we_n_iso_1 => c1_gmem_we_n_iso_1,
      c1_gmem_ce_n_iso_1 => c1_gmem_ce_n_iso_1,
      c2_gmem_we_n_iso_1 => c2_gmem_we_n_iso_1,
      c2_gmem_ce_n_iso_1 => c2_gmem_ce_n_iso_1,
      bmem_we_n_iso_1    => bmem_we_n_iso_1,
      bmem_ce_n_iso_1    => bmem_ce_n_iso_1,

      RAM0_DI_iso_0  => RAM0_DI_iso_0,
      RAM0_A_iso_0   => RAM0_A_iso_0,
      RAM0_WEB_iso_1 => RAM0_WEB_iso_1,
      RAM0_CS_iso_0  => RAM0_CS_iso_0

      );

  -- gmem
  -- gmem1
  gmem1 : SY180_1024X8X1CM8
    port map (
      A0  => c1_gmem_a_iso_0(0),
      A1  => c1_gmem_a_iso_0(1),
      A2  => c1_gmem_a_iso_0(2),
      A3  => c1_gmem_a_iso_0(3),
      A4  => c1_gmem_a_iso_0(4),
      A5  => c1_gmem_a_iso_0(5),
      A6  => c1_gmem_a_iso_0(6),
      A7  => c1_gmem_a_iso_0(7),
      A8  => c1_gmem_a_iso_0(8),
      A9  => c1_gmem_a_iso_0(9),
      DO0 => c1_gmem_q(0),
      DO1 => c1_gmem_q(1),
      DO2 => c1_gmem_q(2),
      DO3 => c1_gmem_q(3),
      DO4 => c1_gmem_q(4),
      DO5 => c1_gmem_q(5),
      DO6 => c1_gmem_q(6),
      DO7 => c1_gmem_q(7),
      DI0 => c1_gmem_d_iso_0(0),
      DI1 => c1_gmem_d_iso_0(1),
      DI2 => c1_gmem_d_iso_0(2),
      DI3 => c1_gmem_d_iso_0(3),
      DI4 => c1_gmem_d_iso_0(4),
      DI5 => c1_gmem_d_iso_0(5),
      DI6 => c1_gmem_d_iso_0(6),
      DI7 => c1_gmem_d_iso_0(7),
      WEB => c1_gmem_we_n_iso_1,
      CK  => clk_mux_out_iso_1,
      CSB => c1_gmem_ce_n_iso_1
      );


-- gmem2
  gmem2 : SY180_1024X8X1CM8
    port map (
      A0  => c2_gmem_a_iso_0(0),
      A1  => c2_gmem_a_iso_0(1),
      A2  => c2_gmem_a_iso_0(2),
      A3  => c2_gmem_a_iso_0(3),
      A4  => c2_gmem_a_iso_0(4),
      A5  => c2_gmem_a_iso_0(5),
      A6  => c2_gmem_a_iso_0(6),
      A7  => c2_gmem_a_iso_0(7),
      A8  => c2_gmem_a_iso_0(8),
      A9  => c2_gmem_a_iso_0(9),
      DO0 => c2_gmem_q(0),
      DO1 => c2_gmem_q(1),
      DO2 => c2_gmem_q(2),
      DO3 => c2_gmem_q(3),
      DO4 => c2_gmem_q(4),
      DO5 => c2_gmem_q(5),
      DO6 => c2_gmem_q(6),
      DO7 => c2_gmem_q(7),
      DI0 => c2_gmem_d_iso_0(0),
      DI1 => c2_gmem_d_iso_0(1),
      DI2 => c2_gmem_d_iso_0(2),
      DI3 => c2_gmem_d_iso_0(3),
      DI4 => c2_gmem_d_iso_0(4),
      DI5 => c2_gmem_d_iso_0(5),
      DI6 => c2_gmem_d_iso_0(6),
      DI7 => c2_gmem_d_iso_0(7),
      WEB => c2_gmem_we_n_iso_1,
      CK  => clk_mux_out_iso_1,
      CSB => c2_gmem_ce_n_iso_1
      );


  -- bmem  !!! SEPARATELY POWERED !!!
  bmem : SY180_512X8X1CM8
    port map (
      A0  => dbus_iso_0(0),
      A1  => dbus_iso_0(1),
      A2  => dbus_iso_0(2),
      A3  => dbus_iso_0(3),
      A4  => dbus_iso_0(4),
      A5  => dbus_iso_0(5),
      A6  => dbus_iso_0(6),
      A7  => dbus_iso_0(7),
      A8  => bmem_a8_iso_0,
      DO0 => bmem_q(0),
      DO1 => bmem_q(1),
      DO2 => bmem_q(2),
      DO3 => bmem_q(3),
      DO4 => bmem_q(4),
      DO5 => bmem_q(5),
      DO6 => bmem_q(6),
      DO7 => bmem_q(7),
      DI0 => bmem_d_iso_0(0),
      DI1 => bmem_d_iso_0(1),
      DI2 => bmem_d_iso_0(2),
      DI3 => bmem_d_iso_0(3),
      DI4 => bmem_d_iso_0(4),
      DI5 => bmem_d_iso_0(5),
      DI6 => bmem_d_iso_0(6),
      DI7 => bmem_d_iso_0(7),
      WEB => bmem_we_n_iso_1,
      CK  => clk_mux_out_iso_1,
      CSB => bmem_ce_n_iso_1
      );

---application memories
  ram0 : SU180_16384X8X1BM8             -- need modification flag, 2015lp
    port map (
      A0  => RAM0_A_iso_0(0),
      A1  => RAM0_A_iso_0(1),
      A2  => RAM0_A_iso_0(2),
      A3  => RAM0_A_iso_0(3),
      A4  => RAM0_A_iso_0(4),
      A5  => RAM0_A_iso_0(5),
      A6  => RAM0_A_iso_0(6),
      A7  => RAM0_A_iso_0(7),
      A8  => RAM0_A_iso_0(8),
      A9  => RAM0_A_iso_0(9),
      A10 => RAM0_A_iso_0(10),
      A11 => RAM0_A_iso_0(11),
      A12 => RAM0_A_iso_0(12),
      A13 => RAM0_A_iso_0(13),
      DO0 => RAM0_DO(0),
      DO1 => RAM0_DO(1),
      DO2 => RAM0_DO(2),
      DO3 => RAM0_DO(3),
      DO4 => RAM0_DO(4),
      DO5 => RAM0_DO(5),
      DO6 => RAM0_DO(6),
      DO7 => RAM0_DO(7),
      DI0 => RAM0_DI_iso_0(0),
      DI1 => RAM0_DI_iso_0(1),
      DI2 => RAM0_DI_iso_0(2),
      DI3 => RAM0_DI_iso_0(3),
      DI4 => RAM0_DI_iso_0(4),
      DI5 => RAM0_DI_iso_0(5),
      DI6 => RAM0_DI_iso_0(6),
      DI7 => RAM0_DI_iso_0(7),
      WEB => RAM0_WEB_iso_1,
      CK  => clk_mux_out_iso_1,
      CS  => RAM0_CS_iso_0,
      OE  => '1'
      );


  --Clock switching logic, designed to handle asynchronous clocks.
  clk_mux_1 : clk_mux
    port map (
      clk1          => xout,
      clk2          => pllout_iso_1,
      sel           => sel_pll_iso_0,
      rst_n         => lp_pwr_ok,
      clk1_selected => xout_selected,
      clk_mux_out   => clk_mux_out_int);

  clk_mux_out <= clk_mux_out_iso_1;

  --clk_mux_2: clk_mux
  --port map (
  -- clk1          => clk_mux_out1,  
  -- clk2          => hf_osc,
  -- sel           => lp_mode_latch,  
  -- rst_n         => rst_n,                     
  -- clk_mux_out   => clk_mux_out2);
  --clk_p_int   <= clk_mux_out2;


  -- Disable latch for the power to BMEM
  process (ld_bmem_iso_0, rtc_sel_iso_0)
  begin
    if ld_bmem_iso_0 = '1' then
      dis_bmem <= rtc_sel_iso_0(0);
    end if;
  end process;



  arst_n <= lp_pwr_ok and not wakeup_lp;

  process (clk_mux_out_int, arst_n)
  begin
    if arst_n = '0' then
      lp_rst_cnt <= "00000";
    elsif falling_edge(clk_mux_out_int) then
      if lp_rst_cnt_off_int = '0' then
        lp_rst_cnt <= lp_rst_cnt + '1';
      end if;
    end if;
  end process;

  lp_rst_cnt_off_int <= '1' when lp_rst_cnt = "11111" else '0';

  pwr_on_rst_n <= lp_pwr_ok;

  pwr_mode_state : process (clk_mux_out_int, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      current_state <= INIT;
    elsif rising_edge(clk_mux_out_int) then
      current_state <= next_state;
    end if;
  end process pwr_mode_state;

  pwr_mode_next : process (current_state, halt_en_iso_0, nap_en_iso_0, wakeup_lp, lp_rst_cnt_off_int)
  begin
    case current_state is
      when INIT =>
        next_state <= ACT;

      when ACT =>
        if halt_en_iso_0 = '1' then
          next_state <= HALTP;
        elsif nap_en_iso_0 = '1' then
          next_state <= NAPP;
        else
          next_state <= ACT;
        end if;

      when HALTP =>
        next_state <= HALTP2;

      when HALTP2 =>
        next_state <= HALTPC;

      when HALTPC =>
        next_state <= HALT;

      when HALT =>
        if wakeup_lp = '1' then
          next_state <= HALTR;
        else
          next_state <= HALT;
        end if;

      when HALTR =>
        if lp_rst_cnt_off_int = '1' then
          next_state <= ACT;
        else
          next_state <= HALTR;
        end if;

      when NAPP =>
        next_state <= NAPP2;

      when NAPP2 =>
        next_state <= NAPPC;

      when NAPPC =>
        next_state <= NAP;

      when NAP =>
        if wakeup_lp = '1' then
          next_state <= NAPR;
        else
          next_state <= NAP;
        end if;

      when NAPR =>
        if lp_rst_cnt_off_int = '1' then
          next_state <= ACT;
        else
          next_state <= NAPR;
        end if;

      when others =>
        next_state <= INIT;
    end case;
  end process pwr_mode_next;

--make all the control signals to be regestered
  pwr_mode_signals : process (clk_mux_out_int, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      pmic_core_en <= '1';
      pmic_io_en   <= '1';
      core_iso     <= '1';
      clk_iso      <= '1';
      reset_core_n <= '0';
      nap_rec      <= '0';
    elsif rising_edge(clk_mux_out_int) then
      if next_state = HALT then
        pmic_core_en <= '0';
      elsif wakeup_lp = '1' then
        pmic_core_en <= '1';
      end if;

      if next_state = HALT or next_state = NAP then
        pmic_io_en <= '0';
      elsif wakeup_lp = '1' then
        pmic_io_en <= '1';
      end if;

      if next_state = ACT then
        core_iso <= '0';
      else
        core_iso <= '1';
      end if;

      if next_state = ACT or next_state = HALTP or next_state = HALTP2 or next_state = NAPP or next_state = NAPP2 then
        clk_iso <= '0';
      else
        clk_iso <= '1';
      end if;

      if next_state = HALTR then
        reset_core_n <= '0';
      elsif next_state = ACT then
        reset_core_n <= '1';
      end if;

      if next_state = NAPR then
        nap_rec <= '1';
      else
        nap_rec <= '0';
      end if;

    end if;

  end process pwr_mode_signals;

  io_iso <= core_iso;

  process (clk_mux_out_int, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      poweron_finish_int <= '0';
    elsif rising_edge(clk_mux_out_int) then
      if halt_en_iso_0 = '1' then
        poweron_finish_int <= '1';
      end if;
    end if;
  end process;

  process (clk_mux_out_int, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      reset_iso <= '0';
    elsif rising_edge(clk_mux_out_int) then
      if reset_iso_clear_iso_0 = '1' then
        reset_iso <= '0';
      elsif wakeup_lp = '1' and current_state = HALT then
        reset_iso <= '1';
      end if;
    end if;
  end process;

--state_proc : process(clk_mux_out_int, arst_n)
--begin
--  if arst_n = '1' then
--    state <= s0;     --- active mode
--    pmic_en_int         <= '1';
--    lp_mode_latch       <= '0';
--    wakeup_lp_latch_int <= '0';
--  elsif rising_edge(clk_mux_out_int) then
--    case state is
--         when s0 =>                   --active mode
--              pmic_en_int       <= '1';
--              lp_mode_latch     <= '0';
--              state             <= s1;
--         when s1 =>                   --sleep pending mode, isolate input from power down, 
--              if lp_mode_iso = '1' then
--                lp_mode_latch <= '1';
--                state <= s2;
--              else 
--                state <= s1;
--              end if;
--         when s2 =>                   --sleep mode
--              pmic_en_int             <= '0';
--              wakeup_lp_latch_int     <= '0';
--              state                   <= s3;
--         when s3 =>                   --active pending
--              if wakeup_lp = '1' then
--                wakeup_lp_latch_int <= '1';
--                state <= s0;
--              else 
--                state <= s3;
--              end if;
--         when others =>
--              NULL;
--    end case;
--  end if;
--end process state_proc;

  poweron_finish <= poweron_finish_int;
--pwr_switch_on <= pwr_switch_on_int;
--rtc_clk <= 0 when lp_mode_latch = '1' and state = s3 else clk_p;


---------------------------------------------------------------------
-- Entire Chip Reset generation &
-- power-on detection part
-------------------------------------------------------------------------------

  for_ASIC_g : if asic generate

    -- The ripple counter clocks. For setting counter more efficiently, the
    -- counter is split up into 6 parts. 'fclk_ok' may clock these parts separately.
    cp_gen : process (qn, en_fclk_iso_0, fclk_iso_0, rxout, rtc_sel_iso_0)
    begin
      -- Normal clocking. All FF:s in one long ripple counter chain.
      cp(0) <= rxout;
      for i in 1 to 46 loop
        cp(i) <= qn(i - 1);
      end loop;
      -- Fast clocking. The selected byte is clocked by fclk_ok.
      if en_fclk_iso_0 = '1' then
        if rtc_sel_iso_0 = 0 then
          cp(0) <= fclk_iso_0;
        end if;
        for i in 1 to 5 loop
          if rtc_sel_iso_0 = i then
            cp((i*8)-1) <= fclk_iso_0;
          end if;
        end loop;
      end if;
    end process cp_gen;

    -- The 47 bits ripple counter.
    async_ripple_counter : for i in 0 to 46 generate
      d_ff : block
      begin  -- block d_ff
        process (cp(i), rst_rtc_iso_0, rtc_sel_iso_0)
        begin  -- process
          if rst_rtc_iso_0 = '1' and rtc_sel_iso_0 = ((i+1)/8) then
            qn(i) <= '1';
          elsif rising_edge(cp(i)) then
            qn(i) <= not qn(i);
          end if;
        end process;
      end block d_ff;
    end generate async_ripple_counter;

    -- Mux for the output data. All six bytes of the counter can be read,
    -- the other two rtc_sel_ok combinations output test data.
    with rtc_sel_iso_0 select
      rtc_data <= not qn(6 downto 0) & '0'                                      when "000",
      not qn(14 downto 7)                                                       when "001",
      not qn(22 downto 15)                                                      when "010",
      not qn(30 downto 23)                                                      when "011",
      not qn(38 downto 31)                                                      when "100",
      not qn(46 downto 39)                                                      when "101",
      rst_rtc_iso_0 & en_fclk_iso_0 & fclk_iso_0 & ld_bmem_iso_0 &
      rtc_sel_iso_0(0) & rtc_sel_iso_0(0) & rtc_sel_iso_0(0) & rtc_sel_iso_0(0) when others;

  -- MRXOUT is now only an external wake-up signal, RTC
  -- oscillator test is done on another pin.
  end generate for_ASIC_g;
  for_fpga_g: if asic = false generate
    
    rtc_data <= (others => '0');

  end generate for_fpga_g;
  mrxout_o <= qn(46);
end rtl;
