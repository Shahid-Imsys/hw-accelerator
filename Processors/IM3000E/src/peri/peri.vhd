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
-- Title      : Peripheral logic
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : peri.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.8				CB			Created
-- 2005-12-10		1.9				CB			New UART design
-- 2006-03-08		1.10 			CB			Removed adc_fb, replaced en_dac with dac_en
--																and en_adc with adc_en,	added dac_en, adc_en,
--																adc_ref2v, adc_extref and adc_diff ports.
-- 2012-06-15       2.0             MN          Added clk_c to ports module
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.gp_pkg.all;
use IEEE.std_logic_unsigned.all;
use work.all;

entity peri is  
  port (
---------------------------------------------------------------------
    -- Signals to/from other blocks
---------------------------------------------------------------------
    -- Clocks to/from clock block
    clk_p       : in  std_logic;
    clk_c_en    : in  std_logic;
    clk_e_pos   : in  std_logic;  -- Execution clock
    clk_e_neg   : in  std_logic;  -- Execution clock
    clk_i       : in  std_logic;  -- I/O clock    
    clk_i_pos   : in  std_logic;  -- I/O clock    
    clk_u_pos   : in  std_logic;  -- UART clock
    clk_rx      : in  std_logic;  -- ERx clock
    clk_tx      : in  std_logic;  -- ETx clock
    clk_a_pos   : in  std_logic;  -- Analog clock
    erxclk      : out std_logic;  -- erxclk from pad to 'clock' block
    etxclk      : out std_logic;  -- etxclk from pad to 'clock' block
    din_a       : out std_logic;  -- D input to FF generating clk_a
    -- to/from core block
    dbus        : in  std_logic_vector(7 downto 0);
    dfp         : out std_logic_vector(7 downto 0); 
    rst_en      : in  std_logic;
    --rst_en2     : in  std_logic;
    pl_pd       : in  std_logic_vector(2 downto 0);
    pl_aaddr    : in  std_logic_vector(4 downto 0);
    idack       : in  std_logic_vector(7 downto 0);                   
    ios_iden    : in  std_logic;                   
    ios_ido     : in  std_logic_vector(7 downto 0);                  
    ilioa       : in  std_logic;                   
    ildout      : in  std_logic;                   
    inext       : in  std_logic;
    iden        : out std_logic;
    --dqm_size    : in  std_logic_vector(1 downto 0);
    en_uart1    : in  std_logic;
    en_uart2    : in  std_logic;
    en_uart3    : in  std_logic;
    en_eth      : in  std_logic_vector(1 downto 0);
    en_tiu      : in  std_logic;
    run_tiu     : in  std_logic;
    en_iobus    : in  std_logic_vector(1 downto 0);
    --ddqm        : in  std_logic_vector(7 downto 0);
    idreq       : out std_logic_vector(7 downto 0);
    idi         : out std_logic_vector(7 downto 0);
    irq0        : out std_logic;
    irq1        : out std_logic;
    tstamp      : out std_logic_vector(2 downto 0);
    tiu_tstamp  : in  std_logic;
    -- to/from analog block
    ach_sel     : out std_logic_vector(2 downto 0);
		adc_bits		: in	std_logic;
    adc_extref	: out	std_logic;	-- Select external ADC reference (internal)
    adc_diff		: out	std_logic;	-- Select differential ADC mode (single-ended)
    adc_en			: out	std_logic;	-- Enable for the ADC
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
    pj_o        : out std_logic_vector(7 downto 0)
   
   );
end peri;

