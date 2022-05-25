library ieee;
use ieee.std_logic_1164.all;

use work.vetypes.all;

entity writebuff is
  port (
    clk     : in  std_logic;
    en      : in  std_logic;
    data    : in  std_logic_vector(63 downto 0);
    ctrl    : in  memreg_ctrl;
    dataout : out std_logic_vector(63 downto 0)
    );
end entity;

architecture first of writebuff is
  alias data0 : std_logic_vector(31 downto 0) is data(63 downto 32);
  alias data1 : std_logic_vector(31 downto 0) is data(31 downto 0);

begin
  process (clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if ctrl.datareg = enable then
          if ctrl.swap = noswap then
            dataout <= data0 & data1;
          else
            dataout <= data1 & data0;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;
