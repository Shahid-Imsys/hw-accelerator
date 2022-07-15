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

entity Top is
  Port (
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
        PEC_Ready            : in  std_logic; 
        GPP_CMD_ACK          : in  std_logic;
        GPP_CMD_Flag         : in  std_logic;
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        NOC_CMD_flag         : out std_logic;
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        --IO INTERFACE SIGNALS
        IO_data              : in  std_logic_vector(127 downto 0);
        NOC_data             : out std_logic_vector(127 downto 0);
        NOC_Address          : out std_logic_vector(31 downto 0);           
        NOC_Length           : out std_logic_vector(15 downto 0);
        NOC_WRITE_REQ        : out std_logic;
        IO_WRITE_ACK         : in  std_logic;
        FIFO_Ready1          : in  std_logic;
        FIFO_Ready2          : in  std_logic;
        FIFO_Ready3          : in  std_logic;
        NOC_DATA_DIR         : out std_logic;
        NOC_DATA_EN          : out std_logic;
        NOC_CTRL_EN          : out std_logic
  );
end Top;

architecture Behavioral of Top is

    component Noc_Top is
    Port(
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
        IO_data              : in  std_logic_vector(127 downto 0);
        FIFO_Ready1          : in  std_logic;
        FIFO_Ready2          : in  std_logic;
        FIFO_Ready3          : in  std_logic;
        WRITE_ACK            : in  std_logic;                
        PEC_Ready            : in  std_logic; 
        GPP_CMD_ACK          : in  std_logic;
        GPP_CMD_Flag         : in  std_logic;
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        --from NOC bus 
        Write_enable         : in  std_logic;
        NOC_bus_in           : in  std_logic_vector(127 downto 0);
        --Output 
        En_IO_Data           : out std_logic;
        En_IO_ctrl           : out std_logic;
        NOC_CMD_flag         : out std_logic;
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        Address              : out std_logic_vector(31 downto 0);               
        Length               : out std_logic_vector(15 downto 0);
        Noc_bus_out          : out std_logic_vector(127 downto 0);
        Tag_Line             : out std_logic;
        NOC_WRITE_REQ        : out std_logic;
        NOC_data             : out std_logic_vector(127 downto 0);
        NOC_DATA_DIR         : out std_logic
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
    
    signal NOC_bus_in   : std_logic_vector(127 downto 0):= (others => '0');
    signal Noc_bus_out  : std_logic_vector(127 downto 0):= (others => '0');
    signal Tag_Line     : std_logic;
    signal Write_enable : std_logic;
     
begin

    Noc_Top_Inst: Noc_Top
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        IO_data                 => IO_data,
        FIFO_Ready1             => FIFO_Ready1,
        FIFO_Ready2             => FIFO_Ready2,
        FIFO_Ready3             => FIFO_Ready3,
        Write_ACK               => IO_WRITE_ACK,
        PEC_Ready               => PEC_Ready,
        GPP_CMD_ACK             => GPP_CMD_ACK,
        GPP_CMD_Flag            => GPP_CMD_Flag,
        GPP_CMD_Data            => GPP_CMD_Data,
        --from NOC bus 
        Write_enable            => Write_enable,
        NOC_bus_in              => NOC_bus_in,
        --Output 
        En_IO_Data              => NOC_DATA_EN,
        En_IO_ctrl              => NOC_CTRL_EN ,
        NOC_CMD_flag            => NOC_CMD_flag,
        NOC_CMD_Data            => NOC_CMD_Data,  
        Address                 => NOC_Address,
        Length                  => NOC_Length,
        Noc_bus_out             => Noc_bus_out,
        Tag_Line                => Tag_Line,
        NOC_WRITE_REQ           => NOC_WRITE_REQ,
        Noc_data                => NOC_data,
        NOC_DATA_DIR            => NOC_DATA_DIR
    );
        
    cluster_controller_Inst1: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(7 downto 0),
        DATA_OUT                => NOC_bus_in(7 downto 0),
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
    
    cluster_controller_Inst2: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs 
        DDO_VLD                 => Write_enable,       
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(15 downto 8),
        DATA_OUT                => NOC_bus_in(15 downto 8),
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
      
    cluster_controller_Inst3: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs 
        DDO_VLD                 => Write_enable,       
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(23 downto 16),
        DATA_OUT                => NOC_bus_in(23 downto 16),
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
    
    cluster_controller_Inst4: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(31 downto 24),
        DATA_OUT                => NOC_bus_in(31 downto 24),
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
    
    cluster_controller_Inst5: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(39 downto 32),
        DATA_OUT                => NOC_bus_in(39 downto 32),
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
    
    cluster_controller_Inst6: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(47 downto 40),
        DATA_OUT                => NOC_bus_in(47 downto 40),
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
      
    cluster_controller_Inst7: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(55 downto 48),
        DATA_OUT                => NOC_bus_in(55 downto 48),
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
    
    cluster_controller_Inst8: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(63 downto 56),
        DATA_OUT                => NOC_bus_in(63 downto 56),
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
    
    
    
    cluster_controller_Inst9: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(71 downto 64),
        DATA_OUT                => NOC_bus_in(71 downto 64),
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
    
    cluster_controller_Inst10: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs 
        DDO_VLD                 => Write_enable,       
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(79 downto 72),
        DATA_OUT                => NOC_bus_in(79 downto 72),
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
      
    cluster_controller_Inst11: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs 
        DDO_VLD                 => Write_enable,       
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(87 downto 80),
        DATA_OUT                => NOC_bus_in(87 downto 80),
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
    
    cluster_controller_Inst12: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(95 downto 88),
        DATA_OUT                => NOC_bus_in(95 downto 88),
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
    
    cluster_controller_Inst13: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(103 downto 96),
        DATA_OUT                => NOC_bus_in(103 downto 96),
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
    
    cluster_controller_Inst14: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(111 downto 104),
        DATA_OUT                => NOC_bus_in(111 downto 104),
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
      
    cluster_controller_Inst15: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(119 downto 112),
        DATA_OUT                => NOC_bus_in(119 downto 112),
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
    
    cluster_controller_Inst16: cluster_controller
    port map
    (
--Clock inputs    
        CLK_P                   => clk,
        CLK_E                   => clk,
--Power reset input:        
        RST_E                   => Reset,
--Clock outputs
        DDO_VLD                 => Write_enable,        
        EVEN_P                  => open,
--Tag line        
        TAG                     => Tag_Line,    
        TAG_FB                  => open,
--Data line        
        DATA                    => Noc_bus_out(127 downto 120),
        DATA_OUT                => NOC_bus_in(127 downto 120),
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
           
end Behavioral;