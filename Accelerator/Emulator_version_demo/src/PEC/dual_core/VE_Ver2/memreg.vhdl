library ieee;
use ieee.std_logic_1164.all;

use work.vetypes.all;

entity memreg is
  port (
    clk       : in  std_logic;
    en        : in  std_logic;
    data0     : in  std_logic_vector(31 downto 0);
    data1     : in  std_logic_vector(31 downto 0);
    weight    : in  std_logic_vector(63 downto 0);
    ctrl      : in  memreg_ctrl;
    dataout   : out std_logic_vector(63 downto 0);
    weightout : out std_logic_vector(63 downto 0)
    );
end entity;

architecture first of memreg is
  alias d3 is dataout(63 downto 48);
  alias d2 is dataout(47 downto 32);
  alias d1 is dataout(31 downto 16);
  alias d0 is dataout(15 downto 0);
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if ctrl.datareg = enable then
          if ctrl.swap = noswap then
            dataout <= data0 & data1;
          elsif ctrl.swap = switch then
            dataout <= weight;
          else
            dataout <= data1 & data0;
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if ctrl.weightreg = enable then
          if ctrl.swap = switch then
            weightout <= data0 & data1;
          else
            weightout <= weight;
          end if;
        end if;
      end if;
    end if;
  end process;

end architecture;
