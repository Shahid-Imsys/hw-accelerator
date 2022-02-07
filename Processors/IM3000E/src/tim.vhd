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
-- 2013-02-21       5.1				MN          Changed rst_en to negtive edge of clk_e
-- 2013-03-09       5.1             MN          Buffer mreset and mtest
-- 2016-08-29                       MN          add rst_cn_cnt1 for reset from HALT mode
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tim is
	port(
		-- Clock
		clk_p      : in  std_logic; -- clock buffer to PLL 
		even_c     : in std_logic;
		clk_c_en   : in  std_logic; -- PLL clock input
		--clk_c2_pos  : out  std_logic; -- clk_c / 2 
		clk_e_pos   : out  std_logic; -- Execution clock input
		clk_e_neg   : out std_logic;
--  clk_i      : in std_logic;  -- I/O clock input
		
		-- Microinstruction fields
		pl         : in  std_logic_vector(79 downto 0); -- Used for CALL SP & ACK SPREQ
		
		--pl_shin_pa : in  std_logic_vector(3 downto 0); -- Used for CALL SP & ACK SPREQ
		--pl_alud    : in  std_logic_vector(2 downto 2); -- Only bit 2 used here
		-- Static control inputs
		en_i       : in  std_logic; -- Enable I/O clock when high
		en_mckout1 : in  std_logic; -- Enable MCKOUT1 pin when high
		en_s       : in  std_logic; -- Enable SP clock when high
		speed_i    : in  std_logic_vector(1 downto 0);   --I/O timing select
		speed_u    : in  std_logic_vector(6 downto 0);   --UART prescaler control
		speed_s    : in  std_logic_vector(1 downto 0);   --SP clock control
		speed_ps1  : in  std_logic_vector(3 downto 0);   --Prescaler 1 control
		speed_ps2  : in  std_logic_vector(5 downto 0);   --Prescaler 2 control
		speed_ps3  : in  std_logic_vector(4 downto 0);   --Prescaler 3 control
		dis_xosc   : in  std_logic; -- disable xosc from CRB
		dis_pll    : in  std_logic; -- disable pll  from CRB
		clk_sel    : in  std_logic;-- clock select from CRB
		-- Inputs from outside core
		mreset     : in  std_logic; -- Asynchronous reset (active low)
		pwr_ok     : in  std_logic; -- Power-on from PWRON
		--mpordis_i  : in  std_logic; -- MPORDIS pad input
		mtest_i    : in  std_logic; -- MTEST pad input
		mbypass_i  : in  std_logic; -- MBYPASS pad input
		-- Inputs from other core blocks
		hold_e     : in  std_logic; -- Hold input for clk_e, stops high when set
		hold_flash : in  std_logic;
		hold_flash_d: in std_logic;
		gen_spreq  : in  std_logic; -- Generate SPREQ (act H)
		rsc_n      : in  std_logic; -- DCRS command from CPC (active low)
		stop_step  : in  std_logic; -- SSCU command from CPC (active high)
		run        : in  std_logic; -- RUCU command from CPC (active high)
		spack_cmd  : in  std_logic; -- ACKC command from CPC (active high)
		reqrun     : in  std_logic; -- Wakeup after sleep mode (active high)
		sleep      : in  std_logic; -- Sleep signal (active high)
		wdog_n     : in  std_logic; -- Watch dog reset (active low)
		
		-- power down wake up reset , added by HYX, 20150706
		reset_core_n  : in std_logic;
		reset_iso  : in std_logic;  -- isolate the reset by power_ok
		reset_iso_clear : out std_logic;

		-- Outputs to outside core
		mrstout    : out std_logic; -- MRSTOUT pad output 
		en_xosc    : out std_logic; -- enable XOSC
		en_pll     : out std_logic; -- enable PLL
		sel_pll    : out std_logic; -- select PLL as clock source
		test_pll   : out std_logic; -- PLL in test mode
		mirqout    : out std_logic; -- MIRQOUT pin, for irq to SP (act low)  
		mckout1    : out std_logic; -- Programmable division of clk_c, to external pin
		--din_e      : out std_logic; -- To clock block for clk_e generation  
		din_i      : out std_logic; -- To clock block for clk_i generation  
		din_u      : out std_logic; -- To clock block for clk_u generation  
		din_s      : out std_logic; -- To clock block for clk_s generation  
		-- Outputs to other core blocks
		--even_c     : out std_logic; -- High during even clk_c cycles   
		--gate_e     : out std_logic; -- A copy of clk_e, used for gating  
		held_e     : out std_logic; -- High when clk_e is held   
		pend_i     : out std_logic; -- High during clk_c cycle before rising clk_i edge
--    gate_i     : out std_logic; -- A copy of clk_i, used for gating 
		state_ps3  : out std_logic_vector(4 downto 0); -- Transfer prescaler 3 to CRB for access
		clkreq_gen : out std_logic; -- Programmable division of clk_c, for clkreq generation
		ld_mar     : out std_logic; -- Load the MAR register at CALL SP (act high)  
		runmode    : out std_logic; -- For status information to SP
		spack_n    : out std_logic; -- SP acknowledge,(act low)
		spreq_n    : out std_logic; -- SP request, (act low)
        rst_n      : out std_logic; -- Asynchronous reset to clk_gen
		rst_cn     : out std_logic; -- Reset signal generated, clk_c sync   
		rst_en     : out std_logic); --Reset signal generated, falling clk_e sync    
