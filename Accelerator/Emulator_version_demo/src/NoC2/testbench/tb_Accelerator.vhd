----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.06.2022 11:42:01
-- Design Name: 
-- Module Name: Top_TB - Behavioral
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
use IEEE.NUMERIC_STD.all;
use std.textio.all;
use std.env.all;

entity Accelerator_tb is

	generic(
		Data_Transfer_Size : integer  := 65520;  --32768; --16384;  --16  --(RM)  (CM)  --512 --256(broadcast)
		Data_Transfer_Size2 : integer := 4095 --2048
		);
end Accelerator_tb;

architecture Behavioral of Accelerator_tb is

    component Accelerator_Top is
    Generic(
      USE_ASIC_MEMORIES      : boolean := false --true
    );    
    port(
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
    end component;
   
    
    type program_mem_type   is array (127 downto 0) of std_logic_vector(127 downto 0);
	type program_mem_type_b is array (127 downto 0) of bit_vector(127 downto 0);
	
    type data_in_type is array (Data_Transfer_Size -1 downto 0) of std_logic_vector(127 downto 0);
    type data_in_type_b is array (Data_Transfer_Size -1 downto 0) of bit_vector(127 downto 0);
    
    type Root_mem_data_type is array (Data_Transfer_Size -1 downto 0) of std_logic_vector(127 downto 0);
    type Root_mem_data_type_b is array (Data_Transfer_Size -1 downto 0) of bit_vector(127 downto 0);  
    
    type out_word   is array (Data_Transfer_Size -1 downto 0) of std_logic_vector(127 downto 0); 
    type out_word2  is array ( (Data_Transfer_Size * 16) -1 downto 0) of std_logic_vector(127 downto 0);  
	
    impure function init_program_mem_from_file (ram_file_name : in string) return program_mem_type is
    FILE ram_file : text is in ram_file_name;
    variable ram_file_line : line;
    variable RAM_B : program_mem_type_b;
    variable RAM :program_mem_type;
    begin
        for i in 0 to 127 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
    return RAM;
    end function;
    
    impure function init_input_from_file (ram_file_name : in string) return data_in_type is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : data_in_type_b;
      variable RAM :data_in_type;
      begin
        for i in 0 to Data_Transfer_Size -1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;

    impure function init_Root_mem_from_file (ram_file_name : in string) return Root_mem_data_type is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : Root_mem_data_type_b;
      variable RAM :Root_mem_data_type;
      begin
        for i in 0 to Data_Transfer_Size -1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;        

    signal program_mem_data  : program_mem_type := init_program_mem_from_file("tb_program_mem_code_regen_0.ascii");
    signal data_Input        : data_in_type := init_input_from_file("tb_input_data.ascii");
    signal Root_mem_data     : Root_mem_data_type := init_Root_mem_from_file("tb_input_data.ascii");  --("tb_Root_mem_data.ascii");       	   
    
    signal    clk_p         : std_logic;
    signal    clk_e         : std_logic;
    signal    Reset         : std_logic;
    --Command interface signals 
    signal    GPP_CMD_Data  : std_logic_vector(127 downto 0);  
    signal    NOC_CMD_Data  : std_logic_vector(7 downto 0);
    signal    GPP_CMD_Flag  : std_logic;
    signal    NOC_CMD_ACK   : std_logic;
    signal    NOC_CMD_flag  : std_logic;    
    signal    GPP_CMD_ACK   : std_logic;
    --Data/control interface signals
    signal    IO_data       : std_logic_vector(127 downto 0);
    signal    NOC_data      : std_logic_vector(127 downto 0); 
    signal    NOC_Address   : std_logic_vector(31 downto 0);
    signal    NOC_Length    : std_logic_vector(15 downto 0);
    signal    FIFO_Ready    : std_logic_vector(5 downto 0);
    signal    NOC_DATA_DIR  : std_logic;
    signal    NOC_DATA_EN   : std_logic;
    signal    NOC_WRITE_REQ : std_logic;
    signal    IO_WRITE_ACK  : std_logic;
    signal    Enable_Root_memory_t : std_logic;
    signal    RM_Data_Out_t        : std_logic_vector(127 downto 0);  
    signal    i             : integer := 0;
    signal    j             : integer := 0;
    signal    k             : integer := 0;
    signal    l             : integer := 0;
    signal    m             : integer := 0;
    signal    progress      : integer := 0;
    signal    progress2     : integer := 0;
    signal    broadcast     : integer := 0;
    signal    broadcast_indexed : integer := 0;
    signal    broadcast_sequential : integer := 0;
    signal    test_case     : integer := 0;
    signal    outword       : out_word;
    signal    outword2      : out_word2; 
                  
begin
    
    UUT: Accelerator_Top port map (clk_p => clk_p, clk_e => clk_e, Reset => Reset, GPP_CMD_Data => GPP_CMD_Data, NOC_CMD_Data => NOC_CMD_Data, GPP_CMD_Flag => GPP_CMD_Flag, 
    NOC_CMD_ACK => NOC_CMD_ACK, NOC_CMD_flag => NOC_CMD_flag, GPP_CMD_ACK => GPP_CMD_ACK, IO_data => IO_data, NOC_data => NOC_data, NOC_Address => NOC_Address, NOC_Length => NOC_Length, 
    FIFO_Ready => FIFO_Ready, NOC_DATA_DIR => NOC_DATA_DIR, NOC_DATA_EN => NOC_DATA_EN, NOC_WRITE_REQ => NOC_WRITE_REQ, IO_WRITE_ACK => IO_WRITE_ACK); 

    process
    begin  
        Reset               <= '1';
        IO_WRITE_ACK        <= '0';
        FIFO_Ready          <= (others => '0');
        IO_data             <= (others => '0'); 
        GPP_CMD_Flag        <= '0';
        GPP_CMD_ACK         <= '0';              
        wait for 50 ns;    
        Reset               <= '0';   
        wait for 40 ns;    
        Reset               <= '1';
        wait for 300 ns;  
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"0000000000000000000000000080000C";          
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 200 ns;
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 200 ns;
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        wait for 100 ns;
        FIFO_ready          <= "001000";  --FIFO_ready2 =0
        
        for j in 0 to 7 loop
            for i in 0 to 15 loop
              IO_data <= program_mem_data(i+j*16);
              wait until rising_edge(clk_e);
              wait for 100 ns;              
            end loop;
              FIFO_ready          <= "010000";
              wait for 100 ns;
              FIFO_ready          <= "000000";  --FIFO_ready2 =0
        end loop;
        
        wait until NOC_CMD_flag = '1';
        wait for 20 ns;
        GPP_CMD_ACK             <= '1';
        wait for 20 ns;
        GPP_CMD_ACK             <= '0';        
        
        
                
--        ----------------------------Boot NOC-----------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------                
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000000080000C";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 200 ns;
--        -----------------------------Write code ----------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 100 ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
        
--        for j in 0 to 7 loop
--            for i in 0 to 15 loop
--              IO_data <= program_mem_data(i+j*16);
--              wait until rising_edge(clk_e);
--              wait for 100 ns;              
--            end loop;
--              FIFO_ready          <= "010000";
--              wait for 100 ns;
--              FIFO_ready          <= "001000";
--        end loop;     
--        -----------------------------Boot NOC----------------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------         
        


--------1 
--        test_case           <= 1;
--        ---------------------------EM->MUX->RM---------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------              
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00010";--x"00000000000000000000000080000010";  --32768
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 200 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 80ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0

--        progress <= 1; 
--        for j in 0 to (Data_Transfer_Size/16) -1 loop
--            for i in 0 to 8 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;        
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
--        wait for 400 ns;
--        progress <= 2;
--        ------------------------READ RM->MUX->EM-------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF0001A";--x"0000000000000000000000008000001A";  --32768
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 220 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 300 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns;
--        end loop;
--        wait for 700ns; 
--        ---------------------------RM->MUX->EM---------------------------                
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------                
 
                      
--        -----------------------------Assertion---------------------------
--        wait for 1000000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential"&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;           
--        -----------------------------------------------------------------        
        
        
        
--------2
--        test_case           <= 2;              
--        ---------------------------EM->TP->RM----------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------        
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00012";--x"00000000000000000000000080000012";         
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 200 ns;    --Based on this wait time, fifo_ready can come when code 53or54 is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 80ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
        
--        progress <= 1;
--        for j in 0 to (Data_Transfer_Size/16) -1 loop
--            for i in 0 to 8 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;        
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
--        wait for 400 ns;
--        progress <= 2;        
--        ------------------------READ RM->TP->EM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF0001C"; --x"0000000000000000000000008000001C";      
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 220 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 280 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns;
--        end loop;
--        wait for 700ns;
--        ------------------------------RM->TP->EM-------------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------
 
 
--        -----------------------------Assertion---------------------------
--        wait for 1000000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential"&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;
--        -----------------------------------------------------------------        



------3
--        test_case           <= 3;
--        ------------------------EM->MUX->CM unicast----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------       
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00014";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1040ns;   --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 100ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
--        progress <= 1; 
--        for j in 0 to (Data_Transfer_Size/16) -1 loop
--            for i in 0 to 8 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;        
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
----        wait for 2400 ns;
----        -------------------------TEST PEC READY--------------------------
----        wait for 40ns;
----        wait until NOC_CMD_flag = '1';
----        wait for 20 ns;
----        GPP_CMD_ACK             <= '1';
----        wait for 20 ns;
----        GPP_CMD_ACK             <= '0';
----        -----------------------END TEST PEC READY------------------------
--        wait until NOC_CMD_flag = '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '0';        
--        ------------------------READ CM->MUX->EM-------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00024";          
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1020ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 340 ns;
------continues read        
----        for i in 1 to (Data_Transfer_Size/16) -1 loop       
----            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
----            wait for 40 ns;
----            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
----            wait for 280 ns; 
----        end loop;
------continues read end               
--        progress <= 4;         
        
--        wait until NOC_CMD_flag = '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '0';
        
--        FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;                       
--        ----------------------------CM->MUX->EM--------------------------                
--        ---------------------------------END-----------------------------       
--        ----------------------------------------------------------------- 
     
--        -----------------------------Assertion---------------------------
--        wait for 1000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential "&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;
--        ----------------------------------------------------------------- 



----4
        test_case           <= 4;
        broadcast           <= 1;
        ---------------------EM->MUX->CM broadcast-----------------------
        -----------------------------------------------------------------
        -----------------------------------------------------------------
        -----------------------------------------------------------------
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"0000000000000000000000000FFF0016";  --32 TS 20 --16 TS 10
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 500 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data -------------------------        
        FIFO_ready          <= "000001";  --FIFO_ready1 =1
        progress <= 1;  
        for i in 0 to (Data_Transfer_Size2) -1 loop        
            wait until NOC_DATA_EN = '1';
            IO_data             <= data_Input(i);
            wait for 40 ns;
        end loop;        
        wait for 400ns;
        progress <= 2;        
        ------------------------READ CM->MUX->EM-------------------------
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"000000000000000000000000FFF00024";  --512 200,  TS--256 TS 100       
        wait for 200 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0'; 
        wait for 1000 ns;
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        wait for 400 ns;
----continues read        
--        for i in 0 to (Data_Transfer_Size2) -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns; 
--        end loop;
----non continues read
--        for i in 0 to (Data_Transfer_Size2) -1 loop
--            wait for 580 ns; 
--        end loop;
----mix read
        for i in 0 to ((Data_Transfer_Size2) -1)/2 loop
            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
            wait for 40 ns;
            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
            wait for 280 ns; 
        end loop;    
        wait for 100ns;
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        for i in 0 to ((Data_Transfer_Size2) -1)/2 loop
            wait for 580 ns; 
        end loop;       
        ----------------------------CM->MUX->EM--------------------------        
        ---------------------------------END-----------------------------       
        -----------------------------------------------------------------

        -----------------------------Assertion---------------------------
        wait for 1000ns;
        progress <= 3;
        k        <= 0;
        j        <= 0;
        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
            for k in 0 to Data_Transfer_Size -1 loop
              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
              wait for 10 ns;
            end loop;
        elsif broadcast = 1 then 
            for k in 0 to Data_Transfer_Size2 -1 loop
                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k *16 +j) severity warning;
                  assert (outword(k *16 +j) = (x"0000000000000000000000000000" & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k *16 +j) severity warning;
                  wait for 10 ns;
                end loop;
            end loop;
            broadcast <= 0;
        elsif broadcast_indexed = 1 then
            for l in 0 to Data_Transfer_Size/4 -1 loop
                for k in 0 to 3 loop
                    for j in 0 to 3 loop
                        for i in 0 to 3 loop
                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
                        wait for 10 ns;
                        end loop;
                    end loop;  
                end loop;
            end loop;
            broadcast_indexed <= 0;
            
        elsif broadcast_sequential = 1 then
            for k in 0 to Data_Transfer_Size/16 -1 loop
                for j in 0 to 15 loop
                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential"&integer'image(k *16 +j) severity warning;
                  wait for 10 ns;
                end loop;
            end loop;
            broadcast_sequential <= 0;                     
        end if;
        -----------------------------------------------------------------



------5
--        test_case           <= 5;
--        ------------------------EM->TP->CM unicast-----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------      
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00018";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1040 ns;           --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 80ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
--        progress <= 1;  
--        for j in 0 to (Data_Transfer_Size/16) -1 loop
--            for i in 0 to 8 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;        
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
--        wait for 400 ns;
--        progress <= 2; 
        
--        wait until NOC_CMD_flag = '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '0';                
--        ------------------------READ CM->TP->EM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00026";    
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1080ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 320 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop       
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns;
--        end loop;
--        progress <= 22;
--        wait for 160 ns;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
            
--        wait until NOC_CMD_flag = '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '1';
--        wait for 20 ns;
--        GPP_CMD_ACK             <= '0';
        
--        FIFO_ready              <= "001000"; --FIFO_ready3,2 =0;         
--        ----------------------------CM->TP->EM---------------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------      

--        -----------------------------Assertion---------------------------
--        wait for 1000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed "&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential"&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;
--        -----------------------------------------------------------------


--------6
--        test_case           <= 6;
--        ------------------------RM->CM unicast-----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
         
--        ---------------------------EM->MUX->RM---------------------------
--        -------------------------SEND DATA TO RM-------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------              
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000080000010";--x"00000000000000000000000080000010";  --32768
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 200 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 80ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0

--        progress <= 1; 
--        for j in 0 to (Data_Transfer_Size/16) -1 loop
--            for i in 0 to 8 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;        
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
--        wait for 400 ns;
--        progress <= 2;

--        ------------------------RM->CM unicast-----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        ----------------------------------------------------------------- 
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000008000001E";  --Data_Transfer_Size =32,00000000000000000000000002000018
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 720 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        progress <= 1;  
--        wait for Data_Transfer_Size * 20 ns;                                        
--        wait for 400 ns;
--        progress <= 2;        
--        ------------------------READ CM->RM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000080000028";   
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1420ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop       
--            wait for 340 ns; 
--        end loop;
--        wait for 10000ns;       
--        -------------------------------CM->RM----------------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------
--        ------------------------READ RM->MUX->EM-------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000008000001A";  --32768
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 200 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 300 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns;
--        end loop;
--        wait for 700ns;                 
        
--        -----------------------------Assertion---------------------------
--        wait for 1000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential "&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;
--        -----------------------------------------------------------------        



--        test_case           <= 7;
--        broadcast_indexed   <= 1;
--        ----------------RM->CM boadcast indexed addressing---------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000008000022"; --16 32 TS 20 --16 TS 10
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 600 ns;
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000010000400010";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';
--        wait for 100 ns;
--        ---------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000030000C00030"; --to test err --x"00000000000000000000030000C00030";  --x"00 00000 00000 00000 00003 0000C 00030";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';        
--        -----------------------------Write data -------------------------        
--        FIFO_ready          <= "000001";  --FIFO_ready1 =1       
--        wait for 1000000ns;
--        ----------------------------RM->CM boadcast----------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------
        
--        --------------------------READ CM->RM----------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000080000028";
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 3000 ns;
--        ----------------------------CM->RM-------------------------------        
--        ------------------------------END--------------------------------        
--        -----------------------------------------------------------------
        
        
--        -----------------------------Assertion---------------------------
--        wait for 100000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = Root_mem_data(k)) report "Incorrect output data in unicast "&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size2/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential"&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;
--        -----------------------------------------------------------------        



