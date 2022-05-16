----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2022 18:25:30
-- Design Name: 
-- Module Name: Noc_Input_Reg - Behavioral
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

entity Noc_Input_Reg is
  Port (
      clk                 : in  std_logic;
      Reset               : in  std_logic;
      write_enable        : in  std_logic;
      NoC_Input_reg_In    : in  std_logic_vector(127 downto 0);
      NoC_Input_reg_Out   : out std_logic_vector(127 downto 0)
   );
end Noc_Input_Reg;

architecture Behavioral of Noc_Input_Reg is
begin
    process (clk, Reset)
    begin
        if Reset = '1' then
            NoC_Input_reg_Out <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then 
                NoC_Input_reg_Out   <= NoC_Input_reg_In;
            end if;    
        end if;    
    end process;
end Behavioral;