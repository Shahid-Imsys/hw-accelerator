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
    --
    FIFO_READY   : out std_logic_vector(ionoc_fifo_depth_bits downto 0); -- FIFO level, filled or remaining dep on NO_DATA_DIR

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
    test1a,
    test1b,
    --
    test2a,
    test2b,
    --
    test3a,
    test3b,
    --
    test4a,
    test4b,
    test4c,
    --
    test5a,
    test5b,
    --
    test6a,
    test6b,
    --
    wait_done,
    done);

  type gpp_action_t is (
    poll_and_read_io_request,
    write_data_to_noc,
    read_data_from_noc,
    idle);

  type io_bus_action_t is (
    poll_for_masked_bit,
    read_io_address,
    read_io_length,
    read_io_datadir,
    --
    write_noc_data,
    read_noc_data,
    --
    done,
    idle);

  -- Constants


  -- TB SETTINGS

  -- Concurrent statementes
  signal clk_p   : std_logic := '0';
  signal clk_noc : std_logic := '0';
  signal reset_n : std_logic := '0';
  --

  -- test_proc
  signal run        : std_logic := '1';
  signal fsm        : fsm_t     := reset;
  signal fsm_d      : fsm_t     := reset;
  signal fsm_count  : integer   := 0;
  signal gpp_action : gpp_action_t := idle;
  signal gpp_wrdata : std_logic_vector(127 downto 0);
  signal gpp_rddata : std_logic_vector(127 downto 0) := (others => '0');

  -- gpp_proc
  signal idi              : std_logic_vector (7 downto 0);
  signal ilioa            : std_logic;
  signal ildout           : std_logic;
  signal inext            : std_logic;
  signal idack            : std_logic;
  signal idreq            : std_logic;
  --
  signal io_bus_action    : io_bus_action_t := idle;
  signal io_bus_action_d  : io_bus_action_t := idle;
  --
  signal io_bus_mask      : std_logic_vector(7 downto 0);
  signal io_bus_poll_data : std_logic_vector(7 downto 0);
  signal io_bus_done      : std_logic;
  --
  signal iobus_status  : std_logic_vector(7 downto 0) := (others => 'U');
  signal iobus_cmd     : std_logic_vector(7 downto 0) := (others => 'U');
  signal iobus_data    : std_logic_vector(7 downto 0) := (others => 'U');
  signal iobus_addr    : std_logic_vector(31 downto 0) := (others => 'U');
  signal iobus_length  : std_logic_vector(15 downto 0) := (others => 'U');
  signal iobus_datadir : std_logic := 'U';


  -- DUT
  -- clk_p
  signal ido           : std_logic_vector (7 downto 0);
  signal iden          : std_logic;

  -- clk_noc
  signal NOC_CMD_ACK   : std_logic                    := '0';
  signal NOC_CMD       : std_logic_vector(7 downto 0) := (others => '0');
  signal NOC_CMD_Flag  : std_logic                    := '0';
  --
  signal GPP_CMD       : std_logic_vector(127 downto 0);
  signal GPP_CMD_Flag  : std_logic;
  signal GPP_CMD_ACK   : std_logic;
  signal NOC_IRQ       : std_logic;
  --
  signal NOC_ADDRESS   : std_logic_vector(31 downto 0)  := (others => '0');
  signal NOC_LENGTH    : std_logic_vector(15 downto 0)  := (others => '0');
  signal NOC_DATA_DIR  : std_logic                      := '0';
  signal NOC_DATA_EN   : std_logic                      := '0';
  signal NOC_WRITE_REQ : std_logic                      := '0';
  signal IO_WRITE_ACK  : std_logic                      := '0';
  signal NOC_IO_DIR    : std_logic                      := '0';
  signal NOC_DATA      : std_logic_vector(127 downto 0);
  signal IO_DATA       : std_logic_vector(127 downto 0);
  signal FIFO_READY    : std_logic_vector(ionoc_fifo_depth_bits downto 0);

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

  gpp_proc : process(clk_p)
    variable l              : line;
    variable row            : integer := 0;
    --
    variable io_bus_counter : integer;
  begin
    if rising_edge(clk_p) then
      -- Defaults
      io_bus_done      <= '0';

     if clk_count(1 downto 0) = "11" then
        -- Defaults
        idi              <= x"00";
        ilioa            <= '1';
        ildout           <= '1';
        inext            <= '1';
        idack            <= '1';

        io_bus_action_d <= io_bus_action;

        io_bus_counter := io_bus_counter + 1;

        case io_bus_action is
          when done =>
            io_bus_counter := 0;
            io_bus_done    <= '1';

          when idle =>
            io_bus_counter   := 0;
            io_bus_poll_data <= x"00";

          when poll_for_masked_bit =>
            if io_bus_counter = 1 then
              idi   <= ionoc_status_address;
              ilioa <= '0';
            else
              inext <= '0';
              --
              if io_bus_counter > 2 then
                if (ido and io_bus_mask) /= x"00" then
                  io_bus_counter   := 0;
                  io_bus_poll_data <= ido;
                  io_bus_action    <= read_io_address;
                  inext            <= '1';
                end if;
            end if;
          end if;

          when read_io_address =>
            if io_bus_counter = 1 then
              idi   <= ionoc_addr_address;
              ilioa <= '0';
            else
              inext <= '0';
              --
              if io_bus_counter = 2 then
                iobus_addr(7 downto 0) <= ido;
              end if;
              if io_bus_counter = 3 then
                iobus_addr(15 downto 8) <= ido;
              end if;
              if io_bus_counter = 4 then
                iobus_addr(23 downto 16) <= ido;
              end if;
              if io_bus_counter = 5 then
                iobus_addr(31 downto 24) <= ido;
                io_bus_action  <= read_io_length;
                io_bus_counter := 0;
              end if;
            end if;

          when read_io_length =>
            if io_bus_counter = 1 then
              idi   <= ionoc_length_address;
              ilioa <= '0';
            else
              inext <= '0';
              --
              if io_bus_counter = 2 then
                iobus_length(7 downto 0) <= ido;
              end if;
              if io_bus_counter = 3 then
                iobus_length(15 downto 8) <= ido;
                io_bus_action  <= read_io_datadir;
                io_bus_counter := 0;
              end if;
            end if;

          when read_io_datadir =>
            if io_bus_counter = 1 then
              idi   <= ionoc_datadir_address;
              ilioa <= '0';
            else
              inext <= '0';
              --
              if io_bus_counter = 2 then
                iobus_datadir <= ido(0);
                io_bus_action <= done;
              end if;
            end if;

          when read_noc_data =>
            if io_bus_counter = 1 then
              idi   <= ionoc_data_address;
              ilioa <= '0';
            else
              inext <= '0';
              --
              if io_bus_counter = 2 then
                gpp_rddata(7 downto 0) <= ido;
              end if;
              if io_bus_counter = 3 then
                gpp_rddata(15 downto 8) <= ido;
              end if;
              if io_bus_counter = 4 then
                gpp_rddata(23 downto 16) <= ido;
              end if;
              if io_bus_counter = 5 then
                gpp_rddata(31 downto 24) <= ido;
              end if;
              if io_bus_counter = 6 then
                gpp_rddata(39 downto 32) <= ido;
              end if;
              if io_bus_counter = 7 then
                gpp_rddata(47 downto 40) <= ido;
              end if;
              if io_bus_counter = 8 then
                gpp_rddata(55 downto 48) <= ido;
              end if;
              if io_bus_counter = 9 then
                gpp_rddata(63 downto 56) <= ido;
              end if;
              if io_bus_counter = 10 then
                gpp_rddata(71 downto 64) <= ido;
              end if;
              if io_bus_counter = 11 then
                gpp_rddata(79 downto 72) <= ido;
              end if;
              if io_bus_counter = 12 then
                gpp_rddata(87 downto 80) <= ido;
              end if;
              if io_bus_counter = 13 then
                gpp_rddata(95 downto 88) <= ido;
              end if;
              if io_bus_counter = 14 then
                gpp_rddata(103 downto 96) <= ido;
              end if;
              if io_bus_counter = 15 then
                gpp_rddata(111 downto 104) <= ido;
              end if;
              if io_bus_counter = 16 then
                gpp_rddata(119 downto 112) <= ido;
              end if;
              if io_bus_counter = 17 then
                gpp_rddata(127 downto 120) <= ido;
                io_bus_action  <= done;
              end if;
            end if;

          when write_noc_data =>
            if io_bus_counter = 1 then
              idi   <= ionoc_data_address;
              ilioa <= '0';
            else
              ildout <= '0';
              --
              if io_bus_counter = 2 then
                idi <= gpp_wrdata(7 downto 0);
              end if;
              if io_bus_counter = 3 then
                idi <= gpp_wrdata(15 downto 8);
              end if;
              if io_bus_counter = 4 then
                idi <= gpp_wrdata(23 downto 16);
              end if;
              if io_bus_counter = 5 then
                idi <= gpp_wrdata(31 downto 24);
              end if;
              if io_bus_counter = 6 then
                idi <= gpp_wrdata(39 downto 32);
              end if;
              if io_bus_counter = 7 then
                idi <= gpp_wrdata(47 downto 40);
              end if;
              if io_bus_counter = 8 then
                idi <= gpp_wrdata(55 downto 48);
              end if;
              if io_bus_counter = 9 then
                idi <= gpp_wrdata(63 downto 56);
              end if;
              if io_bus_counter = 10 then
                idi <= gpp_wrdata(71 downto 64);
              end if;
              if io_bus_counter = 11 then
                idi <= gpp_wrdata(79 downto 72);
              end if;
              if io_bus_counter = 12 then
                idi <= gpp_wrdata(87 downto 80);
              end if;
              if io_bus_counter = 13 then
                idi <= gpp_wrdata(95 downto 88);
              end if;
              if io_bus_counter = 14 then
                idi <= gpp_wrdata(103 downto 96);
              end if;
              if io_bus_counter = 15 then
                idi <= gpp_wrdata(111 downto 104);
              end if;
              if io_bus_counter = 16 then
                idi <= gpp_wrdata(119 downto 112);
              end if;
              if io_bus_counter = 17 then
                idi <= gpp_wrdata(127 downto 120);
                io_bus_action  <= done;
              end if;
            end if;


        end case;

      end if;

      case gpp_action is

        when idle =>
          io_bus_action <= idle;

        when poll_and_read_io_request =>
          if io_bus_action = idle then
            io_bus_action <= poll_for_masked_bit;
             -- Bit 3 in status reg indicating io request available
            io_bus_mask   <= (3 => '1', others => '0');
          end if;

        when write_data_to_noc =>
          if io_bus_action = idle then
            io_bus_action <= write_noc_data;
          end if;

        when read_data_from_noc =>
          if io_bus_action = idle then
            io_bus_action <= read_noc_data;
          end if;

      end case;

    end if; -- clk_p
  end process; -- clk_proc


  test_proc : process(clk_noc)
    variable l   : line;
    variable row : integer := 0;
  begin

    if rising_edge(clk_noc) then
      -- Defaults
      NOC_WRITE_REQ <= '0';
      NOC_DATA_EN   <= '0';

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
            fsm       <= test1a;
            fsm_count <= 0;
            --
            write(l, string'("[TEST START] - Test 1  (Start of GPP to NOC sequence)"));
            writeline(output, l);
          end if;

        when wait_done =>
          if fsm_count = 16 then
            write(l, string'("TB done"));
            writeline(output, l);
            fsm <= done;
          end if;

        -------------------------------------------
        -- TEST1 - NOC requests data from some address (to RxFIFO)
        -------------------------------------------
        when test1a =>
          NOC_ADDRESS  <= x"12345678";
          NOC_LENGTH   <= x"0123";
          NOC_IO_DIR   <= '0'; -- Data dir is towards NOC

          if fsm_count > 0 then
            NOC_WRITE_REQ <= '1';
            if fsm_count = 1 then
              write(l, string'("[NOC] Requesting address 0x"));
              hwrite(l, NOC_ADDRESS);
              writeline(output, l);

              write(l, string'("[NOC] Requesting length 0x"));
              hwrite(l, NOC_LENGTH);
              writeline(output, l);

              write(l, string'("[NOC] Requesting direction "));
              if NOC_DATA_DIR = '0' then write(l, string'("TO NOC (0)")); else write(l, string'("FROM NOC (1)")); end if;
              writeline(output, l);
            end if;
          end if;

          if fsm_count = 3 then -- Should not be hard coded but the NOC is not the DUT here....
            fsm <= test1b;
          end if;

        -- 1b - Show what request the GPP got
        when test1b =>
          gpp_action <= poll_and_read_io_request;

          if io_bus_done = '1' then
            gpp_action <= idle;
            --
            write(l, string'("[GPP] Addr on iobus: 0x"));
            hwrite(l, iobus_addr );
            writeline(output, l);
            --
            write(l, string'("[GPP] Length on iobus: 0x"));
            hwrite(l, iobus_length );
            writeline(output, l);
            --
            write(l, string'("[GPP] Datadir on iobus: "));
            write(l, iobus_datadir );
            writeline(output, l);
            ----------------------------------------
            fsm <= test2a;
            write(l, string'("[TEST START] - Test 2"));
            writeline(output, l);
          end if;

        -------------------------------------------
        -- TEST2 - GPP writes some data to RxFIFO
        -------------------------------------------
        when test2a =>
          if gpp_action    = idle and
             io_bus_action = idle then
            gpp_action <= write_data_to_noc;
            gpp_wrdata <= x"abcdef11223344556677889902345678";
            --
            write(l, string'("[RxFIFO] Level: "));
            write(l, to_integer( unsigned( FIFO_READY ) ) );
            writeline(output, l);
          end if;

          if gpp_action    = write_data_to_noc and
             io_bus_action = done then
            fsm <= test2b;
            --
            write(l, string'("[GPP] Data is written to interface: 0x"));
            hwrite(l, gpp_wrdata );
            writeline(output, l);
          end if;

        when test2b =>
          if io_bus_action = done then
            gpp_action <= idle;
          end if;

          if unsigned( FIFO_READY ) /= 0 then
            --
            write(l, string'("[I/F] Data is written to RxFIFO"));
            writeline(output, l);
            --
            write(l, string'("[RxFIFO] Level: "));
            write(l, to_integer( unsigned( FIFO_READY ) ) );
            writeline(output, l);
            ----------------------------------------
            fsm <= test3a;
            write(l, string'("[TEST START] - Test 3"));
            writeline(output, l);
          end if;

        -------------------------------------------
        -- TEST3 - NOC reads data from adapter (RxFIFO)
        -------------------------------------------
        when test3a =>
          NOC_DATA_DIR <= '0';
          if gpp_action    = idle and
             io_bus_action = idle then

            if NOC_DATA_DIR = '0' and unsigned( FIFO_READY ) /= 0 then
              fsm         <= test3b;
              NOC_DATA_EN <= '1';
              --
              write(l, string'("[NOC] FIFO_READY is non-zero"));
              writeline(output, l);
              write(l, string'("[NOC] IO_DATA is 0x"));
              hwrite(l, IO_DATA );
              writeline(output, l);

            end if;
          end if;

        when test3b =>
          if NOC_DATA_EN = '0' then
            if unsigned( FIFO_READY ) = 0 then
              write(l, string'("[NOC] RxFIFO is empty"));
              writeline(output, l);
              ----------------------------------------
              fsm       <= test4a;
              fsm_count <= 0;
              write(l, string'("[TEST START] - Test 4 (Start of NOC to GPP sequence)"));
              writeline(output, l);
            else
              assert false report "Read RxFIFO did not become empty after read!" severity failure;
            end if;
          end if;

        -------------------------------------------
        -- TEST4 - NOC writes some data to TxFIFO
        -------------------------------------------
        when test4a =>
          NOC_DATA_DIR <= '1';
          NOC_DATA     <= x"1029_3847_5647_3829_10af_becd_beaf_beef";

          if NOC_DATA_DIR = '1' and
             unsigned(FIFO_READY) /= 0 then
              fsm         <= test4b;
              NOC_DATA_EN <= '1';
              --
              write(l, string'("[TxFIFO] Level: "));
              write(l, to_integer( unsigned( FIFO_READY ) ) );
              writeline(output, l);
              --
              write(l, string'("[NOC] NOC_DATA presented to adapter 0x"));
              hwrite(l, NOC_DATA );
              writeline(output, l);
          end if;

        when test4b =>
          if NOC_DATA_DIR = '1' and NOC_DATA_EN = '0' then
            fsm <= test4c;
            --
            write(l, string'("[TxFIFO] Level: "));
            write(l, to_integer( unsigned( FIFO_READY ) ) );
            writeline(output, l);
          end if;

        when test4c =>
          if unsigned( FIFO_READY ) = (2**ionoc_fifo_depth_bits) then
            fsm       <= test5a;
            fsm_count <= 0;
                      --
            write(l, string'("[I/F] Data is read from TxFIFO"));
            writeline(output, l);
            --
            write(l, string'("[TxFIFO] Level: "));
            write(l, to_integer( unsigned( FIFO_READY ) ) );
            writeline(output, l);
            --
            write(l, string'("[TEST START] - Test 5"));
            writeline(output, l);
          end if;

        -------------------------------------------
        -- TEST5 - NOC requests data to some address (to RxFIFO)
        -------------------------------------------
        when test5a =>
          NOC_ADDRESS  <= x"abcdeeef";
          NOC_LENGTH   <= x"2132";
          NOC_IO_DIR   <= '1'; -- Data dir is from NOC

          if fsm_count > 0 then
            NOC_WRITE_REQ <= '1';
            if fsm_count = 1 then
              write(l, string'("[NOC] Requesting address 0x"));
              hwrite(l, NOC_ADDRESS);
              writeline(output, l);

              write(l, string'("[NOC] Requesting length 0x"));
              hwrite(l, NOC_LENGTH);
              writeline(output, l);

              write(l, string'("[NOC] Requesting direction "));
              if NOC_DATA_DIR = '0' then write(l, string'("TO NOC (0)")); else write(l, string'("FROM NOC (1)")); end if;
              writeline(output, l);
            end if;
          end if;

          if fsm_count = 3 then -- Should not be hard coded but the NOC is not the DUT here....
            fsm <= test5b;
          end if;

        -- 5b - Show what request the GPP got
        when test5b =>
          gpp_action <= poll_and_read_io_request;

          if io_bus_done = '1' then
            gpp_action <= idle;
            --
            write(l, string'("[GPP] Addr on iobus: 0x"));
            hwrite(l, iobus_addr );
            writeline(output, l);
            --
            write(l, string'("[GPP] Length on iobus: 0x"));
            hwrite(l, iobus_length );
            writeline(output, l);
            --
            write(l, string'("[GPP] Datadir on iobus: "));
            write(l, iobus_datadir );
            writeline(output, l);
            ----------------------------------------
            fsm <= test6a;
            write(l, string'("[TEST START] - Test 6"));
            writeline(output, l);
          end if;

        -------------------------------------------
        -- TEST6 - GPP reads the data from interface (which automatically has read the non-emtpy TxFIFO)
        -------------------------------------------
        when test6a =>
          if gpp_action    = idle and
             io_bus_action = idle then
            gpp_action <= read_data_from_noc;
          end if;

          if gpp_action    = read_data_from_noc and
             io_bus_action = done then
            fsm <= test6b;
            --
            write(l, string'("[GPP] Data read from interface: 0x"));
            hwrite(l, gpp_rddata );
            writeline(output, l);
          end if;

        when test6b =>
          if io_bus_action = done then
            gpp_action <= idle;
            ----------------------------------------
            fsm       <= wait_done;
            fsm_count <= 0;
            write(l, string'("[WAIT_DONE]"));
            writeline(output, l);
          end if;

        when others =>
          fsm_count <= 0;
          fsm       <= wait_done;

          assert false report "Unhandeled state, exiting..." severity error;

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

configuration simulation of fpga_noc_adapter_tb is
  for tb
  end for;
end configuration;