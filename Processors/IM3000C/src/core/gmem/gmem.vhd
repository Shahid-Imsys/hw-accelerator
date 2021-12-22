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
-- Title      : gmem
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : gmem.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The GMEM consists general register blocks, string buffer,
--              machine stack and p-code stack as well as their pointers.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.8				CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mpgmfield_lib.all;

entity gmem is
	port(
		-- Clock and reset inputs
		rst_en			: in std_logic; -- Reset
		clk_e				: in std_logic;	-- Execution clock 
		gate_e			: in std_logic;	-- Copy of execution clock used for gating 
    held_e			:	in std_logic;	-- High when clk_e is held, multiple of 2 clk_c
		-- Microprogram fields
		pl_gapp			: in std_logic;                     --from instruction reg. 
		pl_pc				: in std_logic_vector(3 downto 0);  --from instruction reg. 
		pl_gass			: in std_logic_vector(1 downto 0);  --from instruction reg.
		pl_gasd			: in std_logic_vector(1 downto 0);  --from instruction reg. 
		pl_gacs			: in std_logic_vector(1 downto 0);  --from instruction reg.
		pl_gacd			: in std_logic_vector(1 downto 0);  --from instruction reg.
		mp_gass			: in std_logic_vector(1 downto 0);  --from microprogram word
		-- Static control inputs
		use_direct	: in std_logic; -- Selects 'direct' as bus driver
		dbl_direct	: in std_logic; -- Indicates 16-bits access
		g_double		: in std_logic; -- Double step control input
		--Control Inputs
		rd_gmem			: in std_logic; -- Indicates GMEM read access
		inv_psmsb		: in std_logic; -- Invert pstack msb from CLC
		--Data Inputs
		dbus				: in std_logic_vector(7 downto 0);  -- D bus
		ybus				: in std_logic_vector(7 downto 0);  -- Y bus
		direct			: in std_logic_vector(7 downto 0); -- GMEM/IOMEM input data bus
		--Control Outputs
		ira2				: out std_logic;  -- PSCTR carry-out flip-flop
		psc_afull		: out std_logic;  -- Pstack almost full flag
		psc_full		: out std_logic;  -- Pstack full flag
		psc_aempty	: out std_logic;  -- Pstack almost empty flag
		psc_empty		: out std_logic;  -- Pstack empty flag
		--Data Outputs
		gctr				: out std_logic_vector(7 downto 0); -- GMEM pointers output to DSL
		gdata				: out std_logic_vector(7 downto 0); -- Latched GMEM data bus to DSL
		g_direct		: out std_logic_vector(7 downto 0); -- GMEM output data bus
		-- GMEM signals
		gmem_ce_n		: out std_logic;
		gmem_we_n		: out std_logic;
		gmem_a			: out std_logic_vector(9 downto 0);
		gmem_d			: out std_logic_vector(7 downto 0);
		gmem_q			: in  std_logic_vector(7 downto 0)
		);
end;


architecture rtl of gmem is

	type   array_8 is array (3 downto 0) of std_logic_vector(7 downto 0);
	type   array_2 is array (3 downto 0) of std_logic_vector(1 downto 0);
	signal gctr_d				:	array_8;
	signal gctr_q				:	array_8;
	signal gctr_op			:	array_2;
	signal gctr_load    : array_8;
	signal gctr_cy      : std_logic_vector(3 downto 0);
	signal mp_gctr_src	: std_logic_vector(7 downto 0);
	signal gctr_src			: std_logic_vector(7 downto 0);
	signal gctr_dst			: std_logic_vector(7 downto 0);
	signal d_or_shadow	: std_logic_vector(7 downto 0);
	signal y_or_shadow	: std_logic_vector(7 downto 0);
	signal src_op				: std_logic_vector(1 downto 0);
	signal dst_op				: std_logic_vector(1 downto 0);
	signal shadow       : std_logic_vector(7 downto 0);  
	signal psctr_cy     : std_logic;  
	signal wr_gmem      : std_logic;  
	signal hold_we      : std_logic;  
	signal hold_rd      : std_logic;  
	signal hold_addr		: std_logic_vector(9 downto 0);
	signal hold_data		: std_logic_vector(7 downto 0);
	signal wr_addr      : std_logic_vector(9 downto 0);
	signal rd_addr      : std_logic_vector(9 downto 0);
	signal logic_addr   : std_logic_vector(9 downto 0);
	signal gmem_we_nint : std_logic;  
	signal gmem_re_n    : std_logic; 
	
