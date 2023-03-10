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
use std.textio.all;
use std.env.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matinv_tb is
--  Port ( );
end matinv_tb;

architecture Behavioral of matinv_tb is
component ve
    generic(
    USE_ASIC_MEMORIES : boolean := false
    );
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
type mem_d is array(255 downto 0) of std_logic_vector(31 downto 0);
type mem_dd is array(511 downto 0) of std_logic_vector(31 downto 0);
type mem_b is array(63 downto 0) of std_logic_vector(63 downto 0);
type processes is (load_para, exe, re_mode_l, re_mode_r, re_mode_b, p_mode_a, p_mode_b, conv_mode_l, conv_mode_r, conv_mode_b, mode_c, bypass, FFT, matinv);
signal clk_p : std_logic;
signal clk_e_pos : std_logic;
signal clk_e_neg : std_logic;
signal rst, ve_push_dtm : std_logic;
signal pl : std_logic_vector(127 downto 0);
signal ybus : std_logic_vector(7 downto 0);
signal ddi_vld : std_logic;
signal re_rdy : std_logic;
signal ve_rdy, ve_rdy_delay : std_logic;
signal load_mem : std_logic;
signal ve_in : std_logic_vector(63 downto 0);
signal ve_out_d : std_logic_vector(7 downto 0);
signal ve_out_dtm : std_logic_vector(127 downto 0);
signal progress : processes;
signal debug, i   : integer;
signal data_memory0, data_memory1 : mem_d;
signal bias_memory : mem_b;


--pl fields
constant au_test_loffset0 : std_logic_vector(127 downto 0) := x"00000200000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant au_test_lcmp0 : std_logic_vector(127 downto 0)    := x"00000240000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant au_test_roffset0 : std_logic_vector(127 downto 0) := x"00000280000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant au_test_rcmp0 : std_logic_vector(127 downto 0)    := x"000002C0000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant au_test_boffset0 : std_logic_vector(127 downto 0) := x"00000300000000000000000000000000";
constant au_test_boffset1 : std_logic_vector(127 downto 0) := x"00000310000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant au_test_bcmp0 : std_logic_vector(127 downto 0)    := x"00000340000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant re_loop    : std_logic_vector(127 downto 0)       := x"00000030000000000000000000000000";
constant re_saddr_l : std_logic_vector(127 downto 0)       := x"00000010000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant ve_loop    : std_logic_vector(127 downto 0)       := x"00000080000000000000000000000000";
constant bias_saddr : std_logic_vector(127 downto 0)       := x"00000190000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant configure  : std_logic_vector(127 downto 0)       := x"00000110000000000000000000000000";
constant pp_ctl     : std_logic_vector(127 downto 0)       := x"00000170000000000000000000000000";
-- matinv test data
constant matinv_test_data1  : string := "s1_matinv_30x30_data0.csv";
constant matinv_test_data2  : string := "s1_matinv_30x30_data1.csv";
constant matinv_table       : string := "R_hex.csv";
--constant matin_out_ref      : string := "";
constant nt_int             : integer := 15; -- 4-> 8*8
constant nt_std             : std_logic_vector := x"f";--max 15 = f


begin

  process
  begin
    clk_p <= '1';
    wait for 7.5 ns;
    clk_p<= '0';
    wait for 7.5 ns;
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
  
  process(load_mem)
  file load_text_file : text open read_mode is matinv_test_data1;
  variable text_line : line;
  variable val_bias : std_logic_vector(31 downto 0);
  begin
    if load_mem = '1' then
      for i in 0 to 255 loop
        exit when endfile(load_text_file);
        readline(load_text_file,text_line);
        hread(text_line, val_bias);
        data_memory0(i) <= val_bias;
      end loop ;
    end if;
  end process;

  process(load_mem)
  file load_text_file : text open read_mode is matinv_test_data2;
  variable text_line : line;
  variable val_bias : std_logic_vector(31 downto 0);
  begin
    if load_mem = '1' then
      for i in 0 to 255 loop
        exit when endfile(load_text_file);
        readline(load_text_file,text_line);
        hread(text_line, val_bias);
        data_memory1(i) <= val_bias;
      end loop ;
    end if;
  end process;

  process(load_mem)
  file load_text_file : text open read_mode is matinv_table;
  variable text_line : line;
  variable val_bias : std_logic_vector(63 downto 0);
  begin
    if load_mem = '1' then
      for i in 0 to 63 loop
        exit when endfile(load_text_file);
        readline(load_text_file,text_line);
        hread(text_line, val_bias);
        bias_memory(i) <= val_bias;
      end loop ;
    end if;
  end process;

  --process(load_mem)
  --file load_text_file : text open read_mode is fft_out_ref;
  --variable text_line : line;
  --variable val_bias : std_logic_vector(31 downto 0);
  --begin
  --  if load_mem = '1' then
  --    for i in 0 to 511 loop
  --      exit when endfile(load_text_file);
  --      readline(load_text_file,text_line);
  --      hread(text_line, val_bias);
  --      fft_outref(i) <= val_bias;
  --    end loop ;
  --  end if;
  --end process;

