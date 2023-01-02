library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity accumulatorodd is
  port (
    clk    : in  std_logic;
    en     : in  std_logic;
    mul    : in  signed(17 downto 0);
    ctrl   : in  acco_ctrl;
    bias   : in  signed(31 downto 0);
    result : out signed(31 downto 0)
    );
end entity;

architecture first of accumulatorodd is
  signal accumulator : signed(31 downto 0);
  signal add_input0  : signed(31 downto 0);
  signal add_input1  : signed(31 downto 0);
  signal add_res     : signed(31 downto 0);
  signal max_value   : signed(31 downto 0);
  constant czero     : signed(31 downto 0) := to_signed(0, 32);
  alias add_sign : std_logic is add_res(20);
begin
  add_input0 <= resize(mul, 32);

  add_input1 <= czero when ctrl.add = zero else not(accumulator) when ctrl.add = max else accumulator;

  add_res <= add_input0 + add_input1;

  max_value <= add_input0 when ctrl.add = zero else accumulator when add_sign = '1' else add_input0; 

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
