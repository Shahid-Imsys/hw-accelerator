----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.06.2022 12:01:30
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Accelerator_Top is
    Generic(
      USE_ASIC_MEMORIES      : boolean := false
    );
    Port (
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
        PEC_Ready            : in  std_logic;
        --Command interface signals 
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        GPP_CMD_Flag         : in  std_logic;
        NOC_CMD_flag         : out std_logic;
        GPP_CMD_ACK          : in  std_logic;
        --Data/control interface signals
        IO_data              : in  std_logic_vector(127 downto 0);
        NOC_data             : out std_logic_vector(127 downto 0);
        NOC_Address          : out std_logic_vector(31 downto 0);           
        NOC_Length           : out std_logic_vector(15 downto 0);
        FIFO_Ready           : in  std_logic_vector(5 downto 0);
        NOC_DATA_DIR         : out std_logic;
        NOC_DATA_EN          : out std_logic;        
        NOC_WRITE_REQ        : out std_logic;
        IO_WRITE_ACK         : in  std_logic
  );
end Accelerator_Top;

architecture Behavioral of Accelerator_Top is

    component Noc_Top is
    Generic(
      USE_ASIC_MEMORIES      : boolean := false
    );
    Port(
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
        PEC_Ready            : in  std_logic; 
        --NOC PEC INTERFACE
        PEC_WE               : in  std_logic;
        PEC_byte_data        : in  std_logic_vector(127 downto 0);
        Noc_byte_data        : out std_logic_vector(127 downto 0);
        Tag_Line             : out std_logic;        
        --ACCELERATOR INTERFACE
        --Command interface signals
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        GPP_CMD_Flag         : in  std_logic;
        NOC_CMD_flag         : out std_logic;
        GPP_CMD_ACK          : in  std_logic;        
        --Data/control interface signals
        IO_data              : in  std_logic_vector(127 downto 0);
        NOC_data             : out std_logic_vector(127 downto 0);
        NOC_Address          : out std_logic_vector(31 downto 0);               
        NOC_Length           : out std_logic_vector(15 downto 0);    
        FIFO_Ready           : in  std_logic_vector(5 downto 0);
        NOC_DATA_DIR         : out std_logic;
        NOC_DATA_EN          : out std_logic;
        NOC_WRITE_REQ        : out std_logic;        
        IO_WRITE_ACK         : in  std_logic                
    );
    end component;

 
    component cluster_controller is
    port(
--Clock inputs
        CLK_P                : in std_logic;     --PE clock, clock from the oscillator --0628
	    CLK_E                : in std_logic;     --NOC clock
--Power reset input:
	    RST_E                : in std_logic; --active low --For reset clk_e generator
--Clock outputs
        DDO_VLD              : out std_logic;    --Output data valid port
	    EVEN_P               : out std_logic;    --To PE and network
--Tag line
	    TAG                  : in std_logic;
	    TAG_FB               : out std_logic;
--Data line   
	    DATA                 : in std_logic_vector(7 downto 0);
	    DATA_OUT             : out std_logic_vector(7 downto 0);
--PE Control
        EXE                  : out std_logic;   --Start execution
	    RESUME               : out std_logic;   --Resume paused execution
--Feedback signals
        C_RDY                : out std_logic;
	    PE_RDY_0             : in std_logic;
	    PE_RDY_1             : in std_logic;
	    PE_RDY_2             : in std_logic;
	    PE_RDY_3             : in std_logic;
	    PE_RDY_4             : in std_logic;
	    PE_RDY_5             : in std_logic;
	    PE_RDY_6             : in std_logic;
	    PE_RDY_7             : in std_logic;
	    PE_RDY_8             : in std_logic;
	    PE_RDY_9             : in std_logic;
	    PE_RDY_10            : in std_logic;
	    PE_RDY_11            : in std_logic;
	    PE_RDY_12            : in std_logic;
	    PE_RDY_13            : in std_logic;
	    PE_RDY_14            : in std_logic;
	    PE_RDY_15            : in std_logic;
--Request and distribution logic signals
        RST_R                : out std_logic;  --Active low
	    REQ_IN               : in std_logic;  --req to noc in reg logic
	    REQ_FIFO             : in std_logic_vector(31 downto 0);
	    DATA_FROM_PE         : in std_logic_vector(127 downto 0);
	    DATA_TO_PE           : out std_logic_vector(127 downto 0);
	    DATA_VLD             : out std_logic;
	    PE_UNIT              : out std_logic_vector(5 downto 0);
	    BC                   : out std_logic; --Broadcast handshake
	    RD_FIFO              : out std_logic;
	    FIFO_VLD             : in std_logic
    );
    end component;
    
    signal PEC_byte_data : std_logic_vector(127 downto 0):= (others => '0');
    signal Noc_byte_data : std_logic_vector(127 downto 0):= (others => '0');
    signal Tag_Line      : std_logic;
    signal PEC_WE        : std_logic_vector(0 to 15);
     
