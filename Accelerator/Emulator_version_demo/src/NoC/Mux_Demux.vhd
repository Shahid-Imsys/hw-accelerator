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
-- Title      : Mux_Demux
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Mux_Demux.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.17
-------------------------------------------------------------------------------
-- Description: -- NoC Mux/Demux    
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-17 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity Mux_Demux is
    Port(
        clk                 : in    std_logic;
        MuxInCtrl           : in    std_logic;
        MuxOutCtrl          : in    std_logic_vector(  1 downto 0);
        Load_Reg            : in    std_logic_vector(  1 downto 0);
        DataInSwitch        : in    std_logic_vector(511 downto 0);
        DataInExtMem        : in    std_logic_vector(127 downto 0);
        DataOutNOCreg       : out   std_logic_vector(511 downto 0);
        DataOutExtMem       : out   std_logic_vector(127 downto 0)
     );
end Mux_Demux;


architecture Behavioral of Mux_Demux is
    
    signal MuxIn3,MuxIn2,MuxIn1,MuxIn0,MD_Reg3,MD_Reg2,MD_Reg1,MD_Reg0  : std_logic_vector(127 downto 0);

begin

    process(DataInSwitch,DataInExtMem,MuxInCtrl)
    begin
        if MuxInCtrl = '1' then
            MuxIn3 <= DataInSwitch(511 downto 384);
            MuxIn2 <= DataInSwitch(383 downto 256);
            MuxIn1 <= DataInSwitch(255 downto 128);
            MuxIn0 <= DataInSwitch(127 downto 0);
        else
            MuxIn3 <= DataInExtMem;
            MuxIn2 <= DataInExtMem;
            MuxIn1 <= DataInExtMem;
            MuxIn0 <= DataInExtMem;
        end if;
    end process;
    
    process(clk)
    begin 
        if rising_edge(clk) then
            if Load_Reg = "11" then
                MD_Reg3 <= MuxIn3;
            end if;
            if Load_Reg = "10" then
                MD_Reg2 <= MuxIn2;
            end if;
            if Load_Reg = "01" then
                MD_Reg1 <= MuxIn1;
            end if;                           
            if Load_Reg = "00" then
                MD_Reg0 <= MuxIn0;
            end if;          
        end if;
    end process;
    
    process(MD_Reg3,MD_Reg2,MD_Reg1,MD_Reg0,MuxOutCtrl)
    begin
        if MuxOutCtrl = "11" then
            DataOutExtMem <= MD_Reg3;
        elsif MuxOutCtrl = "10" then
            DataOutExtMem <= MD_Reg2;
        elsif MuxOutCtrl = "01" then
            DataOutExtMem <= MD_Reg1;            
        elsif MuxOutCtrl = "00" then
            DataOutExtMem <= MD_Reg0;
        end if;
    end process;
    
    DataOutNOCreg(511 downto 384) <= MD_Reg3;
    DataOutNOCreg(383 downto 256) <= MD_Reg2;
    DataOutNOCreg(255 downto 128) <= MD_Reg1;
    DataOutNOCreg(127 downto 0)   <= MD_Reg0;
 
end Behavioral;    
