
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity ldlinvcontroller is
  port (
    clk : in std_logic;
    start : in std_logic;
    en_i : in std_logic;
    nt : in std_logic_vector(4 downto 0) := "00011";
    done : out std_logic;

    data0_addr_o : out std_logic_vector(7 downto 0);
    data1_addr_o : out std_logic_vector(7 downto 0);
    weight_addr_o : out std_logic_vector(7 downto 0);
    data_read_enable_o : out std_logic;
    data_write_enable_o : out std_logic;
    weight_read_enable_o : out std_logic;
    weight_write_enable_o : out std_logic;

    memreg_c_o : out memreg_ctrl;
    writebuff_c_o : out memreg_ctrl;
    inst_o : out instruction;
    ppinst_o : out ppctrl_t;
    ppshiftinst_o : out ppshift_shift_ctrl;
    addbiasinst_o : out ppshift_addbias_ctrl;
    clipinst_o : out ppshift_clip_ctrl;
    zpdata_o : out std_logic_vector(7 downto 0);
    zpweight_o : out std_logic_vector(7 downto 0);
    bias_o : out std_logic_vector(63 downto 0);

    en_max_o : out unsigned(3 downto 0)
  );
end entity;

architecture rtl of ldlinvcontroller is

  signal r : unsigned(4 downto 0) := (others => '0');
  signal c : unsigned(4 downto 0) := (others => '0');
  signal i : unsigned(1 downto 0) := (others => '0');
  signal j : unsigned(4 downto 0) := (others => '0');
  signal r_ce : std_logic;
  signal c_ce : std_logic;
  signal i_ce : std_logic;
  signal j_ce : std_logic;
  signal r_reset : std_logic;
  signal c_reset : std_logic;
  signal i_reset : std_logic;
  signal j_reset : std_logic;
  signal r_max : unsigned(4 downto 0) := (others => '0');
  signal c_max : unsigned(4 downto 0) := (others => '0');
  signal i_max : unsigned(1 downto 0) := (others => '0');
  signal j_max : unsigned(4 downto 0) := (others => '0');
  signal r_is_max : std_logic;
  signal c_is_max : std_logic;
  signal i_is_max : std_logic;
  signal j_is_max : std_logic;

  signal dest_index : unsigned(7 downto 0) := (others => '0');
  signal dest_index_tmp : unsigned(9 downto 0) := (others => '0');
  signal dest_index_tmp2 : unsigned(9 downto 0) := (others => '0');
  signal l_index : unsigned(7 downto 0) := (others => '0');
  signal l_inv_index : unsigned(7 downto 0) := (others => '0');
  signal l_inv_index_tmp : unsigned(9 downto 0) := (others => '0');
  signal l_inv_index_tmp2 : unsigned(9 downto 0) := (others => '0');
  signal sum_index : unsigned(7 downto 0) := (others => '0');
  signal sum_index_tmp : unsigned(9 downto 0) := (others => '0');
  signal csq : unsigned(9 downto 0) := (others => '0');

  type state_type is (idle, working, matmulhalf, rzero, writing);
  signal state : state_type := idle;
  signal next_state : state_type;
  signal prev_state : state_type;

  signal en_max : unsigned(3 downto 0);
  signal stall1 : std_logic;
  signal stall2 : std_logic;

  type addr_type is (d, l, li, s);
  signal data_read_addr : unsigned(7 downto 0) := (others => '0');
  signal data_write_addr : unsigned(7 downto 0) := (others => '0');
  signal weight_read_addr : unsigned(7 downto 0) := (others => '0');
  signal weight_write_addr : unsigned(7 downto 0) := (others => '0');
  signal data_read_addr_sel : addr_type;
  signal weight_read_addr_sel : addr_type;
  signal data_read_enable : std_logic;
  signal data_write_enable : std_logic;
  signal weight_read_enable : std_logic;
  signal weight_write_enable : std_logic;

  signal memreg_c : memreg_ctrl;
  signal writebuff_c : memreg_ctrl;
  signal inst : instruction;
  signal ppinst : ppctrl_t;
  signal ppshiftinst : ppshift_shift_ctrl;
  signal addbiasinst : ppshift_addbias_ctrl;
  signal clipinst : ppshift_clip_ctrl;
  signal zpdata : std_logic_vector(7 downto 0);
  signal zpweight : std_logic_vector(7 downto 0);
  signal bias : std_logic_vector(63 downto 0);

