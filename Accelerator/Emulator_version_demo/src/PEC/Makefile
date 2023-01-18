PEC_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC
PEC_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC
NOC2_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2
NOC2_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/NoC2

pec_rtl: dual_core_rtl mem_comp
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cluster_pkg.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/noc_types_pkg.vhd \
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cluster_controller.vhd \
			 	  $(PEC_DIR_WIN)/FPGA_CMEM_32KX16.vhd   \
			 	  $(PEC_DIR_WIN)/PEC_top.vhd            \
			 	  $(PEC_DIR_WIN)/req_dis_logic.vhd      \
			 	  $(PEC_DIR_WIN)/fifo.vhd

include $(PEC_DIR)/dual_core/Makefile
include $(PROJECT_PATH)/IP/Synopsys/Makefile
