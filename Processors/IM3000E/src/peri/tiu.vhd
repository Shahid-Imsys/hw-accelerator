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
-- Title      : Timer Unit
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : tiu.vhd
-- Author     : Stefan Blixt
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
-- Date                                 Version         Author  Description
-- 2005-11-28           1.2                             CB                      Created
-- 2006-05-17           1.3                             CB                      Made it possible to generate interrupt also
--                                                                                                                              when the REP bit is set.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tiu is
  port (

    -- Interface to host  
    clk_p      : in std_logic;
    clk_p_n    : in std_logic;
    clk_c_en   : in std_logic;          -- Clock 133.3 MHz
    rst_en     : in std_logic;          -- Asynchronous master reset
    reg_wr     : in std_logic;  -- High when reg_addr is written with '1' in bit 7
    wdata      : in std_logic_vector(7 downto 0);  -- Data to write in timer
    reg_addr   : in std_logic_vector(7 downto 0);  -- Register address
    run        : in std_logic;  -- Holding this low keeps the counters from
    -- changing, without destroying parameters.
    -- Parameters can be loaded.
    tiu_enable : in std_logic;  -- Shall be low at initial reset, and when
    -- timer system is not used. Must be high
    -- when loading paramenters and when using
    -- timer system. Signal trst_n is derived
    -- from this signal.

    -- Outputs:
    tiu_irq    : out std_logic;         -- Interrupt request from timer unit
    tiu_out    : out std_logic_vector(7 downto 0);   -- Output, to DSL
    pdi_clk    : out std_logic;         -- clock to parallel data interface 
    -- Interface to I/O port logic 
    cpt_trig   : in  std_logic_vector(7 downto 0);   -- external trigger or
                                                     -- capture
    tstamp_rx1 : in  std_logic;         -- timestamp signal from Ethernet ch 1
    pulseout   : out std_logic_vector(7 downto 0));  -- Outputs to port logic

end;

architecture rtl of tiu is
  constant TIM_CH_NBR : integer := 8;   --number of timers

  type byte_bundle is array (TIM_CH_NBR-1 downto 0) of
    std_logic_vector(7 downto 0);
  type three_bundle is array (TIM_CH_NBR-1 downto 0) of
    std_logic_vector(2 downto 0);

  -- Signals between host_intf and capture
  signal evt          : std_logic_vector(TIM_CH_NBR-1 downto 0);
  signal lcd          : std_logic;
  signal cpt          : std_logic;
  signal cpe          : std_logic;
  signal cps          : std_logic;
  signal cpt_trig_int : std_logic_vector(7 downto 0);
  signal rdata        : byte_bundle;    -- Data selected by reg_addr
  signal turn_on      : std_logic_vector(TIM_CH_NBR-1 downto 0);
                                        -- turn on timer(s)
  signal turn_off_n   : std_logic_vector(TIM_CH_NBR-1 downto 0);
                                        -- turn off timer(s)
  signal reset_ifl_n  : std_logic_vector(TIM_CH_NBR-1 downto 0);
                                        -- reset ifl in timers 
  -- signals inside each timer
  signal onff         : std_logic_vector(TIM_CH_NBR-1 downto 0);
                                        -- "on" FF in timers
  signal ifl          : std_logic_vector(TIM_CH_NBR-1 downto 0);
                                        -- "ifl" FF (irpt flg) in

  -- Signals between timers 
  signal ctrldrvg    : three_bundle;    -- Signals to driving timer
  signal drv         : std_logic_vector(TIM_CH_NBR-1 downto 0);
                                        -- Select "driven" mode -- driving nxt channe
  signal tiu_out_int : std_logic_vector(TIM_CH_NBR-1 downto 0);

  -- all kinds of clocks and related signals

  signal exp         : three_bundle;    -- Prescaler ctrl
  signal genclk      : std_logic_vector(TIM_CH_NBR-1 downto 0);
  --clock precursors  
  signal clk_param   : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- clocks for write parameter in each timer
  signal clk_wr      : std_logic;       -- clock for general writing access 
  signal trst_n      : std_logic;  -- Reset signal to all parts of timer system
  signal first_clk   : std_logic;  -- Basic clk; source of other local clocks;
  signal first_clock : std_logic;  -- Basic clk; source of other local clocks;
  signal clk_t       : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- clocks for timer dwnctrs in
  signal capt_event  : std_logic;
  signal capt_pend   : std_logic;
  signal cnt_half    : std_logic;       -- Dwnctr=10000, for timer 1 only
  signal cnt_zero    : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- Dwnctr=0
  signal cnt_coi     : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- Dwnctr=coi
  signal chain_coi   : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- chained Dwnctr=coi
  signal chain_zero  : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- chained Dwnctr=0  
  signal chain_cken  : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- chained genclk  
  signal begintime   : std_logic_vector(TIM_CH_NBR-1 downto 0);
  -- Dwnctr=0 and start to count
  signal wai_edge    : std_logic_vector(TIM_CH_NBR-1 downto 0);
  signal trig_edge   : std_logic_vector(TIM_CH_NBR-1 downto 0);
  signal toggle_out  : std_logic_vector(TIM_CH_NBR-1 downto 0);
  signal ff          : std_logic_vector(7 downto 0);
  signal ff_old      : std_logic_vector(7 downto 0);  -- TEMPORARY TESTING SIGNAL
  signal frd         : std_logic_vector(TIM_CH_NBR-1 downto 0);

  signal tiu_test : std_logic_vector(TIM_CH_NBR-1 downto 0);
  
