library ieee;
use ieee.std_logic_1164.all;

use work.pad_instance_package.all;

entity inoutput_pad is
  
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
    odn : in std_logic;
    ste : in  std_logic_vector(1 downto 0);
    pd  : in  std_logic;
    pu  : in  std_logic;
    di  : out std_logic
    );
end entity;

architecture str of inoutput_pad is

  signal di_vect : std_logic_vector(1 downto 0);
  
begin  -- architecture str

  
  vertical_g : if direction = vertical generate
    i_v_pad : RIIO_EG1D80V_GPIO_RVT28_V
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
        IE_I  => '1',
        STE_I => ste,
        PD_I  => pd,
        PU_I  => pu,
        DI_O  => di_vect,
        

        VBIAS => open
        );

  elsif direction = horizontal generate
    i_h_pad : RIIO_EG1D80V_GPIO_RVT28_H
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
        IE_I  => '1',
        STE_I => ste,
        PD_I  => pd,
        PU_I  => pu,
        DI_O  => di_vect,
        

        VBIAS => open
        );

  end generate vertical_g;

  di <= di_vect(0);
  
  i_bond_pad : RIIO_BOND64_OUTER_SIG
     port map (PAD => pad);

  end architecture;
