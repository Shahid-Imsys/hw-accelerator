----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2022 18:11:52
-- Design Name: 
-- Module Name: Noc_Reg - Behavioral
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

entity Noc_Register is
  Port (
      clk               : in  std_logic;
      Reset             : in  std_logic;
      Mux_select        : in  std_logic_vector(1 downto 0);
      Input_reg_data    : in  std_logic_vector(127 downto 0);
      Root_Memory_data  : in  std_logic_vector(127 downto 0);
      TP_data           : in  std_logic_vector(127 downto 0);
      Mux_Demux_data    : in  std_logic_vector(127 downto 0);
      Load_NOC_reg      : in  std_logic;		
      Noc_Reg_out       : out std_logic_vector(127 downto 0)  
   );
end Noc_Register;

architecture Behavioral of Noc_Register is

    signal Dataout_mux  : std_logic_vector(127 downto 0);
begin
	process (Mux_select,Input_reg_data,Root_Memory_data,TP_data,Mux_Demux_data,Reset)
	begin
        if Reset = '1' then
	        Dataout_mux     <= ( others => '0');
	    elsif Mux_select = "00" then
            Dataout_mux     <= Input_reg_data;
        elsif  Mux_select = "01" then
            Dataout_mux     <= Root_Memory_data;
        elsif  Mux_select = "10" then
            Dataout_mux     <= TP_data;           
        elsif  Mux_select = "11" then
            Dataout_mux     <= Mux_Demux_data;
        else     
            Dataout_mux     <= ( others => '0');
        end if;
    end process;
    
	process(clk, Reset)
	begin
		if Reset = '1' then
            Noc_Reg_out   <= (others => '0');
		elsif rising_edge (clk) then
			if (Load_NOC_reg = '1') then 
                Noc_Reg_out   <= Dataout_mux;
			end if;
		end if;	
	end process;
end Behavioral;
