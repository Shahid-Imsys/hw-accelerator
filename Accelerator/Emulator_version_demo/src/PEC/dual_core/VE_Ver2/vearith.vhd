library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity vearith is
  port(
    clk         : in  std_logic;
    enable_add     : in  std_logic;
    enable_mul     : in  std_logic;
    enable_acc     : in  std_logic;
    enable_sum     : in  std_logic;
    enable_lod     : in  std_logic;
    data        : in  std_logic_vector(63 downto 0);
    weight      : in  std_logic_vector(63 downto 0);
    feedback    : in  std_logic_vector(63 downto 0);
    ctrl_addmul : in  all_addmul_ctrl;
    ctrl_acc    : in  all_acc_ctrl;
    ppctrl      : in  pp_ctrl;
    lodctrl        : in  lzod_ctrl;
    zpdata      : in  std_logic_vector(7 downto 0);
    zpweight    : in  std_logic_vector(7 downto 0);
    result      : out signed(32 downto 0);
    to_shift    : out ppshift_shift_ctrl;
    to_addbias  : out std_logic
    );
end entity vearith;

architecture first of vearith is
-- Aliases
  alias aL7 : std_logic_vector(7 downto 0) is data(63 downto 56);
  alias aL6 : std_logic_vector(7 downto 0) is data(55 downto 48);
  alias aL5 : std_logic_vector(7 downto 0) is data(47 downto 40);
  alias aL4 : std_logic_vector(7 downto 0) is data(39 downto 32);
  alias aL3 : std_logic_vector(7 downto 0) is data(31 downto 24);
  alias aL2 : std_logic_vector(7 downto 0) is data(23 downto 16);
  alias aL1 : std_logic_vector(7 downto 0) is data(15 downto 8);
  alias aL0 : std_logic_vector(7 downto 0) is data(7 downto 0);

  alias aR7 : std_logic_vector(7 downto 0) is weight(63 downto 56);
  alias aR6 : std_logic_vector(7 downto 0) is weight(55 downto 48);
  alias aR5 : std_logic_vector(7 downto 0) is weight(47 downto 40);
  alias aR4 : std_logic_vector(7 downto 0) is weight(39 downto 32);
  alias aR3 : std_logic_vector(7 downto 0) is weight(31 downto 24);
  alias aR2 : std_logic_vector(7 downto 0) is weight(23 downto 16);
  alias aR1 : std_logic_vector(7 downto 0) is weight(15 downto 8);
  alias aR0 : std_logic_vector(7 downto 0) is weight(7 downto 0);

  alias aF7 : std_logic_vector(7 downto 0) is feedback(63 downto 56);
  alias aF6 : std_logic_vector(7 downto 0) is feedback(55 downto 48);
  alias aF5 : std_logic_vector(7 downto 0) is feedback(47 downto 40);
  alias aF4 : std_logic_vector(7 downto 0) is feedback(39 downto 32);
  alias aF3 : std_logic_vector(7 downto 0) is feedback(31 downto 24);
  alias aF2 : std_logic_vector(7 downto 0) is feedback(23 downto 16);
  alias aF1 : std_logic_vector(7 downto 0) is feedback(15 downto 8);
  alias aF0 : std_logic_vector(7 downto 0) is feedback(7 downto 0);

-- Constants
  constant czero   : std_logic_vector(7 downto 0) := "00000000";
  constant conefft : std_logic_vector(7 downto 0) := "10000000";
  constant cone    : std_logic_vector(7 downto 0) := "00000001";

-- Multiplexer outputs
  signal val7l0, val7l1, val7r0, val7r1 : std_logic_vector(7 downto 0);
  signal val6l0, val6l1, val6r0, val6r1 : std_logic_vector(7 downto 0);
  signal val5l0, val5l1, val5r0, val5r1 : std_logic_vector(7 downto 0);
  signal val4l0, val4l1, val4r0, val4r1 : std_logic_vector(7 downto 0);
  signal val3l0, val3l1, val3r0, val3r1 : std_logic_vector(7 downto 0);
  signal val2l0, val2l1, val2r0, val2r1 : std_logic_vector(7 downto 0);
  signal val1l0, val1l1, val1r0, val1r1 : std_logic_vector(7 downto 0);
  signal val0l0, val0l1, val0r0, val0r1 : std_logic_vector(7 downto 0);

