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
-- Title      : General purpose I/O ports
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : ports.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: This module implements GP2000 'port' and 'PortInit' blocks.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date               Version       Author  Description
-- 2005-11-28         2.8           CB      Created
-- 2005-12-10         2.9           CB      Changed access to interrupt enable registers,
--                                          added UART interrupt sources.
-- 2006-03-08         2.10          CB      Replaced en_dac with dac_en. Replaced en_adc
--                                          with adc_en. Added adc_ref2v, adc_extref and
--                                          adc_diff.
-- 2012-06-15         3.0           MN      use clk_p to replace clk_e for interrupt signals
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mpgmfield_lib.all;
use work.gp_pkg.all;

entity ports is
  port (
    -- Clock and reset inputs
    rst_en : in std_logic;              -- int. generated reset
    --rst_en2           : in  std_logic;                   -- int. generated reset

    clk_e_pos  : in  std_logic;         -- clocks
    clk_e_neg  : in  std_logic;         -- clocks
    clk_p      : in  std_logic;         -- added by maning
    -- Microprogram fields
    pl_aaddr   : in  std_logic_vector(4 downto 0);  -- from microinstruction
    pl_pd      : in  std_logic_vector(2 downto 0);  -- from microinstruction
    -- Data paths
    dbus       : in  std_logic_vector(7 downto 0);  -- D bus
    dfp        : out std_logic_vector(7 downto 0);  -- Data from ports
    -- port A
    paen       : out std_logic_vector(7 downto 0);  -- port A out enable
    pao        : out std_logic_vector(7 downto 0);  -- port A output
    pai        : in  std_logic_vector(7 downto 0);  -- port A input
    -- port B
    pben       : out std_logic_vector(7 downto 0);
    pbo        : out std_logic_vector(7 downto 0);
    pbi        : in  std_logic_vector(7 downto 0);
    -- port C
    pcen       : out std_logic_vector(7 downto 0);
    pco        : out std_logic_vector(7 downto 0);
    pci        : in  std_logic_vector(7 downto 0);
    -- port D
    pden       : out std_logic_vector(7 downto 0);
    pdo        : out std_logic_vector(7 downto 0);
    pdi        : in  std_logic_vector(7 downto 0);
    -- port E
    peen       : out std_logic_vector(7 downto 0);
    peo        : out std_logic_vector(7 downto 0);
    pei        : in  std_logic_vector(7 downto 0);
    -- port F
    pfen       : out std_logic_vector(7 downto 0);
    pfo        : out std_logic_vector(7 downto 0);
    pfi        : in  std_logic_vector(7 downto 0);
    -- port G
    pgen       : out std_logic_vector(7 downto 0);
    pgo        : out std_logic_vector(7 downto 0);
    pgi        : in  std_logic_vector(7 downto 0);
    -- port H
    phen       : out std_logic_vector(7 downto 0);
    pho        : out std_logic_vector(7 downto 0);
    phi        : in  std_logic_vector(7 downto 0);
    -- port I
    pien       : out std_logic_vector(7 downto 0);
    pio        : out std_logic_vector(7 downto 0);
    pii        : in  std_logic_vector(7 downto 0);
    -- port J
    pjen       : out std_logic_vector(7 downto 0);
    pjo        : out std_logic_vector(7 downto 0);
    pji        : in  std_logic_vector(7 downto 0);
    -- interrupt signals to core
    irq0       : out std_logic;
    irq1       : out std_logic;
    -- interrupt sources
    mirq0_i    : in  std_logic;
    mirq1_i    : in  std_logic;
    uart1_irq  : in  std_logic;
    uart2_irq  : in  std_logic;
    uart3_irq  : in  std_logic;
    rx1_irq    : in  std_logic;
    rx2_irq    : in  std_logic;
    tx_irq     : in  std_logic;
    -- signals to/from TIU(timer)
    tiu_out    : in  std_logic_vector(7 downto 0);
    pulseout   : in  std_logic_vector(7 downto 0);
    tiu_irq    : in  std_logic;
    reg_wr     : out std_logic;
    wdata      : out std_logic_vector(7 downto 0);
    reg_addr   : out std_logic_vector(7 downto 0);
    cpt_trig   : out std_logic_vector(7 downto 0);
    -- signals to PDI(parallel data interface)
    pdi_en     : out std_logic;
    pdi_dir    : out std_logic;
    -- signals to/from ADC & DAC
    ach_sel    : out std_logic_vector(2 downto 0);
    adc_extref : out std_logic;  -- Select external ADC reference (internal)
    adc_diff   : out std_logic;  -- Select differential ADC mode (single-ended)
    adc_en     : out std_logic;         -- Enable for the ADC
    adc_prec   : out std_logic;
    adc_mode   : out std_logic_vector(1 downto 0);
    adc_run    : out std_logic;
    adc_done   : in  std_logic;
    adc_data   : in  std_logic_vector(15 downto 0);
    speed_a    : out std_logic_vector(2 downto 0);
    dac_en     : out std_logic_vector(0 to 1);
    dac_data   : out dac_data_type);
