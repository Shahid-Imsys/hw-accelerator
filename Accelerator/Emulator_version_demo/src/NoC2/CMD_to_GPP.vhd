----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 02.03.2022 16:45:44
-- Design Name: 
-- Module Name: CMD_logic - Behavioral
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

entity CMD_to_GPP is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        PEC_ready               : in  std_logic;
        NOC_Ready               : in  std_logic;
        GPP_ACK                 : in  std_logic;
        NOC_CMD_flag            : out std_logic;
        En_CMD                  : out std_logic;
        NOC_CMD_Data            : out std_logic_vector(1 downto 0)
    );
end CMD_to_GPP;

architecture Behavioral of CMD_to_GPP is

    --signal declaration
    signal  counter                 : unsigned(2 downto 0);
    signal  load                    : std_logic;
    signal  clear                   : std_logic;
    signal  enable                  : std_logic;    
    signal  load_counter            : std_logic;
    signal  Reset_PEC_NOC_Ready     : std_logic;
    signal  load_NOC_cmd_reg        : std_logic;
    signal  step_counter            : std_logic;
    signal  Decoder                 : std_logic_vector(5 downto 0);
    signal  NOC_Ready_FF            : std_logic;
    signal  PEC_ready_FF            : std_logic;
    signal  PEC_ready_P             : std_logic;
    signal  NOC_CMD_flag_i          : std_logic;
    signal  NOC_CMD_Reg             : std_logic_vector(1 downto 0);
    signal  xxx                     : std_logic;
    
begin

    NOC_CMD_flag            <= NOC_CMD_flag_i;
    NOC_CMD_Data            <= NOC_CMD_Reg;

    Decoder <= "100000" when counter = 0 else
               "100000" when counter = 1 else
               "010000" when counter = 2 else
               "101000" when counter = 3 else
               "100100" when counter = 4 else
               "100010" when counter = 5 else
               "100001" when counter = 6 else
               "100000" when counter = 7;
                                
    load_counter            <= Decoder(0);
    Reset_PEC_NOC_Ready     <= Decoder(1);
    load_NOC_cmd_reg        <= Decoder(3);
    step_counter            <= Decoder(5);
    
    load    <= load_counter or not (NOC_Ready_FF or PEC_ready_FF);
    enable  <= step_counter or (GPP_ACK and NOC_CMD_flag_i);
    
    process(clk, Reset)
    begin
        if Reset = '1' then
            counter                 <= (others => '0');
            PEC_ready_FF            <= '0';
            NOC_Ready_FF            <= '0';            
            NOC_CMD_Reg             <= "01";
            
        elsif rising_edge(clk) then
            PEC_ready_P             <= PEC_ready;
        
            if ((NOC_Ready = '1' or NOC_Ready_FF = '1') and not(Reset_PEC_NOC_Ready = '1' and NOC_CMD_Reg = "01")) then
                NOC_Ready_FF        <= '1';
            else     
                NOC_Ready_FF        <= '0';
            end if;
            
            if ((PEC_ready = '1' or PEC_ready_FF = '1') and not(Reset_PEC_NOC_Ready = '1' and NOC_CMD_Reg = "10")) then
                PEC_ready_FF        <= '1';
            else     
                PEC_ready_FF        <= '0';
            end if;           
            
--            if (NOC_CMD_Reg = "10" and Reset_PEC_NOC_Ready = '1') then
--                PEC_ready_FF        <= '0';
--            elsif (PEC_ready = '1' and PEC_ready_P = '0') then
--                PEC_ready_FF        <= '1';                
--            end if;
            
            if ( not(NOC_CMD_Reg = "10" and Reset_PEC_NOC_Ready = '1') and (NOC_CMD_Reg = "10" or (PEC_ready_FF = '1' and load_NOC_cmd_reg = '1'))) then
                NOC_CMD_Reg <= "10";
            else 
                NOC_CMD_Reg <= "01";
            end if;         
                
            if Decoder = "010000" then
                NOC_CMD_flag_i  <= '1';
            elsif  Decoder = "100100" then
                En_CMD          <= '1';
            else
                NOC_cmd_flag_i  <= '0';
                En_CMD          <= '0';
            end if;    
            if load = '1' then
                counter   <= (others => '0');
            elsif enable = '1' then
                counter   <= counter + 1;
            end if;            
        end if; --Reset
    end process;                           
    
end Behavioral;