end;
architecture rtl of tim is
	signal reqrun_s      : std_logic;
	signal call_sp       : std_logic;
	signal spack_cmd_c2  : std_logic;
	signal gen_spreq_c2  : std_logic;
	signal ack_spreq     : std_logic;
	signal stop_step_c2  : std_logic;
	signal single_step   : std_logic;
	signal rst_state_n   : std_logic;
--  signal rst_cn_sync  : std_logic;
	signal split_i4      : std_logic;
	signal split_i8      : std_logic;
	signal fract_u       : std_logic_vector(2 downto 0);
	signal ctr_u         : std_logic_vector(3 downto 0);
	signal sum_u         : std_logic_vector(3 downto 0);
	signal split_s4      : std_logic;
	signal split_s8      : std_logic;
	signal prescale1     : std_logic_vector(3 downto 0);
	signal prescale2     : std_logic_vector(5 downto 0);
	signal prescale3     : std_logic_vector(4 downto 0);
	signal ps1_out       : std_logic;
	signal ps2_out       : std_logic;
	signal ps3_out       : std_logic;
	signal rst_nint      : std_logic;
	signal rst_nint_int0  : std_logic;--added by maning
	signal rst_nint_int1  : std_logic;--added by maning
	signal mtest_i_int0  : std_logic;--added by maning
	signal mtest_i_int1  : std_logic;--added by maning	
	signal rst_cn_cnt    : std_logic_vector(2 downto 0);
	signal rst_cn_cnt1    : std_logic_vector(4 downto 0); -- for use in wake up mode added by maning
	signal rst_cn_off    : std_logic;
--	signal pll_stable_cnt : std_logic_vector(14 downto 0);
--	signal pll_stable_cnt_off : std_logic;
	signal sel_pll_on    : std_logic;
	signal din_i_int     : std_logic;
	signal din_s_int     : std_logic;
	signal rst_cn_int    : std_logic;
	signal sel_pll_int   : std_logic;
	signal rst_en_int    : std_logic;
	signal runmode_int   : std_logic;
	signal held_e_int    : std_logic;
	signal mckout1_int   : std_logic;
	signal ff2				   : std_logic;
	signal ff2x				   : std_logic;
	signal spackn_int    : std_logic;
	signal spreqn_int    : std_logic;
	signal clkreq_gen_int: std_logic;
	signal en_pll_int    : std_logic;
	signal gate_i        : std_logic;
	signal gate_s        : std_logic;
	attribute syn_keep   : boolean;
	signal pl_shin_pa_sig:  std_logic_vector(3 downto 0); -- Used for CALL SP & ACK SPREQ
	signal pl_alud_sig   : std_logic; -- Only bit 2 used here
	attribute syn_keep of held_e_int : signal is true;  
