
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.noc_types_pkg.all;
use work.noc_types_tb.all;

entity noc_bus_10_tb is

end entity noc_bus_10_tb;

architecture tb of noc_bus_10_tb is
  component noc_bus_10 is
    port (
      clk : in std_logic;
      rst : in std_logic;

      enable : in std_logic;

      data_from_noc_switch : in std_logic_vector((8*(2**(levels_10_c)))-1 downto 0);
      tag_from_master      : in noc_tag_t((2**levels_10_c)-1 downto 0);


      data_to_noc_switch : out std_logic_vector((8*(2**levels_10_c))-1 downto 0);
      tag_to_master      : out std_logic_vector(1 downto 0);


      data_from_cc : in  noc_data_t((2**levels_10_c)-1 downto 0);
      tag_from_cc  : in  noc_tag_t((2**levels_10_c)-1 downto 0);
      data_to_cc   : out noc_data_t((2**levels_10_c)-1 downto 0);
      tag_to_cc    : out noc_tag_t((2**levels_10_c)-1 downto 0)
      );
  end component;

  signal clk    : std_logic := '0';
  signal rst    : std_logic := '1';
  signal enable : std_logic := '0';

  signal data_from_noc_switch : std_logic_vector((8*(2**(levels_10_c)))-1 downto 0) := (others => '0');
  signal tag_from_master      : noc_tag_t((2**levels_10_c)-1 downto 0) := (others => (others =>'0'));


  signal data_to_noc_switch : std_logic_vector((8*(2**levels_10_c))-1 downto 0) := (others => '0');
  signal tag_to_master      : std_logic_vector(1 downto 0) := (others => '0');


  signal data_from_cc : noc_data_t((2**levels_10_c)-1 downto 0) := (others => (others =>'0'));
  signal tag_from_cc  : noc_tag_t((2**levels_10_c)-1 downto 0) := (others => (others =>'0'));
  signal data_to_cc   : noc_data_t((2**levels_10_c)-1 downto 0) := (others => (others =>'0'));
  signal tag_to_cc    : noc_tag_t((2**levels_10_c)-1 downto 0) := (others => (others =>'0'));

  signal counter : integer := 9;

begin  -- architecture tb

  dut : noc_bus_10
    port map (
      clk => clk,
      rst => rst,

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

  clk   <= not clk after 833 ps;
  rst   <= '0'     after 10 ns;

  main_tb : process is
  begin  -- process main_tb
    

    wait on rst until rst = '0';
    wait on clk until clk = '1';
    enable <= '1';

    wait on clk until clk = '1';
    data_from_noc_switch <= x"01_02_03_04_05_06_07_08";
    data_from_cc <= (x"08", x"07", x"06", x"05", x"04", x"03", x"02", x"01");
    tag_from_master <= ("01", "10", "11", "00", "01", "10", "11", "00");
    tag_from_cc <= ("00", "11", "10", "01", "00", "11", "10", "01");
    wait on clk until clk = '1';

    for i in 0 to 10 loop
      data_from_noc_switch <= data_from_noc_switch(55 downto 0) & std_logic_vector(to_unsigned(counter, 8));
      data_from_cc <= std_logic_vector(to_unsigned(counter, 8)) & data_from_cc(7 downto 1);
      tag_from_master <= std_logic_vector(to_unsigned(counter, 8)(1 downto 0)) & tag_from_master(7 downto 1);
      tag_from_cc <= tag_from_cc(6 downto 0) & std_logic_vector(to_unsigned(counter, 2));
      counter <= counter +1;
      wait on clk until clk = '1';
      
    end loop;  -- i

    
    assert false report "SImulation finished" severity failure;
  end process main_tb;

end architecture tb;
