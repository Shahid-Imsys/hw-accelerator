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
        VE_IN     :            in std_logic_vector(63 downto 0); --DFM input
        --Data outputs
        VE_OUT_D    :          out std_logic_vector(7 downto 0);  --Output to DSL
        VE_OUT_DTM  :          out std_logic_vector(127 downto 0)  --Output to MMR Block
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
    B : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    BYPASS : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mult_gen_0
  PORT (
    CLK : IN STD_LOGIC;
    CE  : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
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
COMPONENT dist_mem_gen_1
  PORT (
    a : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
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
    type dtm_word is array(15 downto 0) of std_logic_vector(7 downto 0);
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
    signal zp_data    : std_logic_vector(7 downto 0); --zero point addition data
    signal zp_weight  : std_logic_vector(7 downto 0); --zero point addition data
    signal scale      : std_logic_vector(4 downto 0); --shift scale factor
    signal pp_ctl  : std_logic_vector(4 downto 0);
    signal bias_index_end : std_logic_vector(7 downto 0);
    signal bias_index_start : std_logic_vector(7 downto 0);
    signal bias_index_wr : std_logic_vector(5 downto 0);
    signal bias_index_rd : std_logic_vector(7 downto 0);
    signal fw_layer   : std_logic_vector(23 downto 0); --feed forward layer, 24 bits.
    signal mul_ctl   : std_logic_vector(7 downto 0); --turn off the multipliers.
    signal dfy_reg   : dfy_word;    --pushback(DFY) register
    signal dtm_data_reg : dtm_word;
    signal re_start_reg : std_logic; --RE start latch
    signal ve_start_reg : std_logic; --VE start latch
    --signal mode_a_reg  : std_logic; --replaced with mode_a_l
    --signal mode_b_reg  : std_logic; --replaced with mode_b_l
    signal addr_reload   : std_logic;
    --signal rst_i       : std_logic;
    signal sclr_i        : std_logic; --For clear accumulator 0-7
    signal buf_out_l  : std_logic_vector(63 downto 0);
    signal buf_out_r  : std_logic_vector(63 downto 0);
    signal mul_in_l_0 : std_logic_vector(8 downto 0);
    signal mul_in_l_1 : std_logic_vector(8 downto 0);
    signal mul_in_l_2 : std_logic_vector(8 downto 0);
    signal mul_in_l_3 : std_logic_vector(8 downto 0);
    signal mul_in_l_4 : std_logic_vector(8 downto 0);
    signal mul_in_l_5 : std_logic_vector(8 downto 0);
    signal mul_in_l_6 : std_logic_vector(8 downto 0);
    signal mul_in_l_7 : std_logic_vector(8 downto 0);
    signal mul_in_r_0 : std_logic_vector(8 downto 0);
    signal mul_in_r_1 : std_logic_vector(8 downto 0);
    signal mul_in_r_2 : std_logic_vector(8 downto 0);
    signal mul_in_r_3 : std_logic_vector(8 downto 0);
    signal mul_in_r_4 : std_logic_vector(8 downto 0);
    signal mul_in_r_5 : std_logic_vector(8 downto 0);
    signal mul_in_r_6 : std_logic_vector(8 downto 0);
    signal mul_in_r_7 : std_logic_vector(8 downto 0);
    signal mul_out_0  : std_logic_vector(17 downto 0);
    signal mul_out_1  : std_logic_vector(17 downto 0);
    signal mul_out_2  : std_logic_vector(17 downto 0);
    signal mul_out_3  : std_logic_vector(17 downto 0);
    signal mul_out_4  : std_logic_vector(17 downto 0);
    signal mul_out_5  : std_logic_vector(17 downto 0);
    signal mul_out_6  : std_logic_vector(17 downto 0);
    signal mul_out_7  : std_logic_vector(17 downto 0);
    signal acc_out_0  : std_logic_vector(31 downto 0);
    signal acc_out_1  : std_logic_vector(31 downto 0);
    signal acc_out_2  : std_logic_vector(31 downto 0);
    signal acc_out_3  : std_logic_vector(31 downto 0);
    signal acc_out_4  : std_logic_vector(31 downto 0);
    signal acc_out_5  : std_logic_vector(31 downto 0);
    signal acc_out_6  : std_logic_vector(31 downto 0);
    signal acc_out_7  : std_logic_vector(31 downto 0);
    signal acc_out_8  : std_logic_vector(31 downto 0);
    signal acc_out_a  : std_logic_vector(31 downto 0);
    signal acc_reg_0  : std_logic_vector(31 downto 0);
    signal acc_reg_1  : std_logic_vector(31 downto 0);
    signal acc_reg_2  : std_logic_vector(31 downto 0);
    signal acc_reg_3  : std_logic_vector(31 downto 0);
    signal acc_reg_4  : std_logic_vector(31 downto 0);
    signal acc_reg_5  : std_logic_vector(31 downto 0);
    signal acc_reg_6  : std_logic_vector(31 downto 0);
    signal acc_reg_7  : std_logic_vector(31 downto 0);
    signal acc_reg_a  : std_logic_vector(31 downto 0);
    signal bias_buf_out : std_logic_vector(63 downto 0);
    signal bias_mux_out : std_logic_vector(15 downto 0);
    signal bias_mux     : std_logic_vector(1 downto 0);
    signal p_adder_out : std_logic_vector(31 downto 0); --Adder output in post processing block
    signal p_shifter_out : std_logic_vector(31 downto 0); --shifter output in post processing block
    signal p_shifter_in : std_logic_vector(31 downto 0);
    signal p_clip_out : std_logic_vector(7 downto 0); --clip logic output
    signal bypass     : std_logic;
    signal sram_in    : std_logic_vector(63 downto 0);
    --signal pb_reg      : std_logic_vector(63 downto 0); --pushback register
    signal mode_a_l  : std_logic;
    signal mode_b_l  : std_logic;
    signal sram_l_we  : std_logic;
    signal sram_r_we  : std_logic;
    signal sram_b_we  : std_logic;
    signal ve_clr_acc : std_logic; --clear accumulators
    signal mul_inn_ctl : std_logic;
    signal acc_inn_ctl : std_logic;
    --signal sramr_in    : std_logic_vector(63 downto 0);
    signal pl_ve_byte : std_logic_vector(3 downto 0);


    signal addr_p_l  : std_logic_vector(7 downto 0);
    signal addr_p_r  : std_logic_vector(7 downto 0);
    signal addr_p_b  : std_logic_vector(5 downto 0);
    --multiplier control signals
    signal mctl_0 :  std_logic;
    signal mctl_1 :  std_logic;
    signal mctl_2 :  std_logic;
    signal mctl_3 :  std_logic;
    signal mctl_4 :  std_logic;
    signal mctl_5 :  std_logic;
    signal mctl_6 :  std_logic;
    signal mctl_7 :  std_logic;
    signal mult_delay : std_logic;
    --accumulator control signals
    signal actl_0 : std_logic;
    signal actl_1 : std_logic;
    signal actl_2 : std_logic;
    signal actl_3 : std_logic;
    signal actl_4 : std_logic;
    signal actl_5 : std_logic;
    signal actl_6 : std_logic;
    signal actl_7 : std_logic;
    signal a_delay : std_logic;
    --signal substract_i : std_logic;
    --signal pcout_i : std_logic_vector(47 downto 0);
    --data flow control signals
    signal latch_ena : std_logic;
    signal o_mux_ena : std_logic;
    signal pp_stage_1 : std_logic; --stage one control, for shifter and bias buffer read signal
    signal pp_stage_2 : std_logic; --stage two control, for adder and bias mux.
    signal ve_out_p : std_logic;
    signal adder_ena : std_logic;
    signal shifter_ena : std_logic;
    signal bias_rd_ena : std_logic;
    signal clip_ena  : std_logic;
    signal output_ena : std_logic;
    signal ve_out_c : std_logic_vector(2 downto 0); --output byte counter to post processor
    signal output_c : std_logic_vector(3 downto 0); --output byte counter to 
    --------------------------------
    --Register set selection fields (can be moved to mpgmfield_lib.vhd?)
    --------------------------------
    constant CONS_NON_ACT          : std_logic_vector(4 downto 0) := "0"&x"0";
    constant CONS_RE_START_ADDR_L  : std_logic_vector(4 downto 0) := "0"&x"1"; --write left starting address of receive engine
    constant CONS_RE_START_ADDR_R  : std_logic_vector(4 downto 0) := "0"&x"2"; --write right starting address of recieve engine
    constant CONS_RE_LC            : std_logic_vector(4 downto 0) := "0"&x"3"; --write receive engine's loop counter
    constant CONS_DFY_ADDR_A       : std_logic_vector(4 downto 0) := "0"&x"4"; --push back address from DFY
    constant CONS_DFY_ADDR_B       : std_logic_vector(4 downto 0) := "0"&x"5"; --push back address from DFY, B mode
    constant CONS_VE_START_ADDR_L  : std_logic_vector(4 downto 0) := "0"&x"6"; --vector engine's left starting address
    constant CONS_VE_START_ADDR_R  : std_logic_vector(4 downto 0) := "0"&x"7"; --vector engine's right starting address
    constant CONS_VE_LC            : std_logic_vector(4 downto 0) := "0"&x"8"; --vector engine's INNER loop counter
    constant CONS_VE_OFFSET_L      : std_logic_vector(4 downto 0) := "0"&x"9"; --left offset
    constant CONS_VE_OFFSET_R      : std_logic_vector(4 downto 0) := "0"&x"a"; --right offset
    constant CONS_VE_DEPTH_L       : std_logic_vector(4 downto 0) := "0"&x"b"; --left depth
    constant CONS_VE_JUMP_L        : std_logic_vector(4 downto 0) := "0"&x"c"; --left jump
    constant CONS_DFY_REG_SHIFT_IN : std_logic_vector(4 downto 0) := "0"&x"d"; --write DFY
    constant CONS_DFY_REG_PARALLEL : std_logic_vector(4 downto 0) := "0"&x"e"; --write DFY in parallel from mac registers
    constant CONS_DTM_REG_SHIFT_IN : std_logic_vector(4 downto 0) := "0"&x"f"; --Write DTM --?
    constant CONS_VE_OLC           : std_logic_vector(4 downto 0) := "1"&x"0"; --write vector engine's OUTER loop counter
    constant CONS_CONFIG           : std_logic_vector(4 downto 0) := "1"&x"1"; --write config register for both ring mode and inner-outer loop mode
    constant CONS_RING_END         : std_logic_vector(4 downto 0) := "1"&x"2"; --Ring mode end address
    constant CONS_RING_START       : std_logic_vector(4 downto 0) := "1"&x"3"; --Ring mode start address. 
    constant CONS_CURR_RING        : std_logic_vector(4 downto 0) := "1"&x"3"; --Current ring address register. Always written when ring_start writes. 
    constant CONS_ZP_DATA          : std_logic_vector(4 downto 0) := "1"&x"4"; --Zero point value for data register, signed
    constant CONS_ZP_WEIGHT        : std_logic_vector(4 downto 0) := "1"&x"5"; --Zero point value for weight register, signed
    constant CONS_SCALE            : std_logic_vector(4 downto 0) := "1"&x"6"; --Scale factor for shifter
    constant CONS_PP_CTL           : std_logic_vector(4 downto 0) := "1"&x"7"; --Controls the bypass of different logics inside post processors
    constant CONS_BIAS_INDEX_END   : std_logic_vector(4 downto 0) := "1"&x"8"; --End indexing of the bias 
    constant CONS_BIAS_INDEX_START : std_logic_vector(4 downto 0) := "1"&x"9"; --Start indexing of the bias
    constant CONS_MAC_SWITCH       : std_logic_vector(4 downto 0) := "1"&x"f"; --write the multiplier control register
    --------------------------------------------------------
    --Delay FFs
    --------------------------------------------------------
    signal delay0 : std_logic; --
    signal delay1 : std_logic;
    signal delay3 : std_logic_vector(9 downto 0);


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
    mode_c    <= PL(92);
    addr_reload <= PL(99);
    ve_clr_acc <= PL(93);
    pl_ve_byte <= PL(112 downto 109);
    --
    --rst_i <= RST;
    --sram_in <= VE_IN;
    reg_write: process(clk_p)
    begin
        if rising_edge(clk_p) and clk_e_neg = '1' then --rising_edge of clk_e
            if RST = '0' then
                re_saddr_l        <= (others => '0');
                re_saddr_r        <= (others => '0');
                re_loop_reg       <= (others => '0');
                re_saddr_a        <= (others => '0'); 
                re_saddr_b        <= (others => '0'); 
                ve_saddr_l        <= (others => '0');
                ve_saddr_r        <= (others => '0');
                ve_loop_reg       <= (others => '0');
                offset_l          <= (others => '0'); 
                offset_r          <= '0'; 
                depth_l           <= (others => '0'); 
                jump_l            <= (others => '0'); 
                --dfy_reg           <= (others =>(others => '0'));
                ve_oloop_reg      <= (others => '0'); 
                config            <= (others => '0'); 
                ring_end_addr     <= (others => '0'); 
                ring_start_addr   <= (others => '0'); 
                --curr_ring_addr    <= (others => '0');
                zp_data           <= (others => '0');
                zp_weight         <= (others => '0');
                scale             <= (others => '0'); 
                pp_ctl            <= (others => '0');
                bias_index_end    <= (others => '0');
                bias_index_start  <= (others => '0');
                mul_ctl           <= (others => '0'); 
            elsif reg_in = CONS_RE_START_ADDR_L then
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
            --elsif reg_in = CONS_DFY_REG_SHIFT_IN then
            --    dfy_reg(to_integer(unsigned(dfy_dest_sel))) <= YBUS;
            elsif reg_in = CONS_VE_OLC then
                ve_oloop_reg <= YBUS;
            elsif reg_in = CONS_CONFIG then
                config <= YBUS;
            elsif reg_in = CONS_RING_END then
                ring_end_addr <= YBUS;
            elsif reg_in = CONS_RING_START then
                ring_start_addr <= YBUS;
                --curr_ring_addr <= YBUS;
            --elsif reg_in = ACC_CLR then
               -- mul_ctl <= YBUS;
            elsif reg_in = CONS_ZP_DATA then
                zp_data <= YBUS;
            elsif reg_in = CONS_ZP_WEIGHT then
                zp_weight <= YBUS;
            elsif reg_in = CONS_SCALE then
                scale   <= YBUS(4 downto 0);
            elsif reg_in = CONS_PP_CTL then
                pp_ctl <= YBUS(4 downto 0);
            elsif reg_in = CONS_BIAS_INDEX_END then
                bias_index_end <= YBUS;
            elsif reg_in = CONS_BIAS_INDEX_START then
                bias_index_start <= YBUS;
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
            if re_start = '1' and re_source = '0' then --only used when the source is from DFM register
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
                bias_index_wr <= (others => '0');
            elsif reg_in = CONS_BIAS_INDEX_START then
                bias_index_wr <= YBUS(5 downto 0);
            elsif addr_reload = '1' then
                re_loop <= re_loop_reg;
                if mode_a_l = '1' then
                    re_addr_l <= re_saddr_l;
                elsif mode_b_l = '1' then
                    re_addr_r <= re_saddr_r;
                end if;
            elsif re_source = '0' and re_start_reg = '1' and re_loop /= (re_loop'range => '0') and DDI_VLD = '1' then

                re_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(re_loop))-1,8));

                if mode_a_l = '1' and mode_b_l = '0'then      
                    re_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_l))+1,8));
                end if;

                if mode_b_l = '1' and mode_a_l = '0'then
                    re_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(re_addr_r))+1,8));
                end if;
                
                if mode_a_l = '1' and mode_b_l = '1' then
                    bias_index_wr <= std_logic_vector(to_unsigned(to_integer(unsigned(bias_index_wr))+1,6));
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
                elsif mode_b = '1' then
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
                mul_inn_ctl <= '1';
            elsif ve_start = '1' and addr_reload = '1' then --load vector engine's outer loop  and inner loop by the control of microinstructions, ring mode doesn't need a address reload
                if mode_a = '1' or mode_b = '1' then
                    ve_oloop <= ve_oloop_reg;
                    ve_loop  <= ve_loop_reg;
                    ve_addr_l <= ve_saddr_l;
                    ve_addr_r <= ve_saddr_r;
                elsif mode_c = '1' then
                    ve_loop <= x"09";
                end if;
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
                    mul_inn_ctl <= '0';
                elsif ve_loop /= (ve_loop'range => '0') then
                    ve_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_loop))-1,8));
                    ve_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_l)+1),8));
                    ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8)); --calculate right address;
                    mul_inn_ctl <= '1';
                end if;
            
            elsif ve_start_reg = '1' and ve_oloop = (ve_oloop'range => '0') then --outer loop is 0. Last loop.
                if ve_loop /= (ve_loop'range => '0') then
                    ve_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_loop))-1,8));
                    ve_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_l)+1),8));
                    ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8)); --calculate right address;
                    mul_inn_ctl <= '1';
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
                curr_ring_addr <= (others => '0');
            elsif reg_in = CONS_RING_START then --initial curr_ring
                curr_ring_addr <= YBUS;
            elsif re_start = '1' and mode_c = '1' and clk_e_pos = '1' then --clk_e synchronized
                if curr_ring_addr = ring_end_addr then
                    curr_ring_addr <= ring_start_addr;
                else
                    curr_ring_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))
                                                       +to_integer(unsigned(depth_l)),8));
                end if;
            elsif ve_start_reg = '1' and config(6) = '1' then
                if curr_ring_addr = ring_end_addr then
                    curr_ring_addr <= ring_start_addr;
                else
                    curr_ring_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))
                                                       +to_integer(unsigned(depth_l)),8));
                end if;
                --ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8));
            --else   --The two signals are also used in other processes
                --curr_ring_addr <= (others => 'Z');
                --ve_addr_r <= (others => 'Z');
            end if;
        end if;
    end process;

    --**********************
    --Address_MUX
    --**********************
    process(re_start_reg,re_source,mode_a_l,mode_b_l,ve_start,ve_start_reg,re_addr_l,re_addr_r,re_addr_a,re_addr_b,ve_addr_l,ve_addr_r)
    begin
        if re_start = '1' or ve_start = '1' then --Not latched instructions.
            if mode_c = '1' then
                addr_p_l <= curr_ring_addr;
                --addr_p_r <= ve_addr_r;  
            end if;

        elsif ve_start_reg = '1' then 
            if config(6) = '1' then
                addr_p_l <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+to_integer(unsigned(offset_l)),8));
                addr_p_r <= ve_addr_r;
            elsif config(6) = '0' then
                addr_p_l <= ve_addr_l;
                addr_p_r <= ve_addr_r;
            end if; 
                
        elsif re_start_reg = '1' and re_source = '0' then --Use receive engine's address counter l and r
            if mode_a_l = '1' and mode_b_l = '0' then
                addr_p_l <= re_addr_l;
            elsif mode_b_l = '1' and mode_a_l = '0' then
                addr_p_r <= re_addr_r;
            end if;

        elsif re_start_reg = '1' and re_source = '1' then --Use receive engine's address counter a and b --mode c added --2.0
            if mode_a_l = '1' then
                addr_p_l <= re_addr_a;
            elsif mode_b_l = '1' then
                addr_p_l <= re_addr_b;
            end if;

        end if;
    end process;

    --Write enable signal to srams
    --
    sram_l_we <= '1' when re_start = '1' and mode_c = '1' and clk_e_pos = '1' else
    '1' when re_start_reg = '1' and mode_a_l = '1' and mode_b_l = '0' else 
    '0';
    
    sram_r_we <= '1' when re_start_reg = '1' and mode_b_l = '1' and mode_a_l = '0' else
    '0' when re_start_reg = '0';
    
    addr_p_b <= bias_index_wr when sram_b_we = '1' else bias_index_rd(7 downto 2);

    sram_b_we <= '1' when re_start_reg = '1' and mode_a_l = '1' and mode_b_l = '1' else '0';

    --sram_we : process(clk_p)
    --begin
    --    --if rising_edge(clk_p) then
    --        if re_start_reg = '1' then
    --            if mode_a_l = '1' then
    --                sram_l_we <= '1';
    --            elsif mode_b_l = '1' then
    --                sram_r_we <= '1';
    --            end if;
    --        elsif re_start = '1' and mode_c = '1' then
    --            sram_l_we <= clk_e_pos;         --Enables only half time of clk_e cycle. POS or NEG TBA
    --        elsif re_start_reg = '0' then
    --            sram_l_we <= '0';
    --            sram_r_we <= '0';
    --        end if;
    --    --end if;
    --end process;

    RE_RDY <= not re_start_reg;
 sclr_i <= not RST or ve_clr_acc;