-- multiplier result
  signal mul7, mul6, mul5, mul4, mul3, mul2, mul1, mul0 : signed(17 downto 0);

-- accumulator result
  signal acc7, acc6, acc5, acc4, acc3, acc2, acc1, acc0 : signed(31 downto 0);
  signal sign6, sign4, sign2, sign0 : std_logic;

  -- TODO: add abs sign

  component addmul is
    port(
      clk                    : in  std_logic;
      enable_add             : in  std_logic;
      enable_mul             : in  std_logic;
      inl0, inl1, inr0, inr1 : in  std_logic_vector(7 downto 0);
      ctrl                   : in  addmul_ctrl;
      am_res                 : out signed(17 downto 0)
      );
  end component;

  component accumulatorodd is
    port (
      clk    : in  std_logic;
      en : in  std_logic;
      mul    : in  signed(17 downto 0);
      ctrl   : in  acco_ctrl;
      result : out signed(31 downto 0)
      );
  end component;

  component accumulatoreven is
    port (
      clk          : in  std_logic;
      en       : in  std_logic;
      mul, mul_odd : in  signed(17 downto 0);
      ctrl         : in  acce_ctrl;
      result       : out signed(31 downto 0);
      sign_o       : out std_logic
      );
  end component;

  component ppadd is
    port (
      clk     : in  std_logic;
      en : in  std_logic;
      in7     : in  signed(31 downto 0);
      in6     : in  signed(31 downto 0);
      in5     : in  signed(31 downto 0);
      in4     : in  signed(31 downto 0);
      in3     : in  signed(31 downto 0);
      in2     : in  signed(31 downto 0);
      in1     : in  signed(31 downto 0);
      in0     : in  signed(31 downto 0);
      ctrl    : in  pp_ctrl;
      result  : out signed(32 downto 0)
      );
  end component;

  component lod
  port (
    clk      : in  std_logic;
    enable   : in  std_logic;
    data3    : in  std_logic_vector(31 downto 0);
    data2    : in  std_logic_vector(31 downto 0);
    data1    : in  std_logic_vector(31 downto 0);
    data0    : in  std_logic_vector(31 downto 0);
    sign3    : in std_logic;
    sign2    : in std_logic;
    sign1    : in std_logic;
    sign0    : in std_logic;
    ctrl     : in  lzod_ctrl;
    to_shift : out ppshift_shift_ctrl;
    to_addbias : out std_logic
  );
  end component lod;

begin


-- Lane 7

-- Input multiplexers

  with ctrl_addmul.mux7l0 select val7l0 <=
    aL7   when L7,
    czero when zero,
    aF7   when F7,
    aF5   when F5;

  with ctrl_addmul.mux7l1 select val7l1 <=
    zpdata when zpd,
    czero  when zero,
    aR7    when R7,
    aL3    when L3,
    aL5    when L5;
    -- TODO
    --conefft  when onefft;

  with ctrl_addmul.mux7r0 select val7r0 <=
    aR7     when R7,
    aR5     when R5,
    aR3     when R3,
    conefft when onefft,
    aL1     when L1,
    aF1     when F1,
    aF3     when F3,
    aF5     when F5;

  with ctrl_addmul.mux7r1 select val7r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am7 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val7l0,
      inl1   => val7l1,
      inr0   => val7r0,
      inr1   => val7r1,
      ctrl   => ctrl_addmul.addmul7,
      am_res => mul7
      );

-- Accumulator

  accum7 : accumulatorodd
    port map (
      clk    => clk,
      en => enable_acc,
      mul    => mul7,
      ctrl   => ctrl_acc.acc7,
      result => acc7
      );

-- Lane 6

-- Input multiplexers

  with ctrl_addmul.mux6l0 select val6l0 <=
    aL6   when L6,
    czero when zero,
    aF4   when F4,
    aF6   when F6;

  with ctrl_addmul.mux6l1 select val6l1 <=
    zpdata when zpd,
    czero  when zero,
    aR6    when R6,
    aL2    when L2,
    --aL0    when L0,
    aL4    when L4;

  with ctrl_addmul.mux6r0 select val6r0 <=
    aR7     when R7,
    aR6     when R6,
    aR5     when R5,
    aR3     when R3,
    conefft when onefft,
    aL1     when L1,
    aF1     when F1,
    aF3     when F3,
    aF5     when F5;

  with ctrl_addmul.mux6r1 select val6r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am6 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val6l0,
      inl1   => val6l1,
      inr0   => val6r0,
      inr1   => val6r1,
      ctrl   => ctrl_addmul.addmul6,
      am_res => mul6
      );

