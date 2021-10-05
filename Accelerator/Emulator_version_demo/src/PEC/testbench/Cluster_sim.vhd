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
type mem_word is array (15 downto 0) of std_logic_vector (7 downto 0);
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
--Progress
signal progress : integer;
--Constants
constant RESET : std_logic_vector(5 downto 0) :="101111";
constant WRITEC : std_logic_vector(5 downto 0) :="100011"; --Write data contineous
constant READ  :  std_logic_vector(5 downto 0) :="100100"; --Read data
constant EXE   : std_logic_vector(5 downto 0) :="100110";
constant RESUME : std_logic_vector(5 downto 0) :="101000";
constant ADDRESS1 : std_logic_vector(14 downto 0) := "000000000000011";
constant ADDRESS2 : std_logic_vector(14 downto 0) := "000000000000100";
constant LENGTH1 : std_logic_vector(14 downto 0) := "000000000000011";
constant LENGTH2 : std_logic_vector(14 downto 0) := "000000000001100";
constant WORD1   : mem_word := (15 =>"11111111", others =>(others=>'0'));
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
  wait for 30 ns;
  tag_in <= word(4);
  wait for 30 ns;
  tag_in <= word(3);
  wait for 30 ns;
  tag_in <= word(2);
  wait for 30 ns;
  tag_in <= word(1);
  wait for 30 ns;
  tag_in <= word(0);
  wait for 30 ns;
  tag_in <= '0';
  wait for 30ns; --one more cycle for transfering from collecting buffer to noc_command register
end sendNOCcommand;

procedure send15bits (constant word : in std_logic_vector(14 downto 0)) is
begin
  tag_in <= word(14);
  wait for 30 ns;
  tag_in <= word(13);
  wait for 30 ns;
  tag_in <= word(12);
  wait for 30 ns;
  tag_in <= word(11);
  wait for 30 ns;
  tag_in <= word(10);
  wait for 30 ns;
  tag_in <= word(9);
  wait for 30 ns;
  tag_in <= word(8);
  wait for 30 ns;
  tag_in <= word(7);
  wait for 30 ns;
  tag_in <= word(6);
  wait for 30 ns;
  tag_in <= word(5);
  wait for 30 ns;
  tag_in <= word(4);
  wait for 30 ns;
  tag_in <= word(3);
  wait for 30 ns;
  tag_in <= word(2);
  wait for 30 ns;
  tag_in <= word(1);
  wait for 30 ns;
  tag_in <= word(0);
  wait for 30 ns;
end send15bits;

procedure sendmemword (constant word : in mem_word)is
begin
  wait for 120 ns;
  data <= word(15);
  wait for 30 ns;
  data <= word(14);
  wait for 30 ns;
  data <= word(13);
  wait for 30 ns;
  data <= word(12);
  wait for 30 ns;
  data <= word(11);
  wait for 30 ns;
  data <= word(10);
  wait for 30 ns;
  data <= word(9);
  wait for 30 ns;
  data <= word(8);
  wait for 30 ns;
  data <= word(7);
  wait for 30 ns;
  data <= word(6);
  wait for 30 ns;
  data <= word(5);
  wait for 30 ns;
  data <= word(4);
  wait for 30 ns;
  data <= word(3);
  wait for 30 ns;
  data <= word(2);
  wait for 30 ns;
  data <= word(1);
  wait for 30 ns;
  data <= word(0);
  wait for 30 ns;
end sendmemword;

procedure sendpedata (constant word: in std_logic_vector(31 downto 0)) is
begin
--req_in <= '1';
wait until rd_fifo = '1';
wait for 15 ns;
fifo_vld <= '1';
req_fifo <= word;
wait for 30 ns;
fifo_vld<= '0';
end sendpedata;

    
begin

tag_in <= '0';
wait for 300 ns;
sendNOCcommand(RESET);
wait for 300 ns;
--sendNOCcommand(RESET);
--wait until tag_out= '0';--RESET DONE
sendNOCcommand(WRITEC);
progress <= 1;
send15bits(LENGTH1);
send15bits(ADDRESS1);
tag_in<= '0';
progress <=2;
sendmemword(WORD1);
sendmemword(WORD2);
sendmemword(WORD3);
sendmemword(WORD4);
data <= (others => '0');
progress <=3;
--sendNOCcommand(RESET);
wait for 300ns;
sendNOCcommand(READ);
send15bits(LENGTH2);
send15bits(ADDRESS2);
tag_in <= '0';
progress <= 4;
--Start testing on PE side(simulated data input)
wait for 300 ns;
req_in <= '1';
sendpedata(RD_REQ1);
sendpedata(RD_REQ1);
sendpedata(RD_REQ1);
sendpedata(WR_REQ1);
sendpedata(DATA1);
fifo_vld<='1';
req_fifo<= DATA2;
wait for 30 ns;
req_fifo <= DATA3;
wait for 30 ns;
req_fifo<= DATA4;
wait for 30 ns;
fifo_vld <= '0';
sendpedata(WR_REQ1);
sendpedata(DATA2);
fifo_vld<='1';
req_fifo<= DATA4;
wait for 30 ns;
req_fifo <= DATA3;
wait for 30 ns;
req_fifo<= DATA1;
wait for 30 ns;
fifo_vld <= '0';
sendpedata(PE_WAIT);



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
