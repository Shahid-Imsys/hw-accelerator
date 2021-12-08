-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : Real Time Clock counter
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : rtc.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The RTC counter is to provide battery powered time keeping
--              while the main power supply is turned off. The counter is
--              consisted of an async 47-bit ripple counter.
--              NOTE: The whole block is powered by Battery! 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.5				CB			Created
-- 2006-02-01		2.6 			CB			Added the en_bmem latch, controlled by the
--																new ld_bmem input port.
-- 2006-03-08		2.7 			CB			Changed pwr_on to pwr_ok, en_bmem to dis_bmem.
-- 2006-05-11		2.8 			CB			Added gate-offs with pwr_ok at all input signals.
-- 2006-05-12		2.9 			CB			Moved gate-offs to a block of their own.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.all;

entity rtc is
  port (
    pwr_ok    : in  std_logic;  -- Core power indicator, controls mrxout_o            
    rxout     : in  std_logic;  -- 32KHz oscillator input         
    mrxout_o  : out std_logic;  -- 32KHz oscillator output or external wake        
    rst_rtc   : in  std_logic;  -- Reset RTC counter byte            
    en_fclk   : in  std_logic;  -- Enable fast clocking of RTC counter byte
    fclk      : in  std_logic;  -- Fast clock to RTC counter byte   
    ld_bmem   : in  std_logic;  -- Latch enable to the dis_bmem latch   
    rtc_sel   : in  std_logic_vector(2 downto 0);  -- RTC byte select
    rtc_data  : out std_logic_vector(7 downto 0);  -- RTC data             
    dis_bmem  : out std_logic);  -- Disable power to BMEM   
end rtc;

architecture rtl of rtc is
  signal cp					: std_logic_vector(46 downto 0);
  signal qn					: std_logic_vector(46 downto 0);

	-- These signals need to be kept through synthesis!
  signal rst_rtc_ok	: std_logic;
  signal en_fclk_ok	: std_logic;
  signal fclk_ok		: std_logic;
  signal ld_bmem_ok	: std_logic;
  signal rtc_sel_ok	: std_logic_vector(2 downto 0);

  attribute syn_keep	: boolean;
  attribute syn_keep of rst_rtc_ok	: signal is true;
  attribute syn_keep of en_fclk_ok	: signal is true;
  attribute syn_keep of fclk_ok			: signal is true;
  attribute syn_keep of ld_bmem_ok	: signal is true;
  attribute syn_keep of rtc_sel_ok	: signal is true;
  
    -- Isolation cells for the rtc
  component rtc_iso
    port (     
      pwr_ok			: in  std_logic;  -- Core power indicator, controls mrxout_o
      rst_rtc			: in  std_logic;  -- Reset RTC counter byte            
      en_fclk			: in  std_logic;  -- Enable fast clocking of RTC counter byte
      fclk				: in  std_logic;  -- Fast clock to RTC counter byte   
      ld_bmem			: in  std_logic;  -- Latch enable to the dis_bmem latch   
      rtc_sel			: in  std_logic_vector(2 downto 0);   -- RTC byte select
      rst_rtc_ok	: out std_logic;
      en_fclk_ok	: out std_logic;
      fclk_ok			: out std_logic;
      ld_bmem_ok	: out std_logic;
      rtc_sel_ok	: out std_logic_vector(2 downto 0));
  end component;  

  
begin  -- rtl

  rtc_iso0: rtc_iso
    port map (
      pwr_ok     => pwr_ok,
      rst_rtc    => rst_rtc,
      en_fclk    => en_fclk,
      fclk       => fclk,
      ld_bmem    => ld_bmem,
      rtc_sel    => rtc_sel,
      rst_rtc_ok => rst_rtc_ok,
      en_fclk_ok => en_fclk_ok,
      fclk_ok    => fclk_ok,
      ld_bmem_ok => ld_bmem_ok,
      rtc_sel_ok => rtc_sel_ok);      

	-- All input signals are gated off using pwr_ok, make
	-- sure this is synthezised into simple AND gates!
--	rst_rtc_ok		<= rst_rtc and pwr_ok;
--	en_fclk_ok		<= en_fclk and pwr_ok;
--	fclk_ok				<= fclk and pwr_ok;
--	ld_bmem_ok		<= ld_bmem and pwr_ok;
--	rtc_sel_ok(0)	<= rtc_sel(0) and pwr_ok;
--	rtc_sel_ok(1)	<= rtc_sel(1) and pwr_ok;
--	rtc_sel_ok(2)	<= rtc_sel(2) and pwr_ok;

	-- Disable latch for the power to BMEM
  process (ld_bmem_ok, rtc_sel_ok)
  begin
		if ld_bmem_ok = '1' then
			dis_bmem <= rtc_sel_ok(0);
		end if;
  end process;

  -- The ripple counter clocks. For setting counter more efficiently, the
  -- counter is split up into 6 parts. 'fclk_ok' may clock these parts separately.
  cp_gen: process (qn, en_fclk_ok, fclk_ok, rxout, rtc_sel_ok)
  begin
    -- Normal clocking. All FF:s in one long ripple counter chain.
    cp(0) <= rxout;
    for i in 1 to 46 loop
      cp(i) <= qn(i - 1);
    end loop;
    -- Fast clocking. The selected byte is clocked by fclk_ok.
    if en_fclk_ok = '1' then
      if rtc_sel_ok = 0 then
        cp(0) <= fclk_ok;
      end if;
      for i in 1 to 5 loop
        if rtc_sel_ok = i then
          cp((i*8)-1) <= fclk_ok;
        end if;
      end loop;
    end if;
  end process cp_gen;

  -- The 47 bits ripple counter.
  async_ripple_counter: for i in 0 to 46 generate
    d_ff: block
    begin  -- block d_ff
      process (cp(i), rst_rtc_ok, rtc_sel_ok)
      begin  -- process
        if rst_rtc_ok = '1' and rtc_sel_ok = ((i+1)/8) then
          qn(i) <= '1';
        elsif rising_edge(cp(i)) then
          qn(i) <= not qn(i);
        end if;
      end process;
    end block d_ff;
  end generate async_ripple_counter;

  -- Mux for the output data. All six bytes of the counter can be read,
  -- the other two rtc_sel_ok combinations output test data.
  with rtc_sel_ok select
    rtc_data <= not qn(6 downto 0) & '0'  when "000",
                not qn(14 downto 7)       when "001",
                not qn(22 downto 15)      when "010",
                not qn(30 downto 23)      when "011",
                not qn(38 downto 31)      when "100",
                not qn(46 downto 39)      when "101",
                rst_rtc_ok & en_fclk_ok & fclk_ok & ld_bmem_ok &
                rtc_sel_ok(0) & rtc_sel_ok(0) & rtc_sel_ok(0) & rtc_sel_ok(0) when others;
  
	-- MRXOUT is now only an external wake-up signal, RTC
	-- oscillator test is done on another pin.
  mrxout_o <= qn(46);
end rtl;
