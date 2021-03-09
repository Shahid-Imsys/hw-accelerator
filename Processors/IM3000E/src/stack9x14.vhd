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
-- Title      : stack9x14
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : stack9x14.vhd
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
-- 2005-11-28		1.0 			CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity stack9x14 is
	port(
	    rst_en          : in std_logic;
	    clk_p           : in std_logic;
		clk_e_pos				: in	std_logic;											-- Clock input
		stack_ctr		: in	std_logic_vector(4 downto 0); 	-- Stack counter
		stack_we_n	: in	std_logic;											-- Write enable (act low)
		stack_empty	: out	std_logic;											-- Stack empty (act high)
		stack_full	: out	std_logic;											-- Stack full (act high)
		stack_in		: in	std_logic_vector(13 downto 0);	-- Stack data input
		stack_out		: out std_logic_vector(13 downto 0));	-- Stack data output
end;

-------------------------------------------------------------------------------
-- Latch based solution. Use this when the smallest, leanest ASIC
-- implementation is desired. Requires some special timing constraints to work
-- well.
-------------------------------------------------------------------------------
architecture latch_based of stack9x14 is
	type mem_type is array (8 downto 0) of std_logic_vector(13 downto 0);

	signal stack 		: mem_type;    
--	signal stack_en	: mem_type;    
	signal word_sel : std_logic_vector(9 downto 0);
	signal decode_n : std_logic_vector(8 downto 0);

	attribute syn_keep : boolean;
	attribute syn_keep of decode_n : signal is true;

begin
	-- Word select line decode. Decodes the incoming stack
	-- counter into one active high word_sel line for each
	-- stack word.
	word_sel(0) <= '1' when stack_ctr(4) = '1' and stack_ctr(0) = '1' else '0';
	word_sel(1) <= '1' when stack_ctr(1) = '1' and stack_ctr(0) = '0' else '0';
	word_sel(2) <= '1' when stack_ctr(2) = '1' and stack_ctr(1) = '0' else '0';
	word_sel(3) <= '1' when stack_ctr(3) = '1' and stack_ctr(2) = '0' else '0';
	word_sel(4) <= '1' when stack_ctr(4) = '1' and stack_ctr(3) = '0' else '0';
	word_sel(5) <= '1' when stack_ctr(4) = '0' and stack_ctr(0) = '0' else '0';
	word_sel(6) <= '1' when stack_ctr(1) = '0' and stack_ctr(0) = '1' else '0';
	word_sel(7) <= '1' when stack_ctr(2) = '0' and stack_ctr(1) = '1' else '0';
	word_sel(8) <= '1' when stack_ctr(3) = '0' and stack_ctr(2) = '1' else '0';
	word_sel(9) <= '1' when stack_ctr(4) = '0' and stack_ctr(3) = '1' else '0';

	-- Stack empty and full outputs, high when stack_ctr
	-- points to the first or last stack word, respectively.  
	stack_empty	<= word_sel(0);
	stack_full	<= word_sel(9);
	
	-- This process handles write operations. When stack_we_n
	-- is low, the fourteen-bit latch word whose corresponding
	-- word_sel line is high is open during the clock's low
	-- (second) phase to let the input data on the stack_in
	-- bus in. When word_sel(9) is set, that is the stack is
	-- full, no stack word will be written.
	-- The decode_n vector is syn_keeped to make the clock
	-- enter the latch gate logic at the latest possible
	-- level, to avoid data hold time problems.
	-- stack_ctr is guaranteed to be stable during the low
	-- clock phase.
	process (clk_e_pos, stack_we_n, word_sel, stack_in, decode_n)
	begin
		for i in 0 to 8 loop
			if stack_we_n = '0' and word_sel(i) = '1' then
				decode_n(i) <= '0';
			else
				decode_n(i) <= '1';
			end if;
			if clk_e_pos = '0' and decode_n(i) = '0' then
				stack(i) <= stack_in;  
			end if;
		end loop;
	end process;

	-- This process creates the output mux. The stack word
	-- that was last written is output, that is the one
	-- "below" the word currently selected by word_sel (because
	-- the stack counter has been incremented after the last
	-- write). If the stack is empty (word_sel(0) active),
	-- stack word 0 is output.
	process (word_sel, stack)
	begin
		stack_out <= stack(0);
		for i in 0 to 8 loop
			if word_sel(i+1) = '1' then
				stack_out <= stack(i);
			end if;
		end loop;
	end process;
