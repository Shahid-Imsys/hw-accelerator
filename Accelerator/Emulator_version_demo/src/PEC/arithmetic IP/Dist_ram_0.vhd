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
use IEEE.std_logic_unsigned.all;

entity dist_ram0 is 
    port(
        clk     : in std_logic;
        we      : in std_logic;
        addr    : in std_logic_vector(7 downto 0);
        di     : in std_logic_vector(63 downto 0);

        do    : out std_logic_vector(63 downto 0)
    );
end entity;

architecture rtl of dist_ram0 is 
    type ram_type is array (255 downto 0) of std_logic_vector(63 downto 0);
    signal RAM : ram_type;
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                RAM(conv_integer(addr)) <= di; 
            end if; 
        end if;
    end process;
    do <= RAM(conv_integer(addr));
end rtl;
