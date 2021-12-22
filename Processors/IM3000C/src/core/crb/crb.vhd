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
-- File       : crb.vhd
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
-- Date					Version		Author	Description
-- 2005-11-28		1.10			CB			Created
-- 2005-12-21		1.20			CB			Updated the PLLM register for new PLL, added
--																pll_frange field, increased pll_n and
--																decreased pll_m.
-- 2006-01-26		1.30			CB			Added the BMEM registers.
-- 2006-02-01		1.40			CB			Added the ld_bmem bit in the RTC register.
-- 2006-02-02		1.41			CB			Changed polarity of the bmem_ce signal.
-- 2006-02-17		1.50			CB			Added IOCTRL register and pad control.
-- 2006-03-08		1.51 			CB			Changed pwr_on to pwr_ok.
-- 2006-04-03		1.60 			CB			Removed 'freeze' from the PLLC register.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity crb is
  port (
    -- Clock and reset functions
    clk_e       : in  std_logic;  -- Execution clock
    rst_cn      : in  std_logic;  -- Asynchronous master reset
    rst_seqc_n  : in  std_logic;  -- Reset from CLC (active low)
    mreset      : in  std_logic;  -- MRESET pin reset (active low)
    pwr_ok      : in  std_logic;  -- Power-on reset (active low)
    -- Microprogram control
    pl_aaddr    : in  std_logic_vector(3 downto 0);  --from the microprogram word
    -- Other control inputs 
    ld_crb      : in  std_logic;  -- Load data in CRB reg from D bus, from CLC
    rd_crb      : in  std_logic;  -- Output CRB reg on crb_out, from DSL
    mwake_i     : in  std_logic;  -- Wake-up signal from external pin
    pa_i        : in  std_logic_vector(4 downto 0); -- Port A input, for port init
    -- Data paths
    dbus        : in  std_logic_vector(7 downto 0); -- D bus, from DSL
    state_ps3   : in  std_logic_vector(4 downto 0); -- State of prescaler 3, from TIM
    crb_out     : out std_logic_vector(7 downto 0); -- CRB output, to DSL
    -- Static control outputs
    -- CCFF register
    en_pmem     : out std_logic;
    speed_i     : out std_logic_vector(1 downto 0);
    en_wdog     : out std_logic;
    pup_clk     : out std_logic;
    pup_irq     : out std_logic_vector(1 downto 0);
    en_i        : out std_logic;
    -- MORG register
    en_d        : out std_logic;
    r_size      : out std_logic_vector(1 downto 0);
    c_size      : out std_logic_vector(1 downto 0);
    dqm_size    : out std_logic_vector(1 downto 0);
    -- MTIM register
    fast_d      : out std_logic;
    t_ras       : out std_logic_vector(2 downto 0);
    t_rcd       : out std_logic_vector(1 downto 0);
    t_rp        : out std_logic_vector(1 downto 0);
    -- PLLC register
    en_tiu      : out std_logic;
    run_tiu     : out std_logic;
    dis_pll     : out std_logic;
    dis_xosc    : out std_logic;
    en_tstamp   : out std_logic_vector(1 downto 0);
    en_mxout    : out std_logic;
    en_mexec    : out std_logic;
    -- PLLM register
    pll_frange  : out std_logic;
    pll_n       : out std_logic_vector(5 downto 0);	-- Expanded
    pll_m       : out std_logic_vector(2 downto 0);	-- Expanded
    -- SECC register
    en_s        : out std_logic;
    speed_s     : out std_logic_vector(1 downto 0);
    -- PMXC register
    adc_dac     : out std_logic;
    en_uart1    : out std_logic;
    en_uart2    : out std_logic;
    en_uart3    : out std_logic;
    en_eth      : out std_logic_vector(1 downto 0);
    en_iobus    : out std_logic_vector(1 downto 0);
    -- UACC register
    adc_ref2v		: out	std_logic;	-- Select 2V internal ADC reference (1V)
    speed_u     : out std_logic_vector(6 downto 0);
    -- PSC1 register
    speed_ps1   : out std_logic_vector(3 downto 0);
    speed_ps2   : out std_logic_vector(5 downto 0);
    -- PSC2 register
    speed_ps3   : out std_logic_vector(4 downto 0);
    en_mckout1  : out std_logic;
    -- IOCTRL register & pad control
    d_hi        : out std_logic;	-- High drive on DRAM interface
    d_sr        : out std_logic;	-- Slew rate limit on DRAM interface
    d_lo        : out std_logic;	-- Low drive on DRAM interface
    p1_hi       : out std_logic;	-- High drive on port group 1 pins
    p1_sr       : out std_logic;	-- Slew rate limit on port group 1 pins
    pc_hi       : out std_logic;	-- High drive on port C pins
    pc_lo_n     : out std_logic;	-- Not low drive port C pins
    ph_hi       : out std_logic;	-- High drive on port H pins
    ph_lo_n     : out std_logic;	-- Not low drive port H pins
    pi_hi       : out std_logic;	-- High drive on port I pins
    pi_lo_n     : out std_logic;	-- Not low drive port I pins
    p2_hi       : out std_logic;	-- High drive on port group 2 pins
    p2_sr       : out std_logic;	-- Slew rate limit on port group 2 pins
    pel_hi      : out std_logic;	-- High drive on low half of port E pins
    peh_hi      : out std_logic;	-- High drive on high half of port E pins
    pdll_hi     : out std_logic;	-- High drive low dibit, low half of port D
    pdlh_hi     : out std_logic;	-- High drive high dibit, low half of port D
    pdh_hi      : out std_logic;	-- High drive on high half of port D pins
    p3_hi       : out std_logic;	-- High drive on port group 3 pins
    p3_sr       : out std_logic;	-- Slew rate limit on port group 3 pins
    pf_hi       : out std_logic;	-- High drive on port F pins
    pg_hi       : out std_logic; 	-- High drive on port G pins
    -- BMEM block interface
    bmem_a8     : out  std_logic;
    bmem_q      : in   std_logic_vector(7 downto 0);
    bmem_d      : out  std_logic_vector(7 downto 0);
    bmem_we_n   : out  std_logic;
    bmem_ce_n   : out  std_logic;
    -- RTC block interface
    rst_rtc     : out std_logic;  -- Reset RTC counter byte
    en_fclk     : out std_logic;  -- Enable fast clocking of RTC counter byte
    fclk        : out std_logic;  -- Fast clock to RTC counter byte
    ld_bmem     : out std_logic;  -- Latch enable to the en_bmem latch
    rtc_sel     : out std_logic_vector(2 downto 0);   -- RTC byte select
    rtc_data    : in  std_logic_vector(7 downto 0));  -- RTC data
