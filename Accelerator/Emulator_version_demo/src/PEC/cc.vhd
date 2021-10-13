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
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--use work.defines.all;

entity cluster_controller is
  port(
--Clock inputs
      CLK_P            : in std_logic;     --PE clock --0628
	  CLK_E            : in std_logic;     --PE's execution clock 
	  --CLK_E_NEG        : in std_logic;     --Inverted clk_e
--Power reset input:
      --RST_P            : in std_logic;
	  RST_E            : in std_logic; --active low --For reset clk_e generator
--Clock outputs
	  CLK_O            : out std_logic;    --not needed in this version
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

component delay_count is
	port(
		 clk_e             :   in std_logic;
         peci_busy         :   in std_logic;
         sig_fin           :   in std_logic;
         noc_cmd           :   in std_logic_vector(4 downto 0);
         noc_reg_rdy       :   in std_logic;
         len_ctr           :   in std_logic_vector(14 downto 0);

         delay             :   out std_logic
        
		);
end component;

component mem_ctrl is
	port(
		clk_e           : in std_logic;
        byte_ctr        : in std_logic_vector(3 downto 0);
        delay           : in std_logic;
        noc_cmd         : in std_logic_vector(4 downto 0);

        noc_reg_rdy     : out std_logic;
        noc_write       : out std_logic;
        noc_read        : out std_logic

		);
end component;

  --Clock signals
  signal clk_m    : std_logic; --CM clock
  signal even_p_int   : std_logic; --even pulses of clk_p,should have the same phase as the even_c in PE
  signal rst_i    : std_logic;
  --Control flip-flops  --TBD
  signal act      : std_logic;  --Activation
  signal c_rdy_i  : std_logic;  --Cluster ready feedback
  --signal rst_en   : std_logic;  --Reset
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
  signal rd_trig   : std_logic;       --Read case trigger
  signal req_int   : std_logic;      --Request type ff
  signal broadcast_int : std_logic;  --Broadcast to PE
  signal r_delay   :std_logic;  --First clock delay when read.
  signal pe_req_type : std_logic_vector(1 downto 0);
  signal cb_status  : std_logic;
  signal req_exe   : std_logic;
  signal write_req : std_logic;
  signal bc_i : std_logic;
  --Control registers
  type reg is array (15 downto 0) of std_logic_vector(7 downto 0);
  signal mem_in      : reg; --Input register to memory
  signal mem_out     : reg; --Output register of memory    
  signal noc_data_in     : reg;                        --NOC data input register
  signal noc_data_out    : reg;                        --NOC data output register
  --signal data_out     : reg;
  signal pe_data_in      : reg;                     --Input register form pe side
  signal data_core_int : reg;                       --Data register for PE --pe_data_out
  signal req_last     : std_logic_vector(5 downto 0);   --Request last field
  signal addr_c       : std_logic_vector(14 downto 0);   --CMEM column address pointer
  signal addr_n       : std_logic_vector(14 downto 0);   --NOC address pointer
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
  --signal tag_ctr      : std_logic_vector(5 downto 0);  
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
  --constant dn_c       : integer :=32  --Data delay for continous writing and reading
  --constant dn_b       : integer :=32+TBD1+TBD2;  --Data delay for burst writing
  --signal delay_c      : std_logic_vector(33 downto 0);--(31 downto 0);--(29  downto 0);
  --signal delay_b      : std_logic_vector(37 downto 0);
  signal rd_ena       : std_logic;
  
  signal one_c_delay :std_logic;
  signal two_c_delay :std_logic;
  
 
begin
          
even_p_generateor: process(rst_e,clk_p)
begin
	if rst_e = '1' then 
		even_p_int <= '1';
	elsif rising_edge(clk_p) then
		    even_p_int <= not even_p_int;
	end if;
end process;
EVEN_P <= even_p_int;		  
		  
  ------------------------------------------------------------------------------
  -- Reset
  ------------------------------------------------------------------------------
--  reset: process(clk_e, sig_fin)
--  begin
--	if rising_edge(clk_e) then
--		if noc_cmd = "01111" then
--	        peci_busy      <= '0';
--	        sig_fin        <= '0';
--	        noc_reg_rdy    <= '0';
--	        noc_write      <= '0';
--	        noc_read       <= '0';
--	        cmd_in         <= '0';
--			delay          <= '0';
--			addr_c         <= (others => '0');
--			addr_n         <= (others => '0');
--			addr_p         <= (others => '0');
--	        noc_cmd        <= (others => '0');
--	        byte_ctr       <= (others => '1');
--	        len_ctr        <= (others => '0');
--	        pk_reg         <= (others => '0');
--	        pk_ctr         <= (others => '0');
--	        dist_reg       <= (others => '0');
--			dist_ctr       <= (others => '0');
--	    else  
--			peci_busy      <= 'Z';
--	        sig_fin        <= 'Z';
--	        noc_reg_rdy    <= 'Z';
--	        noc_write      <= 'Z';
--	        noc_read       <= 'Z';
--	        cmd_in         <= 'Z';
--	        delay          <= 'Z';
--			addr_c         <= (others => 'Z');
--			addr_n         <= (others => 'Z');
--			addr_p         <= (others => 'Z');
--	        noc_cmd        <= (others => 'Z');
--	        byte_ctr       <= (others => 'Z');
--	        len_ctr        <= (others => 'Z');
--	        pk_reg         <= (others => 'Z');
--	        pk_ctr         <= (others => 'Z');
--	        dist_reg       <= (others => 'Z');
--			dist_ctr       <= (others => 'Z');
--		end if;
--    end if;
--end process;
  
  ------------------------------------------------------------------------------
  -- NOC commnad decoding
  ------------------------------------------------------------------------------
  rst : process(noc_cmd)
  begin
		if noc_cmd = "01111" then
		  rst_i <= '0';
		else
		  rst_i <= '1';
		end if;
  end process;
  cmd_activate : process(clk_e) --39 - 33 = 6 6 must be kept
   variable tag_ctr_1 : integer;  -- Reaction time, 38 clock cycles. To be replaced within define document
  begin 
	if rising_edge(clk_e) then
		if noc_cmd = "01111" then
			sig_fin <= '0';
			peci_busy <= '0';
	    elsif noc_reg_rdy= '1' and len_ctr = "000000000000000" then --Refresh when data transfer is finished
			sig_fin <= '0';
		elsif peci_busy = '0' then
			tag_ctr_1 := 41; --40; --38;
            if tag = '1' then
                peci_busy <= '1'; 
            else
                peci_busy <= '0';
			end if;
        elsif peci_busy= '1' then
            tag_ctr_1 := tag_ctr_1-1;
			if tag_ctr_1 = 35 then --34 then --32 then --5 for collecting data to NOC command buffer, 1 for transfer form buffer to NOC command register
				sig_fin <= '1';
			elsif tag_ctr_1 = 0 then
                peci_busy <= '0';
			end if;
		end if;
	end if;
  end process;
  
--  busy_flag: process(cmd_in)
--  begin 
--    if peci_busy = '0' and cmd_in= '1' then
--	    peci_busy <= '1';
--	end if;
--  end process;
  
    tag_translate : process (peci_busy, clk_e, sig_fin)
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
			    elsif peci_busy='0' and sig_fin='0' and delay='0' and rd_trig ='0'  then
					noc_cmd_ctr := 5;
					noc_cmd <= (others => '0');
    		    else 
    			    noc_cmd_ctr := 5;
    			    --noc_cmd <= (others => '0');
    		    end if;
    	  end if;
    end process;
  
--  noc_ctrl: process(clk_e,sig_fin,noc_cmd) --moved to mem_interaction process
--  
--  variable tag_ctr_2 : integer;
--  variable tag_ctr_3 : integer;   --Both to be described in define document
--  begin
--	if rising_edge(clk_e) then
--		if noc_cmd = "01111" then
--			tag_ctr_2 := 30;
--			tag_ctr_3 := 38;
--			len_ctr <= (others => '0');
--			addr_n  <= (others => '0');
--			pk_reg  <= (others => '0');
--			dist_reg <= (others => '0'); 
--		elsif sig_fin = '1' and delay = '0' then 
--		    if noc_cmd = "00011" or noc_cmd = "00100" then
--		    	tag_ctr_2 := tag_ctr_2 - 1;
--		    	if tag_ctr_2 > 14 then
--		    		len_ctr(0) <= tag; 
--		    		for i in 0 to 13 loop
--		    			len_ctr(i+1)<= len_ctr(i);
--		    		end loop;
--		    	elsif tag_ctr_2 <= 14 and tag_ctr_2 >= 0 then
--		    		addr_n(0) <= tag;
--		    		for i in 0 to 13 loop
--		    			addr_n(i+1)<= addr_n(i);
--		    		end loop;
--		    	end if;
--		    elsif noc_cmd = "00101" then
--		    	tag_ctr_3:= tag_ctr_3-1;
--		    	if tag_ctr_3 > 22 then
--		    		len_ctr(0) <= tag; 
--		    		for i in 0 to 13 loop
--		    			len_ctr(i+1)<= len_ctr(i);
--		    		end loop;
--		    	elsif tag_ctr_3 > 7 then
--		    		addr_n(0) <= tag;
--		    		for i in 0 to 13 loop
--		    			addr_n(i+1)<= addr_n(i);
--		    		end loop;
--		    	elsif tag_ctr_3 > 3 then
--		    		pk_reg(0) <= tag;
--		    		for i in 0 to 2 loop
--		    			pk_reg(i+1)<= pk_reg(i);
--		    		end loop;
--		    	elsif tag_ctr_3 >= 0 then
--		    		dist_reg(0) <= tag;
--		    		for i in 0 to 2 loop
--		    			dist_reg(i+1)<= dist_reg(i);
--		    		end loop;
--		    	end if;
--		    end if;
--		elsif delay = '1' then
--		tag_ctr_2 := 30;
--		tag_ctr_3 := 38; 
--		len_ctr <= (others=> 'Z');
--		addr_n <= (others=> 'Z');
--		pk_reg <= (others=> 'Z');
--		dist_reg <= (others=> 'Z');
--		end if;
--
--	end if;
--  end process; 
    
    exe_and_resume: process(clk_e)
		variable idle: boolean;
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				exe_i <= '0';
				resume_i <= '0';
				idle := true;
			elsif noc_cmd = "00110" then --exe command
				exe_i<= '0';
				if idle then
					exe <= '1';
					idle := false;
				end if;
			elsif noc_cmd = "01000" then --continue command
				resume_i<= '0';
				if idle then
					resume_i<= '1';
					idle := false;
				end if;
			else
			    exe_i <= '0';
			    resume_i <= '0';
				idle := true;
			end if;
		end if;
	end process;
    EXE <= exe_i;
	RESUME <= resume_i;

  
  ------------------------------------------------------------------------------
  -- Data transfer
  ------------------------------------------------------------------------------  

	rd_act : process(clk_e)
	--variable two_cycle_delay: std_logic_vector(2 downto 0);
    begin
		if rising_edge(clk_e) then
            noc_delay <= noc_reg_rdy;
			--two_cycle_delay(0) := delay;
			one_c_delay <= delay;
			two_c_delay <= one_c_delay;
            --for i in 0 to 1 loop
			--	two_cycle_delay(i+1) := two_cycle_delay(i);
			--end loop;
		end if;
	end process; 
	rd_trig <= (one_c_delay and two_c_delay);	
	
	
	--Byte counter calculation
	    	  
	byte_ctr_cal: process (clk_e, delay)
	
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				byte_ctr <= "0000";
		    elsif noc_cmd = "00011" or noc_cmd = "00101" then
	            if delay = '1' then
                 	byte_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(byte_ctr))-1,4));
				else
					byte_ctr <= "1111"; 
                end if;
			elsif noc_cmd = "00100" then
				if delay = '1' or rd_trig = '1' then
					byte_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(byte_ctr))-1,4));
				else
					byte_ctr <= "1111"; 
				end if;
			else
				byte_ctr<= "0000";
		    end if;
		end if;
	end process;
	
	data_write : process (noc_cmd, byte_ctr, delay)
	begin
		if noc_cmd = "01111" then
			noc_data_in <=(others => (others => '0'));
		elsif delay = '1' then
          if noc_cmd = "00011" or noc_cmd ="00101" then
			--if byte_ctr_buffer = "1111" or byte_ctr = "0000" then
				noc_data_in(to_integer(unsigned(byte_ctr))) <= DATA;
			--end if;
		  --else 
		  --noc_data_in <=(others => (others => 'Z'));
		  end if;
		end if;
	end process;

	data_read : process (noc_cmd, byte_ctr, rd_trig)

    begin
	    if rd_trig = '1' then
	        DATA_OUT <= noc_data_out(to_integer(unsigned(byte_ctr)+2));
	    else
	           DATA_OUT <= (others => '0');
        end if;
	end process;
    
    memory_interaction : process (clk_e, noc_reg_rdy,delay)
	variable tag_ctr_2 : integer;
	variable tag_ctr_3 : integer;  
    begin
	if rising_edge(clk_e) then
		if noc_cmd = "01111" then
			tag_ctr_2 := 30;
			tag_ctr_3 := 38;
			len_ctr <= (others => '0');
			addr_n  <= (others => '0');
			pk_reg  <= (others => '0');
			dist_reg <= (others => '0'); 
		elsif sig_fin = '1' and delay = '0' then 
		    if noc_cmd = "00011" or noc_cmd = "00100" then
		    	tag_ctr_2 := tag_ctr_2 - 1;
		    	if tag_ctr_2 > 14 then
		    		len_ctr(0) <= tag; 
		    		for i in 0 to 13 loop
		    			len_ctr(i+1)<= len_ctr(i);
		    		end loop;
		    	elsif tag_ctr_2 <= 14 and tag_ctr_2 >= 0 then
		    		addr_n(0) <= tag;
		    		for i in 0 to 13 loop
		    			addr_n(i+1)<= addr_n(i);
		    		end loop;
		    	end if;
		    elsif noc_cmd = "00101" then
		    	tag_ctr_3:= tag_ctr_3-1;
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
	    elsif delay = '1' then
			tag_ctr_2 := 30;
			tag_ctr_3 := 38;
		    if noc_reg_rdy = '1' then
		        --if len_ctr = (len_ctr'range => '0') then
				    --noc_write <= '0';
				    --noc_read  <= '0';
                    --dist_ctr <= (others=> '0');
                    --pk_ctr <= (others => '0');
		        --Write block continous
                if noc_cmd = "00011" then
		                len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		            	addr_n <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_n))+1,15));
		            	--noc_write <= '1';
		        --Read block
		        elsif noc_cmd = "00100" then
		        		len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		        		addr_n <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_n))+1,15));
		        		--noc_read <= '1';
		        --Write block burst
		        elsif noc_cmd = "00101" then
		            if dist_ctr = (dist_ctr'range => '0') and noc_write = '0'then
		                --noc_write <= '1';
		            	pk_ctr <= pk_reg;
		            elsif pk_ctr = (pk_ctr'range => '0') then
		            	--noc_write <= '0';			
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
		    	pk_reg   <= pk_reg  ;
		    	dist_reg <= dist_reg;
		    	pk_ctr   <= pk_ctr  ;
		    	dist_ctr <= dist_ctr;
	        end if;
	    elsif delay = '0' then
	    --noc_write <='0';
        --noc_read <='0';
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
        variable cmd_tr : std_logic; --Save 1 clock to handle the request
	begin
		if rising_edge(clk_p) and even_p_int = '1' then --RD_REQ raises at falling_edge of clk_e
			if noc_cmd = "01111" then
				RD_FIFO <= '0';
                cmd_tr := '0';
            else
                if REQ_IN = '1' and req_exe = '0' and write_req = '0' and cmd_tr = '0' then
                    cmd_tr := '1';
                else
                    cmd_tr := '0';
                end if;

			    if REQ_IN = '1' and req_exe = '0' and write_req = '0' and cmd_tr = '1' then --normal case
			    	RD_FIFO <= '1';
			    elsif req_exe = '1' and write_req = '1' then --write case
			    	RD_FIFO <= '1';
			    else
			    	RD_FIFO <= '0';
			    end if;
            end if;
		end if;
	end process;

 	req_recording: process(clk_p)
 	begin
 		if rising_edge(clk_p) and even_p_int = '1' then --0628 --falling_edge of clk_e
			if noc_cmd = "01111" then
				pe_req_type <= (others => '0');
				req_addr_p <= (others => '0');
				req_len_ctr_p <= (others => '0');
				req_last <= (others => '0');
                bc_i <= '0';
			elsif FIFO_VLD = '1' and req_exe = '0' and write_req = '0' and cb_status = '0'then 
 				pe_req_type <= REQ_FIFO(31 downto 30);
 				req_addr_p <= REQ_FIFO(14 downto 0);
 				req_len_ctr_p <='0' & REQ_FIFO(23 downto 16);--additional one bits for maximum transfer case
 				req_last <= REQ_FIFO(29 downto 24);
                bc_i <= (not REQ_FIFO(31)) and REQ_FIFO(30); --Temp, to be integrated to id_num(req_last) field later for 16 PE version.
            elsif req_exe = '1' and len_ctr_p = "000000000" then
                pe_req_type <= (others => '0');
				req_addr_p <= (others => '0');
				req_len_ctr_p <= (others => '0');
				req_last <= (others => '0');
                bc_i <= '0';
 			end if;
 		end if;
 	end process;
    BC<= bc_i;
    process(clk_e) --Reset need to be added 
	begin 
		if rising_edge(clk_e) then 
			if noc_cmd = "01111" then
				req_exe <= '0';
				cb_status <= '0';
				b_cast_ctr <= (others => '0');
				write_req <= '0';
			elsif req_exe = '0' then
			    if pe_req_type = "01" then
			    	if cb_status = '0' then
			    		cb_status <= '1';
			    		b_cast_ctr <= req_last;
			    	elsif cb_status = '1' then
			    		if FIFO_VLD = '1' and b_cast_ctr /= "000000" then
			    			b_cast_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(b_cast_ctr))-1,6)); --test the last request income case
			    		elsif b_cast_ctr = "000000" then
			    			if len_ctr_p /= "000000000" then
			    				req_exe <= '1';
			    				--addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,15));       --Move to another process
			    				--len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9));  --Move to another process
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
            elsif req_exe = '1' then  --Reset
                if len_ctr_p = "000000000" then
                    req_exe <= '0';
					cb_status <= '0';
                end if;

				if write_count = "11" then
					write_req<= '0';
				end if;
            end if;
		end if;
	end process;
    PE_UNIT <= id_num;
	counting : process(clk_e)  
	begin
		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				addr_p <= (others => '0');
				len_ctr_p <= (others => '0');
				write_count <= "00";
				pe_write <= '0';
			elsif noc_reg_rdy = '0' then
			    if req_exe = '1' then
					if write_req = '0' then
					    addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,15));
					    len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9));
						pe_read <= '1'; 
					elsif write_req = '1' then
						pe_data_in(4*to_integer(unsigned(write_count))) <= REQ_FIFO(7 downto 0);
                        pe_data_in(4*to_integer(unsigned(write_count))+1) <=REQ_FIFO(15 downto 8);
                        pe_data_in(4*to_integer(unsigned(write_count))+2) <=REQ_FIFO(23 downto 16);
                        pe_data_in(4*to_integer(unsigned(write_count))+3) <=REQ_FIFO(31 downto 24);
						write_count <= std_logic_vector(to_unsigned(to_integer(unsigned(write_count))+1,2)); 
						if write_count = "11" then
							pe_write <= '1';
							len_ctr_p <= (others => '0');
						else
							pe_write <= '0';
						end if;
					end if;
				else
					addr_p <= req_addr_p;
					len_ctr_p <= req_len_ctr_p;
				end if;
			end if;
		end if;
	end process;


