//
// Filename          :   ri_adpll_gf22fdx_2gmp_behavioral.v
// Project Name      :   p_ri
// Subproject Name   :   s_libpll_gf22fdsoi
// Description       :   This is a simplified behavioral of the PLL
//                       to reduce simulator resources
//
// Create Date       :   Tue Aug 15 09:14:29 2017
// Last Change       :   $Date: 2018-04-04 14:25:38 +0200 (Wed, 04 Apr 2018) $
// by                :   $Author: pilz $
//------------------------------------------------------------
`celldefine
`timescale 1ns/100fs
module ri_adpll_gf22fdx_2gmp_behavioral #(
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
                       parameter FBT_WITH             =3)
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
                      input                          c_ref_bypass_i, //bypass reference clock to core clock output
                      input                          c_ct_compensation_i,  //in case of finetune underflow/overflow coarsetune will be increased/decreased
                      output [ADPLL_STATUS_BITS-1:0] adpll_status_o, //ADPLL status
                      output                         adpll_status_ack_o,
                      input                          adpll_status_capture_i, //capture Bit for APDLL status, rising edge of adpll_status_capture_i captures status
                      input [2:0]                    scan_in_i,
                      output [2:0]                   scan_out_o,
                      input                          scan_enable_i,
                      input                          testmode_i,
                      output [7:0]                   dco_clk_o,
                      output [1:0]                   clk_tx_o,
                      output                         pfd_o,
                      output                         bist_busy_o, //1:BIST is still running; 0:BIST finished
                      output                         bist_fail_coarse_o, //1:BIST fail for coarsetune (monotony error or BIST was not correct started); 0:BIST pass
                      output                         bist_fail_fine_o    //1:BIST fail for finetune (monotony error or BIST was not correct started); 0:BIST pass
                      );



////////////////////////////////////////////////////////////////////////
///////////////////////////////config part//////////////////////////////

//////lock-in parameter (static for all configurations)
localparam LOCKIN_TIME_SIMPLIFIED_ref100 =  20000.0; //ns
localparam LOCKIN_TIME_SIMPLIFIED_ref50 =  40000.0; //ns
localparam LOCKIN_TIME_SIMPLIFIED_ref25 =  80000.0; //ns
localparam FILTER_COEFF_BITS=5;


wire [1:0]                     c_divcore_sel_sig;
wire [1:0]                     c_out_div_sel_sig;
wire                           c_open_loop_sig;
wire [FT_BIN_WIDTH-1:0]        c_ft_sig;
wire [P_COARSE_BIT_WIDTH-1:0]  c_coarse_sig;
wire                           clk_dsm;
wire                           c_auto_coarsetune;
wire                           c_enforce_lock_sig;
wire                           c_pfd_select_sig;
wire                           c_lock_window_sel_sig;
wire                           c_sync_bypass_sig;
wire [1:0]                     c_filter_shift_sig;
wire                           c_en_fast_lock_sig;
wire [2:0]                     c_sar_limit_sig;
wire                           c_set_op_lock_sig;
wire                           c_disable_lock_sig;
wire                           c_div_core_mux_sel;
wire [FILTER_COEFF_BITS-1:0]   ci_sig; //integral filter coefficient (alpha)
wire [2*FILTER_COEFF_BITS-1:0] cp_sig; //proportional filter coefficient (beta)
wire                           c_bist_mode_sig;
wire                           c_ct_compensation_sig;


