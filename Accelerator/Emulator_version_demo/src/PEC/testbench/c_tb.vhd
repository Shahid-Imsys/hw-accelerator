----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2021 10:47:36 AM
-- Design Name: 
-- Module Name: c_tb - Behavioral
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

entity c_tb is
--  Port ( );
end c_tb;

architecture Behavioral of c_tb is
component PEC_top
  Port ( 
	  CLK_P : in std_logic;
	  CLK_E  : in std_logic;
      --RST_P  : in std_logic;
      RST_E  : in std_logic;
	  clk_O  : out std_logic;
	  TAG    : in std_logic;
	  TAG_FB : out std_logic;
      C_RDY  : out std_logic;
      DATA   : in std_logic_vector(7 downto 0);
      DATA_OUT  : out std_logic_vector(7 downto 0)
  );
 end component;
 component cluster_sim
 Port (
CLK_P            : out std_logic;     --PE clocks
CLK_E            : out std_logic;     --PE's execution clock 
--CLK_E_NEG        : out std_logic;     --Inverted clk_e
RST_E            : out std_logic;
CLK_O            : in std_logic;

TAG              : out std_logic;
TAG_FB           : in std_logic;

c_rdy            : in std_logic;  
DATA             : out std_logic_vector(7 downto 0);
DATA_OUT         : in std_logic_vector(7 downto 0)
 );
 end component;
 
 signal clk_p_i : std_logic;
 signal clk_e_i : std_logic;
 signal rst_e_i : std_logic;
 signal clk_o_i : std_logic;
 signal tag_i   : std_logic;
 signal tag_fb_i : std_logic;
 signal c_rdy_i : std_logic;
 signal data_i : std_logic_vector(7 downto 0);
 signal data_out_i : std_logic_vector( 7 downto 0);
 
begin
cluster: PEC_top
port map(
clk_p => clk_p_i,
clk_e => clk_e_i,
--rst_p => '0',
rst_e => rst_e_i,
clk_o => clk_o_i,
tag => tag_i,
tag_fb => tag_fb_i,
c_rdy => c_rdy_i,
data => data_i,
data_out => data_out_i);

tb: cluster_sim
port map(
clk_p => clk_p_i,
clk_e => clk_e_i,
rst_e => rst_e_i,
clk_o => clk_o_i,
tag => tag_i,
tag_fb => tag_fb_i,
c_rdy => c_rdy_i,
data => data_i,
data_out => data_out_i);


end Behavioral;
