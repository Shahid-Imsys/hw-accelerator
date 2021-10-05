----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2020 11:34:40
-- Design Name: 
-- Module Name: Noc_State_Machine_TB - Behavioral
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

entity Noc_State_Machine_TB is
--  Port ( );
end Noc_State_Machine_TB;

architecture Behavioral of Noc_State_Machine_TB is

    component Noc_State_Machine
    port(
        clk                 : in  std_logic;
        Gated_CLK_from_PEC  : in  std_logic;
        --TAG_shift           : in  std_logic;  --3 Tag control COMMENT FOR TEST
        TS                  : in  std_logic_vector(15 downto 0); --3 from command decoder
        PEC_Ready           : in  std_logic;  --3 from command decoder  
        DMA_Ack             : in  std_logic;  --3 
        CMD_Flag            : in  std_logic;  --3 from command decoder  
        Opcode              : in  std_logic_vector(11 downto 0); --3 from command decoder  New changes in Noc 01/05          
        BC                  : in  std_logic_vector(5 downto 0); --3 from Byte counter 
        --Load_Ext_CMD_Reg    : out std_logic;  --3
        --Load_Ext_Data_Reg   : out std_logic;  --3
        Load_RM_as_gen      : out std_logic;  --3
        Load_EM_as_gen      : out std_logic;  --3
        Load_NOC_Reg        : out std_logic;  --3
        Load_PEC_Reg        : out std_logic;  -- New changes in Noc 01/05  
        Load_PCIe_CMD_Reg   : out std_logic;  -- New changes in Noc 01/05  
        Load_Req_FF         : out std_logic;  -- New changes in Noc 01/05 
        En_PCIe_ctrl        : out std_logic;  -- New changes in Noc 01/05 
        En_PCIe_Data        : out std_logic;  -- New changes in Noc 01/05 
        Load_CMD_Reg        : out std_logic;  -- New changes in Noc 01/05
        Set_PEC_FF2         : out std_logic;  -- New changes in Noc 01/05
        Reset_MDC           : out std_logic;  -- New changes in Noc 01/05
        Load_MD_Reg         : out std_logic;  -- New changes in Noc 01/05
        Step_MDC            : out std_logic;  -- New changes in Noc 01/05
        En_NOC_Transfer     : out std_logic;  --3
        En_RM               : out std_logic;  --3 root memory
        EN_EM               : out std_logic;  --3 ext memory
        R_W_RM              : out std_logic;  --3 root memory
        R_W_EM              : out std_logic;  --3 ext memory
        Load_TAG_arg_Reg    : out std_logic;  --3 Tag line controller
        --Load_TAG_CMD_Reg    : out std_logic;  --3 Tag line controller
        --Start_Tag_Shift     : out std_logic;  --3 Tag Line Controller COMMENT FOR TEST
        --Load_Tag_Shift_Counter: out std_logic;--3 Tag Line Controller COMMENT FOR TEST
        --Set_DMA_Req         : out std_logic;  --3 check
        Reset_CMD_Flag      : out std_logic;  --3 command decoder
        --Set_PEC_Flag2       : out std_logic;  --3 command decoder
        --Reset_Req           : out std_logic;  --3 check??
        Step_BC             : out std_logic;  --3 
        Reset_BC            : out std_logic;  --3        
        Load_Mux_Reg        : out std_logic;  --3
        Control_Data_Out    : out std_logic_vector(7 downto 0);
        --ADD FOR TEST
        Load_AS_Counter_t   : out std_logic;
        Enable_AS_Counter_t : out std_logic;
        Address_Counter_t   : out std_logic_vector(7 downto 0);
        Program_Mem_Out_T   : out std_logic_vector(23 downto 0);
        Load_Mode_Reg_T     : out std_logic;
        Mode_Reg_T          : out std_logic_vector(7 downto 0);
        AS_Counter_Mux_T    : out std_logic_vector(7 downto 0);
        TAG_shift_T         : out std_logic;         
        Loop_Counter_T      : out std_logic_vector(19 downto 0);
        Loop_Register_T     : out std_logic_vector(19 downto 0);
        Transfer_Counter_T  : out std_logic_vector(15 downto 0);
        Step_LC_T           : out std_logic;
        Decr_TC_T           : out std_logic;
        En_AS_Counter_Mux_T : out std_logic;
        Cond_Wait_T         : out std_logic;
        TC_Equal_Zero_T     : out std_logic;
        LC_Equal_LR_T       : out std_logic;
        CM_Flag_Latch_T     : out std_logic
        );
    end component;
    
  
    signal    clk                 : std_logic;
    signal    Gated_CLK_from_PEC  : std_logic;
    --signal    TAG_shift           : std_logic;  --3 Tag control
    signal    TS                  : std_logic_vector(15 downto 0); --3 from command decoder
    signal    PEC_Ready           : std_logic;  --3 from command decoder  
    signal    DMA_Ack             : std_logic;  --3 
    signal    CMD_Flag            : std_logic;  --3 from command decoder  
    signal    Opcode              : std_logic_vector(11 downto 0); --3 from command decoder  New changes in Noc 01/05  
    signal    BC                  : std_logic_vector(5 downto 0); --3 from Byte counter 
    --signal    Load_Ext_CMD_Reg    : std_logic;  --3
    --signal    Load_Ext_Data_Reg   : std_logic;  --3
    signal    Load_RM_as_gen      : std_logic;  --3
    signal    Load_EM_as_gen      : std_logic;  --3
    signal    Load_NOC_Reg        : std_logic;  --3
    signal    Load_PEC_Reg        : std_logic;  -- New changes in Noc 01/05  
    signal    Load_PCIe_CMD_Reg   : std_logic;  -- New changes in Noc 01/05  
    signal    Load_Req_FF         : std_logic;  -- New changes in Noc 01/05 
    signal    En_PCIe_ctrl        : std_logic;  -- New changes in Noc 01/05 
    signal    En_PCIe_Data        : std_logic;  -- New changes in Noc 01/05 
    signal    Load_CMD_Reg        : std_logic;  -- New changes in Noc 01/05
    signal    Set_PEC_FF2         : std_logic;  -- New changes in Noc 01/05
    signal    Reset_MDC           : std_logic;  -- New changes in Noc 01/05
    signal    Load_MD_Reg         : std_logic;  -- New changes in Noc 01/05
    signal    Step_MDC            : std_logic;  -- New changes in Noc 01/05
    signal    En_NOC_Transfer     : std_logic;  --3
    signal    En_RM               : std_logic;  --3 root memory
    signal    EN_EM               : std_logic;  --3 ext memory
    signal    R_W_RM              : std_logic;  --3 root memory
    signal    R_W_EM              : std_logic;  --3 ext memory
    signal    Load_TAG_arg_Reg    : std_logic;  --3 Tag line controller
    --signal    Load_TAG_CMD_Reg    : std_logic;  --3 Tag line controller
    --signal    Start_Tag_Shift     : std_logic;  --3 Tag Line Controller
    --signal    Load_Tag_Shift_Counter: std_logic;--3 Tag Line Controller
    --signal    Set_DMA_Req         : std_logic;  --3 check
    signal    Reset_CMD_Flag      : std_logic;  --3 command decoder
    --signal    Set_PEC_Flag2       : std_logic;  --3 command decoder
    --signal    Reset_Req           : std_logic;  --3 check??
    signal    Step_BC             : std_logic;  --3 
    signal    Reset_BC            : std_logic;  --3        
    signal    Load_Mux_Reg        : std_logic;   --3
    signal    Control_Data_Out    : std_logic_vector(7 downto 0);
    --ADD FOR TEST
    signal    Address_Counter_t   : std_logic_vector(7 downto 0);
    signal    Program_Mem_Out_T   : std_logic_vector(23 downto 0);
    signal    Load_AS_Counter_t   : std_logic;
    signal    Enable_AS_Counter_t : std_logic;
    signal    Load_Mode_Reg_T     : std_logic;
    signal    Mode_Reg_T          : std_logic_vector(7 downto 0);
    signal    AS_Counter_Mux_T    : std_logic_vector(7 downto 0);
    signal    TAG_shift_T         : std_logic;         --ADD FOR TEST
    signal    Loop_Counter_T      : std_logic_vector(19 downto 0);
    signal    Loop_Register_T     : std_logic_vector(19 downto 0);
    signal    Transfer_Counter_T  : std_logic_vector(15 downto 0);
    signal    Step_LC_T           : std_logic;
    signal    Decr_TC_T           : std_logic;
    signal    En_AS_Counter_Mux_T : std_logic;
    signal    Cond_Wait_T         : std_logic;
    signal    TC_Equal_Zero_T     : std_logic;
    signal    LC_Equal_LR_T       : std_logic;
    signal    CM_Flag_Latch_T     : std_logic;


