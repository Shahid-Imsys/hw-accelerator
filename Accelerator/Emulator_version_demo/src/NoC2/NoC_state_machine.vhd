----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 08.02.2022 17:11:58
-- Design Name: 
-- Module Name: NoC_state_machine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Noc State Machine Version2
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
use IEEE.NUMERIC_STD.ALL;
          
entity Noc_State_Machine is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        IO_data                 : in  std_logic_vector(127 downto 0);
        FIFO_Ready1             : in  std_logic;
        FIFO_Ready2             : in  std_logic;
        FIFO_Ready3             : in  std_logic;        
        TAG_shift               : in  std_logic;                    
        TS                      : in  std_logic_vector(15 downto 0);
        TSDiv16_Reg             : in  std_logic_vector(11 downto 0);
        PEC_Ready               : in  std_logic;
        IO_WRITE_ACK            : in  std_logic;
        CMD_FF                  : in  std_logic;
        Opcode                  : in  std_logic_vector(11 downto 0);
        Loop_reg_mux_ctrl       : in  std_logic;
        PEC_WE                  : in  std_logic;
        Load_RM_Address         : out std_logic;  
        Load_NOC_Reg            : out std_logic;  
        Load_PEC_Reg            : out std_logic;  
        Load_REQ_FF             : out std_logic;        
        Load_GPP_CMD            : out std_logic;
        Reset_MDC               : out std_logic;
        Load_MD_Reg             : out std_logic;
        Step_MDC                : out std_logic;
        En_RM                   : out std_logic;                        
        Start_Tag_Shift         : out std_logic;                        
        Load_Tag_Shift_Counter  : out std_logic;                      
        Step_BC                 : out std_logic;  
        Reset_BC                : out std_logic;
        Load_IR                 : out std_logic;
        Reset_IR                : out std_logic;        
        Load_Mux_Reg            : out std_logic; 
        Control_Data_Out        : out std_logic_vector(7 downto 0);
        PEC_TS_Reg              : out std_logic_vector(15 downto 0);              
        Load_NOC_cmd_reg        : out std_logic;
        En_TP                   : out std_logic;
        Reset_TPC               : out std_logic;
        TP_Interchange          : out std_logic;
        NOC_Ready               : out std_logic;
        En_IO_Data              : out std_logic;
        En_IO_Ctrl              : out std_logic;
        Sync_pulse              : out std_logic;
        load_Mode_reg           : out std_logic;
        Load_TSDiv16_reg        : out std_logic;
        ERROR                   : out std_logic;
        Write_REQ               : out std_logic
    );
end Noc_State_Machine;

