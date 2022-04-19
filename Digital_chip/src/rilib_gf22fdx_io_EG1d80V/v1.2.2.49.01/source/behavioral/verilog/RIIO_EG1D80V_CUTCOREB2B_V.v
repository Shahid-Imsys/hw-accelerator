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
module RIIO_EG1D80V_CUTCOREB2B_V(
	
`ifdef USE_PG_PIN

		VDDIO,
		VSSIO,
		VSS_L,
		VSS_R
`endif// USE_PG_PIN		
		);


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
    (* integer inh_conn_prop_name = "vss_l";
       integer inh_conn_def_value = "cds_globals.\\VSS_L! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSS_L;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vss_r";
       integer inh_conn_def_value = "cds_globals.\\VSS_R! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSS_R;
`endif// USE_PG_PIN		

endmodule
`endcelldefine