architecture struct of peri is
  -----------------------------------------------------------------------------
  -- Internal signals driven by sub-blocks
  -----------------------------------------------------------------------------
  -- PORTS
  signal pao     		: std_logic_vector(7 downto 0);
  signal pbo     		: std_logic_vector(7 downto 0);
  signal pco     		: std_logic_vector(7 downto 0);
  signal pdo     		: std_logic_vector(7 downto 0);
  signal peo     		: std_logic_vector(7 downto 0);
  signal pfo     		: std_logic_vector(7 downto 0);
  signal pgo     		: std_logic_vector(7 downto 0);
  signal pho      	: std_logic_vector(7 downto 0);
  signal pien    		: std_logic_vector(7 downto 0);
  signal pio     		: std_logic_vector(7 downto 0);
  signal pjo     		: std_logic_vector(7 downto 0);
  signal reg_wr     : std_logic;
  signal wdata   		: std_logic_vector(7 downto 0);
  signal reg_addr		: std_logic_vector(7 downto 0);
  signal cpt_trig		: std_logic_vector(7 downto 0);
  signal pdi_en  		: std_logic;
  signal pdi_dir 		: std_logic;
  signal adc_en_int	: std_logic;
  signal adc_prec		: std_logic;
  signal adc_run		: std_logic;
  signal adc_mode		: std_logic_vector(1 downto 0);
  signal adc_done		: std_logic;
  signal adc_data		: std_logic_vector(15 downto 0);
  signal speed_a 		: std_logic_vector(2 downto 0);
  signal dac_en_int	: std_logic_vector(0 to 1);
  signal dac_data		: dac_data_type;
  
  -- PORT_MUX
  signal pbi       : std_logic_vector(7 downto 0); 
  signal pci       : std_logic_vector(7 downto 0);  
  signal pdi       : std_logic_vector(7 downto 0);
  signal pei       : std_logic_vector(7 downto 0);
  signal pfi       : std_logic_vector(7 downto 0);
  signal pgi       : std_logic_vector(7 downto 0);
  signal phi       : std_logic_vector(7 downto 0);
  signal pii       : std_logic_vector(7 downto 0);
  signal pji       : std_logic_vector(7 downto 0);
  signal urx1      : std_logic;
  signal ucts1     : std_logic;
  signal urx2      : std_logic;
  signal ucts2     : std_logic;
  signal urx3      : std_logic;
  signal ucts3     : std_logic;
  signal ecrs      : std_logic;
  signal ecol      : std_logic;
  signal erxdv     : std_logic;
  signal erxer     : std_logic;
  signal erxd      : std_logic_vector(3 downto 0);
  signal idi_int   : std_logic_vector(7 downto 0);
  signal idreq_int : std_logic_vector(7 downto 0);
  
  -- IO_MUX 
  signal iden_int  : std_logic;
  signal ido       : std_logic_vector(7 downto 0);
  signal rx1_idack : std_logic;
  signal rx2_idack : std_logic;
  signal tx_idack  : std_logic;
  signal pdi_idack : std_logic;
  
  -- UARTs
  signal uart1_ido  : std_logic_vector(7 downto 0);
  signal uart2_ido  : std_logic_vector(7 downto 0);
  signal uart3_ido  : std_logic_vector(7 downto 0);
  signal uart1_iden : std_logic;
  signal uart2_iden : std_logic;
  signal uart3_iden : std_logic;
  signal utx1       : std_logic;
  signal urts1      : std_logic;
  signal uart1_irq  : std_logic;
  signal utx2       : std_logic;
  signal urts2      : std_logic;
  signal uart2_irq  : std_logic;
  signal utx3       : std_logic;
  signal urts3      : std_logic;
  signal uart3_irq  : std_logic;
  
  --Ethernet
  signal eth_ido    : std_logic_vector(7 downto 0);
  signal eth_iden   : std_logic;
  signal rx1_irq    : std_logic;
  signal rx2_irq 	  : std_logic;
  signal tx_irq 	  : std_logic;
  signal rx1_idreq  : std_logic;
  signal rx2_idreq  : std_logic;
  signal tx_idreq   : std_logic;
  signal etxer      : std_logic;
  signal etxen      : std_logic;
  signal etxd       : std_logic_vector(3 downto 0);

  -- Timer
  signal tiu_out    : std_logic_vector(7 downto 0);
  signal tiu_irq    : std_logic;
  signal pulseout   : std_logic_vector(7 downto 0);
  signal pdi_clk    : std_logic;
  -- Parallel Data Interface
  signal pdi_idreq : std_logic;
  signal pdi_ido   : std_logic_vector(7 downto 0);
  signal pdi_iden  : std_logic;
  signal pdi_d_o   : std_logic_vector(7 downto 0);

  -- ADC & DAC
  signal ctr_a			: std_logic_vector(3 downto 0);
  signal din_a_int	: std_logic;

begin  -- struct
-------------------------------------------------------------------------------
-- Parallel Data Interface
-------------------------------------------------------------------------------
  parallel: entity work.pdi_inf
    port map(
    clk_p		=> clk_p,
	clk_i_pos	=> clk_i_pos,
    idi     => idi_int,
    idack   => pdi_idack,
    idreq   => pdi_idreq,
    ido     => pdi_ido,
    id_en   => pdi_iden,
    pdi_clk => pdi_clk,      
    pdi_en  => pdi_en,
    pdi_dir => pdi_dir,
    pdi_d_i => pbi,              
    pdi_d_o => pdi_d_o);
