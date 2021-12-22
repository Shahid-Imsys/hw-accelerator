-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                                    IMSYS AB,  2000        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   AB, Sweden.                                                             --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys AB or in accordance with the terms and            --
--   conditions stipulated in the agreement/contract under which the         --
--   document(s) have been supplied.                                         --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : dac test bench
-- Project    : dac
-------------------------------------------------------------------------------
-- File       : dac_tb.vhd
-- Author     : Christian Blixt
-- Company    : Imsys AB
-- Date       : 010113
-- Platform   :
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dac_tb is
end dac_tb;

architecture testbench of dac_tb is
		signal clk_p	: std_logic;
		signal rst_n	: std_logic;
		signal ctr_a	: std_logic_vector(2 downto 0);
		signal clk_a	: std_logic;
		signal pulse	: std_logic;
		signal data		: dac_data;
		signal bits		: std_logic_vector(0 to 1);

begin
	rst_n <= '0', '1' after 10 ns;

	process
  begin   
    clk_p <= '0';
    wait for 5 ns;
    clk_p <= '1';
    wait for 5 ns;
  end process;

	process (clk_p, rst_n)
  begin   
  	if rst_n = '0' then
  		ctr_a <= 0;
  		clk_a <= '1';
  	elsif rising_edge(clk_p) then
  		if ctr_a = 6 then
  			ctr_a <= 0;
  			clk_a <= '1';
  		else
  			ctr_a <= clk_a + 1;
	  		clk_a <= '0';
  		end if;
  end process;
  pulse <= clk_a;

	data(0) <= x"00";

	process (clk_a, rst_n)
		variable interval	: integer;
  begin
  	if rst_n = '0' then
			interval := 0;
			data(1) <= x"80";
  	elsif rising_edge(clk_a) then
			if interval = 255 then
				interval := 0;
				data(1) <= data(1) + 1;
			else
				interval := interval + 1;
			end if;
		end if;
  end process;
	
	dac : entity work.dac
		port map (
			clk		=> clk_a,
			rst_n	=> rst_n,
			pulse	=> pulse,
			data	=> data,
			bits	=> bits);

	process (clk_a, rst_n)
		variable integrator	: float;
  begin
  	if rst_n = '0' then
			integrator := 0.0;
  	elsif rising_edge(clk_a) then
			if
			integrator := bits(1);

		end if;
  end process;

end architecture testbench;












