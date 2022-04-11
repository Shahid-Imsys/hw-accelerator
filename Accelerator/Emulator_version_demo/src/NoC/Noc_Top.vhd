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
-- Title      : Noc Top Module
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Noc_Top.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.24
-------------------------------------------------------------------------------
-- Description: Noc Top Module
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
library work;
use work.ACC_types.all;

entity Noc_Top is
    port(
        clk                 : in    std_logic;
        Gated_clk_from_PEC  : in    std_logic;
        Reset               : in    std_logic;
        
        --PCIe side
        PCIe_data           : in    std_logic_vector(255 downto 0); -- pcie data is 32 byte
        Noc_data            : out   std_logic_vector(255 downto 0);
        PCIe_address        : out   std_logic_vector(31 downto 0);  --Q 32 in command decoder 24 in PBdoc?                        
        PCIe_length         : out   std_logic_vector(4 downto 0); 
        PCIe_ready          : in    std_logic;                      --state machine
        CMD_flag            : in    std_logic;                      --command decoder
        Noc_CMD_flag        : out   std_logic;
        R_W_PCIe            : out   std_logic;
        En_PCIe_ctrl        : out   std_logic; 
        En_PCIe_Data        : out   std_logic;    
        PCIe_req            : out   std_logic;               
        PCIe_ack            : in    std_logic;                      --state machine
        
        --CC side     
        PEC_ready           : in    std_logic;                      --state machine
        NOC_bus_In          : in    std_logic_vector(15 downto 0);
        NOC_bus_Out         : out   std_logic_vector(15 downto 0);  --switch output
        NOC_bus_dir         : out   std_logic;      
        Tag_Line            : out   std_logic;
        
        --Test
        h2c_cmd_t           : in    std_logic;
        c2h_cmd_t           : in    std_logic;
        pcie_wr_data_wrs_t  : in    std_logic;
        pcie_wr_ctl_wrs_t   : in    std_logic  
    );
end Noc_Top;


