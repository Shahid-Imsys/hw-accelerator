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
use work.instructiontypes.all;
use work.vetypes.all;
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
        --Control outputs
        VE_DTM_RDY :           out std_logic;
        VE_PUSH_DTM :          out std_logic;
        VE_AUTO_SEND :         out std_logic;
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

--component ve_wctrlpipe
--  port(
--      -- general
--    clk : in std_logic;
--    reset : in std_logic;
--    -- in
--    data0_addr_i : in std_logic_vector(7 downto 0);
--    data1_addr_i : in std_logic_vector(7 downto 0);
--    weight_addr_i : in std_logic_vector(7 downto 0);
--    data_ren_i : in std_logic;
--    data_wen_i : in std_logic;
--    weight_ren_i : in std_logic;
--    weight_wen_i : in std_logic;
--
--    data0_i : in std_logic_vector(31 downto 0);
--    data1_i : in std_logic_vector(31 downto 0);
--    weight_i : in std_logic_vector(63 downto 0);
--
--    memreg_c_i : in memreg_ctrl;
--    writebuff_c_i : in memreg_ctrl;
--    inst_i : in instruction;
--    ppinst_i : in ppctrl_t;
--    ppshiftinst_i : in ppshift_shift_ctrl;
--    addbiasinst_i : in ppshift_addbias_ctrl;
--    clipinst_i : in ppshift_clip_ctrl;
--    lzod_i : in  lzod_ctrl;
--    zpdata_i : in std_logic_vector(7 downto 0);
--    zpweight_i : in std_logic_vector(7 downto 0);
--    bias_i : in std_logic_vector(31 downto 0);
--
--    -- out
--    data0_addr_o : out std_logic_vector(7 downto 0);
--    data1_addr_o : out std_logic_vector(7 downto 0);
--    weight_addr_o : out std_logic_vector(7 downto 0);
--    data_ren_o : out std_logic;
--    data_wen_o : out std_logic;
--    weight_ren_o : out std_logic;
--    weight_wen_o : out std_logic;
--
--    outreg_o : out std_logic_vector(63 downto 0);
--    writebuffer_o : out std_logic_vector(63 downto 0);
--
--    -- en
--    stall : in unsigned(3 downto 0) := (others => '0');
--    en_o : out std_logic
--  );
--end component;

component re
  port(
    clk              : in std_logic;
    rst              : in std_logic;
    clk_e_pos        : in std_logic;
    clk_e_neg        : in std_logic;
    mode_a           : in std_logic;
    mode_b           : in std_logic;
    mode_c           : in std_logic;
    data_valid       : in std_logic;
    re_start         : in std_logic;
    bias_addr_assign : in std_logic;
    re_source        : in std_logic;
    re_addr_reload   : in std_logic;
    re_loop_reg      : in std_logic_vector(7 downto 0);
    re_saddr_l       : in std_logic_vector(7 downto 0);
    re_saddr_r       : in std_logic_vector(7 downto 0);
    re_saddr_a       : in std_logic_vector(7 downto 0);
    re_saddr_b       : in std_logic_vector(7 downto 0);
    bias_index_start : in std_logic_vector(7 downto 0);
    re_ready         : out std_logic;
    write_en_data    : out std_logic;
    write_en_weight  : out std_logic;
    write_en_bias    : out std_logic;
    bias_index_wr    : out std_logic_vector(5 downto 0);
    re_addr_data     : out std_logic_vector(7 downto 0);
    re_addr_weight   : out std_logic_vector(7 downto 0)
  );
end component;

