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

entity re_tb is
--  Port ( );
end re_tb;

architecture Behavioral of re_tb is
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
type mem_w is array(255 downto 0) of std_logic_vector(63 downto 0);
type processes is (load_para, exe, re_mode_l, re_mode_r, re_mode_b, p_mode_a, p_mode_b, conv_mode_l, conv_mode_r, conv_mode_b, mode_c, bypass, FFT);
signal virtual_mem : mem;
signal data_counter : unsigned(8 downto 0) := '0' & x"00";
signal clk_p : std_logic;
signal clk_e_pos : std_logic;
signal clk_e_neg : std_logic;
signal rst, ve_push_dtm : std_logic;
signal pl : std_logic_vector(127 downto 0);
signal ybus : std_logic_vector(7 downto 0);
signal ddi_vld : std_logic;
signal re_rdy : std_logic;
signal ve_rdy, ve_rdy_delay : std_logic;
signal read_out_done, load_mem, fft_read_done : std_logic;
signal ve_in : std_logic_vector(63 downto 0);
signal ve_out_d : std_logic_vector(7 downto 0);
signal ve_out_dtm : std_logic_vector(127 downto 0);
signal progress : processes;
signal debug, i   : integer;
signal fft_resmem, fft_outref : mem_dd;
signal data_memory0, data_memory1 : mem_d;
signal weight_memory : mem_w;


