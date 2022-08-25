library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.stop;

entity tiu_tb is
end;

architecture rtl of tiu_tb is

  component tiu is
    port (

      -- Interface to host  
      clk_p    : in std_logic;
      clk_p_n  : in std_logic;
      clk_c_en : in std_logic;                    -- Clock 133.3 MHz
      rst_en   : in std_logic;                    -- Asynchronous master reset
      reg_wr   : in std_logic;                    -- High when reg_addr is written with '1' in bit 7
      wdata    : in std_logic_vector(7 downto 0); -- Data to write in timer
      reg_addr : in std_logic_vector(7 downto 0); -- Register address
      run      : in std_logic;                    -- Holding this low keeps the counters from
      -- changing, without destroying parameters.
      -- Parameters can be loaded.
      tiu_enable : in std_logic; -- Shall be low at initial reset, and when
      -- timer system is not used. Must be high
      -- when loading paramenters and when using
      -- timer system. Signal trst_n is derived
      -- from this signal.

      -- Outputs:
      tiu_irq : out std_logic;                    -- Interrupt request from timer unit
      tiu_out : out std_logic_vector(7 downto 0); -- Output, to DSL
      pdi_clk : out std_logic;                    -- clock to parallel data interface 
      -- Interface to I/O port logic 
      cpt_trig : in std_logic_vector(7 downto 0); -- external trigger or
      -- capture
      tstamp_rx1 : in std_logic;                    -- timestamp signal from Ethernet ch 1
      pulseout   : out std_logic_vector(7 downto 0) -- Outputs to port logic
    );
  end component;

  constant clk_period : time := 12 ns;

  -- Starting values of timers under test
  constant timer0_msa : integer range 0 to 31 := 7;
  constant timer1_msa : integer range 0 to 31 := 7;
  constant timer2_msa : integer range 0 to 31 := 3;
  constant timer3_msa : integer range 0 to 31 := 4;
  constant timer4_msa : integer range 0 to 31 := 7;
  constant timer5_msa : integer range 0 to 31 := 7;
  constant timer6_msa : integer range 0 to 31 := 7;
  constant timer7_msa : integer range 0 to 31 := 7;

  -- Exp values of timers under test
  -- Will affect counter clock frequency: base_freq/2**exp
  constant timer0_exp : integer range 0 to 7 := 1;
  constant timer1_exp : integer range 0 to 7 := 1;
  constant timer2_exp : integer range 0 to 7 := 0;
  constant timer3_exp : integer range 0 to 4 := 0; -- driven, viable options: 0, 1, 2, 4
  constant timer4_exp : integer range 0 to 7 := 0;
  constant timer5_exp : integer range 0 to 7 := 0;
  constant timer6_exp : integer range 0 to 7 := 0;
  constant timer7_exp : integer range 0 to 7 := 0;

  constant delay_cycles : integer := 10;
  constant pulse_cycles : integer := 75;

  constant timer0_pls : time := (timer0_msa + 1) * (2 ** (timer0_exp + 1)) * clk_period;
  constant timer1_pls : time := (timer1_msa + 1) * (2 ** (timer1_exp + 1)) * clk_period;
  constant timer2_pls : time := (timer2_msa + 1) * (2 ** (timer2_exp + 1)) * clk_period;
  constant timer3_pls : time := (timer3_msa + 1) * (timer2_msa + 1) * (2 ** (timer2_exp + 1)) * clk_period;
  constant timer4_pls : time := (timer4_msa + 1) * (2 ** (timer4_exp + 1)) * clk_period;
  constant timer5_pls : time := (timer5_msa + 1) * (2 ** (timer5_exp + 1)) * clk_period;
  constant timer6_pls : time := (timer6_msa + 1) * (2 ** (timer6_exp + 1)) * clk_period;
  constant timer7_pls : time := (timer7_msa + 1) * (2 ** (timer7_exp + 1)) * clk_period;

  signal clk_p      : std_logic                    := '0';
  signal clk_p_n    : std_logic                    := '1';
  signal clk_c_en   : std_logic                    := '1';
  signal rst_en     : std_logic                    := '0';
  signal reg_wr     : std_logic                    := '0';
  signal wdata      : std_logic_vector(7 downto 0) := (others => '0');
  signal reg_addr   : std_logic_vector(7 downto 0) := (others => '0');
  signal run        : std_logic                    := '1';
  signal tiu_enable : std_logic                    := '0';
  signal tiu_irq    : std_logic;
  signal tiu_out    : std_logic_vector(7 downto 0);
  signal pdi_clk    : std_logic;
  signal cpt_trig   : std_logic_vector(7 downto 0) := (others => '0');
  signal tstamp_rx1 : std_logic;
  signal pulseout   : std_logic_vector(7 downto 0);

  signal trst_n  : std_logic;
  signal trst_n1 : std_logic;

  signal test_done_1     : boolean := false;
  signal test_done_2     : boolean := false;
  signal test_time0_done : boolean := false;
  signal test_time1_done : boolean := false;
  signal test_time2_done : boolean := false;
  signal test_time3_done : boolean := false;
  signal test_time4_done : boolean := false;
  signal test_time5_done : boolean := false;
  signal test_time6_done : boolean := false;
  signal test_time7_done : boolean := false;
  signal test_reset_done : boolean := false;
  signal test_delay_done : boolean := false;
  signal test_cpt_done   : boolean := false;
  signal test_cpt_pass   : boolean := true;
  signal test_reg_pass   : boolean := true;
  signal test_pass       : boolean := true;

  signal read_reg_tmp : std_logic_vector(7 downto 0);
  signal read_reg_cnt : std_logic_vector(7 downto 0) := (others => '0');
  signal reg_addr_chk : std_logic_vector(2 downto 0);
  signal reg_data_out : std_logic_vector(7 downto 0);

  signal clk_pll : std_logic := '0';

