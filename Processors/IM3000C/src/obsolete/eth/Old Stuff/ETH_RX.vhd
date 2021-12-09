-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : Ethernet receive
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : eth_rx.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              * wait_7
--              * crc_ok_delay
--              * better sync of fifo flags?
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-12-13		1.0				CB			Created
-------------------------------------------------------------------------------
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

entity ETH_RX is
	port(
		--GP1000 interface
		clk_i						: in	std_logic;
		inext						: in	std_logic;
		id_i				: in	std_logic_vector(7 downto 0);
		id_o				: out	std_logic_vector(7 downto 0);
		id_en			: out	std_logic;
		RX_REG_EN				: in	std_logic;
		RX_DA						: in	std_logic;
		RX_CTL					: in	std_logic;
		RX_FRAME_STS_EN	: in	std_logic; 
		ilioa						: in	std_logic;
		idack					: in	std_logic;
		idreq					: out	std_logic;
		
		--PHY Interface
		rx_er						: in	std_logic;
		rx_dv						: in	std_logic;
		rxd							: in	std_logic_vector(3 downto 0);
		clk_rx					: in	std_logic;
		
		--system reset
		reset						: in	std_logic
		);
end entity ETH_RX;

architecture structure of ETH_RX is
	--signals:
	signal start_rx_logic	: std_logic;
	signal clear_rx_logic	: std_logic;
	signal RX_GO			: std_logic;
	signal promiscuous		: std_logic;
	signal multicast		: std_logic;
	signal TIP				: std_logic;
	signal EARLY_ER			: std_logic;
	signal EQDA,EQMC,EQFF,EQSFD	: std_logic;
	signal c_11				: std_logic;
	signal FIND_ADR			: std_logic;
	signal CRCOK			: std_logic;
	signal REQ_EN			: std_logic;
	signal ADD_BYTE			: std_logic;
	signal RX_FIFO_FULL		: std_logic;
	signal RX_FIFO_EMPTY	: std_logic;
	signal overrun			: std_logic;
	signal MII_ER			: std_logic;
	signal CRC_ER			: std_logic;
	signal align_er			: std_logic;
	signal store_sts		: std_logic;
	signal odd_nibb,odd_byte: std_logic;
	signal sts_full			: std_logic;
	signal sts_empty		: std_logic;
	signal RX_RESET			: std_logic;
	signal GP_DATA_O_REG		: std_logic_vector(7 downto 0);
	signal GP_DATA_O_FIFO		: std_logic_vector(7 downto 0);
	signal GP_DATA_O_FRAME	: std_logic_vector(7 downto 0);
	signal RX_STS	: std_logic;
	signal RX_FRAME_STS : std_logic;
	
	type rx_states is (FIND_IFG,FIND_SFD,FIND_ADR,RECEIVE,POST_FRAME);
	signal rx_state : rx_states;
	signal ifg_ok		: std_logic;
	signal wait_7			: std_logic; --delay state change...with two cycles..
	signal crc_ok_delay		: std_logic;
	signal adr_ok			: std_logic;
	signal full_sync,empty_sync,sts_full_sync : std_logic;
	signal early_er_i		: std_logic;
	signal store_sts		: std_logic;
	signal add_byte		: std_logic;
	signal align_er		: std_logic;
	signal crc_er		: std_logic;
	signal overrun		: std_logic;
	signal mii_er		: std_logic;
	signal tip		: std_logic;
	signal clear_rx_logic		: std_logic;
	
	--RX_REG
	component RX_REG
		port(
		clk_i				: in	std_logic; --GP1000 CLK
		RX_CTL			: in	std_logic; --write register
		id_i		: in	std_logic_vector(7 downto 0);
		id_o		: out	std_logic_vector(7 downto 0);
		
		--CTL bits
		RX_GO				: out	std_logic; --Start RX logic
		RX_RESET		: out	std_logic; --Reset RX logic
		Multicast		: out	std_logic; --accept multicast frames
		Promiscuous	: out	std_logic; --accept all frames

		--STS bits
		FSV					: in	std_logic; --Frame Status Valid
		FSOVR				: in	std_logic; --Frame Status FIFO FULL
		TIP					: in	std_logic; --transfer in progress
		EARLY_ER		: in	std_logic; --early MII ER flag
		
		--system reset
		reset				: in	std_logic
		);	
	end component RX_REG;
		
	signal RX_RESET_INT	: std_logic;
	SIGNAL FSV			: STD_LOGIC;
	
	--RX_FIFO
	component RX_FIFO
		port(
		--PHY interface
		clk_rx		: in std_logic; --PHY CLK
		Write		: in std_logic; --rx_dv and SFD detected...
		rxd			: in std_logic_vector(3 downto 0); --nibble in...
				
		--GP1000 interface
		clk_i		: in std_logic; --GP1000 CLK
		idack		: in std_logic; 
		idreq		: out std_logic;
		REQ_EN		: in std_logic; --turn of idreq during ADR compare state
		GP_DATA		: out std_logic_vector(7 downto 0);
		
		--STATUS signals
		FULL		: out std_logic; --FIFO FULL
		EMPTY		: out std_logic; --FIFO EMPTY
		ADD_BYTE	: in std_logic; --ADD BYTE...
		
		--reset FIFO
		reset		: in std_logic --clear FIFO
		);
	end component RX_FIFO;
	
	signal RESET_FIFO	: std_logic;
	
	--RX_ADR_MEM
	component RX_ADR_MEM
		port(
		clk_i		: in std_logic; --GP1000 CLK
		GP_DATA		: in std_logic_vector(7 downto 0); 
		RX_DA		: in std_logic; --write 12 nibbles of adr
		ilioa		: in std_logic; --adr strobe
		
		clk_rx		: in std_logic; --PHY CLK
		rxd			: in std_logic_vector(3 downto 0);
		FIND_ADR	: in std_logic; --Find Adr..high for 12 nibbles...	
		C_11		: out std_logic; --12 nibbles gone by...	
		
		--status bits
		EQDA		: out std_logic; --correct adr...
		EQFF		: out std_logic; --broadcast...
		EQMC		: out std_logic; --multicast
		EQSFD		: out std_logic; --Start of Frame Delimiter found...
		
		reset		: in std_logic
		);
	end component RX_ADR_MEM;
	
	--RX_FRAME_FIFO
	component RX_FRAME_FIFO
		port(
		clk_i		: in std_logic; --GP1000 CLK
		RX_FRAME_STS: in std_logic; --read FRAME STS
		GP_DATA		: out std_logic_vector(7 downto 0); 
		
		clk_rx		: in std_logic;
		COUNT		: in std_logic; --count incoming nibbles...
		CLR_C		: in std_logic; --clear count
		
		--FRAME STS BITS
		overrun		: in std_logic; --RX FIFO overrun
		MII_ER		: in std_logic; --rx_er asserted during reception of frame
		CRC_ER		: in std_logic; --CRC ERROR
		ALIGN_ER	: in std_logic; --alignment error
		
		STORE_STS	: in std_logic; --frame received store status!
		
		--FRAME FIFO STATUS
		odd_nibb	: out std_logic; --odd number off nibbles received...
		odd_byte	: out std_logic; --odd number off bytes received...
		full		: out std_logic;
		empty		: out std_logic;
		
		reset		: in std_logic
		);
	end component RX_FRAME_FIFO;
	
	--RX_CRC
	component RXCRC
		port (
    	CLK   : in  std_logic;
    	CLKEN : in  std_logic;
    	INIT  : in  std_logic;
    	D     : in  std_logic_vector(3 downto 0);
    	CRCOK : out std_logic);
	end component RXCRC;
			
	
