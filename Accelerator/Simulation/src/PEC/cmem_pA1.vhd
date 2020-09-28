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

entity cmem is
  port(
--Clock inputs
	  clk_p            : in std_logic;     --PE clocks
--Clock outputs
	  clk_o            : out std_logic;
--Tag line
	  tag              : in std_logic;
--Data line   
	  data             : inout std_logic_vector(7 downto 0);
--PE request
	  req_core         : inout std_logic_vector(143 downto 0);  
--Feedback signals
      fb               : out std_logic
	  ); 
end entity cmem;
	   
architecture rtl of cmem is

-- component CMEM_32KX16 is
--   port(
--	     addr_c      :  in std_logic_vector(14 downto 0);
--		 WR          :  in std_logic;
--		 RD          :  in std_logic;   
--		 D0          :  inout std_logic_vector(7 downto 0);
--		 D1          :  inout std_logic_vector(7 downto 0);
--		 D2          :  inout std_logic_vector(7 downto 0);
--		 D3          :  inout std_logic_vector(7 downto 0);
--		 D4          :  inout std_logic_vector(7 downto 0);
--		 D5          :  inout std_logic_vector(7 downto 0);
--		 D6          :  inout std_logic_vector(7 downto 0);
--		 D7          :  inout std_logic_vector(7 downto 0);
--		 D8          :  inout std_logic_vector(7 downto 0);
--		 D9          :  inout std_logic_vector(7 downto 0);
--		 D10         :  inout std_logic_vector(7 downto 0);
--		 D11         :  inout std_logic_vector(7 downto 0);
--		 D12         :  inout std_logic_vector(7 downto 0);
--		 D13         :  inout std_logic_vector(7 downto 0);
--		 D14         :  inout std_logic_vector(7 downto 0);
--		 D15         :  inout std_logic_vector(7 downto 0)
--		 );
-- end component;
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
  --Control registers
  type noc_reg is array (15 downto 0) of std_logic_vector(7 downto 0);  
  signal noc_data     : noc_reg;                        --NOC data register
  signal data_out     : noc_reg;
  signal req_core_int : std_logic_vector(143 downto 0);  --Request register from PE  
  signal addr_c       : std_logic_vector(14 downto 0);   --CMEM column address pointer
  signal noc_cmd      : std_logic_vector(5 downto 0);    --NOC command register
  --State machine
  --signal tag_ctr      : std_logic_vector(5 downto 0);  
  signal byte_ctr     : std_logic_vector(3 downto 0):="0000";    --Byte counter
  signal byte_ctr_buffer : std_logic_vector (3 downto 0);  --Buffers to delay 1 clock cycle for byte counter
  signal len_ctr      : std_logic_vector(14 downto 0);   --Data block length counter
  signal pk_reg       : std_logic_vector(3 downto 0);  --Data pack size register, length TBD or to be a constant instead
  signal pk_ctr       : std_logic_vector(3 downto 0);
  signal dist_reg     : std_logic_vector(3 downto 0);  --Data pack distance register, length TBD
  signal dist_ctr     : std_logic_vector(3 downto 0);
  --Delay signal
  --constant dn_c       : integer :=32  --Data delay for continous writing and reading
  --constant dn_b       : integer :=32+TBD1+TBD2;  --Data delay for burst writing
  signal delay_c      : std_logic_vector(28  downto 0);
  signal delay_b      : std_logic_vector(36  downto 0);
  
begin
  ------------------------------------------------------------------------------
  -- Reset
  ------------------------------------------------------------------------------
  --reset: process(noc_cmd)
  --begin
  --if rising_edge(clk_p) and noc_cmd = "101111" then
	  --peci_busy      <= '0';
	  --sig_fin        <= '0';
	  --noc_reg_rdy    <= '0';
	  --noc_write      <= '0';
	  --noc_read       <= '0';
	  --cmd_in         <= '0';
	  --delay          <= '0';
	  --addr_c         <= (others => '0');
	  --noc_cmd        <= (others => '0');
	  --byte_ctr       <= (others => '0');
	  --len_ctr        <= (others => '0');
	  --pk_reg         <= (others => '0');
	  --pk_ctr         <= (others => '0');
	  --dist_reg       <= (others => '0');
	  --dist_ctr       <= (others => '0');
	  
	  
  --end if;
