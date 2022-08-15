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
-- Title      : Cluster Controller
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : cc.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The shared local memory(cmem) consists 512 kB memory shared by
--              32 dual-core clusters as well as its address pointers, buffers.
--              
-------------------------------------------------------------------------------
-- TO-DO list : --Configure with microprogram fields
--              --Add feedback signals
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2020-8-21  		     1.0	     CJ			Created
-- 2021-6-29             3.0         CJ         Add PE related logic and interface
--                                              Added clk_p and clk_e_neg for generate signals at falling_edge
-- 2021-8-9              3.1         CJ         Add even pulse signal generator
-- 2021-11-2             3.2         CJ         Make broadcast request an independent process than unicast and write
-- 2022-01-12            3.3         CJ         Add ID data to PEs
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cluster_pkg.all;
use work.all;

--use work.defines.all;

entity cluster_controller is
	generic(
		TAG_CMD_DECODE_TIME : integer := 52 --53     --azzzz38 "to add addr2 in tag line"  --Number of clock cycles for peci_busy to deassert
												--To be moved to defines
		);

  	port(
	--Clock inputs
      	CLK_P            : in std_logic;     --PE clock, clock from the oscillator --0628
	  	CLK_E            : in std_logic;     --NOC clock
	  	--CLK_E_NEG        : in std_logic;     --Inverted clk_e
	--Power reset input:
	    --RST_P            : in std_logic;
		RST_E            : in std_logic; --active low --For reset clk_e generator
	--Clock outputs
		DDO_VLD            : out std_logic;    --Output data valid port
		EVEN_P           : out std_logic;    --To PE and network
	--Tag line
		TAG              : in std_logic;
		TAG_FB           : out std_logic;
	--Data line   
		DATA             : in std_logic_vector(7 downto 0);
		DATA_OUT         : out std_logic_vector(7 downto 0);
	--PE Control
	    EXE              : out std_logic;   --Start execution
		RESUME           : out std_logic;   --Resume paused execution
	--Feedback signals
	    C_RDY               : out std_logic;
		PE_RDY_0         : in std_logic;
		PE_RDY_1         : in std_logic;
		PE_RDY_2         : in std_logic;
		PE_RDY_3         : in std_logic;
		PE_RDY_4         : in std_logic;
		PE_RDY_5         : in std_logic;
		PE_RDY_6         : in std_logic;
		PE_RDY_7         : in std_logic;
		PE_RDY_8         : in std_logic;
		PE_RDY_9         : in std_logic;
		PE_RDY_10         : in std_logic;
		PE_RDY_11         : in std_logic;
		PE_RDY_12         : in std_logic;
		PE_RDY_13         : in std_logic;
		PE_RDY_14         : in std_logic;
		PE_RDY_15         : in std_logic;
	--Request and distribution logic signals
	    RST_R            : out std_logic;  --Active low
		REQ_IN           : in std_logic;  --req to noc in reg logic
		REQ_FIFO          : in std_logic_vector(31 downto 0);
		DATA_FROM_PE     : in std_logic_vector(127 downto 0);
		DATA_TO_PE       : out std_logic_vector(127 downto 0);
		DATA_VLD         : out std_logic;
		PE_UNIT          : out std_logic_vector(5 downto 0);
		BC               : out std_logic; --Broadcast handshake
		RD_FIFO          : out std_logic;
		FIFO_VLD         : in std_logic
		--FOUR_WD_LEFT     : in std_logic 


		); 
end entity cluster_controller;
	   
architecture rtl of cluster_controller is
--COMPONENT dist_mem_gen_0
--  PORT (
--    a : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
--    d : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
--    clk : IN STD_LOGIC;
--    we : IN STD_LOGIC;
--    spo : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
--  );
--END COMPONENT;

component CMEM_32KX16 is
   port(
	     addr_c      :  in std_logic_vector(14 downto 0);
         CK          :  in std_logic;
		 WR          :  in std_logic;
		 RD          :  in std_logic;
		 DI0          :  in std_logic_vector(7 downto 0);
		 DI1          :  in std_logic_vector(7 downto 0);
		 DI2          :  in std_logic_vector(7 downto 0);
		 DI3          :  in std_logic_vector(7 downto 0);
		 DI4          :  in std_logic_vector(7 downto 0);
		 DI5          :  in std_logic_vector(7 downto 0);
		 DI6          :  in std_logic_vector(7 downto 0);
		 DI7          :  in std_logic_vector(7 downto 0);
		 DI8          :  in std_logic_vector(7 downto 0);
		 DI9          :  in std_logic_vector(7 downto 0);
		 DI10         :  in std_logic_vector(7 downto 0);
		 DI11         :  in std_logic_vector(7 downto 0);
		 DI12         :  in std_logic_vector(7 downto 0);
		 DI13         :  in std_logic_vector(7 downto 0);
		 DI14         :  in std_logic_vector(7 downto 0);
		 DI15         :  in std_logic_vector(7 downto 0);

		 DO0          :  out std_logic_vector(7 downto 0);
		 DO1          :  out std_logic_vector(7 downto 0);
		 DO2          :  out std_logic_vector(7 downto 0);
		 DO3          :  out std_logic_vector(7 downto 0);
		 DO4          :  out std_logic_vector(7 downto 0);
		 DO5          :  out std_logic_vector(7 downto 0);
		 DO6          :  out std_logic_vector(7 downto 0);
		 DO7          :  out std_logic_vector(7 downto 0);
		 DO8          :  out std_logic_vector(7 downto 0);
		 DO9          :  out std_logic_vector(7 downto 0);
		 DO10         :  out std_logic_vector(7 downto 0);
		 DO11         :  out std_logic_vector(7 downto 0);
		 DO12         :  out std_logic_vector(7 downto 0);
		 DO13         :  out std_logic_vector(7 downto 0);
		 DO14         :  out std_logic_vector(7 downto 0);
		 DO15         :  out std_logic_vector(7 downto 0)
 
		 );
