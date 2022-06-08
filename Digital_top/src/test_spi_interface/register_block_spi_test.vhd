library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.all;

entity register_block_spi_test is

    port (
          clk   : in std_ulogic;
          rst_n : in std_ulogic;

          -- Registerfields
          version_analog : in version_analog_t;
          version_digital : in version_digital_t;
          mclkout_ds : out mclkout_ds_t;
          mclkout_sr : out mclkout_sr_t;
          mclkout_co : out mclkout_co_t;
          mclkout_odp : out mclkout_odp_t;
          mclkout_odn : out mclkout_odn_t;
          msdout_ds : out msdout_ds_t;
          msdout_sr : out msdout_sr_t;
          msdout_co : out msdout_co_t;
          msdout_odp : out msdout_odp_t;
          msdout_odn : out msdout_odn_t;
          utx_ds : out utx_ds_t;
          utx_sr : out utx_sr_t;
          utx_co : out utx_co_t;
          utx_odp : out utx_odp_t;
          utx_odn : out utx_odn_t;
          mirqout_ds : out mirqout_ds_t;
          mirqout_sr : out mirqout_sr_t;
          mirqout_co : out mirqout_co_t;
          mirqout_odp : out mirqout_odp_t;
          mirqout_odn : out mirqout_odn_t;
          msdin_ste : out msdin_ste_t;
          msdin_pd : out msdin_pd_t;
          msdin_pu : out msdin_pu_t;
          mirq0_ste : out mirq0_ste_t;
          mirq0_pd : out mirq0_pd_t;
          mirq0_pu : out mirq0_pu_t;
          mirq1_ste : out mirq1_ste_t;
          mirq1_pd : out mirq1_pd_t;
          mirq1_pu : out mirq1_pu_t;
          urx_ste : out urx_ste_t;
          urx_pd : out urx_pd_t;
          urx_pu : out urx_pu_t;


          -- SPI Interface
          write_cmd : in  std_ulogic;
          enable    : in  std_ulogic;
          address   : in  std_ulogic_vector(3 downto 0);
          data_in   : in  std_ulogic_vector(7 downto 0);
          data_out  : out std_ulogic_vector(7 downto 0)
    );

end register_block_spi_test;

architecture rtl of register_block_spi_test  is

    signal s_mclkout_ds : mclkout_ds_t;
    signal s_mclkout_sr : mclkout_sr_t;
    signal s_mclkout_co : mclkout_co_t;
    signal s_mclkout_odp : mclkout_odp_t;
    signal s_mclkout_odn : mclkout_odn_t;
    signal s_msdout_ds : msdout_ds_t;
    signal s_msdout_sr : msdout_sr_t;
    signal s_msdout_co : msdout_co_t;
    signal s_msdout_odp : msdout_odp_t;
    signal s_msdout_odn : msdout_odn_t;
    signal s_utx_ds : utx_ds_t;
    signal s_utx_sr : utx_sr_t;
    signal s_utx_co : utx_co_t;
    signal s_utx_odp : utx_odp_t;
    signal s_utx_odn : utx_odn_t;
    signal s_mirqout_ds : mirqout_ds_t;
    signal s_mirqout_sr : mirqout_sr_t;
    signal s_mirqout_co : mirqout_co_t;
    signal s_mirqout_odp : mirqout_odp_t;
    signal s_mirqout_odn : mirqout_odn_t;
    signal s_msdin_ste : msdin_ste_t;
    signal s_msdin_pd : msdin_pd_t;
    signal s_msdin_pu : msdin_pu_t;
    signal s_mirq0_ste : mirq0_ste_t;
    signal s_mirq0_pd : mirq0_pd_t;
    signal s_mirq0_pu : mirq0_pu_t;
    signal s_mirq1_ste : mirq1_ste_t;
    signal s_mirq1_pd : mirq1_pd_t;
    signal s_mirq1_pu : mirq1_pu_t;
    signal s_urx_ste : urx_ste_t;
    signal s_urx_pd : urx_pd_t;
    signal s_urx_pu : urx_pu_t;

    signal s_address : integer range 0 to (2**4) - 1;

