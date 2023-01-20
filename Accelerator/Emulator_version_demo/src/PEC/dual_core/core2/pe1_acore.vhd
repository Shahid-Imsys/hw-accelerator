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
-- Title      : Core logic
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pe1_core.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: auxiliary core
--              only contain pe1_alu, pe1_mbm, pe1_dsl, pe1_clc, pe1_mmr, pe1_gmem moduls
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.11			CB			Created
-- 2005-12-21		2.12			CB			Changed polarity of memory control signals.
-- 2006-01-26		2.13			CB			Added BMEM signals.
-- 2006-02-01		2.14			CB			Added the ld_bmem signal.
-- 2006-02-03		2.15			CB			Changed back polarity of memory control signals.
-- 2006-02-17		2.16			CB			Added soft drive strength and slew rate control.
-- 2006-03-08		2.17 			CB			Changed pwr_on to pwr_ok.
-- 2006-03-17		3.18 			CB			Added test_pll.
-- 2006-03-21		3.19 			CB			Removed en_c, added sel_pll and rst_n.
-- 2006-04-03		3.20 			CB			Removed 'freeze' and 'locked', PLL doesn't
--																support them.
-- 2006-05-04		3.21 			CB			Connected LATCH instead of D-bus to the pe1_mpgm block.
-- 2006-05-08		3.22 			CB			Removed d_bittst from MBM to CLC, added d_sign
--																from DSL to CLC instead.
-- 2012-06-14       4.0             MN          Add clk_in_off and clk_main_off
-- 2012-07-12		4.1				MN			change mxout_o and mexec_o related to mtest_i, change rst_cn_int to rst_en_int for pe1_crb
-- 2012-12-14       5.0             MN          modify the whole module to auxiliary core in dual core system
-- 2015-07-09       5.1             MN          add crb_out from core1, add core2_en_buf for transferring core2_en from core1
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity pe1_acore is
  generic ( USE_ASIC_MEMORIES : boolean := true );
  port (
---------------------------------------------------------------------
    -- Signals to/from other blocks
---------------------------------------------------------------------
    -- Clocks to/from clock block
    clk_p       : in  std_logic;  -- PLL clock
    even_c      : in std_logic;
    -- Control outputs to the clock block
    --ID
    id_number    : in std_logic_vector(5 downto 0); --Added by CJ
    -- signals from the master core
    core2_en    : in  std_logic;  -- core2 enable
    rst_cn          : in std_logic;
	rsc_n           : in std_logic;
	clkreq_gen      : in std_logic;
    crb_out     : in std_logic_vector(7 downto 0);
    en_wdog     : in std_logic;
    pup_clk     : in std_logic;
    pup_irq    	: in std_logic_vector(1 downto 0);
    r_size     	: in std_logic_vector(1 downto 0);
    c_size     	: in std_logic_vector(1 downto 0);
    t_ras      	: in std_logic_vector(2 downto 0);
    t_rcd      	: in std_logic_vector(1 downto 0);
    t_rp       	: in std_logic_vector(1 downto 0);
--    en_mexec   	: in std_logic;
    dqm_size    : in std_logic_vector(1 downto 0);   --input from pe1_crb
    fast_d      : in std_logic;  -- clk_d speed select     input from pe1_crb
    short_cycle : in std_logic;
    -- signal to core1
    crb_sel     : out std_logic_vector(3 downto 0);
    irq0        : in  std_logic;  -- Interrupt request 0
    irq1        : in  std_logic;  -- Interrupt request 1
---------------------------------------------------------------------
    -- Memory signals
---------------------------------------------------------------------
    -- MPRAM signals
    mpram_a     : out std_logic_vector(7 downto 0);-- Address
    mpram_d     : out std_logic_vector(127 downto 0);-- Data to memory
    mpram_ce    : out std_logic_vector(1 downto 0); -- Chip enable(active high)
    --mpram_oe    : out std_logic_vector(1 downto 0); -- Output enable(active high)
    --mpram_we_n  : out std_logic;                    -- Write enable(active low)
    -- MPROM/MPRAM data out bus
    mp_q        : in  std_logic_vector(127 downto 0);-- Data from MPROM/MPRAM
    -- GMEM signals
    gmem_a      : out std_logic_vector(9 downto 0);
    gmem_d      : out std_logic_vector(7 downto 0);
    gmem_q      : in  std_logic_vector(7 downto 0);
    gmem_ce_n   : out std_logic;
    gmem_we_n   : out std_logic;
    -- CC signal
    req_c2    : out std_logic;
    req_rd_c2 : out std_logic;
    ack_c2    : in std_logic;
    ddi_vld   : in std_logic; --Added by CJ
    exe       : in std_logic; --CONT need to be added
    resume    : in std_logic;
    ready     : out std_logic;
    -- CC interface signals
    din_c       : in std_logic_vector(127 downto 0);
    dout_c      : out std_logic_vector(159 downto 0)

    );