--pl fields
constant au_test_loffset0 : std_logic_vector(127 downto 0) := x"00000200000000000000000000000000";
constant au_test_loffset1 : std_logic_vector(127 downto 0) := x"00000210000000000000000000000000";
constant au_test_loffset2 : std_logic_vector(127 downto 0) := x"00000220000000000000000000000000";
constant au_test_loffset3 : std_logic_vector(127 downto 0) := x"00000230000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant au_test_lcmp0 : std_logic_vector(127 downto 0)    := x"00000240000000000000000000000000";
constant au_test_lcmp1 : std_logic_vector(127 downto 0)    := x"00000250000000000000000000000000";
constant au_test_lcmp2 : std_logic_vector(127 downto 0)    := x"00000260000000000000000000000000";
constant au_test_lcmp3 : std_logic_vector(127 downto 0)    := x"00000270000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant au_test_roffset0 : std_logic_vector(127 downto 0) := x"00000280000000000000000000000000";
constant au_test_roffset1 : std_logic_vector(127 downto 0) := x"00000290000000000000000000000000";
constant au_test_roffset2 : std_logic_vector(127 downto 0) := x"000002A0000000000000000000000000";
constant au_test_roffset3 : std_logic_vector(127 downto 0) := x"000002B0000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant au_test_rcmp0 : std_logic_vector(127 downto 0)    := x"000002C0000000000000000000000000";
constant au_test_rcmp1 : std_logic_vector(127 downto 0)    := x"000002D0000000000000000000000000";
constant au_test_rcmp2 : std_logic_vector(127 downto 0)    := x"000002E0000000000000000000000000";
constant au_test_rcmp3 : std_logic_vector(127 downto 0)    := x"000002F0000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant au_test_boffset0 : std_logic_vector(127 downto 0) := x"00000300000000000000000000000000";
constant au_test_boffset1 : std_logic_vector(127 downto 0) := x"00000310000000000000000000000000";
constant au_test_boffset2 : std_logic_vector(127 downto 0) := x"00000320000000000000000000000000";
constant au_test_boffset3 : std_logic_vector(127 downto 0) := x"00000330000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant au_test_bcmp0 : std_logic_vector(127 downto 0)    := x"00000340000000000000000000000000";
constant au_test_bcmp1 : std_logic_vector(127 downto 0)    := x"00000350000000000000000000000000";
constant au_test_bcmp2 : std_logic_vector(127 downto 0)    := x"00000360000000000000000000000000";
constant au_test_bcmp3 : std_logic_vector(127 downto 0)    := x"00000370000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant pa_tset_offset0 : std_logic_vector(127 downto 0)  := X"00000380000000000000000000000000";
constant pa_tset_offset1 : std_logic_vector(127 downto 0)  := X"00000390000000000000000000000000";
constant pa_tset_offset2 : std_logic_vector(127 downto 0)  := X"000003A0000000000000000000000000";
constant pa_tset_offset3 : std_logic_vector(127 downto 0)  := X"000003B0000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant pa_test_cmp0 : std_logic_vector(127 downto 0)     := X"000003C0000000000000000000000000";
constant pa_test_cmp1 : std_logic_vector(127 downto 0)     := X"000003D0000000000000000000000000";
constant pa_test_cmp2 : std_logic_vector(127 downto 0)     := X"000003E0000000000000000000000000";
constant pa_test_cmp3 : std_logic_vector(127 downto 0)     := X"000003F0000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant pb_tset_offset0 : std_logic_vector(127 downto 0)  := X"000001A0000000000000000000000000";
constant pb_tset_offset1 : std_logic_vector(127 downto 0)  := X"000001B0000000000000000000000000";
constant pb_tset_offset2 : std_logic_vector(127 downto 0)  := X"000001C0000000000000000000000000";
--constant pb_tset_offset3 : std_logic_vector(127 downto 0)  := X"000001B0000000000000000000000000";
--------------------------------------------------------------------------------------------------
constant pb_test_cmp0 : std_logic_vector(127 downto 0)     := X"000001D0000000000000000000000000";
constant pb_test_cmp1 : std_logic_vector(127 downto 0)     := X"000001E0000000000000000000000000";
constant pb_test_cmp2 : std_logic_vector(127 downto 0)     := X"000001F0000000000000000000000000";
--constant pb_test_cmp3 : std_logic_vector(127 downto 0)     := X"000001F0000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant re_loop    : std_logic_vector(127 downto 0)       := x"00000030000000000000000000000000";
constant re_saddr_l : std_logic_vector(127 downto 0)       := x"00000010000000000000000000000000";
constant re_saddr_r : std_logic_vector(127 downto 0)       := x"00000020000000000000000000000000";
constant re_saddr_a : std_logic_vector(127 downto 0)       := x"00000040000000000000000000000000";
constant re_saddr_b : std_logic_vector(127 downto 0)       := x"00000050000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant ve_loop    : std_logic_vector(127 downto 0)       := x"00000080000000000000000000000000";
constant ve_oloop   : std_logic_vector(127 downto 0)       := x"00000100000000000000000000000000";
constant bias_end   : std_logic_vector(127 downto 0)       := x"00000180000000000000000000000000";
constant ve_saddr_l : std_logic_vector(127 downto 0)       := x"00000060000000000000000000000000";
constant ve_saddr_r : std_logic_vector(127 downto 0)       := x"00000070000000000000000000000000";
constant bias_saddr : std_logic_vector(127 downto 0)       := x"00000190000000000000000000000000";
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
constant configure  : std_logic_vector(127 downto 0)       := x"00000110000000000000000000000000";
constant pp_ctl     : std_logic_vector(127 downto 0)       := x"00000170000000000000000000000000";
-- fft test
--constant mode_fft : std_logic_vector(127 downto 0) :="";
constant load_lc  : std_logic_vector(127 downto 0) := x"00000080000000000000000000000000";
--constant start    : std_logic_vector(127 downto 0) :="";
--fft test data
constant fft_test_data0     : string := "FFT_256_data0.dat";
constant fft_test_data1     : string := "FFT_256_data1.dat";
constant fft_test_tf        : string := "FFT_256_tf.dat";
constant fft_out_ref        : string := "FFT_256_out_ref.dat";
constant fft_out            : string := "FFT_256_out.dat";
constant fft_points         : integer := 256;
constant fft_stages         : std_logic_vector := x"06";--max 7 = 512 point


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
  file load_text_file : text open read_mode is fft_test_data0;
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
  file load_text_file : text open read_mode is fft_test_data1;
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
  file load_text_file : text open read_mode is fft_test_tf;
  variable text_line : line;
  variable val_bias : std_logic_vector(63 downto 0);
  begin
    if load_mem = '1' then
      for i in 0 to 255 loop
        exit when endfile(load_text_file);
        readline(load_text_file,text_line);
        hread(text_line, val_bias);
        weight_memory(i) <= val_bias;
      end loop ;
    end if;
  end process;

  process(load_mem)
  file load_text_file : text open read_mode is fft_out_ref;
  variable text_line : line;
  variable val_bias : std_logic_vector(31 downto 0);
  begin
    if load_mem = '1' then
      for i in 0 to 511 loop
        exit when endfile(load_text_file);
        readline(load_text_file,text_line);
        hread(text_line, val_bias);
        fft_outref(i) <= val_bias;
      end loop ;
    end if;
  end process;

  process(fft_read_done)
  file save_text_file : text open write_mode is fft_out;
  variable text_line : line;
  begin
    if fft_read_done = '1' then
      for i in 0 to fft_points - 1 loop
        hwrite(text_line, fft_resmem(i));
        writeline(save_text_file, text_line);
      end loop;
    end if;
  end process;

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
pl <= re_loop;
ybus <= x"36";
wait for 30.01 ns;
pl <= pp_ctl;
ybus <= x"F8";
wait for 30.01 ns;
progress <= re_mode_r;
pl <= au_test_roffset0;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_roffset1;
ybus <= x"0f";
wait for 30.01 ns;
pl <= au_test_roffset2;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_roffset3;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_rcmp0;
ybus <= x"06";
wait for 30.01 ns;
pl <= au_test_rcmp1;
ybus <= x"1e";
wait for 30.01 ns;
pl <= au_test_rcmp2;
ybus <= x"02";
wait for 30.01 ns;
pl <= au_test_rcmp3;
ybus <= x"03";
wait for 30.01 ns;
pl <= re_saddr_r;
ybus <= x"03";
wait for 30.01 ns;
pl(95) <= '1'; --start
pl(96) <= '0'; --resource 0
pl(98) <= '0'; --mode a 
pl(97) <= '1'; --mode b 
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
wait for 30 ns;
DDI_VLD <= '1';
for i in 0 to 53 loop
  ve_in <= std_logic_vector(to_unsigned(i, 64));
  wait for 15 ns;
