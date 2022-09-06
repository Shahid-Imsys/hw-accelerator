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
		Data_Transfer_Size : integer := 8     --azzzz
		);
end Accelerator_tb;

architecture Behavioral of Accelerator_tb is

    component Accelerator_Top is
    port(
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
        PEC_Ready            : in  std_logic; 
        --Command interface signals 
        GPP_CMD_Data         : in  std_logic_vector(127 downto 0);
        NOC_CMD_Data         : out std_logic_vector(7 downto 0);
        GPP_CMD_Flag         : in  std_logic;
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
   
    
    type program_mem_type   is array (511 downto 0) of std_logic_vector(127 downto 0);
	type program_mem_type_b is array (511 downto 0) of bit_vector(127 downto 0);
	
    type data_in_type is array ((Data_Transfer_Size * 16) -1 downto 0) of std_logic_vector(127 downto 0);
    type data_in_type_b is array ((Data_Transfer_Size * 16) -1 downto 0) of bit_vector(127 downto 0); 
    
    type out_word   is array ((Data_Transfer_Size * 16) -1 downto 0) of std_logic_vector(127 downto 0);   
	
    impure function init_program_mem_from_file (ram_file_name : in string) return program_mem_type is
    FILE ram_file : text is in ram_file_name;
    variable ram_file_line : line;
    variable RAM_B : program_mem_type_b;
    variable RAM :program_mem_type;
    begin
        for i in 0 to 511 loop
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
        for i in 0 to (Data_Transfer_Size * 16) -1 loop
          readline(ram_file, ram_file_line);
          read(ram_file_line, RAM_B(i));
          RAM(i) := to_stdlogicvector(RAM_B(i));
        end loop;
      return RAM;
    end function;    

    signal program_mem_data  : program_mem_type := init_program_mem_from_file("program_mem_code.ascii");
    signal data_Input        : data_in_type := init_input_from_file("input_data1.ascii");   	   
    
    signal    clk           : std_logic;
    signal    Reset         : std_logic;
    signal    PEC_Ready     : std_logic;
    --Command interface signals 
    signal    GPP_CMD_Data  : std_logic_vector(127 downto 0);  
    signal    NOC_CMD_Data  : std_logic_vector(7 downto 0);
    signal    GPP_CMD_Flag  : std_logic;
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
    signal    progress      : integer := 0;
    signal    outword       : out_word; 
                  
begin
    
    UUT: Accelerator_Top port map (clk => clk, Reset => Reset, PEC_Ready => PEC_Ready, GPP_CMD_Data => GPP_CMD_Data, NOC_CMD_Data => NOC_CMD_Data, GPP_CMD_Flag => GPP_CMD_Flag, 
    NOC_CMD_flag => NOC_CMD_flag, GPP_CMD_ACK => GPP_CMD_ACK, IO_data => IO_data, NOC_data => NOC_data, NOC_Address => NOC_Address, NOC_Length => NOC_Length, FIFO_Ready => FIFO_Ready, 
    NOC_DATA_DIR => NOC_DATA_DIR, NOC_DATA_EN => NOC_DATA_EN, NOC_WRITE_REQ => NOC_WRITE_REQ, IO_WRITE_ACK => IO_WRITE_ACK); 

    process
    begin  
        Reset               <= '0';
        IO_WRITE_ACK        <= '0';
        FIFO_Ready          <= (others => '0');
        IO_data             <= (others => '0'); 
        GPP_CMD_Flag        <= '0';
        GPP_CMD_ACK         <= '0';              
        wait for 50 ns;    
        Reset               <= '1';   
        wait for 40 ns;    
        Reset               <= '0';
        wait for 300 ns;  
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"000000000000000000000000007D000C";          
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 200 ns;
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 200 ns;
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        wait for 80 ns;
        FIFO_ready          <= "001000";  --FIFO_ready2 =0
        
        for j in 0 to 7 loop
            for i in 0 to 15 loop
              IO_data <= program_mem_data(i+j*16);
              wait until rising_edge(clk);
              wait for 100 ns;              
            end loop;
              FIFO_ready          <= "010000";
              wait for 100 ns;
              FIFO_ready          <= "001000";
        end loop;
        
        ------------------------------Boot NOC-------------------------------
        ---------------------------------------------------------------------
        ---------------------------------------------------------------------
        ---------------------------------------------------------------------                
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"000000000000000000000000007D000C";
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 200 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 200 ns;
        -----------------------------Write code ----------------------------
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        wait for 80 ns;
        FIFO_ready          <= "001000";  --FIFO_ready2 =0
        
        for j in 0 to 7 loop
            for i in 0 to 15 loop
              IO_data <= program_mem_data(i+j*16);
              wait until rising_edge(clk);
              wait for 100 ns;              
            end loop;
              FIFO_ready          <= "010000";
              wait for 100 ns;
              FIFO_ready          <= "001000";
        end loop;     
        -----------------------------Boot NOC------------------------------        
        ---------------------------------END-------------------------------        
        -------------------------------------------------------------------         
        


--        -----------------------------EM->MUX->RM-----------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------               
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000400010";          
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 100 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data ----------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait until rising_edge(clk);
--        wait for 40ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
--        wait for 40ns;
--        IO_data             <= data_Input(0);
--        wait for 20ns;        

--        for i in 1 to 9 loop
--          IO_data <= data_Input(i);
--          wait until rising_edge(clk);
--          wait for 20ns;
--        end loop;
--        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--        for i in 10 to 15 loop
--          IO_data <= data_Input(i);
--          wait until rising_edge(clk);
--          wait for 20ns;
--        end loop;        
--        FIFO_ready          <= "100000"; --FIFO_ready3 =0;    

--        for j in 1 to Data_Transfer_Size -1 loop
--            for i in 0 to 8 loop
--              IO_data <= data_Input(i+j*16);
--              wait until rising_edge(clk);
--              wait for 20ns;
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              IO_data <= data_Input(i+j*16);
--              wait until rising_edge(clk);
--              wait for 20ns;
--            end loop;        
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                              
--        wait for 300 ns;
--        ------------------------READ RM->MUX->EM---------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000000040001A";          
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 200 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 220 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 300 ns;
--        for i in 1 to Data_Transfer_Size -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--            wait for 280 ns;
--        end loop;
--        wait for 700ns; 
--        ----------------------------EM->MUX->RM------------------------------                
--        --------------------------------END----------------------------------
--        ---------------------------------------------------------------------                

              
               
--        -----------------------------EM->TP->RM------------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------        
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000400012";          
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 100 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data ----------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait until rising_edge(clk);
--        wait for 40ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
--        wait for 60ns;
--        IO_data             <= data_Input(0);
--        wait for 20ns;
        
--        for i in 1 to 9 loop
--          IO_data <= data_Input(i);
--          wait until rising_edge(clk);
--          wait for 20ns;
--        end loop;
--        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--        for i in 10 to 15 loop
--          IO_data <= data_Input(i);
--          wait until rising_edge(clk);
--          wait for 20ns;
--        end loop;        
--        FIFO_ready          <= "100000"; --FIFO_ready3 =0;   

--        for j in 1 to Data_Transfer_Size -1 loop
--            for i in 0 to 8 loop
--              IO_data <= data_Input(i+j*16);
--              wait until rising_edge(clk);
--              wait for 20ns;
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              IO_data <= data_Input(i+j*16);
--              wait until rising_edge(clk);
--              wait for 20ns;
--            end loop;        
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                           
--        wait for 300 ns;
--        ------------------------READ RM->TP->EM---------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000000040001C";          
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 220 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 300 ns;
--        for i in 1 to Data_Transfer_Size -1 loop
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--            wait for 280 ns;
--        end loop;
--        wait for 700ns;
--        ------------------------------EM->TP->RM---------------------------        
--        ---------------------------------END-------------------------------        
--        -------------------------------------------------------------------
 


        -------------------------EM->MUX->CM unicast-------------------------
        ---------------------------------------------------------------------
        ---------------------------------------------------------------------
        ---------------------------------------------------------------------        
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000800014";    
        wait for 100 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0';
        wait for 1360 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
        -----------------------------Write data ----------------------------
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        IO_data             <= data_Input(0);
        wait until rising_edge(clk);
        wait for 100ns;
        FIFO_ready          <= "001000";  --FIFO_ready2 =0
        wait for 20ns;

        for i in 1 to 9 loop
          IO_data <= data_Input(i);
          wait until rising_edge(clk);
          wait for 20ns;
        end loop;
        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
        for i in 10 to 15 loop
          IO_data <= data_Input(i);
          wait until rising_edge(clk);
          wait for 20ns;
        end loop;        
        FIFO_ready          <= "100000"; --FIFO_ready3 =0;

        for j in 1 to Data_Transfer_Size -1 loop
            for i in 0 to 8 loop
              IO_data <= data_Input(i+j*16);
              wait until rising_edge(clk);
              wait for 20ns;
            end loop;
            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
            for i in 9 to 15 loop
              IO_data <= data_Input(i+j*16);
              wait until rising_edge(clk);
              wait for 20ns;
            end loop;        
            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
        end loop;
        
        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                          
        wait for 300 ns;
        ------------------------READ CM->MUX->EM--------------------------
        GPP_CMD_Flag        <= '1';
        GPP_CMD_Data        <= x"00000000000000000000000000800024";          
        wait for 200 ns;
        GPP_CMD_Flag        <= '0';                   
        wait for 400 ns;        
        IO_WRITE_ACK        <= '1';
        wait for 40 ns;
        IO_WRITE_ACK        <= '0'; 
        wait for 1320 ns;
        FIFO_ready          <= "010000";  --FIFO_ready2 =1
        wait for 400 ns;
        for i in 1 to Data_Transfer_Size -1 loop
----        ----------------------------for test----------------------------
--            FIFO_ready          <= "001000";  --FIFO_ready2 =0
----        ----------------------------for test----------------------------           
            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
            wait for 40 ns;
            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
            wait for 460 ns; 
        end loop;
----        ----------------------------for test----------------------------
--        wait for 500ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 1140ns;
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
--        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
----        ----------------------------for test---------------------------- 
        progress    <= 1;     
        wait for 3000ns;             
        ------------------------------CM->MUX->EM----------------------------                
        ---------------------------------END---------------------------------
        ---------------------------------------------------------------------


--        -------------------------EM->TP->CM unicast--------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------        
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000800018";        
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1340 ns;--980 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
--        -----------------------------Write data ----------------------------
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        IO_data             <= data_Input(0);
--        wait until rising_edge(clk);
--        wait for 100ns;      
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0
--        wait for 20ns;

--        for i in 1 to 8 loop          --changed from 1 to 9 loop in EM->MUX->CM because it has one less line of code before checking fifo_ready3
--          IO_data <= data_Input(i);
--          wait until rising_edge(clk);
--          wait for 20ns;
--        end loop;
--        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--        for i in 9 to 15 loop
--          IO_data <= data_Input(i);
--          wait until rising_edge(clk);
--          wait for 20ns;
--        end loop;        
--        FIFO_ready          <= "100000"; --FIFO_ready3 =0;

--        for j in 1 to Data_Transfer_Size -1 loop
--            for i in 0 to 8 loop
--              IO_data <= data_Input(i+j*16);
--              wait until rising_edge(clk);
--              wait for 20ns;
--            end loop;
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            for i in 9 to 15 loop
--              IO_data <= data_Input(i+j*16);
--              wait until rising_edge(clk);
--              wait for 20ns;
--            end loop;        
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--        end loop;
        
--        FIFO_ready          <= "001000";  --FIFO_ready2 =0                                               
--        wait for 300 ns;
--        ------------------------READ CM->TP->EM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000800026";          
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1400 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 400 ns;
--        for i in 1 to Data_Transfer_Size -1 loop
--        ----------------------------for test----------------------------
----            FIFO_ready          <= "001000";  --FIFO_ready2 =0  
--        ----------------------------for test----------------------------            
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--            wait for 460 ns;
--        end loop;
--        ----------------------------for test----------------------------
----        wait for 500ns;
----        FIFO_ready          <= "010000";  --FIFO_ready2 =1
----        wait for 1140ns;
----        FIFO_ready          <= "001000";  --FIFO_ready2 =0
----        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--        ----------------------------for test----------------------------
--        wait for 8000ns;
--        ----------------------------CM->TP->EM---------------------------        
--        -------------------------------END-------------------------------        
--        -----------------------------------------------------------------



        
--        ------------------------EM->MUX->CM broadcast------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------
--        ---------------------------------------------------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"00000000000000000000000000200016";    
--        wait for 100 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0';
--        wait for 1340 ns;    --Based on this wait time, fifo_ready can come when code 49or4A is executed. after adding adapterFIFO will be fixed.
----        -----------------------------Write data ----------------------------        
--        FIFO_ready          <= "000001";  --FIFO_ready1 =1
--        for j in 0 to Data_Transfer_Size -1 loop
--            wait until NOC_DATA_EN = '1';
--            wait for 20ns;
--            IO_data             <= data_Input(j+2);
--        end loop;
--        wait for 5000ns;
----        ------------------------READ CM->MUX->EM--------------------------
--        GPP_CMD_Flag        <= '1';
--        GPP_CMD_Data        <= x"0000000000000000000000000020001E";          
--        wait for 200 ns;
--        GPP_CMD_Flag        <= '0';                   
--        wait for 400 ns;        
--        IO_WRITE_ACK        <= '1';
--        wait for 40 ns;
--        IO_WRITE_ACK        <= '0'; 
--        wait for 1320 ns;
--        FIFO_ready          <= "010000";  --FIFO_ready2 =1
--        wait for 400 ns;
--        for i in 0 to Data_Transfer_Size -1 loop
------        ----------------------------for test----------------------------
----            FIFO_ready          <= "001000";  --FIFO_ready2 =0  
------        ----------------------------for test----------------------------           
--            FIFO_ready          <= "111000"; --FIFO_ready3 =1;
--            wait for 40 ns;
--            FIFO_ready          <= "100000"; --FIFO_ready3 =0;
--            wait for 460 ns; 
--        end loop;
------        ----------------------------for test----------------------------
----        wait for 500ns;
----        FIFO_ready          <= "010000";  --FIFO_ready2 =1
----        wait for 1140ns;
----        FIFO_ready          <= "001000";  --FIFO_ready2 =0  
----        FIFO_ready          <= "111000"; --FIFO_ready3 =1;
------        ----------------------------for test----------------------------      
--        wait for 6000ns;

        ------------------------------CM->MUX->EM--------------------------        
        ---------------------------------END-------------------------------        
        -------------------------------------------------------------------
               
        --------------------------Assertion--------------------------
        progress <= 2;
        for k in 0 to (Data_Transfer_Size *16) -1 loop
          assert (outword(k) = data_Input(k)) report "Incorrect output data in "&integer'image(k) severity warning;
          wait for 1 ns;
        end loop;
        -------------------------------------------------------------           
        wait for 1000000ns;                                  
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
          if NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"1C" then
            outword(i) <= NOC_data;
            i  <= i +1;
          elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"1A" then
            outword(i) <= NOC_data;
            i  <= i +1; 
          elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"24" then
            outword(i) <= NOC_data;
            i  <= i +1; 
          elsif NOC_DATA_EN = '1' and GPP_CMD_Data(7 downto 0)= x"26" then
            outword(i) <= NOC_data;
            i  <= i +1;                        
          end if; 
        end if;   
    end process;
    
    process
    begin
        clk <= '0';
        for i in 1 to 30000000 loop
            wait for 10ns;
            clk <= not clk;
        end loop;
        wait;
    end process;        

end Behavioral;