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
            acc4 => (acc => keep, add => odd8, reg => keep),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => add),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when unispec,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => add)) when mulce,
            (acc7 => (acc => keep, add => zero, reg => keep),
            acc6 => (acc => keep, add => odd8, reg => add),
            acc5 => (acc => keep, add => zero, reg => keep),
            acc4 => (acc => keep, add => odd8, reg => add),
            acc3 => (acc => keep, add => zero, reg => keep),
            acc2 => (acc => keep, add => odd8, reg => keep),
            acc1 => (acc => keep, add => zero, reg => keep),
            acc0 => (acc => keep, add => odd8, reg => keep)) when mulcf;
end architecture;