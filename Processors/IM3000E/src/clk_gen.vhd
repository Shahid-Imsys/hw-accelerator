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
-- Title      : Clock generation block
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : clk_gen.vhd
-- Author     : Christian Blixt
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
-- 2005-11-28           2.1                             CB                      Created
-- 2005-12-20           2.2                             CB                      Added PLL bypass.
-- 2005-12-21           2.3                             CB                      Cleaned out some duplicate outputs.
-- 2006-01-26           2.4                             CB                      Added clk_a.
-- 2006-02-08           2.5                             CB                      Removed unnecessary _int signals.
-- 2006-02-15           2.6                             CB                      Removed internal drive of Ethernet clocks.
-- 2006-03-21           2.7                     CB                      Added clock switching logic instead of the
--                                                                                                                              clk_p mux. Changed en_pll to sel_pll. Removed
--                                                                                                                              the en_c signal, gating of clk_c now
--                                                                                                                              controlled by rst_cn.
-- 2012-06-14       3.0             MN          Added power management of clk_in_off and clk_main_off
-- 2012-07-12       3.1                         MN                      Moved clk_in_off to iopads module as the input enable for HCLK
-- 2012-09-03           3.2                     MN                      Add router enable, and clock signals for router
-- 2012-12-14       4.0             MN          Add clk_ea, clk_c2a, din_ea for auxiliary core 
-- 2013-01-30       4.1             MN          change clk_in_off back considering the feature of IO pad
-- 2013-02-13       5.0             MN          reconstruct the clock generator
-- 2013-02-19       5.1             MN          change the clk_p generator
-- 2015-07-14       5.2             MN          output different clk_d_pos for core1 and core2
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
    -- Reset input
    --rst_n         : in  std_logic;      -- Asynchronous, from core
    clk_mux_out  : in  std_logic;
    rst_cn       : in  std_logic;       -- Synchronized to clk_c, from core
    -- Clock inputs
    erxclk       : in  std_logic;       -- Ethernet rx clock from Pad
    etxclk       : in  std_logic;       -- Ethernet tx clock from Pad
    -- Clock control inputs, from core
    en_d         : in  std_logic;       -- Enables clk_d when high
    fast_d       : in  std_logic;       -- High speed of DRAM clock when high
    din_i        : in  std_logic;       -- D input to the FF generating clk_i
    din_u        : in  std_logic;       -- D input to the FF generating clk_u
    din_s        : in  std_logic;       -- D input to the FF generating clk_s
    din_a        : in  std_logic;       -- D input to the FF generating clk_a
    -- power management register added in 2012-06-14 16:42:44 by maning
    clk_in_off   : in  std_logic;
    clk_main_off : in  std_logic;
    hold_flash_d : in  std_logic;
    -- Buffered clock net outputs, to core 
    clk_p        : out std_logic;       -- PLL clock, also feedback to PLL  
    clk_c_en     : out std_logic;       -- PLL clock with enable  
    even_c       : out std_logic; 
    clk_i_pos    : out std_logic;       -- I/O clock positive edge
    clk_i        : out std_logic;       -- I/O clock for output
    clk_d        : out std_logic;       -- DRAM clock
    clk_d_pos    : out std_logic;       -- DRAM clock
    clk_da_pos   : out std_logic;       -- DRAM clock for core2
    clk_u_pos    : out std_logic;       -- UART clock
    clk_s        : out std_logic;
    clk_s_pos    : out std_logic;       -- SP clock
    clk_rx       : out std_logic;       -- ETH Rx clock
    clk_tx       : out std_logic;       -- ETH Tx clock    
    clk_a_pos    : out std_logic);      -- Analog clock
end clk_gen;

architecture rtl of clk_gen is
  -- These are the clocks before the clock trees, all FFs below
  -- are clocked by clk_c_int, before the clock tree.
  signal clk_p_int  : std_logic;
  signal clk_c_int  : std_logic;
  -- Early copy of the even_c signal used in the core.
  -- Used here only to generate clk_d when fast_d is zero.
  signal even_c_int : std_logic;

  -- These intermediate signals are needed for zero-timing
  -- simulation. They should not affect synthesis.
  --signal clk_p_int2   : std_logic;
  signal clk_p_int3     : std_logic;
  signal clk_i_int      : std_logic;
  signal clk_i_pos_int  : std_logic;
  signal clk_d_int      : std_logic;
  signal clk_d_pos_int  : std_logic;
  signal clk_da_pos_int : std_logic;
  signal clk_u_int      : std_logic;
  signal clk_s_int      : std_logic;
  signal clk_s_pos_int  : std_logic;
  signal clk_a_int      : std_logic;

