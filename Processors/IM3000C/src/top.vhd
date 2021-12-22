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
-- Title      : Top level
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : top.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Top level model which instantiates the core, memories 
--              and other blocks as well as pad blocks.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.18			CB			Created.
-- 2005-12-20		3.00			CB			Updated for GP3000.
-- 2006-02-01		3.01			CB			Added the ld_bmem signal.
-- 2006-02-15		3.02			CB			Removed en_eth port from clk_gen.
-- 2006-02-17		3.03			CB			Added soft drive strength and slew rate control.
-- 2006-03-09		3.04 			CB			Changed pwr_on to pwr_ok, and en_bmem to
--																dis_bmem. Replaced port dac_bits on the
--																ANALOG block with dac0_bits, dac1_bits.
--																Removed adc_fb and dac_clk, added dac_en,
--																adc_en, adc_ref2v, adc_extref, adc_diff.
--																Removed VSEL, VEXT, added VREGEN. Renamed
--																VREFOUT to EXTREF, changed direction from out
--																to inout. Changed vdd_rtc to VCC18LP.
-- 2006-03-17		3.05 			CB			Added test_pll.
-- 2006-03-21		3.06 			CB			Removed the en_c signal and added sel_pll.
--																sel_pll now goes to the clk_gen block to
--																select source for clk_p instead of en_pll,
--																rst_cn controls clk_c gating instead of en_c.
--																Added rst_n from core to clk_gen, needed for
--																clock switching logic. Changed the PLL feed-
--																back from clk_p to pllout (since clk_p can
--																have XOSC frequency whil PLL is on).
-- 2006-04-03		3.07 			CB			Removed 'freeze' and 'locked', PLL doesn't
--																support them.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity top is
  port (
		-- Left edge
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
		-- Bottom edge
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
		PG7_ERXD3 		: inout std_logic;
		-- Right edge
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
		VREGEN 				: in	std_logic;                  
		ACH0					: in	std_logic;	-- Analog                  
		ACH1					: in	std_logic;	-- Analog                  
		ACH2					: in	std_logic;	-- Analog                  
		ACH3					: in	std_logic;	-- Analog                  
		ACH4					: in	std_logic;	-- Analog                  
		ACH5					: in	std_logic;	-- Analog                  
		ACH6					: in	std_logic;	-- Analog                  
		ACH7					: in	std_logic;	-- Analog                  
		AOUT0					: out	std_logic;	-- Analog                  
		AOUT1					: out	std_logic;	-- Analog                  
		-- Top edge
		EXTREF				: inout	std_logic;	-- Analog                  
		XTAL1					: in	std_logic;                  
		XTAL2					: out	std_logic;                  
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
		MPLL_TSTO			: inout std_logic);                  
end top;

