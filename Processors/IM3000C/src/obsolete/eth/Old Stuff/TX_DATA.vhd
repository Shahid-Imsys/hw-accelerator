------------------------------------------------------------------
--
-- Projectname	: TX DATA	
-- Filename		: TX_DATA_01.vhd
-- Title		: TX DATA
-- Author		: Erik Henkel	
-- Description	: Handles the data transmission to the PHY,
--				Includes a frame FIFO and a transmission state machine.
--				Also generates the CRC32 which is added to the frame  
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

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity tx_data is
	port(
		--GP1000 signals
		idi		: in std_logic_vector(7 downto 0);
		idreq_tx_int		: out std_logic;
		idack_tx		: in std_logic;
		clk_i			: in std_logic; --GP1000 CLK
		
		--control signals
		tx_reset			: in std_logic; --reset all
		valid_col	: in std_logic; --collision indicated from PHY
		valid_crs	: in std_logic; --carrier sense indicated from PHY
		odd 			: in std_logic; --decide if an odd or even frame should be transmitted
		go_tx			: in std_logic;
		
		--GPT signals
		gpt_clr		: out std_logic;
		gpt_7		: in std_logic;
		gpt_15		: in std_logic;
		
		--status signals
		tx_done		: out std_logic;
		legal		: out std_logic;
		
		--PHY control signals
		txer		: out std_logic; --transmit error
		txen		: out std_logic; --request line!
		
		--data out
		txd			: out std_logic_vector(3 downto 0);
		clk_tx		: in std_logic --transmission CLK
		);

end entity tx_data;

architecture structure of tx_data is

	--FIFO
	component TX_FIFO
		port(
		--GP1000 signals
		idi		: in std_logic_vector(7 downto 0);
		DATA_REQ	: out std_logic; --fill me up...
		idack_tx		: in std_logic; --data valid
		clk_i		: in std_logic;
		
		--control signals
		reset		: in std_logic; --reset all pointers
		reset_read	: in std_logic; --reset read pointer
			
		--status signals
		last		: out std_logic; --one byte remaining
		legal		: out std_logic; --frame size legal (60 < frame size < 1514 )
		
		--DATA out
		read		: in std_logic;
		TXD_DATA	: out std_logic_vector(7 downto 0);
		clk_tx		: in std_logic
		);
	end component TX_FIFO;
	
	--FIFO signals
	signal txd_data	: std_logic_vector(7 downto 0);
	signal clr_read : std_logic;
	signal clr_fifo	: std_logic;
	signal fifo_reset : std_logic;
	signal last_odd		: std_logic;
	signal last_even		: std_logic;
	

	--state machine
	type tx_state_type is (IDLE,PREAMBLE,DATA,CRC,JAM,IFG,BUSY);
	signal tx_state : tx_state_type;
	
	signal even	: std_logic;
	signal preamble5,preamble8 : std_logic;
	
	--CRC32
	component TXCRC
		port (
		CLK        : in  std_logic;
    	CRC_GEN    : in  std_logic;
    	PREAMBLE_8 : in  std_logic;
    	PREAMBLE_5 : in  std_logic;
    	D          : in  std_logic_vector(3 downto 0);
    	crc_out     : out std_logic_vector(31 downto 28));
	end component TXCRC;
	
	--CRC32 signals	
	signal crc_gen	: std_logic;
	signal crc_data		: std_logic_vector(3 downto 0);
	signal crc_out	: std_logic_vector(31 downto 28);

  signal txc : std_logic_vector(31 downto 0) := (others => '1'); -- 32 bits CRC                                                               -- registers 
  signal txx : std_logic_vector(3 downto 0);
  signal xd012, xd123, xd013, xd023 : std_logic;
	
begin

