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
//  Software           : Rev: U-2022.12                                
//  Library Format     : Rev: 1.05.00                                  
//  Compiler Name      : gf22nsd41p11s1srl256sa04p1                    
//  Platform           : Linux3.10.0-957.5.1.el7.x86_64                
//                     : #1 SMP Wed Dec 19 10:46:58 EST 2018x86_64     
//  Date of Generation : Fri Dec 09 13:57:23 CET 2022                  
//                                                                     
//---------------------------------------------------------------------
//   --------------------------------------------------------------     
//                       Template Revision : 6.3.7                      
//   --------------------------------------------------------------     
//                 * Synchronous, 1-Port Register File *              
//                   * Fast functional Verilog Model *                
//                THIS IS A SYNCHRONOUS 1-PORT MEMORY MODEL           
//                                                                    
//   Memory Name:SNPS_RF_SP_UHS_256x64                                
//   Memory Size:256 words x 64 bits                                  
//                                                                    
//                               PORT NAME                            
//                               ---------                            
//               Output Ports                                         
//                                   Q[63:0]                          
//               Input Ports:                                         
//                                   ADR[7:0]                         
//                                   D[63:0]                          
//                                   WE                               
//                                   ME                               
//                                   CLK                              
//                                   TEST1                            
//                                   TEST_RNM                         
//                                   RME                              
//                                   RM[3:0]                          
//                                   WA[1:0]                          
//                                   WPULSE[2:0]                      
//                                   LS                               
//                                   BC0                              
//                                   BC1                              
//                                   BC2                              
// -------------------------------------------------------------------- 



`resetall 
`timescale 1 ns / 1 ps 
`celldefine 
`ifdef verifault // for fault simulation purpose 
`suppress_faults 
`enable_portfaults 
`endif 

`define True    1'b1
`define False   1'b0

module SNPS_RF_SP_UHS_256x64 ( Q, ADR, D, WE, ME, CLK, TEST1, TEST_RNM, RME, RM, WA, WPULSE, LS, BC0, BC1, BC2);

// Input/Output Ports Declaration
output  [63:0] Q;
input  [7:0] ADR;
input  [63:0] D;
input WE;
input ME;
input CLK;
input TEST1;
input TEST_RNM;
input RME;
input  [3:0] RM;
input  [1:0] WA;
input  [2:0] WPULSE;
input LS;
input BC0;
input BC1;
input BC2;


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

`ifndef SNPS_FAST_SIM_FFV
reg disp_LS_msg;

reg en_msg_cntrl, mes_all_valid_old;
real msg_start_lmt, msg_end_lmt;
reg disp_LS_msg_old;
initial
begin
  en_msg_cntrl = 1'b0;
  mes_all_valid_old = 1'b0;
  disp_LS_msg_old = 1'b1;
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
    mes_all_valid_old = u0.mes_all_valid;
    assign u0.mes_all_valid = 0;
    disp_LS_msg_old = disp_LS_msg;
    assign disp_LS_msg = 0;
  end
  else
  begin
    deassign u0.mes_all_valid ;
    u0.mes_all_valid = mes_all_valid_old;
    deassign disp_LS_msg;
    disp_LS_msg = disp_LS_msg_old;
  end
end

`endif


`ifndef SNPS_FAST_SIM_FFV
reg ME_latch;

