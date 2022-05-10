RAY_DIR=$(PROJECT_PATH)/IP/RacyICS
RAY_DIR_WIN=$(PROJECT_PATH_WIN)/IP/RacyICS

BOND_PATH_WIN=$(RAY_DIR_WIN)/rilib_gf22fdx_io_EG1d80V/v1.2.2.49.01/source/behavioral/verilog
PLL_PATH_WIN=$(RAY_DIR_WIN)/ri_adpll_gf22fdx_2gmp/v1.1.9.49.01/ri_adpll_gf22fdx_2gmp/behavioral/behavioral_simple
pad_comp:
	$(V_COMP) $(BOND_PATH_WIN)/RIIO_BOND_PADS.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPO_LVT28_H.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPO_LVT28_V.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPI_LVT28_H.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPI_LVT28_V.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPIO_LVT28_H.v \
                  $(BOND_PATH_WIN)/RIIO_EG1D80V_GPIO_LVT28_V.v \
                  $(RAY_DIR_WIN)/racyic_modules/common_sync.v \
                  $(RAY_DIR_WIN)/racyic_modules/common_sync_pedge.v \
		  $(PLL_PATH_WIN)/ri_adpll_gf22fdx_2gmp_behavioral.v