end component;


  --Clock signals
  signal clk_m    : std_logic; --CM clock
  signal even_p_int   : std_logic; --even pulses of clk_p,should have the same phase as the even_c in PE
  signal even_p_1  : std_logic; --delta delay signals
  signal even_p_2  : std_logic; --delta delay signals 
  signal even_p_3  : std_logic;
  signal rst_i    : std_logic;
  --Control flip-flops  --TBD
  signal act      : std_logic;  --Activation
  signal c_rdy_i  : std_logic;  --Cluster ready feedback
  signal cmc      : std_logic;  --Communication
  signal dir_n    : std_logic;  --NOC side direction
  signal exe_i      : std_logic;  --Execution
  signal resume_i : std_logic; --Continue
  signal dir_p    : std_logic;  --PE side direction
  signal debug    : std_logic:='0';
  signal peci_busy : std_logic:='0'; --Cluster interface busy 
  signal cmd_in    : std_logic:='0'; --command incoming ff
  signal sig_fin   : std_logic:='0'; --Tag signal collected
  signal noc_reg_rdy : std_logic:='0';  --NOC data register ready to interact with cluster memory words
  signal noc_delay : std_logic; --one clock_e delay for noc_reg_rdy. Used to trigger 
  signal noc_write : std_logic:='0';  --Write command
  signal noc_read  : std_logic:='0';  --Read command
  signal pe_write  : std_logic;
  signal pe_read   : std_logic;
  signal delay     : std_logic:='0';  --Delay flipflop
  --signal rd_trig   : std_logic;       --Read case trigger
  signal req_int   : std_logic;      --Request type ff
  signal broadcast_int : std_logic;  --Broadcast to PE
  signal r_delay   :std_logic;  --First clock delay when read.
  signal pe_req_type : std_logic_vector(1 downto 0);
  signal cb_status  : std_logic;
  signal req_bexe  : std_logic;
  signal req_exe   : std_logic;
  signal write_req : std_logic;
  signal bc_i : std_logic_vector(6 downto 0);
  signal cl_net_fifo_rd : std_logic;
  signal rd_fifo_i : std_logic;
  signal datain_vld  : std_logic;
  signal dataout_vld : std_logic;
  --Control registers
  type reg is array (15 downto 0) of std_logic_vector(7 downto 0);
  signal mem_in      : reg; --Input register to memory
  signal mem_out     : reg; --Output register of memory    
  signal noc_data_in     : reg;                        --NOC data input register
  signal noc_data_out    : reg;                        --NOC data output register
  signal sync_collector : std_logic_vector(1 downto 0);
  --signal data_out     : reg;
  signal pe_data_in      : reg;                     --Input register form pe side
  signal data_core_int : reg;                       --Data register for PE --pe_data_out
  signal req_last     : std_logic_vector(5 downto 0);   --Request last field
  signal addr_c       : std_logic_vector(14 downto 0);   --CMEM column address pointer
  signal addr_n       : std_logic_vector(14 downto 0);   --NOC address pointer
  signal addr2_n      : std_logic_vector(14 downto 0);   --azzzz addr2 for NOC2
  signal addr_p       : std_logic_vector(14 downto 0);   --PE  side address pointer
  signal req_addr_p   : std_logic_vector(14 downto 0);
  signal noc_cmd_buf  : std_logic_vector(4 downto 0);    --NOC command buffer
  signal noc_cmd      : std_logic_vector(4 downto 0);    --NOC command control register
  signal pe_int       : std_logic_vector(1 downto 0);    --PE internal destination
  signal pe_num       : std_logic_vector(5 downto 0);    --PEs' seriel number
  --signal pe_to_CM     : std_logic_vector(127 downto 0);
  signal id_num       : std_logic_vector(5 downto 0);
  signal wr_i        : std_logic;
  signal rd_i         : std_logic;
  --State machine
  signal byte_ctr     : std_logic_vector(3 downto 0):="0000";    --Byte counter
  signal byte_ctr_buffer : std_logic_vector (3 downto 0);  --Buffers to delay 1 clock cycle for byte counter
  signal len_ctr      : std_logic_vector(14 downto 0);
  signal len_ctr_p    : std_logic_vector(8 downto 0);   --Data block length counter
  signal req_len_ctr_p : std_logic_vector(8 downto 0);
  signal pk_reg       : std_logic_vector(3 downto 0);  --Data pack size register, length TBD or to be a constant instead
  signal pk_ctr       : std_logic_vector(3 downto 0);
  signal dist_reg     : std_logic_vector(3 downto 0);  --Data pack distance register, length TBD
  signal dist_ctr     : std_logic_vector(3 downto 0);
  signal b_cast_ctr   : std_logic_vector(5 downto 0);
  signal write_count  : std_logic_vector(1 downto 0); --Wr req data counter
  --Delay signal
  signal delay_c      : std_logic_vector(TAG_CMD_DECODE_TIME-9 downto 0);--(31 downto 0);--(29  downto 0);
  signal delay_b      : std_logic_vector(TAG_CMD_DECODE_TIME-4 downto 0);
  signal delay_pipe   : std_logic_vector(7 downto 0);  --for delay between tag shift finishes and sync pulse comes
  signal rd_ena       : std_logic;
  signal dataout_vld_o : std_logic;
 
  signal standby : std_logic;
  signal delay_p : std_logic;
  signal delay2  : std_logic;
  
  signal tag_ctr_2 : unsigned(5 downto 0) := "101101"; --azzzz 45 "to add addr2 in tag line" --"011110"; --30
  signal tag_ctr_3 : unsigned(5 downto 0) := "100110"; --38
  signal tag_ctr_1 : unsigned(5 downto 0);
 
