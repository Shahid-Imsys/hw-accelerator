library ieee;
use ieee.std_logic_1164.all;

entity fpga_clock_reset is
 
  generic (
    fpga_g : boolean := true);
  port (
    clk_in   : in std_logic;
    spi_sclk : in std_logic;
    --
    clk_p   : out std_logic;
    clk_p_n : out std_logic;
    clk_rx  : out std_logic;
    clk_tx  : out std_logic;
    sclk    : out std_logic;
    sclk_n  : out std_logic;
    
    pre_spi_rst_n : in std_logic;
    mreset_n      : in std_logic;   -- system reset, active low
    pwr_ok        : in std_logic;   -- Power OK
    c1_wdog_n     : in std_logic;
    
    rst_n     : out std_logic;  -- main reset, sync to clk_p
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

    scan_mode               : in std_logic
    );
end entity fpga_clock_reset;

architecture rtl of fpga_clock_reset is

  signal common_rst_n : std_logic;
  signal main_rst_n : std_logic;
  
begin  -- architecture rtl

  -----------------------------------
  -- reset section
  ----------------------------------
  common_rst_n <= mreset_n and pwr_ok;
  main_rst_n  <= (spi_override_pll_locked or pll_locked) and common_rst_n and c1_wdog_n;

  
  i_main_rst_n : entity work.reset_sync
  port map (
    clk => clk_in,
 
    scan_mode   => scan_mode,
    a_rst_n     => main_rst_n,
    rst_n       => rst_n
    );

  spi_rst_n <= pre_spi_rst_n and pwr_ok;

  sclk <= spi_sclk;
  sclk_n <= not spi_sclk;
      
  ---------------------------------------
  -- Clock section
  --------------------------------------
    
  clk_p   <= clk_in;
  clk_p_n <= not clk_in;
  
  -- Ethernet clocks
  i_eth_rx_clock_gate : entity work.clock_gate
    
    generic map (
      fpga_g => fpga_g)
    port map (
      clk => pg_1_i,
      en  => '1',
      scan_mode => scan_mode,
      clk_out => clk_rx
      );

  i_eth_tx_clock_gate : entity work.clock_gate
    
    generic map (
      fpga_g => fpga_g)
    port map (
      clk => pf_1_i,
      en  => '1',
      scan_mode => scan_mode,
      clk_out => clk_tx
      );

end architecture rtl;
