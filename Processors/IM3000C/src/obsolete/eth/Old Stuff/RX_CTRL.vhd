------------------------------------------------------------------
--
-- Projectname	: ETH_RX	
-- Filename		: RX_CTRL_01.vhd
-- Title		: RX CTRL
-- Author		: Erik Henkel
-- Description	: Controls the RX logic, basicly a state machine...
--	  
--
-------------------------------------------------------------------
--
-- Revisions : 
--	Date	Revision	Comments
--	010124	1			Intial version
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

entity rx_ctrl is
	port(
		--PHY Interface
		clk_rx					: in std_logic; --PHY CLK
		rx_dv						: in std_logic; --data valid from PHY
		rx_er						: in std_logic; --Transmission Error...
		
		--Control 
		start_rx_logic	: out std_logic;
		clear_rx_logic	: out std_logic;
				
		--CTL bits
		rx_go						: in std_logic; --receive frames...
		multicast				: in std_logic; --accept multicast frames
		promiscuous			: in std_logic; --accept all frames
						
		--STS bits
		tip							: out std_logic; --transfer in progress...
		early_er				: out std_logic; --EARLY rx_er 
		
		--Adr compare bits
		eq_da						: in std_logic; --destination ADR ok
		eq_ff						: in std_logic; --broadcast adr
		eq_mc						: in std_logic; --multicast adr
		eq_sfd					: in std_logic; --Start of Frame delimiter found
		c_11						: in std_logic; --end of adr
		find_addr				: out std_logic; --compare destination adr...
		
		--CRC
		crc_ok					: in std_logic;
		
		--RX FIFO signals
		req_en					: out std_logic; --enable DMA_REQ from FIFO
		add_byte				: out std_logic; --add a byte if odd_byte at end of frame...
		full						: in std_logic; --FIFO full
		empty						: in std_logic; --FIFO empty
		
		--RX FRAME STATUS FIFO
		overrun					: out std_logic; --RX_FIFO overrun (full during reception)
		mii_er					: out std_logic; --rx_er during reception of frame...
		crc_er					: out std_logic; --FRAME CRC ERROR...
		align_er				: out std_logic; --alignment error...
		store_sts				: out std_logic; --STORE FRAME STS...(prepare for next...)
		odd_nibb				: in std_logic; --odd nibble...
		odd_byte				: in std_logic; --odd byte...
		sts_full				: in std_logic; --FRAME STS FIFO FULL
		
		--GP1000
		clk_i						: in std_logic;
		rx_sts					: in std_logic;
		
		--system reset
		reset						: in std_logic);
end entity rx_ctrl;

architecture structure of rx_ctrl is

	--state machine:
	type rx_states is (FindIFG,FindSFD,FindAdr,Receive,Post_Frame);
	signal rx_state : rx_states;
	
	--control signals
	signal crc_ok_delay		: std_logic;
	signal adr_ok			: std_logic;
	signal rx_sts_delay		: std_logic;
	signal early_er_I		: std_logic;
	signal wait_7			: std_logic; --delay state change...with two cycles..
	
	--find IFG process signals
	signal IFG_count	: std_logic_vector(4 downto 0);
	signal IFG_OK		: std_logic;

	--sync flags...
	signal full_sync,empty_sync,sts_full_sync : std_logic;
	signal req_en_rx	: std_logic;
	
begin

--------------------
--FIND IFG process
--finds the interframe GAP between frames...
process(clk_rx,reset,rx_dv) is

begin
	if reset = '1' then
		IFG_count <= (others => '1');
		IFG_ok <= '0';
		wait_7 <= '0';
	elsif rising_edge(clk_rx) then
		if rx_dv = '1' then
			IFG_OK <= '0';
			IFG_count <= (others => '0');
			wait_7 <= '0';		
		else
			if IFG_count = 23 then
				IFG_OK <= '1';
			end if;
			if IFG_count = 6 then
				wait_7 <= '1';
			end if;
			IFG_count <= ifg_count+1;
		end if;			
	end if;
end process;

--------------------
--delay crc_ok
--this is to be able to check for alignment errors...
process(clk_rx,reset,crc_ok) is

begin
	if reset = '1' then
		crc_ok_delay <= '0';
	elsif rising_edge(clk_rx) then
		crc_ok_delay <= crc_ok;
	end if;
end process;

--------------------------
--input to STATE machine
adr_ok <= 	rx_go and				
			((promiscuous) or		--accept all frames...
			(multicast and eq_mc) or --multicast accepted
			(eq_ff) or				--broadcast
			(eq_da));				--destination address found...

--sync flags to clk_rx
process(reset,clk_rx,full,empty,sts_full) is

begin
	if reset = '1' then
		full_sync <= '0';
		sts_full_sync <= '0';
		empty_sync <= '0';
	elsif rising_edge(clk_rx) then
		full_sync <= full;
		empty_sync <= empty;
		sts_full_sync <= sts_full;
	end if;
end process;

--------------------------------------------------------------------
--state machine...
process(clk_rx,reset) is	--FIFO status

