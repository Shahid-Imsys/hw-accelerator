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
-- File       : core.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description:
--              
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
-- 2006-05-04		3.21 			CB			Connected LATCH instead of D-bus to the mpgm block.
-- 2006-05-08		3.22 			CB			Removed d_bittst from MBM to CLC, added d_sign
--																from DSL to CLC instead.
-- 2012-06-14       4.0             MN          Add clk_in_off and clk_main_off
-- 2012-07-12		4.1				MN			change mxout_o and mexec_o related to mtest_i, change rst_cn_int to rst_en_int for crb 
-- 2014-07-22       5.0             MN          add flash interface, and hold_e from flash
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity core is
  port (
---------------------------------------------------------------------
    -- Signals to/from other blocks
---------------------------------------------------------------------
    -- Clocks to/from clock block
    clk_p       : in  std_logic;  -- PLL clock
    clk_c_en    : in  std_logic;  -- CP clock
    even_c      : in  std_logic;
    --clk_c2_pos   : in  std_logic;  -- clk_c / 2 
    clk_e_pos    : out  std_logic;  -- Execution clock
    clk_e_neg    : out  std_logic;  -- Execution clock
    clk_i_pos       : in  std_logic;  -- I/O clock
    clk_d_pos       : in  std_logic;  -- DRAM clock
    clk_s_pos       : in  std_logic;  -- SP clock
    -- Control outputs to the clock block
    rst_n       : out std_logic;  -- Asynchronous reset to clk_gen
    rst_cn      : out std_logic;  -- Reset, will hold all clocks except c,rx,tx
    en_d        : out std_logic;  -- Enable clk_d
    fast_d      : out std_logic;  -- clk_d speed select 
    --din_e       : out std_logic;  -- D input to FF generating clk_e
    din_i       : out std_logic;  -- D input to FF generating clk_i
    din_u       : out std_logic;  -- D input to FF generating clk_u
    din_s       : out std_logic;  -- D input to FF generating clk_s
    clk_in_off  : out std_logic;  -- close all input clock
    clk_main_off : out std_logic; -- close main clock except clk_p
    sdram_en : out std_logic; --off chip sdram enable 
    --flash Control   
    out_line    :   out std_logic;  -- one line is 8x4 = 32 bytes
    hold_flash  : in std_logic;
    hold_flash_d: in std_logic;
    flash_en    : out std_logic;
    flash_mode  : out std_logic_vector (3 downto 0);
	  ld_dqi_flash: in std_logic;
    -- Control signals to/from the oscillator and PLL
    pll_frange  : out std_logic;  -- Frequency range select
    pll_n       : out std_logic_vector(5 downto 0);   -- Multiplier
    pll_m       : out std_logic_vector(2 downto 0);   -- Divider
    en_xosc     : out std_logic;  -- Enable XOSC 
    en_pll      : out std_logic;  -- Enable PLL 
		sel_pll     : out std_logic;  -- Select PLL as clock source
		test_pll    : out std_logic;  -- PLL in test mode
    xout        : in  std_logic;  -- XOSC ref. clock output
    -- Power on signal
    pwr_ok      : in  std_logic;  -- Power is on 
    --signals to core2
    c2_core2_en    : out  std_logic;  -- core2 enable
    c2_rsc_n       : out std_logic;
    c2_clkreq_gen  : out std_logic;
    --c2_even_c      : out std_logic;
    c2_crb_sel     : in  std_logic_vector(3 downto 0);
    c2_crb_out     : out std_logic_vector(7 downto 0);
    c2_en_pmem     : out  std_logic;
    c2_en_wdog     : out std_logic;
    c2_pup_clk     : out std_logic;
    c2_pup_irq    	: out std_logic_vector(1 downto 0);
    c2_r_size     	: out std_logic_vector(1 downto 0);
    c2_c_size     	: out std_logic_vector(1 downto 0);
    c2_t_ras      	: out std_logic_vector(2 downto 0);
    c2_t_rcd      	: out std_logic_vector(1 downto 0);
    c2_t_rp       	: out std_logic_vector(1 downto 0);
--    c2_en_mexec   	: out std_logic;
    -- BMEM block signals
    bmem_a8     : out  std_logic;
    bmem_q      : in   std_logic_vector(7 downto 0);
    bmem_d      : out  std_logic_vector(7 downto 0);
    bmem_we_n   : out  std_logic;
    short_cycle : out std_logic;
    bmem_ce_n   : out  std_logic;
	-- router control signals
--	router_ir_en : out std_logic;    --delete by HYX, 20141027
--	north_en	 : out std_logic;       --delete by HYX, 20141027
--	south_en	 : out std_logic;       --delete by HYX, 20141027
--	west_en	 	 : out std_logic;      --delete by HYX, 20141027
--	east_en	 	 : out std_logic;      --delete by HYX, 20141027
--	router_clk_en : out std_logic;   --delete by HYX, 20141027
    -- RTC block signals  
    reset_core_n    : in std_logic;
    reset_iso       : in std_logic; -- reset isolate signal, can differ start from begginning or halt mode
    reset_iso_clear : out std_logic;
	poweron_finish  : in std_logic;
    nap_rec         : in std_logic;  -- will recover from nap mode
    halt_en         : out std_logic;
    nap_en          : out std_logic;
    rst_rtc     : out std_logic;  -- Reset RTC counter byte
    en_fclk     : out std_logic;  -- Enable fast clocking of RTC counter byte
    fclk        : out std_logic;  -- Fast clock to RTC counter byte
    ld_bmem     : out std_logic;  -- Latch enable to the en_bmem latch
    rtc_sel     : out std_logic_vector(2 downto 0);   -- RTC byte select
    rtc_data    : in  std_logic_vector(7 downto 0);   -- RTC data
    --  Signals to/from Peripheral block
    dfp         : in  std_logic_vector(7 downto 0); 
    dbus        : out std_logic_vector(7 downto 0);
    rst_en      : out std_logic;
    --rst_en2     : out std_logic;
    pd          : out std_logic_vector(2 downto 0);  -- pl_pd
    aaddr       : out std_logic_vector(4 downto 0);  -- pl_aaddr
    idreq       : in  std_logic_vector(7 downto 0);
    idi         : in  std_logic_vector(7 downto 0);     
    idack       : out std_logic_vector(7 downto 0);                   
    ios_iden    : out std_logic;                   
    ios_ido     : out std_logic_vector(7 downto 0);                  
    ilioa       : out std_logic;                   
    ildout      : out std_logic;                   
    inext       : out std_logic;
    iden        : in  std_logic;
    dqm_size    : out std_logic_vector(1 downto 0);
    adc_dac     : out std_logic;
    en_uart1    : out std_logic;
    en_uart2    : out std_logic;
    en_uart3    : out std_logic;
    en_eth      : out std_logic_vector(1 downto 0);
    en_tiu      : out std_logic;
    run_tiu     : out std_logic;
    en_tstamp   : out std_logic_vector(1 downto 0);
    en_iobus    : out std_logic_vector(1 downto 0);
    ddqm        : out std_logic_vector(7  downto 0);   
    irq0        : in  std_logic;  -- Interrupt request 0   
    irq1        : in  std_logic;  -- Interrupt request 1   
    adc_ref2v		: out	std_logic;	-- Select 2V internal ADC reference (1V)
---------------------------------------------------------------------
    -- Memory signals
---------------------------------------------------------------------
    -- MPROM signals
    mprom_a     : out std_logic_vector(13 downto 0);-- Address  
    mprom_ce    : out std_logic_vector(1 downto 0); -- Chip enable(active high) 
    mprom_oe    : out std_logic_vector(1 downto 0); --Output enable(active high)
    -- MPRAM signals
    mpram_a     : out std_logic_vector(13 downto 0);-- Address  
    mpram_d     : out std_logic_vector(79 downto 0);-- Data to memory
    mpram_ce    : out std_logic_vector(1 downto 0); -- Chip enable(active high)
    mpram_oe    : out std_logic_vector(1 downto 0); -- Output enable(active high)
    mpram_we_n  : out std_logic;                    -- Write enable(active low)
    -- MPROM/MPRAM data out bus
    mp_q        : in  std_logic_vector(79 downto 0);-- Data from MPROM/MPRAM
    -- GMEM signals
    gmem_a      : out std_logic_vector(9 downto 0);  
    gmem_d      : out std_logic_vector(7 downto 0);  
    gmem_q      : in  std_logic_vector(7 downto 0);
    gmem_ce_n   : out std_logic;                      
    gmem_we_n   : out std_logic;                      
    -- IOMEM signals
    iomem_a     : out std_logic_vector(9 downto 0);
    iomem_d     : out std_logic_vector(15 downto 0);
    iomem_q     : in  std_logic_vector(15 downto 0);
    iomem_ce_n  : out std_logic_vector(1 downto 0);
    iomem_we_n  : out std_logic;
    -- TRCMEM signals (Trace memory)
    trcmem_a    : out std_logic_vector(7 downto 0);
    trcmem_d    : out std_logic_vector(31 downto 0);
    trcmem_q    : in  std_logic_vector(31 downto 0);
    trcmem_ce_n : out std_logic;       
    trcmem_we_n : out std_logic;      
    -- PMEM signals (Patch memory)
    pmem_a      : out std_logic_vector(10 downto 0);
    pmem_d      : out std_logic_vector(1  downto 0);
    pmem_q      : in  std_logic_vector(1  downto 0);
    pmem_ce_n   : out std_logic;  
    pmem_we_n   : out std_logic;
---------------------------------------------------------------------
    -- PADS
---------------------------------------------------------------------
    -- Misc. signals
    --mpordis_i   : in  std_logic;  -- 'power on' from pad
    mreset_i    : in  std_logic;  -- Asynchronous reset input 
    mirqout_o   : out std_logic;  -- Interrupt  request output 
    mckout1_o   : out std_logic;  -- Programmable clock out 
    mckout1_o_en: out std_logic;  -- enable
    msdin_i     : in  std_logic;  -- Serial data in (debug) 
    msdout_o    : out std_logic;  -- Serial data out
    mrstout_o   : out std_logic;  -- Reset out
    --mxout_o     : out std_logic;  -- Oscillator test output
    mexec_o     : out std_logic;  -- clk_e test output
    mtest_i     : in  std_logic;  -- Test mode
    mbypass_i   : in  std_logic;  -- bypass PLL
    mwake_i     : in  std_logic;  -- wake up
    -- DRAM signals
	en_pmem2	: out std_logic; --patch memory enable for program ROM
    d_addr      : out std_logic_vector(31 downto 0);--2012-02-09 14:00:40 maning
    dcs_o       : out std_logic;  -- Chip select
    dras_o      : out std_logic;  -- Row address strobe
    dcas_o      : out std_logic;  -- Column address strobe
    dwe_o       : out std_logic;  -- Write enable
    ddq_i       : in  std_logic_vector(7 downto 0); -- Data input bus
    ddq_o       : out std_logic_vector(7 downto 0); -- Data output bus
    ddq_en      : out std_logic;  -- Data output bus enable
    da_o        : out std_logic_vector(13 downto 0);  -- Address
    dba_o       : out std_logic_vector(1 downto 0); -- Bank address
    dcke_o      : out std_logic_vector(3 downto 0); -- Clock enable
    -- Port A
    pa_i        : in  std_logic_vector(4 downto 0);
	--pl_out          : out std_logic_vector(79 downto 0);--maning
		-- I/O cell configuration control outputs
    d_hi        : out std_logic; -- High drive on DRAM interface, now used for other outputs
    d_sr        : out std_logic; -- Slew rate limit on DRAM interface
    d_lo        : out std_logic; -- Low drive on DRAM interface
    p1_hi       : out std_logic; -- High drive on port group 1 pins
    p1_sr       : out std_logic; -- Slew rate limit on port group 1 pins
    p2_hi       : out std_logic; -- High drive on port group 2 pins
    p2_sr       : out std_logic; -- Slew rate limit on port group 2 pins
    p3_hi       : out std_logic; -- High drive on port group 3 pins
    p3_sr       : out std_logic -- Slew rate limit on port group 3 pins

    -- pc_hi       : out std_logic;  -- High drive on port C pins
    -- pc_lo_n     : out std_logic;  -- Not low drive port C pins
    -- ph_hi       : out std_logic;  -- High drive on port H pins
    -- ph_lo_n     : out std_logic;  -- Not low drive port H pins
    -- pi_hi       : out std_logic;  -- High drive on port I pins
    -- pi_lo_n     : out std_logic;  -- Not low drive port I pins
    -- pel_hi      : out std_logic;  -- High drive on low half of port E pins
    -- peh_hi      : out std_logic;  -- High drive on high half of port E pins
    -- pdll_hi     : out std_logic;  -- High drive low dibit, low half of port D
    -- pdlh_hi     : out std_logic;  -- High drive high dibit, low half of port D
    -- pdh_hi      : out std_logic;  -- High drive on high half of port D pins
    -- pf_hi       : out std_logic;  -- High drive on port F pins
    -- pg_hi       : out std_logic); -- High drive on port G pins
    ); 

