-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : ve
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : ve.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: vector engine
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2021-5-19  		     1.0	     CJ			Created
--2021-9-16              2.0         CJ         Advanced address generation and post processing block added
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.cluster_pkg.all;

entity ve is
    port(
        --Control inputs
        CLK_P:                 in std_logic;
        CLK_E_POS :            in std_logic;
        CLK_E_NEG :            in std_logic;
        RST       :            in std_logic;

        PL        :            in std_logic_vector(127 downto 0);
        YBUS      :            in std_logic_vector(7 downto 0); -- Y bus
        --DFY       :            in std_logic_vector(63 downto 0);

        DDI_VLD   :            in std_logic;  --input data valid, from CC
        --Control outputs
        RE_RDY    :            out std_logic; --Receive engine ready. Activates when re_loop is zero.
        VE_RDY    :            out std_logic; --Vector engine ready. Activates when ve_loop is zero.
        --Data inputs
        VE_IN     :            in std_logic_vector(63 downto 0);
        --Data outputs
        VE_OUT_A    :          out std_logic_vector(7 downto 0);  --Output to DSL
        VE_OUT_SING  :          out std_logic_vector(7 downto 0)  --Output to DSL
        --VE_OUT_BUF1 :          out std_logic_vector(7 downto 0);  --Output to DSL
        --VE_OUT_BUF2 :          out std_logic_vector(7 downto 0);  --Output to DSL
        --VE_OUT_BUF3 :          out std_logic_vector(7 downto 0);  --Output to DSL
        --VE_OUT_BUF4 :          out std_logic_vector(7 downto 0);  --Output to DSL
        --VE_OUT_BUF5 :          out std_logic_vector(7 downto 0);  --Output to DSL
        --VE_OUT_BUF6 :          out std_logic_vector(7 downto 0);  --Output to DSL
        --VE_OUT_BUF7 :          out std_logic_vector(7 downto 0)   --Output to DSL
       );
end entity ve;

architecture rtl of ve is
--COMPONENT xbip_multadd_0
--  PORT (
--    CLK : IN STD_LOGIC;
--    CE : IN STD_LOGIC;
--    SCLR : IN STD_LOGIC;
--    A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    C : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
--    SUBTRACT : IN STD_LOGIC;
--    P : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
--    PCOUT : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
--  );
--END COMPONENT;

