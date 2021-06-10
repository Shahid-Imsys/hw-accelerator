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
-- Title      : sct
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : sct.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Sequence control decode logic 
--
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.1 			CB			Created
-- 2012-08-15		2.0				MN			Removed plus1 since it is not used
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.mpgmfield_lib.all;

entity sct is
	port(
		-- Clock and reset inputs
		clk_p                   : in std_logic;
		clk_e_pos			: in  std_logic;  -- Execution clock
		rst_en			: in  std_logic;  -- Reset input (active  low)
		-- Microprogram fields
		pl_seqc			: in  std_logic_vector(4 downto 0);
		pl_cond			: in  std_logic_vector(5 downto 0);
		pl_cpol			: in  std_logic;                    
		pl_ad				: in  std_logic_vector(11 downto 0);
		ld_mpgm         : in std_logic; --Added by CJ
		-- Control inputs
		ira1				: in  std_logic;  -- SPECIAL flip-flop
		ira2				: in  std_logic;  -- PSCTR carry-out flip-flop (from GMEM)
		st_full			: in  std_logic;  -- Stack full (active high) 
		st_empty		: in  std_logic;  -- Stack empty (active high) 
		ctr_eq0			: in  std_logic;  -- Counter/register zero (active high)
		cond_pass		: in  std_logic;  -- Condition pass (active high)
		dfm_vld         : in  std_logic;  -- DFM data valid --Added by CJ
		vldl            : in  std_logic;  -- one clock latch of dfm_vld
		--Data Inputs
		di					: in  std_logic_vector(7 downto 0);		-- Next address mux 
		y_reg				: in  std_logic_vector(7 downto 0);		-- Y bus register
		pc					: in  std_logic_vector(7 downto 0);	-- Program counter--CJ
		sout				: in  std_logic_vector(7 downto 0);	-- Stack output --CJ
		rout				: in  std_logic_vector(7 downto 0);	-- Counter/register output --CJ
		--Control Outputs
		st_push			: out std_logic;	-- Increment stack counter (active high)
		st_pop			: out std_logic;	-- Decrement stack counter (active high)
		st_we_n			: out std_logic;	-- Stack write enable (active low)
		ctr_dec			: out std_logic;	-- Decrement counter/register (active high)
		ctr_ld			: out std_logic;	-- Load counter/register (active high)
		selblk_aux1	: out std_logic;  -- Select block AUX1 function (active high)
		rst_seqc_n	: out std_logic;  -- SEQC controlled reset (active low)
		--Data Outputs
		dsi					: out std_logic_vector(7 downto 0);   -- Data to DSL (DSOURCE CU)
		rin					: out std_logic_vector(7 downto 0);	-- Counter/register input --CJ
		--Microprogram address output
		mpa					: out std_logic_vector(7 downto 0));	-- Mpgm address to memories --CJ
end;

architecture rtl of sct is
	-- Internally generated reset signals
	signal rst_clc			: std_logic;	-- Active high reset of stack ctr and mpa
	signal rst_err			: std_logic;	-- Active high reset on error
	-- Overlapping mpgm fields
	signal pl_map				: std_logic_vector(3 downto 0);		-- MAP field (AD(3:0))
	signal pl_aux1			: std_logic_vector(2 downto 0);		-- AUX1 field (COND(4:2))
	signal pl_aux2			: std_logic_vector(1 downto 0);		-- AUX2 field (COND(1:0))
	signal pl_bitmsk		: std_logic_vector(3 downto 0);		-- BITMSK field (COND(3:0))
	-- Address select signals
	signal rin_sel			: std_logic_vector(2 downto 0);		-- rin source select
	signal rin_short		: std_logic;	-- Set high four bits of rin to zero
	signal shmadis			: std_logic;	-- Disable bitmask
	signal ds_ctr				: std_logic;	-- Enable stack ctr/counter read
	-- Address selector outputs
	signal rin_mux			: std_logic_vector(7 downto 0);		-- rin source mux output
	-- Intermediate stack/counter control signals
	signal seq_pop			: std_logic;	-- SEQC controlled pop	
	signal seq_may_pop	: std_logic;	-- Possible SEQC controlled pop
	signal seq_des			: std_logic;	-- SEQC controlled stack ctr decr
	signal seq_psh			: std_logic;	-- SEQC controlled push
	signal seq_may_psh	: std_logic;	-- Possible SEQC controlled push
	signal seq_pop_des	: std_logic;	-- SEQC controlled pop or stack ctr decr
	signal seq_dec			: std_logic;	-- SEQC controlled counter decrement
	signal aux_des			: std_logic;	-- AUX controlled stack ctr decr
	signal aux_psh			: std_logic;	-- AUX controlled push
	signal aux_ins			: std_logic;	-- AUX controlled stack ctr incr
	signal aux_psh_ins	: std_logic;	-- AUX controlled push or stack ctr incr 
	signal aux_dec			: std_logic;	-- AUX controlled counter decrement
	-- Other internal signals
	signal auxfunc			: std_logic;	-- AUX stack/ctr functions enabled
	--signal plus1				: std_logic;	-- Set on "plus 1" jumps
	signal req					: std_logic;	-- Reqest signal
	signal bad_plus			: std_logic;	-- Bad "plus 1" jump, to odd address
	signal err_plus			: std_logic;	-- Registered "plus 1" error signal
	signal err_pop			: std_logic;	-- Registered pop error signal
	signal err_push			: std_logic;	-- Registered push error signal
	signal errcode			: std_logic_vector(1 downto 0);		-- Error code
	signal rin_int			: std_logic_vector(11 downto 0);	-- Internal copy of rin
	signal ld_mpgm_int          : std_logic;  --CJ

