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
-- Title      : Configuration Register
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pe1_crb.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description:
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version   Author  Description
-- 2005-11-28   1.10      CB      Created
-- 2005-12-21   1.20      CB      Updated the PLLM register for new PLL, added
--                                pll_frange field, increased pll_n and
--                                decreased pll_m.
-- 2006-01-26   1.30      CB      Added the BMEM registers.
-- 2006-02-01   1.40      CB      Added the ld_bmem bit in the RTC register.
-- 2006-02-02   1.41      CB      Changed polarity of the bmem_ce signal.
-- 2006-02-17   1.50      CB      Added IOCTRL register and pad control.
-- 2006-03-08   1.51      CB      Changed pwr_on to pwr_ok.
-- 2006-04-03   1.60      CB      Removed 'freeze' from the PLLC register.
-- 2012-06-14       2.00            MN          add register clk_in_off and clk_main_off in CRB10(7:6) for power management
--                                              change dis_pll_int default value to '1' to use external oscillator instead of RTC clock
-- 2012-08-14   2.10      MN      add register "en_pmem2" for patch tag memory in program ROM
-- 2012-08-28   2.11      MN      add router control register in CRB12
-- 2013-01-16       2.12            MN          add sdram_en signal in CRB10 to enable the off-chip sdram
-- 2013-01-17       2.13            MN          change bmem_a8 to core2_en to enable the second pe1_core
-- 2013-01-23       2.14            MN          change bmem_we_n to short_cycle for sdram
-- 2013-02-13       5.0             MN          change clk_e with clk_p and clk_e_pos
-- 2014-10-28       6.0             MN          chang bmem back, remove router control, add memory partition bits
-- 2015-07-09       6.1             MN          add crb_out for core2, core2 can read CRB register, but can not write
-- 2015-08-10       6.2             MN          change default value of en_d and fast_d to 1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pe1_crb is
  port (
    -- Clock and reset functions
    clk_p       : in  std_logic;
    clk_e_pos    : in  std_logic;  -- Execution clock
    rst_cn      : in  std_logic;  -- Asynchronous master reset
    rst_seqc_n  : in  std_logic;  -- Reset from CLC (active low)
    mreset      : in  std_logic;  -- MRESET pin reset (active low)
    pwr_ok      : in  std_logic;  -- Power-on reset (active low)
    -- Microprogram control
    pl          : in  std_logic_vector(127 downto 0);  --from the microprogram word
    -- Other control inputs
    ld_crb      : in  std_logic;  -- Load data in CRB reg from D bus, from CLC
    rd_crb      : in  std_logic;  -- Output CRB reg on crb_out, from DSL
    --mwake_i     : in  std_logic;  -- Wake-up signal from external pin
    -- Data paths
    dbus        : in  std_logic_vector(7 downto 0); -- D bus, from DSL
    state_ps3   : in  std_logic_vector(4 downto 0); -- State of prescaler 3, from TIM
    crb_out     : out std_logic_vector(7 downto 0); -- CRB output, to DSL
    -- Static control outputs
    -- CCFF register
    speed_i     : out std_logic_vector(1 downto 0);
    en_wdog     : out std_logic;
    pup_clk     : out std_logic;
    pup_irq     : out std_logic_vector(1 downto 0);
    en_i        : out std_logic;
    -- MORG register
    --r_size      : out std_logic_vector(1 downto 0);
    --c_size      : out std_logic_vector(1 downto 0);
    --dqm_size    : out std_logic_vector(1 downto 0);
    -- MTIM register
    fast_d      : out std_logic;
    t_ras       : out std_logic_vector(2 downto 0);
    t_rcd       : out std_logic_vector(1 downto 0);
    t_rp        : out std_logic_vector(1 downto 0);
    -- PLLC register
    --en_tiu      : out std_logic;
    dis_pll     : out std_logic;
    --dis_xosc    : out std_logic;
    --clk_sel    : out std_logic;
    -- PLLM register
    -- SECC register
    en_s        : out std_logic;
    speed_s     : out std_logic_vector(1 downto 0);
    -- PMXC register
    --adc_dac     : out std_logic;
    --en_iobus    : out std_logic_vector(1 downto 0);
    -- UACC register
    adc_ref2v   : out std_logic;  -- Select 2V internal ADC reference (1V)
    speed_u     : out std_logic_vector(6 downto 0);
    -- PSC1 register
    speed_ps1   : out std_logic_vector(3 downto 0);
    speed_ps2   : out std_logic_vector(5 downto 0);
    -- PSC2 register
    speed_ps3   : out std_logic_vector(4 downto 0);
    en_mckout1  : out std_logic;
    -- power management register added in 2012-06-14 16:29:32 by maning
    --clk_in_off  : out std_logic;
    --clk_main_off : out std_logic;

    core2_en    : out std_logic;
    crb_out_c2  : out std_logic_vector(7 downto 0); -- CRB output, to DSL in core2_en
    crb_sel_c2  : in std_logic_vector(3 downto 0); -- CRB output select, from core2
    short_cycle : out std_logic;
    -- RTC block interface
    poweron_finish   : in std_logic; -- differ start from begginning or halt mode
    nap_rec     : in std_logic;  -- will recover from nap mode
    halt_en     : out std_logic;
    nap_en      : out std_logic);  -- Latch enable to the en_bmem latch
