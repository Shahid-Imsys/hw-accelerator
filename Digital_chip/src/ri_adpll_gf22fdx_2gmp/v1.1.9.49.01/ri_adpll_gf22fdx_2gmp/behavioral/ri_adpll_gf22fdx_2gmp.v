// Company           :   racyics
// Author            :   pilz
// E-Mail            :   pilz@racyics.de
//
// Filename          :   ri_adpll_2gmp.v
// Project Name      :   p_ri
// Subproject Name   :   s_libpll_gf22fdsoi
// Description       :   <short description>
//
// Create Date       :   Tue Aug 15 09:14:29 2017
// Last Change       :   $Date: 2021-07-29 15:41:45 +0200 (Thu, 29 Jul 2021) $
// by                :   $Author: pilz $
//------------------------------------------------------------
module ri_adpll_gf22fdx_2gmp #(
                       //configuration
                       parameter ADPLL_STATUS_BITS    = 21,
                       parameter CLKGEN_FCNTRL_BITS   = 8,      //number of frequency level control bits for clkgen wrapper
                       parameter P_ROW_BIT_WIDTH      = 6,
                       parameter P_COL_BIT_WIDTH      = 8,
                       parameter P_COARSE_BIT_WIDTH   = 6,
                       parameter DCOFTBITS            = 256,
                       // synopsys translate_off
                       parameter SIGMA_T              = 0.005,
                       // synopsys translate_on
                       parameter FT_BIN_WIDTH         = 8,
                       parameter FBT_WITH             = 3)
                     (
                      input                          ref_clk_i, //reference clock input
                      input                          scan_clk_i, //scan clock input
                      input                          reset_q_i, //asynchronous reset
                      input                          en_adpll_ctrl_i, //enable controller
                      output                         clk_core_o, //low speed core clock output
                      output                         pll_locked_o, //lock signal
                      input [4:0]                    c_ci_i,               // integral filter coefficient (alpha)
                      input [7:0]                    c_cp_i,               // proportional filter coefficient (beta)
                      input                          c_main_div_n1_i,      // main loop divider N1
                      input [1:0]                    c_main_div_n2_i,      // main loop divider N2
                      input [1:0]                    c_main_div_n3_i,      // main loop divider N3
                      input [1:0]                    c_main_div_n4_i,      // main loop divider N4
                      input [1:0]                    c_out_div_sel_i,      // output divider select signal
                      input                          c_open_loop_i,        // PLL starts without loop regulation
                      input [7:0]                    c_ft_i,               // fine tune signal for open loop
                      input [1:0]                    c_divcore_sel_i,      // divcore in Custom macro
                      input [5:0]                    c_coarse_i,           // Coarse Tune Value for open loop and Fast Fine Tune
                      input                          c_bist_mode_i,        // BIST mode 1:BIST; 0: normal PLL usage
                      input                          c_auto_coarsetune_i,  // automatic Coarse tune search
                      input                          c_enforce_lock_i,     // overwrites lock bit
                      input                          c_pfd_select_i,       // enables synchronizer for PFD
                      input                          c_lock_window_sel_i,  // lock detection window: 1:short, 0:long
                      input                          c_div_core_mux_sel_i, // selects divider chain: 0: COREDIV, 1: OUTDIV + COREDIV
                      input [1:0]                    c_filter_shift_i,     // shift for CP/CI for fast lockin
                      input                          c_en_fast_lock_i,     // enables fast fine tune lockin
                      input [2:0]                    c_sar_limit_i,        // limit for binary search in fast fine tune
                      input                          c_set_op_lock_i,      // force lock bit to 1 in OP mode
                      input                          c_disable_lock_i,     // force lock bit to 0
                      input                          c_ct_compensation_i,  //in case of finetune underflow/overflow coarsetune will be increased/decreased
                      input                          c_ref_bypass_i, //bypass reference clock to core clock output
                      output [ADPLL_STATUS_BITS-1:0] adpll_status_o, //ADPLL status
                      output                         adpll_status_ack_o,
                      input                          adpll_status_capture_i, //capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
                      input [2:0]                    scan_in_i,
                      //lint_checking ALL OFF
                      output [2:0]                   scan_out_o,
                      //lint_checking ALL ON
                      input                          scan_enable_i,
                      input                          testmode_i,
                      output [7:0]                   dco_clk_o, // multiphase DCO clock
                      output [1:0]                   clk_tx_o,
                      output                         pfd_o,
                      output                         bist_busy_o, //1:BIST is still running; 0:BIST finished
                      output                         bist_fail_coarse_o, //1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
                      output                         bist_fail_fine_o    //1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
                      );





