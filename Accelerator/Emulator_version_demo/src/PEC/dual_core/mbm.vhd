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
-- Title      : Masker, Barrel shifter and Multiplier 
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : mbm.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The MBM block performs various logic functions such as mask,
--              shift and Multiply.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.2				CB			Created
-- 2006-05-04		2.3				CB			Changed the selctor for D and Y bit test from
--																mbs to pl_mbmop for timing reasons. Should not
--																affect functionality at all.
-- 2006-05-04		2.4				CB			Removed D bit test.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mpgmfield_lib.all;

entity mbm is
  port(  
    -- Clock input
    clk_p     : in      std_logic;
    clk_e_pos  : in      std_logic;                    -- Execution clock
    rst_en  : in std_logic;
    -- Microprogram fields
    pl        : in      std_logic_vector(79 downto 0);
    -- Control inputs
    ld_nreg     : in    std_logic;                    -- NREG load signal, from CLC
    -- Data inputs
    ybus      : in      std_logic_vector(7 downto 0); -- Y bus, from ALU
    y_reg     : in      std_logic_vector(7 downto 0); -- Y bus register, from ALU
    latch     : in      std_logic_vector(7 downto 0); -- Latch register, from DSL
    -- Data outputs
    mbmd      : out     std_logic_vector(7 downto 0); -- MBM output, to DSL
    y_bittst  : out     std_logic);                   -- Testbit from Y reg, to CLC
end;

architecture rtl of mbm is
  constant acc_len: integer := 24;      -- Length of accumulator register in bits
  
  signal mul_op   : std_logic;  -- High when multiplication operation performed
  signal shift_op : std_logic;  -- High when multi-byte shift operation performed

  signal nreg     : std_logic_vector(3 downto 0);       -- Shift count register
  signal mbs      : std_logic_vector(3 downto 0);       -- Shift count

  signal rot      : std_logic_vector(7 downto 0);       -- Barrel shifter output
  signal mask     : std_logic_vector(7 downto 0);       -- Bitmask generator output

  signal factor1  : signed(8 downto 0);         -- Multiplicator factor 1 (Y reg)
  signal factor2  : signed(8 downto 0);         -- Multiplicator factor 2 (latch)
  signal product  : signed(17 downto 0);                -- Multiplicator output

  signal ar       : std_logic_vector(acc_len-1 downto 0);  -- Accumulator register
  signal ar_in    : signed(acc_len-1 downto 0);   -- Accumulator input
  signal ar_out   : signed(acc_len-1 downto 0);   -- Accumulator output
  
  signal pl_miform_sig :      std_logic;
  signal pl_mbmop_sig  :      std_logic_vector(3 downto 0);
  signal pl_mapr_sig   :      std_logic_vector(3 downto 0);
  signal pl_data0_sig  :      std_logic_vector(7 downto 0);
  
