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
-- Title      : Ethernet receiver
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
--	Look over asynchronous reset policy.
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-12-15		1.0				CB			Created
-- 2005-01-30		1.1				CB			Changed register layout: moved 'reset' to bit
--																7, added 'fast' on bit 6, collapsed 'go',
--																'multicast' and 'promiscuous' to bits 5,4.
--																Changed minimum inteframe gap to 8 cycles.
--																Added interrupt request output.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity eth_rx is
	generic (
		RX_CTL_ADR	: std_logic_vector(7 downto 0) := x"20"; --acts as CTL/STS
		RX_DA_ADR		: std_logic_vector(7 downto 0) := x"21";
		RX_STS_ADR	: std_logic_vector(7 downto 0) := x"22";		
		RX_SIZE			: natural := 3;		-- 2-log of RX fifo size in nibbles		
		STS_SIZE		: natural := 2);	-- 2-log of STS fifo size in 16-bit statuses		
	port (
		-- Processor interface
		clk_i		: in	std_logic;
		ilioa		: in	std_logic;
		ildout	: in	std_logic;
		inext		: in	std_logic;
		idack		: in	std_logic;
		idreq		: out	std_logic;
		idi			: in	std_logic_vector(7 downto 0);
		ido			: out	std_logic_vector(7 downto 0);
		iden		: out	std_logic;
		irq			: out	std_logic;
		-- PHY Interface
		clk_rx	: in	std_logic;
		clken		: in	std_logic;
		rxdv		: in	std_logic;	
		rxer		: in	std_logic;	
		rxd			: in	std_logic_vector(3 downto 0);
		-- Control register output
		fast		: out	std_logic;	
		tstamp	: out	std_logic;	
		-- System reset
		rst_en	: in	std_logic);
end entity eth_rx;

architecture structure of eth_rx is
-- Address decode & ido mux                                                 --
	signal rx_reg_sel		: std_logic;
	signal rx_reg_wr		: std_logic;
	signal rx_reg_rd		: std_logic;
	signal rx_da_sel		: std_logic;
	signal rx_sts_sel		: std_logic;
	signal rx_sts_rd		: std_logic;

-- Control/status registers                                                 --
	signal rx_reg				: std_logic_vector(7 downto 0);
	signal rx_go				: std_logic;
	signal rx_reset			: std_logic;
	signal xreset				: std_logic;
	signal promiscuous	: std_logic;
	signal multicast		: std_logic;
	signal early_er			: std_logic;

-- RX control
	type rx_states is (FIND_IFG, FIND_SFD, FIND_ADR, RECEIVE, POST_FRAME);
	signal rx_state				: rx_states;
	signal ifg_count			: std_logic_vector(2 downto 0);
	signal ifg_ok					: std_logic;
	signal crc_ok_delay		: std_logic;
	signal adr_ok					: std_logic;
	signal rx_empty_sync	: std_logic;
	signal rx_full_sync		: std_logic;
	signal sts_full_sync	: std_logic;
	signal store_sts			: std_logic;	-- Active high STS fifo write enable
	signal add_byte				: std_logic;	-- Active high
	signal align_er				: std_logic;	-- Alignment error (odd nibbles)
	signal crc_er					: std_logic;	-- CRC error in incoming frame
	signal overrun				: std_logic;	-- RX fifo full during receive
	signal mii_er					: std_logic;	-- Error signal from PHY
	signal clear_rx_logic	: std_logic;	-- Active high RX fifo reset
	signal start_rx_logic	: std_logic;	-- Active high enable for CRC, nibble ctr
	signal start_rx_fifo	: std_logic;	-- Active high RX fifo write enable
	signal rx_find_adr		: std_logic;
	signal req_en					: std_logic;
	signal rxd_reg				: std_logic;
	signal eq_sfd					: std_logic;
	signal tip						: std_logic;
	signal early_er_set		: std_logic;

