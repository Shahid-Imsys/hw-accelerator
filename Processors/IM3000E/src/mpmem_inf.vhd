---------------------------------------------------
--DESIGNED BY MA NING
--7/14/2015 9:13:21 AM   MN    change RAM0 to ROM
--9/22/2016 1:47:07 PM   MN    address of RAM0 should be the address of ROM since the RAM0 has been changed to a ROM, and the address should be address from ROM
--                             otherwise there will be problems when trying to write the mp codes into RAM1.(RAM address will be obtained from yreg and dbus)
---------------------------------------------------
LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.gp_pkg.all;

ENTITY mpmem_inf IS 
    PORT (
        --clk_p         : in std_logic;
        --rst_cn            : in std_logic;
        --clk_e_pos     : in std_logic;
        --clk_ea_pos        : in std_logic;
        -- MPROM signals
        c1_mprom_a     : in std_logic_vector(13 downto 0);-- Address  
        c1_mprom_ce    : in std_logic_vector(1 downto 0); -- Chip enable(active high) 
        c1_mprom_oe    : in std_logic_vector(1 downto 0); -- Output enable(active high)
        -- MPRAM signals
        c1_mpram_a     : in std_logic_vector(13 downto 0);-- Address  
        c1_mpram_d     : in std_logic_vector(79 downto 0);-- Data to memory
        c1_mpram_ce    : in std_logic_vector(1 downto 0); -- Chip enable(active high)
        c1_mpram_oe    : in std_logic_vector(1 downto 0); -- Output enable(active high)
        c1_mpram_we_n  : in std_logic;                    -- Write enable(active low)
        -- PMEM signals (Patch memory)
        c1_pmem_a      : in std_logic_vector(10 downto 0);
        c1_pmem_d      : in std_logic_vector(1  downto 0);
        c1_pmem_q      : out std_logic_vector(1  downto 0);
        c1_pmem_ce_n   : in std_logic;
        c1_pmem_we_n   : in std_logic;
        
        c1_mp_q        : out std_logic_vector(79 downto 0);
        -- MPROM signals
        c2_mprom_a     : in std_logic_vector(13 downto 0);-- Address  
        c2_mprom_ce    : in std_logic_vector(1 downto 0); -- Chip enable(active high) 
        c2_mprom_oe    : in std_logic_vector(1 downto 0); --Output enable(active high)
        -- MPRAM signals
        c2_mpram_a     : in std_logic_vector(13 downto 0);-- Address  
        c2_mpram_d     : in std_logic_vector(79 downto 0);-- Data to memory
        c2_mpram_ce    : in std_logic_vector(1 downto 0); -- Chip enable(active high)
        c2_mpram_oe    : in std_logic_vector(1 downto 0); -- Output enable(active high)
        c2_mpram_we_n  : in std_logic;                    -- Write enable(active low)
        -- PMEM signals (Patch memory)
        c2_pmem_a      : in std_logic_vector(10 downto 0);
        c2_pmem_d      : in std_logic_vector(1  downto 0);
        c2_pmem_q      : out std_logic_vector(1  downto 0);
        c2_pmem_ce_n   : in std_logic;
        c2_pmem_we_n   : in std_logic;
        
        c2_mp_q        : out std_logic_vector(79 downto 0);
        --memory interface
        --ROM0
        ROM0_DO     : in  std_logic_vector (79 downto 0); 
        ROM0_A      : out std_logic_vector (13 downto 0);
        ROM0_CS     : out std_logic;
        ROM0_OE     : out std_logic; 
        --ROM1
        ROM1_DO     : in  std_logic_vector (79 downto 0); 
        ROM1_A      : out std_logic_vector (13 downto 0);
        ROM1_CS     : out std_logic;
        ROM1_OE     : out std_logic;
        --patch memory
        PM_DO      : in  std_logic_vector (1 downto 0);
        PM_DI      : out std_logic_vector (1 downto 0);
        PM_A       : out std_logic_vector (10 downto 0);
        PM_WEB     : out std_logic;
        PM_CSB     : out std_logic;
--        PM_CS      : out std_logic;
        --RAM0      becomes ROM in low power version
        RAM0_DO     : in  std_logic_vector (79 downto 0);
        RAM0_DI     : out std_logic_vector (79 downto 0);
        RAM0_A      : out std_logic_vector (13 downto 0);
        RAM0_WEB    : out std_logic;
--        RAM0_CSB    : out std_logic;
        RAM0_OE     : out std_logic;
        RAM0_CS     : out std_logic;
        --RAM1             --                
        RAM1_DO     : in  std_logic_vector (79 downto 0);
        RAM1_DI     : out std_logic_vector (79 downto 0);
        RAM1_A      : out std_logic_vector (13 downto 0);
        RAM1_WEB    : out std_logic;
--        RAM1_CSB    : out std_logic
        RAM1_CS    : out std_logic
        );
END mpmem_inf;

ARCHITECTURE behav OF mpmem_inf IS  

    signal c1_mp_q_int        : std_logic_vector(79 downto 0);
    signal c2_mp_q_int        : std_logic_vector(79 downto 0);
