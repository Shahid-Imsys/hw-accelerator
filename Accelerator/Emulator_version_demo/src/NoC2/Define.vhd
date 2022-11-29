----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2022 13:08:22
-- Design Name: 
-- Module Name: Define - Behavioral
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package ACC_types is

subtype BYTE is std_logic_vector(7 downto 0); 
type WORD is array (15 downto 0) of BYTE;
type TP_data_type is array (15 downto 0) of WORD;
subtype BYTE1 is std_logic_vector(7 downto 0);
type switch_data_type is array (15 downto 0) of BYTE1;
    
end package ACC_types;