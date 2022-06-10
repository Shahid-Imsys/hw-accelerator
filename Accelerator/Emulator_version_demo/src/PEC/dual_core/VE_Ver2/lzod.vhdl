library ieee;
use ieee.std_logic_1164.all;
use work.vetypes.all;

entity lzod is
  port (
  clk : in std_logic;
  enable : in std_logic;
  data : in std_logic_vector(63 downto 0);
  ctrl : in lzod_ctrl;
  lzo1 : out std_logic_vector(3 downto 0) := "0000";
  lzo2 : out std_logic_vector(3 downto 0) := "0000"
  );
end entity;

architecture basic of lzod is
  signal to_detect : std_logic_vector(15 downto 0);
  signal leading_ones : std_logic_vector(3 downto 0);
  signal leading_zeros : std_logic_vector(3 downto 0);
  signal to_store : std_logic_vector(3 downto 0);
begin
  to_detect <= data(63 downto 48) when ctrl.word = "11" else
               data(47 downto 32) when ctrl.word = "10" else
               data(31 downto 16) when ctrl.word = "01" else
               data(15 downto 0);

  leading_ones <= "0000" when to_detect(15 downto 14) = "10" else
                  "0001" when to_detect(15 downto 13) = "110" else
                  "0010" when to_detect(15 downto 12) = "1110" else
                  "0011" when to_detect(15 downto 11) = "11110" else
                  "0100" when to_detect(15 downto 10) = "111110" else
                  "0101" when to_detect(15 downto 9) = "1111110" else
                  "0110" when to_detect(15 downto 8) = "11111110" else
                  "0111" when to_detect(15 downto 7) = "111111110" else
                  "1000" when to_detect(15 downto 6) = "1111111110" else
                  "1001" when to_detect(15 downto 5) = "11111111110" else
                  "1010" when to_detect(15 downto 4) = "111111111110" else
                  "1011" when to_detect(15 downto 3) = "1111111111110" else
                  "1100" when to_detect(15 downto 2) = "11111111111110" else
                  "1101" when to_detect(15 downto 1) = "111111111111110" else
                  "1110" when to_detect(15 downto 0) = "1111111111111110" else
                  "1111";

  leading_zeros <= "0000" when to_detect(15 downto 14) = "01" else
                   "0001" when to_detect(15 downto 13) = "001" else
                   "0010" when to_detect(15 downto 12) = "0001" else
                   "0011" when to_detect(15 downto 11) = "00001" else
                   "0100" when to_detect(15 downto 10) = "000001" else
                   "0101" when to_detect(15 downto 9) = "0000001" else
                   "0110" when to_detect(15 downto 8) = "00000001" else
                   "0111" when to_detect(15 downto 7) = "000000001" else
                   "1000" when to_detect(15 downto 6) = "0000000001" else
                   "1001" when to_detect(15 downto 5) = "00000000001" else
                   "1010" when to_detect(15 downto 4) = "000000000001" else
                   "1011" when to_detect(15 downto 3) = "0000000000001" else
                   "1100" when to_detect(15 downto 2) = "00000000000001" else
                   "1101" when to_detect(15 downto 1) = "000000000000001" else
                   "1110" when to_detect(15 downto 0) = "0000000000000001" else
                   "1111";
    to_store <= leading_ones when to_detect(15) = '1' else leading_zeros;
    process(clk)
    begin
      if rising_edge(clk) then
        if enable = '1' then
          if ctrl.store = store1 then
            lzo1 <= to_store;
          elsif ctrl.store = store2 then
            lzo2 <= to_store;
          end if;
        end if;
      end if;
    end process;
  end architecture;