end core;

architecture struct of core is
---------------------------------------------------------------------
-- Internal signals
---------------------------------------------------------------------
  -- Microinstruction pipeline register
  signal pl         : std_logic_vector(79 downto 0);

  -- Named fields of the pipeline register input
  signal mp_miform  : std_logic;
  signal mp_ds      : std_logic_vector(3 downto 0);
  signal mp_alud    : std_logic;  
  signal mp_shin_pa : std_logic_vector(3 downto 0);  
  signal mp_gass    : std_logic_vector(1 downto 0);         

  -- CRB signals
  signal crb_out    	: std_logic_vector(7 downto 0);
  signal en_pmem    	: std_logic;
  signal speed_i    	: std_logic_vector(1 downto 0);
  signal en_wdog    	: std_logic;
  signal pup_clk    	: std_logic;
  signal pup_irq    	: std_logic_vector(1 downto 0);
  signal en_i       	: std_logic;
  signal r_size     	: std_logic_vector(1 downto 0);
  signal c_size     	: std_logic_vector(1 downto 0);
  signal dqm_size_int	: std_logic_vector(1 downto 0);
  signal fast_d_int 	: std_logic;
  signal t_ras      	: std_logic_vector(2 downto 0);
  signal t_rcd      	: std_logic_vector(1 downto 0);
  signal t_rp       	: std_logic_vector(1 downto 0);
  signal dis_pll    	: std_logic;
  signal dis_xosc   	: std_logic;
  signal en_mxout   	: std_logic;
  signal clk_sel   	: std_logic;
  signal en_s       	: std_logic;
  signal speed_s    	: std_logic_vector(1 downto 0);
  signal speed_u    	: std_logic_vector(6 downto 0);
  signal speed_ps1  	: std_logic_vector(3 downto 0);
  signal speed_ps2  	: std_logic_vector(5 downto 0);
  signal speed_ps3  	: std_logic_vector(4 downto 0);
  signal en_mckout1 	: std_logic;
  signal short_cycle_int : std_logic;
  -- TIM signals
  --signal even_c     : std_logic;
  signal clk_e_pos_int  : std_logic;
  signal clk_e_neg_int  : std_logic;
  --signal gate_e     : std_logic;
  signal held_e     : std_logic;
  signal pend_i     : std_logic;
  signal state_ps3  : std_logic_vector(4 downto 0);                    
  signal clkreq_gen : std_logic;
  signal ld_mar     : std_logic;
  signal runmode    : std_logic;
  signal spack_n    : std_logic;
  signal spreq_n    : std_logic; 
  signal rst_n_int : std_logic;  
  signal rst_cn_int : std_logic;                    
  signal rst_en_int : std_logic;                    
  signal hold_e_int : std_logic;
  
  -- CLC signals
  signal sleep      : std_logic;                    
  signal inv_psmsb  : std_logic;                    
  signal trace      : std_logic;                    
  signal ld_nreg    : std_logic;                    
  signal reqrun     : std_logic;                    
  signal wdog_n     : std_logic;                    
  signal ld_crb     : std_logic;                    
  signal rst_seqc_n : std_logic;                    
  signal dsi        : std_logic_vector(7 downto 0); 
  signal mpga       : std_logic_vector(13 downto 0);
  signal curr_mpga  : std_logic_vector(13 downto 0);
  signal mar        : std_logic_vector(13 downto 0);

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
  
  -- MBM signals
  signal mbmd       : std_logic_vector(7 downto 0);
  signal y_bittst   : std_logic;
    
  -- MMR signals
  signal dfm        : std_logic_vector(7 downto 0);
  signal direct     : std_logic_vector(7 downto 0);
  signal use_direct : std_logic;               
  signal dbl_direct : std_logic;               
  signal sel_direct : std_logic_vector(1 downto 0);
  signal g_double   : std_logic;               
  signal i_double   : std_logic;               
  signal lmpen      : std_logic;               
  signal adl_cy     : std_logic;               
  signal mmr_hold_e : std_logic;               
  
  -- MPLL signals
  signal lmpwe_n  : std_logic;
  signal udo      : std_logic_vector(79 downto 0);  
  signal ldmp_sig  : std_logic;  
  
  -- CPC signals
  signal rsc_n        : std_logic;
  signal stop_step    : std_logic;
  signal run          : std_logic;
  signal plsel_n      : std_logic;
  signal plcpe_n      : std_logic;
  signal spack_cmd    : std_logic;    
  signal gen_spreq    : std_logic; 
  signal byte_sel     : std_logic_vector(3 downto 0);
  signal wmlat        : std_logic; 
  signal dtal         : std_logic_vector(7 downto 0);
  signal dtcl         : std_logic_vector(7 downto 0);  
  signal dfsr         : std_logic_vector(7 downto 0);
  signal mpram_we_nint: std_logic;   
 
  -- IOS signals
  signal i_direct   : std_logic_vector(7 downto 0);                  
  signal dfio       : std_logic_vector(7 downto 0);
  signal ios_hold_e : std_logic;
  
  attribute syn_keep              : boolean;
  attribute syn_keep of pend_i    : signal is true;
  -- To easy gate-level simulation
  attribute syn_keep of dbus_int  : signal is true;
  attribute syn_keep of ybus      : signal is true;
  attribute syn_keep of curr_mpga : signal is true;
  
