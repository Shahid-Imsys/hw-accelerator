library ieee;
use ieee.std_logic_1164.all;

use work.ACC_types.all;

package noc_types_pkg is

  constant levels_c : integer := 1;

  type noc_data_t is array (natural range <>) of byte;

end package noc_types_pkg;
