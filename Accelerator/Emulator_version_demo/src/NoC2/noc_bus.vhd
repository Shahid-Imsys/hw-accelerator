library ieee;
use ieee.std_logic_1164.all;

use work.noc_types_pkg.all;
use work.Acc_types_pkg.all;

entity noc_bus is
    Generic(
      PEC_NUMBER             : integer := 2;
      REGEN_POINTS           : integer := 2
    );    
  port (
    clk                     : in  std_logic;
    rst                     : in  std_logic;
    enable                  : in  std_logic;

    data_from_noc_switch    : in  std_logic_vector(127 downto 0);
    data_to_cc              : out noc_data_t(15 downto 0);

    data_from_cc            : in  noc_data_t(PEC_NUMBER -1 downto 0);
    data_to_noc_switch      : out noc_data_t(PEC_NUMBER -1 downto 0);

    tag_from_master         : in  std_logic;
    tag_to_cc               : out std_logic;

    tag_to_master           : out noc_tag_t(PEC_NUMBER -1 downto 0);
    tag_from_cc             : in  noc_tag_t(PEC_NUMBER -1 downto 0)
    );
end entity noc_bus;

architecture rtl of noc_bus is

  type noc_data_array_t is array (1 downto 0) of noc_data_t(PEC_NUMBER -1 downto 0);
  type noc_data_array_16_t is array (1 downto 0) of noc_data_t(15 downto 0);
  type tag_array_t is array (1 downto 0) of std_logic;
  type tag_up_array_t is array (1 downto 0) of noc_tag_t(PEC_NUMBER -1 downto 0);
  
  signal master_noc_data_array : noc_data_array_16_t;
  signal cc_noc_data_array     : noc_data_array_t;
  signal data_from_master      : noc_data_t(15 downto 0);
  signal data_to_master        : noc_data_t(PEC_NUMBER -1 downto 0);
  signal master_tag_array      : tag_array_t;
  signal tag_temp              : std_logic_vector(1 downto 0);

  signal cc_tag_array          : tag_up_array_t;

begin  -- architecture rtl

  split_in_data: for i in 15 downto 0 generate
    data_from_master(i) <= data_from_noc_switch(i*8 + 7 downto i*8);
  end generate split_in_data;

  split_in_data1: for i in PEC_NUMBER -1 downto 0 generate
    data_to_noc_switch <= data_to_master;
  end generate split_in_data1; 
  -----------------------------------------------------------------------------
  -- The data and tag line is straigth forward, only insert delays to compensate for length.
  -----------------------------------------------------------------------------
  data_to_cc_proc : process (clk, rst) is
  begin  -- process data_to_cc
    if rst = '0' then                 -- asynchronous reset (active low)
      master_noc_data_array <= (others => (others => (others => '0')));
      cc_noc_data_array     <= (others => (others => (others => '0')));
      master_tag_array      <= (others => '0');
      cc_tag_array          <= (others => (others => (others => '0')));
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        master_noc_data_array <= master_noc_data_array(0 downto 0) & data_from_master;
        cc_noc_data_array     <= cc_noc_data_array(0 downto 0) & data_from_cc;
        master_tag_array      <= master_tag_array(0 downto 0) & tag_from_master;
        cc_tag_array          <= cc_tag_array(0 downto 0) & tag_from_cc;
      end if;
    end if;
  end process data_to_cc_proc;

  BUS_REGEN_POINTS : if REGEN_POINTS = 2 generate
      data_to_cc      <= master_noc_data_array(master_noc_data_array'left);
      data_to_master  <= cc_noc_data_array(cc_noc_data_array'left);
      tag_to_cc <= master_tag_array(master_tag_array'left);
      tag_to_master <= cc_tag_array(cc_tag_array'left);
  elsif REGEN_POINTS = 0 generate  
      data_to_cc      <= data_from_master;
      data_to_master  <= data_from_cc;
      tag_to_cc <= tag_from_master;
      tag_to_master <= tag_from_cc;
  end generate;    

end architecture rtl;
