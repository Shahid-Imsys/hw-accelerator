----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 13:45:02
-- Design Name: 
-- Module Name: NOC_Top_TB - Behavioral
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

entity NOC_Top_TB is
--  Port ( );
end NOC_Top_TB;

architecture Behavioral of NOC_Top_TB is

    component Noc_Top is
    port(
        clk                  : in  std_logic;
        Reset                : in  std_logic;
        IO_data              : in  std_logic_vector(127 downto 0);
        FIFO_Ready1          : in  std_logic;
        FIFO_Ready2          : in  std_logic;
        FIFO_Ready3          : in  std_logic;
        Write_ACK            : in  std_logic;                
        PEC_Ready            : in  std_logic; 
        GPP_ACK              : in  std_logic;
        GPP_CMD_Flag         : in  std_logic;
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        --from NOC bus 
        Write_enable         : in  std_logic;
        NOC_bus_in           : in  std_logic_vector(127 downto 0);
        --Output 
        En_IO_Data           : out std_logic;
        En_IO_ctrl           : out std_logic;
        Sync_pulse           : out std_logic;
        En_CMD               : out std_logic;        
        NOC_CMD_flag         : out std_logic;
        NOC_CMD_Data         : out std_logic_vector(1 downto 0);
        Address              : out std_logic_vector(31 downto 0);               
        Length               : out std_logic_vector(15 downto 0);
        Noc_bus_out          : out std_logic_vector(127 downto 0);
        Tag_Line             : out std_logic;
        Write_REQ            : out std_logic       
      );
    end component;
    
    signal    clk           : std_logic;
    signal    Reset         : std_logic;
    signal    IO_data       : std_logic_vector(127 downto 0);
    signal    FIFO_Ready1   : std_logic;
    signal    FIFO_Ready2   : std_logic;
    signal    FIFO_Ready3   : std_logic;
    signal    Write_ACK     : std_logic;
    signal    PEC_Ready     : std_logic;
    signal    GPP_ACK       : std_logic;
    signal    GPP_CMD_Flag  : std_logic;
    signal    GPP_CMD_Data  : std_logic_vector(127 downto 0);  
    signal    Write_enable  : std_logic;
    signal    NOC_bus_in    : std_logic_vector(127 downto 0);
    signal    En_IO_Data    : std_logic;
    signal    En_IO_ctrl    : std_logic;
    signal    Sync_pulse    : std_logic;
    signal    En_CMD        : std_logic;
    signal    NOC_CMD_flag  : std_logic;
    signal    NOC_CMD_Data  : std_logic_vector(1 downto 0);
    signal    Address       : std_logic_vector(31 downto 0);
    signal    Length        : std_logic_vector(15 downto 0);
    signal    Noc_bus_out   : std_logic_vector(127 downto 0);
    signal    Tag_Line      : std_logic;
    signal    Write_REQ     : std_logic;
     

