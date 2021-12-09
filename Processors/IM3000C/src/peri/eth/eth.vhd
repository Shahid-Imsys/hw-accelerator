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
-- Title      : Ethernet top level
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : eth.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              * Remove input registers?
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-12-15		1.0				CB			Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity eth is
	generic (
		TX_CTL_ADR		: std_logic_vector(7 downto 0) := x"23"; --acts as CTL/STS
		RX_CTL_ADR		: std_logic_vector(7 downto 0) := x"20"; --acts as CTL/STS
		RX_DA_ADR			: std_logic_vector(7 downto 0) := x"21";
		RX_STS_ADR		: std_logic_vector(7 downto 0) := x"22";		
		RX_CTL_ADR_2	: std_logic_vector(7 downto 0) := x"24"; --acts as CTL/STS
		RX_DA_ADR_2		: std_logic_vector(7 downto 0) := x"25";
		RX_STS_ADR_2	: std_logic_vector(7 downto 0) := x"26";		
		TX_SIZE				: natural := 3;	-- 2-log of TX fifo size in nibbles		
		RX_SIZE				: natural := 3;	-- 2-log of RX fifo size in nibbles		
		STS_SIZE			: natural := 2;	-- 2-log of STS fifo size in 16-bit statuses		
		RX_SIZE_2			: natural := 3;	-- 2-log of RX fifo size in nibbles		
		STS_SIZE_2		: natural := 2);-- 2-log of STS fifo size in 16-bit statuses		
	port (
		-- Processor interface
		clk_i			: in	std_logic;
		ilioa			: in	std_logic;
		ildout		: in	std_logic;
		inext			: in	std_logic;
		idi				: in	std_logic_vector(7 downto 0);
		ido				: out	std_logic_vector(7 downto 0);
		iden			: out	std_logic;
		rx1_irq		: out	std_logic;
		rx2_irq		: out	std_logic;
		tx_irq		: out	std_logic;
		rx1_idack	: in	std_logic;
		rx1_idreq	: out	std_logic;
		rx2_idack	: in	std_logic;
		rx2_idreq	: out	std_logic;
		tx_idack	: in	std_logic;
		tx_idreq	: out	std_logic;
		-- PHY interface
		clk_rx		: in	std_logic;
		clk_tx		: in	std_logic;
		erxdv			: in	std_logic;
		erxer			: in	std_logic;
		erxd			: in	std_logic_vector(3 downto 0);
		etxen			: out	std_logic;
		etxer			: out	std_logic;
		ecol			: in	std_logic;
		ecrs			: in	std_logic;
		etxd			: out	std_logic_vector(3 downto 0);
		-- Other control inputs and outputs
		tstamp		: out	std_logic_vector(2 downto 0);
		en_eth		: in	std_logic_vector(1 downto 0));
end entity eth;

architecture structure of eth is
-- Input/output registers
	signal rxdv			: std_logic;
	signal rxer			: std_logic;
	signal rxd			: std_logic_vector(3 downto 0);
	signal txen			: std_logic;
	signal txer			: std_logic;
	signal col			: std_logic;
	signal crs			: std_logic;
	signal txd			: std_logic_vector(3 downto 0);
	
-- RMII conversion
	signal rst_en1		: std_logic;
	signal rst_en2		: std_logic;
	signal rx1_clken	: std_logic;
	signal rx1_odd		: std_logic;
	signal rx1_dreg		: std_logic_vector(1 downto 0);
	signal rx1_ff1		: std_logic;
	signal rx1_ff2		: std_logic;
	signal rx1_ff3		: std_logic;
	signal rx1_rxdv		: std_logic;
	signal rx1_rxer		: std_logic;
	signal rx1_crs		: std_logic;
	signal rx1_rxd		: std_logic_vector(3 downto 0);
	signal rx2_clken	: std_logic;
	signal rx2_odd		: std_logic;
	signal rx2_dreg		: std_logic_vector(1 downto 0);
	signal rx2_ff1		: std_logic;
	signal rx2_ff2		: std_logic;
	signal rx2_ff3		: std_logic;
	signal rx2_rxdv		: std_logic;
	signal rx2_rxer		: std_logic;
	signal rx2_crs		: std_logic;
	signal rx2_rxd		: std_logic_vector(3 downto 0);
	signal tx_clken		: std_logic;
	signal tx_odd			: std_logic;
	signal tx_txen		: std_logic;
	signal tx_txer		: std_logic;
	signal tx_col			: std_logic;
	signal tx_crs			: std_logic;
	signal tx_txd			: std_logic_vector(3 downto 0);