end ports;

architecture rtl of ports is
  constant port_number : integer := 16;  -- 10 external + 6 internal (2 interrupt,
                                         -- timer, serial ctrl/data buf, AD/DA ctrl/data)
  constant PORT_IRQ0   : integer := 10;
  constant PORT_IRQ1   : integer := 11;
  constant PORT_TIMER  : integer := 12;
  constant PORT_SP     : integer := 13;
  constant PORT_DA_H   : integer := 14;
  constant PORT_AD_L   : integer := 15;

  constant IRQ_ADC : integer := 2;

  signal adc_run_d : std_logic;
  signal adc_run_int : std_logic;
  
  signal dtp      : std_logic_vector(7 downto 0);      -- data to ports
  signal we_ctrl  : std_logic;          -- write enable control
  signal we_data  : std_logic;          -- write enable data
  signal we_aaddr : std_logic_vector(3 downto 0);      -- write port select
  type port_type is array (port_number - 1 downto 0)
    of std_logic_vector(7 downto 0);
  signal pi_int       : port_type;
  signal po_int       : port_type;
  signal pen_int      : port_type;
  signal pi_latch     : port_type;
  signal dfp_int      : port_type;      -- data from ports
  signal po_ld        : std_logic_vector(port_number - 1 downto 0);
  signal pen_ld       : std_logic_vector(port_number - 1 downto 0);
  signal irq0_en      : std_logic_vector(7 downto 0);  -- Interrupt enable reg 0
  signal irq1_en      : std_logic_vector(7 downto 0);  -- Interrupt enable reg 1
  signal irq0_src     : std_logic_vector(7 downto 0);  -- Interrupt source vector 0
  signal irq1_src     : std_logic_vector(7 downto 0);  -- Interrupt source vector 1
  signal cpt_trig_int : std_logic_vector(7 downto 0);
  -- serial interface signals
  signal s_p_cfg      : std_logic_vector(7 downto 0);  -- ser/par interface config
  signal sft_reg      : std_logic_vector(8 downto 0);  -- shift register
  signal sft_reg_ld   : std_logic;      -- shift reg load
  signal sft_clk      : std_logic;      -- shift register clock
  signal clk_o_c      : std_logic;      -- clk_o port control
  signal clk_o_d      : std_logic;      -- clk_o port data
  signal data_o_c     : std_logic;      -- data_o port control;
  signal data_o_d     : std_logic;      -- data_o port data;
  -- ADC/DAC signals
  signal dac_timer    : std_logic;
  signal dac_sel      : std_logic_vector(1 downto 0);
  signal adc_mode_int : std_logic_vector(1 downto 0);
  signal adc_done_1   : std_logic;
  signal adc_edge     : std_logic;
  signal adc_irq      : std_logic;

  signal port_irq_in    : std_logic_vector(5 downto 0);
  signal port_irq_rst   : std_logic_vector(5 downto 0);
  signal port_irq_latch : std_logic_vector(5 downto 0);
  signal port_irq_ff    : std_logic_vector(5 downto 0);
  signal port_irq       : std_logic_vector(5 downto 0);
  signal port_irq_en    : std_logic_vector(5 downto 0);  --add by maning

  signal dac_data_d : dac_data_type;
  signal dac_data_int : dac_data_type;
