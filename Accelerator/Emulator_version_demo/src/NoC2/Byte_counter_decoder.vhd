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
	    RM_as_mux            : in  std_logic;
	    RM_byte_as           : in  std_logic_vector(3 downto 0);
	    Decoder              : out std_logic_vector(15 downto 0);
	    byte_counter         : out std_logic_vector(3 downto 0)
    );
end Byte_counter_decoder;

architecture Behavioral of Byte_counter_decoder is

    signal Counter      : unsigned(3 downto 0);
    signal counter_mux  : unsigned(3 downto 0);

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
    
    counter_mux     <= Counter when RM_as_mux = '0' else unsigned(RM_byte_as);   
    
    decoder <= "0000000000000001"   when counter_mux = "0000" else
               "0000000000000010"   when counter_mux = "0001" else
               "0000000000000100"   when counter_mux = "0010" else
               "0000000000001000"   when counter_mux = "0011" else
               "0000000000010000"   when counter_mux = "0100" else
               "0000000000100000"   when counter_mux = "0101" else
               "0000000001000000"   when counter_mux = "0110" else
               "0000000010000000"   when counter_mux = "0111" else
               "0000000100000000"   when counter_mux = "1000" else
               "0000001000000000"   when counter_mux = "1001" else
               "0000010000000000"   when counter_mux = "1010" else
               "0000100000000000"   when counter_mux = "1011" else               
               "0001000000000000"   when counter_mux = "1100" else               
               "0010000000000000"   when counter_mux = "1101" else                            
               "0100000000000000"   when counter_mux = "1110" else               
               "1000000000000000"   when counter_mux = "1111" else 
               "0000000000000000"; 
  
    byte_counter    <= std_logic_vector(Counter);

end Behavioral;