begin
---------------------------------------------------------------------
-- External test clock gating 
---------------------------------------------------------------------
--  mxout_o	<= xout and en_mxout when mtest_i = '1' else
--						 '1';
--  mexec_o	<= clk_e_pos_int and en_mexec when mtest_i = '1' else
--						 '1';

---------------------------------------------------------------------
-- Signals also used by Peri block
---------------------------------------------------------------------
  rst_en <= rst_en_int;
  dbus <= dbus_int;
  pd <= (pl(19) xor pl(66))&(pl(43) xor pl(39))& pl(38);
  aaddr <= pl(23)&pl(6)&pl(54)&pl(27)&pl(49);

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
  --pl_out <= pl;
  pl_reg: process (clk_p, rst_en_int)
  begin
    if rising_edge(clk_p) then--  
        if rst_en_int = '0' then    
            pl <= (others => '0');
        elsif clk_e_pos_int = '0' then
            if plsel_n = '1' then
                pl <= mp_q;
            elsif plcpe_n = '0' then
                pl <= udo;
            end if;
        end if;
    end if;
  end process pl_reg;

 
  -- Some fields have to be accessed directly from the microprogram
  -- memory bus, to determine if a read operation in the GMEM should
  -- be performed at the leading edge of the instruction cycle.
  
  mp_miform  <= mp_q(45);          
  mp_ds      <= mp_q(50)&mp_q(22)&mp_q(14)&mp_q(44);
  mp_alud    <= mp_q(71) xor mp_q(77);
  mp_shin_pa <= (mp_q(60) xor mp_q(68))&mp_q(56)&(mp_q(16) xor mp_q (35))&mp_q(68);
  mp_gass    <= mp_q(0)&mp_q(41);


