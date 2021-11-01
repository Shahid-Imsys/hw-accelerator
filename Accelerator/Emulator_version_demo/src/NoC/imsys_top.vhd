library ieee;
use ieee.std_logic_1164.all;
use work.all;
--use work.gp_pkg.all;

entity imsys_top is
  port (

    ref_clk                     : in  std_logic;                     -- 333.33MHz reference clock. Can be used to generate internal clocks with an MMCM
    -- PCIe DMA
    pcie_req_if_clk_o           : out std_logic;                       -- Request interfaces clock (no requirements to frequency)
    pcie_req_if_rst_o           : out std_logic;                       -- Reset synchronized to request interfaces clock
    pcie_wr_req_ctrl_wrs        : out std_logic;                       -- Write strobe for write request control FIFO - validates all other wr_req_ctrl* signals - must be set in same
                                                                       -- clock cycle as the last data word is written (wr_req_data)
    pcie_rsp_if_clk_i           : in  std_logic; --CJ Added
    pcie_rsp_if_rst_i           : in  std_logic; --CJ Added
    pcie_wr_req_ctrl_length     : out std_logic_vector(4 downto 0);   -- Write request control - length in number of cachelines - 1
    pcie_wr_req_ctrl_start_addr : out std_logic_vector(57 downto 0);  -- Write request control - cacheline aligned start address. Lower 6 bits of the byte address must be zero and are
                                                                       -- not part of this signal.
    pcie_wr_req_ctrl_afu        : in  std_logic;                       -- Write request control FIFO almost full indication - used for backpresure when room for less than 5 entries
    pcie_wr_req_data_wrs        : out std_logic;                       -- Write strobe for write request data FIFO - validates wr_req_data
    pcie_wr_req_data            : out std_logic_vector (255 downto 0); -- Write request data
    pcie_wr_req_data_afu        : in  std_logic;                       -- Write request data FIFO almost full indication - used for backpresure when room for less than 4kB data
    pcie_rd_req_wrs             : out std_logic;                       -- Write strobe for read request FIFO - validates all other rd_req* signals
    pcie_rd_req_start_addr      : out std_logic_vector (57 downto 0);  -- Read request - cacheline aligned start address. Lower 6 bits of the byte address must be zero and are not included in this signal.
    pcie_rd_req_length          : out std_logic_vector (4 downto 0);   -- Read request - length in number of Cachelines - 1
    pcie_rd_req_afu             : in  std_logic;                       -- Read request FIFO almost full indication - used for backpresure when room for less than 5 entries
    pcie_rd_resp_data_vld       : in  std_logic;                       -- Read response valid - validates all other rd_resp_data* signals. Data must be accepted by client as it arrives on this interface
    pcie_rd_resp_data_first     : in  std_logic;                       -- Read response first - high on first word of response
    pcie_rd_resp_data_last      : in  std_logic;                       -- Read response last - high on first word of response
    pcie_rd_resp_data           : in  std_logic_vector (255 downto 0); -- Read response data

    -- DDR4
    ddr4_clk_i                  : in  std_logic;                       -- DDR4 clk (can be used for driving the DDR4 cell interface)
    ddr4_cell_clk_o             : out std_logic;                       -- Clock for DDR4 cell interface. Must not be faster than the 3ns DDR4 clock
    ddr4_cell_rst_o             : out std_logic;                       -- Reset for DDR4 cell interface.
    ddr4_cell_input_start       : out std_logic;                       -- Start of Cell indication
    ddr4_cell_input_data        : out std_logic_vector (255 downto 0); -- Cell data bus. 2KB data must be provided without gaps. First word is indicated with cell_input_start = 1
    ddr4_cell_input_ready       : in  std_logic;                       -- Ready to receive cell. There is room for rest of current cell + 1 more cell of 2KB when cell_input_ready goes high.
    ddr4_input_addr             : out std_logic_vector (21 downto 0);  -- Address where to write cell_input. Must be set in same cycle as cell_input_start.
    ddr4_cell_output_start      : in  std_logic;                       -- Start of Cell indication
    ddr4_cell_output_data       : in  std_logic_vector (255 downto 0); -- Cell data bus. 2KB data is provided without gaps. First word is indicated with cell_output_start = 1
    ddr4_cell_output_ready      : out std_logic;                       -- Ready to receive cell. A new cell will only be output it this input is 1.
    ddr4_output_addr_vld        : out std_logic;                       -- Validates output_addr
    ddr4_output_addr            : out std_logic_vector (21 downto 0);  -- Address where to read cell input. Is sampled when output_addr_vld is 1
    ddr4_output_addr_afu        : in  std_logic;                       -- Output address FIFO almost full. Room for 2 more addresses after being set.
    ddr4_output_addr_ovf        : in  std_logic;                       -- Output address FIFO has overflowed.

    -- Config and status interface#1
    reg1_ref_clk                : in  std_logic;                     -- reference clock for interface. Can be used to generate user_clk
    reg1_user_clk               : out std_logic;                     -- User generated clock. All signals of the interface refers to this clock
    reg1_user_rst               : out std_logic;                     -- Optional reset of register access module external to this module
    reg1_wea                    : in  std_logic;                     -- Write enable
    reg1_wda                    : in  std_logic_vector(31 downto 0); -- Write data
    reg1_ada                    : in  std_logic_vector(15 downto 0); -- Address
    reg1_rea                    : in  std_logic;                     -- Read enable
    reg1_rda                    : out std_logic_vector(31 downto 0); -- Read data
    reg1_rdav                   : out std_logic;                     -- Read data valid
    reg1_ac                     : out std_logic;                     -- Access complete

    -- Config and status interface#2
    reg2_ref_clk                : in  std_logic;                     -- reference clock for interface. Can be used to generate user_clk
    reg2_user_clk               : out std_logic;                     -- User generated clock. All signals of the interface refers to this clock
    reg2_user_rst               : out std_logic;                     -- Optional reset of register access module external to this module
    reg2_wea                    : in  std_logic;                     -- Write enable
    reg2_wda                    : in  std_logic_vector(31 downto 0); -- Write data
    reg2_ada                    : in  std_logic_vector(15 downto 0); -- Address
    reg2_rea                    : in  std_logic;                     -- Read enable
    reg2_rda                    : out std_logic_vector(31 downto 0); -- Read data
    reg2_rdav                   : out std_logic;                     -- Read data valid
    reg2_ac                     : out std_logic;                     -- Access complete
    
    -- clocks and control signals
    HCLK                        : in  std_logic;                  -- clk input, use this or an internally generated clock for CPU core
    MRESET                      : in  std_logic;                  -- system reset               low active
    MIRQOUT                     : out std_logic;                  -- interrupt request output    
    MCKOUT0                     : out std_logic;                  -- for trace adapter
    MCKOUT1                     : out std_logic;                  -- programable clock out
    MTEST                       : in  std_logic;                  --                            high active                 
    MBYPASS                     : in  std_logic;
    MIRQ0                       : in  std_logic;                  --                            low active
    MIRQ1                       : in  std_logic;                  --                            low active
    -- SW debug                                                               
    MSDIN                       : in  std_logic;                  -- serial data in (debug)     
    MSDOUT                      : out std_logic                   -- serial data out    
  );
