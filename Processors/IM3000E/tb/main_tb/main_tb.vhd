library ieee;
use ieee.std_logic_1164.all;
use work.all;
use work.digital_top_sim_pack.all;
use work.tb_components_pkg.all;

use work.gp_pkg.all;

entity main_tb is
end main_tb;

architecture tb of main_tb is

  constant HALF_CLK_C_CYCLE : time := 16000 ps;

  signal MX1_CK  : std_logic;
  signal MXOUT   : std_logic;
  signal MEXEC   : std_logic;
  signal MCKOUT0 : std_logic;
  signal MCKOUT1 : std_logic;
  signal MSDIN   : std_logic;
  signal MSDOUT  : std_logic;
  signal MIRQOUT : std_logic;
  signal MRESET : std_logic;
  signal MTEST : std_logic := '0';
  signal MIRQ0 : std_logic;
  signal MIRQ1 : std_logic;
  signal D_DQ : std_logic_vector(7 downto 0) := (others => 'Z');

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

  signal MBYPASS    : std_logic;
  signal MWAKE      : std_logic;
  signal MLP_PWR_OK : std_logic := '0';
  signal XTAL1      : std_logic;

  signal reg_to_block : reg_to_block_t;

  signal xtal1_int : std_logic := '0';
  signal mx1_ck_int : std_logic := '0';

  signal OSPI_Out   : OSPI_InterfaceOut_t;
  signal OSPI_DQ    : std_logic_vector(7 downto 0);
  signal OSPI_RWDS  : std_logic;

begin  -- architecture tb


  top0 : entity work.top
    generic map (
      g_memory_type => fpga,
      g_clock_frequency => 31
      )
    port map (
      HCLK    => MX1_CK,
      MRESET  => MRESET,
      MRSTOUT => open,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      MCKOUT1 => MCKOUT1,
      MTEST   => MTEST,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug
      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,

      D_CLK => open,
      D_CS  => open,
      D_RAS => open,
      D_CAS => open,
      D_WE  => open,
      D_DQM => open,
      D_DQ  => D_DQ,
      D_A   => open,
      D_BA  => open,
      D_CKE => open,

      PA => PA,
      PB => PB,
      PC => PC,
      PD => PD,
      PE => PE,
      PF => PF,
      PH => PH,
      PI => PI,
      PJ => PJ,

      MBYPASS    => MBYPASS,
      MWAKEUP_LP => MWAKE,
      MLP_PWR_OK => MLP_PWR_OK,

      OSPI_Out   => OSPI_Out,
      OSPI_DQ    => OSPI_DQ,
      OSPI_RWDS  => OSPI_RWDS,

      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => XTAL1,
      adc_bits => '0'
      );

  PA(7 downto 5) <= "000";              -- This is read by ROM bootloader
  PA(4 downto 3) <= "01";               -- Set SP communication at /2 speed
  PA(2 downto 1) <= "01";               -- Set PLL multiplier to 4
  PA(0)          <= '1';                -- Set PLL divider to 1

  -- Reset the circuit for 10 ns;
  MRESET <= '0', '1' after 10 ns;

  -- This emulates a 31.25 MHz crystal
  mx1_ck_int <= not mx1_ck_int after HALF_CLK_C_CYCLE;
  MX1_CK     <= mx1_ck_int;

  -- This emulates a 32768 Hz crystal connected to RXOSC
  --xtal1_int <= not xtal1_int after 15259 ns;
  xtal1_int <= not xtal1_int after 1 us;
  XTAL1     <= xtal1_int;

  -- Bypass disabled
  MBYPASS <= '0';

  -- Wake-up signal inactive
  MWAKE <= '0';

  MIRQ0 <= '1';
  MIRQ1 <= '1';

  -- Connect MLP_PWR_OK to reset for simlicity.
  MLP_PWR_OK <= MRESET;

  i_debug_interface_bfm : entity work.debug_interface_bfm
    port map (

      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,

      reg_to_block   => reg_to_block,
      reg_from_block => open
      );

  i_uart : entity work.uart_tb
    port map (
      tx             => PJ(1),
      rx             => PJ(0),
      reg_to_block   =>  reg_to_block,
      reg_from_block =>  x"00"
      );

  i_octo_spi : entity work.octo_memory_bfm
    port map (
      ck      => OSPI_Out.CK_p,
      cs      => OSPI_Out.CS_n,
      rwds    => OSPI_RWDS,
      dq      => OSPI_DQ,
      reset_n => MRESET
      );

end architecture tb;