end;          

architecture rtl of crb is
  signal crb_sel        : std_logic_vector(3 downto 0);
  signal en_pmem_int    : std_logic;
  signal speed_i_int    : std_logic_vector(1 downto 0);
  signal en_wdog_int    : std_logic;
  signal pup_clk_int    : std_logic;
  signal pup_irq_int    : std_logic_vector(1 downto 0);
  signal en_i_int       : std_logic;
  signal en_d_int       : std_logic;
  signal r_size_int     : std_logic_vector(1 downto 0);
  signal c_size_int     : std_logic_vector(1 downto 0);
  signal dqm_size_int   : std_logic_vector(1 downto 0);
  signal fast_d_int     : std_logic;
  signal t_ras_int      : std_logic_vector(2 downto 0);
  signal t_rcd_int      : std_logic_vector(1 downto 0);
  signal t_rp_int       : std_logic_vector(1 downto 0);
  signal en_tiu_int     : std_logic;
  signal run_tiu_int    : std_logic;
  signal dis_pll_int    : std_logic;
  signal dis_xosc_int   : std_logic;
  signal en_tstamp_int  : std_logic_vector(1 downto 0);
  signal en_mxout_int   : std_logic;
  signal en_mexec_int   : std_logic;
  signal pll_frange_int : std_logic;
  signal pll_n_int      : std_logic_vector(4 downto 0);
  signal pll_m_int      : std_logic_vector(1 downto 0);
  signal en_s_int       : std_logic;
  signal speed_s_int    : std_logic_vector(1 downto 0);
  signal security       : std_logic;
  signal stick          : std_logic_vector(3 downto 0);
  signal adc_dac_int    : std_logic;
  signal en_uart1_int   : std_logic;
  signal en_uart2_int   : std_logic;
  signal en_uart3_int   : std_logic;
  signal en_eth_int     : std_logic_vector(1 downto 0);
  signal en_iobus_int   : std_logic_vector(1 downto 0);
  signal adc_ref2v_int  : std_logic;
  signal speed_u_int    : std_logic_vector(6 downto 0);
  signal speed_ps1_int  : std_logic_vector(3 downto 0);
  signal speed_ps2_int  : std_logic_vector(5 downto 0);
  signal speed_ps3_int  : std_logic_vector(4 downto 0);
  signal en_mckout1_int : std_logic;
  signal d_hi_int   		: std_logic;
  signal d_sr_int   		: std_logic;
  signal p1_hi_int   		: std_logic;
  signal p1_sr_int   		: std_logic;
  signal p2_hi_int   		: std_logic;
  signal p2_sr_int   		: std_logic;
  signal p3_hi_int   		: std_logic;
  signal p3_sr_int   		: std_logic;
  signal bmem_we_nint   : std_logic;
  signal bmem_a8_int    : std_logic;

