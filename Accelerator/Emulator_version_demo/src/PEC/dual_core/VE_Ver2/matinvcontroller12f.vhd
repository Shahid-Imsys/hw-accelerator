
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity matinvcontroller12f is
  port (
    clk : in std_logic;
    start : in std_logic;
    en_i : in std_logic;
    nt : in std_logic_vector(3 downto 0) := "0011";--integer range 0 to 15 := 3;
    done : out std_logic;

    data0_addr_o : out std_logic_vector(7 downto 0);
    data1_addr_o : out std_logic_vector(7 downto 0);
    weight_addr_o : out std_logic_vector(7 downto 0);
    bias_addr_o : out std_logic_vector(7 downto 0);
    bias_addr_ctrl_o : out bias_addr_t;
    data_read_enable_o : out std_logic;
    data_write_enable_o : out std_logic;
    weight_read_enable_o : out std_logic;
    weight_write_enable_o : out std_logic;
    bias_ren_o : out std_logic;

    memreg_c_o : out memreg_ctrl;
    writebuff_c_o : out memreg_ctrl;
    inst_o : out instruction;
    ppinst_o : out ppctrl_t;
    ppshiftinst_shift_o : out ppshift_shift_ctrl;
    ppshiftinst_addbias_o : out ppshift_addbias_ctrl;
    ppshiftinst_clip_o : out ppshift_clip_ctrl;
    lzod_o : out lzod_ctrl;
    feedback_ctrl_o : out feedback_t;
    zpdata_o : out std_logic_vector(7 downto 0);
    zpweight_o : out std_logic_vector(7 downto 0);

    en_max_o : out unsigned(3 downto 0)
  );
end entity;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

architecture rtl of matinvcontroller12f is
  signal l_rows_tmp : unsigned(7 downto 0) := (others => '0');
  signal l_rows : unsigned(6 downto 0) := (others => '0');

  signal l0 : unsigned(3 downto 0) := (others => '0');
  signal l1 : unsigned(3 downto 0) := "0001";
  signal l2 : unsigned(3 downto 0) := "0001";
  signal i : unsigned(2 downto 0) := (others => '0');
  signal e : unsigned(1 downto 0) := (others => '0');
  signal l0_ce : std_logic;
  signal l1_ce : std_logic;
  signal l2_ce : std_logic;
  signal i_ce : std_logic;
  signal e_ce : std_logic;
  signal l0_reset : std_logic;
  signal l1_reset : std_logic;
  signal l2_reset : std_logic;
  signal i_reset : std_logic;
  signal e_reset : std_logic;

  type a_addr_type is (kk, ik, ii, ij);
  signal a_addr : unsigned(7 downto 0);--integer  range 0 to 255;
  signal a_addr_tmp : unsigned(9 downto 0);
  signal a_row : unsigned(4 downto 0);--integer  range 0 to 255;
  signal a_col : unsigned(4 downto 0);--integer  range 0 to 255;
  signal a_addr_sel : a_addr_type;
  type l_addr_type is (kk, ik, jk);
  signal l_addr : unsigned(7 downto 0);--integer range 0 to 255;
  signal l_addr_tmp : unsigned(9 downto 0);--integer range 0 to 255;
  signal l_row : unsigned(4 downto 0);--integer range 0 to 255;
  signal l_col : unsigned(4 downto 0);--integer range 0 to 255;
  signal l_addr_sel : l_addr_type;
  signal d_addr : unsigned(7 downto 0);--integer range 0 to 255;
  signal d_inv_addr : unsigned(7 downto 0);--integer range 0 to 255;
  signal last_addr : unsigned(7 downto 0);--integer range 0 to 255;

  type state_type is (xSYTRF, xTRSM, xSYDRK, xGEMDM, idle, writing, working, matmulhalf, rzero, lidi, tmpli); -- TODO: divide into states for each stage?
  signal state : state_type := idle;
  signal next_state : state_type;
  signal prev_state : state_type;

  signal en_max : unsigned(3 downto 0);

  type addr_type is (a, l, d, di, last, li, s, li2, di2, d2, w2, t2, t22);
  signal data_read_addr : unsigned(7 downto 0);
  signal weight_read_addr : unsigned(7 downto 0);
  signal data_write_addr : unsigned(7 downto 0);
  signal weight_write_addr : unsigned(7 downto 0);
  signal bias_addr : std_logic_vector(7 downto 0);
  signal bias_addr_ctrl : bias_addr_t;
  signal data_read_addr_sel : addr_type;
  signal weight_read_addr_sel : addr_type;
  signal data_write_addr_sel : addr_type;
  signal weight_write_addr_sel : addr_type;
  signal data_read_enable : std_logic;
  signal data_write_enable : std_logic;
  signal weight_read_enable : std_logic;
  signal weight_write_enable : std_logic;
  signal bias_ren : std_logic;

  signal memreg_c : memreg_ctrl;
  signal writebuff_c : memreg_ctrl;
  signal inst : instruction;
  signal ppinst : ppctrl_t;
  signal ppshiftinst_shift : ppshift_shift_ctrl;
  signal ppshiftinst_addbias : ppshift_addbias_ctrl;
  signal ppshiftinst_clip : ppshift_clip_ctrl;
  signal lzod : lzod_ctrl;
  signal feedback_ctrl : feedback_t;
  signal zpdata : std_logic_vector(7 downto 0);
  signal zpweight : std_logic_vector(7 downto 0);

  signal l0p1 : unsigned(3 downto 0); -- TODO: ??this requires nt to maximum be 14 to fit, otherwise lx_cntr requires one more bit??, or maybe not at futher thought
  signal l1p1 : unsigned(3 downto 0);
  signal l2p1 : unsigned(3 downto 0);
  signal instrp1 : unsigned(2 downto 0);
  signal ep1 : unsigned(1 downto 0);
  signal ntm1 : unsigned(3 downto 0);
  signal l1m1 : unsigned(3 downto 0);

  signal instris0 : std_logic;
  signal instris1 : std_logic;
  signal instris2 : std_logic;

  type stage_type is (ldl, linv, mult, idle);
  signal stage : stage_type := idle;
  signal next_stage : stage_type := idle;

  signal instr_is_max : std_logic;
  signal e_is_max : std_logic;
  signal l0_is_max : std_logic;
  signal l1_is_max : std_logic;
  signal l2_is_max : std_logic;

  signal instr_max : unsigned(2 downto 0) := (others => '0');
  signal e_max : unsigned(1 downto 0) := (others => '0');
  signal l0_max : unsigned(3 downto 0) := (others => '0');
  signal l1_max : unsigned(3 downto 0) := (others => '0');
  signal l2_max : unsigned(3 downto 0) := (others => '0');

  signal csq : unsigned(7 downto 0) := (others => '0');
  signal dest_index_tmp : unsigned(8 downto 0) := (others => '0');
  signal dest_index_tmp2 : unsigned(8 downto 0) := (others => '0');
  signal dest_index : unsigned(7 downto 0) := (others => '0');
  signal linv_dest_index_tmp : unsigned(9 downto 0) := (others => '0');
  signal linv_dest_index : unsigned(7 downto 0) := (others => '0');
  signal l_index : unsigned(7 downto 0) := (others => '0');
  signal l_inv_index_tmp : unsigned(8 downto 0) := (others => '0');
  signal l_inv_index_tmp2 : unsigned(9 downto 0) := (others => '0');
  signal l_inv_index : unsigned(7 downto 0) := (others => '0');
  signal sum_index_tmp : unsigned(8 downto 0) := (others => '0');
  signal sum_index : unsigned(7 downto 0) := (others => '0');


  signal stall1 : std_logic;
  signal stall2 : std_logic;

  signal l_inv_addr_tmp2 : unsigned(7 downto 0) := (others => '0');
  signal l_inv_addr_tmp : unsigned(7 downto 0) := (others => '0');
  signal l_inv_addr : unsigned(7 downto 0) := (others => '0');
  signal d_inv_addr2 : unsigned(7 downto 0) := (others => '0');
  signal ntt2 : unsigned(4 downto 0) := (others => '0');
  signal tmp_addr_tmp2 : unsigned(8 downto 0) := (others => '0');
  signal tmp_addr_tmp : unsigned(7 downto 0) := (others => '0');
  signal tmp_addr : unsigned(7 downto 0) := (others => '0');
  signal row : unsigned(4 downto 0) := (others => '0');
  signal d_addr2_tmp : unsigned(9 downto 0) := (others => '0');
  signal d_addr2 : unsigned(7 downto 0) := (others => '0');
  signal w_addr_tmp2 : unsigned(8 downto 0) := (others => '0');
  signal w_addr_tmp : unsigned(7 downto 0) := (others => '0');
  signal w_addr : unsigned(7 downto 0) := (others => '0');
  signal tmp_addr2_tmp2 : unsigned(7 downto 0) := (others => '0');
  signal tmp_addr2_tmp : unsigned(7 downto 0) := (others => '0');
  signal tmp_addr2 : unsigned(7 downto 0) := (others => '0');