begin
---------------------------------------------------------------------
-- Reset generation &
-- power-on detection part
-------------------------------------------------------------------------------
	rst_nint_int0 <= (pwr_ok or reset_iso) and mreset and wdog_n;
	
	reset_iso_clear <= pwr_ok and rst_cn_int;--reset isolate will be cleared if power ok and reset is finished
	
	process (clk_p, rst_nint_int0, reset_core_n)
	begin 
		if rst_nint_int0 = '0' or reset_core_n = '0' then
			rst_nint_int1 <= '0';
			rst_nint <= '0';
		elsif falling_edge(clk_p) then
			rst_nint_int1 <= '1';
			rst_nint <= rst_nint_int1;
		end if;
	end process;	
	
	process (clk_p)
	begin 
		if falling_edge(clk_p) then
			mtest_i_int0 <= mtest_i;
			mtest_i_int1 <= mtest_i_int0;
		end if;
	end process;
	
  	rst_n <= rst_nint;
--	en_pll_int <= (not dis_pll) and (not mbypass_i) and rst_nint;
	en_pll_int <= (not dis_pll) and (not mbypass_i);--clock can be switched to external clock but still keep PLL active
	en_pll <= en_pll_int and rst_nint;-- use for pll pdn
 	test_pll	<= mtest_i_int1 ;--and mpordis_i
	en_xosc <= (not dis_xosc) and rst_nint;
	
	-- First step of rst_cn_cnt, clock with clkreq_gen, it
	-- contains no spikes.
	process (clk_p, rst_nint)
	begin 
	    if rst_nint = '0' then
    	    rst_cn_cnt <= "000";
	    elsif rising_edge(clk_p) then--rising_edge(clk_req_gen_int)
		    if (rst_cn_int = '0' or (sel_pll_on = '0' and en_pll_int = '1')) and clkreq_gen_int = '1' then--rst_cn_cnt needs to count for both rst_cn and pll select
				rst_cn_cnt <= rst_cn_cnt + '1';
			end if;
		end if;
	end process;

	process (clk_p, rst_nint)
	begin 
	    if rst_nint = '0' then
		    rst_cn_cnt1 <= "00000";
		elsif rising_edge(clk_p) then--
		    if rst_cn_int = '0' and reset_iso = '1' then  --for recover from HALT mode
				rst_cn_cnt1 <= rst_cn_cnt1 + '1';
			end if;
		end if;
	end process;
	
	-- rst_cn_off is the final state of rst_cn_cnt. When in test
	-- mode, only the low two FFs are used.
--	rst_cn_off <= '1' when (mtest_i_int1 = '0' and rst_cn_cnt = "111111") or
--						   (mtest_i_int1 = '1' and rst_cn_cnt(1 downto 0) = "11") or
--						    rst_cn_cnt1 = "11111" else '0'; 
	rst_cn_off <= '1' when rst_cn_cnt = "111" or rst_cn_cnt1 = "11111" else '0'; 	
	-- Generate rst_cn, releases when rst_cn_cnt has reached
	-- its final state. mrstout is the same as rst_cn.
	rst_cn_gen: process (clk_p, rst_nint)
	begin 
	    if rst_nint = '0' then 
		    rst_cn_int <= '0';
	    elsif falling_edge(clk_p) then--change to falling edge
              if rst_cn_off = '1' then
                rst_cn_int <= '1';
              end if;      
            end if;
	end process rst_cn_gen;
	rst_cn  <= rst_cn_int;
	mrstout <= rst_cn_int;

