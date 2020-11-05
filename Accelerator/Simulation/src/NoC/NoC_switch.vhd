-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : NoC_switch
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : NoC_switch.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.04
-------------------------------------------------------------------------------
-- Description: -- NoC switch Part of NoC simulation pkg
-- Switch settings:
-- 000   no switch
-- 001   broadcast
-- 010   shift 1 byte left
-- 011   shift 1 byte right
-- 100   shift 4 byte left	
-- 101   shift 8 bytes left
-- 110   shift 4 byte right	
-- 111   shift 8 byte right             
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-8-21  		     1.0	     CJ			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.defines.all;


entity switch is
begin

port (
		switch_In 		: in	NoC_bus;
		switch_Out_en   : in    std_logic;
		decoder         : in	std_logic_vector(63 downto 0);
		switch_mux		: in	std_logic_vector(3 downto 0);
		switch_Out 		: out	NoC_bus
	);
end;


architecture struct of switch is
begin

	switch_bus	: std_logic_vector(7 downto 0);
	max_out     : NoC_bus;

	process switch_bus_driver(decoder,switch_In)
		begin
		for i in 0 to 63 loop
			if decoder(i) ='1' then
				switch_bus <= switch_In(i);
			end if;
		end loop;
	end process;

	process mux(switch_mux,switch_bus,switch_In)
	begin
		for i in 0 to 63 loop
			if switch_mux = "000" then
				mux_out[i] <= switch_In(i);
			elsif switch_mux = "001" then
				mux_out[i] <= switch_bus; ------------------------if it is changing at the same time it may be unstabel??
			elsif switch_mux = "010" then
				if (i > 0) then
					mux_out[i] <= switch_In(i-1);
				else
					mux_out[i] <=(others => '0');
				end;
			elsif switch_mux = "011" then
				if (i < 63) then
					mux_out[i] <= switch_In(i+1);
				else
					mux_out[i] <=(others => '0');
				end;
			elsif switch_mux = "100" then
				if (i > 4) then
					mux_out[i] <= switch_In(i-4);
				else
					mux_out[i] <=(others => '0');
				end;
			elsif switch_mux = "101" then
				if (i > 8) then
					mux_out[i] <= switch_In(i-8);
				else
					mux_out[i] <=(others => '0');
				end;
			elsif switch_mux = "110" then
				if (i < 60) then
					mux_out[i] <= switch_In(i+4);
				else
					mux_out[i] <=(others => '0');
				end;
			elsif switch_mux = "111" then
				if (i < 56) then
					mux_out[i] <= switch_In(i+8);
				else
					mux_out[i] <=(others => '0');
				end;		
			end if;	
		end;
	end;

	if (switch_Out_en = '1') then 
		switch_Out <= mux_out;
	end if;	

end;