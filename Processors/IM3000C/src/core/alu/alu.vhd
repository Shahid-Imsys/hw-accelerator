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
-- Title      : alu
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : alu.vhd
-- Author     : Xing Zhao, Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: The ALU consists of an 8-bit function generator, a 32x8-bit
--              register, the Q register (8 bit) and the Flag register.
-- 
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		3.3				CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.mpgmfield_lib.all;

entity alu is
	port(
		-- Clock input
		clk_e				: in std_logic;		-- Clock input
		-- Microprogram fields
		pl_shin_pa	: in std_logic_vector(2 downto 0);	-- uProg word field
		pl_mbmop		: in std_logic_vector(3 downto 0);	-- uProg word field
		pl_aaddr		: in std_logic_vector(4 downto 0);	-- uProg word field
		pl_baddr		: in std_logic_vector(4 downto 0);	-- uProg word field
		pl_alus			: in std_logic_vector(3 downto 0);	-- uProg word field
		pl_aluf			: in std_logic_vector(2 downto 0);	-- uProg word field
		pl_alud			: in std_logic_vector(2 downto 0);	-- uProg word field
		pl_ff_pb		: in std_logic_vector(3 downto 0);	-- uProg word field
		pl_cin			: in std_logic_vector(1 downto 0);	-- uProg word field
		--Data inputs
		dbus				: in std_logic_vector(7 downto 0);	-- D bus
		-- Flags
		flag_fn			: out std_logic;	-- Registered neg flag
		flag_fc			: out std_logic;	-- Registered carry flag
		flag_fz			: out std_logic;	-- Registered zero flag
		flag_fv			: out std_logic;	-- Registered overflow flag
		flag_fh			: out std_logic;	-- Registered half carry flag
		flag_fp			: out std_logic;	-- Registered parity flag (high when odd) 
		flag_neg		: out std_logic;	-- Loadable neg (sign) FF
		flag_carry	: out std_logic;	-- Loadable carry FF
		flag_zero		: out std_logic;	-- Loadable zero FF
		flag_oflow	: out std_logic;	-- Loadable overflow FF
		flag_link		: out std_logic;	-- Loadable link FF
		flag_pccy		: out std_logic;	-- Loadable program counter carry FF
		flag_qlsb		: out std_logic;	-- Q register lsb
		--Data outputs
		ybus				: out std_logic_vector(7 downto 0);	-- Y bus
		y_reg				: out std_logic_vector(7 downto 0));-- Registered Y bus
end;

architecture rtl of alu is
	signal b_in						: std_logic_vector(7 downto 0);	-- Data input to the register RAM
	signal a_out					: std_logic_vector(7 downto 0);	-- A output from register RAM
	signal a							: std_logic_vector(7 downto 0);	-- A input to source selector
	signal b							: std_logic_vector(7 downto 0);	-- B input to source selector
	signal s							: std_logic_vector(7 downto 0);	-- S (operand 1) input to func gen
	signal re							: std_logic_vector(7 downto 0);	-- Re (operand 2) input to func gen
	signal f							: std_logic_vector(7 downto 0);	-- F (result) output from func gen
	signal q_in						: std_logic_vector(7 downto 0);	-- Data input to Q register
	signal q							: std_logic_vector(7 downto 0);	-- Q register
	signal c_in						: std_logic;	-- Carry input to function generator
	signal flag_ac				: std_logic;	-- Carry output from function generator
	signal flag_az				: std_logic;	-- Zero output from function generator
	signal flag_yz				: std_logic;	-- Zero output from Y bus
	signal flag_av				: std_logic;	-- Overflow output from function generator
	signal flag_ah				: std_logic;	-- Half carry output from function generator
	signal flag_ap				: std_logic;	-- Parity output from function generator
	signal flag_yp				: std_logic;	-- Parity output from Y bus
	signal sel_flag				: std_logic;	-- Selects flags from func gen (low) or Y (high)
	signal flag_yan				: std_logic;	-- Neg output selected from func gen or Y
	signal flag_yac				: std_logic;	-- Carry output selected from func gen or '0'
	signal flag_yaz				: std_logic;	-- Zero output selected from func gen or Y
	signal flag_yav				: std_logic;	-- Overflow output selected from func gen or '0'
	signal flag_yap				: std_logic;	-- Neg output selected from func gen or Y
	signal shift_out			: std_logic;	-- Shift output from the B (register RAM) shifter 
	signal b_shift_in			: std_logic;	-- Shift input to the B shifter
	signal q_shift_in			: std_logic;	-- Shift input to the Q shifter
	signal b_we_n					: std_logic;	-- Write enable (active low) to the register RAM 
	signal q_we_n					: std_logic;	-- Write enable (active low) to the Q register
	-- Internal copies of output signals 
	signal ybus_int				: std_logic_vector(7 downto 0);
	signal y_reg_int			: std_logic_vector(7 downto 0);
	signal flag_fc_int		: std_logic;
	signal flag_carry_int	: std_logic;
	signal flag_zero_int	: std_logic;
	signal flag_link_int	: std_logic;
	signal flag_pccy_int	: std_logic;

