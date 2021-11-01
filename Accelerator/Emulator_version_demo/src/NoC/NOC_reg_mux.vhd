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
-- Title      : NOC_reg_mux
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : NOC_reg_mux.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 04.02.2021
-------------------------------------------------------------------------------
-- Description: Multiplexes different inputs to the NOC register
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-24 		     1.0	     AK			Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity NOC_reg_mux is
  Port(
      clk               : in  std_logic;
      reset             : in  std_logic;
      select_mux        : in  std_logic_vector(1 downto 0);
      Input_reg_data    : in  std_logic_vector(15 downto 0);
      Root_Memory_data  : in  std_logic_vector(15 downto 0);
      Mux_Demux_data    : in  std_logic_vector(255 downto 0);
      Dataout_mux       : out std_logic_vector(255 downto 0)
  );
end NOC_reg_mux;

architecture Behavioral of NOC_reg_mux is

begin
	process (select_mux,Input_reg_data,Root_Memory_data,Mux_Demux_data,reset)
	begin
        if reset = '1' then
	        Dataout_mux     <= ( others => '0');
	    elsif select_mux = "00" then
            Dataout_mux     <= x"000000000000000000000000000000000000000000000000000000000000" & Input_reg_data;
        elsif  select_mux = "01" then
            Dataout_mux     <= x"000000000000000000000000000000000000000000000000000000000000" & Root_Memory_data;
        elsif  select_mux = "11" then
            Dataout_mux     <= Mux_Demux_data;
        else     
            Dataout_mux     <= ( others => '0');
        end if;
    end process;        

end Behavioral;