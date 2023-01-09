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
-- Title      : microprogram trace
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : trace.vhd
-- Author     : Camilla Bihrling
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: microprogram trace
--   The mem_addr_sz generic specifies the size of the trace memory
--   address vector, a 32kB trace memory means mem_addr_sz should
--   be set to 15.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.0 			CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pe1_debug_trace is
  generic (
    mem_addr_sz    : positive;
    set_trace_cmd  : std_logic_vector(3 downto 0);
    go_trace_cmd   : std_logic_vector(3 downto 0);
    read_trace_cmd : std_logic_vector(3 downto 0));
  port (
    clk_p   : in  std_logic;
    clk_e_pos  : in std_logic;
    rst_cn   : in  std_logic;
    -- Control signals
    go      : out std_logic;    -- Waiting-for-trig status output (active high)
    wdata   : in  std_logic_vector(7 downto 0); -- Data in from plll port
    wr      : in std_logic;     -- Write signal from parallel port(active high)
    cmdstrt : in std_logic;     -- Start of parallel port command
    cmdend  : in std_logic;     -- End of parallel port command
    rdata   : out std_logic_vector(7 downto 0); -- Data out to plll port
    rd      : in std_logic;     -- Read signal from parallel port (active high)
    rsel    : out std_logic;    -- rdata output select
    -- Trace port interface
    mpg_a   : in  std_logic_vector(7 downto 0); -- Trace data (uaddress)
    d       : in  std_logic_vector(7 downto 0);  -- Trace data (D-bus)
    y       : in  std_logic_vector(7 downto 0);  -- Trace data (Y-bus)
    -- Trace memory interface
    i       : in  std_logic_vector(31 downto 0); -- Data in from trace memory
    o       : out std_logic_vector(31 downto 0); -- Data out to trace memory
    a       : out std_logic_vector(mem_addr_sz-1 downto 0); --Trace memory address
    adsc_n  : out std_logic;    -- Trace memory chip select (active low)
    gw_n    : out std_logic;    -- Trace memory write enable (active low)
    oe_n    : out std_logic);   -- Trace memory output enable (active low)

end;

architecture rtl of pe1_debug_trace is
  -- Control signals
  signal reset      : std_logic;        -- Reset pulse caused by reset command
  signal i_byte_sel : std_logic_vector(1 downto 0);-- Trace memory byte select
  signal trig_pt    : std_logic_vector(1 downto 0); -- Trigpoint placer
  signal we_trig    : std_logic;
  signal go_sel : std_logic;
  signal set_sel : std_logic;  -- Enable loading into trigger/mask
                                        -- register
  signal read_sel  : std_logic;
  signal set_wen  : std_logic;   -- Load a byte into trigger/mask register
  signal go_wen  : std_logic;

  -- Compare signals
  signal data  : std_logic_vector(31 downto 0); -- Trace data bus
--  signal o_int : std_logic_vector(31 downto 0);  -- Internal outdata
  signal trig  : std_logic_vector(31 downto 0);  -- Trigger word register
  signal mask  : std_logic_vector(31 downto 0);  -- Mask word register
  signal match : std_logic; -- Match signal, high when data satisfies trig/mask
  signal cmp   : std_logic_vector(31 downto 0);  -- Compare vector

  -- Memctrl signals
  signal aq      : std_logic_vector(mem_addr_sz-1 downto 0); -- Trace memory address
  signal step    : std_logic;   -- Request from control logic to step address
  signal stepped : std_logic;   -- Clears step
  signal gone    : std_logic;   -- Clears go

  -- Idiot signals, due to VHDL idiocy
  signal adsc_int: std_logic;
  signal go_int  : std_logic;
  signal go_n    : std_logic;

