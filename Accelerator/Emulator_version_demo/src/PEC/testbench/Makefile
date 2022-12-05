PEC_TB_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/testbench
PEC_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC/testbench

cluster_sim: 
	cp $(PEC_TB_DIR_WIN)/Microcode_File/Pointwise_expand_with_post_processing/*  .
	$(COMP) $(COMP_TB_FLAGS) $(PEC_TB_DIR_WIN)/Cluster_sim.vhd

cluster_tb:
	$(COMP) $(COMP_TB_FLAGS) $(PEC_TB_DIR_WIN)/c_tb.vhd

cluster_pw_pec1_tb: cluster_tb
	cp $(PEC_TB_DIR_WIN)/Microcode_File/Pointwise_complete/*  .
	cp $(PEC_TB_DIR_WIN)/Microcode_File/Pointwise_expand_with_post_processing/*  .
	$(COMP) $(COMP_TB_FLAGS) $(PEC_TB_DIR_WIN)/Cluster_pw_pec1.vhd 
	$(COMP) $(COMP_TB_FLAGS) $(PEC_TB_DIR_WIN)/Cluster_pw_pec2.vhd

Accelerator_bypass_short:
	cp $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2/testbench/*  .
	cp $(PEC_TB_DIR_WIN)/Microcode_File/Pointwise_bypass_short/*  .
	$(COMP) $(COMP_TB_FLAGS) $(PEC_TB_DIR_WIN)/AccBypass_short_tb.vhd





