library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

use work.spi_tb_pack.all;
use work.project_settings.all;
use work.register_pack_spi_test.all;
use work.register_tb_package.all;
use work.register_tb_definitions.all;
use work.data_types_pack.all;

entity register_test_tb is
  end register_test_tb;

architecture tb of register_test_tb is

  component digital_chip is
    port 
    (
      -- PLL reference clock
      pll_ref_clk : inout  std_logic;
      -- reset pins
      preset_n    : inout  std_logic;  -- Power on reset
      mreset_n    : inout  std_logic;  -- Functional reset
      mrstout_n   : inout  std_logic;  -- reset output for external components

      -- Ethernet Interface
      enet_mdio : inout std_logic;
      enet_mdc  : inout std_logic;
      enet_clk  : inout std_logic;
      enet_txen : inout std_logic;
      enet_txer : inout std_logic;
      enet_txd0 : inout std_logic;
      enet_txd1 : inout std_logic;
      enet_rxdv : inout std_logic;
      enet_rxer : inout std_logic;
      enet_rxd0 : inout std_logic;
      enet_rxd1 : inout std_logic;

      -- Octal_spi
      emem_clk   : out   std_logic;
      emem_rst_n : out   std_logic;
      emem_cs_n  : out   std_logic;
      emem_rwds  : inout std_logic;
      emem_d0    : inout std_logic;
      emem_d1    : inout std_logic;
      emem_d2    : inout std_logic;
      emem_d3    : inout std_logic;
      emem_d4    : inout std_logic;
      emem_d5    : inout std_logic;
      emem_d6    : inout std_logic;
      emem_d7    : inout std_logic;

      -- SPI, chip control interface
      spi_sclk : inout std_logic;
      spi_cs_n : inout std_logic;
      spi_mosi : inout std_logic;
      spi_miso : inout std_logic;

      -- IM400 DEBUG interface
      mclkout : inout std_logic;
      msdin   : inout  std_logic;
      msdout  : inout std_logic;
      mirqout : inout std_logic;


      -- IM4000 Boot interface
      pa0_sin : inout std_logic;
      pa5_sin : inout std_logic;
      pa6_sin : inout std_logic;
      pa7_sin : inout std_logic;

      -- I/O bus

      -- DAC and ADC pins
      aout0 : inout std_logic;
      aout1 : inout std_logic;
      ach0  : inout  std_logic;

      -- UART
      utx : inout std_logic;
      urx : inout  std_logic;

      -- Msic. ports
      pg0 : inout std_logic;
      pg1 : inout std_logic;
      pg2 : inout std_logic;
      pg3 : inout std_logic;
      pg4 : inout std_logic;
      pg5 : inout std_logic;
      pg6 : inout std_logic;
      pg7 : inout std_logic;

      mtest  : inout std_logic;  -- port for testmode
      mwake  : inout std_logic;  -- Wake up signal, from what???
      mrxout : inout std_logic;  -- RTC test signal/power supply wake up

      -- interrupts
      mirq0_n : inout std_logic;
      mirq1_n : inout std_logic
    );
  end component;

  signal pll_ref_clk : std_logic := '0';
  signal preset_n    : std_logic := '0';  -- Power on reset
  signal mreset_n    : std_logic := '0';  -- Functional reset
  signal mrstout_n   : std_logic := '0';  -- reset output for external components
  signal enet_mdio   : std_logic := '0';
  signal enet_mdc    : std_logic := '0';
  signal enet_clk    : std_logic := '0';
  signal enet_txen   : std_logic := '0';
  signal enet_txer   : std_logic := '0';
  signal enet_txd0   : std_logic := '0';
  signal enet_txd1   : std_logic := '0';
  signal enet_rxdv   : std_logic := '0';
  signal enet_rxer   : std_logic := '0';
  signal enet_rxd0   : std_logic := '0';
  signal enet_rxd1   : std_logic := '0';
  signal emem_clk    : std_logic := '0';
  signal emem_rst_n  : std_logic := '0';
  signal emem_cs_n   : std_logic := '0';
  signal emem_rwds   : std_logic := '0';
  signal emem_d0     : std_logic := '0';
  signal emem_d1     : std_logic := '0';
  signal emem_d2     : std_logic := '0';
  signal emem_d3     : std_logic := '0';
  signal emem_d4     : std_logic := '0';
  signal emem_d5     : std_logic := '0';
  signal emem_d6     : std_logic := '0';
  signal emem_d7     : std_logic := '0';
  signal spi_sclk    : std_logic := '1';
  signal spi_cs_n    : std_logic := '0';
  signal spi_mosi    : std_logic := '0';
  signal spi_miso    : std_logic := '0';
  signal mclkout     : std_logic := '0';
  signal msdin       : std_logic := '0';
  signal msdout      : std_logic := '0';
  signal mirqout     : std_logic := '0';
  signal pa0_sin     : std_logic := '0';
  signal pa5_sin     : std_logic := '0';
  signal pa6_sin     : std_logic := '0';
  signal pa7_sin     : std_logic := '0';
  signal aout0       : std_logic := '0';
  signal aout1       : std_logic := '0';
  signal ach0        : std_logic := '0';
  signal utx         : std_logic := '0';
  signal urx         : std_logic := '0';
  signal pg0         : std_logic := '0';
  signal pg1         : std_logic := '0';
  signal pg2         : std_logic := '0';
  signal pg3         : std_logic := '0';
  signal pg4         : std_logic := '0';
  signal pg5         : std_logic := '0';
  signal pg6         : std_logic := '0';
  signal pg7         : std_logic := '0';
  signal mtest       : std_logic := '0';  -- port for testmode
  signal mwake       : std_logic := '0';  -- Wake up signal, from what???
  signal mrxout      : std_logic := '0';  -- RTC test signal/power supply wake up
  signal mirq0_n     : std_logic := '0';
  signal mirq1_n     : std_logic := '0';

