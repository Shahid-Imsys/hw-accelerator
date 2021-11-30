PEC_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC
PEC_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC

pec_rtl: 
	$(COMP) $(COMP_RTL_FLAGS) $(PEC_DIR_WIN)/cc.vhd \
			 	  $(PEC_DIR_WIN)/cluster_pkg.vhd \
			 	  $(PEC_DIR_WIN)/CMEM_32KX16.vhd \
			 	  $(PEC_DIR_WIN)/PEC_top.vhd \
			 	  $(PEC_DIR_WIN)/req_dis_logic_16.vhd
			 	 




include $(PEC_DIR)/dual_core/Makefile