end imsys_top;

architecture struct of imsys_top is

  component pcie_a
  port (
  
      REF_CLK                     : in    std_logic;
      -- PCIe DMA
      PCIE_REQ_IF_CLK_O           : out std_logic;                      
      PCIE_REQ_IF_RST_O           : out std_logic;
      PCIE_RSP_IF_CLK_I           : in  std_logic;  --250 MHz,
      PCIE_RSP_IF_RST_I           : in  std_logic;                      
      PCIE_WR_REQ_CTRL_WRS        : out std_logic;                      
                                                                        
      PCIE_WR_REQ_CTRL_LENGTH     : out std_logic_vector (4 downto 0);  
      PCIE_WR_REQ_CTRL_START_ADDR : out std_logic_vector (57 downto 0); 
                                                                        
      PCIE_WR_REQ_CTRL_AFU        : in  std_logic;                      
      PCIE_WR_REQ_DATA_WRS        : out std_logic;                      
      PCIE_WR_REQ_DATA            : out std_logic_vector (255 downto 0);
      PCIE_WR_REQ_DATA_AFU        : in  std_logic;                      
      PCIE_RD_REQ_WRS             : out std_logic;                      
      PCIE_RD_REQ_START_ADDR      : out std_logic_vector (57 downto 0); 
      PCIE_RD_REQ_LENGTH          : out std_logic_vector (4 downto 0);  
      PCIE_RD_REQ_AFU             : in  std_logic;                      
      PCIE_RD_RESP_DATA_VLD       : in  std_logic;                      
      PCIE_RD_RESP_DATA_FIRST     : in  std_logic;                      
      PCIE_RD_RESP_DATA_LAST      : in  std_logic;                      
      PCIE_RD_RESP_DATA           : in  std_logic_vector (255 downto 0);

      -- Config and status interface#1
      REG1_REF_CLK                : in  std_logic;                    
      REG1_USER_CLK               : out std_logic;                    
      REG1_USER_RST               : out std_logic;                    
      REG1_WEA                    : in  std_logic;                    
      REG1_WDA                    : in  std_logic_vector(31 downto 0);
      REG1_ADA                    : in  std_logic_vector(15 downto 0);
      REG1_REA                    : in  std_logic;                    
      REG1_RDA                    : out std_logic_vector(31 downto 0);
      REG1_RDAV                   : out std_logic;                    
      REG1_AC                     : out std_logic;             

      --NOC side
      NOC_DATA                    : out std_logic_vector(255 downto 0);
      PCIE_DATA                   : in  std_logic_vector(255 downto 0);
      PCIE_ADDRESS                : in  std_logic_vector(31 downto 0);
      PCIE_LENGTH                 : in  std_logic_vector(4 downto 0);
      PCIE_RDY                    : out std_logic;
      CMD_FLAG                    : out std_logic;  --PCIe CMD
      NOC_CMD_FLAG                : in  std_logic;
      RW_FLAG                     : in  std_logic;  --0 means "read from PCIe", 1 means "write to PCIe"
      ENA_PCIE_CTL                : in  std_logic;
      ENA_PCIE_DATA               : in  std_logic;
      PCIE_REQ                    : in  std_logic;
      PCIE_ACK                    : out std_logic;
      NOC_RST                     : in  std_logic;
      reset_out                   : out std_logic;
      --Test
      h2c_cmd_t                   : out std_logic;
      c2h_cmd_t                   : out std_logic;
      pcie_wr_data_wrs_t          : out std_logic;
      pcie_wr_ctl_wrs_t           : out std_logic   
  );
end component;

component Noc_Top is
  port(
      clk                 : in    std_logic;
      Gated_clk_from_PEC  : in    std_logic;
      Reset               : in    std_logic;
      
      --PCIe side
      PCIe_data           : in    std_logic_vector(255 downto 0); -- pcie data is 32 byte
      Noc_data            : out   std_logic_vector(255 downto 0);
      PCIe_address        : out   std_logic_vector(31 downto 0); --Q 32 in command decoder 24 in PBdoc?                        
      PCIe_length         : out   std_logic_vector(4 downto 0); 
      PCIe_ready          : in    std_logic; --state machine
      CMD_flag            : in    std_logic; --command decoder
      Noc_CMD_flag        : out   std_logic;
      R_W_PCIe            : out   std_logic;        
      En_PCIe_ctrl        : out   std_logic; 
      En_PCIe_Data        : out   std_logic;    
      PCIe_req            : out   std_logic;               
      PCIe_ack            : in    std_logic; --state machine
      
      --CC side     
      PEC_ready           : in    std_logic; --state machine                                     
      NOC_bus_In          : in    std_logic_vector(15 downto 0);
      NOC_bus_Out         : out   std_logic_vector(15 downto 0);  --switch output
      NOC_bus_dir         : out   std_logic;      
      Tag_Line            : out   std_logic;
              
      --Test
      h2c_cmd_t           : in    std_logic;
      c2h_cmd_t           : in    std_logic;
      pcie_wr_data_wrs_t  : in    std_logic;
      pcie_wr_ctl_wrs_t   : in    std_logic
  );
  end component;

 component Cluster_top is
   Port( 
	  CLK_P     : in std_logic;
	  CLK_E     : in std_logic;
      RST_P     : in std_logic;
      RST_E     : in std_logic;
	  clk_O     : out std_logic;
	  TAG       : in std_logic;
	  TAG_FB    : out std_logic;
      C_RDY     : out std_logic;
      DATA      : in std_logic_vector(7 downto 0);
      DATA_OUT  : out std_logic_vector(7 downto 0);
      noc_cmd_t : out std_logic_vector(4 downto 0);
	  rd_trig_t : out std_logic
  );
end component;
    
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component ila_6

port (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
	probe3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
	probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe8 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	probe9 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
);
end component;


