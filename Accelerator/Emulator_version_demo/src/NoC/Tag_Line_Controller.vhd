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
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-12 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity Tag_Line_Controller is
    port(
        clk                     : in  std_logic;
        reset                   : in  std_logic;        
        Load_Tag_Shift_Counter  : in  std_logic;
        Start_Tag_Shift         : in  std_logic;
        Shift_Count             : in  std_logic_vector(7 downto 0);
        Tag_shift               : out std_logic
    );
end Tag_Line_Controller;


architecture struct of Tag_Line_Controller is

    signal Tag_Shift_Counter    : std_logic_vector(7 downto 0);
    signal Start_Tag_Shift_pre  : std_logic;

begin  

    process (clk, reset)
    begin
        if reset = '1' then
             Tag_Shift_Counter   <= (others => '0');
             Start_Tag_Shift_pre <= '0';
             TAG_shift           <= '0'; 
        elsif rising_edge(clk) then
            if Load_Tag_Shift_Counter = '1' then
                Tag_Shift_Counter <= Shift_Count + '1';  -- to add one cycle for CC command buffer original was Tag_Shift_Counter <= Shift_Count;
            elsif Start_Tag_Shift = '1' or Start_Tag_Shift_pre = '1' then
                Tag_Shift_Counter <= Tag_Shift_Counter - 1;
                Start_Tag_Shift_pre<= '1';
                TAG_shift <= '1';
                if Tag_Shift_Counter = 0 then      
                    TAG_shift <= '0';
                    Start_Tag_Shift_pre <= '0';
                    Tag_Shift_Counter   <= (others => '0');
                end if;
            end if;
        end if;
    end process;
end; 
