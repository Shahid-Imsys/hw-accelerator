// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Jan 20 12:09:02 2022
// Host        : valhall.shortlink.local running 64-bit Red Hat Enterprise Linux Workstation release 7.6 (Maipo)
// Command     : write_verilog -force -mode synth_stub
//               /home/besv/Customers/Imsys/Imsys_git/hw-accelerator/Processors/IM3000E/fpga_synth/gpp/gpp.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_stub.v
// Design      : blk_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku5p-ffvb676-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.1" *)
module blk_mem_gen_0(clka, ena, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[10:0],dina[79:0],douta[79:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [10:0]addra;
  input [79:0]dina;
  output [79:0]douta;
endmodule
