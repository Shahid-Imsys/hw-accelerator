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
-- Title      : ports mux
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : port_mux.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: This block multiplexes ports which shared between UARTs,
--              Ethernet, DDQM, I/O bus, DMA and 'normal ports'. 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.5				CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity port_mux is
  port(
    -- ports mux control signals from Configuration register
    dqm_size  : in  std_logic_vector(1 downto 0);
    en_uart1  : in  std_logic;
    en_uart2  : in  std_logic;
    en_uart3  : in  std_logic;
    en_eth    : in  std_logic_vector(1 downto 0);
    en_iobus  : in  std_logic_vector(1 downto 0);
    en_pdi    : in  std_logic;
    -- signals to/from pads
    pb_i      : in  std_logic_vector(7 downto 0);
    pb_o      : out std_logic_vector(7 downto 0);
    pc_i      : in  std_logic_vector(7 downto 0);  -- from PADs 'input'
    pc_o      : out std_logic_vector(7 downto 0);  -- to PADs 'output'
    pd_i      : in  std_logic_vector(7 downto 0); 
    pd_o      : out std_logic_vector(7 downto 0); 
    pe_o      : out std_logic_vector(7 downto 0); 
    pe_i      : in  std_logic_vector(7 downto 0); 
    pf_o      : out std_logic_vector(7 downto 0); 
    pf_i      : in  std_logic_vector(7 downto 0); 
    pg_o      : out std_logic_vector(7 downto 0); 
    pg_i      : in  std_logic_vector(7 downto 0);
    ph_o      : out std_logic_vector(7 downto 0); 
    ph_i      : in  std_logic_vector(7 downto 0);
    pi_en     : out std_logic_vector(7 downto 0);                    
    pi_o      : out std_logic_vector(7 downto 0); 
    pi_i      : in  std_logic_vector(7 downto 0);     
    pj_o      : out std_logic_vector(7 downto 0); 
    pj_i      : in  std_logic_vector(7 downto 0); 

    -- signals to/from 'ports'
    pbi       : out std_logic_vector(7 downto 0);
    pbo       : in  std_logic_vector(7 downto 0);
    pci       : out std_logic_vector(7 downto 0);-- port normal function 'in'
    pco       : in  std_logic_vector(7 downto 0);-- port normal function 'out'
    pdi       : out std_logic_vector(7 downto 0); 
    pdo       : in  std_logic_vector(7 downto 0); 
    peo       : in  std_logic_vector(7 downto 0); 
    pei       : out std_logic_vector(7 downto 0); 
    pfo       : in  std_logic_vector(7 downto 0); 
    pfi       : out std_logic_vector(7 downto 0); 
    pgo       : in  std_logic_vector(7 downto 0); 
    pgi       : out std_logic_vector(7 downto 0); 
    pho       : in  std_logic_vector(7 downto 0); 
    phi       : out std_logic_vector(7 downto 0); 
    pien      : in  std_logic_vector(7 downto 0);                    
    pio       : in  std_logic_vector(7 downto 0); 
    pii       : out std_logic_vector(7 downto 0);     
    pjo       : in  std_logic_vector(7 downto 0); 
    pji       : out std_logic_vector(7 downto 0); 

    -- signals to/from UARTs, ethernet, MMR, I/O bus, PDI and DMA.
    utx1      : in  std_logic;                     
    urx1      : out std_logic;                     
    urts1     : in  std_logic;                     
    ucts1     : out std_logic;                     
    utx2      : in  std_logic;                     
    urx2      : out std_logic;                     
    urts2     : in  std_logic;                     
    ucts2     : out std_logic;                     
    utx3      : in  std_logic;                     
    urx3      : out std_logic;                     
    urts3     : in  std_logic;                     
    ucts3     : out std_logic;                     
    ecrs      : out std_logic;                     
    ecol      : out std_logic;                     
    etxer     : in  std_logic;                     
    etxen     : in  std_logic;                     
    etxd      : in  std_logic_vector(3 downto 0);  
    etxclk    : out std_logic;                     
    erxdv     : out std_logic;                     
    erxer     : out std_logic;                     
    erxd      : out std_logic_vector(3 downto 0);  
    erxclk    : out std_logic;                     
    ddqm      : in  std_logic_vector(7 downto 0);
    pdi_d     : in  std_logic_vector(7 downto 0);
    idi       : out std_logic_vector(7 downto 0);  
    ido       : in  std_logic_vector(7 downto 0);  
    iden      : in  std_logic;                     
    clk_i     : in  std_logic;                     
    ilioa     : in  std_logic;                     
    ildout    : in  std_logic;                     
    inext     : in  std_logic;
    idack     : in  std_logic_vector(7 downto 0); -- from IOS to external
    idreq     : out std_logic_vector(7 downto 0) -- from external to io_mux
--     -- signals for serial interface
--     sck_o     : in  std_logic;
--     mosi_o    : in  std_logic;
--     miso_o    : in  std_logic
    );
  