--
--	process (clk_p)
--	begin 
--	    if rising_edge(clk_p) then--rising_edge(clk_req_gen_int)
--		    if rst_nint = '0' then
--			    pll_stable_cnt <= "000000000000000";
--			elsif pll_stable_cnt_off = '0' then 
--				pll_stable_cnt <= pll_stable_cnt + '1';
--			end if;
--		end if;
--	end process;	
--
--	pll_stable_cnt_off <= '1' when pll_stable_cnt = "111111111111111" else '0';

	-- sel_pll_on uses the first two ffs of the rst_cn counter
	-- to get enough PLL lock time. 
	--sel_pll_on <= pll_stable_cnt_off; 
	sel_pll_on <= '1' when rst_cn_cnt(1) = '1' else '0';  --at least 1 ms for PLL be stable
	-- Generate sel_pll, delays the use of PLL after en_pll
	-- has acticated, to allow it to stabilize.
	sel_pll_gen: process (clk_p, en_pll_int, rst_nint, clk_sel)
	begin 
		if en_pll_int = '0' or rst_nint = '0' or clk_sel = '1' then 
			sel_pll_int <= '0';
		elsif rising_edge(clk_p) then
			if sel_pll_on = '1' then
				sel_pll_int <= '1';
			end if;      
		end if;
	end process sel_pll_gen;
	sel_pll <= sel_pll_int;
	
---------------------------------------------------------------------
-- Reset generation
---------------------------------------------------------------------
	-- 'rst_en' is asynchronously activated by 'rst_cn'.
	-- Deactivation will be synchronised to the positive edge of 'clk_e'.
--	Reset_dn : process (clk_p)
--	begin
--	    if rising_edge(clk_p) then--rising_edge(clk_e)
--		    if rst_cn_int = '0' then
--			    rst_en_int <= '0';
--			elsif (clk_e_neg = '0') then--clk_e_neg
--			    rst_en_int <= '1';
--			end if;
--		end if;
--	end process;
	rst_en <= rst_cn_int;

	
	-- 'rsc_n' will disable internal clock and reset state counter.
	rst_state_n <= rsc_n and rst_cn_int; 
	
---------------------------------------------------------------------
-- Clock subdivisions
---------------------------------------------------------------------

	-- Generate din_e, this is the D input expression for the
	-- FF in the clock block that generates clk_e. Also generate
	-- gate_e, a copy of clk_e used for gating, not for clocking.
	clk_e_neg <= not even_c or held_e_int or hold_flash;
    clk_e_pos <= even_c or held_e_int or hold_flash;
    --gate_e <= even_c or held_e_int;
	
	-- These FFs split clk_c by four and eight for clk_i generation.
	-- They are not toggled if they are not needed, when clk_i is fast.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_cn_int = '0' or en_i = '0' then
			    split_i4 <= '0';
			    split_i8 <= '0';
		    elsif clk_c_en = '1' then
			    if speed_i = "10" or speed_i = "11" then
				    split_i4 <= not even_c xor split_i4;
			    end if;
			    if speed_i = "11" then
				    split_i8 <= (not even_c and not split_i4) xor split_i8;
			    end if;
			end if;
		end if;
	end process;
	
	-- Generate din_i, this is the D input expression for the
	-- FF in the clock block that generates clk_i.
	-- Also generate pend_i, high for one clk_c cycle just before
	-- clk_i(gate_i) goes high.

	process (en_i, gate_i, even_c, split_i4, split_i8, speed_i)
	begin
		case speed_i is
			when "00" =>
				din_i_int <= not even_c;
				pend_i <= not even_c;
			when "01" =>
				din_i_int <= not even_c xor gate_i;
				pend_i <= not even_c and not gate_i;
			when "10" =>
				din_i_int <= (not even_c and not split_i4) xor gate_i;
				pend_i <= not even_c and not split_i4 and not gate_i;
			when "11" =>
				din_i_int <= (not even_c and not split_i4 and not split_i8)
										 xor gate_i;
				pend_i <= not even_c and not split_i4 and not split_i8 and
									not gate_i;
			when others => null;
		end case;
		if en_i = '0' then
			din_i_int <= '0';
			pend_i <= '0';
		end if;
	end process;
	din_i <= din_i_int;

	-- Generate gate_i, which is exactly the same as clk_i but is used for gating.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_cn_int = '0' then
			    gate_i <= '1';
		    elsif (clk_c_en = '1') then
			    gate_i <= din_i_int;
			end if;
		end if;
	end process;
