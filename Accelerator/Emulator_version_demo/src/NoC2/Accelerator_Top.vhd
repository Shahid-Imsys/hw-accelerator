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
use ieee.numeric_std.all;

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
    generic ( USE_ASIC_MEMORIES : boolean := true );
    Port( 
        CLK_P    : in std_logic;
        CLK_E    : in std_logic;
        RST_E    : in std_logic;
        DDO_VLD  : out std_logic;
        TAG      : in std_logic;
        TAG_FB   : out std_logic;
        C_RDY    : out std_logic;
        DATA     : in std_logic_vector(7 downto 0);
        DATA_OUT : out std_logic_vector(7 downto 0)
    );
    end component;
    
    
    signal PEC_byte_data : std_logic_vector(127 downto 0):= (others => '0');
    signal Noc_byte_data : std_logic_vector(127 downto 0):= (others => '0');
    signal Tag_Line      : std_logic;
    signal PEC_WE        : std_logic_vector(PEC_NUMBER -1 downto 0);
    signal C_RDY         : std_logic_vector(PEC_NUMBER -1 downto 0); 
    signal PEC_Ready     : std_logic;
    signal PEC_WE_noc    : std_logic;
     
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

  pec_gen : for i in 0 to PEC_NUMBER -1 generate
    PEC_top_Inst : PEC_top
    Generic map(
      USE_ASIC_MEMORIES         => USE_ASIC_MEMORIES
    )    
    port map
    ( 
        CLK_P                   => clk_p,
        CLK_E                   => clk_e,
        RST_E                   => Reset,
        DDO_VLD                 => PEC_WE(i),
        TAG                     => Tag_Line,
        TAG_FB                  => open,
        C_RDY                   => C_RDY(i),
        DATA                    => Noc_byte_data(8*i+7 downto 8*i),
        DATA_OUT                => PEC_byte_data(8*i+7 downto 8*i)
     );
  end generate;

  PEC_Ready <= '1' when to_integer(unsigned(C_RDY)) = 2**PEC_NUMBER - 1 else '0';
  PEC_WE_noc<= '1' when to_integer(unsigned(PEC_WE)) > 0 else '0';

end Behavioral;