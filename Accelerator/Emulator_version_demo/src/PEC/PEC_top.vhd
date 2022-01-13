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
use IEEE.STD_LOGIC_1164.ALL;
use work.cluster_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PEC_top is
  Port ( 
	  CLK_P : in std_logic;
	  CLK_E  : in std_logic;
    --  RST_P  : in std_logic;
      RST_E  : in std_logic;
	  clk_O  : out std_logic;
	  TAG    : in std_logic;
	  TAG_FB : out std_logic;
      C_RDY  : out std_logic;
      DATA   : in std_logic_vector(7 downto 0);
      DATA_OUT  : out std_logic_vector(7 downto 0)
  );
end PEC_top;

architecture struct of PEC_top is

component cluster_controller
port(
--Clock inputs
	  CLK_P            : in std_logic;     --PE clocks
	  CLK_E            : in std_logic;     --PE's execution clock
--Asychronized resets
      --RST_P            : in std_logic;
      RST_E            : in std_logic; 
--Clock outputs
	  CLK_O            : out std_logic;
      EVEN_P           : out std_logic;
--Tag line
	  TAG              : in std_logic;
	  TAG_FB           : out std_logic;
--Data line   
	  DATA             : in std_logic_vector(7 downto 0);
	  DATA_OUT         : out std_logic_vector(7 downto 0);


	  EXE              : out std_logic;   --Start execution
	  RESUME           : out std_logic;   --Resume paused execution
--Feedback signals
      C_RDY               : out std_logic;
	  PE_RDY_0         : in std_logic;
	  PE_RDY_1         : in std_logic;
	  PE_RDY_2         : in std_logic;
	  PE_RDY_3         : in std_logic;
	  PE_RDY_4         : in std_logic;
	  PE_RDY_5         : in std_logic;
	  PE_RDY_6         : in std_logic;
	  PE_RDY_7         : in std_logic;
	  PE_RDY_8         : in std_logic;
	  PE_RDY_9         : in std_logic;
	  PE_RDY_10         : in std_logic;
	  PE_RDY_11         : in std_logic;
	  PE_RDY_12         : in std_logic;
	  PE_RDY_13         : in std_logic;
	  PE_RDY_14         : in std_logic;
	  PE_RDY_15         : in std_logic;
--PE request
    RST_R            : out std_logic;  --Active low
	  REQ_IN           : in std_logic;  --req to noc in reg logic
	  REQ_FIFO          : in std_logic_vector(31 downto 0);
	  DATA_TO_PE       : out std_logic_vector(127 downto 0);
	  DATA_VLD         : out std_logic;
	  PE_UNIT          : out std_logic_vector(5 downto 0);
	  BC              : out std_logic;
	  RD_FIFO          : out std_logic;
	  FIFO_VLD         : in std_logic

	  ); 
	  end component;
	  

component req_dst_logic
	port(
        --Shared
        CLK_P     : in std_logic;
        CLK_E     : in std_logic;   --Generated by PE pair 1 
        --CLK_E_NEG     : in std_logic;
        EVEN_P    : in std_logic;
        RESET     : in std_logic;
        --Requet logic
        REQ_TO_NOC : out std_logic;
        REQ_SIG   : in std_logic_vector(15 downto 0);
        ACK_SIG   : out std_logic_vector(15 downto 0);
        PE_REQ_IN    : in pe_req; -- pe_req(0) is the last PE (PE 64)
        OUTPUT    : out std_logic_vector(31 downto 0);
        RD_FIFO   : in std_logic;
        FIFO_VLD  : out std_logic;
        --Distribution network
		DATA_VLD  : in std_logic;
        DATA_NOC  : in std_logic_vector(127 downto 0);
        PE_UNIT   : in std_logic_vector(3 downto 0);
        B_CAST    : in std_logic;
		DATA_VLD_OUT : out std_logic_vector(15 downto 0);
        PE_DATA_OUT  : out pe_data
    
    );
	end component;

