library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;
use work.instructiontypes.all;

entity vecore is
  port (
    clk              : in  std_logic;
    enable_memreg    : in  std_logic;
    enable_add       : in  std_logic;
    enable_mul       : in  std_logic;
    enable_acc       : in  std_logic;
    enable_lod       : in  std_logic;
    enable_sum       : in  std_logic;
    enable_shift     : in  std_logic;
    enable_add_bias  : in  std_logic;
    enable_clip      : in  std_logic;
    enable_writebuff : in  std_logic;
    data0            : in  std_logic_vector(31 downto 0);
    data1            : in  std_logic_vector(31 downto 0);
    weight           : in  std_logic_vector(63 downto 0);
    memctrl          : in  memreg_ctrl;
    wbctrl           : in  memreg_ctrl;
    inst_addmul      : in  instruction;
    inst_acc         : in  instruction;
    ppinst           : in  ppctrl_t;
    shift_ctrl       : in  ppshift_shift_ctrl;
    bias_add_ctrl    : in  ppshift_addbias_ctrl;
    clip_ctrl        : in  ppshift_clip_ctrl;
    lodctrl          : in  lzod_ctrl;
    feedback_shift   : in  feedback_t;
    feedback_clip    : in  feedback_t;
    zpdata           : in  std_logic_vector(7 downto 0);
    zpweight         : in  std_logic_vector(7 downto 0);
    bias             : in  std_logic_vector(15 downto 0);
    shift_result     : out std_logic_vector(15 downto 0);
    outreg           : out std_logic_vector(63 downto 0);
    writebuffer      : out std_logic_vector(63 downto 0)
    );
end entity;

architecture first of vecore is
  signal decoded_addmul : all_addmul_ctrl;
  signal decoded_acc    : all_acc_ctrl;
  signal decoded_pp     : pp_ctrl;
  signal datareg        : std_logic_vector(63 downto 0);
  signal weightreg      : std_logic_vector(63 downto 0);
  signal outreg_int     : std_logic_vector(63 downto 0);
  signal sum            : signed(32 downto 0);
  signal shift_from_lod : ppshift_shift_ctrl;
  signal to_addbias     : std_logic;
  signal feedback       : std_logic_vector(63 downto 0);
  alias F3 is feedback(63 downto 48);
  alias F2 is feedback(47 downto 32);
  alias F1 is feedback(31 downto 16);
  alias F0 is feedback(15 downto 0);
  --signal shift_result   : std_logic_vector(15 downto 0);
  signal clip_result   : std_logic_vector(15 downto 0);

  component memreg
    port (
      clk       : in  std_logic;
      en        : in  std_logic;
      data0     : in  std_logic_vector(31 downto 0);
      data1     : in  std_logic_vector(31 downto 0);
      weight    : in  std_logic_vector(63 downto 0);
      ctrl      : in  memreg_ctrl;
      dataout   : out std_logic_vector(63 downto 0);
      weightout : out std_logic_vector(63 downto 0)
      );
  end component memreg;

  component vearith
  port (
    clk         : in  std_logic;
    enable_add  : in  std_logic;
    enable_mul  : in  std_logic;
    enable_acc  : in  std_logic;
    enable_sum  : in  std_logic;
    enable_lod  : in  std_logic;
    data        : in  std_logic_vector(63 downto 0);
    weight      : in  std_logic_vector(63 downto 0);
    feedback    : in  std_logic_vector(63 downto 0);
    ctrl_addmul : in  all_addmul_ctrl;
    ctrl_acc    : in  all_acc_ctrl;
    ppctrl      : in  pp_ctrl;
    lodctrl     : in  lzod_ctrl;
    zpdata      : in  std_logic_vector(7 downto 0);
    zpweight    : in  std_logic_vector(7 downto 0);
    result      : out signed(32 downto 0);
    to_shift    : out ppshift_shift_ctrl;
    to_addbias  : out std_logic
  );
  end component vearith;

  -- TODO: add abs sign


  component ctrlmap_alu
    port (
      inst    : in  instruction;
      decoded : out all_addmul_ctrl
      );
  end component ctrlmap_alu;

  component ctrlmap_acc
    port (
      inst    : in  instruction;
      decoded : out all_acc_ctrl
      );
  end component ctrlmap_acc;

  component ppmap1
    port (
      inst    : in  ppctrl_t;
      decoded : out pp_ctrl
      );
  end component ppmap1;


  component ppshift
  port (
    clk             : in  std_logic;
    enable_shift    : in  std_logic;
    enable_add_bias : in  std_logic;
    enable_clip     : in  std_logic;
    bias            : in  std_logic_vector(15 downto 0);
    sum             : in  signed(32 downto 0);
    shift_ctrl      : in  ppshift_shift_ctrl;
    bias_add_ctrl   : in  ppshift_addbias_ctrl;
    clip_ctrl       : in  ppshift_clip_ctrl;
    lod_res         : in  ppshift_shift_ctrl;
    lod_neg         : in  std_logic;
    shift_result    : out std_logic_vector(15 downto 0);
    clip_result     : out std_logic_vector(15 downto 0);
    outreg          : out std_logic_vector(63 downto 0)
  );
  end component ppshift;


  component writebuff
    port (
      clk     : in  std_logic;
      en      : in  std_logic;
      data    : in  std_logic_vector(63 downto 0);
      ctrl    : in  memreg_ctrl;
      dataout : out std_logic_vector(63 downto 0)
      );
  end component writebuff;


