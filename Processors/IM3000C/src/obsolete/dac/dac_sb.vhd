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
-- 2006-04-08		2.0			SB
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.gp_pkg.all;

entity dac is
	port (
		clk_a			: in	std_logic;
		rst_n			: in	std_logic_vector(0 to 1);
		dac_data	: in	dac_data_type;
		dac_bits	: out	std_logic_vector(0 to 1));
end entity dac;

architecture structure of dac is
	type adder_type is array (0 to 1) of std_logic_vector(19 downto 0);
	type adder2_type is array (0 to 1) of std_logic_vector(19 downto 17);
	type acc_type is array (0 to 1) of std_logic_vector(18 downto 0);
	signal adder1			: adder_type;
	signal acc			: acc_type;
	signal adder2			: adder2_type;
	signal adder3			: adder_type;
	signal acc2			: acc_type;
--	signal bits_lo	: std_logic_vector(0 to 15);
	signal dac_bits_int	: std_logic_vector(0 to 1);

begin
----------------------------------------------------------------
	-- Accumulator.
	
	-- Adder1.	
	process (dac_bits_int, dac_data, acc)
	begin 
		for i in 0 to 1 loop
			adder1(i) <= (dac_bits_int(i) & dac_bits_int(i) & dac_bits_int(i) & dac_bits_int(i) & dac_data(i)(15 downto 0)) +
									 (acc(i)(18) & acc(i)(18 downto 0));
		end loop;	
	end process;

	process (clk_a, rst_n)
	begin 
		for i in 0 to 1 loop
			if rst_n(i) = '0' then
				acc(i) <= (others => '0');
			elsif rising_edge(clk_a) then
				case adder1(i)(19 downto 18) is
        			  when "01" => acc(i) <= "0111111111111111111";
        			  when "10" => acc(i) <= "1000000000000000000";
        			  when others => acc(i) <= adder1(i)(18 downto 0);
        			end case;
			end if;
		end loop;	
	end process;

	-- Adder2 and 3.	
	process (dac_bits_int, acc, acc2, adder2)
	begin 
		for i in 0 to 1 loop
			adder2(i) <= (dac_bits_int(i) & dac_bits_int(i) & dac_bits_int(i)) +
									 (acc(i)(18) & acc(i)(18 downto 17));
			adder3(i) <= (adder2(i)(19 downto 17) & acc(i)(16 downto 0)) +
									 (acc2(i)(18) & acc2(i)(18 downto 0));
		end loop;	
	end process;

	process (clk_a, rst_n)
	begin 
		for i in 0 to 1 loop
			if rst_n(i) = '0' then
				acc2(i) <= (others => '0');
			elsif rising_edge(clk_a) then
				case adder3(i)(19 downto 18) is
        			  when "01" => acc2(i) <= "0111111111111111111";
        			  when "10" => acc2(i) <= "1000000000000000000";
        			  when others => acc2(i) <= adder3(i)(18 downto 0);
        			end case;
			end if;
		end loop;	
	end process;

	-- Bitstream output.	
	process (acc)
	begin 
		for i in 0 to 1 loop
			dac_bits_int(i) <= not acc2(i)(18);
		end loop;	
	end process;
	dac_bits <= dac_bits_int;

end architecture structure;
		
