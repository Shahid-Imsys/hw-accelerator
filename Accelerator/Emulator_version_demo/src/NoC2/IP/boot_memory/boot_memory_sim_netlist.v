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
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
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