component PE_pair_top
	port(

	HCLK       : in    std_logic;                  -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     : in    std_logic;
    MRESET     : in    std_logic;                  -- system reset               low active
    MIRQOUT    : out   std_logic;                  -- interrupt request output    
    MCKOUT0    : out   std_logic;                  -- for trace adapter
    MCKOUT1    : out   std_logic;                  -- programable clock out
    MTEST      : in    std_logic;                  --                            high active                 
    MBYPASS    : in    std_logic;
    MIRQ0      : in    std_logic;                  --                            low active
    MIRQ1      : in    std_logic;                  --                            low active
    -- SW debug                                                               
    MSDIN      : in    std_logic;                  -- serial data in (debug)     
    MSDOUT     : out   std_logic ;                   -- serial data out  
	-- Cluster interface
	C1_REQ    : out std_logic;
    C2_REQ    : out std_logic;
    C1_ACK    : in std_logic;
    C2_ACK    : in std_logic;
    C1_REQ_D  : out std_logic_vector(31 downto 0);
    C2_REQ_D  : out std_logic_vector(31 downto 0);
    C1_IN_D   : in std_logic_vector(127 downto 0);
    C2_IN_D   : in std_logic_vector(127 downto 0);
    C1_DDI_VLD : in std_logic;
    C2_DDI_VLD : in std_logic;
    C1_RDY     : out std_logic;
    C2_RDY     : out std_logic;
    EXE        : in std_logic;
    RESUME     : in std_logic;
    C1_ID      : in std_logic_vector(5 downto 0);
    C2_ID      : in std_logic_vector(5 downto 0);
    MLP_PWR_OK : in    std_logic;                  -- Power on indecator --From Host directly
    MWAKEUP_LP  : in    std_logic   
  );
	end component;
--signal clk_p_i : std_logic;
--signal clk_e_i : std_logic;
signal even_p_i : std_logic;
--signal clk_e_neg_i : std_logic;
signal clk_o_i : std_logic;
--signal tag_i : std_logic;
signal tag_out_i : std_logic;
--signal data_i : std_logic_vector(7 downto 0);
signal data_out_i : std_logic_vector(7 downto 0);
signal rst_i : std_logic;
signal req_in_i : std_logic;
signal req_fifo_i : std_logic_vector(31 downto 0);
signal data_to_pe_i       : std_logic_vector(127 downto 0);
signal data_vld_i  : std_logic;
signal data_vld_to_pe : std_logic_vector(15 downto 0);
signal pe_unit_i    : std_logic_vector(5 downto 0);
signal bc_i         : std_logic;
signal rd_fifo_i    : std_logic;
signal fifo_vld_i   : std_logic;
signal req_sig_i    : std_logic_vector(15 downto 0);
signal ack_sig_i    : std_logic_vector(15 downto 0);
signal pe_rdy_reg   : std_logic_vector(15 downto 0);
signal pe_req_in_i    : pe_req;
signal pe_data_out_i  : pe_data;
signal exe : std_logic;
signal resume : std_logic;
signal id : ID_TYPE;

begin
    ------------------IO interface-------------------
    --clk_p_i <= CLK_P;
    --clk_e_i <= CLK_E;
    CLK_O <= clk_o_i;
    --tag_i <= TAG;
    TAG_FB <= tag_out_i;
    --data_i <= DATA;
    DATA_OUT <= data_out_i; 
	--clk_e_neg_i <= not clk_e_i;
    ------------------END----------------------------

--testbench: cluster_tb
--port map(
--	CLK_P => clk_p_i,
--	CLK_E => clk_e_i,
--	--CLK_E_NEG => clk_e_neg_i,
--	CLK_O => clk_o_i,
--	TAG  => tag_i,
--	TAG_FB => tag_out_i,
--    DATA => data_i,
--	DATA_OUT => data_out_i
--);

cc: cluster_controller
port map(
	CLK_P => clk_p,
	CLK_E => clk_e,
	--CLK_E_NEG => clk_e_neg_i,
	CLK_O => clk_o_i,
    EVEN_P => even_p_i,
    RST_E  => rst_e,
    --RST_P  => rst_p,
	TAG  => tag,
	TAG_FB => tag_out_i,
    DATA => data,
	DATA_OUT => data_out_i,
	exe      => exe,
	resume   => resume,
    C_RDY     => C_RDY,
    PE_RDY_0    => pe_rdy_reg(0),--'0',--temp
    PE_RDY_1    => pe_rdy_reg(1),--'0',--temp
    PE_RDY_2    => pe_rdy_reg(2),--'0',--temp
    PE_RDY_3    => pe_rdy_reg(3),--'0',--temp
    PE_RDY_4    => pe_rdy_reg(4),--'0',--temp
    PE_RDY_5    => pe_rdy_reg(5),--'0',--temp
    PE_RDY_6    => pe_rdy_reg(6),--'0',--temp
    PE_RDY_7    => pe_rdy_reg(7),--'0',--temp
    PE_RDY_8    => pe_rdy_reg(8),--'0',--temp
    PE_RDY_9    => pe_rdy_reg(9),--'0',--temp
    PE_RDY_10   => pe_rdy_reg(10),--'0',--temp
    PE_RDY_11   => pe_rdy_reg(11),--'0',--temp
    PE_RDY_12   => pe_rdy_reg(12),--'0',--temp
    PE_RDY_13   => pe_rdy_reg(13),--'0',--temp
    PE_RDY_14   => pe_rdy_reg(14),--'0',--temp
    PE_RDY_15   => pe_rdy_reg(15),--'0',--temp        
	RST_R => rst_i,
	REQ_IN     => req_in_i,
    REQ_FIFO   => req_fifo_i,
    DATA_TO_PE => data_to_pe_i,
    DATA_VLD   => data_vld_i,
    PE_UNIT    => pe_unit_i,
    BC         => bc_i,
    RD_FIFO    => rd_fifo_i,
    FIFO_VLD   => fifo_vld_i
);