begin
-------------------------------------------------------------------------------
-- C O N T R O L
-------------------------------------------------------------------------------
  -- Demultiplexor for parallel port commands. Each output is high when the
  -- corresponding command arrives.
  -- Set command (0x81) will cause the following eight bytes
  -- to be clocked into the trigger and mask register with the trig_load
  -- signal.
  -- Go command (0x12) will cause the following byte
  -- to be clocked into trig_pt with the trig_pt_load signal.
  -- Read command (0x03) will start reading data from the trace memory by
  -- setting the oe signal. Reading will terminate on the next byte written
  -- by the parallel port.
	cmd_decode: process (clk_p)
	begin
	if rising_edge(clk_p) then
		if rst_cn = '0' then
			set_sel <= '0';
			go_sel <= '0';
      read_sel <= '0';
    else
			if wr = '1' then
	      read_sel <= '0';
				if cmdstrt = '1' then
					if wdata(3 downto 0) = set_trace_cmd then
						set_sel <= '1';
					end if;
					if wdata(3 downto 0) = go_trace_cmd then
						go_sel <= '1';
					end if;
					if wdata(3 downto 0) = read_trace_cmd then
		        read_sel <= '1';
					end if;
				elsif cmdend = '1' then
					set_sel <= '0';
					go_sel <= '0';
				end if;
			end if;
		end if;
  end if;
	end process cmd_decode;
  set_wen <= set_sel and wr;
  go_wen <= go_sel and wr;
  oe_n <= not read_sel;

  -- Sets the trigpointplacer.
  -- Go command (0x02) will set the go signal, which will enable writing
  -- trace data to the trace memory and waiting for trig.
  -- The gone signal will reset go after the trigger has occurred, reset
  -- will also stop tracing.
  trigpoint_go : process(clk_p)
  begin
  if rising_edge(clk_p) then
    if gone = '1' or reset = '1' then
      go_int <= '0';
    else
      if go_wen = '1' then
        go_int <= wdata(0);
      end if;
    end if;
  end if;
  end process;
  go <= go_int;

  process(clk_p)
  begin
    if rising_edge(clk_p) then
      if go_wen = '1' then
        trig_pt <= wdata(7 downto 6);
      end if;
    end if;
  end process;

  reset <= not wdata(0) when go_wen = '1' else
           not rst_cn;

  -- When reading from the trace memory (oe_n low), this counter will select
  -- the appropriate byte from the 32-bit trace memory bus.
  process(clk_p)
  begin
  if rising_edge(clk_p) then
    if read_sel = '0' then
      i_byte_sel <= "00";
    else
      if rd = '1' then
        i_byte_sel <= i_byte_sel + 1;
      end if;
    end if;
  end if;
  end process;

  -- The step signal will step the trace memory address after a whole word has
  -- been read. The stepped signal (synchronized to clk_e) will clear step when
  -- the address has been stepped.
  step_flipflop : process(clk_p)
  begin
  if rising_edge(clk_p) then
    if ((rst_cn = '0') or (stepped = '1')) then
      step <= '0';
    else
      if rd = '1' and i_byte_sel = "11" then
        step <= '1';
      end if;
    end if;
  end if;
  end process;

  -- rdata selector, will select the right byte from the trace memory data
  -- based on the i_byte_sel counter.

  rdata <= i(7 downto 0)   when i_byte_sel = "00" else
           i(15 downto 8)  when i_byte_sel = "01" else
           i(23 downto 16) when i_byte_sel = "10" else
           i(31 downto 24);

  -- rsel is high when reading from the trace memory, will tell the above when
  -- rdata is valid.
  rsel <= read_sel;