-- The addres length is defined in spi_tb_pack.vhd in
-- verification/package_tb/
  constant data_length_c   : integer := 8;
  constant read_bit_c      : std_ulogic := '1';

  constant osc_frequency : real := 12.0;  -- MHZ
  constant osc_period    : time := 1 us / osc_frequency;
  signal osc_clk         : std_ulogic := '0';

  signal sclk            : std_logic := '0';
  signal rst_n           : std_logic := '0';
  signal cs_n            : std_logic := '1';
  signal mosi            : std_logic := '0';
  signal miso            : std_logic := '0';

  signal pad_config : pad_config_record_t;

  constant version_str : string := temp_version_spi_test(12 to 15);
  constant version : std_ulogic_vector := str_to_stdUlogicVector (version_str);

begin  -- tb

  osc_clk <= not osc_clk after osc_period / 2;

  i_digital_chip : digital_chip
  port map
  (
    -- PLL reference clock
    pll_ref_clk => pll_ref_clk,
    -- reset pins
    preset_n  => rst_n,
    mreset_n  => open,
    mrstout_n => mrstout_n,

    -- Ethernet Interface
    enet_mdio => enet_mdio,
    enet_mdc  => enet_mdc,
    enet_clk  => enet_clk,
    enet_txen => enet_txen,
    enet_txer => enet_txer,
    enet_txd0 => enet_txd0,
    enet_txd1 => enet_txd1,
    enet_rxdv => enet_rxdv,
    enet_rxer => enet_rxer,
    enet_rxd0 => enet_rxd0,
    enet_rxd1 => enet_rxd1,

    -- Octal_spi
    emem_clk   => emem_clk,
    emem_rst_n => emem_rst_n,
    emem_cs_n  => emem_cs_n,
    emem_rwds  => emem_rwds,
    emem_d0    => emem_d0,
    emem_d1    => emem_d1,
    emem_d2    => emem_d2,
    emem_d3    => emem_d3,
    emem_d4    => emem_d4,
    emem_d5    => emem_d5,
    emem_d6    => emem_d6,
    emem_d7    => emem_d7,

    -- SPI, chip control interface
    spi_sclk => sclk,
    spi_cs_n => cs_n,
    spi_mosi => mosi,
    spi_miso => miso,

    -- IM400 DEBUG interface
    mclkout => mclkout,
    msdin   => msdin,
    msdout  => msdout,
    mirqout => mirqout,


    -- IM4000 Boot interface
    pa0_sin => pa0_sin,
    pa5_sin => pa5_sin,
    pa6_sin => pa6_sin,
    pa7_sin => pa7_sin,

    -- I/O bus

    -- DAC and ADC pins
    aout0 => aout0,
    aout1 => aout1,
    ach0  => ach0,

    -- UART
    utx => utx,
    urx => urx,

    -- Msic. ports
    pg0 => pg0,
    pg1 => pg1,
    pg2 => pg2,
    pg3 => pg3,
    pg4 => pg4,
    pg5 => pg5,
    pg6 => pg6,
    pg7 => pg7,

    mtest  => mtest,
    mwake  => mwake,
    mrxout => mrxout,

    -- interrupts
    mirq0_n => mirq0_n,
    mirq1_n => mirq1_n
  );


  spi_register_test : process is
    ---------------------------------------------------------------------------
    -- Write a value to a specific register
    ---------------------------------------------------------------------------
    procedure spi_write (address : in integer; data : in std_ulogic_vector) is
                         variable status   : std_ulogic_vector(7 downto 0);
                         variable data_out : std_ulogic_vector(data'length-1 downto 0);

                         alias l_data : std_ulogic_vector(data'length-1 downto 0) is data;

                         constant byte_length_c : integer := data'length/8;
    begin  -- spi_send
      spi_send_gl(not read_bit_c, address, byte_length_c, l_data, status, data_out,
      sclk, cs_n, miso, mosi);
    end spi_write;

    procedure spi_write (address : in integer; data : in std_ulogic_vector; result : out std_ulogic_vector) is
                         variable status   : std_ulogic_vector(7 downto 0);
                         variable data_out : std_ulogic_vector(data'length-1 downto 0);

                         alias l_data : std_ulogic_vector(data'length-1 downto 0) is data;

                         constant byte_length_c : integer := data'length/8;
    begin  -- spi_send
      spi_send_gl(not read_bit_c, address, byte_length_c, l_data, status, data_out,
      sclk, cs_n, miso, mosi);
      result := data_out;
    end spi_write;

    ---------------------------------------------------------------------------
    -- Read data froma  specific register
    ---------------------------------------------------------------------------
    procedure spi_read (constant address : in integer; data : out std_ulogic_vector) is
                        variable status  : std_ulogic_vector(7 downto 0);
                        variable data_in : std_ulogic_vector(data'length-1 downto 0) := (others => '0');

                        alias l_data           : std_ulogic_vector(data'length-1 downto 0) is data;
                        constant byte_length_c : integer := data'length/8;
    begin  -- spi_send

      spi_send_gl(read_bit_c, address, byte_length_c, data_in, status, data,
      sclk, cs_n, miso, mosi);
    end spi_read;

    ---------------------------------------------------------------------------
    -- Testbench support functions
    ---------------------------------------------------------------------------
    impure function check_values (
    recieved : std_ulogic_vector;
    expected : std_ulogic_vector;
    name     : string)
    return boolean is

      variable result : boolean;
      variable l : line;
    begin  -- function check_reset_values
      if recieved /= expected then
        write(l, string'("register: " & name & " has wrong value: "));
        hwrite(l, recieved);
        write(l, string'(" expected: "));
        hwrite(l, expected);
        result := false;
      else
        write(l, string'("register: " & name));
        result := true;
      end if;
      writeline(output, l);
      return result;
    end function check_values;

    impure function check_values (
    recieved : std_ulogic_vector;
    written  : std_ulogic_vector;
    reg               : register_record_t)
    return boolean is
    begin  -- function check_reset_values
      return check_values(recieved, written and reg.mask, trim(reg.name));
    end function check_values;

    impure function check_reset_values (
    recieved : std_ulogic_vector;
    reg      : register_record_t)
    return boolean is
    begin  -- function check_reset_values
      return check_values(recieved, reg.reset, trim(reg.name));
    end function check_reset_values;

    procedure write_register_test (
                                    test_value : in    std_ulogic_vector;
                                    passed     : inout boolean;
                                    register_list : in register_list_t)
                                    is

                                    constant local_reg_list : register_list_t := get_all_rw_registers(register_list);
                                    variable l : line;
                                    variable data : std_ulogic_vector(7 downto 0);
    begin  -- procedure write_register_test

      write(l, string'("write started"));
      writeline(output, l);
      for i in local_reg_list'range loop
        spi_write(local_reg_list(i).address, test_value, data);
        spi_read(local_reg_list(i).address, data);
        passed := check_values(data, test_value, local_reg_list(i)) and passed;
      end loop;  -- i

      write(l, string'("read and check write started"));
      writeline(output, l);

      for i in local_reg_list'range loop
        spi_read(local_reg_list(i).address, data);
        passed := check_values(data, test_value, local_reg_list(i)) and passed;
      end loop;  -- i
    end procedure write_register_test;

    ---------------------------------------------------------------------------
    -- variables use in the process
    ---------------------------------------------------------------------------
    variable l : line;

    variable data : std_ulogic_vector(data_length_c-1 downto 0);
    variable all_tests_passed : boolean := true;

  begin  -- process spi_register_test

    cs_n <= '1';
    mosi <= '0';
    sclk <= '0';
    
    rst_n <= '0';
    wait for 100 ns;
    rst_n <= '1';

    wait for 100 ns;

    -- Check all reset values
    write(l, string'("Reset value check strats"));
    writeline(output, l);
    for i in all_register_list'range loop
      spi_read(all_register_list(i).address, data);
      all_tests_passed := check_reset_values(data, all_register_list(i)) and all_tests_passed;       
    end loop;  -- i

    -- Check write to register
    write(l, string'("write register test started"));
    writeline(output, l);
    writeline(output, l);

    write_register_test (x"00", all_tests_passed, all_register_list);
    write_register_test (x"FF", all_tests_passed, all_register_list);

    wait for 100 ns;

    if all_tests_passed then
      std.env.stop(0);
    else
      assert false report "Simulation finshed WITH ERROR" severity failure;
    end if;

  end process spi_register_test;

end tb;