begin

-------------------------------------------------------------------------------
-- Host interface block
-------------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- Register address and bit map
  ---------------------------------------------------------------------------
  --  address  |             bit field
  --           |   7    6    5    4    3    2    1    0
  ---------------------------------------------------------------------------
  --  w0000ccc |       exp      |         msa           |
  --  w0010ccc | reqi |   tgl   |         coi           |
  --  w0100ccc | rep  |evt |drv |     wai      |   -    |
  --  w0001000 |      |lcd |cpt |            -          |
  --  10011000        reset onff (bit No = ch No)
  --  10101000        set onff   (bit No = ch No)
  --  10111000        reset ifl  (bit No = ch No)
  --  00011000        read onff  (bit No = ch No)
  --  00111000        read ifl   (bit No = ch No)

  -- Notes:
  -- w = 1/0 -> write/read; ccc = timer No.
  -- exp    : exponent;
  -- msa    : mantissan and ioReg = x"55"
  -- reqi   : interrupt request enable;
  -- tgl    : toggle mode
  -- coi    : coincidence value for toggle (coi = 0 -> no toggle)
  -- rep    : repeat counting;
  -- evt    : external event counting
  -- drv    : driving next timer; 
  -- wai    : wait for external triggering
  -- onff   : FF for turn on/off each timer
  -- ifl    : interrupt flag of each timer
  -- cpt    : external pulse capture enable
  -- lcd    : configure timer for LCD controller usage

  host_if : block
  begin

    -- Generate a one first_clk cycle pulse on turn_on, turn_off_n and
    -- reset_ifl_n if they are assigned with their active values.
    process (clk_wr, wdata, reg_addr)
    begin
      turn_on     <= (others => '0');
      turn_off_n  <= (others => '1');
      reset_ifl_n <= (others => '1');
      if clk_wr = '1' and reg_addr(3) = '1' then  -- write access
        case reg_addr(5 downto 4) is
          when "01"   => turn_off_n  <= wdata;
          when "10"   => turn_on     <= wdata;
          when "11"   => reset_ifl_n <= wdata;
          when others => null;
        end case;
      end if;
    end process;

    -- Write the capture configuration register, used only by timers
    -- 0 and 1 in combination.
    process (trst_n, clk_wr)
    begin
      if (trst_n = '0') then
        cpt <= '0';
        lcd <= '0';
      elsif rising_edge(clk_wr) then
        if (reg_addr(5 downto 3) = "001") then
          cpe <= wdata(4);
          cpt <= wdata(5);
          lcd <= wdata(6);
        end if;
      end if;
    end process;

    -- Mux out rdata from timers
    process (rdata)
      variable tmp : std_logic_vector(7 downto 0);
    begin
      tmp := (others => '0');
      for i in 0 to 7 loop               -- data bus bit slice indexing 
        for j in 0 to TIM_CH_NBR-1 loop  -- timer No. indexing
          tmp(i) := tmp(i) or rdata(j)(i);
        end loop;
      end loop;
      tiu_out_int <= tmp;
    end process;

    -- Mux out rdata, cpt, evt, lcd, onff and ifl registers to host
    process (reg_addr, lcd, cpt, cpe, cps, onff, ifl, tiu_out_int)
    begin
      if reg_addr(3) = '0' then
        tiu_out <= tiu_out_int;
      elsif reg_addr(5) = '1' then
        tiu_out <= ifl;
      elsif reg_addr(4) = '1' then
        tiu_out <= onff;
      else
        tiu_out <= '0' & lcd & cpt & cpe & "000" & cps;
      end if;
    end process;

    -- generating interrupt request from timer unit to host
    process (ifl)
    begin
      tiu_irq <= '0';
      for i in 0 to TIM_CH_NBR-1 loop
        if ifl(i) = '1' then
          tiu_irq <= '1';
        end if;
      end loop;
    end process;

  end block host_if;

