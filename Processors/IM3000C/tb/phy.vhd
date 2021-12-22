library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity phy is
	port (
		mode				: in	std_logic_vector(1 downto 0);
		speed				: in	std_logic;
		PF0_ETXEN		: in	std_logic; 
		PF1_ETXCLK	: out	std_logic; 
		PF2_ETXD0		: in	std_logic; 
		PF3_ETXD1		: in	std_logic; 
		PF4_ERXDV		: out	std_logic; 
		PF5_ERXER		: out	std_logic; 
		PF6_ERXD0		: out	std_logic; 
		PF7_ERXD1		: out	std_logic; 
		PG0_ETXER		: in	std_logic; 
		PG1_ERXCLK	: out	std_logic; 
		PG2_ETXD2		: in	std_logic; 
		PG3_ETXD3		: in	std_logic; 
		PG4_ECOL		: out	std_logic; 
		PG5_ECRS		: out	std_logic; 
		PG6_ERXD2		: out	std_logic; 
		PG7_ERXD3		: out	std_logic);
end;          

architecture behav of phy is
  type   byte_bundle is array (101 downto 0) of
                        std_logic_vector(7 downto 0);

  signal txclk	: std_logic:= '1';
  signal rxd		: std_logic_vector(3 downto 0);
  signal col  	: std_logic;
  signal rxdv2	: std_logic;
  signal rxd2		: std_logic_vector(1 downto 0);
  signal rxdata	: byte_bundle;

begin
	PF5_ERXER <= '0';
	
	process
	begin
		if mode(1) = '0' then
			if speed = '0' then
				-- 2.5 MHz clock when MII 10Mbps
				wait for 200 ns;
				txclk <= not txclk;
				wait for 200 ns;
				txclk <= not txclk;
			else
				-- 25 MHz clock when MII 100Mbps
				wait for 20 ns;
				txclk <= not txclk;
				wait for 20 ns;
				txclk <= not txclk;
			end if;
		else
			-- 50 MHz clock when RMII
			wait for 10 ns;
			txclk <= not txclk;
			wait for 10 ns;
			txclk <= not txclk;
		end if;
	end process;

	PF1_ETXCLK <= txclk;
	PG1_ERXCLK <= txclk;

	process
	begin
		for i in 0 to 97 loop
			rxdata(i) <= x"00" + i;
		end loop;
		rxdata(98) <= x"AC";
		rxdata(99) <= x"42";
		rxdata(100) <= x"94";
		rxdata(101) <= x"CA";

		col <= '0';
		rxd <= x"0";
  	PG5_ECRS <= '0';
		PF4_ERXDV <= '0';
		wait until mode /= "ZZ";
		wait for 300 ns;
--	wait for 300 us;

		if mode = "01" then
			loop
				for i in 0 to 1200 loop
--				for i in 0 to 95 loop
					wait until rising_edge(txclk);
				end loop; 
				PG5_ECRS <= '1';
				PF4_ERXDV <= '1';
				if PF0_ETXEN = '1' then
					col <= '1';
				end if;
				for i in 0 to 14 loop
					wait for 2 ns;
					rxd <= x"5";
					wait until rising_edge(txclk);
					if PF0_ETXEN = '1' then
						col <= '1';
					end if;
				end loop; 
				wait for 2 ns;
				rxd <= x"D";
				wait until rising_edge(txclk);
				if PF0_ETXEN = '1' then
					col <= '1';
				end if;
				for i in 0 to 101 loop
					wait for 2 ns;
					rxd <= rxdata(i)(3 downto 0);
					wait until rising_edge(txclk);
					if PF0_ETXEN = '1' then
						col <= '1';
					end if;
					wait for 2 ns;
					rxd <= rxdata(i)(7 downto 4);
					wait until rising_edge(txclk);
					if PF0_ETXEN = '1' then
						col <= '1';
					end if;
				end loop; 
				wait for 2 ns;
				rxd <= x"0";
				PG5_ECRS <= '0';
				PF4_ERXDV <= '0';
				col <= '0';
			end loop; 
		elsif mode(1) = '1' then
			wait for 5000 ns;
			wait until rising_edge(txclk);
			loop
				wait for 2 ns;
				PF4_ERXDV <= '1';
				rxd(1 downto 0) <= "00";
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				for i in 0 to 30 loop
					wait for 2 ns;
					rxd(1 downto 0) <= "01";
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
				end loop; 
				wait for 2 ns;
				rxd(1 downto 0) <= "11";
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				for i in 0 to 101 loop
					wait for 2 ns;
					rxd(1 downto 0) <= rxdata(i)(1 downto 0);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
					wait for 2 ns;
					rxd(1 downto 0) <= rxdata(i)(3 downto 2);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
					wait for 2 ns;
					rxd(1 downto 0) <= rxdata(i)(5 downto 4);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
					wait for 2 ns;
					rxd(1 downto 0) <= rxdata(i)(7 downto 6);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
				end loop; 
				wait for 2 ns;
				rxd(1 downto 0) <= "00";
				PF4_ERXDV <= '0';
				for k in 0 to 1 loop
					for j in 0 to 6 loop
						wait until rising_edge(txclk);
						if speed = '0' then
							for i in 0 to 8 loop
								wait until rising_edge(txclk);
							end loop;
						end if;
					end loop;
				end loop;
			end loop; 
		end if; 
	end process;

	process
	begin
		rxdv2 <= '0';
		rxd2 <= "00";

		wait until mode /= "ZZ";
		wait for 50 us;
--	wait for 350 us;
		if mode = "11" then
			wait for 500 ns;
			wait until rising_edge(txclk);
			loop
				wait for 2 ns;
				rxdv2 <= '1';
				rxd2 <= "00";
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				for i in 0 to 30 loop
					wait for 2 ns;
					rxd2 <= "01";
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
				end loop; 
				wait for 2 ns;
				rxd2 <= "11";
				wait until rising_edge(txclk);
				if speed = '0' then
					for i in 0 to 8 loop
						wait until rising_edge(txclk);
					end loop;
				end if;
				for i in 0 to 101 loop
					wait for 2 ns;
					rxd2 <= rxdata(i)(1 downto 0);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
					wait for 2 ns;
					rxd2 <= rxdata(i)(3 downto 2);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
					wait for 2 ns;
					rxd2 <= rxdata(i)(5 downto 4);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
					wait for 2 ns;
					rxd2 <= rxdata(i)(7 downto 6);
					wait until rising_edge(txclk);
					if speed = '0' then
						for i in 0 to 8 loop
							wait until rising_edge(txclk);
						end loop;
					end if;
				end loop; 
				wait for 2 ns;
				rxd2 <= "00";
				rxdv2 <= '0';
				for k in 0 to 1 loop
					for j in 0 to 6 loop
						wait until rising_edge(txclk);
						if speed = '0' then
							for i in 0 to 8 loop
								wait until rising_edge(txclk);
							end loop;
						end if;
					end loop;
				end loop;
			end loop; 
		end if; 
	end process;

	PF6_ERXD0 <= rxd(0);
	PF7_ERXD1 <= rxd(1);
	PG6_ERXD2 <= rxd(2) when mode /= "11" else rxd2(0);
	PG7_ERXD3 <= rxd(3) when mode /= "11" else rxd2(1);
	PG4_ECOL	<= col when mode(1) = '0' else rxdv2;
	
end;