begin
  -- The dtp latch opens in the middle of a cycle that writes to
  -- a port register and closes at the end, holding data for the
  -- port register latches that are open during the first half of
  -- the cycle that follows.
------------change latch to registers
---------------------start-----------maning------------------
  process (clk_p)
  begin
    if rising_edge(clk_p) then                           --rising_edge(clk_e)
      if rst_en = '0' then
        dtp <= (others => '0');
      elsif pl_pd = PD_LDPORT and clk_e_pos = '0' then
        dtp <= dbus;
      end if;
    end if;
  end process;
----------------------end------------maning------------------
--  process (clk_e, dbus, pl_pd)
--  begin
--    if clk_e = '0' and pl_pd = PD_LDPORT then
--      dtp <= dbus;
--    end if;
--  end process;

  -- we_ctrl goes high in the middle of a cycle that writes to
  -- a port control register and stays high to the middle of the
  -- next. we_data does the same for data registers.
  process (clk_p)
  begin
    if rising_edge(clk_p) then          --falling_edge(clk_e)
      if rst_en = '0' then
        we_ctrl <= '0';
        we_data <= '0';
      elsif clk_e_neg = '0' then
        we_ctrl <= '0';
        we_data <= '0';
        if pl_pd = PD_LDPORT then
          if pl_aaddr(4) = '0' then
            we_ctrl <= '1';
          else
            we_data <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  -- These flipflops will delay pl_aaddr for half a cycle to
  -- provide select signals for write operations.
  process (clk_p)
  begin
    if rising_edge(clk_p) then          --falling_edge(clk_e)
      if rst_en = '0' then
        we_aaddr <= (others => '0');
      elsif clk_e_neg = '0' then
        we_aaddr <= pl_aaddr(3 downto 0);
      end if;
    end if;
  end process;

  -- These are the general ports. Each port has one control
  -- register (pen) that controls the direction of each port
  -- pin, and one data register (po).
  -- Each port also has a data input latch, and a mux that
  -- enables reading this latch or the pen register.
  -- Finally, there are load pulse outputs for both pen and
  -- po registers.
  port_gen : for i in 0 to port_number - 1 generate
--commented by maning for latch problems 2011-11-24 16:30:01
--    process (rst_en2, clk_e, we_ctrl, we_aaddr, dtp)
--    begin
--                      pen_ld(i) <= '0';
--      if rst_en2 = '0' then
--        pen_int(i) <= (others => '0');
--      elsif clk_e = '1' then
--        if we_ctrl = '1' and i = conv_integer(we_aaddr) then
--                                      pen_ld(i)               <= '1';
--          pen_int(i)  <= dtp;
--        end if;
--      end if;
--    end process;

--commented by maning for latch problems 2011-11-24 16:30:01
--    process (clk_e, we_data, we_aaddr, dtp)
--    begin
--                      po_ld(i) <= '0';
--      if clk_e = '1' then
--        if we_data = '1' and i = conv_integer(we_aaddr) then
--                                      po_ld(i)        <= '1';
--          po_int(i)   <= dtp;
--        end if;
--      end if;
--    end process;
--change latch to registers by maning 2011-11-24 17:09:42
    process (clk_p)
    begin
      if (rising_edge(clk_p)) then      --falling_edge(clk_e)
        if rst_en = '0' then
          pen_int(i) <= (others => '0');
          pen_ld(i)  <= '0';
        elsif clk_e_neg = '0' then
          if we_ctrl = '1' and i = conv_integer(we_aaddr) then
            pen_ld(i)  <= '1';
            pen_int(i) <= dtp;
          elsif pen_ld(i) = '1' then
            pen_ld(i) <= '0';
          end if;
        end if;
      end if;
    end process;



    process (clk_p)
    begin
      if (rising_edge(clk_p)) then      --falling_edge(clk_e)
        if (rst_en = '0') then
          po_ld(i)  <= '0';
          po_int(i) <= (others => '1');  --maning 2012-02-24 13:49:48 change the initial value to 1
        elsif clk_e_neg = '0' then
