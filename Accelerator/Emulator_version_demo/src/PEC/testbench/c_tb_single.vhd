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
use IEEE.NUMERIC_STD.all;
use std.env.all;

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
  generic ( USE_ASIC_MEMORIES : boolean := false );
  Port ( 
	  CLK_P : in std_logic;
	  CLK_E  : in std_logic;
    RST_E  : in std_logic;
	  DDO_VLD  : out std_logic;
	  TAG    : in std_logic;
	  TAG_FB : out std_logic;
    C_RDY  : out std_logic;
    DATA   : in std_logic_vector(7 downto 0);
    DATA_OUT  : out std_logic_vector(7 downto 0)
  );
 end component;
 component cluster_sim
 Port (
    CLK_P            : in std_logic;     --PE clocks
    CLK_E            : in std_logic;     --PE's execution clock 
    RST_E            : out std_logic;
    DDO_VLD            : in std_logic;
    TAG              : out std_logic;
    TAG_FB           : in std_logic;
    c_rdy            : in std_logic; 
    TEST_DONE        : out std_logic; 
    DATA             : out std_logic_vector(7 downto 0);
    DATA_OUT         : in std_logic_vector(7 downto 0)
 );
 end component;

 signal clk_p : std_logic;
 signal clk_e : std_logic;
  --signals for PEC1
 signal rst_e_1 : std_logic;
 signal ddo_vld_1 : std_logic;
 signal tag_1   : std_logic;
 signal tag_fb_1 : std_logic;
 signal c_rdy_1 : std_logic;
 signal data_1 : std_logic_vector(7 downto 0);
 signal data_out_1 : std_logic_vector( 7 downto 0);
 signal test_done_1: std_logic;
 
begin

  process
  begin 
    clk_p <= '1';
    wait for 7.5 ns;
    clk_p <= '0';
    wait for 7.5 ns;
  end process;

  process
  begin
    clk_e <= '1';
    wait for 15 ns;
    clk_e <= '0';
    wait for 15 ns;
  end process;

  process
  begin
    wait until test_done_1 = '1';
    report "simulation end";
    finish;
  end process;

cluster_1: PEC_top
generic map(
  USE_ASIC_MEMORIES => false )
port map(
clk_p => clk_p,
clk_e => clk_e,
rst_e => rst_e_1,
ddo_vld => ddo_vld_1,
tag => tag_1,
tag_fb => tag_fb_1,
c_rdy => c_rdy_1,
data => data_1,
data_out => data_out_1);

tb_1: cluster_sim
port map(
clk_p => clk_p,
clk_e => clk_e,
rst_e => rst_e_1,
ddo_vld => ddo_vld_1,
tag => tag_1,
tag_fb => tag_fb_1,
c_rdy => c_rdy_1,
test_done => test_done_1,
data => data_1,
data_out => data_out_1);

end Behavioral;
