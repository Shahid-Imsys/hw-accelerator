library ieee;
use ieee.std_logic_1164.all;

entity clock_reset is
 
  generic (
    fpga_g : boolean := false);
  port (
    pll_clk : in  std_ulogic;
    enet_clk : in  std_logic;
    clk_p   : out std_logic;
    clk_rx  : out std_logic;
    clk_tx  : out std_logic;

    clock_in_off : in std_logic;

    scan_mode : in std_logic
    );

end entity clock_reset;

architecture rtl of clock_reset is

begin  -- architecture rtl

  -- clk_mux_1 : clk_mux
  --   port map (
  --     clk1          => pll_ref_clk,
  --     clk2          => pll_clk,
  --     sel           => sel_pll,
  --     rst_n         => lp_pwr_ok,
  --     clk1_selected => xout_selected,
  --     clk_mux_out   => clk_mux_out_int);
  
  i_clock_gate : entity work.clock_gate
    
    generic map (
      fpga_g =>  fpga_g)
    port map (
      clk => pll_clk,
      en  => not clock_in_off,
      scan_mode => scan_mode,
      clk_out => clk_p
      );

    clk_rx <= enet_clk;
    clk_tx <= enet_clk;


end architecture rtl;