end port_mux;

architecture rtl of port_mux is

begin  -- rtl
  -- UART1 mux
  pj_o(3 downto 0) <= pjo(3 downto 0) when en_uart1 = '0' else
                      pjo(3) & urts1 & pjo(1) & utx1;
  pji(3 downto 0) <= pj_i(3 downto 0);
  urx1 <= pj_i(1);
  ucts1 <= pj_i(3);

  -- UART2 mux
  pe_o(3 downto 0) <= peo(3 downto 0) when en_uart2 = '0' else
                      peo(3) & urts2 & peo(1) & utx2;
  pei(3 downto 0) <= pe_i(3 downto 0);
  urx2 <= pe_i(1);
  ucts2 <= pe_i(3);  

  -- UART3 mux
  pe_o(7 downto 4) <= peo(7 downto 4) when en_uart3 = '0' else
                      peo(7) & urts3 & peo(5) & utx3;
  pei(7 downto 4) <= pe_i(7 downto 4);
  urx3 <= pe_i(5);
  ucts3 <= pe_i(7);  

  -- Ethernet mux
	pf_o		<= pfo when en_eth = "00" else
						 pfo(7 downto 4) & etxd(1 downto 0) & pfo(1) & etxen;
	pfi			<= pf_i;
	etxclk	<= pf_i(1);
	erxdv		<= pf_i(4);
	erxer		<= pf_i(5);
	erxd(1 downto 0)	<= pf_i(7 downto 6);

	pg_o		<= pgo when en_eth(0) = '0' else
						 pgo(7 downto 4) & etxd(3 downto 2) & pgo(1) & etxer;
	pgi			<= pg_i;
	erxclk	<= pg_i(1);
	ecol		<= pg_i(4);
	ecrs		<= pg_i(5);
	erxd(3 downto 2)	<= pg_i(7 downto 6);

  -- Serial interface and DDQM mux
  pd_o <= pdo when dqm_size = "00" else
          pdo(7 downto 2) & ddqm(1 downto 0) when dqm_size = "01" else
          pdo(7 downto 4) & ddqm(3 downto 0) when dqm_size = "10" else
          ddqm;
  pdi <= pd_i;

  -- Parallel data interface mux
  pb_o <= pbo when en_pdi = '0' else
          pdi_d;
  pbi <= pb_i;
  
  -- I/O bus
  pi_en <= pien when en_iobus = "00" else
           (others => iden);
  pi_o <= pio when en_iobus = "00" else
          ido;
  pii <= pi_i;
  
  idi <= ido when en_iobus = "00" else pi_i;

  pj_o(7 downto 4) <= pjo(7 downto 4) when en_iobus = "00" else
                      clk_i & ilioa & ildout & inext;
  pji(7 downto 4) <= pj_i(7 downto 4);

  -- DMA
  ph_o <= pho when en_iobus(1) = '0' else
          idack(3 downto 0) & "0000";
  phi <= ph_i;
  idreq(3 downto 0) <= "1111" when en_iobus(1) = '0' else
                       ph_i(3 downto 0);
  
  pc_o <= pco when en_iobus /= "11" else
          idack(7 downto 4) & "0000";
  pci <= pc_i;
  idreq(7 downto 4) <= "1111" when en_iobus /= "11" else
                       pc_i(3 downto 0);
  
end rtl;