-------------------------------------------------------------------------------
-- Timer
-------------------------------------------------------------------------------
  timer: entity work.tiu
  port map(
    clk_p       => clk_p,
    clk_c_en    => clk_c_en,
    rst_en      => rst_en,
    reg_wr      => reg_wr,
    wdata       => wdata,
    reg_addr    => reg_addr,
    run         => run_tiu,
    tiu_enable  => en_tiu,
    tiu_irq     => tiu_irq,
    tiu_out     => tiu_out,
    pdi_clk     => pdi_clk,
    cpt_trig    => cpt_trig,
    tstamp_rx1  => tiu_tstamp,
    pulseout    => pulseout);

------------------------------------------------------------------------
-- PORTS
------------------------------------------------------------------------
  ports: entity work.ports
    port map(
      -- Clock and reset inputs
      rst_en    => rst_en,
      --rst_en2   => rst_en2,
      clk_e_pos     => clk_e_pos,
      clk_e_neg     => clk_e_neg,
      clk_p     => clk_p,
      -- Microprogram fields
      pl_aaddr  => pl_aaddr,
      pl_pd     => pl_pd,
      -- Data paths
      dbus      => dbus,
      dfp       => dfp,  
      -- port A
      paen      => pa_en,
      pao       => pa_o,
      pai       => pa_i,
      -- port B
      pben      => pb_en,
      pbo       => pbo,
      pbi       => pbi,
      -- port C
      pcen      => pc_en,
      pco       => pco,
      pci       => pci,
      -- port D
      pden      => pd_en,
      pdo       => pdo,
      pdi       => pdi,
      -- port E
      peen      => pe_en,
      peo       => peo,
      pei       => pei,
      -- port F
      pfen      => pf_en,
      pfo       => pfo,
      pfi       => pfi,
      -- port G
      pgen      => pg_en,
      pgo       => pgo,
      pgi       => pgi,
      -- port H
      phen      => ph_en,
      pho       => pho,
      phi       => phi,
      -- port I
      pien      => pien,
      pio       => pio,
      pii       => pii,
      -- port J
      pjen      => pj_en,
      pjo       => pjo,
      pji       => pji,
      -- interrupt signals to core                                       
      irq0      => irq0,
      irq1      => irq1,
      -- interrupt sources                                       
      mirq0_i   => mirq0_i,
      mirq1_i   => mirq1_i,
      uart1_irq => uart1_irq,
      uart2_irq => uart2_irq,
      uart3_irq => uart3_irq,
      rx1_irq   => rx1_irq,
      rx2_irq   => rx2_irq,
      tx_irq    => tx_irq,
      -- timer signals
      tiu_out    => tiu_out,
      pulseout   => pulseout,
      tiu_irq    => tiu_irq,
      reg_wr     => reg_wr,
      wdata      => wdata,
      reg_addr   => reg_addr,
      cpt_trig   => cpt_trig,
      pdi_en     => pdi_en,
      pdi_dir    => pdi_dir,
      -- analog block control signals
      ach_sel    => ach_sel,
      adc_extref => adc_extref,
      adc_diff   => adc_diff,
      adc_en     => adc_en_int,
      adc_prec   => adc_prec,
      adc_run    => adc_run,
      adc_mode   => adc_mode,
      adc_done   => adc_done,
      adc_data   => adc_data,
      speed_a    => speed_a,
      dac_en     => dac_en_int,
      dac_data   => dac_data);

	adc_en <= adc_en_int;
	dac_en <= dac_en_int;