--                if we_ctrl = '1' and i = conv_integer(we_aaddr) then
--                    po_int(i) <= (others => '1');--maning 2012-02-27 11:00:38 add reset value
--                els
          if we_data = '1' and i = conv_integer(we_aaddr) then
            po_ld(i)  <= '1';
            po_int(i) <= dtp;
          elsif po_ld(i) = '1' then
            po_ld(i) <= '0';
          end if;
        end if;
      end if;
    end process;

--change latch to register by maning 2011-11-25 10:24:25
--    process (clk_e, pi_int(i))
--    begin
--      if clk_e = '0' then
--        pi_latch(i) <= pi_int(i);
--      end if;
--    end process;
--  -- Mux out 'dfp' then latch it.
--  process (clk_e, pl_aaddr, dfp_int)
--  begin
--    if clk_e = '1' then
--      dfp <= (others => '0');
--      for i in 0 to port_number - 1 loop
--        if i = conv_integer(pl_aaddr(3 downto 0)) then
--          dfp <= dfp_int(i);
--        end if;
--      end loop;
--    end if;
--  end process;
---------------------------start-----maning---------------------------------------------
    process (clk_p)
    begin
      if rising_edge(clk_p) then        --rising_edge(clk_e)
        if rst_en = '0' then
          pi_latch(i) <= (others => '0');
        elsif clk_e_pos = '0' then
          pi_latch(i) <= pi_int(i);
        end if;
      end if;
    end process;

    dfp_int(i) <= pen_int(i) when pl_aaddr(4) = '0' else pi_latch(i);
  end generate port_gen;

  dfp <= dfp_int(conv_integer(pl_aaddr(3 downto 0)));


--  process (clk_p)
--  begin
--    if rising_edge(clk_p) then--falling_edge(clk_e)
--        if rst_en = '0' then
--            dfp <= (others => '0');
--        elsif clk_e_neg = '0' then
--            for i in 0 to port_number - 1 loop
--                if i = conv_integer(pl_aaddr(3 downto 0)) then
--                    dfp <= dfp_int(i);
--                end if;
--            end loop;
--        end if;
--    end if;
--  end process;
-----------------------------end-----maning---------------------------------------------
  -- Re-assign external port signals
  pi_int(0) <= pai;
  pi_int(1) <= pbi;
  pi_int(2) <= pci;
  pi_int(3) <= pdi;
  pi_int(4) <= pei;
  pi_int(5) <= pfi;
  pi_int(6) <= pgi;
  pi_int(7) <= phi;
  pi_int(8) <= pii;
  pi_int(9) <= pji;

  pao <= po_int(0);
  pbo <= po_int(1);
  -- pulseout go to port C
  pco <= (po_int(2)(7) xor pulseout(7)) & (po_int(2)(6) xor pulseout(6)) &
         (po_int(2)(5) xor pulseout(5)) & (po_int(2)(4) xor pulseout(4)) &
         (po_int(2)(3) xor pulseout(3)) & (po_int(2)(2) xor pulseout(2)) &
         (po_int(2)(1) xor pulseout(1)) & (po_int(2)(0) xor pulseout(0));

  pdo(7)          <= po_int(3)(7) xor clk_o_d;
  pdo(6)          <= po_int(3)(6) xor data_o_d;
  pdo(5 downto 0) <= po_int(3)(5 downto 0);
  peo             <= po_int(4);
  pfo             <= po_int(5);
  pgo             <= po_int(6);
  pho             <= po_int(7);
  pio             <= po_int(8);
  pjo             <= po_int(9);

  paen <= pen_int(0);
  pben <= pen_int(1);
  pcen <= pen_int(2);

  pden(7)          <= pen_int(3)(7) xor clk_o_c;
  pden(6)          <= pen_int(3)(6) xor data_o_c;
  pden(5 downto 0) <= pen_int(3)(5 downto 0);
  peen             <= pen_int(4);
  pfen             <= pen_int(5);
  pgen             <= pen_int(6);
  phen             <= pen_int(7);
  pien             <= pen_int(8);
  pjen             <= pen_int(9);

  -----------------------------------------------------------------------------
  -- Interrupt control logic
  -----------------------------------------------------------------------------
  -- The handshake between processor and interrupt sources are as follows:
  -- 1. Processor set the mask bit to enable an interrupt;
  -- 2. The interrupt flag irf is set by a source when a service is needed;
  -- 3. Processor reset the mask bit, then start a service;
  -- 4. Processor set the mask bit again to enable further interrupt.

  -- Re-assign interrupt control registers.
  pi_int(PORT_IRQ0) <= irq0_src;        -- Read source vector using DPORT
  irq0_en           <= pen_int(PORT_IRQ0);  -- Write and read enable register using CPORT

  pi_int(PORT_IRQ1) <= irq1_src;        -- Read source vector using DPORT
  irq1_en           <= pen_int(PORT_IRQ1);  -- Write and read enable register using CPORT

  -- Put together interrupt source vectors.
  irq0_src(7 downto 3) <= rx1_irq & rx2_irq & tx_irq & port_irq(1 downto 0);
  irq0_src(IRQ_ADC)    <= adc_irq;
  irq0_src(1 downto 0) <= tiu_irq & (not mirq0_i);
  irq1_src             <= uart1_irq & uart2_irq & uart3_irq & port_irq(5 downto 2) & (not mirq1_i);

  -- Mask interrupt sources with interrupt enable registers
  -- and gate them together to form two interrupt request lines
  -- to the core.
  process (irq0_en, irq1_en, irq0_src, irq1_src)
  begin
    irq0 <= '1';
    irq1 <= '1';
    for i in 0 to 7 loop
      if irq0_en(i) = '1' and irq0_src(i) = '1' then
        irq0 <= '0';
      end if;
      if irq1_en(i) = '1' and irq1_src(i) = '1' then
        irq1 <= '0';
      end if;
    end loop;
  end process;

  port_irq_in     <= pbi(5 downto 0);
