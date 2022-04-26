library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity spiflash is
  generic
  (
    g_file_name : string := "mpram1.data"
  );

  port
  (
    clk  : in std_logic;
    CS   : in std_logic;
    we_n : in std_logic;
    addr : in std_logic_vector(7 downto 0);
    din  : in std_logic_vector(7 downto 0);
    dout : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of spiflash is

  constant npages_c : integer := 8; -- 1 page = 32 bytes
  constant bytes_per_line_c : integer := 10;

  type page_type is array (0 to 31) of std_logic_vector(7 downto 0);
  type ram_type is array (0 to npages_c-1) of page_type;
  type reg_type is array (0 to 2) of std_logic_vector(7 downto 0);

  procedure init_ram_from_file (ram_file_name : in string; signal content : inout ram_type ) is
    file ram_file          : text;
    variable status        : file_open_status := status_error;
    variable ram_file_line : line;
    variable row           : std_logic_vector((bytes_per_line_c*8)-1 downto 0);
    variable bits          : bit;
    variable l             : line;
    variable ram           : ram_type := content;
    variable page          : page_type;

    variable byte_cnt      : integer := 0;
    variable page_cnt      : integer := 0;

  begin
    file_open(status, ram_file, ram_file_name, read_mode);
    if status /= open_ok then
      write(l, string'("open fail"));
      writeline(output, l);
      return;
    end if;

    -- loop through ceil(npages_c, bytes_per_line_c) lines
    for i in 0 to (((npages_c*32 + (bytes_per_line_c-1))/(bytes_per_line_c)) - 1) loop 
      -- insert line i to row
      readline(ram_file, ram_file_line);
      for i in row'range loop
        read(ram_file_line, bits);
        if bits = '1' then
          row(i) := '1';
        else
          row(i) := '0';
        end if;
      end loop;

      -- fill page byte by byte
      for j in 0 to bytes_per_line_c-1 loop
        if (byte_cnt > 31) then
          if (page_cnt > npages_c - 1) then
            exit;
          else
            ram(page_cnt) := page;
            page_cnt := page_cnt + 1;
            byte_cnt := 0;
          end if;
        end if;
        page(byte_cnt) := row(row'left - j*8 downto row'left-7 - j*8);
        byte_cnt := byte_cnt + 1;
      end loop;
    end loop;

    wait for 2 ns;
    write(l, string'("file ") & ram_file_name & " loaded to RAM");
    writeline(output, l);

    file_close(ram_file);

    content <= ram;
  end procedure;

  signal page : page_type;
  signal ram  : ram_type;

  -- Registers
  signal reg : register_type;

begin

  process
  begin
    wait for 10 ps;
    init_ram_from_file(g_file_name, ram);
    loop
      wait on clk until clk = '1'; -- rising_edge(clk) then
      if CS = '1' then
        if we_n = '0' then
          ram(to_integer(unsigned(addr(7 downto 5))))(to_integer(unsigned(addr(4 downto 0)))) <= din; 
        end if;
        dout <= ram(to_integer(unsigned(addr(7 downto 5))))(to_integer(unsigned(addr(4 downto 0)))); 
      end if;
    end loop;
  end process;

end rtl;