begin
----------------------------------------------------------------------
	-- Function generator, controlled by ALUF field. 
----------------------------------------------------------------------
	fgen1 : entity work.fgen
		port map (
			pl_aluf	=> pl_aluf,
			cn			=> c_in,
			cn8			=> flag_ac,
			cn4			=> flag_ah,
			ovr			=> flag_av,
			eq			=> flag_az,
			odd			=> flag_ap,
			re			=> re,
			s				=> s,
			f				=> f);

----------------------------------------------------------------------
	-- Register RAM with 32 x 8 bits words, adressed by AADDR and BADDR
	-- fields.
----------------------------------------------------------------------
	ram32x81 : entity work.ram32x8(register_based)
		port map (
			clk_e			=> clk_e,
			pl_aaddr	=> pl_aaddr,
			pl_baddr	=> pl_baddr,
			we_n			=> b_we_n,
			b_in			=> b_in,
			a_out			=> a_out,
			b_out			=> b);

----------------------------------------------------------------------
	-- A output mux, controlled by ALUS field bit 3.
----------------------------------------------------------------------
	a <=	a_out when pl_alus(3) = '0' else
				pl_mbmop & pl_aaddr(3 downto 0);
	
--------------------------------------------------------------------------------
	-- Q register.
--------------------------------------------------------------------------------
	q_reg: process (clk_e)
	begin
		if rising_edge(clk_e) then
			if q_we_n = '0' then
				q <= q_in;
			end if;
		end if;
	end process;
	flag_qlsb <= q(0);                 --The LSB in Q register flag

--------------------------------------------------------------------------------
	-- Shift input selector, controlled by SHIN/PA field.
