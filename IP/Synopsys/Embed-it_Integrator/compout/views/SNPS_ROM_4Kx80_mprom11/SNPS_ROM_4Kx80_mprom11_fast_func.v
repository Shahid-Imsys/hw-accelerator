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
//  Compiler Name      : gf22nsd41p10s1dvl01msa03                      
//  Platform           : Linux3.10.0-957.5.1.el7.x86_64                
//                     : #1 SMP Wed Dec 19 10:46:58 EST 2018x86_64     
//  Date of Generation : Wed May 18 14:15:58 CEST 2022                 
//                                                                     
//---------------------------------------------------------------------
//   --------------------------------------------------------------     
//                       Template Revision : 3.1.0                      
//   --------------------------------------------------------------     

//                      * Synchronous, 1-Port ROM *                   
//                   * Fast functional Verilog Model *                
//                THIS IS A SYNCHRONOUS 1-PORT MEMORY MODEL           
//                                                                    
//   Memory Name:SNPS_ROM_4Kx80_mprom11                               
//   Memory Size:4096 words x 80 bits                                 
//                                                                    
//                               PORT NAME                            
//                               ---------                            
//               Output Ports                                         
//                                   Q[79:0]                          
//               Input Ports:                                         
//                                   ADR[11:0]                        
//                                   ME                               
//                                   CLK                              
//                                   LS                               
//                                   TEST1                            
//                                   RM[3:0]                          
//                                   RME                              
// -------------------------------------------------------------------- 
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

module SNPS_ROM_4Kx80_mprom11 ( Q, ADR, ME, CLK, LS, TEST1, RM, RME);

// Input/Output Ports Declaration
output  [79:0] Q;
input  [11:0] ADR;
input ME;
input CLK;
input LS;
input TEST1;
input  [3:0] RM;
input RME;


// Local registers, wires, etc
parameter PreloadFilename = "SNPS_ROM_4Kx80_mprom11.hex";
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
initial
begin   : initl_blk
  $readmemh( PreloadFilename, uut.mem_core_array);
end

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
    mes_all_valid_old = uut.mes_all_valid;
    assign uut.mes_all_valid = 0;
    disp_LS_msg_old = disp_LS_msg;
    assign disp_LS_msg = 0;
  end
  else
  begin
    deassign uut.mes_all_valid ;
    uut.mes_all_valid = mes_all_valid_old;
    deassign disp_LS_msg;
    disp_LS_msg = disp_LS_msg_old;
  end
end

`endif


wire [79:0] Q_mem;
reg  [79:0] Q_buf;

always @ ( Q_mem )
begin
  Q_buf <=  Q_mem;
end

assign Q = Q_buf;

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
    uut.diff_me_tch = 1'b1;
  end
  if ((t0_pfirst < t3_me) && (t3_me < t2_pnow))
  begin   
    uut.diff_me_tcc = 1'b1;
  end
    @(negedge CLK)
    t2_nnow = $realtime;
    #0.001;
    uut.diff_me_tch = 1'b0;
    uut.diff_me_tcc = 1'b0;
end

always @(ME)
begin
  t3_me = $realtime;
  if ((t2_pnow < t3_me) && (t2_nnow < t3_me))
  begin   
    uut.diff_me_tch = 1'b1;
  end
end
`endif
generic_behav_SNPS_ROM_4Kx80_mprom11 #( MES_CNTRL) uut ( .Q(Q_mem), .ADR(ADR), .ME(ME), .CLK(CLK) );


endmodule

`endcelldefine 
`ifdef verifault 
`disable_portfaults 
`nosuppress_faults 
`endif 


module generic_behav_SNPS_ROM_4Kx80_mprom11 (  Q, ADR, ME, CLK );

parameter MES_CNTRL = "ON";
parameter words = 4096, bits = 80, addrbits = 12;

output [bits-1:0] Q;
input [addrbits-1:0] ADR;
input ME;
input CLK;

reg [bits-1:0] Q;

reg MElatched;


reg flag_clk_valid;
reg mes_all_valid;

wire [1:0] ADR_valid;
reg [79:0] mem_core_array [0:4095];

parameter DataX = { bits { 1'bx } };

// -------------------------------------------------------------------
// Common tasks
// -------------------------------------------------------------------

`ifndef SNPS_FAST_SIM_FFV
// Task to report unknown messages
task report_unknown;
input [8*5:1] signal;
  begin
      if( (MES_CNTRL=="ON" || MES_CNTRL=="ERR") && $realtime != 0 && mes_all_valid )
      begin
        $display("<<VIRL_MEM_ERR:%0s unknown>> at time=%t; instance=%m (ROM)",signal,$realtime);
      end
 end
endtask

`endif



initial 
begin
  flag_clk_valid = `False;
  mes_all_valid = 1'b0;
end 

`ifndef SNPS_FAST_SIM_FFV
assign ADR_valid = (( ^ADR === 1'bx ) ? 2'b01 : ( ( ADR > 12'b111111111111 ) ? 2'b10 : 2'b00 ));
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
    end // end of memory enable check
  end // end of else of CLK != X
end // end of block blk_negedge_clk_0
`endif
`ifdef SNPS_FAST_SIM_FFV

always @ ( posedge CLK )
begin : blk_posedge_clk_0
      if ( CLK === 1'b1)
      begin
        if ( ME === 1'b1) 
        begin
            ReadPort;
        end // end of ME = 1
      end // end of if CLK = 1
end // end of block blk_posedge_clk_0
`else
always @ ( posedge CLK )
begin : blk_posedge_clk_0
  MElatched = ME;
    if ( flag_clk_valid )
    begin
      if ( CLK === 1'b1)
      begin
        if ( ME === 1'b1) 
        begin
            ReadPort;
        end // end of ME = 1
        else
        begin
          if ( ME === 1'bx ) 
          begin
            report_unknown("ME");
            Q = 80'bx;
          end // end of if ME = X
        end // end of else of ME = 1
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
          flag_clk_valid = `False;
         end // end of diff_me_tch
        end // end of if CLK = 1'bx
      end // end of else of CLK = 1
    end // end of if flag_clk_valid = 1
    else 
    begin
      Q = DataX;
    end // end of else of flag_clk_valid = 1
end // end of block blk_posedge_clk_0
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
      $display("<<VIRL_MEM_WARNING:address is out of range\n RANGE:0 to 4095>> at time=%t; instance=%m (RAMS1H)",$realtime);
    end // end of if mes_all_valid
  end // end of else of ADR_valid = 2'b10
  else 
  begin
    report_unknown("ADR");
    Q = DataX;
  end // end of else of ADR_valid = 2'b01
end // end of block blk_ReadPort
endtask
`endif

endmodule