begin
    
    UUT: Noc_Top port map (clk => clk, Reset => Reset, IO_data => IO_data, FIFO_Ready1 => FIFO_Ready1, FIFO_Ready2 => FIFO_Ready2, FIFO_Ready3 => FIFO_Ready3, Write_ACK => Write_ACK, PEC_Ready => PEC_Ready, GPP_ACK => GPP_ACK, GPP_CMD_Flag => GPP_CMD_Flag, GPP_CMD_Data => GPP_CMD_Data, Write_enable => Write_enable, NOC_bus_in => NOC_bus_in, En_IO_Data => En_IO_Data, En_IO_ctrl => En_IO_ctrl, Sync_pulse => Sync_pulse, En_CMD => En_CMD, NOC_CMD_flag => NOC_CMD_flag, NOC_CMD_Data => NOC_CMD_Data, Address => Address, Length => Length, Noc_bus_out => Noc_bus_out, Tag_Line => Tag_Line, Write_REQ => Write_REQ); 

    process
    begin
        Reset               <= '0';
        Write_ack           <= '0';
        FIFO_Ready1         <= '0'; 
        FIFO_ready2         <= '0';
        FIFO_Ready3         <= '0';
        IO_data             <= (others => '0'); 
        GPP_CMD_Flag        <= '0';              
        wait for 50 ns;    
        Reset               <= '1';   
        wait for 40 ns;    
        Reset               <= '0';
        wait for 300 ns;  
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"000000000000000000000000007D000E";          
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 200 ns;
        Write_ack           <= '1';
        wait for 40 ns;
        Write_ack           <= '0';
        wait for 200 ns;
        FIFO_ready2         <= '1';
        wait for 80 ns;
        FIFO_ready2         <= '0';
        IO_data             <= x"00000000005000020000000000000000";
        wait for 100 ns;
        IO_data             <= x"0000070000C00203000C006000080001";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";      
        wait for 100 ns;
        IO_data             <= x"00080008001000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000660001000400000064800100040";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"08000608081000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000800062008100000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;        
        IO_data             <= x"00000000000000000000000000000000";       
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";          
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;        
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';      
        IO_data             <= x"00000744081000F00000018200040052"; --EM->RM  --182                                                                 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000030800240030"; --LR=09 0r 08?
        wait for 100 ns;
        IO_data             <= x"00020000000000000250004900000183"; --183
        wait for 100 ns;
        IO_data             <= x"04529055009E9004009E901400021000";
        wait for 100 ns;
        IO_data             <= x"000290000012904D000E902005529058";
        wait for 100 ns;
        IO_data             <= x"0000800000109049000E902000000000";  
        wait for 100 ns;
        IO_data             <= x"0000000000000000000880020010901A";   --1A = address of RM ->MUX-> DDR
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00020000000000000250006100000201";  --EM->TP->RM
        wait for 100 ns;
        IO_data             <= x"0453D06D009FD004009FD01400035000"; 
        wait for 100 ns;
        IO_data             <= x"0003D2030013D965000FD0200553D070"; 
        wait for 100 ns;
        IO_data             <= x"000082030019D961000FD02000000000"; 
        wait for 100 ns;
        IO_data             <= x"009D9004000112030000830C0001D900"; 
        wait for 100 ns;
        IO_data             <= x"000000000008000200108000009D9004"; --00108000 1C= address of RM->TP->EM
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        -------------------------------------------------------------- 32 ta 0
        wait for 100 ns;        
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';
        IO_data             <= x"00000000000000000000000000000000";                 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;        
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';
        IO_data             <= x"00000000000000000000000000000000";                 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";                  
        --------------------------------------------------------------
        wait for 100 ns;        
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';
        IO_data             <= x"08000704081000F00000011100040052"; --x"08000704081000F00004001200000111";  --RM->EM
        wait for 100 ns;
        IO_data             <= x"00000000000000000000030700240030"; --x"000003080020000008000706081000E0"; LR=08 0r 07?
        wait for 100 ns;
        IO_data             <= x"0000800000008000000000000A500008"; 
        wait for 100 ns;
        IO_data             <= x"0C529015009E9004009E901400009000"; 
        wait for 100 ns;
        IO_data             <= x"0812900D00029000000E90200D52901A"; 
        wait for 100 ns;
        IO_data             <= x"0812100800021000000E902000029000"; 
        wait for 100 ns;
        IO_data             <= x"00121000000210000000000000020000"; 
        wait for 100 ns;
        IO_data             <= x"000000000000000000000000000A0002"; 
        wait for 100 ns;         
        IO_data             <= x"00008000000000000A50002100000202";  --RM->TP->EM              
        wait for 100 ns;
        IO_data             <= x"009FD004009FD0140000900000008000";
        wait for 100 ns;
        IO_data             <= x"000AD000000FD0200D5AD0350C5AD030";
        wait for 100 ns;
        IO_data             <= x"0000000000000000000AD203081AD026";
        wait for 100 ns;
        IO_data             <= x"081349210003500000035000000FD020";
        wait for 100 ns;
        IO_data             <= x"000349000003530D0003500000000203";  
        wait for 100 ns;
        IO_data             <= x"00100000009F0004009F000400000203";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000080002";  
        wait for 100 ns;
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';        
        IO_data             <= x"00000000000000000000000000000140";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000150"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;        
        IO_data             <= x"00000000000000000000000000000000";                 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';        
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";                 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";        
        wait for 100 ns;
        FIFO_ready2         <= '1';
        wait for 100 ns;
        FIFO_ready2         <= '0';        
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";         
        wait for 100 ns;
        IO_data             <= x"0000000000000506081000E8000007F8"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000"; 
        wait for 100 ns;                          
        IO_data             <= x"00000000000000000000000000000000";                 
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        ------------------------------------------------------------               
        wait for 100 ns;
        IO_data             <= x"0030000000A0000000A0000000040001";
        wait for 100 ns;
        IO_data             <= x"00000000000000000000000000000000";
        wait for 100 ns;
        IO_data             <= x"0B5000F300080014000000000D5000F8";
        wait for 100 ns;
        IO_data             <= x"00000000000800040034000400000000";  
        wait for 100 ns;
        IO_data             <= x"00000000000000000004004000100000";
        wait for 200ns;
        --------------------------------------------------------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------------        
        --------------------------------------------EM->MUX->RM  & RM->MUX->EM----------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------------        
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000400010";          
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        Write_ack           <= '1';
--        wait for 100 ns;
--        Write_ack           <= '0';
--        ---------------------------------------------DATA IS READY IN FIFO
--        wait for 380 ns;    ----Based on this wait time, fifo_ready can come when code line 49 or 4A is being executed. But when adding adapter FIFO this will be fixed.
--        FIFO_ready2         <= '1';
--        IO_data             <= x"11111111111111111111111111111111";        
--        wait for 80 ns;
--        FIFO_ready2         <= '0';   --***
--        wait for 20 ns;
--        IO_data             <= x"22222222222222222222222222222222";        
--        wait for 20 ns;
--        IO_data             <= x"33333333333333333333333333333333";
--        wait for 20 ns;
--        IO_data             <= x"44444444444444444444444444444444";
--        wait for 20 ns;
--        IO_data             <= x"55555555555555555555555555555555";        
--        wait for 20 ns;
--        IO_data             <= x"66666666666666666666666666666666";   
--        wait for 20 ns;
--        IO_data             <= x"77777777777777777777777777777777";
--        wait for 20 ns;
--        IO_data             <= x"88888888888888888888888888888888";
--        wait for 20 ns;
--        IO_data             <= x"99999999999999999999999999999999";        
--        wait for 20 ns;
--        IO_data             <= x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
--        wait for 20 ns;
--        IO_data             <= x"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
--        FIFO_ready3         <= '1';    --***    
--        wait for 20 ns;
--        IO_data             <= x"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC";
--        wait for 20 ns;
--        IO_data             <= x"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD";
--        wait for 20 ns;
--        IO_data             <= x"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";   
--        wait for 20 ns;
--        IO_data             <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
--        FIFO_ready3         <= '0';                        
--        wait for 20 ns;
--        IO_data             <= x"11112222333344445555666677778888";
--        -------------------------------------------------------------------
----        FIFO_ready2         <= '1';
----        wait for 100 ns;
--        wait for 20 ns;
----        FIFO_ready2         <= '0';
--        IO_data             <= x"AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB";        
--        wait for 20 ns;
--        IO_data             <= x"CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDD";   
--        wait for 20 ns;
--        IO_data             <= x"EEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFF";
--        wait for 20 ns;
--        IO_data             <= x"11111111111111112222222222222222";
--        wait for 20 ns;
--        IO_data             <= x"33333333333333334444444444444444";        
--        wait for 20 ns;
--        IO_data             <= x"55555555555555556666666666666666";   
--        wait for 20 ns;
--        IO_data             <= x"77777777777777778888888888888888";
--        wait for 20 ns;
--        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
--        wait for 20 ns;
--        IO_data             <= x"BBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCC";        
--        wait for 20 ns;
--        IO_data             <= x"DDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEE";
--        wait for 20 ns;
--        IO_data             <= x"FFFFFFFFFFFFFFFF0000000000000000";
--        FIFO_ready3         <= '1';       --***                         
--        wait for 20 ns;
--        IO_data             <= x"11111111111111112222222222222222";
--        wait for 20 ns;
--        IO_data             <= x"33333333333333334444444444444444";
--        wait for 20 ns;
--        IO_data             <= x"55555555555555556666666666666666";   
--        wait for 20 ns;
--        IO_data             <= x"77777777777777778888888888888888";
--        FIFO_ready3         <= '0';                                      
--        wait for 20 ns;
--        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
--        -------------------------------------------------------------------
--        -------------------------------------------------------------------
----        FIFO_ready2         <= '1';
----        wait for 100 ns;
--        wait for 20 ns;
----        FIFO_ready2         <= '0';
--        IO_data             <= x"AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB";        
--        wait for 20 ns;
--        IO_data             <= x"CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDD";   
--        wait for 20 ns;
--        IO_data             <= x"EEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFF";
--        wait for 20 ns;
--        IO_data             <= x"11111111111111112222222222222222";
--        wait for 20 ns;
--        IO_data             <= x"33333333333333334444444444444444";        
--        wait for 20 ns;
--        IO_data             <= x"55555555555555556666666666666666";   
--        wait for 20 ns;
--        IO_data             <= x"77777777777777778888888888888888";
--        wait for 20 ns;
--        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
--        wait for 20 ns;
--        IO_data             <= x"BBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCC";        
--        wait for 20 ns;
--        IO_data             <= x"DDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEE";
--        wait for 20 ns;
--        IO_data             <= x"FFFFFFFFFFFFFFFF0000000000000000";
--        FIFO_ready3         <= '1';       --***                         
--        wait for 20 ns;
--        IO_data             <= x"11111111111111112222222222222222";
--        wait for 20 ns;
--        IO_data             <= x"33333333333333334444444444444444";
--        wait for 20 ns;
--        IO_data             <= x"55555555555555556666666666666666";   
--        wait for 20 ns;
--        IO_data             <= x"77777777777777778888888888888888";
--        FIFO_ready3         <= '0';                                      
--        wait for 20 ns;
--        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
--        -------------------------------------------------------------------          
--        ------------------------------------------------------------------- 
----        FIFO_ready2         <= '1';
----        wait for 100 ns;
--        wait for 20 ns;
----        FIFO_ready2         <= '0';
--        IO_data             <= x"11111111111111111111111111111111";        
--        wait for 20 ns;
--        IO_data             <= x"22222222222222222222222222222222";   
--        wait for 20 ns;
--        IO_data             <= x"33333333333333333333333333333333";
--        wait for 20 ns;
--        IO_data             <= x"44444444444444444444444444444444";
--        wait for 20 ns;
--        IO_data             <= x"55555555555555555555555555555555";        
--        wait for 20 ns;
--        IO_data             <= x"66666666666666666666666666666666";   
--        wait for 20 ns;
--        IO_data             <= x"77777777777777777777777777777777";
--        wait for 20 ns;
--        IO_data             <= x"88888888888888888888888888888888";
--        wait for 20 ns;
--        IO_data             <= x"99999999999999999999999999999999";        
--        wait for 20 ns;
--        IO_data             <= x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";   
--        wait for 20 ns;
--        IO_data             <= x"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
--        wait for 20 ns;
--        IO_data             <= x"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC";
--        wait for 20 ns;
--        IO_data             <= x"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD";        
--        wait for 20 ns;
--        IO_data             <= x"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";   
--        wait for 20 ns;
--        IO_data             <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
--        wait for 20 ns;
--        IO_data             <= x"0123456789ABCDEF0123456789ABCDEF";
--        ------------------------------------------------------------------- 
--        FIFO_ready2         <= '0';                                                
--        wait for 300 ns;
--        ------------------------READ RM->MUX->EM---------------------------
--        Write_ack           <= '1';
--        wait for 100 ns;
--        Write_ack           <= '0'; 
--        wait for 220 ns;
--        FIFO_ready2         <= '1';
--        wait for 300 ns;
--        FIFO_ready3         <= '1';  --*****
--        wait for 40 ns;
--        FIFO_ready3         <= '0';       
--        wait for 260 ns;
--        FIFO_ready3         <= '1';  --*****
--        wait for 40 ns;
--        FIFO_ready3         <= '0';
--        wait for 280 ns;
--        FIFO_ready3         <= '1';  --*****
--        wait for 40 ns;
--        FIFO_ready3         <= '0';        
        --------------------------------------------------------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------------        
        --------------------------------------------EM->TP->RM  & RM->TP->EM----------------------------------------------------------------
        --------------------------------------------------------------------------------------------------------------------------------------
        -------------------------------------------------------------------------------------------------------------------------------------- 
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000400012";          
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 200 ns;        
        Write_ack           <= '1';
        wait for 100 ns;
        Write_ack           <= '0';
        ---------------------------------------------DATA IS READY IN FIFO
        wait for 380 ns;    ----Based on this wait time, fifo_ready can come when code line 49 or 4A is being executed. But when adding adapter FIFO this will be fixed.
        FIFO_ready2         <= '1';
        IO_data             <= x"11111111111111111111111111111111";        
        wait for 100 ns;
        FIFO_ready2         <= '0';   --***
        wait for 20 ns;
        IO_data             <= x"22222222222222222222222222222222";        
        wait for 20 ns;
        IO_data             <= x"33333333333333333333333333333333";
        wait for 20 ns;
        IO_data             <= x"44444444444444444444444444444444";
        wait for 20 ns;
        IO_data             <= x"55555555555555555555555555555555";        
        wait for 20 ns;
        IO_data             <= x"66666666666666666666666666666666";   
        wait for 20 ns;
        IO_data             <= x"77777777777777777777777777777777";
        wait for 20 ns;
        IO_data             <= x"88888888888888888888888888888888";
        wait for 20 ns;
        IO_data             <= x"99999999999999999999999999999999";        
        wait for 20 ns;
        IO_data             <= x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        wait for 20 ns;
        IO_data             <= x"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
        FIFO_ready3         <= '1';    --***    
        wait for 20 ns;
        IO_data             <= x"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC";
        wait for 20 ns;
        IO_data             <= x"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD";
        wait for 20 ns;
        IO_data             <= x"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";   
        wait for 20 ns;
        IO_data             <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        FIFO_ready3         <= '0';                        
        wait for 20 ns;
        IO_data             <= x"11223344556677889911223344556677";
        -------------------------------------------------------------------