begin
	-- Create named signals for overlapping microprogram fields.
	pl_map		<= pl_ad(3 downto 0);
	pl_aux1		<= pl_cond(4 downto 2);
	pl_aux2		<= pl_cond(1 downto 0);
	pl_bitmsk	<= pl_cond(3 downto 0);

--------------------------------------------------------------------------------
	-- Sequence control decode.
--------------------------------------------------------------------------------
	-- This process decodes the sequence control operation (SEQC field)
	-- and generates control signals to the address multiplexers, stack
	-- and counter/register.
	seqc_dec : process (rst_en, rst_err, pl_seqc, pl_cpol, pl_cond, pl_aux1,
											pl_aux2, pl_map, cond_pass, ctr_eq0, req,
											pc, rin_int, rout, sout)
		variable d_plus			: std_logic_vector(2 downto 0);
		variable pc_pc_pc		: std_logic_vector(7 downto 0); --CJ
		variable pc_pc_ri		: std_logic_vector(7 downto 0); --CJ
		variable pc_ri_ri		: std_logic_vector(7 downto 0); --CJ
		variable z_ri_ri		: std_logic_vector(7 downto 0); --CJ
		variable pc_rc_rc		: std_logic_vector(7 downto 0); --CJ
		variable st_st_st		: std_logic_vector(7 downto 0); --CJ
		variable plus1_int	: std_logic;
		variable mpa_int		: std_logic_vector(7 downto 0); --CJ
		variable mpa_lc        : std_logic_vector(7 downto 0);
	begin
		-- This intermediate vector is used when rin_sel should be controlled by
		-- cond(4) and map(3..2) (the "d PLUS (L/M)SHALF of.." operations).
		d_plus := pl_cond(4) & pl_map(3 downto 2);

		-- These intermediate vectors are used to assign different source
		-- combinations to the microprogram address in a convenient way.
		pc_pc_pc := pc;
		--pc_pc_ri := pc(13 downto 8) & rin_int(7 downto 0);  -- CJ
		pc_pc_ri := rin_int(7 downto 0);
		--pc_ri_ri := pc(13 downto 12) & rin_int;           --Removed by CJ
		pc_ri_ri := rin_int(7 downto 0); 
		--z_ri_ri  := "00" & rin_int;                       --Removed by CJ 
		z_ri_ri  := rin_int(7 downto 0);     
		--pc_rc_rc := pc(13 downto 12) & rout;              --CJ
		pc_rc_rc := rout;                                   --CJ
		st_st_st := sout;

		-- Default values
		rst_clc			<= not rst_en;	-- Default the same as rst_en (inverse polarity).
		rin_sel			<= RIN_AD;			-- Default is AD (rin low part driven from ad).
		rin_short		<= '0';	-- Default inactive (rin high part driven from ad, not 'Z').
		ds_ctr			<= '0';	-- Default inactive (stack ctr/counter read disabled).
		shmadis 		<= '1';	-- Default active (bitmask disabled).
		seq_pop			<= '0';	-- Default inactive (no SEQC controlled pop).
		seq_may_pop	<= '0';	-- Default inactive (no SEQC controlled possible pop).
		seq_des			<= '0';	-- Default inactive (no SEQC controlled stack ctr decr).
		seq_psh			<= '0';	-- Default inactive (no SEQC controlled push).
		seq_may_psh	<= '0';	-- Default inactive (no SEQC controlled possible push).
		seq_dec			<= '0';	-- Default inactive (no SEQC controlled counter decrement).
		ctr_ld			<= '0';	-- Default inactive (no counter load).
		auxfunc 		<= '0';	-- Default inactive (no AUX stack/ctr functions enabled).	
		selblk_aux1 <= '0';	-- Default inactive (no AUX select block enabled).
		plus1_int		:= '0';	-- Default inactive (no "PLUS 1" function selected).
		rst_seqc_n	<= '1';	-- Default inactive (no SEQC controlled reset).
		
		case pl_seqc is
			when SEQC_RESET =>				-- (00) RESET
				if pl_cpol = '0' then
					rin_sel <= RIN_Z;			-- Makes low part (7..0) of address zero	
					rin_short <= '1';			-- Makes middle part (11..8) of address zero
					mpa_int := z_ri_ri;		-- Makes high part (13..12) of address zero		
					rst_clc	<= '1';				-- CLC reset.
					rst_seqc_n	<= '0';		-- SEQC controlled reset out to CRB.
				else
					rin_sel <= d_plus;		-- d PLUS (L/M)SHALF OF Y/IRA/IR/MEM/SP..
					shmadis <= '0';				-- ..WITH BITMASK nnnn
					seq_may_psh <= '1';		-- Conditional push
					if req = '1' then
						mpa_int := pc_pc_ri;-- Jump short if req
						seq_psh <= '1';			-- Push if req
					else
						mpa_int := pc_pc_pc;-- Continue if not req
					end if;
				end if;
			------------------------------------------------------------------------
			when SEQC_CONTINUE =>			-- (01) CONTINUE
				if pl_cpol = '0' then
					if pl_aux2(0) = '1' then
						ds_ctr <= '1';			-- Aux func: DSOURCE CSTACKL/CTRL/CSTACKH/CTRH
					end if;
					if pl_aux2(1) = '1' then
						rin_sel <= RIN_DI;	-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
					end if;								-- Otherwise aux func: DSOURCE DATA0
					auxfunc <= '1';				-- Auxillary stack/counter functions enabled
				else
					rin_sel <= d_plus;		-- Aux func: DSOURCE d PLUS ..	
					shmadis <= '0';				-- WITH BITMASK nnnn
				end if;
				mpa_int := pc_pc_pc;		-- Always continue
			------------------------------------------------------------------------
			when SEQC_SKIP =>					-- (02) SKIP IF cond
				rin_sel <= RIN_DI;			-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
				mpa_int := pc_pc_pc;		-- Always continue
				plus1_int := '1';				-- This is a "PLUS 1" function
			------------------------------------------------------------------------
			when SEQC_UGOTO =>				-- (03) UNC GO TO d
				auxfunc <= '1';					-- Auxillary stack/counter functions enabled
				mpa_int := pc_pc_ri;		-- Always jump short
			------------------------------------------------------------------------
			when SEQC_LGOTOPLS1 =>		-- (04) LGO TO ad, PLUS 1 IF cond
				mpa_int := pc_ri_ri;		-- Always jump long
				plus1_int := '1';				-- This is a "PLUS 1" function
			------------------------------------------------------------------------
			when SEQC_ULGOTO =>				-- (05) UNC LGO TO ad
				auxfunc <= '1';					-- Auxillary stack/counter functions enabled
				mpa_int := pc_ri_ri;		-- Always jump long
			------------------------------------------------------------------------
			when SEQC_GOTO =>					-- (06) GO TO d IF cond
				if cond_pass = '1' then
					mpa_int := pc_pc_ri;	-- Jump short on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
			------------------------------------------------------------------------
			when SEQC_EGOTOSTD =>			-- (07) GO TO d IF cond, ELSE TO STORED
				if cond_pass = '1' then
					mpa_int := pc_pc_ri;	-- Jump short on pass
				else
					mpa_int := pc_rc_rc;	-- To stored on fail
				end if;
			------------------------------------------------------------------------
			when SEQC_LGOTO =>				-- (08) LGO TO ad IF cond --Replace with microcode loading process.--CJ
			    if ld_mpgm = '1' then
					if dfm_vld = '1' then
						mpa_int := pc_pc_pc;
					elsif dfm_vld = '0' and vldl = '1' then
						mpa_int := mpa_lc;
					else 
					    mpa_int := pc_ri_ri;
					    mpa_lc  := pc_ri_ri;
					end if;
				elsif cond_pass = '1' then
					mpa_int := pc_ri_ri;	-- Jump long on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
			------------------------------------------------------------------------
			when SEQC_UDO =>					-- (09) UNC DO d
				if pl_aux1(0) = '0' then
					auxfunc <= '1';				-- Auxillary stack/counter functions enabled
				else
					selblk_aux1 <= '1';		-- Select block replaces pushing aux funcs
				end if;
				mpa_int := pc_pc_ri;		-- Always jump short
				seq_may_psh <= '1';			-- Unconditional push
				seq_psh <= '1';					-- Always push
			------------------------------------------------------------------------
			when SEQC_LDOPLS1 =>			-- (0A) LDOPLUS1 d, IF cond
				mpa_int := pc_ri_ri;		-- Always jump long
				seq_may_psh <= '1';			-- Unconditional push
				seq_psh <= '1';					-- Always push
				plus1_int := '1';				-- This is a "PLUS 1" function
			------------------------------------------------------------------------
			when SEQC_ULDO =>					-- (0B) UNC LDO ad
				if pl_aux1(0) = '0' then
					auxfunc <= '1';				-- Auxillary stack/counter functions enabled
				else
					selblk_aux1 <= '1';		-- Select block replaces pushing aux funcs
				end if;
				mpa_int := pc_ri_ri;		-- Always jump long
				seq_may_psh <= '1';			-- Unconditional push
				seq_psh <= '1';					-- Always push
			------------------------------------------------------------------------
			when SEQC_DO =>						-- (0C) DO d IF cond
				if cond_pass = '1' then
					mpa_int := pc_pc_ri;	-- Jump short on pass
					seq_psh <= '1';				-- Push on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
				seq_may_psh <= '1';			-- Conditional push
			------------------------------------------------------------------------
			when SEQC_EDOSTD =>				-- (0D) DO d IF cond, ELSE DO STORED
				if cond_pass = '1' then
					mpa_int := pc_pc_ri;	-- Jump short on pass
				else
					mpa_int := pc_rc_rc;	-- To stored on fail
				end if;
				seq_may_psh <= '1';			-- Unconditional push
				seq_psh <= '1';					-- Always push
			------------------------------------------------------------------------
			when SEQC_LDO =>					-- (0E) LDO ad IF cond
				if cond_pass = '1' then
					mpa_int := pc_ri_ri;	-- Jump long on pass
					seq_psh <= '1';				-- Push on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
				seq_may_psh <= '1';			-- Conditional push
			------------------------------------------------------------------------
			when SEQC_URETURN =>			-- (0F) UNC RETURN
				if pl_cpol = '0' then
					if pl_aux2(0) = '1' then
						ds_ctr <= '1';			-- Aux func: DSOURCE CSTACKL/CTRL/CSTACKH/CTRH
					end if;
					if pl_aux2(1) = '1' then
						rin_sel <= RIN_DI;	-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
					end if;								-- Otherwise aux func: DSOURCE DATA0
					auxfunc <= '1';				-- Auxillary stack/counter functions enabled
				else
					rin_sel <= d_plus;		-- Aux func: DSOURCE d PLUS ..	
					shmadis <= '0';				-- WITH BITMASK nnnn
				end if;
				mpa_int := st_st_st;		-- Always return
				seq_may_pop <= '1';			-- Unconditional pop
				seq_pop <= '1';					-- Always pop
			------------------------------------------------------------------------
			when SEQC_RETSKIP =>			-- (10) UNC RETURN & SKIP 1 IF cond
				rin_sel <= RIN_DI;			-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
				mpa_int := st_st_st;		-- Always return
				seq_may_pop <= '1';			-- Unconditional pop
				seq_pop <= '1';					-- Always pop
				plus1_int := '1';				-- This is a "PLUS 1" function
			------------------------------------------------------------------------
			when SEQC_RETURN =>				-- (11) RETURN IF cond
				rin_sel <= RIN_DI;			-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
				if cond_pass = '1' then
					mpa_int := st_st_st;	-- Return on pass
					seq_pop <= '1';				-- Pop on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
				seq_may_pop <= '1';			-- Conditional pop
			------------------------------------------------------------------------
			when SEQC_POPJUMP =>			-- (12) POPJUMP d IF cond
				if cond_pass = '1' then
					mpa_int := pc_pc_ri;	-- Jump short on pass
					seq_des <= '1';				-- Decrement stack counter on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
			------------------------------------------------------------------------
			when SEQC_UDECODE =>			-- (13) UNC xDECODE m
				auxfunc <= '1';					-- Auxillary stack/counter functions enabled
				if pl_map(3) = '0' then
					rin_sel <= RIN_Y;			-- YDECODE
				else
					rin_sel <= RIN_DI;		-- LZPCIRQDECODE/IRDECODE/MEMDECODE/SPDECODE
				end if;
				mpa_int := pc_ri_ri;		-- Always jump long
			------------------------------------------------------------------------
			when SEQC_DECODE =>				-- (14) xDECODE m IF cond
				if pl_map(3) = '0' then
					rin_sel <= RIN_Y;			-- YDECODE
				else
					rin_sel <= RIN_DI;		-- LZPCIRQDECODE/IRDECODE/MEMDECODE/SPDECODE
				end if;
				if cond_pass = '1' then
					mpa_int := pc_ri_ri;	-- Jump long on pass
				else
					mpa_int := pc_pc_pc;	-- Continue on fail
				end if;
			------------------------------------------------------------------------
			when SEQC_VECTOR =>				-- (15) (L)VECTOR.. (a)d, PLUS (L/M)SHALF OF x
				rin_sel <= d_plus;			-- (a)d PLUS (L/M)SHALF OF Y/IRA/IR/MEM/SP..	
				shmadis <= '0';					-- WITH BITMASK nnnn
				if pl_cpol = '1' then
					mpa_int := pc_ri_ri;	-- Jump long if cpol
				else
					mpa_int := pc_pc_ri;	-- Jump short if not cpol
				end if;
			------------------------------------------------------------------------
			when SEQC_STLC_PUSH =>		-- (16) STORE LOOP COUNT ad IF cond, & PUSH
				mpa_int := pc_pc_pc;		-- Always continue
				seq_may_psh <= '1';			-- Unconditional push
				seq_psh <= '1';					-- Always push
				if cond_pass = '1' then
					ctr_ld <= '1';				-- Load ctr on pass
				end if;
			------------------------------------------------------------------------
			when SEQC_STLC =>					-- (17) STORE LOOP COUNT ad/STORE LABEL d
				auxfunc <= '1';					-- Auxillary stack/counter functions enabled
				mpa_int := pc_pc_pc;		-- Always continue
				ctr_ld <= '1';					-- Always load ctr
				if pl_cpol = '0' then
					rin_short <= '1';			-- Load ctr short (8 bit) if not cpol
				end if;
			------------------------------------------------------------------------
			when SEQC_LDCTR =>				-- (18) (L)LOAD CTR FROM x
				auxfunc <= '1';					-- Auxillary stack/counter functions enabled
				if pl_map(3) = '0' then
					rin_sel <= RIN_Y;			-- FROM Y
				else
					rin_sel <= RIN_DI;		-- FROM LZPCIRQ/IR/MEM/SP
				end if;
				mpa_int := pc_pc_pc;		-- Always continue
				ctr_ld <= '1';					-- Always load ctr
				if pl_cpol = '0' then
					rin_short <= '1';			-- Load ctr short (8 bit) if not cpol
				end if;
			------------------------------------------------------------------------
			when SEQC_RCUC0 =>				-- (19) REPEAT CSTACK UNTIL CTR=0
				if pl_cpol = '0' then
					if pl_aux2(0) = '1' then
						ds_ctr <= '1';			-- Aux func: DSOURCE CSTACKL/CTRL/CSTACKH/CTRH
					end if;
					if pl_aux2(1) = '1' then
						rin_sel <= RIN_DI;	-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
					end if;								-- Otherwise aux func: DSOURCE DATA0
					auxfunc <= '1';				-- Auxillary stack/counter functions enabled
				else
					rin_sel <= d_plus;		-- Aux func: DSOURCE d PLUS ..	
					shmadis <= '0';				-- WITH BITMASK nnnn
				end if;
				if ctr_eq0 = '1' then
					mpa_int := pc_pc_pc;	-- Continue if CTR=0
					seq_des <= '1';				-- Decrement stack counter if CTR=0
				else
					mpa_int := st_st_st;	-- Return if CTR>0
					seq_dec <= '1';				-- Decrement ctr if CTR>0
				end if;
			------------------------------------------------------------------------
			when SEQC_RCP1UC0 =>			-- (1A) REPEAT CSTACK UNTIL CTR=0, & SKIP..
				rin_sel <= RIN_DI;			-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
				if ctr_eq0 = '1' then
					mpa_int := pc_pc_pc;	-- Continue if CTR=0
					seq_des <= '1';				-- Decrement stack counter if CTR=0
				else
					mpa_int := st_st_st;	-- Return if CTR>0
					seq_dec <= '1';				-- Decrement ctr if CTR>0
				end if;
				plus1_int := '1';				-- This is a "PLUS 1" function
			------------------------------------------------------------------------
			when SEQC_CCERC =>				-- (1B) PROCEED IF cond, ELSE REPEAT CSTACK
				rin_sel <= RIN_DI;			-- Aux func: DSOURCE LZPCIRQ/IR/DFM/SPCMD
				if cond_pass = '1' then
					mpa_int := pc_pc_pc;	-- Continue on pass
					seq_des <= '1';				-- Decrement stack counter on pass
				else
					mpa_int := st_st_st;	-- Return on fail
				end if;
			------------------------------------------------------------------------
			when SEQC_RDUC0 =>				-- (1C) REPEAT FROM d UNTIL CTR=0
				auxfunc <= '1';					-- Auxillary stack/counter functions enabled
				if ctr_eq0 = '1' then
					mpa_int := pc_pc_pc;	-- Continue if CTR=0
				else
					mpa_int := pc_pc_ri;	-- Jump short if CTR>0
					seq_dec <= '1';				-- Decrement ctr if CTR>0
				end if;
			------------------------------------------------------------------------
			when SEQC_RDP1UC0 =>			-- (1D) REPPLUS1 FROM d, IF cond, UNTIL CTR=0
				if ctr_eq0 = '1' then
					mpa_int := pc_pc_pc;	-- Continue if CTR=0
				else
					mpa_int := pc_pc_ri;	-- Jump short if CTR>0
					seq_dec <= '1';				-- Decrement ctr if CTR>0
				end if;
				plus1_int := '1';				-- This is a "PLUS 1" function
			------------------------------------------------------------------------
			when SEQC_CCC0DERC =>			-- (1E) IF cond CONT, ELSE IF CTR=0 GO TO d ..
				if cond_pass = '1' then
					mpa_int := pc_pc_pc;	-- Continue on pass
				else
					if ctr_eq0 = '1' then
						mpa_int := pc_pc_ri;-- Jump short if fail and CTR=0
						seq_des <= '1';			-- Decrement stack counter if fail and CTR=0
					else
						mpa_int := st_st_st;-- Return if fail and CTR>0
						seq_dec <= '1';			-- Decrement ctr if fail and CTR>0
					end if;
				end if;
			------------------------------------------------------------------------
			when SEQC_C0CCDERC =>			-- (1F) IF CTR=0 CONT, ELSE GO TO d IF cond ..
				if ctr_eq0 = '1' then
					mpa_int := pc_pc_pc;	-- Continue if CTR=0
					seq_des <= '1';				-- Decrement stack counter if CTR=0
				else
					if cond_pass = '1' then
						mpa_int := pc_pc_ri;-- Jump short if pass and CTR>0
					else
						mpa_int := st_st_st;-- Return if fail and CTR>0
						seq_dec <= '1';			-- Decrement ctr if fail and CTR>0
					end if;
				end if;
			------------------------------------------------------------------------
			when others => null;   							
		end case;

		-- Highest priority - on stack error or "plus 1" error jump to address
		-- determined by the errcode signal.
		if rst_err = '1' then	-- Reset state (same as SEQC_RESET with cpol = 0)
			rin_sel <= RIN_Z;		-- Makes low part (7..0) of address zero + errcode	
			rin_short <= '1';		-- Makes middle part (11..8) of address zero
			mpa_int := z_ri_ri;	-- Makes high part (13..12) of address zero		
		end if;

		-- Least significant bit of mpa is or:ed with plus1 and cond_pass,
		-- to implement conditional PLUS 1 jumps. 
		--plus1 <= plus1_int;
		mpa <= mpa_int(7 downto 1) & (mpa_int(0) or (plus1_int and cond_pass));
		bad_plus <= mpa_int(0) and plus1_int;
	end process seqc_dec;

