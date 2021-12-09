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
--              * Make dma_en readable
--              * collision metastable, ok?
--              * Remove input registers?
--              * Remove loopback block?
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

--simulation of Spartan2 components: (remove during syntesis)
--library unisim;
--use unisim.vcomponents.all;

--syntes with Spartan2 components: (remove during simulation i think)
--This package is a version of the Synopsys package and has been 
-- optimized for use with the Express compiler.
--library SYNOPSYS;
--use SYNOPSYS.attributes.all;

entity ETH is
	generic(
		TX_CTL_ADR		: std_logic_vector(7 downto 0) := x"24"; --acts as CTL/STS
		RX_CTL_ADR		: std_logic_vector(7 downto 0) := x"20"; --acts as CTL/STS
		RX_DA_ADR		: std_logic_vector(7 downto 0) := x"21";
		RX_FRAME_STS_ADR: std_logic_vector(7 downto 0) := x"22";		
		rxf_size		: natural := 2;	-- 2-log of size in bytes		
		stsf_size		: natural := 2	-- 2-log of size in 16-bit frame status entries		
		);
	port(
		--GP1000 interface...
		clk_i				: in	std_logic;
		idi		: in	std_logic_vector(7 downto 0);
		ido		: out	std_logic_vector(7 downto 0);
		iden	: out	std_logic;
		ilioa				: in	std_logic;
		INEXT				: in	std_logic;
		ILDOUT			: in	std_logic;
		
		--DMA handling
		TX_DMA_EN		: out	std_logic;
		idack_tx	: in	std_logic;
		idreq_tx	: out	std_logic;
		idack_rx	: in	std_logic;
		idreq_rx	: out	std_logic;
		
		--PHY interface
		ecrs				: in	std_logic;
		ecol				: in	std_logic;
		etxer				: out	std_logic;
		etxen				: out	std_logic;
		etxd				: out	std_logic_vector(3 downto 0);
		clk_tx			: in	std_logic;
		erxdv				: in	std_logic;
		erxer				: in	std_logic;
		erxd				: in	std_logic_vector(3 downto 0);
		clk_rx			: in	std_logic;
		
		--system reset
		reset				: in	std_logic
		);
end entity ETH;

architecture structure of ETH is

	--buffert stages for PHY interface...
	signal txer,txen,col,crs : std_logic;
	signal rxer,rxdv : std_logic;
	signal txd,rxd : std_logic_vector(3 downto 0);
	
	--register signals
	signal tx_reg_wr,tx_reg_sel	: std_logic;
	signal rx_reg_wr,rx_reg_sel	: std_logic;
	signal rx_da_sel,rx_sts_sel : std_logic;
	signal rx_da_wr		: std_logic;
	signal fulldpx	: std_logic;
	signal adr_block	: std_logic;
	signal GP_DATA_O_RX,GP_DATA_O_TX	: std_logic_vector(7 downto 0);
	signal GP_DATA_EN_RX	: std_logic;

	signal rxf_wctr		: std_logic_vector(rxf_size downto 0);
	signal rxf_rctr		: std_logic_vector(rxf_size-1 downto 0);
	signal rxf_count		: std_logic_vector(rxf_size-1 downto 0);
	signal rxf_dout	: std_logic_vector(7 downto 0);

	signal stsf_wctr		: std_logic_vector(stsf_size-1 downto 0);
	signal stsf_rctr		: std_logic_vector(stsf_size downto 0);
	signal stsf_count		: std_logic_vector(stsf_size downto 0);
	signal stsf_dout	: std_logic_vector(7 downto 0);

