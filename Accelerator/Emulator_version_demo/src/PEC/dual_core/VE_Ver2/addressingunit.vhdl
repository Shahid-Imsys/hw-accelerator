

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addressing_unit is 
  generic(
    simulation : boolean := true
  );
  port(
    clk : in std_logic;
    rst : in std_logic;
    en  : in std_logic;
    start : in std_logic;
    load : in std_logic;
    cmp0        : in unsigned(7 downto 0);
    cmp1        : in unsigned(7 downto 0);
    cmp2        : in unsigned(7 downto 0);
    cmp3        : in unsigned(7 downto 0);
    add_offset0 : in unsigned(7 downto 0);
    add_offset1 : in unsigned(7 downto 0);
    add_offset2 : in unsigned(7 downto 0);
    add_offset3 : in unsigned(7 downto 0);
    baseaddress : in std_logic_vector(7 downto 0);

    done : out std_logic;
    finaladdress : out std_logic_vector(7 downto 0)

  );
end entity;

architecture addressing of addressing_unit is 
  --signal list
  --signal load        : std_logic;
  signal rst_first   : std_logic;
  signal rst_second  : std_logic;
  signal rst_fourth  : std_logic;
  signal rst_third   : std_logic;
  signal done_int    : std_logic;
  signal first       : unsigned(7 downto 0);
  signal second      : unsigned(7 downto 0);
  signal third       : unsigned(7 downto 0);
  signal fourth      : unsigned(7 downto 0);
  signal clockcycle  : integer         := 0;

  alias load_second : std_logic is rst_first;
  alias load_third  : std_logic is rst_second;
  alias load_fourth : std_logic is rst_third;

begin

  finaladdress <= std_logic_vector(unsigned(baseaddress) + first + second + third + fourth) when done = '0' and load = '1'
                                                                                            else (others => '0');

  done_int <= rst_first and rst_second and rst_third and rst_fourth when en = '1'
                                                                    else '1';


  -- Clock cycle counter for debug
  process(clk)
  begin
    if rising_edge(clk) then
      if simulation then
        if start = '1' then
          clockcycle <= 0;
        else
          clockcycle <= clockcycle + 1;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        done <= '1';
      else
        if start = '1' then
          done <= '0';
          --if en = '0' then
          --  done <= '1';
          --else
          --  done <= '0';
          --end if;
        elsif done_int = '1' then
          done <= '1';
        end if;
      end if;
    end if;
  end process;

  rst_gen : process(all)
  begin
    -- reset first counter's register and load second counter's register
    if first = cmp0 then
      rst_first <= '1';
    else 
      rst_first <= '0';
    end if;
    -- reset second counter's register and load third counter's register
    if second = cmp1 then
      rst_second <= '1';
    else
      rst_second <= '0';
    end if;
    -- reset third counter's register and load fourth counter's register
    if third = cmp2 then
      rst_third <= '1';
    else
      rst_third <= '0';
    end if;
    -- reset fourth counter's register
    if fourth = cmp3 then
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
      elsif en = '1' then
        if rst_first = '1' then
          first <= (others => '0');
        elsif load = '1' and done = '0' then
          first <= add_offset0 + first;
        end if;
      end if;
    end if;
  end process;

  second_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        second <= (others => '0');
      elsif en = '1' then
        if rst_second = '1' and rst_first = '1' then
          second <= (others => '0');
        elsif load_second = '1' then
          second <= add_offset1 + second;
        end if;
      end if;
    end if;
  end process;

  third_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        third <= (others => '0');
      elsif en = '1' then
        if rst_third = '1' and rst_second = '1' and rst_first = '1' then
          third <= (others => '0');
        elsif load_third = '1' and load_second = '1' then
          third <= add_offset2 + third;
        end if;
      end if;
    end if;
  end process;

  fourth_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        fourth <= (others => '0');
      elsif en = '1' then
        if rst_fourth = '1' and rst_third = '1' and rst_second = '1' and rst_first = '1' then
          fourth <= (others => '0');
        elsif load_fourth = '1' and load_third = '1' and load_second = '1' then
          fourth <= add_offset3 + fourth;
        end if;
      end if;
    end if;
  end process;

end architecture;