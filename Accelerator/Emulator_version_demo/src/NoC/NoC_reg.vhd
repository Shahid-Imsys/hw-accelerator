-- NoC register Part of NoC simulation pkg
-- 
-- Design: Imsys AB
-- Implemented: Bengt Andersson
-- Revision 0

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.defines.all;


entity NoC_reg is
port (		

		NoC_reg_enable		: in std_logic;
		Clk			  		: in std_logic;
		Reg_In0				: in std_logic_vector (7 downto 0);
		Reg_In1				: in std_logic_vector (7 downto 0);
		Reg_In2				: in std_logic_vector (7 downto 0);
		Reg_In3				: in std_logic_vector (7 downto 0);
		Reg_In4				: in std_logic_vector (7 downto 0);
		Reg_In5				: in std_logic_vector (7 downto 0);
		Reg_In6				: in std_logic_vector (7 downto 0);
		Reg_In7				: in std_logic_vector (7 downto 0);
		Reg_In8				: in std_logic_vector (7 downto 0);
		Reg_In9				: in std_logic_vector (7 downto 0);
		Reg_In10			: in std_logic_vector (7 downto 0);
		Reg_In11			: in std_logic_vector (7 downto 0);
		Reg_In12			: in std_logic_vector (7 downto 0);
		Reg_In13			: in std_logic_vector (7 downto 0);
		Reg_In14			: in std_logic_vector (7 downto 0);
		Reg_In15			: in std_logic_vector (7 downto 0);
		Reg_In16			: in std_logic_vector (7 downto 0);
		Reg_In17			: in std_logic_vector (7 downto 0);
		Reg_In18			: in std_logic_vector (7 downto 0);
		Reg_In19			: in std_logic_vector (7 downto 0);
		Reg_In20			: in std_logic_vector (7 downto 0);
		Reg_In21			: in std_logic_vector (7 downto 0);
		Reg_In22			: in std_logic_vector (7 downto 0);
		Reg_In23			: in std_logic_vector (7 downto 0);
		Reg_In24			: in std_logic_vector (7 downto 0);
		Reg_In25			: in std_logic_vector (7 downto 0);
		Reg_In26			: in std_logic_vector (7 downto 0);
		Reg_In27			: in std_logic_vector (7 downto 0);
		Reg_In28			: in std_logic_vector (7 downto 0);
		Reg_In29			: in std_logic_vector (7 downto 0);
		Reg_In30			: in std_logic_vector (7 downto 0);
		Reg_In31			: in std_logic_vector (7 downto 0);
		Reg_In32			: in std_logic_vector (7 downto 0);
		Reg_In33			: in std_logic_vector (7 downto 0);
		Reg_In34			: in std_logic_vector (7 downto 0);
		Reg_In35			: in std_logic_vector (7 downto 0);
		Reg_In36			: in std_logic_vector (7 downto 0);
		Reg_In37			: in std_logic_vector (7 downto 0);
		Reg_In38			: in std_logic_vector (7 downto 0);
		Reg_In39			: in std_logic_vector (7 downto 0);
		Reg_In40			: in std_logic_vector (7 downto 0);
		Reg_In41			: in std_logic_vector (7 downto 0);
		Reg_In42			: in std_logic_vector (7 downto 0);
		Reg_In43			: in std_logic_vector (7 downto 0);
		Reg_In44			: in std_logic_vector (7 downto 0);
		Reg_In45			: in std_logic_vector (7 downto 0);
		Reg_In46			: in std_logic_vector (7 downto 0);
		Reg_In47			: in std_logic_vector (7 downto 0);
		Reg_In48			: in std_logic_vector (7 downto 0);
		Reg_In49			: in std_logic_vector (7 downto 0);
		Reg_In50			: in std_logic_vector (7 downto 0);
		Reg_In51			: in std_logic_vector (7 downto 0);
		Reg_In52			: in std_logic_vector (7 downto 0);
		Reg_In53			: in std_logic_vector (7 downto 0);
		Reg_In54			: in std_logic_vector (7 downto 0);
		Reg_In55			: in std_logic_vector (7 downto 0);
		Reg_In56			: in std_logic_vector (7 downto 0);
		Reg_In57			: in std_logic_vector (7 downto 0);
		Reg_In58			: in std_logic_vector (7 downto 0);
		Reg_In59			: in std_logic_vector (7 downto 0);
		Reg_In60			: in std_logic_vector (7 downto 0);
		Reg_In61			: in std_logic_vector (7 downto 0);
		Reg_In62			: in std_logic_vector (7 downto 0);
		Reg_In63			: in std_logic_vector (7 downto 0);
		NoC_reg_output		: out NoC_bus
	
);
end NoC_reg;


