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
-- Title      : Timing signals generator
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : tim.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The TIM block generates clocks and reset signals for the whole
--              processor. It also outputs several status flags to reflect the
--              current status of clock generation and request logic.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              * Check the 'clock division' agree with specification. Sync.
--                vs. async. counter?
--              * remove 'start_exec'?
--              * Do we still need the variable 'clk_i' frequency?
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		3.10			CB			Created
-- 2005-12-12		3.11			CB			Changed generation of din_u so that the
--																nominal frequency of clk_u becomes 14.7456 MHz
-- 2006-03-08		3.12 			CB			Changed pwr_on to pwr_ok.
-- 2006-03-17		3.13 			CB			Added test_pll.
-- 2006-03-21		3.14 			CB			Removed the en_c signal and its associated
--																logic. Made en_pll be held low by active
--																rst_n instead of rst_cn, and added new output
--																sel_pll to control the PLL mux. Removed some
--																old outcommented code. Added rst_n output for
--																the clk_gen block.
-- 2006-04-03		3.15 			CB			Removed unused 'locked' input.
-- 2013-03-09       5.1             MN          Buffer mreset and mtest
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity atim is
	port(
		-- Clock
		clk_p      : in  std_logic; -- clock buffer to PLL 
		clk_c_en   : in  std_logic; -- PLL clock input
		clk_c2_pos     : in  std_logic; -- clk_c / 2
		clk_e_pos		: out std_logic;
		clk_e_neg		: out std_logic;
		even_c     : in std_logic; -- High during even clk_c cycles
		rst_cn     : in  std_logic;
        core2_en   : in  std_logic;
		-- Inputs from other core blocks
		hold_e     : in  std_logic; -- Hold input for clk_e, stops high when set
		rsc_n      : in  std_logic; -- DCRS command from CPC (active low)
		reqrun     : in  std_logic; -- Wakeup after sleep mode (active high)
		sleep      : in  std_logic; -- Sleep signal (active high)
		-- Outputs to outside core
		--din_e      : out std_logic; -- To clock block for clk_e generation  
		-- Outputs to other core blocks
		--gate_e     : out std_logic; -- A copy of clk_e, used for gating  
		held_e     : out std_logic; -- High when clk_e is held   
		ld_mar     : out std_logic; -- Load the MAR register at CALL SP (act high)  
		runmode    : out std_logic;
		rst_en     : out std_logic); --Reset signal generated, falling clk_e sync    
end;
architecture rtl of atim is
	signal reqrun_s      : std_logic;
	signal rst_state_n   : std_logic;
	signal rst_en_int    : std_logic;
	--signal din_e_int     : std_logic;
	signal runmode_int   : std_logic;
	signal held_e_int    : std_logic;
	attribute syn_keep   : boolean;
	attribute syn_keep of held_e_int : signal is true;  
begin
---------------------------------------------------------------------
-- Reset generation
---------------------------------------------------------------------
	-- 'rst_en' is asynchronously activated by 'rst_cn'.
	-- Deactivation will be synchronised to the positive edge of 'clk_e'.
--	Reset_dn : process (clk_p)
--	begin
--		if rising_edge(clk_p) then--rising_edge(clk_e)
--			if rst_cn = '0' then
--				rst_en_int <= '0';
--			elsif (clk_e_neg = '0') then--
--			    rst_en_int <= '1';
--			end if;
--		end if;
--	end process;
	rst_en <= rst_cn;

	-- 'rsc_n' will disable internal clock and reset state counter.
	rst_state_n <= rsc_n and rst_cn; 

	-- Generate din_e, this is the D input expression for the
	-- FF in the clock block that generates clk_e. Also generate
	-- gate_e, a copy of clk_e used for gating, not for clocking.
	clk_e_neg <= even_c or held_e_int or (not core2_en);
	clk_e_pos <= clk_c2_pos or held_e_int or (not core2_en);
	
--   gate_e <= even_c_int or held_e_int;
--	process (clk_p)
--	begin
--		if rising_edge(clk_p) then
--			if rst_cn = '0' then
--				gate_e <= '1';
--			elsif (clk_c_en = '1') then
--			    gate_e <= din_e_int;
--			end if;
--		end if;
--	end process;
--	din_e <= din_e_int;

---------------------------------------------------------------------
-- Run/stop/step
---------------------------------------------------------------------
	--synchronize 'reqrun'.
	process (clk_p)
	begin
		if rising_edge(clk_p) then
			if rst_cn = '0' then
				reqrun_s <= '0';
			elsif (clk_c2_pos = '0') then
			    reqrun_s <= reqrun;
			end if;
		end if;
	end process;

	-- runmode indicates when clk_e is in run mode. It is set by
	-- reqrun(reqrun_s) and reset by sleep.
	process (clk_p)
	begin
		if rising_edge(clk_p) then
			if rst_state_n = '0' then
				runmode_int <= '1'; -- Run
			elsif clk_c2_pos = '0' then
			    case runmode_int is
			    	when '0' => -- Stop
			    		if reqrun_s = '1' then
			    			runmode_int <= '1'; -- Run
			    		end if;
			    	when '1' => -- Run
			    		if sleep = '1' then
			    			runmode_int <= '0'; -- Stop
			    		end if;
			    	when others => null;
			    end case;
			end if;
		end if;
	end process;
	runmode <= runmode_int;

	-- Generate held_e, used to tell the rest of the core that
	-- clk_e is being held.
	-- held_e is high when hold_e is high or runmode is low.
	-- single_step high overrides hold_e though, and forces
	-- held_e low.
	held_e_int <= (hold_e or (not runmode_int));
	held_e <= held_e_int;


	-- ld_mar is used to load the microprogram address in the MAR
	-- register in the CLC block. This is done at CALL SP or at
	-- every clk_e cycle in stop mode.
	ld_mar <= not runmode_int;

end;

