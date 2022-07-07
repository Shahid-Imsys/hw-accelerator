library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_textio.all;

use std.textio.all;

use work.gp_pkg.all;

entity ionoc_tb is
  generic (
    ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
    ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
    ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
    ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
    ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
    ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A"
    );
end entity;

architecture tb of ionoc_tb is

  component ionoc is
    generic (
      ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
      ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
      ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
      ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
      ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
      ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A"
      );
    port (                              -- Domain clk_p
      ------------------------------------------------------
      clk_p     : in  std_logic;        -- Main clock
      clk_i_pos : in  std_logic;        --
      rst_n     : in  std_logic;        -- Async reset
      -- I/O bus
      idi       : in  std_logic_vector (7 downto 0);  -- I/O bus in
      ido       : out std_logic_vector (7 downto 0);  -- I/O bus out
      iden      : out std_logic;        -- I/O bus enabled (in use)
      ilioa     : in  std_logic;        -- I/O bus load I/O address
      ildout    : in  std_logic;        -- I/O bus data output strobe
      inext     : in  std_logic;        -- I/O bus data input  strobe
      idack     : in  std_logic;        -- I/O bus DMA Ack
      idreq     : out std_logic;        -- I/O bus DMA Request
      NOC_IRQ   : out std_logic;        -- Interrupt on available data from NOC
      ------------------------------------------------------


      -- Domain clk_noc (NOC)
      ------------------------------------------------------
      clk_noc       : in  std_logic;                      -- NOC Clock
      -- GPP CMD to NOC
      GPP_CMD       : out std_logic_vector(127 downto 0); -- Command word
      GPP_CMD_Flag  : out std_logic;                      -- Command word valid
      NOC_CMD_ACK   : in  std_logic;                      -- NOC ready
      -- NOC CMD to GPP
      NOC_CMD_Flag  : in  std_logic;                      -- NOC command byte is valid
      NOC_CMD       : in  std_logic_vector(7 downto 0);   -- Command byte
      GPP_CMD_ACK   : out std_logic;                      -- GPP ack of command byte
      -- NOC Data interface - for NOC request of data trx
      NOC_ADDRESS   : in  std_logic_vector(31 downto 0);  -- Memory address of NOC data request
      NOC_LENGTH    : in  std_logic_vector(15 downto 0);  -- Length of NOC data request
      NOC_DATA_DIR  : in  std_logic;                      -- Direction of NOC data request
      NOC_WRITE_REQ : in  std_logic;                      -- NOC address, length and data direction is valid
      IO_WRITE_ACK  : out std_logic;                      -- NOC data parameters have been read and can now be updated

      -- Domain clk_noc (FIFOS)
      ------------------------------------------------------
      -- NOC TxFIFO, read by IONOC
      TxFIFO_Ready  : out std_logic;                      -- Interface can accept a word from the TxIFO
      TxFIFO_Valid  : in  std_logic;                      -- TxFIFO has availble data which is presented on bus
      TxFIFO_Data   : in  std_logic_vector(127 downto 0); -- TxFIFO data
      -- NOC RxFIFO, written to by IONOC
      RxFIFO_Ready  : in  std_logic;                      -- RxFIFO can accept a word from the IO-bus
      RxFIFO_Valid  : out std_logic;                      -- Interface has availble data which is presented on bus
      RxFIFO_Data   : out std_logic_vector(127 downto 0) -- RxFIFO data
      ------------------------------------------------------
      );
  end component;

  component sync_fifo is
    generic (
      WIDTH : integer := 8;   -- Data width in bits
      BITS  : integer := 4);  -- fifo depth equal to 2^BITS + 1
    port (
      areset_n  : in  std_logic;
      clk       : in  std_logic;
      in_ready  : out std_logic;
      in_valid  : in  std_logic;
      in_data   : in  std_logic_vector(WIDTH-1 downto 0);
      out_ready : in  std_logic;
      out_valid : out std_logic                          := '0';
      out_data  : out std_logic_vector(WIDTH-1 downto 0) := (others => '0');
      level     : out std_logic_vector(BITS downto 0)
      );
  end component;

  -- Types
  type fsm_t is (
    reset,
    init,
    test1_wrio_addr,
    test1_wrio_data,
    test1_iowr_pollstatus,
    --
    test2_nocrd_flag,
    test2_nocrd_ack,
    test2_nocrd_pollstatus,
    --
    test3_nocwr_data,
    test3_nocwr_flag,
    test3_nocwr_ack,
    --
    test4_iord_pollstatus_set,
    test4_iord_data,
    test4_iord_pollstatus_reset,
    --
    test5_write_fifo_data_fr_noc,
    test5_pollstatus_set,
    --
    test6_write_fifo_data_fr_gpp1,
    test6_write_fifo_data_fr_gpp2,
    test6_pollstatus_set,
    test6_read_fifo_data,
    test6_pollstatus_reset,
    --
    test7_read_fifo_data_to_gpp,
    test7_pollstatus_reset,
    --
    test8_read_fifo_data_to_noc,
    --
    test9_issue_request,
    test9_request_processed,
    --
    test10_pollstatus_Set,
    test10_read_io_request_to_gpp_1,
    test10_read_io_request_to_gpp_2,
    test10_read_io_request_to_gpp_3,
    test10_pollstatus_reset,
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

  signal clk_count        : std_logic_vector(7 downto 0) := x"00";
  signal clk_i            : std_logic                    := '0';
  --
  signal idi              : std_logic_vector (7 downto 0);
  signal ilioa            : std_logic;
  signal ildout           : std_logic;
  signal inext            : std_logic;
  signal idack            : std_logic;
  signal idreq            : std_logic;
  --
  signal NOC_CMD_Flag_int : std_logic;
  signal GPP_CMD_ACK_int  : std_logic;
  --
  signal TxFIFO_Valid_int : std_logic;
  signal RxFIFO_Ready_int : std_logic;
  --
  signal IORequest_int    : std_logic;


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

  signal TxFIFO_Ready  : std_logic;
  signal TxFIFO_Valid  : std_logic                      := '0';
  signal TxFIFO_Data   : std_logic_vector(127 downto 0) := (others => '0');
  --
  signal RxFIFO_Ready  : std_logic                      := '0';
  signal RxFIFO_Valid  : std_logic;
  signal RxFIFO_Data   : std_logic_vector(127 downto 0);
  --
  signal NOC_ADDRESS   : std_logic_vector(31 downto 0)  := (others => '0');
  signal NOC_LENGTH    : std_logic_vector(15 downto 0)  := (others => '0');
  signal NOC_DATA_DIR  : std_logic                      := '0';
  signal NOC_CTRL_EN   : std_logic                      := '0';
  signal NOC_DATA_EN   : std_logic                      := '0';
  signal NOC_WRITE_REQ : std_logic                      := '0';
  signal IO_WRITE_ACK  : std_logic                      := '0';
  signal FIFO_READY_1  : std_logic                      := '0';
  signal FIFO_READY_2  : std_logic                      := '0';
  signal FIFO_READY_3  : std_logic                      := '0';

  -- noc_proc
  signal noc_cnt1       : integer   := 0;
  signal CMD_ACK_int    : std_logic := '0';
  --
  signal TxFIFO_Valid_f : boolean   := false;
  signal RxFIFO_Ready_f : boolean   := false;
  --
  signal IORequest_f    : boolean   := false;


  -- clk_proc
  signal ido_buf : std_logic_vector(127 downto 0) := (others => '0');


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

      if clk_i = '0' and
        inext = '0' and
        iden = '1'
      then
        ido_buf <= ido & ido_buf(127 downto 8);
      end if;

    end if;
  end process;

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
      NOC_CMD          <= (others => '-');
      NOC_CMD_Flag_int <= '0';
      --
      TxFIFO_Valid_int <= '0';
      RxFIFO_Ready_int <= '0';
      --
      IORequest_int    <= '0';

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
            fsm       <= test1_wrio_addr;
            fsm_count <= 0;
            --
            write(l, string'("[TEST START] - Test 1"));
            writeline(output, l);
          end if;

        -------------------------------------------
        -- TEST1 - GPP writes 128 bit data to NOC
        -- Write 0x433F3B37332F2B27231F1B1778563412
        -------------------------------------------
        when test1_wrio_addr =>
          if fsm_count < 4 then
            idi   <= ionoc_cmd_address;
            ilioa <= '0';
          end if;

          if fsm_count = 3 then
            fsm_count <= 0;
            fsm       <= test1_wrio_data;
            --
            write(l, string'("GPP is writing data to NOC interface"));
            writeline(output, l);
          end if;

        when test1_wrio_data =>

          if fsm_count < 4 then
            idi   <= ionoc_cmd_address;
            ilioa <= '0';
          else
            ildout <= '0';

            if fsm_count mod 4 /= 3 then
              idi <= idi;
            elsif fsm_count < 4 then
            --
            elsif fsm_count < 8 then
              idi <= x"12";
            elsif fsm_count < 12 then
              idi <= x"34";
            elsif fsm_count < 16 then
              idi <= x"56";
            elsif fsm_count < 20 then
              idi <= x"78";
            elsif fsm_count < 68 then
              idi <= conv_std_logic_vector(fsm_count mod 256, 8);
            end if;
          end if;

          if fsm_count = 67 then
            fsm       <= test1_iowr_pollstatus;
            fsm_count <= 0;
            --
            write(l, string'("GPP has finished writing word to NOC interface: 0x"));
            write(l, string'("433F3B37332F2B27231F1B1778563412"));
            writeline(output, l);
          end if;

        when test1_iowr_pollstatus =>
          -- Poll status until word is read by noc
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(0) = '1' then
              fsm <= test2_nocrd_flag;
              --
              write(l, string'("[STATUS] Word to NOC is pending"));
              writeline(output, l);
              --
              write(l, string'("[TEST START] - Test 2"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Word to NOC not yet pending!"));
              writeline(output, l);
            end if;
          end if;

        -----------------------------------------------------
        -- TEST2 - Present 128 bit data to NOC which reads it
        -----------------------------------------------------
        when test2_nocrd_flag =>
          -- Wait for NOC to ack cmd
          if CMD_ACK_int = '1' then
            fsm <= test2_nocrd_ack;
            --
            write(l, string'("NOC is done reading word"));
            writeline(output, l);
          end if;

        when test2_nocrd_ack =>
          -- Wait for GPP to retract flag
          if GPP_CMD_Flag = '0' then
            fsm       <= test2_nocrd_pollstatus;
            fsm_count <= 0;
            --
            write(l, string'("GPP is done presenting word"));
            writeline(output, l);
          end if;

        when test2_nocrd_pollstatus =>
          -- Poll status until word is read by noc
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(0) = '0' and ido(2) = '1' then
              fsm <= test3_nocwr_data;
              --
              write(l, string'("[STATUS] Word to NOC has been read"));
              writeline(output, l);
              --
              write(l, string'("[TEST START] - Test 3"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Word to NOC not yet read!"));
              writeline(output, l);
            end if;
          end if;

        -------------------------------------------
        -- TEST3 - NOC writes 8 bit data to GPP
        -- Write 0x77
        -------------------------------------------
        when test3_nocwr_data =>
          fsm     <= test3_nocwr_flag;
          NOC_CMD <= x"77";
          --
          write(l, string'("[NOC] Presenting data to NOC interface: 0x"));
          write(l, string'("77"));
          writeline(output, l);

        when test3_nocwr_flag =>
          NOC_CMD_Flag_int <= '1';
          NOC_CMD          <= x"77";
          if GPP_CMD_ACK_int = '1' then
            fsm <= test3_nocwr_ack;
            --
            write(l, string'("Interface ACK'd 0x"));
            hwrite(l, NOC_CMD);
            writeline(output, l);
          end if;

        when test3_nocwr_ack =>
          if GPP_CMD_ACK_int = '0' then
            fsm       <= test4_iord_pollstatus_set;
            fsm_count <= 0;
            --
            write(l, string'("NOC is done writing byte"));
            writeline(output, l);
            --
            write(l, string'("[TEST START] - Test 4"));
            writeline(output, l);
          end if;

        -------------------------------------------
        -- TEST4 - GPP reads 8 bit data from NOC
        -- Expect 0x77
        -------------------------------------------
        when test4_iord_pollstatus_set =>
          -- Poll status until byte is written by NOC
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(1) = '1' then
              fsm <= test4_iord_data;
              --
              write(l, string'("[STATUS] Byte to GPP is pending"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Byte to GPP not yet pending!"));
              writeline(output, l);
            end if;
          end if;

        when test4_iord_data =>
          --
          if fsm_count < 4 then
            idi   <= ionoc_cmd_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            fsm       <= test4_iord_pollstatus_reset;
            write(l, string'("[GPP] Read 0x"));
            hwrite(l, ido);
            writeline(output, l);
            --
            write(l, string'("Waiting for idle status (no longer pending)"));
            writeline(output, l);
          end if;

        when test4_iord_pollstatus_reset =>
          -- Poll status until there is nothing for the GPP
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(1 downto 0) = "00" then  -- Or just bit 1
              fsm <= test5_write_fifo_data_fr_noc;
              for b in 0 to 15 loop
                TxFIFO_Data(8*b + 7 downto 8*b) <=
                  conv_std_logic_vector(17 * b+1, 8);
              end loop;
              --
              write(l, string'("[STATUS] Byte to GPP is not pending"));
              writeline(output, l);
              --
              write(l, string'("[TEST START] - Test 5"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Byte to GPP is still pending!"));
              writeline(output, l);
            end if;
          end if;

        -------------------------------------------
        -- TEST5 - Write FIFO data from NOC
        --
        -------------------------------------------
        when test5_write_fifo_data_fr_noc =>
          --
          TxFIFO_Valid_int <= '1';
          if TxFIFO_Valid_int = '0' then
            write(l, string'("[NOC] Presenting data to TxFIFO: 0x"));
            hwrite(l, TxFIFO_Data);
            writeline(output, l);
          end if;
          --
          if TxFIFO_Valid_int = '1' and TxFIFO_Valid_f then
            if fsm_count = 1-1 then     -- nr_of_words - 1
              TxFIFO_Valid_int <= '0';
              --
              fsm              <= test5_pollstatus_set;
              fsm_count        <= 0;
              --
              write(l, string'("[TxFIFO] Data accepted"));
              writeline(output, l);
            end if;
          else
            fsm_count <= fsm_count;     -- Keep
          end if;

        when test5_pollstatus_set =>
          -- Poll status until byte is available to the RxFIFO
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(7) = '1' then
              fsm <= test6_write_fifo_data_fr_gpp1;
              --
              write(l, string'("[STATUS] TxFIFO Data from NOC is pending"));
              writeline(output, l);
              --
              write(l, string'("[TEST START] - Test 6"));
              writeline(output, l);
            else
              write(l, string'("WARNING: TxFIFO Data from NOC not yet pending!"));
              writeline(output, l);
            end if;
          end if;

        -------------------------------------------
        -- TEST6 - Write FIFO data from GPP
        --
        -------------------------------------------
        when test6_write_fifo_data_fr_gpp1 =>
          if fsm_count < 4 then
            idi   <= ionoc_data_address;
            ilioa <= '0';
          end if;

          if fsm_count = 3 then
            fsm_count <= 0;
            fsm       <= test6_write_fifo_data_fr_gpp2;
            --
            write(l, string'("GPP is writing data to RxFIFO (interface buffer)"));
            writeline(output, l);
          end if;

        when test6_write_fifo_data_fr_gpp2 =>
          ildout <= '0';
          if fsm_count = 0 then
            idi <= x"11";
          elsif fsm_count mod 4 /= 3 then
            idi <= idi;
          elsif fsm_count < 4 then
            idi <= x"22";
          elsif fsm_count < 8 then
            idi <= x"33";
          elsif fsm_count < 12 then
            idi <= x"44";
          elsif fsm_count < 64 then
            idi <= conv_std_logic_vector((fsm_count / 4) * 17 + 34, 8);
          end if;

          if fsm_count = 63 then
            fsm       <= test6_pollstatus_set;
            fsm_count <= 0;
            --
            write(l, string'("GPP has finished writing data to interface: 0x"));
            hwrite(l, RxFIFO_Data);
            writeline(output, l);
          --
          --write(l, string'("Waiting for RxFIFO to read data from interface"));
          --writeline(output, l);
          end if;

        when test6_pollstatus_set =>
          -- Poll status until byte is available to the RxFIFO
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(6) = '1' then
              fsm <= test6_read_fifo_data;
              --
              write(l, string'("[STATUS] Data to RxFIFO is pending"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Data to RxFIFO not yet pending!"));
              writeline(output, l);
            end if;
          end if;

        when test6_read_fifo_data =>
          RxFIFO_Ready_int <= '1';
          if RxFIFO_Ready_f then
            fsm              <= test6_pollstatus_reset;
            RxFIFO_Ready_int <= '0';
            --
            write(l, string'("[RxFIFO] Data accepted"));
            writeline(output, l);
          end if;

        when test6_pollstatus_reset =>
          -- Poll status until there is nothing for the RxFIFO
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(6) = '0' then
              fsm <= test7_read_fifo_data_to_gpp;
              --
              write(l, string'("[STATUS] Data to RxFIFO is no longer pending"));
              writeline(output, l);
              --
              write(l, string'("[TEST START] - Test 7"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Data to RxFIFO is still pending!"));
              writeline(output, l);
            end if;
          end if;

        -------------------------------------------
        -- TEST7 - Read FIFO data to GPP
        --
        -------------------------------------------
        when test7_read_fifo_data_to_gpp =>
          if fsm_count = 0 then
            write(l, string'("GPP is reading data from interface buffer (from TxFIFO)"));
            writeline(output, l);
          end if;

          if fsm_count < 4 then
            idi   <= ionoc_data_address;
            ilioa <= '0';
          else
            inext <= '0';
          -- TODO Combine and print bytes
          end if;

          if fsm_count = 67 then
            fsm       <= test7_pollstatus_reset;
            fsm_count <= 0;
            --
            write(l, string'("GPP has finished reading data from the interface: 0x"));
            hwrite(l, ido_buf);
            writeline(output, l);
          end if;

        when test7_pollstatus_reset =>
          -- Poll status until there is nothing for the RxFIFO
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else                          -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(7) = '0' then
              fsm <= test8_read_fifo_data_to_noc;
              --
              write(l, string'("[STATUS] Data to GPP from TxFIFO is no longer pending"));
              writeline(output, l);
              --
              write(l, string'("[TEST START] - Test 8"));
              writeline(output, l);
            else
              write(l, string'("WARNING: Data from TxFIFO is still pending!"));
              writeline(output, l);
            end if;
          end if;

        -------------------------------------------
        -- TEST8 - Read RxFIFO data to NOC
        --
        -------------------------------------------
        when test8_read_fifo_data_to_noc =>
          fsm <= test9_issue_request;
          write(l, string'("Test 8 is on hold until FIFO RTL is available"));
          writeline(output, l);
          --
          write(l, string'("[TEST START] - Test 9"));
          writeline(output, l);

        -------------------------------------------
        -- TEST9 - Send IO request to adapter
        --
        -------------------------------------------
        when test9_issue_request =>
          IORequest_int <= '1';
          --
          NOC_ADDRESS   <= x"1234_8765";
          NOC_LENGTH    <= x"1337";
          NOC_DATA_DIR  <= '1';
          --
          if IORequest_f then
            fsm <= test9_request_processed;
            --
            write(l, string'("NOC is requesting IO operation"));
            writeline(output, l);
          end if;

        when test9_request_processed =>
          if not IORequest_f then
            fsm       <= test10_pollstatus_Set;
            fsm_count <= 0;
            --
            write(l, string'("NOC IO operation completed"));
            writeline(output, l);
            --
            write(l, string'("[TEST START] - Test 10"));
            writeline(output, l);
          end if;

        when test10_pollstatus_Set =>
          -- Poll status until word is read by noc
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(3) = '1' then
              fsm <= test10_read_io_request_to_gpp_1;
              --
              write(l, string'("[STATUS] IO Request from NOC is pending"));
              writeline(output, l);
            else
              assert false report "IO Request not visible to IO bus!" severity failure;
            end if;
          end if;

        when test10_read_io_request_to_gpp_1 =>
          if fsm_count = 0 then
            write(l, string'("GPP is reading IO request from interface buffer (address)"));
            writeline(output, l);
          end if;

          if fsm_count < 4 then
            idi   <= ionoc_addr_address;
            ilioa <= '0';
          else
            inext <= '0';
          -- TODO Combine and print bytes
          end if;

          if fsm_count = 5+4*4 then
            fsm       <= test10_read_io_request_to_gpp_2;
            fsm_count <= 0;
            --
            write(l, string'("GPP has finished reading data from the interface: 0x"));
            hwrite(l, ido_buf(127 downto 127-31));
            writeline(output, l);
          end if;

        when test10_read_io_request_to_gpp_2 =>
          if fsm_count = 0 then
            write(l, string'("GPP is reading IO request from interface buffer (length)"));
            writeline(output, l);
          end if;

          if fsm_count < 4 then
            idi   <= ionoc_length_address;
            ilioa <= '0';
          else
            inext <= '0';
          -- TODO Combine and print bytes
          end if;

          if fsm_count = 5+4*2 then
            fsm       <= test10_read_io_request_to_gpp_3;
            fsm_count <= 0;
            --
            write(l, string'("GPP has finished reading data from the interface: 0x"));
            hwrite(l, ido_buf(127 downto 127-15));
            writeline(output, l);
          end if;

        when test10_read_io_request_to_gpp_3 =>
          if fsm_count = 0 then
            write(l, string'("GPP is reading IO request from interface buffer (data direction)"));
            writeline(output, l);
          end if;

          if fsm_count < 4 then
            idi   <= ionoc_datadir_address;
            ilioa <= '0';
          else
            inext <= '0';
          -- TODO Combine and print bytes
          end if;

          if fsm_count = 5+8*1 then
            fsm       <= test10_pollstatus_reset;
            fsm_count <= 0;
            --
            write(l, string'("GPP has finished reading data from the interface: 0x"));
            hwrite(l, ido_buf(127 downto 127-7));
            writeline(output, l);
          end if;

        when test10_pollstatus_reset =>
          -- Poll status until there is nothing for the RxFIFO
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(3) = '0' then
              fsm <= wait_done;
              --
              write(l, string'("[STATUS] IO Request is no longer pending"));
              writeline(output, l);
            --
            --write(l, string'("[TEST START] - Test 11"));
            --writeline(output, l);
            else
              write(l, string'("WARNING: Request is still pending!"));
              writeline(output, l);
            end if;
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
      NOC_CMD_ACK   <= '0';
      NOC_WRITE_REQ <= '0';

      if noc_cnt1 < 32 then
        noc_cnt1 <= noc_cnt1 + 1;
      else
        CMD_ACK_int <= '0';
      end if;

      -- GPP acks command from NOC
      if GPP_CMD_ACK = '1' then
        NOC_CMD_Flag    <= '0';
        GPP_CMD_ACK_int <= '1';
      elsif NOC_CMD_Flag_int = '1' then
        if GPP_CMD_ACK_int = '0' then
          NOC_CMD_Flag <= '1';
        end if;
      elsif NOC_CMD_Flag_int = '0' then
        GPP_CMD_ACK_int <= '0';
      end if;

      -- NOC acks command from GPP
      if GPP_CMD_Flag = '1' and
        NOC_CMD_ACK = '0' then
        if noc_cnt1 = 0 then
          noc_cnt1    <= 0;
          NOC_CMD_ACK <= '1';
          CMD_ACK_int <= '1';           -- int flag to other part of TB
          --
          write(l, string'("[NOC] Got command from GPP 0x"));
          hwrite(l, GPP_CMD);
          writeline(output, l);
        else
          noc_cnt1 <= noc_cnt1 - 1;
        end if;
      end if;

      -- Check that GPP retracts CMD Flag
      if GPP_CMD_Flag = '1' and
        NOC_CMD_ACK = '1' then
        if noc_cnt1 /= 0 then
          write(l, string'("[NOC] WARNING GPP_CMD_Flag expexted low"));
          writeline(output, l);
        end if;
      end if;

      -----------------------------------------------------------------------

      if RxFIFO_Ready_int = '1' and not RxFIFO_Ready_f then
        RxFIFO_Ready_f <= true;
        RxFIFO_Ready   <= '1';
      end if;

      if RxFIFO_Ready = '1' and RxFIFO_Valid = '1' then
        RxFIFO_Ready <= '0';
      end if;

      if RxFIFO_Ready_int = '0' and RxFIFO_Ready_f then
        RxFIFO_Ready_f <= false;
      end if;

      -----------------------------------------------------------------------

      if TxFIFO_Valid_int = '1' and not TxFIFO_Valid_f then
        TxFIFO_Valid_f <= true;
        TxFIFO_Valid   <= '1';
      end if;

      if TxFIFO_Ready = '1' and TxFIFO_Valid = '1' then
        TxFIFO_Valid <= '0';
      end if;

      if TxFIFO_Valid_int = '0' and TxFIFO_Valid_f then
        TxFIFO_Valid_f <= false;
      end if;

      -----------------------------------------------------------------------

      if IORequest_int = '1' and not IORequest_f then
        IORequest_f <= true;
      end if;
      --
      if IORequest_int = '0' and IORequest_f then
        NOC_WRITE_REQ <= '1';
      end if;
      --
      if NOC_WRITE_REQ = '1' and IO_WRITE_ACK = '0' then
        NOC_WRITE_REQ <= '1';
      end if;
      --
      if IO_WRITE_ACK = '1' then
        IORequest_f   <= false;
        NOC_WRITE_REQ <= '0';
      end if;

    end if;  -- clk_noc
  end process;  -- noc_proc

  DUT : ionoc
    generic map (
      ionoc_status_address  => ionoc_status_address,
      ionoc_cmd_address     => ionoc_cmd_address,
      ionoc_data_address    => ionoc_data_address,
      ionoc_addr_address    => ionoc_addr_address,
      ionoc_length_address  => ionoc_length_address,
      ionoc_datadir_address => ionoc_datadir_address)
    port map (
      clk_p          => clk_p,
      clk_i_pos      => clk_i,
      rst_n          => reset_n,
      idi            => idi,
      ido            => ido,
      iden           => iden,
      ilioa          => ilioa,
      ildout         => ildout,
      inext          => inext,
      idack          => idack,
      idreq          => idreq,
      NOC_IRQ        => NOC_IRQ,
      --
      clk_noc        => clk_noc,
      GPP_CMD        => GPP_CMD,
      GPP_CMD_Flag   => GPP_CMD_Flag,
      NOC_CMD_ACK    => NOC_CMD_ACK,
      NOC_CMD        => NOC_CMD,
      GPP_CMD_ACK    => GPP_CMD_ACK,
      NOC_CMD_Flag   => NOC_CMD_Flag,
      TxFIFO_Ready   => TxFIFO_Ready,
      TxFIFO_Valid   => TxFIFO_Valid,
      TxFIFO_Data    => TxFIFO_Data,
      RxFIFO_Ready   => RxFIFO_Ready,
      RxFIFO_Valid   => RxFIFO_Valid,
      RxFIFO_Data    => RxFIFO_Data,
      NOC_ADDRESS    => NOC_ADDRESS,
      NOC_LENGTH     => NOC_LENGTH,
      NOC_DATA_DIR   => NOC_DATA_DIR,
      NOC_WRITE_REQ  => NOC_WRITE_REQ,
      IO_WRITE_ACK   => IO_WRITE_ACK
      );

end tb;