begin
	------------------------------------------------------------------------------
	-- Input/output registers                                                 --
	------------------------------------------------------------------------------
	-- Register incoming signals in the clk_rx domain.
	process (clk_rx, reset)
	begin
		if reset = '1' then
			rxer <= '0';
			rxdv <= '0';		
		elsif rising_edge(clk_rx) then
			rxer <= erxer;
			rxdv <= erxdv;		
		end if;
	end process;

	-- Block rxd registers during 10Mbit halfduplex, PHY operational loopback!!
	process (clk_rx, reset, adr_block)
	begin
		if reset = '1' or adr_block = '1' then
			rxd <= (others => '0');
		elsif rising_edge(RX_CLK) then
			rxd <= erxd;
		end if;
	end process;
	adr_block <= not fulldpx and txen;

	-- Register incoming and outgoing signals in the clk_tx domain.
	process (clk_tx, reset)
	begin
		if reset = '1' then
			col		<= '0';
			crs		<= '0';
			etxer	<= '0';
			etxen	<= '0';
			etxd	<= (others => '0');
		elsif rising_edge(TX_CLK) then
			col		<= ecol;
			crs		<= ecrs;
			etxer	<= txer;
			etxen	<= txen;
			etxd	<= txd;
		end if;
	end process;

	------------------------------------------------------------------------------
	-- Address decode & ido mux                                                 --
	------------------------------------------------------------------------------
	-- This process decodes I/O addresses
	process (clk_i, rst_en)
	begin
		if reset = '1' then
			tx_reg_sel	<= '0';
			rx_reg_sel	<= '0';
			rx_da_sel		<= '0';
			rx_sts_sel	<= '0';
		elsif rising_edge(clk_i) then
			if ilioa = '0' then
				tx_reg_sel	<= '0';
				rx_reg_sel	<= '0';
				rx_da_sel		<= '0';
				rx_sts_sel	<= '0';
				if idi = TX_CTL_ADR then
					tx_reg_sel <= '1';
				end if;
				if idi = RX_CTL_ADR then
					rx_reg_sel <= '1';
				end if;
				if idi = RX_DA_ADR then
					rx_da_sel <= '1';
				end if;
				if idi = RX_FRAME_STS_ADR then
					rx_sts_sel <= '1';
				end if;
			end if;
		end if;
	end process;
	tx_reg_wr <= '1' when tx_reg_sel = '1' and ildout = '0' else '0';
	rx_reg_wr <= '1' when rx_reg_sel = '1' and ildout = '0' else '0';
	rx_reg_rd	<= '1' when rx_reg_sel = '1' and inext = '0' else '0';
	rx_da_wr	<= '1' when rx_da_sel = '1' and ildout = '0' else '0';
	rx_sts_rd	<= '1' when rx_sts_sel = '1' and inext = '0' else '0';

	ido <=	rxf_dout when idack_rx = '0' else
					tx_reg when tx_reg_sel = '1' else
					rx_reg when rx_reg_sel = '1' else
					stsf_dout;

	iden <= not inext and (tx_reg_sel or rx_reg_sel or rx_sts_sel) or not idack; 
								
	------------------------------------------------------------------------------
	-- Control/status registers                                                 --
	------------------------------------------------------------------------------
	-- TX control/status register.
	process (clk_i, reset)
	begin
		if reset = '1' then
			tx_reset	<= '1';		
			start			<= '0';
			dma_en		<= '0';
			tx_reg(4)	<= '0';
			tx_reg(2)	<= '0';
		elsif rising_edge(clk_i) then
			tx_reset	<= '0';
			start			<= '0';
			if tx_reg_wr = '1' then
				tx_reset	<= not idi(7);	-- Writing '0' to bit 7 will cause a high pulse on tx_reset
				start			<= idi(7);			-- Writing '1' to bit 7 will cause a high pulse on start		
				dma_en		<= idi(6);
				tx_reg(4)	<= idi(4);
				tx_reg(2)	<= idi(2);
			end if;
		end if;
	end process;
	tx_reg(7)	<= busy;
	tx_reg(6)	<= collision;
	tx_reg(5)	<= '0';
	full_dpx	<= tx_reg(4);
	tx_reg(3)	<= size_error;
	odd				<= tx_reg(2);
	tx_reg(1)	<= '0';
	tx_reg(0)	<= '0';

	-- RX control/status register.
	process (clk_i, reset)
	begin
		if reset = '1' then
			rx_reg <= (others => '0');		
		elsif rising_edge(clk_i) then
			if rx_reg_wr = '1' then
				rx_reg <= idi(7 downto 4);
			end if;
		end if;
	end process;
	rx_go				<= rx_reg(7);
	rx_reset		<= rx_reg(6);
	multicast		<= rx_reg(5);
	promiscuous	<= rx_reg(4);
	rx_reg(3)		<= fsv;
	rx_reg(2)		<= fsovr;
	rx_reg(1)		<= tip;
	rx_reg(0)		<= early_er;
	
	xreset <= rx_reset or reset;

	-- 'collision' status bit, set on half-duplex collision,
	-- reset when TX control register written.
	process (clk_i, reset)
	begin
		if reset = '1' then
			collision <= '0';
		elsif rising_edge(clk_i) then
			if tx_reg_wr = '1' then
				collision <= '0';		
			elsif col = '1' and full_dpx = '0' then
				collision <= '1';		
			end if;
		end if;
	end process;

	-- 'size_error' status bit, set when requested frame size is illegal,
	-- reset when TX control register bit 7 written with '0'.
	process (clk_i, tx_reset)
	begin
		if tx_reset = '1' then
			size_error <= '0';
		elsif rising_edge(clk_i) then
			if start = '1' and legal = '0' then
				size_error <= '1';
			end if;
		end if;
	end process;

	-- 'busy' status bit, set when requested frame size is legal, reset
	-- when TX control register bit 7 written with '0' or frame sent.
	process (clk_i, tx_reset, tx_done)
	begin
		if tx_reset = '1' or tx_done = '1' then
			busy <= '0';
		elsif rising_edge(clk_i) then
			if start = '1' and legal = '1' then
				busy <= '1';
			end if;
		end if;
	end process;

	-- go_tx signal, essentially the 'busy' status bit in the clk_tx domain.
	process (clk_tx, tx_reset, tx_done)
	begin
		if tx_reset = '1' or tx_done = '1' then
			go_tx <= '0';
		elsif rising_edge(clk_tx) then
			go_tx <= busy;
		end if;
	end process;

	-- Generate reset pulse for the 'early_er' status bit
	process(clk_i, reset)	
	begin
		if reset = '1' then
			early_er_rst <= '0';
		elsif rising_edge(clk_i) then
			early_er_rst <= rx_reg_rd;
		end if;
	end process;

	-- 'early_er' status bit, set when there's an early receive error, reset
	-- when RX status register is read.
	process(clk_rx, reset, early_er_rst)
	begin
		if reset = '1' or early_er_rst = '1' then
			early_er <= '0';
		elsif rising_edge(clk_rx) then
			if early_er_i = '1' then
				early_er <= '1';
			end if;
		end if;
	end process;