-- Instantiations of receivers and transmitter                                                 --
	signal rx1_ido		: std_logic_vector(7 downto 0);
	signal rx1_iden	: std_logic;
	signal rx2_ido	: std_logic_vector(7 downto 0);
	signal rx2_iden	: std_logic;
	signal tx_ido		: std_logic_vector(7 downto 0);
	signal tx_iden	: std_logic;
	signal rx1_fast	: std_logic;
	signal rx2_fast	: std_logic;
	signal tx_fast	: std_logic;
	signal phy_sel	: std_logic;

begin
----------------------------------------------------------------
-- Input/output registers.
----------------------------------------------------------------
--	-- Register incoming signals in the clk_rx domain.
--	process (clk_rx, rst_en1)
--	begin
--		if rst_en1 = '0' then
--			rxer <= '0';
--			rxdv <= '0';		
--			rxd <= (others => '0');
--		elsif rising_edge(clk_rx) then
--			rxer <= erxer;
--			rxdv <= erxdv;		
--			rxd <= erxd;
--		end if;
--	end process;
	rxer <= erxer;
	rxdv <= erxdv;		
	rxd <= erxd;
	

--	-- Register incoming and outgoing signals in the clk_tx domain.
--	process (clk_tx, rst_en1)
--	begin
--		if rst_en1 = '0' then
--			col		<= '0';
--			crs		<= '0';
--			etxer	<= '0';
--			etxen	<= '0';
--			etxd	<= (others => '0');
--		elsif rising_edge(clk_tx) then
--			col		<= ecol;
--			crs		<= ecrs;
--			etxer	<= txer;
--			etxen	<= txen;
--			etxd	<= txd;
--		end if;
--	end process;
	col		<= ecol;
	crs		<= ecrs;
	etxer	<= txer;
	etxen	<= txen;
	etxd	<= txd;

----------------------------------------------------------------
-- ido mux.
----------------------------------------------------------------
	ido <=	rx1_ido when rx1_iden = '1' else
					rx2_ido when rx2_iden = '1' else
					tx_ido;

	iden <= rx1_iden or rx2_iden or tx_iden; 
								
