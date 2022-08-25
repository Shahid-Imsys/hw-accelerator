
# create_generated_clock -name ld_bmem -divide_by 2 [get_pins {core1/crb/ld_bmem_reg/Q}] -source [get_ports HCLK]

set_property PACKAGE_PIN AY9 [get_ports {OSPI_Out[CK_p]}]
set_property PACKAGE_PIN BA9 [get_ports {OSPI_Out[CK_n]}]
set_property PACKAGE_PIN BE12 [get_ports {OSPI_Out[CS_n]}]
set_property PACKAGE_PIN BF10 [get_ports {OSPI_Out[RESET_n]}]
set_property PACKAGE_PIN BD12 [get_ports OSPI_RWDS]
set_property PACKAGE_PIN BD13 [get_ports {OSPI_DQ[0]}]
set_property PACKAGE_PIN BE13 [get_ports {OSPI_DQ[1]}]
set_property PACKAGE_PIN BB13 [get_ports {OSPI_DQ[2]}]
set_property PACKAGE_PIN BB12 [get_ports {OSPI_DQ[3]}]
set_property PACKAGE_PIN BE14 [get_ports {OSPI_DQ[4]}]
set_property PACKAGE_PIN BF14 [get_ports {OSPI_DQ[5]}]
set_property PACKAGE_PIN BA14 [get_ports {OSPI_DQ[6]}]
set_property PACKAGE_PIN BB14 [get_ports {OSPI_DQ[7]}]
set_property PACKAGE_PIN BE15 [get_ports MCKOUT0]
set_property PACKAGE_PIN BF9 [get_ports MRESET]
set_property PACKAGE_PIN BF15 [get_ports MSDIN]
set_property PACKAGE_PIN BC14 [get_ports MSDOUT]
set_property PACKAGE_PIN BC15 [get_ports MIRQ0]
set_property PACKAGE_PIN BC13 [get_ports MIRQOUT]
set_property PACKAGE_PIN BA37 [get_ports {LED[7]}]
set_property PACKAGE_PIN AV36 [get_ports {LED[6]}]
set_property PACKAGE_PIN AU37 [get_ports {LED[5]}]
set_property PACKAGE_PIN BF32 [get_ports {LED[4]}]
set_property PACKAGE_PIN BB32 [get_ports {LED[3]}]
set_property PACKAGE_PIN AY30 [get_ports {LED[2]}]
set_property PACKAGE_PIN AV34 [get_ports {LED[1]}]
set_property PACKAGE_PIN AT32 [get_ports {LED[0]}]