architecture structure of Noc_Top is

    component Mux_Demux is
    Port(
        clk               : in  std_logic;
        reset             : in  std_logic;        
        PCIe_Switch       : in  std_logic;
        Load_MD_Reg       : in  std_logic;
        Step_MDC          : in  std_logic;
        Reset_MDC         : in  std_logic;
        Switch_data       : in  std_logic_vector(15 downto 0);      
        PCIe_data         : in  std_logic_vector(255 downto 0);
        Noc_reg_data      : out std_logic_vector(255 downto 0);
        Noc_data_mux_out  : out std_logic_vector(255 downto 0)
        );
    end component;
    
    component NOC_reg_mux is
    Port(
        clk               : in  std_logic;
        reset             : in  std_logic;
        select_mux        : in  std_logic_vector(1 downto 0);
        Input_reg_data    : in  std_logic_vector(15 downto 0);
        Root_Memory_data  : in  std_logic_vector(15 downto 0);
        Mux_Demux_data    : in  std_logic_vector(255 downto 0);
        Dataout_mux       : out std_logic_vector(255 downto 0)
        );
    end component;    

    component Root_Memory is
    Port (
        clk               : in  std_logic;
        reset             : in  std_logic;
        Write_Read_Mode   : in  std_logic;
        Enable            : in  std_logic;
        Load_Add_Gen      : in  std_logic;
        Add_Gen_Value     : in  std_logic_vector(12 downto 0);
        DataIn            : in  std_logic_vector(15 downto 0);
        DataOut           : out std_logic_vector(15 downto 0)
     );
    end component;

    component NoC_reg is
    port(		
		clk			  	  : in  std_logic;
        reset             : in  std_logic;		
		Load_NOC_reg      : in  std_logic;		
		Data_input        : in  std_logic_vector(255 downto 0);
		Data_output       : out std_logic_vector(255 downto 0)	
    );
    end component;

    component NoC_Input_reg is
    port(
        clk               : in  std_logic;
		enable			  : in  std_logic;
        reset             : in  std_logic;
        NoC_Input_reg_In  : in  std_logic_vector(15 downto 0);
        NoC_Input_reg_Out : out std_logic_vector(15 downto 0)
        );
    end component;

    component Noc_Switch is        
    port(
        reset             : in  std_logic;
        switch_Input 	  : in	std_logic_vector(255 downto 0);
        switch_Out_en     : in  std_logic;
        decoder           : in	std_logic_vector(31 downto 0);
        switch_mux		  : in	std_logic_vector(3 downto 0);
        switch_Out 		  : out	std_logic_vector(15 downto 0);
        NOC_bus           : out std_logic_vector(15 downto 0)
        );
    end component;

    component Noc_State_Machine is
    port(
        clk                 : in  std_logic;
        Gated_CLK_from_PEC  : in  std_logic;
        Reset               : in  std_logic;
        TAG_shift           : in  std_logic;                        --Tag control
        TS                  : in  std_logic_vector(15 downto 0);    --from command decoder
        PEC_Ready           : in  std_logic;                        --from command decoder  
        PCIe_ack            : in  std_logic;
        PCIe_ready          : in  std_logic;
        CMD_FF              : in  std_logic;                        --from command decoder
        Opcode              : in  std_logic_vector(11 downto 0);    --from command decoder  
        BC                  : in  std_logic_vector(4 downto 0);     --from Byte counter 
        Load_RM_as_gen      : out std_logic; 
        Load_NOC_Reg        : out std_logic;
        Load_PEC_Reg        : out std_logic;
        Load_PCIe_CMD_Reg   : out std_logic;  
        Load_Req_reg        : out std_logic;
        En_PCIe_ctrl        : out std_logic;
        En_PCIe_Data        : out std_logic;
        Load_CMD_Reg        : out std_logic;
        Set_PEC_FF2         : out std_logic;
        Reset_MDC           : out std_logic;
        Load_MD_Reg         : out std_logic;
        Step_MDC            : out std_logic;           
        En_NOC_Transfer     : out std_logic;
        En_RM               : out std_logic;                        --root memory
        R_W_RM              : out std_logic;                        --root memory
        R_W_PCIe            : out std_logic;                        --ext memory 
        Start_Tag_Shift     : out std_logic;                        --Tag Line Controller 
        Load_Tag_Shift_Counter: out std_logic;                      --Tag Line Controller 
        Step_BC             : out std_logic;
        Reset_BC            : out std_logic;        
        Load_Mux_Reg        : out std_logic;
        Control_Data_Out    : out std_logic_vector(7 downto 0);
        --test
        h2c_cmd_t           : in  std_logic;
        c2h_cmd_t           : in  std_logic;
        pcie_wr_data_wrs_t  : in  std_logic;
        pcie_wr_ctl_wrs_t   : in  std_logic;
        CMD_flag_t          : in  std_logic;
        Noc_CMD_flag_t      : in  std_logic;
        PCIe_req_t          : in  std_logic;
        Address_Counter_t   : out std_logic_vector(7 downto 0)
    );
    end component;
        
    component Command_Decoder is
    Port(
        clk                 : in    std_logic;
        reset               : in    std_logic;
        PEC_Ready_In        : in    std_logic;
        Set_PEC_FF2         : in    std_logic;
        CMD_flag            : in    std_logic;
        Load_CMD_reg        : in    std_logic;
        Noc_data            : in    std_logic_vector(95 downto 0);  -- NOC data (from PCIe 16 lower bytes of pcie data) 16 bytes and lower bits are used
        MD_PCIe_cmd         : in    std_logic;                      --from mux reg
        PEC_Ready_Out       : out   std_logic;
        CMD_FF              : out   std_logic;
        Opcode              : out   std_logic_vector(11 downto 0);
        Switch_ctrl         : out   std_logic_vector(3 downto 0);
        Transfer_size       : out   std_logic_vector(15 downto 0);
        RM_Address          : out   std_logic_vector(15 downto 0);
        PCIe_Address        : out   std_logic_vector(31 downto 0);
        PEC_TS_reg          : out   std_logic_vector(14 downto 0);
        PEC_Address_reg     : out   std_logic_vector(14 downto 0);
        PCIe_length         : out   std_logic_vector(4 downto 0)            
    );
    end component;
    
    component Mux_Reg is
    port(
        clk                 : in  std_logic;
        reset               : in  std_logic;
        Load_Mux_Reg        : in  std_logic;
        Control_Data        : in  std_logic_vector(7 downto 0);
        NoC_Reg_Mux         : out std_logic_vector(1 downto 0);
        MD_PCIe_cmd         : out std_logic;
        PCIedata_Switch     : out std_logic;
        Noc_Bus_Dir         : out std_logic
    );
    end component;
    
    component Tag_Line_Controller is
    port(
        clk                     : in  std_logic;
        reset                   : in  std_logic;
        Load_Tag_Shift_Counter  : in  std_logic;
        Start_Tag_Shift         : in  std_logic;
        Shift_Count             : in  std_logic_vector(7 downto 0);
        Tag_shift               : out std_logic
    );
    end component;
    
    component Tag_Interface is    
    port(
        clk                 : in    std_logic;
        reset               : in    std_logic;
        Load_TAG_Cmd_reg    : in    std_logic;
        Load_TAG_Arg_reg    : in    std_logic;
        Tag_shift           : in    std_logic;
        PEC_AS              : in    std_logic_vector(14 downto 0);
        PEC_TS              : in    std_logic_vector(14 downto 0);
        PEC_CMD             : in    std_logic_vector( 5 downto 0);
        Tag_Line            : out   std_logic
    );
    end component;
    
    component Broadcast_Byte is
    port(
	    clk                  : in    std_logic;
	    reset                : in    std_logic;
	    Reset_BC             : in    std_logic;
	    Step_BC              : in    std_logic;
	    decoder              : out	 std_logic_vector(31 downto 0);
	    byte_counter         : out   std_logic_vector(4 downto 0)
    );
    end component;
    
    component PCIe_Data_block is
    port(
        clk                 : in  std_logic;
        reset               : in  std_logic;
        Load_PCIe_CMD_reg   : in  std_logic;
        MD_PCIe_cmd         : in  std_logic;        
        Data_Input          : in  std_logic_vector(7 downto 0);
        Mux_Demux_data      : in  std_logic_vector(255 downto 0);
        Noc_data            : out std_logic_vector(255 downto 0)
    );
    end component;
    
    component PCIe_Request is
    port(
        clk                : in  std_logic;
        reset              : in  std_logic;
        Data_in            : in  std_logic_vector(1 downto 0);
        enable             : in  std_logic;
        PCIe_Request_out   : out std_logic_vector(1 downto 0)
    );
    end component;
    
