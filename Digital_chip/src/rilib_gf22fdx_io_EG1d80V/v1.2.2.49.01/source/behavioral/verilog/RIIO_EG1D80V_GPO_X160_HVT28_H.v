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
module RIIO_EG1D80V_GPO_X160_HVT28_H (
	
		// PAD
		PAD_B
	
		//GPO
		, DO_I
		, DS_I
		, SR_I
		, CO_I
		, OE_I
		, ODP_I
		, ODN_I
	
		, VBIAS
	
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
	
	//GPO
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DO_I;
input  [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DS_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  SR_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  CO_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  OE_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  ODP_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  ODN_I;

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


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//BEHAVIORAL MODEL
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
//GPO 

//high-side and low-side PAD_B driver 
wire ls_en;
wire oe_valid;


assign oe_valid = OE_I && (DS_I[1:0] == 2'b00 || VBIAS===1'b1);
assign ls_en    =   (oe_valid)&(~ODP_I)&(~DO_I);
assign hs_en_n  = ~((oe_valid)&(~ODN_I)&( DO_I));
pmos HSDRV(PAD_B,1'b1,hs_en_n);
nmos LSDRV(PAD_B,1'b0,ls_en);

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//TIMING ANNOTATION
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
specify
	
	//GPO
	if((DS_I == 2'b00)&&(SR_I == 1'b0)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b01)&&(SR_I == 1'b0)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b10)&&(SR_I == 1'b0)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b11)&&(SR_I == 1'b0)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b00)&&(SR_I == 1'b1)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b01)&&(SR_I == 1'b1)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b10)&&(SR_I == 1'b1)) (DO_I => PAD_B)=(0,0);
	if((DS_I == 2'b11)&&(SR_I == 1'b1)) (DO_I => PAD_B)=(0,0);
	(OE_I => PAD_B)=(0,0,0,0,0,0);
	
endspecify

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

endmodule
`endcelldefine
