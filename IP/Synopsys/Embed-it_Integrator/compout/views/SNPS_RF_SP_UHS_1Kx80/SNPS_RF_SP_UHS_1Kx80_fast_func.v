//---------------------------------------------------------------------
//               Copyright(c) Synopsys, Inc.                           
//     All Rights reserved - Unpublished -rights reserved under        
//     the Copyright laws of the United States of America.             
//                                                                     
//  U.S. Patents: 7,093,156 B1 and 7,406,620 B2 (and more pending).    
//                                                                     
//  This file includes the Confidential information of Synopsys, Inc.  
//  and GLOBALFOUNDRIES.                                               
//  The receiver of this Confidential Information shall not disclose   
//  it to any third party and shall protect its confidentiality by     
//  using the same degree of care, but not less than a reasonable      
//  degree of care, as the receiver uses to protect receiver's own     
//  Confidential Information.                                          
//  Licensee acknowledges and agrees that all output generated for     
//  Licensee by Synopsys, Inc. as described in the pertinent Program   
//  Schedule(s), or generated by Licensee through use of any Compiler  
//  licensed hereunder contains information that complies with the     
//  Virtual Component Identification Physical Tagging Standard (VCID)  
//  as maintained by the Virtual Socket Interface Alliance (VSIA).     
//  Such information may be expressed in GDSII Layer 63 or other such  
//  layer designated by the VSIA, hardware definition languages, or    
//  other formats.  Licensee is not authorized to alter or change any  
//  such information.                                                  
//---------------------------------------------------------------------
//                                                                     
//  Built for linux64 and running on linux64.                          
//                                                                     
//  Software           : Rev: S-2021.09-SP1                            
//  Library Format     : Rev: 1.05.00                                  
//  Compiler Name      : gf22nsd42p11s1drl128sa04p1                    
//  Platform           : Linux3.10.0-957.5.1.el7.x86_64                
//                     : #1 SMP Wed Dec 19 10:46:58 EST 2018x86_64     
//  Date of Generation : Mon May 23 15:53:57 CEST 2022                 
//                                                                     
//---------------------------------------------------------------------
//   --------------------------------------------------------------     
//                       Template Revision : 4.5.4                      
//   --------------------------------------------------------------     
//                 * Synchronous, 2-Port Register File *              
//                   * Fast Functional Verilog Model *                
//                THIS IS A SYNCHRONOUS 2-PORT MEMORY MODEL           
//                                                                    
//   Memory Name:SNPS_RF_SP_UHS_1Kx80                                 
//   Memory Size:1024 words x 80 bits                                 
//                                                                    
//                               PORT NAME                            
//                               ---------                            
//               Output Ports                                         
//                                   QB[79:0]                         
//               Input Ports:                                         
//                                   ADRA[9:0]                        
//                                   DA[79:0]                         
//                                   WEA                              
//                                   MEA                              
//                                   CLKA                             
//                                   TEST1A                           
//                                   TEST_RNMA                        
//                                   RMEA                             
//                                   RMA[3:0]                         
//                                   WA[1:0]                          
//                                   WPULSE[2:0]                      
//                                   LS                               
//                                   ADRB[9:0]                        
//                                   MEB                              
//                                   CLKB                             
//                                   TEST1B                           
//                                   RMEB                             
//                                   RMB[3:0]                         

// To instantiate this model with verilog Bus Wrapper,  use "LS=1'b0" 
// as these pins do not have any functionality in this model.  



`resetall 
`timescale 1 ns / 1 ps 
`celldefine 
`ifdef verifault // for fault simulation purpose 
`suppress_faults 
`enable_portfaults 
`endif 

`define True    1'b1
`define False   1'b0

module SNPS_RF_SP_UHS_1Kx80 ( QB, ADRA, DA, WEA, MEA, CLKA, TEST1A, TEST_RNMA, RMEA, RMA, WA, WPULSE, LS, ADRB, MEB, CLKB, TEST1B, RMEB, RMB);

// Input/Output Ports Declaration
output  [79:0] QB;
input  [9:0] ADRA;
input  [79:0] DA;
input WEA;
input MEA;
input CLKA;
input TEST1A;
input TEST_RNMA;
input RMEA;
input  [3:0] RMA;
input  [1:0] WA;
input  [2:0] WPULSE;
input LS;
input  [9:0] ADRB;
input MEB;
input CLKB;
input TEST1B;
input RMEB;
input  [3:0] RMB;


// Local registers, wires, etc
`ifdef MEM_CHECK_OFF
parameter MES_CNTRL = "OFF";
`else
parameter MES_CNTRL = "ON";
`endif
`ifndef SNPS_FAST_SIM_FFV
`ifndef MES_CNTRL_DEL_BEGIN
  `define MES_CNTRL_DEL_BEGIN 0
`endif

