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
-- Title      : FIFO_0
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : fifo_0.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Ringed buffer used as DTM FIFO
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2022-5-9  		     1.0	     CJ			Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fifo_0 is
    generic(
        DATA_WIDTH : integer := 32;
        DATA_DEPTH : integer := 8;
        PROG_FULL_TRESHOLD : integer :=5
    );
    port(
        clk     : in std_logic;
        srst    : in std_logic;
        rd_en   : in std_logic;
        wr_en   : in std_logic;
        full    : out std_logic;
        empty   : out std_logic;
        prog_full : out std_logic;
        din       : in std_logic_vector(31 downto 0);
        dout      : out std_logic_vector(31 downto 0);
        counter   : out integer range DATA_DEPTH-1 downto 0
    );
end entity;

architecture behavioral of fifo_0 is
    type ram_type is array (DATA_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_type;

    subtype index_type is integer range ram_type'range;
    signal head :index_type;
    signal tail :index_type;

    signal empty_i : std_logic;
    signal full_i  : std_logic;
    signal prog_full_i : std_logic;
    signal counter_i : integer range DATA_DEPTH-1 downto 0;

    procedure increase (signal index : inout index_type) is
    begin
        if index = index_type'high then
            index<= index_type'low;
        else
            index <= index +1;
        end if;
    end procedure;

begin
    --HEAD
    process (clk)
    begin
        if rising_edge(clk) then 
            if srst = '1' then
                head <= 0;
            elsif wr_en = '1' and full_i = '0'then 
                increase(head);
            end if;
        end if;
    end process;

    --TAIL
    process(clk)
    begin
        if rising_edge(clk) then
            if srst = '1' then
                tail <= 0;
            elsif rd_en = '1' and empty_i ='0' then
                increase(tail);
            end if;
        end if;
    end process;

    --DATA TRANSFER
    process(clk)
    begin
        if rising_edge(clk) then
            if srst = '1' then
                ram <= (others =>(others =>'0'));
            else
                ram(head) <= din;
                dout <= ram(tail);
            end if;
        end if;
    end process;

    --COUNTER
    process(head, tail)
    begin
        if head < tail then
            counter_i <= DATA_DEPTH + head - tail;
        else
            counter_i <= head - tail;
        end if;
    end process;

    --FLAGS
    process(counter_i)
    begin
        if counter_i = 0 then
            empty_i <= '1';
        else
            empty_i <= '0';
        end if;

        if counter_i = DATA_DEPTH -1 then
            full_i <= '1';
        else
            full_i <= '0';
        end if;

        if counter_i >= PROG_FULL_TRESHOLD then
            prog_full_i <= '1';
        else
            prog_full_i <= '0';
        end if;
    end process;
    --OUTPUT
    empty <= empty_i;
    full <= full_i;
    prog_full <= prog_full_i;
    counter <= counter_i;


end behavioral;
