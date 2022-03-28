----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2020 11:41:11 AM
-- Design Name: 
-- Module Name: Cluster_tb - Behavioral
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
use IEEE.NUMERIC_STD.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cluster_sim is
Port (
CLK_P            : out std_logic;     --PE clocks
CLK_E            : out std_logic;     --PE's execution clock 
RST_E            : out std_logic;

CLK_O            : in std_logic;

TAG              : out std_logic;
TAG_FB           : in std_logic;

C_RDY            : in std_logic; 
DATA             : out std_logic_vector(7 downto 0);
DATA_OUT         : in std_logic_vector(7 downto 0)
 );
end Cluster_sim;

architecture Behavioral of Cluster_sim is
    type mem_word   is array (15 downto 0) of std_logic_vector(7 downto 0);
    type out_word   is array (2591 downto 0) of std_logic_vector(7 downto 0);
   	type ram_type   is array (255 downto 0) of std_logic_vector(127 downto 0);
    type data_in    is array (359 downto 0) of std_logic_vector(127 downto 0);
    type kernels_in is array (80 downto 0) of std_logic_vector(127 downto 0);
    type bias_in    is array (17 downto 0) of std_logic_vector(127 downto 0);
    type result_out is array (161 downto 0) of std_logic_vector(127 downto 0);
	  type ram_type_b is array (255 downto 0) of bit_vector(127 downto 0);
    type data_in_b  is array (359 downto 0) of bit_vector(127 downto 0);
    type kernels_b  is array (80 downto 0) of bit_vector(127 downto 0);
    type bias_in_b  is array (17 downto 0) of bit_vector(127 downto 0);
    type res_out_b  is array (161 downto 0) of bit_vector(127 downto 0);

		impure function init_ram_from_file (ram_file_name : in string) return ram_type is
		FILE ram_file : text is in ram_file_name;
		variable ram_file_line : line;
		variable RAM_B : ram_type_b;
		variable RAM :ram_type;
		begin
			for i in 0 to 255 loop
				readline(ram_file, ram_file_line);
				read(ram_file_line, RAM_B(i));
				RAM(i) := to_stdlogicvector(RAM_B(i));
			end loop;
		return RAM;
	    end function;

      impure function init_input_from_file (ram_file_name : in string) return data_in is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : data_in_b;
        variable RAM :data_in;
        begin
          for i in 0 to 359 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
      end function;

      impure function init_kernel_from_file (ram_file_name : in string) return kernels_in is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : kernels_b;
        variable RAM :kernels_in;
        begin
          for i in 0 to 80 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
      end function;

      impure function init_bias_from_file (ram_file_name : in string) return bias_in is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : bias_in_b;
        variable RAM :bias_in;
        begin
          for i in 0 to 17 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
      end function;

      impure function init_out_from_file(ram_file_name : in string) return result_out is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : res_out_b;
        variable RAM :result_out;
        begin
          for i in 0 to 161 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
      end function;
	    
	    function conv_to_memword (ramword : std_logic_vector(127 downto 0)) return mem_word is
	    variable mem : mem_word;
	    begin
	    for i in 0 to 15 loop
	    mem(i) := ramword(8*i+7 downto 8*i);
	    end loop;
	    return mem;
	    end function;

signal ucode_dw  : ram_type := init_ram_from_file("microprogram_id.ascii");--("microprogram.ascii");
signal data_dw   : data_in := init_input_from_file("data_dw.ascii");
signal kernel_dw : kernels_in := init_kernel_from_file("kernels_dw.ascii");
signal bias_dw   : bias_in := init_bias_from_file("bias_dw.ascii");
signal ref_out   : result_out := init_out_from_file("ref_result.ascii");
signal clk_p_i : std_logic;
signal clk_e_i : std_logic;
signal clk_e_neg_i : std_logic;
signal tag_in  : std_logic;
signal tag_out : std_logic;
signal clk_o_i   :  std_logic;
signal rst_r   : std_logic;
signal req_in   : std_logic;  
signal req_fifo   : std_logic_vector(31 downto 0);
signal data_to_pe   : std_logic_vector(127 downto 0);
signal data_vld   : std_logic;
signal pe_unit   : std_logic_vector(5 downto 0);
signal rd_fifo   : std_logic;
signal fifo_vld   : std_logic;
signal bc        : std_logic;
signal mem_in     : mem_word;
signal outword    :  out_word;
signal out_ram    : result_out;
--Progress
signal progress : integer;
--Constants
constant RESET : std_logic_vector(5 downto 0) :="101111";
constant WRITEC : std_logic_vector(5 downto 0) :="100011"; --Write data contineous
constant READ  :  std_logic_vector(5 downto 0) :="100100"; --Read data
constant EXE   : std_logic_vector(5 downto 0) :="100110";
constant RESUME : std_logic_vector(5 downto 0) :="101000";
constant ucode_sa   : std_logic_vector(14 downto 0) := (others => '0'); --microcode start address in CM
constant kernels_sa : std_logic_vector(14 downto 0) := "000000100000000"; --0x100, start address of kernels
constant bias_sa    : std_logic_vector(14 downto 0) := "000001000000000"; --0x200, start address of bias
constant data_sa    : std_logic_vector(14 DOWNTO 0) := "000010000000000"; --ADDR HEX 400, DATA START ADDR
constant dw_out_a   : std_logic_vector(14 downto 0) := "100010000000000"; --0x4400, depthwise output address in CM.
constant ucode_len  : std_logic_vector(14 downto 0) := "000000011111111";--255, 256 words--microcode
constant kernels_len: std_logic_vector(14 DOWNTO 0) := "000000001010000";--80, 81 words
constant bias_len   : std_logic_vector(14 DOWNTO 0) := "000000000010001";--17, 18 words
constant data_len   : std_logic_vector(14 DOWNTO 0) := "000000101100111";--359, 360 WORDS
constant dw_out_len : std_logic_vector(14 downto 0) := "000000010100001";--161, 162 output channels.