----------------------------------------------------------------
-- RMII conversion
----------------------------------------------------------------
	rst_en1 <= en_eth(1) or en_eth(0);
	rst_en2 <= en_eth(1) and en_eth(0);

	-- Generate rx1_clken, always high in MII mode, high every 2nd
	-- cycle in 100Mbps RMII mode, high every 20th cycle in 10Mbps
	-- RMII mode.
	-- Also generate helper ffs rx1_dreg, rx1_ff1, rx1_ff2, rx1_ff3.
	process (clk_rx, rst_en1)
		variable ctr10	: integer range 0 to 9;
	begin
		if rst_en1 = '0' then
			rx1_clken	<= '0';
			ctr10			:= 0;
			rx1_odd		<= '0';
			rx1_dreg	<= "00";
			rx1_ff1		<= '0';
			rx1_ff2		<= '0';
			rx1_ff3		<= '0';
		elsif rising_edge(clk_rx) then
			rx1_clken	<= '1';
			if en_eth (1) = '1' then
				if rx1_fast = '1' or ctr10 = 9 then
					-- clken is high in every 2nd cycle, except it will syncronize itself
					-- so it's high during the second preamble dibit by staying low after
					-- crs_dv gone high.
					rx1_odd		<= not rx1_odd;
					if rx1_fast = '1' then
						rx1_clken	<= not rx1_odd;
						if rx1_ff2 = '1' and rx1_ff3 = '0' and rxd(1 downto 0) /= "01" then
							rx1_clken	<= '0';
							rx1_odd		<= '0';
						end if;
					else
						rx1_clken	<= '0';
						if rx1_ff2 = '1' and rx1_ff3 = '0' and rxd(1 downto 0) = "01" then
							rx1_odd		<= '1';
						end if;
					end if;

					-- Helper ffs:	
					-- dreg is the dibit receive data delayed by one cycle.
					-- ff1 and ff2 are just ffs following the asynchronous crs_dv.
					-- ff3 goes high after the 1st preamble dibit, low when crs_dv low for 2 cycles.
					rx1_dreg <= rxd(1 downto 0);
					rx1_ff1 <= rxdv;
					rx1_ff2 <= rx1_ff1;
					if rx1_ff2 = '1' and rxdv = '0' then
						rx1_ff3 <= '0';
					elsif rx1_ff2 = '1' and rxd(1 downto 0) = "01" then
						rx1_ff3 <= '1';
					end if;

					ctr10	:= 0;
				elsif ctr10 = 8 then
					rx1_clken	<= rx1_odd;
					ctr10	:= ctr10 + 1;
				else
					rx1_clken	<= '0';
					ctr10	:= ctr10 + 1;
				end if;
			end if;
		end if;
	end process;
	rx1_rxdv 	<= rxdv when en_eth(1) = '0' else	-- MII
							 rxdv and rx1_ff3;							-- RMII
	rx1_rxer	<= rxer;
	rx1_crs		<= crs when en_eth(1) = '0' else	-- MII
							 rxdv and rx1_ff1 and rx1_ff2;	-- RMII
	rx1_rxd		<= rxd when en_eth(1) = '0' else	-- MII
							 rxd(1 downto 0) & rx1_dreg;		-- RMII

	-- Generate rx2_clken, high every 2nd cycle in 100Mbps mode when
	-- 2nd RMII used , high every 20th cycle in 10Mbps mode.
	-- Also generate helper ffs rx2_dreg, rx2_ff1, rx2_ff2, rx2_ff3.
	process (clk_rx, rst_en2)
		variable ctr10	: integer range 0 to 9;
	begin
		if rst_en2 = '0' then
			rx2_clken	<= '0';
			ctr10			:= 0;
			rx2_odd		<= '0';
			rx2_dreg	<= "00";
			rx2_ff1		<= '0';
			rx2_ff2		<= '0';
			rx2_ff3		<= '0';
		elsif rising_edge(clk_rx) then
			if rx2_fast = '1' or ctr10 = 9 then
				-- clken is high in every 2nd cycle, except it will syncronize itself
				-- so it's high during the second preamble dibit by staying low after
				-- crs_dv gone high.
				rx2_odd		<= not rx2_odd;
				if rx2_fast = '1' then
					rx2_clken	<= not rx2_odd;
					if rx2_ff2 = '1' and rx2_ff3 = '0' and rxd(3 downto 2) /= "01" then
						rx2_clken	<= '0';
						rx2_odd		<= '0';
					end if;
				else
					rx2_clken	<= '0';
					if rx2_ff2 = '1' and rx2_ff3 = '0' and rxd(3 downto 2) = "01" then
						rx2_odd		<= '1';
					end if;
				end if;

				-- Helper ffs:	
				-- dreg is the dibit receive data delayed by one cycle.
				-- ff1 and ff2 are just ffs following the asynchronous crs_dv.
				-- ff3 goes high after the 1st preamble dibit, low when crs_dv low for 2 cycles.
				rx2_dreg <= rxd(3 downto 2);
				rx2_ff1 <= col;
				rx2_ff2 <= rx2_ff1;
				if rx2_ff2 = '1' and col = '0' then
					rx2_ff3 <= '0';
				elsif rx2_ff2 = '1' and rxd(3 downto 2) = "01" then
					rx2_ff3 <= '1';
				end if;

				ctr10	:= 0;
			elsif ctr10 = 8 then
				rx2_clken	<= rx2_odd;
				ctr10	:= ctr10 + 1;
			else
				rx2_clken	<= '0';
				ctr10	:= ctr10 + 1;
			end if;
		end if;
	end process;
	rx2_rxdv	<= col and rx2_ff3;								-- RMII
	rx2_rxer	<= crs;
	rx2_crs		<= col and rx2_ff1 and rx2_ff2;		-- RMII
	rx2_rxd		<= rxd(3 downto 2) & rx2_dreg;		-- RMII
							
	-- Generate tx_clken, always high in MII mode, high every 2nd
	-- cycle in 100Mbps RMII mode, high every 20th cycle in 10Mbps
	-- RMII mode.
	-- Also generate helper ff tx_odd.
	process (clk_tx, rst_en1)
		variable ctr10	: integer range 0 to 9;
	begin
		if rst_en1 = '0' then
			tx_clken	<= '0';
			ctr10			:= 0;
			tx_odd		<= '0';
		elsif rising_edge(clk_tx) then
			tx_clken	<= '1';
			if en_eth (1) = '1' then
				tx_clken	<= '0';
				if tx_fast = '1' then
					tx_odd		<= not tx_odd;
					tx_clken	<= not tx_odd;
				elsif ctr10 = 9 then
					tx_clken	<= tx_odd;
					ctr10	:= 0;
				else
					if ctr10 = 0 then
						tx_odd <= not tx_odd;
					end if;
					ctr10	:= ctr10 + 1;
				end if;
			end if;
		end if;
	end process;
							 
	txen	<= tx_txen when en_eth(1) = '0' else								-- MII
					 '0' when en_eth(0) = '1' and phy_sel = '1' else	-- Dual RMII and 2nd used
					 tx_txen;																					-- 1st RMII
	txer	<= tx_txer when en_eth(1) = '0' else								-- MII
					 '0' when en_eth(0) = '0' or phy_sel = '0' else		-- Single RMII or 1st used
					 tx_txen;																					-- 2nd RMII
	txd(3 downto 2) <=	tx_txd(3 downto 2) when en_eth(1) = '0' else			-- MII
											"00" when en_eth(0) = '0' or phy_sel = '0' else		-- Single RMII or 1st used
											tx_txd(1 downto 0) when tx_odd = '0' else					-- 2nd RMII, 1st dibit
											tx_txd(3 downto 2);																-- 2nd RMII, 2nd dibit
	txd(1 downto 0) <=	tx_txd(1 downto 0) when en_eth(1) = '0' else			-- MII
											"00" when en_eth(0) = '1' and phy_sel = '1' else	-- Dual RMII and 2nd used
											tx_txd(1 downto 0) when tx_odd = '0' else					-- 1st RMII, 1st dibit
											tx_txd(3 downto 2);																-- 1st RMII, 2nd dibit

	tx_crs <= rx2_crs when en_eth = "11" and phy_sel = '1' else	-- Dual RMII and 2nd used
						rx1_crs;																					-- MII, single RMII or 1st used
	tx_col <= col when en_eth(1) = '0' else											-- MII
						tx_crs and tx_txen;																-- RMII

