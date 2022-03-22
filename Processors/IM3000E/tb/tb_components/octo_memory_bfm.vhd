library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

entity octo_memory_bfm is

  port (
    cs    : in    std_logic;
    ck    : in    std_logic;
    rwds  : inout std_logic;
    dq    : inout std_logic_vector(7 downto 0);
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
  signal latency_length : integer   := 10;
  signal counter        : integer   := 0;

  signal address : unsigned(31 downto 0);

  type reg_t is array (17 downto 0) of std_logic_vector(15 downto 0);
  signal reg : reg_t;

  type memory_array_t is array (1023 downto 0) of std_logic_vector(7 downto 0);
  signal memory_low  : memory_array_t;
  signal memory_high : memory_array_t;

  signal burst_length : integer := 0;

begin  -- architecture bfm

  p_deep_power_down : process (all) is
  begin  -- process s
    if (reset_n = '1') or (state = command_state_1 and command = x"99" and reset_enable) then
      deep_power_down_state <= normal;
      deep_power_down       <= false;
    else
      case deep_power_down_state is
        when normal =>
          deep_power_down <= false;
          if (state = command_state_2 and command = x"09") or cr0(15) = '1' then
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
    variable l : line;
  begin  -- process
    if reset_n = '0' then
      write(l, string'("Octo_spi reset pin"));
      writeline(output, l);
      command         <= x"00";
      reset_enable    <= false;
      state           <= command_state_1;
      dq              <= (others => 'Z');
      rwds            <= 'Z';
    elsif cs = '1' then                 -- wait_on_cs state
      command <= x"00";
      state   <= command_state_1;
      dq      <= (others => 'Z');
      rwds    <= 'Z';
    elsif deep_power_down then
      reg <= (others => (others => 'X'));
      cr0 <= cr0_init_value_c;
    elsif ck'event and not deep_power_down then
      case state is
        when command_state_1 =>
          command     <= dq;
          state       <= command_state_2;
          rwds        <= old_latency;
          old_latency <= not old_latency;
          dq          <= (others => 'Z');
        when command_state_2 =>
          assert command = dq report "cmd is not repeated in second byte" severity error;
          case command is
            when x"09" =>                -- deep_power_down
              state        <= command_state_1;
              command      <= x"00";
              reset_enable <= false;
            when x"66" =>
              reset_enable <= true;
              state        <= command_state_1;
            when x"99" =>
              if reset_enable then
                write(l, string'("Octo_spi reset command"));
                writeline(output, l);
                reset_enable    <= false;
                state           <= wait_on_cs;
                rwds            <= 'Z';
              end if;
            when x"9F" =>                -- Read ID
              write(l, string'("Commando read ID not implemnted"));
              writeline(output, l);
              state <= wait_on_cs;
           
            when x"06" =>
              write_enable <= true;
            when x"04" =>
              write_enable <= false;
            when  x"EE" | x"DE" |         -- Read/write memory array 
                  x"65" | x"71"    =>  -- Read register
              state   <= get_address;
              counter <= 3;
            when others =>
              state <= wait_on_cs;
              rwds  <= 'Z';
          end case;

        when get_address =>
          if counter = 0 then
            if command = x"EE" or command = x"DE" or command = x"65" then
              state <= latency_wait;
              -- old_latency is invers from RWDS.
              if old_latency = '1' then
                counter <= latency_length;
              else
                counter <= latency_length * 2;
              end if;
            else
              -- Write register, no latency
              state   <= write_register;
              counter <= 1;
            end if;
          end if;
          address((counter+1)*8 -1 downto counter * 8) <= unsigned(dq);
          counter                                      <= counter -1;

        -- State write register
        when write_register =>
          rwds <= '1';
          if address = x"000000" then     -- ID0 register
            if counter = 1 then
              write(l, string'("[octo BFM] Register ID0 not writable: "));
              hwrite(l, address);
              writeline(output, l);
              counter <= 0;
            else
              rwds  <= '0';
              state <= wait_on_cs;
            end if;
          elsif address = x"000002" then  -- ID1 register
            if counter = 1 then
              write(l, string'("[octo BFM] Register ID1 not writable: "));
              hwrite(l, address);
              writeline(output, l);
              counter <= 0;
            else
              rwds  <= '0';
              state <= wait_on_cs;
            end if;

          elsif address = x"000004" then  -- CR0 register
            if counter = 1 then
              cr0(15 downto 8) <= dq;
              counter          <= 0;
            else
              cr0(7 downto 0) <= dq;
              rwds            <= '0';
              state           <= wait_on_cs;
            end if;

          elsif address = x"00000006" then  -- CR1 register
            if counter = 1 then
              cr1(15 downto 8) <= dq;
              counter          <= 0;
            else
              cr1(7 downto 0) <= dq;
              rwds            <= '0';
              state           <= wait_on_cs;
            end if;

          elsif (address > x"00000007") and (address < x"0000002C") then
            if counter = 1 then
              reg(to_integer(address)-8)(15 downto 8) <= dq;
              rwds                                              <= '1';
              counter                                           <= 0;
            elsif counter = 0 then
              rwds                                             <= '0';
              reg(to_integer(unsigned(address))-8)(7 downto 0) <= dq;
              state                                            <= wait_on_cs;
            else
              write(l, string'("[octo BFM] Wrong register adress: "));
              hwrite(l, address);
              writeline(output, l);
              state <= wait_on_cs;
            end if;
          end if;


        -- State latency wait
        when latency_wait =>
          if counter /= 0 then
            counter <= counter -1;
          else
            if command = x"EE" and ck = '0' then
              state <= read_ddr;
            elsif command = x"65" and ck = '0' then
              state   <= read_register;
              counter <= 1;
            else
              state <= write_ddr;
              counter <= 0;
            end if;
          end if;

        -- State write_ddr, Writes content to emmory
        when write_ddr =>

          if cs = '1' then
            state <= command_state_1;

          elsif counter > burst_length then
            write(l, string'("[Octo_BFM] to many writes in a burst, max number is: "));
            write(l, burst_length);
            writeline(output, l);
            state <= wait_on_cs;
          elsif address(31 downto 10) = to_unsigned(0, 22) then
            memory_low(to_integer(address(9 downto 0))+counter) <= dq;
          elsif address(31 downto 10) = x"FFFFF" & "11" then
            memory_high(to_integer(address(9 downto 0))+counter) <= dq;
          else
            write(l, string'("[Octo_BFM] Warnig, the BFM can not handle address: "));
            hwrite(l, address);
            write(l, string'(" for memory write, this is a limitation in the BFM"));
            writeline(output, l);
          end if;
          
          counter <= counter + 1;
          
        -- State read_ddr, reads contens from memory.
        when read_ddr =>
          write(l, string'("[Octo_BFM] Read from memory not yet supported"));

          rwds <= not rwds;
          if cs = '1' then
            state <= command_state_1;
          
          elsif counter > burst_length then
              write(l, string'("[Octo_BFM] to many writes in a burst, max number is: "));
              write(l, burst_length);
              writeline(output, l);
              state <= wait_on_cs;
              dq <= (others => 'Z');
          elsif address(31 downto 10) = to_unsigned(0, 22) then
            dq <= memory_low((to_integer(address(9 downto 0))+counter));
          elsif address(31 downto 10) = x"FFFFF" & "11" then
            dq <= memory_high((to_integer(address(9 downto 0))+counter));
          else           
            write(l, string'("[Octo_BFM] Warnig, the BFM can not handle address: "));
            hwrite(l, address);
            write(l, string'(" for memory read, this is a limitation in the BFM"));
            writeline(output, l);
          end if;

          counter <= counter + 1;

        -- State read register
        when read_register =>
          rwds <= '1';
          if address = x"000000" then   -- ID0 register
            if counter = 1 then
              dq      <= id0_register_c(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= id0_register_c(7 downto 0);
              state <= wait_on_cs;
            end if;

          elsif address = x"000002" then  -- ID1 register
            if counter = 1 then
              dq      <= id1_register_c(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= id1_register_c(7 downto 0);
              state <= wait_on_cs;
            end if;

          elsif address = x"000004" then
            if counter = 1 then
              dq      <= cr0(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= cr0(7 downto 0);
              state <= wait_on_cs;
            end if;

          elsif address = x"000006" then
            if counter = 1 then
              dq      <= cr1(15 downto 8);
              rwds    <= '1';
              counter <= counter - 1;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= cr1(7 downto 0);
              state <= wait_on_cs;
            end if;

          elsif (unsigned(address) > x"00000007") and (unsigned(address) < x"0000002C") then
            if counter = 1 then
              dq      <= reg(to_integer(unsigned(address))-8)(15 downto 8);
              rwds    <= '1';
              counter <= 0;
            elsif counter = 0 then
              rwds  <= '0';
              dq    <= reg(to_integer(unsigned(address))-8)(7 downto 0);
              state <= wait_on_cs;
            else
              write(l, string'("[octo BFM] Wrong register adress: "));
              hwrite(l, address);
              writeline(output, l);
              state <= wait_on_cs;
            end if;
          end if;

        when others => null;
      end case;

    end if;

  end process;

end architecture bfm;
