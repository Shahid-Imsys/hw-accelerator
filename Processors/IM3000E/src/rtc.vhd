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
-- Date         Version  Author  Description
-- 2005-11-28     2.5      CB      Created
-- 2006-02-01     2.6      CB      Added the en_bmem latch, controlled by the
--                                 ld_bmem input port.
-- 2006-03-08     2.7      CB      Changed pwr_on to pwr_ok, en_bmem to dis_bmem.
-- 2006-05-11     2.8      CB      Added gate-offs with pwr_ok at all input signals.
-- 2006-05-12     2.9      CB      Moved gate-offs to a block of their own.
-- 2015-07-01     3.0      HYX     Add reset counter, isolation cells and power switch control
-- 2015-07-31     3.1      MN      Change output control signals to register
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gp_pkg.all;

entity rtc is
  generic (
    g_memory_type : memory_type_t := asic;
    g_clock_frequency : integer -- Frequency in MHz
    );
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

  --constant rtc_clock_puls_length_c : integer := (g_clock_frequency * (10**6)) / 32768;
  constant rtc_clock_puls_length_c : integer := (g_clock_frequency * (10**6)) / 500000;
  
  --signal cp     : std_logic_vector(46 downto 0);
  signal qn     : unsigned(46 downto 0);
  --signal qn_old : std_logic_vector(46 downto 0);
  signal rxout_old : std_logic;
  signal rxout_internal : std_logic;

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

  signal rst_rtc_iso_0         : std_logic;
  signal en_fclk_iso_0         : std_logic;
  signal fclk_iso_0            : std_logic;
  signal fclk_iso_0_old        : std_logic;
  signal ld_bmem_iso_0         : std_logic;
  signal rtc_sel_iso_0         : unsigned(2 downto 0);
  signal reset_iso_clear_iso_0 : std_logic;
  signal halt_en_iso_0         : std_logic;
  signal nap_en_iso_0          : std_logic;
  signal sel_pll_iso_0         : std_logic;
  signal poweron_finish_int    : std_logic;
  signal pmic_en_int           : std_logic;
--  signal pwr_switch_on_int : std_logic_vector(3 downto 0);
  signal arst_n                : std_logic;
  signal lp_rst_cnt            : unsigned(4 downto 0);
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
      rst_rtc         : in std_logic;   -- Reset RTC counter byte            
      en_fclk         : in std_logic;  -- Enable fast clocking of RTC counter byte
      fclk            : in std_logic;   -- Fast clock to RTC counter byte   
      ld_bmem         : in std_logic;  -- Latch enable to the dis_bmem latch   
      rtc_sel         : in std_logic_vector(2 downto 0);  -- RTC byte select

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

      -- signals isolated to 0
      sel_pll_iso_0         : out std_logic;
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

  component b_memory is
    generic (
      g_memory_type : memory_type_t := asic);
    port (
      clk     : in  std_logic;
      address : in  std_logic_vector(8 downto 0);
      ram_di  : in  std_logic_vector(7 downto 0);
      ram_do  : out std_logic_vector(7 downto 0);
      we_n    : in  std_logic;
      cs      : in  std_logic
      );

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

      c1_gmem_we_n => c1_gmem_we_n,
      c1_gmem_ce_n => c1_gmem_ce_n,
      c2_gmem_we_n => c2_gmem_we_n,
      c2_gmem_ce_n => c2_gmem_ce_n,
      bmem_we_n    => bmem_we_n,
      bmem_ce_n    => bmem_ce_n,


      sel_pll_iso_0           => sel_pll_iso_0,
      rst_rtc_iso_0           => rst_rtc_iso_0,
      en_fclk_iso_0           => en_fclk_iso_0,
      fclk_iso_0              => fclk_iso_0,
      ld_bmem_iso_0           => ld_bmem_iso_0,
      unsigned(rtc_sel_iso_0) => rtc_sel_iso_0,
      reset_iso_clear_iso_0   => reset_iso_clear_iso_0,
      halt_en_iso_0           => halt_en_iso_0,
      nap_en_iso_0            => nap_en_iso_0,


      c1_gmem_a_iso_0   => c1_gmem_a_iso_0,
      c1_gmem_d_iso_0   => c1_gmem_d_iso_0,
      c2_gmem_a_iso_0   => c2_gmem_a_iso_0,
      c2_gmem_d_iso_0   => c2_gmem_d_iso_0,
      dbus_iso_0        => dbus_iso_0,
      bmem_a8_iso_0     => bmem_a8_iso_0,
      bmem_d_iso_0      => bmem_d_iso_0,

      c1_gmem_we_n_iso_1 => c1_gmem_we_n_iso_1,
      c1_gmem_ce_n_iso_1 => c1_gmem_ce_n_iso_1,
      c2_gmem_we_n_iso_1 => c2_gmem_we_n_iso_1,
      c2_gmem_ce_n_iso_1 => c2_gmem_ce_n_iso_1,
      bmem_we_n_iso_1    => bmem_we_n_iso_1,
      bmem_ce_n_iso_1    => bmem_ce_n_iso_1

      );

  -- gmem
  -- gmem1
  gmem1 : memory_1024x8
    generic map (
      g_memory_type => g_memory_type
      )
    port map (
      address => c1_gmem_a_iso_0,
      ram_di  => c1_gmem_d_iso_0,
      ram_do  => c1_gmem_q,
      we_n    => c1_gmem_we_n_iso_1,
      clk     => pllout,
      cs      => c1_gmem_ce_n_iso_1
      );

  -- gmem2 
  gmem2 : memory_1024x8
    generic map (
      g_memory_type => g_memory_type
      )
    port map (
      address => c2_gmem_a_iso_0,
      ram_di  => c2_gmem_d_iso_0,
      ram_do  => c2_gmem_q,
      we_n    => c2_gmem_we_n_iso_1,
      clk     => pllout,                
      cs      => c2_gmem_ce_n_iso_1
      );

  bmem : b_memory
    generic map (
      g_memory_type => g_memory_type)
    port map (
      clk                 => pllout,
      address(7 downto 0) => dbus_iso_0(7 downto 0),
      address(8)          => bmem_a8_iso_0,
      ram_di              => bmem_d_iso_0,
      ram_do              => bmem_q,
      we_n                => bmem_we_n_iso_1,
      cs                  => bmem_ce_n_iso_1
      );

  clk_mux_out <= pllout;
  xout_selected <= '1';

  -- Disable latch for the power to BMEM
