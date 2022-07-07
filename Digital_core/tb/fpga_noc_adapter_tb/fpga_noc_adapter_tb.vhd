library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_textio.all;

use std.textio.all;

use work.gp_pkg.all;

entity fpga_noc_adapter_tb is
  generic (
    ionoc_fifo_depth_bits : integer                      := 4;  -- Each FIFO is 2^x = 16 words deep
    ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
    ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
    ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
    ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
    ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
    ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A");
end entity;

architecture tb of fpga_noc_adapter_tb is

  component fpga_noc_adapter is
  generic (
    ionoc_fifo_depth_bits : integer                      := 4;  -- Each FIFO is 2^x = 16 words deep
    ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
    ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
    ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
    ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
    ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
    ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A");
  port (
    -- Domain clk_p
    ------------------------------------------------------
    clk_p     : in  std_logic;                          -- Main clock
    clk_i_pos : in  std_logic;                          --
    rst_n     : in  std_logic;                          -- Async reset
    -- I/O bus
    idi       : in  std_logic_vector (7 downto 0);      -- I/O bus in
    ido       : out std_logic_vector (7 downto 0);      -- I/O bus out
    iden      : out std_logic;                          -- I/O bus enabled (in use)
    ilioa     : in  std_logic;                          -- I/O bus load I/O address
    ildout    : in  std_logic;                          -- I/O bus data output strobe
    inext     : in  std_logic;                          -- I/O bus data input  strobe
    idack     : in  std_logic;                          -- I/O bus DMA Ack
    idreq     : out std_logic;                          -- I/O bus DMA Request
    NOC_IRQ   : out std_logic;                          -- Interrupt on available data from NOC
    ------------------------------------------------------


    -- Domain clk_noc
    ------------------------------------------------------
    clk_noc : in std_logic;                             -- NOC Clock

    ------ CMD interface -------
    -- GPP CMD to NOC
    GPP_CMD      : out std_logic_vector(127 downto 0);  -- Command word
    GPP_CMD_Flag : out std_logic;                       -- Command word valid
    NOC_CMD_ACK  : in  std_logic;                       -- NOC ready
    -- NOC CMD to GPP
    NOC_CMD_Flag : in  std_logic;                       -- NOC command byte is valid
    NOC_CMD      : in  std_logic_vector(7 downto 0);    -- Command byte
    GPP_CMD_ACK  : out std_logic;                       -- GPP ack of command byte

    ------ DATA interface -------
    NOC_DATA_EN  : in  std_logic;                       -- Enable traffic to (IO_DATA) or from (NOC_DATA) the NOC, dep on NOC_DATA_DIR
    NOC_DATA_DIR : in  std_logic;                       -- Direction of NOC data transfer to/from FIFOs
    NOC_DATA     : in  std_logic_vector(127 downto 0);  -- Data to the TxFIFO
    IO_DATA      : out std_logic_vector(127 downto 0);  -- Data from the RxFIFO
    FIFO_READY   : out std_logic_vector(5 downto 0);    -- FIFO level, filled or remaining dep on NO_DATA_DIR

    ------ IO interface --------
    NOC_ADDRESS   : in  std_logic_vector(31 downto 0);  -- Memory address of NOC data request
    NOC_LENGTH    : in  std_logic_vector(15 downto 0);  -- Length of NOC data request
    NOC_IO_DIR    : in  std_logic;                      -- Direction of NOC data request
    NOC_WRITE_REQ : in  std_logic;                      -- NOC address, length and data direction is valid
    IO_WRITE_ACK  : out std_logic                       -- NOC data parameters have been read and can now be updated
   -------------------------------------------------------
    );
  end component;

  -- Types
  type fsm_t is (
    reset,
    init,
    --
    test1,
    --
    wait_done,
    done);

  -- Constants


  -- TB SETTINGS

  -- Concurrent statementes
  signal clk_p   : std_logic := '0';
  signal clk_noc : std_logic := '0';
  signal reset_n : std_logic := '0';
  --

  -- test_proc
  signal run       : std_logic := '1';
  signal fsm       : fsm_t     := reset;
  signal fsm_d     : fsm_t     := reset;
  signal fsm_count : integer   := 0;

  --
  signal idi              : std_logic_vector (7 downto 0);
  signal ilioa            : std_logic;
  signal ildout           : std_logic;
  signal inext            : std_logic;
  signal idack            : std_logic;
  signal idreq            : std_logic;


  -- DUT
  signal ido  : std_logic_vector (7 downto 0);
  signal iden : std_logic;

  signal NOC_CMD_ACK  : std_logic                    := '0';
  signal NOC_CMD      : std_logic_vector(7 downto 0) := (others => '0');
  signal NOC_CMD_Flag : std_logic                    := '0';

  signal GPP_CMD      : std_logic_vector(127 downto 0);
  signal GPP_CMD_Flag : std_logic;
  signal GPP_CMD_ACK  : std_logic;
  signal NOC_IRQ      : std_logic;
  --
  signal NOC_ADDRESS   : std_logic_vector(31 downto 0)  := (others => '0');
  signal NOC_LENGTH    : std_logic_vector(15 downto 0)  := (others => '0');
  signal NOC_IO_DIR    : std_logic                      := '0';
  signal NOC_DATA_DIR  : std_logic                      := '0';
  signal NOC_DATA_EN   : std_logic                      := '0';
  signal NOC_WRITE_REQ : std_logic                      := '0';
  signal IO_WRITE_ACK  : std_logic                      := '0';
  signal NOC_DATA      : std_logic_vector(127 downto 0);
  signal IO_DATA       : std_logic_vector(127 downto 0);
  signal FIFO_READY    : std_logic_vector(5 downto 0);

  -- noc_proc


  -- clk_proc
  signal clk_count        : std_logic_vector(7 downto 0) := x"00";
  signal clk_i            : std_logic                    := '0';


  -- Constants
  constant clock_frequency_c  : real := 300.0;  --MHz
  constant clock_period_c     : time := 1 us / clock_frequency_c;
  --
  constant nocclk_frequency_c : real := 713.2;  --MHz
  constant nocclk_period_c    : time := 1 us / nocclk_frequency_c;

begin

  clk_p   <= run and not clk_p   after clock_period_c/2;
  clk_noc <= run and not clk_noc after nocclk_period_c/2;
  reset_n <= '1'                 after 10 * clock_period_c;

  clk_proc : process(clk_p)
  begin
    if rising_edge(clk_p) then
      --
      clk_count <= std_logic_vector(unsigned(clk_count) + 1);
      --
      if clk_count(1 downto 0) = "11" then
        clk_i <= '0';
      else
        clk_i <= '1';
      end if;

    end if; -- clk_p
  end process; -- clk_proc

  test_proc : process(clk_p)
    variable l   : line;
    variable row : integer := 0;
  begin

    if rising_edge(clk_p) then
      -- Defaults
      idi              <= x"00";
      ilioa            <= '1';
      ildout           <= '1';
      inext            <= '1';
      idack            <= '1';
      --

      -- Delays
      fsm_d <= fsm;

      -- Reset data_count each new state
      fsm_count <= fsm_count + 1;

      case fsm is
        when done =>
          if fsm_count = 32 then
            run <= '0';
            --
            write(l, string'("Done"));
            writeline(output, l);
          end if;

        when reset =>

          if reset_n = '1' then
            fsm       <= init;
            fsm_count <= 0;
            --
            write(l, string'("Reset released"));
            writeline(output, l);
          end if;

        when init =>
          if clk_count(1 downto 0) = "11" then
            fsm       <= test1;
            fsm_count <= 0;
            --
            write(l, string'("[TEST START] - Test 1"));
            writeline(output, l);
          end if;

        when wait_done =>
          if fsm_count = 16 then
            write(l, string'("TB done"));
            writeline(output, l);
            fsm <= done;
          end if;

        when others =>
          --

      end case;

    end if;  -- clk_p
  end process;  -- test_proc

  noc_proc : process(clk_noc)
    variable l   : line;
    variable row : integer := 0;
  begin

    if rising_edge(clk_noc) then
      -- Defaults

    end if;  -- clk_noc
  end process;  -- noc_proc

  DUT : fpga_noc_adapter
    generic map (
      ionoc_fifo_depth_bits => ionoc_fifo_depth_bits,
      ionoc_status_address  => ionoc_status_address,
      ionoc_cmd_address     => ionoc_cmd_address,
      ionoc_data_address    => ionoc_data_address,
      ionoc_addr_address    => ionoc_addr_address,
      ionoc_length_address  => ionoc_length_address,
      ionoc_datadir_address => ionoc_datadir_address)
    port map (
      clk_p         => clk_p,
      clk_i_pos     => clk_i,
      rst_n         => reset_n,
      idi           => idi,
      ido           => ido,
      iden          => iden,
      ilioa         => ilioa,
      ildout        => ildout,
      inext         => inext,
      idack         => idack,
      idreq         => idreq,
      NOC_IRQ       => NOC_IRQ,
      clk_noc       => clk_noc,
      GPP_CMD       => GPP_CMD,
      GPP_CMD_Flag  => GPP_CMD_Flag,
      NOC_CMD_ACK   => NOC_CMD_ACK,
      NOC_CMD_Flag  => NOC_CMD_Flag,
      NOC_CMD       => NOC_CMD,
      GPP_CMD_ACK   => GPP_CMD_ACK,
      NOC_DATA_EN   => NOC_DATA_EN,
      NOC_DATA_DIR  => NOC_DATA_DIR,
      NOC_DATA      => NOC_DATA,
      IO_DATA       => IO_DATA,
      FIFO_READY    => FIFO_READY,
      NOC_ADDRESS   => NOC_ADDRESS,
      NOC_LENGTH    => NOC_LENGTH,
      NOC_IO_DIR    => NOC_IO_DIR,
      NOC_WRITE_REQ => NOC_WRITE_REQ,
      IO_WRITE_ACK  => IO_WRITE_ACK
    );

end tb;
