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
-- Title      : cmem
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : cmem.vhd
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
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--use work.defines.all;

entity cluster_controller is
  port(
--Clock inputs
	  CLK_E            : in std_logic;     --PE clocks(pll clock)
--Clock outputs
	  CLK_O            : out std_logic;    --not needed in this version
--Tag line
	  TAG              : in std_logic;
	  TAG_FB           : out std_logic;
--Data line   
	  DATA             : in std_logic_vector(7 downto 0);
	  DATA_OUT         : out std_logic_vector(7 downto 0);
--Feedback signals
      --fb               : out std_logic
--Request and distribution logic signals
      RST_R            : out std_logic;
	  REQ_IN           : in std_logic;  --req to noc in reg logic
	  REQ_FIFO          : in std_logic_vector(31 downto 0);
	  DATA_TO_PE       : out std_logic_vector(127 downto 0);
	  PE_UNIT          : out std_logic_vector(5 downto 0);
	  B_CAST           : out std_logic;
	  RD_FIFO          : out std_logic;
	  FOUR_WD_LEFT     : in std_logic 	  
	  ); 
end entity cluster_controller;
	   
architecture rtl of cluster_controller is

component CMEM_32KX16 is
   port(
	     addr_c      :  in std_logic_vector(14 downto 0);
         CK          :  in std_logic;
		 WR          :  in std_logic;
		 RD          :  in std_logic;   
		 D0          :  inout std_logic_vector(7 downto 0);
		 D1          :  inout std_logic_vector(7 downto 0);
		 D2          :  inout std_logic_vector(7 downto 0);
		 D3          :  inout std_logic_vector(7 downto 0);
		 D4          :  inout std_logic_vector(7 downto 0);
		 D5          :  inout std_logic_vector(7 downto 0);
		 D6          :  inout std_logic_vector(7 downto 0);
		 D7          :  inout std_logic_vector(7 downto 0);
		 D8          :  inout std_logic_vector(7 downto 0);
		 D9          :  inout std_logic_vector(7 downto 0);
		 D10         :  inout std_logic_vector(7 downto 0);
		 D11         :  inout std_logic_vector(7 downto 0);
		 D12         :  inout std_logic_vector(7 downto 0);
		 D13         :  inout std_logic_vector(7 downto 0);
		 D14         :  inout std_logic_vector(7 downto 0);
		 D15         :  inout std_logic_vector(7 downto 0);

		 DI0          :  inout std_logic_vector(7 downto 0);
		 DI1          :  inout std_logic_vector(7 downto 0);
		 DI2          :  inout std_logic_vector(7 downto 0);
		 DI3          :  inout std_logic_vector(7 downto 0);
		 DI4          :  inout std_logic_vector(7 downto 0);
		 DI5          :  inout std_logic_vector(7 downto 0);
		 DI6          :  inout std_logic_vector(7 downto 0);
		 DI7          :  inout std_logic_vector(7 downto 0);
		 DI8          :  inout std_logic_vector(7 downto 0);
		 DI9          :  inout std_logic_vector(7 downto 0);
		 DI10         :  inout std_logic_vector(7 downto 0);
		 DI11         :  inout std_logic_vector(7 downto 0);
		 DI12         :  inout std_logic_vector(7 downto 0);
		 DI13         :  inout std_logic_vector(7 downto 0);
		 DI14         :  inout std_logic_vector(7 downto 0);
		 DI15         :  inout std_logic_vector(7 downto 0)
 
		 );