---------------------------------------------------------------------
-- RX control
---------------------------------------------------------------------
	-- Find interframe gap. ifg_ok will be set when rxdv has been
	-- inactive for at least 24 cycles, and reset as soon as rxdv
	-- goes active.
	process (clk_rx, xreset)
		signal ifg_count	: std_logic_vector(4 downto 0);
	begin
		if xreset = '1' then
			ifg_count <= (others => '0');
			ifg_ok <= '0';
			wait_7 <= '0';
		elsif rising_edge(clk_rx) then
			if rxdv = '1' then
				ifg_ok <= '0';
				ifg_count <= (others => '0');
				wait_7 <= '0';		
			else
				if ifg_count = 23 then
					ifg_ok <= '1';
				else
				begin
					if ifg_count = 6 then
						wait_7 <= '1';
					end if;
					ifg_count <= ifg_count+1;
				end if;			
			end if;			
		end if;
	end process;

	-- Delay crc_ok to be able to check for alignment errors.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			crc_ok_delay <= '0';
		elsif rising_edge(clk_rx) then
			crc_ok_delay <= crc_ok;
		end if;
	end process;

	-- adr_ok determines if the incoming frame should be accepted.
	adr_ok <=	promiscuous or						-- Accept all frames in this mode
						(multicast and eq_mc) or	-- Multicast frames accepted in this mode
						eq_ff or									-- Broadcast frames always accepted
						eq_da;										-- Destined to own address always accepted

	-- Syncronize fifo flags to clk_rx domain.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			empty_sync <= '0';
			full_sync <= '0';
			sts_full_sync <= '0';
		elsif rising_edge(clk_rx) then
			empty_sync <= empty;
			full_sync <= full;
			sts_full_sync <= sts_full;
		end if;
	end process;

	-- RX control state machine.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			early_er_i 	<= '0';
			store_sts <= '0';
			add_byte <= '0';
			align_er <= '0';
			crc_er	<= '0';
			overrun <= '0';
			mii_er	<= '0';
			tip 	<= '0';
			clear_rx_logic <= '1';
			rx_state <= FIND_IFG;
		elsif rising_edge(clk_rx) then
			case rx_state is		
				----------------------------------------------------------
				when FIND_IFG =>		-- Look for a new frame after an interframe gap of 24 clk_rx cycles
					clear_rx_logic <= '0';	
					early_er_i 	<= '0';
					store_sts <= '0';
					add_byte <= '0';
					align_er <= '0';
					crc_er	<= '0';
					overrun <= '0';
					mii_er	<= '0';
					tip 	<= '0';				
					if rxdv = '1' and ifg_ok = '1' then
						rx_state <= FIND_SFD;		-- When a new frame starts after valid IFG, wait for SFD
						clear_rx_logic <= '1';
					end if;
				----------------------------------------------------------
				when FIND_SFD =>		-- Look for start of frame delimiter (SFD, "5D") 
					clear_rx_logic <= '0';	
					if rxdv = '0' or rxer = '1' then
						rx_state <= FIND_IFG;		-- Frame ended or receive error, find IFG again
						if rxer = '1' then	
							early_er_i <= '1';		-- If receive error, set EARLY ER flag
						end if;
					elsif eq_sfd = '1' then
						rx_state <= FIND_ADR;		-- SFD found, wait for destination address					
						if full_sync = '1' or sts_full_sync = '1' then
							rx_state <= FIND_IFG;	-- FIFO problem, find IFG again										
						end if;
					end if;
				----------------------------------------------------------
				when FIND_ADR =>		-- Wait for destination address to be received
					if rxdv = '0' or rxer = '1' then
						rx_state <= FIND_IFG;		-- Frame ended or receive error, find IFG again
						if rxer = '1' then	
							early_er_i <= '1';		-- If receive error, set EARLY ER flag
						end if;
						clear_rx_logic <= '1';
					elsif c_11 = '1' then			-- True when the whole address has been received
						if rx_go = '1' and adr_ok = '1' then
							rx_state <= RECEIVE;		-- RX on, address OK, start receive
							tip <= '1';							-- Transfer in progress
						else
							rx_state <= FIND_IFG;		-- RX not on or address not OK, find IFG again										
							clear_rx_logic <= '1';
						end if;					
					end if;					
				----------------------------------------------------------
				when RECEIVE =>
					if rxdv = '1' and full_sync = '1' then
						rx_state <= POST_FRAME;		-- RX fifo full, stop receiving and go post frame				
						overrun <= '1';
					--end of frame...
					elsif rxdv = '0' then				-- Frame ended
						if odd_byte = '1' then
							add_byte <= '1';				-- If nr of received bytes odd then add a byte
						end if;						
						if odd_nibb = '1' and crc_ok_delay = '0' then --CRC NOT OK
							align_er	<= '1';				-- If nr of nibbles odd and crc wrong then
							crc_er		<= '1';				-- report alignment error and crc error
						elsif odd_nibb = '0' and crc_ok = '0' then --CRC NOT OK
							crc_er		<= '1';				-- If crc wrong then report crc error
						end if;
						rx_state <= POST_FRAME;		-- Go post frame (store frame status in fifo)
					end if;	
					if rxer = '1' then
						mii_er <= '1';						-- If receive error, set error flag
					end if;
				----------------------------------------------------------
				when POST_FRAME =>	-- Store frame status in fifo once the whole frame is received
					add_byte <= '0';
					--wait until the very last byte have been read from RX_FIFO
					--before posting frame STS...
					--wait 7 CLK to make sure the RX_FIFO is empty, that gives 
					--the add_byte time to settle...
					--FRAME STS is only stored when the whole frame is downloaded to the GP1000
					if empty_sync = '1' and wait_7 = '1' then
						rx_state <= FIND_IFG;			-- Wait until RX fifo empty, plus 7 cycles to give
						store_sts <= '1';					-- add_byte time to settle, then wait for next frame
					end if;				
				----------------------------------------------------------
				when others => 
					rx_state <= FIND_IFG;
			end case;
		end if;
	end process;		
	start_rx_logic <= '1' when rxdv = '1' and (rx_state = FIND_ADR or rx_state = RECEIVE) else '0';
	-- clear_rx_logic <= '1' when rx_state = FIND_IFG or xreset = '1' else '0';

	-- Flipflop to enable DMA request. 
	process(clk_i, xreset)
	begin
		if xreset = '1' then
			req_en <= '0';
		elsif rising_edge(clk_i) then
			req_en <= '0';
			if rx_state = RECEIVE or rx_state = POST_FRAME then
				req_en <= '1';
			end if;
		end if;
	end process;

	-- Detect SFD in incoming data stream.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			rxd_reg <= (others => '0');
		elsif rising_edge(clk_rx) then
			rxd_reg <= rxd;
		end if;
	end process;
	eqsfd <= '1' when rxd_reg & rxd = x"5D" else '0';