architecture Behavioral of Noc_State_Machine is

    component boot_memory
      port (
        clka  : in  std_logic;
        ena   : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(27 downto 0)
      );
    end component;
    
    component program_memory
      port (
        clka  : in  std_logic;
        ena   : in  std_logic;
        wea   : in  std_logic_vector(0 downto 0);
        addra : in  std_logic_vector(8 downto 0);
        dina  : in  std_logic_vector(27 downto 0);
        douta : out std_logic_vector(27 downto 0)
      );
    end component;

    --signal declaration
    signal  ena_boot_mem            : std_logic;
    signal  load_program_mem        : std_logic;
    signal  Address_Counter         : unsigned(8 downto 0);
    signal  program_mem_we          : std_logic_vector(0 downto 0);
    signal  program_mem_addr_mux    : std_logic_vector(8 downto 0);
    signal  program_mem_data_mux    : std_logic_vector(27 downto 0);
    signal  program_mem_out         : std_logic_vector(27 downto 0);  
    signal  boot_mem_out            : std_logic_vector(27 downto 0); 
    signal  boot_FF                 : std_logic;
    signal  boot_as_counter         : unsigned(8 downto 0);
    signal  Reset_Boot_as_counter   : std_logic;
    signal  Load_Boot_FF            : std_logic;
    signal  Reset_LC                : std_logic;   
    signal  Step_LC                 : std_logic;  
    signal  Control_Data            : std_logic_vector(7 downto 0); 
    signal  TCx16                   : std_logic_vector(19 downto 0); 
    signal  Load_LR                 : std_logic;
    signal  Load_TC                 : std_logic; 
    signal  Decr_TC                 : std_logic;
    signal  Loop_Counter            : unsigned(19 downto 0); 
    signal  Loop_Register           : std_logic_vector(19 downto 0);
    signal  Transfer_Counter        : unsigned(15 downto 0);
    signal  Return_Reg1             : std_logic_vector(8 downto 0);
    signal  Return_Reg2             : std_logic_vector(8 downto 0);
    signal  Load_Return_Reg1        : std_logic;  
    signal  Load_Return_Reg2        : std_logic;  
    signal  Loop_Mux                : std_logic_vector(19 downto 0);
    signal  TC_Equal_Zero           : std_logic;    
    signal  Jump_condition_Mux      : std_logic;   
    signal  Wait_condition_Mux      : std_logic;  
    signal  AS_Counter_Mux          : std_logic_vector(8 downto 0); 
    signal  Load_AS_Counter         : std_logic;
    signal  Enable_AS_Counter       : std_logic;
    signal  Cond_Jump               : std_logic; 
    signal  UnCond_Jump             : std_logic;
    signal  Cond_Wait               : std_logic; 
    signal  Decoder1                : std_logic_vector(12 downto 0);    
    signal  Decoder2                : std_logic_vector(2 downto 0);
    signal  Reg_Area1               : std_logic_vector(6 downto 0);
    signal  Reg_Area2               : std_logic_vector(6 downto 0);
    signal  Reg_Area3               : std_logic_vector(6 downto 0);
    signal  LC_Equal_LR             : std_logic;
    signal  Mem_Out                 : std_logic_vector(27 downto 0);
    signal  Mux1,Mux2               : std_logic_vector(8 downto 0);
    signal  LC_Equal_LR_latch       : std_logic; 
    signal  LC_Equal_LR_extend      : std_logic;
    signal  PEC_WE_latch            : std_logic;
    signal  PEC_WE_extend           : std_logic;
    --internal signals
	signal  Load_GPP_CMD_i          : std_logic;
	signal  Reset_MDC_i             : std_logic;
	signal  Reset_LC_i              : std_logic;
	signal  Reset_BC_i              : std_logic;
	signal  Step_MDC_i              : std_logic;
	signal  Load_MD_Reg_i           : std_logic;
	signal  Load_Tag_Shift_Counter_i: std_logic;
	signal  Start_TAG_Shift_i       : std_logic;
	signal  Load_NOC_reg_i          : std_logic;
	signal  Load_PEC_Reg_i          : std_logic;
	signal  Load_PCIe_CMD_Reg_i     : std_logic;
	signal  En_RM_i                 : std_logic;
	signal  R_W_PCIe_i              : std_logic;
	signal  Load_Mux_Reg_i          : std_logic;
	signal  TC_mux_ctrl             : std_logic;
	signal  MSB_as                  : std_logic;
	signal  FF_data                 : std_logic;
	signal  FF                      : std_logic;	
	