--   gate_i <= gate_i_int;
	
	-- Generate din_u, this is the D input expression for the
	-- FF in the clock block that generates clk_u.
	-- clk_u is a programmable subdivision of clk_c, controlled
	-- by speed_u. The high four bits of speed_u are integral,
	-- while the low three are fractional. When speed_u is 1.0
	-- (0001000), clk_c is divided by 2, when speed_u is 1.5
	-- (0001100), clk_c is divided by 2.5 and so on. When
	-- speed_u is all zero, clk_u is disabled (held high).
	-- clk_u has assymetric duty cycle, and its cycle time will
	-- vary from cycle to cycle when the fractional part of
	-- speed_u is non-zero.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_cn_int = '0' then
			    fract_u <= "000";
			    ctr_u <= "0000";
		    elsif clk_c_en = '1' then
			    if ctr_u = "0000" then
				    fract_u <= sum_u(2 downto 0);
				    ctr_u <= speed_u(6 downto 3) + sum_u(3);
			    else
				    ctr_u <= ctr_u - 1;
			    end if;
			end if;
		end if;
	end process;
	sum_u <= "0000" + fract_u + speed_u(2 downto 0);
	din_u <=  '1' when ctr_u = "0000" else
						'0';

	-- These FFs split clk_c by four and eight for clk_s generation.
	-- They are not toggled if they are not needed, when clk_s is fast.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_cn_int = '0' or en_s = '0' then
			    split_s4 <= '0';
			    split_s8 <= '0';
		    elsif clk_c_en = '1' then
			    if speed_s = "10" or speed_s = "11" then
				    split_s4 <= not even_c xor split_s4;
			    end if;
			    if speed_s = "11" then
				    split_s8 <= (not even_c and not split_s4) xor split_s8;
			    end if;
			end if;
		end if;
	end process;

	-- Generate din_s, this is the D input expression for the
	-- FF in the clock block that generates clk_s.
	process (en_s, gate_s, even_c, split_s4, split_s8, speed_s)
	begin
		case speed_s is
			when "00" =>
				din_s_int <= not even_c;
			when "01" =>
				din_s_int <= not even_c xor gate_s;
			when "10" =>
				din_s_int <= (not even_c and not split_s4) xor gate_s;
			when "11" =>
				din_s_int <= (not even_c and not split_s4 and not split_s8) xor gate_s;
			when others => null;
		end case;
		if en_s = '0' then
			din_s_int <= '0';
		end if;
	end process;
    din_s <= din_s_int;
    -- Generate gate_s, which is exactly the same as clk_i but is used for gating.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_cn_int = '0' then
			    gate_s <= '1';
		    elsif (clk_c_en = '1') then
			    gate_s <= din_s_int;
			end if;
		end if;
	end process;
	-- Prescaler 1 is used to generate mckout1, which is a clock output
	-- pin, and as input to prescaler 2.
	process (clk_p, rst_nint)
	begin
	    if rst_nint = '0' then
		    prescale1 <= "0000";
		elsif rising_edge(clk_p) then
		    if prescale1 = "0000" then
				prescale1 <= speed_ps1;
