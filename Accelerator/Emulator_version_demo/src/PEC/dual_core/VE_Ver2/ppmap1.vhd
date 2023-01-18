library ieee;
use ieee.std_logic_1164.all;

use work.vetypes.all;

entity ppmap1 is
  port (
    inst    : in  ppctrl_t;
    decoded : out pp_ctrl
    );
end entity;

architecture first of ppmap1 is
begin
  with inst select decoded <=
    (mux3 => zero, mux2 => zero, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => hold) when nop,
    (mux3 => left, mux2 => zero, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when select7,
    (mux3 => add, mux2 => zero, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when select6,
    (mux3 => zero, mux2 => left, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when select5,
    (mux3 => zero, mux2 => add, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when select4,
    (mux3 => zero, mux2 => zero, mux1 => left, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when select3,
    (mux3 => zero, mux2 => zero, mux1 => add, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when select2,
    (mux3 => zero, mux2 => zero, mux1 => zero, mux0 => left,
     acc  => zero, addsub => add, reg => enable) when select1,
    (mux3 => zero, mux2 => zero, mux1 => zero, mux0 => add,
     acc  => zero, addsub => add, reg => enable) when select0,
    (mux3 => add, mux2 => add, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when add32,
    (mux3 => zero, mux2 => add, mux1 => add, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when add21,
    (mux3 => zero, mux2 => zero, mux1 => add, mux0 => add,
     acc  => zero, addsub => add, reg => enable) when add10,
    (mux3 => add8, mux2 => add, mux1 => add8, mux0 => add,
     acc  => zero, addsub => sub, reg => enable) when fftsub0,
    (mux3 => add8, mux2 => add, mux1 => add8, mux0 => add,
     acc  => zero, addsub => add, reg => enable) when fftsub1,
    (mux3 => add8, mux2 => add, mux1 => add8, mux0 => zero,
     acc  => zero, addsub => subl, reg => enable) when unitri,
    (mux3 => add, mux2 => add, mux1 => add, mux0 => add,
     acc  => zero, addsub => add, reg => enable) when sumfirst,
    (mux3 => add, mux2 => add, mux1 => add, mux0 => add,
     acc  => acc, addsub => add, reg => enable) when sum,
    (mux3 => add8, mux2 => add, mux1 => add8, mux0 => add,
     acc  => acc, addsub => add, reg => enable) when sum16,
    (mux3 => add8, mux2 => add, mux1 => zero, mux0 => zero,
     acc  => acc, addsub => add, reg => enable) when sum16left,
    (mux3 => add8, mux2 => add, mux1 => zero, mux0 => zero,
     acc  => zero, addsub => add, reg => enable) when matmulleft,
     (mux3 => add, mux2 => zero, mux1 => add8, mux0 => zero,
     acc  => zero, addsub => subl, reg => enable) when nrit;
end architecture;