end pe1_acore;

architecture struct of pe1_acore is
---------------------------------------------------------------------
-- Internal signals
---------------------------------------------------------------------
  -- Microinstruction pipeline register
  signal pl         : std_logic_vector(127 downto 0);
  signal core2_en_buf : std_logic;
  signal vldl       : std_logic;
  signal vldl_2     : std_logic;
  signal ready_1    : std_logic;
  -- Named fields of the pipeline register input
  signal mp_miform  : std_logic;
  signal mp_ds      : std_logic_vector(3 downto 0);
  signal mp_alud    : std_logic;
  signal mp_shin_pa : std_logic_vector(3 downto 0);
  signal mp_gass    : std_logic_vector(1 downto 0);
  signal mpgmin     : std_logic_vector(127 downto 0);

  signal odd_c      : std_logic;
  signal clk_e_pos_int  : std_logic;  -- Execution clock
  signal clk_e_neg_int  : std_logic;  -- Execution clock
  -- TIM signals
  --signal gate_e     : std_logic;
  signal held_e     : std_logic;
  --signal pend_i     : std_logic;
  signal ld_mar     : std_logic;
  --signal runmode    : std_logic;
  signal rst_en_int : std_logic;
  signal hold_e_int : std_logic;

  -- CLC signals
  signal sleep      : std_logic;
  signal inv_psmsb  : std_logic;
  signal trace      : std_logic;
  signal ld_nreg    : std_logic;
  signal reqrun     : std_logic;
  --signal wdog_n     : std_logic;
  --signal ld_crb     : std_logic;
  --signal rst_seqc_n : std_logic;
  signal dsi        : std_logic_vector(7 downto 0);
  signal mpga       : std_logic_vector(7 downto 0);
  signal curr_mpga  : std_logic_vector(7 downto 0);
  --signal mar        : std_logic_vector(7 downto 0);

  -- ALU signals
  signal flag_fn      : std_logic;
  signal flag_fc      : std_logic;
  signal flag_fz      : std_logic;
  signal flag_fv      : std_logic;
  signal flag_fh      : std_logic;
  signal flag_fp      : std_logic;
  signal flag_neg     : std_logic;
  signal flag_carry   : std_logic;
  signal flag_zero    : std_logic;
  signal flag_oflow   : std_logic;
  signal flag_link    : std_logic;
  signal flag_pccy    : std_logic;
  signal flag_qlsb    : std_logic;
  signal ybus         : std_logic_vector(7 downto 0);
  signal y_reg        : std_logic_vector(7 downto 0);

  -- GMEM signals
  signal ira2       : std_logic;
  signal psc_afull  : std_logic;
  signal psc_full   : std_logic;
  signal psc_aempty : std_logic;
  signal psc_empty  : std_logic;
  signal gctr       : std_logic_vector(7 downto 0);
  signal gdata      : std_logic_vector(7 downto 0);
  signal g_direct   : std_logic_vector(7 downto 0);

  -- DSL signals
  signal flag_yeqneg  : std_logic;
  signal rd_gmem      : std_logic;
  signal rd_crb       : std_logic;
  signal d_sign       : std_logic;
  signal dbus_int     : std_logic_vector(7  downto 0);
  signal latch        : std_logic_vector(7  downto 0);
  signal cdfm_int     : std_logic_vector(7 downto 0); --Added by CJ

  -- MBM signals
  signal mbmd       : std_logic_vector(7 downto 0);
  signal y_bittst   : std_logic;

  -- MMR signals
  signal dfm        : std_logic_vector(7 downto 0);
  signal direct     : std_logic_vector(7 downto 0);
  signal use_direct : std_logic;
  signal dbl_direct : std_logic;
  --signal sel_direct : std_logic_vector(1 downto 0);
  signal g_double   : std_logic;
  --signal lmpen      : std_logic;
  signal adl_cy     : std_logic;
  signal mmr_hold_e : std_logic;
  signal dfm_rdy    : std_logic; --CJ
  signal dtm_fifo_rdy : std_logic; --CJ
  signal dtm_buf_empty : std_logic;

  -- CPC signals
