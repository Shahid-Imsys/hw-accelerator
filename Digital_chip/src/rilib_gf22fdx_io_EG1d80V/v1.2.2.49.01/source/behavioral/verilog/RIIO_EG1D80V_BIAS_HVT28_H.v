// ------------------------------------------------------------
// Company           :   racyics                      
// Author            :   hocker            
// E-Mail            :   hocker@racyics.com                    
//                    			
// Filename          :                   
// Project Name      :   p_ri
// Subproject Name   :   s_libio_gf22fdsoi
// Description       :               
//
// Create Date       :   Fri Nov 4 10:53:47 2016 
// Last Change       :   $Date: 2020-08-16 19:52:53 +0200 (Sun, 16 Aug 2020) $
// by                :   $Author: henker $                  			
// ------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RIIO_EG1D80V_BIAS_HVT28_H(
		EN_I,
		EN_VBIAS_I,
		BG_STARTUP_I,
		TRIM_BIAS_I,
		TRIM_CURV_I,
		TRIM_VBG_I,
		BG_VALID_N_O,
		IBIAS_O,
		VBG_O,
		VTMP_O,
		VBIAS
`ifdef USE_PG_PIN
        ,
	
		VDDIO,
		VSSIO,
		VDD,
		VSS
`endif// USE_PG_PIN
		);
		
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  EN_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  EN_VBIAS_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  BG_STARTUP_I;
input   [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TRIM_BIAS_I;
input   [4:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TRIM_CURV_I;
input   [4:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TRIM_VBG_I;

output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  BG_VALID_N_O;
output [15:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  IBIAS_O;
output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VBG_O;
output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VTMP_O;

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




// startup does disturb the bandgap operation
wire bg_valid;
assign bg_valid = EN_I && !BG_STARTUP_I;

assign BG_VALID_N_O = !bg_valid;

// ibias are a nmos current sinks
assign IBIAS_O      = bg_valid ? 16'b0000000000000000 : 16'bzzzzzzzzzzzzzzzz;

assign VBG_O        = bg_valid ? 1'b1 : 1'b0;
assign VTMP_O       = bg_valid ? 1'b1 : 1'b0;

// drive vbias only when enabled
assign VBIAS        = EN_VBIAS_I ? bg_valid ? 1'b1 : 1'b0 : 1'bz;

endmodule
`endcelldefine