begin

    Load_GPP_CMD          <= Load_GPP_CMD_i;
    Reset_MDC             <= Reset_MDC_i;
    Reset_LC              <= Reset_LC_i;
    Reset_BC              <= Reset_BC_i;
    Step_MDC              <= Step_MDC_i;
    Load_MD_Reg           <= Load_MD_Reg_i;
    Load_Tag_Shift_Counter<= Load_Tag_Shift_Counter_i;
    Start_TAG_Shift       <= Start_TAG_Shift_i;
    Load_NOC_reg          <= Load_NOC_reg_i;
    Load_PEC_Reg          <= Load_PEC_Reg_i;
    En_RM                 <= En_RM_i;
    Load_Mux_Reg          <= Load_Mux_Reg_i;
    PEC_TS_Reg            <= std_logic_vector(Transfer_Counter);
        
    boot_memory_Inst : boot_memory
    port map (
      clka  => clk,
      ena   => ena_boot_mem,
      addra => std_logic_vector(Address_Counter(7 downto 0)),
      douta => boot_mem_out
    );
  
    program_memory_Inst : program_memory
    port map (
      clka  => clk,
      ena   => '1',  --need to change
      wea   => program_mem_we,
      addra => program_mem_addr_mux,
      dina  => program_mem_data_mux,
      douta => program_mem_out
    );
    
    mem_out                     <= program_mem_out when FF = '0' else boot_mem_out;
    ena_boot_mem                <= not(boot_FF) or FF;
    program_mem_we(0)           <= '0' when load_program_mem= '0' else '1';
    program_mem_addr_mux        <= std_logic_vector(Address_Counter) when boot_FF = '1' else std_logic_vector(boot_as_counter);
    program_mem_data_mux        <= IO_data(27 downto 0)    when boot_as_counter(1 downto 0) = "00" else
                                   IO_data(59 downto 32)   when boot_as_counter(1 downto 0) = "01" else
                                   IO_data(91 downto 64)   when boot_as_counter(1 downto 0) = "10" else
                                   IO_data(123 downto 96)  when boot_as_counter(1 downto 0) = "11";

    TCx16                       <= std_logic_vector(Transfer_Counter) & "0000"; --TC_Mux & "0000";     --TS & "0000";
    Loop_Mux                    <= x"000" & Control_Data   when Loop_reg_mux_ctrl= '0' else (TCx16);
    Jump_condition_Mux          <= not(CMD_FF)             when Mem_Out(26 downto 24) = "000" else 
                                   not(FIFO_Ready1)        when Mem_Out(26 downto 24) = "001" else
                                   not(FIFO_Ready2)        when Mem_Out(26 downto 24) = "010" else
                                   not(IO_WRITE_ACK)       when Mem_Out(26 downto 24) = "011" else 
                                   not(FIFO_Ready3)        when Mem_Out(26 downto 24) = "100" else 
                                   TC_equal_Zero           when Mem_Out(26 downto 24) = "101" else
                                   LC_Equal_LR_extend      when Mem_Out(26 downto 24) = "110" else '0';

    Wait_condition_Mux          <= PEC_WE_extend           when (Mem_Out(21 downto 20) = "00" and Mem_Out(23)= '1') else 
                                   LC_Equal_LR_extend      when (Mem_Out(21 downto 20) = "01" and Mem_Out(23)= '1') else 
                                   not(TAG_shift)          when (Mem_Out(21 downto 20) = "10" and Mem_Out(23)= '1') else
                                   TC_equal_Zero           when (Mem_Out(21 downto 20) = "11" and Mem_Out(23)= '1') else '0';
   
    AS_Counter_Mux              <= '0' & Opcode(7 downto 0)           when Mem_Out(23) = '1' else Mux1;
    Mux1                        <= Mux2                               when Mem_Out(21 downto 20) = "00" else
                                   Mem_Out(27) & Mem_Out(7 downto 0)  when Mem_Out(21 downto 20) = "01" else
                                   Return_Reg1                        when Mem_Out(21 downto 20) = "10" else
                                   Return_Reg2                        when Mem_Out(21 downto 20) = "11" else (others => '0');                      
    Mux2                        <= Return_Reg2                        when Jump_condition_Mux = '1' else Return_Reg1;