--  signal plsel_n      : std_logic;
--  signal plcpe_n      : std_logic;
  --signal spack_cmd    : std_logic;
  --signal gen_spreq    : std_logic;
  --signal byte_sel     : std_logic_vector(3 downto 0);
  --signal wmlat        : std_logic;
  signal dtal         : std_logic_vector(7 downto 0);
  signal dtcl         : std_logic_vector(7 downto 0);
  --signal mpram_we_nint: std_logic;

  --signal ios_hold_e : std_logic;
  signal req        : std_logic;
  signal req_rd     : std_logic;
  signal ack        : std_logic;
  --VE signals
  signal ve_in_int  : std_logic_vector(63 downto 0);
  signal ve_rdy_int : std_logic;
  signal re_rdy_int : std_logic;
  signal ve_out_d_int : std_logic_vector(7 downto 0);
  signal ve_out_dtm_int : std_logic_vector(127 downto 0);
  signal ve_dtm_rdy_int : std_logic;
  signal ve_push_dtm_int : std_logic;
  signal ve_auto_send_int : std_logic;

  attribute syn_keep              : boolean;
  --attribute syn_keep of pend_i    : signal is true;
  -- To easy gate-level simulation
  attribute syn_keep of dbus_int  : signal is true;
  attribute syn_keep of ybus      : signal is true;
  attribute syn_keep of curr_mpga : signal is true;

begin
  req_c2 <= req;
  req_rd_c2 <= req_rd;
  ack    <= ack_c2;
  ready_1  <= pl(127) and not dtm_fifo_rdy;
  dfm_rdy <= ddi_vld;
---------------------------------------------------------------------
-- External test clock gating
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Signals also used by Peri block
---------------------------------------------------------------------
  --rst_en <= rst_en_int;
  --dbus <= dbus_int;
  --pd <= (pl(19) xor pl(66))&(pl(43) xor pl(39))& pl(38);
  --aaddr <= pl(23)&pl(6)&pl(54)&pl(27)&pl(49);

---------------------------------------------------------------------
-- Microinstruction pipeline register
---------------------------------------------------------------------
  -- If plsel_n is high, this register clocks in the entire
  -- microinstruction word from the microprogram memories and holds
  -- it during execution.
  -- If plsel_n and plcpe_n are low, the data from the MPLL (udo) is
  -- loaded instead.
  -- microinstruction word from the microprogram memories and holds
  -- it during execution.
  -- If plsel_n is low and plcpe_n is high, loading is inhibited and
  -- the register keeps a previously loaded instruction.
  --pl_out <= pl
  ready_delay: process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_en_int = '0' then
        ready <= '0';
      else
        ready <= ready_1;
      end if;
    end if;
  end process;

  data_vld_latch: process(clk_p) --half clk_e latchvariable mid : std_logic;
  begin
      if rising_edge(clk_p) then
        if rst_en_int = '0' then
          vldl <= '0';
        else
          vldl <= ddi_vld;
        end if;
      end if;
  end process;
  data_vld_latch_2 : process(clk_p)
  begin
    if rising_edge(clk_p) then
      vldl_2 <=vldl;
    end if;
  end process;

  pl_reg: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_e)
      core2_en_buf <= core2_en;
      if rst_en_int = '0' then
        pl <= x"00000000000000000000000000000000";
        core2_en_buf <= '0';
      elsif clk_e_pos_int = '0' then
        pl <= mp_q;
      end if;
    end if;
  end process pl_reg;

  crb_sel <= pl(6)&pl(54)&pl(27)&pl(49)  when rd_crb = '1' else --pl_sig15
              "0000";
  -- Some fields have to be accessed directly from the microprogram
  -- memory bus, to determine if a read operation in the GMEM should
  -- be performed at the leading edge of the instruction cycle.

  mp_miform  <= mp_q(45);
  mp_ds      <= mp_q(50)&mp_q(22)&mp_q(14)&mp_q(44);
  mp_alud    <= mp_q(71) xor mp_q(77);
  mp_shin_pa <= (mp_q(60) xor mp_q(68))&mp_q(56)&(mp_q(16) xor mp_q (35))&mp_q(68);
  mp_gass    <= mp_q(0)&mp_q(41);

  odd_c <= not even_c;
