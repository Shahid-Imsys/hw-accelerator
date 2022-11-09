

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity addressing_unit is 
  generic(
    simulation : boolean := true
  );
  port(
    clk           : in std_logic;
    rst           : in std_logic;
    en            : in std_logic;
    ext_tigger_en : in std_logic;
    load          : in std_logic_vector(3 downto 0);
    cmp           : in au_param;
    add_offset    : in au_param;
    baseaddress   : in std_logic_vector(7 downto 0);
    finaladdress  : out std_logic_vector(7 downto 0)
  );
end entity;

architecture addressing of addressing_unit is 
  --signal list
  signal counters     : au_param;
  signal rst_first    : std_logic;
  signal rst_second   : std_logic;
  signal rst_fourth   : std_logic;
  signal rst_third    : std_logic;
  signal load_second  : std_logic; 
  signal load_third   : std_logic; 
  signal load_fourth  : std_logic;
  signal clear_second : std_logic;
  signal clear_third  : std_logic;
  signal clear_fourth : std_logic;
  ------ attributes for synthesis -------
  attribute ram_style : string;
  attribute ram_style of counters : signal is "registers";
  --signal done_int    : std_logic;
  --signal clockcycle  : integer         := 0;


  alias first  : unsigned is counters(0);
  alias second : unsigned is counters(1);
  alias third  : unsigned is counters(2);
  alias fourth : unsigned is counters(3);

begin

  load_second <= load(1) when ext_tigger_en = '1' else rst_first;
  clear_second <= (rst_second and load(1)) when ext_tigger_en = '1' else (rst_second and rst_first);
  load_third  <= load(2) when ext_tigger_en = '1' else rst_second;
  clear_third <= (rst_third and load(2) and load(1)) when ext_tigger_en = '1' else (rst_third and rst_second and rst_first);
  load_fourth <= load(3) when ext_tigger_en = '1' else rst_third;
  clear_fourth <= (rst_fourth and load(3) and load(2) and load(1)) when ext_tigger_en = '1' else (rst_fourth and rst_third and rst_second and rst_first);

  finaladdress <= std_logic_vector(unsigned(baseaddress) + first + second + third + fourth); --when load = '1'
                                                                                            --else (others => '0');

  --done <= rst_first and rst_second and rst_third and rst_fourth;

  rst_gen : process(all)
  begin
    -- reset first counter's register and load second counter's register
    if first = cmp(0) then
      rst_first <= '1';
    else 
      rst_first <= '0';
    end if;
    -- reset second counter's register and load third counter's register
    if second = cmp(1) then
      rst_second <= '1';
    else
      rst_second <= '0';
    end if;
    -- reset third counter's register and load fourth counter's register
    if third = cmp(2) then
      rst_third <= '1';
    else
      rst_third <= '0';
    end if;
    -- reset fourth counter's register
    if fourth = cmp(3) then
      rst_fourth <= '1';
    else 
      rst_fourth <= '0';
    end if;
  end process;

  first_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        first <= (others => '0');
      else
        if en = '1' then
          if rst_first = '1' then
            first <= (others => '0');
          elsif load(0) = '1' then
            first <= add_offset(0) + first;
          end if;
        end if;
      end if;
    end if;
  end process;

  second_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        second <= (others => '0');
      else
        if en = '1' then
          if clear_second = '1' then
            second <= (others => '0');
          elsif load_second = '1' then
            second <= add_offset(1) + second;
          end if;
        end if;
      end if;
    end if;
  end process;

  third_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        third <= (others => '0');
      else
        if en = '1' then
          if clear_third = '1' then
            third <= (others => '0');
          elsif load_third = '1' and load_second = '1' then
            third <= add_offset(2) + third;
          end if;
        end if;
      end if;
    end if;
  end process;

  fourth_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        fourth <= (others => '0');
      else
        if en = '1' then
          if clear_fourth = '1' then
            fourth <= (others => '0');
          elsif load_fourth = '1' and load_third = '1' and load_second = '1' then
            fourth <= add_offset(3) + fourth;
          end if;
        end if;
      end if;
    end if;
  end process;

end architecture;