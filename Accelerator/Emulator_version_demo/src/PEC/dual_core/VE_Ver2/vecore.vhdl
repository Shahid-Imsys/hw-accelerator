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
    lzo_ctrl         : in  lzod_ctrl;
    zpdata           : in  std_logic_vector(7 downto 0);
    zpweight         : in  std_logic_vector(7 downto 0);
    bias             : in  std_logic_vector(31 downto 0);
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
  signal lzo1, lzo2     : std_logic_vector(3 downto 0);

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
      data        : in  std_logic_vector(63 downto 0);
      weight      : in  std_logic_vector(63 downto 0);
      ctrl_addmul : in  all_addmul_ctrl;
      ctrl_acc    : in  all_acc_ctrl;
      ppctrl      : in  pp_ctrl;
      zpdata      : in  std_logic_vector(7 downto 0);
      zpweight    : in  std_logic_vector(7 downto 0);
      result      : out signed(32 downto 0)
      );
  end component vearith;

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


  component ppshift is
    port (
      clk             : in  std_logic;
      enable_shift    : in  std_logic;
      enable_add_bias : in  std_logic;
      enable_clip     : in  std_logic;
      bias            : in  std_logic_vector(31 downto 0);
      sum             : in  signed(32 downto 0);
      shift_ctrl      : in  ppshift_shift_ctrl;
      bias_add_ctrl   : in  ppshift_addbias_ctrl;
      clip_ctrl       : in  ppshift_clip_ctrl;
      outreg          : out std_logic_vector(63 downto 0)
      );
  end component;

  component writebuff
    port (
      clk     : in  std_logic;
      en      : in  std_logic;
      data    : in  std_logic_vector(63 downto 0);
      ctrl    : in  memreg_ctrl;
      dataout : out std_logic_vector(63 downto 0)
      );
  end component writebuff;

  component lzod
  port (
    clk    : in  std_logic;
    enable : in  std_logic;
    data   : in  std_logic_vector(63 downto 0);
    ctrl   : in  lzod_ctrl;
    lzo1   : out std_logic_vector(3 downto 0);
    lzo2   : out std_logic_vector(3 downto 0)
  );
  end component lzod;

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
      data        => datareg,
      weight      => weightreg,
      ctrl_addmul => decoded_addmul,
      ctrl_acc    => decoded_acc,
      ppctrl      => decoded_pp,
      zpdata      => zpdata,
      zpweight    => zpweight,
      result      => sum
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

  -- Leading zero-one detector
  lzod_i : lzod
    port map (
      clk    => clk,
      enable => enable_add,
      data   => datareg,
      ctrl   => lzo_ctrl,
      lzo1   => lzo1,
      lzo2   => lzo2
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

end architecture;