end;

architecture rtl of pe1_crb is
  signal crb_sel        : std_logic_vector(3 downto 0);
  --signal en_pmem_int    : std_logic;
  signal speed_i_int    : std_logic_vector(1 downto 0);
  signal en_wdog_int    : std_logic;
  signal pup_clk_int    : std_logic;
  signal pup_irq_int    : std_logic_vector(1 downto 0);
  signal en_i_int       : std_logic;
  --signal r_size_int     : std_logic_vector(1 downto 0);
  --signal c_size_int     : std_logic_vector(1 downto 0);
  --signal dqm_size_int   : std_logic_vector(1 downto 0);
  signal fast_d_int     : std_logic;
  signal t_ras_int      : std_logic_vector(2 downto 0);
  signal t_rcd_int      : std_logic_vector(1 downto 0);
  signal t_rp_int       : std_logic_vector(1 downto 0);
--  signal en_tiu_int     : std_logic;
  signal dis_pll_int    : std_logic;
--  signal dis_xosc_int   : std_logic;
--  signal en_mexec_int   : std_logic;
--  signal clk_sel_int    : std_logic;-- change en_mexec to clk_sel
  signal en_s_int       : std_logic;
  signal speed_s_int    : std_logic_vector(1 downto 0);
  signal security       : std_logic;
  signal stick          : std_logic_vector(3 downto 0);
--  signal adc_dac_int    : std_logic;
--  signal en_iobus_int   : std_logic_vector(1 downto 0);
  signal adc_ref2v_int  : std_logic;
  signal speed_u_int    : std_logic_vector(6 downto 0);
  signal speed_ps1_int  : std_logic_vector(3 downto 0);
  signal speed_ps2_int  : std_logic_vector(5 downto 0);
  signal speed_ps3_int  : std_logic_vector(4 downto 0);
  signal en_mckout1_int : std_logic;
  --signal clk_in_off_int   : std_logic;
  --signal clk_main_off_int   : std_logic;
  --signal d_hi_int       : std_logic;
  --signal d_sr_int       : std_logic;
  --signal p1_hi_int      : std_logic;
  --signal p1_sr_int      : std_logic;
  --signal p2_hi_int      : std_logic;
  --signal p2_sr_int      : std_logic;
  --signal p3_hi_int      : std_logic;
  --signal p3_sr_int      : std_logic;
--  signal router_ir_en_int : std_logic;                    --delete by HYX, 20141027
--  signal north_en_int   : std_logic;--router lines enable  --delete by HYX, 20141027
--  signal south_en_int   : std_logic;                       --delete by HYX, 20141027
--  signal west_en_int    : std_logic;                        --delete by HYX, 20141027
--  signal east_en_int    : std_logic;                        --delete by HYX, 20141027
--  signal router_clk_en_int  : std_logic;                  --delete by HYX, 20141027
  signal core2_en_int : std_logic;
--  signal ram_partition_int: std_logic_vector(3 downto 0);
  signal halt_en_int  : std_logic;
  signal nap_en_int  : std_logic;
  signal short_cycle_int : std_logic;
  signal pl_sig15 : std_logic_vector(3 downto 0);
