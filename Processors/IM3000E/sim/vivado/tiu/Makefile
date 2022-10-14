TIU_DIR=$(PROJECT_PATH)/Processors/IM3000E/src/peri
TIU_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/src/peri


all: work rtl tb elab

rtl:
	$(COMP) $(COMP_RTL_FLAGS)     \
	$(TIU_DIR_WIN)/tiu.vhd

tb: tiu_block_tb

elab:
	xelab --debug typical tiu_tb
sim:
	$(SIM) $(SIM_FLAGS) work.tiu_tb

work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Processors/IM3000E/tb/tiu_block_tb/Makefile
