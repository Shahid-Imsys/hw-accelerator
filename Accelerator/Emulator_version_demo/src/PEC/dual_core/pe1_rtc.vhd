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
-- File       : pe1_rtc.vhd
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
-- Date					Version		Author	Description
-- 2005-11-28		2.5				CB			Created
-- 2006-02-01		2.6 			CB			Added the en_bmem latch, controlled by the
--																new ld_bmem input port.
-- 2006-03-08		2.7 			CB			Changed pwr_on to pwr_ok, en_bmem to dis_bmem.
-- 2006-05-11		2.8 			CB			Added gate-offs with pwr_ok at all input signals.
-- 2006-05-12		2.9 			CB			Moved gate-offs to a block of their own.
-- 2015-07-01       3.0             HYX         Add reset counter, isolation cells and power switch control
-- 2015-07-31       3.1             MN          Change output control signals to register
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity pe1_rtc is
  generic(
    USE_ASIC_MEMORIES   : boolean := false );
  port (
    --gmem1
    c1_gmem_a         : in    std_logic_vector(9 downto 0);
    c1_gmem_q         : out   std_logic_vector(7 downto 0);
    c1_gmem_d         : in    std_logic_vector(7 downto 0);
    c1_gmem_we_n      : in    std_logic;
    c1_gmem_ce_n      : in    std_logic;

    --gmem2
    c2_gmem_a         : in    std_logic_vector(9 downto 0);
    c2_gmem_q         : out   std_logic_vector(7 downto 0);
    c2_gmem_d         : in    std_logic_vector(7 downto 0);
    c2_gmem_we_n      : in    std_logic;
    c2_gmem_ce_n      : in    std_logic;

    --bmem
    dbus              : in    std_logic_vector(7 downto 0);
    bmem_a8           : in    std_logic;
    bmem_d            : in    std_logic_vector(7 downto 0);
    bmem_we_n         : in    std_logic;
    bmem_ce_n         : in    std_logic;
--
  --  --RAM0
  --  RAM0_DO           : out   std_logic_vector (7 downto 0);
  --  RAM0_DI           : in 	  std_logic_vector (7 downto 0);
  --  RAM0_A            : in 	  std_logic_vector (13 downto 0);
  --  RAM0_WEB          : in 	  std_logic;
  --  RAM0_CS           : in 	  std_logic;

  --  xout                : in  std_logic;  -- external high frequency oscillator clock --Now same as the xout clock, by CJ.
    pllout              : in  std_logic;
  --  sel_pll             : in  std_logic;
  --  xout_selected       : out std_logic;
    lp_pwr_ok           : in  std_logic;  -- Core power indicator, controls mrxout_o
  --  rxout               : in  std_logic;  -- 32KHz oscillator input
  --  mrxout_o            : out std_logic;  -- 32KHz oscillator output or external wake
  --  rst_rtc             : in  std_logic;  -- Reset RTC counter byte
  --  en_fclk             : in  std_logic;  -- Enable fast clocking of RTC counter byte
  --  fclk                : in  std_logic;  -- Fast clock to RTC counter byte
    ld_bmem             : in  std_logic;  -- Latch enable to the dis_bmem latch
  --  rtc_sel             : in  std_logic_vector(2 downto 0);  -- RTC byte select
  --  rtc_data            : out std_logic_vector(7 downto 0);  -- RTC data
  --  dis_bmem            : out std_logic;  -- Disable power to BMEM

  --  reset_iso_clear     : in  std_logic;
    halt_en             : in  std_logic;   --high active, will go to halt state
    nap_en              : in  std_logic;   --high active, will go to nap state
    wakeup_lp           : in  std_logic;  -- From wakeup_lp input IO
    poweron_finish      : out std_logic;  --
    reset_iso           : out std_logic;  -- to isolate the pe1_core reset
    reset_core_n        : out std_logic;  -- to reset pe1_core, low active
    io_iso              : out std_logic;  -- to isolate the io signals in nap mode
    nap_rec             : out std_logic;  -- will recover from nap mode
    pmic_core_en        : out std_logic;
    pmic_io_en          : out std_logic
    );
end pe1_rtc;

