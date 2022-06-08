----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        IO_Data                 : in  std_logic_vector(127 downto 0);
        Switch_Data             : in  std_logic_vector(127 downto 0);
        Data_Direction          : in  std_logic;  -- 0 downstream (IO Data)  -- 1 upstream (Switch Data)
        Mux_Demux_out0          : out std_logic_vector(127 downto 0);
        Mux_Demux_out1          : out std_logic_vector(127 downto 0)
    );       
end Mux_Demux;

architecture Behavioral of Mux_Demux is

    signal Mux_Demux_Data   : std_logic_vector(127 downto 0);

begin

    Mux_Demux_out0  <= Mux_Demux_Data when Data_Direction = '0'   else (others => '0');
    Mux_Demux_out1  <= Mux_Demux_Data when Data_Direction = '1'   else (others => '0');

    process(clk, Reset)
    begin
        if Reset = '1' then
            Mux_Demux_Data         <= (others => '0');                      
        elsif rising_edge(clk) then
            if Data_Direction = '0' then
                Mux_Demux_Data  <= IO_Data;
            else
                Mux_Demux_Data  <= Switch_Data;
            end if;
        end if;
    end process;

end Behavioral;
