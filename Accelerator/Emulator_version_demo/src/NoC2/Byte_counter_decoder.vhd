----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 21:51:11
-- Design Name: 
-- Module Name: Byte_counter_decoder - Behavioral
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

entity Byte_counter_decoder is
    port(
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
	    Reset_BC             : in  std_logic;
	    Step_BC              : in  std_logic;
	    Decoder              : out std_logic_vector(31 downto 0);
	    byte_counter         : out std_logic_vector(4 downto 0)
    );
end Byte_counter_decoder;

architecture Behavioral of Byte_counter_decoder is

    signal Counter      : unsigned(4 downto 0);

begin

    process (clk,Reset)
    begin
        if Reset = '1' then
            Counter <= (others => '0');
        elsif rising_edge(clk) then
            if Reset_BC = '1' then
               Counter <= (others => '0');
            elsif Step_BC = '1' then     
               Counter <= Counter + 1;
            else 
               Counter <= (others => '0');
            end if;
        end if;                           
    end process;
    
    decoder <= "00000000000000000000000000000001"   when Counter = "00000" else
               "00000000000000000000000000000010"   when Counter = "00001" else
               "00000000000000000000000000000100"   when Counter = "00010" else
               "00000000000000000000000000001000"   when Counter = "00011" else
               "00000000000000000000000000010000"   when Counter = "00100" else
               "00000000000000000000000000100000"   when Counter = "00101" else
               "00000000000000000000000001000000"   when Counter = "00110" else
               "00000000000000000000000010000000"   when Counter = "00111" else
               "00000000000000000000000100000000"   when Counter = "01000" else
               "00000000000000000000001000000000"   when Counter = "01001" else
               "00000000000000000000010000000000"   when Counter = "01010" else
               "00000000000000000000100000000000"   when Counter = "01011" else               
               "00000000000000000001000000000000"   when Counter = "01100" else               
               "00000000000000000010000000000000"   when Counter = "01101" else                            
               "00000000000000000100000000000000"   when Counter = "01110" else               
               "00000000000000001000000000000000"   when Counter = "01111" else               
               "00000000000000010000000000000000"   when Counter = "10000" else               
               "00000000000000100000000000000000"   when Counter = "10001" else               
               "00000000000001000000000000000000"   when Counter = "10010" else               
               "00000000000010000000000000000000"   when Counter = "10011" else               
               "00000000000100000000000000000000"   when Counter = "10100" else               
               "00000000001000000000000000000000"   when Counter = "10101" else                      
               "00000000010000000000000000000000"   when Counter = "10110" else               
               "00000000100000000000000000000000"   when Counter = "10111" else               
               "00000001000000000000000000000000"   when Counter = "11000" else   
               "00000010000000000000000000000000"   when Counter = "11001" else               
               "00000100000000000000000000000000"   when Counter = "11010" else               
               "00001000000000000000000000000000"   when Counter = "11011" else   
               "00010000000000000000000000000000"   when Counter = "11100" else   
               "00100000000000000000000000000000"   when Counter = "11101" else               
               "01000000000000000000000000000000"   when Counter = "11110" else               
               "10000000000000000000000000000000"   when Counter = "11111" else 
               "00000000000000000000000000000000"; 
  
    byte_counter    <= std_logic_vector(Counter);

end Behavioral;