--        FIFO_ready2         <= '1';
--        wait for 100 ns;
        wait for 20 ns;
--        FIFO_ready2         <= '0';
        IO_data             <= x"AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB";        
        wait for 20 ns;
        IO_data             <= x"CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDD";   
        wait for 20 ns;
        IO_data             <= x"EEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFF";
        wait for 20 ns;
        IO_data             <= x"11111111111111112222222222222222";
        wait for 20 ns;
        IO_data             <= x"33333333333333334444444444444444";        
        wait for 20 ns;
        IO_data             <= x"55555555555555556666666666666666";   
        wait for 20 ns;
        IO_data             <= x"77777777777777778888888888888888";
        wait for 20 ns;
        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
        wait for 20 ns;
        IO_data             <= x"BBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCC";        
        wait for 20 ns;
        IO_data             <= x"DDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEE";
        wait for 20 ns;
        IO_data             <= x"FFFFFFFFFFFFFFFF0000000000000000";
        FIFO_ready3         <= '1';       --***                         
        wait for 20 ns;
        IO_data             <= x"11111111111111112222222222222222";
        wait for 20 ns;
        IO_data             <= x"33333333333333334444444444444444";
        wait for 20 ns;
        IO_data             <= x"55555555555555556666666666666666";   
        wait for 20 ns;
        IO_data             <= x"77777777777777778888888888888888";
        FIFO_ready3         <= '0';                                      
        wait for 20 ns;
        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
        -------------------------------------------------------------------
        -------------------------------------------------------------------
