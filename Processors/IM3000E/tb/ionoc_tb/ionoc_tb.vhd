library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_textio.all;

use std.textio.all;

use work.gp_pkg.all;

entity ionoc_tb is
  generic (
    ionoc_status_address : std_logic_vector(7 downto 0) := x"45";
    ionoc_cmd_address    : std_logic_vector(7 downto 0) := x"46";
    ionoc_data_address   : std_logic_vector(7 downto 0) := x"47";
    MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
    );
end entity;

architecture tb of ionoc_tb is

  component ionoc is
    generic (
      ionoc_status_address : std_logic_vector(7 downto 0) := x"45";
      ionoc_cmd_address    : std_logic_vector(7 downto 0) := x"46";
      ionoc_data_address   : std_logic_vector(7 downto 0) := x"47";
      MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
      );
    port (clk_p        : in  std_logic;  -- Main clock
          clk_i_pos    : in  std_logic;  --
          rst_n        : in  std_logic;  -- Async reset
          -- I/O bus
          idi          : in  std_logic_vector (7 downto 0);     -- I/O bus in
          ido          : out std_logic_vector (7 downto 0);     -- I/O bus out
          iden         : out std_logic;  -- I/O bus enabled (in use)
          ilioa        : in  std_logic;  -- I/O bus load I/O address
          ildout       : in  std_logic;  -- I/O bus data output strobe
          inext        : in  std_logic;  -- I/O bus data input  strobe
          idack        : in  std_logic;  -- I/O bus DMA Ack
          idreq        : out std_logic;  -- I/O bus DMA Request
          -- GPP to NOC
          GPP_CMD      : out std_logic_vector(127 downto 0);    -- Command word
          GPP_CMD_Flag : out std_logic;  -- Command word valid
          NOC_CMD_ACK  : in  std_logic;  -- NOC ready
          -- NOC to GPP
          NOC_CMD      : in  std_logic_vector(7 downto 0);      -- Command byte
          GPP_CMD_ACK  : out std_logic;  -- GPP ready
          NOC_CMD_Flag : in  std_logic;  -- NOC asks to send byte
          --
          TxFIFO_Ready : out std_logic;  -- Interface can accept a word from the TxIFO
          TxFIFO_Valid : in  std_logic;  -- TxFIFO has availble data which is presented on bus
          TxFIFO_Data  : in  std_logic_vector(127 downto 0);    -- TxFIFO data
          --
          RxFIFO_Ready : in  std_logic;  -- RxFIFO can accept a word from the IO-bus
          RxFIFO_Valid : out std_logic;  -- Interface has availble data which is presented on bus
          RxFIFO_Data  : out std_logic_vector(127 downto 0);    -- RxFIFO data
          --
          NOC_IRQ      : out std_logic  -- Interrupt on available data from NOC
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
    wait_done,
    done);

  -- Constants


  -- TB SETTINGS

  -- Concurrent statementes
  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  --

  -- test_proc
  signal run       : std_logic := '1';
  signal fsm       : fsm_t     := reset;
  signal fsm_d     : fsm_t     := reset;
  signal fsm_count : integer   := 0;

  signal clk_count : std_logic_vector(7 downto 0) := x"00";
  signal clk_i     : std_logic                    := '0';
  --
  signal idi       : std_logic_vector (7 downto 0);
  signal ilioa     : std_logic;
  signal ildout    : std_logic;
  signal inext     : std_logic;
  signal idack     : std_logic;
  signal idreq     : std_logic;


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

  signal TxFIFO_Ready : std_logic;
  signal TxFIFO_Valid : std_logic;
  signal TxFIFO_Data  : std_logic_vector(127 downto 0) := (others => '0');
  --
  signal RxFIFO_Ready : std_logic                      := '0';
  signal RxFIFO_Valid : std_logic;
  signal RxFIFO_Data  : std_logic_vector(127 downto 0);

  -- Constants
  constant clock_frequency_c : real := 300.0;  --MHz
  constant clock_period_c    : time := 1 us / clock_frequency_c;