signal REF_CLK_i                         : std_logic;
signal CLK_L_i                           : std_logic; 
signal PCIE_REQ_IF_CLK_O_i               : std_logic;                          
signal PCIE_REQ_IF_RST_O_i               : std_logic;    
signal PCIE_RSP_IF_CLK_I_i               : std_logic;  --250 MHz,    
signal PCIE_RSP_IF_RST_I_i               : std_logic;                          
signal PCIE_WR_REQ_CTRL_WRS_i            : std_logic;                                              
signal PCIE_WR_REQ_CTRL_LENGTH_i         : std_logic_vector (4 downto 0);      
signal PCIE_WR_REQ_CTRL_START_ADDR_i     : std_logic_vector (57 downto 0);                                                                   
signal PCIE_WR_REQ_CTRL_AFU_i            : std_logic;                          
signal PCIE_WR_REQ_DATA_WRS_i            : std_logic;                          
signal PCIE_WR_REQ_DATA_i                : std_logic_vector (255 downto 0);    
signal PCIE_WR_REQ_DATA_AFU_i            : std_logic;                          
signal PCIE_RD_REQ_WRS_i                 : std_logic;                          
signal PCIE_RD_REQ_START_ADDR_i          : std_logic_vector (57 downto 0);     
signal PCIE_RD_REQ_LENGTH_i              : std_logic_vector (4 downto 0);      
signal PCIE_RD_REQ_AFU_i                 : std_logic;                          
signal PCIE_RD_RESP_DATA_VLD_i           : std_logic;                          
signal PCIE_RD_RESP_DATA_FIRST_i         : std_logic;                          
signal PCIE_RD_RESP_DATA_LAST_i          : std_logic;                          
signal PCIE_RD_RESP_DATA_i               : std_logic_vector (255 downto 0); 
signal REG1_REF_CLK_i                    : std_logic;                                           
signal REG1_USER_CLK_i                   : std_logic;                                           
signal REG1_USER_RST_i                   : std_logic;                                           
signal REG1_WEA_i                        : std_logic;                                           
signal REG1_WDA_i                        : std_logic_vector(31 downto 0);                       
signal REG1_ADA_i                        : std_logic_vector(15 downto 0);                       
signal REG1_REA_i                        : std_logic;                                           
signal REG1_RDA_i                        : std_logic_vector(31 downto 0);                       
signal REG1_RDAV_i                       : std_logic;                                           
signal REG1_AC_i                         : std_logic; 
signal NOC_DATA_i                        : std_logic_vector(255 downto 0);          
signal PCIE_DATA_i                       : std_logic_vector(255 downto 0);          
signal PCIE_ADDRESS_i                    : std_logic_vector(31 downto 0);          
signal PCIE_LENGTH_i                     : std_logic_vector(4 downto 0);          
signal PCIE_RDY_i                        : std_logic;          
signal CMD_FLAG_i                        : std_logic;--PCIe CMD          
signal NOC_CMD_FLAG_i                    : std_logic;          
signal RW_FLAG_i                         : std_logic;  --0 means "read from P          
signal ENA_PCIE_CTL_i                    : std_logic;          
signal ENA_PCIE_DATA_i                   : std_logic;          
signal PCIE_REQ_i                        : std_logic;          
signal PCIE_ACK_i                        : std_logic;          
signal NOC_RST_i                         : std_logic:= '0';
signal NOC_bus_In                        : std_logic_vector(15 downto 0):= (others => '0');
signal NOC_bus_Out                       : std_logic_vector(15 downto 0);
signal NOC_bus_dir                       : std_logic;
signal PEC_ready                         : std_logic;
signal Tag_Line                          : std_logic;
signal TAG_FB1                           : std_logic;
signal TAG_FB2                           : std_logic;
signal REQ_IN                            : std_logic;
signal REQ_FIFO                          : std_logic_vector(31 downto 0);
signal FOUR_WD_LEFT                      : std_logic;
signal Gated_clk_from_PEC                : std_logic;
signal Reset                             : std_logic;
signal h2c_cmd_t                         : std_logic;
signal c2h_cmd_t                         : std_logic;
signal pcie_wr_data_wrs_t                : std_logic;
signal pcie_wr_ctl_wrs_t                 : std_logic;
    
  ------------------------------------------------------
  -- Old version of dual core CPU with debug access only
  ------------------------------------------------------
--  -----------------------------------------------------------------------------
--  -- Internal signals driven by (i.e. "output" from) each block 
--  -----------------------------------------------------------------------------    
signal hclk_i       : std_logic;  -- 16.7mhz clk
signal pllout       : std_logic;                         
signal msdin_i      : std_logic;                         
signal pd_i         : std_logic_vector(7 downto 0);      
signal pj_i         : std_logic_vector(7 downto 0);      
signal pi_i         : std_logic_vector(7 downto 0);      
signal ph_i         : std_logic_vector(7 downto 0);      
signal pc_i         : std_logic_vector(7 downto 0);      
signal mbypass_i    : std_logic;                         
signal mreset_i     : std_logic;                         
signal mtest_i      : std_logic;                         
signal mwake_i      : std_logic;                         
signal mirq0_i      : std_logic;                         
signal mirq1_i      : std_logic;                         
signal pe_i         : std_logic_vector(7 downto 0);      
signal pf_i         : std_logic_vector(7 downto 0);      
signal pg_i         : std_logic_vector(7 downto 0);      
signal pa_i         : std_logic_vector(7 downto 0);      
signal pb_i         : std_logic_vector(7 downto 0);   
--  signal mpordis_i    : std_logic;                                                

-- PLL
  -- PLL                                           
signal tcko         : std_logic;                         
signal const_0      : std_logic; 

-- Core clock buffers
signal even_c       : std_logic;
signal clk_d        : std_logic;
signal clk_d_pos    : std_logic;
signal clk_da_pos   : std_logic;
signal clk_c_en     : std_logic;
signal clk_s        : std_logic;
signal clk_s_pos    : std_logic;
signal clk_u_pos    : std_logic;
signal clk_i        : std_logic;
signal clk_i_pos    : std_logic;
signal clk_e_pos    : std_logic;
signal clk_e_neg    : std_logic;
signal clk_p        : std_logic;
signal clk_rx       : std_logic;  
signal clk_tx       : std_logic;
signal clk_a_pos    : std_logic;
signal clk_c2a_pos  : std_logic;
signal clk_ea_pos   : std_logic;

-- RTC block
signal rxout         : std_logic;
signal mrxout_o      : std_logic;
signal rtc_data      : std_logic_vector(7 downto 0); 
signal dis_bmem_int  : std_logic;

signal halt_en       : std_logic;   --high active, will go to halt state
signal nap_en        : std_logic;   --high active, will go to nap state
signal wakeup_lp     : std_logic;  -- From wakeup_lp input IO
signal poweron_finish: std_logic;  -- 
signal reset_iso     : std_logic;  -- to isolate the core reset
signal reset_iso_clear: std_logic; --clear reset isolate
signal reset_core_n  : std_logic;  -- to reset core, low active
signal io_iso        : std_logic;  -- to isolate the io signals in nap mode
signal nap_rec       : std_logic;  -- will recover from nap mode
signal pmic_core_en  : std_logic;  
signal pmic_io_en    : std_logic;
signal clk_mux_out   : std_logic;
signal lp_pwr_ok     : std_logic;

