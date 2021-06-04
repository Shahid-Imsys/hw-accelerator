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
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;
library modelsim_lib;
--use modelsim_lib.util.all;

entity spboot_tb is
--  generic (
--    rtl_model : boolean := true);
end spboot_tb;

architecture struct of spboot_tb is
  signal HCLK         : std_logic;
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

--  signal cs_n         : std_logic_vector(3 downto 0);
  
--  -- mirror signals of 'clk_e', 'dbus', 'ybus' and 'curr_mpga'.
--  signal top_clk_e     : std_logic;
--  signal top_dbus      : std_logic_vector(7 downto 0);
--  signal top_ybus      : std_logic_vector(7 downto 0);
--  signal top_mpga      : std_logic_vector(13 downto 0);
 
  -- mirror signals of 'clk_d', to get no-skew clock for DRAM.
  signal top_clk_d     : std_logic;


 
begin  -- struct
process
begin
  wait for 64 ns;
  --MSDIN <= '1';
  MTEST <= '1';	
  MRESET <= '1';
  wait until rising_edge(MCKOUT0);
  MTEST <= '0';
  wait;
  --wait until rising_edge(MCKOUT0);
  --MTEST <= '0';	
 end process;

  top0: entity work.imsys_top
    port map (
	  --PA   => PA,
      HCLK  => HCLK,
      -- Left edge
      --MX1_CK      => MX1_CK,         
      --MX2         => open,
      --MXOUT       => MXOUT,          
      --MEXEC       => MEXEC,          
      MCKOUT0     => MCKOUT0,   
      MCKOUT1     => MCKOUT1,   
      MSDIN       => MSDIN,          
      MSDOUT      => MSDOUT,         
      MIRQOUT     => MIRQOUT,       
      --PD0_DDQM0   => PD(0),          
      --PD1_DDQM1   => PD(1),          
      --PD2_DDQM2   => PD(2),          
      --PD3_DDQM3   => PD(3),          
      --PD4_DDQM4   => PD(4),          
      --PD5_DDQM5   => PD(5),          
      --PD6_DDQM6   => PD(6),          
      --PD7_DDQM7   => PD(7),          
      --PJ4_INEXT   => PJ(4),
      --PJ5_ILDOUT  => PJ(5),
      --PJ6_ILIOA   => PJ(6),
      --PJ7_ICLK    => PJ(7),
      --PI0_ID0     => PI(0),      
      --PI1_ID1     => PI(1),      
      --PI2_ID2     => PI(2),      
      --PI3_ID3     => PI(3),      
      --PI4_ID4     => PI(4),      
      --PI5_ID5     => PI(5),      
      --PI6_ID6     => PI(6),      
      --PI7_ID7     => PI(7),
      --PH0_IDREQ0  => PH(0),
      --PH1_IDREQ1  => PH(1),
      --PH2_IDREQ2  => PH(2),
      --PH3_IDREQ3  => PH(3),
      --PH4_IDACK0  => PH(4),
      --PH5_IDACK1  => PH(5),
      --PH6_IDACK2  => PH(6),
      --PH7_IDACK3  => PH(7),
      -- Bottom edge
      --PC0_IDREQ4  => PC(0),             
      --PC1_IDREQ5  => PC(1),             
      --PC2_IDREQ6  => PC(2),             
      --PC3_IDREQ7  => PC(3),             
      --PC4_IDACK4  => PC(4),             
      --PC5_IDACK5  => PC(5),             
      --PC6_IDACK6  => PC(6),             
      --PC7_IDACK7  => PC(7),     
      MBYPASS     => MBYPASS,            
      MRESET      => MRESET,    
      --MRSTOUT     => MRSTOUT,        
      MTEST       => MTEST,     
      --MWAKE       => MWAKE,     
      MIRQ0       => MIRQ0,     
      MIRQ1       => MIRQ1);       
      --MRXOUT      => MRXOUT,
      --PJ0_UTX1    => PJ(0),
      --PJ1_URX1    => PJ(1),
      --PJ2_URTS1   => PJ(2),
      --PJ3_UCTS1   => PJ(3),
      --PE0_UTX2    => PE(0),
      --PE1_URX2    => PE(1),
      --PE2_URTS2   => PE(2),
      --PE3_UCTS2   => PE(3),
      --PE4_UTX3    => PE(4),
      --PE5_URX3    => PE(5),
      --PE6_URTS3   => PE(6),
      --PE7_UCTS3   => PE(7),
      --PF0_ETXEN   => PF(0),
      --PF1_ETXCLK  => PF(1),
      --PF2_ETXD0   => PF(2),
      --PF3_ETXD1   => PF(3),
      --PF4_ERXDV   => PF(4),
      --PF5_ERXER   => PF(5),
      --PF6_ERXD0   => PF(6),
      --PF7_ERXD1   => PF(7),
      --PG0_ETXER   => PG(0),
      --PG1_ERXCLK  => PG(1),
      --PG2_ETXD2   => PG(2),
      --PG3_ETXD3   => PG(3),
      --PG4_ECOL    => PG(4),
      --PG5_ECRS    => PG(5),
      --PG6_ERXD2   => PG(6),
      --PG7_ERXD3   => PG(7),
      --PA0         => PA(0),     
      --PA1         => PA(1),             
      --PA2         => PA(2),             
      --PA3         => PA(3),             
      --PA4         => PA(4),             
      --PA5         => PA(5),             
      --PA6         => PA(6),             
      --PA7         => PA(7),             
      --PB0         => PB(0),             
      ---- Right edge  
      --PB1         => PB(1),             
      --PB2         => PB(2),             
      --PB3         => PB(3),             
      --PB4         => PB(4),             
      --PB5         => PB(5),             
      --PB6         => PB(6),             
      --PB7         => PB(7),             
      --XTAL1       => XTAL1,             
      --XTAL2       => open,             
      --VREGEN      => '0',             
      --EXTREF      => '0',             
      --ACH0        => '0',             
      --ACH1        => '0',             
      --ACH2        => '0',             
      --ACH3        => '0',             
      --ACH4        => '0',             
      --ACH5        => '0',             
      --ACH6        => '0',             
      --ACH7        => '0',             
      --AOUT0       => open,             
      --AOUT1       => open,             
      ----PADs top edge
      --DDQ0        => DDQ(0),            
      --DDQ1        => DDQ(1),            
      --DDQ2        => DDQ(2),            
      --DDQ3        => DDQ(3),            
      --DDQ4        => DDQ(4),            
      --DDQ5        => DDQ(5),            
      --DDQ6        => DDQ(6),            
      --DDQ7        => DDQ(7),        
      --DCLK        => DCLK,              
      --DCS         => DCS,           
      --DRAS        => DRAS,          
      --DCAS        => DCAS,          
      --DWE         => DWE,           
      --DBA0        => DBA(0),            
      --DBA1        => DBA(1),    
      --DA0         => DA(0),         
      --DA1         => DA(1),         
      --DA2         => DA(2),         
      --DA3         => DA(3),         
      --DA4         => DA(4),         
      --DA5         => DA(5),         
      --DA6         => DA(6),         
      --DA7         => DA(7),         
      --DA8         => DA(8),         
      --DA9         => DA(9),             
      --DA10        => DA(10),            
      --DA11        => DA(11),            
      --DA12        => DA(12),            
      --DA13        => DA(13),            
      --DCKE0       => DCKE(0),        
      --DCKE1       => DCKE(1),        
      --DCKE2       => DCKE(2),        
      --DCKE3       => DCKE(3),        
      --MPORDIS     => MPORDIS,            
      --MXOSC_S0    =>'0',          
      --MXOSC_S1    =>'0',          
      --MXOSC_FEB   =>'0',          
      --MPLL_TSTO   => MPLL_TSTO);             
