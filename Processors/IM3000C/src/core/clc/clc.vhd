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
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mpgmfield_lib.all;

entity clc is
  port(
    -- Clock and reset inputs
    clk_e        : in  std_logic;  -- Execution clock
    rst_en       : in  std_logic;  -- Reset input (active  low)
    -- Microprogram fields
    pl_seqc      : in  std_logic_vector(4 downto 0);
    pl_cond      : in  std_logic_vector(4 downto 0);
    pl_cpol      : in  std_logic;                    
    pl_ad        : in  std_logic_vector(11 downto 0);
    pl_alud      : in  std_logic_vector(2  downto 2);        
    pl_shin_pa   : in  std_logic_vector(3 downto 0);
    pl_aaddr     : in  std_logic_vector(4 downto 0);
    -- Static control inputs
    dbl_direct   : in  std_logic;  -- Double step control input
    pup_irq      : in  std_logic_vector(1 downto 0); -- Enable wake on IRQ
    pup_clk      : in  std_logic;  -- Enable wake on CLKREQ
    en_wdog      : in  std_logic;  -- Enable microprogram watchdog
    -- Control inputs
    ld_mar       : in  std_logic;  -- Load mpgm addr in MAR (from TIM)
    clkreq_gen   : in  std_logic;  -- Clock request timer (from TIM)          
    ira2         : in  std_logic;  -- PSCTR carry-out flip-flop (from GMEM)
    irq0         : in  std_logic;  -- External interrupt input 0 (from PERI)
    irq1         : in  std_logic;  -- External interrupt input 1 (from PERI)
    -- Condition inputs
    spreq_n      : in  std_logic;  -- SP request, from TIM (active low)
    spack_n      : in  std_logic;  -- SP acknowledge, from TIM (active low)
    d_sign	     : in  std_logic;  -- Sign bit register from D bus
    y_bittst     : in  std_logic;  -- Testbit from Y bus register
    flag_fn      : in  std_logic;  -- Fast neg flag, from ALU
    flag_fc      : in  std_logic;  -- Fast carry flag, from ALU
    flag_fz      : in  std_logic;  -- Fast zero flag, from ALU
    flag_fv      : in  std_logic;  -- Fast overflow flag, from ALU
    flag_fh      : in  std_logic;  -- Fast halfcarry flag, from ALU
    flag_fp      : in  std_logic;  -- ALU odd parity flag, from ALU
    flag_neg     : in  std_logic;  -- Neg (sign) flipflop, from ALU
    flag_carry   : in  std_logic;  -- Carry  flipflop, from ALU
    flag_zero    : in  std_logic;  -- Zero flipflop, from ALU
    flag_oflow   : in  std_logic;  -- Overflow flipflop, from ALU
    flag_link    : in  std_logic;  -- Link flipflop, from ALU
    flag_pccy    : in  std_logic;  -- PCCY (program counter carry) ff
    flag_qlsb    : in  std_logic;  -- Q register lsb, from ALU
    psc_afull    : in  std_logic;  -- Pstack almost full flag, from GMEM
    psc_full     : in  std_logic;  -- Pstack full flag, from GMEM
    psc_aempty   : in  std_logic;  -- Pstack almost empty flag, from GMEM
    psc_empty    : in  std_logic;  -- Pstack empty flag, from GMEM
    flag_yeqneg  : in  std_logic;  -- Y equals neg flipflop flag, from DSL
    adl_cy       : in  std_logic;  -- from MMR, carry out from ADL
    --Data Inputs
    dbus         : in  std_logic_vector(7 downto 0);   -- D bus
    y_reg        : in  std_logic_vector(7 downto 0);   -- Y bus register
    dtcl         : in  std_logic_vector(7  downto 0);  -- Data from CPC-block
    dfm          : in  std_logic_vector(7  downto 0);  -- Data from memory
    --Control Outputs
    sleep        : out std_logic;  -- Put clk_e generation in stopmode (to TIM)
    inv_psmsb    : out std_logic;  -- Invert pstack msb flipflop (to GMEM, DSL)
    trace        : out std_logic;  -- Trace flag (to DSL)
    ld_nreg      : out std_logic;  -- Load NREG (to MBM)
    reqrun       : out std_logic;  -- Wake-up signal after sleep mode (to TIM)
    wdog_n       : out std_logic;  -- Watch dog reset (to TIM)
    ld_crb       : out std_logic;  -- Load CRB register (to CRB)
    rst_seqc_n   : out std_logic;  -- SEQC controlled reset (to CRB stick bit)
    --Data Outputs
    dsi          : out std_logic_vector(7 downto 0);   -- Data to DSL
    --Microprogram address outputs
    mpga         : out std_logic_vector(13 downto  0); -- Mpgm address to
                                                       -- memories
    curr_mpga    : out std_logic_vector(13 downto  0); -- Current mpgm address
    mar          : out std_logic_vector(13 downto  0)); -- Mpgm address to CPC