--	process (word_sel, stack)
--	begin
--		for i in 0 to 8 loop
--			if word_sel(i+1) = '1' then
--				stack_en(i) <= stack(i);
--			else
--				stack_en(i) <= (others => '0');
--			end if;
--		end loop;
--		if word_sel(0) = '1' then
--			stack_en(0) <= stack(0);
--		end if;
--	end process;
--	stack_out <= stack_en(0) or stack_en(1) or stack_en(2) or stack_en(3) or stack_en(4) or stack_en(5) or stack_en(6) or stack_en(7) or stack_en(8);
end;

-------------------------------------------------------------------------------
-- Register based solution. Use this for FPGA or for a truble-free ASIC
-- implementation. Bigger and comsumes more power than the latch-based
-- solution.
-------------------------------------------------------------------------------
architecture register_based of stack9x14 is
	type mem_type is array (8 downto 0) of std_logic_vector(13 downto 0);

	signal stack 		: mem_type;    
	signal word_sel : std_logic_vector(9 downto 0);

begin
	-- Word select line decode. Decodes the incoming stack
	-- counter into one active high word_sel line for each
	-- stack word.
	word_sel(0) <= '1' when stack_ctr(4) = '1' and stack_ctr(0) = '1' else '0';
	word_sel(1) <= '1' when stack_ctr(1) = '1' and stack_ctr(0) = '0' else '0';
	word_sel(2) <= '1' when stack_ctr(2) = '1' and stack_ctr(1) = '0' else '0';
	word_sel(3) <= '1' when stack_ctr(3) = '1' and stack_ctr(2) = '0' else '0';
	word_sel(4) <= '1' when stack_ctr(4) = '1' and stack_ctr(3) = '0' else '0';
	word_sel(5) <= '1' when stack_ctr(4) = '0' and stack_ctr(0) = '0' else '0';
	word_sel(6) <= '1' when stack_ctr(1) = '0' and stack_ctr(0) = '1' else '0';
	word_sel(7) <= '1' when stack_ctr(2) = '0' and stack_ctr(1) = '1' else '0';
	word_sel(8) <= '1' when stack_ctr(3) = '0' and stack_ctr(2) = '1' else '0';
	word_sel(9) <= '1' when stack_ctr(4) = '0' and stack_ctr(3) = '1' else '0';

	-- Stack empty and full outputs, high when stack_ctr
	-- points to the first or last stack word, respectively.  
	stack_empty	<= word_sel(0);
	stack_full	<= word_sel(9);
	
	-- This process handles write operations. When stack_we_n
	-- is low, the fourteen-bit register word whose corresponding
	-- word_sel line is high is written with the input data on
	-- the stack_in bus on the rising clock edge.
	process (clk_p)
	begin
		if rising_edge(clk_p) then	-- Clocking outside loop, Magma fix
			for i in 0 to 8 loop
			    if rst_en = '0' then
			        stack(i) <= (others => '0');
				elsif stack_we_n = '0' and word_sel(i) = '1' and clk_e_pos = '0' then
					stack(i) <= stack_in;  
				end if;
			end loop;
		end if;
	end process;

	-- This process creates the output mux. The stack word
	-- that was last written is output, that is the one
	-- "below" the word currently selected by word_sel (because
	-- the stack counter has been incremented after the last
	-- write). If the stack is empty (word_sel(0) active),
	-- stack word 0 is output.
	process (word_sel, stack)
	begin
		stack_out <= stack(0);
		for i in 0 to 8 loop
			if word_sel(i+1) = '1' then
				stack_out <= stack(i);
			end if;
		end loop;
	end process;
end;