---------------------------------------------------------------------
-- MPGM
---------------------------------------------------------------------
  pe1_mpgm: entity work.pe1_ampgm
    port map (
      -- Clock and reset
	  core2_en    => core2_en_buf,
      --rst_cn      => rst_cn,
      --clk_e_neg       => clk_e_neg_int,
      --clk_p       => clk_p,
      -- Control signals
      even_c      => odd_c,
      --held_e      => held_e,
      -- Inputs
      mpga        => mpga,
      -- Outputs to MPRAM/MPROM
      mpram_a     => mpram_a,
      --mpram_oe    => mpram_oe,
      mpram_ce    => mpram_ce
      );

  --mprom_a     <= mpga;
  mpram_d     <= mpgmin;--(others => '1');
  --mpram_we_n  <= '1';

---------------------------------------------------------------------
-- TIM - timing logic
---------------------------------------------------------------------
  hold_e_int <= mmr_hold_e;

  pe1_atim: entity work.pe1_atim
    port map (
      -- Clock
      clk_p       => clk_p,
      clk_c2_pos  => odd_c,
      clk_e_pos   => clk_e_pos_int,
      clk_e_neg	  => clk_e_neg_int,
      even_c      => even_c,
      rst_cn      => rst_cn,
	    core2_en    => core2_en_buf,
      -- Inputs from other pe1_core blocks
      hold_e      => hold_e_int,
      rsc_n       => rsc_n,
      reqrun      => reqrun,
      sleep       => sleep,
      -- Outputs to outside pe1_core
      --din_e       => din_e,
      -- Outputs to other pe1_core blocks
      --gate_e      => gate_e,
      held_e      => held_e,
      ld_mar      => ld_mar,
      runmode     => open,
      rst_en      => rst_en_int);


---------------------------------------------------------------------
-- CLC
---------------------------------------------------------------------
  pe1_clc: entity work.pe1_clc
    port map (
      -- Clock and reset inputs
      clk_p         => clk_p,
      clk_e_pos      => clk_e_pos_int,
      rst_en        => rst_en_int,
      -- Microprogram fields
      pl            => pl,
      ld_mpgm       => std_logic'('0'),
      -- Static control inputs
      dbl_direct    => dbl_direct,
      pup_irq       => pup_irq,
      pup_clk       => pup_clk,
      en_wdog       => en_wdog,
      -- Control inputs
      ld_mar        => ld_mar,
      clkreq_gen    => clkreq_gen,
      ira2          => ira2,
      irq0          => irq0,
      irq1          => irq1,
      --dfm_vld       => ddi_vld,  --Added by CJ
      mp_vld        => std_logic'('0'),     --Added by CJ
      -- Condition inputs
      spreq_n       => std_logic'('1'), --'1',
      spack_n       => std_logic'('1'), --'1',
      d_sign      	=> d_sign,
      y_bittst      => y_bittst,
      flag_fn       => flag_fn,
      flag_fc       => flag_fc,
      flag_fz       => flag_fz,
      flag_fv       => flag_fv,
      flag_fh       => flag_fh,
      flag_fp       => flag_fp,
      flag_neg      => flag_neg,
      flag_carry    => flag_carry,
      flag_zero     => flag_zero,
      flag_oflow    => flag_oflow,
      flag_link     => flag_link,
      flag_pccy     => flag_pccy,
      flag_qlsb     => flag_qlsb,
      psc_afull     => psc_afull,
      psc_full      => psc_full,
      psc_aempty    => psc_aempty,
      psc_empty     => psc_empty,
      flag_yeqneg   => flag_yeqneg,
      adl_cy        => adl_cy,
      re_rdy        => re_rdy_int, --Added by CJ
      ve_rdy        => ve_rdy_int, --Added by CJ
      dfm_rdy       => dfm_rdy,--Added by CJ
      fifo_rdy      => dtm_fifo_rdy, --Added by CJ
      buf_empty     => dtm_buf_empty,
      continue      => resume,   --Added by CJ
      --Data Inputs
      dbus          => dbus_int,
      y_reg         => y_reg,
      dtcl          => dtcl,
      dfm           => dfm,
      --Control Outputs
      sleep         => sleep,
      inv_psmsb     => inv_psmsb,
      trace         => trace,
      ld_nreg       => ld_nreg,
      reqrun        => reqrun,
      wdog_n        => open,
      ld_crb        => open,
      rst_seqc_n    => open,
      --Data Outputs
      dsi           => dsi,
      --Microprogram address outputs
      mpga          => mpga,
      curr_mpga     => curr_mpga,
      mar           => open);

