library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity FXPLL031HA0A_APGD is
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
end FXPLL031HA0A_APGD;

architecture struct of FXPLL031HA0A_APGD is
begin
	CKOUT <= FREF;
	TCKO <= '0';
end struct;

    