begin
----------------------------
--Clock domains
----------------------------
--All interactions with NOC are synchronized with clk_e.
--All transportations between CC and PEs are synchronized with even_p_int signal.   
even_p_generateor: process(rst_i,clk_p)
begin
	if rst_i = '0' then --if rst_e = '1' then
		even_p_1 <= '1';
	elsif rising_edge(clk_p) then
		    even_p_1 <= not even_p_1;
	end if;
end process;
even_p_2 <= even_p_1;   --two delta delay to make sure the even_p comes later than clk_p to the processors.
even_p_3 <= even_p_2;   --two delta delay to make sure the even_p comes later than clk_p to the processors. Even_p uses this signal 
even_p_int <= even_p_3;  --3 delta delay to make sure the processor signals comes later than clk_e inside PE, All PE interfaces use this signal
EVEN_P <= even_p_2;		  
		  
  
  ------------------------------------------------------------------------------
  -- NOC commnad decoding
  ------------------------------------------------------------------------------
  rst : process(clk_e)
  begin
	if rising_edge(clk_e) then
		if noc_cmd = "01111" then
		  rst_i <= '0';
		else
		  rst_i <= '1';
		end if;
	end if;
  end process;
  --This process generates peci_busy and sig_fin flags to indicate that the current command is being executed
  cmd_activate : process(clk_e) --39 - 33 = 6 6 must be kept