architecture struct of top is
  -----------------------------------------------------------------------------
  -- Externally supplied components
  -----------------------------------------------------------------------------
  -- Bus holder cell
  component BHD1
    port (
      H : inout std_logic);
  end component;

  -- PLL
	component FXPLL031HA0A_APGD
		port (
			CKOUT  	: out   std_logic;	-- PLL output to clock buffer
			TCKO		: out   std_logic;
			CIN			: in    std_logic;	-- Feedback from clock buffer output
			FREF		: in    std_logic;	-- Reference clock input
			TEST		: in    std_logic;
			FRANGE	: in    std_logic;
			PDN			: in    std_logic;	-- Power down PLL
			TCKI		: in    std_logic;
			NS0			: in    std_logic;	-- Frequency multiplier
			NS1			: in    std_logic;
			NS2			: in    std_logic;
			NS3			: in    std_logic;
			NS4			: in    std_logic;
			NS5			: in    std_logic;
			MS0			: in    std_logic;	-- Frequency divider
			MS1			: in    std_logic;
			MS2			: in    std_logic;
			MS3			: in    std_logic;
			MS4			: in    std_logic;
			MS5			: in    std_logic);
	end component;

  -- mprom0
	component SP180_4096X80BM1B
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			A8		:	in	std_logic; 
			A9		:	in	std_logic; 
			A10		:	in	std_logic;
			A11		:	in	std_logic;
			DO0		: out std_logic;
			DO1		: out std_logic;
			DO2		: out std_logic;
			DO3		: out std_logic;
			DO4		: out std_logic;
			DO5		: out std_logic;
			DO6		: out std_logic;
			DO7		: out std_logic;
			DO8		: out std_logic;
			DO9		: out std_logic;
			DO10	: out std_logic;
			DO11	: out std_logic;
			DO12	: out std_logic;
			DO13	: out std_logic;
			DO14	: out std_logic;
			DO15	: out std_logic;
			DO16	: out std_logic;
			DO17	: out std_logic;
			DO18	: out std_logic;
			DO19	: out std_logic;
			DO20	: out std_logic;
			DO21	: out std_logic;
			DO22	: out std_logic;
			DO23	: out std_logic;
			DO24	: out std_logic;
			DO25	: out std_logic;
			DO26	: out std_logic;
			DO27	: out std_logic;
			DO28	: out std_logic;
			DO29	: out std_logic;
			DO30	: out std_logic;
			DO31	: out std_logic;
			DO32	: out std_logic;
			DO33	: out std_logic;
			DO34	: out std_logic;
			DO35	: out std_logic;
			DO36	: out std_logic;
			DO37	: out std_logic;
			DO38	: out std_logic;
			DO39	: out std_logic;
			DO40	: out std_logic;
			DO41	: out std_logic;
			DO42	: out std_logic;
			DO43	: out std_logic;
			DO44	: out std_logic;
			DO45	: out std_logic;
			DO46	: out std_logic;
			DO47	: out std_logic;
			DO48	: out std_logic;
			DO49	: out std_logic;
			DO50	: out std_logic;
			DO51	: out std_logic;
			DO52	: out std_logic;
			DO53	: out std_logic;
			DO54	: out std_logic;
			DO55	: out std_logic;
			DO56	: out std_logic;
			DO57	: out std_logic;
			DO58	: out std_logic;
			DO59	: out std_logic;
			DO60	: out std_logic;
			DO61	: out std_logic;
			DO62	: out std_logic;
			DO63	: out std_logic;
			DO64	: out std_logic;
			DO65	: out std_logic;
			DO66	: out std_logic;
			DO67	: out std_logic;
			DO68	: out std_logic;
			DO69	: out std_logic;
			DO70	: out std_logic;
			DO71	: out std_logic;
			DO72	: out std_logic;
			DO73	: out std_logic;
			DO74	: out std_logic;
			DO75	: out std_logic;
			DO76	: out std_logic;
			DO77	: out std_logic;
			DO78	: out std_logic;
			DO79	: out std_logic;
			CK		:	in	std_logic;
			CS		:	in	std_logic;
			OE		:	in	std_logic);
	end component;
  
  -- mprom1
	component SP180_4096X80BM1C
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			A8		:	in	std_logic; 
			A9		:	in	std_logic; 
			A10		:	in	std_logic;
			A11		:	in	std_logic;
			DO0		: out std_logic;
			DO1		: out std_logic;
			DO2		: out std_logic;
			DO3		: out std_logic;
			DO4		: out std_logic;
			DO5		: out std_logic;
			DO6		: out std_logic;
			DO7		: out std_logic;
			DO8		: out std_logic;
			DO9		: out std_logic;
			DO10	: out std_logic;
			DO11	: out std_logic;
			DO12	: out std_logic;
			DO13	: out std_logic;
			DO14	: out std_logic;
			DO15	: out std_logic;
			DO16	: out std_logic;
			DO17	: out std_logic;
			DO18	: out std_logic;
			DO19	: out std_logic;
			DO20	: out std_logic;
			DO21	: out std_logic;
			DO22	: out std_logic;
			DO23	: out std_logic;
			DO24	: out std_logic;
			DO25	: out std_logic;
			DO26	: out std_logic;
			DO27	: out std_logic;
			DO28	: out std_logic;
			DO29	: out std_logic;
			DO30	: out std_logic;
			DO31	: out std_logic;
			DO32	: out std_logic;
			DO33	: out std_logic;
			DO34	: out std_logic;
			DO35	: out std_logic;
			DO36	: out std_logic;
			DO37	: out std_logic;
			DO38	: out std_logic;
			DO39	: out std_logic;
			DO40	: out std_logic;
			DO41	: out std_logic;
			DO42	: out std_logic;
			DO43	: out std_logic;
			DO44	: out std_logic;
			DO45	: out std_logic;
			DO46	: out std_logic;
			DO47	: out std_logic;
			DO48	: out std_logic;
			DO49	: out std_logic;
			DO50	: out std_logic;
			DO51	: out std_logic;
			DO52	: out std_logic;
			DO53	: out std_logic;
			DO54	: out std_logic;
			DO55	: out std_logic;
			DO56	: out std_logic;
			DO57	: out std_logic;
			DO58	: out std_logic;
			DO59	: out std_logic;
			DO60	: out std_logic;
			DO61	: out std_logic;
			DO62	: out std_logic;
			DO63	: out std_logic;
			DO64	: out std_logic;
			DO65	: out std_logic;
			DO66	: out std_logic;
			DO67	: out std_logic;
			DO68	: out std_logic;
			DO69	: out std_logic;
			DO70	: out std_logic;
			DO71	: out std_logic;
			DO72	: out std_logic;
			DO73	: out std_logic;
			DO74	: out std_logic;
			DO75	: out std_logic;
			DO76	: out std_logic;
			DO77	: out std_logic;
			DO78	: out std_logic;
			DO79	: out std_logic;
			CK		:	in	std_logic;
			CS		:	in	std_logic;
			OE		:	in	std_logic);
	end component;
  
  -- mpram0, mpram1
	component SU180_2048X80X1BM1
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			A8		:	in	std_logic; 
			A9		:	in	std_logic; 
			A10		:	in	std_logic;
			DO0		: out std_logic;
			DO1		: out std_logic;
			DO2		: out std_logic;
			DO3		: out std_logic;
			DO4		: out std_logic;
			DO5		: out std_logic;
			DO6		: out std_logic;
			DO7		: out std_logic;
			DO8		: out std_logic;
			DO9		: out std_logic;
			DO10	: out std_logic;
			DO11	: out std_logic;
			DO12	: out std_logic;
			DO13	: out std_logic;
			DO14	: out std_logic;
			DO15	: out std_logic;
			DO16	: out std_logic;
			DO17	: out std_logic;
			DO18	: out std_logic;
			DO19	: out std_logic;
			DO20	: out std_logic;
			DO21	: out std_logic;
			DO22	: out std_logic;
			DO23	: out std_logic;
			DO24	: out std_logic;
			DO25	: out std_logic;
			DO26	: out std_logic;
			DO27	: out std_logic;
			DO28	: out std_logic;
			DO29	: out std_logic;
			DO30	: out std_logic;
			DO31	: out std_logic;
			DO32	: out std_logic;
			DO33	: out std_logic;
			DO34	: out std_logic;
			DO35	: out std_logic;
			DO36	: out std_logic;
			DO37	: out std_logic;
			DO38	: out std_logic;
			DO39	: out std_logic;
			DO40	: out std_logic;
			DO41	: out std_logic;
			DO42	: out std_logic;
			DO43	: out std_logic;
			DO44	: out std_logic;
			DO45	: out std_logic;
			DO46	: out std_logic;
			DO47	: out std_logic;
			DO48	: out std_logic;
			DO49	: out std_logic;
			DO50	: out std_logic;
			DO51	: out std_logic;
			DO52	: out std_logic;
			DO53	: out std_logic;
			DO54	: out std_logic;
			DO55	: out std_logic;
			DO56	: out std_logic;
			DO57	: out std_logic;
			DO58	: out std_logic;
			DO59	: out std_logic;
			DO60	: out std_logic;
			DO61	: out std_logic;
			DO62	: out std_logic;
			DO63	: out std_logic;
			DO64	: out std_logic;
			DO65	: out std_logic;
			DO66	: out std_logic;
			DO67	: out std_logic;
			DO68	: out std_logic;
			DO69	: out std_logic;
			DO70	: out std_logic;
			DO71	: out std_logic;
			DO72	: out std_logic;
			DO73	: out std_logic;
			DO74	: out std_logic;
			DO75	: out std_logic;
			DO76	: out std_logic;
			DO77	: out std_logic;
			DO78	: out std_logic;
			DO79	: out std_logic;
			DI0		: in std_logic;
			DI1		: in std_logic;
			DI2		: in std_logic;
			DI3		: in std_logic;
			DI4		: in std_logic;
			DI5		: in std_logic;
			DI6		: in std_logic;
			DI7		: in std_logic;
			DI8		: in std_logic;
			DI9		: in std_logic;
			DI10	: in std_logic;
			DI11	: in std_logic;
			DI12	: in std_logic;
			DI13	: in std_logic;
			DI14	: in std_logic;
			DI15	: in std_logic;
			DI16	: in std_logic;
			DI17	: in std_logic;
			DI18	: in std_logic;
			DI19	: in std_logic;
			DI20	: in std_logic;
			DI21	: in std_logic;
			DI22	: in std_logic;
			DI23	: in std_logic;
			DI24	: in std_logic;
			DI25	: in std_logic;
			DI26	: in std_logic;
			DI27	: in std_logic;
			DI28	: in std_logic;
			DI29	: in std_logic;
			DI30	: in std_logic;
			DI31	: in std_logic;
			DI32	: in std_logic;
			DI33	: in std_logic;
			DI34	: in std_logic;
			DI35	: in std_logic;
			DI36	: in std_logic;
			DI37	: in std_logic;
			DI38	: in std_logic;
			DI39	: in std_logic;
			DI40	: in std_logic;
			DI41	: in std_logic;
			DI42	: in std_logic;
			DI43	: in std_logic;
			DI44	: in std_logic;
			DI45	: in std_logic;
			DI46	: in std_logic;
			DI47	: in std_logic;
			DI48	: in std_logic;
			DI49	: in std_logic;
			DI50	: in std_logic;
			DI51	: in std_logic;
			DI52	: in std_logic;
			DI53	: in std_logic;
			DI54	: in std_logic;
			DI55	: in std_logic;
			DI56	: in std_logic;
			DI57	: in std_logic;
			DI58	: in std_logic;
			DI59	: in std_logic;
			DI60	: in std_logic;
			DI61	: in std_logic;
			DI62	: in std_logic;
			DI63	: in std_logic;
			DI64	: in std_logic;
			DI65	: in std_logic;
			DI66	: in std_logic;
			DI67	: in std_logic;
			DI68	: in std_logic;
			DI69	: in std_logic;
			DI70	: in std_logic;
			DI71	: in std_logic;
			DI72	: in std_logic;
			DI73	: in std_logic;
			DI74	: in std_logic;
			DI75	: in std_logic;
			DI76	: in std_logic;
			DI77	: in std_logic;
			DI78	: in std_logic;
			DI79	: in std_logic;
			WEB	: in	std_logic;
			CK	: in	std_logic;
			CS	: in	std_logic;
			OE	: in	std_logic);
	end component;
  
  -- gmem, iomem0, iomem1
	component SY180_1024X8X1CM8
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			A8		:	in	std_logic; 
			A9		:	in	std_logic; 
			DO0		: out std_logic;
			DO1		: out std_logic;
			DO2		: out std_logic;
			DO3		: out std_logic;
			DO4		: out std_logic;
			DO5		: out std_logic;
			DO6		: out std_logic;
			DO7		: out std_logic;
			DI0		: in std_logic;
			DI1		: in std_logic;
			DI2		: in std_logic;
			DI3		: in std_logic;
			DI4		: in std_logic;
			DI5		: in std_logic;
			DI6		: in std_logic;
			DI7		: in std_logic;
			WEB	: in	std_logic;
			CK	: in	std_logic;
			CSB	: in	std_logic);
	end component;
  
  -- trcmem
	component SY180_256X32X1CM4
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			DO0		: out std_logic;
			DO1		: out std_logic;
			DO2		: out std_logic;
			DO3		: out std_logic;
			DO4		: out std_logic;
			DO5		: out std_logic;
			DO6		: out std_logic;
			DO7		: out std_logic;
			DO8		: out std_logic;
			DO9		: out std_logic;
			DO10	: out std_logic;
			DO11	: out std_logic;
			DO12	: out std_logic;
			DO13	: out std_logic;
			DO14	: out std_logic;
			DO15	: out std_logic;
			DO16	: out std_logic;
			DO17	: out std_logic;
			DO18	: out std_logic;
			DO19	: out std_logic;
			DO20	: out std_logic;
			DO21	: out std_logic;
			DO22	: out std_logic;
			DO23	: out std_logic;
			DO24	: out std_logic;
			DO25	: out std_logic;
			DO26	: out std_logic;
			DO27	: out std_logic;
			DO28	: out std_logic;
			DO29	: out std_logic;
			DO30	: out std_logic;
			DO31	: out std_logic;
			DI0		: in std_logic;
			DI1		: in std_logic;
			DI2		: in std_logic;
			DI3		: in std_logic;
			DI4		: in std_logic;
			DI5		: in std_logic;
			DI6		: in std_logic;
			DI7		: in std_logic;
			DI8		: in std_logic;
			DI9		: in std_logic;
			DI10	: in std_logic;
			DI11	: in std_logic;
			DI12	: in std_logic;
			DI13	: in std_logic;
			DI14	: in std_logic;
			DI15	: in std_logic;
			DI16	: in std_logic;
			DI17	: in std_logic;
			DI18	: in std_logic;
			DI19	: in std_logic;
			DI20	: in std_logic;
			DI21	: in std_logic;
			DI22	: in std_logic;
			DI23	: in std_logic;
			DI24	: in std_logic;
			DI25	: in std_logic;
			DI26	: in std_logic;
			DI27	: in std_logic;
			DI28	: in std_logic;
			DI29	: in std_logic;
			DI30	: in std_logic;
			DI31	: in std_logic;
			WEB	: in	std_logic;
			CK	: in	std_logic;
			CSB	: in	std_logic);
	end component;
  
  -- pmem 
	component SY180_2048X2X1CM8
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			A8		:	in	std_logic; 
			A9		:	in	std_logic; 
			A10		:	in	std_logic;
			DO0		: out std_logic;
			DO1		: out std_logic;
			DI0		: in std_logic;
			DI1		: in std_logic;
			WEB	: in	std_logic;
			CK	: in	std_logic;
			CSB	: in	std_logic);
	end component;

  -- bmem 
	component SY180_512X8X1CM8
		port (
			A0		:	in	std_logic; 
			A1		:	in	std_logic; 
			A2		:	in	std_logic; 
			A3		:	in	std_logic; 
			A4		:	in	std_logic; 
			A5		:	in	std_logic; 
			A6		:	in	std_logic; 
			A7		:	in	std_logic; 
			A8		:	in	std_logic; 
			DO0		: out std_logic;
			DO1		: out std_logic;
			DO2		: out std_logic;
			DO3		: out std_logic;
			DO4		: out std_logic;
			DO5		: out std_logic;
			DO6		: out std_logic;
			DO7		: out std_logic;
			DI0		: in std_logic;
			DI1		: in std_logic;
			DI2		: in std_logic;
			DI3		: in std_logic;
			DI4		: in std_logic;
			DI5		: in std_logic;
			DI6		: in std_logic;
			DI7		: in std_logic;
			WEB	: in	std_logic;
			CK	: in	std_logic;
			CSB	: in	std_logic);
	end component;

  -----------------------------------------------------------------------------
  -- Pad block
  -----------------------------------------------------------------------------
	component pads
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
	end component;

  -----------------------------------------------------------------------------
  -- Analog block
  -----------------------------------------------------------------------------
  component analogtop
    port (
			-- Pad side
			XTAL1				: in	std_logic;                  
			XTAL2				: out	std_logic;                  
			VREGEN			: in	std_logic;                  
			EXTREF			: inout	std_logic;	-- Analog                  
			ACH0				: in	std_logic;	-- Analog                  
			ACH1				: in	std_logic;	-- Analog                  
			ACH2				: in	std_logic;	-- Analog                  
			ACH3				: in	std_logic;	-- Analog                  
			ACH4				: in	std_logic;	-- Analog                  
			ACH5				: in	std_logic;	-- Analog                  
			ACH6				: in	std_logic;	-- Analog                  
			ACH7				: in	std_logic;	-- Analog                  
			AOUT0				: out	std_logic;	-- Analog                  
			AOUT1				: out	std_logic;	-- Analog                  
			-- Internal side
			pwr_ok			: out	std_logic;	-- Power on detector output (active high)  
			dis_bmem		: in	std_logic;	-- Disable for vdd_bmem (active high)  
			vdd_bmem		: out	std_logic;	-- Power for the BMEM block  
			VCC18LP			: out	std_logic;	-- Power for the RTC block  
			rxout				: out	std_logic;	-- RTC oscillator output  
			ach_sel0		: in	std_logic;	-- ADC channel select, bit 0  
			ach_sel1		: in	std_logic;	-- ADC channel select, bit 1  
			ach_sel2		: in	std_logic;	-- ADC channel select, bit 2  
			adc_bits		: out	std_logic;	-- Bitstream from the analog part of ADC
      adc_ref2v		: in	std_logic;	-- Select 2V internal ADC reference (1V)
      adc_extref	: in	std_logic;	-- Select external ADC reference (internal)
      adc_diff		: in	std_logic;	-- Select differential ADC mode (single-ended)
      adc_en			: in	std_logic;	-- Enable for the ADC
			dac0_bits		: in	std_logic;	-- Bitstream to DAC0
			dac1_bits		: in	std_logic;	-- Bitstream to DAC1 
			dac0_en			: in	std_logic;	-- Enable for DAC0
			dac1_en			: in	std_logic;	-- Enable for DAC1 
			clk_a				: in	std_logic);	-- Clock to the DAC's and ADC  
  end component;
  
  -----------------------------------------------------------------------------
  -- Synthesis blocks (clk_gen, rtc, core and peri)
  -----------------------------------------------------------------------------
  -- Clock generation block
  component clk_gen
    port (
      -- Reset input
      rst_n     : in  std_logic;  -- Asynchronous, from core
      rst_cn    : in  std_logic;  -- Synchronized to clk_c, from core
      -- Clock inputs
      pllout    : in  std_logic;  -- Clock input from PLL
	    xout      : in  std_logic;  -- Clock input from reference oscillator
      erxclk    : in  std_logic;  -- Ethernet rx clock input from core
      etxclk    : in  std_logic;  -- Ethernet tx clock input from core
      -- Clock control inputs, from core
--	    en_eth    : in  std_logic_vector(1 downto 0);  -- Ethernet clock select
	    sel_pll   : in  std_logic;  -- Takes clk_p from PLL when high, else from osc
      en_d      : in  std_logic;  -- Enables clk_d when high
      fast_d    : in  std_logic;  -- High speed of DRAM clock when high
      din_e     : in  std_logic;  -- D input to the FF generating clk_e
      din_i     : in  std_logic;  -- D input to the FF generating clk_i
      din_u     : in  std_logic;  -- D input to the FF generating clk_u
      din_s     : in  std_logic;  -- D input to the FF generating clk_s
      din_a     : in  std_logic;  -- D input to the FF generating clk_a
      -- Buffered clock net outputs, to core 
      clk_p     : out std_logic;  -- PLL clock, also feedback to PLL
      clk_c     : out std_logic;  -- PLL clock with enable
      clk_c2    : out std_logic;  -- clk_c / 2 
      clk_e     : out std_logic;  -- Execution clock
      clk_i     : out std_logic;  -- I/O clock
      clk_d     : out std_logic;  -- DRAM clock
      clk_u     : out std_logic;  -- UART clock
      clk_s     : out std_logic;  -- SP clock
      clk_rx    : out std_logic;  -- ETH Rx clock
      clk_tx    : out std_logic;  -- ETH Tx clock
	    clk_a     : out std_logic); -- Analog clock
  end component;

  -- Real time counter (separately powered)
  component rtc 
    port (
      pwr_ok    : in  std_logic;  -- Core power indicator, controls mrxout_o
      rxout     : in  std_logic;  -- 32KHz oscillator input         
      mrxout_o  : out std_logic;  -- 32KHz oscillator output or external wake
      rst_rtc   : in  std_logic;  -- Reset RTC counter byte            
      en_fclk   : in  std_logic;  -- Enable fast clocking of RTC counter byte
      fclk      : in  std_logic;  -- Fast clock to RTC counter byte   
      ld_bmem   : in  std_logic;  -- Latch enable to the dis_bmem latch   
      rtc_sel   : in  std_logic_vector(2 downto 0);   -- RTC byte select
      rtc_data  : out std_logic_vector(7 downto 0);   -- RTC data             
	    dis_bmem  : out std_logic); -- Disable power to BMEM   
  end component;  

  -- Core
  component core
    port (
      ---------------------------------------------------------------------
      -- Signals to/from other blocks
      ---------------------------------------------------------------------
      -- Clocks to/from clock block
      clk_p       : in  std_logic;  -- PLL clock
      clk_c       : in  std_logic;  -- CP clock
      clk_c2      : in  std_logic;  -- clk_c / 2 
      clk_e       : in  std_logic;  -- Execution clock
      clk_i       : in  std_logic;  -- I/O clock
      clk_d       : in  std_logic;  -- DRAM clock
      clk_s       : in  std_logic;  -- SP clock
      -- Control outputs to the clock block
      rst_n       : out std_logic;  -- Asynchronous reset, to clk_gen
      rst_cn      : out std_logic;  -- Reset, will hold all clocks except c,rx,tx
      en_d        : out std_logic;  -- Enable clk_d
      fast_d      : out std_logic;  -- clk_d speed select 
      din_e       : out std_logic;  -- D input to FF generating clk_e
      din_i       : out std_logic;  -- D input to FF generating clk_i
      din_u       : out std_logic;  -- D input to FF generating clk_u
      din_s       : out std_logic;  -- D input to FF generating clk_s
      -- Control signals to/from the oscillator and PLL
      pll_frange  : out std_logic;  -- Frequency range select
      pll_n       : out std_logic_vector(5 downto 0);   -- Multiplier
      pll_m       : out std_logic_vector(2 downto 0);   -- Divider
      en_xosc     : out std_logic;  -- Enable XOSC 
      en_pll      : out std_logic;  -- Enable PLL 
      sel_pll     : out std_logic;  -- Select PLL as clock source
			test_pll    : out std_logic;  -- PLL in test mode
      xout        : in  std_logic;  -- XOSC ref. clock output
      -- Power on signal
      pwr_ok      : in  std_logic;  -- Power is on 
      -- BMEM block signals
 	    bmem_a8     : out  std_logic;
   	  bmem_q      : in   std_logic_vector(7 downto 0);
      bmem_d      : out  std_logic_vector(7 downto 0);
      bmem_we_n   : out  std_logic;
      bmem_ce_n   : out  std_logic;
      -- RTC block signals
      rst_rtc     : out std_logic;  -- Reset RTC counter byte
      en_fclk     : out std_logic;  -- Enable fast clocking of RTC counter byte
      fclk        : out std_logic;  -- Fast clock to RTC counter byte
      ld_bmem     : out std_logic;  -- Latch enable to the dis_bmem latch
      rtc_sel     : out std_logic_vector(2 downto 0);   -- RTC byte select
      rtc_data    : in  std_logic_vector(7 downto 0);   -- RTC data
      --  Signals to/from Peripheral block
      dfp         : in    std_logic_vector(7 downto 0); 
      dbus        : out   std_logic_vector(7 downto 0);
      rst_en      : out   std_logic;
      rst_en2     : out   std_logic;
      pd          : out   std_logic_vector(2 downto 0);  -- pl_pd
      aaddr       : out   std_logic_vector(4 downto 0);  -- pl_aaddr
      idack       : out   std_logic_vector(7 downto 0);
      ios_iden    : out   std_logic;                   
      ios_ido     : out   std_logic_vector(7 downto 0);                  
      ilioa       : out   std_logic;                   
      ildout      : out   std_logic;                   
      inext       : out   std_logic;
      iden        : in    std_logic;
      dqm_size    : out   std_logic_vector(1 downto 0);
      adc_dac     : out   std_logic;
      en_uart1    : out   std_logic;
      en_uart2    : out   std_logic;
      en_uart3    : out   std_logic;
      en_eth      : out   std_logic_vector(1 downto 0);
      en_tiu      : out   std_logic;
      run_tiu     : out   std_logic;
      en_tstamp   : out   std_logic_vector(1 downto 0);
      en_iobus    : out   std_logic_vector(1 downto 0);
      ddqm        : out   std_logic_vector(7  downto 0);
      idreq       : in    std_logic_vector(7 downto 0);
      idi         : in    std_logic_vector(7 downto 0);    
      irq0        : in	  std_logic;  -- Interrupt request 0   
      irq1        : in    std_logic;  -- Interrupt request 1   
      adc_ref2v		: out	  std_logic;	-- Select 2V internal ADC reference (1V)
      ---------------------------------------------------------------------
      -- Memory signals
      ---------------------------------------------------------------------
      -- MPROM signals
      mprom_a     : out std_logic_vector(13 downto 0);  -- Address  
      mprom_ce    : out std_logic_vector(1 downto 0);   -- Chip enable(active high) 
      mprom_oe    : out std_logic_vector(1 downto 0);   -- Output enable(active high) 
      -- MPRAM signals
      mpram_a     : out std_logic_vector(13 downto 0);  -- Address  
      mpram_d     : out std_logic_vector(79 downto 0);  -- Data to memory
      mpram_ce    : out std_logic_vector(1 downto 0);   -- Chip enable(active high)  
      mpram_oe    : out std_logic_vector(1 downto 0);   -- Output enable(active high)  
      mpram_we_n  : out std_logic;                      -- Write enable(active low) 
      -- MPROM/MPRAM data out bus
      mp_q        : in  std_logic_vector(79 downto 0);  -- Data from MPROM/MPRAM  
      -- GMEM signals
      gmem_a      : out std_logic_vector(9 downto 0);  
      gmem_d      : out std_logic_vector(7 downto 0);  
      gmem_q      : in  std_logic_vector(7 downto 0);
      gmem_ce_n   : out std_logic;                      
      gmem_we_n   : out std_logic;                      
      -- IOMEM signals
      iomem_a     : out std_logic_vector(9 downto 0);
      iomem_d     : out std_logic_vector(15 downto 0);
      iomem_q     : in  std_logic_vector(15 downto 0);
      iomem_ce_n  : out std_logic_vector(1 downto 0);
      iomem_we_n  : out std_logic;
      -- TRCMEM signals (Trace memory)
      trcmem_a    : out std_logic_vector(7 downto 0);
      trcmem_d    : out std_logic_vector(31 downto 0);
      trcmem_q    : in  std_logic_vector(31 downto 0);
      trcmem_ce_n : out std_logic;
      trcmem_we_n : out std_logic;
      -- PMEM signals (Patch memory)
      pmem_a      : out std_logic_vector(10 downto 0);
      pmem_d      : out std_logic_vector(1  downto 0);
      pmem_q      : in  std_logic_vector(1  downto 0);
      pmem_ce_n   : out std_logic;
      pmem_we_n   : out std_logic;
      ---------------------------------------------------------------------
      -- PADS
      ---------------------------------------------------------------------
      -- Misc. signals
      mpordis_i   : in  std_logic;  -- 'power on' from pad
      mreset_i    : in  std_logic;  -- Asynchronous reset input 
      mirqout_o   : out std_logic;  -- Interrupt  request output 
      mckout1_o   : out std_logic;  -- Programmable clock out 
      msdin_i     : in  std_logic;  -- Serial data in (debug) 
      msdout_o    : out std_logic;  -- Serial data out
      mrstout_o   : out std_logic;  -- Reset out
      mxout_o     : out std_logic;  -- Oscillator test output
      mexec_o     : out std_logic;  -- clk_e test output
      mtest_i     : in  std_logic;  -- Test mode
      mbypass_i   : in  std_logic;  -- bypass PLL
      mwake_i     : in  std_logic;  -- wake up
      -- DRAM signals
      dcs_o       : out std_logic;      -- Chip select
      dras_o      : out std_logic;      -- Row address strobe
      dcas_o      : out std_logic;      -- Column address strobe
      dwe_o       : out std_logic;      -- Write enable
      ddq_i       : in    std_logic_vector(7 downto 0); -- Data input bus
      ddq_o       : out std_logic_vector(7 downto 0);   -- Data output bus
      ddq_en      : out std_logic;      -- Data output bus enable
      da_o        : out std_logic_vector(13 downto 0);  -- Address
      dba_o       : out std_logic_vector(1 downto 0);   -- Bank address
      dcke_o      : out std_logic_vector(3 downto 0);   -- Clock enable
      -- Port A
      pa_i        : in  std_logic_vector(4 downto 0); 
			-- I/O cell configuration control outputs
	    d_hi        : out std_logic;	-- High drive on DRAM interface
	    d_sr        : out std_logic;	-- Slew rate limit on DRAM interface
	    d_lo        : out std_logic;	-- Low drive on DRAM interface
	    p1_hi       : out std_logic;	-- High drive on port group 1 pins
	    p1_sr       : out std_logic;	-- Slew rate limit on port group 1 pins
	    pc_hi       : out std_logic;	-- High drive on port C pins
	    pc_lo_n     : out std_logic;	-- Not low drive port C pins
	    ph_hi       : out std_logic;	-- High drive on port H pins
	    ph_lo_n     : out std_logic;	-- Not low drive port H pins
	    pi_hi       : out std_logic;	-- High drive on port I pins
	    pi_lo_n     : out std_logic;	-- Not low drive port I pins
	    p2_hi       : out std_logic;	-- High drive on port group 2 pins
	    p2_sr       : out std_logic;	-- Slew rate limit on port group 2 pins
	    pel_hi      : out std_logic;	-- High drive on low half of port E pins
	    peh_hi      : out std_logic;	-- High drive on high half of port E pins
	    pdll_hi     : out std_logic;	-- High drive low dibit, low half of port D
	    pdlh_hi     : out std_logic;	-- High drive high dibit, low half of port D
	    pdh_hi      : out std_logic;	-- High drive on high half of port D pins
	    p3_hi       : out std_logic;	-- High drive on port group 3 pins
	    p3_sr       : out std_logic;	-- Slew rate limit on port group 3 pins
	    pf_hi       : out std_logic;	-- High drive on port F pins
	    pg_hi       : out std_logic);	-- High drive on port G pins
  end component;

  -- Peripherals
  component peri 
    port (
      ---------------------------------------------------------------------
      -- Signals to/from other blocks
      ---------------------------------------------------------------------
      -- Clocks to/from clk_gen block
      clk_c       : in  std_logic;
      clk_e       : in  std_logic;  -- Execution clock
      clk_i       : in  std_logic;  -- I/O clock    
      clk_u       : in  std_logic;  -- UART clock
      clk_rx      : in  std_logic;  -- Ethernet receive clock
      clk_tx      : in  std_logic;  -- Ethernet transmit clock
      clk_a       : in  std_logic;  -- Analog clock
      erxclk      : out std_logic;  -- go to clock buffer
      etxclk      : out std_logic;  -- go to clock buffer
      din_a       : out std_logic;  -- D input to FF generating clk_a
      -- to/from core block
      dbus        : in  std_logic_vector(7 downto 0);
      dfp         : out std_logic_vector(7 downto 0); 
      rst_en      : in  std_logic;
      rst_en2     : in  std_logic;
      pl_pd       : in  std_logic_vector(2 downto 0);
      pl_aaddr    : in  std_logic_vector(4 downto 0);
      idack       : in  std_logic_vector(7 downto 0);
      ios_iden    : in  std_logic;                   
      ios_ido     : in  std_logic_vector(7 downto 0);                  
      ilioa       : in  std_logic;                   
      ildout      : in  std_logic;                   
      inext       : in  std_logic;
      iden        : out std_logic;
      dqm_size    : in  std_logic_vector(1 downto 0);
      en_uart1    : in  std_logic;
      en_uart2    : in  std_logic;
      en_uart3    : in  std_logic;
      en_tiu      : in  std_logic;
      run_tiu     : in  std_logic;
      en_eth      : in  std_logic_vector(1 downto 0);
      en_iobus    : in  std_logic_vector(1 downto 0);
      ddqm        : in  std_logic_vector(7  downto 0);
      idreq       : out std_logic_vector(7 downto 0);
      idi         : out std_logic_vector(7 downto 0);
      irq0        : out std_logic;
      irq1        : out std_logic;
      tstamp      : out std_logic_vector(2 downto 0);
	    -- to/from analog block
  	  ach_sel     : out std_logic_vector(2 downto 0);
      adc_bits		: in	std_logic;
      adc_extref	: out	std_logic;
      adc_diff		: out	std_logic;
      adc_en			: out	std_logic;
      dac_bits		: out	std_logic_vector(0 to 1);
      dac_en			: out	std_logic_vector(0 to 1);
      ---------------------------------------------------------------------
      -- PADS
      ---------------------------------------------------------------------
  	  -- External interrupt pins
	    mirq0_i     : in  std_logic;
	    mirq1_i     : in  std_logic;
      -- Port A,B,C,D,E,F,G,H,I,J
      pa_i        : in  std_logic_vector(7 downto 0); 
      pa_en       : out std_logic_vector(7 downto 0); 
      pa_o        : out std_logic_vector(7 downto 0); 
      pb_i        : in  std_logic_vector(7 downto 0); 
      pb_en       : out std_logic_vector(7 downto 0); 
      pb_o        : out std_logic_vector(7 downto 0); 
      pc_i        : in  std_logic_vector(7 downto 0); 
      pc_en       : out std_logic_vector(7 downto 0); 
      pc_o        : out std_logic_vector(7 downto 0); 
      pd_i        : in  std_logic_vector(7 downto 0); 
      pd_en       : out std_logic_vector(7 downto 0); 
      pd_o        : out std_logic_vector(7 downto 0); 
      pe_i        : in  std_logic_vector(7 downto 0); 
      pe_en       : out std_logic_vector(7 downto 0); 
      pe_o        : out std_logic_vector(7 downto 0); 
      pf_i        : in  std_logic_vector(7 downto 0); 
      pf_en       : out std_logic_vector(7 downto 0); 
      pf_o        : out std_logic_vector(7 downto 0); 
      pg_i        : in  std_logic_vector(7 downto 0); 
      pg_en       : out std_logic_vector(7 downto 0); 
      pg_o        : out std_logic_vector(7 downto 0); 
      ph_i        : in  std_logic_vector(7 downto 0); 
      ph_en       : out std_logic_vector(7 downto 0); 
      ph_o        : out std_logic_vector(7 downto 0); 
      pi_i        : in  std_logic_vector(7 downto 0); 
      pi_en       : out std_logic_vector(7 downto 0); 
      pi_o        : out std_logic_vector(7 downto 0); 
      pj_i        : in  std_logic_vector(7 downto 0); 
      pj_en       : out std_logic_vector(7 downto 0); 
      pj_o        : out std_logic_vector(7 downto 0));
  end component;  

  -----------------------------------------------------------------------------
  -- Internal signals driven by (i.e. "output" from) each block 
  -----------------------------------------------------------------------------
  -- PLL                                           
  signal pllout       : std_logic;                         
  signal tcko         : std_logic;                         
  signal const_0      : std_logic;                         
                                                           
  -- Pad block
  signal xout         : std_logic;
  signal msdin_i      : std_logic;                         
  signal pd_i         : std_logic_vector(7 downto 0);      
  signal pj_i         : std_logic_vector(7 downto 0);      
  signal pi_i         : std_logic_vector(7 downto 0);      
  signal ph_i         : std_logic_vector(7 downto 0);      
  signal pc_i         : std_logic_vector(7 downto 0);      
  signal mbypass_i    : std_logic;                         
  signal mreset_i     : std_logic;                         
  signal mtest_i      : std_logic;                         
  signal mwake_i      : std_logic;                         
  signal mirq0_i      : std_logic;                         
  signal mirq1_i      : std_logic;                         
  signal pe_i         : std_logic_vector(7 downto 0);      
  signal pf_i         : std_logic_vector(7 downto 0);      
  signal pg_i         : std_logic_vector(7 downto 0);      
  signal pa_i         : std_logic_vector(7 downto 0);      
  signal pb_i         : std_logic_vector(7 downto 0);      
  signal ddq_i        : std_logic_vector(7 downto 0);      
  signal mpordis_i    : std_logic;                         

  -- Analog block                                         
  signal pwr_ok       : std_logic;                         
  signal rxout        : std_logic;                         
  signal adc_bits_int : std_logic;                         
  signal adc_bits     : std_logic;                         

  -- Core clock buffers
  signal clk_d  : std_logic;
  signal clk_c  : std_logic;
  signal clk_c2 : std_logic;  
  signal clk_s  : std_logic;
  signal clk_u  : std_logic;
  signal clk_i  : std_logic;
  signal clk_e  : std_logic;
  signal clk_p  : std_logic;
  signal clk_rx : std_logic;  
  signal clk_tx : std_logic;
  signal clk_a  : std_logic;
  
  -- RTC block
  signal mrxout_o : std_logic;
  signal rtc_data : std_logic_vector(7 downto 0); 
  signal dis_bmem : std_logic;

  -----------------------------------------------------------------------------
  -- core/peri driven signals
  -----------------------------------------------------------------------------
  -- Signals to other blocks
  signal pll_frange   : std_logic;
  signal pll_n        : std_logic_vector(5 downto 0);
  signal pll_m        : std_logic_vector(2 downto 0);
  signal en_xosc      : std_logic;
  signal en_pll       : std_logic;
  signal sel_pll      : std_logic;
  signal test_pll     : std_logic;
  signal erxclk       : std_logic;
  signal etxclk       : std_logic;
  signal rst_n        : std_logic;    
  signal rst_cn       : std_logic;    
  signal en_d         : std_logic;    
  signal fast_d       : std_logic;    
  signal din_e        : std_logic;    
  signal din_i        : std_logic;    
  signal din_u        : std_logic;    
  signal din_s        : std_logic;    
  signal din_a        : std_logic;    
  signal bmem_a8      : std_logic;    
  signal bmem_d       : std_logic_vector(7 downto 0);    
  signal bmem_we_n    : std_logic;    
  signal bmem_ce_n    : std_logic;    
  signal rst_rtc      : std_logic; 
  signal en_fclk      : std_logic; 
  signal fclk         : std_logic;
  signal ld_bmem      : std_logic;
  signal rtc_sel      : std_logic_vector(2 downto 0);
  signal ach_sel      : std_logic_vector(2 downto 0);
  signal adc_ref2v    : std_logic;
  signal adc_extref   : std_logic;
  signal adc_diff     : std_logic;
  signal adc_en       : std_logic;
  signal dac_bits     : std_logic_vector(0 to 1);
  signal dac_en       : std_logic_vector(0 to 1);
  signal en_tstamp    : std_logic_vector(1 downto 0);
  signal tstamp       : std_logic_vector(2 downto 0);
  signal mpll_tsto_o  : std_logic;                         
  signal adc_dac      : std_logic;                         
  -- to memories signals
  signal mprom_a       : std_logic_vector(13 downto 0); 
  signal mprom_ce      : std_logic_vector(1 downto 0);  
  signal mprom_oe      : std_logic_vector(1 downto 0);
  signal mpram_a       : std_logic_vector(13 downto 0); 
  signal mpram_d       : std_logic_vector(79 downto 0);   
  signal mpram_ce      : std_logic_vector(1 downto 0);    
  signal mpram_oe      : std_logic_vector(1 downto 0);    
  signal mpram_we_n    : std_logic;                       
  signal gmem_a        : std_logic_vector(9 downto 0);    
  signal gmem_d        : std_logic_vector(7 downto 0);    
  signal gmem_ce_n     : std_logic;                       
  signal gmem_we_n     : std_logic;                       
  signal iomem_a       : std_logic_vector(9 downto 0);    
  signal iomem_d       : std_logic_vector(15 downto 0);   
  signal iomem_ce_n    : std_logic_vector(1 downto 0);    
  signal iomem_we_n    : std_logic;                       
  signal trcmem_a      : std_logic_vector(7 downto 0);    
  signal trcmem_d      : std_logic_vector(31 downto 0);   
  signal trcmem_ce_n   : std_logic;                       
  signal trcmem_we_n   : std_logic;                                            
  signal pmem_a        : std_logic_vector(10 downto 0);   
  signal pmem_d        : std_logic_vector(1 downto 0);   
  signal pmem_ce_n     : std_logic;                       
  signal pmem_we_n     : std_logic;                       
  -- to PADS
  signal mirqout_o     : std_logic;                       
  signal mckout1_o     : std_logic;                       
  signal msdout_o      : std_logic;                       
  signal mrstout_o     : std_logic;                       
  signal mexec_o       : std_logic;                       
  signal mxout_o       : std_logic;                       
  signal dcs_o         : std_logic;                       
  signal dras_o        : std_logic;                       
  signal dcas_o        : std_logic;                       
  signal dwe_o         : std_logic;                       
  signal ddq_o         : std_logic_vector(7 downto 0);    
  signal ddq_en        : std_logic;                       
  signal da_o          : std_logic_vector(13 downto 0);   
  signal dba_o         : std_logic_vector(1 downto 0);    
  signal dcke_o        : std_logic_vector(3 downto 0);    
  signal pa_en         : std_logic_vector(7 downto 0);    
  signal pa_o          : std_logic_vector(7 downto 0);    
  signal pb_en         : std_logic_vector(7 downto 0);    
  signal pb_o          : std_logic_vector(7 downto 0);    
  signal pc_en         : std_logic_vector(7 downto 0);    
  signal pc_o          : std_logic_vector(7 downto 0);    
  signal pd_en         : std_logic_vector(7 downto 0);    
  signal pd_o          : std_logic_vector(7 downto 0);    
  signal pe_en         : std_logic_vector(7 downto 0);    
  signal pe_o          : std_logic_vector(7 downto 0);    
  signal pf_en         : std_logic_vector(7 downto 0);    
  signal pf_o          : std_logic_vector(7 downto 0);    
  signal pg_en         : std_logic_vector(7 downto 0);    
  signal pg_o          : std_logic_vector(7 downto 0);    
  signal ph_en         : std_logic_vector(7 downto 0);    
  signal ph_o          : std_logic_vector(7 downto 0);    
  signal pi_en         : std_logic_vector(7 downto 0);    
  signal pi_o          : std_logic_vector(7 downto 0);    
  signal pj_en         : std_logic_vector(7 downto 0);    
  signal pj_o          : std_logic_vector(7 downto 0);     
  signal d_hi          : std_logic;                       
  signal d_sr          : std_logic;                       
  signal d_lo          : std_logic;                       
  signal p1_hi         : std_logic;                       
  signal p1_sr         : std_logic;                       
  signal pc_hi         : std_logic;                       
  signal pc_lo_n       : std_logic;                       
  signal ph_hi         : std_logic;                       
  signal ph_lo_n       : std_logic;                       
  signal pi_hi         : std_logic;                       
  signal pi_lo_n       : std_logic;                       
  signal p2_hi         : std_logic;                       
  signal p2_sr         : std_logic;                       
  signal pel_hi        : std_logic;                       
  signal peh_hi        : std_logic;                       
  signal pdll_hi       : std_logic;                       
  signal pdlh_hi       : std_logic;                       
  signal pdh_hi        : std_logic;                       
  signal p3_hi         : std_logic;                       
  signal p3_sr         : std_logic;                       
  signal pf_hi         : std_logic;                       
  signal pg_hi         : std_logic;                       
  
  -----------------------------------------------------------------------------
  -- signals between core and peri
  -----------------------------------------------------------------------------
  -- core driven
  signal dbus        : std_logic_vector(7 downto 0);  
  signal rst_en      : std_logic;
  signal rst_en2     : std_logic;
  signal pd          : std_logic_vector(2 downto 0);
  signal aaddr       : std_logic_vector(4 downto 0);
  signal idack       : std_logic_vector(7 downto 0);
  signal ios_iden    : std_logic;                   
  signal ios_ido     : std_logic_vector(7 downto 0);                  
  signal ilioa       : std_logic;                   
  signal ildout      : std_logic;                   
  signal inext       : std_logic;
  signal iden        : std_logic;                         
  signal dqm_size    : std_logic_vector(1 downto 0);
  signal en_uart1    : std_logic;
  signal en_uart2    : std_logic;
  signal en_uart3    : std_logic;
  signal en_eth      : std_logic_vector(1 downto 0);
  signal en_iobus    : std_logic_vector(1 downto 0);
  signal ddqm        : std_logic_vector(7 downto 0);
  signal en_tiu      : std_logic;
  signal run_tiu     : std_logic;
  -- Peri driven
  signal dfp         : std_logic_vector(7 downto 0);
  signal idreq       : std_logic_vector(7 downto 0);
  signal idi         : std_logic_vector(7 downto 0);
  signal irq0        : std_logic;                         
  signal irq1        : std_logic;                         

  -----------------------------------------------------------------------------
  -- Memory driven signals
  -----------------------------------------------------------------------------
  -- MPROM0, MPROM1, MPRAM0, MPRAM1
  signal mp_q      : std_logic_vector(79 downto 0);
  
  -- GMEM
  signal gmem_q    : std_logic_vector(7 downto 0);
  
  -- IOMEM0, IOMEM1
  signal iomem_q   : std_logic_vector(15 downto 0);
  
  -- TRCMEM
  signal trcmem_q  : std_logic_vector(31 downto 0);
  
  -- PMEM (Patch memory)  
  signal pmem_q    : std_logic_vector(1  downto 0);

  -- BMEM (battery backed memory)
  signal bmem_q    : std_logic_vector(7 downto 0); 

  -----------------------------------------------------------------------------
  -- Attributes declaration and specification
  -----------------------------------------------------------------------------
  attribute syn_black_box           : boolean;
  attribute black_box_tri_pins      : string;
  attribute syn_black_box of BHD1 : component is true;  
	attribute syn_black_box of FXPLL031HA0A_APGD				: component is true;
  attribute syn_black_box of analogtop										: component is true;    
  attribute syn_black_box of SP180_4096X80BM1B				: component is true;
  attribute syn_black_box of SP180_4096X80BM1C				: component is true;
  attribute syn_black_box of SU180_2048X80X1BM1				: component is true;
  attribute syn_black_box of SY180_1024X8X1CM8				: component is true;
  attribute syn_black_box of SY180_256X32X1CM4				: component is true;
  attribute syn_black_box of SY180_2048X2X1CM8				: component is true;
  attribute syn_black_box of SY180_512X8X1CM8					: component is true;
	attribute black_box_tri_pins of SP180_4096X80BM1B		: component is "DO0,DO1,DO2,DO3,DO4," &
																																		 "DO5,DO6,DO7,DO8,DO9," &
																																		 "DO10,DO11,DO12,DO13,DO14," &
																																		 "DO15,DO16,DO17,DO18,DO19," &
																																		 "DO20,DO21,DO22,DO23,DO24," &
																																		 "DO25,DO26,DO27,DO28,DO29," &
																																		 "DO30,DO31,DO32,DO33,DO34," &
																																		 "DO35,DO36,DO37,DO38,DO39," &
																																		 "DO40,DO41,DO42,DO43,DO44," &
																																		 "DO45,DO46,DO47,DO48,DO49," &
																																		 "DO50,DO51,DO52,DO53,DO54," &
																																		 "DO55,DO56,DO57,DO58,DO59," &
																																		 "DO60,DO61,DO62,DO63,DO64," &
																																		 "DO65,DO66,DO67,DO68,DO69," &
																																		 "DO70,DO71,DO72,DO73,DO74," &
																																		 "DO75,DO76,DO77,DO78,DO79";
	attribute black_box_tri_pins of SP180_4096X80BM1C		: component is "DO0,DO1,DO2,DO3,DO4," &
																																		 "DO5,DO6,DO7,DO8,DO9," &
																																		 "DO10,DO11,DO12,DO13,DO14," &
																																		 "DO15,DO16,DO17,DO18,DO19," &
																																		 "DO20,DO21,DO22,DO23,DO24," &
																																		 "DO25,DO26,DO27,DO28,DO29," &
																																		 "DO30,DO31,DO32,DO33,DO34," &
																																		 "DO35,DO36,DO37,DO38,DO39," &
																																		 "DO40,DO41,DO42,DO43,DO44," &
																																		 "DO45,DO46,DO47,DO48,DO49," &
																																		 "DO50,DO51,DO52,DO53,DO54," &
																																		 "DO55,DO56,DO57,DO58,DO59," &
																																		 "DO60,DO61,DO62,DO63,DO64," &
																																		 "DO65,DO66,DO67,DO68,DO69," &
																																		 "DO70,DO71,DO72,DO73,DO74," &
																																		 "DO75,DO76,DO77,DO78,DO79";
	attribute black_box_tri_pins of SU180_2048X80X1BM1	: component is "DO0,DO1,DO2,DO3,DO4," &
																																		 "DO5,DO6,DO7,DO8,DO9," &
																																		 "DO10,DO11,DO12,DO13,DO14," &
																																		 "DO15,DO16,DO17,DO18,DO19," &
																																		 "DO20,DO21,DO22,DO23,DO24," &
																																		 "DO25,DO26,DO27,DO28,DO29," &
																																		 "DO30,DO31,DO32,DO33,DO34," &
																																		 "DO35,DO36,DO37,DO38,DO39," &
																																		 "DO40,DO41,DO42,DO43,DO44," &
																																		 "DO45,DO46,DO47,DO48,DO49," &
																																		 "DO50,DO51,DO52,DO53,DO54," &
																																		 "DO55,DO56,DO57,DO58,DO59," &
																																		 "DO60,DO61,DO62,DO63,DO64," &
																																		 "DO65,DO66,DO67,DO68,DO69," &
																																		 "DO70,DO71,DO72,DO73,DO74," &
																																		 "DO75,DO76,DO77,DO78,DO79";