-----------------------------------------

  -----------------------------------------------------------------------------
  -- SDRAM
  -----------------------------------------------------------------------------
--  sdram: entity work.mt48lc4m16a2
--    generic map(
--    		-- CAS latency 3
--        tAC        => 5.4 ns,
--        tHZ        => 5.4 ns,
--        tOH        => 2.7 ns,
--        tMRD       => 2, 
--        tRAS       => 45.0 ns,
--        tRC        => 65.0 ns,
--        tRCD       => 20.0 ns,
--        tRP        => 20.0 ns,
--        tRRD       => 15.0 ns,
--        tWRa       => 7.5 ns, 
--        tWRp       => 15.0 ns,             
--        tAH        => 0.8 ns,
--        tAS        => 1.5 ns,
--        tCH        => 2.5 ns,
--        tCL        => 2.5 ns,
--        tCK        => 7.5 ns,
--        tDH        => 0.8 ns,
--        tDS        => 1.5 ns,
--        tCKH       => 0.8 ns,
--        tCKS       => 1.5 ns,
--        tCMH       => 0.8 ns,
--        tCMS       => 1.5 ns,                 
--    		-- CAS latency 2
----        tAC        => 6.0 ns,
----        tHZ        => 7.0 ns,
----        tOH        => 2.7 ns,
----        tMRD       => 2, 
----        tRAS       => 44.0 ns,
----        tRC        => 66.0 ns,
----        tRCD       => 20.0 ns,
----        tRP        => 20.0 ns,
----        tRRD       => 15.0 ns,
----        tWRa       => 7.5 ns, 
----        tWRp       => 15.0 ns,             
----        tAH        => 0.8 ns,
----        tAS        => 1.5 ns,
----        tCH        => 2.5 ns,
----        tCL        => 2.5 ns,
----        tCK        => 10.0 ns,
----        tDH        => 0.8 ns,
----        tDS        => 1.5 ns,
----        tCKH       => 0.8 ns,
----        tCKS       => 1.5 ns,
----        tCMH       => 0.8 ns,
----        tCMS       => 1.5 ns,                 
--        addr_bits  => 12,
--        data_bits  => 16,
--        col_bits   => 8)
--    port map(
--        Dq(15 downto 8) => DDQ,
--        Dq(7 downto 0)  => DDQ,
--        Addr            => DA(11 downto 0),             
--        Ba              => DBA,                         
--        Clk             => top_clk_d,                        
--        Cke             => DCKE(0),                     
--        Cs_n            => DCS,                         
--        Ras_n           => DRAS,                        
--        Cas_n           => DCAS,                        
--        We_n            => DWE,                         
--        Dqm             => PD(1 downto 0),              
--        Load            => '0',                         
--        Unload          => '0',                         
--        Row_start       => 0,                           
--        Row_end         => 0);                          

