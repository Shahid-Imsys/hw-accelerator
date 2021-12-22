------------------------------------------------------------------
--
-- Projectname	: TX FIFO (1536x8 FIFO)	
-- Filename		: TX_FIFO_01.vhd
-- Title		: TX_FIFO	
-- Author		: Erik Henkel	
-- Description	: FIFO with room for 1536 bytes made of three 
--				connected Block RAMS.
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010117	1			Intial version
-- 
--
-------------------------------------------------------------------

--The IEEE standard 1164 package, declares std_logic, rising_edge(), etc.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--simulation of Spartan2 components: (remove during syntesis)
--library unisim;
--use unisim.vcomponents.all;

--library virtex;
--use virtex.components.all;

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity TX_FIFO is
	
	port(
		--GP1000 signals
		idi		: in std_logic_vector(7 downto 0);
		idreq_tx_int	: out std_logic; --fill me up...
		idack_tx		: in std_logic; --data valid
		clk_i		: in std_logic;
		
		--control signals
		fifo_reset		: in std_logic; --reset all pointers
		clr_read	: in std_logic; --reset read pointer
			
		--status signals
		last_odd		: out std_logic; --one byte remaining
		legal		: out std_logic; --frame size legal (60 < frame size < 1514 )
		
		--DATA out
		even		: in std_logic;
		txd_data	: out std_logic_vector(7 downto 0);
		clk_tx		: in std_logic
		);
		
end entity TX_FIFO;

architecture structure of TX_FIFO is

	--Select Block RAM: 
	component RAMB4_S8_S8
		port(
			WEA		: in std_logic;
			ENA		: in std_logic;
			RSTA	: in std_logic;
			CLKA	: in std_logic;
			ADDRA	: in std_logic_vector(8 downto 0);
			DIA		: in std_logic_vector(7 downto 0);
			WEB		: in std_logic;
			ENB		: in std_logic;
			RSTB	: in std_logic;
			CLKB	: in std_logic;
			ADDRB	: in std_logic_vector(8 downto 0);
			DIB		: in std_logic_vector(7 downto 0);
			DOA		: out std_logic_vector(7 downto 0);
			DOB		: out std_logic_vector(7 downto 0)
			);
	end component;

	--Block RAM signals
	signal w_count,r_count	: std_logic_vector(10 downto 0);
	signal dummy_bus		: std_logic_vector(7 downto 0);
	signal data1,data2,data3: std_logic_vector(7 downto 0); --data out from the three different BLOCK RAMS
	signal WEB,RSTB,RSTA,ENA,ENB : std_logic;
	signal WEA_1,WEA_2,WEA_3 : std_logic;
	signal TX_CLKn : std_logic;
	
	signal read_enable	: std_logic_vector(1 downto 0);

begin
	
	RAM512: RAMB4_S8_S8
		port map(
			WEA		=> WEA_1,
			ENA		=> ENA,
			RSTA	=> RSTA,
			CLKA	=> clk_i,
			ADDRA	=> w_count(8 downto 0),
			DIA		=> idi,
			WEB		=> WEB,
			ENB		=> ENB,
			RSTB	=> RSTB,
			CLKB	=> clk_tx,
			ADDRB	=> r_count(8 downto 0),
			DIB		=> dummy_bus,
			DOA		=> open,
			DOB		=> data1
			);
	
	RAM1024: RAMB4_S8_S8
		port map(
			WEA		=> WEA_2,
			ENA		=> ENA,
			RSTA	=> RSTA,
			CLKA	=> clk_i,
			ADDRA	=> w_count(8 downto 0),
			DIA		=> idi,
			WEB		=> WEB,
			ENB		=> ENB,
			RSTB	=> RSTB,
			CLKB	=> clk_tx,
			ADDRB	=> r_count(8 downto 0),
			DIB		=> dummy_bus,
			DOA		=> open,
			DOB		=> data2
			);
	
	RAM1536: RAMB4_S8_S8
		port map(
			WEA		=> WEA_3,
			ENA		=> ENA,
			RSTA	=> RSTA,
			CLKA	=> clk_i,
			ADDRA	=> w_count(8 downto 0),
			DIA		=> idi,
			WEB		=> WEB,
			ENB		=> ENB,
			RSTB	=> RSTB,
			CLKB	=> clk_tx,
			ADDRB	=> r_count(8 downto 0),
			DIB		=> dummy_bus,
			DOA		=> open,
			DOB		=> data3
			);
	
	--port A always WRITE
	ENA 	<= '1';
	RSTA 	<= '0';
	
	--RAM512 (byte 0 - 512)
	WEA_1 <=	'1' when w_count(10 downto 9) = "00" and idack_tx = '0' else
				'0';
	
	--RAM1024 (byte 512 - 1024)
	WEA_2 <=	'1' when w_count(10 downto 9) = "01" and idack_tx = '0' else
				'0';
	
	--RAM1536 (byte 1024 - 1536)
	WEA_3 <= 	'1' when w_count(10 downto 9) = "10" and idack_tx = '0' else
				'0';
	
	--port B always READ
	ENB		<= '1';
	RSTB	<= '0';
	WEB		<= '0';
	
	with read_enable select
		txd_data <= data1 when "00", -- 0 - 512
								data2 when "01", -- 512 - 1024
								data3 when "10", -- 1024 - 1536
								(others => '0') when others;
					
	dummy_bus <= (others => '0');	

--write counter
process(clk_i,fifo_reset,idack_tx) is

begin
	if fifo_reset = '1' then
		w_count <= (others => '0');
	elsif rising_edge(clk_i) then
		if idack_tx = '0' then
			w_count <= w_count+1;
		end if;
	end if;
end process;

--read counter
TX_CLKn <= not clk_tx;

process(TX_CLKn,fifo_reset,clr_read,even) is

begin
	if fifo_reset = '1' or clr_read = '1' then
		r_count <= (others => '0');
	elsif rising_edge(TX_CLKn) then
		if even = '1' then
			r_count <= r_count+1;
		end if;
	end if;
end process;

--sync enable signals to r_count (2 MSB bits acts as enable)
process(clk_tx,fifo_reset,r_count) is

begin
	if fifo_reset = '1' then
		read_enable <= (others => '0');
	elsif rising_edge(clk_tx) then
		read_enable <= r_count(10 downto 9);
	end if;
end process;
				

--set status signals
--data request
process(clk_i,fifo_reset,w_count) is

begin
	if fifo_reset = '1' then
		idreq_tx_int <= '0'; --FIFO empty
	elsif rising_edge(clk_i) then
		if w_count(10 downto 0) = x"5FA" then
			idreq_tx_int <= '1'; --FIFO full (illegal frame SIZE)
		end if;
	end if;
end process;

--legal (frame size)
process(clk_i,w_count,fifo_reset) is

begin
	if fifo_reset = '1' then
		legal <= '0';
	elsif rising_edge(clk_i) then
		if w_count = 60 then --min SIZE
			legal <= '1';
		elsif w_count = 1515 then --over max size
			legal <= '0';
		end if;
	end if;
end process;


last_odd <= '1' when (w_count(10 downto 0)-1) = r_count(10 downto 0) else --one byte left
		'0'; 

end architecture structure;
