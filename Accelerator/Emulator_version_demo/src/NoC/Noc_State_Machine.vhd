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
-- Description: Noc State Machine execute the hex code for different use cases
-- that are saved in the program memory
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
        EN_EM                   : out std_logic;                        --ext memory
        R_W_RM                  : out std_logic;                        --root memory
        R_W_PCIe                : out std_logic;                        --ext memory
        Start_Tag_Shift         : out std_logic;                        --Tag Line Controller 
        Load_Tag_Shift_Counter  : out std_logic;                        --Tag Line Controller 
        Step_BC                 : out std_logic;  
        Reset_BC                : out std_logic;        
        Load_Mux_Reg            : out std_logic; 
        Control_Data_Out        : out std_logic_vector(7 downto 0)
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

    signal  Load_Mode_Reg       : std_logic:= '0'; 
    signal  Reset_LC            : std_logic:= '0';  
    signal  Step_LC             : std_logic:= '0';  
    signal  Control_Data        : std_logic_vector(7 downto 0) := (others => '0'); 
    signal  TSx16               : std_logic_vector(19 downto 0):= (others => '0'); 
    signal  Load_LR             : std_logic:= '0';   
    signal  Load_TC             : std_logic:= '0'; 
    signal  Decr_TC             : std_logic:= '0';
    signal  Reset_CM_Flag       : std_logic:= '0'; 
    signal  Loop_Counter        : std_logic_vector(19 downto 0):= (others => '0'); 
    signal  Loop_Register       : std_logic_vector(19 downto 0):= (others => '0');
    signal  Transfer_Counter    : std_logic_vector(15 downto 0):= (others => '0');
    signal  Return_Reg1         : std_logic_vector(7 downto 0):= (others => '0');
    signal  Return_Reg2         : std_logic_vector(7 downto 0):= (others => '0');
    signal  Mode_Reg            : std_logic_vector(7 downto 0):= (others => '0');
    signal  BC_equal_64         : std_logic:= '0';  
    signal  Load_Return_Reg1    : std_logic:= '0';  
    signal  Load_Return_Reg2    : std_logic:= '0';  
    signal  Loop_Mux            : std_logic_vector(19 downto 0):= (others => '0');
    signal  CM_Flag_Latch       : std_logic:= '0';    
    signal  TC_Equal_Zero       : std_logic:= '0';    
    signal  Jump_condition_Mux  : std_logic:= '0';   
    signal  Wait_condition_Mux  : std_logic:= '0';  
    signal  AS_Counter_Mux      : std_logic_vector(7 downto 0):= (others => '0'); 
    signal  Program_Mem_Out     : std_logic_vector(23 downto 0):= (others => '0');
    signal  Load_AS_Counter     : std_logic:= '0';
    signal  Enable_AS_Counter   : std_logic:= '0';
    signal  Address_Counter     : std_logic_vector(7 downto 0):= (others => '0'); 
    signal  Cond_Jump           : std_logic:= '0'; 
    signal  UnCond_Jump         : std_logic:= '0';
    signal  Cond_Wait           : std_logic:= '0'; 
    signal  Decoder1            : std_logic_vector(8 downto 0):= (others => '0');    
    signal  Decoder2            : std_logic_vector(2 downto 0):= (others => '0');
    signal  Reg_Area1           : std_logic_vector(6 downto 0):= (others => '0');
    signal  Reg_Area2           : std_logic_vector(6 downto 0):= (others => '0');
    signal  Reg_Area3           : std_logic_vector(6 downto 0):= (others => '0');
    signal  LC_Equal_LR         : std_logic:= '0';
    signal  Mem_Out             : std_logic_vector(23 downto 0):= (others => '0');
    signal  Mux1,Mux2           : std_logic_vector(7 downto 0);
    signal  LC_Equal_LR_latch   : std_logic:= '0'; 
    signal  LC_Equal_LR_extend  : std_logic:= '0';

