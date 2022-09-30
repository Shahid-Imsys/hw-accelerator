// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Sep 30 15:40:06 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/markar/checkouts/ImSys/testMaster/Accelerator/Emulator_version_demo/src/NoC2/IP/boot_memory/boot_memory_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20912)
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
