library ieee;
use ieee.std_logic_1164.all;

use work.pad_instance_package.all;

entity output_pad is
  
  generic (
    direction : direction_t);

  port (
    pad : inout std_logic;
    do  : in std_logic;
    ds  : in std_logic_vector(3 downto 0);
    sr  : in std_logic;
    co  : in std_logic;
    oe  : in std_logic;
    odp : in std_logic;
    odn : in std_logic
    );
end entity output_pad;

architecture str of output_pad is

begin  -- architecture str

  
  vertical_g : if direction = vertical generate
    i_v_pad : RIIO_EG1D80V_GPO_RVT28_V
      port map (
        -- PAD
        PAD_B => pad,
        --GPIO
        DO_I  => do,
        DS_I  => ds,
        SR_I  => sr,
        CO_I  => co,
        OE_I  => oe,
        ODP_I => odp,
        ODN_I => odn,

        VBIAS => open
        );

  elsif direction = horizontal generate
    i_h_pad : RIIO_EG1D80V_GPO_RVT28_H
      port map (
        -- PAD
        PAD_B => pad,
        --GPIO
        DO_I  => do,
        DS_I  => ds,
        SR_I  => sr,
        CO_I  => co,
        OE_I  => oe,
        ODP_I => odp,
        ODN_I => odn,

        VBIAS => open
        );
    end generate vertical_g;
    
  i_bond_pad : RIIO_BOND64_OUTER_SIG
     port map (PAD => pad);

end architecture str;