begin
  pl_sig15 <= pl(6)&pl(54)&pl(27)&pl(49);
  process (clk_p, rst_cn, ld_crb, pl_sig15, dbus)
  begin
    if rst_cn = '0' then
      -- CCFF register
      --en_pmem_int   <= '0';
      speed_i_int   <= "00";
      en_wdog_int   <= '0';
      pup_clk_int   <= '0';
      pup_irq_int   <= "00";
      en_i_int      <= '0';
      -- MORG register
      --r_size_int    <= "00";
      --c_size_int    <= "00";
      --dqm_size_int  <= "00";
      -- MTIM register
      fast_d_int    <= '1';  --change default value to 1
      t_ras_int     <= "111";
      t_rcd_int     <= "11";
      t_rp_int      <= "11";
      -- PLLC register
      --en_tiu_int    <= '0';
      dis_pll_int   <= '0'; -- change default value to '1' by HYX, 20141115
      --clk_sel_int  <= '0';--select PLL
      -- PLLM register
      -- SECC register
      en_s_int      <= '1';
      speed_s_int   <= "00";
      security      <= '0';
      stick(2)      <= '0';
      -- PMXC register
      --adc_dac_int   <= '0';
      --en_iobus_int  <= "00";
      -- UACC register
      adc_ref2v_int <= '1';
      speed_u_int   <= "0000000";
      -- PSC1 register
      speed_ps1_int   <= "1111";
      speed_ps2_int   <= "111111";
      -- PSC2 register
      speed_ps3_int   <= "11111";
      en_mckout1_int  <= '0';
      -- off chip sdram enable
      -- IOCTRL register
      --d_hi_int  <= '0';
      --d_sr_int  <= '0';
      --p1_hi_int <= '0';
      --p1_sr_int <= '0';
      --p2_hi_int <= '0';
      --p2_sr_int <= '0';
      --p3_hi_int <= '0';
      --p3_sr_int <= '0';
    --router control
      core2_en_int <= '0';
      halt_en_int <= '0';                 -- added bu HYX, 20150707
      short_cycle_int <= '0';
    elsif rising_edge(clk_p) then   -- Register based implementation
      if ld_crb = '1' and clk_e_pos = '0' then
        case pl_sig15 is
          when "0000" => -- CCFF register
            --en_pmem_int   <= dbus(7);
            speed_i_int   <= dbus(6 downto 5);
            en_wdog_int   <= dbus(4);
            pup_clk_int   <= dbus(3);
            pup_irq_int   <= dbus(2 downto 1);
            en_i_int      <= dbus(0);
          --when "0001" => -- MORG register
          --  r_size_int    <= dbus(5 downto 4);
          --  c_size_int    <= dbus(3 downto 2);
          --  dqm_size_int  <= dbus(1 downto 0);
          when "0010" => -- MTIM register
            fast_d_int    <= dbus(7);
            t_ras_int     <= dbus(6 downto 4);
            t_rcd_int     <= dbus(3 downto 2);
            t_rp_int      <= dbus(1 downto 0);
          when "0011" => -- PLLC register
            --en_tiu_int    <= dbus(7);
            dis_pll_int   <= dbus(5);
--          dis_xosc_int  <= dbus(4); -- In the next process due to different reset
            --clk_sel_int  <= dbus(0);
          --when "0100" => -- PLLM register
          when "0101" => -- SECC register
            en_s_int      <= dbus(7);
            speed_s_int   <= dbus(6 downto 5);
            if dbus(4) = '1' then security  <= '1'; end if; -- Unclearable by pe1_mpgm
--          if dbus(3) = '1' then stick(3)  <= '1'; end if; -- In the next process due to different reset
            if dbus(2) = '1' then stick(2)  <= '1'; end if; -- Unclearable by pe1_mpgm
--          if dbus(1) = '1' then stick(1)  <= '1'; end if; -- In the next process due to different reset
--          if dbus(0) = '1' then stick(0)  <= '1'; end if; -- In the next process due to different reset
          --when "0110" => -- PMXC register
            --adc_dac_int   <= dbus(7);
            --en_iobus_int  <= dbus(1 downto 0);
          when "0111" => -- UACC register
            adc_ref2v_int <= dbus(7);
            speed_u_int   <= dbus(6 downto 0);
          when "1000" => -- PSC1 register
            speed_ps1_int             <= dbus(7 downto 4);
            speed_ps2_int(5 downto 2) <= dbus(3 downto 0);
          when "1001" => -- PSC2 register
            speed_ps2_int(1 downto 0) <= dbus(7 downto 6);
            speed_ps3_int             <= dbus(5 downto 1);
            en_mckout1_int            <= dbus(0);
          --when "1010" => -- off chip sdram enable
          --when "1011" => -- IOCTRL register
          --  d_hi_int  <= dbus(7);
          --  d_sr_int  <= dbus(6);
          --  p1_hi_int <= dbus(5);
          --  p1_sr_int <= dbus(4);
          --  p2_hi_int <= dbus(3);
          --  p2_sr_int <= dbus(2);
          --  p3_hi_int <= dbus(1);
          --  p3_sr_int <= dbus(0);
          when "1100" =>
      --router control
