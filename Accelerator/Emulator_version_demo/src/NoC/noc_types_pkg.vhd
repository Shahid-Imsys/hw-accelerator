library ieee;
use ieee.std_logic_1164.all;

use work.ACC_types.all;

package noc_types_pkg is

  constant levels_c : integer := 1;
  constant levels_10_c : integer := 3;

  type noc_data_t is array (natural range <>) of byte;
  type noc_tag_t is array (natural range <>) of std_logic_vector(1 downto 0);

end package noc_types_pkg;
