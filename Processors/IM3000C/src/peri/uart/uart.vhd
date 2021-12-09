-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                                    IMSYS AB,  2000        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   AB, Sweden.                                                             --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys AB or in accordance with the terms and            --
--   conditions stipulated in the agreement/contract under which the         --
--   document(s) have been supplied.                                         --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart.vhd
-- Author     : Christian Blixt
-- Company    : Imsys AB
-- Date       : 2002/06/17
-- Platform   : Windows 2000
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author                  Description
-- 2002/06/17  1.0      Christian Blixt         Created
-- 2003/04/30  1.1			Christian Blixt					Added the uart_en port.
-- 2003/11/28  1.2			Christian Blixt					Improved break handling by
--																							adding the rx_wait flipflop.
-- 2004/08/20  1.3			Christian Blixt					Made receiver reject short
--																							start bits. Made the tx parity
--																							ignore the unused data bit on
--																							7-bit characters.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.gp_lib.all;

entity uart is
	generic (
		uart_reg_address				: std_logic_vector(7 downto 0) := x"28";
		uart_prescaler_address	: std_logic_vector(7 downto 0) := x"29";
		uart_flag_address				: std_logic_vector(7 downto 0) := x"2A";
		uart_fx_address					: std_logic_vector(7 downto 0) := x"2B");
	port (
		-- Clock and reset signals
		rst_en		: in	std_logic;  -- Global asynchronous reset
		clk_i			: in	std_logic;  -- Interface clock 
		clk_u			: in	std_logic;  -- Uart clock, 14.7456 MHz 
		clk_u_ce	: in	std_logic;	-- Prescaler clock enable
		-- I/O interface
		idi				: in	std_logic_vector(7 downto 0);
		ido				: out	std_logic_vector(7 downto 0);
		iden			: out	std_logic;
		ilioa			: in	std_logic;
		ildout		: in	std_logic;
		inext			: in	std_logic;
		-- Status outputs
		uart_en		: out	std_logic;	-- UART enabled (active high)
		irq				: out	std_logic;	-- Interrupt request (active high)
		-- RS232 interface
		rx				: in	std_logic;  -- RS232 Recieve Data
		tx				: out	std_logic;	-- RS232 Transmit Data
		cts				: in	std_logic;  -- RS232 Clear To Send
		rts				: out	std_logic); -- RS232 Request To Send
end;

