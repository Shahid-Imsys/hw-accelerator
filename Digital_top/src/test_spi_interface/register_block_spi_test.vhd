library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_spi_test.all;

entity register_block_spi_test is

    port (
          clk   : in std_ulogic;
          rst_n : in std_ulogic;

          -- Registerfields
          version_analog : in  version_analog_t;
          version_digital : in  version_digital_t;
          mclkout_ds : out mclkout_ds_t;
          mclkout_sr : out mclkout_sr_t;
          mclkout_co : out mclkout_co_t;
          mclkout_odp : out mclkout_odp_t;
          mclkout_odn : out mclkout_odn_t;
          msdout_ds : out msdout_ds_t;
          msdout_sr : out msdout_sr_t;
          msdout_co : out msdout_co_t;
          msdout_odp : out msdout_odp_t;
          msdout_odn : out msdout_odn_t;
          utx_ds : out utx_ds_t;
          utx_sr : out utx_sr_t;
          utx_co : out utx_co_t;
          utx_odp : out utx_odp_t;
          utx_odn : out utx_odn_t;
          mirqout_ds : out mirqout_ds_t;
          mirqout_sr : out mirqout_sr_t;
          mirqout_co : out mirqout_co_t;
          mirqout_odp : out mirqout_odp_t;
          mirqout_odn : out mirqout_odn_t;
          msdin_ste : out msdin_ste_t;
          msdin_pd : out msdin_pd_t;
          msdin_pu : out msdin_pu_t;
          mirq0_ste : out mirq0_ste_t;
          mirq0_pd : out mirq0_pd_t;
          mirq0_pu : out mirq0_pu_t;
          mirq1_ste : out mirq1_ste_t;
          mirq1_pd : out mirq1_pd_t;
          mirq1_pu : out mirq1_pu_t;
          urx_ste : out urx_ste_t;
          urx_pd : out urx_pd_t;
          urx_pu : out urx_pu_t;
          emem_d0_out_ds : out emem_d0_out_ds_t;
          emem_d0_out_sr : out emem_d0_out_sr_t;
          emem_d0_out_co : out emem_d0_out_co_t;
          emem_d0_out_odp : out emem_d0_out_odp_t;
          emem_d0_out_odn : out emem_d0_out_odn_t;
          emem_d0_in_ste : out emem_d0_in_ste_t;
          emem_d0_in_pd : out emem_d0_in_pd_t;
          emem_d0_in_pu : out emem_d0_in_pu_t;
          emem_d1_out_ds : out emem_d1_out_ds_t;
          emem_d1_out_sr : out emem_d1_out_sr_t;
          emem_d1_out_co : out emem_d1_out_co_t;
          emem_d1_out_odp : out emem_d1_out_odp_t;
          emem_d1_out_odn : out emem_d1_out_odn_t;
          emem_d1_in_ste : out emem_d1_in_ste_t;
          emem_d1_in_pd : out emem_d1_in_pd_t;
          emem_d1_in_pu : out emem_d1_in_pu_t;
          emem_d2_out_ds : out emem_d2_out_ds_t;
          emem_d2_out_sr : out emem_d2_out_sr_t;
          emem_d2_out_co : out emem_d2_out_co_t;
          emem_d2_out_odp : out emem_d2_out_odp_t;
          emem_d2_out_odn : out emem_d2_out_odn_t;
          emem_d2_in_ste : out emem_d2_in_ste_t;
          emem_d2_in_pd : out emem_d2_in_pd_t;
          emem_d2_in_pu : out emem_d2_in_pu_t;
          emem_d3_out_ds : out emem_d3_out_ds_t;
          emem_d3_out_sr : out emem_d3_out_sr_t;
          emem_d3_out_co : out emem_d3_out_co_t;
          emem_d3_out_odp : out emem_d3_out_odp_t;
          emem_d3_out_odn : out emem_d3_out_odn_t;
          emem_d3_in_ste : out emem_d3_in_ste_t;
          emem_d3_in_pd : out emem_d3_in_pd_t;
          emem_d3_in_pu : out emem_d3_in_pu_t;
          emem_d4_out_ds : out emem_d4_out_ds_t;
          emem_d4_out_sr : out emem_d4_out_sr_t;
          emem_d4_out_co : out emem_d4_out_co_t;
          emem_d4_out_odp : out emem_d4_out_odp_t;
          emem_d4_out_odn : out emem_d4_out_odn_t;
          emem_d4_in_ste : out emem_d4_in_ste_t;
          emem_d4_in_pd : out emem_d4_in_pd_t;
          emem_d4_in_pu : out emem_d4_in_pu_t;
          emem_d5_out_ds : out emem_d5_out_ds_t;
          emem_d5_out_sr : out emem_d5_out_sr_t;
          emem_d5_out_co : out emem_d5_out_co_t;
          emem_d5_out_odp : out emem_d5_out_odp_t;
          emem_d5_out_odn : out emem_d5_out_odn_t;
          emem_d5_in_ste : out emem_d5_in_ste_t;
          emem_d5_in_pd : out emem_d5_in_pd_t;
          emem_d5_in_pu : out emem_d5_in_pu_t;
          emem_d6_out_ds : out emem_d6_out_ds_t;
          emem_d6_out_sr : out emem_d6_out_sr_t;
          emem_d6_out_co : out emem_d6_out_co_t;
          emem_d6_out_odp : out emem_d6_out_odp_t;
          emem_d6_out_odn : out emem_d6_out_odn_t;
          emem_d6_in_ste : out emem_d6_in_ste_t;
          emem_d6_in_pd : out emem_d6_in_pd_t;
          emem_d6_in_pu : out emem_d6_in_pu_t;
          emem_d7_out_ds : out emem_d7_out_ds_t;
          emem_d7_out_sr : out emem_d7_out_sr_t;
          emem_d7_out_co : out emem_d7_out_co_t;
          emem_d7_out_odp : out emem_d7_out_odp_t;
          emem_d7_out_odn : out emem_d7_out_odn_t;
          emem_d7_in_ste : out emem_d7_in_ste_t;
          emem_d7_in_pd : out emem_d7_in_pd_t;
          emem_d7_in_pu : out emem_d7_in_pu_t;
          emem_clk_ds : out emem_clk_ds_t;
          emem_clk_sr : out emem_clk_sr_t;
          emem_clk_co : out emem_clk_co_t;
          emem_clk_odp : out emem_clk_odp_t;
          emem_clk_odn : out emem_clk_odn_t;
          emem_rwds_out_ds : out emem_rwds_out_ds_t;
          emem_rwds_out_sr : out emem_rwds_out_sr_t;
          emem_rwds_out_co : out emem_rwds_out_co_t;
          emem_rwds_out_odp : out emem_rwds_out_odp_t;
          emem_rwds_out_odn : out emem_rwds_out_odn_t;
          emem_rwds_in_ste : out emem_rwds_in_ste_t;
          emem_rwds_in_pd : out emem_rwds_in_pd_t;
          emem_rwds_in_pu : out emem_rwds_in_pu_t;
          emem_cs_n_ds : out emem_cs_n_ds_t;
          emem_cs_n_sr : out emem_cs_n_sr_t;
          emem_cs_n_co : out emem_cs_n_co_t;
          emem_cs_n_odp : out emem_cs_n_odp_t;
          emem_cs_n_odn : out emem_cs_n_odn_t;
          emem_rst_n_ds : out emem_rst_n_ds_t;
          emem_rst_n_sr : out emem_rst_n_sr_t;
          emem_rst_n_co : out emem_rst_n_co_t;
          emem_rst_n_odp : out emem_rst_n_odp_t;
          emem_rst_n_odn : out emem_rst_n_odn_t;
          aout0_ds : out aout0_ds_t;
          aout0_sr : out aout0_sr_t;
          aout0_co : out aout0_co_t;
          aout0_odp : out aout0_odp_t;
          aout0_odn : out aout0_odn_t;
          aout1_ds : out aout1_ds_t;
          aout1_sr : out aout1_sr_t;
          aout1_co : out aout1_co_t;
          aout1_odp : out aout1_odp_t;
          aout1_odn : out aout1_odn_t;
          ach0_ste : out ach0_ste_t;
          ach0_pd : out ach0_pd_t;
          ach0_pu : out ach0_pu_t;
          enet_mdio_out_ds : out enet_mdio_out_ds_t;
          enet_mdio_out_sr : out enet_mdio_out_sr_t;
          enet_mdio_out_co : out enet_mdio_out_co_t;
          enet_mdio_out_odp : out enet_mdio_out_odp_t;
          enet_mdio_out_odn : out enet_mdio_out_odn_t;
          enet_mdio_in_ste : out enet_mdio_in_ste_t;
          enet_mdio_in_pd : out enet_mdio_in_pd_t;
          enet_mdio_in_pu : out enet_mdio_in_pu_t;
          enet_mdc_ds : out enet_mdc_ds_t;
          enet_mdc_sr : out enet_mdc_sr_t;
          enet_mdc_co : out enet_mdc_co_t;
          enet_mdc_odp : out enet_mdc_odp_t;
          enet_mdc_odn : out enet_mdc_odn_t;
          enet_txer_ds : out enet_txer_ds_t;
          enet_txer_sr : out enet_txer_sr_t;
          enet_txer_co : out enet_txer_co_t;
          enet_txer_odp : out enet_txer_odp_t;
          enet_txer_odn : out enet_txer_odn_t;
          enet_txd0_ds : out enet_txd0_ds_t;
          enet_txd0_sr : out enet_txd0_sr_t;
          enet_txd0_co : out enet_txd0_co_t;
          enet_txd0_odp : out enet_txd0_odp_t;
          enet_txd0_odn : out enet_txd0_odn_t;
          enet_txd1_ds : out enet_txd1_ds_t;
          enet_txd1_sr : out enet_txd1_sr_t;
          enet_txd1_co : out enet_txd1_co_t;
          enet_txd1_odp : out enet_txd1_odp_t;
          enet_txd1_odn : out enet_txd1_odn_t;
          enet_txen_ds : out enet_txen_ds_t;
          enet_txen_sr : out enet_txen_sr_t;
          enet_txen_co : out enet_txen_co_t;
          enet_txen_odp : out enet_txen_odp_t;
          enet_txen_odn : out enet_txen_odn_t;
          enet_clk_ste : out enet_clk_ste_t;
          enet_clk_pd : out enet_clk_pd_t;
          enet_clk_pu : out enet_clk_pu_t;
          enet_rxdv_ste : out enet_rxdv_ste_t;
          enet_rxdv_pd : out enet_rxdv_pd_t;
          enet_rxdv_pu : out enet_rxdv_pu_t;
          enet_rxd0_ste : out enet_rxd0_ste_t;
          enet_rxd0_pd : out enet_rxd0_pd_t;
          enet_rxd0_pu : out enet_rxd0_pu_t;
          enet_rxd1_ste : out enet_rxd1_ste_t;
          enet_rxd1_pd : out enet_rxd1_pd_t;
          enet_rxd1_pu : out enet_rxd1_pu_t;
          enet_rxer_ste : out enet_rxer_ste_t;
          enet_rxer_pd : out enet_rxer_pd_t;
          enet_rxer_pu : out enet_rxer_pu_t;
          spi_sclk_ste : out spi_sclk_ste_t;
          spi_sclk_pd : out spi_sclk_pd_t;
          spi_sclk_pu : out spi_sclk_pu_t;
          spi_cs_n_ste : out spi_cs_n_ste_t;
          spi_cs_n_pd : out spi_cs_n_pd_t;
          spi_cs_n_pu : out spi_cs_n_pu_t;
          spi_mosi_ste : out spi_mosi_ste_t;
          spi_mosi_pd : out spi_mosi_pd_t;
          spi_mosi_pu : out spi_mosi_pu_t;
          spi_miso_ds : out spi_miso_ds_t;
          spi_miso_sr : out spi_miso_sr_t;
          spi_miso_co : out spi_miso_co_t;
          spi_miso_odp : out spi_miso_odp_t;
          spi_miso_odn : out spi_miso_odn_t;
          pll_ref_clk_ste : out pll_ref_clk_ste_t;
          pll_ref_clk_pd : out pll_ref_clk_pd_t;
          pll_ref_clk_pu : out pll_ref_clk_pu_t;
          pa0_sin_out_ds : out pa0_sin_out_ds_t;
          pa0_sin_out_sr : out pa0_sin_out_sr_t;
          pa0_sin_out_co : out pa0_sin_out_co_t;
          pa0_sin_out_odp : out pa0_sin_out_odp_t;
          pa0_sin_out_odn : out pa0_sin_out_odn_t;
          pa0_sin_in_ste : out pa0_sin_in_ste_t;
          pa0_sin_in_pd : out pa0_sin_in_pd_t;
          pa0_sin_in_pu : out pa0_sin_in_pu_t;
          pa5_cs_n_out_ds : out pa5_cs_n_out_ds_t;
          pa5_cs_n_out_sr : out pa5_cs_n_out_sr_t;
          pa5_cs_n_out_co : out pa5_cs_n_out_co_t;
          pa5_cs_n_out_odp : out pa5_cs_n_out_odp_t;
          pa5_cs_n_out_odn : out pa5_cs_n_out_odn_t;
          pa5_cs_n_in_ste : out pa5_cs_n_in_ste_t;
          pa5_cs_n_in_pd : out pa5_cs_n_in_pd_t;
          pa5_cs_n_in_pu : out pa5_cs_n_in_pu_t;
          pa6_sck_out_ds : out pa6_sck_out_ds_t;
          pa6_sck_out_sr : out pa6_sck_out_sr_t;
          pa6_sck_out_co : out pa6_sck_out_co_t;
          pa6_sck_out_odp : out pa6_sck_out_odp_t;
          pa6_sck_out_odn : out pa6_sck_out_odn_t;
          pa6_sck_in_ste : out pa6_sck_in_ste_t;
          pa6_sck_in_pd : out pa6_sck_in_pd_t;
          pa6_sck_in_pu : out pa6_sck_in_pu_t;
          pa7_sout_out_ds : out pa7_sout_out_ds_t;
          pa7_sout_out_sr : out pa7_sout_out_sr_t;
          pa7_sout_out_co : out pa7_sout_out_co_t;
          pa7_sout_out_odp : out pa7_sout_out_odp_t;
          pa7_sout_out_odn : out pa7_sout_out_odn_t;
          pa7_sout_in_ste : out pa7_sout_in_ste_t;
          pa7_sout_in_pd : out pa7_sout_in_pd_t;
          pa7_sout_in_pu : out pa7_sout_in_pu_t;
          pg0_out_ds : out pg0_out_ds_t;
          pg0_out_sr : out pg0_out_sr_t;
          pg0_out_co : out pg0_out_co_t;
          pg0_out_odp : out pg0_out_odp_t;
          pg0_out_odn : out pg0_out_odn_t;
          pg0_in_ste : out pg0_in_ste_t;
          pg0_in_pd : out pg0_in_pd_t;
          pg0_in_pu : out pg0_in_pu_t;
          pg1_out_ds : out pg1_out_ds_t;
          pg1_out_sr : out pg1_out_sr_t;
          pg1_out_co : out pg1_out_co_t;
          pg1_out_odp : out pg1_out_odp_t;
          pg1_out_odn : out pg1_out_odn_t;
          pg1_in_ste : out pg1_in_ste_t;
          pg1_in_pd : out pg1_in_pd_t;
          pg1_in_pu : out pg1_in_pu_t;
          pg2_out_ds : out pg2_out_ds_t;
          pg2_out_sr : out pg2_out_sr_t;
          pg2_out_co : out pg2_out_co_t;
          pg2_out_odp : out pg2_out_odp_t;
          pg2_out_odn : out pg2_out_odn_t;
          pg2_in_ste : out pg2_in_ste_t;
          pg2_in_pd : out pg2_in_pd_t;
          pg2_in_pu : out pg2_in_pu_t;
          pg3_out_ds : out pg3_out_ds_t;
          pg3_out_sr : out pg3_out_sr_t;
          pg3_out_co : out pg3_out_co_t;
          pg3_out_odp : out pg3_out_odp_t;
          pg3_out_odn : out pg3_out_odn_t;
          pg3_in_ste : out pg3_in_ste_t;
          pg3_in_pd : out pg3_in_pd_t;
          pg3_in_pu : out pg3_in_pu_t;
          pg4_out_ds : out pg4_out_ds_t;
          pg4_out_sr : out pg4_out_sr_t;
          pg4_out_co : out pg4_out_co_t;
          pg4_out_odp : out pg4_out_odp_t;
          pg4_out_odn : out pg4_out_odn_t;
          pg4_in_ste : out pg4_in_ste_t;
          pg4_in_pd : out pg4_in_pd_t;
          pg4_in_pu : out pg4_in_pu_t;
          pg5_out_ds : out pg5_out_ds_t;
          pg5_out_sr : out pg5_out_sr_t;
          pg5_out_co : out pg5_out_co_t;
          pg5_out_odp : out pg5_out_odp_t;
          pg5_out_odn : out pg5_out_odn_t;
          pg5_in_ste : out pg5_in_ste_t;
          pg5_in_pd : out pg5_in_pd_t;
          pg5_in_pu : out pg5_in_pu_t;
          pg6_out_ds : out pg6_out_ds_t;
          pg6_out_sr : out pg6_out_sr_t;
          pg6_out_co : out pg6_out_co_t;
          pg6_out_odp : out pg6_out_odp_t;
          pg6_out_odn : out pg6_out_odn_t;
          pg6_in_ste : out pg6_in_ste_t;
          pg6_in_pd : out pg6_in_pd_t;
          pg6_in_pu : out pg6_in_pu_t;
          pg7_out_ds : out pg7_out_ds_t;
          pg7_out_sr : out pg7_out_sr_t;
          pg7_out_co : out pg7_out_co_t;
          pg7_out_odp : out pg7_out_odp_t;
          pg7_out_odn : out pg7_out_odn_t;
          pg7_in_ste : out pg7_in_ste_t;
          pg7_in_pd : out pg7_in_pd_t;
          pg7_in_pu : out pg7_in_pu_t;
          mtest_ste : out mtest_ste_t;
          mtest_pd : out mtest_pd_t;
          mtest_pu : out mtest_pu_t;
          mwake_ste : out mwake_ste_t;
          mwake_pd : out mwake_pd_t;
          mwake_pu : out mwake_pu_t;
          mrxout_out_ds : out mrxout_out_ds_t;
          mrxout_out_sr : out mrxout_out_sr_t;
          mrxout_out_co : out mrxout_out_co_t;
          mrxout_out_odp : out mrxout_out_odp_t;
          mrxout_out_odn : out mrxout_out_odn_t;
          pll_1_main_div_n1 : out pll_1_main_div_n1_t;
          pll_1_main_div_n2 : out pll_1_main_div_n2_t;
          pll_1_main_div_n3 : out pll_1_main_div_n3_t;
          pll_1_main_div_n4 : out pll_1_main_div_n4_t;
          pll_2_open_loop : out pll_2_open_loop_t;
          pll_2_out_div_sel : out pll_2_out_div_sel_t;
          pll_2_ci : out pll_2_ci_t;
          pll_cp_cp : out pll_cp_cp_t;
          pll_ft_ft : out pll_ft_ft_t;
          pll_3_divcore_sel : out pll_3_divcore_sel_t;
          pll_3_coarse : out pll_3_coarse_t;
          pll_4_auto_coarsetune : out pll_4_auto_coarsetune_t;
          pll_4_enforce_lock : out pll_4_enforce_lock_t;
          pll_4_pfd_select : out pll_4_pfd_select_t;
          pll_4_lock_window_sel : out pll_4_lock_window_sel_t;
          pll_4_div_core_mux_sel : out pll_4_div_core_mux_sel_t;
          pll_4_filter_shift : out pll_4_filter_shift_t;
          pll_4_en_fast_lock : out pll_4_en_fast_lock_t;
          pll_5_sar_limit : out pll_5_sar_limit_t;
          pll_5_set_op_lock : out pll_5_set_op_lock_t;
          pll_5_disable_lock : out pll_5_disable_lock_t;
          pll_5_ref_bypass : out pll_5_ref_bypass_t;
          pll_5_ct_compensation : out pll_5_ct_compensation_t;
          adpll_status0_adpll_status_0 : in  adpll_status0_adpll_status_0_t;
          adpll_status1_adpll_status_1 : in  adpll_status1_adpll_status_1_t;
          adpll_status2_adpll_status_2 : in  adpll_status2_adpll_status_2_t;
          io_dack0_n_ste : out io_dack0_n_ste_t;
          io_dack0_n_pd : out io_dack0_n_pd_t;
          io_dack0_n_pu : out io_dack0_n_pu_t;
          io_dreq0_n_ds : out io_dreq0_n_ds_t;
          io_dreq0_n_sr : out io_dreq0_n_sr_t;
          io_dreq0_n_co : out io_dreq0_n_co_t;
          io_dreq0_n_odp : out io_dreq0_n_odp_t;
          io_dreq0_n_odn : out io_dreq0_n_odn_t;
          io_dack1_n_ste : out io_dack1_n_ste_t;
          io_dack1_n_pd : out io_dack1_n_pd_t;
          io_dack1_n_pu : out io_dack1_n_pu_t;
          io_dreq1_n_ds : out io_dreq1_n_ds_t;
          io_dreq1_n_sr : out io_dreq1_n_sr_t;
          io_dreq1_n_co : out io_dreq1_n_co_t;
          io_dreq1_n_odp : out io_dreq1_n_odp_t;
          io_dreq1_n_odn : out io_dreq1_n_odn_t;
          io_dack2_n_ste : out io_dack2_n_ste_t;
          io_dack2_n_pd : out io_dack2_n_pd_t;
          io_dack2_n_pu : out io_dack2_n_pu_t;
          io_dreq2_n_ds : out io_dreq2_n_ds_t;
          io_dreq2_n_sr : out io_dreq2_n_sr_t;
          io_dreq2_n_co : out io_dreq2_n_co_t;
          io_dreq2_n_odp : out io_dreq2_n_odp_t;
          io_dreq2_n_odn : out io_dreq2_n_odn_t;
          io_dack3_n_ste : out io_dack3_n_ste_t;
          io_dack3_n_pd : out io_dack3_n_pd_t;
          io_dack3_n_pu : out io_dack3_n_pu_t;
          io_dreq3_n_ds : out io_dreq3_n_ds_t;
          io_dreq3_n_sr : out io_dreq3_n_sr_t;
          io_dreq3_n_co : out io_dreq3_n_co_t;
          io_dreq3_n_odp : out io_dreq3_n_odp_t;
          io_dreq3_n_odn : out io_dreq3_n_odn_t;
          io_d0_out_ds : out io_d0_out_ds_t;
          io_d0_out_sr : out io_d0_out_sr_t;
          io_d0_out_co : out io_d0_out_co_t;
          io_d0_out_odp : out io_d0_out_odp_t;
          io_d0_out_odn : out io_d0_out_odn_t;
          io_d0_in_ste : out io_d0_in_ste_t;
          io_d0_in_pd : out io_d0_in_pd_t;
          io_d0_in_pu : out io_d0_in_pu_t;
          io_d1_out_ds : out io_d1_out_ds_t;
          io_d1_out_sr : out io_d1_out_sr_t;
          io_d1_out_co : out io_d1_out_co_t;
          io_d1_out_odp : out io_d1_out_odp_t;
          io_d1_out_odn : out io_d1_out_odn_t;
          io_d1_in_ste : out io_d1_in_ste_t;
          io_d1_in_pd : out io_d1_in_pd_t;
          io_d1_in_pu : out io_d1_in_pu_t;
          io_d2_out_ds : out io_d2_out_ds_t;
          io_d2_out_sr : out io_d2_out_sr_t;
          io_d2_out_co : out io_d2_out_co_t;
          io_d2_out_odp : out io_d2_out_odp_t;
          io_d2_out_odn : out io_d2_out_odn_t;
          io_d2_in_ste : out io_d2_in_ste_t;
          io_d2_in_pd : out io_d2_in_pd_t;
          io_d2_in_pu : out io_d2_in_pu_t;
          io_d3_out_ds : out io_d3_out_ds_t;
          io_d3_out_sr : out io_d3_out_sr_t;
          io_d3_out_co : out io_d3_out_co_t;
          io_d3_out_odp : out io_d3_out_odp_t;
          io_d3_out_odn : out io_d3_out_odn_t;
          io_d3_in_ste : out io_d3_in_ste_t;
          io_d3_in_pd : out io_d3_in_pd_t;
          io_d3_in_pu : out io_d3_in_pu_t;
          io_d4_out_ds : out io_d4_out_ds_t;
          io_d4_out_sr : out io_d4_out_sr_t;
          io_d4_out_co : out io_d4_out_co_t;
          io_d4_out_odp : out io_d4_out_odp_t;
          io_d4_out_odn : out io_d4_out_odn_t;
          io_d4_in_ste : out io_d4_in_ste_t;
          io_d4_in_pd : out io_d4_in_pd_t;
          io_d4_in_pu : out io_d4_in_pu_t;
          io_d5_out_ds : out io_d5_out_ds_t;
          io_d5_out_sr : out io_d5_out_sr_t;
          io_d5_out_co : out io_d5_out_co_t;
          io_d5_out_odp : out io_d5_out_odp_t;
          io_d5_out_odn : out io_d5_out_odn_t;
          io_d5_in_ste : out io_d5_in_ste_t;
          io_d5_in_pd : out io_d5_in_pd_t;
          io_d5_in_pu : out io_d5_in_pu_t;
          io_d6_out_ds : out io_d6_out_ds_t;
          io_d6_out_sr : out io_d6_out_sr_t;
          io_d6_out_co : out io_d6_out_co_t;
          io_d6_out_odp : out io_d6_out_odp_t;
          io_d6_out_odn : out io_d6_out_odn_t;
          io_d6_in_ste : out io_d6_in_ste_t;
          io_d6_in_pd : out io_d6_in_pd_t;
          io_d6_in_pu : out io_d6_in_pu_t;
          io_d7_out_ds : out io_d7_out_ds_t;
          io_d7_out_sr : out io_d7_out_sr_t;
          io_d7_out_co : out io_d7_out_co_t;
          io_d7_out_odp : out io_d7_out_odp_t;
          io_d7_out_odn : out io_d7_out_odn_t;
          io_d7_in_ste : out io_d7_in_ste_t;
          io_d7_in_pd : out io_d7_in_pd_t;
          io_d7_in_pu : out io_d7_in_pu_t;
          io_ldout_n_ds : out io_ldout_n_ds_t;
          io_ldout_n_sr : out io_ldout_n_sr_t;
          io_ldout_n_co : out io_ldout_n_co_t;
          io_ldout_n_odp : out io_ldout_n_odp_t;
          io_ldout_n_odn : out io_ldout_n_odn_t;
          io_next_n_ds : out io_next_n_ds_t;
          io_next_n_sr : out io_next_n_sr_t;
          io_next_n_co : out io_next_n_co_t;
          io_next_n_odp : out io_next_n_odp_t;
          io_next_n_odn : out io_next_n_odn_t;
          io_clk_ds : out io_clk_ds_t;
          io_clk_sr : out io_clk_sr_t;
          io_clk_co : out io_clk_co_t;
          io_clk_odp : out io_clk_odp_t;
          io_clk_odn : out io_clk_odn_t;
          io_ioa_n_ds : out io_ioa_n_ds_t;
          io_ioa_n_sr : out io_ioa_n_sr_t;
          io_ioa_n_co : out io_ioa_n_co_t;
          io_ioa_n_odp : out io_ioa_n_odp_t;
          io_ioa_n_odn : out io_ioa_n_odn_t;
          mrxout_in_ste : out mrxout_in_ste_t;
          mrxout_in_pd : out mrxout_in_pd_t;
          mrxout_in_pu : out mrxout_in_pu_t;


          -- SPI Interface
          write_cmd : in  std_ulogic;
          enable    : in  std_ulogic;
          address   : in  std_ulogic_vector(6 downto 0);
          data_in   : in  std_ulogic_vector(7 downto 0);
          data_out  : out std_ulogic_vector(7 downto 0)
    );

end register_block_spi_test;

