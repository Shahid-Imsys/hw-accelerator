----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/05/2021 02:14:45 PM
-- Design Name: 
-- Module Name: Cluster_top - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.cluster_pkg.all;
use work.noc_types_pkg.all;

entity PEC_top is
  generic(
    USE_ASIC_MEMORIES      : boolean := true;
    PEC_NUMBER             : integer := 2
  );  
  port (
    CLK_P    : in  std_logic;
    CLK_E    : in  std_logic;
    RST_E    : in  std_logic;
    DDO_VLD  : out std_logic;
    TAG      : in  std_logic;
    TAG_FB   : out std_logic;
    C_RDY    : out std_logic;
    DATA_True_Broadcast : in noc_data_t(15 downto 0);
    DATA     : in  std_logic_vector(7 downto 0);
    DATA_OUT : out std_logic_vector(7 downto 0)
    );
end PEC_top;

architecture struct of PEC_top is

  component cluster_controller
    generic(
      USE_ASIC_MEMORIES   : boolean := false;
      PEC_NUMBER          : integer := 2;
      --single_pe_sim       : boolean := false;
      TAG_CMD_DECODE_TIME : integer := 38     --Number of clock cycles for peci_busy to deassert
    );
    port(
--Clock inputs
      CLK_P        : in  std_logic;     --PE clocks
      CLK_E        : in  std_logic;     --PE's execution clock
--Asychronized resets
      RST_E        : in  std_logic;
--Clock outputs
      DDO_VLD      : out std_logic;
      EVEN_P       : out std_logic;
--Tag line
      TAG          : in  std_logic;
      TAG_FB       : out std_logic;
--Data line
      DATA_True_Broadcast : in noc_data_t(15 downto 0);
      DATA         : in  std_logic_vector(7 downto 0);
      DATA_OUT     : out std_logic_vector(7 downto 0);
      EXE          : out std_logic;     --Start execution
      RESUME       : out std_logic;     --Resume paused execution
--Feedback signals
      C_RDY        : out std_logic;
      PES_RDY      : in  std_logic_vector(15 downto 0);
--PE request
      RST_R        : out std_logic;     --Active low
      REQ_IN       : in  std_logic;     --req to noc in reg logic
      REQ_FIFO     : in  std_logic_vector(31 downto 0);
      DATA_FROM_PE : in  std_logic_vector(127 downto 0);
      DATA_TO_PE   : out std_logic_vector(127 downto 0);
      DATA_VLD     : out std_logic;
      PE_UNIT      : out std_logic_vector(5 downto 0);
      BC           : out std_logic;
      RD_FIFO      : out std_logic;
      FIFO_VLD     : in  std_logic
      );
  end component;


  component req_dst_logic
    generic (USE_ASIC_MEMORIES : boolean := true);
    port(
      --Shared
      CLK_P        : in  std_logic;
      CLK_E        : in  std_logic;     --Generated by PE pair 1 
      EVEN_P       : in  std_logic;
      RESET        : in  std_logic;
      --Requet logic
      REQ_TO_NOC   : out std_logic;
      REQ_SIG      : in  std_logic_vector(15 downto 0);
      REQ_RD_IN    : in  std_logic_vector(15 downto 0);
      ACK_SIG      : out std_logic_vector(15 downto 0);
      PE_REQ_IN    : in  pe_req;        -- pe_req(0) is the last PE (PE 64)
      CMD_OUTPUT   : out std_logic_vector(31 downto 0);
      DATA_OUTPUT  : out std_logic_vector(127 downto 0);
      RD_FIFO      : in  std_logic;
      FIFO_VLD     : out std_logic;
      --Distribution network
      DATA_VLD     : in  std_logic;
      DATA_NOC     : in  std_logic_vector(127 downto 0);
      PE_UNIT      : in  std_logic_vector(3 downto 0);
      B_CAST       : in  std_logic;
      DATA_VLD_OUT : out std_logic_vector(15 downto 0);
      PE_DATA_OUT  : out pe_data

      );
  end component;

  component PE_pair_top
    generic (USE_ASIC_MEMORIES : boolean := true);
    port(
      HCLK       : in  std_logic;  -- clk input, use this or an internally generated clock for CPU core
      EVEN_C     : in  std_logic;
      MRESET     : in  std_logic;  -- system reset               low active
      MIRQOUT    : out std_logic;       -- interrupt request output    
      MCKOUT1    : out std_logic;       -- programable clock out              
      MBYPASS    : in  std_logic;
      -- SW debug                                                               
      MSDIN      : in  std_logic;       -- serial data in (debug)     
      MSDOUT     : out std_logic;       -- serial data out  
      -- Cluster interface
      C1_REQ     : out std_logic;
      C1_REQ_RD  : out std_logic;
      C2_REQ     : out std_logic;
      C2_REQ_RD  : out std_logic;
      C1_ACK     : in  std_logic;
      C2_ACK     : in  std_logic;
      C1_REQ_D   : out std_logic_vector(159 downto 0);
      C2_REQ_D   : out std_logic_vector(159 downto 0);
      C1_IN_D    : in  std_logic_vector(127 downto 0);
      C2_IN_D    : in  std_logic_vector(127 downto 0);
      C1_DDI_VLD : in  std_logic;
      C2_DDI_VLD : in  std_logic;
      C1_RDY     : out std_logic;
      C2_RDY     : out std_logic;
      EXE        : in  std_logic;
      RESUME     : in  std_logic;
      C1_ID      : in  std_logic_vector(5 downto 0);
      C2_ID      : in  std_logic_vector(5 downto 0);
      MLP_PWR_OK : in  std_logic;  -- Power on indecator --From Host directly
      MWAKEUP_LP : in  std_logic
      );
  end component;

  signal even_p_i       : std_logic;
  signal ddo_vld_i      : std_logic;
  signal tag_out_i      : std_logic;
  signal data_out_i     : std_logic_vector(7 downto 0);
  signal rst_i          : std_logic;
  signal req_in_i       : std_logic;
  signal req_fifo_i     : std_logic_vector(31 downto 0);
  signal data_fifo_i    : std_logic_vector(127 downto 0);
  signal data_to_pe_i   : std_logic_vector(127 downto 0);
  signal data_vld_i     : std_logic;
  signal data_vld_to_pe : std_logic_vector(15 downto 0);
  signal pe_unit_i      : std_logic_vector(5 downto 0);
  signal bc_i           : std_logic;
  signal rd_fifo_i      : std_logic;
  signal fifo_vld_i     : std_logic;
  signal req_sig_i      : std_logic_vector(15 downto 0);
  signal req_rd_i       : std_logic_vector(15 downto 0);
  signal ack_sig_i      : std_logic_vector(15 downto 0);
  signal pe_rdy_reg     : std_logic_vector(15 downto 0);
  signal pe_req_in_i    : pe_req;
  signal pe_data_out_i  : pe_data;
  signal exe            : std_logic;
  signal resume         : std_logic;

  attribute mark_debug : string;
  attribute mark_debug of exe: signal is "true"; 
  attribute mark_debug of data_to_pe_i: signal is "true";   


