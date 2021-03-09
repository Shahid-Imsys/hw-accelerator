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
-- Title      : Tag_Line_Controller
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Tag_Line_Controller.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.10
-------------------------------------------------------------------------------
-- Description: -- TAG Line Controller   
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-12 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity Tag_Line_Controller is
    port(
        clk                 : in    std_logic;
        Load_Shift_Counter  : in    std_logic;
        Start_Shift         : in    std_logic;
        Shift_Count         : in    std_logic_vector(7 downto 0);
        Shift               : out   std_logic
    );
end Tag_Line_Controller;


architecture struct of Tag_Line_Controller is

    signal Shift_Counter : std_logic_vector(7 downto 0) := ( others => '0');

begin  

    process (clk)
    begin
        if rising_edge(clk) then
            if Load_Shift_Counter = '1' then
                Shift_Counter <= Shift_Count;
            elsif Shift_Counter = 0 then
                Shift <= '0';
            elsif Start_Shift = '1' then
                Shift_Counter <= Shift_Counter - 1;
                Shift <= '1';
            end if;
        end if;
    end process;
    
end;              
                

                        

