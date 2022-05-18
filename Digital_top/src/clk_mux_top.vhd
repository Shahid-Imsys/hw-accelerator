-------------------------------------------------------------------------------
-- File       : clk_switch.vhd
-- Author     : Yuxiang Huan
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description:  Clock switching logic, designed to handle asynchronous
--               clocks. Will guarantee a well-behaved switch of source
--               for clk_mux_out, controlled by sel.
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version   Author  Description
-- 2015-07-02   1.0       HYX     Created
-- 2016-08-30   2.0       MN      Add clk1_selected signal output
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity clk_mux_top is
  port (
    clk1           : in  std_logic;   
    clk2           : in  std_logic;
    sel            : in  std_logic;  
    rst1_n         : in  std_logic; 
    rst2_n         : in  std_logic;
    clk1_selected  : out std_logic;-- high active                     
    clk_mux_out    : out std_logic);    
end clk_mux_top;

architecture rtl of clk_mux_top is
  signal clk1_ff1         : std_logic;
  signal clk1_ff2         : std_logic;
  signal clk2_ff1         : std_logic;
  signal clk2_ff2         : std_logic;

begin
   process (clk1, rst1_n)
   begin
   if rst1_n = '0' then
     clk1_ff2 <= '0';
   elsif falling_edge(clk1) then
     clk1_ff2 <= clk1_ff1;
   end if;
   end process;

   process (clk1, rst1_n)
   begin
   if rst1_n = '0' then
     clk1_ff1 <= '0';
   elsif rising_edge(clk1) then
     clk1_ff1 <= not clk2_ff2 and not sel;
   end if;
   end process;


   process (clk2, rst2_n)
   begin
   if rst2_n = '0' then
     clk2_ff2 <= '0';
   elsif falling_edge(clk2) then
     clk2_ff2 <= clk2_ff1;
   end if;
   end process;

   process (clk2, rst2_n)
   begin
   if rst2_n = '0' then
     clk2_ff1 <= '0';
   elsif rising_edge(clk2) then
     clk2_ff1 <= not clk1_ff2 and sel;
   end if;
   end process;

   clk_mux_out  <= (clk1_ff2 and clk1) or (clk2_ff2 and clk2); -- clock mux for clk1 and clk2, controlled by sel_pll
    clk1_selected <= clk1_ff2;
   end rtl;