begin

    --UUT: Noc_State_Machine port map (clk => clk, Gated_CLK_from_PEC => Gated_CLK_from_PEC, TS => TS, PEC_Ready => PEC_Ready, DMA_Ack => DMA_Ack, CMD_Flag => CMD_Flag, BC => BC, Load_Ext_CMD_Reg => Load_Ext_CMD_Reg, Load_Ext_Data_Reg => Load_Ext_Data_Reg, Load_RM_as_gen => Load_RM_as_gen, Load_EM_as_gen => Load_EM_as_gen, Load_NOC_Reg => Load_NOC_Reg, En_NOC_Transfer => En_NOC_Transfer, En_RM => En_RM, EN_EM => EN_EM, R_W_RM => R_W_RM, R_W_EM => R_W_EM, Load_TAG_arg_Reg => Load_TAG_arg_Reg, Load_TAG_CMD_Reg => Load_TAG_CMD_Reg, Set_DMA_Req => Set_DMA_Req, Reset_CMD_Flag => Reset_CMD_Flag, Set_PEC_Flag2 => Set_PEC_Flag2, Reset_Req => Reset_Req, Step_BC => Step_BC, Reset_BC => Reset_BC, Load_Mux_Reg => Load_Mux_Reg, Control_Data_Out => Control_Data_Out, Load_AS_Counter_t => Load_AS_Counter_t, Enable_AS_Counter_t => Enable_AS_Counter_t, Address_Counter_t => Address_Counter_t , Program_Mem_Out_T => Program_Mem_Out_T, Load_Mode_Reg_T => Load_Mode_Reg_T, Mode_Reg_T => Mode_Reg_T,AS_Counter_Mux_T => AS_Counter_Mux_T, TAG_shift_T => TAG_shift_T,Loop_Counter_T => Loop_Counter_T,Loop_Register_T => Loop_Register_T, Transfer_Counter_T => Transfer_Counter_T,Step_LC_T => Step_LC_T, Decr_TC_T => Decr_TC_T, En_AS_Counter_Mux_T => En_AS_Counter_Mux_T, Cond_Wait_T => Cond_Wait_T, TC_Equal_Zero_T => TC_Equal_Zero_T, LC_Equal_LR_T => LC_Equal_LR_T, CM_Flag_Latch_T => CM_Flag_Latch_T);
    UUT: Noc_State_Machine port map (clk => clk, Gated_CLK_from_PEC => Gated_CLK_from_PEC, TS => TS, PEC_Ready => PEC_Ready, DMA_Ack => DMA_Ack, CMD_Flag => CMD_Flag, Opcode => Opcode, BC => BC, Load_RM_as_gen => Load_RM_as_gen, Load_EM_as_gen => Load_EM_as_gen, Load_NOC_Reg => Load_NOC_Reg, Load_PEC_Reg => Load_PEC_Reg, Load_PCIe_CMD_Reg => Load_PCIe_CMD_Reg, Load_Req_FF => Load_Req_FF, En_PCIe_ctrl => En_PCIe_ctrl, En_PCIe_Data => En_PCIe_Data, Load_CMD_Reg => Load_CMD_Reg, Set_PEC_FF2 => Set_PEC_FF2, Reset_MDC => Reset_MDC, Load_MD_Reg => Load_MD_Reg, Step_MDC => Step_MDC, En_NOC_Transfer => En_NOC_Transfer, En_RM => En_RM, EN_EM => EN_EM, R_W_RM => R_W_RM, R_W_EM => R_W_EM, Load_TAG_arg_Reg => Load_TAG_arg_Reg, Reset_CMD_Flag => Reset_CMD_Flag, Step_BC => Step_BC, Reset_BC => Reset_BC, Load_Mux_Reg => Load_Mux_Reg, Control_Data_Out => Control_Data_Out, Load_AS_Counter_t => Load_AS_Counter_t, Enable_AS_Counter_t => Enable_AS_Counter_t, Address_Counter_t => Address_Counter_t , Program_Mem_Out_T => Program_Mem_Out_T, Load_Mode_Reg_T => Load_Mode_Reg_T, Mode_Reg_T => Mode_Reg_T,AS_Counter_Mux_T => AS_Counter_Mux_T, TAG_shift_T => TAG_shift_T,Loop_Counter_T => Loop_Counter_T,Loop_Register_T => Loop_Register_T, Transfer_Counter_T => Transfer_Counter_T,Step_LC_T => Step_LC_T, Decr_TC_T => Decr_TC_T, En_AS_Counter_Mux_T => En_AS_Counter_Mux_T, Cond_Wait_T => Cond_Wait_T, TC_Equal_Zero_T => TC_Equal_Zero_T, LC_Equal_LR_T => LC_Equal_LR_T, CM_Flag_Latch_T => CM_Flag_Latch_T);
    
    
    process
        begin
            PEC_Ready           <= '0';
            DMA_Ack             <= '0';
            CMD_Flag            <= '0';
            TS                  <= x"0002";
            Opcode              <= x"010";  --put 10 for test to go to the next command 
        
            wait for 50 ns;    
            PEC_Ready           <= '1';
    
            wait for 40 ns;    
            PEC_Ready           <= '0';
            
            wait for 100 ns;  
            CMD_FLAG            <= '1';
            
            wait for 40 ns;
            CMD_FLAG            <= '0';
    
            wait for 100 ns;
              
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
    
    
--    process
--    begin
        
--        clk                 <= '0';
--        TS                  <= x"000A";
--        PEC_Ready           <= '0';
--        DMA_Ack             <= '0';
--        CMD_Flag            <= '0';
----        BC                  <= (others => '0');
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;        
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        PEC_Ready           <= '1';        
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        PEC_Ready           <= '0';        
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        CMD_FLAG            <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        CMD_FLAG            <= '0';                
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
----        CMD_FLAG            <= '0';                
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        CMD_FLAG            <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        CMD_FLAG            <= '0'; 
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;    
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;        
--        clk                 <= '0';
--        wait for 10 ns;
--        clk                 <= '1';
--        wait for 10 ns;             
--    end process;
    
    
    
    
end Behavioral;