begin

	-----------------------------------------------------------------------------
	-- GMEM pointers
	-----------------------------------------------------------------------------

	-- Source pointer operation. When GAPP is zero, GACS control source pointer
	-- operation. If GAPP is set and GACS = 2 or 3, GACD is used instead.
	-- Otherwise (push&load or pop) load. 
	src_op <= pl_gacs when pl_gapp = '0' else			
						pl_gacd when pl_gacs(1) = '1' else	
						"11";																
						 
	-- Dest pointer operation. When GAPP=0 or GACS(1)=0, dst ptr op = GACD.
	-- Otherwise (push&load or pop) load.
	dst_op <= pl_gacd when pl_gapp = '0' or pl_gacs(1) = '0' else 
						"11";																
		
	process (src_op, dst_op, mp_gass, pl_gass, pl_gasd, gctr_d, gctr_q)
	begin
		case mp_gass is
			when "00" =>	mp_gctr_src <= gctr_d(0);
			when "01" =>	mp_gctr_src <= gctr_d(1);
			when "10" =>	mp_gctr_src <= gctr_d(2);
			when "11" =>	mp_gctr_src <= gctr_d(3);
			when others => null;
		end case;

		for i in 0 to 3 loop

--			if mp_gass = i then
--				mp_gctr_src <= gctr_d(i);
--			end if;
			
			if pl_gass = i then
				gctr_src <= gctr_q(i);
			end if;
			
			if pl_gasd = i then
				gctr_dst <= gctr_q(i);
			end if;

			if pl_gass = i and src_op /= "00" then
				gctr_op(i) <=	src_op;
			elsif pl_gasd = i then  
				gctr_op(i) <=	dst_op;
			else
				gctr_op(i) <=	"00";
			end if;
		end loop;
	end process;
	gctr <= gctr_src;
	
	d_or_shadow	<=	shadow when pl_gapp = '1' and pl_gacs(0) = '1' else
									dbus;
	
	y_or_shadow	<=	shadow when pl_gapp = '1' and pl_gacs(0) = '1' else
									ybus;
	gctr_load(0) <= d_or_shadow;
	gctr_load(3 downto 1) <= (others => y_or_shadow);
	psctr_cy <= gctr_cy(3);

	-- Counter instantiations. Index 0 to 3 stands for BR, SBCTR, MSCTR and PSCTR. 
	gctr_gen: for i in 0 to 3 generate
		gctr: block
			signal gctr_d_int	: std_logic_vector(7 downto 0);
			signal gctr_q_int	: std_logic_vector(7 downto 0);
		begin  -- block gctr
			process (g_double, gctr_op(i), gctr_q_int, gctr_load(i)) 
			begin
				gctr_cy(i) <= '0';
				case gctr_op(i) is
					when "00" =>				-- No operation 
						gctr_d_int <= gctr_q_int; 
					when "01" =>				-- Increment 
						if g_double = '0' then
							gctr_d_int <= gctr_q_int + 1;
							if gctr_q_int = x"FF" then
								gctr_cy(i) <= '1';
							end if;
						else
							gctr_d_int <= gctr_q_int + 2; 
							if gctr_q_int(7 downto 1) = "1111111" then
								gctr_cy(i) <= '1';
							end if;
						end if;
					when "10" =>				-- Decrement 
						if g_double = '0' then
							gctr_d_int <= gctr_q_int - 1; 
							if gctr_q_int = x"00" then
								gctr_cy(i) <= '1';
							end if;
						else
							gctr_d_int <= gctr_q_int - 2; 
							if gctr_q_int(7 downto 1) = "0000000" then
								gctr_cy(i) <= '1';
							end if;
						end if;
					when "11" =>				-- Load 
						gctr_d_int <= gctr_load(i); 
					when others => null;
				end case;
			end process;

			process (clk_e) 
			begin
				if rising_edge(clk_e) then
					gctr_q_int <= gctr_d_int;
				end if;
			end process;

			gctr_d(i) <= gctr_d_int;
			gctr_q(i) <= gctr_q_int; 
			
		end block gctr;
	end generate gctr_gen;

	-- Shadow register
	process (clk_e)
	begin
		if rising_edge(clk_e) then
			if pl_gapp = '1' and pl_gacs(0) = '0' then
				if pl_gacs(1) = '0' then
					shadow <= gctr_src;
				else
					shadow <= gctr_dst;
				end if;
			end if;
		end if;
	end process;
	
	--carry-out from PSCTR (registered)
	process (clk_e)
	begin
		if rising_edge(clk_e) then
			if gctr_op(3) /= "00" then
				ira2 <= psctr_cy;
			end if;
		end if;
	end process;
	
	--Flags from PSCTR (combinatorial)
	PSCTR_flags: process (gctr_q(3))
	begin
		if gctr_q(3)(7 downto 3) = "00000" then   --PSCTR < 0x08
			psc_afull <= '1';                 --Pstack almost full flag
		else
			psc_afull <= '0';
		end if;

		if gctr_q(3) = x"00" then               --PSCTR = 0x00
			psc_full <= '1';                  --Pstack full flag
		else
			psc_full <= '0';
		end if;

		if gctr_q(3)(7 downto 3) = "11111" then   --PSCTR >= 0xF8
			psc_aempty <= '1';                --Pstack almost empty flag
		else
			psc_aempty <= '0';
		end if;

		if gctr_q(3) = x"FF" then               --PSCTR = 0xFF
			psc_empty <= '1';                 --Pstack empty flag
		else
			psc_empty <= '0';
		end if;
	end process;  


	-----------------------------------------------------------------------------
	-- GMEM address, data, wen, csn.
	-----------------------------------------------------------------------------
	wr_gmem <=	'1' when pl_pc = PC_WRITEGMEM else
							'0';

	-- Hold register for write address and data.
	hold_load: process (clk_e, rst_en)
	begin 
		if rst_en = '0' then
			hold_we <= '0';
			hold_rd <= '0';
		elsif rising_edge(clk_e) then
			hold_we <= '0';
			hold_rd <= '0';
			if rd_gmem = '1' then
				hold_rd <= '1';
			end if;
			if wr_gmem = '1' and dbl_direct = '0' then
				hold_we <= '1';
				hold_addr <= pl_gasd & gctr_dst;  
				if use_direct = '0' then
					hold_data <= ybus;  
				else
					hold_data <= direct;  
				end if;
			end if;
		end if;
	end process hold_load;

	wr_addr <=	hold_addr when dbl_direct = '0' else
							pl_gasd & gctr_dst(7 downto 1) & (gate_e xnor gctr_dst(0));

	rd_addr <=	mp_gass & mp_gctr_src when dbl_direct = '0' or gate_e = '0' else
							pl_gass & gctr_src(7 downto 1) & (not gctr_src(0));

	logic_addr <= wr_addr when gmem_we_nint = '0' else
								rd_addr;
	
	gmem_a(9 downto 8) <= logic_addr(9 downto 8);
	gmem_a(7) <=	logic_addr(7) when logic_addr(9 downto 8) /= "11" else
								logic_addr(7) xor inv_psmsb;
	gmem_a(6 downto 0) <= logic_addr(6 downto 0);
	
	gmem_we_nint <= not (((hold_we and gate_e) or (dbl_direct and wr_gmem)) and not held_e);
	gmem_we_n <= gmem_we_nint;

	gmem_re_n <= not ((rd_gmem and not gate_e) or (dbl_direct and hold_rd and gate_e and not held_e));

	gmem_ce_n <= gmem_we_nint and gmem_re_n;
	
	gmem_d <= direct when dbl_direct = '1' else hold_data;
	
	--latch RAM data output
	latch_gdata: process (clk_e, hold_rd, gmem_q)
	begin  
		if clk_e = '1' then
			if hold_rd = '1' then
				gdata <= gmem_q;
			end if;
		end if;
	end process latch_gdata;

	g_direct <= gmem_q;

end;
