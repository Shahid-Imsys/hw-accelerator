--postprocess adder
--this block can be use as adder or accumulator or MUX. For details check
--the block diagram

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity ppadd is
  port (
    clk     : in  std_logic;
    en : in  std_logic;
    in7     : in  signed(31 downto 0);
    in6     : in  signed(31 downto 0);
    in5     : in  signed(31 downto 0);
    in4     : in  signed(31 downto 0);
    in3     : in  signed(31 downto 0);
    in2     : in  signed(31 downto 0);
    in1     : in  signed(31 downto 0);
    in0     : in  signed(31 downto 0);
    loadin  : in  signed(31 downto 0);
    ctrl    : in  pp_ctrl;
    result  : out signed(32 downto 0)
    );
end entity;

architecture first of ppadd is
  constant czero                : signed (32 downto 0) := to_signed(0, 33);
  signal in3m, in2m, in1m, in0m : signed (32 downto 0);  -- Input multiplexers
  signal accm                   : signed (32 downto 0);  -- Input multiplexers
  signal sum1, sum0             : signed (32 downto 0);  -- Partial sums
  signal sum1e, sum0e           : signed (33 downto 0);  -- Partial sums with extra bit
  signal rese                   : signed (33 downto 0);  -- Result with extra bit
  signal resreg                 : signed (32 downto 0);  -- Pipeline
begin
  with ctrl.mux3 select in3m <=
    resize(in7, 33)                when left,
    resize(in6, 33)                when add,
    shift_left(resize(in6, 33), 8) when add8,
    czero                          when zero;

  with ctrl.mux2 select in2m <=
    resize(in5, 33) when left,
    resize(in4, 33) when add,
    czero           when zero;

  with ctrl.mux1 select in1m <=
    resize(in3, 33)                when left,
    resize(in2, 33)                when add,
    shift_left(resize(in2, 33), 8) when add8,
    czero                          when zero;

  with ctrl.mux0 select in0m <=
    resize(in1, 33) when left,
    resize(in0, 33) when add,
    czero           when zero;

  with ctrl.acc select accm <=
    resreg when acc,
    czero  when zero;

  sum1 <= in3m + in2m + accm;
  sum0 <= in1m + in0m;

  sum1e <= sum1 & '1'   when ctrl.addsub = add or ctrl.addsub = sub else (not(sum1) & '1');
  sum0e <= (sum0 & '0') when ctrl.addsub = add                      else (not(sum0) & '1') when ctrl.addsub = sub else (sum0 & '1');

  rese <= sum0e + sum1e;

  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if ctrl.reg = enable then
          resreg <= rese(33 downto 1);
        elsif ctrl.reg = load then
          resreg <= resize(loadin, 33);
        end if;
      end if;
    end if;
  end process;

  result <= resreg;
end architecture;
