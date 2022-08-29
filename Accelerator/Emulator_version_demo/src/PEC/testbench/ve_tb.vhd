----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/09/2021 11:01:05 PM
-- Design Name: 
-- Module Name: ve_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.env.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ve_tb is
--  Port ( );
end ve_tb;

architecture Behavioral of ve_tb is
component ve
    port(
    CLK_P        : in std_logic;
    CLK_E_POS    : in std_logic;
    CLK_E_NEG    : in std_logic;
    RST          : in std_logic;
    PL           : in std_logic_vector(127 downto 0);
    YBUS         : in std_logic_vector(7 downto 0);    
    DDI_VLD      : in std_logic;  
    RE_RDY       : out std_logic; 
    VE_RDY       : out std_logic; 
    VE_IN        : in std_logic_vector(63 downto 0);
    VE_DTM_RDY   : out std_logic;
    VE_PUSH_DTM  : out std_logic;
    VE_AUTO_SEND : out std_logic;
    VE_OUT_D     : out std_logic_vector(7 downto 0); 
    VE_OUT_DTM   : out std_logic_vector(127 downto 0) );
end component;

type mem is array(511 downto 0) of std_logic_vector(127 downto 0);
signal virtual_mem : mem;
signal data_counter : unsigned(8 downto 0) := '0' & x"00";
signal clk_p : std_logic;
signal clk_e_pos : std_logic;
signal clk_e_neg : std_logic;
signal rst : std_logic;
signal pl : std_logic_vector(127 downto 0);
signal ybus : std_logic_vector(7 downto 0);
signal ddi_vld : std_logic;
signal re_rdy : std_logic;
signal ve_rdy, ve_rdy_delay : std_logic;
signal read_out_done : std_logic;
signal ve_in : std_logic_vector(63 downto 0);
signal ve_out_d : std_logic_vector(7 downto 0);
signal ve_out_dtm : std_logic_vector(127 downto 0);
signal progress : integer;
signal debug   : integer;


--pl fields
constant au_test_offset0 : std_logic_vector(127 downto 0) := x"00000200000000000000000000000000";
constant au_test_offset1 : std_logic_vector(127 downto 0) := x"00000210000000000000000000000000";
constant au_test_offset2 : std_logic_vector(127 downto 0) := x"00000220000000000000000000000000";
constant au_test_offset3 : std_logic_vector(127 downto 0) := x"00000230000000000000000000000000";
constant au_test_cmp0 : std_logic_vector(127 downto 0) := x"00000240000000000000000000000000";
constant au_test_cmp1 : std_logic_vector(127 downto 0) := x"00000250000000000000000000000000";
constant au_test_cmp2 : std_logic_vector(127 downto 0) := x"00000260000000000000000000000000";
constant au_test_cmp3 : std_logic_vector(127 downto 0) := x"00000270000000000000000000000000";
--write post processing relevant registers 54-59
constant word_54 : std_logic_vector(127 downto 0) := "00000000000000000000001010000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_55 : std_logic_vector(127 downto 0) := "00000000000000000000001010100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_56 : std_logic_vector(127 downto 0) := "00000000000000000000001011000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_57 : std_logic_vector(127 downto 0) := "00000000000000000000001011100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_58 : std_logic_vector(127 downto 0) := "00000000000000000000001100000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_59 : std_logic_vector(127 downto 0) := "00000000000000000000001100100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
-- fft test
--constant mode_fft : std_logic_vector(127 downto 0) :="";
constant load_lc  : std_logic_vector(127 downto 0) := x"00000080000000000000000000000000";
--constant start    : std_logic_vector(127 downto 0) :="";


begin
process
begin
clk_p <= '1';
wait for 15 ns;
clk_p<= '0';
wait for 15 ns;
end process;

process(clk_p)
begin
if rst = '0' then
clk_e_pos <= '0';
elsif rising_edge(clk_p) then
clk_e_pos <= not clk_e_pos;
end if;
end process;
clk_e_neg <= not clk_e_pos;

process
begin
--wait for 1 ns; --Manually added delay
rst <= '0';
--Reset
wait for 300 ns;
DDI_VLD <= '1'; 
wait for 30 ns;
DDI_VLD <= '0';
rst <= '1';
wait for 60 ns;
pl <= au_test_offset0;
wait for 30 ns;
ybus <= x"03";
wait for 30 ns;
pl <= au_test_offset1;
wait for 30 ns;
ybus <= x"0f";
wait for 30 ns;
pl <= au_test_offset2;
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl <= au_test_offset3;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl <= au_test_cmp0;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl <= au_test_cmp1;
wait for 30 ns;
ybus <= x"1e";
wait for 30 ns;
pl <= au_test_cmp2;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl <= au_test_cmp3;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
progress <= 1;
pl(94)<= '0';
pl(93) <= '1';
wait for 30 ns;
progress <= 2;
pl <= load_lc;
wait for 30 ns;
ybus <= x"06";
progress <= 3;
Pl(95) <= '1';
wait for 30 ns;
pl(95) <= '0';

wait until read_out_done = '1';
report "simulation end";
finish;
end process;

process(clk_e_neg)
begin
  if rising_edge(clk_e_neg) then
    ve_rdy_delay <= ve_rdy;
  end if;
end process;

process(clk_e_neg, ve_rdy_delay, ve_out_dtm)
begin
  read_out_done <= '0';
  if clk_e_neg = '1' and ve_rdy_delay = '1' then
    virtual_mem(to_integer(data_counter)) <= ve_out_dtm;
    if data_counter = '1' & x"ff" then
      data_counter <= (others => '0');
      read_out_done <= '1';
    else
      data_counter <= data_counter+1;
    end if;
  end if;
end process;

process(clk_p)
begin
if rising_edge(clk_p) then
if DDI_VLD = '1' then
debug <= 1;
else
debug <= 0;
end if;
end if;
end process;

vector_engine: ve
port map(
    CLK_P        => clk_p,
    CLK_E_POS    => clk_e_pos,
    CLK_E_NEG    => clk_e_neg,
    RST          => rst,
    PL           => pl,
    YBUS         => ybus,
    DDI_VLD      => ddi_vld,
    RE_RDY       => re_rdy,
    VE_RDY       => ve_rdy,
    VE_IN        => ve_in,
    VE_DTM_RDY   => open,
    VE_PUSH_DTM  => open,
    VE_AUTO_SEND => open,
    VE_OUT_D     => ve_out_d,
    VE_OUT_DTM   => ve_out_dtm
);
end Behavioral;