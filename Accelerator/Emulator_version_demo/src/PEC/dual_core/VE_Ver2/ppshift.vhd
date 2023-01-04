--postprocess shift
--this block perform shiftting, add bias and clip.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity ppshift is
  port (
    clk             : in  std_logic;
    enable_shift    : in  std_logic;
    enable_add_bias : in  std_logic;
    enable_clip     : in  std_logic;
    bias            : in  std_logic_vector(15 downto 0);
    sum             : in  signed(32 downto 0);
    shift_ctrl      : in  ppshift_shift_ctrl;
    bias_add_ctrl   : in  ppshift_addbias_ctrl;
    clip_ctrl       : in  ppshift_clip_ctrl;
    lod_res         : in  ppshift_shift_ctrl;
    lod_neg         : in  std_logic;
    shift_result    : out std_logic_vector(15 downto 0); -- For division
    clip_result     : out std_logic_vector(15 downto 0); -- For feedback
    outreg          : out std_logic_vector(63 downto 0)
    );
end entity;

architecture first of ppshift is
  alias d3 is outreg(63 downto 48);
  alias d2 is outreg(47 downto 32);
  alias d1 is outreg(31 downto 16);
  alias d0 is outreg(15 downto 0);
  constant czero         : signed(32 downto 0)           := to_signed(0, 33);
  constant cone          : signed(32 downto 0)           := to_signed(1, 33);
  constant czero16       : std_logic_vector(15 downto 0) := (others => '0');
  constant cone16        : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(256, 16));
  constant cone16_12f    : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(4096, 16));
  signal addinput0       : signed(32 downto 0);  -- Adder input multiplexer
  signal addinput1       : signed(32 downto 0);  -- Adder input multiplexer
  signal addresult       : signed(32 downto 0);  -- Adder result
  signal accreg          : signed(32 downto 0);  -- Accumulator register
  signal beforeshift     : signed(33 downto 0);
  signal aftershift      : signed(33 downto 0);
  signal shiftresult     : signed(33 downto 0);
  signal shiftresult_tmp : signed(33 downto 0);
  signal stage16         : signed(33 downto 0);
  signal stage8          : signed(33 downto 0);
  signal stage4          : signed(33 downto 0);
  signal stage2          : signed(33 downto 0);
  signal stage1          : signed(33 downto 0);
  signal addresult_tmp   : signed(33 downto 0);
  signal to_clip         : signed(31 downto 0);
  signal outreg_en       : std_logic_vector(7 downto 0);  -- Binary enable bits
  signal delayed_enable  : enable_t;
  signal lod_neg_delayed : std_logic;
  signal bias_add_ctrl2  : ppacc_t;
  signal clipresult      : std_logic_vector(15 downto 0);
  signal outreg_int      : std_logic_vector(63 downto 0);
  signal fill, roundbit  : std_logic;
  signal sticky16        : std_logic;
  signal sticky8         : std_logic;
  signal sticky4         : std_logic;
  signal sticky2         : std_logic;
  signal sticky1         : std_logic;
  signal sticky          : std_logic;
  signal shift_bits      : unsigned(4 downto 0);
  signal shift_dir       : shift_t;
  alias clipresult_short is clipresult(7 downto 0);
