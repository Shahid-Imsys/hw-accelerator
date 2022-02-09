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
    type mem_word is array (15 downto 0) of std_logic_vector(7 downto 0);
   	type ram_type is array (255 downto 0) of std_logic_vector(127 downto 0);
    type ram_type_vc is array (286 downto 0) of std_logic_vector(127 downto 0);
    type ram_type_vd is array (214 downto 0) of std_logic_vector(127 downto 0);
    type ram_type_uc is array (7 downto 0) of std_logic_vector(127 downto 0);
	  type ram_type_b is array (255 downto 0) of bit_vector(127 downto 0);
    type ram_type_c is array (286 downto 0) of bit_vector(127 downto 0);
    type ram_type_d is array (214 downto 0) of bit_vector(127 downto 0);
    type ram_type_e is array (7 downto 0) of bit_vector(127 downto 0);
		impure function init_ram_from_file (ram_file_name : in string) return ram_type is
		FILE ram_file : text is in ram_file_name;
		variable ram_file_line : line;
		variable RAM_B : ram_type_b;
		variable RAM :ram_type;
		begin
			--while not endfile(ram_file) loop
			for i in 0 to 255 loop
				readline(ram_file, ram_file_line);
				read(ram_file_line, RAM_B(i));
				RAM(i) := to_stdlogicvector(RAM_B(i));
			end loop;
		return RAM;
	    end function;

      impure function init_input_from_file (ram_file_name : in string) return ram_type_vc is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : ram_type_c;
        variable RAM :ram_type_vc;
        begin
          --while not endfile(ram_file) loop
          for i in 0 to 286 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
      end function;

      impure function init_kernel_from_file (ram_file_name : in string) return ram_type_vd is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : ram_type_d;
        variable RAM :ram_type_vd;
        begin
          --while not endfile(ram_file) loop
          for i in 0 to 214 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
      end function;

      impure function init_unicast_from_file (ram_file_name : in string) return ram_type_uc is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : ram_type_e;
        variable RAM :ram_type_uc;
        begin
          --while not endfile(ram_file) loop
          for i in 0 to 7 loop
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
--component cluster_controller
--     port(
----Clock inputs
--	  CLK_P            : out std_logic;     --PE clocks
--	  CLK_E            : out std_logic;     --PE's execution clock 
--	  CLK_E_NEG        : out std_logic;     --Inverted clk_e
----Clock outputs
--	  CLK_O            : in std_logic;
----Tag line
--	  TAG              : out std_logic;
--	  TAG_FB           : in std_logic;
----Data line   
--	  DATA             : out std_logic_vector(7 downto 0);
--	  DATA_OUT         : in std_logic_vector(7 downto 0);
----PE request
--    RST_R            : out std_logic;  --Active low
--	  REQ_IN           : in std_logic;  --req to noc in reg logic
--	  REQ_FIFO          : in std_logic_vector(31 downto 0);
--	  DATA_TO_PE       : out std_logic_vector(127 downto 0);
--	  DATA_VLD         : out std_logic;
--	  PE_UNIT          : out std_logic_vector(5 downto 0);
--	  BC              : out std_logic;
--	  RD_FIFO          : out std_logic;
--	  FIFO_VLD         : in std_logic
----Feedback signals
--      --fb               : out std_logic
--	  ); 
--end component;
signal ucode : ram_type := init_ram_from_file("SequenceTest_F_Core2en.data");--("SequenceTest_F.data");
--signal ucode_ve : ram_type := init_ram_from_file("program_0x000_o.ascii");
--signal ucode_uc : ram_type := init_ram_from_file("unicast_plus_core_2_BE_F.data");--("unicast_BE_F.data");
signal input_0 : ram_type_vc := init_input_from_file("input_0x400.ascii");
signal kernel_0 : ram_type_vd := init_kernel_from_file("kernel_0x100.ascii");
signal unicast_data : ram_type_uc := init_unicast_from_file("unicastdata.ascii");
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
--Progress
signal progress : integer;
--Constants
constant RESET : std_logic_vector(5 downto 0) :="101111";
constant WRITEC : std_logic_vector(5 downto 0) :="100011"; --Write data contineous
constant READ  :  std_logic_vector(5 downto 0) :="100100"; --Read data
constant EXE   : std_logic_vector(5 downto 0) :="100110";
constant RESUME : std_logic_vector(5 downto 0) :="101000";
constant ADDRESS1 : std_logic_vector(14 downto 0) := "000000000000011"; --3
constant ADDRESS2 : std_logic_vector(14 downto 0) := "000000000000100"; --4
constant ADDRESS3 : std_logic_vector(14 downto 0) := (others => '0');
constant ADDRESS4 : std_logic_vector(14 downto 0) := "000000100000000";
constant ADDRESS5 : std_logic_vector(14 downto 0) := "000001000011111";
constant ADDRESS6 : STD_LOGIC_VECTOR(14 DOWNTO 0) := "000010000000000"; --ADDR HEX 400, UNICAST DATA START ADDR
constant LENGTH1 : std_logic_vector(14 downto 0) := "000000000000011";  --3 --write 4 words
constant LENGTH2 : std_logic_vector(14 downto 0) := "000000000000010";  --2 --read 3 words
constant LENGTH3 : std_logic_vector(14 downto 0) := "000000011111111";--255
CONSTANT LENGTH4 : STD_LOGIC_VECTOR(14 DOWNTO 0) := "000000100011110";--286--INPUT
CONSTANT LENGTH5 : STD_LOGIC_VECTOR(14 DOWNTO 0) := "000000011010110";--214--KERNEL
constant LENGTH6 : STD_LOGIC_VECTOR(14 DOWNTO 0) := "000000000000111";--7 ---8 WORDS
constant WORD1   : mem_word := (15 =>"11111111", 14 => x"fe", 13 => x"fd", 12 => x"fc", 11 => x"fb", 10 => x"fa", 0=> x"f0",others =>(others=>'0'));
constant WORD2   : mem_word := (15 =>"11111111", 12=> "00001000", others =>(others=>'0'));
constant WORD3   : mem_word := (15 =>"11111111", 14 => "00001111", 11=> "00001001", others =>(others=>'0'));
constant WORD4   : mem_word := (others =>(others=>'1'));
--PE side
constant RD_REQ1 : std_logic_vector(31 downto 0) :="01000010000000100000000000000011"; --Broadcast request, start from address 3, 2 words, 3 Pe issues this request
constant WR_REQ1 : std_logic_vector(31 downto 0) :="11000100000000010000000000001111"; --Write request,starts from address 15
constant PE_WAIT : std_logic_vector(31 downto 0) :=(others => '0');
constant DATA1   : std_logic_vector(31 downto 0) :=(others => '1');
constant DATA2   : std_logic_vector(31 downto 0) :=(1 =>'1',others => '0');
constant DATA3   : std_logic_vector(31 downto 0) :=(2 => '1',others => '0');
constant DATA4   : std_logic_vector(31 downto 0) :=(31=> '1', 30=> '1', others => '0');
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
sendNOCcommand(WRITEC);
progress <= 1;
send15bits(LENGTH1); --3
send15bits(ADDRESS1);--3
tag_in<= '0';
progress <=2;
--wait for 120 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
sendmemword(WORD1);
sendmemword(WORD2);
sendmemword(WORD3);
sendmemword(WORD4);
data <= (others => '0');
progress <=3;
--sendNOCcommand(RESET);
--wait for 300ns;
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
send15bits(LENGTH2);
send15bits(ADDRESS2);
tag_in <= '0';
progress <= 4;
--Transfer the complete microcode program
wait until tag_fb = '0';
--wait for 120ns; --Added a delay here, to be researched in later
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
--sendNOCcommand(RESET);
--wait for 300 ns;
--input
sendNOCcommand(WRITEC);
send15bits(LENGTH4);
send15bits(ADDRESS4);
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=8;
for i in 0 to 286 loop
  sendmemword(conv_to_memword(input_0(i)));
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
send15bits(LENGTH5);
send15bits(ADDRESS5);
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=9;
for i in 0 to 214 loop
  sendmemword(conv_to_memword(kernel_0(i)));