begin

  -- Memory register for read
  memreg_i : memreg
    port map (
      clk       => clk,
      en        => enable_memreg,
      data0     => data0,
      data1     => data1,
      weight    => weight,
      ctrl      => memctrl,
      dataout   => datareg,
      weightout => weightreg
      );

  -- Arithmetic unit
  vearith_i : vearith
    port map (
      clk         => clk,
      enable_add  => enable_add,
      enable_mul  => enable_mul,
      enable_acc  => enable_acc,
      enable_sum  => enable_sum,
      enable_lod  => enable_lod,
      data        => datareg,
      weight      => weightreg,
      feedback    => feedback,
      ctrl_addmul => decoded_addmul,
      ctrl_acc    => decoded_acc,
      ppctrl      => decoded_pp,
      lodctrl     => lodctrl,
      zpdata      => zpdata,
      zpweight    => zpweight,
      result      => sum,
      to_shift    => shift_from_lod,
      to_addbias  => to_addbias
      );

  -- Instruction decoder for arithmetic unit muxes and adders
  ctrlmap_alu_i : ctrlmap_alu
    port map (
      inst    => inst_addmul,
      decoded => decoded_addmul
      );

  -- Instruction decoder for arithmetic unit accumulators
  ctrlmap_acc_i : ctrlmap_acc
    port map (
      inst    => inst_acc,
      decoded => decoded_acc
      );


  -- Instruction decoder for arithmetic unit post-summation
  ppmap1_i : ppmap1
    port map (
      inst    => ppinst,
      decoded => decoded_pp
      );


  -- Shift
  shift : ppshift
    port map (
      enable_shift    => enable_shift,
      enable_add_bias => enable_add_bias,
      enable_clip     => enable_clip,
      clk             => clk,
      bias            => bias,
      sum             => sum,
      shift_ctrl      => shift_ctrl,
      bias_add_ctrl   => bias_add_ctrl,
      clip_ctrl       => clip_ctrl,
      lod_res         => shift_from_lod,
      lod_neg         => to_addbias,
      shift_result    => shift_result,
      clip_result     => clip_result,
      outreg          => outreg_int
      );

  -- Buffer for writing
  writebuff_i : writebuff
    port map (
      clk     => clk,
      en      => enable_writebuff,
      data    => outreg_int,
      ctrl    => wbctrl,
      dataout => writebuffer
      );

  outreg <= outreg_int;

  feedback_update : process(bias, clk)
  begin
    F0 <= bias;
    if rising_edge(clk) then
      if enable_shift = '1' then
        if feedback_shift = shift_to_3 then
          F3 <= shift_result;
        elsif feedback_shift = shift_to_2 then
          F2 <= shift_result;
        end if;
      end if;
      if enable_clip = '1' then
        -- TODO
        --if feedback_clip = clip_to_3 then
        --  F3 <= clip_result;
        --elsif feedback_clip = clip_to_1 then
        if feedback_clip = clip_to_1 then
          F1 <= clip_result;
        end if;
      end if;
    end if;
  end process;

end architecture;
