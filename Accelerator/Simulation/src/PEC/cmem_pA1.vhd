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

entity cmem is
  port(
--Clock inputs
	  clk_p            : in std_logic;     --PE clocks
--Clock outputs
	  clk_o            : out std_logic;
--Tag line
	  tag              : inout std_logic;
--Data line   
	  data             : inout std_logic_vector(7 downto 0);
--PE request
	  req_core         : inout std_logic_vector(143 downto 0);  
--Feedback signals
      fb               : out std_logic
	  ); 
end entity cmem;
	   
architecture rtl of cmem is

  component CMEM_32KX16 is
    port(
	     addr_c      :  in std_logic_vector(15 downto 0);
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
		 D15         :  inout std_logic_vector(7 downto 0)
		 );
  end component;
  --Control flip-flops  --TBD
  signal act      : std_logic;  --Activation
  --signal rst_en   : std_logic;  --Reset
  signal cmc      : std_logic;  --Communication
  signal dir_n    : std_logic;  --NOC side direction
  signal exe      : std_logic;  --Execution
  signal dir_p    : std_logic;  --PE side direction
  signal peci_busy : std_logic; --Cluster interface busy 
  signal sig_fin   : std_logic; --Tag signal collected
  signal noc_reg_rdy : std_logic;  --NOC data register ready to interact with cluster memory words
  signal noc_write : std_logic;  --Write command
  signal noc_read  : std_logic;  --Read command
  signal delay     : std_logic;  --Delay flipflop
  --Control registers
  type noc_reg is array (15 downto 0) of std_logic_vector(7 downto 0);  
  signal noc_data     : noc_reg;                        --NOC data register
  signal req_core_int : std_logic_vector(143 downto 0);  --Request register from PE  
  signal addr_c       : std_logic_vector(14 downto 0);   --CMEM column address pointer
  signal noc_cmd      : std_logic_vector(5 downto 0);    --NOC command register
  --State machine
  signal byte_ctr     : std_logic_vector(3 downto 0);    --Byte counter
  signal byte_ctr_buffer : std_logic_vector (3 downto 0);  --Buffers to delay 1 clock cycle for byte counter
  signal len_ctr      : std_logic_vector(14 downto 0);   --Data block length counter
  signal pk_reg       : std_logic_vector(TBD1 downto 0);  --Data pack size register, length TBD
  signal pk_ctr       : std_logic_vector(TBD1 downto 0);
  signal dist_reg     : std_logic_vector(TBD2 downto 0);  --Data pack distance register, length TBD
  signal dist_ctr     : std_logic_vector(TBD2 downto 0);
  --Delay signal
  constant dn_c       : integer :=32  --Data delay for continous writing and reading
  constant dn_b       : integer :=32+TBD1+TBD2;  --Data delay for burst writing
  signal delay_c      : std_logic_vector(dn_c  downto 0);
  signal delay_b      : std_logic_vector(dn_b  downto 0);
  
