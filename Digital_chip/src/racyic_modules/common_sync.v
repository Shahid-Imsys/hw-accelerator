// Company           :   RacyICs
// Author            :   eisenreich
// E-Mail            :   eisenreich@racyics.com
//
// Filename          :   common_sync.v
// Project Name      :   p_ri
// Subproject Name   :   s_common
// Description       :   common cell for 2-stage synchronization
//
// Create Date       :   Thu Jun 13 11:59:54 2013
// Last Change       :   $Date$
// by                :   $Author$
// -----------------------------------------------------------------------------
// Version   |  Author    |  Date         |  Comment
// -----------------------------------------------------------------------------
// 1.0       |  eisenreich  | 13 Juni 2013   |  initial release
// -----------------------------------------------------------------------------

module common_sync (clk_i,
					reset_n_i,
					data_i,
					data_o
					);

   input  clk_i;
   input  reset_n_i;

   input  data_i;
   output data_o;

`ifdef FPGA_IMPL
   (* SHREG_EXTRACT = "NO", RLOC = "X0Y0" *)
`endif
   reg 	  data_sync0;
`ifdef FPGA_IMPL
   (* SHREG_EXTRACT = "NO", RLOC = "X0Y0" *)
`endif
   reg 	  data_sync1;

   assign data_o = data_sync1;

   always@(posedge clk_i or negedge reset_n_i)
   begin
		if(reset_n_i == 1'b0) begin
			 data_sync0 <= 1'b0;
			 data_sync1 <= 1'b0;
		end
		else begin
			 data_sync0 <= data_i;
			 data_sync1 <= data_sync0;
		end
   end

endmodule
