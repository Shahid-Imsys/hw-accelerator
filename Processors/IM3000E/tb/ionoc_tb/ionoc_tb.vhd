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
    ionoc_data_address   : std_logic_vector(7 downto 0) := x"46";
    MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
    );
end entity;

architecture tb of ionoc_tb is

  component ionoc is
    generic (
      ionoc_status_address : std_logic_vector(7 downto 0) := x"45";
      ionoc_data_address   : std_logic_vector(7 downto 0) := x"46";
      MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
      );
    port (clk_p        : in  std_logic;  -- Main clock
          clk_i_pos    : in  std_logic;  --
          rst_n        : in  std_logic;  -- Async reset
          -- I/O bus
          idi          : in  std_logic_vector (7 downto 0);   -- I/O bus in
          ido          : out std_logic_vector (7 downto 0);   -- I/O bus out
          iden         : out std_logic;  -- I/O bus enabled (in use)
          ilioa        : in  std_logic;  -- I/O bus load I/O address
          ildout       : in  std_logic;  -- I/O bus data output strobe
          inext        : in  std_logic;  -- I/O bus data input  strobe
          idack        : in  std_logic;  -- I/O bus DMA Ack
          idreq        : out std_logic;  -- I/O bus DMA Request
          -- GPP to NOC
          GPP_CMD      : out std_logic_vector(127 downto 0);  -- Command word
          GPP_CMD_Flag : out std_logic;  -- Command word valid
          NOC_CMD_ACK  : in  std_logic;  -- NOC ready
          -- NOC to GPP
          NOC_CMD      : in  std_logic_vector(7 downto 0); -- Command byte
          GPP_CMD_ACK  : out std_logic;                    -- GPP ready
          NOC_CMD_Flag : in  std_logic;                    -- NOC asks to send byte
          NOC_CMD_EN   : in  std_logic;                    -- Command byte valid
          --
          TxFIFO_Ready : out std_logic;                      -- Interface can accept a word from the TxIFO
          TxFIFO_Valid : in  std_logic;                      -- TxFIFO has availble data which is presented on bus
          TxFIFO_Data  : in  std_logic_vector(127 downto 0); -- TxFIFO data
          --
          RxFIFO_Ready : in  std_logic;                      -- RxFIFO can accept a word from the IO-bus
          RxFIFO_Valid : out std_logic;                      -- Interface has availble data which is presented on bus
          RxFIFO_Data  : out std_logic_vector(127 downto 0); -- RxFIFO data
          --
          NOC_IRQ      : out std_logic                     -- Interrupt on available data from NOC
          );
  end component;

  -- Types
  type fsm_t is (
    reset,
    init,
    send_cmd,
    write_data,
    poll_done1,
    req_gpp_access,
    poll_done2,
    read_data,
    poll_done3,
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
  signal NOC_CMD_EN   : std_logic                    := '0';

  signal GPP_CMD      : std_logic_vector(127 downto 0);
  signal GPP_CMD_Flag : std_logic;
  signal GPP_CMD_ACK  : std_logic;
  signal NOC_IRQ      : std_logic;

  signal TxFIFO_Valid : std_logic;
  signal RxFIFO_Ready : std_logic;
  signal TxFIFO_Data  : std_logic_vector(127 downto 0);
  --
  signal TxFIFO_Ready : std_logic                      := '0';
  signal RxFIFO_Valid : std_logic                      := '0';
  signal RxFIFO_Data  : std_logic_vector(127 downto 0) := (others => '0');

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
      idi    <= x"00";
      ilioa  <= '1';
      ildout <= '1';
      inext  <= '1';
      idack  <= '1';
      --
      NOC_CMD_ACK <= '0';
      NOC_CMD_EN  <= '0';
      NOC_CMD     <= (others => '-');
      --
      if GPP_CMD_ACK = '1' then
        NOC_CMD_Flag <= '0';
      end if;

      -- Delays
      fsm_d <= fsm;

      -- Reset data_count each new state
      fsm_count <= fsm_count + 1;

      case fsm is
        when done =>
          if fsm_count = 32 then
            run <= '0';
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
            fsm       <= send_cmd;
            fsm_count <= 0;
          end if;

        when send_cmd =>
          if fsm_count < 4 then
            idi   <= ionoc_data_address;
            ilioa <= '0';
          end if;

          if fsm_count = 3 then
            fsm_count <= 0;
            fsm       <= write_data;
            write(l, string'("IO bus is writing data to NOC interface"));
            writeline(output, l);
          end if;

        when write_data =>

          if fsm_count < 4 then
            idi   <= ionoc_data_address;
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
            fsm       <= poll_done1;
            write(l, string'("Waiting for NOC to read command word"));
            writeline(output, l);
            fsm_count <= 0;
          end if;

        when poll_done1 =>
          -- Poll status until word is read by noc
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if GPP_CMD_Flag = '1' and NOC_CMD_ACK = '1' then
            fsm <= req_gpp_access;
            write(l, string'("IO bus is waiting for NOC to present byte response"));
            writeline(output, l);
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            NOC_CMD_ACK <= '1';
            write(l, string'("NOC_CMD_ACK high"));
            writeline(output, l);
          end if;

        when req_gpp_access =>
          NOC_CMD_Flag <= '1';

          if GPP_CMD_ACK = '1' then
            fsm <= poll_done2;
            write(l, string'("GPP will accept NOC comand byte"));
            writeline(output, l);
          end if;

        when poll_done2 =>
          -- Poll status until NOC has byte for GPP
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(1) = '1' then
              fsm <= read_data;
              write(l, string'("Reading NOC byte"));
              writeline(output, l);
            else
              NOC_CMD_EN <= '1';
              NOC_CMD    <= x"77";
              write(l, string'("NOC flags byte available"));
              writeline(output, l);
            end if;
          end if;

        when read_data =>
          --
          if fsm_count < 4 then
            idi   <= ionoc_data_address;
            ilioa <= '0';
          else -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            fsm <= poll_done3;
            write(l, string'("IO-bus got 0x"));
            hwrite(l, ido );
            writeline(output, l);

            write(l, string'("Waiting to idle status"));
            writeline(output, l);
          end if;

        when poll_done3 =>
          -- Poll status until there is nothing for the GPP
          if fsm_count < 4 then
            idi   <= ionoc_status_address;
            ilioa <= '0';
          else -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(1 downto 0) = "00" then
              fsm <= wait_done;
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
      NOC_CMD_EN   => NOC_CMD_EN,
      TxFIFO_Ready => TxFIFO_Ready,
      TxFIFO_Valid => TxFIFO_Valid,
      TxFIFO_Data  => TxFIFO_Data,
      RxFIFO_Ready => RxFIFO_Ready,
      RxFIFO_Valid => RxFIFO_Valid,
      RxFIFO_Data  => RxFIFO_Data,
      NOC_IRQ      => NOC_IRQ);

end tb;
