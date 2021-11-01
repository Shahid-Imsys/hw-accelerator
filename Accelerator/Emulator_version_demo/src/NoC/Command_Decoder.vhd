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
-- Date       : 28.01.2021 08:46:29
-------------------------------------------------------------------------------
-- Description: Extracts different parts from the received command in NOC            
-------------------------------------------------------------------------------
-- TO-DO list :             
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Command_Decoder is
    Port(
        clk                 : in   std_logic;
        reset               : in   std_logic;
        PEC_Ready_In        : in   std_logic;
        Set_PEC_FF2         : in   std_logic;
        CMD_flag            : in   std_logic; 
        Load_CMD_reg        : in   std_logic;
        Noc_data            : in   std_logic_vector(95 downto 0); 
        MD_PCIe_cmd         : in   std_logic; 
        PEC_Ready_Out       : out  std_logic;
        CMD_FF              : out  std_logic;
        Opcode              : out  std_logic_vector(11 downto 0);
        Switch_ctrl         : out  std_logic_vector(3 downto 0);
        Transfer_size       : out  std_logic_vector(15 downto 0);
        RM_Address          : out  std_logic_vector(15 downto 0);
        PCIe_Address        : out  std_logic_vector(31 downto 0); 
        PEC_TS_reg          : out  std_logic_vector(14 downto 0);
        PEC_Address_reg     : out  std_logic_vector(14 downto 0);
        PCIe_length         : out  std_logic_vector(4 downto 0) 
    );
end Command_Decoder;


architecture Behavioral of Command_Decoder is

    signal CMD_reg      : std_logic_vector(95 downto 0);
    signal PEC_FF1      : std_logic;
    signal PEC_FF2      : std_logic:= '0';
    signal Adder        : std_logic_vector(6 downto 0);

begin

    process(clk, reset)
    begin
        if reset = '1' then
            CMD_reg     <= (others => '0');
            CMD_FF      <= '0';
			Adder		<= (others => '0');
			PCIe_length <= (others => '0');
        elsif rising_edge(clk) then
            if Load_CMD_reg = '1' then
                CMD_reg <= Noc_data;
            end if;
        
            CMD_FF   <= CMD_flag;
            PEC_FF2  <= PEC_FF1 and (Set_PEC_FF2 or PEC_FF2);
            PEC_FF1  <= PEC_Ready_In;
            Adder       <= CMD_reg(22 downto 16) + "0000011";
            PCIe_length <= Adder(6 downto 2) + "11111";      --number of cache lines - 1               
        end if;
    end process;

    PEC_Ready_Out       <= PEC_FF1 and not(PEC_FF2);

    Opcode              <= CMD_reg(11 downto 0);
    Switch_Ctrl         <= CMD_reg(15 downto 12);
    Transfer_Size       <= CMD_reg(31 downto 16);
    PEC_TS_REG          <= CMD_reg(30 downto 16);
    RM_Address          <= CMD_reg(47 downto 32);
    PEC_Address_reg     <= CMD_reg(62 downto 48);
    PCIe_Address        <= CMD_reg(95 downto 64);
  
end Behavioral;