--    Cond_Jump                   <= '1' when Mem_Out(23 downto 20) = "0101" or Mem_Out(23 downto 20) = "0111" or Mem_Out(23 downto 20) = "1000" else '0';
    Cond_Jump                   <= '1' when Mem_Out(23 downto 20) = "0101" or Mem_Out(23 downto 20) = "0110" or Mem_Out(23 downto 20) = "0111"  else '0';
    UnCond_Jump                 <= '1' when Mem_Out(23 downto 20) = "0001" or Mem_Out(23 downto 20) = "0010" or Mem_Out(23 downto 20) = "0011" or Mem_Out(23 downto 20) = "0100" or Mem_Out(23 downto 20) = "1100" else '0';
    Cond_Wait                   <= '1' when (Mem_Out(21 downto 20) = "01" and Mem_Out(23)= '1') or (Mem_Out(21 downto 20) = "10" and Mem_Out(23)= '1') or (Mem_Out(21 downto 20) = "11" and Mem_Out(23)= '1') or (Mem_Out(21 downto 20) = "00" and Mem_Out(23)= '1') else '0';
    Load_AS_Counter             <= (Jump_condition_Mux and Cond_Jump) or UnCond_Jump;
    Enable_AS_Counter           <=  Wait_condition_Mux or not(Cond_Wait);

    Decoder2                    <= "001" when Mem_Out(19 downto 18) = "01" else 
                                   "010" when Mem_Out(19 downto 18) = "10" else 
                                   "100" when Mem_Out(19 downto 18) = "11" else "000";
                                   
    Decoder1                    <= "0000000000001" when Mem_Out(11 downto 8) = "0001" else 
                                   "0000000000010" when Mem_Out(11 downto 8) = "0010" else 
                                   "0000000000100" when Mem_Out(11 downto 8) = "0011" else 
                                   "0000000001000" when Mem_Out(11 downto 8) = "0100" else 
                                   "0000000010000" when Mem_Out(11 downto 8) = "0101" else 
                                   "0000000100000" when Mem_Out(11 downto 8) = "0110" else 
                                   "0000001000000" when Mem_Out(11 downto 8) = "0111" else 
                                   "0000010000000" when Mem_Out(11 downto 8) = "1000" else
                                   "0000100000000" when Mem_Out(11 downto 8) = "1001" else
                                   "0001000000000" when Mem_Out(11 downto 8) = "1010" else
                                   "0010000000000" when Mem_Out(11 downto 8) = "1011" else
                                   "0100000000000" when Mem_Out(11 downto 8) = "1011" else
                                   "1000000000000" when Mem_Out(11 downto 8) = "1011" else
                                   "0000000000000";

    Reg_Area1                   <= Mem_Out(6 downto 0) when Decoder2= "001" else "0000000";
    Reg_Area2                   <= Mem_Out(6 downto 0) when Decoder2= "010" else "0000000";
    Reg_Area3                   <= Mem_Out(6 downto 0) when Decoder2= "100" else "0000000";
    
    LC_Equal_LR                 <= '1' when Loop_Counter = unsigned(Loop_Register) and Loop_Counter > 0 else '0';
    LC_Equal_LR_extend          <= LC_Equal_LR or LC_Equal_LR_latch;
    TC_Equal_Zero               <= '1' when Transfer_Counter = x"0000" else '0';
    PEC_WE_extend               <= PEC_WE or PEC_WE_latch;
    

    process(clk, reset)
    begin
        if reset = '1' then
            Load_MD_Reg_i               <= '0';
            Step_MDC_i                  <= '0';
            Reset_BC_i                  <= '0';
            Load_PCIe_CMD_Reg_i         <= '0';
            Control_Data_Out            <= (others => '0');
            LC_Equal_LR_latch           <= '0';
            PEC_WE_latch                <= '0';
            Control_Data                <= (others => '0');               
            Load_Mux_Reg_i              <= '0';
            Load_LR                     <= '0';
            Load_PEC_Reg_i              <= '0'; 
            Load_Tag_Shift_Counter_i    <= '0';
            Load_Return_Reg1            <= '0';
            Load_Return_Reg2            <= '0';
            Load_REQ_FF                 <= '0';
            Load_NOC_reg_i              <= '0';
            Sync_pulse                  <= '0';
            En_RM_i                     <= '0';
            En_IO_Data                  <= '0';
            Start_TAG_Shift_i           <= '0';
            Load_TC                     <= '0';
            Load_GPP_CMD_i              <= '0';  
            Reset_MDC_i                 <= '0';           
            Step_LC                     <= '0';
            Decr_TC                     <= '0';
            Reset_LC_i                  <= '0';
            Loop_Counter                <= (others => '0');
            Loop_Register               <= (others => '0');
            Transfer_Counter            <= (others => '0');
            Return_Reg1                 <= (others => '0');
            Return_Reg2                 <= (others => '0');
            Address_Counter             <= (others => '0');
            TP_Interchange              <= '0';
            Load_NOC_cmd_reg            <= '0';
            En_TP                       <= '0';
            Reset_TPC                   <= '0';
            En_IO_Ctrl                  <= '0';
            Load_RM_Address             <= '0';
            boot_FF                     <= '0';
            NOC_Ready                   <= '0';
            TC_mux_ctrl                 <= '0';
            load_Mode_reg               <= '0';
            Load_TSDiv16_reg            <= '0';
            
        elsif rising_edge(clk) then
            FF                          <= not(boot_FF);
            LC_Equal_LR_latch           <= LC_Equal_LR;
            PEC_WE_latch                <= PEC_WE;
            Control_Data                <= Mem_Out(7 downto 0);
            Control_Data_Out            <= Mem_Out(7 downto 0);
            MSB_as                      <= Mem_Out(27);
            
            Load_Mux_Reg_i              <= Decoder1(0);
            load_Mode_reg               <= Decoder1(1);
            Load_LR                     <= Decoder1(2);
            Load_PEC_Reg_i              <= Decoder1(3);    
            Load_Tag_Shift_Counter_i    <= Decoder1(4);
            Load_Return_Reg1            <= Decoder1(5);
            Load_Return_Reg2            <= Decoder1(6);
            Step_BC                     <= Decoder1(7);
            Load_IR                     <= Decoder1(8);
            Load_GPP_CMD_i              <= Decoder1(9);
            load_program_mem            <= Decoder1(10);
            
            Load_NOC_reg_i              <= Mem_Out(12);
            TP_Interchange              <= Mem_Out(13);
            En_TP                       <= Mem_Out(14);
            En_RM_i                     <= Mem_Out(15);
            Sync_pulse                  <= Mem_Out(16);
            En_IO_Data                  <= Mem_Out(17);
            
            Start_TAG_Shift_i           <= Decoder2(0) and Mem_Out(0); 
            Load_RM_Address             <= Decoder2(0) and Mem_Out(1);
            Reset_TPC                   <= Decoder2(0) and Mem_Out(3);            
            Load_TC                     <= Decoder2(0) and Mem_Out(4);
            TC_mux_ctrl                 <= Decoder2(0) and Mem_Out(5);
            				
            NOC_Ready                   <= Decoder2(1) and Mem_Out(1);
            Write_REQ                   <= Decoder2(1) and Mem_Out(2);
            Load_Boot_FF                <= Decoder2(1) and Mem_Out(3);
            FF_data                     <= Decoder2(1) and Mem_Out(4);
            Reset_Boot_as_counter       <= Decoder2(1) and Mem_Out(5);
            ERROR                       <= Decoder2(1) and Mem_Out(6);                  
            
            Step_LC                     <= Decoder2(2) and Mem_Out(2);
            Reset_IR                    <= Decoder2(2) and Mem_Out(3);
            Decr_TC                     <= Decoder2(2) and Mem_Out(4);
            Reset_LC_i                  <= Decoder2(2) and Mem_Out(5);
            Reset_BC_i                  <= Decoder2(2) and Mem_Out(6); 
            
            if Reset_Boot_as_counter = '1' then
                boot_as_counter   <= (others => '0');
            elsif load_program_mem = '1' then
                boot_as_counter   <= boot_as_counter + 1;
            end if;
            if Load_Boot_FF = '1' then
                boot_FF   <= FF_data;
            end if;            

            if Reset_LC_i = '1' then 
                Loop_Counter    <= (others => '0');
            elsif Step_LC = '1' then
                Loop_Counter    <= Loop_Counter + 1;
            end if;    

            if Load_LR = '1' then
                Loop_Register   <= Loop_Mux;
            end if;
            
            if Load_TC = '1' then
                if TC_mux_ctrl = '0' then 
                    Transfer_Counter <= unsigned(TS);
                else
                    Transfer_Counter <= unsigned("0000" & TSDiv16_Reg);
                end if;    
            elsif Decr_TC ='1' then
                Transfer_Counter <= Transfer_Counter - 1;
            end if;      
            
            if Load_AS_Counter = '1' then
                Address_Counter   <=  unsigned(AS_Counter_Mux);
            elsif Enable_AS_Counter = '1' then
                Address_Counter   <= Address_Counter + 1;
            end if;

            if Load_Return_Reg1 = '1' then 
                Return_Reg1     <=  MSB_as & Control_Data;
            end if;
            
            if Load_Return_Reg2 = '1' then 
                Return_Reg2     <=  MSB_as & Control_Data;
            end if;
        end if; --reset
    end process;        
                        
end Behavioral;