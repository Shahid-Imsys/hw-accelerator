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
-- Title      : pe1_fgenpart
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pe1_fgenpart.vhd
-- Author     : Christian Blixt
-- Company    : Imsys AB
-- Date       :
-------------------------------------------------------------------------------
-- Description:
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version   Author  Description
-- 2005-11-28		1.0				CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity pe1_fgenpart is
	port(
		s				: in	std_logic_vector(4 downto 0);
		a				: in	std_logic;
		b				: in	std_logic;
		orexp		: out	std_logic;
		andexp	: out	std_logic);
end;

architecture rtl of pe1_fgenpart is
begin
	orexp		<= not ((s(4) and a and not b) or (s(3) and not a and not b) or (s(2) and not a and b));
	andexp	<= not ((s(4) xor not a) or (s(1) and b) or (s(0) and not b));

--	process (s, a, b)
--	begin
--		case s(4 downto 2) is
--			when "000" => orexp		<= '1';
--			when "001" => orexp		<= a or not b;
--			when "010" => orexp		<= a or b;
--			when "011" => orexp		<= a;
--			when "100" => orexp		<= not a or b;
--			when "101" => orexp		<= not a xor b;
--			when "110" => orexp		<= b;
--			when "111" => orexp		<= a and b;
--			when others => orexp	<= '-';
--		end case;
--
--		case s(4) & s(1 downto 0) is
--			when "000" => andexp	<= a;
--			when "001" => andexp	<= a and b;
--			when "010" => andexp	<= a and not b;
--			when "011" => andexp	<= '0';
--			when "100" => andexp	<= not a;
--			when "101" => andexp	<= not a and b;
--			when "110" => andexp	<= not a and not b;
--			when "111" => andexp	<= '0';
--			when others => andexp	<= '-';
--		end case;
--	end process;
end;



