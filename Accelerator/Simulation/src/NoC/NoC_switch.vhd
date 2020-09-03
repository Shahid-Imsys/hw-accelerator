-- NoC switch Part of NoC simulation pkg
-- 
-- Design: Imsys AB
-- Implemented: Bengt Andersson
-- Revision 0
--
-- Switch settings:
-- 0000   no switch
-- 0001   broadcast
-- 0010   shift 1 byte left
-- 0011   shift 4 bytes left (16 x 4 regions)
-- 0100   shift 8 bytes left (8 x 8 regions)
-- 0101   interchange with byte +1
-- 0110   interchange with byte +2
-- 0111   interchange with byte +4
-- 1000   interchange with byte +8
-- 1001   interchange with byte +16
-- 1010   interchange with byte +32




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.defines.all;


entity switch is
begin

port (
		enable	: in std_logic;

	);
end;


architecture struct of switch is
begin

	process low_mux()
	
	end low_mux;


	process mid_mux()
	
	end low_mux;


	process high_mux()
	
	end low_mux;
end struct switch;