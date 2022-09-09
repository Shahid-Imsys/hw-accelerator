

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
  signal load         : std_logic;
  signal done         : std_logic;
  signal cmp0         : unsigned(7 downto 0);
  signal cmp1         : unsigned(7 downto 0);
  signal cmp2         : unsigned(7 downto 0);
  signal cmp3         : unsigned(7 downto 0);
  signal offset0      : unsigned(7 downto 0);
  signal offset1      : unsigned(7 downto 0);
  signal offset2      : unsigned(7 downto 0);
  signal offset3      : unsigned(7 downto 0);
  --signal config_in    : unsigned(7 downto 0);
  --signal set_up       : std_logic_vector(2 downto 0);
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
      cmp0         : in unsigned(7 downto 0);
      cmp1         : in unsigned(7 downto 0);
      cmp2         : in unsigned(7 downto 0);
      cmp3         : in unsigned(7 downto 0);
      add_offset0  : in unsigned(7 downto 0);
      add_offset1  : in unsigned(7 downto 0);
      add_offset2  : in unsigned(7 downto 0);
      add_offset3  : in unsigned(7 downto 0);
      --config_in    : in unsigned(7 downto 0);
      --set_up       : in std_logic_vector(2 downto 0);
      baseaddress  : in std_logic_vector(7 downto 0);
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
    cmp0         => cmp0,
    cmp1         => cmp1,
    cmp2         => cmp2,
    cmp3         => cmp3,
    add_offset0  => offset0,
    add_offset1  => offset1,
    add_offset2  => offset2,
    add_offset3  => offset3,
    --config_in    => config_in,
    --set_up       => set_up,
    baseaddress  => baseaddress,
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
    offset0 <= x"03";
    wait for 30 ns;
    offset1 <= x"0f";
    wait for 30 ns;
    offset2 <= x"01";
    wait for 30 ns;
    offset3 <= x"03";
    wait for 30 ns;
    cmp0 <= x"06";
    wait for 30 ns;
    cmp1 <= x"1e";
    wait for 30 ns;
    cmp2 <= x"02";
    wait for 30 ns;
    cmp3 <= x"03";
    wait for 30 ns;
    baseaddress <= x"00";
    start <= '1';
    wait for 30 ns;
    start <= '0';
    wait for 900 ns;
    load <= '1';
    wait for 810 ns;
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