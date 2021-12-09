library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity flash is
	port (
		mode	: in	std_logic;
		CS		: in	std_logic;
		SCK		: in	std_logic; 
		SO		: out	std_logic; 
		SI		: in	std_logic);
end;          

architecture behav of flash is
  type   byte_bundle is array (299 downto 0) of
                        std_logic_vector(7 downto 0);

  signal command	: std_logic_vector(7 downto 0);
  signal dataout	: std_logic_vector(7 downto 0);
  signal data	: byte_bundle;
  signal dataptr	: integer;

begin

  process
  begin
		dataptr <= 0;
		data(0) <= x"FF";
		data(1) <= x"FF";
		data(2) <= x"02";	-- Access time
		data(3) <= x"03";	-- Nr words
		data(4) <= x"0F";	-- AddrH
		data(5) <= x"11";	-- AddrL
		data(6) <= x"11";	-- StartAddrL

		data(7) <= x"88";	-- 1st word
		data(8) <= x"04";
		data(9) <= x"00";
		data(10) <= x"00";
		data(11) <= x"00";
		data(12) <= x"00";
		data(13) <= x"3F";
		data(14) <= x"F0";
		data(15) <= x"00";
		data(16) <= x"00";

		data(17) <= x"88";	-- 2nd word
		data(18) <= x"04";
		data(19) <= x"00";
		data(20) <= x"00";
		data(21) <= x"00";
		data(22) <= x"00";
		data(23) <= x"3F";
		data(24) <= x"F0";
		data(25) <= x"00";
		data(26) <= x"00";

		data(27) <= x"A0";	-- 3rd word
		data(28) <= x"04";
		data(29) <= x"00";
		data(30) <= x"04";
		data(31) <= x"40";
		data(32) <= x"00";
		data(33) <= x"3F";
		data(34) <= x"F0";
		data(35) <= x"00";
		data(36) <= x"00";

		SO <= 'Z';

		loop		
			-- Wait until chip select is active
			wait until CS = '0';
	
			-- Get command opcode
			command <= x"00";
			for i in 1 to 8 loop
				wait until rising_edge(SCK);
				command <= command(6 downto 0) & SI;
				wait until falling_edge(SCK);
			end loop;

			if mode = '1' then
				command(7) <= not command(7);
				wait for 1 ns;
			end if;
	
			-- Execute command
			case command is
				when x"52" =>
					for i in 9 to 63 loop
						wait until rising_edge(SCK);
						wait until falling_edge(SCK);
					end loop;

					if mode = '0' then
						wait until rising_edge(SCK);
						wait until falling_edge(SCK);
					end if;
	
					wait until rising_edge(SCK) or rising_edge(CS);
					while rising_edge(SCK) loop
						dataout <= data(dataptr);
						dataptr <= dataptr + 1;
						for i in 1 to 8 loop
							wait until falling_edge(SCK);
							SO <= 'X';
							wait for 20 ns;
							SO <= dataout(7);
							dataout <= dataout(6 downto 0) & '0';
						end loop;
						wait until rising_edge(SCK) or rising_edge(CS);
					end loop;
	
					wait for 18 ns;
					SO <= 'Z';

				when others =>   							
					wait until rising_edge(CS);
			end case;

		end loop;

	end process;

end;