architecture rtl of uart is
	-- Address decode
	signal ctrl_sel				: std_logic;	-- Control reg selected
	signal baud_sel				: std_logic;	-- Baudrate register selected
	signal flag_sel				: std_logic;	-- Flag register selected
	signal data_sel				: std_logic;	-- Data register selected
	signal ctrl_wr				: std_logic;	-- Control reg write
	signal baud_wr				: std_logic;	-- Baudrate register write
	signal flag_wr				: std_logic;	-- Flag register write
	signal data_wr				: std_logic;	-- Transmit fifo write (from processor)
	signal data_rd				: std_logic;	-- Receive fifo read (from processor)
	-- Control register
	signal ctrl_reg				: std_logic_vector(6 downto 0);	-- Control register
	signal ctrl_size			: std_logic;										-- Size control bit
	signal ctrl_stop			: std_logic;										-- Stop bits control bit
	signal ctrl_prty			: std_logic_vector(1 downto 0);	-- Parity control bits
	signal ctrl_enable		: std_logic;							-- UART enabled
	signal ctrl_break			: std_logic;							-- Break on
	signal ctrl_irda			: std_logic;							-- IrDA mode on
	signal char_len				: integer range 8 to 11;	-- Total length of character
	-- Baudrate register and generator 
	signal baud_reg				: std_logic_vector(3 downto 0);	-- Baudrate register
	signal div24_count		: integer range 0 to 23;	-- Low baudrate prescaler ctr
	signal div24_ce				: std_logic;							-- Low baudrate prescaler out
	signal baud_count			: integer range 0 to 127;	-- Baudrate generator ctr
	signal baud_ce				: std_logic;							-- Baudrate generator out
	-- Interrupt mask register & flag register
	signal irqen_reg			: std_logic_vector(3 downto 0);	-- Interrupt mask reg
	signal dcts_irq				: std_logic;							-- Delta-CTS interrupt
	signal rx_irq					: std_logic;							-- Receive interrupt
	signal tx_irq					: std_logic;							-- Transmit interrupt
	signal err_irq				: std_logic;							-- Error interrupt
	signal par_err				: std_logic;							-- Parity error flag
	signal ovr_err				: std_logic;							-- Overrun error flag
	signal frm_err				: std_logic;							-- Framing error flag
	signal dcts						: std_logic;							-- Delta-CTS flag
	signal cts_1					: std_logic;							-- For synchronizing of CTS line
	signal cts_2					: std_logic;							-- For change detect of CTS line
	signal flg_prio				: std_logic_vector(1 downto 0);	-- Prio encoded flags
	signal flags					: std_logic_vector(7 downto 0);	-- Flag register
	-- Transmit shift register
	signal tx_reg					: std_logic_vector(9 downto 0);	-- Transmit shift reg
	signal tx_baud_count	: std_logic_vector(3 downto 0);	-- TX baud oversamping
	signal tx_bit_count		: integer range 0 to 11;				-- TX bit counter
	signal tx_busy				: std_logic;	-- Transmit shift register busy
	-- Transmit fifo
	signal tx_ffout				: std_logic_vector(7 downto 0);	-- Transmit fifo
	signal tx_ffe					: std_logic;	-- Transmit fifo empty	
	signal tx_ffrd				: std_logic;	-- Transmit fifo read
	signal tx_ffpar				: std_logic;	-- Parity from transmit fifo
	-- Receive shift register
	signal rx_reg					: std_logic_vector(9 downto 0);	-- Receive shift reg
	signal rx_baud_count	: std_logic_vector(3 downto 0);	-- RX baud oversamping
	signal rx_bit_count		: integer range 0 to 11;				-- RX bit counter
	signal rx_counting		: std_logic;	-- Receiver counting
	signal rx_busy				: std_logic;	-- Receive shift register busy
	signal rx_new					: std_logic;	-- New data in receive shift register
	signal rx_1						: std_logic;	-- For synchronizing of RX line
	signal rx_2						: std_logic;	-- For IrDA pulse stretching of RX line
	signal rx_in					: std_logic;	-- RX line synchronized and stretched
	signal rx_ovr					: std_logic;	-- Overrun error detection
	signal rx_frm					: std_logic;	-- Framing error detection
	signal rx_wait				: std_logic;	-- Framing error wait flipflop
	-- Receive fifo
	signal rx_ffout				: std_logic_vector(7 downto 0);	-- Receive fifo
	signal rx_fff					: std_logic;	-- Receive fifo full
	signal rx_ffwr				: std_logic;	-- Receive fifo write
	signal rx_fferr				: std_logic;	-- Parity error from receive fifo
	
