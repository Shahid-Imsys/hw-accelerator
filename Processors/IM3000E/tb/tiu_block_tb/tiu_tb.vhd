library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

  signal addr : std_logic_vector(7 downto 0);
  signal data : std_logic_vector(7 downto 0);


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

  test : process

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
    write_reg("10000000", "00000111"); -- set msa of counter 0 to 111
    write_reg("10000001", "00100111"); -- set msa of counter 1 to 111 and exp to 1
    write_reg("10010000", "00100000"); -- set tgl of counter 0 to 01
    write_reg("10010001", "00100000"); -- set tgl of counter 1 to 01
    write_reg("10101000", "11111111"); -- enable all counters
    wait;

  end process;

  test_time0 : process(pulseout(0))
    variable tmp : time := 0 ns;
  begin
    if rising_edge(pulseout(0)) then
      tmp := now;
    elsif falling_edge(pulseout(0)) then
      assert now - tmp = clk_period*16 report "Timer 0 pulseout fail" severity error;
    end if;
  end process;

  test_time1 : process(pulseout(1))
    variable tmp : time := 0 ns;
  begin
    if rising_edge(pulseout(1)) then
      tmp := now;
    elsif falling_edge(pulseout(1)) then
      assert now - tmp = clk_period*32 report "Timer 1 pulseout fail. Pulse active for: " & time'image(now - tmp) & ", should be: " & time'image(clk_period*32)  severity error;
    end if;
  end process;

end architecture;
