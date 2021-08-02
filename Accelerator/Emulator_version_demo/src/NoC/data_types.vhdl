library ieee;
use ieee.std_logic_1164.all;


package data_types is

  type byte_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
  type cluster_array_t is array (3 downto 0) of byte_array_t(3 downto 0);

end package data_types;