end component;
 

  --Clock signals
  signal clk_m    : std_logic; --CM clock
  --Control flip-flops  --TBD
  signal act      : std_logic;  --Activation
  --signal rst_en   : std_logic;  --Reset
  signal cmc      : std_logic;  --Communication
  signal dir_n    : std_logic;  --NOC side direction
  signal exe      : std_logic;  --Execution
  signal dir_p    : std_logic;  --PE side direction
  signal debug    : std_logic:='0';
  signal peci_busy : std_logic:='0'; --Cluster interface busy 
  signal cmd_in    : std_logic:='0'; --command incoming ff
  signal sig_fin   : std_logic:='0'; --Tag signal collected
  signal noc_reg_rdy : std_logic:='0';  --NOC data register ready to interact with cluster memory words
  signal noc_write : std_logic:='0';  --Write command
  signal noc_read  : std_logic:='0';  --Read command
  signal delay     : std_logic:='0';  --Delay flipflop
  signal rd_trig   : std_logic;       --Read case trigger
  signal req_int   : std_logic;      --Request type ff
  signal broadcast_int : std_logic;  --Broadcast to PE
  signal r_delay   :std_logic;  --First clock delay when read.
  signal pe_req_type : std_logic_vector(1 downto 0);
  signal cb_status  : std_logic;
  signal req_exe   : std_logic;
  signal write_req : std_logic;
  --Control registers
  type reg is array (15 downto 0) of std_logic_vector(7 downto 0);  
  signal noc_data     : reg;                        --NOC data register
  --signal data_out     : reg;
  signal data_core_int : reg;                       --Data register for PE
  signal req_last     : std_logic_vector(5 downto 0);   --Request last field
  signal addr_c       : std_logic_vector(14 downto 0);   --CMEM column address pointer
  signal addr_n       : std_logic_vector(14 downto 0);   --NOC address pointer
  signal addr_p       : std_logic_vector(14 downto 0);   --PE  side address pointer
  signal noc_cmd_buf  : std_logic_vector(4 downto 0);    --NOC command buffer
  signal noc_cmd      : std_logic_vector(4 downto 0);    --NOC command control register
  signal pe_int       : std_logic_vector(1 downto 0);    --PE internal destination
  signal pe_num       : std_logic_vector(5 downto 0);    --PEs' seriel number
  signal pe_to_CM     : std_logic_vector(127 downto 0);
  signal id_num       : std_logic_vector(5 downto 0);
  --State machine
  --signal tag_ctr      : std_logic_vector(5 downto 0);  
  signal byte_ctr     : std_logic_vector(3 downto 0):="0000";    --Byte counter
  signal byte_ctr_buffer : std_logic_vector (3 downto 0);  --Buffers to delay 1 clock cycle for byte counter
  signal len_ctr      : std_logic_vector(14 downto 0);
  signal len_ctr_p    : std_logic_vector(8 downto 0);   --Data block length counter
  signal pk_reg       : std_logic_vector(3 downto 0);  --Data pack size register, length TBD or to be a constant instead
  signal pk_ctr       : std_logic_vector(3 downto 0);
  signal dist_reg     : std_logic_vector(3 downto 0);  --Data pack distance register, length TBD
  signal dist_ctr     : std_logic_vector(3 downto 0);
  signal b_cast_ctr   : std_logic_vector(5 downto 0);
  --Delay signal
  --constant dn_c       : integer :=32  --Data delay for continous writing and reading
  --constant dn_b       : integer :=32+TBD1+TBD2;  --Data delay for burst writing
  signal delay_c      : std_logic_vector(33 downto 0);--(31 downto 0);--(29  downto 0);
  signal delay_b      : std_logic_vector(37 downto 0);
  signal rd_ena       : std_logic;
  
  signal one_c_delay :std_logic;
  signal two_c_delay :std_logic;
  
 
begin
          