-----------------------------------------------------------------------------
-- core/peri driven signals
-----------------------------------------------------------------------------
-- Signals to other blocks
signal pll_frange   : std_logic;
signal pll_n        : std_logic_vector(5 downto 0);
signal pll_m        : std_logic_vector(2 downto 0);
signal en_xosc      : std_logic;
signal en_pll       : std_logic;
signal sel_pll      : std_logic;
signal xout_selected : std_logic;
signal test_pll     : std_logic;
signal pll_pdn      : std_logic;       --added by HYX,20141115
signal erxclk       : std_logic;
signal etxclk       : std_logic;
signal rst_n        : std_logic;    
signal rst_cn       : std_logic;    
signal en_d         : std_logic;    
signal fast_d       : std_logic;    
--signal din_e        : std_logic;
signal din_ea       : std_logic;    
signal din_i        : std_logic;    
signal din_u        : std_logic;    
signal din_s        : std_logic;    
signal din_a        : std_logic;
--add the following two signals by maning
signal clk_in_off   : std_logic;
signal clk_main_off : std_logic;  
signal sdram_en		: std_logic; 
signal out_line     : std_logic;
signal hold_flash   : std_logic;   
signal hold_flash_d : std_logic;                  
signal flash_en     : std_logic;                    
signal flash_mode   : std_logic_vector (3 downto 0);
signal ld_dqi_flash : std_logic; 
signal router_ido   : std_logic_vector(7 downto 0);
signal core_idi     : std_logic_vector(7 downto 0);
signal bmem_a8      : std_logic;    
signal bmem_d       : std_logic_vector(7 downto 0);      
signal bmem_ce_n    : std_logic;   
signal bmem_we_n    : std_logic; 
--  signal ram_partition : std_logic_vector(3 downto 0); 
signal rst_rtc      : std_logic; 
signal en_fclk      : std_logic; 
signal fclk         : std_logic;
signal ld_bmem      : std_logic;
signal rtc_sel      : std_logic_vector(2 downto 0);
signal ach_sel      : std_logic_vector(2 downto 0);
signal adc_bits_int : std_logic; -- added by HYX, 20141205
signal dac_bits     : std_logic_vector(0 to 1);
signal dac_en       : std_logic_vector(0 to 1);
signal en_tstamp    : std_logic_vector(1 downto 0);
signal tiu_tstamp   : std_logic;
signal tstamp       : std_logic_vector(2 downto 0);
signal mpll_tsto_o  : std_logic;                         
signal adc_dac      : std_logic;  
--signals to core2
signal  c2_core2_en : std_logic;  -- core2 enable
signal  c2_rsc_n    : std_logic;
signal  c2_clkreq_gen : std_logic;
--signal  c2_even_c     : std_logic;
signal  c2_crb_out  : std_logic_vector(7 downto 0);
signal  c2_crb_sel  : std_logic_vector(3 downto 0);  
signal  c2_en_pmem  : std_logic;
signal  c2_en_wdog  : std_logic;
signal  c2_pup_clk  : std_logic;
signal  c2_pup_irq  : std_logic_vector(1 downto 0);
signal  c2_r_size   : std_logic_vector(1 downto 0);
signal  c2_c_size   : std_logic_vector(1 downto 0);
signal  c2_t_ras    : std_logic_vector(2 downto 0);
signal  c2_t_rcd    : std_logic_vector(1 downto 0);
signal  c2_t_rp     : std_logic_vector(1 downto 0);
--  signal  c2_en_mexec   : std_logic;
-- to memories signals
signal c1_mprom_a       : std_logic_vector(13 downto 0); 
signal c1_mprom_ce      : std_logic_vector(1 downto 0);  
signal c1_mprom_oe      : std_logic_vector(1 downto 0);
signal c1_mpram_a       : std_logic_vector(13 downto 0); 
signal c1_mpram_d       : std_logic_vector(79 downto 0);   
signal c1_mpram_ce      : std_logic_vector(1 downto 0);    
signal c1_mpram_oe      : std_logic_vector(1 downto 0);    
signal c1_mpram_we_n    : std_logic;                       
signal c1_gmem_a        : std_logic_vector(9 downto 0);    
signal c1_gmem_d        : std_logic_vector(7 downto 0);    
signal c1_gmem_ce_n     : std_logic;                      
signal c1_gmem_we_n     : std_logic;                       
signal iomem_a       : std_logic_vector(9 downto 0);    
signal iomem_d       : std_logic_vector(15 downto 0);   
signal iomem_ce_n    : std_logic_vector(1 downto 0);  
signal iomem_we_n    : std_logic;                      
signal trcmem_a      : std_logic_vector(7 downto 0);    
signal trcmem_d      : std_logic_vector(31 downto 0);   
signal trcmem_ce_n   : std_logic;                       
signal trcmem_we_n   : std_logic;                                            
signal c1_pmem_a        : std_logic_vector(10 downto 0);   
signal c1_pmem_d        : std_logic_vector(1 downto 0);   
signal c1_pmem_ce_n     : std_logic;                      
signal c1_pmem_we_n     : std_logic;  
signal en_pmem2	   : std_logic;
signal short_cycle   : std_logic;
-- to PADS
signal mirqout_o     : std_logic;                       
signal mckout1_o     : std_logic;   
signal mckout1_o_en  : std_logic;                    
signal msdout_o      : std_logic;                       
signal mrstout_o     : std_logic;                       
signal mexec_o       : std_logic;                       
signal mxout_o       : std_logic;                       
signal ddq_en        : std_logic;                       
signal da_o          : std_logic_vector(13 downto 0);   
signal dba_o         : std_logic_vector(1 downto 0);    
signal dcke_o        : std_logic_vector(3 downto 0);    
signal pa_en         : std_logic_vector(7 downto 0);    
signal pa_o          : std_logic_vector(7 downto 0);    
signal pb_en         : std_logic_vector(7 downto 0);    
signal pb_o          : std_logic_vector(7 downto 0);    
signal pc_en         : std_logic_vector(7 downto 0);    
signal pc_o          : std_logic_vector(7 downto 0);    
signal pd_en         : std_logic_vector(7 downto 0);    
signal pd_o          : std_logic_vector(7 downto 0);    
signal pe_en         : std_logic_vector(7 downto 0);    
signal pe_o          : std_logic_vector(7 downto 0);    
signal pf_en         : std_logic_vector(7 downto 0);    
signal pf_o          : std_logic_vector(7 downto 0);    
signal pg_en         : std_logic_vector(7 downto 0);    
signal pg_o          : std_logic_vector(7 downto 0);    
signal ph_en         : std_logic_vector(7 downto 0);    
signal ph_o          : std_logic_vector(7 downto 0);    
signal pi_en         : std_logic_vector(7 downto 0);    
signal pi_o          : std_logic_vector(7 downto 0);    
signal pj_en         : std_logic_vector(7 downto 0);    
signal pj_o          : std_logic_vector(7 downto 0);