architecture rtl of register_block_spi_test  is

    signal s_version_analog : version_analog_t;
    signal s_version_digital : version_digital_t;
    signal s_mclkout_ds : mclkout_ds_t;
    signal s_mclkout_sr : mclkout_sr_t;
    signal s_mclkout_co : mclkout_co_t;
    signal s_mclkout_odp : mclkout_odp_t;
    signal s_mclkout_odn : mclkout_odn_t;
    signal s_msdout_ds : msdout_ds_t;
    signal s_msdout_sr : msdout_sr_t;
    signal s_msdout_co : msdout_co_t;
    signal s_msdout_odp : msdout_odp_t;
    signal s_msdout_odn : msdout_odn_t;
    signal s_utx_ds : utx_ds_t;
    signal s_utx_sr : utx_sr_t;
    signal s_utx_co : utx_co_t;
    signal s_utx_odp : utx_odp_t;
    signal s_utx_odn : utx_odn_t;
    signal s_mirqout_ds : mirqout_ds_t;
    signal s_mirqout_sr : mirqout_sr_t;
    signal s_mirqout_co : mirqout_co_t;
    signal s_mirqout_odp : mirqout_odp_t;
    signal s_mirqout_odn : mirqout_odn_t;
    signal s_msdin_ste : msdin_ste_t;
    signal s_msdin_pd : msdin_pd_t;
    signal s_msdin_pu : msdin_pu_t;
    signal s_mirq0_ste : mirq0_ste_t;
    signal s_mirq0_pd : mirq0_pd_t;
    signal s_mirq0_pu : mirq0_pu_t;
    signal s_mirq1_ste : mirq1_ste_t;
    signal s_mirq1_pd : mirq1_pd_t;
    signal s_mirq1_pu : mirq1_pu_t;
    signal s_urx_ste : urx_ste_t;
    signal s_urx_pd : urx_pd_t;
    signal s_urx_pu : urx_pu_t;
    signal s_emem_d0_out_ds : emem_d0_out_ds_t;
    signal s_emem_d0_out_sr : emem_d0_out_sr_t;
    signal s_emem_d0_out_co : emem_d0_out_co_t;
    signal s_emem_d0_out_odp : emem_d0_out_odp_t;
    signal s_emem_d0_out_odn : emem_d0_out_odn_t;
    signal s_emem_d0_in_ste : emem_d0_in_ste_t;
    signal s_emem_d0_in_pd : emem_d0_in_pd_t;
    signal s_emem_d0_in_pu : emem_d0_in_pu_t;
    signal s_emem_d1_out_ds : emem_d1_out_ds_t;
    signal s_emem_d1_out_sr : emem_d1_out_sr_t;
    signal s_emem_d1_out_co : emem_d1_out_co_t;
    signal s_emem_d1_out_odp : emem_d1_out_odp_t;
    signal s_emem_d1_out_odn : emem_d1_out_odn_t;
    signal s_emem_d1_in_ste : emem_d1_in_ste_t;
    signal s_emem_d1_in_pd : emem_d1_in_pd_t;
    signal s_emem_d1_in_pu : emem_d1_in_pu_t;
    signal s_emem_d2_out_ds : emem_d2_out_ds_t;
    signal s_emem_d2_out_sr : emem_d2_out_sr_t;
    signal s_emem_d2_out_co : emem_d2_out_co_t;
    signal s_emem_d2_out_odp : emem_d2_out_odp_t;
    signal s_emem_d2_out_odn : emem_d2_out_odn_t;
    signal s_emem_d2_in_ste : emem_d2_in_ste_t;
    signal s_emem_d2_in_pd : emem_d2_in_pd_t;
    signal s_emem_d2_in_pu : emem_d2_in_pu_t;
    signal s_emem_d3_out_ds : emem_d3_out_ds_t;
    signal s_emem_d3_out_sr : emem_d3_out_sr_t;
    signal s_emem_d3_out_co : emem_d3_out_co_t;
    signal s_emem_d3_out_odp : emem_d3_out_odp_t;
    signal s_emem_d3_out_odn : emem_d3_out_odn_t;
    signal s_emem_d3_in_ste : emem_d3_in_ste_t;
    signal s_emem_d3_in_pd : emem_d3_in_pd_t;
    signal s_emem_d3_in_pu : emem_d3_in_pu_t;
    signal s_emem_d4_out_ds : emem_d4_out_ds_t;
    signal s_emem_d4_out_sr : emem_d4_out_sr_t;
    signal s_emem_d4_out_co : emem_d4_out_co_t;
    signal s_emem_d4_out_odp : emem_d4_out_odp_t;
    signal s_emem_d4_out_odn : emem_d4_out_odn_t;
    signal s_emem_d4_in_ste : emem_d4_in_ste_t;
    signal s_emem_d4_in_pd : emem_d4_in_pd_t;
    signal s_emem_d4_in_pu : emem_d4_in_pu_t;
    signal s_emem_d5_out_ds : emem_d5_out_ds_t;
    signal s_emem_d5_out_sr : emem_d5_out_sr_t;
    signal s_emem_d5_out_co : emem_d5_out_co_t;
    signal s_emem_d5_out_odp : emem_d5_out_odp_t;
    signal s_emem_d5_out_odn : emem_d5_out_odn_t;
    signal s_emem_d5_in_ste : emem_d5_in_ste_t;
    signal s_emem_d5_in_pd : emem_d5_in_pd_t;
    signal s_emem_d5_in_pu : emem_d5_in_pu_t;
    signal s_emem_d6_out_ds : emem_d6_out_ds_t;
    signal s_emem_d6_out_sr : emem_d6_out_sr_t;
    signal s_emem_d6_out_co : emem_d6_out_co_t;
    signal s_emem_d6_out_odp : emem_d6_out_odp_t;
    signal s_emem_d6_out_odn : emem_d6_out_odn_t;
    signal s_emem_d6_in_ste : emem_d6_in_ste_t;
    signal s_emem_d6_in_pd : emem_d6_in_pd_t;
    signal s_emem_d6_in_pu : emem_d6_in_pu_t;
    signal s_emem_d7_out_ds : emem_d7_out_ds_t;
    signal s_emem_d7_out_sr : emem_d7_out_sr_t;
    signal s_emem_d7_out_co : emem_d7_out_co_t;
    signal s_emem_d7_out_odp : emem_d7_out_odp_t;
    signal s_emem_d7_out_odn : emem_d7_out_odn_t;
    signal s_emem_d7_in_ste : emem_d7_in_ste_t;
    signal s_emem_d7_in_pd : emem_d7_in_pd_t;
    signal s_emem_d7_in_pu : emem_d7_in_pu_t;
    signal s_emem_clk_ds : emem_clk_ds_t;
    signal s_emem_clk_sr : emem_clk_sr_t;
    signal s_emem_clk_co : emem_clk_co_t;
    signal s_emem_clk_odp : emem_clk_odp_t;
    signal s_emem_clk_odn : emem_clk_odn_t;
    signal s_emem_rwds_out_ds : emem_rwds_out_ds_t;
    signal s_emem_rwds_out_sr : emem_rwds_out_sr_t;
    signal s_emem_rwds_out_co : emem_rwds_out_co_t;
    signal s_emem_rwds_out_odp : emem_rwds_out_odp_t;
    signal s_emem_rwds_out_odn : emem_rwds_out_odn_t;
    signal s_emem_rwds_in_ste : emem_rwds_in_ste_t;
    signal s_emem_rwds_in_pd : emem_rwds_in_pd_t;
    signal s_emem_rwds_in_pu : emem_rwds_in_pu_t;
    signal s_emem_cs_n_ds : emem_cs_n_ds_t;
    signal s_emem_cs_n_sr : emem_cs_n_sr_t;
    signal s_emem_cs_n_co : emem_cs_n_co_t;
    signal s_emem_cs_n_odp : emem_cs_n_odp_t;
    signal s_emem_cs_n_odn : emem_cs_n_odn_t;
    signal s_emem_rst_n_ds : emem_rst_n_ds_t;
    signal s_emem_rst_n_sr : emem_rst_n_sr_t;
    signal s_emem_rst_n_co : emem_rst_n_co_t;
    signal s_emem_rst_n_odp : emem_rst_n_odp_t;
    signal s_emem_rst_n_odn : emem_rst_n_odn_t;
    signal s_aout0_ds : aout0_ds_t;
    signal s_aout0_sr : aout0_sr_t;
    signal s_aout0_co : aout0_co_t;
    signal s_aout0_odp : aout0_odp_t;
    signal s_aout0_odn : aout0_odn_t;
    signal s_aout1_ds : aout1_ds_t;
    signal s_aout1_sr : aout1_sr_t;
    signal s_aout1_co : aout1_co_t;
    signal s_aout1_odp : aout1_odp_t;
    signal s_aout1_odn : aout1_odn_t;
    signal s_ach0_ste : ach0_ste_t;
    signal s_ach0_pd : ach0_pd_t;
    signal s_ach0_pu : ach0_pu_t;
    signal s_enet_mdio_out_ds : enet_mdio_out_ds_t;
    signal s_enet_mdio_out_sr : enet_mdio_out_sr_t;
    signal s_enet_mdio_out_co : enet_mdio_out_co_t;
    signal s_enet_mdio_out_odp : enet_mdio_out_odp_t;
    signal s_enet_mdio_out_odn : enet_mdio_out_odn_t;
    signal s_enet_mdio_in_ste : enet_mdio_in_ste_t;
    signal s_enet_mdio_in_pd : enet_mdio_in_pd_t;
    signal s_enet_mdio_in_pu : enet_mdio_in_pu_t;
    signal s_enet_mdc_ds : enet_mdc_ds_t;
    signal s_enet_mdc_sr : enet_mdc_sr_t;
    signal s_enet_mdc_co : enet_mdc_co_t;
    signal s_enet_mdc_odp : enet_mdc_odp_t;
    signal s_enet_mdc_odn : enet_mdc_odn_t;
    signal s_enet_txer_ds : enet_txer_ds_t;
    signal s_enet_txer_sr : enet_txer_sr_t;
    signal s_enet_txer_co : enet_txer_co_t;
    signal s_enet_txer_odp : enet_txer_odp_t;
    signal s_enet_txer_odn : enet_txer_odn_t;
    signal s_enet_txd0_ds : enet_txd0_ds_t;
    signal s_enet_txd0_sr : enet_txd0_sr_t;
    signal s_enet_txd0_co : enet_txd0_co_t;
    signal s_enet_txd0_odp : enet_txd0_odp_t;
    signal s_enet_txd0_odn : enet_txd0_odn_t;
    signal s_enet_txd1_ds : enet_txd1_ds_t;
    signal s_enet_txd1_sr : enet_txd1_sr_t;
    signal s_enet_txd1_co : enet_txd1_co_t;
    signal s_enet_txd1_odp : enet_txd1_odp_t;
    signal s_enet_txd1_odn : enet_txd1_odn_t;
    signal s_enet_txen_ds : enet_txen_ds_t;
    signal s_enet_txen_sr : enet_txen_sr_t;
    signal s_enet_txen_co : enet_txen_co_t;
    signal s_enet_txen_odp : enet_txen_odp_t;
    signal s_enet_txen_odn : enet_txen_odn_t;
    signal s_enet_clk_ste : enet_clk_ste_t;
    signal s_enet_clk_pd : enet_clk_pd_t;
    signal s_enet_clk_pu : enet_clk_pu_t;
    signal s_enet_rxdv_ste : enet_rxdv_ste_t;
    signal s_enet_rxdv_pd : enet_rxdv_pd_t;
    signal s_enet_rxdv_pu : enet_rxdv_pu_t;
    signal s_enet_rxd0_ste : enet_rxd0_ste_t;
    signal s_enet_rxd0_pd : enet_rxd0_pd_t;
    signal s_enet_rxd0_pu : enet_rxd0_pu_t;
    signal s_enet_rxd1_ste : enet_rxd1_ste_t;
    signal s_enet_rxd1_pd : enet_rxd1_pd_t;
    signal s_enet_rxd1_pu : enet_rxd1_pu_t;
    signal s_enet_rxer_ste : enet_rxer_ste_t;
    signal s_enet_rxer_pd : enet_rxer_pd_t;
    signal s_enet_rxer_pu : enet_rxer_pu_t;
    signal s_spi_sclk_ste : spi_sclk_ste_t;
    signal s_spi_sclk_pd : spi_sclk_pd_t;
    signal s_spi_sclk_pu : spi_sclk_pu_t;
    signal s_spi_cs_n_ste : spi_cs_n_ste_t;
    signal s_spi_cs_n_pd : spi_cs_n_pd_t;
    signal s_spi_cs_n_pu : spi_cs_n_pu_t;
    signal s_spi_mosi_ste : spi_mosi_ste_t;
    signal s_spi_mosi_pd : spi_mosi_pd_t;
    signal s_spi_mosi_pu : spi_mosi_pu_t;
    signal s_spi_miso_ds : spi_miso_ds_t;
    signal s_spi_miso_sr : spi_miso_sr_t;
    signal s_spi_miso_co : spi_miso_co_t;
    signal s_spi_miso_odp : spi_miso_odp_t;
    signal s_spi_miso_odn : spi_miso_odn_t;
    signal s_pll_ref_clk_ste : pll_ref_clk_ste_t;
    signal s_pll_ref_clk_pd : pll_ref_clk_pd_t;
    signal s_pll_ref_clk_pu : pll_ref_clk_pu_t;
    signal s_pa0_sin_out_ds : pa0_sin_out_ds_t;
    signal s_pa0_sin_out_sr : pa0_sin_out_sr_t;
    signal s_pa0_sin_out_co : pa0_sin_out_co_t;
    signal s_pa0_sin_out_odp : pa0_sin_out_odp_t;
    signal s_pa0_sin_out_odn : pa0_sin_out_odn_t;
    signal s_pa0_sin_in_ste : pa0_sin_in_ste_t;
    signal s_pa0_sin_in_pd : pa0_sin_in_pd_t;
    signal s_pa0_sin_in_pu : pa0_sin_in_pu_t;
    signal s_pa5_cs_n_out_ds : pa5_cs_n_out_ds_t;
    signal s_pa5_cs_n_out_sr : pa5_cs_n_out_sr_t;
    signal s_pa5_cs_n_out_co : pa5_cs_n_out_co_t;
    signal s_pa5_cs_n_out_odp : pa5_cs_n_out_odp_t;
    signal s_pa5_cs_n_out_odn : pa5_cs_n_out_odn_t;
    signal s_pa5_cs_n_in_ste : pa5_cs_n_in_ste_t;
    signal s_pa5_cs_n_in_pd : pa5_cs_n_in_pd_t;
    signal s_pa5_cs_n_in_pu : pa5_cs_n_in_pu_t;
    signal s_pa6_sck_out_ds : pa6_sck_out_ds_t;
    signal s_pa6_sck_out_sr : pa6_sck_out_sr_t;
    signal s_pa6_sck_out_co : pa6_sck_out_co_t;
    signal s_pa6_sck_out_odp : pa6_sck_out_odp_t;
    signal s_pa6_sck_out_odn : pa6_sck_out_odn_t;
    signal s_pa6_sck_in_ste : pa6_sck_in_ste_t;
    signal s_pa6_sck_in_pd : pa6_sck_in_pd_t;
    signal s_pa6_sck_in_pu : pa6_sck_in_pu_t;
    signal s_pa7_sout_out_ds : pa7_sout_out_ds_t;
    signal s_pa7_sout_out_sr : pa7_sout_out_sr_t;
    signal s_pa7_sout_out_co : pa7_sout_out_co_t;
    signal s_pa7_sout_out_odp : pa7_sout_out_odp_t;
    signal s_pa7_sout_out_odn : pa7_sout_out_odn_t;
    signal s_pa7_sout_in_ste : pa7_sout_in_ste_t;
    signal s_pa7_sout_in_pd : pa7_sout_in_pd_t;
    signal s_pa7_sout_in_pu : pa7_sout_in_pu_t;
    signal s_pg0_out_ds : pg0_out_ds_t;
    signal s_pg0_out_sr : pg0_out_sr_t;
    signal s_pg0_out_co : pg0_out_co_t;
    signal s_pg0_out_odp : pg0_out_odp_t;
    signal s_pg0_out_odn : pg0_out_odn_t;
    signal s_pg0_in_ste : pg0_in_ste_t;
    signal s_pg0_in_pd : pg0_in_pd_t;
    signal s_pg0_in_pu : pg0_in_pu_t;
    signal s_pg1_out_ds : pg1_out_ds_t;
    signal s_pg1_out_sr : pg1_out_sr_t;
    signal s_pg1_out_co : pg1_out_co_t;
    signal s_pg1_out_odp : pg1_out_odp_t;
    signal s_pg1_out_odn : pg1_out_odn_t;
    signal s_pg1_in_ste : pg1_in_ste_t;
    signal s_pg1_in_pd : pg1_in_pd_t;
    signal s_pg1_in_pu : pg1_in_pu_t;
    signal s_pg2_out_ds : pg2_out_ds_t;
    signal s_pg2_out_sr : pg2_out_sr_t;
    signal s_pg2_out_co : pg2_out_co_t;
    signal s_pg2_out_odp : pg2_out_odp_t;
    signal s_pg2_out_odn : pg2_out_odn_t;
    signal s_pg2_in_ste : pg2_in_ste_t;
    signal s_pg2_in_pd : pg2_in_pd_t;
    signal s_pg2_in_pu : pg2_in_pu_t;
    signal s_pg3_out_ds : pg3_out_ds_t;
    signal s_pg3_out_sr : pg3_out_sr_t;
    signal s_pg3_out_co : pg3_out_co_t;
    signal s_pg3_out_odp : pg3_out_odp_t;
    signal s_pg3_out_odn : pg3_out_odn_t;
    signal s_pg3_in_ste : pg3_in_ste_t;
    signal s_pg3_in_pd : pg3_in_pd_t;
    signal s_pg3_in_pu : pg3_in_pu_t;
    signal s_pg4_out_ds : pg4_out_ds_t;
    signal s_pg4_out_sr : pg4_out_sr_t;
    signal s_pg4_out_co : pg4_out_co_t;
    signal s_pg4_out_odp : pg4_out_odp_t;
    signal s_pg4_out_odn : pg4_out_odn_t;
    signal s_pg4_in_ste : pg4_in_ste_t;
    signal s_pg4_in_pd : pg4_in_pd_t;
    signal s_pg4_in_pu : pg4_in_pu_t;
    signal s_pg5_out_ds : pg5_out_ds_t;
    signal s_pg5_out_sr : pg5_out_sr_t;
    signal s_pg5_out_co : pg5_out_co_t;
    signal s_pg5_out_odp : pg5_out_odp_t;
    signal s_pg5_out_odn : pg5_out_odn_t;
    signal s_pg5_in_ste : pg5_in_ste_t;
    signal s_pg5_in_pd : pg5_in_pd_t;
    signal s_pg5_in_pu : pg5_in_pu_t;
    signal s_pg6_out_ds : pg6_out_ds_t;
    signal s_pg6_out_sr : pg6_out_sr_t;
    signal s_pg6_out_co : pg6_out_co_t;
    signal s_pg6_out_odp : pg6_out_odp_t;
    signal s_pg6_out_odn : pg6_out_odn_t;
    signal s_pg6_in_ste : pg6_in_ste_t;
    signal s_pg6_in_pd : pg6_in_pd_t;
    signal s_pg6_in_pu : pg6_in_pu_t;
    signal s_pg7_out_ds : pg7_out_ds_t;
    signal s_pg7_out_sr : pg7_out_sr_t;
    signal s_pg7_out_co : pg7_out_co_t;
    signal s_pg7_out_odp : pg7_out_odp_t;
    signal s_pg7_out_odn : pg7_out_odn_t;
    signal s_pg7_in_ste : pg7_in_ste_t;
    signal s_pg7_in_pd : pg7_in_pd_t;
    signal s_pg7_in_pu : pg7_in_pu_t;
    signal s_mtest_ste : mtest_ste_t;
    signal s_mtest_pd : mtest_pd_t;
    signal s_mtest_pu : mtest_pu_t;
    signal s_mwake_ste : mwake_ste_t;
    signal s_mwake_pd : mwake_pd_t;
    signal s_mwake_pu : mwake_pu_t;
    signal s_mrxout_out_ds : mrxout_out_ds_t;
    signal s_mrxout_out_sr : mrxout_out_sr_t;
    signal s_mrxout_out_co : mrxout_out_co_t;
    signal s_mrxout_out_odp : mrxout_out_odp_t;
    signal s_mrxout_out_odn : mrxout_out_odn_t;
    signal s_pll_1_main_div_n1 : pll_1_main_div_n1_t;
    signal s_pll_1_main_div_n2 : pll_1_main_div_n2_t;
    signal s_pll_1_main_div_n3 : pll_1_main_div_n3_t;
    signal s_pll_1_main_div_n4 : pll_1_main_div_n4_t;
    signal s_pll_2_open_loop : pll_2_open_loop_t;
    signal s_pll_2_out_div_sel : pll_2_out_div_sel_t;
    signal s_pll_2_ci : pll_2_ci_t;
    signal s_pll_cp_cp : pll_cp_cp_t;
    signal s_pll_ft_ft : pll_ft_ft_t;
    signal s_pll_3_divcore_sel : pll_3_divcore_sel_t;
    signal s_pll_3_coarse : pll_3_coarse_t;
    signal s_pll_4_auto_coarsetune : pll_4_auto_coarsetune_t;
    signal s_pll_4_enforce_lock : pll_4_enforce_lock_t;
    signal s_pll_4_pfd_select : pll_4_pfd_select_t;
    signal s_pll_4_lock_window_sel : pll_4_lock_window_sel_t;
    signal s_pll_4_div_core_mux_sel : pll_4_div_core_mux_sel_t;
    signal s_pll_4_filter_shift : pll_4_filter_shift_t;
    signal s_pll_4_en_fast_lock : pll_4_en_fast_lock_t;
    signal s_pll_5_sar_limit : pll_5_sar_limit_t;
    signal s_pll_5_set_op_lock : pll_5_set_op_lock_t;
    signal s_pll_5_disable_lock : pll_5_disable_lock_t;
    signal s_pll_5_ref_bypass : pll_5_ref_bypass_t;
    signal s_pll_5_ct_compensation : pll_5_ct_compensation_t;
    signal s_adpll_status0_adpll_status_0 : adpll_status0_adpll_status_0_t;
    signal s_adpll_status1_adpll_status_1 : adpll_status1_adpll_status_1_t;
    signal s_adpll_status2_adpll_status_2 : adpll_status2_adpll_status_2_t;
    signal s_io_dack0_n_ste : io_dack0_n_ste_t;
    signal s_io_dack0_n_pd : io_dack0_n_pd_t;
    signal s_io_dack0_n_pu : io_dack0_n_pu_t;
    signal s_io_dreq0_n_ds : io_dreq0_n_ds_t;
    signal s_io_dreq0_n_sr : io_dreq0_n_sr_t;
    signal s_io_dreq0_n_co : io_dreq0_n_co_t;
    signal s_io_dreq0_n_odp : io_dreq0_n_odp_t;
    signal s_io_dreq0_n_odn : io_dreq0_n_odn_t;
    signal s_io_dack1_n_ste : io_dack1_n_ste_t;
    signal s_io_dack1_n_pd : io_dack1_n_pd_t;
    signal s_io_dack1_n_pu : io_dack1_n_pu_t;
    signal s_io_dreq1_n_ds : io_dreq1_n_ds_t;
    signal s_io_dreq1_n_sr : io_dreq1_n_sr_t;
    signal s_io_dreq1_n_co : io_dreq1_n_co_t;
    signal s_io_dreq1_n_odp : io_dreq1_n_odp_t;
    signal s_io_dreq1_n_odn : io_dreq1_n_odn_t;
    signal s_io_dack2_n_ste : io_dack2_n_ste_t;
    signal s_io_dack2_n_pd : io_dack2_n_pd_t;
    signal s_io_dack2_n_pu : io_dack2_n_pu_t;
    signal s_io_dreq2_n_ds : io_dreq2_n_ds_t;
    signal s_io_dreq2_n_sr : io_dreq2_n_sr_t;
    signal s_io_dreq2_n_co : io_dreq2_n_co_t;
    signal s_io_dreq2_n_odp : io_dreq2_n_odp_t;
    signal s_io_dreq2_n_odn : io_dreq2_n_odn_t;
    signal s_io_dack3_n_ste : io_dack3_n_ste_t;
    signal s_io_dack3_n_pd : io_dack3_n_pd_t;
    signal s_io_dack3_n_pu : io_dack3_n_pu_t;
    signal s_io_dreq3_n_ds : io_dreq3_n_ds_t;
    signal s_io_dreq3_n_sr : io_dreq3_n_sr_t;
    signal s_io_dreq3_n_co : io_dreq3_n_co_t;
    signal s_io_dreq3_n_odp : io_dreq3_n_odp_t;
    signal s_io_dreq3_n_odn : io_dreq3_n_odn_t;
    signal s_io_d0_out_ds : io_d0_out_ds_t;
    signal s_io_d0_out_sr : io_d0_out_sr_t;
    signal s_io_d0_out_co : io_d0_out_co_t;
    signal s_io_d0_out_odp : io_d0_out_odp_t;
    signal s_io_d0_out_odn : io_d0_out_odn_t;
    signal s_io_d0_in_ste : io_d0_in_ste_t;
    signal s_io_d0_in_pd : io_d0_in_pd_t;
    signal s_io_d0_in_pu : io_d0_in_pu_t;
    signal s_io_d1_out_ds : io_d1_out_ds_t;
    signal s_io_d1_out_sr : io_d1_out_sr_t;
    signal s_io_d1_out_co : io_d1_out_co_t;
    signal s_io_d1_out_odp : io_d1_out_odp_t;
    signal s_io_d1_out_odn : io_d1_out_odn_t;
    signal s_io_d1_in_ste : io_d1_in_ste_t;
    signal s_io_d1_in_pd : io_d1_in_pd_t;
    signal s_io_d1_in_pu : io_d1_in_pu_t;
    signal s_io_d2_out_ds : io_d2_out_ds_t;
    signal s_io_d2_out_sr : io_d2_out_sr_t;
    signal s_io_d2_out_co : io_d2_out_co_t;
    signal s_io_d2_out_odp : io_d2_out_odp_t;
    signal s_io_d2_out_odn : io_d2_out_odn_t;
    signal s_io_d2_in_ste : io_d2_in_ste_t;
    signal s_io_d2_in_pd : io_d2_in_pd_t;
    signal s_io_d2_in_pu : io_d2_in_pu_t;
    signal s_io_d3_out_ds : io_d3_out_ds_t;
    signal s_io_d3_out_sr : io_d3_out_sr_t;
    signal s_io_d3_out_co : io_d3_out_co_t;
    signal s_io_d3_out_odp : io_d3_out_odp_t;
    signal s_io_d3_out_odn : io_d3_out_odn_t;
    signal s_io_d3_in_ste : io_d3_in_ste_t;
    signal s_io_d3_in_pd : io_d3_in_pd_t;
    signal s_io_d3_in_pu : io_d3_in_pu_t;
    signal s_io_d4_out_ds : io_d4_out_ds_t;
    signal s_io_d4_out_sr : io_d4_out_sr_t;
    signal s_io_d4_out_co : io_d4_out_co_t;
    signal s_io_d4_out_odp : io_d4_out_odp_t;
    signal s_io_d4_out_odn : io_d4_out_odn_t;
    signal s_io_d4_in_ste : io_d4_in_ste_t;
    signal s_io_d4_in_pd : io_d4_in_pd_t;
    signal s_io_d4_in_pu : io_d4_in_pu_t;
    signal s_io_d5_out_ds : io_d5_out_ds_t;
    signal s_io_d5_out_sr : io_d5_out_sr_t;
    signal s_io_d5_out_co : io_d5_out_co_t;
    signal s_io_d5_out_odp : io_d5_out_odp_t;
    signal s_io_d5_out_odn : io_d5_out_odn_t;
    signal s_io_d5_in_ste : io_d5_in_ste_t;
    signal s_io_d5_in_pd : io_d5_in_pd_t;
    signal s_io_d5_in_pu : io_d5_in_pu_t;
    signal s_io_d6_out_ds : io_d6_out_ds_t;
    signal s_io_d6_out_sr : io_d6_out_sr_t;
    signal s_io_d6_out_co : io_d6_out_co_t;
    signal s_io_d6_out_odp : io_d6_out_odp_t;
    signal s_io_d6_out_odn : io_d6_out_odn_t;
    signal s_io_d6_in_ste : io_d6_in_ste_t;
    signal s_io_d6_in_pd : io_d6_in_pd_t;
    signal s_io_d6_in_pu : io_d6_in_pu_t;
    signal s_io_d7_out_ds : io_d7_out_ds_t;
    signal s_io_d7_out_sr : io_d7_out_sr_t;
    signal s_io_d7_out_co : io_d7_out_co_t;
    signal s_io_d7_out_odp : io_d7_out_odp_t;
    signal s_io_d7_out_odn : io_d7_out_odn_t;
    signal s_io_d7_in_ste : io_d7_in_ste_t;
    signal s_io_d7_in_pd : io_d7_in_pd_t;
    signal s_io_d7_in_pu : io_d7_in_pu_t;
    signal s_io_ldout_n_ds : io_ldout_n_ds_t;
    signal s_io_ldout_n_sr : io_ldout_n_sr_t;
    signal s_io_ldout_n_co : io_ldout_n_co_t;
    signal s_io_ldout_n_odp : io_ldout_n_odp_t;
    signal s_io_ldout_n_odn : io_ldout_n_odn_t;
    signal s_io_next_n_ds : io_next_n_ds_t;
    signal s_io_next_n_sr : io_next_n_sr_t;
    signal s_io_next_n_co : io_next_n_co_t;
    signal s_io_next_n_odp : io_next_n_odp_t;
    signal s_io_next_n_odn : io_next_n_odn_t;
    signal s_io_clk_ds : io_clk_ds_t;
    signal s_io_clk_sr : io_clk_sr_t;
    signal s_io_clk_co : io_clk_co_t;
    signal s_io_clk_odp : io_clk_odp_t;
    signal s_io_clk_odn : io_clk_odn_t;
    signal s_io_ioa_n_ds : io_ioa_n_ds_t;
    signal s_io_ioa_n_sr : io_ioa_n_sr_t;
    signal s_io_ioa_n_co : io_ioa_n_co_t;
    signal s_io_ioa_n_odp : io_ioa_n_odp_t;
    signal s_io_ioa_n_odn : io_ioa_n_odn_t;
    signal s_mrxout_in_ste : mrxout_in_ste_t;
    signal s_mrxout_in_pd : mrxout_in_pd_t;
    signal s_mrxout_in_pu : mrxout_in_pu_t;

    signal s_address : integer range 0 to (2**7) - 1;

