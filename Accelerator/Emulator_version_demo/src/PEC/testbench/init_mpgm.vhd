----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2021 02:14:17 PM
-- Design Name: 
-- Module Name: init_mpgm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity init_mpgm is
  Port (
  HCLK       : out std_logic;
  EVEN_C     : out std_logic;
  exe        : out std_logic;
  RESUME     : out std_logic;
  MTEST      : out std_logic;
  MRESET     : out std_logic;
  MCKOUT0    : in std_logic;
  MWAKEUP_LP : out std_logic;
  MLP_PWR_OK : out std_logic;
  ----------------------------
  c1_in_data : out std_logic_vector(127 downto 0);
  c1_ddi_vld : out std_logic
   );
end init_mpgm;

architecture Behavioral of init_mpgm is
   	type ram_type is array (255 downto 0) of std_logic_vector(127 downto 0);
	type ram_type_b is array (255 downto 0) of bit_vector(127 downto 0);
		impure function init_ram_from_file (ram_file_name : in string) return ram_type is
		FILE ram_file : text is in ram_file_name;
		variable ram_file_line : line;
		variable RAM_B : ram_type_b;
		variable RAM :ram_type;
		begin
			--for i in rom_type'range loop
			for i in 0 to 255 loop
				readline(ram_file, ram_file_line);
				read(ram_file_line, RAM_B(i));
				RAM(i) := to_stdlogicvector(RAM_B(i));
			end loop;
		return RAM;
	    end function;
   
   
   
   
   signal RAM : ram_type := init_ram_from_file("SequenceTest_F.data");
   signal hclk_i : std_logic;
   signal even_c_i : std_logic:='1';
   signal exe_i : std_logic;
   signal resume_i : std_logic;
   signal c1_input: std_logic_vector(127 downto 0);
   signal c1_data_vld : std_logic;
   signal even_c_1 : std_logic;
   signal even_c_2 : std_logic;
   
   
begin
  process
   
   procedure sendmc (signal word: in std_logic_vector(127 downto 0))is
   begin
   wait until rising_edge(hclk_i) and even_c_i = '0'; --rising_edge of clk_e
   --if rising_edge(hclk_i) and even_c_i = '1' then
   c1_input <= word;
   c1_data_vld <= '1';
   --end if;
   --wait until rising_edge(hclk_i) and even_c_i = '1';
   end procedure;
   
  begin
  --wait for 30 ns;
  MLP_PWR_OK <= '0';
  wait for 60 ns;
  MLP_PWR_OK <= '1';
  MWAKEUP_LP <= '0';
  wait for 6000 ns;
  MLP_PWR_OK <= '0';
  wait for 60 ns;
  MLP_PWR_OK <= '1';
  wait for 3000 ns; --wait until 
  exe_i<= '1';
  wait for 60 ns;
  exe_i<= '0';
  wait for 600 ns;
  for i in 0 to 255 loop
  --if rising_edge(hclk_i) and even_c_i = '1' then
  sendmc(RAM(i));
  end loop;
  wait for 60 ns;
  c1_input <= (others => '0');
  wait for 60 ns;
  c1_data_vld <= '0'; 
  wait for 1000ns;
  wait;
  end process;
  
  process
  begin
  wait for 60 ns;
  --MSDIN <= '1';
  MTEST <= '1';	
  MRESET <= '1';
  wait until rising_edge(MCKOUT0);
  MTEST <= '0';
  
  wait;
  --wait until rising_edge(MCKOUT0);
  --MTEST <= '0';	
  end process;
  
  
   process
   begin
   hclk_i <= '1';
   wait for 15 ns;
   hclk_i <= '0';
   wait for 15 ns;
   end process;
   
   process(hclk_i)
   begin
   if rising_edge(hclk_i) then
       even_c_i <= not even_c_i;
   end if;
   --wait for 30 ns;
   --even_c_i <= '0';
   --wait for 30 ns;
   end process;
   
even_c_1 <= even_c_i;
even_c_2 <= even_c_1;
   

HCLK <= hclk_i;
EVEN_C <= even_c_2;
EXE <= exe_i;
RESUME <= resume_i;
c1_in_data <= c1_input;
c1_ddi_vld <= c1_data_vld;
end Behavioral;
