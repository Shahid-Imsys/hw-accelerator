// Company          :   Racyics GmbH
// Author           :   
// E/Mail           :   
//
// Filename         :   rterm_calib.v
// Project Name     :   p_ri
// Subproject Name  :   s_libio_gf22fdsoi
// Description      :   Termination Resistor Calibration
//                      for RIIO_EG1D80V_RTERMCAL_V/H
// Create Date      :   Fri Dec 29 12:59:38 2017
// Last Change      :   
// by               :   
//------------------------------------------------------------
// Version   |  Author    |  Date         |  Comment
// -----------------------------------------------------------
// 1.1       | schreiter  | 03 Feb 2018   |  checked version
// -----------------------------------------------------------
//
//------------------------------------------------------------
module rterm_calib (
		    clk_ref_i,
		    reset_n_i,

		    calib_en_i,
		    calib_done_o,

		    calib_lvds_ovr_i,
		    calib_lvds_val_i,
		    calib_lvds_cal_o,

		    calib_c2c_ovr_i,
		    calib_c2c_val_i,
		    calib_c2c_cal_b_o,
		    calib_c2c_cal_t_o,

		    rtermcal_result_i,
		    rtermcal_d_iosg_o,
		    rtermcal_d_lvds_o,
		    rtermcal_mode_o
		    );
   
   //====== IOs ==========================================================
   // synchronous interface to reg file.
   // static control vectors for instances of C2C/SG-IO cells and HS-LVDS cells.
   input          clk_ref_i;		// reg file clock
   input 	  reset_n_i;
   
   // from/to regfile (RF) and to IO cell instances (I) using the calibration value
   input 	  calib_en_i;        // <-RF enable calibration, continuous tracking
   output 	  calib_done_o;	     // ->RF calibration done
   
   input 	  calib_lvds_ovr_i;  // <-RF enable override for hs-lvds termination trimming
   input [3:0] 	  calib_lvds_val_i;  // <-RF override value for hs-lvds termination, binary coded
   output [3:0]   calib_lvds_cal_o;  // ->RF, ->I final value for hs-lvds termination, binary coded

   input 	  calib_c2c_ovr_i;   // <-RF enable override for C2C termination trimming
   input [3:0] 	  calib_c2c_val_i;   // <-RF override value for C2C termination, binary coded
   output [3:0]   calib_c2c_cal_b_o; // ->RF calibration value for C2C termination, reg-file read-back, binary coded
                                     // ATTENTION: NOT TO INSTANCES -> NO OVERRIDE
   output [15:1]  calib_c2c_cal_t_o; // ->I  calibration value for C2C termination, instances, thermometer coded
   reg [15:1] 	  calib_c2c_cal_t_o;
   
   
   // from/to RTEMCAL custom macro (RIIO_EG1D80V_RTERMCAL_V/H)
   // asynchronous interface to RIIO_EG1D80V_RTERMCAL_V/H instance
   input [1:0] 	  rtermcal_result_i; // ==1'b0 decrement / ==1'b1 increment code
   output [15:1]  rtermcal_d_iosg_o; // C2C (SG-IO) current calibration value, thermometer coded
   reg [15:1] 	  rtermcal_d_iosg_o;
   output [3:0]   rtermcal_d_lvds_o; // HS-LVDS current calibration value, binary coded
   reg [3:0] 	  rtermcal_d_lvds_o;
   output [1:0]   rtermcal_mode_o;   // [0]: sgio trimming mode enable, precedence over [1]: lvds trimming mode enable
   reg [1:0] 	  rtermcal_mode_o;
   
   
   
   //====== Parameter ====================================================
   localparam S_RESET  = 2'd0;
   localparam S_WAIT   = 2'd1;
   localparam S_SAR    = 2'd2;

   localparam P_WAIT_C2C  = 30;
   localparam P_WAIT_LVDS = 31;
   localparam P_SETTLE_C2C    = 50;
   localparam P_SETTLE_LVDS   = 50;
   
   //====== Internal Signals =============================================
   
   // FSM
   reg [1:0] 	  state_r;                            // current state
   reg [1:0] 	  state_nxt;                       // next state; combinational
   reg [3:0] 	  shift_r;                            // shift reg for SAR
   reg [3:0] 	  shift_nxt;		              // shift reg for SAR
   reg 		  trim_lvds_not_sgio_r;		      // 0: C2C/sgio, 1: HS-LVDS
   reg            trim_lvds_not_sgio_nxt;

   // stuff
   reg [1:0] 	  rtermcal_result_0_sync_r; // synchronizer for full custom comparator result 
   reg [1:0] 	  rtermcal_result_1_sync_r; // synchronizer for full custom comparator result 
   reg [7:0] 	  counter_r;			      // counter for wait loops.
   reg            counter_set;
   reg 		  sar_complete_s;
   wire           sar_comparator_s;
   reg 		  calib_done_r;	     // ->RF calibration done

   // calibration
   reg [3:0] 	  val_r;   // current calibration value, SAR data register
   reg [3:0] 	  val_nxt;
   
   reg [3:0] 	  cal_c2c_r;		// calibration result register for C2C/SG-IO trimming
   reg [3:0] 	  cal_lvds_r;		// calibration result register for HS-LVDS trimming
   
   wire [3:0] 	  cal_c2c_s;		// calibration result for C2C/SG-IO trimming
   wire [3:0] 	  cal_lvds_s;		// calibration result for HS-LVDS trimming

   reg [3:0] 	  val_c2c_s;		// calibration value for C2C/SG-IO trimming
   
   //====== Synchronizer =================================================
   always@(posedge clk_ref_i or negedge reset_n_i) begin
      if(reset_n_i == 1'b0) begin
	 rtermcal_result_0_sync_r <= 2'b0;
	 rtermcal_result_1_sync_r <= 2'b0;
      end
      else begin
	 rtermcal_result_0_sync_r <= {rtermcal_result_0_sync_r[0], rtermcal_result_i[0]};
	 rtermcal_result_1_sync_r <= {rtermcal_result_1_sync_r[0], rtermcal_result_i[1]};
      end
   end

   // comparator selection mux
   assign sar_comparator_s = trim_lvds_not_sgio_r==1'b1 ? ~rtermcal_result_1_sync_r[1] : ~rtermcal_result_0_sync_r[1];

   //====== FSM & SAR regs ===============================================
   always@(posedge clk_ref_i or negedge reset_n_i) begin
      if(reset_n_i == 1'b0) begin
	 state_r              <= S_RESET;
	 shift_r              <= 4'b0;
	 val_r                <= 4'b0;
	 trim_lvds_not_sgio_r <= 1'b0;
      end
      else begin
	 state_r              <= state_nxt;
	 shift_r              <= shift_nxt;
	 val_r                <= val_nxt;
	 trim_lvds_not_sgio_r <= trim_lvds_not_sgio_nxt;	 
      end
   end
   
   always@(state_r or shift_r or val_r or trim_lvds_not_sgio_r or calib_en_i or counter_r or sar_comparator_s) begin
      state_nxt = state_r;
      shift_nxt = shift_r;
      trim_lvds_not_sgio_nxt = trim_lvds_not_sgio_r;
      counter_set = 1'b0;
      sar_complete_s = 1'b0;
      val_nxt = val_r;

      case(state_r)
	S_RESET : if(calib_en_i == 1'b1) begin
	   state_nxt = S_WAIT;
	   counter_set = 1'b1;
	   trim_lvds_not_sgio_nxt = 1'b0;
	   val_nxt = 4'b1000;
        end

	S_WAIT : begin
	   if( counter_r == 8'b0) begin
	      state_nxt = S_SAR;
	      counter_set = 1'b1;
	   end
	   shift_nxt = 4'b1000;
	   val_nxt = 4'b1000;
	end
	
	S_SAR : if( counter_r == 8'b0) begin // Settling time done
	   counter_set = 1'b1;
	   if( shift_r == 4'b0001) begin // SAR complete
	      sar_complete_s = 1'b1;
	      trim_lvds_not_sgio_nxt = ~trim_lvds_not_sgio_r;
	      if( calib_en_i==1'b1 || trim_lvds_not_sgio_r==1'b0) begin
		 val_nxt = 4'b1000;
		 state_nxt = S_WAIT;
	      end
	      else begin
		 state_nxt = S_RESET;
		 counter_set = 1'b0;
	      end
	   end
	   else begin
	      shift_nxt = {1'b0, shift_r[3:1]};
	      val_nxt = (val_r & (~shift_r | {4{sar_comparator_s}})) | shift_nxt;
	   end
	end // if ( counter_r == 8'b0)

	default : state_nxt = S_RESET;
      endcase
   end

   //====== TIMER / COUNTER
   always @(posedge clk_ref_i or negedge reset_n_i) begin
      if( reset_n_i==1'b0) begin
	 counter_r <= 8'b0;
      end
      else begin
	 if( counter_set==1'b1)begin
	    if( state_nxt==S_WAIT) begin
	       counter_r <= trim_lvds_not_sgio_r==1'b0 ? P_WAIT_C2C : P_WAIT_LVDS;
	    end
	    else if( state_nxt==S_SAR) begin
	       counter_r <= trim_lvds_not_sgio_r==1'b0 ? P_SETTLE_C2C : P_SETTLE_LVDS;
	    end
	 end
	 else if( counter_r!=8'b0) begin
	    counter_r <= counter_r - 8'd1;
	 end
      end // else: !if( reset_n_i==1'b0)
   end // always @ (posedge clk_ref_i or negedge reset_n_i)
   

   // ======= CALIBRATION RESULT REGISTERS
   always@(posedge clk_ref_i or negedge reset_n_i) begin
      if(reset_n_i == 1'b0) begin
	 cal_c2c_r <= 4'b1000;
	 cal_lvds_r <= 4'b1000;
      end
      else begin
	 if( sar_complete_s==1'b1) begin
	    if( trim_lvds_not_sgio_r==1'b0) begin
	       cal_c2c_r <= {val_r[3:1], sar_comparator_s};
	    end
	    else begin
	       cal_lvds_r <= {val_r[3:1], sar_comparator_s};
	    end
	 end
      end // else: !if(reset_n_i == 1'b0)
   end // always@ (posedge clk_ref_i or negedge reset_n_i)

   assign cal_c2c_s  = calib_c2c_ovr_i ==1'b1 ? calib_c2c_val_i : cal_c2c_r;
   assign cal_lvds_s = calib_lvds_ovr_i==1'b1 ? calib_lvds_val_i : cal_lvds_r;

   // completion flag
   always @(posedge clk_ref_i or negedge reset_n_i) begin
      if( reset_n_i == 1'b0) begin
	 calib_done_r <= 1'b0;
      end
      else begin
	 if( state_nxt == S_RESET)
	   calib_done_r <= 1'b0;
	 else if( sar_complete_s==1'b1 && trim_lvds_not_sgio_r==1'b1)
	   calib_done_r <= 1'b1;
      end
   end // always @ (posedge clk_ref_i or negedge reset_n_i)
   

   
   //====== set outputs  =================================================

   assign calib_done_o = calib_done_r;
   assign calib_lvds_cal_o = cal_lvds_s;
   assign calib_c2c_cal_b_o = cal_c2c_r;
   
   always@(cal_c2c_s) begin
      case(cal_c2c_s)
	4'b0000 : calib_c2c_cal_t_o = 15'h0000;
	4'b0001 : calib_c2c_cal_t_o = 15'h0001;
	4'b0010 : calib_c2c_cal_t_o = 15'h0003;
	4'b0011 : calib_c2c_cal_t_o = 15'h0007;
	4'b0100 : calib_c2c_cal_t_o = 15'h000F;
	4'b0101 : calib_c2c_cal_t_o = 15'h001F;
	4'b0110 : calib_c2c_cal_t_o = 15'h003F;
	4'b0111 : calib_c2c_cal_t_o = 15'h007F;
	4'b1000 : calib_c2c_cal_t_o = 15'h00FF;
	4'b1001 : calib_c2c_cal_t_o = 15'h01FF;
	4'b1010 : calib_c2c_cal_t_o = 15'h03FF;
	4'b1011 : calib_c2c_cal_t_o = 15'h07FF;
	4'b1100 : calib_c2c_cal_t_o = 15'h0FFF;
	4'b1101 : calib_c2c_cal_t_o = 15'h1FFF;
	4'b1110 : calib_c2c_cal_t_o = 15'h3FFF;
	default : calib_c2c_cal_t_o = 15'h7FFF;
      endcase
   end // always@ (cal_c2c_s)
   
   always @(state_r or trim_lvds_not_sgio_r or val_r or cal_c2c_r) begin
      if( (state_r==S_WAIT || state_r==S_SAR) && trim_lvds_not_sgio_r==1'b0)
	val_c2c_s = val_r;
      else
	val_c2c_s = cal_c2c_r;
   end
   always@(val_c2c_s) begin
      case(val_c2c_s)
	4'b0000 : rtermcal_d_iosg_o = 15'h0000;
	4'b0001 : rtermcal_d_iosg_o = 15'h0001;
	4'b0010 : rtermcal_d_iosg_o = 15'h0003;
	4'b0011 : rtermcal_d_iosg_o = 15'h0007;
	4'b0100 : rtermcal_d_iosg_o = 15'h000F;
	4'b0101 : rtermcal_d_iosg_o = 15'h001F;
	4'b0110 : rtermcal_d_iosg_o = 15'h003F;
	4'b0111 : rtermcal_d_iosg_o = 15'h007F;
	4'b1000 : rtermcal_d_iosg_o = 15'h00FF;
	4'b1001 : rtermcal_d_iosg_o = 15'h01FF;
	4'b1010 : rtermcal_d_iosg_o = 15'h03FF;
	4'b1011 : rtermcal_d_iosg_o = 15'h07FF;
	4'b1100 : rtermcal_d_iosg_o = 15'h0FFF;
	4'b1101 : rtermcal_d_iosg_o = 15'h1FFF;
	4'b1110 : rtermcal_d_iosg_o = 15'h3FFF;
	default : rtermcal_d_iosg_o = 15'h7FFF;
      endcase
   end // always@ (val_c2c_s)
   
   always @(state_r or trim_lvds_not_sgio_r or val_r or cal_lvds_r) begin
      if( (state_r==S_WAIT || state_r==S_SAR) && trim_lvds_not_sgio_r==1'b1)
	rtermcal_d_lvds_o = val_r;
      else
	rtermcal_d_lvds_o = cal_lvds_r;
   end
   
   always @(state_r or trim_lvds_not_sgio_r) begin
      if( state_r==S_WAIT || state_r==S_SAR)
	rtermcal_mode_o = {trim_lvds_not_sgio_r, ~trim_lvds_not_sgio_r};
      else
	rtermcal_mode_o = 2'b0;
   end
	
endmodule
