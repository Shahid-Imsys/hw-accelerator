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
module RIIO_EG1D80V_CUTIOB2B_H(
	
`ifdef USE_PG_PIN
		VSSIO_L,
		VSSIO_R,
		VDD,
		VSS
`endif// USE_PG_PIN		
		);


`ifdef USE_PG_PIN
	// supply
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vssio_l";
       integer inh_conn_def_value = "cds_globals.\\VSSIO_L! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSSIO_L;
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vssio_r";
       integer inh_conn_def_value = "cds_globals.\\VSSIO_R! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSSIO_R;
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
