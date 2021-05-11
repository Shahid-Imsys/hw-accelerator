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
-- Title      : mdr
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : mdr.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Memory Data Register
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2021-3-19  		     1.0	     CJ			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--use work.defines.all;

entity mdr is
port(
--Hand shake
EXE   : IN STD_LOGIC;
CLK_E : IN STD_LOGIC;
DIN_EN : IN STD_LOGIC;
--pe
DTM_ENA  : IN STD_LOGIC;
--Data to memory (DTM)
DTM   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
DDQ_O : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--Data from memory (DFM)
DDQ_I : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
DIN_VLD : OUT STD_LOGIC;
);
end entity;

architecture rtl of mdr is
	signal dtm_reg                : std_logic_vector(31 downto 0);
	signal dfm_reg                : std_logic_vector(127 downto 0);
	signal init_mpgm          : std_logic_vector(31 downto 0);
	signal exe_i              : std_logic;
	--signal data_vld           : std_logic;
begin
-----------------------------------------------------------
--DTM
-----------------------------------------------------------
	init_mpgm <= "01000000000000000000111110111111" --load 32 words from CM address 0
	DTM <= dtm_reg;
	DIN_VLD <= din_en;

data_uploading: process(clk_e,exe)
begin 
	if rising_edge(clk_e) then
		if EXE = '1' then
			dtm_reg <= init_mpgm;
		elsif dtm_ena = '1' then
            dtm_reg <= DDQ_O;
		else 
			dtm_reg <= null;
		end if;
	end if;
end process;

------------------------------------------------------------
--DFM
------------------------------------------------------------

data_downloading : process(clk_e)
begin
	if rising_edge(clk_e) then
		if din_en = '1' then
			dfm_reg <= DDQ_I;
		else
			dfm_reg <= null;
		end if;
	end if;
end process;