begin

    
    Program_Memory : blk_mem_gen_1
    port map (
      clka => clk,
      ena => '1',
      addra => Address_Counter, 
      douta => Program_Mem_Out
    );

    Mem_Out                     <= Program_Mem_Out;        
    TSx16                       <= TS & "0000";
    Loop_Mux                    <= x"000" & Control_Data  when Mode_Reg(6)= '0' else (TSx16); 
    Jump_condition_Mux          <= CMD_FF               when Mode_Reg(2 downto 0) = "000" else 
                                   PEC_Ready            when Mode_Reg(2 downto 0) = "001" else 
                                   --BC_equal_64          when Mode_Reg(2 downto 0) = "010" else 
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

    BC_equal_64                 <= '1' when BC= "111111";

    R_W_RM                      <= Mode_Reg(3);
    R_W_PCIe                    <= Mode_Reg(4);
    
    LC_Equal_LR                 <= '1' when Loop_Counter = Loop_Register and Loop_Counter > 0 else '0';
    LC_Equal_LR_extend          <= LC_Equal_LR or LC_Equal_LR_latch;


    process(clk)
    begin
        if rising_edge(clk) then
        
            LC_Equal_LR_latch           <= LC_Equal_LR;
       
            Control_Data                <= Mem_Out(7 downto 0);
            Control_Data_Out            <= Mem_Out(7 downto 0);
            
            Load_Mux_Reg                <= Decoder1(0);
            Load_Mode_Reg               <= Decoder1(1);
            Load_LR                     <= Decoder1(2);
            Load_PEC_Reg                <= Decoder1(3);    
            Load_Tag_Shift_Counter      <= Decoder1(4);
            Load_Return_Reg1            <= Decoder1(5);
            Load_Return_Reg2            <= Decoder1(6);
            Load_PCIe_CMD_Reg           <= Decoder1(7);    
            Load_Req_reg                <= Decoder1(8);     
            
            Load_NOC_Reg                <= Mem_Out(12);
            En_NOC_Transfer             <= Mem_Out(13);
            En_RM                       <= Mem_Out(15);
            En_PCIe_ctrl                <= Mem_Out(16);     
            En_PCIe_Data                <= Mem_Out(17);    
            
            Start_Tag_Shift             <= Decoder2(0) and Mem_Out(0); 
            Load_RM_as_gen              <= Decoder2(0) and Mem_Out(1);
            Load_TC                     <= Decoder2(0) and Mem_Out(4);
            Reset_CM_Flag               <= Decoder2(0) and Mem_Out(5);            
            Load_CMD_Reg                <= Decoder2(1) and Mem_Out(0);     
            Set_PEC_FF2                 <= Decoder2(1) and Mem_Out(2);      
            Reset_MDC                   <= Decoder2(1) and Mem_Out(3);     
            
            Load_MD_Reg                 <= Decoder2(2) and Mem_Out(0);    
            Step_MDC                    <= Decoder2(2) and Mem_Out(1);    
            Step_LC                     <= Decoder2(2) and Mem_Out(2);
            Step_BC                     <= Decoder2(2) and Mem_Out(3);
            Decr_TC                     <= Decoder2(2) and Mem_Out(4);
            Reset_LC                    <= Decoder2(2) and Mem_Out(5);
            Reset_BC                    <= Decoder2(2) and Mem_Out(6);            
                            
--            LC_Equal_LR     <= '0';     --version 2    
            if Reset_LC = '1' then 
                Loop_Counter    <= (others => '0');
--                LC_Equal_LR     <= '0';
            elsif Step_LC = '1' then
                Loop_Counter    <= Loop_Counter + '1';
            end if;    
--            if Loop_Counter = Loop_Register then
--                if Loop_Counter > 0 then
--                    LC_Equal_LR     <= '1';
--                end if;    
--            end if;

            if Load_LR = '1' then
                Loop_Register   <= Loop_Mux;
            end if;          
            
            if Reset = '1' then
                Transfer_Counter        <= (others => '0');
                Address_Counter   <= (others => '0');
            else    
                if Transfer_Counter = x"0000" then
                    TC_Equal_Zero     <= '1';
                else
                    TC_Equal_Zero     <= '0';
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
        end if;
    end process;

    process(Gated_CLK_from_PEC)
    begin
        if rising_edge(Gated_CLK_from_PEC) then   
            if Reset_CM_Flag = '1' then
                CM_Flag_Latch   <= '0';
            else
                CM_Flag_Latch   <= Cond_Wait; 
            end if;
        end if;
    end process;

end Behavioral;