
This do a standalone depthwise convolusion with postprocessing.
Below here is were to load the data and from where and size to read it.



LOAD_MP 0x0     Depthwise_stride1_1A_short_pp_F.mp
LOAD_CM 0x4000  dw_data_left_top.bin
LOAD_CM 0x1000  CM_kernels_T_dw_u8_ref.bin
LOAD_CM 0x2000  CM_bias_dw_s16_ref.bin

START_VE

READ_CM 0x44000 out_result.bin 2592 1 1

VERIFY  out_result.bin 2592 dw_ref_left_top.bin
