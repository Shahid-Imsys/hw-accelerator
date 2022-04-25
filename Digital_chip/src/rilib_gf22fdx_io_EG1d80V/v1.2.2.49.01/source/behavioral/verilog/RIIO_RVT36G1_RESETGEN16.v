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
module RIIO_RVT36G1_RESETGEN16(
		  CLK_O
		, RESET_N_O
		, EN_N_CR_I
		, EN_N_CS_I
		, RES_N_I
		, TIMER_I
`ifdef USE_PG_PIN
		, VDD
		, VSS
`endif// USE_PG_PIN
);

`ifdef USE_PG_PIN
inout           
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer inh_conn_prop_name = "vdd";
  integer inh_conn_def_value = "cds_globals.\\VDD! ";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDD;
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

`else// !USE_PG_PIN

wire   VDD;
assign VDD = 1'b1;

wire   VSS;
assign VSS = 1'b0;

`endif// USE_PG_PIN

input             EN_N_CR_I;         // (active low) enable clock during reset
input             EN_N_CS_I;         // (active low) enable clock when counter has stopped
input      [3:0]  RES_N_I;
input      [7:0]  TIMER_I;

output            CLK_O;
output            RESET_N_O;


/////////////////////////////////////////////////
// see doc for voltage/temperature dependency
  parameter real FREQ = 100;                          // MHz

  localparam real clk_pd  = 1.0/(FREQ * 1e6) * 1e9;   // ns
  localparam real clk_on  = 0.5 * clk_pd;             // ns
  localparam real clk_off = clk_pd - clk_on;          // ns

  reg        cnt_run;
  reg [15:0] cnt_pos;
  reg        clk_run;
  reg        clk_int;

  initial begin
    cnt_run <= 0;
    clk_run <= EN_N_CR_I;
    clk_int <= 0;
  end

  // trigger osc and counter
  always @(RES_N_I) begin
    clk_run = (RES_N_I===4'b1111) ? 1 : ~EN_N_CR_I;
    cnt_run = (RES_N_I===4'b1111) ? 1 : 0;
    cnt_pos = 0;
  end

  // increment counter
  // stop counter when timer is reached
  // stop osc when requested
  always @(posedge clk_int) begin
    if( cnt_run ) begin
      cnt_pos = cnt_pos + 1;
      if( (TIMER_I==0 && cnt_pos[15]==1) || (TIMER_I!=0 && TIMER_I==cnt_pos[14:7]) ) begin
        cnt_run=0;
        clk_run <= ~EN_N_CS_I;
      end
    end
  end

  // build clock with potentially arbitraty duty cycle
  always @(posedge clk_run) begin
    if( clk_run ) begin
      clk_int = 1;
      while( clk_run ) begin
        #(clk_on)  clk_int = 0;
        #(clk_off) clk_int = 1;
      end
    end
    clk_int = 0;
  end

  // assgn outputs
  assign CLK_O     = clk_int;
  assign RESET_N_O = ~cnt_run && (RES_N_I===4'b1111);


specify
	specparam CDS_LIBNAME  = "rilib_gf22fdx_io_EG1d80V";
	specparam CDS_CELLNAME = "RIIO_RVT36G1_RESETGEN16";
	specparam CDS_VIEWNAME = "schematic";
endspecify

endmodule
`endcelldefine