--    variable tag_ctr_1 : integer;  -- Reaction time, 38 clock cycles. To be replaced within define document
  begin 
	if rising_edge(clk_e)then
		if noc_cmd = "01111" or noc_cmd = "00110" then
			sig_fin <= '0';
			peci_busy <= '0';
	    elsif noc_reg_rdy= '1' and len_ctr = "000000000000001" then --azzz as len_ctr decreases after noc_reg_rdy = '1' (len_ctr = "000000000000001")   Refresh when data transfer is finished
			sig_fin <= '0';
		elsif peci_busy = '0' and sig_fin = '0' then
			tag_ctr_1 <= to_unsigned(TAG_CMD_DECODE_TIME,6); 
            if tag = '1' then
                peci_busy <= '1'; 
            else
                peci_busy <= '0';
			end if;
        elsif peci_busy= '1' then
            tag_ctr_1 <= tag_ctr_1-1;
			if tag_ctr_1 = TAG_CMD_DECODE_TIME -5 then --azzzz TAG_CMD_DECODE_TIME -6 then --5 for collecting data to NOC command buffer, 1 for transfer form buffer to NOC command register
				sig_fin <= '1';
			elsif tag_ctr_1 = 0 then
                peci_busy <= '0';
			end if;
		end if;
	end if;
  end process;
  
	--This process translates the incoming data from tag line to command register
    tag_translate : process (clk_e)
    variable noc_cmd_ctr : integer :=5;
    begin
    	  if rising_edge (clk_e) then
    	        if noc_cmd = "01111" then
    			    noc_cmd <= (others => '0');
    			    noc_cmd_buf <= (others => '0');
    		    elsif peci_busy = '1' and sig_fin = '0' then
    			    if noc_cmd_ctr /= 0 then
    			    noc_cmd <= (others => '1');
    			    --noc_cmd <= noc_cmd_buf;
    			    noc_cmd_buf(0)<= tag;
    			    for i in 0 to 3 loop
    			    noc_cmd_buf(i+1) <= noc_cmd_buf(i);
    			    end loop;
    			    noc_cmd_ctr := noc_cmd_ctr -1;
    			    elsif noc_cmd_ctr = 0 then
    			    noc_cmd <= noc_cmd_buf;
    			    end if;
			    elsif peci_busy='0' and sig_fin='0' and delay2='0' then
					noc_cmd_ctr := 5;
					noc_cmd <= (others => '0');
    		    else 
    			    noc_cmd_ctr := 5;
    			    --noc_cmd <= (others => '0');
    		    end if;
    	  end if;
    end process;
  
    --Generate execution and resume signals. exe_i and resume_i only get one pulse 
	--per command.
    exe_and_resume: process(clk_p)
		variable idle: boolean;
	begin
		if rising_edge(clk_p) then
			if even_p_int = '0' then --use even_p_3 signal to make sure exe and resume comes later than even_p signal to PEs
				if noc_cmd = "01111" then
					exe_i <= '0';
					resume_i <= '0';
					idle := true;
				elsif noc_cmd = "00110" then --exe command
					resume_i <= '0';
					if idle then
						exe_i <= '1';
						idle := false;
					else
						exe_i <= '0';
					end if;
				elsif noc_cmd = "01000" then --continue command
					exe_i <= '0';
					if idle then
						resume_i<= '1';
						idle := false;
					else
						resume_i <= '0';
					end if;
				else
				    exe_i <= '0';
				    resume_i <= '0';
					idle := true;
				end if;
			end if;
		end if;
	end process;
    EXE <= exe_i;
	RESUME <= resume_i;

  
  ------------------------------------------------------------------------------
  -- Data transfer
  ------------------------------------------------------------------------------  
	--This counter counts the number of clocks for the lenth counter data and
	--the starting addres data to come from the tag line and asserts a delay 
	--signal afterwards. 
	delay_count: process(clk_e)  
	begin

		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				delay <= '0';
				delay2 <= '0';
				delay_c <= (others => '0');
				delay_b <= (others => '0');
			elsif noc_cmd = "00011" then		--azzz WriteBlockC	
			    if noc_reg_rdy= '1' and len_ctr = "000000000000001" then  --azzz as len_ctr decreases after noc_reg_rdy = '1' (len_ctr = "000000000000000")
				    delay <= '0';
				    delay2 <= '0';
			    elsif peci_busy = '1' and sig_fin = '1' then
			    	delay_c(0) <= '1';
		            for i in 0 to TAG_CMD_DECODE_TIME-10 loop
			    		delay_c(i+1) <= delay_c(i);
			    	end loop;
					delay <= delay_c(TAG_CMD_DECODE_TIME-9); --(31); --(29); --changed to assert one clock before data comes
				end if;

				delay_pipe(0) <= delay;
		        for i in 0 to 3 loop
			        delay_pipe(i+1) <= delay_pipe(i);
			    end loop;
			    
			    delay2 <= delay_pipe(4); 			
				
			elsif noc_cmd = "00101" then     --azzz WriteBlockB
				if noc_reg_rdy= '1' and len_ctr = "000000000000000" then 
					delay <= '0';
					delay2 <= '0';
				elsif peci_busy = '1' and sig_fin = '1' then	
			    	delay_b(0) <= '1';
		            for i in 0 to TAG_CMD_DECODE_TIME-5 loop
			    	    delay_b(i+1) <= delay_b(i);
			    	end loop;
			    	delay <= delay_b(TAG_CMD_DECODE_TIME-4);
				end if;
			elsif noc_cmd = "00100" then     --azzz ReadBlock
				if byte_ctr = "0000" and len_ctr = "000000000000000" then  --azzz as len_ctr decreases after noc_reg_rdy = '1' (len_ctr = "111111111111111")
					delay <= '0';
					delay2 <= '0';
				elsif peci_busy = '1' and sig_fin = '1' then
						delay_c(0) <= '1';
						for i in 0 to TAG_CMD_DECODE_TIME-10 loop
							delay_c(i+1) <= delay_c(i);
						end loop;
						delay <= delay_c(TAG_CMD_DECODE_TIME-9);
				end if;
				delay_pipe(0) <= delay;
		        for i in 0 to 3 loop
			        delay_pipe(i+1) <= delay_pipe(i);
			    end loop;
			    
			    delay2 <= delay_pipe(4); 
		    else 
		        delay_c <=(others => '0');
		        delay_b <=(others => '0');
			end if;
		end if;
	end process;
	--This process generates a the latched delay signals to control the behaviour 
	--of some triggers.
	rd_act : process(clk_e)
    begin
		if rising_edge(clk_e) then
            noc_delay <= noc_reg_rdy;
			--one_c_delay <= delay;
			--two_c_delay <= one_c_delay;
			--three_c_delay <= two_c_delay;
		end if;
	end process; 
	--rd_trig <= (one_c_delay and two_c_delay and three_c_delay);	
	
	
	--Byte counter calculation
	--Byte counter is used to indicate which byte of the noc_data_in register
	--and noc_data_out register is being activated. 	  
	byte_ctr_cal: process (clk_e)
	
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				byte_ctr <= "1111";  --azzzz "0000";
		    elsif noc_cmd = "00011" or noc_cmd = "00101" then
	            if delay2 = '1' and datain_vld = '1' then
                 	byte_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(byte_ctr))-1,4));
				else
					byte_ctr <= "1111"; 
                end if;
			elsif noc_cmd = "00100" then
				if delay = '1'  and dataout_vld = '1'then
					byte_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(byte_ctr))-1,4));
				else
					byte_ctr <= "1111"; 
				end if;
			else
				byte_ctr<= "0000";
		    end if;
		end if;
	end process;

	
	extended_sync_pulse_collector : process(clk_e)
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				sync_collector <= (others => '0');
			elsif noc_cmd = "00011" or noc_cmd = "00101" or noc_cmd = "00100" then
				if delay2 = '1' then
					sync_collector(0) <= tag;
					sync_collector(1) <= sync_collector(0);
				else
					sync_collector <=(others => '0');
				end if;
			else
				sync_collector <=(others => '0');
			end if;
		end if;
	end process;

	datain_valid_generator: process(clk_e)
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				datain_vld <= '0';
			elsif noc_cmd = "00011" or noc_cmd = "00101" then
				if sync_collector = "11" then
					datain_vld <= '1';
				elsif byte_ctr = "0000" then
					datain_vld <= '0';
				end if;
			end if;
		end if;
	end process;

	dataout_vld_generator: process(clk_e)
	begin
		if rising_edge(clk_e) then
			if noc_cmd ="01111" then
				dataout_vld <= '0';
			elsif noc_cmd = "00100" then
				if noc_read = '1' then
					dataout_vld <= '1';
				elsif byte_ctr = "0000" then
					dataout_vld <= '0';
				end if;
			end if;
		end if;
	end process;
	
	
	--This process generates memory interaction signals to control the write or read.
	mem_activation : process(clk_e)
    begin
		if rising_edge(clk_e) then
			noc_reg_rdy <= '0';
        	noc_write <= '0';
        	noc_read <= '0';
			if noc_cmd = "01111" then
				noc_reg_rdy <= '0';
        	    noc_write <= '0';
        	    noc_read <= '0';
        	elsif delay2 = '1' then     
			    if noc_cmd = "00011" or noc_cmd = "00101" then
			        if byte_ctr = "0000" then 
			        	noc_reg_rdy <= '1';
        	            noc_write <= '1';
						noc_read <= '0';
			        else
			            noc_reg_rdy <= '0';
        	            noc_write <= '0';
			    	end if;
			    elsif noc_cmd = "00100" then
			    	if sync_collector= "11" then
			    		noc_reg_rdy <= '1';
        	            noc_read <= '1';
			    	else 
			    		noc_reg_rdy <= '0';
        	            noc_read <= '0';
			    	end if;   
			    else 
			    	noc_reg_rdy <='0';
        	        noc_write <= '0';
        	        noc_read <= '0';   
	    	    end if;
			end if;
		end if;
	end process;
	--one clock delay of noc_read to load data in noc_data_out register to output port
	process(clk_e)
	begin
		if rising_edge(clk_e) then
			dataout_vld_o <= dataout_vld;
		end if;
	end process;
	DDO_VLD <= dataout_vld_o;
	--Write data from DATA port byte by byte to the noc_data_in register
	data_write : process (clk_e)--(noc_cmd, byte_ctr, delay, DATA)
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				noc_data_in <=(others => (others => '0'));
			elsif delay2 = '1' then
        	  if noc_cmd = "00011" or noc_cmd ="00101" then
				noc_data_in(to_integer(unsigned(byte_ctr))) <= DATA;
			  end if;
			end if;
		end if;
	end process;

	--Read data to DATA_OUT port byte by byte from noc_data_out register.
	data_read : process (clk_e)--dataout_vld,byte_ctr,noc_data_out)
    begin
		if rising_edge(clk_e) then
	    	if dataout_vld = '1' then
	    	    DATA_OUT <= noc_data_out(to_integer(unsigned(byte_ctr)));
	    	else
	    	    DATA_OUT <= (others => '0');
        	end if;
		end if;
	end process;
    --This process writes lenth counter, noc address pointer counter, package
	--counter and distance counter with data from tag line under the control of 
	--noc_cmd register and trigger signals.
    memory_interaction : process (clk_e)