---------------------------------------------------------------------
-- MPGM
---------------------------------------------------------------------
  mpgm: entity work.mpgm
    port map (
      -- Clock and reset
      rst_cn      => rst_cn_int,
      clk_p       => clk_p,
      clk_e_neg    => clk_e_neg_int,
      -- Control signals
      even_c      => even_c,
      held_e      => held_e,
      plsel_n     => plsel_n,
      lmpen       => lmpen,
      lmpwe_n     => lmpwe_n,
      en_pmem     => en_pmem,
      -- Inputs
      mpga        => mpga,
      latch       => latch,
      y_reg       => y_reg,
      -- Outputs to MPRAM/MPROM
      mpram_a     => mpram_a,    
      mprom_oe    => mprom_oe,     
      mpram_oe    => mpram_oe,     
      mprom_ce    => mprom_ce,     
      mpram_ce    => mpram_ce,    
      -- PMEM
      pmem_a      => pmem_a,    
      pmem_q      => pmem_q,    
      pmem_ce_n   => pmem_ce_n);    

  mprom_a     <= mpga;
  mpram_d     <= udo;
  mpram_we_n  <= mpram_we_nint and lmpwe_n;
  pmem_d      <= udo(1 downto 0);
  pmem_we_n   <= mpram_we_nint and lmpwe_n;