COMPONENT accumulator
  PORT (
    data : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mul
  PORT (
    CLK : IN STD_LOGIC;
    CE  : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
  );
END COMPONENT;

component mem is
  generic (
    width       : integer := 8;
    addressbits : integer := 2;
    columns     : integer := 4
    );
  port (
    clk       : in  std_logic;
    read_en   : in  std_logic;
    write_en  : in  std_logic;
    d_in      : in  std_logic_vector(width-1 downto 0);
    address   : in  std_logic_vector(addressbits-1 downto 0);
    d_out     : out std_logic_vector(width-1 downto 0)
  );
end component;

COMPONENT dist_ram0
  PORT (
    addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    di : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    do : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;
COMPONENT dist_ram1
  PORT (
    addr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    di : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    do : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
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
    signal re_addr_data   : std_logic_vector(7 downto 0);
    signal re_addr_weight : std_logic_vector(7 downto 0);
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
    signal offset_r    : std_logic_vector(7 downto 0); --right oprand offset register --expand to 8 bits, 1209
    signal jump_l    : std_logic_vector(7 downto 0);--Jump register
    signal depth_l   : std_logic_vector(7 downto 0);--depth register
    signal config    : std_logic_vector(7 downto 0); --configure register
    signal ring_end_addr : std_logic_vector(7 downto 0);
    signal ring_start_addr : std_logic_vector(7 downto 0);
    signal curr_ring_addr : std_logic_vector(7 downto 0);
    signal next_ring_addr : std_logic_vector(7 downto 0);
    signal zp_data    : std_logic_vector(7 downto 0); --zero point addition data
    signal zp_weight  : std_logic_vector(7 downto 0); --zero point addition data
    signal scale      : std_logic_vector(4 downto 0); --shift scale factor
    signal pp_ctl  : std_logic_vector(7 downto 0); --expand this 8 bits, 1209
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
    signal bias_addr_assign : std_logic; --enable signal for enbale the assignment of bias start address.
    signal re_addr_reload   : std_logic;
    signal ve_addr_reload   : std_logic;
    signal sclr_i        : std_logic; --For clear accumulator 0-7
    signal data0  : std_logic_vector(31 downto 0);
    signal data1  : std_logic_vector(31 downto 0);
    signal weight  : std_logic_vector(63 downto 0);
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
    signal writebuffer    : std_logic_vector(63 downto 0);
    signal bias_in    : std_logic_vector(63 downto 0);
    signal mode_a_l  : std_logic;
    signal mode_b_l  : std_logic;
    signal write_en_o  : std_logic;
    signal write_en_w_o  : std_logic;
    signal write_en_b_o  : std_logic;
    signal ve_clr_acc : std_logic; --clear accumulators
    signal mul_inn_ctl : std_logic;
    signal acc_inn_ctl : std_logic;
    signal pl_ve_byte : std_logic_vector(3 downto 0);


    signal data0addr_to_memory  : std_logic_vector(7 downto 0);
    signal weightaddr_to_memory  : std_logic_vector(7 downto 0);
    signal biasaddr_to_memory  : std_logic_vector(5 downto 0);
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
    signal output_c : std_logic_vector(3 downto 0); --output byte counter 
    signal sclr_i_delay : std_logic;
    signal mode_c_l : std_logic;
    --output control signals
    signal load_dtm_out : std_logic;
    signal send_req_d : std_logic;
    signal set_fifo_push : std_logic;
    signal read_en_o, read_en_w_o, read_en_b_o : std_logic;
    --signal ve_push_dtm : std_logic; --0126
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
    acc_latch <= PL(94); --ACCTOREG --To be removed
    re_source <= PL(96); --RE_DFY_SRC --
    reg_in    <= PL(105 downto 101);
    mode_a    <= PL(98);
    mode_b    <= PL(97);
    mode_c    <= PL(92);
    --addr_reload <= PL(99); 
    re_addr_reload <= PL(99);
    ve_addr_reload <= PL(107);
    ve_clr_acc <= PL(93);
    pl_ve_byte <= PL(112 downto 109);
    --
    reg_write: process(clk_p)
    begin
        if rising_edge(clk_p) then
            if clk_e_neg = '1' then --rising_edge of clk_e
                if RST = '0' then
                    re_saddr_l        <= (others => '0');
                    re_saddr_r        <= (others => '0');
                    re_loop_reg       <= (others => '0');
                    re_saddr_a        <= (others => '0'); 
                    re_saddr_b        <= (others => '0'); 
                    ve_saddr_l        <= (others => '0');
                    ve_saddr_r        <= (others => '0');
                    ve_loop_reg       <= (others => '0');
                    offset_l          <= (others => '0');  --Be aware of step and offset and depth!! --1125
                    offset_r          <= (others => '0');              --Make it 8 bits -1125
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
                    pp_ctl            <= (others => '0');  --Make it 8 bits
                    bias_index_end    <= (others => '0');
                    bias_index_start  <= (others => '0');
                    bias_addr_assign  <= '0';
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
                    --offset_r <= YBUS(0);
                    offset_r <= YBUS;
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
                    pp_ctl <= YBUS;
                elsif reg_in = CONS_BIAS_INDEX_END then
                    bias_index_end <= YBUS;
                elsif reg_in = CONS_BIAS_INDEX_START then
                    bias_index_start <= YBUS;
                    bias_addr_assign <= '1';
                elsif reg_in = CONS_MAC_SWITCH then
                    mul_ctl <= YBUS;
                else
                    bias_addr_assign <= '0';
                end if;
            end if;
        end if;
    end process;
    
    --Latched signals
    --Some signals from pl registers are latched for receive engine and vector engine to operate
    --without control from pl. Latched signals are cleared when loop registers goes to 0. 
    latch_signals: process(clk_p)
    begin
        if rising_edge(clk_p) then --latches at the rising_edge of clk_p. 
            if ve_start = '1' then
                ve_start_reg <= '1';
            elsif ve_loop = (ve_loop'range => '0') and ve_oloop = (ve_oloop'range => '0') then 
                ve_start_reg <= '0';
            end if;
            if ve_start = '1' and mode_c = '1' then
                mode_c_l <= '1';
            elsif ve_loop = (ve_loop'range => '0') and ve_oloop = (ve_oloop'range => '0') then
                mode_c_l <= '0';
            end if;
        end if;
    end process;
----------------------------------------------------------------------------------
--Address generation block
----------------------------------------------------------------------------------
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
                mul_inn_ctl <= '0';
            --Add reload function without starting the engine, 1210
            elsif ve_addr_reload = '1' and clk_e_pos = '1' then
                ve_loop <= ve_loop_reg;
                ve_oloop <= ve_oloop_reg;
                if mode_a = '1' then
                    ve_addr_l <= ve_saddr_l;
                end if;
                if mode_b = '1' then
                    ve_addr_r <= ve_saddr_r;
                end if;
            --1210
            elsif ve_start = '1' and ve_addr_reload = '1' then --load vector engine's outer loop  and inner loop by the control of microinstructions, ring mode doesn't need a address reload
                mul_inn_ctl <= '1';
                ve_oloop <= ve_oloop_reg;
                ve_loop  <= ve_loop_reg;
                if mode_a = '1' or mode_b = '1' then
                    if mode_a = '1' then                --- reload depending on mode.
                        ve_addr_l <= ve_saddr_l;
                    end if;
                    if mode_b = '1' then
                        ve_addr_r <= ve_saddr_r;
                    end if;
                end if;
            elsif ve_start_reg = '1' and ve_oloop /= (ve_oloop'range => '0')then --when outer loop is not 0, do self reload.
                --if ve_loop = (ve_loop'range => '0') then --acts when ve's inner loop counter goes to 0,
                mul_inn_ctl <= '1';
                if ve_loop = x"01" then --acts when ve's inner loop counter goes to 1, by Jonny,1210
                    ve_oloop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_oloop))-1,8));
                    mul_inn_ctl <= '0';
                end if;

                if ve_loop = (ve_loop'range => '0') then
                    if config(4) = '1' then --reload by config register, bit 4 in configure register
                    ve_loop <= ve_loop_reg;
                    end if;
                    if config(2) = '1' then 
                    ve_addr_l <= ve_saddr_l;
                    end if;
                    if config(3) = '1' then
                    ve_addr_r <= ve_saddr_r;
                    end if;
                    --mul_inn_ctl <= '0';
                elsif ve_loop /= (ve_loop'range => '0') then
                    ve_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_loop))-1,8));
                    ve_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_l)+1),8));
                    ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8)); --calculate right address;
                    --mul_inn_ctl <= '1';
                end if;
            
            elsif ve_start_reg = '1' and ve_oloop = (ve_oloop'range => '0') then --outer loop is 0. Last loop without self reloading process.
                if ve_loop /= (ve_loop'range => '0') then
                    ve_loop <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_loop))-1,8));
                    ve_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_l)+1),8));
                    ve_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_addr_r)+1),8)); --calculate right address;
                    mul_inn_ctl <= '1';
                    if ve_loop = x"01" then
                        mul_inn_ctl <= '0';
                    end if;
                end if;   
            end if;
        end if;
    end process;
    
    process(clk_p) --Added clock confinement for ve_rdy
    begin
        if rising_edge(clk_p) then
            if clk_e_pos = '0' then
                VE_RDY <= not ve_start_reg;--remove revert --1125 
            end if;
        end if;
    end process;
    
    --********************************
    --Mode c. Shared by RE and VE
    --********************************
    --How to control the right address?
    next_ring_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+ to_integer(unsigned(offset_l)),8));

    mode_c_addr: process(clk_p)
    begin
        if rising_edge(clk_p) then
            if RST = '0' then
                curr_ring_addr <= (others => '0');
            elsif reg_in = CONS_RING_START and CLK_E_NEG = '1' then --initial curr_ring
                curr_ring_addr <= YBUS;
            elsif ve_addr_reload = '1' then
                curr_ring_addr <= curr_ring_addr;
            elsif (re_start_reg = '1' and mode_c_l = '1') or (re_start = '1' and mode_c = '1' and clk_e_pos = '0') then --make this an automatic process --1215
                if next_ring_addr = ring_end_addr then --if ( ( (uint32_t)curr_ring_addr + (uint32_t)offset_l ) == (uint32_t)ring_end_addr  ) { // then
                    curr_ring_addr <= ring_start_addr;
                elsif (re_source = '0' and re_loop /= (re_loop'range => '0') and ddi_vld = '1') or re_source = '1' then
                    curr_ring_addr <= next_ring_addr;
                end if;
            elsif ve_start_reg = '1' and mode_c_l = '1' then
                if next_ring_addr = ring_end_addr then --if ( ( (uint32_t)curr_ring_addr + (uint32_t)offset_l ) == (uint32_t)ring_end_addr  ) { // then
                    curr_ring_addr <= ring_start_addr;
                elsif ve_loop /=(ve_loop'range => '0') then
                    curr_ring_addr <= next_ring_addr;
                end if;
            end if;
        end if;
    end process;

    --**********************
    --Address_MUX
    --**********************
    address_pointer_mux: process(all)
    begin
        if ve_start_reg = '1' then 
            weightaddr_to_memory <= ve_addr_r;
            if mode_c_l = '1' then
                data0addr_to_memory <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+to_integer(unsigned(depth_l)),8));
            else
                data0addr_to_memory <= ve_addr_l;
            end if; 
        else
            data0addr_to_memory <= re_addr_data;
            weightaddr_to_memory <= re_addr_weight;
        end if;
    end process;

    bias_address_mux: process(clk_p)
    begin
        if rising_edge(clk_p) then
            if rst = '0' then
                biasaddr_to_memory <= (others => '0');
            else
                if write_en_b_o = '1' then
                    biasaddr_to_memory <= bias_index_wr;
                else
                    if o_mux_ena = '1' then
                        biasaddr_to_memory <= bias_index_rd(7 downto 2);
                    end if;
                end if;
            end if;
        end if;
    end process;

    --Clear accumulator signal
    acc_clear:process(clk_p)
    begin 
        if rising_edge(clk_p) then
            sclr_i_delay <= '0';
            if ve_start_reg = '1' and ve_oloop /= (ve_oloop'range => '0') and ve_loop = (ve_loop'range => '0') then
                sclr_i_delay <= config(1);
            end if;
            sclr_i <= not RST or ve_clr_acc or sclr_i_delay;
        end if;
    end process;

    

---------------------------------------------------------------
--Data Input MUX
---------------------------------------------------------------
data_input: process(clk_p)
begin
    if rising_edge(clk_p) then
        writebuffer <= ve_in;
        bias_in <= writebuffer; --Bias buffer --Always VE_IN
        if re_source = '1' then
            writebuffer(7 downto 0) <= dfy_reg(0);
            writebuffer(15 downto 8) <= dfy_reg(1);
            writebuffer(23 downto 16) <= dfy_reg(2);
            writebuffer(31 downto 24) <= dfy_reg(3);
            writebuffer(39 downto 32) <= dfy_reg(4);
            writebuffer(47 downto 40) <= dfy_reg(5);
            writebuffer(55 downto 48) <= dfy_reg(6);
            writebuffer(63 downto 56) <= dfy_reg(7);
        end if;
    end if;
end process;

---------------------------------------------------------------
----------read mux ------ TBD ------- temp solution -----------
---------------------------------------------------------------
process(all)
begin
  if re_rdy = '1' then
    read_en_o <= '1';
    read_en_w_o <= '1';
    read_en_b_o <= '1';
  else
    read_en_o <= '0';
    read_en_w_o <= '0';
    read_en_b_o <= '0';
  end if;
end process;
----mul need to be fix, remove gap-----
---------------------------------------------------------------
--multiplier control logic:
---------------------------------------------------------------
process(clk_p) --Enable control signal, synchronized by the data flow
begin
    if rising_edge(clk_p) then
        delay0 <= ve_start_reg;
        mult_delay <= mul_inn_ctl;
    end if;
end process;
 mctl_0 <= not mul_ctl(0) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_1 <= not mul_ctl(1) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_2 <= not mul_ctl(2) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_3 <= not mul_ctl(3) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_4 <= not mul_ctl(4) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_5 <= not mul_ctl(5) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_6 <= not mul_ctl(6) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 mctl_7 <= not mul_ctl(7) and mult_delay;--ve_start_reg and mult_delay and mul_inn_ctl;
 process(clk_p)
 begin
     if rising_edge(clk_p) then
         a_delay <= delay0;
         delay3(0) <= a_delay;
         acc_inn_ctl <= mult_delay;
     end if;
 end process;
 actl_0 <= not mul_ctl(0) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_1 <= not mul_ctl(1) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_2 <= not mul_ctl(2) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_3 <= not mul_ctl(3) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_4 <= not mul_ctl(4) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_5 <= not mul_ctl(5) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_6 <= not mul_ctl(6) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 actl_7 <= not mul_ctl(7) and acc_inn_ctl;--and a_delay and delay0 and acc_inn_ctl ;
 bypass <= '0';

--Zero point substractor, always active

--Left substractor
mul_in_l_0 <= std_logic_vector(to_signed(to_integer(unsigned(data1(7 downto 0)))-to_integer(unsigned(zp_data)),9));
mul_in_l_1 <= std_logic_vector(to_signed(to_integer(unsigned(data1(15 downto 8)))-to_integer(unsigned(zp_data)),9));
mul_in_l_2 <= std_logic_vector(to_signed(to_integer(unsigned(data1(23 downto 16)))-to_integer(unsigned(zp_data)),9));
mul_in_l_3 <= std_logic_vector(to_signed(to_integer(unsigned(data1(31 downto 24)))-to_integer(unsigned(zp_data)),9));
mul_in_l_4 <= std_logic_vector(to_signed(to_integer(unsigned(data0(7 downto 0)))-to_integer(unsigned(zp_data)),9));
mul_in_l_5 <= std_logic_vector(to_signed(to_integer(unsigned(data0(15 downto 8)))-to_integer(unsigned(zp_data)),9));
mul_in_l_6 <= std_logic_vector(to_signed(to_integer(unsigned(data0(23 downto 16)))-to_integer(unsigned(zp_data)),9));
mul_in_l_7 <= std_logic_vector(to_signed(to_integer(unsigned(data0(31 downto 24)))-to_integer(unsigned(zp_data)),9));

--Right substractor
mul_in_r_0 <= std_logic_vector(to_signed(to_integer(unsigned(weight(7 downto 0)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_1 <= std_logic_vector(to_signed(to_integer(unsigned(weight(15 downto 8)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_2 <= std_logic_vector(to_signed(to_integer(unsigned(weight(23 downto 16)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_3 <= std_logic_vector(to_signed(to_integer(unsigned(weight(31 downto 24)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_4 <= std_logic_vector(to_signed(to_integer(unsigned(weight(39 downto 32)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_5 <= std_logic_vector(to_signed(to_integer(unsigned(weight(47 downto 40)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_6 <= std_logic_vector(to_signed(to_integer(unsigned(weight(55 downto 48)))-to_integer(unsigned(zp_weight)),9));
mul_in_r_7 <= std_logic_vector(to_signed(to_integer(unsigned(weight(63 downto 56)))-to_integer(unsigned(zp_weight)),9));

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
    if rising_edge(clk_p) then
        --if latch_ena = '1' then
        if acc_latch = '1' then --controlled by ucode directly --1217
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
    end if;
end process;
--Overall accumulator (Adder)
acc_out_a <= std_logic_vector(
                              unsigned(acc_out_0)+ 
                              unsigned(acc_out_1)+
                              unsigned(acc_out_2)+
                              unsigned(acc_out_3)+
                              unsigned(acc_out_4)+
                              unsigned(acc_out_5)+
                              unsigned(acc_out_6)+
                              unsigned(acc_out_7));

---------------------------------------------------------------
--Post processing block
---------------------------------------------------------------
--Output source selector
ve_out_p <= pp_ctl(0);
--process(clk_p) --create a 11 clock_delay for pp to pick up output words after vector engine finishes its execution.
--begin
--    if rising_edge (clk_p) then
--        if rst = '0' then
--            ve_out_p <= '0';
--            delay3 <= (others => '0');
--        else
--            if  ve_start_reg = '1' and ve_loop = (ve_loop'range => '0') and ve_oloop = (ve_oloop'range => '0') then
--            delay3(0) <= config(7);
--            end if;
--            
--            for i in 0 to 8 loop
--                delay3(i+1) <= delay3(i);
--            end loop; 
--                ve_out_p <= delay3(9);
--        end if;
--           
--    end if;
--end process;
--Two modes
--For output from overall accumulator latch, this selector activates one clock.
--For output from unique accumulator latches, this mux activates eight clocks and select one accumulator latch in each clock cycle.
process(clk_p)
begin
    if rising_edge(clk_p) then
        --if latch_ena = '1' then
            --o_mux_ena <= '1';
        if delay3(0) = '1' and a_delay = '1' and acc_inn_ctl = '1' and (delay0 = '0' or a_delay = '0' or mult_delay = '0') then
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
    if rising_edge(clk_p) then
        if rst = '0' then
            ve_out_c <= (others => '0');
        elsif o_mux_ena = '1' then
            if ve_out_p = '0' then
                p_shifter_in <= acc_out_a;
            elsif ve_out_p = '1' then
                ve_out_c <= std_logic_vector(to_signed(to_integer(signed(ve_out_c))+1,3));
                if ve_out_c = "000" then
                    p_shifter_in <= acc_out_0;
                elsif ve_out_c = "001" then
                    p_shifter_in <= acc_out_1;
                elsif ve_out_c = "010" then
                    p_shifter_in <= acc_out_2;
                elsif ve_out_c = "011" then
                    p_shifter_in <= acc_out_3;
                elsif ve_out_c = "100" then
                    p_shifter_in <= acc_out_4;
                elsif ve_out_c = "101" then
                    p_shifter_in <= acc_out_5;
                elsif ve_out_c = "110" then
                    p_shifter_in <= acc_out_6;
                elsif ve_out_c = "111" then
                    p_shifter_in <= acc_out_7;
                end if;
            end if;
        end if;
        --end if;
    end if;
end process;
                
--Post Shifter --maximum 16 bits, scale <= "10000"
process(clk_p) --Enable control, one clock delay of ourput selector
begin
    if rising_edge(clk_p) then
        pp_stage_1 <= o_mux_ena;
    end if;
end process;
shifter_ena <= pp_stage_1;-- and not pp_ctl(0); --1217

process(clk_p)
    variable sh0, sh1, sh2, sh3, sh4: std_logic_vector(31 downto 0);
begin
    if rising_edge(clk_p) then
        if shifter_ena = '1' then --and shifter_on = '0'
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
    end if;
end process;
--bias buffer --also activates at the clock cycle when shifter is activated, so shares the o_mux_ena signal
process(clk_p)
begin 
    if rising_edge(clk_p) then
        if reg_in = CONS_BIAS_INDEX_START then
            bias_index_rd <= YBUS;
--        elsif o_mux_ena = '1' then         
        elsif pp_stage_1 = '1' then
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

adder_ena <= pp_stage_2 and not pp_ctl(1);

process(clk_p) 
begin
    if rising_edge(clk_p) then
        if adder_ena = '1' then -------------- It is fine that p_adder_out being truncated --------------
            p_adder_out <= std_logic_vector(to_signed(to_integer(signed(p_shifter_out))+to_integer(signed(bias_mux_out)),32));
        else
            p_adder_out <= p_shifter_out;
        end if;
    end if;
end process;


--Clip 8
process(clk_p) --Enable control, one clock delay after adder control.
begin
    if rising_edge(clk_p) then
        clip_ena <= adder_ena;
    end if;
end process; 
process(clk_p,p_adder_out)
    variable diff : std_logic_vector(31 downto 0);
begin       ---------------- Truncating here doesn't hurt ----------------
    diff := std_logic_vector(to_signed(to_integer(signed(p_adder_out)) - 256,32));
    if rising_edge(clk_p) then
        if clip_ena = '1' then
            if p_adder_out(31) = '1' then     --Negative
                p_clip_out <= (others => '0');
            elsif diff(31) = '0' then         --? maybe 0?
                p_clip_out <= (others => '1');
            else
                p_clip_out <= p_adder_out(7 downto 0);
            end if;
        end if;
    end if;
end process;

    
---------------------------------------------------------------
--MEM, Multiplier and accumulator IPs
---------------------------------------------------------------
accu_0 : accumulator
  PORT MAP (
    data => mul_out_0,
    CLK => CLK_P,
    CE => actl_0,
    reset => sclr_i,
    sum => acc_out_0
  );
  accu_1 : accumulator
  PORT MAP (
    data => mul_out_1,
    CLK => CLK_P,
    CE => actl_1,
    reset => sclr_i,
    sum => acc_out_1
  );
  accu_2 : accumulator
  PORT MAP (
    data => mul_out_2,
    CLK => CLK_P,
    CE => actl_2,
    reset => sclr_i,
    sum => acc_out_2
  );
  accu_3 : accumulator
  PORT MAP (
    data => mul_out_3,
    CLK => CLK_P,
    CE => actl_3,
    reset => sclr_i,
    sum => acc_out_3
  );
  accu_4 : accumulator
  PORT MAP (
    data => mul_out_4,
    CLK => CLK_P,
    CE => actl_4,
    reset => sclr_i,
    sum => acc_out_4
  );
  accu_5 : accumulator
  PORT MAP (
    data => mul_out_5,
    CLK => CLK_P,
    CE => actl_5,
    reset => sclr_i,
    sum => acc_out_5
  );
  accu_6 : accumulator
  PORT MAP (
    data => mul_out_6,
    CLK => CLK_P,
    CE => actl_6,
    reset => sclr_i,
    sum => acc_out_6
  );
  accu_7 : accumulator
  PORT MAP (
    data => mul_out_7,
    CLK => CLK_P,
    CE => actl_7,
    reset => sclr_i,
    sum => acc_out_7
  );
  mul_0 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_0,
    A => mul_in_l_0,
    B => mul_in_r_0,
    P => mul_out_0
  );
  mul_1 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_1,
    A => mul_in_l_1,
    B => mul_in_r_1,
    P => mul_out_1
  );
  mul_2 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_2,
    A => mul_in_l_2,
    B => mul_in_r_2,
    P => mul_out_2
  );
  mul_3 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_3,
    A => mul_in_l_3,
    B => mul_in_r_3,
    P => mul_out_3
  );
  mul_4 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_4,
    A => mul_in_l_4,
    B => mul_in_r_4,
    P => mul_out_4
  );
  mul_5 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_5,
    A => mul_in_l_5,
    B => mul_in_r_5,
    P => mul_out_5
  );
  mul_6 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_6,
    A => mul_in_l_6,
    B => mul_in_r_6,
    P => mul_out_6
  );
  mul_7 : mul
  PORT MAP (
    CLK => CLK_P,
    CE  => mctl_7,
    A => mul_in_l_7,
    B => mul_in_r_7,
    P => mul_out_7
  );
--data mem(splited in high and low part)--
  databuf_0 : mem
  generic map(
    width       => 32,
    addressbits => 8,
    columns     => 2
  )
  port map (
    clk       => clk_p,
    read_en   => read_en_o,
    write_en  => write_en_o,
    d_in      => writebuffer(63 downto 32),
    address   => data0addr_to_memory,
    d_out     => data0
  );
  databuf_1 : mem
  generic map(
    width       => 32,
    addressbits => 8,
    columns     => 2
  )
  port map(
    clk       => clk_p,
    read_en   => read_en_o,
    write_en  => write_en_o,
    d_in      => writebuffer(31 downto 0),
    address   => data0addr_to_memory,
    d_out     => data1
  );
--bias mem--
  buf_bias : mem
  generic map(
    width       => 64,
    addressbits => 6,
    columns     => 4
  )
  port map(
    clk       => clk_p,
    read_en   => read_en_b_o,
    write_en  => write_en_b_o,
    d_in      => bias_in,--writebuffer,
    address   => biasaddr_to_memory,
    d_out     => bias_buf_out
  );
--weight mem--
  buf_weight : mem
  generic map (
    width       => 64,
    addressbits => 8,
    columns     => 4
  )
  port map (
    clk       => clk_p,
    read_en   => read_en_w_o,
    write_en  => write_en_w_o,
    d_in      => writebuffer,
    address   => weightaddr_to_memory,
    d_out     => weight
  );

  re_i : re
  port map(
    clk              => clk_p,
    rst              => rst,
    clk_e_pos        => clk_e_pos,
    clk_e_neg        => clk_e_neg,
    mode_a           => mode_a,
    mode_b           => mode_b,
    mode_c           => mode_c,
    data_valid       => DDI_VLD,
    re_start         => re_start,
    bias_addr_assign => bias_addr_assign,
    re_source        => re_source,
    re_addr_reload   => re_addr_reload,
    re_loop_reg      => re_loop_reg,
    re_saddr_l       => re_saddr_l,
    re_saddr_r       => re_saddr_r,
    re_saddr_a       => re_saddr_a,
    re_saddr_b       => re_saddr_b,
    bias_index_start => bias_index_start,
    re_ready         => re_rdy,
    write_en_data    => write_en_o,
    write_en_weight  => write_en_w_o,
    write_en_bias    => write_en_b_o,
    bias_index_wr    => bias_index_wr,
    re_addr_data     => re_addr_data,
    re_addr_weight   => re_addr_weight
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

process(clk_p,dtm_data_reg)
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
        elsif output_ena = '1' then 
            if pp_ctl(4 downto 3) = "01" then --to feedback(dfy) register
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

        if pp_ctl(4 downto 3) = "10" and output_c(1 downto 0) = "11" and output_ena = '1' then
            load_dtm_out <= '1';
        else
            load_dtm_out <= '0';
        end if;
        set_fifo_push <= load_dtm_out;
    end if;
    --output to dtm
    for i in 0 to 15 loop
        VE_OUT_DTM(8*i+7 downto 8*i) <= dtm_data_reg(i);
    end loop;
end process;

dtm_ctl_out: process(pp_ctl,load_dtm_out,set_fifo_push)
begin
    if pp_ctl(5) = '1' then
        ve_dtm_rdy <= load_dtm_out;
    else
        ve_dtm_rdy <= '0';
    end if;

    if pp_ctl(6) = '1' then
        ve_push_dtm <= load_dtm_out;
    else
        ve_push_dtm <= '0';
    end if;

    ve_auto_send <= pp_ctl(7);
end process;

end architecture;  
                    

                 
    





