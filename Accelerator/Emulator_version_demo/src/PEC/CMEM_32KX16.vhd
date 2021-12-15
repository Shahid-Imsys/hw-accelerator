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
-- Title      : CMEM_32KX16
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : CMEM_32KX16.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Memory blocks of cluster memory
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2020-9-9  		     1.0	     CJ			Created
-- 2021-6-30             2.0         CJ         Remove dir sel signal
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CMEM_32KX16 is 
    port(
        addr_c      :  in std_logic_vector(14 downto 0);
        CK          :  in std_logic;
        WR          :  in std_logic;
        RD          :  in std_logic;
        DI0          :  in std_logic_vector(7 downto 0);
        DI1          :  in std_logic_vector(7 downto 0);
        DI2          :  in std_logic_vector(7 downto 0);
        DI3          :  in std_logic_vector(7 downto 0);
        DI4          :  in std_logic_vector(7 downto 0);
        DI5          :  in std_logic_vector(7 downto 0);
        DI6          :  in std_logic_vector(7 downto 0);
        DI7          :  in std_logic_vector(7 downto 0);
        DI8          :  in std_logic_vector(7 downto 0);
        DI9          :  in std_logic_vector(7 downto 0);
        DI10         :  in std_logic_vector(7 downto 0);
        DI11         :  in std_logic_vector(7 downto 0);
        DI12         :  in std_logic_vector(7 downto 0);
        DI13         :  in std_logic_vector(7 downto 0);
        DI14         :  in std_logic_vector(7 downto 0);
        DI15         :  in std_logic_vector(7 downto 0);
        
        DO0          :  out std_logic_vector(7 downto 0);
        DO1          :  out std_logic_vector(7 downto 0);
        DO2          :  out std_logic_vector(7 downto 0);
        DO3          :  out std_logic_vector(7 downto 0);
        DO4          :  out std_logic_vector(7 downto 0);
        DO5          :  out std_logic_vector(7 downto 0);
        DO6          :  out std_logic_vector(7 downto 0);
        DO7          :  out std_logic_vector(7 downto 0);
        DO8          :  out std_logic_vector(7 downto 0);
        DO9          :  out std_logic_vector(7 downto 0);
        DO10         :  out std_logic_vector(7 downto 0);
        DO11         :  out std_logic_vector(7 downto 0);
        DO12         :  out std_logic_vector(7 downto 0);
        DO13         :  out std_logic_vector(7 downto 0);
        DO14         :  out std_logic_vector(7 downto 0);
        DO15         :  out std_logic_vector(7 downto 0)


    );

end entity;

architecture struct of CMEM_32KX16 is
    type memunit is array (32767 downto 0) of std_logic_vector(127 downto 0);
    type memword is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal mem  : memunit;
    signal di   : memword;
    signal do   : memword;
    signal addr : std_logic_vector(14 downto 0); 
begin
    
    addr <= addr_c;
    di(0) <= DI0;
    di(1) <= DI1;
    di(2) <= DI2;
    di(3) <= DI3;
    di(4) <= DI4;
    di(5) <= DI5;
    di(6) <= DI6;
    di(7) <= DI7;
    di(8) <= DI8;
    di(9) <= DI9;
    di(10) <= DI10;
    di(11) <= DI11;
    di(12) <= DI12;
    di(13) <= DI13;
    di(14) <= DI14;
    di(15) <= DI15;

    
    
    process(CK)
    begin
        if rising_edge(CK) then
            if WR = '1' then
                for i in 0 to 15 loop
                    mem(to_integer(unsigned(addr_c)))(8*i+7 downto 8*i) <= di(i);
                end loop;
            end if;
            for i in 0 to 15 loop
                do(i)<= mem(to_integer(unsigned(addr_c)))(8*i+7 downto 8*i);
            end loop;
        end if;
    end process;

        DO0 <= do(0);-- when RD = '1' else (others => 'Z');
        DO1 <= do(1);-- when RD = '1' else (others => 'Z');
        DO2 <= do(2);-- when RD = '1' else (others => 'Z');
        DO3 <= do(3);-- when RD = '1' else (others => 'Z');
        DO4 <= do(4);-- when RD = '1' else (others => 'Z');
        DO5 <= do(5);-- when RD = '1' else (others => 'Z');
        DO6 <= do(6);-- when RD = '1' else (others => 'Z');
        DO7 <= do(7);-- when RD = '1' else (others => 'Z');
        DO8 <= do(8);-- when RD = '1' else (others => 'Z');
        DO9 <= do(9);-- when RD = '1' else (others => 'Z');
        DO10 <= do(10);-- when RD = '1' else (others => 'Z');
        DO11 <= do(11);-- when RD = '1' else (others => 'Z');
        DO12 <= do(12);-- when RD = '1' else (others => 'Z');
        DO13 <= do(13);-- when RD = '1' else (others => 'Z');
        DO14 <= do(14);-- when RD = '1' else (others => 'Z');
        DO15 <= do(15);-- when RD = '1' else (others => 'Z');


end architecture struct;