end loop;
DDI_VLD <= '0';
wait for 30 ns;
progress <= re_mode_l;
pl <= au_test_loffset0;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_loffset1;
ybus <= x"0f";
wait for 30.01 ns;
pl <= au_test_loffset2;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_loffset3;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_lcmp0;
ybus <= x"06";
wait for 30.01 ns;
pl <= au_test_lcmp1;
ybus <= x"1e";
wait for 30.01 ns;
pl <= au_test_lcmp2;
ybus <= x"02";
wait for 30.01 ns;
pl <= au_test_lcmp3;
ybus <= x"03";
wait for 30.01 ns;
pl <= re_saddr_l;
ybus <= x"05";
wait for 30.01 ns;
pl(96) <= '0'; --resource 0
pl(95) <= '1'; --start
pl(98) <= '1'; --mode a 
pl(97) <= '0'; --mode b 
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
wait for 30 ns;
DDI_VLD <= '1'; 
for i in 54 to 107 loop
  ve_in <= std_logic_vector(to_unsigned(i, 64));
  wait for 15 ns;
end loop;
DDI_VLD <= '0';
wait for 30 ns;

progress <= re_mode_b;
pl <= au_test_boffset0;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_boffset1;
ybus <= x"0f";
wait for 30.01 ns;
pl <= au_test_boffset2;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_boffset3;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_bcmp0;
ybus <= x"06";
wait for 30.01 ns;
pl <= au_test_bcmp1;
ybus <= x"1e";
wait for 30.01 ns;
pl <= au_test_bcmp2;
ybus <= x"02";
wait for 30.01 ns;
pl <= au_test_bcmp3;
ybus <= x"03";
wait for 30.01 ns;
pl <= re_saddr_l;
ybus <= x"05";
wait for 30.01 ns;
pl(96) <= '0'; --resource 0
pl(95) <= '1'; --start
pl(98) <= '1'; --mode a 
pl(97) <= '1'; --mode b 
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
wait for 30 ns;
DDI_VLD <= '1'; 
for i in 108 to 161 loop
  ve_in <= std_logic_vector(to_unsigned(i, 64));
  wait for 15 ns;
end loop;
DDI_VLD <= '0';
wait for 90 ns;

load_mem <= '1';
wait for 30 ns;
load_mem <= '0';
wait for 60 ns;
pl(94) <= '1';
wait for 30 ns;
pl(94) <= '0'; 
pl <= re_loop;
ybus <= std_logic_vector(to_unsigned(fft_points/2, 8));
wait for 30.01 ns;
progress <= re_mode_l;
pl <= au_test_loffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_lcmp0;
ybus <= std_logic_vector(to_unsigned(fft_points/2, 8));
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
for i in 1 to (fft_points/2) - 1 loop
  ve_in <= data_memory0(i) & data_memory1(i);
  wait for 15 ns;
end loop;
  wait for 15 ns;
DDI_VLD <= '0';