architecture rtl of pe1_rtc is
  signal cp					: std_logic_vector(46 downto 0);
  signal qn					: std_logic_vector(46 downto 0);

	-- These signals need to be kept through synthesis!

  -- gmem1
  signal c1_gmem_a_iso_0        : std_logic_vector(9 downto 0);
  signal c1_gmem_d_iso_0        : std_logic_vector(7 downto 0);
  signal c1_gmem_we_n_iso_1     : std_logic;
  signal c1_gmem_ce_n_iso_1     : std_logic;

  -- gmem2
  signal c2_gmem_a_iso_0        : std_logic_vector(9 downto 0);
  signal c2_gmem_d_iso_0        : std_logic_vector(7 downto 0);
  signal c2_gmem_we_n_iso_1     : std_logic;
  signal c2_gmem_ce_n_iso_1     : std_logic;

  -- bmem
  signal dbus_iso_0             : std_logic_vector(7 downto 0);
  signal bmem_d_iso_0           : std_logic_vector(7 downto 0);

  -- RAM0
  signal RAM0_DI_iso_0       	: std_logic_vector(7 downto 0);
  signal RAM0_A_iso_0        	: std_logic_vector(13 downto 0);
  signal RAM0_CS_iso_0       	: std_logic;
  signal RAM0_WEB_iso_1      	: std_logic;


  signal clk_mux_out_iso_1      : std_logic;

  signal rst_rtc_iso_0	: std_logic;
  signal en_fclk_iso_0	: std_logic;
  signal fclk_iso_0		  : std_logic;
  signal ld_bmem_iso_0	: std_logic;
  signal rtc_sel_iso_0	: std_logic_vector(2 downto 0);
  signal halt_en_iso_0   : std_logic;
  signal nap_en_iso_0    : std_logic;
  signal sel_pll_iso_0  : std_logic;
  signal pllout_iso_1   : std_logic;
  signal poweron_finish_int : std_logic;
  signal pmic_en_int  : std_logic;
--  signal pwr_switch_on_int : std_logic_vector(3 downto 0);
  signal clk_mux_out_int  : std_logic;
  signal arst_n   : std_logic;
  signal lp_rst_cnt : std_logic_vector(4 downto 0);
  signal core_iso : std_logic;
  signal clk_iso  : std_logic;
  signal lp_rst_cnt_off_int  : std_logic;
  signal pwr_on_rst_n  : std_logic;

  signal c1_gmem_we_iso_1 : std_logic;
  signal c2_gmem_we_iso_1 : std_logic;

  TYPE states IS (INIT, ACT, HALTP, HALTP2, HALTPC, HALT, HALTR, NAPP, NAPP2, NAPPC, NAP, NAPR);
  SIGNAL next_state : states;
  SIGNAL current_state : states;