set_property PACKAGE_PIN BB16 [get_ports OE_CTR]
set_property PACKAGE_PIN AP13 [get_ports PA6_SCK]
set_property PACKAGE_PIN AR13 [get_ports PA5_CS_N]
set_property PACKAGE_PIN AV10 [get_ports PA0_SIN]
set_property PACKAGE_PIN AW10 [get_ports PA7_SOUT]
set_property PACKAGE_PIN AK13 [get_ports ENET_TXD3]
set_property PACKAGE_PIN AK14 [get_ports ENET_TXD2]
set_property PACKAGE_PIN AM12 [get_ports ENET_TXD1]
set_property PACKAGE_PIN AM13 [get_ports ENET_TXD0]
set_property PACKAGE_PIN AV13 [get_ports ENET_TXCTL]
set_property PACKAGE_PIN AV14 [get_ports ENET_TXCLK]
set_property PACKAGE_PIN AJ12 [get_ports ENET_RXD3]
set_property PACKAGE_PIN AJ13 [get_ports ENET_RXD2]
set_property PACKAGE_PIN AL12 [get_ports ENET_RXD1]
set_property PACKAGE_PIN AK12 [get_ports ENET_RXD0]
set_property PACKAGE_PIN AT14 [get_ports ENET_RXCTL]
set_property PACKAGE_PIN AR14 [get_ports ENET_RXCLK]
set_property PACKAGE_PIN BD15 [get_ports ENET_RST_N]
set_property PACKAGE_PIN BD11 [get_ports ENET_MDIO]
set_property PACKAGE_PIN BC11 [get_ports ENET_MDC]
set_property PACKAGE_PIN AW8 [get_ports {TEST_OUTP[0]}]
set_property PACKAGE_PIN AW7 [get_ports {TEST_OUTP[1]}]
set_property PACKAGE_PIN AP12 [get_ports {TEST_OUTP[2]}]
set_property PACKAGE_PIN AR12 [get_ports {TEST_OUTP[3]}]
set_property PACKAGE_PIN AL14 [get_ports {TEST_OUTP[4]}]
set_property PACKAGE_PIN AM14 [get_ports {TEST_OUTP[5]}]
set_property PACKAGE_PIN AY8 [get_ports {TEST_OUTP[6]}]
set_property PACKAGE_PIN AY7 [get_ports {TEST_OUTP[7]}]
set_property PACKAGE_PIN AN16 [get_ports {TEST_OUTP[8]}]
set_property PACKAGE_PIN AP16 [get_ports {TEST_OUTP[9]}]
set_property PACKAGE_PIN AK15 [get_ports {TEST_OUTP[10]}]
set_property PACKAGE_PIN AL15 [get_ports {TEST_OUTP[11]}]
set_property PACKAGE_PIN AV9 [get_ports {TEST_OUTP[12]}]
set_property PACKAGE_PIN AV8 [get_ports {TEST_OUTP[13]}]
set_property PACKAGE_PIN AW11 [get_ports {TEST_OUTP[14]}]
set_property PACKAGE_PIN AY10 [get_ports {TEST_OUTP[15]}]
set_property PACKAGE_PIN BC9 [get_ports URX]
set_property PACKAGE_PIN BC8 [get_ports UTX]

set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports MSDOUT]
set_property IOSTANDARD LVCMOS18 [get_ports OE_CTR]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[CK_n]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[CK_p]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[CS_n]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[RESET_n]}]
set_property IOSTANDARD LVCMOS18 [get_ports OSPI_RWDS]
set_property IOSTANDARD LVCMOS18 [get_ports PA0_SIN]
set_property IOSTANDARD LVCMOS18 [get_ports PA5_CS_N]
set_property IOSTANDARD LVCMOS18 [get_ports PA6_SCK]
set_property IOSTANDARD LVCMOS18 [get_ports PA7_SOUT]
set_property IOSTANDARD LVCMOS18 [get_ports URX]
set_property IOSTANDARD LVCMOS18 [get_ports UTX]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXCTL]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD0]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD1]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD2]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD3]
set_property IOSTANDARD LVCMOS18 [get_ports MCKOUT0]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_MDC]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_MDIO]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RST_N]
set_property IOSTANDARD LVCMOS18 [get_ports MIRQOUT]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXCLK]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXCTL]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD0]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD1]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD2]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD3]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXCLK]
set_property IOSTANDARD LVCMOS18 [get_ports MIRQ0]
set_property IOSTANDARD LVCMOS18 [get_ports MRESET]
set_property IOSTANDARD LVCMOS18 [get_ports MSDIN]

set_property PACKAGE_PIN AY14 [get_ports {pmod0_in[0]}]
set_property PACKAGE_PIN AY15 [get_ports {pmod0_in[1]}]
set_property PACKAGE_PIN AW15 [get_ports {pmod0_in[2]}]
set_property PACKAGE_PIN AV15 [get_ports {pmod0_out[3]}]
set_property PACKAGE_PIN AV16 [get_ports {pmod0_out[4]}]

