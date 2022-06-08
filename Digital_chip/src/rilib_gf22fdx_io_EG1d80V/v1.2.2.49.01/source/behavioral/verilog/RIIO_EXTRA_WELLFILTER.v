`celldefine
module RIIO_EXTRA_WELLFILTER(
`ifdef USE_PG_PIN
		  .VXW(short)
		, .VXW_FLT(short)
		, SUB
`endif// USE_PG_PIN
);

`ifdef USE_PG_PIN
inout
`ifdef USE_AMS_EXTENSION
`ifdef INCA
(* integer inh_conn_prop_name = "sub";
   integer inh_conn_def_value = "cds_globals.\\SUB! "; *)
`endif// INCA
`endif//USE_AMS_EXTENSION
 SUB;

inout  short;

`endif// USE_PG_PIN



specify
	specparam CDS_LIBNAME  = "rilib_gf22fdx_io_EG1d80V";
	specparam CDS_CELLNAME = "RIIO_EXTRA_WELLFILTER";
	specparam CDS_VIEWNAME = "schematic";
endspecify

endmodule
`endcelldefine