--				if mtest_i_int1 = '1' then -- Shorten counter to 2 FFs in test mode
--					prescale1(3 downto 2) <= "00";
--				end if;
			else
				prescale1 <= prescale1-1;
			end if;
		end if;
	end process;
	ps1_out <=  '1' when prescale1 = "0000" else
							'0';

	-- Generate mckout1.
	process (clk_p, rst_nint)
	begin
	    if rst_nint = '0' then
		    mckout1_int <= '0';
		elsif rising_edge(clk_p) then
		    if ps1_out = '1' and en_mckout1 = '1' then
				mckout1_int <= not mckout1_int;
			end if;
		end if;
	end process;

	process (clk_p)
	begin
		if rising_edge(clk_p) then
			if en_mckout1 = '0' then
				ff2 <= '0';
			elsif prescale1-1 = '0' & speed_ps1(3 downto 1) then
				ff2 <= not ff2;
			end if;
		end if;
	end process;

	process (clk_p)
	begin
		if falling_edge(clk_p) then
			if en_mckout1 = '0' then
				ff2x <= '0';
			elsif prescale1 = '0' & speed_ps1(3 downto 1) then
				ff2x <= not ff2x;
			end if;
		end if;
	end process;

	mckout1 <= mckout1_int xor ff2 when speed_ps1(0) = '1' else
						 mckout1_int xor ff2x;

	-- Prescaler 2 is used to generate a frequency close to 1MHz, which is
	-- used as input to prescaler 3. That way the readable prescaler 3 can
	-- be used to maintain a microsecond counter.
	process (clk_p, rst_nint)
	begin
	    if rst_nint = '0' then
		    prescale2 <= "000000";
		elsif rising_edge(clk_p) then
		    if ps1_out = '1' then
				if prescale2 = "000000" then
					prescale2 <= speed_ps2;
--					if mtest_i_int1 = '1' then    -- Shorten counter to 3 FFs in test mode
--						prescale2(5 downto 3) <= "000";
--					end if;
				else
					prescale2 <= prescale2-1;
				end if;
			end if;
		end if;
	end process;
	ps2_out <=  '1' when prescale2 = "000000" and ps1_out = '1' else
							'0';

	-- Prescaler 3 is used to generate clock request. This prescaler is
	-- readable through the CRB interface.
	process (clk_p, rst_nint)
	begin
	    if rst_nint = '0' then
		    prescale3 <= "00000";
			clkreq_gen_int <= '0';
	    elsif rising_edge(clk_p) then
		    clkreq_gen_int <= ps3_out;
			if ps2_out = '1' then
				if prescale3 = "00000" then
					prescale3 <= speed_ps3;
--					if mtest_i_int1 = '1' then    -- Shorten counter to 2 FFs in test mode
--						prescale3(4 downto 2) <= "000";
--					end if;
				else
					prescale3 <= prescale3-1;
				end if;
			end if;
	    end if;
	end process;
	ps3_out <=  '1' when prescale3 = "00000" and ps2_out = '1' else
							'0';
	clkreq_gen <= clkreq_gen_int;
	state_ps3 <= prescale3;

---------------------------------------------------------------------
-- Run/stop/step
---------------------------------------------------------------------
	--synchronize 'reqrun'.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then 
		    if rst_cn_int = '0' then
			    reqrun_s <= '0';
		    elsif (even_c = '0') then
			    reqrun_s <= reqrun;
			end if;
		end if;
	end process;

	-- runmode indicates when clk_e is in run mode. It is set by
	-- run or reqrun(reqrun_s) and reset by stop_step or sleep.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_state_n = '0' then
			    runmode_int <= '1'; -- Run
		    elsif even_c = '0' then
			    case runmode_int is
			    	when '0' => -- Stop
			    		if run = '1' or reqrun_s = '1' then
			    			runmode_int <= '1'; -- Run
			    		end if;
			    	when '1' => -- Run
			    		if stop_step = '1' or sleep = '1' then
			    			runmode_int <= '0'; -- Stop
			    		end if;
			    	when others => null;
			    end case;
			end if;
		end if;
	end process;
	runmode <= runmode_int;

	-- single_step step is used to edge detect stop_step to the
	-- clk_c2 domain, to avoid multiple steps when clk_s is slow.
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
	        if rst_cn_int = '0' then
	            single_step <= '0';
	            stop_step_c2 <= '0';
		    elsif (even_c = '0') then   
			    single_step		<= stop_step and not stop_step_c2;
			    stop_step_c2	<= stop_step;
			end if;
		end if;
	end process;

	-- Generate held_e, used to tell the rest of the core that
	-- clk_e is being held.
	-- held_e is high when hold_e is high or runmode is low.
	-- single_step high overrides hold_e though, and forces
	-- held_e low.
	held_e_int <= (not single_step) and (hold_e or (not runmode_int) or hold_flash_d);
	held_e <= held_e_int;