clk_gen : process(clk_e, noc_reg_rdy)
begin
  if rising_edge(clk_e) then
    if noc_reg_rdy = '1' then
       clk_m <= clk_e;
    else
       clk_m <= '0';
    end if;
  end if;
  end process;
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
  cmd_activate : process(clk_e) --39 - 33 = 6 6 must be kept
   variable tag_ctr_1 : integer;  -- Reaction time, 38 clock cycles. To be replaced within define document
  begin 
	if rising_edge(clk_e) then
		if noc_cmd = "01111" then
			sig_fin <= '0';
			peci_busy <= '0';
			sig_fin <= '0';
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
  
  noc_ctrl: process(clk_e,sig_fin,noc_cmd)
  
  variable tag_ctr_2 : integer:=30;
  variable tag_ctr_3 : integer:=38;   --Both to be described in define document
  begin
	if rising_edge(clk_e) then
		if noc_cmd = "01111" then
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
		len_ctr <= (others=> 'Z');
		addr_n <= (others=> 'Z');
		pk_reg <= (others=> 'Z');
		dist_reg <= (others=> 'Z');
		end if;

	end if;
  end process; 
  
  ------------------------------------------------------------------------------
  -- Data transfer
  ------------------------------------------------------------------------------  
	
	delay_count: process(clk_e, peci_busy, sig_fin)
    
	begin

		if rising_edge(clk_e) then
			if noc_cmd = "01111" then
				delay <= '0';
				delay_c <= (others => '0');
				delay_b <= (others => '0');
			elsif noc_cmd = "00011" then
			
			    if noc_reg_rdy= '1' and len_ctr = "000000000000000" then  
				    delay <= '0';
			    elsif peci_busy = '1' and sig_fin = '1' then
			    --if noc_cmd = "00011" or noc_cmd = "00100" then
			    	delay_c(0) <= '1';
		            for i in 0 to 32 loop--30 loop --28 loop
			    		delay_c(i+1) <= delay_c(i);
			    	end loop;
					delay <= delay_c(33);--(31); --(29);
				end if;
			elsif noc_cmd = "00101" then
				if noc_reg_rdy= '1' and len_ctr = "000000000000000" then  
					delay <= '0';
				elsif peci_busy = '1' and sig_fin = '1' then	
			    	delay_b(0) <= '1';
		            for i in 0 to 36 loop
			    	    delay_b(i+1) <= delay_b(i);
			    	end loop;
			    	delay <= delay_b(37);
				end if;
			elsif noc_cmd = "00100" then
				if noc_reg_rdy= '1' and len_ctr = "111111111111111" then  
					delay <= '0';
				elsif peci_busy = '1' and sig_fin = '1' then
					--if noc_cmd = "00011" or noc_cmd = "00100" then
						delay_c(0) <= '1';
						for i in 0 to 28 loop
							delay_c(i+1) <= delay_c(i);
						end loop;
						delay <= delay_c(29);
				end if;
		    else 
		        delay_c <=(others => '0');
		        delay_b <=(others => '0');
			end if;
		end if;
	end process;

	rd_act : process(clk_e)
	--variable two_cycle_delay: std_logic_vector(2 downto 0);
    begin
		if rising_edge(clk_e) then
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

	mem_activation : process(clk_e, byte_ctr, delay)
    begin
		if noc_cmd = "01111" then
			noc_reg_rdy <= '0';
        elsif delay = '1' then     
		    if noc_cmd = "00011" or noc_cmd = "00101" then
		        if byte_ctr = "0000" then 
		        	noc_reg_rdy <= '1';
		        else
		            noc_reg_rdy <= '0';
		    	end if;
		    elsif noc_cmd = "00100" then
		    	if byte_ctr = "1111" then
		    		noc_reg_rdy <= '1';
		    	else 
		    		noc_reg_rdy <= '0';
		    	end if;
		    else 
		    	noc_reg_rdy <='0';   
	        end if;
		else 
			noc_reg_rdy <='0';   
		end if;
	end process;
	
	data_write : process (noc_cmd, byte_ctr, delay)
	begin
		if noc_cmd = "01111" then
			noc_data <=(others => (others => '0'));
		elsif delay = '1' then
          if noc_cmd = "00011" or noc_cmd ="00101" then
			--if byte_ctr_buffer = "1111" or byte_ctr = "0000" then
				noc_data(to_integer(unsigned(byte_ctr))) <= DATA;
			--end if;
		  else 
		  noc_data <=(others => (others => 'Z'));
		  end if;
		end if;
	end process;

	data_read : process (noc_cmd, byte_ctr, rd_trig)

    begin
	    if rd_trig = '1' then
	        DATA_OUT <= noc_data(to_integer(unsigned(byte_ctr)+2));
	    else
	           DATA_OUT <= (others => '0');
        end if;
	end process;
    
    memory_interaction : process (clk_e, noc_reg_rdy,delay)

    begin
	if rising_edge(clk_e) then
	    if delay = '1' then
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
		            	noc_write <= '1';
		        --Read block
		        elsif noc_cmd = "00100" then
		        		len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		        		addr_n <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_n))+1,15));
		        		noc_read <= '1';
		        --Write block burst
		        elsif noc_cmd = "00101" then
		            if dist_ctr = (dist_ctr'range => '0') and noc_write = '0'then
		                noc_write <= '1';
		            	pk_ctr <= pk_reg;
		            elsif pk_ctr = (pk_ctr'range => '0') then
		            	noc_write <= '0';			
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
	    noc_write <='0';
        noc_read <='0';
		len_ctr <= (others=> 'Z');
		addr_n <= (others=> 'Z');
		pk_reg <= (others=> 'Z');
		dist_reg <= (others=> 'Z');
		pk_ctr <= (others => '0');
		dist_ctr <=(others => '0'); 
		end if;
	end if;
	end process;
	
 --	-----------------------------------------------------------------------------
 --	--PEC side 
 --	-----------------------------------------------------------------------------
 --	--Request logic reset
     req_rst : process(clk_e)
     begin
 		if rising_edge(clk_e) then
 			if noc_cmd = "01111" then
 				RST_R <= '1';
 			else
 				RST_R <= '0';
 			end if;
 		end if;
 	end process;

 --
 	req_trans: process(clk_e)
 	begin
 		--if rising_edge(clk_e) then --0519
 			if REQ_IN = '1' and req_exe = '0' and write_req = '0' then --?
 				RD_FIFO <= '1';
 				pe_req_type <= REQ_FIFO(31 downto 30);
 				addr_p <= REQ_FIFO(14 downto 0);
 				len_ctr_p <='0' & REQ_FIFO(23 downto 16);--additional one bits for maximum transfer case
 				req_last <= REQ_FIFO(29 downto 24);
 			elsif req_exe = '0' and write_req = '1' then  --Write case
 				RD_FIFO <= '0';
 			elsif req_exe = '1' and write_req = '1' then 
 				RD_FIFO <= '1';
 			else
 				RD_FIFO <= '0';
 				pe_req_type <= (others => '0');
 				addr_p <= (others => '0');
 				len_ctr_p <= (others => '0');
 				req_last <= (others => '0');
 			end if;
 		--end if;
 	end process;
    
 	trans_type : process(pe_req_type,clk_e)
    begin
		if noc_reg_rdy = '0' then
            if pe_req_type = "01" then
 			    if cb_status = '0' then
 				cb_status <= '1';
 				b_cast_ctr <= req_last;
 			    elsif cb_status = '1' then
 				if rising_edge(clk_e) then
 				    if b_cast_ctr /= "000000" then
 					    b_cast_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(b_cast_ctr))-1,6));
 					elsif b_cast_ctr = "000000" then
 						if len_ctr_p /= "111111111" then
 						req_exe <= '1';
 						addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,15));
 						len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9));
 						elsif len_ctr_p = "111111111" then
 							req_exe <= '0';
 							cb_status <= '0';
 						end if;
 					end if;
 				end if;
 			    end if;
 		elsif pe_req_type = "10" then
 			id_num <= req_last;
 			if rising_edge(clk_e) then
 				if len_ctr_p /= "111111111" then
 					req_exe <= '1';
 					addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,15));
 					len_ctr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr_p))-1,9));
 				elsif len_ctr_p = "111111111" then
 					req_exe <= '0';
 				end if;
 			end if;
 		elsif pe_req_type = "11" then
 			id_num <= req_last;
             write_req <= '1';
 			if FOUR_WD_LEFT = '0' then--Check for 4 more words signal
 				req_exe <= '1';
 				for i in 3 downto 0 loop
 				    if rising_edge(clk_e) then --will it cause any clock delay?
                         pe_to_CM(32*i+31 downto 32*i) <= REQ_FIFO;
 				    end if;
 			    end loop;
 				req_exe <= '0';
 				write_req <= '0';
 			end if;
 		end if;
	end if;
 	end process;
