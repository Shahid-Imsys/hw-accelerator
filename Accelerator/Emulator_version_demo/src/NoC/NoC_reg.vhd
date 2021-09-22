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
-- Title      : Noc_Reg
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Noc_Reg.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 28.01.2021
-------------------------------------------------------------------------------
-- Description: NOC register
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-24 		     1.0	     AK			Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.ACC_types.all;


entity Noc_Reg is
port (		
		clk			  		: in  std_logic;
		reset               : in  std_logic;
		Load_NOC_reg        : in  std_logic;		
		Data_input          : in  std_logic_vector(255 downto 0);
		Data_output         : out std_logic_vector(255 downto 0)	
);
end Noc_Reg;


architecture struct of NoC_reg is

begin

	process(Clk, reset)
	begin
                if reset = '1' then
                  Data_output   <= (others => '0');	
		elsif rising_edge (Clk) then
                  if (Load_NOC_reg = '1') then 
                    Data_output   <= Data_input;
                  end if;
		end if;	
	end process;	
	
end;
