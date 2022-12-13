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
		Data_Transfer_Size : integer := 65520;--32768; --16384; --65520;  --16  --(RM)  --65520 (CM)  --512 --256(broadcast)
		Data_Transfer_Size2 : integer := 4096 --2048
		);
end Accelerator_tb;

architecture Behavioral of Accelerator_tb is

    component Accelerator_Top is
    Generic(
      USE_ASIC_MEMORIES      : boolean := true;
      PEC_NUMBER             : integer := 2
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
   
    type progress_state is (waiting, send_cmd, rd_cm, sending_ucode, sending_params, sending_kernels, sending_bias, sending_data, cmd_exe, executing, result_cmp);
    type program_mem_type   is array (127 downto 0) of std_logic_vector(127 downto 0);
	  type program_mem_type_b is array (127 downto 0) of bit_vector(127 downto 0);
	
    type data_in_type is array (Data_Transfer_Size -1 downto 0) of std_logic_vector(127 downto 0);
    type data_in_type_b is array (Data_Transfer_Size -1 downto 0) of bit_vector(127 downto 0);
    
    type Root_mem_data_type is array (Data_Transfer_Size -1 downto 0) of std_logic_vector(127 downto 0);
    type Root_mem_data_type_b is array (Data_Transfer_Size -1 downto 0) of bit_vector(127 downto 0);  
    
    type out_word   is array (Data_Transfer_Size -1 downto 0) of std_logic_vector(127 downto 0); 
    type out_word2  is array ( (Data_Transfer_Size * 16) -1 downto 0) of std_logic_vector(127 downto 0);  

    ------------------------------types for pec-----------------------------------------
    constant ucode_sa    : std_logic_vector(14 downto 0) := "000000000000000"; --microcode start address in CM
    constant param_sa    : std_logic_vector(14 downto 0) := "000000100000000"; --0x100, start address of parameters
    constant kernels_sa  : std_logic_vector(14 downto 0) := "000001000000000"; --0x200, start address of kernels
    constant bias_sa     : std_logic_vector(14 downto 0) := "000001100000000"; --0x300, start address of bias
    constant data_sa     : std_logic_vector(14 DOWNTO 0) := "000010000000000"; --0x400, start address of input data
    constant out_sa      : std_logic_vector(14 downto 0) := "001010000000000"; --0x1400, pointwise output address in CM.
    constant ucode_len   : integer := 256;
    constant param_len   : integer := 64;
    constant kernels_len : integer := 216;
    constant bias_len    : integer := 3;
    constant data_len    : integer := 72;
    constant out_len     : integer := 16;   
   
    type mem_word   is array (15 downto 0) of std_logic_vector(7 downto 0);
    type out_byte   is array (294911 downto 0) of std_logic_vector(7 downto 0);
   	type ram_type   is array (255 downto 0) of std_logic_vector(127 downto 0);
    type data_in    is array (data_len - 1 downto 0) of std_logic_vector(127 downto 0);
    type kernels_in is array (kernels_len - 1 downto 0) of std_logic_vector(127 downto 0);
    type bias_in    is array (bias_len - 1 downto 0) of std_logic_vector(127 downto 0);
    type param_in   is array (param_len - 1 downto 0) of std_logic_vector(127 downto 0);
    type result_out is array (out_len - 1 downto 0) of std_logic_vector(127 downto 0);
	  type ram_type_b is array (255 downto 0) of bit_vector(127 downto 0);
    type data_in_b  is array (data_len - 1 downto 0) of bit_vector(127 downto 0);
    type kernels_b  is array (kernels_len - 1 downto 0) of bit_vector(127 downto 0);
    type bias_in_b  is array (bias_len - 1 downto 0) of bit_vector(127 downto 0);
    type param_b    is array (param_len - 1 downto 0) of bit_vector(127 downto 0);
    type res_out_b  is array (out_len - 1 downto 0) of bit_vector(127 downto 0);
	  ------------------------------------------------------------------------------------

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
    
    impure function init_ram_from_file (ram_file_name : in string) return ram_type is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : ram_type_b;
      variable RAM :ram_type;
      begin
        for i in 0 to ucode_len - 1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;
  
    impure function init_param_from_file (ram_file_name : in string) return param_in is
        FILE ram_file : text is in ram_file_name;
        variable ram_file_line : line;
        variable RAM_B : param_b;
        variable RAM :param_in;
        begin
          for i in 0 to param_len - 1 loop
            readline(ram_file, ram_file_line);
            read(ram_file_line, RAM_B(i));
            RAM(i) := to_stdlogicvector(RAM_B(i));
          end loop;
        return RAM;
    end function;
  
    impure function init_input_from_file (ram_file_name : in string) return data_in is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : data_in_b;
      variable RAM :data_in;
      begin
        for i in 0 to data_len - 1 loop 
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;
  
    impure function init_kernel_from_file (ram_file_name : in string) return kernels_in is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : kernels_b;
      variable RAM :kernels_in;
      begin
        for i in 0 to kernels_len - 1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;
  
    impure function init_bias_from_file (ram_file_name : in string) return bias_in is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : bias_in_b;
      variable RAM :bias_in;
      begin
        for i in 0 to bias_len - 1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;
  
    impure function init_out_from_file(ram_file_name : in string) return result_out is
      FILE ram_file : text is in ram_file_name;
      variable ram_file_line : line;
      variable RAM_B : res_out_b;
      variable RAM :result_out;
      begin
        for i in 0 to out_len - 1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;

    signal program_mem_data  : program_mem_type := init_program_mem_from_file("tb_program_mem_code.ascii");
    signal data_Input        : data_in_type := init_input_from_file("tb_input_data.ascii");
    signal Root_mem_data     : Root_mem_data_type := init_Root_mem_from_file("tb_Root_mem_data.ascii");       	   
    
    signal ucode   : ram_type   := init_ram_from_file("Pointwise_generic_bypass.ascii");
    signal data    : data_in    := init_input_from_file("pwc_data_4x8x144.ascii");
    signal kernel  : kernels_in := init_kernel_from_file("CM_kernels_pwc_u8_ref.ascii");
    signal bias    : bias_in    := init_bias_from_file("CM_bias_pwc_s16.ascii");
    signal param   : param_in   := init_param_from_file("CM_params_bp.ascii");
    signal ref_out : result_out := init_out_from_file("pwc_ref_4x8x32.ascii");

    signal    clk_p         : std_logic;
    signal    clk_e         : std_logic;
    signal    Reset         : std_logic;
    signal    PEC_Ready     : std_logic;
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
    signal    i             : integer := 0;
    signal    j             : integer := 0;
    signal    k             : integer := 0;
    signal    l             : integer := 0;
    signal    m             : integer := 0;--(out_len)*16 - 1;
    signal    progress      : progress_state;--integer := 0;
    signal    progress2     : integer := 0;
    signal    broadcast     : integer := 0;
    signal    broadcast_indexed : integer := 0;
    signal    broadcast_sequential : integer := 0;
    signal    test_case     : integer := 0;
    signal    outword       : out_word;
    signal    outword2      : out_word2; 

    alias     GPP_CMD_LEN : std_logic_vector is GPP_CMD_Data(31 downto 16);
    alias     GPP_CMD_SA  : std_logic_vector is GPP_CMD_Data(62 downto 48);
                  
begin
    
    UUT: Accelerator_Top generic map(USE_ASIC_MEMORIES => true, PEC_NUMBER => 1) port map (clk_p => clk_p, clk_e => clk_e, Reset => Reset, GPP_CMD_Data => GPP_CMD_Data, NOC_CMD_Data => NOC_CMD_Data, GPP_CMD_Flag => GPP_CMD_Flag, 
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


------3
--        test_case           <= 3;
--        ------------------------EM->MUX->CM unicast----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------       
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00014"; --x"00000000000000000000000080000014"; --x"00000000000000000000000000100014";  --Data_Transfer_Size =32,00000000000000000000000000200014
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1040ns; --1200ns;  --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
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
--        wait for 2400 ns;
--        progress <= 2;
--        ------------------------READ CM->MUX->EM-------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00024";--x"00000000000000000000000080000024"; --x"00000000000000000000000000100024";          
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1100ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 320 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop       
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
--            wait for 280 ns; 
--        end loop;
--        wait for 1500ns;  --10000ns;               
--        ----------------------------CM->MUX->EM--------------------------                
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------    
--
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
--          
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



------4
--        test_case           <= 4;
--        ------------------------EM->TP->CM unicast-----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------      
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00018"; --x"00000000000000000000000080000018";  --Data_Transfer_Size =32,00000000000000000000000002000018
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1040 ns; --1360 ns;--980 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
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
--        ------------------------READ CM->TP->EM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"000000000000000000000000FFF00026";  --x"00000000000000000000000080000026";      
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1000ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 420 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop       
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;    --"100000"; --FIFO_ready3 =0;
--            wait for 280 ns; 
--        end loop;
--        wait for 10000ns;       
--        ----------------------------CM->TP->EM---------------------------        
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



------5
        test_case           <= 5;
        broadcast           <= 1;
        ---------------------EM->MUX->CM broadcast-----------------------
        -----------------------------------------------------------------
        -----------------------------------------------------------------
        -----------------------------------------------------------------
        ---------------------uprogram------------------------------------
        -----------------------------------------------------------------
        progress            <= send_cmd;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000000016";--x"00000000000000000000000008000016";--x"00000000000000000000000008000016"; --32 TS 20 --16 TS 10
        GPP_CMD_LEN         <= std_logic_vector(to_unsigned(ucode_len, 16)); 
        GPP_CMD_SA          <= ucode_sa;
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0';                
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 500 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data -------------------------        
        FIFO_ready          <= "000001";  --FIFO_ready1 =1
        progress <= sending_ucode;  
        for i in 0 to (ucode_len) -1 loop        
            wait until NOC_DATA_EN = '1';
            IO_data      <= ucode(i);
            wait for 40 ns;
        end loop;  
        progress <= waiting;      
        wait for 700ns;        
        -----------------------------------------------------------------
        ---------------------parameters----------------------------------
        -----------------------------------------------------------------
        progress            <= send_cmd;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000000016";--x"00000000000000000000000008000016";--x"00000000000000000000000008000016"; --32 TS 20 --16 TS 10
        GPP_CMD_LEN         <= std_logic_vector(to_unsigned(param_len, 16)); 
        GPP_CMD_SA          <= param_sa;
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0';                   
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 500 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data -------------------------        
        FIFO_ready          <= "000001";  --FIFO_ready1 =1
        progress <= sending_params;  
        for i in 0 to (param_len) -1 loop        
            wait until NOC_DATA_EN = '1';
            IO_data     <= param(i);
            wait for 40 ns;
        end loop;   
        progress <= waiting;     
        wait for 700ns;   
        -----------------------------------------------------------------
        ---------------------kernels-------------------------------------
        -----------------------------------------------------------------
        progress            <= send_cmd;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000000016";--x"00000000000000000000000008000016";--x"00000000000000000000000008000016"; --32 TS 20 --16 TS 10
        GPP_CMD_LEN         <= std_logic_vector(to_unsigned(kernels_len, 16)); 
        GPP_CMD_SA          <= kernels_sa;
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0';                    
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 500 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data -------------------------        
        FIFO_ready          <= "000001";  --FIFO_ready1 =1
        progress <= sending_kernels;  
        for i in 0 to (kernels_len) -1 loop        
            wait until NOC_DATA_EN = '1';
            IO_data     <= kernel(i);
            wait for 40 ns;
        end loop;
        progress <= waiting;        
        wait for 700ns;   
        -----------------------------------------------------------------
        ---------------------bias----------------------------------------
        -----------------------------------------------------------------
        progress            <= send_cmd;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000000016";--x"00000000000000000000000008000016";--x"00000000000000000000000008000016"; --32 TS 20 --16 TS 10
        GPP_CMD_LEN         <= std_logic_vector(to_unsigned(bias_len, 16)); 
        GPP_CMD_SA          <= bias_sa;
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0';                   
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 500 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data -------------------------        
        FIFO_ready          <= "000001";  --FIFO_ready1 =1
        progress <= sending_bias;  
        for i in 0 to (bias_len) -1 loop        
            wait until NOC_DATA_EN = '1';
            IO_data     <= bias(i);
            wait for 40 ns;
        end loop;
        progress <= waiting;        
        wait for 700ns;
        -----------------------------------------------------------------
        ---------------------data----------------------------------------
        -----------------------------------------------------------------
        progress            <= send_cmd;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"0000000000000000000000000FFF0016";--x"00000000000000000000000008000016";--x"00000000000000000000000008000016"; --32 TS 20 --16 TS 10
        GPP_CMD_LEN         <= std_logic_vector(to_unsigned(data_len, 16)); 
        GPP_CMD_SA          <= data_sa;
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0';                    
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 500 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data -------------------------        
        FIFO_ready          <= "000001";  --FIFO_ready1 =1
        progress <= sending_data;  
        for i in 0 to (data_len) -1 loop        
            wait until NOC_DATA_EN = '1';
            IO_data        <= data(i);
            wait for 40 ns;
        end loop;        
        progress <= waiting;
        wait for 700ns;
        -----------------------------------------------------------------
        ---------------------------Execution-----------------------------
        -----------------------------------------------------------------
        progress <= cmd_exe;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000000038";
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0'; 
        progress <= executing;
        -----------------------------------------------------------------
        --------------------------Wait--ready----------------------------
        -----------------------------------------------------------------
        wait until NOC_CMD_Data = x"02";
        -----------------------------------------------------------------
        ------------------------READ CM->MUX->EM-------------------------
        -----------------------------------------------------------------
        progress            <= send_cmd;
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"000000000000000000000000FFF00024";--x"00000000000000000000000080000024"; --512 200,  TS--256 TS 100       
        GPP_CMD_LEN         <= std_logic_vector(to_unsigned(out_len*16, 16)); 
        GPP_CMD_SA          <= out_sa;
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';
        if NOC_CMD_flag /= '1' then
          wait;
        end if;
        GPP_CMD_ACK         <= '1';    
        wait for 1000 ns;
        GPP_CMD_ACK         <= '0';                    
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0'; 
        wait for 1000 ns;
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        wait for 380 ns;
        progress <= rd_cm;
        for i in 0 to (out_len) -1 loop
            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
            wait for 40 ns;
            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;
            wait for 280 ns; 
        end loop; 
        progress <= waiting;    
        wait for 100ns;
        ----------------------------CM->MUX->EM--------------------------        
        ---------------------------------END-----------------------------       
        -----------------------------------------------------------------


        -----------------------------Assertion---------------------------
        if NOC_DATA_EN /= '0' then
          wait;
        end if;
        progress <= result_cmp;
        k        <= 0;
        j        <= 0;
        if broadcast = 0 and broadcast_indexed = 0 and broadcast_sequential = 0 then
            for k in 0 to data_len -1 loop
              assert (outword(k) = data(k)) report "Incorrect output data in unicast"&integer'image(k) severity warning;
              wait for 10 ns;
            end loop;
        elsif broadcast = 1 then 
            for k in 0 to out_len -1 loop
                --for j in 0 to 15 loop
                  --assert (outword(k *16 +j) = (ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8) & ref_out(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast"&integer'image(k *16 +j) severity warning;
                  assert(outword(k) = ref_out(k)) report "Incorrect output data in broadcast"&integer'image(k) severity warning;
                  wait for 10 ns;
                --end loop;
            end loop;
            broadcast <= 0;
        --elsif broadcast_indexed = 1 then
        --    for l in 0 to Data_Transfer_Size/4 -1 loop
        --        for k in 0 to 3 loop
        --            for j in 0 to 3 loop
        --                for i in 0 to 3 loop
        --                    assert (outword2((l*64) + (k *16) +(j *4) + i) = Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32)) & Root_mem_data(i)((k*8) +(j*32) + 7 downto (k*8) +(j*32))) report "Incorrect output data in broadcast_indexed"&integer'image((l*64) + (k *16) +(j *4) + i) severity warning;
        --                wait for 10 ns;
        --                end loop;
        --            end loop;  
        --        end loop;
        --    end loop;
        --    broadcast_indexed <= 0;            
        --elsif broadcast_sequential = 1 then
        --    for k in 0 to Data_Transfer_Size/16 -1 loop
        --        for j in 0 to 15 loop
        --          assert (outword2(k *16 +j) = (Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8) & Root_mem_data(k)(j*8 + 7 downto j*8))) report "Incorrect output data in broadcast_sequential"&integer'image(k *16 +j) severity warning;
        --          wait for 10 ns;
        --        end loop;
        --    end loop;
        --    broadcast_sequential <= 0;                     
        end if;
        -----------------------------------------------------------------
        ------------------------------End--------------------------------
        -----------------------------------------------------------------



------6
--        test_case           <= 6;
--        ------------------------RM->CM unicast-----------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        ----------------------------------------------------------------- 
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000008000001E"; --x"0000000000000000000000008000001E";  --Data_Transfer_Size =32,00000000000000000000000002000018
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 720 ns; --1360 ns;--980 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data -------------------------
--        progress <= 1;  
--        wait for Data_Transfer_Size * 20 ns;                                        
--        wait for 400 ns;
--        progress <= 2;        
--        ------------------------READ CM->RM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000080000028";  --x"00000000000000000000000080000028";      
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1000ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 420 ns;
--        for i in 1 to (Data_Transfer_Size/16) -1 loop       
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "001000"; --FIFO_ready3,2 =0;    --"100000"; --FIFO_ready3 =0;
--            wait for 280 ns; 
--        end loop;
--        wait for 10000ns;       
--        -------------------------------CM->RM----------------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------
--        
--        
--        -----------------------------Assertion---------------------------
--        wait for 1000ns;
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
--            
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



--          test_case           <= 7;
--          broadcast_indexed   <= 1;
--        ----------------RM->CM boadcast indexed addressing---------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        -----------------------------------------------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000100022"; --16 32 TS 20 --16 TS 10
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 600 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000010000400010";   --x"00 00000 00000 00000 00001 00004 00010";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';
--        wait for 100 ns;
--        ---------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000030000C00030";  --x"00 00000 00000 00000 00003 0000C 00030";
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';        
--        -----------------------------Write data -------------------------        
--        FIFO_ready          <= "000001";  --FIFO_ready1 =1       
--        wait for 100000ns;
--        ----------------------------RM->CM boadcast----------------------        
--        ---------------------------------END-----------------------------       
--        -----------------------------------------------------------------
        
--        --------------------------READ CM->RM----------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000001000028";
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 3000 ns;
--        ----------------------------CM->RM-------------------------------        
--        ---------------------------------END-----------------------------        
--        -----------------------------------------------------------------



        --test_case           <= 8;
        --broadcast_sequential  <= 1;          
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
--        wait for 3000 ns;
--        ------------------------------CM->RM-----------------------------       
--        ---------------------------------END-----------------------------        
--        -----------------------------------------------------------------
          report "simulation end";
          finish;
--        wait for 10000000ns;                                  
    end process;

    process(clk_e)
    begin
        if rising_edge(clk_e) then
            if NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"1C" then
                outword(m) <= NOC_data;
                if m /= out_len - 1 then
                  m  <= m + 1;
                  progress2 <= 5; 
                else
                  progress2 <= 0;
                end if;
            elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"1A" then
                outword(m) <= NOC_data;
                if m /= (out_len)*16 - 1 then
                  m  <= m + 1;
                  progress2 <= 5; 
                else
                  progress2 <= 0;
                end if;
            elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"24" then
                --outword((out_len - 1) - m/16)((m mod 16)*8 + 7 downto (m mod 16)*8) <= NOC_data(7 downto 0);
                outword(m/16)((m mod 16)*8 + 7 downto (m mod 16)*8) <= NOC_data(7 downto 0);
                if m /= (out_len)*16 - 1 then
                  m  <= m + 1;
                  progress2 <= 5; 
                else
                  progress2 <= 0;
                end if; 
            elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"26" then
                outword(m) <= NOC_data;
                if m /= (out_len)*16 - 1 then
                  m  <= m + 1;
                  progress2 <= 5; 
                else
                  progress2 <= 0;
                end if;                                
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