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
-- Title      : I/O subsystem
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pe1_ios_dackgen.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: DMA acknowledge prioritization and generation.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.3 			CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.pe1_gp_pkg.all;

entity pe1_ios_dackgen is
  port (
    clk_p       : in    std_logic;
    clk_i_pos   : in    std_logic;
    rst_en      : in    std_logic;
    idreq       : in    std_logic_vector(DMA_CHANNELS-1 downto 0);
    active      : in    std_logic_vector(DMA_CHANNELS-1 downto 0);
    dir         : in    std_logic_vector(DMA_CHANNELS-1 downto 0);
    dmap_stop   : in    std_logic_vector(DMA_CHANNELS-1 downto 0);
    priority    : in    std_logic_vector(DMA_CHANNELS-1 downto 0);
    pend_pio    : in    std_logic;      -- High when programmable I/O pending
    pend_dma    : out   std_logic;      -- High when DMA I/O pending
    input_dma   : out   std_logic;      -- High when input DMA I/O in progress
    block_out   : in    std_logic;      -- Block output I/O operations in the next cycle
    blocked_pio : in    std_logic;      -- High when a programmed operation was blocked
    dmap_cnt    : out   std_logic_vector(DMA_CHANNELS-1 downto 0);
    idack       : out   std_logic_vector(DMA_CHANNELS-1 downto 0));

end pe1_ios_dackgen;

architecture rtl of pe1_ios_dackgen is
  signal p_ack_any   : std_logic;
  signal p_ack_code  : std_logic_vector(DMA_CHBITS-1 downto 0);
  signal p_ack_dir   : std_logic;
  signal h_ack_any   : std_logic;
  signal h_ack_code  : std_logic_vector(DMA_CHBITS-1 downto 0);
  signal ack_any     : std_logic;
  signal ack_code    : std_logic_vector(DMA_CHBITS-1 downto 0);
  signal ack_dir     : std_logic;
  signal p_ack       : std_logic_vector(DMA_CHANNELS-1 downto 0);
  signal ack         : std_logic_vector(DMA_CHANNELS-1 downto 0);
  signal dmap_cnt_int:  std_logic_vector(DMA_CHANNELS-1 downto 0);
  attribute syn_keep : boolean;
  attribute syn_keep of dmap_cnt_int : signal is true;
