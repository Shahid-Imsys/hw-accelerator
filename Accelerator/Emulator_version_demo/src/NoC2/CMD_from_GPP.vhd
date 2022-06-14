----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 08:41:20
-- Design Name: 
-- Module Name: CMD_from_GPP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CMD_from_GPP is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        GPP_CMD_Flag            : in  std_logic;
        Load_GPP_CMD_reg        : in  std_logic;
        Load_TSDiv16_reg        : in  std_logic;
        GPP_CMD_Data            : in  std_logic_vector(127 downto 0);
        Opcode                  : out std_logic_vector(7  downto 0);
        Switch_ctrl             : out std_logic_vector(7 downto 0);
        Transfer_size           : out std_logic_vector(15 downto 0);
        RM_address              : out std_logic_vector(15 downto 0);
        CM_Address0             : out std_logic_vector(14 downto 0);
        CM_Address1             : out std_logic_vector(14 downto 0);
        Padding_Data            : out std_logic_vector(7 downto 0);
        Length                  : out std_logic_vector(15 downto 0);
        Address                 : out std_logic_vector(31 downto 0);        
        CMD_FF                  : out std_logic;
        TSDiv16_Reg             : out std_logic_vector(11 downto 0);
        NOC_CMD_ACK             : out std_logic
    );
end CMD_from_GPP;

architecture Behavioral of CMD_from_GPP is

    signal  GPP_CMD_Reg         : std_logic_vector(127 downto 0);
    signal  Length_i            : std_logic_vector(15 downto 0);
    signal  Length_plus         : std_logic_vector(15 downto 0);
    signal  FF_Ack              : std_logic;
    
begin

    Opcode          <= GPP_CMD_Reg(7 downto 0);
    Switch_ctrl     <= GPP_CMD_Reg(15 downto 8);
    Transfer_size   <= GPP_CMD_Reg(31 downto 16);
    Length          <= GPP_CMD_Reg(31 downto 16);
    Length_i        <= GPP_CMD_Reg(31 downto 16);   
    RM_address      <= GPP_CMD_Reg(47 downto 32);
    CM_Address0     <= GPP_CMD_Reg(62 downto 48);
    CM_Address1     <= GPP_CMD_Reg(78 downto 64);
    Address         <= GPP_CMD_Reg(111 downto 80);
    Padding_Data    <= GPP_CMD_Reg(119 downto 112);
    
    NOC_CMD_ACK     <= FF_Ack;
    
    process(clk, Reset)
    begin
        if Reset = '1' then
            GPP_CMD_Reg         <= (others => '0');
            CMD_FF              <= '0';
            Length_plus         <= (others => '0');         
        elsif rising_edge(clk) then
            if Load_GPP_CMD_reg = '1' then
                GPP_CMD_Reg     <= GPP_CMD_Data;
            end if;
            CMD_FF              <= GPP_CMD_Flag;
            Length_plus         <= std_logic_vector(unsigned(Length_i) + x"000F");
            if Load_TSDiv16_Reg = '1' then
                TSDiv16_Reg     <= Length_plus(15 downto 4);
            end if;
            FF_Ack     <= Load_GPP_CMD_reg;
        end if;
    end process;           

end Behavioral;