COMPONENT c_accum_0
  PORT (
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    BYPASS : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mult_gen_0
  PORT (
    CLK : IN STD_LOGIC;
    CE  : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;
COMPONENT dist_mem_gen_0
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

    --------------------------------
    --PL signals
    --------------------------------
    --Receive engine signals
    signal re_start : std_logic;
    signal re_source : std_logic;
    signal re_source_reg : std_logic;
    signal re_rdy_int : std_logic;
    --Vector engine signals
    signal ve_rdy_int : std_logic;
    signal ve_start : std_logic;
    signal dfy_dest_sel : std_logic_vector(2 downto 0);
    --signal wr_st_addr:std_logic; --TBD
    --signal wr_offset : std_logic;--TBD
    --signal wr_jump   : std_logic;--TBD
    --signal wr_depth  : std_logic;--TBD
    --signal mac_switch : std_logic;
    signal acc_latch  : std_logic;
      --Post processing --TBA

    --Shared signals
    signal mode_a : std_logic; --mode A activate
    signal mode_b : std_logic; --mode B activate
    signal mode_c : std_logic; --Vector engine mode c;
    signal mode_d : std_logic; --Vector engine mode d;
    signal reload : std_logic; --reload address counters 
    signal reg_in : std_logic_vector(4 downto 0); --parameter register set field, including loop counter.
    
    --------------------------------
    --Registers
    --------------------------------
    type dfy_word is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal re_addr_l   : std_logic_vector(7 downto 0); --Receive engine left address when DFM is used as the source
    signal re_addr_r   : std_logic_vector(7 downto 0);
    signal re_saddr_l  : std_logic_vector(7 downto 0); --Receive engine's left starting address when DFM is used as the source
    signal re_saddr_r  : std_logic_vector(7 downto 0);
    signal re_loop_reg : std_logic_vector(7 downto 0); --receive engine's loop counter register
    signal re_loop     : std_logic_vector(7 downto 0); --receive engine's loop counter
    signal re_saddr_a   : std_logic_vector(7 downto 0); --Receive engine mode A start address when DFY is used as the source
    signal re_saddr_b   : std_logic_vector(7 downto 0); 
    signal re_addr_a   : std_logic_vector(7 downto 0); 
    signal re_addr_b   : std_logic_vector(7 downto 0); 
    signal ve_addr_l   : std_logic_vector(7 downto 0); --data to address pointer left
    signal ve_saddr_l  : std_logic_vector(7 downto 0); --Left starting address register
    signal ve_addr_r   : std_logic_vector(7 downto 0);
    signal ve_saddr_r  : std_logic_vector(7 downto 0);
    signal ve_loop     : std_logic_vector(7 downto 0);
    signal ve_oloop    : std_logic_vector(7 downto 0);
    signal ve_loop_reg : std_logic_vector(7 downto 0);
    signal ve_oloop_reg : std_logic_vector(7 downto 0);
    signal offset_l    : std_logic_vector(7 downto 0); --offset register
    signal offset_r    : std_logic; 
    signal jump_l    : std_logic_vector(7 downto 0);--Jump register
    signal depth_l   : std_logic_vector(7 downto 0);--depth register
    signal config    : std_logic_vector(7 downto 0); --configure register
    signal ring_end_addr : std_logic_vector(7 downto 0);
    signal ring_start_addr : std_logic_vector(7 downto 0);
    signal curr_ring_addr : std_logic_vector(7 downto 0);
    signal mul_ctl   : std_logic_vector(7 downto 0); --turn off the multipliers.
    signal dfy_reg   : dfy_word;
    signal re_start_reg : std_logic; --RE start latch
    signal ve_start_reg : std_logic; --VE start latch
    --signal mode_a_reg  : std_logic; --replaced with mode_a_l
    --signal mode_b_reg  : std_logic; --replaced with mode_b_l
    signal addr_reload   : std_logic;
    --signal rst_i       : std_logic;
    signal sclr_i        : std_logic; --For clear accumulator 0-7
    signal buf_out_l  : std_logic_vector(63 downto 0);
    signal buf_out_r  : std_logic_vector(63 downto 0);
    signal mul_out_0  : std_logic_vector(15 downto 0);
    signal mul_out_1  : std_logic_vector(15 downto 0);
    signal mul_out_2  : std_logic_vector(15 downto 0);
    signal mul_out_3  : std_logic_vector(15 downto 0);
    signal mul_out_4  : std_logic_vector(15 downto 0);
    signal mul_out_5  : std_logic_vector(15 downto 0);
    signal mul_out_6  : std_logic_vector(15 downto 0);
    signal mul_out_7  : std_logic_vector(15 downto 0);
    signal acc_out_0  : std_logic_vector(23 downto 0);
    signal acc_out_1  : std_logic_vector(23 downto 0);
    signal acc_out_2  : std_logic_vector(23 downto 0);
    signal acc_out_3  : std_logic_vector(23 downto 0);
    signal acc_out_4  : std_logic_vector(23 downto 0);
    signal acc_out_5  : std_logic_vector(23 downto 0);
    signal acc_out_6  : std_logic_vector(23 downto 0);
    signal acc_out_7  : std_logic_vector(23 downto 0);
    signal acc_out_8  : std_logic_vector(23 downto 0);
    signal acc_out_a  : std_logic_vector(31 downto 0);
    signal bypass     : std_logic;
    signal sram_in    : std_logic_vector(63 downto 0);
    signal mode_a_l  : std_logic;
    signal mode_b_l  : std_logic;
    signal sram_l_we  : std_logic;
    signal sram_r_we  : std_logic;
    signal ve_clr_acc : std_logic; --clear accumulators
    --signal sramr_in    : std_logic_vector(63 downto 0);
    signal pl_ve_byte : std_logic_vector(3 downto 0);


    signal addr_p_l  : std_logic_vector(7 downto 0);
    signal addr_p_r  : std_logic_vector(7 downto 0);

    --multiplier control signals
    signal mctl_0 :  std_logic;
    signal mctl_1 :  std_logic;
    signal mctl_2 :  std_logic;
    signal mctl_3 :  std_logic;
    signal mctl_4 :  std_logic;
    signal mctl_5 :  std_logic;
    signal mctl_6 :  std_logic;
    signal mctl_7 :  std_logic;
    signal ve_mult_latch : std_logic;
    --accumulator control signals
    signal actl_0 : std_logic;
    signal actl_1 : std_logic;
    signal actl_2 : std_logic;
    signal actl_3 : std_logic;
    signal actl_4 : std_logic;
    signal actl_5 : std_logic;
    signal actl_6 : std_logic;
    signal actl_7 : std_logic;
    signal a_latch : std_logic;
    signal substract_i : std_logic;
    signal pcout_i : std_logic_vector(47 downto 0);
    --------------------------------
    --Register set selection fields (can be moved to mpgmfield_lib.vhd?)
    --------------------------------
    constant CONS_NON_ACT         : std_logic_vector(4 downto 0) := "0"&x"0";
    constant CONS_RE_START_ADDR_L : std_logic_vector(4 downto 0) := "0"&x"1"; --write left starting address of receive engine
    constant CONS_RE_START_ADDR_R : std_logic_vector(4 downto 0) := "0"&x"2"; --write right starting address of recieve engine
    constant CONS_RE_LC           : std_logic_vector(4 downto 0) := "0"&x"3"; --write receive engine's loop counter
    constant CONS_DFY_ADDR_A      : std_logic_vector(4 downto 0) := "0"&x"4"; --push back address from DFY
    constant CONS_DFY_ADDR_B      : std_logic_vector(4 downto 0) := "0"&x"5"; --push back address from DFY, B mode
    constant CONS_VE_START_ADDR_L : std_logic_vector(4 downto 0) := "0"&x"6"; --vector engine's left starting address
    constant CONS_VE_START_ADDR_R : std_logic_vector(4 downto 0) := "0"&x"7"; --vector engine's right starting address
    constant CONS_VE_LC           : std_logic_vector(4 downto 0) := "0"&x"8"; --vector engine's INNER loop counter
    constant CONS_VE_OFFSET_L     : std_logic_vector(4 downto 0) := "0"&x"9"; --left offset
    constant CONS_VE_OFFSET_R     : std_logic_vector(4 downto 0) := "0"&x"a"; --right offset
    constant CONS_VE_DEPTH_L      : std_logic_vector(4 downto 0) := "0"&x"b"; --left depth
    constant CONS_VE_JUMP_L       : std_logic_vector(4 downto 0) := "0"&x"c"; --left jump
    constant CONS_DFY_REG_SHIFT_IN: std_logic_vector(4 downto 0) := "0"&x"d"; --write DFY
    constant CONS_DFY_REG_PARALLEL: std_logic_vector(4 downto 0) := "0"&x"e"; --write DFY in parallel from mac registers
    constant CONS_DTM_REG_SHIFT_IN: std_logic_vector(4 downto 0) := "0"&x"f"; --Write DTM --?
    constant CONS_VE_OLC          : std_logic_vector(4 downto 0) := "1"&x"0"; --write vector engine's OUTER loop counter
    constant CONS_CONFIG          : std_logic_vector(4 downto 0) := "1"&x"1"; --write config register for both ring mode and inner-outer loop mode
    constant CONS_RING_END        : std_logic_vector(4 downto 0) := "1"&x"2"; --Ring mode end address
    constant CONS_RING_START      : std_logic_vector(4 downto 0) := "1"&x"3"; --Ring mode start address. 
    constant CONS_CURR_RING       : std_logic_vector(4 downto 0) := "1"&x"3"; --Current ring address register. Always written when ring_start writes. 
    constant CONS_MAC_SWITCH      : std_logic_vector(4 downto 0) := "1"&x"f"; --write the multiplier control register


begin
    --Microcode translation
    --Some microinstructions are latched to registers and operates at clk_p frequency. 
    --Not latched signals are used only in one microinstruction time (clk_e) together with 
    --re_start and ve_start signals and mode abcd or relaod signal. 
    dfy_dest_sel <= PL (118 downto 116); --DEST_BYTE
    re_start  <= PL(100);
    ve_start  <= PL(95); --VE_ST
    acc_latch <= PL(94); --ACCTOREG
    re_source <= PL(96); --RE_DFY_SRC --
    reg_in    <= PL(105 downto 101);
    mode_a    <= PL(98);
    mode_b    <= PL(97);
    addr_reload <= PL(99);
    ve_clr_acc <= PL(93);
    pl_ve_byte <= PL(112 downto 109);
    --
    --rst_i <= RST;
    sram_in <= VE_IN;
    reg_write: process(clk_p)
    begin
        if rising_edge(clk_p) and clk_e_neg = '1' then --rising_edge of clk_e
            if reg_in = CONS_RE_START_ADDR_L then
                re_saddr_l <= YBUS;
            elsif reg_in = CONS_RE_START_ADDR_R then
                re_saddr_r <= YBUS;
            elsif reg_in = CONS_RE_LC then
                re_loop_reg <= YBUS;
            elsif reg_in = CONS_DFY_ADDR_A then
                re_saddr_a <= YBUS;
            elsif reg_in = CONS_DFY_ADDR_B then
                re_saddr_b <= YBUS;
            elsif reg_in = CONS_VE_START_ADDR_L then
                ve_saddr_l <= YBUS;
            elsif reg_in = CONS_VE_START_ADDR_R then
                ve_saddr_r <= YBUS;
            elsif reg_in = CONS_VE_LC then
                ve_loop_reg <= YBUS;
            elsif reg_in = CONS_VE_OFFSET_L then
                offset_l <= YBUS;
            elsif reg_in = CONS_VE_OFFSET_R then
                offset_r <= YBUS(0);
            elsif reg_in = CONS_VE_DEPTH_L then
                depth_l <= YBUS;
            elsif reg_in = CONS_VE_JUMP_L then
                jump_l <= YBUS;
            elsif reg_in = CONS_DFY_REG_SHIFT_IN then
                dfy_reg(to_integer(unsigned(dfy_dest_sel))) <= YBUS;
            elsif reg_in = CONS_VE_OLC then
                ve_oloop_reg <= YBUS;
            elsif reg_in = CONS_CONFIG then
                config <= YBUS;
            elsif reg_in = CONS_RING_END then
                ring_end_addr <= YBUS;
            elsif reg_in = CONS_RING_START then
                ring_start_addr <= YBUS;
                curr_ring_addr <= YBUS;
            --elsif reg_in = ACC_CLR then
               -- mul_ctl <= YBUS;
            elsif reg_in = CONS_MAC_SWITCH then
                mul_ctl <= YBUS;
            end if;
        end if;
    end process;
    
    --Latched signals
    --Some signals from pl registers are latched for receive engine and vector engine to operate
    --without control from pl. Latched signals are cleared when loop registers goes to 0. 
    latch_signals: process(clk_p,re_start,addr_reload,re_loop,addr_reload,ve_start,ve_loop, mode_a, mode_b,mode_c)
    begin
        if rising_edge(clk_p) then --latches at the rising_edge of clk_p. 
            if re_start = '1' then --always after loop counter is set
                re_start_reg <= '1';
            elsif re_loop = (re_loop'range => '0') then 
                re_start_reg <= '0';
            end if;
    
            if ve_start = '1' then
                ve_start_reg <= '1';
            elsif ve_loop = (ve_loop'range => '0') and ve_oloop = (ve_oloop'range => '0') then 
                ve_start_reg <= '0';
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
        end if;
    end process;
----------------------------------------------------------------------------------
--Address generation block
----------------------------------------------------------------------------------
    --********************************
    --Receive engine
    --********************************
    --Mode left and right for reveive engine, used to load srams from DTM. 
    receive_addr_write : process (clk_p) 
    begin 
        if rising_edge(clk_p) then
            if RST = '0' then        --Active low or high?
                re_addr_l<= (others => '0');
                re_addr_r <= (others => '0');
                re_loop <= (others => '0');
            elsif addr_reload = '1' then
                re_loop <= re_loop_reg;
                if mode_a_l = '1' then
                    re_addr_l <= re_saddr_l;
                elsif mode_b_l = '1' then
                    re_addr_r <= re_saddr_r;
                end if;
            elsif re_source = '0' and re_start_reg = '1' and re_loop /= (re_loop'range => '0') and DDI_VLD = '1' then

                re_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(re_loop))-1,8));

                if mode_a_l = '1' then      
                    re_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_l))+1,8));
                    
                end if;

                if mode_b_l = '1' then
                    re_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_r))+1,8));
                end if;

            end if;
        end if;
    end process;
    --Mode a and b for reloading receive engine, mode bits are not latched.
    --re_start, re_source and modes are written in one microinstructions.
    --addr_reload, modes are written in one microinstruction.
    pushback_addr_write : process(clk_p) --generate address counter a abd b
    begin
        if rising_edge(clk_p) then
            if RST = '0' then
                re_addr_a <= (others => '0');
                re_addr_b <= (others => '0');
            elsif addr_reload = '1' then
                if mode_a = '1' then
                    re_addr_a <= re_saddr_a;
                elsif mode_b = '1' then
                    re_addr_b <= re_saddr_b;
                end if;
            elsif re_source = '1' and re_start = '1' then
                if mode_a = '1'  then 
                    re_addr_a <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_a))+1,8));
                end if;
                
                if mode_b = '1' then
                    re_addr_b <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_b))+1,8));
                end if;

            end if;
        end if;
    end process;

    --********************************
    --Vector engine
    --********************************
    --Mode left and right of vector engine. Controlled by latched control signal and two loopcounters
    ve_addr_gene: process(clk_p)
    begin
        if rising_edge(clk_p) then
            if RST = '0' then
                ve_addr_l <= (others => '0');
                ve_addr_r <= (others => '0');
                ve_loop <= (others => '0');
                ve_oloop <= (others => '0');
            if ve_start = '1' and addr_reload = '1' then --load vector engine's outer loop  and inner loop by the control of microinstructions, ring mode doesn't need a address reload
                if mode_a = '1' or mode_b = '1' then --only mode a and b requires outer loop to be reloaded
                ve_oloop <= ve_oloop_reg;
                end if;
                ve_loop <= ve_loop_reg;
                ve_addr_l <= ve_saddr_l;
                ve_addr_r <= ve_saddr_r;               
            elsif ve_start_reg = '1' and ve_oloop /= (ve_oloop'range => '0')then --when outer loop is not 0, do self reload.
                if ve_loop = (ve_loop'range => '0') then --acts when ve's inner loop counter goes to 0, 
                    ve_oloop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_oloop))-1,8));

                    if config(4) = '1' then --reload by config register, bit 4 in configure register
                    ve_loop <= ve_loop_reg;
                    end if;

                    if config(2) = '1' then 
                    ve_addr_l <= ve_saddr_l;
                    end if;

                    if config(3) = '1' then
                    ve_addr_r <= ve_saddr_r;
                    end if;

                elsif ve_loop /= (ve_loop'range => '0') then
                    ve_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_loop))-1,8));
                    ve_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_l)+1),8));
                    ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8)); --calculate right address;
                end if;
            
            elsif ve_start_reg = '1' and ve_oloop = (ve_oloop'range => '0') then --outer loop is 0. Last loop.
                if ve_loop /= (ve_loop'range => '0') then
                    ve_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_loop))-1,8));
                    ve_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_l)+1),8));
                    ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8)); --calculate right address;
                end if;   
            end if;
            end if;
        end if;
    end process;
    
    VE_RDY <= not ve_start_reg;
    --********************************
    --Mode c. Shared by RE and VE
    --********************************
    --How to control the right address?
    mode_c_addr: process(clk_p)
    begin
        if rising_edge(clk_p) then
            if RST = '0' then
                ring_start_addr <= (others => '0');
                ring_end_addr <= (others => '0');
                curr_ring_addr <= (others => '0');
            elsif re_start = '1' and mode_c = '1' then --clk_e synchronized
                if curr_ring_addr = ring_end_addr then
                    curr_ring_addr <= ring_start_addr;
                else
                    curr_ring_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))
                                                       +to_integer(unsigned(offset_l))
                                                       +to_integer(unsigned(depth_l)),8));
                end if;
            elsif ve_start_reg = '1' and config(6) = '1' then
                if curr_ring_addr = ring_end_addr then
                    curr_ring_addr <= ring_start_addr;
                else
                    curr_ring_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))
                                                       +to_integer(unsigned(offset_l))
                                                       +to_integer(unsigned(depth_l)),8));
                end if;
                ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8));
            else
                curr_ring_addr <= (others => 'Z');
                ve_addr_r <= (others => 'Z');
            end if;
        end if;
    end process;


    --**********************
    --Address_MUX
    --**********************
    process(clk_p,re_start_reg,re_source,mode_a_l,mode_b_l,ve_start_reg,re_addr_l,re_addr_r,re_addr_a,re_addr_b,ve_addr_l,ve_addr_r)
    begin
        if re_start = '1' or ve_start = '1' then
            if mode_c = '1' then
                addr_p_l <= curr_ring_addr;  
            end if;
        elsif ve_start_reg = '1' and mode_c = '1' then
            addr_p_l <= curr_ring_addr;
            addr_p_r <= ve_addr_r; --reload reg required. --TBD      
        elsif re_start_reg = '1' and re_source = '0' then --Use receive engine's address counter l and r
            if mode_a_l = '1' then
                addr_p_l <= re_addr_l;
            end if;

            if mode_b_l = '1' then
                addr_p_r <= re_addr_r;
            end if;
        elsif re_start_reg = '1' and re_source = '1' then --Use receive engine's address counter a and b --mode c added --2.0
            if mode_a_l = '1' then
                addr_p_l <= re_addr_a;
            elsif mode_b_l = '1' then
                addr_p_r <= re_addr_b;
            end if;
        elsif ve_start_reg = '1' then --Use vector engine's address counter
            if config(2) = '1' then
                addr_p_l <= ve_addr_l;
            end if;

            if config(3) = '1' then
                addr_p_r <= ve_addr_r;
            end if;
        end if;
    end process;

    --Write enable signal to srams
    sram_we : process(clk_p)
    begin
        if rising_edge(clk_p) then
            if re_start_reg = '1' then
                if mode_a_l = '1' then
                    sram_l_we <= '1';
                elsif mode_b_l = '1' then
                    sram_r_we <= '1';
                end if;
            elsif re_start = '1' and mode_c = '1' then
                sram_l_we <= CLK_E_POS;         --Enables only half time of clk_e cycle. POS or NEG TBA
            elsif re_start_reg = '0' then
                sram_l_we <= '0';
                sram_r_we <= '0';
            end if;
        end if;
    end process;

    RE_RDY <= not re_start_reg;
 sclr_i <= not RST and ve_clr_acc;



