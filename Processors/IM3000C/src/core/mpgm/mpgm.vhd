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
-- File       : mpgm.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The 'mpgm' block handles control signals to microprogram 
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
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mpgm is
	port (
		-- Clock and reset
		rst_cn      : in  std_logic;
		clk_e       : in  std_logic;
		-- Control signals
		even_c      : in  std_logic;  -- High during even clk_c cycles
		held_e      : in  std_logic;  -- High when clk_e is held
		plsel_n     : in  std_logic;  -- From CPC, low when SP controls PL
		lmpen       : in  std_logic;  -- From MMR, high when self-loading mpgm
		lmpwe_n     : in  std_logic;  -- From MPLL, low when self-load write
		en_pmem     : in  std_logic;  -- Enable patch memory, from CRB
		-- Inputs
		mpga        : in  std_logic_vector(13 downto 0);  -- from CLC, mpgm address
		latch       : in  std_logic_vector(7 downto 0);   -- Latch register, used when loading
		y_reg       : in  std_logic_vector(7 downto 0);   -- Y bus, used when loading   
		-- Outputs to MPRAM/MPROM
		mpram_a     : out std_logic_vector(13 downto 0);  -- MPG RAM address    
		mprom_oe    : out std_logic_vector(1 downto 0);   -- ROM output enable (active high)
		mpram_oe    : out std_logic_vector(1 downto 0);   -- RAM output enable (active high)
		mprom_ce    : out std_logic_vector(1 downto 0);   -- ROM chip enable (active high)
		mpram_ce    : out std_logic_vector(1 downto 0);		-- RAM chip enable (active high)
		-- Outputs to PMEM
		pmem_q      : in  std_logic_vector(1 downto 0);   -- PMEM output   
		pmem_a      : out std_logic_vector(10 downto 0);  -- PMEM address    
		pmem_ce_n   : out std_logic);   									-- PMEM chip enable (active high)
end mpgm;

architecture rtl of mpgm is
	signal mprom_ce_int   : std_logic_vector(1 downto 0);
	signal mpram_ce_int   : std_logic_vector(1 downto 0);
	signal oe_sel  				: std_logic_vector(1 downto 0);
	signal pmem_ce_nint		: std_logic;
	signal patch_en				: std_logic;
	signal patched				: std_logic;
	signal patch_addr			: std_logic_vector(13 downto 0);
	signal ram_addr				: std_logic_vector(13 downto 0);

begin  -- rtl
	-- Address muxes
	patch_addr <=	mpga when patched = '0' else
								"01111" & pmem_q & mpga(6 downto 0);	-- When a ROM address is patched to RAM

	ram_addr <=	patch_addr when lmpen = '0' else
							latch(5 downto 0) & y_reg;							-- When self-loading RAM
							
	mpram_a <=	ram_addr;
	
	pmem_a(10) <= ram_addr(1) when lmpen = '1' or plsel_n = '0' else
								ram_addr(13);
	pmem_a(9) <= 	ram_addr(0) when lmpen = '1' or plsel_n = '0' else
								ram_addr(11) when ram_addr(13) = '1' else
								ram_addr(12);
	pmem_a(8 downto 0) <= ram_addr(10 downto 2);

	-- Microprogram RAM address
--  mpram_a <=	mpga										when lmpen = '0' and patched_ff = '0' else
--							latch(5 downto 0) & ybus when patched_ff = '0' else
--               & pmem_q & mpgm(6 downto 0);
--  patch_addr <=	mpga when patched_ff = '0' else
--								"01111" & pmem_q & mpga(6 downto 0);

--  mpram_a <= latch(5 downto 0) & y_reg when lmpen = '1' else
--             mpga;


	process (even_c, held_e, patch_addr, lmpen, lmpwe_n, latch)
	begin
		mprom_ce_int	<= "00";
		mpram_ce_int	<= "00";
		if held_e = '0' and even_c = '1' then	-- Generate CE on clk_e falling edge

			-- Read access or SP write access			
			case patch_addr(13 downto 11) is
				when "000" =>                   -- Address 0000 to 07FF
					mprom_ce_int(0)  <= '1';      -- in ROM 0
				when "001" =>                   -- Address 0800 to 0FFF
					mpram_ce_int(0)  <= '1';      -- in RAM 0
				when "010" =>                   -- Address 1000 to 17FF
					mprom_ce_int(0)  <= '1';      -- in ROM 0
				when "011" =>                   -- Address 1800 to 1FFF
					mpram_ce_int(1)  <= '1';      -- in RAM 1
				when "100"|"101"|"110"|"111" => -- Address 2000 to 3FFF
					mprom_ce_int(1)  <= '1';      -- in ROM 1
				when others => null;
			end case;

			-- Self-load write access			
			if lmpen = '1' and lmpwe_n = '0' and latch(5) = '0' then
				if latch(4) = '0' then
					mpram_ce_int(0)  <= '1'; -- Write CE to RAM 0
				else
					mpram_ce_int(1)  <= '1'; -- Write CE to RAM 1
				end if;
			end if;
		end if;
	end process;
	mprom_ce <= mprom_ce_int;
	mpram_ce <= mpram_ce_int;

	process (even_c, held_e, mprom_ce_int, en_pmem, plsel_n, lmpen, lmpwe_n, latch)
	begin
		pmem_ce_nint	<= '1';

		-- Read access or SP write access			
		if (en_pmem = '1' or plsel_n = '0') and mprom_ce_int /= "00" then
			pmem_ce_nint <= '0';
		end if;

		-- Self-load write access			
		if held_e = '0' and even_c = '1' then	-- Generate CE on clk_e falling edge
			if lmpen = '1' and lmpwe_n = '0' and latch(5) = '1' then
				pmem_ce_nint <= '0'; -- Write CE to PMEM
			end if;
		end if;
	end process;
	pmem_ce_n <= pmem_ce_nint;

	-- Output enable generation
	process (clk_e, rst_cn)
	begin
		if rst_cn = '0' then
			oe_sel <= "00";
		elsif falling_edge(clk_e) then
			if mprom_ce_int(0) = '1' then
				oe_sel <= "00";
			elsif mprom_ce_int(1) = '1' then
				oe_sel <= "01";
			elsif mpram_ce_int(0) = '1' then
				oe_sel <= "10";
			else
				oe_sel <= "11";
			end if;
		end if;
	end process;

	mprom_oe(0) <= '1' when oe_sel = "00" and (even_c = '0' or held_e = '1') else '0';
	mprom_oe(1) <= '1' when oe_sel = "01" and (even_c = '0' or held_e = '1') else '0';
	mpram_oe(0) <= '1' when oe_sel = "10" and (even_c = '0' or held_e = '1') else '0';
	mpram_oe(1) <= '1' when oe_sel = "11" and (even_c = '0' or held_e = '1') else '0';

	-- Patch detection, disabled when writing
	process (clk_e, rst_cn)
	begin
		if rst_cn = '0' then
			patch_en	<= '0';
		elsif falling_edge(clk_e) then
			patch_en	<= not pmem_ce_nint and plsel_n and not lmpen;
		end if;
	end process;

	patched <= patch_en and (pmem_q(0) or pmem_q(1));
	
end rtl;
