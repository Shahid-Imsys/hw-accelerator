--control map for accumulator
--this block maps the control instructions from controller
--to accumulators.

use work.vetypes.all;
use work.instructiontypes.all;

entity ctrlmap_acc is
port (
  inst : in instruction;
  decoded : out all_acc_ctrl);
end entity;

architecture generated of ctrlmap_acc is
begin
with inst select decoded <= 
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => zero, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => zero, reg => keep)) when fftadd0,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => keep),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => zero, reg => keep),
            acc3 => (acc => keep, add => zero, reg => add),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => zero, reg => add)) when fftadd1,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when fftsub0,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when fftsub1,
            (acc7 => (acc => acc, add => acc, reg => keep),
            acc6 => (acc => acc, add => acc, reg => keep),
            acc5 => (acc => acc, add => acc, reg => keep),
            acc4 => (acc => acc, add => acc, reg => keep),
            acc3 => (acc => acc, add => acc, reg => keep),
            acc2 => (acc => acc, add => acc, reg => keep),
            acc1 => (acc => acc, add => acc, reg => keep),
            acc0 => (acc => acc, add => acc, reg => keep)) when conv,
            (acc7 => (acc => acc, add => zero, reg => keep),
            acc6 => (acc => acc, add => zero, reg => keep),
            acc5 => (acc => acc, add => zero, reg => keep),
            acc4 => (acc => acc, add => zero, reg => keep),
            acc3 => (acc => acc, add => zero, reg => keep),
            acc2 => (acc => acc, add => zero, reg => keep),
            acc1 => (acc => acc, add => zero, reg => keep),
            acc0 => (acc => acc, add => zero, reg => keep)) when firstconv,
            (acc7 => (acc => acc, add => acc, reg => add),
            acc6 => (acc => acc, add => acc, reg => add),
            acc5 => (acc => acc, add => acc, reg => add),
            acc4 => (acc => acc, add => acc, reg => add),
            acc3 => (acc => acc, add => acc, reg => add),
            acc2 => (acc => acc, add => acc, reg => add),
            acc1 => (acc => acc, add => acc, reg => add),
            acc0 => (acc => acc, add => acc, reg => add)) when lastconv,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd, reg => add)) when sum,
            (acc7 => (acc => keep, add => acc, reg => keep),
            acc6 => (acc => keep, add => acc, reg => keep),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => acc, reg => keep),
            acc3 => (acc => keep, add => acc, reg => keep),
            acc2 => (acc => keep, add => acc, reg => keep),
            acc1 => (acc => keep, add => acc, reg => keep),
            acc0 => (acc => keep, add => acc, reg => keep)) when nop,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul00,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul01,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul11,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul10,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => zero, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when matadd00,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => keep),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => zero, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when matadd01,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => keep),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => zero, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when matadd10,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => keep),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => zero, reg => keep),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => zero, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matadd11,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matsub,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matdet,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul00t,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul01t,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul11t,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when matmul10t,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when unitri1,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when unitri2,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => keep),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when unitri3,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when unitri4,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when unispec,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => abs16, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => abs16, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => abs16, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => abs16, reg => add)) when abs16,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when mulden,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when mulnum,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when nrit,
            (acc7 => (acc => max, add => max, reg => keep),
            acc6 => (acc => max, add => max, reg => keep),
            acc5 => (acc => max, add => max, reg => keep),
            acc4 => (acc => max, add => max, reg => keep),
            acc3 => (acc => max, add => max, reg => keep),
            acc2 => (acc => max, add => max, reg => keep),
            acc1 => (acc => max, add => max, reg => keep),
            acc0 => (acc => max, add => max, reg => keep)) when max,
            (acc7 => (acc => max, add => zero, reg => keep),
            acc6 => (acc => max, add => zero, reg => keep),
            acc5 => (acc => max, add => zero, reg => keep),
            acc4 => (acc => max, add => zero, reg => keep),
            acc3 => (acc => max, add => zero, reg => keep),
            acc2 => (acc => max, add => zero, reg => keep),
            acc1 => (acc => max, add => zero, reg => keep),
            acc0 => (acc => max, add => zero, reg => keep)) when firstmax,
            (acc7 => (acc => max, add => zero, reg => max),
            acc6 => (acc => max, add => zero, reg => max),
            acc5 => (acc => max, add => zero, reg => max),
            acc4 => (acc => max, add => zero, reg => max),
            acc3 => (acc => max, add => zero, reg => max),
            acc2 => (acc => max, add => zero, reg => max),
            acc1 => (acc => max, add => zero, reg => max),
            acc0 => (acc => max, add => zero, reg => max)) when lastmax,
            (acc7 => (acc => zero, add => zero, reg => keep),
            acc6 => (acc => zero, add => zero, reg => keep),
            acc5 => (acc => zero, add => zero, reg => keep),
            acc4 => (acc => zero, add => zero, reg => keep),
            acc3 => (acc => zero, add => zero, reg => keep),
            acc2 => (acc => zero, add => zero, reg => keep),
            acc1 => (acc => zero, add => zero, reg => keep),
            acc0 => (acc => zero, add => zero, reg => keep)) when zeroacc,
            (acc7 => (acc => keep, add => zero, reg => add),
            acc6 => (acc => keep, add => zero, reg => add),
            acc5 => (acc => keep, add => zero, reg => add),
            acc4 => (acc => keep, add => zero, reg => add),
            acc3 => (acc => keep, add => zero, reg => add),
            acc2 => (acc => keep, add => zero, reg => add),
            acc1 => (acc => keep, add => zero, reg => add),
            acc0 => (acc => keep, add => zero, reg => add)) when acctoout;
end architecture;