-------------------------------------------------------------------------------
-- PORT_MUX
-------------------------------------------------------------------------------
  port_mux: entity work.port_mux
    port map(
      -- ports mux control signals from Configuration register
      --dqm_size  => dqm_size,
      en_uart1  => en_uart1,
      en_uart2  => en_uart2,
      en_uart3  => en_uart3,
      en_eth    => en_eth,
      en_iobus  => en_iobus,
      en_pdi    => pdi_en,
      pb_i      => pb_i,
      pb_o      => pb_o,
      pc_i      => pc_i,
      pc_o      => pc_o,
      pd_i      => pd_i,
      pd_o      => pd_o,
      pe_i      => pe_i,
      pe_o      => pe_o,
      pf_i      => pf_i,
      pf_o      => pf_o,
      pg_i      => pg_i,
      pg_o      => pg_o,
      ph_i      => ph_i,
      ph_o      => ph_o,
      pi_en     => pi_en,
      pi_i      => pi_i,
      pi_o      => pi_o,
      pj_i      => pj_i,
      pj_o      => pj_o,
      pbi       => pbi,
      pbo       => pbo,
      pci       => pci,
      pco       => pco,
      pdi       => pdi,
      pdo       => pdo,
      pei       => pei,
      peo       => peo,
      pfi       => pfi,
      pfo       => pfo,
      pgi       => pgi,
      pgo       => pgo,
      phi       => phi,
      pho       => pho,
      pien      => pien,
      pii       => pii,
      pio       => pio,
      pji       => pji,
      pjo       => pjo,
      utx1      => utx1,
      urx1      => urx1,
      urts1     => urts1,
      ucts1     => ucts1,
      utx2      => utx2,
      urx2      => urx2,
      urts2     => urts2,
      ucts2     => ucts2,
      utx3      => utx3,
      urx3      => urx3,
      urts3     => urts3,
      ucts3     => ucts3,
      ecrs      => ecrs,
      ecol      => ecol,
      etxer     => etxer,
      etxen     => etxen,
      etxd      => etxd,
      etxclk    => etxclk,
      erxdv     => erxdv,
      erxer     => erxer,
      erxd      => erxd,
      erxclk    => erxclk,
      --ddqm      => ddqm,
      pdi_d     => pdi_d_o, 
      idi       => idi_int,
      ido       => ido,
      iden      => iden_int,
      clk_i     => clk_i,
      ilioa     => ilioa,
      ildout    => ildout,
      inext     => inext,
      idack     => idack,
      idreq     => idreq_int);
  
  idi <= idi_int;
    
-------------------------------------------------------------------------------
-- IO_MUX
-------------------------------------------------------------------------------
  io_mux: entity work.io_mux
    port map(
      en_eth        => en_eth,
      en_pdi        => pdi_en, 
      ios_iden      => ios_iden,
      ios_ido       => ios_ido,
      uart1_iden    => uart1_iden,
      uart1_ido     => uart1_ido,
      uart2_iden    => uart2_iden,
      uart2_ido     => uart2_ido,
      uart3_iden    => uart3_iden,
      uart3_ido     => uart3_ido,
      eth_iden      => eth_iden,
      eth_ido       => eth_ido,
      pdi_iden      => pdi_iden,
      pdi_ido       => pdi_ido, 
      iden          => iden_int,
      ido           => ido,
      -- IDREQ
      idreq         => idreq_int,
      rx1_idreq     => rx1_idreq,
      rx2_idreq     => rx2_idreq,
      tx_idreq      => tx_idreq,
      pdi_idreq     => pdi_idreq, 
      ios_idreq     => idreq,
      -- IDACK
      idack         => idack,
      rx1_idack     => rx1_idack,
      rx2_idack     => rx2_idack,
      tx_idack      => tx_idack,
      pdi_idack     => pdi_idack);
  
  iden <= iden_int;

-------------------------------------------------------------------------------
-- UARTs
-------------------------------------------------------------------------------
  uart1: entity work.uart
    generic map(
      uart_reg_address        => com1_reg_address,
      uart_prescaler_address  => com1_prescaler_address,
      uart_flag_address       => com1_flag_address,
      uart_fx_address         => com1_fx_address)
    port map(
      rst_en   => en_uart1,
      clk_p    => clk_p,
      clk_i_pos    => clk_i_pos,
      clk_u_pos    => clk_u_pos,
      clk_u_ce => '1',
      idi      => idi_int,
      ido      => uart1_ido,
      iden     => uart1_iden, 
      ilioa    => ilioa,
      ildout   => ildout,
      inext    => inext,
      uart_en  => open,
      irq      => uart1_irq,
      rx       => urx1,
      tx       => utx1,
      cts      => ucts1,
      rts      => urts1);

  uart2: entity work.uart
    generic map(
      uart_reg_address        => com2_reg_address,
      uart_prescaler_address  => com2_prescaler_address,
      uart_flag_address       => com2_flag_address,
      uart_fx_address         => com2_fx_address)
    port map(
      rst_en   => en_uart2,
      clk_p    => clk_p,
      clk_i_pos    => clk_i_pos,
      clk_u_pos    => clk_u_pos,
      clk_u_ce => '1',
      idi      => idi_int,
      ido      => uart2_ido,
      iden     => uart2_iden, 
      ilioa    => ilioa,
      ildout   => ildout,
      inext    => inext,
      uart_en  => open,
      irq      => uart2_irq,
      rx       => urx2,
      tx       => utx2,
      cts      => ucts2,
      rts      => urts2);

  uart3: entity work.uart
    generic map(
      uart_reg_address        => com3_reg_address,
      uart_prescaler_address  => com3_prescaler_address,
      uart_flag_address       => com3_flag_address,
      uart_fx_address         => com3_fx_address)
    port map(
      rst_en   => en_uart3,
      clk_p    => clk_p,
      clk_i_pos    => clk_i_pos,
      clk_u_pos    => clk_u_pos,
      clk_u_ce => '1',
      idi      => idi_int,
      ido      => uart3_ido,
      iden     => uart3_iden, 
      ilioa    => ilioa,
      ildout   => ildout,
      inext    => inext,
      uart_en  => open,
      irq      => uart3_irq,
      rx       => urx3,
      tx       => utx3,
      cts      => ucts3,
      rts      => urts3);

