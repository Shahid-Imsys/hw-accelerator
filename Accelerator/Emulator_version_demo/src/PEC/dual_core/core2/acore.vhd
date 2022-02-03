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
-- Description: auxiliary core
--              only contain alu, mbm, dsl, clc, mmr, gmem moduls
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
-- 2012-12-14       5.0             MN          modify the whole module to auxiliary core in dual core system
-- 2015-07-09       5.1             MN          add crb_out from core1, add core2_en_buf for transferring core2_en from core1
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity acore is
  port (
---------------------------------------------------------------------
    -- Signals to/from other blocks
---------------------------------------------------------------------
    -- Clocks to/from clock block
    clk_p       : in  std_logic;  -- PLL clock
    clk_c_en       : in  std_logic;  -- CP clock
    even_c      : in std_logic;
    --clk_c2_pos      : in  std_logic;  -- clk_c / 2 
    clk_e_pos       : out  std_logic;  -- Execution clock
	clk_d_pos		: in  std_logic;
    -- Control outputs to the clock block
    --rst_n       : out std_logic;  -- Asynchronous reset to clk_gen
    --rst_cn      : out std_logic;  -- Reset, will hold all clocks except c,rx,tx
    --din_e       : out std_logic;  -- D input to FF generating clk_e
    -- signals from the master core
    core2_en    : in  std_logic;  -- core2 enable
    rst_cn          : in std_logic;
	rsc_n           : in std_logic;
	clkreq_gen      : in std_logic;
    crb_out     : in std_logic_vector(7 downto 0);
    en_pmem     : in  std_logic;
    en_wdog     : in std_logic;
    pup_clk     : in std_logic;
    pup_irq    	: in std_logic_vector(1 downto 0);
    r_size     	: in std_logic_vector(1 downto 0);
    c_size     	: in std_logic_vector(1 downto 0);
    t_ras      	: in std_logic_vector(2 downto 0);
    t_rcd      	: in std_logic_vector(1 downto 0);
    t_rp       	: in std_logic_vector(1 downto 0);
--    en_mexec   	: in std_logic;
    dqm_size    : in std_logic_vector(1 downto 0);   --input from crb
    fast_d      : in std_logic;  -- clk_d speed select     input from crb
    short_cycle : in std_logic;
    -- signal to core1
    crb_sel     : out std_logic_vector(3 downto 0);
    --  Signals to/from Peripheral block
    dfp         : in  std_logic_vector(7 downto 0); 
    --dbus        : out std_logic_vector(7 downto 0);
    --rst_en      : out std_logic;
    --pd          : out std_logic_vector(2 downto 0);  -- pl_pd
    --aaddr       : out std_logic_vector(4 downto 0);  -- pl_aaddr
    ddqm        : out std_logic_vector(7  downto 0);   
    irq0        : in  std_logic;  -- Interrupt request 0   
    irq1        : in  std_logic;  -- Interrupt request 1   
---------------------------------------------------------------------
    -- Memory signals
---------------------------------------------------------------------
    -- MPROM signals
    mprom_a     : out std_logic_vector(13 downto 0);-- Address  --CJ
    mprom_ce    : out std_logic_vector(1 downto 0); -- Chip enable(active high) 
    mprom_oe    : out std_logic_vector(1 downto 0); --Output enable(active high)
    -- MPRAM signals
    mpram_a     : out std_logic_vector(7 downto 0);-- Address  
    mpram_d     : out std_logic_vector(127 downto 0);-- Data to memory
    mpram_ce    : out std_logic_vector(1 downto 0); -- Chip enable(active high)
    mpram_oe    : out std_logic_vector(1 downto 0); -- Output enable(active high)
    mpram_we_n  : out std_logic;                    -- Write enable(active low)
    -- MPROM/MPRAM data out bus
    mp_q        : in  std_logic_vector(127 downto 0);-- Data from MPROM/MPRAM
    -- GMEM signals
    gmem_a      : out std_logic_vector(9 downto 0);  
    gmem_d      : out std_logic_vector(7 downto 0);  
    gmem_q      : in  std_logic_vector(7 downto 0);
    gmem_ce_n   : out std_logic;                      
    gmem_we_n   : out std_logic;                      
    -- PMEM signals (Patch memory)
    pmem_a      : out std_logic_vector(10 downto 0);
    pmem_d      : out std_logic_vector(1  downto 0);
    pmem_q      : in  std_logic_vector(1  downto 0);
    pmem_ce_n   : out std_logic;
    pmem_we_n   : out std_logic;
    -- CC signal
    req_c2    : out std_logic;
    ack_c2    : in std_logic;
    ddi_vld   : in std_logic; --Added by CJ
    exe       : in std_logic; --CONT need to be added
    resume    : in std_logic;
    ready     : out std_logic;
---------------------------------------------------------------------
    -- PADS
---------------------------------------------------------------------
    -- DRAM signals
    d_addr      : out std_logic_vector(31 downto 0);--2012-02-09 14:00:40 maning
    dcs_o       : out std_logic;  -- Chip select
    dras_o      : out std_logic;  -- Row address strobe
    dcas_o      : out std_logic;  -- Column address strobe
    dwe_o       : out std_logic;  -- Write enable
    ddq_i       : in  std_logic_vector(7 downto 0); -- Data input bus --CJ
    ddq_o       : out std_logic_vector(7 downto 0); -- Data output bus --CJ
    ddq_en      : out std_logic;  -- Data output bus enable
    da_o        : out std_logic_vector(13 downto 0);  -- Address
    dba_o       : out std_logic_vector(1 downto 0); -- Bank address
    dcke_o      : out std_logic_vector(3 downto 0); -- Clock enable
    -- CC interface signals
    din_c       : in std_logic_vector(127 downto 0);
    dout_c      : out std_logic_vector(31 downto 0)

    ); 