begin
  ------------------------------------------------------------------------------
  -- Reset
  ------------------------------------------------------------------------------
  reset: process(clk_p, noc_cmd）；
  begin
  if rising_edge(clk_p) and noc_cmd = '101111' then
	  peci_busy      <= '0';
	  sig_fin        <= '0';
	  noc_reg_rdy    <= '0';
	  noc_write      <= '0';
	  noc_read       <= '0';
	  addr_c         <= (others => '0');
	  noc_cmd        <= (others => '0');
	  byte_ctr       <= (others => '0');
	  len_ctr        <= (others => '0');
	  pk_reg         <= (others => '0');
	  pk_ctr         <= (others => '0');
	  dist_reg       <= (others => '0');
	  dist_ctr       <= (others => '0');
	  
	  
  end if;
end process;
  
  ------------------------------------------------------------------------------
  -- NOC commnad decoding
  ------------------------------------------------------------------------------
  noc_translate: process(tag, clk_p)
  
  begin 
    if peci_busy = '0' then
      wait until tag = '1';
	    peci_busy <= '1';
	    for i in 0 to 5 loop
	      if rising_edge(clk_p) then
		    noc_cmd(i)<= tag;
			  if i = 5 then
			    sig_fin <= '1';
			  else 
			    sig_fin <= '0';
			  end if;
		  end if;
	    end loop;
	end if;
  end process;
  
  noc_ctrl: process(clk_p)
  
  begin
	if peci_busy = '1' and sig_fin = '1' then
	  case noc_cmd is
        when "100011" =>
          for i in 0 to 29 loop  --length counter loading
            if rising_edge(clk_p) then
			  if i<15 then
			    len_ctr(i) <= tag; 
              else			  
                addr_c(i-15) <= tag;
			  end if;
			end if;
		  end loop;
        when "100101" =>
          for i in 0 to 29+TBD1+TBD2 loop  -- length counter loading
		    if rising_edge(clk_p) then
			    if i< 15 then 
				  len_ctr(i) <= tag;
				elsif i<15+TBD1 then --data pack size counter and distance counter loading
				  pk_reg(i-15) <= tag;
				elsif i<15+TBD1+TBD2 then 
				  dist_reg(i-TBD1-15) <= tag;
				else
				  addr_c(i-TBD1-TBD2-15) <= tag;
				end if;
			end if;
		  end loop;
		when "100100" =>
			for i in 0 to 29 loop
				if rising_edge(clk_p) then
					if i<15 then 
						len_ctr(i) <= tag;
					else
						addr_c(i-15) <= tag;
					end if;
				end if;
			end loop;
	  end case;
	end if;
  end process; 
  
  ------------------------------------------------------------------------------
  -- Data transfer
  ------------------------------------------------------------------------------  
	
	delay_count: process(clk_p, peci_busy, sig_fin)
    
	begin
	  delay_c(0) <= '1';
	  delay_b(0) <= '1';
      if peci_busy = '1' and sig_fin = '1' then
	    if noc_cmd = "100011" or noc_cmd = "100100" then
		  for i in 0 to dn_c-2 loop
		    if rising_edge(clk_p) then
			  delay_c(i+1) <= delay_c(i);
			end if;
		  end loop;
		  delay <= delay_c(dn_c -1);
		elsif noc_cmd = "100101" then
		  for i in 0 to dn_b-2 loop
		    if rising_edge(clk_p) then
			  delay_b(i+1) <= delay_b(i);
			end if;
		  end loop;
		  delay <= delay_b(dn_b -1);
		else 
		  delay_c <=(others => '0');
		  delay_b <=(others => '0');
		  delay <= '0';
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

			  if byte_ctr_buffer = "1111" or byte_ctr = "0000" then
				if noc_cmd = "100011" or noc_cmd ="100101" then
				    noc_data(to_integer(unsigned(byte_ctr))) <= data;
				elsif noc_cmd = "100100" then
					data <= noc_data(to_integer(unsigned(byte_ctr)));
				end if;
			  end if;
		  end if;
	  end if;
	end process;
    
    data_write : process (clk_p, noc_reg_rdy)
    
    begin
	  if rising_edge(clk_p) and noc_reg_rdy = '1' then
		--Write block continous
        if noc_cmd = "100011" then
		  if len_ctr = (len_ctr'range => '0') then
			noc_write <= '0';
		  else
			noc_write <= '1';
		  end if;

		  if noc_write = '1' then
		    len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
            addr_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_c))+1,15));
		  end if;
		--Read block
		elsif noc_cmd = "100100" then
			if len_ctr = (len_ctr'range => '0') then
				noc_read <= '0';
			else
				noc_read <= '1';
			end if;

			if noc_read = '1' then
				len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
				addr_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_c))+1,15));
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
			dist_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(dist_ctr))-1,TBD2));
		  elsif noc_write = '1' then
		  	pk_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(pk_ctr))-1,TBD1));
		  	addr_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_c))+1,15));
			len_ctr <= std_logic_vector(to_unsigned(to_integer(unsigned(len_ctr))-1,15));
		  	dist_ctr <= dist_reg;
		  end if;
		end if;
	  end if;
	end process;
           		
	--Memory blocks
    clustermem : CMEM_32KX16
	port map (
		addr_c => addr_c,
		WR => noc_write, 
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
		D15 => noc_data(15)
        );		

end architecture rtl; 