--end process;
  
  ------------------------------------------------------------------------------
  -- NOC commnad decoding
  ------------------------------------------------------------------------------
  cmd_activate : process(clk_p)
   variable tag_ctr_1 : integer:= 64;  -- To be replaced within define document
  begin 
	if rising_edge(clk_p) then
		if noc_reg_rdy= '1' and len_ctr = (len_ctr'range => '0') then
			sig_fin <= '0';
        elsif peci_busy = '0' then
            if tag = '1' then
                peci_busy <= '1'; 
            else
                peci_busy <= '0';
			end if;
        elsif peci_busy= '1' then
            tag_ctr_1 := tag_ctr_1-1;
			if tag_ctr_1 = 58 then --64-6 Total loop ctr= used for command translate
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
  
  tag_translate : process (peci_busy, clk_p, sig_fin)
  begin
        if rising_edge (clk_p) and peci_busy = '1' and sig_fin = '0' then
		    noc_cmd(0)<= tag;
		    for i in 0 to 4 loop
		    noc_cmd(i+1) <= noc_cmd(i);
		    end loop;
	    end if;
  end process;
  
  noc_ctrl: process(clk_p,sig_fin,noc_cmd)
  
  variable tag_ctr_2 : integer:=30;
  variable tag_ctr_3 : integer:=38;   --Both to be described in define document
  begin
	if rising_edge(clk_p) then 
		if sig_fin = '1' and delay = '0' then --and peci_busy = '1' Bug TB fixed
		  if noc_cmd = "100011" or noc_cmd = "100100" then
		  	tag_ctr_2 := tag_ctr_2 - 1;
		  	if tag_ctr_2 > 14 then
		  		len_ctr(0) <= tag; 
		  		for i in 0 to 13 loop
		  			len_ctr(i+1)<= len_ctr(i);
		  		end loop;
		  	elsif tag_ctr_2 <= 14 and tag_ctr_2 >= 0 then
		  		addr_c(0) <= tag;
		  		for i in 0 to 13 loop
		  			addr_c(i+1)<= addr_c(i);
		  		end loop;
		  	end if;
		  elsif noc_cmd = "100101" then
		  	tag_ctr_3:= tag_ctr_3-1;
		  	if tag_ctr_3 > 22 then
		  		len_ctr(0) <= tag; 
		  		for i in 0 to 13 loop
		  			len_ctr(i+1)<= len_ctr(i);
		  		end loop;
		  	elsif tag_ctr_3 > 7 then
		  		addr_c(0) <= tag;
		  		for i in 0 to 13 loop
		  			addr_c(i+1)<= addr_c(i);
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
		len_ctr <= (others=> 'Z');
		addr_c <= (others=> 'Z');
		pk_reg <= (others=> 'Z');
		dist_reg <= (others=> 'Z');
		end if;

	end if;
  end process; 
  
  ------------------------------------------------------------------------------
  -- Data transfer
  ------------------------------------------------------------------------------  
	
	delay_count: process(clk_p, peci_busy, sig_fin)
    
	begin

		if rising_edge(clk_p)  then
			if noc_reg_rdy= '1' and len_ctr = (len_ctr'range => '0') then
				delay <= '0';
			elsif peci_busy = '1' and sig_fin = '1' then
			    if noc_cmd = "100011" or noc_cmd = "100100" then
			    	delay_c(0) <= '1';
		            for i in 0 to 27 loop
			    		delay_c(i+1) <= delay_c(i);
			    	end loop;
			    	delay <= delay_c(28);
			    elsif noc_cmd = "100101" then
			    	delay_b(0) <= '1';
		            for i in 0 to 35 loop
			    	delay_b(i+1) <= delay_b(i);
			    	end loop;
			    	delay <= delay_b(36);
			    end if;
		    else 
		        delay_c <=(others => '0');
		        delay_b <=(others => '0');
			end if;
		end if;
	end process;
	
	data_transfer : process (clk_p, delay)
	
	begin
	  if delay = '1'then
		  if rising_edge(clk_p) then
			  if byte_ctr = "1111" then -- Delay one clock cycle for writing to mem words
				byte_ctr_buffer <= (others => '0');
				byte_ctr <= byte_ctr_buffer;
				  if byte_ctr_buffer = "1111" then
					noc_reg_rdy <= '1';
				  else
					noc_reg_rdy <= '0';
				  end if; 
		      else
		        noc_reg_rdy <= '0';
				byte_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(byte_ctr))+1,4));
				byte_ctr_buffer <= (others=> '1');
			  end if;
		  end if;
	  end if;
	end process;
	
	data_write : process (noc_cmd, byte_ctr, byte_ctr_buffer,delay)
	begin
		if delay = '1' then
          if noc_cmd = "100011" or noc_cmd ="100101" then
			if byte_ctr_buffer = "1111" or byte_ctr = "0000" then
				noc_data(to_integer(unsigned(byte_ctr))) <= data;
			end if;
		  end if;
		end if;
	end process;

	data_read : process (noc_cmd, byte_ctr, byte_ctr_buffer)

    begin
	if noc_cmd = "100100" and byte_ctr_buffer = "1111" and byte_ctr = "0000" then
		data <= data_out(to_integer(unsigned(byte_ctr)));
	else
		data <= (others => 'Z');
    end if;
	end process;
    
    memory_interaction : process (clk_p, noc_reg_rdy,delay)

    begin
	if rising_edge(clk_p) then
	    if delay = '1' then
		    if noc_reg_rdy = '1' then
		    --Write block continous
                if noc_cmd = "100011" then
		            if len_ctr = (len_ctr'range => '0') then
		            	noc_write <= '0';
		            else
		                len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		            	addr_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_c))+1,15));
		            	noc_write <= '1';
		            end if;
		        --Read block
		        elsif noc_cmd = "100100" then
		        	if len_ctr = (len_ctr'range => '0') then
		        		noc_read <= '0';
		        	elsif noc_read = '1' then
		        		len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		        		addr_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_c))+1,15));
		        		noc_read <= '1';
		        	end if;
		        --Write block burst
		        elsif noc_cmd = "100101" then
		            if len_ctr = (len_ctr'range => '0') then
		                noc_write <= '0';
						dist_ctr <= (others=> '0');
		            elsif dist_ctr = (dist_ctr'range => '0') and noc_write = '0'then
		                noc_write <= '1';
		            	pk_ctr <= pk_reg;
		            elsif pk_ctr = (pk_ctr'range => '0') then
		            	noc_write <= '0';			
		            	dist_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(dist_ctr))-1,4));
		            elsif noc_write = '1' then
		              	pk_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(pk_ctr))-1,4));
		              	addr_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_c))+1,15));
		            	len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		              	dist_ctr <= dist_reg;
		            end if;
        
		        end if;
		    else
		    	len_ctr  <= len_ctr ;
		    	addr_c   <= addr_c  ;
		    	pk_reg   <= pk_reg  ;
		    	dist_reg <= dist_reg;
		    	pk_ctr   <= pk_ctr  ;
		    	dist_ctr <= dist_ctr;
	        end if;
	    elsif delay = '0' then
		len_ctr <= (others=> 'Z');
		addr_c <= (others=> 'Z');
		pk_reg <= (others=> 'Z');
		dist_reg <= (others=> 'Z');
		pk_ctr <= (others => '0');
		dist_ctr <=(others => '0'); 
		end if;
	end if;
	end process;
           		
	--Memory blocks
--    clustermem : CMEM_32KX16
--	port map (
--		addr_c => addr_c,
--		WR => noc_write, 
--		RD => noc_read,
--        D0 => noc_data(0),
--		D1 => noc_data(1),
--		D2 => noc_data(2),
--		D3 => noc_data(3),
--		D4 => noc_data(4),
--		D5 => noc_data(5),
--		D6 => noc_data(6),
--		D7 => noc_data(7),
--		D8 => noc_data(8),
--		D9 => noc_data(9),
--		D10 => noc_data(10),
--		D11 => noc_data(11),
--		D12 => noc_data(12),
--		D13 => noc_data(13),
--		D14 => noc_data(14),
--		D15 => noc_data(15)
--        );		
--
end architecture rtl; 
