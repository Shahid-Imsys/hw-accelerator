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
module RIIO_EG1D80V_POR_IO_V1D0_V(
	
		  POR_N_CORE_O
	
`ifdef USE_PG_PIN
		, VDDIO
		, VSSIO
		, VDD
		, VSS
		, VDDIO_POR
		, VSSIO_POR
		, VDD_POR
		, VSS_POR
`endif// USE_PG_PIN
);

	
	//outputs
output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD_POR";
	   integer groundSensitivity = "VSS_POR"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  POR_N_CORE_O;



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
  
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vddio_por";
       integer inh_conn_def_value = "cds_globals.\\VDDIO_POR! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDDIO_POR;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vssio_por";
       integer inh_conn_def_value = "cds_globals.\\VSSIO_POR! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSSIO_POR;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vdd_por";
       integer inh_conn_def_value = "cds_globals.\\VDD_POR! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDD_POR;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vss_por";
       integer inh_conn_def_value = "cds_globals.\\VSS_POR! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSS_POR;
  
`endif// USE_PG_PIN


//////////////////////////////////////////////////////////
//MODEL
//////////////////////////////////////////////////////////

parameter DELAY = 20;

wire rst;
assign #(DELAY) rst = 1'b0;

assign POR_N_CORE_O = (rst===1'b0) ? 1'b1 : 1'b0;

endmodule
`endcelldefine
