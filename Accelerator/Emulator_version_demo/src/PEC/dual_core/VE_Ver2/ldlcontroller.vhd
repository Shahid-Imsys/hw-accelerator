
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
        nt : in std_logic_vector(4 downto 0) := "00010";--integer range 0 to 20 := 3;
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

architecture rtl of ldlcontroller is
    signal l_rows_tmp : unsigned(9 downto 0) := (others => '0');
    signal l_rows : unsigned(7 downto 0) := (others => '0');

    signal k : unsigned(4 downto 0) := (others => '0');--integer range 0 to nt := 0;
    signal i : unsigned(4 downto 0) := "00001";--integer range 0 to nt := 1;
    signal j : unsigned(4 downto 0) := "00001";--integer range 0 to nt := 1;
    signal r : unsigned(2 downto 0) := (others => '0');
    signal c : unsigned(1 downto 0) := (others => '0');
    signal k_ce : std_logic;
    signal i_ce : std_logic;
    signal j_ce : std_logic;
    signal r_ce : std_logic;
    signal c_ce : std_logic;
    signal k_reset : std_logic;
    signal i_reset : std_logic;
    signal j_reset : std_logic;
    signal r_reset : std_logic;
    signal c_reset : std_logic;
    signal r_max : unsigned(2 downto 0) := (others => '0');

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
    signal d_inv_addr : unsigned(7 downto 0);--integer range 0 to 255;
    signal last_addr : unsigned(7 downto 0);--integer range 0 to 255;

    type state_type is (xSYTRF,xTRSM,xSYDRK,xGEMDM,idle,writing);
    signal state : state_type := idle;
    signal next_state : state_type;
    signal prev_state : state_type;

    signal en_max : unsigned(3 downto 0);

    type addr_type is (a,l,d,di,last);
    signal data_read_addr : unsigned(7 downto 0);--integer;
    signal weight_read_addr : unsigned(7 downto 0);--integer;
    signal data_write_addr : unsigned(7 downto 0);--integer;
    signal weight_write_addr : unsigned(7 downto 0);--integer;
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

    signal kp1 : unsigned(4 downto 0);
    signal ip1 : unsigned(4 downto 0);
    signal jp1 : unsigned(4 downto 0);
    signal rp1 : unsigned(2 downto 0);
    signal cp1 : unsigned(1 downto 0);
    signal ntm1 : unsigned(4 downto 0);
    signal im1 : unsigned(4 downto 0);

    signal ris0 : std_logic;
    signal ris1 : std_logic;
    signal ris2 : std_logic;