begin
  --counters-----------------------------------------------------------------
  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if r_reset = '1' then
          r <= (others => '0');
        elsif r_ce = '1' then
          r <= r + 1;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if c_reset = '1' then
          c <= (others => '0');
        elsif c_ce = '1' then
          c <= c + 1;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if i_reset = '1' then
          i <= (others => '0');
        elsif i_ce = '1' then
          i <= i + 1;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if j_reset = '1' then
          j <= (others => '0');
        elsif j_ce = '1' then
          j <= j + 1;
        end if;
      end if;
    end if;
  end process;
  ---------------------------------------------------------------------------
  --states-------------------------------------------------------------------
  --process (all) --TODO
  process (state, i_is_max, j_is_max, i, c_is_max, prev_state, r_is_max, start)
  begin
    case state is
      when rzero =>
        if i_is_max = '1' then
          next_state <= writing;
        else
          next_state <= state;
        end if;
      when working =>
        if j_is_max = '1' then
          if i >= 2 then
            next_state <= matmulhalf;
          elsif i = 1 then
            next_state <= writing;
          end if;
        else
          next_state <= state;
        end if;
      when matmulhalf =>
        if i_is_max = '1' and j_is_max = '1' then
          next_state <= writing;
        else
          next_state <= working;
        end if;
      when writing =>
        case prev_state is
          when rzero =>
            if c_is_max = '1' then
              next_state <= working;
            else
              next_state <= rzero;
            end if;
          when working =>
            next_state <= working;
          when others =>
            if r_is_max = '1' and c_is_max = '1' and i_is_max = '1' and j_is_max = '1' then
              done <= '1';
              next_state <= idle;
            else
              next_state <= working;
            end if;
        end case;
      when others =>
        done <= '0';
        if start = '1' then
          next_state <= rzero;
        else
          next_state <= state;
        end if;
    end case;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        state <= next_state;
        prev_state <= state;
      end if;
    end if;
  end process;
  ---------------------------------------------------------------------------
  --counter control----------------------------------------------------------
  --process (all)
  process (start, state, next_state, i_is_max, j_is_max, c_is_max, r_is_max)
  begin
    r_ce <= '0';
    r_reset <= '0';

    case state is
      when working =>
        if next_state /= matmulhalf and j_is_max = '1' and i_is_max = '1' and c_is_max = '1' then
          if r_is_max = '1' then
            r_reset <= '1';
          else
            r_ce <= '1';
          end if;
        end if;
      when writing =>
        if i_is_max = '1' and c_is_max = '1' then
          if r_is_max = '1' then
              r_reset <= '1';
          else
            r_ce <= '1';
          end if;
        end if;
      when others =>
        if start = '1' then
          r_reset <= '1';
        end if;
    end case;
  end process;

  --process (all)
  process (start, state, next_state, i_is_max, j_is_max, c_is_max)
  begin
    c_ce <= '0';
    c_reset <= '0';

    case state is
      when working =>
        if next_state /= matmulhalf and j_is_max = '1' and i_is_max = '1' then
          if c_is_max = '1' then
            c_reset <= '1';
          else
            c_ce <= '1';
          end if;
        end if;
      when writing =>
        if i_is_max = '1' then
          if c_is_max = '1' then
              c_reset <= '1';
          else
            c_ce <= '1';
          end if;
        end if;
      when others =>
        if start = '1' then
          c_reset <= '1';
        end if;
    end case;
  end process;

  --process (all)
  process (start, state, next_state, i_is_max, j_is_max)
  begin
    i_ce <= '0';
    i_reset <= '0';

    case state is
      when rzero =>
        if i_is_max = '0' then
          i_ce <= '1';
        end if;
      when working =>
        if next_state /= matmulhalf and j_is_max = '1' then
          if i_is_max = '1' then
            i_reset <= '1';
          else
            i_ce <= '1';
          end if;
        end if;
      when matmulhalf =>
        if i_is_max = '0' then
          i_ce <= '1';
        end if;
      when writing =>
        if i_is_max = '1' then
          i_reset <= '1';
        end if;
      when others =>
        if start = '1' then
          i_reset <= '1';
        end if;
    end case;
  end process;

  --process (all)
  process (start, state, next_state, j_is_max)
  begin
    j_ce <= '0';
    j_reset <= '0';

    case state is
      when rzero =>
        j_reset <= '1';
      when working =>
        if next_state /= matmulhalf then
          if j_is_max = '1' then
            j_reset <= '1';
          else
            j_ce <= '1';
          end if;
        end if;
      when matmulhalf =>
        if next_state = working then
          j_reset <= '1';
        end if;
      when writing =>
        if j_is_max = '1' then
          j_reset <= '1';
        end if;
      when others =>
        if start = '1' then
          j_reset <= '1';
        end if;
    end case;
  end process;

  r_max <= unsigned(nt) - 1;
  c_max <= r_max - r;
  i_max <= "11";
  j_max <= (others => '0') when r = 0 else r - 1;

  r_is_max <= '1' when (r = r_max) else '0';
  c_is_max <= '1' when (c = c_max) else '0';
  i_is_max <= '1' when (i = i_max) else '0';
  j_is_max <= '1' when (j = j_max) else '0';

  ---------------------------------------------------------------------------
  --address control----------------------------------------------------------

  csq <= c*c + c;

  dest_index_tmp <= r*r + r + csq;
  dest_index_tmp2 <= dest_index_tmp(9 downto 1) + r*c + c;
  dest_index <= dest_index_tmp2(7 downto 0);

  l_index <= dest_index + j;

  l_inv_index_tmp <= j*j + j + csq;
  l_inv_index_tmp2 <= l_inv_index_tmp(9 downto 1) + j*c + c;
  l_inv_index <= l_inv_index_tmp2(7 downto 0);

  sum_index_tmp <= dest_index_tmp2 + r; --sum_index_tmp <= (r + c) * (3 + r + c)/2; --TODO: (r + c) * (r + c - 1)/2
  sum_index <= sum_index_tmp(7 downto 0);

  --process (all)
  process(r, state)
  begin
    if r = 0 then
      weight_read_addr_sel <= d;
    elsif state = matmulhalf then
      weight_read_addr_sel <= s;
      data_read_addr_sel <= d;
    else
      weight_read_addr_sel <= l;
      data_read_addr_sel <= li;
    end if;
  end process;

  with weight_read_addr_sel select
    weight_read_addr <=
    dest_index when d,
    l_index when l,
    sum_index when others;

  with data_read_addr_sel select
    data_read_addr <=
    dest_index when d,
    l_inv_index when others;

  data_write_addr <= dest_index;

  ---------------------------------------------------------------------------
  --instructions-------------------------------------------------------------
  --process (all)
  process (state, i, j, j_is_max)
  begin
    data_read_enable <= '0';
    data_write_enable <= '0';
    weight_read_enable <= '0';
    weight_write_enable <= '0';

    memreg_c <= (swap => switch,
      datareg => hold,
      weightreg => hold);
    writebuff_c <= (swap => noswap,
      datareg => hold,
      weightreg => hold);
    inst <= nop;
    ppinst <= sum16;
    ppshiftinst <=
      (acce => enable,
      shift => 8,
      use_lod => '0',
      shift_dir => right);
    addbiasinst <= (acc => pass,
                    quant => trunc);
    clipinst <= (clip => clip16,
                  outreg => out76);
    zpdata <= (others => '0');
    zpweight <= (others => '0');
    bias <= (others => '0');

    case state is
      when rzero =>
        case i is
          when "00" =>
            ppinst <= nop;
            clipinst.clip <= clipone16;
            data_read_enable <= '1';
            weight_read_enable <= '1';
            memreg_c.datareg <= enable;
            memreg_c.weightreg <= enable;
          when "01" =>
            ppinst <= nop;
            clipinst.clip <= clipzero;
            clipinst.outreg <= out54;
          when "10" =>
            inst <= unitri3;
            ppinst <= select6;
            addbiasinst.acc <= negate;
            ppshiftinst.shift <= 7;
            clipinst.outreg <= out32;
          when others =>
            ppinst <= nop;
            clipinst.clip <= clipone16;
            clipinst.outreg <= out10;
        end case;
      when working =>
        data_read_enable <= '1';
        weight_read_enable <= '1';
        memreg_c.datareg <= enable;
        memreg_c.weightreg <= enable;
        case i is
          when "00" =>
            inst <= matmul00;
            if j_is_max = '1' then
              addbiasinst.acc <= negate;
            end if;
          when "01" =>
            inst <= matmul01;
            if j_is_max = '1' then
              addbiasinst.acc <= negate;
            end if;
            clipinst.outreg <= out54;
          when "10" =>
            inst <= matmul10;
            clipinst.outreg <= out32;
          when others =>
            inst <= matmul11;
            clipinst.outreg <= out10;
        end case;

        if j = 0 then
          ppinst <= fftsub1;-- first
        end if;
      when matmulhalf =>
        ppinst <= sum16left;
        addbiasinst.acc <= negate;
        data_read_enable <= '1';
        weight_read_enable <= '1';
        memreg_c.datareg <= enable;
        memreg_c.weightreg <= enable;
        if i = 2 then
          inst <= matmul10; --inst <= matmul102;
          clipinst.outreg <= out32;
        else
          inst <= matmul11; --inst <= matmul112;
          clipinst.outreg <= out10;
        end if;
      when writing =>
        ppinst <= nop;
        ppshiftinst.acce <= hold;
        clipinst.outreg <= none;
        data_read_enable <= '0';
        weight_read_enable <= '0';
        data_write_enable <= '1';
        weight_write_enable <= '0';
        writebuff_c.datareg <= enable;
        writebuff_c.weightreg <= enable;
      when others =>
        ppinst <= nop;
    end case;
  end process;
  ---------------------------------------------------------------------------

  --process (all)
  process(state, i, j_is_max, nt, r, c_is_max, r_is_max)
  begin
    stall1 <= '0';
    stall2 <= '0';
    if (state = writing and i = 3 and j_is_max = '1') then
      if (unsigned(nt) > 5 and r = 4 and c_is_max = '1') then
        stall1 <= '1';
      end if;
      if (unsigned(nt) > 6 and r > 4 and r_is_max /= '1') then
        stall2 <= '1';
      end if;
    end if;
  end process;

  --process (all)
  process(state, c_is_max, c, nt, stall1, stall2, i)
  begin
    en_max <= x"0";
    if state = writing and c_is_max = '1' and c = 1 and nt = "00010" then -- special case for 2x2 matrix
      en_max <= X"A";
    elsif stall1 = '1' then
      en_max <= X"A";
    elsif stall2 = '1' then
      en_max <= X"A";
    elsif state = writing and i = 2 then
      en_max <= X"A";
    end if;
  end process;

  ---------------------------------------------------------------------------
  --out----------------------------------------------------------------------

  en_max_o <= en_max;

  data0_addr_o <= std_logic_vector(data_read_addr) when (data_write_enable /= '1')
                  else std_logic_vector(data_write_addr);
  data1_addr_o <= data0_addr_o;
  --weight_addr_o <= std_logic_vector(weight_read_addr) when (weight_write_enable /= '1')
  --                else std_logic_vector(weight_write_addr);
  weight_addr_o <= std_logic_vector(weight_read_addr);
  data_read_enable_o <= data_read_enable;
  data_write_enable_o <= data_write_enable;
  weight_read_enable_o <= weight_read_enable;
  weight_write_enable_o <= weight_write_enable;

  memreg_c_o <= memreg_c;
  writebuff_c_o <= writebuff_c;
  inst_o <= inst;
  ppinst_o <= ppinst;
  ppshiftinst_o <= ppshiftinst;
  addbiasinst_o <= addbiasinst;
  clipinst_o <= clipinst;
  zpdata_o <= zpdata;
  zpweight_o <= zpweight;
  bias_o <= bias;

end architecture;
