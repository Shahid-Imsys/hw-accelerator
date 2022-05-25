


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.instructiontypes.all;
use work.vetypes.all;


entity ve is
    port(
        CLK_P        : in std_logic;
        CLK_E_POS    : in std_logic;
        CLK_E_NEG    : in std_logic;
        RST          : in std_logic;
        --Control inputs
        DDI_VLD      : in std_logic;  --input data valid, from CC
        YBUS         : in std_logic_vector(7 downto 0); -- Y bus
        VE_IN        : in std_logic_vector(63 downto 0); --DFM input
        PL           : in std_logic_vector(127 downto 0);
        --Control outputs
        RE_RDY       : out std_logic; --Receive engine ready. Activates when re_loop is zero.
        VE_RDY       : out std_logic; --Vector engine ready. Activates when ve_loop is zero.
        VE_DTM_RDY   : out std_logic;
        VE_PUSH_DTM  : out std_logic;
        VE_AUTO_SEND : out std_logic;
        --Data outputs
        VE_OUT_D     : out std_logic_vector(7 downto 0);  --Output to DSL
        VE_OUT_DTM   : out std_logic_vector(127 downto 0)  --Output to MMR Block
       );
end entity ve;

architecture rtl of ve is
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
  -- signals 
  type instruction_array is array (integer range <>) of instruction;
  signal inst_pipe                 : instruction_array(0 to 15);
  signal clk                       : std_logic;
  signal start                     : std_logic;
  signal stages                    : unsigned(2 downto 0);
  signal nt                        : std_logic_vector(4 downto 0);
  signal data0addr_from_controller : std_logic_vector(7 downto 0);
  signal data1addr_from_controller : std_logic_vector(7 downto 0);
  signal data0addr_to_memory       : std_logic_vector(7 downto 0);
  signal data1addr_to_memory       : std_logic_vector(7 downto 0);
  signal tfaddr_from_controller    : std_logic_vector(7 downto 0);
  signal tfaddr_to_memory          : std_logic_vector(7 downto 0);
  signal bias_to_memory            : std_logic_vector(5 downto 0);
  signal read_en, read_en_o        : std_logic;
  signal read_en_w_o, read_en_b_o  : std_logic;
  signal write_en, write_en_o      : std_logic;
  signal write_en_w_o, write_en_b_o: std_logic;
  signal memreg_c                  : memreg_ctrl;
  signal writebuff_c               : memreg_ctrl;
  signal done                      : std_logic;
  signal finalstage                : std_logic;
  signal inst_arith                : instruction;
  signal inst_add                  : ppctrl_t;
  signal inst_shift                : ppshift_shift_ctrl;
  signal inst_addbias              : ppshift_addbias_ctrl;
  signal inst_clip                 : ppshift_clip_ctrl;
  signal data0                     : std_logic_vector(31 downto 0);
  signal data1                     : std_logic_vector(31 downto 0);
  signal weight                    : std_logic_vector(63 downto 0);
  signal zpdata                    : std_logic_vector(7 downto 0)  := (others => '0');
  signal zpweight                  : std_logic_vector(7 downto 0)  := (others => '0');
  signal bias                      : std_logic_vector(63 downto 0);
  signal outreg                    : std_logic_vector(63 downto 0);
  signal writebuffer               : std_logic_vector(63 downto 0);
  signal bias_mux_out              : std_logic_vector(15 downto 0);
  signal en                        : std_logic                     := '1';
  signal reset                     : std_logic                     := '0';
  signal stall                     : unsigned(3 downto 0);
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
  signal ve_addr_l   : std_logic_vector(7 downto 0); --data to address pointer left
  signal ve_saddr_l  : std_logic_vector(7 downto 0); --Left starting address register
  signal ve_addr_r   : std_logic_vector(7 downto 0);
  signal ve_saddr_r  : std_logic_vector(7 downto 0);
  signal ve_loop     : std_logic_vector(7 downto 0);
  signal ve_oloop    : std_logic_vector(7 downto 0);
  signal ve_loop_reg : std_logic_vector(7 downto 0);
  signal ve_oloop_reg : std_logic_vector(7 downto 0);
  signal offset_r    : std_logic_vector(7 downto 0); --right oprand offset register --expand to 8 bits, 1209
  signal jump_l    : std_logic_vector(7 downto 0);--Jump register
  signal depth_l   : std_logic_vector(7 downto 0);--depth register
  signal config    : std_logic_vector(7 downto 0); --configure register
  signal ring_end_addr : std_logic_vector(7 downto 0);
  signal ring_start_addr : std_logic_vector(7 downto 0);
  signal curr_ring_addr : std_logic_vector(7 downto 0);
  signal next_ring_addr : std_logic_vector(7 downto 0);
  signal scale      : std_logic_vector(4 downto 0); --shift scale factor
  signal pp_ctl  : std_logic_vector(7 downto 0); --expand this 8 bits, 1209
  signal bias_index_end : std_logic_vector(7 downto 0);
  signal bias_index_start : std_logic_vector(7 downto 0);
  signal bias_index_rd : std_logic_vector(7 downto 0);
  signal fw_layer   : std_logic_vector(23 downto 0); --feed forward layer, 24 bits.
  signal dfy_reg   : dfy_word;    --pushback(DFY) register
  signal dtm_data_reg : dtm_word;
  signal ve_start_reg : std_logic; --VE start latch
  signal re_addr_reload   : std_logic;
  signal ve_addr_reload   : std_logic;
  signal sclr_i        : std_logic; --For clear accumulator 0-7
  signal bias_buf_out : std_logic_vector(63 downto 0);
  signal bias_mux     : std_logic_vector(1 downto 0);
  signal p_adder_out : std_logic_vector(31 downto 0); --Adder output in post processing block
  signal p_shifter_out : std_logic_vector(31 downto 0); --shifter output in post processing block
  signal p_shifter_in : std_logic_vector(31 downto 0);
  signal p_clip_out : std_logic_vector(7 downto 0); --clip logic output
  signal bypass     : std_logic;
  signal sram_in    : std_logic_vector(63 downto 0);
  signal bias_in    : std_logic_vector(63 downto 0);

  signal sram_l_we  : std_logic;
  signal sram_r_we  : std_logic;
  signal sram_b_we  : std_logic;
  signal ve_clr_acc : std_logic; --clear accumulators
  signal mul_inn_ctl : std_logic;
  signal acc_inn_ctl : std_logic;
  signal pl_ve_byte : std_logic_vector(3 downto 0);


  signal addr_p_l  : std_logic_vector(7 downto 0);
  signal addr_p_r  : std_logic_vector(7 downto 0);
  signal addr_p_b  : std_logic_vector(5 downto 0);
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


    -- components
    -- TODO : mem components, data0, data1, weight; controllers : conv; 
    --component convcontroller is
    --    generic();
    --    port(); 
    --end component;

  component fftcontroller is
    generic(
      simulation : boolean := true
    );
    port(
      clk          : in  std_logic;
      en           : in  std_logic;
      start        : in  std_logic;
      stages       : in  unsigned(2 downto 0);
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

  component ldlcontroller is 
    port(
      clk                   : in std_logic;
      start                 : in std_logic;
      en_i                  : in std_logic;
      nt                    : in std_logic_vector(4 downto 0);--integer range 0 to 20 := 3;
      done                  : out std_logic;
      data0_addr_o          : out std_logic_vector(7 downto 0);
      data1_addr_o          : out std_logic_vector(7 downto 0);
      weight_addr_o         : out std_logic_vector(7 downto 0);
      data_read_enable_o    : out std_logic;
      data_write_enable_o   : out std_logic;
      weight_read_enable_o  : out std_logic;
      weight_write_enable_o : out std_logic;
      memreg_c_o            : out memreg_ctrl;
      writebuff_c_o         : out memreg_ctrl;
      inst_o                : out instruction;
      ppinst_o              : out ppctrl_t;
      ppshiftinst_shift_o   : out ppshift_shift_ctrl;
      ppshiftinst_addbias_o : out ppshift_addbias_ctrl;
      ppshiftinst_clip_o    : out ppshift_clip_ctrl;
      zpdata_o              : out std_logic_vector(7 downto 0);
      zpweight_o            : out std_logic_vector(7 downto 0);
      bias_o                : out std_logic_vector(63 downto 0);
      en_max_o              : out unsigned(3 downto 0)
    );
  end component;

  component ldlinvcontroller is
    port(
      clk                   : in std_logic;
      start                 : in std_logic;
      en_i                  : in std_logic;
      nt                    : in std_logic_vector(4 downto 0);
      done                  : out std_logic;
      data0_addr_o          : out std_logic_vector(7 downto 0);
      data1_addr_o          : out std_logic_vector(7 downto 0);
      weight_addr_o         : out std_logic_vector(7 downto 0);
      data_read_enable_o    : out std_logic;
      data_write_enable_o   : out std_logic;
      weight_read_enable_o  : out std_logic;
      weight_write_enable_o : out std_logic;
      memreg_c_o            : out memreg_ctrl;
      writebuff_c_o         : out memreg_ctrl;
      inst_o                : out instruction;
      ppinst_o              : out ppctrl_t;
      ppshiftinst_o         : out ppshift_shift_ctrl;
      addbiasinst_o         : out ppshift_addbias_ctrl;
      clipinst_o            : out ppshift_clip_ctrl;
      zpdata_o              : out std_logic_vector(7 downto 0);
      zpweight_o            : out std_logic_vector(7 downto 0);
      bias_o                : out std_logic_vector(63 downto 0);
      en_max_o              : out unsigned(3 downto 0)
    );
  end component;

  component ve_wctrlpipe is
    port(
      clk           : in  std_logic;
      reset         : in  std_logic;
      data0_addr_i  : in  std_logic_vector(7 downto 0);
      data1_addr_i  : in  std_logic_vector(7 downto 0);
      weight_addr_i : in  std_logic_vector(7 downto 0);
      data_ren_i    : in  std_logic;
      data_wen_i    : in  std_logic;
      weight_ren_i  : in  std_logic;
      weight_wen_i  : in  std_logic;
      data0_i       : in  std_logic_vector(31 downto 0);
      data1_i       : in  std_logic_vector(31 downto 0);
      weight_i      : in  std_logic_vector(63 downto 0);
      memreg_c_i    : in  memreg_ctrl;
      writebuff_c_i : in  memreg_ctrl;
      inst_i        : in  instruction;
      ppinst_i      : in  ppctrl_t;
      ppshiftinst_i : in  ppshift_shift_ctrl;
      addbiasinst_i : in  ppshift_addbias_ctrl;
      clipinst_i    : in  ppshift_clip_ctrl;
      zpdata_i      : in  std_logic_vector(7 downto 0);
      zpweight_i    : in  std_logic_vector(7 downto 0);
      bias_i        : in  std_logic_vector(15 downto 0);
      data0_addr_o  : out std_logic_vector(7 downto 0);
      data1_addr_o  : out std_logic_vector(7 downto 0);
      weight_addr_o : out std_logic_vector(7 downto 0);
      data_ren_o    : out std_logic;
      data_wen_o    : out std_logic;
      weight_ren_o  : out std_logic;
      weight_wen_o  : out std_logic;
      outreg_o      : out std_logic_vector(63 downto 0);
      writebuffer_o : out std_logic_vector(63 downto 0);
      stall         : in  unsigned(3 downto 0) := (others => '0');
      en_o          : out std_logic
    );
  end component;

  component mem is
    generic (
      width       : integer := 8;
      addressbits : integer := 2;
      columns : integer := 4
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

begin
  -- instances
  fftcontroller_i : fftcontroller
  generic map (
    simulation => false
  )
  port map (
    clk          => clk,
    en           => en,
    start        => start,
    stages       => stages,
    data0addr    => data0addr_from_controller,
    data1addr    => data1addr_from_controller,
    tfaddr       => tfaddr_from_controller,
    read_en      => read_en,
    write_en     => write_en,
    memreg_c     => memreg_c,
    writebuff_c  => writebuff_c,
    done         => done,
    finalstage   => finalstage,
    inst_arith   => inst_arith,
    inst_add     => inst_add,
    inst_shift   => inst_shift,
    inst_addbias => inst_addbias,
    inst_clip    => inst_clip,
    stall        => stall
  );

  ldlcontroller_i : ldlcontroller
  port map(
    clk                   => clk,
    start                 => start,
    en_i                  => en,
    nt                    => nt,
    done                  => done,
    data0_addr_o          => data0addr_from_controller,
    data1_addr_o          => data1addr_from_controller,
    weight_addr_o         => tfaddr_from_controller,
    data_read_enable_o    => read_en,
    data_write_enable_o   => write_en,
    weight_read_enable_o  => read_en_w_o,
    weight_write_enable_o => write_en_w_o,
    memreg_c_o            => memreg_c,
    writebuff_c_o         => writebuff_c,
    inst_o                => inst_arith,
    ppinst_o              => inst_add,
    ppshiftinst_shift_o   => inst_shift,
    ppshiftinst_addbias_o => inst_addbias,
    ppshiftinst_clip_o    => inst_clip,
    zpdata_o              => zpdata,
    zpweight_o            => zpweight,
    bias_o                => bias,
    en_max_o              => stall
  );

  ldlinvcontroller_i : ldlinvcontroller
  port map(
    clk                   => clk,
    start                 => start,
    en_i                  => en,
    nt                    => nt,
    done                  => done,
    data0_addr_o          => data0addr_from_controller,
    data1_addr_o          => data1addr_from_controller,
    weight_addr_o         => tfaddr_from_controller,
    data_read_enable_o    => read_en,
    data_write_enable_o   => write_en,
    weight_read_enable_o  => read_en_w_o,
    weight_write_enable_o => write_en_w_o,
    memreg_c_o            => memreg_c,
    writebuff_c_o         => writebuff_c,
    inst_o                => inst_arith,
    ppinst_o              => inst_add,
    ppshiftinst_o         => inst_shift,
    addbiasinst_o         => inst_addbias,
    clipinst_o            => inst_clip,
    zpdata_o              => zpdata,
    zpweight_o            => zpweight,
    bias_o                => bias,
    en_max_o              => stall
  );
    
  ve_wctrlpipe_i : ve_wctrlpipe
  port map(
    clk           => clk,
    reset         => reset,
    data0_addr_i  => data0addr_from_controller,
    data1_addr_i  => data1addr_from_controller,
    weight_addr_i => tfaddr_from_controller,
    data_ren_i    => read_en,                 --==========================--
    data_wen_i    => write_en,                --==== MUX needed for   ====--
    weight_ren_i  => read_en_w_o,             --==== these enables    ====--
    weight_wen_i  => write_en_w_o,            --==========================--
    data0_i       => data0,
    data1_i       => data1,
    weight_i      => weight,
    memreg_c_i    => memreg_c,
    writebuff_c_i => writebuff_c,
    inst_i        => inst_arith,
    ppinst_i      => inst_add,
    ppshiftinst_i => inst_shift,
    addbiasinst_i => inst_addbias,
    clipinst_i    => inst_clip,
    zpdata_i      => zpdata,
    zpweight_i    => zpweight,
    bias_i        => bias_mux_out,
    data0_addr_o  => data0addr_to_memory,
    data1_addr_o  => data1addr_to_memory,
    weight_addr_o => tfaddr_to_memory,
    data_ren_o    => read_en_o,
    data_wen_o    => write_en_o,
    weight_ren_o  => read_en_w_o,
    outreg_o      => outreg,
    writebuffer_o => writebuffer,
    stall         => stall,
    en_o          => en
  );

  mem_weight : mem
  generic map (
    width       => 64,
    addressbits => 8,
    columns => 4
  )
  port map (
    clk       => clk,
    read_en   => read_en_w_o,
    write_en  => write_en_w_o,
    d_in      => writebuffer,
    address   => tfaddr_to_memory,
    d_out     => weight
  );

  mem_bias : mem
  generic map (
    width       => 64,
    addressbits => 6,
    columns => 4
  )
  port map (
    clk       => clk,
    read_en   => read_en_b_o,
    write_en  => write_en_b_o,
    d_in      => writebuffer,
    address   => bias_to_memory,
    d_out     => bias
  );

  mem_d0 : mem
  generic map (
    width       => 32,
    addressbits => 8,
    columns => 2
  )
  port map (
    clk       => clk,
    read_en   => read_en_o,
    write_en  => write_en_o,
    d_in      => writebuffer(63 downto 32),
    address   => data0addr_to_memory,
    d_out     => data0
  );

  mem_d1 : mem
  generic map (
    width       => 32,
    addressbits => 8,
    columns => 2
  )
  port map (
    clk       => clk,
    read_en   => read_en_o,
    write_en  => write_en_o,
    d_in      => writebuffer(31 downto 0),
    address   => data0addr_to_memory,
    d_out     => data1
  );

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
  re_addr_reload <= PL(99);
  ve_addr_reload <= PL(107);
  ve_clr_acc <= PL(93);
  pl_ve_byte <= PL(112 downto 109);
    

end architecture;