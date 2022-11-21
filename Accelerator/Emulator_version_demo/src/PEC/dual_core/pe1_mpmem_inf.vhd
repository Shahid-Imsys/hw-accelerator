---------------------------------------------------
--DESIGNED BY MA NING
--7/14/2015 9:13:21 AM   MN    change RAM0 to ROM
--9/22/2016 1:47:07 PM   MN    address of RAM0 should be the address of ROM since the RAM0 has been changed to a ROM, and the address should be address from ROM
--                             otherwise there will be problems when trying to write the mp codes into RAM1.(RAM address will be obtained from yreg and dbus)
--2021-3-25              CJ    Remove ROM0, ROM1, RAM1 and patch memory. Make RAM0 32*128.
---------------------------------------------------
LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.pe1_gp_pkg.all;

ENTITY pe1_mpmem_inf IS
    PORT (
        c1_mpram_a     : in std_logic_vector(7 downto 0);
        c1_mpram_d     : in std_logic_vector(127 downto 0);
        c1_mpram_ce    : in std_logic_vector(1 downto 0); -- Chip enable(active high)
        c1_mpram_oe    : in std_logic_vector(1 downto 0); -- Output enable(active high)
        c1_mpram_we_n  : in std_logic;                    -- Write enable(active low)
        c1_pmem_q      : out std_logic_vector(1  downto 0);
        c1_mp_q        : out std_logic_vector(127 downto 0);
        -- MPRAM signals
        c2_mpram_a     : in std_logic_vector(7 downto 0);  -- Address      --Modified by CJ
        c2_mpram_d     : in std_logic_vector(127 downto 0);-- Data to memory --CJ
        c2_mpram_ce    : in std_logic_vector(1 downto 0); -- Chip enable(active high)
        c2_mpram_oe    : in std_logic_vector(1 downto 0); -- Output enable(active high)
        c2_mpram_we_n  : in std_logic;                    -- Write enable(active low)
        c2_pmem_q      : out std_logic_vector(1  downto 0);
        c2_mp_q        : out std_logic_vector(127 downto 0);
        PM_DO      : in  std_logic_vector (1 downto 0);
        --RAM0      becomes ROM in low power version
        RAM0_DO     : in  std_logic_vector (127 downto 0); --Modified by CJ
        RAM0_DI     : out std_logic_vector (127 downto 0); --Modified by CJ
        RAM0_A      : out std_logic_vector (7 downto 0);
        RAM0_WEB    : out std_logic;
        RAM0_OE     : out std_logic;
        RAM0_CS     : out std_logic
        );
END pe1_mpmem_inf;

ARCHITECTURE behav OF pe1_mpmem_inf IS

    signal c1_mp_q_int        : std_logic_vector(127 downto 0);
    signal c2_mp_q_int        : std_logic_vector(127 downto 0);
BEGIN
-----------------------RAM0----------------------
    RAM0_DI <= c1_mpram_d WHEN c1_mpram_ce(0) = '1' ELSE
               c2_mpram_d WHEN c2_mpram_ce(0) = '1' ELSE
               c1_mpram_d;
    RAM0_A <=  c1_mpram_a WHEN c1_mpram_ce(0) = '1' ELSE
               c2_mpram_a WHEN c2_mpram_ce(0) = '1' ELSE
               c1_mpram_a;
    RAM0_WEB <= c1_mpram_we_n;
    RAM0_OE <= c1_mpram_oe(0) OR c2_mpram_oe(0);
    RAM0_CS <= c1_mpram_ce(0) OR c2_mpram_ce(0);
-----------------------------------------------------------------------------------------------------------------------------------------
    c1_mp_q_int <=  RAM0_DO;
    c2_mp_q_int <=  RAM0_DO;
    c1_mp_q <= c1_mp_q_int;
    c2_mp_q <= c2_mp_q_int;
    c1_pmem_q <= PM_DO;
    c2_pmem_q <= PM_DO;
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

END behav;
