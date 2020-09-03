-- IO block simulation for Imsys Accelerator
-- 
-- 
-- Design: Imsys AB
-- Implemented: Bengt Andersson
-- Revision 0


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.defines.all;


entity ETH_phy is
	port (
		data_in	: in Byte; 
		data_ut	: out Byte; 
	);
end ETH_phy;



architecture struct of ETH_phy is

end struct ETH_phy;