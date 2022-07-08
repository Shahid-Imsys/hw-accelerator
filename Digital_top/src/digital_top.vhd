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
use work.data_types_pack.all;

entity digital_top is

  generic (
    g_memory_type     : memory_type_t := asic;
    g_simulation      : boolean := false;
    g_clock_frequency : integer);

  port (
    hclk        : in  std_logic;        -- clk input
    pll_ref_clk : in  std_logic;
    pll_locked  : in  std_logic;
    pre_spi_rst_n   : in  std_logic;  
    MRESET      : in  std_logic;        -- system reset, active low
    MRSTOUT     : out std_logic;
    MIRQOUT     : out std_logic;        -- interrupt request output
    MCKOUT0     : out std_logic;        -- for trace adapter
    MCKOUT1     : out std_logic;        -- programable clock out
    mckout1_en  : out std_logic;        -- Enable signal for MCKOUT1 pad.
    MTEST       : in  std_logic;        -- Active high
    MBYPASS     : in  std_logic;
    MIRQ0       : in  std_logic;        -- Active low
    MIRQ1       : in  std_logic;        -- Active low
    -- SW debug
    MSDIN       : in  std_logic;        -- serial data in (debug)
    MSDOUT      : out std_logic;        -- serial data out

    MWAKEUP_LP : in  std_logic;         -- Active high
    MLP_PWR_OK : in  std_logic;
    -- power management control
    MPMIC_CORE : out std_logic;
    MPMIC_IO   : out std_logic;

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
    -- pi_i  : in  std_logic_vector(7 downto 0);
    -- pi_en : out std_logic_vector(7 downto 0);
    -- pi_o  : out std_logic_vector(7 downto 0);
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
    ospi_cs_n        : out std_logic;
    ospi_ck_n        : out std_logic;
    ospi_ck_p        : out std_logic;
    ospi_reset_n     : out std_logic;
    ospi_dq_in       : in  std_logic_vector(7 downto 0);
    ospi_dq_out      : out std_logic_vector(7 downto 0);
    ospi_dq_enable   : out std_logic;
    ospi_rwds_in     : in  std_logic;
    ospi_rwds_out    : out std_logic;
    ospi_rwds_enable : out std_logic;
    
    dummy_output : out std_logic_vector(7 downto 0);

    -- SPI, chip control interface
    spi_sclk      : in  std_logic;
    spi_cs_n      : in  std_logic;
    spi_mosi      : in  std_logic;
    spi_miso      : out std_logic;
    spi_miso_oe_n : out std_logic;
    pad_config    : out pad_config_record_t;
    pll_config    : out pll_registers_record_t;
    adpll_config  : in adpll_registers_record_t
    );

end entity digital_top;

