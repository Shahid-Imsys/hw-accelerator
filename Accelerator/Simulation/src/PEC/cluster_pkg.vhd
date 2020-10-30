library IEEE;
use IEEE.std_logic_1164.all;
--use work.defines.all; --TBA

package cluster_pkg is
    type pe_req is array (63 downto 0) of std_logic_vector(25 downto 0); --To be replaced within defines
    type pe_data is array (63 downto 0) of std_logic_vector(127 downto 0);
end package cluster_pkg;
 