signal d_hi          : std_logic;                       
signal d_sr          : std_logic;                       
signal d_lo          : std_logic;                       
signal p1_hi         : std_logic;                       
signal p1_sr         : std_logic;     
signal p2_hi         : std_logic;                       
signal p2_sr         : std_logic; 
signal p3_hi         : std_logic;                       
signal p3_sr         : std_logic;                                      

-----------------------------------------------------------------------------
-- signals between core and peri
-----------------------------------------------------------------------------
-- core driven
signal dbus        : std_logic_vector(7 downto 0);  
signal rst_en      : std_logic;
--signal rst_en2     : std_logic;
signal pd_s          : std_logic_vector(2 downto 0);
signal aaddr       : std_logic_vector(4 downto 0);
signal idack       : std_logic_vector(7 downto 0);
signal ios_iden    : std_logic;                   
signal ios_ido     : std_logic_vector(7 downto 0);                  
signal ilioa       : std_logic;                   
signal ildout      : std_logic;                   
signal inext       : std_logic;
signal iden        : std_logic;                         
signal dqm_size    : std_logic_vector(1 downto 0);
signal en_uart1    : std_logic;
signal en_uart2    : std_logic;
signal en_uart3    : std_logic;
signal en_eth      : std_logic_vector(1 downto 0);
signal en_iobus    : std_logic_vector(1 downto 0);
signal ddqm        : std_logic_vector(7 downto 0);
signal en_tiu      : std_logic;
signal run_tiu     : std_logic;
-- Peri driven
signal dfp         : std_logic_vector(7 downto 0);
signal idreq       : std_logic_vector(7 downto 0);
signal idi         : std_logic_vector(7 downto 0);
signal irq0        : std_logic;                         
signal irq1        : std_logic; 
------signal declaration end here------------------
--signal proc_clk    : std_logic;
-----------------------------------------------------------------------------
-- Memory driven signals
-----------------------------------------------------------------------------
-- MPROM0, MPROM1, MPRAM0, MPRAM1
signal c1_mp_q      : std_logic_vector(79 downto 0);
signal c2_mp_q      : std_logic_vector(79 downto 0);  
-- GMEM
signal c1_gmem_q    : std_logic_vector(7 downto 0);
signal c2_gmem_q    : std_logic_vector(7 downto 0);
-- IOMEM0, IOMEM1
signal iomem_q   : std_logic_vector(15 downto 0);

-- TRCMEM
signal trcmem_q  : std_logic_vector(31 downto 0);

-- PMEM (Patch memory)  
signal c1_pmem_q    : std_logic_vector(1  downto 0);
signal c2_pmem_q    : std_logic_vector(1  downto 0);
-- BMEM (battery backed memory)
signal bmem_q    : std_logic_vector(7 downto 0); 

signal rom0_addr_sig : std_logic_vector(11 downto 0); 
-------------------------------------------------------------------------------
---------------dual core related----------------------------------------------------------
-------------------------------------------------------------------------------
signal c1_d_addr   : std_logic_vector(31 downto 0);
signal c1_d_cs     : std_logic;  -- CS to SDRAM
  signal c1_d_ras    : std_logic;  -- RAS to SDRAM
  signal c1_d_cas    : std_logic;  -- CAS to SDRAM
  signal c1_d_we     : std_logic;  -- WE to SDRAM
  signal c1_d_dqi    : std_logic_vector(7 downto 0); -- Data in from processor
  signal c1_d_dqi_sd : std_logic_vector(7 downto 0); -- Data in from sdram
  signal c1_d_dqo    : std_logic_vector(7 downto 0); -- Data out to processor
signal c2_d_addr   : std_logic_vector(31 downto 0);
signal c2_d_cs     : std_logic;  -- CS to SDRAM
  signal c2_d_ras    : std_logic;  -- RAS to SDRAM
  signal c2_d_cas    : std_logic;  -- CAS to SDRAM
  signal c2_d_we     : std_logic;  -- WE to SDRAM
  signal c2_d_dqi    : std_logic_vector(7 downto 0); -- Data in from processor
  signal c2_d_dqo    : std_logic_vector(7 downto 0); -- Data out to processor
  
signal c2_mprom_a       : std_logic_vector(13 downto 0); 
signal c2_mprom_ce      : std_logic_vector(1 downto 0);  
signal c2_mprom_oe      : std_logic_vector(1 downto 0);
signal c2_mpram_a       : std_logic_vector(13 downto 0); 
signal c2_mpram_d       : std_logic_vector(79 downto 0);   
signal c2_mpram_ce      : std_logic_vector(1 downto 0);    
signal c2_mpram_oe      : std_logic_vector(1 downto 0);    
signal c2_mpram_we_n    : std_logic;                       
signal c2_gmem_a        : std_logic_vector(9 downto 0);    
signal c2_gmem_d        : std_logic_vector(7 downto 0);    
signal c2_gmem_ce_n     : std_logic;                       
signal c2_gmem_we_n     : std_logic;                                                                 
signal c2_pmem_a        : std_logic_vector(10 downto 0);   
signal c2_pmem_d        : std_logic_vector(1 downto 0);   
signal c2_pmem_ce_n     : std_logic;                       
signal c2_pmem_we_n     : std_logic; 

signal mp_ROM0_DO     : std_logic_vector (79 downto 0); 
signal mp_ROM0_A      : std_logic_vector (13 downto 0); 
signal mp_ROM0_CS     : std_logic;                      
signal mp_ROM0_OE     : std_logic;                      
signal mp_ROM1_DO     :  std_logic_vector (79 downto 0);
signal mp_ROM1_A      :  std_logic_vector (13 downto 0);
signal mp_ROM1_CS     :  std_logic;                     
signal mp_ROM1_OE     :  std_logic;                     
signal mp_PM_DO       : std_logic_vector (1 downto 0);  
signal mp_PM_DI       : std_logic_vector (1 downto 0);  
signal mp_PM_A        : std_logic_vector (10 downto 0); 
signal mp_PM_WEB      : std_logic;                      
signal mp_PM_CSB      : std_logic;      