--      router_ir_en_int <= dbus(7);       --delete by HYX, 20141027
--      north_en_int <= dbus(6);           --delete by HYX, 20141027
--      south_en_int <= dbus(5);           --delete by HYX, 20141027
--      west_en_int <= dbus(4);            --delete by HYX, 20141027
--      east_en_int <= dbus(3);            --delete by HYX, 20141027
--      router_clk_en_int <= dbus(2);      --delete by HYX, 20141027
        --  if dbus(7) = '0' then
        --    if c2_ready = '1' then
              core2_en_int <= dbus(7);
        --    else
        --      core2_en_int <= core2_en_int;
        --    end if;
        --  else
        --    core2_en_int <= dbus(7);
        --  end if;
--            ram_partition_int <= dbus(6 downto 3);
            halt_en_int <= dbus(3);           -- added bu HYX, 20150707
            short_cycle_int <= dbus(2);

          --when "1101" => -- BMEM data
          --when "1111" => -- RTC control
          --  rst_rtc <= dbus(7);
          --  en_fclk <= dbus(6);
          --  fclk    <= dbus(5);
          --  rtc_sel <= dbus(2 downto 0);
          when others =>
            NULL;
        end case;
      end if;
    end if;
  end process;
------------------------------maning add the following for power management-------------------------------
--process (clk_p, rst_cn, ld_crb, pl_sig15, dbus, reqrun)
--  begin
--    if rst_cn = '0' or reqrun = '1' then
--      clk_in_off_int <= '0';
--      clk_main_off_int <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
--    elsif rising_edge(clk_p) then   -- Register based implementation
--      if ld_crb = '1' and clk_e_pos = '0' then
--        case pl_sig15 is
--          when "1010" => -- power management register
--            clk_in_off_int <= dbus(7);
--            clk_main_off_int <= dbus(6);
--          when others =>
--            NULL;
--        end case;
--      end if;
--    end if;
--  end process;

process (clk_p, rst_cn, ld_crb, pl_sig15, dbus, nap_rec)
  begin
    if rst_cn = '0' or nap_rec = '1'then  --both reset and nap_rec will clear the nap_en bit
      nap_en_int <= '0';
    elsif rising_edge(clk_p) then   -- Register based implementation
      if ld_crb = '1' and clk_e_pos = '0' then
        case pl_sig15 is
          when "1100" => --
            nap_en_int <= dbus(4);
          when others =>
            NULL;
        end case;
      end if;
    end if;
  end process;

--------------------------------------------end by maning-------------------------------------------------

  -- CE to BMEM active when BMEM address is written

  -- This process handles the 'dis_xosc' bit in the PLLC register,
  -- because its reset differs from most of the CRB register bits.
  --process (clk_p, rst_cn, mwake_i, ld_crb, pl_sig15, dbus)
  --begin
  --  if rst_cn = '0' or mwake_i = '1' then
      -- PLLC register, dis_xosc also reset by MWAKE pin
  --    dis_xosc_int  <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
  --  elsif rising_edge(clk_p) then   -- Register based implementation
  --    if ld_crb = '1' and pl_sig15 = "0011" and clk_e_pos = '0' then        -- PLLC register
  --      dis_xosc_int <= dbus(4);
  --    end if;
  --  end if;
  --end process;

  -- This process handles the 'stick(3)' bit in the SECC register,
  -- because its reset differs from most of the CRB register bits.
  process (clk_p, rst_seqc_n, ld_crb, pl_sig15, dbus)
  begin