--distribution network
    process (clk_e)
    begin
    	if rising_edge(clk_e) then 
            if pe_read = '1' then --Data valid asserts together with output data
    	        for i in 15 downto 0 loop
    	        	DATA_TO_PE(8*i+7 downto 8*i) <= data_core_int(i);
    	        end loop;
    	        	DATA_VLD <= not noc_reg_rdy;
            else
                DATA_TO_PE <= (others=>'0');
                DATA_VLD <= '0';
            end if;
        end if;
    end process;


 --Address & trigger MUX
 process(noc_reg_rdy,addr_p)				
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
    process(noc_reg_rdy)
    begin
        if noc_reg_rdy = '1' then
            mem_in <= noc_data_in;
        else
            mem_in <= pe_data_in;
        end if;
    end process;
--Output Latch
    process(clk_e)
    begin
        if rising_edge(clk_e) then
            if noc_delay = '1' then
                noc_data_out <= data_core_int;
            end if;
        end if;
    end process;

TAG_FB <= sig_fin or delay;
---------------------------------------------
--Cluster ready indecator
---------------------------------------------
c_rdy_i <= PE_RDY_0 and PE_RDY_1 and PE_RDY_2 and PE_RDY_3 and
           PE_RDY_4 and PE_RDY_5 and PE_RDY_6 and PE_RDY_7 and
		   PE_RDY_8 and PE_RDY_9 and PE_RDY_10 and PE_RDY_11 and
		   PE_RDY_12 and PE_RDY_13 and PE_RDY_14 and PE_RDY_15;
