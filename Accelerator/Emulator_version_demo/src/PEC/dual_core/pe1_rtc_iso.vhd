library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity pe1_rtc_iso is
    port (
      iso             : in  std_logic;  -- isolation controll signal, active high
      clk_iso         : in  std_logic;
	  -- signals to be isolated
      --reset_iso_clear     : in  std_logic;
      halt_en         : in  std_logic;
      nap_en          : in  std_logic;
      --sel_pll         : in  std_logic;
      pllout          : in  std_logic;
      --rst_rtc         : in  std_logic;  -- Reset RTC counter byte
      --en_fclk         : in  std_logic;  -- Enable fast clocking of RTC counter byte
      --fclk            : in  std_logic;  -- Fast clock to RTC counter byte
      ld_bmem         : in  std_logic;  -- Latch enable to the dis_bmem latch
      --rtc_sel         : in  std_logic_vector(2 downto 0);   -- RTC byte select
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
      bmem_a8           : in    std_logic;
      bmem_d            : in    std_logic_vector(7 downto 0);
      bmem_we_n         : in    std_logic;
      bmem_ce_n         : in    std_logic;

	  --RAM0
	--  RAM0_DI           : in    std_logic_vector(7 downto 0);
      --RAM0_A            : in    std_logic_vector(13 downto 0);
      --RAM0_WEB          : in    std_logic;
      --RAM0_CS           : in    std_logic;

      -- signals isolated to 0
      --sel_pll_iso_0   : out std_logic;
      --rst_rtc_iso_0   : out std_logic;
      --en_fclk_iso_0   : out std_logic;
      --fclk_iso_0      : out std_logic;
      ld_bmem_iso_0   : out std_logic;
      --rtc_sel_iso_0   : out std_logic_vector(2 downto 0);
      --reset_iso_clear_iso_0   : out std_logic;
      halt_en_iso_0     : out std_logic;
      nap_en_iso_0      : out std_logic;


      c1_gmem_a_iso_0   : out std_logic_vector(9 downto 0);
      c1_gmem_d_iso_0   : out std_logic_vector(7 downto 0);

      c2_gmem_a_iso_0   : out std_logic_vector(9 downto 0);
      c2_gmem_d_iso_0   : out std_logic_vector(7 downto 0);

      dbus_iso_0        : out std_logic_vector(7 downto 0);
      bmem_a8_iso_0     : out std_logic;
      bmem_d_iso_0      : out std_logic_vector(7 downto 0);

	--  RAM0_DI_iso_0       : out    std_logic_vector(7 downto 0);
	--  RAM0_A_iso_0        : out    std_logic_vector(13 downto 0);
      --RAM0_CS_iso_0       : out    std_logic;

      clk_mux_out_iso_1   : out  std_logic;
	--  pllout_iso_1    	  : out std_logic;

      -- signals isolated to 1
      c1_gmem_we_n_iso_1  : out std_logic;
      c1_gmem_ce_n_iso_1  : out std_logic;
      c2_gmem_we_n_iso_1  : out std_logic;
      c2_gmem_ce_n_iso_1  : out std_logic;
      bmem_we_n_iso_1     : out std_logic;
      bmem_ce_n_iso_1     : out std_logic
	--  RAM0_WEB_iso_1      : out std_logic
        );
        --attribute gated_clock : string;
        --attribute gated_clock of clk_mux_out_iso_1 : signal is "true";
end pe1_rtc_iso;

architecture rtl of pe1_rtc_iso is

begin

	-- These input signals are gated off to 0 using iso, make
	-- sure this is synthezised into simple AND gates!
      --sel_pll_iso_0         <= sel_pll          and (not iso);
      --rst_rtc_iso_0	        <= rst_rtc          and (not iso);
      --en_fclk_iso_0	        <= en_fclk          and (not iso);
      --fclk_iso_0	        <= fclk             and (not iso);
      ld_bmem_iso_0	        <= ld_bmem          and (not iso);
      --rtc_sel_iso_0(0)      <= rtc_sel(0)       and (not iso);
      --rtc_sel_iso_0(1)      <= rtc_sel(1)       and (not iso);
      --rtc_sel_iso_0(2)      <= rtc_sel(2)       and (not iso);
      --reset_iso_clear_iso_0 <= reset_iso_clear  and (not iso);
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
            bmem_d_iso_0(i) <= bmem_d(i)        and (not iso);
		--	RAM0_DI_iso_0(i)   <= RAM0_DI(i)	and (not iso);
      end generate data_bus_gen;

      --ram_addr_gen : for i in 0 to 13 generate
      --      RAM0_A_iso_0(i) <= RAM0_A(i)  and (not iso);
      --end generate ram_addr_gen;

      --bmem_a8_iso_0  <= bmem_a8                 and (not iso);
	--  RAM0_CS_iso_0  <= RAM0_CS					and (not iso);

      -- These input signals are gated off to 1 using iso, make
      -- sure this is synthezised into simple OR gates!
      clk_mux_out_iso_1  <= clk_mux_out;    -- or iso;
      --pllout_iso_1       <= pllout          or clk_iso;
      c1_gmem_we_n_iso_1 <= c1_gmem_we_n    or iso;
      c1_gmem_ce_n_iso_1 <= c1_gmem_ce_n    or iso;
      c2_gmem_we_n_iso_1 <= c2_gmem_we_n    or iso;
      c2_gmem_ce_n_iso_1 <= c2_gmem_ce_n    or iso;
      --bmem_we_n_iso_1   <= bmem_we_n        or iso;
      --bmem_ce_n_iso_1   <= bmem_ce_n        or iso;
	--  RAM0_WEB_iso_1    <= RAM0_WEB         or iso;


end rtl;

