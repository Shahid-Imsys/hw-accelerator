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
-- Title      : PCIe_Request
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : PCIe_Request.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 04.02.2021
-------------------------------------------------------------------------------
-- Description: PCIe_Request
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PCIe_Request is
  Port(
      clk               : in  std_logic;
      reset             : in  std_logic;
      Data_in           : in  std_logic_vector(1 downto 0);
      enable            : in  std_logic;
      PCIe_Request_out  : out std_logic_vector(1 downto 0)
   );
end PCIe_Request;

architecture Behavioral of PCIe_Request is

begin
	process(clk, reset)
	begin
        if reset = '1' then
            PCIe_Request_out  <= (others => '0');
        elsif rising_edge (clk) then
            if (enable = '1') then
                PCIe_Request_out  <= Data_in;
            end if;
		end if;	
	end process;

end Behavioral;