// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Aug 26 13:57:23 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top boot_memory -prefix
//               boot_memory_ boot_memory_sim_netlist.v
// Design      : boot_memory
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcvu9p-flga2104-2L-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "boot_memory,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module boot_memory
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [27:0]douta;

  wire [7:0]addra;
  wire clka;
  wire [27:0]douta;
  wire ena;
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
  wire [27:0]NLW_U0_doutb_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [27:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.894217 mW" *) 
  (* C_FAMILY = "virtexuplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
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
  (* C_INIT_FILE = "boot_memory.mem" *) 
  (* C_INIT_FILE_NAME = "boot_memory.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "28" *) 
  (* C_READ_WIDTH_B = "28" *) 
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
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "28" *) 
  (* C_WRITE_WIDTH_B = "28" *) 
  (* C_XDEVICEFAMILY = "virtexuplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  boot_memory_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[27:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[27:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20624)
`pragma protect data_block
QaIDyrWPyqZw01VkrOTAq4Cqk4iF6H742YmyesBoj21/K3BRQXrBZ9r83higDIvbHUiTjqMyw552
W3dr3Vd+91TxPNKRFpHr+TNhALxR6L4+gh1LnnOmds3kf22pwKYP9ozCU7VewmBDqCw6vaFeN7jQ
qOOwO3c0l2hYYeK20dQzA6YjiYvLjekY3wBAzRNfFxu5FnxSwBTBJB9d6m/hfzPiYoL3YGgvTJvt
TtKp7OKz7VItNmcskiKkxGWbu4fGHqfp5EYjOSLUb6VnfIsicjxl1MXU6CrvUt/7QSAAEZgZm7B+
M1vkfWBZAjZoeqOgZGHcsvH3rc6tyrqQ+94i7q3xVuiWolGd/oUdE/3+RHCcRKqPe9kYA9Gd8LQm
z2n85SDSxZZP3szF3NOPjYSxSACz1tagdyEb4Sns+5pk6a3f8LSHrGu9riI6jN7agR7v3dHz1R1i
razUtMp+8UXGgp0GF6RmPH7auATBTuSpBH+tJpy3CY80zhoeLQBdXghGNRQiZcUNuwfVOFjFI7Qj
tdTkvEudEc+hlSEHeihU06eohWirRpaDZVsc1fSpyPGQvy8e9DK5BcMQOsJ62SslIl7zpcpavaKU
pfrNes3VnGjo3vvhYy+v/KIYdNqg/mgw3rA1Ae6C7Fuih7yjSVw6Ax0mck+3IItaEy+pZCq40vfh
cLGZPaEQ5KAp6k8QYP1Tr3CFp+GvMpH72J1p/M+K/wqiDS9bxArzAkkQXHjgEauYK1eiW1PyM6KD
TuZzTCXE34suq5/u69iXE1NNOKyzwPYlOR5CTd5EW4k7C8e5lRMtLN7RRB/LWOQwZILUiZ2Ohdeg
0YZmfdf5Z9vaZBL93++UdfVXnlKfjWgX1Qb/2PkYPR83fEBLUJ96y8UPzP2ifYko759FxyiaVWFa
FfhB/GTziIo+j8v1IKERh3aSWwKttkiXduOtSMJFicoMFDOypo5gQwMMs+D1IzgbXUKuhlo9a7KN
HxKakYZigvavSd5qb3b5CmQf/AYVEBO9sPf29djqFUQf4XOgfmjqXGY1B6r9LvtIsTuU6foCWo2f
diNxxOK3+/9CcEa67HzKgMlxKeOhl7BAcQ4MXFTmPl6F0mr25WmplKdnwevL6FMimWK1rlt2DCQC
9J7NXIbOBJkVY2wabTq8YhITVZgGSSq/h4LUlFEWggiOB+BTuafnZqXo3HZVILCQqdXA5QaDnYew
lfSJNS2XfQdwdeksF/KV8jvxGdD5tn/gwH2PqHC0eev7qrtzbx4vdG1acAGXmgID/H/ve3vQcTtN
STfSCragEMZma4dHnoTx4AF/fA3Ok0t0f1w2hgZx70Du75VPCSnftD97xXRt03FA8swHnaDVzqwD
Tv57Rzw1WhHC12w7Jf2sxmdgqPU/LwP7fVkRsBWN5cmioPxuMJf8RfXcySJ3WyXuo7XiG/w3Oxf5
z6DnlwziITyLj98Z7IGY7GiF3GfjjKKH6mvti09hurjhCfK092p0Hj47tH5tU7Rq163CSW1TFvW+
hdSpC5zo1P0+ESbYX6YaFr6Wop7p7ateeMrSBxDSCkiK9Es/qtT7IOxkcfB58ZPYQY2KCclAddtm
YhztY6YCW2o8u1ml1pMERX+vPmYDUfy+tpv4O9jWAlksw/2kn8qbClXlZACloPCVVEbIjmfRNu4D
l7x/7hHJO7HsRzL2TQKYPxHuUHXNoVKN8b94tKk54Pal4wbpaD4Nwk5Rhbn4jEzvJylyZKGStgBA
xitZtnfk3ftNbcsxMq0w0rkieQUCCzf5a9p1grW+lJXqPLjYqy35/iT7nUDFLilSvz+QWOYMqv6z
LjKtQMnbdQySDPBVS1lnfWOES4gfiqgEuAsvEGSyl8TK15LBn1ozAwjFKtG4/h6J7VZuIoZkBgI4
pcfd1qYLaZVXzaJth41rfe+6lvmE8v31F7rqU84pl9jzVjnUIqEBSMQ6PHv3WpfGdUqDAyq7Kntf
Fir81tFJNeUK3h6J7gyrczZq23TNvWqa/SuRjUrFL5kKObc4YWmLwE1uLLxOyidKnoTogAzx+Fg0
Msc8zrXp5WxuQ9bMoB7rLpC+yXAQdBR7FxPGQB5G+TomNRBBZlshVwv/f37NseSrkSnyvKCcYbay
oA+j+tlASEvhEiXvZELACZ4D++G9PRqFkLlKmVInH/nI2TbueNxccmXjXgwbrDuxo2Y0FOzDhHgL
6ZH5+51njl+TTE6DdFez/KqkXQN5Z5dLfbondVvGfRxDs6UaqH1Yf11H5iBJoH2htCUSBBxR753y
e6nQUA8bx+5iX28SK2Bsdh03Zh+Da9jp2RBms6LG9s8aV7CfdiQ2DDaaYTfHMQEh0jyuzqJ42ulp
xafNU4f51zSue0UCQBCevjqKGpl8dbpCRi6QZVYGE5Wmn/QtYT9FCW5eWdBhhm0Y6XLs4kag8szD
cHtHeN1G9/XB3HnsYpA52ePESVbjVdYiRBDqIZeQiz1PLcteIRE3EDV1vnkzksqaD5bsgcjE7NkT
l6zHnoCN2iXJme7vcUHlboKPiPWuJ8ado6EZp8MfUlzk4c2zENHxBc+jgIwWa3E0D1uMNEhRxpSU
wKO32h2HtANZNRd8QvtcHeIhHQU0GXYSQjuySwCtKDVAlM2ypMkyEW33B2AZ6yb8Uo60dl7GtUD+
BJgOfBYs7SHa+iCDyKSi7h/7MIggVfZbBlkCvCY361ibi9HiKrFlogVYGWgvTHcC36RoC/k/hTWO
6PLhfkBegl3hNfFwBFy6SY50do1tAk96YmmfgEJYXdY5RB5nyUsnELF9CQ6GLCH8tu++T14bY5PX
deZqX177zlzLCKVArrN2eWKcj176//Vp62inQjafLCf/35loMA1yiSKf/219Glhg+VAbEf8SHgDz
C9Tq6QB8fY1s0mEsfSJYeZl84wCrodx6zL3ROX2NVX/hz1dDAzUkZ8xc4Kxfbg4+J16BmA+EVGVf
IvAKPQhPTxpI5MCt+sKS24i7MdsN9n580VB6HACYq66HfmnMcyCzt8W0FrYbwcx0DoXkzpSjsQCb
NyA16slR5gp1FyYtN0XkexLbyIzMVYNpXz54o+eQYiFh/pUqA/Gq5+gxkc9A4eCQRqM7V2ZTdg8/
QfjicBSehOzFG64WcxsmLiBtArS/Rlyw3REbN01+qqwptfUO1OXVrDQOTVBpil2PLXjBZsBZkHH5
FQ1Cz2BF5TCC90yw3HoQwHBKz2Gy/g+jiGqio3W3DF/TkoKUt+viM+3hAXr/ZLY8EbPL9Kcc7tuh
3QHhUQ1XZHdU6uIKKcdVHiNoSGaQAWnRq+oFxC5yhI1OEo0wLO7SexPVATsBzJTmNTmYHBNzuDWy
LT5JMC8cRJKzt3SGMZ/gX5RO5rE2+nEuzkhu+aOdQlno7831FFYzZCOoBcpp1o+7a4LSZC3JTtq1
kxqhnuX1LhWD42jqSd1YBxm7Da373PepXQWJMnU/OdsSz07JjOOzp8W8Sn11NyDl1fC2BfXEE4HS
r4a+sKMnR2YoKYseAK2iak6AAa9mZnZ2rsxLiBNMBVN8dTBK3TkGCoX3vSi4U5TkDRQska7tIsP5
ihWjjD3tqAPr+epxzUiiGjE4ugY8wXoteAiI27a/c0MvuLIdlFOs0Yo10NVmdiA1BVAwRgcVsp4C
tjuh3k2FkOasdphzXVzrp1NRkkYCPj93gHASHLcH1Acj0JqBZf0qYqAIHfetEV5dspwag7T8+24j
xxbETGkUPPmdPzGZPWMsmuQefUCOG3M4gQrs8xxRkbA+I87QgjMgXR/Ih1jKdK3sbD1MMl3kfLEq
DV2b27DwnpG6KMdIxRMWtPZhjugJOuvQaMhMMA7VdYylCz6JBdcjnBXX3ZFBBdSDg7SifBsBEqXU
fwYgfVa37uSg0Ypce0zLdnkLpzgNu+8POY6IcAzoj1/lqqRZFeehosztmHTDX5Yq9gCHlsy09BKE
n+GZBfzll8JaM2KIp7pXmDdrtAXHBc4B8RceLT1KzRjn5HB6HlecHl3GIDeD8Pfvnxarq6vLJK4f
5N7CkUNah++FHuqkJxkRKx9swS7YRrVAxjFPqxZtl3B85HP9gnVxMUwI+bB0zNOvvOSZb1xhfRu0
xkVt0tlfSey98lFA/6PQlMfQuVJ1cVHtT/JUUcrFD4Khq53eS+wfFTstpehciTby/XuO3dmS4CNl
UUWATAi0B/LFyvsM9a0r9fTsmVoslo36d3aHuOXNG+EaW8dCGLwoXmEo1V+gbiUYQ93OhgaZfCJY
9+/l5URrWXMVaMxdhpEAs7lRaomDPp73mYwQUwFu8iw38JsRo3KoErIXgaxx7yVhVLUXm/CPaMq6
/ESp3CNaYry23EaTgNWJxrxvnYvaveSqBKLmcXPNWFZ7jELWggt5A8Sf4rPu0MvtHwhvmfRGglUA
unrmjSeVw6ue4+Qo9aWfe1uuXpJoe1YXUdXNbSpoJWU3JrkMfe83U6fuzfQVpkgMjAQnemOTr/n/
gUPQEivOTGARN1iyfhJ0riEoL7CmVvpniF1xP6/hZ6cku37NTpPRmILERCQaCT/kxkDWosNOfNLL
N7ihVvk3xeowUQ/clqu5aK/1h8Sh6BydkreG+iDUaqQA7TH2J1BmGXhaJBFbLYOqEH39BLEEGdkN
ba9TygM16HyrkQ/GprXcNaJBCnrcVuG8/EeRWxjxFx6GuWTkAhoQcNM1xZ39B8HimsgBXPHdi9Vi
H5m3zRSX1dPphXLY2NFETx4jNRIEc1XlAK1pAninDAwJhDYmTTvK9lNp8wM//pNwqP0W3++lR64F
D+nRZl6mc8fO/FJwaBeBaUKXQbiPD0DJ7N9JpO6Kbwkw3xOWhvYakxQtoptPDyQgzWfSphD6SAzl
B/eGWI3m3VDTwjmF1+tat/aJ4v4tUh1SAXCxR5eLNcYdROiD/Q4kg85tnWldwOHKR6FmKZxkkjd4
kIYFzgZ7czMQ2NpFPQ3xlhJixOoWXbKfZWtQzq6zVfJ7Q5BTR5diwVSnnqPij909ROeuuEVZ9Lze
hP97Fx+XWEL6Ep6EvMPMrquoaGX1++4DfLnZNqgJ9Vpb6cvi5paJYSxuZk3W+M058gCzYwDVHqPU
79TNroPu8Y5+PfpDletJlXmB+kXfsOQK19svHW+WT6egcPl4eViv4/lLzaLb9Opy4uIvLqWqE7oL
cdNH3WCsyWWxau08csm5JiDJAy3ZADbZsnAIMPiCdj5+payPYtZkqFYNalySmZmAYcKkfsBF5VoZ
aNCo0IB0IljjkccM6cplhQswfOJ4bPfBikKuI3aSbL2MIq6ubSE7opA++mwNgmxFg4Nq1lhjV1oD
sUGOz9rOuDmdJtqGzpv6BTjHoddstnv01NGDn5Q7ckuqRN5ST1LIDKdmpUTZ4SXoOteDSebvfS5Q
buaOIW0SQhtG81KvWKV7MuBRACFSOEMN8ltAkMxFnLJwUeMsrvpTlimbOUESYEaLgP9Ztef9fgY/
67Jw9aNjKjYIW/ZuWtJXS+z7Oj8subzXUFihjjo45q0HWcAHNFhjr/c4DmdMHxKgxCn1SiDtADzH
nT1nxqi6mFpeglJMmW8cl4meVPfIddjHXpnqdHf44IHaX3CRxisFI/XVxJd+4EzE0txlJC1PKf33
rNQ6V6vx6ZaAFYeJ5WWhsIUehExszwRqqbjPLF8lqI5rMWD0+0b9KmNYGM9IJr/Bc+sXMb7d2y8T
prJZHNY/si1t40ElUJsH6wZzqtYbo2BAozqYMWF2Il3WToTckX+lH2cRO5i3xqI4JBV3lur+0ini
f/JzSmITl61GWy2SkcKI7f87A5qvrRtvq4ExGK4HwYshoTmCiQBrp45Mc+iSieiJ2t0n7Ykf7dW8
nCheFU6yTHrT3aUZfep23XWpEHRY6lOmNJPZ3wZKv8+GGhyCvZYUln18dtQyH550fxLjyo4oN+bO
/TcKfDdpEV09QUID7frjoaaDQ5dTO/4LlClyQW1REIvhC3hf8vk8hSleIiUJLQ4+kH0N3fQDWuYb
/Cu5CMMy60Na9pAq/ds8ZCkuaikUA6txOchPYMgEaLPNcl6acXNCHk4Kc7FuQi9OeVecv6AtOelv
X566rOw5tjXQC852LmLpDFliiB0b26AVespLL4SJb78YB4/YST0cnJfD9yfF6/PTkNAuUugkOg4Q
TOqcj70ltVm+B2vYx+aBfv0Ti6miEZ4ahFN5kfc/KyEMF1yRFl7ZzH6Yk1KuHJiiFuWY+7WKo7Ja
eCfmgi2av1Cuu06ukmFLzPNIjR1eE9zuoCtHlVY3hrVjt7ScBPeDiGUcdzsi59cadsagpRGoZCxR
IYi7Ur8vYppJyZV5MgJPEHclM0NfQfoumPhoIITqeoqIpc0jOnJt6KmgMvrGYajv84rN/sZULUg6
DFH66VV0d95bMF46bZlzudCRx3Y2GUoOWdDN3Ua8bzRFRjoo/x67a8DYFzU1zIc/ETbzbJymnXeV
H7FClfKOeX6uyCoqVnlnW4e3r+ssZa1LQAivuEv6yUuRdIKGqGIXuKMCnegzuIOVEa9SnPsz9LtE
/zt6G5dl1vdGgC3pz7AeOjCznkFLyHXvNx2jmFUPiqPz31SkU0cqrtTHF9KSFOLJ7T19E3czfLqY
tS0mOs+pt7ZgSPwjVqBUN7GmVA+KHk6hXnCWeNyB6f1z9Ni21HG+0DcJcEplpEvLMeHcvqAkXtXx
jvaL/9pdxoHXTtn4lyerDcRUEtlQuoIF+HscCSOTy3FvVjKjtSFu857NJbr3/4K5c4rZPFMtvwLh
NJsUgnZEBV8wm665xmtvbMFOpqDYInkTy1xegueCUp1FrIxL7Nu2DWogkeZ+EKrq458uh21vjfd/
I2vi7FdAZico2u3BYAJ0qcRo1+lYWKCMIshXowcffqL2FHtkBAi3bmGaqptwBW/1Y2WTZ8bYUxSv
DBj5q0BbuIRvBFQvb6T1qVV/qhsBJdvjhRK0KUCepCGEow29WxWTRtvjzu3orkLn8EX05KxMcE/p
FPWAqtIeM3RTVqlchEoZXobXN1TBZ8/6TSvIKanUZxvCM0lcN3lPYl2rdpnHwH3xqGN7l/xoztr4
bgXDmhoEnmSwpRRR+8TCTsvGh/1+TJlEOeaWOIdXexyjYXiuhMAZ6OXuQnRj+MWN+BlndWwX3/+D
Wbs597GYrfjSzo10ZAX9n4UbRUj2WP3DReat81tCeR8GXkwCleaYNiV+R5XILtWxp1Lgc61LYc04
gkVK2yGvZXQdePrbIwCWdVTNmZWcggKN4svKfLn658/Q6tbhr3bEgWw+snaE/nwmHr+74jP9z0X4
EJul0j0ZrwdXWNGeF7t34NG9SOpvZtcJ9OWfd2i28piJaWjrjwZddvhetBpm5H5yoriXLkoQWXDL
VTyNL3m3y3gf05OKHpUKz4wJOMWN3TtEH/2Nsy4NSUc3cmrCBbwzFZMaqU+b3WC+fG/FtoyXfSve
Iy9yXc6g3Mfy/WwhFZH6QRMxE5Bts9hhM5jFJwoaYgIEklnpYo+IVysoSQQEu85Cpc5KE8oDaKzM
o3G7mqvk57UgV3gB9O+4AnxcniJadL0v1fm77sqVfQcMMq8o+7W0+IfZPt3/BfU4c+690mEOYcyd
6Ca+IdUZlRqUQMaGYb+ootywMzkH7ijPZzsKF6w2vPKqRKAqxMX2qPkZVcc+Df4rAz6TP7lps6y5
vLF7K7XOJTNLEiwzgqHZNxLiglnz5nf7w7w3YHMa5m+Qt82Fyj9uhy2h3ksjHyFhUzH7e2bXL7e5
DyTtyqcK0P/9K5omUCMAPror7as+EmJ1mSlKN1RbA29qbRcqQ2ZmaRTrLvQKDzda1/iLHNN95EO/
4chqQk/Ov1UqzT74E4DENtHsYTsb5cfn2RCcCBvATjpo6QGBxlfjMzu4Dm/sjGlObzMW0jS6wlyp
PleD8uSAe6D52GQ9mzWt3Y11ylEanK4H7/h7W8zWgbXICdcN3vx2tk+DiXJyqPJNmoRALJhzMPFR
cZ1Oyuu8t+6XICQ+/hFrDSypwj/6V2cshS1dqC/emxmeH1vHChsYeeeW6TlL+qPsvL+hfTLapbUw
MirHrpP/GGeCugcWFtKZ9u2ocHF/vMy86jVirjdP47ycTFWgmMIfT40GH98xKBLPX3E2wonGy++k
LwwRe9OXDPM5QvxJ6yi7w9J0MlKUOlhCByKoin0hYghCNeRA3bIgQYT+HEi3fqguju8cMOAxj33v
IxMsM30zOQzyfsocAz4E5OcnvClMMoINC+UnASDu4KqnwDj7UVp6IxCcVgOoDNqxDTsAnyF4T7dO
Wc68ouVIIFJY3gBBf6FPuUAeAMoBUNruRHOT/KpQ8aj26szmh3IyCyIsff51B356zISU1lS1xXBv
SCK4vnEMoUyYQzAqIz8oO7YLCME6mNHp73VadunsHW5QiU+MF0H32XzIRc2DkRiIo7NHuiObGtvO
3tArbafggqDPed/w7QopFFpyDtgqKsVj7o3q8e+KNs/MWKT+EHhu20akcBS/c3zhCwG9qQyVEhEB
x/VSZf7eXUCXCkrzc0gUfBm0izlQjFh0vWOYKW9Aln9wFWLxa7nH8BKDl+gfHUzj4YUkG9LOXsBd
nVq9ZnTrIKtDdJia5qq6LYi8kuFb2aBY4bOOnQccqKcMQASobLAu2ws6jzAgPN18txj/RiE+u4Fk
kL4Y85z/5JACle96kV8Z/swn4WVomm+GR+m/zfC4plvBSEzAmlUJWYIXWSHRAl4+Sr86p6jR81od
PUOQ6C6nAskZCs2Ccu3aZg+zRe4Z8m9dFeX4em38RwGtynu3oGe+IKCoCnJ1zo1Uedknz1y0lVhZ
jvYilSHwYP+0HffCAQyIthwBvTO900t3hkY0mUkZemwgk2tq+eB5hMabu749HylL2fE921Wvvi9q
kgBpOglbCyJvhzKe/9Da516A2KMSQm2QkPpDduWTTFmrH/7kTUqKCP5uh82TQuwEUSJoGSakg6XK
umWoqjI6sTvTe4suFAge6nBOPMX7XX29RGJFh28ovjxYh1zNPcBlxpc3wuFVCdko+dE3yHCJY2Ie
m/J3jv1WC0ao4AVSua6NWV5KGB3e8v1cV3pP7KMLMXrbVfIf9I1LV8CRgb+YXJhMVmdYR8DO1zu/
cy9VcW74TLsQAP5VGDm7zo/KbgPDkbgBFx+ICVTWS4vq4lg59oOks3M6QRHWD1CSRNx/0CNjfRvf
D9Q/m4EBauAj3AEduekU7kTqr+5+xhnFz/8q05BLzTJmfi8jvBaVampGFXskTMht+38D1vwBV3Xf
5FyNRNbElIgqx8ZD+SgA0bE1tFTgfksQXw3RvFUVxom12pz8evfC0uGhUQoHlo86kY99+v1vcQ20
fvfI+cBUyihNNGPxGHF5Cqkx9npQVsG5JRMLlWBVUOcGSgdcBm18ykAGfTis/UijHH5XoLpn5U8q
AypUdKzTRU85/d4rVtvdi0z+XTWUX1yb5WAMWPHkK9GMfbhe6h/01ntIjXDmzTKkT4j9ER0wu/lr
5apmRo5EN1dmwCfJfUH/ogXBVR66GHIovQhBnQqWiyv41KKT0RKMS+btIsK8+ff2XDDAaS8iC1bk
5CY/00tBSQ1/B7zZyYQMoYuVDXayG8iH3pzazpz74WAzTd7euaiftBRbVzvf79YlmeggpJBs0RKQ
9fzr4Z3BBhtF5qw5YFIMiQ/pOTp81k5+k1jajyvxuDlDh1dFcCdzTxS/HxHENTyy3bV45KXsm+1M
MM3ct4/QUCY6Dhe6fjhPfkjOJbVCffM2PDw4JmIHV04O6DS8u2qg0949YRJl/J/7AB+XAqLU2gU7
QQ/n8ouO7Fkq6Q62m2BoGUUAUqCf28hi5ccyAR99bBJ/bRn8oN8UXk5mN+/S2Sg5chSqgLVQKRcN
CT4Bj1tykbHNUWu9+H7sDfbYMULly88R3BQ/9eKz3rkG6RFc6OOo0CGv4Y0gHyQH8Ub7cl2jO+48
sPOXQuC6Z+Oz2gxHwDe6B2x9SFecPp6INJ3ZkFIuQmpovJPUmdNlnuQ4TsJQr0q5DmPrFT/+fmqM
AqjpwrR57GFe61ugzdSGGBaSxfF/Ul4GQK3q1fjlKBGvs39hZyKprg2BVfDsQHKM8QRKaPyTVoKn
cVOf0e9p2gnDMlTxBx9y8SM0DBlyU6WMfOl70G8iNuJigTxtU4E2OvEZ8UxrR9KwtPdkcjVM9JYo
yh00UAOMIDzO/XJrMRTbRV/knRluOFfPB/VqgVlKA6mn8GJ7Gmkb7KiV0H++CKLk8DHbRJBXFe01
R8E5Gs48dy4vYx8479CAsqYuIEF2RQp0KJE/MIAWtG6e4yldow7GspHE0vgS9dfixRQMDgKqdOQH
UnJ0heekAfKqtRZfbPrdkTeetuXlDMcEOmcQqMw5InnhKMhdLUnGcPSibPEN+XxUcgNsUfao36xP
fGoZfnjVjmcFF9yjhnLO+H/ozOykebdk8V05NbLGk0Folw4ER4N833FhuI+8/ffC6tSsuOcZQAw2
T7shcyAlqbHmHEBf4LW8YNOPCWFtJe0kcih2WitdFiscYw8qvtOo8foGNNdWngg76aTvUGm7vMvY
i0IIPRIid6p+I1chgptR5cTuCMQs0cDh/E4TzASjntx2hx6EOn20rNQfsA+CQhDeU6q2NxloHBk1
1hlmf5nkbHg9Xxv6q47xlCBkj8o3xuzLjyDxGxmNt22vC61pMMwR8B87U54uGAcDlA9rpu/inLXw
dAGYxSDvVgR32mDDMWJUxyzKjZwGN7HltZJ3eFMuEgNoFJ9p6ZifMaLNy7IjwTIFhhZjvpz6qWxJ
BuN0IZudThuibFsGRhAWG2g8P6c733qdhkdPMDhE2qUFs1F3vZEb7OF4/nZ/3CMiM4ml82Tf64w5
C2PrTg9W9GtW/8N767Nbd6xB1Mrd5A27goKSBIjUGWYtq3E5ToyJsuyncfguMRqQxtNC2dbAyk6G
2gp4Omvo4TTVms4wM1jzycDFVRf+RZfngdEfvE3Pbcdl1ItvfkVCl1G6tVMKAhp/dQOR0l3Mn2Jz
JbYfZk6467stEH59+tk/7hk/na2Ra3Obt2rX+34PJ/uoq/SMr4eH1ePZly9KyXTOC8fBE/rZKtPl
7kOVqNoHwmh1quI6rjIpHhfWMcUVngLV1YlS+nN5nDsjkiKPAM2fh1iBHVEFt09Sz/kQ1x6Y3QcT
CoTpHvnaf2gENtgielWUXEqH6IJlpcCtY1ZPvV1ziT+giQ2zT20en4EMfqAQZzcxLIU7eKYDmeyE
i1XMUqbMVp4K2ck88xe52sqghsO4RJPXRZPlL+dvP9uOFaQzad0oC9j/nJyDo0lt4B/HWsyYvv3l
pTmovpJsEo2I/gnHB2sDXiFBRgwV+JI1JQNMRBb8Qxke9YCsBTs2IFwGuEmW9NyYuV3/uZ52iErK
FwSbhlPDZ75Wl3bFwnK3j/rWcCAF9UBT42JxD10AJk6Ttt9fbr+W2gXFYy6JMtsqp/Oyhz0jmB9p
He/2baagXYe4DwDjm/ZP4ueDktl9CNmgmiQnoq85t6T4Bto0WeNz9EqVjoY8ns7iSQiLZElHIiXY
uTKoOZMrlS89cZv/RwGgCrvibeCecyf6+MDT4/cdbUGJeNA8CVFGMc36WGYaZAnDDS5XcOX+WErP
ay179QaSqm56ggbgVeKvuM0aJOvY/yvZhN4r6YLaJKVvo76r1GhChpM7Ol4x5M/VUtLUPovXh0D/
SY1TIJtBbBDre5Gr6Xg6wiLK4f78QjiBsmynu+CGU71xgaoy4N3MMGnJIJj07ol1ymMu7PKrl5Qc
YF8ozFXbrn7ta7GFuhWcd2jaHEg5lFN9w1JZYkGys8QlDHRwC7il0SMxpI+l5d77kaOevQ594+VA
1fQe1CRNiLEmLfC38tbGg4IofLF8+lGIVb5iBQ3kRySJVAeU2+C/QmRKI1JKsW8PX1u/2nNv5T1D
CpMCTXoF2aDukeUgEYu2uTdqcSZEYZS+meUxzXAchCM9q9kPnn9jZ5OIRUFv8xVbJLYkNhMMNFxN
iiY72yVTccTTgiUpfgsXUVvkjsyOgG678UnbtxkcFLGtGsWP0x35jU4vgQqSwsAtQFKIJ/zpGXqB
DGf8xdN/X3S7KcVK11R+qjAqGp+p4OcZhA0gpKGeV71S0I9z+DDhVmw00pwzagoRv8tzpyCOH6G3
jmeB6fPIzzSl9cAx5uGYtv2E9lGwUW2HQMsDigXptAEbGKA8XOwSZmi8BSYGOfNzw1fzUCwPvRXV
l50vYLSheBFpJHrhVNd9TZpstAqaQOVYHGg8Q/yqYj/X/buVyl7Y/6C1bfX81yPI5+2hIoLYZDLu
Pz+hRBv7cDSkJHtchc9Uk3Hiftk5Pomz+NDPGhmCKBh/MzmqIOpC3eI5qPsFO0ZA09U959B7UKGf
yK8ngGKkxx5rtZ4YNc5G6P4qMrBEoUKxr0HM40BSkUzni9NI52FYNOaEYSS6G/pkn6x5swvJdQoy
d0VxPV5+851d+GRA/aK5+3iqNX8925/SeL7tb0Txm9fi3qxe6FlVJqMxPomzyHOuY5xHDS4MSIjV
JyklrWIJuZCzAebvOfkpVwKn+uSvx29OdZ7hAgttp4TAx+44Jj2Z+93uhS1e1rNeU89P5JsWbw12
BvY4KPIEMU1R6S0kvJuq9aB6GW1AlYZZZKCPrh8/NVNUlSZ9H6FM8SMBWPmftVlTxkTzAt6DwduP
wGHptedMn6dQgyrRQrGc4ymz85mWKjweG0WLZZvcy3fbFiiZfI9l10tCQl6kmIO38eHX2vKQ5Lva
ZIlterPKGAmjEjQVgGUy/REF8stbALj2Vq2iB8MxECsb3eNprXR2b/CAxi6RhHJAKoDS8O3GOB7D
mL6uzW6xXB7+cZHIh8BArgFK1ayn0Q2lHI6Ed8WsiUmh0cX0pnF558sIlt/7Tep75lbCYLlpDJf7
JJm5MR4i8zpueag/qvombVgeR8afmkdTgGTOuTVggFA7af8nZI7pS1ewz/OTr5JrL/b4bwoYe2Lh
DXIXy86Y4T4sndd9GC8pdP5wVPxcHD9StKW3gKyZmcr51JTxZ20KPAwDq15m14JNchbBCq0v2E2I
2DL1D6fvVTEn6sP6wATU75bsm5MYpDFLuRd4CmEND8oXvZ6TnRft8NpnLawMom/mJEDg4kscBunZ
OvJUksvqPXUPdKXFwpvEIYLhXVQbJupkK5KY1xNIKllopU5uenjl3Y0hZr5EV/xhCesUtIoABlCE
Y+0FBTA9Vs8ggBCYaZm1ho2oG7pPviQ8OTeYPgB1IQRVCb50rFZe1+sqxmCwez8WDhKiVer+FEKs
7IwpHL9zSVwLGcZ4UDQv7G0E/RwKz76N7aQcuKQxChTuhNycPDc0tOkrSBxOkIEZedJTzISAceAu
tg83KQQQjtqLod8rvHcChDynZAsAVb8HMA3Hmci7zGWP45MTnbT+XNw7QQ01bhM/e05p6bSCO/dm
4PmmjpCREBHyk5twnwyqry3KJdvrlsiS4clof/dSrOhRUMLU5QlXNvGBCkHcrWE9LW937WdjJ95a
9n7wnM9Y0o2HxSG8ooaFy/b0V4TUHbN1sv1VVT157FAJjdm+b0nluE4i4uCjx4E4vfHcL7dSbn53
4bS323xt0FXK5R40PzKzMwAH8zXFbEGBJRAl/JlFjEj3gf6b+b3DqQiE1WzMeclPO0cC1rJdgZpd
siZvgh7mSBRaQSJXMCkX0dxJ1BeDZ7WUVf818zOG2JzgZpiEeQTw502r1vm7gp2WQS4gD+wpfhTy
6sHKfto/d8WR4UbglUNNxdEVUIo7euKwCi2eNGJ7Er4cuZwa9sWYwkMIJMAh2x3vyMAMPtxBfWvr
NXd3tU5qn2SysGFlwiY6GQCjWmLQYNZB/z5vz2KqOP662xlkT7fkFltIJZBMGKpYVHwegXAKumyT
8gbCNT3SS8eaTY0jGCcdD5xYvyAkNcs74IOzCFEc7kz+gVAsxSmVTtqNAeZxKmkKCNQyJdvZYgm6
p7fyjkAsVbwgyFV58jQtpjNmUmB414GwPrcOOSWAykyvkXaakrur9BwGl6SRW8MnxS0xWxI2hzDX
jEAxOsfczCYpy1biUjuoeNc8FZB23H9NCcJt6W++X+/zHXZ25sXqMuY7D4zUORT1QvNfuZaJpeuS
7lInof3pc/Zf25b+qq2KFSDXBadVns73iKUNIQJwf2pzrJ/L4tXjBbQEZ3E+5/TV1nsaJJO6iXk4
BF4YOMHCzpSzYj9kUZEYwCReIHexrLsCsZ6P7itJO9IcnDCHYgNiXCmEpRzDOYYsVPy7d27fxv8a
z2UEBX0aCWaP9v6FaKg7T55OpGwv+/ivxM7LZG0uAeyE8lIt7uXie7uLYFs9uwO71ThWVs8Alll4
TRgNihqAKx7c/WekaA8s9rtXKsllNGoYsbTnqqt4SI4hlhjzS23WmkZG+9/nR88fkyPZcLj+FxNk
0YRb1Je0L+oey82FT0MTNGkCRiGR+HoqU5Y+nFgNA6yUfhXwGAfE1RD658SbUxnIkcw6bBZd4xNu
k8KmECX/I9MMckHZBy4cB5IvHDyQbqV72RFK8WxeyYjNouBiuxnMGb4qeKw6pvkzX5FZc3C1+4eq
JxTPX0DIIZtHmkvfgeX0NRh8JCR5jr8E5WSDIlOd4jpxApAMdhUjjBpqDTVIeWjmt2mBCB3FUB0Z
u/p4t5NDMxQZGu2BbFMXXyCrVUKWyXPPniONBJhiqMX3KqznRfVp5/DezwF/MLMKOBjTdBj2gbBj
8kF5RJ4PiAZCp4bnqeE3inDBtuAfAXoJ2hA8MbT7fm91Qim3Gh9W6yiLLiqWWAlazfnnj4D30Zjl
CCN9EA14soAN38RqGx2HuuEXIGJyCqlGHd86g5Xi/zVZVN129DcIbmivqrcABxfdFOBm27E5HBN7
608/U7jRIVbmyjSnx1lV86GmmMgdWJd0YbKYcvu1mEF6BOk+nX1sW6ZDioW2rDrAgRPbsuBIa9uk
JuKy2pHm6wMexZ3TbM5ekvE2vREbTRRyYfnBajo1OnSj//cm6b3cCY/yPjgDrdpxCI3gVUjY3l7A
q/45M3XmfBQr4Xhx60hKpZzAPwC+uKGhZXF/mY5zItJhZay3rBdSYUGCpyX/NvpxIu8+yLYFTZsZ
mV3m+FfRPLCgoKmKPbZAT8t5/pE+G/g8AliNb3AY107rK2nP/sr1oTU9vF9wHUY+dlYjt6oB3Ysn
zzmajp2xFdXO5Kwxl4hVRiFWU0f7bFxY/5r/p/RECfw9WHu/YdabrbC67iKYOYH5OMNrTuLTqb6f
0woDm88pfi5AHkd4M6X9nonx3Iz9mcxKKitGHeI8/SJB/4KyK6JzuI6cTgabbq9SalzQg5qPCIdX
EFTDpeicVO+XHJ87swj9ehl/w/KkoKZmKLBT0iW74yR62+Q/fo4/0wNjkyaF4H0I9l9yQu2oFNEK
Kfbl2maFumKkHeBnETKjOHT94PKcWvBGQHzs8OV+tImeHcHQLvbfk6bGiOV7SDhVVANkZjAUluh4
b7+vnrl9HSICJSjGfO2/73NoZ4DIS0CxrHrQhGOTshdRukwmhvyrFe6HceRwVKFcK4hbYqnQXAwG
syCJHwjrddJ6uy9ciWOOimj6ePhtJZM8JT3dqPdp7BjjSTdAI4+r2ivoaDMO0OQ1XImsMATeOmsI
yhE3opTDM9zYR/FAE5/N3nYSl5EZ3PW96Vx9tW8JdO+6mab5pz9l4ReW06mBFzneaba+2fouiaeB
0TGYaWCQzk42sV6aL2y6DrMaopGppNC5IDNGj9dyzkZL18E01coWkcOHVrrKpO/p9SzFk60aDzq5
YsKxBKqRCWrrH+NWNBJqj+VSMHMyXXtkO2cdrQdw3u4J6IqMllTQ1DCPwRbqOcCCBkUaCZ5LVunQ
3v/TsBj//hnkmqboVMRb2TU8Zwa6W6fCbEZj53wXPAbpMrp4ei/am1C9DzannKm09e4jb4XcIDYj
jfZC5JpUF/PnEkUS35xLK41/g1BP12rGBzOVXVwWXEKhuPZ08LAy2ZlTKXm7Bdd+vLq8xku8U0Jh
nlPQXB9yYfYDX5fnN6Qbc1aVqp7U6scOUtX50+bkCeuzZo8XxVUWI0GaxZENxhZjykKBHaAq3P7q
mftWLhhJqEZDMPi27phCYghdh7GZNCpskf16VkKcpscZeUBtUkFsDbMvO050KpD/oLxK0mV6mgfo
8gT4fwad+UcnjpyLWUqjxROSUbY8FavlW74987zRrIQBvZYLfLO+TwiyGzNpctO64B/SNi02q+s8
ZNXOFj8Wvq3axl0xbkisPMiQvZmXgBaBFK15nnUwh5YfKgHopF3rpqvocqFbfE5Z/NsZDq24j40A
p6kPyRC8sDbXgWOMRz0ZLJk9XrAYc/xKcItdi0vgyiIcGkv/XhkC4t7dQSTsdV7KEyCGenyOTdzt
3vkD6GysEDit0YciCW9Tr7/4ZP4Q5iB8nN9+uxPM1C4sN1qyyceRcQn5LnWHVigw9ClhJi8R4uUt
yG3XLJSqKlGc76h8TpwPxAOMqNgb/utw/amnm1jAVp69z884A760x2iAJRXQq90ydTIJ0tlVN94p
e5YUMGKon5ySqoLEvgowTnLXg014S/JoyJKFuIAMC/6TjqCHvzpSNFSY4+QCvGpUwXmLdTONTMJD
/V4pxRlmsBAeTHaA6iNN3li9EVy0BA0I/OYz9hIVZWyLN5YtaiF2WuzC65T1LPzObnl8IjkiUZxB
b2Mx+mFlfKxcPggWhhh0X3qDkMF22GjSbQoHFmZ1w42wXNBwZy9Bsw2bU5737ZV8pKI9N+KWLFw1
L3do3wNdLAx9xh4PbMLh9hrlk7kd+5TZtpjA2URCpFnMutlpHkeacOOrmhJy3TuOZzOJdxQ9KqJL
Nb1lsB/gkTrcEjJnJytfA80RbeWMHX1JWZa4h+go89RiezldsYIteVS/mKagwjYll2ljuiUuZeIs
3EK3CpkQ2Iu7EXPnkqQM1LKTOZ8JSK9cCiesptAbEHtQPhENalBFygEzwR6KjpIwniAuod0DQ14O
IV2G0bu2eUvm26tu9JQBt6SCSYKa/fSO9LNtIiPrSG/MpxJsJLwB7jHDJ2lDX30ZZ2VrXhGOjdDV
TQbOXbtv5T+PPONgLVwJWYVP11NQasw2Fs3i1IAuHeBezy0/Pt7JNtq6mlcs1SIFKOT/4aY7oGKm
1vaDVnI77nTE1z3ALCBnhhxzSdX0eGsn+SwPra7hkBsUaeSxz1lbPer7JOZ9psBaLinNmg2fdahF
4U325p1WNY4V/uhFDqZh6AOquwreVSKV1viUcCQivXS1X0fAAMTOAdkAO6F956OOsIg8QST3adpj
nhK39/RZnXtuLwdaZd9O4NuLWfLHbxLD3XfXlZ11QE0ScKppr3kIHF/duKrJdvuIm9F9v704bHwf
MNjvqf+2ZB7qYOUKBR/+3ulFaUkSRmhc66h/U5VirvdMQ820pOr5L7naLkTlbmMc/OM3jvE1alLy
FIdZ7iEQcZM/9YOUYlN57/yUsoE3epsm3VhzK24BvKO9aTWgxjacX9xW9MN1dms4UppsOcOFSSdz
4wimzBtVrKCP3rX7Xiudk/7ZJvfykQUIs4wjw2PV0JqEYtESJJe5Ba/4E357ptEgvlddaEMW5wiv
AckKLUA/iKA+bsSL05B66vlLmCfEHLRXENDq7LqsPtfU4sl6/F4imZYURBsPKxUexxfoBanxwzWc
qNyLh2MEW0ehvQFus/a+K4alxQ4ITUJergCcwCVB1s2omW5Pi56BArapqE+ZEbbOMt9rwN6i8cGm
XRn7J4kaJKd7+CKkPvT0n6gqrGvcyL1CtwxoYHU7uUm3/8H3T+pkSb4CAMrrTfhuIDMgzMYz8Or1
spi4bsKmbSlDag44UOv/3CrHlMcwsNZWWxy1ojTQ1mwpIwwCvWVI8hNuTMhqCRXjoBXZXT3/Rdgb
BxwuA/ick/s49z64YEHV71pFZmueOIkyGkiKkSVscYJfN0CzT1BEz7WMphvRLNX0HOCLECgEQ9DJ
X8nzZ2dvHmTsJ6FCXO9g1edYPfRKpWHMi86m1o8QI5/X9sEit4Si8UC5+gcec73mJHyFC6ht9a6i
vzA8UvDfF0l7Uf9ToW+dLq46a3u9ZU3GdMFhRCZZtVx/E0BjCEFY8hvtr9jzOIs7QGuykN+VWy9a
gvaAkI+YcbcXrgcAZg2OF8WWhHZhjHXRF/OkYLolI1ubLCTvIF+4a8LAve9WYyiyM5GI91kSnqmJ
ZSf6hH9Z1319dwlUSeIrytmqEY453BC7Ja5p80H3YaA8euRMbNguUWBLuX7VjFb4I7gVcdd19tQJ
tW6DdBdd6WKZFrKS7GqN4+AoFY/+QiKKUv+bfYHrjzamyApX2eMG1QjS39QPHVCFF1o/RElISEqx
fsJFNTYnT94BxszjVTmokUIquQI1J+p6PiE1/UliJfm3Yo+wbQduiOVA8mvz2zCE8NIjdBwIY1om
60FFi82Sg/0Ip/sT+eIR74Jgl+rzWiI8QYoFTJq7+WPBF5UPB980o9KKq2L0MGEwifCe33KLE2w2
x7Lf74wZyT5VITTdQWZzGaXAnHSQgn8Khce46GScX5WPDhN6jMSBZEJaFY+t7rX1pBCros+n0pRC
uePY7M5c/orwMRZKkT4SYGsNh0b6aYxmwagIm29BcpujadZ1nsOKIyf3/2zkSiLWkWkzXAVveOgz
Q5uDb8xCE76LN9TN0BvjZqUDmu7rydOrtT+r/8rVgPMS9ymtwfLHl1hBF3rr4Ony/TCuiqo7bdjR
9o3X3MFzEEmhg3DySWT7nyzIthdWL7fJMJx1gDSDuWQTY/aPbEYjbU8s2qswM1TLZi6pqZ1IOlfC
Bt+G4TVGC2IY+9rCpTL+K/42Nav4obGUMShWUwh/ZDs3IydMej+CtNVUuGW60X94WaGTLogNXsKV
eDW1MswBHbvlP9A6kYJabDlNm5CTUlliivNqrIh7j/kIyNo/K/rT+yBUcG2BSREcxRmJFBOeR6qH
OQaPVVwcMepBRrmhACKQHsi/vAmDRFi0hsvthWtQVUZSZHAN4knmexplxB3AfCxnG/DXaQ9cOPPq
L6m/cWu7KIb5Qnc30t98r9HhozY1paYYGiE+jcmQcrDUn2HH6KYfpD+86V73nIi5cZBYbpjWJeEq
+Z5YqTRjK+lNiMmKS/kee6kahJZBKug3JvG+0HTrBcIH87umLJtS9FcMyYw2a1Q0HE8Qlv3yLuvZ
A2KTOLc5XbFKlB+hhjSHQs4pv/wsl83xYIS5f47To9uB8lpVocm3taKS8/EMcPVnoffJ705AFNsD
tl+wnyad1PLE4lBsVTJ2uRU6xbEmfXceySHrawTKrShl7hRr78NeXJr2ag/st9FnAS7nDPv8G0Pp
FSTygvU7u/QnS+HlGvDYvytbH7KBQ0tdGHjrkdwNw1X9Y9P53Yt77YGNTAQ52LM10Mt/K9pTW899
r8PFR2gfC4dgMJisWgKdFLbygXUEvmput3SxUHIjbp7ty9v7wFiLmanyzw4OgGUD6ElN69A54Wrr
/3vWNLwBahzloZXBLwxID3yv9T+KRk/v/dLi75UnrV2e2UZgvPVMKyGvG/ELDCdL4OEzJcrX8kJE
yUatadu5OIYmrb/FbqAPXIuAiLEYNV9LiVsgTOc8D5LZDkg4RC3JwozLSsf0wUJS4WVH0CX+W31d
I6OWnrkxvitzorTnbDNRF0+Eq6IMfyEt33x3T306SwGHJ5D7huYiKGjgGbEoRB0w8pOh2RvqT9+r
2lCVbob1n0lhKJ7AkjCfaTI/MKLjypDnQJJgMwdHLRZyLvDLSgPXAHdb57lSXRfywVZxkqsDs2MA
ravkF0naerQ9s9D/4Ik9lc2Yp/B/G3mVCp3JRjqT5CxiAhi4upaRNuZahHOjucPAvPcgwptOV4UE
+i3ajsnTNs4vNt+Y0OhDBp3+mJ8w0TFYFeoVfPI+dRepd77rdIF4WWAuP/h554RrAwK3ZWjJ74Yu
yWu4NxEHsju5SsNKR3bUIvfOog+tlKg5Zdmqzo5wl/sOdK272T385Ke12oLdZXWPrIsldCTqOePo
nmEu0wy1RGAlz0YxT4loC/mHeRWtSws4PsMD4BfdLbaynhQtW+LfcUL25psElCuTEEfnafiuGcu3
mFc6YjpW3e0hsoRjRhsVTAuvCfuC3+N1nDTXMtm8q5Z9csR7dWNBJNs3Yu7BTKWr9YqrVTV0r9K5
t4r7xK+hNhRq0qWZ3GCI5cuMd4Wa3ZnmgMUH1ahW5fWApyje99g+GYfNjMbEC15ymnJcTF7dfVWL
5wj2ONtm4aaj7Sagi2Je2Rfj+iWoyrV/UNDXapVonLa5sb/xmTZCrK9R0fF35qoxUHcYzEQrN73q
mKJwpGVFjAtYW+GN1oswvZEhdeMFQP8OnPpi5fvrSvYviCcmGwRf/KumtLHezMvrDY+lw7u9Rq83
5YgRHW5UhYZt5s81eEwhkZGx7QUop0ac12vC3Y57D1YHmbpXSlQ7OM3a5xhrV4ZXZvuNdoyQbEXY
CEbV29jKBqSy52mvMme7MQ9xlR0y5FLtk4Qzvz9WkQhzP2/QdXAPnt6vThJp0gnrNRrKA0QQ0dwM
FDQf9fROdY7epzGx79QpFMXbgAADZ/dIwBWjFr04VCnvVJKtM8njRJQobKEf9ct53uiQYOOaNTvm
OSvs+tpTxzhLu/KD6NZ8GCRd9pBgaRhzbP3gKoqVrx0PCn2In28mHjkWVUBJYwZq5/nE9QwzAxs2
QlMRvDOjeUxQHpiWJhyP4QZn3l+h8FfbrrbMzoFFglEj+50s4mGJ1yaHq6D2BivWw9X/ME1Eul0x
3IFlVWmSuU1gkFaMQU/J4nVQkd1aKcXHOCqvPLK5sGyYlJ7RU1My2pgsR5K82SBeVgtFw5O4I98l
IzW8SEnw7IrXIngi5cGI1RH2m03CH4lL7pbf9XQ4+8gdDvwvugq+TBco4EvOnK5ml9zLff2cypTv
iUCV7DUs4ThOK0CDjvWRTbBaEQ4j9iXJnpKMWU+S41J3QVrJisqkeYKEGYDcgRe8536VjiU4ybub
rj61hC2p7Jt2eCOmo85VNYYWy8T7Ldx+RNwaTSB2lcVo1fsODtG+e6zZu+/BgxfoiQd7BTmanBO1
hy890Go71RvFol6BQtxcZj1McehUBIQfp93KExNqmR2U67PQDUAp8wsgvkRfx0nDga42hwxuRvlG
eFkV29atPw31R+sRMtz2/nkvEjHdhiW2E8KeP1x3IOBgl4EJ8Tb6DK9TjPEY7mT2MiAfWIknlx0v
hdQhQaJbx+hggtvMa9Kup2p0zkkXIcW/dZPcl2m7LcnFkl5ONkmpcVZ0xuDN77I9yqDugFOg1/KT
bTgUthryK6Nvb94V5emhWqRYAHExloEDhnSshKDl4WXdoUyNLtyjwYyFignRcgiYatuM1OgyjUoR
LANK+xtGpyDMzCw6Akd6+o1+keYdOZYZoKtImGfSGhFpaXVeIlneuLZEJFugkEdsKmx5hmayGpqU
Z0iq/XVHdCkNWE0H82LXFhpHOvGP9mDECnB8tvdd/ATtOUEXYcWtlf8OiBVAXaCTcYmBOnTdrXZm
+1P/PdYR4HBYdhsGooMGyjNqT9xFGgxKwHnNDzFoVzAUR8rS5lu8RrTp2mN3M/Gssj1n/xZUYZJ/
4nImXdG2typApmcF7lkFG2/qUe1QRKrBB3SS9fYFWpOxIw7CmREaYrJUD3nuiO0sW6l1QU5IJNzu
2jmAzSmJ8ZuuvNAfq4BBFsv2wYFQY3H4qmzpBr6H7pMIpgNZfOk2J90wLXNOOsTT1FemaC6kicP/
O2jEWnzJGeKbN6IVCwXLO2oLE1zqr8b2iCzQlehI73Dy666egpoJX81gp7eeUpbo410hI8ctfk7l
jL4v+J1xHT9mkgmTkYteVPpjRqFmHw8xEm3yZ2S0buA/R5Hdlkr4Kf9gTNF6GvUD9b7aXdRcfGVZ
dB0GRl/1NtGzKIGWCFMfKWwypapSVxmrv49mARhNluE6+pg5bHi3NCgnSFyro8zr9M1TCHblBrne
3eR+qy7UI/h/tnHRyGuEkKxiMbnKo+5WzfGVmDEJCSd4lrM5Rs5TgGnRyRdDql9q1iIQwoF7O7gD
vCnWUsfdCBbovc5IiDWwsLTHImD5RAIcZaODdPA89kS8f+A/1DZePBsCsBQ36Mxn0bUyJn992C/W
6n52VBjSGTc5IWwxFS/UGoOth0AF2kCyrIeECeYQKmiEXonZaqDUaGHccg1BnI+rUAEb7lOM64T8
ekfcYabvtI0mesGmySQ9CF5iqJgYW7YxT3hV5n9QC7m73StFJmqqobKnR2NgOtWvrRYnAkCyFaCK
nvElkbgVs/gr7yKUk0GGRysWwG4ZcFlHCd/f4ojN7UzvuNrzKAo2B6Ni7oJoaKs6N6JTQ9gvqR6/
5VwnvFWINUpEBjWWNYQmMj1FOiw5+34aPTV90nujwg+Im+VXZok0EPcB04Jea+CypEjIYkeeFubN
qVy10VruqeEuIYfi8G4eSDpu+kp/+J45SAtTwg+GaLEFFBqDq4KmZ5YKsrN/nVTVfk2UjiPT3ScN
h3S8aelcYe5rFJgd0mg3ZsHbbMSqZpBnwkOYxi2RE/+iyRea4D6ezGW66KJrVF33OE0QBvzhWvWe
SN2xMmQ1olZhx1wo9PUvAirVcnmzshLvNn8ob44tQKpKxmbJPa98LNwh8fqQeyReBGmXSyPIFjSF
oy72qUN2Z4CYMQRspDgI1Pt/LWBF4RwejBJgCEQ8TUBBDgpDtSJfUJF0MDoHHRvGafSwZqdEtkyG
8Tw1FGmdjVoddFWjhkZ4ARMW8HFDzOOC89XssHq6dX91xJl5VakvIKZwJHwT5TB9WfHag6mOzm8H
X/WsCgbp3Wwods8rI34Xi5XEmeqSEDbVrgx739IcyHdw5V4m2qkNSVs5n3Yu+grH8nLi0bnzaiQy
r61NYJgxVbGlOgjXTlKQoYcIMUmm51zBzZosya9/6mIexxjZQqoEELmB8N1gvuMM91kuuC1xVL0i
wuj+Uhz+wLKBXAtPMtVJMAN+wCV55AtbtsbHbnejvRRLdIs1N2t59eAi1UQTBmfZJORDaKaalYkO
VYJrYA8M1LqzwXGDMFck9AY2o9i+EmbtF07KkEAi7Bt5ijGVp1MUMKgCopY+6m5jXOkuamz6c7k2
XNHzQd8XfXgroPn7cbYobzg/C6rwRBSZ8gMf4fb+WFVtnPnXsCfnVzOD5eFU31cF8P2jOROsrr8l
b6jj5LoIM68hSi6zIC5wlvAGdwS/S3K/1ywQAhqsZ2fNX1zRCxZIax5Hncsrnpqnx3WJMsna17Mn
6RO0Ox2iG7FlN4XeJk8kYHNeKrGMx5WPa0fm7A1FGiBKiSS70s4v52fSc1DlePYyOvRBVOOmzPIH
utNVmJsYhYtjyWrDBnZXPxqQavEBzz/nfHi7RMTT7LALg3zvsMw71qbCRgiWR2ikBloMmPdDmTYF
PdyRY19wT3HPU/Wa2dIOL8hGDJGjZfVuKgkFV4BBmFY6QHfcr6OS/Tj6e3OV/+hZhU78gCrwcEIJ
uqkMPeMjva4g7tEdxMlwFaA2WmH9hLV1z4plU81Q/DWFgwTdoZOWkvtMYVo6aaVpGPTC6zXtuitm
1ERzehU422baTdRMJsVt9e0/t4JlI1AmEbfXnnDZ8tZqYSQuRKoZp/x+OLI22kfw2YWDqywiNONX
7kPByuuk5GoL1hCNH7DkCiUmXSY1H7v4hFOGyy6CxSim7hgvAXHFy/7LQIdlkQxDmJgnlw7qe4G3
QQBo7mAzZnFZA6fd+8z1Qzhi23cFghL2de04fRUacZ7DrRaDEbPJqAmNfKEnS7R5qHqCqB/nX77s
hXmtwZ8Og1B8gJ/rNOD038ST4P/kjdGE0F72djtXa7ZtieqnalNE2tlfEk81bRPhS2qVxDLcvTBD
dKUEIaZ7EPeXoPplBaOGV91TX9aWFCfLqGX5HsPX7YZ65wlXEEr+g0cHhjRPuVliDsQs8ptV1hLv
QjzZD0GUNxJSusu19RNCEkAuf3dFzL36l/l7obXH0ZANzG+kF1mac3t9/CPPOJdt47iGuST0tczn
fIbu3C4DWHKisdOZbsIugaRaYBzS/FJrKwdWKb2yPkcRy/somTHErwk0WCAtOQUTn8cSGb5gZyM4
UJ0k+K0TBo1SnFav4CirMH2d8GlZeA+QnXdEKiGqxD7SVvqTm6uhLIn8V5teTZvMQ8mTjgolmYdy
wqNbSDAimSqOoXb60SE4qM3KMzlzwkwHcw1OWYFFkYIuDggUAI/HLZCfOmnVM7gAcz0lgW1prwf6
hyXhJPWwITMHG4QgRPNJG98mwwfIreu1UtaJ3T+LQYHWp7rVf4eR8o7boqbGtmxnybW2jEfKxyUy
MvXQ41DLbaXeMQPB+WVpyiUg48UR+LrDIbaWtyLSSjDMP7zBM9XHAekDc4++/+L3i0JY18cGEiTq
2qG/WHuQP0SRrx9CoVjrTSU+tquY5hrWMZrCVfz9zjfGoVQ1DVL4mta45tcJconX5X/8byWGtP+b
uU3SEpway5q/k4q1e1MOmlU0kIHNxNod1fJ1W80W781oVYWmKeK1EXyKFfH9Lnzam6uB6wl6C7pA
AZo+YAYffnbHF3s7JBVWC/IOm5cNz1jjr7Uo0AuKeQfbsCGP45pjjRpCR0tWCCjqcNpimEg5lqrF
nBX35psg+SP4lPLkT/jnk0banO+aFui19Jm9IPtBIfvGIq3498n6z81w7HcXIVeySt+pDE81kEOM
ruOb/vjBMcJ0WqKhJf6E052tjnaTT2r9OKyFA+Poi/3UO6N81dPJcm1bxqmY8YmDuuFKfKwHbKqw
oTDH7MZDrEmy6o5PJRU3+7CIo4XklilZNBe6t00CpQ9t+/aUXVRiOjnt2kJt2LH0c5AR5U/fdAgR
q1oysd5uOttVwY7RDixibNaMC2laduNbZNciC2F+1Et4YZg9eD41j0broBgHvdEpQ46ToR9Xahja
luPZbRRDm27QNnRONRMkILRMBlu9nW2wjFSrOfGCliUDTbIS+Ed66mwi6KgCbRgDXvNhqOEVJD7f
dynPu9+bEvVcWRcuubkodsJRvIpWU/IzmGgaSOC/vc4xYGEywR92ysH6bDnR5Y1+bGl7pyjD74Cr
vAAunanRh5/HoncDRpHAqJr58PeAIb+e+QeZfcj2bP4EDP8KQBGtQE72dk7Edg5geT6gCxwEyNC8
p4Z5twvaeIOdil9by2ByV4QBlxUObxc9eWaX/ZeLVyxvFcQK6FH3AlAbTfUdbLiPlUPEtWmRow8l
4UIQ6/gt4+uixj31bVe1TZBGrgvEsuKUdJXMt+07ypEuNFSYKTuszxiCL5t28BS6QZ3QEcPxwmBj
EVv2+6LWUIR+SBy99jiRa51U6x598ShwZWBxWdSHOGFcnolomObdSIXeF0C9J+XxCIDYtScV/PDE
HJQbE8LVl4HYJ9WMu+CW62zudyePBM48pPmKJVAtQKXtKGUHVJ0x274/MtPTNed5k8q8NxP9dan9
iDRlrktFss3kWHK4srOy2u9eT+rfgvG4ZW+Yw2q5SCemSqqWfpCDen57jpY3x1u0pZXAqI/ncSte
42kX0wuoJw3RT0K67cLQZLVQ+ytaCiIUwxYvddC6GWUU99ERF0+UKEqZ7+Vu+4cEskVzXM50a5HF
30Yiy7PFKd8xQLjatkQwyc4ido30Pl/kc5AA5asV092wsBU2LFVoNsApFNOASCE2qojWK8MrCv8t
USjgxUfjgBWj6niyanAyVISZv9AqyuFepvexWujbL95fpdqHa5Kt2XTTtqj6hdfdt6Jo3X5w5i9q
7EF7QPasrEvPG+mVg/N+UFSgB2FXAhpp1eRtBdqWAxBMs8FPnfByROQOY5SALRyrsHOxB1PABqpp
wFJB9xKal+lZQLSyMCnewJcjQ3Ck2DtSv+XY2SQmyTILP5iCd8uVpHRjUPhlHU8aXVFKGf5hhaLv
iaj+XLy09dNsCAP9bGI99yxIA4LTPXqR1o6UFiS0O/2Zc4QS8piROoz7qBEllyOaGQuwvCjMkl8+
v9Wyn7ILHCCSoyCG+Sa+81T3w25258D87jORqhGO1876GGmvcw08C2nFAdIGeHKBnetAQsaUCE2w
Z/Fe0GeHcBVD7nKOLlznhqzkqiKuETmIQQU75lzczeDTEqyEQ7SHTDoHA1l6piAzqPA6CSZqwRMw
KXB9/sPAq6xoEvzLuQFI3QSNzpqYjR3/+SrH3U0syBBn9bJpObXFImbRp993yp2pOFHQtE7LLakw
RtkSzq9L0A0bwGgyol7BrI3SrxanX4t3rkpQ2/YjyPnrnwcrTsXFqkUhpTQBIqUhP33CiJdE1EIX
Cz290mtbbyF97I3ao9fbkxgn5ChBgsrOe8aIDqcD83nXE0g86n0CXGnw87gwWUgVLXgF/Rq43Q12
GNqB+BMrqz5RjU7LbzdMgoxCFChDpxU0xVve4AzDRV0zlZuCUKrJAYDSlj7NI1keT1/SPFrcwpC8
PNod6rDTLrQsf+ijPrlZxcvW8139ccNflcMDxUbtLAq129sp/21Okrc5eqMpvUzC9TTMx1le/2w8
U6i+r7bdj6fOjfVT0TgGDNVGPK73keibCzB7NLcqVHOgztyMHHKzQFXsJFbDf/6GlNrUBFTjP4/F
xPMpnD+XadcwFi5uf+s0LT2bg/7g6+cyRkAJ0wXxohiWAddOxXUfy7XRa7rJO8YVftMV+R9i8MaR
jL60H13d0HYK2VmO7q2bhGaCqJW7YOPkGmBcA3/R5JzGJXPxGKiTsDrazYN65T9XaS1y5G1xDIqr
dIK1qvTycCTLWqOPJ0VfvwBDrh2CZ6PsUjUkW5iVIYm5f1Hh7I5nf3a29VGtQMAo6Pusw84+NTn+
5pM3n+DMYq+XZ869P5gPgB6yTOXNVIwOmo0sanyRtZ/6NWA+JbJswJEO+LITHIv10XQE1b956wdF
VfL0YQK3dNgezmn+8NxfXFWCQ11EdSiJDBfnfUh94qzeU/oNpaCKPFgll9grU459g91AJ48kmULp
EHdaofyGHmuVj7NofOCKWokONFqgZt5a5/L7gwY6DsuPXckS0Tzyrua4U8+GoKOShCrpH+2iq+fp
qFvJrZGH3A/nvh8plsD2uK+UZTAC/gVj5it6aLqtEQp742xQ5o2A0YgjVdTcHDjg3Yo5M3c3FMPJ
d6T8W32ZutPo7AGZuMIhDyg6T6tsqhQRFme96kS58MB+nJgQajqfeIzF7I5NvC4Z6QBxb9bhaI4n
EG8zFmiahrzUTTagh+F32it+2umt37ldmdlZBBlOaNBTi7doAXgk9NxUyGsmRj3ooodtifIFjyIy
NcRFyTQ5oX4fsR5p2PHhF0/FeY/d2ofiPg8qZicEsHzXR7u5rB58iHT7LytYfC7/yRX+edM5sFrb
a2Cog4BNzIO4YvEMOMlgJFvZLKO9MGh2ZO4xqUIBf2Ro8JR3Ka6td/9H13AERzA=
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