end acore;

architecture struct of acore is
---------------------------------------------------------------------
-- Internal signals
---------------------------------------------------------------------
  -- Microinstruction pipeline register
  signal pl         : std_logic_vector(127 downto 0);
  signal core2_en_buf : std_logic;
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
  -- CRB signals
  --signal crb_out    	: std_logic_vector(7 downto 0);
  --signal en_pmem    	: std_logic;
  --signal speed_i    	: std_logic_vector(1 downto 0);
  --signal en_wdog    	: std_logic;
  --signal pup_clk    	: std_logic;
  --signal pup_irq    	: std_logic_vector(1 downto 0);
  --signal en_i       	: std_logic;
  --signal r_size     	: std_logic_vector(1 downto 0);
  --signal c_size     	: std_logic_vector(1 downto 0);
  --signal dqm_size_int	: std_logic_vector(1 downto 0);
  --signal fast_d_int 	: std_logic;
  --signal t_ras      	: std_logic_vector(2 downto 0);
  --signal t_rcd      	: std_logic_vector(1 downto 0);
  --signal t_rp       	: std_logic_vector(1 downto 0);
  --signal dis_pll    	: std_logic;
  --signal dis_xosc   	: std_logic;
  --signal en_mxout   	: std_logic;
  --signal en_mexec   	: std_logic;
  --signal en_s       	: std_logic;
  --signal speed_s    	: std_logic_vector(1 downto 0);
  --signal speed_u    	: std_logic_vector(6 downto 0);
  --signal speed_ps1  	: std_logic_vector(3 downto 0);
  --signal speed_ps2  	: std_logic_vector(5 downto 0);
  --signal speed_ps3  	: std_logic_vector(4 downto 0);
  --signal en_mckout1 	: std_logic;
  -- TIM signals
  --signal gate_e     : std_logic;
  signal held_e     : std_logic;
  --signal pend_i     : std_logic;
  signal ld_mar     : std_logic;
  signal runmode    : std_logic;
  signal spack_n    : std_logic;
  signal spreq_n    : std_logic; 
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
  signal mpga       : std_logic_vector(7 downto 0);
  signal curr_mpga  : std_logic_vector(7 downto 0);
  signal mar        : std_logic_vector(7 downto 0);

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
  signal sel_direct : std_logic_vector(1 downto 0);
  signal g_double   : std_logic;               
  signal i_double   : std_logic;               
  signal lmpen      : std_logic;               
  signal adl_cy     : std_logic;               
  signal mmr_hold_e : std_logic; 
  signal dfm_rdy    : std_logic; --CJ 
  signal dtm_fifo_rdy : std_logic; --CJ              
  
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
 
  -- IOS signals
  signal i_direct   : std_logic_vector(7 downto 0);                  
  signal dfio       : std_logic_vector(7 downto 0);
  --signal ios_hold_e : std_logic;
  signal req        : std_logic;
  signal ack        : std_logic;
  --VE signals
  signal ve_in_int  : std_logic_vector(63 downto 0);
  signal ve_rdy_int : std_logic;
  signal re_rdy_int : std_logic;
  signal ve_out_d_int : std_logic_vector(7 downto 0);
  signal ve_out_dtm_int : std_logic_vector(127 downto 0);
  signal vldl      : std_logic; --Added by CJ
  attribute syn_keep              : boolean;
  --attribute syn_keep of pend_i    : signal is true;
  -- To easy gate-level simulation
  attribute syn_keep of dbus_int  : signal is true;
  attribute syn_keep of ybus      : signal is true;
  attribute syn_keep of curr_mpga : signal is true;
  
begin
  req_c2 <= req;
  ack    <= ack_c2;
  ready  <= pl(121);
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
  pl_reg: process (clk_p, rst_en_int)
  begin 
    if rst_en_int = '0' then    
      pl <= (others => '0');
      core2_en_buf <= '0';
    elsif rising_edge(clk_p) then--rising_edge(clk_e)   
        core2_en_buf <= core2_en;
        if clk_e_pos_int = '0' then
