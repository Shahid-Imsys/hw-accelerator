library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

entity octo_memory_bfm is

  port (
    cs      : in    std_logic;
    ck      : in    std_logic;
    rwds    : inout std_logic;
    dq      : inout std_logic_vector(7 downto 0);
    reset_n : in    std_logic);

end entity octo_memory_bfm;

architecture bfm of octo_memory_bfm is
  -- manufacturer: Cypress
  -- Nine colum address bit
  -- thirty tw row address bits.
  constant id0_register_c   : std_logic_vector(15 downto 0) := x"0C81";
  constant id1_register_c   : std_logic_vector(15 downto 0) := x"0001";
  constant cr0_init_value_c : std_logic_vector(15 downto 0) := x"012F";
  constant cr1_init_value_c : std_logic_vector(15 downto 0) := x"FFC1";

  subtype cmd_t is std_logic_vector(7 downto 0);

  constant CMD_REST_ENABLE   : cmd_t := x"66";
  constant CMD_RESET         : cmd_t := x"99";
  constant CMD_READ_ID       : cmd_t := x"9F";
  constant CMD_DEEP_PD       : cmd_t := x"B9";
  constant CMD_READ_DDR      : cmd_t := x"EE";
  constant CMD_WRITE_DDR     : cmd_t := x"DE";
  constant CMD_WRITE_ENABLE  : cmd_t := x"06";
  constant CMD_WRITE_DISABLE : cmd_t := x"04";
  constant CMD_READ_REG      : cmd_t := x"65";
  constant CMD_WRITE_REG     : cmd_t := x"71";

  signal cr0 : std_logic_vector(15 downto 0) := cr0_init_value_c;
  signal cr1 : std_logic_vector(15 downto 0) := cr1_init_value_c;

  type state_t is (command_state_1, command_state_2, get_address, latency_wait,
                   read_register, write_register, wait_on_cs,
                   read_ddr, write_ddr);
  signal state                 : state_t                      := command_state_1;
  type deep_power_down_state_t is (normal, start, power_down, ending);
  signal deep_power_down_state : deep_power_down_state_t      := normal;
  signal command               : std_logic_vector(7 downto 0) := x"00";
  signal reset_enable          : boolean                      := false;
  signal deep_power_down       : boolean                      := false;
  signal write_enable          : boolean                      := false;

  signal old_latency    : std_logic := '0';
  signal counter        : integer   := 0;
  signal latency_length : integer;
  signal address        : unsigned(31 downto 0);

  type reg_t is array (17 downto 0) of std_logic_vector(15 downto 0);
  signal reg : reg_t;

  type memory_array_t is array (1023 downto 0) of std_logic_vector(7 downto 0);
  signal memory_low  : memory_array_t;
  signal memory_high : memory_array_t;

  signal burst_length : integer := 0;

  signal found_error : boolean := false;

