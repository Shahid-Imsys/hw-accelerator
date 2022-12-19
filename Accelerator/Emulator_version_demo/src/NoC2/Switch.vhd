----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 05.04.2022 15:33:35
-- Design Name: 
-- Module Name: Switch - Behavioral
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
use work.Acc_types_pkg.all;

entity Switch is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        switch_Input            : in  std_logic_vector(127 downto 0);
        Decoder                 : in  std_logic_vector(15 downto 0);
        switch_input_muxes      : in  std_logic_vector(2 downto 0);
        switch_Noc_bus_mux      : in  std_logic;
        EN_Noc_byte_data        : in  std_logic;
        Noc_byte_data           : out std_logic_vector(127 downto 0);
        switch_out              : out std_logic_vector(127 downto 0)    
    );        
end Switch;

architecture Behavioral of Switch is

	signal switch_mux_In   : switch_data_type;
	signal switch_bus	   : std_logic_vector(7 downto 0):= (others => '0');
	signal mux_m           : switch_data_type;
	
begin

    switch_mux_In(0)    <= switch_Input(7 downto 0);
    switch_mux_In(1)    <= switch_Input(15 downto 8);
    switch_mux_In(2)    <= switch_Input(23 downto 16);
    switch_mux_In(3)    <= switch_Input(31 downto 24);
    switch_mux_In(4)    <= switch_Input(39 downto 32);
    switch_mux_In(5)    <= switch_Input(47 downto 40);
    switch_mux_In(6)    <= switch_Input(55 downto 48);
    switch_mux_In(7)    <= switch_Input(63 downto 56);
    switch_mux_In(8)    <= switch_Input(71 downto 64);
    switch_mux_In(9)    <= switch_Input(79 downto 72);
    switch_mux_In(10)   <= switch_Input(87 downto 80);
    switch_mux_In(11)   <= switch_Input(95 downto 88);
    switch_mux_In(12)   <= switch_Input(103 downto 96);
    switch_mux_In(13)   <= switch_Input(111 downto 104);
    switch_mux_In(14)   <= switch_Input(119 downto 112);
    switch_mux_In(15)   <= switch_Input(127 downto 120);

	process (Decoder,switch_mux_In)
    begin
		for i in 0 to 15 loop
			if Decoder(i) ='1' then
				switch_bus <= switch_mux_In(i);
--			else 
--			 	switch_bus <= (others => '0');  --for removing inferring latch
			end if;
		end loop;
	end process;
	
	process (switch_mux_In,switch_input_muxes)
    begin
		for i in 0 to 15 loop
			if switch_input_muxes(0) ='0' then
	           mux_m(i)    <= switch_mux_In(i);
	        else
	           mux_m(i)    <= (others => '0');   --later will be mux_f when we add fringe management
			end if;
		end loop;
	end process;
	
	Noc_byte_data     <= switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus & switch_bus when (switch_Noc_bus_mux = '1' and EN_Noc_byte_data = '1') else
	                  mux_m(15) & mux_m(14) & mux_m(13) & mux_m(12) & mux_m(11) & mux_m(10) & mux_m(9) & mux_m(8) & mux_m(7) & mux_m(6) & mux_m(5) & mux_m(4) & mux_m(3) & mux_m(2) & mux_m(1) & mux_m(0) when EN_Noc_byte_data = '1'
	                  else (others => '0');
    switch_out     <= switch_mux_In(15) & switch_mux_In(14) & switch_mux_In(13) & switch_mux_In(12) & switch_mux_In(11) & switch_mux_In(10) & switch_mux_In(9) & switch_mux_In(8) & switch_mux_In(7) & switch_mux_In(6) & switch_mux_In(5) & switch_mux_In(4) & switch_mux_In(3) & switch_mux_In(2) & switch_mux_In(1) & switch_mux_In(0);
end Behavioral;