---------------------------------------------------------------
--multiplier control logic:
---------------------------------------------------------------
process(clk_p)
begin
    if rising_edge(clk_p) then
        ve_mult_latch <= ve_start_reg;
    end if;
end process;
 mctl_0 <= mul_ctl(0) and (ve_start_reg or ve_mult_latch);
 mctl_1 <= mul_ctl(1) and (ve_start_reg or ve_mult_latch);
 mctl_2 <= mul_ctl(2) and (ve_start_reg or ve_mult_latch);
 mctl_3 <= mul_ctl(3) and (ve_start_reg or ve_mult_latch);
 mctl_4 <= mul_ctl(4) and (ve_start_reg or ve_mult_latch);
 mctl_5 <= mul_ctl(5) and (ve_start_reg or ve_mult_latch);
 mctl_6 <= mul_ctl(6) and (ve_start_reg or ve_mult_latch);
 mctl_7 <= mul_ctl(7) and (ve_start_reg or ve_mult_latch);
 process(clk_p)
 begin
     if rising_edge(clk_p) then
         a_latch <= ve_mult_latch;
     end if;
 end process;
 actl_0 <= mul_ctl(0) and (a_latch or ve_mult_latch);
 actl_1 <= mul_ctl(1) and (a_latch or ve_mult_latch);
 actl_2 <= mul_ctl(2) and (a_latch or ve_mult_latch);
 actl_3 <= mul_ctl(3) and (a_latch or ve_mult_latch);
 actl_4 <= mul_ctl(4) and (a_latch or ve_mult_latch);
 actl_5 <= mul_ctl(5) and (a_latch or ve_mult_latch);
 actl_6 <= mul_ctl(6) and (a_latch or ve_mult_latch);
 actl_7 <= mul_ctl(7) and (a_latch or ve_mult_latch);
 bypass <= '0';
