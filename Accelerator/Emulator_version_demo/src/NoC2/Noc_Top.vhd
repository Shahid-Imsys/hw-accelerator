----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 22:26:06
-- Design Name: 
-- Module Name: Noc_Top - structural 
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

entity Noc_Top is
  Port (
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
end Noc_Top;

architecture structural of Noc_Top is

    component Noc_State_Machine is
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
        Write_ack               : in  std_logic;
        CMD_FF                  : in  std_logic;
        Opcode                  : in  std_logic_vector(11 downto 0);
        Loop_reg_mux_ctrl       : in  std_logic;
        Load_RM_Address         : out std_logic;  
        Load_NOC_Reg            : out std_logic;  
        Load_PEC_Reg            : out std_logic;  
        Load_REQ_FF             : out std_logic;          
        Load_GPP_CMD_Reg        : out std_logic;
        Reset_MDC               : out std_logic;
        Load_MD_Reg             : out std_logic;
        Step_MDC                : out std_logic;
        En_RM                   : out std_logic;                        
        Start_Tag_Shift         : out std_logic;                        
        Load_Tag_Shift_Counter  : out std_logic;                      
        Step_BC                 : out std_logic;  
        Reset_BC                : out std_logic;        
        Load_Mux_Reg            : out std_logic; 
        Control_Data_Out        : out std_logic_vector(7 downto 0);
        PEC_TS_Reg              : out std_logic_vector(15 downto 0);              
        Load_NOC_cmd_reg        : out std_logic;
        En_TP_write             : out std_logic;
        En_TP_read              : out std_logic;
        Reset_TPC               : out std_logic;
        TP_Interchange          : out std_logic;
        NOC_Ready               : out std_logic;
        En_IO_Data              : out std_logic;
        En_IO_Ctrl              : out std_logic;
        Sync_pulse              : out std_logic;
        load_Mode_reg           : out std_logic;
        Load_TSDiv16_reg        : out std_logic                            
    );
    end component;
        
    component CMD_from_GPP is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        GPP_CMD_Flag            : in  std_logic;
        Load_GPP_CMD_reg        : in  std_logic;
        Load_TSDiv16_reg        : in  std_logic;
        GPP_CMD_Data            : in  std_logic_vector(127 downto 0);
        Opcode                  : out std_logic_vector(7  downto 0);
        Switch_ctrl             : out std_logic_vector(7 downto 0);
        Transfer_size           : out std_logic_vector(15 downto 0);
        RM_address              : out std_logic_vector(15 downto 0);
        CM_Address0             : out std_logic_vector(14 downto 0);
        CM_Address1             : out std_logic_vector(14 downto 0);
        Padding_Data            : out std_logic_vector(7 downto 0);
        Length                  : out std_logic_vector(15 downto 0);
        Address                 : out std_logic_vector(31 downto 0);        
        CMD_FF                  : out std_logic;
        TSDiv16_Reg             : out std_logic_vector(11 downto 0)
    );
    end component;
  
    component CMD_to_GPP is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        PEC_ready               : in  std_logic;
        NOC_Ready               : in  std_logic;
        GPP_ACK                 : in  std_logic;
        NOC_CMD_flag            : out std_logic;
        En_CMD                  : out std_logic;
        NOC_CMD_Data            : out std_logic_vector(1 downto 0)
    );
    end component;
    
    component Mux_Demux is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        IO_Data                 : in  std_logic_vector(127 downto 0);
        Switch_Data             : in  std_logic_vector(127 downto 0);
        Data_Direction          : in  std_logic;  -- 0 downstream (IO Data)  -- 1 upstream (Switch Data)
        Mux_Demux_out0          : out std_logic_vector(127 downto 0);
        Mux_Demux_out1          : out std_logic_vector(127 downto 0)
    );       
    end component;
    
    component Transpose_unit is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        Reset_TPC               : in  std_logic;
        En_TP_write             : in  std_logic;
        En_TP_read              : in  std_logic;
        Data_dir                : in  std_logic;
        TP_Interchange          : in  std_logic;                                       
        IO_data                 : in  std_logic_vector(127 downto 0);
        switch_data             : in  std_logic_vector(127 downto 0);
        Noc_reg_mux             : out std_logic_vector(127 downto 0);
        Noc_data_mux            : out std_logic_vector(127 downto 0)  
    );
    end component;
    
    component Root_Memory is
    Port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        Write_Read_Mode         : in  std_logic;
        Enable                  : in  std_logic;
        Load_RM_Address         : in  std_logic;
        RM_Address              : in  std_logic_vector(12 downto 0);
        DataIn                  : in  std_logic_vector(127 downto 0);
        DataOut                 : out std_logic_vector(127 downto 0)  
    );
    end component;
    
    component Noc_Input_Reg is
    Port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        write_enable            : in  std_logic;
        NoC_Input_reg_In        : in  std_logic_vector(127 downto 0);
        NoC_Input_reg_Out       : out std_logic_vector(127 downto 0)
    );
    end component;         

    component Noc_Register is
    Port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        Mux_select              : in  std_logic_vector(1 downto 0);
        Input_reg_data          : in  std_logic_vector(127 downto 0);
        Root_Memory_data        : in  std_logic_vector(127 downto 0);
        TP_data                 : in  std_logic_vector(127 downto 0);
        Mux_Demux_data          : in  std_logic_vector(127 downto 0);
        Load_NOC_reg            : in  std_logic;		
        Noc_Reg_out             : out std_logic_vector(127 downto 0)  
    );
    end component;
    
    component Switch is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        switch_Input            : in  std_logic_vector(127 downto 0);
        Decoder                 : in  std_logic_vector(15 downto 0);
        switch_input_muxes      : in  std_logic_vector(2 downto 0);
        switch_Noc_bus_mux      : in  std_logic;
        Noc_bus_out             : out std_logic_vector(127 downto 0);
        switch_out              : out std_logic_vector(127 downto 0)    
    );        
    end component;
    
    component Byte_counter_decoder is
    port(
	    clk                     : in  std_logic;
	    Reset                   : in  std_logic;
	    Reset_BC                : in  std_logic;
	    Step_BC                 : in  std_logic;
	    Decoder                 : out std_logic_vector(15 downto 0);
	    byte_counter            : out std_logic_vector(4 downto 0)
    );
    end component;
    
    component Mux_Register is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        Load_Mux_Reg            : in  std_logic;
        Control_Data            : in  std_logic_vector(7 downto 0);
        NOC_reg_mux_ctrl        : out std_logic_vector(1 downto 0);
        NOC_data_mux_ctrl       : out std_logic;
        Data_dir                : out std_logic;
        NOC_bus_out_mux_ctrl    : out std_logic;
        Loop_reg_mux_ctrl       : out std_logic;
        R_W_RM                  : out std_logic
    );        
    end component;
    
    component Tag_Line_Block is
    Port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;       
        Load_Tag_Shift_Counter  : in  std_logic;
        Start_Tag_Shift         : in  std_logic;
        Shift_Count             : in  std_logic_vector(7 downto 0); 
        Load_TAG_Cmd_reg        : in  std_logic;
        Load_TAG_Arg_reg        : in  std_logic;
        PEC_AS0                 : in  std_logic_vector(14 downto 0);
        PEC_AS1                 : in  std_logic_vector(14 downto 0);
        PEC_TS                  : in  std_logic_vector(15 downto 0);
        PEC_CMD                 : in  std_logic_vector( 5 downto 0);
        Tag_Line                : out std_logic;
        TAG_shift               : out std_logic             
    );
    end component;
    
    --NOC_State Machine
    signal TAG_shift            : std_logic;
    signal Transfer_size        : std_logic_vector(15 downto 0);
    signal CMD_FF               : std_logic;
    signal Opcode               : std_logic_vector(11 downto 0);
    signal Loop_reg_mux_ctrl    : std_logic;
    signal Load_RM_Address      : std_logic;
    signal Load_NOC_Reg         : std_logic;
    signal Load_PEC_Reg         : std_logic;
    signal Load_REQ_FF          : std_logic;
    signal Load_GPP_CMD_Reg     : std_logic;
    signal Reset_MDC            : std_logic;
    signal Load_MD_Reg          : std_logic;
    signal Step_MDC             : std_logic;
    signal En_RM                : std_logic;
    signal Start_Tag_Shift      : std_logic;
    signal Load_Tag_Shift_Counter : std_logic;
    signal Step_BC              : std_logic;
    signal Reset_BC             : std_logic;
    signal Load_Mux_Reg         : std_logic;
    signal Control_Data_Out     : std_logic_vector(7 downto 0);
    signal PEC_TS_Reg           : std_logic_vector(15 downto 0);
    signal Load_NOC_cmd_reg     : std_logic;
    signal En_TP_write          : std_logic;
    signal En_TP_read           : std_logic;
    signal Reset_TPC            : std_logic;
    signal TP_Interchange       : std_logic;
    signal NOC_Ready            : std_logic;
    signal Sync_pulse_i         : std_logic;
    signal load_Mode_reg        : std_logic;
    signal Load_TSDiv16_reg     : std_logic;              

    --CMD_From_GPP
    signal Switch_ctrl          : std_logic_vector(7 downto 0); 
    signal RM_address           : std_logic_vector(15 downto 0);
    signal CM_Address0          : std_logic_vector(14 downto 0);
    signal CM_Address1          : std_logic_vector(14 downto 0);
    signal Padding_Data         : std_logic_vector(7 downto 0);
    signal TSDiv16_Reg          : std_logic_vector(11 downto 0);
    --MUX_DEMUX
    signal Switch_Data          : std_logic_vector(127 downto 0);
    signal Data_Direction       : std_logic;
    signal Mux_Demux_out0       : std_logic_vector(127 downto 0);
    signal Mux_Demux_out1       : std_logic_vector(127 downto 0);
    signal Noc_reg_mux          : std_logic_vector(127 downto 0);
    signal Noc_data_mux         : std_logic_vector(127 downto 0);
    --Root_Memory
    signal R_W_RM               : std_logic;
    signal RM_Data_Out          : std_logic_vector(127 downto 0);
    --NoC_INPUT_REG
    signal NoC_Input_reg_Out    : std_logic_vector(127 downto 0);
    --NOC REG
    signal NOC_reg_mux_ctrl     : std_logic_vector(1 downto 0);
    signal Noc_Reg_out          : std_logic_vector(127 downto 0);
    --Switch
    signal Decoder              : std_logic_vector(15 downto 0);
    signal NOC_bus_out_mux_ctrl : std_logic;
    --Byte_counter_decoder
    signal byte_counter         : std_logic_vector(4 downto 0);
    --Mux_Register
    signal NOC_data_mux_ctrl    : std_logic;
    signal Tag_Line_pre         : std_logic;
    --
    signal REQ_FF               : std_logic; 
    signal Mode_reg             : std_logic_vector(1 downto 0);
    signal Enable_Root_memory   : std_logic;
    signal En_IO_Data_SM        : std_logic;       
    
