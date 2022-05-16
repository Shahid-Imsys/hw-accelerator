library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_imsys_demo.all;
use work.project_settings.all;
use work.register_record_pack.all;
use work.data_types_pack.all;

entity test_init is
  port (
    rst_n               : in  std_ulogic;
    spi_rst_n_i         : in  std_ulogic;
    sclk_int            : in  std_ulogic;
    sclk_n              : in  std_ulogic;
    cs_n                : in  std_ulogic;
    mosi                : in  std_ulogic;
    miso                : out std_ulogic;
    miso_oe_n           : out std_ulogic;
    pad_config          : out pad_config_record_t
    );

end entity test_init;

architecture rtl of test_init is

  component spi_interface is
    generic (
      data_width_g           : natural   := 8;
      address_width_g        : natural   := 7;
      start_burst_adresses_g : natural   := 16#ff#;
      write_value_g          : std_logic := '0'
      );
    port (
      clk       : in  std_ulogic;       -- Clock from microcontroller spi
      nclk      : in  std_ulogic;       -- Invers clk
      spi_rst_n : in  std_ulogic;
      rst_n     : in  std_ulogic;
      cs_n      : in  std_ulogic;
      mosi      : in  std_ulogic;       -- Master output Slave input
      miso      : out std_ulogic;       -- Master input Slave Output
      miso_oe_n : out std_ulogic;

      write_spi : out std_ulogic;
      enable    : out std_ulogic;
      address   : out unsigned(address_width_g - 1 downto 0);
      data_in   : in  std_ulogic_vector(spi_data_width_c - 1 downto 0);
      data_out  : out std_ulogic_vector(spi_data_width_c - 1 downto 0);

      update_buffer_index : out std_ulogic
      );
  end component spi_interface;

  signal sub_word            : std_ulogic_vector(15 downto 0);
  signal write_data          : std_ulogic;
  signal address             : unsigned(spi_address_width_c - 1 downto 0);
  signal register_enable     : std_ulogic;
  signal register_data_in    : std_ulogic_vector(spi_data_width_c-1 downto 0) := (others => '0');
  signal register_data_out   : std_ulogic_vector(spi_data_width_c-1 downto 0) := (others => '0');
  signal update_buffer_index : std_ulogic;

  constant version_str : string := temp_version_imsys_demo(12 to 16);

begin  -- architecture rtl

  sub_word <= str_to_stdUlogicVector (version_str);

  i_register_block_imsys_demo : register_block_imsys_demo
    port map (
      clk                             => sclk_n,
      rst_n                           => rst_n,
      version_analog                  => x"0",
      version_digital                 => x"1",
      subversion_hi_byte_sub_hi_byte  => sub_word(15 downto 8),
      subversion_low_byte_sub_lo_byte => sub_word(7 downto 0),

      mclkout_ds  => pad_config.mckout.ds,
      mclkout_sr  => pad_config.mckout.sr,
      mclkout_co  => pad_config.mckout.co,
      mclkout_odp => pad_config.mckout.odp,
      mclkout_odn => pad_config.mckout.odn,
      msdout_ds   => pad_config.msdout.ds,
      msdout_sr   => pad_config.msdout.sr,
      msdout_co   => pad_config.msdout.co,
      msdout_odp  => pad_config.msdout.odp,
      msdout_odn  => pad_config.msdout.odn,
      utx_ds      => pad_config.utx.ds,
      utx_sr      => pad_config.utx.sr,
      utx_co      => pad_config.utx.co,
      utx_odp     => pad_config.utx.odp,
      utx_odn     => pad_config.utx.odn,
      mirqout_ds  => pad_config.mirqout.ds,
      mirqout_sr  => pad_config.mirqout.sr,
      mirqout_co  => pad_config.mirqout.co,
      mirqout_odp => pad_config.mirqout.odp,
      mirqout_odn => pad_config.mirqout.odn,
      msdin_ste   => pad_config.msdin.ste,
      msdin_pd    => pad_config.msdin.pd,
      msdin_pu    => pad_config.msdin.pu,
      mirq0_ste   => pad_config.mirq0.ste,
      mirq0_pd    => pad_config.mirq0.pd,
      mirq0_pu    => pad_config.mirq0.pu,
      mirq1_ste   => pad_config.mirq1.ste,
      mirq1_pd    => pad_config.mirq1.pd,
      mirq1_pu    => pad_config.mirq1.pu,
      urx_ste     => pad_config.urx.ste,
      urx_pd      => pad_config.urx.pd,
      urx_pu      => pad_config.urx.pu,

      write_cmd => write_data,
      enable    => register_enable,
      address   => std_ulogic_vector(address(3 downto 0)),
      data_in   => register_data_in(7 downto 0),
      data_out  => register_data_out(7 downto 0)
      );

  i_spi_inteface : spi_interface
    generic map (
      data_width_g           => spi_data_width_c,
      address_width_g        => spi_address_width_c,
      start_burst_adresses_g => 16#40#,
      write_value_g          => '0'
      )
    port map (
      clk                 => sclk_int,
      nclk                => sclk_n,
      spi_rst_n           => spi_rst_n_i,
      rst_n               => rst_n,
      cs_n                => cs_n,
      mosi                => mosi,
      miso                => miso,
      miso_oe_n           => miso_oe_n,
      write_spi           => write_data,
      enable              => register_enable,
      address             => address,
      data_in             => register_data_out,
      data_out            => register_data_in,
      update_buffer_index => update_buffer_index);


end architecture rtl;