end loop;
progress <=11;
wait until tag_fb = '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
--unicast data
sendNOCcommand(WRITEC);
send15bits(LENGTH6);
send15bits(ADDRESS6);
tag_in <= '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
progress <=10;
for i in 0 to 7 loop
  sendmemword(conv_to_memword(unicast_data(i)));
end loop;
progress <=13;
wait until tag_fb = '0';
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
wait until rising_edge(clk_e_i);
wait for 5 ns;
--
sendNOCcommand(WRITEC);
send15bits(LENGTH3);--255
send15bits(ADDRESS3);--0
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
sendmemword(conv_to_memword(ucode(i)));
--sendmemword(conv_to_memword(ucode_ve(i)));
--sendmemword(conv_to_memword(ucode_uc(i)));
end loop;
data <= (others => '0');
progress <=5;
wait until tag_fb = '0'; 
--sendNOCcommand(WRITEC); --send input data
--send15bits(LENGTH4);
--send15bits(ADDRESS4_DATA);
--tag_in <= '0';
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--for i in 0 to 31 loop
--  sendmemword(conv_to_memword(input_data(i))); --send ve pointwise test microcode
--end loop;
--data <= (others => '0');
--progress <=6;
--wait until tag_fb = '0'; 
--sendNOCcommand(WRITEC); --send input data
--send15bits(LENGTH5);
--send15bits(ADDRESS5_KERNEL);
--tag_in <= '0';
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--wait until rising_edge(clk_e_i);
--wait for 5 ns;
--for i in 0 to 215 loop
--  sendmemword(conv_to_memword(input_kernel(i))); --send ve pointwise test microcode
--end loop;
--data <= (others => '0');
--progress <=7;
--wait until tag_fb = '0'; 

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
--wait for 13000 ns;
wait until rising_edge(C_RDY);