begin

    Noc_Top_Inst: Noc_Top
    Generic map(
      USE_ASIC_MEMORIES         => USE_ASIC_MEMORIES
    )
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        PEC_Ready               => PEC_Ready,
        --NOC PEC INTERFACE 
        PEC_WE                  => PEC_WE(0),
        PEC_byte_data           => PEC_byte_data, 
        Noc_byte_data           => Noc_byte_data,
        Tag_Line                => Tag_Line,
        --ACCELERATOR INTERFACE
        --Command interface signals 
        GPP_CMD_Data            => GPP_CMD_Data,
        NOC_CMD_Data            => NOC_CMD_Data,
        GPP_CMD_Flag            => GPP_CMD_Flag,
        NOC_CMD_flag            => NOC_CMD_flag,                                  
        GPP_CMD_ACK             => GPP_CMD_ACK,
        --Data/control interface signals
        IO_data                 => IO_data,
        Noc_data                => NOC_data,
        NOC_Address             => NOC_Address,
        NOC_Length              => NOC_Length,                        
        FIFO_Ready              => FIFO_Ready,
        NOC_DATA_DIR            => NOC_DATA_DIR,
        NOC_DATA_EN             => NOC_DATA_EN,
        NOC_WRITE_REQ           => NOC_WRITE_REQ,
        IO_WRITE_ACK            => IO_WRITE_ACK        
    );
        
  cc_gen : for i in 0 to 1 generate
    cluster_controller_Inst : cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => PEC_WE(i),        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_byte_data(8*i+7 downto 8*i),
        DATA_OUT                => PEC_byte_data(8*i+7 downto 8*i),
--PE Control        
        EXE                     => open,
        RESUME                  => open,
--Feedback signals        
        C_RDY                   => open,
        PE_RDY_0                => '0',
        PE_RDY_1                => '0',
        PE_RDY_2                => '0',
        PE_RDY_3                => '0',
        PE_RDY_4                => '0',
        PE_RDY_5                => '0',
        PE_RDY_6                => '0',
        PE_RDY_7                => '0',
        PE_RDY_8                => '0',
        PE_RDY_9                => '0',
        PE_RDY_10               => '0',
        PE_RDY_11               => '0',
        PE_RDY_12               => '0',
        PE_RDY_13               => '0',
        PE_RDY_14               => '0',
        PE_RDY_15               => '0',
--Request and distribution logic signals        
        RST_R                   => open,
        REQ_IN                  => '0',
        REQ_FIFO                => (others => '0'),
        DATA_FROM_PE            => (others => '0'),
        DATA_TO_PE              => open,
        DATA_VLD                => open,
        PE_UNIT                 => open,
        BC                      => open,
        RD_FIFO                 => open,
        FIFO_VLD                => '0'                                  
    );
  end generate;
           
end Behavioral;