// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Mar 14 15:39:08 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top dist_mem_gen_0 -prefix
//               dist_mem_gen_0_ dist_mem_gen_0_stub.v
// Design      : dist_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu9p-flga2104-2L-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2021.2" *)
module dist_mem_gen_0(a, d, clk, we, i_ce, qspo_ce, qspo)
/* synthesis syn_black_box black_box_pad_pin="a[10:0],d[79:0],clk,we,i_ce,qspo_ce,qspo[79:0]" */;
  input [10:0]a;
  input [79:0]d;
  input clk;
  input we;
  input i_ce;
  input qspo_ce;
  output [79:0]qspo;
endmodule