-------------------------------------------------------------------------------
-- ETH
-------------------------------------------------------------------------------
  eth: entity work.eth
    generic map(
      TX_CTL_ADR		=> Tx_ctl_addr,
      RX_CTL_ADR		=> Rx_ctl_addr,
      RX_DA_ADR			=> Rx_da_addr,
      RX_STS_ADR		=> Rx_frame_sts_addr,
      RX_CTL_ADR_2	=> Rx_ctl_addr_2,
      RX_DA_ADR_2		=> Rx_da_addr_2,
      RX_STS_ADR_2	=> Rx_frame_sts_addr_2)
    port map(
			-- Processor interface
      clk_p		=> clk_p,
      clk_i_pos	=> clk_i_pos,
      ilioa			=> ilioa,
      ildout		=> ildout,
      inext			=> inext,
      idi				=> idi_int,
      ido				=> eth_ido,
      iden			=> eth_iden, 
      rx1_irq		=> rx1_irq,
      rx2_irq		=> rx2_irq,
      tx_irq		=> tx_irq,
      rx1_idack	=> rx1_idack,
      rx1_idreq	=> rx1_idreq,
      rx2_idack	=> rx2_idack,
      rx2_idreq	=> rx2_idreq,
      tx_idack	=> tx_idack,
      tx_idreq	=> tx_idreq,
			-- PHY interface
      clk_rx    => clk_rx,
      clk_tx    => clk_tx,
      erxdv     => erxdv, 
      erxer     => erxer, 
      erxd      => erxd,  
      etxen     => etxen, 
      etxer     => etxer, 
      ecol      => ecol,  
      ecrs      => ecrs,  
      etxd      => etxd,  
			-- Other control inputs and outputs
      tstamp    => tstamp,
      en_eth    => en_eth);

-------------------------------------------------------------------------------
-- ADC & DAC
-------------------------------------------------------------------------------
	-- Generate din_a, this is the D input expression for the
	-- FF in the clock block that generates clk_a.
	-- clk_u is a programmable subdivision of clk_c, controlled
	-- by speed_a. clk_a has 50% duty cycle.
	process (clk_p)
	begin
		if rising_edge(clk_p) then --rising_edge(clk_c)
		    if rst_en = '0' then
		        ctr_a <= "0000";
		        din_a_int <= '1';
		    elsif clk_c_en = '1' then
			    if dac_en_int(0) = '0' and dac_en_int(1) = '0' and adc_en_int = '0' then
			    	ctr_a <= "0000";
			    	din_a_int <= '1';
			    else			
			    	if ctr_a = "0000" then
			    		din_a_int <= not din_a_int;
			    		ctr_a <= ('0' & speed_a) + 3;
			    	else
			    		ctr_a <= ctr_a - 1;
			    	end if;
			    end if;
			end if;
		end if;
	end process;
	din_a <= din_a_int;

  adc: entity work.adc
    port map(  
      clk_p         => clk_p,
      clk_a_pos			=> clk_a_pos,
      rst_n			=> adc_en_int,
      adc_prec  => adc_prec,
      adc_run   => adc_run,
      adc_mode  => adc_mode,
      adc_bits  => adc_bits,
      adc_done	=> adc_done,
      adc_data	=> adc_data);

  dac: entity work.dac
    port map(
        clk_p      => clk_p,
      clk_a_pos			=> clk_a_pos,
      rst_n			=> dac_en_int,
      dac_data	=> dac_data,
      dac_bits	=> dac_bits);

end struct;
