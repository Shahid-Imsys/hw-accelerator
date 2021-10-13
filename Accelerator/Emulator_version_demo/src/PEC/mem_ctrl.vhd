

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity mem_ctrl is 
    port(
        clk_e           : in std_logic;
        byte_ctr        : in std_logic_vector(3 downto 0);
        delay           : in std_logic;
        noc_cmd         : in std_logic_vector(4 downto 0);

        noc_reg_rdy     : out std_logic;
        noc_write       : out std_logic;
        noc_read        : out std_logic
        
        
        );
end entity;

architecture rtl of mem_ctrl is

begin

    process(clk_e, byte_ctr, delay)
    begin
		if noc_cmd = "01111" then
			noc_reg_rdy <= '0';
            noc_write <= '0';
            noc_read <= '0';
        elsif delay = '1' then     
		    if noc_cmd = "00011" or noc_cmd = "00101" then
		        if byte_ctr = "0000" then 
		        	noc_reg_rdy <= '1';
                    noc_write <= '1';
		        else
		            noc_reg_rdy <= '0';
                    noc_write <= '0';
		    	end if;
		    elsif noc_cmd = "00100" then
		    	if byte_ctr = "1111" then
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
		else 
			noc_reg_rdy <='0'; 
            noc_write <= '0';
            noc_read <= '0';  
		end if;
	end process;
	
    
end architecture;