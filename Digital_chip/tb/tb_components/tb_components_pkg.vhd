
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.digital_top_sim_pack.all;


package tb_components_pkg is

  component debug_interface_bfm is
    port(

      MSDIN   : out std_logic := '0';
      MSDOUT  : in  std_logic;
      MIRQOUT : in  std_logic;
      MCKOUT0 : in  std_logic;

      reg_to_block   : in  reg_to_block_t;
      reg_from_block : out reg_from_block_t
      );
  end component debug_interface_bfm;

  component uart is
    port (
      tx             : out std_ulogic;
      rx             : in  std_ulogic;
      reg_to_block   : out reg_to_block_t;
      reg_from_block : in  reg_from_block_t
      );
  end component uart;

end package tb_components_pkg;