--	variable tag_ctr_2 : integer;
--	variable tag_ctr_3 : integer;  
    begin
	if rising_edge(clk_e) then
		if noc_cmd = "01111" then
			tag_ctr_2 <= "101101"; --azzzz 45 "to add addr2 in tag line" --"011110"; --30
			tag_ctr_3 <= "100110"; --38;
			len_ctr <= (others => '0');
			addr_n  <= (others => '0');
			addr2_n  <= (others => '0');
			pk_reg  <= (others => '0');
			dist_reg <= (others => '0'); 
		elsif sig_fin = '1' and delay = '0' then
		    if noc_cmd = "00011" or noc_cmd = "00100" then
                tag_ctr_2 <= tag_ctr_2 - 1;
                if tag_ctr_2 >= 30 then --azzzz 15 then  to add addr2 in tag line
                    len_ctr(0) <= tag; 
                    for i in 0 to 13 loop
                        len_ctr(i+1)<= len_ctr(i);
                    end loop;
                elsif tag_ctr_2 < 30 and tag_ctr_2 >= 15 then    --azzzz  tag_ctr_2 <= 15 and tag_ctr_2 >= 0 then   "to add addr2 in tag line"
                    addr_n(0) <= tag;
                    for i in 0 to 13 loop
                        addr_n(i+1)<= addr_n(i);
                    end loop;
                elsif tag_ctr_2 < 15 and tag_ctr_2 >= 0 then     --azzzz  tag_ctr_2 <= 15 and tag_ctr_2 >= 0 then   "to add addr2 in tag line"
                    addr2_n(0) <= tag;
                    for i in 0 to 13 loop
                        addr2_n(i+1)<= addr2_n(i);
                    end loop;		    		
                end if;
		    elsif noc_cmd = "00101" then
		    	tag_ctr_3<= tag_ctr_3-1;
		    	if tag_ctr_3 > 22 then
		    		len_ctr(0) <= tag; 
		    		for i in 0 to 13 loop
		    			len_ctr(i+1)<= len_ctr(i);
		    		end loop;
		    	elsif tag_ctr_3 > 7 then
		    		addr_n(0) <= tag;
		    		for i in 0 to 13 loop
		    			addr_n(i+1)<= addr_n(i);
		    		end loop;
		    	elsif tag_ctr_3 > 3 then
		    		pk_reg(0) <= tag;
		    		for i in 0 to 2 loop
		    			pk_reg(i+1)<= pk_reg(i);
		    		end loop;
		    	elsif tag_ctr_3 >= 0 then
		    		dist_reg(0) <= tag;
		    		for i in 0 to 2 loop
		    			dist_reg(i+1)<= dist_reg(i);
		    		end loop;
		    	end if;
		    end if;
	    elsif delay2 = '1' then   -- azzz delay = '1' then changed to delay2 because of the delay before receiving data
			tag_ctr_2 <= "101101"; --azzzz 45 to add addr2 in tag line --"011110"; --30
			tag_ctr_3 <= "100110"; --38;
		    if noc_reg_rdy = '1' then
                if noc_cmd = "00011" then
		                len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		            	addr_n <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_n))+1,15));
		        --Read block
		        elsif noc_cmd = "00100" then
		        		len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		        		addr_n <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_n))+1,15));
		        --Write block burst
		        elsif noc_cmd = "00101" then
		            if dist_ctr = (dist_ctr'range => '0') and noc_write = '0'then
		            	pk_ctr <= pk_reg;
		            elsif pk_ctr = (pk_ctr'range => '0') then		
		            	dist_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(dist_ctr))-1,4));
		            elsif noc_write = '1' then
		              	pk_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(pk_ctr))-1,4));
		              	addr_n <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_n))+1,15));
		            	len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		              	dist_ctr <= dist_reg;
		            end if;
		        end if;
            else
		    	len_ctr  <= len_ctr ;
		    	addr_n   <= addr_n  ;
		    	addr2_n   <= addr2_n  ;
		    	pk_reg   <= pk_reg  ;
		    	dist_reg <= dist_reg;
		    	pk_ctr   <= pk_ctr  ;
		    	dist_ctr <= dist_ctr;
	        end if;
	    elsif delay2 = '0' then  -- azzz delay = '0' then changed to delay2 as it needs to run this when TAG data is sent and the delay before receiving data is gone 
			pk_ctr <= (others => '0'); --reset
			dist_ctr <=(others => '0'); --reset
		end if;
	end if;
	end process;
	
 --	-----------------------------------------------------------------------------
 --	--PEC side 
 --	-----------------------------------------------------------------------------
 --	--Request logic reset
     RST_R <= rst_i;

 -- Fetch data from req_fifo
    process(clk_p)
         --Save 1 clock to handle the request
	begin
		if rising_edge(clk_p) then --RD_REQ raises at falling_edge of clk_e
			if noc_cmd = "01111" then
				RD_FIFO <= '0';
                standby <= '1';
            elsif even_p_int = '1' then --RD_FIFO raises at falling_edge of clk_e
                

			    if REQ_IN = '1' and req_exe = '0' and write_req = '0' and standby = '1' then --normal case
			    	RD_FIFO <= '1';
					standby <= '0';
			    --elsif req_exe = '1' and write_req = '1' and write_count /= "11" then --write case
			    	--RD_FIFO <= '1';
				elsif req_exe = '1' or cb_status = '1' then
                    standby <= '1';
			    else
					RD_FIFO <= '0';
			    end if;
			else
				RD_FIFO <= '0';
            end if;
		end if;
	end process;

	--Treanslate the requests from PEs
 	req_recording: process(clk_p)
 	begin
 		if rising_edge(clk_p) then --0628 --only have meaning at falling_edge of clk_e
			if noc_cmd = "01111" then
				pe_req_type <= (others => '0');
				req_addr_p <= (others => '0');
				req_len_ctr_p <= (others => '0');
				req_last <= (others => '0');
                bc_i <= (others => '0');

			elsif FIFO_VLD = '1' and req_exe = '0' and req_bexe = '0' and write_req = '0' and cb_status = '0'then 
 				pe_req_type <= REQ_FIFO(31 downto 30);
 				req_addr_p <= REQ_FIFO(14 downto 0);
 				--req_len_ctr_p <=std_logic_vector(unsigned('0' & REQ_FIFO(23 downto 16)) + 1);--additional one bits for maximum transfer case
 				req_last <= REQ_FIFO(29 downto 24);
                bc_i(0) <= (not REQ_FIFO(31)) and REQ_FIFO(30); --Temp, to be integrated to id_num(req_last) field later for 16 PE version.
            elsif (req_exe = '1' or req_bexe = '1')and len_ctr_p = "000000001" then
                pe_req_type <= (others => '0');
				req_addr_p <= (others => '0');
				--req_len_ctr_p <= (others => '0');
				req_last <= (others => '0');

                bc_i(0) <= '0';

 			end if;
			for i in 0 to 5 loop
				bc_i(i+1) <= bc_i(i);
			end loop;
 		end if;
 	end process;

    BC<= bc_i(6);
	--Generate activation signals of counters for PEs' requests. 
	--Including broadcast request, unicast request and write request.
    process(clk_p) --Reset need to be added 
	begin 
		if rising_edge(clk_p) then
			if noc_cmd = "01111" then
				req_exe <= '0';
				req_bexe <= '0';
				cb_status <= '0';
				b_cast_ctr <= (others => '0');
				write_req <= '0';
			elsif even_p_int = '0' then 
			    if req_exe = '0' and req_bexe = '0' then
			        if pe_req_type = "01" then
			        	if cb_status = '0' then
			        		cb_status <= '1';
			        		b_cast_ctr <= req_last;
			        	elsif cb_status = '1' then
			        		if FIFO_VLD = '1' and b_cast_ctr /= "000000" then
			        			b_cast_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(b_cast_ctr))-1,6)); --test the last request income case
			        		elsif b_cast_ctr = "000000" then
			        			if len_ctr_p /= "000000000" then
			        				req_bexe <= '1';
			        			end if;
			        		end if;
			        	end if;
			        elsif pe_req_type = "10" then
			        	id_num <= req_last;
			        	if len_ctr_p /= "000000000" then
			        		req_exe <= '1';
			        	end if;
			        elsif pe_req_type = "11" then	
			        	id_num <= req_last;
                        write_req <= '1';
			        	if len_ctr_p /= "000000000" then
			        		req_exe <= '1';
			        	end if;
			        end if;
                elsif req_bexe = '1' then  --Reset broadcast signals
                    if len_ctr_p = "000000001" then
                        req_bexe <= '0';
			    		cb_status <= '0';
                    end if;
                elsif req_exe = '1' then --Reset unicast signals
			    	if len_ctr_p = "000000001" then
                        req_exe <= '0';
			    	end if;
    
			    	--if write_count = "11" then
			    		write_req<= '0';
			    	--end if;
                end if;
			end if;
		end if;
	end process;
    PE_UNIT <= id_num;
	--Activation of the counters
	counting : process(clk_p)  
	begin
		if rising_edge(clk_p) then 
			if noc_cmd = "01111" then
				addr_p <= (others => '0');
				len_ctr_p <= (others => '0');
				write_count <= "00";
				pe_write <= '0';
				pe_read <= '0';
			elsif even_p_int = '0' then	
				if noc_reg_rdy = '0' then
					pe_read <= '0';
					pe_write <= '0';
					if req_bexe = '1' then
						addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,15));
						len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9));
						pe_read <= '1'; 
				    elsif req_exe = '1' then
						if write_req = '0' then
						    addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,15));
						    len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9));
							if pe_write = '0' then
								pe_read <= '1';
							end if; 
						elsif write_req = '1' then--and fifo_vld = '1' then
							--pe_data_in(4*to_integer(unsigned(write_count))) <= REQ_FIFO(7 downto 0);
            	            --pe_data_in(4*to_integer(unsigned(write_count))+1) <=REQ_FIFO(15 downto 8);
            	            --pe_data_in(4*to_integer(unsigned(write_count))+2) <=REQ_FIFO(23 downto 16);
            	            --pe_data_in(4*to_integer(unsigned(write_count))+3) <=REQ_FIFO(31 downto 24);
							--write_count <= std_logic_vector(to_unsigned(to_integer(unsigned(write_count))+1,2));
							len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9)); 
							--if write_count = "11" then
								pe_write <= '1';
							--else
								--pe_write <= '0';
							--end if;
						end if;
					elsif FIFO_VLD = '1' and req_exe = '0' and req_bexe = '0' and write_req = '0' and cb_status = '0'then
						addr_p <= REQ_FIFO(14 downto 0);
						len_ctr_p <= std_logic_vector(unsigned('0' & REQ_FIFO(23 downto 16)) + 1);
					elsif pe_req_type = "11" then  --Add trade off. For 4B version, the len_ctr is "11" but for 20B version, it is "00" instead.
												   --Will delete when the micorocde is modified for 20B version with "00" in len_ctr field. 
						len_ctr_p <= '0'& x"01";

					end if;
				end if;
			end if;
		end if;
	end process;
	--Data buffer
	process(DATA_FROM_PE)
	begin
		for i in 0 to 3 loop                                     --incoming data in formatt(a1,b1,c1,d1,a2,b2,c2,d2,a3,b3,c3,d3,a4,b4,c4,d4)
			pe_data_in(i) <= DATA_FROM_PE(8*i+103 downto 8*i+96);--pe_data_in in format(a4,b4,c4,d4,a3,b3,c3,d3,a2,b2,c2,d2,a1,b1,c1,d1)
			pe_data_in(i+4) <= DATA_FROM_PE(8*i+71 downto 8*i+64);
			pe_data_in(i+8) <= DATA_FROM_PE(8*i+39 downto 8*i+32);
			pe_data_in(i+12) <= DATA_FROM_PE(8*i+7 downto 8*i);
		end loop;
	end process;


