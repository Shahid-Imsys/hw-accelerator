

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity re is 
  port(
    clk              : in std_logic;
    rst              : in std_logic;
    clk_e_pos        : in std_logic;
    mode_a           : in std_logic;
    mode_b           : in std_logic;
    mode_c           : in std_logic;
    data_valid       : in std_logic;
    re_start         : in std_logic;
    re_source        : in std_logic;
    cnt_rst          : in std_logic;
    wr_counter       : in std_logic_vector(7 downto 0);
    re_busy          : out std_logic;
    write_en_data    : out std_logic;
    write_en_weight  : out std_logic;
    write_en_bias    : out std_logic;
    mode_c_l         : out std_logic;
    left_rst         : out std_logic;
    right_rst        : out std_logic;
    bias_rst         : out std_logic;
    left_load        : out std_logic;
    right_load       : out std_logic;
    bias_load        : out std_logic
  );
end entity re;

architecture receive_engine of re is
  --signals
  signal mode_a_l        : std_logic;
  signal mode_b_l        : std_logic;
  signal re_loop         : std_logic_vector(7 downto 0);
  signal ring_end_addr   : std_logic_vector(7 downto 0);
  signal ring_start_addr : std_logic_vector(7 downto 0);
  signal curr_ring_addr  : std_logic_vector(7 downto 0);
  signal next_ring_addr  : std_logic_vector(7 downto 0);
  signal offset_l        : std_logic_vector(7 downto 0); --offset register

begin

  --assign port

  latch_signals: process(clk)
  begin
    if rising_edge(clk) then --latches at the rising_edge of clk_p. 
      if rst = '0' then
        re_busy <= '0';
      else
        if re_start = '1' and re_source = '0' then --only used when the source is from DFM register
          re_busy <= '1';
        elsif re_loop = (re_loop'range => '0') then 
          re_busy <= '0';
        end if;
        --mode a and b will be reflected by config registers when ve_starts
        if re_start = '1' and mode_a = '1' then
          mode_a_l <= '1';
        elsif re_loop = (re_loop'range => '0') then
          mode_a_l <= '0';
        end if;
        if re_start= '1' and mode_b = '1' then
          mode_b_l <= '1';
        elsif re_loop = (re_loop'range => '0') then
          mode_b_l <= '0';
        end if;
        --mode c latch signal --1210
        if re_start = '1' and mode_c = '1' then
          mode_c_l <= '1';
        elsif re_loop = (re_loop'range => '0') then
          mode_c_l <= '0';
        end if;
      end if;
    end if;
  end process;

  wr_loop_counting: process(clk)
  begin
    if rising_edge(clk) then
      if RST = '0' then
        re_loop <= (others => '0');
      elsif re_start = '1' and clk_e_pos = '1' and re_source = '0' then
        re_loop <= wr_counter;
      elsif re_source = '0' and re_busy = '1' and re_loop /=(re_loop'range => '0') and data_valid = '1' then
        re_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(re_loop))-1,8));
      end if;
    end if;
  end process;

  load : process (clk) 
  begin 
    if rising_edge(clk) then
      if RST = '0' then        --Active low or high?
        left_rst <= '1';
        right_rst <= '1';
        bias_rst <= '1';
        left_load <= '0';
        right_load <= '0'; 
        bias_load  <= '0';
      elsif re_source = '0' and cnt_rst = '1' then
        if mode_a_l = '1' and mode_b_l = '0'then
          left_rst <= '1';
        elsif mode_a_l = '1' and mode_b_l = '0'then
          right_rst <= '1';
        elsif mode_a_l = '1' and mode_b_l = '1' then
          bias_rst <= '1';
        end if;
      elsif re_source = '0' and re_busy = '1' and data_valid = '1' and re_loop /= (re_loop'range => '0') then
        left_rst <= '0';
        right_rst <= '0';
        bias_rst <= '0';
        if mode_a_l = '1' and mode_b_l = '0'then      
          left_load <= '1';
        end if;
        if mode_b_l = '1' and mode_a_l = '0'then
          right_load <= '1';
        end if;
        if mode_a_l = '1' and mode_b_l = '1' then
          bias_load <= '1';
        end if;
      else
        left_load <= '0';
        right_load <= '0';
        bias_load <= '0';
      end if;
    end if;
  end process;

  --Mode a and b for reloading receive engine, mode bits are not latched.
  --re_start, re_source and modes are written in one microinstruction.
  --addr_reload, modes are written in one microinstruction.
  --pushback_addr_write : process(clk) --generate address counter a abd b
  --begin
  --  if rising_edge(clk) then
  --    if RST = '0' then
  --      re_addr_a <= (others => '0');
  --      re_addr_b <= (others => '0');
  --    elsif clk_e_pos = '1'then --falling_edge of clock_e
  --      if re_source = '1' and re_addr_reload = '1' then
  --        if mode_a = '1' then
  --          re_addr_a <= re_saddr_a;
  --        elsif mode_b = '1' then
  --          re_addr_b <= re_saddr_b;
  --        end if;
  --      elsif re_addr_reload = '0' and re_source = '1' and re_start = '1' then
  --        if mode_a = '1'  then 
  --          re_addr_a <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_a))+1,8));
  --        elsif mode_b = '1' then
  --          re_addr_b <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_b))+1,8));
  --        end if;
  --      end if;
  --    end if;
  --  end if;
  --end process;

  --====== Addresses MUX ======--
  --address_pointer_mux: process(all)
  --begin
  --  if re_busy = '0' and re_source = '1' then --Use receive engine's address counter a and b --mode c added --2.0
  --    re_addr_weight <= (others => '0');
  --    if mode_a_l = '1' then
  --      re_addr_data <= re_addr_a;
  --    elsif mode_b_l = '1' then
  --      re_addr_data <= re_addr_b;
  --    else
  --      re_addr_data <= (others => '0');
  --    end if;
  --  else
  --    re_addr_data <= (others => '0');
  --    re_addr_weight <= (others => '0');
  --  end if;
  --end process;
  
  --Write enable signal to srams
  --
  write_enable_left: process(all)
  begin
    if re_busy = '1' and ((mode_a_l = '1' and mode_b_l = '0' ) or mode_c_l = '1')then
      write_en_data <= left_load;
    elsif re_start = '1' and re_source = '1' and mode_a = '1' then
      write_en_data <= left_load;
    else
      write_en_data <= '0';
    end if;
  end process;

  write_enable_right: process(all)
  begin
    if re_busy = '1' and mode_a_l = '0' and mode_b_l = '1' then
      write_en_weight <= right_load;
    elsif re_start = '1' and re_source = '1' and mode_b ='1' then
      write_en_weight <= right_load;
    else
      write_en_weight <= '0';
    end if;
  end process;

  write_enable_bias: process(all)
  begin 
    if re_busy = '1' and mode_a_l = '1' and mode_b_l = '1' then
      write_en_bias <= bias_load;
    else
      write_en_bias <= '0';
    end if;
  end process;
                  

end architecture;