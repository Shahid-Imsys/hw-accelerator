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
-- Title      : Noc_Input_Reg
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Noc_Input_Reg.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 28.01.2021
-------------------------------------------------------------------------------
-- Description: -- NoC Input register    
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.ACC_types.all;


entity Noc_Input_Reg is
    port (
            clk                 : in  std_logic;
            reset               : in  std_logic;
            NoC_Input_reg_In    : in  std_logic_vector(15 downto 0);
            NoC_Input_reg_Out   : out std_logic_vector(15 downto 0)
        );
end Noc_Input_Reg;

architecture Behavioral of Noc_Input_Reg is

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                NoC_Input_reg_Out <= (others => '0');
            else    
                NoC_Input_reg_Out   <= NoC_Input_reg_In;
            end if;    
        end if;
    end process;
end Behavioral;


