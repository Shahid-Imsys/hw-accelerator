library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vetypes.all;

entity lod is
  port (
  clk : in std_logic;
  enable : in std_logic;
  data3 : in std_logic_vector(31 downto 0);
  data2 : in std_logic_vector(31 downto 0);
  data1 : in std_logic_vector(31 downto 0);
  data0 : in std_logic_vector(31 downto 0);
  sign3 : in std_logic;
  sign2 : in std_logic;
  sign1 : in std_logic;
  sign0 : in std_logic;
  ctrl : in lzod_ctrl;
  to_shift : out ppshift_shift_ctrl;
  to_addbias : out std_logic
  );
end entity;

-- TODO: add sign

architecture basic of lod is
  signal to_detect : std_logic_vector(31 downto 0);
  signal leading_one : unsigned(4 downto 0);
  signal lzo1, lzo2, lzo3 : unsigned(4 downto 0);
  signal to_sign, s1, s2, s3 : std_logic;
  signal diff1, diff2, diff3, unnorm, unnormb, deta, detb : signed(5 downto 0);

begin
  to_detect <= data3 when ctrl.word = "11" else
               data2 when ctrl.word = "10" else
               data1 when ctrl.word = "01" else
               data0;

  to_sign <= sign3 when ctrl.word = "11" else
             sign2 when ctrl.word = "10" else
             sign1 when ctrl.word = "01" else
             sign0;

  leading_one <= "00000" when to_detect(31) = '1' else
                 "00001" when to_detect(30) = '1' else
                 "00010" when to_detect(29) = '1' else
                 "00011" when to_detect(28) = '1' else
                 "00100" when to_detect(27) = '1' else
                 "00101" when to_detect(26) = '1' else
                 "00110" when to_detect(25) = '1' else
                 "00111" when to_detect(24) = '1' else
                 "01000" when to_detect(23) = '1' else
                 "01001" when to_detect(22) = '1' else
                 "01010" when to_detect(21) = '1' else
                 "01011" when to_detect(20) = '1' else
                 "01100" when to_detect(19) = '1' else
                 "01101" when to_detect(18) = '1' else
                 "01110" when to_detect(17) = '1' else
                 "01111" when to_detect(16) = '1' else
                 "10000" when to_detect(15) = '1' else
                 "10001" when to_detect(14) = '1' else
                 "10010" when to_detect(13) = '1' else
                 "10011" when to_detect(12) = '1' else
                 "10100" when to_detect(11) = '1' else
                 "10101" when to_detect(10) = '1' else
                 "10110" when to_detect(9) = '1' else
                 "10111" when to_detect(8) = '1' else
                 "11000" when to_detect(7) = '1' else
                 "11001" when to_detect(6) = '1' else
                 "11010" when to_detect(5) = '1' else
                 "11011" when to_detect(4) = '1' else
                 "11100" when to_detect(3) = '1' else
                 "11101" when to_detect(2) = '1' else
                 "11110" when to_detect(1) = '1' else
                 "11111";

process(clk)
    begin
      if rising_edge(clk) then
        if enable = '1' then
          if ctrl.store = store1 then
            lzo1 <= leading_one;
            s1 <= to_sign;
          elsif ctrl.store = store2 then
            lzo2 <= leading_one;
            s2 <= to_sign;
          elsif ctrl.store = store3 then
            lzo3 <= leading_one;
            s3 <= to_sign;
          end if;
        end if;
      end if;
    end process;

diff1 <= signed(resize(lzo1, 6)) - signed(resize(lzo2, 6));
--diff2 <= -diff1;
unnorm <= diff1 + 22;
deta <= diff1 + 14;
diff3 <= signed(resize(lzo3, 6)) - signed(resize(lzo2, 6));
--detb <= diff3 + 14;
unnormb <= diff3 + 22;

    process(clk)
        begin
          if rising_edge(clk) then
            if enable = '1' then
              to_shift.acce <= hold;
              to_shift.use_lod <= '1';
              to_addbias <= '0';
              if ctrl.output = val then
                to_shift.shift <= to_integer(unsigned(leading_one));
                to_shift.shift_dir <= left;
              --elsif ctrl.output = diff then
              --  if diff1(5) = '0' then
              --    to_shift.shift <= to_integer(diff1);
              --    to_shift.shift_dir <= left;
              --  else
              --    to_shift.shift <= to_integer(diff2);
              --    to_shift.shift_dir <= right;
              --  end if;
              elsif ctrl.output = nrit then
                to_shift.shift <= to_integer(unnorm);
                to_shift.shift_dir <= right;
                to_addbias <= s1 xor s2;
              elsif ctrl.output = det1 then
                to_shift.shift <= to_integer(deta);
                to_shift.shift_dir <= right;
              --elsif ctrl.output = det2 then
              --  to_shift.shift <= to_integer(detb);
              --  to_shift.shift_dir <= right;
              elsif ctrl.output = nrit2 then
                to_shift.shift <= to_integer(unnormb);
                to_shift.shift_dir <= right;
              end if;
            end if;
          end if;
        end process;

  end architecture;