begin

  -- TODO: add abs sign

  process(sum, shift_dir)
  begin
    if shift_dir = left then
      for i in 1 to 33 loop
        beforeshift(i) <= sum(33-i);
      end loop;
      beforeshift(0) <= '0';
    else
      beforeshift <= sum & '0';
    end if;
  end process;

  shift_bits <= to_unsigned(lod_res.shift, 5) when shift_ctrl.use_lod = '1'
                else to_unsigned(shift_ctrl.shift, 5);
  shift_dir <= lod_res.shift_dir when shift_ctrl.use_lod = '1'
               else shift_ctrl.shift_dir;

  fill       <= beforeshift(33) when shift_dir = right else '0';

  -- Shift by 16
  stage16(33 downto 18) <= (others => fill)          when shift_bits(4) = '1' else beforeshift(33 downto 18);
  stage16(17 downto 0)  <= beforeshift(33 downto 16) when shift_bits(4) = '1' else beforeshift(17 downto 0);
  sticky16              <= beforeshift(15) or beforeshift(14) or beforeshift(13) or beforeshift(12)
                           or beforeshift(11) or beforeshift(10) or beforeshift(9) or beforeshift(8)
                           or beforeshift(7) or beforeshift(6) or beforeshift(5) or beforeshift(4)
                           or beforeshift(3) or beforeshift(2) or beforeshift(1) or beforeshift(0)
                           when shift_bits(4) = '1' else '0';

  -- Shift by 8
  stage8(33 downto 26) <= (others => fill)     when shift_bits(3) = '1' else stage16(33 downto 26);
  stage8(25 downto 0)  <= stage16(33 downto 8) when shift_bits(3) = '1' else stage16(25 downto 0);
  sticky8              <= stage16(7) or stage16(6) or stage16(5) or stage16(4)
                          or stage16(3) or stage16(2) or stage16(1) or stage16(0) or sticky16
                          when shift_bits(3) = '1' else sticky16;

  -- Shift by 4
  stage4(33 downto 30) <= (others => fill)    when shift_bits(2) = '1' else stage8(33 downto 30);
  stage4(29 downto 0)  <= stage8(33 downto 4) when shift_bits(2) = '1' else stage8(29 downto 0);
  sticky4              <= stage8(3) or stage8(2) or stage8(1) or stage8(0) or sticky8
                          when shift_bits(2) = '1' else sticky8;

  -- Shift by 2
  stage2(33 downto 32) <= (others => fill)    when shift_bits(1) = '1' else stage4(33 downto 32);
  stage2(31 downto 0)  <= stage4(33 downto 2) when shift_bits(1) = '1' else stage4(31 downto 0);
  sticky2              <= stage4(1) or stage4(0) or sticky4
                          when shift_bits(1) = '1' else sticky4;

  -- Shift by 1
  stage1(33)          <= fill                when shift_bits(0) = '1' else stage2(33);
  stage1(32 downto 0) <= stage2(33 downto 1) when shift_bits(0) = '1' else stage2(32 downto 0);
  sticky1             <= stage2(0) or sticky2
                         when shift_bits(0) = '1' else sticky2;

  aftershift <= stage1;

  process(aftershift, shift_dir)
  begin
    if shift_dir = left then
      for i in 1 to 33 loop
        shiftresult_tmp(i) <= aftershift(34-i);
        shiftresult_tmp(0) <= aftershift(0);
      end loop;
    else
      shiftresult_tmp <= aftershift;
    end if;
  end process;

  shift_result <= std_logic_vector(shiftresult_tmp(32 downto 17));

  process(clk)
  begin
    if rising_edge(clk) then
      if enable_shift = '1' then
        delayed_enable <= shift_ctrl.acce;
        lod_neg_delayed <= lod_neg;
        if shift_ctrl.acce = enable then
          shiftresult <= shiftresult_tmp;
          sticky      <= sticky1;
        end if;
      end if;
    end if;
  end process;

  bias_add_ctrl2 <= negate when (lod_neg_delayed = '1') else bias_add_ctrl.acc;


  with bias_add_ctrl2 select addinput0 <=
    resize(signed(bias), 33) when addbias,
    cone                     when negate,
    czero                    when pass;

  with bias_add_ctrl2 select addinput1 <=
    shiftresult(33 downto 1)     when addbias,
    not shiftresult(33 downto 1) when negate,
    shiftresult(33 downto 1)     when pass;


  with bias_add_ctrl.quant select roundbit <=
    '0'                       when trunc,
    shiftresult(0)            when round,
    shiftresult(0) and sticky when unbiased;

  addresult_tmp <= (addinput0 & '1') + (addinput1 & roundbit);

  addresult <= addresult_tmp(33 downto 1);

  process(clk)
  begin
    if rising_edge(clk) then
      if enable_add_bias = '1' then
        if delayed_enable = enable then
          accreg <= addresult;
        end if;
      end if;
    end if;
  end process;

  to_clip <= accreg(31 downto 0);

  process(to_clip, clip_ctrl.clip)
  begin
    case clip_ctrl.clip is
      when clip8 =>
        -- 8-bit unsigned: 0 <= clipresult <= 255
        if to_clip(31) = '1' then       -- saturate to min
          clipresult <= czero16;
        elsif not(to_clip(30 downto 8) = X"000000") then  -- saturate to max
          clipresult <= (others => '1');
        else                            -- no saturate
          clipresult <= std_logic_vector(to_clip(15 downto 0));
        end if;
      when clip16 =>
        -- 16-bit signed: -32768 <= clipresult <= 32767
        if (to_clip(31) = '0') and not(to_clip(30 downto 15) = X"0000") then  -- saturate to max pos
          clipresult <= (15 => '0', others => '1');
        elsif (to_clip(31) = '1') and not(to_clip(30 downto 15) = X"ffff") then  -- saturate to max min
          clipresult <= (15 => '1', others => '0');
        else
          clipresult <= std_logic_vector(to_clip(15 downto 0));  -- no saturate
        end if;
      when clipone16 =>
        -- set to one
        clipresult <= cone16;
      when clipone16_12f =>
        -- set to one
        clipresult <= cone16_12f;
      when clipzero =>
        -- set to zero
        clipresult <= czero16;
      when none =>
        -- pass result on
        clipresult <= std_logic_vector(to_clip(15 downto 0));
    end case;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if enable_clip = '1' then
        case clip_ctrl.outreg is
          when out0  => outreg_int(7 downto 0)   <= clipresult_short;
          when out1  => outreg_int(15 downto 8)  <= clipresult_short;
          when out2  => outreg_int(23 downto 16) <= clipresult_short;
          when out3  => outreg_int(31 downto 24) <= clipresult_short;
          when out4  => outreg_int(39 downto 32) <= clipresult_short;
          when out5  => outreg_int(47 downto 40) <= clipresult_short;
          when out6  => outreg_int(55 downto 48) <= clipresult_short;
          when out7  => outreg_int(63 downto 56) <= clipresult_short;
          when out10 => outreg_int(15 downto 0)  <= clipresult;
          when out32 => outreg_int(31 downto 16) <= clipresult;
          when out54 => outreg_int(47 downto 32) <= clipresult;
          when out76 => outreg_int(63 downto 48) <= clipresult;
          when none  => null;           -- Better way to enable clock gating?
        end case;
      end if;
    end if;
  end process;

  clip_result <= clipresult;
  outreg <= outreg_int;

end architecture;