--  -----------------------------------------------------------------------------
--  -- I/O UNIT
--  -----------------------------------------------------------------------------
--  IO_unit: entity work.ioUnit
--    generic map(
--      test_io_addr   => x"CC",
--      mem_cs_addr    => x"66")
--    port map(
--      rst_n     => MRESET,
--      PA        => PA,          
--      PB        => PB,          
--      PC        => PC,          
--      PD        => PD,          
--      PE        => PE,          
--      PF        => PF,          
--      PG        => PG,          
--      PH        => PH,          
--      PI        => PI,          
--      PJ        => PJ,         
--      cs_n_in   => DCS,
--      cs_n_out  => cs_n
--      );
  
  -----------------------------------------------------------------------------
  -- STIMULI
  -----------------------------------------------------------------------------
  --stim: entity work.spboot_stim
  --  port map (
  --    MX1_CK    => MX1_CK,      
  --    MXOUT     => MXOUT,       
  --    MEXEC     => MEXEC,       
  --    MCKOUT0   => MCKOUT0,     
  --    MCKOUT1   => MCKOUT1,     
  --    MSDIN     => MSDIN,       
  --    MSDOUT    => MSDOUT,      
  --    MIRQOUT   => MIRQOUT,          
  --    MBYPASS   => MBYPASS,          
  --    MRESET    => MRESET,      
  --    MRSTOUT   => MRSTOUT,     
  --    MTEST     => MTEST,       
  --    MWAKE     => MWAKE,       
  --    MIRQ0     => MIRQ0,       
  --    MIRQ1     => MIRQ1,          
  --    MRXOUT    => MRXOUT,      
  --    PA        => PA,                  
  --    PB        => PB,                  
  --    XTAL1     => XTAL1,
  --    MPORDIS   => MPORDIS);          

--  rtl_gen: if rtl_model generate
--  ----------------------------------------------------------------------------
--  -- Mirror signals of dbus, ybus and mpga
--  ----------------------------------------------------------------------------
--    init_signal_spy("/gp2000_tb/top/clk_e", "/gp2000_tb/top_clk_e",1);
--    init_signal_spy("/gp2000_tb/top/core0/dbus", "/gp2000_tb/top_dbus",1);
--    init_signal_spy("/gp2000_tb/top/core0/ybus", "/gp2000_tb/top_ybus",1);
--    init_signal_spy("/gp2000_tb/top/core0/curr_mpga", "/gp2000_tb/top_mpga",1);
--
--  ----------------------------------------------------------------------------
--  -- TRACE FILE GENERATION
--  ----------------------------------------------------------------------------
--    trace_gen: entity work.tracer
--      generic map (
--        start_trace_addr => x"0800")      -- changes to desired address
--      port map(
--        clk_e  => top_clk_e,
--        dbus   => top_dbus,
--        ybus   => top_ybus,
--        mpga   => top_mpga 
--        );    
--  end generate rtl_gen;

--CJ
process 
begin
HCLK <= '1';
wait for 16ns;
HCLK <= '0';
wait for 16ns;
end process;
--
--process
--begin
--    wait for 60 ns;
--    MSDIN <= '1';
--
--		-- Wait for power-on reset to release
--    MTEST <= '1';							-- Test mode enabled, to shorten reset timeout
--    MRESET <= '0';
--	wait for 15 ns;
--	MRESET <= '1';
--	wait;
--end process;
end struct;
