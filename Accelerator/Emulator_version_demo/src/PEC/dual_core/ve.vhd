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
use work.pe1_mpgmfield_lib.all;
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

  component fpga_mem256x32 is
    port (
      clk      : in  std_logic;
      read_en  : in  std_logic;
      write_en : in  std_logic;
      d_in     : in  std_logic_vector(31 downto 0);
      address  : in  std_logic_vector(7 downto 0);
      d_out    : out std_logic_vector(31 downto 0)
      );
  end component;

  component fpga_mem256x64 is
    port (
      clk      : in  std_logic;
      read_en  : in  std_logic;
      write_en : in  std_logic;
      d_in     : in  std_logic_vector(63 downto 0);
      address  : in  std_logic_vector(7 downto 0);
      d_out    : out std_logic_vector(63 downto 0)
      );
  end component;

  component fpga_mem64x64 is
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

  component addressing_unit
    generic (
      simulation : boolean := true
      );
    port(
      clk           : in std_logic;
      rst           : in std_logic;
      en            : in std_logic;
      ext_tigger_en : in std_logic;
      load          : in std_logic_vector(3 downto 0);
      cmp           : in au_param;
      add_offset    : in au_param;
      baseaddress   : in std_logic_vector(7 downto 0);
      finaladdress  : out std_logic_vector(7 downto 0)
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
      pushback_en     : in std_logic;
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
      en               : in std_logic;
      clk_e_pos        : in std_logic;
      start            : in std_logic;
      cnt_rst          : in std_logic;
      data_valid       : in std_logic;
      mode_a           : in std_logic;
      mode_b           : in std_logic;
      mode_c           : in std_logic;
      bypass           : in std_logic;
      config           : in std_logic_vector(7 downto 0);
      pp_ctl           : in std_logic_vector(7 downto 0);
      dot_cnt          : in std_logic_vector(7 downto 0);
      oc_cnt           : in std_logic_vector(7 downto 0);
      scale            : in std_logic_vector(4 downto 0);
      mode_c_l         : out std_logic;
      bypass_reg       : out std_logic;
      load             : out std_logic;
      rd_en            : out std_logic;
      left_rst         : out std_logic;
      right_rst        : out std_logic;
      bias_load        : out std_logic; 
      bias_rd_en       : out std_logic;
      ext_load         : out std_logic;
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
      stall            : out unsigned(3 downto 0);
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

  component matinvcontroller12f
    port(
      clk                   : in std_logic;
      start                 : in std_logic;
      en_i                  : in std_logic;
      nt                    : in std_logic_vector(3 downto 0) := "0011";--integer range 0 to 15 := 3;
      done                  : out std_logic;

      data0_addr_o          : out std_logic_vector(7 downto 0);
      data1_addr_o          : out std_logic_vector(7 downto 0);
      weight_addr_o         : out std_logic_vector(7 downto 0);
      bias_addr_o           : out std_logic_vector(7 downto 0);
      bias_addr_ctrl_o      : out bias_addr_t;
      data_read_enable_o    : out std_logic;
      data_write_enable_o   : out std_logic;
      weight_read_enable_o  : out std_logic;
      weight_write_enable_o : out std_logic;
      bias_ren_o            : out std_logic;

      memreg_c_o            : out memreg_ctrl;
      writebuff_c_o         : out memreg_ctrl;
      inst_o                : out instruction;
      ppinst_o              : out ppctrl_t;
      ppshiftinst_shift_o   : out ppshift_shift_ctrl;
      ppshiftinst_addbias_o : out ppshift_addbias_ctrl;
      ppshiftinst_clip_o    : out ppshift_clip_ctrl;
      lzod_o                : out lzod_ctrl;
      feedback_ctrl_o       : out feedback_t;
      zpdata_o              : out std_logic_vector(7 downto 0);
      zpweight_o            : out std_logic_vector(7 downto 0);

      en_max_o              : out unsigned(3 downto 0)
    );
  end component;

  --------------------------------
  --PL signals
  --------------------------------
  --Receive engine signals
  signal re_start : std_logic;
  signal re_source : std_logic;
  --signal re_source_reg : std_logic;
  --Vector engine signals
  signal start, start_reg, conv_start, fft_start, matinv_start : std_logic;
  signal dfy_dest_sel : std_logic_vector(3 downto 0);
  --signal mac_switch : std_logic;
  --Shared signals
  signal mode_a : std_logic; --mode A activate
  signal mode_b : std_logic; --mode B activate
  signal mode_c : std_logic; --Vector engine mode c;
--  signal mode_d : std_logic; --Vector engine mode d; not impelemented yet
  signal remode_c_l : std_logic; --receive engine's mode c latch signal
  signal vemode_c_l : std_logic; --vector engine's mode c latch signal
  --signal reload : std_logic; --reload address counters 
  signal reg_in : std_logic_vector(5 downto 0); --parameter register set field, including loop counter.
  signal re_switch : std_logic; --Used to control VE's work mode, RE mode or VE mode.
    
  --------------------------------
  --Registers
  --------------------------------
  signal dfy_reg : dfy_word;    --pushback(DFY) register
  signal dtm_data_reg : dtm_word;
  signal mode_latch : mode;
  signal fft_state, matinv_state : read_state;
  signal au_lcmp, au_loffset, au_rcmp, au_roffset, au_bcmp, au_boffset : au_param;
  signal pa_cmp, pa_offset, pb_offset, pb_cmp : au_param;
  signal re_saddr_l, re_saddr_r : std_logic_vector(7 downto 0); --Receive engine's left starting address when DFM is used as the source
  signal re_loop_reg : std_logic_vector(7 downto 0); --receive engine's loop counter register
  signal re_saddr_a, re_saddr_b : std_logic_vector(7 downto 0); --Receive engine mode A start address when DFY is used as the source 
  signal ve_saddr_l, ve_saddr_r : std_logic_vector(7 downto 0); --Left starting address register
  signal left_baseaddress, right_baseaddress : std_logic_vector(7 downto 0);
  signal left_finaladdress, right_finaladdress, bias_finaladdress : std_logic_vector(7 downto 0);
  signal apushback_finaladdress, bpushback_finaladdress : std_logic_vector(7 downto 0);
  signal ve_loop_reg, ve_oloop_reg : std_logic_vector(7 downto 0);
  signal ve_fftaddr_d0, ve_fftaddr_d1, ve_fftaddr_tf : std_logic_vector(7 downto 0);
  signal fft_stages : unsigned(2 downto 0);
  signal fft_en, fft_done, fft_resload, finalstage, matinv_en, matinv_done, matinv_done_reg : std_logic;
  signal left_loading, right_loading, bias_loading : std_logic_vector(3 downto 0);
  signal left_rst, right_rst, bias_rst : std_logic;
  signal lrst_from_conv, rrst_from_conv : std_logic;
  signal lrst_from_re, rrst_from_re, brst_from_re : std_logic;
  signal lload_from_re, rload_from_re, bload_from_re : std_logic;
  signal load_from_conv, bload_from_conv : std_logic;
  signal apushback_load, bpushback_load : std_logic_vector(3 downto 0); 
  signal apushback_rst, bpushback_rst : std_logic;
  signal ring_load, ring_rd, ring_wr, ext_load : std_logic;
  signal ext_tigger_en : std_logic;
  signal config : std_logic_vector(7 downto 0); --configure register
  signal ring_start_addr : std_logic_vector(7 downto 0);
  signal zp_data, zpdata_i : std_logic_vector(7 downto 0); --zero point addition data
  signal zp_weight, zpweight_i : std_logic_vector(7 downto 0); --zero point addition data
  signal scale : std_logic_vector(4 downto 0); --shift scale factor
  signal pp_ctl : std_logic_vector(7 downto 0); --expand this 8 bits, 1209
  signal bias_index_start : std_logic_vector(7 downto 0);
  signal data0_addr_i, data1_addr_i : std_logic_vector(7 downto 0);
  signal weight_addr_i, bias_addr_i : std_logic_vector(7 downto 0);
  signal bias_addr_o : std_logic_vector(5 downto 0);
  signal re_busy : std_logic; --RE start latch
  signal conv_busy : std_logic; --VE start latch
  signal re_cnt_rst, conv_cnt_rst, cnt_rst  : std_logic;
  signal conv_enable : std_logic;
  signal data0 : std_logic_vector(31 downto 0);
  signal data1 : std_logic_vector(31 downto 0);
  signal weight, weight_out : std_logic_vector(63 downto 0);
  signal bias_buf_out : std_logic_vector(63 downto 0);
  signal bypass, bypass_reg, rcving_data, bypass_valid : std_logic;
  signal writebuffer : std_logic_vector(63 downto 0);
  signal mem_data_in, data_to_mem, bypassed_reg, bypassed_weight : std_logic_vector(63 downto 0);
  signal mem_data_reg : std_logic_vector(63 downto 0);
  signal ve_out_reg, fft_result, matinv_result : std_logic_vector(127 downto 0);
  signal read_en_b_i : std_logic;
  signal data_write_enable_i, weight_write_enable_i : std_logic;
  signal write_en_o, write_en_w_o, write_en_b_o : std_logic;
  signal dwen_from_re, wwen_from_re, bwen_from_re : std_logic;
  signal read_en_to_mux, read_en_w_to_mux, read_en_b_to_mux : std_logic;
  signal write_en_to_mux, write_en_w_to_mux : std_logic;
  signal keep_acc : std_logic; --keep accumulators vaule for long pointwise convolution
  signal fft_mode : std_logic;
  signal N_point : integer;
  signal bits    : integer;
  signal n       : integer; 
  signal mem_no, swap_int : std_logic;
  signal bit_rev : std_logic_vector(7 downto 0);
  signal out_byte_sel : std_logic_vector(3 downto 0);


  signal data0addr_to_memory : std_logic_vector(7 downto 0);
  signal data1addr_to_memory : std_logic_vector(7 downto 0);
  signal weightaddr_to_memory : std_logic_vector(7 downto 0);
  signal biasaddr_to_memory : std_logic_vector(5 downto 0);
  --data flow control signals
  signal adder_ena : std_logic;
  signal shifter_ena : std_logic;
  signal clip_ena : std_logic;
  signal output_ena : std_logic;
  signal output_c : unsigned(3 downto 0); --output byte counter 
  signal mode_c_l : std_logic;
  --output control signals
  signal load_dtm_out : std_logic;
  signal read_en_o, read_en_w_o, read_en_b_o : std_logic;
  signal outrd_en, woutrd_en, res_assign : std_logic;
  signal matinv_resrd_en, matinv_resrdw_en : std_logic;
  signal matinv_resrd_en_i, matinv_resrdw_en_i : std_logic;
  signal matinv_resdrd_done, matinv_reswrd_done : std_logic;
  signal fft_resrd_done : std_logic;
  signal data_read_enable_i   : std_logic;
  signal weight_read_enable_i : std_logic;
  signal rd_en_conv, b_rd_en_conv : std_logic;
  signal fft_read_en, fft_write_en : std_logic;
  signal memreg_c_i, conv_memreg_c, fft_memreg_c, matinv_memreg_c : memreg_ctrl;
  signal writebuff_c_i, conv_writebuff_c, fft_writebuff_c, matinv_writebuff_c : memreg_ctrl;
  signal inst_i, conv_ins, fft_inst, matinv_inst : instruction;
  signal ppinst_i, conv_ppins, fft_ppinst, matinv_ppinst : ppctrl_t;
  signal ppshiftinst_i, conv_ppshiftinst, fft_ppshiftinst, matinv_ppshiftinst : ppshift_shift_ctrl;
  signal addbiasinst_i, conv_addbiasinst, fft_addbiasinst, matinv_addbiasinst : ppshift_addbias_ctrl;
  signal clipinst_i, conv_clipinst, fft_clipinst, matinv_clipinst : ppshift_clip_ctrl;
  signal outreg : std_logic_vector(63 downto 0);
  signal fft_stall, conv_stall, stall : unsigned(3 downto 0);
  signal matinv_data0_addr, matinv_data1_addr : std_logic_vector(7 downto 0);
  signal matinv_weight_addr, matinv_bias_addr : std_logic_vector(7 downto 0);
  signal bias_addr_ctrl_i, matinv_bias_addr_ctrl : bias_addr_t;
  signal matinv_data_read_en, matinv_data_write_en, matinv_bias_ren : std_logic; 
  signal matinv_weight_read_en, matinv_weight_write_en, matinv_resload : std_logic;
  signal lzod_i, matinv_lzod : lzod_ctrl;
  signal feedback_ctrl_i, matinv_feedback_ctrl : feedback_t;
  signal matinv_zpdata_o, matinv_zpweight_o : std_logic_vector(7 downto 0);
  signal matinv_stall : unsigned(3 downto 0);
  signal nt : std_logic_vector(3 downto 0);
  signal en_o : std_logic;
  signal pushback_en : std_logic;
  signal data0_addr_o, data1_addr_o, weight_addr_o : std_logic_vector(7 downto 0);
  signal fft_done_pipe, matinv_done_pipe : std_logic_vector(10 downto 0);
  --signal ve_push_dtm : std_logic; --0126
  signal no_pushback : std_logic; -- remove later
  signal lrst         : std_logic;
  signal rrst         : std_logic;
  signal brst         : std_logic;
  signal parst        : std_logic;
  signal pbrst        : std_logic;
  signal en_conv      : std_logic;
  --constant CONS_MAC_SWITCH       : std_logic_vector(4 downto 0) := "1"&x"f"; --write the multiplier control register
  --------------------------------------------------------
  --Delay FFs
  --------------------------------------------------------
  signal delay3 : std_logic_vector(3 downto 0);


begin
  --Microcode translation
  --Some microinstructions are latched to registers and operates at clk_p frequency. 
  --Not latched signals are used only in one microinstruction time (clk_e) together with 
  --re_start and ve_start signals and mode abcd or relaod signal. 
  bypass       <= PL(121);-- buffer bypass
  dfy_dest_sel <= PL(119 downto 116); --DEST_BYTE
  out_byte_sel <= PL(112 downto 109);
  conv_enable  <= PL(107);
  fft_mode     <= PL(106);
  reg_in       <= PL(105 downto 100);
  cnt_rst      <= PL(99);
  mode_a       <= PL(98);
  mode_b       <= PL(97);
  re_source    <= PL(96); --RE_DFY_SRC --
  start        <= PL(95); 
  re_switch    <= PL(94); -- RE mode or VE mode
  keep_acc     <= PL(93);
  mode_c       <= PL(92);

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
          ring_start_addr   <= (others => '0'); 
          zp_data           <= (others => '0');
          zp_weight         <= (others => '0');
          scale             <= (others => '0'); 
          pp_ctl            <= (others => '0');  --Make it 8 bits
          bias_index_start  <= (others => '0');
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
          re_saddr_l <= YBUS;--counter clear should be added
        elsif reg_in = CONS_RE_START_ADDR_R then
          re_saddr_r <= YBUS;--counter clear should be added
        elsif reg_in = CONS_RE_LC then
          re_loop_reg <= YBUS;
        elsif reg_in = CONS_DFY_ADDR_A then
          re_saddr_a <= YBUS;
        elsif reg_in = CONS_DFY_ADDR_B then
          re_saddr_b <= YBUS;
        elsif reg_in = CONS_VE_START_ADDR_L then
          ve_saddr_l <= YBUS;--counter clear should be added
        elsif reg_in = CONS_VE_START_ADDR_R then
          ve_saddr_r <= YBUS;--counter clear should be added
        elsif reg_in = CONS_VE_LC then
          ve_loop_reg <= YBUS;
        --elsif reg_in = CONS_DFY_REG_SHIFT_IN then
        --    dfy_reg(to_integer(unsigned(dfy_dest_sel))) <= YBUS;
        elsif reg_in = CONS_VE_OLC then
          ve_oloop_reg <= YBUS;
        elsif reg_in = CONS_CONFIG then
          config <= YBUS;
        elsif reg_in = CONS_RING_END then
          -- NOP
        elsif reg_in = CONS_RING_START then
          ring_start_addr <= YBUS;--counter clear should be added
        elsif reg_in = CONS_ZP_DATA then
          zp_data <= YBUS;
        elsif reg_in = CONS_ZP_WEIGHT then
          zp_weight <= YBUS;
        elsif reg_in = CONS_SCALE then
          scale   <= YBUS(4 downto 0);
        elsif reg_in = CONS_PP_CTL then
          pp_ctl <= YBUS;
        elsif reg_in = CONS_BIAS_INDEX_END then
          -- NOP
        elsif reg_in = CONS_BIAS_INDEX_START then
          bias_index_start <= YBUS;--counter clear should be added
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
        re_rdy <= not re_busy;
      end if;
    end if;
  end process;

  process(clk_p) --Added clock confinement for ve_rdy
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        ve_rdy <= '1';
      elsif clk_e_pos = '0' then
        ve_rdy <= not conv_busy and not bypass_reg and fft_resrd_done and matinv_resdrd_done and matinv_reswrd_done;
      end if;
    end if;
  end process;

  process(clk_p) -- latch martix inversion done signal, since it being set to high for only one clock p.
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        matinv_done <= '1';
      elsif matinv_start = '1' then
        matinv_done <= '0';
      elsif matinv_done_reg = '1' then
        matinv_done <= '1';
      end if;
    end if;
  end process;

  mode_state_machine : process(clk_p) 
  begin
    if rising_edge(clk_p) then
      start_reg <= start;
      if rst = '0' then
        mode_latch <= idle;
      elsif clk_e_pos = '1' then
        case mode_latch is 
          when idle => 
            if re_switch = '1' then
              mode_latch <= re_mode;
            elsif conv_enable = '1' and fft_mode = '0' and re_switch = '0' then
              mode_latch <= conv;
            elsif conv_enable = '0' and fft_mode = '1' and re_switch = '0' then  
              mode_latch <= fft;
            elsif conv_enable = '1' and fft_mode = '1' and re_switch = '0' then
              mode_latch <= matrix;
            else
              mode_latch <= idle;
            end if;
          when re_mode =>
            if (conv_enable = '1' and fft_mode = '0' and re_switch = '0') or (re_source = '1' and pushback_en = '0') then
              mode_latch <= conv;
            elsif conv_enable = '0' and fft_mode = '1' and re_switch = '0' then  
              mode_latch <= fft;
            elsif conv_enable = '1' and fft_mode = '1' and re_switch = '0' then
              mode_latch <= matrix;
            --elsif re_rdy = '1' then --back to initial state TBD
            --  mode_latch <= idle;
            else
              mode_latch <= re_mode;
            end if;
          when conv =>
            if re_switch = '1' or (re_source = '1' and pushback_en = '1') then --pushback
              mode_latch <= re_mode;
            elsif conv_enable = '0' and fft_mode = '1' and re_switch = '0' then  
              mode_latch <= fft;
            elsif conv_enable = '1' and fft_mode = '1' and re_switch = '0' then
              mode_latch <= matrix;
            --elsif ve_rdy = '1' then
            --  mode_latch <= idle;  
            else
              mode_latch <= conv;
            end if;
          when fft =>
            if re_switch = '1' then
              mode_latch <= re_mode;
            elsif conv_enable = '1' and fft_mode = '0' and re_switch = '0' then
              mode_latch <= conv;
            elsif conv_enable = '1' and fft_mode = '1' and re_switch = '0' then
              mode_latch <= matrix;
            --elsif fft_resrd_done = '1' then
            --  mode_latch <= idle;  
            else
              mode_latch <= fft;
            end if;
          when matrix => 
            if re_switch = '1' then
              mode_latch <= re_mode;
            elsif conv_enable = '1' and fft_mode = '0' and re_switch = '0' then
              mode_latch <= conv;
            elsif conv_enable = '0' and fft_mode = '1' and re_switch = '0' then  
              mode_latch <= fft;
            --elsif matinv_done = '1' then
            --  mode_latch <= idle;
            else
              mode_latch <= matrix;
            end if;
          when others => mode_latch <= idle;
        end case;
      end if;
    end if;
  end process;

  fft_en <= '1' when mode_latch = fft else '0'; -- more enable signals should be added to controllers later
  matinv_en <= en_o when mode_latch = matrix else '0';

  --********************************
  --Mode c. Shared by RE and VE
  --********************************

  mode_c_addr: process(clk_p)
  begin
    if rising_edge(clk_p) then
      if RST = '0' then
        ring_load <= '0';
        ring_rd <= '0';
        ring_wr <= '0';
      elsif (re_busy = '1' and mode_c_l = '1') or (re_start = '1' and mode_c = '1' and clk_e_pos = '0') then --make this an automatic process --1215
        if (re_source = '0' and DDI_VLD = '1') or re_source = '1' then
          ring_load <= '1';
          ring_wr <= '1';
        else
          ring_load <= '0';
          ring_wr <= '0';
        end if;
      elsif conv_busy = '1' and mode_c_l = '1' then
        ring_load <= '1';
        ring_rd <= '1';
      else
        ring_load <= '0';
        ring_rd <= '0';
        ring_wr <= '0';
      end if;
    end if;
  end process;

  --**********************
  --Address_MUX
  --**********************
  AUparam_mux : process(all)
    variable nr : unsigned(3 downto 0);
  begin
    nr := unsigned(nt);
    case mode_latch is 
      when re_mode => left_baseaddress  <= re_saddr_l when mode_c_l = '0' else ring_start_addr;                                                    
                      right_baseaddress <= re_saddr_r; 
                      left_loading(0) <= lload_from_re when mode_c_l = '0' else ring_load;
                      left_loading(3 downto 1) <= "000"; -- not use currently
                      right_loading(0) <= rload_from_re;
                      right_loading(3 downto 1) <= "000"; -- not use currently
                      bias_loading(0) <= bload_from_re;
                      bias_loading(3 downto 1) <= "000"; -- not use currently
      when conv    => left_baseaddress  <= ve_saddr_l when mode_c_l = '0' else ring_start_addr;
                      right_baseaddress <= ve_saddr_r;
                      left_loading(0) <= load_from_conv when mode_c_l = '0' else ring_load;
                      left_loading(1) <= ext_load;
                      left_loading(3 downto 2) <= "00"; -- not use currently
                      right_loading(0) <= load_from_conv;
                      right_loading(3 downto 1) <= "000"; -- not use currently
                      bias_loading(0) <= bload_from_conv;
                      bias_loading(3 downto 1) <= "000"; -- not use currently
      when matrix  => left_baseaddress <= x"00";
                      right_baseaddress <= std_logic_vector(shift_right((nr*(nr + 1)), 1));
                      left_loading(0) <= matinv_resrd_en;
                      left_loading(3 downto 1) <= "000"; -- not use currently
                      right_loading(0) <= matinv_resrdw_en;
                      right_loading(3 downto 1) <= "000"; -- not use currently
                      bias_loading <= x"0";
      when others  => left_baseaddress  <= x"00";
                      right_baseaddress <= x"00";
                      left_loading <= x"0";
                      right_loading <= x"0";
                      bias_loading <= x"0";
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

  addrfromctrl_pointer_mux : process(all) --select generated address and feed it into pipelines
  begin
    case mode_latch is
      when re_mode => data0_addr_i  <= left_finaladdress;
                      data1_addr_i  <= left_finaladdress;
                      weight_addr_i <= right_finaladdress when bypass_reg = '0' else x"00";
                      bias_addr_i   <= bias_finaladdress; 
      when conv    => data0_addr_i  <= left_finaladdress;
                      data1_addr_i  <= left_finaladdress;
                      weight_addr_i <= right_finaladdress when bypass_reg = '0' else x"00";
                      bias_addr_i   <= bias_finaladdress; 
      when fft     => data0_addr_i  <= ve_fftaddr_d0;
                      data1_addr_i  <= ve_fftaddr_d1;
                      weight_addr_i <= ve_fftaddr_tf;
                      bias_addr_i   <= x"00";
      when matrix  => data0_addr_i  <= matinv_data0_addr;
                      data1_addr_i  <= matinv_data1_addr;
                      weight_addr_i <= matinv_weight_addr;
                      bias_addr_i   <= matinv_bias_addr;
      when others  => data0_addr_i  <= x"00";
                      data1_addr_i  <= x"00";
                      weight_addr_i <= x"00";
                      bias_addr_i   <= x"00";
    end case;
  end process;
  
  addrtomem_pointer_mux: process(all) --select address and feed it to local buffer
  begin
    case mode_latch is 
      when re_mode => biasaddr_to_memory <= bias_finaladdress(5 downto 0);
                      weightaddr_to_memory <= right_finaladdress when bypass_reg = '0' else x"00";
                      data0addr_to_memory <= left_finaladdress;
                      data1addr_to_memory <= left_finaladdress;
                      if re_source = '1' and mode_a = '1' then
                        data0addr_to_memory <= apushback_finaladdress;
                        data1addr_to_memory <= apushback_finaladdress;
                      elsif re_source = '1' and mode_b = '1' then
                        data0addr_to_memory <= bpushback_finaladdress;
                        data1addr_to_memory <= bpushback_finaladdress;
                      end if;
      when conv    => biasaddr_to_memory <= bias_addr_o;
                      weightaddr_to_memory <= weight_addr_o when bypass_reg = '0' else x"00";
                      data0addr_to_memory <= data0_addr_o;
                      data1addr_to_memory <= data1_addr_o;
      when fft     => biasaddr_to_memory <= bias_addr_o;
                      if fft_done_pipe(10) = '1' and fft_done = '1' then
                        weightaddr_to_memory <= x"00";
                        data0addr_to_memory  <= bit_rev;
                        data1addr_to_memory  <= bit_rev;
                      else
                        weightaddr_to_memory <= weight_addr_o;
                        data0addr_to_memory  <= data0_addr_o;
                        data1addr_to_memory  <= data1_addr_o;
                      end if;
      when matrix  => biasaddr_to_memory <= bias_addr_o;
                      if matinv_done_pipe(10) = '1' and matinv_done = '1' then
                        weightaddr_to_memory <= right_finaladdress;
                        data0addr_to_memory  <= left_finaladdress;
                        data1addr_to_memory  <= left_finaladdress;
                      else
                        weightaddr_to_memory <= weight_addr_o;
                        data0addr_to_memory  <= data0_addr_o;
                        data1addr_to_memory  <= data1_addr_o;
                      end if;
      when others  => biasaddr_to_memory <= bias_addr_o;
                      weightaddr_to_memory <= weight_addr_o;
                      data0addr_to_memory  <= data0_addr_o;
                      data1addr_to_memory  <= data1_addr_o;
    end case;
  end process;


  start_demux : process(all) --control bit to function controllers
  begin
    --if rising_edge(clk_p) then
    conv_start   <= '0';
    fft_start    <= '0';
    matinv_start <= '0';
    re_start     <= '0';
    left_rst     <= '0';
    right_rst    <= '0';
    bias_rst     <= '0';
    fft_stages   <= "000";
    stall        <= x"0";
    nt           <= x"0";
    re_cnt_rst   <= '0';
    conv_cnt_rst <= '0';
    bypass_valid <= '0';
    rcving_data  <= '0';
    case mode_latch is
      when conv    => conv_start   <= start;
                      conv_cnt_rst <= cnt_rst;
                      bypass_valid <= DDI_VLD;
                      stall        <= conv_stall;
                      left_rst     <= lrst_from_conv when mode_c_l = '0' else '0';
                      right_rst    <= rrst_from_conv;
                      bias_rst     <= '0';
      when fft     => fft_start    <= start and start_reg;
                      fft_stages   <= unsigned(ve_loop_reg(2 downto 0));
                      stall        <= fft_stall;
      when matrix  => matinv_start <= start and start_reg;
                      nt           <= ve_loop_reg(3 downto 0);
                      stall        <= matinv_stall;
      when re_mode => re_start     <= start;
                      re_cnt_rst   <= cnt_rst;
                      rcving_data  <= DDI_VLD;
                      left_rst     <= lrst_from_re when mode_c_l = '0' else '0';
                      right_rst    <= rrst_from_re;
                      bias_rst     <= brst_from_re;
      when others  => null;
    end case;
    --end if;
  end process;

  instruction_mux : process(all) -- select generated instructions and feed to pipelines
  begin
    case mode_latch is
      when conv   => memreg_c_i      <= conv_memreg_c;
                     writebuff_c_i   <= conv_writebuff_c;
                     inst_i          <= conv_ins;
                     ppinst_i        <= conv_ppins;
                     ppshiftinst_i   <= conv_ppshiftinst;
                     addbiasinst_i   <= conv_addbiasinst;
                     clipinst_i      <= conv_clipinst;
                     lzod_i          <= (word => "00", store => none, output => none);
                     feedback_ctrl_i <= clip_to_1;
                     zpdata_i        <= zp_data;
                     zpweight_i      <= zp_weight;
                     bias_addr_ctrl_i<= ctrl;
      when fft    => memreg_c_i      <= fft_memreg_c;
                     writebuff_c_i   <= fft_writebuff_c;
                     inst_i          <= fft_inst;
                     ppinst_i        <= fft_ppinst;
                     ppshiftinst_i   <= fft_ppshiftinst;
                     addbiasinst_i   <= fft_addbiasinst;
                     clipinst_i      <= fft_clipinst;
                     lzod_i          <= (word => "00", store => none, output => none);
                     feedback_ctrl_i <= clip_to_1;
                     zpdata_i        <= x"00";
                     zpweight_i      <= x"00";
                     bias_addr_ctrl_i<= ctrl;
      when matrix => memreg_c_i      <= matinv_memreg_c;
                     writebuff_c_i   <= matinv_writebuff_c;
                     inst_i          <= matinv_inst;
                     ppinst_i        <= matinv_ppinst;
                     ppshiftinst_i   <= matinv_ppshiftinst;
                     addbiasinst_i   <= matinv_addbiasinst;
                     clipinst_i      <= matinv_clipinst;
                     lzod_i          <= matinv_lzod;
                     feedback_ctrl_i <= matinv_feedback_ctrl;
                     zpdata_i        <= matinv_zpdata_o;
                     zpweight_i      <= matinv_zpweight_o;
                     bias_addr_ctrl_i<= matinv_bias_addr_ctrl;
      when others => memreg_c_i      <= (swap => noswap, datareg => hold, weightreg => hold);
                     writebuff_c_i   <= (swap => noswap, datareg => hold, weightreg => hold);
                     inst_i          <= nop;
                     ppinst_i        <= nop;
                     ppshiftinst_i   <= (acce => hold, shift => to_integer(unsigned(scale)), use_lod => '0', shift_dir => left);
                     addbiasinst_i   <= (acc  => pass, quant => unbiased);
                     clipinst_i      <= (clip => none, outreg => none);
                     lzod_i          <= (word => "00", store => none, output => none);
                     feedback_ctrl_i <= clip_to_1;
                     zpdata_i        <= x"00";
                     zpweight_i      <= x"00";
                     bias_addr_ctrl_i<= ctrl;
    end case;
  end process;

---------------------------------------------------------------
--Data Input MUX
---------------------------------------------------------------
  data_input: process(clk_p)
  begin
    if rising_edge(clk_p) then
      mem_data_reg <= ve_in;
      mem_data_in <= mem_data_reg; 
      bypassed_reg <= mem_data_in;
      bypassed_weight <= bypassed_reg;
    end if;
  end process;

---------------------------------------------------------------
----------read mux ------ TBD ------- temp solution -----------
---------------------------------------------------------------
  rw_from_control_mux : process(all)
  begin
    if re_busy = '0' then
      if mode_latch = conv then
        data_read_enable_i <= ring_rd when mode_c_l = '1' else rd_en_conv;
        data_write_enable_i <= '0';
        weight_read_enable_i <= rd_en_conv when bypass_reg = '0' else '0';
        weight_write_enable_i <= '0';
        read_en_b_i <= b_rd_en_conv;
      elsif mode_latch = fft then
        data_read_enable_i <= fft_read_en;
        data_write_enable_i <= fft_write_en;
        weight_read_enable_i <= fft_read_en;
        weight_write_enable_i <= '0';
        read_en_b_i <= '0';
      elsif mode_latch = matrix then
        data_read_enable_i <= matinv_data_read_en;
        data_write_enable_i <= matinv_data_write_en;
        weight_read_enable_i <= matinv_weight_read_en;
        weight_write_enable_i <= matinv_weight_write_en;
        read_en_b_i <= matinv_bias_ren;
      else
        data_read_enable_i <= '0';
        data_write_enable_i <= '0';
        weight_read_enable_i <= '0';
        weight_write_enable_i <= '0';
        read_en_b_i <= '0';
      end if;
    else
      data_read_enable_i <= '0';
      data_write_enable_i <= dwen_from_re when mode_c_l = '0' else ring_wr;
      weight_read_enable_i <= '0';
      weight_write_enable_i <= '0';--wwen_from_re when bypass_reg = '0' else '0';
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
      read_en_o    <= '0';--read_en_to_mux;
      write_en_o   <= dwen_from_re;
      read_en_w_o  <= '0';--read_en_w_to_mux;
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
      if fft_done_pipe(10) = '1' and fft_done = '1' then
        read_en_o   <= outrd_en;
        read_en_w_o <= woutrd_en;
      end if;
    elsif mode_latch = matrix then
      read_en_o    <= read_en_to_mux;
      write_en_o   <= write_en_to_mux;
      read_en_w_o  <= read_en_w_to_mux;
      write_en_w_o <= write_en_w_to_mux;
      read_en_b_o  <= read_en_b_to_mux;
      if matinv_done_pipe(10) = '1' and matinv_done = '1' then
        read_en_o <= matinv_resrd_en;
        read_en_w_o <= matinv_resrdw_en;
      end if;
    end if;
  end process;

  bypass_mux : process(all)
  begin
    weight <= weight_out when bypass_reg = '0' else bypassed_weight;
  end process;

  no_pushback <= not pushback_en; -- remove later
  lrst <= rst and not left_rst;
  rrst <= rst and not right_rst;
  brst <= rst and not bias_rst;
  parst <= rst and not apushback_rst;
  pbrst <= rst and not bpushback_rst;
  en_conv <= en_o and not pushback_en;
  ext_tigger_en <= mode_c_l;-- or other function enable

---------------------------------------------------------------
--MEM, Multiplier and accumulator IPs
---------------------------------------------------------------
  buf_asic_gen : if USE_ASIC_MEMORIES generate
--data mem(splited in high and low part)--
    databuf_0 : SNPS_RF_SP_UHS_256x32
      port map (
        Q        => data0,
        ADR      => data0addr_to_memory,
        D        => data_to_mem(63 downto 32),
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
        D        => data_to_mem(31 downto 0),
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
        Q        => weight_out,
        ADR      => weightaddr_to_memory,
        D        => data_to_mem,
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
        D        => mem_data_in,            --writebuffer
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
    databuf_0 : fpga_mem256x32
      port map (
        clk      => clk_p,
        read_en  => read_en_o,
        write_en => write_en_o,
        d_in     => data_to_mem(63 downto 32),
        address  => data0addr_to_memory,
        d_out    => data0
        );
    databuf_1 : fpga_mem256x32
      port map(
        clk      => clk_p,
        read_en  => read_en_o,
        write_en => write_en_o,
        d_in     => data_to_mem(31 downto 0),
        address  => data1addr_to_memory,
        d_out    => data1
        );
    --weight mem--
    buf_weight : fpga_mem256x64
      port map (
        clk      => clk_p,
        read_en  => read_en_w_o,
        write_en => write_en_w_o,
        d_in     => data_to_mem,
        address  => weightaddr_to_memory,
        d_out    => weight_out
        );
    
    --bias mem--
    buf_bias : fpga_mem64x64
      port map(
        clk      => clk_p,
        read_en  => read_en_b_o,
        write_en => write_en_b_o,
        d_in     => mem_data_in,            --writebuffer,
        address  => biasaddr_to_memory,
        d_out    => bias_buf_out
        );
  end generate;

  data_addressing : addressing_unit
    port map(
      clk           => clk_p,
      rst           => lrst,
      en            => no_pushback,
      ext_tigger_en => ext_tigger_en,
      load          => left_loading,  
      cmp           => au_lcmp,
      add_offset    => au_loffset,
      baseaddress   => left_baseaddress,
      finaladdress  => left_finaladdress
    );

  weight_addressing : addressing_unit
    port map(
      clk           => clk_p,
      rst           => rrst,
      en            => no_pushback,
      ext_tigger_en => ext_tigger_en,
      load          => right_loading,
      cmp           => au_rcmp,
      add_offset    => au_roffset,
      baseaddress   => right_baseaddress,
      finaladdress  => right_finaladdress
    );

  bias_addressing : addressing_unit
    port map(
      clk           => clk_p,
      rst           => brst,
      en            => no_pushback,
      ext_tigger_en => ext_tigger_en,
      load          => bias_loading,
      cmp           => au_bcmp,
      add_offset    => au_boffset,
      baseaddress   => bias_index_start,
      finaladdress  => bias_finaladdress
    );

    pushback_a : addressing_unit
    port map(
      clk           => clk_p,
      rst           => parst,
      en            => pushback_en,
      ext_tigger_en => ext_tigger_en,
      load          => apushback_load,
      cmp           => pa_cmp,
      add_offset    => pa_offset,
      baseaddress   => re_saddr_a,
      finaladdress  => apushback_finaladdress
    );

    pushback_b : addressing_unit
    port map(
      clk           => clk_p,
      rst           => pbrst,
      en            => pushback_en,
      ext_tigger_en => ext_tigger_en,
      load          => bpushback_load,
      cmp           => pb_cmp,
      add_offset    => pb_offset,
      baseaddress   => re_saddr_b,
      finaladdress  => bpushback_finaladdress
    );

  re_i : re
    port map(
      clk             => clk_p,
      rst             => rst,
      clk_e_pos       => clk_e_pos,
      mode_a          => mode_a,
      mode_b          => mode_b,
      mode_c          => mode_c,
      data_valid      => rcving_data,
      re_start        => re_start,
      re_source       => re_source,
      cnt_rst         => re_cnt_rst,
      pushback_en     => pushback_en,
      wr_counter      => re_loop_reg,
      re_busy         => re_busy,
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
      apushback_load  => apushback_load(0),
      bpushback_load  => bpushback_load(0)
    );

  convcontroller_i : convcontroller
    port map(
      clk              => clk_p,
      rst              => rst,
      en               => en_conv,
      clk_e_pos        => clk_e_pos,
      start            => conv_start,
      cnt_rst          => conv_cnt_rst,
      data_valid       => bypass_valid,
      mode_a           => mode_a,
      mode_b           => mode_b,
      mode_c           => mode_c,
      bypass           => bypass,
      config           => config,
      pp_ctl           => pp_ctl,
      dot_cnt          => ve_loop_reg,--dot_cnt,
      oc_cnt           => ve_oloop_reg,--oc_cnt,
      scale            => scale,
      mode_c_l         => vemode_c_l,
      bypass_reg       => bypass_reg,
      load             => load_from_conv,
      rd_en            => rd_en_conv,
      left_rst         => lrst_from_conv,
      right_rst        => rrst_from_conv,
      bias_load        => bload_from_conv,
      bias_rd_en       => b_rd_en_conv,
      ext_load         => ext_load,
      enable_shift     => shifter_ena,
      enable_add_bias  => adder_ena,
      enable_clip      => clip_ena,
      memreg_c         => conv_memreg_c,
      writebuff_c      => conv_writebuff_c,
      inst             => conv_ins,
      ppinst           => conv_ppins,
      ppshiftinst      => conv_ppshiftinst,
      addbiasinst      => conv_addbiasinst,
      clipinst         => conv_clipinst,
      stall            => conv_stall,
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
      stall        => fft_stall
    );

  matinvcontroller12f_i : matinvcontroller12f
    port map(
      clk                   => clk_p,
      start                 => matinv_start,
      en_i                  => matinv_en,
      nt                    => nt,
      done                  => matinv_done_reg,
      data0_addr_o          => matinv_data0_addr,
      data1_addr_o          => matinv_data1_addr,
      weight_addr_o         => matinv_weight_addr,
      bias_addr_o           => matinv_bias_addr,
      bias_addr_ctrl_o      => matinv_bias_addr_ctrl,--: out bias_addr_t;
      data_read_enable_o    => matinv_data_read_en,
      data_write_enable_o   => matinv_data_write_en,
      weight_read_enable_o  => matinv_weight_read_en,
      weight_write_enable_o => matinv_weight_write_en,
      bias_ren_o            => matinv_bias_ren,
      memreg_c_o            => matinv_memreg_c,
      writebuff_c_o         => matinv_writebuff_c,
      inst_o                => matinv_inst,
      ppinst_o              => matinv_ppinst,
      ppshiftinst_shift_o   => matinv_ppshiftinst,
      ppshiftinst_addbias_o => matinv_addbiasinst,
      ppshiftinst_clip_o    => matinv_clipinst,
      lzod_o                => matinv_lzod,--: out lzod_ctrl;
      feedback_ctrl_o       => matinv_feedback_ctrl,--: out feedback_t;
      zpdata_o              => matinv_zpdata_o,
      zpweight_o            => matinv_zpweight_o,
      en_max_o              => matinv_stall 
    );

  ve_wctrlpipe_inst : ve_wctrlpipe
    port map(
      clk             => clk_p,
      data0_addr_i    => data0_addr_i,
      data1_addr_i    => data1_addr_i,
      weight_addr_i   => weight_addr_i,
      bias_addr_i     => bias_addr_i, 
      bias_addr_ctrl_i=> bias_addr_ctrl_i, 
      data_ren_i      => data_read_enable_i,
      data_wen_i      => data_write_enable_i,
      weight_ren_i    => weight_read_enable_i,
      weight_wen_i    => weight_write_enable_i,
      bias_ren_i      => read_en_b_i, 
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
      lzod_i          => lzod_i,
      feedback_ctrl_i => feedback_ctrl_i, --in feedback_t;
      zpdata_i        => zpdata_i,
      zpweight_i      => zpweight_i,
      bias_i          => bias_buf_out,
      data0_addr_o    => data0_addr_o,
      data1_addr_o    => data1_addr_o,  
      weight_addr_o   => weight_addr_o,
      bias_addr_o     => bias_addr_o,  
      data_ren_o      => read_en_to_mux,
      data_wen_o      => write_en_to_mux,          
      weight_ren_o    => read_en_w_to_mux,
      weight_wen_o    => write_en_w_to_mux,
      bias_ren_o      => read_en_b_to_mux,           
      outreg_o        => outreg,
      writebuffer_o   => writebuffer,
      stall           => stall,
      en_o            => en_o
      );

------------------------------------------------------------------------------
  --Output 
------------------------------------------------------------------------------
  process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        delay3 <= (others => '0');
        fft_done_pipe <= (others => '0');
        matinv_done_pipe <= (others => '0');
      else
        delay3(0) <= clip_ena;
        for i in 0 to 2 loop
          delay3(i + 1) <= delay3(i);
        end loop;
        output_ena <= delay3(3); 

        fft_done_pipe(0) <= fft_done;
        for i in 0 to 9 loop
          fft_done_pipe(i + 1) <= fft_done_pipe(i);
        end loop;

        matinv_done_pipe(0) <= matinv_done;
        for i in 0 to 9 loop
          matinv_done_pipe(i + 1) <= matinv_done_pipe(i);
        end loop;
      end if; 
    end if;
  end process;
  ----------------------------------------------------------------------------
  -- FFT results bit reverse
  ----------------------------------------------------------------------------
  stage_to_points : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        N_point <= 0;
        bits    <= 0;
      elsif fft_start = '1' then
        case fft_stages is 
          --1 stage
          when "000"  => N_point <= 4;
                         bits    <= 2;
          --2 stage
          when "001"  => N_point <= 8;
                         bits    <= 3;
          --3 stage
          when "010"  => N_point <= 16;
                         bits    <= 4;
          --4 stage
          when "011"  => N_point <= 32;
                         bits    <= 5;
          --5 stage
          when "100"  => N_point <= 64;
                         bits    <= 6;
          --6 stage
          when "101"  => N_point <= 128;
                         bits    <= 7;
          --7 stage
          when "110"  => N_point <= 256;
                         bits    <= 8;
          --8 satege
          when others => N_point <= 512;
                         bits    <= 9;
        end case;
      end if;
    end if;
  end process;

  fft_read_states : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        fft_state <= waiting;
        outrd_en <= '0';
        woutrd_en <= '0';
      else
        case fft_state is 
          when waiting =>
            if fft_start = '1' then
              fft_state <= computing;
            end if;
          when computing =>
          if fft_done = '1' and fft_done_pipe(8) = '1' and fft_resrd_done = '0' then
            outrd_en <= '1';
            fft_state <= reading_dbuffer;
          end if;
          when reading_dbuffer =>
            if n = to_integer(shift_right(to_unsigned(N_point, 10), 1)) then -- n = N/2
              outrd_en <= '0';
              fft_state <= waiting;
            end if;
          when others => fft_state <= waiting;
        end case;
      end if;
    end if;
  end process;

  fft_readout : process(clk_p)
    variable n_vector : std_logic_vector(7 downto 0);
  begin
    if rising_edge(clk_p) then
      swap_int <= mem_no;
      if rst = '0' then
        fft_resrd_done <= '1';
        mem_no <= '0';
        swap_int <= '0';
        n <= 0;
        bit_rev <= x"00";
      else
        if fft_state = waiting then
          if fft_start = '1' then
            fft_resrd_done <= '0';
          end if;
        elsif mode_latch = fft and fft_state = reading_dbuffer then 
          n_vector := std_logic_vector(to_unsigned(n, 8));       
          if n = to_integer(shift_right(to_unsigned(N_point, 10), 1)) then -- n = N/2
            fft_resrd_done <= '1';
            n <= 0;
          else 
            case bits is 
              when 2      => mem_no     <= n_vector(0);
                             bit_rev(0) <= n_vector(0);
              when 3      => mem_no     <= n_vector(0) xor n_vector(1);
                             bit_rev(0) <= n_vector(1);
                             bit_rev(1) <= n_vector(0);
              when 4      => mem_no     <= n_vector(0) xor n_vector(1) xor n_vector(2);
                             bit_rev(0) <= n_vector(2);
                             bit_rev(1) <= n_vector(1);  
                             bit_rev(2) <= n_vector(0);
              when 5      => mem_no     <= n_vector(0) xor n_vector(1) xor n_vector(2) xor n_vector(3);
                             bit_rev(0) <= n_vector(3);
                             bit_rev(1) <= n_vector(2);
                             bit_rev(2) <= n_vector(1);
                             bit_rev(3) <= n_vector(0);
              when 6      => mem_no     <= n_vector(0) xor n_vector(1) xor n_vector(2) xor n_vector(3) xor n_vector(4);
                             bit_rev(0) <= n_vector(4);
                             bit_rev(1) <= n_vector(3);
                             bit_rev(2) <= n_vector(2);
                             bit_rev(3) <= n_vector(1);
                             bit_rev(4) <= n_vector(0);
              when 7      => mem_no     <= n_vector(0) xor n_vector(1) xor n_vector(2) xor n_vector(3) xor n_vector(4) xor n_vector(5);
                             bit_rev(0) <= n_vector(5);
                             bit_rev(1) <= n_vector(4);
                             bit_rev(2) <= n_vector(3);
                             bit_rev(3) <= n_vector(2);
                             bit_rev(4) <= n_vector(1);
                             bit_rev(5) <= n_vector(0);
              when 8      => mem_no     <= n_vector(0) xor n_vector(1) xor n_vector(2) xor n_vector(3) xor n_vector(4) xor n_vector(5) xor n_vector(6);
                             bit_rev(0) <= n_vector(6);
                             bit_rev(1) <= n_vector(5);
                             bit_rev(2) <= n_vector(4);
                             bit_rev(3) <= n_vector(3);
                             bit_rev(4) <= n_vector(2);
                             bit_rev(5) <= n_vector(1);
                             bit_rev(6) <= n_vector(0);
              when others => mem_no     <= n_vector(0) xor n_vector(1) xor n_vector(2) xor n_vector(3) xor n_vector(4) xor n_vector(5) xor n_vector(6) xor n_vector(7);
                             bit_rev(0) <= n_vector(7);
                             bit_rev(1) <= n_vector(6);
                             bit_rev(2) <= n_vector(5);
                             bit_rev(3) <= n_vector(4);
                             bit_rev(4) <= n_vector(3);
                             bit_rev(5) <= n_vector(2);
                             bit_rev(6) <= n_vector(1);
                             bit_rev(7) <= n_vector(0);
            end case;
            n <= n + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  fft_resload_to_reg : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        res_assign <= '0';
        fft_resload <= '0';
      else
        res_assign <= read_en_o;
        if fft_done_pipe(10) = '1' and res_assign = '1' and mode_latch = fft then
          if CLK_E_NEG = '0' then
            if swap_int = '1' then
              fft_result(63 downto 0) <= data0 & data1;
            else
              fft_result(63 downto 0) <= data1 & data0; 
            end if;
            fft_resload <= '0';
          else
            if swap_int = '1' then
              fft_result(127 downto 64) <= data0 & data1;
            else
              fft_result(127 downto 64) <= data1 & data0;
            end if;
            fft_resload <= '1';
          end if;
        else
          fft_resload <= '0';
          fft_result <= (others => '0');
        end if;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- matrix inversion results read
  ----------------------------------------------------------------------------
  matinv_read_FSM : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        matinv_state <= waiting;
        matinv_resrd_en <= '0';
        matinv_resrdw_en <= '0';
        matinv_resrd_en_i <= '0';
        matinv_resrdw_en_i <= '0';
      else
        matinv_resrd_en_i <= matinv_resrd_en;
        matinv_resrdw_en_i <= matinv_resrdw_en;
        case matinv_state is 
          when waiting =>
            if matinv_start = '1' then
              matinv_state <= computing;
            end if;
          when computing => 
            if matinv_done = '1' and matinv_done_pipe(10) = '1' then
              matinv_state <= reading_dbuffer;
            end if;
          when reading_dbuffer => 
            matinv_resrd_en <= '1';
            if matinv_resdrd_done = '1' then
              matinv_resrd_en <= '0';
              matinv_state <= reading_wbuffer;
            end if;
          when reading_wbuffer => 
            matinv_resrdw_en <= '1';
            if matinv_reswrd_done = '1' then
              matinv_resrdw_en <= '0';
              matinv_state <= waiting;
            end if;
          when others => matinv_state <= waiting;
        end case;
      end if;
    end if;
  end process;

  nt_to_addresses : process(clk_p)
    variable nr : integer;
    variable alinv_endrow : unsigned(7 downto 0);
    variable ddinv_endrow : unsigned(7 downto 0);
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        alinv_endrow := (others => '0');
        ddinv_endrow := (others => '0');
        nr := 0;
        matinv_resdrd_done <= '1';
        matinv_reswrd_done <= '1';
      else
        if matinv_start = '1' then
          nr := to_integer(unsigned(nt));
          alinv_endrow := to_unsigned(nr*(nr+1), 8) - 1; --total number of rows (nt*(nt+1))/2
          ddinv_endrow := shift_right(to_unsigned(nr*(nr+1), 8), 1) + (unsigned(nt)*2) - 1;
          matinv_resdrd_done <= '0';
          matinv_reswrd_done <= '0';
        elsif mode_latch = matrix and matinv_state = reading_dbuffer then 
          if left_finaladdress = std_logic_vector(alinv_endrow - 1) then
            matinv_resdrd_done <= '1';
          end if;
        elsif mode_latch = matrix and matinv_state = reading_wbuffer then
          if right_finaladdress = std_logic_vector(ddinv_endrow - 1) then
            matinv_reswrd_done <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  matinv_resload_to_reg : process(clk_p)
  begin
    if rising_edge(clk_p) then
      if rst = '0' then
        matinv_resload <= '0';
      else
        if matinv_done_pipe(10) = '1' and mode_latch = matrix then
          if matinv_resrd_en_i = '1' then
            if CLK_E_NEG = '0' then
              matinv_result(63 downto 0) <= data1 & data0; 
              matinv_resload <= '0';
            else
              matinv_result(127 downto 64) <= data1 & data0;
              matinv_resload <= '1';
            end if;
          elsif matinv_resrdw_en_i = '1' then
            if CLK_E_NEG = '1' then
              matinv_result(63 downto 0) <= weight_out; 
              matinv_resload <= '0';
            else
              matinv_result(127 downto 64) <= weight_out;
              matinv_resload <= '1';
            end if;
          else
            matinv_resload <= '0';
            matinv_result <= (others => '0');
          end if; 
        else
          matinv_resload <= '0';
          matinv_result <= (others => '0');
        end if;
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
        pushback_en <= '0';
        load_dtm_out <= '0';
      elsif reg_in = CONS_DFY_REG_SHIFT_IN then --write feedback(dfy) register through y bus
        if clk_e_neg = '1' then
          dfy_reg(to_integer(unsigned(dfy_dest_sel))) <= YBUS;
        end if;
      elsif output_ena = '1' then 
        if pp_ctl(4 downto 3) = "01" then --to feedback(dfy) register
          dfy_reg(to_integer(output_c)) <= outreg(7 downto 0);
          if output_c = x"7" then
            output_c <=(others => '0');
            pushback_en <= '1';
          else
            output_c <= output_c + 1;
            pushback_en <= '0';
          end if;
        elsif pp_ctl(4 downto 3) = "10" then --to DTM data register
          dtm_data_reg(to_integer(output_c)) <= outreg(7 downto 0);
          output_c <= output_c + 1;
        end if;
      end if;
      if pp_ctl(4 downto 3) = "10" and output_c(1 downto 0) = "11" and output_ena = '1' then
        load_dtm_out <= '1';
      else
        load_dtm_out <= '0';
      end if;
    end if;
    -- output to dtm
    for i in 0 to 15 loop
      ve_out_reg(8*i+7 downto 8*i) <= dtm_data_reg(i);
    end loop;
  end process;

  -- output to d-bus
  VE_OUT_D <= dtm_data_reg(to_integer(unsigned(out_byte_sel)));

  out_mux : process(all)
  begin
    case mode_latch is 
      when fft => VE_OUT_DTM <= fft_result;
      when matrix => VE_OUT_DTM <= matinv_result;
      when others => VE_OUT_DTM <= ve_out_reg;
    end case;
  end process;

  dtm_ctl_out : process(all)
  begin
    if pp_ctl(5) = '1' then
      ve_dtm_rdy <= load_dtm_out or fft_resload or matinv_resload;
    else
      ve_dtm_rdy <= '0';
    end if;
    if pp_ctl(6) = '1' then
      ve_push_dtm <= load_dtm_out or fft_resload or matinv_resload;
    else
      ve_push_dtm <= '0';
    end if;
    ve_auto_send <= pp_ctl(7);
  end process;

end architecture;  
