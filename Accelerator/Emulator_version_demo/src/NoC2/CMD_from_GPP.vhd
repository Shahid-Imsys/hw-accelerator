----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
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
        Load_GPP_CMD            : in  std_logic;
        GPP_CMD_Data            : in  std_logic_vector(127 downto 0);
        Control_data            : in  std_logic_vector(7 downto 0);
        Opcode                  : out std_logic_vector(7  downto 0);
        Switch_ctrl             : out std_logic_vector(7 downto 0);
        Transfer_size           : out std_logic_vector(15 downto 0);
        RM_address              : out std_logic_vector(14 downto 0);
        CM_Address0             : out std_logic_vector(14 downto 0);
        CM_Address1             : out std_logic_vector(14 downto 0);
        Padding_Data            : out std_logic_vector(7 downto 0);
        NOC_Length              : out std_logic_vector(15 downto 0);
        NOC_Address             : out std_logic_vector(31 downto 0);        
        TSDiv16_Reg             : out std_logic_vector(11 downto 0);
        CMD_FF                  : out std_logic;        
        NOC_CMD_ACK             : out std_logic;
        Address_steps           : out std_logic_vector(118 downto 0);
        End_values              : out std_logic_vector(118 downto 0)
    );
end CMD_from_GPP;

architecture Behavioral of CMD_from_GPP is

    signal  GPP_CMD_Reg         : std_logic_vector(127 downto 0);
    signal  GPP_CMD_Reg2        : std_logic_vector(118 downto 0);
    signal  GPP_CMD_Reg3        : std_logic_vector(118 downto 0);
    signal  NOC_Length_i        : std_logic_vector(15 downto 0);
    signal  NOC_Length_plus     : std_logic_vector(15 downto 0);
    signal  FF_Ack              : std_logic;
    signal  FF                  : std_logic;
    
begin

    Opcode          <= GPP_CMD_Reg(7 downto 0);
    Switch_ctrl     <= GPP_CMD_Reg(15 downto 8);
    Transfer_size   <= GPP_CMD_Reg(31 downto 16);
    NOC_Length      <= GPP_CMD_Reg(31 downto 16);
    NOC_Length_i    <= GPP_CMD_Reg(31 downto 16);   
    RM_address      <= GPP_CMD_Reg(46 downto 32);
    CM_Address0     <= GPP_CMD_Reg(62 downto 48);
    CM_Address1     <= GPP_CMD_Reg(78 downto 64);
    NOC_Address     <= GPP_CMD_Reg(111 downto 80);
    Padding_Data    <= GPP_CMD_Reg(119 downto 112);
    
    NOC_CMD_ACK     <= FF_Ack;
    
    Address_steps   <= GPP_CMD_Reg2;
    End_values      <= GPP_CMD_Reg3;
    
    process(clk, Reset)
    begin
        if Reset = '0' then
            GPP_CMD_Reg         <= (others => '0');
            CMD_FF              <= '0';
            NOC_Length_plus     <= (others => '0');         
        elsif rising_edge(clk) then
            if Load_GPP_CMD = '1' and Control_data(0) = '1' then
                GPP_CMD_Reg     <= GPP_CMD_Data;
                FF              <= '1';
            end if;
            if Load_GPP_CMD = '1' and Control_data(1) = '1' then
                GPP_CMD_Reg2    <= GPP_CMD_Data(118 downto 0);
            end if;
            if Load_GPP_CMD = '1' and Control_data(2) = '1' then
                GPP_CMD_Reg3    <= GPP_CMD_Data(118 downto 0);
            end if;                       
            CMD_FF              <= GPP_CMD_Flag;
            NOC_Length_plus     <= std_logic_vector(unsigned(NOC_Length_i) + x"000F");
            if FF = '1' then
                TSDiv16_Reg     <= NOC_Length_plus(15 downto 4);
            end if;
            FF_Ack     <= Load_GPP_CMD;
        end if;
    end process;           

end Behavioral;