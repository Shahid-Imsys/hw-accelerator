library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vetypes is
  type au_param is array(3 downto 0) of unsigned(7 downto 0);
  type dfy_word is array(7 downto 0) of std_logic_vector(7 downto 0);
  type dtm_word is array(15 downto 0) of std_logic_vector(7 downto 0);
  type mode is (re_mode, conv, fft, matrix);
  type read_state is (waiting, reading_dmem, reading_wmem);

  type sign_t is (s, u);
  type swap_t is (noswap, swap, switch);
  type addsub_t is (add, sub);
  type addsub2_t is (add, sub, subl);
  type enable_t is (enable, hold);

  type mux7l0_t is (zero, L7, F5, F7);
  -- TODO
  --type mux7l1_t is (zpd, zero, R7, L3, onefft, L5);
  type mux7l1_t is (zpd, zero, R7, L3, L5);
  type mux7r0_t is (R7, R3, R5, onefft, L1, F1, F3, F5);
  type mux7r1_t is (zpw, zero);

  type mux6l0_t is (zero, L6, F4, F6);
  -- TODO
  --type mux6l1_t is (zpd, zero, R6, L2, L0, L4);
  type mux6l1_t is (zpd, zero, R6, L2, L4);
  type mux6r0_t is (R6, R3, R5, R7, onefft, L1, F1, F3, F5);
  type mux6r1_t is (zpw, zero);

  type mux5l0_t is (zero, L5, L7, F5, F7);
  type mux5l1_t is (zpd, zero, R5, L3, L5);
  type mux5r0_t is (R5, R2, R4, R6, onefft, L0, F0, F2, F4);
  type mux5r1_t is (zpw, zero);

  type mux4l0_t is (zero, L4, L6, F4, F6);
  type mux4l1_t is (zpd, zero, R4, L2, L4);
  type mux4r0_t is (R4, R2, R6, onefft, L0, F0, F2, F4);
  type mux4r1_t is (zpw, zero);

  type mux3l0_t is (zero, L3, L5, F7);
  type mux3l1_t is (zpd, zero, R3, L1);
  type mux3r0_t is (R3, R1, R5, R7, one, onefft, L3);
  type mux3r1_t is (zpw, zero);

  type mux2l0_t is (zero, L2, L4, F6);
  type mux2l1_t is (zpd, zero, R2, L0);
  type mux2r0_t is (R2, R1, R3, R5, R7, one, onefft, L3);
  type mux2r1_t is (zpw, zero);

  type mux1l0_t is (L1, L5);
  type mux1l1_t is (zpd, zero, R1, L1);
  type mux1r0_t is (R1, R0, R2, R4, R6, onefft, L2);
  type mux1r1_t is (zpw, zero);

  type mux0l0_t is (zero, L0, L4);
  type mux0l1_t is (zpd, zero, R0, L0);
  type mux0r0_t is (R0, R2, R4, R6, onefft, L2);
  type mux0r1_t is (zpw, zero);

  type acc_t is (keep, acc, zero, max);
  type addo_t is (zero, acc, max);
  type adde_t is (zero, acc, odd, odd8, abs16, max);
  type reg_t is (keep, add, acc, max);

  type ppodd_t is (zero, add, add8, left);
  type ppeven_t is (zero, add, left);
  type ppadd_t is (zero, acc);
  type ppacc_t is (pass, negate, addbias);
  type shift_t is (left, right);
  type clip_t is (none, clip8, clip16, clipone16, clipzero);
  type outreg_t is (none, out7, out6, out5, out4, out3, out2, out1, out0, out76, out54, out32, out10);
  type quant_t is (trunc, round, unbiased);
  type lzod_t is (none, store1, store2, store3);
  --type lzod_out_t is (none, val, diff, nrit, nrit2, det1, det2);
  type lzod_out_t is (none, val, nrit, nrit2, det1);
  type ppctrl_t is (nop, add32, add10, add21, fftsub0, fftsub1, sumfirst, sum, sumall,
                    select7, select6, select5, select4, select3, select2, select1,
                    select0, unitri, sum16, sum16left, matmulleft, nrit);
  function to_ppctrl_t (v : std_logic_vector(3 downto 0)) return ppctrl_t;
  type feedback_t is (keep, shift_to_3, shift_to_2, clip_to_3, clip_to_1);
  type bias_addr_t is (ctrl,shift);

  -- alias matadd00 is add32 [return ppctrl_t];
  -- alias fftadd0 is add32 [return ppctrl_t];
  -- alias matadd11 is add10 [return ppctrl_t];
  -- alias fftadd1 is add10 [return ppctrl_t];
  -- alias matadd01 is add21 [return ppctrl_t];
  -- alias matadd10 is add21 [return ppctrl_t];
  -- alias matmul is fftsub1 [return ppctrl_t];
  -- alias sum16first is fftsub1 [return ppctrl_t];
  -- alias zero is pass [return ppacc_t];

  type addmul_ctrl is record
    signl0    : sign_t;
    signl1    : sign_t;
    signr0    : sign_t;
    signr1    : sign_t;
    addsubl   : addsub_t;
    addsubr   : addsub_t;
    en_addmul : enable_t;
  end record;

  type acco_ctrl is record
    acc : acc_t;
    add : addo_t;
    reg : reg_t;
  end record;

  type acce_ctrl is record
    acc : acc_t;
    add : adde_t;
    reg : reg_t;
  end record;

  type all_addmul_ctrl is record
    mux7l0  : mux7l0_t;
    mux7l1  : mux7l1_t;
    mux7r0  : mux7r0_t;
    mux7r1  : mux7r1_t;
    addmul7 : addmul_ctrl;

    mux6l0  : mux6l0_t;
    mux6l1  : mux6l1_t;
    mux6r0  : mux6r0_t;
    mux6r1  : mux6r1_t;
    addmul6 : addmul_ctrl;

    mux5l0  : mux5l0_t;
    mux5l1  : mux5l1_t;
    mux5r0  : mux5r0_t;
    mux5r1  : mux5r1_t;
    addmul5 : addmul_ctrl;

    mux4l0  : mux4l0_t;
    mux4l1  : mux4l1_t;
    mux4r0  : mux4r0_t;
    mux4r1  : mux4r1_t;
    addmul4 : addmul_ctrl;

    mux3l0  : mux3l0_t;
    mux3l1  : mux3l1_t;
    mux3r0  : mux3r0_t;
    mux3r1  : mux3r1_t;
    addmul3 : addmul_ctrl;

    mux2l0  : mux2l0_t;
    mux2l1  : mux2l1_t;
    mux2r0  : mux2r0_t;
    mux2r1  : mux2r1_t;
    addmul2 : addmul_ctrl;

    mux1l0  : mux1l0_t;
    mux1l1  : mux1l1_t;
    mux1r0  : mux1r0_t;
    mux1r1  : mux1r1_t;
    addmul1 : addmul_ctrl;

    mux0l0  : mux0l0_t;
    mux0l1  : mux0l1_t;
    mux0r0  : mux0r0_t;
    mux0r1  : mux0r1_t;
    addmul0 : addmul_ctrl;
  end record all_addmul_ctrl;

  type all_acc_ctrl is record
    acc7    : acco_ctrl;
    acc6    : acce_ctrl;
    acc5    : acco_ctrl;
    acc4    : acce_ctrl;
    acc3    : acco_ctrl;
    acc2    : acce_ctrl;
    acc1    : acco_ctrl;
    acc0    : acce_ctrl;
  end record all_acc_ctrl;

  type pp_ctrl is record
    mux3   : ppodd_t;
    mux2   : ppeven_t;
    mux1   : ppodd_t;
    mux0   : ppeven_t;
    acc    : ppadd_t;
    addsub : addsub2_t;
    reg    : enable_t;
  end record pp_ctrl;

  type ppshift_shift_ctrl is record
    acce      : enable_t;
    shift     : natural range 0 to 31;
    use_lod   : std_logic;
    shift_dir : shift_t;
  end record ppshift_shift_ctrl;

  type ppshift_addbias_ctrl is record
    acc       : ppacc_t;
    quant     : quant_t;
  end record ppshift_addbias_ctrl;

  type ppshift_clip_ctrl is record
    clip      : clip_t;
    outreg    : outreg_t;
  end record ppshift_clip_ctrl;

  type lzod_ctrl is record
    word : std_logic_vector(1 downto 0);
    store : lzod_t;
    output : lzod_out_t;
  end record lzod_ctrl;

  type memreg_ctrl is record
    swap      : swap_t;
    datareg   : enable_t;
    weightreg : enable_t;
  end record;
end package;

package body vetypes is
  function to_ppctrl_t (v : std_logic_vector(3 downto 0)) return ppctrl_t is
  begin
    return ppctrl_t'val(to_integer(unsigned(v)));
  end function;
end package body;
