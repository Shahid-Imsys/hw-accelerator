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
-- Title      : MPGM load latches
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : mpll.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The 'MPLL' generates microprogram memory load latch signals.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.4				CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mpll is  
  port (
    -- Clock signals
    rst_cn      : in std_logic;
    clk_p       : in std_logic;
    clk_c2_pos  : in  std_logic;   -- 'clk_c / 2' clock
    clk_e_pos   : in std_logic;
    clk_e_neg      : in  std_logic;   -- execution clock 
    gate_e     : in  std_logic;   -- Copy of execution clock used for gating, also the positive edge
    -- From CPC (SP load)
    wmlat			 : in  std_logic;   -- load mpll pulse (1 'clk_s', active high)
    byte_sel   : in  std_logic_vector(3 downto 0);  -- byte select
    dfsr       : in  std_logic_vector(7 downto 0);  -- data bus
    -- From GP processor (self-load)
    lmpen      : in  std_logic;   -- enable self-load (active high, from MMR)
    dbl_direct : in  std_logic;   -- select 16-bit load (if high, from MMR)
    ldmp       : in  std_logic;   -- load pulse (1 'clk_e', active high)
    direct     : in  std_logic_vector(7 downto 0);  -- data bus
    -- Output
    lmpwe_n    : out std_logic;   -- write mpgm mem pulse
    udo        : out std_logic_vector(79 downto 0));  -- mpgRAM input data bus
end mpll;

architecture rtl of mpll is
  signal cnt      : std_logic_vector(3 downto 0);
  signal even_reg : std_logic_vector(7 downto 0);

begin
  -- self-load counting. If 'dbl_direct' is true, the counter is counting up to
  -- '5' else to '10'.
  self_ld_counting: process (clk_p)
    variable cnt_int  : std_logic_vector(3 downto 0);
  begin
    if rising_edge(clk_p) then--positive edge of clk_e 
        if lmpen = '0' then  
            cnt_int   := (others => '0');
            lmpwe_n   <= '1';
        elsif clk_e_pos = '0' then
            lmpwe_n <= '1';
            if ldmp = '1' then
              cnt_int := cnt_int + 1;
            end if;
            if cnt_int = "0101" and dbl_direct = '1' then
              cnt_int := (others => '0');
              lmpwe_n <= '0';
            end if;
            if cnt_int = "1010" and dbl_direct = '0' then
              cnt_int := (others => '0');
              lmpwe_n <= '0';
            end if;
        end if;
    end if;
    cnt <= cnt_int;
  end process self_ld_counting;
  
  -- pre-load 'even' byte at 'double' case
  even_load: process (clk_p)
  begin  
    if rising_edge(clk_p) then--falling_edge(clk_e)
        if  rst_cn = '0' then
            even_reg <= (others => '0');
        elsif clk_e_neg = '0' then 
            if dbl_direct = '1' and ldmp = '1' and lmpen = '1' then
              even_reg <= direct;
            end if;
        end if;
    end if;
  end process even_load;
  
  -- load 'mpll'
  mpll_load: process (clk_p)
  begin 
    if rising_edge(clk_p) then--rising_edge(clk_c2)
        if rst_cn = '0' then
            udo <= (others => '0');
        elsif clk_c2_pos = '0' then
            if wmlat = '1' then     
              -- SP load
              for i in 9 downto 0 loop
                if byte_sel = i+1 then
                  udo((i+1)*8 - 1 downto i*8) <= dfsr;
                end if;
              end loop;
            elsif lmpen = '1' and ldmp = '1' and gate_e = '0' then    
              -- Self load
              if dbl_direct = '0' then
                                              -- Single byte transfer
                for i in 9 downto 0 loop
                  if cnt = 9-i then
                    udo((i+1)*8 - 1 downto i*8) <= direct;
                  end if;
                end loop;
              else
                                              -- Double byte transfer
                for i in 4 downto 0 loop
                  if cnt = 4-i then
                    udo((2*i + 2)*8 - 1 downto (2*i + 1)*8) <= even_reg;
                    udo((2*i + 1)*8 - 1 downto (2*i + 0)*8) <= direct;
                  end if;
                end loop;
              end if;
            end if;
        end if;
    end if;  
  end process mpll_load;
end rtl;