--  if clk_e = '0' then          -- Latch based implementation
    if rising_edge(clk_p) then   -- Register based implementation
      if (clk_e_pos = '0') then
        if rst_seqc_n = '0' then
              -- SECC register, stick(3) synchronous reset by rst_seqc_n
          stick(3)  <= '0';
        elsif ld_crb = '1' and pl_sig15 = "0101" then     -- SECC register
          if dbus(3) = '1' then
            stick(3)  <= '1';
          end if; -- Unclearable by pe1_mpgm
        end if;
      end if;
    end if;
  end process;

  -- This process handles the 'stick(1)' bit in the SECC register,
  -- because its reset differs from most of the CRB register bits.
  process (clk_p, mreset, pwr_ok, ld_crb, pl_sig15, dbus)
  begin
    if mreset = '0' or pwr_ok = '0' then
      -- SECC register, stick(1) reset by mreset or pwr_ok
      stick(1)  <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
    elsif rising_edge(clk_p) then   -- Register based implementation
      if ld_crb = '1' and pl_sig15 = "0101" and clk_e_pos = '0' then        -- SECC register
        if dbus(1) = '1' then
          stick(1)  <= '1';
        end if; -- Unclearable by pe1_mpgm
      end if;
    end if;
  end process;

  -- This process handles the 'stick(0)' bit in the SECC register,
  -- because its reset differs from most of the CRB register bits.
  process (clk_p, pwr_ok, ld_crb, pl_sig15, dbus)
  begin
    if pwr_ok = '0' then
      -- SECC register, stick(0) reset by pwr_ok
      stick(0)  <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
    elsif rising_edge(clk_p) then   -- Register based implementation
      if ld_crb = '1' and pl_sig15 = "0101" and clk_e_pos = '0' then        -- SECC register
        if dbus(0) = '1' then
          stick(0)  <= '1';
        end if; -- Unclearable by pe1_mpgm
      end if;
    end if;
  end process;

  -- Make CRB mux stand still when not reading CRB.
  crb_sel <=  pl_sig15 when rd_crb = '1' else
              "0000";

--234567890123456789012345678901234567890123456789012345678901234567890123456789
  process (crb_sel, speed_i_int, en_wdog_int, pup_clk_int,
           en_i_int, fast_d_int,
           t_ras_int, t_rcd_int, dis_pll_int,
           en_s_int, speed_s_int, security,
           stick, pup_irq_int,
           adc_ref2v_int, speed_u_int,
           speed_ps1_int, speed_ps2_int, speed_ps3_int, en_mckout1_int, state_ps3,
           core2_en_int , nap_en_int,poweron_finish,short_cycle_int)--
  begin
    crb_out <= x"00";
    case crb_sel is
      when "0000" => -- CCFF register
        --crb_out(7)          <= en_pmem_int;
        crb_out(6 downto 5) <= speed_i_int;
        crb_out(4)          <= en_wdog_int;
        crb_out(3)          <= pup_clk_int;
        crb_out(2 downto 1) <= pup_irq_int;
        crb_out(0)          <= en_i_int;
      --when "0001" => -- MORG register
      --  crb_out(5 downto 4) <= r_size_int;
      --  crb_out(3 downto 2) <= c_size_int;
      --  crb_out(1 downto 0) <= dqm_size_int;
      when "0010" => -- MTIM register
        crb_out(7)          <= fast_d_int;
        crb_out(6 downto 4) <= t_ras_int;
        crb_out(3 downto 2) <= t_rcd_int;
        crb_out(1 downto 0) <= t_rcd_int;
      when "0011" => -- PLLC register
        --crb_out(7)          <= en_tiu_int;
        crb_out(5)          <= dis_pll_int;
        --crb_out(4)          <= dis_xosc_int;
        --crb_out(0)          <= clk_sel_int;
      --when "0100" => -- PLLM register
      when "0101" => -- SECC register
        crb_out(7)          <= en_s_int;
        crb_out(6 downto 5) <= speed_s_int;
        crb_out(4)          <= security;
        crb_out(3 downto 0) <= stick;
      --when "0110" => -- PMXC register
        --crb_out(7)          <= adc_dac_int;
        --crb_out(1 downto 0) <= en_iobus_int;
      when "0111" => -- UACC register
        crb_out(7)          <= adc_ref2v_int;
        crb_out(6 downto 0) <= speed_u_int;
      when "1000" => -- PSC1 register
        crb_out(7 downto 4) <= speed_ps1_int;
        crb_out(3 downto 0) <= speed_ps2_int(5 downto 2);
      when "1001" => -- PSC2 register
        crb_out(7 downto 6) <= speed_ps2_int(1 downto 0);
        crb_out(5 downto 1) <= speed_ps3_int;
        crb_out(0)          <= en_mckout1_int;
      when "1010" => -- PSS register
        --crb_out(7) <= clk_in_off_int;
        --crb_out(6) <= clk_main_off_int;
        crb_out(4 downto 0) <= state_ps3;
      --when "1011" => -- IOCTRL register
      --  crb_out(7)          <= d_hi_int;
      --  crb_out(6)          <= d_sr_int;
      --  crb_out(5)          <= p1_hi_int;
      --  crb_out(4)          <= p1_sr_int;
      --  crb_out(3)          <= p2_hi_int;
      --  crb_out(2)          <= p2_sr_int;
      --  crb_out(1)          <= p3_hi_int;
      --  crb_out(0)          <= p3_sr_int;
      when "1100" => -- BMEM control
