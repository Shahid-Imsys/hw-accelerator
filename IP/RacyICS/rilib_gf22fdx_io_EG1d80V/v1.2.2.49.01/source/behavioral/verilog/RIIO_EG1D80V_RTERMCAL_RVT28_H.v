`celldefine
module RIIO_EG1D80V_RTERMCAL_RVT28_H(

		// PAD
		PAD_B

		//IO
		, D_IOSG_I
		, D_LVDS_I
		, MODE_I
		, RESULT_O

`ifdef USE_PG_PIN
		, VDDQ
		, VSSQ

		, VDDIO
		, VSSIO
		, VDD
		, VSS
`endif// USE_PG_PIN
);

	// PAD
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  PAD_B;

	// IO
output [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
   RESULT_O;
input [15:1]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
   D_IOSG_I;
input [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  D_LVDS_I;
input [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
   MODE_I;


`ifdef USE_PG_PIN
	// supply
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(* integer inh_conn_prop_name = "vddq";
   integer inh_conn_def_value = "cds_globals.\\VDDQ! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
 VDDQ;
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(* integer inh_conn_prop_name = "vssq";
   integer inh_conn_def_value = "cds_globals.\\VSSQ! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
 VSSQ;
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

localparam real res_nom_external = 200;
localparam real res_trim_nom     = 5000;
localparam real res_sgio_offset  = 20;
localparam real res_lvds_offset  = -10;

reg [1:0] RESULT_O;

real trim_val_sgio;
always @(MODE_I or D_IOSG_I) begin
	// 32elements (17 + 0..15), thermo
	trim_val_sgio = res_sgio_offset + 
		res_trim_nom /
		( 17+         D_IOSG_I[ 1]+ D_IOSG_I[ 2]+ D_IOSG_I[ 3]+
		D_IOSG_I[ 4]+ D_IOSG_I[ 5]+ D_IOSG_I[ 6]+ D_IOSG_I[ 7]+
		D_IOSG_I[ 8]+ D_IOSG_I[ 9]+ D_IOSG_I[10]+ D_IOSG_I[11]+
		D_IOSG_I[12]+ D_IOSG_I[13]+ D_IOSG_I[14]+ D_IOSG_I[15]);
	
	RESULT_O[0] = (MODE_I[0]==1'b1) && (trim_val_sgio < res_nom_external);
end

real trim_val_lvds;
always @(MODE_I or D_LVDS_I) begin
	// 32elements (17 + 0..15), binary
	trim_val_lvds = res_lvds_offset + 
		res_trim_nom / (17+ D_LVDS_I);
	
	RESULT_O[1] = (MODE_I[1]==1'b1) && (MODE_I[0]==1'b0) && (trim_val_lvds < res_nom_external);
end


endmodule
`endcelldefine