signal mp_RAM0_DO     :  std_logic_vector (79 downto 0);
signal mp_RAM0_DI     :  std_logic_vector (79 downto 0);
signal mp_RAM0_A      :  std_logic_vector (13 downto 0);
signal mp_RAM0_WEB    :  std_logic;   
signal mp_RAM0_OE     :  std_logic;
signal mp_RAM0_CS     :  std_logic;                  
                  
signal mp_RAM1_DO     :  std_logic_vector (79 downto 0);
signal mp_RAM1_DI     :  std_logic_vector (79 downto 0);
signal mp_RAM1_A      :  std_logic_vector (13 downto 0);
signal mp_RAM1_WEB    :  std_logic;
signal mp_RAM1_CS     : std_logic;   

signal f_addr_in     : std_logic_vector(16 downto 0);
signal f_rd_in       : std_logic;  -- low active
signal f_wr_in       : std_logic;  -- low active        
signal f_data_in     : std_logic_vector(7 downto 0); -- Data in from processor
signal f_data_out    : std_logic_vector(7 downto 0); -- Data out to processor   
signal f_CE          : std_logic;                      
signal f_ADDR        : std_logic_vector(12 downto 0);  
signal f_WRONLY      : std_logic;                      
signal f_PERASE      : std_logic;                      
signal f_SERASE      : std_logic;                      
signal f_MERASE      : std_logic;                      
signal f_PROG        : std_logic;                      
signal f_INF         : std_logic;                      
signal f_POR         : std_logic;                      
signal f_SAVEN       : std_logic;                      
signal f_TM          : std_logic_vector(3 downto 0);   
signal f_DATA_WR     : std_logic_vector(31 downto 0);  
signal f0_ALE        : std_logic;    
signal f0_DATA_IN    :std_logic_vector(31 downto 0);       
signal f0_RBB        :std_logic;  
signal f1_ALE        : std_logic;    
signal f1_DATA_IN    :std_logic_vector(31 downto 0);       
signal f1_RBB        :std_logic; 
signal f2_ALE        : std_logic;    
signal f2_DATA_IN    :std_logic_vector(31 downto 0);       
signal f2_RBB        :std_logic; 
signal f3_ALE        : std_logic;    
signal f3_DATA_IN    :std_logic_vector(31 downto 0);       
signal f3_RBB        :std_logic; 
--RAM0 
signal RAM0_DO         : std_logic_vector (7 downto 0); -- modify flag, 2015lp
signal RAM0_DI         : std_logic_vector (7 downto 0);
signal RAM0_A          : std_logic_vector (13 downto 0);
signal RAM0_WEB        : std_logic;
signal RAM0_CS         : std_logic;
      --RAM1 
signal RAM1_DO         : std_logic_vector (7 downto 0);
signal RAM1_DI         : std_logic_vector (7 downto 0);
signal RAM1_A          : std_logic_vector (13 downto 0);
signal RAM1_WEB        : std_logic;
signal RAM1_CS         : std_logic;
       --RAM2 
signal RAM2_DO         : std_logic_vector (7 downto 0);
signal RAM2_DI         : std_logic_vector (7 downto 0);
signal RAM2_A          : std_logic_vector (13 downto 0);
signal RAM2_WEB        : std_logic;
signal RAM2_CS         : std_logic;
       --RAM3 
signal RAM3_DO         : std_logic_vector (7 downto 0);
signal RAM3_DI         : std_logic_vector (7 downto 0);
signal RAM3_A          : std_logic_vector (13 downto 0);
signal RAM3_WEB        : std_logic;
signal RAM3_CS         : std_logic;
       --RAM4 
signal RAM4_DO         : std_logic_vector (7 downto 0);
signal RAM4_DI         : std_logic_vector (7 downto 0);
signal RAM4_A          : std_logic_vector (13 downto 0);
signal RAM4_WEB        : std_logic;
signal RAM4_CS         : std_logic;
signal locked          : std_logic;
signal clk_gen         : std_logic;
signal Reset_P1        : std_logic;
signal Reset_P2        : std_logic;
signal Reset_extended  : std_logic;
signal Reset_meta      : std_logic;
signal Reset_cdc       : std_logic;
signal PCIE_reset      : std_logic;
signal Reset_NOC       : std_logic;
signal noc_cmd1_t      : std_logic_vector (4 downto 0);
signal noc_cmd2_t      : std_logic_vector (4 downto 0);
signal rd_trig1_t      : std_logic;
signal rd_trig2_t      : std_logic;

signal	probe0_i       : std_logic_vector(15 downto 0); 
signal	probe1_i       : std_logic_vector(15 downto 0); 
signal	probe2_i       : std_logic_vector(4 downto 0); 
signal	probe3_i       : std_logic_vector(4 downto 0); 
signal	probe4_i       : std_logic_vector(0 downto 0); 
signal	probe5_i       : std_logic_vector(0 downto 0); 
signal	probe6_i       : std_logic_vector(0 downto 0); 
signal	probe7_i       : std_logic_vector(0 downto 0); 
signal	probe8_i       : std_logic_vector(0 downto 0);
signal	probe9_i       : std_logic_vector(0 downto 0);


begin

mmcm_inst : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_gen, --180MHz
   clk_out2 => CLK_P,   --Fast clock 360MHz

  -- Status and control signals                
   reset => Reset,
   locked => locked,
   -- Clock in ports
   clk_in1 => ref_clk
 );
 
--
-- RJ start
--
--  ------------------------------------------------------
--  -- PCIe
--  ------------------------------------------------------
--  pcie_req_if_clk_o <= ref_clk;
--  pcie_req_if_rst_o <= '0';
--  pcie_wr_req_ctrl_wrs <= '0';
--  pcie_wr_req_ctrl_length     <= (others => '0');
--  pcie_wr_req_ctrl_start_addr <= (others => '0');
--  pcie_wr_req_data_wrs        <= '0';
--  pcie_wr_req_data            <= (others => '0');
--  pcie_rd_req_wrs             <= '0';
--  pcie_rd_req_start_addr      <= (others => '0');
--  pcie_rd_req_length          <= (others => '0');
--
--  ------------------------------------------------------
--  -- DDR4
--  ------------------------------------------------------
  ddr4_cell_clk_o           <= ddr4_clk_i;
  ddr4_cell_rst_o           <= '0';
  ddr4_cell_input_start     <= '0';
  ddr4_cell_input_data      <= (others => '0');
  ddr4_input_addr           <= (others => '0');
  ddr4_cell_output_ready    <= '0';
  ddr4_output_addr_vld      <= '0';
  ddr4_output_addr          <= (others => '0');
--
--  ------------------------------------------------------
--  -- Reg1
--  ------------------------------------------------------
  --reg1_user_clk  <= reg1_ref_clk;
