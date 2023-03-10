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
-- Title      : Generic parallel data interface
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pdi.vhd
-- Author     : Xing Zhao
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
-- 2005-11-28		0.0				CB			Created
-- 2005-12-15		1.0				CB			Changed id_en to active high
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity pdi_inf is  
  port (
    -- IO bus signals
    clk_p           : in std_logic;
	clk_i_pos		: in	std_logic;
    idi     : in  std_logic_vector(7 downto 0);
    idack   : in  std_logic; 
    idreq   : out std_logic;
    ido     : out std_logic_vector(7 downto 0);
    id_en   : out std_logic;            -- active high!
    -- clock from timer
    pdi_clk : in  std_logic;
    -- configuration from CRB(?)
    pdi_en  : in  std_logic;            -- '1': enable
    pdi_dir : in  std_logic;            -- '1/0': output/input  
    -- data to/from port
    pdi_d_i : in  std_logic_vector(7 downto 0);
    pdi_d_o : out std_logic_vector(7 downto 0)
    );
end pdi_inf;

architecture rtl of pdi_inf is
  type mem_typ is array (3 downto 0) of
                   std_logic_vector(7 downto 0);
  signal wr_ptr : std_logic_vector(1 downto 0);
  signal rd_ptr : std_logic_vector(1 downto 0);
  signal entry  : std_logic_vector(1 downto 0);  
  signal fifo   : mem_typ;
  signal edge   : std_logic_vector(1 downto 0);
  signal ext_acc: std_logic;            -- external access
begin  -- rtl
  -- detecting pdi_clk falling edge
  process (clk_p)
  begin
    if rising_edge(clk_p) then  --rising_edge(clk_i)
        if pdi_en = '0' then 
            edge <= (others => '0');
        elsif  clk_i_pos = '0' then
            edge(0) <= pdi_clk;
            edge(1) <= edge(0);
        end if;
    end if;
  end process;
  ext_acc <= edge(1) and (not edge(0));

  -- FIFO write pointer
  process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i) 
        if (pdi_en = '0') then
            wr_ptr <= (others => '0');
        elsif clk_i_pos = '0' then
            if (idack = '0' and pdi_dir = '1') or
              (ext_acc = '1' and pdi_dir = '0') then
              wr_ptr <= wr_ptr + 1;
            end if;
        end if;
    end if;
  end process;

  -- FIFO read pointer
  process (clk_p)
  begin 
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if (pdi_en = '0') then
            rd_ptr <= (others => '0');
        elsif clk_i_pos = '0' then
            if (idack = '0' and pdi_dir = '0') or
              (ext_acc = '1' and pdi_dir = '1') then
              rd_ptr <= rd_ptr + 1;
            end if;
        end if;
    end if;
  end process;

  -- FIFO entry count
  process (clk_p)
    variable tmp : std_logic_vector(1 downto 0);
  begin 
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if (pdi_en = '0') then
            tmp := (others => '0');
        elsif clk_i_pos = '0' then
            if (idack = '0' and pdi_dir = '1') or
              (ext_acc = '1' and pdi_dir = '0') then
                tmp := tmp + 1;
            end if;
            if (idack = '0' and pdi_dir = '0') or
              (ext_acc = '1' and pdi_dir = '1') then
              tmp := tmp - 1;
            end if;
        end if;        
    end if;
    entry <= tmp;
  end process;

  -- FIFO write access
  process (clk_p)
  begin    
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if clk_i_pos = '0' then
            if (idack = '0' and pdi_dir = '1' and pdi_en = '1') then
              fifo(conv_integer(wr_ptr)) <= idi;
            end if;
            if (pdi_dir = '0' and ext_acc = '1' and pdi_en = '1') then
              fifo(conv_integer(wr_ptr)) <= pdi_d_i;
            end if;
        end if;
    end if;
  end process;

  -- FIFO read access
  pdi_d_o <= fifo(conv_integer(rd_ptr));
  ido <= fifo(conv_integer(rd_ptr));
  id_en <= '1' when idack = '0' and pdi_dir = '0' else
           '0';
  
  -- idreq generation
  process (entry, idack, pdi_en, pdi_dir)
  begin
    idreq <= '1';
    if pdi_en = '1' then
      idreq <= '0';
      if ((entry = "01" and idack = '0') or entry = "00")
        and pdi_dir = '0' then
        idreq <= '1';
      end if;
      if ((entry = "10" and idack = '0') or entry = "11")
        and pdi_dir = '1' then
        idreq <= '1';
      end if;
    end if;   
  end process;

  
end rtl;