begin
  process (clk_e, rst_cn, ld_crb, pl_aaddr, dbus, pa_i)
  begin
    if rst_cn = '0' then
      -- CCFF register
      en_pmem_int   <= '0';
      speed_i_int   <= "00";
      en_wdog_int   <= '0';
      pup_clk_int   <= '0';
      pup_irq_int   <= "00";
      en_i_int      <= '0';
      -- MORG register
      en_d_int      <= '0';
      r_size_int    <= "00";
      c_size_int    <= "00";
      dqm_size_int  <= "00";
      -- MTIM register
      fast_d_int    <= '0';
      t_ras_int     <= "111";
      t_rcd_int     <= "11";
      t_rp_int      <= "11";
      -- PLLC register
      en_tiu_int    <= '0';
      run_tiu_int   <= '0';
      dis_pll_int   <= '0';
--    dis_xosc_int  <= '0'; -- In the next process due to different reset
      en_tstamp_int <= "00";
      en_mxout_int  <= '1';
      en_mexec_int  <= '1';
      -- PLLM register
      pll_frange_int	<= '1';
      pll_n_int(4)  	<= '0';
      pll_n_int(3)  	<= pa_i(2);
      pll_n_int(2)  	<= pa_i(1);
      pll_n_int(1)  	<= '0';
      pll_n_int(0)  	<= '0';
      pll_m_int(1)  	<= '0';
      pll_m_int(0)  	<= pa_i(0);
      -- SECC register
      en_s_int      <= '1';
      speed_s_int   <= pa_i(4 downto 3);
      security      <= '0';
      stick(2)      <= '0';
      -- PMXC register
      adc_dac_int   <= '0';
      en_uart1_int  <= '0';
      en_uart2_int  <= '0';
      en_uart3_int  <= '0';
      en_eth_int    <= "00";
      en_iobus_int  <= "00";
      -- UACC register
      adc_ref2v_int <= '1';
      speed_u_int   <= "0000000";
      -- PSC1 register
      speed_ps1_int   <= "1111";
      speed_ps2_int   <= "111111";
      -- PSC2 register
      speed_ps3_int   <= "11111";
      en_mckout1_int  <= '0';
      -- IOCTRL register
      d_hi_int	<= '0';
      d_sr_int	<= '0';
      p1_hi_int	<= '0';
      p1_sr_int	<= '0';
      p2_hi_int	<= '0';
      p2_sr_int	<= '0';
      p3_hi_int	<= '0';
      p3_sr_int	<= '0';
      -- BMEM control
      bmem_we_nint <= '1';
      bmem_a8_int  <= '0';
      -- BMEM data
      bmem_d	<= x"00";
       -- RTC control
      rst_rtc <= '0';
      en_fclk <= '0';
      fclk    <= '1';
      ld_bmem <= '0';
      rtc_sel <= "111";
--  elsif clk_e = '0' then          -- Latch based implementation
    elsif rising_edge(clk_e) then   -- Register based implementation
      if ld_crb = '1' then
        case pl_aaddr is
          when "0000" => -- CCFF register
            en_pmem_int   <= dbus(7);
            speed_i_int   <= dbus(6 downto 5);
            en_wdog_int   <= dbus(4);
            pup_clk_int   <= dbus(3);
            pup_irq_int   <= dbus(2 downto 1);
            en_i_int      <= dbus(0);
          when "0001" => -- MORG register
            en_d_int      <= dbus(6);
            r_size_int    <= dbus(5 downto 4);
            c_size_int    <= dbus(3 downto 2);
            dqm_size_int  <= dbus(1 downto 0);
          when "0010" => -- MTIM register
            fast_d_int    <= dbus(7);
            t_ras_int     <= dbus(6 downto 4);
            t_rcd_int     <= dbus(3 downto 2);
            t_rp_int      <= dbus(1 downto 0);
          when "0011" => -- PLLC register
            en_tiu_int    <= dbus(7);
            run_tiu_int   <= dbus(6);
            dis_pll_int   <= dbus(5);