---------------------------------------------------------------
--Data Input MUX
---------------------------------------------------------------
--Left and right buffers
sram_in(7 downto 0) <= dfy_reg(0) when re_source = '1' else VE_IN(7 downto 0);
sram_in(15 downto 8) <= dfy_reg(1)when re_source = '1' else VE_IN(15 downto 8);
sram_in(23 downto 16) <= dfy_reg(2)when re_source = '1' else VE_IN(23 downto 16);
sram_in(31 downto 24) <= dfy_reg(3)when re_source = '1' else VE_IN(31 downto 24);
sram_in(39 downto 32) <= dfy_reg(4)when re_source = '1' else VE_IN(39 downto 32);
sram_in(47 downto 40) <= dfy_reg(5)when re_source = '1' else VE_IN(47 downto 40);
sram_in(55 downto 48) <= dfy_reg(6)when re_source = '1' else VE_IN(55 downto 48);
sram_in(63 downto 56) <= dfy_reg(7)when re_source = '1' else VE_IN(63 downto 56);
--Bias buffer --Always VE_IN



---------------------------------------------------------------
--multiplier control logic:
---------------------------------------------------------------
process(clk_p) --Enable control signal, synchronized by the data flow
begin
    if rising_edge(clk_p) then
        delay0 <= ve_start_reg;
        mult_delay <= delay0;
    end if;