C_RDY <= c_rdy_i;
----------------------------------------------------------------------------------	
process(noc_cmd)
begin 
if noc_cmd = "00100" then
rd_ena <= '1';
else
rd_ena <= '0';
end if;
end process;
CLK_O <= CLK_E and (delay or rd_trig) and rd_ena;	
				
	--Memory blocks
    clustermem : CMEM_32KX16
	port map (
		addr_c => addr_c, 
		CK => clk_e,
		WR => wr_i, --To be written as one write ff instead of 2 ffs
		RD => rd_i,
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

	delay_counter : delay_count
	port map (
		clk_e => clk_e,
		peci_busy => peci_busy,
		sig_fin => sig_fin,
		noc_cmd => noc_cmd,
		noc_reg_rdy => noc_reg_rdy,
		len_ctr => len_ctr,

		delay => delay

	);

	mem_control : mem_ctrl
	port map (
		clk_e => clk_e,
        byte_ctr => byte_ctr,
        delay => delay,
        noc_cmd => noc_cmd,

        noc_reg_rdy => noc_reg_rdy,
        noc_write => noc_write,
        noc_read => noc_read

	);

end architecture rtl; 

-----------------------------------------------------------
--NOTE
-----------------------------------------------------------

--CM Address Arbiter expects NOC side have higher priority then PE side. 

