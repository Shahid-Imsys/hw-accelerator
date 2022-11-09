

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

use work.vetypes.all;

entity au_tb is
  
end entity;

architecture rtl of au_tb is 

  signal clk          : std_logic;
  signal rst          : std_logic;
  signal en           : std_logic;
  signal start        : std_logic;
  signal load         : std_logic;
  signal done         : std_logic;
  signal cmp         : au_param;
  signal offset      : au_param;
  signal counters     : au_param;
  signal addon_off    : std_logic_vector(2 downto 0);
  signal baseaddress  : std_logic_vector(7 downto 0);
  signal finaladdress : std_logic_vector(7 downto 0);

  component addressing_unit
    generic (
      simulation : boolean := true
      );
    port(
      clk          : in std_logic;
      rst          : in std_logic;
      en           : in std_logic;
      start        : in std_logic;
      load         : in std_logic;
      cmp         : in au_param;
      add_offset  : in au_param;
      addon_off    : in std_logic_vector(2 downto 0);
      baseaddress  : in std_logic_vector(7 downto 0);
      counters     : out au_param;
      done         : out std_logic;
      finaladdress : out std_logic_vector(7 downto 0)
    );
  end component;

begin

  addressing : addressing_unit
  generic map(
    simulation   => true
  )
  port map(
    clk          => clk,
    rst          => rst,
    en           => en,
    start        => start,
    load        => load,
    cmp         => cmp,
    add_offset  => offset,
    addon_off    => addon_off,
    baseaddress  => baseaddress,
    counters     => counters,
    done         => done,
    finaladdress => finaladdress
  );

  clk_gen : process
  begin
  clk <= '1';
  wait for 7.5 ns;
  clk <= '0';
  wait for 7.5 ns;
  end process;

  process
  begin
    rst <= '0';
    wait for 30 ns;
    wait for 1 ns;
    rst <= '1';
    addon_off <= "000";
    offset(0) <= x"03";
    wait for 30 ns;
    offset(1) <= x"0f";
    wait for 30 ns;
    offset(2) <= x"01";
    wait for 30 ns;
    offset(3) <= x"03";
    wait for 30 ns;
    cmp(0) <= x"06";
    wait for 30 ns;
    cmp(1) <= x"1e";
    wait for 30 ns;
    cmp(2) <= x"02";
    wait for 30 ns;
    cmp(3) <= x"03";
    wait for 30 ns;
    baseaddress <= x"00";
    start <= '1';
    wait for 30 ns;
    start <= '0';
    wait for 900 ns;
    load <= '1';
    wait for 840 ns;
    load <= '0';
    --wait until done = '1';
    wait for 1000 ns;
    --baseaddress <= x"03";
    --start <= '1';
    --wait for 30 ns;
    --start <= '0';
    --wait until done = '1';
    report "simulation end";
    finish;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if start = '1' then
        en <= '1';
      elsif done = '1' then
        en <= '0';
      end if;
    end if;
  end process;


end architecture;