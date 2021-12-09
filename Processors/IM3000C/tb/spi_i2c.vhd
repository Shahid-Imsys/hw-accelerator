library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi_i2c is
	port (
		mode			: in		std_logic_vector(7 downto 0);
		sck_scl		: inout	std_logic; 
		mosi_sda	: inout	std_logic; 
		miso			: inout	std_logic);
end;          

architecture behav of spi_i2c is
  constant t1 : time := 100 ns;	-- SPI: 1st clock phase time
  constant t2 : time := 100 ns;	-- SPI: 2nd clock phase time
  constant t3 : time := 5 us;		-- SPI: Time before first clock of a byte
  constant t4 : time := 1 us;		-- SPI: Time after last clock of a byte
  constant t5 : time := 2 us;		-- I2C: Time for slave to hold SCL low
  constant t6 : time := 10 ns;	-- I2C: Data setup/hold

  type byte_bundle is array (4 downto 0) of std_logic_vector(7 downto 0);

--  signal sck_scl_int	: std_logic;
--  signal mosi_sda_int	: std_logic;
--  signal miso_int			: std_logic;
  signal data_out			: byte_bundle;
  signal data_in			: byte_bundle;

begin
	data_out(0) <= x"12";
	data_out(1) <= x"34";
	data_out(2) <= x"56";
	data_out(3) <= x"78";
	data_out(4) <= x"9A";

	process	
		variable shreg		: std_logic_vector(7 downto 0);
		variable shreg_0	: std_logic;
	begin
		sck_scl		<= 'Z';
		mosi_sda	<= 'Z';
		miso			<= 'Z';

		loop
			wait until mode(7) = '1';
			-- Active
			if mode(6) = '0' then
				-- SPI ==================================================================================================
				if mode(5) = '0' then
					-- Master ===========================================================
					sck_scl		<= mode(1);					-- Set initial (idle) clock state
					mosi_sda	<= '0';							-- Output dummy bit on MOSI line
					miso			<= 'Z';							-- Make MISO an input
					for i in 0 to 4 loop
						-- Byte loop
						shreg := data_out(i);				-- Get new output byte to shift register
		        wait for t3;
						for j in 0 to 7 loop
							-- Bit loop
							if mode(0) = '0' then
								-- CPHA = 0
								mosi_sda <= shreg(7);		-- Output bit on MOSI line
				        wait for t1;
								sck_scl <= not sck_scl;	-- Toggle clock
								shreg := shreg(6 downto 0) & miso;	-- Input bit from MISO line
				        wait for t2;
							else
								-- CPHA = 1
				        wait for t1;
								mosi_sda <= shreg(7);		-- Output bit on MOSI line
								sck_scl <= not sck_scl;	-- Toggle clock
				        wait for t2;
								shreg := shreg(6 downto 0) & miso;	-- Input bit from MISO line
							end if;
							sck_scl <= not sck_scl;		-- Toggle clock
						end loop;
		        wait for t4;
						data_in(i) <= shreg;				-- Unload new input byte from shift register
					end loop;
					sck_scl		<= 'Z';
					mosi_sda	<= 'Z';
				else
					-- Slave ============================================================
					sck_scl		<= 'Z';							-- Make SCK an input
					mosi_sda	<= 'Z';							-- Make MOSI an input
					miso			<= '0';							-- Output dummy bit on MISO line
					for i in 0 to 4 loop
						-- Byte loop
						shreg := data_out(i);				-- Get new output byte to shift register
						for j in 0 to 7 loop
							-- Bit loop
							if mode(0) = '0' then
								-- CPHA = 0
								miso <= shreg(7);				-- Output bit on MISO line
								wait until sck_scl /= mode(1);					-- Wait for clock toggle
								shreg := shreg(6 downto 0) & mosi_sda;	-- Input bit from MOSI line
								wait until sck_scl = mode(1);						-- Wait for clock toggle
							else
								-- CPHA = 1
								wait until sck_scl /= mode(1);					-- Wait for clock toggle
								miso <= shreg(7);				-- Output bit on MISO line
								wait until sck_scl = mode(1);						-- Wait for clock toggle
								shreg := shreg(6 downto 0) & mosi_sda;	-- Input bit from MOSI line
							end if;
						end loop;
						data_in(i) <= shreg;				-- Unload new input byte from shift register
					end loop;
		      wait for t4;
					miso	<= 'Z';
				end if;
			else
				-- I2C ==================================================================================================
				if mode(5) = '0' then
					-- Master ===========================================================
					sck_scl		<= mode(1);					-- Set initial (idle) clock state
					mosi_sda	<= '0';							-- Output dummy bit on MOSI line
					miso			<= 'Z';							-- Make MISO an input
					for i in 0 to 4 loop
						-- Byte loop
						shreg := data_out(i);				-- Get new output byte to shift register
		        wait for t3;
						for j in 0 to 7 loop
							-- Bit loop
							if mode(0) = '0' then
								-- CPHA = 0
								mosi_sda <= shreg(7);		-- Output bit on MOSI line
				        wait for t1;
								sck_scl <= not sck_scl;	-- Toggle clock
								shreg := shreg(6 downto 0) & miso;	-- Input bit from MISO line
				        wait for t2;
							else
								-- CPHA = 1
				        wait for t1;
								mosi_sda <= shreg(7);		-- Output bit on MOSI line
								sck_scl <= not sck_scl;	-- Toggle clock
				        wait for t2;
								shreg := shreg(6 downto 0) & miso;	-- Input bit from MISO line
							end if;
							sck_scl <= not sck_scl;		-- Toggle clock
						end loop;
		        wait for t4;
						data_in(i) <= shreg;				-- Unload new input byte from shift register
					end loop;
					sck_scl		<= 'Z';
					mosi_sda	<= 'Z';
				else
					-- Slave ============================================================
					if mode(4) = '0' then
						-- Receive
						sck_scl		<= 'H';								-- Release SCL
						mosi_sda	<= 'H';								-- Release SDA
						wait until mosi_sda = '0';			-- Wait start condition
						wait until sck_scl = '0';
						for i in 0 to 4 loop
							-- Byte loop
							for j in 0 to 8 loop					-- Nine bits including ACK
								-- Bit loop
								if mode(0) = '1' then
									-- Not full speed capable
									sck_scl		<= '0';					-- Pull SCL
									wait for t5;
								end if;
								if (j < 8 or i = 4) then		-- Output ACK on SDA line
									mosi_sda	<= 'H';
								else
									mosi_sda	<= '0';
								end if;
								wait for t6;
								sck_scl		<= 'H';						-- Release SCL
								wait until sck_scl /= '0';	-- Wait for clock toggle
								shreg := shreg(6 downto 0) & shreg_0;
								shreg_0 := mosi_sda;
								wait until sck_scl = '0';		-- Wait for clock toggle
								wait for t6;
								mosi_sda	<= 'H';						-- Release SDA
							end loop;
							data_in(i) <= shreg;					-- Unload new input byte from shift register
						end loop;
					else
						-- Transmit
						sck_scl		<= 'H';								-- Release SCL
						mosi_sda	<= 'H';								-- Release SDA
						wait until mosi_sda = '0';			-- Wait start condition
						wait until sck_scl = '0';
						for i in 0 to 4 loop
							-- Byte loop
							shreg := data_out(i);					-- Get new output byte to shift register
							for j in 0 to 8 loop					-- Nine bits including ACK
								-- Bit loop
								if mode(0) = '1' then
									-- Not full speed capable
									sck_scl		<= '0';					-- Pull SCL
									wait for t5;
								end if;
								if shreg(7) = '1' then			-- Output bit on SDA line
									mosi_sda	<= 'H';
								else
									mosi_sda	<= '0';
								end if;
								wait for t6;
								sck_scl		<= 'H';						-- Release SCL
								wait until sck_scl /= '0';	-- Wait for clock toggle
								wait until sck_scl = '0';		-- Wait for clock toggle
								shreg := shreg(6 downto 0) & '1';
								wait for t6;
							end loop;
						end loop;
					end if;
				end if;
			end if;
		end loop;
	end process;
	
--	sck_scl		<= sck_scl_int;
--	mosi_sda	<= mosi_sda_int;
--	miso 			<= miso_int;

end;