begin

  clk     <= run and not clk after clock_period_c/2;
  reset_n <= '1'             after 10 * clock_period_c;

  clk_proc : process(clk)
  begin
    if rising_edge(clk) then
      --
      clk_count <= std_logic_vector(unsigned(clk_count) + 1);
      --
      if clk_count(1 downto 0) = "11" then
        clk_i <= '0';
      else
        clk_i <= '1';
      end if;
    end if;
  end process;

  test_proc : process(clk)
    variable l   : line;
    variable row : integer := 0;
  begin

    if rising_edge(clk) then
      -- Defaults
      idi          <= x"00";
      ilioa        <= '1';
      ildout       <= '1';
      inext        <= '1';
      idack        <= '1';
      --
      NOC_CMD_ACK  <= '0';
      NOC_CMD      <= (others => '-');
      --
      TxFIFO_Valid <= '0';
      RxFIFO_Ready <= '0';
      --
      NOC_CMD_Flag <= '0';

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
          if GPP_CMD_Flag = '1' then
            fsm         <= test2_nocrd_ack;
            NOC_CMD_ACK <= '1';
            --
            write(l, string'("[NOC] Read 0x"));
            hwrite(l, GPP_CMD);
            writeline(output, l);
          end if;

        when test2_nocrd_ack =>
          NOC_CMD_ACK <= '1';
          if GPP_CMD_Flag = '0' then
            fsm <= test2_nocrd_pollstatus;
            --
            write(l, string'("NOC is done reading word"));
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
              --
            else
              write(l, string'("WARNING: Word to NOC not yet pending!"));
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
          NOC_CMD_Flag <= '1';
          NOC_CMD      <= x"77";
          if GPP_CMD_ACK = '1' then
            fsm <= test3_nocwr_ack;
            --
            write(l, string'("Interface ACK'd 0x"));
            hwrite(l, NOC_CMD);
            writeline(output, l);
          end if;

        when test3_nocwr_ack =>
          if GPP_CMD_ACK = '0' then
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
          TxFIFO_Valid <= '1';
          if TxFIFO_Valid = '0' then
            write(l, string'("[NOC] Presenting data to TxFIFO"));
            writeline(output, l);
          end if;
          --
          for b in 0 to 15 loop
            TxFIFO_Data(8*b + 7 downto 8*b) <=
              conv_std_logic_vector(17 * b+1, 8);
          end loop;
          --
          if TxFIFO_Valid = '1' and TxFIFO_Ready = '1' then
            if fsm_count = 1-1 then     -- nr_of_words - 1
              TxFIFO_Valid <= '0';
              --
              fsm          <= test5_pollstatus_set;
              fsm_count    <= 0;
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
            write(l, string'("[TBD]"));
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
          if RxFIFO_Valid = '1' then
              fsm          <= test6_pollstatus_reset;
              RxFIFO_Ready <= '1';
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
            write(l, string'("[TBD]"));
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
              fsm <= wait_done;
              --
              write(l, string'("[STATUS] Data to GPP from TxFIFO is no longer pending"));
              writeline(output, l);
              --
              --write(l, string'("[TEST START] - Test 8"));
              --writeline(output, l);
            else
              write(l, string'("WARNING: Data from TxFIFO is still pending!"));
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

    end if;
  end process;

  DUT : ionoc
    generic map (
      ionoc_status_address => ionoc_status_address,
      ionoc_cmd_address    => ionoc_cmd_address,
      ionoc_data_address   => ionoc_data_address,
      MAX_BURST_LEN        => MAX_BURST_LEN)
    port map (
      clk_p        => clk,
      clk_i_pos    => clk_i,
      rst_n        => reset_n,
      idi          => idi,
      ido          => ido,
      iden         => iden,
      ilioa        => ilioa,
      ildout       => ildout,
      inext        => inext,
      idack        => idack,
      idreq        => idreq,
      GPP_CMD      => GPP_CMD,
      GPP_CMD_Flag => GPP_CMD_Flag,
      NOC_CMD_ACK  => NOC_CMD_ACK,
      NOC_CMD      => NOC_CMD,
      GPP_CMD_ACK  => GPP_CMD_ACK,
      NOC_CMD_Flag => NOC_CMD_Flag,
      TxFIFO_Ready => TxFIFO_Ready,
      TxFIFO_Valid => TxFIFO_Valid,
      TxFIFO_Data  => TxFIFO_Data,
      RxFIFO_Ready => RxFIFO_Ready,
      RxFIFO_Valid => RxFIFO_Valid,
      RxFIFO_Data  => RxFIFO_Data,
      NOC_IRQ      => NOC_IRQ);

end tb;
