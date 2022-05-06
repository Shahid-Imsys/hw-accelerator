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
// Last Change       :   $Date: 2019-08-01 12:20:04 +0200 (Thu, 01 Aug 2019) $
// by                :   $Author: henker $                  			
// ------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RIIO_EG3D30V_ANAIO_V_func (
    .PAD_B(pad_rx),     // shortcircuit all pins

    .VESD0_B(pad_rx),
    .VESD1_B(pad_rx),
    .VESD2_B(pad_rx),
    .VESD3_B(pad_rx),

    .VRES0_B(pad_rx),
    .VRES1_B(pad_rx),
    .VRES2_B(pad_rx),
    .VRES3_B(pad_rx)
);
    inout pad_rx;
endmodule
`endcelldefine

`celldefine
module RIIO_EG3D30V_ANAIO_V(
		  PAD_B
		
		, VESD0_B
		, VESD1_B
		, VESD2_B
		, VESD3_B
		
		, VRES0_B
		, VRES1_B
		, VRES2_B
		, VRES3_B
	
`ifdef USE_PG_PIN
		
		, VDDIO
		, VSSIO
		, VDD
		, VSS
`endif// USE_PG_PIN
		);
	// PAD
inout  	PAD_B;

	// core
inout  	VESD0_B;
inout  	VESD1_B;
inout  	VESD2_B;
inout  	VESD3_B;

inout  	VRES0_B;
inout  	VRES1_B;
inout  	VRES2_B;
inout  	VRES3_B;

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

    RIIO_EG1D80V_ANAIO_V_func i_func (
        .PAD_B   (PAD_B),

        .VESD0_B (VESD0_B),
        .VESD1_B (VESD1_B),
        .VESD2_B (VESD2_B),
        .VESD3_B (VESD3_B),

        .VRES0_B (VRES0_B),
        .VRES1_B (VRES1_B),
        .VRES2_B (VRES2_B),
        .VRES3_B (VRES3_B)
    );

endmodule
`endcelldefine