end process;
 mctl_0 <= not mul_ctl(0) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_1 <= not mul_ctl(1) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_2 <= not mul_ctl(2) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_3 <= not mul_ctl(3) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_4 <= not mul_ctl(4) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_5 <= not mul_ctl(5) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_6 <= not mul_ctl(6) and ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_7 <= not mul_ctl(7) and ve_start_reg and mult_delay and mul_inn_ctl;
 process(clk_p)
 begin
     if rising_edge(clk_p) then
         a_delay <= mult_delay;
         acc_inn_ctl <= mul_inn_ctl;
     end if;
 end process;
 actl_0 <= not mul_ctl(0) and a_delay and delay0 and acc_inn_ctl ;
 actl_1 <= not mul_ctl(1) and a_delay and delay0 and acc_inn_ctl ;
 actl_2 <= not mul_ctl(2) and a_delay and delay0 and acc_inn_ctl ;
 actl_3 <= not mul_ctl(3) and a_delay and delay0 and acc_inn_ctl ;
 actl_4 <= not mul_ctl(4) and a_delay and delay0 and acc_inn_ctl ;
 actl_5 <= not mul_ctl(5) and a_delay and delay0 and acc_inn_ctl ;
 actl_6 <= not mul_ctl(6) and a_delay and delay0 and acc_inn_ctl ;
 actl_7 <= not mul_ctl(7) and a_delay and delay0 and acc_inn_ctl ;
 bypass <= '0';
