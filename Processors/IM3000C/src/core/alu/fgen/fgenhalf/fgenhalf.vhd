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
-- Title      : fgenhalf
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : fgenhalf.vhd
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

entity fgenhalf is
  port(
    s				: in	std_logic_vector(4 downto 0);
    mn			: in	std_logic;
    cn			: in	std_logic;
    a				: in	std_logic_vector(3 downto 0);
    b				: in	std_logic_vector(3 downto 0);
    cn3			: out std_logic;
    cn4			: out std_logic;
    f				: out	std_logic_vector(3 downto 0));
end;

architecture rtl of fgenhalf is
	signal orexp	: std_logic_vector(3 downto 0);
	signal andexp	: std_logic_vector(3 downto 0);
	signal ariexp	: std_logic_vector(4 downto 0);

begin
	fgenpart0 : entity work.fgenpart
		port map (
			s				=> s,
			a				=> a(0),
			b				=> b(0),
			orexp		=> orexp(0),
			andexp	=> andexp(0));

	fgenpart1 : entity work.fgenpart
		port map (
			s				=> s,
			a				=> a(1),
			b				=> b(1),
			orexp		=> orexp(1),
			andexp	=> andexp(1));

	fgenpart2 : entity work.fgenpart
		port map (
			s				=> s,
			a				=> a(2),
			b				=> b(2),
			orexp		=> orexp(2),
			andexp	=> andexp(2));

	fgenpart3 : entity work.fgenpart
		port map (
			s				=> s,
			a				=> a(3),
			b				=> b(3),
			orexp		=> orexp(3),
			andexp	=> andexp(3));
			
	ariexp(0) <= not cn;
	ariexp(1) <= not andexp(0) and
							 not (orexp(0) and cn);
	ariexp(2) <= not andexp(1) and
							 not (orexp(1) and andexp(0)) and
							 not (orexp(0) and orexp(1) and cn);
	ariexp(3) <= not andexp(2) and
							 not (orexp(2) and andexp(1)) and
							 not (orexp(1) and orexp(2) and andexp(0)) and
							 not (orexp(0) and orexp(1) and orexp(2) and cn);
	ariexp(4) <= not andexp(3) and
							 not (orexp(3) and andexp(2)) and
							 not (orexp(2) and orexp(3) and andexp(1)) and
							 not (orexp(1) and orexp(2) and orexp(3) and andexp(0)) and
							 not (orexp(0) and orexp(1) and orexp(2) and orexp(3) and cn);

	f(0) <= (orexp(0) xor andexp(0)) xnor (mn or ariexp(0));
	f(1) <= (orexp(1) xor andexp(1)) xnor (mn or ariexp(1));
	f(2) <= (orexp(2) xor andexp(2)) xnor (mn or ariexp(2));
	f(3) <= (orexp(3) xor andexp(3)) xnor (mn or ariexp(3));

	cn3 <= not ariexp(3);
	cn4 <= not ariexp(4);
end;



