IONOC_DIR=$(PROJECT_PATH)/Processors/IM3000E/src
IONOC_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/src


all: work rtl tb

rtl:
	$(COMP) $(COMP_RTL_FLAGS)                                 \
	$(IONOC_DIR_WIN)/gp_pkg.vhd                               \
	$(PROJECT_PATH_WIN)/Digital_core/src/ionoc.vhd            \
	$(PROJECT_PATH_WIN)/Digital_core/src/fpga_noc_adapter.vhd

tb: fpga_noc_adapter_tb

sim:
	$(SIM) $(SIM_FLAGS) work.fpga_noc_adapter_tb

work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Digital_core/tb/fpga_noc_adapter_tb/Makefile