----------------------------------------------------------------
-- TX control.
----------------------------------------------------------------
	process (clk_tx, tx_reset)
	begin
		if tx_reset = '1' then
			tx_state <= IDLE;
		elsif rising_edge(clk_tx) then
			case tx_state is
				----------------------------------------------------------
				when IDLE =>			-- Nothing to do, wait for something to happen
					if valid_crs = '1' then
						tx_state <= BUSY;			-- Incoming frame in half duplex, can't transmit
					elsif go_tx = '1' then
						tx_state <= PREAMBLE;	-- GO bit set, start sending frame
					end if;
				----------------------------------------------------------
				when PREAMBLE =>	-- Transmit 16 nibbles of preamble
					if gpt_15 = '1' then
						tx_state <= DATA;			-- 16 nibbles sent, start transmission of data
					end if;
				----------------------------------------------------------
				when DATA =>			-- Transmit the data (even or odd frame)
					if valid_col = '1' then 
						tx_state <= JAM;			-- Collision in half duplex, go transmit jam sequence
					elsif even = '1' and ((last_odd = '1' and odd = '1') or
																(last_even = '1' and odd = '0')) then
						tx_state <= CRC;
					end if;
				----------------------------------------------------------
				when CRC =>				-- Transmit the 4 bytes of CRC
					if valid_col = '1' then 
						tx_state <= JAM;			-- Collision in half duplex, go transmit jam sequence
					elsif gpt_7 = '1' then
						tx_state <= BUSY;
					end if;		
				----------------------------------------------------------
				when JAM =>				-- Transmit jam sequence
					if gpt_7 = '1' then
						tx_state <= BUSY;
					end if;	
				----------------------------------------------------------	
				when IFG =>				-- Wait for interframe gap
					if gpt_7 = '1' then
						tx_state <= IDLE;
					end if;	
				----------------------------------------------------------		
				when BUSY =>			-- Wait for incoming frame to pass
					if valid_crs = '0' and gpt_15 = '1' then
						tx_state <= IFG;
					end if;	
				----------------------------------------------------------		
				when others =>
					tx_state <= IDLE;
			end case;		
		end if;
	end process;

	-- Signals decoded from tx_state
	process (tx_state, valid_col, gpt_7, valid_crs)
	begin
		tx_done <= '0';
		gpt_clr <= '1';
		clr_fifo <= '0';		
		clr_read <= '0';
		txen <= '0';
		txer <= '0';
		Preamble5 <= '0';
		Preamble8 <= '0';
		crc_gen <= '0';
		case tx_state is
				when PREAMBLE =>
					gpt_clr <= '0';
					txen <= '1';
					Preamble5 <= '1';			-- 16 nibbles
					Preamble8 <= gpt_15;	-- last nibble
				when DATA =>
					txen <= '1';
					crc_gen <= '1';
				when CRC =>
					gpt_clr <= '0';
					if valid_col = '1' or gpt_7 = '1' then
						gpt_clr <= '1';
					end if;
					if valid_col = '0' and gpt_7 = '1' then
						tx_done <= '1';
						clr_fifo <= '1';		
					end if;
					txen <= '1';
				when JAM =>
					gpt_clr <= '0';
					if gpt_7 = '1' then
						gpt_clr <= '1';
						tx_done <= '1';
						clr_read <= '1'; --clear read pointer for fifo
					end if;
					txen <= '1';
--				txer <= '1';
				when IFG =>
					gpt_clr <= '0';
				when BUSY =>
					gpt_clr <= '0';
					if valid_crs = '1' then
						gpt_clr <= '1';
					end if;
				when others =>
		end case;		
	end process;

	crc_gen <= '1' when tx_state = DATA else '0';
	fifo_reset <= tx_reset or clr_fifo;
	--data in to CRC32
	crc_data <= txd_data(3 downto 0) when even = '0' else txd_data(7 downto 4); --data from FIFO to CRC32
	--data to PHY
	--txd <= 	crc_data when crc_gen = '1' else
	txd <= 	crc_data when tx_state = DATA or tx_state = JAM else
			crc_out(28) & crc_out(29) & crc_out(30) & crc_out(31); --shift the order of the bits...so that they are correct...

	-- even signal (first nibble in the byte)
	process (clk_tx, tx_state)
	begin
		if tx_state /= DATA then
			even <= '0';
		elsif rising_edge(clk_tx) then
			even <= not even;
		end if;
	end process;
	
	-- last_even signal (last_odd delayed one clock)
	process (clk_tx, tx_reset)
	begin
		if tx_reset = '1' then
			last_even <= '0';
		elsif rising_edge(clk_tx) then
			last_even <= last_odd;
		end if;
	end process;



