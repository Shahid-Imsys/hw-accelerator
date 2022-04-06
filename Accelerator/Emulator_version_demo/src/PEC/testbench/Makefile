PEC_TB_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/testbench
PEC_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC/testbench

cluster_tb: copy_microcode
	$(COMP) $(COMP_TB_FLAGS) $(PEC_TB_DIR_WIN)/c_tb.vhd \
			 	  $(PEC_TB_DIR_WIN)/Cluster_sim.vhd 

copy_microcode:
	cp $(PEC_TB_DIR_WIN)/Microcode_File/Pointwise_expand_with_post_processing/*  .




