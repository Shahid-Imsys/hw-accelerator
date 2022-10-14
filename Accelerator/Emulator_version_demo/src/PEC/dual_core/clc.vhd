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
-- Title      : Sequence control logic
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : clc.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The CLC block consists of microprogram sequence controller, 
--              instruction register, stack and stack counter.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		4.2 			CB			Created
-- 2006-05-08		4.3 			CB			Removed D bit test, added DSXFC condition instead.
-- 2013-03-01       5.1             MN          Buffer mpga at the falling edge of clk_p
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mpgmfield_lib.all;

entity clc is
  port(
    -- Clock and reset inputs
    clk_p        : in  std_logic;
    clk_e_pos     : in  std_logic;  -- Execution clock
    rst_en       : in  std_logic;  -- Reset input (active  low)
    -- Microprogram fields
    pl           : in  std_logic_vector(127 downto 0);
    ld_mpgm      : in  std_logic;
    -- Static control inputs
    dbl_direct   : in  std_logic;  -- Double step control input
    pup_irq      : in  std_logic_vector(1 downto 0); -- Enable wake on IRQ
    pup_clk      : in  std_logic; 
    en_wdog      : in  std_logic; 
    -- Control inputs
    ld_mar       : in  std_logic; 
    clkreq_gen   : in  std_logic; 
    ira2         : in  std_logic; 
    irq0         : in  std_logic; 
    irq1         : in  std_logic; 
    --dfm_vld      : in  std_logic; -- Added by CJ
    mp_vld       : in  std_logic;
    -- Condition inputs
    spreq_n      : in  std_logic; 
    spack_n      : in  std_logic; 
    d_sign	     : in  std_logic; 
    y_bittst     : in  std_logic; 
    flag_fn      : in  std_logic; 
    flag_fc      : in  std_logic; 
    flag_fz      : in  std_logic; 
    flag_fv      : in  std_logic; 
    flag_fh      : in  std_logic; 
    flag_fp      : in  std_logic; 
    flag_neg     : in  std_logic; 
    flag_carry   : in  std_logic; 
    flag_zero    : in  std_logic; 
    flag_oflow   : in  std_logic; 
    flag_link    : in  std_logic; 
    flag_pccy    : in  std_logic; 
    flag_qlsb    : in  std_logic; 
    psc_afull    : in  std_logic; 
    psc_full     : in  std_logic; 
    psc_aempty   : in  std_logic; 
    psc_empty    : in  std_logic; 
    flag_yeqneg  : in  std_logic; 
    adl_cy       : in  std_logic; 
    re_rdy       : in  std_logic;--Added by CJ
    ve_rdy       : in  std_logic;--Added by CJ
    dfm_rdy      : in  std_logic;--Added by CJ
    fifo_rdy     : in  std_logic;--Added by CJ
    buf_empty    : in std_logic;
    continue     : in  std_logic;--Added by CJ
    --Data Inputs
    dbus         : in  std_logic_vector(7 downto 0);   
    y_reg        : in  std_logic_vector(7 downto 0);   
    dtcl         : in  std_logic_vector(7  downto 0);  
    dfm          : in  std_logic_vector(7  downto 0);  
    --Control Outputs
    sleep        : out std_logic;  
    inv_psmsb    : out std_logic;  
    trace        : out std_logic;  
    ld_nreg      : out std_logic;  
    reqrun       : out std_logic;  
    wdog_n       : out std_logic;  
    ld_crb       : out std_logic;  
    rst_seqc_n   : out std_logic;  
    --Data Outputs
    dsi          : out std_logic_vector(7 downto 0);  
    --Microprogram address outputs
    mpga         : out std_logic_vector(7 downto  0); --CJ
    curr_mpga    : out std_logic_vector(7 downto  0); --CJ
    mar          : out std_logic_vector(7 downto  0)); --CJ
end;

