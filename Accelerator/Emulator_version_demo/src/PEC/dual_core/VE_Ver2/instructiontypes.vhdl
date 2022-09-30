package instructiontypes is
type instruction is (fftadd0, fftadd1, fftsub0, fftsub1, conv, firstconv, lastconv, sum, nop, matmul00, matmul01, matmul11, matmul10, matadd00, matadd01, matadd10, matadd11, matsub, matdet, matmul00t, matmul01t, matmul11t, matmul10t, unitri1, unitri2, unitri3, unitri4, unispec, abs16, mulden, mulnum, nrit, max, firstmax, lastmax, zeroacc, acctoout);
end package instructiontypes;
