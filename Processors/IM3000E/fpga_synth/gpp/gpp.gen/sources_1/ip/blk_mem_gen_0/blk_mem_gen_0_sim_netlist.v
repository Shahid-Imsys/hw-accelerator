// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Tue Apr  5 10:09:58 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/markar/checkouts/ImSys/master/Processors/IM3000E/fpga_synth/gpp/gpp.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcvu9p-flga2104-2L-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    wea,
    addra,
    dina,
    douta,
    clkb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [1:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [2:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [3:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [3:0]doutb;

  wire [1:0]addra;
  wire [2:0]addrb;
  wire clka;
  wire clkb;
  wire [7:0]dina;
  wire [3:0]dinb;
  wire [7:0]douta;
  wire [3:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [2:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "2" *) 
  (* C_ADDRB_WIDTH = "3" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     1.648818 mW" *) 
  (* C_FAMILY = "virtexuplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "2" *) 
  (* C_READ_DEPTH_A = "4" *) 
  (* C_READ_DEPTH_B = "8" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "4" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "4" *) 
  (* C_WRITE_DEPTH_B = "8" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "4" *) 
  (* C_XDEVICEFAMILY = "virtexuplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[2:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[2:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[3:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oESHD2Q5NORrmTVTCApB+YFZJwjA1ezq7U6VZh96by+ofPCvSFp06AIoCLvB4BhPvxfob6kIkBpR
xVCOLM7HsDk7nO1JVWiYIJ6okoWTA8hAlPj3sdGuMwRlZNSBKn/c6F+CW5Jl37TEGotkhycSB3Bg
B/uu1THUZwIG87RPahE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RovEhaqHrFqzjckk+DIWG8LQeqg2Y/nACQDyXKKtSav7YHlgpKmgHZnsxwwNpqrqVRGyjTecSQ+e
6Mr/Pi9au3AgJVPL6VOgwNVE0yj2LpA4LPyWzxLN3+DiSDmsaCBNCBlVQi2MRKUabou8nLaXldbL
+7pv4pYhQdcyjDzuC2dx3HmzADqstdEiyXeU3ktJ29CDLDmGwDWdmsrl90s4YQSfBV2nj4/Vut3L
p/8dzphf1htPaNMujMxxgp3z4JzUEDJJokDL+gNutEEHiaWpI3URIA5v22vJu+NPD+eEraSioHfL
DPKAajZTwK5FHnonu4O2D0co8GWqWW5cUqZz9A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jBQ6Th9yy7jtKQD1h235YLT6qO6XiBaBKGJrV1Z8H9M9ePJ9R/fA8E1okt4LyBvoWjR7tmCbIg7A
0/vuKOogkLtDE/BtTlp4z1iurO8rQrAcdZy/e+7GATawyJxFY7kZhnXASu9zB8TiOBELSlapkpxe
WuAzXLde9FBMBkq4RSc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eucSNV2Zbm4zYc2tIGRlGmlVM8+WHY1NHe9drZdgDhGPOHz8PTqHapfnZ1kWuTLtPBLSMvcXNScn
UTvpULofBV6qD7WHLPg7UJcjpZVDL69lk88chgqrlc/RqaJXKNVv+Ubku53ZLU20uZK71bNymjSM
855RVWw5lvTHTCNC2MYIS94Fmrzuq8i0+tFh5qBKkHK2BC+fD7xVyyfuh4mZR2yr/hRs/emoI79E
IKoJnLiglVp6RXTsXFzZW4pIthbjWSuZlOQvoYkS2RMj8a0r9lyariphRQunoudc0bLO4Phk578c
40gusaaS/MI7idMT7k1Di96kvu5mHi23loRcZQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
E/syLaRG2Ss/xTTkuAkOKXzm53+rCptYO2DkVukWhvlLmEB2daHCPrXt4gKeuG+0hIGWedSwCiLJ
7KNtEAiTumJ/j+3p7s3oXN9ftCSRolXoACsCclEAmwYjVM0ubCXUx6JNFOGt0yDl2Jsd5+W10mSJ
bYEKvRKi7koXM/eYJqbhTrtsrHDwRJEY0JVUPh8EOkLLqaIKbnjb6ENEY6qZOamp5PaWsSS30gJM
N6fB8D1AmGKnFbfY+d5TexS55Z92aYcAHNX2XwHsKnm45az1vHeZ0rTEU/oONIaSZfikRni1iDBg
x2GOue6sLiwxTEHaVkTJsOVR4mx0VsfFxavwRg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dSHHpkQiOEzzKs4D71WVyDXLpkKuR9h9h3pBLtnCq2bXiwE/eQHmk5HeQb+qREg0Yv193OukqaQz
RZyuF5GQcqOpqFHMxO62HQ2pdjdpMT5CC7gHvmgiw9qBkJJrXpihIHER4X7OF2iNUfeqxJ8eiSz3
C0V20NlIwKG7Mxg8MVj++xmb32KMUqL7ptikkym20vVdhecVMNvpPoXp8uvaGT7991enWP9HGKUC
9kLY2DEYwRGE71UJJLGWo4n49R50ExFRj91xWnYfvp7uJsMNwnBp5l3GTZiMELX2RkRVSPOHr7l1
n2p5Vq7Uee2drny1IxZ/4c0hYY6y3QWSEqpESw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HUtfqZ9dh5oZTOAt9a0ebo+wQbzg3izFQ0kVqZN81S4cBjQEF53WUiVlTKBDVjvLNUby4Se9WZjj
j86TQzuGJxLPDTohmbytErsg5JrlXHbHGwR4zGNGTbBs12X7PkxtS8wVCp+7b1rX6pOGOPqm6FoG
g6rZY/bTzVfGYF2CAOhjJUqUOXEAKnZRehspRyiBI28/ZZPSAUD/abKprW8PWCxMx2zPWztZz4No
R96jgvHezNzB1Ta8W7uRBFTMp+XVSToxTp2jzSXJZ0V5xJl+gdVjAMmf6+te2vqrK2wDWdMxk3Sf
iyLI4d0s25vCybcY2fZWacq5iO9pSlSaOQWgCA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
vYYu2Kvhv3RZi0pFbjRTQ/BBwfilCrGpkMls+Dz6HBGTZvSaC/anWgymoDS0XnoSENGG3Pz3EBF0
19OqLbyna95IHFe2bA7f8RgU9SEUffZ8eXGigfOjAWpZCN07Q77RkhGUKal7okWe3Q6xHtZy83l2
kW8ma3kOYL7GzQjtpbP3lINHLMqpGEo0dzbOHiJ5r6W5U6DsILGsoLQOXcw+MwrevvNRB0KkSklj
QnL8K2AK8PIsJGM6F8dj5KwRYhSBYNb1opuVpiJWlbHgADoeM+dhiRxBLmnaDE8PWs1ReY6uMzzH
SvvO6UEyxQtvS/Smm/uogr1eUFedUaBHPMEXnYlTAv/SKrh942GeknsqfrjGkZxWTN2NEnvpRUwT
fS0pyd/Err0s94b0srmcTYyxZfJGRUct2T8MCphZFaScAlhn655pxW9RaHMfcvDJUHpW8Qa+KhRt
9CWYScPIH6YNDByLQbhKL5BTpAYMNYPF2W7vM2ZzDob2NB7m6GGeKRr3

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QSNmIeTT4pBji+CTjknWXN6sH9Wff8+t8KF+AC3fIoIw08jtLtShcB9ZGeEKG02RGCO4lNIUf5YB
2TVYk6EJ5XyCav12qDhc60n56UVrnpfo7drorY0NmOypuxECgO43h6SDWp9W7px3r4CJnQ4+X2Mj
943GdP30WfL5kbWHZJC1Dz9cBIqRa1EbNXvvAqBvRPS2+aXBXAPOC4rNVZGeIUspn/33IW3yJLSp
Jm5GIct87ZuSoz8+DXhUvsTj4hq8lgirVhfz1qhHm8SfODcE91FGUPw3vbpGWXsBX73t2zxFC1Hz
/6m4YqQJVxd+H5iGE4kbHxHyHnH7FIerqc8Phw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UhfxKxECbuHK/o9ZExa2zP/MIPmFXuDNZwgpiawuBmPeRI1nJsYB7vzbBGMPKny4yIHLT8mHrQRc
fs05atkjIAbLea4+WNoCdCeg7/0PzuodM1ol3it6BHQ6Yzq4mnZbzlk8Xtwmk8ACAbzOr2SYxYWX
ueuUlimUSRusIe4+NiPvzbfHMAOVPjdmSY7zaSyeJuhdAR+fUGeHy5B23Xe2X6cDPeJ75IqcBeul
ox3dTXi3L8r/s1bTKX3FhxRyPZuh/xCWuEajsF2fEYdwWHKtLX6IQniLBJ5ZnVSS8D7IYPsvV4t0
9rWJqto5O1n3rAM44OvKvc9pOYXJupuv7g3gWg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fmo66vhS7nigYtLDMjdj7hgUnDG/fnO+cIaY/3qHrcwT7u/paj5enLuWHovegu9O9WRq3pPNnjuN
6vZRpuCgz5p4VAV7dVg9fuzg99BAjThp1Q/+HIPfdQ2LM14ZpTh4FXxthHGkTyS5PJArvZ3/UMpW
zwfdYd5+k2/emJ4/nuqoJHQG8k+O5EjSprLTvNZ/wrE1cT/fW/Lu2pxI4msHqVVYAXz7sJ13cQ+C
7tKxCV8vTyf0rpStdE+kZXg+jrc7vFKuPJO0U9axMsC0nXyeYx2jzfAHptGWKvfQaPg/Eo9mgLyN
qSJfFS6aIycuxNmg7L82WK401aWhnUn7GNrudg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22256)
`pragma protect data_block
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
kbOBbnWZPM+BUvHk40YLnZ1X6dCooRPl/l8=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
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
    reg GRESTORE_int;

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
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

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

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
