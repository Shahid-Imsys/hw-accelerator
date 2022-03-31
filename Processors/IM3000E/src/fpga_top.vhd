----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 10:24:00 AM
-- Design Name: 
-- Module Name: fpga_top - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.gp_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpga_top is
  port (
    MRESET  : in  std_logic;
    MIRQOUT : out std_logic;
    MCKOUT0 : out std_logic;
    MIRQ0   : in  std_logic;
    MSDIN   : in  std_logic;
    MSDOUT  : out std_logic;

    PA6_SCK  : inout std_logic;
    PA5_CS_N : inout std_logic;
    PA0_SIN  : inout std_logic;
    PA7_SOUT : inout std_logic;

    URX    : inout std_logic;
    UTX    : inout std_logic;
    OE_CTR : out   std_logic;

    ENET_MDC  : out   std_logic;
    ENET_MDIO : inout std_logic;

    ENET_RST_N : out std_logic;
    
    ENET_TXCLK : in  std_logic;
    ENET_TXCTL : out std_logic;
    ENET_TXD0  : out std_logic;
    ENET_TXD1  : out std_logic;
    ENET_TXD2  : out std_logic;
    ENET_TXD3  : out std_logic;

    ENET_RXCLK : in std_logic;
    ENET_RXCTL : in std_logic;
    ENET_RXD0  : in std_logic;
    ENET_RXD1  : in std_logic;
    ENET_RXD2  : in std_logic;
    ENET_RXD3  : in std_logic;

    -- OSPI interface
    OSPI_Out  : out   OSPI_InterfaceOut_t;
    OSPI_DQ   : inout std_logic_vector(7 downto 0);
    OSPI_RWDS : inout std_logic;

    TEST_OUTP : out std_logic_vector(15 downto 0);

    LED : out std_logic_vector (7 downto 0)
    );
end fpga_top;