begin

  s_address <= to_integer(unsigned(address));

  register_proc : process (clk, rst_n)
  begin  -- process register
    if rst_n = '0' then               -- asynchronous reset (active low)
      s_mclkout_ds <= mclkout_ds_reset_c;
      s_mclkout_sr <= mclkout_sr_reset_c;
      s_mclkout_co <= mclkout_co_reset_c;
      s_mclkout_odp <= mclkout_odp_reset_c;
      s_mclkout_odn <= mclkout_odn_reset_c;
      s_msdout_ds <= msdout_ds_reset_c;
      s_msdout_sr <= msdout_sr_reset_c;
      s_msdout_co <= msdout_co_reset_c;
      s_msdout_odp <= msdout_odp_reset_c;
      s_msdout_odn <= msdout_odn_reset_c;
      s_utx_ds <= utx_ds_reset_c;
      s_utx_sr <= utx_sr_reset_c;
      s_utx_co <= utx_co_reset_c;
      s_utx_odp <= utx_odp_reset_c;
      s_utx_odn <= utx_odn_reset_c;
      s_mirqout_ds <= mirqout_ds_reset_c;
      s_mirqout_sr <= mirqout_sr_reset_c;
      s_mirqout_co <= mirqout_co_reset_c;
      s_mirqout_odp <= mirqout_odp_reset_c;
      s_mirqout_odn <= mirqout_odn_reset_c;
      s_msdin_ste <= msdin_ste_reset_c;
      s_msdin_pd <= msdin_pd_reset_c;
      s_msdin_pu <= msdin_pu_reset_c;
      s_mirq0_ste <= mirq0_ste_reset_c;
      s_mirq0_pd <= mirq0_pd_reset_c;
      s_mirq0_pu <= mirq0_pu_reset_c;
      s_mirq1_ste <= mirq1_ste_reset_c;
      s_mirq1_pd <= mirq1_pd_reset_c;
      s_mirq1_pu <= mirq1_pu_reset_c;
      s_urx_ste <= urx_ste_reset_c;
      s_urx_pd <= urx_pd_reset_c;
      s_urx_pu <= urx_pu_reset_c;
      s_emem_d0_out_ds <= emem_d0_out_ds_reset_c;
      s_emem_d0_out_sr <= emem_d0_out_sr_reset_c;
      s_emem_d0_out_co <= emem_d0_out_co_reset_c;
      s_emem_d0_out_odp <= emem_d0_out_odp_reset_c;
      s_emem_d0_out_odn <= emem_d0_out_odn_reset_c;
      s_emem_d0_in_ste <= emem_d0_in_ste_reset_c;
      s_emem_d0_in_pd <= emem_d0_in_pd_reset_c;
      s_emem_d0_in_pu <= emem_d0_in_pu_reset_c;
      s_emem_d1_out_ds <= emem_d1_out_ds_reset_c;
      s_emem_d1_out_sr <= emem_d1_out_sr_reset_c;
      s_emem_d1_out_co <= emem_d1_out_co_reset_c;
      s_emem_d1_out_odp <= emem_d1_out_odp_reset_c;
      s_emem_d1_out_odn <= emem_d1_out_odn_reset_c;
      s_emem_d1_in_ste <= emem_d1_in_ste_reset_c;
      s_emem_d1_in_pd <= emem_d1_in_pd_reset_c;
      s_emem_d1_in_pu <= emem_d1_in_pu_reset_c;
      s_emem_d2_out_ds <= emem_d2_out_ds_reset_c;
      s_emem_d2_out_sr <= emem_d2_out_sr_reset_c;
      s_emem_d2_out_co <= emem_d2_out_co_reset_c;
      s_emem_d2_out_odp <= emem_d2_out_odp_reset_c;
      s_emem_d2_out_odn <= emem_d2_out_odn_reset_c;
      s_emem_d2_in_ste <= emem_d2_in_ste_reset_c;
      s_emem_d2_in_pd <= emem_d2_in_pd_reset_c;
      s_emem_d2_in_pu <= emem_d2_in_pu_reset_c;
      s_emem_d3_out_ds <= emem_d3_out_ds_reset_c;
      s_emem_d3_out_sr <= emem_d3_out_sr_reset_c;
      s_emem_d3_out_co <= emem_d3_out_co_reset_c;
      s_emem_d3_out_odp <= emem_d3_out_odp_reset_c;
      s_emem_d3_out_odn <= emem_d3_out_odn_reset_c;
      s_emem_d3_in_ste <= emem_d3_in_ste_reset_c;
      s_emem_d3_in_pd <= emem_d3_in_pd_reset_c;
      s_emem_d3_in_pu <= emem_d3_in_pu_reset_c;
      s_emem_d4_out_ds <= emem_d4_out_ds_reset_c;
      s_emem_d4_out_sr <= emem_d4_out_sr_reset_c;
      s_emem_d4_out_co <= emem_d4_out_co_reset_c;
      s_emem_d4_out_odp <= emem_d4_out_odp_reset_c;
      s_emem_d4_out_odn <= emem_d4_out_odn_reset_c;
      s_emem_d4_in_ste <= emem_d4_in_ste_reset_c;
      s_emem_d4_in_pd <= emem_d4_in_pd_reset_c;
      s_emem_d4_in_pu <= emem_d4_in_pu_reset_c;
      s_emem_d5_out_ds <= emem_d5_out_ds_reset_c;
      s_emem_d5_out_sr <= emem_d5_out_sr_reset_c;
      s_emem_d5_out_co <= emem_d5_out_co_reset_c;
      s_emem_d5_out_odp <= emem_d5_out_odp_reset_c;
      s_emem_d5_out_odn <= emem_d5_out_odn_reset_c;
      s_emem_d5_in_ste <= emem_d5_in_ste_reset_c;
      s_emem_d5_in_pd <= emem_d5_in_pd_reset_c;
      s_emem_d5_in_pu <= emem_d5_in_pu_reset_c;
      s_emem_d6_out_ds <= emem_d6_out_ds_reset_c;
      s_emem_d6_out_sr <= emem_d6_out_sr_reset_c;
      s_emem_d6_out_co <= emem_d6_out_co_reset_c;
      s_emem_d6_out_odp <= emem_d6_out_odp_reset_c;
      s_emem_d6_out_odn <= emem_d6_out_odn_reset_c;
      s_emem_d6_in_ste <= emem_d6_in_ste_reset_c;
      s_emem_d6_in_pd <= emem_d6_in_pd_reset_c;
      s_emem_d6_in_pu <= emem_d6_in_pu_reset_c;
      s_emem_d7_out_ds <= emem_d7_out_ds_reset_c;
      s_emem_d7_out_sr <= emem_d7_out_sr_reset_c;
      s_emem_d7_out_co <= emem_d7_out_co_reset_c;
      s_emem_d7_out_odp <= emem_d7_out_odp_reset_c;
      s_emem_d7_out_odn <= emem_d7_out_odn_reset_c;
      s_emem_d7_in_ste <= emem_d7_in_ste_reset_c;
      s_emem_d7_in_pd <= emem_d7_in_pd_reset_c;
      s_emem_d7_in_pu <= emem_d7_in_pu_reset_c;
      s_emem_clk_ds <= emem_clk_ds_reset_c;
      s_emem_clk_sr <= emem_clk_sr_reset_c;
      s_emem_clk_co <= emem_clk_co_reset_c;
      s_emem_clk_odp <= emem_clk_odp_reset_c;
      s_emem_clk_odn <= emem_clk_odn_reset_c;
      s_emem_rwds_out_ds <= emem_rwds_out_ds_reset_c;
      s_emem_rwds_out_sr <= emem_rwds_out_sr_reset_c;
      s_emem_rwds_out_co <= emem_rwds_out_co_reset_c;
      s_emem_rwds_out_odp <= emem_rwds_out_odp_reset_c;
      s_emem_rwds_out_odn <= emem_rwds_out_odn_reset_c;
      s_emem_rwds_in_ste <= emem_rwds_in_ste_reset_c;
      s_emem_rwds_in_pd <= emem_rwds_in_pd_reset_c;
      s_emem_rwds_in_pu <= emem_rwds_in_pu_reset_c;
      s_emem_cs_n_ds <= emem_cs_n_ds_reset_c;
      s_emem_cs_n_sr <= emem_cs_n_sr_reset_c;
      s_emem_cs_n_co <= emem_cs_n_co_reset_c;
      s_emem_cs_n_odp <= emem_cs_n_odp_reset_c;
      s_emem_cs_n_odn <= emem_cs_n_odn_reset_c;
      s_emem_rst_n_ds <= emem_rst_n_ds_reset_c;
      s_emem_rst_n_sr <= emem_rst_n_sr_reset_c;
      s_emem_rst_n_co <= emem_rst_n_co_reset_c;
      s_emem_rst_n_odp <= emem_rst_n_odp_reset_c;
      s_emem_rst_n_odn <= emem_rst_n_odn_reset_c;
      s_aout0_ds <= aout0_ds_reset_c;
      s_aout0_sr <= aout0_sr_reset_c;
      s_aout0_co <= aout0_co_reset_c;
      s_aout0_odp <= aout0_odp_reset_c;
      s_aout0_odn <= aout0_odn_reset_c;
      s_aout1_ds <= aout1_ds_reset_c;
      s_aout1_sr <= aout1_sr_reset_c;
      s_aout1_co <= aout1_co_reset_c;
      s_aout1_odp <= aout1_odp_reset_c;
      s_aout1_odn <= aout1_odn_reset_c;
      s_ach0_ste <= ach0_ste_reset_c;
      s_ach0_pd <= ach0_pd_reset_c;
      s_ach0_pu <= ach0_pu_reset_c;
      s_enet_mdio_out_ds <= enet_mdio_out_ds_reset_c;
      s_enet_mdio_out_sr <= enet_mdio_out_sr_reset_c;
      s_enet_mdio_out_co <= enet_mdio_out_co_reset_c;
      s_enet_mdio_out_odp <= enet_mdio_out_odp_reset_c;
      s_enet_mdio_out_odn <= enet_mdio_out_odn_reset_c;
      s_enet_mdio_in_ste <= enet_mdio_in_ste_reset_c;
      s_enet_mdio_in_pd <= enet_mdio_in_pd_reset_c;
      s_enet_mdio_in_pu <= enet_mdio_in_pu_reset_c;
      s_enet_mdc_ds <= enet_mdc_ds_reset_c;
      s_enet_mdc_sr <= enet_mdc_sr_reset_c;
      s_enet_mdc_co <= enet_mdc_co_reset_c;
      s_enet_mdc_odp <= enet_mdc_odp_reset_c;
      s_enet_mdc_odn <= enet_mdc_odn_reset_c;
      s_enet_txer_ds <= enet_txer_ds_reset_c;
      s_enet_txer_sr <= enet_txer_sr_reset_c;
      s_enet_txer_co <= enet_txer_co_reset_c;
      s_enet_txer_odp <= enet_txer_odp_reset_c;
      s_enet_txer_odn <= enet_txer_odn_reset_c;
      s_enet_txd0_ds <= enet_txd0_ds_reset_c;
      s_enet_txd0_sr <= enet_txd0_sr_reset_c;
      s_enet_txd0_co <= enet_txd0_co_reset_c;
      s_enet_txd0_odp <= enet_txd0_odp_reset_c;
      s_enet_txd0_odn <= enet_txd0_odn_reset_c;
      s_enet_txd1_ds <= enet_txd1_ds_reset_c;
      s_enet_txd1_sr <= enet_txd1_sr_reset_c;
      s_enet_txd1_co <= enet_txd1_co_reset_c;
      s_enet_txd1_odp <= enet_txd1_odp_reset_c;
      s_enet_txd1_odn <= enet_txd1_odn_reset_c;
      s_enet_txen_ds <= enet_txen_ds_reset_c;
      s_enet_txen_sr <= enet_txen_sr_reset_c;
      s_enet_txen_co <= enet_txen_co_reset_c;
      s_enet_txen_odp <= enet_txen_odp_reset_c;
      s_enet_txen_odn <= enet_txen_odn_reset_c;
      s_enet_clk_ste <= enet_clk_ste_reset_c;
      s_enet_clk_pd <= enet_clk_pd_reset_c;
      s_enet_clk_pu <= enet_clk_pu_reset_c;
      s_enet_rxdv_ste <= enet_rxdv_ste_reset_c;
      s_enet_rxdv_pd <= enet_rxdv_pd_reset_c;
      s_enet_rxdv_pu <= enet_rxdv_pu_reset_c;
      s_enet_rxd0_ste <= enet_rxd0_ste_reset_c;
      s_enet_rxd0_pd <= enet_rxd0_pd_reset_c;
      s_enet_rxd0_pu <= enet_rxd0_pu_reset_c;
      s_enet_rxd1_ste <= enet_rxd1_ste_reset_c;
      s_enet_rxd1_pd <= enet_rxd1_pd_reset_c;
      s_enet_rxd1_pu <= enet_rxd1_pu_reset_c;
      s_enet_rxer_ste <= enet_rxer_ste_reset_c;
      s_enet_rxer_pd <= enet_rxer_pd_reset_c;
      s_enet_rxer_pu <= enet_rxer_pu_reset_c;
      s_spi_sclk_ste <= spi_sclk_ste_reset_c;
      s_spi_sclk_pd <= spi_sclk_pd_reset_c;
      s_spi_sclk_pu <= spi_sclk_pu_reset_c;
      s_spi_cs_n_ste <= spi_cs_n_ste_reset_c;
      s_spi_cs_n_pd <= spi_cs_n_pd_reset_c;
      s_spi_cs_n_pu <= spi_cs_n_pu_reset_c;
      s_spi_mosi_ste <= spi_mosi_ste_reset_c;
      s_spi_mosi_pd <= spi_mosi_pd_reset_c;
      s_spi_mosi_pu <= spi_mosi_pu_reset_c;
      s_spi_miso_ds <= spi_miso_ds_reset_c;
      s_spi_miso_sr <= spi_miso_sr_reset_c;
      s_spi_miso_co <= spi_miso_co_reset_c;
      s_spi_miso_odp <= spi_miso_odp_reset_c;
      s_spi_miso_odn <= spi_miso_odn_reset_c;
      s_pll_ref_clk_ste <= pll_ref_clk_ste_reset_c;
      s_pll_ref_clk_pd <= pll_ref_clk_pd_reset_c;
      s_pll_ref_clk_pu <= pll_ref_clk_pu_reset_c;
      s_pa0_sin_out_ds <= pa0_sin_out_ds_reset_c;
      s_pa0_sin_out_sr <= pa0_sin_out_sr_reset_c;
      s_pa0_sin_out_co <= pa0_sin_out_co_reset_c;
      s_pa0_sin_out_odp <= pa0_sin_out_odp_reset_c;
      s_pa0_sin_out_odn <= pa0_sin_out_odn_reset_c;
      s_pa0_sin_in_ste <= pa0_sin_in_ste_reset_c;
      s_pa0_sin_in_pd <= pa0_sin_in_pd_reset_c;
      s_pa0_sin_in_pu <= pa0_sin_in_pu_reset_c;
      s_pa5_cs_n_out_ds <= pa5_cs_n_out_ds_reset_c;
      s_pa5_cs_n_out_sr <= pa5_cs_n_out_sr_reset_c;
      s_pa5_cs_n_out_co <= pa5_cs_n_out_co_reset_c;
      s_pa5_cs_n_out_odp <= pa5_cs_n_out_odp_reset_c;
      s_pa5_cs_n_out_odn <= pa5_cs_n_out_odn_reset_c;
      s_pa5_cs_n_in_ste <= pa5_cs_n_in_ste_reset_c;
      s_pa5_cs_n_in_pd <= pa5_cs_n_in_pd_reset_c;
      s_pa5_cs_n_in_pu <= pa5_cs_n_in_pu_reset_c;
      s_pa6_sck_out_ds <= pa6_sck_out_ds_reset_c;
      s_pa6_sck_out_sr <= pa6_sck_out_sr_reset_c;
      s_pa6_sck_out_co <= pa6_sck_out_co_reset_c;
      s_pa6_sck_out_odp <= pa6_sck_out_odp_reset_c;
      s_pa6_sck_out_odn <= pa6_sck_out_odn_reset_c;
      s_pa6_sck_in_ste <= pa6_sck_in_ste_reset_c;
      s_pa6_sck_in_pd <= pa6_sck_in_pd_reset_c;
      s_pa6_sck_in_pu <= pa6_sck_in_pu_reset_c;
      s_pa7_sout_out_ds <= pa7_sout_out_ds_reset_c;
      s_pa7_sout_out_sr <= pa7_sout_out_sr_reset_c;
      s_pa7_sout_out_co <= pa7_sout_out_co_reset_c;
      s_pa7_sout_out_odp <= pa7_sout_out_odp_reset_c;
      s_pa7_sout_out_odn <= pa7_sout_out_odn_reset_c;
      s_pa7_sout_in_ste <= pa7_sout_in_ste_reset_c;
      s_pa7_sout_in_pd <= pa7_sout_in_pd_reset_c;
      s_pa7_sout_in_pu <= pa7_sout_in_pu_reset_c;
      s_pg0_out_ds <= pg0_out_ds_reset_c;
      s_pg0_out_sr <= pg0_out_sr_reset_c;
      s_pg0_out_co <= pg0_out_co_reset_c;
      s_pg0_out_odp <= pg0_out_odp_reset_c;
      s_pg0_out_odn <= pg0_out_odn_reset_c;
      s_pg0_in_ste <= pg0_in_ste_reset_c;
      s_pg0_in_pd <= pg0_in_pd_reset_c;
      s_pg0_in_pu <= pg0_in_pu_reset_c;
      s_pg1_out_ds <= pg1_out_ds_reset_c;
      s_pg1_out_sr <= pg1_out_sr_reset_c;
      s_pg1_out_co <= pg1_out_co_reset_c;
      s_pg1_out_odp <= pg1_out_odp_reset_c;
      s_pg1_out_odn <= pg1_out_odn_reset_c;
      s_pg1_in_ste <= pg1_in_ste_reset_c;
      s_pg1_in_pd <= pg1_in_pd_reset_c;
      s_pg1_in_pu <= pg1_in_pu_reset_c;
      s_pg2_out_ds <= pg2_out_ds_reset_c;
      s_pg2_out_sr <= pg2_out_sr_reset_c;
      s_pg2_out_co <= pg2_out_co_reset_c;
      s_pg2_out_odp <= pg2_out_odp_reset_c;
      s_pg2_out_odn <= pg2_out_odn_reset_c;
      s_pg2_in_ste <= pg2_in_ste_reset_c;
      s_pg2_in_pd <= pg2_in_pd_reset_c;
      s_pg2_in_pu <= pg2_in_pu_reset_c;
      s_pg3_out_ds <= pg3_out_ds_reset_c;
      s_pg3_out_sr <= pg3_out_sr_reset_c;
      s_pg3_out_co <= pg3_out_co_reset_c;
      s_pg3_out_odp <= pg3_out_odp_reset_c;
      s_pg3_out_odn <= pg3_out_odn_reset_c;
      s_pg3_in_ste <= pg3_in_ste_reset_c;
      s_pg3_in_pd <= pg3_in_pd_reset_c;
      s_pg3_in_pu <= pg3_in_pu_reset_c;
      s_pg4_out_ds <= pg4_out_ds_reset_c;
      s_pg4_out_sr <= pg4_out_sr_reset_c;
      s_pg4_out_co <= pg4_out_co_reset_c;
      s_pg4_out_odp <= pg4_out_odp_reset_c;
      s_pg4_out_odn <= pg4_out_odn_reset_c;
      s_pg4_in_ste <= pg4_in_ste_reset_c;
      s_pg4_in_pd <= pg4_in_pd_reset_c;
      s_pg4_in_pu <= pg4_in_pu_reset_c;
      s_pg5_out_ds <= pg5_out_ds_reset_c;
      s_pg5_out_sr <= pg5_out_sr_reset_c;
      s_pg5_out_co <= pg5_out_co_reset_c;
      s_pg5_out_odp <= pg5_out_odp_reset_c;
      s_pg5_out_odn <= pg5_out_odn_reset_c;
      s_pg5_in_ste <= pg5_in_ste_reset_c;
      s_pg5_in_pd <= pg5_in_pd_reset_c;
      s_pg5_in_pu <= pg5_in_pu_reset_c;
      s_pg6_out_ds <= pg6_out_ds_reset_c;
      s_pg6_out_sr <= pg6_out_sr_reset_c;
      s_pg6_out_co <= pg6_out_co_reset_c;
      s_pg6_out_odp <= pg6_out_odp_reset_c;
      s_pg6_out_odn <= pg6_out_odn_reset_c;
      s_pg6_in_ste <= pg6_in_ste_reset_c;
      s_pg6_in_pd <= pg6_in_pd_reset_c;
      s_pg6_in_pu <= pg6_in_pu_reset_c;
      s_pg7_out_ds <= pg7_out_ds_reset_c;
      s_pg7_out_sr <= pg7_out_sr_reset_c;
      s_pg7_out_co <= pg7_out_co_reset_c;
      s_pg7_out_odp <= pg7_out_odp_reset_c;
      s_pg7_out_odn <= pg7_out_odn_reset_c;
      s_pg7_in_ste <= pg7_in_ste_reset_c;
      s_pg7_in_pd <= pg7_in_pd_reset_c;
      s_pg7_in_pu <= pg7_in_pu_reset_c;
      s_mtest_ste <= mtest_ste_reset_c;
      s_mtest_pd <= mtest_pd_reset_c;
      s_mtest_pu <= mtest_pu_reset_c;
      s_mwake_ste <= mwake_ste_reset_c;
      s_mwake_pd <= mwake_pd_reset_c;
      s_mwake_pu <= mwake_pu_reset_c;
      s_mrxout_out_ds <= mrxout_out_ds_reset_c;
      s_mrxout_out_sr <= mrxout_out_sr_reset_c;
      s_mrxout_out_co <= mrxout_out_co_reset_c;
      s_mrxout_out_odp <= mrxout_out_odp_reset_c;
      s_mrxout_out_odn <= mrxout_out_odn_reset_c;
      s_pll_1_main_div_n1 <= pll_1_main_div_n1_reset_c;
      s_pll_1_main_div_n2 <= pll_1_main_div_n2_reset_c;
      s_pll_1_main_div_n3 <= pll_1_main_div_n3_reset_c;
      s_pll_1_main_div_n4 <= pll_1_main_div_n4_reset_c;
      s_pll_2_open_loop <= pll_2_open_loop_reset_c;
      s_pll_2_out_div_sel <= pll_2_out_div_sel_reset_c;
      s_pll_2_ci <= pll_2_ci_reset_c;
      s_pll_cp_cp <= pll_cp_cp_reset_c;
      s_pll_ft_ft <= pll_ft_ft_reset_c;
      s_pll_3_divcore_sel <= pll_3_divcore_sel_reset_c;
      s_pll_3_coarse <= pll_3_coarse_reset_c;
      s_pll_4_auto_coarsetune <= pll_4_auto_coarsetune_reset_c;
      s_pll_4_enforce_lock <= pll_4_enforce_lock_reset_c;
      s_pll_4_pfd_select <= pll_4_pfd_select_reset_c;
      s_pll_4_lock_window_sel <= pll_4_lock_window_sel_reset_c;
      s_pll_4_div_core_mux_sel <= pll_4_div_core_mux_sel_reset_c;
      s_pll_4_filter_shift <= pll_4_filter_shift_reset_c;
      s_pll_4_en_fast_lock <= pll_4_en_fast_lock_reset_c;
      s_pll_5_sar_limit <= pll_5_sar_limit_reset_c;
      s_pll_5_set_op_lock <= pll_5_set_op_lock_reset_c;
      s_pll_5_disable_lock <= pll_5_disable_lock_reset_c;
      s_pll_5_ref_bypass <= pll_5_ref_bypass_reset_c;
      s_pll_5_ct_compensation <= pll_5_ct_compensation_reset_c;
      s_io_dack0_n_ste <= io_dack0_n_ste_reset_c;
      s_io_dack0_n_pd <= io_dack0_n_pd_reset_c;
      s_io_dack0_n_pu <= io_dack0_n_pu_reset_c;
      s_io_dreq0_n_ds <= io_dreq0_n_ds_reset_c;
      s_io_dreq0_n_sr <= io_dreq0_n_sr_reset_c;
      s_io_dreq0_n_co <= io_dreq0_n_co_reset_c;
      s_io_dreq0_n_odp <= io_dreq0_n_odp_reset_c;
      s_io_dreq0_n_odn <= io_dreq0_n_odn_reset_c;
      s_io_dack1_n_ste <= io_dack1_n_ste_reset_c;
      s_io_dack1_n_pd <= io_dack1_n_pd_reset_c;
      s_io_dack1_n_pu <= io_dack1_n_pu_reset_c;
      s_io_dreq1_n_ds <= io_dreq1_n_ds_reset_c;
      s_io_dreq1_n_sr <= io_dreq1_n_sr_reset_c;
      s_io_dreq1_n_co <= io_dreq1_n_co_reset_c;
      s_io_dreq1_n_odp <= io_dreq1_n_odp_reset_c;
      s_io_dreq1_n_odn <= io_dreq1_n_odn_reset_c;
      s_io_dack2_n_ste <= io_dack2_n_ste_reset_c;
      s_io_dack2_n_pd <= io_dack2_n_pd_reset_c;
      s_io_dack2_n_pu <= io_dack2_n_pu_reset_c;
      s_io_dreq2_n_ds <= io_dreq2_n_ds_reset_c;
      s_io_dreq2_n_sr <= io_dreq2_n_sr_reset_c;
      s_io_dreq2_n_co <= io_dreq2_n_co_reset_c;
      s_io_dreq2_n_odp <= io_dreq2_n_odp_reset_c;
      s_io_dreq2_n_odn <= io_dreq2_n_odn_reset_c;
      s_io_dack3_n_ste <= io_dack3_n_ste_reset_c;
      s_io_dack3_n_pd <= io_dack3_n_pd_reset_c;
      s_io_dack3_n_pu <= io_dack3_n_pu_reset_c;
      s_io_dreq3_n_ds <= io_dreq3_n_ds_reset_c;
      s_io_dreq3_n_sr <= io_dreq3_n_sr_reset_c;
      s_io_dreq3_n_co <= io_dreq3_n_co_reset_c;
      s_io_dreq3_n_odp <= io_dreq3_n_odp_reset_c;
      s_io_dreq3_n_odn <= io_dreq3_n_odn_reset_c;
      s_io_d0_out_ds <= io_d0_out_ds_reset_c;
      s_io_d0_out_sr <= io_d0_out_sr_reset_c;
      s_io_d0_out_co <= io_d0_out_co_reset_c;
      s_io_d0_out_odp <= io_d0_out_odp_reset_c;
      s_io_d0_out_odn <= io_d0_out_odn_reset_c;
      s_io_d0_in_ste <= io_d0_in_ste_reset_c;
      s_io_d0_in_pd <= io_d0_in_pd_reset_c;
      s_io_d0_in_pu <= io_d0_in_pu_reset_c;
      s_io_d1_out_ds <= io_d1_out_ds_reset_c;
      s_io_d1_out_sr <= io_d1_out_sr_reset_c;
      s_io_d1_out_co <= io_d1_out_co_reset_c;
      s_io_d1_out_odp <= io_d1_out_odp_reset_c;
      s_io_d1_out_odn <= io_d1_out_odn_reset_c;
      s_io_d1_in_ste <= io_d1_in_ste_reset_c;
      s_io_d1_in_pd <= io_d1_in_pd_reset_c;
      s_io_d1_in_pu <= io_d1_in_pu_reset_c;
      s_io_d2_out_ds <= io_d2_out_ds_reset_c;
      s_io_d2_out_sr <= io_d2_out_sr_reset_c;
      s_io_d2_out_co <= io_d2_out_co_reset_c;
      s_io_d2_out_odp <= io_d2_out_odp_reset_c;
      s_io_d2_out_odn <= io_d2_out_odn_reset_c;
      s_io_d2_in_ste <= io_d2_in_ste_reset_c;
      s_io_d2_in_pd <= io_d2_in_pd_reset_c;
      s_io_d2_in_pu <= io_d2_in_pu_reset_c;
      s_io_d3_out_ds <= io_d3_out_ds_reset_c;
      s_io_d3_out_sr <= io_d3_out_sr_reset_c;
      s_io_d3_out_co <= io_d3_out_co_reset_c;
      s_io_d3_out_odp <= io_d3_out_odp_reset_c;
      s_io_d3_out_odn <= io_d3_out_odn_reset_c;
      s_io_d3_in_ste <= io_d3_in_ste_reset_c;
      s_io_d3_in_pd <= io_d3_in_pd_reset_c;
      s_io_d3_in_pu <= io_d3_in_pu_reset_c;
      s_io_d4_out_ds <= io_d4_out_ds_reset_c;
      s_io_d4_out_sr <= io_d4_out_sr_reset_c;
      s_io_d4_out_co <= io_d4_out_co_reset_c;
      s_io_d4_out_odp <= io_d4_out_odp_reset_c;
      s_io_d4_out_odn <= io_d4_out_odn_reset_c;
      s_io_d4_in_ste <= io_d4_in_ste_reset_c;
      s_io_d4_in_pd <= io_d4_in_pd_reset_c;
      s_io_d4_in_pu <= io_d4_in_pu_reset_c;
      s_io_d5_out_ds <= io_d5_out_ds_reset_c;
      s_io_d5_out_sr <= io_d5_out_sr_reset_c;
      s_io_d5_out_co <= io_d5_out_co_reset_c;
      s_io_d5_out_odp <= io_d5_out_odp_reset_c;
      s_io_d5_out_odn <= io_d5_out_odn_reset_c;
      s_io_d5_in_ste <= io_d5_in_ste_reset_c;
      s_io_d5_in_pd <= io_d5_in_pd_reset_c;
      s_io_d5_in_pu <= io_d5_in_pu_reset_c;
      s_io_d6_out_ds <= io_d6_out_ds_reset_c;
      s_io_d6_out_sr <= io_d6_out_sr_reset_c;
      s_io_d6_out_co <= io_d6_out_co_reset_c;
      s_io_d6_out_odp <= io_d6_out_odp_reset_c;
      s_io_d6_out_odn <= io_d6_out_odn_reset_c;
      s_io_d6_in_ste <= io_d6_in_ste_reset_c;
      s_io_d6_in_pd <= io_d6_in_pd_reset_c;
      s_io_d6_in_pu <= io_d6_in_pu_reset_c;
      s_io_d7_out_ds <= io_d7_out_ds_reset_c;
      s_io_d7_out_sr <= io_d7_out_sr_reset_c;
      s_io_d7_out_co <= io_d7_out_co_reset_c;
      s_io_d7_out_odp <= io_d7_out_odp_reset_c;
      s_io_d7_out_odn <= io_d7_out_odn_reset_c;
      s_io_d7_in_ste <= io_d7_in_ste_reset_c;
      s_io_d7_in_pd <= io_d7_in_pd_reset_c;
      s_io_d7_in_pu <= io_d7_in_pu_reset_c;
      s_io_ldout_n_ds <= io_ldout_n_ds_reset_c;
      s_io_ldout_n_sr <= io_ldout_n_sr_reset_c;
      s_io_ldout_n_co <= io_ldout_n_co_reset_c;
      s_io_ldout_n_odp <= io_ldout_n_odp_reset_c;
      s_io_ldout_n_odn <= io_ldout_n_odn_reset_c;
      s_io_next_n_ds <= io_next_n_ds_reset_c;
      s_io_next_n_sr <= io_next_n_sr_reset_c;
      s_io_next_n_co <= io_next_n_co_reset_c;
      s_io_next_n_odp <= io_next_n_odp_reset_c;
      s_io_next_n_odn <= io_next_n_odn_reset_c;
      s_io_clk_ds <= io_clk_ds_reset_c;
      s_io_clk_sr <= io_clk_sr_reset_c;
      s_io_clk_co <= io_clk_co_reset_c;
      s_io_clk_odp <= io_clk_odp_reset_c;
      s_io_clk_odn <= io_clk_odn_reset_c;
      s_io_ioa_n_ds <= io_ioa_n_ds_reset_c;
      s_io_ioa_n_sr <= io_ioa_n_sr_reset_c;
      s_io_ioa_n_co <= io_ioa_n_co_reset_c;
      s_io_ioa_n_odp <= io_ioa_n_odp_reset_c;
      s_io_ioa_n_odn <= io_ioa_n_odn_reset_c;
      s_mrxout_in_ste <= mrxout_in_ste_reset_c;
      s_mrxout_in_pd <= mrxout_in_pd_reset_c;
      s_mrxout_in_pu <= mrxout_in_pu_reset_c;
    elsif clk 'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        case s_address is
          when version_address_c => 
          when mclkout_address_c => 
            if write_cmd = '1' then
              s_mclkout_ds <= data_in(mclkout_ds_msb_c downto mclkout_ds_lsb_c);
              s_mclkout_sr <= data_in(mclkout_sr_msb_c);
              s_mclkout_co <= data_in(mclkout_co_msb_c);
              s_mclkout_odp <= data_in(mclkout_odp_msb_c);
              s_mclkout_odn <= data_in(mclkout_odn_msb_c);
            end if;
          when msdout_address_c => 
            if write_cmd = '1' then
              s_msdout_ds <= data_in(msdout_ds_msb_c downto msdout_ds_lsb_c);
              s_msdout_sr <= data_in(msdout_sr_msb_c);
              s_msdout_co <= data_in(msdout_co_msb_c);
              s_msdout_odp <= data_in(msdout_odp_msb_c);
              s_msdout_odn <= data_in(msdout_odn_msb_c);
            end if;
          when utx_address_c => 
            if write_cmd = '1' then
              s_utx_ds <= data_in(utx_ds_msb_c downto utx_ds_lsb_c);
              s_utx_sr <= data_in(utx_sr_msb_c);
              s_utx_co <= data_in(utx_co_msb_c);
              s_utx_odp <= data_in(utx_odp_msb_c);
              s_utx_odn <= data_in(utx_odn_msb_c);
            end if;
          when mirqout_address_c => 
            if write_cmd = '1' then
              s_mirqout_ds <= data_in(mirqout_ds_msb_c downto mirqout_ds_lsb_c);
              s_mirqout_sr <= data_in(mirqout_sr_msb_c);
              s_mirqout_co <= data_in(mirqout_co_msb_c);
              s_mirqout_odp <= data_in(mirqout_odp_msb_c);
              s_mirqout_odn <= data_in(mirqout_odn_msb_c);
            end if;
          when msdin_address_c => 
            if write_cmd = '1' then
              s_msdin_ste <= data_in(msdin_ste_msb_c downto msdin_ste_lsb_c);
              s_msdin_pd <= data_in(msdin_pd_msb_c);
              s_msdin_pu <= data_in(msdin_pu_msb_c);
            end if;
          when mirq0_address_c => 
            if write_cmd = '1' then
              s_mirq0_ste <= data_in(mirq0_ste_msb_c downto mirq0_ste_lsb_c);
              s_mirq0_pd <= data_in(mirq0_pd_msb_c);
              s_mirq0_pu <= data_in(mirq0_pu_msb_c);
            end if;
          when mirq1_address_c => 
            if write_cmd = '1' then
              s_mirq1_ste <= data_in(mirq1_ste_msb_c downto mirq1_ste_lsb_c);
              s_mirq1_pd <= data_in(mirq1_pd_msb_c);
              s_mirq1_pu <= data_in(mirq1_pu_msb_c);
            end if;
          when urx_address_c => 
            if write_cmd = '1' then
              s_urx_ste <= data_in(urx_ste_msb_c downto urx_ste_lsb_c);
              s_urx_pd <= data_in(urx_pd_msb_c);
              s_urx_pu <= data_in(urx_pu_msb_c);
            end if;
          when emem_d0_out_address_c => 
            if write_cmd = '1' then
              s_emem_d0_out_ds <= data_in(emem_d0_out_ds_msb_c downto emem_d0_out_ds_lsb_c);
              s_emem_d0_out_sr <= data_in(emem_d0_out_sr_msb_c);
              s_emem_d0_out_co <= data_in(emem_d0_out_co_msb_c);
              s_emem_d0_out_odp <= data_in(emem_d0_out_odp_msb_c);
              s_emem_d0_out_odn <= data_in(emem_d0_out_odn_msb_c);
            end if;
          when emem_d0_in_address_c => 
            if write_cmd = '1' then
              s_emem_d0_in_ste <= data_in(emem_d0_in_ste_msb_c downto emem_d0_in_ste_lsb_c);
              s_emem_d0_in_pd <= data_in(emem_d0_in_pd_msb_c);
              s_emem_d0_in_pu <= data_in(emem_d0_in_pu_msb_c);
            end if;
          when emem_d1_out_address_c => 
            if write_cmd = '1' then
              s_emem_d1_out_ds <= data_in(emem_d1_out_ds_msb_c downto emem_d1_out_ds_lsb_c);
              s_emem_d1_out_sr <= data_in(emem_d1_out_sr_msb_c);
              s_emem_d1_out_co <= data_in(emem_d1_out_co_msb_c);
              s_emem_d1_out_odp <= data_in(emem_d1_out_odp_msb_c);
              s_emem_d1_out_odn <= data_in(emem_d1_out_odn_msb_c);
            end if;
          when emem_d1_in_address_c => 
            if write_cmd = '1' then
              s_emem_d1_in_ste <= data_in(emem_d1_in_ste_msb_c downto emem_d1_in_ste_lsb_c);
              s_emem_d1_in_pd <= data_in(emem_d1_in_pd_msb_c);
              s_emem_d1_in_pu <= data_in(emem_d1_in_pu_msb_c);
            end if;
          when emem_d2_out_address_c => 
            if write_cmd = '1' then
              s_emem_d2_out_ds <= data_in(emem_d2_out_ds_msb_c downto emem_d2_out_ds_lsb_c);
              s_emem_d2_out_sr <= data_in(emem_d2_out_sr_msb_c);
              s_emem_d2_out_co <= data_in(emem_d2_out_co_msb_c);
              s_emem_d2_out_odp <= data_in(emem_d2_out_odp_msb_c);
              s_emem_d2_out_odn <= data_in(emem_d2_out_odn_msb_c);
            end if;
          when emem_d2_in_address_c => 
            if write_cmd = '1' then
              s_emem_d2_in_ste <= data_in(emem_d2_in_ste_msb_c downto emem_d2_in_ste_lsb_c);
              s_emem_d2_in_pd <= data_in(emem_d2_in_pd_msb_c);
              s_emem_d2_in_pu <= data_in(emem_d2_in_pu_msb_c);
            end if;
          when emem_d3_out_address_c => 
            if write_cmd = '1' then
              s_emem_d3_out_ds <= data_in(emem_d3_out_ds_msb_c downto emem_d3_out_ds_lsb_c);
              s_emem_d3_out_sr <= data_in(emem_d3_out_sr_msb_c);
              s_emem_d3_out_co <= data_in(emem_d3_out_co_msb_c);
              s_emem_d3_out_odp <= data_in(emem_d3_out_odp_msb_c);
              s_emem_d3_out_odn <= data_in(emem_d3_out_odn_msb_c);
            end if;
          when emem_d3_in_address_c => 
            if write_cmd = '1' then
              s_emem_d3_in_ste <= data_in(emem_d3_in_ste_msb_c downto emem_d3_in_ste_lsb_c);
              s_emem_d3_in_pd <= data_in(emem_d3_in_pd_msb_c);
              s_emem_d3_in_pu <= data_in(emem_d3_in_pu_msb_c);
            end if;
          when emem_d4_out_address_c => 
            if write_cmd = '1' then
              s_emem_d4_out_ds <= data_in(emem_d4_out_ds_msb_c downto emem_d4_out_ds_lsb_c);
              s_emem_d4_out_sr <= data_in(emem_d4_out_sr_msb_c);
              s_emem_d4_out_co <= data_in(emem_d4_out_co_msb_c);
              s_emem_d4_out_odp <= data_in(emem_d4_out_odp_msb_c);
              s_emem_d4_out_odn <= data_in(emem_d4_out_odn_msb_c);
            end if;
          when emem_d4_in_address_c => 
            if write_cmd = '1' then
              s_emem_d4_in_ste <= data_in(emem_d4_in_ste_msb_c downto emem_d4_in_ste_lsb_c);
              s_emem_d4_in_pd <= data_in(emem_d4_in_pd_msb_c);
              s_emem_d4_in_pu <= data_in(emem_d4_in_pu_msb_c);
            end if;
          when emem_d5_out_address_c => 
            if write_cmd = '1' then
              s_emem_d5_out_ds <= data_in(emem_d5_out_ds_msb_c downto emem_d5_out_ds_lsb_c);
              s_emem_d5_out_sr <= data_in(emem_d5_out_sr_msb_c);
              s_emem_d5_out_co <= data_in(emem_d5_out_co_msb_c);
              s_emem_d5_out_odp <= data_in(emem_d5_out_odp_msb_c);
              s_emem_d5_out_odn <= data_in(emem_d5_out_odn_msb_c);
            end if;
          when emem_d5_in_address_c => 
            if write_cmd = '1' then
              s_emem_d5_in_ste <= data_in(emem_d5_in_ste_msb_c downto emem_d5_in_ste_lsb_c);
              s_emem_d5_in_pd <= data_in(emem_d5_in_pd_msb_c);
              s_emem_d5_in_pu <= data_in(emem_d5_in_pu_msb_c);
            end if;
          when emem_d6_out_address_c => 
            if write_cmd = '1' then
              s_emem_d6_out_ds <= data_in(emem_d6_out_ds_msb_c downto emem_d6_out_ds_lsb_c);
              s_emem_d6_out_sr <= data_in(emem_d6_out_sr_msb_c);
              s_emem_d6_out_co <= data_in(emem_d6_out_co_msb_c);
              s_emem_d6_out_odp <= data_in(emem_d6_out_odp_msb_c);
              s_emem_d6_out_odn <= data_in(emem_d6_out_odn_msb_c);
            end if;
          when emem_d6_in_address_c => 
            if write_cmd = '1' then
              s_emem_d6_in_ste <= data_in(emem_d6_in_ste_msb_c downto emem_d6_in_ste_lsb_c);
              s_emem_d6_in_pd <= data_in(emem_d6_in_pd_msb_c);
              s_emem_d6_in_pu <= data_in(emem_d6_in_pu_msb_c);
            end if;
          when emem_d7_out_address_c => 
            if write_cmd = '1' then
              s_emem_d7_out_ds <= data_in(emem_d7_out_ds_msb_c downto emem_d7_out_ds_lsb_c);
              s_emem_d7_out_sr <= data_in(emem_d7_out_sr_msb_c);
              s_emem_d7_out_co <= data_in(emem_d7_out_co_msb_c);
              s_emem_d7_out_odp <= data_in(emem_d7_out_odp_msb_c);
              s_emem_d7_out_odn <= data_in(emem_d7_out_odn_msb_c);
            end if;
          when emem_d7_in_address_c => 
            if write_cmd = '1' then
              s_emem_d7_in_ste <= data_in(emem_d7_in_ste_msb_c downto emem_d7_in_ste_lsb_c);
              s_emem_d7_in_pd <= data_in(emem_d7_in_pd_msb_c);
              s_emem_d7_in_pu <= data_in(emem_d7_in_pu_msb_c);
            end if;
          when emem_clk_address_c => 
            if write_cmd = '1' then
              s_emem_clk_ds <= data_in(emem_clk_ds_msb_c downto emem_clk_ds_lsb_c);
              s_emem_clk_sr <= data_in(emem_clk_sr_msb_c);
              s_emem_clk_co <= data_in(emem_clk_co_msb_c);
              s_emem_clk_odp <= data_in(emem_clk_odp_msb_c);
              s_emem_clk_odn <= data_in(emem_clk_odn_msb_c);
            end if;
          when emem_rwds_out_address_c => 
            if write_cmd = '1' then
              s_emem_rwds_out_ds <= data_in(emem_rwds_out_ds_msb_c downto emem_rwds_out_ds_lsb_c);
              s_emem_rwds_out_sr <= data_in(emem_rwds_out_sr_msb_c);
              s_emem_rwds_out_co <= data_in(emem_rwds_out_co_msb_c);
              s_emem_rwds_out_odp <= data_in(emem_rwds_out_odp_msb_c);
              s_emem_rwds_out_odn <= data_in(emem_rwds_out_odn_msb_c);
            end if;
          when emem_rwds_in_address_c => 
            if write_cmd = '1' then
              s_emem_rwds_in_ste <= data_in(emem_rwds_in_ste_msb_c downto emem_rwds_in_ste_lsb_c);
              s_emem_rwds_in_pd <= data_in(emem_rwds_in_pd_msb_c);
              s_emem_rwds_in_pu <= data_in(emem_rwds_in_pu_msb_c);
            end if;
          when emem_cs_n_address_c => 
            if write_cmd = '1' then
              s_emem_cs_n_ds <= data_in(emem_cs_n_ds_msb_c downto emem_cs_n_ds_lsb_c);
              s_emem_cs_n_sr <= data_in(emem_cs_n_sr_msb_c);
              s_emem_cs_n_co <= data_in(emem_cs_n_co_msb_c);
              s_emem_cs_n_odp <= data_in(emem_cs_n_odp_msb_c);
              s_emem_cs_n_odn <= data_in(emem_cs_n_odn_msb_c);
            end if;
          when emem_rst_n_address_c => 
            if write_cmd = '1' then
              s_emem_rst_n_ds <= data_in(emem_rst_n_ds_msb_c downto emem_rst_n_ds_lsb_c);
              s_emem_rst_n_sr <= data_in(emem_rst_n_sr_msb_c);
              s_emem_rst_n_co <= data_in(emem_rst_n_co_msb_c);
              s_emem_rst_n_odp <= data_in(emem_rst_n_odp_msb_c);
              s_emem_rst_n_odn <= data_in(emem_rst_n_odn_msb_c);
            end if;
          when aout0_address_c => 
            if write_cmd = '1' then
              s_aout0_ds <= data_in(aout0_ds_msb_c downto aout0_ds_lsb_c);
              s_aout0_sr <= data_in(aout0_sr_msb_c);
              s_aout0_co <= data_in(aout0_co_msb_c);
              s_aout0_odp <= data_in(aout0_odp_msb_c);
              s_aout0_odn <= data_in(aout0_odn_msb_c);
            end if;
          when aout1_address_c => 
            if write_cmd = '1' then
              s_aout1_ds <= data_in(aout1_ds_msb_c downto aout1_ds_lsb_c);
              s_aout1_sr <= data_in(aout1_sr_msb_c);
              s_aout1_co <= data_in(aout1_co_msb_c);
              s_aout1_odp <= data_in(aout1_odp_msb_c);
              s_aout1_odn <= data_in(aout1_odn_msb_c);
            end if;
          when ach0_address_c => 
            if write_cmd = '1' then
              s_ach0_ste <= data_in(ach0_ste_msb_c downto ach0_ste_lsb_c);
              s_ach0_pd <= data_in(ach0_pd_msb_c);
              s_ach0_pu <= data_in(ach0_pu_msb_c);
            end if;
          when enet_mdio_out_address_c => 
            if write_cmd = '1' then
              s_enet_mdio_out_ds <= data_in(enet_mdio_out_ds_msb_c downto enet_mdio_out_ds_lsb_c);
              s_enet_mdio_out_sr <= data_in(enet_mdio_out_sr_msb_c);
              s_enet_mdio_out_co <= data_in(enet_mdio_out_co_msb_c);
              s_enet_mdio_out_odp <= data_in(enet_mdio_out_odp_msb_c);
              s_enet_mdio_out_odn <= data_in(enet_mdio_out_odn_msb_c);
            end if;
          when enet_mdio_in_address_c => 
            if write_cmd = '1' then
              s_enet_mdio_in_ste <= data_in(enet_mdio_in_ste_msb_c downto enet_mdio_in_ste_lsb_c);
              s_enet_mdio_in_pd <= data_in(enet_mdio_in_pd_msb_c);
              s_enet_mdio_in_pu <= data_in(enet_mdio_in_pu_msb_c);
            end if;
          when enet_mdc_address_c => 
            if write_cmd = '1' then
              s_enet_mdc_ds <= data_in(enet_mdc_ds_msb_c downto enet_mdc_ds_lsb_c);
              s_enet_mdc_sr <= data_in(enet_mdc_sr_msb_c);
              s_enet_mdc_co <= data_in(enet_mdc_co_msb_c);
              s_enet_mdc_odp <= data_in(enet_mdc_odp_msb_c);
              s_enet_mdc_odn <= data_in(enet_mdc_odn_msb_c);
            end if;
          when enet_txer_address_c => 
            if write_cmd = '1' then
              s_enet_txer_ds <= data_in(enet_txer_ds_msb_c downto enet_txer_ds_lsb_c);
              s_enet_txer_sr <= data_in(enet_txer_sr_msb_c);
              s_enet_txer_co <= data_in(enet_txer_co_msb_c);
              s_enet_txer_odp <= data_in(enet_txer_odp_msb_c);
              s_enet_txer_odn <= data_in(enet_txer_odn_msb_c);
            end if;
          when enet_txd0_address_c => 
            if write_cmd = '1' then
              s_enet_txd0_ds <= data_in(enet_txd0_ds_msb_c downto enet_txd0_ds_lsb_c);
              s_enet_txd0_sr <= data_in(enet_txd0_sr_msb_c);
              s_enet_txd0_co <= data_in(enet_txd0_co_msb_c);
              s_enet_txd0_odp <= data_in(enet_txd0_odp_msb_c);
              s_enet_txd0_odn <= data_in(enet_txd0_odn_msb_c);
            end if;
          when enet_txd1_address_c => 
            if write_cmd = '1' then
              s_enet_txd1_ds <= data_in(enet_txd1_ds_msb_c downto enet_txd1_ds_lsb_c);
              s_enet_txd1_sr <= data_in(enet_txd1_sr_msb_c);
              s_enet_txd1_co <= data_in(enet_txd1_co_msb_c);
              s_enet_txd1_odp <= data_in(enet_txd1_odp_msb_c);
              s_enet_txd1_odn <= data_in(enet_txd1_odn_msb_c);
            end if;
          when enet_txen_address_c => 
            if write_cmd = '1' then
              s_enet_txen_ds <= data_in(enet_txen_ds_msb_c downto enet_txen_ds_lsb_c);
              s_enet_txen_sr <= data_in(enet_txen_sr_msb_c);
              s_enet_txen_co <= data_in(enet_txen_co_msb_c);
              s_enet_txen_odp <= data_in(enet_txen_odp_msb_c);
              s_enet_txen_odn <= data_in(enet_txen_odn_msb_c);
            end if;
          when enet_clk_address_c => 
            if write_cmd = '1' then
              s_enet_clk_ste <= data_in(enet_clk_ste_msb_c downto enet_clk_ste_lsb_c);
              s_enet_clk_pd <= data_in(enet_clk_pd_msb_c);
              s_enet_clk_pu <= data_in(enet_clk_pu_msb_c);
            end if;
          when enet_rxdv_address_c => 
            if write_cmd = '1' then
              s_enet_rxdv_ste <= data_in(enet_rxdv_ste_msb_c downto enet_rxdv_ste_lsb_c);
              s_enet_rxdv_pd <= data_in(enet_rxdv_pd_msb_c);
              s_enet_rxdv_pu <= data_in(enet_rxdv_pu_msb_c);
            end if;
          when enet_rxd0_address_c => 
            if write_cmd = '1' then
              s_enet_rxd0_ste <= data_in(enet_rxd0_ste_msb_c downto enet_rxd0_ste_lsb_c);
              s_enet_rxd0_pd <= data_in(enet_rxd0_pd_msb_c);
              s_enet_rxd0_pu <= data_in(enet_rxd0_pu_msb_c);
            end if;
          when enet_rxd1_address_c => 
            if write_cmd = '1' then
              s_enet_rxd1_ste <= data_in(enet_rxd1_ste_msb_c downto enet_rxd1_ste_lsb_c);
              s_enet_rxd1_pd <= data_in(enet_rxd1_pd_msb_c);
              s_enet_rxd1_pu <= data_in(enet_rxd1_pu_msb_c);
            end if;
          when enet_rxer_address_c => 
            if write_cmd = '1' then
              s_enet_rxer_ste <= data_in(enet_rxer_ste_msb_c downto enet_rxer_ste_lsb_c);
              s_enet_rxer_pd <= data_in(enet_rxer_pd_msb_c);
              s_enet_rxer_pu <= data_in(enet_rxer_pu_msb_c);
            end if;
          when spi_sclk_address_c => 
            if write_cmd = '1' then
              s_spi_sclk_ste <= data_in(spi_sclk_ste_msb_c downto spi_sclk_ste_lsb_c);
              s_spi_sclk_pd <= data_in(spi_sclk_pd_msb_c);
              s_spi_sclk_pu <= data_in(spi_sclk_pu_msb_c);
            end if;
          when spi_cs_n_address_c => 
            if write_cmd = '1' then
              s_spi_cs_n_ste <= data_in(spi_cs_n_ste_msb_c downto spi_cs_n_ste_lsb_c);
              s_spi_cs_n_pd <= data_in(spi_cs_n_pd_msb_c);
              s_spi_cs_n_pu <= data_in(spi_cs_n_pu_msb_c);
            end if;
          when spi_mosi_address_c => 
            if write_cmd = '1' then
              s_spi_mosi_ste <= data_in(spi_mosi_ste_msb_c downto spi_mosi_ste_lsb_c);
              s_spi_mosi_pd <= data_in(spi_mosi_pd_msb_c);
              s_spi_mosi_pu <= data_in(spi_mosi_pu_msb_c);
            end if;
          when spi_miso_address_c => 
            if write_cmd = '1' then
              s_spi_miso_ds <= data_in(spi_miso_ds_msb_c downto spi_miso_ds_lsb_c);
              s_spi_miso_sr <= data_in(spi_miso_sr_msb_c);
              s_spi_miso_co <= data_in(spi_miso_co_msb_c);
              s_spi_miso_odp <= data_in(spi_miso_odp_msb_c);
              s_spi_miso_odn <= data_in(spi_miso_odn_msb_c);
            end if;
          when pll_ref_clk_address_c => 
            if write_cmd = '1' then
              s_pll_ref_clk_ste <= data_in(pll_ref_clk_ste_msb_c downto pll_ref_clk_ste_lsb_c);
              s_pll_ref_clk_pd <= data_in(pll_ref_clk_pd_msb_c);
              s_pll_ref_clk_pu <= data_in(pll_ref_clk_pu_msb_c);
            end if;
          when pa0_sin_out_address_c => 
            if write_cmd = '1' then
              s_pa0_sin_out_ds <= data_in(pa0_sin_out_ds_msb_c downto pa0_sin_out_ds_lsb_c);
              s_pa0_sin_out_sr <= data_in(pa0_sin_out_sr_msb_c);
              s_pa0_sin_out_co <= data_in(pa0_sin_out_co_msb_c);
              s_pa0_sin_out_odp <= data_in(pa0_sin_out_odp_msb_c);
              s_pa0_sin_out_odn <= data_in(pa0_sin_out_odn_msb_c);
            end if;
          when pa0_sin_in_address_c => 
            if write_cmd = '1' then
              s_pa0_sin_in_ste <= data_in(pa0_sin_in_ste_msb_c downto pa0_sin_in_ste_lsb_c);
              s_pa0_sin_in_pd <= data_in(pa0_sin_in_pd_msb_c);
              s_pa0_sin_in_pu <= data_in(pa0_sin_in_pu_msb_c);
            end if;
          when pa5_cs_n_out_address_c => 
            if write_cmd = '1' then
              s_pa5_cs_n_out_ds <= data_in(pa5_cs_n_out_ds_msb_c downto pa5_cs_n_out_ds_lsb_c);
              s_pa5_cs_n_out_sr <= data_in(pa5_cs_n_out_sr_msb_c);
              s_pa5_cs_n_out_co <= data_in(pa5_cs_n_out_co_msb_c);
              s_pa5_cs_n_out_odp <= data_in(pa5_cs_n_out_odp_msb_c);
              s_pa5_cs_n_out_odn <= data_in(pa5_cs_n_out_odn_msb_c);
            end if;
          when pa5_cs_n_in_address_c => 
            if write_cmd = '1' then
              s_pa5_cs_n_in_ste <= data_in(pa5_cs_n_in_ste_msb_c downto pa5_cs_n_in_ste_lsb_c);
              s_pa5_cs_n_in_pd <= data_in(pa5_cs_n_in_pd_msb_c);
              s_pa5_cs_n_in_pu <= data_in(pa5_cs_n_in_pu_msb_c);
            end if;
          when pa6_sck_out_address_c => 
            if write_cmd = '1' then
              s_pa6_sck_out_ds <= data_in(pa6_sck_out_ds_msb_c downto pa6_sck_out_ds_lsb_c);
              s_pa6_sck_out_sr <= data_in(pa6_sck_out_sr_msb_c);
              s_pa6_sck_out_co <= data_in(pa6_sck_out_co_msb_c);
              s_pa6_sck_out_odp <= data_in(pa6_sck_out_odp_msb_c);
              s_pa6_sck_out_odn <= data_in(pa6_sck_out_odn_msb_c);
            end if;
          when pa6_sck_in_address_c => 
            if write_cmd = '1' then
              s_pa6_sck_in_ste <= data_in(pa6_sck_in_ste_msb_c downto pa6_sck_in_ste_lsb_c);
              s_pa6_sck_in_pd <= data_in(pa6_sck_in_pd_msb_c);
              s_pa6_sck_in_pu <= data_in(pa6_sck_in_pu_msb_c);
            end if;
          when pa7_sout_out_address_c => 
            if write_cmd = '1' then
              s_pa7_sout_out_ds <= data_in(pa7_sout_out_ds_msb_c downto pa7_sout_out_ds_lsb_c);
              s_pa7_sout_out_sr <= data_in(pa7_sout_out_sr_msb_c);
              s_pa7_sout_out_co <= data_in(pa7_sout_out_co_msb_c);
              s_pa7_sout_out_odp <= data_in(pa7_sout_out_odp_msb_c);
              s_pa7_sout_out_odn <= data_in(pa7_sout_out_odn_msb_c);
            end if;
          when pa7_sout_in_address_c => 
            if write_cmd = '1' then
              s_pa7_sout_in_ste <= data_in(pa7_sout_in_ste_msb_c downto pa7_sout_in_ste_lsb_c);
              s_pa7_sout_in_pd <= data_in(pa7_sout_in_pd_msb_c);
              s_pa7_sout_in_pu <= data_in(pa7_sout_in_pu_msb_c);
            end if;
          when pg0_out_address_c => 
            if write_cmd = '1' then
              s_pg0_out_ds <= data_in(pg0_out_ds_msb_c downto pg0_out_ds_lsb_c);
              s_pg0_out_sr <= data_in(pg0_out_sr_msb_c);
              s_pg0_out_co <= data_in(pg0_out_co_msb_c);
              s_pg0_out_odp <= data_in(pg0_out_odp_msb_c);
              s_pg0_out_odn <= data_in(pg0_out_odn_msb_c);
            end if;
          when pg0_in_address_c => 
            if write_cmd = '1' then
              s_pg0_in_ste <= data_in(pg0_in_ste_msb_c downto pg0_in_ste_lsb_c);
              s_pg0_in_pd <= data_in(pg0_in_pd_msb_c);
              s_pg0_in_pu <= data_in(pg0_in_pu_msb_c);
            end if;
          when pg1_out_address_c => 
            if write_cmd = '1' then
              s_pg1_out_ds <= data_in(pg1_out_ds_msb_c downto pg1_out_ds_lsb_c);
              s_pg1_out_sr <= data_in(pg1_out_sr_msb_c);
              s_pg1_out_co <= data_in(pg1_out_co_msb_c);
              s_pg1_out_odp <= data_in(pg1_out_odp_msb_c);
              s_pg1_out_odn <= data_in(pg1_out_odn_msb_c);
            end if;
          when pg1_in_address_c => 
            if write_cmd = '1' then
              s_pg1_in_ste <= data_in(pg1_in_ste_msb_c downto pg1_in_ste_lsb_c);
              s_pg1_in_pd <= data_in(pg1_in_pd_msb_c);
              s_pg1_in_pu <= data_in(pg1_in_pu_msb_c);
            end if;
          when pg2_out_address_c => 
            if write_cmd = '1' then
              s_pg2_out_ds <= data_in(pg2_out_ds_msb_c downto pg2_out_ds_lsb_c);
              s_pg2_out_sr <= data_in(pg2_out_sr_msb_c);
              s_pg2_out_co <= data_in(pg2_out_co_msb_c);
              s_pg2_out_odp <= data_in(pg2_out_odp_msb_c);
              s_pg2_out_odn <= data_in(pg2_out_odn_msb_c);
            end if;
          when pg2_in_address_c => 
            if write_cmd = '1' then
              s_pg2_in_ste <= data_in(pg2_in_ste_msb_c downto pg2_in_ste_lsb_c);
              s_pg2_in_pd <= data_in(pg2_in_pd_msb_c);
              s_pg2_in_pu <= data_in(pg2_in_pu_msb_c);
            end if;
          when pg3_out_address_c => 
            if write_cmd = '1' then
              s_pg3_out_ds <= data_in(pg3_out_ds_msb_c downto pg3_out_ds_lsb_c);
              s_pg3_out_sr <= data_in(pg3_out_sr_msb_c);
              s_pg3_out_co <= data_in(pg3_out_co_msb_c);
              s_pg3_out_odp <= data_in(pg3_out_odp_msb_c);
              s_pg3_out_odn <= data_in(pg3_out_odn_msb_c);
            end if;
          when pg3_in_address_c => 
            if write_cmd = '1' then
              s_pg3_in_ste <= data_in(pg3_in_ste_msb_c downto pg3_in_ste_lsb_c);
              s_pg3_in_pd <= data_in(pg3_in_pd_msb_c);
              s_pg3_in_pu <= data_in(pg3_in_pu_msb_c);
            end if;
          when pg4_out_address_c => 
            if write_cmd = '1' then
              s_pg4_out_ds <= data_in(pg4_out_ds_msb_c downto pg4_out_ds_lsb_c);
              s_pg4_out_sr <= data_in(pg4_out_sr_msb_c);
              s_pg4_out_co <= data_in(pg4_out_co_msb_c);
              s_pg4_out_odp <= data_in(pg4_out_odp_msb_c);
              s_pg4_out_odn <= data_in(pg4_out_odn_msb_c);
            end if;
          when pg4_in_address_c => 
            if write_cmd = '1' then
              s_pg4_in_ste <= data_in(pg4_in_ste_msb_c downto pg4_in_ste_lsb_c);
              s_pg4_in_pd <= data_in(pg4_in_pd_msb_c);
              s_pg4_in_pu <= data_in(pg4_in_pu_msb_c);
            end if;
          when pg5_out_address_c => 
            if write_cmd = '1' then
              s_pg5_out_ds <= data_in(pg5_out_ds_msb_c downto pg5_out_ds_lsb_c);
              s_pg5_out_sr <= data_in(pg5_out_sr_msb_c);
              s_pg5_out_co <= data_in(pg5_out_co_msb_c);
              s_pg5_out_odp <= data_in(pg5_out_odp_msb_c);
              s_pg5_out_odn <= data_in(pg5_out_odn_msb_c);
            end if;
          when pg5_in_address_c => 
            if write_cmd = '1' then
              s_pg5_in_ste <= data_in(pg5_in_ste_msb_c downto pg5_in_ste_lsb_c);
              s_pg5_in_pd <= data_in(pg5_in_pd_msb_c);
              s_pg5_in_pu <= data_in(pg5_in_pu_msb_c);
            end if;
          when pg6_out_address_c => 
            if write_cmd = '1' then
              s_pg6_out_ds <= data_in(pg6_out_ds_msb_c downto pg6_out_ds_lsb_c);
              s_pg6_out_sr <= data_in(pg6_out_sr_msb_c);
              s_pg6_out_co <= data_in(pg6_out_co_msb_c);
              s_pg6_out_odp <= data_in(pg6_out_odp_msb_c);
              s_pg6_out_odn <= data_in(pg6_out_odn_msb_c);
            end if;
          when pg6_in_address_c => 
            if write_cmd = '1' then
              s_pg6_in_ste <= data_in(pg6_in_ste_msb_c downto pg6_in_ste_lsb_c);
              s_pg6_in_pd <= data_in(pg6_in_pd_msb_c);
              s_pg6_in_pu <= data_in(pg6_in_pu_msb_c);
            end if;
          when pg7_out_address_c => 
            if write_cmd = '1' then
              s_pg7_out_ds <= data_in(pg7_out_ds_msb_c downto pg7_out_ds_lsb_c);
              s_pg7_out_sr <= data_in(pg7_out_sr_msb_c);
              s_pg7_out_co <= data_in(pg7_out_co_msb_c);
              s_pg7_out_odp <= data_in(pg7_out_odp_msb_c);
              s_pg7_out_odn <= data_in(pg7_out_odn_msb_c);
            end if;
          when pg7_in_address_c => 
            if write_cmd = '1' then
              s_pg7_in_ste <= data_in(pg7_in_ste_msb_c downto pg7_in_ste_lsb_c);
              s_pg7_in_pd <= data_in(pg7_in_pd_msb_c);
              s_pg7_in_pu <= data_in(pg7_in_pu_msb_c);
            end if;
          when mtest_address_c => 
            if write_cmd = '1' then
              s_mtest_ste <= data_in(mtest_ste_msb_c downto mtest_ste_lsb_c);
              s_mtest_pd <= data_in(mtest_pd_msb_c);
              s_mtest_pu <= data_in(mtest_pu_msb_c);
            end if;
          when mwake_address_c => 
            if write_cmd = '1' then
              s_mwake_ste <= data_in(mwake_ste_msb_c downto mwake_ste_lsb_c);
              s_mwake_pd <= data_in(mwake_pd_msb_c);
              s_mwake_pu <= data_in(mwake_pu_msb_c);
            end if;
          when mrxout_out_address_c => 
            if write_cmd = '1' then
              s_mrxout_out_ds <= data_in(mrxout_out_ds_msb_c downto mrxout_out_ds_lsb_c);
              s_mrxout_out_sr <= data_in(mrxout_out_sr_msb_c);
              s_mrxout_out_co <= data_in(mrxout_out_co_msb_c);
              s_mrxout_out_odp <= data_in(mrxout_out_odp_msb_c);
              s_mrxout_out_odn <= data_in(mrxout_out_odn_msb_c);
            end if;
          when pll_1_address_c => 
            if write_cmd = '1' then
              s_pll_1_main_div_n1 <= data_in(pll_1_main_div_n1_msb_c);
              s_pll_1_main_div_n2 <= data_in(pll_1_main_div_n2_msb_c downto pll_1_main_div_n2_lsb_c);
              s_pll_1_main_div_n3 <= data_in(pll_1_main_div_n3_msb_c downto pll_1_main_div_n3_lsb_c);
              s_pll_1_main_div_n4 <= data_in(pll_1_main_div_n4_msb_c downto pll_1_main_div_n4_lsb_c);
            end if;
          when pll_2_address_c => 
            if write_cmd = '1' then
              s_pll_2_open_loop <= data_in(pll_2_open_loop_msb_c);
              s_pll_2_out_div_sel <= data_in(pll_2_out_div_sel_msb_c downto pll_2_out_div_sel_lsb_c);
              s_pll_2_ci <= data_in(pll_2_ci_msb_c downto pll_2_ci_lsb_c);
            end if;
          when pll_cp_address_c => 
            if write_cmd = '1' then
              s_pll_cp_cp <= data_in(pll_cp_cp_msb_c downto pll_cp_cp_lsb_c);
            end if;
          when pll_ft_address_c => 
            if write_cmd = '1' then
              s_pll_ft_ft <= data_in(pll_ft_ft_msb_c downto pll_ft_ft_lsb_c);
            end if;
          when pll_3_address_c => 
            if write_cmd = '1' then
              s_pll_3_divcore_sel <= data_in(pll_3_divcore_sel_msb_c downto pll_3_divcore_sel_lsb_c);
              s_pll_3_coarse <= data_in(pll_3_coarse_msb_c downto pll_3_coarse_lsb_c);
            end if;
          when pll_4_address_c => 
            if write_cmd = '1' then
              s_pll_4_auto_coarsetune <= data_in(pll_4_auto_coarsetune_msb_c);
              s_pll_4_enforce_lock <= data_in(pll_4_enforce_lock_msb_c);
              s_pll_4_pfd_select <= data_in(pll_4_pfd_select_msb_c);
              s_pll_4_lock_window_sel <= data_in(pll_4_lock_window_sel_msb_c);
              s_pll_4_div_core_mux_sel <= data_in(pll_4_div_core_mux_sel_msb_c);
              s_pll_4_filter_shift <= data_in(pll_4_filter_shift_msb_c downto pll_4_filter_shift_lsb_c);
              s_pll_4_en_fast_lock <= data_in(pll_4_en_fast_lock_msb_c);
            end if;
          when pll_5_address_c => 
            if write_cmd = '1' then
              s_pll_5_sar_limit <= data_in(pll_5_sar_limit_msb_c downto pll_5_sar_limit_lsb_c);
              s_pll_5_set_op_lock <= data_in(pll_5_set_op_lock_msb_c);
              s_pll_5_disable_lock <= data_in(pll_5_disable_lock_msb_c);
              s_pll_5_ref_bypass <= data_in(pll_5_ref_bypass_msb_c);
              s_pll_5_ct_compensation <= data_in(pll_5_ct_compensation_msb_c);
            end if;
          when adpll_status0_address_c => 
          when adpll_status1_address_c => 
          when adpll_status2_address_c => 
          when io_dack0_n_address_c => 
            if write_cmd = '1' then
              s_io_dack0_n_ste <= data_in(io_dack0_n_ste_msb_c downto io_dack0_n_ste_lsb_c);
              s_io_dack0_n_pd <= data_in(io_dack0_n_pd_msb_c);
              s_io_dack0_n_pu <= data_in(io_dack0_n_pu_msb_c);
            end if;
          when io_dreq0_n_address_c => 
            if write_cmd = '1' then
              s_io_dreq0_n_ds <= data_in(io_dreq0_n_ds_msb_c downto io_dreq0_n_ds_lsb_c);
              s_io_dreq0_n_sr <= data_in(io_dreq0_n_sr_msb_c);
              s_io_dreq0_n_co <= data_in(io_dreq0_n_co_msb_c);
              s_io_dreq0_n_odp <= data_in(io_dreq0_n_odp_msb_c);
              s_io_dreq0_n_odn <= data_in(io_dreq0_n_odn_msb_c);
            end if;
          when io_dack1_n_address_c => 
            if write_cmd = '1' then
              s_io_dack1_n_ste <= data_in(io_dack1_n_ste_msb_c downto io_dack1_n_ste_lsb_c);
              s_io_dack1_n_pd <= data_in(io_dack1_n_pd_msb_c);
              s_io_dack1_n_pu <= data_in(io_dack1_n_pu_msb_c);
            end if;
          when io_dreq1_n_address_c => 
            if write_cmd = '1' then
              s_io_dreq1_n_ds <= data_in(io_dreq1_n_ds_msb_c downto io_dreq1_n_ds_lsb_c);
              s_io_dreq1_n_sr <= data_in(io_dreq1_n_sr_msb_c);
              s_io_dreq1_n_co <= data_in(io_dreq1_n_co_msb_c);
              s_io_dreq1_n_odp <= data_in(io_dreq1_n_odp_msb_c);
              s_io_dreq1_n_odn <= data_in(io_dreq1_n_odn_msb_c);
            end if;
          when io_dack2_n_address_c => 
            if write_cmd = '1' then
              s_io_dack2_n_ste <= data_in(io_dack2_n_ste_msb_c downto io_dack2_n_ste_lsb_c);
              s_io_dack2_n_pd <= data_in(io_dack2_n_pd_msb_c);
              s_io_dack2_n_pu <= data_in(io_dack2_n_pu_msb_c);
            end if;
          when io_dreq2_n_address_c => 
            if write_cmd = '1' then
              s_io_dreq2_n_ds <= data_in(io_dreq2_n_ds_msb_c downto io_dreq2_n_ds_lsb_c);
              s_io_dreq2_n_sr <= data_in(io_dreq2_n_sr_msb_c);
              s_io_dreq2_n_co <= data_in(io_dreq2_n_co_msb_c);
              s_io_dreq2_n_odp <= data_in(io_dreq2_n_odp_msb_c);
              s_io_dreq2_n_odn <= data_in(io_dreq2_n_odn_msb_c);
            end if;
          when io_dack3_n_address_c => 
            if write_cmd = '1' then
              s_io_dack3_n_ste <= data_in(io_dack3_n_ste_msb_c downto io_dack3_n_ste_lsb_c);
              s_io_dack3_n_pd <= data_in(io_dack3_n_pd_msb_c);
              s_io_dack3_n_pu <= data_in(io_dack3_n_pu_msb_c);
            end if;
          when io_dreq3_n_address_c => 
            if write_cmd = '1' then
              s_io_dreq3_n_ds <= data_in(io_dreq3_n_ds_msb_c downto io_dreq3_n_ds_lsb_c);
              s_io_dreq3_n_sr <= data_in(io_dreq3_n_sr_msb_c);
              s_io_dreq3_n_co <= data_in(io_dreq3_n_co_msb_c);
              s_io_dreq3_n_odp <= data_in(io_dreq3_n_odp_msb_c);
              s_io_dreq3_n_odn <= data_in(io_dreq3_n_odn_msb_c);
            end if;
          when io_d0_out_address_c => 
            if write_cmd = '1' then
              s_io_d0_out_ds <= data_in(io_d0_out_ds_msb_c downto io_d0_out_ds_lsb_c);
              s_io_d0_out_sr <= data_in(io_d0_out_sr_msb_c);
              s_io_d0_out_co <= data_in(io_d0_out_co_msb_c);
              s_io_d0_out_odp <= data_in(io_d0_out_odp_msb_c);
              s_io_d0_out_odn <= data_in(io_d0_out_odn_msb_c);
            end if;
          when io_d0_in_address_c => 
            if write_cmd = '1' then
              s_io_d0_in_ste <= data_in(io_d0_in_ste_msb_c downto io_d0_in_ste_lsb_c);
              s_io_d0_in_pd <= data_in(io_d0_in_pd_msb_c);
              s_io_d0_in_pu <= data_in(io_d0_in_pu_msb_c);
            end if;
          when io_d1_out_address_c => 
            if write_cmd = '1' then
              s_io_d1_out_ds <= data_in(io_d1_out_ds_msb_c downto io_d1_out_ds_lsb_c);
              s_io_d1_out_sr <= data_in(io_d1_out_sr_msb_c);
              s_io_d1_out_co <= data_in(io_d1_out_co_msb_c);
              s_io_d1_out_odp <= data_in(io_d1_out_odp_msb_c);
              s_io_d1_out_odn <= data_in(io_d1_out_odn_msb_c);
            end if;
          when io_d1_in_address_c => 
            if write_cmd = '1' then
              s_io_d1_in_ste <= data_in(io_d1_in_ste_msb_c downto io_d1_in_ste_lsb_c);
              s_io_d1_in_pd <= data_in(io_d1_in_pd_msb_c);
              s_io_d1_in_pu <= data_in(io_d1_in_pu_msb_c);
            end if;
          when io_d2_out_address_c => 
            if write_cmd = '1' then
              s_io_d2_out_ds <= data_in(io_d2_out_ds_msb_c downto io_d2_out_ds_lsb_c);
              s_io_d2_out_sr <= data_in(io_d2_out_sr_msb_c);
              s_io_d2_out_co <= data_in(io_d2_out_co_msb_c);
              s_io_d2_out_odp <= data_in(io_d2_out_odp_msb_c);
              s_io_d2_out_odn <= data_in(io_d2_out_odn_msb_c);
            end if;
          when io_d2_in_address_c => 
            if write_cmd = '1' then
              s_io_d2_in_ste <= data_in(io_d2_in_ste_msb_c downto io_d2_in_ste_lsb_c);
              s_io_d2_in_pd <= data_in(io_d2_in_pd_msb_c);
              s_io_d2_in_pu <= data_in(io_d2_in_pu_msb_c);
            end if;
          when io_d3_out_address_c => 
            if write_cmd = '1' then
              s_io_d3_out_ds <= data_in(io_d3_out_ds_msb_c downto io_d3_out_ds_lsb_c);
              s_io_d3_out_sr <= data_in(io_d3_out_sr_msb_c);
              s_io_d3_out_co <= data_in(io_d3_out_co_msb_c);
              s_io_d3_out_odp <= data_in(io_d3_out_odp_msb_c);
              s_io_d3_out_odn <= data_in(io_d3_out_odn_msb_c);
            end if;
          when io_d3_in_address_c => 
            if write_cmd = '1' then
              s_io_d3_in_ste <= data_in(io_d3_in_ste_msb_c downto io_d3_in_ste_lsb_c);
              s_io_d3_in_pd <= data_in(io_d3_in_pd_msb_c);
              s_io_d3_in_pu <= data_in(io_d3_in_pu_msb_c);
            end if;
          when io_d4_out_address_c => 
            if write_cmd = '1' then
              s_io_d4_out_ds <= data_in(io_d4_out_ds_msb_c downto io_d4_out_ds_lsb_c);
              s_io_d4_out_sr <= data_in(io_d4_out_sr_msb_c);
              s_io_d4_out_co <= data_in(io_d4_out_co_msb_c);
              s_io_d4_out_odp <= data_in(io_d4_out_odp_msb_c);
              s_io_d4_out_odn <= data_in(io_d4_out_odn_msb_c);
            end if;
          when io_d4_in_address_c => 
            if write_cmd = '1' then
              s_io_d4_in_ste <= data_in(io_d4_in_ste_msb_c downto io_d4_in_ste_lsb_c);
              s_io_d4_in_pd <= data_in(io_d4_in_pd_msb_c);
              s_io_d4_in_pu <= data_in(io_d4_in_pu_msb_c);
            end if;
          when io_d5_out_address_c => 
            if write_cmd = '1' then
              s_io_d5_out_ds <= data_in(io_d5_out_ds_msb_c downto io_d5_out_ds_lsb_c);
              s_io_d5_out_sr <= data_in(io_d5_out_sr_msb_c);
              s_io_d5_out_co <= data_in(io_d5_out_co_msb_c);
              s_io_d5_out_odp <= data_in(io_d5_out_odp_msb_c);
              s_io_d5_out_odn <= data_in(io_d5_out_odn_msb_c);
            end if;
          when io_d5_in_address_c => 
            if write_cmd = '1' then
              s_io_d5_in_ste <= data_in(io_d5_in_ste_msb_c downto io_d5_in_ste_lsb_c);
              s_io_d5_in_pd <= data_in(io_d5_in_pd_msb_c);
              s_io_d5_in_pu <= data_in(io_d5_in_pu_msb_c);
            end if;
          when io_d6_out_address_c => 
            if write_cmd = '1' then
              s_io_d6_out_ds <= data_in(io_d6_out_ds_msb_c downto io_d6_out_ds_lsb_c);
              s_io_d6_out_sr <= data_in(io_d6_out_sr_msb_c);
              s_io_d6_out_co <= data_in(io_d6_out_co_msb_c);
              s_io_d6_out_odp <= data_in(io_d6_out_odp_msb_c);
              s_io_d6_out_odn <= data_in(io_d6_out_odn_msb_c);
            end if;
          when io_d6_in_address_c => 
            if write_cmd = '1' then
              s_io_d6_in_ste <= data_in(io_d6_in_ste_msb_c downto io_d6_in_ste_lsb_c);
              s_io_d6_in_pd <= data_in(io_d6_in_pd_msb_c);
              s_io_d6_in_pu <= data_in(io_d6_in_pu_msb_c);
            end if;
          when io_d7_out_address_c => 
            if write_cmd = '1' then
              s_io_d7_out_ds <= data_in(io_d7_out_ds_msb_c downto io_d7_out_ds_lsb_c);
              s_io_d7_out_sr <= data_in(io_d7_out_sr_msb_c);
              s_io_d7_out_co <= data_in(io_d7_out_co_msb_c);
              s_io_d7_out_odp <= data_in(io_d7_out_odp_msb_c);
              s_io_d7_out_odn <= data_in(io_d7_out_odn_msb_c);
            end if;
          when io_d7_in_address_c => 
            if write_cmd = '1' then
              s_io_d7_in_ste <= data_in(io_d7_in_ste_msb_c downto io_d7_in_ste_lsb_c);
              s_io_d7_in_pd <= data_in(io_d7_in_pd_msb_c);
              s_io_d7_in_pu <= data_in(io_d7_in_pu_msb_c);
            end if;
          when io_ldout_n_address_c => 
            if write_cmd = '1' then
              s_io_ldout_n_ds <= data_in(io_ldout_n_ds_msb_c downto io_ldout_n_ds_lsb_c);
              s_io_ldout_n_sr <= data_in(io_ldout_n_sr_msb_c);
              s_io_ldout_n_co <= data_in(io_ldout_n_co_msb_c);
              s_io_ldout_n_odp <= data_in(io_ldout_n_odp_msb_c);
              s_io_ldout_n_odn <= data_in(io_ldout_n_odn_msb_c);
            end if;
          when io_next_n_address_c => 
            if write_cmd = '1' then
              s_io_next_n_ds <= data_in(io_next_n_ds_msb_c downto io_next_n_ds_lsb_c);
              s_io_next_n_sr <= data_in(io_next_n_sr_msb_c);
              s_io_next_n_co <= data_in(io_next_n_co_msb_c);
              s_io_next_n_odp <= data_in(io_next_n_odp_msb_c);
              s_io_next_n_odn <= data_in(io_next_n_odn_msb_c);
            end if;
          when io_clk_address_c => 
            if write_cmd = '1' then
              s_io_clk_ds <= data_in(io_clk_ds_msb_c downto io_clk_ds_lsb_c);
              s_io_clk_sr <= data_in(io_clk_sr_msb_c);
              s_io_clk_co <= data_in(io_clk_co_msb_c);
              s_io_clk_odp <= data_in(io_clk_odp_msb_c);
              s_io_clk_odn <= data_in(io_clk_odn_msb_c);
            end if;
          when io_ioa_n_address_c => 
            if write_cmd = '1' then
              s_io_ioa_n_ds <= data_in(io_ioa_n_ds_msb_c downto io_ioa_n_ds_lsb_c);
              s_io_ioa_n_sr <= data_in(io_ioa_n_sr_msb_c);
              s_io_ioa_n_co <= data_in(io_ioa_n_co_msb_c);
              s_io_ioa_n_odp <= data_in(io_ioa_n_odp_msb_c);
              s_io_ioa_n_odn <= data_in(io_ioa_n_odn_msb_c);
            end if;
          when mrxout_in_address_c => 
            if write_cmd = '1' then
              s_mrxout_in_ste <= data_in(mrxout_in_ste_msb_c downto mrxout_in_ste_lsb_c);
              s_mrxout_in_pd <= data_in(mrxout_in_pd_msb_c);
              s_mrxout_in_pu <= data_in(mrxout_in_pu_msb_c);
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process register_proc;


  handle_output_signals:process(enable, s_address,
                                s_version_analog, s_version_digital, s_mclkout_ds, s_mclkout_sr, s_mclkout_co, s_mclkout_odp,
                                s_mclkout_odn, s_msdout_ds, s_msdout_sr, s_msdout_co, s_msdout_odp, s_msdout_odn, s_utx_ds,
                                s_utx_sr, s_utx_co, s_utx_odp, s_utx_odn, s_mirqout_ds, s_mirqout_sr, s_mirqout_co,
                                s_mirqout_odp, s_mirqout_odn, s_msdin_ste, s_msdin_pd, s_msdin_pu, s_mirq0_ste, s_mirq0_pd,
                                s_mirq0_pu, s_mirq1_ste, s_mirq1_pd, s_mirq1_pu, s_urx_ste, s_urx_pd, s_urx_pu,
                                s_emem_d0_out_ds, s_emem_d0_out_sr, s_emem_d0_out_co, s_emem_d0_out_odp, s_emem_d0_out_odn,
                                s_emem_d0_in_ste, s_emem_d0_in_pd, s_emem_d0_in_pu, s_emem_d1_out_ds, s_emem_d1_out_sr,
                                s_emem_d1_out_co, s_emem_d1_out_odp, s_emem_d1_out_odn, s_emem_d1_in_ste, s_emem_d1_in_pd,
                                s_emem_d1_in_pu, s_emem_d2_out_ds, s_emem_d2_out_sr, s_emem_d2_out_co, s_emem_d2_out_odp,
                                s_emem_d2_out_odn, s_emem_d2_in_ste, s_emem_d2_in_pd, s_emem_d2_in_pu, s_emem_d3_out_ds,
                                s_emem_d3_out_sr, s_emem_d3_out_co, s_emem_d3_out_odp, s_emem_d3_out_odn, s_emem_d3_in_ste,
                                s_emem_d3_in_pd, s_emem_d3_in_pu, s_emem_d4_out_ds, s_emem_d4_out_sr, s_emem_d4_out_co,
                                s_emem_d4_out_odp, s_emem_d4_out_odn, s_emem_d4_in_ste, s_emem_d4_in_pd, s_emem_d4_in_pu,
                                s_emem_d5_out_ds, s_emem_d5_out_sr, s_emem_d5_out_co, s_emem_d5_out_odp, s_emem_d5_out_odn,
                                s_emem_d5_in_ste, s_emem_d5_in_pd, s_emem_d5_in_pu, s_emem_d6_out_ds, s_emem_d6_out_sr,
                                s_emem_d6_out_co, s_emem_d6_out_odp, s_emem_d6_out_odn, s_emem_d6_in_ste, s_emem_d6_in_pd,
                                s_emem_d6_in_pu, s_emem_d7_out_ds, s_emem_d7_out_sr, s_emem_d7_out_co, s_emem_d7_out_odp,
                                s_emem_d7_out_odn, s_emem_d7_in_ste, s_emem_d7_in_pd, s_emem_d7_in_pu, s_emem_clk_ds,
                                s_emem_clk_sr, s_emem_clk_co, s_emem_clk_odp, s_emem_clk_odn, s_emem_rwds_out_ds,
                                s_emem_rwds_out_sr, s_emem_rwds_out_co, s_emem_rwds_out_odp, s_emem_rwds_out_odn,
                                s_emem_rwds_in_ste, s_emem_rwds_in_pd, s_emem_rwds_in_pu, s_emem_cs_n_ds, s_emem_cs_n_sr,
                                s_emem_cs_n_co, s_emem_cs_n_odp, s_emem_cs_n_odn, s_emem_rst_n_ds, s_emem_rst_n_sr,
                                s_emem_rst_n_co, s_emem_rst_n_odp, s_emem_rst_n_odn, s_aout0_ds, s_aout0_sr, s_aout0_co,
                                s_aout0_odp, s_aout0_odn, s_aout1_ds, s_aout1_sr, s_aout1_co, s_aout1_odp, s_aout1_odn,
                                s_ach0_ste, s_ach0_pd, s_ach0_pu, s_enet_mdio_out_ds, s_enet_mdio_out_sr,
                                s_enet_mdio_out_co, s_enet_mdio_out_odp, s_enet_mdio_out_odn, s_enet_mdio_in_ste,
                                s_enet_mdio_in_pd, s_enet_mdio_in_pu, s_enet_mdc_ds, s_enet_mdc_sr, s_enet_mdc_co,
                                s_enet_mdc_odp, s_enet_mdc_odn, s_enet_txer_ds, s_enet_txer_sr, s_enet_txer_co,
                                s_enet_txer_odp, s_enet_txer_odn, s_enet_txd0_ds, s_enet_txd0_sr, s_enet_txd0_co,
                                s_enet_txd0_odp, s_enet_txd0_odn, s_enet_txd1_ds, s_enet_txd1_sr, s_enet_txd1_co,
                                s_enet_txd1_odp, s_enet_txd1_odn, s_enet_txen_ds, s_enet_txen_sr, s_enet_txen_co,
                                s_enet_txen_odp, s_enet_txen_odn, s_enet_clk_ste, s_enet_clk_pd, s_enet_clk_pu,
                                s_enet_rxdv_ste, s_enet_rxdv_pd, s_enet_rxdv_pu, s_enet_rxd0_ste, s_enet_rxd0_pd,
                                s_enet_rxd0_pu, s_enet_rxd1_ste, s_enet_rxd1_pd, s_enet_rxd1_pu, s_enet_rxer_ste,
                                s_enet_rxer_pd, s_enet_rxer_pu, s_spi_sclk_ste, s_spi_sclk_pd, s_spi_sclk_pu, s_spi_cs_n_ste,
                                s_spi_cs_n_pd, s_spi_cs_n_pu, s_spi_mosi_ste, s_spi_mosi_pd, s_spi_mosi_pu, s_spi_miso_ds,
                                s_spi_miso_sr, s_spi_miso_co, s_spi_miso_odp, s_spi_miso_odn, s_pll_ref_clk_ste,
                                s_pll_ref_clk_pd, s_pll_ref_clk_pu, s_pa0_sin_out_ds, s_pa0_sin_out_sr, s_pa0_sin_out_co,
                                s_pa0_sin_out_odp, s_pa0_sin_out_odn, s_pa0_sin_in_ste, s_pa0_sin_in_pd, s_pa0_sin_in_pu,
                                s_pa5_cs_n_out_ds, s_pa5_cs_n_out_sr, s_pa5_cs_n_out_co, s_pa5_cs_n_out_odp,
                                s_pa5_cs_n_out_odn, s_pa5_cs_n_in_ste, s_pa5_cs_n_in_pd, s_pa5_cs_n_in_pu, s_pa6_sck_out_ds,
                                s_pa6_sck_out_sr, s_pa6_sck_out_co, s_pa6_sck_out_odp, s_pa6_sck_out_odn, s_pa6_sck_in_ste,
                                s_pa6_sck_in_pd, s_pa6_sck_in_pu, s_pa7_sout_out_ds, s_pa7_sout_out_sr, s_pa7_sout_out_co,
                                s_pa7_sout_out_odp, s_pa7_sout_out_odn, s_pa7_sout_in_ste, s_pa7_sout_in_pd, s_pa7_sout_in_pu,
                                s_pg0_out_ds, s_pg0_out_sr, s_pg0_out_co, s_pg0_out_odp, s_pg0_out_odn, s_pg0_in_ste,
                                s_pg0_in_pd, s_pg0_in_pu, s_pg1_out_ds, s_pg1_out_sr, s_pg1_out_co, s_pg1_out_odp,
                                s_pg1_out_odn, s_pg1_in_ste, s_pg1_in_pd, s_pg1_in_pu, s_pg2_out_ds, s_pg2_out_sr,
                                s_pg2_out_co, s_pg2_out_odp, s_pg2_out_odn, s_pg2_in_ste, s_pg2_in_pd, s_pg2_in_pu,
                                s_pg3_out_ds, s_pg3_out_sr, s_pg3_out_co, s_pg3_out_odp, s_pg3_out_odn, s_pg3_in_ste,
                                s_pg3_in_pd, s_pg3_in_pu, s_pg4_out_ds, s_pg4_out_sr, s_pg4_out_co, s_pg4_out_odp,
                                s_pg4_out_odn, s_pg4_in_ste, s_pg4_in_pd, s_pg4_in_pu, s_pg5_out_ds, s_pg5_out_sr,
                                s_pg5_out_co, s_pg5_out_odp, s_pg5_out_odn, s_pg5_in_ste, s_pg5_in_pd, s_pg5_in_pu,
                                s_pg6_out_ds, s_pg6_out_sr, s_pg6_out_co, s_pg6_out_odp, s_pg6_out_odn, s_pg6_in_ste,
                                s_pg6_in_pd, s_pg6_in_pu, s_pg7_out_ds, s_pg7_out_sr, s_pg7_out_co, s_pg7_out_odp,
                                s_pg7_out_odn, s_pg7_in_ste, s_pg7_in_pd, s_pg7_in_pu, s_mtest_ste, s_mtest_pd, s_mtest_pu,
                                s_mwake_ste, s_mwake_pd, s_mwake_pu, s_mrxout_out_ds, s_mrxout_out_sr, s_mrxout_out_co,
                                s_mrxout_out_odp, s_mrxout_out_odn, s_pll_1_main_div_n1, s_pll_1_main_div_n2,
                                s_pll_1_main_div_n3, s_pll_1_main_div_n4, s_pll_2_open_loop, s_pll_2_out_div_sel, s_pll_2_ci,
                                s_pll_cp_cp, s_pll_ft_ft, s_pll_3_divcore_sel, s_pll_3_coarse, s_pll_4_auto_coarsetune,
                                s_pll_4_enforce_lock, s_pll_4_pfd_select, s_pll_4_lock_window_sel, s_pll_4_div_core_mux_sel,
                                s_pll_4_filter_shift, s_pll_4_en_fast_lock, s_pll_5_sar_limit, s_pll_5_set_op_lock,
                                s_pll_5_disable_lock, s_pll_5_ref_bypass, s_pll_5_ct_compensation,
                                s_adpll_status0_adpll_status_0, s_adpll_status1_adpll_status_1, s_adpll_status2_adpll_status_2,
                                s_io_dack0_n_ste, s_io_dack0_n_pd, s_io_dack0_n_pu, s_io_dreq0_n_ds, s_io_dreq0_n_sr,
                                s_io_dreq0_n_co, s_io_dreq0_n_odp, s_io_dreq0_n_odn, s_io_dack1_n_ste, s_io_dack1_n_pd,
                                s_io_dack1_n_pu, s_io_dreq1_n_ds, s_io_dreq1_n_sr, s_io_dreq1_n_co, s_io_dreq1_n_odp,
                                s_io_dreq1_n_odn, s_io_dack2_n_ste, s_io_dack2_n_pd, s_io_dack2_n_pu, s_io_dreq2_n_ds,
                                s_io_dreq2_n_sr, s_io_dreq2_n_co, s_io_dreq2_n_odp, s_io_dreq2_n_odn, s_io_dack3_n_ste,
                                s_io_dack3_n_pd, s_io_dack3_n_pu, s_io_dreq3_n_ds, s_io_dreq3_n_sr, s_io_dreq3_n_co,
                                s_io_dreq3_n_odp, s_io_dreq3_n_odn, s_io_d0_out_ds, s_io_d0_out_sr, s_io_d0_out_co,
                                s_io_d0_out_odp, s_io_d0_out_odn, s_io_d0_in_ste, s_io_d0_in_pd, s_io_d0_in_pu, s_io_d1_out_ds,
                                s_io_d1_out_sr, s_io_d1_out_co, s_io_d1_out_odp, s_io_d1_out_odn, s_io_d1_in_ste,
                                s_io_d1_in_pd, s_io_d1_in_pu, s_io_d2_out_ds, s_io_d2_out_sr, s_io_d2_out_co,
                                s_io_d2_out_odp, s_io_d2_out_odn, s_io_d2_in_ste, s_io_d2_in_pd, s_io_d2_in_pu, s_io_d3_out_ds,
                                s_io_d3_out_sr, s_io_d3_out_co, s_io_d3_out_odp, s_io_d3_out_odn, s_io_d3_in_ste,
                                s_io_d3_in_pd, s_io_d3_in_pu, s_io_d4_out_ds, s_io_d4_out_sr, s_io_d4_out_co,
                                s_io_d4_out_odp, s_io_d4_out_odn, s_io_d4_in_ste, s_io_d4_in_pd, s_io_d4_in_pu, s_io_d5_out_ds,
                                s_io_d5_out_sr, s_io_d5_out_co, s_io_d5_out_odp, s_io_d5_out_odn, s_io_d5_in_ste,
                                s_io_d5_in_pd, s_io_d5_in_pu, s_io_d6_out_ds, s_io_d6_out_sr, s_io_d6_out_co,
                                s_io_d6_out_odp, s_io_d6_out_odn, s_io_d6_in_ste, s_io_d6_in_pd, s_io_d6_in_pu, s_io_d7_out_ds,
                                s_io_d7_out_sr, s_io_d7_out_co, s_io_d7_out_odp, s_io_d7_out_odn, s_io_d7_in_ste,
                                s_io_d7_in_pd, s_io_d7_in_pu, s_io_ldout_n_ds, s_io_ldout_n_sr, s_io_ldout_n_co,
                                s_io_ldout_n_odp, s_io_ldout_n_odn, s_io_next_n_ds, s_io_next_n_sr, s_io_next_n_co,
                                s_io_next_n_odp, s_io_next_n_odn, s_io_clk_ds, s_io_clk_sr, s_io_clk_co, s_io_clk_odp,
                                s_io_clk_odn, s_io_ioa_n_ds, s_io_ioa_n_sr, s_io_ioa_n_co, s_io_ioa_n_odp, s_io_ioa_n_odn,
                                s_mrxout_in_ste, s_mrxout_in_pd, s_mrxout_in_pu)
  begin
    data_out <= (others => '0');

    if enable = '1' then
      case s_address is
        when version_address_c => 
          data_out(version_analog_msb_c downto version_analog_lsb_c) <= s_version_analog;
          data_out(version_digital_msb_c downto version_digital_lsb_c) <= s_version_digital;
        when mclkout_address_c => 
          data_out(mclkout_ds_msb_c downto mclkout_ds_lsb_c) <= s_mclkout_ds;
          data_out(mclkout_sr_msb_c) <= s_mclkout_sr;
          data_out(mclkout_co_msb_c) <= s_mclkout_co;
          data_out(mclkout_odp_msb_c) <= s_mclkout_odp;
          data_out(mclkout_odn_msb_c) <= s_mclkout_odn;
        when msdout_address_c => 
          data_out(msdout_ds_msb_c downto msdout_ds_lsb_c) <= s_msdout_ds;
          data_out(msdout_sr_msb_c) <= s_msdout_sr;
          data_out(msdout_co_msb_c) <= s_msdout_co;
          data_out(msdout_odp_msb_c) <= s_msdout_odp;
          data_out(msdout_odn_msb_c) <= s_msdout_odn;
        when utx_address_c => 
          data_out(utx_ds_msb_c downto utx_ds_lsb_c) <= s_utx_ds;
          data_out(utx_sr_msb_c) <= s_utx_sr;
          data_out(utx_co_msb_c) <= s_utx_co;
          data_out(utx_odp_msb_c) <= s_utx_odp;
          data_out(utx_odn_msb_c) <= s_utx_odn;
        when mirqout_address_c => 
          data_out(mirqout_ds_msb_c downto mirqout_ds_lsb_c) <= s_mirqout_ds;
          data_out(mirqout_sr_msb_c) <= s_mirqout_sr;
          data_out(mirqout_co_msb_c) <= s_mirqout_co;
          data_out(mirqout_odp_msb_c) <= s_mirqout_odp;
          data_out(mirqout_odn_msb_c) <= s_mirqout_odn;
        when msdin_address_c => 
          data_out(msdin_ste_msb_c downto msdin_ste_lsb_c) <= s_msdin_ste;
          data_out(msdin_pd_msb_c) <= s_msdin_pd;
          data_out(msdin_pu_msb_c) <= s_msdin_pu;
        when mirq0_address_c => 
          data_out(mirq0_ste_msb_c downto mirq0_ste_lsb_c) <= s_mirq0_ste;
          data_out(mirq0_pd_msb_c) <= s_mirq0_pd;
          data_out(mirq0_pu_msb_c) <= s_mirq0_pu;
        when mirq1_address_c => 
          data_out(mirq1_ste_msb_c downto mirq1_ste_lsb_c) <= s_mirq1_ste;
          data_out(mirq1_pd_msb_c) <= s_mirq1_pd;
          data_out(mirq1_pu_msb_c) <= s_mirq1_pu;
        when urx_address_c => 
          data_out(urx_ste_msb_c downto urx_ste_lsb_c) <= s_urx_ste;
          data_out(urx_pd_msb_c) <= s_urx_pd;
          data_out(urx_pu_msb_c) <= s_urx_pu;
        when emem_d0_out_address_c => 
          data_out(emem_d0_out_ds_msb_c downto emem_d0_out_ds_lsb_c) <= s_emem_d0_out_ds;
          data_out(emem_d0_out_sr_msb_c) <= s_emem_d0_out_sr;
          data_out(emem_d0_out_co_msb_c) <= s_emem_d0_out_co;
          data_out(emem_d0_out_odp_msb_c) <= s_emem_d0_out_odp;
          data_out(emem_d0_out_odn_msb_c) <= s_emem_d0_out_odn;
        when emem_d0_in_address_c => 
          data_out(emem_d0_in_ste_msb_c downto emem_d0_in_ste_lsb_c) <= s_emem_d0_in_ste;
          data_out(emem_d0_in_pd_msb_c) <= s_emem_d0_in_pd;
          data_out(emem_d0_in_pu_msb_c) <= s_emem_d0_in_pu;
        when emem_d1_out_address_c => 
          data_out(emem_d1_out_ds_msb_c downto emem_d1_out_ds_lsb_c) <= s_emem_d1_out_ds;
          data_out(emem_d1_out_sr_msb_c) <= s_emem_d1_out_sr;
          data_out(emem_d1_out_co_msb_c) <= s_emem_d1_out_co;
          data_out(emem_d1_out_odp_msb_c) <= s_emem_d1_out_odp;
          data_out(emem_d1_out_odn_msb_c) <= s_emem_d1_out_odn;
        when emem_d1_in_address_c => 
          data_out(emem_d1_in_ste_msb_c downto emem_d1_in_ste_lsb_c) <= s_emem_d1_in_ste;
          data_out(emem_d1_in_pd_msb_c) <= s_emem_d1_in_pd;
          data_out(emem_d1_in_pu_msb_c) <= s_emem_d1_in_pu;
        when emem_d2_out_address_c => 
          data_out(emem_d2_out_ds_msb_c downto emem_d2_out_ds_lsb_c) <= s_emem_d2_out_ds;
          data_out(emem_d2_out_sr_msb_c) <= s_emem_d2_out_sr;
          data_out(emem_d2_out_co_msb_c) <= s_emem_d2_out_co;
          data_out(emem_d2_out_odp_msb_c) <= s_emem_d2_out_odp;
          data_out(emem_d2_out_odn_msb_c) <= s_emem_d2_out_odn;
        when emem_d2_in_address_c => 
          data_out(emem_d2_in_ste_msb_c downto emem_d2_in_ste_lsb_c) <= s_emem_d2_in_ste;
          data_out(emem_d2_in_pd_msb_c) <= s_emem_d2_in_pd;
          data_out(emem_d2_in_pu_msb_c) <= s_emem_d2_in_pu;
        when emem_d3_out_address_c => 
          data_out(emem_d3_out_ds_msb_c downto emem_d3_out_ds_lsb_c) <= s_emem_d3_out_ds;
          data_out(emem_d3_out_sr_msb_c) <= s_emem_d3_out_sr;
          data_out(emem_d3_out_co_msb_c) <= s_emem_d3_out_co;
          data_out(emem_d3_out_odp_msb_c) <= s_emem_d3_out_odp;
          data_out(emem_d3_out_odn_msb_c) <= s_emem_d3_out_odn;
        when emem_d3_in_address_c => 
          data_out(emem_d3_in_ste_msb_c downto emem_d3_in_ste_lsb_c) <= s_emem_d3_in_ste;
          data_out(emem_d3_in_pd_msb_c) <= s_emem_d3_in_pd;
          data_out(emem_d3_in_pu_msb_c) <= s_emem_d3_in_pu;
        when emem_d4_out_address_c => 
          data_out(emem_d4_out_ds_msb_c downto emem_d4_out_ds_lsb_c) <= s_emem_d4_out_ds;
          data_out(emem_d4_out_sr_msb_c) <= s_emem_d4_out_sr;
          data_out(emem_d4_out_co_msb_c) <= s_emem_d4_out_co;
          data_out(emem_d4_out_odp_msb_c) <= s_emem_d4_out_odp;
          data_out(emem_d4_out_odn_msb_c) <= s_emem_d4_out_odn;
        when emem_d4_in_address_c => 
          data_out(emem_d4_in_ste_msb_c downto emem_d4_in_ste_lsb_c) <= s_emem_d4_in_ste;
          data_out(emem_d4_in_pd_msb_c) <= s_emem_d4_in_pd;
          data_out(emem_d4_in_pu_msb_c) <= s_emem_d4_in_pu;
        when emem_d5_out_address_c => 
          data_out(emem_d5_out_ds_msb_c downto emem_d5_out_ds_lsb_c) <= s_emem_d5_out_ds;
          data_out(emem_d5_out_sr_msb_c) <= s_emem_d5_out_sr;
          data_out(emem_d5_out_co_msb_c) <= s_emem_d5_out_co;
          data_out(emem_d5_out_odp_msb_c) <= s_emem_d5_out_odp;
          data_out(emem_d5_out_odn_msb_c) <= s_emem_d5_out_odn;
        when emem_d5_in_address_c => 
          data_out(emem_d5_in_ste_msb_c downto emem_d5_in_ste_lsb_c) <= s_emem_d5_in_ste;
          data_out(emem_d5_in_pd_msb_c) <= s_emem_d5_in_pd;
          data_out(emem_d5_in_pu_msb_c) <= s_emem_d5_in_pu;
        when emem_d6_out_address_c => 
          data_out(emem_d6_out_ds_msb_c downto emem_d6_out_ds_lsb_c) <= s_emem_d6_out_ds;
          data_out(emem_d6_out_sr_msb_c) <= s_emem_d6_out_sr;
          data_out(emem_d6_out_co_msb_c) <= s_emem_d6_out_co;
          data_out(emem_d6_out_odp_msb_c) <= s_emem_d6_out_odp;
          data_out(emem_d6_out_odn_msb_c) <= s_emem_d6_out_odn;
        when emem_d6_in_address_c => 
          data_out(emem_d6_in_ste_msb_c downto emem_d6_in_ste_lsb_c) <= s_emem_d6_in_ste;
          data_out(emem_d6_in_pd_msb_c) <= s_emem_d6_in_pd;
          data_out(emem_d6_in_pu_msb_c) <= s_emem_d6_in_pu;
        when emem_d7_out_address_c => 
          data_out(emem_d7_out_ds_msb_c downto emem_d7_out_ds_lsb_c) <= s_emem_d7_out_ds;
          data_out(emem_d7_out_sr_msb_c) <= s_emem_d7_out_sr;
          data_out(emem_d7_out_co_msb_c) <= s_emem_d7_out_co;
          data_out(emem_d7_out_odp_msb_c) <= s_emem_d7_out_odp;
          data_out(emem_d7_out_odn_msb_c) <= s_emem_d7_out_odn;
        when emem_d7_in_address_c => 
          data_out(emem_d7_in_ste_msb_c downto emem_d7_in_ste_lsb_c) <= s_emem_d7_in_ste;
          data_out(emem_d7_in_pd_msb_c) <= s_emem_d7_in_pd;
          data_out(emem_d7_in_pu_msb_c) <= s_emem_d7_in_pu;
        when emem_clk_address_c => 
          data_out(emem_clk_ds_msb_c downto emem_clk_ds_lsb_c) <= s_emem_clk_ds;
          data_out(emem_clk_sr_msb_c) <= s_emem_clk_sr;
          data_out(emem_clk_co_msb_c) <= s_emem_clk_co;
          data_out(emem_clk_odp_msb_c) <= s_emem_clk_odp;
          data_out(emem_clk_odn_msb_c) <= s_emem_clk_odn;
        when emem_rwds_out_address_c => 
          data_out(emem_rwds_out_ds_msb_c downto emem_rwds_out_ds_lsb_c) <= s_emem_rwds_out_ds;
          data_out(emem_rwds_out_sr_msb_c) <= s_emem_rwds_out_sr;
          data_out(emem_rwds_out_co_msb_c) <= s_emem_rwds_out_co;
          data_out(emem_rwds_out_odp_msb_c) <= s_emem_rwds_out_odp;
          data_out(emem_rwds_out_odn_msb_c) <= s_emem_rwds_out_odn;
        when emem_rwds_in_address_c => 
          data_out(emem_rwds_in_ste_msb_c downto emem_rwds_in_ste_lsb_c) <= s_emem_rwds_in_ste;
          data_out(emem_rwds_in_pd_msb_c) <= s_emem_rwds_in_pd;
          data_out(emem_rwds_in_pu_msb_c) <= s_emem_rwds_in_pu;
        when emem_cs_n_address_c => 
          data_out(emem_cs_n_ds_msb_c downto emem_cs_n_ds_lsb_c) <= s_emem_cs_n_ds;
          data_out(emem_cs_n_sr_msb_c) <= s_emem_cs_n_sr;
          data_out(emem_cs_n_co_msb_c) <= s_emem_cs_n_co;
          data_out(emem_cs_n_odp_msb_c) <= s_emem_cs_n_odp;
          data_out(emem_cs_n_odn_msb_c) <= s_emem_cs_n_odn;
        when emem_rst_n_address_c => 
          data_out(emem_rst_n_ds_msb_c downto emem_rst_n_ds_lsb_c) <= s_emem_rst_n_ds;
          data_out(emem_rst_n_sr_msb_c) <= s_emem_rst_n_sr;
          data_out(emem_rst_n_co_msb_c) <= s_emem_rst_n_co;
          data_out(emem_rst_n_odp_msb_c) <= s_emem_rst_n_odp;
          data_out(emem_rst_n_odn_msb_c) <= s_emem_rst_n_odn;
        when aout0_address_c => 
          data_out(aout0_ds_msb_c downto aout0_ds_lsb_c) <= s_aout0_ds;
          data_out(aout0_sr_msb_c) <= s_aout0_sr;
          data_out(aout0_co_msb_c) <= s_aout0_co;
          data_out(aout0_odp_msb_c) <= s_aout0_odp;
          data_out(aout0_odn_msb_c) <= s_aout0_odn;
        when aout1_address_c => 
          data_out(aout1_ds_msb_c downto aout1_ds_lsb_c) <= s_aout1_ds;
          data_out(aout1_sr_msb_c) <= s_aout1_sr;
          data_out(aout1_co_msb_c) <= s_aout1_co;
          data_out(aout1_odp_msb_c) <= s_aout1_odp;
          data_out(aout1_odn_msb_c) <= s_aout1_odn;
        when ach0_address_c => 
          data_out(ach0_ste_msb_c downto ach0_ste_lsb_c) <= s_ach0_ste;
          data_out(ach0_pd_msb_c) <= s_ach0_pd;
          data_out(ach0_pu_msb_c) <= s_ach0_pu;
        when enet_mdio_out_address_c => 
          data_out(enet_mdio_out_ds_msb_c downto enet_mdio_out_ds_lsb_c) <= s_enet_mdio_out_ds;
          data_out(enet_mdio_out_sr_msb_c) <= s_enet_mdio_out_sr;
          data_out(enet_mdio_out_co_msb_c) <= s_enet_mdio_out_co;
          data_out(enet_mdio_out_odp_msb_c) <= s_enet_mdio_out_odp;
          data_out(enet_mdio_out_odn_msb_c) <= s_enet_mdio_out_odn;
        when enet_mdio_in_address_c => 
          data_out(enet_mdio_in_ste_msb_c downto enet_mdio_in_ste_lsb_c) <= s_enet_mdio_in_ste;
          data_out(enet_mdio_in_pd_msb_c) <= s_enet_mdio_in_pd;
          data_out(enet_mdio_in_pu_msb_c) <= s_enet_mdio_in_pu;
        when enet_mdc_address_c => 
          data_out(enet_mdc_ds_msb_c downto enet_mdc_ds_lsb_c) <= s_enet_mdc_ds;
          data_out(enet_mdc_sr_msb_c) <= s_enet_mdc_sr;
          data_out(enet_mdc_co_msb_c) <= s_enet_mdc_co;
          data_out(enet_mdc_odp_msb_c) <= s_enet_mdc_odp;
          data_out(enet_mdc_odn_msb_c) <= s_enet_mdc_odn;
        when enet_txer_address_c => 
          data_out(enet_txer_ds_msb_c downto enet_txer_ds_lsb_c) <= s_enet_txer_ds;
          data_out(enet_txer_sr_msb_c) <= s_enet_txer_sr;
          data_out(enet_txer_co_msb_c) <= s_enet_txer_co;
          data_out(enet_txer_odp_msb_c) <= s_enet_txer_odp;
          data_out(enet_txer_odn_msb_c) <= s_enet_txer_odn;
        when enet_txd0_address_c => 
          data_out(enet_txd0_ds_msb_c downto enet_txd0_ds_lsb_c) <= s_enet_txd0_ds;
          data_out(enet_txd0_sr_msb_c) <= s_enet_txd0_sr;
          data_out(enet_txd0_co_msb_c) <= s_enet_txd0_co;
          data_out(enet_txd0_odp_msb_c) <= s_enet_txd0_odp;
          data_out(enet_txd0_odn_msb_c) <= s_enet_txd0_odn;
        when enet_txd1_address_c => 
          data_out(enet_txd1_ds_msb_c downto enet_txd1_ds_lsb_c) <= s_enet_txd1_ds;
          data_out(enet_txd1_sr_msb_c) <= s_enet_txd1_sr;
          data_out(enet_txd1_co_msb_c) <= s_enet_txd1_co;
          data_out(enet_txd1_odp_msb_c) <= s_enet_txd1_odp;
          data_out(enet_txd1_odn_msb_c) <= s_enet_txd1_odn;
        when enet_txen_address_c => 
          data_out(enet_txen_ds_msb_c downto enet_txen_ds_lsb_c) <= s_enet_txen_ds;
          data_out(enet_txen_sr_msb_c) <= s_enet_txen_sr;
          data_out(enet_txen_co_msb_c) <= s_enet_txen_co;
          data_out(enet_txen_odp_msb_c) <= s_enet_txen_odp;
          data_out(enet_txen_odn_msb_c) <= s_enet_txen_odn;
        when enet_clk_address_c => 
          data_out(enet_clk_ste_msb_c downto enet_clk_ste_lsb_c) <= s_enet_clk_ste;
          data_out(enet_clk_pd_msb_c) <= s_enet_clk_pd;
          data_out(enet_clk_pu_msb_c) <= s_enet_clk_pu;
        when enet_rxdv_address_c => 
          data_out(enet_rxdv_ste_msb_c downto enet_rxdv_ste_lsb_c) <= s_enet_rxdv_ste;
          data_out(enet_rxdv_pd_msb_c) <= s_enet_rxdv_pd;
          data_out(enet_rxdv_pu_msb_c) <= s_enet_rxdv_pu;
        when enet_rxd0_address_c => 
          data_out(enet_rxd0_ste_msb_c downto enet_rxd0_ste_lsb_c) <= s_enet_rxd0_ste;
          data_out(enet_rxd0_pd_msb_c) <= s_enet_rxd0_pd;
          data_out(enet_rxd0_pu_msb_c) <= s_enet_rxd0_pu;
        when enet_rxd1_address_c => 
          data_out(enet_rxd1_ste_msb_c downto enet_rxd1_ste_lsb_c) <= s_enet_rxd1_ste;
          data_out(enet_rxd1_pd_msb_c) <= s_enet_rxd1_pd;
          data_out(enet_rxd1_pu_msb_c) <= s_enet_rxd1_pu;
        when enet_rxer_address_c => 
          data_out(enet_rxer_ste_msb_c downto enet_rxer_ste_lsb_c) <= s_enet_rxer_ste;
          data_out(enet_rxer_pd_msb_c) <= s_enet_rxer_pd;
          data_out(enet_rxer_pu_msb_c) <= s_enet_rxer_pu;
        when spi_sclk_address_c => 
          data_out(spi_sclk_ste_msb_c downto spi_sclk_ste_lsb_c) <= s_spi_sclk_ste;
          data_out(spi_sclk_pd_msb_c) <= s_spi_sclk_pd;
          data_out(spi_sclk_pu_msb_c) <= s_spi_sclk_pu;
        when spi_cs_n_address_c => 
          data_out(spi_cs_n_ste_msb_c downto spi_cs_n_ste_lsb_c) <= s_spi_cs_n_ste;
          data_out(spi_cs_n_pd_msb_c) <= s_spi_cs_n_pd;
          data_out(spi_cs_n_pu_msb_c) <= s_spi_cs_n_pu;
        when spi_mosi_address_c => 
          data_out(spi_mosi_ste_msb_c downto spi_mosi_ste_lsb_c) <= s_spi_mosi_ste;
          data_out(spi_mosi_pd_msb_c) <= s_spi_mosi_pd;
          data_out(spi_mosi_pu_msb_c) <= s_spi_mosi_pu;
        when spi_miso_address_c => 
          data_out(spi_miso_ds_msb_c downto spi_miso_ds_lsb_c) <= s_spi_miso_ds;
          data_out(spi_miso_sr_msb_c) <= s_spi_miso_sr;
          data_out(spi_miso_co_msb_c) <= s_spi_miso_co;
          data_out(spi_miso_odp_msb_c) <= s_spi_miso_odp;
          data_out(spi_miso_odn_msb_c) <= s_spi_miso_odn;
        when pll_ref_clk_address_c => 
          data_out(pll_ref_clk_ste_msb_c downto pll_ref_clk_ste_lsb_c) <= s_pll_ref_clk_ste;
          data_out(pll_ref_clk_pd_msb_c) <= s_pll_ref_clk_pd;
          data_out(pll_ref_clk_pu_msb_c) <= s_pll_ref_clk_pu;
        when pa0_sin_out_address_c => 
          data_out(pa0_sin_out_ds_msb_c downto pa0_sin_out_ds_lsb_c) <= s_pa0_sin_out_ds;
          data_out(pa0_sin_out_sr_msb_c) <= s_pa0_sin_out_sr;
          data_out(pa0_sin_out_co_msb_c) <= s_pa0_sin_out_co;
          data_out(pa0_sin_out_odp_msb_c) <= s_pa0_sin_out_odp;
          data_out(pa0_sin_out_odn_msb_c) <= s_pa0_sin_out_odn;
        when pa0_sin_in_address_c => 
          data_out(pa0_sin_in_ste_msb_c downto pa0_sin_in_ste_lsb_c) <= s_pa0_sin_in_ste;
          data_out(pa0_sin_in_pd_msb_c) <= s_pa0_sin_in_pd;
          data_out(pa0_sin_in_pu_msb_c) <= s_pa0_sin_in_pu;
        when pa5_cs_n_out_address_c => 
          data_out(pa5_cs_n_out_ds_msb_c downto pa5_cs_n_out_ds_lsb_c) <= s_pa5_cs_n_out_ds;
          data_out(pa5_cs_n_out_sr_msb_c) <= s_pa5_cs_n_out_sr;
          data_out(pa5_cs_n_out_co_msb_c) <= s_pa5_cs_n_out_co;
          data_out(pa5_cs_n_out_odp_msb_c) <= s_pa5_cs_n_out_odp;
          data_out(pa5_cs_n_out_odn_msb_c) <= s_pa5_cs_n_out_odn;
        when pa5_cs_n_in_address_c => 
          data_out(pa5_cs_n_in_ste_msb_c downto pa5_cs_n_in_ste_lsb_c) <= s_pa5_cs_n_in_ste;
          data_out(pa5_cs_n_in_pd_msb_c) <= s_pa5_cs_n_in_pd;
          data_out(pa5_cs_n_in_pu_msb_c) <= s_pa5_cs_n_in_pu;
        when pa6_sck_out_address_c => 
          data_out(pa6_sck_out_ds_msb_c downto pa6_sck_out_ds_lsb_c) <= s_pa6_sck_out_ds;
          data_out(pa6_sck_out_sr_msb_c) <= s_pa6_sck_out_sr;
          data_out(pa6_sck_out_co_msb_c) <= s_pa6_sck_out_co;
          data_out(pa6_sck_out_odp_msb_c) <= s_pa6_sck_out_odp;
          data_out(pa6_sck_out_odn_msb_c) <= s_pa6_sck_out_odn;
        when pa6_sck_in_address_c => 
          data_out(pa6_sck_in_ste_msb_c downto pa6_sck_in_ste_lsb_c) <= s_pa6_sck_in_ste;
          data_out(pa6_sck_in_pd_msb_c) <= s_pa6_sck_in_pd;
          data_out(pa6_sck_in_pu_msb_c) <= s_pa6_sck_in_pu;
        when pa7_sout_out_address_c => 
          data_out(pa7_sout_out_ds_msb_c downto pa7_sout_out_ds_lsb_c) <= s_pa7_sout_out_ds;
          data_out(pa7_sout_out_sr_msb_c) <= s_pa7_sout_out_sr;
          data_out(pa7_sout_out_co_msb_c) <= s_pa7_sout_out_co;
          data_out(pa7_sout_out_odp_msb_c) <= s_pa7_sout_out_odp;
          data_out(pa7_sout_out_odn_msb_c) <= s_pa7_sout_out_odn;
        when pa7_sout_in_address_c => 
          data_out(pa7_sout_in_ste_msb_c downto pa7_sout_in_ste_lsb_c) <= s_pa7_sout_in_ste;
          data_out(pa7_sout_in_pd_msb_c) <= s_pa7_sout_in_pd;
          data_out(pa7_sout_in_pu_msb_c) <= s_pa7_sout_in_pu;
        when pg0_out_address_c => 
          data_out(pg0_out_ds_msb_c downto pg0_out_ds_lsb_c) <= s_pg0_out_ds;
          data_out(pg0_out_sr_msb_c) <= s_pg0_out_sr;
          data_out(pg0_out_co_msb_c) <= s_pg0_out_co;
          data_out(pg0_out_odp_msb_c) <= s_pg0_out_odp;
          data_out(pg0_out_odn_msb_c) <= s_pg0_out_odn;
        when pg0_in_address_c => 
          data_out(pg0_in_ste_msb_c downto pg0_in_ste_lsb_c) <= s_pg0_in_ste;
          data_out(pg0_in_pd_msb_c) <= s_pg0_in_pd;
          data_out(pg0_in_pu_msb_c) <= s_pg0_in_pu;
        when pg1_out_address_c => 
          data_out(pg1_out_ds_msb_c downto pg1_out_ds_lsb_c) <= s_pg1_out_ds;
          data_out(pg1_out_sr_msb_c) <= s_pg1_out_sr;
          data_out(pg1_out_co_msb_c) <= s_pg1_out_co;
          data_out(pg1_out_odp_msb_c) <= s_pg1_out_odp;
          data_out(pg1_out_odn_msb_c) <= s_pg1_out_odn;
        when pg1_in_address_c => 
          data_out(pg1_in_ste_msb_c downto pg1_in_ste_lsb_c) <= s_pg1_in_ste;
          data_out(pg1_in_pd_msb_c) <= s_pg1_in_pd;
          data_out(pg1_in_pu_msb_c) <= s_pg1_in_pu;
        when pg2_out_address_c => 
          data_out(pg2_out_ds_msb_c downto pg2_out_ds_lsb_c) <= s_pg2_out_ds;
          data_out(pg2_out_sr_msb_c) <= s_pg2_out_sr;
          data_out(pg2_out_co_msb_c) <= s_pg2_out_co;
          data_out(pg2_out_odp_msb_c) <= s_pg2_out_odp;
          data_out(pg2_out_odn_msb_c) <= s_pg2_out_odn;
        when pg2_in_address_c => 
          data_out(pg2_in_ste_msb_c downto pg2_in_ste_lsb_c) <= s_pg2_in_ste;
          data_out(pg2_in_pd_msb_c) <= s_pg2_in_pd;
          data_out(pg2_in_pu_msb_c) <= s_pg2_in_pu;
        when pg3_out_address_c => 
          data_out(pg3_out_ds_msb_c downto pg3_out_ds_lsb_c) <= s_pg3_out_ds;
          data_out(pg3_out_sr_msb_c) <= s_pg3_out_sr;
          data_out(pg3_out_co_msb_c) <= s_pg3_out_co;
          data_out(pg3_out_odp_msb_c) <= s_pg3_out_odp;
          data_out(pg3_out_odn_msb_c) <= s_pg3_out_odn;
        when pg3_in_address_c => 
          data_out(pg3_in_ste_msb_c downto pg3_in_ste_lsb_c) <= s_pg3_in_ste;
          data_out(pg3_in_pd_msb_c) <= s_pg3_in_pd;
          data_out(pg3_in_pu_msb_c) <= s_pg3_in_pu;
        when pg4_out_address_c => 
          data_out(pg4_out_ds_msb_c downto pg4_out_ds_lsb_c) <= s_pg4_out_ds;
          data_out(pg4_out_sr_msb_c) <= s_pg4_out_sr;
          data_out(pg4_out_co_msb_c) <= s_pg4_out_co;
          data_out(pg4_out_odp_msb_c) <= s_pg4_out_odp;
          data_out(pg4_out_odn_msb_c) <= s_pg4_out_odn;
        when pg4_in_address_c => 
          data_out(pg4_in_ste_msb_c downto pg4_in_ste_lsb_c) <= s_pg4_in_ste;
          data_out(pg4_in_pd_msb_c) <= s_pg4_in_pd;
          data_out(pg4_in_pu_msb_c) <= s_pg4_in_pu;
        when pg5_out_address_c => 
          data_out(pg5_out_ds_msb_c downto pg5_out_ds_lsb_c) <= s_pg5_out_ds;
          data_out(pg5_out_sr_msb_c) <= s_pg5_out_sr;
          data_out(pg5_out_co_msb_c) <= s_pg5_out_co;
          data_out(pg5_out_odp_msb_c) <= s_pg5_out_odp;
          data_out(pg5_out_odn_msb_c) <= s_pg5_out_odn;
        when pg5_in_address_c => 
          data_out(pg5_in_ste_msb_c downto pg5_in_ste_lsb_c) <= s_pg5_in_ste;
          data_out(pg5_in_pd_msb_c) <= s_pg5_in_pd;
          data_out(pg5_in_pu_msb_c) <= s_pg5_in_pu;
        when pg6_out_address_c => 
          data_out(pg6_out_ds_msb_c downto pg6_out_ds_lsb_c) <= s_pg6_out_ds;
          data_out(pg6_out_sr_msb_c) <= s_pg6_out_sr;
          data_out(pg6_out_co_msb_c) <= s_pg6_out_co;
          data_out(pg6_out_odp_msb_c) <= s_pg6_out_odp;
          data_out(pg6_out_odn_msb_c) <= s_pg6_out_odn;
        when pg6_in_address_c => 
          data_out(pg6_in_ste_msb_c downto pg6_in_ste_lsb_c) <= s_pg6_in_ste;
          data_out(pg6_in_pd_msb_c) <= s_pg6_in_pd;
          data_out(pg6_in_pu_msb_c) <= s_pg6_in_pu;
        when pg7_out_address_c => 
          data_out(pg7_out_ds_msb_c downto pg7_out_ds_lsb_c) <= s_pg7_out_ds;
          data_out(pg7_out_sr_msb_c) <= s_pg7_out_sr;
          data_out(pg7_out_co_msb_c) <= s_pg7_out_co;
          data_out(pg7_out_odp_msb_c) <= s_pg7_out_odp;
          data_out(pg7_out_odn_msb_c) <= s_pg7_out_odn;
        when pg7_in_address_c => 
          data_out(pg7_in_ste_msb_c downto pg7_in_ste_lsb_c) <= s_pg7_in_ste;
          data_out(pg7_in_pd_msb_c) <= s_pg7_in_pd;
          data_out(pg7_in_pu_msb_c) <= s_pg7_in_pu;
        when mtest_address_c => 
          data_out(mtest_ste_msb_c downto mtest_ste_lsb_c) <= s_mtest_ste;
          data_out(mtest_pd_msb_c) <= s_mtest_pd;
          data_out(mtest_pu_msb_c) <= s_mtest_pu;
        when mwake_address_c => 
          data_out(mwake_ste_msb_c downto mwake_ste_lsb_c) <= s_mwake_ste;
          data_out(mwake_pd_msb_c) <= s_mwake_pd;
          data_out(mwake_pu_msb_c) <= s_mwake_pu;
        when mrxout_out_address_c => 
          data_out(mrxout_out_ds_msb_c downto mrxout_out_ds_lsb_c) <= s_mrxout_out_ds;
          data_out(mrxout_out_sr_msb_c) <= s_mrxout_out_sr;
          data_out(mrxout_out_co_msb_c) <= s_mrxout_out_co;
          data_out(mrxout_out_odp_msb_c) <= s_mrxout_out_odp;
          data_out(mrxout_out_odn_msb_c) <= s_mrxout_out_odn;
        when pll_1_address_c => 
          data_out(pll_1_main_div_n1_msb_c) <= s_pll_1_main_div_n1;
          data_out(pll_1_main_div_n2_msb_c downto pll_1_main_div_n2_lsb_c) <= s_pll_1_main_div_n2;
          data_out(pll_1_main_div_n3_msb_c downto pll_1_main_div_n3_lsb_c) <= s_pll_1_main_div_n3;
          data_out(pll_1_main_div_n4_msb_c downto pll_1_main_div_n4_lsb_c) <= s_pll_1_main_div_n4;
        when pll_2_address_c => 
          data_out(pll_2_open_loop_msb_c) <= s_pll_2_open_loop;
          data_out(pll_2_out_div_sel_msb_c downto pll_2_out_div_sel_lsb_c) <= s_pll_2_out_div_sel;
          data_out(pll_2_ci_msb_c downto pll_2_ci_lsb_c) <= s_pll_2_ci;
        when pll_cp_address_c => 
          data_out(pll_cp_cp_msb_c downto pll_cp_cp_lsb_c) <= s_pll_cp_cp;
        when pll_ft_address_c => 
          data_out(pll_ft_ft_msb_c downto pll_ft_ft_lsb_c) <= s_pll_ft_ft;
        when pll_3_address_c => 
          data_out(pll_3_divcore_sel_msb_c downto pll_3_divcore_sel_lsb_c) <= s_pll_3_divcore_sel;
          data_out(pll_3_coarse_msb_c downto pll_3_coarse_lsb_c) <= s_pll_3_coarse;
        when pll_4_address_c => 
          data_out(pll_4_auto_coarsetune_msb_c) <= s_pll_4_auto_coarsetune;
          data_out(pll_4_enforce_lock_msb_c) <= s_pll_4_enforce_lock;
          data_out(pll_4_pfd_select_msb_c) <= s_pll_4_pfd_select;
          data_out(pll_4_lock_window_sel_msb_c) <= s_pll_4_lock_window_sel;
          data_out(pll_4_div_core_mux_sel_msb_c) <= s_pll_4_div_core_mux_sel;
          data_out(pll_4_filter_shift_msb_c downto pll_4_filter_shift_lsb_c) <= s_pll_4_filter_shift;
          data_out(pll_4_en_fast_lock_msb_c) <= s_pll_4_en_fast_lock;
        when pll_5_address_c => 
          data_out(pll_5_sar_limit_msb_c downto pll_5_sar_limit_lsb_c) <= s_pll_5_sar_limit;
          data_out(pll_5_set_op_lock_msb_c) <= s_pll_5_set_op_lock;
          data_out(pll_5_disable_lock_msb_c) <= s_pll_5_disable_lock;
          data_out(pll_5_ref_bypass_msb_c) <= s_pll_5_ref_bypass;
          data_out(pll_5_ct_compensation_msb_c) <= s_pll_5_ct_compensation;
        when adpll_status0_address_c => 
          data_out(adpll_status0_adpll_status_0_msb_c downto adpll_status0_adpll_status_0_lsb_c) <= s_adpll_status0_adpll_status_0;
        when adpll_status1_address_c => 
          data_out(adpll_status1_adpll_status_1_msb_c downto adpll_status1_adpll_status_1_lsb_c) <= s_adpll_status1_adpll_status_1;
        when adpll_status2_address_c => 
          data_out(adpll_status2_adpll_status_2_msb_c downto adpll_status2_adpll_status_2_lsb_c) <= s_adpll_status2_adpll_status_2;
        when io_dack0_n_address_c => 
          data_out(io_dack0_n_ste_msb_c downto io_dack0_n_ste_lsb_c) <= s_io_dack0_n_ste;
          data_out(io_dack0_n_pd_msb_c) <= s_io_dack0_n_pd;
          data_out(io_dack0_n_pu_msb_c) <= s_io_dack0_n_pu;
        when io_dreq0_n_address_c => 
          data_out(io_dreq0_n_ds_msb_c downto io_dreq0_n_ds_lsb_c) <= s_io_dreq0_n_ds;
          data_out(io_dreq0_n_sr_msb_c) <= s_io_dreq0_n_sr;
          data_out(io_dreq0_n_co_msb_c) <= s_io_dreq0_n_co;
          data_out(io_dreq0_n_odp_msb_c) <= s_io_dreq0_n_odp;
          data_out(io_dreq0_n_odn_msb_c) <= s_io_dreq0_n_odn;
        when io_dack1_n_address_c => 
          data_out(io_dack1_n_ste_msb_c downto io_dack1_n_ste_lsb_c) <= s_io_dack1_n_ste;
          data_out(io_dack1_n_pd_msb_c) <= s_io_dack1_n_pd;
          data_out(io_dack1_n_pu_msb_c) <= s_io_dack1_n_pu;
        when io_dreq1_n_address_c => 
          data_out(io_dreq1_n_ds_msb_c downto io_dreq1_n_ds_lsb_c) <= s_io_dreq1_n_ds;
          data_out(io_dreq1_n_sr_msb_c) <= s_io_dreq1_n_sr;
          data_out(io_dreq1_n_co_msb_c) <= s_io_dreq1_n_co;
          data_out(io_dreq1_n_odp_msb_c) <= s_io_dreq1_n_odp;
          data_out(io_dreq1_n_odn_msb_c) <= s_io_dreq1_n_odn;
        when io_dack2_n_address_c => 
          data_out(io_dack2_n_ste_msb_c downto io_dack2_n_ste_lsb_c) <= s_io_dack2_n_ste;
          data_out(io_dack2_n_pd_msb_c) <= s_io_dack2_n_pd;
          data_out(io_dack2_n_pu_msb_c) <= s_io_dack2_n_pu;
        when io_dreq2_n_address_c => 
          data_out(io_dreq2_n_ds_msb_c downto io_dreq2_n_ds_lsb_c) <= s_io_dreq2_n_ds;
          data_out(io_dreq2_n_sr_msb_c) <= s_io_dreq2_n_sr;
          data_out(io_dreq2_n_co_msb_c) <= s_io_dreq2_n_co;
          data_out(io_dreq2_n_odp_msb_c) <= s_io_dreq2_n_odp;
          data_out(io_dreq2_n_odn_msb_c) <= s_io_dreq2_n_odn;
        when io_dack3_n_address_c => 
          data_out(io_dack3_n_ste_msb_c downto io_dack3_n_ste_lsb_c) <= s_io_dack3_n_ste;
          data_out(io_dack3_n_pd_msb_c) <= s_io_dack3_n_pd;
          data_out(io_dack3_n_pu_msb_c) <= s_io_dack3_n_pu;
        when io_dreq3_n_address_c => 
          data_out(io_dreq3_n_ds_msb_c downto io_dreq3_n_ds_lsb_c) <= s_io_dreq3_n_ds;
          data_out(io_dreq3_n_sr_msb_c) <= s_io_dreq3_n_sr;
          data_out(io_dreq3_n_co_msb_c) <= s_io_dreq3_n_co;
          data_out(io_dreq3_n_odp_msb_c) <= s_io_dreq3_n_odp;
          data_out(io_dreq3_n_odn_msb_c) <= s_io_dreq3_n_odn;
        when io_d0_out_address_c => 
          data_out(io_d0_out_ds_msb_c downto io_d0_out_ds_lsb_c) <= s_io_d0_out_ds;
          data_out(io_d0_out_sr_msb_c) <= s_io_d0_out_sr;
          data_out(io_d0_out_co_msb_c) <= s_io_d0_out_co;
          data_out(io_d0_out_odp_msb_c) <= s_io_d0_out_odp;
          data_out(io_d0_out_odn_msb_c) <= s_io_d0_out_odn;
        when io_d0_in_address_c => 
          data_out(io_d0_in_ste_msb_c downto io_d0_in_ste_lsb_c) <= s_io_d0_in_ste;
          data_out(io_d0_in_pd_msb_c) <= s_io_d0_in_pd;
          data_out(io_d0_in_pu_msb_c) <= s_io_d0_in_pu;
        when io_d1_out_address_c => 
          data_out(io_d1_out_ds_msb_c downto io_d1_out_ds_lsb_c) <= s_io_d1_out_ds;
          data_out(io_d1_out_sr_msb_c) <= s_io_d1_out_sr;
          data_out(io_d1_out_co_msb_c) <= s_io_d1_out_co;
          data_out(io_d1_out_odp_msb_c) <= s_io_d1_out_odp;
          data_out(io_d1_out_odn_msb_c) <= s_io_d1_out_odn;
        when io_d1_in_address_c => 
          data_out(io_d1_in_ste_msb_c downto io_d1_in_ste_lsb_c) <= s_io_d1_in_ste;
          data_out(io_d1_in_pd_msb_c) <= s_io_d1_in_pd;
          data_out(io_d1_in_pu_msb_c) <= s_io_d1_in_pu;
        when io_d2_out_address_c => 
          data_out(io_d2_out_ds_msb_c downto io_d2_out_ds_lsb_c) <= s_io_d2_out_ds;
          data_out(io_d2_out_sr_msb_c) <= s_io_d2_out_sr;
          data_out(io_d2_out_co_msb_c) <= s_io_d2_out_co;
          data_out(io_d2_out_odp_msb_c) <= s_io_d2_out_odp;
          data_out(io_d2_out_odn_msb_c) <= s_io_d2_out_odn;
        when io_d2_in_address_c => 
          data_out(io_d2_in_ste_msb_c downto io_d2_in_ste_lsb_c) <= s_io_d2_in_ste;
          data_out(io_d2_in_pd_msb_c) <= s_io_d2_in_pd;
          data_out(io_d2_in_pu_msb_c) <= s_io_d2_in_pu;
        when io_d3_out_address_c => 
          data_out(io_d3_out_ds_msb_c downto io_d3_out_ds_lsb_c) <= s_io_d3_out_ds;
          data_out(io_d3_out_sr_msb_c) <= s_io_d3_out_sr;
          data_out(io_d3_out_co_msb_c) <= s_io_d3_out_co;
          data_out(io_d3_out_odp_msb_c) <= s_io_d3_out_odp;
          data_out(io_d3_out_odn_msb_c) <= s_io_d3_out_odn;
        when io_d3_in_address_c => 
          data_out(io_d3_in_ste_msb_c downto io_d3_in_ste_lsb_c) <= s_io_d3_in_ste;
          data_out(io_d3_in_pd_msb_c) <= s_io_d3_in_pd;
          data_out(io_d3_in_pu_msb_c) <= s_io_d3_in_pu;
        when io_d4_out_address_c => 
          data_out(io_d4_out_ds_msb_c downto io_d4_out_ds_lsb_c) <= s_io_d4_out_ds;
          data_out(io_d4_out_sr_msb_c) <= s_io_d4_out_sr;
          data_out(io_d4_out_co_msb_c) <= s_io_d4_out_co;
          data_out(io_d4_out_odp_msb_c) <= s_io_d4_out_odp;
          data_out(io_d4_out_odn_msb_c) <= s_io_d4_out_odn;
        when io_d4_in_address_c => 
          data_out(io_d4_in_ste_msb_c downto io_d4_in_ste_lsb_c) <= s_io_d4_in_ste;
          data_out(io_d4_in_pd_msb_c) <= s_io_d4_in_pd;
          data_out(io_d4_in_pu_msb_c) <= s_io_d4_in_pu;
        when io_d5_out_address_c => 
          data_out(io_d5_out_ds_msb_c downto io_d5_out_ds_lsb_c) <= s_io_d5_out_ds;
          data_out(io_d5_out_sr_msb_c) <= s_io_d5_out_sr;
          data_out(io_d5_out_co_msb_c) <= s_io_d5_out_co;
          data_out(io_d5_out_odp_msb_c) <= s_io_d5_out_odp;
          data_out(io_d5_out_odn_msb_c) <= s_io_d5_out_odn;
        when io_d5_in_address_c => 
          data_out(io_d5_in_ste_msb_c downto io_d5_in_ste_lsb_c) <= s_io_d5_in_ste;
          data_out(io_d5_in_pd_msb_c) <= s_io_d5_in_pd;
          data_out(io_d5_in_pu_msb_c) <= s_io_d5_in_pu;
        when io_d6_out_address_c => 
          data_out(io_d6_out_ds_msb_c downto io_d6_out_ds_lsb_c) <= s_io_d6_out_ds;
          data_out(io_d6_out_sr_msb_c) <= s_io_d6_out_sr;
          data_out(io_d6_out_co_msb_c) <= s_io_d6_out_co;
          data_out(io_d6_out_odp_msb_c) <= s_io_d6_out_odp;
          data_out(io_d6_out_odn_msb_c) <= s_io_d6_out_odn;
        when io_d6_in_address_c => 
          data_out(io_d6_in_ste_msb_c downto io_d6_in_ste_lsb_c) <= s_io_d6_in_ste;
          data_out(io_d6_in_pd_msb_c) <= s_io_d6_in_pd;
          data_out(io_d6_in_pu_msb_c) <= s_io_d6_in_pu;
        when io_d7_out_address_c => 
          data_out(io_d7_out_ds_msb_c downto io_d7_out_ds_lsb_c) <= s_io_d7_out_ds;
          data_out(io_d7_out_sr_msb_c) <= s_io_d7_out_sr;
          data_out(io_d7_out_co_msb_c) <= s_io_d7_out_co;
          data_out(io_d7_out_odp_msb_c) <= s_io_d7_out_odp;
          data_out(io_d7_out_odn_msb_c) <= s_io_d7_out_odn;
        when io_d7_in_address_c => 
          data_out(io_d7_in_ste_msb_c downto io_d7_in_ste_lsb_c) <= s_io_d7_in_ste;
          data_out(io_d7_in_pd_msb_c) <= s_io_d7_in_pd;
          data_out(io_d7_in_pu_msb_c) <= s_io_d7_in_pu;
        when io_ldout_n_address_c => 
          data_out(io_ldout_n_ds_msb_c downto io_ldout_n_ds_lsb_c) <= s_io_ldout_n_ds;
          data_out(io_ldout_n_sr_msb_c) <= s_io_ldout_n_sr;
          data_out(io_ldout_n_co_msb_c) <= s_io_ldout_n_co;
          data_out(io_ldout_n_odp_msb_c) <= s_io_ldout_n_odp;
          data_out(io_ldout_n_odn_msb_c) <= s_io_ldout_n_odn;
        when io_next_n_address_c => 
          data_out(io_next_n_ds_msb_c downto io_next_n_ds_lsb_c) <= s_io_next_n_ds;
          data_out(io_next_n_sr_msb_c) <= s_io_next_n_sr;
          data_out(io_next_n_co_msb_c) <= s_io_next_n_co;
          data_out(io_next_n_odp_msb_c) <= s_io_next_n_odp;
          data_out(io_next_n_odn_msb_c) <= s_io_next_n_odn;
        when io_clk_address_c => 
          data_out(io_clk_ds_msb_c downto io_clk_ds_lsb_c) <= s_io_clk_ds;
          data_out(io_clk_sr_msb_c) <= s_io_clk_sr;
          data_out(io_clk_co_msb_c) <= s_io_clk_co;
          data_out(io_clk_odp_msb_c) <= s_io_clk_odp;
          data_out(io_clk_odn_msb_c) <= s_io_clk_odn;
        when io_ioa_n_address_c => 
          data_out(io_ioa_n_ds_msb_c downto io_ioa_n_ds_lsb_c) <= s_io_ioa_n_ds;
          data_out(io_ioa_n_sr_msb_c) <= s_io_ioa_n_sr;
          data_out(io_ioa_n_co_msb_c) <= s_io_ioa_n_co;
          data_out(io_ioa_n_odp_msb_c) <= s_io_ioa_n_odp;
          data_out(io_ioa_n_odn_msb_c) <= s_io_ioa_n_odn;
        when mrxout_in_address_c => 
          data_out(mrxout_in_ste_msb_c downto mrxout_in_ste_lsb_c) <= s_mrxout_in_ste;
          data_out(mrxout_in_pd_msb_c) <= s_mrxout_in_pd;
          data_out(mrxout_in_pu_msb_c) <= s_mrxout_in_pu;
        when others => null;
      end case;
    end if;
  end process handle_output_signals;


  s_version_analog <= version_analog;
  s_version_digital <= version_digital;
  mclkout_ds <= s_mclkout_ds;
  mclkout_sr <= s_mclkout_sr;
  mclkout_co <= s_mclkout_co;
  mclkout_odp <= s_mclkout_odp;
  mclkout_odn <= s_mclkout_odn;
  msdout_ds <= s_msdout_ds;
  msdout_sr <= s_msdout_sr;
  msdout_co <= s_msdout_co;
  msdout_odp <= s_msdout_odp;
  msdout_odn <= s_msdout_odn;
  utx_ds <= s_utx_ds;
  utx_sr <= s_utx_sr;
  utx_co <= s_utx_co;
  utx_odp <= s_utx_odp;
  utx_odn <= s_utx_odn;
  mirqout_ds <= s_mirqout_ds;
  mirqout_sr <= s_mirqout_sr;
  mirqout_co <= s_mirqout_co;
  mirqout_odp <= s_mirqout_odp;
  mirqout_odn <= s_mirqout_odn;
  msdin_ste <= s_msdin_ste;
  msdin_pd <= s_msdin_pd;
  msdin_pu <= s_msdin_pu;
  mirq0_ste <= s_mirq0_ste;
  mirq0_pd <= s_mirq0_pd;
  mirq0_pu <= s_mirq0_pu;
  mirq1_ste <= s_mirq1_ste;
  mirq1_pd <= s_mirq1_pd;
  mirq1_pu <= s_mirq1_pu;
  urx_ste <= s_urx_ste;
  urx_pd <= s_urx_pd;
  urx_pu <= s_urx_pu;
  emem_d0_out_ds <= s_emem_d0_out_ds;
  emem_d0_out_sr <= s_emem_d0_out_sr;
  emem_d0_out_co <= s_emem_d0_out_co;
  emem_d0_out_odp <= s_emem_d0_out_odp;
  emem_d0_out_odn <= s_emem_d0_out_odn;
  emem_d0_in_ste <= s_emem_d0_in_ste;
  emem_d0_in_pd <= s_emem_d0_in_pd;
  emem_d0_in_pu <= s_emem_d0_in_pu;
  emem_d1_out_ds <= s_emem_d1_out_ds;
  emem_d1_out_sr <= s_emem_d1_out_sr;
  emem_d1_out_co <= s_emem_d1_out_co;
  emem_d1_out_odp <= s_emem_d1_out_odp;
  emem_d1_out_odn <= s_emem_d1_out_odn;
  emem_d1_in_ste <= s_emem_d1_in_ste;
  emem_d1_in_pd <= s_emem_d1_in_pd;
  emem_d1_in_pu <= s_emem_d1_in_pu;
  emem_d2_out_ds <= s_emem_d2_out_ds;
  emem_d2_out_sr <= s_emem_d2_out_sr;
  emem_d2_out_co <= s_emem_d2_out_co;
  emem_d2_out_odp <= s_emem_d2_out_odp;
  emem_d2_out_odn <= s_emem_d2_out_odn;
  emem_d2_in_ste <= s_emem_d2_in_ste;
  emem_d2_in_pd <= s_emem_d2_in_pd;
  emem_d2_in_pu <= s_emem_d2_in_pu;
  emem_d3_out_ds <= s_emem_d3_out_ds;
  emem_d3_out_sr <= s_emem_d3_out_sr;
  emem_d3_out_co <= s_emem_d3_out_co;
  emem_d3_out_odp <= s_emem_d3_out_odp;
  emem_d3_out_odn <= s_emem_d3_out_odn;
  emem_d3_in_ste <= s_emem_d3_in_ste;
  emem_d3_in_pd <= s_emem_d3_in_pd;
  emem_d3_in_pu <= s_emem_d3_in_pu;
  emem_d4_out_ds <= s_emem_d4_out_ds;
  emem_d4_out_sr <= s_emem_d4_out_sr;
  emem_d4_out_co <= s_emem_d4_out_co;
  emem_d4_out_odp <= s_emem_d4_out_odp;
  emem_d4_out_odn <= s_emem_d4_out_odn;
  emem_d4_in_ste <= s_emem_d4_in_ste;
  emem_d4_in_pd <= s_emem_d4_in_pd;
  emem_d4_in_pu <= s_emem_d4_in_pu;
  emem_d5_out_ds <= s_emem_d5_out_ds;
  emem_d5_out_sr <= s_emem_d5_out_sr;
  emem_d5_out_co <= s_emem_d5_out_co;
  emem_d5_out_odp <= s_emem_d5_out_odp;
  emem_d5_out_odn <= s_emem_d5_out_odn;
  emem_d5_in_ste <= s_emem_d5_in_ste;
  emem_d5_in_pd <= s_emem_d5_in_pd;
  emem_d5_in_pu <= s_emem_d5_in_pu;
  emem_d6_out_ds <= s_emem_d6_out_ds;
  emem_d6_out_sr <= s_emem_d6_out_sr;
  emem_d6_out_co <= s_emem_d6_out_co;
  emem_d6_out_odp <= s_emem_d6_out_odp;
  emem_d6_out_odn <= s_emem_d6_out_odn;
  emem_d6_in_ste <= s_emem_d6_in_ste;
  emem_d6_in_pd <= s_emem_d6_in_pd;
  emem_d6_in_pu <= s_emem_d6_in_pu;
  emem_d7_out_ds <= s_emem_d7_out_ds;
  emem_d7_out_sr <= s_emem_d7_out_sr;
  emem_d7_out_co <= s_emem_d7_out_co;
  emem_d7_out_odp <= s_emem_d7_out_odp;
  emem_d7_out_odn <= s_emem_d7_out_odn;
  emem_d7_in_ste <= s_emem_d7_in_ste;
  emem_d7_in_pd <= s_emem_d7_in_pd;
  emem_d7_in_pu <= s_emem_d7_in_pu;
  emem_clk_ds <= s_emem_clk_ds;
  emem_clk_sr <= s_emem_clk_sr;
  emem_clk_co <= s_emem_clk_co;
  emem_clk_odp <= s_emem_clk_odp;
  emem_clk_odn <= s_emem_clk_odn;
  emem_rwds_out_ds <= s_emem_rwds_out_ds;
  emem_rwds_out_sr <= s_emem_rwds_out_sr;
  emem_rwds_out_co <= s_emem_rwds_out_co;
  emem_rwds_out_odp <= s_emem_rwds_out_odp;
  emem_rwds_out_odn <= s_emem_rwds_out_odn;
  emem_rwds_in_ste <= s_emem_rwds_in_ste;
  emem_rwds_in_pd <= s_emem_rwds_in_pd;
  emem_rwds_in_pu <= s_emem_rwds_in_pu;
  emem_cs_n_ds <= s_emem_cs_n_ds;
  emem_cs_n_sr <= s_emem_cs_n_sr;
  emem_cs_n_co <= s_emem_cs_n_co;
  emem_cs_n_odp <= s_emem_cs_n_odp;
  emem_cs_n_odn <= s_emem_cs_n_odn;
  emem_rst_n_ds <= s_emem_rst_n_ds;
  emem_rst_n_sr <= s_emem_rst_n_sr;
  emem_rst_n_co <= s_emem_rst_n_co;
  emem_rst_n_odp <= s_emem_rst_n_odp;
  emem_rst_n_odn <= s_emem_rst_n_odn;
  aout0_ds <= s_aout0_ds;
  aout0_sr <= s_aout0_sr;
  aout0_co <= s_aout0_co;
  aout0_odp <= s_aout0_odp;
  aout0_odn <= s_aout0_odn;
  aout1_ds <= s_aout1_ds;
  aout1_sr <= s_aout1_sr;
  aout1_co <= s_aout1_co;
  aout1_odp <= s_aout1_odp;
  aout1_odn <= s_aout1_odn;
  ach0_ste <= s_ach0_ste;
  ach0_pd <= s_ach0_pd;
  ach0_pu <= s_ach0_pu;
  enet_mdio_out_ds <= s_enet_mdio_out_ds;
  enet_mdio_out_sr <= s_enet_mdio_out_sr;
  enet_mdio_out_co <= s_enet_mdio_out_co;
  enet_mdio_out_odp <= s_enet_mdio_out_odp;
  enet_mdio_out_odn <= s_enet_mdio_out_odn;
  enet_mdio_in_ste <= s_enet_mdio_in_ste;
  enet_mdio_in_pd <= s_enet_mdio_in_pd;
  enet_mdio_in_pu <= s_enet_mdio_in_pu;
  enet_mdc_ds <= s_enet_mdc_ds;
  enet_mdc_sr <= s_enet_mdc_sr;
  enet_mdc_co <= s_enet_mdc_co;
  enet_mdc_odp <= s_enet_mdc_odp;
  enet_mdc_odn <= s_enet_mdc_odn;
  enet_txer_ds <= s_enet_txer_ds;
  enet_txer_sr <= s_enet_txer_sr;
  enet_txer_co <= s_enet_txer_co;
  enet_txer_odp <= s_enet_txer_odp;
  enet_txer_odn <= s_enet_txer_odn;
  enet_txd0_ds <= s_enet_txd0_ds;
  enet_txd0_sr <= s_enet_txd0_sr;
  enet_txd0_co <= s_enet_txd0_co;
  enet_txd0_odp <= s_enet_txd0_odp;
  enet_txd0_odn <= s_enet_txd0_odn;
  enet_txd1_ds <= s_enet_txd1_ds;
  enet_txd1_sr <= s_enet_txd1_sr;
  enet_txd1_co <= s_enet_txd1_co;
  enet_txd1_odp <= s_enet_txd1_odp;
  enet_txd1_odn <= s_enet_txd1_odn;
  enet_txen_ds <= s_enet_txen_ds;
  enet_txen_sr <= s_enet_txen_sr;
  enet_txen_co <= s_enet_txen_co;
  enet_txen_odp <= s_enet_txen_odp;
  enet_txen_odn <= s_enet_txen_odn;
  enet_clk_ste <= s_enet_clk_ste;
  enet_clk_pd <= s_enet_clk_pd;
  enet_clk_pu <= s_enet_clk_pu;
  enet_rxdv_ste <= s_enet_rxdv_ste;
  enet_rxdv_pd <= s_enet_rxdv_pd;
  enet_rxdv_pu <= s_enet_rxdv_pu;
  enet_rxd0_ste <= s_enet_rxd0_ste;
  enet_rxd0_pd <= s_enet_rxd0_pd;
  enet_rxd0_pu <= s_enet_rxd0_pu;
  enet_rxd1_ste <= s_enet_rxd1_ste;
  enet_rxd1_pd <= s_enet_rxd1_pd;
  enet_rxd1_pu <= s_enet_rxd1_pu;
  enet_rxer_ste <= s_enet_rxer_ste;
  enet_rxer_pd <= s_enet_rxer_pd;
  enet_rxer_pu <= s_enet_rxer_pu;
  spi_sclk_ste <= s_spi_sclk_ste;
  spi_sclk_pd <= s_spi_sclk_pd;
  spi_sclk_pu <= s_spi_sclk_pu;
  spi_cs_n_ste <= s_spi_cs_n_ste;
  spi_cs_n_pd <= s_spi_cs_n_pd;
  spi_cs_n_pu <= s_spi_cs_n_pu;
  spi_mosi_ste <= s_spi_mosi_ste;
  spi_mosi_pd <= s_spi_mosi_pd;
  spi_mosi_pu <= s_spi_mosi_pu;
  spi_miso_ds <= s_spi_miso_ds;
  spi_miso_sr <= s_spi_miso_sr;
  spi_miso_co <= s_spi_miso_co;
  spi_miso_odp <= s_spi_miso_odp;
  spi_miso_odn <= s_spi_miso_odn;
  pll_ref_clk_ste <= s_pll_ref_clk_ste;
  pll_ref_clk_pd <= s_pll_ref_clk_pd;
  pll_ref_clk_pu <= s_pll_ref_clk_pu;
  pa0_sin_out_ds <= s_pa0_sin_out_ds;
  pa0_sin_out_sr <= s_pa0_sin_out_sr;
  pa0_sin_out_co <= s_pa0_sin_out_co;
  pa0_sin_out_odp <= s_pa0_sin_out_odp;
  pa0_sin_out_odn <= s_pa0_sin_out_odn;
  pa0_sin_in_ste <= s_pa0_sin_in_ste;
  pa0_sin_in_pd <= s_pa0_sin_in_pd;
  pa0_sin_in_pu <= s_pa0_sin_in_pu;
  pa5_cs_n_out_ds <= s_pa5_cs_n_out_ds;
  pa5_cs_n_out_sr <= s_pa5_cs_n_out_sr;
  pa5_cs_n_out_co <= s_pa5_cs_n_out_co;
  pa5_cs_n_out_odp <= s_pa5_cs_n_out_odp;
  pa5_cs_n_out_odn <= s_pa5_cs_n_out_odn;
  pa5_cs_n_in_ste <= s_pa5_cs_n_in_ste;
  pa5_cs_n_in_pd <= s_pa5_cs_n_in_pd;
  pa5_cs_n_in_pu <= s_pa5_cs_n_in_pu;
  pa6_sck_out_ds <= s_pa6_sck_out_ds;
  pa6_sck_out_sr <= s_pa6_sck_out_sr;
  pa6_sck_out_co <= s_pa6_sck_out_co;
  pa6_sck_out_odp <= s_pa6_sck_out_odp;
  pa6_sck_out_odn <= s_pa6_sck_out_odn;
  pa6_sck_in_ste <= s_pa6_sck_in_ste;
  pa6_sck_in_pd <= s_pa6_sck_in_pd;
  pa6_sck_in_pu <= s_pa6_sck_in_pu;
  pa7_sout_out_ds <= s_pa7_sout_out_ds;
  pa7_sout_out_sr <= s_pa7_sout_out_sr;
  pa7_sout_out_co <= s_pa7_sout_out_co;
  pa7_sout_out_odp <= s_pa7_sout_out_odp;
  pa7_sout_out_odn <= s_pa7_sout_out_odn;
  pa7_sout_in_ste <= s_pa7_sout_in_ste;
  pa7_sout_in_pd <= s_pa7_sout_in_pd;
  pa7_sout_in_pu <= s_pa7_sout_in_pu;
  pg0_out_ds <= s_pg0_out_ds;
  pg0_out_sr <= s_pg0_out_sr;
  pg0_out_co <= s_pg0_out_co;
  pg0_out_odp <= s_pg0_out_odp;
  pg0_out_odn <= s_pg0_out_odn;
  pg0_in_ste <= s_pg0_in_ste;
  pg0_in_pd <= s_pg0_in_pd;
  pg0_in_pu <= s_pg0_in_pu;
  pg1_out_ds <= s_pg1_out_ds;
  pg1_out_sr <= s_pg1_out_sr;
  pg1_out_co <= s_pg1_out_co;
  pg1_out_odp <= s_pg1_out_odp;
  pg1_out_odn <= s_pg1_out_odn;
  pg1_in_ste <= s_pg1_in_ste;
  pg1_in_pd <= s_pg1_in_pd;
  pg1_in_pu <= s_pg1_in_pu;
  pg2_out_ds <= s_pg2_out_ds;
  pg2_out_sr <= s_pg2_out_sr;
  pg2_out_co <= s_pg2_out_co;
  pg2_out_odp <= s_pg2_out_odp;
  pg2_out_odn <= s_pg2_out_odn;
  pg2_in_ste <= s_pg2_in_ste;
  pg2_in_pd <= s_pg2_in_pd;
  pg2_in_pu <= s_pg2_in_pu;
  pg3_out_ds <= s_pg3_out_ds;
  pg3_out_sr <= s_pg3_out_sr;
  pg3_out_co <= s_pg3_out_co;
  pg3_out_odp <= s_pg3_out_odp;
  pg3_out_odn <= s_pg3_out_odn;
  pg3_in_ste <= s_pg3_in_ste;
  pg3_in_pd <= s_pg3_in_pd;
  pg3_in_pu <= s_pg3_in_pu;
  pg4_out_ds <= s_pg4_out_ds;
  pg4_out_sr <= s_pg4_out_sr;
  pg4_out_co <= s_pg4_out_co;
  pg4_out_odp <= s_pg4_out_odp;
  pg4_out_odn <= s_pg4_out_odn;
  pg4_in_ste <= s_pg4_in_ste;
  pg4_in_pd <= s_pg4_in_pd;
  pg4_in_pu <= s_pg4_in_pu;
  pg5_out_ds <= s_pg5_out_ds;
  pg5_out_sr <= s_pg5_out_sr;
  pg5_out_co <= s_pg5_out_co;
  pg5_out_odp <= s_pg5_out_odp;
  pg5_out_odn <= s_pg5_out_odn;
  pg5_in_ste <= s_pg5_in_ste;
  pg5_in_pd <= s_pg5_in_pd;
  pg5_in_pu <= s_pg5_in_pu;
  pg6_out_ds <= s_pg6_out_ds;
  pg6_out_sr <= s_pg6_out_sr;
  pg6_out_co <= s_pg6_out_co;
  pg6_out_odp <= s_pg6_out_odp;
  pg6_out_odn <= s_pg6_out_odn;
  pg6_in_ste <= s_pg6_in_ste;
  pg6_in_pd <= s_pg6_in_pd;
  pg6_in_pu <= s_pg6_in_pu;
  pg7_out_ds <= s_pg7_out_ds;
  pg7_out_sr <= s_pg7_out_sr;
  pg7_out_co <= s_pg7_out_co;
  pg7_out_odp <= s_pg7_out_odp;
  pg7_out_odn <= s_pg7_out_odn;
  pg7_in_ste <= s_pg7_in_ste;
  pg7_in_pd <= s_pg7_in_pd;
  pg7_in_pu <= s_pg7_in_pu;
  mtest_ste <= s_mtest_ste;
  mtest_pd <= s_mtest_pd;
  mtest_pu <= s_mtest_pu;
  mwake_ste <= s_mwake_ste;
  mwake_pd <= s_mwake_pd;
  mwake_pu <= s_mwake_pu;
  mrxout_out_ds <= s_mrxout_out_ds;
  mrxout_out_sr <= s_mrxout_out_sr;
  mrxout_out_co <= s_mrxout_out_co;
  mrxout_out_odp <= s_mrxout_out_odp;
  mrxout_out_odn <= s_mrxout_out_odn;
  pll_1_main_div_n1 <= s_pll_1_main_div_n1;
  pll_1_main_div_n2 <= s_pll_1_main_div_n2;
  pll_1_main_div_n3 <= s_pll_1_main_div_n3;
  pll_1_main_div_n4 <= s_pll_1_main_div_n4;
  pll_2_open_loop <= s_pll_2_open_loop;
  pll_2_out_div_sel <= s_pll_2_out_div_sel;
  pll_2_ci <= s_pll_2_ci;
  pll_cp_cp <= s_pll_cp_cp;
  pll_ft_ft <= s_pll_ft_ft;
  pll_3_divcore_sel <= s_pll_3_divcore_sel;
  pll_3_coarse <= s_pll_3_coarse;
  pll_4_auto_coarsetune <= s_pll_4_auto_coarsetune;
  pll_4_enforce_lock <= s_pll_4_enforce_lock;
  pll_4_pfd_select <= s_pll_4_pfd_select;
  pll_4_lock_window_sel <= s_pll_4_lock_window_sel;
  pll_4_div_core_mux_sel <= s_pll_4_div_core_mux_sel;
  pll_4_filter_shift <= s_pll_4_filter_shift;
  pll_4_en_fast_lock <= s_pll_4_en_fast_lock;
  pll_5_sar_limit <= s_pll_5_sar_limit;
  pll_5_set_op_lock <= s_pll_5_set_op_lock;
  pll_5_disable_lock <= s_pll_5_disable_lock;
  pll_5_ref_bypass <= s_pll_5_ref_bypass;
  pll_5_ct_compensation <= s_pll_5_ct_compensation;
  s_adpll_status0_adpll_status_0 <= adpll_status0_adpll_status_0;
  s_adpll_status1_adpll_status_1 <= adpll_status1_adpll_status_1;
  s_adpll_status2_adpll_status_2 <= adpll_status2_adpll_status_2;
  io_dack0_n_ste <= s_io_dack0_n_ste;
  io_dack0_n_pd <= s_io_dack0_n_pd;
  io_dack0_n_pu <= s_io_dack0_n_pu;
  io_dreq0_n_ds <= s_io_dreq0_n_ds;
  io_dreq0_n_sr <= s_io_dreq0_n_sr;
  io_dreq0_n_co <= s_io_dreq0_n_co;
  io_dreq0_n_odp <= s_io_dreq0_n_odp;
  io_dreq0_n_odn <= s_io_dreq0_n_odn;
  io_dack1_n_ste <= s_io_dack1_n_ste;
  io_dack1_n_pd <= s_io_dack1_n_pd;
  io_dack1_n_pu <= s_io_dack1_n_pu;
  io_dreq1_n_ds <= s_io_dreq1_n_ds;
  io_dreq1_n_sr <= s_io_dreq1_n_sr;
  io_dreq1_n_co <= s_io_dreq1_n_co;
  io_dreq1_n_odp <= s_io_dreq1_n_odp;
  io_dreq1_n_odn <= s_io_dreq1_n_odn;
  io_dack2_n_ste <= s_io_dack2_n_ste;
  io_dack2_n_pd <= s_io_dack2_n_pd;
  io_dack2_n_pu <= s_io_dack2_n_pu;
  io_dreq2_n_ds <= s_io_dreq2_n_ds;
  io_dreq2_n_sr <= s_io_dreq2_n_sr;
  io_dreq2_n_co <= s_io_dreq2_n_co;
  io_dreq2_n_odp <= s_io_dreq2_n_odp;
  io_dreq2_n_odn <= s_io_dreq2_n_odn;
  io_dack3_n_ste <= s_io_dack3_n_ste;
  io_dack3_n_pd <= s_io_dack3_n_pd;
  io_dack3_n_pu <= s_io_dack3_n_pu;
  io_dreq3_n_ds <= s_io_dreq3_n_ds;
  io_dreq3_n_sr <= s_io_dreq3_n_sr;
  io_dreq3_n_co <= s_io_dreq3_n_co;
  io_dreq3_n_odp <= s_io_dreq3_n_odp;
  io_dreq3_n_odn <= s_io_dreq3_n_odn;
  io_d0_out_ds <= s_io_d0_out_ds;
  io_d0_out_sr <= s_io_d0_out_sr;
  io_d0_out_co <= s_io_d0_out_co;
  io_d0_out_odp <= s_io_d0_out_odp;
  io_d0_out_odn <= s_io_d0_out_odn;
  io_d0_in_ste <= s_io_d0_in_ste;
  io_d0_in_pd <= s_io_d0_in_pd;
  io_d0_in_pu <= s_io_d0_in_pu;
  io_d1_out_ds <= s_io_d1_out_ds;
  io_d1_out_sr <= s_io_d1_out_sr;
  io_d1_out_co <= s_io_d1_out_co;
  io_d1_out_odp <= s_io_d1_out_odp;
  io_d1_out_odn <= s_io_d1_out_odn;
  io_d1_in_ste <= s_io_d1_in_ste;
  io_d1_in_pd <= s_io_d1_in_pd;
  io_d1_in_pu <= s_io_d1_in_pu;
  io_d2_out_ds <= s_io_d2_out_ds;
  io_d2_out_sr <= s_io_d2_out_sr;
  io_d2_out_co <= s_io_d2_out_co;
  io_d2_out_odp <= s_io_d2_out_odp;
  io_d2_out_odn <= s_io_d2_out_odn;
  io_d2_in_ste <= s_io_d2_in_ste;
  io_d2_in_pd <= s_io_d2_in_pd;
  io_d2_in_pu <= s_io_d2_in_pu;
  io_d3_out_ds <= s_io_d3_out_ds;
  io_d3_out_sr <= s_io_d3_out_sr;
  io_d3_out_co <= s_io_d3_out_co;
  io_d3_out_odp <= s_io_d3_out_odp;
  io_d3_out_odn <= s_io_d3_out_odn;
  io_d3_in_ste <= s_io_d3_in_ste;
  io_d3_in_pd <= s_io_d3_in_pd;
  io_d3_in_pu <= s_io_d3_in_pu;
  io_d4_out_ds <= s_io_d4_out_ds;
  io_d4_out_sr <= s_io_d4_out_sr;
  io_d4_out_co <= s_io_d4_out_co;
  io_d4_out_odp <= s_io_d4_out_odp;
  io_d4_out_odn <= s_io_d4_out_odn;
  io_d4_in_ste <= s_io_d4_in_ste;
  io_d4_in_pd <= s_io_d4_in_pd;
  io_d4_in_pu <= s_io_d4_in_pu;
  io_d5_out_ds <= s_io_d5_out_ds;
  io_d5_out_sr <= s_io_d5_out_sr;
  io_d5_out_co <= s_io_d5_out_co;
  io_d5_out_odp <= s_io_d5_out_odp;
  io_d5_out_odn <= s_io_d5_out_odn;
  io_d5_in_ste <= s_io_d5_in_ste;
  io_d5_in_pd <= s_io_d5_in_pd;
  io_d5_in_pu <= s_io_d5_in_pu;
  io_d6_out_ds <= s_io_d6_out_ds;
  io_d6_out_sr <= s_io_d6_out_sr;
  io_d6_out_co <= s_io_d6_out_co;
  io_d6_out_odp <= s_io_d6_out_odp;
  io_d6_out_odn <= s_io_d6_out_odn;
  io_d6_in_ste <= s_io_d6_in_ste;
  io_d6_in_pd <= s_io_d6_in_pd;
  io_d6_in_pu <= s_io_d6_in_pu;
  io_d7_out_ds <= s_io_d7_out_ds;
  io_d7_out_sr <= s_io_d7_out_sr;
  io_d7_out_co <= s_io_d7_out_co;
  io_d7_out_odp <= s_io_d7_out_odp;
  io_d7_out_odn <= s_io_d7_out_odn;
  io_d7_in_ste <= s_io_d7_in_ste;
  io_d7_in_pd <= s_io_d7_in_pd;
  io_d7_in_pu <= s_io_d7_in_pu;
  io_ldout_n_ds <= s_io_ldout_n_ds;
  io_ldout_n_sr <= s_io_ldout_n_sr;
  io_ldout_n_co <= s_io_ldout_n_co;
  io_ldout_n_odp <= s_io_ldout_n_odp;
  io_ldout_n_odn <= s_io_ldout_n_odn;
  io_next_n_ds <= s_io_next_n_ds;
  io_next_n_sr <= s_io_next_n_sr;
  io_next_n_co <= s_io_next_n_co;
  io_next_n_odp <= s_io_next_n_odp;
  io_next_n_odn <= s_io_next_n_odn;
  io_clk_ds <= s_io_clk_ds;
  io_clk_sr <= s_io_clk_sr;
  io_clk_co <= s_io_clk_co;
  io_clk_odp <= s_io_clk_odp;
  io_clk_odn <= s_io_clk_odn;
  io_ioa_n_ds <= s_io_ioa_n_ds;
  io_ioa_n_sr <= s_io_ioa_n_sr;
  io_ioa_n_co <= s_io_ioa_n_co;
  io_ioa_n_odp <= s_io_ioa_n_odp;
  io_ioa_n_odn <= s_io_ioa_n_odn;
  mrxout_in_ste <= s_mrxout_in_ste;
  mrxout_in_pd <= s_mrxout_in_pd;
  mrxout_in_pu <= s_mrxout_in_pu;

end rtl;

