library ieee;
use ieee.std_logic_1164.all;

entity clock_reset is
 
  generic (
    fpga_g : boolean := false);
  port (
    pll_clk : in  std_ulogic;
    pll_ref_clk : in std_ulogic;
    spi_sclk : in  std_logic;
    clk_p   : out std_logic;
    clk_rx  : out std_logic;
    clk_tx  : out std_logic;
    sclk : out std_logic;
    sclk_n : out std_logic;
    

    mreset_n     : in  std_logic;   -- system reset, active low
    pwr_ok       : in  std_logic;   -- Power OK

    rst_n : out std_logic;  -- main reste, sync to clk_p
    
    --etxclk : in std_logic;
    --erxclk : in std_logic;

    pg_1_i : in std_logic;
    pf_1_i : in std_logic;

    clock_in_off : in std_logic;
    sel_pll      : in std_logic;
    spi_sel_pll  : in std_logic;
    spi_override_pll_locked : in std_logic;
    pll_locked   : in std_logic;

    scan_mode : in std_logic
    );

end entity clock_reset;

architecture rtl of clock_reset is

  signal clk_mux_out_int : std_logic;
  signal clk_mux_out_int_d : std_logic;

  signal common_rst_n : std_logic;
  signal common_1_rst_n, common_2_rst_n : std_logic;
  signal main_rst_n : std_logic;
  
  signal sel_pll_all      : std_logic;
  
begin  -- architecture rtl

  -----------------------------------
  -- reset section
  ----------------------------------
  common_rst_n <= mreset_n and pwr_ok;
  
  i_rst1_n : entity work.reset_sync 
  port map (
    clk => pll_ref_clk,
 
    scan_mode   => scan_mode,
    a_rst_n     => common_rst_n,
    rst_n       => common_1_rst_n
    );

  i_rst2_n : entity work.reset_sync
  port map (
    clk => pll_clk,
 
    scan_mode   => scan_mode,
    a_rst_n     => common_rst_n,
    rst_n       => common_2_rst_n
    );


  main_rst_n <= (spi_override_pll_locked or pll_locked) and common_rst_n;

  
  i_main_rst_n : entity work.reset_sync
  port map (
    clk => clk_mux_out_int_d,
 
    scan_mode   => scan_mode,
    a_rst_n     => main_rst_n,
    rst_n       => rst_n
    );

  ---------------------------------------
  -- Clock section
  --------------------------------------
  
  sel_pll_all <= mreset_n and pll_locked and spi_sel_pll and not sel_pll;
  
  clk_mux_1 : entity work.clk_mux_top
     port map (
       clk1          => pll_ref_clk,
       clk2          => pll_clk,
       sel           => sel_pll_all,
       rst1_n        => common_1_rst_n,
       rst2_n        => common_2_rst_n,
       clk1_selected => open,
       clk_mux_out   => clk_mux_out_int);

  clk_mux_out_int_d <= clk_mux_out_int;
  
  
  i_clock_gate : entity work.clock_gate  
    generic map (
      fpga_g =>  fpga_g)
    port map (
      clk => clk_mux_out_int,
      en  => not clock_in_off,
      scan_mode => scan_mode,
      clk_out => clk_p
      );


  -- Ethernet clocks
  i_eth_rx_clock_gate : entity work.clock_gate
    
    generic map (
      fpga_g =>  fpga_g)
    port map (
      clk => pg_1_i,
      en  => '1',
      scan_mode => scan_mode,
      clk_out => clk_rx
      );

  i_eth_tx_clock_gate : entity work.clock_gate
    
    generic map (
      fpga_g =>  fpga_g)
    port map (
      clk => pf_1_i,
      en  => '1',
      scan_mode => scan_mode,
      clk_out => clk_tx
      );

  sclk <= spi_sclk;
  sclk_n <= not spi_sclk;

end architecture rtl;