set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_in[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_in[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_in[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_out[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_out[4]}]

# No PMOD is clock capable, so override this requirement. Should be ok, the SPI clock is slow.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {pmod0_in_IBUF[0]_inst/O}]

create_clock -period 20.000 -name ENET_TXCLK -waveform {0.000 10.000} [get_ports ENET_TXCLK]
set_clock_groups -name ENET_TXCLK -asynchronous -group [get_clocks ENET_TXCLK]

create_clock -period 20.000 -name ENET_RXCLK -waveform {0.000 10.000} [get_ports ENET_RXCLK]
set_clock_groups -name ENET_RXCLK -asynchronous -group [get_clocks ENET_RXCLK]

create_clock -period 100.000 -name SPI_SCK -waveform {0.000 50.000} [get_ports {pmod0_in[0]}]
set_clock_groups -name SPI_CLK -asynchronous -group [get_clocks SPI_SCK]

#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 2.000 [get_ports ENET_MDIO]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports ENET_MDIO]
#set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports ENET_MDIO]
#set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.500 [get_ports ENET_MDIO]
#set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports ENET_MDC]
#set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.500 [get_ports ENET_MDC]
#set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports ENET_RST_N]
#set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.500 [get_ports ENET_RST_N]

#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports ENET_RXCTL]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports ENET_RXCTL]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports ENET_RXD0]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports ENET_RXD0]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports ENET_RXD1]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports ENET_RXD1]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports ENET_RXD3]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports ENET_RXD3]


set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXCTL]
set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXD0]
set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXD1]
set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXD3]

set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXCTL]
set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXD0]
set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXD1]
set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXD3]

set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXCTL]
set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXD0]
set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXD1]
set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXD3]

set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXCTL]
set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXD0]
set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXD1]
set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXD3]

# CS
#set_input_delay -clock [get_clocks SPI_SCK] -min -add_delay 48.000 [get_ports {pmod0_in[1]}]
#set_input_delay -clock [get_clocks SPI_SCK] -max -add_delay 52.000 [get_ports {pmod0_in[1]}]

# MOSI
#set_input_delay -clock [get_clocks SPI_SCK] -min -add_delay 48.000 [get_ports {pmod0_in[2]}]
#set_input_delay -clock [get_clocks SPI_SCK] -max -add_delay 52.000 [get_ports {pmod0_in[2]}]


set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports {OSPI_DQ[*]}]
set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports OSPI_RWDS]
set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports {OSPI_DQ[*]}]
set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports OSPI_RWDS]

set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.200 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.200 [get_ports OSPI_RWDS]

