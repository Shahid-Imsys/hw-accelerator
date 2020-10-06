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
        D15         :  inout std_logic_vector(7 downto 0)       
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
    di(0) <= D0;
    di(1) <= D1;
    di(2) <= D2;
    di(3) <= D3;
    di(4) <= D4;
    di(5) <= D5;
    di(6) <= D6;
    di(7) <= D7;
    di(8) <= D8;
    di(9) <= D9;
    di(10) <= D10;
    di(11) <= D11;
    di(12) <= D12;
    di(13) <= D13;
    di(14) <= D14;
    di(15) <= D15;
    
    
    process(CK)
    begin
        if rising_edge(CK) then
            if WR = '1' then
                mem(to_integer(unsigned(addr_c))) <= di(15)&di(14)&di(13)&di(12)&di(11)&di(10)&di(9)&di(8)&di(7)&di(6)&di(5)&di(4)&di(3)&di(2)&di(1)&di(0);
            end if;
            for i in 0 to 15 loop
                do(i)<= mem(to_integer(unsigned(addr_c)))(8*i+7 downto 8*i);
            end loop;
        end if;
    end process;

        D0 <= do(0) when RD = '1' else (others => 'Z');
        D1 <= do(1) when RD = '1' else (others => 'Z');
        D2 <= do(2) when RD = '1' else (others => 'Z');
        D3 <= do(3) when RD = '1' else (others => 'Z');
        D4 <= do(4) when RD = '1' else (others => 'Z');
        D5 <= do(5) when RD = '1' else (others => 'Z');
        D6 <= do(6) when RD = '1' else (others => 'Z');
        D7 <= do(7) when RD = '1' else (others => 'Z');
        D8 <= do(8) when RD = '1' else (others => 'Z');
        D9 <= do(9) when RD = '1' else (others => 'Z');
        D10 <= do(10) when RD = '1' else (others => 'Z');
        D11 <= do(11) when RD = '1' else (others => 'Z');
        D12 <= do(12) when RD = '1' else (others => 'Z');
        D13 <= do(13) when RD = '1' else (others => 'Z');
        D14 <= do(14) when RD = '1' else (others => 'Z');
        D15 <= do(15) when RD = '1' else (others => 'Z');

end architecture struct;