---------------------------------------------------------------
--Zero point substractor, always active
---------------------------------------------------------------
--Left substractor
mul_in_l_0 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(7 downto 0)))-to_integer(unsigned(zp_data)),9));
mul_in_l_1 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(15 downto 8)))-to_integer(unsigned(zp_data)),9));
mul_in_l_2 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(23 downto 16)))-to_integer(unsigned(zp_data)),9));
mul_in_l_3 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(31 downto 24)))-to_integer(unsigned(zp_data)),9));
mul_in_l_4 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(39 downto 32)))-to_integer(unsigned(zp_data)),9));
mul_in_l_5 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(47 downto 40)))-to_integer(unsigned(zp_data)),9));
mul_in_l_6 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(55 downto 48)))-to_integer(unsigned(zp_data)),9));
mul_in_l_7 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_l(63 downto 56)))-to_integer(unsigned(zp_data)),9));

--Right substractor
mul_in_r_0 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(7 downto 0)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_1 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(15 downto 8)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_2 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(23 downto 16)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_3 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(31 downto 24)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_4 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(39 downto 32)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_5 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(47 downto 40)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_6 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(55 downto 48)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_7 <= std_logic_vector(to_signed(to_integer(unsigned(buf_out_r(63 downto 56)))-to_integer(unsigned(zp_weight)),9));