begin
	RX_FRAME_STS <= RX_FRAME_STS_EN AND not inext;

	--SET RX RESET:
	RX_RESET <= RX_RESET_INT OR RESET;

	RX_REG1: RX_REG
		port map(
		clk_i				=> clk_i,
		RX_CTL			=> RX_CTL,
		id_i		=> id_i,
		id_o		=> GP_DATA_O_REG,
		
		--CTL bits
		RX_GO				=> RX_GO,
		RX_RESET		=> RX_RESET_INT,
		Multicast		=> MULTICAST,
		Promiscuous	=> PROMISCuouS,
		
		--STS bits
		FSV					=> FSV,
		FSOVR				=> STS_FULL,
		TIP					=> TIP, --transfer in progress
		EARLY_ER		=> EARLY_ER, --early MII ER flag
		
		--system reset
		reset				=> RESET
		);	
	
	FSV <= NOT STS_EMPTY;
	
	RX_FIFO1: RX_FIFO
		port map(
		--PHY interface
		clk_rx		=> clk_rx, --PHY CLK
		Write		=> START_RX_LOGIC, --rx_dv and SFD detected...
		rxd			=> rxd, --nibble in...
				
		--GP1000 interface
		clk_i		=> clk_i, --GP1000 CLK
		idack		=> idack, 
		idreq		=> idreq,
		REQ_EN		=> REQ_EN, --turn of idreq during ADR compare state
		GP_DATA		=> GP_DATA_O_FIFO,
		
		--STATUS signals
		FULL		=> RX_FIFO_FULL,--FIFO FULL
		EMPTY		=> RX_FIFO_EMPTY, --FIFO EMPTY
		ADD_BYTE	=> ADD_BYTE, --ADD BYTE...
		
		--reset FIFO
		reset		=> CLEAR_RX_LOGIC --clear FIFO
		);
		
	RX_ADR_MEM1: RX_ADR_MEM
		port map(
		clk_i		=> clk_i,
		GP_DATA	=> id_i,
		RX_DA		=> rx_da,
		ilioa		=> ilioa,
		
		clk_rx		=> clk_rx,
		rxd			=> rxd,
		FIND_ADR	=> find_adr,	
		C_11		=> c_11,
		
		--status bits
		EQDA		=> EQDA,
		EQFF		=> EQFF,
		EQMC		=> EQMC,
		EQSFD		=> EQSFD,
		
		reset		=> reset
		);
	
	RX_FRAME_FIFO1: RX_FRAME_FIFO
		port map(
		clk_i		=> clk_i,
		RX_FRAME_STS=> RX_FRAME_STS, --read FRAME STS
		GP_DATA		=> GP_DATA_O_FRAME, 
		
		clk_rx		=> clk_rx,
		COUNT		=> start_rx_logic, --count incoming nibbles...
		CLR_C		=> clear_rx_logic, --clear count
		
		--FRAME STS BITS
		overrun		=> overrun, --RX FIFO overrun
		MII_ER		=> MII_ER, --rx_er asserted during reception of frame
		CRC_ER		=> CRC_ER, --CRC ERROR
		ALIGN_ER	=> ALIGN_ER, --alignment error
		
		STORE_STS	=> store_sts, --frame received store status!
		
		--FRAME FIFO STATUS
		odd_nibb	=> odd_nibb, --odd number off nibbles received...
		odd_byte	=> odd_byte, --odd number off bytes received...
		full		=> sts_full,
		empty		=> sts_empty,
		
		reset		=> RX_RESET
		);
	
	RXCRC1: RXCRC
		port map(
    	CLK   => clk_rx,
    	CLKEN => start_rx_logic,
    	INIT  => clear_rx_logic,
    	D     => rxd,
    	CRCOK => CRCOK
    	);	

	id_o <=	GP_DATA_O_FIFO when idack = '0' else
								GP_DATA_O_FRAME when RX_FRAME_STS_EN = '1' else
								GP_DATA_O_REG;

	id_en <= RX_REG_EN or RX_FRAME_STS_EN or not idack;
end architecture structure;