-- COMPONENT ila_7
-- PORT (
	-- clk : IN STD_LOGIC;
	-- probe0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	-- probe1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	-- probe2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
	-- probe3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	-- probe4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	-- probe5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
	-- probe6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	-- probe7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	-- probe8 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	-- probe9 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
	-- probe10 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    -- probe11 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	-- probe12 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	-- probe13 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	-- probe14 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	-- probe15 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	-- probe16 : IN STD_LOGIC_VECTOR(12 DOWNTO 0); 
	-- probe17 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- probe18 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- probe19 : in STD_LOGIC_VECTOR (31 DOWNTO 0)
-- );
-- END COMPONENT  ;

    --Noc_State_Machine signals
    signal  Byte_counter                : std_logic_vector(4 downto 0);
    signal  Load_RM_address             : std_logic;
    signal  Load_NOC_Reg                : std_logic;
    signal  Start_Tag_Shift             : std_logic;
    signal  Load_Tag_Shift_Counter      : std_logic;
    signal  Load_PEC_Reg                : std_logic;
    signal  En_RM                       : std_logic;
    signal  R_W_RM                      : std_logic;
    signal  Step_BC                     : std_logic;
    signal  Reset_BC                    : std_logic;      
    signal  Load_Mux_Reg                : std_logic;
    signal  Control_Data_Out            : std_logic_vector(7 downto 0);
    signal  Tag_shift                   : std_logic;
    signal  Reset_MDC                   : std_logic;
    signal  Load_MD_Reg                 : std_logic;
    signal  Step_MDC                    : std_logic;
    signal  Load_PCIe_CMD_Reg           : std_logic;
    signal  Load_Req_reg                : std_logic;
    signal  En_Noc_Transfer             : std_logic;
    signal  Address_Counter_t           : std_logic_vector(7 downto 0);
    --command decoder signals
    signal  Set_PEC_FF2                 : std_logic;
    signal  Load_CMD_reg                : std_logic;
    signal  MD_PCIe_cmd                 : std_logic; 
    signal  PEC_Ready_Out               : std_logic;
    signal  PEC_Ready_CD                : std_logic;
    signal  CMD_FF                      : std_logic;
    signal  Opcode                      : std_logic_vector(11 downto 0);
    signal  Switch_Ctrl                 : std_logic_vector(3 downto 0);
    signal  Transfer_Size               : std_logic_vector(15 downto 0);
    signal  RM_Address                  : std_logic_vector(15 downto 0);
    signal  PEC_TS_reg                  : std_logic_vector(14 downto 0);
    signal  PEC_Address_reg             : std_logic_vector(14 downto 0);
    --Mux reg
    signal  NoC_Reg_Mux_Select          : std_logic_vector(1 downto 0);
    signal  PCIedata_Switch             : std_logic;
    --Root Memory
    signal  RM_DataIn                   : std_logic_vector(15 downto 0);
    signal  RM_DataOut                  : std_logic_vector(15 downto 0);
    --NoC_Input_reg
    signal  NoC_Input_reg_Out           : std_logic_vector(15 downto 0);
    --NoC_reg
	signal	Noc_reg_DataIn              : std_logic_vector(255 downto 0);
	signal	Noc_reg_DataOut             : std_logic_vector(255 downto 0);
    --Noc_Switch
    signal  Noc_Switch_Out              : std_logic_vector(15 downto 0);
    signal  NOC_bus_Output              : std_logic_vector(15 downto 0);
    signal  NOC_bus_direction           : std_logic;
    --Broadcast_Byte
    signal  decoder                     : std_logic_vector(31 downto 0);
    --PCIe_Data_block
    signal  Noc_data_Mux_Demux          : std_logic_vector(255 downto 0);
    --Mux_Demux
    signal  Noc_reg_mux_data            : std_logic_vector(255 downto 0);
    signal  PCIe_request_out            : std_logic_vector( 1 downto 0);
	signal  Noc_data_i                  : std_logic_vector(255 downto 0);
    --test
    signal  Noc_CMD_flag_t              : std_logic;
    signal  PCIe_req_t                  : std_logic;
    signal  PCIe_req_i                  : std_logic;
    signal  Noc_CMD_flag_i              : std_logic;
   --ILA signals
    -- signal probe0_i                     : std_logic_vector(15 downto 0);         
    -- signal probe1_i                     : std_logic_vector(15 downto 0);
    -- signal probe2_i                     : std_logic_vector(1 downto 0);
    -- signal probe3_i                     : std_logic_vector(15 downto 0);
    -- signal probe4_i                     : std_logic_vector(15 downto 0);
    -- signal probe5_i                     : std_logic_vector(3 downto 0);
    -- signal probe6_i                     : std_logic_vector(15 downto 0);
    -- signal probe7_i                     : std_logic_vector(0 downto 0);
    -- signal probe8_i                     : std_logic_vector(0 downto 0);
    -- signal probe9_i                     : std_logic_vector(255 downto 0);
    -- signal probe10_i                    : std_logic_vector(63 downto 0);
    -- signal probe11_i                    : std_logic_vector(0 downto 0);
    -- signal probe12_i                    : std_logic_vector(7 downto 0);
    -- signal probe13_i                    : std_logic_vector(0 downto 0);
    -- signal probe14_i                    : std_logic_vector(0 downto 0);
    -- signal probe15_i                    : std_logic_vector(0 downto 0);
    -- signal probe16_i                    : std_logic_vector(12 downto 0);
    -- signal probe17_i                    : std_logic_vector(15 downto 0);
    -- signal probe18_i                    : std_logic_vector(15 downto 0);
    -- signal probe19_i                    : std_logic_vector(31 downto 0);
    				 