begin
	if reset = '1' then
		--sts bits (internal ones)
		early_er_i 	<= '0';
		store_sts <= '0';
		add_byte <= '0';
		align_er <= '0';
		crc_er	<= '0';
		overrun <= '0';
		mii_er	<= '0';
		tip 	<= '0';
		clear_rx_logic <= '1';
		--state machine
		RX_STATE <= FINDIFG;
	elsif rising_edge(clk_rx) then
		case RX_STATE is		
			----------------------------------------------------------
			--FINDIFG, look for a interframe GAP of 24 clk_rx times
			when FINDIFG =>
				--IFG found
				if IFG_OK = '1' and rx_dv = '1' then
					RX_STATE <= FINDSFD; --find SFD
					clear_rx_logic <= '1';
				else
					clear_rx_logic <= '0';	
					RX_STATE <= FINDIFG; --keep looking					
				end if;
				--restore signals				
				early_er_i 	<= '0';
				store_sts <= '0';
				add_byte <= '0';
				align_er <= '0';
				crc_er	<= '0';
				overrun <= '0';
				mii_er	<= '0';
				tip 	<= '0';				
			
			----------------------------------------------------------
			--FINDSFD, look for SFD ("5D") 
			when FINDSFD =>
				if rx_er = '1' then --EARLY ER flag
					early_er_i <= '1';
					RX_STATE <= FINDIFG; --find IFG again...*sigh*
				elsif rx_dv = '0' then --end of frame...
					RX_STATE <= FINDIFG; --find IFG again...*sigh*					
				elsif (eq_sfd and (full_sync or sts_full_sync)) = '1' then --SFD found but FIFO problem
					--FIFO problem is either that RX_FIFO is full or that RX_FRAME_STS_FIFO is full...
					RX_STATE <= FINDIFG; --find IFG again...*sigh*										
				elsif eq_sfd = '1' then --ROCK'N'ROLL
					RX_STATE <= FINDADR;					
				else
					RX_STATE <= FINDSFD;									
				end if;
				clear_rx_logic <= '0';	
			----------------------------------------------------------
			--FINDADR
			when FINDADR =>
				--end of frame or error...
				if rx_er = '1' or rx_dv = '0' then
					RX_STATE <= FINDIFG;
					if rx_er = '1' then	
						early_er_i <= '1'; --set flag...
					end if;
					clear_rx_logic <= '1';
				--is the adr ok? and is rx_go flag set?
				elsif c_11 = '1' and adr_ok = '1' then
					RX_STATE <= receive;
					tip <= '1'; --transfer in progress!!...
				--adr_ok not set discard frame...
				elsif c_11 = '1' then
					clear_rx_logic <= '1';
					RX_STATE <= FINDIFG; --find IFG again...*sigh*										
				end if;					
			
			----------------------------------------------------------
			--receive
			when receive =>
				--check RX_FIFO
				if rx_dv = '1' and full_sync = '1' then --RX_FIFO full...STOP!!
					overrun <= '1';
					RX_STATE <= post_frame;				
				--end of frame...
				elsif rx_dv = '0' then
					--if nr of bytes odd then add a byte...
					if odd_byte = '1' then
						add_byte <= '1';
					end if;						
					
					--check for alignment error:
					--odd nr off nibbles...then check if CRC is OK...
					--one nibble extra...(= alignment error..if CRC is not ok...)					
					if odd_nibb = '1' and crc_ok_delay = '0' then --CRC NOT OK
						align_er	<= '1';
						crc_er		<= '1';
					--normal FRAME
					elsif odd_nibb = '0' and crc_ok = '0' then --CRC NOT OK
						crc_er		<= '1';
					end if;
					
					--goto POST_FRAME (frame sts is stored in FIFO)
					RX_STATE <= post_frame;
				
				else
					RX_STATE <= receive;
				end if;	
			
				--check for mii_er
				if rx_er = '1' then
					mii_er <= '1';
				end if;
						
			----------------------------------------------------------
			--post_frame
			when post_frame =>
				add_byte <= '0';
				--wait until the very last byte have been read from RX_FIFO
				--before posting frame STS...
				--wait 7 CLK to make sure the RX_FIFO is empty, that gives 
				--the add_byte time to settle...
				--FRAME STS is only stored when the whole frame is downloaded to the GP1000
				if empty_sync = '1' and wait_7 = '1' then
					RX_STATE <= findIFG;
					store_sts <= '1';
				else
					RX_STATE <= post_frame;
				end if;				
			
			----------------------------------------------------------
			when others => 
				RX_STATE <= FINDIFG;
		end case;
	end if;
end process;		


---------------------------
--outputs from RX_STATE
start_rx_logic <= '1' when rx_dv = '1' and (RX_STATE = FINDADR or RX_STATE = receive) else '0';
--clear_rx_logic <= '1' when RX_STATE = FINDIFG or reset = '1' else '0';

--enable request (DMA_req_en):
process(clk_i,reset,req_en_rx) is

begin
	if reset = '1' then
		req_en <= '0';
	elsif rising_edge(clk_i) then
		req_en <= req_en_rx;
	end if;
end process;

req_en_rx <= '1' when RX_STATE = Receive or RX_STATE = post_frame else '0';

--FINDADR:
find_addr <= '1' when RX_STATE = FINDADR else '0';

--------------------------------------------------------------
--set/clear status bits (rx_sts)
process(clk_i,rx_sts,reset) is

begin
	if reset = '1' then
		rx_sts_delay <= '0';
	elsif rising_edge(clk_i) then
		rx_sts_delay <= rx_sts;
	end if;
end process;

process(clk_rx,rx_sts_delay,reset,early_er_i) is

begin
	if reset = '1' or rx_sts_delay = '1' then
		early_er <= '0';
	elsif rising_edge(clk_rx) then
		if early_er_i = '1' then
			early_er <= '1';
		end if;
	end if;
end process;

end architecture structure;