always @ (negedge CLK or ME)
begin
  if (CLK === 1'b0)
    ME_latch =  ME;
end
`endif
wire [63:0] Q_mem;
reg  [63:0] Q_buf;

always @ ( Q_mem )
begin
  Q_buf <= Q_mem;
end

assign Q = Q_buf;
`ifndef SNPS_FAST_SIM_FFV
initial
begin
disp_LS_msg = 1'b1;
end

// Display the warning when LS is 1.

always @ ( negedge LS )
begin
  disp_LS_msg = 1'b1;
  disp_LS_msg_old = 1'b1;
end

always @ (posedge LS or posedge CLK)
begin : blk_ls_0
  if (LS === 1'b1 && ME_latch !== 1'b0)
  begin
    if( (MES_CNTRL=="ON" || MES_CNTRL=="WARN") && disp_LS_msg === 1'b1 )
    begin
      $display("<<VIRL_MEM_WARNING:  No Operation as Memory is in Light Sleep mode.>> time=%0t instance=%m", $time);
      disp_LS_msg = 1'b0;
    end
  end // if LS = 1
end // end of always block blk_ls_0

`endif
`ifndef SNPS_FAST_SIM_FFV

real t0_pfirst, t1_pfirst, t2_pnow, t2_nnow, t3_me;
initial
begin
  t0_pfirst = 0.0;
  t1_pfirst = 0.0;
  t2_pnow = 0.0;
  t2_nnow = 0.0;
  t3_me = 0.0;
end
always @(posedge CLK)
begin
  t0_pfirst = t1_pfirst;
  t1_pfirst = t2_pnow;
  t2_pnow = $realtime;
  if ((t1_pfirst < t3_me) && (t3_me < t2_pnow))
  begin   
    u0.diff_me_tch = 1'b1;
  end
  if ((t0_pfirst < t3_me) && (t3_me < t2_pnow))
  begin   
    u0.diff_me_tcc = 1'b1;
  end
    @(negedge CLK)
    t2_nnow = $realtime;
    #0.001;
    u0.diff_me_tch = 1'b0;
    u0.diff_me_tcc = 1'b0;
end

always @(ME)
begin
  t3_me = $realtime;
  if ((t2_pnow < t3_me) && (t2_nnow < t3_me))
  begin   
    u0.diff_me_tch = 1'b1;
  end
end
`endif
generic_behav_SNPS_RF_SP_UHS_256x64 #( MES_CNTRL) u0 ( .Q(Q_mem), .ADR(ADR), .D(D), .WE(WE), .ME(ME), .CLK(CLK), .LS(LS), .BC0(BC0), .BC1(BC1), .BC2(BC2) );


endmodule

`endcelldefine 
`ifdef verifault 
`disable_portfaults 
`nosuppress_faults 
`endif 


module generic_behav_SNPS_RF_SP_UHS_256x64 (  Q, ADR, D, WE, ME, CLK, LS, BC0, BC1, BC2 );

parameter MES_CNTRL = "ON";
parameter words = 256, bits = 64, addrbits = 8, wabits=2, wpulsebits=3;

output [bits-1:0] Q;
input [addrbits-1:0] ADR;
input [bits-1:0] D;
input WE;
input ME;
input CLK;
input LS;
input BC0;
input BC1;
input BC2;

reg [bits-1:0] Q;

reg MElatched;


reg flag_clk_valid;
reg mes_all_valid;

wire [1:0] ADR_valid;
reg [63:0] mem_core_array [0:255];

parameter DataX = { bits { 1'bx } };

// -------------------------------------------------------------------
// Common tasks
// -------------------------------------------------------------------

`ifndef SNPS_FAST_SIM_FFV
// Task to report unknown messages
task report_unknown;
input [8*8:1] signal;
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


initial 
begin
  flag_clk_valid = `False;
  mes_all_valid = 1'b0;
end 

`ifndef SNPS_FAST_SIM_FFV
assign ADR_valid = (( ^ADR === 1'bx ) ? 2'b01 : ( ( ADR > 8'b11111111 ) ? 2'b10 : 2'b00 ));
`endif

`ifndef SNPS_FAST_SIM_FFV
reg diff_me_tch, diff_me_tcc;
always @ ( negedge CLK )
begin : blk_negedge_clk_0
  if ( CLK !== 1'bx && CLK !== 1'bz )
  begin
    flag_clk_valid = `True;
  end // end if CLK != X
  else
  begin
    if (MElatched !== 1'b0 || ME !== 1'b0)
    begin
    report_unknown("CLK");
    flag_clk_valid = `False;
    Q = DataX;
    corrupt_all_loc(`True);
  end // end of else of CLK != X
  end // end of if (ME !== 1'b0)
end // end of block blk_negedge_clk_0
`endif

`ifdef SNPS_FAST_SIM_FFV

always @ ( posedge CLK )
begin : blk_posedge_clk_0
  MElatched = ME;
  if ( (LS === 1'b1 && MElatched !== 1'bx))
  begin
    MElatched = 1'b0;
  end
      if ( CLK === 1'b1)
      begin
        if ( MElatched === 1'b1) 
        begin
          if ( WE === 1'b1) 
          begin
            WritePort;
          end // end of Write
          else if ( WE === 1'b0 )
          begin
            ReadPort;
          end // end of Read
        end // end of MElatched = 1
      end // end of if CLK = 1
end // end of block blk_posedge_clk_0
`else
always @ ( posedge CLK )
begin : blk_posedge_clk_0
  MElatched = ME;
  if ( (LS === 1'b1 && MElatched !== 1'bx))
  begin
    MElatched = 1'b0;
  end
  if ( LS === 1'bX && MElatched !== 1'b0 )
  begin
    report_unknown("LS");
    corrupt_all_loc(`True);
    Q = 64'bx;
  end
  else
  begin
    if ( flag_clk_valid )
    begin
      if ( CLK === 1'b1)
      begin
        if ( MElatched === 1'b1) 
        begin
          if ( WE === 1'b1) 
          begin
            WritePort;
          end // end of Write
          else if ( WE === 1'b0 )
          begin
            ReadPort;
          end // end of Read
          else
          begin
            report_unknown("WE");
            mem_core_array[ADR] = DataX ;
            if ( ADR_valid === 2'b00 ) 
            begin
              Q = DataX;
            end // end of if ADR_valid = 2'b00
            else if ( ADR_valid === 2'b01 ) 
            begin
              Q = DataX;
              corrupt_all_loc(`True);
            end // end of else of ADR_valid = 2'b01
          end // end of else of WE = X
        end // end of MElatched = 1
        else
        begin
          if ( MElatched === 1'bx ) 
          begin
            report_unknown("ME");
            `ifdef virage_ignore_read_addx
              if ( WE === 1'b1 )
              begin
                corrupt_all_loc(`True);
              end
              else
              begin
                Q = DataX;
              end
            `else
              begin
                corrupt_all_loc(`True);
                if ( WE !== 1'b1 )
                  Q = DataX;
              end
            `endif
          end // end of if MElatched = X
        end // end of else of MElatched = 1
      end // end of if CLK = 1
      else 
      begin
        if ( CLK === 1'bx || CLK === 1'bz ) 
        begin
          #0.001;
          if (diff_me_tch === 1'b1 || MElatched !== 1'b0 || ME !== 1'b0)
          begin
          report_unknown("CLK");
          Q = DataX;
          corrupt_all_loc(`True);
          end // end of diff_me_tch
        end // end of if CLK = 1'bx
      end // end of else of CLK = 1
    end // end of if flag_clk_valid = 1
    else 
    begin
      Q = DataX;
      corrupt_all_loc(`True);
    end // end of else of flag_clk_valid = 1
  end // end of else of LS = 1
end // end of block blk_posedge_clk_0
`endif


`ifdef SNPS_FAST_SIM_FFV
task WritePort;
begin : blk_WritePort
    mem_core_array[ADR] = D;
    if ( !mes_all_valid )
       mes_all_valid = 1'b1;
end // end of block blk_WritePort
endtask
`else
task WritePort;
begin : blk_WritePort
  if ( ADR_valid === 2'b00 )
  begin
    mem_core_array[ADR] = D;
    if ( !mes_all_valid )
       mes_all_valid = 1'b1;
    if ( ^D === 1'bx )
    begin
      report_unknown("D");
    end
  end // end of if ADR_valid = 2'b00
  else if (ADR_valid === 2'b10 )
  begin
    if ( (MES_CNTRL == "ON" || MES_CNTRL == "WARN") && $realtime != 0 && mes_all_valid )
    begin
      $display("<<VIRL_MEM_WARNING:address is out of range\n RANGE:0 to 255>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid 
  end // end of else of ADR_valid = 2'b10
  else 
  begin
    report_unknown("ADR");
         corrupt_all_loc(`True);
  end // end of else of ADR_valid = 2'b01
end // end of block blk_WritePort
endtask
`endif

`ifdef SNPS_FAST_SIM_FFV
task ReadPort;
begin : blk_ReadPort
    Q = mem_core_array[ADR];
end // end of block blk_ReadPort
endtask
`else
task ReadPort;
begin : blk_ReadPort
  if ( ADR_valid === 2'b00 )
  begin
    Q = mem_core_array[ADR];
  end // end of if ADR_valid = 2'b00
  else if ( ADR_valid === 2'b10 )
  begin
       Q = DataX;
    if ( (MES_CNTRL == "ON" || MES_CNTRL == "WARN") && $realtime != 0 && mes_all_valid )
    begin
      $display("<<VIRL_MEM_WARNING:address is out of range\n RANGE:0 to 255>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid
  end // end of else of ADR_valid = 2'b10
  else 
  begin
    report_unknown("ADR");
    Q = DataX;
    `ifdef virage_ignore_read_addx
      if ( WE === 1'b1 )
        corrupt_all_loc(`True);
    `else
        corrupt_all_loc(`True);
    `endif
  end // end of else of ADR_valid = 2'b01
end // end of block blk_ReadPort
endtask
`endif

endmodule