--    crb_out(7)      <= router_ir_en_int;       --delete by HYX, 20141027
--    crb_out(6)      <= north_en_int;           --delete by HYX, 20141027
--    crb_out(5)      <= south_en_int;           --delete by HYX, 20141027
--    crb_out(4)      <= west_en_int;            --delete by HYX, 20141027
--    crb_out(3)      <= east_en_int;            --delete by HYX, 20141027
--    crb_out(2)      <= router_clk_en_int;      --delete by HYX, 20141027

        crb_out(7)      <= core2_en_int;
--        crb_out(6 downto 3) <= ram_partition_int;
        crb_out(4)          <= nap_en_int;
        crb_out(3)          <= poweron_finish;
        crb_out(2)          <= short_cycle_int;
      --when "1101" => -- BMEM data
      --  crb_out             <= bmem_q;
      --when "1111" => -- RTC data
      --  crb_out             <= rtc_data;
      when others =>
        NULL;
    end case;
  end process;

--234567890123456789012345678901234567890123456789012345678901234567890123456789
  process (crb_sel_c2, speed_i_int, en_wdog_int, pup_clk_int,
           en_i_int, fast_d_int,
           t_ras_int, t_rcd_int, dis_pll_int,
           en_s_int, speed_s_int, security,
           stick, pup_irq_int,
           adc_ref2v_int, speed_u_int,
           speed_ps1_int, speed_ps2_int, speed_ps3_int, en_mckout1_int, state_ps3,
           core2_en_int , nap_en_int,poweron_finish,short_cycle_int)--
  begin
    crb_out_c2 <= x"00";
    case crb_sel_c2 is
      when "0000" => -- CCFF register
        --crb_out_c2(7)          <= en_pmem_int;
        crb_out_c2(6 downto 5) <= speed_i_int;
        crb_out_c2(4)          <= en_wdog_int;
        crb_out_c2(3)          <= pup_clk_int;
        crb_out_c2(2 downto 1) <= pup_irq_int;
        crb_out_c2(0)          <= en_i_int;
      --when "0001" => -- MORG register
      --  crb_out_c2(5 downto 4) <= r_size_int;
      --  crb_out_c2(3 downto 2) <= c_size_int;
      --  crb_out_c2(1 downto 0) <= dqm_size_int;
      when "0010" => -- MTIM register
        crb_out_c2(7)          <= fast_d_int;
        crb_out_c2(6 downto 4) <= t_ras_int;
        crb_out_c2(3 downto 2) <= t_rcd_int;
        crb_out_c2(1 downto 0) <= t_rcd_int;
      when "0011" => -- PLLC register
        --crb_out_c2(7)          <= en_tiu_int;
        crb_out_c2(5)          <= dis_pll_int;
        --crb_out_c2(4)          <= dis_xosc_int;
        --crb_out_c2(0)          <= clk_sel_int;
      --when "0100" => -- PLLM register
      when "0101" => -- SECC register
        crb_out_c2(7)          <= en_s_int;
        crb_out_c2(6 downto 5) <= speed_s_int;
        crb_out_c2(4)          <= security;
        crb_out_c2(3 downto 0) <= stick;
      --when "0110" => -- PMXC register
        --crb_out_c2(7)          <= adc_dac_int;
        --crb_out_c2(1 downto 0) <= en_iobus_int;
      when "0111" => -- UACC register
        crb_out_c2(7)          <= adc_ref2v_int;
        crb_out_c2(6 downto 0) <= speed_u_int;
      when "1000" => -- PSC1 register
        crb_out_c2(7 downto 4) <= speed_ps1_int;
        crb_out_c2(3 downto 0) <= speed_ps2_int(5 downto 2);
      when "1001" => -- PSC2 register
        crb_out_c2(7 downto 6) <= speed_ps2_int(1 downto 0);
        crb_out_c2(5 downto 1) <= speed_ps3_int;
        crb_out_c2(0)          <= en_mckout1_int;
      when "1010" => -- PSS register
        --crb_out_c2(7) <= clk_in_off_int;
        --crb_out_c2(6) <= clk_main_off_int;
        crb_out_c2(4 downto 0) <= state_ps3;
      --when "1011" => -- IOCTRL register
        --crb_out_c2(7)          <= d_hi_int;
        --crb_out_c2(6)          <= d_sr_int;
        --crb_out_c2(5)          <= p1_hi_int;
        --crb_out_c2(4)          <= p1_sr_int;
        --crb_out_c2(3)          <= p2_hi_int;
        --crb_out_c2(2)          <= p2_sr_int;
        --crb_out_c2(1)          <= p3_hi_int;
        --crb_out_c2(0)          <= p3_sr_int;
      when "1100" => -- BMEM control
