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
-- Title      : NoC_Input_reg
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : NoC_Input_reg.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.10
-------------------------------------------------------------------------------
-- Description: -- NoC Input register    
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-10 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.defines.all;


entity NoC_Input_reg is
    port (
            clk                 : in std_logic;
            NoC_Input_reg_In    : in std_logic_vector(511 downto 0);
            NoC_Input_reg_Out   : in std_logic_vector(511 downto 0)
        );
    end;


architecture struct of Tag_Interface is
    begin

        process (clk)
        begin
            if rising_edge(clk) then     
                NoC_Input_reg_Out   <= NoC_Input_reg_In;
            end if;
        end process;
    end;
    