wait for 30 ns;
pl <= au_test_roffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_roffset1;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_rcmp0;
ybus <= std_logic_vector(to_unsigned(fft_points/2, 8));
wait for 30.01 ns;
pl <= re_saddr_r;
ybus <= x"00";
wait for 30.01 ns;
pl(95) <= '1'; --start
pl(96) <= '0'; --resource 0
pl(98) <= '0'; --mode a 
pl(97) <= '1'; --mode b 
pl(99) <= '1';
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
pl(99) <= '0';
wait for 30 ns;
ve_in <= weight_memory(0);
wait for 15 ns;
DDI_VLD <= '1';
for i in 1 to (fft_points/2) - 1 loop
  ve_in <= weight_memory(i);
  wait for 15 ns;
end loop;
  wait for 15 ns;
DDI_VLD <= '0';
wait for 30 ns;

pl(94) <= '0';
pl(107) <= '1';
wait for 30 ns;
pl(107) <= '0';
pl <= ve_loop;
ybus <= x"03";
wait for 30.01 ns;
pl <= ve_oloop;
ybus <= x"10";
wait for 30.01 ns;
pl <= bias_end;
ybus <= x"03";
wait for 30.01 ns;
progress <= conv_mode_b;
pl <= au_test_boffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_boffset1;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_boffset2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_boffset3;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_bcmp0;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_bcmp1;
ybus <= x"0f";
wait for 30.01 ns;
pl <= au_test_bcmp2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_bcmp3;
ybus <= x"00";
wait for 30.01 ns;
pl <= bias_saddr;
ybus <= x"04";
wait for 30 ns;
progress <= conv_mode_r;
pl <= au_test_roffset0;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_roffset1;
ybus <= x"0f";
wait for 30.01 ns;
pl <= au_test_roffset2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_roffset3;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_rcmp0;
ybus <= x"06";
wait for 30.01 ns;
pl <= au_test_rcmp1;
ybus <= x"1e";
wait for 30.01 ns;
pl <= au_test_rcmp2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_rcmp3;
ybus <= x"00";
wait for 30.01 ns;
pl <= ve_saddr_r;
ybus <= x"03";
wait for 30.01 ns;
pl <= configure;
ybus <= x"14";
wait for 30 ns;
progress <= conv_mode_l;
pl <= au_test_loffset0;
ybus <= x"03";
wait for 30.01 ns;
pl <= au_test_loffset1;
ybus <= x"0f";
wait for 30.01 ns;
pl <= au_test_loffset2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_loffset3;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_lcmp0;
ybus <= x"06";
wait for 30.01 ns;
pl <= au_test_lcmp1;
ybus <= x"1e";
wait for 30.01 ns;
pl <= au_test_lcmp2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_lcmp3;
ybus <= x"00";
wait for 30.01 ns;
pl <= ve_saddr_l;
ybus <= x"05";
wait for 30.01 ns;
pl <= re_saddr_b;
ybus <= x"03";
wait for 30.01 ns;
pl <= re_saddr_a;
ybus <= x"01";
wait for 30.01 ns;
pl <= pa_test_cmp0;
ybus <= x"05";
wait for 30.01 ns;
pl <= pa_tset_offset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= pb_test_cmp0;
ybus <= x"06";
wait for 30.01 ns;
pl <= pb_tset_offset0;
ybus <= x"02";
wait for 30.01 ns;
pl(96) <= '1'; --resource 1
pl(99) <= '1';
wait for 30 ns;
pl(99) <= '0';
wait for 120 ns;
pl(95) <= '1';
pl(99) <= '1';
wait for 30 ns;
pl(95) <= '0';
pl(99) <= '0';
wait for 660 ns;
pl(97) <= '1'; --mode a 
wait for 30 ns;
pl(97) <= '0'; --mode a 
wait until ve_rdy = '1';
progress <= p_mode_a;
--pl(94) <= '1';
--wait for 30 ns;
--pl(94) <= '0'; 
wait for 60 ns;
pl(99) <= '0'; --cnt_rst = '0'
pl(98) <= '1'; --mode a 
pl(97) <= '0'; --mode b 
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a 
progress <= p_mode_b;
wait for 30 ns;
pl(99) <= '0'; --cnt_rst = '0'
pl(98) <= '0'; --mode a 
pl(97) <= '1'; --mode b 
wait for 90 ns;
pl(95) <= '0'; --start
progress <= p_mode_a;
wait for 30 ns;
pl(99) <= '0'; --cnt_rst = '0'
pl(98) <= '1'; --mode a 
pl(97) <= '0'; --mode b 
wait for 90 ns;
progress <= mode_c;
pl <= ve_loop;
ybus <= x"09";
wait for 30.01 ns;
pl <= ve_oloop;
ybus <= x"02";
wait for 30.01 ns;
pl <= au_test_loffset0;
ybus <= x"12";
wait for 30.01 ns;
pl <= au_test_lcmp0;
ybus <= x"90";
wait for 30.01 ns;
pl <= au_test_loffset1;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_loffset2;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_loffset3;
ybus <= x"00";
wait for 30.01 ns;
pl <= pp_ctl;
ybus <= x"F5";
pl(99) <= '1'; --cnt_rst = '1'
wait for 30.01 ns;
pl(95) <= '1';
pl(92) <= '1';
wait for 30 ns;
pl(92) <= '0';
pl(99) <= '0'; --cnt_rst = '1'
pl(95) <= '0'; --start
wait for 525 ns;
progress <= bypass;
pl(99) <= '1';
wait for 30 ns;
pl(99) <= '0';
--pl(121) <= '1';
wait for 30 ns;
pl <= pp_ctl;
ybus <= x"F8";
--pl(99) <= '1'; --cnt_rst = '1'
--pl(95) <= '1'; --start
--wait for 30 ns;
--pl(99) <= '0'; --cnt_rst = '1'
--pl(95) <= '0'; --start
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
ybus <= std_logic_vector(to_unsigned(fft_points/2, 8));
wait for 30.01 ns;
progress <= re_mode_l;
pl <= au_test_loffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_lcmp0;
ybus <= std_logic_vector(to_unsigned(fft_points/2, 8));
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
for i in 1 to (fft_points/2) - 1 loop
  ve_in <= data_memory0(i) & data_memory1(i);
  wait for 15 ns;
