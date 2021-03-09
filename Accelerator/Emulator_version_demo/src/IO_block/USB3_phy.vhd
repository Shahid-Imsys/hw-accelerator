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


entity USB3_phy is
	port (
		data_in	: in Byte; 
		data_ut	: out Byte; 
	);
end USB3_phy;



architecture struct of USB3_phy is

end struct USB3_phy;