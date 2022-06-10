library ieee;
use ieee.std_logic_1164.all;

package pad_instance_package is

  type direction_t is (vertical, horizontal);

  component RIIO_BOND64_OUTER_SIG
    port (
      PAD : inout std_logic);
  end component;

  component RIIO_EG1D80V_GPO_RVT28_H
    port (
      -- PAD
      PAD_B : inout std_logic;

      --GPO
      DO_I  : in std_logic;
      DS_I  : in std_logic_vector(3 downto 0);
      SR_I  : in std_logic;
      CO_I  : in std_logic;
      OE_I  : in std_logic;
      ODP_I : in std_logic;
      ODN_I : in std_logic;

      VBIAS : inout std_logic
      );
  end component;

  component RIIO_EG1D80V_GPO_RVT28_V
    port (
      -- PAD
      PAD_B : inout std_logic;

      --GPO
      DO_I  : in std_logic;
      DS_I  : in std_logic_vector(3 downto 0);
      SR_I  : in std_logic;
      CO_I  : in std_logic;
      OE_I  : in std_logic;
      ODP_I : in std_logic;
      ODN_I : in std_logic;

      VBIAS : inout std_logic
      );
  end component;

  component RIIO_EG1D80V_GPI_RVT28_V
    port (
      -- PAD
      PAD_B : inout std_logic;
      --GPI
      IE_I  : in    std_logic;
      STE_I : in    std_logic_vector(1 downto 0);
      PD_I  : in    std_logic;
      PU_I  : in    std_logic;
      DI_O  : out   std_logic_vector(1 downto 0)
      );
  end component;

  component RIIO_EG1D80V_GPI_RVT28_H
    port (
      -- PAD
      PAD_B : inout std_logic;
      --GPI
      IE_I  : in    std_logic;
      STE_I : in    std_logic_vector(1 downto 0);
      PD_I  : in    std_logic;
      PU_I  : in    std_logic;
      DI_O  : out   std_logic_vector(1 downto 0)
      );
  end component;
  
  component RIIO_EG1D80V_GPIO_RVT28_V
    port (
      -- PAD
      PAD_B : inout std_logic;
      --GPIO
      DO_I  : in    std_logic;
      DS_I  : in    std_logic_vector(3 downto 0);
      SR_I  : in    std_logic;
      CO_I  : in    std_logic;
      OE_I  : in    std_logic;
      ODP_I : in    std_logic;
      ODN_I : in    std_logic;
      IE_I  : in    std_logic;
      STE_I : in    std_logic_vector(1 downto 0);
      PD_I  : in    std_logic;
      PU_I  : in    std_logic;
      DI_O  : out   std_logic_vector(1 downto 0);

      VBIAS : inout std_logic
      );
  end component;

  component RIIO_EG1D80V_GPIO_RVT28_H
    port (
      -- PAD
      PAD_B : inout std_logic;
      --GPIO
      DO_I  : in    std_logic;
      DS_I  : in    std_logic_vector(3 downto 0);
      SR_I  : in    std_logic;
      CO_I  : in    std_logic;
      OE_I  : in    std_logic;
      ODP_I : in    std_logic;
      ODN_I : in    std_logic;
      IE_I  : in    std_logic;
      STE_I : in    std_logic_vector(1 downto 0);
      PD_I  : in    std_logic;
      PU_I  : in    std_logic;
      DI_O  : out   std_logic_vector(1 downto 0);

      VBIAS : inout std_logic
      );
  end component;
  
end package pad_instance_package;