---------------------------------------------------------------------
-- CRB - configuration register block
---------------------------------------------------------------------
  crb: entity work.crb
    port map (
      -- Clock and reset functions
      clk_p         => clk_p,
      clk_e_pos       => clk_e_pos_int,
      rst_cn      => rst_n_int,--rst_cn_int, using rst_n_int instead
      rst_seqc_n  => rst_seqc_n,             
      mreset      => mreset_i,             
      pwr_ok      => pwr_ok,             
      -- Microprogram control
      pl          => pl,             
      -- Other control inputs 
      ld_crb      => ld_crb,             
      rd_crb      => rd_crb,             
      mwake_i     => mwake_i,  
      pa_i        => pa_i,
      -- Data paths
      dbus        => dbus_int,             
      state_ps3   => state_ps3,
      crb_out     => crb_out,            
      -- Static control outputs
      -- CCFF register
      en_pmem     => en_pmem,
      speed_i     => speed_i,            
      en_wdog     => en_wdog,            
      pup_clk     => pup_clk,            
      pup_irq     => pup_irq,            
      en_i        => en_i,             
      -- MORG register
	  en_pmem2	  => en_pmem2,
      en_d        => en_d,             
      r_size      => r_size,             
      c_size      => c_size,             
      dqm_size    => dqm_size_int,             
      -- MTIM register
      fast_d      => fast_d_int,             
      t_ras       => t_ras,            
      t_rcd       => t_rcd,            
      t_rp        => t_rp,             
      -- PLLC register
      en_tiu      => en_tiu,
      run_tiu     => run_tiu,
      dis_pll     => dis_pll,     
      dis_xosc    => dis_xosc,
      en_tstamp   => en_tstamp,     
      en_mxout    => en_mxout,     
      clk_sel    => clk_sel,
      -- PLLM register
			pll_frange	=> pll_frange,
      pll_n       => pll_n,            
      pll_m       => pll_m,            
      -- SECC register
      en_s        => en_s,            
      speed_s     => speed_s,            
      -- PMXC register
      adc_dac     => adc_dac,             
      en_uart1    => en_uart1,             
      en_uart2    => en_uart2,             
      en_uart3    => en_uart3,             
      en_eth      => en_eth,             
      en_iobus    => en_iobus,             
      -- UACC register
      adc_ref2v   => adc_ref2v,         
      speed_u     => speed_u,         
      -- PSC1 register
      speed_ps1   => speed_ps1,         
      speed_ps2   => speed_ps2,         
      -- PSC2 register
      speed_ps3   => speed_ps3,         
      en_mckout1  => en_mckout1,
      clk_in_off   => clk_in_off   ,
      clk_main_off => clk_main_off ,
      sdram_en => sdram_en,
      reqrun      => reqrun,
      --flash control
      flash_en    => flash_en,
      flash_mode => flash_mode,
	  --router control register
--	  router_ir_en => router_ir_en,      --delete by HYX, 20141027
--	  north_en	   => north_en	  ,        --delete by HYX, 20141027
--	  south_en	   => south_en	  ,        --delete by HYX, 20141027
--	  west_en	   => west_en	  ,          --delete by HYX, 20141027
--	  east_en	   => east_en	  ,          --delete by HYX, 20141027
--	  router_clk_en => router_clk_en,    --delete by HYX, 20141027
	    -- IOCTRL register & pad control   --delete by HYX, 20141027
    d_hi           => d_hi           ,   --: out std_logic; -- High drive on DRAM interface
    d_sr           => d_sr           ,   --: out std_logic; -- Slew rate limit on DRAM interface
    d_lo           => d_lo           ,   --: out std_logic; -- Low drive on DRAM interface
    p1_hi          => p1_hi          ,   --: out std_logic; -- High drive on port group 1 pins
    p1_sr          => p1_sr          ,   --: out std_logic; -- Slew rate limit on port group 1 pins
    p2_hi          => p2_hi          ,   --: out std_logic; -- High drive on port group 2 pins
    p2_sr          => p2_sr          ,   --: out std_logic; -- Slew rate limit on port group 2 pins
    p3_hi          => p3_hi          ,   --: out std_logic; -- High drive on port group 3 pins
    p3_sr          => p3_sr          ,   --: out std_logic; -- Slew rate limit on port group 3 pins
    -- pc_hi          => pc_hi          ,   --: out std_logic;  -- High drive on port C pins
    -- pc_lo_n        => pc_lo_n        ,   --: out std_logic;  -- Not low drive port C pins
    -- ph_hi          => ph_hi          ,   --: out std_logic;  -- High drive on port H pins
    -- ph_lo_n        => ph_lo_n        ,   --: out std_logic;  -- Not low drive port H pins
    -- pi_hi          => pi_hi          ,   --: out std_logic;  -- High drive on port I pins
    -- pi_lo_n        => pi_lo_n        ,   --: out std_logic;  -- Not low drive port I pins
    -- pel_hi         => pel_hi         ,   --: out std_logic;  -- High drive on low half of port E pins
    -- peh_hi         => peh_hi         ,   --: out std_logic;  -- High drive on high half of port E pins
    -- pdll_hi        => pdll_hi        ,   --: out std_logic;  -- High drive low dibit, low half of port D
    -- pdlh_hi        => pdlh_hi        ,   --: out std_logic;  -- High drive high dibit, low half of port D
    -- pdh_hi         => pdh_hi         ,   --: out std_logic;  -- High drive on high half of port D pins
    -- pf_hi          => pf_hi          ,   --: out std_logic;  -- High drive on port F pins
    -- pg_hi          => pg_hi             --: out std_logic  -- High drive on port G pins
    	-- BMEM block interface
      bmem_a8     => bmem_a8,
      core2_en    => c2_core2_en,         
      bmem_q      => bmem_q ,         
      bmem_d      => bmem_d,         
      bmem_we_n   => bmem_we_n,         
      short_cycle => short_cycle_int,
      bmem_ce_n   => bmem_ce_n,        
      
      crb_out_c2  => c2_crb_out,
      crb_sel_c2  => c2_crb_sel, 
      -- RTC block interface
      poweron_finish   => poweron_finish   ,-- differ start from begginning or halt mode
      nap_rec     => nap_rec     , -- will recover from nap mode
      halt_en     => halt_en     ,
      nap_en      => nap_en      ,
      rst_rtc     => rst_rtc,      
      en_fclk     => en_fclk,  
      fclk        => fclk,     
      ld_bmem     => ld_bmem,     
      rtc_sel     => rtc_sel,    
      rtc_data    => rtc_data);    

  fast_d		<= fast_d_int;   
	dqm_size	<= dqm_size_int;
    c2_rsc_n    <= rsc_n;
    c2_clkreq_gen <= clkreq_gen;
    --c2_even_c   <= even_c;
    c2_en_pmem    <= en_pmem  ;  
    c2_en_wdog    <= en_wdog  ;  
    c2_pup_clk    <= pup_clk  ;  
    c2_pup_irq    <= pup_irq  ;  
    c2_r_size     <= r_size   ;  
    c2_c_size     <= c_size   ;  
    c2_t_ras      <= t_ras    ;  
    c2_t_rcd      <= t_rcd    ;  
    c2_t_rp       <= t_rp     ;  