begin  -- rtl
  -- This process generates p_ack_any, p_ack_dir and p_ack_code.
  -- p_ack_any is high when there is an ack pending.
  -- p_ack_dir shows the direction of the pending ack, high if output.
  -- p_ack_code is the channel number of the pending ack.
  -- Which ack is pending is determined by selecting, among the
  -- requesting channels that are active and not stopped, the one with
  -- the highest priority.
  -- Channels are prioritized after channel number, lower number has
  -- higher prirority. There is also a priority bit, channels with this
  -- bit set have lower priority than all channels with the bit cleared.
  -- Also, if the processor reuests programmed I/O, no low-priority
  -- (priority bit set) channels will be acknowledged.
  -- Finally, if the pending ack is of output direction and output operations
  -- are blocked, the pending ack is cancelled to avoid a bus clash. If
  -- this was the case in the previous cycle, that cancelled pending ack
  -- is forced to be pending in this cycle if it is still valid, regardless
  -- of possibly changed priority conditions.
  p_ack_any_gen: process (idreq, active, dmap_stop, dir, priority, pend_pio,
                          h_ack_any, h_ack_code, block_out, blocked_pio)
    variable valid_req     : std_logic_vector(DMA_CHANNELS-1 downto 0);
    variable p_ack_any_int : std_logic;
    variable p_ack_dir_int : std_logic;
  begin
    -- Default.
    p_ack_any_int := '0';
    p_ack_code  <= (others => '0');
    p_ack_dir_int := '0';

    -- Only requests on active channels that have not reached stop are valid.
    for i in 0 to DMA_CHANNELS-1 loop
      valid_req(i) := not idreq(i) and active(i) and not dmap_stop(i);
    end loop;

    -- High priority channels.
    hi_priority: for i in 0 to DMA_CHANNELS-1 loop
      if valid_req(i) = '1' and priority(i) = '0' then
        p_ack_any_int := '1';
        p_ack_code <= conv_std_logic_vector(i, DMA_CHBITS);
        p_ack_dir_int := dir(i);
        exit hi_priority;
      end if;
    end loop;

    -- Low priority channels.
    if pend_pio = '0' and p_ack_any_int = '0' then
      lo_priority: for i in 0 to DMA_CHANNELS-1 loop
        if valid_req(i) = '1' then
          p_ack_any_int := '1';
          p_ack_code <= conv_std_logic_vector(i, DMA_CHBITS);
          p_ack_dir_int := dir(i);
          exit lo_priority;
        end if;
      end loop;
    end if;

    -- Set pend_dma if any ack is pending, even if that ack is held
    -- to prevent bus clash below.
    pend_dma <= p_ack_any_int;

    -- Hold bus clashing ack, or force previously held ack
    if h_ack_any = '1' and valid_req(conv_integer(h_ack_code)) = '1' then
      -- Here when previously held ack is still valid, force that ack.
      p_ack_any_int := '1';
      pend_dma <= '1';
      p_ack_code <= h_ack_code;
      p_ack_dir_int := '1';
    elsif blocked_pio = '1' then
      -- Here when programmed operation was held, disable ack to let it pass.
      p_ack_any_int := '0';
      pend_dma <= '0';
    elsif p_ack_dir_int = '1' and block_out = '1' then
      -- Here when currently prioritized will cause bus clash, hold it.
      p_ack_any_int := '0';
    end if;

    p_ack_any <= p_ack_any_int;
    p_ack_dir <= p_ack_dir_int;
  end process p_ack_any_gen;

  -- This process records any cancelled (held) pending acks for
  -- the next cycle by setting h_ack_any and storing p_ack_code
  -- in h_ack_code. Note that h_ack_any will never be set if no
  -- ack is pending, because then p_ack_dir will be low.
  h_ack_any_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if rst_en = '0' then
            h_ack_any  <= '0';
            h_ack_code <= (others => '0');
        elsif clk_i_pos = '0' then
            h_ack_any  <= '0';
            if p_ack_dir = '1' and block_out = '1' then
              h_ack_any  <= '1';
              h_ack_code <= p_ack_code;
            end if;
        end if;
    end if;
  end process h_ack_any_gen;

  -- These registers will transfer a pending ack in the previous
  -- cycle into an ack in this cycle by copying p_ack_any, p_ack_code
  -- and p_ack_dir into ack_any, ack_code and ack_dir. ack_dir is
  -- set high if there was no pending ack, to allow the clash detection
  -- logic in the p_ack_any_gen process to look for low ack_dir only
  -- and not need to check ack_any.
  ack_any_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if rst_en = '0' then
            ack_any   <= '0';
            ack_code  <= (others => '0');
            ack_dir   <= '1';
        elsif clk_i_pos = '0' then
            ack_any   <= '0';
            ack_dir   <= '1';
            if p_ack_any = '1' then
              ack_any  <= '1';
              ack_code <= p_ack_code;
              ack_dir  <= p_ack_dir;
            end if;
        end if;
    end if;
  end process ack_any_gen;
  input_dma <= not ack_dir;

  -- Decode p_ack_any and p_ack code into one active high p_ack line
  -- for each channel. These are used to advance the DMA pointer on
  -- output accesses.
  p_ack_gen: process (p_ack_any, p_ack_code)
  begin
    p_ack <= (others => '0');
    if p_ack_any = '1' then
      p_ack(conv_integer(p_ack_code)) <= '1';
    end if;
  end process p_ack_gen;

  -- Decode ack_any and ack code into one active high ack line
  -- for each channel. These are used to advance the DMA pointer on
  -- input accesses. They are also fed to pins as the IDACK lines.
  -- Gating ack with dmap_stop is necessary for input channels.
  ack_gen: process (ack_any, ack_code)
  begin
    ack <= (others => '0');
    if ack_any = '1' then
      ack(conv_integer(ack_code)) <= '1';
    end if;
  end process ack_gen;
  idack <= not (ack and not (dmap_stop and not dir));

  -- Select p_ack for output channels and ack for input channels
  -- to advance the DMA pointers.
  dmap_cnt_gen: process (dir, p_ack, ack, dmap_stop)
  begin
    for i in 0 to DMA_CHANNELS-1 loop
      if dir(i) = '1' then
        dmap_cnt_int(i) <= p_ack(i);
      else
        dmap_cnt_int(i) <= ack(i) and not dmap_stop(i);
      end if;
    end loop;
  end process dmap_cnt_gen;
  dmap_cnt <= dmap_cnt_int;

end rtl;