---------------------------------------------------------------------
-- ALU
---------------------------------------------------------------------
  pe1_alu: entity work.pe1_alu
    port map (
      -- Clock input
      clk_p         => clk_p,
      clk_e_pos     => clk_e_pos_int,
	    rst_n	  		=> rst_en_int,
      -- Microprogram fields
      pl            => pl,
      init_load     => std_logic'('0'),
      --Data inputs
      dbus          => dbus_int,
      -- Flags
      flag_fn       => flag_fn,
      flag_fc       => flag_fc,
      flag_fz       => flag_fz,
      flag_fv       => flag_fv,
      flag_fh       => flag_fh,
      flag_fp       => flag_fp,
      flag_neg      => flag_neg,
      flag_carry    => flag_carry,
      flag_zero     => flag_zero,
      flag_oflow    => flag_oflow,
      flag_link     => flag_link,
      flag_pccy     => flag_pccy,
      flag_qlsb     => flag_qlsb,
      --Data outputs
      ybus          => ybus,
      y_reg         => y_reg);

---------------------------------------------------------------------
-- GMEM
---------------------------------------------------------------------
  pe1_gmem: entity work.pe1_gmem
    port map (
			-- Clock and reset inputs
      rst_en     => rst_en_int,
      clk_p      => clk_p,
      clk_e_pos   => clk_e_pos_int,
      clk_e_neg   => clk_e_neg_int,
      --gate_e     => clk_e_pos_int,
      held_e     => held_e,
      -- Microprogram fields
      pl         => pl,
      mp_gass	 => mp_gass,
      -- Static control inputs
      use_direct => use_direct,
      dbl_direct => dbl_direct,
      g_double   => g_double,
      -- Control Inputs
      rd_gmem    => rd_gmem,
      inv_psmsb  => inv_psmsb,
      -- Data Inputs
      dbus       => dbus_int,
      ybus       => ybus,
      direct     => direct,
      -- Control Outputs
      ira2       => ira2,
      psc_afull  => psc_afull,
      psc_full   => psc_full,
      psc_aempty => psc_aempty,
      psc_empty  => psc_empty,
      -- Data Outputs
      gctr       => gctr,
      gdata      => gdata,
      g_direct   => g_direct,
      -- GMEM signals
      gmem_ce_n  => gmem_ce_n,
      gmem_we_n  => gmem_we_n,
      gmem_a     => gmem_a,
      gmem_d     => gmem_d,
      gmem_q     => gmem_q);

---------------------------------------------------------------------
-- DSL
---------------------------------------------------------------------
  pe1_dsl: entity work.pe1_dsl
    port map (
      -- Clock input
	  rst_en       => rst_en_int,
      clk_p         => clk_p,
      clk_e_pos      => clk_e_pos_int,
      -- Microprogram fields
      pl            => pl,
      mp_ds         => mp_ds,
      mp_miform     => mp_miform,
      mp_shin_pa    => mp_shin_pa,
      mp_alud       => mp_alud,
      -- Data Inputs
      flag_neg      => flag_neg,
      flag_carry    => flag_carry,
      flag_zero     => flag_zero,
      flag_oflow    => flag_oflow,
      flag_link     => flag_link,
      flag_pccy     => flag_pccy,
      inv_psmsb     => inv_psmsb,
      trace         => trace,
      ybus          => ybus,
      y_reg         => y_reg,
      mbmd          => mbmd,
      gctr          => gctr,
      crb_out       => crb_out,
      dfm           => dfm,
      dsi           => dsi,
      gdata         => gdata,
      dtal          => dtal,
       --CJ added
       VE_OUT_D      => ve_out_d_int,
       CDFM         => cdfm_int,
       ID_NUM       => id_number,
       --VE_OUT_SING   => ve_out_sing_int,
      -- Control Output
      flag_yeqneg   => flag_yeqneg,
      load_b        => open,
      rd_gmem       => rd_gmem,
      rd_crb        => rd_crb,
      d_sign				=> d_sign,
      -- Data Outputs
      dbus          => dbus_int,
      latch         => latch);