--------------------------------------------------------------------------------
	-- Auxiliary function decode.
--------------------------------------------------------------------------------
	-- This process decodes the auxiliary functions (in AUX1) associated
	-- with certain sequence control operations (denoted by the auxfunc signal)
	-- and generates control signals to the stack and counter/register.
	aux_proc : process (auxfunc, pl_aux1)
	begin
		-- Default values
		aux_des	<= '0';	-- Default inactive (no AUX controlled stack ctr decr).
		aux_psh	<= '0';	-- Default inactive (no AUX controlled push).
		aux_ins	<= '0';	-- Default inactive (no AUX controlled stack ctr incr).
		aux_dec	<= '0';	-- Default inactive (no AUX controlled counter decrement).

		if auxfunc = '1' then
			case pl_aux1 is
				when AUX1_POPCSTACK =>	-- (1) POP CSTACK
					aux_des	<= '1';
				when AUX1_DECTR =>			-- (2) DECREMENT CTR
					aux_dec	<= '1';
				when AUX1_POPDECTR =>		-- (3) POP AND DECREMENT CTR
					aux_des	<= '1';
					aux_dec	<= '1';
				when AUX1_INST =>				-- (4) INCREMENT STCTR
					aux_ins	<= '1';
				when AUX1_PUSHCSTACK =>	-- (5) PUSH CSTACK
					aux_psh	<= '1';
				when AUX1_WHENSPREQ =>	-- (6) WHEN SPREQ
					 null;
				when AUX1_PUSHDECTR =>	-- (7) PUSH CSTACK & DECREMENT CTR
					aux_psh	<= '1';
					aux_dec	<= '1';
				when others => null;   							
			end case;
		end if;
	end process;

