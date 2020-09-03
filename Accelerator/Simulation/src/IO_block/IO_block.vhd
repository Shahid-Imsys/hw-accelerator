-- IO block simulation for Imsys Accelerator
-- 
-- Top file
-- Design: Imsys AB
-- Implemented: Bengt Andersson
-- Revision 0


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.defines.all;


entity IO_block is
	port (
		data_port	: inout NoC_bus; 
	);
end IO_block;




architecture struct of IO_block is

	signal internal_bus	: NoC_bus;


 component DDR_phy
    port (
		data_in	: in Byte; 
		data_ut	: out Byte 
);
  end component;  

 component ETH_phy
    port (
		data_in	: in Byte; 
		data_ut	: out Byte 
);
  end component;  

 component PCIe_phy
    port (
		data_in	: in Byte; 
		data_ut	: out Byte 
);
  end component;  

 component USB3_phy
    port (
		data_in	: in Byte; 
		data_ut	: out Byte 
);
  end component;  

qwassssssssss                                            wq
begin -- RTL

end struct IO_block;