-- Address memory.
	type adr_array is array (11 downto 0) of std_logic_vector(3 downto 0);
	signal adr_mem			: adr_array;
	signal adr_data			: std_logic_vector(3 downto 0);
	signal adr_rctr			: std_logic_vector(3 downto 0);
	signal eqff_all			: std_logic;
	signal eqmc_1st			: std_logic;
	signal eqda_all			: std_logic;
	signal eqff_this		: std_logic;
	signal eqmc_this		: std_logic;
	signal eqda_this		: std_logic;
	signal eq_ff				: std_logic;
	signal eq_mc				: std_logic;
	signal eq_da				: std_logic;

-- RX fifo.
	type rx_fifo_type is array(2**RX_SIZE - 1 downto 0) of std_logic_vector(3 downto 0);
	signal rx_fifo			: rx_fifo_type;
	signal rx_dout			: std_logic_vector(7 downto 0);
	signal rx_wctr			: std_logic_vector(RX_SIZE-1 downto 0);	-- Counts nibbles
	signal rx_rctr			: std_logic_vector(RX_SIZE-2 downto 0);	-- Counts bytes
	signal rx_count			: integer range 0 to 2**RX_SIZE - 1;		-- Counts bytes
	signal rx_wctr1_i		: std_logic;
	signal rx_wctr1_i2	: std_logic;
	signal rx_full			: std_logic;
	signal rx_empty			: std_logic;
	signal rx_aempty		: std_logic;

-- Frame status fifo.
	type sts_fifo_type is array(2**(STS_SIZE+1) - 1 downto 0) of std_logic_vector(7 downto 0);
	signal sts_fifo			: sts_fifo_type;
	signal sts_dout			: std_logic_vector(7 downto 0);
	signal sts_wctr			: std_logic_vector(STS_SIZE-1 downto 0);	-- Counts statuses (16-bit)
	signal sts_rctr			: std_logic_vector(STS_SIZE downto 0);		-- Counts bytes
	signal sts_count		: integer range 0 to 2**(STS_SIZE+2) - 1;	-- Counts bytes
	signal sts_wctr0_i	: std_logic;
	signal sts_wctr0_i2	: std_logic;
	signal sts_full			: std_logic;
	signal sts_empty		: std_logic;
	signal frame_sts		: std_logic_vector(15 downto 0);	-- Frame status entry 
	signal nibb_count		: std_logic_vector(11 downto 0);	-- Frame length in nibbles 
	signal illegal			: std_logic;	-- Illegal frame size, too large (2048 bytes)
	signal odd_nibb			: std_logic;
	signal odd_byte			: std_logic;

-- RX CRC.
	constant CRC_REMAINDER : std_logic_vector(31 DOWNTO 0) := x"3E02BBED";
	signal crc					: std_logic_vector(31 downto 0);
	signal crc_ok				: std_logic;

begin
----------------------------------------------------------------
-- Address decode & ido mux.
----------------------------------------------------------------
	-- This process decodes I/O addresses
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			rx_reg_sel	<= '0';
			rx_da_sel		<= '0';
			rx_sts_sel	<= '0';
		elsif rising_edge(clk_i) then
			if ilioa = '0' then
				rx_reg_sel	<= '0';
				rx_da_sel		<= '0';
				rx_sts_sel	<= '0';
				if idi = RX_CTL_ADR then
					rx_reg_sel <= '1';
				end if;
				if idi = RX_DA_ADR then
					rx_da_sel <= '1';
				end if;
				if idi = RX_STS_ADR then
					rx_sts_sel <= '1';
				end if;
			end if;
		end if;
	end process;
	rx_reg_wr <= '1' when rx_reg_sel = '1' and ildout = '0' else '0';
	rx_reg_rd	<= '1' when rx_reg_sel = '1' and inext = '0' else '0';
	rx_sts_rd	<= '1' when rx_sts_sel = '1' and inext = '0' else '0';

	ido		<=	rx_dout when idack = '0' else
						rx_reg when rx_reg_sel = '1' else
						sts_dout;

	iden	<= (not inext and (rx_reg_sel or rx_sts_sel)) or not idack; 

