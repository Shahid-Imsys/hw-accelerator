----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 05.04.2022 13:54:46
-- Design Name: 
-- Module Name: Mux_Demux - Behavioral
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

entity Mux_Demux is
    port(
        IO_Data                 : in  std_logic_vector(127 downto 0);
        Switch_Data             : in  std_logic_vector(127 downto 0);
        Mux_Demux_out0          : out std_logic_vector(127 downto 0);
        Mux_Demux_out1          : out std_logic_vector(127 downto 0)
    );       
end Mux_Demux;

architecture Behavioral of Mux_Demux is

begin

    Mux_Demux_out0  <= IO_Data;
    Mux_Demux_out1  <= Switch_Data;

end Behavioral;
