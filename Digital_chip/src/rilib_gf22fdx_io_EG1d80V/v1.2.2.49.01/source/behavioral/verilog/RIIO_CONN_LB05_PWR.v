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
module RIIO_CONN_LB05_PWR(
	        SIG
`ifdef USE_PG_PIN
		, VDD
`endif// USE_PG_PIN
		);


inout SIG;

`ifdef USE_PG_PIN
	// supply
inout 
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer inh_conn_prop_name = "vdd";
       integer inh_conn_def_value = "cds_globals.\\VDD! "; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDD;
`endif// USE_PG_PIN


`ifdef USE_PG_PIN
   tran conn(VDD, SIG);
`else
   assign SIG=1'b1;
`endif
  
endmodule
`endcelldefine
