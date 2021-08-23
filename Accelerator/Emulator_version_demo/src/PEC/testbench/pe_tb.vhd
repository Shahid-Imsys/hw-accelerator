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

entity pe_tb is
--  generic (
--    rtl_model : boolean := true);
end pe_tb;

architecture struct of pe_tb is
    component p_top
        port (
            --Data interface --Added by CJ
            C1_REQ    : out std_logic;
            C2_REQ    : out std_logic;
            C1_ACK    : in std_logic;
            C2_ACK    : in std_logic;
            C1_REQ_D  : out std_logic_vector(31 downto 0);
            C2_REQ_D  : out std_logic_vector(31 downto 0);
            C1_IN_D   : in std_logic_vector(127 downto 0);
            C2_IN_D   : in std_logic_vector(127 downto 0);
            C1_DDI_VLD : in std_logic;
            C2_DDI_VLD : in std_logic;
            EXE        : in std_logic;
        
            -- clocks and control signals
            HCLK       : in    std_logic;                  -- clk input, use this or an internally generated clock for CPU core
            EVEN_C     : in    std_logic;                  -- even pulses of HCLK. Used to generate clk_e_pos and clk_e_neg.
            MRESET     : in    std_logic;                  -- system reset               low active
            MIRQOUT    : out   std_logic;                  -- interrupt request output    
            MCKOUT0    : out   std_logic;                  -- for trace adapter
            MCKOUT1    : out   std_logic;                  -- programable clock out
            MTEST      : in    std_logic;                  --                            high active                 
            MBYPASS    : in    std_logic;
            MIRQ0      : in    std_logic;                  --                            low active
            MIRQ1      : in    std_logic;                  --                            low active
            -- SW debug                                                               
            MSDIN      : in    std_logic;                  -- serial data in (debug)     
            MSDOUT     : out   std_logic;                   -- serial data out
            MLP_PWR_OK : in    std_logic;
            MWAKEUP_LP : in    std_logic    
          );
        end component;
        component spboot_stim
            port(
                MX1_CK   : inout std_logic;
                CLK_P    : out   std_logic;
                EVEN_C   : out   std_logic; 
                EXE      : out   std_logic;    
                MXOUT    : in    std_logic;   
                MEXEC    : in    std_logic;   
                MCKOUT0  : in    std_logic;   
                MCKOUT1  : in    std_logic;   
                MSDIN    : out   std_logic;   
                MSDOUT   : in    std_logic;   
                MIRQOUT  : in    std_logic;   
                MBYPASS  : out   std_logic;   
                MRESET   : out   std_logic;   
                MRSTOUT  : in    std_logic;   
                MTEST    : out   std_logic;   
                MWAKE    : out   std_logic;   
                MIRQ0    : out   std_logic;   
                MIRQ1    : out   std_logic;   
                MRXOUT   : in    std_logic;
                PA       : inout std_logic_vector(7 downto 0);        
                PB       : in    std_logic_vector(7 downto 0);        
                XTAL1    : inout std_logic;   
                MPORDIS  : out   std_logic   
                );
            end component;
            component init_mpgm
            port(
            HCLK : out std_logic;
            EVEN_C : out std_logic;
            EXE : out std_logic;
            MTEST      : out std_logic;
            MRESET     : out std_logic;
            MCKOUT0    : in std_logic;
            MWAKEUP_LP : out std_logic;
            MLP_PWR_OK : out std_logic;
            c1_in_data : out std_logic_vector(127 downto 0);
            c1_ddi_vld : out std_logic
            );
            end component;
  signal hclk_i         : std_logic;
  signal even_c_i       : std_logic;
  signal mx1_ck_i       : std_logic;                      
  signal mxout_i        : std_logic;                      
  signal mexec_i        : std_logic;                      
  signal mckout0_i      : std_logic;                      
  signal mckout1_i      : std_logic;                      
  signal msdin_i        : std_logic;                      
  signal msdout_i       : std_logic;                      
  signal mirqout_i      : std_logic;                      
  signal mbypass_i      : std_logic;                      
  signal mreset_i       : std_logic;                      
  signal MRSTOUT_i      : std_logic;                      
  signal MTEST_i        : std_logic;                      
  signal MWAKE_i        : std_logic;                      
  signal MIRQ0_i        : std_logic;                      
  signal MIRQ1_i        : std_logic;                      
  signal MRXOUT       : std_logic; 
  signal exe_i        : std_logic;                     
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
  signal mlp_pwr_ok_i : std_logic;
  signal mwakeup_lp_i : std_logic;
  signal c1_indata    : std_logic_vector(127 downto 0);
  signal c1_vld       : std_logic;
  

