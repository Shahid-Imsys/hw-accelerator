--memory type for testing

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package memtypes is
  type load_save_t is (idle,load,save,savefinal);
end package;
