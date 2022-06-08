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
module RIIO_EG1D80V_ESD_B2B_010x046(

`ifdef USE_PG_PIN
		  SUB
		, VSS
		, VSSX
`endif// USE_PG_PIN
		
);

`ifdef USE_PG_PIN
inout           
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer inh_conn_prop_name = "sub";
  integer inh_conn_def_value = "cds_globals.\\SUB! ";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  SUB;
inout           
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer inh_conn_prop_name = "vss";
  integer inh_conn_def_value = "cds_globals.\\VSS! ";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSS;
inout           
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer inh_conn_prop_name = "vssx";
  integer inh_conn_def_value = "cds_globals.\\VSSX! ";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSSX;

`endif// USE_PG_PIN


endmodule
`endcelldefine
