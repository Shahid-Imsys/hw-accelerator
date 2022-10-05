// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Wed Oct  5 10:11:30 2022
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
1q74wof73Napy/bQ1c23WfSA1vb/941Xey1cKFCDUBIx5tbYvaGR6Hu2ROCCHkEhbR3VNjSkYyyR
GbAx+tq7hnnb013cdW4GJjY1XpC6PsRokXa3KgSxBgDU+Y77mR2jZYoGsOl9TNsedtWoyif5ShWz
Sip9EGNKQq8zhMVlbiqJxL4Gvt4H2ptH4GgsWiUYnVYroBlqz6NBE5BV8+Sb5OgwAcrtr+BuRa4h
arQmV76j0moSkj2Qth8VENetZ+VrnWjOyOU0DtGjQXsi5tYbKHMdQ21c/4LIJUuvHxCebUTjMG5W
r/xxu9pIpLnAdLa4i0vqiwypNyDqY7ihkvBMcGxw8OixsR/Tt2dgCTxeClcJgQTJCz9/25nUcDKv
LPiXzg7vWArL6V6zOGkdzwh4WgwxCI7tCrlPSWDU5AKcAWPjcdhbQrmfC5KdTVL945vwHqRQDkwW
zKUutKflkVVaKgk47su2z4DyLw2fe09BiR2+Atxdne2WWFiJf4wUUlARBfYpWh+Fi1APsyHmFSa5
UPfT4z/+GMjkh76gHMIDNEt+iUmtNyHGdR+br0j7UDZSlvpP4UDo7VSjHCNw9Mc5JRLK9hRQgduR
kJDdj7IamytrfJ7IVoW3RHsfGHWT/w9P6Ew7YZZVri+oV6Wobj/mtTfduZ2neE0fWKw6DwuUm4zf
PdYsRzN28xPLHOg48t5W8bslI3qE/3mSiFtTj7gmoUwDEVwE5zryjhSFS4u3GKfzAUKXMSC8sxZE
EBG/0kJ0gVne19OhnJFzmIIJNh4leyu/WO917YdIDubEtiucMCsfnNOrfbZrVUArXTHDdXBNH4MP
6WUVHyOWRjNErlI72QYN7DTkwQS4zPKCHoPB+O+IL9UCO2VYhFWoR5sIdcxN0ldkTkeemqJOEX3m
mqYqDcf6HPwNBOOV/5ak1vpnJ8pOpC52+wZVjq0k9HnZNjnXir312+ItovYOC6TyjNvP93TFflm0
R6uRXXSBMn6ViLke6upLcg40CO4K1Co9VauuSjcQ922Lx2n5NoRI+D9FaiHAfMcpAYuGPqZ951lD
RfoghvivY++uA4FHNU0K/gs9KWhLmsDVO6P8huo5lzJq7afGJmSy4XP5xRbgrJJTlJBD6do5Yepd
2xHIcUErguyrZ15IsP06q6RBF8X0AbbetJhXmzIPvEciOXSsxZRm9sHEKzBjcSmH2B7uZlTcocR0
gVuVqs04aNJ+4X1x/OaKMwLFB36EhDBQnTDGKIKw2JTkmrUwSmfduDz5nVUifb1mePuf44daLZnl
8yMWiTHapSIn7C3hDBSHOedOTSy7qBX/8Khc6zADvfQoO64sOsixQqFgM3mvHnod2wKQvyJfGKEp
qZiKTBxbW1OGI4fCMKl/pgou1zNvu+RodiywDIv/lZh/w4/ooqroGBRJkPlZrbszYSwb0GKsTEW5
2nDLqmYD9PzrJ3yPK/tiZQOE7RUn4jdj1D8gqOAOleU/YOlNWjBUT0jMUjaTI7vc69Ydnlayze09
wYqXX/Bu1qZ/iiYgyQooesXpqVO3tDtTemaMnTN/J8Sm3FIBMG2JYRZL1l9FS5R9KcZ9KFFcU2iG
a9/cH5f8uSrou0jS3ouqJ9+NWgL5DRYjohU1gKUwi/EMNmrOunV3DbJRAk2d8XcYoa/xKNogHeyi
EMHMujxQb8raRI3s9amEP3SmRA/cOUeckstl6FfNc+qdXLUBLSFAagePjl50BBMFRB0LqrOGPueW
7O630BMe9xF3dGRGMZ21OIjZUNpAwqTDMweFnnjMcgmiLFNcxl9/7YoXKWVXZDtebaKgxtK5+rCB
QKy+NM5M9u7j8VfZZ8q+c6qiimExaGBMTp8kR8uV7M1BOlVv6Rho5bNtUWe2V1DDwJKBMLN+sK4z
/VpFT8Jfp4YSvW4wnwuqWEgDwdFUPL7dlNP3kjOgjD/IuOSJf6kFdbyOxqp75c/gOS2WI0MFm5gp
OoWLgFrgTWwthheHuautBppXypOphfVXkPzLCuVbEDr8Ku6hx3pnIbm8FEtOw7/9UVRZNIP4xeKC
b+7k7esCRdxCDFO6zvD1juuV3X4jRoqWCHyDhGMxiQb+jJ2RTK4LkrZqWwUtHgYqQ9PJOcDwuGn6
lwR6tTRtY1i7IiGaylVDYOttUOOQqYuGa6G/80ij42PP7W0X2wQv/ECiFcQInysMdsvfZx4rmMze
ZfNrSAt+3wvdZDV5eENYCaJP8dJGhVX4iKAhoITlxLocL3EQ1IJDL5/vjGWxI6pC1Lsjzlo50WCw
IypUysO3C1fIzvGutbPOKSXAnwLz7KTtr2hk/zk/bJFHu28SM+E7HOu3Kd+TDzjq7xIURXycDc1z
mokHqF8idc8GsFcQ7gM5oE/wU9Fc7WNZcriQuX3o/6nIZhkm6OpGYL89bDBR9vZeWbMGrZxAhln7
koRzi0ntaH2GKZWNWvd/4DNilmgxVEAfJgMb+7JoAEIpH6ak6TC6MDR/RKt5S7M5HF3fjPTdJyaT
u34Id9kwohBCxhzGgT84P1xVG/JqZHmkXhTlPaxqBnLHTea33P+E36Sw8JfzLu5kvoYqduAM2lP0
94zbgmHGaOenbVfibGR2TQ8lxwwJozGQamiOGpg8Xa96fnyAMM6336a0oHj7dU0YZ28dN0hnD0Qt
v5Vbcxp2lV7tFBFFov+frcnFg5dQOD5mOx7JRqiMfAcoGjmwww13KpzWlxnhXzp1bpZQVJnW2a5y
AOBbvVZSB3srgzYwAZFDPAS5XFuDWQlu043MdpUPZ4bUuEUbZ7EBQRvc5ZZAIMmIXL0XoZ/y3NNr
GLGjYT/+5J/H/1GUL/RkneNX1EOTslfOegOcwEoX5gVlAAJyI+gczzu8w9Ug6COBkncN8sEEL/u2
xnwsfKPd9XEp1mnAb7JCLIu7qzbnOvtGBi/nWI5kTAZf9zl+zM0zUgLhluodppZypEnN8DVeDVSV
4Ed1lWIHEfSi7m5wuz8TkdbDvd65RczmLZsDlcW/ZfepVSLiRYHpZold4/xhTPH+Bx3NJ1uXb0Ql
PWNS1Re0QInWlfrr84vh6t0PCO3BIjuOZ/9oskcC+WsakqpcfdV57qxJUG0W0LkwmrqmEs+3AWI3
5uiHPKgiKxjcnqFAUiT69Q+a2EzDAm8qG7D+HHXMMVQ1igjMIDq4sOdGA7BA1goQ0SS+T/Utxeu6
bkKJJ8ylJ3zeIRyoQoWlyf7k27rsXuAUoO2HgXfTTmL57CUnWuSljsPbg082omheX4RlYknamOPq
cbiBWqgPBHqPNxtvPZ2tuF4xGuKhm/9Vb3EG6VU6jv1yG3uLsg8dLKKhjo2lgR4duR7W6QEwmzNY
itbgpu3qESpcYEbY2jatjGGBqZQN3l3fXrdA1bgoZEidoKCZtQNaaR3GoLJV1Miqi6n2NV3HSrvK
ghaXxRnpBrFnKoVl2b5rZWBuak3H2Mm3YjAhUmOanxvRvPlCmK42xZ7gQmMXQ78YAEE6Q4z3tFre
CHG4qPZ64/+i2l1kKG9boZUI4xxChjSLSrXdp0vwMEaAPB2pSJA5iSY1RaruoIDECeqWVb30S1wq
c9tsPEyK6bu33aforik5mmw4RnHiuJgTDqDtg2jct1SPze14fwAdmyGCM7xdG+moO5rhYGc6s7A2
xohF8zGDyNlMzoSWAOh5AfaIfigH+Jb8smPp1YFrdb9+39w2EzR8YOD+TcEtbgBGjJvHxMtgTMKw
QzTpdZboUXdRTkZE3QGuwqkJ2jd09Nz6n1y2K6088rMJN2R7Se7xW+6Q7xQ/TyCrxG9csWiEhiE5
HmNP1dty5khS6sSk+kzZVpZYTdPTszqei3c7K9ncRuih/+XVVFEB0cBy69NqzU9pOTI8j5iXDb7F
4J5VtFJCf3t+p7zSsMy+0FoiNR3EK26u9Qoba/0nJ381Ra29TjwpDOKNqc6d4UiFohbhsgyE9ZXb
7D5vu3HXqbpqFM+6uiyXft8HELshKU/aRFrb6An2IU3KrFGqaZVqJOGCu8Mi4HMa207TnljbbLJc
qFH1cNzh0yBYsECqqhNQ4zvFvnmZtpyraGjJTyRcDUezJOqriUYO6nU7HCTzgwQd+WhvSoO+AvQN
yMniDR+n/LhpO+g4APysOor7r3Gj8iruUZaz3A0WY7BqyWPylpIOwZfRAvxkHrQK5zfzG4Z0vy0d
WPqRZ7aGzkBMMairmMtIpMiQR91UJZwy61zXnP7HJ3wanr5aWHmYjKZ9ojLZ/oZ6/umzc786PKJL
Ggbh7bmz1whGTunWL9/DH7Frra2xaZRiYI+wjpsAtNtcxjjOTEox+oyeonkf0X+EM3dH0VJCBaSq
IakgXkluoqmz0i2zCkM/XDI9KQ9SVAVAh0krkLY5D7MtfefNchl65bH33OlQTAFo1h3h3DN1uRs3
K8b//Aii16pTRT0/hEzOqoDpxWulQVTUjrAr0qBqrhKVLvDlJwo1BFkrtFEG5I+II7a0jlo63O5b
knV/I6u7xCDuKCtJYhw7GVSAngpgQOVY2xdTmBZiZ0EF9YDYfieHOBiqBquAogrkpQCnD0vjA5rR
rX5S7KNPMreLmP/QhnROnSyP27p5RpbWb4zCCkLD65dXwClJsqj+GbmZUCPBvYWRX+ZEq9W1bvWw
v08zL2kpo//ySg38UyxfdqxuMHkKyMfOW+FOb50ACTD9027k3UQFi1Qw8qtq0E3887tPRB2ZGdzX
KaUYXV5PEb8iVsz4aKVkRIkte4FCIlEFB5C3oSKAan1kbhTr+dTpVvMoWpV9QdvocnHklj8+IcIT
7uKIIpOeJt8cHpeOvhCCTjUycwkG5uiXb6rsFin58kItCMb6cRYAb0l00zJWij4rNz5arXfmJw6w
VCFrCxdg4DjgS8WwrvO83cYceR3L7VPa5f8KAEJ0l5moW8oSO6+SgV5ZwO8CHNSjm5A0yerplBLH
proN67CB1LaWdoHklugnTKBYQT0OUGliodYAftlffHkzecyneBnJb+9QAxw2ZONl4Kgrz2GO8ME6
QccLR25bVYbC0Ed+4PwzVk5pEamN4wNguuAlIVwPAffT/7weVqz2skB4PK8Oxom0NRQdr0hzmeM+
s6Af09yC4izZ69ih69xg75CBggen/+GRZtTBeJNVVx9Sb329LXYw7P7nuXpf3VsBAvMcE1CjCaLw
hIXJCkKVn2dPiVI9lzIxil9BQWRMw+RaAo9++knXjnjEwzD+95+ubjNQkBJiWzc+SZFGE4hN0aGr
OBp51PNFtQe/+F2rpn9Av9QnB4hZAjnD6jLMR9thnbD8LjOXWeZU7hycNCJneNJDPxPdJV46/qQd
cFKGpv/fZucXwoHvRk4kydWfjlry4+pFExNtrXnrGAMfD9D4Kanbrn2JymbN/iqXEfRuSpZd51iv
NvdMPm2jtB8tEBAPof+1dYBbpRY0neDTVFI0ZhLamFj5kmpJcknJYbRlvdbjpRPrbSq5fWsW2eNv
Pd4xcdhMQm+kJ5iDFlF46QeqhIuGXQ5p6rLYJNqqH2loSlicCNvhgT6VFpkD8tRb2F96MO2MOEPl
TIdUjulEf+FmYNW8PS2xhV5XGczUN6ttW9RGRBDThgxd3D3gUx3UOtb6yK6VxGwp2TaJ8MoLchtd
WnN94vjlDxqtChQg9cSGD73u9cyAIIuKHd7/SlrgC17+XeHMZ8rTx+zfiVgilBc+O1K6Tm/3/U0q
Hgq6ohCaqU5BCK7H6WqX7HsAWGvMvqGjfFy0fyrkA/Wtp+/g8b0X/OWIB4dQ4whtqhEeIhK2gkNU
72Z8e2zX34R4HA2DDQqd6SgaM3dlnfU1PJL7xSzsXQXPOZ2YObkZPH+bnES+DV8UNTO8gYs9uOTo
4fcKRfSFXQoj7UN7AR1j0B4Porv8JiNj1iZbKI40gK69l3IYGy5XWpYnYmWHZ0Oi82T0wEXA7xbA
V0T7MJ20T9z+CMF+gBuYMmjWXdLQL8dlV3IV8ilFdXZTO5hHSusCxsdayAFnX/7wG4KtOczFmPZg
F/mYUScbqBSLNNzkGci1ZTHZucbN7sicYgnAvein1PvxIhhl+EgwPC3imAsG+lDNHvEKOnHQzFcF
NkeEfESw2oc5rL/2z/AYS3tpalgWbSzqRkydrPnwcVQrJOnbpASFL1qM1m1vx4+pbiVnso+rXvoQ
E7j0ZqSS1CPadZQY4Zn1fAESgy87uyhktAu74aZjojvvKR6cl6zUXFc1nzHyHUANSgooTEpD4qQj
tuglQx2VwOC5FURURofOZ3Nf5Rf/16eyDdLJlRb3hApTIgq18pghpe5P2CHsUfflr7OgbU4JoBvo
yqxysmVDT0gyHnLqGp1xyvql7b0cRsnT2fQccyle9wTDioDeeBfed81OBrZkgXkzLQGeYBQT2b80
bTpwmxG1O1L1wk00M7eXaOdx9kPvhk//QqmjmDhEUno7EMUaYU6KUmw0Jt+vIBGgaacLgvNbhdiI
XPQ7pFXY+UV+7Dscm5Dd6gHGobCjzZQ5Vi3ouU6ENqvce6uJMfebgslYxn5FiURkYxA9o27FJFo1
Dhk6jQ+IhQUQoW5IpJk3P2BPLTFT4YLvmMSJ4Dlq/vZ+2QlLdXJaYGNf/Dt1EAHVgAMidRe7itL0
W2fkzk8Eknj5+kQWnakY6Rqng7TobL3fw3dDszHGHsjCtAvKpW25dENSR3Xq460zJc2SZB6bipNa
I7+v1C4n+moPgHY71SHwiJYRCYSkmA74+mAicnKcWslfmSOWy5UkCDQYCJw69yWYDUMPzWpVglv/
47kG5dEapyCs4v2cYSVdZ+34dqPqTE1GRpUh8opHZLF/+LMip0S4TD9n5CO3hAvnOTClkC/Bf0op
bPepnLfyaeclcZFDcBYNZJIEs3XE/BQs5oxfxh084EPU4UCj98iSKNv4h0t5WwzLSFwbddclXbK9
StweXDMR2Iwo5ismff3vfiqYhd+UZUwQkEoW6/XvDWU9e3gaZUnvNrUDiOVY3JMfL8ngssR429eK
JDSde+o+3NMY+asxUxxGB+Fde0q9pxdUjZ/aQW/OsSZvT6hROH6djCnre+TQ1qKorKQOAX+0nT5E
7iWeDn5xNQ1tRBw2vw4RSNE9FdmyWGIogQm+vAZ/1bOBFX7S+eQd3aCkRtjwD4qLBGIPeTp/D2+E
MElm8IW28G+Kptomb8pnOUmOlI97s9xEX41kacXfLNqtXdlmcBu06PzCJg1+87FzfoO2X0RIvuq3
lxC9Xe4tOyr0rHDL0DaTItd+E9yRA8VMUTWWxyE3CoApwQ+66J9/0tUAUXWishfoGMCidPrvSioP
rn54+MKBnvUMjiZnpRKd0vxYlwKkxTWHkTzv0VfofC37pcZ4URpsH9fj2FVmTea2HWA3qkqE3kLQ
y2pCT+q8BgZjZZ/fJAylkRvS8p7U3Fr/ZepdpHojilY75WclSMQdXPBgyNepH8G1nXJoKGsqf/Ok
2W8pOG/x55+GKb4dfj2OuaWINJfj2GG5cNYXluGDc7Wj2F0EQMMeUOsJwHNbbS5lkttAHTMEKqEa
srGmwZeAbAVRy4FM2KFj0tk+AMeFsvrxUJDjmEldEB0CXxChyRJtVphIpqZ1X54bHJKDy7Lm7VmQ
xOILGqEfCJGR+C+ABt4o1ziiFpZzf+E4JH5J+NEmBH9SIIouty/whAd+R3EmFkdUdzYNznkMCFwk
RuFloGqESw0Jeu8I3ZwxtWD6uOdT42BvjpHxKqPqD4cUdyRJa3TPQud4QCxsFEniFTfJeJW9lbw+
8LDma+EXIklUXkobozEN34K1oW3bzqKIR23bcMImgtr8OTFMLxyT7OYCyJB/ozGuH+ftE6xMuBQk
NeDoVUnRRGaz7DByFx5bRSJpq7IBSJLf3pEMZ/fi1mAkNzmHmSey9aqWucvJbGGqRHy/MtIia8ke
Nmz/+59MernxvYBvjZXnnId2O82CrsM+7Hh5LoeR4rVvTuGc5E/6jhGT0cuDbEkweQtDILRuJdHT
2Jv/FEXlsTgKjekSqi5Qn4POr0zu/RuHea+5Vmls7n55glpXN9sRCDcdww70V5VZlT+r/rVLgSD3
gmstbT2RO8hjLawV6Epgueb7WvyaZYcQBvT5yw2Ru0kHqOsJy58TRgsgJxT4Ontp5azvR4c4DfBS
C2HkEJvZdSfvB6xj+WWUOHhTopY53V45UEXRA7Kh33XKDSwd5foqMQJm5bAjY0Z/BqDi/YYqTTCg
5lrxLsZr0l9b7GU/i3e3tdSxRwX2PIJ6OjjSERQPXfKwYoru49bl57RdpFJcu7jfffAduF5pn9Q3
3JQJBrOzXlOCz238b2G4okQ+8aUdcFKn7iQZnCq8ZBzyKo+lOTSdghaQv/yX6uit6SQorf5bJ9Hc
W7Jz31vs1vd4Flgiir6UTfQ+hATYYFJaK2K+lhdZE9oaTXijcfvrMS/08Qx3AEwUQKN8OhCLMB0S
XjCtERWVHFZV2ZsGiOwmFXFRvMYKBOYQnGgAGXvr1mkixdFksIkHUkjItnRvBjpQV3DDobJFPlaY
7Eo4+2LuU8xW61xC1eig+eZkqkbRj2RpCZztnWgRK+YgXJl0gYV711riJcNwOIsWty2DQLajXJ+X
KkfSHTEUAlfunp+kMbdF+SD2eBsJOYq9rtkuFoumwCiCoVAaZjW0j1pvbNOCFTcUPR5x1crcD8Sa
fRgx0+rSVn+aM3MmCmuQXENWv4Trj98drlxsdUVKzMqj/yOphd3Et37Kpkqfb6eGk/tinP5GUCv4
UnOk/gpGxlC0STJQCUWtmeKzABCRHq9ADGgllO8E3MbvnfFi9ugTc0WoZeME20o56TLJ82LICIie
pXxry1+HP/md1yUlyg1Dr4aKAhg8PU26rgDDDYnAVnja1ex9B5fxoW5PJ+U1sUcJu6YleKPzjO4o
cuiuCAqeKJDdUs6OHu51nW5ml9SR4e7SBdK0/SSglorct1Gs6LHW4jdZg+SblTmamkZRyHybYFEe
qaauQ90EI1K6oE6b1IbKRCQnCAu8bKg6vFfN4BcKeMHdVuUtULcld0MuqKVfETJ1Z5T0vHXYM/aH
cvp2qyMraNbcIgJ0Apu5KtxFaokRRvs9pGyMVStWxq2UMAaSlKm1FtTxVF9XTprHtjNqJLavhAyj
r/8ra1UDdrt3EHN5f1fZUJoYDwFKL2zSGdAonvzfQZXhcWfPlnAGv+KGROBxhxKsWsEMTdhCfiuT
BY4EG7bcyucu2u7kN7IldqeYMUyTStwntyytjQdY/spWTkvSoamtfCmKCwtQvleeXBVRr7fRP8Vy
nUEhAS8AiO2az1cIH6uRLkVUOjc304axtH5BUB1Seg1ex+CvnDtVO2Z4GrVNkOv/kVkvI3gRJY1s
9KzuezbBlyRpToUDDPXQq5mCkoPS3VnbHb3gBTFIqr8aWm7RWSQY5AQFSc5FeQ6r9dTB+1YWbX6I
hZTk8dl4l/cIehzoQV9E1BcRcqQ3yVjs7lK0JKCpLjpROWYKr7a3Y+IWnOP+1PaAXVdG6Zrn3+8m
OATD9RrXw4P3XdzMSL+/F9mm1gbXVVDc2zQVCd8oslSmDASazdrJc03XQxpYrsNp6z+LVj7xt521
NYVkmVaIELI1cvU2r0NcgCrnJm+naSCRbvatllqKRsvRIdgZD/XeNjv1FLC7Zf4FZ+gz+7RXN0p3
MGo9yXisMUDSe9JcsV/dUDqpd46D8kwk0KrrWAhzxNFfwaT1VDD5HeqVhSYmit6QKXt428WuH/Ky
/NmZOcVPxI82iu9HkZLuYr0WInQ6G2vD4Epf+/wzJsp6M8XWBT8yprswYU5WHj052BAlYF+XyYxD
h4X9PELUbbdaK7nGBlAwSPSqZBqY0BIywOioPcBoHaWKxqiu8zT5OVhgFbBrfjSIAkO8RzeqVmPg
Ihv2XnriV15Of9J23mGzagwDI6MUGK1rG87RulD7PYBeZls1va9a0WzhoLslgsoeeDVSEXCPWlpo
Gd7TybRH0NgwJS/BFd9ac80nldPG58Ovo4VHIzWBd/U/l+4P9wWn845mPR+LmUrHa2efgwkF/Vb9
803mGLOkepg1ys/89OJ0y+JWA9Jfi0CZBNlIpQ3ZmT89lOLb6jSuCEmWm3s9nbSI8A9gqWaWmb0j
5dHI45JjhxfCBHj1goyDuzo3e5G4ZXM8ynGnKhMIUIk8qAi3cBSL9f6/rScLXcf3cpl+5xzUphDY
VVOwdeUGyetzPwRoJ1wc/nqG0EKiLwIW3CkRe8XhErWshV8Bpgf+1Cf8et6FvHilhBivSc17MSDk
76AioIhZHMKm3PyZpOZQMvM64FwpsuD1UX6OI6kiAVBV5VNhXjgaCHNH+74Hn8u9XRVgYjFoajBc
nSlaG8WQEK0lyQsLGiZXWuy9uBI8HoW/7dsejZArNqb9W9b5bM6ABbb8qIE5ql0yAy296qIpBYQl
ZPruRL+m1/Ph7h31gh1hc/xRNTCpJXtYDa7u5Z0i6VU+S5iMdP5ScLl49iP/+aT+EYbCb2sJdn8P
aQY5qErqGZsGCEJu7UQzGE4XI1a+3SAOKsSWxFMGe4+ojNt7bjCGCkCOsmdlPURjM+gtj4EHlAuV
OJLCcI15oE7mAyhb+J3ozLRaByOPhblKI42txu7CtOR20ZB7/apvg7FCbcOxL0duzO6Mdm0Lwzjv
wcsOnxO/7CiIF0Y7ekCsi0SNaY8l6Ys6i0wJLrFBypEdAUBEVAQbBYNw27jq3NI3R7ZntfsJUJuq
goBBbw1p38+gkeYWGTVgzuvi6yut8yVXvE+AtvpUO0odUrzGxvD6aPsiALpFUPcy+wULpmPB9gyW
K21pwFE1xyNNKfnJmYqWq5PsILYzC/yBT84kNH18NgVSK6+Fb2MoX8Iv55ureuEbCw9Mtz58k5Gd
FHldQFa1SWdC/7DA2JGxPPPUEtOk1urjwj3NX++lOtGAQjDLUIklJ27gIJdFZfdcoY/YPHtaZ8UF
k2MjMklIQqq3vtczgwsINsilApYyHJUHqYulPIVU7+ayjiIF0t1EEQofjttZ8bHG7M88KthWm1DL
xBhtxuXaWGTR5FE+MVJbSdD3OPyXACt3bozhhgzdhnyXkQIhSWvV4Vd809hqdorBOSDz8yoYCKhq
kBuARjia0oL/Rm4kjfmkZAcNo+WwbyN9sI6twtDW50zDSnCWR9mvc15z3R9EU1LKKeOw5dPu1ImI
bEKIN4wPxTaT/ejZkO3ebN51rjFJY7KHCeqLxxmxuyRf+sonjjHqhbJF8aZb2teEp9TK93HH+DZv
y1lQlnk9lkLkAEyvVoJ01TpzJ+YS5Wpc+WbsjFVkSmpVmvFzXzNh7vxUBY+pmiehsdrjlWAhFLb1
TZA8j2PaV9AkENU/31ffYlg7AGLMrUSduNN8EY99a9JQYrY8NejRCO27Vwne0lgt7KdcChVBGo7R
QnmfaBSPH6nP5vinukkmrNF0M3pOBrA+yTVRSYvH8nXVh70fkNSLNPUaQJqTpv2Fzq7V/gU6Qvx8
j0aRecrW3p1dz+minV2JSSU2grjPREbKi1VJ8/d5iogJ3ndkwJNVyPzaGuWDTy9GYFeBv5nlWAl8
qNxLPfoeIOsXxJO1ulY19Q8IpyOtV8FbeAFj73UWcOj53xrlMFBSOQP1Ny7PMXMd2WZRwPYW9GZa
Eh9yLy4zx3nYlg3gzMN194tSWQS7b/vaXYIKxZ1ni012XTd1U1Cl9CDvGSMziNDpqnFrM4yKzbxR
szbP/cub/RO/kM+Fhc3t7liRBONxcFjLP0h+x22F6b7livyD3qOVji8yJhBFYrTh+an052zS5jS1
soVPcF4s77WIrdWYghNAPpqchqCszs+PENI/L2h7imf3qM4TzAIW6aLohYbaZVD1pz2lbSGryRxw
kCk5nI/ErGbX8u3pWUQ04Fhj96qu/ceq+2WdoXxO0ALmZxmlGu9I+TVGpjstVqFyCawzYs/w+SBq
F5Oj3oBvItMG0NecRafUtzcsf8HIb7EhDU8VOH2z+tBbBsuAAmWrUiWtSUdFZLlPiceqsoxpKjeh
+hUZhJD9FSSQpHew0huKTQFpn9Qnz+cdrcMT3BPSDCMoJkLLbLpBUru+SucLsz+px1OiaZjk6Cap
kG2CF9+9SW44m07FV8ZKbtMXwNdV60VHLNzWV7wd+FkgGlVJCAggRcxJgucAswS8GQJlAGs9ZaSo
bQm38M4y8vhA6LcIksAR+qs3FPZrM7mb6RqkLx1i5cwlPeUb5+NC1DmZxTbIY9WoGUgQoRpG7jLi
DQA9ywxUk2F1SO004FVnhnpPp++P6wKl4z8tzHWxXVXGos1k3mNToSVsLMbDsvAH4bdRdGCIuwqS
CHfPsk2D2k22IFXE+ExA5XxToJxR8gat3qht6rUPlo6YvCRzcReAucDs3BVULOVbCcaTA6oYL+so
DrLzrc1vwjT8oubuLW9/c8v05tKzHTK3lVW+Rpqs98gSrrFphqajJ84HU0lyZr2oTDsvyC8hXs06
I4ugfg4usHbOxu270c4zc8FnWT79k0ftwY4UjKu1aQCJPLlHXmhNq74ctfeiyO8k3OUbkJcSQHoM
be8nYshihtFDyYV6FNsVamU3EH+VLqjm4tJppkSCb9Kt3AP+wx6EAgFmtc60/EHIkf27kOU7k5vo
igZ7kLcuTjcP/pHpFvjtBiiT1S0j6O9miqyl8gXesZCr653u5trsaVgGbiObAHLif4nxmobHxcOk
kfDYwhDJyhD9U6FtLrLTQheGgQNmVOBc+n8ZZn2pyzCM0xNvmC4hS7CbemijkS9SOAN9xhtZU/ry
EFrf3a90tR68WbVq/lq0LzuQk9rcedaauLFlmMrLKJ2IIHSITebKnCPWmPdEUMSGFZkzFV2dsn2i
HKc8VAVztFihEwp2zpqP6/D7ZUqQ5++A9LylaoI6S0gZb76ffPE4SDiJAJFOorGhlkIBCcFsg9c0
aDsS998pvgT5Vd0yBLY6/pR24sSlj9IPX6yDVApLVIYSfGQesEeyZZEQbVj4YTdt0MTsLaEJh3zr
AtpyQHHFyert3+y0U7XX/o4pwBCCTNNZy/Nw50ejZJTfb0c0P7cKoe5s8fnM8CZ0q4BKeE1hvw88
B00AoTi8NSenw7kA4D/knRMsLJrVmNEXciz4KqGgitC+GBm2Xj88Q+3Ql8nRx1WlLJcBOrLxwYH1
8nDOPivJjw+KY0WCP3bhRxbm9zmxgiezM5JtiVMA82jk70K8CtZjylb5nDVaWJL/gp3CpEDexwVt
tI99q1W/gOzqtJ3/rtEWyE3p91/hK2AVUOUFipLiKnB7CYYTo7vFwq9gMu3e3cANSSD1FfRHrnU/
DHvSTdGBna9otXTdZ/m90BlmjHNQhhl8fHfjCPfTYSoHj1cqhk6CMA7ofI0W4g/M2rC5dkdOVr2B
vLm44wmQ8e/OqDP5FIMXGZNvbjlsKnbN5dMa1UqAIO+QDCJFMuCwKyCz7jhYKG8hO+N56VakAbRl
TMDtAAzwaKzA3LPaVWWiipuUxHUyvl/1mTUEMNsmjrq93hfh7sNMX1cc+IXDyAJF/itO5vYCoPmy
Hi9TeJPIf8dHcCpdWUsIoAlx4iZm864SP12A4cgzdW8SFtKIYGz5V+6WcxyHt+veDSWw+pTosq4P
cHx0hNp2e1DF+0X+p+wdrgGXNxgLbpmuWXGsFtfikPV8VXdsW/FF7nTrdjvlRG5fpmYJmusb0wH3
PjQ1Ez65UuB7Y8ZvNeSUznlKBo8b/bcNQr454BETm81rD9Hkvf1XiH6WBuE+gLKxC/4OnSChiitm
JvFV1DvLnCSPnhFuakYMXsJl1gZfx29rH2zEiFRlqo27GHpnFsDs12lv8WSkFC5LyGELUMN58rB+
KRCKBFDVHHpNXIlOmSImldmnBbii44tUuOi6S3eQiAHqp5jSGR1yBZH90ypQJoVLF4UA+37EDJz8
0+Xg98aQ8DCD9DZSuzftwNME868i4D8HESOswOD64/QvEwMCUknO8C/Qib9v4MNgNMDf2fGFow5E
QUtlzziQPNsQ1I5OyQctfgDwlCFpGgos+S9ur9cz9sjmrwPz1MyetZfui4f1UoVx6nhi4BkV22Dv
yu31EqFtoGBUu5j5ybxo/KS5KqkIHrfHyitKrDZPplsGiqVzBiuMIZ1EYkNrRDEA+zglO62uvO48
aDPmnbWgcxe02K2G//NeEBGjaa0MCl++QLicIGd3PeOjywatHpBtBi7CeK5ufMcHAJiZdVv8CitI
acE1W2bgIgJIXMKKfrHBpHIAgo+Jf2OMt1X8mK5FFNPJtFZoEPj5Bp6nQ92lBrG8BOi/nACOf/y8
zXGfVl+pUe3aDC0ARdapkoyAhnWnbBKMDGjLSApEoHM+Xham/P9OQ+VHk+93CblZoxMoWUpP4oZy
ysA4pErCFiWQ/thZcsL1QvPqIRBDgUUX1XWhSojqfOfu45FCI+FzrdouBzgjXdDnUFX4AkGHLTOB
zAecCuPWmAQzex/SctszhZaKvMohFAlsa3WkgrorpBXW+30SGBUWphoxoXjT2HXm/WFCHcyCaxf3
qmTs1kF11w0a7LXGFau6N7U4b5AhyJReinYP+vfJSIdoITTGEVd1tmsCfEZcbR4nGEbSi4WAo9mo
KnxszOX2mwSjIQbxyv/O2C1jLl4Vx44pWzSj+mOrGRnWofrjkJaVt9cyDwZ+JJNB0NZ7wyY66mlF
f6nhC575JFuo3DsouYHq92RgBDrIVIIGzSzdVCSDzYBUBZr/JVYTLpk1bM4Lv91SiEuXfoWXBuXQ
X7wNf6X/q3yFZ0OGJHdfgzoCpXAT//JHfHdQerqceRrO8xYcLI3WydanCGGfmblzFbTJlmL9thMK
BYwF6kF7PWY4Yh/bLgFFDzHTCbbyNApO6dVpReqZp9EeUJ2ld0dAzjf5mU9eJUkW3pcxLka0d8p3
qog/RFf8g7tNqdNmY36GkToAoG5vsjX1+JUazr9Jkb4EiYRNBJqs6ITTXLuWp8NT7Rl2dfck/ZAx
wuv4ObUKYUGzGuyzBbsGwHW4QKIPtdS2rc7rq5sD6ttqBdIqRVSbRq8eWvUYDQ0dkyvVs1evW5H6
GljoJnIfPxFErPylVQRHPDMhglQedtzmZNAtsGuZJokmug9uIcwcYetUMJ8nOgSiYnq02x7FJ7de
o4qVw/Wy1FaNC/wwUwthErQ9xi/C6R1B+VIIt+j9pISVjikGOzyE8PjN8Rx+nkOgabDjo3iKxnvA
jqHLWHTrQaUUWNn7bozaxXlu07v25tH9GJlFmIBxxyPC+Z8FgrqX6ZZm+/VSXdPTEEo3/HHAlP4J
flmBKiM0ldM2wt2ODCOXLwLxsMmRDPBPUfMluLiA40i2yMQw7UQDupQUT1kK7I0SfgVjDejZ9pNi
hDB1mRHPXuDUlc7bFyjr9nd7NOIiRw9SCgquYkBK54Vu73ac3rVbtB5w1Fjqj/RkxCkRsakzPW6b
anPWaKtovREQW+dIj5JaqnRpgtkxgHhwE5JIK3VrSvLy03aOG6TfDpaTfWtUef34DSRQzEhzI7L/
i+SpO+VRblpf4foh/OhUTaTzB6tyb24UIZPVNRWNaiklkPK441jIh6leVmIkgIlnWyIDVPNuChWj
Sngwam0CxZctnJKxniCWiidVxxObEcekuJL5Sd2ufiKSZVngbBQ+ZfzJC34Ke8FQn+7j4wrgyKBE
V0or6utq+25ad4xCl47xV6nHotwxkhH+tfCjWhBEGyineEjU5U6JqNRJWLMyR7HFo6+sUzkfC+N2
gUdoI0u1fEDngRvsYjAgnI1wPdR+SUF2FAX69vTAsu1pr+OcKEAw+43E1Mo7O4onRMUUianlNxSH
Cr1PsTMwQUjh2DNEiHESyLIB4HYqclbSHcgS4xqX4g4rYFLCd5VKDUAtVVyKE4sXxyjnu5cI+kVx
zL1Tq/oQ5YVbyzVbBZ8hD+224VIGDySpQQLHq+m1ypdAio3DOcT4kq+Wuor98QsR9DmfY1kytD8Z
gP9mEAarCR57isqjy8tQRfKLSX/SyOfj7WaUcbw8aBqCMRgakcpXUGOcurvNsF5oSAlYg7pcAAcN
hfLL/vcocG1l2z2f77QWF55eDeb3PYi5rZvobfP8pWaHqqEj5bgZ0sdTzOosquFWg70fnn2Qn/XP
RUe5xS05YwMECw4swz7zXN3D1aJJNUiJTiXcojVc2WYxfEU/KQB2gz+8T+Emc+aPGCXSZ4NTSumN
XDu3S7It8pH63sUfcrZd/nlRS202ia3khRoVWv2Bs0tynqpr8X8t+jRq+F7fjzCuyNcSMa2Pv8HS
weOnyEV9DgWJsh+tiRfDsHyLT+7x8JRMUeu6zIyvmVYAujUodSq5ORgEfGDvKg1SvRu/q27uG2z6
Df7EylVtcydXH4fVqdudsMxMQlzHtDQvDm8JiP+Mb2RFQ9+rYV0kBrCmYcXZxadgDK9QJ3c4kia8
O9T10DwYfgOC+SWwWeklOoiLXRy+fE1pcp/2UDOHdXBC/CANbP21vDkClsnlTO5sI7fpdczBCkKO
g7hd3NUxzkFhfrH9wulOGAxTzy/Hy1HY8mp4Hz6UfeWaADDpF1KjZgzdzCDQOtLzcxEvW75l/lxl
ssXPldKsZ32D55iiowCo0OD9LhAKxpDPkNRKNDMfQ2wQ7ChrJjSgHq3ze03NzpvzFIsI6yYuMVnk
BbH1aRFfF3P8pX3quk6ZIgzeL05JO0mUvHjiQ5lLc2wvK1ST520XgC0iBJxFf4nuKoi5kI6fUWSE
mYqsPLbL9n6UsPdz7o5wqGr/Ar2kjAC5trzSH/Sv/CgzcNPtZqSU6eLt6I3BwYV/uYGu2Vijb8ZD
mq83tkeHVxd7yt2m6bNHJIAa4jZvu0NhlSJ/qAwwXwlIjwIgV4H5z2CubUgWx/Ehpjd2AM882/7j
k4EnuXpRrASQx3wsy2DBNeSqs8pDCJodWGWDJ85xAZ4YGXxp5WyKSTZC6TaUt9uSQw4hMfVrjhHI
vlyfZcoICGpHhQCC5VqRFkKVEcnzkdVnjlfXLumaSNjPuVvw901CjNrBsiMJ+O4fe1Mmsa1t4VOF
ss47PeaQ522SZ05RSvfhrVhcw5aBPfxubo8UT/7vJFTC2eJ0Y+kieON5lOJZEZv2H9wIxXLvhWaa
CSWszouX4aHB/hI5vAYEUrDuHUtYFS+2oAB4gKfeIXS0L3NqrL16tKmmrLrgyFocf5G9oItUG37M
FrfQv8OKElaWo+OfBQJmvC34iaARlRW7KJedKfydP/bAH317imX/s5+fjKyqoZtGMf/j/k6JR3Cj
5G2wPs44VnrwQ1EJ5GWd1J6f/KdKlk8pEhe/lQOXJ6BkyfGH8asyPiRfVlO1D8h3flYo715ZgaBO
qZlDlcIYuLet+VMeO+QfIYtZb6+SPi2KGZFjGP0Ysg3VIqGvbUuaOCyDJGK994m3sehJgLcgjEZf
hWWTJLAbUBd482OW6/Qy9W0ggNlwRHlGmlQYFr8SqXid68xh+oCOctpYbvXflpDAx410rLkq0De1
PPNpbVQAjFuqwWTksq1ym77izHvWe2nIR+jCImBbwXJJFl4BsTBZCvKuhqBm/4P14oRc9MK2nE+G
mwePYd/q+gtPkcBRwYwUgu/n7R6O5cT2Gmb1QmdEBC7vQjwYsy2ceFb7Zx7pYlM4tZkDDkbOImmr
plrmm9aYlStB2WcPvNYw3dm+D+2SRskDtK3WGn6ftrezxyC4t/UjAkatd+o7+PljYizinQkKPe4R
enCBMIz3K4Yq/HlGGhCe6t+qoFIi+uVkt19GhkRF5hBYqqiNT9rCdOKJlH+4pgpIGlGUZi1mFEPs
tyYrQFt5qz7TFUVtymF1UbPXlmwlgahy/0swt58MjqWvtUCFIvQKplvR9oMQ9fLNhmoIGqDNx6YL
VwMYE9Rmg/Yfy8zSNq/EYlRYlyeKZ8lbN0qNNJpzrFVFQCDA4JVv4sPPO3atV+NCYhJ6tHvntbix
sQzUuuUkgaAaSWveW94quo5DhTCe39g4tIQjVLsVKAkyO8tgpD60/iVfcuUHqRi1r2gE+dQg1Anq
bbRkT+2CvCtoZti7F14zt21MCfclokIUpwdFc/F6j1Tuilk+nCHO36m3b13BR8Y9Z5NngW5TScbT
3HOgOOYxziI3ZeXfcRtz4qkwuJ4s6qMSG0JZRq1IdyDzz5TrkJ98+9eXxYTsNLT5OVmoTS9/sKV1
MOvUzEPLFRv6wqu8dtxGdh55scJS4x1GhUKdpSt3RWzVTbvVgypPb6A1CWJiBr42IfOMiqM/qzp1
KTpz2AI/SvgMHlh8E4I8zJy5nMy/VWXz2x6mUvxoUyPKzJAVuPPZxFCLAAK8sTx7alFMF0Reu3MP
2yqDFRYVBj4EkteXZ3gFZet5J9EG6x7I1FlenmK3IwhbgGk+7SYjDMeSiZLQmnKeE18XMMeVkOhY
bupjOGw/6jzOx5lqHLOMG7jUBJ1hDM5TXH+BJqeOam1N67qiUNJlrYOCedcY4/uh0hHiJU2OATSW
hy1sCaL+ob0dyKvasvsuUwHUFcPVevIB98tCtSaq2pC2F2gFDN3dDi7vN2ymXrn/WGRjD1xakoIB
QHUaTA8DQ5SrvQOUnqh/k4QVxBV5DX3Nv6KZnml2ui0FeLGgGZ6BW7Zds88pH2A22sCJm0du1lHk
i7cM96sLdDdeyeh54/qKxCbWssd0FxjIQ6R8lwJdToJWvpK5KotsTtmAb4mH88CDcL9h50a5N/HZ
HB0wlN/YgRsJEL6CbiKrheH225yCPutlXl03wWrZOodWawEOASvOqWpGIRrXC18xJRH0zCyQfAgU
p5G7bhs/fwdDEqW8S1q6b/r7w3zUumKH0ZenIQggA9OQh8p0uEes53F1dfOQOssZiUQgWSEkT4UB
VwMI456cZg/JfaJOZ1Z0O9D5eyLlTjGrseR8pbgSAfBGCNJXkawm65N+/2nuliyhfeRGNsMYN83h
pwC40EEMQk6B6gGMbCfKcCgvm2I0/Ji/xzI39YK5s7S4fLNQXIrBz6JRVrAPmtE/J7eH1/p2IMGd
Ifl8bSLsXmRke9O1EG30AVIR7L/bYEulLG53iqL1+dngpjgSovnmjA5W8J8PyAfVPDJCYW1tC+uj
gB4gV9PKUZS4F6WKXN9hrPvU64377toQ3jeYeb5FogvZghAtYmuDjRjd/UgTheWiRYWOE2ATBt4R
jQRkjxELJsHnpmpa5K2y33M/xVTCQwb2mhgK3Nf9K52daTX2yySm4xb2+4N3J7ii3hKUE0bWF3cS
bjdODLqAFOzWwspsuJpsEYQirtTkZTaxbun2japK5EzZ0v9bT6kb53ja0Vl+LGWpasuLRsr5n6k8
LhiGQLWyvf08Bxi6pnNnKJURwdVGkmAgkmMGOgys1Zx4IZe9aB811mW8ItW3pixqG/I9QV/PZs+i
dvoTd6NV9thSydMkHr3lR1DoJa49NXJK0MXQnMA30OouMUGXJj5rMH81Mn3GDqVpltcV6wiWPNZO
7Y7kG4/PvtZWvqJ6q+1v4AeclzApLrNjqOpXXztIvhwgecu/HOKCd968LrmYjiZmRkj8P5Dba1Q7
sHr9v2+EhpFxDmZb2uDDBy6HVVyd8GUoK26F9zG7i1ck0ShHfRCW9zJ/u8PA1pKvP0VGYYNbXe5p
cp73SrLXTQ7ikLiIyUnkj1JuW5l8Jpk9oYKKJo1xxZp/wjNz8LV6aKqdIbpn9E21VQN8pbvncSxl
+xwossuPrBuf8F9MxI+1yXw/ce3Shx9SQl82GvntM/7O7svRBMGMfc26CD3iPjhEXsXqjjTxUVv6
ay7eToZHrrvw+LFWX+0Kedz2nbCtvGgfpxjGcBBtfwClJtFsHRfPBIlPh9tiZGcwWkfD15RtjGQI
uHcW0Ahdk2/90lpS818FtsCe9Tr/obu/C6j2+vmihtoBJZ8sji8L5Xtu0RywGG5GFcwCMP72rTbE
sbZK/sU1BPs5a6LC8dCoVQhWiuTq+cB3kh6UH405u16gLOCqJIWgtUwjewsGaH5qEN4rH31lqdfH
cvaSUn9owBidvCarEz86NZABdqjz0Ge6cWY2TmQCiWkIJqsEhXcxx3ANXpCONMLYod6gNN8MvGSH
QrGm4VDoi5FrmhnBFzMRZPOkHTTQzaUjEw+53XVDIiaDtR61Wjzo4CDcHKZIHLvy/MU1t8fecCiJ
GBVcf7AoegnK330NPddl13kSErvaMM2IQ2hMdcFh+WHywxRW7LI12almkfJoSah+sbiRVp6McqED
WJsTbqQiPq93YNhVxxaO741grlH0jZnheJesIUomp80L/w8RYmrvm0Q+X85ixzR/5ov+GwNhFqGj
tQ0LEVzbrDPVlVLdma2IH0zuSVROjPFk2EhnEL8B62NDF1NDA0erfAPCdAnwZ+SosUZWdk8mbcBd
LWMVp1Ayz6vH5TKaKp1fEFpEQ3YTw3QQpF1pPnjRhIs09A23WxtAd4Fpuswo3T4/KIphQzUIzvOX
4eidjdKByKsaWyUwQDwms1PDryuTS2qSJ82PHjiuXlLSG7nZfYnXY8rWp+G6OwR9d9aARH4pH8dE
2Op0Nocx3W8LA8DfyM90hN2h6D5bNWvB+16jH1zwccGtAQ0dp7j8deEpCOY6HOOxx1rOafGCQAm8
RYkepSafTLW54lZWGElsi1+39N4haK8IL0qJcN5J1xtGpLirXfaxU5p5MLRdrulc+qJ0aeTJA9uP
Brq8dVYZ5ExnaRBxMJEWL20C6t81iNLs+Hf7CYmxRc+ggzikWJWDPqOkmhfcO71giYBL6MRvtsjh
7dS8y6UmHIuKh467kU43ni9vvJOrGh6gyhfHQuA4OxCK06paMUo+iFpNDDakJgKkaabQYkVx1foq
Bd65J8UT/YLhuxEZxqeNi59UK5svLT8hbAfBqnDcTKVYLgq7IzIYJkfKvEMhXK/KxJG2TjmVDwc/
Y6gPZ8n5B3cAVQ8Ezm7qjMsYcN4WYVOhs+mtvfSlvXBH0Fm/kuUtdUMqICGZOyVCGFcSmJ+aDPis
iGLboUpyZrRTOM/RbGhR4pqtlOGnoGCYnAbpE3OyabaPGJq6vXGJggXu1wRuCkhreSa120HnW2PU
1TUH5gcxbI/2Xt/N9thZatl5ObtxU/THjfW7M5Cx5s4I57EHRFXcMwtso8yJ7mM5rTLfvbnCMWvq
ELAn/6rv4VYu0reKY2hKL8mOuxFaUdueI5dD1gpeJgV9DG9guHLMRzZbLgEtXMfpnNnpUElOhX6Q
5CmB5Ptu8IWU9heL5j7gvFhTSGQuh4Q+Mg/ChjiPP1uU4eLNwfNivhdi/qAHlFhAox90Wh7ZYIDZ
4rZCFs5REWLxfXrQs7FSFeJzN24SD5bNdulbclvp8oHyZPK7+YwljJVKBk83qGcekPhrBq94XGPg
VIsLRBkVfitWIrqBq8q+HVh5XpQujwiLgkBfFZ/nGcTNbKCUXKhzWHyD4MY6hp8m/XY538CSV4g0
XwUfu4PFlamTJ44oPGo0XvQJDomA+M7/vAQzEo4s7/2A7OLqhQydyUBcaEfcHVtUDkEDyjOYlMF/
glYpBUDI1jvDqD94Km97YNenE9qsj+YCB9UARyMPCNeNfqtzZaw4CgpoaMNdTQ7TKx7N6OnwqLzh
RXjlUMUpNPhwOz6+5VBmx+5McZVX/1UbPaTFxThIMAkww9Pj73Bq+b2F+Rm2AE9uWN9NswNfaSKE
7XyP19Rgn/B5L5YSzfGam+AHBiWEuV98KX+d35CYRx9nukS2ghgSX1x9J5PAq1ROgmrl1YQXtOtE
FPEHxtZNzDP2mSThYGdY5qIHEesDKLAqrof7rTTsdtq+b4N67pbYehIrzhPbQ56k5IfBQMuZ8E75
LQTrNHjAlz70FAi8x97cC9EYgVWCvraRvAQCuOg3YVjFruyNFCJoik1OCS7cod5OAE4PKNMMaPtn
2J8OhHbsUMPHQbG9tPWbOO2qOLafr5wEi5216F11VS1vi5/MMgeZVx8OkoHzokLZwacXNztroGWF
WFCmYOjX0QlBKAsHirU0Bt4RSVOYU7Y903dva8fmxvg0vf38hGQWmWjxZ7d1+PLK8fn5atoPL53a
K0yIycCI3RHv6iB80fJJ7sIj6SPkcNV36P5vByrVeUdtr3emXENfAcB+A5+Ci+0u+gCwNatcJuHH
PnD8sl2txlwZTUaYChEO2zCufUzLvfmQjxvyVO5l+UeMwFLLy7lo9kbVxXBFsM6cS0BPi9iCN+MJ
JB0sci0GL2BLBOgs8JObE1LreepSYHJ5/ScH7tw2OZSQrdMqqIWp7KNHXw8qeCK3cOw5nP+8fXUr
s7xx7YDTxn9lQ1w2FjDBnDgABWRXpKDnzabk2bbiBIGrVp8Gl4t8AbOxp7rdtlvvh42HnecMtSfT
+zVPdiviOfDxh1XqJpPzaF0IX/Gr+TZXsQ22pon58tIVxjNnltVA3d0qrGj+/HGvLPZVPOnX1ktl
CO5ET8/ae/QqzSds3PQ+jJq11QHdu6Hj6VRa77lKOA5j6cJU7692wELezZf8AylfvsLiCjZyQmOr
/2c/wToE01XZSKa8LHlzdP+5DnzZaZKmInj/3AFU6nLeyWjMIY4JbzG30GjvSk0pu7eAo6Bvg1F9
d6O0na5aLfcaexB3gmKeqzIZEVaRo2Yxfh/j6hJWW3iEKjp6kxHO/eG0/qzdxcSwZMXou5xM822/
BkNydY8Vj7rh6BUOirt5ebfMiAAZxrlIojnx1cwm5xysY9IJ/kekUCvMWW4bKL6JFdspK9QCiO4Y
4SU5rYNDQ0PL5toP+MITal5SrLUTK89BFCUZ8PIgq8vdkBsYCpDpk1iLhj5WirhPuGRlqS7k8P2x
LwBwqAo/zNDbeqRiZPDcQaHgZoZpGFCqOHMXkpbqjyILBJlsBOi8ZtCbUTmS7ArIEITiHis1gAQn
azBik7LTWD8O0/AAVxbSpid9SLmw4OBv0pxPtP4sm1OjUkFsZ0ncGvVcmA9kMxDlFiwcd5F1Ka+X
cJi+3no7fy9I95KSjtHO2e9XjudlmwX3v2Q0AOb8LtiOTzs8CdAZ5LhtB5LxOWMVKHaVfPq42XmB
j2baOaYRU44i32//5SJZw4IDyXUvzFal56CYZtxu9Cgru8FLG2skCejzH3aMXtm/Jzzc3zqJeESv
Y2fB8C7rgZxIDQZJd2XlmJfTZOt+AfC/4lby5yCwZ9uqemwPhUi46neE9xhccabGpDw6/EK6WPgB
LGswUp8CFuQeW2vZAzViAzuSlbyqXqcw3913vIEJTpJFifWM+i4D/wb6BZtk8WpyKqPXbWoUXS8q
UD7yAP95jcvo/mtCBWVz7dE1VSc8ntxGKM2MLRSEk2to7h8tJ5+s7nI+oo9VWSfceYu0338KqrZN
tOIohbVSnYkEI/7oGDl+Azvf3Zq0r/rbd8P6XUr+OFsetkVOg8TRzivvJICuB2OVZCkWuso0Otsw
EvuH9xMCiAvZL3UvPnK9HwkezzmzHY6BOH+6wu1cfS7nxRcU326tz1hryHZHlOOLevL4FzNCXWta
u/TMR4CEyakuEVfP2+ohXZR8txuKs/PQP/APfagIxodcjjCI1jYnQ8Z8mZDZNiGJ+N/xQtsjBwlH
SPoAAgEoaZstgvfExSuliWzeVHDwljbRGWDMQJyizq4qk2m6SJGwQtgB3qJHWb8Kltd4G9XFz2cN
P8Q39LUwHY5d0mIirDv1cfZ8JB/dCekWbJPLqi/ASlEMfUYOuIbRanuOjz7heBhXNTsAZ0ysNpgx
Rfd63D+jz37Qz96hVSbQsxUuf0yuCh8nL2SeBVLxgEZ+eelsYoX7d8xmUBqQY4l4wy3OtNmH+K9D
YB8ZitZ1v7ZZ15K+AaRy5/0ZLI2d5UMPYjc+hQQ04Ic9kUyX+0/K3UWaIchvMhq1BqEqkdlzDVbE
dHRvVVBow6ajzw8u3C2h9scnIRjcpKeR9tAVZiBPF8wF+SSHWCKB+mkJcDUpnwNIBlQglwYwPTwx
u3tJDWjiSCbwwch2ITtiRZAXz6sLiYyPS9THx5hie8y/LdroCh4l4h5NHYrDivTGPEo/cjPEDSjG
TjHb6L2gDlxdKWfEVvPH04syh0v68b2ieBcDw4S3NdWEBGILgCfpqd/U+absBjSAveQtlVideZ6s
kUA0dG6txtFWWi8v/cLH8X/Wtf2Ywma2ahgyGxYljHNa2d6F8kLNwhHfaiKgaae89ZSH1cL1QTdv
Ztn36LfNq7A7oK6Rofx/EEDsSksuxS2zRcZhbw5IqQa1oqQmqrukNDNnEwtAGoxw/VDFOsUxbz6w
CHZyMJP4zc1h/RYQIWg+0ZbgdVRxKlS5bAqNLMvAfGLE4ceuhaMEUsidfdFP8e2cY5wnlsH1v+px
76r5NQQtMFvr59f36rdwgOd4YSKT5fR5tIlnR7V+No+m8E3N+jW6JnkaYHEXP3AAi9ZbpnhfhbqZ
NncQdVQjMOpKYdEzBROhbZJuGWfEek/UqqbKEmdSGQv/ONoWeyYGAfVqr92jlezfCxagpVuGm9sh
T1XytZ5p8RZ6iS0QoTbBxqqkmToBtFMLzqEKoIVrgq8aC1oAXxddozh0o9mH1ztoaQyvnFl6UrJH
49ddBLMkdzg9cLrSfDARQGQ7+kfY7ni+gJXQMWpVWQGDDJdXYfoDk75yZDDd67BCXBv/bsG5vRHF
0BUkgVlPc0Vi/vpFF9k+DR4vin5/sxt/F2ZIUQshpjoK5NJI6CANTN5cCbrZLF6dxWWtaY42SFiS
feO4hSGdnA5GtWAUvaSYgZkpNHGk1nzskC7+EbP5vzp0kRRI8bh4PdHND7n7LKdgSXJML+evPlz4
fgwz3ZMyjvsByEJkNhjt/DgrXcs4w98cwGrfnieEDG/0lgbtoWykFcixIOd8xcIPpyzUS1A9T9cL
WSS/8dEkrgW4Y/JbSX3RWo30wFNYWwbKzwedNuQDvA7YLUmKcBJmso2UZRrEs1kcZAMvAQss3ZpC
sbuklvdeJomZ8xuUheqAvZboNaduPM6kWA8/xmGkOHdkDSEfnxpHkmHwieI4Oj6RtxtTITiB+g05
dlyNbEN5YcqoatiRQcHSehs4IEBlUpJ++NqibEVyDLa47ZGTtyTTyGrv6MP7A/llnYp5hRm51q+O
5m6ZO69BiUxmfim16JWOdDuho6SJ1bq1UeCwOLoYLbcAscWpm+6seurTwLvqdwFWMEjxBfYDDzMD
sG5PNw/dDiC5QzJJCTIHF06+xSRygse51P8aqM2UNLTVkMsmKRxf1f0nmpwIGf5WEfFDu0wG01rJ
Mjs8CAqUBdtSWN5BZycCYV0wUF95NmosuobBvcQk2UaB4cBDXDE5A+/DOfbMHUDIjt5nfi9aTlA9
++A40RfUiCPGGFpPQMbsSh6xhkW94eH21Dukaj7nTyRzPL2l7ILU03R1lZLpghDcCb4mcWO7VqWY
IEmuyYUDH1p4t0/2cuk/vBh+YJdvNMN5xNy4/O3h+YWVSpNz54aW0wkrllhpMEj5FtAUvhXTn9pC
apHoiJi0MgJYGknzJ9g1uBP3ZkD9fYMvy2MNOQfKL+JBeBpV5k/AE7nfBtrISEHqEEdKgnJ2BMw5
/yW5XX0P/QPAQZ8u68jsNX4SkCRXV6X3BxOSnDKJ4F4SA3Dbfa2eXzkvqZDQcbQyY8Mny73UUXAf
KESYN81BjlXqE8AFoTKJy4aFYQWkc0PmxxyoSL8lkLFqj26Imni31ElBK4qWAJv2CksIF8yNg/8L
qPz/eFNge68RrAP80IJZanCrmafIXvqJEzo33Lks/jPb6v6Q6MPFpkCMDugznps2daKzJuIHupvv
Aru2dmmaHs+DghlnhbrzVGBu06pLsuQ8DjhFpqrE8YAVM2NJjyhmGKPrJOgL2bAyOxEAeKWtRYIj
/7rnjYh12qEZbj9yIfEt1v5ZBaYjb5o+JJoFTjfQ2hbszbWy5U+SLLzox299/SycPibSn1YNn4wN
O3NavoH+amr+R68+Y6uaQhiDeeA6FxzhLwMcMQ/KLK6oPumNGCcRZiDvHKje37i/xdZaRCfhY7mj
+JhBuoKnjA9iIieBK9/0ujsoRM9QQFQRX6yAt90TuQY+KyPxtveEqC+BMQ0nz5jsLq8CjM53nIVG
VcfTspO5QWyez1EWsBkwkcaJhr9akxv6L40fl8iSyCykE1jr3ubigadpXVKvpOdkfOCBppyadNXg
I0FhCzmxBO56E1RPkdxTTeRxCcgPfG8PbvVxrhy76UTJYoqU1KeaH3/0LQ8eb+c/wTxTEk0v4Wzw
ZlIr0Yv7Rl/DDS32yqVR8xE4bRO8CyS+MmEhOFA6SGuwn3IpmO0T+NAO+LgTqcSE57fo2BjlbE+E
73KfllSGi3DCsf0/PSKxCi0nJblgZHByLpNdTxSJZuJ6ykEpb6ygiFQQoQGyY8aLGfhXQ0znYtSR
IrFS4lk23FVTy969OMd5SSrc7XWpHFm4OqijBxtHZ8314z5e+WDzuOOLWpza8HgZuugEbRElh/5I
eh6XW7A3857GXQxaFo1+PlkN5KUm4cYxaMa+fvhj8BDrAwidlkKNnprrAx9KwSIMcDHpE37zUtdR
k2ycUpO3CE6i85RPQXSweItatWCKaJcydydd3p8HKBGV8zeCx/0BEUD8KVvFz2c9EmC+53O/8c3g
ok4XCm+wmQbQb/H+hHsyHyYuJZ2a/h44L6wE+k2fdinwhiptINSRbZLX0QXvGxH8lHc1eRKvqb+u
AeBdSHtdarVB9dXp5IvyJO+gC0prcW3y33fnW1XTizcY2MaTT8U8rIp8s2Dn1XEvQLfUrfA8++XK
5+e1Czfuv8n1yBmOuYkHJBSTPiQey1TxQwyYNpeW3dokNtNO+Yi1WDpWinotmOcuvzqgsv0j0noS
myEETul7yYgUeyjDV1+2fjFnzeRYzvPnPmNGlSX89jTJ1kLjtCshGVadpK5BwUd9Hxgea0INQq1g
v4R8COng4YFgQq7aEm1dAjxQvWIbbGg6JTGsrZQSDCEWzWUMbaov/xWKEvKyOgOOQniXx4YUY95M
OhlGbZS1nZCa3g/bUBzTfZIxTJOgsEhzSGdx/dxbMkocBDpREpVNwIw+Ey1xlwjTnMJVp+FURl5b
QxyBFt6wiyOp3uo2eLLt9OyMOOZYVgNmOUsG6+hN/U4C+11UIUhmFPmaa3xP9YcLmu7MSRbhsKC7
bPEAeWQbUA6TH89lnaAlFr0npeRlYR2KfBQ7elUoMwVRGiiUpcv3C5pu1/bsNpRD/pKYW4HVcxFZ
bbOF5ia9EIJZENIT3OWWMW5iURNMwXdYZOIEInXoDGBmjodzTtoC0dQchRlruegAPjf0Ei97EsWJ
WRQrnMbx4/ioechRz1qa7/Lut6P4AYEiLZtFssGccdiQUwBxp5i4+2k+LrFeJPuh+l8ZMC4qR89l
i0s6SFwou5BijVWAnZMvXTiT2YKY43EekhxpyS/nkx5roD0jKCrdIEzDI0TgXdLpbBryeLbqmtyF
lgBEEO2+xe0HN0HHU6MtY9Y4lzDn55kEU5vBgOTTzK+5vvSyhin6JoQeVDGuonqrZydAArlqFXNg
GZdS5gBJAkyW1U9NKv9/DDTSgXyRyMtZCZ0Br2ZJfy04jBTHccV/KGXJj3OHCPlCeE88mVnp5I59
RkRinrpYB0um+Rcr7ssO6mQpyhBiNz+Bbk9iNHxCm82keR8i50DeX33OzKN3Au5FJwEMYILc+eLK
9U2RcddUoDHPq8IhEfyrqWahzojpZ8lxq7fW98N2T+a44d1W3YqHvPYkGGID7nRNdoN4VcIhqhY3
r5Hj6ZSkg0f7NWPPFzlWxCp8J9ZT9Ag/zwI5sErjbL3GCICQmGIBdJwWr/m+9EQKSpH6sw4+KWP9
ZPqwUfOxRoGLtWxXsi/oTzQzU6p1i+JDSOjBCDnT1G4TXBorGei+1aiLu0u+R1cPUf8=
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