architecture struct of NoC_reg is

begin
	process(Clk)
	begin
		if rising_edge (Clk) then
			if (NoC_reg_enable = '1') then 
				NoC_reg_output[0]  <= Reg_In0;
				NoC_reg_output[1]  <= Reg_In1;
				NoC_reg_output[2]  <= Reg_In2;
				NoC_reg_output[3]  <= Reg_In3;			
				NoC_reg_output[4]  <= Reg_In4;
				NoC_reg_output[5]  <= Reg_In5;
				NoC_reg_output[6]  <= Reg_In6;
				NoC_reg_output[7]  <= Reg_In7;
				NoC_reg_output[8]  <= Reg_In8;
				NoC_reg_output[9]  <= Reg_In9;
				NoC_reg_output[10] <= Reg_In10;
				NoC_reg_output[11] <= Reg_In11;
				NoC_reg_output[12] <= Reg_In12;
				NoC_reg_output[13] <= Reg_In13;			
				NoC_reg_output[14] <= Reg_In14;
				NoC_reg_output[15] <= Reg_In15;
				NoC_reg_output[16] <= Reg_In16;
				NoC_reg_output[17] <= Reg_In17;
				NoC_reg_output[18] <= Reg_In18;
				NoC_reg_output[19] <= Reg_In19;
				NoC_reg_output[20] <= Reg_In20;
				NoC_reg_output[21] <= Reg_In21;
				NoC_reg_output[22] <= Reg_In22;
				NoC_reg_output[23] <= Reg_In23;			
				NoC_reg_output[24] <= Reg_In24;
				NoC_reg_output[25] <= Reg_In25;
				NoC_reg_output[26] <= Reg_In26;
				NoC_reg_output[27] <= Reg_In27;
				NoC_reg_output[28] <= Reg_In28;
				NoC_reg_output[29] <= Reg_In29;
				NoC_reg_output[30] <= Reg_In30;
				NoC_reg_output[31] <= Reg_In31;
				NoC_reg_output[32] <= Reg_In32;
				NoC_reg_output[33] <= Reg_In33;			
				NoC_reg_output[34] <= Reg_In34;
				NoC_reg_output[35] <= Reg_In35;
				NoC_reg_output[36] <= Reg_In36;
				NoC_reg_output[37] <= Reg_In37;
				NoC_reg_output[38] <= Reg_In38;
				NoC_reg_output[39] <= Reg_In39;
				NoC_reg_output[40] <= Reg_In40;
				NoC_reg_output[41] <= Reg_In41;
				NoC_reg_output[42] <= Reg_In42;
				NoC_reg_output[43] <= Reg_In43;			
				NoC_reg_output[44] <= Reg_In44;
				NoC_reg_output[45] <= Reg_In45;
				NoC_reg_output[46] <= Reg_In46;
				NoC_reg_output[47] <= Reg_In47;
				NoC_reg_output[48] <= Reg_In48;
				NoC_reg_output[49] <= Reg_In49;
				NoC_reg_output[50] <= Reg_In50;
				NoC_reg_output[51] <= Reg_In51;
				NoC_reg_output[52] <= Reg_In52;
				NoC_reg_output[53] <= Reg_In53;			
				NoC_reg_output[54] <= Reg_In54;
				NoC_reg_output[55] <= Reg_In55;
				NoC_reg_output[56] <= Reg_In56;
				NoC_reg_output[57] <= Reg_In57;
				NoC_reg_output[58] <= Reg_In58;
				NoC_reg_output[59] <= Reg_In59;
				NoC_reg_output[60] <= Reg_In60;									
				NoC_reg_output[61] <= Reg_In61;
				NoC_reg_output[62] <= Reg_In62;
				NoC_reg_output[63] <= Reg_In63
			end if;
		end if;	
	end process;	
end;