--    c2_en_mexec   <= en_mexec ;  
    short_cycle <= short_cycle_int;
    
    
---------------------------------------------------------------------
-- TIM - timing logic
---------------------------------------------------------------------
  hold_e_int <= ios_hold_e or mmr_hold_e;
  mckout1_o_en <= en_mckout1;
  tim: entity work.tim
    port map (
      -- Clock
      clk_p       => clk_p,
      even_c      => even_c,
      clk_c_en       => clk_c_en,            
      --clk_c2_pos      => clk_c2_pos,            
      clk_e_pos       => clk_e_pos_int,
	  clk_e_neg	   	=> clk_e_neg_int,
      -- Microinstruction fields
      pl  		  => pl,           
      -- Static control inputs
      en_i        => en_i,             
      en_mckout1  => en_mckout1,             
      en_s        => en_s,            
      speed_i     => speed_i,            
      speed_u     => speed_u,            
      speed_s     => speed_s,            
      speed_ps1   => speed_ps1,            
      speed_ps2   => speed_ps2,            
      speed_ps3   => speed_ps3,            
      dis_xosc    => dis_xosc,
      dis_pll     => dis_pll,
      clk_sel     => clk_sel,
      -- Inputs from outside core
      mreset      => mreset_i,
      pwr_ok      => pwr_ok,
      --mpordis_i   => mpordis_i,
      mtest_i     => mtest_i,
      mbypass_i   => mbypass_i,
      -- Inputs from other core blocks
      hold_e      => hold_e_int,   
      hold_flash  => hold_flash,
      hold_flash_d => hold_flash_d,        
      gen_spreq   => gen_spreq,          
      rsc_n       => rsc_n,            
      stop_step   => stop_step,        
      run         => run,              
      spack_cmd   => spack_cmd,          
      reqrun      => reqrun,           
      sleep       => sleep,            
      wdog_n      => wdog_n,             
      -- Outputs to outside core
      mrstout     => mrstout_o, 
      en_xosc     => en_xosc,
      en_pll      => en_pll,
      sel_pll     => sel_pll,
      test_pll    => test_pll,
      mirqout     => mirqout_o,          
      mckout1     => mckout1_o, 
      --din_e       => din_e,          
      din_i       => din_i,          
      din_u       => din_u,          
      din_s       => din_s,          
      -- Outputs to other core blocks
      --even_c      => even_c,           
      --gate_e      => gate_e,          
      held_e      => held_e,          
      pend_i      => pend_i,
      state_ps3   => state_ps3,           
      clkreq_gen  => clkreq_gen,           
      ld_mar      => ld_mar,         
      runmode     => runmode,          
      spack_n     => spack_n,          
      spreq_n     => spreq_n,          
      rst_n       => rst_n_int,           
      rst_cn      => rst_cn_int,             
      rst_en      => rst_en_int,
      reset_core_n => reset_core_n,
	  reset_iso_clear => reset_iso_clear,
      reset_iso => reset_iso
      --rst_en2     => rst_en2
	  );
        
  rst_cn <= rst_cn_int;
  rst_n <= rst_n_int;
  clk_e_pos <= clk_e_pos_int;
  clk_e_neg <= clk_e_neg_int;