begin

  s_address <= to_integer(unsigned(address));

  register_proc : process (clk, rst_n)
  begin  -- process register
    if rst_n = '0' then               -- asynchronous reset (active low)
      s_mclkout_ds <= mclkout_ds_reset_c;
      s_mclkout_sr <= mclkout_sr_reset_c;
      s_mclkout_co <= mclkout_co_reset_c;
      s_mclkout_odp <= mclkout_odp_reset_c;
      s_mclkout_odn <= mclkout_odn_reset_c;
      s_msdout_ds <= msdout_ds_reset_c;
      s_msdout_sr <= msdout_sr_reset_c;
      s_msdout_co <= msdout_co_reset_c;
      s_msdout_odp <= msdout_odp_reset_c;
      s_msdout_odn <= msdout_odn_reset_c;
      s_utx_ds <= utx_ds_reset_c;
      s_utx_sr <= utx_sr_reset_c;
      s_utx_co <= utx_co_reset_c;
      s_utx_odp <= utx_odp_reset_c;
      s_utx_odn <= utx_odn_reset_c;
      s_mirqout_ds <= mirqout_ds_reset_c;
      s_mirqout_sr <= mirqout_sr_reset_c;
      s_mirqout_co <= mirqout_co_reset_c;
      s_mirqout_odp <= mirqout_odp_reset_c;
      s_mirqout_odn <= mirqout_odn_reset_c;
      s_msdin_ste <= msdin_ste_reset_c;
      s_msdin_pd <= msdin_pd_reset_c;
      s_msdin_pu <= msdin_pu_reset_c;
      s_mirq0_ste <= mirq0_ste_reset_c;
      s_mirq0_pd <= mirq0_pd_reset_c;
      s_mirq0_pu <= mirq0_pu_reset_c;
      s_mirq1_ste <= mirq1_ste_reset_c;
      s_mirq1_pd <= mirq1_pd_reset_c;
      s_mirq1_pu <= mirq1_pu_reset_c;
      s_urx_ste <= urx_ste_reset_c;
      s_urx_pd <= urx_pd_reset_c;
      s_urx_pu <= urx_pu_reset_c;
    elsif clk 'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        case s_address is
          when version_address_c => 
          when mclkout_address_c => 
            if write_cmd = '1' then
              s_mclkout_ds <= data_in(mclkout_ds_msb_c downto mclkout_ds_lsb_c);
              s_mclkout_sr <= data_in(mclkout_sr_msb_c);
              s_mclkout_co <= data_in(mclkout_co_msb_c);
              s_mclkout_odp <= data_in(mclkout_odp_msb_c);
              s_mclkout_odn <= data_in(mclkout_odn_msb_c);
            end if;
          when msdout_address_c => 
            if write_cmd = '1' then
              s_msdout_ds <= data_in(msdout_ds_msb_c downto msdout_ds_lsb_c);
              s_msdout_sr <= data_in(msdout_sr_msb_c);
              s_msdout_co <= data_in(msdout_co_msb_c);
              s_msdout_odp <= data_in(msdout_odp_msb_c);
              s_msdout_odn <= data_in(msdout_odn_msb_c);
            end if;
          when utx_address_c => 
            if write_cmd = '1' then
              s_utx_ds <= data_in(utx_ds_msb_c downto utx_ds_lsb_c);
              s_utx_sr <= data_in(utx_sr_msb_c);
              s_utx_co <= data_in(utx_co_msb_c);
              s_utx_odp <= data_in(utx_odp_msb_c);
              s_utx_odn <= data_in(utx_odn_msb_c);
            end if;
          when mirqout_address_c => 
            if write_cmd = '1' then
              s_mirqout_ds <= data_in(mirqout_ds_msb_c downto mirqout_ds_lsb_c);
              s_mirqout_sr <= data_in(mirqout_sr_msb_c);
              s_mirqout_co <= data_in(mirqout_co_msb_c);
              s_mirqout_odp <= data_in(mirqout_odp_msb_c);
              s_mirqout_odn <= data_in(mirqout_odn_msb_c);
            end if;
          when msdin_address_c => 
            if write_cmd = '1' then
              s_msdin_ste <= data_in(msdin_ste_msb_c downto msdin_ste_lsb_c);
              s_msdin_pd <= data_in(msdin_pd_msb_c);
              s_msdin_pu <= data_in(msdin_pu_msb_c);
            end if;
          when mirq0_address_c => 
            if write_cmd = '1' then
              s_mirq0_ste <= data_in(mirq0_ste_msb_c downto mirq0_ste_lsb_c);
              s_mirq0_pd <= data_in(mirq0_pd_msb_c);
              s_mirq0_pu <= data_in(mirq0_pu_msb_c);
            end if;
          when mirq1_address_c => 
            if write_cmd = '1' then
              s_mirq1_ste <= data_in(mirq1_ste_msb_c downto mirq1_ste_lsb_c);
              s_mirq1_pd <= data_in(mirq1_pd_msb_c);
              s_mirq1_pu <= data_in(mirq1_pu_msb_c);
            end if;
          when urx_address_c => 
            if write_cmd = '1' then
              s_urx_ste <= data_in(urx_ste_msb_c downto urx_ste_lsb_c);
              s_urx_pd <= data_in(urx_pd_msb_c);
              s_urx_pu <= data_in(urx_pu_msb_c);
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process register_proc;


  handle_output_signals:process(enable, s_address,
                                s_mclkout_ds, s_mclkout_sr, s_mclkout_co, s_mclkout_odp, s_mclkout_odn, s_msdout_ds,
                                s_msdout_sr, s_msdout_co, s_msdout_odp, s_msdout_odn, s_utx_ds, s_utx_sr, s_utx_co, s_utx_odp,
                                s_utx_odn, s_mirqout_ds, s_mirqout_sr, s_mirqout_co, s_mirqout_odp, s_mirqout_odn,
                                s_msdin_ste, s_msdin_pd, s_msdin_pu, s_mirq0_ste, s_mirq0_pd, s_mirq0_pu, s_mirq1_ste,
                                s_mirq1_pd, s_mirq1_pu, s_urx_ste, s_urx_pd, s_urx_pu)
  begin
    data_out <= (others => '0');

    if enable = '1' then
      case s_address is
        when version_address_c => 
          data_out(version_analog_msb_c downto version_analog_lsb_c) <= version_analog_reset_c;
          data_out(version_digital_msb_c downto version_digital_lsb_c) <= version_digital_reset_c;
        when mclkout_address_c => 
          data_out(mclkout_ds_msb_c downto mclkout_ds_lsb_c) <= s_mclkout_ds;
          data_out(mclkout_sr_msb_c) <= s_mclkout_sr;
          data_out(mclkout_co_msb_c) <= s_mclkout_co;
          data_out(mclkout_odp_msb_c) <= s_mclkout_odp;
          data_out(mclkout_odn_msb_c) <= s_mclkout_odn;
        when msdout_address_c => 
          data_out(msdout_ds_msb_c downto msdout_ds_lsb_c) <= s_msdout_ds;
          data_out(msdout_sr_msb_c) <= s_msdout_sr;
          data_out(msdout_co_msb_c) <= s_msdout_co;
          data_out(msdout_odp_msb_c) <= s_msdout_odp;
          data_out(msdout_odn_msb_c) <= s_msdout_odn;
        when utx_address_c => 
          data_out(utx_ds_msb_c downto utx_ds_lsb_c) <= s_utx_ds;
          data_out(utx_sr_msb_c) <= s_utx_sr;
          data_out(utx_co_msb_c) <= s_utx_co;
          data_out(utx_odp_msb_c) <= s_utx_odp;
          data_out(utx_odn_msb_c) <= s_utx_odn;
        when mirqout_address_c => 
          data_out(mirqout_ds_msb_c downto mirqout_ds_lsb_c) <= s_mirqout_ds;
          data_out(mirqout_sr_msb_c) <= s_mirqout_sr;
          data_out(mirqout_co_msb_c) <= s_mirqout_co;
          data_out(mirqout_odp_msb_c) <= s_mirqout_odp;
          data_out(mirqout_odn_msb_c) <= s_mirqout_odn;
        when msdin_address_c => 
          data_out(msdin_ste_msb_c downto msdin_ste_lsb_c) <= s_msdin_ste;
          data_out(msdin_pd_msb_c) <= s_msdin_pd;
          data_out(msdin_pu_msb_c) <= s_msdin_pu;
        when mirq0_address_c => 
          data_out(mirq0_ste_msb_c downto mirq0_ste_lsb_c) <= s_mirq0_ste;
          data_out(mirq0_pd_msb_c) <= s_mirq0_pd;
          data_out(mirq0_pu_msb_c) <= s_mirq0_pu;
        when mirq1_address_c => 
          data_out(mirq1_ste_msb_c downto mirq1_ste_lsb_c) <= s_mirq1_ste;
          data_out(mirq1_pd_msb_c) <= s_mirq1_pd;
          data_out(mirq1_pu_msb_c) <= s_mirq1_pu;
        when urx_address_c => 
          data_out(urx_ste_msb_c downto urx_ste_lsb_c) <= s_urx_ste;
          data_out(urx_pd_msb_c) <= s_urx_pd;
          data_out(urx_pu_msb_c) <= s_urx_pu;
        when others => null;
      end case;
    end if;
  end process handle_output_signals;


  mclkout_ds <= s_mclkout_ds;
  mclkout_sr <= s_mclkout_sr;
  mclkout_co <= s_mclkout_co;
  mclkout_odp <= s_mclkout_odp;
  mclkout_odn <= s_mclkout_odn;
  msdout_ds <= s_msdout_ds;
  msdout_sr <= s_msdout_sr;
  msdout_co <= s_msdout_co;
  msdout_odp <= s_msdout_odp;
  msdout_odn <= s_msdout_odn;
  utx_ds <= s_utx_ds;
  utx_sr <= s_utx_sr;
  utx_co <= s_utx_co;
  utx_odp <= s_utx_odp;
  utx_odn <= s_utx_odn;
  mirqout_ds <= s_mirqout_ds;
  mirqout_sr <= s_mirqout_sr;
  mirqout_co <= s_mirqout_co;
  mirqout_odp <= s_mirqout_odp;
  mirqout_odn <= s_mirqout_odn;
  msdin_ste <= s_msdin_ste;
  msdin_pd <= s_msdin_pd;
  msdin_pu <= s_msdin_pu;
  mirq0_ste <= s_mirq0_ste;
  mirq0_pd <= s_mirq0_pd;
  mirq0_pu <= s_mirq0_pu;
  mirq1_ste <= s_mirq1_ste;
  mirq1_pd <= s_mirq1_pd;
  mirq1_pu <= s_mirq1_pu;
  urx_ste <= s_urx_ste;
  urx_pd <= s_urx_pd;
  urx_pu <= s_urx_pu;

end rtl;

