----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2021 15:16:01
-- Design Name: 
-- Module Name: Noc_tb - Behavioral
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

entity Noc_tb is
--  Port ( );
end Noc_tb;

architecture Behavioral of Noc_tb is

    component Noc_Top is
        port(
        clk                 : in    std_logic;
        Gated_clk_from_PEC  : in    std_logic;
        Reset               : in    std_logic;
        PEC_ready           : in    std_logic; --state machine
        PCIe_ack            : in    std_logic; --state machine 1.29
        PCIe_ready          : in    std_logic; --state machine 1.29
        CMD_flag            : in    std_logic; --command decoder
        --En_Noc_Transfer     : out   std_logic;
        PCIe_data           : in    std_logic_vector(255 downto 0); -- pcie data is 32 byte
        NOC_bus_In          : in    std_logic_vector(15 downto 0);
        NOC_bus_Out         : out   std_logic_vector(15 downto 0);        
        Noc_data            : out   std_logic_vector(255 downto 0);
        PCIe_length         : out   std_logic_vector(4 downto 0); 
        PCIe_address        : out   std_logic_vector(31 downto 0); --Q 32 in command decoder 24 in PBdoc?
        NOC_bus_dir         : out   std_logic;      
        PCIe_req            : out   std_logic; 
        Noc_CMD_flag        : out   std_logic;
        En_PCIe_ctrl        : out   std_logic; 
        En_PCIe_Data        : out   std_logic;
        Tag_Line            : out   std_logic;
        --TEST
        Address_Counter_t   : out std_logic_vector(7 downto 0);
        Load_AS_Counter_t   : out std_logic;
        Enable_AS_Counter_t : out std_logic;
        Program_Mem_Out_T   : out std_logic_vector(23 downto 0);
        Load_Mode_Reg_T     : out std_logic;
        Mode_Reg_T          : out std_logic_vector(7 downto 0);
        AS_Counter_Mux_T    : out std_logic_vector(7 downto 0);
        Loop_Counter_T      : out std_logic_vector(19 downto 0);
        Loop_Register_T     : out std_logic_vector(19 downto 0);
        Transfer_Counter_T  : out std_logic_vector(15 downto 0);
        TC_Equal_Zero_T     : out std_logic;
        LC_Equal_LR_T       : out std_logic;
        Control_Data_Out_t : out std_logic_vector(7 downto 0);
        Loop_Mux_t         : out std_logic_vector(19 downto 0);
        Step_MDC_t         : out std_logic;
        MDC_t              : out integer;
        Load_MD_Reg_t      : out std_logic;
        CM_Flag_Latch_t    : out std_logic;
        Load_Tag_Shift_Counter_t : out std_logic;
        Start_TAG_Shift_t   : out std_logic;
        Tag_shift_t         : out std_logic;
        Noc_reg_DataOut_t   : out std_logic_vector(255 downto 0);
        NoC_Input_reg_Out_t : out std_logic_vector(15 downto 0);
        Load_NOC_reg_t      : out std_logic;
        RM_Address_t        : out std_logic_vector(12 downto 0);
        En_RM_t             : out std_logic;
        RM_DataOut_t        : out std_logic_vector(15 downto 0);
        Noc_reg_mux_data_t  : out std_logic_vector(255 downto 0); 
        Noc_reg_DataIn_t    : out std_logic_vector(255 downto 0);
        RM_Read_mem_enable_t: out std_logic;
        MD_reg_t            : out std_logic_vector(255 downto 0);
        Step_LC_t           : out std_logic;
        decoder_t           : out std_logic_vector(31 downto 0);
        Cond_Wait_t         : out std_logic;
        Wait_condition_Mux_t: out std_logic;
        R_W_RM_t            : out std_logic
        );
    end component;
    
    signal clk                 : std_logic;
    signal Gated_clk_from_PEC  : std_logic;
    signal Reset               : std_logic;
    signal PEC_ready           : std_logic;
    signal CMD_flag            : std_logic; 
    signal PCIe_ack            : std_logic; 
    signal PCIe_ready          : std_logic;
    signal PCIe_data           : std_logic_vector(255 downto 0); 
    signal NOC_bus_In          : std_logic_vector(15 downto 0);
    signal NOC_bus_Out         : std_logic_vector(15 downto 0);      
    signal NOC_bus_dir         : std_logic;      
    signal PCIe_req            : std_logic;
    signal Noc_CMD_flag        : std_logic;
    signal PCIe_length         : std_logic_vector(4 downto 0); 
    signal PCIe_address        : std_logic_vector(31 downto 0); --Q 32 in command decoder 24 in PBdoc?
    signal Noc_data            : std_logic_vector(255 downto 0);
    signal En_PCIe_ctrl        : std_logic; 
    signal En_PCIe_Data        : std_logic;
    signal Tag_Line            : std_logic;
    signal  Address_Counter_t           : std_logic_vector(7 downto 0);
    signal  Load_AS_Counter_t           : std_logic;
    signal  Enable_AS_Counter_t         : std_logic;
    signal  Program_Mem_Out_T           : std_logic_vector(23 downto 0);
    signal  Load_Mode_Reg_T             : std_logic;
    signal  Mode_Reg_T                  : std_logic_vector(7 downto 0);
    signal  AS_Counter_Mux_T            : std_logic_vector(7 downto 0);
    signal  Loop_Counter_T              : std_logic_vector(19 downto 0);
    signal  Loop_Register_T             : std_logic_vector(19 downto 0);
    signal  Transfer_Counter_T          : std_logic_vector(15 downto 0);
    signal  TC_Equal_Zero_T             : std_logic;
    signal  LC_Equal_LR_T               : std_logic;
    signal  Control_Data_Out_t          : std_logic_vector(7 downto 0);
    signal  Loop_Mux_t                  : std_logic_vector(19 downto 0);
    signal  Step_MDC_t                  : std_logic;
    signal  MDC_t                       : integer;
    signal  Load_MD_Reg_t               : std_logic;
    signal  CM_Flag_Latch_t             : std_logic;
    signal  Load_Tag_Shift_Counter_t    : std_logic;
    signal  Start_TAG_Shift_t           : std_logic;
    signal  Tag_shift_t                 : std_logic;
    signal  Noc_reg_DataOut_t           : std_logic_vector(255 downto 0);
    signal  NoC_Input_reg_Out_t         : std_logic_vector(15 downto 0);
    signal  Load_NOC_reg_t              : std_logic;
    signal  RM_Address_t                : std_logic_vector(12 downto 0);
    signal  En_RM_t                     : std_logic;
    signal  RM_DataOut_t                : std_logic_vector(15 downto 0);
    signal  Noc_reg_mux_data_t          : std_logic_vector(255 downto 0); 
    signal  Noc_reg_DataIn_t            : std_logic_vector(255 downto 0);
    signal  RM_Read_mem_enable_t        : std_logic;
    signal  MD_reg_t                    : std_logic_vector(255 downto 0);
    signal  Step_LC_t                   : std_logic;
    signal  decoder_t                   : std_logic_vector(31 downto 0);
    signal  Cond_Wait_t                 : std_logic;
    signal  Wait_condition_Mux_t        : std_logic;
    signal  R_W_RM_t                    : std_logic;



