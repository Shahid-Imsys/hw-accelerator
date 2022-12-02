library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

-- gray cdc. 

entity gray_cdc is
	generic (
		WIDTH : integer := 8
	);
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		input : in unsigned(WIDTH-1 downto 0);
		output : out unsigned(WIDTH-1 downto 0)
	);
end gray_cdc;

architecture fpga_rtl of gray_cdc is

	function b2g(bin : unsigned(WIDTH-1 downto 0)) return unsigned is 
		variable tmp : unsigned(WIDTH-1 downto 0); 
	begin 
		tmp(WIDTH-1) := bin(WIDTH-1); 
		for i in WIDTH-2 downto 0 loop 
		  tmp(i) := bin(i+1) xor bin(i); 
		end loop; 
		return tmp; 
	end b2g;
	
	function g2b(gray : unsigned(WIDTH-1 downto 0)) return unsigned is 
		variable tmp : unsigned(WIDTH-1 downto 0); 
	begin 
		tmp(WIDTH-1) := gray(WIDTH-1); 
		for i in WIDTH-1-1 downto 0 loop 
			tmp(i) := tmp(i+1) xor gray(i); 
		end loop; 
		return tmp; 
	end g2b;

	signal gray_code : unsigned(WIDTH-1 downto 0);
	signal async : unsigned(WIDTH-1 downto 0) := (others => '0');

  attribute async_reg : string;
  attribute async_reg of async : signal is "true"; 

begin

	gray_code <= b2g(input);

	process (clk, reset_n) begin
			if reset_n = '0' then
				async <= (others => '0');
			elsif rising_edge(clk) then
				async <= gray_code;				
			end if;
	end process;

	output <= g2b(async);

end fpga_rtl;
