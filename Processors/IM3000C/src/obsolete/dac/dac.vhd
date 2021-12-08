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
-- Title      : DAC digital part
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : dac.vhd
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
-- 2005-01-13		1.0				CB			Created
-- 2006-03-08		1.1 			CB			Separated asynchronous reset for the channels.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.gp_pkg.all;

entity dac is
	port (
		clk_a			: in	std_logic;
		rst_n			: in	std_logic_vector(0 to DAC_CHANNELS-1);
		dac_data	: in	dac_data_type;
		dac_bits	: out	std_logic_vector(0 to DAC_CHANNELS-1));
end entity dac;

architecture structure of dac is
	type acc_type is array (0 to DAC_CHANNELS-1) of std_logic_vector(DAC_LBITS+1 downto 0);
	signal rc				: std_logic_vector(DAC_HBITS-1 downto 0);
	signal pt				: std_logic_vector(DAC_HBITS-1 downto 0);
	signal acc			: acc_type;
	signal bits_lo	: std_logic_vector(0 to DAC_CHANNELS-1);

begin
----------------------------------------------------------------
-- High order bits.
----------------------------------------------------------------
--	-- Ripple counter, first FF.
--	process (clk_a, rst_n)
--	begin 
--		if rst_n = '0' then
--			rc(0) <= '0';
--		elsif rising_edge(clk_a) then
--			rc(0) <= not rc(0);
--		end if;
--	end process;
--
--	-- Ripple counter, next FFs.
--	process (rc, rst_n)
--	begin 
--		for i in 1 to DAC_HBITS-1 loop
--			if rst_n = '0' then
--				rc(i) <= '0';
--			elsif falling_edge(rc(i-1)) then
--				rc(i) <= not rc(i);
--			end if;
--		end loop;	
--	end process;

	-- Synchronous counter, all FFs.
	process (clk_a, rst_n(0))
	begin 
		if rst_n(0) = '0' then
			rc <= (others => '0');
		elsif rising_edge(clk_a) then
			rc <= rc + 1;
		end if;
	end process;

	-- Pulse train forming logic.
--process (rc, pulse)
	process (rc)
	begin 
		for i in 0 to DAC_HBITS-1 loop
--		pt(i) <= rc(i) and pulse;
			pt(i) <= rc(i);
			for j in 0 to i-1 loop
				if rc(j) = '1' then
					pt(i) <= '0';
				end if;
			end loop;	
		end loop;	
	end process;

	-- Bitstream generators.	
	process (pt, dac_data, rc, bits_lo)
	begin 
		for i in 0 to DAC_CHANNELS-1 loop
			dac_bits(i) <= bits_lo(i);
			for j in 0 to DAC_HBITS-1 loop
				if rc(j) = '1' then				
					dac_bits(i) <= '0';
				end if;	
			end loop;	
			for j in 0 to DAC_HBITS-1 loop
				if (pt(DAC_HBITS-1-j) and dac_data(i)(j)) = '1' then
					dac_bits(i) <= '1';
				end if;	
			end loop;	
		end loop;	
	end process;

----------------------------------------------------------------
-- Low order bits.
----------------------------------------------------------------
	-- Accumulator.
--process (rc, rst_n)
	process (clk_a, rst_n)
	begin 
		for i in 0 to DAC_CHANNELS-1 loop
			if rst_n(i) = '0' then
				acc(i) <= (others => '0');
--		elsif falling_edge(rc(DAC_HBITS-1)) then
			elsif rising_edge(clk_a) then
				if rc = (2**DAC_HBITS)-1 then
					acc(i) <= acc(i) + (acc(i)(DAC_LBITS+1) & acc(i)(DAC_LBITS+1) &
															dac_data(i)(DAC_LBITS-1 downto 0));
				end if;
			end if;
		end loop;	
	end process;

	-- Bitstream output.	
	process (acc)
	begin 
		for i in 0 to DAC_CHANNELS-1 loop
			bits_lo(i) <= acc(i)(DAC_LBITS+1);
		end loop;	
	end process;

end architecture structure;
		