----------------------------------------------------------------
-- Control/status registers.
----------------------------------------------------------------
	-- RX control/status register.
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			rx_reg(7 downto 4) <= (others => '0');		
		elsif rising_edge(clk_i) then
			if rx_reg_wr = '1' then
				rx_reg(7 downto 4) <= idi(7 downto 4);
			end if;
		end if;
	end process;
	rx_reset		<= rx_reg(7);
	fast				<= rx_reg(6);
	rx_go				<= rx_reg(5) or rx_reg(4);
	multicast		<= rx_reg(5);
	promiscuous	<= rx_reg(5) and rx_reg(4);
	rx_reg(3)		<= not sts_empty;
	rx_reg(2)		<= sts_full;
	rx_reg(1)		<= tip;
	rx_reg(0)		<= early_er;
	
	xreset	<= rx_reset or not rst_en;
	irq			<= not sts_empty; 								

	-- 'early_er' status bit, set when there's an early receive error, reset
	-- when RX status register is read.
	process(clk_i, rst_en, early_er_set)
	begin
		if rst_en = '0' then
			early_er <= '0';
		elsif early_er_set = '1' then
			early_er <= '1';
		elsif rising_edge(clk_i) then
			if rx_reg_rd = '1' then
				early_er <= '0';
			end if;
		end if;
	end process;

---------------------------------------------------------------------
-- Address memory.
---------------------------------------------------------------------
	-- Write address memory one byte at a time.
	process (clk_i, rst_en)
		variable adr_wctr : std_logic_vector(2 downto 0);
	begin
		if rst_en = '0' then
			adr_wctr := (others => '0');
		elsif rising_edge(clk_i) then
			if rx_da_sel = '0' then
				adr_wctr := (others => '0');
			elsif ildout = '0' then
				adr_mem(conv_integer(adr_wctr & '0')) <= idi(3 downto 0);
				adr_mem(conv_integer(adr_wctr & '1')) <= idi(7 downto 4);
				adr_wctr := adr_wctr + 1;
			end if;
		end if;
	end process;

	-- Read address memory one nibble at a time during the
	-- FIND_ADR state. adr_rctr = 11 marks the end of this
	-- state.
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			adr_rctr <= (others => '0');
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				if rx_find_adr = '1' then
					adr_rctr <= adr_rctr + 1;
					if adr_rctr = 11 then
						adr_rctr <= (others => '0');
					end if;
				end if;
			end if;
		end if;
	end process;
	adr_data <= adr_mem(conv_integer(adr_rctr));

	-- Broadcast, multicast or own address?
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			eqff_all <= '1';
			eqmc_1st <= '0';
			eqda_all <= '1';
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				if rx_find_adr = '1' then
					if eqff_this = '0' then
						eqff_all <= '0';
					end if;
					if eqmc_this = '1' then
						eqmc_1st <= '1';
					end if;
					if eqda_this = '0' then
						eqda_all <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	eqff_this <= '1' when rxd = x"F" else '0';
	eqmc_this <= '1' when adr_rctr = "0000" and rxd(0) = '1' else '0';
	eqda_this <= '1' when rxd = adr_data else '0';
	eq_ff <= eqff_all and eqff_this;   
	eq_mc <= eqmc_1st or eqmc_this;
	eq_da <= eqda_all and eqda_this;   

