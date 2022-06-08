CHIP_DIR=$(PROJECT_PATH)/Digital_chip/src
CHIP_DIR_WIN=$(PROJECT_PATH_WIN)/Digital_chip/src

BOND_PATH_WIN=$(CHIP_DIR_WIN)/rilib_gf22fdx_io_EG1d80V/v1.2.2.49.01/source/behavioral/verilog
PLL_PATH_WIN=$(CHIP_DIR_WIN)/ri_adpll_gf22fdx_2gmp/v1.1.9.49.01/ri_adpll_gf22fdx_2gmp/behavioral/behavioral_simple

digital_chip_rtl: digital_top_rtl pad_comp
	$(COMP) $(COMP_RTL_FLAGS) $(CHIP_DIR_WIN)/pad_instance_package.vhd \
                                  $(CHIP_DIR_WIN)/inoutput_pad.vhd \
                                  $(CHIP_DIR_WIN)/input_pad.vhd \
                                  $(CHIP_DIR_WIN)/output_pad.vhd \
				  $(CHIP_DIR_WIN)/digital_chip.vhd

#pad_comp:
#	$(V_COMP) $(BOND_PATH_WIN)/RIIO_BOND_PADS.v \
#                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPO_LVT28_H.v \
#                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPO_LVT28_V.v \
#                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPI_LVT28_H.v \
#                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPI_LVT28_V.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPIO_LVT28_H.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPIO_LVT28_V.v \
                  $(CHIP_DIR_WIN)/racyic_modules/common_sync.v \
                  $(CHIP_DIR_WIN)/racyic_modules/common_sync_pedge.v \
		  $(PLL_PATH_WIN)/ri_adpll_gf22fdx_2gmp_behavioral.v

include $(PROJECT_PATH)/Digital_top/src/Makefile
include $(PROJECT_PATH)/IP/RacyICS/Makefile
