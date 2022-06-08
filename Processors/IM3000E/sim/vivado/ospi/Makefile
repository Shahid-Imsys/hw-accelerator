OSPI_DIR=$(PROJECT_PATH)/Processors/IM3000E/src/peri
OSPI_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/src/peri


all: work rtl tb elab

rtl:
	$(COMP) $(COMP_RTL_FLAGS)     \
	$(OSPI_DIR_WIN)/../gp_pkg.vhd \
	$(OSPI_DIR_WIN)/OctoSPI.vhd

tb: ospi_tb

elab:
	xelab --debug typical ospi_tb
sim:
	$(SIM) $(SIM_FLAGS) work.ospi_tb

work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Processors/IM3000E/tb/ospi_tb/Makefile