BEGIN
--------------------mp rom0----------------------
    ROM0_A <= c1_mprom_a WHEN c1_mprom_ce(0) = '1' ELSE
              c2_mprom_a WHEN c2_mprom_ce(0) = '1' ELSE
              c1_mprom_a;
    ROM0_CS <= c1_mprom_ce(0) OR c2_mprom_ce(0);
    ROM0_OE <= c1_mprom_oe(0) OR c2_mprom_oe(0);  
--------------------mp rom1----------------------
    ROM1_A <= c1_mprom_a WHEN c1_mprom_ce(1) = '1' ELSE
              c2_mprom_a WHEN c2_mprom_ce(1) = '1' ELSE
              c1_mprom_a;
    ROM1_CS <= c1_mprom_ce(1) OR c2_mprom_ce(1);
    ROM1_OE <= c1_mprom_oe(1) OR c2_mprom_oe(1);   
---------------------PATCH MEM------------------ 
    PM_DI <= c1_pmem_d WHEN c1_pmem_ce_n = '0' ELSE
             c2_pmem_d WHEN c2_pmem_ce_n = '0' ELSE
             c1_pmem_d;
    PM_A <=  c1_pmem_a WHEN c1_pmem_ce_n = '0' ELSE
             c2_pmem_a WHEN c2_pmem_ce_n = '0' ELSE
             c1_pmem_a;
    PM_WEB <= c1_pmem_we_n AND c2_pmem_we_n;
    PM_CSB <= c1_pmem_ce_n AND c2_pmem_ce_n;
--    PM_CS <= NOT (c1_pmem_ce_n AND c2_pmem_ce_n);
-----------------------RAM0----------------------  
    RAM0_DI <= c1_mpram_d WHEN c1_mpram_ce(0) = '1' ELSE
               c2_mpram_d WHEN c2_mpram_ce(0) = '1' ELSE
               c1_mpram_d;
    RAM0_A <=  c1_mpram_a WHEN c1_mpram_ce(0) = '1' ELSE
               c2_mpram_a WHEN c2_mpram_ce(0) = '1' ELSE
               c1_mpram_a;                                                         
    RAM0_WEB <= c1_mpram_we_n AND c2_mpram_we_n;
--    RAM0_CSB <= NOT (c1_mpram_ce(0) OR c2_mpram_ce(0));
    RAM0_OE <= c1_mpram_oe(0) OR c2_mpram_oe(0);
    RAM0_CS <= c1_mpram_ce(0) OR c2_mpram_ce(0);
-------------------------RAM1----------------------       -- 
    RAM1_DI <= c1_mpram_d WHEN c1_mpram_ce(1) = '1' ELSE
               c2_mpram_d WHEN c2_mpram_ce(1) = '1' ELSE
               c1_mpram_d;
    RAM1_A <=  c1_mpram_a WHEN c1_mpram_ce(1) = '1' ELSE
               c2_mpram_a WHEN c2_mpram_ce(1) = '1' ELSE
               c1_mpram_a;                                                         
    RAM1_WEB <= c1_mpram_we_n AND c2_mpram_we_n;
--    RAM1_CSB <= NOT (c1_mpram_ce(1) OR c2_mpram_ce(1));
    RAM1_CS <= c1_mpram_ce(1) OR c2_mpram_ce(1);
----------------------------------------------------------------------------------------------------------------------------------------- 
    c1_mp_q_int <=  ROM0_DO WHEN c1_mprom_oe(0) = '1' ELSE               
                    ROM1_DO WHEN c1_mprom_oe(1) = '1' ELSE
                    RAM0_DO WHEN c1_mpram_oe(0) = '1' ELSE
                    RAM1_DO WHEN c1_mpram_oe(1) = '1' ELSE  -- 
                    ROM0_DO;
    c2_mp_q_int <=  ROM0_DO WHEN c2_mprom_oe(0) = '1' ELSE               
                    ROM1_DO WHEN c2_mprom_oe(1) = '1' ELSE
                    RAM0_DO WHEN c2_mpram_oe(0) = '1' ELSE
                    RAM1_DO WHEN c2_mpram_oe(1) = '1' ELSE   -- 
                    ROM0_DO;
    c1_mp_q <= c1_mp_q_int;
    c2_mp_q <= c2_mp_q_int;

    -- process (clk_p)
    -- begin
        -- if (falling_edge(clk_p)) then
            -- if rst_cn = '0' then
                -- c1_mp_q <= (others => '0');
            -- elsif clk_e_pos = '0' then
                -- c1_mp_q <= c1_mp_q_int;
            -- end if;
        -- end if;
    -- end process;

    -- process (clk_p)
    -- begin
        -- if (falling_edge(clk_p)) then
            -- if rst_cn = '0' then
                -- c2_mp_q <= (others => '0');
            -- elsif clk_ea_pos = '0' then
                -- c2_mp_q <= c2_mp_q_int;
            -- end if;
        -- end if;
    -- end process; 
    
    c1_pmem_q <= PM_DO;
    c2_pmem_q <= PM_DO;
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
    
END behav;