--        test_case             <= 8;
--        broadcast_sequential  <= 1;          
--        ---------------RM->CM boadcast sequenced addressing--------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------

--        ---------------------------EM->MUX->RM---------------------------
--        -------------------------SEND DATA TO RM-------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------              
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000008000010";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 200 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 80ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0

--        progress <= 1; 
--        for j in 0 to (Data_Transfer_Size2/16) -1 loop
--            for i in 0 to 8 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              wait until rising_edge(clk_e);
--              IO_data <= data_Input(i+j*16);
--            end loop;        
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
--        wait for 400 ns;
--        progress <= 2;
        
--        ---------------RM->CM boadcast sequenced addressing--------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------        
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000008000020"; --2048 which will read back 32768 to Root mem which is maximum RM size
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 600 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.        
--        -----------------------------Write data -------------------------        
--        FIFO_ready          <= "000001";  --FIFO_ready1 =1       
--        wait for 1000000ns;
--        ----------------------------RM->CM boadcast----------------------        
--        ---------------------------------END-----------------------------        
--        -----------------------------------------------------------------
        
--        ----------------------------READ CM->RM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000080000028"; --32768 which is maximum RM size
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
        
--        for i in 1 to (Data_Transfer_Size/16) -1 loop
--            wait for 320 ns;
--        end loop; 
--        wait for 10000ns;        
--        ------------------------------CM->RM-----------------------------       
--        ---------------------------------END-----------------------------        
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        ------------------------READ RM->MUX->EM-------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000008000001A";  --32768
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 200 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 280 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns;
--        end loop;
--        wait for 700ns;
        