--distribution network
    process (clk_p)
    begin
    	if rising_edge(clk_p) then 
			if even_p_int = '0' then 
            	if pe_read ='1' then --Data valid asserts together with output data
    	    	    for i in 15 downto 0 loop
    	    	    	DATA_TO_PE(8*i+7 downto 8*i) <= data_core_int(i);
    	    	    end loop;
    	    	    	DATA_VLD <= not noc_reg_rdy;
            	else
            	    DATA_TO_PE <= (others=>'0');
            	    DATA_VLD <= '0';
            	end if;
			end if;
        end if;
    end process;


 --Address & trigger MUX
 process(noc_reg_rdy,addr_p, addr_n, noc_write, noc_read, pe_write, pe_read)				
 begin
 	if noc_reg_rdy = '1' then  --to be replaced with noc_enable (CM access arbiter)
 		addr_c <= addr_n;
		wr_i <= noc_write;
		rd_i <= noc_read;
 	elsif noc_reg_rdy /= '1' then
 		addr_c <= addr_p;
		wr_i <= pe_write;
		rd_i <= pe_read;
 	end if;
 end process;

 --Data MUX
 --Input MUX
    process(noc_reg_rdy, pe_data_in, noc_data_in)
    begin
		mem_in <= pe_data_in;
        if noc_reg_rdy = '1' then
            mem_in <= noc_data_in;
        end if;
    end process;