--      port_irq_rst(1) <= pen_ld(PORT_IRQ0) and dtp(4);
--      port_irq_rst(0) <= pen_ld(PORT_IRQ0) and dtp(3);
--      port_irq_rst(5) <= pen_ld(PORT_IRQ1) and dtp(4);
--      port_irq_rst(4) <= pen_ld(PORT_IRQ1) and dtp(3);
--      port_irq_rst(3) <= pen_ld(PORT_IRQ1) and dtp(2);
--      port_irq_rst(2) <= pen_ld(PORT_IRQ1) and dtp(1);
  port_irq_rst(1) <= po_ld(PORT_IRQ0) and dtp(4);
  port_irq_rst(0) <= po_ld(PORT_IRQ0) and dtp(3);
  port_irq_rst(5) <= po_ld(PORT_IRQ1) and dtp(4);
  port_irq_rst(4) <= po_ld(PORT_IRQ1) and dtp(3);
  port_irq_rst(3) <= po_ld(PORT_IRQ1) and dtp(2);
  port_irq_rst(2) <= po_ld(PORT_IRQ1) and dtp(1);

--  process (clk_e, port_irq_in, rst_en)
--  begin
--              if rst_en = '0' then
--                      port_irq_latch <= (others => '0');
--              elsif clk_e = '1' then
--                      port_irq_latch <= port_irq_in;
--              end if;
--  end process;
--
--  process (clk_e, rst_en)
--  begin
--              if rst_en = '0' then
--                      port_irq_ff <= (others => '0');
--              elsif rising_edge(clk_e) then
--                      port_irq_ff <= port_irq_latch;
--              end if;
--  end process;
--
--      process (rst_en, port_irq_rst, port_irq_latch, port_irq_ff)
--      begin
--              for i in 0 to 5 loop
--          if rst_en = '0' then
--                              port_irq(i) <= '0';
--                      elsif port_irq_rst(i) = '1' then
--                              port_irq(i) <= '0';
--                      elsif port_irq_latch(i) = '1' and port_irq_ff(i) = '0' then
--                              port_irq(i) <= '1';
--                      end if;
--              end loop;
--      end process;
--------------------maning commented the above codes in 2012-06-15 09:41:32---------------------
----------------------------------the modified code start---------------------------------------
  port_irq_en <= irq1_en(4 downto 1) & irq0_en(4 downto 3);

  process (clk_p)
  begin
    if rising_edge (clk_p) then
      if rst_en = '0' then
        port_irq_latch <= (others => '0');
      else
        port_irq_latch <= port_irq_in;
      end if;
    end if;
  end process;

  process (clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_en = '0' then
        port_irq_ff <= (others => '0');
      else
        port_irq_ff <= port_irq_latch;
      end if;
    end if;
  end process;

  process (clk_p)
  begin
    if rising_edge(clk_p) then
      if rst_en = '0' then
        for i in 0 to 5 loop
          port_irq(i) <= '0';
        end loop;
      else
        for i in 0 to 5 loop
          if port_irq_rst(i) = '1' or port_irq_en(i) = '0' then  --clear the interrupt when clearing it or not enable
            port_irq(i) <= '0';
          elsif port_irq_latch(i) = '1' and port_irq_ff(i) = '0' then
            port_irq(i) <= '1';
          end if;
        end loop;
      end if;
    end if;
  end process;

---------------------------------end modification by maning-------------------------------------


  -----------------------------------------------------------------------------
  -- Timer control
  -----------------------------------------------------------------------------

  -- Re-assign timer registers
  pi_int(PORT_TIMER) <= tiu_out;
  reg_addr           <= pen_int(PORT_TIMER);
  wdata              <= po_int(PORT_TIMER);
  reg_wr             <= pen_int(PORT_TIMER)(7) and pen_ld(PORT_TIMER);

  -- cpt_trig come from port C
--  cpt_trig <= sft_clk & sft_clk &
--              (pci(5) xor po_int(2)(5)) & (pci(4) xor po_int(2)(4)) &
  cpt_trig <= sft_clk & sft_clk & sft_clk &
              (pci(4) xor po_int(2)(4)) &
              (pci(3) xor po_int(2)(3)) & (pci(2) xor po_int(2)(2)) &
              (pci(1) xor po_int(2)(1)) & (pci(0) xor po_int(2)(0));

  -----------------------------------------------------------------------------
  -- Generic Serial Interface
  -----------------------------------------------------------------------------
  -- GSI is aimed to support common serial I/O interfaces, such as SPI or I2C
  -- protocols. It is assumed that GP2000 plays as a master and it can perform
  -- both sending and receiving access.
  -- The main Logic is a 8-bit shift register. Upon each byte access finished,
  -- processor shall serve the interrupt request by read/write a new byte
  -- from/to the shifte register.
  -- When the serial interface is used, the signal lines are assigned to Port D
  -- as follows:
  -- PD(7): clk_o, clock output, for example SPI 'SCK';
  -- PD(6): data_o, data output, for example SPI 'MOSI' or I2C SDA;
  -- PD(5): data_i, data input, for example SPI 'MISO';
  -- The other interface signals are supposed to be handled by processor, for
  -- example SPI's 'SS_N', by direct driving the corressponding ports.
  -- The timer channel 6 and 7 are reserved as shift clock generation and bit
  -- counting logic. The external clock may be configured driven from channel 6
  -- or channel 5.

  -- Re-assign serial transfer interface registers
  pi_int(PORT_SP) <= sft_reg(7 downto 0);  -- processor read sft_reg
  s_p_cfg         <= pen_int(PORT_SP);
  sft_reg_ld      <= po_ld(PORT_SP);
  pdi_dir         <= s_p_cfg(6);
  pdi_en          <= s_p_cfg(7);

  gsi : block
    signal sft_out : std_logic;         -- shift register output

    -- configurable registers
    signal sft_in_sel  : std_logic_vector(1 downto 0);  -- 'shift in' select
    signal sft_clk_pol : std_logic;     -- shift clock polarity control
    signal clk_o_cfg   : std_logic;     -- clk_o port config
    signal data_o_cfg  : std_logic;     -- data_o port config
    signal asy_comm    : std_logic;
    signal dis_gsi     : std_logic;
  begin  -- block gsi
    -- assign config registers
    sft_in_sel  <= s_p_cfg(1 downto 0);
    sft_clk_pol <= s_p_cfg(2);
    clk_o_cfg   <= s_p_cfg(3);
    data_o_cfg  <= s_p_cfg(4);
    asy_comm    <= s_p_cfg(5);
    dis_gsi     <= '1' when asy_comm = '1' and sft_in_sel = "00" else '0';  -- Unused combination

    -- Shift register clock comes the clock pin and is polarity
    -- configurable:
    sft_clk <= (sft_clk_pol xor pdi(7)) when dis_gsi = '0' else '0';

    -- Shift register shall be able to perform these operations:
    -- 1. processor write/read access
    -- 2. selectable 'shift in' sources
    process(clk_p, rst_en) is
      variable sft_clk_d : std_logic_vector(3 downto 0);
      variable pdi5_d    : std_logic_vector(3 downto 0);
      variable pdi6_d    : std_logic_vector(3 downto 0);
    begin
      if rst_en = '0' then
        -- Variables
        sft_clk_d := (others => '0');
        pdi5_d    := (others => '0');
        pdi6_d    := (others => '0');
        -- Signals
        sft_reg    <= (others => '0');

      elsif rising_edge(clk_p) then

        if sft_reg_ld = '1' then
--          sft_reg(8 downto 1) <= dtp;
          sft_reg(0)          <= sft_in_sel(1) or sft_in_sel(0);
          --
--          if asy_comm = '0' then
--            sft_out <= dtp(7);
--          else
            sft_out <= '0';
--          end if;

        elsif sft_clk_d(1) = '0' and sft_clk_d(0) = '1' then
          -- Rising edge of sft_clk (after double regs)
          sft_out <= sft_reg(8);

          if pulseout(7) = '0' then
            case sft_in_sel is
              when "00"   => sft_reg <= sft_reg(7 downto 0) & '0';
              when "01"   => sft_reg <= sft_reg(7 downto 0) & '1';
              when "10"   => sft_reg <= sft_reg(7 downto 0) & pdi5_d(0);
              when "11"   => sft_reg <= sft_reg(7 downto 0) & pdi6_d(0);
              when others => null;
            end case;
          end if;
        end if;  -- sft_clk

        --
        sft_clk_d := sft_clk & sft_clk_d(3 downto 1);
        pdi5_d    := pdi(5)  & pdi5_d(3 downto 1);
        pdi6_d    := pdi(6)  & pdi6_d(3 downto 1);
      end if;  -- clk_p
    end process;

    -- generates configurable port data/control signals
    clk_o_c <= '0' when clk_o_cfg = '0' or dis_gsi = '1' else
               pulseout(6);

    clk_o_d <= '0' when clk_o_cfg = '1' or dis_gsi = '1' else
               pulseout(6);

    data_o_c <= '0' when data_o_cfg = '0' or dis_gsi = '1' else
                sft_out;

    data_o_d <= '0' when data_o_cfg = '1' or dis_gsi = '1' else
                sft_out;

  end block gsi;

  -----------------------------------------------------------------------------
  -- DAC/ ADC control
  -----------------------------------------------------------------------------

  -- Re-assign AD/DA control/data registers
  speed_a      <= pen_int(PORT_DA_H)(7 downto 5);
  dac_timer    <= pen_int(PORT_DA_H)(4);
  dac_en(1)    <= pen_int(PORT_DA_H)(3);
  dac_en(0)    <= pen_int(PORT_DA_H)(2);
  dac_sel(1)   <= pen_int(PORT_DA_H)(1);
  dac_sel(0)   <= pen_int(PORT_DA_H)(0);
  adc_extref   <= pen_int(PORT_AD_L)(7);
  adc_diff     <= pen_int(PORT_AD_L)(6);
  adc_mode_int <= pen_int(PORT_AD_L)(5 downto 4);
  adc_prec     <= pen_int(PORT_AD_L)(3);
  ach_sel      <= pen_int(PORT_AD_L)(2 downto 0);

  adc_mode <= adc_mode_int;

  -- Load data to the DAC registers from the data registers of ports O and P.
  -- When dac_timer is set, data is only loaded when there is a pulse from
  -- timer 2, otherwise it is loaded continously. dac_sel determines which
  -- channel that is loaded: none, ch0, ch1 or both (ch1 inverted).
  process (dac_timer, dac_sel, pulseout(2), po_int(PORT_DA_H), po_int(PORT_AD_L), dac_data_d)
  begin
    dac_data_int(1) <= dac_data_d(1);
    dac_data_int(0) <= dac_data_d(0);
    if dac_timer = '0' or pulseout(2) = '1' then
      if dac_sel(0) = '1' then
        dac_data_int(0) <= po_int(PORT_DA_H) & po_int(PORT_AD_L);
      end if;
      if dac_sel(1) = '1' then
        if dac_sel(0) = '0' then
          dac_data_int(1) <= po_int(PORT_DA_H) & po_int(PORT_AD_L);
        else
          dac_data_int(1) <= not (po_int(PORT_DA_H) & po_int(PORT_AD_L));
        end if;
      end if;
    end if;
  end process;

  dac_data <= dac_data_int;
  
  latch_removal: process (clk_p, rst_en) is
  begin  -- process latch_removal
    if rst_en = '0' then                -- asynchronous reset (active low)
      dac_data_d <= (others => (others => '0'));
    elsif clk_p'event and clk_p = '1' then  -- rising clock edge
      dac_data_d(1) <= dac_data_int(1);
      dac_data_d(0) <= dac_data_int(0);
    end if;
  end process latch_removal;

  -- Detect rising edges of adc_done.
--      process (clk_e)
--      begin
--              if rising_edge(clk_e) then
--                      adc_done_1 <= adc_done;
--              end if;
--      end process;
----------------------------change clock clk_e to clk_p by maning 2012-06-15 09:50:02--------------------
  process (clk_p)
  begin
    if rising_edge(clk_p) then
      if (rst_en = '0') then
        adc_done_1 <= '0';
      else
        adc_done_1 <= adc_done;
      end if;
    end if;
  end process;
--------------------------------------------end by maning------------------------------------------------
  adc_edge <= adc_done and not adc_done_1;

  -- Let the ADC run free in modes 11,10. In mode 01, initiate a new
  -- sample using a pulse from timer 4. Mode 00 is reset.
  process (adc_mode_int, pulseout(4), adc_edge, adc_run_d)
  begin
    adc_run_int <= adc_run_d;
    if adc_mode_int(1) = '1' then
      adc_run_int <= '1';
    elsif adc_mode_int(0) = '1' then
      if pulseout(4) = '1' then
        adc_run_int <= '1';
      elsif adc_edge = '1' then
        adc_run_int <= '0';
      end if;
    else
      adc_run_int <= '0';
    end if;
  end process;

  adc_run <= adc_run_int;
  
  process (clk_p)
  begin
    if rising_edge(clk_p) then
      adc_run_d <= adc_run_int;
    end if;
  end process;
  
  adc_en <= '1' when adc_mode_int /= "00" else
            '0';

  -- ADC data is readable in the data registers of ports O and P.
  pi_int(PORT_DA_H) <= adc_data(15 downto 8);
  pi_int(PORT_AD_L) <= adc_data(7 downto 0);

  -- ADC interrupt will be set once new data is loaded into the ADC
  -- data registers, and reset when the enable bit for the ADC interrupt
  -- is written with '1'.
--      process (rst_en, pen_ld(PORT_IRQ0), dtp(IRQ_ADC), adc_edge)
--      begin
--    if rst_en = '0' then
--                      adc_irq <= '0';
--              elsif pen_ld(PORT_IRQ0) = '1' and dtp(IRQ_ADC) = '1' then
--                      adc_irq <= '0';
--              elsif adc_edge = '1' then
--                      adc_irq <= '1';
--              end if;
--      end process;
---------------------------commented the above codes by maning 2012-06-15 09:55:38-------------------------
------------------------------------change latches to registers--------------------------------------------
  process (clk_p)
  begin
    if rising_edge (clk_p) then
      if rst_en = '0' then
        adc_irq <= '0';
      else
        --if pen_ld(PORT_IRQ0) = '1' and dtp(IRQ_ADC) = '1' then
        if po_ld(PORT_IRQ0) = '1' and dtp(IRQ_ADC) = '1' then
          adc_irq <= '0';
        elsif adc_edge = '1' then
          adc_irq <= '1';
        end if;
      end if;
    end if;
  end process;
----------------------------------------end by maning------------------------------------------------------
end rtl;