-------------------------------------------------------------------------------
  -- Timer blocks
-------------------------------------------------------------------------------
-- These are the timers. Each timer has parameter registers
-- and a 5-bit downcounter, as well as control logic that can produce
-- pulses to ports, request interrupt, and connect to neighbor timers
-- for extended precicion.
  timer_gen : for i in 0 to TIM_CH_NBR-1 generate
    tim_ch : block                      -- tim_ch block  

      signal wai_start    : std_logic;  -- Wait at start
      signal wai_coi      : std_logic;  -- Wait at coincidence
      signal wai_ff       : std_logic;  -- Disable downcount
      signal dwnctr       : std_logic_vector(4 downto 0);  -- Downcounter
      signal tiu_test_2   : std_logic_vector(4 downto 0);  -- Downcounter
      signal ld_dwnctr    : std_logic;  -- Load cond for ctr
      signal msa          : std_logic_vector(4 downto 0);  -- mantissa
      signal reqi         : std_logic;  -- Req irpt when ctr=0
      signal tgl          : std_logic_vector(1 downto 0);  -- toggle function
      signal coi          : std_logic_vector(4 downto 0);  -- toggle coincidence
      signal rep          : std_logic;  -- Repeat when ctr=0
      signal wai          : std_logic_vector(2 downto 0);  -- Wait external trigge
      signal bff          : std_logic;
      signal tgl_set      : std_logic;
      signal tgl_reset    : std_logic;
      signal pulseout_int : std_logic;

    begin
      -- Timer's private parameters. Written from wdata when there is a pulse
      -- on the clk_param line. For timers 2 and up this only happens when
      -- reg_addr is written with 1xxx0ccc, where xxx is don't care and ccc
      -- matches the timer number. For timers 0 and 1 there is also a
      -- pulse when there is a capture event, in which case the capt_pend
      -- signal is high and msa should be loaded from the downctr instead.
      -- No other parameters are loaded in this case.
      process (clk_p, trst_n)
      begin
        if trst_n = '0' then
          exp(i) <= (others => '0');
          msa    <= (others => '0');
          reqi   <= '0';
          tgl    <= (others => '0');
          coi    <= (others => '0');
          rep    <= '0';
          evt(i) <= '0';
          drv(i) <= '0';
          wai    <= (others => '0');
        elsif rising_edge(clk_p) then
          if i < 2 and cpt = '1' and capt_pend = '1' then
            msa <= dwnctr;
          elsif (clk_param(i) = '1') then 
            case reg_addr(5 downto 4) is
              when "00" => exp(i) <= wdata(7 downto 5);
                           msa <= wdata(4 downto 0);
              when "01" => reqi <= wdata(7);
                           tgl <= wdata(6 downto 5);
                         coi <= wdata(4 downto 0);
              when "10" => rep <= wdata(7);
                           evt(i) <= wdata(6);
                           drv(i) <= wdata(5);
                           wai    <= wdata(4 downto 2);
              when others => null;
            end case;
          end if;
        end if;
      end process;

      -- Read access to parameter registers. The timer that is selected by
      -- the low three bits of reg_addr continously outputs the register
      -- selected by bits 4 and 5 of reg_addr on its private output bus,
      -- the other timers output zero. The output buses are then OR'ed
      -- together. 
      process (reg_addr, exp(i), msa, reqi, tgl, rep, wai, drv(i), evt(i), coi)
      begin
        rdata(i) <= (others => '0');
        if i = conv_integer(reg_addr(2 downto 0)) then
          case reg_addr(5 downto 4) is
            when "00"   => rdata(i) <= exp(i) & msa;
            when "01"   => rdata(i) <= reqi & tgl & coi;
            when "10"   => rdata(i) <= rep & evt(i) & drv(i) & wai & "00";
            when others => null;
          end case;
        end if;
      end process;

      -- wai_ff is used for external triggering timer: counter counts only
      -- when wai_ff = 0.  Therefore wai_ff is reset by cpt_trig(i).
      -- Control register field wai controls when wai_ff is set. Only a driving
      -- or single timer's wai field should be used.
      -- The cpt_trig event is edge triggered when wai(0) is set, else level
      -- triggered.

      process (clk_p_n, trst_n, cpt_trig_int(i), onff(i))
      begin
        if trst_n = '0' or (cpt_trig_int(i) = '1' and onff(i) = '1') then
          wai_ff <= '0';
        elsif rising_edge(clk_p_n) then
          if genclk(i) = '1' then
            if wai(1 downto 0) = "00" then
              wai_ff <= '0';
            elsif wai(2) = '0' and begintime(i) = '1' then
              wai_ff <= '1';
            elsif wai(2 downto 1) = "01" and wai_start = '1' then
              wai_ff <= '1';
            elsif wai(2 downto 1) = "11" and wai_coi = '1' then
              wai_ff <= '1';
            end if;
          end if;
        end if;
      end process;
      
      wai_edge(i) <= wai(0);

      wai_start <= '1' when begintime(i) = '1' else
                   '1' when cnt_zero(i) = '1' and ctrldrvg(i)(1) = '0' else
                   '0';
      wai_coi <= '1' when cnt_coi(i) = '1' and ctrldrvg(i)(2) = '0' else
                 '0';

      ------- Counter ----------------------------------
      -- This is the 5-bit downcounter of a timer. 
      process(clk_p_n, onff(i))
      begin
        if onff(i) = '0' then
          dwnctr <= "00000";
        elsif rising_edge(clk_p_n) then
          if genclk(i) = '1' then
            if ld_dwnctr = '1' then
              dwnctr <= msa;
            elsif wai_ff = '0' then
              dwnctr <= dwnctr - 1;
            end if;
          end if;
        end if;
      end process;
      -- When a timer counts to zero, it either reloads itself from msa or
      -- wraps around. A single timer is always reloaded, a driving timer
      -- is reloaded only if its ctrldrvg(1) line is held low by the driven
      -- timer.
      -- A timer is also always reloaded on the first clk_t pulse of its
      -- active time, regardless of the dwnctr state before that. 
      ld_dwnctr <= '0' when i < 2 and cpt = '1' else
                   '1' when begintime(i) = '1' else
                   '1' when cnt_zero(i) = '1' and ctrldrvg(i)(1) = '0' else
                   '0';

      -- These counter states are used for all kinds of control logic
      -- related to count end actions, such as of toggling, interrupt and
      -- reloading etc.
      cnt_zero(i) <= '1' when dwnctr = "00000" and begintime(i) = '0' else '0';
      cnt_coi(i)  <= '1' when dwnctr = coi and begintime(i) = '0'     else '0';

      -- Generate ctrldrvg, chain_zero, and chain_coi.
      not_lowest_ch : if i > 0 generate
        ctrldrvg(i-1)(0) <= drv(i-1) and chain_zero(i) and not rep and exp(i)(0);
