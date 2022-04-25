library ieee;
use ieee.std_logic_1164.all;

use work.pad_instance_package.all;


entity input_pad is

  generic (
    direction : direction_t);

  port (
    pad : inout  std_logic;
    ie  : in  std_logic;
    ste : in  std_logic_vector(1 downto 0);
    pd  : in  std_logic;
    pu  : in  std_logic;
    di  : out std_logic
    );
end entity input_pad;

architecture str of input_pad is

  signal di_vect : std_logic_vector(1 downto 0);
  
begin  -- architecture str

  verical : if direction = vertical generate
    i_v_pad : RIIO_EG1D80V_GPI_LVT28_V
      port map (
        -- PAD
        PAD_B => pad,
        --GPI
        IE_I  => ie,
        STE_I => ste,
        PD_I  => pd,
        PU_I  => pu,
        DI_O  => di_vect
        );

  elsif direction = horizontal generate
    i_h_pad : RIIO_EG1D80V_GPI_LVT28_H
      port map (
        -- PAD
        PAD_B => pad,
        --GPI
        IE_I  => ie,
        STE_I => ste,
        PD_I  => pd,
        PU_I  => pu,
        DI_O  => di_vect
        );

  end generate verical;

  di <= di_vect(0);
  
  -- i_bond_pad : RIIO_BOND64_OUTER_SIG
  --   port map (PAD => pad);

end architecture str;
