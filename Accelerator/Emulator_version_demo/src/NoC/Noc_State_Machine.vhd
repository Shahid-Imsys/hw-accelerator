-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : Noc state machine
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Noc_State_Machine.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.24
-------------------------------------------------------------------------------
-- Description: -- Noc State Machine
-------------------------------------------------------------------------------
-- TO-DO list :             
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-24 		     1.0	     AK			Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
            

entity Noc_State_Machine is
    port(
        clk                     : in  std_logic;
        Gated_CLK_from_PEC      : in  std_logic;
        Reset                   : in  std_logic;
        TAG_shift               : in  std_logic;                        --Tag control 
        TS                      : in  std_logic_vector(15 downto 0);    -- from command decoder
        PEC_Ready               : in  std_logic;                        -- from command decoder 
        PCIe_ack                : in  std_logic;
        PCIe_ready              : in  std_logic; 
        CMD_FF                  : in  std_logic;                        -- from command decoder 
        Opcode                  : in  std_logic_vector(11 downto 0);    -- from command decoder  New changes in Noc 01/05  
        BC                      : in  std_logic_vector(4 downto 0);     -- from Byte counter 
        Load_RM_as_gen          : out std_logic;  
        Load_NOC_Reg            : out std_logic;  
        Load_PEC_Reg            : out std_logic;  
        Load_PCIe_CMD_Reg       : out std_logic;  
        Load_Req_reg            : out std_logic; 
        En_PCIe_ctrl            : out std_logic;
        En_PCIe_Data            : out std_logic;
        Load_CMD_Reg            : out std_logic;
        Set_PEC_FF2             : out std_logic;
        Reset_MDC               : out std_logic;
        Load_MD_Reg             : out std_logic;
        Step_MDC                : out std_logic;
        En_NOC_Transfer         : out std_logic;
        En_RM                   : out std_logic;                        --root memory
        R_W_RM                  : out std_logic;                        --root memory
        R_W_PCIe                : out std_logic;                        --ext memory
        Start_Tag_Shift         : out std_logic;                        --Tag Line Controller 
        Load_Tag_Shift_Counter  : out std_logic;                        --Tag Line Controller 
        Step_BC                 : out std_logic;  
        Reset_BC                : out std_logic;        
        Load_Mux_Reg            : out std_logic; 
        Control_Data_Out        : out std_logic_vector(7 downto 0);
        --test
        h2c_cmd_t               : in  std_logic;
        c2h_cmd_t               : in  std_logic;
        pcie_wr_data_wrs_t      : in  std_logic;
        pcie_wr_ctl_wrs_t       : in  std_logic;
        CMD_flag_t              : in  std_logic;
        Noc_CMD_flag_t          : in  std_logic;
        PCIe_req_t              : in  std_logic;
        Address_Counter_t       : out std_logic_vector(7 downto 0)
        );
end Noc_State_Machine;

