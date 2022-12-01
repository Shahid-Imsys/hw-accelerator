all: work  rtl tb elab

rtl: pec_rtl noc2_rtl

etb: tb elab

tb: Accelerator_sim 

elab:
	xelab --debug typical Accelerator_tb

sim:
	$(SIM) $(SIM_FLAGS) work.Accelerator_tb --autoloadwcfg
work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/testbench/Makefile
include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/Makefile
include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2/Makefile