--------------------------------------------------------------------------------
	shin_sel: process (pl_alud(1), pl_shin_pa, f(7), f(0), q(7), q(0), flag_link_int, flag_carry_int, flag_ac)
	begin
		if pl_alud(1) = '0' then						-- Right shift --
			case pl_shin_pa is								-----------------         
				when SHIN_SINP0 =>							-- SERIAL INPUT = 0
					b_shift_in <= '0';
					q_shift_in <= '0';
				when SHIN_SINPLINK =>						-- SERIAL INPUT = LINK
					b_shift_in <= flag_link_int;
					q_shift_in <= f(0);
				when SHIN_SINPC =>							-- SERIAL INPUT = C
					b_shift_in <= flag_carry_int; 
					q_shift_in <= f(0);
				when SHIN_ROTDOUBLE =>					-- ROTDOUBLE (right)
					b_shift_in <= q(0);	
					q_shift_in <= f(0);
				when SHIN_ROTATE =>							-- ROTATE (right)
					b_shift_in <= f(0);
					q_shift_in <= q(0);
				when SHIN_ARIDOUBLE =>					-- ARITHMETIC (right)
					b_shift_in <= f(7);
					q_shift_in <= f(0);
				when SHIN_SINP1 =>							-- SERIAL INPUT = 1
					b_shift_in <= '1';
					q_shift_in <= '1';
				when SHIN_SHIFTMD =>						-- SHIFTMUL
					b_shift_in <= flag_ac;
					q_shift_in <= f(0);
				when others => null;   							
			end case;
		else																-- Left shift --
			case pl_shin_pa is								----------------         
				when SHIN_SINP0 =>							-- SERIAL INPUT = 0
					b_shift_in <= '0';
					q_shift_in <= '0';
				when SHIN_SINPLINK =>						-- SERIAL INPUT = LINK
					b_shift_in <= flag_link_int;
					q_shift_in <= f(7);
				when SHIN_SINPC =>							-- SERIAL INPUT = C
					b_shift_in <= flag_carry_int; 
					q_shift_in <= f(7);
				when SHIN_ROTDOUBLE =>					-- ROTDOUBLE (left)
					b_shift_in <= q(7);
					q_shift_in <= f(7);
				when SHIN_ROTATE =>							-- ROTATE (left)
					b_shift_in <= f(7);
					q_shift_in <= q(7);
				when SHIN_ARIDOUBLE =>					-- ARITHMETIC (left)
					b_shift_in <= q(7);
					q_shift_in <= '0';
				when SHIN_SINP1 =>							-- SERIAL INPUT = 1
					b_shift_in <= '1';
					q_shift_in <= '1';
				when SHIN_SHIFTMD =>						-- SHIFTDIV
					b_shift_in <= q(7);
					q_shift_in <= not flag_link_int;
				when others => null;   							
			end case;
		end if;
	end process;

--------------------------------------------------------------------------------
	-- Shift output selector, controlled by ALUD field bit 1.
--------------------------------------------------------------------------------
	shift_out <=	f(0) when pl_alud(1) = '0' else
								f(7);     

----------------------------------------------------------------------
	-- Source selector, controlled by ALUS field.
----------------------------------------------------------------------
	source_sel: process (pl_alus, a, b, q, dbus)
	begin                           
		case pl_alus(2 downto 0) is
			when ALUS_QA =>						-- QA
				s  <= q;
				re <= a;
			when ALUS_BA =>						-- BA
				s  <= b;
				re <= a;     
			when ALUS_Q0 =>						-- Q0
				s  <= q;
				re <= (others => '0');
			when ALUS_B0 =>						-- B0
				s  <= b;
				re <= (others => '0');
			when ALUS_A0 =>						-- A0
				s  <= a;
				re <= (others => '0');
			when ALUS_AD =>						-- AD 
				s  <= a;
				re <= dbus;        
			when ALUS_QD =>						-- QD
				s  <= q;
				re <= dbus;
			when ALUS_0D =>						-- 0D
				s  <= (others => '0');
				re <= dbus;
			when others => null;
		end case;
	end process;

--------------------------------------------------------------------------------
	-- Destination selector, controlled by ALUD field.
--------------------------------------------------------------------------------
	alud_sel: process (pl_alud, f, q, b_shift_in, q_shift_in)
	begin
		-- Default values