--
--  signal state  : std_logic_vector(1 downto 0);
--  signal next_state  : std_logic_vector(1 downto 0);
--  constant s0   : std_logic_vector(1 downto 0) := "00";
--  constant s1   : std_logic_vector(1 downto 0) := "01";
--  constant s2   : std_logic_vector(1 downto 0) := "10";
--  constant s3   : std_logic_vector(1 downto 0) := "11";

  --attribute syn_keep	: boolean;
  --attribute syn_keep of rst_rtc_ok	: signal is true;
  --attribute syn_keep of en_fclk_ok	: signal is true;
  --attribute syn_keep of fclk_ok			: signal is true;
  --attribute syn_keep of ld_bmem_ok	: signal is true;
  --attribute syn_keep of rtc_sel_ok	: signal is true;

    -- Isolation cells for the pe1_rtc
  component pe1_rtc_iso
    port (
      iso			        : in  std_logic;  -- isolation controll signal, active high
	  clk_iso				 : in  std_logic;  -- isolation controll signal, active high
      -- signals to be isolated
      halt_en         : in  std_logic;
      nap_en          : in  std_logic;
      ld_bmem			    : in  std_logic;  -- Latch enable to the dis_bmem latch
      clk_mux_out     : in  std_logic;

          --gmem1
      c1_gmem_a         : in    std_logic_vector(9 downto 0);
      c1_gmem_d         : in    std_logic_vector(7 downto 0);
      c1_gmem_we_n      : in    std_logic;
      c1_gmem_ce_n      : in    std_logic;

      --gmem2
      c2_gmem_a         : in    std_logic_vector(9 downto 0);
      c2_gmem_d         : in    std_logic_vector(7 downto 0);
      c2_gmem_we_n      : in    std_logic;
      c2_gmem_ce_n      : in    std_logic;

      --bmem
      dbus              : in    std_logic_vector(7 downto 0);
      bmem_a8           : in    std_logic;
      bmem_d            : in    std_logic_vector(7 downto 0);
      bmem_we_n         : in    std_logic;
      bmem_ce_n         : in    std_logic;

      ld_bmem_iso_0	    : out std_logic;
      halt_en_iso_0   : out std_logic;
      nap_en_iso_0    : out std_logic;

      c1_gmem_a_iso_0   : out std_logic_vector(9 downto 0);
      c1_gmem_d_iso_0   : out std_logic_vector(7 downto 0);

      c2_gmem_a_iso_0   : out std_logic_vector(9 downto 0);
      c2_gmem_d_iso_0   : out std_logic_vector(7 downto 0);

      dbus_iso_0        : out std_logic_vector(7 downto 0);
      bmem_d_iso_0      : out std_logic_vector(7 downto 0);

      clk_mux_out_iso_1   : out  std_logic;

      -- signals isolated to 1
      c1_gmem_we_n_iso_1  : out std_logic;
      c1_gmem_ce_n_iso_1  : out std_logic;
      c2_gmem_we_n_iso_1  : out std_logic;
      c2_gmem_ce_n_iso_1  : out std_logic
      );
  end component;

   -- pe1_gmem
  component SNPS_RF_SP_UHS_1024x8 is
    port (
      Q        : out std_logic_vector(7 downto 0);
      ADR      : in  std_logic_vector(9 downto 0);
      D        : in  std_logic_vector(7 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component FPGA_SY180_1024X8X1CM8
    port(
      A0                         :   IN   std_logic;
      A1                         :   IN   std_logic;
      A2                         :   IN   std_logic;
      A3                         :   IN   std_logic;
      A4                         :   IN   std_logic;
      A5                         :   IN   std_logic;
      A6                         :   IN   std_logic;
      A7                         :   IN   std_logic;
      A8                         :   IN   std_logic;
      A9                         :   IN   std_logic;
      DO0                        :   OUT   std_logic;
      DO1                        :   OUT   std_logic;
      DO2                        :   OUT   std_logic;
      DO3                        :   OUT   std_logic;
      DO4                        :   OUT   std_logic;
      DO5                        :   OUT   std_logic;
      DO6                        :   OUT   std_logic;
      DO7                        :   OUT   std_logic;
      DI0                        :   IN   std_logic;
      DI1                        :   IN   std_logic;
      DI2                        :   IN   std_logic;
      DI3                        :   IN   std_logic;
      DI4                        :   IN   std_logic;
      DI5                        :   IN   std_logic;
      DI6                        :   IN   std_logic;
      DI7                        :   IN   std_logic;
      WEB                        :   IN   std_logic;
      CK                         :   IN   std_logic;
      CSB                        :   IN   std_logic
      );
  end component;

begin  -- rtl

  rtc_iso0: pe1_rtc_iso
    port map (
      iso            => core_iso,
      clk_iso        => clk_iso,
      halt_en        => halt_en,
      nap_en         => nap_en,
      ld_bmem        => ld_bmem,

      c1_gmem_a      =>  c1_gmem_a,
      c1_gmem_d      =>  c1_gmem_d,
      c2_gmem_a      =>  c2_gmem_a,
      c2_gmem_d      =>  c2_gmem_d,
      dbus           =>  dbus,
      bmem_a8        =>  bmem_a8,
      bmem_d         =>  bmem_d,
      clk_mux_out    =>  clk_mux_out_int,

      c1_gmem_we_n   =>  c1_gmem_we_n,
      c1_gmem_ce_n   =>  c1_gmem_ce_n,
      c2_gmem_we_n   =>  c2_gmem_we_n,
      c2_gmem_ce_n   =>  c2_gmem_ce_n,
      bmem_we_n      =>  bmem_we_n,
      bmem_ce_n      =>  bmem_ce_n,

      halt_en_iso_0     => halt_en_iso_0,
      nap_en_iso_0      => nap_en_iso_0,


      c1_gmem_a_iso_0     =>  c1_gmem_a_iso_0,
      c1_gmem_d_iso_0     =>  c1_gmem_d_iso_0,
      c2_gmem_a_iso_0     =>  c2_gmem_a_iso_0,
      c2_gmem_d_iso_0     =>  c2_gmem_d_iso_0,
      dbus_iso_0          =>  dbus_iso_0,
      bmem_d_iso_0        =>  bmem_d_iso_0,
      clk_mux_out_iso_1   =>  clk_mux_out_iso_1,

      c1_gmem_we_n_iso_1  =>  c1_gmem_we_n_iso_1,
      c1_gmem_ce_n_iso_1  =>  c1_gmem_ce_n_iso_1,
      c2_gmem_we_n_iso_1  =>  c2_gmem_we_n_iso_1,
      c2_gmem_ce_n_iso_1  =>  c2_gmem_ce_n_iso_1

      );

  c1_gmem_we_iso_1 <= not c1_gmem_we_n_iso_1;
  c2_gmem_we_iso_1 <= not c2_gmem_we_n_iso_1;

  -- pe1_gmem
gmem_sim_gen : if not USE_ASIC_MEMORIES generate

  -- gmem1
  gmem1: FPGA_SY180_1024X8X1CM8
  PORT MAP (
      A0          => c1_gmem_a_iso_0(0),
      A1          => c1_gmem_a_iso_0(1),
      A2          => c1_gmem_a_iso_0(2),
      A3          => c1_gmem_a_iso_0(3),
      A4          => c1_gmem_a_iso_0(4),
      A5          => c1_gmem_a_iso_0(5),
      A6          => c1_gmem_a_iso_0(6),
      A7          => c1_gmem_a_iso_0(7),
      A8          => c1_gmem_a_iso_0(8),
      A9          => c1_gmem_a_iso_0(9),
      DO0         => c1_gmem_q(0),
      DO1         => c1_gmem_q(1),
      DO2         => c1_gmem_q(2),
      DO3         => c1_gmem_q(3),
      DO4         => c1_gmem_q(4),
      DO5         => c1_gmem_q(5),
      DO6         => c1_gmem_q(6),
      DO7         => c1_gmem_q(7),
      DI0         => c1_gmem_d_iso_0(0),
      DI1         => c1_gmem_d_iso_0(1),
      DI2         => c1_gmem_d_iso_0(2),
      DI3         => c1_gmem_d_iso_0(3),
      DI4         => c1_gmem_d_iso_0(4),
      DI5         => c1_gmem_d_iso_0(5),
      DI6         => c1_gmem_d_iso_0(6),
      DI7         => c1_gmem_d_iso_0(7),
      WEB         => c1_gmem_we_n_iso_1,
      CK          => clk_mux_out_iso_1,
      CSB         => c1_gmem_ce_n_iso_1
      );


-- gmem2
  gmem2: FPGA_SY180_1024X8X1CM8
  PORT MAP (
      A0          => c2_gmem_a_iso_0(0),
      A1          => c2_gmem_a_iso_0(1),
      A2          => c2_gmem_a_iso_0(2),
      A3          => c2_gmem_a_iso_0(3),
      A4          => c2_gmem_a_iso_0(4),
      A5          => c2_gmem_a_iso_0(5),
      A6          => c2_gmem_a_iso_0(6),
      A7          => c2_gmem_a_iso_0(7),
      A8          => c2_gmem_a_iso_0(8),
      A9          => c2_gmem_a_iso_0(9),
      DO0         => c2_gmem_q(0),
      DO1         => c2_gmem_q(1),
      DO2         => c2_gmem_q(2),
      DO3         => c2_gmem_q(3),
      DO4         => c2_gmem_q(4),
      DO5         => c2_gmem_q(5),
      DO6         => c2_gmem_q(6),
      DO7         => c2_gmem_q(7),
      DI0         => c2_gmem_d_iso_0(0),
      DI1         => c2_gmem_d_iso_0(1),
      DI2         => c2_gmem_d_iso_0(2),
      DI3         => c2_gmem_d_iso_0(3),
      DI4         => c2_gmem_d_iso_0(4),
      DI5         => c2_gmem_d_iso_0(5),
      DI6         => c2_gmem_d_iso_0(6),
      DI7         => c2_gmem_d_iso_0(7),
      WEB         => c2_gmem_we_n_iso_1,
      CK          => clk_mux_out_iso_1,
      CSB         => c2_gmem_ce_n_iso_1
      );

end generate;

gmem_asic_gen : if USE_ASIC_MEMORIES generate

  -- gmem1
  gmem1: SNPS_RF_SP_UHS_1024x8
  port map (
      Q        => c1_gmem_q,
      ADR      => c1_gmem_a_iso_0,
      D        => c1_gmem_d_iso_0,
      WE       => c1_gmem_we_iso_1,
      ME       => '1', -- c1_gmem_ce_n_iso_1
      CLK      => clk_mux_out_iso_1,
      TEST1    => '0',
      TEST_RNM => '0',
      RME      => '0',
      RM       => (others => '0'),
      WA       => (others => '0'),
      WPULSE   => (others => '0'),
      LS       => '0',
      BC0      => '0',
      BC1      => '0',
      BC2      => '0');

  -- gmem2
  gmem2: SNPS_RF_SP_UHS_1024x8
  port map (
      Q        => c2_gmem_q,
      ADR      => c2_gmem_a_iso_0,
      D        => c2_gmem_d_iso_0,
      WE       => c2_gmem_we_iso_1,
      ME       => '1', -- c2_gmem_ce_n_iso_1
      CLK      => clk_mux_out_iso_1,
      TEST1    => '0',
      TEST_RNM => '0',
      RME      => '0',
      RM       => (others => '0'),
      WA       => (others => '0'),
      WPULSE   => (others => '0'),
      LS       => '0',
      BC0      => '0',
      BC1      => '0',
      BC2      => '0');

end generate;


   --Clock switching logic, designed to handle asynchronous clocks.
  -- clk_mux_1: clk_mux
  -- port map (
  --  clk1          => xout,
  --  clk2          => pllout_iso_1,
  --  sel           => sel_pll_iso_0,
  --  rst_n         => lp_pwr_ok,
  --  clk1_selected => xout_selected,
  --  clk_mux_out   => clk_mux_out_int);
   clk_mux_out_int <= pllout;

   --clk_mux_2: clk_mux
   --port map (
   -- clk1          => clk_mux_out1,
   -- clk2          => hf_osc,
   -- sel           => lp_mode_latch,
   -- rst_n         => rst_n,
   -- clk_mux_out   => clk_mux_out2);
   --clk_p_int   <= clk_mux_out2;


	-- Disable latch for the power to BMEM
  --process (ld_bmem_iso_0, rtc_sel_iso_0)
  --begin
	--	if ld_bmem_iso_0 = '1' then
	--		dis_bmem <= rtc_sel_iso_0(0);
	--	end if;
  --end process;



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

pwr_mode_state : process (clk_mux_out_int,pwr_on_rst_n)
begin
  if pwr_on_rst_n = '0' then
    current_state <= INIT;
  elsif rising_edge(clk_mux_out_int) then
    current_state <= next_state;
  end if;
end process pwr_mode_state;

pwr_mode_next : process (current_state, halt_en_iso_0, nap_en_iso_0, wakeup_lp, lp_rst_cnt_off_int )
begin
    CASE current_state IS
		WHEN INIT 		=>
		    next_state <= ACT;

        WHEN ACT 		=>
		    IF halt_en_iso_0 = '1' THEN
		        next_state <= HALTP;
		    ELSIF nap_en_iso_0 = '1' THEN
		        next_state <= NAPP;
		    ELSE
		        next_state <= ACT;
		    END IF;

		WHEN HALTP 		=>
		    next_state <= HALTP2;

		WHEN HALTP2		=>
		    next_state <= HALTPC;

		WHEN HALTPC		=>
		    next_state <= HALT;

		WHEN HALT 		=>
		    IF wakeup_lp = '1' THEN
		        next_state <= HALTR;
		    ELSE
		        next_state <= HALT;
		    END IF;

		WHEN HALTR 		=>
		    IF lp_rst_cnt_off_int = '1' THEN
		        next_state <= ACT;
		    ELSE
		        next_state <= HALTR;
		    END IF;

		WHEN NAPP 		=>
		    next_state <= NAPP2;

		WHEN NAPP2 		=>
		    next_state <= NAPPC;

		WHEN NAPPC 		=>
		    next_state <= NAP;

		WHEN NAP 		=>
		    IF wakeup_lp = '1' THEN
		        next_state <= NAPR;
		    ELSE
		        next_state <= NAP;
		    END IF;

		WHEN NAPR 		=>
		    IF lp_rst_cnt_off_int = '1' THEN
		        next_state <= ACT;
		    ELSE
		        next_state <= NAPR;
		    END IF;

		WHEN OTHERS 	=>
    	  next_state <= INIT;
	END CASE;
end process pwr_mode_next;

--make all the control signals to be regestered
pwr_mode_signals : process (clk_mux_out_int,pwr_on_rst_n)
begin
    IF pwr_on_rst_n = '0'   THEN
        pmic_core_en    <= '1';
		pmic_io_en      <= '1';
		core_iso        <= '1';
		clk_iso         <= '1';
		reset_core_n    <= '0';
		nap_rec         <= '0';
    ELSIF rising_edge(clk_mux_out_int) THEN
        IF next_state = HALT THEN
            pmic_core_en    <= '0';
        ELSIF wakeup_lp = '1' THEN
            pmic_core_en    <= '1';
        END IF;

        IF next_state = HALT or next_state = NAP THEN
            pmic_io_en    <= '0';
        ELSIF wakeup_lp = '1' THEN
            pmic_io_en    <= '1';
        END IF;

        IF next_state = ACT THEN
            core_iso    <= '0';
        ELSE
            core_iso    <= '1';
        END IF;

        IF next_state = ACT or next_state = HALTP or next_state = HALTP2 or next_state = NAPP or next_state = NAPP2 THEN
            clk_iso    <= '0';
        ELSE
            clk_iso    <= '1';
        END IF;

        IF next_state = HALTR THEN
            reset_core_n    <= '0';
        ELSIF next_state = ACT THEN
            reset_core_n    <= '1';
        END IF;

        IF next_state = NAPR THEN
            nap_rec    <= '1';
        ELSE
            nap_rec    <= '0';
        END IF;

	END IF;

end process pwr_mode_signals;

io_iso <= core_iso;

process (clk_mux_out_int,pwr_on_rst_n)
begin
  if pwr_on_rst_n = '0' then
        poweron_finish_int <= '0';
  elsif rising_edge(clk_mux_out_int) then
        if halt_en_iso_0 = '1' then
            poweron_finish_int <= '1';
        end if;
  end if;
end process;

process (clk_mux_out_int,pwr_on_rst_n)
begin
  if pwr_on_rst_n = '0' then
        reset_iso <= '0';
  elsif rising_edge(clk_mux_out_int) then
        --if reset_iso_clear_iso_0 = '1' then
        --    reset_iso <= '0';
        if wakeup_lp = '1' and current_state = HALT then
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


  -- The ripple counter clocks. For setting counter more efficiently, the
  -- counter is split up into 6 parts. 'fclk_ok' may clock these parts separately.
  --cp_gen: process (qn, en_fclk_iso_0, fclk_iso_0, rxout, rtc_sel_iso_0)
  --begin
  --  -- Normal clocking. All FF:s in one long ripple counter chain.
  --  cp(0) <= rxout;
  --  for i in 1 to 46 loop
  --    cp(i) <= qn(i - 1);
  --  end loop;
  --  -- Fast clocking. The selected byte is clocked by fclk_ok.
  --  if en_fclk_iso_0 = '1' then
  --    if rtc_sel_iso_0 = 0 then
  --      cp(0) <= fclk_iso_0;
  --    end if;
  --    for i in 1 to 5 loop
  --      if rtc_sel_iso_0 = i then
  --        cp((i*8)-1) <= fclk_iso_0;
  --      end if;
  --    end loop;
  --  end if;
  --end process cp_gen;

  -- The 47 bits ripple counter.
  --async_ripple_counter: for i in 0 to 46 generate
  --  d_ff: block
  --  begin  -- block d_ff
  --    process (cp(i), rst_rtc_iso_0, rtc_sel_iso_0)
  --    begin  -- process
  --      if rst_rtc_iso_0 = '1' and rtc_sel_iso_0 = ((i+1)/8) then
  --        qn(i) <= '1';
  --      elsif rising_edge(cp(i)) then
  --        qn(i) <= not qn(i);
  --      end if;
  --    end process;
  --  end block d_ff;
  --end generate async_ripple_counter;

  -- Mux for the output data. All six bytes of the counter can be read,
  -- the other two rtc_sel_ok combinations output test data.
  --with rtc_sel_iso_0 select
  --  rtc_data <= not qn(6 downto 0) & '0'  when "000",
  --              not qn(14 downto 7)       when "001",
  --              not qn(22 downto 15)      when "010",
  --              not qn(30 downto 23)      when "011",
  --              not qn(38 downto 31)      when "100",
  --              not qn(46 downto 39)      when "101",
  --              rst_rtc_iso_0 & en_fclk_iso_0 & fclk_iso_0 & ld_bmem_iso_0 &
  --              rtc_sel_iso_0(0) & rtc_sel_iso_0(0) & rtc_sel_iso_0(0) & rtc_sel_iso_0(0) when others;

	-- MRXOUT is now only an external wake-up signal, RTC
	-- oscillator test is done on another pin.
  --mrxout_o <= qn(46);
end rtl;