begin

    UUT: Noc_Top port map (clk => clk, Gated_CLK_from_PEC => Gated_CLK_from_PEC,Reset => Reset,PEC_ready =>PEC_ready,CMD_flag => CMD_flag,PCIe_ack => PCIe_ack,PCIe_ready => PCIe_ready,
    PCIe_data => PCIe_data,NOC_bus_In => NOC_bus_In,NOC_bus_Out=>NOC_bus_Out,NOC_bus_dir => NOC_bus_dir,PCIe_req => PCIe_req,Noc_CMD_flag=>Noc_CMD_flag,PCIe_length => PCIe_length,
    PCIe_address => PCIe_address,Noc_data => Noc_data,En_PCIe_ctrl => En_PCIe_ctrl,En_PCIe_Data => En_PCIe_Data,Tag_Line => Tag_Line,Address_Counter_t=>Address_Counter_t,Load_AS_Counter_t=>
    Load_AS_Counter_t,Enable_AS_Counter_t=>Enable_AS_Counter_t,Program_Mem_Out_T=>Program_Mem_Out_T,Load_Mode_Reg_T=>Load_Mode_Reg_T,Mode_Reg_T=>Mode_Reg_T,AS_Counter_Mux_T=>AS_Counter_Mux_T,
    Loop_Counter_T=>Loop_Counter_T,Loop_Register_T=>Loop_Register_T,Transfer_Counter_T=>Transfer_Counter_T,TC_Equal_Zero_T=>TC_Equal_Zero_T,LC_Equal_LR_T=>LC_Equal_LR_T,Control_Data_Out_t=>Control_Data_Out_t,
    Loop_Mux_t=>Loop_Mux_t,Step_MDC_t=>Step_MDC_t,MDC_t=>MDC_t,Load_MD_Reg_t=>Load_MD_Reg_t,CM_Flag_Latch_t=>CM_Flag_Latch_t,Load_Tag_Shift_Counter_t=>Load_Tag_Shift_Counter_t,Start_TAG_Shift_t=>Start_TAG_Shift_t,
    Tag_shift_t=>Tag_shift_t,Noc_reg_DataOut_t=>Noc_reg_DataOut_t,NoC_Input_reg_Out_t=>NoC_Input_reg_Out_t,Load_NOC_reg_t=>Load_NOC_reg_t,RM_Address_t=>RM_Address_t,En_RM_t=>En_RM_t,RM_DataOut_t=>RM_DataOut_t,
    Noc_reg_mux_data_t=>Noc_reg_mux_data_t,Noc_reg_DataIn_t=>Noc_reg_DataIn_t,RM_Read_mem_enable_t=>RM_Read_mem_enable_t,MD_reg_t=>MD_reg_t,Step_LC_t=>Step_LC_t,decoder_t=>decoder_t,Cond_Wait_t=>Cond_Wait_t,Wait_condition_Mux_t=>Wait_condition_Mux_t,R_W_RM_t=>R_W_RM_t); 
    
    --DDR->CM unicast USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_ack            <= '0';
            PCIe_ready          <= '0';
            PCIe_data           <= (others => '0');
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000010100"; --opcode 14 hex DDR->CM unicast and TS= 1 bit 16 th    TS=3  bit 16,17 th                                                                                                                                                                                                                                                                               
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 320 ns; 
            PCIe_ready          <= '1';
            wait for 80 ns;
            PCIe_data           <= x"A0B0C0D0E0F0A1B1C1D1E1F1A2B2C2D2E2F2A3B3C3D3E3F3A4B4C4D4E4F4A5B5";                                                                                                                                                                                                                                                                               
            wait for 1300 ns;
            PCIe_data           <= x"A0B0C0D0E0F0A1B1C1D1E1F1A2B2C2D2E2F2A3B3C3D3E3F3A4B4C4D4E4F4A5B5";                                                                                                                                                                                                                                                                                           
            wait for 3400 ns; 
            wait;
    end process;
    
    --DDR->CM broadcast USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_ack            <= '0';
            PCIe_ready          <= '0';
            PCIe_data           <= (others => '0');
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100001000000010110"; --opcode 14 hex DDR->CM broadcast and TS= 1 bit 16 th    TS=3  bit 16,17 th    bit12=1 broadcast switch settings                                                                                                                                                                                                                                                                 
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 320 ns; 
            PCIe_ready          <= '1';
            PCIe_data           <= x"A0B0C0D0E0F0A1B1C1D1E1F1A2B2C2D2E2F2A3B3C3D3E3F3A4B4C4D4E4F4A5B5";                                                                                                                                                                                                                                                                               
            wait for 1380 ns;
            PCIe_ack            <= '1';       
            wait for 3200 ns; 
            wait;
    end process; 

    --CM ->EM USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_ack            <= '0';
            PCIe_ready          <= '0';
            PCIe_data           <= (others => '0');
            NOC_bus_In          <= (others => '0');
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000100100"; --opcode 24 hex CM->EM broadcast and TS= 1 bit 16 th    TS=3  bit 16,17 th                                                                                                                                                                                                                                                                   
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 200 ns;
            PCIe_ack            <= '1';
            wait for 100 ns;
            PCIe_ack            <= '0';
            wait for 120 ns;
            NOC_bus_In          <= x"0100";
            wait for 20 ns;
            NOC_bus_In          <= x"0201";  
            wait for 20 ns;
            NOC_bus_In          <= x"0403";
            wait for 20 ns;
            NOC_bus_In          <= x"0605"; 
            wait for 20 ns;
            NOC_bus_In          <= x"0807";  
            wait for 20 ns;
            NOC_bus_In          <= x"0A09";
            wait for 20 ns;
            NOC_bus_In          <= x"0C0B"; 
            wait for 20 ns;
            NOC_bus_In          <= x"0E0D"; 
            wait for 20 ns;
            NOC_bus_In          <= x"000F";
            wait for 20 ns;
            NOC_bus_In          <= x"1211"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1413";
            wait for 20 ns;
            NOC_bus_In          <= x"1615"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1817"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1A19"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1C1B"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1E1D"; 
            wait for 20 ns;
            NOC_bus_In          <= x"201F"; 
            wait for 20 ns;
            NOC_bus_In          <= x"2221";  
            wait for 20 ns;
            NOC_bus_In          <= x"2423";
            wait for 20 ns;
            NOC_bus_In          <= x"2625"; 
            wait for 20 ns;
            NOC_bus_In          <= x"2827"; 
            wait for 20 ns;
            NOC_bus_In          <= x"2A29"; 
            wait for 20 ns;
            NOC_bus_In          <= x"2C2B"; 
            wait for 20 ns;
            NOC_bus_In          <= x"2E2D";                                                                                                                       
            wait for 4800 ns;
            wait;
    end process;
    
    --CM -> RM USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_data           <= (others => '0');
            NOC_bus_In          <= (others => '0');
            PCIe_ack            <= '0';
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000101000"; --opcode 14 hex DDR->CM broadcast and (TS= 1 bit 17 th TS=3  bit 17,18 th)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 340 ns; 
            NOC_bus_In          <= x"0100";
            wait for 20 ns;
            NOC_bus_In          <= x"0201";  
            wait for 20 ns;
            NOC_bus_In          <= x"0403";
            wait for 20 ns;
            NOC_bus_In          <= x"0605"; 
            wait for 20 ns;
            NOC_bus_In          <= x"0807";  
            wait for 20 ns;
            NOC_bus_In          <= x"0A09";
            wait for 20 ns;
            NOC_bus_In          <= x"0C0B"; 
            wait for 20 ns;
            NOC_bus_In          <= x"0E0D"; 
            wait for 20 ns;
            NOC_bus_In          <= x"000F";
            wait for 20 ns;
            NOC_bus_In          <= x"1211"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1413";
            wait for 20 ns;
            NOC_bus_In          <= x"1615"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1817"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1A19"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1C1B"; 
            wait for 20 ns;
            NOC_bus_In          <= x"1E1D";
            wait for 20 ns;
            NOC_bus_In          <= x"1F1F"; 
            wait for 20 ns;            
            NOC_bus_In          <= x"0100";
            wait for 20 ns;
            NOC_bus_In          <= x"0201";  
            wait for 20 ns;
            NOC_bus_In          <= x"0403";
            wait for 20 ns;
            NOC_bus_In          <= x"0605"; 
            wait for 20 ns;
            NOC_bus_In          <= x"0807";              
            wait for 1020 ns;
            PCIe_ack            <= '1';
            wait for 9600 ns;
            wait for 3400 ns; 
            wait;
    end process; 

    --RM ->CM UNICAST USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_data           <= (others => '0');
            NOC_bus_In          <= (others => '0');
            PCIe_ack            <= '0';
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000010000000000011110"; --opcode 1E hex RM >CM unicast and (TS= 1 bit 17 th TS=3  bit 17,18 th) and bit34 is 1 it means RM address = 2
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 620 ns; 
            wait for 1020 ns;
            PCIe_ack            <= '1';
            wait for 9600 ns;
            wait for 3400 ns; 
            wait;
    end process; 
    
    --RM ->CM BROADCAST USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_data           <= (others => '0');
            NOC_bus_In          <= (others => '0');
            PCIe_ack            <= '0';
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000010000000000100000"; --opcode 20 hex RM >CM broadcast and (TS= 1 bit 17 th TS=3  bit 17,18 th) and bit33 is 1 it means RM address = 1
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 620 ns; 
            wait for 1020 ns;
            PCIe_ack            <= '1';
            wait for 9600 ns;
            wait for 3800 ns; 
            wait;
    end process; 

    --RM ->EM USE CASE
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_data           <= (others => '0');
            NOC_bus_In          <= (others => '0');
            PCIe_ack            <= '0';
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000010000000000011010"; --opcode 1A hex RM ->EM and (TS= 1 bit 17 th TS=3  bit 17,18 th) and bit34 is 1 it means RM address = 2
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 300 ns; 
            PCIe_ack            <= '1';
            wait for 10600 ns;
            wait for 3400 ns;
            wait;
    end process;

    --DDR->RM  NEED TO EDIT
    process
    begin
            Reset               <= '1';
            PEC_Ready           <= '0';
            CMD_Flag            <= '0';
            PCIe_ack            <= '0';
            PCIe_ready          <= '0';
            PCIe_data           <= (others => '0');
            wait for 20 ns; 
            Reset               <= '0';
            wait for 30 ns;  
            wait for 40 ns;  
            PCIe_data           <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000010000"; --opcode 10 hex DDR->RM and TS= 1 bit 16 th    TS=3  bit 16,17 th                                                                                                                                                                                                                                                                               
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            wait for 100 ns;
            CMD_FLAG            <= '0';
            wait for 320 ns; 
            PCIe_ready          <= '1';
            wait for 80 ns;
            PCIe_data           <= x"A0B0C0D0E0F0A1B1C1D1E1F1A2B2C2D2E2F2A3B3C3D3E3F3A4B4C4D4E4F4A5B5"; 
            wait for 700 ns; 
            PCIe_ack            <= '1';
            wait for 600 ns;
            wait for 3900 ns; 
            wait;
    end process;
    
 
    process
    begin
        clk <= '0';
        for i in 1 to 3000 loop
            wait for 10ns;
            clk <= not clk;
        end loop;
        wait;
    end process;
    
    process
    begin
        Gated_CLK_from_PEC <= '0';
        for i in 1 to 3000 loop
            wait for 9ns;
            Gated_CLK_from_PEC <= not Gated_CLK_from_PEC;
            wait for 1ns;
        end loop;
        wait;
    end process;

end Behavioral;
