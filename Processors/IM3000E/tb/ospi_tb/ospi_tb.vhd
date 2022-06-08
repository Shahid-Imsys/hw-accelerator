library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

use std.textio.all;

use work.gp_pkg.all;

entity ospi_tb is
  generic (
    ospi_cmd_address     : std_logic_vector(7 downto 0) := x"40";
    ospi_addr_address    : std_logic_vector(7 downto 0) := x"41";
    ospi_data_address    : std_logic_vector(7 downto 0) := x"42";
    ospi_flags_address   : std_logic_vector(7 downto 0) := x"43";
    ospi_latency_address : std_logic_vector(7 downto 0) := x"44";
    MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
    );
end entity;

architecture tb of ospi_tb is

  component OctoSPI is
    generic (
      ospi_cmd_address     : std_logic_vector(7 downto 0) := x"40";
      ospi_addr_address    : std_logic_vector(7 downto 0) := x"41";
      ospi_data_address    : std_logic_vector(7 downto 0) := x"42";
      ospi_flags_address   : std_logic_vector(7 downto 0) := x"43";
      ospi_latency_address : std_logic_vector(7 downto 0) := x"44";
      MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
      );
    port (clk_p     : in    std_logic;  -- Main clock
          clk_i_pos : in    std_logic;  --
          rst_n     : in    std_logic;  -- Async reset
          idi       : in    std_logic_vector (7 downto 0);      -- I/O bus in
          ido       : out   std_logic_vector (7 downto 0);      -- I/O bus out
          iden      : out   std_logic;  -- I/O bus enabled (in use)
          ilioa     : in    std_logic;  -- I/O bus Load IO address
          ildout    : in    std_logic;  -- I/O bus data output strobe
          inext     : in    std_logic;  -- I/O bus data input  strobe
          idack     : in    std_logic;  -- I/O bus DMA Ack
          idreq     : out   std_logic;  -- I/O bus DMA Request
          OSPI_Out  : out   OSPI_InterfaceOut_t;  -- OSPI pins out to chip
          OSPI_DQ   : inout std_logic_vector(7 downto 0);
          OSPI_RWDS : inout std_logic   -- OSPI pins in/out from/to chip
          );
  end component;

  -- Types
  type fsm_t is (
    reset,
    init,
    send_flags,
    send_addr,
    send_data,
    send_latency,
    send_cmd,
    read_data,
    write_data,
    poll_done,
    done);

  -- Constants
  constant RW_READ  : std_logic_vector(7 downto 0) := x"00";
  constant RW_WRITE : std_logic_vector(7 downto 0) := x"20";
  --
  constant LEN_0B   : std_logic_vector(7 downto 0) := x"00";
  constant LEN_2B   : std_logic_vector(7 downto 0) := x"08";
  constant LEN_16B  : std_logic_vector(7 downto 0) := x"18";
  constant LEN_32B  : std_logic_vector(7 downto 0) := x"1C";
  constant LEN_64B  : std_logic_vector(7 downto 0) := x"14";
  constant LEN_128B : std_logic_vector(7 downto 0) := x"10";
