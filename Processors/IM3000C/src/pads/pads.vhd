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
-- Title      : I/O Cells and Pads
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pads.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Instantiation of all digital signal pads of GP3000. Also
--							instantiates the reference oscillator.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-12-20		1.0				CB			Created
-- 2006-02-06		1.1				CB			Replaced oscillator UROSCAHC by UROSCHINTC. 
-- 2006-02-16		1.2				CB			Updated for staggered pads on left side of
--																bottom edge, new power/ground placement, pad
--																spreading in corners. Added soft drive
--																strength and slew rate control to some pins.
-- 2006-02-17		1.3				CB			Finished adding soft drive strength and slew
--																rate control.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity pads is
	port (
		-- Left edge, pad side
		MX1_CK   			: in    std_logic;   
		MX2      			: inout std_logic;   
		MXOSC_FEB			: in    std_logic;                  
		MXOSC_S1			: in    std_logic;                  
		MXOSC_S0			: in    std_logic;                  
		MXOUT    			: out   std_logic;                  
		MEXEC    			: out   std_logic;                  
		MCKOUT0  			: out   std_logic;                  
		MCKOUT1  			: out   std_logic;                  
		MSDIN    			: in    std_logic;                  
		MSDOUT   			: out   std_logic;                  
		MIRQOUT  			: out   std_logic;                  
		PD0_DDQM0			: inout std_logic;                  
		PD1_DDQM1			: inout std_logic;                  
		PD2_DDQM2			: inout std_logic;                  
		PD3_DDQM3			: inout std_logic;                  
		PD4_DDQM4			: inout std_logic;                  
		PD5_DDQM5			: inout std_logic;                  
		PD6_DDQM6			: inout std_logic;                  
		PD7_DDQM7			: inout std_logic;                  
		PJ4_INEXT 		: inout std_logic;        
		PJ5_ILDOUT		: inout std_logic;        
		PJ6_ILIOA 		: inout std_logic;        
		PJ7_ICLK  		: inout std_logic;        
		PI0_ID0   		: inout std_logic;        
		PI1_ID1   		: inout std_logic;        
		PI2_ID2   		: inout std_logic;        
		PI3_ID3   		: inout std_logic;        
		PI4_ID4   		: inout std_logic;        
		PI5_ID5   		: inout std_logic;        
		PI6_ID6   		: inout std_logic;        
		PI7_ID7   		: inout std_logic;        
		PH0_IDREQ0		: inout std_logic;        
		PH1_IDREQ1		: inout std_logic;        
		PH2_IDREQ2		: inout std_logic;        
		PH3_IDREQ3		: inout std_logic;        
		PH4_IDACK0		: inout std_logic;        
		PH5_IDACK1		: inout std_logic;        
		PH6_IDACK2		: inout std_logic;        
		PH7_IDACK3		: inout std_logic;        
		PC0_IDREQ4		: inout std_logic;  
		PC1_IDREQ5		: inout std_logic;  
		PC2_IDREQ6		: inout std_logic;  
		PC3_IDREQ7		: inout std_logic;  
		PC4_IDACK4		: inout std_logic;  
		PC5_IDACK5		: inout std_logic;  
		PC6_IDACK6		: inout std_logic;  
		PC7_IDACK7		: inout std_logic;
		-- Bottom edge, pad side
		MBYPASS				: in    std_logic;                  
		MRESET 				: in    std_logic;                  
		MRSTOUT				: out   std_logic;                  
		MTEST  				: in    std_logic;                  
		MWAKE 				: in    std_logic;                  
		MIRQ0 				: in    std_logic;                  
		MIRQ1 				: in    std_logic;                  
		MRXOUT				: out   std_logic;
		PJ0_UTX1			: inout std_logic;                  
		PJ1_URX1			: inout std_logic;                  
		PJ2_URTS1 		: inout std_logic;
		PJ3_UCTS1 		: inout std_logic;
		PE0_UTX2  		: inout std_logic;
		PE1_URX2  		: inout std_logic;
		PE2_URTS2 		: inout std_logic;
		PE3_UCTS2 		: inout std_logic;
		PE4_UTX3  		: inout std_logic;
		PE5_URX3  		: inout std_logic;
		PE6_URTS3 		: inout std_logic;
		PE7_UCTS3 		: inout std_logic;
		PF0_ETXEN 		: inout std_logic;
		PF1_ETXCLK		: inout std_logic;
		PF2_ETXD0 		: inout std_logic;
		PF3_ETXD1 		: inout std_logic;
		PF4_ERXDV 		: inout std_logic;
		PF5_ERXER 		: inout std_logic;
		PF6_ERXD0 		: inout std_logic;
		PF7_ERXD1 		: inout std_logic;
		PG0_ETXER 		: inout std_logic;
		PG1_ERXCLK		: inout std_logic;
		PG2_ETXD2 		: inout std_logic;
		PG3_ETXD3 		: inout std_logic;
		PG4_ECOL  		: inout std_logic;
		PG5_ECRS  		: inout std_logic;
		PG6_ERXD2 		: inout std_logic;    
		-- Right edge, pad side
		PG7_ERXD3 		: inout std_logic;
		PA0						: inout std_logic;
		PA1						: inout std_logic;
		PA2						: inout std_logic;
		PA3						: inout std_logic;
		PA4						: inout std_logic;
		PA5						: inout std_logic;
		PA6						: inout std_logic;
		PA7						: inout std_logic;
		PB0						: inout std_logic;
		PB1						: inout std_logic;
		PB2						: inout std_logic;
		PB3						: inout std_logic;      
		PB4						: inout std_logic;  
		PB5						: inout std_logic;  
		PB6						: inout std_logic;  
		PB7						: inout std_logic;  
		-- Top edge, pad side
		DDQ0					: inout std_logic;
		DDQ1					: inout std_logic;
		DDQ2					: inout std_logic;
		DDQ3					: inout std_logic;
		DDQ4					: inout std_logic;
		DDQ5					: inout std_logic;
		DDQ6					: inout std_logic;
		DDQ7					: inout std_logic;
		DCLK					: out   std_logic;
		DCS 					: out   std_logic;
		DRAS					: out   std_logic;
		DCAS					: out   std_logic;
		DWE 					: out   std_logic;
		DBA0					: out   std_logic;
		DBA1					: out   std_logic;
		DA0 					: out   std_logic;
		DA1 					: out   std_logic;
		DA2 					: out   std_logic;
		DA3 					: out   std_logic;
		DA4 					: out   std_logic;
		DA5 					: out   std_logic;
		DA6 					: out   std_logic;
		DA7 					: out   std_logic;
		DA8 					: out   std_logic;
		DA9 					: out   std_logic;
		DA10					: out   std_logic;
		DA11					: out   std_logic;
		DA12					: out   std_logic;
		DA13					: out   std_logic;
		DCKE0					: out   std_logic;                  
		DCKE1					: out   std_logic;                  
		DCKE2					: out   std_logic;                  
		DCKE3					: out   std_logic;                  
		MPORDIS				: in    std_logic;                  
		MPLL_TSTO			: inout std_logic;                  
		-- Left edge, internal side
		mx1_ck_i 			: out   std_logic;
		mx1_ck_e			: in    std_logic;
		mxout_o  			: in    std_logic;                                     
		mexec_o  			: in    std_logic;                                     
		mckout0_o			: in    std_logic;                                     
		mckout1_o			: in    std_logic;                                     
		msdin_i  			: out   std_logic;                                     
		msdout_o 			: in    std_logic;                                     
		mirqout_o			: in    std_logic;                                     
		pd_en					: in    std_logic_vector(7 downto 0); 
		pd_o 					: in    std_logic_vector(7 downto 0);                  
		pd_i 					: out   std_logic_vector(7 downto 0);                  
		pj_en					: in    std_logic_vector(7 downto 0);
		pj_o 					: in    std_logic_vector(7 downto 0);                  
		pj_i 					: out   std_logic_vector(7 downto 0);                   
		pi_en					: in    std_logic_vector(7 downto 0);
		pi_o 					: in    std_logic_vector(7 downto 0);
		pi_i 					: out   std_logic_vector(7 downto 0);
		ph_en					: in    std_logic_vector(7 downto 0);
		ph_o 					: in    std_logic_vector(7 downto 0);
		ph_i 					: out   std_logic_vector(7 downto 0);
		pc_en					: in    std_logic_vector(7 downto 0);
		pc_o 					: in    std_logic_vector(7 downto 0);
		pc_i 					: out   std_logic_vector(7 downto 0);
		-- Bottom edge, internal side
		mbypass_i			: out   std_logic;                                     
		mreset_i 			: out   std_logic;                                     
		mrstout_o			: in    std_logic;                                     
		mtest_i  			: out   std_logic;                                     
		mwake_i 			: out   std_logic;                                     
		mirq0_i 			: out   std_logic;                                     
		mirq1_i 			: out   std_logic;                                     
		mrxout_o			: in    std_logic;
		pe_en					: in    std_logic_vector(7 downto 0);
		pe_o 					: in    std_logic_vector(7 downto 0);
		pe_i 					: out   std_logic_vector(7 downto 0);
		pf_en					: in    std_logic_vector(7 downto 0);
		pf_o 					: in    std_logic_vector(7 downto 0);
		pf_i 					: out   std_logic_vector(7 downto 0);
		pg_en					: in    std_logic_vector(7 downto 0);
		pg_o 					: in    std_logic_vector(7 downto 0);
		pg_i 					: out   std_logic_vector(7 downto 0);
		-- Right edge, internal side
		pa_en					: in    std_logic_vector(7 downto 0);
		pa_o 					: in    std_logic_vector(7 downto 0);
		pa_i 					: out   std_logic_vector(7 downto 0);
		pb_en					: in    std_logic_vector(7 downto 0);
		pb_o 					: in    std_logic_vector(7 downto 0);
		pb_i 					: out   std_logic_vector(7 downto 0);
		-- Top edge, internal side
		ddq_en				: in    std_logic;	-- Connected to all DDQ cells                     
		ddq_o 				: in    std_logic_vector(7 downto 0);  
		ddq_i 				: out   std_logic_vector(7 downto 0);
		dclk_o				: in    std_logic;                     
		dcs_o 				: in    std_logic;                     
		dras_o				: in    std_logic;                     
		dcas_o				: in    std_logic;                     
		dwe_o 				: in    std_logic;                     
		dba_o 				: in    std_logic_vector(1 downto 0);                     
		da_o  				: in    std_logic_vector(13 downto 0);   
		dcke_o				: in    std_logic_vector(3 downto 0);                  
		mpordis_i			: out   std_logic;                                     
		mpll_tsto_o		: in    std_logic;
		mpll_tsto_en	: in    std_logic;
		-- I/O cell configuration control inputs
		d_hi					: in    std_logic;
		d_sr					: in    std_logic;
		d_lo					: in    std_logic;
		p1_hi					: in    std_logic;
		p1_sr					: in    std_logic;
		pc_hi					: in    std_logic;
		pc_lo_n				: in    std_logic;
		ph_hi					: in    std_logic;
		ph_lo_n				: in    std_logic;
		pi_hi					: in    std_logic;
		pi_lo_n				: in    std_logic;
		p2_hi					: in    std_logic;
		p2_sr					: in    std_logic;
		pel_hi				: in    std_logic;
		peh_hi				: in    std_logic;
		pdll_hi				: in    std_logic;
		pdlh_hi				: in    std_logic;
		pdh_hi				: in    std_logic;
		p3_hi					: in    std_logic;
		p3_sr					: in    std_logic;
		pf_hi					: in    std_logic;
		pg_hi					: in    std_logic);
