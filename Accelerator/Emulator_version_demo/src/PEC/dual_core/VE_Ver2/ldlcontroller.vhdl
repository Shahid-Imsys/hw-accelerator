
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
        nt : in std_logic_vector(4 downto 0) := "00011";--integer range 0 to 20 := 3;
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
        bias_o : out std_logic_vector(31 downto 0);

        en_max_o : out unsigned(3 downto 0)
    );
end entity;

-------------------------------------------------------------------------------
-- TODO: data/weight_read/write_enable, memreg_c/writebuff_c, en_max
-------------------------------------------------------------------------------

architecture rtl of ldlcontroller is
    signal l_rows_tmp : unsigned(9 downto 0) := (others => '0');
    signal l_rows : unsigned(7 downto 0) := (others => '0');

    signal k : unsigned(4 downto 0) := (others => '0');--integer range 0 to nt := 0;
    signal i : unsigned(4 downto 0) := "00001";--integer range 0 to nt := 1;
    signal j : unsigned(4 downto 0) := "00001";--integer range 0 to nt := 1;
    signal r : unsigned(4 downto 0) := (others => '0');
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
    signal r_max : unsigned(4 downto 0) := (others => '0');

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
    signal bias : std_logic_vector(31 downto 0);
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if en_i = '1' then
                if k_reset = '1' then
                    k <= (others => '0'); -- 0 due to zero indexing
                elsif k_ce = '1' then
                    k <= k + 1;
                end if;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en_i = '1' then
                if i_reset = '1' then
                    i <= k + 1;
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
                    j <= k + 1;
                elsif j_ce = '1' then
                    j <= j + 1;
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

    -- next state process
    process (all)
    begin
        next_state <= state;
        if state = xSYTRF then -- xSYTRF
            if r = "00000" and c = "00" then
                next_state <= writing;
            elsif r = "00101" and c = "01" then
                next_state <= writing;
            elsif c = "11" then
                if r = "00110" and k = unsigned(nt)-1 then
                    done <= '1';
                    -- go to wait state
                    next_state <= idle;
                else
                    next_state <= writing;
                end if;
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
                if r = "00110" then
                    next_state <= xTRSM;
                else
                    next_state <= xSYTRF;
                end if;
            elsif prev_state = xTRSM then
                if r = "00001" and i = unsigned(nt)-1 then
                    next_state <= xSYDRK;
                else
                    next_state <= xTRSM;
                end if;
            elsif prev_state = xSYDRK then
                if r = "00011" then
                    if i > k+1 then
                        next_state <= xGEMDM;
                    elsif i = unsigned(nt)-1 then
                        next_state <= xSYTRF;
                    else
                        next_state <= xSYDRK;
                    end if;
                else
                    next_state <= xSYDRK;
                end if;
            elsif prev_state = xGEMDM then
                if r = "00011" then
                    if j = i-1 then
                        if i = unsigned(nt)-1 then
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
        r_max <= "00110" when xSYTRF,
            "00001" when xTRSM,
            "00011" when xSYDRK,
            "00011" when xGEMDM,
            "11111" when others;


    -- counter control
    process (all)
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
            if r = "00011" and c = "00" then
                r_ce <= '1';
                c_reset <= '1';
            end if;
        elsif state = xTRSM then -- xTRSM

        elsif state = xSYDRK then -- xSYDRK
            if r = "00000" and c = "00" then
                r_ce <= '1';
                c_reset <= '1';
            end if;

        elsif state = xGEMDM then -- xGEMDM
            if r = "00000" and c = "00" then
                r_ce <= '1';
                c_reset <= '1';
            end if;

        elsif state = writing then
            if prev_state = xSYTRF then
                if next_state = xTRSM then
                    i_reset <= '1';
                end if;
            elsif prev_state = xTRSM and r = "00001" then
                if next_state = xTRSM then
                    i_ce <= '1';
                else -- next_state = xSYDRK
                    i_reset <= '1';
                end if;
            elsif prev_state = xSYDRK and r = "00011" then
                if next_state = xSYTRF then
                    k_ce <= '1';
                elsif next_state = xSYDRK then
                    i_ce <= '1';
                else -- next_state = xGEMDM
                    j_reset <= '1';
                end if;
            elsif prev_state = xGEMDM and r = "00011" then
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
    process (all)
    begin
        if state = xSYTRF then -- xSYTRF
            if r = "00000" then
                data_read_addr_sel <= a;
                weight_write_addr_sel <= last;
                a_addr_sel <= kk;
            elsif r = "00001" then        -- 4 cycles, set Lkk
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= l;
                l_addr_sel <= kk;
            elsif r = "00010" then                               -- 4 cycles, set Dkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= d;
                a_addr_sel <= kk;
            elsif r = "00011" then
                weight_read_addr_sel <= a;
                data_write_addr_sel <= last;
                a_addr_sel <= kk;
            elsif r = "00100" then
                data_read_addr_sel <= last;
                data_write_addr_sel <= last;
            else
                data_read_addr_sel <= last;
                weight_read_addr_sel <= d;
                weight_write_addr_sel <= di;
            end if;
        elsif state = xTRSM then -- xTRSM
            if r = "00000" then        -- 4 cycles, Aik*Lkk
                data_read_addr_sel <= a;
                weight_read_addr_sel <= l;
                data_write_addr_sel <= last;
                a_addr_sel <= ik;
                l_addr_sel <= kk;
            else                                -- 4 cycles, tmp*d_inv
                data_read_addr_sel <= last;
                weight_read_addr_sel <= di;
                weight_write_addr_sel <= l;
                l_addr_sel <= ik;
            end if;
        elsif state = xSYDRK then -- xSYDRK
            if r = "00000" then           -- probably 1 cycle, from W to D
                weight_read_addr_sel <= l;
                l_addr_sel <= ik;
            elsif r = "00001" then        -- 4 cycles, Lik*Dkk
                weight_read_addr_sel <= d;
                weight_write_addr_sel <= last;
            elsif r = "00010" then        -- 4 cycles, tmp*Lik, W*D
                data_read_addr_sel <= last;
                weight_read_addr_sel <= last;
                weight_write_addr_sel <= last;
            else                                -- matsub
                data_read_addr_sel <= a;
                weight_read_addr_sel <= last;
                data_write_addr_sel <= a;
                a_addr_sel <= ii;
            end if;
        elsif state  = xGEMDM then -- xGEMDM
            if r = "00000" then           -- probably 1 cycle, from W to D
                weight_read_addr_sel <= l;
                l_addr_sel <= ik;
            elsif r = "00001" then        -- 4 cycles, Lik*Dkk
                weight_read_addr_sel <= d;
                data_write_addr_sel <= last;
            elsif r = "00010" then        -- 4 cycles, tmp*Ljk, D*W
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
        elsif state = writing then
            if prev_state = xSYTRF then
                if r = "00000" then
                    weight_write_addr_sel <= last;
                elsif r = "00001" then        -- 4 cycles, set Lkk
                    weight_write_addr_sel <= l;
                    l_addr_sel <= kk;
                elsif r = "00010" then                               -- 4 cycles, set Dkk
                    weight_write_addr_sel <= d;
                elsif r = "00011" then
                    data_write_addr_sel <= last;
                elsif r = "00100" then
                    data_write_addr_sel <= last;
                else
                    weight_write_addr_sel <= di;
                end if;
            elsif prev_state = xTRSM then
                if r = "00000" then        -- 4 cycles, Aik*Lkk
                    data_write_addr_sel <= last;
                else                                -- 4 cycles, tmp*d_inv
                    weight_write_addr_sel <= l;
                    l_addr_sel <= ik;
                end if;
            elsif prev_state = xSYDRK then
                if r = "00000" then           -- probably 1 cycle, from W to D
                elsif r = "00001" then        -- 4 cycles, Lik*Dkk
                    weight_write_addr_sel <= last;
                elsif r = "00010" then        -- 4 cycles, tmp*Lik, W*D
                    weight_write_addr_sel <= last;
                else                                -- matsub
                    weight_write_addr_sel <= a;
                    a_addr_sel <= ii;
                end if;
            else -- prev_state = xGEMDM
                if r = "00000" then           -- probably 1 cycle, from W to D
                elsif r = "00001" then        -- 4 cycles, Lik*Dkk
                    data_write_addr_sel <= last;
                elsif r = "00010" then        -- 4 cycles, tmp*Ljk, D*W
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
    l_rows_tmp <= unsigned(nt)*(1+unsigned(nt))/2;
    l_rows <= l_rows_tmp(7 downto 0);
    a_addr_tmp <= a_row*(a_row+1)/2 + a_col;
    a_addr <= a_addr_tmp(7 downto 0);
    l_addr_tmp <= l_row*(l_row+1)/2 + l_col;
    l_addr <= l_addr_tmp(7 downto 0);
    d_addr <= k + l_rows;
    d_inv_addr <= d_addr + unsigned(nt);
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
                            d_inv_addr when di,
                            last_addr when last,
                            (others => '0') when others;

    with weight_read_addr_sel select
        weight_read_addr <= a_addr when a,
                            l_addr when l,
                            d_addr when d,
                            d_inv_addr when di,
                            last_addr when last,
                            (others => '0') when others;

    with data_write_addr_sel select
        data_write_addr <=  a_addr when a,
                            l_addr when l,
                            d_addr when d,
                            d_inv_addr when di,
                            last_addr when last,
                            (others => '0') when others;

    with weight_write_addr_sel select
        weight_write_addr <= a_addr when a,
                             l_addr when l,
                             d_addr when d,
                             d_inv_addr when di,
                             last_addr when last,
                             (others => '0') when others;


    -- instructions
    process (all)
    begin
        data_read_enable <= '0';
        weight_read_enable <= '0';
        data_write_enable <= '0';
        weight_write_enable <= '0';

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
             shift_dir => right);

        ppshiftinst_addbias <=
            (acc       => pass,
             quant     => trunc);

        ppshiftinst_clip <=
            (clip      => clip16,
             outreg    => out76);

        zpdata <= (others => '0');
        zpweight <= (others => '0');
        bias <= (others => '0');

        if state = xSYTRF then -- xSYTRF -- TODO all instructions with new state control
            if r = "00000" then
                data_read_enable <= '1';
                memreg_c.datareg <= enable;
                -- inst <= division; -- TODO
                ppinst <= select6;
            elsif r = "00001" then        -- 4 cycles, set Lkk
                case c is
                    when "00" =>
                        weight_read_enable <= '1';
                        memreg_c.weightreg <= enable;
                        ppinst <= nop;
                        ppshiftinst_clip.clip <= clipone16;
                    when "01" =>
                        ppinst <= nop;
                        ppshiftinst_clip.clip <= clipzero;
                        ppshiftinst_clip.outreg <= out54;
                    when "10" =>
                        inst <= unitri1;
                        ppinst <= select6;
                        ppshiftinst_shift.shift <= 7;
                        ppshiftinst_clip.outreg <= out32;
                    when others => -- "11"
                        ppinst <= nop;
                        ppshiftinst_clip.clip <= clipone16;
                        ppshiftinst_clip.outreg <= out10;
                end case;
            elsif r = "00010" then                                -- 4 cycles, set Dkk
                case c is
                    when "00" =>
                        data_read_enable <= '1';
                        weight_read_enable <= '1';
                        memreg_c.datareg <= enable;
                        memreg_c.weightreg <= enable;
                        inst <= unitri1;
                        ppinst <= select6;
                        ppshiftinst_shift.shift <= 7;
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
                        ppinst <= select6;
                        ppshiftinst_shift.shift <= 7;
                        ppshiftinst_clip.outreg <= out10;
                end case;
            elsif r = "00011" then
                weight_read_enable <= '1';
                memreg_c.swap <= weighttodata;
                memreg_c.datareg <= enable;
                ppinst <= nop;
            elsif r = "00100" then
                inst <= matdet;
                ppinst <= fftsub0;
                ppshiftinst_shift.shift <= 0;
                case c is
                    when "00" =>
                    ppshiftinst_clip.outreg <= out76;
                    when "01" =>
                        ppshiftinst_clip.outreg <= out54;
                    when "10" =>
                        ppshiftinst_clip.outreg <= out32;
                    when others =>
                        ppshiftinst_clip.outreg <= out10;
                end case;
            elsif r = "00101" then
                --inst <= division; -- TODO
                ppinst <= select0;
                case c is
                    when "00" =>
                        data_read_enable <= '1';
                        memreg_c.datareg <= enable; -- TODO possibly need zeros in the middle
                    when others =>
                        ppshiftinst_clip.outreg <= out10;
                end case;
            else
                case c is
                    when "00" =>
                        data_read_enable <= '1';
                        weight_read_enable <= '1';
                        memreg_c.datareg <= enable;
                        memreg_c.weightreg <= enable;
                        inst <= matmul11; --d(4)*(1/det(a))
                    when "01" =>
                        ppinst <= nop;
                        ppshiftinst_clip.clip <= clipzero;
                        ppshiftinst_clip.outreg <= out54;
                    when "10" =>
                        ppinst <= nop;
                        ppshiftinst_clip.clip <= clipzero;
                        ppshiftinst_clip.outreg <= out32;
                    when others =>
                        inst <= matmul00; --d(1)*(1/det(a))
                        ppshiftinst_clip.outreg <= out10;
                end case;
            end if;
        elsif state = xTRSM then -- xTRSM
            if r = "00000" then        -- 4 cycles, Aik*Lkk
                inst <= unitri1;
                ppinst <= select6;
                ppshiftinst_shift.shift <= 7;
                case c is
                    when "00" =>
                        data_read_enable <= '1';
                        weight_read_enable <= '1';
                        memreg_c.datareg <= enable;
                        memreg_c.weightreg <= enable;
                    when "01" =>
                        inst <= unitri2;
                        ppinst <= unitri;
                        ppshiftinst_clip.outreg <= out54;
                    when "10" =>
                        inst <= unitri3;
                        ppshiftinst_clip.outreg <= out32;
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
            if r = "00000" then           -- probably 1 cycle, from W to D
                weight_read_enable <= '1';
                memreg_c.swap <= weighttodata;
                memreg_c.datareg <= enable;
                ppinst <= nop;
            elsif r = "00001" then        -- 4 cycles, Lik*Dkk
                inst <= matmul00;
                case c is
                    when "00" =>
                        weight_read_enable <= '1';
                        memreg_c.weightreg <= enable;
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
            elsif r = "00010" then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul00t; -- matmul_t
                case c is
                    when "00" =>
                        data_read_enable <= '1';
                        weight_read_enable <= '1';
                        memreg_c.datareg <= enable;
                        memreg_c.weightreg <= enable;
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
            if r = "00000" then           -- probably 1 cycle, from W to D
                weight_read_enable <= '1';
                memreg_c.swap <= weighttodata;
                memreg_c.datareg <= enable;
                ppinst <= nop;
            elsif r = "00001" then        -- 4 cycles, Lik*Dkk
                inst <= matmul00;
                case c is
                    when "00" =>
                        weight_read_enable <= '1';
                        memreg_c.weightreg <= enable;
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
            elsif r = "00010" then        -- 4 cycles, tmp*Lik, W*D
                inst <= matmul00t; -- matmul_t
                case c is
                    when "00" =>
                        data_read_enable <= '1';
                        weight_read_enable <= '1';
                        memreg_c.datareg <= enable;
                        memreg_c.weightreg <= enable;
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
            ppshiftinst_clip.outreg <= none;
            case prev_state is
                when xSYTRF =>
                    case r is
                        when "00000" =>
                            weight_write_enable <= '1';
                        when "00001" =>
                            weight_write_enable <= '1';
                        when "00010" =>
                            weight_write_enable <= '1';
                        when "00100" =>
                            data_write_enable <= '1';
                        when "00101" =>
                            data_write_enable <= '1';
                        when others =>
                            weight_write_enable <= '1';
                    end case;
                when xTRSM =>
                    case r is
                        when "00000" =>
                            data_write_enable <= '1';
                        when others =>
                            weight_write_enable <= '1';
                    end case;
                when xSYDRK =>
                    case r is
                        when "00001" =>
                            weight_write_enable <= '1';
                        when "00010" =>
                            weight_write_enable <= '1';
                        when others =>
                            data_write_enable <= '1';
                    end case;
                when others => -- xGEMDM
                    case r is
                        when "00001" =>
                            data_write_enable <= '1';
                        when "00010" =>
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

  process (all)
  begin
    en_max <= x"0";
    if state = writing and prev_state = xSYTRF and r = "00010" then
        en_max <= X"A";
    end if;
  end process;

  ---------------------------------------------------------------------------

    -- outputs
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
