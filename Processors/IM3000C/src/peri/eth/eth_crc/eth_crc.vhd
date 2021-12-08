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
-- Title      : Ethernet CRC generator/checker
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : eth_crc.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2006-01-12		1.0				CB			Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity eth_crc is
	port (
		clk			: in	std_logic;
		clken		: in	std_logic;
		rst			: in	std_logic;	-- Active high
		enable	: in	std_logic;	-- Active high
		data		: in	std_logic_vector(3 downto 0);
		crc			: out	std_logic_vector(31 downto 0));
end entity eth_crc;

architecture structure of eth_crc is
	signal x	: std_logic_vector(3 downto 0);
	signal c	: std_logic_vector(31 downto 0);

begin
	-- XOR the input data with the top nibble of the current CRC.
	x <= c(31 downto 28) xor data;

	-- CRC register.
	process (clk, rst)
	begin
		if rst = '1' then  
			c <= (others => '1');
		elsif rising_edge(clk) then
			if clken = '1' then
				if enable = '1' then
					c <=	(c(27) xor x(1)) &
								(c(26) xor x(0)) &
								c(25) &
								c(24) &
								(c(23) xor x(2) xor x(1)) &
								(c(22) xor x(1) xor x(0)) &
								(c(21) xor x(3) xor x(0)) &
								(c(20) xor x(2)) &
								c(19) &
								c(18) &
								(c(17) xor x(3)) &
								(c(16) xor x(3) xor x(2)) &
								(c(15) xor x(3)) &
								(c(14) xor x(2)) &
								(c(13) xor x(1)) &
								(c(12) xor x(0)) &             
								(c(11) xor x(1) xor x(2) xor x(3)) &
								(c(10) xor x(0) xor x(1) xor x(2)) &
								(c(9) xor x(1) xor x(0)) &
								(c(8) xor x(0)) &
								(c(7) xor x(0) xor x(2) xor x(3)) &
								(c(6) xor x(2) xor x(1)) &
								(c(5) xor x(0) xor x(1) xor x(3)) &
								(c(4) xor x(0) xor x(2) xor x(3)) &
								(c(3) xor x(0) xor x(1) xor x(3)) &
								(c(2) xor x(0) xor x(2) xor x(3)) &
								(c(1) xor x(2) xor x(1)) &
								(c(0) xor x(0) xor x(1) xor x(3)) &
								x(3) &
								(x(3) xor x(2)) &
								(x(1) xor x(2) xor x(3)) &
								(x(0) xor x(1) xor x(2));
				end if;
			end if;
		end if;
	end process;

	-- CRC output.
	crc <= c;

end architecture structure;
		
