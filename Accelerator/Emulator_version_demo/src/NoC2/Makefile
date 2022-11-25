NOC2_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2
NOC2_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/NoC2

IP_DIR_WIN=$(PROJECT_PATH_WIN)/fpga_synth/gpp

noc2_rtl: xilinx_ip mem_comp
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Acc_data_types.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Accelerator_Top.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Byte_counter_decoder.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/CMD_from_GPP.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/CMD_to_GPP.vhd
\	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Define.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Mux_Demux.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Mux_Register.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Noc_Input_Reg.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Noc_Register.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/NoC_state_machine.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Noc_Top.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Root_Memory.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Switch.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Tag_Line_Block.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/Transpose_unit.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/RM_as_generator.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/PMEM_512X28.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(NOC2_DIR_WIN)/RMEM_32KX16.vhd

xilinx_ip:
	$(V_COMP) $(IP_DIR_WIN)/gpp.ip_user_files/ipstatic/simulation/blk_mem_gen_v8_4.v
	$(V_COMP) $(NOC2_DIR_WIN)/IP/boot_memory/sim/boot_memory.v
        
include $(PROJECT_PATH)/IP/Synopsys/Makefile