--          dis_xosc_int  <= dbus(4); -- In the next process due to different reset
            en_tstamp_int <= dbus(3 downto 2);
            en_mxout_int  <= dbus(1);
            en_mexec_int  <= dbus(0);
          when "0100" => -- PLLM register
            pll_frange_int	<= dbus(7);
            pll_n_int     	<= dbus(6 downto 2);
            pll_m_int    		<= dbus(1 downto 0);
          when "0101" => -- SECC register
            en_s_int      <= dbus(7);
            speed_s_int   <= dbus(6 downto 5);
            if dbus(4) = '1' then security  <= '1'; end if; -- Unclearable by mpgm
--          if dbus(3) = '1' then stick(3)  <= '1'; end if; -- In the next process due to different reset
            if dbus(2) = '1' then stick(2)  <= '1'; end if; -- Unclearable by mpgm
--          if dbus(1) = '1' then stick(1)  <= '1'; end if; -- In the next process due to different reset
--          if dbus(0) = '1' then stick(0)  <= '1'; end if; -- In the next process due to different reset
          when "0110" => -- PMXC register
            adc_dac_int   <= dbus(7);
            en_uart1_int  <= dbus(6);
            en_uart2_int  <= dbus(5);
            en_uart3_int  <= dbus(4);
            en_eth_int    <= dbus(3 downto 2);
            en_iobus_int  <= dbus(1 downto 0);
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
          when "1011" => -- IOCTRL register
            d_hi_int	<= dbus(7);
            d_sr_int	<= dbus(6);
            p1_hi_int	<= dbus(5);
            p1_sr_int	<= dbus(4);
            p2_hi_int	<= dbus(3);
            p2_sr_int	<= dbus(2);
            p3_hi_int	<= dbus(1);
            p3_sr_int	<= dbus(0);
          when "1100" => -- BMEM control
            bmem_we_nint <= dbus(1);
            bmem_a8_int  <= dbus(0);
          when "1101" => -- BMEM data
            bmem_d	<= dbus;
          when "1111" => -- RTC control
            rst_rtc <= dbus(7);
            en_fclk <= dbus(6);
            fclk    <= dbus(5);
            ld_bmem <= dbus(4);
            rtc_sel <= dbus(2 downto 0);
          when others =>
            NULL;
        end case;
      end if;
    end if;
  end process;
	-- CE to BMEM active when BMEM address is written
	bmem_ce_n <= '0' when ld_crb = '1' and pl_aaddr = "1110" else '1';

  -- This process handles the 'dis_xosc' bit in the PLLC register,
  -- because its reset differs from most of the CRB register bits. 
  process (clk_e, rst_cn, mwake_i, ld_crb, pl_aaddr, dbus)
  begin
    if rst_cn = '0' or mwake_i = '1' then
      -- PLLC register, dis_xosc also reset by MWAKE pin
      dis_xosc_int  <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
    elsif rising_edge(clk_e) then   -- Register based implementation
      if ld_crb = '1' and pl_aaddr = "0011" then        -- PLLC register
        dis_xosc_int <= dbus(4);
      end if;
    end if;
  end process;

  -- This process handles the 'stick(3)' bit in the SECC register,
  -- because its reset differs from most of the CRB register bits. 
  process (clk_e, rst_seqc_n, ld_crb, pl_aaddr, dbus)
  begin
--  if clk_e = '0' then          -- Latch based implementation
    if rising_edge(clk_e) then   -- Register based implementation
      if rst_seqc_n = '0' then
            -- SECC register, stick(3) synchronous reset by rst_seqc_n
        stick(3)  <= '0';
      elsif ld_crb = '1' and pl_aaddr = "0101" then     -- SECC register
        if dbus(3) = '1' then
          stick(3)  <= '1';
        end if; -- Unclearable by mpgm
      end if;
    end if;
  end process;

  -- This process handles the 'stick(1)' bit in the SECC register,
  -- because its reset differs from most of the CRB register bits. 
  process (clk_e, mreset, pwr_ok, ld_crb, pl_aaddr, dbus)
  begin
    if mreset = '0' or pwr_ok = '0' then
      -- SECC register, stick(1) reset by mreset or pwr_ok
      stick(1)  <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
    elsif rising_edge(clk_e) then   -- Register based implementation
      if ld_crb = '1' and pl_aaddr = "0101" then        -- SECC register
        if dbus(1) = '1' then
          stick(1)  <= '1';
        end if; -- Unclearable by mpgm
      end if;
    end if;
  end process;

  -- This process handles the 'stick(0)' bit in the SECC register,
  -- because its reset differs from most of the CRB register bits. 
  process (clk_e, pwr_ok, ld_crb, pl_aaddr, dbus)
  begin
    if pwr_ok = '0' then
      -- SECC register, stick(0) reset by pwr_ok
      stick(0)  <= '0';
