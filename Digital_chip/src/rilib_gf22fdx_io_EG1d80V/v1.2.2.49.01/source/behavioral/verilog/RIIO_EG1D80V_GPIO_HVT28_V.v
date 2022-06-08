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
// Last Change       :   $Date: 2019-01-22 18:42:34 +0100 (Tue, 22 Jan 2019) $
// by                :   $Author: schreiter $                  			
// ------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RIIO_EG1D80V_GPIO_HVT28_V (
	
		// PAD
		PAD_B
	
		//GPIO
		, DO_I
		, DS_I
		, SR_I
		, CO_I
		, OE_I
		, ODP_I
		, ODN_I
		, IE_I
		, STE_I
		, PD_I
		, PU_I
		, DI_O

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
	
	//GPIO
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DO_I;
input   [3:0]
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
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  PD_I;
input
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  PU_I;
output  [1:0]
`ifdef USE_AMS_EXTENSION
`ifdef INCA
    (* integer supplySensitivity = "VDD";
	   integer groundSensitivity = "VSS"; *)
`endif//INCA
`endif//USE_AMS_EXTENSION
  DI_O;

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
//GPIO 

//high-side and low-side PAD_B driver 
wire ls_en;
wire hs_en_n;
wire oe_valid;


assign oe_valid = OE_I && (DS_I[1:0] == 2'b00 || VBIAS===1'b1);
assign ls_en    =   (oe_valid)&(~ODP_I)&(~DO_I);
assign hs_en_n  = ~((oe_valid)&(~ODN_I)&( DO_I));
pmos HSDRV(PAD_B,1'b1,hs_en_n);
nmos LSDRV(PAD_B,1'b0,ls_en);

//input receiver with PU,PD and keeper
wire pu, pd;
reg pu_en, pd_en;
wire PAD_B_rx;

pullup(pu);
pulldown(pd);
nmos PUEN(PAD_B,pu,pu_en);
nmos PDEN(PAD_B,pd,pd_en);

assign PAD_B_rx = PAD_B;

always @(PU_I or PD_I or PAD_B_rx or IE_I) begin
	case ({PU_I,PD_I})
		2'b00: begin
				pu_en = 1'b0;
				pd_en = 1'b0;
		end
		2'b01: begin
				pu_en = 1'b0;
				pd_en = 1'b1;
		end
		2'b10:	begin
				pu_en = 1'b1;
				pd_en = 1'b0;
		end
		2'b11: begin
				pu_en = (PAD_B_rx&IE_I);
				pd_en =~(PAD_B_rx&IE_I);
		end
	endcase
end

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

    if (((DS_I[2]===0)&&(DS_I[3]===0))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===0)&&(DS_I[3]===0))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===0)&&(DS_I[3]===1))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===0)&&(DS_I[3]===1))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===1)&&(DS_I[3]===0))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===1)&&(DS_I[3]===0))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===1)&&(DS_I[3]===1))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if (((DS_I[2]===1)&&(DS_I[3]===1))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);

    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===0)) (OE_I => PAD_B)=(0,0,0,0,0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===1)) (OE_I => PAD_B)=(0,0,0,0,0,0);

    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
   if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[0])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[0])=(0,0);

    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
   if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (IE_I => DI_O[1])=(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (IE_I => DI_O[1])=(0,0);

    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===0)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===0))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===0))&&(IE_I===1))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===0))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===0)) (DO_I => PAD_B)=(0,0);
    if ((((DS_I[2]===1)&&(DS_I[3]===1))&&(IE_I===1))&&(SR_I===1)) (DO_I => PAD_B)=(0,0);

    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[0]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[0]) =(0,0);

    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===0)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===0))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===0))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===0)) (PAD_B => DI_O[1]) =(0,0);
    if ((((PD_I===1)&&(PU_I===1))&&(STE_I[0]===1))&&(STE_I[1]===1)) (PAD_B => DI_O[1]) =(0,0);



      ifnone (OE_I => PAD_B)=(0,0,0,0,0,0);
      ifnone (DO_I => PAD_B)=(0,0);

      ifnone (PAD_B => DI_O[0])=(0,0);
      ifnone (PAD_B => DI_O[1])=(0,0);
      ifnone (IE_I => DI_O[0])=(0,0);
      ifnone (IE_I => DI_O[1])=(0,0);


endspecify


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

endmodule
`endcelldefine