accu_0 : c_accum_0
  PORT MAP (
    B => mul_out_0,
    CLK => CLK_P,
    CE => actl_0,
    BYPASS => bypass, --NOT USED
    SCLR => sclr_i,
    Q => acc_out_0
  );
  accu_1 : c_accum_0
  PORT MAP (
    B => mul_out_1,
    CLK => CLK_P,
    CE => actl_1,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_1
  );
  accu_2 : c_accum_0
  PORT MAP (
    B => mul_out_2,
    CLK => CLK_P,
    CE => actl_2,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_2
  );
  accu_3 : c_accum_0
  PORT MAP (
    B => mul_out_3,
    CLK => CLK_P,
    CE => actl_3,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_3
  );
  accu_4 : c_accum_0
  PORT MAP (
    B => mul_out_4,
    CLK => CLK_P,
    CE => actl_4,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_4
  );
  accu_5 : c_accum_0
  PORT MAP (
    B => mul_out_5,
    CLK => CLK_P,
    CE => actl_5,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_5
  );
  accu_6 : c_accum_0
  PORT MAP (
    B => mul_out_6,
    CLK => CLK_P,
    CE => actl_6,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_6
  );
  accu_7 : c_accum_0
  PORT MAP (
    B => mul_out_7,
    CLK => CLK_P,
    CE => actl_7,
    BYPASS => BYPASS,
    SCLR => sclr_i,
    Q => acc_out_7
  );
  mul_0 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_0,
    A => buf_out_l(7 downto 0),
    B => buf_out_r(7 downto 0),
    P => mul_out_0
  );
  mul_1 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_1,
    A => buf_out_l(15 downto 8),
    B => buf_out_r(15 downto 8),
    P => mul_out_1
  );
  mul_2 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_2,
    A => buf_out_l(23 downto 16),
    B => buf_out_r(23 downto 16),
    P => mul_out_2
  );
  mul_3 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_3,
    A => buf_out_l(31 downto 24),
    B => buf_out_r(31 downto 24),
    P => mul_out_3
  );
  mul_4 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_4,
    A => buf_out_l(39 downto 32),
    B => buf_out_r(39 downto 32),
    P => mul_out_4
  );
  mul_5 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_5,
    A => buf_out_l(47 downto 40),
    B => buf_out_r(47 downto 40),
    P => mul_out_5
  );
  mul_6 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_6,
    A => buf_out_l(55 downto 48),
    B => buf_out_r(55 downto 48),
    P => mul_out_6
  );
  mul_7 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_7,
    A => buf_out_l(63 downto 56),
    B => buf_out_r(63 downto 56),
    P => mul_out_7
  );
  substract_i <= '0';
  --mac_0 : xbip_multadd_0
  --PORT MAP (
  --  CLK => CLK_P,
  --  CE => mctl_0,
  --  SCLR => sclr_i,
  --  A => buf_out_l(7 downto 0),
  --  B => buf_out_r(7 downto 0),
  --  C => acc_out_0,
  --  SUBTRACT => substract_i,
  --  P => acc_out_0,
  --  PCOUT => pcout_i
  --);
  --mac_7 : xbip_multadd_0
  --PORT MAP (
  --  CLK => CLK_P,
  --  CE => mctl_7,
  --  SCLR => sclr_i,
  --  A => buf_out_l(63 downto 56),
  --  B => buf_out_r(63 downto 56),
  --  C => mul_out_7,
  --  SUBTRACT => open,
  --  P => acc_out_7,
  --  PCOUT => open
  --);
  buf_0 : dist_mem_gen_0
  PORT MAP (
    a => addr_p_l,
    d => sram_in,
    clk => clk_p,
    we => sram_l_we, --
    spo => buf_out_l
  );
  buf_1 : dist_mem_gen_0
  PORT MAP (
    a => addr_p_r,
    d => sram_in,
    clk => clk_p,
    we => sram_r_we,
    spo => buf_out_r
  );
  --Overall accumulator (Adder)
  acc_out_a <= std_logic_vector(to_unsigned
                               (to_integer(unsigned(acc_out_0))+ 
                                to_integer(unsigned(acc_out_1))+
                                to_integer(unsigned(acc_out_2))+
                                to_integer(unsigned(acc_out_3))+
                                to_integer(unsigned(acc_out_4))+
                                to_integer(unsigned(acc_out_5))+
                                to_integer(unsigned(acc_out_6))+
                                to_integer(unsigned(acc_out_7)),32));