---------------------------------------------------------------------
-- Address memory.
---------------------------------------------------------------------
	-- Write address memory one nibble at a time.
	process (clk_i, ilioa, reset)
	begin
		if reset = '1' or ilioa = '0' then
			w_adr <= (others => '0');
		elsif rising_edge(clk_i) then
			if rx_da_wr = '1' then
				adr_mem(conv_integer(w_adr)) <= idi(3 downto 0);
				w_adr <= w_adr + 1;
			end if;
		end if;
	end process;

	find_adr <= '1' when rx_state = FIND_ADR else '0';

	-- Read address memory one nibble at a time during the
	-- FIND_ADR state. The c_11 signal marks the end of this
	-- state.
	process (clk_rx, reset, find_adr)
	begin
		if reset = '1' or find_adr = '0' then
			count <= (others => '0');
		elsif rising_edge(clk_rx) then
			if count = 11 then
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	c_11 <= '1' when count = 11 else '0';
	adr_data <= adr_mem(conv_integer(count));

	-- Broadcast, multicast or own address?
	process (clk_rx, reset, find_adr)
	begin
		if reset = '1' or find_adr = '0' then
			eqff_all <= '1';
			eqmc_1st <= '0';
			eqda_all <= '1';
		elsif rising_edge(clk_rx) then
			if eqff_this = '0' then
				eqff_all <= '0';
			end if;
			if eqmc_this then
				eqmc_1st <= '1';
			end if;
			if eqda_this = '0' then
				eqda_all <= '0';
			end if;
		end if;
	end process;
	eqff_this <= '1' when rxd = x"F" else '0';
	eqmc_this <= '1' when count = "0000" and rxd(0) = '1' else '0';
	eqda_this <= '1' when rxd = adr_data else '0';
	eqff <= find_adr and eqff_all and eqff_this;   
	eqmc <= find_adr and (eqmc_1st or eqmc_this);
	eqda <= find_adr and eqda_all and eqda_this;   