assign ci_sig                = c_ci_i[4:0]; //  5-bit, integral filter coefficient (alpha)
assign cp_sig                = {2'b00,c_cp_i}; //  8-bit, proportional filter coefficient (beta)
assign c_out_div_sel_sig     =  c_out_div_sel_i    ;
assign c_open_loop_sig       =  c_open_loop_i      ;
assign c_ft_sig              =  c_ft_i             ;
assign c_divcore_sel_sig     =  c_divcore_sel_i    ;
assign c_coarse_sig          =  c_coarse_i         ; // Coarse Tune Reset Value
assign c_bist_mode_sig       =  c_bist_mode_i    ;
assign c_auto_coarsetune     =  c_auto_coarsetune_i;
assign c_enforce_lock_sig    =  c_enforce_lock_i   ;
assign c_pfd_select_sig      =  c_pfd_select_i     ;
assign c_lock_window_sel_sig =  c_lock_window_sel_i;
assign c_div_core_mux_sel    =  c_div_core_mux_sel_i;
assign c_filter_shift_sig    =  c_filter_shift_i   ;
assign c_en_fast_lock_sig    =  c_en_fast_lock_i   ;
assign c_sar_limit_sig       =  c_sar_limit_i      ;
assign c_set_op_lock_sig     =  c_set_op_lock_i    ;
assign c_disable_lock_sig    =  c_disable_lock_i   ;
assign c_ct_compensation_sig = c_ct_compensation_i;



////////////////////////////////////////////////////////////////////////
///////////////////////////////reference period measurement/////////////
real                       ref_period = 0.0;
real                       ref_time0 = 0.1;
real                       ref_time1 = 0.1;
real                       lockin_start =0.0;
reg                        enable_delay =1'b0;


always @(posedge en_adpll_ctrl_i) begin
    lockin_start <= $realtime;
end

always @(posedge ref_clk_i) begin
    if(en_adpll_ctrl_i==1'b1) begin
        if((ref_time0 - lockin_start) < 100.0) begin
            ref_time0 <= $realtime;
            ref_time1 <= ref_time0;
            ref_period <= ref_time0 - ref_time1;
        end
        enable_delay <= 1'b1;
    end
    else begin
        enable_delay <= 1'b0;
    end
end


////////////////////////////////////////////////////////////////////////
///////////////////////////////lock-in delay///////////////////////////
reg lock_enable;
reg config_error = 1'b0;
real locktime = 0.0;


always @(posedge ref_clk_i or negedge en_adpll_ctrl_i) begin
    if(en_adpll_ctrl_i==1'b0) begin
        lock_enable <= 1'b0;
    end
    else begin
        if (enable_delay == 1'b1) begin
            locktime <= $realtime;
            //ref_clk: f>100MHz
            if (ref_period <= 11.0) begin
                if(((locktime - lockin_start) < LOCKIN_TIME_SIMPLIFIED_ref100)) begin
                    lock_enable <= 1'b0;
                end
                else begin
                    lock_enable <= 1'b1;
                end
            end
            //ref_clk: f<25MHz
            else if (ref_period >= 39.0) begin
                if(((locktime - lockin_start) < LOCKIN_TIME_SIMPLIFIED_ref25)) begin
                    lock_enable <= 1'b0;
                end
                else begin
                    lock_enable <= 1'b1;
                end
            end
            //ref_clk: 25MHz<f<100MHz
            else begin
                 if(((locktime - lockin_start) < LOCKIN_TIME_SIMPLIFIED_ref50)) begin
                    lock_enable <= 1'b0;
                end
                else begin
                    lock_enable <= 1'b1;
                end
            end
        end
    end
end

assign pll_locked_o = (config_error)? 1'bx : lock_enable;


////////////////////////////////////////////////////////////////////////
///////////////////////////////clk output period calculation////////////
real pll_core_period =20.0;
real dco_period = 20.0;
real dco_out_period = 20.0;
real corediv_mux_period = 20.0;
real N1, N2, N3, N4;

always @(posedge  lock_enable) begin
    //////////////////////////////////////
    //expected DCO frequency
    /////////////////////////////////////
    //N2
    case(c_main_div_n2_i)
        2'b00: N2  = 2.0;
        2'b01: N2  = 3.0;
        2'b10: N2  = 4.0;
        default:N2 = 5.0;
    endcase
    //N3
    case(c_main_div_n3_i)
        2'b00: N3  = 2.0;
        2'b01: N3  = 3.0;
        2'b10: N3  = 4.0;
        default:N3 = 5.0;
    endcase
    //N1
    case(c_main_div_n1_i)
        1'b0: N1  = 1.0;
        default:N1 = 2.0;
    endcase

	case(c_main_div_n4_i)
        2'b00: N4  = 1.0;
        2'b01: N4  = 2.0;
        2'b10: N4  = 3.0;
        default:N4 = 4.0;
    endcase


    dco_period =ref_period/(N1*N2*N3*N4);


    //////////////////////////////////////////
    //expected 8 phase DCO output frequency
    /////////////////////////////////////////
    if(c_out_div_sel_sig==2'b00) begin
        dco_out_period = dco_period;
    end
    else if(c_out_div_sel_sig==2'b01) begin
        dco_out_period = dco_period*2.0;
    end
    else if(c_out_div_sel_sig==2'b10) begin
        dco_out_period = dco_period*4.0;
    end
    else if(c_out_div_sel_sig==2'b11) begin
        dco_out_period = dco_period*8.0;
    end

    //////////////////////////////////////////
    //COREDIV
    /////////////////////////////////////////
    if(c_div_core_mux_sel == 1'b0) begin
        corediv_mux_period = dco_period ;
    end
    else begin
        corediv_mux_period = dco_out_period;
    end

    if(c_divcore_sel_sig == 2'b00) begin
       pll_core_period = corediv_mux_period;
    end
    else if(c_divcore_sel_sig == 2'b01) begin
       pll_core_period = corediv_mux_period*3.0;
    end
    else if(c_divcore_sel_sig == 2'b10) begin
       pll_core_period = corediv_mux_period*5.0;
    end
    else if(c_divcore_sel_sig == 2'b11) begin
       pll_core_period = corediv_mux_period*10.0;
    end
end



////////////////////////////////////////////////////////////////////////
///////////////////////////////clk core///////////////////////////////
reg clk_core = 1'b0;

always #(pll_core_period/2.0) clk_core =!clk_core;
assign clk_core_o = (c_ref_bypass_i || testmode_i) ? ref_clk_i: (lock_enable && !config_error)? clk_core:(config_error)?1'bx:1'b0;



////////////////////////////////////////////////////////////////////////
///////////////////////////////dco clock phases/////////////////////////
reg dco_clk_phase_0 = 1'b1;
always #(dco_out_period/2.0) dco_clk_phase_0 =!dco_clk_phase_0;


assign                       dco_clk_o[7] = (enable_delay && !config_error)?dco_clk_phase_0:(config_error)?1'bx:1'b1;
assign #(dco_out_period/8.0) dco_clk_o[6] = (enable_delay)?dco_clk_o[7]:1'b1;
assign #(dco_out_period/8.0) dco_clk_o[5] = (enable_delay)?dco_clk_o[6]:1'b1;
assign #(dco_out_period/8.0) dco_clk_o[4] = (enable_delay)?dco_clk_o[5]:1'b1;
assign #(dco_out_period/8.0) dco_clk_o[3] = (enable_delay)?dco_clk_o[4]:1'b0;
assign #(dco_out_period/8.0) dco_clk_o[2] = (enable_delay)?dco_clk_o[3]:1'b0;
assign #(dco_out_period/8.0) dco_clk_o[1] = (enable_delay)?dco_clk_o[2]:1'b0;
assign #(dco_out_period/8.0) dco_clk_o[0] = (enable_delay)?dco_clk_o[1]:1'b0;


assign clk_tx_o[0] = dco_clk_o[3];
assign clk_tx_o[1] = dco_clk_o[7];

////////////////////////////////////////////////////////////////////////
///////////////////////////////status output///////////////////////////
wire                         ack_ctrl;
wire                         ack_bisc;
wire                         adpll_status_capture_pulse;
reg                          r_adpll_status_ack;
reg [ADPLL_STATUS_BITS-1:0]  r_adpll_status = 0;




common_sync_pedge i_status_read_sync_pedge (
            .clk_i(ref_clk_i),
            .reset_n_i(reset_q_i),
            .data_i(adpll_status_capture_i),
            .data_o(),
            .data_pedge_o(adpll_status_capture_pulse));

common_sync i_status_ack_sync (
			.clk_i(ref_clk_i),
			.reset_n_i(reset_q_i),
			.data_i(r_adpll_status_ack || (!en_adpll_ctrl_i)),
			.data_o(adpll_status_ack_o));


always @(posedge ref_clk_i or negedge reset_q_i) begin
    if (reset_q_i == 1'b0)	begin
        r_adpll_status_ack <= 1'b0;
        r_adpll_status <= 0;
    end
    else begin
    if 	(adpll_status_capture_pulse==1'b1) begin
            r_adpll_status_ack <= 1'b1;
            r_adpll_status[0] <= lock_enable;
    end
        else begin
            r_adpll_status_ack <= 1'b0;
        end // else: !if(adpll_status_capture_pulse==1'b1)
	end
end

 assign adpll_status_o = (config_error) ? {ADPLL_STATUS_BITS{1'bx}} : r_adpll_status;


//////////////////////////////////////////////////////
//////////////////////////not used outputs///////////
assign pfd_o = 1'b0;


////////////////////////////////////////////////////////////////////////
///////////////////////////////config analysis part/////////////////////
always @(*) begin
    config_error = 1'b0;
    if(c_open_loop_sig == 1'b1) begin
        $display("PLL Warning %m: Open Loop mode not supported in simplified PLL behavioral.");
        config_error = 1'b1;
    end
    if(lock_enable === 1'b1) begin
        if(cp_sig < ci_sig) begin
            $display("PLL Warning %m: Proportional Filter Value is less than Integral Value.");
            config_error = 1'b1;
        end

        if(c_disable_lock_sig == 1'b1) begin
            $display("PLL Warning %m: Lock bit forced to zero.");
            config_error = 1'b1;
        end
        if(c_bist_mode_sig == 1'b1) begin
            $display("PLL Warning %m: BIST mode not supported in simplified PLL behavioral.");
            config_error = 1'b1;
        end
        if(c_ct_compensation_sig == 1'b1) begin
            $display("PLL Warning %m: Coarsetune compensation not supported in simplified PLL behavioral.");
            config_error = 1'b1;
        end
        if(dco_period < 0.3 || dco_period > 3.5) begin
            $display("PLL Warning %m: DCO frequency is out of specification");
            config_error = 1'b1;
        end
        if((1/ref_period)*N3*N4 > 0.5) begin
             $display("PLL Warning %m: Invalid config: fref*N3*N4>500MHz");
            config_error = 1'b1;
        end
    end
end



always @(c_ci_i or c_cp_i or c_main_div_n1_i or c_main_div_n2_i or c_main_div_n3_i or c_main_div_n4_i or c_out_div_sel_i or c_open_loop_i or c_ft_i or c_divcore_sel_i or
         c_coarse_i or c_coarse_i or c_bist_mode_i or c_auto_coarsetune_i or c_enforce_lock_i or c_pfd_select_i or c_lock_window_sel_i or c_div_core_mux_sel_i or c_filter_shift_i or
         c_en_fast_lock_i or c_sar_limit_i or c_sar_limit_i or c_set_op_lock_i or c_disable_lock_i or c_ref_bypass_i) begin
        if (en_adpll_ctrl_i == 1'b1) begin
            $display("PLL Warning %m: configuration changed during enabled PLL--> not allowed");
        end
end


////////////////////////////////////////////////////////////////////
//////BIST behavioral//////////////////////////////////////////////

assign bist_busy_o = 1'b0;
assign bist_fail_coarse_o = 1'b0;
assign bist_fail_fine_o = 1'b0;


///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////specifies for netlist simulation////////////////////

`ifndef RI_PLL_FUNCTIONAL
    reg notifier;
    specify
        (en_adpll_ctrl_i => adpll_status_ack_o) = (1.0, 1.0);

        (scan_clk_i       => scan_out_o[0])         = (1.0, 1.0);
        (scan_clk_i       => scan_out_o[1])         = (1.0, 1.0);
        (scan_clk_i       => scan_out_o[2])         = (1.0, 1.0);

        (ref_clk_i       => pll_locked_o)       = (1.0, 1.0);
        (ref_clk_i       => adpll_status_ack_o) = (1.0, 1.0);
        (ref_clk_i       => adpll_status_o)     = (1.0, 1.0);

        $setup(en_adpll_ctrl_i,        posedge ref_clk_i, 1.0, notifier);
        $setup(adpll_status_capture_i, posedge ref_clk_i, 1.0, notifier);

        $recovery(reset_q_i, posedge ref_clk_i, 1.0, notifier);
        $width(posedge ref_clk_i, 1.0, 0, notifier);
        $width(negedge ref_clk_i, 1.0, 0, notifier);
    endspecify
`endif



endmodule
`endcelldefine