end pads;

architecture struct of pads is
	component UROSCHINTC
		port (
			O  	: out   std_logic;
			I  	: in    std_logic;
			IO 	: inout std_logic;
			E  	: in    std_logic;
			EB	: in    std_logic;
			S0	: in    std_logic;
			S1	: in    std_logic;
			FEB	: in    std_logic);
	end component;
	
	component XMC
		port (
			O		: out   std_logic;
			I		: in    std_logic;
			PU	: in    std_logic;
			PD	: in    std_logic;
			SMT	: in    std_logic);
	end component;
	
	component XMD
		port (
			O		: out   std_logic;
			I		: in    std_logic;
			PU	: in    std_logic;
			PD	: in    std_logic;
			SMT	: in    std_logic);
	end component;

	component YA2GSC
		port (
			O		: out   std_logic;
			I		: in    std_logic;
			E		: in    std_logic;
			E2	: in    std_logic;
			E4	: in    std_logic;
			E8	: in    std_logic;
			SR	: in    std_logic);
	end component;

	component YA2GSD
		port (
			O		: out   std_logic;
			I		: in    std_logic;
			E		: in    std_logic;
			E2	: in    std_logic;
			E4	: in    std_logic;
			E8	: in    std_logic;
			SR	: in    std_logic);
	end component;

	component ZMA2GSC
		port(
			O  	: out   std_logic;
			I  	: in    std_logic;
			IO 	: inout std_logic;
			E  	: in    std_logic;
			E2 	: in    std_logic;
			E4 	: in    std_logic;
			E8 	: in    std_logic;
			SR 	: in    std_logic;
			PU 	: in    std_logic;
			PD 	: in    std_logic;
			SMT	: in    std_logic);
	end component;

	component ZMA2GSD
		port(
			O  	: out   std_logic;
			I  	: in    std_logic;
			IO 	: inout std_logic;
			E  	: in    std_logic;
			E2 	: in    std_logic;
			E4 	: in    std_logic;
			E8 	: in    std_logic;
			SR 	: in    std_logic;
			PU 	: in    std_logic;
			PD 	: in    std_logic;
			SMT	: in    std_logic);
	end component;

  signal mxosc_s0_i		: std_logic;
  signal mxosc_s1_i		: std_logic;
  signal mxosc_feb_i	: std_logic;

	attribute syn_black_box	: boolean;
	attribute syn_black_box of UROSCHINTC					: component is true;
	attribute syn_black_box of XMC								: component is true;
	attribute syn_black_box of XMD								: component is true;
	attribute syn_black_box of YA2GSC							: component is true;  
	attribute syn_black_box of YA2GSD							: component is true;
	attribute syn_black_box of ZMA2GSC						: component is true;
	attribute syn_black_box of ZMA2GSD						: component is true;  

