library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package spi_tb_pack is

  ---------------------------------------------------------------------------
  --       _______                                                     ____
  --  cs_n        |___________________________________________________|
  --                  _   _        _             _   _         _
  --  sclk -|________| |_| |_.....| |___________| |_| |.......| |________
  --
  --        |bcs |  | adress byte   | dbb      | data byte      | belay_before_cs_high
  --              bsclk
  --
  -----------------------------------------------------------------------------

  constant spi_frequency_c : real := 20.0;  -- Frequency in MHz
  constant spi_freq_c      : time := (1.0/spi_frequency_c) * 1 us;  --Spi frequency/2

  constant address_length_c : integer := 15;

  constant delay_between_sclk_low_until_cs_low_c : time := 20 ns;  --bcs
  constant delay_after_cs_low_c                  : time := 0 ns;   -- bsclk
  constant delay_between_bytes_c                 : time := 1 ns;   --dbb
  constant delay_befor_cs_high_c                 : time := spi_freq_c;

  procedure spi_gl (
    constant data_in   : in  std_ulogic_vector;
    variable data_out  : out std_ulogic_vector;
    signal temp_spiclk : out std_ulogic;
    signal temp_cs     : out std_ulogic;
    signal spi_miso    : in  std_ulogic;
    signal temp_mosi   : out std_ulogic
    );

  procedure spi_send_gl (
    constant rw_bit      : in  std_ulogic;
    constant address     : in  integer;
    constant nr_byte     : in  integer;
    constant data_in     : in  std_ulogic_vector;
    variable status_data : out std_ulogic_vector(7 downto 0);
    variable data_out    : out std_ulogic_vector;
    signal temp_spiclk   : out std_ulogic;
    signal temp_cs       : out std_ulogic;
    signal temp_miso     : in  std_ulogic;
    signal temp_mosi     : out std_ulogic
    );

end spi_tb_pack;

package body spi_tb_pack is

  procedure spi_gl (
    constant data_in   : in  std_ulogic_vector;
    variable data_out  : out std_ulogic_vector;
    signal temp_spiclk : out std_ulogic;
    signal temp_cs     : out std_ulogic;
    signal spi_miso    : in  std_ulogic;
    signal temp_mosi   : out std_ulogic
    ) is
    variable spi_count : integer;
  begin
    spi_count := 8;
    while spi_count > 0 loop
      temp_spiclk           <= '0';
      temp_mosi             <= data_in(spi_count-1);
      wait for spi_freq_c;
      temp_spiclk           <= '1';
      data_out(spi_count-1) := spi_miso;
      wait for spi_freq_c;
      temp_spiclk           <= '0';
      spi_count             := spi_count - 1;
    end loop;
    wait for delay_between_bytes_c;
  end spi_gl;


  procedure spi_send_gl (
    constant rw_bit      : in  std_ulogic;
    constant address     : in  integer;
    constant nr_byte     : in  integer;
    constant data_in     : in  std_ulogic_vector;
    variable status_data : out std_ulogic_vector(7 downto 0);
    variable data_out    : out std_ulogic_vector;
    signal temp_spiclk   : out std_ulogic;
    signal temp_cs       : out std_ulogic;
    signal temp_miso     : in  std_ulogic;
    signal temp_mosi     : out std_ulogic
    ) is
    variable xin            : std_ulogic_vector(7 downto 0);
    variable xout           : std_ulogic_vector(7 downto 0);
    variable length         : integer;
    variable spi_byte_count : integer;
    variable data_out_temp  : std_ulogic_vector(data_out'length-1 downto 0) := (others => '0');
    variable address_var    : std_ulogic_vector(address_length_c-1 downto 0);
  begin

    temp_spiclk <= '0';
    wait for delay_between_sclk_low_until_cs_low_c;
    temp_cs     <= '0';
    wait for delay_after_cs_low_c;
    address_var := std_ulogic_vector(to_unsigned(address, address_length_c));

    spi_byte_count := (address_length_c+1) / 8;
    while spi_byte_count > 0 loop
      if spi_byte_count = (address_length_c+1) / 8 then
        xin := rw_bit & address_var(address_length_c-1 downto address_length_c - 7);
      else
        xin := address_var((8*spi_byte_count)-1 downto 8*(spi_byte_count-1));
      end if;
      spi_gl(xin, xout, temp_spiclk, temp_cs, temp_miso, temp_mosi);
      status_data    := xout;
      spi_byte_count := spi_byte_count - 1;
    end loop;
    length         := data_in'length;
    spi_byte_count := nr_byte;
    while spi_byte_count > 0 loop       -- little endian
      xin(7 downto 0) := data_in((8*spi_byte_count)-1 downto 8*(spi_byte_count-1));
      spi_gl(xin, xout, temp_spiclk, temp_cs, temp_miso, temp_mosi);

      data_out_temp((8*spi_byte_count)-1 downto 8*(spi_byte_count-1)) := xout;
      spi_byte_count                                                  := spi_byte_count - 1;
    end loop;
    data_out := data_out_temp;
    wait for delay_befor_cs_high_c;
    temp_cs  <= '1';
    wait for delay_between_bytes_c;
  end spi_send_gl;


end spi_tb_pack;