begin
	------------------------------------------------------------------------------
	-- Address decode & ido mux                                                 --
	------------------------------------------------------------------------------
	-- This process decodes I/O addresses
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			ctrl_sel	<= '0';
			baud_sel	<= '0';
			flag_sel	<= '0';
			data_sel	<= '0';
		elsif rising_edge(clk_i) then
			if ilioa = '0' then
				ctrl_sel	<= '0';
				baud_sel	<= '0';
				flag_sel	<= '0';
				data_sel	<= '0';
				if idi = uart_reg_address then
					ctrl_sel <= '1';
				end if;
				if idi = uart_prescaler_address then
					baud_sel <= '1';
				end if;
				if idi = uart_flag_address then
					flag_sel <= '1';
				end if;
				if idi = uart_fx_address then
					data_sel <= '1';
				end if;
			end if;
		end if;
	end process;
	ctrl_wr <= '1' when ctrl_sel = '1' and ildout = '0' else '0';
	baud_wr <= '1' when baud_sel = '1' and ildout = '0' else '0';
	flag_wr <= '1' when flag_sel = '1' and ildout = '0' else '0';
	data_wr <= '1' when data_sel = '1' and ildout = '0' else '0';
	data_rd <= '1' when data_sel = '1' and inext = '0' else '0';

	ido <= cts_1 & ctrl_reg when ctrl_sel = '1' else
				 irqen_reg & baud_reg when baud_sel = '1' else
				 flags when flag_sel = '1' else
				 rx_ffout;
		
	iden <= not inext and (ctrl_sel or baud_sel or flag_sel or data_sel); 

	------------------------------------------------------------------------------
	-- Control register & character size                                        --
	------------------------------------------------------------------------------
	-- Control register.
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			ctrl_reg <= (others => '0');
		elsif rising_edge(clk_i) then
			if ctrl_wr = '1' then
				ctrl_reg <= idi(6 downto 0);
			end if;
		end if;
	end process;
	
	rts					<= ctrl_reg(6); 
	ctrl_enable	<= ctrl_reg(5) or ctrl_reg(4);
	ctrl_irda		<= ctrl_reg(5) and not ctrl_reg(4);
	ctrl_break	<= ctrl_reg(5) and ctrl_reg(4);
	ctrl_size		<= ctrl_reg(3);
	ctrl_stop		<= ctrl_reg(2);
	ctrl_prty		<= ctrl_reg(1 downto 0);
	uart_en			<= ctrl_enable;			

	-- Character size, 8-11 bits.
	process (ctrl_size, ctrl_stop, ctrl_prty)
	begin
		if ctrl_size = '0' xor ctrl_stop = '1' xor ctrl_prty /= "00" then
			if ctrl_size = '0' and ctrl_stop = '1' and ctrl_prty /= "00" then
				char_len <= 11;
			else
				char_len <= 9;
			end if;
		else
			if ctrl_size = '0' or ctrl_stop = '1' or ctrl_prty /= "00" then
				char_len <= 10;
			else
				char_len <= 8;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------------
	-- Baudrate register and generator                                          --
	------------------------------------------------------------------------------
	-- Baudrate register.
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			baud_reg <= (others => '0');
		elsif rising_edge(clk_i) then
			if baud_wr = '1' then
				baud_reg <= idi(3 downto 0);
			end if;
		end if;
	end process;

	-- Low baudrate prescaler. Divides incoming prescaler
	-- output by 24 if bit 3 of the baudrate register is zero.
	process (clk_u, rst_en)
	begin
		if rst_en = '0' then
			div24_count <= 0;
		elsif rising_edge(clk_u) then
			if baud_reg(3) = '1' then
				div24_count <= 0;
			elsif clk_u_ce = '1' then
				if div24_count = 0 then
					div24_count <= 23;
				else
					div24_count <= div24_count - 1;
				end if;
			end if;
		end if;
	end process;
	div24_ce <= '1' when clk_u_ce = '1' and div24_count = 0 else '0';

	-- Baudrate generator. Divides the low baudrate prescaler
	-- output by 2**baud_reg(2 downto 0).
	process (clk_u, rst_en)
	begin
		if rst_en = '0' then
			baud_count <= 0;
		elsif rising_edge(clk_u) then
			if div24_ce = '1' then
				if baud_count = 0 then
					baud_count <= (2**conv_integer(baud_reg(2 downto 0))) - 1;
				else
					baud_count <= baud_count - 1;
				end if;
			end if;
		end if;
	end process;
	baud_ce <= '1' when div24_ce = '1' and baud_count = 0 else '0';

	------------------------------------------------------------------------------
	-- Interrupt mask register & flag register & priority encode                --
	------------------------------------------------------------------------------
	-- Interrupt mask register.
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			irqen_reg <= (others => '0');
		elsif rising_edge(clk_i) then
			if baud_wr = '1' then
				irqen_reg <= idi(7 downto 4);
			end if;
		end if;
	end process;
	
	-- Interrupt sources are masked with their enable bits
	-- before they are gated together as an interrupt output.
	dcts_irq <= dcts and irqen_reg(3);
	rx_irq <= rx_fff and irqen_reg(2);
	tx_irq <= tx_ffe and irqen_reg(1);
	err_irq <= (frm_err or ovr_err or par_err) and irqen_reg(0);
	irq <= (dcts_irq or rx_irq or tx_irq or err_irq) and ctrl_enable;

	-- Priority encoded flags. Mask bits in effect.
	process (rx_irq, tx_irq, dcts_irq, err_irq)
	begin
		if rx_irq = '1' then
			flg_prio <= "11";
		elsif tx_irq = '1' then
			flg_prio <= "10";
		elsif dcts_irq = '1' or err_irq = '1' then
			flg_prio <= "01";
		else
			flg_prio <= "00";
		end if;
	end process;
	
	-- Flag register.
	flags(7) <= tx_ffe;
	flags(6) <= rx_fff;
	flags(5) <= not tx_ffe or tx_busy;
	flags(4) <= frm_err;
	flags(3) <= ovr_err;
	flags(2) <= par_err;
	flags(1 downto 0) <= flg_prio;

	------------------------------------------------------------------------------
	-- Data fifos/registers & parity generation                                 --
	------------------------------------------------------------------------------
	-- Transmit fifo/register.
	process (clk_i, rst_en)
	begin
		if rst_en = '0' then
			tx_ffout <= (others => '0');
		elsif rising_edge(clk_i) then
			if data_wr = '1' then
				tx_ffout <= idi;
			end if;
		end if;
	end process;

	-- Transmit parity generation.
	tx_ffpar <= ((tx_ffout(7) and not ctrl_size) xor
							 tx_ffout(6) xor tx_ffout(5) xor tx_ffout(4) xor
							 tx_ffout(3) xor tx_ffout(2) xor tx_ffout(1) xor tx_ffout(0) xor
							 not ctrl_prty(0)) and ctrl_prty(1);

	-- Transmit fifo empty flag generation.
	process (clk_u, data_wr, rst_en)
	begin
		if rst_en = '0' then
			tx_ffe <= '1';
		elsif data_wr = '1' then
			tx_ffe <= '0';
		elsif rising_edge(clk_u) then
			if tx_ffrd = '1' then
				tx_ffe <= '1';
			end if;
		end if;
	end process;

	-- Receive fifo/register.
	process (clk_u, rst_en)
	begin
		if rst_en = '0' then
			rx_ffout <= (others => '0');
		elsif rising_edge(clk_u) then
			if rx_ffwr = '1' then
				rx_ffout <= rx_reg(7 downto 0);
				if ctrl_size = '1' then
					rx_ffout(7) <= '0';
				end if;
			end if;
		end if;
	end process;
	
	-- Receive parity check. Space polarity errors not detected.
	rx_fferr <= (rx_reg(7) xor rx_reg(6) xor rx_reg(5) xor rx_reg(4) xor
							 rx_reg(3) xor rx_reg(2) xor rx_reg(1) xor rx_reg(0) xor
							 rx_reg(8) xor ctrl_size xor not ctrl_prty(0)) and ctrl_prty(1);
	
	-- Receive fifo full flag generation.
	process (clk_u, data_rd, rst_en)
	begin
		if rst_en = '0' or data_rd = '1' then
			rx_fff <= '0';
		elsif rising_edge(clk_u) then
			if rx_ffwr = '1' then
				rx_fff <= '1';
			end if;
		end if;
	end process;

	------------------------------------------------------------------------------
	-- Error flags                                                              --
	------------------------------------------------------------------------------
	-- Parity error flag. Reset when flag reg written.
	process (clk_u, flag_wr, rst_en)
	begin
		if rst_en = '0' or flag_wr = '1' then
			par_err <= '0';
		elsif rising_edge(clk_u) then
			if rx_ffwr = '1' and rx_fferr = '1' then
				par_err <= '1';
			end if;
		end if;
	end process;

	-- Overrun error flag. Reset when flag reg written.
	process (clk_u, flag_wr, rst_en)
	begin
		if rst_en = '0' or flag_wr = '1' then
			ovr_err <= '0';
		elsif rising_edge(clk_u) then
			if rx_ovr = '1' then
				ovr_err <= '1';
			end if;
		end if;
	end process;
	
	-- Framing error flag. Reset when flag reg written.
	process (clk_u, flag_wr, rst_en)
	begin
		if rst_en = '0' or flag_wr = '1' then
			frm_err <= '0';
		elsif rising_edge(clk_u) then
			if rx_frm = '1' then
				frm_err <= '1';
			end if;
		end if;
	end process;
	
	-- Delta CTS flag. Reset when flag reg written.
	process (clk_u, flag_wr, rst_en, cts)
	begin
		if rst_en = '0' or flag_wr = '1' then
			dcts <= '0';
			cts_2 <= cts;
			cts_1 <= cts;
		elsif rising_edge(clk_u) then
			if cts_2 /= cts_1 then
				dcts <= '1';
			end if;
			cts_2 <= cts_1;
			cts_1 <= cts;
		end if;
	end process;
	
	------------------------------------------------------------------------------
	-- Transmit shift register                                                  --
	------------------------------------------------------------------------------
	-- Transmit shift register. Loaded from the transmit holding fifo
	-- when that is not empty. Shifted out to tx on every 16th baud_ce
	-- when busy. In IrDA mode, the output on tx is inverted and the high
	-- bit output (corresponding to logic 0) is limited to 3 baud_ce
	-- clocks.
	process (clk_u, rst_en)
	begin
		if rst_en = '0' then
			tx_reg <= (others => '1');
			tx_bit_count <= 0;
			tx_baud_count <= "0000";
		elsif rising_edge(clk_u) then
			if baud_ce = '1' then
			-- Baud prescaler clock enable -------------------------------------------
				if tx_busy = '1' then
				-- Transmitter active --------------------------------------------------
					if tx_baud_count = "0000" then
						-- New bit
						tx_reg <= '1' & tx_reg(9 downto 1);	-- Shift data register
						tx_bit_count <= tx_bit_count - 1;		-- Count down bit counter
					end if;
					if tx_baud_count = "1101" and ctrl_irda = '1' then
						tx_reg(0) <= '1';										-- Up tx in 3 clks for IrDA
					end if;
					tx_baud_count <= tx_baud_count - 1;		-- Count down baud counter
				elsif tx_ffe = '0' and data_wr = '0' then
				-- Load new data -------------------------------------------------------
					tx_reg(0) <= '0';								-- Start bit to shift reg bit 0
					tx_reg(8 downto 1) <= tx_ffout;	-- Load data in shift reg bits 8-1
					tx_reg(9) <= '1';								-- Stop bit to shift reg bit 9
					if ctrl_size = '1' then
						if ctrl_prty = "00" then			-- If 7-bit chars, bit 8 replaced..
							tx_reg(8) <= '1';						-- ..by stop bit, if no parity used
						else
							tx_reg(8) <= tx_ffpar;			-- ..by parity, if used
						end if;
					elsif ctrl_prty /= "00" then		-- If 8-bit chars, bit 9 replaced..
						tx_reg(9) <= tx_ffpar;				-- ..by parity, if used
					end if;
					tx_bit_count <= char_len;				-- Init bit ctr for 8-11 bits
					tx_baud_count <= "1111";				-- Init baud ctr to 1 bit time
				end if;
				------------------------------------------------------------------------
			end if;
			--------------------------------------------------------------------------
		end if;
	end process;
	tx_busy <= '1' when tx_bit_count /= 0 or tx_baud_count /= "0000" else '0';
	tx_ffrd <= '1' when baud_ce = '1' and tx_busy = '0' and
											tx_ffe = '0' and data_wr = '0' else '0';
	
	-- The tx line is held high if the UART is disabled. If enabled, it is held
	-- low when break mode is on. If enabled and not in break mode, it outputs
	-- the shift register data, inverted if in IrDA mode.
	tx <= ((tx_reg(0) xor ctrl_irda) and not ctrl_break) or not ctrl_enable;
		
	------------------------------------------------------------------------------
	-- Receive shift register                                                   --
	------------------------------------------------------------------------------
	-- Receive shift register. Shifts in a character from rx when a start
	-- bit is detected, one bit is shifted on every 16th baud_ce. In IrDA mode,
	-- incoming negaive pulses are streched until after the next sample point.
	process (clk_u, rst_en)
	begin
		if rst_en = '0' then
			rx_1 <= '1';
			rx_2 <= '1';
			rx_in <= '1';
			rx_new <= '0';
			rx_busy <= '0';
			rx_reg <= (others => '1');
			rx_bit_count <= 0;
			rx_baud_count <= "0000";
		elsif rising_edge(clk_u) then
			if baud_ce = '1' then
			-- Baud prescaler clock enable -------------------------------------------
				if rx_counting = '1' then
				-- Receiver active -----------------------------------------------------
					rx_baud_count <= rx_baud_count - 1;		-- Count down baud counter
					if rx_baud_count = "0000" then
						-- New bit
						rx_reg <= '1' & rx_reg(9 downto 1);	-- Shift data register
						rx_reg(char_len - 2) <= rx_in;			-- Feed rx bit into shift
						rx_bit_count <= rx_bit_count - 1;		-- Count down bit counter
						rx_busy <= '1';											-- Start bit received
						rx_new <= '1';											-- New data in shift reg
						if ctrl_irda = '1' then
							-- Synchronize and stretch (if IrDA) rx
							rx_in <= '1';											-- Up rx after sample for IrDA
						end if;
					end if;
					if rx_in = '1' and rx_busy = '0' then
						-- Too short start bit, deactivate receiver
						rx_bit_count <= 0;									-- Clear bit counter
						rx_baud_count <= "0000";						-- Clear baud counter
						rx_busy <= '0';											-- Start bit not received
					end if;
				else
				-- Receiver inactive, waiting for start bit ----------------------------
					rx_busy <= '0';												-- Receiver not busy
					if rx_in = '0' and rx_new = '0' and rx_wait = '0' then
						-- Start receive new character
						rx_bit_count <= char_len;						-- Init bit ctr for 8-11 bits
						rx_baud_count <= "0111";						-- Init baud ctr to 1/2 bit time
					end if;
				end if;
			end if;
			--------------------------------------------------------------------------
			-- Synchronize and stretch (if IrDA) rx ----------------------------------
			if ctrl_enable = '0' then
				rx_in <= '1';
			elsif ctrl_irda = '0' or (rx_2 = '1' and rx_1 = '0') then
				rx_in <= rx_1;
			end if;
			rx_1 <= rx;
			rx_2 <= rx_1;
			--------------------------------------------------------------------------
			-- No new data in shift reg ----------------------------------------------
			if rx_ffwr = '1' then
				rx_new <= '0';
			end if;
			--------------------------------------------------------------------------
		end if;
	end process;

	-- Receiver is counting from the detection of the start bit to one baud_ce
	-- cycle before the sample point of the last stop bit. The last stop bit
	-- will never be sampled.
	rx_counting <= '1' when rx_bit_count /= 0 or rx_baud_count /= "0000" else '0';

	-- Data will be transferred from the receiver shift register to the receiver
	-- fifo on the first clk_u after the counting signal has dropped, unless the
	-- fifo is full. If it is full, transfer will be delayed until there is room.
	rx_ffwr <= '1' when rx_new = '1' and rx_counting = '0' and
											rx_fff = '0' and data_rd = '0' else '0';

	-- Overrun will be flagged if a new start bit arrives before received data
	-- has been transferred to the receive fifo.
	rx_ovr  <= '1' when rx_new = '1' and rx_counting = '0' and
											baud_ce = '1' and rx_in = '0' else '0';

	-- Framing error will be flagged if a new start bit arrives when the last
	-- stop bit is expected.
	rx_frm  <= '1' when rx_busy = '1' and rx_counting = '0' and
											baud_ce = '1' and rx_in = '0' else '0';  

	-- Framing error wait flipflop. Used to disable receiver following a framing
	-- error until the rx line has gone high, to avoid multiple interrupts during
	-- break conditions.
	process (clk_u, rx_in, rst_en)
	begin
		if rst_en = '0' or rx_in = '1' then
			rx_wait <= '0';
		elsif rising_edge(clk_u) then
			if rx_frm = '1' then
				rx_wait <= '1';
			end if;
		end if;
	end process;
end rtl;
