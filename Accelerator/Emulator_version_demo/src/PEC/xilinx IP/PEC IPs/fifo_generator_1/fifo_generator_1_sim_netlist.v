// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Nov  2 13:28:25 2021
// Host        : LAPTOP-8S3BREPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/work/Hardware/FPGA/cc_net_pe/cc_net_pe.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1_sim_netlist.v
// Design      : fifo_generator_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku5p-ffvb676-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_generator_1,fifo_generator_v13_2_3,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module fifo_generator_1
   (clk,
    srst,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    almost_full,
    empty,
    almost_empty,
    valid,
    data_count,
    prog_empty,
    wr_rst_busy,
    rd_rst_busy);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME core_clk, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input clk;
  input srst;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [31:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [31:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE ALMOST_FULL" *) output almost_full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ ALMOST_EMPTY" *) output almost_empty;
  output valid;
  output [9:0]data_count;
  output prog_empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire almost_empty;
  wire almost_full;
  wire clk;
  wire [9:0]data_count;
  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire prog_empty;
  wire rd_en;
  wire rd_rst_busy;
  wire srst;
  wire valid;
  wire wr_en;
  wire wr_rst_busy;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [9:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [9:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "10" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "32" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "32" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "kintexuplus" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "1" *) 
  (* C_HAS_ALMOST_FULL = "1" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "1" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "1" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "1" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "0" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "2" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "1" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "1022" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "1021" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "10" *) 
  (* C_RD_DEPTH = "1024" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "10" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "1" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "10" *) 
  (* C_WR_DEPTH = "1024" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "10" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  fifo_generator_1_fifo_generator_v13_2_3 U0
       (.almost_empty(almost_empty),
        .almost_full(almost_full),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(data_count),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(prog_empty),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[9:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(srst),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(valid),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[9:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_generic_cstr" *) 
module fifo_generator_1_blk_mem_gen_generic_cstr
   (dout,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    din);
  output [31:0]dout;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input [31:0]din;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;

  fifo_generator_1_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .Q(Q),
        .SS(SS),
        .clk(clk),
        .din(din),
        .dout(dout),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module fifo_generator_1_blk_mem_gen_prim_width
   (dout,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    din);
  output [31:0]dout;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input [31:0]din;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;

  fifo_generator_1_blk_mem_gen_prim_wrapper \prim_noinit.ram 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_1 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .Q(Q),
        .SS(SS),
        .clk(clk),
        .din(din),
        .dout(dout),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper" *) 
module fifo_generator_1_blk_mem_gen_prim_wrapper
   (dout,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_1 ,
    din);
  output [31:0]dout;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_1 ;
  input [31:0]din;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_1 ;
  wire \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_144 ;
  wire \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_145 ;
  wire \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_146 ;
  wire \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_147 ;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;
  wire \NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASOUTDBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASOUTSBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTA_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTB_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTPA_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTPB_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOUTADOUT_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOUTPADOUTP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E2 #(
    .CASCADE_ORDER_A("NONE"),
    .CASCADE_ORDER_B("NONE"),
    .CLOCK_DOMAINS("COMMON"),
    .DOA_REG(1),
    .DOB_REG(1),
    .ENADDRENA("FALSE"),
    .ENADDRENB("FALSE"),
    .EN_ECC_PIPE("FALSE"),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RDADDRCHANGEA("FALSE"),
    .RDADDRCHANGEB("FALSE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(36),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SLEEP_ASYNC("FALSE"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(36),
    .WRITE_WIDTH_B(36)) 
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({Q,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ADDRBWRADDR({\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_1 ,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ADDRENA(1'b0),
        .ADDRENB(1'b0),
        .CASDIMUXA(1'b0),
        .CASDIMUXB(1'b0),
        .CASDINA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASDINB({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASDINPA({1'b0,1'b0,1'b0,1'b0}),
        .CASDINPB({1'b0,1'b0,1'b0,1'b0}),
        .CASDOMUXA(1'b0),
        .CASDOMUXB(1'b0),
        .CASDOMUXEN_A(1'b0),
        .CASDOMUXEN_B(1'b0),
        .CASDOUTA(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTA_UNCONNECTED [31:0]),
        .CASDOUTB(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTB_UNCONNECTED [31:0]),
        .CASDOUTPA(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTPA_UNCONNECTED [3:0]),
        .CASDOUTPB(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASDOUTPB_UNCONNECTED [3:0]),
        .CASINDBITERR(1'b0),
        .CASINSBITERR(1'b0),
        .CASOREGIMUXA(1'b0),
        .CASOREGIMUXB(1'b0),
        .CASOREGIMUXEN_A(1'b0),
        .CASOREGIMUXEN_B(1'b0),
        .CASOUTDBITERR(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASOUTDBITERR_UNCONNECTED ),
        .CASOUTSBITERR(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASOUTSBITERR_UNCONNECTED ),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DINADIN(din),
        .DINBDIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DINPADINP({1'b0,1'b0,1'b0,1'b0}),
        .DINPBDINP({1'b0,1'b0,1'b0,1'b0}),
        .DOUTADOUT(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOUTADOUT_UNCONNECTED [31:0]),
        .DOUTBDOUT(dout),
        .DOUTPADOUTP(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOUTPADOUTP_UNCONNECTED [3:0]),
        .DOUTPBDOUTP({\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_144 ,\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_145 ,\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_146 ,\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_147 }),
        .ECCPARITY(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ECCPIPECE(1'b0),
        .ENARDEN(\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .ENBWREN(tmp_ram_rd_en),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(tmp_ram_regce),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(SS),
        .SBITERR(\NLW_DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .SLEEP(1'b0),
        .WEA({\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 }),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_top" *) 
module fifo_generator_1_blk_mem_gen_top
   (dout,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    din);
  output [31:0]dout;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input [31:0]din;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;

  fifo_generator_1_blk_mem_gen_generic_cstr \valid.cstr 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .Q(Q),
        .SS(SS),
        .clk(clk),
        .din(din),
        .dout(dout),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_4_2" *) 
module fifo_generator_1_blk_mem_gen_v8_4_2
   (dout,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    din);
  output [31:0]dout;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input [31:0]din;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;

  fifo_generator_1_blk_mem_gen_v8_4_2_synth inst_blk_mem_gen
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .Q(Q),
        .SS(SS),
        .clk(clk),
        .din(din),
        .dout(dout),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_4_2_synth" *) 
module fifo_generator_1_blk_mem_gen_v8_4_2_synth
   (dout,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    din);
  output [31:0]dout;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input [31:0]din;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;

  fifo_generator_1_blk_mem_gen_top \gnbram.gnativebmg.native_blk_mem_gen 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .Q(Q),
        .SS(SS),
        .clk(clk),
        .din(din),
        .dout(dout),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
endmodule

(* ORIG_REF_NAME = "bram_fifo_rstlogic" *) 
module fifo_generator_1_bram_fifo_rstlogic
   (wr_rst_reg_reg_0,
    tmp_ram_regce,
    SS,
    srst,
    clk,
    ram_rd_en_d1);
  output wr_rst_reg_reg_0;
  output tmp_ram_regce;
  output [0:0]SS;
  input srst;
  input clk;
  input ram_rd_en_d1;

  wire [0:0]SS;
  wire clk;
  (* async_reg = "true" *) wire d_asreg;
  wire ram_rd_en_d1;
  (* async_reg = "true" *) wire rd_rst_reg;
  (* async_reg = "true" *) wire rdrst_q1;
  (* async_reg = "true" *) wire rdrst_q2;
  (* async_reg = "true" *) wire rdrst_q3;
  (* async_reg = "true" *) wire rst_d1;
  (* async_reg = "true" *) wire rst_d2;
  wire srst;
  wire tmp_ram_regce;
  wire wr_rst_reg_i_1_n_0;
  wire wr_rst_reg_reg_0;
  (* async_reg = "true" *) wire wrrst_q1;
  (* async_reg = "true" *) wire wrrst_q2;
  (* async_reg = "true" *) wire wrrst_q3;

  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_3 
       (.I0(wr_rst_reg_reg_0),
        .I1(srst),
        .I2(ram_rd_en_d1),
        .O(tmp_ram_regce));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_4 
       (.I0(srst),
        .I1(wr_rst_reg_reg_0),
        .O(SS));
  LUT1 #(
    .INIT(2'h2)) 
    i_0
       (.I0(1'b0),
        .O(d_asreg));
  LUT1 #(
    .INIT(2'h2)) 
    i_1
       (.I0(1'b0),
        .O(rd_rst_reg));
  LUT1 #(
    .INIT(2'h2)) 
    i_2
       (.I0(1'b0),
        .O(wrrst_q1));
  LUT1 #(
    .INIT(2'h2)) 
    i_3
       (.I0(1'b0),
        .O(wrrst_q2));
  LUT1 #(
    .INIT(2'h2)) 
    i_4
       (.I0(1'b0),
        .O(wrrst_q3));
  LUT1 #(
    .INIT(2'h2)) 
    i_5
       (.I0(1'b0),
        .O(rdrst_q1));
  LUT1 #(
    .INIT(2'h2)) 
    i_6
       (.I0(1'b0),
        .O(rdrst_q2));
  LUT1 #(
    .INIT(2'h2)) 
    i_7
       (.I0(1'b0),
        .O(rdrst_q3));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b1)) 
    rst_d1_reg
       (.C(clk),
        .CE(1'b1),
        .D(srst),
        .Q(rst_d1),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b1)) 
    rst_d2_reg
       (.C(clk),
        .CE(1'b1),
        .D(rst_d1),
        .Q(rst_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h4)) 
    wr_rst_reg_i_1
       (.I0(wr_rst_reg_reg_0),
        .I1(srst),
        .O(wr_rst_reg_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    wr_rst_reg_reg
       (.C(clk),
        .CE(1'b1),
        .D(wr_rst_reg_i_1_n_0),
        .Q(wr_rst_reg_reg_0),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "compare" *) 
module fifo_generator_1_compare
   (comp0,
    v1_reg);
  output comp0;
  input [4:0]v1_reg;

  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire comp0;
  wire [4:0]v1_reg;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED ;
  wire [7:0]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED ;

  (* OPT_MODIFIED = "MLO " *) 
  (* XILINX_LEGACY_PRIM = "(CARRY4)" *) 
  (* box_type = "PRIMITIVE" *) 
  CARRY8 \gmux.gm[0].gm1.m1_CARRY4_CARRY8 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED [7:5],comp0,carrynet_3,carrynet_2,carrynet_1,carrynet_0}),
        .DI({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED [7:5],1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED [7:0]),
        .S({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED [7:5],v1_reg}));
endmodule

(* ORIG_REF_NAME = "compare" *) 
module fifo_generator_1_compare_0
   (wr_en_0,
    p_2_out,
    v1_reg_1,
    wr_en,
    comp0,
    E,
    out,
    SS,
    almost_full,
    \gaf.gaf0.ram_afull_i_reg ,
    rd_en,
    \gaf.gaf0.ram_afull_i_reg_0 ,
    p_0_in);
  output wr_en_0;
  output p_2_out;
  input [4:0]v1_reg_1;
  input wr_en;
  input comp0;
  input [0:0]E;
  input out;
  input [0:0]SS;
  input almost_full;
  input \gaf.gaf0.ram_afull_i_reg ;
  input rd_en;
  input [0:0]\gaf.gaf0.ram_afull_i_reg_0 ;
  input p_0_in;

  wire [0:0]E;
  wire [0:0]SS;
  wire almost_full;
  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire comp0;
  wire comp1;
  wire \gaf.gaf0.ram_afull_i_reg ;
  wire [0:0]\gaf.gaf0.ram_afull_i_reg_0 ;
  wire out;
  wire p_0_in;
  wire p_2_out;
  wire rd_en;
  wire [4:0]v1_reg_1;
  wire wr_en;
  wire wr_en_0;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED ;
  wire [7:0]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED ;

  LUT6 #(
    .INIT(64'hFAFFA2AAAAAAA2AA)) 
    \gaf.gaf0.ram_afull_i_i_1 
       (.I0(almost_full),
        .I1(comp1),
        .I2(\gaf.gaf0.ram_afull_i_reg ),
        .I3(rd_en),
        .I4(\gaf.gaf0.ram_afull_i_reg_0 ),
        .I5(p_0_in),
        .O(p_2_out));
  (* OPT_MODIFIED = "MLO " *) 
  (* XILINX_LEGACY_PRIM = "(CARRY4)" *) 
  (* box_type = "PRIMITIVE" *) 
  CARRY8 \gmux.gm[0].gm1.m1_CARRY4_CARRY8 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED [7:5],comp1,carrynet_3,carrynet_2,carrynet_1,carrynet_0}),
        .DI({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED [7:5],1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED [7:0]),
        .S({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED [7:5],v1_reg_1}));
  LUT6 #(
    .INIT(64'h000000000FFF0088)) 
    ram_full_fb_i_i_1
       (.I0(wr_en),
        .I1(comp1),
        .I2(comp0),
        .I3(E),
        .I4(out),
        .I5(SS),
        .O(wr_en_0));
endmodule

(* ORIG_REF_NAME = "compare" *) 
module fifo_generator_1_compare_1
   (p_0_in,
    v1_reg_0);
  output p_0_in;
  input [4:0]v1_reg_0;

  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire p_0_in;
  wire [4:0]v1_reg_0;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED ;
  wire [7:0]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED ;

  (* OPT_MODIFIED = "MLO " *) 
  (* XILINX_LEGACY_PRIM = "(CARRY4)" *) 
  (* box_type = "PRIMITIVE" *) 
  CARRY8 \gmux.gm[0].gm1.m1_CARRY4_CARRY8 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED [7:5],p_0_in,carrynet_3,carrynet_2,carrynet_1,carrynet_0}),
        .DI({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED [7:5],1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED [7:0]),
        .S({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED [7:5],v1_reg_0}));
endmodule

(* ORIG_REF_NAME = "compare" *) 
module fifo_generator_1_compare_2
   (ram_empty_fb_i_reg,
    \gmux.gm[1].gms.ms_0 ,
    \gmux.gm[2].gms.ms_0 ,
    \gmux.gm[3].gms.ms_0 ,
    \gmux.gm[4].gms.ms_0 ,
    ram_empty_i_reg,
    srst_full_ff_i,
    p_17_out,
    out,
    rd_en,
    comp1);
  output ram_empty_fb_i_reg;
  input \gmux.gm[1].gms.ms_0 ;
  input \gmux.gm[2].gms.ms_0 ;
  input \gmux.gm[3].gms.ms_0 ;
  input \gmux.gm[4].gms.ms_0 ;
  input ram_empty_i_reg;
  input srst_full_ff_i;
  input p_17_out;
  input out;
  input rd_en;
  input comp1;

  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire comp0;
  wire comp1;
  wire \gmux.gm[1].gms.ms_0 ;
  wire \gmux.gm[2].gms.ms_0 ;
  wire \gmux.gm[3].gms.ms_0 ;
  wire \gmux.gm[4].gms.ms_0 ;
  wire out;
  wire p_17_out;
  wire ram_empty_fb_i_reg;
  wire ram_empty_i_reg;
  wire rd_en;
  wire srst_full_ff_i;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED ;
  wire [7:0]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED ;

  (* OPT_MODIFIED = "MLO " *) 
  (* XILINX_LEGACY_PRIM = "(CARRY4)" *) 
  (* box_type = "PRIMITIVE" *) 
  CARRY8 \gmux.gm[0].gm1.m1_CARRY4_CARRY8 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED [7:5],comp0,carrynet_3,carrynet_2,carrynet_1,carrynet_0}),
        .DI({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED [7:5],1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED [7:0]),
        .S({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED [7:5],ram_empty_i_reg,\gmux.gm[4].gms.ms_0 ,\gmux.gm[3].gms.ms_0 ,\gmux.gm[2].gms.ms_0 ,\gmux.gm[1].gms.ms_0 }));
  LUT6 #(
    .INIT(64'hDFCFDFCCDFCCDFCC)) 
    ram_empty_fb_i_i_1
       (.I0(comp0),
        .I1(srst_full_ff_i),
        .I2(p_17_out),
        .I3(out),
        .I4(rd_en),
        .I5(comp1),
        .O(ram_empty_fb_i_reg));
endmodule

(* ORIG_REF_NAME = "compare" *) 
module fifo_generator_1_compare_3
   (comp1,
    p_1_out,
    v1_reg,
    almost_empty,
    p_17_out,
    out,
    rd_en,
    comp2);
  output comp1;
  output p_1_out;
  input [4:0]v1_reg;
  input almost_empty;
  input p_17_out;
  input out;
  input rd_en;
  input comp2;

  wire almost_empty;
  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire comp1;
  wire comp2;
  wire out;
  wire p_17_out;
  wire p_1_out;
  wire rd_en;
  wire [4:0]v1_reg;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED ;
  wire [7:0]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED ;

  LUT6 #(
    .INIT(64'h2AAF2A2A2AAA2A2A)) 
    \gae.ram_aempty_i_i_1 
       (.I0(almost_empty),
        .I1(comp1),
        .I2(p_17_out),
        .I3(out),
        .I4(rd_en),
        .I5(comp2),
        .O(p_1_out));
  (* OPT_MODIFIED = "MLO " *) 
  (* XILINX_LEGACY_PRIM = "(CARRY4)" *) 
  (* box_type = "PRIMITIVE" *) 
  CARRY8 \gmux.gm[0].gm1.m1_CARRY4_CARRY8 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED [7:5],comp1,carrynet_3,carrynet_2,carrynet_1,carrynet_0}),
        .DI({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED [7:5],1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED [7:0]),
        .S({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED [7:5],v1_reg}));
endmodule

(* ORIG_REF_NAME = "compare" *) 
module fifo_generator_1_compare_4
   (comp2,
    v1_reg_0);
  output comp2;
  input [4:0]v1_reg_0;

  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire comp2;
  wire [4:0]v1_reg_0;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED ;
  wire [7:0]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED ;
  wire [7:5]\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED ;

  (* OPT_MODIFIED = "MLO " *) 
  (* XILINX_LEGACY_PRIM = "(CARRY4)" *) 
  (* box_type = "PRIMITIVE" *) 
  CARRY8 \gmux.gm[0].gm1.m1_CARRY4_CARRY8 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_CO_UNCONNECTED [7:5],comp2,carrynet_3,carrynet_2,carrynet_1,carrynet_0}),
        .DI({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_DI_UNCONNECTED [7:5],1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_O_UNCONNECTED [7:0]),
        .S({\NLW_gmux.gm[0].gm1.m1_CARRY4_CARRY8_S_UNCONNECTED [7:5],v1_reg_0}));
endmodule

(* ORIG_REF_NAME = "dc_ss" *) 
module fifo_generator_1_dc_ss
   (Q,
    out,
    rd_en,
    srst_full_ff_i,
    E,
    clk);
  output [9:0]Q;
  input out;
  input rd_en;
  input srst_full_ff_i;
  input [0:0]E;
  input clk;

  wire [0:0]E;
  wire [9:0]Q;
  wire clk;
  wire out;
  wire rd_en;
  wire srst_full_ff_i;

  fifo_generator_1_updn_cntr \gsym_dc.dc 
       (.E(E),
        .Q(Q),
        .clk(clk),
        .out(out),
        .rd_en(rd_en),
        .srst_full_ff_i(srst_full_ff_i));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module fifo_generator_1_fifo_generator_ramfifo
   (data_count,
    dout,
    empty,
    full,
    almost_full,
    almost_empty,
    valid,
    wr_rst_reg_reg,
    prog_empty,
    rd_en,
    srst,
    clk,
    din,
    wr_en);
  output [9:0]data_count;
  output [31:0]dout;
  output empty;
  output full;
  output almost_full;
  output almost_empty;
  output valid;
  output wr_rst_reg_reg;
  output prog_empty;
  input rd_en;
  input srst;
  input clk;
  input [31:0]din;
  input wr_en;

  wire almost_empty;
  wire almost_full;
  wire clk;
  wire [9:0]data_count;
  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire \gntv_or_sync_fifo.gl0.wr_n_0 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_15 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_16 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_17 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_18 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_19 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_20 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_21 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_22 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_24 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_3 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_4 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_40 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_41 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_42 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_43 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_44 ;
  wire [4:0]\grss.rsts/gae.c3/v1_reg ;
  wire [4:0]\gwss.wsts/gaf.c2/v1_reg ;
  wire [9:0]p_0_out;
  wire [9:0]p_11_out;
  wire p_17_out;
  wire p_2_out;
  wire p_7_out;
  wire prog_empty;
  wire ram_rd_en_d1;
  wire rd_en;
  wire [9:0]rd_pntr_plus2;
  wire srst;
  wire srst_full_ff_i;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;
  wire valid;
  wire wr_en;
  wire [9:0]wr_pntr_plus2;
  wire wr_rst_reg_reg;

  fifo_generator_1_rd_logic \gntv_or_sync_fifo.gl0.rd 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (wr_rst_reg_reg),
        .E(p_7_out),
        .Q(p_11_out),
        .S({\gntv_or_sync_fifo.gl0.wr_n_15 ,\gntv_or_sync_fifo.gl0.wr_n_16 ,\gntv_or_sync_fifo.gl0.wr_n_17 ,\gntv_or_sync_fifo.gl0.wr_n_18 ,\gntv_or_sync_fifo.gl0.wr_n_19 ,\gntv_or_sync_fifo.gl0.wr_n_20 ,\gntv_or_sync_fifo.gl0.wr_n_21 ,\gntv_or_sync_fifo.gl0.wr_n_22 }),
        .almost_empty(almost_empty),
        .clk(clk),
        .\count_reg[0] (\gntv_or_sync_fifo.gl0.wr_n_0 ),
        .\count_reg[9] (data_count),
        .empty(empty),
        .\gc1.count_d2_reg[9] (p_0_out),
        .\gc1.count_reg[9] (rd_pntr_plus2),
        .\gmux.gm[1].gms.ms (\gntv_or_sync_fifo.gl0.wr_n_40 ),
        .\gmux.gm[2].gms.ms (\gntv_or_sync_fifo.gl0.wr_n_41 ),
        .\gmux.gm[3].gms.ms (\gntv_or_sync_fifo.gl0.wr_n_42 ),
        .\gmux.gm[4].gms.ms (\gntv_or_sync_fifo.gl0.wr_n_43 ),
        .\gmux.gm[4].gms.ms_0 (wr_pntr_plus2),
        .\greg.gpcry_sym.diff_pntr_pad_reg[10] ({\gntv_or_sync_fifo.gl0.wr_n_3 ,\gntv_or_sync_fifo.gl0.wr_n_4 }),
        .\greg.gpcry_sym.diff_pntr_pad_reg[8] (\gntv_or_sync_fifo.gl0.wr_n_24 ),
        .out(p_2_out),
        .p_17_out(p_17_out),
        .prog_empty(prog_empty),
        .ram_empty_i_reg(\gntv_or_sync_fifo.gl0.wr_n_44 ),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_en(rd_en),
        .srst(srst),
        .srst_full_ff_i(srst_full_ff_i),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .v1_reg(\gwss.wsts/gaf.c2/v1_reg ),
        .v1_reg_0(\grss.rsts/gae.c3/v1_reg ),
        .valid(valid),
        .wr_en(wr_en));
  fifo_generator_1_wr_logic \gntv_or_sync_fifo.gl0.wr 
       (.E(p_7_out),
        .Q(p_11_out),
        .S({\gntv_or_sync_fifo.gl0.wr_n_15 ,\gntv_or_sync_fifo.gl0.wr_n_16 ,\gntv_or_sync_fifo.gl0.wr_n_17 ,\gntv_or_sync_fifo.gl0.wr_n_18 ,\gntv_or_sync_fifo.gl0.wr_n_19 ,\gntv_or_sync_fifo.gl0.wr_n_20 ,\gntv_or_sync_fifo.gl0.wr_n_21 ,\gntv_or_sync_fifo.gl0.wr_n_22 }),
        .SS(srst_full_ff_i),
        .almost_full(almost_full),
        .clk(clk),
        .full(full),
        .\gaf.gaf0.ram_afull_i_reg (p_2_out),
        .\gcc0.gc1.gsym.count_d2_reg[0] (\gntv_or_sync_fifo.gl0.wr_n_40 ),
        .\gcc0.gc1.gsym.count_d2_reg[2] (\gntv_or_sync_fifo.gl0.wr_n_41 ),
        .\gcc0.gc1.gsym.count_d2_reg[4] (\gntv_or_sync_fifo.gl0.wr_n_42 ),
        .\gcc0.gc1.gsym.count_d2_reg[6] (\gntv_or_sync_fifo.gl0.wr_n_43 ),
        .\gcc0.gc1.gsym.count_d2_reg[9] ({\gntv_or_sync_fifo.gl0.wr_n_3 ,\gntv_or_sync_fifo.gl0.wr_n_4 }),
        .\gcc0.gc1.gsym.count_d2_reg[9]_0 (\gntv_or_sync_fifo.gl0.wr_n_44 ),
        .\gcc0.gc1.gsym.count_reg[9] (wr_pntr_plus2),
        .\gmux.gm[4].gms.ms (rd_pntr_plus2),
        .\greg.gpcry_sym.diff_pntr_pad_reg[10] (p_0_out),
        .out(\gntv_or_sync_fifo.gl0.wr_n_0 ),
        .ram_full_fb_i_reg(\gntv_or_sync_fifo.gl0.wr_n_24 ),
        .rd_en(rd_en),
        .v1_reg(\grss.rsts/gae.c3/v1_reg ),
        .v1_reg_0(\gwss.wsts/gaf.c2/v1_reg ),
        .wr_en(wr_en),
        .wr_en_0(p_17_out));
  fifo_generator_1_memory \gntv_or_sync_fifo.mem 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (p_17_out),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (p_0_out),
        .E(p_7_out),
        .Q(p_11_out),
        .SS(srst_full_ff_i),
        .clk(clk),
        .din(din),
        .dout(dout),
        .ram_rd_en_d1(ram_rd_en_d1),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
  fifo_generator_1_reset_blk_ramfifo rstblk
       (.SS(srst_full_ff_i),
        .clk(clk),
        .ram_rd_en_d1(ram_rd_en_d1),
        .srst(srst),
        .tmp_ram_regce(tmp_ram_regce),
        .wr_rst_reg_reg(wr_rst_reg_reg));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module fifo_generator_1_fifo_generator_top
   (DATA_COUNT,
    dout,
    empty,
    full,
    almost_full,
    almost_empty,
    valid,
    wr_rst_reg_reg,
    prog_empty,
    rd_en,
    srst,
    clk,
    din,
    wr_en);
  output [9:0]DATA_COUNT;
  output [31:0]dout;
  output empty;
  output full;
  output almost_full;
  output almost_empty;
  output valid;
  output wr_rst_reg_reg;
  output prog_empty;
  input rd_en;
  input srst;
  input clk;
  input [31:0]din;
  input wr_en;

  wire [9:0]DATA_COUNT;
  wire almost_empty;
  wire almost_full;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire prog_empty;
  wire rd_en;
  wire srst;
  wire valid;
  wire wr_en;
  wire wr_rst_reg_reg;

  fifo_generator_1_fifo_generator_ramfifo \grf.rf 
       (.almost_empty(almost_empty),
        .almost_full(almost_full),
        .clk(clk),
        .data_count(DATA_COUNT),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_empty(prog_empty),
        .rd_en(rd_en),
        .srst(srst),
        .valid(valid),
        .wr_en(wr_en),
        .wr_rst_reg_reg(wr_rst_reg_reg));
endmodule

(* C_ADD_NGC_CONSTRAINT = "0" *) (* C_APPLICATION_TYPE_AXIS = "0" *) (* C_APPLICATION_TYPE_RACH = "0" *) 
(* C_APPLICATION_TYPE_RDCH = "0" *) (* C_APPLICATION_TYPE_WACH = "0" *) (* C_APPLICATION_TYPE_WDCH = "0" *) 
(* C_APPLICATION_TYPE_WRCH = "0" *) (* C_AXIS_TDATA_WIDTH = "8" *) (* C_AXIS_TDEST_WIDTH = "1" *) 
(* C_AXIS_TID_WIDTH = "1" *) (* C_AXIS_TKEEP_WIDTH = "1" *) (* C_AXIS_TSTRB_WIDTH = "1" *) 
(* C_AXIS_TUSER_WIDTH = "4" *) (* C_AXIS_TYPE = "0" *) (* C_AXI_ADDR_WIDTH = "32" *) 
(* C_AXI_ARUSER_WIDTH = "1" *) (* C_AXI_AWUSER_WIDTH = "1" *) (* C_AXI_BUSER_WIDTH = "1" *) 
(* C_AXI_DATA_WIDTH = "64" *) (* C_AXI_ID_WIDTH = "1" *) (* C_AXI_LEN_WIDTH = "8" *) 
(* C_AXI_LOCK_WIDTH = "1" *) (* C_AXI_RUSER_WIDTH = "1" *) (* C_AXI_TYPE = "1" *) 
(* C_AXI_WUSER_WIDTH = "1" *) (* C_COMMON_CLOCK = "1" *) (* C_COUNT_TYPE = "0" *) 
(* C_DATA_COUNT_WIDTH = "10" *) (* C_DEFAULT_VALUE = "BlankString" *) (* C_DIN_WIDTH = "32" *) 
(* C_DIN_WIDTH_AXIS = "1" *) (* C_DIN_WIDTH_RACH = "32" *) (* C_DIN_WIDTH_RDCH = "64" *) 
(* C_DIN_WIDTH_WACH = "1" *) (* C_DIN_WIDTH_WDCH = "64" *) (* C_DIN_WIDTH_WRCH = "2" *) 
(* C_DOUT_RST_VAL = "0" *) (* C_DOUT_WIDTH = "32" *) (* C_ENABLE_RLOCS = "0" *) 
(* C_ENABLE_RST_SYNC = "1" *) (* C_EN_SAFETY_CKT = "0" *) (* C_ERROR_INJECTION_TYPE = "0" *) 
(* C_ERROR_INJECTION_TYPE_AXIS = "0" *) (* C_ERROR_INJECTION_TYPE_RACH = "0" *) (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
(* C_ERROR_INJECTION_TYPE_WACH = "0" *) (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
(* C_FAMILY = "kintexuplus" *) (* C_FULL_FLAGS_RST_VAL = "0" *) (* C_HAS_ALMOST_EMPTY = "1" *) 
(* C_HAS_ALMOST_FULL = "1" *) (* C_HAS_AXIS_TDATA = "1" *) (* C_HAS_AXIS_TDEST = "0" *) 
(* C_HAS_AXIS_TID = "0" *) (* C_HAS_AXIS_TKEEP = "0" *) (* C_HAS_AXIS_TLAST = "0" *) 
(* C_HAS_AXIS_TREADY = "1" *) (* C_HAS_AXIS_TSTRB = "0" *) (* C_HAS_AXIS_TUSER = "1" *) 
(* C_HAS_AXI_ARUSER = "0" *) (* C_HAS_AXI_AWUSER = "0" *) (* C_HAS_AXI_BUSER = "0" *) 
(* C_HAS_AXI_ID = "0" *) (* C_HAS_AXI_RD_CHANNEL = "1" *) (* C_HAS_AXI_RUSER = "0" *) 
(* C_HAS_AXI_WR_CHANNEL = "1" *) (* C_HAS_AXI_WUSER = "0" *) (* C_HAS_BACKUP = "0" *) 
(* C_HAS_DATA_COUNT = "1" *) (* C_HAS_DATA_COUNTS_AXIS = "0" *) (* C_HAS_DATA_COUNTS_RACH = "0" *) 
(* C_HAS_DATA_COUNTS_RDCH = "0" *) (* C_HAS_DATA_COUNTS_WACH = "0" *) (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
(* C_HAS_DATA_COUNTS_WRCH = "0" *) (* C_HAS_INT_CLK = "0" *) (* C_HAS_MASTER_CE = "0" *) 
(* C_HAS_MEMINIT_FILE = "0" *) (* C_HAS_OVERFLOW = "0" *) (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
(* C_HAS_PROG_FLAGS_RACH = "0" *) (* C_HAS_PROG_FLAGS_RDCH = "0" *) (* C_HAS_PROG_FLAGS_WACH = "0" *) 
(* C_HAS_PROG_FLAGS_WDCH = "0" *) (* C_HAS_PROG_FLAGS_WRCH = "0" *) (* C_HAS_RD_DATA_COUNT = "0" *) 
(* C_HAS_RD_RST = "0" *) (* C_HAS_RST = "0" *) (* C_HAS_SLAVE_CE = "0" *) 
(* C_HAS_SRST = "1" *) (* C_HAS_UNDERFLOW = "0" *) (* C_HAS_VALID = "1" *) 
(* C_HAS_WR_ACK = "0" *) (* C_HAS_WR_DATA_COUNT = "0" *) (* C_HAS_WR_RST = "0" *) 
(* C_IMPLEMENTATION_TYPE = "0" *) (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
(* C_IMPLEMENTATION_TYPE_RDCH = "1" *) (* C_IMPLEMENTATION_TYPE_WACH = "1" *) (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
(* C_IMPLEMENTATION_TYPE_WRCH = "1" *) (* C_INIT_WR_PNTR_VAL = "0" *) (* C_INTERFACE_TYPE = "0" *) 
(* C_MEMORY_TYPE = "1" *) (* C_MIF_FILE_NAME = "BlankString" *) (* C_MSGON_VAL = "1" *) 
(* C_OPTIMIZATION_MODE = "0" *) (* C_OVERFLOW_LOW = "0" *) (* C_POWER_SAVING_MODE = "0" *) 
(* C_PRELOAD_LATENCY = "2" *) (* C_PRELOAD_REGS = "1" *) (* C_PRIM_FIFO_TYPE = "1kx36" *) 
(* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
(* C_PRIM_FIFO_TYPE_WACH = "512x36" *) (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) (* C_PROG_EMPTY_TYPE = "1" *) 
(* C_PROG_EMPTY_TYPE_AXIS = "0" *) (* C_PROG_EMPTY_TYPE_RACH = "0" *) (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
(* C_PROG_EMPTY_TYPE_WACH = "0" *) (* C_PROG_EMPTY_TYPE_WDCH = "0" *) (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL = "1022" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) (* C_PROG_FULL_THRESH_NEGATE_VAL = "1021" *) (* C_PROG_FULL_TYPE = "0" *) 
(* C_PROG_FULL_TYPE_AXIS = "0" *) (* C_PROG_FULL_TYPE_RACH = "0" *) (* C_PROG_FULL_TYPE_RDCH = "0" *) 
(* C_PROG_FULL_TYPE_WACH = "0" *) (* C_PROG_FULL_TYPE_WDCH = "0" *) (* C_PROG_FULL_TYPE_WRCH = "0" *) 
(* C_RACH_TYPE = "0" *) (* C_RDCH_TYPE = "0" *) (* C_RD_DATA_COUNT_WIDTH = "10" *) 
(* C_RD_DEPTH = "1024" *) (* C_RD_FREQ = "1" *) (* C_RD_PNTR_WIDTH = "10" *) 
(* C_REG_SLICE_MODE_AXIS = "0" *) (* C_REG_SLICE_MODE_RACH = "0" *) (* C_REG_SLICE_MODE_RDCH = "0" *) 
(* C_REG_SLICE_MODE_WACH = "0" *) (* C_REG_SLICE_MODE_WDCH = "0" *) (* C_REG_SLICE_MODE_WRCH = "0" *) 
(* C_SELECT_XPM = "0" *) (* C_SYNCHRONIZER_STAGE = "2" *) (* C_UNDERFLOW_LOW = "0" *) 
(* C_USE_COMMON_OVERFLOW = "0" *) (* C_USE_COMMON_UNDERFLOW = "0" *) (* C_USE_DEFAULT_SETTINGS = "0" *) 
(* C_USE_DOUT_RST = "1" *) (* C_USE_ECC = "0" *) (* C_USE_ECC_AXIS = "0" *) 
(* C_USE_ECC_RACH = "0" *) (* C_USE_ECC_RDCH = "0" *) (* C_USE_ECC_WACH = "0" *) 
(* C_USE_ECC_WDCH = "0" *) (* C_USE_ECC_WRCH = "0" *) (* C_USE_EMBEDDED_REG = "1" *) 
(* C_USE_FIFO16_FLAGS = "0" *) (* C_USE_FWFT_DATA_COUNT = "0" *) (* C_USE_PIPELINE_REG = "0" *) 
(* C_VALID_LOW = "0" *) (* C_WACH_TYPE = "0" *) (* C_WDCH_TYPE = "0" *) 
(* C_WRCH_TYPE = "0" *) (* C_WR_ACK_LOW = "0" *) (* C_WR_DATA_COUNT_WIDTH = "10" *) 
(* C_WR_DEPTH = "1024" *) (* C_WR_DEPTH_AXIS = "1024" *) (* C_WR_DEPTH_RACH = "16" *) 
(* C_WR_DEPTH_RDCH = "1024" *) (* C_WR_DEPTH_WACH = "16" *) (* C_WR_DEPTH_WDCH = "1024" *) 
(* C_WR_DEPTH_WRCH = "16" *) (* C_WR_FREQ = "1" *) (* C_WR_PNTR_WIDTH = "10" *) 
(* C_WR_PNTR_WIDTH_AXIS = "10" *) (* C_WR_PNTR_WIDTH_RACH = "4" *) (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
(* C_WR_PNTR_WIDTH_WACH = "4" *) (* C_WR_PNTR_WIDTH_WDCH = "10" *) (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
(* C_WR_RESPONSE_LATENCY = "1" *) (* ORIG_REF_NAME = "fifo_generator_v13_2_3" *) 
module fifo_generator_1_fifo_generator_v13_2_3
   (backup,
    backup_marker,
    clk,
    rst,
    srst,
    wr_clk,
    wr_rst,
    rd_clk,
    rd_rst,
    din,
    wr_en,
    rd_en,
    prog_empty_thresh,
    prog_empty_thresh_assert,
    prog_empty_thresh_negate,
    prog_full_thresh,
    prog_full_thresh_assert,
    prog_full_thresh_negate,
    int_clk,
    injectdbiterr,
    injectsbiterr,
    sleep,
    dout,
    full,
    almost_full,
    wr_ack,
    overflow,
    empty,
    almost_empty,
    valid,
    underflow,
    data_count,
    rd_data_count,
    wr_data_count,
    prog_full,
    prog_empty,
    sbiterr,
    dbiterr,
    wr_rst_busy,
    rd_rst_busy,
    m_aclk,
    s_aclk,
    s_aresetn,
    m_aclk_en,
    s_aclk_en,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awregion,
    s_axi_awuser,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wuser,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_buser,
    s_axi_bvalid,
    s_axi_bready,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awqos,
    m_axi_awregion,
    m_axi_awuser,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wid,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wuser,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_buser,
    m_axi_bvalid,
    m_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arregion,
    s_axi_aruser,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_ruser,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arqos,
    m_axi_arregion,
    m_axi_aruser,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_ruser,
    m_axi_rvalid,
    m_axi_rready,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser,
    axi_aw_injectsbiterr,
    axi_aw_injectdbiterr,
    axi_aw_prog_full_thresh,
    axi_aw_prog_empty_thresh,
    axi_aw_data_count,
    axi_aw_wr_data_count,
    axi_aw_rd_data_count,
    axi_aw_sbiterr,
    axi_aw_dbiterr,
    axi_aw_overflow,
    axi_aw_underflow,
    axi_aw_prog_full,
    axi_aw_prog_empty,
    axi_w_injectsbiterr,
    axi_w_injectdbiterr,
    axi_w_prog_full_thresh,
    axi_w_prog_empty_thresh,
    axi_w_data_count,
    axi_w_wr_data_count,
    axi_w_rd_data_count,
    axi_w_sbiterr,
    axi_w_dbiterr,
    axi_w_overflow,
    axi_w_underflow,
    axi_w_prog_full,
    axi_w_prog_empty,
    axi_b_injectsbiterr,
    axi_b_injectdbiterr,
    axi_b_prog_full_thresh,
    axi_b_prog_empty_thresh,
    axi_b_data_count,
    axi_b_wr_data_count,
    axi_b_rd_data_count,
    axi_b_sbiterr,
    axi_b_dbiterr,
    axi_b_overflow,
    axi_b_underflow,
    axi_b_prog_full,
    axi_b_prog_empty,
    axi_ar_injectsbiterr,
    axi_ar_injectdbiterr,
    axi_ar_prog_full_thresh,
    axi_ar_prog_empty_thresh,
    axi_ar_data_count,
    axi_ar_wr_data_count,
    axi_ar_rd_data_count,
    axi_ar_sbiterr,
    axi_ar_dbiterr,
    axi_ar_overflow,
    axi_ar_underflow,
    axi_ar_prog_full,
    axi_ar_prog_empty,
    axi_r_injectsbiterr,
    axi_r_injectdbiterr,
    axi_r_prog_full_thresh,
    axi_r_prog_empty_thresh,
    axi_r_data_count,
    axi_r_wr_data_count,
    axi_r_rd_data_count,
    axi_r_sbiterr,
    axi_r_dbiterr,
    axi_r_overflow,
    axi_r_underflow,
    axi_r_prog_full,
    axi_r_prog_empty,
    axis_injectsbiterr,
    axis_injectdbiterr,
    axis_prog_full_thresh,
    axis_prog_empty_thresh,
    axis_data_count,
    axis_wr_data_count,
    axis_rd_data_count,
    axis_sbiterr,
    axis_dbiterr,
    axis_overflow,
    axis_underflow,
    axis_prog_full,
    axis_prog_empty);
  input backup;
  input backup_marker;
  input clk;
  input rst;
  input srst;
  input wr_clk;
  input wr_rst;
  input rd_clk;
  input rd_rst;
  input [31:0]din;
  input wr_en;
  input rd_en;
  input [9:0]prog_empty_thresh;
  input [9:0]prog_empty_thresh_assert;
  input [9:0]prog_empty_thresh_negate;
  input [9:0]prog_full_thresh;
  input [9:0]prog_full_thresh_assert;
  input [9:0]prog_full_thresh_negate;
  input int_clk;
  input injectdbiterr;
  input injectsbiterr;
  input sleep;
  output [31:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output overflow;
  output empty;
  output almost_empty;
  output valid;
  output underflow;
  output [9:0]data_count;
  output [9:0]rd_data_count;
  output [9:0]wr_data_count;
  output prog_full;
  output prog_empty;
  output sbiterr;
  output dbiterr;
  output wr_rst_busy;
  output rd_rst_busy;
  input m_aclk;
  input s_aclk;
  input s_aresetn;
  input m_aclk_en;
  input s_aclk_en;
  input [0:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input [3:0]s_axi_awregion;
  input [0:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input [0:0]s_axi_wid;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_wlast;
  input [0:0]s_axi_wuser;
  input s_axi_wvalid;
  output s_axi_wready;
  output [0:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_buser;
  output s_axi_bvalid;
  input s_axi_bready;
  output [0:0]m_axi_awid;
  output [31:0]m_axi_awaddr;
  output [7:0]m_axi_awlen;
  output [2:0]m_axi_awsize;
  output [1:0]m_axi_awburst;
  output [0:0]m_axi_awlock;
  output [3:0]m_axi_awcache;
  output [2:0]m_axi_awprot;
  output [3:0]m_axi_awqos;
  output [3:0]m_axi_awregion;
  output [0:0]m_axi_awuser;
  output m_axi_awvalid;
  input m_axi_awready;
  output [0:0]m_axi_wid;
  output [63:0]m_axi_wdata;
  output [7:0]m_axi_wstrb;
  output m_axi_wlast;
  output [0:0]m_axi_wuser;
  output m_axi_wvalid;
  input m_axi_wready;
  input [0:0]m_axi_bid;
  input [1:0]m_axi_bresp;
  input [0:0]m_axi_buser;
  input m_axi_bvalid;
  output m_axi_bready;
  input [0:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input [3:0]s_axi_arregion;
  input [0:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [0:0]s_axi_rid;
  output [63:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output [0:0]s_axi_ruser;
  output s_axi_rvalid;
  input s_axi_rready;
  output [0:0]m_axi_arid;
  output [31:0]m_axi_araddr;
  output [7:0]m_axi_arlen;
  output [2:0]m_axi_arsize;
  output [1:0]m_axi_arburst;
  output [0:0]m_axi_arlock;
  output [3:0]m_axi_arcache;
  output [2:0]m_axi_arprot;
  output [3:0]m_axi_arqos;
  output [3:0]m_axi_arregion;
  output [0:0]m_axi_aruser;
  output m_axi_arvalid;
  input m_axi_arready;
  input [0:0]m_axi_rid;
  input [63:0]m_axi_rdata;
  input [1:0]m_axi_rresp;
  input m_axi_rlast;
  input [0:0]m_axi_ruser;
  input m_axi_rvalid;
  output m_axi_rready;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tstrb;
  input [0:0]s_axis_tkeep;
  input s_axis_tlast;
  input [0:0]s_axis_tid;
  input [0:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tstrb;
  output [0:0]m_axis_tkeep;
  output m_axis_tlast;
  output [0:0]m_axis_tid;
  output [0:0]m_axis_tdest;
  output [3:0]m_axis_tuser;
  input axi_aw_injectsbiterr;
  input axi_aw_injectdbiterr;
  input [3:0]axi_aw_prog_full_thresh;
  input [3:0]axi_aw_prog_empty_thresh;
  output [4:0]axi_aw_data_count;
  output [4:0]axi_aw_wr_data_count;
  output [4:0]axi_aw_rd_data_count;
  output axi_aw_sbiterr;
  output axi_aw_dbiterr;
  output axi_aw_overflow;
  output axi_aw_underflow;
  output axi_aw_prog_full;
  output axi_aw_prog_empty;
  input axi_w_injectsbiterr;
  input axi_w_injectdbiterr;
  input [9:0]axi_w_prog_full_thresh;
  input [9:0]axi_w_prog_empty_thresh;
  output [10:0]axi_w_data_count;
  output [10:0]axi_w_wr_data_count;
  output [10:0]axi_w_rd_data_count;
  output axi_w_sbiterr;
  output axi_w_dbiterr;
  output axi_w_overflow;
  output axi_w_underflow;
  output axi_w_prog_full;
  output axi_w_prog_empty;
  input axi_b_injectsbiterr;
  input axi_b_injectdbiterr;
  input [3:0]axi_b_prog_full_thresh;
  input [3:0]axi_b_prog_empty_thresh;
  output [4:0]axi_b_data_count;
  output [4:0]axi_b_wr_data_count;
  output [4:0]axi_b_rd_data_count;
  output axi_b_sbiterr;
  output axi_b_dbiterr;
  output axi_b_overflow;
  output axi_b_underflow;
  output axi_b_prog_full;
  output axi_b_prog_empty;
  input axi_ar_injectsbiterr;
  input axi_ar_injectdbiterr;
  input [3:0]axi_ar_prog_full_thresh;
  input [3:0]axi_ar_prog_empty_thresh;
  output [4:0]axi_ar_data_count;
  output [4:0]axi_ar_wr_data_count;
  output [4:0]axi_ar_rd_data_count;
  output axi_ar_sbiterr;
  output axi_ar_dbiterr;
  output axi_ar_overflow;
  output axi_ar_underflow;
  output axi_ar_prog_full;
  output axi_ar_prog_empty;
  input axi_r_injectsbiterr;
  input axi_r_injectdbiterr;
  input [9:0]axi_r_prog_full_thresh;
  input [9:0]axi_r_prog_empty_thresh;
  output [10:0]axi_r_data_count;
  output [10:0]axi_r_wr_data_count;
  output [10:0]axi_r_rd_data_count;
  output axi_r_sbiterr;
  output axi_r_dbiterr;
  output axi_r_overflow;
  output axi_r_underflow;
  output axi_r_prog_full;
  output axi_r_prog_empty;
  input axis_injectsbiterr;
  input axis_injectdbiterr;
  input [9:0]axis_prog_full_thresh;
  input [9:0]axis_prog_empty_thresh;
  output [10:0]axis_data_count;
  output [10:0]axis_wr_data_count;
  output [10:0]axis_rd_data_count;
  output axis_sbiterr;
  output axis_dbiterr;
  output axis_overflow;
  output axis_underflow;
  output axis_prog_full;
  output axis_prog_empty;

  wire \<const0> ;
  wire \<const1> ;
  wire almost_empty;
  wire almost_full;
  wire clk;
  wire [9:0]data_count;
  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire prog_empty;
  wire rd_en;
  wire srst;
  wire valid;
  wire wr_en;
  wire wr_rst_busy;

  assign axi_ar_data_count[4] = \<const0> ;
  assign axi_ar_data_count[3] = \<const0> ;
  assign axi_ar_data_count[2] = \<const0> ;
  assign axi_ar_data_count[1] = \<const0> ;
  assign axi_ar_data_count[0] = \<const0> ;
  assign axi_ar_dbiterr = \<const0> ;
  assign axi_ar_overflow = \<const0> ;
  assign axi_ar_prog_empty = \<const1> ;
  assign axi_ar_prog_full = \<const0> ;
  assign axi_ar_rd_data_count[4] = \<const0> ;
  assign axi_ar_rd_data_count[3] = \<const0> ;
  assign axi_ar_rd_data_count[2] = \<const0> ;
  assign axi_ar_rd_data_count[1] = \<const0> ;
  assign axi_ar_rd_data_count[0] = \<const0> ;
  assign axi_ar_sbiterr = \<const0> ;
  assign axi_ar_underflow = \<const0> ;
  assign axi_ar_wr_data_count[4] = \<const0> ;
  assign axi_ar_wr_data_count[3] = \<const0> ;
  assign axi_ar_wr_data_count[2] = \<const0> ;
  assign axi_ar_wr_data_count[1] = \<const0> ;
  assign axi_ar_wr_data_count[0] = \<const0> ;
  assign axi_aw_data_count[4] = \<const0> ;
  assign axi_aw_data_count[3] = \<const0> ;
  assign axi_aw_data_count[2] = \<const0> ;
  assign axi_aw_data_count[1] = \<const0> ;
  assign axi_aw_data_count[0] = \<const0> ;
  assign axi_aw_dbiterr = \<const0> ;
  assign axi_aw_overflow = \<const0> ;
  assign axi_aw_prog_empty = \<const1> ;
  assign axi_aw_prog_full = \<const0> ;
  assign axi_aw_rd_data_count[4] = \<const0> ;
  assign axi_aw_rd_data_count[3] = \<const0> ;
  assign axi_aw_rd_data_count[2] = \<const0> ;
  assign axi_aw_rd_data_count[1] = \<const0> ;
  assign axi_aw_rd_data_count[0] = \<const0> ;
  assign axi_aw_sbiterr = \<const0> ;
  assign axi_aw_underflow = \<const0> ;
  assign axi_aw_wr_data_count[4] = \<const0> ;
  assign axi_aw_wr_data_count[3] = \<const0> ;
  assign axi_aw_wr_data_count[2] = \<const0> ;
  assign axi_aw_wr_data_count[1] = \<const0> ;
  assign axi_aw_wr_data_count[0] = \<const0> ;
  assign axi_b_data_count[4] = \<const0> ;
  assign axi_b_data_count[3] = \<const0> ;
  assign axi_b_data_count[2] = \<const0> ;
  assign axi_b_data_count[1] = \<const0> ;
  assign axi_b_data_count[0] = \<const0> ;
  assign axi_b_dbiterr = \<const0> ;
  assign axi_b_overflow = \<const0> ;
  assign axi_b_prog_empty = \<const1> ;
  assign axi_b_prog_full = \<const0> ;
  assign axi_b_rd_data_count[4] = \<const0> ;
  assign axi_b_rd_data_count[3] = \<const0> ;
  assign axi_b_rd_data_count[2] = \<const0> ;
  assign axi_b_rd_data_count[1] = \<const0> ;
  assign axi_b_rd_data_count[0] = \<const0> ;
  assign axi_b_sbiterr = \<const0> ;
  assign axi_b_underflow = \<const0> ;
  assign axi_b_wr_data_count[4] = \<const0> ;
  assign axi_b_wr_data_count[3] = \<const0> ;
  assign axi_b_wr_data_count[2] = \<const0> ;
  assign axi_b_wr_data_count[1] = \<const0> ;
  assign axi_b_wr_data_count[0] = \<const0> ;
  assign axi_r_data_count[10] = \<const0> ;
  assign axi_r_data_count[9] = \<const0> ;
  assign axi_r_data_count[8] = \<const0> ;
  assign axi_r_data_count[7] = \<const0> ;
  assign axi_r_data_count[6] = \<const0> ;
  assign axi_r_data_count[5] = \<const0> ;
  assign axi_r_data_count[4] = \<const0> ;
  assign axi_r_data_count[3] = \<const0> ;
  assign axi_r_data_count[2] = \<const0> ;
  assign axi_r_data_count[1] = \<const0> ;
  assign axi_r_data_count[0] = \<const0> ;
  assign axi_r_dbiterr = \<const0> ;
  assign axi_r_overflow = \<const0> ;
  assign axi_r_prog_empty = \<const1> ;
  assign axi_r_prog_full = \<const0> ;
  assign axi_r_rd_data_count[10] = \<const0> ;
  assign axi_r_rd_data_count[9] = \<const0> ;
  assign axi_r_rd_data_count[8] = \<const0> ;
  assign axi_r_rd_data_count[7] = \<const0> ;
  assign axi_r_rd_data_count[6] = \<const0> ;
  assign axi_r_rd_data_count[5] = \<const0> ;
  assign axi_r_rd_data_count[4] = \<const0> ;
  assign axi_r_rd_data_count[3] = \<const0> ;
  assign axi_r_rd_data_count[2] = \<const0> ;
  assign axi_r_rd_data_count[1] = \<const0> ;
  assign axi_r_rd_data_count[0] = \<const0> ;
  assign axi_r_sbiterr = \<const0> ;
  assign axi_r_underflow = \<const0> ;
  assign axi_r_wr_data_count[10] = \<const0> ;
  assign axi_r_wr_data_count[9] = \<const0> ;
  assign axi_r_wr_data_count[8] = \<const0> ;
  assign axi_r_wr_data_count[7] = \<const0> ;
  assign axi_r_wr_data_count[6] = \<const0> ;
  assign axi_r_wr_data_count[5] = \<const0> ;
  assign axi_r_wr_data_count[4] = \<const0> ;
  assign axi_r_wr_data_count[3] = \<const0> ;
  assign axi_r_wr_data_count[2] = \<const0> ;
  assign axi_r_wr_data_count[1] = \<const0> ;
  assign axi_r_wr_data_count[0] = \<const0> ;
  assign axi_w_data_count[10] = \<const0> ;
  assign axi_w_data_count[9] = \<const0> ;
  assign axi_w_data_count[8] = \<const0> ;
  assign axi_w_data_count[7] = \<const0> ;
  assign axi_w_data_count[6] = \<const0> ;
  assign axi_w_data_count[5] = \<const0> ;
  assign axi_w_data_count[4] = \<const0> ;
  assign axi_w_data_count[3] = \<const0> ;
  assign axi_w_data_count[2] = \<const0> ;
  assign axi_w_data_count[1] = \<const0> ;
  assign axi_w_data_count[0] = \<const0> ;
  assign axi_w_dbiterr = \<const0> ;
  assign axi_w_overflow = \<const0> ;
  assign axi_w_prog_empty = \<const1> ;
  assign axi_w_prog_full = \<const0> ;
  assign axi_w_rd_data_count[10] = \<const0> ;
  assign axi_w_rd_data_count[9] = \<const0> ;
  assign axi_w_rd_data_count[8] = \<const0> ;
  assign axi_w_rd_data_count[7] = \<const0> ;
  assign axi_w_rd_data_count[6] = \<const0> ;
  assign axi_w_rd_data_count[5] = \<const0> ;
  assign axi_w_rd_data_count[4] = \<const0> ;
  assign axi_w_rd_data_count[3] = \<const0> ;
  assign axi_w_rd_data_count[2] = \<const0> ;
  assign axi_w_rd_data_count[1] = \<const0> ;
  assign axi_w_rd_data_count[0] = \<const0> ;
  assign axi_w_sbiterr = \<const0> ;
  assign axi_w_underflow = \<const0> ;
  assign axi_w_wr_data_count[10] = \<const0> ;
  assign axi_w_wr_data_count[9] = \<const0> ;
  assign axi_w_wr_data_count[8] = \<const0> ;
  assign axi_w_wr_data_count[7] = \<const0> ;
  assign axi_w_wr_data_count[6] = \<const0> ;
  assign axi_w_wr_data_count[5] = \<const0> ;
  assign axi_w_wr_data_count[4] = \<const0> ;
  assign axi_w_wr_data_count[3] = \<const0> ;
  assign axi_w_wr_data_count[2] = \<const0> ;
  assign axi_w_wr_data_count[1] = \<const0> ;
  assign axi_w_wr_data_count[0] = \<const0> ;
  assign axis_data_count[10] = \<const0> ;
  assign axis_data_count[9] = \<const0> ;
  assign axis_data_count[8] = \<const0> ;
  assign axis_data_count[7] = \<const0> ;
  assign axis_data_count[6] = \<const0> ;
  assign axis_data_count[5] = \<const0> ;
  assign axis_data_count[4] = \<const0> ;
  assign axis_data_count[3] = \<const0> ;
  assign axis_data_count[2] = \<const0> ;
  assign axis_data_count[1] = \<const0> ;
  assign axis_data_count[0] = \<const0> ;
  assign axis_dbiterr = \<const0> ;
  assign axis_overflow = \<const0> ;
  assign axis_prog_empty = \<const1> ;
  assign axis_prog_full = \<const0> ;
  assign axis_rd_data_count[10] = \<const0> ;
  assign axis_rd_data_count[9] = \<const0> ;
  assign axis_rd_data_count[8] = \<const0> ;
  assign axis_rd_data_count[7] = \<const0> ;
  assign axis_rd_data_count[6] = \<const0> ;
  assign axis_rd_data_count[5] = \<const0> ;
  assign axis_rd_data_count[4] = \<const0> ;
  assign axis_rd_data_count[3] = \<const0> ;
  assign axis_rd_data_count[2] = \<const0> ;
  assign axis_rd_data_count[1] = \<const0> ;
  assign axis_rd_data_count[0] = \<const0> ;
  assign axis_sbiterr = \<const0> ;
  assign axis_underflow = \<const0> ;
  assign axis_wr_data_count[10] = \<const0> ;
  assign axis_wr_data_count[9] = \<const0> ;
  assign axis_wr_data_count[8] = \<const0> ;
  assign axis_wr_data_count[7] = \<const0> ;
  assign axis_wr_data_count[6] = \<const0> ;
  assign axis_wr_data_count[5] = \<const0> ;
  assign axis_wr_data_count[4] = \<const0> ;
  assign axis_wr_data_count[3] = \<const0> ;
  assign axis_wr_data_count[2] = \<const0> ;
  assign axis_wr_data_count[1] = \<const0> ;
  assign axis_wr_data_count[0] = \<const0> ;
  assign dbiterr = \<const0> ;
  assign m_axi_araddr[31] = \<const0> ;
  assign m_axi_araddr[30] = \<const0> ;
  assign m_axi_araddr[29] = \<const0> ;
  assign m_axi_araddr[28] = \<const0> ;
  assign m_axi_araddr[27] = \<const0> ;
  assign m_axi_araddr[26] = \<const0> ;
  assign m_axi_araddr[25] = \<const0> ;
  assign m_axi_araddr[24] = \<const0> ;
  assign m_axi_araddr[23] = \<const0> ;
  assign m_axi_araddr[22] = \<const0> ;
  assign m_axi_araddr[21] = \<const0> ;
  assign m_axi_araddr[20] = \<const0> ;
  assign m_axi_araddr[19] = \<const0> ;
  assign m_axi_araddr[18] = \<const0> ;
  assign m_axi_araddr[17] = \<const0> ;
  assign m_axi_araddr[16] = \<const0> ;
  assign m_axi_araddr[15] = \<const0> ;
  assign m_axi_araddr[14] = \<const0> ;
  assign m_axi_araddr[13] = \<const0> ;
  assign m_axi_araddr[12] = \<const0> ;
  assign m_axi_araddr[11] = \<const0> ;
  assign m_axi_araddr[10] = \<const0> ;
  assign m_axi_araddr[9] = \<const0> ;
  assign m_axi_araddr[8] = \<const0> ;
  assign m_axi_araddr[7] = \<const0> ;
  assign m_axi_araddr[6] = \<const0> ;
  assign m_axi_araddr[5] = \<const0> ;
  assign m_axi_araddr[4] = \<const0> ;
  assign m_axi_araddr[3] = \<const0> ;
  assign m_axi_araddr[2] = \<const0> ;
  assign m_axi_araddr[1] = \<const0> ;
  assign m_axi_araddr[0] = \<const0> ;
  assign m_axi_arburst[1] = \<const0> ;
  assign m_axi_arburst[0] = \<const0> ;
  assign m_axi_arcache[3] = \<const0> ;
  assign m_axi_arcache[2] = \<const0> ;
  assign m_axi_arcache[1] = \<const0> ;
  assign m_axi_arcache[0] = \<const0> ;
  assign m_axi_arid[0] = \<const0> ;
  assign m_axi_arlen[7] = \<const0> ;
  assign m_axi_arlen[6] = \<const0> ;
  assign m_axi_arlen[5] = \<const0> ;
  assign m_axi_arlen[4] = \<const0> ;
  assign m_axi_arlen[3] = \<const0> ;
  assign m_axi_arlen[2] = \<const0> ;
  assign m_axi_arlen[1] = \<const0> ;
  assign m_axi_arlen[0] = \<const0> ;
  assign m_axi_arlock[0] = \<const0> ;
  assign m_axi_arprot[2] = \<const0> ;
  assign m_axi_arprot[1] = \<const0> ;
  assign m_axi_arprot[0] = \<const0> ;
  assign m_axi_arqos[3] = \<const0> ;
  assign m_axi_arqos[2] = \<const0> ;
  assign m_axi_arqos[1] = \<const0> ;
  assign m_axi_arqos[0] = \<const0> ;
  assign m_axi_arregion[3] = \<const0> ;
  assign m_axi_arregion[2] = \<const0> ;
  assign m_axi_arregion[1] = \<const0> ;
  assign m_axi_arregion[0] = \<const0> ;
  assign m_axi_arsize[2] = \<const0> ;
  assign m_axi_arsize[1] = \<const0> ;
  assign m_axi_arsize[0] = \<const0> ;
  assign m_axi_aruser[0] = \<const0> ;
  assign m_axi_arvalid = \<const0> ;
  assign m_axi_awaddr[31] = \<const0> ;
  assign m_axi_awaddr[30] = \<const0> ;
  assign m_axi_awaddr[29] = \<const0> ;
  assign m_axi_awaddr[28] = \<const0> ;
  assign m_axi_awaddr[27] = \<const0> ;
  assign m_axi_awaddr[26] = \<const0> ;
  assign m_axi_awaddr[25] = \<const0> ;
  assign m_axi_awaddr[24] = \<const0> ;
  assign m_axi_awaddr[23] = \<const0> ;
  assign m_axi_awaddr[22] = \<const0> ;
  assign m_axi_awaddr[21] = \<const0> ;
  assign m_axi_awaddr[20] = \<const0> ;
  assign m_axi_awaddr[19] = \<const0> ;
  assign m_axi_awaddr[18] = \<const0> ;
  assign m_axi_awaddr[17] = \<const0> ;
  assign m_axi_awaddr[16] = \<const0> ;
  assign m_axi_awaddr[15] = \<const0> ;
  assign m_axi_awaddr[14] = \<const0> ;
  assign m_axi_awaddr[13] = \<const0> ;
  assign m_axi_awaddr[12] = \<const0> ;
  assign m_axi_awaddr[11] = \<const0> ;
  assign m_axi_awaddr[10] = \<const0> ;
  assign m_axi_awaddr[9] = \<const0> ;
  assign m_axi_awaddr[8] = \<const0> ;
  assign m_axi_awaddr[7] = \<const0> ;
  assign m_axi_awaddr[6] = \<const0> ;
  assign m_axi_awaddr[5] = \<const0> ;
  assign m_axi_awaddr[4] = \<const0> ;
  assign m_axi_awaddr[3] = \<const0> ;
  assign m_axi_awaddr[2] = \<const0> ;
  assign m_axi_awaddr[1] = \<const0> ;
  assign m_axi_awaddr[0] = \<const0> ;
  assign m_axi_awburst[1] = \<const0> ;
  assign m_axi_awburst[0] = \<const0> ;
  assign m_axi_awcache[3] = \<const0> ;
  assign m_axi_awcache[2] = \<const0> ;
  assign m_axi_awcache[1] = \<const0> ;
  assign m_axi_awcache[0] = \<const0> ;
  assign m_axi_awid[0] = \<const0> ;
  assign m_axi_awlen[7] = \<const0> ;
  assign m_axi_awlen[6] = \<const0> ;
  assign m_axi_awlen[5] = \<const0> ;
  assign m_axi_awlen[4] = \<const0> ;
  assign m_axi_awlen[3] = \<const0> ;
  assign m_axi_awlen[2] = \<const0> ;
  assign m_axi_awlen[1] = \<const0> ;
  assign m_axi_awlen[0] = \<const0> ;
  assign m_axi_awlock[0] = \<const0> ;
  assign m_axi_awprot[2] = \<const0> ;
  assign m_axi_awprot[1] = \<const0> ;
  assign m_axi_awprot[0] = \<const0> ;
  assign m_axi_awqos[3] = \<const0> ;
  assign m_axi_awqos[2] = \<const0> ;
  assign m_axi_awqos[1] = \<const0> ;
  assign m_axi_awqos[0] = \<const0> ;
  assign m_axi_awregion[3] = \<const0> ;
  assign m_axi_awregion[2] = \<const0> ;
  assign m_axi_awregion[1] = \<const0> ;
  assign m_axi_awregion[0] = \<const0> ;
  assign m_axi_awsize[2] = \<const0> ;
  assign m_axi_awsize[1] = \<const0> ;
  assign m_axi_awsize[0] = \<const0> ;
  assign m_axi_awuser[0] = \<const0> ;
  assign m_axi_awvalid = \<const0> ;
  assign m_axi_bready = \<const0> ;
  assign m_axi_rready = \<const0> ;
  assign m_axi_wdata[63] = \<const0> ;
  assign m_axi_wdata[62] = \<const0> ;
  assign m_axi_wdata[61] = \<const0> ;
  assign m_axi_wdata[60] = \<const0> ;
  assign m_axi_wdata[59] = \<const0> ;
  assign m_axi_wdata[58] = \<const0> ;
  assign m_axi_wdata[57] = \<const0> ;
  assign m_axi_wdata[56] = \<const0> ;
  assign m_axi_wdata[55] = \<const0> ;
  assign m_axi_wdata[54] = \<const0> ;
  assign m_axi_wdata[53] = \<const0> ;
  assign m_axi_wdata[52] = \<const0> ;
  assign m_axi_wdata[51] = \<const0> ;
  assign m_axi_wdata[50] = \<const0> ;
  assign m_axi_wdata[49] = \<const0> ;
  assign m_axi_wdata[48] = \<const0> ;
  assign m_axi_wdata[47] = \<const0> ;
  assign m_axi_wdata[46] = \<const0> ;
  assign m_axi_wdata[45] = \<const0> ;
  assign m_axi_wdata[44] = \<const0> ;
  assign m_axi_wdata[43] = \<const0> ;
  assign m_axi_wdata[42] = \<const0> ;
  assign m_axi_wdata[41] = \<const0> ;
  assign m_axi_wdata[40] = \<const0> ;
  assign m_axi_wdata[39] = \<const0> ;
  assign m_axi_wdata[38] = \<const0> ;
  assign m_axi_wdata[37] = \<const0> ;
  assign m_axi_wdata[36] = \<const0> ;
  assign m_axi_wdata[35] = \<const0> ;
  assign m_axi_wdata[34] = \<const0> ;
  assign m_axi_wdata[33] = \<const0> ;
  assign m_axi_wdata[32] = \<const0> ;
  assign m_axi_wdata[31] = \<const0> ;
  assign m_axi_wdata[30] = \<const0> ;
  assign m_axi_wdata[29] = \<const0> ;
  assign m_axi_wdata[28] = \<const0> ;
  assign m_axi_wdata[27] = \<const0> ;
  assign m_axi_wdata[26] = \<const0> ;
  assign m_axi_wdata[25] = \<const0> ;
  assign m_axi_wdata[24] = \<const0> ;
  assign m_axi_wdata[23] = \<const0> ;
  assign m_axi_wdata[22] = \<const0> ;
  assign m_axi_wdata[21] = \<const0> ;
  assign m_axi_wdata[20] = \<const0> ;
  assign m_axi_wdata[19] = \<const0> ;
  assign m_axi_wdata[18] = \<const0> ;
  assign m_axi_wdata[17] = \<const0> ;
  assign m_axi_wdata[16] = \<const0> ;
  assign m_axi_wdata[15] = \<const0> ;
  assign m_axi_wdata[14] = \<const0> ;
  assign m_axi_wdata[13] = \<const0> ;
  assign m_axi_wdata[12] = \<const0> ;
  assign m_axi_wdata[11] = \<const0> ;
  assign m_axi_wdata[10] = \<const0> ;
  assign m_axi_wdata[9] = \<const0> ;
  assign m_axi_wdata[8] = \<const0> ;
  assign m_axi_wdata[7] = \<const0> ;
  assign m_axi_wdata[6] = \<const0> ;
  assign m_axi_wdata[5] = \<const0> ;
  assign m_axi_wdata[4] = \<const0> ;
  assign m_axi_wdata[3] = \<const0> ;
  assign m_axi_wdata[2] = \<const0> ;
  assign m_axi_wdata[1] = \<const0> ;
  assign m_axi_wdata[0] = \<const0> ;
  assign m_axi_wid[0] = \<const0> ;
  assign m_axi_wlast = \<const0> ;
  assign m_axi_wstrb[7] = \<const0> ;
  assign m_axi_wstrb[6] = \<const0> ;
  assign m_axi_wstrb[5] = \<const0> ;
  assign m_axi_wstrb[4] = \<const0> ;
  assign m_axi_wstrb[3] = \<const0> ;
  assign m_axi_wstrb[2] = \<const0> ;
  assign m_axi_wstrb[1] = \<const0> ;
  assign m_axi_wstrb[0] = \<const0> ;
  assign m_axi_wuser[0] = \<const0> ;
  assign m_axi_wvalid = \<const0> ;
  assign m_axis_tdata[7] = \<const0> ;
  assign m_axis_tdata[6] = \<const0> ;
  assign m_axis_tdata[5] = \<const0> ;
  assign m_axis_tdata[4] = \<const0> ;
  assign m_axis_tdata[3] = \<const0> ;
  assign m_axis_tdata[2] = \<const0> ;
  assign m_axis_tdata[1] = \<const0> ;
  assign m_axis_tdata[0] = \<const0> ;
  assign m_axis_tdest[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[0] = \<const0> ;
  assign m_axis_tlast = \<const0> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[3] = \<const0> ;
  assign m_axis_tuser[2] = \<const0> ;
  assign m_axis_tuser[1] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  assign m_axis_tvalid = \<const0> ;
  assign overflow = \<const0> ;
  assign prog_full = \<const0> ;
  assign rd_data_count[9] = \<const0> ;
  assign rd_data_count[8] = \<const0> ;
  assign rd_data_count[7] = \<const0> ;
  assign rd_data_count[6] = \<const0> ;
  assign rd_data_count[5] = \<const0> ;
  assign rd_data_count[4] = \<const0> ;
  assign rd_data_count[3] = \<const0> ;
  assign rd_data_count[2] = \<const0> ;
  assign rd_data_count[1] = \<const0> ;
  assign rd_data_count[0] = \<const0> ;
  assign rd_rst_busy = wr_rst_busy;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_buser[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_rdata[63] = \<const0> ;
  assign s_axi_rdata[62] = \<const0> ;
  assign s_axi_rdata[61] = \<const0> ;
  assign s_axi_rdata[60] = \<const0> ;
  assign s_axi_rdata[59] = \<const0> ;
  assign s_axi_rdata[58] = \<const0> ;
  assign s_axi_rdata[57] = \<const0> ;
  assign s_axi_rdata[56] = \<const0> ;
  assign s_axi_rdata[55] = \<const0> ;
  assign s_axi_rdata[54] = \<const0> ;
  assign s_axi_rdata[53] = \<const0> ;
  assign s_axi_rdata[52] = \<const0> ;
  assign s_axi_rdata[51] = \<const0> ;
  assign s_axi_rdata[50] = \<const0> ;
  assign s_axi_rdata[49] = \<const0> ;
  assign s_axi_rdata[48] = \<const0> ;
  assign s_axi_rdata[47] = \<const0> ;
  assign s_axi_rdata[46] = \<const0> ;
  assign s_axi_rdata[45] = \<const0> ;
  assign s_axi_rdata[44] = \<const0> ;
  assign s_axi_rdata[43] = \<const0> ;
  assign s_axi_rdata[42] = \<const0> ;
  assign s_axi_rdata[41] = \<const0> ;
  assign s_axi_rdata[40] = \<const0> ;
  assign s_axi_rdata[39] = \<const0> ;
  assign s_axi_rdata[38] = \<const0> ;
  assign s_axi_rdata[37] = \<const0> ;
  assign s_axi_rdata[36] = \<const0> ;
  assign s_axi_rdata[35] = \<const0> ;
  assign s_axi_rdata[34] = \<const0> ;
  assign s_axi_rdata[33] = \<const0> ;
  assign s_axi_rdata[32] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_ruser[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign s_axis_tready = \<const0> ;
  assign sbiterr = \<const0> ;
  assign underflow = \<const0> ;
  assign wr_ack = \<const0> ;
  assign wr_data_count[9] = \<const0> ;
  assign wr_data_count[8] = \<const0> ;
  assign wr_data_count[7] = \<const0> ;
  assign wr_data_count[6] = \<const0> ;
  assign wr_data_count[5] = \<const0> ;
  assign wr_data_count[4] = \<const0> ;
  assign wr_data_count[3] = \<const0> ;
  assign wr_data_count[2] = \<const0> ;
  assign wr_data_count[1] = \<const0> ;
  assign wr_data_count[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  fifo_generator_1_fifo_generator_v13_2_3_synth inst_fifo_gen
       (.almost_empty(almost_empty),
        .almost_full(almost_full),
        .clk(clk),
        .data_count(data_count),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_empty(prog_empty),
        .rd_en(rd_en),
        .srst(srst),
        .valid(valid),
        .wr_en(wr_en),
        .wr_rst_reg_reg(wr_rst_busy));
endmodule

(* ORIG_REF_NAME = "fifo_generator_v13_2_3_synth" *) 
module fifo_generator_1_fifo_generator_v13_2_3_synth
   (data_count,
    dout,
    empty,
    full,
    almost_full,
    almost_empty,
    valid,
    wr_rst_reg_reg,
    prog_empty,
    rd_en,
    srst,
    clk,
    din,
    wr_en);
  output [9:0]data_count;
  output [31:0]dout;
  output empty;
  output full;
  output almost_full;
  output almost_empty;
  output valid;
  output wr_rst_reg_reg;
  output prog_empty;
  input rd_en;
  input srst;
  input clk;
  input [31:0]din;
  input wr_en;

  wire almost_empty;
  wire almost_full;
  wire clk;
  wire [9:0]data_count;
  wire [31:0]din;
  wire [31:0]dout;
  wire empty;
  wire full;
  wire prog_empty;
  wire rd_en;
  wire srst;
  wire valid;
  wire wr_en;
  wire wr_rst_reg_reg;

  fifo_generator_1_fifo_generator_top \gconvfifo.rf 
       (.DATA_COUNT(data_count),
        .almost_empty(almost_empty),
        .almost_full(almost_full),
        .clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_empty(prog_empty),
        .rd_en(rd_en),
        .srst(srst),
        .valid(valid),
        .wr_en(wr_en),
        .wr_rst_reg_reg(wr_rst_reg_reg));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module fifo_generator_1_memory
   (dout,
    ram_rd_en_d1,
    clk,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    tmp_ram_rd_en,
    tmp_ram_regce,
    SS,
    Q,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ,
    din,
    E);
  output [31:0]dout;
  output ram_rd_en_d1;
  input clk;
  input [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input tmp_ram_rd_en;
  input tmp_ram_regce;
  input [0:0]SS;
  input [9:0]Q;
  input [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  input [31:0]din;
  input [0:0]E;

  wire [0:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [9:0]\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ;
  wire [0:0]E;
  wire [9:0]Q;
  wire [0:0]SS;
  wire clk;
  wire [31:0]din;
  wire [31:0]dout;
  wire ram_rd_en_d1;
  wire tmp_ram_rd_en;
  wire tmp_ram_regce;

  fifo_generator_1_blk_mem_gen_v8_4_2 \gbm.gbmg.gbmgc.ngecc.bmg 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_0 ),
        .Q(Q),
        .SS(SS),
        .clk(clk),
        .din(din),
        .dout(dout),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .tmp_ram_regce(tmp_ram_regce));
  FDRE #(
    .INIT(1'b0)) 
    \gbm.gregce.ram_rd_en_d1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(E),
        .Q(ram_rd_en_d1),
        .R(SS));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module fifo_generator_1_rd_bin_cntr
   (Q,
    v1_reg_0,
    v1_reg,
    \gc1.count_d2_reg[9]_0 ,
    \gmux.gm[4].gms.ms ,
    \gmux.gm[4].gms.ms_0 ,
    srst_full_ff_i,
    E,
    clk);
  output [9:0]Q;
  output [4:0]v1_reg_0;
  output [4:0]v1_reg;
  output [9:0]\gc1.count_d2_reg[9]_0 ;
  input [9:0]\gmux.gm[4].gms.ms ;
  input [9:0]\gmux.gm[4].gms.ms_0 ;
  input srst_full_ff_i;
  input [0:0]E;
  input clk;

  wire [0:0]E;
  wire [9:0]Q;
  wire clk;
  wire \gc1.count[9]_i_2_n_0 ;
  wire [9:0]\gc1.count_d2_reg[9]_0 ;
  wire [9:0]\gmux.gm[4].gms.ms ;
  wire [9:0]\gmux.gm[4].gms.ms_0 ;
  wire [9:0]plusOp__0;
  wire [9:0]rd_pntr_plus1;
  wire srst_full_ff_i;
  wire [4:0]v1_reg;
  wire [4:0]v1_reg_0;

  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gc1.count[0]_i_1 
       (.I0(Q[0]),
        .O(plusOp__0[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gc1.count[1]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc1.count[2]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(Q[2]),
        .O(plusOp__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc1.count[3]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[3]),
        .O(plusOp__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \gc1.count[4]_i_1 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .I4(Q[4]),
        .O(plusOp__0[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \gc1.count[5]_i_1 
       (.I0(Q[3]),
        .I1(Q[1]),
        .I2(Q[0]),
        .I3(Q[2]),
        .I4(Q[4]),
        .I5(Q[5]),
        .O(plusOp__0[5]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \gc1.count[6]_i_1 
       (.I0(\gc1.count[9]_i_2_n_0 ),
        .I1(Q[6]),
        .O(plusOp__0[6]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    \gc1.count[7]_i_1 
       (.I0(\gc1.count[9]_i_2_n_0 ),
        .I1(Q[6]),
        .I2(Q[7]),
        .O(plusOp__0[7]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hDF20)) 
    \gc1.count[8]_i_1 
       (.I0(Q[6]),
        .I1(\gc1.count[9]_i_2_n_0 ),
        .I2(Q[7]),
        .I3(Q[8]),
        .O(plusOp__0[8]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hF7FF0800)) 
    \gc1.count[9]_i_1 
       (.I0(Q[8]),
        .I1(Q[7]),
        .I2(\gc1.count[9]_i_2_n_0 ),
        .I3(Q[6]),
        .I4(Q[9]),
        .O(plusOp__0[9]));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \gc1.count[9]_i_2 
       (.I0(Q[5]),
        .I1(Q[3]),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(Q[2]),
        .I5(Q[4]),
        .O(\gc1.count[9]_i_2_n_0 ));
  FDSE #(
    .INIT(1'b1)) 
    \gc1.count_d1_reg[0] 
       (.C(clk),
        .CE(E),
        .D(Q[0]),
        .Q(rd_pntr_plus1[0]),
        .S(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[1] 
       (.C(clk),
        .CE(E),
        .D(Q[1]),
        .Q(rd_pntr_plus1[1]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[2] 
       (.C(clk),
        .CE(E),
        .D(Q[2]),
        .Q(rd_pntr_plus1[2]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[3] 
       (.C(clk),
        .CE(E),
        .D(Q[3]),
        .Q(rd_pntr_plus1[3]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[4] 
       (.C(clk),
        .CE(E),
        .D(Q[4]),
        .Q(rd_pntr_plus1[4]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[5] 
       (.C(clk),
        .CE(E),
        .D(Q[5]),
        .Q(rd_pntr_plus1[5]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[6] 
       (.C(clk),
        .CE(E),
        .D(Q[6]),
        .Q(rd_pntr_plus1[6]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[7] 
       (.C(clk),
        .CE(E),
        .D(Q[7]),
        .Q(rd_pntr_plus1[7]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[8] 
       (.C(clk),
        .CE(E),
        .D(Q[8]),
        .Q(rd_pntr_plus1[8]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d1_reg[9] 
       (.C(clk),
        .CE(E),
        .D(Q[9]),
        .Q(rd_pntr_plus1[9]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[0] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[0]),
        .Q(\gc1.count_d2_reg[9]_0 [0]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[1] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[1]),
        .Q(\gc1.count_d2_reg[9]_0 [1]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[2] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[2]),
        .Q(\gc1.count_d2_reg[9]_0 [2]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[3] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[3]),
        .Q(\gc1.count_d2_reg[9]_0 [3]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[4] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[4]),
        .Q(\gc1.count_d2_reg[9]_0 [4]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[5] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[5]),
        .Q(\gc1.count_d2_reg[9]_0 [5]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[6] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[6]),
        .Q(\gc1.count_d2_reg[9]_0 [6]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[7] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[7]),
        .Q(\gc1.count_d2_reg[9]_0 [7]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[8] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[8]),
        .Q(\gc1.count_d2_reg[9]_0 [8]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_d2_reg[9] 
       (.C(clk),
        .CE(E),
        .D(rd_pntr_plus1[9]),
        .Q(\gc1.count_d2_reg[9]_0 [9]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[0] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[0]),
        .Q(Q[0]),
        .R(srst_full_ff_i));
  FDSE #(
    .INIT(1'b1)) 
    \gc1.count_reg[1] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[1]),
        .Q(Q[1]),
        .S(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[2] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[2]),
        .Q(Q[2]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[3] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[3]),
        .Q(Q[3]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[4] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[4]),
        .Q(Q[4]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[5] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[5]),
        .Q(Q[5]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[6] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[6]),
        .Q(Q[6]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[7] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[7]),
        .Q(Q[7]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[8] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[8]),
        .Q(Q[8]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gc1.count_reg[9] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[9]),
        .Q(Q[9]),
        .R(srst_full_ff_i));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[0].gm1.m1_i_1__0 
       (.I0(rd_pntr_plus1[0]),
        .I1(\gmux.gm[4].gms.ms [0]),
        .I2(rd_pntr_plus1[1]),
        .I3(\gmux.gm[4].gms.ms [1]),
        .O(v1_reg_0[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[0].gm1.m1_i_1__3 
       (.I0(\gc1.count_d2_reg[9]_0 [0]),
        .I1(\gmux.gm[4].gms.ms_0 [0]),
        .I2(\gc1.count_d2_reg[9]_0 [1]),
        .I3(\gmux.gm[4].gms.ms_0 [1]),
        .O(v1_reg[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[1].gms.ms_i_1__0 
       (.I0(rd_pntr_plus1[2]),
        .I1(\gmux.gm[4].gms.ms [2]),
        .I2(rd_pntr_plus1[3]),
        .I3(\gmux.gm[4].gms.ms [3]),
        .O(v1_reg_0[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[1].gms.ms_i_1__3 
       (.I0(\gc1.count_d2_reg[9]_0 [2]),
        .I1(\gmux.gm[4].gms.ms_0 [2]),
        .I2(\gc1.count_d2_reg[9]_0 [3]),
        .I3(\gmux.gm[4].gms.ms_0 [3]),
        .O(v1_reg[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[2].gms.ms_i_1__0 
       (.I0(rd_pntr_plus1[4]),
        .I1(\gmux.gm[4].gms.ms [4]),
        .I2(rd_pntr_plus1[5]),
        .I3(\gmux.gm[4].gms.ms [5]),
        .O(v1_reg_0[2]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[2].gms.ms_i_1__3 
       (.I0(\gc1.count_d2_reg[9]_0 [4]),
        .I1(\gmux.gm[4].gms.ms_0 [4]),
        .I2(\gc1.count_d2_reg[9]_0 [5]),
        .I3(\gmux.gm[4].gms.ms_0 [5]),
        .O(v1_reg[2]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[3].gms.ms_i_1__0 
       (.I0(rd_pntr_plus1[6]),
        .I1(\gmux.gm[4].gms.ms [6]),
        .I2(rd_pntr_plus1[7]),
        .I3(\gmux.gm[4].gms.ms [7]),
        .O(v1_reg_0[3]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[3].gms.ms_i_1__3 
       (.I0(\gc1.count_d2_reg[9]_0 [6]),
        .I1(\gmux.gm[4].gms.ms_0 [6]),
        .I2(\gc1.count_d2_reg[9]_0 [7]),
        .I3(\gmux.gm[4].gms.ms_0 [7]),
        .O(v1_reg[3]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[4].gms.ms_i_1__0 
       (.I0(rd_pntr_plus1[9]),
        .I1(\gmux.gm[4].gms.ms [9]),
        .I2(rd_pntr_plus1[8]),
        .I3(\gmux.gm[4].gms.ms [8]),
        .O(v1_reg_0[4]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[4].gms.ms_i_1__3 
       (.I0(\gc1.count_d2_reg[9]_0 [8]),
        .I1(\gmux.gm[4].gms.ms_0 [8]),
        .I2(\gc1.count_d2_reg[9]_0 [9]),
        .I3(\gmux.gm[4].gms.ms_0 [9]),
        .O(v1_reg[4]));
endmodule

(* ORIG_REF_NAME = "rd_handshaking_flags" *) 
module fifo_generator_1_rd_handshaking_flags
   (valid,
    srst_full_ff_i,
    ram_valid_i,
    clk);
  output valid;
  input srst_full_ff_i;
  input ram_valid_i;
  input clk;

  wire clk;
  wire ram_valid_d1;
  wire ram_valid_i;
  wire srst_full_ff_i;
  wire valid;

  FDRE #(
    .INIT(1'b0)) 
    \gv.ram_valid_d1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(ram_valid_i),
        .Q(ram_valid_d1),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \gvep1.ram_valid_d2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(ram_valid_d1),
        .Q(valid),
        .R(srst_full_ff_i));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module fifo_generator_1_rd_logic
   (out,
    empty,
    almost_empty,
    valid,
    prog_empty,
    \count_reg[9] ,
    tmp_ram_rd_en,
    E,
    \gc1.count_reg[9] ,
    v1_reg,
    \gc1.count_d2_reg[9] ,
    \gmux.gm[1].gms.ms ,
    \gmux.gm[2].gms.ms ,
    \gmux.gm[3].gms.ms ,
    \gmux.gm[4].gms.ms ,
    ram_empty_i_reg,
    v1_reg_0,
    clk,
    srst_full_ff_i,
    p_17_out,
    \greg.gpcry_sym.diff_pntr_pad_reg[8] ,
    Q,
    S,
    \greg.gpcry_sym.diff_pntr_pad_reg[10] ,
    rd_en,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    srst,
    ram_rd_en_d1,
    wr_en,
    \count_reg[0] ,
    \gmux.gm[4].gms.ms_0 );
  output out;
  output empty;
  output almost_empty;
  output valid;
  output prog_empty;
  output [9:0]\count_reg[9] ;
  output tmp_ram_rd_en;
  output [0:0]E;
  output [9:0]\gc1.count_reg[9] ;
  output [4:0]v1_reg;
  output [9:0]\gc1.count_d2_reg[9] ;
  input \gmux.gm[1].gms.ms ;
  input \gmux.gm[2].gms.ms ;
  input \gmux.gm[3].gms.ms ;
  input \gmux.gm[4].gms.ms ;
  input ram_empty_i_reg;
  input [4:0]v1_reg_0;
  input clk;
  input srst_full_ff_i;
  input p_17_out;
  input \greg.gpcry_sym.diff_pntr_pad_reg[8] ;
  input [9:0]Q;
  input [7:0]S;
  input [1:0]\greg.gpcry_sym.diff_pntr_pad_reg[10] ;
  input rd_en;
  input \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input srst;
  input ram_rd_en_d1;
  input wr_en;
  input \count_reg[0] ;
  input [9:0]\gmux.gm[4].gms.ms_0 ;

  wire \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [0:0]E;
  wire [9:0]Q;
  wire [7:0]S;
  wire almost_empty;
  wire [4:0]\c2/v1_reg ;
  wire clk;
  wire cntr_en;
  wire \count_reg[0] ;
  wire [9:0]\count_reg[9] ;
  wire empty;
  wire [9:0]\gc1.count_d2_reg[9] ;
  wire [9:0]\gc1.count_reg[9] ;
  wire \gmux.gm[1].gms.ms ;
  wire \gmux.gm[2].gms.ms ;
  wire \gmux.gm[3].gms.ms ;
  wire \gmux.gm[4].gms.ms ;
  wire [9:0]\gmux.gm[4].gms.ms_0 ;
  wire [1:0]\greg.gpcry_sym.diff_pntr_pad_reg[10] ;
  wire \greg.gpcry_sym.diff_pntr_pad_reg[8] ;
  wire out;
  wire p_17_out;
  wire prog_empty;
  wire ram_empty_i_reg;
  wire ram_rd_en_d1;
  wire ram_valid_i;
  wire rd_en;
  wire srst;
  wire srst_full_ff_i;
  wire tmp_ram_rd_en;
  wire [4:0]v1_reg;
  wire [4:0]v1_reg_0;
  wire valid;
  wire wr_en;

  fifo_generator_1_rd_handshaking_flags \grhf.rhf 
       (.clk(clk),
        .ram_valid_i(ram_valid_i),
        .srst_full_ff_i(srst_full_ff_i),
        .valid(valid));
  fifo_generator_1_dc_ss \grss.gdc.dc 
       (.E(cntr_en),
        .Q(\count_reg[9] ),
        .clk(clk),
        .out(out),
        .rd_en(rd_en),
        .srst_full_ff_i(srst_full_ff_i));
  fifo_generator_1_rd_pe_ss \grss.gpe.rdpe 
       (.Q(Q[8:0]),
        .S(S),
        .clk(clk),
        .\greg.gpcry_sym.diff_pntr_pad_reg[10]_0 (\greg.gpcry_sym.diff_pntr_pad_reg[10] ),
        .\greg.gpcry_sym.diff_pntr_pad_reg[8]_0 (\greg.gpcry_sym.diff_pntr_pad_reg[8] ),
        .p_17_out(p_17_out),
        .prog_empty(prog_empty),
        .ram_rd_en_d1(ram_rd_en_d1),
        .srst_full_ff_i(srst_full_ff_i));
  fifo_generator_1_rd_status_flags_ss \grss.rsts 
       (.\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram (\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .E(cntr_en),
        .almost_empty(almost_empty),
        .clk(clk),
        .\count_reg[0] (\count_reg[0] ),
        .empty(empty),
        .\gmux.gm[1].gms.ms (\gmux.gm[1].gms.ms ),
        .\gmux.gm[2].gms.ms (\gmux.gm[2].gms.ms ),
        .\gmux.gm[3].gms.ms (\gmux.gm[3].gms.ms ),
        .\gmux.gm[4].gms.ms (\gmux.gm[4].gms.ms ),
        .out(out),
        .p_17_out(p_17_out),
        .ram_empty_i_reg_0(ram_empty_i_reg),
        .ram_valid_i(ram_valid_i),
        .rd_en(rd_en),
        .rd_en_0(E),
        .srst(srst),
        .srst_full_ff_i(srst_full_ff_i),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .v1_reg(\c2/v1_reg ),
        .v1_reg_0(v1_reg_0),
        .wr_en(wr_en));
  fifo_generator_1_rd_bin_cntr rpntr
       (.E(E),
        .Q(\gc1.count_reg[9] ),
        .clk(clk),
        .\gc1.count_d2_reg[9]_0 (\gc1.count_d2_reg[9] ),
        .\gmux.gm[4].gms.ms (Q),
        .\gmux.gm[4].gms.ms_0 (\gmux.gm[4].gms.ms_0 ),
        .srst_full_ff_i(srst_full_ff_i),
        .v1_reg(v1_reg),
        .v1_reg_0(\c2/v1_reg ));
endmodule

(* ORIG_REF_NAME = "rd_pe_ss" *) 
module fifo_generator_1_rd_pe_ss
   (prog_empty,
    srst_full_ff_i,
    p_17_out,
    clk,
    \greg.gpcry_sym.diff_pntr_pad_reg[8]_0 ,
    Q,
    S,
    \greg.gpcry_sym.diff_pntr_pad_reg[10]_0 ,
    ram_rd_en_d1);
  output prog_empty;
  input srst_full_ff_i;
  input p_17_out;
  input clk;
  input \greg.gpcry_sym.diff_pntr_pad_reg[8]_0 ;
  input [8:0]Q;
  input [7:0]S;
  input [1:0]\greg.gpcry_sym.diff_pntr_pad_reg[10]_0 ;
  input ram_rd_en_d1;

  wire [8:0]Q;
  wire [7:0]S;
  wire clk;
  wire [10:1]diff_pntr_pad;
  wire \gpes.prog_empty_i_i_1_n_0 ;
  wire \gpes.prog_empty_i_i_2_n_0 ;
  wire \gpes.prog_empty_i_i_3_n_0 ;
  wire [1:0]\greg.gpcry_sym.diff_pntr_pad_reg[10]_0 ;
  wire \greg.gpcry_sym.diff_pntr_pad_reg[8]_0 ;
  wire p_17_out;
  wire [10:1]plusOp;
  wire plusOp_carry__0_n_7;
  wire plusOp_carry_n_0;
  wire plusOp_carry_n_1;
  wire plusOp_carry_n_2;
  wire plusOp_carry_n_3;
  wire plusOp_carry_n_4;
  wire plusOp_carry_n_5;
  wire plusOp_carry_n_6;
  wire plusOp_carry_n_7;
  wire prog_empty;
  wire ram_rd_en_d1;
  wire ram_wr_en_i;
  wire srst_full_ff_i;
  wire [7:1]NLW_plusOp_carry__0_CO_UNCONNECTED;
  wire [7:2]NLW_plusOp_carry__0_O_UNCONNECTED;

  LUT6 #(
    .INIT(64'hEEEEAEEEFEEEEEEE)) 
    \gpes.prog_empty_i_i_1 
       (.I0(srst_full_ff_i),
        .I1(prog_empty),
        .I2(\gpes.prog_empty_i_i_2_n_0 ),
        .I3(\gpes.prog_empty_i_i_3_n_0 ),
        .I4(ram_rd_en_d1),
        .I5(ram_wr_en_i),
        .O(\gpes.prog_empty_i_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \gpes.prog_empty_i_i_2 
       (.I0(diff_pntr_pad[5]),
        .I1(diff_pntr_pad[6]),
        .I2(diff_pntr_pad[7]),
        .I3(diff_pntr_pad[8]),
        .I4(diff_pntr_pad[10]),
        .I5(diff_pntr_pad[9]),
        .O(\gpes.prog_empty_i_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0004)) 
    \gpes.prog_empty_i_i_3 
       (.I0(diff_pntr_pad[1]),
        .I1(diff_pntr_pad[2]),
        .I2(diff_pntr_pad[4]),
        .I3(diff_pntr_pad[3]),
        .O(\gpes.prog_empty_i_i_3_n_0 ));
  FDRE #(
    .INIT(1'b1)) 
    \gpes.prog_empty_i_reg 
       (.C(clk),
        .CE(1'b1),
        .D(\gpes.prog_empty_i_i_1_n_0 ),
        .Q(prog_empty),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[10]),
        .Q(diff_pntr_pad[10]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[1]),
        .Q(diff_pntr_pad[1]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[2]),
        .Q(diff_pntr_pad[2]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[3]),
        .Q(diff_pntr_pad[3]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[4]),
        .Q(diff_pntr_pad[4]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[5]),
        .Q(diff_pntr_pad[5]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[6]),
        .Q(diff_pntr_pad[6]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[7]),
        .Q(diff_pntr_pad[7]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[8]),
        .Q(diff_pntr_pad[8]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.gpcry_sym.diff_pntr_pad_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(plusOp[9]),
        .Q(diff_pntr_pad[9]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \greg.ram_wr_en_i_reg 
       (.C(clk),
        .CE(1'b1),
        .D(p_17_out),
        .Q(ram_wr_en_i),
        .R(srst_full_ff_i));
  CARRY8 plusOp_carry
       (.CI(\greg.gpcry_sym.diff_pntr_pad_reg[8]_0 ),
        .CI_TOP(1'b0),
        .CO({plusOp_carry_n_0,plusOp_carry_n_1,plusOp_carry_n_2,plusOp_carry_n_3,plusOp_carry_n_4,plusOp_carry_n_5,plusOp_carry_n_6,plusOp_carry_n_7}),
        .DI(Q[7:0]),
        .O(plusOp[8:1]),
        .S(S));
  CARRY8 plusOp_carry__0
       (.CI(plusOp_carry_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_plusOp_carry__0_CO_UNCONNECTED[7:1],plusOp_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,Q[8]}),
        .O({NLW_plusOp_carry__0_O_UNCONNECTED[7:2],plusOp[10:9]}),
        .S({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,\greg.gpcry_sym.diff_pntr_pad_reg[10]_0 }));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_ss" *) 
module fifo_generator_1_rd_status_flags_ss
   (out,
    empty,
    almost_empty,
    tmp_ram_rd_en,
    E,
    rd_en_0,
    ram_valid_i,
    \gmux.gm[1].gms.ms ,
    \gmux.gm[2].gms.ms ,
    \gmux.gm[3].gms.ms ,
    \gmux.gm[4].gms.ms ,
    ram_empty_i_reg_0,
    v1_reg,
    v1_reg_0,
    clk,
    srst_full_ff_i,
    rd_en,
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ,
    srst,
    p_17_out,
    wr_en,
    \count_reg[0] );
  output out;
  output empty;
  output almost_empty;
  output tmp_ram_rd_en;
  output [0:0]E;
  output [0:0]rd_en_0;
  output ram_valid_i;
  input \gmux.gm[1].gms.ms ;
  input \gmux.gm[2].gms.ms ;
  input \gmux.gm[3].gms.ms ;
  input \gmux.gm[4].gms.ms ;
  input ram_empty_i_reg_0;
  input [4:0]v1_reg;
  input [4:0]v1_reg_0;
  input clk;
  input srst_full_ff_i;
  input rd_en;
  input \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  input srst;
  input p_17_out;
  input wr_en;
  input \count_reg[0] ;

  wire \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ;
  wire [0:0]E;
  wire almost_empty;
  wire c1_n_0;
  wire clk;
  wire comp1;
  wire comp2;
  wire \count_reg[0] ;
  wire \gmux.gm[1].gms.ms ;
  wire \gmux.gm[2].gms.ms ;
  wire \gmux.gm[3].gms.ms ;
  wire \gmux.gm[4].gms.ms ;
  wire p_17_out;
  wire p_1_out;
  (* DONT_TOUCH *) wire ram_empty_fb_i;
  (* DONT_TOUCH *) wire ram_empty_i;
  wire ram_empty_i_reg_0;
  wire ram_valid_i;
  wire rd_en;
  wire [0:0]rd_en_0;
  wire srst;
  wire srst_full_ff_i;
  wire tmp_ram_rd_en;
  wire [4:0]v1_reg;
  wire [4:0]v1_reg_0;
  wire wr_en;

  assign empty = ram_empty_i;
  assign out = ram_empty_fb_i;
  LUT4 #(
    .INIT(16'hFFF4)) 
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_2 
       (.I0(ram_empty_fb_i),
        .I1(rd_en),
        .I2(\DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram ),
        .I3(srst),
        .O(tmp_ram_rd_en));
  fifo_generator_1_compare_2 c1
       (.comp1(comp1),
        .\gmux.gm[1].gms.ms_0 (\gmux.gm[1].gms.ms ),
        .\gmux.gm[2].gms.ms_0 (\gmux.gm[2].gms.ms ),
        .\gmux.gm[3].gms.ms_0 (\gmux.gm[3].gms.ms ),
        .\gmux.gm[4].gms.ms_0 (\gmux.gm[4].gms.ms ),
        .out(ram_empty_fb_i),
        .p_17_out(p_17_out),
        .ram_empty_fb_i_reg(c1_n_0),
        .ram_empty_i_reg(ram_empty_i_reg_0),
        .rd_en(rd_en),
        .srst_full_ff_i(srst_full_ff_i));
  fifo_generator_1_compare_3 c2
       (.almost_empty(almost_empty),
        .comp1(comp1),
        .comp2(comp2),
        .out(ram_empty_fb_i),
        .p_17_out(p_17_out),
        .p_1_out(p_1_out),
        .rd_en(rd_en),
        .v1_reg(v1_reg));
  LUT4 #(
    .INIT(16'h22D2)) 
    \count[9]_i_1 
       (.I0(rd_en),
        .I1(ram_empty_fb_i),
        .I2(wr_en),
        .I3(\count_reg[0] ),
        .O(E));
  fifo_generator_1_compare_4 \gae.c3 
       (.comp2(comp2),
        .v1_reg_0(v1_reg_0));
  FDSE #(
    .INIT(1'b1)) 
    \gae.ram_aempty_i_reg 
       (.C(clk),
        .CE(1'b1),
        .D(p_1_out),
        .Q(almost_empty),
        .S(srst_full_ff_i));
  LUT2 #(
    .INIT(4'h2)) 
    \gbm.gregce.ram_rd_en_d1_i_1 
       (.I0(rd_en),
        .I1(ram_empty_fb_i),
        .O(rd_en_0));
  LUT2 #(
    .INIT(4'h2)) 
    \gv.ram_valid_d1_i_1 
       (.I0(rd_en),
        .I1(ram_empty_i),
        .O(ram_valid_i));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(c1_n_0),
        .Q(ram_empty_fb_i),
        .R(1'b0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b1)) 
    ram_empty_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(c1_n_0),
        .Q(ram_empty_i),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module fifo_generator_1_reset_blk_ramfifo
   (wr_rst_reg_reg,
    tmp_ram_regce,
    SS,
    srst,
    clk,
    ram_rd_en_d1);
  output wr_rst_reg_reg;
  output tmp_ram_regce;
  output [0:0]SS;
  input srst;
  input clk;
  input ram_rd_en_d1;

  wire [0:0]SS;
  wire clk;
  wire ram_rd_en_d1;
  wire srst;
  wire tmp_ram_regce;
  wire wr_rst_reg_reg;

  fifo_generator_1_bram_fifo_rstlogic \g8serrst.usrst_inst 
       (.SS(SS),
        .clk(clk),
        .ram_rd_en_d1(ram_rd_en_d1),
        .srst(srst),
        .tmp_ram_regce(tmp_ram_regce),
        .wr_rst_reg_reg_0(wr_rst_reg_reg));
endmodule

(* ORIG_REF_NAME = "updn_cntr" *) 
module fifo_generator_1_updn_cntr
   (Q,
    out,
    rd_en,
    srst_full_ff_i,
    E,
    clk);
  output [9:0]Q;
  input out;
  input rd_en;
  input srst_full_ff_i;
  input [0:0]E;
  input clk;

  wire [0:0]E;
  wire [9:0]Q;
  wire clk;
  wire \count[0]_i_1_n_0 ;
  wire \count[8]_i_10_n_0 ;
  wire \count[8]_i_2_n_0 ;
  wire \count[8]_i_3_n_0 ;
  wire \count[8]_i_4_n_0 ;
  wire \count[8]_i_5_n_0 ;
  wire \count[8]_i_6_n_0 ;
  wire \count[8]_i_7_n_0 ;
  wire \count[8]_i_8_n_0 ;
  wire \count[8]_i_9_n_0 ;
  wire \count[9]_i_3_n_0 ;
  wire \count_reg[8]_i_1_n_0 ;
  wire \count_reg[8]_i_1_n_1 ;
  wire \count_reg[8]_i_1_n_10 ;
  wire \count_reg[8]_i_1_n_11 ;
  wire \count_reg[8]_i_1_n_12 ;
  wire \count_reg[8]_i_1_n_13 ;
  wire \count_reg[8]_i_1_n_14 ;
  wire \count_reg[8]_i_1_n_15 ;
  wire \count_reg[8]_i_1_n_2 ;
  wire \count_reg[8]_i_1_n_3 ;
  wire \count_reg[8]_i_1_n_4 ;
  wire \count_reg[8]_i_1_n_5 ;
  wire \count_reg[8]_i_1_n_6 ;
  wire \count_reg[8]_i_1_n_7 ;
  wire \count_reg[8]_i_1_n_8 ;
  wire \count_reg[8]_i_1_n_9 ;
  wire \count_reg[9]_i_2_n_15 ;
  wire out;
  wire rd_en;
  wire srst_full_ff_i;
  wire [7:0]\NLW_count_reg[9]_i_2_CO_UNCONNECTED ;
  wire [7:1]\NLW_count_reg[9]_i_2_O_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \count[0]_i_1 
       (.I0(Q[0]),
        .O(\count[0]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h9A)) 
    \count[8]_i_10 
       (.I0(Q[1]),
        .I1(out),
        .I2(rd_en),
        .O(\count[8]_i_10_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \count[8]_i_2 
       (.I0(Q[1]),
        .O(\count[8]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_3 
       (.I0(Q[7]),
        .I1(Q[8]),
        .O(\count[8]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_4 
       (.I0(Q[6]),
        .I1(Q[7]),
        .O(\count[8]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_5 
       (.I0(Q[5]),
        .I1(Q[6]),
        .O(\count[8]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_6 
       (.I0(Q[4]),
        .I1(Q[5]),
        .O(\count[8]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_7 
       (.I0(Q[3]),
        .I1(Q[4]),
        .O(\count[8]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_8 
       (.I0(Q[2]),
        .I1(Q[3]),
        .O(\count[8]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[8]_i_9 
       (.I0(Q[1]),
        .I1(Q[2]),
        .O(\count[8]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \count[9]_i_3 
       (.I0(Q[8]),
        .I1(Q[9]),
        .O(\count[9]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[0] 
       (.C(clk),
        .CE(E),
        .D(\count[0]_i_1_n_0 ),
        .Q(Q[0]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[1] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_15 ),
        .Q(Q[1]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[2] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_14 ),
        .Q(Q[2]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[3] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_13 ),
        .Q(Q[3]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[4] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_12 ),
        .Q(Q[4]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[5] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_11 ),
        .Q(Q[5]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[6] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_10 ),
        .Q(Q[6]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[7] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_9 ),
        .Q(Q[7]),
        .R(srst_full_ff_i));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[8] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[8]_i_1_n_8 ),
        .Q(Q[8]),
        .R(srst_full_ff_i));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY8 \count_reg[8]_i_1 
       (.CI(Q[0]),
        .CI_TOP(1'b0),
        .CO({\count_reg[8]_i_1_n_0 ,\count_reg[8]_i_1_n_1 ,\count_reg[8]_i_1_n_2 ,\count_reg[8]_i_1_n_3 ,\count_reg[8]_i_1_n_4 ,\count_reg[8]_i_1_n_5 ,\count_reg[8]_i_1_n_6 ,\count_reg[8]_i_1_n_7 }),
        .DI({Q[7:1],\count[8]_i_2_n_0 }),
        .O({\count_reg[8]_i_1_n_8 ,\count_reg[8]_i_1_n_9 ,\count_reg[8]_i_1_n_10 ,\count_reg[8]_i_1_n_11 ,\count_reg[8]_i_1_n_12 ,\count_reg[8]_i_1_n_13 ,\count_reg[8]_i_1_n_14 ,\count_reg[8]_i_1_n_15 }),
        .S({\count[8]_i_3_n_0 ,\count[8]_i_4_n_0 ,\count[8]_i_5_n_0 ,\count[8]_i_6_n_0 ,\count[8]_i_7_n_0 ,\count[8]_i_8_n_0 ,\count[8]_i_9_n_0 ,\count[8]_i_10_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \count_reg[9] 
       (.C(clk),
        .CE(E),
        .D(\count_reg[9]_i_2_n_15 ),
        .Q(Q[9]),
        .R(srst_full_ff_i));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY8 \count_reg[9]_i_2 
       (.CI(\count_reg[8]_i_1_n_0 ),
        .CI_TOP(1'b0),
        .CO(\NLW_count_reg[9]_i_2_CO_UNCONNECTED [7:0]),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_count_reg[9]_i_2_O_UNCONNECTED [7:1],\count_reg[9]_i_2_n_15 }),
        .S({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,\count[9]_i_3_n_0 }));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module fifo_generator_1_wr_bin_cntr
   (\gcc0.gc1.gsym.count_d2_reg[9]_0 ,
    Q,
    S,
    \gcc0.gc1.gsym.count_reg[9]_0 ,
    v1_reg_0,
    v1_reg,
    v1_reg_1,
    \gcc0.gc1.gsym.count_d2_reg[0]_0 ,
    \gcc0.gc1.gsym.count_d2_reg[2]_0 ,
    \gcc0.gc1.gsym.count_d2_reg[4]_0 ,
    \gcc0.gc1.gsym.count_d2_reg[6]_0 ,
    \gcc0.gc1.gsym.count_d2_reg[9]_1 ,
    \greg.gpcry_sym.diff_pntr_pad_reg[10] ,
    \gmux.gm[4].gms.ms ,
    SS,
    E,
    clk);
  output [1:0]\gcc0.gc1.gsym.count_d2_reg[9]_0 ;
  output [9:0]Q;
  output [7:0]S;
  output [9:0]\gcc0.gc1.gsym.count_reg[9]_0 ;
  output [4:0]v1_reg_0;
  output [4:0]v1_reg;
  output [4:0]v1_reg_1;
  output \gcc0.gc1.gsym.count_d2_reg[0]_0 ;
  output \gcc0.gc1.gsym.count_d2_reg[2]_0 ;
  output \gcc0.gc1.gsym.count_d2_reg[4]_0 ;
  output \gcc0.gc1.gsym.count_d2_reg[6]_0 ;
  output \gcc0.gc1.gsym.count_d2_reg[9]_1 ;
  input [9:0]\greg.gpcry_sym.diff_pntr_pad_reg[10] ;
  input [9:0]\gmux.gm[4].gms.ms ;
  input [0:0]SS;
  input [0:0]E;
  input clk;

  wire [0:0]E;
  wire [9:0]Q;
  wire [7:0]S;
  wire [0:0]SS;
  wire clk;
  wire \gcc0.gc1.gsym.count[9]_i_2_n_0 ;
  wire \gcc0.gc1.gsym.count_d2_reg[0]_0 ;
  wire \gcc0.gc1.gsym.count_d2_reg[2]_0 ;
  wire \gcc0.gc1.gsym.count_d2_reg[4]_0 ;
  wire \gcc0.gc1.gsym.count_d2_reg[6]_0 ;
  wire [1:0]\gcc0.gc1.gsym.count_d2_reg[9]_0 ;
  wire \gcc0.gc1.gsym.count_d2_reg[9]_1 ;
  wire [9:0]\gcc0.gc1.gsym.count_reg[9]_0 ;
  wire [9:0]\gmux.gm[4].gms.ms ;
  wire [9:0]\greg.gpcry_sym.diff_pntr_pad_reg[10] ;
  wire [9:0]p_12_out;
  wire [9:0]plusOp__1;
  wire [4:0]v1_reg;
  wire [4:0]v1_reg_0;
  wire [4:0]v1_reg_1;

  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gcc0.gc1.gsym.count[0]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .O(plusOp__1[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gcc0.gc1.gsym.count[1]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .O(plusOp__1[1]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gcc0.gc1.gsym.count[2]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .O(plusOp__1[2]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gcc0.gc1.gsym.count[3]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .I3(\gcc0.gc1.gsym.count_reg[9]_0 [3]),
        .O(plusOp__1[3]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \gcc0.gc1.gsym.count[4]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .I3(\gcc0.gc1.gsym.count_reg[9]_0 [3]),
        .I4(\gcc0.gc1.gsym.count_reg[9]_0 [4]),
        .O(plusOp__1[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \gcc0.gc1.gsym.count[5]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [3]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .I3(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .I4(\gcc0.gc1.gsym.count_reg[9]_0 [4]),
        .I5(\gcc0.gc1.gsym.count_reg[9]_0 [5]),
        .O(plusOp__1[5]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \gcc0.gc1.gsym.count[6]_i_1 
       (.I0(\gcc0.gc1.gsym.count[9]_i_2_n_0 ),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [6]),
        .O(plusOp__1[6]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB4)) 
    \gcc0.gc1.gsym.count[7]_i_1 
       (.I0(\gcc0.gc1.gsym.count[9]_i_2_n_0 ),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [6]),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [7]),
        .O(plusOp__1[7]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hDF20)) 
    \gcc0.gc1.gsym.count[8]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [6]),
        .I1(\gcc0.gc1.gsym.count[9]_i_2_n_0 ),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [7]),
        .I3(\gcc0.gc1.gsym.count_reg[9]_0 [8]),
        .O(plusOp__1[8]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hF7FF0800)) 
    \gcc0.gc1.gsym.count[9]_i_1 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [8]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [7]),
        .I2(\gcc0.gc1.gsym.count[9]_i_2_n_0 ),
        .I3(\gcc0.gc1.gsym.count_reg[9]_0 [6]),
        .I4(\gcc0.gc1.gsym.count_reg[9]_0 [9]),
        .O(plusOp__1[9]));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \gcc0.gc1.gsym.count[9]_i_2 
       (.I0(\gcc0.gc1.gsym.count_reg[9]_0 [5]),
        .I1(\gcc0.gc1.gsym.count_reg[9]_0 [3]),
        .I2(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .I3(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .I4(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .I5(\gcc0.gc1.gsym.count_reg[9]_0 [4]),
        .O(\gcc0.gc1.gsym.count[9]_i_2_n_0 ));
  FDSE #(
    .INIT(1'b1)) 
    \gcc0.gc1.gsym.count_d1_reg[0] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .Q(p_12_out[0]),
        .S(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[1] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .Q(p_12_out[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[2] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .Q(p_12_out[2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[3] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [3]),
        .Q(p_12_out[3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[4] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [4]),
        .Q(p_12_out[4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[5] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [5]),
        .Q(p_12_out[5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[6] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [6]),
        .Q(p_12_out[6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[7] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [7]),
        .Q(p_12_out[7]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[8] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [8]),
        .Q(p_12_out[8]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d1_reg[9] 
       (.C(clk),
        .CE(E),
        .D(\gcc0.gc1.gsym.count_reg[9]_0 [9]),
        .Q(p_12_out[9]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[0] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[0]),
        .Q(Q[0]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[1] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[1]),
        .Q(Q[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[2] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[2]),
        .Q(Q[2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[3] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[3]),
        .Q(Q[3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[4] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[4]),
        .Q(Q[4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[5] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[5]),
        .Q(Q[5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[6] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[6]),
        .Q(Q[6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[7] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[7]),
        .Q(Q[7]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[8] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[8]),
        .Q(Q[8]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_d2_reg[9] 
       (.C(clk),
        .CE(E),
        .D(p_12_out[9]),
        .Q(Q[9]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[0] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[0]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [0]),
        .R(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gcc0.gc1.gsym.count_reg[1] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[1]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [1]),
        .S(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[2] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[2]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[3] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[3]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[4] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[4]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[5] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[5]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[6] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[6]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[7] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[7]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [7]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[8] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[8]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [8]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gcc0.gc1.gsym.count_reg[9] 
       (.C(clk),
        .CE(E),
        .D(plusOp__1[9]),
        .Q(\gcc0.gc1.gsym.count_reg[9]_0 [9]),
        .R(SS));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[0].gm1.m1_i_1 
       (.I0(Q[0]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [0]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [1]),
        .I3(Q[1]),
        .O(v1_reg_0[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[0].gm1.m1_i_1__1 
       (.I0(Q[0]),
        .I1(\gmux.gm[4].gms.ms [0]),
        .I2(Q[1]),
        .I3(\gmux.gm[4].gms.ms [1]),
        .O(v1_reg[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[0].gm1.m1_i_1__2 
       (.I0(p_12_out[0]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [0]),
        .I2(p_12_out[1]),
        .I3(\greg.gpcry_sym.diff_pntr_pad_reg[10] [1]),
        .O(v1_reg_1[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[0].gm1.m1_i_1__4 
       (.I0(Q[0]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [0]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [1]),
        .I3(Q[1]),
        .O(\gcc0.gc1.gsym.count_d2_reg[0]_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[1].gms.ms_i_1 
       (.I0(Q[2]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [2]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [3]),
        .I3(Q[3]),
        .O(v1_reg_0[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[1].gms.ms_i_1__1 
       (.I0(Q[2]),
        .I1(\gmux.gm[4].gms.ms [2]),
        .I2(Q[3]),
        .I3(\gmux.gm[4].gms.ms [3]),
        .O(v1_reg[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[1].gms.ms_i_1__2 
       (.I0(p_12_out[2]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [2]),
        .I2(p_12_out[3]),
        .I3(\greg.gpcry_sym.diff_pntr_pad_reg[10] [3]),
        .O(v1_reg_1[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[1].gms.ms_i_1__4 
       (.I0(Q[2]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [2]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [3]),
        .I3(Q[3]),
        .O(\gcc0.gc1.gsym.count_d2_reg[2]_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[2].gms.ms_i_1 
       (.I0(Q[4]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [4]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [5]),
        .I3(Q[5]),
        .O(v1_reg_0[2]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[2].gms.ms_i_1__1 
       (.I0(Q[4]),
        .I1(\gmux.gm[4].gms.ms [4]),
        .I2(Q[5]),
        .I3(\gmux.gm[4].gms.ms [5]),
        .O(v1_reg[2]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[2].gms.ms_i_1__2 
       (.I0(p_12_out[4]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [4]),
        .I2(p_12_out[5]),
        .I3(\greg.gpcry_sym.diff_pntr_pad_reg[10] [5]),
        .O(v1_reg_1[2]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[2].gms.ms_i_1__4 
       (.I0(Q[4]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [4]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [5]),
        .I3(Q[5]),
        .O(\gcc0.gc1.gsym.count_d2_reg[4]_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[3].gms.ms_i_1 
       (.I0(Q[6]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [6]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [7]),
        .I3(Q[7]),
        .O(v1_reg_0[3]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[3].gms.ms_i_1__1 
       (.I0(Q[6]),
        .I1(\gmux.gm[4].gms.ms [6]),
        .I2(Q[7]),
        .I3(\gmux.gm[4].gms.ms [7]),
        .O(v1_reg[3]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[3].gms.ms_i_1__2 
       (.I0(p_12_out[6]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [6]),
        .I2(p_12_out[7]),
        .I3(\greg.gpcry_sym.diff_pntr_pad_reg[10] [7]),
        .O(v1_reg_1[3]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[3].gms.ms_i_1__4 
       (.I0(Q[6]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [6]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [7]),
        .I3(Q[7]),
        .O(\gcc0.gc1.gsym.count_d2_reg[6]_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[4].gms.ms_i_1 
       (.I0(Q[9]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [9]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [8]),
        .I3(Q[8]),
        .O(v1_reg_0[4]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[4].gms.ms_i_1__1 
       (.I0(Q[8]),
        .I1(\gmux.gm[4].gms.ms [8]),
        .I2(Q[9]),
        .I3(\gmux.gm[4].gms.ms [9]),
        .O(v1_reg[4]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[4].gms.ms_i_1__2 
       (.I0(p_12_out[9]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [9]),
        .I2(p_12_out[8]),
        .I3(\greg.gpcry_sym.diff_pntr_pad_reg[10] [8]),
        .O(v1_reg_1[4]));
  LUT4 #(
    .INIT(16'h9009)) 
    \gmux.gm[4].gms.ms_i_1__4 
       (.I0(Q[9]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [9]),
        .I2(\greg.gpcry_sym.diff_pntr_pad_reg[10] [8]),
        .I3(Q[8]),
        .O(\gcc0.gc1.gsym.count_d2_reg[9]_1 ));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry__0_i_1
       (.I0(Q[9]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [9]),
        .O(\gcc0.gc1.gsym.count_d2_reg[9]_0 [1]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry__0_i_2
       (.I0(Q[8]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [8]),
        .O(\gcc0.gc1.gsym.count_d2_reg[9]_0 [0]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_2
       (.I0(Q[7]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [7]),
        .O(S[7]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_3
       (.I0(Q[6]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [6]),
        .O(S[6]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_4
       (.I0(Q[5]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [5]),
        .O(S[5]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_5
       (.I0(Q[4]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [4]),
        .O(S[4]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_6
       (.I0(Q[3]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [3]),
        .O(S[3]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_7
       (.I0(Q[2]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [2]),
        .O(S[2]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_8
       (.I0(Q[1]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [1]),
        .O(S[1]));
  LUT2 #(
    .INIT(4'h9)) 
    plusOp_carry_i_9
       (.I0(Q[0]),
        .I1(\greg.gpcry_sym.diff_pntr_pad_reg[10] [0]),
        .O(S[0]));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module fifo_generator_1_wr_logic
   (out,
    full,
    almost_full,
    \gcc0.gc1.gsym.count_d2_reg[9] ,
    Q,
    S,
    wr_en_0,
    ram_full_fb_i_reg,
    \gcc0.gc1.gsym.count_reg[9] ,
    v1_reg,
    \gcc0.gc1.gsym.count_d2_reg[0] ,
    \gcc0.gc1.gsym.count_d2_reg[2] ,
    \gcc0.gc1.gsym.count_d2_reg[4] ,
    \gcc0.gc1.gsym.count_d2_reg[6] ,
    \gcc0.gc1.gsym.count_d2_reg[9]_0 ,
    v1_reg_0,
    clk,
    SS,
    \greg.gpcry_sym.diff_pntr_pad_reg[10] ,
    wr_en,
    E,
    \gaf.gaf0.ram_afull_i_reg ,
    rd_en,
    \gmux.gm[4].gms.ms );
  output out;
  output full;
  output almost_full;
  output [1:0]\gcc0.gc1.gsym.count_d2_reg[9] ;
  output [9:0]Q;
  output [7:0]S;
  output [0:0]wr_en_0;
  output ram_full_fb_i_reg;
  output [9:0]\gcc0.gc1.gsym.count_reg[9] ;
  output [4:0]v1_reg;
  output \gcc0.gc1.gsym.count_d2_reg[0] ;
  output \gcc0.gc1.gsym.count_d2_reg[2] ;
  output \gcc0.gc1.gsym.count_d2_reg[4] ;
  output \gcc0.gc1.gsym.count_d2_reg[6] ;
  output \gcc0.gc1.gsym.count_d2_reg[9]_0 ;
  input [4:0]v1_reg_0;
  input clk;
  input [0:0]SS;
  input [9:0]\greg.gpcry_sym.diff_pntr_pad_reg[10] ;
  input wr_en;
  input [0:0]E;
  input \gaf.gaf0.ram_afull_i_reg ;
  input rd_en;
  input [9:0]\gmux.gm[4].gms.ms ;

  wire [0:0]E;
  wire [9:0]Q;
  wire [7:0]S;
  wire [0:0]SS;
  wire almost_full;
  wire [4:0]\c0/v1_reg ;
  wire [4:0]\c1/v1_reg ;
  wire clk;
  wire full;
  wire \gaf.gaf0.ram_afull_i_reg ;
  wire \gcc0.gc1.gsym.count_d2_reg[0] ;
  wire \gcc0.gc1.gsym.count_d2_reg[2] ;
  wire \gcc0.gc1.gsym.count_d2_reg[4] ;
  wire \gcc0.gc1.gsym.count_d2_reg[6] ;
  wire [1:0]\gcc0.gc1.gsym.count_d2_reg[9] ;
  wire \gcc0.gc1.gsym.count_d2_reg[9]_0 ;
  wire [9:0]\gcc0.gc1.gsym.count_reg[9] ;
  wire [9:0]\gmux.gm[4].gms.ms ;
  wire [9:0]\greg.gpcry_sym.diff_pntr_pad_reg[10] ;
  wire out;
  wire ram_full_fb_i_reg;
  wire rd_en;
  wire [4:0]v1_reg;
  wire [4:0]v1_reg_0;
  wire wr_en;
  wire [0:0]wr_en_0;

  fifo_generator_1_wr_status_flags_ss \gwss.wsts 
       (.E(E),
        .SS(SS),
        .almost_full(almost_full),
        .clk(clk),
        .full(full),
        .\gaf.gaf0.ram_afull_i_reg_0 (\gaf.gaf0.ram_afull_i_reg ),
        .out(out),
        .ram_full_fb_i_reg_0(ram_full_fb_i_reg),
        .rd_en(rd_en),
        .v1_reg(\c0/v1_reg ),
        .v1_reg_0(v1_reg_0),
        .v1_reg_1(\c1/v1_reg ),
        .wr_en(wr_en),
        .wr_en_0(wr_en_0));
  fifo_generator_1_wr_bin_cntr wpntr
       (.E(wr_en_0),
        .Q(Q),
        .S(S),
        .SS(SS),
        .clk(clk),
        .\gcc0.gc1.gsym.count_d2_reg[0]_0 (\gcc0.gc1.gsym.count_d2_reg[0] ),
        .\gcc0.gc1.gsym.count_d2_reg[2]_0 (\gcc0.gc1.gsym.count_d2_reg[2] ),
        .\gcc0.gc1.gsym.count_d2_reg[4]_0 (\gcc0.gc1.gsym.count_d2_reg[4] ),
        .\gcc0.gc1.gsym.count_d2_reg[6]_0 (\gcc0.gc1.gsym.count_d2_reg[6] ),
        .\gcc0.gc1.gsym.count_d2_reg[9]_0 (\gcc0.gc1.gsym.count_d2_reg[9] ),
        .\gcc0.gc1.gsym.count_d2_reg[9]_1 (\gcc0.gc1.gsym.count_d2_reg[9]_0 ),
        .\gcc0.gc1.gsym.count_reg[9]_0 (\gcc0.gc1.gsym.count_reg[9] ),
        .\gmux.gm[4].gms.ms (\gmux.gm[4].gms.ms ),
        .\greg.gpcry_sym.diff_pntr_pad_reg[10] (\greg.gpcry_sym.diff_pntr_pad_reg[10] ),
        .v1_reg(v1_reg),
        .v1_reg_0(\c0/v1_reg ),
        .v1_reg_1(\c1/v1_reg ));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_ss" *) 
module fifo_generator_1_wr_status_flags_ss
   (out,
    full,
    almost_full,
    wr_en_0,
    ram_full_fb_i_reg_0,
    v1_reg,
    v1_reg_1,
    v1_reg_0,
    clk,
    SS,
    wr_en,
    E,
    \gaf.gaf0.ram_afull_i_reg_0 ,
    rd_en);
  output out;
  output full;
  output almost_full;
  output [0:0]wr_en_0;
  output ram_full_fb_i_reg_0;
  input [4:0]v1_reg;
  input [4:0]v1_reg_1;
  input [4:0]v1_reg_0;
  input clk;
  input [0:0]SS;
  input wr_en;
  input [0:0]E;
  input \gaf.gaf0.ram_afull_i_reg_0 ;
  input rd_en;

  wire [0:0]E;
  wire [0:0]SS;
  wire c1_n_0;
  wire clk;
  wire comp0;
  wire \gaf.gaf0.ram_afull_i_reg_0 ;
  wire p_0_in;
  wire p_2_out;
  (* DONT_TOUCH *) wire ram_afull_fb;
  (* DONT_TOUCH *) wire ram_afull_i;
  (* DONT_TOUCH *) wire ram_full_fb_i;
  wire ram_full_fb_i_reg_0;
  (* DONT_TOUCH *) wire ram_full_i;
  wire rd_en;
  wire [4:0]v1_reg;
  wire [4:0]v1_reg_0;
  wire [4:0]v1_reg_1;
  wire wr_en;
  wire [0:0]wr_en_0;

  assign almost_full = ram_afull_i;
  assign full = ram_full_i;
  assign out = ram_full_fb_i;
  LUT2 #(
    .INIT(4'h2)) 
    \DEVICE_8SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_1 
       (.I0(wr_en),
        .I1(ram_full_fb_i),
        .O(wr_en_0));
  fifo_generator_1_compare c0
       (.comp0(comp0),
        .v1_reg(v1_reg));
  fifo_generator_1_compare_0 c1
       (.E(E),
        .SS(SS),
        .almost_full(ram_afull_i),
        .comp0(comp0),
        .\gaf.gaf0.ram_afull_i_reg (\gaf.gaf0.ram_afull_i_reg_0 ),
        .\gaf.gaf0.ram_afull_i_reg_0 (wr_en_0),
        .out(ram_full_fb_i),
        .p_0_in(p_0_in),
        .p_2_out(p_2_out),
        .rd_en(rd_en),
        .v1_reg_1(v1_reg_1),
        .wr_en(wr_en),
        .wr_en_0(c1_n_0));
  fifo_generator_1_compare_1 \gaf.c2 
       (.p_0_in(p_0_in),
        .v1_reg_0(v1_reg_0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \gaf.gaf0.ram_afull_i_reg 
       (.C(clk),
        .CE(1'b1),
        .D(p_2_out),
        .Q(ram_afull_i),
        .R(SS));
  LUT1 #(
    .INIT(2'h2)) 
    i_0
       (.I0(1'b0),
        .O(ram_afull_fb));
  LUT4 #(
    .INIT(16'hF4FF)) 
    plusOp_carry_i_1
       (.I0(ram_full_fb_i),
        .I1(wr_en),
        .I2(\gaf.gaf0.ram_afull_i_reg_0 ),
        .I3(rd_en),
        .O(ram_full_fb_i_reg_0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    ram_full_fb_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(c1_n_0),
        .Q(ram_full_fb_i),
        .R(1'b0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    ram_full_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(c1_n_0),
        .Q(ram_full_i),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
