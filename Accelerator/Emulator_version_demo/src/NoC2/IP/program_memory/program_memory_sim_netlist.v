// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Aug 26 15:27:54 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top program_memory -prefix
//               program_memory_ program_memory_sim_netlist.v
// Design      : program_memory
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcvu9p-flga2104-2L-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "program_memory,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module program_memory
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [27:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [27:0]douta;

  wire [8:0]addra;
  wire clka;
  wire [27:0]dina;
  wire [27:0]douta;
  wire ena;
  wire [0:0]wea;
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
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [27:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.910628 mW" *) 
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
  (* C_INIT_FILE = "program_memory.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
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
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "28" *) 
  (* C_WRITE_WIDTH_B = "28" *) 
  (* C_XDEVICEFAMILY = "virtexuplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  program_memory_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[27:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
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
        .wea(wea),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21328)
`pragma protect data_block
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
OCQuHbE0P5INGA==
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
