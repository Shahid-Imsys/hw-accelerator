etb: tb elab

tb: NoCtoPEC_tb.vhd 

elab:
	xelab --debug typical ac_tb

sim:
	$(SIM) $(SIM_FLAGS) c_tb_behav --autoloadwcfg
work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/testbench/Makefile
include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/Makefile
include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2/Makefile