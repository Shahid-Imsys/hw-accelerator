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
-- Title      : alu
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : alu.vhd
-- Author     : Xing Zhao, Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The ALU consists of an 8-bit function generator, a 32x8-bit
--              register, the Q register (8 bit) and the Flag register.
-- 
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date                                 Version         Author  Description
-- 2005-11-28           3.3                             CB                      Created
-- 2012-08-16           4.0                             MN                      Added reset signal
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.mpgmfield_lib.all;

entity alu is
  port(
    -- Clock input
    clk_p      : in  std_logic;
    clk_e_pos  : in  std_logic;         -- Clock input           
    rst_n      : in  std_logic;         -- reset input added by maning
    -- Microprogram fields
    pl         : in  std_logic_vector(79 downto 0);  -- uProg word field
    --Data inputs
    dbus       : in  std_logic_vector(7 downto 0);   -- D bus
    -- Flags
    flag_fn    : out std_logic;
    flag_fc    : out std_logic;
    flag_fz    : out std_logic;
    flag_fv    : out std_logic;
    flag_fh    : out std_logic;
    flag_fp    : out std_logic;
    flag_neg   : out std_logic;
    flag_carry : out std_logic;
    flag_zero  : out std_logic;
    flag_oflow : out std_logic;
    flag_link  : out std_logic;
    flag_pccy  : out std_logic;
    flag_qlsb  : out std_logic;
    --Data outputs
    ybus       : out std_logic_vector(7 downto 0);   -- Y bus
    y_reg      : out std_logic_vector(7 downto 0));  -- Registered Y bus
end;

architecture rtl of alu is
  signal b_in           : std_logic_vector(7 downto 0);
  signal a_out          : std_logic_vector(7 downto 0);
  signal a              : std_logic_vector(7 downto 0);
  signal b              : std_logic_vector(7 downto 0);
  signal s              : std_logic_vector(7 downto 0);
  signal re             : std_logic_vector(7 downto 0);
  signal f              : std_logic_vector(7 downto 0);
  signal q_in           : std_logic_vector(7 downto 0);
  signal q              : std_logic_vector(7 downto 0);
  signal c_in           : std_logic;
  signal flag_ac        : std_logic;
  signal flag_az        : std_logic;
  signal flag_yz        : std_logic;
  signal flag_av        : std_logic;
  signal flag_ah        : std_logic;
  signal flag_ap        : std_logic;
  signal flag_yp        : std_logic;
  signal sel_flag       : std_logic;
  signal flag_yan       : std_logic;
  signal flag_yac       : std_logic;
  signal flag_yaz       : std_logic;
  signal flag_yav       : std_logic;
  signal flag_yap       : std_logic;
  signal shift_out      : std_logic;
  signal b_shift_in     : std_logic;
  signal q_shift_in     : std_logic;
  signal b_we_n         : std_logic;  -- Write enable (active low) to the register RAM 
  signal q_we_n         : std_logic;  -- Write enable (active low) to the Q register
  -- Internal copies of output signals 
  signal ybus_int       : std_logic_vector(7 downto 0);
  signal y_reg_int      : std_logic_vector(7 downto 0);
  signal flag_fc_int    : std_logic;
  signal flag_carry_int : std_logic;
  signal flag_zero_int  : std_logic;
  signal flag_link_int  : std_logic;
  signal flag_pccy_int  : std_logic;

  signal pl_sig18 : std_logic_vector(2 downto 0);
  signal pl_sig6  : std_logic_vector(3 downto 0);
  signal pl_sig15 : std_logic_vector(4 downto 0);
  signal pl_sig16 : std_logic_vector(4 downto 0);
  signal pl_sig10 : std_logic_vector(3 downto 0);
  signal pl_sig11 : std_logic_vector(2 downto 0);
  signal pl_sig12 : std_logic_vector(2 downto 0);
  signal pl_sig14 : std_logic_vector(3 downto 0);
  signal pl_sig13 : std_logic_vector(1 downto 0);
  
begin
----------------------------------------------------------------------
  -- Function generator, controlled by ALUF field. 
----------------------------------------------------------------------
  pl_sig11 <= (pl(31) xor pl(13))&(pl(40) xor pl(18))&(pl(51) xor pl(48));
  fgen1 : entity work.fgen
    port map (
      pl_aluf => pl_sig11,
      cn      => c_in,
      cn8     => flag_ac,
      cn4     => flag_ah,
      ovr     => flag_av,
      eq      => flag_az,
      odd     => flag_ap,
      re      => re,
      s       => s,
      f       => f);

----------------------------------------------------------------------
  -- Register RAM with 32 x 8 bits words, adressed by AADDR and BADDR
  -- fields.