---------------------------------------------------------------------
-- RX fifo.
---------------------------------------------------------------------
	-- Write counter and fifo write.
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_wctr <= (others => '0');
		elsif rising_edge(clk_rx) then
			if start_rx_logic = '1' then
				rx_fifo(conv_integer(rxf_wctr)) <= rxd;
				rxf_wctr <= rxf_wctr+1;
			elsif add_byte = '1' then
				rxf_wctr <= rxf_wctr+2;
			end if;
		end if;
	end process;
	
	-- Read counter and fifo read.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_rctr <= (others => '0');
		elsif rising_edge(clk_i) then
			if idack_rx = '0' then
				rxf_rctr <= rxf_rctr+1;
			end if;
		end if;
	end process;
	rxf_dout <= rx_fifo(conv_integer(rxf_rctr & '0')) & rx_fifo(conv_integer(rxf_rctr & '1'));

	-- Level counter and fifo flags.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_count			<= (others => '0');
			rxf_wctr2_i		<= '0';
			rxf_wctr2_i2	<= '0';
		elsif rising_edge(clk_i) then
			if (rxf_count_add xor rxf_count_sub) = '1' then 
				if rxf_count_add = '1' then
					rxf_count <= rxf_count + 1;
				else
					rxf_count <= rxf_count - 1;
				end if;
			end if;
			rxf_wctr2_i <= rxf_wctr(2);
			rxf_wctr2_i2 <= rxf_wctr2_i;
		end if;
	end process;
	rxf_count_add <= rxf_wctr2_i xor rxf_wctr2_i2;	-- Add to counter every 4:th nibble written (4-bit)
	rxf_count_sub <= not idack_rx and rxf_rctr(0);	-- Subtract from counter every 2:nd time fifo read (8-bit)
	full <= '1' when rxf_count(rxf_size) = '1' else '0';
	empty <= '1' when rxf_count = (others => '0') else '0';
	aempty <= '1' when rxf_count(rxf_size downto 1) = (others => '0') and rxf_count(0) = '1' else '0';

	-- DMA request logic.
	idreq_rx <= '1' when req_en = '0' else										-- No req when not enabled
							'1' when empty = '1' else											-- No req when fifo empty
							'1' when amepty = '1' and idack_rx = '0' else	-- No req when last byte already ack'ed
							'0';																					-- Otherwise, request

