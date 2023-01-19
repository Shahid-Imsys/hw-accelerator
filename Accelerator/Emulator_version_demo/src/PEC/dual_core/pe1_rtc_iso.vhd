library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity pe1_rtc_iso is
    port (
      iso             : in  std_logic;  -- isolation controll signal, active high
      clk_iso         : in  std_logic;
	  -- signals to be isolated
      halt_en         : in  std_logic;
      nap_en          : in  std_logic;
      clk_mux_out     : in  std_logic;

          --gmem1
      c1_gmem_a         : in    std_logic_vector(9 downto 0);
      c1_gmem_d         : in    std_logic_vector(7 downto 0);
      c1_gmem_we_n      : in    std_logic;
      c1_gmem_ce_n      : in    std_logic;

      --gmem2
      c2_gmem_a         : in    std_logic_vector(9 downto 0);
      c2_gmem_d         : in    std_logic_vector(7 downto 0);
      c2_gmem_we_n      : in    std_logic;
      c2_gmem_ce_n      : in    std_logic;

      --bmem
      dbus              : in    std_logic_vector(7 downto 0);

      halt_en_iso_0     : out std_logic;
      nap_en_iso_0      : out std_logic;


      c1_gmem_a_iso_0   : out std_logic_vector(9 downto 0);
      c1_gmem_d_iso_0   : out std_logic_vector(7 downto 0);

      c2_gmem_a_iso_0   : out std_logic_vector(9 downto 0);
      c2_gmem_d_iso_0   : out std_logic_vector(7 downto 0);

      dbus_iso_0        : out std_logic_vector(7 downto 0);

      clk_mux_out_iso_1   : out  std_logic;

      -- signals isolated to 1
      c1_gmem_we_n_iso_1  : out std_logic;
      c1_gmem_ce_n_iso_1  : out std_logic;
      c2_gmem_we_n_iso_1  : out std_logic;
      c2_gmem_ce_n_iso_1  : out std_logic
        );
        --attribute gated_clock : string;
        --attribute gated_clock of clk_mux_out_iso_1 : signal is "true";
end pe1_rtc_iso;

architecture rtl of pe1_rtc_iso is

begin

	-- These input signals are gated off to 0 using iso, make
	-- sure this is synthezised into simple AND gates!
      halt_en_iso_0         <= halt_en          and (not iso);
      nap_en_iso_0          <= nap_en           and (not iso);


      addr_bus_gen : for i in 0 to 9 generate
            c1_gmem_a_iso_0(i) <= c1_gmem_a(i)  and (not iso);
            c2_gmem_a_iso_0(i) <= c2_gmem_a(i)  and (not iso);
      end generate addr_bus_gen;

      data_bus_gen : for i in 0 to 7 generate
            c1_gmem_d_iso_0(i) <= c1_gmem_d(i)  and (not iso);
            c2_gmem_d_iso_0(i) <= c2_gmem_d(i)  and (not iso);
            dbus_iso_0(i) <= dbus(i)            and (not iso);
      end generate data_bus_gen;

      --ram_addr_gen : for i in 0 to 13 generate
      --      RAM0_A_iso_0(i) <= RAM0_A(i)  and (not iso);
      --end generate ram_addr_gen;

      -- These input signals are gated off to 1 using iso, make
      -- sure this is synthezised into simple OR gates!
      clk_mux_out_iso_1  <= clk_mux_out;    -- or iso;
      c1_gmem_we_n_iso_1 <= c1_gmem_we_n    or iso;
      c1_gmem_ce_n_iso_1 <= c1_gmem_ce_n    or iso;
      c2_gmem_we_n_iso_1 <= c2_gmem_we_n    or iso;
      c2_gmem_ce_n_iso_1 <= c2_gmem_ce_n    or iso;


end rtl;

