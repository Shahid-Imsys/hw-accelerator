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
  type ram_type  is array (0 to npages_c-1) of page_type;
  type reg_type  is array (0 to 2) of std_logic_vector(7 downto 0);

  type state_fall_type is (idle, we, wd, rsr1, rsr2, rsr3, rd);

  procedure init_ram_from_file (ram_file_name : in string; signal content : inout ram_type ) is
    file ram_file            : text;
    variable status_v        : file_open_status := status_error;
    variable ram_file_line_v : line;
    variable row_v           : std_logic_vector((bytes_per_line_c*8)-1 downto 0);
    variable bits_v          : bit;
    variable l_v             : line;
    variable ram_v           : ram_type := content;
    variable page_v          : page_type;

    variable byte_cnt_v      : integer := 0;
    variable page_cnt_v      : integer := 0;

  begin
    file_open(status_v, ram_file, ram_file_name, read_mode);
    if status_v /= open_ok then
      write(l_v, string'("open fail"));
      writeline(output, l_v);
      return;
    end if;

    -- loop through enough lines fo fill ram
    for i in 0 to (integer(ceil(real(npages_c*32)/real(bytes_per_line_c)))) loop
      -- insert line i to row_v
      readline(ram_file, ram_file_line_v);
      for i in row_v'range loop
        read(ram_file_line_v, bits_v);
        if bits_v = '1' then
          row_v(i) := '1';
        else
          row_v(i) := '0';
        end if;
      end loop;

      -- fill page byte by byte
      for j in 0 to bytes_per_line_c-1 loop
        if (byte_cnt_v > 31) then
          if (page_cnt_v > npages_c - 1) then
            exit;
          else
            ram_v(page_cnt_v) := page_v;
            page_cnt_v := page_cnt_v + 1;
            byte_cnt_v := 0;
          end if;
        end if;
        page_v(byte_cnt_v) := row_v(row_v'left - j*8 downto row_v'left-7 - j*8);
        byte_cnt_v := byte_cnt_v + 1;
      end loop;
    end loop;

    wait for 2 ns;
    write(l_v, string'("file ") & ram_file_name & " loaded to RAM");
    writeline(output, l_v);

    file_close(ram_file);

    content <= ram_v;
    wait for 1 ps;
  end procedure;

  signal page  : page_type;
  signal ppbuf : page_type := (others => (others => '1'));
  signal ppdv  : std_logic := '0';
  signal erase : std_logic := '0';
  signal ram   : ram_type := (others => (others => (others => '1')));
  signal reg   : reg_type := (others => (others => '0'));
  signal state_fall : state_fall_type;
  signal WEL   : std_logic := '0'; -- Write Enable Latch
  signal BUSY  : std_logic := '0';

  signal addr_test : std_logic_vector(23 downto 0); -- TEMP TEST

begin

  reg(0)(1) <= WEL;
  reg(0)(0) <= BUSY;

  process

    variable instruction : std_logic_vector(7 downto 0);
    variable address     : std_logic_vector(23 downto 0);

    variable instcnt : integer;
    variable addrcnt : integer;
    variable bitcnt  : integer;
    variable pagecnt : integer;
    variable bytecnt : integer;

  begin
    wait for 10 ps;
    init_ram_from_file(g_file_name, ram);

    loop
      wait on clk, cs_n;

      if (clk = '1' and cs_n = '1') then

        do          <= '0';
        state_fall  <= idle;
        instruction := (others => '0');
        address     := (others => '0');
        instcnt     := 0;
        addrcnt     := -1;
        bitcnt      := 7;
        pagecnt     := 0;
        bytecnt     := 0;

      elsif (clk = '1' and cs_n = '0') then
        if (instcnt < 7) then
          instruction(instruction'left - instcnt) := di;
          instcnt := instcnt + 1;
        else
          if (instcnt = 7) then
            instruction(instruction'left - instcnt) := di;
            instcnt := instcnt + 1;
          end if;
          case instruction is

            ---------------------------
            -- Write enable
            ---------------------------
            when x"06" =>
              state_fall <= we;

            ---------------------------
            -- Write disable
            ---------------------------
            when x"04"=>
              state_fall <= wd;

            ---------------------------
            -- Read Status Register 1
            ---------------------------
            when x"05" =>
              state_fall <= rsr1;

            ---------------------------
            -- Read Status Register 2
            ---------------------------
            when x"35" =>
              state_fall <= rsr2;

            ---------------------------
            -- Read Status Register 3
            ---------------------------
            when x"15" =>
              state_fall <= rsr3;

            ---------------------------
            -- Read data
            ---------------------------
            when x"03" =>
              if (BUSY = '1') then -- if BUSY
                instruction := (others => '0');
              else
                -- Read address
                if (addrcnt < 0) then
                  addrcnt := addrcnt + 1;
                elsif (addrcnt < 23) then
                  address(address'left - addrcnt) := di;
                  addr_test <= address; -- TEMP TEST
                  addrcnt := addrcnt + 1;
                else
                  if (addrcnt = 23) then
                    address(address'left - addrcnt) := di;
                    addr_test <= address; -- TEMP TEST
                    addrcnt := addrcnt + 1;
                    bytecnt := to_integer(unsigned(address(4 downto 0)));
                    pagecnt := to_integer(unsigned(address(integer(ceil(log2(real(npages_c))))-1 downto 5))); 
                  end if;
                  state_fall <= rd;
                end if;
              end if;

            ---------------------------
            -- Page program
            ---------------------------
            when x"02" =>
              if (BUSY = '1' or WEL = '0') then -- if BUSY or WEL = 0
                instruction := (others => '0');
              else
                -- Read address
                if (addrcnt < 0) then
                  addrcnt := addrcnt + 1;
                elsif (addrcnt < 24) then
                  address(address'left - addrcnt) := di;
                  addrcnt := addrcnt + 1;
                  bytecnt := to_integer(unsigned(address(4 downto 0)));
                  pagecnt := to_integer(unsigned(address(integer(ceil(log2(real(npages_c))))-1 downto 5))); 
                else
                  -- Read data into buffer
                  if (bitcnt < 0) then
                    if (bytecnt > 30) then
                      bytecnt := 0;
                    else
                      bytecnt := bytecnt + 1;
                    end if;
                    bitcnt := 7;
                  end if;
                  ppbuf(bytecnt)(bitcnt) <= di;
                  bitcnt := bitcnt - 1;
                  if (bitcnt < 0) then
                    ppdv <= '1';
                  else
                    ppdv <= '0';
                  end if;
                end if;
              end if;

            ---------------------------
            -- Chip Erase
            ---------------------------
            when x"c7" | x"60" =>
              if (BUSY = '1' or WEL = '0') then -- if BUSY or WEL = 0
                instruction := (others => '0');
              else
                erase <= '1';
              end if;

            when others =>
              state_fall <= state_fall;
          end case;
        end if;

      elsif (clk = '0' and cs_n = '0') then -- Falling edge

        case state_fall is

          -- Write enable
          when we =>
            WEL <= '1'; -- WEL

          -- Write disable
          when wd =>
            WEL <= '0'; -- WEL

          -- Read status register 1
          when rsr1 =>
            if (bitcnt < 0) then
              bitcnt := 7;
            end if;
            do     <= reg(0)(bitcnt);
            bitcnt := bitcnt - 1;

          -- Read status register 2
          when rsr2 =>
            if (bitcnt < 0) then
              bitcnt := 7;
            end if;
            do     <= reg(1)(bitcnt);
            bitcnt := bitcnt - 1;

          -- Read status register 3
          when rsr3 =>
            if (bitcnt > 7) then
              bitcnt := 0;
            end if;
            do     <= reg(2)(bitcnt);
            bitcnt := bitcnt + 1;

          -- Read data
          when rd =>
            if (bitcnt < 0) then
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
              bitcnt := 7;
            end if;
            do     <= ram(pagecnt)(bytecnt)(bitcnt);
            bitcnt := bitcnt - 1;

          when others =>
            state_fall <= state_fall;
        end case;

      -- Data valid, program ram with buffer
      elsif (cs_n = '1' and ppdv = '1') then
        BUSY <= '1';
        for i in ppbuf'low to ppbuf'high loop
          for j in 0 to 7 loop
            ram(pagecnt)(i)(j) <= ram(pagecnt)(i)(j) and ppbuf(i)(j);
          end loop;
        end loop;
        wait for 0.4 ms; -- Typ page program duration
        WEL  <= '0';
        BUSY <= '0';
        ppdv <= '0';

      -- Erase chip
      elsif (cs_n = '1' and erase = '1') then
        ram       <= (others => (others => (others => '1')));
        BUSY  <= '1';
        --wait for 20 ms; -- Chip Erase Time (Typ 20 s)
        BUSY  <= '0';
        erase <= '0';
        WEL   <= '0';
      end if;
    end loop;
  end process;
end rtl;