--
  constant INC_DISABLED : std_logic_vector(7 downto 0) := x"00";
  constant INC_ENABLED  : std_logic_vector(7 downto 0) := x"02";


  -- TB SETTINGS
  constant ACCESSS_RW  : std_logic_vector(7 downto 0) := RW_WRITE;
  constant ACCESSS_LEN : std_logic_vector(7 downto 0) := LEN_0B;
  constant ACCESSS_INC : std_logic_vector(7 downto 0) := INC_ENABLED;

  constant OSPI_LATENCY : integer := 7;

  -- Concurrent statementes
  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  --

  -- test_proc
  signal run       : std_logic := '1';
  signal fsm       : fsm_t     := reset;
  signal fsm_d     : fsm_t     := reset;
  signal fsm_count : integer   := 0;

  signal OSPI_Out_d    : OSPI_InterfaceOut_t;
  signal OSPI_ClkCount : integer := 0;
  --
  signal clk_count  : std_logic_vector(7 downto 0) := x"00";
  signal clk_i      : std_logic                    := '0';
  --
  signal idi        : std_logic_vector (7 downto 0);
  signal ilioa      : std_logic;
  signal ildout     : std_logic;
  signal inext      : std_logic;
  signal idack      : std_logic;
  signal idreq      : std_logic;


  -- DUT
  signal ido       : std_logic_vector (7 downto 0);
  signal iden      : std_logic;
  signal OSPI_Out  : OSPI_InterfaceOut_t;
  signal OSPI_DQ   : std_logic_vector(7 downto 0);
  signal OSPI_RWDS : std_logic;

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
      idi       <= x"00";
      ilioa     <= '1';
      ildout    <= '1';
      inext     <= '1';
      idack     <= '1';
      --
      OSPI_DQ    <= (others => 'Z');     -- Chip does not drive by default
      OSPI_RWDS  <= 'Z';
      OSPI_Out_d <= OSPI_Out;
      --

      -- Delays
      fsm_d <= fsm;

      -- Reset data_count each new state
      fsm_count <= fsm_count + 1;

      if OSPI_Out.CK_p /= OSPI_Out_d.CK_p then
        OSPI_ClkCount <= OSPI_ClkCount + 1;
      end if;

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
            fsm       <= send_flags;
            fsm_count <= 0;
          end if;

        when send_flags =>
          if fsm_count < 4 then
            idi   <= ospi_flags_address;
            ilioa <= '0';
          elsif fsm_count < 8 then
            idi       <= ACCESSS_RW or ACCESSS_LEN or ACCESSS_INC;
            ildout    <= '0';
          end if;

          if fsm_count = 7 then
            fsm       <= send_latency;
            fsm_count <= 0;
          end if;

        when send_latency =>
          if fsm_count < 4 then
            idi   <= ospi_latency_address;
            ilioa <= '0';
          elsif fsm_count < 8 then
            idi       <= std_logic_vector(to_unsigned( OSPI_LATENCY, 8 ) );
            ildout    <= '0';
          end if;

          if fsm_count = 7 then
            fsm       <= send_addr;
            fsm_count <= 0;
          end if;

        when send_addr =>
          if fsm_count < 4 then
            idi   <= ospi_addr_address;
            ilioa <= '0';
          elsif fsm_count < 8 then
            idi    <= x"19";
            ildout <= '0';
          elsif fsm_count < 12 then
            idi    <= x"80";
            ildout <= '0';
          elsif fsm_count < 16 then
            idi    <= x"01";
            ildout <= '0';
          elsif fsm_count < 20 then
            idi       <= x"22";
            ildout    <= '0';
          end if;

          if fsm_count = 19 then
            fsm       <= send_data;
            fsm_count <= 0;
          end if;

        when send_cmd =>
          if fsm_count < 4 then
            idi   <= ospi_cmd_address;
            ilioa <= '0';
          elsif fsm_count < 8 then
            idi       <= x"77";
            ildout    <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ACCESSS_RW = RW_READ then
              fsm <= read_data;
            -- elsif ACCESSS_RW = RW_READ then
            else
              fsm <= write_data;
            end if;
          end if;

        when send_data =>
          if fsm_count < 4 then
            idi   <= ospi_data_address;
            ilioa <= '0';
          elsif fsm_count < 8 then
            idi    <= x"12";
            ildout <= '0';
          elsif fsm_count < 12 then
            idi    <= x"34";
            ildout <= '0';
          elsif fsm_count < 16 then
            idi    <= x"56";
            ildout <= '0';
          elsif fsm_count < 20 then
            idi       <= x"78";
            ildout    <= '0';
          end if;

          if fsm_count = 19 then -- TODO Poll done flag
            fsm       <= send_cmd;
            fsm_count <= 0;
          end if;

        when read_data =>                         -- + ACCESSS_LEN
          if OSPI_ClkCount > 2*(1 + 2 + OSPI_LATENCY + 1 ) + 1 then -- Fixed data len of 1x2 bytes [TODO make dynamic]
            OSPI_DQ   <= std_logic_vector(to_unsigned(fsm_count / 4, 8));
            fsm       <= poll_done;
            fsm_count <= 0;

          elsif OSPI_ClkCount > 2*(1 + 2 + OSPI_LATENCY) then
            OSPI_DQ <= std_logic_vector(to_unsigned(fsm_count / 4, 8));
            if fsm_count mod 8 < 4 then
              OSPI_RWDS <= '0';
            else
              OSPI_RWDS <= '1';
            end if;

          else
            fsm_count <= 0;
          end if;

        when write_data =>
          if OSPI_ClkCount > 2*(1 + 2 + OSPI_LATENCY + 1 ) + 1 then -- Fixed data len of 1x2 bytes [TODO make dynamic]
            -- <= OSPI_DQ; -- Ignore incomming data
            fsm       <= poll_done;
            fsm_count <= 0;
          end if;

        when poll_done =>

          -- Poll flag
          if fsm_count < 4 then
            idi   <= ospi_flags_address;
            ilioa <= '0';
          else -- if fsm_count < 8 then
            inext <= '0';
          end if;

          if fsm_count = 7 then
            fsm_count <= 0;
            if ido(0) = '1' then
              fsm <= done;
            end if;
          end if;

        when others =>
          --

      end case;

    end if;
  end process;

  DUT : OctoSPI
    generic map (
      ospi_cmd_address     => ospi_cmd_address,
      ospi_addr_address    => ospi_addr_address,
      ospi_data_address    => ospi_data_address,
      ospi_flags_address   => ospi_flags_address,
      ospi_latency_address => ospi_latency_address,
      MAX_BURST_LEN        => MAX_BURST_LEN
      )
    port map (clk_p     => clk,
              clk_i_pos => clk_i,
              rst_n     => reset_n,
              idi       => idi,
              ido       => ido,
              iden      => iden,
              ilioa     => ilioa,
              ildout    => ildout,
              inext     => inext,
              idack     => idack,
              idreq     => idreq,
              OSPI_Out  => OSPI_Out,
              OSPI_DQ   => OSPI_DQ,
              OSPI_RWDS => OSPI_RWDS
              );

end tb;