---------------------------------------------------------------------
-- Call SP/SP ack
---------------------------------------------------------------------
	-- Decode the PA field of the microinstruction to generate
	-- the call_sp and ack_spreq signals.
	pl_shin_pa_sig <= (pl(60) xor pl(68))&pl(56)&(pl(16) xor pl(35))&pl(68);
	pl_alud_sig    <= pl(71) xor pl(77);
	process (pl_shin_pa_sig, pl_alud_sig)
	begin
		call_sp <= '0';
		ack_spreq <= '0';
		if pl_shin_pa_sig = "1010" and pl_alud_sig = '0' then
			call_sp <= '1';     --Request from GP to SP(Support Processor)
		end if;
		if pl_shin_pa_sig = "1011" and pl_alud_sig = '0' then
			ack_spreq <= '1';   --'Ack' from GP to SP, active high
		end if;
	end process;

	-- ld_mar is used to load the microprogram address in the MAR
	-- register in the CLC block. This is done at CALL SP or at
	-- every clk_e cycle in stop mode.
	ld_mar <= call_sp or not runmode_int;

---------------------------------------------------------------------
-- SPACK/call SP
---------------------------------------------------------------------
	-- spack_n is set after call_sp, and reset by spack_cmd.
	-- mirqout is the inverse of spack_n. spack_cmd is edge
	-- detected since it comes from the potentially slow clk_s
	-- domain, call_sp is gated with held_e to avoid setting
	-- spack_n and then hanging on a stopped clk_e.
	process (clk_p)
	begin  
	    if rising_edge(clk_p) then
		    if rst_state_n = '0' then
			    spackn_int <= '0';
			    spack_cmd_c2 <= '0';
		    elsif (even_c = '0') then
			    if call_sp = '1' and held_e_int = '0' and hold_flash = '0' then
			    	spackn_int <= '1';
			    elsif spack_cmd = '1' and spack_cmd_c2 = '0' then
			    	spackn_int <= '0';
			    end if;
			    spack_cmd_c2 <= spack_cmd;
			end if;
		end if;
	end process;
	spack_n <= spackn_int;  
	mirqout <= not spackn_int;  

---------------------------------------------------------------------
-- SPREQ/ack SPREQ
---------------------------------------------------------------------
	-- spreq_n is reset after gen_spreq, and set by ack_spreq.
	-- gen_spreq is edge detected since it comes from the potentially
	-- slow clk_s domain, ack_spreq is gated with held_e to avoid
	-- resetting spreq_n and then hanging on a stopped clk_e.
	process (clk_p)
	begin  
	    if rising_edge(clk_p) then
		    if rst_state_n = '0' then
			    spreqn_int <= '1';
			    gen_spreq_c2 <= '0';
		    elsif even_c = '0' then
			    if gen_spreq = '1' and gen_spreq_c2 = '0' then
			    	spreqn_int <= '0';    
			    elsif ack_spreq = '1' and held_e_int = '0' and hold_flash = '0' then
			    	spreqn_int <= '1';    
			    end if;
			    gen_spreq_c2 <= gen_spreq;
			end if;
		end if;
	end process;
	spreq_n <= spreqn_int;
end;