begin
  PAD_MX1_CK : UROSCHINTC port map ( EB => '0',
    I		=> MX1_CK,
    IO	=> MX2,
    S0	=> mxosc_s0_i,
    S1	=> mxosc_s1_i,
    FEB	=> mxosc_feb_i,
    E		=> mx1_ck_e,
    O		=> mx1_ck_i);    
  PAD_MXOSC_FEB : XMC port map ( PU => '0', PD => '1', SMT => '0',
    I		=> MXOSC_FEB,
    O		=> mxosc_feb_i);  
  PAD_MXOSC_S1 : XMC port map ( PU => '0', PD => '1', SMT => '0',
    I		=> MXOSC_S1,
    O		=> mxosc_s1_i);  
  PAD_MXOSC_S0 : XMC port map ( PU => '1', PD => '0', SMT => '0',
    I		=> MXOSC_S0,
    O		=> mxosc_s0_i);  
  PAD_MXOUT : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MXOUT,
    E		=> '1',
    I		=> mxout_o);
  PAD_MEXEC : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MEXEC,
    E		=> '1',
    I		=> mexec_o);
  PAD_MCKOUT0 : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MCKOUT0,
    E		=> '1',
    I		=> mckout0_o);
  PAD_MCKOUT1 : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MCKOUT1,
    E		=> '1',
    I		=> mckout1_o);
  PAD_MSDIN : XMC port map ( PU => '1', PD => '0', SMT => '1',
    I		=> MSDIN,
    O		=> msdin_i);
  PAD_MSDOUT : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MSDOUT,
    E		=> '1',
    I		=> msdout_o);
  PAD_MIRQOUT : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MIRQOUT,
    E		=> '1',
    I		=> mirqout_o);
  PAD_PD0_DDQM0 : ZMA2GSC port map ( E2 => pdll_hi, E4 => pdll_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD0_DDQM0,
    E		=> pd_en(0),
    I		=> pd_o(0),
    O		=> pd_i(0));
  PAD_PD1_DDQM1 : ZMA2GSC port map ( E2 => pdll_hi, E4 => pdll_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD1_DDQM1,
    E		=> pd_en(1),
    I		=> pd_o(1),
    O		=> pd_i(1));
  PAD_PD2_DDQM2 : ZMA2GSC port map ( E2 => pdlh_hi, E4 => pdlh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD2_DDQM2,
    E		=> pd_en(2),
    I		=> pd_o(2),
    O		=> pd_i(2));
  PAD_PD3_DDQM3 : ZMA2GSC port map ( E2 => pdlh_hi, E4 => pdlh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD3_DDQM3,
    E		=> pd_en(3),
    I		=> pd_o(3),
    O		=> pd_i(3));
  PAD_PD4_DDQM4 : ZMA2GSC port map ( E2 => pdh_hi, E4 => pdh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD4_DDQM4,
    E		=> pd_en(4),
    I		=> pd_o(4),
    O		=> pd_i(4));
  PAD_PD5_DDQM5 : ZMA2GSC port map ( E2 => pdh_hi, E4 => pdh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD5_DDQM5,
    E		=> pd_en(5),
    I		=> pd_o(5),
    O		=> pd_i(5));
  PAD_PD6_DDQM6 : ZMA2GSC port map ( E2 => pdh_hi, E4 => pdh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD6_DDQM6,
    E		=> pd_en(6),
    I		=> pd_o(6),
    O		=> pd_i(6));
  PAD_PD7_DDQM7 : ZMA2GSC port map ( E2 => pdh_hi, E4 => pdh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PD7_DDQM7,
    E		=> pd_en(7),
    I		=> pd_o(7),
    O		=> pd_i(7));
  PAD_PJ4_INEXT : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ4_INEXT,
    E		=> pj_en(4),
    I		=> pj_o(4),
    O		=> pj_i(4));  
  PAD_PJ5_ILDOUT : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ5_ILDOUT,
    E		=> pj_en(5),
    I		=> pj_o(5),
    O		=> pj_i(5));  
  PAD_PJ6_ILIOA : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ6_ILIOA,
    E		=> pj_en(6),
    I		=> pj_o(6),
    O		=> pj_i(6));  
  PAD_PJ7_ICLK : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_lo_n, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ7_ICLK,
    E		=> pj_en(7),
    I		=> pj_o(7),
    O		=> pj_i(7));  
  PAD_PI0_ID0 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI0_ID0,
    E		=> pi_en(0),
    I		=> pi_o(0),
    O		=> pi_i(0));  
  PAD_PI1_ID1 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI1_ID1,
    E		=> pi_en(1),
    I		=> pi_o(1),
    O		=> pi_i(1));  
  PAD_PI2_ID2 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI2_ID2,
    E		=> pi_en(2),
    I		=> pi_o(2),
    O		=> pi_i(2));  
  PAD_PI3_ID3 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI3_ID3,
    E		=> pi_en(3),
    I		=> pi_o(3),
    O		=> pi_i(3));  
  PAD_PI4_ID4 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI4_ID4,
    E		=> pi_en(4),
    I		=> pi_o(4),
    O		=> pi_i(4));  
  PAD_PI5_ID5 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI5_ID5,
    E		=> pi_en(5),
    I		=> pi_o(5),
    O		=> pi_i(5));  
  PAD_PI6_ID6 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI6_ID6,
    E		=> pi_en(6),
    I		=> pi_o(6),
    O		=> pi_i(6));  
  PAD_PI7_ID7 : ZMA2GSC port map ( E2 => pi_lo_n, E4 => pi_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PI7_ID7,
    E		=> pi_en(7),
    I		=> pi_o(7),
    O		=> pi_i(7));  
  PAD_PH0_IDREQ0 : ZMA2GSC port map ( E2 => ph_hi, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH0_IDREQ0,
    E		=> ph_en(0),
    I		=> ph_o(0),
    O		=> ph_i(0));  
  PAD_PH1_IDREQ1 : ZMA2GSC port map ( E2 => ph_hi, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH1_IDREQ1,
    E		=> ph_en(1),
    I		=> ph_o(1),
    O		=> ph_i(1));  
  PAD_PH2_IDREQ2 : ZMA2GSC port map ( E2 => ph_hi, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH2_IDREQ2,
    E		=> ph_en(2),
    I		=> ph_o(2),
    O		=> ph_i(2));  
  PAD_PH3_IDREQ3 : ZMA2GSC port map ( E2 => ph_hi, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH3_IDREQ3,
    E		=> ph_en(3),
    I		=> ph_o(3),
    O		=> ph_i(3));  
  PAD_PH4_IDACK0 : ZMA2GSC port map ( E2 => ph_lo_n, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH4_IDACK0,
    E		=> ph_en(4),
    I		=> ph_o(4),
    O		=> ph_i(4));  
  PAD_PH5_IDACK1 : ZMA2GSC port map ( E2 => ph_lo_n, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH5_IDACK1,
    E		=> ph_en(5),
    I		=> ph_o(5),
    O		=> ph_i(5));  
  PAD_PH6_IDACK2 : ZMA2GSC port map ( E2 => ph_lo_n, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH6_IDACK2,
    E		=> ph_en(6),
    I		=> ph_o(6),
    O		=> ph_i(6));  
  PAD_PH7_IDACK3 : ZMA2GSC port map ( E2 => ph_lo_n, E4 => ph_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PH7_IDACK3,
    E		=> ph_en(7),
    I		=> ph_o(7),
    O		=> ph_i(7));  
  PAD_PC0_IDREQ4 : ZMA2GSC port map ( E2 => pc_hi, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC0_IDREQ4,
    E		=> pc_en(0),
    I		=> pc_o(0),
    O		=> pc_i(0));  
  PAD_PC1_IDREQ5 : ZMA2GSC port map ( E2 => pc_hi, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC1_IDREQ5,
    E		=> pc_en(1),
    I		=> pc_o(1),
    O		=> pc_i(1));  
  PAD_PC2_IDREQ6 : ZMA2GSC port map ( E2 => pc_hi, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC2_IDREQ6,
    E		=> pc_en(2),
    I		=> pc_o(2),
    O		=> pc_i(2));  
  PAD_PC3_IDREQ7 : ZMA2GSC port map ( E2 => pc_hi, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC3_IDREQ7,
    E		=> pc_en(3),
    I		=> pc_o(3),
    O		=> pc_i(3));  
  PAD_PC4_IDACK4 : ZMA2GSC port map ( E2 => pc_lo_n, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC4_IDACK4,
    E		=> pc_en(4),
    I		=> pc_o(4),
    O		=> pc_i(4));  
  PAD_PC5_IDACK5 : ZMA2GSC port map ( E2 => pc_lo_n, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC5_IDACK5,
    E		=> pc_en(5),
    I		=> pc_o(5),
    O		=> pc_i(5));  
  PAD_PC6_IDACK6 : ZMA2GSC port map ( E2 => pc_lo_n, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC6_IDACK6,
    E		=> pc_en(6),
    I		=> pc_o(6),
    O		=> pc_i(6));  
  PAD_PC7_IDACK7 : ZMA2GSC port map ( E2 => pc_lo_n, E4 => pc_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '1',
    IO	=> PC7_IDACK7,
    E		=> pc_en(7),
    I		=> pc_o(7),
    O		=> pc_i(7));  

	-- Bottom edge
  PAD_MBYPASS : XMD port map ( PU => '0', PD => '1', SMT => '1',
    I		=> MBYPASS,
    O		=> mbypass_i);
  PAD_MRESET : XMD port map ( PU => '1', PD => '0', SMT => '1',
    I		=> MRESET,
    O		=> mreset_i);
  PAD_MRSTOUT : YA2GSD port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MRSTOUT,
    E		=> '1',
    I		=> mrstout_o);
  PAD_MTEST : XMD port map ( PU => '0', PD => '1', SMT => '1',
    I		=> MTEST,
    O		=> mtest_i);
  PAD_MWAKE : XMD port map ( PU => '0', PD => '1', SMT => '1',
    I		=> MWAKE,
    O		=> mwake_i);
  PAD_MIRQ0 : XMD port map ( PU => '1', PD => '0', SMT => '1',
    I		=> MIRQ0,
    O		=> mirq0_i);
  PAD_MIRQ1 : XMD port map ( PU => '1', PD => '0', SMT => '1',
    I		=> MIRQ1,
    O		=> mirq1_i);
  PAD_MRXOUT : YA2GSD port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MRXOUT,
    E		=> '1',
    I		=> mrxout_o);
  PAD_PJ0_UTX1 : ZMA2GSD port map ( E2 => p1_hi, E4 => p1_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ0_UTX1,
    E		=> pj_en(0),
    I		=> pj_o(0),
    O		=> pj_i(0));
  PAD_PJ1_URX1 : ZMA2GSD port map ( E2 => p1_hi, E4 => p1_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ1_URX1,
    E		=> pj_en(1),
    I		=> pj_o(1),
    O		=> pj_i(1));
  PAD_PJ2_URTS1 : ZMA2GSD port map ( E2 => p1_hi, E4 => p1_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ2_URTS1,
    E		=> pj_en(2),
    I		=> pj_o(2),
    O		=> pj_i(2));
  PAD_PJ3_UCTS1 : ZMA2GSD port map ( E2 => p1_hi, E4 => p1_hi, E8 => '0', SR => p1_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PJ3_UCTS1,
    E		=> pj_en(3),
    I		=> pj_o(3),
    O		=> pj_i(3));  
  PAD_PE0_UTX2 : ZMA2GSD port map ( E2 => pel_hi, E4 => pel_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE0_UTX2,
    E		=> pe_en(0),
    I		=> pe_o(0),
    O		=> pe_i(0));
  PAD_PE1_URX2 : ZMA2GSD port map ( E2 => pel_hi, E4 => pel_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE1_URX2,
    E		=> pe_en(1),
    I		=> pe_o(1),
    O		=> pe_i(1));
  PAD_PE2_URTS2 : ZMA2GSD port map ( E2 => pel_hi, E4 => pel_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE2_URTS2,
    E		=> pe_en(2),
    I		=> pe_o(2),
    O		=> pe_i(2));
  PAD_PE3_UCTS2 : ZMA2GSD port map ( E2 => pel_hi, E4 => pel_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE3_UCTS2,
    E		=> pe_en(3),
    I		=> pe_o(3),
    O		=> pe_i(3));
  PAD_PE4_UTX3 : ZMA2GSD port map ( E2 => peh_hi, E4 => peh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE4_UTX3,
    E		=> pe_en(4),
    I		=> pe_o(4),
    O		=> pe_i(4));
  PAD_PE5_URX3 : ZMA2GSD port map ( E2 => peh_hi, E4 => peh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE5_URX3,
    E		=> pe_en(5),
    I		=> pe_o(5),
    O		=> pe_i(5));
  PAD_PE6_URTS3 : ZMA2GSD port map ( E2 => peh_hi, E4 => peh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE6_URTS3,
    E		=> pe_en(6),
    I		=> pe_o(6),
    O		=> pe_i(6));
  PAD_PE7_UCTS3 : ZMA2GSD port map ( E2 => peh_hi, E4 => peh_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PE7_UCTS3,
    E		=> pe_en(7),
    I		=> pe_o(7),
    O		=> pe_i(7));
  PAD_PF0_ETXEN : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF0_ETXEN,
    E		=> pf_en(0),
    I		=> pf_o(0),
    O		=> pf_i(0));
  PAD_PF1_ETXCLK : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF1_ETXCLK,
    E		=> pf_en(1),
    I		=> pf_o(1),
    O		=> pf_i(1));
  PAD_PF2_ETXD0 : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF2_ETXD0,
    E		=> pf_en(2),
    I		=> pf_o(2),
    O		=> pf_i(2));
  PAD_PF3_ETXD1 : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF3_ETXD1,
    E		=> pf_en(3),
    I		=> pf_o(3),
    O		=> pf_i(3));
  PAD_PF4_ERXDV : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF4_ERXDV,
    E		=> pf_en(4),
    I		=> pf_o(4),
    O		=> pf_i(4));
  PAD_PF5_ERXER : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF5_ERXER,
    E		=> pf_en(5),
    I		=> pf_o(5),
    O		=> pf_i(5));
  PAD_PF6_ERXD0 : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF6_ERXD0,
    E		=> pf_en(6),
    I		=> pf_o(6),
    O		=> pf_i(6));
  PAD_PF7_ERXD1 : ZMA2GSD port map ( E2 => pf_hi, E4 => pf_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PF7_ERXD1,
    E		=> pf_en(7),
    I		=> pf_o(7),
    O		=> pf_i(7));
  PAD_PG0_ETXER : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG0_ETXER,
    E		=> pg_en(0),
    I		=> pg_o(0),
    O		=> pg_i(0));
  PAD_PG1_ERXCLK : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG1_ERXCLK,
    E		=> pg_en(1),
    I		=> pg_o(1),
    O		=> pg_i(1));
  PAD_PG2_ETXD2 : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG2_ETXD2,
    E		=> pg_en(2),
    I		=> pg_o(2),
    O		=> pg_i(2));
  PAD_PG3_ETXD3 : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG3_ETXD3,
    E		=> pg_en(3),
    I		=> pg_o(3),
    O		=> pg_i(3));
  PAD_PG4_ECOL : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG4_ECOL,
    E		=> pg_en(4),
    I		=> pg_o(4),
    O		=> pg_i(4));
  PAD_PG5_ECRS : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG5_ECRS,
    E		=> pg_en(5),
    I		=> pg_o(5),
    O		=> pg_i(5));
  PAD_PG6_ERXD2 : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG6_ERXD2,
    E		=> pg_en(6),
    I		=> pg_o(6),
    O		=> pg_i(6));

	-- Right edge
  PAD_PG7_ERXD3 : ZMA2GSD port map ( E2 => pg_hi, E4 => pg_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PG7_ERXD3,
    E		=> pg_en(7),
    I		=> pg_o(7),
    O		=> pg_i(7));
  PAD_PA0 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA0,
    E		=> pa_en(0),
    I		=> pa_o(0),
    O		=> pa_i(0));  
  PAD_PA1 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA1,
    E		=> pa_en(1),
    I		=> pa_o(1),
    O		=> pa_i(1));
  PAD_PA2 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA2,
    E		=> pa_en(2),
    I		=> pa_o(2),
    O		=> pa_i(2));
  PAD_PA3 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA3,
    E		=> pa_en(3),
    I		=> pa_o(3),
    O		=> pa_i(3));
  PAD_PA4 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA4,
    E		=> pa_en(4),
    I		=> pa_o(4),
    O		=> pa_i(4));
  PAD_PA5 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA5,
    E		=> pa_en(5),
    I		=> pa_o(5),
    O		=> pa_i(5));
  PAD_PA6 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA6,
    E		=> pa_en(6),
    I		=> pa_o(6),
    O		=> pa_i(6));
  PAD_PA7 : ZMA2GSD port map ( E2 => p2_hi, E4 => p2_hi, E8 => '0', SR => p2_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PA7,
    E		=> pa_en(7),
    I		=> pa_o(7),
    O		=> pa_i(7));
  PAD_PB0 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB0,
    E		=> pb_en(0),
    I		=> pb_o(0),
    O		=> pb_i(0));
  PAD_PB1 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB1,
    E		=> pb_en(1),
    I		=> pb_o(1),
    O		=> pb_i(1));
  PAD_PB2 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB2,
    E		=> pb_en(2),
    I		=> pb_o(2),
    O		=> pb_i(2));
  PAD_PB3 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB3,
    E		=> pb_en(3),
    I		=> pb_o(3),
    O		=> pb_i(3));
  PAD_PB4 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB4,
    E		=> pb_en(4),
    I		=> pb_o(4),
    O		=> pb_i(4));  
  PAD_PB5 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB5,
    E		=> pb_en(5),
    I		=> pb_o(5),
    O		=> pb_i(5));  
  PAD_PB6 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB6,
    E		=> pb_en(6),
    I		=> pb_o(6),
    O		=> pb_i(6));  
  PAD_PB7 : ZMA2GSD port map ( E2 => p3_hi, E4 => p3_hi, E8 => '0', SR => p3_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> PB7,
    E		=> pb_en(7),
    I		=> pb_o(7),
    O		=> pb_i(7));  

	-- Top edge
  PAD_DDQ0 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ0,
    E		=> ddq_en,
    I		=> ddq_o(0),
    O		=> ddq_i(0));
  PAD_DDQ1 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ1,
    E		=> ddq_en,
    I		=> ddq_o(1),
    O		=> ddq_i(1));  
  PAD_DDQ2 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ2,
    E		=> ddq_en,
    I		=> ddq_o(2),
    O		=> ddq_i(2));  
  PAD_DDQ3 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ3,
    E		=> ddq_en,
    I		=> ddq_o(3),
    O		=> ddq_i(3));  
  PAD_DDQ4 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ4,
    E		=> ddq_en,
    I		=> ddq_o(4),
    O		=> ddq_i(4));  
  PAD_DDQ5 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ5,
    E		=> ddq_en,
    I		=> ddq_o(5),
    O		=> ddq_i(5));  
  PAD_DDQ6 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ6,
    E		=> ddq_en,
    I		=> ddq_o(6),
    O		=> ddq_i(6));  
  PAD_DDQ7 : ZMA2GSC port map ( E2 => '0', E4 => d_lo, E8 => d_hi, SR => d_sr, PU => '0', PD => '0', SMT => '0',
    IO	=> DDQ7,
    E		=> ddq_en,
    I		=> ddq_o(7),
    O		=> ddq_i(7));  
  PAD_DCLK : YA2GSC port map ( E2 => '1', E4 => '1', E8 => d_hi, SR => d_sr,
    O		=> DCLK,
    E		=> '1',
    I		=> dclk_o);
  PAD_DCS : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DCS,
    E		=> '1',
    I		=> dcs_o);
  PAD_DRAS : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DRAS,
    E		=> '1',
    I		=> dras_o);
  PAD_DCAS : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DCAS,
    E		=> '1',
    I		=> dcas_o);
  PAD_DWE : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DWE,
    E		=> '1',
    I		=> dwe_o);
  PAD_DBA0 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DBA0,
    E		=> '1',
    I		=> dba_o(0));
  PAD_DBA1 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DBA1,
    E		=> '1',
    I		=> dba_o(1));
  PAD_DA0 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA0,
    E		=> '1',
    I		=> da_o(0));
  PAD_DA1 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA1,
    E		=> '1',
    I		=> da_o(1));
  PAD_DA2 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA2,
    E		=> '1',
    I		=> da_o(2));
  PAD_DA3 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA3,
    E		=> '1',
    I		=> da_o(3));
  PAD_DA4 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA4,
    E		=> '1',
    I		=> da_o(4));
  PAD_DA5 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA5,
    E		=> '1',
    I		=> da_o(5));
  PAD_DA6 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA6,
    E		=> '1',
    I		=> da_o(6));
  PAD_DA7 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA7,
    E		=> '1',
    I		=> da_o(7));
  PAD_DA8 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA8,
    E		=> '1',
    I		=> da_o(8));
  PAD_DA9 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA9,
    E		=> '1',
    I		=> da_o(9));
  PAD_DA10 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA10,
    E		=> '1',
    I		=> da_o(10));
  PAD_DA11 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA11,
    E		=> '1',
    I		=> da_o(11));
  PAD_DA12 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA12,
    E		=> '1',
    I		=> da_o(12));
  PAD_DA13 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DA13,
    E		=> '1',
    I		=> da_o(13));
  PAD_DCKE0 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DCKE0,
    E		=> '1',
    I		=> dcke_o(0));
  PAD_DCKE1 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DCKE1,
    E		=> '1',
    I		=> dcke_o(1));
  PAD_DCKE2 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DCKE2,
    E		=> '1',
    I		=> dcke_o(2));
  PAD_DCKE3 : YA2GSC port map ( E2 => '1', E4 => d_hi, E8 => '0', SR => d_sr,
    O		=> DCKE3,
    E		=> '1',
    I		=> dcke_o(3));  
  PAD_MPORDIS : XMC port map ( PU => '0', PD => '1', SMT => '1',
    I		=> MPORDIS,
    O		=> mpordis_i);  
  PAD_MPLL_TSTO : YA2GSC port map ( E2 => '0', E4 => '0', E8 => '0', SR => '0',
    O		=> MPLL_TSTO,
    E		=> mpll_tsto_en,
    I		=> mpll_tsto_o);

end struct;

    