--    crb_out(7)      <= router_ir_en_int;       --delete by HYX, 20141027
--    crb_out(6)      <= north_en_int;           --delete by HYX, 20141027
--    crb_out(5)      <= south_en_int;           --delete by HYX, 20141027
--    crb_out(4)      <= west_en_int;            --delete by HYX, 20141027
--    crb_out(3)      <= east_en_int;            --delete by HYX, 20141027
--    crb_out(2)      <= router_clk_en_int;      --delete by HYX, 20141027

        crb_out_c2(7)      <= core2_en_int;
--        crb_out(6 downto 3) <= ram_partition_int;
        crb_out_c2(4)          <= nap_en_int;
        crb_out_c2(3)          <= poweron_finish;
        crb_out_c2(2)          <= short_cycle_int;
      --when "1101" => -- BMEM data
      --  crb_out_c2             <= bmem_q;
      --when "1111" => -- RTC data
      --  crb_out_c2             <= rtc_data;
      when others =>
        NULL;
    end case;
  end process;

  speed_i     <= speed_i_int;
  en_wdog     <= en_wdog_int;
  pup_clk     <= pup_clk_int;
  pup_irq     <= pup_irq_int;
  en_i        <= en_i_int;
  --r_size      <= r_size_int;
  --c_size      <= c_size_int;
  --dqm_size    <= dqm_size_int;
  fast_d      <= fast_d_int;
  t_ras       <= t_ras_int;
  t_rcd       <= t_rcd_int;
  t_rp        <= t_rp_int;
  --en_tiu      <= en_tiu_int;
  dis_pll     <= dis_pll_int;
  --dis_xosc    <= dis_xosc_int;
  --clk_sel    <= clk_sel_int;
  en_s        <= en_s_int and not security;
  speed_s     <= speed_s_int;
  --adc_dac     <= adc_dac_int;
  --en_iobus    <= en_iobus_int;
  adc_ref2v   <= adc_ref2v_int;
  speed_u     <= speed_u_int;
  speed_ps1   <= speed_ps1_int;
  speed_ps2   <= speed_ps2_int;
  speed_ps3   <= speed_ps3_int;
  en_mckout1  <= en_mckout1_int;
  --clk_in_off <= clk_in_off_int;
  --clk_main_off <= clk_main_off_int;
  --d_hi        <= d_hi_int;
  --d_sr        <= d_sr_int;
  --p1_hi       <= p1_hi_int;
  --p1_sr       <= p1_sr_int;
  --p2_hi       <= p2_hi_int;
  --p2_sr       <= p2_sr_int;
  --p3_hi       <= p3_hi_int;
  --p3_sr       <= p3_sr_int;
  short_cycle <= short_cycle_int;
  halt_en     <= halt_en_int;
  nap_en      <= nap_en_int;
  core2_en <= core2_en_int;
--  ram_partition <= ram_partition_int;

  --d_lo    <= not d_hi_int;

end;
