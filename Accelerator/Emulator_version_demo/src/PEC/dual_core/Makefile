DUAL_CORE_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/dual_core/
DUAL_CORE_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC/dual_core/

dual_core_rtl:
	$(COMP) $(COMP_RTL_FLAGS) $(DUAL_CORE_DIR_WIN)/pe1_mpgmfield_lib.vhd \
					$(DUAL_CORE_DIR_WIN)/pe1_mpgm.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_fgenpart.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_fgenhalf.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_fgendec.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_fgen.vhd\
				  $(DUAL_CORE_DIR_WIN)/ram64x8.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_sct.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_stack9x14.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_debug_trace.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/vetypes.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/instructiontypes.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/fpga_mem64x64.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/fpga_mem256x32.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/fpga_mem256x64.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/re.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/convcontroller.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/fftcontroller.vhd \
 				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/accumulatoreven.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/accumulatorodd.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/addressingunit.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/addmul.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/ctrlmap_acc.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/ctrlmap_alu.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/lod.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/memreg.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/ppadd.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/ppmap1.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/ppshift.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/ve_wctrlpipe.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/vearith.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/vecore.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/writebuff.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(DUAL_CORE_DIR_WIN)/pe1_alu.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/pe1_clc.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/cmdr.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/pe1_cpc.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/pe1_crb.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_dsl.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_fgen.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_gmem.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_gp_pkg.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_ios_dackgen.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_ios_dmap.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_ios_dma.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_mbm.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_mmr.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_mpll.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_mpmem_inf.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_rtc.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_rtc_iso.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_tim.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/vetypes.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/instructiontypes.vhd \
				  $(DUAL_CORE_DIR_WIN)/ve.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/pe1_acmdr.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/pe1_ampgm.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/pe1_atim.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/pe1_acore.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/FPGA_SU180_256X128X1BM1A.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/FPGA_SY180_1024X8X1CM8.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_flash_inf.vhd \
				  $(DUAL_CORE_DIR_WIN)/pe1_ios.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/pe1_core.vhd \
				  $(DUAL_CORE_DIR_WIN)/PE_pair_top.vhd
