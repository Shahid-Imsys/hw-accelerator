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
-- Title      : Acc
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Accumulator.vhd
-- Author     : Zejun Huang
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: accumulator
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2021-12-10  		     1.0	     ZH			Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity accumulator is 
    port(
        ------in------
        clk     : in std_logic;
        ce      : in std_logic;
        reset   : in std_logic;

        data    : in std_logic_vector(17 downto 0);
        ------out-----
        sum     : out std_logic_vector(31 downto 0)
    );
    attribute use_dsp : string;
    attribute use_dsp of accumulator : entity is "yes";
end entity;

architecture behavioural of accumulator is 
begin
   acc: process(clk)
    variable tmp_sum : signed(31 downto 0);
   begin
       if (rising_edge(clk)) then
         if (reset = '1') then
            tmp_sum := (others => '0');
         elsif (ce = '1') then 
            tmp_sum := tmp_sum + signed(data);
         end if;
         sum <= std_logic_vector(tmp_sum);
       end if;
   end process acc;
end architecture;
