library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity eprom is
	port (
		CE		: in	std_logic;
		IO		: out	std_logic_vector(7 downto 0); 
		A			: in	std_logic_vector(15 downto 0));
end;          

architecture behav of eprom is
  type   byte_bundle is array (999 downto 0) of
                        std_logic_vector(7 downto 0);

  signal addr	: std_logic_vector(15 downto 0);
  signal data	: byte_bundle;

begin
	data(0) <= x"05";	-- Access time
	data(1) <= x"02";	-- Nr words
	data(2) <= x"0F";	-- AddrH
	data(3) <= x"11";	-- AddrL

	data(4) <= x"88";	-- 1st word
	data(5) <= x"04";
	data(6) <= x"00";
	data(7) <= x"00";
	data(8) <= x"00";
	data(9) <= x"00";
	data(10) <= x"3F";
	data(11) <= x"F0";
	data(12) <= x"00";
	data(13) <= x"00";

	data(14) <= x"88";	-- 2nd word
	data(15) <= x"04";
	data(16) <= x"00";
	data(17) <= x"00";
	data(18) <= x"00";
	data(19) <= x"00";
	data(20) <= x"3F";
	data(21) <= x"F0";
	data(22) <= x"00";
	data(23) <= x"00";

	data(254) <= x"02";	-- Block tail
	data(255) <= x"00";

	data(512) <= x"FF"; 
	data(513) <= x"01";	-- Nr words
	data(514) <= x"0F";	-- AddrH
	data(515) <= x"13";	-- AddrL

	data(516) <= x"A0";	-- 3rd word
	data(517) <= x"04";
	data(518) <= x"00";
	data(519) <= x"04";
	data(520) <= x"40";
	data(521) <= x"00";
	data(522) <= x"3F";
	data(523) <= x"F0";
	data(524) <= x"00";
	data(525) <= x"00";

	data(766) <= x"00";	-- Block tail
	data(767) <= x"11";	-- StartAddrL

	addr <= A after 70 ns;
	
	IO <= "ZZZZZZZZ" when CE = '1' else
				data(conv_integer(addr));				
end;
