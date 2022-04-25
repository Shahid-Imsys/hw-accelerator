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
// Last Change       :   $Date: 2018-12-15 22:47:59 +0100 (Sat, 15 Dec 2018) $
// by                :   $Author: henker $                  			
// ------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RIIO_EG1D80V_GPI_PD_HVT28_V (
	
		// PAD
		PAD_B
	
		//GPI
		, IE_I
		, STE_I
		, DI_O
	
`ifdef USE_PG_PIN
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
	
	//GPI
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  IE_I;
input   [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  STE_I;
output  [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DI_O;


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

//////////////////////////////////////////////////////////
//GPI 

//input receiver with PD
wire pd;
wire PAD_B_rx;

pulldown(pd);
nmos PDEN(PAD_B,pd,1'b1);

assign PAD_B_rx = PAD_B;


assign DI_O[0] = (PAD_B_rx&IE_I);
assign DI_O[1] = (PAD_B_rx&IE_I);

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//TIMING ANNOTATION
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
specify
	
	//GPI
	(PAD_B => DI_O[0])=(0,0);
	(PAD_B => DI_O[1])=(0,0);
	(IE_I => DI_O[0])=(0,0);
	(IE_I => DI_O[1])=(0,0);
	
endspecify

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

endmodule
`endcelldefine
