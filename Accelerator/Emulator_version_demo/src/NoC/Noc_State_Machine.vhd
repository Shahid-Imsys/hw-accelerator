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
        TAG_shift               : in  std_logic;                        -- Tag control 
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
        EN_EM                   : out std_logic;                        --ext memory
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
        PCIe_req_t              : in  std_logic
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
    
    component ila_2
    port(
        clk     : in  std_logic;
        probe0  : in std_logic_vector(0 downto 0); 
        probe1  : in std_logic_vector(0 downto 0); 
        probe2  : in std_logic_vector(7 downto 0); 
        probe3  : in std_logic_vector(7 downto 0); 
        probe4  : in std_logic_vector(0 downto 0); 
        probe5  : in std_logic_vector(0 downto 0); 
        probe6  : in std_logic_vector(0 downto 0); 
        probe7  : in std_logic_vector(0 downto 0); 
        probe8  : in std_logic_vector(0 downto 0); 
        probe9  : in std_logic_vector(0 downto 0); 
        probe10 : in std_logic_vector(0 downto 0); 
        probe11 : in std_logic_vector(0 downto 0); 
        probe12 : in std_logic_vector(7 downto 0); 
        probe13 : in std_logic_vector(0 downto 0); 
        probe14 : in std_logic_vector(23 downto 0); 
        probe15 : in std_logic_vector(0 downto 0); 
        probe16 : in std_logic_vector(7 downto 0); 
        probe17 : in std_logic_vector(7 downto 0); 
        probe18 : in std_logic_vector(19 downto 0); 
        probe19 : in std_logic_vector(19 downto 0); 
        probe20 : in std_logic_vector(15 downto 0); 
        probe21 : in std_logic_vector(0 downto 0); 
        probe22 : in std_logic_vector(0 downto 0); 
        probe23 : in std_logic_vector(19 downto 0); 
        probe24 : in std_logic_vector(0 downto 0); 
        probe25 : in std_logic_vector(0 downto 0); 
        probe26 : in std_logic_vector(0 downto 0); 
        probe27 : in std_logic_vector(0 downto 0); 
        probe28 : in std_logic_vector(0 downto 0); 
        probe29 : in std_logic_vector(0 downto 0); 
        probe30 : in std_logic_vector(0 downto 0); 
        probe31 : in std_logic_vector(0 downto 0); 
        probe32 : in std_logic_vector(8 downto 0); 
        probe33 : in std_logic_vector(2 downto 0); 
        probe34 : in std_logic_vector(0 downto 0); 
        probe35 : in std_logic_vector(0 downto 0); 
        probe36 : in std_logic_vector(0 downto 0); 
        probe37 : in std_logic_vector(0 downto 0); 
        probe38 : in std_logic_vector(0 downto 0);
        probe39 : in std_logic_vector(0 downto 0);
        probe40 : in std_logic_vector(0 downto 0);
        probe41 : in std_logic_vector(0 downto 0);
        probe42 : in std_logic_vector(0 downto 0);
        probe43 : in std_logic_vector(0 downto 0);
        probe44 : in std_logic_vector(0 downto 0);
        probe45 : in std_logic_vector(0 downto 0);
        probe46 : in std_logic_vector(0 downto 0);
        probe47 : in std_logic_vector(0 downto 0);
        probe48 : in std_logic_vector(0 downto 0);
        probe49 : in std_logic_vector(0 downto 0);
        probe50 : in std_logic_vector(0 downto 0);
        probe51 : in std_logic_vector(0 downto 0);
        probe52 : in std_logic_vector(0 downto 0);
        probe53 : in std_logic_vector(0 downto 0);
        probe54 : in std_logic_vector(0 downto 0);
        probe55 : in std_logic_vector(0 downto 0);
        probe56 : in std_logic_vector(0 downto 0);
        probe57 : in std_logic_vector(0 downto 0);
        probe58 : in std_logic_vector(11 downto 0);
        probe59 : in std_logic_vector(4 downto 0);
        probe60 : in std_logic_vector(15 downto 0)	
    );
    end component;
    
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
    signal  LC_Equal_LR             : std_logic:= '0';
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
	signal  EN_EM_i                 : std_logic;
	signal  R_W_RM_i                : std_logic;
	signal  R_W_PCIe_i              : std_logic;
	signal  Step_BC_i               : std_logic;
	signal  Load_Mux_Reg_i          : std_logic;
    --ILA SIGNALS
    signal probe0  : std_logic_vector(0 downto 0); 
	signal probe1  : std_logic_vector(0 downto 0); 
	signal probe2  : std_logic_vector(7 downto 0); 
	signal probe3  : std_logic_vector(7 downto 0); 
	signal probe4  : std_logic_vector(0 downto 0); 
	signal probe5  : std_logic_vector(0 downto 0); 
	signal probe6  : std_logic_vector(0 downto 0); 
	signal probe7  : std_logic_vector(0 downto 0); 
	signal probe8  : std_logic_vector(0 downto 0); 
	signal probe9  : std_logic_vector(0 downto 0); 
	signal probe10 : std_logic_vector(0 downto 0); 
	signal probe11 : std_logic_vector(0 downto 0); 
	signal probe12 : std_logic_vector(7 downto 0); 
	signal probe13 : std_logic_vector(0 downto 0); 
	signal probe14 : std_logic_vector(23 downto 0); 
	signal probe15 : std_logic_vector(0 downto 0); 
	signal probe16 : std_logic_vector(7 downto 0); 
	signal probe17 : std_logic_vector(7 downto 0); 
	signal probe18 : std_logic_vector(19 downto 0); 
	signal probe19 : std_logic_vector(19 downto 0); 
	signal probe20 : std_logic_vector(15 downto 0); 
	signal probe21 : std_logic_vector(0 downto 0); 
	signal probe22 : std_logic_vector(0 downto 0); 
	signal probe23 : std_logic_vector(19 downto 0); 
	signal probe24 : std_logic_vector(0 downto 0); 
	signal probe25 : std_logic_vector(0 downto 0); 
	signal probe26 : std_logic_vector(0 downto 0); 
	signal probe27 : std_logic_vector(0 downto 0); 
	signal probe28 : std_logic_vector(0 downto 0); 
	signal probe29 : std_logic_vector(0 downto 0); 
	signal probe30 : std_logic_vector(0 downto 0); 
	signal probe31 : std_logic_vector(0 downto 0); 
	signal probe32 : std_logic_vector(8 downto 0); 
	signal probe33 : std_logic_vector(2 downto 0); 
	signal probe34 : std_logic_vector(0 downto 0); 
	signal probe35 : std_logic_vector(0 downto 0); 
	signal probe36 : std_logic_vector(0 downto 0); 
	signal probe37 : std_logic_vector(0 downto 0); 
	signal probe38 : std_logic_vector(0 downto 0);
	signal probe39 : std_logic_vector(0 downto 0);
    signal probe40 : std_logic_vector(0 downto 0);
    signal probe41 : std_logic_vector(0 downto 0);
    signal probe42 : std_logic_vector(0 downto 0);
    signal probe43 : std_logic_vector(0 downto 0);
    signal probe44 : std_logic_vector(0 downto 0);
    signal probe45 : std_logic_vector(0 downto 0);
    signal probe46 : std_logic_vector(0 downto 0);
    signal probe47 : std_logic_vector(0 downto 0);
    signal probe48 : std_logic_vector(0 downto 0);
    signal probe49 : std_logic_vector(0 downto 0);
    signal probe50 : std_logic_vector(0 downto 0);
    signal probe51 : std_logic_vector(0 downto 0);
    signal probe52 : std_logic_vector(0 downto 0);
    signal probe53 : std_logic_vector(0 downto 0);
    signal probe54 : std_logic_vector(0 downto 0);
    signal probe55 : std_logic_vector(0 downto 0);
    signal probe56 : std_logic_vector(0 downto 0);
    signal probe57 : std_logic_vector(0 downto 0);
    signal probe58 : std_logic_vector(11 downto 0);
    signal probe59 : std_logic_vector(4 downto 0);
    signal probe60 : std_logic_vector(15 downto 0);	


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
    EN_EM                 <= EN_EM_i;
    R_W_RM                <= R_W_RM_i;
    R_W_PCIe              <= R_W_PCIe_i;
    Step_BC               <= Step_BC_i;
    Load_Mux_Reg          <= Load_Mux_Reg_i;

    Program_Memory : blk_mem_gen_1
    port map 
    (
        clka => clk,
        ena => '1',
        addra => Address_Counter, 
        douta => Program_Mem_Out
    );

    Mem_Out                     <= Program_Mem_Out when reset ='0' else (others => '0');
    TSx16                       <= TS & "0000";
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
                                   Return_Reg2          when Mem_Out(21 downto 20) = "11";                             
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
                Start_Tag_Shift             <= '0';
                Load_RM_as_gen              <= '0';
                Load_CMD_Reg                <= '0';
                Set_PEC_FF2                 <= '0';
                Reset_MDC                   <= '0';
                Load_Mux_Reg                <= '0';
                Load_PEC_Reg                <= '0';
                Load_Tag_Shift_Counter      <= '0';
                Load_PCIe_CMD_Reg           <= '0';
                Control_Data_Out            <= (others => '0');
                Load_NOC_Reg                <= '0';
                En_NOC_Transfer             <= '0';
                En_RM                       <= '0';
                En_PCIe_ctrl                <= '0';
                En_PCIe_Data                <= '0';
                
                LC_Equal_LR_latch           <= '0';
                Control_Data                <= (others => '0');               
                Load_Mux_Reg_i              <= '0';
                Load_Mode_Reg               <= '0';
                Load_LR                     <= '0';
                Load_PEC_Reg_i              <= '0'; 
                Load_Tag_Shift_Counter_i    <= '0';
                Load_Return_Reg1            <= '0';
                Load_Return_Reg2            <= '0';
                Load_Req_reg                <= '0';                   
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
                Loop_Mux                    <= (others => '0');
                TC_Equal_Zero               <= '0';
                Address_Counter             <= (others => '0');
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
                Load_PCIe_CMD_Reg           <= Decoder1(7);    
                Load_Req_reg                <= Decoder1(8);     
                
                Load_NOC_reg_i              <= Mem_Out(12);
                En_NOC_Transfer_i           <= Mem_Out(13);
                En_RM_i                     <= Mem_Out(15);
                En_PCIe_ctrl_i              <= Mem_Out(16);     
                En_PCIe_Data_i              <= Mem_Out(17);    
                
                Start_TAG_Shift_i           <= Decoder2(0) and Mem_Out(0); 
                Load_RM_as_gen_i            <= Decoder2(0) and Mem_Out(1);
                Load_TC                     <= Decoder2(0) and Mem_Out(4);
                Reset_CM_Flag               <= Decoder2(0) and Mem_Out(5);            
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
                
                if Load_TC = '1' then
                    Transfer_Counter <= TS;
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
                
        end if;  --clock
    end process;

    process(Gated_CLK_from_PEC)
    begin
        if rising_edge(Gated_CLK_from_PEC) then
            if reset = '1'then
                CM_Flag_Latch <= '0';             
            elsif Reset_CM_Flag = '1' then
                CM_Flag_Latch <= '0';
            else
                CM_Flag_Latch <= Cond_Wait; 
            end if;
        end if;
    end process;
            
        
    probe0(0)           <= h2c_cmd_t;
    probe1(0)           <= CMD_flag_t;
    probe2(7 downto 0)  <= Mux2;
    probe3(7 downto 0)  <= Return_Reg2;
    probe4(0)           <= Noc_CMD_flag_t;
    probe5(0)           <= PCIe_req_t;
    probe6(0)           <= c2h_cmd_t;
    probe7(0)           <= PCIe_ack;
    probe8(0)           <= En_PCIe_Data_i;
    probe9(0)           <= pcie_wr_data_wrs_t;
    probe10(0)          <= pcie_wr_ctl_wrs_t;
    probe11(0)          <= Load_AS_Counter;
    probe12(7 downto 0) <= Address_Counter;
    probe13(0)          <= Enable_AS_Counter;
    probe14(23 downto 0)<= Program_Mem_Out;
    probe15(0)          <= Load_Mode_Reg;
    probe16(7 downto 0) <= Mode_Reg;
    probe17(7 downto 0) <= AS_Counter_Mux;
    probe18(19 downto 0)<= Loop_Counter;
    probe19(19 downto 0)<= Loop_Register;
    probe20(15 downto 0)<= Transfer_Counter;
    probe21(0)          <= TC_Equal_Zero;
    probe22(0)          <= LC_Equal_LR;
    probe23(19 downto 0)<= Loop_Mux;
    probe24(0)          <= CMD_FF;
    probe25(0)          <= Load_MD_Reg_i;
    probe26(0)          <= CM_Flag_Latch;
    probe27(0)          <= Load_Tag_Shift_Counter_i;
    probe28(0)          <= Start_TAG_Shift_i;
    probe29(0)          <= Tag_shift;
    probe30(0)          <= Load_CMD_Reg_i;
    probe31(0)          <= Jump_condition_Mux;
    probe32(8 downto 0) <= decoder1;
    probe33(2 downto 0) <= decoder2;
    probe34(0)          <= Cond_Wait;
    probe35(0)          <= Wait_condition_Mux;
    probe36(0)          <= LC_Equal_LR_latch;
    probe37(0)          <= LC_Equal_LR_extend;
    probe38(0)          <= Mux1(0);
    probe39(0)          <= Mux1(1);
    probe40(0)          <= PEC_Ready;
    probe41(0)          <= CMD_FF;
    probe42(0)          <= PCIe_ready;
    probe43(0)          <= Load_RM_as_gen_i;
    probe44(0)          <= Load_PEC_Reg_i;
    probe45(0)          <= Load_PEC_Reg_i;
    probe46(0)          <= Load_PCIe_CMD_Reg_i;
    probe47(0)          <= Load_Req_reg_i;
    probe48(0)          <= En_PCIe_ctrl_i;
    probe49(0)          <= Set_PEC_FF2_i;
    probe50(0)          <= En_NOC_Transfer_i;
    probe51(0)          <= En_RM_i;
    probe52(0)          <= En_RM_i;
    probe53(0)          <= R_W_RM_i;
    probe54(0)          <= R_W_PCIe_i;
    probe55(0)          <= Step_BC_i;
    probe56(0)          <= Load_Mux_Reg_i;
    probe57(0)          <= Reset;
    probe58(11 downto 0)<= Opcode;
    probe59(4 downto 0) <= BC;
    probe60(15 downto 0)<= TS;
    
    
    Ila_NOC : ila_2
    port map(
	clk => clk,
	probe0 => probe0, 
	probe1 => probe1, 
	probe2 => probe2, 
	probe3 => probe3, 
	probe4 => probe4, 
	probe5 => probe5, 
	probe6 => probe6, 
	probe7 => probe7, 
	probe8 => probe8, 
	probe9 => probe9, 
	probe10 => probe10, 
	probe11 => probe11, 
	probe12 => probe12, 
	probe13 => probe13, 
	probe14 => probe14, 
	probe15 => probe15, 
	probe16 => probe16, 
	probe17 => probe17, 
	probe18 => probe18, 
	probe19 => probe19, 
	probe20 => probe20, 
	probe21 => probe21, 
	probe22 => probe22, 
	probe23 => probe23, 
	probe24 => probe24, 
	probe25 => probe25, 
	probe26 => probe26, 
	probe27 => probe27, 
	probe28 => probe28, 
	probe29 => probe29, 
	probe30 => probe30, 
	probe31 => probe31, 
	probe32 => probe32, 
	probe33 => probe33, 
	probe34 => probe34, 
	probe35 => probe35, 
	probe36 => probe36, 
	probe37 => probe37, 
	probe38 => probe38,
	probe39 => probe39,
	probe40 => probe40, 
	probe41 => probe41, 
	probe42 => probe42, 
	probe43 => probe43, 
	probe44 => probe44, 
	probe45 => probe45, 
	probe46 => probe46, 
	probe47 => probe47, 
	probe48 => probe48,
	probe49 => probe49,
	probe50 => probe50, 
	probe51 => probe51, 
	probe52 => probe52, 
	probe53 => probe53, 
	probe54 => probe54, 
	probe55 => probe55, 
	probe56 => probe56, 
	probe57 => probe57, 
	probe58 => probe58,
	probe59 => probe59,
	probe60 => probe60			
);

end Behavioral;
