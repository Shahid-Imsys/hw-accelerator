NOC2_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2
NOC2_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/NoC2

noc2_rtl:
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/cluster_pkg.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Acc_data_types.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Accelerator_Top.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Byte_counter_decoder.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/cluster_controller.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/CMD_from_GPP.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/CMD_to_GPP.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/CMEM_32KX16.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Define.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Mux_Demux.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Mux_Register.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Noc_Input_Reg.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Noc_Register.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/NoC_state_machine.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Noc_Top.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Root_Memory.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Switch.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Tag_Line_Block.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Top.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Transpose_unit.vhd
