library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity spiflash is
  generic
  (
    g_file_name : string := "mpramtest.data"
  );

  port
  (
    clk    : in  std_logic;
    cs_n   : in  std_logic;
    di     : in  std_logic;
    do     : out std_logic;
    wp_n   : in  std_logic;
    hold_n : in  std_logic
  );
end entity;

architecture rtl of spiflash is

  constant npages_c : integer := 8; -- 1 page = 32 bytes
  constant bytes_per_line_c : integer := 10;

  type page_type is array (0 to 31) of std_logic_vector(7 downto 0);
  type ram_type is array (0 to npages_c-1) of page_type;
  type reg_type is array (0 to 2) of std_logic_vector(7 downto 0);

  type state_type is (idle, read_data, page_program, read_sr1, read_sr2, read_sr3);

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

    -- loop through enough lines fo fill ram
      for i in 0 to (integer(ceil(real(npages_c*32)/real(bytes_per_line_c)))) loop
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

  signal reg : reg_type := ((others => '0'), ("11110000"), ("01010101"));

  signal state : state_type;
  signal address : std_logic_vector(23 downto 0);

begin

  process
  begin
    wait for 10 ps;
    init_ram_from_file(g_file_name, ram);
    wait;
  end process;

  process(clk)
    variable instruction : std_logic_vector(7 downto 0);
    variable instcnt : integer;
    variable addrcnt : integer;
    variable docnt   : integer;
    variable pagecnt : integer;
    variable bytecnt : integer;

  begin
    if (rising_edge(clk)) then
      if (cs_n = '1') then
        do          <= '0';
        state       <= idle;
        instruction := (others => '0');
        address     <= (others => '0');
        instcnt     := 0;
        addrcnt     := 0;
        docnt       := 7;
        pagecnt     := 0;
        bytecnt     := 0;

      else
        if (instcnt < 7) then
          instruction(instruction'left - instcnt) := di;
          instcnt := instcnt + 1;
        else
          if (instcnt = 7) then
            instruction(instruction'left - instcnt) := di;
            instcnt := instcnt + 1;
          end if;
          case instruction is

            -- Read Status Register 1
            when x"05" =>
              state <= read_sr1;

            -- Read Status Register 2
            when x"35" =>
              state <= read_sr2;

            -- Read Status Register 3
            when x"15" =>
              state <= read_sr3;

            -- Read data
            when x"03" =>
              if (reg(0)(0) = '1') then
                instruction := (others => '0');
              else
                if (addrcnt > 23) then
                  state   <= read_data;
                else
                  address(23 - addrcnt) <= di;
                  addrcnt := addrcnt + 1;
                  bytecnt := to_integer(unsigned(address(4 downto 0)));
                  pagecnt := to_integer(unsigned(address(integer(ceil(log2(real(npages_c))))-1 downto 5))); 
                  if (addrcnt > 23) then
                    state   <= read_data;
                  end if;
                end if;
              end if;

            when others =>
              state <= state;
          end case;

        end if;
      end if;
    else

      case state is

        when read_sr1 =>
          if (docnt < 0) then
            docnt := 7;
          end if;
          do    <= reg(0)(docnt);
          docnt := docnt - 1;

        when read_sr2 =>
          if (docnt < 0) then
            docnt := 7;
          end if;
          do    <= reg(1)(docnt);
          docnt := docnt - 1;

        when read_sr3 =>
          if (docnt > 7) then
            docnt := 0;
          end if;
          do    <= reg(2)(docnt);
          docnt := docnt + 1;

        when read_data =>
          if (docnt < 0) then
            if (bytecnt > 30) then
              if (pagecnt > npages_c - 2) then
                pagecnt := 0;
              else
                pagecnt := pagecnt + 1;
              end if;
              bytecnt := 0;
            else
              bytecnt := bytecnt + 1;
            end if;
            docnt := 7;
          end if;
          do    <= ram(pagecnt)(bytecnt)(docnt);
          docnt := docnt - 1;

        when others =>
          state <= state;
      end case;
    end if;
  end process;

end rtl;