end;

architecture rtl of clc is
  -- Overlapping mpgm fields
  signal pl_map    : std_logic_vector(3 downto 0); -- MAP field (AD(3:0))
  signal pl_aux1   : std_logic_vector(2 downto 0); -- AUX1 field (COND(4:2))
  -- Internal buses
  signal pc        : std_logic_vector(13 downto 0);-- Program counter register
  signal di        : std_logic_vector(7 downto 0); -- Next address selector
                                                   -- output            
  signal ir        : std_logic_vector(7 downto 0);-- Instruction register
  signal irq       : std_logic_vector(2 downto 0);-- Request code
  -- Stack
  signal st_ctr    : std_logic_vector(4 downto 0);-- Stack counter
  signal st_out    : std_logic_vector(13 downto 0);     -- Stack output
  signal st_full   : std_logic; -- Stack full flag
  signal st_empty  : std_logic; -- Stack empty flag
  signal st_push   : std_logic; -- Increment stack counter signal
  signal st_pop    : std_logic; -- Decrement stack counter signal
  signal st_we_n   : std_logic; -- Stack write enable (active low)
  -- Loop counter/register
  signal ctr_in    : std_logic_vector(11 downto 0);-- Counter/register input
                                                   -- bus
  signal ctr_out   : std_logic_vector(11 downto 0);-- Counter/register output
                                                   -- bus
  signal ctr_eq0   : std_logic; -- Counter zero flag
  signal ctr_dec   : std_logic; -- Counter decrement signal
  signal ctr_ld    : std_logic; -- Counter/register load signal
  -- Conditions
  signal sel_cond  : std_logic; -- Selected condition
  signal cpass     : std_logic; -- Polarized selected condition (high on pass)
  -- PA pulse field decode
  signal ld_special: std_logic; -- Load special flipflop
  signal ld_ir     : std_logic; -- Load instruction register
  signal cuirq     : std_logic; -- If set, decode AADDR field for pulses below
  signal ld_fwi    : std_logic; -- Load fwi flipflop
  signal ld_trace  : std_logic; -- Load trace flipflop
  signal set_ackclk: std_logic; -- Set ack_clkreq flipflop
  signal ld_invps  : std_logic; -- Load invps flipflop
  signal selblk_pa : std_logic; -- Select block PA function
  -- From SCT, select block
  signal selblk_aux1: std_logic;  -- Select block AUX1 function
  -- Request flipflops
  signal special   : std_logic; -- special flipflop, loadable
  signal fwi       : std_logic; -- fwi flipflop, loadable
  signal ack_clkreq: std_logic; -- ack_clkreq flipflop, will pulse to reset
                                -- clkreq 
  -- Synchronization of request signals
  signal clkreq    : std_logic; -- Asynchronous clkreq signal, set by
                                -- clkreq_gen edge
  signal clkreq_s1 : std_logic; -- clkreq synchronized by one flipflop
  signal clkreq_s2 : std_logic; -- clkreq synchronized by two flipflops
  signal irq0_s1   : std_logic; -- irq0 synchronized by one flipflop
  signal irq1_s1   : std_logic; -- irq1 synchronized by one flipflop
  signal irq0_s2   : std_logic; -- irq0 synchronized by two flipflops
  signal irq1_s2   : std_logic; -- irq1 synchronized by two flipflops
  -- Internal copies of output signals
  signal mpga_int  : std_logic_vector(13 downto 0);
  signal curr_mpga_int: std_logic_vector(13 downto  0);
  signal trace_int : std_logic;
  signal stack_in  : std_logic_vector(13 downto 0);
begin
  -- Create named signals for overlapping microprogram fields.
  pl_map  <= pl_ad(3 downto 0);
  pl_aux1 <= pl_cond(4 downto 2);