`ifdef RI_ADPLL_GF22FDX_2GMP_BEHAVIORAL
    parameter SIMPLE_BEHAVIORAL = 1;
`else
    parameter SIMPLE_BEHAVIORAL = 0;
    wire reset_q;
`endif



generate
    if (SIMPLE_BEHAVIORAL) begin: gen_inst_ri_adpll_simple_behavioral
            ri_adpll_gf22fdx_2gmp_behavioral #(.ADPLL_STATUS_BITS(ADPLL_STATUS_BITS),
                                  .DCOFTBITS(DCOFTBITS),
                                  .FT_BIN_WIDTH(FT_BIN_WIDTH),
                                  .FBT_WITH(FBT_WITH),
                                  .P_COARSE_BIT_WIDTH(P_COARSE_BIT_WIDTH),
                                  .P_ROW_BIT_WIDTH(P_ROW_BIT_WIDTH),
                                  // synopsys translate_off
                                  .SIGMA_T(SIGMA_T),
                                  // synopsys translate_on
                                  .P_COL_BIT_WIDTH(P_COL_BIT_WIDTH))
                                  i_ri_adpll_2gmp_behavioral
                                  (
                                  .ref_clk_i(ref_clk_i),                           //reference clock input
                                  .scan_clk_i(scan_clk_i),                         //scan clock input
                                  .reset_q_i(reset_q_i),                             //asynchronous reset
                                  .en_adpll_ctrl_i(en_adpll_ctrl_i),               //enable controller
                                  .clk_core_o(clk_core_o),                         //low speed core clock outpu
                                  .pfd_o(pfd_o),
                                  .pll_locked_o(pll_locked_o),                     //lock signal
                                  .c_ref_bypass_i(c_ref_bypass_i),                     //bypass reference clock to core clock output
                                  .dco_clk_o(dco_clk_o),                           // multiphase DCO clock
                                  .clk_tx_o(clk_tx_o),
                                  .c_ci_i(c_ci_i),               // integral filter coefficient (alpha)
                                  .c_cp_i(c_cp_i),               // proportional filter coefficient (beta)
                                  .c_main_div_n1_i(c_main_div_n1_i),      // main loop divider N1
                                  .c_main_div_n2_i(c_main_div_n2_i),      // main loop divider N2
                                  .c_main_div_n3_i(c_main_div_n3_i),      // main loop divider N3
                                  .c_main_div_n4_i(c_main_div_n4_i),      // main loop divider N4
                                  .c_out_div_sel_i(c_out_div_sel_i),      // output divider select signal
                                  .c_open_loop_i(c_open_loop_i),        // PLL starts without loop regulation
                                  .c_ft_i(c_ft_i),               // fine tune signal for open loop
                                  .c_divcore_sel_i(c_divcore_sel_i),      // divcore in Custom macro
                                  .c_coarse_i(c_coarse_i),           // Coarse Tune Value for open loop and Fast Fine Tune
                                  .c_bist_mode_i(c_bist_mode_i),     // BIST mode 1:BIST; 0: normal PLL usage
                                  .c_auto_coarsetune_i(c_auto_coarsetune_i),  // automatic Coarse tune search
                                  .c_enforce_lock_i(c_enforce_lock_i),     // overwrites lock bit
                                  .c_pfd_select_i(c_pfd_select_i),       // enables synchronizer for PFD
                                  .c_lock_window_sel_i(c_lock_window_sel_i),  // lock detection window: 1:short, 0:long
                                  .c_div_core_mux_sel_i(c_div_core_mux_sel_i), // selects divider chain: 0: COREDIV, 1: OUTDIV + COREDIV
                                  .c_filter_shift_i(c_filter_shift_i),     // shift for CP/CI for fast lockin
                                  .c_en_fast_lock_i(c_en_fast_lock_i),     // enables fast fine tune lockin
                                  .c_sar_limit_i(c_sar_limit_i),        // limit for binary search in fast fine tune
                                  .c_set_op_lock_i(c_set_op_lock_i),      // force lock bit to 1 in OP mode
                                  .c_disable_lock_i(c_disable_lock_i),     // force lock bit to 0
                                  .c_ct_compensation_i(c_ct_compensation_i), //in case of finetune underflow/overflow coarsetune will be increased/decreased
                                  .adpll_status_o(adpll_status_o),                 //ADPLL status
                                  .adpll_status_ack_o(adpll_status_ack_o),
                                  .adpll_status_capture_i(adpll_status_capture_i), //capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
                                  //DFT
                                  .scan_in_i(scan_in_i),
                                  .scan_out_o(scan_out_o),
                                  .scan_enable_i(scan_enable_i),
                                  .testmode_i(testmode_i),
                                  .bist_busy_o(bist_busy_o), //1:BIST i still running; 0:BIST finished
                                  .bist_fail_coarse_o(bist_fail_coarse_o), //1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
                                  .bist_fail_fine_o(bist_fail_fine_o) //1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
                                  );
    end
    else begin : gen_inst_ri_adpll

        common_clkbuf i_reset_buf (.I(reset_q_i),.Z(reset_q));

        ri_adpll_2gmp_core_mclk #(.ADPLL_STATUS_BITS(ADPLL_STATUS_BITS),
                                  .DCOFTBITS(DCOFTBITS),
                                  .FT_BIN_WIDTH(FT_BIN_WIDTH),
                                  .FBT_WITH(FBT_WITH),
                                  .P_COARSE_BIT_WIDTH(P_COARSE_BIT_WIDTH),
                                  .P_ROW_BIT_WIDTH(P_ROW_BIT_WIDTH),
                                  // synopsys translate_off
                                  .SIGMA_T(SIGMA_T),
                                  // synopsys translate_on
                                  .P_COL_BIT_WIDTH(P_COL_BIT_WIDTH))
                                  i_ri_adpll_2gmp_core_mclk
                                  (
                                  .ref_clk_i(ref_clk_i),                           //reference clock input
                                  .scan_clk_i(scan_clk_i),                         //scan clock input
                                  .reset_q_i(reset_q),                             //asynchronous reset
                                  .en_adpll_ctrl_i(en_adpll_ctrl_i),               //enable controller
                                  .clk_core_o(clk_core_o),                         //low speed core clock outpu
                                  .pfd_o(pfd_o),
                                  .pll_locked_o(pll_locked_o),                     //lock signal
                                  .c_ref_bypass_i(c_ref_bypass_i),                     //bypass reference clock to core clock output
                                  .dco_clk_o(dco_clk_o),                           // multiphase DCO clock
                                  .clk_tx_o(clk_tx_o),
                                  .c_ci_i(c_ci_i),               // integral filter coefficient (alpha)
                                  .c_cp_i(c_cp_i),               // proportional filter coefficient (beta)
                                  .c_main_div_n1_i(c_main_div_n1_i),      // main loop divider N1
                                  .c_main_div_n2_i(c_main_div_n2_i),      // main loop divider N2
                                  .c_main_div_n3_i(c_main_div_n3_i),      // main loop divider N3
                                  .c_main_div_n4_i(c_main_div_n4_i),      // main loop divider N4
                                  .c_out_div_sel_i(c_out_div_sel_i),      // output divider select signal
                                  .c_open_loop_i(c_open_loop_i),        // PLL starts without loop regulation
                                  .c_ft_i(c_ft_i),               // fine tune signal for open loop
                                  .c_divcore_sel_i(c_divcore_sel_i),      // divcore in Custom macro
                                  .c_coarse_i(c_coarse_i),           // Coarse Tune Value for open loop and Fast Fine Tune
                                  .c_bist_mode_i(c_bist_mode_i),     // BIST mode 1:BIST; 0: normal PLL usage
                                  .c_auto_coarsetune_i(c_auto_coarsetune_i),  // automatic Coarse tune search
                                  .c_enforce_lock_i(c_enforce_lock_i),     // overwrites lock bit
                                  .c_pfd_select_i(c_pfd_select_i),       // enables synchronizer for PFD
                                  .c_lock_window_sel_i(c_lock_window_sel_i),  // lock detection window: 1:short, 0:long
                                  .c_div_core_mux_sel_i(c_div_core_mux_sel_i), // selects divider chain: 0: COREDIV, 1: OUTDIV + COREDIV
                                  .c_filter_shift_i(c_filter_shift_i),     // shift for CP/CI for fast lockin
                                  .c_en_fast_lock_i(c_en_fast_lock_i),     // enables fast fine tune lockin
                                  .c_sar_limit_i(c_sar_limit_i),        // limit for binary search in fast fine tune
                                  .c_set_op_lock_i(c_set_op_lock_i),      // force lock bit to 1 in OP mode
                                  .c_disable_lock_i(c_disable_lock_i),     // force lock bit to 0
                                  .c_ct_compensation_i(c_ct_compensation_i), //in case of finetune underflow/overflow coarsetune will be increased/decreased
                                  .adpll_status_o(adpll_status_o),                 //ADPLL status
                                  .adpll_status_ack_o(adpll_status_ack_o),
                                  .adpll_status_capture_i(adpll_status_capture_i), //capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
                                  //DFT
                                  .scan_enable_i(scan_enable_i),
                                  .testmode_i(testmode_i),
                                  .bist_busy_o(bist_busy_o), //1:BIST i still running; 0:BIST finished
                                 .bist_fail_coarse_o(bist_fail_coarse_o), //1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
                                 .bist_fail_fine_o(bist_fail_fine_o) //1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
                                  );
    end
endgenerate




endmodule
