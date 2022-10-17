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
-- Title      : Top level
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : digital_core
-- Author     : Bengt Svantesson
-- Company    : Imsys Technologies AB
-- Date       :
-------------------------------------------------------------------------------
-- Description: Core level block that instantiates the IM4000, Accelerator and
-- glue logic..
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.gp_pkg.all;

entity digital_core is

  generic (
    g_memory_type         : memory_type_t := asic;
    ionoc_fifo_depth_bits : integer       := 4;  -- Each FIFO is 2^x = 16 words deep
    g_clock_frequency     : integer);

  port (
    clk_p_cpu   : in std_logic;         -- clk input
    clk_p_cpu_n : in std_logic;         -- clk input
    clk_noc     : in std_logic;         -- 
    clk_rx      : in std_logic;
    clk_tx      : in std_logic;

    cpu_rst_n : in std_logic;

    MRESET     : in  std_logic;         -- system reset, active low
    c1_wdog_n  : out std_logic;
    MRSTOUT    : out std_logic;
    MIRQOUT    : out std_logic;         -- interrupt request output
    MCKOUT0    : out std_logic;         -- for trace adapter
    MCKOUT1    : out std_logic;         -- programable clock out
    mckout1_en : out std_logic;         -- Enable signal for MCKOUT1 pad.
    MTEST      : in  std_logic;         -- active high
    MBYPASS    : in  std_logic;
    MIRQ0      : in  std_logic;         -- active low
    MIRQ1      : in  std_logic;         -- active low
    -- SW debug
    MSDIN      : in  std_logic;         -- serial data in (debug)
    MSDOUT     : out std_logic;         -- serial data out

    MWAKEUP_LP : in  std_logic;         -- active high
    MLP_PWR_OK : in  std_logic;
    -- power management control
    MPMIC_CORE : out std_logic;
    MPMIC_IO   : out std_logic;

    clock_in_off : out std_logic;
    clock_sel    : out std_logic;

    -- Analog internal signals
    pwr_ok     : in  std_logic;  -- Power on detector output (active high)
    dis_bmem   : out std_logic;         -- Disable for vdd_bmem (active high)
    vdd_bmem   : in  std_logic;         -- Power for the BMEM block
    VCC18LP    : in  std_logic;         -- Power for the RTC block
    rxout      : in  std_logic;         -- RTC oscillator output
    ach_sel0   : out std_logic;         -- ADC channel select, bit 0
    ach_sel1   : out std_logic;         -- ADC channel select, bit 1
    ach_sel2   : out std_logic;         -- ADC channel select, bit 2
    adc_bits   : in  std_logic;  -- Bitstream from the analog part of ADC
    adc_ref2v  : out std_logic;  -- Select 2V internal ADC reference (1V)
    adc_extref : out std_logic;  -- Select external ADC reference (internal)
    adc_diff   : out std_logic;  -- Select differential ADC mode (single-ended)
    adc_en     : out std_logic;         -- Enable for the ADC
    dac0_bits  : out std_logic;         -- Bitstream to DAC0
    dac1_bits  : out std_logic;         -- Bitstream to DAC1
    dac0_en    : out std_logic;         -- Enable for DAC0
    dac1_en    : out std_logic;         -- Enable for DAC1
    clk_a      : out std_logic;         -- Clock to the DAC's and ADC

    -- Port A
    pa_i  : in  std_logic_vector(7 downto 0);
    pa_en : out std_logic_vector(7 downto 0);
    pa_o  : out std_logic_vector(7 downto 0);
    -- Port B
    pb_i  : in  std_logic_vector(7 downto 0);
    pb_en : out std_logic_vector(7 downto 0);
    pb_o  : out std_logic_vector(7 downto 0);
    -- Port C
    pc_i  : in  std_logic_vector(7 downto 0);
    pc_en : out std_logic_vector(7 downto 0);
    pc_o  : out std_logic_vector(7 downto 0);
    -- Port D
    pd_i  : in  std_logic_vector(7 downto 0);
    pd_en : out std_logic_vector(7 downto 0);
    pd_o  : out std_logic_vector(7 downto 0);
    -- Port E
    pe_i  : in  std_logic_vector(7 downto 0);
    pe_en : out std_logic_vector(7 downto 0);
    pe_o  : out std_logic_vector(7 downto 0);
    -- Port F
    pf_i  : in  std_logic_vector(7 downto 0);
    pf_en : out std_logic_vector(7 downto 0);
    pf_o  : out std_logic_vector(7 downto 0);
    -- Port G
    pg_i  : in  std_logic_vector(7 downto 0);
    pg_en : out std_logic_vector(7 downto 0);
    pg_o  : out std_logic_vector(7 downto 0);
    -- Port H
    ph_i  : in  std_logic_vector(7 downto 0);
    ph_en : out std_logic_vector(7 downto 0);
    ph_o  : out std_logic_vector(7 downto 0);
    -- Port I
    pi_i  : in  std_logic_vector(7 downto 0);
    pi_en : out std_logic_vector(7 downto 0);
    pi_o  : out std_logic_vector(7 downto 0);
    -- Port J
    pj_i  : in  std_logic_vector(7 downto 0);
    pj_en : out std_logic_vector(7 downto 0);
    pj_o  : out std_logic_vector(7 downto 0);
    -- I/O cell configuration control outputs
    -- d_hi        : out std_logic; -- High drive on DRAM interface, now used for other outputs
    -- d_sr        : out std_logic; -- Slew rate limit on DRAM interface
    d_lo  : out std_logic;              -- Low drive on DRAM interface
    p1_hi : out std_logic;              -- High drive on port group 1 pins
    p1_sr : out std_logic;              -- Slew rate limit on port group 1 pins
    p2_hi : out std_logic;              -- High drive on port group 2 pins
    p2_sr : out std_logic;              -- Slew rate limit on port group 2 pins
    p3_hi : out std_logic;              -- High drive on port group 3 pins
    p3_sr : out std_logic;              -- Slew rate limit on port group 3 pins

    -- OSPI interface
    ospi_out         : out OSPI_InterfaceOut_t;
    ospi_dq_in       : in  std_logic_vector(7 downto 0);
    ospi_dq_out      : out std_logic_vector(7 downto 0);
    ospi_dq_enable   : out std_logic;
    ospi_rwds_in     : in  std_logic;
    ospi_rwds_out    : out std_logic;
    ospi_rwds_enable : out std_logic);

