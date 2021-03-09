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
-- Title      : fgendec
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : fgendec.vhd
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
use work.mpgmfield_lib.all;

entity fgendec is
  port(
		pl_aluf	: in	std_logic_vector(2 downto 0);
		s				: out	std_logic_vector(4 downto 0);
		mn			: out	std_logic);
end;

architecture rtl of fgendec is
begin
	process (pl_aluf)
	begin
		case pl_aluf is
			when ALUF_S_PLUS_RE =>
				s				<= "01001";
				mn			<= '0';
			when ALUF_S_MINUS_RE =>
				s				<= "10001";
				mn			<= '0';
			when ALUF_RE_MINUS_S =>
				s				<= "00110";
				mn			<= '0';
			when ALUF_S_OR_RE =>
				s				<= "01011";
				mn			<= '1';
			when ALUF_S_AND_RE =>
				s				<= "01110";
				mn			<= '1';
			when ALUF_S_ANDNOT_RE =>
				s				<= "01000";
				mn			<= '1';
			when ALUF_S_XOR_RE =>
				s				<= "01001";
				mn			<= '1';
			when ALUF_S_XNOR_RE =>
				s				<= "00110";
				mn			<= '1';
			when others => null;
		end case;
	end process;
end;



