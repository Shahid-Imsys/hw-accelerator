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
-- Title      : Microprogram memory address mapping
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pe1_mpgm.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: The 'pe1_mpgm' block handles control signals to microprogram
--              ROM/RAM.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		3.2				CB			Created
-- 2005-12-21		3.3				CB			Changed polarity of memory control signals.
-- 2006-02-03		3.4				CB			Changed back polarity of pmem_ce.
-- 2006-05-04		3.5				CB			Changed from using D-bus to using LATCH as
--																address for MPRAM and PMEM when writing to
--																them during self-load.
-- 2013-01-14       4.0             MN          Changed pe1_mpgm for core2, remove plsel_n, lmpen, lmpwe_n, latch
-- 2015-06-26 		6.0             HYX		    delete held_e = 0 when generating mprom_ce_int
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity pe1_ampgm is
	port (
		-- Clock and reset
		core2_en    : in std_logic;
		rst_cn      : in  std_logic;
		clk_p       : in  std_logic;
		clk_e_neg       : in  std_logic;
		-- Control signals
		even_c      : in  std_logic;  -- High during even clk_c cycles
		held_e      : in  std_logic;  -- High when clk_e is held
		en_pmem     : in  std_logic;  -- Enable patch memory, from CRB
		-- Inputs
		mpga        : in  std_logic_vector(7 downto 0);  -- from CLC, pe1_mpgm address
		-- Outputs to MPRAM/MPROM
		mpram_a     : out std_logic_vector(7 downto 0);  -- MPG RAM address
		mprom_oe    : out std_logic_vector(1 downto 0);   -- ROM output enable (active high)
		mpram_oe    : out std_logic_vector(1 downto 0);   -- RAM output enable (active high)
		mpram_ce    : out std_logic_vector(1 downto 0);		-- RAM chip enable (active high)
		-- Outputs to PMEM
		pmem_q      : in  std_logic_vector(1 downto 0));   									-- PMEM chip enable (active low)
end pe1_ampgm;

architecture rtl of pe1_ampgm is
	signal mprom_ce_int   : std_logic_vector(1 downto 0);
	signal mpram_ce_int   : std_logic_vector(1 downto 0);
	signal oe_sel  				: std_logic_vector(1 downto 0);
	signal pmem_ce_nint		: std_logic;
	signal patch_en				: std_logic;
	signal patched				: std_logic;
	signal patch_addr			: std_logic_vector(13 downto 0);
	signal ram_addr				: std_logic_vector(7 downto 0);

begin  -- rtl
	-- Address muxes
	--patch_addr <=	mpga when patched = '0' else
	--							"00111" & pmem_q & mpga(6 downto 0);	-- When a ROM address is patched to RAM
--
	--ram_addr <=	patch_addr ;
	--
	--mpram_a <=	ram_addr;
	--
	--pmem_a(10) <= ram_addr(13);
	--pmem_a(9) <= 	ram_addr(11) when ram_addr(13) = '1' else
	--				ram_addr(12);
	--pmem_a(8 downto 0) <= ram_addr(10 downto 2);

	-- Microprogram RAM address
--  mpram_a <=	mpga										when lmpen = '0' and patched_ff = '0' else
--							latch(5 downto 0) & ybus when patched_ff = '0' else
--               & pmem_q & pe1_mpgm(6 downto 0);
--  patch_addr <=	mpga when patched_ff = '0' else
--								"01111" & pmem_q & mpga(6 downto 0);

--  mpram_a <= latch(5 downto 0) & y_reg when lmpen = '1' else
--             mpga;
	ram_addr <= mpga;
	mpram_a <= ram_addr;

	process (even_c, held_e, patch_addr,core2_en)
	begin
		--mprom_ce_int	<= "00";
		mpram_ce_int	<= "00";
--		if held_e = '0' and even_c = '1' and core2_en = '1' then	-- Generate CE on clk_e falling edge     --and even_c = '1'  2011-12-13 10:30:32 for maning
		if even_c = '1' and core2_en = '1' then
			-- Read access or SP write access
			--case patch_addr(13 downto 11) is
			--	when "000" =>                   -- Address 0000 to 07FF
			--		mprom_ce_int(0)  <= '1';      -- in ROM 0
			--	when "001" =>                   -- Address 0800 to 0FFF
			--		mpram_ce_int(0)  <= '1';      -- in RAM 0
			--	when "010" =>                   -- Address 1000 to 17FF
			--		mprom_ce_int(0)  <= '1';      -- in ROM 0
			--	when "011" =>                   -- Address 1800 to 1FFF
			--		mpram_ce_int(1)  <= '1';      -- in RAM 1
			--	when "100"|"101"|"110"|"111" => -- Address 2000 to 3FFF
			--		mprom_ce_int(1)  <= '1';      -- in ROM 1
			--	when others => null;
			--end case;
		mpram_ce_int <= "01";	--CJ

		end if;
	end process;
	--mprom_ce <= mprom_ce_int;
	mpram_ce <= mpram_ce_int;

	--process (mprom_ce_int, en_pmem)
	--begin
	--	pmem_ce_nint	<= '1';

	--	-- Read access or SP write access
	--	if (en_pmem = '1') and mprom_ce_int /= "00" then
	--		pmem_ce_nint <= '0';
	--	end if;

	--end process;
	--pmem_ce_n <= pmem_ce_nint;

	-- Output enable generation
	process (clk_p)
	begin
	    if rising_edge(clk_p) then
		    if rst_cn = '0' then
			    oe_sel <= "00";
		    elsif (clk_e_neg = '0') then   --falling edge of clk_e
			    --if mprom_ce_int(0) = '1' then
			    --	oe_sel <= "00";
			    --elsif mprom_ce_int(1) = '1' then
			    --	oe_sel <= "01";
			    --elsif mpram_ce_int(0) = '1' then
			    	oe_sel <= "10";
			    --else
			    --	oe_sel <= "11";
			    --end if;
			end if;
		end if;
	end process;

	mprom_oe(0) <= '1' when oe_sel = "00" and (even_c = '0' or held_e = '1') and core2_en = '1' else '0'; --
	mprom_oe(1) <= '1' when oe_sel = "01" and (even_c = '0' or held_e = '1') and core2_en = '1' else '0'; --
	mpram_oe(0) <= '1' when oe_sel = "10" and (even_c = '0' or held_e = '1') and core2_en = '1' else '0'; --
	mpram_oe(1) <= '1' when oe_sel = "11" and (even_c = '0' or held_e = '1') and core2_en = '1' else '0'; --

	-- Patch detection, disabled when writing
	--process (clk_p)
	--begin
	--    if rising_edge(clk_p) then
	--	    if rst_cn = '0' then
	--		    patch_en	<= '0';
	--	    elsif (clk_e_neg = '0') then   --falling edge of clk_e
	--		    patch_en	<= not pmem_ce_nint;
	--		end if;
	--	end if;
	--end process;

	--patched <= patch_en and (pmem_q(0) or pmem_q(1));

end rtl;
