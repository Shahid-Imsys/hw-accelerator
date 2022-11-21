PEC_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC
PEC_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC

pec_rtl: dual_core_rtl ip mem_comp
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cluster_pkg.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cluster_controller.vhd \
			 	  $(PEC_DIR_WIN)/CMEM_32KX16.vhd \
			 	  $(PEC_DIR_WIN)/PEC_top.vhd \
			 	  $(PEC_DIR_WIN)/req_dis_logic.vhd

ip:
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/arithmetic\ IP/fifo.vhd

include $(PEC_DIR)/dual_core/Makefile
include $(PROJECT_PATH)/IP/Synopsys/Makefile
