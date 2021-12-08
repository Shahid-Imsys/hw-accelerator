// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Nov  2 12:58:04 2021
// Host        : LAPTOP-8S3BREPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top c_accum_0 -prefix
//               c_accum_0_ c_accum_0_sim_netlist.v
// Design      : c_accum_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku5p-ffvb676-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c_accum_0,c_accum_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_accum_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module c_accum_0
   (B,
    CLK,
    CE,
    BYPASS,
    SCLR,
    Q);
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 bypass_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME bypass_intf, LAYERED_METADATA undef" *) input BYPASS;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA undef" *) output [31:0]Q;

  wire [17:0]B;
  wire BYPASS;
  wire CE;
  wire CLK;
  wire [31:0]Q;
  wire SCLR;

  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_XDEVICEFAMILY = "kintexuplus" *) 
  (* c_add_mode = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_width = "18" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "1" *) 
  (* c_has_c_in = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "32" *) 
  (* c_scale = "0" *) 
  (* c_verbosity = "0" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_accum_0_c_accum_v12_0_12 U0
       (.ADD(1'b1),
        .B(B),
        .BYPASS(BYPASS),
        .CE(CE),
        .CLK(CLK),
        .C_IN(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "0" *) (* C_AINIT_VAL = "0" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_TYPE = "0" *) (* C_B_WIDTH = "18" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "1" *) (* C_HAS_CE = "1" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_SCLR = "1" *) (* C_HAS_SINIT = "0" *) (* C_HAS_SSET = "0" *) 
(* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) (* C_OUT_WIDTH = "32" *) 
(* C_SCALE = "0" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "kintexuplus" *) (* downgradeipidentifiedwarnings = "yes" *) 
module c_accum_0_c_accum_v12_0_12
   (B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    Q);
  input [17:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output [31:0]Q;

  wire [17:0]B;
  wire BYPASS;
  wire CE;
  wire CLK;
  wire [31:0]Q;
  wire SCLR;

  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_XDEVICEFAMILY = "kintexuplus" *) 
  (* c_add_mode = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_width = "18" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "1" *) 
  (* c_has_c_in = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "32" *) 
  (* c_scale = "0" *) 
  (* c_verbosity = "0" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_accum_0_c_accum_v12_0_12_viv i_synth
       (.ADD(1'b0),
        .B(B),
        .BYPASS(BYPASS),
        .CE(CE),
        .CLK(CLK),
        .C_IN(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
R2WRfNM7iQfVezffU9mXj7DNae56tUQw2KSdDdI4OGMYB65JnERrwsR2dRInx7o7wH1Brw7ehdso
AxemvL19bQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
umbbDadnux1HIv/f5nt3od0S8xUq+jhzaSGi+5TlPeW6L931zufNZnEKGpZodz45bXX8TxhW8JI3
J12xUnskyRF5krUTBcSoqcMJr8/06+d4nJHedF3WjWnW1gHzNmrJoEUYRigH104FnWzebk1isRIr
uCSdAzalikXhTX0SEiY=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
aTp1eCjrnU1khDqTWy5d+cZDPSAuxQwnTycBPO6Y1aMzqpnXGjhvaNSjYXFh2XSlHbf4EwbDRXqU
K1fW9WBj/U213OBYmro12wgQzjA1GAmNMXMBq4GK1HGbW169XARW9nfzhl95a9jV6qi506hsEK67
g67p6VIHSrgUnhkZ7ez3DpVagtvsGEae3GAFNgKRL9EVO49cxteh3tlOPfgwheDs9USfBIdfa+yB
QV+scaeiQVLOFvXl8t/kTdLx9lEicWLFzNKOE2sVSGZgPvd7fUwZ+y8EtoKTrXzK44aVJvVOiD6m
vTmmSUPCpRj5wl+f0jclvvc86ycqX4gvC3iA9g==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XM69JFnplXxalOK99DHcsVHn16k5x1wa/VRdDOR58eYORKM0EfVwK0CqBgG8xVMVulfojxFdppHa
yGzaeL+A8AqbG1w70JWFTru1upLFxJuozxX2AsOo3ewr3ws7tRDZVMoI+uwVgZ+8VyIB/p71YZL7
rWcStJAJWwPmo7JMDVGi7O7lywBtA5r9pDxBRPh6eYRuaLxSllrJAj4FkFA7JbGriJzj3vSrW+sP
7Zs9EBsxbXI75gcdVEvJbPoDfHmbsViPVMyQOXi7zo5w4MNf/nCnJadJLRYnPM6TgOZRxGY9i6Bu
y7FVhmgG241mQi5/8FcBdJy6U+4iQZJHbfZXYQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
h7a3PoBXWVyoTzWRLpoXTe52cvA8XSFHzkgYj56I8Df/WDYXD99No7bXQK2NnBnU2QTR0UtLY1nm
c3Ca0F55BQ2WArsbuUl9g6xAtyCfQkQrh3iw3CCTKKVgac4/wGTyWAL71gLKQ/587QYPX1oiFHop
E1F8SfYj739DqBTi/GIHwLA5G+XRYBT9KgQMBbliiHiRNCD35p7ZrngSX7j5x5Zyef78BbsLpSN6
nfBLa5KhSRE+anTpxCjDOtMId/PIp8ggvAFfA96aXOGMlF9WOfoTzYIHSU56BvDQJlUYzJzWD8vZ
HdQZe6g1qfOyVcETeM9SLE9f18G/ypg/cJO46Q==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
hcaOEOxV9amYvmRV9jFkhRHpbu8mNofSGci7o22h0i4J4+5anRkzdXz5ihgmJJ70fzRge/ZpF33A
xGQdRLzSOJnx/0BXHpYpJZmNIHZSMZ623YSrTvEuvaf9YdF7lNT2gUcY1z138BwEKukso1UEBSoj
d5NwAziWrdV5rD1He1s=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
X2Xllt9uFeKr6FIBXnJCIzB/ea5RHsUZWPGsJj5FMTHs70YYPxMdlvhX5fMq+3zwRnGLBh2AXlMP
62zwKGikYjtmAJgWsxVxeIAfmLNIoWeJDb3CXVosgoqn1IqFssNWNDKdTGYe9MYTkqRd6QW6R2GX
BnNBdOhSsi2zKr2+y+xqOwoH7yi8jopYEdPIrgHJT58LYcR3uUtM88nga0M2yiwOK20+2btxZLos
JeF6J82bC9r9xvEViWwuspHvhE8eSkL6x7eqB+OIOpF3PFLbV8OmAoKkOBmTuulR3Jj8MFacFgZM
Bvy/68az8+wRddG+v+zCI368BrObIO1JMPpnGw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UScxPebcxwq3sZF/GwvHX9Lb0sNqwhMV4pT1xHcuDTuJKmW8Oas3OT5s47iC7b5Wyre61lPrJpNa
qAPpzADWoFxHaG59GNDtGF3qyhu6Hh3GD0jGx4QQ0lo2/qE6oSUOOKCqkfT6mI+ySIvPc4/h/dlL
ArfQt9T/s9PIYQZZm9QXzxKn1YEaLHI+EhizLeNB9PplubD0jXcAfqu6BhqAZ+iiopOBaLA7V3W2
iMmKEzv00CUIne5M5NsIBexvCOOOyvVlsjctlvZBbMd7qqEra4M/egRa4FEoNbJV50CfPJj+wxbC
BuJcm7HmbVj0J2D+L1qIJPSrcUSYJOdxA6u1+w==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
11vI+GtfsxW4MdZrEfoG7hBy/BzqjNLp14MK2lQgA8KqfqVTQqJX+1si2ynSaNwQVEw0fj2OhVv9
Fs6pXvYjrDGDYBOmdVgqEri+YJQaW6va2TAF6AVwlEmlz7faOL9oeYMJmsQ+WrcBDVN0/iw9HxDA
BExZq2NAxhS6gD68ta3AgBPI/rOnO1b36rRxoZGGRmO46L8pj7izr/o8J5yB6mAfgJxQmMb2SARr
R1Yd58cgQMMahIHaUUwSm0Q2LJUA0kL6bKo2+KphDXkYj7cH5v1WcBkDKIBGCx89sVvrRM6eaPX4
0uHP0Zj9kiF+JBeJRLh57ttXHMQ7ppRvYnu59A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28384)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
