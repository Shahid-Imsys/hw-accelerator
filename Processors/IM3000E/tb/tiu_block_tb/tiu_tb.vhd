library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.stop;

entity tiu_tb is
  end;          

architecture rtl of tiu_tb is

  component tiu is
    port 
    (

      -- Interface to host  
      clk_p      : in  std_logic;
      clk_c_en   : in  std_logic;  -- Clock 133.3 MHz
      rst_en     : in  std_logic;  -- Asynchronous master reset
      reg_wr     : in  std_logic;  -- High when reg_addr is written with '1' in bit 7
      wdata      : in  std_logic_vector(7 downto 0); -- Data to write in timer
      reg_addr   : in  std_logic_vector(7 downto 0); -- Register address
      run        : in  std_logic;  -- Holding this low keeps the counters from
                                   -- changing, without destroying parameters.
                                   -- Parameters can be loaded.
      tiu_enable : in  std_logic;   -- Shall be low at initial reset, and when
                                    -- timer system is not used. Must be high
                                    -- when loading paramenters and when using
                                    -- timer system. Signal trst_n is derived
                                    -- from this signal.

      -- Outputs:
      tiu_irq    : out std_logic;   -- Interrupt request from timer unit
      tiu_out    : out std_logic_vector(7 downto 0); -- Output, to DSL
      pdi_clk    : out std_logic;   -- clock to parallel data interface 
                                    -- Interface to I/O port logic 
      cpt_trig   : in  std_logic_vector(7 downto 0);  -- external trigger or
                                                      -- capture
      tstamp_rx1 : in  std_logic;   -- timestamp signal from Ethernet ch 1
      pulseout   : out std_logic_vector(7 downto 0) -- Outputs to port logic
    ); 
  end component;

  constant clk_period      : time := 12 ns;
  constant clk_period_half : time := clk_period / 2;

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
  constant timer0_exp : integer range 0 to 7  := 0;
  constant timer1_exp : integer range 0 to 7  := 1;
  constant timer2_exp : integer range 0 to 7  := 0;
  constant timer3_exp : integer range 0 to 4  := 0; -- driven, viable options: 0, 1, 2, 4
  constant timer4_exp : integer range 0 to 7  := 0;
  constant timer5_exp : integer range 0 to 7  := 0;
  constant timer6_exp : integer range 0 to 7  := 0;
  constant timer7_exp : integer range 0 to 7  := 0;

  constant timer0_pls : time := (timer0_msa+1)*(2**(timer0_exp + 1))*clk_period;
  constant timer1_pls : time := (timer1_msa+1)*(2**(timer1_exp + 1))*clk_period;
  constant timer2_pls : time := (timer2_msa+1)*(2**(timer2_exp + 1))*clk_period;
  constant timer3_pls : time := (timer3_msa+1)*(timer2_msa + 1)*(2**(timer2_exp + 1))*clk_period;
  constant timer4_pls : time := (timer4_msa+1)*(2**(timer4_exp + 1))*clk_period;
  constant timer5_pls : time := (timer5_msa+1)*(2**(timer5_exp + 1))*clk_period;
  constant timer6_pls : time := (timer6_msa+1)*(2**(timer6_exp + 1))*clk_period;
  constant timer7_pls : time := (timer7_msa+1)*(2**(timer7_exp + 1))*clk_period;

  signal clk_p     : std_logic := '0'; 
  signal clk_c_en  : std_logic := '1';
  signal rst_en    : std_logic := '0';
  signal reg_wr    : std_logic := '0';
  signal wdata     : std_logic_vector(7 downto 0) := (others => '0');
  signal reg_addr  : std_logic_vector(7 downto 0) := (others => '0');
  signal run       : std_logic := '1';
  signal tiu_enable: std_logic := '0';
  signal tiu_irq   : std_logic; 
  signal tiu_out   : std_logic_vector(7 downto 0); 
  signal pdi_clk   : std_logic; 
  signal cpt_trig  : std_logic_vector(7 downto 0);
  signal tstamp_rx1: std_logic; 
  signal pulseout  : std_logic_vector(7 downto 0);

  signal test_done : boolean := false;
  signal test_pass : boolean := true;
  signal test_time0_done : boolean := false;
  signal test_time1_done : boolean := false;
  signal test_time2_done : boolean := false;
  signal test_time3_done : boolean := false;
  signal test_time4_done : boolean := false;
  signal test_time5_done : boolean := false;
  signal test_time6_done : boolean := false;
  signal test_time7_done : boolean := false;