--        FIFO_ready2         <= '1';
--        wait for 100 ns;
        wait for 20 ns;
--        FIFO_ready2         <= '0';
        IO_data             <= x"AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB";        
        wait for 20 ns;
        IO_data             <= x"CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDD";   
        wait for 20 ns;
        IO_data             <= x"EEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFF";
        wait for 20 ns;
        IO_data             <= x"11111111111111112222222222222222";
        wait for 20 ns;
        IO_data             <= x"33333333333333334444444444444444";        
        wait for 20 ns;
        IO_data             <= x"55555555555555556666666666666666";   
        wait for 20 ns;
        IO_data             <= x"77777777777777778888888888888888";
        wait for 20 ns;
        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
        wait for 20 ns;
        IO_data             <= x"BBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCC";        
        wait for 20 ns;
        IO_data             <= x"DDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEE";
        wait for 20 ns;
        IO_data             <= x"FFFFFFFFFFFFFFFF0000000000000000";
        FIFO_ready3         <= '1';       --***                         
        wait for 20 ns;
        IO_data             <= x"11111111111111112222222222222222";
        wait for 20 ns;
        IO_data             <= x"33333333333333334444444444444444";
        wait for 20 ns;
        IO_data             <= x"55555555555555556666666666666666";   
        wait for 20 ns;
        IO_data             <= x"77777777777777778888888888888888";
        FIFO_ready3         <= '0';                                      
        wait for 20 ns;
        IO_data             <= x"9999999999999999AAAAAAAAAAAAAAAA";
        -------------------------------------------------------------------          
        ------------------------------------------------------------------- 