architecture rtl of digital_top is

  component test_spi_interface is
    port (
      rst_n        : in  std_ulogic;
      sclk_int     : in  std_ulogic;
      sclk_n       : in  std_ulogic;
      cs_n         : in  std_ulogic;
      mosi         : in  std_ulogic;
      miso         : out std_ulogic;
      miso_oe_n    : out std_ulogic;
      pad_config   : out pad_config_record_t;
      pll_config   : out pll_registers_record_t;
      adpll_config : in adpll_registers_record_t
      );
  end component;

  component SNPS_RF_SP_UHS_1024x8 is
    port (
      Q        : out std_logic_vector(7 downto 0);
      ADR      : in  std_logic_vector(9 downto 0);
      D        : in  std_logic_vector(7 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_RF_SP_UHS_1024x32 is
    port (
      Q        : out std_logic_vector(31 downto 0);
      ADR      : in  std_logic_vector(9 downto 0);
      D        : in  std_logic_vector(31 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_RF_SP_UHS_256x64 is
    port (
      Q        : out std_logic_vector(63 downto 0);
      ADR      : in  std_logic_vector(7 downto 0);
      D        : in  std_logic_vector(63 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_RF_SP_UHS_64x64 is
    port (
      Q        : out std_logic_vector(63 downto 0);
      ADR      : in  std_logic_vector(5 downto 0);
      D        : in  std_logic_vector(63 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_SP_HD_8Kx128 is
    port (
      Q        : out std_logic_vector(127 downto 0);
      ADR      : in  std_logic_vector(12 downto 0);
      D        : in  std_logic_vector(127 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_SP_HD_16Kx8
    port (
      Q        : out std_logic_vector(7 downto 0);
      ADR      : in  std_logic_vector(13 downto 0);
      D        : in  std_logic_vector(7 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic
      );
  end component;

  type slv8 is array(natural range <>) of std_logic_vector(7 downto 0);
  type slv64 is array(natural range <>) of std_logic_vector(63 downto 0);
  type slv128 is array(natural range <>) of std_logic_vector(127 downto 0);

  signal dummy_dout_1 : slv64(7 downto 0);
  signal dummy_dout_2a : slv8(7 downto 0);
  signal dummy_dout_2b : slv8(7 downto 0);
  signal dummy_dout_3 : std_logic_vector(31 downto 0);
  signal dummy_dout_4 : slv64(15 downto 0);
  signal dummy_dout_5 : slv64(15 downto 0);
  signal dummy_dout_6 : slv64(15 downto 0);
  signal dummy_dout_7 : slv128(3 downto 0);
  signal dummy_dout_8 : slv128(3 downto 0);

  signal dummy_addr : std_logic_vector(13 downto 0);
  signal dummy_din  : std_logic_vector(127 downto 0);
  signal dummy_we   : std_logic_vector(108 downto 0);

  signal ospi_dq_out_int : std_logic_vector(7 downto 0);

  constant asic_c : memory_type_t := asic;

  signal clk_p_cpu   : std_logic;
  signal clk_p_cpu_n : std_logic;
  signal clk_rx      : std_logic;
  signal clk_tx      : std_logic;

  signal sclk   : std_logic;
  signal sclk_n : std_logic;

  signal spi_rst_n    : std_logic;
  signal cpu_rst_n    : std_logic;
  signal clock_in_off : std_logic;
  signal clock_sel    : std_logic; 
  signal c1_wdog_n    : std_logic;

  signal pi_data : std_logic_vector(7 downto 0);

begin  -- architecture rtl

  ospi_dq_out <= ospi_dq_out_int;

  i_clock_reset : entity work.clock_reset

    generic map (
      fpga_g => (asic_c = fpga))

    port map (
      pll_clk     => hclk,
      pll_ref_clk => pll_ref_clk,
      spi_sclk    => spi_sclk,

      pre_spi_rst_n => pre_spi_rst_n,
      mreset_n => mreset,
      pwr_ok   => pwr_ok,
      c1_wdog_n => c1_wdog_n,

      rst_n => cpu_rst_n,
      spi_rst_n => spi_rst_n,

      clk_p  => clk_p_cpu,
      clk_p_n => clk_p_cpu_n,
      clk_rx => clk_rx,
      clk_tx => clk_tx,
      sclk   => sclk,
      sclk_n => sclk_n,

      pg_1_i => pg_i(1),
      pf_1_i => pf_i(1),

      clock_in_off => clock_in_off,
      sel_pll => clock_sel,
      spi_sel_pll  => '1',

      spi_override_pll_locked => '0',
      pll_locked              => pll_locked,

      scan_mode => mtest
      );

  i_digital_core : entity work.digital_core
    generic map (
      g_memory_type     => g_memory_type,
      g_clock_frequency => g_clock_frequency  -- system clock frequency in MHz
      )
    port map (
      clk_p_cpu => clk_p_cpu,
      clk_p_cpu_n => clk_p_cpu_n,
      clk_rx    => clk_rx,
      clk_tx    => clk_tx,

      cpu_rst_n => cpu_rst_n,

      MRESET  => MRESET,
      c1_wdog_n => c1_wdog_n,
      MRSTOUT => MRSTOUT,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      MCKOUT1 => MCKOUT1,
      MTEST   => MTEST,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug
      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,

      clock_in_off => clock_in_off,
      clock_sel    => clock_sel,

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
      pi_i  => pi_data,
      pi_en => open,
      pi_o  => pi_data,
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

      ospi_out.cs_n    => ospi_cs_n,
      ospi_out.ck_n    => ospi_ck_n,
      ospi_out.ck_p    => ospi_ck_p,
      ospi_out.reset_n => ospi_reset_n,
      ospi_dq_in       => ospi_dq_in,
      ospi_dq_out      => ospi_dq_out_int,
      ospi_dq_enable   => ospi_dq_enable,
      ospi_rwds_in     => ospi_rwds_in,
      ospi_rwds_out    => ospi_rwds_out,
      ospi_rwds_enable => ospi_rwds_enable,


      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => rxout,
      adc_bits => adc_bits
      );

  i_test_spi_interface : test_spi_interface
    port map
    (
      rst_n        => spi_rst_n,
      sclk_int     => sclk,
      sclk_n       => sclk_n,
      cs_n         => spi_cs_n,
      mosi         => spi_mosi,
      miso         => spi_miso,
      miso_oe_n    => spi_miso_oe_n,
      pad_config   => pad_config,
      pll_config   => pll_config,
      adpll_config => adpll_config
      );

  -- All "dummy" named instances and signals are temporary and are to be soon removed!!
  
  asic_dummy_memories: if g_memory_type = asic and not g_simulation generate
  
    dummy_signal_proc: process( hclk )
        variable offset :  integer := 0;
        variable index   : integer := 0;
        variable lvector : std_logic_vector(4767 downto 0);

    begin
      if false then
        -- No reset available?

      elsif rising_edge(hclk) then

        dummy_addr <= dummy_addr(5 downto 0) & ospi_dq_out_int;
        dummy_din <= (ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int &
                      ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int &
                      ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int &
                      ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int & ospi_dq_out_int)
                     xor dummy_dout_7(3)
                     xor dummy_dout_7(2)
                     xor dummy_dout_7(1)
                     xor dummy_dout_7(0);

        dummy_we       <= dummy_din(107 downto 0) & lvector(index);
        dummy_output   <= dummy_we(7 downto 0);

        if index = 4767 then
          index := 0;
        else
          index := index + 1;
        end if;

        offset := 0;
        for i in dummy_dout_1'range loop  -- 8 * 64 = 512
          lvector(i*64 + 63 + offset downto i*64 + offset) := dummy_dout_1(i);
        end loop;

        offset := offset + 512;
        for i in dummy_dout_2a'range loop  -- 8 * 8 = 64
          lvector(i*8 + 7 + offset downto i*8 + offset) := dummy_dout_2a(i);
        end loop;

        offset := offset + 64;
        for i in dummy_dout_2b'range loop  -- 8 * 8 = 64
          lvector(i*8 + 7 + offset downto i*8 + offset) := dummy_dout_2b(i);
        end loop;

        offset := offset + 64;
        lvector(offset+31 downto offset) := dummy_dout_3;

        offset := offset + 32;
        for i in dummy_dout_4'range loop  -- 16 * 64 = 1024
          lvector(i*64 + 63 + offset downto i*64 + offset) := dummy_dout_4(i);
        end loop;

        offset := offset + 1024;
        for i in dummy_dout_5'range loop  -- 16 * 64 = 1024
          lvector(i*64 + 63 + offset downto i*64 + offset) := dummy_dout_5(i);
        end loop;

        offset := offset + 1024;
        for i in dummy_dout_6'range loop  -- 16 * 64 = 1024
          lvector(i*64 + 63 + offset downto i*64 + offset) := dummy_dout_6(i);
        end loop;

        offset := offset + 1024;
        for i in dummy_dout_7'range loop  -- 4 * 128 = 512
          lvector(i*128 + 127 + offset downto i*128 + offset) := dummy_dout_7(i);
        end loop;

        offset := offset + 512;
        for i in dummy_dout_8'range loop  -- 4 * 128 = 512
          lvector(i*128 + 127 + offset downto i*128 + offset) := dummy_dout_8(i);
        end loop;

        --offset := offset + 512;

      end if;
    end process;


    mpgm_gen : for i in dummy_dout_1'range generate
      mpram00 : SNPS_RF_SP_UHS_256x64
        port map (
          Q        => dummy_dout_1(i),
          ADR      => dummy_addr(7 downto 0),
          D        => dummy_din(63 downto 0),
          WE       => dummy_we(0 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;

    gmem1_gen : for i in dummy_dout_2a'range generate
      gmem1: SNPS_RF_SP_UHS_1024x8
        port map (
          Q        => dummy_dout_2a(i),
          ADR      => dummy_addr(9 downto 0),
          D        => dummy_din(7 downto 0),
          WE       => dummy_we(8 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;
    
    gmem2_gen : for i in dummy_dout_2b'range generate
      gmem2: SNPS_RF_SP_UHS_1024x8
        port map (
          Q        => dummy_dout_2b(i),
          ADR      => dummy_addr(9 downto 0),
          D        => dummy_din(7 downto 0),
          WE       => dummy_we(8 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;

    fifo_memory : SNPS_RF_SP_UHS_1024x32
      port map (
        Q        => dummy_dout_3,
        ADR      => dummy_addr(9 downto 0),
        D        => dummy_din(31 downto 0),
        WE       => dummy_we(24),
        ME       => '1',
        CLK      => hclk,
        TEST1    => '0',
        TEST_RNM => '0',
        RME      => '0',
        RM       => (others => '0'),
        WA       => (others => '0'),
        WPULSE   => (others => '0'),
        LS       => '0',
        BC0      => '0',
        BC1      => '0',
        BC2      => '0');

    ve_l_gen : for i in dummy_dout_4'range generate
      buf_1 : SNPS_RF_SP_UHS_256x64
        port map (
          Q        => dummy_dout_4(i),
          ADR      => dummy_addr(7 downto 0),
          D        => dummy_din(63 downto 0),
          WE       => dummy_we(25 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;

    ve_r_gen : for i in dummy_dout_5'range generate
      buf_0 : SNPS_RF_SP_UHS_256x64
        port map (
          Q        => dummy_dout_5(i),
          ADR      => dummy_addr(7 downto 0),
          D        => dummy_din(63 downto 0),
          WE       => dummy_we(41 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;
    
    ve_bias_gen : for i in dummy_dout_6'range generate
      buf_bias : SNPS_RF_SP_UHS_64x64
        port map (
          Q        => dummy_dout_6(i),
          ADR      => dummy_addr(5 downto 0),
          D        => dummy_din(63 downto 0),
          WE       => dummy_we(57 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;

    cm_clust_gen : for i in dummy_dout_7'range generate
      clustermem : SNPS_SP_HD_8Kx128
        port map (
          Q        => dummy_dout_7(i),
          ADR      => dummy_addr(12 downto 0),
          D        => dummy_din(127 downto 0),
          WE       => dummy_we(73 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;

    rm_gen : for i in dummy_dout_8'range generate
      root_memory_inst : SNPS_SP_HD_8Kx128
        port map (
          Q        => dummy_dout_8(i),
          ADR      => dummy_addr(12 downto 0),
          D        => dummy_din(127 downto 0),
          WE       => dummy_we(77 + i),
          ME       => '1',
          CLK      => hclk,
          TEST1    => '0',
          TEST_RNM => '0',
          RME      => '0',
          RM       => (others => '0'),
          WA       => (others => '0'),
          WPULSE   => (others => '0'),
          LS       => '0',
          BC0      => '0',
          BC1      => '0',
          BC2      => '0');
    end generate;
  end generate;
    
   asic_dummy_output: if g_memory_type /= asic or g_simulation generate
    dummy_output <= (others => '0');
  end generate;

end architecture rtl;