--  process (ld_bmem_iso_0, rtc_sel_iso_0)
--  begin
--    if ld_bmem_iso_0 = '1' then
--      dis_bmem <= rtc_sel_iso_0(0);
--    end if;
--  end process;
  dis_bmem <= '0';


  arst_n <= lp_pwr_ok and not wakeup_lp;

  process (pllout, arst_n)
  begin
    if arst_n = '0' then
      lp_rst_cnt <= "00000";
    elsif falling_edge(pllout) then
      if lp_rst_cnt_off_int = '0' then
        lp_rst_cnt <= lp_rst_cnt + '1';
      end if;
    end if;
  end process;

  lp_rst_cnt_off_int <= '1' when lp_rst_cnt = "11111" else '0';

  pwr_on_rst_n <= lp_pwr_ok;

  pwr_mode_state : process (pllout, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      current_state <= INIT;
    elsif rising_edge(pllout) then
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
  pwr_mode_signals : process (pllout, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      pmic_core_en <= '1';
      pmic_io_en   <= '1';
      core_iso     <= '1';
      clk_iso      <= '1';
      reset_core_n <= '0';
      nap_rec      <= '0';
    elsif rising_edge(pllout) then
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

  process (pllout, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      poweron_finish_int <= '0';
    elsif rising_edge(pllout) then
      if halt_en_iso_0 = '1' then
        poweron_finish_int <= '1';
      end if;
    end if;
  end process;

  process (pllout, pwr_on_rst_n)
  begin
    if pwr_on_rst_n = '0' then
      reset_iso <= '0';
    elsif rising_edge(pllout) then
      if reset_iso_clear_iso_0 = '1' then
        reset_iso <= '0';
      elsif wakeup_lp = '1' and current_state = HALT then
        reset_iso <= '1';
      end if;
    end if;
  end process;

--state_proc : process(pllout, arst_n)
--begin
--  if arst_n = '1' then
--    state <= s0;     --- active mode
--    pmic_en_int         <= '1';
--    lp_mode_latch       <= '0';
--    wakeup_lp_latch_int <= '0';
--  elsif rising_edge(pllout) then
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

  -----------------------------------------------------------------------------
  -- This is the old RTC, going on the external rxout clock, the counter is a
  -- ripple counter.
  -----------------------------------------------------------------------------

-- The ripple counter clocks. For setting counter more efficiently, the
  -- counter is split up into 6 parts. 'fclk_ok' may clock these parts separately.
  -- cp_gen : process (qn_old, en_fclk_iso_0, fclk_iso_0, rxout, rtc_sel_iso_0)
  -- begin
  --   -- Normal clocking. All FF:s in one long ripple counter chain.
  --   cp(0) <= rxout;
  --   for i in 1 to 46 loop
  --     cp(i) <= qn_old(i - 1);
  --   end loop;
  --   -- Fast clocking. The selected byte is clocked by fclk_ok.
  --   if en_fclk_iso_0 = '1' then
  --     if rtc_sel_iso_0 = 0 then
  --       cp(0) <= fclk_iso_0;
  --     end if;
  --     for i in 1 to 5 loop 
  --       if rtc_sel_iso_0 = i then
  --         cp((i*8)-1) <= fclk_iso_0;
  --       end if;
  --     end loop;
  --   end if;
  -- end process cp_gen;

  -- -- The 47 bits ripple counter.
  -- async_ripple_counter : for i in 0 to 46 generate
  --   d_ff : block
  --   begin  -- block d_ff
  --     process (cp(i), rst_rtc_iso_0, rtc_sel_iso_0)
  --     begin  -- process
  --       if rst_rtc_iso_0 = '1' and rtc_sel_iso_0 = ((i+1)/8) then
  --         qn_old(i) <= '1';
  --       elsif rising_edge(cp(i)) then
  --         qn_old(i) <= not qn_old(i);
  --       end if;
  --     end process;
  --   end block d_ff;
  -- end generate async_ripple_counter;

  
  ----------------------------------------------------------------------------
  -- For the testchip is the RTC driven on the system clock. This enahces the
  -- power consumtion considerable, but for a testchip is this acceptable.
  --
  -- If this is going to be a real chip must the RTC be chnaged to go on the
  -- exteranl 32 Khz crystal.
  -----------------------------------------------------------------------------

-- For the testchip is not  a real 32 KHz crystal used, instead is the clock
  -- generated from the system clock.
  p_gen_rx_out: process (pllout, pwr_on_rst_n) is
    variable rx_counter : integer range 0 to 32767;
  begin  -- process p_gen_rx_out
    if pwr_on_rst_n = '0' then          -- asynchronous reset (active low)
      rxout_internal <= '0';
      rx_counter := 0;
    elsif pllout'event and pllout = '1' then  -- rising clock edge
      if rx_counter >= rtc_clock_puls_length_c then
        rxout_internal <= not rxout_internal;
        rx_counter := 0;
      else
        rx_counter := rx_counter + 1;
      end if;
    end if;
  end process p_gen_rx_out;


  -- Syncgronous version of the RTC.
  synchronous_counter : process (pllout, pwr_on_rst_n) is
  begin  -- process synchronous_counter
    if pwr_on_rst_n = '0' then            -- asynchronous reset (active low)
      qn <= (others => '0');
    elsif rising_edge(pllout) then  -- rising clock edge
      if rst_rtc_iso_0 = '1' then
        case rtc_sel_iso_0 is
          when to_unsigned(0, 3) =>
            qn(7 downto 0) <= (others => '1');
          when to_unsigned(1, 3) =>
            qn(15 downto 8) <= (others => '1');
          when to_unsigned(2, 3) =>
            qn(23 downto 16) <= (others => '1');
          when to_unsigned(3, 3) =>
            qn(31 downto 24) <= (others => '1');
          when to_unsigned(4, 3) =>
            qn(39 downto 32) <= (others => '1');
          when to_unsigned(5, 3) =>
            qn(46 downto 40) <= (others => '1');
          when others => null;
        end case;
      else
        if (en_fclk_iso_0 = '1') and (fclk_iso_0 = '1') and (fclk_iso_0_old = '0') then
           
          case rtc_sel_iso_0 is
            when "000" => qn(6 downto 0) <=  qn(6 downto 0) - 1;
            when "001" => qn(14 downto 7) <=  qn(14 downto 7) - 1;
            when "010" => qn(22 downto 15) <=  qn(22 downto 15) - 1;
            when "011" => qn(30 downto 23) <=  qn(30 downto 23) - 1;
            when "100" => qn(38 downto 31) <=  qn(38 downto 31) - 1;
            when "101" => qn(46 downto 39) <=  qn(46 downto 39) - 1;
            when others => null;
          end case;
        end if;
        
        if rxout_internal = '1' and rxout_old = '0' then
          qn <= qn - 1;
        end if;

      end if;
      
      rxout_old <= rxout_internal;
      fclk_iso_0_old <= fclk_iso_0;
      
    end if;
  end process synchronous_counter;

  -- Mux for the output data. All six bytes of the counter can be read,
  -- the other two rtc_sel_ok combinations output test data.
  with rtc_sel_iso_0 select
    rtc_data <= std_logic_vector(not qn(6 downto 0) & '0')                    when "000",
    std_logic_vector(not qn(14 downto 7))                                     when "001",
    std_logic_vector(not qn(22 downto 15))                                    when "010",
    std_logic_vector(not qn(30 downto 23))                                    when "011",
    std_logic_vector(not qn(38 downto 31))                                    when "100",
    std_logic_vector(not qn(46 downto 39))                                    when "101",
    rst_rtc_iso_0 & en_fclk_iso_0 & fclk_iso_0 & ld_bmem_iso_0 &
    rtc_sel_iso_0(0) & rtc_sel_iso_0(0) & rtc_sel_iso_0(0) & rtc_sel_iso_0(0) when others;

  -- MRXOUT is now only an external wake-up signal, RTC
  -- oscillator test is done on another pin.
  mrxout_o <= qn(46);
end rtl;