--        FIFO_ready2         <= '1';
--        wait for 100 ns;
        wait for 20 ns;
--        FIFO_ready2         <= '0';
        IO_data             <= x"11111111111111111111111111111111";        
        wait for 20 ns;
        IO_data             <= x"22222222222222222222222222222222";   
        wait for 20 ns;
        IO_data             <= x"33333333333333333333333333333333";
        wait for 20 ns;
        IO_data             <= x"44444444444444444444444444444444";
        wait for 20 ns;
        IO_data             <= x"55555555555555555555555555555555";        
        wait for 20 ns;
        IO_data             <= x"66666666666666666666666666666666";   
        wait for 20 ns;
        IO_data             <= x"77777777777777777777777777777777";
        wait for 20 ns;
        IO_data             <= x"88888888888888888888888888888888";
        wait for 20 ns;
        IO_data             <= x"99999999999999999999999999999999";        
        wait for 20 ns;
        IO_data             <= x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";   
        wait for 20 ns;
        IO_data             <= x"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
        wait for 20 ns;
        IO_data             <= x"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC";
        wait for 20 ns;
        IO_data             <= x"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD";        
        wait for 20 ns;
        IO_data             <= x"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";   
        wait for 20 ns;
        IO_data             <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        wait for 20 ns;
        IO_data             <= x"0123456789ABCDEF0123456789ABCDEF";
        ------------------------------------------------------------------- 
        FIFO_ready2         <= '0';                                                
        wait for 300 ns;
        ------------------------READ RM->MUX->EM---------------------------
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"0000000000000000000000000040001C";          
        wait for 200 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 200 ns;        
                
        Write_ack           <= '1';
        wait for 300 ns;
        Write_ack           <= '0'; 
        wait for 220 ns;
        FIFO_ready2         <= '1';
        wait for 300 ns;
        FIFO_ready3         <= '1';  --*****
        wait for 40 ns;
        FIFO_ready3         <= '0';       
        wait for 280 ns;
        FIFO_ready3         <= '1';  --*****
        wait for 40 ns;
        FIFO_ready3         <= '0';
        wait for 280 ns;
        FIFO_ready3         <= '1';  --*****
        wait for 40 ns;
        FIFO_ready3         <= '0';  
        -------------------------------------------------------------------
        -------------------------------------------------------------------
        -------------------------------------------------------------------                                                                          
        wait for 1000000ns;        
    end process;
   
    process
    begin
        clk <= '0';
        for i in 1 to 30000000 loop
            wait for 10ns;
            clk <= not clk;
        end loop;
        wait;
    end process;

end Behavioral;