--------------------------------------------------------------------------------
	-- Counter/register input (rin) selection.
--------------------------------------------------------------------------------
	-- This process implements the rin mux, used to select the source
	-- of the low 8 bits of the rin bus depending on the rin_sel signal
	-- from the sequence control decoding.
	process (rin_sel, pl_ad, y_reg, di, errcode, ira2, ira1)
	begin
		case rin_sel is
			when RIN_Z =>			-- 000
				rin_mux(7 downto 4) <= "0000";
				rin_mux(3 downto 0) <= "00" & errcode;
			when RIN_Y =>			-- 001
				rin_mux(7 downto 4) <= y_reg(7 downto 4);
				rin_mux(3 downto 0) <= y_reg(3 downto 0);
			when RIN_AD =>		-- 010
				rin_mux(7 downto 4) <= pl_ad(7 downto 4);
				rin_mux(3 downto 0) <= pl_ad(3 downto 0);
			when RIN_DI =>		-- 011
				rin_mux(7 downto 4) <= di(7 downto 4);
				rin_mux(3 downto 0) <= di(3 downto 0);
			when RIN_spare =>	-- 100
				rin_mux(7 downto 4) <= "0000";
				rin_mux(3 downto 0) <= "----";
			when RIN_YM =>		-- 101
				rin_mux(7 downto 4) <= y_reg(7 downto 4);
				rin_mux(3 downto 0) <= y_reg(7 downto 4);
			when RIN_IRA =>		-- 110
				rin_mux(7 downto 4) <= pl_ad(7 downto 4);
				rin_mux(3 downto 0) <= '0' & ira2 & ira1 & '0';
			when RIN_DIM =>		-- 111
				rin_mux(7 downto 4) <= di(7 downto 4);
				rin_mux(3 downto 0) <= di(7 downto 4);
			when others => null;   							
		end case;
	end process;
	
	-- High part of rin is always taken from the ad field, except when the
	-- counter/register is loaded short (rin_short set), in which case it
	-- is set to zero.
	--rin_int(11 downto 8)	<= pl_ad(11 downto 8) when rin_short = '0' else (others => '0');--Deleted by CJ

	-- Middle part of rin is taken from the rin mux except when using a "d
	-- PLUS (L/M)SHALF OF .." construct (shmadis not set), in which case
	-- it is taken from the ad field.
	rin_int(7 downto 4)		<= rin_mux(7 downto 4) when shmadis = '1' else pl_ad(7 downto 4);

	-- Low part of rin is always taken from the rin mux, but masked by bitmsk
	-- if shmadis is not set (".. WITH BITMASK nnnn" construct).
	rin_int(3)						<= rin_mux(3) when shmadis = '1' or pl_bitmsk(3) = '1' else '0';
	rin_int(2)						<= rin_mux(2) when shmadis = '1' or pl_bitmsk(2) = '1' else '0';
	rin_int(1)						<= rin_mux(1) when shmadis = '1' or pl_bitmsk(1) = '1' else '0';
	rin_int(0)						<= rin_mux(0) when shmadis = '1' or pl_bitmsk(0) = '1' else '0';
	rin <= rin_int(7 downto 0);

	-- Request signal used by SEQC_RESET, will cause BREAK calls if any unmasked
	-- bits of the selected rin source nibble are set.
	req <= '0' when rin_int(3 downto 0) = "0000" else '1';