--          if plsel_n = '1' then
            pl <= mp_q;
--          elsif plcpe_n = '0' then
--            pl <= udo;
--          end if;
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
  mpgm: entity work.ampgm
    port map (
      -- Clock and reset
	  core2_en    => core2_en_buf,
      rst_cn      => rst_cn,
      clk_e_neg       => clk_e_neg_int,
      clk_p       => clk_p,
      -- Control signals
      even_c      => odd_c,
      held_e      => held_e,
      en_pmem     => en_pmem,
      -- Inputs
      mpga        => mpga,
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

  --mprom_a     <= mpga;
  mpram_d     <= mpgmin;--(others => '1');
  mpram_we_n  <= '1';
  pmem_d      <= "11";
  pmem_we_n   <= '1';

---------------------------------------------------------------------
-- TIM - timing logic
---------------------------------------------------------------------
  hold_e_int <= mmr_hold_e;
  
  atim: entity work.atim
    port map (
      -- Clock
      clk_p       => clk_p,
      clk_c_en    => clk_c_en,            
      clk_c2_pos  => odd_c,            
      clk_e_pos   => clk_e_pos_int,            
      clk_e_neg	  => clk_e_neg_int,
      even_c      => even_c,
      rst_cn      => rst_cn, 
	    core2_en    => core2_en_buf,     
      -- Inputs from other core blocks
      hold_e      => hold_e_int,           
      rsc_n       => rsc_n,            
      reqrun      => reqrun,           
      sleep       => sleep,            
      -- Outputs to outside core
      --din_e       => din_e,          
      -- Outputs to other core blocks
      --gate_e      => gate_e,          
      held_e      => held_e,          
      ld_mar      => ld_mar,         
      runmode     => runmode,          
      rst_en      => rst_en_int);
        

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
      ld_mpgm       => std_logic'('0'), --'0', 
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
      mp_vld        => std_logic'('0'), --'0',     --Added by CJ            
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
  dsl: entity work.dsl
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
      dfio          => dfio,             
      dsi           => dsi,              
      gdata         => gdata,            
      dtal          => dtal,             
      dfp           => dfp,
       --CJ added
       VE_OUT_D      => ve_out_d_int,
       CDFM         => cdfm_int,
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
  mbm: entity work.mbm
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
  mmr: entity work.mmr
    port map (
      -- Clock and reset functions
      rst_en      => rst_en_int,
      clk_p       => clk_p,
      clk_e_neg    => clk_e_neg_int,
      clk_c2_pos      => odd_c,            
      clk_d_pos       => clk_d_pos,            
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
      --ve_data     => ve_in_int,             
      en_dqo      => ddq_en,
	  ld_dqi_flash => std_logic'('0'), --'0',
      d_a         => da_o,             
      d_ba        => dba_o,              
      d_dqm       => ddqm,
      --exe         => exe,    --Added by CJ 
      --LD_MPGM     => std_logic'('0'), --'0',
      
      --ddi_vld     => ddi_vld,  --Added by CJ        
      d_cke       => dcke_o); 
---------------------------------------------------------------------
-- VE
---------------------------------------------------------------------
      --CJ Added
      vector_engine : entity work.ve
      port map(
      CLK_P       => clk_p,
      CLK_E_POS   => clk_e_pos_int,
      CLK_E_NEG   => clk_e_neg_int,
      RST         => rst_en_int,
      PL          => pl,
      YBUS        => ybus,
      DDI_VLD     => ddi_vld,
      RE_RDY      => re_rdy_int,
      VE_RDY      => ve_rdy_int,
      VE_IN       => ve_in_int,
      VE_OUT_D    => ve_out_d_int,
      VE_OUT_DTM => ve_out_dtm_int
      );
---------------------------------------------------------------------
-- CMDR
---------------------------------------------------------------------
--Interface of the core and cluster controller
      cmdr: entity work.acmdr
      port map(
        CLK_P    => clk_p,
        RST_EN   => rst_en_int,
        CLK_E_POS => clk_e_pos_int,
        PL       => pl,
        --EXE      => exe,
        DATA_VLD => ddi_vld,
        REQ_OUT  => req,
        ACK_IN   => ack,
        DIN      => din_c,
        DOUT     =>dout_c,
        YBUS     =>ybus,
        LD_MPGM  =>std_logic'('0'),
        VE_DIN   =>ve_in_int,
        DBUS_DATA=>cdfm_int,
        MPGMM_IN =>mpgmin,
        VE_DTMO  =>ve_out_dtm_int
      );    

    i_direct <= x"00"; 
    dfio <= x"00";
    dtal <= x"00";
    dtcl <= x"00";
    clk_e_pos <= clk_e_pos_int;
end;