`ifndef MES_CNTRL_DEL_END
  `define MES_CNTRL_DEL_END 0
`endif
parameter MesCntrl_Begin = `MES_CNTRL_DEL_BEGIN;
parameter MesCntrl_End = `MES_CNTRL_DEL_END;

`endif
parameter TCSEP = 0.001;

`ifndef SNPS_FAST_SIM_FFV
reg disp_LS_msgA;
reg disp_LS_msgB;

reg en_msg_cntrl, mes_all_valid_old;
real msg_start_lmt, msg_end_lmt;
reg disp_LS_msgA_old;
reg disp_LS_msgB_old;
initial
begin
  en_msg_cntrl = 1'b0;
  mes_all_valid_old = 1'b0;
  disp_LS_msgA_old = 1'b1;
  disp_LS_msgB_old = 1'b1;
  if (MesCntrl_Begin < 0)
    msg_start_lmt = 0;
  else
    msg_start_lmt = MesCntrl_Begin;
  if (MesCntrl_End < 0)
    msg_end_lmt = 0;
  else
    msg_end_lmt = MesCntrl_End;
  
  if (msg_end_lmt > msg_start_lmt)
  begin
    en_msg_cntrl <= #(msg_start_lmt) 1'b1;
    en_msg_cntrl <= #(msg_end_lmt) 1'b0;
  end
end

`ifdef MES_CNTRL_PIN
always @(`MES_CNTRL_PIN)
begin
  if (msg_start_lmt == 0 && msg_end_lmt == 0)
  begin
    if (`MES_CNTRL_PIN  === `MES_CNTRL_PIN_VAL)
    begin
      en_msg_cntrl = 1;
    end
    else
    begin
      en_msg_cntrl = 0;
    end
  end
end
`endif

always @( en_msg_cntrl )
begin
  if (en_msg_cntrl == 1'b1 )
  begin
    mes_all_valid_old = uut.mes_all_valid;
    assign uut.mes_all_valid = 0;
    disp_LS_msgA_old = disp_LS_msgA;
    assign disp_LS_msgA = 0;
    disp_LS_msgB_old = disp_LS_msgB;
    assign disp_LS_msgB = 0;
  end
  else
  begin
    deassign uut.mes_all_valid ;
    uut.mes_all_valid = mes_all_valid_old;
    deassign disp_LS_msgA;
    disp_LS_msgA = disp_LS_msgA_old;
    deassign disp_LS_msgB;
    disp_LS_msgB = disp_LS_msgB_old;
  end
end

`endif


wire [79:0] QB_mem;
reg  [79:0] QB_buf;

always @ ( QB_mem )
begin
  QB_buf <=  QB_mem;
end

assign QB = QB_buf;

`ifndef SNPS_FAST_SIM_FFV
real t0a_pfirst, t1a_pfirst, t2a_pnow, t2a_nnow, t3a_me;
real t0b_pfirst, t1b_pfirst, t2b_pnow, t2b_nnow, t3b_me;
initial
begin
  t0a_pfirst = 0.0;
  t1a_pfirst = 0.0;
  t2a_pnow = 0.0;
  t2a_nnow = 0.0;
  t3a_me = 0.0;
  t0b_pfirst = 0.0;
  t1b_pfirst = 0.0;
  t2b_pnow = 0.0;
  t2b_nnow = 0.0;
  t3b_me = 0.0;
end
always @(posedge CLKA)
begin
  t0a_pfirst = t1a_pfirst;
  t1a_pfirst = t2a_pnow;
  t2a_pnow = $realtime;
  if ((t1a_pfirst < t3a_me) && (t3a_me < t2a_pnow))
  begin   
    uut.diff_me_tcha = 1'b1;
  end
  if ((t0a_pfirst < t3a_me) && (t3a_me < t2a_pnow))
  begin   
    uut.diff_me_tcca = 1'b1;
  end
    @(negedge CLKA)
    t2a_nnow = $realtime;
    #0.001;
    uut.diff_me_tcha = 1'b0;
    uut.diff_me_tcca = 1'b0;
end

always @(MEA)
begin
  t3a_me = $realtime;
  if ((t2a_pnow < t3a_me) && (t2a_nnow < t3a_me))
  begin   
    uut.diff_me_tcha = 1'b1;
  end
end
always @(posedge CLKB)
begin
  t0b_pfirst = t1b_pfirst;
  t1b_pfirst = t2b_pnow;
  t2b_pnow = $realtime;
  if ((t1b_pfirst < t3b_me) && (t3b_me < t2b_pnow))
  begin   
    uut.diff_me_tchb = 1'b1;
  end
  if ((t0b_pfirst < t3b_me) && (t3b_me < t2b_pnow))
  begin   
    uut.diff_me_tccb = 1'b1;
  end
    @(negedge CLKB)
    t2b_nnow = $realtime;
    #0.001;
    uut.diff_me_tchb = 1'b0;
    uut.diff_me_tccb = 1'b0;
end

always @(MEB)
begin
  t3b_me = $realtime;
  if ((t2b_pnow < t3b_me) && (t2b_nnow < t3b_me))
  begin   
    uut.diff_me_tchb = 1'b1;
  end
end
`endif
generic_behav_SNPS_RF_SP_UHS_1Kx80 #( MES_CNTRL, TCSEP) uut ( .QB(QB_mem), .ADRA(ADRA), .DA(DA), .WEA(WEA), .MEA(MEA), .CLKA(CLKA), .ADRB(ADRB), .MEB(MEB), .CLKB(CLKB) );


endmodule

`endcelldefine 
`ifdef verifault 
`disable_portfaults 
`nosuppress_faults 
`endif 


module generic_behav_SNPS_RF_SP_UHS_1Kx80 (  QB, ADRA, DA, WEA, MEA, CLKA, ADRB, MEB, CLKB );

parameter MES_CNTRL = "ON";
parameter TCSEP = 0.001;
parameter words = 1024, bits = 80, addrbits = 10, wabits=2, wpulsebits=3;

output [bits-1:0] QB;
input [addrbits-1:0] ADRA;
input [bits-1:0] DA;
input WEA;
input MEA;
input CLKA;
input [addrbits-1:0] ADRB;
input MEB;
input CLKB;

reg [bits-1:0] QB;


reg [addrbits-1:0] ADRAlatched;
reg WEAlatched;
reg [bits-1:0] DAlatched;
reg [bits-1:0] memdata_bef_wrt;


reg [addrbits-1:0] ADRBlatched;

reg MEAlatched;
reg MEBlatched;


real CLK_A_T, CLK_B_T;

reg flaga_clk_valid;
reg flagb_clk_valid;
reg mes_all_valid;

wire [1:0] ADRA_valid;
wire [1:0] ADRB_valid;
reg [79:0] mem_core_array [0:1023];

parameter DataX = { bits { 1'bx } };

// -------------------------------------------------------------------
// Common tasks
// -------------------------------------------------------------------

`ifndef SNPS_FAST_SIM_FFV
// Task to report unknown messages
task report_unknown;
input [8*9:1] signal;
  begin
      if( (MES_CNTRL=="ON" || MES_CNTRL=="ERR") && $realtime != 0 && mes_all_valid )
      begin
        $display("<<VIRL_MEM_ERR:%0s unknown>> at time=%t; instance=%m (RAMS1H)",signal,$realtime);
      end
 end
endtask

`endif

task corrupt_all_loc;
 input flag_range_ok;
 integer addr_index;
 begin
   if( flag_range_ok == `True)
   begin
   for( addr_index = 0; addr_index < words; addr_index = addr_index + 1)
   begin
     mem_core_array[ addr_index] = DataX;
   end
  end
 end
endtask


/////////////////////////////////////////////
/////Simultaneous Clock handling
/////////////////////////////////////////////

reg same_edge;

always @( posedge same_edge ) 
begin : blk_same_edge
`ifdef SNPS_FAST_SIM_FFV
  if ((( ADRAlatched === ADRBlatched ) ) && ( ^ADRAlatched !== 1'bx ) && ( ^ADRBlatched !== 1'bx ))
`else
  if ((( ADRAlatched === ADRBlatched ) && (ADRA_valid == 2'b00)) && ( ^ADRAlatched !== 1'bx ) && ( ^ADRBlatched !== 1'bx ))
`endif
  begin
    if ( MEBlatched === 1'bX)
    begin
      QB = DataX;
    end
    else
    begin
      if ( MEAlatched !== 1'b0 && MEBlatched !== 1'b0 && WEAlatched !== 1'b0 )
      begin
        QB = memdata_bef_wrt ^ ( DataX & (memdata_bef_wrt ^DAlatched));
      end
    end // end if simultaneous write and read
  end // end of if ADRA and ADRB
end // end of block blk_same_edge

initial 
begin
  flaga_clk_valid = `False;
  mes_all_valid = 1'b0;
end 

`ifndef SNPS_FAST_SIM_FFV
assign ADRA_valid = (( ^ADRA === 1'bx ) ? 2'b01 : ( ( ADRA > 10'b1111111111 ) ? 2'b10 : 2'b00 ));
`endif

`ifndef SNPS_FAST_SIM_FFV
reg diff_me_tcha, diff_me_tcca;
always @ ( negedge CLKA )
begin : blk_negedge_clk_0
  if ( CLKA !== 1'bx && CLKA !== 1'bz )
  begin
    flaga_clk_valid = `True;
  end // end if CLKA != X
  else
  begin
    if (MEAlatched !== 1'b0 || MEA !== 1'b0)
    begin
    report_unknown("CLKA");
    flaga_clk_valid = `False;
    corrupt_all_loc(`True);
  end // end of else of CLKA != X
  end // end of diff_me_tch
end // end of block blk_negedge_clk_0
`endif
`ifdef SNPS_FAST_SIM_FFV

always @ ( posedge CLKA )
begin : blk_posedge_clk_0
   CLK_A_T = $realtime;
   ADRAlatched = ADRA;
   WEAlatched = WEA;
   DAlatched = DA;
  MEAlatched = MEA;
   if (CLK_A_T - CLK_B_T < TCSEP)
     same_edge = 1'b1;
   else
     same_edge = 1'b0;
      if ( CLKA === 1'b1)
      begin
        if ( MEA === 1'b1) 
        begin
          if ( WEA === 1'b1) 
          begin
            memdata_bef_wrt = mem_core_array[ADRA];
            WritePortA;
          end // end of Write
        end // end of MEA = 1
      end // end of if CLKA = 1
end // end of block blk_posedge_clk_0
`else
always @ ( posedge CLKA )
begin : blk_posedge_clk_0
   CLK_A_T = $realtime;
   ADRAlatched = ADRA;
   WEAlatched = WEA;
   DAlatched = DA;
  MEAlatched = MEA;
   if (CLK_A_T - CLK_B_T < TCSEP)
     same_edge = 1'b1;
   else
     same_edge = 1'b0;
    if ( flaga_clk_valid )
    begin
      if ( CLKA === 1'b1)
      begin
        if ( MEA === 1'b1) 
        begin
          if ( WEA === 1'b1) 
          begin
            memdata_bef_wrt = mem_core_array[ADRA];
            WritePortA;
          end // end of Write
          else
          begin
           if ( WEA === 1'bx )
           begin
            report_unknown("WEA");
            mem_core_array[ADRA] = DataX ;
            if ( ADRA_valid === 2'b00 ) 
            begin
            end // end of if ADRA_valid = 2'b00
            else if ( ADRA_valid === 2'b01 ) 
            begin
              corrupt_all_loc(`True);
            end // end of else of ADRA_valid = 2'b01
           end // 
          end // end of else of WEA = X
        end // end of MEA = 1
        else
        begin
          if ( MEA === 1'bx ) 
          begin
            report_unknown("MEA");
            if ( WEA !== 1'b0 )
            begin
              corrupt_all_loc(`True);
            end
          end // end of if MEA = X
        end // end of else of MEA = 1
      end // end of if CLKA = 1
      else 
      begin
        if ( CLKA === 1'bx || CLKA === 1'bz ) 
        begin
          #0.001;
          if (diff_me_tcha === 1'b1 || MEAlatched !== 1'b0 || MEA !== 1'b0)
          begin
          report_unknown("CLKA");
          corrupt_all_loc(`True);
        end // end of if CLKA = 1'bx
        end // end of diff_me_tch
      end // end of else of CLKA = 1
    end // end of if flaga_clk_valid = 1
    else 
    begin
      corrupt_all_loc(`True);
    end // end of else of flaga_clk_valid = 1
end // end of block blk_posedge_clk_0
`endif


`ifdef SNPS_FAST_SIM_FFV
task WritePortA;
begin : blk_WritePortA
    mem_core_array[ADRA] = DA;
    if ( !mes_all_valid )
       mes_all_valid = 1'b1;
end // end of block blk_WritePortA
endtask
`else
task WritePortA;
begin : blk_WritePortA
  if ( ADRA_valid === 2'b00 )
  begin
    mem_core_array[ADRA] = DA;
    if ( !mes_all_valid )
       mes_all_valid = 1'b1;
    if ( ^DA === 1'bx )
    begin
      report_unknown("DA");
    end
  end // end of if ADRA_valid = 2'b00
  else if (ADRA_valid === 2'b10 )
  begin
    if ( (MES_CNTRL == "ON" || MES_CNTRL == "WARN") && $realtime != 0 && mes_all_valid )
    begin
      $display("<<VIRL_MEM_WARNING:address is out of range\n RANGE:0 to 1023>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid 
  end // end of else of ADRA_valid = 2'b10
  else 
  begin
    report_unknown("ADRA");
    corrupt_all_loc(`True);
  end // end of else of ADRA_valid = 2'b01
end // end of block blk_WritePortA
endtask
`endif

initial 
begin
  flagb_clk_valid = `False;
  mes_all_valid = 1'b0;
end 

`ifndef SNPS_FAST_SIM_FFV
assign ADRB_valid = (( ^ADRB === 1'bx ) ? 2'b01 : ( ( ADRB > 10'b1111111111 ) ? 2'b10 : 2'b00 ));
`endif

`ifndef SNPS_FAST_SIM_FFV
reg diff_me_tchb, diff_me_tccb;
always @ ( negedge CLKB )
begin : blk_negedge_clk_1
  if ( CLKB !== 1'bx && CLKB !== 1'bz )
  begin
    flagb_clk_valid = `True;
  end // end if CLKB != X
  else
  begin
    if (MEBlatched !== 1'b0 || MEB !== 1'b0)
    begin
    report_unknown("CLKB");
    flagb_clk_valid = `False;
    QB = DataX;
  end // end of else of CLKB != X
  end // end of diff_me_tch
end // end of block blk_negedge_clk_1
`endif
`ifdef SNPS_FAST_SIM_FFV

always @ ( posedge CLKB )
begin : blk_posedge_clk_1
   CLK_B_T = $realtime;
   ADRBlatched = ADRB;
  MEBlatched = MEB;
   if (CLK_B_T - CLK_A_T < TCSEP)
     same_edge = 1'b1;
   else
     same_edge = 1'b0;
      if ( CLKB === 1'b1)
      begin
        if ( MEB === 1'b1) 
        begin
            ReadPortB;
        end // end of MEB = 1
      end // end of if CLKB = 1
end // end of block blk_posedge_clk_1
`else
always @ ( posedge CLKB )
begin : blk_posedge_clk_1
   CLK_B_T = $realtime;
   ADRBlatched = ADRB;
  MEBlatched = MEB;
   if (CLK_B_T - CLK_A_T < TCSEP)
     same_edge = 1'b1;
   else
     same_edge = 1'b0;
    if ( flagb_clk_valid )
    begin
      if ( CLKB === 1'b1)
      begin
        if ( MEB === 1'b1) 
        begin
            ReadPortB;
        end // end of MEB = 1
        else
        begin
          if ( MEB === 1'bx ) 
          begin
            report_unknown("MEB");
            QB = 80'bx;
          end // end of if MEB = X
        end // end of else of MEB = 1
      end // end of if CLKB = 1
      else 
      begin
        if ( CLKB === 1'bx || CLKB === 1'bz ) 
        begin
          #0.001;
          if (diff_me_tchb === 1'b1 || MEBlatched !== 1'b0 || MEB !== 1'b0)
          begin
          report_unknown("CLKB");
          QB = DataX;
        end // end of if CLKB = 1'bx
        end // end of diff_me_tch
      end // end of else of CLKB = 1
    end // end of if flagb_clk_valid = 1
    else 
    begin
      QB = DataX;
    end // end of else of flagb_clk_valid = 1
end // end of block blk_posedge_clk_1
`endif



`ifdef SNPS_FAST_SIM_FFV
task ReadPortB;
begin : blk_ReadPortB
    QB = mem_core_array[ADRB];
end // end of block blk_ReadPortB
endtask
`else
task ReadPortB;
begin : blk_ReadPortB
  if ( ADRB_valid === 2'b00 )
  begin
    QB = mem_core_array[ADRB];
  end // end of if ADRB_valid = 2'b00
  else if ( ADRB_valid === 2'b10 )
  begin
    QB = DataX;
    if ( (MES_CNTRL == "ON" || MES_CNTRL == "WARN") && $realtime != 0 && mes_all_valid )
    begin
      $display("<<VIRL_MEM_WARNING:address is out of range\n RANGE:0 to 1023>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid
  end // end of else of ADRB_valid = 2'b10
  else 
  begin
    report_unknown("ADRB");
    QB = DataX;
  end // end of else of ADRB_valid = 2'b01
end // end of block blk_ReadPortB
endtask
`endif

endmodule
