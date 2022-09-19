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
        ERROR                   : in  std_logic;
        GPP_CMD_ACK             : in  std_logic;
        NOC_CMD_flag            : out std_logic;
        NOC_CMD_Data            : out std_logic_vector(7 downto 0)
    );
end CMD_to_GPP;

architecture Behavioral of CMD_to_GPP is

    --signal declaration
    signal  counter                 : unsigned(2 downto 0);
    signal  load                    : std_logic;
    signal  clear                   : std_logic;
    signal  enable                  : std_logic;    
    signal  load_counter            : std_logic;
    signal  Reset_PEC_NOC_ERROR_FF  : std_logic;
    signal  load_NOC_CMD_REG        : std_logic;
    signal  step_counter            : std_logic;
    signal  Decoder                 : std_logic_vector(5 downto 0);
    signal  NOC_Ready_FF            : std_logic;
    signal  PEC_ready_FF            : std_logic;
    signal  NOC_CMD_flag_i          : std_logic;
    signal  NOC_CMD_Reg             : std_logic_vector(7 downto 0);
    signal  NOC_ERROR_FF            : std_logic;
    signal  NOC_CMD_FF_value        : std_logic;
    
begin

    NOC_CMD_flag            <= NOC_CMD_flag_i;
    NOC_CMD_Data            <= NOC_CMD_Reg;

    Decoder <= "100000" when counter = 0 else   
               "100000" when counter = 1 else   
               "110000" when counter = 2 else   
               "001000" when counter = 3 else   
               "100100" when counter = 4 else   
               "100010" when counter = 5 else 
               "100001" when counter = 6 else  
               "100000" when counter = 7 else  
               "100000";  
                                
    load_counter            <= Decoder(0);      
    Reset_PEC_NOC_ERROR_FF  <= Decoder(2);      
    NOC_CMD_FF_value        <= Decoder(3);      
    load_NOC_CMD_REG        <= Decoder(4);      
    step_counter            <= Decoder(5);      
    
    load    <= load_counter or not (NOC_Ready_FF or PEC_ready_FF or NOC_ERROR_FF); --
    enable  <= step_counter or (GPP_CMD_ACK and NOC_CMD_FF_value);  --
    
    process(clk, Reset)
    begin
        if Reset = '1' then
            counter                 <= (others => '0');  
            PEC_ready_FF            <= '0';     
            NOC_Ready_FF            <= '0';     
            NOC_ERROR_FF            <= '0';            
            NOC_CMD_Reg             <= (others => '0');
            
        elsif rising_edge(clk) then
            NOC_CMD_flag_i          <= not(GPP_CMD_ACK) and NOC_CMD_FF_value;
        
            if ((NOC_Ready = '1' or NOC_Ready_FF = '1') and not((Reset_PEC_NOC_ERROR_FF = '1' and NOC_CMD_Reg(0) = '1') or Reset = '1')) then
                NOC_Ready_FF        <= '1';
            else     
                NOC_Ready_FF        <= '0';
            end if;
            
            if ((PEC_ready = '1' or PEC_ready_FF = '1') and not((Reset_PEC_NOC_ERROR_FF = '1' and NOC_CMD_Reg(1) = '1') or Reset = '1')) then
                PEC_ready_FF        <= '1';
            else     
                PEC_ready_FF        <= '0';
            end if;
                       
            if ((Error = '1' or NOC_ERROR_FF = '1') and not((Reset_PEC_NOC_ERROR_FF = '1' and NOC_CMD_Reg(2) = '1') or Reset = '1')) then
                NOC_ERROR_FF        <= '1';
            else     
                NOC_ERROR_FF        <= '0';
            end if;            
            
            if (load_NOC_CMD_REG = '1') then
                NOC_CMD_Reg(0) <= not(PEC_ready_FF) and not(NOC_ERROR_FF) and NOC_Ready_FF;
                NOC_CMD_Reg(1) <= not(NOC_ERROR_FF) and PEC_ready_FF ;
                NOC_CMD_Reg(2) <= NOC_ERROR_FF;
                NOC_CMD_Reg(7 downto 3) <= "00000";
            end if;         
                 
            if load = '1' then
                counter   <= (others => '0');
            elsif enable = '1' then
                counter   <= counter + 1;
            end if;            
        end if; --Reset
    end process;                           
    
end Behavioral;