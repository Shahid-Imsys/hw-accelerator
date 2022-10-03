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
use work.mpgmfield_lib.all;
--use work.cluster_pkg.all;

entity ve is
  generic(
    USE_ASIC_MEMORIES : boolean := false
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
      clk              : in std_logic;
      -- in
      data0_addr_i     : in std_logic_vector(7 downto 0);
      data1_addr_i     : in std_logic_vector(7 downto 0);
      weight_addr_i    : in std_logic_vector(7 downto 0);
      bias_addr_i      : in std_logic_vector(7 downto 0);
      bias_addr_ctrl_i : in bias_addr_t;
      data_ren_i       : in std_logic;
      data_wen_i       : in std_logic;
      weight_ren_i     : in std_logic;
      weight_wen_i     : in std_logic;
      bias_ren_i       : in std_logic;

      data0_i          : in std_logic_vector(31 downto 0);
      data1_i          : in std_logic_vector(31 downto 0);
      weight_i         : in std_logic_vector(63 downto 0);
  
      memreg_c_i       : in memreg_ctrl;
      writebuff_c_i    : in memreg_ctrl;
      inst_i           : in instruction;
      ppinst_i         : in ppctrl_t;
      ppshiftinst_i    : in ppshift_shift_ctrl;
      addbiasinst_i    : in ppshift_addbias_ctrl;
      clipinst_i       : in ppshift_clip_ctrl;
      lzod_i           : in lzod_ctrl;
      feedback_ctrl_i  : in feedback_t;
      zpdata_i         : in std_logic_vector(7 downto 0);
      zpweight_i       : in std_logic_vector(7 downto 0);
      bias_i           : in std_logic_vector(63 downto 0);
      -- out
      data0_addr_o     : out std_logic_vector(7 downto 0);
      data1_addr_o     : out std_logic_vector(7 downto 0);
      weight_addr_o    : out std_logic_vector(7 downto 0);
      bias_addr_o      : out std_logic_vector(5 downto 0);
      data_ren_o       : out std_logic;
      data_wen_o       : out std_logic;
      weight_ren_o     : out std_logic;
      weight_wen_o     : out std_logic;
      bias_ren_o       : out std_logic;
      outreg_o         : out std_logic_vector(63 downto 0);
      writebuffer_o    : out std_logic_vector(63 downto 0);
      -- en
      stall            : in unsigned(3 downto 0) := (others => '0');
      en_o             : out std_logic
    );
  end component;

  component mem is
    generic (
      load_filename : string;
      width         : integer := 32;
      addressbits   : integer := 2;
      columns       : integer := 4
      );
    port (
      clk      : in  std_logic;
      read_en  : in  std_logic;
      write_en : in  std_logic;
      d_in     : in  std_logic_vector(width-1 downto 0);
      address  : in  std_logic_vector(addressbits-1 downto 0);
      d_out    : out std_logic_vector(width-1 downto 0);
      load_mem : in std_logic
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

  component addressing_unit
    generic (
      simulation : boolean := true
      );
    port(
      clk          : in std_logic;
      rst          : in std_logic;
      load         : in std_logic;
      cmp          : in au_param;
      add_offset   : in au_param;
      baseaddress  : in std_logic_vector(7 downto 0);
      finaladdress : out std_logic_vector(7 downto 0)
    );
  end component;

  component re
    port(
      clk             : in std_logic;
      rst             : in std_logic;
      clk_e_pos       : in std_logic;
      mode_a          : in std_logic;
      mode_b          : in std_logic;
      mode_c          : in std_logic;
      data_valid      : in std_logic;
      re_start        : in std_logic;
      re_source       : in std_logic;
      cnt_rst         : in std_logic;
      wr_counter      : in std_logic_vector(7 downto 0);
      re_busy         : out std_logic;
      write_en_data   : out std_logic;
      write_en_weight : out std_logic;
      write_en_bias   : out std_logic;
      mode_c_l        : out std_logic;
      left_rst        : out std_logic;
      right_rst       : out std_logic;
      bias_rst        : out std_logic;
      left_load       : out std_logic;
      right_load      : out std_logic;
      bias_load       : out std_logic;
      apushback_rst   : out std_logic;
      bpushback_rst   : out std_logic;
      apushback_load  : out std_logic;
      bpushback_load  : out std_logic
    );
  end component;

  component convcontroller
    port(
      clk              : in std_logic;
      rst              : in std_logic;
      clk_e_pos        : in std_logic;
      start            : in std_logic;
      cnt_rst          : in std_logic;
      mode_a           : in std_logic;
      mode_b           : in std_logic;
      mode_c           : in std_logic;
      config           : in std_logic_vector(7 downto 0);
      pp_ctl           : in std_logic_vector(7 downto 0);
      dot_cnt          : in std_logic_vector(7 downto 0);
      oc_cnt           : in std_logic_vector(7 downto 0);
      bias_au_addr     : in std_logic_vector(7 downto 0);
      bias_index_end   : in std_logic_vector(7 downto 0);
      scale            : in std_logic_vector(4 downto 0);
      mode_c_l         : out std_logic;
      load             : out std_logic;
      rd_en            : out std_logic;
      left_rst         : out std_logic;
      right_rst        : out std_logic;
      bias_load        : out std_logic; 
      bias_rd_en       : out std_logic;
      bias_rst         : out std_logic;
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

  component fftcontroller
    port(
      clk          : in  std_logic;
      en           : in  std_logic;
      start        : in  std_logic;
      stages       : in  unsigned(2 downto 0);  -- N = 2^(stages + 2), at most 7
      data0addr    : out std_logic_vector(7 downto 0);
      data1addr    : out std_logic_vector(7 downto 0);
      tfaddr       : out std_logic_vector(7 downto 0);
      read_en      : out std_logic;
      write_en     : out std_logic;
      memreg_c     : out memreg_ctrl;
      writebuff_c  : out memreg_ctrl;
      done         : out std_logic;
      finalstage   : out std_logic;
      inst_arith   : out instruction;
      inst_add     : out ppctrl_t;
      inst_shift   : out ppshift_shift_ctrl;
      inst_addbias : out ppshift_addbias_ctrl;
      inst_clip    : out ppshift_clip_ctrl;
      stall        : out unsigned(3 downto 0)
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
  signal start, conv_start, fft_start : std_logic;
  signal lau_activate, rau_activate, bau_activate, activate_from_re : std_logic;
  signal dfy_dest_sel : std_logic_vector(3 downto 0);
  --signal mac_switch : std_logic;
  --Shared signals
  signal mode_a : std_logic; --mode A activate
  signal mode_b : std_logic; --mode B activate
  signal mode_c : std_logic; --Vector engine mode c;
  signal mode_d : std_logic; --Vector engine mode d;
  signal remode_c_l : std_logic; --receive engine's mode c latch signal
  signal vemode_c_l : std_logic; --vector engine's mode c latch signal
  signal reload : std_logic; --reload address counters 
  signal reg_in : std_logic_vector(5 downto 0); --parameter register set field, including loop counter.
  signal rv_switch : std_logic; --Used to control VE's work mode, RE mode or VE mode.
    
  --------------------------------
  --Registers
  --------------------------------
  signal dfy_reg   : dfy_word;    --pushback(DFY) register
  signal dtm_data_reg : dtm_word;
  signal mode_latch : mode;
  signal fft_read_state : read_state;
  signal au_lcmp, au_loffset, au_rcmp, au_roffset, au_bcmp, au_boffset : au_param;
  signal pa_cmp, pa_offset, pb_offset, pb_cmp : au_param;
  signal re_saddr_l, re_saddr_r  : std_logic_vector(7 downto 0); --Receive engine's left starting address when DFM is used as the source
  signal re_loop_reg : std_logic_vector(7 downto 0); --receive engine's loop counter register
  signal re_loop : std_logic_vector(7 downto 0); --receive engine's loop counter
  signal re_saddr_a, re_saddr_b   : std_logic_vector(7 downto 0); --Receive engine mode A start address when DFY is used as the source 
  signal ve_saddr_l, ve_saddr_r  : std_logic_vector(7 downto 0); --Left starting address register
  signal left_baseaddress, right_baseaddress : std_logic_vector(7 downto 0);
  signal left_finaladdress, right_finaladdress, bias_finaladdress : std_logic_vector(7 downto 0);
  signal apushback_finaladdress, bpushback_finaladdress : std_logic_vector(7 downto 0);
  signal ve_loop, ve_oloop, dot_cnt, oc_cnt     : std_logic_vector(7 downto 0);
  signal ve_loop_reg, ve_oloop_reg : std_logic_vector(7 downto 0);
  signal ve_fftaddr_d0, ve_fftaddr_d1, ve_fftaddr_tf : std_logic_vector(7 downto 0);
  signal fft_stages : unsigned(2 downto 0);
  signal fft_en, fft_done, finalstage : std_logic;
  signal left_loading, right_loading, bias_loading : std_logic;
  signal left_rst, right_rst, bias_rst : std_logic;
  signal lrst_from_conv, rrst_from_conv, brst_from_conv : std_logic;
  signal lrst_from_re, rrst_from_re, brst_from_re : std_logic;
  signal lload_from_re, rload_from_re, bload_from_re : std_logic;
  signal load_from_conv, bload_from_conv : std_logic;
  signal apushback_load, bpushback_load, apushback_rst, bpushback_rst : std_logic;
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
  signal data0_addr_i, data1_addr_i : std_logic_vector(7 downto 0);
  signal weight_addr_i, bias_addr_i : std_logic_vector(7 downto 0);
  signal bias_index_rd, bias_index_wr : std_logic_vector(7 downto 0);
  signal bias_addr_o : std_logic_vector(5 downto 0);
  signal fw_layer   : std_logic_vector(23 downto 0); --feed forward layer, 24 bits.
  signal mul_ctl   : std_logic_vector(7 downto 0); --turn off the multipliers.
  signal re_ready : std_logic; --RE start latch
  signal conv_busy : std_logic; --VE start latch
  signal re_cnt_rst, conv_cnt_rst, cnt_rst  : std_logic;
  signal conv_enable : std_logic;
  signal data0  : std_logic_vector(31 downto 0);
  signal data1  : std_logic_vector(31 downto 0);
  signal weight  : std_logic_vector(63 downto 0);
  signal bias_buf_out : std_logic_vector(63 downto 0);
  signal bypass     : std_logic;
  signal writebuffer : std_logic_vector(63 downto 0);
  signal mem_data_in, data_to_mem : std_logic_vector(63 downto 0);
  signal bias_in    : std_logic_vector(63 downto 0);
  signal ve_out_reg, fft_result : std_logic_vector(127 downto 0);
  signal mode_a_l  : std_logic;
  signal mode_b_l  : std_logic;
  signal read_en_b_i : std_logic;
  signal data_write_enable_i, weight_write_enable_i : std_logic;
  signal write_en_o, write_en_w_o, write_en_b_o  : std_logic;
  signal dwen_from_re, wwen_from_re, bwen_from_re : std_logic;
  signal read_en_to_mux, read_en_w_to_mux, read_en_b_to_mux : std_logic;
  signal write_en_to_mux, write_en_w_to_mux : std_logic;
  signal ve_clr_acc : std_logic; --clear accumulators
  signal pl_ve_byte : std_logic_vector(3 downto 0);
  --fft test data
  constant fft256_rand_data0  : string := "fft256_data0.dat";
  constant fft256_rand_data1  : string := "fft256_data1.dat";
  constant fft256_rand_weight : string := "fft256_weight.dat";
  constant fftcopy            : string := "fftcopy.dat";


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
  signal rdout_addr_data, rdout_addr_weight : std_logic_vector(7 downto 0);
  signal doutrd_en, woutrd_en : std_logic;
  signal dmem_read_done, wmem_read_done : std_logic;
  signal data_read_enable_i   : std_logic;
  signal weight_read_enable_i : std_logic;
  signal rd_en_conv, b_rd_en_conv : std_logic;
  signal fft_read_en, fft_write_en : std_logic;
  signal memreg_c_i       : memreg_ctrl;
  signal conv_memreg_c    : memreg_ctrl;
  signal fft_memreg_c     : memreg_ctrl;
  signal writebuff_c_i    : memreg_ctrl;
  signal conv_writebuff_c : memreg_ctrl;
  signal fft_writebuff_c  : memreg_ctrl;
  signal inst_i           : instruction;
  signal conv_inst        : instruction;
  signal fft_inst         : instruction;
  signal ppinst_i         : ppctrl_t;
  signal conv_ppinst      : ppctrl_t;
  signal fft_ppinst       : ppctrl_t;
  signal ppshiftinst_i    : ppshift_shift_ctrl;
  signal conv_ppshiftinst : ppshift_shift_ctrl;
  signal fft_ppshiftinst  : ppshift_shift_ctrl;
  signal addbiasinst_i    : ppshift_addbias_ctrl;
  signal conv_addbiasinst : ppshift_addbias_ctrl;
  signal fft_addbiasinst  : ppshift_addbias_ctrl;
  signal clipinst_i       : ppshift_clip_ctrl;
  signal conv_clipinst    : ppshift_clip_ctrl;
  signal fft_clipinst     : ppshift_clip_ctrl;
  signal outreg : std_logic_vector(63 downto 0);
  signal stall : unsigned(3 downto 0) := (others => '0');
  signal en_i : std_logic;
  signal data0_addr_o : std_logic_vector(7 downto 0);
  signal data1_addr_o : std_logic_vector(7 downto 0);
  signal weight_addr_o : std_logic_vector(7 downto 0);
  signal fft_done_pipe : std_logic_vector(10 downto 0);
  --signal ve_push_dtm : std_logic; --0126

  --constant CONS_MAC_SWITCH       : std_logic_vector(4 downto 0) := "1"&x"f"; --write the multiplier control register
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
  dfy_dest_sel   <= PL(119 downto 116); --DEST_BYTE
  start          <= PL(95); 
  rv_switch      <= PL(94); -- RE mode or VE mode
  re_source      <= PL(96); --RE_DFY_SRC --
  reg_in         <= PL(105 downto 100);
  mode_a         <= PL(98);
  mode_b         <= PL(97);
  mode_c         <= PL(92);
  cnt_rst        <= PL(99); 
  conv_enable    <= PL(107);
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
          mul_ctl           <= (others => '0'); 
          au_lcmp           <= (others => (others => '0'));
          au_loffset        <= (others => (others => '0'));
          au_rcmp           <= (others => (others => '0'));
          au_roffset        <= (others => (others => '0'));
          au_bcmp           <= (others => (others => '0'));
          au_boffset        <= (others => (others => '0'));
          pa_cmp            <= (others => (others => '0'));
          pa_offset         <= (others => (others => '0'));
          pb_cmp            <= (others => (others => '0'));
          pb_offset         <= (others => (others => '0'));
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
        elsif reg_in = CONS_AU_LOFFSET0 then
          au_loffset(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LOFFSET1 then
          au_loffset(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LOFFSET2 then
          au_loffset(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LOFFSET3 then
          au_loffset(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LCMP0 then
          au_lcmp(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LCMP1 then
          au_lcmp(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LCMP2 then
          au_lcmp(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_LCMP3 then
          au_lcmp(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_ROFFSET0 then
          au_roffset(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_ROFFSET1 then
          au_roffset(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_ROFFSET2 then
          au_roffset(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_ROFFSET3 then
          au_roffset(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_RCMP0 then
          au_rcmp(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_RCMP1 then
          au_rcmp(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_RCMP2 then
          au_rcmp(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_RCMP3 then
          au_rcmp(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BOFFSET0 then
          au_boffset(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BOFFSET1 then
          au_boffset(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BOFFSET2 then
          au_boffset(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BOFFSET3 then
          au_boffset(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BCMP0 then
          au_bcmp(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BCMP1 then
          au_bcmp(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BCMP2 then
          au_bcmp(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_BCMP3 then
          au_bcmp(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PACMP0 then
          pa_cmp(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PACMP1 then
          pa_cmp(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PACMP2 then
          pa_cmp(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PACMP3 then
          pa_cmp(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PAOFFSET0 then
          pa_offset(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PAOFFSET1 then
          pa_offset(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PAOFFSET2 then
          pa_offset(2) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PAOFFSET3 then
          pa_offset(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PBCMP0 then
          pb_cmp(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PBCMP1 then
          pb_cmp(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PBCMP2 then
          pb_cmp(2) <= unsigned(YBUS);
        --elsif reg_in = CONS_AU_PBCMP3 then   -- parameter field fulled 
        --  pb_cmp(3) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PBOFFSET0 then
          pb_offset(0) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PBOFFSET1 then
          pb_offset(1) <= unsigned(YBUS);
        elsif reg_in = CONS_AU_PBOFFSET2 then
          pb_offset(2) <= unsigned(YBUS);
        --elsif reg_in = CONS_AU_PBOFFSET3 then   -- parameter field fulled 
        --  pb_offset(3) <= unsigned(YBUS);
        end if;
      end if;
    end if;
  end process;
    
  mode_c_l <= remode_c_l or vemode_c_l;

  process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        re_rdy <= '1';
      elsif clk_e_pos = '0' then
        re_rdy <= not re_ready;
      end if;
    end if;
  end process;

  process(clk_p) --Added clock confinement for ve_rdy
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        ve_rdy <= '1';
      elsif clk_e_pos = '0' then
        ve_rdy <= not conv_busy and fft_done;--fft_done_pipe(10);
      end if;
    end if;
  end process;
  
  RE_VE_switch : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rv_switch = '1' and ve_rdy = '1' then
        mode_latch <= re_mode;
      else
        if re_rdy = '1' and ve_rdy = '1' then
          if ve_clr_acc = '1' and rv_switch = '0' then  
            mode_latch <= fft;
          elsif conv_enable = '1' and rv_switch = '0' then
            mode_latch <= conv;
          elsif ve_clr_acc = '1' and conv_enable = '1' and rv_switch = '0' then
            mode_latch <= matrix;
          end if;
        end if;
      end if;
    end if;
  end process;

  fft_en <= '1' when mode_latch = fft else '0'; -- more enable signals should be added to controllers later to reduce power consumption.

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
      elsif cnt_rst = '1' then
        curr_ring_addr <= curr_ring_addr;
      elsif (re_ready = '0' and mode_c_l = '1') or (re_start = '1' and mode_c = '1' and clk_e_pos = '0') then --make this an automatic process --1215
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
  AUparam_mux : process(all)
  begin
    case mode_latch is 
      when re_mode => left_baseaddress  <= re_saddr_l;                                                    
                      right_baseaddress <= re_saddr_r; 
                      left_loading <= lload_from_re;
                      right_loading <= rload_from_re;
                      bias_loading <= bload_from_re;
      when conv    => left_baseaddress  <= ve_saddr_l;
                      right_baseaddress <= ve_saddr_r;
                      left_loading <= load_from_conv;
                      right_loading <= load_from_conv;
                      bias_loading <= bload_from_conv;
      when others  => left_baseaddress  <= x"00";
                      right_baseaddress <= x"00";
                      left_loading <= '0';
                      right_loading <= '0';
                      bias_loading <= '0';
    end case;
  end process;

  data_to_mem_mux : process(all)
  begin
    case mode_latch is
      when re_mode => data_to_mem <= mem_data_in when re_source = '0' 
                                                 else (dfy_reg(7) & dfy_reg(6) & dfy_reg(5) & dfy_reg(4) &
                                                       dfy_reg(3) & dfy_reg(2) & dfy_reg(1) & dfy_reg(0));
      when others  => data_to_mem <= writebuffer; 
    end case;
  end process;

  addrfromctrl_pointer_mux : process(all)
  begin
    case mode_latch is
      when re_mode => data0_addr_i  <= x"00";
                      data1_addr_i  <= x"00";
                      weight_addr_i <= x"00";
                      bias_addr_i   <= x"00"; 
      when conv    => data0_addr_i  <= left_finaladdress;
                      data1_addr_i  <= left_finaladdress;
                      weight_addr_i <= right_finaladdress;
                      bias_addr_i   <= bias_finaladdress; 
      when fft     => data0_addr_i  <= ve_fftaddr_d0;
                      data1_addr_i  <= ve_fftaddr_d1;
                      weight_addr_i <= ve_fftaddr_tf;
                      bias_addr_i   <= x"00";
      when others  => data0_addr_i  <= x"00";
                      data1_addr_i  <= x"00";
                      weight_addr_i <= x"00";
                      bias_addr_i   <= x"00";
    end case;
  end process;
  
  addrtomem_pointer_mux: process(all)
  begin
    case mode_latch is 
      when re_mode => biasaddr_to_memory <= bias_finaladdress(5 downto 0);
                      weightaddr_to_memory <= right_finaladdress;
                        if mode_c_l = '1' then
                          data0addr_to_memory <= curr_ring_addr;
                          data1addr_to_memory <= curr_ring_addr;
                        else
                          data0addr_to_memory <= left_finaladdress;
                          data1addr_to_memory <= left_finaladdress;
                          if re_source = '1' and mode_a = '1' then
                            data0addr_to_memory <= apushback_finaladdress;
                            data1addr_to_memory <= apushback_finaladdress;
                          elsif re_source = '1' and mode_b = '1' then
                            data0addr_to_memory <= bpushback_finaladdress;
                            data1addr_to_memory <= bpushback_finaladdress;
                          end if;
                        end if;
      when conv    => biasaddr_to_memory <= bias_addr_o;
                      weightaddr_to_memory <= weight_addr_o;
                        if mode_c_l = '1' then
                          data0addr_to_memory <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+to_integer(unsigned(depth_l)),8));
                          data1addr_to_memory <= std_logic_vector(to_unsigned(to_integer(unsigned(curr_ring_addr))+to_integer(unsigned(depth_l)),8));
                        else
                          data0addr_to_memory <= data0_addr_o;
                          data1addr_to_memory <= data1_addr_o;
                        end if; 
      when fft     => if fft_done_pipe(10) = '1' then
                        weightaddr_to_memory <= rdout_addr_weight;
                        data0addr_to_memory  <= rdout_addr_data;
                        data1addr_to_memory  <= rdout_addr_data;
                      else
                        weightaddr_to_memory <= weight_addr_o;
                        data0addr_to_memory  <= data0_addr_o;
                        data1addr_to_memory  <= data1_addr_o;
                      end if;
      when others  => biasaddr_to_memory <= bias_addr_o;
                      weightaddr_to_memory <= weight_addr_o;
                      data0addr_to_memory  <= data0_addr_o;
                      data1addr_to_memory  <= data1_addr_o;-- for now
    end case;
  end process;

  --bias_address_mux: process(all)
  --begin
  --  if rst = '0' then
  --    bias_addr_i <= (others => '0');
  --  else
  --    if bwen_from_re = '1' then
  --      bias_addr_i <= bias_finaladdress;
  --    else
  --      if ve_loop = x"01" then
  --        bias_addr_i <= bias_index_rd;
  --      end if;
  --    end if;
  --  end if;
  --end process;

  start_demux : process(all)
  begin
    conv_start     <= '0';
    fft_start      <= '0';
    re_start       <= '0';
    left_rst       <= '0';
    right_rst      <= '0';
    bias_rst       <= '0';
    dot_cnt        <= x"00";
    oc_cnt         <= x"00";
    re_loop        <= x"00";
    fft_stages     <= "000";
    re_cnt_rst     <= '0';
    conv_cnt_rst   <= '0';
    case mode_latch is
      when conv    => conv_start     <= start;
                      conv_cnt_rst   <= cnt_rst;
                      dot_cnt        <= ve_loop_reg;
                      oc_cnt         <= ve_oloop_reg;
                      left_rst       <= lrst_from_conv;
                      right_rst      <= rrst_from_conv;
                      bias_rst       <= brst_from_conv;
      when fft     => fft_start      <= start;
                      fft_stages     <= unsigned(ve_loop_reg(2 downto 0));
      when re_mode => re_start       <= start;
                      re_cnt_rst     <= cnt_rst;
                      re_loop        <= ve_loop_reg;
                      left_rst       <= lrst_from_re;
                      right_rst      <= rrst_from_re;
                      bias_rst       <= brst_from_re;
      when others  => null;
    end case;
  end process;

  instruction_mux : process(all)
  begin
    case mode_latch is
      when conv   => memreg_c_i    <= conv_memreg_c;
                     writebuff_c_i <= conv_writebuff_c;
                     inst_i        <= conv_inst;
                     ppinst_i      <= conv_ppinst;
                     ppshiftinst_i <= conv_ppshiftinst;
                     addbiasinst_i <= conv_addbiasinst;
                     clipinst_i    <= conv_clipinst;
      when fft    => memreg_c_i    <= fft_memreg_c;
                     writebuff_c_i <= fft_writebuff_c;
                     inst_i        <= fft_inst;
                     ppinst_i      <= fft_ppinst;
                     ppshiftinst_i <= fft_ppshiftinst;
                     addbiasinst_i <= fft_addbiasinst;
                     clipinst_i    <= fft_clipinst;
      when others => memreg_c_i    <= (noswap, hold, hold);
                     writebuff_c_i <= (noswap, hold, hold);
                     inst_i        <= nop;
                     ppinst_i      <= nop;
                     ppshiftinst_i <= (hold, 0, '0', left);
                     addbiasinst_i <= (pass, unbiased);
                     clipinst_i    <= (none, none);
    end case;
  end process;

---------------------------------------------------------------
--Data Input MUX
---------------------------------------------------------------
  data_input: process(clk_p)
  begin
    if rising_edge(clk_p) then
      mem_data_in <= ve_in;
      bias_in <= ve_in; --Bias buffer --Always VE_IN
    end if;
  end process;

---------------------------------------------------------------
----------read mux ------ TBD ------- temp solution -----------
---------------------------------------------------------------
  rw_from_control_mux : process(all)
  begin
    if re_ready = '0' then
      if mode_latch = conv then
        data_read_enable_i <= rd_en_conv;
        data_write_enable_i <= '0';
        weight_read_enable_i <= rd_en_conv;
        weight_write_enable_i <= '0';
        read_en_b_i <= b_rd_en_conv;
      elsif mode_latch = fft then
        data_read_enable_i <= fft_read_en;
        data_write_enable_i <= fft_write_en;
        weight_read_enable_i <= fft_read_en;
        weight_write_enable_i <= fft_write_en;
        read_en_b_i <= '0';
      end if;
    else
      data_read_enable_i <= '0';
      data_write_enable_i <= dwen_from_re;
      weight_read_enable_i <= '0';
      weight_write_enable_i <= wwen_from_re;
      read_en_b_i <= '0';
    end if;
  end process;

  rw_to_mem_mux : process(all)
  begin
    read_en_o    <= '0';
    write_en_o   <= '0';
    read_en_w_o  <= '0';
    write_en_w_o <= '0';
    read_en_b_o  <= '0';
    write_en_b_o <= '0';
    if mode_latch = re_mode then
      read_en_o    <= read_en_to_mux;
      write_en_o   <= dwen_from_re;
      read_en_w_o  <= read_en_w_to_mux;
      write_en_w_o <= wwen_from_re;
      write_en_b_o <= bwen_from_re;
    elsif mode_latch = conv then
      read_en_o    <= read_en_to_mux;
      write_en_o   <= '0';
      read_en_w_o  <= read_en_w_to_mux;
      write_en_w_o <= '0';
      read_en_b_o  <= read_en_b_to_mux;
    elsif mode_latch = fft then
      read_en_o    <= read_en_to_mux;
      write_en_o   <= write_en_to_mux;
      read_en_w_o  <= read_en_w_to_mux;
      write_en_w_o <= write_en_w_to_mux;
      if fft_done_pipe(10) = '1' then
        read_en_o   <= doutrd_en;
        read_en_w_o <= woutrd_en;
      end if;
    end if;
  end process;
  bypass <= '0';

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
    databuf_0 : mem
      generic map(
        load_filename => fft256_rand_data0,
        width         => 32,
        addressbits   => 8,
        columns       => 4
        )
      port map (
        clk      => clk_p,
        read_en  => read_en_o,
        write_en => write_en_o,
        d_in     => data_to_mem(63 downto 32),
        address  => data0addr_to_memory,
        d_out    => data0,
        load_mem => '0'--DDI_VLD
        );
    databuf_1 : mem
      generic map(
        load_filename => fft256_rand_data1,
        width         => 32,
        addressbits   => 8,
        columns       => 4
        )
      port map(
        clk      => clk_p,
        read_en  => read_en_o,
        write_en => write_en_o,
        d_in     => data_to_mem(31 downto 0),
        address  => data1addr_to_memory,
        d_out    => data1,
        load_mem => '0'--DDI_VLD
        );
--weight mem--
    buf_weight : mem
      generic map (
        load_filename => fft256_rand_weight,
        width         => 64,
        addressbits   => 8,
        columns       => 8
        )
      port map (
        clk      => clk_p,
        read_en  => read_en_w_o,
        write_en => write_en_w_o,
        d_in     => data_to_mem,
        address  => weightaddr_to_memory,
        d_out    => weight,
        load_mem => '0'--DDI_VLD
        );

--bias mem--
    buf_bias : mem
      generic map(
        load_filename => fftcopy,
        width         => 64,
        addressbits   => 6,
        columns       => 8
        )
      port map(
        clk      => clk_p,
        read_en  => read_en_b_o,
        write_en => write_en_b_o,
        d_in     => bias_in,            --writebuffer,
        address  => biasaddr_to_memory,
        d_out    => bias_buf_out,
        load_mem => '0'--DDI_VLD
        );
  end generate;

  data_addressing : addressing_unit
    port map(
      clk          => clk_p,
      rst          => rst and not left_rst,
      load         => left_loading,
      cmp          => au_lcmp,
      add_offset   => au_loffset,
      baseaddress  => left_baseaddress,
      finaladdress => left_finaladdress
    );

  weight_addressing : addressing_unit
    port map(
      clk          => clk_p,
      rst          => rst and not right_rst,
      load         => right_loading,
      cmp          => au_rcmp,
      add_offset   => au_roffset,
      baseaddress  => right_baseaddress,
      finaladdress => right_finaladdress
    );

  bias_addressing : addressing_unit
    port map(
      clk          => clk_p,
      rst          => rst and not bias_rst,
      load         => bias_loading,
      cmp          => au_bcmp,
      add_offset   => au_boffset,
      baseaddress  => bias_index_start,
      finaladdress => bias_finaladdress
    );

    pushback_a : addressing_unit
    port map(
      clk          => clk_p,
      rst          => rst and not apushback_rst,
      load         => apushback_load,
      cmp          => pa_cmp,
      add_offset   => pa_offset,
      baseaddress  => re_saddr_a,
      finaladdress => apushback_finaladdress
    );

    pushback_b : addressing_unit
    port map(
      clk          => clk_p,
      rst          => rst and not bpushback_rst,
      load         => bpushback_load,
      cmp          => pb_cmp,
      add_offset   => pb_offset,
      baseaddress  => re_saddr_b,
      finaladdress => bpushback_finaladdress
    );

  re_i : re
    port map(
      clk             => clk_p,
      rst             => rst,
      clk_e_pos       => clk_e_pos,
      mode_a          => mode_a,
      mode_b          => mode_b,
      mode_c          => mode_c,
      data_valid      => DDI_VLD,
      re_start        => re_start,
      re_source       => re_source,
      cnt_rst         => re_cnt_rst,
      wr_counter      => re_loop,
      re_busy         => re_ready,
      write_en_data   => dwen_from_re,
      write_en_weight => wwen_from_re,
      write_en_bias   => bwen_from_re,
      mode_c_l        => remode_c_l,
      left_rst        => lrst_from_re,
      right_rst       => rrst_from_re,
      bias_rst        => brst_from_re,
      left_load       => lload_from_re,
      right_load      => rload_from_re,
      bias_load       => bload_from_re,
      apushback_rst   => apushback_rst,
      bpushback_rst   => bpushback_rst,
      apushback_load  => apushback_load,
      bpushback_load  => bpushback_load
    );

  convcontroller_i : convcontroller
    port map(
      clk              => clk_p,
      rst              => rst,
      clk_e_pos        => clk_e_pos,
      start            => conv_start,
      cnt_rst          => conv_cnt_rst,
      mode_a           => mode_a,
      mode_b           => mode_b,
      mode_c           => mode_c,
      config           => config,
      pp_ctl           => pp_ctl,
      dot_cnt          => dot_cnt,
      oc_cnt           => oc_cnt,
      bias_au_addr     => bias_finaladdress,
      bias_index_end   => bias_index_end,
      scale            => scale,
      mode_c_l         => vemode_c_l,
      load             => load_from_conv,
      rd_en            => rd_en_conv,
      left_rst         => lrst_from_conv,
      right_rst        => rrst_from_conv,
      bias_load        => bload_from_conv,
      bias_rd_en       => b_rd_en_conv,
      bias_rst         => brst_from_conv,
      enable_shift     => shifter_ena,
      enable_add_bias  => adder_ena,
      enable_clip      => clip_ena,
      memreg_c         => conv_memreg_c,
      writebuff_c      => conv_writebuff_c,
      inst             => conv_inst,
      ppinst           => conv_ppinst,
      ppshiftinst      => conv_ppshiftinst,
      addbiasinst      => conv_addbiasinst,
      clipinst         => conv_clipinst,
      busy             => conv_busy
    );

  fftcontroller_i : fftcontroller
    port map(
      clk          => clk_p,
      en           => fft_en,
      start        => fft_start,
      stages       => fft_stages,  -- N = 2^(stages + 2), at most 7
      data0addr    => ve_fftaddr_d0, --data address comes out from fft controller
      data1addr    => ve_fftaddr_d1, --data address comes out from fft controller
      tfaddr       => ve_fftaddr_tf, --TF address comes out from fft controller
      read_en      => fft_read_en,
      write_en     => fft_write_en,
      memreg_c     => fft_memreg_c,
      writebuff_c  => fft_writebuff_c,
      done         => fft_done,
      finalstage   => finalstage,
      inst_arith   => fft_inst,
      inst_add     => fft_ppinst,
      inst_shift   => fft_ppshiftinst,
      inst_addbias => fft_addbiasinst,
      inst_clip    => fft_clipinst,
      stall        => stall
    );

  ve_wctrlpipe_inst : ve_wctrlpipe
    port map(
      clk             => clk_p,
      data0_addr_i    => data0_addr_i,
      data1_addr_i    => data1_addr_i,
      weight_addr_i   => weight_addr_i,
      bias_addr_i     => bias_addr_i, --in std_logic_vector(7 downto 0);
      bias_addr_ctrl_i=> ctrl, --in bias_addr_t;
      data_ren_i      => data_read_enable_i,
      data_wen_i      => data_write_enable_i,
      weight_ren_i    => weight_read_enable_i,
      weight_wen_i    => weight_write_enable_i,
      bias_ren_i      => read_en_b_i, --in std_logic;
      data0_i         => data0,
      data1_i         => data1,
      weight_i        => weight,
      memreg_c_i      => memreg_c_i,
      writebuff_c_i   => writebuff_c_i,
      inst_i          => inst_i,
      ppinst_i        => ppinst_i,
      ppshiftinst_i   => ppshiftinst_i,
      addbiasinst_i   => addbiasinst_i,
      clipinst_i      => clipinst_i,
      lzod_i          => ("00", none, none),
      feedback_ctrl_i => clip_to_1, --in feedback_t;
      zpdata_i        => zp_data,
      zpweight_i      => zp_weight,
      bias_i          => bias_buf_out,
      data0_addr_o    => data0_addr_o,
      data1_addr_o    => data1_addr_o,  
      weight_addr_o   => weight_addr_o,
      bias_addr_o     => bias_addr_o,  --biasaddr_to_memory, --out std_logic_vector(5 downto 0);
      data_ren_o      => read_en_to_mux,
      data_wen_o      => write_en_to_mux,          
      weight_ren_o    => read_en_w_to_mux,
      weight_wen_o    => write_en_w_to_mux,
      bias_ren_o      => read_en_b_to_mux,           
      outreg_o        => outreg,
      writebuffer_o   => writebuffer,
      stall           => stall,
      en_o            => en_i
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
      output_ena <= delay3(6); 
      --output_ena <= re_source;--DNN PUSH BACK TEST
    end if;
  end process;

  --sim_out : process(clk_p) --DNN PUSH BACK TEST
  --begin
  --  if rising_edge(clk_p) then
  --    if rst = '0' then 
  --      outreg <= (others => '0');
  --    else
  --      outreg <= std_logic_vector(unsigned(outreg)+1);
  --    end if;
  --  end if;
  --end process;

  fft_read_states : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        fft_read_state <= waiting;
        doutrd_en <= '0';
        woutrd_en <= '0';
      else
        case fft_read_state is 
          when waiting =>
            if fft_done_pipe(10) = '1' and dmem_read_done = '0' then
              doutrd_en <= '1';
              fft_read_state <= reading_dmem;
            end if;
          when reading_dmem =>
            if rdout_addr_data = x"ff" and wmem_read_done = '0' then
              doutrd_en <= '0';
              woutrd_en <= '1';
              fft_read_state <= reading_wmem;
            end if;
          when reading_wmem =>
            if rdout_addr_weight = x"ff" then
              woutrd_en <= '0';
              fft_read_state <= waiting;
            end if;
          when others => fft_read_state <= waiting;
        end case;
      end if;
    end if;
  end process;

  fft_readout : process(clk_p)
  begin
    if rising_edge(clk_p) then
      fft_done_pipe(0) <= fft_done;
      for i in 0 to 9 loop
        fft_done_pipe(i+1) <= fft_done_pipe(i);
      end loop;
      if rst = '0' then
        dmem_read_done <= '0';
        wmem_read_done <= '0';
        rdout_addr_data <= x"00";
        rdout_addr_weight <= x"00";
        fft_done_pipe <= (others => '0');
      else
        if fft_read_state = waiting then
          if fft_start = '1' then
            dmem_read_done <= '0';
            wmem_read_done <= '0';
          end if;
        elsif fft_read_state = reading_dmem then        
          if rdout_addr_data = x"ff" then
            dmem_read_done <= '1';
            rdout_addr_data <= x"00";
          else 
            rdout_addr_data <= std_logic_vector(unsigned(rdout_addr_data)+1);
          end if;
        elsif fft_read_state = reading_wmem then
          if rdout_addr_weight = x"ff" then
            wmem_read_done <= '1';
            rdout_addr_weight <= x"00";
          else 
            rdout_addr_weight <= std_logic_vector(unsigned(rdout_addr_weight)+1);
          end if;
        end if;
      end if;
    end if;
  end process;

  process(clk_p)
  begin
    if rising_edge(clk_p) then
      if fft_done_pipe(10) = '1' then
        if CLK_E_NEG = '0' then
          if doutrd_en = '1' then
            fft_result(127 downto 64) <= data0 & data1; 
          elsif woutrd_en = '1' then
            fft_result(127 downto 64) <= weight;
          end if;
        else
          if doutrd_en = '1' then
            fft_result(63 downto 0) <= data0 & data1; 
          elsif woutrd_en = '1' then
            fft_result(63 downto 0) <= weight;
          end if;
        end if;
      else
        fft_result <= (others => '0');
      end if;
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
      ve_out_reg(8*i+7 downto 8*i) <= dtm_data_reg(i);
    end loop;
  end process;

  out_mux : process(all)
  begin
    case mode_latch is 
      when fft => VE_OUT_DTM <= fft_result when clk_e_neg = '1' else (others => '0');
      when others => VE_OUT_DTM <= ve_out_reg;
    end case;
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