begin

    kp1 <= k + 1;
    ip1 <= i + 1;
    jp1 <= j + 1;
    rp1 <= r + 1;
    cp1 <= c + 1;
    ntm1 <= unsigned(nt) - 1;
    im1 <= i - 1;

    ris0 <= '1' when r = "000" else '0';
    ris1 <= '1' when r = "001" else '0';
    ris2 <= '1' when r = "010" else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if en_i = '1' then
                if k_reset = '1' then
                    k <= (others => '0'); -- 0 due to zero indexing
                elsif k_ce = '1' then
                    k <= kp1;
                end if;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en_i = '1' then
                if i_reset = '1' then
                    i <= kp1;
                elsif i_ce = '1' then
                    i <= ip1;
                end if;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en_i = '1' then
                if j_reset = '1' then
                    j <= kp1;
                elsif j_ce = '1' then
                    j <= jp1;
                end if;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en_i = '1' then
                if r_reset = '1' then
                    r <= (others => '0');
                elsif r_ce = '1' then
                    r <= rp1;
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
                else
                    c <= cp1;
                end if;
            end if;
        end if;
    end process;

    -- next state process
    --process (all)
    process (state, prev_state, k, i, j, r, c, start, ris1, ris2, ntm1, kp1, im1)
    begin
        next_state <= state;
        if state = xSYTRF then -- xSYTRF
            if (c = "11" and (ris1 = '1' or ris2 = '1')) or r = "110" then
                next_state <= writing;
            end if;
        elsif state = xTRSM then -- xTRSM
            if c = "11" then
                next_state <= writing;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if c = "11" then
                next_state <= writing;
            end if;
        elsif state = xGEMDM then -- xGEMDM
            if c = "11" then
                next_state <= writing;
            end if;
        elsif state = writing then
            if prev_state = xSYTRF then
                if r = "110" then
                    if k = ntm1 then
                        done <= '1';
                        next_state <= idle;
                    else
                        next_state <= xTRSM;
                    end if;
                else
                    next_state <= xSYTRF;
                end if;
            elsif prev_state = xTRSM then
                if ris1 = '1' and i = ntm1 then
                    next_state <= xSYDRK;
                else
                    next_state <= xTRSM;
                end if;
            elsif prev_state = xSYDRK then
                if ris2 = '1' then
                    if i > kp1 then
                        next_state <= xGEMDM;
                    elsif i = ntm1 then
                        next_state <= xSYTRF;
                    else
                        next_state <= xSYDRK;
                    end if;
                else
                    next_state <= xSYDRK;
                end if;
            else
                if ris2 = '1' then
                    if j = im1 then
                        if i = ntm1 then
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

    with prev_state select
        r_max <= "110" when xSYTRF,
            "001" when xTRSM,
            "010" when xSYDRK,
            "010" when xGEMDM,
            "111" when others;


    -- counter control
    --process (all)
    process (state, next_state, prev_state, r, c, r_max, start, ris0, ris1, ris2)
    begin
        k_ce <= '0';
        i_ce <= '0';
        j_ce <= '0';
        r_ce <= '0';
        c_ce <= '1';
        k_reset <= '0';
        i_reset <= '0';
        j_reset <= '0';
        r_reset <= '0';
        c_reset <= '0';

        if state = xSYTRF then -- xSYTRF
            if
            (ris0 = '1' and c = "11") or (r = "011" and c = "11") or
            (r = "100" and c = "11") or r = "101" then
                r_ce <= '1';
                c_reset <= '1';
            end if;
        elsif state = writing then
            if prev_state = xSYTRF then
                if next_state = xTRSM then
                    i_reset <= '1';
                end if;
            elsif prev_state = xTRSM and ris1 = '1' then
                if next_state = xTRSM then
                    i_ce <= '1';
                else -- next_state = xSYDRK
                    i_reset <= '1';
                end if;
            elsif prev_state = xSYDRK and ris2 = '1' then
                if next_state = xSYTRF then
                    k_ce <= '1';
                elsif next_state = xSYDRK then
                    i_ce <= '1';
                else -- next_state = xGEMDM
                    j_reset <= '1';
                end if;
            elsif prev_state = xGEMDM and ris2 = '1' then
                if next_state = xSYTRF then
                    k_ce <= '1';
                elsif next_state = xSYDRK then
                    i_ce <= '1';
                else -- next_state = xGEMDM
                    j_ce <= '1';
                end if;
            end if;
            if r = r_max then
                r_reset <= '1';
            else
                r_ce <= '1';
            end if;
            c_reset <= '1';
        else -- idle
            if start = '1' then
                k_reset <= '1';
                i_reset <= '1';
                j_reset <= '1';
                r_reset <= '1';
                c_reset <= '1';
            end if;
        end if;
    end process;

    -- address select control
    --process (all)
    process (state, prev_state, r, ris0, ris1)
    begin
        data_read_addr_sel <= a;
        weight_read_addr_sel <= last;
        data_write_addr_sel <= last;
        weight_write_addr_sel <= last;
        a_addr_sel <= kk;
        l_addr_sel <= kk;
        if state = xSYTRF then -- xSYTRF
            data_read_addr_sel <= a;
            a_addr_sel <= kk;
        elsif state = xTRSM then -- xTRSM
            if ris0 = '1' then        -- 4 cycles, Aik*Lkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= l;
                a_addr_sel <= ik;
                l_addr_sel <= kk;
            else                                -- 4 cycles, tmp*d_inv
                data_read_addr_sel <= last;
                weight_read_addr_sel <= di;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if ris0 = '1' then           -- 4 cycles, Aik*Lkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= l;
                a_addr_sel <= ik;
                l_addr_sel <= kk;
            elsif ris1 = '1' then -- 4 cycles, tmp*Lik, W*D
                data_read_addr_sel <= last;
                weight_read_addr_sel <= l;
                l_addr_sel <= ik;
            else                                -- matsub
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                a_addr_sel <= ii;
            end if;
        elsif state  = xGEMDM then -- xGEMDM
            if ris0 = '1' then           -- 4 cycles, Aik*Lkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= l;
                a_addr_sel <= ik;
                l_addr_sel <= kk;
            elsif ris1 = '1' then        -- 4 cycles, tmp*Ljk, D*W
                data_read_addr_sel <= last;
                weight_read_addr_sel <= l;
                l_addr_sel <= jk;
            else                                -- matsub
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                a_addr_sel <= ij;
            end if;
        elsif state = writing then
            if prev_state = xSYTRF then
                case r is
                    when "001" =>
                        weight_write_addr_sel <= l;
                        l_addr_sel <= kk;
                    when "010" =>
                        weight_write_addr_sel <= d;
                    when others =>
                        weight_write_addr_sel <= di;
                end case;
            elsif prev_state = xTRSM then
                if ris0 = '1' then        -- 4 cycles, Aik*Lkk
                    data_write_addr_sel <= last;
                else                                -- 4 cycles, tmp*d_inv
                    weight_write_addr_sel <= l;
                    l_addr_sel <= ik;
                end if;
            elsif prev_state = xSYDRK then
                if ris0 = '1' then           -- 4 cycles, Aik*Lkk
                    data_write_addr_sel <= last;
                elsif ris1 = '1' then -- 4 cycles, tmp*Lik, W*D
                    weight_write_addr_sel <= last;
                else                                -- matsub
                    data_write_addr_sel <= a;
                    a_addr_sel <= ii;
                end if;
            else -- prev_state = xGEMDM
                if ris0 = '1' then           -- 4 cycles, Aik*Lkk
                    data_write_addr_sel <= last;
                elsif ris1 = '1' then        -- 4 cycles, tmp*Ljk, D*W
                    weight_write_addr_sel <= last;
                else                                -- matsub
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
    end process;

    -- addresses
    --l_rows_tmp <= unsigned(nt)*(1+unsigned(nt));
    l_rows_tmp <= unsigned(nt)*unsigned(nt)+unsigned(nt);
    l_rows <= l_rows_tmp(8 downto 1);

    --a_addr_tmp <= a_row*(a_row+1);
    a_addr_tmp <= a_row*a_row+a_row;
    a_addr <= a_addr_tmp(8 downto 1) + a_col;

    --l_addr_tmp <= l_row*(l_row+1);
    l_addr_tmp <= l_row*l_row+l_row;
    l_addr <= l_addr_tmp(8 downto 1) + l_col;

    d_addr <= k + l_rows;
    d_inv_addr <= d_addr + unsigned(nt);
    last_addr <= x"FF";

    with a_addr_sel select
        a_row <= k when kk,
                 i when others;

    with a_addr_sel select
        a_col <= k when kk,
                 k when ik,
                 i when ii,
                 j when others;


    with l_addr_sel select
        l_row <= k when kk,
                 i when ik,
                 j when others;

    l_col <= k;

    -- remove unneccesary addresses
    with data_read_addr_sel select
        data_read_addr <=   a_addr when a,
                            last_addr when others;

    with weight_read_addr_sel select
        weight_read_addr <= a_addr when a,
                            l_addr when l,
                            d_inv_addr when di,
                            last_addr when others;

    with data_write_addr_sel select
        data_write_addr <=  a_addr when a,
                            last_addr when others;

    with weight_write_addr_sel select
        weight_write_addr <= a_addr when a,
                             l_addr when l,
                             d_addr when d,
                             d_inv_addr when di,
                             last_addr when others;

    bias_addr <= (others => '0');


    -- instructions
    --process (all)
    process (state, prev_state, r, c, ris0, ris1)
    begin
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
            (acce      => enable,
             shift     => 8,
             use_lod    => '0',
             shift_dir => right);

        ppshiftinst_addbias <=
            (acc       => pass,
             quant     => trunc); -- TODO: trunc eller round, trunc verkar bättre, kanske ska vara round på fler ställen?

        ppshiftinst_clip <=
            (clip      => clip16,
             outreg    => none);

        lzod <= (word => "00", store => none, output => none);
        feedback_ctrl <= keep;

        zpdata <= (others => '0');
        zpweight <= (others => '0');

        if state = xSYTRF then -- xSYTRF
            case r is
                when "000" =>
                    case c is
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
                    case c is
                        when "00" =>
                            ppinst <= nop;
                            ppshiftinst_clip.clip <= clipone16;
                            ppshiftinst_clip.outreg <= out76;
                        when "01" =>
                            ppinst <= nop;
                            ppshiftinst_clip.clip <= clipzero;
                            ppshiftinst_clip.outreg <= out54;
                        when "10" =>
                            ppinst <= nop;
                            ppshiftinst_clip.clip <= clipone16;
                            ppshiftinst_clip.outreg <= out10;
                        when others =>
                            inst <= nrit;
                            ppinst <= nrit;
                            ppshiftinst_shift <= (acce => enable, shift => 8, use_lod => '1', shift_dir => right);
                            ppshiftinst_addbias <= (acc => pass, quant => round); -- TODO: trunc eller round vid division?
                            ppshiftinst_clip <= (clip => clip16, outreg => out32);
                            lzod <= (word => "11", store => none, output => nrit);
                            feedback_ctrl <= clip_to_1;
                    end case;
                when "010" =>
                    case c is
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
                    case c is
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
                    case c is
                        when "00" =>
                            --normalize d(4)
                            bias_addr_ctrl <= shift;
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
                    ppshiftinst_addbias <= (acc => pass, quant => round); -- TODO: trunc eller round vid division?
                    ppshiftinst_clip <= (clip => clip16, outreg => out10);
                --when "01111" =>
                when others =>
                    -- calc it2
                    inst <= nrit;
                    ppinst <= nrit;
                    ppshiftinst_shift.use_lod <= '1';
                    lzod <= (word => "11", store => none, output => nrit2);
                    ppshiftinst_addbias <= (acc => pass, quant => round); -- TODO: trunc eller round vid division?
                    ppshiftinst_clip <= (clip => clip16, outreg => out76);
            end case;
        elsif state = xTRSM then -- xTRSM
            if ris0 = '1' then        -- 4 cycles, Aik*Lkk
                inst <= unitri1;
                ppinst <= select6;
                case c is
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
            else                                -- 4 cycles, tmp*d_inv
                inst <= matmul00;
                case c is
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
            if ris0 = '1' then        -- 4 cycles, Aik*Lkk
                inst <= unitri1;
                ppinst <= select6;
                case c is
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
            elsif ris1 = '1' then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul00t; -- matmul_t
                -- TODO: result from this is often too big
                case c is
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
            else                                -- matsub
                -- TODO: result from this is often too small, due to previous result
                inst <= matsub;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 7;
                ppshiftinst_addbias <= (acc => pass, quant => round); -- TODO: to slightly increase result
                case c is
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
        elsif state  = xGEMDM then -- xGEMDM
            if ris0 = '1' then        -- 4 cycles, Aik*Lkk
                inst <= unitri1;
                ppinst <= select6;
                case c is
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
            elsif ris1 = '1' then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul00t; -- matmul_t
                case c is
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
            else                                -- matsub
                inst <= matsub;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 7;
                case c is
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
                    case r is
                        when "001" =>
                            weight_write_enable <= '1';
                        when "010" =>
                            weight_write_enable <= '1';
                        --when "01111" =>
                        when others =>
                            weight_write_enable <= '1';
                    end case;
                when xTRSM =>
                    case r is
                        when "000" =>
                            data_write_enable <= '1';
                        when others =>
                            weight_write_enable <= '1';
                    end case;
                when xSYDRK =>
                    case r is
                        when "000" =>
                            data_write_enable <= '1';
                        when "001" =>
                            weight_write_enable <= '1';
                        when others =>
                            data_write_enable <= '1';
                    end case;
                when others => -- xGEMDM
                    case r is
                        when "000" =>
                            data_write_enable <= '1';
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
    end process;

    ---------------------------------------------------------------------------
    -- TODO add delay depending on data dependecies when testing for functionality

  --process (all)
  process (state, next_state, prev_state, r, c, ris0, ris1, ris2)
  begin
    en_max <= x"0";
    if state = xSYTRF then
        if ris0 = '1' and c = "01" then
            en_max <= x"4";
        elsif (ris0 = '1' and c = "11") or (r = "011" and c = "10") or (r = "100" and (c = "00" or c = "10")) or r = "101" then
            en_max <= x"1";
        elsif (r = "100" and c = "11") then
            en_max <= x"2";
        end if;
    elsif state = writing then
        if prev_state = xSYTRF then
            if ris1 = '1' then
                en_max <= x"2";
            end if;
        elsif prev_state = xTRSM then
            if ris0 = '1' then
                en_max <= x"A";
            end if;
        elsif prev_state = xSYDRK then
            if ris0 = '1' or ris1 = '1' or (ris2 = '1' and next_state = xSYTRF) then
                en_max <= x"A";
            end if;
        --elsif prev_state = xGEMDM then
        else
            if ris0 = '1' or ris1 = '1' or (ris2 = '1' and next_state = xSYTRF) then
                en_max <= x"A";
            end if;
        end if;
    end if;
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