----------------------------------------------------------------------
  pl_sig15 <= pl(23)&pl(6)&pl(54)&pl(27)&pl(49);
  pl_sig16 <= pl(70)&pl(67)&pl(33)&pl(69)&pl(53);
  ram32x81 : entity work.ram32x8(register_based)
    port map (
      clk_p     => clk_p,
      clk_e_pos => clk_e_pos,
      rst_n     => rst_n,
      pl_aaddr  => pl_sig15,
      pl_baddr  => pl_sig16,
      we_n      => b_we_n,
      b_in      => b_in,
      a_out     => a_out,
      b_out     => b);

----------------------------------------------------------------------
  -- A output mux, controlled by ALUS field bit 3.
----------------------------------------------------------------------
  pl_sig6  <= (pl(7) xor pl(36))&(pl(8) xor pl(50))&(pl(30) xor pl(62))&(pl(29) xor pl(10));
  pl_sig10 <= pl(64)&pl(75)&pl(76)&pl(18);
  a        <= a_out when pl_sig10(3) = '0' else
       pl_sig6 & pl_sig15(3 downto 0);

--------------------------------------------------------------------------------
  -- Q register.
--------------------------------------------------------------------------------
  q_reg : process (clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_n = '0' then
        q <= (others => '0');
      elsif q_we_n = '0' and clk_e_pos = '0' then
        q <= q_in;
      end if;
    end if;
  end process;
  flag_qlsb <= q(0);                    --The LSB in Q register flag

--------------------------------------------------------------------------------
  -- Shift input selector, controlled by SHIN/PA field.
--------------------------------------------------------------------------------
  pl_sig18 <= pl(56)&(pl(16) xor pl(35))&pl(68);
  pl_sig12 <= (pl(71) xor pl(77))&pl(65)&pl(48);
  shin_sel : process (pl_sig12(1), pl_sig18, f(7), f(0), q(7), q(0), flag_link_int, flag_carry_int, flag_ac)
  begin
    if pl_sig12(1) = '0' then
      case pl_sig18 is
        when SHIN_SINP0 =>
          b_shift_in <= '0';
          q_shift_in <= '0';
        when SHIN_SINPLINK =>
          b_shift_in <= flag_link_int;
          q_shift_in <= f(0);
        when SHIN_SINPC =>
          b_shift_in <= flag_carry_int;
          q_shift_in <= f(0);
        when SHIN_ROTDOUBLE =>
          b_shift_in <= q(0);
          q_shift_in <= f(0);
        when SHIN_ROTATE =>
          b_shift_in <= f(0);
          q_shift_in <= q(0);
        when SHIN_ARIDOUBLE =>
          b_shift_in <= f(7);
          q_shift_in <= f(0);
        when SHIN_SINP1 =>
          b_shift_in <= '1';
          q_shift_in <= '1';
        when SHIN_SHIFTMD =>
          b_shift_in <= flag_ac;
          q_shift_in <= f(0);
        when others => null;
      end case;
    else
      case pl_sig18 is
        when SHIN_SINP0 =>
          b_shift_in <= '0';
          q_shift_in <= '0';
        when SHIN_SINPLINK =>
          b_shift_in <= flag_link_int;
          q_shift_in <= f(7);
        when SHIN_SINPC =>
          b_shift_in <= flag_carry_int;
          q_shift_in <= f(7);
        when SHIN_ROTDOUBLE =>
          b_shift_in <= q(7);
          q_shift_in <= f(7);
        when SHIN_ROTATE =>
          b_shift_in <= f(7);
          q_shift_in <= q(7);
        when SHIN_ARIDOUBLE =>
          b_shift_in <= q(7);
          q_shift_in <= '0';
        when SHIN_SINP1 =>
          b_shift_in <= '1';
          q_shift_in <= '1';
        when SHIN_SHIFTMD =>
          b_shift_in <= q(7);
          q_shift_in <= not flag_link_int;
        when others => null;
      end case;
    end if;
  end process;

--------------------------------------------------------------------------------
  -- Shift output selector, controlled by ALUD field bit 1.
--------------------------------------------------------------------------------
  shift_out <= f(0) when pl_sig12(1) = '0' else
               f(7);

----------------------------------------------------------------------
  -- Source selector, controlled by ALUS field.
----------------------------------------------------------------------
  source_sel : process (pl_sig10, a, b, q, dbus)
  begin
    case pl_sig10(2 downto 0) is
      when ALUS_QA =>                   -- QA
        s  <= q;
        re <= a;
      when ALUS_BA =>                   -- BA
        s  <= b;
        re <= a;
      when ALUS_Q0 =>                   -- Q0
        s  <= q;
        re <= (others => '0');
      when ALUS_B0 =>                   -- B0
        s  <= b;
        re <= (others => '0');
      when ALUS_A0 =>                   -- A0
        s  <= a;
        re <= (others => '0');
      when ALUS_AD =>                   -- AD 
        s  <= a;
        re <= dbus;
      when ALUS_QD =>                   -- QD
        s  <= q;
        re <= dbus;
      when ALUS_0D =>                   -- 0D
        s  <= (others => '0');
        re <= dbus;
      when others => null;
    end case;
  end process;

--------------------------------------------------------------------------------
  -- Destination selector, controlled by ALUD field.
--------------------------------------------------------------------------------
  alud_sel : process (pl_sig12, f, q, b_shift_in, q_shift_in)
  begin
    -- Default values
--              b_in <= f;    
--              q_in <= q;                     
    b_in   <= (others => '0');  --change the initial value to 0  by maning
    q_in   <= (others => '0');
    b_we_n <= '1';
    q_we_n <= '1';

    case pl_sig12 is
      when ALUD_NOP =>
        null;
      when ALUD_QREG =>
        q_we_n <= '0';
        q_in   <= f;
      when ALUD_RAMATOY =>
        b_we_n <= '0';
        b_in   <= f;
      when ALUD_RAM =>
        b_we_n <= '0';
        b_in   <= f;
      when ALUD_RAMQRIGHT =>
        b_we_n           <= '0';
        b_in(6 downto 0) <= f(7 downto 1);
        b_in(7)          <= b_shift_in;
        q_we_n           <= '0';
        q_in(6 downto 0) <= q(7 downto 1);
        q_in(7)          <= q_shift_in;
      when ALUD_RAMRIGHT =>
        b_we_n           <= '0';
        b_in(6 downto 0) <= f(7 downto 1);
        b_in(7)          <= b_shift_in;
      when ALUD_RAMQLEFT =>
        b_we_n           <= '0';
        b_in(7 downto 1) <= f(6 downto 0);
        b_in(0)          <= b_shift_in;
        q_we_n           <= '0';
        q_in(7 downto 1) <= q(6 downto 0);
        q_in(0)          <= q_shift_in;
      when ALUD_RAMLEFT =>
        b_we_n           <= '0';
        b_in(7 downto 1) <= f(6 downto 0);
        b_in(0)          <= b_shift_in;
      when others => null;
    end case;
  end process;

----------------------------------------------------------------------
  -- Carry input selector, controlled by CIN field. 
----------------------------------------------------------------------
  pl_sig13 <= (pl(9) xor pl(63))&pl(79);
  cin_sel : process (pl_sig13, pl_sig11, pl_sig16, flag_carry_int, flag_pccy_int, flag_fc_int)
  begin
    case pl_sig13 is
      when CIN_0 =>                     -- CARRYIN = 0
        c_in <= '0';
        if pl_sig11 = ALUF_S_PLUS_RE and pl_sig16 = "01110" then
          c_in <= flag_pccy_int;  -- CARRYIN = PCCY (only on add with BDEST PCH (=reg# 0E))  
        end if;
      when CIN_1 =>                     -- CARRYIN = 1
        c_in <= '1';
      when CIN_C =>                     -- CARRYIN = C
        c_in <= flag_carry_int;
      when CIN_FC =>                    -- CARRYIN = FC
        c_in <= flag_fc_int;
      when others => null;
    end case;
  end process;

----------------------------------------------------------------------
  -- Registered flags, always loaded. 
----------------------------------------------------------------------
  flag_register : process (clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_n = '0' then
        flag_fn     <= '0';             -- Registered signed flag
        flag_fc_int <= '0';             -- Registered carry output flag
        flag_fz     <= '0';             -- Registered zero flag
        flag_fv     <= '0';             -- Registered overflow flag
        flag_fh     <= '0';             -- Registered half carry output flag 
        flag_fp     <= '0';             -- Registered parity flag
      elsif clk_e_pos = '0' then
        flag_fn     <= flag_yan;        -- Registered signed flag
        flag_fc_int <= flag_yac;        -- Registered carry output flag
        flag_fz     <= flag_yaz;        -- Registered zero flag
        flag_fv     <= flag_yav;        -- Registered overflow flag
        flag_fh     <= flag_ah;         -- Registered half carry output flag 
        flag_fp     <= flag_yap;        -- Registered parity flag
      end if;
    end if;
  end process;
  flag_fc <= flag_fc_int;

----------------------------------------------------------------------
  -- Loadable flags, loading controlled by FF/PB field. 
----------------------------------------------------------------------
  pl_sig14 <= (pl(1) xor pl(65))&pl(63)&pl(77)&(pl(20) xor pl(79));
  ffpb_instr : process (clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_n = '0' then
        flag_oflow     <= '0';
        flag_neg       <= '0';
        flag_zero_int  <= '0';
        flag_carry_int <= '0';
        flag_pccy_int  <= '0';
        flag_link_int  <= '0';
      elsif clk_e_pos = '0' then
        case pl_sig14 is
          when FF_LZNVLOG =>
            flag_oflow    <= '0';
            flag_neg      <= flag_yan;
            flag_zero_int <= flag_yaz;
          when FF_LCZNVARI =>
            flag_oflow     <= flag_yav;
            flag_neg       <= flag_yan;
            flag_zero_int  <= flag_yaz;
            flag_carry_int <= flag_yac;
          when FF_RESPCCY =>
            flag_pccy_int <= '0';
          when FF_LCNVARI =>
            flag_oflow     <= flag_yav;
            flag_neg       <= flag_yan;
            flag_carry_int <= flag_yac;
          when FF_LLFSHIFT =>
            flag_link_int <= shift_out;
          when FF_LCZNVARI16 =>
            flag_oflow     <= flag_yav;
            flag_neg       <= flag_yan;
            flag_zero_int  <= flag_yaz and flag_zero_int;
            flag_carry_int <= flag_yac;
          when FF_LLFD =>
            flag_link_int <= dbus(3);
          when FF_SETC =>
            flag_carry_int <= '1';
          when FF_LCZNVLOG =>
            flag_oflow     <= '0';
            flag_neg       <= flag_yan;
            flag_zero_int  <= flag_yaz;
            flag_carry_int <= '0';
          when FF_LCZNVFD =>
            flag_oflow     <= dbus(5);
            flag_neg       <= dbus(4);
            flag_zero_int  <= dbus(2);
            flag_carry_int <= dbus(0);
          when FF_LOADPCCY =>
            flag_pccy_int <= flag_yac;
          when FF_LCFSHIFT =>
            flag_carry_int <= shift_out;
          when FF_LZNLOG =>
            flag_neg      <= flag_yan;
            flag_zero_int <= flag_yaz;
          when FF_LZNLOG16 =>
            flag_neg      <= flag_yan;
            flag_zero_int <= flag_yaz and flag_zero_int;
          when FF_NOP =>
            null;
          when FF_LCZARI =>
            flag_zero_int  <= flag_yaz;
            flag_carry_int <= flag_yac;
          when others => null;
        end case;
      end if;
    end if;
  end process;
  flag_zero  <= flag_zero_int;
  flag_pccy  <= flag_pccy_int;
  flag_carry <= flag_carry_int;
  flag_link  <= flag_link_int;

----------------------------------------------------------------------
  -- Output selector, controlled by ALUD field. 
----------------------------------------------------------------------
  -- Y bus gets A operand when doing RAMATOY, function generator
  -- output otherwise.
  ybus_int <= a when pl_sig12 = ALUD_RAMATOY else
              f;
  ybus <= ybus_int;

  -- Zero and parity flags from the Y bus.      
  flag_yz <= not (ybus_int(7) or ybus_int(6) or ybus_int(5) or ybus_int(4) or
                  ybus_int(3) or ybus_int(2) or ybus_int(1) or ybus_int(0));
  flag_yp <= ybus_int(7) xor ybus_int(6) xor ybus_int(5) xor ybus_int(4) xor
             ybus_int(3) xor ybus_int(2) xor ybus_int(1) xor ybus_int(0);

  -- Zero, parity and neg flags are taken from the Y bus when doing a
  -- single operand OR (PASS), from function generator otherwise.
  sel_flag <= '1' when (pl_sig10(2 downto 0) = ALUS_Q0 or
                        pl_sig10(2 downto 0) = ALUS_A0 or
                        pl_sig10(2 downto 0) = ALUS_B0 or
                        pl_sig10(2 downto 0) = ALUS_0D) and
              pl_sig11 = ALUF_S_OR_RE else '0';
  flag_yan <= ybus_int(7) when sel_flag = '1' else
              f(7);
  flag_yac <= '0' when sel_flag = '1' else
              flag_ac;
  flag_yaz <= flag_yz when sel_flag = '1' else
              flag_az;
  flag_yav <= '0' when sel_flag = '1' else
              flag_av;
  flag_yap <= flag_yp when sel_flag = '1' else
              flag_ap;

----------------------------------------------------------------------
  -- Y bus register.
----------------------------------------------------------------------
  process (clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_n = '0' then
        y_reg_int <= (others => '0');
      elsif clk_e_pos = '0' then
        y_reg_int <= ybus_int;
      end if;
    end if;
  end process;
  y_reg <= y_reg_int;
end;