---------------------------------------------------------------------
-- TX fifo.
---------------------------------------------------------------------



--
-- components:

--TX FIFO
	TX_FIFO1: TX_FIFO
		port map(
			--GP1000 signals
			idi		=> idi,
			idreq_tx_int	=> idreq_tx_int,
			idack_tx		=> idack_tx,
			clk_i		=> clk_i,
			--control signals
			reset		=> fifo_reset, --aka TX_GO = '0' or frame transmitted OK
			reset_read	=> clr_read,
			--status signals
			last		=> last_odd,
			legal		=> legal, --frame size legal (60 < frame size < 1514 )
			--DATA out
			read		=> even,
			TXD_DATA	=> txd_data,
			clk_tx		=> clk_tx
		);			

---------------------------------------------------------------------
-- TX CRC.
---------------------------------------------------------------------
	-- XOR the input data with the top nibble of the current CRC.
	txx <= (txc(28) xor crc_data(3)) & (txc(29) xor crc_data(2)) & (txc(30) xor crc_data(1)) & (txc(31) xor crc_data(0));

	-- Often used XOR subexpressions.
	xd012 <= txx(0) xor txx(1) xor txx(2);
	xd123 <= txx(1) xor txx(2) xor txx(3);
	xd013 <= txx(0) xor txx(1) xor txx(3);
	xd023 <= txx(0) xor txx(2) xor txx(3);
  
	process (clk_tx)
	begin
		if rising_edge(clk_tx) then
			if crc_gen = '0' then       -- After 8 clocks initialized to x"FFFFFFFF"
				txc(3 downto 0) <= (others => '1');
				txc(7 downto 4) <= txc(3 downto 0);
				txc(11 downto 8) <= txc(7 downto 4);
				txc(15 downto 12) <= txc(11 downto 8);
				txc(19 downto 16) <= txc(15 downto 12);
				txc(23 downto 20) <= txc(19 downto 16);
				txc(27 downto 24) <= txc(23 downto 20);
				txc(31 downto 28) <= txc(27 downto 24);
			else  
				txc <=	txc(27) &
								txc(26) &
								(txc(25) xor txx(0)) &
								(txc(24) xor txx(1)) &
								(txc(23) xor txx(2)) &
								(txc(22) xor txx(3) xor txx(0)) &
								(txc(21) xor txx(1) xor txx(0)) &
								(txc(20) xor txx(2) xor txx(1)) &
								(txc(19) xor txx(3) xor txx(2)) &
								(txc(18) xor txx(3)) &
								txc(17) &
								txc(16) &
								(txc(15) xor txx(0)) &             
								(txc(14) xor txx(1)) &
								(txc(13) xor txx(2)) &
								(txc(12) xor txx(3)) &
								(txc(11) xor txx(0)) &
								(txc(10) xor txx(1) xor txx(0)) &
								(txc(9) xor xd012) &
								(txc(8) xor xd123) &
								(txc(7) xor xd023) &
								(txc(6) xor xd013) &
								(txc(5) xor txx(2) xor txx(1)) &
								(txc(4) xor xd023) &
								(txc(3) xor xd013) &
								(txc(2) xor txx(2) xor txx(1)) &
								(txc(1) xor xd023) &
								(txc(0) xor xd013) &
								xd012 &
								xd123 &
								(txx(3) xor txx(2)) &
								txx(3);
			end if;
		end if;
	end process;

	-- CRC output.
	crc_out <= (preamble_5 xnor txc(31)) & ('0' xnor txc(30)) & (preamble_5 xnor txc(29)) & (preamble_8 xnor txc(28)); 
		
end architecture;