--Output Latch
    noc_data_out <= data_core_int when noc_delay = '1';

TAG_FB <= sig_fin or delay;
---------------------------------------------
--Cluster ready indecator
---------------------------------------------
c_rdy_i <= PE_RDY_0 and PE_RDY_1 and PE_RDY_2 and PE_RDY_3 and
           PE_RDY_4 and PE_RDY_5 and PE_RDY_6 and PE_RDY_7 and
		   PE_RDY_8 and PE_RDY_9 and PE_RDY_10 and PE_RDY_11 and
		   PE_RDY_12 and PE_RDY_13 and PE_RDY_14 and PE_RDY_15;
		   
C_RDY <= c_rdy_i and not REQ_IN and not req_exe and not pe_write;
----------------------------------------------------------------------------------	
process(clk_e)
begin
	if rising_edge(clk_e) then
		if noc_cmd = "00100" then
		rd_ena <= '1';
		else
		rd_ena <= '0';
		end if;
	end if;
end process;

--CLK_O <= dataout_vld_o and clk_e;

process(clk_e)
begin
if rising_edge(clk_e) then
    delay_p <= delay;
end if;
end process;
				
	--Memory blocks
    clustermem : CMEM_32KX16
	port map (
		addr_c => addr_c, 
		CK => clk_e,
		WR => wr_i, --To be written as one write ff instead of 2 ffs
		RD => rd_i, --unused
        DI0 => mem_in(0),
		DI1 => mem_in(1),
		DI2 => mem_in(2),
		DI3 => mem_in(3),
		DI4 => mem_in(4),
		DI5 => mem_in(5),
		DI6 => mem_in(6),
		DI7 => mem_in(7),
		DI8 => mem_in(8),
		DI9 => mem_in(9),
		DI10 => mem_in(10),
		DI11 => mem_in(11),
		DI12 => mem_in(12),
		DI13 => mem_in(13),
		DI14 => mem_in(14),
		DI15 => mem_in(15),

		DO0 => data_core_int(0),
		DO1 => data_core_int(1),
		DO2 => data_core_int(2),
		DO3 => data_core_int(3),
		DO4 => data_core_int(4),
		DO5 => data_core_int(5),
		DO6 => data_core_int(6),
		DO7 => data_core_int(7),
		DO8 => data_core_int(8),
		DO9 => data_core_int(9),
		DO10 => data_core_int(10),
		DO11 => data_core_int(11),
		DO12 => data_core_int(12),
		DO13 => data_core_int(13),
		DO14 => data_core_int(14),
		DO15 => data_core_int(15)
        );		
	

end architecture rtl; 

-----------------------------------------------------------
--NOTE
-----------------------------------------------------------

--CM Address Arbiter expects NOC side have higher priority then PE side. 