--		b_in <= f;    
--		q_in <= q;                     
		b_in <= (others => '-');    
		q_in <= (others => '-');                     
		b_we_n <= '1';
		q_we_n <= '1';
	
		case pl_alud is
			when ALUD_NOP =>											-- NOP
				null;
			when ALUD_QREG =>											-- QREG
				q_we_n	<= '0';											-- Write F to Q
				q_in		<= f;
			when ALUD_RAMATOY =>									-- RAMATOY
				b_we_n	<= '0';											-- Write F to reg B
				b_in		<= f;
			when ALUD_RAM =>											-- RAM
				b_we_n	<= '0';											-- Write F to reg B
				b_in		<= f;
			when ALUD_RAMQRIGHT =>								-- RAMQRIGHT
				b_we_n	<= '0';											-- Write F/2 to reg B
				b_in(6 downto 0) <= f(7 downto 1);
				b_in(7)	<= b_shift_in;
				q_we_n	<= '0';											-- Write Q/2 to Q
				q_in(6 downto 0) <= q(7 downto 1);
				q_in(7) <= q_shift_in;
			when ALUD_RAMRIGHT =>									-- RAMRIGHT
				b_we_n	<= '0';											-- Write F/2 to reg B
				b_in(6 downto 0) <= f(7 downto 1);
				b_in(7) <= b_shift_in;
			when ALUD_RAMQLEFT =>									-- RAMQLEFT
				b_we_n	<= '0';											-- Write F*2 to reg B
				b_in(7 downto 1) <= f(6 downto 0);
				b_in(0) <= b_shift_in;
				q_we_n	<= '0';											-- Write Q*2 to Q
				q_in(7 downto 1) <= q(6 downto 0);
				q_in(0) <= q_shift_in;
			when ALUD_RAMLEFT =>									-- RAMLEFT
				b_we_n	<= '0';											-- Write F*2 to reg B
				b_in(7 downto 1) <= f(6 downto 0);
				b_in(0) <= b_shift_in;
			when others => null;   							
		end case;
	end process;

----------------------------------------------------------------------
	-- Carry input selector, controlled by CIN field. 
