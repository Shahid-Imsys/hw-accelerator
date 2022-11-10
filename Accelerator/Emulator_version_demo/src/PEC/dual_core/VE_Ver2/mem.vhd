--mem for testing

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.memtypes.all;

entity mem is
  generic (
    load_filename : string;
    width         : integer := 32;
    addressbits   : integer := 2;
    columns       : integer := 4
    );
  port (
    clk      : in  std_logic;
    read_en  : in  std_logic;
    write_en : in  std_logic;
    d_in     : in  std_logic_vector(width-1 downto 0);
    address  : in  std_logic_vector(addressbits-1 downto 0);
    d_out    : out std_logic_vector(width-1 downto 0);
    load_mem : in std_logic
    );
end entity;

architecture rtl of mem is
  constant mem_size    : integer := natural(2 ** real(addressbits));
  type mem_t is array (0 to mem_size-1) of std_logic_vector(width-1 downto 0);
  signal memory        : mem_t;
  signal cycle_counter : integer := 0;
  constant data_size   : integer := width/columns;
begin

  process(clk, load_mem)
  file load_text_file : text open read_mode is load_filename;
  file save_text_file : text;
  variable text_line : line;
  variable val_bias : std_logic_vector(width-1 downto 0);
  begin
    if load_mem = '1' then
      for i in 0 to mem_size-1 loop
        exit when endfile(load_text_file);
        readline(load_text_file,text_line);
        hread(text_line, val_bias);
        memory(i) <= val_bias;
      end loop ;
    elsif rising_edge(clk) then
      assert not (read_en = '1' and write_en = '1') report "Concurrent read and write";
      if read_en = '1' then
        d_out <= memory(to_integer(unsigned(address)));
      elsif write_en = '1' then
        memory(to_integer(unsigned(address))) <= d_in;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      cycle_counter <= cycle_counter + 1;
    end if;
  end process;

end architecture;