architecture rtl of clc is
  -- Overlapping mpgm fields
  signal pl_map    : std_logic_vector(3 downto 0); 
  signal pl_aux1   : std_logic_vector(2 downto 0); 
  -- Internal buses
  signal pc        : std_logic_vector(7 downto 0); --CJ
  signal di        : std_logic_vector(7 downto 0); 
                                                   
  signal ir        : std_logic_vector(7 downto 0);
  signal irq       : std_logic_vector(2 downto 0);
  -- Stack
  signal st_ctr    : std_logic_vector(4 downto 0);
  signal st_out    : std_logic_vector(13 downto 0); --CJ
  signal st_full   : std_logic; 
  signal st_empty  : std_logic; 
  signal st_push   : std_logic; 
  signal st_pop    : std_logic; 
  signal st_we_n   : std_logic; 
  -- Loop counter/register
  signal ctr_in    : std_logic_vector(7 downto 0);-- Counter/register input --CJ
                                                   -- bus
  signal ctr_out   : std_logic_vector(7 downto 0);-- Counter/register output --CJ
                                                   -- bus
  signal ctr_eq0   : std_logic; 
  signal ctr_dec   : std_logic; 
  signal ctr_ld    : std_logic; 
  -- Conditions
  signal sel_cond  : std_logic; 
  signal cpass     : std_logic; 
  -- PA pulse field decode
  signal ld_special: std_logic; 
  signal ld_ir     : std_logic; 
  signal cuirq     : std_logic; 
  signal ld_fwi    : std_logic; 
  signal ld_trace  : std_logic; 
  signal set_ackclk: std_logic; 
  signal ld_invps  : std_logic; 
  signal selblk_pa : std_logic; 
  -- From SCT, select block
  signal selblk_aux1: std_logic;
  -- Request flipflops
  signal special   : std_logic; 
  signal fwi       : std_logic; 
  signal ack_clkreq: std_logic; 
                                
  -- Synchronization of request signals
  signal clkreq    : std_logic; 
                                
  signal clkreq_s1 : std_logic; 
  signal clkreq_s2 : std_logic; 
  signal irq0_s1   : std_logic; 
  signal irq1_s1   : std_logic; 
  signal irq0_s2   : std_logic; 
  signal irq1_s2   : std_logic; 
  -- Internal copies of output signals
  signal mpga_int  : std_logic_vector(7 downto 0); --CJ
  --signal mpga_int_b  : std_logic_vector(13 downto 0);--buffer added by maning
  signal curr_mpga_int: std_logic_vector(7 downto  0); --CJ
  signal trace_int : std_logic;
  signal stack_in  : std_logic_vector(13 downto 0);
  
  signal pl_sig0      : std_logic_vector(4 downto 0);
  signal pl_sig1      : std_logic_vector(5 downto 0);
  signal pl_sig2      : std_logic;                    
  signal pl_sig8        : std_logic_vector(11 downto 0);
  signal pl_sig12      : std_logic;        
  signal pl_sig18   : std_logic_vector(3 downto 0);
  signal pl_sig15     : std_logic_vector(4 downto 0);
  signal pl_ld_mpgm  : std_logic; --Added by CJ

  

begin
  -- Create named signals for overlapping microprogram fields.
  pl_sig1 <= pl(115)&pl(52)&pl(73)&pl(78)&pl(57)&pl(46);
  pl_sig8   <= pl(28)&pl(62)&(pl(26) xor pl(17))&(pl(3) xor pl(59))&(pl(58) xor pl(28))&pl(17)&pl(10)&pl(59)&(pl(4)xor pl(76))&(pl(37) xor pl(75))&pl(13)&pl(24) ;
  pl_map  <= (pl(4)xor pl(76))&(pl(37) xor pl(75))&pl(13)&pl(24);
  pl_aux1 <= pl_sig1(4 downto 2);
  pl_ld_mpgm <= ld_mpgm; --Added by CJ
----------------------------------------------------------------------
  -- Sequence control decode logic. 
----------------------------------------------------------------------

  pl_sig0 <= pl(42)&pl(74)&pl(15)&pl(5)&pl(34);
  pl_sig2 <= pl(61) xor pl(14);
  sct1 : entity work.sct
    port map (
      -- Clock and reset inputs
      clk_p        => clk_p,
      clk_e_pos     => clk_e_pos,
      rst_en       => rst_en,
      pl_seqc      => pl_sig0,
      pl_cond      => pl_sig1,
      pl_cpol      => pl_sig2,
      pl_ad        => pl_sig8,
      ld_mpgm      => pl_ld_mpgm, --Added by CJ
      ira1         => special,
      ira2         => ira2,
      st_full      => st_full,
      st_empty     => st_empty,
      ctr_eq0      => ctr_eq0,
      cond_pass    => cpass,
      --dfm_vld      => dfm_vld, --CJ
      data_vld      => mp_vld,    --CJ
      di           => di,
      y_reg        => y_reg,
      pc           => pc,
      sout         => st_out(7 downto 0), --CJ
      rout         => ctr_out,
      st_push      => st_push,
      st_pop       => st_pop,
      st_we_n      => st_we_n,
      ctr_dec      => ctr_dec,
      ctr_ld       => ctr_ld,
      selblk_aux1  => selblk_aux1,
      rst_seqc_n   => rst_seqc_n,
      dsi          => dsi,
      rin          => ctr_in,
      mpa          => mpga_int);
  mpga <= mpga_int;