--  signal cs_n         : std_logic_vector(3 downto 0);
  
--  -- mirror signals of 'clk_e', 'dbus', 'ybus' and 'curr_mpga'.
--  signal top_clk_e     : std_logic;
--  signal top_dbus      : std_logic_vector(7 downto 0);
--  signal top_ybus      : std_logic_vector(7 downto 0);
--  signal top_mpga      : std_logic_vector(13 downto 0);
 
  -- mirror signals of 'clk_d', to get no-skew clock for DRAM.
  signal top_clk_d     : std_logic;


 
begin  -- struct
--process
--begin
  --wait for 60 ns;
  --MSDIN <= '1';
  --MTEST_i <= '1';	
  --MRESET_i <= '1';
  --wait until rising_edge(MCKOUT0_i);
  --MTEST_i <= '0';
  --wait;
  --wait until rising_edge(MCKOUT0);
  --MTEST <= '0';	
 --end process;

  top0: p_top
    port map (
        C1_REQ     => open,
        C2_REQ     => open,
        C1_ACK     => '0',
        C2_ACK     => '0',
        C1_REQ_D   => open,
        C2_REQ_D   => open,
        C1_IN_D    => c1_indata,
        C2_IN_D    => (others=>'0'),
        C1_DDI_VLD => c1_vld,
        C2_DDI_VLD => '0',
        EXE        => exe_i,
        HCLK       => hclk_i,
        EVEN_C     => even_c_i,
        MRESET     => mreset_i,
        MIRQOUT    => mirqout_i,
        MCKOUT0    => mckout0_i,
        MCKOUT1    => mckout1_i,
        MTEST      => mtest_i,
        MBYPASS    => mbypass_i,
        MIRQ0      => mirq0_i,
        MIRQ1      => mirq1_i,    
        MSDIN      => msdin_i,
        MSDOUT     => msdout_i,
        MLP_PWR_OK => mlp_pwr_ok_i,
        MWAKEUP_LP => mwakeup_lp_i);
        
    --simu1: spboot_stim
    --port map(
    --    MX1_CK     => MX1_CK_i,
    --    CLK_P       => hclk_i,
    --    EVEC_C     => even_c_i,
    --    EXE        => exe_i,         
    --    MXOUT      => mxout_i,          
    --    MEXEC      => MEXEC_i,          
    --    MCKOUT0    => MCKOUT0_i,        
    --    MCKOUT1    => MCKOUT1_i,        
    --    MSDIN      => MSDIN_i,          
    --    MSDOUT     => MSDOUT_i,         
    --    MIRQOUT    => MIRQOUT_i,        
    --    MBYPASS    => MBYPASS_i,        
    --    MRESET     => MRESET_i,         
    --    MRSTOUT    => MRSTOUT_i,        
    --    MTEST      => MTEST_i,          
    --    MWAKE      => MWAKE_i,          
    --    MIRQ0      => MIRQ0_i,          
    --    MIRQ1      => MIRQ1_i,          
    --    MRXOUT     => MRXOUT,         
    --    PA         => PA,             
    --    PB         => PB,             
    --    XTAL1      => XTAL1,          
    --    MPORDIS    => MPORDIS       
    --);
    simu2: init_mpgm
    port map(
        HCLK => hclk_i,
        EVEN_C => even_c_i,
        EXE  => exe_i,
        MTEST => mtest_i,
        MRESET => mreset_i,
        MCKOUT0 => mckout0_i,
        MLP_PWR_OK => mlp_pwr_ok_i,
        MWAKEUP_LP => mwakeup_lp_i,
        c1_in_data => c1_indata,
        c1_ddi_vld => c1_vld
    );
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
--process 
--begin
--HCLK <= '1';
--wait for 16ns;
--HCLK <= '0';
--wait for 16ns;
--end process;
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