----------------------------------------------------------------------
	cin_sel: process (pl_cin, pl_aluf, pl_baddr, flag_carry_int, flag_pccy_int, flag_fc_int)
	begin
		case pl_cin is
			when CIN_0	=>							-- CARRYIN = 0
				c_in <= '0';
				if pl_aluf = ALUF_S_PLUS_RE and pl_baddr = "01110" then
					c_in <= flag_pccy_int;	-- CARRYIN = PCCY (only on add with BDEST PCH (=reg# 0E))  
				end if;
			when CIN_1	=>							-- CARRYIN = 1
				c_in <= '1';
			when CIN_C	=>							-- CARRYIN = C
				c_in <= flag_carry_int;
			when CIN_FC	=>							-- CARRYIN = FC
				c_in <= flag_fc_int;
			when others => null;
		end case;
	end process;

----------------------------------------------------------------------
	-- Registered flags, always loaded. 
----------------------------------------------------------------------
	flag_register: process (clk_e)
	begin
		if rising_edge(clk_e) then
			flag_fn			<= flag_yan;	-- Registered signed flag
			flag_fc_int	<= flag_yac;	-- Registered carry output flag
			flag_fz			<= flag_yaz;	-- Registered zero flag
			flag_fv			<= flag_yav;	-- Registered overflow flag
			flag_fh			<= flag_ah;		-- Registered half carry output flag 
			flag_fp			<= flag_yap;	-- Registered parity flag
		end if;
	end process; 
	flag_fc <= flag_fc_int;

----------------------------------------------------------------------
	-- Loadable flags, loading controlled by FF/PB field. 
----------------------------------------------------------------------
	ffpb_instr: process (clk_e)         
	begin
		if rising_edge(clk_e) then
			case pl_ff_pb is
				when FF_LZNVLOG =>							-- LOAD ZNV LOG
					flag_oflow			<= '0';    
					flag_neg				<= flag_yan;
					flag_zero_int		<= flag_yaz;
				when FF_LCZNVARI =>							-- LOAD CZNV ARI 
					flag_oflow			<= flag_yav;    
					flag_neg				<= flag_yan;
					flag_zero_int		<= flag_yaz;
					flag_carry_int	<= flag_yac;
				when FF_RESPCCY =>							-- RESET PCCY 
					flag_pccy_int		<= '0';
				when FF_LCNVARI =>							-- LOAD CNV ARI
					flag_oflow			<= flag_yav;    
					flag_neg				<= flag_yan;   
					flag_carry_int	<= flag_yac;
				when FF_LLFSHIFT =>							-- LOAD LINK FROM SHIFT 
					flag_link_int		<= shift_out; 
				when FF_LCZNVARI16 =>						-- LOAD CZNV ARI16
					flag_oflow			<= flag_yav;    
					flag_neg				<= flag_yan;
					flag_zero_int		<= flag_yaz and flag_zero_int;
					flag_carry_int	<= flag_yac;
				when FF_LLFD =>									-- LOAD LINK FROM D
					flag_link_int		<= dbus(3);    
				when FF_SETC =>									-- SET C
					flag_carry_int	<= '1';    
				when FF_LCZNVLOG =>							-- LOAD CZNV LOG 
					flag_oflow			<= '0';    
					flag_neg				<= flag_yan;
					flag_zero_int		<= flag_yaz;
					flag_carry_int	<= '0';
				when FF_LCZNVFD =>							-- LOAD CZNV FROM D 
					flag_oflow			<= dbus(5);  
					flag_neg				<= dbus(4);
					flag_zero_int		<= dbus(2);
					flag_carry_int	<= dbus(0);
				when FF_LOADPCCY =>							-- LOAD PCCY 
					flag_pccy_int		<= flag_yac;    
				when FF_LCFSHIFT =>							-- LOAD C FROM SHIFT 
					flag_carry_int	<= shift_out; 
				when FF_LZNLOG =>								-- LOAD ZN LOG
					flag_neg				<= flag_yan;
					flag_zero_int		<= flag_yaz;
				when FF_LZNLOG16 =>							-- LOAD ZN LOG16
					flag_neg				<= flag_yan;
					flag_zero_int		<= flag_yaz and flag_zero_int;
				when FF_NOP =>									-- No operation  
					null;
				when FF_LCZARI =>								-- LOAD CZ ARI 
					flag_zero_int		<= flag_yaz;
					flag_carry_int	<= flag_yac;
				when others => null;         
			end case; 
		end if;
	end process;
	flag_zero  <= flag_zero_int;
	flag_pccy  <= flag_pccy_int;
	flag_carry <= flag_carry_int;
	flag_link  <= flag_link_int;

----------------------------------------------------------------------
	-- Output selector, controlled by ALUD field. 
----------------------------------------------------------------------
	-- Y bus gets A operand when doing RAMATOY, function generator
	-- output otherwise.
	ybus_int <= a when pl_alud = ALUD_RAMATOY else
							f;
	ybus <= ybus_int;
	
	-- Zero and parity flags from the Y bus.      
	flag_yz	<= not (ybus_int(7) or ybus_int(6) or ybus_int(5) or ybus_int(4) or
									ybus_int(3) or ybus_int(2) or ybus_int(1) or ybus_int(0));
	flag_yp <= ybus_int(7) xor ybus_int(6) xor ybus_int(5) xor ybus_int(4) xor
						 ybus_int(3) xor ybus_int(2) xor ybus_int(1) xor ybus_int(0);

	-- Zero, parity and neg flags are taken from the Y bus when doing a
	-- single operand OR (PASS), from function generator otherwise.
	sel_flag <=	'1' when (pl_alus(2 downto 0) = ALUS_Q0 or
												pl_alus(2 downto 0) = ALUS_A0 or
												pl_alus(2 downto 0) = ALUS_B0 or
												pl_alus(2 downto 0) = ALUS_0D) and
												pl_aluf = ALUF_S_OR_RE else '0';
	flag_yan <= ybus_int(7) when sel_flag = '1' else
							f(7);					 
	flag_yac <= '0' when sel_flag = '1' else
							flag_ac;					 
	flag_yaz <= flag_yz when sel_flag = '1' else
							flag_az;					 
	flag_yav <= '0' when sel_flag = '1' else
							flag_av;					 
	flag_yap <= flag_yp when sel_flag = '1' else
							flag_ap;					 
					
----------------------------------------------------------------------
	-- Y bus register.
----------------------------------------------------------------------
	process (clk_e)         
	begin
		if rising_edge(clk_e) then
			y_reg_int <= ybus_int;     
		end if;
	end process;
	y_reg <= y_reg_int;
end;



