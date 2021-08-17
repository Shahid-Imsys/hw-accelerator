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
-- Title      : Tag_Interface
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Tag_Interface.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.09
-------------------------------------------------------------------------------
-- Description: Tag Inteface part of NOC          
-------------------------------------------------------------------------------
-- TO-DO list :       
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-09 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Tag_Interface is    
    port(
        clk                 : in  std_logic;
        reset               : in  std_logic;
        Load_TAG_Cmd_reg    : in  std_logic;
        Load_TAG_Arg_reg    : in  std_logic;
        Tag_shift           : in  std_logic;
        PEC_AS              : in  std_logic_vector(14 downto 0);
        PEC_TS              : in  std_logic_vector(14 downto 0);
        PEC_CMD             : in  std_logic_vector( 5 downto 0);
        Tag_Line            : out std_logic
        );
    end;

architecture struct of Tag_Interface is

    signal PEC_Reg          : std_logic_vector(36 downto 0);  -- to add one cycle for CC command buffer original was signal PEC_Reg 
    signal PEC_CMD_Ready    : std_logic;
    signal PEC_Arg_Ready    : std_logic;
    signal Tag_shift_p      : std_logic;
        
begin

    process (clk)
    begin  
        if rising_edge(clk) then
            if reset = '0' then
                PEC_Reg         <= (others => '0');
                PEC_CMD_Ready   <= '0';
                PEC_Arg_Ready   <= '0';
                Tag_shift_p     <= '0';
                Tag_Line        <= '0';
            else
                Tag_shift_p     <= Tag_shift;           
                if Load_TAG_Cmd_reg = '1' then
                    PEC_Reg(36 downto 31)       <= PEC_CMD;  -- to add one cycle for CC command buffer
                    PEC_Reg(30)                 <= '0';      -- to add one cycle for CC command buffer
                    PEC_CMD_Ready               <= '1';
                end if;
    
                if Load_TAG_Arg_reg = '1' then
                    PEC_Reg(29 downto 15)       <= PEC_TS;
                    PEC_Reg(14 downto 0)        <= PEC_AS;
                    PEC_Arg_Ready               <= '1'; 
                end if;    
    
                if Tag_shift = '1' and PEC_CMD_Ready = '1' and PEC_Arg_Ready = '1' then
                    Tag_Line                    <= PEC_Reg(36); 
                    PEC_Reg(36 downto 0)        <= PEC_Reg(35 downto 0) & '0';                
                end if;
    
                if Tag_shift = '0' and Tag_shift_p = '1' then
                    PEC_CMD_Ready               <= '0';
                    PEC_Arg_Ready               <= '0';
                    Tag_Line                    <= '0';
                    PEC_Reg                     <= ( others => '0'); 
                end if;
            end if;            
        end if;    
    end process;
end;