--  elsif clk_e = '0' then          -- Latch based implementation
    elsif rising_edge(clk_e) then   -- Register based implementation
      if ld_crb = '1' and pl_aaddr = "0101" then        -- SECC register
        if dbus(0) = '1' then
          stick(0)  <= '1';
        end if; -- Unclearable by mpgm
      end if;
    end if;
  end process;

  -- Make CRB mux stand still when not reading CRB.
  crb_sel <=  pl_aaddr when rd_crb = '1' else
              "0000";
              
--234567890123456789012345678901234567890123456789012345678901234567890123456789
  process (crb_sel, en_pmem_int, speed_i_int, en_wdog_int, pup_clk_int,
           en_i_int, en_d_int, r_size_int, c_size_int, dqm_size_int, fast_d_int,
           t_ras_int, t_rcd_int, en_tiu_int, run_tiu_int, dis_pll_int,
           dis_xosc_int, en_tstamp_int, en_mxout_int, en_mexec_int,
           pll_frange_int, pll_n_int, pll_m_int, en_s_int, speed_s_int, security,
           stick, adc_dac_int, en_uart1_int, pup_irq_int, en_uart2_int,
           en_uart3_int, en_eth_int, en_iobus_int, adc_ref2v_int, speed_u_int,
           speed_ps1_int, speed_ps2_int, speed_ps3_int, en_mckout1_int, state_ps3,
           d_hi_int, d_sr_int, p1_hi_int, p1_sr_int, p2_hi_int, p2_sr_int,
           p3_hi_int, p3_sr_int, bmem_we_nint, bmem_a8_int, bmem_q, rtc_data)
  begin
    crb_out <= x"00";
    case crb_sel is
      when "0000" => -- CCFF register
        crb_out(7)          <= en_pmem_int;
        crb_out(6 downto 5) <= speed_i_int;
        crb_out(4)          <= en_wdog_int;
        crb_out(3)          <= pup_clk_int;
        crb_out(2 downto 1) <= pup_irq_int;
        crb_out(0)          <= en_i_int;
      when "0001" => -- MORG register
        crb_out(6)          <= en_d_int;
        crb_out(5 downto 4) <= r_size_int;
        crb_out(3 downto 2) <= c_size_int;
        crb_out(1 downto 0) <= dqm_size_int;
      when "0010" => -- MTIM register
        crb_out(7)          <= fast_d_int;
        crb_out(6 downto 4) <= t_ras_int;
        crb_out(3 downto 2) <= t_rcd_int;
        crb_out(1 downto 0) <= t_rcd_int;
      when "0011" => -- PLLC register
        crb_out(7)          <= en_tiu_int;
        crb_out(6)          <= run_tiu_int;
        crb_out(5)          <= dis_pll_int;
        crb_out(4)          <= dis_xosc_int;
        crb_out(3 downto 2) <= en_tstamp_int;
        crb_out(1)          <= en_mxout_int;
        crb_out(0)          <= en_mexec_int;
      when "0100" => -- PLLM register
        crb_out(7)          <= pll_frange_int;
        crb_out(6 downto 2) <= pll_n_int;
        crb_out(1 downto 0) <= pll_m_int;
      when "0101" => -- SECC register
        crb_out(7)          <= en_s_int;
        crb_out(6 downto 5) <= speed_s_int;
        crb_out(4)          <= security;
        crb_out(3 downto 0) <= stick;
      when "0110" => -- PMXC register
        crb_out(7)          <= adc_dac_int;
        crb_out(6)          <= en_uart1_int;
        crb_out(5)          <= en_uart2_int;
        crb_out(4)          <= en_uart3_int;
        crb_out(3 downto 2) <= en_eth_int;
        crb_out(1 downto 0) <= en_iobus_int;
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
        crb_out(4 downto 0) <= state_ps3;
      when "1011" => -- IOCTRL register
        crb_out(7)					<= d_hi_int;
        crb_out(6)					<= d_sr_int;
        crb_out(5)					<= p1_hi_int;
        crb_out(4)					<= p1_sr_int;
        crb_out(3)					<= p2_hi_int;
        crb_out(2)					<= p2_sr_int;
        crb_out(1)					<= p3_hi_int;
        crb_out(0)					<= p3_sr_int;
      when "1100" => -- BMEM control
        crb_out(1)          <= bmem_we_nint;
        crb_out(0)          <= bmem_a8_int;
      when "1101" => -- BMEM data
        crb_out             <= bmem_q;
      when "1111" => -- RTC data
        crb_out             <= rtc_data;
      when others =>
        NULL;
    end case;
  end process;

  en_pmem     <= en_pmem_int;
  speed_i     <= speed_i_int;
  en_wdog     <= en_wdog_int;
  pup_clk     <= pup_clk_int;
  pup_irq     <= pup_irq_int;
  en_i        <= en_i_int;
  en_d        <= en_d_int;
  r_size      <= r_size_int;
  c_size      <= c_size_int;
  dqm_size    <= dqm_size_int;
  fast_d      <= fast_d_int;
  t_ras       <= t_ras_int;
  t_rcd       <= t_rcd_int;
  t_rp        <= t_rp_int;
  en_tiu      <= en_tiu_int;
  run_tiu     <= run_tiu_int;
  dis_pll     <= dis_pll_int;
  dis_xosc    <= dis_xosc_int;
  en_tstamp   <= en_tstamp_int;
  en_mxout    <= en_mxout_int;
  en_mexec    <= en_mexec_int;
  pll_frange  <= pll_frange_int;
  pll_n				<= "100000" when pll_n_int = "0000" else '0' & pll_n_int;	--Expand
  pll_m       <= "101" when pll_m_int = "00" else '0' & pll_m_int;			--Expand
  en_s        <= en_s_int and not security;
  speed_s     <= speed_s_int;
  adc_dac     <= adc_dac_int;
  en_uart1    <= en_uart1_int;
  en_uart2    <= en_uart2_int;
  en_uart3    <= en_uart3_int;
  en_eth      <= en_eth_int;
  en_iobus    <= en_iobus_int;
  adc_ref2v   <= adc_ref2v_int;
  speed_u     <= speed_u_int;
  speed_ps1   <= speed_ps1_int;
  speed_ps2   <= speed_ps2_int;
  speed_ps3   <= speed_ps3_int;
  en_mckout1  <= en_mckout1_int;
  d_hi   			<= d_hi_int;
  d_sr   			<= d_sr_int;
  p1_hi   		<= p1_hi_int;
  p1_sr   		<= p1_sr_int;
  p2_hi   		<= p2_hi_int;
  p2_sr   		<= p2_sr_int;
  p3_hi   		<= p3_hi_int;
  p3_sr   		<= p3_sr_int;
  bmem_we_n   <= bmem_we_nint;
  bmem_a8     <= bmem_a8_int;

	d_lo		<= not d_hi_int;
	pc_hi		<= '0' when en_iobus_int = "11" else p1_hi_int;		-- PC used for I/O bus when en_iobus = 11
	pc_lo_n	<= '1' when en_iobus_int = "11" else p1_hi_int;
	ph_hi		<= '0' when en_iobus_int(1) = '1' else p1_hi_int;	-- PH used for I/O bus when en_iobus = 10,11
	ph_lo_n	<= '1' when en_iobus_int(1) = '1' else p1_hi_int;
	pi_hi		<= '0' when en_iobus_int /= "00" else p1_hi_int;	-- PI used for I/O bus when en_iobus = 01,10,11
	pi_lo_n	<= '1' when en_iobus_int /= "00" else p1_hi_int;
	pel_hi	<= p2_hi_int and not en_uart2_int;
	peh_hi	<= p2_hi_int and not en_uart3_int;
	pdll_hi	<= '0' when dqm_size_int /= "00" else p2_hi_int;	-- Bits 0,1 of PD used for DQM when dqm_size = 01,10,11
	pdlh_hi	<= '0' when dqm_size_int(1) = '1' else p2_hi_int;	-- Bits 2,3 of PD used for DQM when dqm_size = 10,11
	pdh_hi	<= '0' when dqm_size_int = "11" else p2_hi_int;		-- Bits 4-7 of PD used for DQM when dqm_size = 11
	pf_hi		<= '0' when en_eth_int /= "00" else p3_hi_int;		-- PF used for Ethernet when en_eth = 01,10,11
	pg_hi		<= '0' when en_eth_int(0) = '1' else p3_hi_int;		-- PG used for Ethernet when en_eth = 01,11
  
end;
