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
-- Date                                 Version         Author  Description
-- 2021-5-19                 1.0             CJ                 Created
--2021-9-16              2.0         CJ         Advanced address generation and post processing block added
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instructiontypes.all;
use work.vetypes.all;
--use work.cluster_pkg.all;

entity ve is
  generic(
    USE_ASIC_MEMORIES : boolean := true
    );
  port(
    --Control inputs
    CLK_P        : in std_logic;
    CLK_E_POS    : in std_logic;
    CLK_E_NEG    : in std_logic;
    RST          : in std_logic;
    PL           : in std_logic_vector(127 downto 0);
    YBUS         : in std_logic_vector(7 downto 0);  -- Y bus
    --DFY        : in std_logic_vector(63 downto 0);
    DDI_VLD      : in  std_logic;       --input data valid, from CC
    --Control outputs
    RE_RDY       : out std_logic;  --Receive engine ready. Activates when re_loop is zero.
    VE_RDY       : out std_logic;  --Vector engine ready. Activates when ve_loop is zero.
    --Data inputs
    VE_IN        : in  std_logic_vector(63 downto 0);  --DFM input
    --Control outputs
    VE_DTM_RDY   : out std_logic;
    VE_PUSH_DTM  : out std_logic;
    VE_AUTO_SEND : out std_logic;
    --Data outputs
    VE_OUT_D     : out std_logic_vector(7 downto 0);   --Output to DSL
    VE_OUT_DTM   : out std_logic_vector(127 downto 0)  --Output to MMR Block
    );
end entity ve;

