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
-- Title      : ram32x8
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : ram32x8.vhd
-- Author     : Christian Blixt
-- Company    : Imsys AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
-- 32 x 8 dual-port RAM.
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
use ieee.std_logic_unsigned.all;

entity ram32x8 is
	port(
		clk_e			: in	std_logic;											-- Clock input
		pl_aaddr	: in	std_logic_vector(4 downto 0); 	-- Read address A
		pl_baddr	: in	std_logic_vector(4 downto 0); 	-- Read/write address B
		we_n			: in	std_logic;											-- Write enable (active low)
		b_in			: in	std_logic_vector(7 downto 0);		-- Data input B
		a_out			: out std_logic_vector(7 downto 0);		-- Data output A
		b_out			: out std_logic_vector(7 downto 0));	-- Data output B
end;

-------------------------------------------------------------------------------
-- Latch based solution. Use this when the smallest, leanest ASIC
-- implementation is desired. Requires some special timing constraints to work
-- well.
-------------------------------------------------------------------------------
architecture latch_based of ram32x8 is
	type mem_type is array (31 downto 0) of std_logic_vector(7 downto 0);

	signal ram 			: mem_type;    
	signal decode_n : std_logic_vector(31 downto 0);

	attribute syn_keep : boolean;
	attribute syn_keep of decode_n : signal is true;

begin
	-- This process handles write operations. When we_n is
	-- low, the eight-bit latch word pointed to by pl_baddr
	-- is open during the clock's low (second) phase to let
	-- the input data on the b_in bus in.
	-- The decode_n vector is syn_keeped to make the clock
	-- enter the latch gate logic at the latest possible
	-- level, to avoid data hold time problems.
	-- Both pl_baddr  and we_n are guaranteed to be stable
	-- during the low clock phase, but b_in can change up
	-- to a set-up time before the latches close.
	process (clk_e, we_n, pl_baddr, b_in, decode_n)
	begin
		for i in 0 to 31 loop
			if we_n = '0' and pl_baddr = i then 
				decode_n(i) <= '0';
			else
				decode_n(i) <= '1';
			end if;
			if clk_e = '0' and decode_n(i) = '0' then
				ram(i) <= b_in;  
			end if;
		end loop;
	end process;

	-- This process creates the output latches. Every cycle
	-- is a read operation on both output buses, so these
	-- latches are open whenever the clock is in its high
	-- (first) phase. The purpose of the latches is solely
	-- to keep the outputs unchanged when the corresponding
	-- RAM word is written to, they are open when the
	-- addresses change so their propagation delay should
	-- be added to the address decode and mux delay to form
	-- the access time (clock to output) of the RAM.
	process (clk_e, pl_aaddr, pl_baddr, ram)
	begin
		if clk_e = '1'  then
			a_out <= ram(conv_integer(pl_aaddr));
			b_out <= ram(conv_integer(pl_baddr));
		end if;
	end process;
end latch_based;

-------------------------------------------------------------------------------
-- Register based solution. Use this for FPGA or for a trouble-free ASIC
-- implementation. Bigger and comsumes more power than the latch-based
-- solution.
-------------------------------------------------------------------------------
architecture register_based of ram32x8 is
	type mem_type is array (31 downto 0) of std_logic_vector(7 downto 0);
	signal ram 			: mem_type;    

begin
	-- This process handles write operations. When we_n is
	-- low, the eight-bit register word pointed to by pl_baddr
	-- is written with the input data on the b_in bus on
	-- the rising clock edge.
	process (clk_e)
	begin
		if rising_edge(clk_e) then
			if we_n = '0' then
				ram(conv_integer(pl_baddr)) <= b_in;  
			end if;
		end if;
	end process;

	-- Read data is asynchronously output at both output buses.
	a_out <= ram(conv_integer(pl_aaddr));
	b_out <= ram(conv_integer(pl_baddr));
end register_based;