begin

    Tag_Line        <= Tag_Line_pre or Sync_pulse_i;
    Sync_pulse      <= Sync_pulse_i;
    Write_REQ       <= REQ_FF;
    
	process(clk, Reset)
	begin
		if Reset = '1' then
            REQ_FF   <= '0';
            Mode_reg <= (others => '0');
		elsif rising_edge (clk) then
			if (Load_REQ_FF = '1') then 
                REQ_FF   <= Control_Data_Out(0);
			end if;
			if (load_Mode_reg = '1') then
		        Mode_reg <= Control_Data_Out(1 downto 0);
		    end if;    
		end if;	
	end process;
	
	Enable_Root_memory     <= Mode_reg(1) and En_RM;
	En_IO_Data             <= Mode_reg(0) and En_IO_Data_SM;  
        
    Noc_State_Machine_Inst: Noc_State_Machine
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        IO_data                 => IO_data,
        FIFO_Ready1             => FIFO_Ready1,
        FIFO_Ready2             => FIFO_Ready2,
        FIFO_Ready3             => FIFO_Ready3,        
        TAG_shift               => TAG_shift,                   
        TS                      => Transfer_size,
        TSDiv16_Reg             => TSDiv16_Reg,
        PEC_Ready               => PEC_Ready,
        Write_ack               => Write_ack,
        CMD_FF                  => CMD_FF,
        Opcode                  => Opcode,
        Loop_reg_mux_ctrl       => Loop_reg_mux_ctrl,
        --OUTPIUT
        Load_RM_Address         => Load_RM_Address,
        Load_NOC_Reg            => Load_NOC_Reg,
        Load_PEC_Reg            => Load_PEC_Reg,
        Load_REQ_FF             => Load_REQ_FF,                
        Load_GPP_CMD_Reg        => Load_GPP_CMD_Reg,
        Reset_MDC               => Reset_MDC,
        Load_MD_Reg             => Load_MD_Reg,
        Step_MDC                => Step_MDC,
        En_RM                   => En_RM,    
        Start_Tag_Shift         => Start_Tag_Shift,              
        Load_Tag_Shift_Counter  => Load_Tag_Shift_Counter,    
        Step_BC                 => Step_BC,            
        Reset_BC                => Reset_BC,          
        Load_Mux_Reg            => Load_Mux_Reg,  
        Control_Data_Out        => Control_Data_Out,
        PEC_TS_Reg              => PEC_TS_Reg,                     
        Load_NOC_cmd_reg        => Load_NOC_cmd_reg,
        En_TP_write             => En_TP_write,     
        En_TP_read              => En_TP_read,        
        Reset_TPC               => Reset_TPC,
        TP_Interchange          => TP_Interchange,        
        NOC_Ready               => NOC_Ready,
        En_IO_Data              => En_IO_Data_SM,
        En_IO_Ctrl              => En_IO_Ctrl,
        Sync_pulse              => Sync_pulse_i,
        load_Mode_reg           => load_Mode_reg,
        Load_TSDiv16_reg        => Load_TSDiv16_reg                               
    );
    
    CMD_from_GPP_Inst: CMD_from_GPP
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        GPP_CMD_Flag            => GPP_CMD_Flag,
        Load_GPP_CMD_reg        => Load_GPP_CMD_reg,
        Load_TSDiv16_reg        => Load_TSDiv16_reg,
        GPP_CMD_Data            => GPP_CMD_Data,        --INPUT to Noc_top?
        Opcode                  => Opcode(7 downto 0),  --LOWER bits of OPCODE?
        Switch_ctrl             => Switch_ctrl,
        Transfer_size           => Transfer_size,
        RM_address              => RM_address,
        CM_Address0             => CM_Address0,
        CM_Address1             => CM_Address1,
        Padding_Data            => Padding_Data,        --INPUT to where?
        Length                  => Length,              --INPUT to where?
        Address                 => Address,             --INPUT to where?
        CMD_FF                  => CMD_FF,
        TSDiv16_Reg             => TSDiv16_Reg       
    );
    
    CMD_to_GPP_Inst: CMD_to_GPP
    port map
    (
        clk                     => clk,
        Reset                   => Reset,    
        PEC_ready               => PEC_ready,
        NOC_Ready               => NOC_Ready,
        GPP_ACK                 => GPP_ACK,
        NOC_CMD_flag            => NOC_CMD_flag,         --NOC output?
        En_CMD                  => En_CMD,               --NOC output?
        NOC_CMD_Data            => NOC_CMD_Data          --NOC output?
    );
    
    Mux_Demux_Inst: Mux_Demux
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        IO_Data                 => IO_Data,
        Switch_Data             => Switch_Data,
        Data_Direction          => Data_Direction,
        Mux_Demux_out0          => Mux_Demux_out0,
        Mux_Demux_out1          => Mux_Demux_out1
    );

    Transpose_unit_Inst: Transpose_unit
    port map
    (
        clk                     => clk,
        Reset                   => Reset,    
        Reset_TPC               => Reset_TPC,
        En_TP_write             => En_TP_write,
        En_TP_read              => En_TP_read,
        Data_dir                => Data_Direction,
        TP_Interchange          => TP_Interchange,
        IO_data                 => IO_data,
        switch_data             => switch_data,
        Noc_reg_mux             => Noc_reg_mux,
        Noc_data_mux            => Noc_data_mux
    );
    
    Root_Memory_Inst: Root_Memory
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        Write_Read_Mode         => R_W_RM,  -- from Mux_register
        Enable                  => Enable_Root_memory,
        Load_RM_Address         => Load_RM_Address,
        RM_Address              => RM_Address(12 downto 0),
        DataIn                  => switch_data,
        DataOut                 => RM_Data_Out
     );
 
    Noc_Input_Reg_Inst: Noc_Input_Reg
    port map
    (
        clk                     => clk,
        Reset                   => Reset,    
        write_enable            => write_enable,
        NoC_Input_reg_In        => NOC_bus_in,
        NoC_Input_reg_Out       => NoC_Input_reg_Out
    );
    
    Noc_Register_Inst: Noc_Register
    port map
    (
        clk                     => clk,
        Reset                   => Reset,      
        Mux_select              => NOC_reg_mux_ctrl,   
        Input_reg_data          => NoC_Input_reg_Out,
        Root_Memory_data        => RM_Data_Out,
        TP_data                 => Noc_reg_mux,
        Mux_Demux_data          => Mux_Demux_out0,
        Load_NOC_reg            => Load_NOC_reg,	
        Noc_Reg_out             => Noc_Reg_out
    );
    
    Switch_Inst: Switch
    port map
    (
        clk                     => clk,
        Reset                   => Reset, 
        switch_Input            => Noc_Reg_out,
        Decoder                 => Decoder,
        switch_input_muxes      => Switch_ctrl(2 downto 0),  ---???? 3 or 8?
        switch_Noc_bus_mux      => NOC_bus_out_mux_ctrl,
        Noc_bus_out             => Noc_bus_out,
        switch_out              => switch_data
    );
    
    Byte_counter_decoder_Inst: Byte_counter_decoder
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
	    Reset_BC                => Reset_BC,
	    Step_BC                 => Step_BC,
	    Decoder                 => Decoder,
	    byte_counter            => byte_counter    
    );

    Mux_Register_Inst: Mux_Register
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        Load_Mux_Reg            => Load_Mux_Reg,
        Control_Data            => Control_Data_Out,
        NOC_reg_mux_ctrl        => NOC_reg_mux_ctrl,
        NOC_data_mux_ctrl       => NOC_data_mux_ctrl,
        Data_dir                => Data_Direction,
        NOC_bus_out_mux_ctrl    => NOC_bus_out_mux_ctrl,
        Loop_reg_mux_ctrl       => Loop_reg_mux_ctrl,
        R_W_RM                  => R_W_RM
    );
  
    Tag_Line_Block_Inst: Tag_Line_Block
    port map
    (
        clk                     => clk,
        Reset                   => Reset,
        Load_Tag_Shift_Counter  => Load_Tag_Shift_Counter,
        Start_Tag_Shift         => Start_Tag_Shift,
        Shift_Count             => Control_Data_Out,
        Load_TAG_Cmd_reg        => Load_PEC_Reg,
        Load_TAG_Arg_reg        => Load_PEC_Reg,
        PEC_AS0                 => CM_Address0,
        PEC_AS1                 => CM_Address1,
        PEC_TS                  => PEC_TS_Reg,
        PEC_CMD                 => Control_Data_Out(5 downto 0),
        Tag_Line                => Tag_Line_pre,
        TAG_shift               => TAG_shift
    );
                   
end structural;