--------------------------------------------------------------------------------
	-- DSOURCE CU (dsi) selection.
--------------------------------------------------------------------------------
	-- The dsi bus is always taken from the low eight bits of rin except
	-- when ds_ctr is set, in which case it selects high or low half of
	-- the current stack word or the counter/register.
	dsi_mux : process (ds_ctr, pl_map, sout, st_empty, rout, rin_int)
	begin
		if ds_ctr = '1' then 
			case pl_map(3 downto 2) is
				when DS_CSTACKL	=>	-- (0) DSOURCE CSTACKL
					dsi <= sout(7 downto 0);
				when DS_CTRL	=>		-- (1) DSOURCE CTRL
					dsi <= rout(7 downto 0);
				--when DS_CSTACKH	=>	-- (2) DSOURCE CSTACKH                             
				--	dsi <= st_empty & '0' & sout(13 downto 8);	-- Stack empty in high bit
				--when DS_CTRH	=>		-- (3) DSOURCE CTRH
				--	dsi <= "0000" & rout(11 downto 8);
				when others => null;
			end case;
		else
			dsi <= rin_int(7 downto 0);
		end if;
	end process;

--------------------------------------------------------------------------------
	-- Generation of stack and counter/register control signals.
--------------------------------------------------------------------------------
	-- Combine stack and counter/register control signals from sequence
	-- control decode and auxiliary function decode. Both st_pop and
	-- st_push are activated at reset, to reset the stack. SEQC contolled
	-- pop or decrement stack operations block AUX controlled push or
	-- increment stack operations, to avoid unintentionally resetting the
	-- stack.
	seq_pop_des	<= seq_pop or seq_des;	-- Intermediate signal
	aux_psh_ins	<= aux_psh or aux_ins;	-- Intermediate signal	
	st_pop 	<= rst_clc or seq_pop_des or aux_des;
	st_push	<= rst_clc or seq_psh or (aux_psh_ins and not seq_pop_des);
	st_we_n	<= not(seq_psh or (aux_psh and not seq_pop_des));	-- Active low						
	ctr_dec	<= seq_dec or aux_dec;												

