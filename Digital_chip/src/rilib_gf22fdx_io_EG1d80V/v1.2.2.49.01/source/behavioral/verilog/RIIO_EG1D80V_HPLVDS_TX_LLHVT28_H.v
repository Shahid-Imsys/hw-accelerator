`timescale 1ns/10ps
`celldefine
module RIIO_EG1D80V_HPLVDS_TX_LLHVT28_H (
	
		// PADS
		A_PAD_B,
		B_PAD_B
	
		//HPLVDS
		, DO_I
		, DI_O

		, EI_DETECT_EN_I
		, EI_DETECT_O

		, RTERM_EN_I
		, RTERM_TRIM_I

		, RX_EN_I
		, RX_POL_I
		, RX_VCM_EN_I
		, RX_GAIN_I
		, RX_CTLE_RES_I
		, RX_CTLE_CAP_I

		, TX_EN_I
		, TX_EI_I
		, TX_POL_I
		, TX_BIAS_I
		, TX_BIAS_OD_I
		, TX_VCM_EN_I
		, TX_VCM_I
	
		, VBIAS
	
`ifdef USE_PG_PIN
		, VDDIO
		, VSSIO
		, VDD
		, VSS
`endif// USE_PG_PIN
);

	// PADS
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_PAD_B;
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_PAD_B;
	
	//HPLVDS
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DO_I;            // data to write on pads
output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DI_O;            // data read from pads

input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  EI_DETECT_EN_I;  // enable EI detector
output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  EI_DETECT_O;     // EI detected on pads

input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RTERM_EN_I;      // enable termination resistor between pads
input  [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RTERM_TRIM_I;    // rterm trimming

input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RX_EN_I;         // enable receiver
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RX_POL_I;        // receiver polarity
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RX_VCM_EN_I;     // enable receiver common mode (when ac coupled)
input [3:1]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RX_GAIN_I;        // receiver gain setting
input [7:1]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RX_CTLE_RES_I;    // receiver ctle resistor setting
input [3:1]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  RX_CTLE_CAP_I;    // receiver ctle capacitor setting

input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_EN_I;         // enable transmitter
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_EI_I;         // force electrical idle on pads
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_POL_I;        // transmitter polarity
input [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_BIAS_I;       // transmitter bias setting
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_BIAS_OD_I;    // transmitter bias 2x overdrive
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_VCM_EN_I;    // enable transmitter vcm by connecting termination resistors to VDD
input [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TX_VCM_I;       //  transmitter vcm setting


inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer inh_conn_prop_name = "vbias";
  integer inh_conn_def_value = "cds_globals.\\VBIAS! ";
  integer supplySensitivity = "VDDIO";
  integer groundSensitivity = "VSSIO";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VBIAS;


`ifdef USE_PG_PIN
	// supply
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vddio";
       integer inh_conn_def_value = "cds_globals.\\VDDIO! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDDIO;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vssio";
       integer inh_conn_def_value = "cds_globals.\\VSSIO! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSSIO;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vdd";
       integer inh_conn_def_value = "cds_globals.\\VDD! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDD;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vss";
       integer inh_conn_def_value = "cds_globals.\\VSS! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSS;
`endif// USE_PG_PIN

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//BEHAVIORAL MODEL
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


// RTERM
assign (highz1, weak0) A_PAD_B = ~RTERM_EN_I;
assign (highz1, weak0) B_PAD_B = ~RTERM_EN_I;


// TX                                                 disabled             no bias                   idle   normal operation
assign A_PAD_B = (TX_EN_I!=1'b1 || TX_VCM_EN_I!=1'b1) ? 1'bz : VBIAS!==1'b1 ? 1'b1 : TX_EI_I==1'b1 ? 1'b0 : ~DO_I ^ TX_POL_I;
assign B_PAD_B = (TX_EN_I!=1'b1 || TX_VCM_EN_I!=1'b1) ? 1'bz : VBIAS!==1'b1 ? 1'b1 : TX_EI_I==1'b1 ? 1'b0 :  DO_I ^ TX_POL_I;

// RX, EIDETECT
reg rx_data, rx_ei_detect;
always @(A_PAD_B or B_PAD_B) begin
   rx_data     =1'b0;
   rx_ei_detect=1'b0;
   casez( {A_PAD_B, B_PAD_B})
   2'b00: rx_ei_detect=1'b1; // idle
   2'b01: rx_data=1'b0;      // normal op
   2'b10: rx_data=1'b1;      // normal op
   2'bzz: rx_data=1'bx;      // garbage
   endcase
end
assign DI_O        = (rx_data ^ RX_POL_I) & RX_EN_I;
assign EI_DETECT_O = rx_ei_detect         & EI_DETECT_EN_I;

endmodule
`endcelldefine
