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
-- Title      : Testbench
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : spboot_tb.vhd
-- Author     : Christian Blixt
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
-- 2006-02-22		1.00			CB			Created.
-- 2021-20-28                           JM              Modified for IM3000e
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity spboot_tb is
end spboot_tb;

architecture struct of spboot_tb is
  signal MX1_CK       : std_logic;                      
  signal MXOUT        : std_logic;                      
  signal MEXEC        : std_logic;                      
  signal MCKOUT0      : std_logic;                      
  signal MCKOUT1      : std_logic;                      
  signal MSDIN        : std_logic;                      
  signal MSDOUT       : std_logic;                      
  signal MIRQOUT      : std_logic;                      
  signal PD           : std_logic_vector(7 downto 0);   
  signal PJ           : std_logic_vector(7 downto 0);   
  signal PI           : std_logic_vector(7 downto 0);   
  signal PH           : std_logic_vector(7 downto 0);   
  signal PC           : std_logic_vector(7 downto 0);   
  signal MBYPASS      : std_logic;                      
  signal MRESET       : std_logic;                      
  signal MRSTOUT      : std_logic;                      
  signal MTEST        : std_logic;                      
  signal MWAKE        : std_logic;                      
  signal MIRQ0        : std_logic;                      
  signal MIRQ1        : std_logic;                      
  signal MRXOUT       : std_logic;                      
  signal PE           : std_logic_vector(7 downto 0);   
  signal PF           : std_logic_vector(7 downto 0);   
  signal PG           : std_logic_vector(7 downto 0);   
  signal PA           : std_logic_vector(7 downto 0);   
  signal PB           : std_logic_vector(7 downto 0);   
  signal XTAL1        : std_logic;                      
  signal DDQ          : std_logic_vector(7 downto 0);   
  signal DCLK         : std_logic;                      
  signal DCS          : std_logic;                      
  signal DRAS         : std_logic;                      
  signal DCAS         : std_logic;                      
  signal DWE          : std_logic;                      
  signal DBA          : std_logic_vector(1 downto 0);   
  signal DA           : std_logic_vector(13 downto 0);  
  signal DCKE         : std_logic_vector(3 downto 0);   
  signal MPORDIS      : std_logic;                      
  signal MPLL_TSTO    : std_logic;
  signal RTCLK      : std_logic := '0';
  signal MLP_PWR_OK : std_logic := '0';
  signal DDQM : std_logic_vector(7 downto 0);
  
 
  -- mirror signals of 'clk_d', to get no-skew clock for DRAM.
  signal top_clk_d     : std_logic;
 
begin  -- struct

  top0 : entity work.top
    port map (
      HCLK    => MX1_CK,        
      MRESET  => MRESET,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      MCKOUT1 => MCKOUT1,
      MTEST   => MTEST,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug                                                               
      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,

      D_CLK   => DCLK,
      D_CS    => DCS,
      D_RAS   => DRAS,
      D_CAS   => DCAS,
      D_WE    => DWE, 
      D_DQM   => DDQM,
      D_DQ    => DDQ,
      D_A     => DA,
      D_BA    => DBA,
      D_CKE   => DCKE,   
      
      PA => PA,
      PB => PB,
      PC => PC,
      PD => PD,
      PE => PE,
      PF => PF,
      PH => PH,
      PI => PI,
      PJ => PJ,

      MBYPASS    => MBYPASS,
      MWAKEUP_LP => MWAKE,
      MLP_PWR_OK => MLP_PWR_OK,

      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => XTAL1,
      --rxout    => RTCLK,
      adc_bits => '0'
      );

  -- Connect MLP_PWR_OK to reset for simlicity. 
  MLP_PWR_OK <= MRESET;

  RTCLK <= MX1_CK;      

  -----------------------------------------------------------------------------
  -- SDRAM
  -----------------------------------------------------------------------------
  sdram: entity work.mt48lc4m16a2
    generic map(
    		-- CAS latency 3
        tAC        => 5.4 ns,
        tHZ        => 5.4 ns,
        tOH        => 2.7 ns,
        tMRD       => 2, 
        tRAS       => 45.0 ns,
        tRC        => 65.0 ns,
        tRCD       => 20.0 ns,
        tRP        => 20.0 ns,
        tRRD       => 15.0 ns,
        tWRa       => 7.5 ns, 
        tWRp       => 15.0 ns,             
        tAH        => 0.8 ns,
        tAS        => 1.5 ns,
        tCH        => 2.5 ns,
        tCL        => 2.5 ns,
        tCK        => 7.5 ns,
        tDH        => 0.8 ns,
        tDS        => 1.5 ns,
        tCKH       => 0.8 ns,
        tCKS       => 1.5 ns,
        tCMH       => 0.8 ns,
        tCMS       => 1.5 ns,                 
               
        addr_bits  => 12,
        data_bits  => 16,
        col_bits   => 8)
    port map(
        Dq(15 downto 8) => DDQ,
        Dq(7 downto 0)  => DDQ,
        Addr            => DA(11 downto 0),             
        Ba              => DBA,                         
        Clk             => top_clk_d,                        
        Cke             => DCKE(0),                     
        Cs_n            => DCS,                         
        Ras_n           => DRAS,                        
        Cas_n           => DCAS,                        
        We_n            => DWE,                         
        Dqm             => DDQM(1 downto 0), --PD(1 downto 0),              
        Load            => '0',                         
        Unload          => '0',                         
        Row_start       => 0,                           
        Row_end         => 0);                          

  -----------------------------------------------------------------------------
  -- STIMULI
  -----------------------------------------------------------------------------
  stim: entity work.spboot_stim
    port map (
      MX1_CK    => MX1_CK,      
      MXOUT     => MXOUT,       
      MEXEC     => MEXEC,       
      MCKOUT0   => MCKOUT0,     
      MCKOUT1   => MCKOUT1,     
      MSDIN     => MSDIN,       
      MSDOUT    => MSDOUT,      
      MIRQOUT   => MIRQOUT,          
      MBYPASS   => MBYPASS,          
      MRESET    => MRESET,      
      MRSTOUT   => MRSTOUT,     
      MTEST     => MTEST,       
      MWAKE     => MWAKE,       
      MIRQ0     => MIRQ0,       
      MIRQ1     => MIRQ1,          
      MRXOUT    => MRXOUT,      
      PA        => PA,                  
      PB        => PB,                  
      XTAL1     => XTAL1,
      MPORDIS   => MPORDIS);          

  MRSTOUT <= << signal top0.mrstout_o : std_logic >>;
end struct;