--------------------------------------------------------------------------------
	-- Error handling.
--------------------------------------------------------------------------------
	-- The err_plus signal is set if the destination of a "plus 1" jump
	-- is an odd address. The flip-flop is needed to avoid a combinatorial
	-- loop. Signal err_pop is set on pop from empty stack, err_push on
	-- push on full stack. Note that not taken conditional push/pop on
	-- full/empty stack is also considered an error. Incrementing/decrementing
	-- the stack counter without writing/reading the stack does not generate
	-- error however, even if the stack is full/empty. The stack counter is
	-- supposed to never wrap from empty to full.
	process (clk_p, rst_en)
	begin
	    if rising_edge(clk_p) then
            if rst_en = '0' then
                err_plus <= '0';
                err_pop <= '0';
                err_push <= '0';
		    elsif clk_e_pos = '0' then 
			    err_plus <= bad_plus;
			    err_pop <= seq_may_pop and st_empty; 
			    err_push <=	(seq_may_psh or (aux_psh and not seq_pop_des)) and st_full; 
			end if;
		end if;
	end process;

	-- The rst_err signal goes active (high) if the external reset is activated
	-- or a stack error (push on full stack, pop from empty stack) or a "plus 1"
	-- error occurs. It will force the microprogram address to a location
	-- determined by the error code. 
	rst_err <=	not rst_en or	err_plus or	err_pop or err_push; 
	
	-- This process generates the error code used on rst_err.
	process (err_plus, err_pop, err_push)
	begin
    if err_plus = '1' then 
			errcode <= "11";				-- "plus 1" error, jump to address 0003
		elsif err_pop = '1' then
			errcode <= "01";				-- Pop error, jump to address 0001
		elsif err_push = '1' then
			errcode <= "10";				-- Push error, jump to address 0002
		else
			errcode <= "00";				-- No error
		end if;
	end process;
end;

																																																																																																																																