architecture rtl of fpga_top is

  component clk_wiz_0
    port
      (
        clk_200M : out std_logic;
        clk_300M : out std_logic;
        clk_400M : out std_logic;
        clk_in   : in  std_logic
        );
  end component;

  component top is
    generic (
      g_memory_type : memory_type_t := referens
      );
    port (
      -- clocks and control signals
      HCLK    : in  std_logic;          -- clk input
      MRESET  : in  std_logic;  -- system reset               low active
      MIRQOUT : out std_logic;          -- interrupt request output
      MCKOUT0 : out std_logic;          --for trace adapter
      MCKOUT1 : out std_logic;          --programable clock out
      MTEST   : in  std_logic;  --                            high active
      MBYPASS : in  std_logic;
      MIRQ0   : in  std_logic;  --                            low active
      MIRQ1   : in  std_logic;  --                            low active
      -- SW debug
      MSDIN   : in  std_logic;          -- serial data in (debug)
      MSDOUT  : out std_logic;          -- serial data out

      MWAKEUP_LP : in    std_logic;     --                          high active
      MLP_PWR_OK : in    std_logic;
      -- power management control
      --pwr_switch_on : out std_logic_vector(3 downto 0);
      MPMIC_CORE : out   std_logic;
      MPMIC_IO   : out   std_logic;
      -- SDRAM interface (41bits)
      D_CLK      : out   std_logic;     --clock to SDRAM
      D_CS       : out   std_logic;     -- CS to SDRAM
      D_RAS      : out   std_logic;     -- RAS to SDRAM
      D_CAS      : out   std_logic;     -- CAS to SDRAM
      D_WE       : out   std_logic;     -- WE to SDRAM
      D_DQM      : out   std_logic_vector(7 downto 0);  --data mask
      D_DQ       : inout std_logic_vector(7 downto 0);  --data
      D_A        : out   std_logic_vector(13 downto 0);
      D_BA       : out   std_logic_vector(1 downto 0);
      D_CKE      : out   std_logic_vector(3 downto 0);

      -- Analog internal signals
      pwr_ok     : in  std_logic;  -- Power on detector output (active high)
      dis_bmem   : out std_logic;       -- Disable for vdd_bmem (active high)
      vdd_bmem   : in  std_logic;       -- Power for the BMEM block
      VCC18LP    : in  std_logic;       -- Power for the RTC block
      rxout      : in  std_logic;       -- RTC oscillator output
      ach_sel0   : out std_logic;       -- ADC channel select, bit 0
      ach_sel1   : out std_logic;       -- ADC channel select, bit 1
      ach_sel2   : out std_logic;       -- ADC channel select, bit 2
      adc_bits   : in  std_logic;  -- Bitstream from the analog part of ADC
      adc_ref2v  : out std_logic;  -- Select 2V internal ADC reference (1V)
      adc_extref : out std_logic;  -- Select external ADC reference (internal)
      adc_diff   : out std_logic;  -- Select differential ADC mode (single-ended)
      adc_en     : out std_logic;       -- Enable for the ADC
      dac0_bits  : out std_logic;       -- Bitstream to DAC0
      dac1_bits  : out std_logic;       -- Bitstream to DAC1
      dac0_en    : out std_logic;       -- Enable for DAC0
      dac1_en    : out std_logic;       -- Enable for DAC1
      clk_a      : out std_logic;       -- Clock to the DAC's and ADC

      -- PLL
      -- VCC18A  : in   std_logic;
      -- GND18A  : in   std_logic;
      -- VCC18D  : in   std_logic;
      -- GND18D  : in   std_logic;
      -- VCCK    : in   std_logic;
      -- GNDK    : in   std_logic;

      -- PORT
      PA : inout std_logic_vector(7 downto 0);  -- port A
      PB : inout std_logic_vector(7 downto 0);  -- port B
      PC : inout std_logic_vector(7 downto 0);  -- port C
      PD : inout std_logic_vector(7 downto 0);  -- port D /DDQM, connect to TYA(7..0) and to DDQM(7..0)
      PE : inout std_logic_vector(7 downto 0);
      PF : inout std_logic_vector(7 downto 0);  -- port F ethernet 1
      PG : inout std_logic_vector(7 downto 0);  -- port G, added by HYX, 20141115
      PH : inout std_logic_vector(7 downto 0);  -- port H /DMA ctrl
      PI : inout std_logic_vector(7 downto 0);  -- port I /ID
      PJ : inout std_logic_vector(7 downto 0);  -- port J /I/O ctrl, UART1, connect to I/O ctrl, DRAS(3..0)

      -- OSPI interface
      OSPI_Out  : out   OSPI_InterfaceOut_t;
      OSPI_DQ   : inout std_logic_vector(7 downto 0);
      OSPI_RWDS : inout std_logic
      );
-- MPG RAM signals
  end component;

  -- SDRAM (remove)
  signal D_CLK : std_logic;
  signal D_CS  : std_logic;
  signal D_RAS : std_logic;
  signal D_CAS : std_logic;
  signal D_WE  : std_logic;
  signal D_DQM : std_logic_vector(7 downto 0);
  signal D_DQ  : std_logic_vector(7 downto 0);
  signal D_A   : std_logic_vector(13 downto 0);
  signal D_BA  : std_logic_vector(1 downto 0);
  signal D_CKE : std_logic_vector(3 downto 0);

  -- NC PINS!!!!
  signal MCKOUT1    : std_logic;
  signal MTEST      : std_logic;
  signal MBYPASS    : std_logic;
  signal MIRQ1      : std_logic;
  signal MWAKEUP_LP : std_logic;
  signal MLP_PWR_OK : std_logic;
  signal MPMIC_CORE : std_logic;
  signal MPMIC_IO   : std_logic;

  -- Misc analog (also NC)
  signal dis_bmem   : std_logic;
  signal pwr_ok     : std_logic;
  signal ach_sel0   : std_logic;
  signal ach_sel1   : std_logic;
  signal ach_sel2   : std_logic;
  signal adc_ref2v  : std_logic;
  signal adc_extref : std_logic;
  signal adc_diff   : std_logic;
  signal adc_en     : std_logic;
  signal dac0_bits  : std_logic;
  signal dac1_bits  : std_logic;
  signal dac0_en    : std_logic;
  signal dac1_en    : std_logic;
  signal clk_a      : std_logic;

  -- Inputs
  signal vdd_bmem   : std_logic;
  signal VCC18LP    : std_logic;
  signal rxout      : std_logic;
  signal adc_bits   : std_logic;

  -- Ports
  signal PA : std_logic_vector(7 downto 0);
  signal PB : std_logic_vector(7 downto 0);
  signal PC : std_logic_vector(7 downto 0);
  signal PD : std_logic_vector(7 downto 0);
  signal PE : std_logic_vector(7 downto 0);
  signal PF : std_logic_vector(7 downto 0);
  signal PG : std_logic_vector(7 downto 0);
  signal PH : std_logic_vector(7 downto 0);
  signal PI : std_logic_vector(7 downto 0);
  signal PJ : std_logic_vector(7 downto 0);

  signal HCLK           : std_logic;
  signal clk_200m       : std_logic;
  signal clk_300m       : std_logic;
  signal clk_400m       : std_logic;
  signal VCU118_Clk300M : std_logic;

  signal counter34 : unsigned(33 downto 0) := (others => '0');