---------------------------------------------------------------------
-- MBM
---------------------------------------------------------------------
  pe1_mbm: entity work.pe1_mbm
    port map (
      -- Clock input
      clk_p     =>  clk_p,
      clk_e_pos     =>  clk_e_pos_int,
		rst_en       => rst_en_int,
      -- Microprogram fields
      pl        =>  pl,
      -- Control inputs
      ld_nreg   =>  ld_nreg,
      -- Data inputs
      ybus      =>  ybus,
      y_reg     =>  y_reg,
      latch     =>  latch,
      -- Data outputs
      mbmd      =>  mbmd,
      y_bittst  =>  y_bittst);

---------------------------------------------------------------------
-- MMR
---------------------------------------------------------------------
  pe1_mmr: entity work.pe1_mmr
    port map (
      -- Clock and reset functions
      rst_en      => rst_en_int,
      clk_p       => clk_p,
      clk_e_neg    => clk_e_neg_int,
      clk_c2_pos      => odd_c,
      clk_e_pos       => clk_e_pos_int,
      --gate_e      => clk_e_pos_int,
      even_c      => odd_c,
      held_e      => held_e,
      -- Microprogram control
      pl          => pl,
      -- Static control inputs
      r_size      => r_size,
      c_size      => c_size,
      dqm_size    => dqm_size,
      t_ras       => t_ras,
      t_rcd       => t_rcd,
      t_rp        => t_rp,
      fast_d      => fast_d,
      short_cycle => short_cycle,
      -- Data paths
      dbus        => dbus_int,
      ybus        => ybus,
      g_direct    => g_direct,
      dfm         => dfm,
      direct      => direct,
      -- Outputs
      use_direct  => use_direct,
      dbl_direct  => dbl_direct,
      sel_direct  => open,
      g_double    => g_double,
      lmpen       => open,
      adl_cy      => adl_cy,
      hold_e      => mmr_hold_e);
---------------------------------------------------------------------
-- VE
---------------------------------------------------------------------
      --CJ Added
      vector_engine : entity work.ve
      generic map( USE_ASIC_MEMORIES => USE_ASIC_MEMORIES )
      port map(
      CLK_P       => clk_p,
      CLK_E_POS   => clk_e_pos_int,
      CLK_E_NEG   => clk_e_neg_int,
      RST         => rst_en_int,
      PL          => pl,
      YBUS        => ybus,
      DDI_VLD     => vldl_2,--replace it with vldl in later version
      RE_RDY      => re_rdy_int,
      VE_RDY      => ve_rdy_int,
      VE_IN       => ve_in_int,
      VE_DTM_RDY  => ve_dtm_rdy_int,
      VE_PUSH_DTM => ve_push_dtm_int,
      VE_AUTO_SEND => ve_auto_send_int,
      VE_OUT_D    => ve_out_d_int,
      VE_OUT_DTM  => ve_out_dtm_int
      );
---------------------------------------------------------------------
-- CMDR
---------------------------------------------------------------------
--Interface of the pe1_core and cluster controller
      cmdr: entity work.pe1_acmdr
      port map(
        CLK_P    => clk_p,
        RST_EN   => rst_en_int,
        CLK_E_POS => clk_e_pos_int,
        PL       => pl,
        --EXE      => exe,
        DATA_VLD => ddi_vld,
        REQ_OUT  => req,
        REQ_RD_OUT => req_rd,
        ACK_IN   => ack,
        DIN      => din_c,
        DOUT     =>dout_c,
        YBUS     =>ybus,
        LD_MPGM  =>std_logic'('0'),
        VE_DIN   =>ve_in_int,
        DBUS_DATA=>cdfm_int,
        MPGMM_IN =>mpgmin,
        DTM_FIFO_RDY => dtm_fifo_rdy,
        dtm_buf_empty => dtm_buf_empty,
        VE_DTMO  =>ve_out_dtm_int,
        VE_DTM_RDY => ve_dtm_rdy_int,
        VE_PUSH_DTM => ve_push_dtm_int,
        VE_AUTO_SEND => ve_auto_send_int
      );

    dtal <= x"00";
    dtcl <= x"00";
end;