--  reg1_user_rst  <= '0';
--  reg1_rda       <= (others => '0');
--  reg1_rdav      <= '0';
--  reg1_ac        <= reg1_wea;
--
--  ------------------------------------------------------
--  -- Reg2
--  ------------------------------------------------------
  reg2_user_clk  <= reg2_ref_clk;
  reg2_user_rst  <= '0';
  reg2_rda       <= (others => '0');
  reg2_rdav      <= '0';
  reg2_ac        <= reg2_wea;
--
--  
  hclk_i <= HCLK;
  --hclk_i <= ref_clk;
  mreset_i <= MRESET;
  MIRQOUT <= mirqout_o;
  MCKOUT0 <= clk_s;
  MCKOUT1 <= mckout1_o; 
  mtest_i <= MTEST;
  mbypass_i <= MBYPASS;
  mirq0_i <= MIRQ0;
  mirq1_i <= MIRQ1;
  -- SW debug                                                               
  msdin_i <= MSDIN;
  MSDOUT <= msdout_o;

  rxout <= clk_s;

  --wakeup_lp <= '1';
  --lp_pwr_ok <= '1';
  --pmic_core_en <= '1';
  --pmic_io_en <= '1';
  --io_iso <= '1';

  pllout <= HCLK;
  --pllout <= ref_clk;
-- RJ end
-- CJ
  REF_CLK_i <=  clk_gen; --ref_clk;

process(ref_clk_i)
variable eight_loop : integer:=0 ;
begin
    if rising_edge(ref_clk_i) then
        if eight_loop <8 then
            clk_l_i <= '1';
        elsif eight_loop <16 then
            clk_l_i <= '0';
        end if;
        if eight_loop = 15 then
          eight_loop := 0;
        end if;
        eight_loop := eight_loop +1;
    end if;
end process;

  PCIE_REQ_IF_CLK_O            <= PCIE_REQ_IF_CLK_O_i;           
  PCIE_REQ_IF_RST_O            <= PCIE_REQ_IF_RST_O_i;           
  PCIE_RSP_IF_CLK_I_i          <= PCIE_RSP_IF_CLK_I ;           
  PCIE_RSP_IF_RST_I_i          <= PCIE_RSP_IF_RST_I;           
  PCIE_WR_REQ_CTRL_WRS         <= PCIE_WR_REQ_CTRL_WRS_i;        
                                                     
  PCIE_WR_REQ_CTRL_LENGTH      <= PCIE_WR_REQ_CTRL_LENGTH_i;     
  PCIE_WR_REQ_CTRL_START_ADDR  <= PCIE_WR_REQ_CTRL_START_ADDR_i; 
                                                              
  PCIE_WR_REQ_CTRL_AFU_i       <= PCIE_WR_REQ_CTRL_AFU;        
  PCIE_WR_REQ_DATA_WRS         <= PCIE_WR_REQ_DATA_WRS_i;        
  PCIE_WR_REQ_DATA             <= PCIE_WR_REQ_DATA_i;            
  PCIE_WR_REQ_DATA_AFU_i       <= PCIE_WR_REQ_DATA_AFU;        
  PCIE_RD_REQ_WRS              <= PCIE_RD_REQ_WRS_i;             
  PCIE_RD_REQ_START_ADDR       <= PCIE_RD_REQ_START_ADDR_i;      
  PCIE_RD_REQ_LENGTH           <= PCIE_RD_REQ_LENGTH_i;          
  PCIE_RD_REQ_AFU_i            <= PCIE_RD_REQ_AFU;             
  PCIE_RD_RESP_DATA_VLD_i      <= PCIE_RD_RESP_DATA_VLD;       
  PCIE_RD_RESP_DATA_FIRST_i    <= PCIE_RD_RESP_DATA_FIRST;     
  PCIE_RD_RESP_DATA_LAST_i     <= PCIE_RD_RESP_DATA_LAST;      
  PCIE_RD_RESP_DATA_i          <= PCIE_RD_RESP_DATA;           
  REG1_REF_CLK_i               <= reg1_ref_clk;                
  reg1_user_clk                <= REG1_USER_CLK_i;               
  reg1_user_rst                <= REG1_USER_RST_i;               
  reg1_wea_i                   <= REG1_WEA;                    
  reg1_wda_i                   <= REG1_WDA;                    
  reg1_ada_i                   <= REG1_ADA;                    
  reg1_rea_i                   <= REG1_REA;                    
  reg1_rda                     <= REG1_RDA_i;                    
  reg1_rdav                    <= REG1_RDAV_i;                   
  reg1_ac                      <= REG1_AC_i;     
  
