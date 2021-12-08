library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mmc is
	port (
		CLK		: in		std_logic;
		CMD		: inout	std_logic; 
		DAT		: inout	std_logic);
end;          

architecture behav of mmc is
  type   byte_bundle is array (1099 downto 0) of
                        std_logic_vector(7 downto 0);

  signal command	: std_logic_vector(7 downto 0);
  signal dataout	: std_logic_vector(7 downto 0);
  signal data	: byte_bundle;
  signal dataptr	: integer;
  signal ready		: std_logic;

begin

  process
  begin
		ready <= '0';

		dataptr <= 0;
		data(0) <= x"02";	-- Nr words
		data(1) <= x"0F";	-- AddrH
		data(2) <= x"11";	-- AddrL
		data(3) <= x"11";	-- StartAddrL

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

		data(256) <= x"00";	-- Nr words
		data(257) <= x"0F";	-- AddrH
		data(258) <= x"11";	-- AddrL
		data(259) <= x"11";	-- StartAddrL

		data(512) <= x"55";	-- CRC
		data(513) <= x"54";	-- CRC
		data(514) <= x"FF";	-- 
		data(515) <= x"FE";	-- 

		data(516) <= x"01";	-- Nr words
		data(517) <= x"0F";	-- AddrH
		data(518) <= x"13";	-- AddrL
		data(519) <= x"11";	-- StartAddrL

		data(520) <= x"A0";	-- 3rd word
		data(521) <= x"04";
		data(522) <= x"00";
		data(523) <= x"04";
		data(524) <= x"40";
		data(525) <= x"00";
		data(526) <= x"3F";
		data(527) <= x"F0";
		data(528) <= x"00";
		data(529) <= x"00";

		CMD <= 'Z';
		DAT <= 'Z';

		loop		
			while CMD /= '0' loop
				wait until rising_edge(CLK);
				wait for 1 ns;
			end loop;
			
			-- Get command opcode
			command <= x"00";
			wait until falling_edge(CLK);
			wait until rising_edge(CLK);
			wait until falling_edge(CLK);
			for i in 1 to 6 loop
				wait until rising_edge(CLK);
				command(7 downto 1) <= command(6 downto 0);
				if CMD = '0' then
					command(0) <= '0';
				else
					command(0) <= '1';
				end if;
				wait until falling_edge(CLK);
			end loop;

			-- Execute command
			case command is
				when x"01" =>
					for i in 1 to 40 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					for i in 1 to 5 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= '0';
					for i in 1 to 2 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= 'Z';
					for i in 1 to 6 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= ready;
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					ready <= 'Z';
					CMD <= 'Z';
					for i in 1 to 26 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					wait until rising_edge(CLK);
					wait for 1 ns;

				when x"03" =>
					for i in 1 to 40 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					for i in 1 to 17 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= '0';
					for i in 1 to 8 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;

					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					CMD <= '1';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);

					CMD <= 'Z';
					for i in 1 to 24 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					wait until rising_edge(CLK);
					wait for 1 ns;

				when x"29" =>
					for i in 1 to 40 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					for i in 1 to 5 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= '0';
					for i in 1 to 2 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= 'Z';
					for i in 1 to 6 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					CMD <= ready;
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					ready <= 'Z';
					CMD <= 'Z';
					for i in 1 to 26 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					wait until rising_edge(CLK);
					wait for 1 ns;

				when x"0B" =>
					for i in 1 to 40 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					for i in 1 to 17 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					DAT <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					while CMD /= '0' loop
						if data(dataptr) = "XXXXXXXX" then
							dataout <= x"FF";
						else
							dataout <= data(dataptr);
						end if;
						dataptr <= dataptr + 1;
						wait for 1 ns;
						for i in 1 to 8 loop
							DAT <= dataout(7);
							dataout <= dataout(6 downto 0) & '0';
							wait until rising_edge(CLK);
							wait until falling_edge(CLK);
						end loop;
					end loop;
					wait until rising_edge(CLK);
					wait for 1 ns;

				when x"12" =>
					for i in 1 to 40 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					for i in 1 to 17 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					DAT <= '0';
					wait until rising_edge(CLK);
					wait until falling_edge(CLK);
					while CMD /= '0' loop
						if data(dataptr) = "XXXXXXXX" then
							dataout <= x"FF";
						else
							dataout <= data(dataptr);
						end if;
						dataptr <= dataptr + 1;
						wait for 1 ns;
						for i in 1 to 8 loop
							DAT <= dataout(7);
							dataout <= dataout(6 downto 0) & '0';
							wait until rising_edge(CLK);
							wait until falling_edge(CLK);
						end loop;
					end loop;
					wait until rising_edge(CLK);
					wait for 1 ns;

				when others =>   							
					for i in 1 to 40 loop
						wait until rising_edge(CLK);
						wait until falling_edge(CLK);
					end loop;
					wait until rising_edge(CLK);
					wait for 1 ns;
			end case;

		end loop;

	end process;

end;
