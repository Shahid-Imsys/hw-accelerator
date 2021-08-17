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
-- Title      : Broadcast_Byte
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Broadcast_Byte.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 28.01.2021
-------------------------------------------------------------------------------
-- Description: Broadcast byte counter
-------------------------------------------------------------------------------
-- TO-DO list :       
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-16 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity Broadcast_Byte is
    port(
	    clk                  : in  std_logic;
	    reset                : in  std_logic;
	    Reset_BC             : in  std_logic;
	    Step_BC              : in  std_logic;
	    decoder              : out std_logic_vector(31 downto 0);
	    byte_counter         : out std_logic_vector(4 downto 0)
        );
end Broadcast_Byte;


architecture Behavioral of Broadcast_Byte is

    signal Counter      : std_logic_vector(4 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Counter <= (others => '0');
            else
                if Reset_BC = '1' then
                   Counter <= (others => '0');
                elsif Step_BC = '1' then     
                   Counter <= Counter + '1';
                else 
                   Counter <= (others => '0');
                end if;
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
  
    byte_counter    <= Counter;
    
    
end Behavioral;