---------------------------------------------------------------------
-- Frame status fifo.
---------------------------------------------------------------------
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

---------------------------------------------------------------------
-- RX CRC.
---------------------------------------------------------------------
	-- XOR the input data with the top nibble of the current CRC.
	rxx <= (rxc(28) xor rxd(3)) & (rxc(29) xor rxd(2)) & (rxc(30) xor rxd(1)) & (rxc(31) xor rxd(0));

	-- Generate CRC.
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then  
			rxc <= (others => '1');
		elsif rising_edge(clk_rx) then
			if start_rx_logic = '1' then
				rxc <=	rxc(27) &
								rxc(26) &
								(rxc(25) xor rxx(0)) &
								(rxc(24) xor rxx(1)) &
								(rxc(23) xor rxx(2)) &
								(rxc(22) xor rxx(3) xor rxx(0)) &
								(rxc(21) xor rxx(1) xor rxx(0)) &
								(rxc(20) xor rxx(2) xor rxx(1)) &
								(rxc(19) xor rxx(3) xor rxx(2)) &
								(rxc(18) xor rxx(3)) &
								rxc(17) &
								rxc(16) &
								(rxc(15) xor rxx(0)) &             
								(rxc(14) xor rxx(1)) &
								(rxc(13) xor rxx(2)) &
								(rxc(12) xor rxx(3)) &
								(rxc(11) xor rxx(0)) &
								(rxc(10) xor rxx(1) xor rxx(0)) &
								(rxc(9) xor rxx(2) xor rxx(1) xor rxx(0)) &
								(rxc(8) xor rxx(3) xor rxx(2) xor rxx(1)) &
								(rxc(7) xor rxx(3) xor rxx(2) xor rxx(0)) &
								(rxc(6) xor rxx(3) xor rxx(1) xor rxx(0)) &
								(rxc(5) xor rxx(2) xor rxx(1)) &
								(rxc(4) xor rxx(3) xor rxx(2) xor rxx(0)) &
								(rxc(3) xor rxx(3) xor rxx(1) xor rxx(0)) &
								(rxc(2) xor rxx(2) xor rxx(1)) &
								(rxc(1) xor rxx(3) xor rxx(2) xor rxx(0)) &
								(rxc(0) xor rxx(3) xor rxx(1) xor rxx(0)) &
								(rxx(2) xor rxx(1) xor rxx(0)) &
								(rxx(3) xor rxx(2) xor rxx(1)) &
								(rxx(3) xor rxx(2)) &
								rxx(3);
			end if;
		end if;
	end process;

	-- Check generated CRC, should be OK when incoming CRC processed.
	crc_ok <= '1' when rxc = CRC_REMAINDER else '0';

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


	-- Write counter and fifo write.
	process (clk_tx, fifo_reset)
	begin
		if fifo_reset = '1' then
			txf_wctr <= (others => '0');
		elsif rising_edge(clk_tx) then
			if idack_tx = '0' then
				tx_fifo(conv_integer(txf_wctr & '0')) <= idi(7 downto 4);
				tx_fifo(conv_integer(txf_wctr & '1')) <= idi(3 downto 0);
				txf_wctr <= txf_wctr+1;
			elsif add_byte = '1' then
				rxf_wctr <= rxf_wctr+2;
			end if;
		end if;
	end process;

			if start_rx_logic = '1' then
	
	-- Read counter and fifo read.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_rctr <= (others => '0');
		elsif rising_edge(clk_i) then
			if idack_rx = '0' then
				rxf_rctr <= rxf_rctr+1;
			end if;
		end if;
	end process;
	txf_dout <= tx_fifo(conv_integer(rxf_rctr & '0')) & tx_fifo(conv_integer(rxf_rctr & '1'));

	-- Level counter and fifo flags.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rxf_count			<= (others => '0');
			rxf_wctr2_i		<= '0';
			rxf_wctr2_i2	<= '0';
		elsif rising_edge(clk_i) then
			if (rxf_count_add xor rxf_count_sub) = '1' then 
				if rxf_count_add = '1' then
					rxf_count <= rxf_count + 1;
				else
					rxf_count <= rxf_count - 1;
				end if;
			end if;
			rxf_wctr2_i <= rxf_wctr(2);
			rxf_wctr2_i2 <= rxf_wctr2_i;
		end if;
	end process;
	rxf_count_add <= rxf_wctr2_i xor rxf_wctr2_i2;	-- Add to counter every 4:th nibble written (4-bit)
	rxf_count_sub <= not idack_rx and rxf_rctr(0);	-- Subtract from counter every 2:nd time fifo read (8-bit)
	full <= '1' when rxf_count(rxf_size) = '1' else '0';
	empty <= '1' when rxf_count = (others => '0') else '0';
	aempty <= '1' when rxf_count(rxf_size downto 1) = (others => '0') and rxf_count(0) = '1' else '0';

	-- DMA request logic.
	idreq_rx <= '1' when req_en = '0' else										-- No req when not enabled
							'1' when empty = '1' else											-- No req when fifo empty
							'1' when amepty = '1' and idack_rx = '0' else	-- No req when last byte already ack'ed
							'0';																					-- Otherwise, request


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
----------------------------------------------------------
--components
	ETH_RX1: ETH_RX
		port map(
		--GP1000 interface
		clk_i				=> clk_i,
		INEXT				=> INEXT,
		idi		=> idi,
		ido		=> GP_DATA_O_RX,
		GP_DATA_EN	=> GP_DATA_EN_RX,
		rx_reg_sel		=> rx_reg_sel,
		rx_da_wr		=> rx_da_wr,
		rx_reg_wr		=> rx_reg_wr,
		rx_sts_sel=> rx_sts_sel, 
		ilioa		=> ilioa,
		DMA_ACK		=> idack_rx,
		DMA_REQ		=> idreq_rx,
		
		--PHY Interface
		rx_er		=> rxer,
		rx_dv		=> rxdv,
		rxd			=> rxd,
		RX_CLK		=> RX_CLK,
		
		--system reset
		reset		=> reset
		);	

	ETH_TX1: ETH_TX
		port map(
		--GP1000 interface
		idi		=> idi,
		ido		=> GP_DATA_O_TX,
		clk_i		=> clk_i,
		DMA_ACK		=> idack_tx,
		DMA_REQ		=> idreq_tx,
		dma_en		=> dma_en,
		
		--Register enable signals
		tx_reg_wr		=> tx_reg_wr,
		
		--PHY interface
		TX_CRS		=> crs,
		tx_col		=> col,
		tx_en		=> txen,
		tx_er		=> txer,
		txd			=> txd,
		TX_CLK		=> TX_CLK,
		
		fulldpx	=> fulldpx,
		--system reset
		reset		=> reset	
		);	

end architecture structure;
		
