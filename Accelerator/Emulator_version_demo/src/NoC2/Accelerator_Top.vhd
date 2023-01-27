----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
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
use ieee.numeric_std.all;
use work.noc_types_pkg.all;

entity Accelerator_Top is
    Generic(
      USE_ASIC_MEMORIES      : boolean := true;
      PEC_NUMBER             : integer := 2
    );
    Port (
	      clk_p                : in  std_logic;
        clk_e                : in  std_logic;
	      Reset                : in  std_logic;
        --Command interface signals 
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        GPP_CMD_Flag         : in  std_logic;
        NOC_CMD_ACK          : out std_logic;
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
      USE_ASIC_MEMORIES      : boolean := true
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
        NOC_CMD_ACK          : out std_logic;
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

    component PEC_top is
    generic(
      USE_ASIC_MEMORIES      : boolean := true;
      PEC_NUMBER             : integer := 2
    );    
    Port( 
        CLK_P    : in std_logic;
        CLK_E    : in std_logic;
        RST_E    : in std_logic;
        DDO_VLD  : out std_logic;
        TAG      : in std_logic;
        TAG_FB   : out std_logic;
        C_RDY    : out std_logic;
        DATA_True_Broadcast : in noc_data_t(15 downto 0);
        DATA     : in std_logic_vector(7 downto 0);        
        DATA_OUT : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component noc_bus is
    generic(
      PEC_NUMBER             : integer := 2;
      REGEN_POINTS           : integer := 2
    );    
    port(
        clk                     : in  std_logic;
        rst                     : in  std_logic;
        enable                  : in  std_logic;
        
        data_from_noc_switch    : in  std_logic_vector(127 downto 0);
        data_to_cc              : out noc_data_t(15 downto 0);        
    
        data_from_cc            : in  noc_data_t(PEC_NUMBER -1 downto 0);
        data_to_noc_switch      : out noc_data_t(PEC_NUMBER -1 downto 0);
    
        tag_from_master         : in  std_logic;
        tag_to_cc               : out std_logic;
    
        tag_to_master           : out noc_tag_t(PEC_NUMBER -1 downto 0);
        tag_from_cc             : in  noc_tag_t(PEC_NUMBER -1 downto 0)
    );
    end component;
    
    
    signal PEC_byte_data  : std_logic_vector(127 downto 0):= (others => '0');
    signal PEC_data       : noc_data_t(PEC_NUMBER -1 downto 0);  
    signal Noc_byte_data  : std_logic_vector(127 downto 0):= (others => '0');
    signal Tag_Line       : std_logic;
    signal PEC_WE         : std_logic_vector(PEC_NUMBER -1 downto 0);
    signal C_RDY          : std_logic_vector(PEC_NUMBER -1 downto 0); 
    signal PEC_Ready      : std_logic;
    signal PEC_WE_noc     : std_logic;
    signal Tag_Line_to_cc : std_logic;
    signal C_RDY_to_master: std_logic_vector(PEC_NUMBER -1 downto 0);
    signal data_to_cc     : noc_data_t(15 downto 0);
    signal data_from_cc   : noc_data_t(PEC_NUMBER -1 downto 0);
    signal Tag_to_master  : noc_tag_t(PEC_NUMBER -1 downto 0);
    signal Tag_from_cc    : noc_tag_t(PEC_NUMBER -1 downto 0);
    signal PEC_Ready_to_master: std_logic_vector(PEC_NUMBER -1 downto 0);
    signal PEC_WE_to_master: std_logic_vector(PEC_NUMBER -1 downto 0);
     
begin

    Noc_Top_Inst: Noc_Top
    Generic map(
      USE_ASIC_MEMORIES         => USE_ASIC_MEMORIES
    )
    port map
    (
        clk                     => clk_e,
        Reset                   => Reset,
        PEC_Ready               => PEC_Ready,
        --NOC PEC INTERFACE 
        PEC_WE                  => PEC_WE_noc,
        PEC_byte_data           => PEC_byte_data, 
        Noc_byte_data           => Noc_byte_data,
        Tag_Line                => Tag_Line,
        --ACCELERATOR INTERFACE
        --Command interface signals 
        GPP_CMD_Data            => GPP_CMD_Data,
        NOC_CMD_Data            => NOC_CMD_Data,
        GPP_CMD_Flag            => GPP_CMD_Flag,
        NOC_CMD_ACK             => NOC_CMD_ACK,
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
    
    noc_bus_Inst: noc_bus
    Generic map(
      PEC_NUMBER         => PEC_NUMBER,
      REGEN_POINTS       => 2
    )
    port map
    (
        clk                     => clk_e,
        rst                     => Reset,
        enable                  => '1',     --need to check
         
        data_from_noc_switch    => Noc_byte_data,
        data_to_cc              => data_to_cc,
    
        data_from_cc            => data_from_cc,
        data_to_noc_switch      => PEC_data,
    
        tag_from_master         => Tag_Line,
        tag_to_cc               => Tag_Line_to_cc,
    
        tag_to_master           => Tag_to_master,--C_RDY_to_master,
        tag_from_cc             => Tag_from_cc  --C_RDY
    );

  pec_gen : for i in 0 to PEC_NUMBER -1 generate
    PEC_top_Inst : PEC_top
    Generic map(
      USE_ASIC_MEMORIES         => USE_ASIC_MEMORIES,
      PEC_NUMBER                => PEC_NUMBER   
    )    
    port map
    ( 
        CLK_P                   => clk_p,
        CLK_E                   => clk_e,
        RST_E                   => Reset,
        DDO_VLD                 => PEC_WE(i),
        TAG                     => Tag_Line_to_cc,
        TAG_FB                  => open,
        C_RDY                   => C_RDY(i),
        DATA_True_Broadcast     => data_to_cc,
        DATA                    => data_to_cc(i),
        DATA_OUT                => data_from_cc(i)
     );
  end generate;

  Tag_gen : for i in 0 to PEC_NUMBER -1 generate  
      Tag_from_cc(i)   <= C_RDY(i) & PEC_WE(i);
  end generate;
  
    Tag_to_master_gen : for i in 0 to PEC_NUMBER -1 generate  
      PEC_Ready_to_master(i)   <= Tag_to_master(i)(1);
      PEC_WE_to_master(i)      <= Tag_to_master(i)(0);
  end generate;    
 
  PEC_Ready     <= '1' when to_integer(unsigned(PEC_Ready_to_master)) = 2**PEC_NUMBER - 1 else '0';
  PEC_WE_noc    <= '1' when to_integer(unsigned(PEC_WE_to_master)) > 0 else '0';
  
  PEC_byte_data(127 downto (8*PEC_NUMBER)) <= (others => '0') when PEC_NUMBER < 16;

  PEC_byte_data_gen : for i in 0 to PEC_NUMBER -1 generate  
      PEC_byte_data((i*8+7) downto i*8)  <= PEC_data(i);
  end generate;
    
--  PEC_Ready     <= '1' when to_integer(unsigned(C_RDY_to_master)) = 2**PEC_NUMBER - 1 else '0';
--  PEC_WE_noc    <= '1' when to_integer(unsigned(PEC_WE)) > 0 else '0';  

end Behavioral;