------------------------------------------------------------------------------
 --Output --Quantization block need to be added here
 ------------------------------------------------------------------------------
  VE_OUT_A <= acc_out_a (7 downto 0);
process(clk_p)
begin
    if rising_edge(clk_p) and clk_e_neg = '1' then
        if pl_ve_byte = x"0" then
            VE_OUT_SING <= acc_out_0 (7 downto 0);
        elsif pl_ve_byte = x"1" then
            VE_OUT_SING <= acc_out_1 (7 downto 0);
        elsif pl_ve_byte = x"2" then
            VE_OUT_SING <= acc_out_2 (7 downto 0);
        elsif pl_ve_byte = x"3" then
            VE_OUT_SING <= acc_out_3 (7 downto 0);
        elsif pl_ve_byte = x"4" then
            VE_OUT_SING <= acc_out_4 (7 downto 0);
        elsif pl_ve_byte = x"5" then
            VE_OUT_SING <= acc_out_5 (7 downto 0);
        elsif pl_ve_byte = x"6" then
            VE_OUT_SING <= acc_out_6 (7 downto 0);
        elsif pl_ve_byte = x"7" then
            VE_OUT_SING <= acc_out_7 (7 downto 0);
        else
            VE_OUT_SING <= (others => 'Z');
        end if;
    end if;
end process;
  
end architecture;  
                    

                 
    