--        -----------------------------Assertion---------------------------
--        wait for 1000ns;
--        progress <= 3;
--        k        <= 0;
--        j        <= 0;
--        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
--            for k in 0 to Data_Transfer_Size -1 loop
--              assert (outword(k) = data_Input(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
--              wait for 10 ns;
--            end loop;
--        elsif broadcast = 1 then 
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8) & data_Input(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast <= 0;
--        elsif broadcast_indexed = 1 then
--            for l in 0 to Data_Transfer_Size/4 -1 loop
--                for k in 0 to 3 loop
--                    for j in 0 to 3 loop
--                        for i in 0 to 3 loop
--                            assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
--                        wait for 10 ns;
--                        end loop;
--                    end loop;  
--                end loop;
--            end loop;
--            broadcast_indexed <= 0;
            
--        elsif broadcast_sequential = 1 then
--            for k in 0 to Data_Transfer_Size/16 -1 loop
--                for j in 0 to 15 loop
--                  assert (outword(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential "&integer'image(k *16 +j) severity warning;
--                  wait for 10 ns;
--                end loop;
--            end loop;
--            broadcast_sequential <= 0;                     
--        end if;
--        -----------------------------------------------------------------  
                 
     
        wait for 10000000ns;                                  
    end process;

    process(clk_e)
    begin
        if rising_edge(clk_e) then
            if NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"1C" then
                outword(m) <= NOC_data;
                m  <= m +1;
                progress2 <= 5;
            elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"1A" then
                outword(m) <= NOC_data;
                m  <= m +1;
                progress2 <= 5; 
            elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"24" then
                outword(m) <= NOC_data;
                m  <= m +1;
                progress2 <= 5; 
            elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"26" then
                outword(m) <= NOC_data;
                m  <= m +1;
                progress2 <= 5;
            elsif Enable_Root_memory_t = '1' and GPP_CMD_Data(7 downto 0)= x"28" then
                outword2(m) <= RM_Data_Out_t;
--                outword(m) <= RM_Data_Out_t;
                m  <= m +1;
                progress2 <= 5;                
            elsif m > Data_Transfer_Size -1 then
                progress2 <= 0;
                m  <= 0;                    
            end if; 
        end if;
           
    end process;
    process
    begin
        clk_e <= '0';
        for i in 1 to 30000000 loop
            wait for 10ns;
            clk_e <= not clk_e;
        end loop;
        wait;
    end process;
    
    process
    begin
        clk_p <= '0';
        for i in 1 to 30000000 loop
            wait for 5ns;
            clk_p <= not clk_p;
        end loop;
        wait;
    end process;                

end Behavioral;
