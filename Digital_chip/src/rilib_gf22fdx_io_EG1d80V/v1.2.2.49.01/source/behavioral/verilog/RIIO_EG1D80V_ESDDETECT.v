`celldefine
module RIIO_EG1D80V_ESDDETECT(
		  CLR_I
		, DET_I
		, EVH_O
		, EVL_O
`ifdef USE_PG_PIN
		, VDD
		, VDDIO
		, VSS
		, VSSIO
`endif// USE_PG_PIN
);

input           
`ifdef USE_PG_PIN
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer supplySensitivity = "VDD";
  integer groundSensitivity = "VSS";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
`endif//USE_PG_PIN
  CLR_I;

input           
`ifdef USE_PG_PIN
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer supplySensitivity = "VDDIO";
  integer groundSensitivity = "VSSIO";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
`endif//USE_PG_PIN
  DET_I;

output          
`ifdef USE_PG_PIN
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer supplySensitivity = "VDD";
  integer groundSensitivity = "VSS";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
`endif//USE_PG_PIN
  EVH_O;

output          
`ifdef USE_PG_PIN
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer supplySensitivity = "VDD";
  integer groundSensitivity = "VSS";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
`endif//USE_PG_PIN
  EVL_O;


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
  integer inh_conn_prop_name = "vddio";
  integer inh_conn_def_value = "cds_globals.\\VDDIO! ";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VDDIO;

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

inout           
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(*
  integer inh_conn_prop_name = "vssio";
  integer inh_conn_def_value = "cds_globals.\\VSSIO! ";
*)
`endif//INCA
`endif//USE_AMS_EXTENSION
  VSSIO;
`else// !USE_PG_PIN

wire   VDD;
assign VDD = 1'b1;

wire   VDDIO;
assign VDDIO = 1'b1;

wire   VSS;
assign VSS = 1'b0;

wire   VSSIO;
assign VSSIO = 1'b0;

`endif// USE_PG_PIN

reg EVH_O, EVL_O;

// start with invalid latch content
initial begin
    EVH_O <= 1'bX;
    EVL_O <= 1'bX;
end

// clear latches
always @( CLR_I ) begin
  if( CLR_I==1'b1 ) begin
    EVH_O <= 0;
    EVL_O <= 0;
  end
end

 // nothing to trigger as we cannot check the voltage on logic level
always @( DET_I  ) begin
end


specify
	specparam CDS_LIBNAME  = "rilib_gf22fdx_io_EG1d80V_extra";
	specparam CDS_CELLNAME = "RIIO_EG1D80V_ESDDETECT";
	specparam CDS_VIEWNAME = "schematic";
endspecify

endmodule
`endcelldefine