adapter: pcie_a
port map(
    REF_CLK                         => REF_CLK_i,                                    
    PCIE_REQ_IF_CLK_O               => PCIE_REQ_IF_CLK_O_i,                                              
    PCIE_REQ_IF_RST_O               => PCIE_REQ_IF_RST_O_i,                                              
    PCIE_RSP_IF_CLK_I               => PCIE_RSP_IF_CLK_I_i,                                              
    PCIE_RSP_IF_RST_I               => PCIE_RSP_IF_RST_I_i,                                              
    PCIE_WR_REQ_CTRL_WRS            => PCIE_WR_REQ_CTRL_WRS_i,                                                                                            
    PCIE_WR_REQ_CTRL_LENGTH         => PCIE_WR_REQ_CTRL_LENGTH_i,                                        
    PCIE_WR_REQ_CTRL_START_ADDR     => PCIE_WR_REQ_CTRL_START_ADDR_i,                                                                                                
    PCIE_WR_REQ_CTRL_AFU            => PCIE_WR_REQ_CTRL_AFU_i,                                           
    PCIE_WR_REQ_DATA_WRS            => PCIE_WR_REQ_DATA_WRS_i,                                           
    PCIE_WR_REQ_DATA                => PCIE_WR_REQ_DATA_i,                                               
    PCIE_WR_REQ_DATA_AFU            => PCIE_WR_REQ_DATA_AFU_i,                                           
    PCIE_RD_REQ_WRS                 => PCIE_RD_REQ_WRS_i,                                                
    PCIE_RD_REQ_START_ADDR          => PCIE_RD_REQ_START_ADDR_i,                                         
    PCIE_RD_REQ_LENGTH              => PCIE_RD_REQ_LENGTH_i,                                             
    PCIE_RD_REQ_AFU                 => PCIE_RD_REQ_AFU_i,                                                
    PCIE_RD_RESP_DATA_VLD           => PCIE_RD_RESP_DATA_VLD_i,                                          
    PCIE_RD_RESP_DATA_FIRST         => PCIE_RD_RESP_DATA_FIRST_i,                                        
    PCIE_RD_RESP_DATA_LAST          => PCIE_RD_RESP_DATA_LAST_i,                                         
    PCIE_RD_RESP_DATA               => PCIE_RD_RESP_DATA_i,                                              
    REG1_REF_CLK                    => REG1_REF_CLK_i,                                      
    REG1_USER_CLK                   => REG1_USER_CLK_i,                                     
    REG1_USER_RST                   => REG1_USER_RST_i,                                     
    REG1_WEA                        => REG1_WEA_i,                                          
    REG1_WDA                        => REG1_WDA_i,                                          
    REG1_ADA                        => REG1_ADA_i,                                          
    REG1_REA                        => REG1_REA_i,                                          
    REG1_RDA                        => REG1_RDA_i,                                          
    REG1_RDAV                       => REG1_RDAV_i,                                         
    REG1_AC                         => REG1_AC_i,                                           
    NOC_DATA                        => NOC_DATA_i,                                         
    PCIE_DATA                       => PCIE_DATA_i,                                        
    PCIE_ADDRESS                    => PCIE_ADDRESS_i,                                     
    PCIE_LENGTH                     => PCIE_LENGTH_i,                                      
    PCIE_RDY                        => PCIE_RDY_i,                                         
    CMD_FLAG                        => CMD_FLAG_i,                                         
    NOC_CMD_FLAG                    => NOC_CMD_FLAG_i,                                     
    RW_FLAG                         => RW_FLAG_i,                                          
    ENA_PCIE_CTL                    => ENA_PCIE_CTL_i,                                     
    ENA_PCIE_DATA                   => ENA_PCIE_DATA_i,                                    
    PCIE_REQ                        => PCIE_REQ_i,                                         
    PCIE_ACK                        => PCIE_ACK_i,                                         
    NOC_RST                         => NOC_RST_i,
    reset_out                       => PCIE_reset,
    --test
    h2c_cmd_t                       => h2c_cmd_t,
    c2h_cmd_t                       => c2h_cmd_t,          
    pcie_wr_data_wrs_t              => pcie_wr_data_wrs_t,        
    pcie_wr_ctl_wrs_t               => pcie_wr_ctl_wrs_t        
); 

PEC_ready               <= '0'; --not(TAG_FB1 or TAG_FB2);
Reset                   <= not(MRESET);

--process(ref_clk)
--begin
--if rising_edge(ref_clk) then
--    Reset_P1    <= Reset;
--    Reset_P2    <= Reset_P1;
--end if;
--end process;

--Reset_extended  <= Reset or Reset_P1 or Reset_P2;

--process(REF_CLK_i)
--begin
--    if rising_edge(REF_CLK_i) then
--        Reset_meta     <= Reset_extended;
--        Reset_cdc      <= Reset_meta;
--    end if;
--end process;  

Reset_NOC   <= PCIE_reset;  --Reset_cdc or PCIE_reset;

Noc_Top_Inst: Noc_Top
port map(
        clk                 => REF_CLK_i,  
        Gated_clk_from_PEC  => Gated_clk_from_PEC,
        Reset               => Reset_NOC, --Reset_cdc,
     --PCIe side    
        PCIe_data           => NOC_DATA_i,
        Noc_data            => PCIE_DATA_i,
        PCIe_address        => PCIE_ADDRESS_i,
        PCIe_length         => PCIE_LENGTH_i,
        PCIe_ready          => PCIE_RDY_i,
        CMD_flag            => CMD_FLAG_i,
        Noc_CMD_flag        => NOC_CMD_FLAG_i,
        R_W_PCIe            => RW_FLAG_i,
        En_PCIe_ctrl        => ENA_PCIE_CTL_i,
        En_PCIe_Data        => ENA_PCIE_DATA_i,            
        PCIe_req            => PCIE_REQ_i,
        PCIe_ack            => PCIE_ACK_i,
    --CC side     
        PEC_ready           => PEC_ready,
        NOC_bus_In          => NOC_bus_In,
        NOC_bus_Out         => NOC_bus_Out,
        NOC_bus_dir         => NOC_bus_dir,  
        Tag_Line            => Tag_Line,   
        --Test
        h2c_cmd_t           => h2c_cmd_t,
        c2h_cmd_t           => c2h_cmd_t,
        pcie_wr_data_wrs_t  => pcie_wr_data_wrs_t,
        pcie_wr_ctl_wrs_t   => pcie_wr_ctl_wrs_t
);
     
Cluster_top_Inst1: Cluster_top
port map(
        CLK_P               => CLK_P,
        CLK_E               => REF_CLK_i,
        clk_O               => Gated_clk_from_PEC,      --Clock outputs   
        RST_P               => '0',
        RST_E               => '0',
        TAG                 => Tag_Line,                --Tag line
        TAG_FB              => TAG_FB1,
        C_RDY               => open,
        DATA                => NOC_bus_Out(7 downto 0), --Data line
        DATA_OUT            => NOC_bus_In(7 downto 0),
        noc_cmd_t           => noc_cmd1_t, 
	    rd_trig_t           => rd_trig1_t           
);
  
Cluster_top_Inst2: Cluster_top
port map(
        CLK_P               => CLK_P,
        CLK_E               => REF_CLK_i,
        clk_O               => open,      --Clock outputs   
        RST_P               => '0',
        RST_E               => '0',
        TAG                 => Tag_Line,                --Tag line
        TAG_FB              => TAG_FB2,
        C_RDY               => open,
        DATA                => NOC_bus_Out(15 downto 8), --Data line
        DATA_OUT            => NOC_bus_In(15 downto 8),
        noc_cmd_t           => noc_cmd2_t, 
	    rd_trig_t           => rd_trig2_t                    
);

    probe0_i(15 downto 0) <= NOC_bus_In;
    probe1_i(15 downto 0) <= NOC_bus_Out;
    probe2_i(4 downto 0)  <= noc_cmd1_t;
    probe3_i(4 downto 0)  <= noc_cmd2_t;
    probe4_i(0)           <= rd_trig1_t;
    probe5_i(0)           <= rd_trig2_t;
    probe6_i(0)           <= Tag_Line;
    probe7_i(0)           <= TAG_FB1;
    probe8_i(0)           <= TAG_FB2;
    probe9_i(0)           <= Tag_Line; 


Ila_Imsys : ila_6
port map
(
	clk => REF_CLK_i,
	probe0 => probe0_i, 
	probe1 => probe1_i, 
	probe2 => probe2_i, 
	probe3 => probe3_i, 
	probe4 => probe4_i, 
	probe5 => probe5_i, 
	probe6 => probe6_i, 
	probe7 => probe7_i, 
	probe8 => probe8_i,
	probe9 => probe9_i
);
   

end struct;