---------------------------------------------------------------------
-- CLC
---------------------------------------------------------------------
  clc: entity work.clc
    port map (
      -- Clock and reset inputs
      clk_p         => clk_p,
      clk_e_pos      => clk_e_pos_int,
      rst_en        => rst_en_int,              
      -- Microprogram fields
      pl            => pl, 
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
      -- Condition inputs
      spreq_n       => spreq_n,             
      spack_n       => spack_n,             
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
      wdog_n        => wdog_n,                
      ld_crb        => ld_crb,                
      rst_seqc_n    => rst_seqc_n,             
      --Data Outputs
      dsi           => dsi,
      --Microprogram address outputs
      mpga          => mpga,
      curr_mpga     => curr_mpga,
      mar           => mar);

---------------------------------------------------------------------
-- ALU
---------------------------------------------------------------------
  alu: entity work.alu
    port map (
      -- Clock input
      clk_p         => clk_p,
      clk_e_pos     => clk_e_pos_int, 
	  rst_n	  		=> rst_en_int,
      -- Microprogram fields
      pl            => pl,  
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
  gmem: entity work.gmem
    port map (
			-- Clock and reset inputs
      rst_en     => rst_en_int,
      clk_p      => clk_p,              
      clk_e_pos   => clk_e_pos_int,
      clk_e_neg   => clk_e_neg_int,
      gate_e     => clk_e_pos_int,          
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
  dsl: entity work.dsl
    port map (
      -- Clock input
      rst_en        => rst_en_int,
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
      dfio          => dfio,             
      dsi           => dsi,              
      gdata         => gdata,            
      dtal          => dtal,             
      dfp           => dfp,
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
  mbm: entity work.mbm
    port map (
      -- Clock input
      clk_p     =>  clk_p,           
      clk_e_pos     =>  clk_e_pos_int, 
      rst_en   => rst_en_int,
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
  mmr: entity work.mmr
    port map (
      -- Clock and reset functions
      rst_en      => rst_en_int,
      clk_p       => clk_p,
      clk_e_neg    => clk_e_neg_int,
      clk_c2_pos      => even_c,            
      clk_d_pos       => clk_d_pos,            
      clk_e_pos       => clk_e_pos_int,
      gate_e      => clk_e_pos_int,          
      even_c      => even_c,
      held_e      => held_e,
      -- Microprogram control
      pl          => pl,             
      -- Static control inputs
      r_size      => r_size,               
      c_size      => c_size,               
      dqm_size    => dqm_size_int,               
      t_ras       => t_ras,              
      t_rcd       => t_rcd,              
      t_rp        => t_rp,               
      fast_d      => fast_d_int, 
	  short_cycle => short_cycle_int,
      -- Data paths
      dbus        => dbus_int,             
      ybus        => ybus,             
      g_direct    => g_direct,             
      i_direct    => i_direct,             
      dfm         => dfm,            
      direct      => direct,             
      -- Outputs
      use_direct  => use_direct,           
      dbl_direct  => dbl_direct,           
      sel_direct  => sel_direct,           
      g_double    => g_double,           
      i_double    => i_double,           
      lmpen       => lmpen,           
      adl_cy      => adl_cy,             
      hold_e      => mmr_hold_e,             
      -- SDRAM signals
      d_addr      => d_addr,
      d_cs        => dcs_o,              
      d_ras       => dras_o,             
      d_cas       => dcas_o,             
      d_we        => dwe_o,              
      d_dqi       => ddq_i,             
      d_dqo       => ddq_o,             
      en_dqo      => ddq_en,
      out_line    => out_line,
	  ld_dqi_flash => ld_dqi_flash,
      d_a         => da_o,             
      d_ba        => dba_o,              
      d_dqm       => ddqm,             
      d_cke       => dcke_o);              

---------------------------------------------------------------------
-- MPLL
---------------------------------------------------------------------
  ldmp_sig <= pl(43) xor pl(39);
  mpll: entity work.mpll
    port map (
    rst_cn      => rst_cn_int,
    clk_p       => clk_p,
    clk_c2_pos  => even_c, 
    clk_e_neg   => clk_e_neg_int,
    clk_e_pos   => clk_e_pos_int,
    gate_e      => clk_e_pos_int,          
    wmlat       => wmlat,
    byte_sel    => byte_sel,
    dfsr        => dfsr,
    lmpen       => lmpen,
    dbl_direct  => dbl_direct,
    ldmp        => ldmp_sig,
    direct      => direct,
    lmpwe_n     => lmpwe_n,
    udo         => udo);
    
---------------------------------------------------------------------
-- CPC
---------------------------------------------------------------------
  cpc: entity work.cpc
    port map (
      -- Clock and reset inputs
      rst_cn      => rst_cn_int, 
      clk_p       => clk_p,         
      clk_s_pos       => clk_s_pos,         
      clk_e_pos       => clk_e_pos_int,         
      -- Control inputs
      runmode     => runmode,               
      spreq_n     => spreq_n,                
      spack_n     => spack_n,                
      ld_mar      => ld_mar,           
      -- Data inputs
      mp_q        => mp_q,                
      pmem_q      => pmem_q,                
      curr_mpga   => curr_mpga,               
      mar         => mar,               
      dbus        => dbus_int,                
      ybus        => ybus,                
      -- Control outputs
      mpram_we_n  => mpram_we_nint,
      rsc_n       => rsc_n,                
      stop_step   => stop_step,                
      run         => run,
      plsel_n     => plsel_n,
      plcpe_n     => plcpe_n,
      spack_cmd   => spack_cmd,
      gen_spreq   => gen_spreq,
      byte_sel    => byte_sel, 
      wmlat       => wmlat,                
      -- Data outputs
      dtal        => dtal,                 
      dtcl        => dtcl,
      dfsr        => dfsr,
      -- External pins
      msdin       => msdin_i,          
      msdout      => msdout_o,--,
      -- TRCMEM signals
      trcmem_q    => trcmem_q,     
      trcmem_d    => trcmem_d,     
      trcmem_a    => trcmem_a,     
      trcmem_ce_n => trcmem_ce_n,   
      trcmem_we_n => trcmem_we_n     
      );

---------------------------------------------------------------------
-- IOS
---------------------------------------------------------------------
  ios: entity work.ios
    port map (
      -- Clock and reset signals
      rst_en         => rst_en_int,
      clk_p          => clk_p,   
      clk_c_en          => clk_c_en,
      clk_c2_pos         => even_c,
      clk_e_pos          => clk_e_pos_int,    
      clk_e_neg          => clk_e_neg_int,
      gate_e         => clk_e_pos_int,          
      clk_i_pos          => clk_i_pos,
      -- Microprogram fields
      pl             => pl,           
      -- Static control inputs
      use_direct     => use_direct,
      dbl_direct     => dbl_direct,
      i_double       => i_double,     
      -- Control inputs
      pend_i         => pend_i,
      held_e         => held_e,
      -- Data paths
      dbus           => dbus_int,        
      direct         => direct,        
      i_direct       => i_direct,        
      dfio           => dfio,        
      -- Control outputs
      hold_e         => ios_hold_e, 
      -- I/O bus
      idack          => idack,
      idreq          => idreq,
      idi            => idi,         
      ios_iden       => ios_iden,         
      ido            => ios_ido,         
      ilioa          => ilioa,       
      ildout         => ildout,      
      inext          => inext,       
      iden           => iden,
      -- IOMEM signals
      iomem_ce_n     => iomem_ce_n,  
      iomem_we_n     => iomem_we_n, 
      iomem_a        => iomem_a,
      iomem_d        => iomem_d,
      iomem_q        => iomem_q);
     
     
end;





