
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

use work.noc_types_pkg.all;
use work.ACC_types.all;

entity simple_noc_bus_tb is

end entity simple_noc_bus_tb;

architecture tb of simple_noc_bus_tb is

  component noc_bus
    port (
      clk    : in std_logic;
      rst    : in std_logic;
      enable : in std_logic;

      data_from_noc_switch : in std_logic_vector((8*(levels_c+1))-1 downto 0);
      tag_from_master      : in noc_tag_t((2**levels_c)-1 downto 0);


      data_to_noc_switch : out std_logic_vector((8*(levels_c+1))-1 downto 0);
      tag_to_master      : out std_logic_vector(1 downto 0);


      data_from_cc : in  noc_data_t((2**levels_c)-1 downto 0);
      tag_from_cc  : in  noc_tag_t((2**levels_c)-1 downto 0);
      data_to_cc   : out noc_data_t((2**levels_c)-1 downto 0);
      tag_to_cc    : out noc_tag_t((2**levels_c)-1 downto 0)
      );
  end component;

  signal clk    : std_logic := '0';
  signal rst    : std_logic := '1';
  signal enable : std_logic := '1';

  signal data_from_noc_switch : std_logic_vector((8*(levels_c+1))-1 downto 0) := (others => '0');
  signal tag_from_master      : noc_tag_t((2**levels_c)-1 downto 0);


  signal data_to_noc_switch : std_logic_vector((8*(levels_c+1))-1 downto 0) := (others => '0');
  signal tag_to_master      : std_logic_vector(1 downto 0)                  := (others => '0');


  signal data_from_cc : noc_data_t((2**levels_c)-1 downto 0) := (others => (others => '0'));
  signal tag_from_cc  : noc_tag_t((2**levels_c)-1 downto 0) := (others => (others => '0'));
  signal data_to_cc   : noc_data_t((2**levels_c)-1 downto 0) := (others => (others => '0'));
  signal tag_to_cc    : noc_tag_t((2**levels_c)-1 downto 0) := (others => (others => '0'));

begin  -- architecture tb

  i_noc_bus : noc_bus
    port map (
      clk    => clk,
      rst    => rst,
      enable => enable,

      data_from_noc_switch => data_from_noc_switch,
      tag_from_master      => tag_from_master,


      data_to_noc_switch => data_to_noc_switch,
      tag_to_master      => tag_to_master,


      data_from_cc => data_from_cc,
      tag_from_cc  => tag_from_cc,
      data_to_cc   => data_to_cc,
      tag_to_cc    => tag_to_cc
      );

  clk <= not clk after 400 ps;
  rst <= '0'     after 4 ns;

  data_generater : process is
    variable noc_switch_data          : unsigned(64 downto 0)                 := (others => '0');
    variable cc_data                  : unsigned(15 downto 0)                 := (others => '0');
    type noc_data_array_t is array (natural range <>) of noc_data_t((2**levels_c)-1 downto 0);
    type noc_tag_array_t is array (natural range <>) of noc_tag_t((2**levels_c)-1 downto 0);
    type noc_cc_tag_array_t is array (natural range <>) of std_logic_vector(1 downto 0);
    variable saved_data_to_cc         : noc_data_array_t(levels_c+1 downto 0) := (others => (others => (others => '0')));
    variable saved_data_to_noc_switch : noc_data_array_t(levels_c+1 downto 0) := (others => (others => (others => '0')));
    variable saved_master_tag         : noc_tag_array_t(levels_c+1 downto 0)  := (others => (others => (others => '0')));
    variable saved_cc_tag : noc_cc_tag_array_t(levels_c+1 downto 0) := (others => (others => '0'));
    variable start_check_data         : boolean                               := false;

    variable l : line;
  begin  -- process data_generater

    if rst = '0' then
      -------------------------------------------------------------------------
      -- Create basis for stimuli
      -------------------------------------------------------------------------
      noc_switch_data      := noc_switch_data + 7;
      cc_data              := cc_data + 19;

      -------------------------------------------------------------------------
      -- Write progress
      -------------------------------------------------------------------------
      if (noc_switch_data/7) mod 1000 = 1 then
        write(l, to_integer(noc_switch_data/7));
        write(l, string'(" bytes sent trough"));
        writeline(output, l);
      end if;

      -------------------------------------------------------------------------
      -- Create stimuli for the DUT
      -------------------------------------------------------------------------
      data_from_noc_switch <= std_logic_vector(noc_switch_data(data_from_noc_switch'left downto 0));
      data_from_cc(0)      <= std_logic_vector(cc_data(7 downto 0));
      data_from_cc(1)      <= std_logic_vector(cc_data(15 downto 8));

      tag_from_master(0) <= std_logic_vector(noc_switch_data(5 downto 4));
      tag_from_master(1) <= std_logic_vector(cc_data(5 downto 4));

      tag_from_cc(0) <= std_logic_vector(noc_switch_data(10 downto 9));
      tag_from_cc(1) <= std_logic_vector(cc_data(10 downto 9));

      -------------------------------------------------------------------------
      -- Verify the output from DUT
      -------------------------------------------------------------------------
      if start_check_data then
        assert data_to_cc = saved_data_to_cc(saved_data_to_cc'left)
          report "Wrong data from noc_bus to CC"
          severity error;

        assert data_to_noc_switch = saved_data_to_noc_switch(saved_data_to_noc_switch'left)(1) &
                                    saved_data_to_noc_switch(saved_data_to_noc_switch'left)(0)
          report "Wrong data from noc_bus to master"
          severity error;

        assert tag_to_master = saved_cc_tag(saved_cc_tag'left)
          report "Wrong tag from CC"
          severity error;
      end if;

      -------------------------------------------------------------------------
      -- Save the stimuli in a data structure so the out put from the DUT can
      -- be verified.
      -- a behave model of the DUT
      -------------------------------------------------------------------------
      saved_data_to_cc(saved_data_to_cc'left downto 1) := saved_data_to_cc(saved_data_to_cc'left-1 downto 0);
      saved_data_to_cc(0)(0)                           := std_logic_vector(noc_switch_data(7 downto 0));
      saved_data_to_cc(0)(1)                           := std_logic_vector(noc_switch_data(15 downto 8));

      saved_data_to_noc_switch(saved_data_to_noc_switch'left downto 1) := saved_data_to_noc_switch(saved_data_to_noc_switch'left-1 downto 0);
      saved_data_to_noc_switch(0)(0)                                   := std_logic_vector(cc_data(7 downto 0));
      saved_data_to_noc_switch(0)(1)                                   := std_logic_vector(cc_data(15 downto 8));

      saved_master_tag(saved_master_tag'left downto 1) := saved_master_tag(saved_master_tag'left-1 downto 0);
      saved_master_tag(0)(0)                           := std_logic_vector(noc_switch_data(5 downto 4));
      saved_master_tag(0)(1)                           := std_logic_vector(cc_data(5 downto 4));

      saved_cc_tag(saved_cc_tag'left downto 1) := saved_cc_tag(saved_cc_tag'left-1 downto 0);
      saved_cc_tag(0)(0) := noc_switch_data(9) or  cc_data(9);
      saved_cc_tag(0)(1) := noc_switch_data(10)  or cc_data(10);


      start_check_data := true;
    end if;

    wait on clk until clk = '1';

  end process data_generater;


end architecture tb;

