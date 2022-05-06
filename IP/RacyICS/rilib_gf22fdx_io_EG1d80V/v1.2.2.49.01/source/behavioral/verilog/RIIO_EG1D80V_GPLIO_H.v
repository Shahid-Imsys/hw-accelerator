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
module RIIO_EG1D80V_GPLIO_H (
	
		// PADS
		A_PAD_B,
		B_PAD_B
	
		//GPIO A
		, A_DO_I
		, A_DS_I
		, A_SR_I
		, A_CO_I
		, A_OE_I
		, A_ODP_I
		, A_ODN_I
		, A_IE_I
		, A_STE_I
		, A_PD_I
		, A_PU_I
		, A_DI_O

		//GPIO B
		, B_DO_I
		, B_DS_I
		, B_SR_I
		, B_CO_I
		, B_OE_I
		, B_ODP_I
		, B_ODN_I
		, B_IE_I
		, B_STE_I
		, B_PD_I
		, B_PU_I
		, B_DI_O
	
		//LVDS
		, L_DO_I
		, L_OE_I
		, L_DS_I
		, L_IE_I
		, L_RTERM_I
		, L_DI_O
	
		, VBIAS
	
`ifdef USE_PG_PIN
		, VDDIO
		, VSSIO
		, VDD
		, VSS
`endif// USE_PG_PIN
);

	// PADS
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_PAD_B;
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDDIO";
	   integer groundSensitivity = "VSSIO"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_PAD_B;
	
	//GPIO A
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_DO_I;
input   [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_DS_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_SR_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_CO_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_OE_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_ODP_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_ODN_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_IE_I;
input   [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_STE_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_PD_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_PU_I;
output  [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  A_DI_O;

	//GPIO B
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_DO_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_OE_I;
input   [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_DS_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_SR_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_CO_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_ODP_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_ODN_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_IE_I;
input   [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_STE_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_PD_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_PU_I;
output  [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  B_DI_O;
	
	//LVDS
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  L_DO_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  L_OE_I;
input   [3:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  L_DS_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  L_IE_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  L_RTERM_I;
output
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  L_DI_O;

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
//GPIO A

//high-side and low-side pad driver 
wire a_ls_en;
wire a_hs_en_n;
wire a_oe_valid;

assign a_oe_valid = A_OE_I && ~L_OE_I && (A_DS_I[1:0] == 2'b00 || VBIAS===1'b1);
assign a_ls_en    =   (a_oe_valid)&(~A_ODP_I)&(~A_DO_I);
assign a_hs_en_n  = ~((a_oe_valid)&(~A_ODN_I)&( A_DO_I));
pmos A_HSDRV(A_PAD_B,1'b1,a_hs_en_n);
nmos A_LSDRV(A_PAD_B,1'b0,a_ls_en);

//input receiver with PU,PD and keeper
wire a_pu, a_pd;
reg a_pu_en, a_pd_en;
wire a_pad_rx;

pullup(a_pu);
pulldown(a_pd);
nmos A_PUEN(A_PAD_B,a_pu,(a_pu_en&~L_OE_I));
nmos A_PDEN(A_PAD_B,a_pd,(a_pd_en&~L_OE_I));

assign a_pad_rx = A_PAD_B;

always @(A_PU_I or A_PD_I or a_pad_rx) begin
	case ({A_PU_I,A_PD_I})
		2'b00: begin
				a_pu_en = 1'b0;
				a_pd_en = 1'b0;
		end
		2'b01: begin
				a_pu_en = 1'b0;
				a_pd_en = 1'b1;
		end
		2'b10:	begin
				a_pu_en = 1'b1;
				a_pd_en = 1'b0;
		end
		2'b11: begin
				a_pu_en = a_pad_rx;
				a_pd_en =~a_pad_rx;
		end
	endcase
end

assign A_DI_O[0] = ((L_OE_I) ? 1'bx: a_pad_rx)&A_IE_I;
assign A_DI_O[1] = ((L_OE_I) ? 1'bx: a_pad_rx)&A_IE_I;
//////////////////////////////////////////////////////////
//GPIO B

//high-side and low-side pad driver 
wire b_ls_en;
wire b_hs_en_n;
wire b_oe_valid;

assign b_oe_valid = B_OE_I && ~L_OE_I && (B_DS_I[1:0] == 2'b00 || VBIAS===1'b1);
assign b_ls_en    =   (b_oe_valid)&(~B_ODP_I)&(~B_DO_I);
assign b_hs_en_n  = ~((b_oe_valid)&(~B_ODN_I)&( B_DO_I));
pmos B_HSDRV(B_PAD_B,1'b1,b_hs_en_n);
nmos B_LSDRV(B_PAD_B,1'b0,b_ls_en);

//input receiver with PU,PD and keeper
wire b_pu, b_pd;
reg b_pu_en, b_pd_en;
wire b_pad_rx;

pullup(b_pu);
pulldown(b_pd);
nmos B_PUEN(B_PAD_B,b_pu,(b_pu_en&~L_OE_I));
nmos B_PDEN(B_PAD_B,b_pd,(b_pd_en&~L_OE_I));

assign b_pad_rx = B_PAD_B;

always @(B_PU_I or B_PD_I or b_pad_rx) begin
	case ({B_PU_I,B_PD_I})
		2'b00: begin
				b_pu_en=1'b0;
				b_pd_en=1'b0;
		end
		2'b01: begin
				b_pu_en=1'b0;
				b_pd_en=1'b1;
		end
		2'b10:	begin
				b_pu_en=1'b1;
				b_pd_en=1'b0;
		end
		2'b11: begin
				b_pu_en=b_pad_rx;
				b_pd_en=~b_pad_rx;
		end
	endcase
end

assign B_DI_O[0] = ((L_OE_I) ? 1'bx: b_pad_rx)&B_IE_I;
assign B_DI_O[1] = ((L_OE_I) ? 1'bx: b_pad_rx)&B_IE_I;
//////////////////////////////////////////////////////////
//LVDS

//Driver
wire l_oe_valid;

assign l_oe_valid = L_OE_I && (L_DS_I[1:0] == 2'b00 || VBIAS===1'b1);
bufif1 (A_PAD_B,L_DO_I,l_oe_valid);
bufif1 (B_PAD_B,~L_DO_I,l_oe_valid);

//Receiver
reg lvds_rx;
always @(A_PAD_B or B_PAD_B) begin
	case ({A_PAD_B,B_PAD_B})
		2'b00: 	lvds_rx=1'bx;
		2'b01: 	lvds_rx=1'b0;
		2'b10: 	lvds_rx=1'b1;
		2'b11: 	lvds_rx=1'bx;
	endcase
end
assign L_DI_O= (L_IE_I==1'b1)  ? lvds_rx : 1'b0;

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//TIMING ANNOTATION
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
specify
	
	//GPIO A
	if((A_DS_I == 2'b00)&&(A_SR_I == 1'b0)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b01)&&(A_SR_I == 1'b0)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b10)&&(A_SR_I == 1'b0)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b11)&&(A_SR_I == 1'b0)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b00)&&(A_SR_I == 1'b1)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b01)&&(A_SR_I == 1'b1)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b10)&&(A_SR_I == 1'b1)) (A_DO_I => A_PAD_B)=(0,0);
	if((A_DS_I == 2'b11)&&(A_SR_I == 1'b1)) (A_DO_I => A_PAD_B)=(0,0);
	(A_OE_I => A_PAD_B)=(0,0,0,0,0,0);
	(A_PAD_B => A_DI_O[0])=(0,0);
	(A_PAD_B => A_DI_O[1])=(0,0);
	(A_IE_I => A_DI_O[0])=(0,0);
	(A_IE_I => A_DI_O[1])=(0,0);
	
	//GPIO B
	if((B_DS_I == 2'b00)&&(B_SR_I == 1'b0)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b01)&&(B_SR_I == 1'b0)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b10)&&(B_SR_I == 1'b0)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b11)&&(B_SR_I == 1'b0)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b00)&&(B_SR_I == 1'b1)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b01)&&(B_SR_I == 1'b1)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b10)&&(B_SR_I == 1'b1)) (B_DO_I => B_PAD_B)=(0,0);
	if((B_DS_I == 2'b11)&&(B_SR_I == 1'b1)) (B_DO_I => B_PAD_B)=(0,0);
	(B_OE_I => B_PAD_B)=(0,0,0,0,0,0);
	(B_PAD_B => B_DI_O[0])=(0,0);
	(B_PAD_B => B_DI_O[1])=(0,0);
	(B_IE_I => B_DI_O[0])=(0,0);
	(B_IE_I => B_DI_O[1])=(0,0);

endspecify

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

endmodule
`endcelldefine