begin

  LED(7)          <= not PA(7);
  LED(6)          <= not PA(6);
  LED(5)          <= not PA(5);
  LED(4)          <= not PA(0);
  LED(3 downto 0) <= std_logic_vector(counter34(33 downto 30));

  PA7_SOUT <= PA(7);
  PA6_SCK  <= PA(6);
  PA5_CS_N <= PA(5);
  PA0_SIN  <= PA(0);

  OE_CTR <= '1';                        -- Low tri-states levelshifter outputs
  
  -- TODO
  vdd_bmem   <= '0';
  VCC18LP    <= '0';
  rxout      <= '0';
  adc_bits   <= '0';
  -- URX <= 
  -- UTX <=  

  process(VCU118_Clk300M)
  begin
    if rising_edge(VCU118_Clk300M) then
      counter34 <= counter34 + 1;
    end if;
  end process;

  fpga_pll_inst : clk_wiz_0
    port map (

      clk_200M => clk_200M,
      clk_300M => clk_300M,
      clk_400M => clk_400M,
      clk_in   => VCU118_Clk300M
      );

  HCLK <= clk_300m;

  im4000_inst : top
    generic map (
      g_memory_type => fpga
      )
    port map (
      HCLK       => HCLK,
      MRESET     => MRESET,
      MIRQOUT    => MIRQOUT,
      MCKOUT0    => MCKOUT0,
      MCKOUT1    => MCKOUT1,
      MTEST      => MTEST,
      MBYPASS    => MBYPASS,
      MIRQ0      => MIRQ0,
      MIRQ1      => MIRQ1,
      MSDIN      => MSDIN,
      MSDOUT     => MSDOUT,
      MWAKEUP_LP => MWAKEUP_LP,
      MLP_PWR_OK => MLP_PWR_OK,
      MPMIC_CORE => MPMIC_CORE,
      MPMIC_IO   => MPMIC_IO,
      D_CLK      => D_CLK,
      D_CS       => D_CS,
      D_RAS      => D_RAS,
      D_CAS      => D_CAS,
      D_WE       => D_WE,
      D_DQM      => D_DQM,
      D_DQ       => D_DQ,
      D_A        => D_A,
      D_BA       => D_BA,
      D_CKE      => D_CKE,
      pwr_ok     => pwr_ok,
      dis_bmem   => dis_bmem,
      vdd_bmem   => vdd_bmem,
      VCC18LP    => VCC18LP,
      rxout      => rxout,
      ach_sel0   => ach_sel0,
      ach_sel1   => ach_sel1,
      ach_sel2   => ach_sel2,
      adc_bits   => adc_bits,
      adc_ref2v  => adc_ref2v,
      adc_extref => adc_extref,
      adc_diff   => adc_diff,
      adc_en     => adc_en,
      dac0_bits  => dac0_bits,
      dac1_bits  => dac1_bits,
      dac0_en    => dac0_en,
      dac1_en    => dac1_en,
      clk_a      => clk_a,
      PA         => PA,
      PB         => PB,
      PC         => PC,
      PD         => PD,
      PE         => PE,
      PF         => PF,
      PG         => PG,
      PH         => PH,
      PI         => PI,
      PJ         => PJ,
      OSPI_Out   => OSPI_Out,
      OSPI_DQ    => OSPI_DQ,
      OSPI_RWDS  => OSPI_RWDS
      );

end rtl;