architecture rtl of ve is

  component ve_wctrlpipe
    port(
      -- general
      clk : in std_logic;
      -- in
      data0_addr_i : in std_logic_vector(7 downto 0);
      data1_addr_i : in std_logic_vector(7 downto 0);
      weight_addr_i : in std_logic_vector(7 downto 0);
      bias_addr_i : in std_logic_vector(7 downto 0);
      bias_addr_ctrl_i : in bias_addr_t;
      data_ren_i : in std_logic;
      data_wen_i : in std_logic;
      weight_ren_i : in std_logic;
      weight_wen_i : in std_logic;
      bias_ren_i : in std_logic;

      data0_i : in std_logic_vector(31 downto 0);
      data1_i : in std_logic_vector(31 downto 0);
      weight_i : in std_logic_vector(63 downto 0);

      memreg_c_i : in memreg_ctrl;
      writebuff_c_i : in memreg_ctrl;
      inst_i : in instruction;
      ppinst_i : in ppctrl_t;
      ppshiftinst_i : in ppshift_shift_ctrl;
      addbiasinst_i : in ppshift_addbias_ctrl;
      clipinst_i : in ppshift_clip_ctrl;
      lzod_i : in  lzod_ctrl;
      feedback_ctrl_i : in feedback_t;
      zpdata_i : in std_logic_vector(7 downto 0);
      zpweight_i : in std_logic_vector(7 downto 0);
      bias_i : in std_logic_vector(63 downto 0);

      -- out
      data0_addr_o : out std_logic_vector(7 downto 0);
      data1_addr_o : out std_logic_vector(7 downto 0);
      weight_addr_o : out std_logic_vector(7 downto 0);
      bias_addr_o : out std_logic_vector(5 downto 0);
      data_ren_o : out std_logic;
      data_wen_o : out std_logic;
      weight_ren_o : out std_logic;
      weight_wen_o : out std_logic;
      bias_ren_o : out std_logic;

      outreg_o : out std_logic_vector(63 downto 0);
      writebuffer_o : out std_logic_vector(63 downto 0);

      -- en
      stall : in unsigned(3 downto 0) := (others => '0');
      en_o : out std_logic
      );
  end component;

  component mem256x32 is
    port (
      clk      : in  std_logic;
      read_en  : in  std_logic;
      write_en : in  std_logic;
      d_in     : in  std_logic_vector(31 downto 0);
      address  : in  std_logic_vector(7 downto 0);
      d_out    : out std_logic_vector(31 downto 0)
      );
  end component;

  component mem256x64 is
    port (
      clk      : in  std_logic;
      read_en  : in  std_logic;
      write_en : in  std_logic;
      d_in     : in  std_logic_vector(63 downto 0);
      address  : in  std_logic_vector(7 downto 0);
      d_out    : out std_logic_vector(63 downto 0)
      );
  end component;

  component mem64x64 is
    port (
      clk      : in  std_logic;
      read_en  : in  std_logic;
      write_en : in  std_logic;
      d_in     : in  std_logic_vector(63 downto 0);
      address  : in  std_logic_vector(5 downto 0);
      d_out    : out std_logic_vector(63 downto 0)
      );
  end component;

  component SNPS_RF_SP_UHS_256x64 is
    port (
      Q        : out std_logic_vector(63 downto 0);
      ADR      : in  std_logic_vector(7 downto 0);
      D        : in  std_logic_vector(63 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_RF_SP_UHS_256x32 is
    port (
      Q        : out std_logic_vector(31 downto 0);
      ADR      : in  std_logic_vector(7 downto 0);
      D        : in  std_logic_vector(31 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

  component SNPS_RF_SP_UHS_64x64 is
    port (
      Q        : out std_logic_vector(63 downto 0);
      ADR      : in  std_logic_vector(5 downto 0);
      D        : in  std_logic_vector(63 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;

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
      re_busy          : out std_logic;
      write_en_data    : out std_logic;
      write_en_weight  : out std_logic;
      write_en_bias    : out std_logic;
      mode_c_l         : out std_logic;
      bias_index_wr    : out std_logic_vector(5 downto 0);
      re_loop_counter  : out std_logic_vector(7 downto 0);
      re_addr_data     : out std_logic_vector(7 downto 0);
      re_addr_weight   : out std_logic_vector(7 downto 0)
  );
  end component;

  component convcontroller
    port(
      clk              : in std_logic;
      rst              : in std_logic;
      clk_e_pos        : in std_logic;
      start            : in std_logic;
      mode_a           : in std_logic;
      mode_b           : in std_logic;
      mode_c           : in std_logic;
      addr_reload      : in std_logic;
      bias_addr_assign : in std_logic;
      config           : in std_logic_vector(7 downto 0);
      pp_ctl           : in std_logic_vector(7 downto 0);
      conv_saddr_l     : in std_logic_vector(7 downto 0);
      conv_saddr_r     : in std_logic_vector(7 downto 0);
      loop_counter     : in std_logic_vector(7 downto 0);
      oloop_counter    : in std_logic_vector(7 downto 0);
      bias_index_start : in std_logic_vector(7 downto 0);
      bias_index_end   : in std_logic_vector(7 downto 0);
      scale            : in std_logic_vector(4 downto 0);
      conv_loop_ctr    : out std_logic_vector(7 downto 0);
      data_addr        : out std_logic_vector(7 downto 0);
      weight_addr      : out std_logic_vector(7 downto 0);
      bias_addr        : out std_logic_vector(7 downto 0);
      bias_mux         : out std_logic_vector(1 downto 0);
      mode_c_l         : out std_logic;
      data_rd_en       : out std_logic;
      data_wr_en       : out std_logic;
      weight_rd_en     : out std_logic;
      weight_wr_en     : out std_logic;
      enable_shift     : out std_logic;
      enable_add_bias  : out std_logic;
      enable_clip      : out std_logic;
      memreg_c         : out memreg_ctrl;
      writebuff_c      : out memreg_ctrl;
      inst             : out instruction;
      ppinst           : out ppctrl_t;
      ppshiftinst      : out ppshift_shift_ctrl;
      addbiasinst      : out ppshift_addbias_ctrl;
      clipinst         : out ppshift_clip_ctrl;
      busy             : out std_logic
    );
  end component;

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
  --Shared signals
  signal mode_a : std_logic; --mode A activate
  signal mode_b : std_logic; --mode B activate
  signal mode_c : std_logic; --Vector engine mode c;
  signal mode_d : std_logic; --Vector engine mode d;
  signal remode_c_l : std_logic; --receive engine's mode c latch signal
  signal vemode_c_l : std_logic; --vector engine's mode c latch signal
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
  signal re_busy : std_logic; --RE start latch
  signal conv_busy : std_logic; --VE start latch
  signal bias_addr_assign : std_logic; --enable signal for enbale the assignment of bias start address.
  signal re_addr_reload   : std_logic;
  signal ve_addr_reload   : std_logic;
  signal data0  : std_logic_vector(31 downto 0);
  signal data1  : std_logic_vector(31 downto 0);
  signal weight  : std_logic_vector(63 downto 0);
  signal bias_buf_out : std_logic_vector(63 downto 0);
  signal bias_mux_out : std_logic_vector(31 downto 0);
  signal bias_mux     : std_logic_vector(1 downto 0);
  signal bypass     : std_logic;
  signal writebuffer    : std_logic_vector(63 downto 0);
  signal mem_data_in : std_logic_vector(63 downto 0);
  signal bias_in    : std_logic_vector(63 downto 0);
  signal mode_a_l  : std_logic;
  signal mode_b_l  : std_logic;
  signal write_en_o, write_en_w_o, write_en_b_o  : std_logic;
  signal ve_clr_acc : std_logic; --clear accumulators
  signal pl_ve_byte : std_logic_vector(3 downto 0);


  signal data0addr_to_memory : std_logic_vector(7 downto 0);
  signal data1addr_to_memory : std_logic_vector(7 downto 0);
  signal weightaddr_to_memory : std_logic_vector(7 downto 0);
  signal biasaddr_to_memory : std_logic_vector(5 downto 0);
  --data flow control signals
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
  signal mode_c_l : std_logic;
  --output control signals
  signal load_dtm_out : std_logic;
  signal send_req_d : std_logic;
  signal set_fifo_push : std_logic;
  signal read_en_o, read_en_w_o, read_en_b_o : std_logic;
  signal data_read_enable_i   : std_logic;
  signal weight_read_enable_i : std_logic;
  signal memreg_c_i : memreg_ctrl;
  signal writebuff_c_i : memreg_ctrl;
  signal inst_i : instruction;
  signal ppinst_i : ppctrl_t;
  signal ppshiftinst_i : ppshift_shift_ctrl;
  signal addbiasinst_i : ppshift_addbias_ctrl;
  signal clipinst_i : ppshift_clip_ctrl;
  signal lzod_i : lzod_ctrl;
  signal feedback_ctrl_i : feedback_t;
  signal outreg : std_logic_vector(63 downto 0);
  signal stall : unsigned(3 downto 0) := (others => '0');
  signal en_i : std_logic;
  signal data0_addr_o : std_logic_vector(7 downto 0);
  signal data1_addr_o : std_logic_vector(7 downto 0);
  signal weight_addr_o : std_logic_vector(7 downto 0);
  signal bias_addr_o : std_logic_vector(5 downto 0);
  signal conv_done_pipe : std_logic_vector(5 downto 0);
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
  signal a_delay : std_logic;
  signal delay3 : std_logic_vector(9 downto 0);


begin
  --Microcode translation
  --Some microinstructions are latched to registers and operates at clk_p frequency. 
  --Not latched signals are used only in one microinstruction time (clk_e) together with 
  --re_start and ve_start signals and mode abcd or relaod signal. 
  dfy_dest_sel   <= PL (118 downto 116); --DEST_BYTE
  re_start       <= PL(100);
  ve_start       <= PL(95); --VE_ST
  --acc_latch      <= PL(94); --ACCTOREG --To be removed
  re_source      <= PL(96); --RE_DFY_SRC --
  reg_in         <= PL(105 downto 101);
  mode_a         <= PL(98);
  mode_b         <= PL(97);
  mode_c         <= PL(92);
  --addr_reload <= PL(99); 
  re_addr_reload <= PL(99);
  ve_addr_reload <= PL(107);
  ve_clr_acc     <= PL(93);
  pl_ve_byte     <= PL(112 downto 109);
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
    
  mode_c_l <= remode_c_l or vemode_c_l;

  process(clk_p)
  begin
    if rising_edge(clk_p) then
      if clk_e_pos = '0' then
        re_rdy <= not re_busy;
      end if;
    end if;
  end process;

  process(clk_p) --Added clock confinement for ve_rdy
  begin
    if rising_edge(clk_p) then
      conv_done_pipe(0) <= not conv_busy;
      for i in 0 to 4 loop
        conv_done_pipe(i+1) <= conv_done_pipe(i);
      end loop;
      if clk_e_pos = '0' then
        ve_rdy <= not conv_busy;--conv_done_pipe(0);
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
      elsif (re_busy = '1' and mode_c_l = '1') or (re_start = '1' and mode_c = '1' and clk_e_pos = '0') then --make this an automatic process --1215
        if next_ring_addr = ring_end_addr then --if ( ( (uint32_t)curr_ring_addr + (uint32_t)offset_l ) == (uint32_t)ring_end_addr  ) { // then
          curr_ring_addr <= ring_start_addr;
        elsif (re_source = '0' and re_loop = x"01" and ddi_vld = '1') or re_source = '1' then --/= (re_loop'range => '0') and ddi_vld = '1') or re_source = '1' then
          curr_ring_addr <= next_ring_addr;
        end if;
      elsif conv_busy = '1' and mode_c_l = '1' then
        if next_ring_addr = ring_end_addr then --if ( ( (uint32_t)curr_ring_addr + (uint32_t)offset_l ) == (uint32_t)ring_end_addr  ) { // then
          curr_ring_addr <= ring_start_addr;
        elsif ve_loop = x"01" then--/=(ve_loop'range => '0') then
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
    biasaddr_to_memory <= bias_index_wr;
    if conv_done_pipe(5) = '0' or conv_busy = '1' then 
      weightaddr_to_memory <= weight_addr_o;
      if conv_done_pipe(5) = '0' then
        biasaddr_to_memory <= bias_addr_o;
      end if;
      if mode_c_l = '1' then
        data0addr_to_memory <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+to_integer(unsigned(depth_l)),8));
        data1addr_to_memory <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+to_integer(unsigned(depth_l)),8));
      else
        data0addr_to_memory <= data0_addr_o;
        data1addr_to_memory <= data1_addr_o;
      end if; 
    else
      weightaddr_to_memory <= re_addr_weight;
      
      if mode_c_l = '1' then
        data0addr_to_memory <= curr_ring_addr;
        data1addr_to_memory <= curr_ring_addr;
      else
        data0addr_to_memory <= re_addr_data;
        data1addr_to_memory <= re_addr_data;
      end if;
    end if;
  end process;

  --bias_address_mux: process(clk_p)
  --begin
  --  if rising_edge(clk_p) then
  --    if rst = '0' then
  --      biasaddr_to_memory <= (others => '0');
  --    else
  --      if write_en_b_o = '1' then
  --        biasaddr_to_memory <= bias_index_wr;
  --      else
  --        --if ve_loop = x"01" then
  --          biasaddr_to_memory <= bias_addr_o;--bias_index_rd(7 downto 2);
  --        --end if;
  --      end if;
  --    end if;
  --  end if;
  --end process;

---------------------------------------------------------------
--Data Input MUX
---------------------------------------------------------------
  data_input: process(clk_p)
  begin
    if rising_edge(clk_p) then
      mem_data_in <= ve_in;
      bias_in <= ve_in;--mem_data_in; --Bias buffer --Always VE_IN
      if re_source = '1' then
        mem_data_in(7 downto 0) <= dfy_reg(0);
        mem_data_in(15 downto 8) <= dfy_reg(1);
        mem_data_in(23 downto 16) <= dfy_reg(2);
        mem_data_in(31 downto 24) <= dfy_reg(3);
        mem_data_in(39 downto 32) <= dfy_reg(4);
        mem_data_in(47 downto 40) <= dfy_reg(5);
        mem_data_in(55 downto 48) <= dfy_reg(6);
        mem_data_in(63 downto 56) <= dfy_reg(7);
      end if;
    end if;
  end process;

---------------------------------------------------------------
----------read mux ------ TBD ------- temp solution -----------
---------------------------------------------------------------
  process(all)
  begin
    if re_busy = '0' then
      data_read_enable_i <= '1';
      weight_read_enable_i <= '1';
      --read_en_b_o <= '1';
    else
      data_read_enable_i <= '0';
      weight_read_enable_i <= '0';
      --read_en_b_o <= '0';
    end if;
  end process;

  bypass <= '0';

--bias data selector
  bias_mux_out <= (x"0000" & bias_buf_out(16*(to_integer(unsigned(bias_mux)))+15 downto 16*(to_integer(unsigned(bias_mux)))));
---------------------------------------------------------------
--MEM, Multiplier and accumulator IPs
---------------------------------------------------------------
  buf_asic_gen : if USE_ASIC_MEMORIES generate
--data mem(splited in high and low part)--
    databuf_0 : SNPS_RF_SP_UHS_256x32
      port map (
        Q        => data0,
        ADR      => data0addr_to_memory,
        D        => mem_data_in(63 downto 32),
        WE       => write_en_o,
        ME       => '1',
        CLK      => clk_p,
        TEST1    => '0',
        TEST_RNM => '0',
        RME      => '0',
        RM       => (others => '0'),
        WA       => (others => '0'),
        WPULSE   => (others => '0'),
        LS       => '0',
        BC0      => '0',
        BC1      => '0',
        BC2      => '0');

    databuf_1 : SNPS_RF_SP_UHS_256x32
      port map (
        Q        => data1,
        ADR      => data1addr_to_memory,
        D        => mem_data_in(31 downto 0),
        WE       => write_en_o,
        ME       => '1',
        CLK      => clk_p,
        TEST1    => '0',
        TEST_RNM => '0',
        RME      => '0',
        RM       => (others => '0'),
        WA       => (others => '0'),
        WPULSE   => (others => '0'),
        LS       => '0',
        BC0      => '0',
        BC1      => '0',
        BC2      => '0');

--weight mem--
    buf_weight : SNPS_RF_SP_UHS_256x64
      port map (
        Q        => weight,
        ADR      => weightaddr_to_memory,
        D        => mem_data_in,
        WE       => write_en_w_o,
        ME       => '1',
        CLK      => clk_p,
        TEST1    => '0',
        TEST_RNM => '0',
        RME      => '0',
        RM       => (others => '0'),
        WA       => (others => '0'),
        WPULSE   => (others => '0'),
        LS       => '0',
        BC0      => '0',
        BC1      => '0',
        BC2      => '0');

--bias mem--
    buf_bias : SNPS_RF_SP_UHS_64x64
      port map (
        Q        => bias_buf_out,
        ADR      => biasaddr_to_memory,
        D        => bias_in,            --writebuffer
        WE       => write_en_b_o,
        ME       => '1',
        CLK      => clk_p,
        TEST1    => '0',
        TEST_RNM => '0',
        RME      => '0',
        RM       => (others => '0'),
        WA       => (others => '0'),
        WPULSE   => (others => '0'),
        LS       => '0',
        BC0      => '0',
        BC1      => '0',
        BC2      => '0');
  end generate;

  buf_sim_gen : if not USE_ASIC_MEMORIES generate
--data mem(splited in high and low part)--
    databuf_0 : mem256x32
      port map (
        clk      => clk_p,
        read_en  => read_en_o,
        write_en => write_en_o,
        d_in     => mem_data_in(63 downto 32),
        address  => data0addr_to_memory,
        d_out    => data0
        );
    databuf_1 : mem256x32
      port map(
        clk      => clk_p,
        read_en  => read_en_o,
        write_en => write_en_o,
        d_in     => mem_data_in(31 downto 0),
        address  => data1addr_to_memory,
        d_out    => data1
        );
--weight mem--
    buf_weight : mem256x64
      port map (
        clk      => clk_p,
        read_en  => read_en_w_o,
        write_en => write_en_w_o,
        d_in     => mem_data_in,
        address  => weightaddr_to_memory,
        d_out    => weight
        );

--bias mem--
    buf_bias : mem64X64
      port map(
        clk      => clk_p,
        read_en  => read_en_b_o,
        write_en => write_en_b_o,
        d_in     => bias_in,            --writebuffer,
        address  => biasaddr_to_memory,
        d_out    => bias_buf_out
        );
  end generate;

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
    re_busy          => re_busy,
    write_en_data    => write_en_o,
    write_en_weight  => write_en_w_o,
    write_en_bias    => write_en_b_o,
    mode_c_l         => remode_c_l,
    bias_index_wr    => bias_index_wr,
    re_loop_counter  => re_loop,
    re_addr_data     => re_addr_data,
    re_addr_weight   => re_addr_weight
  );

  convcontroller_i : convcontroller
  port map(
    clk              => clk_p,
    rst              => rst,
    clk_e_pos        => clk_e_pos,
    start            => ve_start,
    mode_a           => mode_a,
    mode_b           => mode_b,
    mode_c           => mode_c,
    addr_reload      => ve_addr_reload,
    bias_addr_assign => bias_addr_assign,
    config           => config,
    pp_ctl           => pp_ctl,
    conv_saddr_l     => ve_saddr_l,
    conv_saddr_r     => ve_saddr_r,
    loop_counter     => ve_loop_reg,
    oloop_counter    => ve_oloop_reg,
    bias_index_start => bias_index_start,
    bias_index_end   => bias_index_end,
    scale            => scale,
    conv_loop_ctr    => ve_loop,
    data_addr        => ve_addr_l,
    weight_addr      => ve_addr_r,
    bias_addr        => bias_index_rd,
    bias_mux         => bias_mux,
    mode_c_l         => vemode_c_l,
    data_rd_en       => open, -----------
    data_wr_en       => open, -- TBD
    weight_rd_en     => open, --
    weight_wr_en     => open, -----------
    enable_shift     => shifter_ena,
    enable_add_bias  => adder_ena,
    enable_clip      => clip_ena,
    memreg_c         => memreg_c_i,
    writebuff_c      => writebuff_c_i,
    inst             => inst_i,
    ppinst           => ppinst_i,
    ppshiftinst      => ppshiftinst_i,
    addbiasinst      => addbiasinst_i,
    clipinst         => clipinst_i,
    busy             => conv_busy
  );

  ve_wctrlpipe_inst : ve_wctrlpipe
    port map(
      clk              => clk_p,
      data0_addr_i     => ve_addr_l,     --data0_addr_i,
      data1_addr_i     => ve_addr_l,     --data1_addr_i,
      weight_addr_i    => ve_addr_r,     --weight_addr_i,
      bias_addr_i      => bias_index_rd, 
      bias_addr_ctrl_i => ctrl,
      data_ren_i       => data_read_enable_i,
      data_wen_i       => write_en_o,    --data_write_enable_i,
      weight_ren_i     => weight_read_enable_i,
      weight_wen_i     => write_en_w_o,  --weight_write_enable_i, 
      bias_ren_i       => '1',
      data0_i          => data0,
      data1_i          => data1,
      weight_i         => weight,
      memreg_c_i       => memreg_c_i,
      writebuff_c_i    => writebuff_c_i,
      inst_i           => inst_i,
      ppinst_i         => ppinst_i,
      ppshiftinst_i    => ppshiftinst_i,
      addbiasinst_i    => addbiasinst_i,
      clipinst_i       => clipinst_i,
      lzod_i           => lzod_i,
      feedback_ctrl_i  => feedback_ctrl_i,
      zpdata_i         => zp_data,
      zpweight_i       => zp_weight,
      bias_i           => bias_buf_out,
      data0_addr_o     => data0_addr_o,
      data1_addr_o     => data1_addr_o,  -- for now data0 and 1 use the same address.
      weight_addr_o    => weight_addr_o,
      bias_addr_o      => bias_addr_o,
      data_ren_o       => read_en_o,
      data_wen_o       => open,          --data_write_enable_o,
      weight_ren_o     => read_en_w_o,
      weight_wen_o     => open,          --weight_write_enable_o,
      bias_ren_o       => read_en_b_o,
      outreg_o         => outreg,
      writebuffer_o    => writebuffer,
      stall            => stall,
      en_o             => en_i
      );

------------------------------------------------------------------------------
  --Output 
------------------------------------------------------------------------------
  process(clk_p)
  begin
    if rising_edge(clk_p) then
      delay3(0) <= clip_ena;
      for i in 0 to 5 loop
        delay3(i+1) <= delay3(i);
      end loop;
        output_ena <= delay3(4); 
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
          dfy_reg(to_integer(unsigned(output_c))) <= outreg(7 downto 0);
          if output_c = x"7" then
            output_c <=(others => '0');
          else
            output_c <= std_logic_vector(to_unsigned(to_integer(unsigned(output_c))+1,4));
          end if;
        elsif pp_ctl(4 downto 3) = "10" then --to DTM data register
          dtm_data_reg(to_integer(unsigned(output_c))) <= outreg(7 downto 0);
          output_c <= std_logic_vector(to_unsigned(to_integer(unsigned(output_c))+1,4));
        else --to dbus
          VE_OUT_D <= outreg(7 downto 0);
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

  dtm_ctl_out : process(pp_ctl, load_dtm_out, set_fifo_push)
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
