----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2022 17:15:12
-- Design Name: 
-- Module Name: noc_type_pkg - Behavioral
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

package noc_types_pkg is
  subtype BYTE2 is std_logic_vector(7 downto 0); 
  subtype two_bit is std_logic_vector(1 downto 0);
  type noc_data_t is array (natural range <>) of BYTE2;
  type noc_tag_t is array (natural range <>) of two_bit;

end package noc_types_pkg;