begin

  clk_pll      <= not clk_pll after 3 ns;
  reg_addr_chk <= reg_addr(5 downto 3);

  i_tiu : tiu
  port map
  (
    clk_p      => clk_p,
    clk_p_n    => clk_p_n,
    clk_c_en   => clk_c_en,
    rst_en     => rst_en,
    reg_wr     => reg_wr,
    wdata      => wdata,
    reg_addr   => reg_addr,
    run        => run,
    tiu_enable => tiu_enable,
    tiu_irq    => tiu_irq,
    tiu_out    => tiu_out,
    pdi_clk    => pdi_clk,
    cpt_trig   => cpt_trig,
    tstamp_rx1 => tstamp_rx1,
    pulseout   => pulseout
  );

  clock : process (clk_pll)
    variable counter : std_logic := '0';
  begin
    if (rising_edge(clk_pll)) then
      clk_p <= '0';
      if (counter = '0') then
        clk_p <= '1';
      else
        clk_p_n <= '1';
      end if;
      counter := not counter;
    else -- falling edge
      clk_p   <= '0';
      clk_p_n <= '0';
    end if;
  end process;

  reset : process
  begin
    wait for clk_period;
    wait until rising_edge(clk_p);
    rst_en     <= '1';
    tiu_enable <= '1';

    wait until test_done_1;
    wait until rising_edge(clk_p);
    rst_en <= '0';

    wait for clk_period;
    wait until rising_edge(clk_p);
    rst_en          <= '1';
    test_reset_done <= true;
    write(output, string'("Reset" & lf));

    wait until test_delay_done;
    wait until rising_edge(clk_p);
    rst_en <= '0';

    wait for clk_period;
    wait until rising_edge(clk_p);
    rst_en <= '1';
    write(output, string'("Reset" & lf));

    wait;
  end process;

  init : process
    procedure write_reg (
      addr_in : in std_logic_vector(7 downto 0);
      data_in : in std_logic_vector(7 downto 0)) is
    begin
      wait until rising_edge(clk_p);
      reg_wr   <= addr_in(7);
      reg_addr <= addr_in;
      wdata    <= data_in;
    end procedure;

    procedure read_reg (
      addr_in         : in std_logic_vector(7 downto 0);
      signal data_out : out std_logic_vector(7 downto 0)) is
    begin
      wait until rising_edge(clk_p);
      reg_wr   <= '0';
      reg_addr <= addr_in;
      wait for clk_period;
      data_out <= tiu_out;
    end procedure;

    variable tmp : std_logic_vector(7 downto 0);

  begin
    wait until rising_edge(rst_en);
    wait until rising_edge(clk_p);
    write_reg("10000000", std_logic_vector(to_unsigned(timer0_exp, 3)) & std_logic_vector(to_unsigned(timer0_msa, 5)));
    write_reg("10000001", std_logic_vector(to_unsigned(timer1_exp, 3)) & std_logic_vector(to_unsigned(timer1_msa, 5)));
    write_reg("10000010", std_logic_vector(to_unsigned(timer2_exp, 3)) & std_logic_vector(to_unsigned(timer2_msa, 5)));
    write_reg("10000011", std_logic_vector(to_unsigned(timer3_exp, 3)) & std_logic_vector(to_unsigned(timer3_msa, 5)));
    write_reg("10000100", std_logic_vector(to_unsigned(timer4_exp, 3)) & std_logic_vector(to_unsigned(timer4_msa, 5)));
    write_reg("10000101", std_logic_vector(to_unsigned(timer5_exp, 3)) & std_logic_vector(to_unsigned(timer5_msa, 5)));
    write_reg("10000110", std_logic_vector(to_unsigned(timer6_exp, 3)) & std_logic_vector(to_unsigned(timer6_msa, 5)));
    write_reg("10000111", std_logic_vector(to_unsigned(timer7_exp, 3)) & std_logic_vector(to_unsigned(timer7_msa, 5)));
    write_reg("10010000", "00100000"); -- set tgl of timer 0 to 01
    write_reg("10010001", "00100000"); -- set tgl of timer 1 to 01
    write_reg("10010010", "00100000"); -- set tgl of timer 2 to 01
    write_reg("10010011", "00100000"); -- set tgl of timer 3 to 01
    write_reg("10010100", "00100000"); -- set tgl of timer 4 to 01
    write_reg("10010101", "00100000"); -- set tgl of timer 5 to 01
    write_reg("10010110", "00100000"); -- set tgl of timer 6 to 01
    write_reg("10010111", "00100000"); -- set tgl of timer 7 to 01
    write_reg("10100010", "00100000"); -- set drv of timer 2 to 1
    write_reg("10101000", "11111111"); -- enable all timers
    wait for clk_period;
    if (test_reg_pass) then
      write(output, string'("Register r/w test OK" & lf));
    else
      write(output, string'("Register r/w test FAIL" & lf));
    end if;

    wait until test_reset_done;
    write_reg("10100000", "00000100"); -- set wai of timer 0 to 1
    write_reg("10000000", "00000001"); -- set msa of timer 0 to 1
    write_reg("10010000", "00100000"); -- set tgl of timer 0 to 1

    write_reg("10101000", "00000001"); -- enable timer 0

    wait for clk_period * delay_cycles;
    cpt_trig(0) <= '1';
    wait for clk_period;
    cpt_trig(0) <= '0';

    wait until rising_edge(rst_en);
    write_reg("10100000", "00100100"); -- set wai and drv of timer 0 to 1
    write_reg("10010000", "10000000"); -- set wai and drv of timer 0 to 1
    write_reg("10000000", "00000111"); -- set msa of timer 0 to 7
    write_reg("10000001", "00000111"); -- set msa of timer 1 to 7
    write_reg("01111111", "00000000");
    write_reg("10001000", "00100000"); -- set cpt_en to 1

    write_reg("10101000", "00000011"); -- enable timer 0

    wait for clk_period * delay_cycles;
    cpt_trig(0) <= '1';
    wait for clk_period * pulse_cycles;
    cpt_trig(0) <= '0';
    wait for clk_period;
    read_reg("00000000", reg_data_out);
    wait for 1 ps;
    tmp := reg_data_out;
    read_reg("00000001", reg_data_out);
    wait for 1 ps;

    if ((((31 - (to_integer(unsigned(tmp))) + 32 * (31 - to_integer(unsigned(reg_data_out)))) * 2) = pulse_cycles) or
      (((31 - (to_integer(unsigned(tmp))) + 32 * (31 - to_integer(unsigned(reg_data_out)))) * 2) = pulse_cycles + 1)) then
      write(output, string'("Interval measurement test OK" & lf));
    else
      write(output, string'("Interval measurement test FAIL, result: " & integer'image((62 - (to_integer(unsigned(tmp)) + to_integer(unsigned(reg_data_out)))) * 2) & lf));
      test_cpt_pass <= false;
    end if;
    test_cpt_done <= true;
    wait;
  end process;

  test_time : process (pulseout, rst_en, test_reg_pass, tiu_irq)
    type tmp_t is array (0 to 7) of time;
    variable tmp : tmp_t := (others => 0 ns);
  begin
    if (rst_en = '0') then
      test_time0_done <= false;
      test_time1_done <= false;
      test_time2_done <= false;
      test_time3_done <= false;
      test_time4_done <= false;
      test_time5_done <= false;
      test_time6_done <= false;
      test_time7_done <= false;

    else
      if (not test_reset_done) then
        if rising_edge(pulseout(0)) then
          tmp(0) := now;
        elsif falling_edge(pulseout(0)) then
          if (now - tmp(0) = timer0_pls) then
            write(output, string'("Timer 0 pulseout test OK" & lf));
          else
            write(output, string("Timer 0 pulseout FAIL. Pulse active for: " & time'image(now - tmp(0)) & ", should be: " & time'image(timer0_pls) & lf));
            test_pass <= false;
          end if;
          test_time0_done <= true;
        end if;

        if rising_edge(pulseout(1)) then
          tmp(1) := now;
        elsif falling_edge(pulseout(1)) then
          if (now - tmp(1) = timer1_pls) then
            write(output, string'("Timer 1 pulseout test OK" & lf));
          else
            write(output, string("Timer 1 pulseout FAIL. Pulse active for: " & time'image(now - tmp(1)) & ", should be: " & time'image(timer1_pls) & lf));
            test_pass <= false;
          end if;
          test_time1_done <= true;
        end if;

        if rising_edge(pulseout(2)) then
          tmp(2) := now;
        elsif falling_edge(pulseout(2)) then
          if (now - tmp(2) = timer2_pls) then
            write(output, string'("Timer 2 pulseout test OK" & lf));
          else
            write(output, string("Timer 2 pulseout FAIL. Pulse active for: " & time'image(now - tmp(2)) & ", should be: " & time'image(timer2_pls) & lf));
            test_pass <= false;
          end if;
          test_time2_done <= true;
        end if;

        if rising_edge(pulseout(3)) then
          tmp(3) := now;
        elsif falling_edge(pulseout(3)) then
          if (now - tmp(3) = timer3_pls) then
            write(output, string'("Timer 3 (driven by timer 2) pulseout test OK" & lf));
          else
            write(output, string'("Timer 3 (driven by timer 2) pulseout fail. Pulse active for: " & time'image(now - tmp(3)) & ", should be: " & time'image(timer3_pls) & lf));
            test_pass <= false;
          end if;
          test_time3_done <= true;
        end if;

        if rising_edge(pulseout(4)) then
          tmp(4) := now;
        elsif falling_edge(pulseout(4)) then
          if (now - tmp(4) = timer4_pls) then
            write(output, string'("Timer 4 pulseout test OK" & lf));
          else
            write(output, string("Timer 4 pulseout FAIL. Pulse active for: " & time'image(now - tmp(4)) & ", should be: " & time'image(timer4_pls) & lf));
            test_pass <= false;
          end if;
          test_time4_done <= true;
        end if;

        if rising_edge(pulseout(5)) then
          tmp(5) := now;
        elsif falling_edge(pulseout(5)) then
          if (now - tmp(5) = timer5_pls) then
            write(output, string'("Timer 5 pulseout test OK" & lf));
          else
            write(output, string("Timer 5 pulseout FAIL. Pulse active for: " & time'image(now - tmp(5)) & ", should be: " & time'image(timer5_pls) & lf));
            test_pass <= false;
          end if;
          test_time5_done <= true;
        end if;

        if rising_edge(pulseout(6)) then
          tmp(6) := now;
        elsif falling_edge(pulseout(6)) then
          if (now - tmp(6) = timer6_pls) then
            write(output, string'("Timer 6 pulseout test OK" & lf));
          else
            write(output, string("Timer 6 pulseout FAIL. Pulse active for: " & time'image(now - tmp(6)) & ", should be: " & time'image(timer6_pls) & lf));
            test_pass <= false;
          end if;
          test_time6_done <= true;
        end if;

        if rising_edge(pulseout(7)) then
          tmp(7) := now;
        elsif falling_edge(pulseout(7)) then
          if (now - tmp(7) = timer7_pls) then
            write(output, string'("Timer 7 pulseout test OK" & lf));
          else
            write(output, string("Timer 7 pulseout FAIL. Pulse active for: " & time'image(now - tmp(7)) & ", should be: " & time'image(timer7_pls) & lf));
            test_pass <= false;
          end if;
          test_time7_done <= true;
        end if;

        if (test_reg_pass /= true) then
          test_pass <= false;
        end if;
      else -- test_reset_done
        if rising_edge(pulseout(0)) then
          tmp(0) := now;
        elsif falling_edge(pulseout(0)) then
          if (now - tmp(0) = ((delay_cycles + 1) * 12 ns)) or (now - tmp(0) = ((delay_cycles + 2) * 12 ns)) then
            write(output, string("Timer 0 delayed start test OK" & lf));
          else
            write(output, string("Timer 0 delayed start test FAIL. Expected delays: " & integer'image(((delay_cycles + 3) * 12)) & " ns or " & integer'image(((delay_cycles + 4) * 12)) & " ns. Actual delay: " & time'image(now - tmp(0)) & lf));
            test_pass <= false;
          end if;
          test_delay_done <= true;
        end if;
      end if;
      --if (test_delay_done) then
      --  if

    end if;

  end process;

  test_stop : process (clk_p)
  begin
    if rising_edge(clk_p) then
      if (test_done_1 and test_done_2 and test_cpt_done) then
        if (test_pass and test_cpt_pass) then
          write(output, string'("Test PASS" & lf));
        else
          write(output, string'("Test FAIL" & lf));
        end if;
        stop;
      end if;
    end if;
  end process;

  read_reg : process (clk_p, trst_n1)
  begin
    if (rising_edge(clk_p)) then
      if (trst_n1 = '1') then
        if (reg_addr_chk = ("000" or "001" or "010" or "100")) then
          read_reg_cnt <= std_logic_vector(unsigned(read_reg_cnt) + 1);
          if (tiu_out /= wdata) then
            write(output, string'("Register r/w error, reg_cnt: " & to_string(read_reg_cnt) & lf));
            test_reg_pass <= false;
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk_p)
  begin
    if rising_edge(clk_p) then
      if (rst_en = '0') then
        trst_n  <= '0';
        trst_n1 <= '0';
      elsif clk_c_en = '1' then
        trst_n  <= tiu_enable;
        trst_n1 <= trst_n;
      end if;
    end if;
  end process;

  test_done_1 <= test_done_1 or
    (test_time0_done and
    test_time1_done and
    test_time2_done and
    test_time3_done and
    test_time4_done and
    test_time5_done and
    test_time6_done and
    test_time7_done);

  test_done_2 <= test_done_2 or
    (test_reset_done and
    test_delay_done);

end architecture;