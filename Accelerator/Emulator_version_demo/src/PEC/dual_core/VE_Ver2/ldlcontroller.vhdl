
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity ldlcontroller is
    port (
        clk : in std_logic;
        start : in std_logic;
        en_i : in std_logic;
        nt : in std_logic_vector(4 downto 0);--integer range 0 to 20 := 3;
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
        ppshiftinst_shift_o : out ppshift_shift_ctrl;
        ppshiftinst_addbias_o : out ppshift_addbias_ctrl;
        ppshiftinst_clip_o : out ppshift_clip_ctrl;
        zpdata_o : out std_logic_vector(7 downto 0);
        zpweight_o : out std_logic_vector(7 downto 0);
        bias_o : out std_logic_vector(63 downto 0);

        en_max_o : out unsigned(3 downto 0)
    );
end entity;

-------------------------------------------------------------------------------
-- TODO: data/weight_read/write_enable, memreg_c/writebuff_c, en_max
-------------------------------------------------------------------------------

architecture rtl of ldlcontroller is
    constant l_rows : unsigned(7 downto 0) := x"D2";

    signal k : unsigned(4 downto 0) := (others => '0');--integer range 0 to nt := 0;
    signal i : unsigned(4 downto 0) := "00001";--integer range 0 to nt := 1;
    signal j : unsigned(4 downto 0) := "00001";--integer range 0 to nt := 1;
    signal k_ce : std_logic;
    signal i_ce : std_logic;
    signal j_ce : std_logic;
    signal k_reset : std_logic;
    signal i_reset : std_logic;
    signal j_reset : std_logic;

    type a_addr_type is (kk,ik,ii,ij);
    signal a_addr : unsigned(7 downto 0);--integer  range 0 to 255;
    signal a_addr_tmp : unsigned(9 downto 0);--integer  range 0 to 255;
    signal a_row : unsigned(4 downto 0);--integer  range 0 to 255;
    signal a_col : unsigned(4 downto 0);--integer  range 0 to 255;
    signal a_addr_sel : a_addr_type;
    type l_addr_type is (kk,ik,jk);
    signal l_addr : unsigned(7 downto 0);--integer range 0 to 255;
    signal l_addr_tmp : unsigned(9 downto 0);--integer range 0 to 255;
    signal l_row : unsigned(4 downto 0);--integer range 0 to 255;
    signal l_col : unsigned(4 downto 0);--integer range 0 to 255;
    signal l_addr_sel : l_addr_type;
    signal d_addr : unsigned(7 downto 0);--integer range 0 to 255;
    signal last_addr : unsigned(7 downto 0);--integer range 0 to 255;

    type state_type is (xSYTRF,xTRSM,xSYDRK,xGEMDM,idle);
    signal state : state_type := idle;
    signal next_state : state_type;
    signal prev_state : state_type;
    signal state_counter : integer;
    signal state_counter_reset : std_logic;
    signal state_counter_max : integer;

    signal en_max : unsigned(3 downto 0);

    type addr_type is (a,l,d,last);
    signal data_read_addr : unsigned(7 downto 0);--integer;
    signal weight_read_addr : unsigned(7 downto 0);--integer;
    signal data_write_addr : unsigned(7 downto 0);--integer;
    signal weight_write_addr : unsigned(7 downto 0);--integer;
    signal data_read_addr_sel : addr_type;
    signal weight_read_addr_sel : addr_type;
    signal data_write_addr_sel : addr_type;
    signal weight_write_addr_sel : addr_type;
    signal data_read_enable : std_logic;
    signal data_write_enable : std_logic;
    signal weight_read_enable : std_logic;
    signal weight_write_enable : std_logic;

    signal memreg_c : memreg_ctrl;
    signal writebuff_c : memreg_ctrl;
    signal inst : instruction;
    signal ppinst : ppctrl_t;
    signal ppshiftinst_shift : ppshift_shift_ctrl;
    signal ppshiftinst_addbias : ppshift_addbias_ctrl;
    signal ppshiftinst_clip : ppshift_clip_ctrl;
    signal zpdata : std_logic_vector(7 downto 0);
    signal zpweight : std_logic_vector(7 downto 0);
    signal bias : std_logic_vector(63 downto 0);
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if k_reset = '1' then
                -- k <= 1; -- 1 due to one indexing
                k <= (others => '0'); -- 0 due to zero indexing
            elsif k_ce = '1' then
                k <= k + 1;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if i_reset = '1' then
                i <= k + 1;
            elsif i_ce = '1' then
                i <= i + 1;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if j_reset = '1' then
                j <= k + 1;
            elsif j_ce = '1' then
                j <= j + 1;
            end if;
        end if;
    end process;

    -- next state process
    process (all)
    begin
        if state = xSYTRF then -- xSYTRF
            if state_counter = state_counter_max then
                if k = unsigned(nt) then
                    done <= '1';
                    -- go to wait state
                    next_state <= idle;
                else
                    next_state <= xTRSM;
                end if;
            else
                next_state <= state;
            end if;
        elsif state = xTRSM then -- xTRSM
            if state_counter = state_counter_max then
                if i = unsigned(nt) then
                    next_state <= xSYDRK;
                end if;
            else
                next_state <= state;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if state_counter = state_counter_max then
                if i > k+1 then
                    next_state <= xGEMDM;
                elsif i = unsigned(nt) then
                    next_state <= xSYTRF;
                end if;
            else
                next_state <= state;
            end if;
        elsif state = xGEMDM then -- xGEMDM
            if state_counter = state_counter_max then
                if j = i-1 then
                    if i = unsigned(nt) then
                        next_state <= xSYTRF;
                    else
                        next_state <= xSYDRK;
                    end if;
                end if;
            else
                next_state <= state;
            end if;
        else -- idle
            if start = '1' then
                next_state <= xSYTRF;
            else
                next_state <= state;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if state_counter_reset = '1' then
                state_counter <= 0;
            else
                state_counter <= state_counter + 1;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
            prev_state <= state;
        end if;
    end process;

    -- counter control
    process (all)
    begin
        k_ce <= '0';
        i_ce <= '0';
        j_ce <= '0';
        k_reset <= '0';
        i_reset <= '0';
        j_reset <= '0';
        state_counter_reset <= '0';
        if state = xSYTRF then -- xSYTRF
            if state_counter = state_counter_max then
                if next_state = xTRSM then
                    i_reset <= '1';
                    state_counter_reset <= '1';
                else
                    state_counter_reset <= '1';
                end if;
            end if;
        elsif state = xTRSM then -- xTRSM
            if state_counter = state_counter_max then
                if next_state = xSYDRK then
                    i_reset <= '1';
                    state_counter_reset <= '1';
                else
                    i_ce <= '1';
                    state_counter_reset <= '1';
                end if;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if state_counter = state_counter_max then
                if next_state = xGEMDM then
                    j_reset <= '1';
                    state_counter_reset <= '1';
                elsif next_state = xSYTRF then
                    k_ce <= '1';
                    state_counter_reset <= '1';
                else
                    i_ce <= '1';
                    state_counter_reset <= '1';
                end if;
            end if;
        elsif state = xGEMDM then -- xGEMDM
            if state_counter = state_counter_max then
                if next_state = xSYTRF then
                    k_ce <= '1';
                    state_counter_reset <= '1';
                elsif next_state = xSYDRK then
                    i_ce <= '1';
                    state_counter_reset <= '1';
                else
                    j_ce <= '1';
                    state_counter_reset <= '1';
                end if;
            end if;
        else -- idle
            if start = '1' then
                k_reset <= '1';
                i_reset <= '1';
                j_reset <= '1';
                state_counter_reset <= '1';
            end if;
        end if;
    end process;

    -- address select control
    process (all)
    begin
        if state = xSYTRF then -- xSYTRF
            if state_counter = 0 then
                data_read_addr_sel <= a;
                weight_write_addr_sel <= last;
                a_addr_sel <= kk;
            elsif state_counter >= 1 and state_counter < 5 then        -- 4 cycles, set Lkk
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= l;
                l_addr_sel <= kk;
            else                                -- 4 cycles, set Dkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= d;
                a_addr_sel <= kk;
            end if;
        elsif state = xTRSM then -- xTRSM
            if state_counter >= 0 and state_counter < 4 then
                weight_read_addr_sel <= d;
                data_write_addr_sel <= last;
            elsif state_counter >= 4 and state_counter < 6 then
                data_read_addr_sel <= last;
                data_write_addr_sel <= last;
            elsif state_counter >= 6 and state_counter < 10 then        -- 4 cycles, set d_inv
                data_read_addr_sel <= last;
                weight_read_addr_sel <= d;
                weight_write_addr_sel <= last;
            elsif state_counter >= 10 and state_counter < 14 then        -- 4 cycles, Aik*Lkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= l;
                data_write_addr_sel <= last;
                a_addr_sel <= ik;
                l_addr_sel <= kk;
            else                                -- 4 cycles, tmp*d_inv
                data_read_addr_sel <= last;
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= l;
                l_addr_sel <= ik;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if state_counter = 0 then           -- probably 1 cycle, from W to D
                weight_read_addr_sel <= l;
                data_write_addr_sel <= last;
                l_addr_sel <= ik;
            elsif state_counter >= 1 and state_counter < 5 then        -- 4 cycles, Lik*Dkk
                data_read_addr_sel <= last;
                weight_read_addr_sel <= d;
                weight_write_addr_sel <= last;
            elsif state_counter >= 5 and state_counter < 9 then        -- 4 cycles, tmp*Lik, W*D
                data_read_addr_sel <= last;
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= last;
            else                                -- matsub
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= a;
                a_addr_sel <= ii;
            end if;
        elsif state  = xGEMDM then -- xGEMDM
            if state_counter = 0 then           -- probably 1 cycle, from W to D
                weight_read_addr_sel <= l;
                data_write_addr_sel <= last;
                l_addr_sel <= ik;
            elsif state_counter >= 1 and state_counter < 5 then        -- 4 cycles, Lik*Dkk
                data_read_addr_sel <= last;
                weight_read_addr_sel <= d;
                data_write_addr_sel <= last;
            elsif state_counter >= 5 and state_counter < 9 then        -- 4 cycles, tmp*Ljk, D*W
                data_read_addr_sel <= last;
                weight_read_addr_sel <= l;
                weight_write_addr_sel <= last;
                l_addr_sel <= jk;
            else                                -- matsub
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                data_write_addr_sel <= a;
                a_addr_sel <= ij;
            end if;
        else -- idle, prepare for start
            data_read_addr_sel <= a;
            weight_read_addr_sel <= last;
            data_write_addr_sel <= last;
            weight_write_addr_sel <= last;
            a_addr_sel <= kk;
            l_addr_sel <= kk;
        end if;
    end process;

    -- addresses
    a_addr_tmp <= a_row*unsigned(nt) + a_col;
    a_addr <= a_addr_tmp(7 downto 0);
    l_addr_tmp <= l_row*(l_row+1)/2 + l_col;
    l_addr <= l_addr_tmp(7 downto 0);
    d_addr <= k + l_rows;
    last_addr <= x"FF";

    with a_addr_sel select
        a_row <= k when kk,
                 i when ik,
                 i when ii,
                 i when ij,
                 (others => '0') when others;

    with a_addr_sel select
        a_col <= k when kk,
                 k when ik,
                 i when ii,
                 j when ij,
                 (others => '0') when others;


    with l_addr_sel select
        l_row <= k when kk,
                 i when ik,
                 j when jk,
                 (others => '0') when others;

    with l_addr_sel select
        l_col <= k when kk,
                 k when ik,
                 k when jk,
                 (others => '0') when others;

    -- remove unneccesary addresses
    with data_read_addr_sel select
        data_read_addr <=   a_addr when a,
                            l_addr when l,
                            d_addr when d,
                            last_addr when last,
                            (others => '0') when others;

    with weight_read_addr_sel select
        weight_read_addr <= a_addr when a,
                            l_addr when l,
                            d_addr when d,
                            last_addr when last,
                            (others => '0') when others;

    with data_write_addr_sel select
        data_write_addr <=  a_addr when a,
                            l_addr when l,
                            d_addr when d,
                            last_addr when last,
                            (others => '0') when others;

    with weight_write_addr_sel select
        weight_write_addr <= a_addr when a,
                             l_addr when l,
                             d_addr when d,
                             last_addr when last,
                             (others => '0') when others;


    -- instructions
    process (all)
    begin
        data_read_enable <= '0';
        data_write_enable <= '0';
        weight_read_enable <= '0';
        weight_write_enable <= '0';

        memreg_c <= (swap => noswap,
            datareg => hold,
            weightreg => hold);
        writebuff_c <= (swap => noswap,
            datareg => hold,
            weightreg => hold);

        ppinst <= fftsub1;
        ppshiftinst_shift <=
            (acce      => enable,
             shift     => 8,
             shift_dir => right);

        ppshiftinst_addbias <=
            (acc       => pass,
             quant     => unbiased);

        ppshiftinst_clip <=
            (clip      => clip16,
             outreg    => out10);

        zpdata <= (others => '0');
        zpweight <= (others => '0');
        bias <= (others => '0');

        if state = xSYTRF then -- xSYTRF -- TODO
            if state_counter = 0 then
                -- inst <= division;
                ppinst <= select0;
                ppshiftinst_shift.shift <= 16;
            elsif state_counter = 1 then        -- 4 cycles, set Lkk
                -- inst <= feed_through; -- unitri1/3 ?
                ppinst <= select0;
                ppshiftinst_shift.shift <= 16;
            else                                -- 4 cycles, set Dkk
                -- inst <= feed_through; -- unitri1/3 ?
                -- inst <= unispec;
                ppshiftinst_shift.shift <= 16;
            end if;
        elsif state = xTRSM then -- xTRSM
            if state_counter = 0 then
                inst <= matdet;
                ppinst <= fftsub0;
                ppshiftinst_shift.shift <= 0;
            elsif state_counter = 1 then
                --inst <= division;
                ppinst <= select0;
                ppshiftinst_shift.shift <= 16;
            elsif state_counter = 2 then        -- 4 cycles, set d_inv
                inst <= matmul00; -- matmul_diag
                ppshiftinst_shift.shift <= 16;
            elsif state_counter = 3 then        -- 4 cycles, Aik*Lkk
                inst <= unitri1;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 7;
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 4 then        -- 4 cycles, Aik*Lkk
                inst <= unitri2;
                ppinst <= unitri;
                ppshiftinst_shift.shift <= 7;
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 5 then        -- 4 cycles, Aik*Lkk
                inst <= unitri3;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 7;
                ppshiftinst_clip.outreg <= out32;
            elsif state_counter = 6 then        -- 4 cycles, Aik*Lkk
                inst <= unitri4;
                ppinst <= unitri;
                ppshiftinst_shift.shift <= 7;
            elsif state_counter = 7 then        -- 4 cycles, tmp*d_inv
                inst <= matmul00;
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 8 then        -- 4 cycles, tmp*d_inv
                inst <= matmul01;
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 9 then        -- 4 cycles, tmp*d_inv
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out32;
            else                                -- 4 cycles, tmp*d_inv
                inst <= matmul11;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if state_counter = 0 then           -- probably 1 cycle, from W to D
                -- inst <= feed_through;    -- or nop?
                ppinst <= select0;
                ppshiftinst_shift.shift <= 16;
            elsif state_counter = 1 then        -- 4 cycles, Lik*Dkk
                inst <= matmul00;
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 2 then        -- 4 cycles, Lik*Dkk
                inst <= matmul01;
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 3 then        -- 4 cycles, Lik*Dkk
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out32;
            elsif state_counter = 4 then        -- 4 cycles, Lik*Dkk
                inst <= matmul11;
            elsif state_counter = 5 then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul00t; -- matmul_t
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 6 then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul01t; -- matmul_t
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 7 then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul10t; -- matmul_t
                ppshiftinst_clip.outreg <= out32;
            elsif state_counter = 8 then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul11t; -- matmul_t
            elsif state_counter = 9 then             -- matsub
                inst <= matsub;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 0;
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 10 then             -- matsub
                inst <= matsub;
                ppinst <= select4;
                ppshiftinst_shift.shift <= 0;
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 11 then             -- matsub
                inst <= matsub;
                ppinst <= select2;
                ppshiftinst_shift.shift <= 0;
                ppshiftinst_clip.outreg <= out32;
            else                                -- matsub
                inst <= matsub;
                ppinst <= select0;
                ppshiftinst_shift.shift <= 0;
            end if;
        elsif state  = xGEMDM then -- xGEMDM
            if state_counter = 0 then           -- probably 1 cycle, from W to D
                -- inst <= feed_through;
                ppinst <= select0;
                ppshiftinst_shift.shift <= 16;
            elsif state_counter = 1 then        -- 4 cycles, Lik*Dkk
                inst <= matmul00;
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 2 then        -- 4 cycles, Lik*Dkk
                inst <= matmul01;
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 3 then        -- 4 cycles, Lik*Dkk
                inst <= matmul10;
                ppshiftinst_clip.outreg <= out32;
            elsif state_counter = 4 then        -- 4 cycles, Lik*Dkk
                inst <= matmul11;
            elsif state_counter = 5 then        -- 4 cycles, tmp*Ljk, D*W
                inst <= matmul00t; -- matmul_t
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 6 then        -- 4 cycles, tmp*Ljk, D*W
                inst <= matmul01t; -- matmul_t
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 7 then        -- 4 cycles, tmp*Ljk, D*W
                inst <= matmul10t; -- matmul_t
                ppshiftinst_clip.outreg <= out32;
            elsif state_counter = 8 then        -- 4 cycles, tmp*Ljk, D*W
                inst <= matmul11t; -- matmul_t
            elsif state_counter = 9 then             -- matsub
                inst <= matsub;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 0;
                ppshiftinst_clip.outreg <= out76;
            elsif state_counter = 10 then             -- matsub
                inst <= matsub;
                ppinst <= select4;
                ppshiftinst_shift.shift <= 0;
                ppshiftinst_clip.outreg <= out54;
            elsif state_counter = 11 then             -- matsub
                inst <= matsub;
                ppinst <= select2;
                ppshiftinst_shift.shift <= 0;
                ppshiftinst_clip.outreg <= out32;
            else                                -- matsub
                inst <= matsub;
                ppinst <= select0;
                ppshiftinst_shift.shift <= 0;
            end if;
        else -- idle, prepare for start
            inst <= nop;
            ppinst <= nop;
            ppshiftinst_shift.shift <= 16;
        end if;
    end process;

    with state select
        state_counter_max <= 8 when xSYTRF,
                             17 when xTRSM,
                             12 when xSYDRK,
                             12 when xGEMDM,
                             0 when others;

    ---------------------------------------------------------------------------

  process (all)
  begin
    en_max <= x"0";
  end process;

  ---------------------------------------------------------------------------

    -- outputs
    --data0_addr_o <= std_logic_vector(data_read_addr) when (data_write_enable /= '1')
    --    else std_logic_vector(data_write_addr);
    data0_addr_o <= std_logic_vector(data_read_addr) when (data_write_enable /= '1')
                        else std_logic_vector(data_write_addr);
    data1_addr_o <= data0_addr_o;
    weight_addr_o <= std_logic_vector(weight_read_addr) when (weight_write_enable /= '1')
                        else std_logic_vector(weight_write_addr);
    data_read_enable_o <= data_read_enable;
    data_write_enable_o <= data_write_enable;
    weight_read_enable_o <= weight_read_enable;
    weight_write_enable_o <= weight_write_enable;

    memreg_c_o <= memreg_c;
    writebuff_c_o <= writebuff_c;
    inst_o <= inst;
    ppinst_o <= ppinst;
    ppshiftinst_shift_o <= ppshiftinst_shift;
    ppshiftinst_addbias_o <= ppshiftinst_addbias;
    ppshiftinst_clip_o <= ppshiftinst_clip;
    zpdata_o <= zpdata;
    zpweight_o <= zpweight;
    bias_o <= bias;

    en_max_o <= en_max;

end architecture;
