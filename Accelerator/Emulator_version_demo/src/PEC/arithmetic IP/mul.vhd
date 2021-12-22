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
-- File       : Dist_ram_0.vhd
-- Author     : Zejun Huang
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Distributed RAM
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

entity mul is
    port(
        clk     : in std_logic;
        ce      : in std_logic;
        a       : in std_logic_vector(8 downto 0);
        b       : in std_logic_vector(8 downto 0);

        p       : out std_logic_vector(17 downto 0)
    );
    attribute use_dsp : string;
    attribute use_dsp of mul : entity is "yes";
end entity;

architecture behavioral of mul is 
begin
    process (clk)
    begin
        if (rising_edge(clk)) then 
            if (ce = '1') then 
                p <= std_logic_vector(signed(a) * signed(b));
            end if;
        end if;
    end process;
end behavioral;