--Accumulator Latch
process(clk_p) --Enable signal, two clock delay after the acc_latch control signal is asserted.
begin
    if rising_edge(clk_p) then
        if ve_start = '1' and clk_e_pos = '0' then
            if acc_latch = '1' then
                delay1 <= '1';
            end if;
        elsif ve_start_reg= '1' and ve_loop = (ve_loop'range => '0') and config(0) = '1' then
            delay1 <= '1';
        else
            delay1 <= '0';
        end if;
        latch_ena <= delay1;
    end if;
end process;

process(clk_p)
begin 
    if rising_edge(clk_p) and latch_ena = '1' then
        acc_reg_0 <= acc_out_0;
        acc_reg_1 <= acc_out_1;
        acc_reg_2 <= acc_out_2;
        acc_reg_3 <= acc_out_3;
        acc_reg_4 <= acc_out_4;
        acc_reg_5 <= acc_out_5;
        acc_reg_6 <= acc_out_6;
        acc_reg_7 <= acc_out_7;
        acc_reg_a <= acc_out_a;
    end if;
end process;
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

---------------------------------------------------------------
--Post processing block
---------------------------------------------------------------
--Output source selector
process(clk_p) --create a 11 clock_delay for pp to pick up output words after vector engine finishes its execution.
begin
    if rising_edge (clk_p) then
        if rst = '0' then
            ve_out_p <= '0';
            delay3 <= (others => '0');
        else
            if  ve_start_reg = '1' and ve_loop = (ve_loop'range => '0') and ve_oloop = (ve_oloop'range => '0') then
            delay3(0) <= config(7);
            end if;
            
            for i in 0 to 8 loop
                delay3(i+1) <= delay3(i);
            end loop;
        end if;
            ve_out_p <= delay3(9);
    end if;
end process;
--Two modes
--For output from overall accumulator latch, this selector activates one clock.
--For output from unique accumulator latches, this mux activates eight clocks and select one accumulator latch in each clock cycle.
process(clk_p)
begin
    if rising_edge(clk_p) then
        if latch_ena = '1' then
            o_mux_ena <= '1';
        elsif ve_out_p = '0' then --11 clock delay of config(7)
            o_mux_ena <= '0';
        elsif ve_out_c = (ve_out_c'range => '1') then --reset the output enable signal
            o_mux_ena <= '0';
        end if;
    end if;
end process;

process(clk_p)
begin 
    if rising_edge(clk_p) and o_mux_ena = '1' then
        if ve_out_p = '0' then
            p_shifter_in <= acc_out_a;
        elsif ve_out_p = '1' then
            ve_out_c <= std_logic_vector(to_signed(to_integer(signed(ve_out_c))+1,3));
            if ve_out_c = x"0" then
                p_shifter_in <= acc_out_0;
            elsif ve_out_c = x"1" then
                p_shifter_in <= acc_out_1;
            elsif ve_out_c = x"2" then
                p_shifter_in <= acc_out_2;
            elsif ve_out_c = x"3" then
                p_shifter_in <= acc_out_3;
            elsif ve_out_c = x"4" then
                p_shifter_in <= acc_out_4;
            elsif ve_out_c = x"5" then
                p_shifter_in <= acc_out_5;
            elsif ve_out_c = x"6" then
                p_shifter_in <= acc_out_6;
            elsif ve_out_c = x"7" then
                p_shifter_in <= acc_out_7;
            end if;
        end if;
    end if;
end process;
                
--Post Shifter --maximum 16 bits, scale <= "10000"
process(clk_p) --Enable control, one clock delay of ourput selector
begin
    if rising_edge(clk_p) then
        pp_stage_1 <= o_mux_ena;
    end if;
end process;
shifter_ena <= pp_stage_1 and not pp_ctl(0);

process(clk_p)
    variable sh0, sh1, sh2, sh3, sh4: std_logic_vector(31 downto 0);
begin
    if rising_edge(clk_p) and shifter_ena = '1' then --and shifter_on = '0'
        if scale(4) = '0' then
            sh4 := p_shifter_in;
        elsif scale(4) = '1' then
            sh4(31 downto 16) :=(others => p_shifter_in(31));
            sh4(15 downto 0) := p_shifter_in(31 downto 16);
        end if;

        if scale(3) = '0' then
            sh3 := sh4;
        elsif scale(3) = '1' then
            sh3(31 downto 24):=(others => sh4(31));
            sh3(23 downto 0) := sh4(31 downto 8);
        end if;

        if scale(2) = '0' then
            sh2 := sh3;
        elsif scale(2) = '1' then
            sh2(31 downto 28):=(others => sh3(31));
            sh2(27 downto 0) := sh3(31 downto 4);
        end if;

        if scale(1) = '0' then
            sh1 := sh2;
        elsif scale(1) = '1' then
            sh1(31 downto 30):=(others => sh2(31));
            sh1(29 downto 0) := sh2(31 downto 2);
        end if;

        if scale(0) = '0' then
           sh0 := sh1;
        elsif scale(0) = '1' then
            sh0(31):= sh1(31);
            sh0(30 downto 0) := sh1(31 downto 1) ;
        end if;
        
        p_shifter_out <= sh0;
            ---------------------------
            ---------------------------
    end if;
end process;
--bias buffer --also activates at the clock cycle when shifter is activated, so shares the o_mux_ena signal
process(clk_p)
begin 
    if rising_edge(clk_p) then
        if reg_in = CONS_BIAS_INDEX_START then
            bias_index_rd <= YBUS;
        elsif o_mux_ena = '1' then
            bias_mux <= bias_index_rd (1 downto 0);
            if bias_index_rd = bias_index_end then
                bias_index_rd <= bias_index_start;
            else
                bias_index_rd <= std_logic_vector(to_unsigned(to_integer(unsigned(bias_index_rd))+1,8));
            end if;
        end if;
    end if;
end process;
bias_rd_ena <= o_mux_ena and not pp_ctl(1);
bias_mux_out <= bias_buf_out(16*(to_integer(unsigned(bias_mux)))+15 downto 16*(to_integer(unsigned(bias_mux))));
--Post Adder
process(clk_p) --Enable control, one clock delay adter shifter control.
begin
    if rising_edge(clk_p) then
        pp_stage_2 <= pp_stage_1;
    end if;
end process;

adder_ena <= pp_stage_1 and not pp_ctl(1);

process(clk_p) 
begin
    if rising_edge(clk_p) and adder_ena = '1' then
        p_adder_out <= std_logic_vector(to_signed(to_integer(signed(p_shifter_out))+to_integer(signed(bias_mux_out)),32));
    end if;
end process;


--Clip 8
process(clk_p) --Enable control, one clock delay after adder control.
begin
    if rising_edge(clk_p) then
        clip_ena <= adder_ena;
    end if;
end process; 
process(clk_p)
    variable diff : std_logic_vector(31 downto 0);
begin
    diff := std_logic_vector(to_signed(to_integer(signed(p_adder_out)) - 256,32));
    if rising_edge(clk_p) and clip_ena = '1' then
        if p_adder_out(31) = '1' then
            p_clip_out <= (others => '0');
        elsif diff(31) = '1' then
            p_clip_out <= (others => '1');
        else
            p_clip_out <= p_adder_out(7 downto 0);
        end if;
    end if;
end process;

    
---------------------------------------------------------------
--MEM, Multiplier and accumulator IPs
---------------------------------------------------------------
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
    A => mul_in_l_0,
    B => mul_in_r_0,
    P => mul_out_0
  );
  mul_1 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_1,
    A => mul_in_l_1,
    B => mul_in_r_1,
    P => mul_out_1
  );
  mul_2 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_2,
    A => mul_in_l_2,
    B => mul_in_r_2,
    P => mul_out_2
  );
  mul_3 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_3,
    A => mul_in_l_3,
    B => mul_in_r_3,
    P => mul_out_3
  );
  mul_4 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_4,
    A => mul_in_l_4,
    B => mul_in_r_4,
    P => mul_out_4
  );
  mul_5 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_5,
    A => mul_in_l_5,
    B => mul_in_r_5,
    P => mul_out_5
  );
  mul_6 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_6,
    A => mul_in_l_6,
    B => mul_in_r_6,
    P => mul_out_6
  );
  mul_7 : mult_gen_0
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_7,
    A => mul_in_l_7,
    B => mul_in_r_7,
    P => mul_out_7
  );
  --substract_i <= '0';
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
    a =>addr_p_r,
    d => sram_in,
    clk => clk_p,
    we => sram_r_we,
    spo => buf_out_r
  );
  buf_bias : dist_mem_gen_1
  PORT MAP (
    clk => clk_p,
    a => addr_p_b,
    spo => bias_buf_out,
    we => sram_b_we,
    d => VE_IN
  );