cluster_net: req_dst_logic
port map(
	CLK_P      =>clk_p,
    CLK_E      =>clk_e,
    --CLK_E_NEG  =>clk_e_neg_i,
    EVEN_P     => even_p_i,
    RESET      =>rst_i,
    REQ_TO_NOC =>req_in_i,
    REQ_SIG    =>req_sig_i,
    ACK_SIG    =>ack_sig_i,
    PE_REQ_IN  =>pe_req_in_i,
    OUTPUT     =>req_fifo_i,
    RD_FIFO    =>rd_fifo_i,
    FIFO_VLD   =>fifo_vld_i,
	DATA_VLD   =>data_vld_i,
    DATA_NOC   =>data_to_pe_i,
    PE_UNIT    =>pe_unit_i(3 downto 0),
    B_CAST     =>bc_i,
	DATA_VLD_OUT => data_vld_to_pe,
    PE_DATA_OUT   => pe_data_out_i
);
pe_pair_1: PE_pair_top
port map(
	C1_REQ     => req_sig_i(15),
    C2_REQ     => req_sig_i(14),
    C1_ACK     => ack_sig_i(0),
    C2_ACK     => ack_sig_i(1),
    C1_REQ_D   => pe_req_in_i(0),
    C2_REQ_D   => pe_req_in_i(1),
    C1_IN_D    => pe_data_out_i(0),
    C2_IN_D    => pe_data_out_i(1),
    C1_DDI_VLD => data_vld_to_pe(0),
    C2_DDI_VLD => data_vld_to_pe(1),
    C1_RDY     => pe_rdy_reg(15),
    C2_RDY     => pe_rdy_reg(14),
    EXE        => exe,
    RESUME     => resume,
    C1_ID      => id(0),
    C2_ID      => id(1),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out  
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0' 
);
pe_pair_2: PE_pair_top
port map(
	C1_REQ     => req_sig_i(13),
    C2_REQ     => req_sig_i(12),
    C1_ACK     => ack_sig_i(2),
    C2_ACK     => ack_sig_i(3),
    C1_REQ_D   => pe_req_in_i(2),
    C2_REQ_D   => pe_req_in_i(3),
    C1_IN_D    => pe_data_out_i(2),
    C2_IN_D    => pe_data_out_i(3),
    C1_DDI_VLD => data_vld_to_pe(2),
    C2_DDI_VLD => data_vld_to_pe(3),
    C1_RDY     => pe_rdy_reg(13),
    C2_RDY     => pe_rdy_reg(12),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(2),
    C2_ID      => id(3),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out  
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0'
);
pe_pair_3: PE_pair_top
port map(
	C1_REQ     => req_sig_i(11),
    C2_REQ     => req_sig_i(10),
    C1_ACK     => ack_sig_i(4),
    C2_ACK     => ack_sig_i(5),
    C1_REQ_D   => pe_req_in_i(4),
    C2_REQ_D   => pe_req_in_i(5),
    C1_IN_D    => pe_data_out_i(4),
    C2_IN_D    => pe_data_out_i(5),
    C1_DDI_VLD => data_vld_to_pe(4),
    C2_DDI_VLD => data_vld_to_pe(5),
    C1_RDY     => pe_rdy_reg(11),
    C2_RDY     => pe_rdy_reg(10),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(4),
    C2_ID      => id(5),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out 
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0' 
);
pe_pair_4: PE_pair_top
port map(
	C1_REQ     => req_sig_i(9),
    C2_REQ     => req_sig_i(8),
    C1_ACK     => ack_sig_i(6),
    C2_ACK     => ack_sig_i(7),
    C1_REQ_D   => pe_req_in_i(6),
    C2_REQ_D   => pe_req_in_i(7),
    C1_IN_D    => pe_data_out_i(6),
    C2_IN_D    => pe_data_out_i(7),
    C1_DDI_VLD => data_vld_to_pe(6),
    C2_DDI_VLD => data_vld_to_pe(7),
    C1_RDY     => pe_rdy_reg(9),
    C2_RDY     => pe_rdy_reg(8),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(6),
    C2_ID      => id(7),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out  
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0'
);
pe_pair_5: PE_pair_top
port map(
	C1_REQ     => req_sig_i(7),
    C2_REQ     => req_sig_i(6),
    C1_ACK     => ack_sig_i(8),
    C2_ACK     => ack_sig_i(9),
    C1_REQ_D   => pe_req_in_i(8),
    C2_REQ_D   => pe_req_in_i(9),
    C1_IN_D    => pe_data_out_i(8),
    C2_IN_D    => pe_data_out_i(9),
    C1_DDI_VLD => data_vld_to_pe(8),
    C2_DDI_VLD => data_vld_to_pe(9),
    C1_RDY     => pe_rdy_reg(7),
    C2_RDY     => pe_rdy_reg(6),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(8),
    C2_ID      => id(9),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out 
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0' 
);
pe_pair_6: PE_pair_top
port map(
	C1_REQ     => req_sig_i(5),
    C2_REQ     => req_sig_i(4),
    C1_ACK     => ack_sig_i(10),
    C2_ACK     => ack_sig_i(11),
    C1_REQ_D   => pe_req_in_i(10),
    C2_REQ_D   => pe_req_in_i(11),
    C1_IN_D    => pe_data_out_i(10),
    C2_IN_D    => pe_data_out_i(11),
    C1_DDI_VLD => data_vld_to_pe(10),
    C2_DDI_VLD => data_vld_to_pe(11),
    C1_RDY     => pe_rdy_reg(5),
    C2_RDY     => pe_rdy_reg(4),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(10),
    C2_ID      => id(11),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out 
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0' 
);
pe_pair_7: PE_pair_top
port map(
	C1_REQ     => req_sig_i(3),
    C2_REQ     => req_sig_i(2),
    C1_ACK     => ack_sig_i(12),
    C2_ACK     => ack_sig_i(13),
    C1_REQ_D   => pe_req_in_i(12),
    C2_REQ_D   => pe_req_in_i(13),
    C1_IN_D    => pe_data_out_i(12),
    C2_IN_D    => pe_data_out_i(13),
    C1_DDI_VLD => data_vld_to_pe(12),
    C2_DDI_VLD => data_vld_to_pe(13),
    C1_RDY     => pe_rdy_reg(3),
    C2_RDY     => pe_rdy_reg(2),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(12),
    C2_ID      => id(13),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0'  
);
pe_pair_8: PE_pair_top
port map(
	C1_REQ     => req_sig_i(1),
    C2_REQ     => req_sig_i(0),
    C1_ACK     => ack_sig_i(14),
    C2_ACK     => ack_sig_i(15),
    C1_REQ_D   => pe_req_in_i(14),
    C2_REQ_D   => pe_req_in_i(15),
    C1_IN_D    => pe_data_out_i(14),
    C2_IN_D    => pe_data_out_i(15),
    C1_DDI_VLD => data_vld_to_pe(14),
    C2_DDI_VLD => data_vld_to_pe(15),
    C1_RDY     => pe_rdy_reg(1),
    C2_RDY     => pe_rdy_reg(0),
    EXE        => '0',--exe,      --Block
    RESUME     => resume,
    C1_ID      => id(14),
    C2_ID      => id(15),
	HCLK       => clk_p,                 -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     => even_p_i,
    MRESET     => rst_i,                 -- system reset               low active
    MIRQOUT    => open,                 -- interrupt request output    
    MCKOUT0    => open,                 -- for trace adapter
    MCKOUT1    => open,                 -- programable clock out
    MTEST      => '0',                 --                            high active                 
    MBYPASS    => '0',
    MIRQ0      => '1',                 --                            low active
    MIRQ1      => '1',                 --                            low active
    -- SW debug=>                                             
    MSDIN      => '0',                 -- serial data in (debug)     
    MSDOUT     => open,                 -- serial data out 
    MLP_PWR_OK => '1',
    MWAKEUP_LP => '0' 
);
end struct;
