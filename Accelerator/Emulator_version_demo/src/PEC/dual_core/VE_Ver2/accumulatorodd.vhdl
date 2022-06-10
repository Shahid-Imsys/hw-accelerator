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
    result : out signed(31 downto 0)
    );
end entity;

architecture first of accumulatorodd is
  signal accumulator : signed(31 downto 0);
  signal add_input0  : signed(31 downto 0);
  signal add_input1  : signed(31 downto 0);
  signal add_res     : signed(31 downto 0);
  constant czero     : signed(31 downto 0) := to_signed(0, 32);

begin
  add_input0 <= resize(mul, 32);

  add_input1 <= czero when ctrl.add = zero else accumulator;

  add_res <= add_input0 + add_input1;

  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if ctrl.acc = acc then
          accumulator <= add_res;
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
        end if;
      end if;
    end if;
  end process;

end architecture;