begin

  clk_p_int <= clk_mux_out when clk_in_off = '0' else '0';
  clk_p     <= clk_p_int;

  -- PLL output is the source of clk_c except when the PLL
  -- is disabled, then clk_c is taken directly from the
  -- reference oscillator. clk_c can be disabled by rst_cn
  -- low. When disabled, clk_c stays high.
--  clk_c_int           <= clk_p_int or not rst_cn;
  clk_c_int <= rst_cn and (not clk_main_off);

  -- Generation of even_c, high during even cycles of clk_c
  -- NOTE that this FF is clocked by clk_c_int, before the clock tree!
  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        even_c_int <= '1';
      elsif clk_c_int = '1' then
        even_c_int <= not even_c_int;
      end if;
    end if;
  end process;
  even_c <= even_c_int;

  -- Generate clk_i
  -- NOTE that this FF is clocked by clk_c_int, before the clock tree!
  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        clk_i_int <= '1';
      elsif clk_c_int = '1' then
        clk_i_int <= din_i;
      end if;
    end if;
  end process;

  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        clk_i_pos_int <= '1';
      elsif clk_c_int = '1' then
        clk_i_pos_int <= din_i;
      end if;
    end if;
  end process;
  -- Generate clk_d
  -- When en_d is set, clk_d equals clk_c if fast_d is set, the inverse of
  -- even_c otherwise. When en_d is not set, clk_d stays high if fast_d is
  -- set, low otherwise.
  -- NOTE that the source of this signal is clk_c_int, before the clock tree!
  clk_d_int <= clk_p_int or (not clk_c_int) or not en_d when fast_d = '1' else
               not even_c_int and en_d;

  clk_d_pos_int <= (not clk_c_int) or (not en_d) or hold_flash_d when fast_d = '1' else
                   (not clk_c_int) or (not even_c_int) or (not en_d) or hold_flash_d;
  clk_da_pos_int <= (not clk_c_int) or not en_d when fast_d = '1' else
                    (not clk_c_int) or even_c_int or (not en_d);
  -- Generate clk_u
  -- NOTE that this FF is clocked by clk_c_int, before the clock tree!
  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        clk_u_int <= '0';
      elsif clk_c_int = '1' then
        clk_u_int <= din_u;
      end if;
    end if;
  end process;

  -- Generate clk_s
  -- NOTE that this FF is clocked by clk_c_int, before the clock tree!
  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        clk_s_int <= '0';
      elsif clk_c_int = '1' then
        clk_s_int <= din_s;
      end if;
    end if;
  end process;

  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        clk_s_pos_int <= '0';
      elsif clk_c_int = '1' then
        clk_s_pos_int <= din_s;
      end if;
    end if;
  end process;

  clk_rx <= erxclk;
  clk_tx <= etxclk;

  -- Generate clk_a
  -- NOTE that this FF is clocked by clk_c_int, before the clock tree!
  process (clk_p_int)
  begin
    if rising_edge(clk_p_int) then
      if rst_cn = '0' then
        clk_a_int <= '0';
      elsif clk_c_int = '1' then
        clk_a_int <= din_a;
      end if;
    end if;
  end process;

  -- These buffers are needed for zero-timing simulation.
  -- They should not affect synthesis.
  --clk_p_int3 <= clk_p_int2;
  clk_p      <= clk_p_int;
  clk_c_en   <= clk_c_int;
  clk_i      <= clk_i_int;
  clk_i_pos  <= clk_i_pos_int or (not din_i);
  clk_d      <= clk_d_int;
  clk_d_pos  <= clk_d_pos_int;
  clk_da_pos <= clk_da_pos_int;
  clk_u_pos  <= clk_u_int or (not din_u);
  clk_s_pos  <= clk_s_pos_int or (not din_s);
  clk_s      <= clk_s_int;
  clk_a_pos  <= clk_a_int or (not din_a);

end;