-- Accumulator

  accum6 : accumulatoreven
    port map (
      clk     => clk,
      en  => enable_acc,
      mul     => mul6,
      mul_odd => mul7,
      ctrl    => ctrl_acc.acc6,
      result  => acc6,
      sign_o  => sign6
      );

-- Lane 5

-- Input multiplexers

  with ctrl_addmul.mux5l0 select val5l0 <=
    aL7   when L7,
    aL5   when L5,
    czero when zero,
    aF5   when F5,
    aF7   when F7;

  with ctrl_addmul.mux5l1 select val5l1 <=
    zpdata when zpd,
    czero  when zero,
    aR5    when R5,
    aL3    when L3,
    aL5    when L5;

  with ctrl_addmul.mux5r0 select val5r0 <=
    aR6     when R6,
    aR5     when R5,
    aR4     when R4,
    aR2     when R2,
    conefft when onefft,
    aL0     when L0,
    aF0     when F0,
    aF2     when F2,
    aF4     when F4;

  with ctrl_addmul.mux5r1 select val5r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am5 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val5l0,
      inl1   => val5l1,
      inr0   => val5r0,
      inr1   => val5r1,
      ctrl   => ctrl_addmul.addmul5,
      am_res => mul5
      );

-- Accumulator

  accum5 : accumulatorodd
    port map (
      clk    => clk,
      en => enable_acc,
      mul    => mul5,
      ctrl   => ctrl_acc.acc5,
      result => acc5
      );

-- Lane 4

-- Input multiplexers

  with ctrl_addmul.mux4l0 select val4l0 <=
    aL6   when L6,
    aL4   when L4,
    czero when zero,
    aF4   when F4,
    aF6   when F6;

  with ctrl_addmul.mux4l1 select val4l1 <=
    zpdata when zpd,
    czero  when zero,
    aR4    when R4,
    aL2    when L2,
    aL4    when L4;

  with ctrl_addmul.mux4r0 select val4r0 <=
    aR6     when R6,
    aR4     when R4,
    aR2     when R2,
    conefft when onefft,
    aL0     when L0,
    aF0     when F0,
    aF2     when F2,
    aF4     when F4;

  with ctrl_addmul.mux4r1 select val4r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am4 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val4l0,
      inl1   => val4l1,
      inr0   => val4r0,
      inr1   => val4r1,
      ctrl   => ctrl_addmul.addmul4,
      am_res => mul4
      );

-- Accumulator

  accum4 : accumulatoreven
    port map (
      clk     => clk,
      en  => enable_acc,
      mul     => mul4,
      mul_odd => mul5,
      ctrl    => ctrl_acc.acc4,
      result  => acc4,
      sign_o  => sign4
      );

-- Lane 3

-- Input multiplexers

  with ctrl_addmul.mux3l0 select val3l0 <=
    aL5   when L5,
    aL3   when L3,
    czero when zero,
    AF7   when F7;

  with ctrl_addmul.mux3l1 select val3l1 <=
    zpdata when zpd,
    czero  when zero,
    aR3    when R3,
    aL1    when L1;

  with ctrl_addmul.mux3r0 select val3r0 <=
    aR7     when R7,
    aR5     when R5,
    aR3     when R3,
    aR1     when R1,
    cone    when one,
    conefft when onefft,
    aL3     when L3;

  with ctrl_addmul.mux3r1 select val3r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am3 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val3l0,
      inl1   => val3l1,
      inr0   => val3r0,
      inr1   => val3r1,
      ctrl   => ctrl_addmul.addmul3,
      am_res => mul3
      );

-- Accumulator

  accum3 : accumulatorodd
    port map (
      clk    => clk,
      en => enable_acc,
      mul    => mul3,
      ctrl   => ctrl_acc.acc3,
      result => acc3
      );

-- Lane 2

