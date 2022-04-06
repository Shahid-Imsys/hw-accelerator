PEC_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC
PEC_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC

pec_rtl: dual_core_rtl ip
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cluster_pkg.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cc.vhd \
			 	  $(PEC_DIR_WIN)/CMEM_32KX16.vhd \
			 	  $(PEC_DIR_WIN)/PEC_top.vhd \
			 	  $(PEC_DIR_WIN)/req_dis_logic_16.vhd

ip:
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/xilinx\ IP/PEC\ IPs/fifo_generator_0/fifo_generator_0_sim_netlist.vhdl \
				$(PEC_DIR_WIN)/xilinx\ IP/PEC\ IPs/fifo_generator_1/fifo_generator_1_sim_netlist.vhdl \
				$(PEC_DIR_WIN)/xilinx\ IP/PEC\ IPs/c_accum_0/c_accum_0_sim_netlist.vhdl \
				$(PEC_DIR_WIN)/xilinx\ IP/PEC\ IPs/dist_mem_gen_0/dist_mem_gen_0_sim_netlist.vhdl \
				$(PEC_DIR_WIN)/xilinx\ IP/PEC\ IPs/dist_mem_gen_1/dist_mem_gen_1_sim_netlist.vhdl \
				$(PEC_DIR_WIN)/xilinx\ IP/PEC\ IPs/mult_gen_0/mult_gen_0_sim_netlist.vhdl \
				$(PEC_DIR_WIN)/arithmetic\ IP/Accumulator.vhd \
				$(PEC_DIR_WIN)/arithmetic\ IP/Dist_ram_0.vhd \
				$(PEC_DIR_WIN)/arithmetic\ IP/Dist_ram_1.vhd \
				$(PEC_DIR_WIN)/arithmetic\ IP/mul.vhd

include $(PEC_DIR)/dual_core/Makefile