architecture Behavioral of Noc_State_Machine is

    component blk_mem_gen_1
    port(
        clka :  in  std_logic;
        ena :   in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(23 downto 0)
     );
    end component;
    
    -- component ila_2
    -- port(
        -- clk     : in  std_logic;
        -- probe0  : in std_logic_vector(0 downto 0); 
        -- probe1  : in std_logic_vector(0 downto 0); 
        -- probe2  : in std_logic_vector(7 downto 0); 
        -- probe3  : in std_logic_vector(7 downto 0); 
        -- probe4  : in std_logic_vector(0 downto 0); 
        -- probe5  : in std_logic_vector(0 downto 0); 
        -- probe6  : in std_logic_vector(0 downto 0); 
        -- probe7  : in std_logic_vector(0 downto 0); 
        -- probe8  : in std_logic_vector(0 downto 0); 
        -- probe9  : in std_logic_vector(0 downto 0); 
        -- probe10 : in std_logic_vector(0 downto 0); 
        -- probe11 : in std_logic_vector(0 downto 0); 
        -- probe12 : in std_logic_vector(7 downto 0); 
        -- probe13 : in std_logic_vector(0 downto 0); 
        -- probe14 : in std_logic_vector(23 downto 0); 
        -- probe15 : in std_logic_vector(0 downto 0); 
        -- probe16 : in std_logic_vector(7 downto 0); 
        -- probe17 : in std_logic_vector(7 downto 0); 
        -- probe18 : in std_logic_vector(19 downto 0); 
        -- probe19 : in std_logic_vector(19 downto 0); 
        -- probe20 : in std_logic_vector(15 downto 0); 
        -- probe21 : in std_logic_vector(0 downto 0); 
        -- probe22 : in std_logic_vector(0 downto 0); 
        -- probe23 : in std_logic_vector(19 downto 0); 
        -- probe24 : in std_logic_vector(0 downto 0);
        -- probe25 : in std_logic_vector(0 downto 0); 
        -- probe26 : in std_logic_vector(0 downto 0); 
        -- probe27 : in std_logic_vector(0 downto 0); 
        -- probe28 : in std_logic_vector(0 downto 0); 
        -- probe29 : in std_logic_vector(0 downto 0); 
        -- probe30 : in std_logic_vector(0 downto 0); 
        -- probe31 : in std_logic_vector(0 downto 0); 
        -- probe32 : in std_logic_vector(8 downto 0); 
        -- probe33 : in std_logic_vector(2 downto 0); 
        -- probe34 : in std_logic_vector(0 downto 0); 
        -- probe35 : in std_logic_vector(0 downto 0); 
        -- probe36 : in std_logic_vector(0 downto 0); 
        -- probe37 : in std_logic_vector(0 downto 0); 
        -- probe38 : in std_logic_vector(0 downto 0);
        -- probe39 : in std_logic_vector(0 downto 0);
        -- probe40 : in std_logic_vector(0 downto 0);
        -- probe41 : in std_logic_vector(0 downto 0);
        -- probe42 : in std_logic_vector(0 downto 0);
        -- probe43 : in std_logic_vector(0 downto 0);
        -- probe44 : in std_logic_vector(0 downto 0);
        -- probe45 : in std_logic_vector(0 downto 0);
        -- probe46 : in std_logic_vector(0 downto 0);
        -- probe47 : in std_logic_vector(0 downto 0);
        -- probe48 : in std_logic_vector(0 downto 0);
        -- probe49 : in std_logic_vector(0 downto 0);
        -- probe50 : in std_logic_vector(0 downto 0);
        -- probe51 : in std_logic_vector(0 downto 0);
        -- probe52 : in std_logic_vector(0 downto 0);
        -- probe53 : in std_logic_vector(0 downto 0);
        -- probe54 : in std_logic_vector(0 downto 0);
        -- probe55 : in std_logic_vector(0 downto 0);
        -- probe56 : in std_logic_vector(0 downto 0);
        -- probe57 : in std_logic_vector(0 downto 0);
        -- probe58 : in std_logic_vector(11 downto 0);
        -- probe59 : in std_logic_vector(4 downto 0);
        -- probe60 : in std_logic_vector(15 downto 0)
    -- );
    -- end component;

    signal  Load_Mode_Reg           : std_logic;
    signal  Reset_LC                : std_logic;   
    signal  Step_LC                 : std_logic;  
    signal  Control_Data            : std_logic_vector(7 downto 0); 
    signal  TSx16                   : std_logic_vector(19 downto 0); 
    signal  Load_LR                 : std_logic;
    signal  Load_TC                 : std_logic; 
    signal  Decr_TC                 : std_logic;
    signal  Reset_CM_Flag           : std_logic;
    signal  Loop_Counter            : std_logic_vector(19 downto 0); 
    signal  Loop_Register           : std_logic_vector(19 downto 0);
    signal  Transfer_Counter        : std_logic_vector(15 downto 0);
    signal  Return_Reg1             : std_logic_vector(7 downto 0);
    signal  Return_Reg2             : std_logic_vector(7 downto 0);
    signal  Mode_Reg                : std_logic_vector(7 downto 0);
    signal  Load_Return_Reg1        : std_logic;  
    signal  Load_Return_Reg2        : std_logic;  
    signal  Loop_Mux                : std_logic_vector(19 downto 0);
    signal  CM_Flag_Latch           : std_logic;    
    signal  TC_Equal_Zero           : std_logic;    
    signal  Jump_condition_Mux      : std_logic;   
    signal  Wait_condition_Mux      : std_logic;  
    signal  AS_Counter_Mux          : std_logic_vector(7 downto 0); 
    signal  Program_Mem_Out         : std_logic_vector(23 downto 0);
    signal  Load_AS_Counter         : std_logic;
    signal  Enable_AS_Counter       : std_logic;
    signal  Address_Counter         : std_logic_vector(7 downto 0); 
    signal  Cond_Jump               : std_logic; 
    signal  UnCond_Jump             : std_logic;
    signal  Cond_Wait               : std_logic; 
    signal  Decoder1                : std_logic_vector(8 downto 0);    
    signal  Decoder2                : std_logic_vector(2 downto 0);
    signal  Reg_Area1               : std_logic_vector(6 downto 0);
    signal  Reg_Area2               : std_logic_vector(6 downto 0);
    signal  Reg_Area3               : std_logic_vector(6 downto 0);
    signal  LC_Equal_LR             : std_logic;
    signal  Mem_Out                 : std_logic_vector(23 downto 0);
    signal  Mux1,Mux2               : std_logic_vector(7 downto 0);
    signal  LC_Equal_LR_latch       : std_logic; 
    signal  LC_Equal_LR_extend      : std_logic;
    --internal signals
	signal  En_PCIe_Data_i          : std_logic;
	signal  Load_CMD_Reg_i          : std_logic;
	signal  Reset_MDC_i             : std_logic;
	signal  Reset_LC_i              : std_logic;
	signal  Reset_BC_i              : std_logic;
	signal  Step_MDC_i              : std_logic;
	signal  Load_MD_Reg_i           : std_logic;
	signal  Load_Tag_Shift_Counter_i: std_logic;
	signal  Start_TAG_Shift_i       : std_logic;
	signal  Load_NOC_reg_i          : std_logic;
	signal  Load_RM_as_gen_i        : std_logic;
	signal  Load_PEC_Reg_i          : std_logic;
	signal  Load_PCIe_CMD_Reg_i     : std_logic;
	signal  Load_Req_reg_i          : std_logic;
	signal  En_PCIe_ctrl_i          : std_logic;
	signal  Set_PEC_FF2_i           : std_logic;
	signal  En_NOC_Transfer_i       : std_logic;
	signal  En_RM_i                 : std_logic;
	signal  R_W_RM_i                : std_logic;
	signal  R_W_PCIe_i              : std_logic;
	signal  Step_BC_i               : std_logic;
	signal  Load_Mux_Reg_i          : std_logic;
	signal  Shift_TC_i              : std_logic;
	signal  TS_odd                  : std_logic_vector(15 downto 0);          
    -- ILA SIGNALS
    -- signal probe0_i  : std_logic_vector(0 downto 0); 
	-- signal probe1_i  : std_logic_vector(0 downto 0); 
	-- signal probe2_i  : std_logic_vector(7 downto 0); 
	-- signal probe3_i  : std_logic_vector(7 downto 0); 
	-- signal probe4_i  : std_logic_vector(0 downto 0); 
	-- signal probe5_i  : std_logic_vector(0 downto 0); 
	-- signal probe6_i  : std_logic_vector(0 downto 0); 
	-- signal probe7_i  : std_logic_vector(0 downto 0); 
	-- signal probe8_i  : std_logic_vector(0 downto 0); 
	-- signal probe9_i  : std_logic_vector(0 downto 0); 
	-- signal probe10_i : std_logic_vector(0 downto 0); 
	-- signal probe11_i : std_logic_vector(0 downto 0); 
	-- signal probe12_i : std_logic_vector(7 downto 0); 
	-- signal probe13_i : std_logic_vector(0 downto 0); 
	-- signal probe14_i : std_logic_vector(23 downto 0); 
	-- signal probe15_i : std_logic_vector(0 downto 0); 
	-- signal probe16_i : std_logic_vector(7 downto 0); 
	-- signal probe17_i : std_logic_vector(7 downto 0); 
	-- signal probe18_i : std_logic_vector(19 downto 0); 
	-- signal probe19_i : std_logic_vector(19 downto 0); 
	-- signal probe20_i : std_logic_vector(15 downto 0); 
	-- signal probe21_i : std_logic_vector(0 downto 0); 
	-- signal probe22_i : std_logic_vector(0 downto 0); 
	-- signal probe23_i : std_logic_vector(19 downto 0); 
	-- signal probe24_i : std_logic_vector(0 downto 0); 
	-- signal probe25_i : std_logic_vector(0 downto 0); 
	-- signal probe26_i : std_logic_vector(0 downto 0); 
	-- signal probe27_i : std_logic_vector(0 downto 0); 
	-- signal probe28_i : std_logic_vector(0 downto 0); 
	-- signal probe29_i : std_logic_vector(0 downto 0); 
	-- signal probe30_i : std_logic_vector(0 downto 0); 
	-- signal probe31_i : std_logic_vector(0 downto 0); 
	-- signal probe32_i : std_logic_vector(8 downto 0); 
	-- signal probe33_i : std_logic_vector(2 downto 0); 
	-- signal probe34_i : std_logic_vector(0 downto 0); 
	-- signal probe35_i : std_logic_vector(0 downto 0); 
	-- signal probe36_i : std_logic_vector(0 downto 0); 
	-- signal probe37_i : std_logic_vector(0 downto 0); 
	-- signal probe38_i : std_logic_vector(0 downto 0);
	-- signal probe39_i : std_logic_vector(0 downto 0);
    -- signal probe40_i : std_logic_vector(0 downto 0);
    -- signal probe41_i : std_logic_vector(0 downto 0);
    -- signal probe42_i : std_logic_vector(0 downto 0);
    -- signal probe43_i : std_logic_vector(0 downto 0);
    -- signal probe44_i : std_logic_vector(0 downto 0);
    -- signal probe45_i : std_logic_vector(0 downto 0);
    -- signal probe46_i : std_logic_vector(0 downto 0);
    -- signal probe47_i : std_logic_vector(0 downto 0);
    -- signal probe48_i : std_logic_vector(0 downto 0);
    -- signal probe49_i : std_logic_vector(0 downto 0);
    -- signal probe50_i : std_logic_vector(0 downto 0);
    -- signal probe51_i : std_logic_vector(0 downto 0);
    -- signal probe52_i : std_logic_vector(0 downto 0);
    -- signal probe53_i : std_logic_vector(0 downto 0);
    -- signal probe54_i : std_logic_vector(0 downto 0);
    -- signal probe55_i : std_logic_vector(0 downto 0);
    -- signal probe56_i : std_logic_vector(0 downto 0);
    -- signal probe57_i : std_logic_vector(0 downto 0);
    -- signal probe58_i : std_logic_vector(11 downto 0);
    -- signal probe59_i : std_logic_vector(4 downto 0);
    -- signal probe60_i : std_logic_vector(15 downto 0);

