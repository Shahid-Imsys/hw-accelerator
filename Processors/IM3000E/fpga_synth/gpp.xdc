
create_clock -name hclk -period 20 [get_ports HCLK]
create_clock -name clk_tx -period 80 [get_ports PF[1]]
create_clock -name clk_rx -period 80 [get_ports PG[1]]
create_clock -name clk_pd -period 80 [get_ports PD[7]]

#create_clock -name rtc_clk -period 28571 [get_ports rxout]

##create_generated_clock -name en_fclk -divide_by 2 [get_pins {core1/crb/en_fclk_reg/Q}] -source [get_ports HCLK]
##create_generated_clock -name fclk    -divide_by 2 [get_pins {core1/crb/fclk_reg/Q}]    -source [get_ports HCLK]
create_generated_clock -name ld_bmem -divide_by 2 [get_pins {core1/crb/ld_bmem_reg/Q}] -source [get_ports HCLK]

#create_generated_clock -divide_by 2 [get_pins {peri01/timer/capture.trig_edge_reg[*]/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/tic.clk_wr_reg/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 4 [get_pins {peri01/timer/tic.clk_t_reg[*]/Q}] -source [get_ports HCLK]

#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[0].div.ff_reg[0]/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[1].div.ff_reg[1]/Q}] -source [get_pins {peri01/timer/prescaler.freq[0].div.ff_reg[0]/Q}]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[2].div.ff_reg[2]/Q}] -source [get_pins {peri01/timer/prescaler.freq[1].div.ff_reg[1]/Q}]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[3].div.ff_reg[3]/Q}] -source [get_pins {peri01/timer/prescaler.freq[2].div.ff_reg[2]/Q}]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[4].div.ff_reg[4]/Q}] -source [get_pins {peri01/timer/prescaler.freq[3].div.ff_reg[3]/Q}]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[5].div.ff_reg[5]/Q}] -source [get_pins {peri01/timer/prescaler.freq[4].div.ff_reg[4]/Q}]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[6].div.ff_reg[6]/Q}] -source [get_pins {peri01/timer/prescaler.freq[5].div.ff_reg[5]/Q}]
#create_generated_clock -divide_by 2 [get_pins {peri01/timer/prescaler.freq[7].div.ff_reg[7]/Q}] -source [get_pins {peri01/timer/prescaler.freq[6].div.ff_reg[6]/Q}]

#create_generated_clock -divide_by 2 [get_pins {peri01/ports/port_gen[13][0]/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 2 [get_pins {peri01/ports/port_gen[13][1]/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 2 [get_pins {peri01/ports/port_gen[13][5]/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 2 [get_pins {peri01/ports/port_gen[13][4]/Q}] -source [get_ports HCLK]
#create_generated_clock -divide_by 2 [get_pins {peri01/ports/port_gen[13][5]/Q}] -source [get_ports HCLK]



