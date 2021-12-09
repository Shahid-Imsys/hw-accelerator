

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity delay_count is 
    port (
         clk_e             :   in std_logic;
         peci_busy         :   in std_logic;
         sig_fin           :   in std_logic;
         noc_cmd           :   in std_logic_vector(4 downto 0);
         noc_reg_rdy       :   in std_logic;
         len_ctr           :   in std_logic_vector(14 downto 0);

         delay             :   out std_logic

    );
end entity;

architecture rtl of delay_count is 

signal 		delay_b           :   std_logic_vector(37 downto 0);
signal      delay_c           :   std_logic_vector(33 downto 0);

begin

    process(clk_e, peci_busy, sig_fin)
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

end architecture;