----------------------------------------------------------------
-- Instantiations of receivers and transmitter.
----------------------------------------------------------------
  eth_rx1 : entity work.eth_rx
		generic map (
			RX_CTL_ADR	=> RX_CTL_ADR,
			RX_DA_ADR		=> RX_DA_ADR,
			RX_STS_ADR	=> RX_STS_ADR,
			RX_SIZE			=> RX_SIZE,
			STS_SIZE		=> STS_SIZE)
		port map (
			-- Processor interface
			clk_i		=> clk_i,
			ilioa		=> ilioa,
			ildout	=> ildout,
			inext		=> inext,
			idack		=> rx1_idack,
			idreq		=> rx1_idreq,
			idi			=> idi,
			ido			=> rx1_ido,
			iden		=> rx1_iden,
			irq			=> rx1_irq,
			-- PHY Interface
			clk_rx	=> clk_rx,
			clken		=> rx1_clken,
			rxdv		=> rx1_rxdv,
			rxer		=> rx1_rxer,
			rxd			=> rx1_rxd,
			-- Control register output
			fast		=> rx1_fast,
			tstamp	=> tstamp(0),
			-- System reset
			rst_en	=> rst_en1);	

  eth_rx2 : entity work.eth_rx
		generic map (
			RX_CTL_ADR	=> RX_CTL_ADR_2,
			RX_DA_ADR		=> RX_DA_ADR_2,
			RX_STS_ADR	=> RX_STS_ADR_2,
			RX_SIZE			=> RX_SIZE_2,
			STS_SIZE		=> STS_SIZE_2)
		port map (
			-- Processor interface
			clk_i		=> clk_i,
			ilioa		=> ilioa,
			ildout	=> ildout,
			inext		=> inext,
			idack		=> rx2_idack,
			idreq		=> rx2_idreq,
			idi			=> idi,
			ido			=> rx2_ido,
			iden		=> rx2_iden,
			irq			=> rx2_irq,
			-- PHY Interface
			clk_rx	=> clk_rx,
			clken		=> rx2_clken,
			rxdv		=> rx2_rxdv,
			rxer		=> rx2_rxer,
			rxd			=> rx2_rxd,
			-- Control register output
			fast		=> rx2_fast,
			tstamp	=> tstamp(1),
			-- System reset
			rst_en	=> rst_en2);	

  eth_tx1 : entity work.eth_tx
		generic map (
			TX_CTL_ADR	=> TX_CTL_ADR,
			TX_SIZE			=> TX_SIZE)
		port map (
			-- Processor interface
			clk_i		=> clk_i,
			ilioa		=> ilioa,
			ildout	=> ildout,
			inext		=> inext,
			idack		=> tx_idack,
			idreq		=> tx_idreq,
			idi			=> idi,
			ido			=> tx_ido,
			iden		=> tx_iden,
			irq			=> tx_irq,
			-- PHY Interface
			clk_tx	=> clk_tx,
			clken		=> tx_clken,
			txen		=> tx_txen,
			txer		=> tx_txer,
			col			=> tx_col,
			crs			=> tx_crs,
			txd			=> tx_txd,
			-- Control register outputs
			fast		=> tx_fast,
			phy_sel	=> phy_sel,
			tstamp	=> tstamp(2),
			-- System reset
			rst_en	=> rst_en1);	

end architecture structure;
		