sendNOCcommand(Exe);
tag_in <= '0';
progress <= 6;

wait for 300 ns;

--req_in <= '1';
--sendpedata(RD_REQ1);
--sendpedata(RD_REQ1);
--sendpedata(RD_REQ1);
--sendpedata(WR_REQ1);
--sendpedata(DATA1);
--fifo_vld<='1';
--req_fifo<= DATA2;
--wait until rising_edge(clk_e_i);
--req_fifo <= DATA3;
--wait until rising_edge(clk_e_i);
--req_fifo<= DATA4;
--wait until rising_edge(clk_e_i);
--fifo_vld <= '0';
--sendpedata(WR_REQ1);
--sendpedata(DATA2);
--fifo_vld<='1';
--req_fifo<= DATA4;
--wait until rising_edge(clk_e_i);
--req_fifo <= DATA3;
--wait until rising_edge(clk_e_i);
--req_fifo<= DATA1;
--wait until rising_edge(clk_e_i);
--fifo_vld <= '0';
--sendpedata(PE_WAIT);



wait;

end process;
CLK_P<= clk_p_i;
CLK_E <= clk_e_i;
--CLK_E_NEG <= clk_e_neg_i;
TAG<=tag_in;
tag_out <= TAG_FB; 
--cc: cluster_controller
--port map(
--CLK_P => clk_p,
--clk_e => clk_e,
--clk_e_neg => clk_e_neg,
--TAG   => tag_in,
--TAG_FB => tag_out,
--DATA  => data,
--DATA_OUT => data_out,
--CLK_O => clk_o,  
--);

end Behavioral;
