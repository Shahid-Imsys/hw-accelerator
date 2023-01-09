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
-- File       : pe1_ios_dmap.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: Pointers and related logic for one DMA channel.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.1 			CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.pe1_gp_pkg.all;

entity pe1_ios_dmap is
  port (
    -- Clock signals
    clk_p       : in std_logic;
    clk_c2_pos    : in  std_logic;
--    even_c    : in  std_logic;
    clk_e_pos     : in  std_logic;
    rst_en       : in std_logic;
    -- Channel settings
    active    : in  std_logic;
    dir       : in  std_logic;
    suse      : in  std_logic;
    bsr       : in  std_logic_vector(IOMEM_ADDR_WIDTH-5 downto 0);
    ber       : in  std_logic_vector(IOMEM_ADDR_WIDTH-5 downto 0);
    -- Control inputs
    pend_i    : in  std_logic;  -- High when clk_i rising edge pending
    dmap_cnt  : in  std_logic;
    piop_cnt  : in  std_logic;
    i_double  : in  std_logic;
    -- Control outputs
    dmap_stop : out std_logic;
    -- Pointer outputs
    dmap      : out std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);
    piop      : out std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0));

end pe1_ios_dmap;

architecture rtl of pe1_ios_dmap is
  signal dmap_plus  : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);
  signal dmap_end   : std_logic;
  signal dmap_ld    : std_logic;
  signal dmap_next  : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);
  signal piop_plus  : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);
  signal piop_end   : std_logic;
  signal piop_ld    : std_logic;
  signal piop_next  : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);
  signal last_ff    : std_logic;
  signal dmap_int   : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);
  signal piop_int   : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);

begin
  -- Calculate next DMA pointer. Wrap from ber to bsr, hold at
  -- bsr when not active, increment when dmap_cnt high.
  dmap_plus <= dmap_int + 1 when dmap_cnt = '1' else dmap_int;
  dmap_end  <= '1' when dmap_plus = ber & "0000" else '0';
  dmap_ld   <= '1' when active = '0' or dmap_end = '1' else '0';
  dmap_next <= bsr & "0000" when dmap_ld = '1' else dmap_plus;

  -- Update DMA pointer.
  dmap_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then --rising_edge(clk_i)
        if rst_en = '0' then
            dmap_int <= (others => '0');
        else
            dmap_int <= dmap_next;
        end if;
    end if;
  end process dmap_gen;
  dmap <= dmap_int;

  -- Calculate next PIO pointer. Wrap from ber to bsr, hold at
  -- bsr when not active, increment when piop_cnt high, by 2 if
  -- i_double also high.
  piop_plus <= piop_int + 2 when piop_cnt = '1' and i_double = '1' else
               piop_int + 1 when piop_cnt = '1' and i_double = '0' else
               piop_int;
  piop_end  <= '1' when piop_plus = ber & "0000" else '0';
  piop_ld   <= '1' when active = '0' or piop_end = '1' else '0';
  piop_next <= bsr & "0000" when piop_ld = '1' else piop_plus;

  -- Update PIO pointer.
  piop_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then --rising_edge(clk_e)
        if rst_en = '0' then
            piop_int <= (others => '0');
        elsif clk_e_pos = '0' then
            piop_int <= piop_next;
        end if;
    end if;
  end process piop_gen;
  piop <= piop_int;

  -- Keep track of what happened most recently, DMA access without
  -- PIOP access or PIOP access without DMA access. The sense of the
  -- flag depends on the channel direction, this is to get the start
  -- value right for dmap_stop (high if output, low if input).
  last_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_c2)
        if rst_en = '0' then
            last_ff <= '0';
        elsif clk_c2_pos = '0' then
--          if even_c = '0' then
            if active = '0' then
              last_ff <= '0';
            elsif (dmap_cnt = '1' and pend_i = '1') and piop_cnt = '0' then
              last_ff <= not dir;
            elsif not (dmap_cnt = '1' and pend_i = '1') and piop_cnt = '1' then
              last_ff <= dir;
            end if;
         end if;
      end if;
--    end if;
  end process last_gen;

  -- Stop further DMA accesses on this channel if stop is used, the DMA
  -- pointer equals the PIO pointer, and the last unilateral access was
  -- from the DMA side.
  dmap_stop <= '1' when (suse = '1' and dmap_int = piop_int and dir = '1'
                         and last_ff = '0')
               else '1' when (suse = '1' and dmap_int = piop_int and dir = '0'
                              and last_ff = '1')
               else '0';
end rtl;


