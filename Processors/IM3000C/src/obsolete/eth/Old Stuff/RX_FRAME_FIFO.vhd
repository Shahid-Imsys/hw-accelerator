------------------------------------------------------------------
--
-- Projectname	: RX FRAME STS FIFO	
-- Filename		: RX_FRAME_FIFO_01.vhd
-- Title		: RX_FRAME_FIFO
-- Author		: Erik Henkel	
-- Description	: RX_FRAME_FIFO stores FRAME information,
--				STS of frame and FRAME LENGHT. 16x16 frame STS
--				can be stored...
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010123	1			Intial version
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
--use work.vcomponents.all;

--library virtex;
--use virtex.components.all;

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity RX_FRAME_FIFO is
	port(
		ICLK		: in std_logic; --GP1000 CLK
		rx_sts_rd: in std_logic; --read FRAME STS
		GP_DATA		: out std_logic_vector(7 downto 0); 
		
		RX_CLK		: in std_logic;
		start_rx_logic		: in std_logic; --count incoming nibbles...
		clear_rx_logic		: in std_logic; --clear count
		
		--FRAME STS BITS
		overrun		: in std_logic; --RX FIFO overrun
		MII_ER		: in std_logic; --RX_ER asserted during reception of frame
		CRC_ER		: in std_logic; --CRC ERROR
		ALIGN_ER	: in std_logic; --alignment error
		
		STORE_STS	: in std_logic; --frame received store status!
		
		--FRAME FIFO STATUS
		odd_nibb	: out std_logic; --odd number off nibbles received...
		odd_byte	: out std_logic; --odd number off bytes received...
		full		: out std_logic;
		empty		: out std_logic;
		
		xreset		: in std_logic
		);
end entity RX_FRAME_FIFO;

architecture structure of RX_FRAME_FIFO is

	--BLOCK RAM component 
	component RAMB4_S8_S16
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
			ADDRB	: in std_logic_vector(7 downto 0);
			DIB		: in std_logic_vector(15 downto 0);
			DOA		: out std_logic_vector(7 downto 0);
			DOB		: out std_logic_vector(15 downto 0)
			);
	end component;
	
	--BLOCK RAM signals
	signal dummy_bus	: std_logic_vector(7 downto 0);
	signal WEA,WEB		: std_logic;
	signal RST,EN		: std_logic;
	signal ADDRA		: std_logic_vector(7 downto 0);
	signal ADDRB		: std_logic_vector(8 downto 0);
	
	--control signals
	signal stsf_wctr		: std_logic_vector(stsf_size-1 downto 0);
	signal stsf_rctr		: std_logic_vector(stsf_size downto 0);
	signal stsf_count		: std_logic_vector(stsf_size downto 0);
	signal stsf_dout	: std_logic_vector(7 downto 0);
	signal fifo_empty	: std_logic;
	signal rdack,wdack	: std_logic;
	signal w_mem		: std_logic;
	signal frame_sts_reg: std_logic_vector(15 downto 0);
	signal sts_data		: std_logic_vector(7 downto 0);
	signal sts_data_reg		: std_logic_vector(7 downto 0);
	signal load_reg		: std_logic;
	signal reg_full		: std_logic;
	signal nibb_count	: std_logic_vector(11 downto 0);
	signal store_sts_delay : std_logic;
	signal legal		: std_logic;
	signal one_byte		: std_logic;
	
begin

	--BLOCK RAM component
	FRAME_RAM: RAMB4_S8_S16
		port map(
			WEA		=> WEB,
			ENA		=> EN,
			RSTA	=> RST,
			CLKA	=> ICLK,
			ADDRA	=> ADDRB,
			DIA		=> dummy_bus,
			WEB		=> WEA,
			ENB		=> EN,
			RSTB	=> RST,
			CLKB	=> RX_CLK,
			ADDRB	=> ADDRA,
			DIB		=> frame_sts_reg,
			DOA		=> sts_data,
			DOB		=> open
			);


	-- Write counter and fifo write.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			stsf_wctr <= (others => '0');
		elsif rising_edge(clk_rx) then
			if store_sts = '1' then
				sts_fifo(conv_integer(stsf_wctr & '0')) <= frame_sts(15 downto 8);
				sts_fifo(conv_integer(stsf_wctr & '1')) <= frame_sts(7 downto 0);
				stsf_wctr <= stsf_wctr + 1;
			end if;
		end if;
	end process;
	frame_sts(15) <= align_er;	-- Alignment error (odd nibbles)
	frame_sts(14) <= overrun;		-- RX fifo full during receive
	frame_sts(13) <= mii_er;		-- Error signal from PHY
	frame_sts(12) <= crc_er;		-- CRC error in incoming frame
	frame_sts(11) <= not legal;	-- Illegal frame size, too small or too large
	frame_sts(10 downto 0) <= nibb_count(11 downto 1);	-- Frame length in bytes 
	
	-- Read counter and fifo read.
	process (clk_i, xreset)
	begin
		if xreset = '1' then
			stsf_rctr <= (others => '0');
		elsif rising_edge(clk_i) then
			if rx_sts_rd = '1' then
				stsf_rctr <= stsf_rctr+1;
			end if;
		end if;
	end process;
	stsf_dout <= sts_fifo(conv_integer(stsf_rctr));

	-- Level counter and fifo flags.
	process (clk_i, xreset)
	begin
		if xreset = '1' then
			stsf_count			<= (others => '0');
			stsf_wctr0_i		<= '0';
			stsf_wctr0_i2		<= '0';
		elsif rising_edge(clk_i) then
			if (stsf_count_add xor stsf_count_sub) = '1' then 
				if stsf_count_add = '1' then
					stsf_count <= stsf_count+1;
				else
					stsf_count <= stsf_count-1;
				end if;
			end if;
			stsf_wctr0_i <= stsf_wctr(0);
			stsf_wctr0_i2 <= stsf_wctr0_i;
		end if;
	end process;
	stsf_count_add <= stsf_wctr0_i xor stsf_wctr0_i2;	-- Add to counter each time frame status written (16-bit)
	stsf_count_sub <= rx_sts_rd and stsf_rctr(0);			-- Subtract from counter every 2:nd time fifo read (8-bit)
	full <= '1' when stsf_count(stsf_size) = '1' else '0';
	empty <= '1' when stsf_count = (others => '0') else '0';

	-- Nibble counter, determines size of incoming frame
	process (clk_rx, xreset, clear_rx_logic)
	begin
		if xreset = '1' or clear_rx_logic = '1' then
			nibb_count <= (others => '0');
		elsif rising_edge(clk_rx) then
			if start_rx_logic = '1' then
				nibb_count <= nibb_count + 1;
			end if;
		end if;
	end process;
	odd_nibb <= nibb_count(0);
	odd_byte <= nibb_count(1);

	-- Determine if current frame size is legal.
	process (clk_rx, xreset, clear_rx_logic)
	begin
		if xreset = '1' or clear_rx_logic = '1' then
			legal <= '0';
		elsif rising_edge(clk_rx) then
			if nibb_count(11 downto 1) = 64 then				-- Min frame size reached
				legal <= '1';
			elsif nibb_count(11 downto 1) = 1519 then		-- Max frame size exceeded
				legal <= '0';
			end if;		
		end if;
	end process;
end architecture structure;
		

