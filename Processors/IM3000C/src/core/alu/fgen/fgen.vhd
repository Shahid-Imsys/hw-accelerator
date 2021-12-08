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
-- Title      : fgen
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : fgen.vhd
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
-- Date         Version   Author  Description
-- 2005-11-28		1.0				CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity fgen is
  port(
		-- Microprogram fields
		pl_aluf	: in	std_logic_vector(2 downto 0); --uProg word field
		-- Flags
		cn			: in	std_logic;
		cn8			: out	std_logic;
		cn4			: out	std_logic;
		ovr			: out	std_logic;
		eq			: out	std_logic;
		odd			: out	std_logic;
		--Data inputs
		re			: in	std_logic_vector(7 downto 0);
		s				: in	std_logic_vector(7 downto 0);
		--Data output
		f				: out	std_logic_vector(7 downto 0));
end;

architecture rtl of fgen is
	signal func_s 	: std_logic_vector(4 downto 0);
	signal mn				: std_logic;
	signal cn4_int	: std_logic;
	signal cn7_int	: std_logic;
	signal cn8_int	: std_logic;
	signal f_int 		: std_logic_vector(7 downto 0);
	
begin
	fgendec0 : entity work.fgendec
		port map (
			pl_aluf	=> pl_aluf,
			s				=> func_s,
			mn			=> mn);

	fgenhalf0 : entity work.fgenhalf
		port map (
			s				=> func_s,
			mn			=> mn,
			cn			=> cn,
			a				=> re(3 downto 0),
			b				=> s(3 downto 0),
			cn3			=> open,
			cn4			=> cn4_int,
			f				=> f_int(3 downto 0));

	fgenhalf1 : entity work.fgenhalf
		port map (
			s				=> func_s,
			mn			=> mn,
			cn			=> cn4_int,
			a				=> re(7 downto 4),
			b				=> s(7 downto 4),
			cn3			=> cn7_int,
			cn4			=> cn8_int,
			f				=> f_int(7 downto 4));
			
	ovr	<= cn7_int xor cn8_int;
	eq	<= not (f_int(7) or f_int(6) or f_int(5) or f_int(4) or
							f_int(3) or f_int(2) or f_int(1) or f_int(0));
	odd	<= f_int(7) xor f_int(6) xor f_int(5) xor f_int(4) xor
				 f_int(3) xor f_int(2) xor f_int(1) xor f_int(0);

	cn4	<= cn4_int;
	cn8	<= cn8_int;
	f		<= f_int;	
end;



