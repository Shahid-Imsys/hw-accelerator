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
-- Title      : eth synthesis shell
-- Project    : eth
-------------------------------------------------------------------------------
-- File       : eth_tb.vhd
-- Author     : Christian Blixt
-- Company    : Imsys AB
-- Date       : 010110
-- Platform   : Windows 98
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 010110      1.0      Christian Blixt   Created
-- 011112      2.0      Sebastian Edman   Updated to eth2
-- 020416      3.0      Sebastian Edman   Updated to eth3
-- 060111      4.0      Christian Blixt   Updated to eth
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity eth_tb is
end eth_tb;

architecture testbench of eth_tb is
    constant stimfile : string := "eth.stim";
		-- Processor interface
		signal iclk   	: std_logic;
		signal ilioa  	: std_logic;
		signal ildout 	: std_logic;
		signal inext  	: std_logic;
		signal id     	: std_logic_vector(7 downto 0);
    signal ido_eth  : std_logic_vector(7 downto 0);
    signal iden_eth	: std_logic;
		signal idack  	: std_logic_vector(3 downto 0);
		signal idreq  	: std_logic_vector(3 downto 0);
		-- PHY interface
		signal rxclk		: std_logic;
		signal txclk		: std_logic;
		signal rxdv			: std_logic;
		signal rxer			: std_logic;
		signal rxd			: std_logic_vector(3 downto 0);
		signal txen			: std_logic;
		signal txer			: std_logic;
		signal col			: std_logic;
		signal crs			: std_logic;    
		signal txd			: std_logic_vector(3 downto 0);
		-- system reset
		signal phymode  : std_logic_vector(1 downto 0);


begin
	phymode <= "00", "01" after 10 ns;
	idreq(0) <= '1';
	idreq(2) <= '1';
	
	eth : entity work.eth
		generic map (
			TX_CTL_ADR		=> x"24",
			RX_CTL_ADR		=> x"20",
			RX_DA_ADR			=> x"21",
			RX_STS_ADR		=> x"22",
			RX_CTL_ADR_2	=> x"25",
			RX_DA_ADR_2		=> x"26",
			RX_STS_ADR_2	=> x"27",
			TX_SIZE				=> 3,
			RX_SIZE				=> 4,
			STS_SIZE			=> 2,
			RX_SIZE_2			=> 3,
			STS_SIZE_2		=> 2)
		port map (
			-- Processor interface
			clk_i			=> iclk,
			ilioa			=> ilioa,
			inext			=> inext,
			ildout		=> ildout,
			idi				=> id,
			ido				=> ido_eth,
			iden			=> iden_eth,
			idack_rx	=> idack(1),
			idreq_rx	=> idreq(1),
			idack_tx	=> idack(3),
			idreq_tx	=> idreq(3),
			-- PHY interface
			clk_rx		=> rxclk,
			clk_tx		=> txclk,
			erxdv			=> rxdv,
			erxer			=> rxer,
			erxd			=> rxd,
			etxen			=> txen,
			etxer			=> txer,
			ecol			=> col,
			ecrs			=> crs,
			etxd			=> txd,
		-- System reset
			phymode   => phymode);
    
	cjipgen : entity work.cjipgen(generator)
		generic map (
      half_cycle_time => 15 ns,
			cjipfilename	=> stimfile
		)
		port map (
			iclk	  => iclk,
			ilioa	  => ilioa,
			ildout  => ildout,
			inext	  => inext,
			idreq   => idreq,
			idack   => idack,
			id		  => id
		);

  ethgen : entity work.ethgen(generator)
    generic map (
      half_cycle_time => 20 ns,
      filename => stimfile
    )
    port map (
			tx_clk  => txclk,
			tx_en   => txen,
			tx_er   => txer,
			txd     => txd,
			rx_clk  => rxclk,
			rx_dv   => rxdv,
			rx_er   => rxer,
			rxd     => rxd,
			col     => col,
			crs     => crs
    );

    id <= ido_eth when iden_eth = '1' else
          (others => 'Z');

end architecture testbench;












