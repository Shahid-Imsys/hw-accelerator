// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Fri Aug 26 15:27:56 2022
// Host        : AliceSim running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/markar/checkouts/ImSys/testMaster/Accelerator/Emulator_version_demo/src/NoC2/IP/program_memory/program_memory_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21600)
`pragma protect data_block
ptYaPeUF3jFZKpKlypq3SACyzwRbOHdbr6MrmCNSGz8jv35ztD1NIAdQSOm1QP9LmPKPdfI9olkW
0ajmewr5rd9dixm7Kb4Zi0diaWdlb3Zfq8MZzVo+9l7lpen4gK5Z9A91xGvb/vsNS2LEjFGcKgvQ
Zqf0NoFEz63HGXt91iGxDe5Ob+EXaD6awjMkCVE120BZ6tPucnPewFkSqUdcYw5X76LJa7Hg0kNG
4hZSZgHnYIw+q6SeKoKgZpdWlzgngylkq2kb+I5uB2d1Z2zqqpm3UL97Mt2Rm36yVz/ccchIMhUz
sDJY8uXxkwycJDSsT9xg/SIcBalEqxyLZ8SGzE4GoJw3Inaz/XqoLm5qeD5mjLU/Y45RsrnYnOPX
cHC2a8YvuRPQPU3W9TLP1NyGNOkkbGS7spCDbTD7I37hXj0ZZxnp2Vlkt/bX7ydxyBPgkFmgW/Fj
95skR0vsQVOV4VctCDtGquaE8OWN9tfNecCyJyHL7sFyoAiEXRnPpA5yoSEP7Le01T+WApRAvAgw
O/DGwS0tTuoNV8y6smGSXEYCmUyK2h9VgB2dRSVNXQIegid18xOwb/t2HAcuVdyNuCRoHotqhF2k
5pokjNdzix5MNnIhjahlS1dy9R/eW3TBI7igTb1+AFwhZIdVV1o/TOR3vo66aoBBr/uPoM2KxnsB
SVJtadQiW0I534jz+bZcK6l6iy+ccgxVsUTpM2JOZvj+Yq0+qa3YRUqk8rQidjHCRR1vD61lGggz
liZblsgA2IZEDV+zRazOwr1lRKrPP8B/PLaNp+LmZa5qCGSrxgHoMyPAU4IzcfYCQS+0yjYFg08n
Ue1jZ5iFyxl9m8bS+VMdPMK5Mh0eADSPu8T85Svp3bFLB/ZJHJCck3TWpnJia140E8ZaKh+hJxSQ
JtnbYsioSYM72gQ+q5WNSYNHV9PDnX9D7y9cQsu9NIlKf29yslMTrCTz5nKy9WxsrNPuCdCv1jG4
uHvzpPPAmG2XDMqgatQA+MeMtanyLafbmjhvNVvWkerpO5S0TevDIP43MHTU6VAjfMkn99GTFgAh
VoEeGDm4Q4FMA46MkaZ4TK4whGSozKTkOTRuUohg8ggRmtixVfzLzlx4ZcZmiRDzrVfvi9NIlDqY
ZjOrbNfKil1I3AlUZ4qZVllriQ5m02TRZcTUTVs2G4xfshsGwNe5ucZN0ZOwjIScGIiHghU6sipS
a9C0XCGCSUEk9Eq70PanCFAqn/s7U0CzIULd8u82FfUQU2yDmDlAd1JA/fJZCo4LJDBIWtv6LsiC
rBK7dmHNDhn0mt0k8F1Eo1yEwNgufxKl3rXS5BUhr1ptwqvjha3rhoKlmssr2JPZpsT6Jcl+z1uI
DpR32rN+uupBItVdOdzXi6KfdFpr8jwLrcpawI1dcBW1Ps9g4Kb/ERjMkLIvANzHio3zwjOt7iSh
FdrGXY0Vrju9aPl5ySC0VcJSkauLR4x+7rEzKTWHBngexVJhWZOLvW2jjiTVmgGGRq9H92cmlRex
moWPfL+NN0zketZOeCCfstj6tYyH63LA6ZPdzCF4LZmuoRZapHz4BnOpFs+8A4xrcEu3UJw64Eg1
R4IhWYZIng7uAz8E8UeUTKYQRYuRsX4I7KBNR9AXZKhT0nG5fy0qqtyjpI9H2cnGaiSGUmvvZhLa
u4eQAqSjHADsLlmTnLrFyWu54mYVduKOOiCPzoWoKVQpX1KCN5VGKu7Cne6n+Wyu+nlLoLxyDUD9
SZXrsHa0Dv2MMlRriEomWPesPuouScVsrGkvExhKNMdrwCeULGHjdQXEalMX95vrkSHC+5dtMVO+
9p0R3llE50JykOwlfS+p9uDIV2zEf1R6baNUOvrEW65P2GfljQiGvXHD1QZXva3bxU4jUQormmPR
8XJEDSMWwiAS/MgtKWNSFkWD2BiM4kePceNiBeGDknddKkHZu8Ni/1wYiukoJDkHg4bf2x8sjQzs
pjsk9ySMjATRLhQUWQZYPlD7NqvF/T6tgs9YV2qmNd/duGAWzOHbyOEqWWL+rhvqlXiS6UGb7QM7
Yf0eJMuNB3sdRzncmJGTtWBRaSnMZnnK8w+jIxMAOKmHXIOv7zeRz/xafxZ0LkD6o3vd/Y1SggbZ
rQHOIooYZaJcjHoOzXSiGyDS18LEDHjzSwRXgS09x2gb37qtyLLfKNlqOWQdtRc598hs9sQo7iuS
2I1jE+fyQU8dHFETjHH/zIvG3l3u/AjpyC/uRxKeOOltinwvY4o5QegxB/DbbruG+lMbeZ9hVBlh
eM5fG0KDWv9uIYqqFFAZyn+7oqjcpuXAYRh5mk0OXeeZQ5BPac923suhEwHw7IWIESm4RUJumnAT
/f2yc7s9OJxJVJACEDjcGJNPodS2HqdoTffLfWFa62ONhQAUgl9oWw/qW+q0pW5nFKOex2TJQ54p
yfqxMwCIIyWthUdWOWVY5yBR5yCzD3NuluHyK6iwlbGuODuLYHrJZXluCIsAv3VA7BTb74SWBFnW
zW2WXzTZaBi3Oz2CJl2v2HpbUc7F5UaayjQUsr3MXFcMxjxHBOde/9j061BTOBA+0Z4ub0r2VFck
SEULBx1kVGXD8Q3pPAH1tHxqdFNkpw2bFHc3eW4A360zoNSqMQXNq4ri7QMJarr+XETTJ9QE1LAU
jS835n+NPfuuqaLq/fmunhuCtABcguz7M/McZjl/ubqYay6cwiUgJ7iGTiS2safMR0iH3xFsrR0Y
94FF/XFCciGF6mnkw8EH6Q2Mu7XB6hARJEXLsz7uWcg0d55NHHycyoCVXGsSak6ZF7d56130g2GS
qKR/BtqOuU92STIwtcON5vL5ellJojRG4fA9FulN2YO2HAX7buryTdKirbqKr9SB330PMw9oRz7s
YvKhpd3rMq//wRL6GDFOWfRt9KKcHRdezdi+cs203Qq0GYVpmSjzObCV2v53WwgaKKpeUBBzaGHB
UT50+i+4im5HKOPEy+RbIrKecYgicOJHbnAPN6sJV9ttD9msrtGPyeLli6mzVfgKgoaDf37Gc007
J6OnVGP5bgDbyOfWqVMcNE9dGQKfpor5PaInQ44zW300bfeuoSDbiaOdPieJyJ7a2US775u32F2F
G0QzuZRKWD4WxA54Vw9U6rKjoqdxGC9TsvQ4AiEgwiVo2AjzL3fImIF8x9PJsZZZ6yhyqXCHSYcU
5vky0gFJqt6vG78xotVaZKp7pcBMbgdTOdm/uW6vjv0EclnD6jdVzvxTxpza4k8RzT+8U6zYQCxq
vPKFwkI96u/dkOeK2Th5bUNjn6EHMlD3GRyEi1yDHBU93wJJGCUIwjLlzTo5c2mLz99j44yRmLj4
nZwqXTgaYCqvjqmEywPtL11wL7ugxqkPeqOp7yvm9fPjtJYxYpw6SnYYpqaq1rd6GDB4VQDXx5gP
EJYlyuvbHs+ZGxYimIqYSxhP3HWOBeHKvtRDRgnapkzOmlt+ZI9ucTgubSj9ClB5h+zeAQKNzn9n
T330aEkUTJ1/teUDnbEuMhzOfExqsOA2BDAl773wWYv/idvGuK3CtpshiOzxR5cbKh1BtYhACx2s
I6t15zZ5KXJV6UCKf0cAVRRIQIOeAYoYWTSx5YsMl9bKF9EjP/laYuNOqq/ahWW2M2yrNPg3JE0E
viKhnIwLi2TR3J5hA556hCfgNJ7OjVKEQprd7fC0EQfl5DjDQ5bBvVjAOof4uOvAkI2kwM9M0WGR
IeL9sAW/UosI2X6U1q8GSI33aw2WxHfWgqS09ZBlLPLtyzFtKkReVk9vtLhDOO7v/CTzmSjxhy/C
E0bxZsp7tRzxE78gnsmx+/ixJ6+7qHJMT6xdZb9ZLlzEKOe6by3ak7Pn+6JVWdJ2GJiYsu5DCGK/
0XEmtyI7dsMSAAi7MbJd/KbTJIWp0ztjr8MXLMtZbSvfmWN8BJM3u75ECNOJA00CB6+lfXkYBxee
UCv6TGmZlhCWsQ7JppqoQMSebfh+gsy2ULxUTBCogIMo/cdeLdAiLcsJ/6wPdgMNmvICeKDVztei
mmDh9L75AubBlHgec4Jrwigz/t6H8tQYCUR5qyfXpEFrNZNW8UkW3EGgp1vy2IWUdXxwwRkaqarS
6jjwMd6tf3iCjGwrGO0cKg+/QMTleoxqAoU/UOYbLb/xzW+hLoyIMzEuT3S07QvSI/ugRgWHsW4s
rIyjFe+R5GkixW2DoDOZL68JrEQe7AECr6rx3A5PCOIDolzpLiyeQL8bvuO9lCUgWGV5ufmMe+KL
xQTJjJtat4SJ1DkHLoYK1NC4SQwUZcuZy90I0SvGEPHHFsTEX34eCPwNxEaDObMEBEklE+fvNgmK
JJy0fgAS6/0QgDX4/XizBxHIHOXJlXsNa50fA5Kz5N9rmI0B+tZwJ7Y9CgFWudUkYCde9BLs5+EQ
ib49pPoSOCKqF+zoTfcAtP2M7ahG++m8tz1LfyHROxuXRnMH0XF01mRXJYsY+C35cf0kN8+3RgaV
qRbf/go+4OHer3emyUvYr1qgr3VKKxmsx/uokvw/jnbtRf5eu5hKhr1ypNpXjGrDRYnHfHx8Voir
v0zjRfFsKY1TNqwMiikz86nFoSuCc+7Ajrpp+KJcJuwfC2wZ52JEdB3u8djJ8ScoVuUmd9Zw9aF6
yQZH3bqeLXaCuMSDdGs+gIv6ayfFi1nZV9b35zx+T/qlLE9rgVi7V1Iaz97n3e2odDDaLkmTbOZO
Kn5rzo6j7HzHuZyVEkWjv+e6ArvKUcWOnssRtcwTCbkyTqpcA0GZTWqjrwGUOzEYPP3pUClmYsm/
Uaj9fvaIrRRRhXLzzjLYrjpFWpN2R2NvPDTWx22r2srE3vMIY99txoAMzpYK7xVjtZJeF8HTsZl2
D7/XNmJiFckw0G6hNDkbGtlsRRPCqccIVZPISuDkv2NjxvlvjAB/geP2kS3e1Bh0TqhLyr+IimRk
/xPupmcBOS3lWWqcrplSH/nrJvAq10QUXV3ufb7ozYjPuL+uGa87QkUwKQzqz6MhLlDfqRnp3grC
WiiN8lxPfLnOx+WlVyXU3GZqzobP68IXC7fNxed/wK8agPAYMeHcngxWqHRKySQ1qMEtPkHZ4Sap
3bBKMJtt/QPmVY/pPNYyin3itQmINZVzsKbrwCZVF26rIt0T170II5DpPMGICIOGa+1V+nzJIX7m
1152ZKGH1i0Xf0+lWjBUY2QP1A7tC2WvyZTjhXZu5FaXDXGsmcQTDUFx4D93SlosIRiIDFP7bCJ9
uEf8X8k9auSS0i8s3vCsWkuic/bZBmCthkVIQnhc8OGBoGntOxadY0ak72QlhvQtBwRAVpamE5Ud
kOMh8P3+cd1fGmr6uEmp/ga3+eI8ByQj9vCgEc5EmD2snquvc+F9HJJpC2W+K5oDOk4XNUdNSEBt
JlDwllvdZquXA9Bbmbo1P5RqxBdTzV83WP/BSuxrgzH5RjQV6Kyi2cskbpuAwcv3fK83XqDZvb3l
RnhNgnhAm4FoJFGixwQFoPF+HtEzj0zBr0q/l7j5M/bp62gleTlIpE0/ls1RT7I46Z8oqoGDj2VT
8GKYRZatKa50600zX3Ed245s5pNu90XsgMjQU7nbGFvxBe4BeAvRqHvJe+BfJM0LI6gFewvH6Nbh
mdOF904xLPWjDTvTXV+D82fyfdAmv8ZWm7JoeQP5bbv4Wxtj5gq8YoXEEBjTumx5Mo4fzVn03VY8
kiHA9iWi6ERbZ5XLseP71Q1u5H1lG2tRAujO0Ak5D02kCnxuG1p0cWJKuN0NHms8/LU1OSSljWIL
ChXwZr9HuhoPPPHulXwlXFDBPzDhmip1+7lp28A/pnzxiCycAyIjVdvNI0kjG8Zth7LrVBic+ZJ4
9twLu2M0Q+pOEfw1fDtO09J2UvbmuJR218lJuk91H7HPzn4cr3+xUkvCtYd2VKs0+yBCH7b7suHt
KREzrgJCu+a823w0nrx834RzLCxLLdoiaPOROGvMNm09KoeVmKgvPXcT0bLE6HpvFRvC0Csd6Wp5
wwL6gnnYNF3Aupd3l2vryBx+Ry/QW2I7DkOBkBu2PrvexEWfqjv0Q95RQTg6QYAEYQc5EwKmvnBO
DIq5bgOnSVMnh6I3q1SrtB1dKvln9QU1nWoOhWvlTsroPaM0vR3hSDgMNLHr2CWLUJGfwCom3zMW
Inh0AhqAa17kRQ8y6eKLnvfao5Xjb06jTvkMmWAJUWH7L/RTejcxeWFzmIh6zwoUk1NE0B+GoLbd
5wNegrSjuO15/gEKbM5XAHnGGU5apFMzdCFOzhw77vWkv2pAh7oXa3NyTFIg5fBa3huvDOmgMP/Q
nMBoDABRlQe9ho7PLcjpx4heZJlwr/C1EeJaJlsKpwihK7h5JRjeA+Sv7Je6ZX5Uc6tGiDL+mc5R
MDQpKOkdCwNzlZ3+CAq0PDrcrMBOJtwfcLIqyldFAJKdMAyKJiD8WvcULGu7b00e0bta+tR3hj2c
WER3I4oIAsHVgN10DpCtoRXtXBIGL8nglTXCwqEoX/08oQV1DioLTXXOdLterRAWVZjEBPOs2oE9
DUXI0sOjlCik2FAFAZrUFQidE7UTUBEcUYk5+iKp4IElhfCTnW/gfTYQmWy+KEwWlxFpkEhBg1y2
BbjmnunvXnXRXap2QNAQ7Ki8XA/P0cY3nMT8qriQCXCn223nOHz/6Gi6UCLb10Bc5LdqW5/y9dbv
cvF+vWnHhKhkOYwDxWsx318Ts4mgTGlgHkoYeLndKq6875WfrdwwVTBHkh0lJzMF4Orz8vtkdhds
DcXHFT/c4Cn2HM0zAuL7qj7Ew/oHJ59+L9oTjNed/PHxAWs36p0W4G9mKtbUvvmf/517WjrY04i9
m83wkMRx6HsnJh3BrMEKNUZUi6n2a+wygP5gNJldX3B0mh1xPQ91mlFpZhPOdWpD1cfaIiPdPpuC
wIULo5uUbRufjEXGal4A+5QMjphOslJcyj25GqcaIDU9YRUxQJJ73nbgqBoqcwSPwF3uJCyfD+6O
neI0JzMlwIsLYQ1h0SeibWmSVHdS+Q+mJ9LPk1FMYYUZlUGdnHvAq7G8RiBrO5DjtAovauWlYc2C
vCL1PAI5JCyKzvhSI5/kV1kNtDc3aD7CGOIJUSoo0O415ZiCEuSQ+tBaXSmlvvPNb6UKP7+tyYbr
MlPrbwa3ZWaXwYJAoDPPn5a6RZp2cyw4+VABPsqkoKTIenD3W0howy7NKnziUxkHWBUgzjXm0CWb
HHmGoeK04OUAAR8eh/ehEXcR6F6AHXcYKDvMhisntnAgUmCPRXXgurOzY4l86add87o7u3WJBZ0a
3NZH7PfZU8myUOFKeX8e54JlB97S4gcbcHZhJ4SrwdMQ+GapUBIqnryT6+QmF3PNYkdbHXAnCaLm
IMD6u5To7GRoPGM0P0Sjg4cZlq+oob1pyDX/OPU3zdWBoR/cg46g+hLexqujKHJNYfA3/Nq9LvEm
DJ5Xa7yNFe5LEHdatSFvlffBWyNxU1oVLkqygSxziOxezArBS5q2n4MyWFSugthlChcjq+Mfl/0H
o8DXOkDCiE6yPhUIgU8kK7tXG2k8gApbdv1B7Y/9OOb/DXd2nA/PM1PLSTXP3MeuK01Yw8pgJ+zt
12TF1PYlRNO4id2r+ObLwFthHY/Fn6KSepUSudzaXcnlcX8Za3ulgWu1rA1f3c90VLHBGohEJr13
Dqf+wZXoeSRi9mE7HUlvJCXZmHh/SKPaqxM3b7prX7gsIVh834krC2ht7Iw9RTkee3c1L00hXEhu
mY4wcJpGEa5UtQMoBUpOuddqGRumiLFGzAj1CxGF4zp68gplXimXnW5kMvdw66KKDKK2i37kjw4p
QKsxb/oNDcN1ychS5uxlvEtb93QZFc6Lp6pB5TovFQQ5bnh9cqjd7sL2Vv4XnlRaE79t6kxXK87d
oBXRxWg6/GvVOAfcuqEJh5EoQaJFKPXwOgXXk4ANrfjSjhN1NvKvfKj2rCF+HSEGBB8P++Layi40
oZYbbZ6afYr+J/0LC6C9i3p+7TqfoPS7B55lN2KHARU/F+2I92A710hLk3fwLriCsR8awCqF4l9K
MmpZnxcp0YULNtnQsiOwliluGxz/CeMP6awE9NEY4dRWXD3WIEbNrCB0bOVaop4hasPCIvBA0gVP
/I/tbxSLGH84PuGmoR0kcIh1Oi+9UVZTsEerbF4m3hUM2FwRzjzCIgXxKQ8odZ5hVOhp9IWzzaKW
0ybGSu9rDn7YFiaRpGb3fIPBfoBomD476S9NYdXSMwSXvm58UJ53Rg74JQ0Pcu0DITRsN02kEnhf
x7xKixNbSecVGvkOXwZfV6HpXWK8iJMCNlu3k7D4Ox8og3JjvK40VaIrBI9RicS/g51XmYgG9ZSk
8lerQJ1bqOsu6cyOJPU5TJhWvocCTpdILZx4DSriPgFkGiuQn9RJaYf3pDKpSD0cmXd26+ThTGV9
seC6Qt0yBohE/udaXyEOBNE184uPBuFt2NvKewx4WX+fEZsWF4UhL29KjyszYwHEB8Uh3T6ldDip
1qBHq3hyd7f2VZfaqo0Kp3/cj3iUz98vx7SbLCxd5dCHPzoo0ZjpKkUBIm6fJtqvVT8XkUENQTrF
WNQEWDrhNuBNlcyIyJ9z7NrpJex3Cj/jh5eZmt2IAG7KQHKSluYU0BXXxDUw1D1ufdTfFAh7Ro9Y
GB2SodkpScveq9/ONI6VsYlHu82JFIDYTpwkjbGY18/2sq+uBcMoA3e/thgT1YJgHSRIsTCWekzl
cSRwOxQhKn9r/LB+qxRgtaONZA+cDRXK1xS+3i6BpO0QLCDJc2pWRVMVGqBZmtlsigyaCj3x+oiN
c0XZ5quS/xYMdUS+CIb96T07uPPmgPE0mmkS4LCeu9IYZJsvMTN8M/mR+ehHjeqOqP8gpOqVAFej
6b04WATj3Oanf+x+K1NiaLOMEw84p0EdoEVnQLBawEeUDbl0yFAT098AFO99swi4co0Mr06EcBAn
k/7ugySGX4Q5MgwbSj3Cvqq+cDcvUpy5NSSw1tKt06x4eT1GobblaoRKl1RoFHMOoWJ/W3v7Ip75
EsPS8QpACW2q8ykEuZaduZ+IARXa8ZaeRJmV1l4KmFqQLTqp3kgToo55Jtktj1JtUuNijxyNj+6L
idShWPVdDcG1yV6zG9K9iSO1g16eHSFvYmWYiRmTGwFz/02hL6c+qewAwREnHSJVrpM6MiNGx0PB
yPuBVeH4jQ4NA3B8TTfyWmu7zj7scawS/WPaTM/6gvqTnVjaR6xB/7NOlT6bTegb+OoYN29y6xAX
RgSC6dStsLnmK+yMhzyM9BZOUhrkwBbRzxkkjZTlxy7NH7wIbtByGdqMOyJIXuEcShplyZlMVG+B
rvrcYma1EJnKNi2yCKZoc1CTH6gt7TEotq9GohepqcNl+3uv6GzQOxcO7QXYKQRZtxCjd/a0Nq1f
wGaJxOXeClvu+mYfLlofzPoDxeSe3iYo8AALlhm19u7QzhsZE3tUA111UdCyoBU7jNt261T2Qqvm
ZgIvQUrTfHlAIL4Vb0qQbAcpAZvBlWPiKNiqaTwxCa2R7g06i1+TlJgoRqGBubdfTeAOs0Sle+/3
0v5fM/73D3mpVLltpyue7i6Ng2DhSbKX5NLaW7EFLlunVvS2UGZzSaOX+PWvlV/TcLRP4uS1xij3
g45OwidANN3bLUKnSplDEeyyIUJ0T9ToNqCFw/X9sqsx0hbNpqWj1GG2sqxI/NnoKOkGfYAFmbHC
rRiTVJZT5VHi/3xOfBGRcAfldlwYmHoD1S0TTzPxlF4pnM8l7s+KcHPn4nKXh1Jq4FthunhdPiBV
85/qyAYZg2n9l2chfxMTnFe/GNd1Q1LBDxWSdyf5u70JhGJUX1/SMw+ddEXvHcnGUL1Msu6sUHlM
snWhdUdpBPNEwtFwcjh14CeiZ9EnNObhigMaltGFYjFUWHz4WGMNJRyZO/nD0hQYdypMHVY1Tgjo
UikrkYDjjrvrBJYjocXJK/cGB/QkKjXmi8uGGGGzDjCvqMZrWBaylqLqX7XmUTYYKZzffhiXXOJz
2RI5WgbugTczB4QgwjAAHZ9SDHMii5frJeLy91jENTCEmZe5EJL+LS8tXpD2tYyMDhhxmeQtk8hI
2c4HBrTqiDbyuJuV8MUwyJKfDRvCsfaRY+SV1x7YlQTqJR6GTdR9SjMYV3qrk3+sj5Qi6m/N/hpR
WP/0rOtdvPY+fZVt+ECLRKgcqBJkZAl+logQal0tkNq9DufCHPGFPev9yOI9eBZgzsVPiFXQHLfQ
T9A3GogsYM7OUoLL367G/4Mj/GUmZQBspPoVR1gMbIpauDm5lOhFyNN5aGNn+jq6rpkeEGG6gByM
gi2EOUqY9ryXQuvlWawKirbFSICU6MLmymhY7rEqYzPecSafHdX0eTyI6i2H53RnPbYy6CP4F7Ue
sbulLDqw7o7XXXCyB64arw+GgWYx7QRoh6lULJ+XtSnohOASqYQ474gW1eeDs5LWK3IqcI6rPxc8
NlezWuK2paYoAZioMTc4nErtacB8UDKFOfD7mFiJ5tha8Km6AAk+1X7/CD3acJVd5Fw9oOyKRRAh
DbwoQc08epQPMTFfEXVrZaKhRgg3pAg6VWoNUiSINELLW29lypqY3DRLy3xNiDi1DtyrhX0kSFQM
AmtZ/rPtPqbQ7K8o1ZWNrOldnoTqFxu+O0ErcD2Yvwnojnby9DQYpkPpSuojIosoWjXikPijY7cc
DsCsfAjNv57GcaGLzs3qS8yyrKGPsc4EMyzPB5KXktN1ySUzam0FXXPioQSZHSjAk6H0Wn1Dre92
DbDaOR3MQQnqsAj8GTteZH31OOoIDInO9ioU7IK2DWDHTM5Soukbvb17w1VFysO6TuFhlyMtgjxT
COl4nNbi1iP7kPNANynbJCkDVejVVFC/wfc65qI/mKzHizp6SuWZ20XHGyguIlCInIXR/35Al11B
PHt1PXB5uqCwUvo80CA7b5gQCz024dJF+oj08/w5qTZnutkxedYTKW9z1ry+FFsMBHF/HKiuBv47
VpsyyyuoS5aCd1EC7TCVuIotiFu2tNwE+Fk0Xkd3Z5Vf0klJfiC54mstXaZAOT0rwBrhbP5TYrrY
Z4xyDBe1EXRVeZqhCraSkQPGwwqART7RjH/OjuGRGojsy6FfI4gz+xMcsSi6fOTPG+LPJRtluahM
ZrcnUdKYSUPNHmD9vDi6y/xgqPkSDTVi/A9vtyzffHO5wmRjsytjVtbjXLhd1Bai2LgPccVGRovg
Cm8FUQ21PpdMCaI6ovzZrXDXVCmNU//D0y2UldTGCb1nlYtKeyWQVIJkoROsWlvRJIs3TaaleF4a
h3jhU1RAwkO3jfoZeW4iSfpFiJR2h1xJUSnYOvM0NP0jpMgHUOGtQ0CunXL/T+74/mswLKgu18zl
e404908Ae9t5mGFNZSxLivXgYPBfhdF1QfvSlDBgDg/pYFKwTpSJjKPGhPv7kux2RwVxELE77ory
idDHSLXn+VtLy0CYkGWna9mVpN4SVyce3LVqNiNsaZ0kYsWUJmbKJdDLIfyJ8Tx3glKNIdHM+XRF
k3lNPr1bJ4lgd9aWKOIWvsowK1o9kIUOWtbMzPLb5Ct6yFASUAnUyNMFPWluEVzIpEd2strTe43I
+wo0Eb+CJ9CBhyGk3DuDx9bn4y27D5NJBW/2u8TiEOmP7piQEzcF5w520Op22XinnfwKR5b23izH
79V9flboaVqDIPmqhipdPS9aK6mmeqPq2Qc9b+Ar7175Z2gWh49QccgUqTy49c0nmg01dxaImYf6
S6b1TFz4KFbSykcTqO/T26ta8Qe0wJDGg29bm99DwyziLQwHu3MuBOOe2Sl8Qd2zcVCQqdBYkmn/
WD46mXofXLpyPhIGdN4P0avsiMjt/KGfqKtgjSGTHy5m9+oRuRPnuGgakamXWqmo7/x1cDUjkv4b
N82wnKyoSabSTBqOvWoyGu0HUgn8Exzrt6nfLgg8iufwMkovibJ8c0P3MRGYHbTu72/H7+QTo0GQ
mJR671PXS5unJ9w6J4IqhhBA6cPvucwgbF04ys+e3HZLhboCc0ozD9I4CvC+Hg87VuDLTiFvPy5x
zechkZaUD4SjmgSTaSnxnwqwkTkShEu4B5iqe2LJqJOouHV6Yxhs/BCDNp2y6fyf1ceRHRvxlEtJ
8WZfa8hhzcDWET1UApA+sPaXSjvDVTZyVPeMmSJWZja4TvnoOL+axf7VtzXBP/fBoFAepZs8rL5O
vjEM3tO1FQaMg6aemKQJRPOPcr4go8Th/phgzh/ma+4b/KyfXli7QjjlK9iXcqByzK0jXSf+ab+q
m6gAGvNgJTL0qt86vIY6OAj4VNvG+z82CNlzv7RPL3Fn6BbWbwftjk/wxYf4tj6GW7uC94Riy4y5
F6W2Tos8XhPuvPQsUGDqj1UDBirhSEsZmmIYdHKeWwFQ0ecspTZ4lnhvyynwpNMTQWTV/oj81xyK
PAHl0iPGJuX2DJ8Vjs1hUWBbM1deARkKRdq9Ojkp7a2GOFfqApLqYrN/tw65qmZKE0laFZXXUX2V
W5WIJhcBLFnAxQsNAO3ttaatBNgW4Eu0aj1D/b/EgYlpfi9gIGUOwQviuFCMADKoffakxenarprg
Hqi0DHlAYLZY83lkDJ8l8hsARowRy10HLaux/K02DQkx6Ul7aYAxjC4kgyvZOCsJ8Pw7Xlp6hvtu
tEukqLiytgdOW2oAPM1QT1O7hBaPJycwZbulWPWm6CZbVh7wMTccrLoeFdIv+s/QCbx1Ppw63qtv
tFl7jDaatdlJGJXyd3q5bGABNArorRLPSNexm75NVOSoh7z49Wbc/1QQnMUP3n0gK5KVYXjo6mrP
ZqWPP/ZNnblREpTn9nxi0RuyCsyaVTDTUOGwEWnufir2qh1VgoTSWDEfaXGkQwVEcqpUkE41U+NU
gYC8TOzGBoMdX7RoKp+JSanw0l5pB14CqhQc+kiEwrk30S3+vYEav5GGoQxY4crhJE7KjXyxRjeL
Z789SogxxIWZhugOAAA/N3LPAhGKejq5A8eJgDm5CMdjpfPQHD6ZjPbjhCxqQKRwlIclVgs270fl
n8Tbwy6+Ag2TyKyMfsEJmLApSX+P6xT10COJBInqcAznES4Kh9joouVHdl22T9J2kWTcrQ3Rwwyj
4AXCBVMV8rxyblzdT7hdkurJqQxhbvf33QqXOO4G0Nh9Ui7RIfMf1Sm++EofDTHF3bF2Nn0VqO9V
8efjUFuLI57VEAvQRup8KSgvleEamed2V6BNcwoevBBEihXGFIIbn+2qXuqtJFv5T2N1FLuaprcX
4ROuvR5kiTfqGHUUYcqBDtaWW5iNccN3hJ2Q6tE/7gQlD9VE7h+k3wAcLZ42hjXu5I7C5PI9WyVB
GhdI6y8QE7OIB/orY59+o/tUc8yZCztOkOj48z+1T0w4SM4O5FYAcP1Ygbbx5HlHJNG48xTpN1xs
aor2pckSL7/VcWQPDNVnz7Jbztm0PwvzYTbI7QmJWRRt1emzTISsM96gMZDIVA/HfLOkvMeyMMAi
HvH1mpogg4aP2Q6Mx2HSEt8zbltc8dQuVGZpXRgHJf5EEOSMFmGig9azfeGEqRRptFHjD18pQem3
Eh2iAYEne2VrPf1ZKMiSr790ZgLhFcg2ixIukANA/PdIvFTh0PQCSXF4TRIf6+r/kr8h39GGfCHx
byeLFwSUHMuq3MJvQU0LVtFX/peUyTRBdICBCtLdwokCW26+WRM3u3YVOl/2QQ6CU1uKC0AizWXs
WJM6Qn+h99ThLML1rovEzvnp/qa5F8SAVl0YYjcVdaBnuTty+Rl0v2g6CUAMr8PN7M9T0nvWLH5B
ifmxsufvZIPiUO9QSVeXgs2N2RhMh3kFXYsFAagjwsefTNSkp8DuYPSx+/K03eDI6dYzhD74Csr2
iuIwyHagoalXZnV5X4fvrf9ENQ30vWXqsmKpi4kDHqFOeaRL0LvhJolgznDltKEYgv2USzRu39vO
FiIWhgSqXhXWw/XFEA32Y7UbeCVJyyzRnCFHX3IM2/fbrMOTn+EpJSvimZCIsC3cKhxpZYwPlTg7
u/IOJO4beOgQ52Butkd8f+nIs9HQC683G3UMdNF6K+CWLgseWxmS9MXa9OccCMrJ62pQ5P8dGFYu
PXhFXPK6rEBrppxuq/GTydl2OOVHg5ri5QqacceOysg4uh4h/MjZuNMEecXJD6Yd5wn5kYb7MRbd
xxMW4m8t7oaIt76csDLrY2NmtVgIZv7LAmDHbIgUarmWjCjTxNRbbY7s4LyYiFCjqe4TuXjinqvI
kacn3MLGxZFkmj9w24Rypu2JC238CHa9wZwwc3MLAgsLR4vVLFWt98o1rLhBVSnbVzIlhIBtbxxS
bAJIzZ3srR+3mb7TunxayQs7LDQSMdRi4LinbJx+Dt5Gom7Fj9QTyUdWRN5nWqN+yQCGuVzZY/hf
Ii+HCZbX65tk7IRzep4GERmisOyQFdtInKDN61Utwkrbv7SFA18Mq+vDX+IDr1IOsyT89XKlPDiE
OqRoxG+3pdXo7HML2VyT/PaX7fabFFP1GuvLeOIFiqb87UzeLf+0cExyW+wNSV3x8SiUHiauRxqS
AXReeT0c6jTqU+E3oWxGMUfoXJZxzTIHS0DhP6jYC1hxpqCKcymGUwEfXCQv9G9W2cOOFs2GLIZt
BzfLFWZjiMet37RnzLeom9C/itn50O3eaxNq4+0M2DYDKnR7Il6qIykJvsaSynwzFP/UIDqvl4N9
+IJpp0c08lroZxh+s+bfMFBcUt4j/uxhEtGpqpl7MagmmUH+0yemiC4SbdRlF9I4bcHACvFTOQ4n
28YZn8Tp5kYj2o4boxSvDf0JOgnDmuKSZv+SuCDWqG0Uzos4NTuLFP6ByJJPljOVnfy2VB/OYHDh
2Vbew470uVZdugQitpVt54BHud9uSx3I8B+KYWgZHQWsqiVLa/mYVLIRoy6eDecV5Ze/0XnpAKJs
m35YuEsj/KSfxaiQ6/kXvBxtSlH/APq69nDNbyNLXX54ol4ud266Rs7l/NtcfttSiCJO4yycb2uJ
uYMlbbUeaDlPaIRQLu8L3JXEjBMKoW2KWBC22ScPGAmY6C7aLTFGXdAuCTomsyXT9piYYmbnPPXt
+TvHfcT0O6b3ijlBiOXQZOv8GVEeQRoeZxf7xni15JWljBxFNb/kyKaW/2qxgbSfLK9kL3pLLyJz
k359S+fhl1vuqemIO4upooSiwvHHh8TnXrIdQdwLVGUXr2MzDvqtiIErmeg6+yErpSfagV/d0fe9
dL2QvPfhH67krMWy7Zslej9OMmjcaCpcm5WT0c7fVGMyBQ7vZQqaFl9t8VcmHKLvueFKHvjTgaP8
qGqjmFvQzqaPSJtYCXE/3e8ophyfhRttiqSzk0yXTuZuqjbwitAZU94m+wK53UbymPACxjBenoIH
lX2CR1d91daD7QjDG/R8G4IbD4UoZWHYTJ3bQ4yQH10ITYhqkdzCxtVA5VrMn3cwzKjI2pyCXWM5
itc9YcEDDq2o4d55j1S2gozT2VgzD94DNwSS9A0vpt6CVZ98gCvZ/2rOENpPaQzKYYLmdFP3wq7G
o23SHuLSyvTSBGKpc4lEk9VOVbxvucIeE74w0/TJJf9XxcC5RRcjXXzKfVEBi5hUZUVy88R0dfOc
eB5qM67a9bUGT5UMIkRCHprOI72ub6rRn9ojGCyIDlb54/Ru6nZZ9rAGVVHmlhJI16oB8aMOYIOb
pWjMdttb/5zm/T/Jhvn9Nydjy04ZNCmDEaXfaWHpCeunCjLBgek0VbNqrAQlN/7isfV14k1breHG
p7Z5MKl0qoIeMmmMMOucDcY/srAiX3F2bvq5Lz/khOthoOORf6L1fIolkWaY/OIAtC5fMArxCu2r
h0kbZBAv6hHjorYNJvE5bQlFps+sE4QoJCzTHztUSGFeIFy49G2iSlKxAgGrezF0gqJmsedY0yGj
71ccr7DtD1uRBBCW5ZqSEW/RPIJiAVJOjDvg6vknQXykasiJhxRDpl6By1M2gDlOfP7b09tmMntE
OOZq5rsVuAw8L8s3tagauTFZV7m0HCV/13RufGHH3gtlOs94i3WbMQi9uetssqI8M18eQi56MQq0
mx/w8ApRuVbigxagomZD5/e16bmf320shCShb1UNfxU1imvaWXJRs6IsJYMIQXmFoHDGdJpOsiBe
+7GQ6hqUTizui6uYnKlyKaYvGgZlPX06Mxe+kofOEE7kE3E15r2nM2YVpCWANa5cRDUWUKjXDzu9
OAzN6lC7b3iEf9x5J7XHaE7Vog02cO/ZRhcS/cuIh2o+9DMrtnJxp6GuCgFuZuLSvTT7esSOG3Jy
XCYl2XUagg+2L8M2sO8Sk5utGn17nW6TnbF4wtmY9D3k0ph55axv0y3G4d0eJIDinL+hoaRYWulC
xR3PCl334M3cZj+FsRx5yY7JbPquUx1pC9elPozk/U6FWqYi6NtmPcfjatEouA+EeEbxCWm+99TC
LOUr3a0dIfRqRj9AnyaFVosSLuFjSWHv0ZBGeJF6RTXcARtcStwRGlU+r430yFxnFL1U0qZLMmvV
qswt2LMGQHcGtpeyZ8VJ64iTpPtBHoU3aunnX5oWQxwT6D6xgh1GQz1ybS3wJjot/B+k+VWoJAPi
cJZ+OakJdwejdLm3pMTNG4bd4TNJKAFWJfOIwiV9ycNiab1hJ8MooHirgBh1x2JWywU+GPmlHTYI
6Ek5YKXTQzs3vhpZm4gFZVzg7AcNY1+fBlp2wQDBTsFeWAV/8CO6EAznhAGScXwf4BwMjmcw8zSy
xF/0ClXzayZlyWdzxjkGb/2PQnLKBWW/KHOeARSbnwUB5MjvG+6/PxxF/oFpeeikj4KqQge4i5VK
eesY8lJt+/X9k9hLMGd/4/R9zMgtx3hp556CkOMDpeObybU2q9jkOtyGXvGiQeWFxczJz++3e66k
sBrEJD7xtxsTTMHzzSpiTHffyCP/t4dRUT+ZgDLIHhJ2DoAUTdVffZ0wCk/aHmYVU57ibRlvdTsi
evQYKKm82skrdtPGR0vk2nkfB4LVg+kN422/+SnIoGx3l6lJdrOYBXxrbNPBuVDJ49Dh8iH7WUlG
68D8L8hIEnZT+1dk3/SAvBzvBSRhB0aB+wkGNX1Cv/4M61V6GZMHC2CYnBX6TvEXvoDzybpQ0MDE
S0hATAu7qs0xTVrFuvMiekXrOOmdiTlwRNlmstP2cnSARyg0M8pum6H0il1Y6fxK9bdubWpO/aO1
SYDPsKqA28C/k48AQlT8xZ3mTFTK9Ft+lRg5HqqT5dFEU4dRH9G8JRnjSXcl2ZRDfhQqeJQMyxQi
8S80Ipg5EcjBDMZY1iMWQD0SO6ZwQxkaN20DAiHM5IDq4VeUUzajBbLakVYfbcViWOKsm589Yao8
MN5TafF6wJtPiC0YopG15Ji04aiiwpBC8K/gWJ0eZUZxGzV2dzDPBhBbip4uRYOMZ0GxmtQzhHUc
aMm/Y4dflOaN5DHyLRa0LfVYAaHWoEzoKYDnVARw1+b6S7bGfvsNkgV7JF4inIJoXUKWYzobga7K
QoGiwqKEeeOItGPzYeD/s9pAcAYwcta5ABmzGlHl/4h1zJ6YdSYIa7ymHWiGPRrbhJdIrXeQ9RM8
gBHiQK11BTetYHkeYxpAaaTwBGbFK97niFvSCKnNXriKtJfMXHpagrws8VL3T2K2lRkE1VYcUMZs
gbyo178IQIIpgeghMDxv4foJqjycIhED2eRdqqF0kWU0WY+vqfwSr5scjagq1/+3tpXwo7CoiMqj
GczMS/uxFUiI0GuM7S6fJCxgQDRUUrSQioDVGkC+iIY5gsf2izKARi0GoZzsqePTSfT33n7MvgyN
dkVjwnITfFe7LoM0edQPEg7k8i711vqRyNB4XbGalUl3xZtE9fzu6gku90VE71/dG0UdKbve4mCm
4YZweNa3SRIj6Sbf9FT97FcnV2CyrSpc8bqAPfVVieHya2B0iA2pHYajdJM+4yt0rghXhzP6fmAj
PDBGVFmyMy67aOVkJZfcNd+Oht2n3P7dchXEhJ6Q9er7lt/r/kBeTSTtbrk6aLz4ysqtCLCnPz4a
EGpROECwuzo9GTdM9qn6sv2dIVRnERiP6jVXyp49FgzZ9LKmtbnXLMYO3BbvE2SGyrVNdlH4rAQC
U3App+0p/FdA8C4BygVLTTK8zGkQdnS+Nb0bIrxnTCZNNQ53MMqHNJ/leEegE2FbFWExQLmynUUi
+LGcQaMyCz1rh+8xzziimlJtGgznlqnKjZhcs6LNQPqgC1ufe1ur0QqIaF0O4WcfqL3E67tzwM4h
0jauGajVuI+NRHOVs3kDwTi69itAmsznlUMA7rSyuZ5+KcJdQpzaEpkya/2hM1elK2JOvRcKAJsn
oi6IdsuNsyi3ln/D0vIwZuSbHlKY8CwZRnC6Qxd80qwXumoSYf4MJksSmGxLd9SiRj1E9dqn/FYt
v71yBkHfbfFX+hzlQv3vRDueY3RRS2x5QnNX7U5dGVj/qDKtVmIu8/UUW7ksXroaRFaIiyDy5Ij6
OsSCFLxRxWEEJf7XZvPBuH/8ymHT18N1Pe9ZFxMY/pKnehwonwYrqydHq7OE9Bj1Qz8c2/xLzc7V
wcjnaWWNy2UD78LqIiBtEyMeG1BQ+VuV2cql6SBHjJFPcY6wYM5rrAVnyGoAFuvt4M0szT1PMxiP
J5BLeKmSwlUDCGsmYR5p388HLR0diXtTlcZP54d+uJrYriLiA4DQZuEiNFxlRcJV/iF0uASquglX
6jVPh5duU11NxOO7vK3twQ1qYAuEJ/9ZZDr4Ek6fAX+5eJaXqXob++TxIMihA67hTp2TL9SlAMg0
JcKXC2iKwPCW6Kcmo6QBG0PTTs/LNYcIWQAx4DZrUvbhr4TcL5ceG3FX/K1qvaIh1ihJ1R93aKvB
NO4e2OOmEnTGyt33+cpdro38MFH884BY3ouLleeMbsd9IrywO5FLBb23uFuf8HQme9HKUewh2AjX
tiSUr1Lh38mV65A0C3jVCLwncZlaogf9+Z7imGwnTkffgIZ3jzZy+X+ksbqUca4BCIjuCXp3l0OM
IuJLyBfwbhSlKSxAIFQjQ3Ly+0mfRb8N4IXJaIujCR0SQ+zqszvs/6lA47LzbzdG0JrLFer8Q+O+
LDEwPG28sPuVjdtHOo/be9pPA07CYtcnKtf34VLQCW8hmhtRn95WlEzGhrM6CJWAQaEKcM7aSRdn
I1IMOrZm9dvPqKPVa/0E9ssLe0wh/X8yVf+LNarQ7/pLwJsJrxKlqrH5IwyW3mczoy8T4Zpb4duZ
AA2WhULvMlTENxNGmFgDIZJ+ZsEC22qGDsQX6SdnBgqsoP2vFloXafPJvhU8Iy+zcqF7QgeHSHQR
qVkWM3uNJhT+OFnFhwsQHuNZXbXlV7GKhm7rfamaZdDpVc66XMGp2p1fQ9iP3IHhN33U6VHJQNgG
fVjcArM/TIoqHuB1YBTRgCh0bHjGns7J+jQnKRNmKZnnHjoj21yUzzFtvEW+0CbTGf2wvNQN7yMu
DgqQbjK82dgJ4OCdzSfHlOivzxM9ABv/zavsEWEDv2B9W0IWVEH85Ob1/5eA3C+/YFhWSdT6vKkJ
T476GwsmWVaLlmLY0PXCTFJGwp2z3KbsYPGap1sKhju7yS7hEF54rsqWj3Lb5n5ufQybqh+VqXw3
CWvYodSKukBE6PTqkDMD7e/EiDHCIlGn8Tv6yf2zgQc4LCsAXd/m9H3jZQZdPo6pdytDZv/7hWKR
rFtSCII/jiHlXBIGNpbVzjuZwIidzQn1QXMDawN77l7sh8APz26yieWx65GrjfdbEFsaEdArpYrW
6R8AsMov4i3iVXefsSLvsRh05MkTyOrQSzSAa8b84AXHoDXLzPafTlGXpQujjg/UOaaHPz4k2ipK
v3BBjHZICdaORDVPC9FDsZZWX7P8mibI38tnMLpN1J9JQAMbrCynK53xrP3NPDpxgnp8svZsPZ2u
nJfPSMqITd60clzAdOmTKqryp4MJFHFasf328ycd+9nYDSI/yAugFRJiz4oVdjBkMXrqbdzg31em
7CUb0wbUofXiEA/odohnQda7ddlciZLBjYkbpJIuAjQyQde3m/x/PgOp8216zfVXR+UMj9mH0PHx
b7thk3jSZAWwQLp0OI+o56TkZ6Uk8+SCetHj5Ut9hW4ccTlVkfCoVNIcHl0hEqeKU75M4e56ApVY
+6qLgdSt2y1FNRToXJvVQZz3U1bX+LUyvhhiLYvlKQW3C2RAAUUUFuJu4H0+3FVeWO0KycH+R7ja
6IysPzvrgs6aN+BN5q/O7/Tlb30iEgVNXUU2D2uSMPKO80R7OEnPJL43j38lnheHRHK0cxxhwG/k
FN2p9YkcrdzwLj24RWaxp7/uM+kHc/W1rLj93RAsnpn5DCcaKA+RgXRdz+Hqn1+aTrrGiSOAAiW8
ENtHqYKdLnZMvnjUSiMtXw4Q6D9Kpn8ZlX6ifI/PG7Mgdwzfd05kyoDkpVvMvkj4Lz0DXXoHh/Ev
kBaYGKLFCuWqDCgVNtI8cT5jVC2JkGbXZsWiyAZCmVQN4t8nNbQtbYmWKiqnbUJDVYOHHAbBldeA
Ay1JGi9yI0vdOzd0P1d5vphda8vIS95WR+xFeS+Qv3hsPDmlZ0LREVsU1PiiqMVNBV6UuGfZwEvV
VhDptAMxYBAvcOG5iuRiiuiTBU/HObCf527pyXiPtvja2a8lWkJxFDXCBXJeGCm5NaTohqxJouTM
d5kD/UzAGV03UhFzmpe6YU6jP4CohPBa8IvgPniOwwVseqrrEHTVV5a3/CvFLFH1hgkCturBRTNK
H8QivbcRaTt1/MY088dmnNKL44GdNQI9cRw9xWnS/bgTzNA34IihQIewjFxKWW5UT+6GDzW/pb3Z
OBwno3ZhQjs4CD3qDl6/PbTKMbV/FlVPS957oQIVxGe5RwmBW5Rb5i6DMgC/ycw/SHGkV2j6bcS9
sFdDZts+u5hPCPvAMoMe0zS6fRTOT/goGcpFJLLrCmIV0Y5qGWfui55xUeAeH0ND4cwAKHsoa6O3
z2aT/w7suIuNVYouSErNPayA7Q1UNKvdoA33T6rvYJ9Q4A03KTsNJVmz1G4bAneX744h96U7DB0F
rwI1fFCVRi+CcHJjjvL9+szzs2NxGAFyx5/5HhYUh0JxAyO30Aocgaepi4xZiAf+Oe6dkNqMeTfO
uAjZvTmzvHWNV6XDzHMQLoIN4LqK2qOjSd8xfO7vm2IMBPGC3SpY72JEm6TQJKGXJ6+YCIhLKE6F
EJWqmE4CpW+NmH9FESV44oK3ToKQ1SL787nXd4vZFdWvxNnzGmR+OweFzcNJfhhL4jFU/yKB9e9g
EZhhWUA70w8tFy7dNpfsnsfm+uINTttsoR8EpUNervJof86KlmGECLlYpCIZAiYDCy9Q/4jm5ZyK
Ht8S2kSVcnTjmy9NNzt8iB8WXVJ2VG9oeYS3D6jJ23LK9PYdn4gXhWkE95bHxzxeocsD/qh3CUkJ
zABaxMZr30/H6FWDYTiHFnm18k0mCWsSSpGIGUFHoy88RXAz7dwipoXxO+TaHBBuqavJcDua4CfA
gsvlGCwVxcwzvT5c0VS30eGtz9VlKuFMpiXln21Q+nsMcOrlcB+AbIPCv9l+50zxWW/L/KfJbVaw
sZzm2BZyvW9JWJ34nbclJcJo2hCi97Ub5C2tYSI1RPd+CTnCfOvf5aJxZBfdB1XIZcsUXqrw1mIp
gizqNRZX4Wx+dan+d9gRyDV6ZJAdS7sylLcwmzLdxksp9JowPN4ZQIkMEu7EWpDHMwfgKFxraxt/
4InzyVzv7x6K49mqtry7CWzG0wlfu7F8jHGdB347EI93kgpUwbCjeiFKIH9dWvrhMw9UHowjusAZ
8JwdECzc33e9PdFW9H4DesNimNffCA08a/HAVkShihLAgsuP3jRxBlFcUha4zGwZhBPRLw+W3TM6
qd2iuapNsTg1mGgr5ybE2m2STqtNKunfyM9pa8BVYA7OPEvAoHKJ4I3Sf/uPoByZFutsxRotw5Ce
Ys1llMDy5kb5ybuRkys58q1xDwweWh0HhoOXEXvKAP06aRyBeRFMaeQOEhzDykYsEHJQktGtyCZj
Ki98DERo4Q155t0Vs5E1MCm9i2oJwPX8ze1KigUQ5+U3lUsqasjyyjkM6a6gYRXBkHcBCvbZuNW4
NEh7pMXjgrPSDStfWekfGsmY6qmTYzOcj+RJwt83Ye59DqxG1X0mZSBrKvj6wcZ+afepHKnB38LG
17X3TfpiBveUVn9DBd7gFYj2n63Ks+W+4L93HumxvjZc//bllrRjk0CcaruO3X8Og+GMNtC1V/qT
Fvfm9lLZ35FXqXGFTu0WGqClMl+cjP019Qom/rqaLHnHLrkL1kF1mpYclVuAzGkmk3PddU4FgpNj
VRFhzsjSgMi+uIpujcDLqZ9W0rySlfe+eTUbNV76PCGOu3U9/9BKR82+zmIGicHuL5MX3fOgMBBA
mzTtGDNa7d0pfHTCEXqdVcxAdyYVQsaYQMiogo5G78I7GuZtm1nMUDUggk9aQEg2egno5DL72YM+
IF6OiaCEnboDGIOeLVyBjSWL+Kp7664+g2L/CK4wJygsKxMRp5CEJ+Y6fOD/AWAn7YbATgClugVo
DkpmZtoCW1LCGSYAxV7txJZ3wLjWA7ZVeFtfPCZDUGuRDbGk2afC3TDUVN/yqK26cHi+GpjpkANS
maB6Twzn104fK4BXsPAYAE/e8wTDXzuuJURYtRwUcc8OKc1FS0AEZolZ6+v7uCnnUqVP8+/7nhhP
pQ5jqTylzDnhOkaho1bMSm8LoWp/7r/5OOHJaXh/wf3++l4TQkruRT4fhHzZYGP3bYCWfqkBV0a+
OU9DwTn/z2/H0jnkBKYsTW09E1h42D7ouc8yQHnEIuth5rcAUj2jB9QOfovjB7bP0TIuUdYS44e8
PhA0AasZEvFjM6EpeGRNqf1YWE7oJUtZC+EC48mWLGkrtfM1UtoqsL9uJhWDc56nLzVlZVHoRtLM
niXbIYLI9Bi2ObJs7gwYnNyCf2vTuoyqA+9Zo7aEPkS53mbN6HUHgBkOwooh5JaLqHUK8OOasqk6
c6qi5qR7tsEuiC3xsoTTkoLFK0hlTPCFiuGiXzRLmoCMQP5sBtaQ4Dzv5LpnvwxlpK9qGFsV5xMe
ywB3B0uHtrMfN5Pgihm4bq6Jz+idrbfhhBAr/L9vc3yfbyiLSdnblPLrt8r7O6LMEnQ8xiC/nMMT
gFY1o2wganNPaXxr3iJLjgVlowWoh8yEW2VWaAIf2TkNb5evEuPL0tFXS6EB518M8yvtjSVa4EBV
z9UZZsVKx4e+ELpyaaxb5/zf0KnkBjheGig+TsIFYrckHzsJ5BdB5XJaORh7hrxwHcUc0KXdCP2o
nqqbGI3FGS0I1PuwRphsmU7hzKZkwwzSh2kX/EUin4/z0OvrkDS5az9Mp7OuRf1ZkqXt6x+gFWQ+
Bcb8jFqfa/OOVwn26DxavBAH7yi2Sk1vfZas7DvUC5kdikmjEtL2R98fFNC2CUjDOeUIIlhxZHSP
ppymSaZFt4zEXYOjByapsQYH5mGZmkUZxNjRz3CyHckyPl4JGFcpzoyrrlFGXPVKvgEUeMPqGdlg
5AddbFvgRPSEXBozAEJOzy2gqz6x851BbjZXtYHwnD+04fSiiK6ZSIAqeYQSkvCOXOer8TvLz4BS
RGjsup3H81Ilzwc0ovLRhL4/XR3k/t28TIzehbbJFYejK/3ugCOpI8DPAZXE0UfWUa/Jl40l/6QV
scNzDfdK7Vd3DhikFSCTlqVW9C8q6EpqLhbu+7cP7hFxFW/6LuNCdK70BeYmodqjCjzkudKGP98G
SOmM+Z4HuN9IpTqN8ueYbV2CWcHwpS7fmAGmRYLxlCdezEQVX0kWOXVgEjjjNNpjNLm10VS45zn7
0OOlMH/j4nkHpjJajJmvaVshA6cQdZanxS65NUOXyXqyC/WsnkmY3Jsx7FjS+MM1i3aFkYriBLhB
ykP6NKuW1nqFjJjUbCVRCtvn2h98c2CSNWchN4xl9an7VFQGhEqJgl0u5Td7aqsWDWFKSCEWvd9t
NnUZVt/IgnL6E42douPGx4MEPTmptkMz7p/eRpCuI9OsRifpW8F8eUeQGhshW6JRTHlkw1JmtT9i
QMefGWAnDP3Lic+MMzqjrWYhS3VzOHXEfWLcfQYknY8ThXtC3UkWImAnxK/6YKzyGErWC+7NfYf3
ceQSjuTeyzd812UUmHos4T37tLCSiUV/9gASp14vSanDRhf9bMQ+G7DqmbUtG6QX0lkhrnK5KwAf
234dnT+Kn3JwYzgQZEISqvsCGiURzhuqlsjXNQhpHtEqsAlF28dOJJaOTcNKPf2aVjRvaaFGuoe5
EtsW0+cxCHFLoMsf+iVLETghicjCSSGbyjCP0qpb3lYTKLrNoJFSTsj8OSwwRRTMA4k11R3Cvj9C
0cfG6ZZS1Zm1H4+9Mr+jqEPyZSYMAwdKO2f261oruncPwuHTxj1KETJVjI9oS+HpOTfBIsdaDsAD
0oLFz71uXyPVsZOHoLBg7klfuXthgYYXgNZcYSFBP8+/zTSjH5OuIUbQzsCYozR6Exp06/v1u5Rf
G2lcmli64g7rWcCkgWqEdFfCmapKdcSa190XJv6JDfmgvP1crf9ogE+5kxd//bx1ztRUa0eAmj/q
UcbJNjNyOZv+0HhwkizhJHzjcxfedsIAFmnfPdmgTL7ZNkvntmdG7riG5W6raBXndUpE7nQUXGTX
wPO7FCzINSmmuC61uJqzSOQgCUhgIqMIrVzG2D47Eb8qIHTHnuj12feslsrsiZaOmDEvkFwGDWpl
JEphFJAM8DMNep5sfBFEkT7XGS/TbSY+J3at9pEBySrbayrYMVN1Be9Jp26vdY5tQhmTKXuM3xh6
47bqnJG2TIuow4IbD4q3p4prGIKQQFjgOahSjVZFSad1Qavlu82j7AIh2dCjOIUSGSUlRtrZ6NJH
ni7ofixxX+/0Xb/JcvhI2bu31WZsyJ8qaEvx0byDe6RurbPk+566zotOeKPfWHF6iElyQA8UMWBW
fmMJ6Ah1/jHjI8R23+31MH4hgXYgjwTqkRBaHMaRlOuXdVHKTHwnN75Xw0XqHqyZPPwTXtqPXo+N
uDp0KtDPRefqz2Rx8LIppkbgJvVCADgfich7xxSY47IbRdPvi212jShC/22w9pt81gWBsVorCGr6
3wob42J7HeHAsww5MA6Ix34VNtU9gkVRuFGvdaaGUXVX8Od6law6xdf7lsnYyukm6G3RRRtfCjn0
k42zpJWdpjSflySGoljoN4FYeRIYCpof71W6LnfHwel42xYz15KgsXu9tLd4cpM/TRAwaUFHBCrQ
GHgJIpVF2f5BBNCCYZQac9mAxP9m6Fxen+SdDcSspvGygeZ+qWmFIHWEc2/8zYvY8lNHtIN0++R1
Q/KMWhhnaXxTV/y35YW9mZJk/jhkDG+9TTWm/LtEE1KrsTixWWCO7M2yoUH2pInu6O7vv758Ditl
STDyu3MfH0sRbF1oIlIiB7G/xS78df7xCqcd7kY0kExYlON4b8ZyASKfbI4MJZCxzcBxmEr54Xe1
dCgQrxN5+npai6e4JVJlbSf9hjJsgoy1YVYFIipjv/wbV/sGOqk4XOS6nTThL+xlqGfiRpEzoBVy
tykuzs99dDx1tCO7qdd1My7M79NvBTZR5Ggqe6tKzd9Lk2FFcfnxqryLCNIR19MjwAP8r6br3V95
G1oZhg5EdwDjWQ1JFBfkrdjl+CW0HAk19abzH384H0Ur3en1tYL4tVMyuoDnIQH9q1GPfR/a9IIw
5N2LUw44/YPaQ5/fgvldzJM3v2cvNw8w3jwi3omXgiAO3/pO5zHFXSsoB36ONm+oVmKLJ/EuB+Vm
CNkKvrEZfk/tMWjPmscdoFpjveULtdG4WFi8gCSPMaMmtqWDw2PF1lCVyHhkkD4RnBkB53zHZKgE
5gTkyWAJQr+vSSYImsG2kgrvMXkJiSyNvAXEIP7d8dKNSHEivI7qvPFEkvPTYsbpBdFCWC9I3Lic
KK1hk+neW0kRKmIh2aP263i8n/WdQzTrWd/F6phL/v9Ugd6RZIsAWBqBX706i/0YAJHTqsDEFbPp
cshBu2ZXKNj6Z060S55++zv0RlpFLZMzBpDFQiOliHbkS1GAx0FzjRk2g+oET5zVV+Vxi9NDA6RT
AFzJa9TIIHpB83ruI8OCSI532KKyWF9ZvgEwn77nv0A5NOcR1KSrIxuqH3k30+4+u5PfQCN9G30T
ubu6QSvXrb4Uvd9a3uTfxYmB3OJkU5vi0XdfaGsfDDIl9Pml+4l4nhGsWl4QV7Jmg+rtRadlqHY+
rTkp8omUcZBdsgfOrpACfh9wBya1kw1MDeVNq6o44i603neqllHuzpf30LBuFzl7jT51ANiIpurh
DUO4Il6lW7fQ2BNkGao/IZ9LLJRe5n7cJvJARavY4TlxpTH0DanJz+FR92wXyVyNczz/sJXqdoAK
DdrFWafNntVTm8tyA2nmuiKxqspHqYciZRjgXazgYxa8FSbSTBIonPrz8CXnvlFEMSXJ1D/5nijN
ftz7mQvgrM1eChIpQk4msYquI0fm8Z+VCfhyNtcPKsyBNS36RPF0SCYMVRaDaay/jDNRBx867Fge
SCKDZKifUVQO3ZRKgHz9F8HhaQKK8bqgervDv5/Qa+04tCEpvrdAo6hg1VgpHuD5HxO2ly3REy8S
UG7fJEsR8VWA3wjysj48qimc0E4eCG3DMxscBW1xNp0CjCxpRzJlOdJyexHDoUz2bX+7vH1/bZqz
hSYC/P60RNlVcI6+wfCDr9ktuU/2cON8Htz9rVeIgmehyS4hbCAhIVgwEYaTd3qKdIz1Xh+5cjHu
Iida1PmvTLQs4O9USiugx+Ww1N/X6RnhoBA07b1tPtJY6+M+XI9lXAHJMli9qarDBPmY4K0s823Y
7VSoCQjEHvDq7kCHES9u7FleciumtohXM32aKQgQHLt+3Fkt9S3tc8EnYOpqhXD3Lh13rsPkmTN5
tQGHA64vxt0rqKoL5O2PHXv7hjUSkxPtfO3w3i5v4LT2/6LBC7i7JiR3xMut0hSDYJq12XWqoOqJ
nAlY5uwEK8OFC47njnMO09ebSK19QfW8ZOdVJr5NxW4KGvuC8gpZujEeO4VJEuxrprinYquO71sJ
UJccTy/OpfaoVEqfYKGbSG/FfZq8qCldH0gl40aSfOYT8v3g7dm1g1Pdike3Pk1J+dolumnEIKhO
gk8pkI0piAc/ISpZ0VlQB+zr9OBgwKcU7ah9WbE29Un7J/EwBZjaAx/jJ8eY+IoZR/I4+xr2icLS
+JqH2vxYqWIINUoFoJyeQw/nUXLKyqdYCiSnJH9dupaywiE0DB8Pqw0XTf7nfcxByTgN7CMRcRnS
KdrIHdGF7jBGGvE+40K3kWA9ErgOvNH9mTQy5IPAnVekMBM3RSnUmZAJdCAbZyeI+69+bCnj1QGT
igANw2LdhTX94yXU60NIFcSIzoWUPf97DnLVo5xF0W2tu7BdBNMs81NIKS+zNZs9mrmr7OvFty0s
Pi0L0JG8yDgAO01b1pSjw6+elj+oiR/USenjQMjavL+zk/Rms4SkgiCgH3Ru0hd66ScMd2uhwgVY
8ddbZvEotFBTkYR374YORA+iYkIVqwflstv0UG87mQXUqD3Pnygfk1jJ4lD1kL/J9+rGvHKtxvv0
FiMC7UUc7sIz3mVO5aqMr1+wR6nyhuEhX2kzt3dZj0BFn8wx0suno/pkEHvXODz8dY7eSFVBdKzz
Y9zkGjZ2B1zq3YM0obYB/s6antRN3bLAxI/FV49SLt1W8m50uPz8Zbv3TRsNGg6I0XN/pg0EWAku
GQhLzxBWtrXLFew1YbR3ehs6EtLFtpI3ts9sY2npBOzYq5KPXO9U+B/DPUof2fS2oZ9AsEiF8kfp
knbvJng1SB6GrLn4tOkZy2FRExICF2rKBQJpbQRgdFJU8tAFlgKTIFSWf0+AOed4mBeWUAw/D88I
LdGdz4tulIVHeKhl+C62fCumiXmp7/z0Ikc3qYFUWYtsdjWFpJVSMENydhWmwi5a8X5V+fV4MqpU
BMtFNyd1uGrm6itQLoiwaZWU0FOtSViyFBQwisBAToTIjAVYycP1wUF/zTAiXmgCOZBHozyoNSgW
o4kia2ZAd4UbAaXAZOKa94kF/S9EkHRgebwtmrRnqyiydz59EWFGO0P7NsXRcrynsbOs43vqdazb
wgyuK3wy4ZNFYeyrB3Tj/tHS6JFI4dua0TTCYJTvvx0qJ+vn7QtgcsjqF7YPAiV6c05jSPpOHRdr
ssrWtrbbuPwUp4oqPx7EMjJvMk4r7lf6tc+3OlO3iOiaEeCCbFSc/q99uzh7dfTsbVqKZnIYG2wd
1bPYyN0AYpXuU+IwOdjNnEsB84Fu4FLVR1d9fAn+JemybtmZHUDkK8cx4wN6XwOIJLCHpLK1GuJt
zJCZbN71Gpyeq3A+5VtIhNOPK5Z0ZZ7ke1G8AfAarfxJyysJpsYIMAANvjogy1aJUV70HS5jsMub
36gzff+H1grUgs8YzXV2tTdkVWVy/oLMkAi9nAI50E4sSsZCSouMHPs5ThkQQv8imB+SN88LuUNk
XrOVBBqq3bYPW0J3YP4qqMLGccbsA3dIDqPRZboStRRJrrefLYKwSCZsFsrkQBrX/aSaYZsoVqoO
pX+/sIS+05AthGITHTJdw4emC4E/1m3P2kDSn5qM2DMzl2my+j081Oe+BbgKs/joGBFcEUkd
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
