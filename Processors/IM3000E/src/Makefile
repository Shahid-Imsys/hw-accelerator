GPP_DIR=$(PROJECT_PATH)/Processors/IM3000E/src
GPP_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/src

IP_DIR_WIN=$(PROJECT_PATH_WIN)/fpga_synth/gpp

gpp_rtl: mem_load_comp fpga_ip
	$(COMP) $(COMP_RTL_FLAGS) $(GPP_DIR_WIN)/mpgmfield_lib.vhd \
			 	  $(GPP_DIR_WIN)/gp_pkg.vhd \
			 	  $(GPP_DIR_WIN)/fgendec.vhd \
			 	  $(GPP_DIR_WIN)/fgenpart.vhd \
			 	  $(GPP_DIR_WIN)/fgenhalf.vhd \
			 	  $(GPP_DIR_WIN)/fgen.vhd \
			 	  $(GPP_DIR_WIN)/ram32x8.vhd \
			 	  $(GPP_DIR_WIN)/alu.vhd \
			 	  $(GPP_DIR_WIN)/sct.vhd \
			 	  $(GPP_DIR_WIN)/stack9x14.vhd \
			 	  $(GPP_DIR_WIN)/clc.vhd \
			 	  $(GPP_DIR_WIN)/clk_mux.vhd \
			 	  $(GPP_DIR_WIN)/clk_gen.vhd \
			 	  $(GPP_DIR_WIN)/pads/YA2GSD.vhd \
			 	  $(GPP_DIR_WIN)/iopads.vhd \
			 	  $(GPP_DIR_WIN)/rtc.vhd \
			 	  $(GPP_DIR_WIN)/rtc_iso.vhd \
			 	  $(GPP_DIR_WIN)/mpgm.vhd \
			 	  $(GPP_DIR_WIN)/crb.vhd \
			 	  $(GPP_DIR_WIN)/tim.vhd \
			 	  $(GPP_DIR_WIN)/gmem.vhd \
			 	  $(GPP_DIR_WIN)/dsl.vhd \
			 	  $(GPP_DIR_WIN)/mbm.vhd \
			 	  $(GPP_DIR_WIN)/mmr.vhd \
			 	  $(GPP_DIR_WIN)/mpll.vhd \
			 	  $(GPP_DIR_WIN)/debug_trace.vhd \
			 	  $(GPP_DIR_WIN)/cpc.vhd \
			 	  $(GPP_DIR_WIN)/ios_dackgen.vhd \
			 	  $(GPP_DIR_WIN)/ios_dmap.vhd \
			 	  $(GPP_DIR_WIN)/ios_dma.vhd \
			 	  $(GPP_DIR_WIN)/ios.vhd \
			 	  $(GPP_DIR_WIN)/core.vhd \
			 	  $(GPP_DIR_WIN)/core2/ampgm.vhd \
			 	  $(GPP_DIR_WIN)/core2/atim.vhd \
			 	  $(GPP_DIR_WIN)/core2/acore.vhd \
			 	  $(GPP_DIR_WIN)/mpmem_inf.vhd \
			 	  $(GPP_DIR_WIN)/sdram_inf.vhd \
			 	  $(GPP_DIR_WIN)/peri/pdi.vhd \
			 	  $(GPP_DIR_WIN)/peri/tiu.vhd \
			 	  $(GPP_DIR_WIN)/peri/ports.vhd \
			 	  $(GPP_DIR_WIN)/peri/port_mux.vhd \
			 	  $(GPP_DIR_WIN)/peri/io_mux.vhd \
			 	  $(GPP_DIR_WIN)/peri/uart.vhd \
			 	  $(GPP_DIR_WIN)/peri/eth_crc.vhd \
			 	  $(GPP_DIR_WIN)/peri/eth_rx.vhd \
			 	  $(GPP_DIR_WIN)/peri/eth_tx.vhd \
			 	  $(GPP_DIR_WIN)/peri/eth.vhd \
			 	  $(GPP_DIR_WIN)/peri/adc.vhd \
			 	  $(GPP_DIR_WIN)/peri/dac.vhd \
			 	  $(GPP_DIR_WIN)/peri/OctoSPI.vhd \
			 	  $(GPP_DIR_WIN)/peri/peri.vhd \
			 	  $(GPP_DIR_WIN)/top.vhd \
			 	  $(GPP_DIR_WIN)/ext/mprom_memory00.vhd \
			 	  $(GPP_DIR_WIN)/ext/mprom_memory11.vhd \
			 	  $(GPP_DIR_WIN)/ext/mpram_memory.vhd \
			 	  $(GPP_DIR_WIN)/ext/ram_memory.vhd \
			 	  $(GPP_DIR_WIN)/ext/memory_1024x8.vhd \
			 	  $(GPP_DIR_WIN)/ext/trace_memory.vhd \
			 	  $(GPP_DIR_WIN)/ext/b_memory.vhd \
			 	  $(GPP_DIR_WIN)/ext/SP180_4096X80BM1B.vhd \
			 	  $(GPP_DIR_WIN)/ext/SY180_2048X2X1CM8.vhd \
			 	  $(GPP_DIR_WIN)/ext/SU180_16384X8X1BM8.vhd \
			 	  $(GPP_DIR_WIN)/ext/SY180_256X32X1CM4.vhd \
			 	  $(GPP_DIR_WIN)/ext/SU180_2048X80X1BM1.vhd \
			 	  $(GPP_DIR_WIN)/ext/SY180_512X8X1CM8.vhd \
			 	  $(GPP_DIR_WIN)/ext/SP180_4096X80BM1A.vhd \
			 	  $(GPP_DIR_WIN)/ext/SY180_1024X8X1CM8.vhd

mem_load_comp:
	$(V_COMP) $(GPP_DIR_WIN)/ext/load_mpram.v

fpga_ip:
#	$(V_COMP) $(IP_DIR_WIN)/gpp.ip_user_files/ipstatic/simulation/dist_mem_gen_v8_0.v \
#	          $(IP_DIR_WIN)/gpp.ip_user_files/ipstatic/simulation/blk_mem_gen_v8_4.v
#		  $(IP_DIR_WIN)/gpp.gen/sources_1/ip/dist_mem_gen_0/sim/dist_mem_gen_0.v
	$(V_COMP) $(IP_DIR_WIN)/gpp.gen/sources_1/ip/main_mem/sim/main_mem.v
	$(V_COMP) $(IP_DIR_WIN)/gpp.gen/sources_1/ip/mpram_mem/sim/mpram_mem.v
	#$(V_COMP) $(IP_DIR_WIN)/gpp.gen/sources_1/ip/eth_tx_fifo/sim/eth_tx_fifo.v

#include $(GPP_DIR)/pads/Makefile
