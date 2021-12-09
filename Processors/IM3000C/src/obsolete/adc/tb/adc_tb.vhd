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
-- Title      : adc test bench
-- Project    : adc
-------------------------------------------------------------------------------
-- File       : adc_tb.vhd
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
use ieee.math_real.all;
use Std.TextIO.all;
use work.gp_pkg.all;

entity dac_tb is
end dac_tb;

architecture testbench of dac_tb is
	constant FREQ_IN		: real := 1000.0;
	constant CYCLE_P		: time := 10 ns;
	constant CLK_DIV		: integer := 13;
	constant PULSE_LEN	: integer := 6;
	constant CYCLE_A		: time := CLK_DIV * CYCLE_P;
	constant FREQ_A			: real := real(1 sec/CYCLE_A);
	constant VMAX				: real := 3.2;
	constant IFACTOR		: real := 0.1;
	constant TINCR			: real := FREQ_IN/FREQ_A * 2.0*MATH_PI;
			
	signal clk_p	: std_logic;
	signal rst_n	: std_logic;
	signal clk_a	: std_logic;
	signal pulse	: std_logic;
	signal ain		: real;
	signal input	: std_logic;
	signal fb			: std_logic;
	signal clk_en	: std_logic;
	signal output	: std_logic_vector(3*ADC_N-1 downto 0);
	signal sample	: std_logic_vector(3*ADC_N-1 downto 0);

  file out_file	: Text open write_mode is "ADC.TXT";

begin
	rst_n <= '0', '1' after 10 ns;

	process
  begin   
    clk_p <= '0';
    wait for CYCLE_P/2;
    clk_p <= '1';
    wait for CYCLE_P/2;
  end process;

	process (clk_p, rst_n)
		variable ctr_a	: integer;
  begin   
  	if rst_n = '0' then
  		ctr_a := 0;
  		clk_a <= '1';
  	elsif rising_edge(clk_p) then
 			ctr_a := ctr_a + 1;
  		if ctr_a = CLK_DIV then
  			ctr_a := 0;
  			clk_a <= '1';
  		elsif ctr_a = CLK_DIV-PULSE_LEN then
	  		clk_a <= '0';
  		end if;
 		end if;
  end process;
  pulse <= clk_a;

	-- Input sine wave generator
	process (clk_a, rst_n)
		variable t	: real;
  begin   
		if rst_n = '0' then
			ain <= VMAX/2.0;
			t		:= 0.0;
		elsif rising_edge(clk_a) then
			ain <= (1.0 + sin(t)) * VMAX/2.0;
			t := t + TINCR;
			if t >= 2.0*MATH_PI then
				t := t - 2.0*MATH_PI;
			end if;
		end if;
  end process;
	
	-- Analog part emulation
	process (clk_a, rst_n)
		variable iin1		: real;
		variable iin2		: real;
		variable iout1	: real;
		variable iout2	: real;
  begin   
  	if rst_n = '0' then
			iin1	:= 0.0;
			iin2	:= 0.0;
			iout1	:= 0.0;
			iout2	:= 0.0;
  		input <= '0';
  	elsif rising_edge(clk_a) then
			iin1 := ain;
			iin2 := iout1;
			if fb = '1' then
				iin1 := iin1 - VMAX;
				iin2 := iin2 - VMAX;
			end if;
			iout1 := iout1 + IFACTOR * iin1;
			iout2 := iout2 + IFACTOR * iin2;
			if iout2 > VMAX/2.0 then
				input <= '1';
			else
				input <= '0';
			end if;
		end if;
  end process;

	adc : entity work.adc
		port map (
			clk_a		=> clk_a,
			rst_n		=> rst_n,
			input		=> input,
			fb			=> fb,
			clk_en	=> clk_en,
			output	=> output);

	process (clk_a, rst_n)
		variable diff2		: std_logic_vector(3*ADC_N-1 downto 0);
		variable diff3		: std_logic_vector(3*ADC_N-1 downto 0);
    variable out_line	: Line;
  begin   
  	if rst_n = '0' then
			diff2		:= (others => '0');
			diff3		:= (others => '0');
			sample	<= (others => '0');
  	elsif rising_edge(clk_a) then
			if clk_en = '1' then
				sample <= output - diff2 - diff3;
				diff3 := output - diff2;
				diff2 := output;
--        Write(out_line, ain);
--        Write(out_line, string'(","));
--        Write(out_line, HexImage(sample));
        Write(out_line, real(conv_integer(sample))/2097152.0 * 3.2 - 1.6);
        WriteLine(out_file, out_line);
			end if;
		end if;
  end process;

end architecture testbench;