begin

    En_PCIe_Data          <= En_PCIe_Data_i;
    Load_CMD_Reg          <= Load_CMD_Reg_i;
    Reset_MDC             <= Reset_MDC_i;
    Reset_LC              <= Reset_LC_i;
    Reset_BC              <= Reset_BC_i;
    Step_MDC              <= Step_MDC_i;
    Load_MD_Reg           <= Load_MD_Reg_i;
    Load_Tag_Shift_Counter<= Load_Tag_Shift_Counter_i;
    Start_TAG_Shift       <= Start_TAG_Shift_i;
    Load_NOC_reg          <= Load_NOC_reg_i;
    Load_RM_as_gen        <= Load_RM_as_gen_i;
    Load_PEC_Reg          <= Load_PEC_Reg_i;
    Load_PCIe_CMD_Reg     <= Load_PCIe_CMD_Reg_i;
    Load_Req_reg          <= Load_Req_reg_i;
    En_PCIe_ctrl          <= En_PCIe_ctrl_i;
    Set_PEC_FF2           <= Set_PEC_FF2_i;
    En_NOC_Transfer       <= En_NOC_Transfer_i;
    En_RM                 <= En_RM_i;
    R_W_RM                <= R_W_RM_i;
    R_W_PCIe              <= R_W_PCIe_i;
    Step_BC               <= Step_BC_i;
    Load_Mux_Reg          <= Load_Mux_Reg_i;
    
    Address_Counter_t     <= Address_Counter;

    Program_Memory : blk_mem_gen_1
    port map 
    (
        clka => clk,
        ena => '1',
        addra => Address_Counter, 
        douta => Program_Mem_Out
    );

    Mem_Out                     <= Program_Mem_Out;
    TSx16                       <= Transfer_Counter & "0000"; --TC_Mux & "0000";     --TS & "0000";
    Loop_Mux                    <= x"000" & Control_Data  when Mode_Reg(6)= '0' else (TSx16);
    Jump_condition_Mux          <= CMD_FF               when Mode_Reg(2 downto 0) = "000" else 
                                   PEC_Ready            when Mode_Reg(2 downto 0) = "001" else 
                                   not(PCIe_ack)        when Mode_Reg(2 downto 0) = "011" else 
                                   not(PCIe_ready)      when Mode_Reg(2 downto 0) = "100" else 
                                   TC_equal_Zero        when Mode_Reg(2 downto 0) = "101" else
                                   LC_Equal_LR_extend   when Mode_Reg(2 downto 0) = "110" else '0';

    Wait_condition_Mux          <= LC_Equal_LR_extend   when (Mem_Out(21 downto 20) = "01" and Mem_Out(23)= '1') else 
                                   not(TAG_shift)       when (Mem_Out(21 downto 20) = "10" and Mem_Out(23)= '1') else
                                   CM_Flag_Latch        when (Mem_Out(21 downto 20) = "11" and Mem_Out(23)= '1') else '0';
                                                                                                                             
   
    AS_Counter_Mux              <= Opcode(7 downto 0)   when Mem_Out(23) = '1' else Mux1;
    Mux1                        <= Mux2                 when Mem_Out(21 downto 20) = "00" else
                                   Mem_Out(7 downto 0)  when Mem_Out(21 downto 20) = "01" else
                                   Return_Reg1          when Mem_Out(21 downto 20) = "10" else
                                   Return_Reg2          when Mem_Out(21 downto 20) = "11" else (others => '0');                      
    Mux2                        <= Return_Reg2          when Jump_condition_Mux = '1' else Return_Reg1;

    Cond_Jump                   <= '1' when Mem_Out(23 downto 20) = "0101" or Mem_Out(23 downto 20) = "0111" or Mem_Out(23 downto 20) = "1000" else '0';
    UnCond_Jump                 <= '1' when Mem_Out(23 downto 20) = "0001" or Mem_Out(23 downto 20) = "0010" or Mem_Out(23 downto 20) = "0011" or Mem_Out(23 downto 20) = "0100" or Mem_Out(23 downto 20) = "1100" else '0';
    Cond_Wait                   <= '1' when (Mem_Out(21 downto 20) = "01" and Mem_Out(23)= '1') or (Mem_Out(21 downto 20) = "10" and Mem_Out(23)= '1') or (Mem_Out(21 downto 20) = "11" and Mem_Out(23)= '1') else '0';
    Load_AS_Counter             <= (Jump_condition_Mux and Cond_Jump) or UnCond_Jump;
    Enable_AS_Counter           <=  Wait_condition_Mux or not(Cond_Wait);

    Decoder2                    <= "001" when Mem_Out(19 downto 18) = "01" else 
                                   "010" when Mem_Out(19 downto 18) = "10" else 
                                   "100" when Mem_Out(19 downto 18) = "11" else "000";
                                   
    Decoder1                    <= "000000001" when Mem_Out(11 downto 8) = "0001" else 
                                   "000000010" when Mem_Out(11 downto 8) = "0010" else 
                                   "000000100" when Mem_Out(11 downto 8) = "0011" else 
                                   "000001000" when Mem_Out(11 downto 8) = "0100" else 
                                   "000010000" when Mem_Out(11 downto 8) = "0101" else 
                                   "000100000" when Mem_Out(11 downto 8) = "0110" else 
                                   "001000000" when Mem_Out(11 downto 8) = "0111" else 
                                   "010000000" when Mem_Out(11 downto 8) = "1000" else
                                   "100000000" when Mem_Out(11 downto 8) = "1001" else
                                   "000000000";

    Reg_Area1                   <= Mem_Out(6 downto 0) when Decoder2= "001" else "0000000";
    Reg_Area2                   <= Mem_Out(6 downto 0) when Decoder2= "010" else "0000000";
    Reg_Area3                   <= Mem_Out(6 downto 0) when Decoder2= "100" else "0000000";

    R_W_RM_i                    <= Mode_Reg(3);
    R_W_PCIe_i                  <= Mode_Reg(4);
    
    LC_Equal_LR                 <= '1' when Loop_Counter = Loop_Register and Loop_Counter > 0 else '0';
    LC_Equal_LR_extend          <= LC_Equal_LR or LC_Equal_LR_latch;


    process(clk, reset)
    begin
        if reset = '1' then
            Load_MD_Reg_i               <= '0';
            Step_MDC_i                  <= '0';
            Step_BC_i                   <= '0';
            Reset_BC_i                  <= '0';
            Load_PCIe_CMD_Reg_i         <= '0';
            Control_Data_Out            <= (others => '0');
            LC_Equal_LR_latch           <= '0';
            Control_Data                <= (others => '0');               
            Load_Mux_Reg_i              <= '0';
            Load_Mode_Reg               <= '0';
            Load_LR                     <= '0';
            Load_PEC_Reg_i              <= '0'; 
            Load_Tag_Shift_Counter_i    <= '0';
            Load_Return_Reg1            <= '0';
            Load_Return_Reg2            <= '0';
            Load_Req_reg_i              <= '0';
            Load_NOC_reg_i              <= '0';
            En_NOC_Transfer_i           <= '0';
            En_RM_i                     <= '0';
            En_PCIe_ctrl_i              <= '0';
            En_PCIe_Data_i              <= '0';
            Start_TAG_Shift_i           <= '0';
            Load_RM_as_gen_i            <= '0';
            Load_TC                     <= '0';
            Reset_CM_Flag               <= '0';
            Load_CMD_Reg_i              <= '0';  
            Set_PEC_FF2_i               <= '0';      
            Reset_MDC_i                 <= '0';           
            Step_LC                     <= '0';
            Decr_TC                     <= '0';
            Reset_LC_i                  <= '0';
            Loop_Counter                <= (others => '0');
            Loop_Register               <= (others => '0');
            Transfer_Counter            <= (others => '0');
            Return_Reg1                 <= (others => '0');
            Return_Reg2                 <= (others => '0');
            Mode_Reg                    <= (others => '0');
            TC_Equal_Zero               <= '0';
            Address_Counter             <= (others => '0');
            Shift_TC_i                  <= '0';
        elsif rising_edge(clk) then
            LC_Equal_LR_latch           <= LC_Equal_LR;
            Control_Data                <= Mem_Out(7 downto 0);
            Control_Data_Out            <= Mem_Out(7 downto 0);
            
            Load_Mux_Reg_i              <= Decoder1(0);
            Load_Mode_Reg               <= Decoder1(1);
            Load_LR                     <= Decoder1(2);
            Load_PEC_Reg_i              <= Decoder1(3);    
            Load_Tag_Shift_Counter_i    <= Decoder1(4);
            Load_Return_Reg1            <= Decoder1(5);
            Load_Return_Reg2            <= Decoder1(6);
            Load_PCIe_CMD_Reg_i         <= Decoder1(7);    
            Load_Req_reg_i              <= Decoder1(8);     
            
            Load_NOC_reg_i              <= Mem_Out(12);
            En_NOC_Transfer_i           <= Mem_Out(13);
            En_RM_i                     <= Mem_Out(15);
            En_PCIe_ctrl_i              <= Mem_Out(16);     
            En_PCIe_Data_i              <= Mem_Out(17);    
            
            Start_TAG_Shift_i           <= Decoder2(0) and Mem_Out(0); 
            Load_RM_as_gen_i            <= Decoder2(0) and Mem_Out(1);
            Load_TC                     <= Decoder2(0) and Mem_Out(4);
            Reset_CM_Flag               <= Decoder2(0) and Mem_Out(5);				
            Shift_TC_i                  <= Decoder2(0) and Mem_Out(6);
            Load_CMD_Reg_i              <= Decoder2(1) and Mem_Out(0);     
            Set_PEC_FF2_i               <= Decoder2(1) and Mem_Out(2);      
            Reset_MDC_i                 <= Decoder2(1) and Mem_Out(3);     
            
            Load_MD_Reg_i               <= Decoder2(2) and Mem_Out(0);    
            Step_MDC_i                  <= Decoder2(2) and Mem_Out(1);    
            Step_LC                     <= Decoder2(2) and Mem_Out(2);
            Step_BC_i                   <= Decoder2(2) and Mem_Out(3);
            Decr_TC                     <= Decoder2(2) and Mem_Out(4);
            Reset_LC_i                  <= Decoder2(2) and Mem_Out(5);
            Reset_BC_i                  <= Decoder2(2) and Mem_Out(6);

            if Reset_LC_i = '1' then 
                Loop_Counter    <= (others => '0');
            elsif Step_LC = '1' then
                Loop_Counter    <= Loop_Counter + '1';
            end if;    

            if Load_LR = '1' then
                Loop_Register   <= Loop_Mux;
            end if;
             
            if Transfer_Counter = x"0000" then
                TC_Equal_Zero    <= '1';
            else
                TC_Equal_Zero    <= '0';
            end if;
            
            TS_odd <= TS + '1';
            
            if Load_TC = '1' then
                if Shift_TC_i = '1' then
                    Transfer_Counter <= '0' & TS_odd(15 downto 1);
                else
                    Transfer_Counter <= TS;
                end if;       
            elsif Decr_TC ='1' then
                Transfer_Counter <= Transfer_Counter - '1';
            end if;
            
            if Load_AS_Counter = '1' then
                Address_Counter   <=  AS_Counter_Mux;
            elsif Enable_AS_Counter = '1' then
                Address_Counter   <= Address_Counter + 1;
            end if;

            if Load_Return_Reg1 = '1' then 
                Return_Reg1     <=  Control_Data;
            end if;
            
            if Load_Return_Reg2 = '1' then 
                Return_Reg2     <=  Control_Data;
            end if;
            
            if Load_Mode_Reg = '1' then 
                Mode_Reg        <=  Control_Data;
            end if;
        end if; --reset
    end process;

    process(clk, reset)
    begin
        if reset = '1'then
            CM_Flag_Latch <= '0';
        elsif rising_edge(clk) then
            if Reset_CM_Flag = '1' then
                CM_Flag_Latch <= '0';
            elsif Gated_CLK_from_PEC = '1' then
                CM_Flag_Latch <= Cond_Wait; 
            end if;
        end if;
    end process;
	 
    -- probe0_i(0)           <= h2c_cmd_t;
    -- probe1_i(0)           <= CMD_flag_t;
    -- probe2_i(7 downto 0)  <= Mux2;
    -- probe3_i(7 downto 0)  <= Return_Reg2;
    -- probe4_i(0)           <= Noc_CMD_flag_t;
    -- probe5_i(0)           <= PCIe_req_t;
    -- probe6_i(0)           <= c2h_cmd_t;
    -- probe7_i(0)           <= PCIe_ack;
    -- probe8_i(0)           <= En_PCIe_Data_i;
    -- probe9_i(0)           <= pcie_wr_data_wrs_t;
    -- probe10_i(0)          <= pcie_wr_ctl_wrs_t;
    -- probe11_i(0)          <= Load_AS_Counter;
    -- probe12_i(7 downto 0) <= Address_Counter;
    -- probe13_i(0)          <= Enable_AS_Counter;
    -- probe14_i(23 downto 0)<= Program_Mem_Out;
    -- probe15_i(0)          <= Load_Mode_Reg;
    -- probe16_i(7 downto 0) <= Mode_Reg;
    -- probe17_i(7 downto 0) <= AS_Counter_Mux;
    -- probe18_i(19 downto 0)<= Loop_Counter;
    -- probe19_i(19 downto 0)<= Loop_Register;
    -- probe20_i(15 downto 0)<= Transfer_Counter;
    -- probe21_i(0)          <= TC_Equal_Zero;
    -- probe22_i(0)          <= LC_Equal_LR;
    -- probe23_i(19 downto 0)<= Loop_Mux;
    -- probe24_i(0)          <= CMD_FF;
    -- probe25_i(0)          <= Load_MD_Reg_i;
    -- probe26_i(0)          <= CM_Flag_Latch;
    -- probe27_i(0)          <= Load_Tag_Shift_Counter_i;
    -- probe28_i(0)          <= Start_TAG_Shift_i;
    -- probe29_i(0)          <= Tag_shift;
    -- probe30_i(0)          <= Load_CMD_Reg_i;
    -- probe31_i(0)          <= Jump_condition_Mux;
    -- probe32_i(8 downto 0) <= decoder1;
    -- probe33_i(2 downto 0) <= decoder2;
    -- probe34_i(0)          <= Cond_Wait;
    -- probe35_i(0)          <= Wait_condition_Mux;
    -- probe36_i(0)          <= LC_Equal_LR_latch;
    -- probe37_i(0)          <= LC_Equal_LR_extend;
    -- probe38_i(0)          <= Mux1(0);
    -- probe39_i(0)          <= Mux1(1);
    -- probe40_i(0)          <= PEC_Ready;
    -- probe41_i(0)          <= CMD_FF;
    -- probe42_i(0)          <= PCIe_ready;
    -- probe43_i(0)          <= Load_RM_as_gen_i;
    -- probe44_i(0)          <= Load_PEC_Reg_i;
    -- probe45_i(0)          <= Load_PEC_Reg_i;
    -- probe46_i(0)          <= Load_PCIe_CMD_Reg_i;
    -- probe47_i(0)          <= Load_Req_reg_i;
    -- probe48_i(0)          <= En_PCIe_ctrl_i;
    -- probe49_i(0)          <= Set_PEC_FF2_i;
    -- probe50_i(0)          <= En_NOC_Transfer_i;
    -- probe51_i(0)          <= En_RM_i;
    -- probe52_i(0)          <= En_RM_i;
    -- probe53_i(0)          <= R_W_RM_i;
    -- probe54_i(0)          <= R_W_PCIe_i;
    -- probe55_i(0)          <= Step_BC_i;
    -- probe56_i(0)          <= Load_Mux_Reg_i;
    -- probe57_i(0)          <= Reset;
    -- probe58_i(11 downto 0)<= Opcode;
    -- probe59_i(4 downto 0) <= BC;
    -- probe60_i(15 downto 0)<= TS;

    	
    -- Ila_NOC : ila_2
    -- port map(
	-- clk 	=> clk,
    -- probe0  => probe0_i, 
	-- probe1  => probe1_i, 
	-- probe2  => probe2_i, 
	-- probe3  => probe3_i, 
	-- probe4  => probe4_i, 
	-- probe5  => probe5_i, 
	-- probe6  => probe6_i, 
	-- probe7  => probe7_i, 
	-- probe8  => probe8_i, 
	-- probe9  => probe9_i, 
	-- probe10 => probe10_i,
	-- probe11 => probe11_i,
	-- probe12 => probe12_i,
	-- probe13 => probe13_i,
	-- probe14 => probe14_i,
	-- probe15 => probe15_i,
	-- probe16 => probe16_i,
	-- probe17 => probe17_i,
	-- probe18 => probe18_i,
	-- probe19 => probe19_i,
	-- probe20 => probe20_i,
	-- probe21 => probe21_i,
	-- probe22 => probe22_i,
	-- probe23 => probe23_i,
	-- probe24 => probe24_i,
	-- probe25 => probe25_i,
	-- probe26 => probe26_i,
	-- probe27 => probe27_i,
	-- probe28 => probe28_i,
	-- probe29 => probe29_i,
	-- probe30 => probe30_i,
	-- probe31 => probe31_i, 
	-- probe32 => probe32_i, 
	-- probe33 => probe33_i, 
	-- probe34 => probe34_i, 
	-- probe35 => probe35_i, 
	-- probe36 => probe36_i, 
	-- probe37 => probe37_i, 
	-- probe38 => probe38_i,
	-- probe39 => probe39_i,
	-- probe40 => probe40_i, 
	-- probe41 => probe41_i, 
	-- probe42 => probe42_i, 
	-- probe43 => probe43_i, 
	-- probe44 => probe44_i, 
	-- probe45 => probe45_i, 
	-- probe46 => probe46_i, 
	-- probe47 => probe47_i, 
	-- probe48 => probe48_i,
	-- probe49 => probe49_i,
	-- probe50 => probe50_i, 
	-- probe51 => probe51_i, 
	-- probe52 => probe52_i, 
	-- probe53 => probe53_i, 
	-- probe54 => probe54_i, 
	-- probe55 => probe55_i, 
	-- probe56 => probe56_i, 
	-- probe57 => probe57_i, 
	-- probe58 => probe58_i,
	-- probe59 => probe59_i,
	-- probe60 => probe60_i			
-- );

end Behavioral;