set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports {OSPI_Out[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.200 [get_ports {OSPI_Out[*]}]

set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 3.000 [get_ports UTX]
set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 5.000 [get_ports UTX]

set_input_delay -clock [get_clocks SPI_SCK] 10.000 [get_ports {pmod0_in[*]}]
set_output_delay -clock [get_clocks SPI_SCK] 1.000 [get_ports {pmod0_out[*]}]

set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.200 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.200 [get_ports OSPI_RWDS]

set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports {OSPI_Out[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay 0.200 [get_ports {OSPI_Out[*]}]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports {OSPI_Out[*]}]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.250 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.250 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.250 [get_ports {OSPI_Out[*]}]

set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay -1.000 [get_ports {OSPI_Out[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay -0.300 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay -0.300 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -max -add_delay -0.300 [get_ports {OSPI_Out[*]}]


set_input_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay 2.000 [get_ports ENET_MDIO]
set_input_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 5.000 [get_ports ENET_MDIO]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports ENET_MDIO]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.100 [get_ports ENET_MDIO]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports ENET_MDC]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.100 [get_ports ENET_MDC]

#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports ENET_RST_N]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.500 [get_ports ENET_RST_N]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA0_SIN]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA0_SIN]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA5_CS_N]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA5_CS_N]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA6_SCK]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA6_SCK]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA7_SOUT]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA7_SOUT]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports URX]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports URX]

# SPI CS to OE
set_false_path -from [get_ports {pmod0_in[1]}] -to [get_ports {pmod0_out[4]}]

# From IM3000C
set_false_path -from [get_cells im4000_inst/i_digital_core/i_im4000_top/core1/crb/en_uart1_int_reg]
set_false_path -from [get_cells im4000_inst/i_digital_core/i_im4000_top/core1/crb/en_uart2_int_reg]
set_false_path -from [get_cells im4000_inst/i_digital_core/i_im4000_top/core1/crb/en_uart3_int_reg]

# Ports
set_false_path -to [get_ports *LED*]

set_false_path -from [get_ports URX]
set_false_path -from [get_ports MRESET]
set_false_path -from [get_ports MIRQ0]
set_false_path -from [get_ports MSDIN]

set_false_path -to [get_ports UTX]
set_false_path -to [get_ports MCKOUT0]
set_false_path -to [get_ports MSDOUT]
set_false_path -to [get_ports MIRQOUT]

set_false_path -to [get_ports ENET_RST_N]






connect_debug_port u_ila_0/probe13 [get_nets [list im4000_inst/i_clock_reset/c1_wdog_n]]
connect_debug_port u_ila_0/probe14 [get_nets [list im4000_inst/i_clock_reset/clk_p]]
connect_debug_port u_ila_0/probe15 [get_nets [list im4000_inst/i_clock_reset/clock_p_puls]]
connect_debug_port u_ila_0/probe16 [get_nets [list im4000_inst/i_clock_reset/common_rst_n]]
connect_debug_port u_ila_0/probe21 [get_nets [list im4000_inst/i_clock_reset/main_rst_n]]
connect_debug_port u_ila_0/probe33 [get_nets [list im4000_inst/i_clock_reset/p_0_in]]
connect_debug_port u_ila_0/probe34 [get_nets [list im4000_inst/i_clock_reset/p_1_in]]
connect_debug_port u_ila_0/probe36 [get_nets [list im4000_inst/i_clock_reset/rst_n]]
connect_debug_port u_ila_0/probe37 [get_nets [list im4000_inst/i_clock_reset/sel_pll_all]]






create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list fpga_pll_inst/inst/clk_100M]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_ce[0]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 14 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[0]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[1]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[2]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[3]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[4]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[5]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[6]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[7]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[8]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[9]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[10]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[11]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[12]} {im4000_inst/i_digital_core/i_im4000_top/c1_mprom_a[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 7 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_rdindex[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 7 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_length[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 3 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_fsm[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_fsm[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_fsm[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_latency[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_latency[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_latency[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_latency[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 2 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_ce[0]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 14 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[0]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[1]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[2]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[3]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[4]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[5]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[6]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[7]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[8]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[9]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[10]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[11]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[12]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_a[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 80 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[0]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[1]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[2]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[3]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[4]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[5]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[6]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[7]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[8]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[9]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[10]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[11]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[12]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[13]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[14]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[15]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[16]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[17]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[18]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[19]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[20]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[21]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[22]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[23]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[24]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[25]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[26]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[27]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[28]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[29]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[30]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[31]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[32]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[33]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[34]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[35]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[36]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[37]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[38]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[39]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[40]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[41]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[42]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[43]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[44]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[45]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[46]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[47]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[48]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[49]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[50]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[51]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[52]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[53]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[54]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[55]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[56]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[57]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[58]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[59]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[60]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[61]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[62]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[63]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[64]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[65]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[66]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[67]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[68]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[69]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[70]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[71]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[72]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[73]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[74]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[75]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[76]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[77]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[78]} {im4000_inst/i_digital_core/i_im4000_top/c1_mpram_d[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 80 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/core2/pl[0]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[1]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[2]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[3]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[4]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[5]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[6]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[7]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[8]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[9]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[10]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[11]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[12]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[13]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[14]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[15]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[16]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[17]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[18]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[19]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[20]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[21]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[22]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[23]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[24]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[25]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[26]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[27]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[28]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[29]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[30]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[31]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[32]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[33]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[34]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[35]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[36]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[37]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[38]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[39]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[40]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[41]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[42]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[43]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[44]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[45]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[46]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[47]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[48]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[49]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[50]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[51]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[52]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[53]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[54]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[55]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[56]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[57]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[58]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[59]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[60]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[61]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[62]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[63]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[64]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[65]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[66]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[67]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[68]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[69]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[70]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[71]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[72]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[73]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[74]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[75]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[76]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[77]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[78]} {im4000_inst/i_digital_core/i_im4000_top/core2/pl[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_out[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/idi[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_o[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ido[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 9 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[7]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_counter[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_cmd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_i[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 32 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[0]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[1]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[2]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[3]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[4]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[5]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[6]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[7]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[8]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[9]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[10]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[11]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[12]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[13]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[14]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[15]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[16]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[17]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[18]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[19]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[20]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[21]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[22]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[23]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[24]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[25]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[26]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[27]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[28]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[29]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[30]} {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ospi_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 80 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/core1/pl[0]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[1]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[2]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[3]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[4]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[5]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[6]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[7]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[8]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[9]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[10]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[11]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[12]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[13]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[14]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[15]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[16]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[17]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[18]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[19]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[20]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[21]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[22]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[23]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[24]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[25]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[26]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[27]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[28]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[29]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[30]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[31]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[32]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[33]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[34]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[35]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[36]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[37]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[38]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[39]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[40]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[41]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[42]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[43]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[44]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[45]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[46]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[47]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[48]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[49]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[50]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[51]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[52]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[53]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[54]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[55]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[56]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[57]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[58]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[59]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[60]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[61]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[62]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[63]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[64]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[65]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[66]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[67]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[68]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[69]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[70]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[71]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[72]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[73]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[74]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[75]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[76]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[77]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[78]} {im4000_inst/i_digital_core/i_im4000_top/core1/pl[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 80 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[0]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[1]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[2]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[3]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[4]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[5]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[6]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[7]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[8]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[9]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[10]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[11]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[12]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[13]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[14]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[15]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[16]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[17]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[18]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[19]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[20]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[21]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[22]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[23]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[24]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[25]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[26]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[27]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[28]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[29]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[30]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[31]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[32]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[33]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[34]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[35]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[36]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[37]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[38]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[39]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[40]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[41]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[42]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[43]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[44]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[45]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[46]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[47]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[48]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[49]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[50]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[51]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[52]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[53]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[54]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[55]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[56]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[57]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[58]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[59]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[60]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[61]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[62]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[63]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[64]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[65]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[66]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[67]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[68]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[69]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[70]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[71]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[72]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[73]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[74]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[75]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[76]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[77]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[78]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_d[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 2 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_ce[0]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 14 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[0]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[1]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[2]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[3]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[4]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[5]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[6]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[7]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[8]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[9]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[10]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[11]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[12]} {im4000_inst/i_digital_core/i_im4000_top/c2_mpram_a[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 14 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[0]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[1]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[2]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[3]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[4]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[5]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[6]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[7]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[8]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[9]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[10]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[11]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[12]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_a[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 2 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_ce[0]} {im4000_inst/i_digital_core/i_im4000_top/c2_mprom_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 8 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {OSPI_DQ_i[0]} {OSPI_DQ_i[1]} {OSPI_DQ_i[2]} {OSPI_DQ_i[3]} {OSPI_DQ_i[4]} {OSPI_DQ_i[5]} {OSPI_DQ_i[6]} {OSPI_DQ_i[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/c2_core2_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/flags_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ildout]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/ilioa]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/inext]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_DQ_e]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list OSPI_DQ_e]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_Out[CK_n]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_Out[CK_p]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_Out[CS_n]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_Out[RESET_n]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_RWDS_e]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list OSPI_RWDS_e]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list OSPI_RWDS_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_RWDS_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/OSPI_RWDS_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list im4000_inst/i_digital_core/i_im4000_top/peri01/ospi/rst_n]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_100m]
