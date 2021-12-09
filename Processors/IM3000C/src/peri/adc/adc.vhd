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
-- Title      : ADC digital part
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : adc.vhd
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
-- 2005-01-14		1.0				CB			Created
-- 2006-03-08		1.1 			CB			Removed the feedback flipflop.
-- 2006-03-09		1.2 			CB			Added sync flipflop, removed divide clk_a by
--																four, added post processing (sum, diff2,
--																diff3, output).
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.gp_pkg.all;

entity adc is
	port (
		clk_a			: in	std_logic;
		rst_n			: in	std_logic;
		adc_prec	: in	std_logic;
		adc_run		: in	std_logic;
		adc_mode	: in	std_logic_vector(1 downto 0);
		adc_bits	: in	std_logic;
		adc_done	: out	std_logic;
		adc_data	: out	std_logic_vector(15 downto 0));
end entity adc;

architecture structure of adc is
  constant ADC_N	: integer := 7;	-- Max precision

	signal ff				: std_logic;
	signal cyc_ctr	: std_logic_vector(ADC_N-1 downto 0);
	signal clk_en		: std_logic;
	signal en_ctr		: std_logic_vector(1 downto 0);
	signal adc_done_int	: std_logic;
	signal acc1_in	: std_logic_vector(3*ADC_N-1 downto 0);
	signal acc2_in	: std_logic_vector(3*ADC_N-1 downto 0);
	signal acc3_in	: std_logic_vector(3*ADC_N-1 downto 0);
	signal acc1			: std_logic_vector(3*ADC_N-1 downto 0);
	signal acc2			: std_logic_vector(3*ADC_N-1 downto 0);
	signal acc3			: std_logic_vector(3*ADC_N-1 downto 0);
	signal sum			: std_logic_vector(3*ADC_N-1 downto 0);
	signal diff2		: std_logic_vector(3*ADC_N-1 downto 0);
	signal diff3		: std_logic_vector(3*ADC_N-1 downto 0);

begin
	-- Synchronizing flipflop. The adc_bits input might be metastable.
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			ff <= '0';
		elsif rising_edge(clk_a) then
			ff <= adc_bits;
		end if;
	end process;

	-- Cycle counter.
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			cyc_ctr <= (others => '0');
		elsif rising_edge(clk_a) then
			if adc_run = '0' then
				cyc_ctr <= (others => '0');
			else
				cyc_ctr <= cyc_ctr + 1;
			end if;
		end if;
	end process;

	-- Clock enable (clk_en). Active (high) once per 2**ADC_N cycles of clk_a
	-- if adc_prec is set, otherwise once per 2**(ADC_N-1) cycles
	process (cyc_ctr, adc_prec)
	begin 
		clk_en <= '1';
		for i in 0 to ADC_N-2 loop
			if cyc_ctr(i) = '0' then
				clk_en <= '0';
			end if;
		end loop;
		if adc_prec = '1' and cyc_ctr(ADC_N-1) = '0' then
			clk_en <= '0';
		end if;
	end process;

	-- Clock enable counter.
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			en_ctr <= "00";
		elsif rising_edge(clk_a) then
			if adc_run = '0' then
				en_ctr <= "00";
			elsif clk_en = '1' then
				en_ctr <= en_ctr + 1;
			end if;
		end if;
	end process;

	-- Sample done (adc_done). Active (high) on every fourth, every
	-- second, or all clk_en pulses depending on mode.
	process (clk_en, adc_mode, en_ctr)
	begin 
		adc_done_int <= '0';
		if clk_en = '1' then
			if adc_mode = "11" then
				adc_done_int <= '1';
			elsif adc_mode(1) = '1' and en_ctr(0) = '1' then
				adc_done_int <= '1';
			elsif en_ctr = "11" then
				adc_done_int <= '1';
			end if;
		end if;
	end process;

	-- Accumulator 1. Accumulates on every cycle, never resets.
	acc1_in <= acc1 + ff when adc_prec = '1' else
						 acc1 + (ff & "000");
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			acc1 <= (others => '0');
		elsif rising_edge(clk_a) then
			acc1 <= acc1_in;
		end if;
	end process;

	-- Accumulator 2. Accumulates on every cycle, never resets.
	acc2_in <= acc2 + acc1_in;
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			acc2 <= (others => '0');
		elsif rising_edge(clk_a) then
			acc2 <= acc2_in;
		end if;
	end process;

	-- Accumulator 3. Accumulates on every cycle, resets on clk_en.
	acc3_in <= acc3 + acc2_in;
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			acc3 <= (others => '0');
		elsif rising_edge(clk_a) then
			if clk_en = '1' or adc_run = '0' then
				acc3 <= (others => '0');
			else
				acc3 <= acc3_in;
			end if;
		end if;
	end process;

	-- Sum register. Loaded on clk_en.
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			sum <= (others => '0');
		elsif rising_edge(clk_a) then
			if clk_en = '1' then
				sum <= acc3_in;
			end if;
		end if;
	end process;

	-- Diff 2 register. Loaded on clk_en. Stores the previous sum value.
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			diff2 <= (others => '0');
		elsif rising_edge(clk_a) then
			if clk_en = '1' then
				diff2 <= sum;
			end if;
		end if;
	end process;

	-- Diff 3 register. Loaded on clk_en. Stores the difference between
	-- the two last sum values.
	process (clk_a, rst_n)
	begin 
		if rst_n = '0' then
			diff3 <= (others => '0');
		elsif rising_edge(clk_a) then
			if clk_en = '1' then
				diff3 <= sum - diff2;
			end if;
		end if;
	end process;

	-- Output latch. Loaded on adc_done. Equal to the difference between
	-- the two last sum values minus the previous difference. Only the 16
	-- most significant bytes of this difference are used.
	process (clk_a, rst_n, adc_done_int, diff2, diff3, sum)
	begin 
		if rst_n = '0' then
			adc_data <= (others => '0');
		elsif clk_a = '0' and adc_done_int = '1' then
			adc_data <= sum(3*ADC_N-1 downto 3*ADC_N-16) -
									diff2(3*ADC_N-1 downto 3*ADC_N-16) -
									diff3(3*ADC_N-1 downto 3*ADC_N-16);
		end if;
	end process;

	process (clk_a)
	begin 
		if rising_edge(clk_a) then
			adc_done <= adc_done_int;	
		end if;
	end process;

end architecture structure;
		
