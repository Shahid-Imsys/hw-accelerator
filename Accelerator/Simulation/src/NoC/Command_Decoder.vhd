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
-- Title      : Command_Decoder
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Command_Decoder.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.17
-------------------------------------------------------------------------------
-- Description: -- Command decoder inside NOC block
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-18 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity Command_Decoder is
    Port(
        clk                 : in    std_logic;
        Reset_CMD_flag      : in    std_logic;
        Set_PEC_FF2         : in    std_logic;
        PEC_Ready_In        : in    std_logic;
        Write_En            : in    std_logic;
        Address_From_PCIE   : in    std_logic_vector(23 downto 0);
        Data_From_PCIE      : in    std_logic_vector(127 downto 0);
        PEC_Ready_Out       : out   std_logic;
        CMD_Flag            : out   std_logic;
        NOC_CMD             : out   std_logic_vector(11 downto 0);
        Switch_Ctrl         : out   std_logic_vector(3 downto 0);
        Transfer_Size       : out   std_logic_vector(15 downto 0);
        RM_Address          : out   std_logic_vector(15 downto 0);
        Ext_Mem_Address     : out   std_logic_vector(23 downto 0);
        PEC_CMD_REG         : out   std_logic_vector(5 downto 0);
        PEC_TS_REG          : out   std_logic_vector(14 dwonto 0);
        PEC_Address_REG     : out   std_logic_vector(14 dwonto 0)
    );
end Command_Decoder;


architecture Behavioral of Command_Decoder is

    signal Hardwired_Address        : std_logic_vector(23 downto 0);
    signal NOC_CMD_REG              : std_logic_vector(127 downto 0);
    signal NOC_CMD_REG_En           : std_logic : = '0';
    signal CMD_FF                   : std_logic : = '0';
    signal PEC_FF1                  : std_logic : = '0';
    signal PEC_FF2                  : std_logic : = '0';

begin

    if ((Hardwired_Address = Address_From_PCIE) and Write_En = '1') then
        NOC_CMD_REG_En = '1';
    end if;

    process(clk)
    begin
        if rising_edge(clk) then
            if NOC_CMD_REG_En = '1' then
                NOC_CMD_REG <= Data_From_PCIE;
            end if;
            CMD_FF   <= not(Reset_CMD_flag) and (NOC_CMD_REG_En or CMD_FF);
            PEC_FF2  <= PEC_FF1 and (Set_PEC_FF2 or PEC_FF2);
            PEC_FF1  <= PEC_Ready_In;
        end if;
    end process;

    CMD_Flag            <= CMD_FF;
    PEC_Ready_Out       <= PEC_FF1 and not(PEC_FF2);
    NOC_CMD             <= NOC_CMD_REG(11 downto 0);
    PEC_CMD_REG         <= NOC_CMD_REG( 5 downto 0);
    Switch_Ctrl         <= NOC_CMD_REG(15 downto 12);
    Transfer_Size       <= NOC_CMD_REG(31 downto 16);
    PEC_TS_REG          <= NOC_CMD_REG(30 downto 16);
    RM_Address          <= NOC_CMD_REG(47 downto 32);
    PEC_Address_REG     <= NOC_CMD_REG(62 downto 48);
    Ext_Mem_Address     <= NOC_CMD_REG(86 downto 63);
  
end Behavioral;

