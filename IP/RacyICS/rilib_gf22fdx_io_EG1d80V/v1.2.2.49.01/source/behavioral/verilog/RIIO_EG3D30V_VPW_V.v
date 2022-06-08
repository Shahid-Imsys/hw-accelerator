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
// Last Change       :   $Date: 2019-02-26 15:19:35 +0100 (Tue, 26 Feb 2019) $
// by                :   $Author: henker $                  			
// ------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RIIO_EG3D30V_VPW_V(
	
`ifdef USE_PG_PIN
		VPW,
	
		VDDIO,
		VSSIO,
		VDD,
		VSS
`endif// USE_PG_PIN
		);

`ifdef USE_PG_PIN
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vpw";
       integer inh_conn_def_value = "cds_globals.\\VPW! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VPW;

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


endmodule
`endcelldefine
