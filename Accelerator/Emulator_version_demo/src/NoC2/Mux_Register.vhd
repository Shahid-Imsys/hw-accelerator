----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 16:33:59
-- Design Name: 
-- Module Name: Mux_Register - Behavioral
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

entity Mux_Register is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        Load_Mux_Reg            : in  std_logic;
        Control_Data            : in  std_logic_vector(7 downto 0);
        NOC_reg_mux_ctrl        : out std_logic_vector(1 downto 0);
        NOC_data_mux_ctrl       : out std_logic;
        Data_dir                : out std_logic;
        NOC_bus_out_mux_ctrl    : out std_logic;
        Loop_reg_mux_ctrl       : out std_logic;
        R_W_RM                  : out std_logic
    );        
end Mux_Register;

architecture Behavioral of Mux_Register is

    signal Mux_reg :   std_logic_vector(7 downto 0):= (others => '0');
    
begin

    NOC_reg_mux_ctrl        <= Mux_reg(1 downto 0);
    NOC_data_mux_ctrl       <= Mux_reg(2);
    Data_Dir                <= Mux_reg(3);
    NOC_bus_out_mux_ctrl    <= Mux_reg(4);
    Loop_reg_mux_ctrl       <= Mux_reg(5);
    R_W_RM                  <= Mux_reg(6);

    process(clk, Reset)
    begin
        if Reset = '1' then
            Mux_reg        <= (others => '0');
        elsif rising_edge(clk) then
            if (Load_Mux_Reg = '1') then 
                Mux_reg    <=  Control_Data;
            end if;    
        end if;
    end process;

end Behavioral;
