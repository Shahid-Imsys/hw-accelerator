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

  constant npages_c         : integer := 8; -- 1 page = 32 bytes
  constant bytes_per_line_c : integer := 10; -- in file to read
  constant pp_exec_time_c   : time    := 200 ns; -- Typ 0.4 ms, max 3 ms
  constant ec_exec_time_c   : time    := 200 ns; -- Typ 20 s, max 100 s

  type page_type is array (0 to 31) of std_logic_vector(7 downto 0);
  type ram_type  is array (0 to npages_c-1) of page_type;
  type reg_type  is array (0 to 2) of std_logic_vector(7 downto 0);

  type state_fall_type is (idle, rsr1, rsr2, rsr3, rd);
  type state_cs_type   is (idle, pp, ec, we, wd);
  type state_busy_type is (idle, pp, ec);

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
  signal ram   : ram_type := (others => (others => (others => '1')));
  signal reg   : reg_type := (others => (others => '0'));
  signal BUSY  : std_logic := '0';
  signal WEL   : std_logic := '0'; -- Write Enable Latch
  signal ppbuf : page_type := (others => (others => '1'));
  signal timer : time;

  signal state_fall : state_fall_type;
  signal state_cs   : state_cs_type;
  signal state_busy : state_busy_type;

begin

  reg(0)(1) <= WEL;
  reg(0)(0) <= BUSY;

  process

    variable instruction_v : std_logic_vector(7 downto 0)  := (others => '0');
    variable address_v     : std_logic_vector(23 downto 0) := (others => '0');

    variable instcnt_v : integer := 0;
    variable addrcnt_v : integer := -1;
    variable bitcnt_v  : integer := 7;
    variable pagecnt_v : integer := 0;
    variable bytecnt_v : integer := 0;
    variable busycnt_v : integer := 0;

  begin
    wait for 10 ps;
    init_ram_from_file(g_file_name, ram);

    loop
      wait on clk, cs_n;

      if (rising_edge(clk)) then
        if (instcnt_v < 7) then
          instruction_v(instruction_v'left - instcnt_v) := di;
          instcnt_v := instcnt_v + 1;
        else
          if (instcnt_v = 7) then
            instruction_v(instruction_v'left - instcnt_v) := di;
            instcnt_v := instcnt_v + 1;
          end if;
          case instruction_v is

            ---------------------------
            -- Write enable
            ---------------------------
            when x"06" =>
              if (BUSY = '1') then
                instruction_v := (others => '0');
              else
                state_cs <= we;
              end if;

            ---------------------------
            -- Write disable
            ---------------------------
            when x"04"=>
              if (BUSY = '1') then
                instruction_v := (others => '0');
              else
                state_cs <= wd;
              end if;

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
              if (BUSY = '1') then
                instruction_v := (others => '0');
              else
                -- Read address
                if (addrcnt_v < 0) then
                  addrcnt_v := addrcnt_v + 1;
                elsif (addrcnt_v < 23) then
                  address_v(address_v'left - addrcnt_v) := di;
                  addrcnt_v := addrcnt_v + 1;
                else
                  if (addrcnt_v = 23) then
                    address_v(address_v'left - addrcnt_v) := di;
                    addrcnt_v := addrcnt_v + 1;
                    bytecnt_v := to_integer(unsigned(address_v(4 downto 0)));
                    pagecnt_v := to_integer(unsigned(address_v(23 downto 5))); 
                  --pagecnt_v := to_integer(unsigned(address_v(integer(ceil(log2(real(npages_c))))-1 downto 5))); 
                  end if;
                  state_fall <= rd;
                end if;
              end if;

            ---------------------------
            -- Page program
            ---------------------------
            when x"02" =>
              if (BUSY = '1' or WEL = '0') then
                instruction_v := (others => '0');
              else
                -- Read address
                if (addrcnt_v < 0) then
                  addrcnt_v := addrcnt_v + 1;
                elsif (addrcnt_v < 24) then
                  address_v(address_v'left - addrcnt_v) := di;
                  addrcnt_v := addrcnt_v + 1;
                  bytecnt_v := to_integer(unsigned(address_v(4 downto 0)));
                  pagecnt_v := to_integer(unsigned(address_v(23 downto 5))); 
                else
                  -- Read data into buffer
                  if (bitcnt_v < 0) then
                    if (bytecnt_v > 30) then
                      bytecnt_v := 0;
                    else
                      bytecnt_v := bytecnt_v + 1;
                    end if;
                    bitcnt_v := 7;
                  end if;
                  ppbuf(bytecnt_v)(bitcnt_v) <= di;
                  bitcnt_v := bitcnt_v - 1;
                  if (bitcnt_v < 0) then
                    state_cs <= pp;
                  else
                    state_cs <= idle;
                  end if;
                end if;
              end if;

            ---------------------------
            -- Chip Erase
            ---------------------------
            when x"c7" | x"60" =>
              if (BUSY = '1' or WEL = '0') then 
                instruction_v := (others => '0');
              else
                state_cs <= ec;
              end if;

            when others =>
              state_fall <= state_fall;
          end case;
        end if;

      elsif (falling_edge(clk)) then -- Falling edge

        case state_fall is

          -- Read status register 1
          when rsr1 =>
            if (bitcnt_v < 0) then
              bitcnt_v := 7;
            end if;
            do     <= reg(0)(bitcnt_v);
            bitcnt_v := bitcnt_v - 1;

          -- Read status register 2
          when rsr2 =>
            if (bitcnt_v < 0) then
              bitcnt_v := 7;
            end if;
            do     <= reg(1)(bitcnt_v);
            bitcnt_v := bitcnt_v - 1;

          -- Read status register 3
          when rsr3 =>
            if (bitcnt_v > 7) then
              bitcnt_v := 0;
            end if;
            do     <= reg(2)(bitcnt_v);
            bitcnt_v := bitcnt_v + 1;

          -- Read data
          when rd =>
            if (bitcnt_v < 0) then
              if (bytecnt_v > 30) then
                if (pagecnt_v > npages_c - 2) then
                  pagecnt_v := 0;
                else
                  pagecnt_v := pagecnt_v + 1;
                end if;
                bytecnt_v := 0;
              else
                bytecnt_v := bytecnt_v + 1;
              end if;
              bitcnt_v := 7;
            end if;
            do     <= ram(pagecnt_v)(bytecnt_v)(bitcnt_v);
            bitcnt_v := bitcnt_v - 1;

          when others =>
            state_fall <= state_fall;
        end case;
      end if;


      if (cs_n = '1') then
        case state_cs is

          -- Write enable
          when we =>
            WEL      <= '1';

          -- Write disable
          when wd =>
            WEL      <= '0';

          -- Page program
          when pp =>
            for i in ppbuf'low to ppbuf'high loop
              for j in 0 to 7 loop
                ram(pagecnt_v)(i)(j) <= ram(pagecnt_v)(i)(j) and ppbuf(i)(j);
              end loop;
            end loop;
            WEL        <= '0';
            timer      <= now;
            state_busy <= pp;

          -- Erase chip
          when ec =>
            ram   <= (others => (others => (others => '1')));
            WEL        <= '0';
            timer      <= now;
            state_busy <= ec;

          when others =>
            null;

        end case;

        state_cs      <= idle;
        do            <= '0';
        state_fall    <= idle;
        instruction_v := (others => '0');
        address_v     := (others => '0');
        instcnt_v     := 0;
        addrcnt_v     := -1;
        bitcnt_v      := 7;
        pagecnt_v     := 0;
        bytecnt_v     := 0;
        busycnt_v     := 0;

      end if;
    end loop;
  end process;

  busy_timer : process
  begin
    loop
      case state_busy is
        when pp =>
          if (timer > now - pp_exec_time_c) then
            BUSY <= '1';
          else
            BUSY <= '0';
          end if;

        when ec =>
          if (timer > now - ec_exec_time_c) then
            BUSY <= '1';
          else
            BUSY <= '0';
          end if;

        when others =>
          BUSY <= '0';
      end case;
      wait for 1 ns;
    end loop;
  end process;
end rtl;