begin
  -----------------------------------------------------------------------------
  -- Instantiation of bus holders
  -----------------------------------------------------------------------------
  holder_gen: for i in 0 to 79 generate
    bushold: BHD1
      port map (
        H => mp_q(i));
  end generate holder_gen;
  
  -----------------------------------------------------------------------------
  -- PLL
  -----------------------------------------------------------------------------
  pll0: FXPLL031HA0A_APGD
    port map (
      FREF		=> xout,
      FRANGE	=> pll_frange,
      NS0			=> pll_n(0),
      NS1			=> pll_n(1),
      NS2			=> pll_n(2),
      NS3			=> pll_n(3),
      NS4			=> pll_n(4),
      NS5			=> pll_n(5),
      MS0			=> pll_m(0),
      MS1			=> pll_m(1),
      MS2			=> pll_m(2),
      MS3			=> const_0,
      MS4			=> const_0,
      MS5			=> const_0,
      PDN			=> en_pll,
      TCKO		=> tcko,
      TEST		=> test_pll,
      TCKI		=> xout,
      CKOUT		=> pllout,
      CIN			=> pllout);
	const_0 <= '0';

  -----------------------------------------------------------------------------
  -- Instantiation of memories
  -----------------------------------------------------------------------------
  -- mpram0, mpram1
  mpram0: SU180_2048X80X1BM1
    port map ( 
      A0		=> mpram_a(0),
      A1		=> mpram_a(1),
      A2		=> mpram_a(2),
      A3		=> mpram_a(3),
      A4		=> mpram_a(4),
      A5		=> mpram_a(5),
      A6		=> mpram_a(6),
      A7		=> mpram_a(7),
      A8		=> mpram_a(8),
      A9		=> mpram_a(9),
      A10		=> mpram_a(10),
      DO0		=> mp_q(0),
      DO1		=> mp_q(1),
      DO2		=> mp_q(2),
      DO3		=> mp_q(3),
      DO4		=> mp_q(4),
      DO5		=> mp_q(5),
      DO6		=> mp_q(6),
      DO7		=> mp_q(7),
      DO8		=> mp_q(8),
      DO9		=> mp_q(9),
      DO10	=> mp_q(10),
      DO11	=> mp_q(11),
      DO12	=> mp_q(12),
      DO13	=> mp_q(13),
      DO14	=> mp_q(14),
      DO15	=> mp_q(15),
      DO16	=> mp_q(16),
      DO17	=> mp_q(17),
      DO18	=> mp_q(18),
      DO19	=> mp_q(19),
      DO20	=> mp_q(20),
      DO21	=> mp_q(21),
      DO22	=> mp_q(22),
      DO23	=> mp_q(23),
      DO24	=> mp_q(24),
      DO25	=> mp_q(25),
      DO26	=> mp_q(26),
      DO27	=> mp_q(27),
      DO28	=> mp_q(28),
      DO29	=> mp_q(29),
      DO30	=> mp_q(30),
      DO31	=> mp_q(31),
      DO32	=> mp_q(32),
      DO33	=> mp_q(33),
      DO34	=> mp_q(34),
      DO35	=> mp_q(35),
      DO36	=> mp_q(36),
      DO37	=> mp_q(37),
      DO38	=> mp_q(38),
      DO39	=> mp_q(39),
      DO40	=> mp_q(40),
      DO41	=> mp_q(41),
      DO42	=> mp_q(42),
      DO43	=> mp_q(43),
      DO44	=> mp_q(44),
      DO45	=> mp_q(45),
      DO46	=> mp_q(46),
      DO47	=> mp_q(47),
      DO48	=> mp_q(48),
      DO49	=> mp_q(49),
      DO50	=> mp_q(50),
      DO51	=> mp_q(51),
      DO52	=> mp_q(52),
      DO53	=> mp_q(53),
      DO54	=> mp_q(54),
      DO55	=> mp_q(55),
      DO56	=> mp_q(56),
      DO57	=> mp_q(57),
      DO58	=> mp_q(58),
      DO59	=> mp_q(59),
      DO60	=> mp_q(60),
      DO61	=> mp_q(61),
      DO62	=> mp_q(62),
      DO63	=> mp_q(63),
      DO64	=> mp_q(64),
      DO65	=> mp_q(65),
      DO66	=> mp_q(66),
      DO67	=> mp_q(67),
      DO68	=> mp_q(68),
      DO69	=> mp_q(69),
      DO70	=> mp_q(70),
      DO71	=> mp_q(71),
      DO72	=> mp_q(72),
      DO73	=> mp_q(73),
      DO74	=> mp_q(74),
      DO75	=> mp_q(75),
      DO76	=> mp_q(76),
      DO77	=> mp_q(77),
      DO78	=> mp_q(78),
      DO79	=> mp_q(79),
      DI0		=> mpram_d(0),
      DI1		=> mpram_d(1),
      DI2		=> mpram_d(2),
      DI3		=> mpram_d(3),
      DI4		=> mpram_d(4),
      DI5		=> mpram_d(5),
      DI6		=> mpram_d(6),
      DI7		=> mpram_d(7),
      DI8		=> mpram_d(8),
      DI9		=> mpram_d(9),
      DI10	=> mpram_d(10),
      DI11	=> mpram_d(11),
      DI12	=> mpram_d(12),
      DI13	=> mpram_d(13),
      DI14	=> mpram_d(14),
      DI15	=> mpram_d(15),
      DI16	=> mpram_d(16),
      DI17	=> mpram_d(17),
      DI18	=> mpram_d(18),
      DI19	=> mpram_d(19),
      DI20	=> mpram_d(20),
      DI21	=> mpram_d(21),
      DI22	=> mpram_d(22),
      DI23	=> mpram_d(23),
      DI24	=> mpram_d(24),
      DI25	=> mpram_d(25),
      DI26	=> mpram_d(26),
      DI27	=> mpram_d(27),
      DI28	=> mpram_d(28),
      DI29	=> mpram_d(29),
      DI30	=> mpram_d(30),
      DI31	=> mpram_d(31),
      DI32	=> mpram_d(32),
      DI33	=> mpram_d(33),
      DI34	=> mpram_d(34),
      DI35	=> mpram_d(35),
      DI36	=> mpram_d(36),
      DI37	=> mpram_d(37),
      DI38	=> mpram_d(38),
      DI39	=> mpram_d(39),
      DI40	=> mpram_d(40),
      DI41	=> mpram_d(41),
      DI42	=> mpram_d(42),
      DI43	=> mpram_d(43),
      DI44	=> mpram_d(44),
      DI45	=> mpram_d(45),
      DI46	=> mpram_d(46),
      DI47	=> mpram_d(47),
      DI48	=> mpram_d(48),
      DI49	=> mpram_d(49),
      DI50	=> mpram_d(50),
      DI51	=> mpram_d(51),
      DI52	=> mpram_d(52),
      DI53	=> mpram_d(53),
      DI54	=> mpram_d(54),
      DI55	=> mpram_d(55),
      DI56	=> mpram_d(56),
      DI57	=> mpram_d(57),
      DI58	=> mpram_d(58),
      DI59	=> mpram_d(59),
      DI60	=> mpram_d(60),
      DI61	=> mpram_d(61),
      DI62	=> mpram_d(62),
      DI63	=> mpram_d(63),
      DI64	=> mpram_d(64),
      DI65	=> mpram_d(65),
      DI66	=> mpram_d(66),
      DI67	=> mpram_d(67),
      DI68	=> mpram_d(68),
      DI69	=> mpram_d(69),
      DI70	=> mpram_d(70),
      DI71	=> mpram_d(71),
      DI72	=> mpram_d(72),
      DI73	=> mpram_d(73),
      DI74	=> mpram_d(74),
      DI75	=> mpram_d(75),
      DI76	=> mpram_d(76),
      DI77	=> mpram_d(77),
      DI78	=> mpram_d(78),
      DI79	=> mpram_d(79),
      WEB   => mpram_we_n,
      CK    => clk_c,
      CS    => mpram_ce(0),
      OE    => mpram_oe(0));
  mpram1: SU180_2048X80X1BM1
    port map ( 
      A0		=> mpram_a(0),
      A1		=> mpram_a(1),
      A2		=> mpram_a(2),
      A3		=> mpram_a(3),
      A4		=> mpram_a(4),
      A5		=> mpram_a(5),
      A6		=> mpram_a(6),
      A7		=> mpram_a(7),
      A8		=> mpram_a(8),
      A9		=> mpram_a(9),
      A10		=> mpram_a(10),
      DO0		=> mp_q(0),
      DO1		=> mp_q(1),
      DO2		=> mp_q(2),
      DO3		=> mp_q(3),
      DO4		=> mp_q(4),
      DO5		=> mp_q(5),
      DO6		=> mp_q(6),
      DO7		=> mp_q(7),
      DO8		=> mp_q(8),
      DO9		=> mp_q(9),
      DO10	=> mp_q(10),
      DO11	=> mp_q(11),
      DO12	=> mp_q(12),
      DO13	=> mp_q(13),
      DO14	=> mp_q(14),
      DO15	=> mp_q(15),
      DO16	=> mp_q(16),
      DO17	=> mp_q(17),
      DO18	=> mp_q(18),
      DO19	=> mp_q(19),
      DO20	=> mp_q(20),
      DO21	=> mp_q(21),
      DO22	=> mp_q(22),
      DO23	=> mp_q(23),
      DO24	=> mp_q(24),
      DO25	=> mp_q(25),
      DO26	=> mp_q(26),
      DO27	=> mp_q(27),
      DO28	=> mp_q(28),
      DO29	=> mp_q(29),
      DO30	=> mp_q(30),
      DO31	=> mp_q(31),
      DO32	=> mp_q(32),
      DO33	=> mp_q(33),
      DO34	=> mp_q(34),
      DO35	=> mp_q(35),
      DO36	=> mp_q(36),
      DO37	=> mp_q(37),
      DO38	=> mp_q(38),
      DO39	=> mp_q(39),
      DO40	=> mp_q(40),
      DO41	=> mp_q(41),
      DO42	=> mp_q(42),
      DO43	=> mp_q(43),
      DO44	=> mp_q(44),
      DO45	=> mp_q(45),
      DO46	=> mp_q(46),
      DO47	=> mp_q(47),
      DO48	=> mp_q(48),
      DO49	=> mp_q(49),
      DO50	=> mp_q(50),
      DO51	=> mp_q(51),
      DO52	=> mp_q(52),
      DO53	=> mp_q(53),
      DO54	=> mp_q(54),
      DO55	=> mp_q(55),
      DO56	=> mp_q(56),
      DO57	=> mp_q(57),
      DO58	=> mp_q(58),
      DO59	=> mp_q(59),
      DO60	=> mp_q(60),
      DO61	=> mp_q(61),
      DO62	=> mp_q(62),
      DO63	=> mp_q(63),
      DO64	=> mp_q(64),
      DO65	=> mp_q(65),
      DO66	=> mp_q(66),
      DO67	=> mp_q(67),
      DO68	=> mp_q(68),
      DO69	=> mp_q(69),
      DO70	=> mp_q(70),
      DO71	=> mp_q(71),
      DO72	=> mp_q(72),
      DO73	=> mp_q(73),
      DO74	=> mp_q(74),
      DO75	=> mp_q(75),
      DO76	=> mp_q(76),
      DO77	=> mp_q(77),
      DO78	=> mp_q(78),
      DO79	=> mp_q(79),
      DI0		=> mpram_d(0),
      DI1		=> mpram_d(1),
      DI2		=> mpram_d(2),
      DI3		=> mpram_d(3),
      DI4		=> mpram_d(4),
      DI5		=> mpram_d(5),
      DI6		=> mpram_d(6),
      DI7		=> mpram_d(7),
      DI8		=> mpram_d(8),
      DI9		=> mpram_d(9),
      DI10	=> mpram_d(10),
      DI11	=> mpram_d(11),
      DI12	=> mpram_d(12),
      DI13	=> mpram_d(13),
      DI14	=> mpram_d(14),
      DI15	=> mpram_d(15),
      DI16	=> mpram_d(16),
      DI17	=> mpram_d(17),
      DI18	=> mpram_d(18),
      DI19	=> mpram_d(19),
      DI20	=> mpram_d(20),
      DI21	=> mpram_d(21),
      DI22	=> mpram_d(22),
      DI23	=> mpram_d(23),
      DI24	=> mpram_d(24),
      DI25	=> mpram_d(25),
      DI26	=> mpram_d(26),
      DI27	=> mpram_d(27),
      DI28	=> mpram_d(28),
      DI29	=> mpram_d(29),
      DI30	=> mpram_d(30),
      DI31	=> mpram_d(31),
      DI32	=> mpram_d(32),
      DI33	=> mpram_d(33),
      DI34	=> mpram_d(34),
      DI35	=> mpram_d(35),
      DI36	=> mpram_d(36),
      DI37	=> mpram_d(37),
      DI38	=> mpram_d(38),
      DI39	=> mpram_d(39),
      DI40	=> mpram_d(40),
      DI41	=> mpram_d(41),
      DI42	=> mpram_d(42),
      DI43	=> mpram_d(43),
      DI44	=> mpram_d(44),
      DI45	=> mpram_d(45),
      DI46	=> mpram_d(46),
      DI47	=> mpram_d(47),
      DI48	=> mpram_d(48),
      DI49	=> mpram_d(49),
      DI50	=> mpram_d(50),
      DI51	=> mpram_d(51),
      DI52	=> mpram_d(52),
      DI53	=> mpram_d(53),
      DI54	=> mpram_d(54),
      DI55	=> mpram_d(55),
      DI56	=> mpram_d(56),
      DI57	=> mpram_d(57),
      DI58	=> mpram_d(58),
      DI59	=> mpram_d(59),
      DI60	=> mpram_d(60),
      DI61	=> mpram_d(61),
      DI62	=> mpram_d(62),
      DI63	=> mpram_d(63),
      DI64	=> mpram_d(64),
      DI65	=> mpram_d(65),
      DI66	=> mpram_d(66),
      DI67	=> mpram_d(67),
      DI68	=> mpram_d(68),
      DI69	=> mpram_d(69),
      DI70	=> mpram_d(70),
      DI71	=> mpram_d(71),
      DI72	=> mpram_d(72),
      DI73	=> mpram_d(73),
      DI74	=> mpram_d(74),
      DI75	=> mpram_d(75),
      DI76	=> mpram_d(76),
      DI77	=> mpram_d(77),
      DI78	=> mpram_d(78),
      DI79	=> mpram_d(79),
      WEB   => mpram_we_n,
      CK    => clk_c,
      CS    => mpram_ce(1),
      OE    => mpram_oe(1));

  -- mprom0, mprom1
  mprom0: SP180_4096X80BM1B
    port map (
      A0		=> mprom_a(0),
      A1		=> mprom_a(1),
      A2		=> mprom_a(2),
      A3		=> mprom_a(3),
      A4		=> mprom_a(4),
      A5		=> mprom_a(5),
      A6		=> mprom_a(6),
      A7		=> mprom_a(7),
      A8		=> mprom_a(8),
      A9		=> mprom_a(9),
      A10		=> mprom_a(10),
      A11		=> mprom_a(12),
      DO0		=> mp_q(0),
      DO1		=> mp_q(1),
      DO2		=> mp_q(2),
      DO3		=> mp_q(3),
      DO4		=> mp_q(4),
      DO5		=> mp_q(5),
      DO6		=> mp_q(6),
      DO7		=> mp_q(7),
      DO8		=> mp_q(8),
      DO9		=> mp_q(9),
      DO10	=> mp_q(10),
      DO11	=> mp_q(11),
      DO12	=> mp_q(12),
      DO13	=> mp_q(13),
      DO14	=> mp_q(14),
      DO15	=> mp_q(15),
      DO16	=> mp_q(16),
      DO17	=> mp_q(17),
      DO18	=> mp_q(18),
      DO19	=> mp_q(19),
      DO20	=> mp_q(20),
      DO21	=> mp_q(21),
      DO22	=> mp_q(22),
      DO23	=> mp_q(23),
      DO24	=> mp_q(24),
      DO25	=> mp_q(25),
      DO26	=> mp_q(26),
      DO27	=> mp_q(27),
      DO28	=> mp_q(28),
      DO29	=> mp_q(29),
      DO30	=> mp_q(30),
      DO31	=> mp_q(31),
      DO32	=> mp_q(32),
      DO33	=> mp_q(33),
      DO34	=> mp_q(34),
      DO35	=> mp_q(35),
      DO36	=> mp_q(36),
      DO37	=> mp_q(37),
      DO38	=> mp_q(38),
      DO39	=> mp_q(39),
      DO40	=> mp_q(40),
      DO41	=> mp_q(41),
      DO42	=> mp_q(42),
      DO43	=> mp_q(43),
      DO44	=> mp_q(44),
      DO45	=> mp_q(45),
      DO46	=> mp_q(46),
      DO47	=> mp_q(47),
      DO48	=> mp_q(48),
      DO49	=> mp_q(49),
      DO50	=> mp_q(50),
      DO51	=> mp_q(51),
      DO52	=> mp_q(52),
      DO53	=> mp_q(53),
      DO54	=> mp_q(54),
      DO55	=> mp_q(55),
      DO56	=> mp_q(56),
      DO57	=> mp_q(57),
      DO58	=> mp_q(58),
      DO59	=> mp_q(59),
      DO60	=> mp_q(60),
      DO61	=> mp_q(61),
      DO62	=> mp_q(62),
      DO63	=> mp_q(63),
      DO64	=> mp_q(64),
      DO65	=> mp_q(65),
      DO66	=> mp_q(66),
      DO67	=> mp_q(67),
      DO68	=> mp_q(68),
      DO69	=> mp_q(69),
      DO70	=> mp_q(70),
      DO71	=> mp_q(71),
      DO72	=> mp_q(72),
      DO73	=> mp_q(73),
      DO74	=> mp_q(74),
      DO75	=> mp_q(75),
      DO76	=> mp_q(76),
      DO77	=> mp_q(77),
      DO78	=> mp_q(78),
      DO79	=> mp_q(79),
      CK		=> clk_c,
      CS		=> mprom_ce(0),
      OE		=> mprom_oe(0));       
  mprom1: SP180_4096X80BM1C
    port map (
      A0		=> mprom_a(0),
      A1		=> mprom_a(1),
      A2		=> mprom_a(2),
      A3		=> mprom_a(3),
      A4		=> mprom_a(4),
      A5		=> mprom_a(5),
      A6		=> mprom_a(6),
      A7		=> mprom_a(7),
      A8		=> mprom_a(8),
      A9		=> mprom_a(9),
      A10		=> mprom_a(10),
      A11		=> mprom_a(11),
      DO0		=> mp_q(0),
      DO1		=> mp_q(1),
      DO2		=> mp_q(2),
      DO3		=> mp_q(3),
      DO4		=> mp_q(4),
      DO5		=> mp_q(5),
      DO6		=> mp_q(6),
      DO7		=> mp_q(7),
      DO8		=> mp_q(8),
      DO9		=> mp_q(9),
      DO10	=> mp_q(10),
      DO11	=> mp_q(11),
      DO12	=> mp_q(12),
      DO13	=> mp_q(13),
      DO14	=> mp_q(14),
      DO15	=> mp_q(15),
      DO16	=> mp_q(16),
      DO17	=> mp_q(17),
      DO18	=> mp_q(18),
      DO19	=> mp_q(19),
      DO20	=> mp_q(20),
      DO21	=> mp_q(21),
      DO22	=> mp_q(22),
      DO23	=> mp_q(23),
      DO24	=> mp_q(24),
      DO25	=> mp_q(25),
      DO26	=> mp_q(26),
      DO27	=> mp_q(27),
      DO28	=> mp_q(28),
      DO29	=> mp_q(29),
      DO30	=> mp_q(30),
      DO31	=> mp_q(31),
      DO32	=> mp_q(32),
      DO33	=> mp_q(33),
      DO34	=> mp_q(34),
      DO35	=> mp_q(35),
      DO36	=> mp_q(36),
      DO37	=> mp_q(37),
      DO38	=> mp_q(38),
      DO39	=> mp_q(39),
      DO40	=> mp_q(40),
      DO41	=> mp_q(41),
      DO42	=> mp_q(42),
      DO43	=> mp_q(43),
      DO44	=> mp_q(44),
      DO45	=> mp_q(45),
      DO46	=> mp_q(46),
      DO47	=> mp_q(47),
      DO48	=> mp_q(48),
      DO49	=> mp_q(49),
      DO50	=> mp_q(50),
      DO51	=> mp_q(51),
      DO52	=> mp_q(52),
      DO53	=> mp_q(53),
      DO54	=> mp_q(54),
      DO55	=> mp_q(55),
      DO56	=> mp_q(56),
      DO57	=> mp_q(57),
      DO58	=> mp_q(58),
      DO59	=> mp_q(59),
      DO60	=> mp_q(60),
      DO61	=> mp_q(61),
      DO62	=> mp_q(62),
      DO63	=> mp_q(63),
      DO64	=> mp_q(64),
      DO65	=> mp_q(65),
      DO66	=> mp_q(66),
      DO67	=> mp_q(67),
      DO68	=> mp_q(68),
      DO69	=> mp_q(69),
      DO70	=> mp_q(70),
      DO71	=> mp_q(71),
      DO72	=> mp_q(72),
      DO73	=> mp_q(73),
      DO74	=> mp_q(74),
      DO75	=> mp_q(75),
      DO76	=> mp_q(76),
      DO77	=> mp_q(77),
      DO78	=> mp_q(78),
      DO79	=> mp_q(79),
      CK		=> clk_c,
      CS		=> mprom_ce(1),
      OE		=> mprom_oe(1));       

  -- gmem
  gmem: SY180_1024X8X1CM8
    port map ( 
      A0   => gmem_a(0),
      A1   => gmem_a(1),
      A2   => gmem_a(2),
      A3   => gmem_a(3),
      A4   => gmem_a(4),
      A5   => gmem_a(5),
      A6   => gmem_a(6),
      A7   => gmem_a(7),
      A8   => gmem_a(8),
      A9   => gmem_a(9),
      DO0  => gmem_q(0),
      DO1  => gmem_q(1),
      DO2  => gmem_q(2),
      DO3  => gmem_q(3),
      DO4  => gmem_q(4),
      DO5  => gmem_q(5),
      DO6  => gmem_q(6),
      DO7  => gmem_q(7),
      DI0  => gmem_d(0),
      DI1  => gmem_d(1),
      DI2  => gmem_d(2),
      DI3  => gmem_d(3),
      DI4  => gmem_d(4),
      DI5  => gmem_d(5),
      DI6  => gmem_d(6),
      DI7  => gmem_d(7),
      WEB  => gmem_we_n,
      CK   => clk_c,
      CSB  => gmem_ce_n);

  -- iomem0, iomem1
  iomem0: SY180_1024X8X1CM8
    port map ( 
      A0   => iomem_a(0),
      A1   => iomem_a(1),
      A2   => iomem_a(2),
      A3   => iomem_a(3),
      A4   => iomem_a(4),
      A5   => iomem_a(5),
      A6   => iomem_a(6),
      A7   => iomem_a(7),
      A8   => iomem_a(8),
      A9   => iomem_a(9),
      DO0  => iomem_q(0),
      DO1  => iomem_q(1),
      DO2  => iomem_q(2),
      DO3  => iomem_q(3),
      DO4  => iomem_q(4),
      DO5  => iomem_q(5),
      DO6  => iomem_q(6),
      DO7  => iomem_q(7),
      DI0  => iomem_d(0),
      DI1  => iomem_d(1),
      DI2  => iomem_d(2),
      DI3  => iomem_d(3),
      DI4  => iomem_d(4),
      DI5  => iomem_d(5),
      DI6  => iomem_d(6),
      DI7  => iomem_d(7),
      WEB  => iomem_we_n,
      CK   => clk_c,
      CSB  => iomem_ce_n(0));
  iomem1: SY180_1024X8X1CM8
    port map ( 
      A0   => iomem_a(0),
      A1   => iomem_a(1),
      A2   => iomem_a(2),
      A3   => iomem_a(3),
      A4   => iomem_a(4),
      A5   => iomem_a(5),
      A6   => iomem_a(6),
      A7   => iomem_a(7),
      A8   => iomem_a(8),
      A9   => iomem_a(9),
      DO0  => iomem_q(8),
      DO1  => iomem_q(9),
      DO2  => iomem_q(10),
      DO3  => iomem_q(11),
      DO4  => iomem_q(12),
      DO5  => iomem_q(13),
      DO6  => iomem_q(14),
      DO7  => iomem_q(15),
      DI0  => iomem_d(8),
      DI1  => iomem_d(9),
      DI2  => iomem_d(10),
      DI3  => iomem_d(11),
      DI4  => iomem_d(12),
      DI5  => iomem_d(13),
      DI6  => iomem_d(14),
      DI7  => iomem_d(15),
      WEB  => iomem_we_n,
      CK   => clk_c,
      CSB  => iomem_ce_n(1));

  -- pmem
  pmem: SY180_2048X2X1CM8
    port map ( 
      A0		=> pmem_a(0),
      A1		=> pmem_a(1),
      A2		=> pmem_a(2),
      A3		=> pmem_a(3),
      A4		=> pmem_a(4),
      A5		=> pmem_a(5),
      A6		=> pmem_a(6),
      A7		=> pmem_a(7),
      A8		=> pmem_a(8),
      A9		=> pmem_a(9),
      A10		=> pmem_a(10),
      DO0   => pmem_q(0),      
      DO1   => pmem_q(1),      
      DI0   => pmem_d(0),
      DI1   => pmem_d(1),
      WEB   => pmem_we_n,
      CK    => clk_c,
      CSB   => pmem_ce_n);
   
  -- bmem  !!! SEPARATELY POWERED !!!
  bmem: SY180_512X8X1CM8
    port map ( 
      A0   => dbus(0),
      A1   => dbus(1),
      A2   => dbus(2),
      A3   => dbus(3),
      A4   => dbus(4),
      A5   => dbus(5),
      A6   => dbus(6),
      A7   => dbus(7),
      A8   => bmem_a8,
      DO0  => bmem_q(0),
      DO1  => bmem_q(1),
      DO2  => bmem_q(2),
      DO3  => bmem_q(3),
      DO4  => bmem_q(4),
      DO5  => bmem_q(5),
      DO6  => bmem_q(6),
      DO7  => bmem_q(7),
      DI0  => bmem_d(0),
      DI1  => bmem_d(1),
      DI2  => bmem_d(2),
      DI3  => bmem_d(3),
      DI4  => bmem_d(4),
      DI5  => bmem_d(5),
      DI6  => bmem_d(6),
      DI7  => bmem_d(7),
      WEB  => bmem_we_n,
      CK   => clk_e,
      CSB  => bmem_ce_n);

  -- trcmem
  trcmem: SY180_256X32X1CM4
    port map ( 
      A0		=> trcmem_a(0),
      A1		=> trcmem_a(1),
      A2		=> trcmem_a(2),
      A3		=> trcmem_a(3),
      A4		=> trcmem_a(4),
      A5		=> trcmem_a(5),
      A6		=> trcmem_a(6),
      A7		=> trcmem_a(7),
      DO0		=> trcmem_q(0),
      DO1		=> trcmem_q(1),
      DO2		=> trcmem_q(2),
      DO3		=> trcmem_q(3),
      DO4		=> trcmem_q(4),
      DO5		=> trcmem_q(5),
      DO6		=> trcmem_q(6),
      DO7		=> trcmem_q(7),
      DO8		=> trcmem_q(8),
      DO9		=> trcmem_q(9),
      DO10	=> trcmem_q(10),
      DO11	=> trcmem_q(11),
      DO12	=> trcmem_q(12),
      DO13	=> trcmem_q(13),
      DO14	=> trcmem_q(14),
      DO15	=> trcmem_q(15),
      DO16	=> trcmem_q(16),
      DO17	=> trcmem_q(17),
      DO18	=> trcmem_q(18),
      DO19	=> trcmem_q(19),
      DO20	=> trcmem_q(20),
      DO21	=> trcmem_q(21),
      DO22	=> trcmem_q(22),
      DO23	=> trcmem_q(23),
      DO24	=> trcmem_q(24),
      DO25	=> trcmem_q(25),
      DO26	=> trcmem_q(26),
      DO27	=> trcmem_q(27),
      DO28	=> trcmem_q(28),
      DO29	=> trcmem_q(29),
      DO30	=> trcmem_q(30),
      DO31	=> trcmem_q(31),
      DI0		=> trcmem_d(0),
      DI1		=> trcmem_d(1),
      DI2		=> trcmem_d(2),
      DI3		=> trcmem_d(3),
      DI4		=> trcmem_d(4),
      DI5		=> trcmem_d(5),
      DI6		=> trcmem_d(6),
      DI7		=> trcmem_d(7),
      DI8		=> trcmem_d(8),
      DI9		=> trcmem_d(9),
      DI10	=> trcmem_d(10),
      DI11	=> trcmem_d(11),
      DI12	=> trcmem_d(12),
      DI13	=> trcmem_d(13),
      DI14	=> trcmem_d(14),
      DI15	=> trcmem_d(15),
      DI16	=> trcmem_d(16),
      DI17	=> trcmem_d(17),
      DI18	=> trcmem_d(18),
      DI19	=> trcmem_d(19),
      DI20	=> trcmem_d(20),
      DI21	=> trcmem_d(21),
      DI22	=> trcmem_d(22),
      DI23	=> trcmem_d(23),
      DI24	=> trcmem_d(24),
      DI25	=> trcmem_d(25),
      DI26	=> trcmem_d(26),
      DI27	=> trcmem_d(27),
      DI28	=> trcmem_d(28),
      DI29	=> trcmem_d(29),
      DI30	=> trcmem_d(30),
      DI31	=> trcmem_d(31),
      WEB   => trcmem_we_n,
      CK    => clk_e,
      CSB   => trcmem_ce_n);

  ----------------------------------------------------------------------------
  -- Pads
  ----------------------------------------------------------------------------
  pads0: pads
    port map (
      MX1_CK        => MX1_CK,            
      MX2           => MX2,          
      MXOSC_FEB       => MXOSC_FEB,            
      MXOSC_S1       => MXOSC_S1,            
      MXOSC_S0       => MXOSC_S0,            
      MXOUT         => MXOUT,             
      MEXEC         => MEXEC,             
      MCKOUT1       => MCKOUT1,           
      MCKOUT0       => MCKOUT0,           
      MSDIN         => MSDIN,             
      MSDOUT        => MSDOUT,            
      MIRQOUT       => MIRQOUT,           
      PD0_DDQM0     => PD0_DDQM0,         
      PD1_DDQM1     => PD1_DDQM1,         
      PD2_DDQM2     => PD2_DDQM2,         
      PD3_DDQM3     => PD3_DDQM3,         
      PD4_DDQM4     => PD4_DDQM4,         
      PD5_DDQM5     => PD5_DDQM5,         
      PD6_DDQM6     => PD6_DDQM6,         
      PD7_DDQM7     => PD7_DDQM7,         
      PJ4_INEXT   => PJ4_INEXT,
      PJ5_ILDOUT  => PJ5_ILDOUT,
      PJ6_ILIOA   => PJ6_ILIOA,
      PJ7_ICLK    => PJ7_ICLK,
      PI0_ID0     => PI0_ID0,
      PI1_ID1     => PI1_ID1,
      PI2_ID2     => PI2_ID2,
      PI3_ID3     => PI3_ID3,
      PI4_ID4     => PI4_ID4,
      PI5_ID5     => PI5_ID5,
      PI6_ID6     => PI6_ID6,
      PI7_ID7     => PI7_ID7,
      PH0_IDREQ0  => PH0_IDREQ0,
      PH1_IDREQ1  => PH1_IDREQ1,
      PH2_IDREQ2  => PH2_IDREQ2,
      PH3_IDREQ3  => PH3_IDREQ3,
      PH4_IDACK0  => PH4_IDACK0,
      PH5_IDACK1  => PH5_IDACK1,
      PH6_IDACK2  => PH6_IDACK2,
      PH7_IDACK3  => PH7_IDACK3,
      PC0_IDREQ4  => PC0_IDREQ4,
      PC1_IDREQ5  => PC1_IDREQ5,
      PC2_IDREQ6  => PC2_IDREQ6,
      PC3_IDREQ7  => PC3_IDREQ7,
      PC4_IDACK4  => PC4_IDACK4,
      PC5_IDACK5  => PC5_IDACK5,
      PC6_IDACK6  => PC6_IDACK6,
      PC7_IDACK7  => PC7_IDACK7,
      MBYPASS       => MBYPASS,           
      MRESET        => MRESET,            
      MRSTOUT       => MRSTOUT,           
      MTEST         => MTEST,             
      MWAKE         => MWAKE,             
      MIRQ0         => MIRQ0,             
      MIRQ1         => MIRQ1,             
      MRXOUT      => MRXOUT,
      PJ0_UTX1      => PJ0_UTX1,                
      PJ1_URX1      => PJ1_URX1,     
      PJ2_URTS1   => PJ2_URTS1,
      PJ3_UCTS1   => PJ3_UCTS1,
      PE0_UTX2    => PE0_UTX2,
      PE1_URX2    => PE1_URX2,
      PE2_URTS2   => PE2_URTS2,
      PE3_UCTS2   => PE3_UCTS2,
      PE4_UTX3    => PE4_UTX3,
      PE5_URX3    => PE5_URX3,
      PE6_URTS3   => PE6_URTS3,
      PE7_UCTS3   => PE7_UCTS3,
      PF0_ETXEN   => PF0_ETXEN,
      PF1_ETXCLK  => PF1_ETXCLK,
      PF2_ETXD0   => PF2_ETXD0,
      PF3_ETXD1   => PF3_ETXD1,
      PF4_ERXDV   => PF4_ERXDV,
      PF5_ERXER   => PF5_ERXER,
      PF6_ERXD0   => PF6_ERXD0,
      PF7_ERXD1   => PF7_ERXD1,
      PG0_ETXER   => PG0_ETXER,
      PG1_ERXCLK  => PG1_ERXCLK,
      PG2_ETXD2   => PG2_ETXD2,
      PG3_ETXD3   => PG3_ETXD3,
      PG4_ECOL    => PG4_ECOL,
      PG5_ECRS    => PG5_ECRS,
      PG6_ERXD2   => PG6_ERXD2,
      PG7_ERXD3   => PG7_ERXD3,
      PA0         => PA0,
      PA1         => PA1,
      PA2         => PA2,
      PA3         => PA3,
      PA4         => PA4,
      PA5         => PA5,
      PA6         => PA6,
      PA7         => PA7,
      PB0         => PB0,
      PB1         => PB1,
      PB2         => PB2,
      PB3         => PB3,
      PB4         => PB4,
      PB5         => PB5,
      PB6         => PB6,
      PB7         => PB7,
      DDQ0        => DDQ0,
      DDQ1        => DDQ1,
      DDQ2        => DDQ2,
      DDQ3        => DDQ3,
      DDQ4        => DDQ4,
      DDQ5        => DDQ5,
      DDQ6        => DDQ6,
      DDQ7        => DDQ7,
      DCLK        => DCLK,
      DCS         => DCS,
      DRAS        => DRAS,
      DCAS        => DCAS,
      DWE         => DWE,  
      DBA0        => DBA0,
      DBA1        => DBA1,
      DA0         => DA0,
      DA1         => DA1,
      DA2         => DA2,
      DA3         => DA3,
      DA4         => DA4,
      DA5         => DA5,
      DA6         => DA6,
      DA7         => DA7,
      DA8         => DA8,
      DA9         => DA9,
      DA10        => DA10,
      DA11        => DA11,
      DA12        => DA12,
      DA13        => DA13,
      DCKE0         => DCKE0,             
      DCKE1         => DCKE1,             
      DCKE2         => DCKE2,             
      DCKE3         => DCKE3,             
      MPORDIS       => MPORDIS,            
      MPLL_TSTO     => MPLL_TSTO,    
      mx1_ck_i      => xout,          
      mx1_ck_e      => en_xosc,          
      mxout_o       => mxout_o,           
      mexec_o       => mexec_o,           
      mckout0_o     => clk_s,             
      mckout1_o     => mckout1_o,         
      msdin_i       => msdin_i,           
      msdout_o      => msdout_o,          
      mirqout_o     => mirqout_o,         
      pd_en         => pd_en,             
      pd_i          => pd_i,              
      pd_o          => pd_o,              
      pj_en         => pj_en, 
      pj_i          => pj_i,  
      pj_o          => pj_o, 
      pi_en       => pi_en,
      pi_o        => pi_o,
      pi_i        => pi_i,
      ph_en       => ph_en,
      ph_o        => ph_o,
      ph_i        => ph_i,
      pc_en       => pc_en,
      pc_o        => pc_o,
      pc_i        => pc_i,
      mbypass_i     => mbypass_i,         
      mreset_i      => mreset_i,          
      mrstout_o     => mrstout_o,         
      mtest_i       => mtest_i,           
      mwake_i       => mwake_i,           
      mirq0_i       => mirq0_i,           
      mirq1_i       => mirq1_i,           
      mrxout_o    => mrxout_o,
      pe_en       => pe_en,
      pe_o        => pe_o,
      pe_i        => pe_i,
      pf_en       => pf_en,
      pf_o        => pf_o,
      pf_i        => pf_i,
      pg_en       => pg_en,
      pg_o        => pg_o,
      pg_i        => pg_i,
      pa_en       => pa_en,
      pa_o        => pa_o,
      pa_i        => pa_i,
      pb_en       => pb_en,
      pb_o        => pb_o,
      pb_i        => pb_i,
      ddq_en      => ddq_en,
      ddq_o       => ddq_o,
      ddq_i       => ddq_i,
      dclk_o      => clk_d,
      dcs_o       => dcs_o,
      dras_o      => dras_o,
      dcas_o      => dcas_o,
      dwe_o       => dwe_o,
      dba_o       => dba_o,
      da_o        => da_o, 
      dcke_o        => dcke_o,            
      mpordis_i     => mpordis_i,          
      mpll_tsto_o   => mpll_tsto_o,
      mpll_tsto_en  => '1',
      d_hi        => d_hi, 
      d_sr        => d_sr, 
      d_lo        => d_lo, 
      p1_hi       => p1_hi, 
      p1_sr       => p1_sr, 
      pc_hi       => pc_hi, 
      pc_lo_n     => pc_lo_n, 
      ph_hi       => ph_hi, 
      ph_lo_n     => ph_lo_n, 
      pi_hi       => pi_hi, 
      pi_lo_n     => pi_lo_n, 
      p2_hi       => p2_hi, 
      p2_sr       => p2_sr, 
      pel_hi      => pel_hi, 
      peh_hi      => peh_hi, 
      pdll_hi     => pdll_hi, 
      pdlh_hi     => pdlh_hi, 
      pdh_hi      => pdh_hi, 
      p3_hi       => p3_hi, 
      p3_sr       => p3_sr, 
      pf_hi       => pf_hi, 
      pg_hi       => pg_hi); 

  -----------------------------------------------------------------------------
  -- Analog part
  -----------------------------------------------------------------------------
  analog0: analogtop
    port map (
			-- Pad side
			XTAL1				=> XTAL1,  
			XTAL2				=> XTAL2,  
			VREGEN			=> VREGEN,  
			EXTREF			=> EXTREF,  
			ACH0				=> ACH0,  
			ACH1				=> ACH1,  
			ACH2				=> ACH2,  
			ACH3				=> ACH3,  
			ACH4				=> ACH4,  
			ACH5				=> ACH5,  
			ACH6				=> ACH6,  
			ACH7				=> ACH7,  
			AOUT0				=> AOUT0,  
			AOUT1				=> AOUT1,  
			-- Internal side
			pwr_ok			=> pwr_ok,  
			dis_bmem		=> dis_bmem,  
			vdd_bmem		=> open,  -- Power to the BMEM block (RAM)
			VCC18LP			=> open,	-- Power to the RTC block  
			rxout				=> rxout,  
			ach_sel0		=> ach_sel(0),  
			ach_sel1		=> ach_sel(1),  
			ach_sel2		=> ach_sel(2),  
			adc_bits		=> adc_bits_int,  
			adc_ref2v		=> adc_ref2v,  
			adc_extref	=> adc_extref,  
			adc_diff		=> adc_diff,  
			adc_en			=> adc_en,  
			dac0_bits		=> dac_bits(0),  
			dac1_bits		=> dac_bits(1),  
			dac0_en			=> dac_en(0),  
			dac1_en			=> dac_en(1),  
			clk_a				=> clk_a); 
			
	adc_bits <= adc_bits_int when adc_dac = '0' else
							dac_bits(0) when dac_en(0) = '1' else
							dac_bits(1);

  -----------------------------------------------------------------------------
  -- Clock generation block
  -----------------------------------------------------------------------------
  clk_gen0: clk_gen
    port map (
      rst_n      => rst_n,
      rst_cn     => rst_cn,
      pllout     => pllout,
      xout       => xout,
      erxclk     => erxclk,
      etxclk     => etxclk,
--      en_eth     => en_eth,
      sel_pll    => sel_pll,  
      en_d       => en_d,  
      fast_d     => fast_d,
      din_e      => din_e, 
      din_i      => din_i, 
      din_u      => din_u, 
      din_s      => din_s,
      din_a      => din_a,
      clk_p      => clk_p, 
      clk_c      => clk_c,
      clk_c2     => clk_c2,
      clk_e      => clk_e, 
      clk_i      => clk_i, 
      clk_d      => clk_d, 
      clk_u      => clk_u, 
      clk_s      => clk_s,
      clk_rx     => clk_rx,
      clk_tx     => clk_tx,
      clk_a      => clk_a);

  -----------------------------------------------------------------------------
  -- Real time clock  !!! SEPARATELY POWERED !!!
  -----------------------------------------------------------------------------
  rtc0: rtc
    port map (
      pwr_ok     => pwr_ok,
      rxout      => rxout,
      mrxout_o   => mrxout_o,
      rst_rtc    => rst_rtc,
      en_fclk    => en_fclk,
      fclk       => fclk,
      ld_bmem    => ld_bmem,
      rtc_sel    => rtc_sel,
      rtc_data   => rtc_data,      
      dis_bmem   => dis_bmem);      

  -----------------------------------------------------------------------------
  -- core
  -----------------------------------------------------------------------------
  core0: core
    port map (
      clk_p       => clk_p,
      clk_c       => clk_c,
      clk_c2      => clk_c2,
      clk_e       => clk_e,
      clk_i       => clk_i,
      clk_d       => clk_d,
      clk_s       => clk_s,
      rst_n       => rst_n,
      rst_cn      => rst_cn,
      en_d        => en_d,
      fast_d      => fast_d,
      din_e       => din_e,
      din_i       => din_i,
      din_u       => din_u,
      din_s       => din_s,
      pll_frange  => pll_frange,
      pll_n       => pll_n,
      pll_m       => pll_m,
      en_xosc     => en_xosc,
      en_pll      => en_pll,
      sel_pll     => sel_pll,
      test_pll    => test_pll,
      xout        => xout,
      pwr_ok      => pwr_ok,
      bmem_a8     => bmem_a8,
      bmem_q      => bmem_q,
      bmem_d      => bmem_d,
      bmem_we_n   => bmem_we_n,
      bmem_ce_n   => bmem_ce_n,
      rst_rtc     => rst_rtc,
      en_fclk     => en_fclk,
      fclk        => fclk,
      ld_bmem     => ld_bmem,
      rtc_sel     => rtc_sel,
      rtc_data    => rtc_data,      
      dfp         => dfp,
      dbus        => dbus,
      rst_en      => rst_en,
      rst_en2     => rst_en2,
      pd          => pd,
      aaddr       => aaddr,
      idreq       => idreq,
      idi         => idi,
      idack       => idack,
      ios_iden    => ios_iden,
      ios_ido     => ios_ido,
      ilioa       => ilioa,
      ildout      => ildout,
      inext       => inext,
      iden        => iden,
      dqm_size    => dqm_size,
      adc_dac     => adc_dac,
      en_uart1    => en_uart1,
      en_uart2    => en_uart2,
      en_uart3    => en_uart3,
      en_eth      => en_eth,
      en_tiu      => en_tiu,
      run_tiu     => run_tiu,
      en_tstamp   => en_tstamp,
      en_iobus    => en_iobus,
      ddqm        => ddqm,
      irq0     	  => irq0,
      irq1     	  => irq1,
      adc_ref2v 	=> adc_ref2v,
      mprom_a     => mprom_a,
      mprom_ce    => mprom_ce,
      mprom_oe    => mprom_oe,
      mpram_a     => mpram_a,
      mpram_d     => mpram_d,
      mpram_ce    => mpram_ce,
      mpram_oe    => mpram_oe,
      mpram_we_n  => mpram_we_n,
      mp_q        => mp_q,
      gmem_a      => gmem_a,
      gmem_d      => gmem_d,
      gmem_q      => gmem_q,
      gmem_ce_n   => gmem_ce_n,
      gmem_we_n   => gmem_we_n,
      iomem_a     => iomem_a,
      iomem_d     => iomem_d,
      iomem_q     => iomem_q,
      iomem_ce_n  => iomem_ce_n,
      iomem_we_n  => iomem_we_n,
      trcmem_a    => trcmem_a,
      trcmem_d    => trcmem_d,
      trcmem_q    => trcmem_q,
      trcmem_ce_n => trcmem_ce_n,
      trcmem_we_n => trcmem_we_n,
      pmem_a      => pmem_a,
      pmem_d      => pmem_d,
      pmem_q      => pmem_q,
      pmem_ce_n   => pmem_ce_n,
      pmem_we_n   => pmem_we_n,
      mpordis_i   => mpordis_i,
      mreset_i    => mreset_i,
      mirqout_o   => mirqout_o,
      mckout1_o   => mckout1_o,
      msdin_i     => msdin_i,
      msdout_o    => msdout_o,
      mrstout_o   => mrstout_o,
      mxout_o     => mxout_o,
      mexec_o     => mexec_o,
      mtest_i     => mtest_i,
      mbypass_i   => mbypass_i,
      mwake_i     => mwake_i,
      dcs_o       => dcs_o,
      dras_o      => dras_o,
      dcas_o      => dcas_o,
      dwe_o       => dwe_o,
      ddq_i       => ddq_i,
      ddq_o       => ddq_o,
      ddq_en      => ddq_en,
      da_o        => da_o,
      dba_o       => dba_o,
      dcke_o      => dcke_o,
      pa_i        => pa_i(4 downto 0),
      d_hi        => d_hi, 
      d_sr        => d_sr, 
      d_lo        => d_lo, 
      p1_hi       => p1_hi, 
      p1_sr       => p1_sr, 
      pc_hi       => pc_hi, 
      pc_lo_n     => pc_lo_n, 
      ph_hi       => ph_hi, 
      ph_lo_n     => ph_lo_n, 
      pi_hi       => pi_hi, 
      pi_lo_n     => pi_lo_n, 
      p2_hi       => p2_hi, 
      p2_sr       => p2_sr, 
      pel_hi      => pel_hi, 
      peh_hi      => peh_hi, 
      pdll_hi     => pdll_hi, 
      pdlh_hi     => pdlh_hi, 
      pdh_hi      => pdh_hi, 
      p3_hi       => p3_hi, 
      p3_sr       => p3_sr, 
      pf_hi       => pf_hi, 
      pg_hi       => pg_hi); 

	mpll_tsto_o <=	tcko when en_tstamp = "00" else
									tstamp(0) when en_tstamp = "01" else
									tstamp(1) when en_tstamp = "10" else
									tstamp(2);
									
  -----------------------------------------------------------------------------
  -- Peripherals
  -----------------------------------------------------------------------------
  peri0: peri
    port map (
      clk_c     	=> clk_c,
      clk_e     	=> clk_e,
      clk_i     	=> clk_i,
      clk_u     	=> clk_u,
      clk_rx    	=> clk_rx,
      clk_tx    	=> clk_tx,
      clk_a     	=> clk_a,
      erxclk    	=> erxclk,
      etxclk    	=> etxclk, 
      din_a     	=> din_a,
      dbus      	=> dbus,
      dfp       	=> dfp,
      rst_en    	=> rst_en,
      rst_en2    	=> rst_en2,
      pl_pd     	=> pd,
      pl_aaddr  	=> aaddr,
      idack     	=> idack,
      ios_iden  	=> ios_iden,
      ios_ido   	=> ios_ido,
      ilioa     	=> ilioa,
      ildout    	=> ildout,
      inext     	=> inext,
      iden        => iden,
      dqm_size  	=> dqm_size,
      en_uart1  	=> en_uart1,
      en_uart2  	=> en_uart2,
      en_uart3  	=> en_uart3,
      en_eth    	=> en_eth,
      en_tiu    	=> en_tiu,
      run_tiu   	=> run_tiu,
      en_iobus  	=> en_iobus,
      ddqm      	=> ddqm,
      idreq     	=> idreq,
      idi       	=> idi,
      irq0      	=> irq0,
      irq1      	=> irq1,
      tstamp     	=> tstamp,
      ach_sel   	=> ach_sel,
      adc_bits  	=> adc_bits,
      adc_extref	=> adc_extref,
      adc_diff  	=> adc_diff,
      adc_en    	=> adc_en,
      dac_bits  	=> dac_bits,
      dac_en    	=> dac_en,
      mirq0_i   	=> mirq0_i,
      mirq1_i   	=> mirq1_i,
      pa_i      	=> pa_i,
      pa_en     	=> pa_en,
      pa_o      	=> pa_o,
      pb_i      	=> pb_i,
      pb_en     	=> pb_en,
      pb_o      	=> pb_o,
      pc_i      	=> pc_i,
      pc_en     	=> pc_en,
      pc_o      	=> pc_o,
      pd_i      	=> pd_i,
      pd_en     	=> pd_en,
      pd_o      	=> pd_o,
      pe_i      	=> pe_i,
      pe_en     	=> pe_en,
      pe_o      	=> pe_o,
      pf_i      	=> pf_i,
      pf_en     	=> pf_en,
      pf_o      	=> pf_o,
      pg_i      	=> pg_i,
      pg_en     	=> pg_en,
      pg_o      	=> pg_o,
      ph_i      	=> ph_i,
      ph_en     	=> ph_en,
      ph_o      	=> ph_o,
      pi_i      	=> pi_i,
      pi_en     	=> pi_en,
      pi_o      	=> pi_o,
      pj_i      	=> pj_i,
      pj_en     	=> pj_en,
      pj_o      	=> pj_o);  

end;