begin
  ---------------------------------------------------------------------
  -- NREG
  ---------------------------------------------------------------------
  nreg_p : process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            nreg <= (others => '0');
        elsif ld_nreg = '1' and clk_e_pos = '0' then
            nreg <= ybus(3 downto 0);
      end if;
    end if;
  end process;               

  ---------------------------------------------------------------------
  -- MBS, controls MASK, BSH and testbit functions
  ---------------------------------------------------------------------
  pl_mbmop_sig <= (pl(7) xor pl(36))&(pl(8) xor pl(50))&(pl(30) xor pl(62))&(pl(29) xor pl(10));
  mbs_p : process (pl_mbmop_sig, nreg)
  begin
    if pl_mbmop_sig(3) = '0' then   -- LANDD0, ROTL1ANDD0..ROTL7ANDD0
      mbs <= pl_mbmop_sig;          -- Shift count controlled by MBMOP
    else                        -- otherwise 
      mbs <= nreg;              -- Shift count controlled by NREG
    end if;
  end process;

  ---------------------------------------------------------------------
  -- Barrel shifter and mask function
  ---------------------------------------------------------------------
  -- Three-stage barrel shifter, rotate 'latch' 'mbs' steps left to
  -- 'rot'. 
  rot_p: process (mbs, latch)
    variable sh0, sh1, sh2 : std_logic_vector(7 downto 0);
  begin
    if mbs(2) = '0' then        -- First stage
      sh2 := latch;
    else
      sh2 := latch(3 downto 0) & latch(7 downto 4);
    end if;
    if mbs(1) = '0' then        -- Second stage
      sh1 := sh2;
    else
      sh1 := sh2(5 downto 0) & sh2(7 downto 6);
    end if;
    if mbs(0) = '0' then        -- Third stage
      sh0 := sh1;
    else
      sh0 := sh1(6 downto 0) & sh1(7);
    end if;
    rot <= sh0;
  end process;

  -- Generate a bitmask depending on 'mbs' in 'mask'.   
  mask_p: process (mbs)
  begin
    case mbs is
      when "0000" => mask <= "11111111";
      when "0001" => mask <= "11111110";
      when "0010" => mask <= "11111100";
      when "0011" => mask <= "11111000";
      when "0100" => mask <= "11110000";
      when "0101" => mask <= "11100000";
      when "0110" => mask <= "11000000";
      when "0111" => mask <= "10000000";                      
      when "1000" => mask <= "00000000";
      when "1001" => mask <= "00000001";
      when "1010" => mask <= "00000011";
      when "1011" => mask <= "00000111";
      when "1100" => mask <= "00001111";
      when "1101" => mask <= "00011111";
      when "1110" => mask <= "00111111";
      when "1111" => mask <= "01111111";                      
      when others => null;
    end case;
  end process;
  
  ---------------------------------------------------------------------
  -- Multiplier 
  ---------------------------------------------------------------------
  pl_miform_sig <= pl(45);
  -- This signal is active when a multiplication operation is performed.
  mul_op <= '1' when    (pl_mbmop_sig = MBMOP_MUL1 or
                         pl_mbmop_sig = MBMOP_MUL2 or
                         pl_mbmop_sig = MBMOP_MUL3) and
            (pl_miform_sig = '1') else '0';

  -- Factor 1 to the signed multiplier is taken from the Y bus register.
  -- It is sign extended into the ninth bit if bit 3 of the MAPR field
  -- is set. It is cleared when no multiplication is performed.
  pl_mapr_sig <= pl(28)&pl(62)&(pl(26) xor pl(17))&(pl(3) xor pl(59));
  factor1(7 downto 0) <= signed(y_reg) when mul_op = '1' else (others => '0');
  factor1(8) <= y_reg(7) when pl_mapr_sig(3) = '1' and mul_op = '1' else '0';

  -- Factor 2 to the signed multiplier is taken from the latch register.
  -- It is sign extended into the ninth bit if bit 2 of the MAPR field
  -- is set.
  factor2(7 downto 0) <= signed(latch);
  factor2(8) <= latch(7) when pl_mapr_sig(2) = '1' else '0';

  -- The output of the multiplier is the signed product of the two factors.
  product <= factor1 * factor2;
  
  ---------------------------------------------------------------------
  -- Accumulator register
  ---------------------------------------------------------------------
  -- This signal is active when a multi-byte shift operation
  -- is performed.
  shift_op <= '1' when  (pl_mbmop_sig = MBMOP_FIRSTSHIFT or
                         pl_mbmop_sig = MBMOP_NEXTSHIFT) and
              (pl_miform_sig = '1') else '0';

  -- Select accumulator, accumulator/256 or zero as input to
  -- the accumulator addition, depending on the multiplication
  -- operation.
  ar_out_p: process (pl_mbmop_sig, ar)
  begin
    case pl_mbmop_sig is
      when MBMOP_MUL2 =>                -- MUL2, ar/256
        ar_out(acc_len-1 downto acc_len-8) <= (others => ar(acc_len-1));
        ar_out(acc_len-9 downto 0) <= signed(ar(acc_len-1 downto 8));
      when MBMOP_MUL3 =>               -- MUL3, ar
        ar_out <= signed(ar);                                                   
      when others =>                   -- MUL1 etc, zero
        ar_out <= (others => '0');
    end case;
  end process;

  -- Accumulator addition.
  ar_in <= ar_out + product;
  
  -- Accumulator is loaded from the accumulator addition in the
  -- multiplication     operations and from the masked barrel shift
  -- output in the multi-byte shift operations.
  ar_p: process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            ar <= (others => '0');
        elsif clk_e_pos = '0' then 
            if mul_op = '1' then            -- MUL1/2/3
              ar <= std_logic_vector(ar_in);
            elsif shift_op = '1' then -- FIRSTSHIFT and NEXTSHIFT
              ar(7 downto 0) <= rot and (not mask);
            end if;
        end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- MBMD output select 
  -----------------------------------------------------------------------------
  -- The MUL1 and MUL3 operations now emit zero for timing reasons,
  -- all output from multiplication must be taken out using the MUL2
  -- operation.
  pl_data0_sig <= (pl(58) xor pl(28))&pl(17)&pl(10)&pl(59)&(pl(4)  xor pl(76))&(pl(37) xor pl(75))&pl(13)&pl(24);
  mbmd_p : process (pl_mbmop_sig, y_reg, rot, pl_data0_sig, mask, ar)
  begin
    if pl_mbmop_sig(3) = '0' then           -- LANDD0, ROTL1ANDD0..ROTL7ANDD0
      mbmd <= rot and pl_data0_sig;         -- Rotated LATCH and DATA0 field
    else
      case pl_mbmop_sig is
        when MBMOP_YORD0 =>             -- Y register and DATA0 field
          mbmd <= y_reg or pl_data0_sig;                
        when MBMOP_ROTLATCH =>          -- Rotated LATCH
          mbmd <= rot;
        when MBMOP_MASKANDY =>          -- Mask and Y register
          mbmd <= mask and y_reg;
        when MBMOP_FIRSTSHIFT =>        -- Mask and rotated LATCH
          mbmd <= mask and rot;
        when MBMOP_NEXTSHIFT =>         -- Mask and rotated LATCH or ARL
          mbmd <= (mask and rot) or (ar(7 downto 0));
        when MBMOP_MUL2 =>              -- ARL
          mbmd <= ar(7 downto 0);
        when MBMOP_MUL1|MBMOP_MUL3 =>
          mbmd <= x"00";
        when others => null;
      end case;      
    end if;      
  end process;  

  ---------------------------------------------------------------------
  -- Testbits from D bus and Y register
  ---------------------------------------------------------------------
  -- Microprogram command TESTBIT sets pl_mbmop=0-7 -> mbs:=pl_mbmop(2:0)
  bittest_p : process (pl_mbmop_sig, y_reg)           
  begin
    case pl_mbmop_sig(2 downto 0) is
      when "000"  => y_bittst <= y_reg(0);
      when "001"  => y_bittst <= y_reg(1);
      when "010"  => y_bittst <= y_reg(2);
      when "011"  => y_bittst <= y_reg(3);
      when "100"  => y_bittst <= y_reg(4);
      when "101"  => y_bittst <= y_reg(5);
      when "110"  => y_bittst <= y_reg(6);
      when "111"  => y_bittst <= y_reg(7);
      when others => null;             
    end case;
  end process;
  
end;