begin

  l0p1 <= l0 + 1;
  l1p1 <= l1 + 1;
  l2p1 <= l2 + 1;
  instrp1 <= i + 1;
  ep1 <= e + 1;
  ntm1 <= unsigned(nt) - 1;
  l1m1 <= l1 - 1;

  instris0 <= '1' when i = "000" else '0';
  instris1 <= '1' when i = "001" else '0';
  instris2 <= '1' when i = "010" else '0';

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if l0_reset = '1' then
          l0 <= (others => '0');
        elsif l0_ce = '1' then
          l0 <= l0p1;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if l1_reset = '1' then
          if stage = ldl then
            l1 <= l0p1;
          else
            l1 <= (others => '0');
          end if;
        elsif l1_ce = '1' then
          l1 <= l1p1;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if l2_reset = '1' then
          if stage = ldl then
            l2 <= l0p1;
          else
            l2 <= (others => '0');
          end if;
        elsif l2_ce = '1' then
          l2 <= l2p1;
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
          i <= instrp1;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        if e_reset = '1' then
          e <= (others => '0');
        else
          if stage = linv or stage = mult then
            if e_ce = '1' then
              e <= ep1;
            end if;
          else
            e <= ep1;
          end if;
        end if;
      end if;
    end if;
  end process;

  -- next state process
  process (state, prev_state, l0, l1, l2, i, e, start, instris1, instris2, ntm1, l0p1, l1m1, stage, e_is_max, l2_is_max, l1_is_max, l0_is_max)
  begin
    next_state <= state;
    next_stage <= stage;
    done <= '0';
    case stage is
      when ldl =>
        if state = xSYTRF then -- xSYTRF
          if (e = "11" and (instris1 = '1' or instris2 = '1')) or i = "110" then
            next_state <= writing;
          end if;
        elsif state = xTRSM then -- xTRSM
          if e = "11" then
            next_state <= writing;
          end if;
        elsif state = xSYDRK then -- xSYDRK
          if e = "11" then
            next_state <= writing;
          end if;
        elsif state = xGEMDM then -- xGEMDM
          if e = "11" then
            next_state <= writing;
          end if;
        elsif state = writing then
          if prev_state = xSYTRF then
            if i = "110" then
              if l0 = ntm1 then
                next_state <= idle;
                next_stage <= linv;
              else
                next_state <= xTRSM;
              end if;
            else
              next_state <= xSYTRF;
            end if;
          elsif prev_state = xTRSM then
            if instris1 = '1' and '0'&l1 = ntm1 then
              next_state <= xSYDRK;
            else
              next_state <= xTRSM;
            end if;
          elsif prev_state = xSYDRK then
            if instris2 = '1' then
              if '0'&l1 > '0'&l0p1 then
                next_state <= xGEMDM;
              elsif '0'&l1 = ntm1 then
                next_state <= xSYTRF;
              else
                next_state <= xSYDRK;
              end if;
            else
              next_state <= xSYDRK;
            end if;
          else
            if instris2 = '1' then
              if '0'&l2 = l1m1 then
                if '0'&l1 = ntm1 then
                  next_state <= xSYTRF;
                else
                  next_state <= xSYDRK;
                end if;
              else
                next_state <= xGEMDM;
              end if;
            else
              next_state <= xGEMDM;
            end if;
          end if;
        else -- idle
          done <= '0';
          if start = '1' then
            next_state <= xSYTRF;
          end if;
        end if;

      when linv =>
        case state is
          when rzero =>
            if e_is_max = '1' then
              next_state <= writing;
            else
              next_state <= state;
            end if;
          when working =>
            if l2_is_max = '1' then
              if e >= 2 then
                next_state <= matmulhalf;
              elsif e = 1 then
                next_state <= writing;
              end if;
            else
              next_state <= state;
            end if;
          when matmulhalf =>
            if e_is_max = '1' and l2_is_max = '1' then
              next_state <= writing;
            else
              next_state <= working;
            end if;
          when writing =>
            case prev_state is
              when rzero =>
                if l1_is_max = '1' then
                  next_state <= working;
                else
                  next_state <= rzero;
                end if;
              when working =>
                next_state <= working;
              when others =>
                if l0_is_max = '1' and l1_is_max = '1' and e_is_max = '1' and l2_is_max = '1' then
                  next_state <= idle;
                  next_stage <= mult;
                else
                  next_state <= working;
                end if;
            end case;
          when others => --idle
            done <= '0';
            next_state <= rzero;
        end case;

      when mult =>
        case state is
          when lidi =>
            if e_is_max = '1' then
              next_state <= writing;
            else
              next_state <= state;
            end if;
          when tmpli =>
            if e_is_max = '1' and l2_is_max = '1' then
              next_state <= writing;
            else
              next_state <= state;
            end if;

          when writing =>
            case prev_state is
              when lidi =>
                if l0_is_max = '1' and l1_is_max = '1' then
                  next_state <= tmpli;
                else
                  next_state <= lidi;
                end if;

              when others => --tmpli
                if l0_is_max = '1' and l1_is_max = '1' then
                  next_state <= idle;
                  next_stage <= idle;
                  done <= '1';
                else
                  next_state <= tmpli;
                end if;

            end case;

          when others => --idle
            next_state <= lidi;
        end case;

      when others => --idle
        done <= '0';
        if start = '1' then
          next_stage <= ldl;
          next_state <= xSYTRF;
        else
          next_stage <= stage;
        end if;

    end case;

  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if en_i = '1' then
        state <= next_state;
        prev_state <= state;
        stage <= next_stage;
      end if;
    end if;
  end process;
  -- counter control
  process (state, next_state, prev_state, i, e, instr_max, start, instris0, instris1, instris2, stage,  e_is_max, l2_is_max, l1_is_max, l0_is_max)
  begin
    --c_ce <= '1';
    l0_ce <= '0';
    l1_ce <= '0';
    l2_ce <= '0';
    i_ce <= '0';
    e_ce <= '0';
    l0_reset <= '0';
    l1_reset <= '0';
    l2_reset <= '0';
    i_reset <= '0';
    e_reset <= '0';

    case stage is
      when ldl =>
        e_ce <= '1';
        if state = xSYTRF then -- xSYTRF
          if (instris0 = '1' and e = "11") or (i = "011" and e = "11") or (i = "100" and e = "11") or i = "101" then
            i_ce <= '1';
            e_reset <= '1';
          end if;
        elsif state = writing then
          if prev_state = xSYTRF then
            if next_state = xTRSM then
              l1_reset <= '1';
            end if;
          elsif prev_state = xTRSM and instris1 = '1' then
            if next_state = xTRSM then
              l1_ce <= '1';
            else -- next_state = xSYDRK
              l1_reset <= '1';
            end if;
          elsif prev_state = xSYDRK and instris2 = '1' then
            if next_state = xSYTRF then
              l0_ce <= '1';
            elsif next_state = xSYDRK then
              l1_ce <= '1';
            else -- next_state = xGEMDM
              l2_reset <= '1';
            end if;
          elsif prev_state = xGEMDM and instris2 = '1' then
            if next_state = xSYTRF then
              l0_ce <= '1';
            elsif next_state = xSYDRK then
              l1_ce <= '1';
            else -- next_state = xGEMDM
              l2_ce <= '1';
            end if;
          end if;
          if i = instr_max then
            i_reset <= '1';
          else
            i_ce <= '1';
          end if;
          e_reset <= '1';
        else -- idle
          if start = '1' then
            l0_reset <= '1';
            l1_reset <= '1';
            l2_reset <= '1';
            i_reset <= '1';
            e_reset <= '1';
          end if;
        end if;
      when linv =>
        l1_ce <= '0';
        case state is
          when rzero =>
            l2_reset <= '1';
            if e_is_max = '0' then
              e_ce <= '1';
            end if;
          when working =>
            if next_state /= matmulhalf then
              if l2_is_max = '1' then
                l2_reset <= '1';
                if e_is_max = '1' then
                  e_reset <= '1';
                  if l1_is_max = '1' then
                    l1_reset <= '1';
                    if l0_is_max = '1' then
                      l0_reset <= '1';
                    else
                      l0_ce <= '1';
                    end if;
                  else
                    l1_ce <= '1';
                  end if;
                else
                  e_ce <= '1';
                end if;
              else
                l2_ce <= '1';
              end if;
            end if;
          when matmulhalf =>
            if e_is_max = '0' then
              e_ce <= '1';
            end if;
            if next_state = working then
              l2_reset <= '1';
            end if;
          when writing =>
            if e_is_max = '1' then
              e_reset <= '1';
              if l1_is_max = '1' then
                l1_reset <= '1';
                if l0_is_max = '1' then
                  l0_reset <= '1';
                else
                  l0_ce <= '1';
                end if;
              else
                l1_ce <= '1';
              end if;
            end if;
            if l2_is_max = '1' then
              l2_reset <= '1';
            end if;
          when idle =>
            l0_reset <= '1';
            l1_reset <= '1';
            e_reset <= '1';
            l2_reset <= '1';
          when others =>
            l0_reset <= '0';
            l1_reset <= '0';
            e_reset <= '0';
            l2_reset <= '0';
        end case;
      when mult =>
        l1_ce <= '0';
        case state is
          when lidi =>
            e_ce <= '1';

          when tmpli =>
            if l2_is_max = '1' then
              e_ce <= '1';
              l2_reset <= '1';
            else
              l2_ce <= '1';
            end if;

          when writing =>
            e_reset <= '1';
            l2_reset <= '1';
            if l1_is_max = '1' then
              if l0_is_max = '1' then
                l0_reset <= '1';
              else
                l0_ce <= '1';
              end if;
            end if;
            if l1_is_max = '1' then
              l1_reset <= '1';
            else
              l1_ce <= '1';
            end if;

          when others =>
            l0_reset <= '1';
            l1_reset <= '1';
            l2_reset <= '1';
            i_reset <= '1';
            e_reset <= '1';
        end case;

      when others => --idle
        l0_reset <= '1';
        l1_reset <= '1';
        l2_reset <= '1';
        i_reset <= '1';
        e_reset <= '1';
    end case;

  end process;

  process (stage, prev_state, nt)
  begin
    case stage is
      when ldl =>
        case prev_state is
          when xSYTRF =>
            instr_max <= "110";
          when xTRSM =>
            instr_max <= "001";
          when xSYDRK =>
            instr_max <= "010";
          when xGEMDM =>
            instr_max <= "010";
          when others =>
            instr_max <= "111";
        end case;

      when others => --linv
        instr_max <= "111";

    end case;
  end process;

  l0_max <= (unsigned(nt(3 downto 0)) - 1);

  with stage select
    l1_max <=
    (l0_max - l0) when linv,
    l0 when others;

  e_max <= "11";

  process (stage, nt, l0)
  begin
    case stage is
      when linv =>
        l2_max <= (others => '0') when l0 = 0 else l0 - 1;

      when others => --mult
        l2_max <= unsigned(nt(3 downto 0)) - l0 - 1;

    end case;
  end process;

  l0_is_max <= '1' when (l0 = l0_max) else '0';
  l1_is_max <= '1' when (l1 = l1_max) else '0';
  l2_is_max <= '1' when (l2 = l2_max) else '0';
  instr_is_max <= '1' when (i = instr_max) else '0';
  e_is_max <= '1' when (e = e_max) else '0';

  -- address select control
  process (state, prev_state, i, instris0, instris1, stage, l0)
  begin
    data_read_addr_sel <= a;
    weight_read_addr_sel <= last;
    data_write_addr_sel <= last;
    weight_write_addr_sel <= last;
    a_addr_sel <= kk;
    l_addr_sel <= kk;
    case stage is
      when ldl =>
        if state = xSYTRF then -- xSYTRF
          data_read_addr_sel <= a;
          a_addr_sel <= kk;
        elsif state = xTRSM then -- xTRSM
          if instris0 = '1' then -- 4 cycles, Aik*Lkk
            data_read_addr_sel <= a;
            weight_read_addr_sel <= l;
            a_addr_sel <= ik;
            l_addr_sel <= kk;
          else -- 4 cycles, tmp*d_inv
            data_read_addr_sel <= last;
            weight_read_addr_sel <= di;
          end if;
        elsif state = xSYDRK then -- xSYDRK
          if instris0 = '1' then -- 4 cycles, Aik*Lkk
            data_read_addr_sel <= a;
            weight_read_addr_sel <= l;
            a_addr_sel <= ik;
            l_addr_sel <= kk;
          elsif instris1 = '1' then -- 4 cycles, tmp*Lik, W*D
            data_read_addr_sel <= last;
            weight_read_addr_sel <= l;
            l_addr_sel <= ik;
          else -- matsub
            data_read_addr_sel <= a;
            weight_read_addr_sel <= last;
            a_addr_sel <= ii;
          end if;
        elsif state = xGEMDM then -- xGEMDM
          if instris0 = '1' then -- 4 cycles, Aik*Lkk
            data_read_addr_sel <= a;
            weight_read_addr_sel <= l;
            a_addr_sel <= ik;
            l_addr_sel <= kk;
          elsif instris1 = '1' then -- 4 cycles, tmp*Ljk, D*W
            data_read_addr_sel <= last;
            weight_read_addr_sel <= l;
            l_addr_sel <= jk;
          else -- matsub
            data_read_addr_sel <= a;
            weight_read_addr_sel <= last;
            a_addr_sel <= ij;
          end if;
        elsif state = writing then
          if prev_state = xSYTRF then
            case i is
              when "001" =>
                weight_write_addr_sel <= l;
                l_addr_sel <= kk;
              when "010" =>
                weight_write_addr_sel <= d;
              when others =>
                weight_write_addr_sel <= di;
            end case;
          elsif prev_state = xTRSM then
            if instris0 = '1' then -- 4 cycles, Aik*Lkk
              data_write_addr_sel <= last;
            else -- 4 cycles, tmp*d_inv
              weight_write_addr_sel <= l;
              l_addr_sel <= ik;
            end if;
          elsif prev_state = xSYDRK then
            if instris0 = '1' then -- 4 cycles, Aik*Lkk
              data_write_addr_sel <= last;
            elsif instris1 = '1' then -- 4 cycles, tmp*Lik, W*D
              weight_write_addr_sel <= last;
            else -- matsub
              data_write_addr_sel <= a;
              a_addr_sel <= ii;
            end if;
          else -- prev_state = xGEMDM
            if instris0 = '1' then -- 4 cycles, Aik*Lkk
              data_write_addr_sel <= last;
            elsif instris1 = '1' then -- 4 cycles, tmp*Ljk, D*W
              weight_write_addr_sel <= last;
            else -- matsub
              data_write_addr_sel <= a;
              a_addr_sel <= ij;
            end if;
          end if;
        else -- idle, prepare for start
          data_read_addr_sel <= a;
          weight_read_addr_sel <= last;
          data_write_addr_sel <= last;
          weight_write_addr_sel <= last;
          a_addr_sel <= kk;
          l_addr_sel <= kk;
        end if;
      when linv =>
        if l0 = 0 then
          weight_read_addr_sel <= d;
        elsif state = matmulhalf then
          weight_read_addr_sel <= s;
          data_read_addr_sel <= d;
        else
          weight_read_addr_sel <= l;
          data_read_addr_sel <= li;
        end if;
      when others => --mult
        case state is
          when lidi =>
            data_read_addr_sel <= li2;
            weight_read_addr_sel <= di2;
          when tmpli =>
            data_read_addr_sel <= d2;
            weight_read_addr_sel <= w2;
          when others => -- writing
            case prev_state is
              when lidi =>
                data_read_addr_sel <= li2;
                weight_read_addr_sel <= di2;
                weight_write_addr_sel <= t2;
              when others => -- tmpli
                data_read_addr_sel <= d2;
                weight_read_addr_sel <= w2;
                data_write_addr_sel <= t22;
            end case;
        end case;
    end case;
  end process;

  -- addresses --TODO: possible optimization, resize usage and address generation depending on stage
  --ldl
  l_rows_tmp <= unsigned(nt) * unsigned(nt) + unsigned(nt);
  l_rows <= l_rows_tmp(7 downto 1);

  a_addr_tmp <= a_row * a_row + a_row;
  a_addr <= a_addr_tmp(8 downto 1) + a_col;

  l_addr_tmp <= l_row * l_row + l_row;
  l_addr <= l_addr_tmp(8 downto 1) + l_col;

  d_addr <= resize(l0,8) + resize(l_rows,8);
  d_inv_addr <= d_addr + unsigned(nt);
  last_addr <= x"FF";

  --linv
  csq <= l1 * l1 + l1;

  dest_index_tmp <= resize(l0 * l0 + l0,9) + resize(csq,9);
  dest_index_tmp2 <= resize(dest_index_tmp(8 downto 1),9) + resize(l0 * l1 + l1,9);
  dest_index <= dest_index_tmp2(7 downto 0);

  linv_dest_index_tmp <= resize(dest_index_tmp2,10) + resize(l_rows,10);
  linv_dest_index <= linv_dest_index_tmp(7 downto 0);

  l_index <= dest_index + l2;

  l_inv_index_tmp <= resize(l2 * l2 + l2,9) + resize(csq,9);
  l_inv_index_tmp2 <= resize(l_inv_index_tmp(8 downto 1),10) + resize(l2 * l1 + l1,10) + resize(l_rows,10);
  l_inv_index <= l_inv_index_tmp2(7 downto 0);

  sum_index_tmp <= dest_index_tmp2 + l0;
  sum_index <= sum_index_tmp(7 downto 0);

  --mult
  l_inv_addr_tmp2 <= (l0 + 1) * (l0);
  l_inv_addr_tmp <= resize(l_inv_addr_tmp2(7 downto 1),8) + resize(l1,8) + resize(l_rows,8);
  l_inv_addr <= l_inv_addr_tmp(7 downto 0);
  d_inv_addr2 <= l0 + resize(l_rows,8) + unsigned(nt);
  ntt2 <= unsigned(nt)&'0';
  tmp_addr_tmp2 <= l1 * (ntt2 - l1 - 1);
  tmp_addr_tmp <= tmp_addr_tmp2(8 downto 1) + l0;
  tmp_addr <= tmp_addr_tmp(7 downto 0);
  row <= resize(l0,5) + resize(l2,5);
  d_addr2_tmp <= (row * (row + 1))/2 + l1 + l_rows;
  d_addr2 <= d_addr2_tmp(7 downto 0);
  w_addr_tmp2 <= l0 * (ntt2 + 1 - l0);
  w_addr_tmp <= l2 + w_addr_tmp2(8 downto 1);
  w_addr <= w_addr_tmp(7 downto 0);
  tmp_addr2_tmp2 <= (l0 + 1) * (l0);
  tmp_addr2_tmp <= resize(tmp_addr2_tmp2(7 downto 1),8) + resize(l1,8);
  tmp_addr2 <= tmp_addr2_tmp(7 downto 0);

  with a_addr_sel select
    a_row <= '0'&l0 when kk,
    '0'&l1 when others;

  with a_addr_sel select
    a_col <= '0'&l0 when kk,
    '0'&l0 when ik,
    '0'&l1 when ii,
    '0'&l2 when others;

  with l_addr_sel select
    l_row <= '0'&l0 when kk,
    '0'&l1 when ik,
    '0'&l2 when others;

  l_col <= '0'&l0;

  -- remove unneccesary addresses

  process (stage, data_read_addr_sel, a_addr, last_addr, l_inv_index, linv_dest_index, l_inv_addr, d_addr2)
  begin
    case stage is
      when ldl =>
        case data_read_addr_sel is
          when a =>
            data_read_addr <= a_addr;
          when others =>
            data_read_addr <= last_addr;
        end case;

      when linv =>
        case data_read_addr_sel is
          when d =>
            data_read_addr <= linv_dest_index;
          when others =>
            data_read_addr <= l_inv_index;
        end case;

      when others => --mult
        case data_read_addr_sel is
          when li2 =>
            data_read_addr <= l_inv_addr;
          when others =>
            data_read_addr <= d_addr2;
        end case;

    end case;
  end process;

  process (stage, weight_read_addr_sel, a_addr, l_addr, d_inv_addr, last_addr, dest_index, l_index, sum_index, d_inv_addr2, w_addr)
  begin
    case stage is
      when ldl =>
        case weight_read_addr_sel is
          when a =>
            weight_read_addr <= a_addr;
          when l =>
            weight_read_addr <= l_addr;
          when di =>
            weight_read_addr <= d_inv_addr;
          when others =>
            weight_read_addr <= last_addr;
        end case;

      when linv =>
        case weight_read_addr_sel is
          when d =>
            weight_read_addr <= dest_index;
          when l =>
            weight_read_addr <= l_index;
          when others =>
            weight_read_addr <= sum_index;
        end case;

      when others => -- mult
        case weight_read_addr_sel is
          when di2 =>
            weight_read_addr <= d_inv_addr2;
          when others =>
            weight_read_addr <= w_addr;
        end case;
    end case;
  end process;

  process (stage, data_write_addr_sel, a_addr, last_addr, linv_dest_index, tmp_addr2)
  begin
    case stage is
      when ldl =>
        case data_write_addr_sel is
          when a =>
            data_write_addr <= a_addr;
          when others =>
            data_write_addr <= last_addr;
        end case;

      when linv =>
        data_write_addr <= linv_dest_index;

      when others => --mult
        data_write_addr <= tmp_addr2;

    end case;
  end process;

  process (stage, weight_write_addr_sel, a_addr, l_addr, d_addr, d_inv_addr, last_addr, tmp_addr)
  begin
    case stage is
      when ldl =>
        case weight_write_addr_sel is
          when a =>
            weight_write_addr <= a_addr;
          when l =>
            weight_write_addr <= l_addr;
          when d =>
            weight_write_addr <= d_addr;
          when di =>
            weight_write_addr <= d_inv_addr;
          when others =>
            weight_write_addr <= last_addr;
        end case;

      when others => --mult
        weight_write_addr <= tmp_addr;

    end case;
  end process;

  bias_addr <= (others => '0');

  -- instructions
  process (state, prev_state, i, e, instris0, instris1, stage, l2_is_max, l2)
  begin

    bias_ren <= '0';
    bias_addr_ctrl <= ctrl;
    lzod <= (word => "00", store => none, output => none);
    feedback_ctrl <= keep;

    case stage is
      when ldl =>
        data_read_enable <= '0';
        weight_read_enable <= '0';
        data_write_enable <= '0';
        weight_write_enable <= '0';
        bias_ren <= '0';
        bias_addr_ctrl <= ctrl;

        memreg_c <= (swap => noswap,
          datareg => hold,
          weightreg => hold);
        writebuff_c <= (swap => noswap,
          datareg => hold,
          weightreg => hold);

        inst <= nop;
        ppinst <= fftsub1;
        ppshiftinst_shift <=
          (acce => enable,
          shift => 12,
          use_lod => '0',
          shift_dir => right);

        ppshiftinst_addbias <=
          (acc => pass,
          --quant => trunc);
          quant => round);

        ppshiftinst_clip <=
          (clip => clip16,
          outreg => none);

        lzod <= (word => "00", store => none, output => none);
        feedback_ctrl <= keep;

        zpdata <= (others => '0');
        zpweight <= (others => '0');

        if state = xSYTRF then -- xSYTRF
          case i is
            when "000" =>
              case e is
                when "00" =>
                  data_read_enable <= '1';
                  bias_addr_ctrl <= shift;
                  memreg_c.datareg <= enable;
                  inst <= abs16;
                  ppinst <= select6;
                  ppshiftinst_shift.use_lod <= '1';
                  lzod <= (word => "11", store => store2, output => val);
                  feedback_ctrl <= shift_to_3;
                when "01" =>
                  inst <= abs16;
                  ppinst <= select2;
                  ppshiftinst_shift.use_lod <= '1';
                  lzod <= (word => "01", store => store1, output => val);
                  feedback_ctrl <= shift_to_2;
                when "10" =>
                  inst <= mulden;
                  ppinst <= matmulleft;
                  ppshiftinst_shift <= (acce => enable, shift => 9, use_lod => '0', shift_dir => left);
                  feedback_ctrl <= shift_to_2;
                when others =>
                  inst <= mulnum;
                  ppinst <= matmulleft;
                  ppshiftinst_shift <= (acce => enable, shift => 1, use_lod => '0', shift_dir => left);
                  feedback_ctrl <= shift_to_3;
              end case;
            when "001" =>
              case e is
                when "00" =>
                  ppinst <= nop;
                  ppshiftinst_clip.clip <= clipone16_12f;
                  ppshiftinst_clip.outreg <= out76;
                when "01" =>
                  ppinst <= nop;
                  ppshiftinst_clip.clip <= clipzero;
                  ppshiftinst_clip.outreg <= out54;
                when "10" =>
                  ppinst <= nop;
                  ppshiftinst_clip.clip <= clipone16_12f;
                  ppshiftinst_clip.outreg <= out10;
                when others =>
                  inst <= nrit;
                  ppinst <= nrit;
                  ppshiftinst_shift <= (acce => enable, shift => 12, use_lod => '1', shift_dir => right);
                  ppshiftinst_addbias <= (acc => pass, quant => round);
                  ppshiftinst_clip <= (clip => clip16, outreg => out32);
                  lzod <= (word => "11", store => none, output => nrit);
                  feedback_ctrl <= clip_to_1;
              end case;
            when "010" =>
              case e is
                when "00" =>
                  inst <= unitri1;
                  ppinst <= select6;
                  ppshiftinst_shift.shift <= 7;
                  ppshiftinst_clip.outreg <= out76;
                when "01" =>
                  ppinst <= nop;
                  ppshiftinst_clip.clip <= clipzero;
                  ppshiftinst_clip.outreg <= out54;
                when "10" =>
                  ppinst <= nop;
                  ppshiftinst_clip.clip <= clipzero;
                  ppshiftinst_clip.outreg <= out32;
                when others => -- "11"
                  inst <= unispec;
                  ppinst <= unitri;
                  ppshiftinst_clip.outreg <= out10;
              end case;
            when "011" =>
              case e is
                when "00" =>
                  inst <= matdet;
                  ppinst <= fftsub0;
                  ppshiftinst_shift <= (acce => hold, shift => 0, use_lod => '0', shift_dir => left);
                  lzod <= (word => "10", store => none, output => none);
                when "01" =>
                  --normalize det(a)
                  bias_addr_ctrl <= shift;
                  ppinst <= nop;
                  ppshiftinst_shift.use_lod <= '1';
                  lzod <= (word => "10", store => store2, output => val);
                  feedback_ctrl <= shift_to_3;
                when "10" =>
                  --normalize a(1)
                  inst <= abs16;
                  ppinst <= select6;
                  ppshiftinst_shift.use_lod <= '1';
                  lzod <= (word => "11", store => store1, output => val);
                  feedback_ctrl <= shift_to_2;
                when others =>
                  -- calc d(4)
                  inst <= unispec;
                  ppinst <= unitri;
                  ppshiftinst_shift <= (acce => hold, shift => 0, use_lod => '0', shift_dir => left);
                  lzod <= (word => "10", store => none, output => none);
              end case;
            when "100" =>
              case e is
                when "00" =>
                  --normalize d(4)
                  --bias_addr_ctrl <= shift;
                  ppinst <= nop;
                  ppshiftinst_shift.use_lod <= '1';
                  lzod <= (word => "10", store => store3, output => val);
                  feedback_ctrl <= shift_to_2;
                when "01" =>
                  -- calc delta
                  inst <= mulden;
                  ppinst <= matmulleft;
                  ppshiftinst_shift <= (acce => enable, shift => 9, use_lod => '0', shift_dir => left);
                  feedback_ctrl <= shift_to_2;
                when "10" =>
                  -- calc t1
                  inst <= mulnum;
                  ppinst <= matmulleft;
                  ppshiftinst_shift <= (acce => enable, shift => 1, use_lod => '0', shift_dir => left);
                  feedback_ctrl <= shift_to_3;
                when others =>
                  -- calc t2
                  inst <= mulnum;
                  ppinst <= matmulleft;
                  ppshiftinst_shift <= (acce => enable, shift => 1, use_lod => '0', shift_dir => left);
                  feedback_ctrl <= shift_to_3;
              end case;
            when "101" =>
              -- calc it1
              inst <= nrit;
              ppinst <= nrit;
              ppshiftinst_shift.use_lod <= '1';
              lzod <= (word => "11", store => none, output => det1);
              ppshiftinst_addbias <= (acc => pass, quant => round);
              ppshiftinst_clip <= (clip => clip16, outreg => out10);
            when others =>
              -- calc it2
              inst <= nrit;
              ppinst <= nrit;
              ppshiftinst_shift.use_lod <= '1';
              lzod <= (word => "11", store => none, output => nrit2);
              ppshiftinst_addbias <= (acc => pass, quant => round);
              ppshiftinst_clip <= (clip => clip16, outreg => out76);
          end case;
        elsif state = xTRSM then -- xTRSM
          if instris0 = '1' then -- 4 cycles, Aik*Lkk
            inst <= unitri1;
            ppinst <= select6;
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
                ppshiftinst_shift.shift <= 7;
              when "01" =>
                inst <= unitri2;
                ppinst <= unitri;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= unitri3;
                ppshiftinst_clip.outreg <= out32;
                ppshiftinst_shift.shift <= 7;
              when others =>
                inst <= unitri4;
                ppinst <= unitri;
                ppshiftinst_clip.outreg <= out10;
            end case;
          else -- 4 cycles, tmp*d_inv
            inst <= matmul00;
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
              when "01" =>
                inst <= matmul01;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                inst <= matmul11;
                ppshiftinst_clip.outreg <= out10;
            end case;
          end if;
        elsif state = xSYDRK then -- xSYDRK
          if instris0 = '1' then -- 4 cycles, Aik*Lkk
            inst <= unitri1;
            ppinst <= select6;
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
                ppshiftinst_shift.shift <= 7;
              when "01" =>
                inst <= unitri2;
                ppinst <= unitri;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= unitri3;
                ppshiftinst_clip.outreg <= out32;
                ppshiftinst_shift.shift <= 7;
              when others =>
                inst <= unitri4;
                ppinst <= unitri;
                ppshiftinst_clip.outreg <= out10;
            end case;
          elsif instris1 = '1' then -- 4 cycles, tmp*Lik, W*D
            inst <= matmul00t; -- matmul_t
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
              when "01" =>
                inst <= matmul01t;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= matmul10t;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                inst <= matmul11t;
                ppshiftinst_clip.outreg <= out10;
            end case;
          else -- matsub
            inst <= matsub;
            ppinst <= select6;
            ppshiftinst_shift.shift <= 7;
            ppshiftinst_addbias <= (acc => pass, quant => round);
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
              when "01" =>
                ppinst <= select4;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                ppinst <= select2;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                ppinst <= select0;
                ppshiftinst_clip.outreg <= out10;
            end case;
          end if;
        elsif state = xGEMDM then -- xGEMDM
          if instris0 = '1' then -- 4 cycles, Aik*Lkk
            inst <= unitri1;
            ppinst <= select6;
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
                ppshiftinst_shift.shift <= 7;
              when "01" =>
                inst <= unitri2;
                ppinst <= unitri;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= unitri3;
                ppshiftinst_clip.outreg <= out32;
                ppshiftinst_shift.shift <= 7;
              when others =>
                inst <= unitri4;
                ppinst <= unitri;
                ppshiftinst_clip.outreg <= out10;
            end case;
          elsif instris1 = '1' then -- 4 cycles, tmp*Lik, W*D
            inst <= matmul00t; -- matmul_t
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
              when "01" =>
                inst <= matmul01t;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= matmul10t;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                inst <= matmul11t;
                ppshiftinst_clip.outreg <= out10;
            end case;
          else -- matsub
            inst <= matsub;
            ppinst <= select6;
            ppshiftinst_shift.shift <= 7;
            case e is
              when "00" =>
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
                ppshiftinst_clip.outreg <= out76;
              when "01" =>
                ppinst <= select4;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                ppinst <= select2;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                ppinst <= select0;
                ppshiftinst_clip.outreg <= out10;
            end case;
          end if;
        elsif state = writing then
          writebuff_c.datareg <= enable;
          ppinst <= nop;
          ppshiftinst_shift.acce <= hold;
          case prev_state is
            when xSYTRF =>
              weight_write_enable <= '1';
            when xTRSM =>
              case i is
                when "000" =>
                  data_write_enable <= '1';
                when others =>
                  weight_write_enable <= '1';
              end case;
            when xSYDRK =>
              case i is
                when "001" =>
                  weight_write_enable <= '1';
                when others =>
                  data_write_enable <= '1';
              end case;
            when others => -- xGEMDM
              case i is
                when "001" =>
                  weight_write_enable <= '1';
                when others =>
                  data_write_enable <= '1';
              end case;
          end case;
        else -- idle, prepare for start
          inst <= nop;
          ppinst <= nop;
        end if;

      when linv =>
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
        ppshiftinst_shift <=
          (acce => enable,
          shift => 12,
          use_lod => '0',
          shift_dir => right);
        ppshiftinst_addbias <= (acc => pass,
          --quant => trunc);
          quant => round);
        ppshiftinst_clip <= (clip => clip16,
          outreg => out76);
        zpdata <= (others => '0');
        zpweight <= (others => '0');

        case state is
          when rzero =>
            case e is
              when "00" =>
                ppinst <= nop;
                ppshiftinst_clip.clip <= clipone16_12f;
                data_read_enable <= '1';
                weight_read_enable <= '1';
                memreg_c.datareg <= enable;
                memreg_c.weightreg <= enable;
              when "01" =>
                ppinst <= nop;
                ppshiftinst_clip.clip <= clipzero;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= unitri3;
                ppinst <= select6;
                ppshiftinst_addbias.acc <= negate;
                ppshiftinst_addbias.quant <= trunc; --TODO
                ppshiftinst_shift.shift <= 7;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                ppinst <= nop;
                ppshiftinst_clip.clip <= clipone16_12f;
                ppshiftinst_clip.outreg <= out10;
            end case;
          when working =>
            data_read_enable <= '1';
            weight_read_enable <= '1';
            memreg_c.datareg <= enable;
            memreg_c.weightreg <= enable;
            case e is
              when "00" =>
                inst <= matmul00;
                if l2_is_max = '1' then
                  ppshiftinst_addbias.acc <= negate;
                  ppshiftinst_addbias.quant <= trunc; --TODO
                end if;
              when "01" =>
                inst <= matmul01;
                if l2_is_max = '1' then
                  ppshiftinst_addbias.acc <= negate;
                  ppshiftinst_addbias.quant <= trunc; --TODO
                end if;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                inst <= matmul11;
                ppshiftinst_clip.outreg <= out10;
            end case;

            if l2 = 0 then
              ppinst <= fftsub1;-- first
            end if;
          when matmulhalf =>
            ppinst <= sum16left;
            ppshiftinst_addbias.acc <= negate;
            ppshiftinst_addbias.quant <= trunc; --TODO
            data_read_enable <= '1';
            weight_read_enable <= '1';
            memreg_c.datareg <= enable;
            memreg_c.weightreg <= enable;
            if e = 2 then
              inst <= matmul10; --inst <= matmul102;
              ppshiftinst_clip.outreg <= out32;
            else
              inst <= matmul11; --inst <= matmul112;
              ppshiftinst_clip.outreg <= out10;
            end if;
          when writing =>
            ppinst <= nop;
            ppshiftinst_shift.acce <= hold;
            ppshiftinst_clip.outreg <= none;
            data_read_enable <= '0';
            weight_read_enable <= '0';
            data_write_enable <= '1';
            weight_write_enable <= '0';
            writebuff_c.datareg <= enable;
            writebuff_c.weightreg <= enable;
          when others =>
            ppinst <= nop;
        end case;

      when others => --mult

        --TODO: possible optimization, use symmetric property along the diagonal

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
        ppshiftinst_shift <=
          (acce => enable,
          shift => 12,
          use_lod => '0',
          shift_dir => right);
        ppshiftinst_addbias <= (acc => pass,
          --quant => trunc);
          quant => round);
        ppshiftinst_clip <= (clip => clip16,
          outreg => out76);
        zpdata <= (others => '0');
        zpweight <= (others => '0');

        case state is
          when lidi =>
            case e is
              when "00" =>
                inst <= matmul00;
              when "01" =>
                inst <= matmul01;
                ppshiftinst_clip.outreg <= out32;
              when "10" =>
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out54;
              when others =>
                inst <= matmul11;
                ppshiftinst_clip.outreg <= out10;
            end case;

            if l2 = 0 then
              ppinst <= fftsub1;-- first
            end if;

            if e = 0 then
              data_read_enable <= '1';
              weight_read_enable <= '1';
              memreg_c.datareg <= enable;
              memreg_c.weightreg <= enable;
            end if;

          when tmpli =>
            data_read_enable <= '1';
            weight_read_enable <= '1';
            memreg_c.datareg <= enable;
            memreg_c.weightreg <= enable;
            case e is
              when "00" =>
                inst <= matmul00;
              when "01" =>
                inst <= matmul01;
                ppshiftinst_clip.outreg <= out54;
              when "10" =>
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out32;
              when others =>
                inst <= matmul11;
                ppshiftinst_clip.outreg <= out10;
            end case;

            if l2 = 0 then
              ppinst <= fftsub1;-- first
            end if;
          when writing =>
            ppinst <= nop;
            ppshiftinst_shift.acce <= hold;
            ppshiftinst_clip.outreg <= none;
            data_read_enable <= '0';
            weight_read_enable <= '0';
            if prev_state = lidi then
              data_write_enable <= '0';
              weight_write_enable <= '1';
            else
              data_write_enable <= '1';
              weight_write_enable <= '0';
            end if;
            writebuff_c.datareg <= enable;
            writebuff_c.weightreg <= enable;
          when others =>
            ppinst <= nop;
        end case;
    end case;
  end process;

  ---------------------------------------------------------------------------

  process (state, e, nt, l2_is_max, l0, l1_is_max, l0_is_max)
  begin
    stall1 <= '0';
    stall2 <= '0';
    if (state = writing and e = 3 and l2_is_max = '1') then
      if (unsigned(nt) > 5 and l0 = 4 and l1_is_max = '1') then
        stall1 <= '1';
      end if;
      if (unsigned(nt) > 6 and l0 > 4 and l0_is_max /= '1') then
        stall2 <= '1';
      end if;
    end if;
  end process;

  --process (all)
  process (state, next_state, prev_state, i, e, instris0, instris1, instris2, stage, nt, stall1, stall2, l1_is_max, l1, l0_is_max)
  begin
    case stage is
      when ldl =>
        en_max <= x"0";
        if state = xSYTRF then
          if instris0 = '1' and e = "01" then
            en_max <= x"4";
          elsif (instris0 = '1' and e = "11") or (i = "011" and e = "10") or (i = "100" and (e = "00" or e = "10")) or i = "101" then
            en_max <= x"1";
          elsif (i = "100" and e = "11") then
            en_max <= x"2";
          end if;
        elsif state = writing then
          if prev_state = xSYTRF then
            if instris1 = '1' then
              en_max <= x"2";
            end if;
            if next_state = idle then
              en_max <= x"A";
            end if;
          elsif prev_state = xTRSM then
            if instris0 = '1' then
              en_max <= x"A";
            end if;
          else
            if instris0 = '1' or instris1 = '1' or (instris2 = '1' and next_state = xSYTRF) then
              en_max <= x"A";
            end if;
          end if;
        end if;
      when linv =>
        en_max <= x"0";
        if state = writing and l1_is_max = '1' and l1 = 1 and nt = "0010" then -- special case for 2x2 matrix
          en_max <= X"A";
        elsif stall1 = '1' then
          en_max <= X"A";
        elsif stall2 = '1' then
          en_max <= X"A";
        elsif state = writing and e = 2 then
          en_max <= X"A";
        elsif state = writing and next_state = idle then
          en_max <= x"A";
        end if;
      when mult =>
        en_max <= x"0";
        if state = writing and l0_is_max = '1' and l1_is_max = '1' then
          en_max <= x"A";
        end if;
        if state = writing and prev_state = tmpli and l0_is_max = '0' then --possible optimization
          en_max <= x"A";
        end if;
      when others => --idle
        en_max <= x"0";
    end case;

  end process;

  ---------------------------------------------------------------------------

  -- outputs
  data0_addr_o <= std_logic_vector(data_read_addr) when (data_write_enable /= '1')
    else std_logic_vector(data_write_addr);
  data1_addr_o <= data0_addr_o;
  weight_addr_o <= std_logic_vector(weight_read_addr) when (weight_write_enable /= '1')
    else std_logic_vector(weight_write_addr);
  bias_addr_o <= bias_addr;
  bias_addr_ctrl_o <= bias_addr_ctrl;
  data_read_enable_o <= data_read_enable;
  data_write_enable_o <= data_write_enable;
  weight_read_enable_o <= weight_read_enable;
  weight_write_enable_o <= weight_write_enable;
  bias_ren_o <= bias_ren;

  memreg_c_o <= memreg_c;
  writebuff_c_o <= writebuff_c;
  inst_o <= inst;
  ppinst_o <= ppinst;
  ppshiftinst_shift_o <= ppshiftinst_shift;
  ppshiftinst_addbias_o <= ppshiftinst_addbias;
  ppshiftinst_clip_o <= ppshiftinst_clip;
  lzod_o <= lzod;
  feedback_ctrl_o <= feedback_ctrl;
  zpdata_o <= zpdata;
  zpweight_o <= zpweight;

  en_max_o <= en_max when (en_i = '1') else (others => '0');

end architecture;
