library ieee;
use ieee.std_logic_1164.all;

entity clock_reset is

  generic (
    fpga_g : boolean := false);
  port (
    pll_clk     : in std_ulogic;
    pll_ref_clk : in std_ulogic;
    spi_sclk    : in std_logic;
    clk_p_cpu   : out std_logic;
    clk_p_cpu_n : out std_logic;
    clk_p_acc   : out std_logic;
    clk_e       : out std_logic;
    clk_rx      : out std_logic;
    clk_tx      : out std_logic;
    sclk        : out std_logic;
    sclk_n      : out std_logic;

    pre_spi_rst_n : in std_logic;
    mreset_n      : in std_logic; -- system reset, active low
    pwr_ok        : in std_logic; -- Power OK
    c1_wdog_n     : in std_logic;

    rst_n     : out std_logic; -- main reste, sync to clk_p
    spi_rst_n : out std_logic;

    --etxclk : in std_logic;
    --erxclk : in std_logic;

    pg_1_i : in std_logic;
    pf_1_i : in std_logic;

    clock_in_off            : in std_logic;
    sel_pll                 : in std_logic;
    spi_sel_pll             : in std_logic;
    spi_override_pll_locked : in std_logic;
    pll_locked              : in std_logic;

    scan_mode : in std_logic
  );

end entity clock_reset;

architecture rtl of clock_reset is

  signal clk_mux_out_int   : std_logic;
  signal clk_mux_out_int_d : std_logic;

  signal common_rst_n                   : std_logic;
  signal common_1_rst_n, common_2_rst_n : std_logic;
  signal main_rst_n                     : std_logic;

  signal sel_pll_all : std_logic;

  signal cpu_clock_p_puls   : std_logic;
  signal cpu_clock_p_n_puls : std_logic;
  signal acc_clock_p_puls   : std_logic;
  signal clock_e_puls       : std_logic;

begin -- architecture rtl

  -----------------------------------
  -- reset section
  ----------------------------------
  common_rst_n <= mreset_n and pwr_ok;

  i_rst1_n : entity work.reset_sync
    port map(
      clk => pll_ref_clk,

      scan_mode => scan_mode,
      a_rst_n   => common_rst_n,
      rst_n     => common_1_rst_n
    );

  i_rst2_n : entity work.reset_sync
    port map(
      clk => pll_clk,

      scan_mode => scan_mode,
      a_rst_n   => common_rst_n,
      rst_n     => common_2_rst_n
    );
  main_rst_n <= (spi_override_pll_locked or pll_locked) and common_rst_n and c1_wdog_n;
  i_main_rst_n : entity work.reset_sync
    port map(
      clk => clk_mux_out_int_d,

      scan_mode => scan_mode,
      a_rst_n   => main_rst_n,
      rst_n     => rst_n
    );

  spi_rst_n <= pre_spi_rst_n and pwr_ok;

  ---------------------------------------
  -- Clock section
  --------------------------------------

  sel_pll_all <= mreset_n and pll_locked and spi_sel_pll and not sel_pll;

  clk_mux_1 : entity work.clk_mux_top
    port map(
      clk1          => pll_ref_clk,
      clk2          => pll_clk,
      sel           => sel_pll_all,
      rst1_n        => common_1_rst_n,
      rst2_n        => common_2_rst_n,
      clk1_selected => open,
      clk_mux_out   => clk_mux_out_int);

  clk_mux_out_int_d <= clk_mux_out_int;

  i_clock_gate_cpu : entity work.clock_gate
    generic map(
      fpga_g => fpga_g)
    port map(
      clk       => clk_mux_out_int,
      en        => cpu_clock_p_puls,
      scan_mode => scan_mode,
      clk_out   => clk_p_cpu
    );

  i_clock_gate_cpu_n : entity work.clock_gate
    generic map(
      fpga_g => fpga_g)
    port map(
      clk       => clk_mux_out_int,
      en        => cpu_clock_p_n_puls,
      scan_mode => scan_mode,
      clk_out   => clk_p_cpu_n
    );

  i_clock_gate_acc : entity work.clock_gate
    generic map(
      fpga_g => fpga_g)
    port map(
      clk       => clk_mux_out_int,
      en        => acc_clock_p_puls,
      scan_mode => scan_mode,
      clk_out   => clk_p_acc
    );

  i_clock_gate_e : entity work.clock_gate
    generic map(
      fpga_g => fpga_g)
    port map(
      clk       => clk_mux_out_int,
      en        => clock_e_puls,
      scan_mode => scan_mode,
      clk_out   => clk_e
    );

  -- Ethernet clocks
  i_eth_rx_clock_gate : entity work.clock_gate
    generic map(
      fpga_g => fpga_g)
    port map(
      clk       => pg_1_i,
      en        => '1',
      scan_mode => scan_mode,
      clk_out   => clk_rx
    );

  i_eth_tx_clock_gate : entity work.clock_gate
    generic map(
      fpga_g => fpga_g)
    port map(
      clk       => pf_1_i,
      en        => '1',
      scan_mode => scan_mode,
      clk_out   => clk_tx
    );

  sclk   <= spi_sclk;
  sclk_n <= not spi_sclk;

  clock_divide_acc_p : process (clk_mux_out_int, rst_n) is
    variable counter : integer range 0 to 1;
  begin
    if rst_n = '0' then
      acc_clock_p_puls <= '0';
    elsif rising_edge(clk_mux_out_int) then
      acc_clock_p_puls <= '0';

      if clock_in_off then
        acc_clock_p_puls <= '0';
      else
        acc_clock_p_puls <= '1';
      end if;
    end if;
  end process clock_divide_acc_p;

  clock_divide_cpu_p : process (clk_mux_out_int, rst_n) is
    variable counter : integer range 0 to 1;
  begin               -- process clock_divide_e
    if rst_n = '0' then -- asynchronous reset (active low)
      cpu_clock_p_puls   <= '0';
      cpu_clock_p_n_puls <= '0';
      counter := 0;
    elsif rising_edge(clk_mux_out_int) then
      cpu_clock_p_puls   <= '0';
      cpu_clock_p_n_puls <= '0';

      if clock_in_off then
        cpu_clock_p_puls   <= '0';
        cpu_clock_p_n_puls <= '0';
        counter := 0;
      elsif counter = 0 then
        cpu_clock_p_puls <= '1';
        counter := counter + 1;
      elsif counter = 1 then
        cpu_clock_p_n_puls <= '1';
        counter := 0;
      end if;
    end if;
  end process clock_divide_cpu_p;

  clock_divide_e : process (clk_mux_out_int, rst_n) is
    variable counter : integer range 0 to 1;
  begin               -- process clock_divide_e
    if rst_n = '0' then -- asynchronous reset (active low)
      clock_e_puls <= '0';
      counter := 0;
    elsif rising_edge(clk_mux_out_int) then
      clock_e_puls <= '0';

      if clock_in_off then
        clock_e_puls <= '0';
        counter := 0;
      elsif counter = 0 then
        clock_e_puls <= '1';
        counter := counter + 1;
      elsif counter = 1 then
        counter := 0;
      end if;
    end if;
  end process clock_divide_e;

end architecture rtl;