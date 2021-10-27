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
-- Title      : Cluster Memory Data Register
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : CMDR.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Data from memory (DFM) and data to memory (DTM) logic for 
--              connection with cluster memory
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2021-10-26           1.0         CJ      Created    
--     
--     
--     
--     
--     
--     
--     
--     
--     
--    
--     
--     
--    
--     
--     
--     
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmdr is
    port(
        --Clock and reset functions
        CLK_P     : in std_logic;
        RST_EN    : in std_logic;
        CLK_E_NEG : in std_logic;   
        --Microprogram control
        PL        : in std_logic_vector(127 downto 0);
        --Cluster data interface
        DATA_VLD  : in std_logic;
        DIN       : in std_logic_vector(127 downto 0);
        DOUT      : out std_logic_vector(32 downto 0);
        --Core interface
        YBUS      : in std_logic_vector(7 downto 0);
        LD_MPGM   : in std_logic;
        VE_DIN    : out std_logic_vector(63 downto 0); --to vector engine
        DBUS_DATA : out std_logic_vector(7 downto 0);  --to DSL
        MPGMM_IN  : out std_logic_vector(127 downto 0); --to microprogram memory
        VE_DTMO   : in std_logic_vector(127 downto 0)  --output DTM data from VE;
        
    );
end; 

architecture rtl of cmdr is
    --control fields
    signal pl_dbus_s     : std_logic_vector(4 downto 0);
    signal pl_dfm_byte    : std_logic_vector(3 downto 0);

    signal ve_data_int : std_logic_vector(63 downto 0);
    signal mp_data_int : std_logic_vector(127 downto 0);
    signal dbus_reg    : std_logic_vector(127 downto 0);
    signal output_int  : std_logic_vector(32 downto 0);
    signal dbus_int    : std_logic_vector(7 downto 0);

begin
--*******************************************************************     
-- Cluster DFM
--*******************************************************************
    pl_dfm_byte  <= PL(112 downto 109);
    pl_dbus_s    <= pl(108)&pl(50)&pl(22)&pl(14)&pl(44);
    process(clk_p)
        variable dbus_trig: boolean;
    begin
        if rising_edge(clk_p) then
            if RST_EN = '0' then
                dbus_trig := true;
                ve_data_int <= (others => '0');
                mp_data_int <= (others => '0');
                dbus_reg <= (others => '0');
            elsif DATA_VLD = '1' then 
                mp_data_int <= DIN;           --input to microprogram data
                if CLK_E_NEG = '0' then
                    ve_data_int <= DIN(63 downto 0); --input lower half to vector engine at falling edge of clk_e
                elsif CLK_E_NEG = '1' then
                    ve_data_int <= DIN(127 downto 64); --input upper half to vector engine at rising edge of clk_e
                end if;

                if pl_dbus_s = "10001" and dbus_trig then --load dbus register once when d source is cdfm (maximum 16 clk_e cycles before send next read request to cluster controller!!)
                    dbus_trig := false;
                    dbus_reg <= DIN;
                elsif pl_dbus_s /= "10001" then
                    dbus_trig := true;
                end if;
            end if;
        end if;
    end process;

    dbus_int <= dbus_reg(8*(to_integer(unsigned(pl_dfm_byte)))+7 downto 8*(to_integer(unsigned(pl_dfm_byte))));
    VE_DIN <= ve_data_int;
    MPGMM_IN <= mp_data_int;
    DBUS_DATA <= dbus_int;

--*******************************************************************     
-- Cluster DTM
--*******************************************************************
    --Cluster DTM has two input sources. One is ybus, which is controlled by the microcode directly and the bandwidth is 8 bits per clock e cycle 