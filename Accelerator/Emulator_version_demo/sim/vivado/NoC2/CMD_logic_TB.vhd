----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2022 15:10:57
-- Design Name: 
-- Module Name: CMD_logic_TB - Behavioral
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

entity CMD_logic_TB is
--  Port ( );
end CMD_logic_TB;

architecture Behavioral of CMD_logic_TB is

    component CMD_logic is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        PEC_ready               : in  std_logic;
        NOC_Ready               : in  std_logic;
        GPP_Ack                 : in  std_logic;
        NOC_CMD_flag            : out std_logic;
        En_CMD                  : out std_logic;
        NOC_CMD_Data            : out std_logic_vector(1 downto 0)
    );
    end component;
    
    signal    clk                 : std_logic;
    signal    Reset               : std_logic;
    signal    PEC_ready           : std_logic;
    signal    NOC_Ready           : std_logic;
    signal    GPP_Ack             : std_logic;
    signal    NOC_CMD_flag        : std_logic;
    signal    En_CMD              : std_logic;
    signal    NOC_CMD_Data        : std_logic_vector(1 downto 0); 
    
begin

    UUT: CMD_logic port map (clk => clk, Reset => Reset, PEC_ready => PEC_ready, NOC_Ready => NOC_Ready, GPP_Ack => GPP_Ack, NOC_CMD_flag => NOC_CMD_flag, En_CMD => En_CMD, NOC_CMD_Data => NOC_CMD_Data);
    
    process
    begin
        Reset               <= '0';
        wait for 50 ns;    
        Reset               <= '1';   
        wait for 40 ns;    
        Reset               <= '0';          
        wait for 300 ns;  
--        CMD_FF              <= '1';           
        wait for 80 ns;
--        CMD_FF              <= '0';  
        wait for 200 ns;
--        Write_ack           <= '1';
        wait for 40 ns;
--        Write_ack           <= '0';
        wait for 200 ns;
--        FIFO_ready          <= '1';
        wait for 80 ns;
--        IO_data             <= x"00080001000000000050000100000000"; --"00000000 00500001 00000000 00080001";   00080001000000000050000100000000
        wait for 80 ns;
--        IO_data             <= x"05500000000007100000061300040010";
        wait for 200ns;           
    end process;
   
    process
    begin
        clk <= '0';
        for i in 1 to 3000 loop
            wait for 10ns;
            clk <= not clk;
        end loop;
        wait;
    end process;    

end Behavioral;