begin


    NOC_bus_dir       <= NOC_bus_direction; 
    NOC_bus_Out       <= NOC_bus_Output;
    RM_DataIn         <= NOC_bus_Output;
    PCIe_req_i        <= PCIe_request_out(0);
    Noc_CMD_flag_i    <= PCIe_request_out(1);  
    PCIe_req          <= PCIe_req_i;
    Noc_CMD_flag      <= Noc_CMD_flag_i;
    Noc_data          <= Noc_data_i;
    --test
    Noc_CMD_flag_t   <= Noc_CMD_flag_i;
    PCIe_req_t       <= PCIe_req_i;
       
    Noc_State_Machine_Inst: Noc_State_Machine
    port map(
            clk                 => clk,
            Gated_CLK_from_PEC  => Gated_clk_from_PEC,
            Reset               => Reset,
            TAG_shift           => Tag_shift,
            TS                  => Transfer_Size,           --3 from command decoder
            PEC_Ready           => PEC_Ready_CD,            --3 from command decoder
            PCIe_ack            => PCIe_ack,
            PCIe_ready          => PCIe_ready,
            CMD_FF              => CMD_FF,                  --3 from command decoder
            opcode              => opcode,
            BC                  => Byte_counter,            --3 from Byte counter 
            Load_RM_as_gen      => Load_RM_address,
            Load_NOC_Reg        => Load_NOC_Reg,
            Load_PEC_Reg        => Load_PEC_Reg,
            Load_PCIe_CMD_Reg   => Load_PCIe_CMD_Reg,
            Load_Req_reg        => Load_Req_reg,
            En_PCIe_ctrl        => En_PCIe_ctrl,
            En_PCIe_Data        => En_PCIe_Data,
            Load_CMD_Reg        => Load_CMD_Reg,
            Set_PEC_FF2         => Set_PEC_FF2,
            Reset_MDC           => Reset_MDC,
            Load_MD_Reg         => Load_MD_Reg,
            Step_MDC            => Step_MDC,              
            En_NOC_Transfer     => En_NOC_Transfer,
            En_RM               => En_RM,
            R_W_RM              => R_W_RM,
            R_W_PCIe            => R_W_PCIe,
            Start_Tag_Shift     => Start_Tag_Shift,
            Load_Tag_Shift_Counter =>  Load_Tag_Shift_Counter,
            Step_BC             => Step_BC,
            Reset_BC            => Reset_BC,
            Load_Mux_Reg        => Load_Mux_Reg, 
            Control_Data_Out    => Control_Data_Out,
            --test
            h2c_cmd_t           => h2c_cmd_t,    
            c2h_cmd_t           => c2h_cmd_t, 
            pcie_wr_data_wrs_t  => pcie_wr_data_wrs_t,
            pcie_wr_ctl_wrs_t   => pcie_wr_ctl_wrs_t,
            CMD_flag_t          => CMD_flag,
            Noc_CMD_flag_t      => Noc_CMD_flag_t,
            PCIe_req_t          => PCIe_req_t,
            Address_Counter_t   => Address_Counter_t   
    );
  
    Command_Decoder_Inst: Command_Decoder
    port map(
            clk                 => clk,
            reset               => reset,
            PEC_Ready_In        => PEC_Ready,        --from PEC
            Set_PEC_FF2         => Set_PEC_FF2,      --from state machine  
            CMD_flag            => CMD_flag,         --from pcie
            Load_CMD_reg        => Load_CMD_reg,     --from state machine 
            Noc_data            => PCIe_data(95 downto 0), -- from pcie, length? pcie data is 32 byte
            MD_PCIe_cmd         => MD_PCIe_cmd,
            PEC_Ready_Out       => PEC_Ready_CD,
            CMD_FF              => CMD_FF,
            Opcode              => Opcode,           --to state machine 
            Switch_Ctrl         => Switch_Ctrl,
            Transfer_Size       => Transfer_Size,
            RM_Address          => RM_Address,
            PCIe_Address        => PCIe_Address,
            PEC_TS_reg          => PEC_TS_REG,
            PEC_Address_reg     => PEC_Address_REG,
            PCIe_length         => PCIe_length
    );
  
    Mux_Demux_Inst: Mux_Demux 
    port map(
            clk                => clk,
            reset              => reset,
            PCIe_Switch        => PCIedata_Switch,
            Load_MD_Reg        => Load_MD_Reg,
            Step_MDC           => Step_MDC,
            Reset_MDC          => Reset_MDC,
            Switch_data        => Noc_Switch_Out,  
            PCIe_data          => PCIe_data,
            Noc_reg_data       => Noc_reg_mux_data,
            Noc_data_mux_out   => Noc_data_Mux_Demux
    );   

    NOC_reg_mux_Inst: NOC_reg_mux
    port map(
            clk                => clk,
            reset              => reset,
            select_mux         => NoC_Reg_Mux_Select,
            Input_reg_data     => NoC_Input_reg_Out,
            Root_Memory_data   => RM_DataOut,
            Mux_Demux_data     => Noc_reg_mux_data,
            Dataout_mux        => Noc_reg_DataIn
    );
    
    NoC_reg_Inst: NoC_reg
    port map(		
            clk			  	    => clk,
            reset               => reset,
            Load_NOC_reg 	    => Load_NOC_reg,
            Data_input          => Noc_reg_DataIn,
            Data_output         => Noc_reg_DataOut   
    );     
            
    Noc_Switch_Inst: Noc_Switch
    port map(
            reset                   => reset,
            switch_Input 		    => Noc_reg_DataOut,
            switch_Out_en           => NOC_bus_direction, --0 downstream
            decoder                 => decoder,
            switch_mux		        => Switch_Ctrl,
            switch_Out 		        => Noc_Switch_Out,
            NOC_bus                 => NOC_bus_Output
	);    
	
    Noc_Input_Reg_Inst: Noc_Input_Reg
    port map(
            clk                 => clk,
			enable				=> Gated_clk_from_PEC,
            reset               => reset,
            NoC_Input_reg_In    => NOC_bus_In,
            NoC_Input_reg_Out   => NoC_Input_reg_Out
    );	
     
    PCIe_Data_block_Inst: PCIe_Data_block
    port map(
            clk                 => clk,
            reset               => reset,
            Load_PCIe_CMD_reg   => Load_PCIe_CMD_Reg,
            MD_PCIe_cmd         => MD_PCIe_cmd,        
            Data_Input          => Control_Data_Out,
            Mux_Demux_data      => Noc_data_Mux_Demux,
            Noc_data            => Noc_data_i
    );
   
    Mux_Reg_Inst: Mux_Reg
    port map(
            clk                 => clk,  
            reset               => reset,            
            Load_Mux_Reg        => Load_Mux_Reg,               
            Control_Data        => Control_Data_Out,
            NoC_Reg_Mux         => NoC_Reg_Mux_Select,
            MD_PCIe_cmd         => MD_PCIe_cmd,
            PCIedata_Switch     => PCIedata_Switch,    --to Mux/Demux
            Noc_Bus_Dir         => NOC_bus_direction
    );
    
    Tag_Line_Controller_Inst: Tag_Line_Controller
    port map(
            clk                     => clk,
            reset                   => reset,                        
            Load_Tag_Shift_Counter  => Load_Tag_Shift_Counter,
            Start_Tag_Shift         => Start_TAG_Shift,        
            Shift_Count             => Control_Data_Out,
            Tag_shift               => Tag_shift
    );
    
    Tag_Interface_Inst: Tag_Interface
    port map(
            clk                 => clk,
            reset               => reset,
            Load_TAG_Cmd_reg    => Load_PEC_Reg,
            Load_TAG_Arg_reg    => Load_PEC_Reg,
            Tag_shift           => Tag_shift,
            PEC_AS              => PEC_Address_REG,
            PEC_TS              => PEC_TS_REG,
            PEC_CMD             => Control_Data_Out(5 downto 0),
            Tag_Line            => Tag_Line
    );
  
    Root_Memory_Inst: Root_Memory
    Port map(
            clk                 => clk,
            reset               => reset,
            Write_Read_Mode     => R_W_RM,
            Enable              => En_RM,
            Load_Add_Gen        => Load_RM_address,
            Add_Gen_Value       => RM_Address(12 downto 0),
            DataIn              => RM_DataIn,
            DataOut             => RM_DataOut
    );
	
	Brodcast_Byte_Inst: Broadcast_Byte
	port map(
            clk                    => clk,
            reset                  => reset,
            Reset_BC               => Reset_BC,
            Step_BC                => Step_BC,
            decoder                => decoder,  
            byte_counter           => Byte_counter  
	);
	
	PCIe_Request_Inst: PCIe_Request
    port map(
            clk                    => clk,
            reset                  => reset,
            Data_in                => Control_Data_Out(1 downto 0),
            enable                 => Load_Req_reg,
            PCIe_Request_out       => PCIe_request_out
    );
	
	-- probe0_i(15 downto 0) <= NOC_bus_In;      
    -- probe1_i(15 downto 0) <= NoC_Input_reg_Out;   
    -- probe2_i(1 downto 0)  <= NoC_Reg_Mux_Select;                       	
    -- probe3_i(15 downto 0) <= Noc_reg_DataIn(15 downto 0);                             
    -- probe4_i(15 downto 0) <= Noc_reg_DataOut(15 downto 0);                   
    -- probe5_i(3 downto 0)  <= Switch_Ctrl;
    -- probe6_i(15 downto 0) <= Noc_Switch_Out;                           
    -- probe7_i(0)           <= Gated_clk_from_PEC; --Load_MD_Reg;
    -- probe8_i(0)           <= PCIedata_Switch;       
    -- probe9_i(255 downto 0)<= Noc_reg_mux_data; --Noc_data_Mux_Demux;       
    -- probe10_i(255 downto 0)<= Noc_data_i;
    -- probe10_i(63 downto 0) <= PCIe_data(63 downto 0);--Noc_data_i(63 downto 0);
    -- probe11_i(0)           <= Load_NOC_reg;
    -- probe12_i(7 downto 0)  <= Address_Counter_t;
    -- probe13_i(0)           <= R_W_RM;
    -- probe14_i(0)           <= En_RM;
    -- probe15_i(0)           <= Load_RM_address;
    -- probe16_i(11 downto 0) <= RM_Address(11 downto 0);
    -- probe17_i(15 downto 0) <= RM_DataIn;
    -- probe18_i(15 downto 0) <= RM_DataOut;
    -- probe19_i(31 downto 0) <= decoder;
        
        
    -- ILA_NOC_TOP : ila_7
    -- port map (
        -- clk => clk,
        -- probe0     => probe0_i, 
        -- probe1     => probe1_i, 
        -- probe2     => probe2_i, 
        -- probe3     => probe3_i, 
        -- probe4     => probe4_i, 
        -- probe5     => probe5_i, 
        -- probe6     => probe6_i, 
        -- probe7     => probe7_i, 
        -- probe8     => probe8_i, 
        -- probe9     => probe9_i, 
        -- probe10    => probe10_i,
        -- probe11    => probe11_i,
        -- probe12    => probe12_i,
        -- probe13    => probe13_i, 
        -- probe14    => probe14_i, 
        -- probe15    => probe15_i, 
        -- probe16    => probe16_i, 
        -- probe17    => probe17_i, 
        -- probe18    => probe18_i,
        -- probe19    => probe19_i
    -- );

end structure;