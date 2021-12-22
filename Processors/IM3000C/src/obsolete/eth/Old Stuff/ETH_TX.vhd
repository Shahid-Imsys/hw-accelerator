------------------------------------------------------------------
--
-- Projectname	: ETH_TX	
-- Filename		: ETH_TX_01.vhd
-- Title		: ETH_TX
-- Author		: Erik Henkel
-- Description	: TX part of Ethernet block...This block connect the 
--				Blocks included in the TX part...
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010118	1			Intial version
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

entity ETH_TX is
	port(
		--GP1000 interface
		idi	: in	std_logic_vector(7 downto 0);
		GP_DATA_O	: out	std_logic_vector(7 downto 0);
		clk_i			: in	std_logic;
		idack_tx		: in	std_logic;
		idreq_tx		: out	std_logic;
		
		--Register enable signals
		TX_CTL		: in	std_logic;
		
		--PHY interface
		crs		: in	std_logic;
		col		: in	std_logic;
		txen			: out	std_logic;
		txer			: out	std_logic;
		txd				: out	std_logic_vector(3 downto 0);
		clk_tx		: in	std_logic;
		
		fulldpx		: out	std_logic;

		--system reset
		reset			: in	std_logic		
		);
end entity ETH_TX;

architecture struct of ETH_TX is

	--TX_DATA component
	component TX_DATA
		port(
		--GP1000 signals
		GP_DATA		: in std_logic_vector(7 downto 0);
		idreq_tx		: out std_logic;
		idack_tx		: in std_logic;
		clk_i		: in std_logic; --GP1000 CLK
		
		--control signals
		reset			: in std_logic; --reset all (TX_GO = '0')
		COL_HALF	: in std_logic; --collision indicated from PHY
		CRS_HALF	: in std_logic; --carrier sense indicated from PHY
		ODD 			: in std_logic; --decide if an odd or even frame should be transmitted
		GO_TX			: in std_logic; --legal frame and TX_GO issued...
		
		--GPT signals
		GPT_CLR		: out std_logic;
		GPT_7		: in std_logic;
		GPT_15		: in std_logic;
		
		--status signals
		TX_DONE		: out std_logic;
		LEGAL		: out std_logic;
		
		--PHY control signals
		txer		: out std_logic; --transmitt error
		txen		: out std_logic; --request line!
		
		--data out
		txd			: out std_logic_vector(3 downto 0);
		clk_tx		: in std_logic --transmission CLK
		);
	end component;
		
	--TX_GPT component
	component GPT
		port(
		clk_tx	: in std_logic;
		CLR		: in std_logic;
		
		GPT_7	: out std_logic; --7 cycles
		GPT_15	: out std_logic --15 cycles
		);	
	end component;
	
	--TX_REG component
	component TX_REG
		port (
		idi	: in	std_logic_vector(7 downto 0);
		GP_DATA_O	: out	std_logic_vector(7 downto 0);
		clk_i			: in	std_logic;
		clk_tx		: in	std_logic;
		reset			: in	std_logic; --system reset
				
		--register enable signals
		TX_CTL		: in	std_logic;
		
		--CTL signals
		TX_RESET	: out	std_logic; --TX_GO = 0
		fulldpx	: out	std_logic; --full duplex
		ODD				: out	std_logic; --transmit odd frame
		GO_TX			: out	std_logic;
		
		--STS signals
		TX_DONE		: in	std_logic; --FRAME sent
		COL				: in	std_logic; --collision
		LEGAL			: in	std_logic --frame size legal
		
		);	
	end component;
	
	--signals
	signal idreq_tx_int	 : std_logic;
	signal valid_col : std_logic;
	signal valid_crs	: std_logic;
	signal not_empty : std_logic;
	signal gpt_clr  : std_logic;
	signal gpt_7	: std_logic;
	signal gpt_15	: std_logic;
	signal odd	: std_logic;
	signal tx_reset		: std_logic;
	signal tx_done : std_logic;
	signal go_tx : std_logic;
	signal legal		: std_logic;
	
begin

	valid_col <= col and not fulldpx;
	valid_crs <= crs and not fulldpx;
	
	idreq_tx <= not(not idreq_tx_int AND dma_en);
	
	TX_DATA1: TX_DATA
		port map(
		--GP1000 signals
		idi		=> idi,
		idreq_tx		=> idreq_tx_int,
		idack_tx		=> idack_tx,
		clk_i		=> clk_i,
		
		--control signals
		reset		=> tx_reset, --reset all (TX_GO = '0')
		COL_HALF	=> valid_col, --collision indicated from PHY
		CRS_HALF	=> valid_crs, --carrier sense indicated from PHY
		ODD 	=> odd, --decide if an odd or even frame should be transmitted
		GO_TX		=> go_tx,
		
		--GPT signals
		GPT_CLR		=> gpt_clr,
		GPT_7		=> gpt_7,
		GPT_15		=> gpt_15,
		
		--status signals
		TX_DONE		=> tx_done,
		LEGAL		=> legal,
		
		--PHY control signals
		txer		=> txer, --transmitt error
		txen		=> txen, --request line!
		
		--data out
		txd			=> txd,
		clk_tx		=> clk_tx --transmission CLK
		);
	
	GPT1: GPT
		port map(
		clk_tx	=> clk_tx,
		CLR		=> gpt_clr,
		
		GPT_7	=> gpt_7, --7 cycles
		GPT_15	=> gpt_15 --15 cycles
		);
	
	TX_REG1: TX_REG
		port map(
		idi	=> idi,
		GP_DATA_O	=> GP_DATA_O,
		clk_i			=> clk_i,
		clk_tx		=> clk_tx,
		reset			=> reset, --system reset
				
		--register enable signals
		TX_CTL		=> TX_CTL,
		
		--CTL signals
		TX_RESET	=> tx_reset, --TX_GO = 0
		fulldpx	=> fulldpx, --full duplex
		ODD				=> odd, --transmit odd frame
		GO_TX			=> go_tx,
		
		--STS signals
		TX_DONE		=> tx_done,
		COL				=> valid_col, --collision
		LEGAL			=> legal
		);	


end architecture;