--      ctrldrvg(i-1)(0) <= drv(i-1) and chain_zero(i) and (not rep or ctrldrvg(i)(0)) and exp(i)(0);   -- Suggested metal fix #17, never implemented
        ctrldrvg(i-1)(1) <= drv(i-1) and (not cnt_zero(i) or ctrldrvg(i)(1)) and exp(i)(1);
        ctrldrvg(i-1)(2) <= drv(i-1) and not cnt_coi(i) and exp(i)(1);
        chain_coi(i)     <= cnt_coi(i) and (not drv(i-1) or chain_coi(i-1) or exp(i)(2));
        chain_zero(i)    <= cnt_zero(i) and (not drv(i-1) or chain_zero(i-1));
        chain_cken(i)    <= genclk(i) or (drv(i-1) and chain_cken(i-1) and not exp(i)(2));
      end generate not_lowest_ch;

      -- Separate generate for timer 0, since i-1 is invalid. 
      -- Also generates parallel data inteface clock, unique to this timer.
      lowest_ch : if i = 0 generate
        ctrldrvg(TIM_CH_NBR-1)(0) <= '0';
        ctrldrvg(TIM_CH_NBR-1)(1) <= '0';
        ctrldrvg(TIM_CH_NBR-1)(2) <= '0';
        chain_coi(i)              <= cnt_coi(i);
        chain_zero(i)             <= cnt_zero(i);
        chain_cken(i)             <= genclk(i);

        -- Generation of parallel data interface clock. When used for LCD
        -- driver, the data clock rate is the double of pixel clock rate and it
        -- is gated with Venable and Henable(Ch7 and Ch5).
        -- pdi_clk <= (first_clk and toggle_out(5) and toggle_out(7))
        --            when exp(i) = "000" and lcd = '1' else
        --            (ff(conv_integer(exp(i)) - 1) and toggle_out(5) and
        --             toggle_out(7)) when lcd = '1' else
        --            toggle_out(i);

        pdi_clk <= (first_clock and toggle_out(5) and toggle_out(7))
                   when exp(i) = "000" and lcd = '1' else
                   (ff(conv_integer(exp(i)) - 1) and toggle_out(5) and
                    toggle_out(7)) when lcd = '1' else
                   toggle_out(i);
        
      end generate lowest_ch;

      ------- On/off ctrl ------------------------------
      -- The onff flipflop can be written by the processor, and determines
      -- whether a timer is active or not. When not active, no clk_t pulses
      -- are generated for this timer.
      -- When a timer counts to zero, it turns itself off if its rep bit is
      -- set to zero. 
      -- A driving timer with its rep bit set can be forced to turn itself
      -- off anyway by the driven timer, if the latter sets the former's
      -- ctrldrvg(0) line high. 
      process (clk_p_n, trst_n)
      begin
        if trst_n = '0' then
          onff(i) <= '0';
        elsif rising_edge(clk_p_n) then
          if (turn_on(i) = '1') then
            onff(i) <= '1';
          elsif (turn_off_n(i) = '0') then
            onff(i) <= '0';
          else
            if (cnt_zero(i) = '1' and rep = '0') or ctrldrvg(i)(0) = '1' then
              onff(i) <= '0';
            end if;
          end if;
        end if;
      end process;

      -- begintime from the activation of a timer until the first clk_t after
      -- onff goes from 0 -> 1. It is used mainly to make sure the dwnctr
      -- value is ignored on the first clock.
      process (clk_p_n, turn_off_n(i), onff(i))
      begin
        if (turn_off_n(i) = '0' or onff(i) = '0') then
          bff <= '0';
        elsif rising_edge(clk_p_n) then
          if genclk(i) = '1' then
            bff <= onff(i);
          end if;
        end if;
      end process;
      begintime(i) <= onff(i) and not bff;

      ------- Interrupt ctrl ------------------------------
      -- Interrupt request is issued at end time or capture event (timer 0
      -- only) if reqi is enabled. When capture is enabled, timer 0 generates
      -- only capture interrupt, not end time interrupt.
      -- Note: capture interrupt is async set because external event nature.
      process (reset_ifl_n(i), trst_n, reqi, capt_event, clk_p_n)
      begin
        if rising_edge(clk_p_n) then
	  if i = 0 and (reset_ifl_n(i) = '0' or trst_n = '0') then
	    ifl(i) <= '0';
	  else
	    if genclk(i) = '1' then
	      if i = 0 and reqi = '1' and cnt_zero(i) = '1' and cpt = '0' then
		ifl(i) <= '1';  -- Timer 0 does not generate wrap interrupt in capture mode
	      elsif i = 1 and reqi = '1' and (cnt_zero(i) = '1' or (cnt_half = '1' and cpt = '1')) then
		ifl(i) <= '1';  -- Timer 1 generates wrap interrupt twice per lap in capture mode
	      elsif i > 1 and reqi = '1' and cnt_zero(i) = '1' then
		ifl(i) <= '1';  -- Timers 2-7 generate wrap interrupt once per lap
	      end if;
	    end if;
          end if;
        end if;

	if i = 0 and capt_event = '1' and reqi = '1' then
	  ifl(i) <= '1';      -- Timer 0 generates interrupt on capture
	elsif i > 0 and  (reset_ifl_n(i) = '0' or trst_n = '0') then
	  ifl(i) <= '0';  -- Timer 0 does not generate wrap interrupt in capture mode
	end if;
	
      end process;

      ch_1 : if i = 1 generate
        cnt_half <= '1' when dwnctr = "10000" and begintime(i) = '0' else '0';
      end generate ch_1;

      ------- Toggle ctrl ------------------------------
      -- tgl = 00 -> no toggle;
      -- tgl = 01 -> toggle at start and end;
      -- tgl = 10 -> toggle at enter and leaving coi(chained or not chained); 
      -- tgl = 11 -> toggle at coi(chained or not chained) and end
      process (tgl, chain_coi(i), chain_zero(i), begintime(i))
      begin
        case tgl is
          when "00" =>   tgl_set <= '0';
                         tgl_reset <= '0';
          when "01" =>   tgl_set <= begintime(i);
                         tgl_reset <= chain_zero(i);
          when "10" =>   tgl_set <= chain_coi(i);
                         tgl_reset <= not chain_coi(i);
          when others => tgl_set <= chain_coi(i);
                         tgl_reset <= chain_zero(i);
        end case;
      end process;
                 
      process (clk_p_n, onff(i))
      begin
        if onff(i) = '0' then
          pulseout_int <= '0';
        elsif rising_edge(clk_p_n) then
          if first_clock = '1' then
            if chain_cken(i) = '1' then
              if tgl_reset = '1' then
                pulseout_int <= '0';
              elsif tgl_set = '1' then
                pulseout_int <= '1';
              end if;
            end if;
          end if;
        end if;
      end process;

      
      toggle_out(i) <= ff(conv_integer(exp(i))) when tgl = "00" and lcd = '1' else
                       pulseout_int;

    end block tim_ch;
  end generate timer_gen;

  -- Output toggles. When used as LCD driver, the Venable and Henable is gated.
  pulseout(6 downto 0) <= toggle_out(6 downto 0);
  pulseout(7)          <= (toggle_out(7) and toggle_out(5)) when lcd = '1' else
                 toggle_out(7);

  ----------------------------------------------------------------------------
  -- Prescaler block
  ----------------------------------------------------------------------------
  prescaler : block

  begin

    -- Frequency divider
    process (clk_p_n, trst_n)
    begin
      if (trst_n = '0') then
        ff <= (others => '0');
      elsif rising_edge(clk_p_n) then
        if first_clock = '1' then
          if run = '1' then
            ff <= ff + 1;
          else
            ff(0) <= '0';
          end if;
        end if;
      end if;
    end process;

    process(ff)
      variable tmp : std_logic_vector(7 downto 0);
    begin
      tmp(0) := ff(0);
      for i in 1 to 7 loop
        tmp(i) := tmp(i-1) and ff(i);
      end loop;
      frd <= tmp;
    end process;

    -- This process select genclk for each timer.
    process (frd, onff, drv, exp, begintime, cnt_zero, evt, trig_edge)
      variable tmp : std_logic_vector(TIM_CH_NBR-1 downto 0);
    begin
      for i in 0 to TIM_CH_NBR-1 loop
        -- Default frequency selection, controlled by exp
        tmp(i) := frd(conv_integer(exp(i)));

        -- Timer may be used for external event counting, clocked by rising
        -- edge on its cpt_trig input. 
        if evt(i) = '1' then
          tmp(i) := begintime(i) or trig_edge(i);
        end if;

        -- Lapcount instead, if driven by preceding timer (not for timer 0).
        -- Clock when driving timer wraps, or at first clock.
        if i > 0 and drv(i-1) = '1' then
          tmp(i) := (begintime(i-1) or cnt_zero(i-1)) and tmp(i-1);
        end if;

        -- If timer not on, then no clock.
        if onff(i) = '0' then
          tmp(i) := '0';
        end if;
      end loop;
      genclk <= tmp;
    end process;

  end block prescaler;

  -----------------------------------------------------------------------------
  -- Timer clocks generation
  -----------------------------------------------------------------------------
  tic : block

  begin
    -- Synchronized enable signal, for entire timer system. Stops and resets
    -- clocks and counters. Used for all initial reset within timer system.
    process (clk_p)
    begin
      if rising_edge(clk_p) then        --rising_edge(clk_c) 
        if (rst_en = '0') then
          trst_n <= '0';
        elsif clk_c_en = '1' then
          trst_n <= tiu_enable;
        end if;
      end if;
    end process;

    -- This is the clock that drives the frequency divider common to all
    -- timers. It is also used to generate the clocks used for host
    -- interface and parameter registers.
    first_clock <= clk_c_en and trst_n;
    first_clk   <= (not clk_p) and clk_c_en and trst_n;  -- 133 MHz clk (if enabled)

    -- This process creates a clkpulse for writing in parameter registers.
    -- It is distributed to the params block in every timer, but writing
    -- will be performed only in the timer selected by wr(i).

    process (clk_p_n)
    begin
      if rising_edge(clk_p_n) then
        if first_clock = '1' then
          if (trst_n = '0' or rst_en = '0') then
            clk_wr <= '0';
          else
            clk_wr <= reg_wr;
          end if;
        end if;
      end if;
    end process;

    
    -- Distribute (buffer) clk_wr to each timer, one pulse only when
    -- writing a parameter. Also a pulse for timers 0 and 1 on capture
    -- event, to load downctr into msa.
    process (clk_wr, reg_addr, capt_event)
    begin
      clk_param    <= (others => '0');
      for i in 0 to TIM_CH_NBR-1 loop
        if reg_addr(3) = '0' and (i = conv_integer(reg_addr(2 downto 0))) and clk_wr = '1' then
          clk_param(i) <= '1';
        end if;
      end loop;
    end process;

    -- This process generates the individual clock for each timer.  
    process (clk_p_n, trst_n)
    begin
      if (trst_n = '0') then
        clk_t <= (others => '0');
      elsif rising_edge(clk_p_n) then
        if first_clock = '1' then
          for i in 0 to TIM_CH_NBR-1 loop
            clk_t(i) <= genclk(i);
          end loop;
        end if;
      end if;
    end process;
 
  end block tic;

  ----------------------------------------------------------------------------
  -- Capture block
  ----------------------------------------------------------------------------
  capture : block
    signal sync_0        : std_logic_vector(TIM_CH_NBR-1 downto 0);
    signal sync_1        : std_logic_vector(TIM_CH_NBR-1 downto 0);
    signal sync_0_rx1    : std_logic;
    signal sync_1_rx1    : std_logic;
    signal trig_edge_rx1 : std_logic;
    signal cpt_prev      : std_logic;

  begin
    -- These flipflops detect positive edge of 'capture' inputs from ports,
    -- where they can be polarity controlled.
    process (clk_p_n, trst_n)
    begin
      if trst_n = '0' then
        sync_0 <= (others => '0');
        sync_1 <= (others => '0');
      elsif rising_edge(clk_p_n) then
        if first_clock = '1' then
          for i in 0 to TIM_CH_NBR-1 loop
            sync_0(i) <= cpt_trig(i) and not sync_1(i);
            sync_1(i) <= (cpt_trig(i) and sync_1(i)) or sync_0(i);
          end loop;
        end if;
      end if;
    end process;

    -- Clock these flipflops on falling edge instead, to avoid race
    -- In the capture mode, there is a mechanism to prevent additional capture
    -- as long as the interrupt flag is set.
    process (clk_p, trst_n)
    begin
      if trst_n = '0' then
        trig_edge <= (others => '0');
      elsif rising_edge(clk_p) then
        if first_clock = '1' then
          for i in 0 to TIM_CH_NBR-1 loop
            if i = 0 then
              trig_edge(i) <= sync_0(i) and not sync_1(i) and not (cpt and ifl(i));
            else
              trig_edge(i) <= sync_0(i) and not sync_1(i);
            end if;
          end loop;
        end if;
      end if;
    end process;

    -- External triggers used for delayed start of counters.
    -- External trigger is active at positive edge if wai_edge is set,
    -- otherwise at high level.
    process (trig_edge, sync_1, wai_edge)
    begin
      for i in 0 to TIM_CH_NBR-1 loop
        if wai_edge(i) = '1' then
          cpt_trig_int(i) <= trig_edge(i);
        else
          cpt_trig_int(i) <= sync_1(i);
        end if;
      end loop;
    end process;

    -- These flipflops detect positive edge of timestamp input from Ethernet
    -- In the capture mode, there is a mechanism to prevent additional capture
    -- as long as the interrupt flag is set.
    -- If cpe is false, Ethernet timestamping is disabled
    process (clk_p_n)
    begin
      if rising_edge(clk_p_n) then
        if first_clock = '1' then
          sync_0_rx1 <= cpe and tstamp_rx1 and not sync_1_rx1;
          sync_1_rx1 <= ((cpe and tstamp_rx1) and sync_1_rx1) or sync_0_rx1;
        end if;
      end if;
    end process;

    -- Clock these flipflops on falling edge instead, to avoid race
    process (clk_p_n)
    begin
      if rising_edge(clk_p_n) then
        if first_clock = '1' then
          trig_edge_rx1 <= sync_0_rx1 and not sync_1_rx1 and not (cpt and ifl(0));
        end if;
      end if;
    end process;

    -- capt_event is the second event (the end of a signal pulse or a signal
    -- with delay phase), which is used to copy a counter value and generate
    -- interrupt. This event is generated only when cpt is set.    
    process (clk_p, trst_n)
    begin
      if (trst_n = '0') then
        capt_event <= '0';
      elsif rising_edge(clk_p) then
        capt_event <= capt_pend and cpt;
      end if;
    end process;

    -- capt_pend is used to tell the msa input mux to load msa from the
    -- downctr rather than from wdata on the capt_event pulse.
    --capt_pend <= (sync_0(0) or sync_0_rx1) and cpt;

    process (clk_p, trst_n)
    begin
      if (trst_n = '0') then
        cpt_prev  <= '0';
        capt_pend <= '0';
      elsif rising_edge(clk_p) then
        cpt_prev  <= cpt_trig(0);
        capt_pend <= '0';
        if (cpt_prev = '1' and cpt_trig(0) = '0') then
          capt_pend <= '1';
        end if;
      end if;
    end process;


    -- This flipflop stores the source of capture. '0' means cpt_trig,
    -- '1' means Ethernet timestamp.
    process (capt_event)
    begin
      if rising_edge(capt_event) then
        cps <= sync_0_rx1;
      end if;
    end process;

  end block capture;

end;