end loop;
  wait for 15 ns;
DDI_VLD <= '0';

wait for 30 ns;
progress <= re_mode_r;
pl <= au_test_roffset0;
ybus <= x"01";
wait for 30.01 ns;
pl <= au_test_roffset1;
ybus <= x"00";
wait for 30.01 ns;
pl <= au_test_rcmp0;
ybus <= std_logic_vector(to_unsigned(fft_points/2, 8));
wait for 30.01 ns;
pl <= re_saddr_r;
ybus <= x"00";
wait for 30.01 ns;
pl(95) <= '1'; --start
pl(96) <= '0'; --resource 0
pl(98) <= '0'; --mode a 
pl(97) <= '1'; --mode b 
pl(99) <= '1';
wait for 30 ns;
pl(95) <= '0'; --start
pl(98) <= '0'; --mode a off
pl(97) <= '0'; --mode b off
pl(99) <= '0';
wait for 30 ns;
ve_in <= weight_memory(0);
wait for 15 ns;
DDI_VLD <= '1';
for i in 1 to (fft_points/2) - 1 loop
  ve_in <= weight_memory(i);
  wait for 15 ns;
end loop;
  wait for 15 ns;
DDI_VLD <= '0';
wait for 30 ns;
--ddi_vld <= '1';
pl(106) <= '1'; --fft
progress <= fft;
wait for 30 ns;
pl <= ve_loop;
ybus <= fft_stages;
wait for 30.01 ns;
pl(95) <= '1';
wait for 30 ns;
pl(95) <= '0';
wait until fft_read_done = '1';

for i in 0 to fft_points -1 loop
  assert (fft_resmem(i) = fft_outref(i))
  report "Incorrect output data in fft_resmem"&integer'image(i) severity warning;
  wait for 10 ns;
end loop;
--pl(94)<= '0';
--pl(93) <= '1';
--wait for 30 ns;
--progress <= ;
--pl <= load_lc;
--wait for 30 ns;
--ybus <= x"06";
--progress <= ;
--Pl(95) <= '1';
--wait for 30 ns;
--pl(95) <= '0';
--
--wait until read_out_done = '1';
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

process(clk_p, rst)
begin
  if rst = '0' then
    i <= 0;
    fft_read_done <= '0';
  elsif rising_edge(clk_p) then
    if progress = fft and ve_push_dtm = '1' and i < fft_points then
      fft_resmem(i) <= ve_out_dtm(31 downto 0);
      fft_resmem(i+1) <= ve_out_dtm(63 downto 32);
      fft_resmem(i+2) <= ve_out_dtm(95 downto 64);
      fft_resmem(i+3) <= ve_out_dtm(127 downto 96);
      i <= i + 4;
    else
      if i >= fft_points then
        i <= 0;
        fft_read_done <= '1';
      end if;
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