---------------------------------------------------------------------
-- RX control.
---------------------------------------------------------------------
	-- Find interframe gap. ifg_ok will be set when rxdv has been
	-- inactive for at least 7 cycles, and reset as soon as rxdv
	-- goes active.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			ifg_count <= (others => '0');
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				if rxdv = '1' then
					ifg_count <= (others => '0');
				elsif ifg_ok = '0' then
					ifg_count <= ifg_count + 1;
				end if;			
			end if;			
		end if;
	end process;
	ifg_ok <= '1' when ifg_count = 7 else '0';

	-- Delay crc_ok to be able to check for alignment errors.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			crc_ok_delay <= '0';
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				crc_ok_delay <= crc_ok;
			end if;
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
			rx_empty_sync	<= '0';
			rx_full_sync	<= '0';
			sts_full_sync	<= '0';
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				rx_empty_sync	<= rx_empty;
				rx_full_sync	<= rx_full;
				sts_full_sync	<= sts_full;
			end if;
		end if;
	end process;

	-- RX control state machine.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			early_er_set 	<= '0';
			store_sts <= '0';
			add_byte <= '0';
			align_er <= '0';
			crc_er	<= '0';
			overrun <= '0';
			mii_er	<= '0';
			tip 	<= '0';
			clear_rx_logic <= '1';
			rx_state <= FIND_IFG;
			tstamp <= '0';
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				tstamp <= '0';
				case rx_state is		
					----------------------------------------------------------
					when FIND_IFG =>		-- Look for a new frame after an interframe gap of 8 clk_rx cycles
						clear_rx_logic <= '1';	
						early_er_set 	<= '0';
						store_sts <= '0';
						add_byte <= '0';
						align_er <= '0';
						crc_er	<= '0';
						overrun <= '0';
						mii_er	<= '0';
						tip 	<= '0';				
						if rxdv = '1' and ifg_ok = '1' then
							rx_state <= FIND_SFD;		-- When a new frame starts after valid IFG, wait for SFD
						end if;
					----------------------------------------------------------
					when FIND_SFD =>		-- Look for start of frame delimiter (SFD, "5D") 
						if rxdv = '0' or rxer = '1' then
							rx_state <= FIND_IFG;		-- Frame ended or receive error, find IFG again
							if rxer = '1' then	
								early_er_set <= '1';	-- If receive error, set EARLY ER flag
							end if;
						elsif eq_sfd = '1' then
							tstamp <= '1';
							rx_state <= FIND_ADR;		-- SFD found, wait for destination address					
							if sts_full_sync = '1' then
								rx_state <= FIND_IFG;	-- FIFO problem, find IFG again										
							end if;
							clear_rx_logic <= '0';	
						end if;
					----------------------------------------------------------
					when FIND_ADR =>		-- Wait for destination address to be received
						if rxdv = '0' then					-- Frame ended
							rx_state <= FIND_IFG;			-- Find IFG again if nothing received yet										
							if nibb_count /= 0 then		-- If something received, we must post frame
								rx_state <= POST_FRAME;	-- Go post frame (store frame status in fifo)
								if odd_byte = '1' then
									add_byte <= '1';			-- If nr of received bytes odd then add a byte
								end if;						
							end if;						
						elsif adr_rctr = 11 then		-- True when the whole address has been received
							if rx_go = '1' and adr_ok = '1' then
								rx_state <= RECEIVE;		-- RX on, address OK, start receive
								tip <= '1';							-- Transfer in progress
							else
								rx_state <= FIND_IFG;		-- RX not on or address not OK, find IFG again										
							end if;					
						end if;					
						if rxer = '1' then
							mii_er <= '1';						-- If receive error, set error flag
						end if;
					----------------------------------------------------------
					when RECEIVE =>
						if rxdv = '0' then					-- Frame ended
							rx_state <= POST_FRAME;		-- Go post frame (store frame status in fifo)
							if odd_byte = '1' then
								add_byte <= '1';				-- If nr of received bytes odd then add a byte
							end if;						
							if odd_nibb = '1' and crc_ok_delay = '0' then --CRC NOT OK
								align_er	<= '1';				-- If nr of nibbles odd and crc wrong then
								crc_er		<= '1';				-- report alignment error and crc error
							elsif odd_nibb = '0' and crc_ok = '0' then --CRC NOT OK
								crc_er		<= '1';				-- If crc wrong then report crc error
							end if;
						elsif rx_full_sync = '1' then
							rx_state <= POST_FRAME;		-- RX fifo full, stop receiving and go post frame				
							overrun <= '1';
						elsif illegal = '1' then
							rx_state <= POST_FRAME;		-- Frame too long, exceeds capacity of nibble counter				
						end if;	
						if rxer = '1' then
							mii_er <= '1';						-- If receive error, set error flag
						end if;
					----------------------------------------------------------
					when POST_FRAME =>	-- Store frame status in fifo once the whole frame is received
						add_byte <= '0';
						--wait until the very last byte have been read from RX_FIFO
						--before posting frame STS...
						--wait until ifg_ok to make sure the RX_FIFO is empty, that gives 
						--the add_byte time to settle...
						--FRAME STS is only stored when the whole frame hass left the fifo.
						if rx_empty_sync = '1' and ifg_ok = '1' then
							rx_state <= FIND_IFG;			-- Wait until RX fifo empty, plus some cycles to give
							store_sts <= '1';					-- add_byte time to settle, then wait for next frame
						end if;				
					----------------------------------------------------------
					when others => 
						rx_state <= FIND_IFG;
				end case;
			end if;
		end if;
	end process;		
	rx_find_adr <= '1' when rx_state = FIND_ADR else '0';
	start_rx_logic	<= '0' when rxdv = '0' else
										 '1' when rx_state = RECEIVE or rx_state = FIND_ADR else
										 '0';
	start_rx_fifo		<= '0' when rxdv = '0' else
										 '1' when rx_state = RECEIVE else
										 '0' when rx_state /= FIND_ADR else
										 '1' when promiscuous = '1' or (multicast = '1' and eq_mc = '1') else
										 '0';

	-- Flipflop to enable DMA request. 
	process(clk_i, xreset)
	begin
		if xreset = '1' then
			req_en <= '0';
		elsif rising_edge(clk_i) then
			req_en <= '0';
			if rx_state = FIND_ADR or rx_state = RECEIVE or rx_state = POST_FRAME then
				req_en <= '1';
			end if;
		end if;
	end process;

	-- Detect SFD in incoming data stream.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			rxd_reg <= '0';
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				rxd_reg <= '0';
				if rxd = x"5" then
					rxd_reg <= '1';
				end if;
			end if;
		end if;
	end process;
	eq_sfd <= '1' when rxd_reg = '1' and rxd = x"D" else '0';

