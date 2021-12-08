library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity rtc_iso is
    port (     
      pwr_ok    : in  std_logic;  -- Core power indicator, controls mrxout_o
      rst_rtc   : in  std_logic;  -- Reset RTC counter byte            
      en_fclk   : in  std_logic;  -- Enable fast clocking of RTC counter byte
      fclk      : in  std_logic;  -- Fast clock to RTC counter byte   
      ld_bmem   : in  std_logic;  -- Latch enable to the dis_bmem latch   
      rtc_sel   : in  std_logic_vector(2 downto 0);   -- RTC byte select
      rst_rtc_ok : out std_logic;
      en_fclk_ok : out std_logic;
      fclk_ok : out std_logic;
      ld_bmem_ok : out std_logic;
      rtc_sel_ok : out std_logic_vector(2 downto 0));
end rtc_iso;

architecture rtl of rtc_iso is

begin

	-- All input signals are gated off using pwr_ok, make
	-- sure this is synthezised into simple AND gates!
      rst_rtc_ok	      <= rst_rtc and pwr_ok;
      en_fclk_ok	      <= en_fclk and pwr_ok;
      fclk_ok			      <= fclk and pwr_ok;
      ld_bmem_ok	      <= ld_bmem and pwr_ok;
      rtc_sel_ok(0)   <= rtc_sel(0) and pwr_ok;
      rtc_sel_ok(1)   <= rtc_sel(1) and pwr_ok;
      rtc_sel_ok(2)   <= rtc_sel(2) and pwr_ok;
  
end rtl;

