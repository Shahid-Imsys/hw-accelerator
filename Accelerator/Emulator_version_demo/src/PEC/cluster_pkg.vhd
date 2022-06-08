library IEEE;
use IEEE.std_logic_1164.all;
--use work.defines.all; --TBA

package cluster_pkg is
    type pe_req is array (15 downto 0) of std_logic_vector(159 downto 0); --To be replaced within defines
    type pe_data is array (15 downto 0) of std_logic_vector(127 downto 0);
    type ID_TYPE is array (63 downto 0) of std_logic_vector(5 downto 0);
    constant ID_NUM_0 : std_logic_vector(5 downto 0) := "000000";
    constant ID_NUM_1 : std_logic_vector(5 downto 0) := "000001";
    constant ID_NUM_2 : std_logic_vector(5 downto 0) := "000010";
    constant ID_NUM_3 : std_logic_vector(5 downto 0) := "000011";
    constant ID_NUM_4 : std_logic_vector(5 downto 0) := "000100";
    constant ID_NUM_5 : std_logic_vector(5 downto 0) := "000101";
    constant ID_NUM_6 : std_logic_vector(5 downto 0) := "000110";
    constant ID_NUM_7 : std_logic_vector(5 downto 0) := "000111";
    constant ID_NUM_8 : std_logic_vector(5 downto 0) := "001000";
    constant ID_NUM_9 : std_logic_vector(5 downto 0) := "001001";
    constant ID_NUM_10 : std_logic_vector(5 downto 0) := "001010";
    constant ID_NUM_11 : std_logic_vector(5 downto 0) := "001011";
    constant ID_NUM_12 : std_logic_vector(5 downto 0) := "001100";
    constant ID_NUM_13 : std_logic_vector(5 downto 0) := "001101";
    constant ID_NUM_14 : std_logic_vector(5 downto 0) := "001110";
    constant ID_NUM_15 : std_logic_vector(5 downto 0) := "001111";

end package cluster_pkg;
 