end entity digital_core;

architecture rtl of digital_core is

  component fpga_noc_adapter is
    generic (
      ionoc_fifo_depth_bits : integer                      := 4;  -- Each FIFO is 2^x = 16 words deep
      ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
      ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
      ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
      ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
      ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
      ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A");
    port (
      -- Domain clk_p
      ------------------------------------------------------
      clk_p     : in  std_logic;        -- Main clock
      clk_i_pos : in  std_logic;        --
      rst_n     : in  std_logic;        -- Async reset
      -- I/O bus
      idi       : in  std_logic_vector (7 downto 0);  -- I/O bus in
      ido       : out std_logic_vector (7 downto 0);  -- I/O bus out
      iden      : out std_logic;        -- I/O bus enabled (in use)
      ilioa     : in  std_logic;        -- I/O bus load I/O address
      ildout    : in  std_logic;        -- I/O bus data output strobe
      inext     : in  std_logic;        -- I/O bus data input  strobe
      idack     : in  std_logic;        -- I/O bus DMA Ack
      idreq     : out std_logic;        -- I/O bus DMA Request
      NOC_IRQ   : out std_logic;        -- Interrupt on available data from NOC
      ------------------------------------------------------


      -- Domain clk_noc
      ------------------------------------------------------
      clk_noc : in std_logic;           -- NOC Clock

      ------ CMD interface -------
      -- GPP CMD to NOC
      GPP_CMD      : out std_logic_vector(127 downto 0);  -- Command word
      GPP_CMD_Flag : out std_logic;     -- Command word valid
      NOC_CMD_ACK  : in  std_logic;     -- NOC ready
      -- NOC CMD to GPP
      NOC_CMD_Flag : in  std_logic;     -- NOC command byte is valid
      NOC_CMD      : in  std_logic_vector(7 downto 0);    -- Command byte
      GPP_CMD_ACK  : out std_logic;     -- GPP ack of command byte

      ------ DATA interface -------
      NOC_DATA_EN  : in  std_logic;  -- Enable traffic to (IO_DATA) or from (NOC_DATA) the NOC, dep on NOC_DATA_DIR
      NOC_DATA_DIR : in  std_logic;  -- Direction of NOC data transfer to/from FIFOs
      NOC_DATA     : in  std_logic_vector(127 downto 0);  -- Data to the TxFIFO
      IO_DATA      : out std_logic_vector(127 downto 0);  -- Data from the RxFIFO
      --
      FIFO_READY   : out std_logic_vector(ionoc_fifo_depth_bits downto 0);  -- FIFO level, filled or remaining dep on NO_DATA_DIR

      ------ IO interface --------
      NOC_ADDRESS   : in  std_logic_vector(31 downto 0);  -- Memory address of NOC data request
      NOC_LENGTH    : in  std_logic_vector(15 downto 0);  -- Length of NOC data request
      NOC_IO_DIR    : in  std_logic;    -- Direction of NOC data request
      NOC_WRITE_REQ : in  std_logic;  -- NOC address, length and data direction is valid
      IO_WRITE_ACK  : out std_logic  -- NOC data parameters have been read and can now be updated
     -------------------------------------------------------
      );
  end component;

  component Accelerator_Top is
    Generic(
        g_memory_type        : memory_type_t := asic
    );
    port (
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
        PEC_Ready            : in  std_logic;
        --Command interface signals 
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        GPP_CMD_Flag         : in  std_logic;
        NOC_CMD_ACK          : out std_logic;
        NOC_CMD_flag         : out std_logic;
        GPP_CMD_ACK          : in  std_logic;
        --Data/control interface signals
        IO_data              : in  std_logic_vector(127 downto 0);
        NOC_data             : out std_logic_vector(127 downto 0);
        NOC_Address          : out std_logic_vector(31 downto 0);           
        NOC_Length           : out std_logic_vector(15 downto 0);
        FIFO_Ready           : in  std_logic_vector(5 downto 0);
        NOC_DATA_DIR         : out std_logic;
        NOC_DATA_EN          : out std_logic;        
        NOC_WRITE_REQ        : out std_logic;
        IO_WRITE_ACK         : in  std_logic
  );
  end component;

-- noc_adapter_inst
  signal clk_i_pos     : std_logic;
  signal ext_iden      : std_logic;
  signal ext_idreq     : std_logic;
  signal ext_idack     : std_logic;
  signal ext_ilioa     : std_logic;
  signal ext_ildout    : std_logic;
  signal ext_inext     : std_logic;
  signal ext_idi       : std_logic_vector(7 downto 0);
  signal ext_ido       : std_logic_vector(7 downto 0);
  --
  signal NOC_IRQ       : std_logic;
  signal GPP_CMD       : std_logic_vector(127 downto 0);
  signal GPP_CMD_Flag  : std_logic;
  signal NOC_CMD_ACK   : std_logic;
  signal NOC_CMD_Flag  : std_logic;
  signal NOC_CMD       : std_logic_vector(7 downto 0);
  signal GPP_CMD_ACK   : std_logic;
  signal NOC_DATA_EN   : std_logic;
  signal NOC_DATA_DIR  : std_logic;
  signal NOC_DATA      : std_logic_vector(127 downto 0);
  signal IO_DATA       : std_logic_vector(127 downto 0);
  signal FIFO_READY    : std_logic_vector(ionoc_fifo_depth_bits downto 0);
  signal NOC_ADDRESS   : std_logic_vector(31 downto 0);
  signal NOC_LENGTH    : std_logic_vector(15 downto 0);
  signal NOC_IO_DIR    : std_logic;
  signal NOC_WRITE_REQ : std_logic;
  signal IO_WRITE_ACK  : std_logic;

begin  -- architecture rtl

  NOC_IO_DIR <= NOC_DATA_DIR; -- Use same signal for both FIFO xfer and IO request direction
  
  Accelerator_Top_inst : Accelerator_Top
    generic map(
      g_memory_type => g_memory_type )
    port map (
      clk           => clk_noc,
      Reset         => cpu_rst_n,
      PEC_Ready     => '0',
      GPP_CMD_ACK   => GPP_CMD_ACK,
      GPP_CMD_Flag  => GPP_CMD_Flag,
      GPP_CMD_Data  => GPP_CMD,
      NOC_CMD_flag  => NOC_CMD_flag,
      NOC_CMD_ACK   => NOC_CMD_ACK,
      NOC_CMD_Data  => NOC_CMD,
      IO_data       => IO_data,
      NOC_data      => NOC_data,
      NOC_Address   => NOC_Address,
      NOC_Length    => NOC_Length,
      NOC_WRITE_REQ => NOC_WRITE_REQ,
      IO_WRITE_ACK  => IO_WRITE_ACK,
      FIFO_Ready    => FIFO_Ready,
      NOC_DATA_DIR  => NOC_DATA_DIR,
      NOC_DATA_EN   => NOC_DATA_EN
      );

  noc_adapter_inst : fpga_noc_adapter
    generic map (
      ionoc_fifo_depth_bits => ionoc_fifo_depth_bits,  -- Each FIFO is 2^x = 16 words deep,
      ionoc_status_address  => x"45",
      ionoc_cmd_address     => x"46",
      ionoc_data_address    => x"47",
      ionoc_addr_address    => x"48",
      ionoc_length_address  => x"49",
      ionoc_datadir_address => x"4A")
    port map (
      clk_p         => clk_p_cpu,
      clk_i_pos     => clk_i_pos,
      rst_n         => cpu_rst_n,
      idi           => ext_idi,
      ido           => ext_ido,
      iden          => ext_iden,
      ilioa         => ext_ilioa,
      ildout        => ext_ildout,
      inext         => ext_inext,
      idack         => ext_idack,
      idreq         => ext_idreq,
      clk_noc       => clk_noc,
      --
      NOC_IRQ       => NOC_IRQ,
      GPP_CMD       => GPP_CMD,
      GPP_CMD_Flag  => GPP_CMD_Flag,
      NOC_CMD_ACK   => NOC_CMD_ACK,
      NOC_CMD_Flag  => NOC_CMD_Flag,
      NOC_CMD       => NOC_CMD,
      GPP_CMD_ACK   => GPP_CMD_ACK,
      NOC_DATA_EN   => NOC_DATA_EN,
      NOC_DATA_DIR  => NOC_DATA_DIR,
      NOC_DATA      => NOC_DATA,
      IO_DATA       => IO_DATA,
      FIFO_READY    => FIFO_READY,
      NOC_ADDRESS   => NOC_ADDRESS,
      NOC_LENGTH    => NOC_LENGTH,
      NOC_IO_DIR    => NOC_IO_DIR,
      NOC_WRITE_REQ => NOC_WRITE_REQ,
      IO_WRITE_ACK  => IO_WRITE_ACK
      );

  i_im4000_top : entity work.top
    generic map (
      g_memory_type     => g_memory_type,
      g_clock_frequency => 31           -- system clock frequency in MHz
      )
    port map (
      clk_p     => clk_p_cpu,
      clk_p_n   => clk_p_cpu_n,
      clk_rx    => clk_rx,
      clk_tx    => clk_tx,
      MRESET    => MRESET,
      rst_n     => cpu_rst_n,
      c1_wdog_n => c1_wdog_n,
      MRSTOUT   => MRSTOUT,
      MIRQOUT   => MIRQOUT,
      MCKOUT0   => MCKOUT0,
      MCKOUT1   => MCKOUT1,
      MTEST     => MTEST,
      MIRQ0     => MIRQ0,
      MIRQ1     => MIRQ1,
      -- SW debug
      MSDIN     => MSDIN,
      MSDOUT    => MSDOUT,

      clock_in_off => clock_in_off,
      clock_sel    => clock_sel,

      -- IO-bus interface to NOC adapter
      ext_i_pos  => clk_i_pos,
      ext_ido    => ext_ido,
      ext_iden   => ext_iden,
      ext_idreq  => ext_idreq,
      ext_idack  => ext_idack,
      ext_ilioa  => ext_ilioa,
      ext_ildout => ext_ildout,
      ext_inext  => ext_inext,
      ext_idi    => ext_idi,
      ext_irq    => NOC_IRQ,

      -- Port A
      pa_i  => pa_i,
      pa_en => pa_en,
      pa_o  => pa_o,
      -- Port B
      pb_i  => pb_i,
      pb_en => pb_en,
      pb_o  => pb_o,
      -- Port C
      pc_i  => pc_i,
      pc_en => pc_en,
      pc_o  => pc_o,
      -- Port D
      pd_i  => pd_i,
      pd_en => pd_en,
      pd_o  => pd_o,
      -- Port Eopen,
      pe_i  => pe_i,
      pe_en => pe_en,
      pe_o  => pe_o,
      -- Port F
      pf_i  => pf_i,
      pf_en => pf_en,
      pf_o  => pf_o,
      -- Port G
      pg_i  => pg_i,
      pg_en => pg_en,
      pg_o  => pg_o,
      -- Port H
      ph_i  => ph_i,
      ph_en => ph_en,
      ph_o  => ph_o,
      -- Port I
      pi_i  => pi_i,
      pi_en => pi_en,
      pi_o  => pi_o,
      -- Port J
      pj_i  => pj_i,
      pj_en => pj_en,
      pj_o  => pj_o,
      -- I/O cell configuration control outputs
      -- d_hi  => open,
      -- d_sr  => open,
      d_lo  => d_lo,
      p1_hi => p1_hi,
      p1_sr => p1_sr,
      p2_hi => p2_hi,
      p2_sr => p2_sr,
      p3_hi => p3_hi,
      p3_sr => p3_sr,

      MBYPASS    => MBYPASS,
      MWAKEUP_LP => MWAKEUP_LP,
      MLP_PWR_OK => MLP_PWR_OK,

      OSPI_Out    => ospi_out,
      OSPI_DQ_i   => ospi_dq_in,
      OSPI_DQ_o   => ospi_dq_out,
      OSPI_DQ_e   => ospi_dq_enable,
      OSPI_RWDS_i => ospi_rwds_in,
      OSPI_RWDS_o => ospi_rwds_out,
      OSPI_RWDS_e => ospi_rwds_enable,

      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => rxout,
      adc_bits => adc_bits
      );

end architecture rtl;