process
begin
--wait for 1 ns; --Manually added delay
rst <= '0';
load_mem <= '0';
--Reset
wait for 300 ns;
--DDI_VLD <= '1'; 
--wait for 30 ns;
DDI_VLD <= '0';
rst <= '1';
wait for 60 ns;
pl(94) <= '1';
wait for 30 ns;
pl(94) <= '0'; 
wait for 30 ns;
pl <= pp_ctl;
ybus <= x"F8";

wait for 120 ns;
ddi_vld <= '1';
wait for 135 ns;
ddi_vld <= '0';
wait for 810 ns;
load_mem <= '1';
wait for 30 ns;
load_mem <= '0';
wait for 60 ns;
pl(94) <= '1';
wait for 30 ns;
pl(94) <= '0'; 
pl <= re_loop;
ybus <= std_logic_vector(to_unsigned((((1+nt_int)*nt_int)/2 - 1), 8));
wait for 30.01 ns;
progress <= re_mode_l;
pl <= au_test_loffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_lcmp0;
ybus <= std_logic_vector(to_unsigned((((1+nt_int)*nt_int)/2 - 1), 8));
wait for 30.01 ns;
pl <= re_saddr_l;
ybus <= x"00";
wait for 30.01 ns;
pl(95) <= '1'; --start
pl(96) <= '0'; --resource 0
pl(98) <= '1'; --mode a 
pl(97) <= '0'; --mode b 
pl(99) <= '1';
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
pl(99) <= '0';
wait for 30 ns;
ve_in <= data_memory0(0) & data_memory1(0);
wait for 15 ns;
DDI_VLD <= '1';
for i in 1 to (((1+nt_int)*nt_int)/2 - 1) loop
  ve_in <= data_memory0(i) & data_memory1(i);
  wait for 15 ns;
end loop;
  wait for 15 ns;
DDI_VLD <= '0';

pl <= re_loop;
ybus <= std_logic_vector(to_unsigned(63, 8));
wait for 30.01 ns;
progress <= re_mode_b;
pl <= au_test_boffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_boffset1;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_bcmp0;
ybus <= std_logic_vector(to_unsigned(63, 8));
wait for 30.01 ns;
pl <= bias_saddr;
ybus <= x"00";
wait for 30.01 ns;
pl(95) <= '1'; --start
pl(96) <= '0'; --resource 0
pl(98) <= '1'; --mode a 
pl(97) <= '1'; --mode b 
pl(99) <= '1';
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
pl(99) <= '0';
wait for 30 ns;
ve_in <= bias_memory(0);
wait for 15 ns;
DDI_VLD <= '1';
for i in 1 to 63 loop
  ve_in <= bias_memory(i);
  wait for 15 ns;
end loop;
  wait for 15 ns;
DDI_VLD <= '0';
wait for 30 ns;
pl(106) <= '1';
pl(107) <= '1';
progress <= matinv;
wait for 30 ns;
pl <= ve_loop;
ybus <= x"0" & nt_std;
wait for 30.01 ns;
pl(95) <= '1';
wait for 30 ns;
pl(95) <= '0';
--------- read out set up ----------
pl <= au_test_lcmp0;
ybus <= std_logic_vector(to_unsigned((((1+nt_int)*nt_int) - 1), 8));
wait for 30.01 ns;
pl <= au_test_roffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_rcmp0;
ybus <= std_logic_vector(to_unsigned((((1+nt_int)*nt_int)/2 + nt_int*2 - 1), 8));
wait for 30.01 ns;
wait until ve_rdy = '1';
wait for 2000 ns;

report "simulation end";
finish;
end process;

process(clk_e_neg)
begin
  if rising_edge(clk_e_neg) then
    ve_rdy_delay <= ve_rdy;
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
generic map(
  USE_ASIC_MEMORIES => false
  )
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
    VE_PUSH_DTM  => ve_push_dtm,
    VE_AUTO_SEND => open,
    VE_OUT_D     => ve_out_d,
    VE_OUT_DTM   => ve_out_dtm
);
end Behavioral;
