library ieee;
use ieee.std_logic_1164.all;

use work.noc_types_pkg.all;
use work.ACC_types.all;

entity noc_bus is
  port (
    clk   : in std_logic;
    rst  : in std_logic;

    enable : in std_logic;

    data_from_noc_switch : in std_logic_vector((8*(levels_c+1))-1 downto 0);
    tag_from_master  : in std_logic_vector((2**levels_c)-1 downto 0);


    data_to_noc_switch : out  std_logic_vector((8*(levels_c+1))-1 downto 0);
    tag_to_master  : out std_logic;


    data_from_cc : in  noc_data_t((2**levels_c)-1 downto 0);
    tag_from_cc  : in  std_logic_vector((2**levels_c)-1 downto 0);
    data_to_cc   : out noc_data_t((2**levels_c)-1 downto 0);
    tag_to_cc    : out std_logic_vector((2**levels_c)-1 downto 0)
    );
end entity noc_bus;

architecture rtl of noc_bus is

  type noc_data_array_t is array (levels_c downto 0) of noc_data_t((2**levels_c)-1 downto 0);
  type tag_array_t is array (levels_c downto 0) of std_logic_vector((2**levels_c)-1 downto 0);
  signal master_noc_data_array : noc_data_array_t;
  signal cc_noc_data_array     : noc_data_array_t;

  signal data_from_master : noc_data_t((2**levels_c)-1 downto 0);
  signal data_to_master : noc_data_t((2**levels_c)-1 downto 0);
  
  signal master_tag_array : tag_array_t;
  signal tag_temp : std_ulogic;

begin  -- architecture rtl

  split_in_data: for i in levels_c downto 0 generate
    data_from_master(i) <= data_from_noc_switch(i*8 + 7 downto i*8);
    data_to_noc_switch(i*8 + 7 downto i*8) <= data_to_master(i);
  end generate split_in_data;
  
  -----------------------------------------------------------------------------
  -- The data is straigth forward, only insert delays to compensate for length.
  -----------------------------------------------------------------------------
  data_to_cc_proc : process (clk, rst) is
  begin  -- process data_to_cc
    if rst = '1' then                 -- asynchronous reset (active low)
      master_noc_data_array <= (others => (others => (others => '0')));
      cc_noc_data_array     <= (others => (others => (others => '0')));
      master_tag_array      <= (others => (others => '0'));
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        master_noc_data_array <= master_noc_data_array((levels_c)-1 downto 0) & data_from_master;
        cc_noc_data_array     <= cc_noc_data_array((levels_c)-1 downto 0) & data_from_cc;
        master_tag_array      <= master_tag_array((levels_c)-1 downto 0) & tag_from_master;
      end if;
    end if;
  end process data_to_cc_proc;

  data_to_cc      <= master_noc_data_array(master_noc_data_array'left);
  data_to_master  <= cc_noc_data_array(cc_noc_data_array'left);
  tag_to_cc <= master_tag_array(master_tag_array'left);

  -----------------------------------------------------------------------------
  -- Tag line to master shall be a tree structure, a bit more complicated.
  -----------------------------------------------------------------------------

  tag_to_cc_proc : process (clk, rst) is
  begin  -- process tag_to_cc_lev_1
    if rst = '1' then                 -- asynchronous reset (active low)
      tag_to_master   <= '0';
      tag_temp        <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        tag_temp <= tag_from_cc(1) or tag_from_cc(0);
        tag_to_master <= tag_temp;

      end if;
    end if;
  end process tag_to_cc_proc;



end architecture rtl;
