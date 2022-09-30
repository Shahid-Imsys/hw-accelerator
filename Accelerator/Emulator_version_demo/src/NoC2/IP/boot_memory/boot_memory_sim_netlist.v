// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Sep 30 13:30:55 2022
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
