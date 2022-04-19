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
// Last Change       :   $Date: 2020-08-20 10:35:38 +0200 (Thu, 20 Aug 2020) $
// by                :   $Author: henker $                  			
// ------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RIIO_EG1D80V_IBIAS_HVT28_H(
		EN_IBIAS_I,
		EN_VBIAS_I,
		BG_STARTUP_I,
		TRIM_IBIAS_I,
		TRIM_VBIAS_I,
		BG_VALID_O,
		IBIAS_N_5D0U_O,
		IBIAS_P_2D5U_O,
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
  EN_IBIAS_I;
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
input   [4:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TRIM_IBIAS_I;
input   [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  TRIM_VBIAS_I;

output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  BG_VALID_O;
output [15:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* /* not supply sensititve */
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  IBIAS_N_5D0U_O;
output [4:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   /* not ground sensititve */ *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  IBIAS_P_2D5U_O;

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




// startup might disturb the bandgap operation
wire bg_valid;
assign bg_valid = (EN_IBIAS_I || EN_VBIAS_I) && !BG_STARTUP_I;

assign BG_VALID_O = bg_valid;

// ibias_n are a nmos current sources referenced at vssio
assign IBIAS_N_5D0U_O = (bg_valid && EN_IBIAS_I) ? 16'b0000000000000000 : 16'bzzzzzzzzzzzzzzzz;
// ibias_p are a pmos current sources referenced at vddio
assign IBIAS_P_2D5U_O = (bg_valid && EN_IBIAS_I) ?  5'b11111            :  5'bzzzzz;

// drive vbias only when enabled
assign VBIAS          = (bg_valid && EN_VBIAS_I) ? 1'b1 : 1'bz;

endmodule
`endcelldefine
