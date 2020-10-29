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
        CS          :  in std_logic;
        D0          :  inout std_logic_vector(7 downto 0);
        D1          :  inout std_logic_vector(7 downto 0);
        D2          :  inout std_logic_vector(7 downto 0);
        D3          :  inout std_logic_vector(7 downto 0);
        D4          :  inout std_logic_vector(7 downto 0);
        D5          :  inout std_logic_vector(7 downto 0);
        D6          :  inout std_logic_vector(7 downto 0);
        D7          :  inout std_logic_vector(7 downto 0);
        D8          :  inout std_logic_vector(7 downto 0);
        D9          :  inout std_logic_vector(7 downto 0);
        D10         :  inout std_logic_vector(7 downto 0);
        D11         :  inout std_logic_vector(7 downto 0);
        D12         :  inout std_logic_vector(7 downto 0);
        D13         :  inout std_logic_vector(7 downto 0);
        D14         :  inout std_logic_vector(7 downto 0);
        D15         :  inout std_logic_vector(7 downto 0);
        
        DI0          :  inout std_logic_vector(7 downto 0);
        DI1          :  inout std_logic_vector(7 downto 0);
        DI2          :  inout std_logic_vector(7 downto 0);
        DI3          :  inout std_logic_vector(7 downto 0);
        DI4          :  inout std_logic_vector(7 downto 0);
        DI5          :  inout std_logic_vector(7 downto 0);
        DI6          :  inout std_logic_vector(7 downto 0);
        DI7          :  inout std_logic_vector(7 downto 0);
        DI8          :  inout std_logic_vector(7 downto 0);
        DI9          :  inout std_logic_vector(7 downto 0);
        DI10         :  inout std_logic_vector(7 downto 0);
        DI11         :  inout std_logic_vector(7 downto 0);
        DI12         :  inout std_logic_vector(7 downto 0);
        DI13         :  inout std_logic_vector(7 downto 0);
        DI14         :  inout std_logic_vector(7 downto 0);
        DI15         :  inout std_logic_vector(7 downto 0)


    );

end entity;

architecture struct of CMEM_32KX16 is
    type memunit is array (32767 downto 0) of std_logic_vector(127 downto 0);
    type memword is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal mem  : memunit;
    signal di_up   : memword;
    signal do_up   : memword;
    signal di_down : memword;
    signal do_down : memword;
    signal addr : std_logic_vector(14 downto 0); 
begin
    
    addr <= addr_c;
    di_up(0) <= D0;
    di_up(1) <= D1;
    di_up(2) <= D2;
    di_up(3) <= D3;
    di_up(4) <= D4;
    di_up(5) <= D5;
    di_up(6) <= D6;
    di_up(7) <= D7;
    di_up(8) <= D8;
    di_up(9) <= D9;
    di_up(10) <= D10;
    di_up(11) <= D11;
    di_up(12) <= D12;
    di_up(13) <= D13;
    di_up(14) <= D14;
    di_up(15) <= D15;

    di_down(0) <= DI0;
    di_down(1) <= DI1;
    di_down(2) <= DI2;
    di_down(3) <= DI3;
    di_down(4) <= DI4;
    di_down(5) <= DI5;
    di_down(6) <= DI6;
    di_down(7) <= DI7;
    di_down(8) <= DI8;
    di_down(9) <= DI9;
    di_down(10) <= DI10;
    di_down(11) <= DI11;
    di_down(12) <= DI12;
    di_down(13) <= DI13;
    di_down(14) <= DI14;
    di_down(15) <= DI15;
    
    
    process(CK)
    begin
        if rising_edge(CK) then
            if CS = '0' then
                if WR = '1' then
                    for i in 0 to 15 loop
                        mem(to_integer(unsigned(addr_c)))(8*1+7 downto 8*i) <= di_up(i);
                    end loop;
                    for i in 0 to 15 loop
                        do_up(i)<= mem(to_integer(unsigned(addr_c)))(8*i+7 downto 8*i);
                    end loop;
                end if;
            elsif CS = '1' then
                if WR = '1' then
                    for i in 0 to 15 loop
                        mem(to_integer(unsigned(addr_c)))(8*1+7 downto 8*i) <= di_down(i);
                    end loop;
                    for i in 0 to 15 loop
                        do_down(i)<= mem(to_integer(unsigned(addr_c)))(8*i+7 downto 8*i);
                    end loop;
                end if;
            end if;
        end if;
    end process;

        D0 <= do_up(0) when RD = '1' else (others => 'Z');
        D1 <= do_up(1) when RD = '1' else (others => 'Z');
        D2 <= do_up(2) when RD = '1' else (others => 'Z');
        D3 <= do_up(3) when RD = '1' else (others => 'Z');
        D4 <= do_up(4) when RD = '1' else (others => 'Z');
        D5 <= do_up(5) when RD = '1' else (others => 'Z');
        D6 <= do_up(6) when RD = '1' else (others => 'Z');
        D7 <= do_up(7) when RD = '1' else (others => 'Z');
        D8 <= do_up(8) when RD = '1' else (others => 'Z');
        D9 <= do_up(9) when RD = '1' else (others => 'Z');
        D10 <= do_up(10) when RD = '1' else (others => 'Z');
        D11 <= do_up(11) when RD = '1' else (others => 'Z');
        D12 <= do_up(12) when RD = '1' else (others => 'Z');
        D13 <= do_up(13) when RD = '1' else (others => 'Z');
        D14 <= do_up(14) when RD = '1' else (others => 'Z');
        D15 <= do_up(15) when RD = '1' else (others => 'Z');


        DI0 <= do_down(0) when RD = '1' else (others => 'Z');
        DI1 <= do_down(1) when RD = '1' else (others => 'Z');
        DI2 <= do_down(2) when RD = '1' else (others => 'Z');
        DI3 <= do_down(3) when RD = '1' else (others => 'Z');
        DI4 <= do_down(4) when RD = '1' else (others => 'Z');
        DI5 <= do_down(5) when RD = '1' else (others => 'Z');
        DI6 <= do_down(6) when RD = '1' else (others => 'Z');
        DI7 <= do_down(7) when RD = '1' else (others => 'Z');
        DI8 <= do_down(8) when RD = '1' else (others => 'Z');
        DI9 <= do_down(9) when RD = '1' else (others => 'Z');
        DI10 <= do_down(10) when RD = '1' else (others => 'Z');
        DI11 <= do_down(11) when RD = '1' else (others => 'Z');
        DI12 <= do_down(12) when RD = '1' else (others => 'Z');
        DI13 <= do_down(13) when RD = '1' else (others => 'Z');
        DI14 <= do_down(14) when RD = '1' else (others => 'Z');
        DI15 <= do_down(15) when RD = '1' else (others => 'Z');
end architecture struct;