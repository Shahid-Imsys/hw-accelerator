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

signal clk_p : std_logic;
signal clk_e_pos : std_logic;
signal clk_e_neg : std_logic;
signal rst : std_logic;
signal pl : std_logic_vector(127 downto 0);
signal ybus : std_logic_vector(7 downto 0);
signal ddi_vld : std_logic;
signal re_rdy : std_logic;
signal ve_rdy : std_logic;
signal ve_in : std_logic_vector(63 downto 0);
signal ve_out_d : std_logic_vector(7 downto 0);
signal ve_out_dtm : std_logic_vector(127 downto 0);
signal progress : integer;
signal debug   : integer;


--pl fields
constant word_0 : std_logic_vector(127 downto 0) := "00000000000000000000000000100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_1 : std_logic_vector(127 downto 0) := "00000000000000000000000001000000000000000000000000000000011010000000000001100010000001010000011011001010101000000000000001000000";
constant word_2 : std_logic_vector(127 downto 0) := "00000000000000000000000001100000000000000000000000000000011010000000000001100010000001010000011011101010101000000000000001000000";
constant word_3 : std_logic_vector(127 downto 0) := "00000000000000000000000010000000000000000000000000000000011010000000000001100010000001010000011010001010101000000000000101000000";
constant word_4 : std_logic_vector(127 downto 0) := "00000000000000000000000010100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000101000000";
constant word_5 : std_logic_vector(127 downto 0) := "00000000000000000000000011000000000000000000000000000000011010000000000001100010000001010000011011001010101000000000000101000000";
constant word_6 : std_logic_vector(127 downto 0) := "00000000000000000000000011100000000000000000000000000000011010000000000001100010000001010000011011101010101000000000000101000000";
constant word_7 : std_logic_vector(127 downto 0) := "00000000000000000000000100000000000000000000000000000000011010000000000001100010000001010000011010001010101000000000000011000000";
constant word_8 : std_logic_vector(127 downto 0) := "00000000000000000000000100100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000011000000";
constant word_9 : std_logic_vector(127 downto 0) := "00000000000000000000000101000000000000000000000000000000011010000000000001100010000001010000011011001010101000000000000011000000";
constant word_10 : std_logic_vector(127 downto 0) := "00000000000000000000000101100000000000000000000000000000011010000000000001100010000001010000011011101010101000000000000011000000";
constant word_11 : std_logic_vector(127 downto 0) := "00000000000000000000000110000000000000000000000000000000011010000000000001100010000001010000011010001010101000000000000111000000";
constant word_12 : std_logic_vector(127 downto 0) := "00000000000000000000001111100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_13 : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000100000000001001011000001010000010010001010110000000000000001000010";
constant word_14 : std_logic_vector(127 downto 0) := "00000000000000000000000000100000000000000000000010010000000000100000000000100000001001010000010000000000000101000000000000010010";
constant word_15 : std_logic_vector(127 downto 0) := "00000000000000000000000001000000000000000000000010010000001000100000000000000010001001010000010000000010000101000000000000010010";
constant word_16 : std_logic_vector(127 downto 0) := "00000000000000000000000001100000000000000000000010010000001000100000000000100000001001010000010000001000000101000000000000010010";
constant word_17 : std_logic_vector(127 downto 0) := "00000000000000000000000010000000000000000000000010010000000000100000000000000010001001010000011000001010000101000000000000010010";
constant word_18 : std_logic_vector(127 downto 0) := "00000000000000000000000010100000000000000000000010010000000000100000000001100000001001010000011000000000000101000000000000010010";
constant word_19 : std_logic_vector(127 downto 0) := "00000000000000000000000011000000000000000000000010010000001000100000000001000010001001010000011000000010000101000000000000010010";
constant word_20 : std_logic_vector(127 downto 0) := "00000000000000000000000011100000000000000000000010010000001000100000000001100000001001010000011000001000000101000000000000010010";
constant word_21 : std_logic_vector(127 downto 0) := "00000000000000000000000100000000000000000000000010010000000010100000000001000010001001010000010000001010000101000000000000010010";
constant word_22 : std_logic_vector(127 downto 0) := "00000000000000000000000100100000000000000000000010010000000010100000000000100000001001010000010000000000000101000000000001010010";
constant word_23 : std_logic_vector(127 downto 0) := "00000000000000000000000101000000000000000000000010010000001010100000000000000010001001010000010000000010000101000000000001010010";
constant word_24 : std_logic_vector(127 downto 0) := "00000000000000000000000101100000000000000000000010010000001010100000000000100000001001010000010000001000000101000000000001010010";
constant word_25 : std_logic_vector(127 downto 0) := "00000000000000000000000110000000000000000000000010010000000010100000000000000010001001010000011000001010000101000000000001010010";
constant word_26 : std_logic_vector(127 downto 0) := "00000000000000000000001111100000000000000000000000000000000000100000000000000000001001000000010000000000000000000000000000000010";
constant word_27 : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000100010000001001011000101010000010011101010110000000100000111000010";
constant word_28 : std_logic_vector(127 downto 0) := "00000000000000000000000000100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_29 : std_logic_vector(127 downto 0) := "00000000000000000000000001000000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_30 : std_logic_vector(127 downto 0) := "00000000000000000000000001100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_31 : std_logic_vector(127 downto 0) := "00000000000000000000000010000000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_32 : std_logic_vector(127 downto 0) := "00000000000000000000000010100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_33 : std_logic_vector(127 downto 0) := "00000000000000000000000011000000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_34 : std_logic_vector(127 downto 0) := "00000000000000000000000011100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_35 : std_logic_vector(127 downto 0) := "00000000000000000000000100000000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_36 : std_logic_vector(127 downto 0) := "00000000000000000000000100100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_37 : std_logic_vector(127 downto 0) := "00000000000000000000000101000000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_38 : std_logic_vector(127 downto 0) := "00000000000000000000000101100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_39 : std_logic_vector(127 downto 0) := "00000000000000000000000110000000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_40 : std_logic_vector(127 downto 0) := "00000000000000000000001111100000000000000000000010010000000000100000000000001001001001010000010000000000000101000000000000010010";
constant word_41 : std_logic_vector(127 downto 0) := "00000001000000000000000000000000000000000000000000000000011010000000000001100010001001000000001000101011101000001000010001010000";
constant word_42 : std_logic_vector(127 downto 0) := "00000000000000000000001000100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_43 : std_logic_vector(127 downto 0) := "00000000000000000000001000000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_44 : std_logic_vector(127 downto 0) := "00000000000000000000001001000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_45 : std_logic_vector(127 downto 0) := "00000000000000000000001001100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_46 : std_logic_vector(127 downto 0) := "00000000000000000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_47 : std_logic_vector(127 downto 0) := "00000000000100000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_48 : std_logic_vector(127 downto 0) := "00000000001000000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_49 : std_logic_vector(127 downto 0) := "00000000001100000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_50 : std_logic_vector(127 downto 0) := "00000000010000000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_51 : std_logic_vector(127 downto 0) := "00000000010100000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_52 : std_logic_vector(127 downto 0) := "00000000011000000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
constant word_53 : std_logic_vector(127 downto 0) := "00000000011100000000000110100000000000000000000000000000011010000010000001100110000101010000011011101010111000000100000011000000";
--write post processing relevant registers 54-59
constant word_54 : std_logic_vector(127 downto 0) := "00000000000000000000001010000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_55 : std_logic_vector(127 downto 0) := "00000000000000000000001010100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_56 : std_logic_vector(127 downto 0) := "00000000000000000000001011000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_57 : std_logic_vector(127 downto 0) := "00000000000000000000001011100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_58 : std_logic_vector(127 downto 0) := "00000000000000000000001100000000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";
constant word_59 : std_logic_vector(127 downto 0) := "00000000000000000000001100100000000000000000000000000000011010000000000001100010000001010000011010101010101000000000000001000000";

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
wait for 30 ns;
rst <= '1';
wait for 60 ns;
--Load registers
ve_in <= (others => '0');
pl<= word_0;
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl<= word_1;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl<= word_2;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_3;
wait for 30 ns;
ybus <= x"04";
wait for 30 ns;
pl<= word_4;
wait for 30 ns;
ybus <= x"05";
wait for 30 ns;
pl<= word_5;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_6;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_7;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_8;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_9;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_10;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl<= word_11;
ybus <= x"00";
wait for 60 ns;
pl<= word_12;
ybus <= x"06";
wait for 60 ns;
pl<= word_13;
ybus <= x"06";
wait for 60 ns;
pl<= word_42; --Write config register
ybus <= x"0d";
wait for 60 ns;
progress <= 1;
--pl<= word_14;
--ybus <= x"06";
--wait for 60 ns;
--pl<= word_15;
--ybus <= x"06";
--wait for 60 ns;
--
pl(100)<= '1';
--pl(107)<= '1';
pl(99) <= '1';
pl(98) <= '1'; --re start, re reload, mode_a
wait for 60 ns;
pl(100) <= '0';
--pl(107)<= '0';
pl(99) <= '0';
pl(98) <= '0';
wait for 600 ns;
progress <= 2;
ddi_vld <= '1';
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"0000000000000003";
wait for 30 ns;
ve_in <= x"0000000000000001";
wait for 30 ns;
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"000000000000000a";
wait for 30 ns;
ve_in <= x"0000000000000010";
wait for 30 ns;
ddi_vld <= '0';
ve_in <= (others => '0');
wait for 60 ns;
pl(100)<= '1';
pl(99) <= '1';
pl(97) <= '1'; --re start, re load, mode_b
wait for 60 ns;
pl(100) <= '0';
pl(99) <= '0';
pl(97) <= '0';
wait for 600 ns;
ddi_vld <= '1';
ve_in <= x"0000000000000001";
wait for 30 ns;
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"0000000000000003";
wait for 30 ns;
ve_in <= x"0000000000000004";
wait for 30 ns;
ve_in <= x"000000000000000a";
wait for 30 ns;
ve_in <= x"0000000000000010";
wait for 30 ns;
ddi_vld <= '0';
ve_in <= (others => '0');
wait for 120 ns;
--load ve registers --Does not match the previous time line of data from ybus. Check!
pl<= word_5;
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl<= word_6;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl<= word_7;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_12;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
progress <= 3;
--VE start, ve_reload
Pl(95) <= '1';
pl(98) <= '1';
pl(107) <= '1';
pl(99) <= '1';
--pl(97) <= '1';
wait for 60 ns;
pl(95) <= '0';
pl(107) <= '0';
pl(98) <= '0';
pl(97) <= '0';
wait for 600 ns;
--Start testing a process with outer loop
progress <= 20;
pl<= word_42; --Write config register
wait for 30 ns;
ybus <= x"15";
wait for 30 ns;
pl<= word_43; --Write ve outer loop register
wait for 30 ns;
ybus <= x"02"; --Do 3 outer loops;
wait for 30 ns;
pl<= word_2; --Load re_loop
wait for 30 ns;
ybus <= x"0c"; --Load 12 words;
wait for 30 ns;
pl(100)<= '1';
pl(99) <= '1';
pl(97) <= '1'; --re start, re load, mode_b
wait for 60 ns;
pl(100) <= '0';
pl(99) <= '0';
pl(97) <= '0';
wait for 600ns;
ddi_vld <= '1';
ve_in <= x"0000000000000001";
wait for 30 ns;
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"0000000000000003";
wait for 30 ns;
ve_in <= x"0000000000000004";
wait for 30 ns;
ve_in <= x"0000000000000005";
wait for 30 ns;
ve_in <= x"0000000000000006";
wait for 30 ns;
ve_in <= x"0000000000000007";
wait for 30 ns;
ve_in <= x"0000000000000008";
wait for 30 ns;
ve_in <= x"0000000000000009";
wait for 30 ns;
ve_in <= x"000000000000000a";
wait for 30 ns;
ve_in <= x"000000000000000b";
wait for 30 ns;
ve_in <= x"000000000000000c";
wait for 30 ns;
progress <= 21;
ddi_vld <= '0';
ve_in <=( others => '0');
wait for 60 ns;
pl<= word_2; --write re_loop register;
ybus<=x"04";  --Load 4 words;
wait for 60 ns;
pl(100)<= '1';
--pl(107)<= '1';
pl(99) <= '1';
pl(98) <= '1'; --re start, re reload, mode_a
wait for 60 ns;
pl(100)<= '0';
--pl(107)<= '1';
pl(99) <= '0';
pl(98) <= '0'; --re start, re reload, mode_a
wait for 240 ns;
ddi_vld <= '1';
ve_in <= x"0000000000000001";
wait for 30 ns;
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"0000000000000003";
wait for 30 ns;
ve_in <= x"0000000000000004";
wait for 30 ns;
ddi_vld <= '0';
ve_in <=( others => '0');
progress <= 22;
wait for 60 ns;
wait for 360 ns;
pl<= word_5;
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl<= word_6;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl<= word_7;
wait for 30 ns; --inner loop, 4
ybus <= x"04";
wait for 30 ns;
progress<=23;
Pl(95) <= '1';
pl(107) <= '1';
pl(99) <= '1';
pl(97) <= '1';
pl(93) <= '1'; --clear accumulator
wait for 60 ns;
pl(95) <= '0';
pl(107) <= '0';
pl(99) <= '0';
pl(98) <= '0';
pl(97) <= '0'; --Expected result: 1*1+2*2+3*3+4*4+1*5+2*6+3*7+4*8+1*9+2*10+3*11+4*12 = 210 = x"d2" in acc_latch_0;
pl(93)<= '0';
wait for 6000 ns;
--Mode C testing
progress <= 30;
pl <= word_44; --write ring_end_address
wait for 30 ns;
ybus <= x"2b"; --43 
wait for 30 ns;
pl <= word_45;
wait for 30 ns;
ybus <= x"10"; --17 --ring start address
wait for 30 ns;
pl <= word_8;
wait for 30 ns;
ybus<= x"00";  --Offset 
wait for 30 ns;
pl<= word_10;
wait for 30 ns;
ybus <= x"03"; --Depth
progress <= 7;
wait for 30 ns;
pl <= word_46;
wait for 30 ns;
ybus<= x"01"; --write pushback register bit 0 to 7;
wait for 30 ns;
pl <= word_47;
wait for 30 ns;
ybus <= x"00";--write pushback register bit 8 to 15;
wait for 30 ns;
pl(100) <= '1';
pl(96) <= '1';
pl(92) <= '1'; --re_start, mode c
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl<= word_47;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl(100) <= '1';
pl(96) <= '1';
pl(92) <= '1'; --re_start, mode c
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"03";
wait for 30 ns;
pl(100) <= '1';
pl(92) <= '1'; --re_start, mode c
pl(96) <= '1';
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"04";
wait for 30 ns;
pl<= word_47;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl(100) <= '1';
pl(96) <= '1';
pl(92) <= '1'; --re_start, mode c
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"05";
wait for 30 ns;
pl(100) <= '1';
pl(92) <= '1'; --re_start, mode c
pl(96) <= '1';
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_47;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl(100) <= '1';
pl(96) <= '1';
pl(92) <= '1'; --re_start, mode c
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"07";
wait for 30 ns;
pl(100) <= '1';
pl(92) <= '1'; --re_start, mode c
pl(96) <= '1';
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"08";
wait for 30 ns;
pl<= word_47;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl(100) <= '1';
pl(96) <= '1';
pl(92) <= '1'; --re_start, mode c
wait for 60 ns;
pl<= word_46;
wait for 30 ns;
ybus <= x"09";
wait for 30 ns;
pl(100) <= '1';
pl(92) <= '1'; --re_start, mode c
pl(96) <= '1';
wait for 60 ns;
pl <= word_42;
wait for 30 ns;
ybus <= x"41";
wait for 30 ns;
pl(100) <= '0';
pl(99) <= '1';
pl(95) <= '1';  --ve_start, mode c
pl(93) <= '1';
pl(92) <= '1'; 
pl(96) <= '0';
wait for 60 ns;
pl(99) <= '0';
pl(95) <= '0';
pl(93) <= '0';
pl(92) <= '0';
wait for 1200 ns;
--Test post processing block
progress <= 100;
pl <= word_54; --write zp_data
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl <= word_55; --write zp_weight
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl<= word_56;  --write scale factor
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl<= word_57;  --write post processing control register
wait for 30 ns;
ybus <= x"08"; --"00001000"
wait for 30 ns;
pl<= word_59;  --write starting indexing register
wait for 30 ns;
ybus <= x"05";
wait for 30 ns;
pl<= word_2;
wait for 30 ns; --inner loop, 1 word.
ybus <= x"02"; 
wait for 30 ns;
pl(100) <= '1'; --re_start, mode_a and mode_b both asserts
pl(99) <= '1';
pl(98) <= '1';
pl(97) <= '1';
wait for 60 ns;
pl(100) <= '0';
pl(99) <= '0';
pl(98) <= '0';
pl(97) <= '0';
wait for 300 ns;
ve_in <= x"0001000200030004"; --write 2 bram words
ddi_vld <= '1';
wait for 60 ns;
ddi_vld <= '0';
ve_in <=x"1000000000000000";
--ve_in <= (others => '0');
progress <= 101;
wait for 120 ns;
pl<= word_0;
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl<= word_1;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl<= word_2;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
--pl<= word_3;
--wait for 30 ns;
--ybus <= x"04";
--wait for 30 ns;
--pl<= word_4;
--wait for 30 ns;
--ybus <= x"05";
--wait for 30 ns;
--pl<= word_5;
--wait for 30 ns;
--ybus <= x"06";
--wait for 30 ns;
--pl<= word_6;
--wait for 30 ns;
--ybus <= x"06";
--wait for 30 ns;
--pl<= word_7;
--wait for 30 ns;
--ybus <= x"06";
--wait for 30 ns;
--pl<= word_8;
--wait for 30 ns;
--ybus <= x"06";
--wait for 30 ns;
--pl<= word_9;
--wait for 30 ns;
--ybus <= x"06";
--wait for 30 ns;
--pl<= word_10;
--wait for 30 ns;
--ybus <= x"00";
--wait for 30 ns;
--pl<= word_11;
--ybus <= x"00";
--wait for 60 ns;
--pl<= word_12;
--ybus <= x"06";
--wait for 60 ns;
--pl<= word_13;
--ybus <= x"06";
--wait for 60 ns;
--pl<= word_42; --Write config register
--ybus <= x"0d";
--wait for 60 ns;
--progress <= 1;
--pl<= word_14;
--ybus <= x"06";
--wait for 60 ns;
--pl<= word_15;
--ybus <= x"06";
--wait for 60 ns;
--
pl(100)<= '1';
--pl(107)<= '1';
pl(99) <= '1';
pl(98) <= '1'; --re start, re reload, mode_a
wait for 60 ns;
pl(100) <= '0';
--pl(107)<= '0';
pl(99) <= '0';
pl(98) <= '0';
wait for 600 ns;
progress <= 2;
ddi_vld <= '1';
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"0000000000000003";
wait for 30 ns;
ve_in <= x"0000000000000001";
wait for 30 ns;
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"000000000000000a";
wait for 30 ns;
ve_in <= x"0000000000000010";
wait for 30 ns;
ddi_vld <= '0';
ve_in <= (others => '0');
wait for 60 ns;
pl(100)<= '1';
pl(99) <= '1';
pl(97) <= '1'; --re start, re load, mode_b
wait for 60 ns;
pl(100) <= '0';
pl(99) <= '0';
pl(97) <= '0';
wait for 600 ns;
ddi_vld <= '1';
ve_in <= x"0000000000000001";
wait for 30 ns;
ve_in <= x"0000000000000002";
wait for 30 ns;
ve_in <= x"0000000000000003";
wait for 30 ns;
ve_in <= x"0000000000000004";
wait for 30 ns;
ve_in <= x"000000000000000a";
wait for 30 ns;
ve_in <= x"0000000000000010";
wait for 30 ns;
ddi_vld <= '0';
ve_in <= (others => '0');
wait for 120 ns;
wait for 60 ns;
progress <= 102;
pl<= word_5;
wait for 30 ns;
ybus <= x"01";
wait for 30 ns;
pl<= word_6;
wait for 30 ns;
ybus <= x"02";
wait for 30 ns;
pl<= word_7;
wait for 30 ns;
ybus <= x"06";
wait for 30 ns;
pl<= word_12;
wait for 30 ns;
ybus <= x"00";
wait for 30 ns;
pl<= word_42;
wait for 30 ns;
ybus<= x"0d";
wait for 30 ns;
progress <= 103;
pl <= word_59;
wait for 30 ns;
ybus <= x"14";
wait for 30 ns;
--VE start, ve_reload
Pl(95) <= '1';
pl(98) <= '1';
--pl(107) <= '1';
pl(99) <= '1';
--pl(97) <= '1';
wait for 60 ns;
pl(95) <= '0';
pl(107) <= '0';
pl(98) <= '0';
pl(97) <= '0';
wait for 600 ns; --expected ressult in acc_reg_0 : x"153", in p_adder_out : x"ad", in clip_out: x"ff"



wait;
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
    CLK_P       => clk_p,
    CLK_E_POS   => clk_e_pos,
    CLK_E_NEG   => clk_e_neg,
    RST         => rst,
    PL          => pl,
    YBUS        => ybus,
    DDI_VLD     => ddi_vld,
    RE_RDY      => re_rdy,
    VE_RDY      => ve_rdy,
    VE_IN       => ve_in,
    VE_OUT_D    => ve_out_d,
    VE_OUT_DTM => ve_out_dtm
);
end Behavioral;