---------------------------------------------------------------------
-- RX fifo.
---------------------------------------------------------------------
	-- Write counter and fifo write.
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rx_wctr <= (others => '0');
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				if start_rx_fifo = '1' then		-- Write one nibble 
					rx_fifo(conv_integer(rx_wctr)) <= rxd;
					rx_wctr <= rx_wctr + 1;
				elsif add_byte = '1' then			-- Advance ctr one byte
					rx_wctr <= rx_wctr + 2;
				end if;
			end if;
		end if;
	end process;
	
	-- Read counter and fifo read.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rx_rctr <= (others => '0');
		elsif rising_edge(clk_i) then
			if idack = '0' then						-- Read one byte
				rx_rctr <= rx_rctr + 1;			
			end if;
		end if;
	end process;
	rx_dout <= rx_fifo(conv_integer(rx_rctr & '1')) & rx_fifo(conv_integer(rx_rctr & '0'));

	-- Level counter and fifo flags.
	process (clk_i, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			rx_count		<= 0;
			rx_wctr1_i	<= '0';
			rx_wctr1_i2	<= '0';
		elsif rising_edge(clk_i) then
			if ((rx_wctr1_i xor rx_wctr1_i2) xnor idack) = '1' then 
				if idack = '1' then
					rx_count <= rx_count + 1;	-- Add to counter on every 2:nd nibble written
				else
					rx_count <= rx_count - 1;	-- Subtract from counter every time fifo read
				end if;
			end if;
			rx_wctr1_i	<= rx_wctr(1);		-- Synchronize bit 1 of rx_wctr to clk_i, because
			rx_wctr1_i2 <= rx_wctr1_i;		-- fifo is written twice for every byte
		end if;
	end process;
	rx_full		<= '1' when rx_count >= 2**(RX_SIZE-1) else '0';
	rx_empty	<= '1' when rx_count = 0 else '0';
	rx_aempty	<= '1' when rx_count = 1 else '0';

	-- DMA request logic.
	idreq <= '1' when req_en = '0' else											-- No req when not enabled
					 '1' when rx_empty = '1' else										-- No req when fifo empty
					 '1' when rx_aempty = '1' and idack = '0' else	-- No req when last byte already ack'ed
					 '0';																						-- Otherwise, request

---------------------------------------------------------------------
-- Frame status fifo.
---------------------------------------------------------------------
	-- Write counter and fifo write.
	process (clk_rx, xreset)
	begin
		if xreset = '1' then
			sts_wctr <= (others => '0');
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				if store_sts = '1' then
					sts_fifo(conv_integer(sts_wctr & '0')) <= frame_sts(15 downto 8);
					sts_fifo(conv_integer(sts_wctr & '1')) <= frame_sts(7 downto 0);
					sts_wctr <= sts_wctr + 1;
				end if;
			end if;
		end if;
	end process;
	frame_sts(15) <= mii_er;		-- Error signal from PHY
	frame_sts(14 downto 13) <=	"01" when align_er = '1' else	-- Alignment error (odd nibbles)
															"10" when crc_er = '1' else		-- CRC error in incoming frame
															"11" when overrun = '1' else	-- RX fifo full during receive
															"00";													-- No error
	frame_sts(12) <= '1' when promiscuous = '1' or (multicast = '1' and eqmc_1st = '1') else '0';
	frame_sts(11) <= eqff_all;
	frame_sts(10 downto 0) <= nibb_count(11 downto 1);	-- Frame length in bytes 

	-- Read counter and fifo read.
	process (clk_i, xreset)
	begin
		if xreset = '1' then
			sts_rctr <= (others => '0');
		elsif rising_edge(clk_i) then
			if rx_sts_rd = '1' then
				sts_rctr <= sts_rctr + 1;
			end if;
		end if;
	end process;
	sts_dout <= sts_fifo(conv_integer(sts_rctr));

	-- Level counter and fifo flags.
	process (clk_i, xreset)
	begin
		if xreset = '1' then
			sts_count			<= 0;
			sts_wctr0_i		<= '0';
			sts_wctr0_i2	<= '0';
		elsif rising_edge(clk_i) then
			if ((sts_wctr0_i xor sts_wctr0_i2) xor (rx_sts_rd and sts_rctr(0))) = '1' then 
				if (sts_wctr0_i xor sts_wctr0_i2) = '1' then
					sts_count <= sts_count + 1;	-- Add to counter each time frame status written
				else
					sts_count <= sts_count - 1;	-- Subtract from counter every 2:nd time fifo read
				end if;
			end if;
			sts_wctr0_i		<= sts_wctr(0);
			sts_wctr0_i2	<= sts_wctr0_i;
		end if;
	end process;
	sts_full	<= '1' when sts_count >= 2**(STS_SIZE+1) else '0';
	sts_empty	<= '1' when sts_count = 0 else '0';

	-- Nibble counter, determines size of incoming frame
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then
			nibb_count <= (others => '0');
		elsif rising_edge(clk_rx) then
			if clken = '1' then
				if start_rx_fifo = '1' and illegal = '0' then
					nibb_count <= nibb_count + 1;
				end if;
			end if;
		end if;
	end process;
	odd_nibb <= nibb_count(0);
	odd_byte <= nibb_count(1);
	illegal	<=	'1' when nibb_count = x"FFF" else
							'0';

----------------------------------------------------------------
-- Instantiation of RX CRC.
----------------------------------------------------------------
  eth_crc1 : entity work.eth_crc
		port map (
			clk			=> clk_rx,
			clken		=> clken,
			rst			=> clear_rx_logic,
			enable	=> start_rx_logic,
			data		=> rxd,
			crc			=> crc);	

	-- Check generated CRC, should be OK when incoming CRC processed.
	crc_ok <= '1' when crc = CRC_REMAINDER else '0';

end architecture structure;
		