-------------------------------------------------------------------------------
-- T R A C E
-------------------------------------------------------------------------------

  -- Data is the 32-bit bus to compare block for comparision with trig or
  -- mask word. O is the 32-bit bus out to trace memory. They both consist of
  -- dbus and ybus and the current microprogram address except on the first
  -- writing while trig_pt is in "only trigword write" mode when there is an
  -- '1' in bit 16 to show where the writing begins.

  o <= x"00008000" when we_trig = '1' and trig_pt = "11" else
       d & y & "00000000" & mpg_a; -- dbus, ybus and the 8 bit uaddress --CJ

  data <= d & y & "00000000" & mpg_a;

  -- Instance of memctrl. Produces control signals gw and adsc to the trace
  -- memory, as well as reset signals gone and stepped to the control logic.
  -- Also contains the trigger delay counter, which will delay for one half
  -- of the trace memory before stopping the trace after trig.
  memctrl : block

    signal delay_cnt   : std_logic_vector(mem_addr_sz downto 0);
    signal trig        : std_logic;
    signal step_sync   : std_logic;
    signal step_edge1  : std_logic;
    signal step_edge2  : std_logic;
    signal go_sync     : std_logic;

    signal stepped_int : std_logic;
    signal gw_int      : std_logic;
    signal adsc_tmp    : std_logic;

    signal rst_int     : std_logic;
    signal trig_en     : std_logic;
    signal match_dly   : std_logic;
    signal we_trig_int : std_logic;
    signal be_gone     : std_logic;

  begin

    -- step_sync is just the step signal synchronized to the clk_e domain.
    -- step_edge1 and step_edge2 are used to detect the positive edges of step.
    process(clk_p)
    begin
      if rising_edge(clk_p) then
				if clk_e_pos = '0' then
        	step_sync <= step;
        	step_edge1 <= step_sync;
        	step_edge2 <= step_edge1;
	      end if;
      end if;
    end process;

    -- stepped will be high for one clk_e cycle following the positive edges
    -- of the step signal.
    stepped_int <= step_edge1 and not step_edge2;
    stepped <= stepped_int;

    -- go_sync is just the go signal synchronized to the clk_e domain.
    -- gw is the write enable to the trace memory, it will
    -- be active (low) while go_sync is high.
    process(clk_p)
    begin
    if rising_edge(clk_p) then
      if reset = '1' then
        go_sync <= '0';
        gw_int <= '1';
      elsif clk_e_pos = '0' then
        if go_int = '1' then
          go_sync <= '1';
        elsif gone = '1' then
          go_sync <= '0';
        end if;
        gw_int <= not go_sync;
      end if;
    end if;
    end process;

    -- we_trig is a pulse at go's rising edge.
    -- When trig_pt is "11" an '1' will be written in the
    -- place of the mpga_address(13) to the trace memory.
    -- This is to show where the writing starts.
    we_trig_int <= go_sync and gw_int;
    we_trig <= we_trig_int;

    -- trig will be set by the match signal and will remain set
    -- until gw is deactivated by the gone signal.
    process(clk_p)
    begin
    if rising_edge(clk_p) then
      if rst_int = '1' then
        trig <= '0';
      elsif clk_e_pos = '0' then
        if match = '1' then
          trig <= '1';
        end if;
      end if;
    end if;
    end process;

    -- Match signal delayed one clk_e for the
    -- delay counter to count when trig_pt = "11"
    process(clk_p)
    begin
    if rising_edge(clk_p) then
			if clk_e_pos = '0' then
        if match = '1' then
          match_dly <= '1';
        else
          match_dly <= '0';
        end if;
	    end if;
    end if;
    end process;

    rst_int <= not(go_int) when trig_pt = "11" else
               gw_int;

    trig_en <= ((trig and match_dly) or we_trig_int) when trig_pt = "11" else
               (trig or match);

    -- Trigger delay counter. Used to save a number of trace samples
    -- after the trigger has occurred.
    process(clk_p)
    begin
    if rising_edge(clk_p) then
      if rst_int = '1' then
        delay_cnt <= (others => '0');
      elsif clk_e_pos = '0' then
        if trig_en = '1' then
          delay_cnt <= delay_cnt + 1;
        end if;
      end if;
    end if;
    end process;

    be_gone <= delay_cnt(7) and delay_cnt(6) and delay_cnt(5) and delay_cnt(4)
               and delay_cnt(3) and delay_cnt(2) and (not(delay_cnt(1))) and
               delay_cnt(0);

    -- The gone signal goes active when the delay counter has expired. It will
    -- reset the go signal and stop writing to the trace memory.

    gone <= delay_cnt(mem_addr_sz) when trig_pt = "11" else
            be_gone when trig_pt = "01" else
            delay_cnt(0) when trig_pt = "10" else
            delay_cnt(mem_addr_sz-1);

    gw_n <= not((go_sync and match) or we_trig_int) when trig_pt = "11" else
            gw_int;

    -- adsc is the chip select input to the trace memory, it will be active
    -- (low) on the stepped pulse (when reading) or when gw_n is active (when
    -- writing).
    adsc_tmp <= stepped_int or not gw_int;
    adsc_int <= not((adsc_tmp and match) or we_trig_int ) when trig_pt = "11"
                else not(adsc_tmp);
  end block;

  adsc_n <= adsc_int;

  -- Address counter. Counts after each memory operation, recognized
  -- by active (low) adsc.
  process(clk_p)
  begin
  if rising_edge(clk_p) then
    if rst_cn = '0' then
      aq <= (others => '0');
    elsif clk_e_pos = '0' then
      if adsc_int = '0' then
        aq <= aq + 1;
      end if;
    end if;
  end if;
  end process;

  a <= aq;

  go_n <= not go_int;

  -- Compare block. Provides the match signal which signals when
  -- trace data matches trig and mask words.
  compare : block
  begin

    -- For each data bit, set the corresponding cmp bit
    -- if data matches trig or mask is set
    process(trig, data, mask)
    begin
      for i in 0 to 31 loop
        if (trig(i) = data(i) or mask(i) = '1') then
          cmp(i) <= '1';
        else
          cmp(i) <= '0';
        end if;
      end loop;
    end process;

    -- Set match if all cmp bits are set
    process(clk_p)
    begin
    if rising_edge(clk_p) then
      if go_n = '1' then
        match <= '0';
      elsif clk_e_pos = '0' then
        if cmp = "11111111111111111111111111111111" then
          match <= '1';
        else
          match <= '0';
        end if;
      end if;
    end if;
    end process;

  end block;

  -- Trigger and mask word register, load from parallel
  -- port data when set_wen is set
  mask_trig_flipflops : process(clk_p)
  begin
    if  rising_edge(clk_p) then
      if set_wen = '1' then
        trig(31 downto 24) <= wdata;
        trig(23 downto 16) <= trig(31 downto 24);
        trig(15 downto 8)  <= trig(23 downto 16);
        trig(7 downto 0)   <= trig(15 downto 8);
        mask(31 downto 24) <= trig(7 downto 0);
        mask(23 downto 16) <= mask(31 downto 24);
        mask(15 downto 8)  <= mask(23 downto 16);
        mask(7 downto 0)   <= mask(15 downto 8);
      end if;
    end if;
  end process;

end;

