-- Input multiplexers

  with ctrl_addmul.mux2l0 select val2l0 <=
    aL2   when L2,
    aL4   when L4,
    czero when zero,
    aF6   when F6;

  with ctrl_addmul.mux2l1 select val2l1 <=
    zpdata when zpd,
    czero  when zero,
    aR2    when R2,
    aL0    when L0;

  with ctrl_addmul.mux2r0 select val2r0 <=
    aR7     when R7,
    aR5     when R5,
    aR3     when R3,
    aR2     when R2,
    aR1     when R1,
    cone    when one,
    conefft when onefft,
    aL3     when L3;

  with ctrl_addmul.mux2r1 select val2r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am2 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val2l0,
      inl1   => val2l1,
      inr0   => val2r0,
      inr1   => val2r1,
      ctrl   => ctrl_addmul.addmul2,
      am_res => mul2
      );

-- Accumulator

  accum2 : accumulatoreven
    port map (
      clk     => clk,
      en  => enable_acc,
      mul     => mul2,
      mul_odd => mul3,
      ctrl    => ctrl_acc.acc2,
      result  => acc2,
      sign_o  => sign2
      );

-- Lane 1

-- Input multiplexers

  with ctrl_addmul.mux1l0 select val1l0 <=
    aL1 when L1,
    aL5 when L5;

  with ctrl_addmul.mux1l1 select val1l1 <=
    zpdata when zpd,
    czero  when zero,
    aR1    when R1,
    aL1    when L1;

  with ctrl_addmul.mux1r0 select val1r0 <=
    aR6     when R6,
    aR4     when R4,
    aR2     when R2,
    aR1     when R1,
    aR0     when R0,
    conefft when onefft,
    aL2     when L2;

  with ctrl_addmul.mux1r1 select val1r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am1 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val1l0,
      inl1   => val1l1,
      inr0   => val1r0,
      inr1   => val1r1,
      ctrl   => ctrl_addmul.addmul1,
      am_res => mul1
      );

-- Accumulator

  accum1 : accumulatorodd
    port map (
      clk    => clk,
      en => enable_acc,
      mul    => mul1,
      ctrl   => ctrl_acc.acc1,
      result => acc1
      );


-- Lane 0

-- Input multiplexers

  with ctrl_addmul.mux0l0 select val0l0 <=
    aL0   when L0,
    aL4   when L4,
    czero when zero;

  with ctrl_addmul.mux0l1 select val0l1 <=
    zpdata when zpd,
    czero  when zero,
    aR0    when R0,
    aL0    when L0;

  with ctrl_addmul.mux0r0 select val0r0 <=
    aR6     when R6,
    aR4     when R4,
    aR2     when R2,
    aR0     when R0,
    conefft when onefft,
    aL2     when L2;

  with ctrl_addmul.mux0r1 select val0r1 <=
    zpweight when zpw,
    czero    when zero;

-- Adders and multipliers

  am0 : addmul
    port map (
      clk    => clk,
      enable_add => enable_add,
      enable_mul => enable_mul,
      inl0   => val0l0,
      inl1   => val0l1,
      inr0   => val0r0,
      inr1   => val0r1,
      ctrl   => ctrl_addmul.addmul0,
      am_res => mul0
      );

-- Accumulator

  accum0 : accumulatoreven
    port map (
      clk     => clk,
      en  => enable_acc,
      mul     => mul0,
      mul_odd => mul1,
      ctrl    => ctrl_acc.acc0,
      result  => acc0,
      sign_o  => sign0
      );

-- Post-processing

-- Summation

  summation : ppadd
    port map (
      clk     => clk,
      en => enable_sum,
      in7     => acc7,
      in6     => acc6,
      in5     => acc5,
      in4     => acc4,
      in3     => acc3,
      in2     => acc2,
      in1     => acc1,
      in0     => acc0,
      ctrl    => ppctrl,
      result  => result
      );

  -- Leading one detection
    lod_i : lod
    port map (
      clk      => clk,
      enable   => enable_lod,
      data3    => std_logic_vector(acc6),
      data2    => std_logic_vector(result(31 downto 0)), --TODO
      data1    => std_logic_vector(acc2),
      data0    => std_logic_vector(acc0),
      sign3    => sign6,
      sign2    => sign4,
      sign1    => sign2,
      sign0    => sign0,
      ctrl     => lodctrl,
      to_shift => to_shift,
      to_addbias => to_addbias
    );


end architecture;