----------------------------------------------------------------------
  -- Microprogram stack memory. 
----------------------------------------------------------------------
  --stack_in <= curr_mpga_int(13 downto 12) & pc(11 downto 0);--CJ
  stack_in <= "000000" & pc;
  stack9x141 : entity work.stack9x14(register_based)
    port map (
        rst_en => rst_en,
      clk_p        => clk_p,
      clk_e_pos     => clk_e_pos,
      stack_ctr    => st_ctr,
      stack_we_n   => st_we_n,
      stack_empty  => st_empty,
      stack_full   => st_full,
      stack_in     => stack_in,
      stack_out    => st_out);

----------------------------------------------------------------------
  -- Microprogram stack counter. 
----------------------------------------------------------------------
 
  stack_counter : process (clk_p)  
  begin 
    if rising_edge(clk_p) then
        if rst_en = '0' then
            st_ctr <= (others => '1'); 
        elsif clk_e_pos = '0' then
            if st_push = '1' and st_pop = '1' then  -- Both push and pop does reset
              st_ctr <= (others => '1');                              
            elsif st_push = '1' then     -- Push (may wrap)
              st_ctr <= st_ctr(3 downto 0) & (not st_ctr(4));
            elsif st_pop = '1' and st_empty = '0' then -- Pop if not emtpy
                                                       -- (don't wrap)
              st_ctr <= (not st_ctr(0)) & st_ctr(4 downto 1);
            end if;
        end if;
    end if;
  end process;

----------------------------------------------------------------------
  -- Loop counter/register. 
----------------------------------------------------------------------
  -- The counter/register is used as loop counter and as an address
  -- register. It can be loaded from the ctr_in bus, when ctr_ld is
  -- high, or decremented, by 1 or by 2 depending on the dbl_direct
  -- signal, when ctr_dec is high.
  Loopcounter : process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            ctr_out <= (others => '0');
        elsif (clk_e_pos = '0') then
            if ctr_ld = '1' then             -- Load ctr from ctr_in
              ctr_out <= ctr_in;
            elsif ctr_dec = '1' then         -- Decrement ctr..
              if dbl_direct = '0' then       -- ..by one if single step
                ctr_out <= ctr_out - 1;
              else                           -- ..by two if double step
                ctr_out <= ctr_out - 2;
              end if;
            end if;
         end if;
    end if;
  end process;

  -- The ctr_eq0 signal is active (high) when the counter/register
  -- is zero or, if dbl_direct is set (double stepping is active), at
  -- least the high eleven bits of it are zero.
  --ctr_eq0 <= '1' when ctr_out(11 downto 1) = 0 and
             --(ctr_out(0) = '0' or dbl_direct = '1') else '0';--CJ
  ctr_eq0 <= '1' when ctr_out(7 downto 1) = 0 and
             (ctr_out(0) = '0' or dbl_direct = '1') else '0'; 
  
----------------------------------------------------------------------
  -- Program counter register/incrementor. 
----------------------------------------------------------------------
	-- add mpga buffer for timing by maning
	-- process (clk_p)
	-- begin
	    -- if (falling_edge(clk_p)) then
	        -- if rst_en = '0' then
	            -- mpga_int_b <= (others => '0');
		    -- elsif clk_e_pos = '0' then
				-- mpga_int_b <= mpga_int;
			-- end if;
		-- end if;
	-- end process;
  -- curr_mpga holds the address of the microinstruction currently
  -- under execution. It is loaded by the same edge that loads the
  -- corresponding microprogram word into the pipeline register.  
  -- process (clk_p)
  -- begin
	-- if rising_edge(clk_p) then 
	    -- if rst_en = '0' then
	        -- curr_mpga_int <= (others => '0');
        -- elsif (clk_e_pos = '0') then
            -- curr_mpga_int <= mpga_int_b;
        -- end if;
    -- end if;
  -- end process;	

  process (clk_p)
  begin
	if rising_edge(clk_p) then 
		if rst_en = '0' then
	        curr_mpga_int <= (others => '0');
        elsif (clk_e_pos = '0') then
            curr_mpga_int <= mpga_int;
        end if;
    end if;
  end process;
  curr_mpga <= curr_mpga_int;
  pl_sig18 <= (pl(60) xor pl(68))&pl(56)&(pl(16) xor pl(35))&pl(68);
  
  -- pc is the address of the next instruction. It is used by the
  -- sequence control decode logic to generate addresses when the
  -- program is not jumping. pc wraps at 4k word boundaries.
  -- The two high bits are unchanged when there is no select block
  -- operation.
  --pc(11 downto 0)  <= curr_mpga_int(11 downto 0) + 1;   -- Increment low 12
                                                        -- bits, wrap at 4k
    pc <= curr_mpga_int + 1; --CJ
  --pc(13 downto 12) <= pl_sig18(1 downto 0) when selblk_pa = '1' else       --Deleted by CJ
  --                    pl_aux1(2 downto 1) when selblk_aux1 = '1' else     --Deleted by CJ
  --                    curr_mpga_int(13 downto 12);     --Deleted by CJ

  -- Microprogram Address Register. This register is loaded at every
  -- clock edge in stop mode or at CALL SP in run mode. Its purpose
  -- is to present the microprogram address for the debugger (CPC).
  process (clk_p) 
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            mar <= (others => '0');
        elsif (clk_e_pos = '0') then
            if ld_mar = '1' then
              --mar(13 downto 0) <= curr_mpga_int(13 downto 0); --CJ
              mar <= curr_mpga_int; --CJ
            end if;
        end if;
    end if;
  end process;

----------------------------------------------------------------------
  -- Source select for the di bus. 
----------------------------------------------------------------------
  -- Priority encoder. Encodes the ENDDECODE interrupt requests according
  -- to their priority into the irq vector. Priority "000" (highest) is
  -- unused. irq = "111" means no request.
  PRE: process (flag_pccy, irq0_s2, irq1_s2, clkreq_s2, spreq_n,
                fwi)
  begin
    if spreq_n = '0' then       -- Highest priorty
      irq <= "001";
    elsif fwi = '1' then
      irq <= "010";
    elsif clkreq_s2 = '1' then
      irq <= "011";
    elsif irq1_s2 = '0' then
      irq <= "100";
    elsif irq0_s2 = '0' then
      irq <= "101";
    elsif flag_pccy = '1' then  -- Lowest priorty
      irq <= "110";
    else                        -- No request                           
      irq <= "111";
    end if;
  end process;

  -- Next Address Selector (32 to 8 mux). Selects source for the di
  -- bus, which is used to generate address at some decode and vector
  -- jumps.
  NAS : process (pl_map, flag_link, flag_zero, flag_pccy,
                 flag_carry, irq, ir, dfm, dtcl, trace_int)
  begin
    case pl_map(1 downto 0) is  
      when "00"   => di <= flag_link & flag_zero & flag_pccy &
                           flag_carry & trace_int & irq;   --LZPCIRQ
      when "01"   => di <= ir;     -- Instruction Register
      when "10"   => di <= dfm;    -- Data from MMR
      when "11"   => di <= dtcl;   -- SP command
      when others => null;
    end case;
  end process;

----------------------------------------------------------------------
  -- Condition Select Logic (32 to 1 mux). 
----------------------------------------------------------------------
  -- Select the desired condition flag (controlled by pl_sig1).
  CSL : process (pl_sig1, spreq_n, flag_zero, flag_oflow, d_sign, spack_n,
                 flag_carry, flag_yeqneg, psc_empty, flag_fc, y_bittst,
                 flag_fh, flag_pccy, psc_afull, flag_neg, flag_link,
                 psc_full, special, flag_fz, flag_fp, psc_aempty,
                 flag_fn, flag_qlsb, flag_fv, ctr_eq0, adl_cy,ve_rdy,re_rdy,dfm_rdy,
                 fifo_rdy, buf_empty, continue)
	  variable flag_less		: std_logic; -- LESS flag = NEG xor OVERFLOW
	  variable flag_fl			: std_logic; -- FL flag = FN xor FV
	  variable flag_greater	: std_logic; -- GREATER flag = not LESS and not ZERO
	  variable flag_fg			: std_logic; -- FG flag = not FL and not FZ
	  variable flag_above		: std_logic; -- ABOVE flag = CARRY and not ZERO (BELOW = not CARRY)
  	variable flag_fa			: std_logic; -- FA flag = FC and not FZ
  	variable flag_dsxfc		: std_logic; -- DSXFC flag = d_sign xor FC
  begin
    -- Locally generated flag combinations
    flag_less := flag_neg xor flag_oflow;       
    flag_fl := flag_fn xor flag_fv;     
    flag_greater := not flag_less and not flag_zero;    
    flag_fg := not flag_fl and not flag_fz;     
    flag_above := flag_carry and not flag_zero; 
    flag_fa := flag_fc and not flag_fz;
    flag_dsxfc := d_sign xor flag_fc;
    
    case pl_sig1(5 downto 0) is
      when COND_ZERO =>    sel_cond <= flag_zero;     
      when COND_CARRY =>   sel_cond <= flag_carry;    
      when COND_FH =>      sel_cond <= flag_fh;       
      when COND_NEG =>     sel_cond <= flag_neg;      
      when COND_FZ =>      sel_cond <= flag_fz;       
      when COND_FC =>      sel_cond <= flag_fc;       
      when COND_FN =>      sel_cond <= flag_fn;       
      when COND_FV =>      sel_cond <= flag_fv;       
      when COND_OVERFLOW =>sel_cond <= flag_oflow;    
      when COND_LESS =>    sel_cond <= flag_less;     
      when COND_PCCY =>    sel_cond <= flag_pccy;     
      when COND_LINK =>    sel_cond <= flag_link;     
      when COND_ODD =>     sel_cond <= flag_fp;       
      when COND_FL =>      sel_cond <= flag_fl;       
      when COND_QLSB =>    sel_cond <= flag_qlsb;     
      when COND_CNDFALSE =>sel_cond <= '0';           
      when COND_DSXFC =>   sel_cond <= flag_dsxfc;    
      when COND_YBITSET => sel_cond <= y_bittst;      
      when COND_PSCAFU =>  sel_cond <= psc_afull;     
      when COND_PSCFULL => sel_cond <= psc_full;      
      when COND_PSCAEM =>  sel_cond <= psc_aempty;    
      when COND_PSCEM =>   sel_cond <= psc_empty;     
      when COND_CTREQ0 =>  sel_cond <= ctr_eq0;       
      when COND_GREATER => sel_cond <= flag_greater;  
      when COND_NSPREQ =>  sel_cond <= spreq_n;       
      when COND_NSPACK =>  sel_cond <= spack_n;       
      when COND_FG =>      sel_cond <= flag_fg;       
      when COND_ABOVE =>   sel_cond <= flag_above;    
      when COND_SPECIAL => sel_cond <= special;       
      when COND_YEQNEG =>  sel_cond <= flag_yeqneg;   
      when COND_FA =>      sel_cond <= flag_fa;       
      when COND_ADLCY =>   sel_cond <= adl_cy;
      when COND_VE_RDY   =>sel_cond <= ve_rdy; --Added by CJ
      when COND_RE_RDY   =>sel_cond <= re_rdy; --Added by CJ
      when COND_DFM_RDY  =>sel_cond <= dfm_rdy; --Added by CJ
      when COND_FIFO_RDY =>sel_cond <= fifo_rdy; --Added by CJ
      when COND_CONT     =>sel_cond <= continue; --Added by CJ
      when COND_BUF_EMPTY => sel_cond <= buf_empty;        
      when others  => sel_cond <= '0';
    end case;
  end process;

  
  cpass <= sel_cond xor pl_sig2;  --cpass=1 IF ...(true) else cpass=0
                                  --cpass=1 IF NOT ...(true) else cpass=0

----------------------------------------------------------------------
  -- Pulse field PA decode, request flipflops, and instruction reg. 
----------------------------------------------------------------------
  pl_sig12 <= pl(71) xor pl(77);
  process (pl_sig18, pl_sig12)
  begin
    -- Default, all inactive
    ld_nreg <= '0';
    ld_special <= '0';
    ld_ir <= '0';
    cuirq <= '0';
    selblk_pa <= '0';

    if pl_sig12 = '0' then
      case pl_sig18 is
        when PA_LOADNREG =>     -- (0001) LOAD NREG
          ld_nreg <= '1';
        when PA_RESSPEC|
          PA_SETSPEC =>         -- (001x) RESET/SET SPECIAL
          ld_special <= '1';
        when PA_LOADIR =>       -- (1000) LOAD IR
          ld_ir <= '1';
        when PA_CUIRQ =>        -- (1001) CUIRQ
          cuirq <= '1';
        when PA_SELBLK0|
          PA_SELBLK1|
          PA_SELBLK2|
          PA_SELBLK3 =>         -- (11xx) SELECT BLKx
          selblk_pa <= '1';
        when others => null;  
      end case;
    end if;
  end process;

  pl_sig15 <= pl(23)&pl(6)&pl(54)&pl(27)&pl(49);
  process (cuirq, pl_sig15, rst_en)
  begin
    -- Default, all inactive
    ld_crb <= '0';
    ld_fwi <= '0';
    ld_trace <= '0';
    set_ackclk <= '0';
    sleep <= '0';
    ld_invps <= '0';

    if cuirq = '1' then
      if pl_sig15(4) = '1' then         -- (1xxxx) LOAD CRBx
        ld_crb <= '1';
      else
        case pl_sig15 is
          when CUIRQ_RSTFWI|
            CUIRQ_SETFWI =>             -- (0000x) RESET/SET FWI
            ld_fwi <= '1';
          when CUIRQ_RSTTRACE|
            CUIRQ_SETTRACE =>           -- (0001x) RESET/SET TRACE
            ld_trace <= '1';
          when CUIRQ_ACKCLK =>          -- (00100) ACK CLKREQ
            set_ackclk <= '1';
          when CUIRQ_SLEEP =>           -- (00101) SLEEP
            if rst_en = '1' then
              sleep <= '1';             -- sleep is disabled by reset
            end if;
          when CUIRQ_RSTINVPS|
            CUIRQ_SETINVPS =>           -- (0011x) RESET/SET INVPS
            ld_invps <= '1';
          when others => null;          
        end case;
      end if;
    end if;
  end process;

  RFF : process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            special      <= '0';
            fwi          <= '0';
            trace_int    <= '0';
            ack_clkreq   <= '0';
            inv_psmsb    <= '0';
        elsif (clk_e_pos = '0') then
            if ld_special = '1' then
              special <= pl_sig18(0);       -- SPECIAL flag
            end if;
            if ld_fwi = '1' then
              fwi <= pl_sig15(0);             -- FWI flag
            end if;
            if ld_trace = '1' then
              trace_int <= pl_sig15(0);       -- TRACE flag
            end if;
            if set_ackclk = '1' then
              ack_clkreq <= '1';              -- ACK CLKREQ pulse
            else
              ack_clkreq <= '0';
            end if;
            if ld_invps = '1' then
              inv_psmsb <= pl_sig15(0);       -- INVPS flag
            end if;  
        end if;
    end if;
  end process;
  trace <= trace_int;

  -- Instruction register. Loaded from the D bus when ld_ir is set.
  IRG : process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            ir <= (others => '0');
        elsif (clk_e_pos = '0') then
            if ld_ir = '1' then
              ir <= dbus;
            end if;
        end if;
    end if;
  end process;

----------------------------------------------------------------------
  -- Clock request and external interrupt requests. 
----------------------------------------------------------------------
  
  process (clk_p)
  begin
	if rising_edge(clk_p) then
		if rst_en = '0' then
			clkreq <= '0';
		elsif ack_clkreq = '1' then
			clkreq <= '0';
		elsif (clkreq_gen = '1') then
            clkreq <= '1';
        end if;
    end if;
  end process;

  process (clk_p)
  begin
    if rising_edge(clk_p) then 
        if rst_en = '0' or en_wdog = '0' then
            wdog_n <= '1';
        elsif (clkreq_gen = '1') then
            wdog_n <= not clkreq;  -- Watch dog reset (active low)
        end if;
    end if;
  end process;
  
  process (clk_p)
  begin
    if rising_edge(clk_p) then 
        if rst_en = '0' then
            clkreq_s1 <= '0';
            clkreq_s2 <= '0';
        elsif clk_e_pos = '0' then
            clkreq_s1 <= clkreq;
            clkreq_s2 <= clkreq_s1;
        end if;
    end if;
  end process;

  process (clk_p)
  begin
    if rising_edge(clk_p) then
        if  rst_en = '0' then
            irq0_s1 <= '0';
            irq1_s1 <= '0';
            irq0_s2 <= '0';
            irq1_s2 <= '0';
        elsif clk_e_pos = '0' then
            irq0_s1 <= irq0;
            irq1_s1 <= irq1;
            irq0_s2 <= irq0_s1;
            irq1_s2 <= irq1_s1;
        end if;
    end if;
  end process;

  -- Active high signal reqrun used as a wake-up signal after sleep
  -- mode in TIM.
  reqrun <= '1' when (irq0 = '0' and pup_irq(0) = '1') or
            (irq1 = '0' and pup_irq(1) = '1') or
            (clkreq = '1' and pup_clk = '1') else
            '0';
end;

