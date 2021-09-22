----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.01.2021 09:30:14
-- Design Name: 
-- Module Name: defines - Behavioral
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
--constant word_size : positive := 16;
--constant address_size : positive := 24;
--subtype word is bit_vector(word_size - 1 downto 0);
--subtype address is bit_vector(address_size - 1 downto 0);

-- Will this work?, BA

--type Byte is array (7 downto 0) of std_logic;
--type NoC_bus_type is array (63 downto 0) of BYTE;
--type NoC_reg_type is array (31 downto 0) of BYTE;

--type WORD is array (15 downto 0) of std_logic;
--type NoC_bus_type1 is array (0 downto 0) of WORD;
--type NoC_bus_type2 is array (15 downto 0) of WORD;

subtype BYTE1 is std_logic_vector(7 downto 0);
type switch_data_type is array (31 downto 0) of BYTE1;
type switch_mux_type is array (1 downto 0) of BYTE1;

end package ACC_types;