--distribution network
process (req_exe,addr_p)
begin
	if req_exe = '1' then
		



 --Req_logic reset
 --process(clk_e)
 --begin
 --	if rising_edge(clk_e) then
 --		if noc_cmd = "01111" then
 --			rst_r <= '1';
 --		else
 --			rst_r <= '0';
 --		end if;
 --	end if;
 --end process;


 -- Address MUX
 process(noc_reg_rdy)				
 begin
 	if noc_reg_rdy = '1' then  --to be replaced with noc_enable (CM access arbiter)
 		addr_c <= addr_n;		
 	elsif noc_reg_rdy = '0' then
 		addr_c <= addr_p;
 	end if;
 end process;

TAG_FB <= sig_fin or delay;

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
		CK => clk_m,
		WR => noc_write, --To be written as one write ff instead of 2 ffs
		RD => noc_read,
        D0 => noc_data(0),
		D1 => noc_data(1),
		D2 => noc_data(2),
		D3 => noc_data(3),
		D4 => noc_data(4),
		D5 => noc_data(5),
		D6 => noc_data(6),
		D7 => noc_data(7),
		D8 => noc_data(8),
		D9 => noc_data(9),
		D10 => noc_data(10),
		D11 => noc_data(11),
		D12 => noc_data(12),
		D13 => noc_data(13),
		D14 => noc_data(14),
		D15 => noc_data(15),

		DI0 => data_core_int(0),
		DI1 => data_core_int(1),
		DI2 => data_core_int(2),
		DI3 => data_core_int(3),
		DI4 => data_core_int(4),
		DI5 => data_core_int(5),
		DI6 => data_core_int(6),
		DI7 => data_core_int(7),
		DI8 => data_core_int(8),
		DI9 => data_core_int(9),
		DI10 => data_core_int(10),
		DI11 => data_core_int(11),
		DI12 => data_core_int(12),
		DI13 => data_core_int(13),
		DI14 => data_core_int(14),
		DI15 => data_core_int(15)
        );		

end architecture rtl; 

-----------------------------------------------------------
--NOTE
-----------------------------------------------------------

--CM Address Arbiter expects NOC side have higher priority then PE side. How to indicate process and continue commands to PEs
--since the PE is responsible for request broadcast. Acknowledge signal required.

--Feedback signal to be added. Apart from PECI-Busy. How NOC handle this feedback?

--Request FIFO issues. Size and speed.