----------------------------------------------------------------------
  -- Sequence control decode logic. 
----------------------------------------------------------------------
  sct1 : entity work.sct
    port map (
      -- Clock and reset inputs
      clk_e        => clk_e,
      rst_en       => rst_en,
      pl_seqc      => pl_seqc,
      pl_cond      => pl_cond,
      pl_cpol      => pl_cpol,
      pl_ad        => pl_ad,
      ira1         => special,
      ira2         => ira2,
      st_full      => st_full,
      st_empty     => st_empty,
      ctr_eq0      => ctr_eq0,
      cond_pass    => cpass,
      di           => di,
      y_reg        => y_reg,
      pc           => pc,
      sout         => st_out,
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
  stack_in <= curr_mpga_int(13 downto 12) & pc(11 downto 0);
  stack9x141 : entity work.stack9x14
    port map (
      clk_e        => clk_e,
      stack_ctr    => st_ctr,
      stack_we_n   => st_we_n,
      stack_empty  => st_empty,
      stack_full   => st_full,
      stack_in     => stack_in,
      stack_out    => st_out);

----------------------------------------------------------------------
  -- Microprogram stack counter. 
----------------------------------------------------------------------
  -- This is the stack counter, implemented as a Johnson counter. At
  -- reset, it is set to "11111". At each push, a zero is shifted in
  -- from the right until the entire counter contains zeroes, then ones
  -- are shifted in until it contains "01111". This represents the full
  -- state, and requires nine pushes from empty. 
  stack_counter : process (clk_e)  
  begin 
    if rising_edge(clk_e) then
      if st_push = '1' and st_pop = '1' then  -- Both push and pop does reset
        st_ctr <= (others => '1');                              
      elsif st_push = '1' then     -- Push (may wrap)
        st_ctr <= st_ctr(3 downto 0) & (not st_ctr(4));
      elsif st_pop = '1' and st_empty = '0' then -- Pop if not emtpy
                                                 -- (don't wrap)
        st_ctr <= (not st_ctr(0)) & st_ctr(4 downto 1);
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
  Loopcounter : process (clk_e)
  begin
    if rising_edge(clk_e) then
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
  end process;

  -- The ctr_eq0 signal is active (high) when the counter/register
  -- is zero or, if dbl_direct is set (double stepping is active), at
  -- least the high eleven bits of it are zero.
  ctr_eq0 <= '1' when ctr_out(11 downto 1) = 0 and
             (ctr_out(0) = '0' or dbl_direct = '1') else '0';
  
----------------------------------------------------------------------
  -- Program counter register/incrementor. 
----------------------------------------------------------------------
  -- curr_mpga holds the address of the microinstruction currently
  -- under execution. It is loaded by the same edge that loads the
  -- corresponding microprogram word into the pipeline register.  
  process (clk_e)
  begin
    if rising_edge(clk_e) then 
      curr_mpga_int <= mpga_int;
    end if;
  end process;
  curr_mpga <= curr_mpga_int;
  
  -- pc is the address of the next instruction. It is used by the
  -- sequence control decode logic to generate addresses when the
  -- program is not jumping. pc wraps at 4k word boundaries.
  -- The two high bits are unchanged when there is no select block
  -- operation.
  pc(11 downto 0)  <= curr_mpga_int(11 downto 0) + 1;   -- Increment low 12
                                                        -- bits, wrap at 4k
  pc(13 downto 12) <= pl_shin_pa(1 downto 0) when selblk_pa = '1' else
                      pl_aux1(2 downto 1) when selblk_aux1 = '1' else
                      curr_mpga_int(13 downto 12);

  -- Microprogram Address Register. This register is loaded at every
  -- clock edge in stop mode or at CALL SP in run mode. Its purpose
  -- is to present the microprogram address for the debugger (CPC).
  process (clk_e) 
  begin
    if rising_edge(clk_e) then
      if ld_mar = '1' then
        mar(13 downto 0) <= curr_mpga_int(13 downto 0);
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
  -- Select the desired condition flag (controlled by pl_cond).
  CSL : process (pl_cond, spreq_n, flag_zero, flag_oflow, d_sign, spack_n,
                 flag_carry, flag_yeqneg, psc_empty, flag_fc, y_bittst,
                 flag_fh, flag_pccy, psc_afull, flag_neg, flag_link,
                 psc_full, special, flag_fz, flag_fp, psc_aempty,
                 flag_fn, flag_qlsb, flag_fv, ctr_eq0, adl_cy)
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
    
    case pl_cond(4 downto 0) is
      when COND_ZERO =>    sel_cond <= flag_zero;     -- (00000) ZERO
      when COND_CARRY =>   sel_cond <= flag_carry;    -- (00001) CARRY
      when COND_FH =>      sel_cond <= flag_fh;       -- (00010) FH
      when COND_NEG =>     sel_cond <= flag_neg;      -- (00011) NEG
      when COND_FZ =>      sel_cond <= flag_fz;       -- (00100) FZ
      when COND_FC =>      sel_cond <= flag_fc;       -- (00101) FC
      when COND_FN =>      sel_cond <= flag_fn;       -- (00110) FN
      when COND_FV =>      sel_cond <= flag_fv;       -- (00111) FV
      when COND_OVERFLOW =>sel_cond <= flag_oflow;    -- (01000) OVERFLOW
      when COND_LESS =>    sel_cond <= flag_less;     -- (01001) LESS
      when COND_PCCY =>    sel_cond <= flag_pccy;     -- (01010) PCCY
      when COND_LINK =>    sel_cond <= flag_link;     -- (01011) LINK
      when COND_ODD =>     sel_cond <= flag_fp;       -- (01100) YREGODD/YREGEVEN
      when COND_FL =>      sel_cond <= flag_fl;       -- (01101) FL;
      when COND_QLSB =>    sel_cond <= flag_qlsb;     -- (01110) QLSB
      when COND_CNDFALSE =>sel_cond <= '0';           -- (01111) CONDFALSE/UNCOND
      when COND_DSXFC =>   sel_cond <= flag_dsxfc;    -- (10000) DSXFC
      when COND_YBITSET => sel_cond <= y_bittst;      -- (10001) YREGBITSET
      when COND_PSCAFU =>  sel_cond <= psc_afull;     -- (10010) PSCAFU
      when COND_PSCFULL => sel_cond <= psc_full;      -- (10011) PSCFULL
      when COND_PSCAEM =>  sel_cond <= psc_aempty;    -- (10100) PSCAEM
      when COND_PSCEM =>   sel_cond <= psc_empty;     -- (10101) PSCEM
      when COND_CTREQ0 =>  sel_cond <= ctr_eq0;       -- (10110) CTREQ0
      when COND_GREATER => sel_cond <= flag_greater;  -- (10111) GREATER  
      when COND_NSPREQ =>  sel_cond <= spreq_n;       -- (11000) SPREQ
      when COND_NSPACK =>  sel_cond <= spack_n;       -- (11001) SPACK
      when COND_FG =>      sel_cond <= flag_fg;       -- (11010) FG
      when COND_ABOVE =>   sel_cond <= flag_above;    -- (11011) ABOVE
      when COND_SPECIAL => sel_cond <= special;       -- (11100) SPECIAL
      when COND_YEQNEG =>  sel_cond <= flag_yeqneg;   -- (11101) YREGEQNEG
      when COND_FA =>      sel_cond <= flag_fa;       -- (11110) FA;
      when COND_ADLCY =>   sel_cond <= adl_cy;        -- (11111) ADLCY;
      when others  => null;
    end case;
  end process;

  -- Select the desired condition polarity (in pl_cpol). The result,
  -- cpass, is used by the sequence control decode logic for
  -- conditional jumps.
  cpass <= sel_cond xor pl_cpol;  --cpass=1 IF ...(true) else cpass=0
                                  --cpass=1 IF NOT ...(true) else cpass=0

----------------------------------------------------------------------
  -- Pulse field PA decode, request flipflops, and instruction reg. 
----------------------------------------------------------------------
  -- Decode for LOAD NREG, RESET/SET SPECIAL, LOAD IR, CUIRQ and
  -- SELECT BLOCK from SHIN/PA and ALUD(2). 
  process (pl_shin_pa, pl_alud(2))
  begin
    -- Default, all inactive
    ld_nreg <= '0';
    ld_special <= '0';
    ld_ir <= '0';
    cuirq <= '0';
    selblk_pa <= '0';

    if pl_alud(2) = '0' then
      case pl_shin_pa is
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

  -- If cuirq is set, decode for RESET/SET FWI, RESET/SET TRACE,
  -- ACK CLKREQ, SLEEP, RESET/SET INVPS and LOAD CRBx from the
  -- AADDR field.
  process (cuirq, pl_aaddr, rst_en)
  begin
    -- Default, all inactive
    ld_crb <= '0';
    ld_fwi <= '0';
    ld_trace <= '0';
    set_ackclk <= '0';
    sleep <= '0';
    ld_invps <= '0';

    if cuirq = '1' then
      if pl_aaddr(4) = '1' then         -- (1xxxx) LOAD CRBx
        ld_crb <= '1';
      else
        case pl_aaddr is
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

  -- Request flipflops. Loaded from low bit of AADDR or SHIN/PA field
  -- when the corresponding enable signal, from decode above, is active.
  -- The ack_clkreq flipflop is an exception, it is always set when
  -- its enable is active, and reset when not.  
  RFF : process (clk_e, rst_en)
  begin
    if rst_en = '0' then
      special      <= '0';
      fwi          <= '0';
      trace_int    <= '0';
      ack_clkreq   <= '0';
      inv_psmsb    <= '0';
    elsif rising_edge(clk_e) then
      if ld_special = '1' then
        special <= pl_shin_pa(0);       -- SPECIAL flag
      end if;
      if ld_fwi = '1' then
        fwi <= pl_aaddr(0);             -- FWI flag
      end if;
      if ld_trace = '1' then
        trace_int <= pl_aaddr(0);       -- TRACE flag
      end if;
      if set_ackclk = '1' then
        ack_clkreq <= '1';              -- ACK CLKREQ pulse
      else
        ack_clkreq <= '0';
      end if;
      if ld_invps = '1' then
        inv_psmsb <= pl_aaddr(0);       -- INVPS flag
      end if;
    end if;
  end process;
  trace <= trace_int;

  -- Instruction register. Loaded from the D bus when ld_ir is set.
  IRG : process (clk_e)
  begin
    if rising_edge(clk_e) then
      if ld_ir = '1' then
        ir <= dbus;
      end if;
    end if;
  end process;

----------------------------------------------------------------------
  -- Clock request and external interrupt requests. 
----------------------------------------------------------------------
  -- The asynchronous (to clk_e) signal clkreq is set at positive
  -- edge of clkreq_gen and asynchronously reset by ack_clkreq. Thus
  -- clkreq can be activated even if clk_e is not running, which
  -- is necessary when using clock request to wake the processor.
  process (ack_clkreq, clkreq_gen)
  begin
    if ack_clkreq = '1' then
      clkreq <= '0';
    elsif rising_edge(clkreq_gen) then
      clkreq <= '1';
    end if;
  end process;

  -- The asynchronous (to clk_e) reset signal wdog_n is activated if
  -- a clock request is missed, detected by clkreq still being set
  -- on the next rising edge of clkreq_gen. On reset, or if it is
  -- disabled by en_wdog low, it is deactivated. wdog_n is used to
  -- reset the processor if the microprogram hangs.
  process (rst_en, en_wdog, clkreq_gen)
  begin
    if rst_en = '0' or en_wdog = '0' then
      wdog_n <= '1';
    elsif rising_edge(clkreq_gen) then
      wdog_n <= not clkreq;  -- Watch dog reset (active low)
    end if;
  end process;
  
  -- Synchronize clkreq through two flipflops to clkreq_s2. This
  -- is the synchronous clock request signal that is used by the
  -- priority encoder.
  process (clk_e)
  begin
    if rising_edge(clk_e) then 
      clkreq_s1 <= clkreq;
      clkreq_s2 <= clkreq_s1;
    end if;
  end process;

  -- Synchronize the irq0 and irq1 inputs through two pairs of
  -- flipflops to the synchronous irq0_s2 and irq1_s2 that are used
  -- by the priority encoder.
  process (clk_e)
  begin
    if rising_edge(clk_e) then
      irq0_s1 <= irq0;
      irq1_s1 <= irq1;
      irq0_s2 <= irq0_s1;
      irq1_s2 <= irq1_s1;
    end if;
  end process;

  -- Active high signal reqrun used as a wake-up signal after sleep
  -- mode in TIM.
  reqrun <= '1' when (irq0 = '0' and pup_irq(0) = '1') or
            (irq1 = '0' and pup_irq(1) = '1') or
            (clkreq = '1' and pup_clk = '1') else
            '0';
end;

