

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity au_tb is
  --  Port ( );
end entity;

architecture rtl of au_tb is 

  signal clk          : std_logic;
  signal rst          : std_logic;
  signal en           : std_logic;
  signal start        : std_logic;
  signal done         : std_logic;
  signal config_in    : unsigned(7 downto 0);
  signal set_up       : std_logic_vector(2 downto 0);
  signal baseaddress  : std_logic_vector(7 downto 0);
  signal finaladdress : std_logic_vector(7 downto 0);

  component addressing_unit
    port(
      clk          : in std_logic;
      rst          : in std_logic;
      en           : in std_logic;
      load         : in std_logic;
      config_in    : in unsigned(7 downto 0);
      set_up       : in std_logic_vector(2 downto 0);
      baseaddress  : in std_logic_vector(7 downto 0);
      done         : out std_logic;
      finaladdress : out std_logic_vector(7 downto 0)
    );
  end component;

begin

  addressing : addressing_unit
  port map(
    clk          => clk,
    rst          => rst,
    en           => en,
    load         => start,
    config_in    => config_in,
    set_up       => set_up,
    baseaddress  => baseaddress,
    done         => done,
    finaladdress => finaladdress
  );

  clk_gen : process
  begin
  clk <= '1';
  wait for 15 ns;
  clk <= '0';
  wait for 15 ns;
  end process;

  process
  begin
    rst <= '0';
    wait for 30 ns;
    wait for 1 ns;
    rst <= '1';
    set_up <= "000";
    config_in <= x"03";
    wait for 30 ns;
    set_up <= "001";
    config_in <= x"0f";
    wait for 30 ns;
    set_up <= "010";
    config_in <= x"01";
    wait for 30 ns;
    set_up <= "011";
    config_in <= x"00";
    wait for 30 ns;
    set_up <= "100";
    config_in <= x"06";
    wait for 30 ns;
    set_up <= "101";
    config_in <= x"1e";
    wait for 30 ns;
    set_up <= "110";
    config_in <= x"02";
    wait for 30 ns;
    set_up <= "111";
    config_in <= x"00";
    wait for 30 ns;
    baseaddress <= x"00";
    start <= '1';
    en <= '1';
    wait until done = '1';
    start <= '0';
    wait for 30 ns;
    baseaddress <= x"03";
    start <= '1';
    wait until done = '1';
    report "simulation end";
    finish;
  end process;


end architecture;