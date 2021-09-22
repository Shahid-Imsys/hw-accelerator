----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/05/2021 02:14:45 PM
-- Design Name: 
-- Module Name: Cluster_top - RTL
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
use work.cluster_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity c_clk_gen is
port(
--Clock inputs
	  PLL_IN            : in std_logic;     
	  --CLK_E            : in std_logic;
      EVEN_C           : out std_logic;
      CLK_E_POS        : out std_logic;
      CLK_E_NEG        : out std_logic;
      CLK_OUT         : out std_logic;
      