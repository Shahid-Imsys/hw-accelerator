----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 05.04.2022 15:56:34
-- Design Name: 
-- Module Name: Acc_data_types - Behavioral
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

package Acc_data_types is

subtype BYTE1 is std_logic_vector(7 downto 0);
type switch_data_type is array (15 downto 0) of BYTE1;

end package Acc_data_types;