begin

  DDO_VLD  <= ddo_vld_i;
  TAG_FB   <= tag_out_i;
  DATA_OUT <= data_out_i;
  ------------------END----------------------------

  cc : cluster_controller
    generic map (
      USE_ASIC_MEMORIES => USE_ASIC_MEMORIES,
      PEC_NUMBER        => PEC_NUMBER
--    single_pe_sim       => -- no flow of generics, use defaults
--    TAG_CMD_DECODE_TIME => -- no flow of generics, use defaults
    )
    port map(
      CLK_P        => clk_p,
      CLK_E        => clk_e,
      --CLK_E_NEG => clk_e_neg_i,
      DDO_VLD      => ddo_vld_i,
      EVEN_P       => even_p_i,
      RST_E        => rst_e,
      --RST_P  => rst_p,
      TAG          => tag,
      TAG_FB       => tag_out_i,
      DATA_True_Broadcast   => DATA_True_Broadcast,
      DATA         => DATA,
      DATA_OUT     => data_out_i,
      exe          => exe,
      resume       => resume,
      C_RDY        => C_RDY,
      PES_RDY      => pe_rdy_reg,    --'0',--temp     
      RST_R        => rst_i,
      REQ_IN       => req_in_i,
      REQ_FIFO     => req_fifo_i,
      DATA_FROM_PE => data_fifo_i,
      DATA_TO_PE   => data_to_pe_i,
      DATA_VLD     => data_vld_i,
      PE_UNIT      => pe_unit_i,
      BC           => bc_i,
      RD_FIFO      => rd_fifo_i,
      FIFO_VLD     => fifo_vld_i
      );

  cluster_net : req_dst_logic
    generic map (USE_ASIC_MEMORIES => USE_ASIC_MEMORIES)
    port map(
      CLK_P        => clk_p,
      CLK_E        => clk_e,
      EVEN_P       => even_p_i,
      RESET        => rst_i,
      REQ_TO_NOC   => req_in_i,
      REQ_SIG      => req_sig_i,
      REQ_RD_IN    => req_rd_i,
      ACK_SIG      => ack_sig_i,
      PE_REQ_IN    => pe_req_in_i,
      CMD_OUTPUT   => req_fifo_i,
      DATA_OUTPUT  => data_fifo_i,
      RD_FIFO      => rd_fifo_i,
      FIFO_VLD     => fifo_vld_i,
      DATA_VLD     => data_vld_i,
      DATA_NOC     => data_to_pe_i,
      PE_UNIT      => pe_unit_i(3 downto 0),
      B_CAST       => bc_i,
      DATA_VLD_OUT => data_vld_to_pe,
      PE_DATA_OUT  => pe_data_out_i
      );

  gen_pe_pairs : for i in 0 to 7 generate
    pe_pair : PE_pair_top
      generic map(
        USE_ASIC_MEMORIES => USE_ASIC_MEMORIES)
      port map(
        C1_REQ     => req_sig_i(15 - 2*i),
        C1_REQ_RD  => req_rd_i(15 - 2*i),
        C2_REQ     => req_sig_i(14 - 2*i),
        C2_REQ_RD  => req_rd_i(14 - 2*i),
        C1_ACK     => ack_sig_i(0 + 2*i),
        C2_ACK     => ack_sig_i(1 + 2*i),
        C1_REQ_D   => pe_req_in_i(0 + 2*i),
        C2_REQ_D   => pe_req_in_i(1 + 2*i),
        C1_IN_D    => pe_data_out_i(0 + 2*i),
        C2_IN_D    => pe_data_out_i(1 + 2*i),
        C1_DDI_VLD => data_vld_to_pe(0 + 2*i),
        C2_DDI_VLD => data_vld_to_pe(1 + 2*i),
        C1_RDY     => pe_rdy_reg(15 - 2*i),
        C2_RDY     => pe_rdy_reg(14 - 2*i),
        EXE        => exe,
        RESUME     => resume,
        C1_ID      => std_logic_vector(to_unsigned(2*i + 0, 6)),
        C2_ID      => std_logic_vector(to_unsigned(2*i + 1, 6)),
        HCLK       => clk_p,
        EVEN_C     => even_p_i,
        MRESET     => rst_i,
        MIRQOUT    => open,
        MCKOUT1    => open,
        MBYPASS    => '0',
        -- SW debug=>                                             
        MSDIN      => '0',
        MSDOUT     => open,
        MLP_PWR_OK => '1',
        MWAKEUP_LP => '0'
        );
  end generate;

end struct;