------------------------------------------------------------------------------
 --Output 
 ------------------------------------------------------------------------------
process(clk_p)
begin
    if rising_edge(clk_p) then
        output_ena <= clip_ena;
    end if;
end process;

process(clk_p)
begin
    if rising_edge(clk_p) then
        if RST = '0' then
            dfy_reg <= (others => (others => '0'));
            dtm_data_reg <= (others => (others => '0'));
            output_c <= (others => '0');
        elsif reg_in = CONS_DFY_REG_SHIFT_IN then --write feedback(dfy) register through y bus
            if clk_e_neg = '1' then
            dfy_reg(to_integer(unsigned(dfy_dest_sel))) <= YBUS;
            end if;
        elsif output_ena = '1' then --to feedback(dfy) register
            if pp_ctl(4 downto 3) = "01" then
                dfy_reg(to_integer(unsigned(output_c))) <= p_clip_out;
                if output_c = x"7" then
                    output_c <=(others => '0');
                else
                    output_c <= std_logic_vector(to_unsigned(to_integer(unsigned(output_c))+1,4));
                end if;
            elsif pp_ctl(4 downto 3) = "10" then --to DTM data register
                dtm_data_reg(to_integer(unsigned(output_c))) <= p_clip_out;
                output_c <= std_logic_vector(to_unsigned(to_integer(unsigned(output_c))+1,4));
            else --to dbus
                VE_OUT_D <= p_clip_out;
            end if;
        end if;
    end if;
    --output to dtm
    for i in 0 to 15 loop
        VE_OUT_DTM(8*i+7 downto 8*i) <= dtm_data_reg(i);
    end loop;
end process;


end architecture;  
                    

                 
    





