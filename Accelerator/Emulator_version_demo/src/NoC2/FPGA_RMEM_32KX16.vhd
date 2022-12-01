----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 31.10.2022 09:16:22
-- Design Name: 
-- Module Name: RM - Behavioral
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
use ieee.numeric_std.all;

entity FPGA_RMEM_32KX16 is
    port(
		  clk     : in std_logic;
          ena     : in std_logic;
          wea     : in std_logic;
          addra   : in std_logic_vector(14 downto 0);
          dina    : in std_logic_vector(127 downto 0);
          douta   : out std_logic_vector(127 downto 0)
	);	
	end FPGA_RMEM_32KX16;	

architecture Behavioral of FPGA_RMEM_32KX16 is

    type memunit is array (0 to 32767) of std_logic_vector(127 downto 0);
    signal mem  : memunit;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if wea = '1' and ena = '1' then
                mem(to_integer(unsigned(addra))) <= dina;
            end if;
			if wea = '0' and ena = '1' then
				douta<= mem(to_integer(unsigned(addra)));
			end if;
		end if;
	end process;

end Behavioral;
