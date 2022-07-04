// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Tue Apr  5 10:09:57 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top blk_mem_gen_0 -prefix
//               blk_mem_gen_0_ blk_mem_gen_0_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21968)
`pragma protect data_block
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
HLrk4E+pNdZCHPxTcEr/ZG+l7BYycm4=
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