begin 

--Main clock, 30 ns.
process
begin 
  clk_p_i <= '1';
  wait for 7.5 ns;
  clk_p_i <= '0';
  wait for 7.5 ns;
end process;

--clk_e
process
begin
  clk_e_i <= '1';
  wait for 15 ns;
  clk_e_i <= '0';
  wait for 15 ns;
end process;
clk_e_neg_i <= not clk_e_i;


--TEST
process

procedure sendNOCcommand (constant word : in std_logic_vector(5 downto 0))is
begin 
  tag_in <= word(5);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(4);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(3);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(2);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(1);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(0);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= '0';
  wait until rising_edge(clk_e_i);
wait for 5ns; --one more cycle for transfering from collecting buffer to noc_command register
end sendNOCcommand;

procedure send15bits (constant word : in std_logic_vector(14 downto 0)) is
begin
  tag_in <= word(14);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(13);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(12);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(11);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(10);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(9);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(8);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(7);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(6);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(5);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(4);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(3);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(2);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(1);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  tag_in <= word(0);
  wait until rising_edge(clk_e_i);
wait for 5ns;
end send15bits;

procedure sendmemword (constant word : in mem_word)is
begin
  data <= word(15);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(14);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(13);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(12);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(11);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(10);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(9);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(8);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(7);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(6);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(5);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(4);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(3);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(2);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(1);
  wait until rising_edge(clk_e_i);
wait for 5ns;
  data <= word(0);
  wait until rising_edge(clk_e_i);
wait for 5ns;
end sendmemword;

procedure readmemword (signal outword : out out_word) is
begin
  for i in 0 to 2591 loop
  outword(i) <= data_out;
  wait until rising_edge(clk_e_i);
wait for 5ns;
  end loop;
end readmemword;

procedure sendpedata (constant word: in std_logic_vector(31 downto 0)) is
begin
--req_in <= '1';
wait until rd_fifo = '1';
wait for 15 ns;
fifo_vld <= '1';
req_fifo <= word;
wait until rising_edge(clk_e_i);
wait for 5ns;
fifo_vld<= '0';
end sendpedata;

    
begin

tag_in <= '0';
--wait for 150 ns;
wait until rising_edge(clk_e_i);
wait for 5ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
sendNOCcommand(RESET);
--wait for 150 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
--sendNOCcommand(RESET);
--wait until tag_out= '0';--RESET DONE
--input
sendNOCcommand(WRITEC);
send15bits(data_len);
send15bits(data_sa);--0x400
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=31;
for i in 0 to 359 loop
  sendmemword(conv_to_memword(data_dw(i)));
end loop;
progress <=7;
wait until tag_fb = '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
--kernel
sendNOCcommand(WRITEC);
send15bits(kernels_len);
send15bits(kernels_sa);--0x100
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=215;
for i in 0 to 80 loop
  sendmemword(conv_to_memword(kernel_dw(i)));
end loop;
progress <=8;
wait until tag_fb = '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
sendNOCcommand(WRITEC);
send15bits(bias_len);
send15bits(bias_sa);--200
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=17;
for i in 0 to 17 loop
  sendmemword(conv_to_memword(bias_dw(i)));
end loop;
progress <=9;
wait until tag_fb = '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;

sendNOCcommand(WRITEC);
send15bits(ucode_len);--255
send15bits(ucode_sa);--0
tag_in <= '0';
--wait for 120 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=41;
for i in 0 to 255 loop
sendmemword(conv_to_memword(ucode_dw(i)));
end loop;
data <= (others => '0');
progress <=5;
wait until tag_fb = '0'; 

--wait for 120 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
sendNOCcommand(Exe);
tag_in <= '0';
progress <= 8;


--Start testing on PE side(simulated data input)
wait for 220000 ns;
--wait until rising_edge(C_RDY);
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
sendNOCcommand(READ);
send15bits(dw_out_len);
send15bits(dw_out_a);
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <= 2303; 
  readmemword(outword);
  for i in 0 to 161 loop
    out_ram(i) <= outword(16*i) & outword(16*i+1) & outword(16*i+2) & outword(16*i+3) & 
                  outword(16*i+4) & outword(16*i+5) & outword(16*i+6) & outword(16*i+7) &
                  outword(16*i+8) & outword(16*i+9) & outword(16*i+10) & outword(16*i+11) &
                  outword(16*i+12) & outword(16*i+13) & outword(16*i+14) & outword(16*i+15);
  end loop;

  progress <=5;
  wait until tag_fb = '0';



wait;

end process;
CLK_P<= clk_p_i;
CLK_E <= clk_e_i;
TAG<=tag_in;
tag_out <= TAG_FB; 

end Behavioral;