begin

  clk_p <= not clk_p after clk_period_half;

  i_tiu : tiu
  port map
  (
    clk_p      => clk_p,
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

  reset : process
  begin
    wait for clk_period;
    rst_en     <= '1';
    tiu_enable <= '1';
    wait;
  end process;

  init : process
    procedure write_reg (addr_in : in std_logic_vector(7 downto 0);
                         data_in : in std_logic_vector(7 downto 0)) is
    begin
      reg_wr   <= addr_in(7);
      reg_addr <= addr_in;
      wdata    <= data_in;
      wait for clk_period;
    end procedure;

  begin
    wait until rst_en = '1';
    wait for clk_period;
    write_reg("10000000", std_logic_vector(to_unsigned(timer0_exp, 3)) & std_logic_vector(to_unsigned(timer0_msa, 5)));
    write_reg("10000001", std_logic_vector(to_unsigned(timer1_exp, 3)) & std_logic_vector(to_unsigned(timer1_msa, 5)));
    write_reg("10000010", std_logic_vector(to_unsigned(timer2_exp, 3)) & std_logic_vector(to_unsigned(timer2_msa, 5)));
    write_reg("10000011", std_logic_vector(to_unsigned(timer3_exp, 3)) & std_logic_vector(to_unsigned(timer3_msa, 5)));
    write_reg("10000100", std_logic_vector(to_unsigned(timer4_exp, 3)) & std_logic_vector(to_unsigned(timer4_msa, 5)));
    write_reg("10000101", std_logic_vector(to_unsigned(timer5_exp, 3)) & std_logic_vector(to_unsigned(timer5_msa, 5)));
    write_reg("10000110", std_logic_vector(to_unsigned(timer6_exp, 3)) & std_logic_vector(to_unsigned(timer6_msa, 5)));
    write_reg("10000111", std_logic_vector(to_unsigned(timer7_exp, 3)) & std_logic_vector(to_unsigned(timer7_msa, 5)));
    write_reg("10010000", "00100000"); -- set tgl of counter 0 to 01
    write_reg("10010001", "00100000"); -- set tgl of counter 1 to 01
    write_reg("10010010", "00100000"); -- set tgl of counter 2 to 01
    write_reg("10010011", "00100000"); -- set tgl of counter 3 to 01
    write_reg("10010100", "00100000"); -- set tgl of counter 4 to 01
    write_reg("10010101", "00100000"); -- set tgl of counter 5 to 01
    write_reg("10010110", "00100000"); -- set tgl of counter 6 to 01
    write_reg("10010111", "00100000"); -- set tgl of counter 7 to 01
    write_reg("10100010", "00100000"); -- set drv of counter 2 to 1
    write_reg("10101000", "11111111"); -- enable all counters
    wait;
  end process;

  test_time : process(pulseout)
    type tmp_t is array (0 to 7) of time;
    variable tmp : tmp_t := (others => 0 ns);
  begin
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

  end process;

  test_stop : process
  begin
    wait until test_done;
    if (test_pass) then
      write(output, string'("Test PASS" & lf));
    else
      write(output, string'("Test FAIL" & lf));
    end if;
    stop;
  end process;

  test_done <= test_time0_done and test_time1_done and test_time2_done and test_time3_done and test_time4_done;

end architecture;