begin  -- architecture bfm

  assert rwds /= 'X' report "[Octo_BFM] Double driving on RWDS" severity warning;

  with cr0(7 downto 4) select latency_length <=
    5 when "0000",
    6 when "0001",
    7 when "0010",
    3 when "1110",
    4 when "1111",
    0 when others; -- Reserved!

  check_double_drive_dq : process (ck) is
    variable no_dd : boolean := true;
  begin  -- process check_double_drive_dq
    if falling_edge(ck) then
      for i in dq'range loop
        if dq(i) = 'X' then
          no_dd := false;
        end if;
      end loop;  -- i

      assert no_dd report "[Octo_BFM] Double driving on signal dq" severity warning;
    end if;
    
  end process check_double_drive_dq;

  p_deep_power_down : process (all) is
  begin  -- process s
    if (reset_n = '1') or (state = command_state_1 and command = CMD_RESET and reset_enable) then
      deep_power_down_state <= normal;
      deep_power_down       <= false;
    else
      case deep_power_down_state is
        when normal =>
          deep_power_down <= false;
          if (state = command_state_2 and command = CMD_DEEP_PD) or cr0(15) = '1' then
            deep_power_down_state <= start;
            deep_power_down       <= true;
          end if;
        when start =>
          if cs = '1' then
            deep_power_down_state <= power_down;
          end if;
        when power_down =>
          if cs = '0' then
            deep_power_down_state <= ending;
          end if;
        when ending =>
          if cs = '1' then
            deep_power_down_state <= normal;
            deep_power_down       <= false;
          end if;
      end case;

    end if;
  end process;

  burst_length <= 128 when cr0(1 downto 0) = "00" else
                  64 when cr0(1 downto 0) = "01" else
                  16 when cr0(1 downto 0) = "10" else
                  32;

  process (ck, cs, reset_n, deep_power_down) is

    procedure check_for_z is
      variable no_z : boolean := true;
    begin  -- procedure check_double_drive_dq
      for i in dq'range loop
        if dq(i) = 'Z' then
          no_z := false;
        end if;
      end loop;  -- i

      assert no_z
        report "[Octo_BFM] No drivig on DQ in state " & state_t'image(state)
        severity warning;
    end procedure check_for_z;

    variable l : line;
  begin  -- process

    found_error <= false;

    if reset_n = '0' then
      write(l, string'("[Octo_BFM] In reset"));
      writeline(output, l);
      command      <= x"00";
      reset_enable <= false;
      state        <= command_state_1;
      dq           <= (others => 'Z');
      rwds         <= 'Z';
    elsif cs = '1' then                 -- wait_on_cs state
      command <= x"00";
      state   <= command_state_1;
      if state /= command_state_1 and state /= wait_on_cs and state /= write_ddr then
        write(l, string'("[Octo_BFM] Warning, BFM in state "));
        write(l, state_t'image(state));
        write(l, string'(" when cs is high"));
        writeline(output, l);
        found_error <= true;
      end if;
      dq   <= (others => 'Z');
      rwds <= 'Z';
    elsif falling_edge(cs) then
      rwds        <= old_latency;
      old_latency <= not old_latency;
    elsif deep_power_down then
      reg <= (others => (others => 'X'));
      cr0 <= cr0_init_value_c;
    elsif ck'event and not deep_power_down then
      case state is
        when command_state_1 =>
          command <= dq;
          state   <= command_state_2;
          dq      <= (others => 'Z');
        when command_state_2 =>
          assert command = dq report "[Octo_BFM] CMD is not repeated in second byte" severity error;
          case command is
            when CMD_DEEP_PD =>
              state        <= command_state_1;
              command      <= x"00";
              reset_enable <= false;
            when CMD_REST_ENABLE =>
              reset_enable <= true;
              state        <= command_state_1;
            when CMD_RESET =>
              if reset_enable then
                write(l, string'("[Octo_BFM] Reset command"));
                writeline(output, l);
                reset_enable <= false;
                state        <= wait_on_cs;
                rwds         <= 'Z';
              end if;
            when CMD_READ_ID =>
              write(l, string'("[Octo_BFM] Commando read ID not implemented"));
              writeline(output, l);
              state <= wait_on_cs;

            when x"06" =>
              write_enable <= true;
              state        <= wait_on_cs;
            when x"04" =>
              write_enable <= false;
            when CMD_READ_DDR | CMD_WRITE_DDR |
                 CMD_READ_REG | CMD_WRITE_REG =>
              state   <= get_address;
              counter <= 3;
            when others =>
              state <= wait_on_cs;
              rwds  <= 'Z';
          end case;

        when get_address =>
          if counter = 0 then
            if command = CMD_WRITE_DDR then
              state <= latency_wait;
              -- old_latency is inverse of RWDS.
              if old_latency = '1' then
                counter <= 2 * latency_length - 2;
              else
                counter <= 4 * latency_length - 2;
              end if;
            elsif command = CMD_READ_DDR or
              command = CMD_READ_REG then
              state <= latency_wait;
              -- old_latency is inverse of RWDS.
              if old_latency = '1' then
                counter <= 2 * latency_length + 1;
              else
                counter <= 4 * latency_length + 1;
              end if;
            else
              -- Write register, no latency
              state   <= write_register;
              counter <= 1;
            end if;
          else
            counter <= counter - 1;
          end if;

          check_for_z;
          address((counter+1) * 8 - 1 downto counter * 8) <= unsigned(dq);

        -- State write register
        when write_register =>
          rwds <= 'Z';

          check_for_z;
          assert rwds /= 'Z'
            report "[Octo_BFM] No driving on RWDS in state write_register"
            severity warning;

          if address = 0 then           -- ID0 register
            if counter = 1 then
              write(l, string'("[Octo_BFM] Register ID0 not writable: "));
              hwrite(l, address);
              writeline(output, l);
              found_error <= true;
              counter     <= 0;
            else
              state <= wait_on_cs;
            end if;
          elsif address = 2 then        -- ID1 register
            if counter = 1 then
              write(l, string'("[Octo_BFM] Register ID1 not writable: "));
              hwrite(l, address);
              writeline(output, l);
              found_error <= true;
              counter     <= 0;
            else
              state <= wait_on_cs;
            end if;

          elsif address = 4 then        -- CR0 register
            for i in dq'range loop
              if dq(i) /= '0' and dq(i) /= '1' then
                write(l, string'("[Octo_BFM] DQ bit "));
                hwrite(l, to_unsigned(i, 4));
                write(l, string'(" read as undefined"));
                writeline(output, l);
                found_error <= true;
                counter     <= 0;
              end if;
            end loop;
            if counter = 1 then
              cr0(15 downto 8) <= dq;
              counter          <= 0;
            else
              cr0(7 downto 0) <= dq;
              state           <= wait_on_cs;
              write(l, string'("[Octo_BFM] CR0 is now set to 0x"));
              hwrite(l, unsigned(cr0(15 downto 8)));
              hwrite(l, unsigned(dq));
              writeline(output, l);
            end if;

          elsif address = 6 then        -- CR1 register
            if counter = 1 then
              cr1(15 downto 8) <= dq;
              counter          <= 0;
            else
              cr1(7 downto 0) <= dq;
              state           <= wait_on_cs;
              write(l, string'("[Octo_BFM] CR1 is now set to 0x"));
              hwrite(l, unsigned(cr1(15 downto 8)));
              hwrite(l, unsigned(dq));
              writeline(output, l);
            end if;

          elsif (address > 7) and (address < x"2C") then
            if counter = 1 then
              reg(to_integer(address)-8)(15 downto 8) <= dq;
              rwds                                    <= '1';
              counter                                 <= 0;
            elsif counter = 0 then
              reg(to_integer(unsigned(address))-8)(7 downto 0) <= dq;
              state                                            <= wait_on_cs;
            else
              write(l, string'("[Octo_BFM] Wrong register address: "));
              hwrite(l, address);
              writeline(output, l);
              found_error <= true;
              state       <= wait_on_cs;
            end if;
          end if;

        -- State latency wait
        when latency_wait =>
          if counter /= 0 then
            counter <= counter -1;
          else
            if command = CMD_READ_DDR and ck = '0' then
              state <= read_ddr;
            elsif command = CMD_READ_REG and ck = '0' then
              state   <= read_register;
              counter <= 1;
            elsif ck = '0' then
              state   <= write_ddr;
              rwds    <= 'Z';
              counter <= 0;
            end if;
          end if;

          if command = CMD_WRITE_DDR then
            rwds <= 'Z';
          elsif command = CMD_READ_DDR or command = CMD_READ_REG then
            rwds <= '0';
          end if;

        -- State write_ddr, Writes content to emmory
        when write_ddr =>
          if cs = '1' then
            state <= command_state_1;

          elsif counter > burst_length then
            write(l, string'("[Octo_BFM] Too many writes in a burst, max number is: "));
            write(l, burst_length);
            writeline(output, l);
            found_error <= true;
            state       <= wait_on_cs;
          elsif address(31 downto 10) = to_unsigned(0, 22) then
            memory_low(to_integer(address(9 downto 0))+counter) <= dq;
            write(l, string'("[Octo_BFM] Wrote 0x"));
            hwrite(l, dq);
            write(l, string'(" to address 0x"));
            write(l, to_integer(address) + counter);
            writeline(output, l);
          elsif address(31 downto 10) = x"FFFFF" & "11" then
            memory_high(to_integer(address(9 downto 0))+counter) <= dq;
            write(l, string'("[Octo_BFM] Wrote 0x"));
            hwrite(l, dq);
            write(l, string'(" to address 0x"));
            write(l, to_integer(address) + counter);
            writeline(output, l);
          else
            write(l, string'("[Octo_BFM] Warning, the BFM can not handle address: "));
            hwrite(l, address);
            write(l, string'(" for memory write, this is a limitation in the BFM"));
            writeline(output, l);
            found_error <= true;
          end if;

          counter <= counter + 1;
          check_for_z;
          assert rwds /= 'Z'
            report "no driving on RWDS in state " & state_t'image(state)
            severity warning;

        -- State read_ddr, reads contens from memory.
        when read_ddr =>
          rwds <= not rwds;
          if cs = '1' then
            state <= command_state_1;

          elsif counter > burst_length then
            write(l, string'("[Octo_BFM] Too many writes in a burst, max number is: "));
            write(l, burst_length);
            writeline(output, l);
            found_error <= true;
            state       <= wait_on_cs;
            dq          <= (others => 'Z');
          elsif address(31 downto 10) = to_unsigned(0, 22) then
            dq <= memory_low((to_integer(address(9 downto 0))+counter));
            write(l, string'("[Octo_BFM] Read 0x"));
            hwrite(l, memory_low((to_integer(address(9 downto 0))+counter)));
            write(l, string'(" from address 0x"));
            write(l, to_integer(address) + counter);
            writeline(output, l);
          elsif address(31 downto 10) = x"FFFFF" & "11" then
            dq <= memory_high((to_integer(address(9 downto 0))+counter));
            write(l, string'("[Octo_BFM] Read 0x"));
            hwrite(l, memory_low((to_integer(address(9 downto 0))+counter)));
            write(l, string'(" from address 0x"));
            write(l, to_integer(address) + counter);
            writeline(output, l);
          else
            write(l, string'("[Octo_BFM] Warning, the BFM can not handle address: "));
            hwrite(l, address);
            write(l, string'(" for memory read, this is a limitation in the BFM"));
            writeline(output, l);
            found_error <= true;
            if counter mod 2 = 0 then
              dq <= CMD_WRITE_DDR;
            else
              dq <= x"AD";
            end if;
          end if;

          counter <= counter + 1;

        -- State read register
        when read_register =>
          rwds <= '1';

          if address = 0 then           -- ID0 register
            if counter = 1 then
              dq      <= id0_register_c(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= id0_register_c(7 downto 0);
              state <= wait_on_cs;
              write(l, string'("[Octo_BFM] Register ID0 (0x"));
              hwrite(l, address);
              write(l, string'(") is read as 0x"));
              hwrite(l, unsigned(dq));
              hwrite(l, unsigned(id0_register_c(7 downto 0)));
              writeline(output, l);
            end if;

          elsif address = 2 then        -- ID1 register
            if counter = 1 then
              dq      <= id1_register_c(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= id1_register_c(7 downto 0);
              state <= wait_on_cs;
              write(l, string'("[Octo_BFM] Register ID1 (0x"));
              hwrite(l, address);
              write(l, string'(") is read as 0x"));
              hwrite(l, unsigned(dq));
              hwrite(l, unsigned(id1_register_c(7 downto 0)));
              writeline(output, l);
            end if;

          elsif address = 4 then
            if counter = 1 then
              dq      <= cr0(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= cr0(7 downto 0);
              state <= wait_on_cs;
              write(l, string'("[Octo_BFM] Register CR0 (0x"));
              hwrite(l, address);
              write(l, string'(") is read as 0x"));
              hwrite(l, unsigned(dq));
              hwrite(l, unsigned(cr0(7 downto 0)));
              writeline(output, l);
            end if;

          elsif address = 6 then
            if counter = 1 then
              dq      <= cr1(15 downto 8);
              rwds    <= '1';
              counter <= counter - 1;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= cr1(7 downto 0);
              state <= wait_on_cs;
              write(l, string'("[Octo_BFM] Register CR1 (0x"));
              hwrite(l, address);
              write(l, string'(") is read as 0x"));
              hwrite(l, unsigned(dq));
              hwrite(l, unsigned(cr1(7 downto 0)));
              writeline(output, l);
            end if;

          elsif (unsigned(address) > 7) and (unsigned(address) < x"2C") then
            if counter = 1 then
              dq      <= reg(to_integer(unsigned(address))-8)(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= reg(to_integer(unsigned(address))-8)(7 downto 0);
              state <= wait_on_cs;
              write(l, string'("[Octo_BFM] Register at addr 0x"));
              hwrite(l, address);
              write(l, string'(" is read as 0x"));
              hwrite(l, unsigned(dq));
              hwrite(l, unsigned(reg(to_integer(unsigned(address))-8)(7 downto 0)));
              writeline(output, l);
            else
              write(l, string'("[Octo_BFM] Wrong register address: "));
              hwrite(l, address);
              writeline(output, l);
              found_error <= true;
              state       <= wait_on_cs;
            end if;
          end if;

        when others => null;
      end case;

    end if;

  end process;

end architecture bfm;
