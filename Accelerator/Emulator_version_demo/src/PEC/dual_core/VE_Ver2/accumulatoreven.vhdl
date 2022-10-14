library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity accumulatoreven is
  port (
    clk     : in  std_logic;
    en      : in  std_logic;
    mul     : in  signed(17 downto 0);
    mul_odd : in  signed(17 downto 0);
    ctrl    : in  acce_ctrl;
<<<<<<< HEAD
    bias    : in  signed(31 downto 0);
=======
>>>>>>> master
    result  : out signed(31 downto 0);
    sign_o  : out std_logic
    );
end entity;

-- TODO: add output for sign

architecture first of accumulatoreven is
  signal accumulator : signed(31 downto 0);
  signal add_input0  : signed(31 downto 0);
  signal add_input1  : signed(31 downto 0);
  signal add_res     : signed(31 downto 0);
  signal mul_odd_abs : signed(31 downto 0);
  signal mul_abs     : signed(31 downto 0);
  signal max_value   : signed(31 downto 0);
  constant czero     : signed(31 downto 0) := to_signed(0, 32);
  alias sign : std_logic is mul_odd(17);
  alias add_sign : std_logic is add_res(20);

begin
  mul_abs <= signed(resize(unsigned(not(mul(14 downto 7))), 32)) when sign = '1' else
             signed(resize(unsigned(mul(14 downto 7)), 32));

  mul_odd_abs <= signed(shift_left(resize(unsigned(not(mul_odd(14 downto 7))), 31), 7)) & '1' when sign = '1' else
                 signed(shift_left(resize(unsigned(mul_odd(14 downto 7)), 31), 7)) & '0';

  add_input0 <= mul_abs when ctrl.add = abs16 else resize(mul(17 downto 1) & '1', 32) when ctrl.add = max else resize(mul, 32);

  with ctrl.add select add_input1 <=
    czero                              when zero,
    resize(mul_odd, 32)                when odd,
    shift_left(resize(mul_odd, 32), 8) when odd8,
    accumulator                        when acc,
    mul_odd_abs when abs16,
    not(accumulator) when max;

  add_res <= add_input0 + add_input1;

  max_value <= accumulator when add_sign = '0' else add_input0;

  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if ctrl.acc = acc then
          accumulator <= add_res;
        elsif ctrl.acc = zero then
          accumulator <= (others => '0');
        elsif ctrl.acc = max then
          accumulator <= max_value;
        elsif ctrl.acc = loadbias then
          accumulator <= bias;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        sign_o <= sign;
        if ctrl.reg = add then
          result <= add_res;
        elsif ctrl.reg = acc then
          result <= accumulator;
        elsif ctrl.reg = max then
          result <= max_value;
        end if;
      end if;
    end if;
  end process;


end architecture;
