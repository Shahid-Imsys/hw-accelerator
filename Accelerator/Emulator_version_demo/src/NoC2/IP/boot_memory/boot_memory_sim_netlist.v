// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Tue Oct  4 16:41:49 2022
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
