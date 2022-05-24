

all: work tb elab

tb:
	$(V_COMP) readmemh.v

elab:
	xelab --debug typical rom_bin_to_hex_conv
sim:
	$(SIM) $(SIM_FLAGS) work.rom_bin_to_hex_conv

work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf



