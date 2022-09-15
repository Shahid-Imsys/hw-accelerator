-- ----------------------------------------------------------------------------
-- Copyright (c): Shortlink AB
-- All Rights Reserved.
--
-- The information contained herein is confidential property of
-- Shortlink AB. The user, copying, transfer or disclosure
-- of such information is prohibited except by express written
-- agreement with Shortlink AB.
-- ----------------------------------------------------------------------------
-- ASIC:     
-- Module:   
-- ----------------------------------------------------------------------------
-- Authors:  
-- Company:  Shortlink
-- ----------------------------------------------------------------------------
-- Description:
--
-- Parent:
-- Children:
--
-- Reference:
--
-- ----------------------------------------------------------------------------
-- REVISION HISTORY:
-- 2013-02-12 haro Added ; @ the end.
-- ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

use std.textio.all;


use work.digital_top_sim_pack.all;

entity uart_tb is

  port (
    clk            : in  std_logic;
    tx             : out std_ulogic;
    rx             : in  std_ulogic;
    reg_to_block   : out reg_to_block_t;
    reg_from_block : in  reg_from_block_t
    );
end uart_tb;



architecture tb of uart_tb is

  constant bit_length_1062kHz   : time := 941.176 ns;
  constant bit_length_1000kHz   : time := 1000 ns;
  constant bit_length_921k600Hz : time := 1085 ns;
  constant bit_length_532kHz    : time := 1882.353 ns;
  constant bit_length_500kHz    : time := 2000 ns;
  constant bit_length_250kHz    : time := 4000 ns;
  constant bit_length_115k2Hz   : time := 8681 ns;
  constant bit_length_83kHz     : time := 12000 ns;
  constant bit_length_42kHz     : time := 24000 ns;
  constant bit_length_9k6Hz     : time := 104166 ns;
  constant bit_length_600Hz     : time := 1666666 ns;



  -- signal start_bit     : time := 27.2 ns * 1.5;
  -- signal bit_length    : time := 27.2 ns;

  signal bit_length    : time := bit_length_921k600Hz; -- 27.2 ns * 2;
  signal start_bit     : time := bit_length * 1.5;
  signal new_byte      : std_ulogic;
  signal received_byte : integer;
  signal tx_data       : std_ulogic_vector(7 downto 0);
  signal tx_int        : std_ulogic;
  signal tx_enable     : boolean := false;
  signal tx_busy       : boolean;

  type state_t is (wait_on_address, short_message_1, short_message_2, write_message, write_data, read_data);
  signal state : state_t := wait_on_address;

  signal uploading   : boolean := false;
  signal upload_done : boolean := false;


begin

  tx        <= tx_int;
  start_bit <= bit_length * 1.5;

  process
    variable received_data : std_ulogic_vector(7 downto 0);
  begin
    wait until rx = '0';
    received_data := (others => '0');
    wait for start_bit;
    for i in 0 to 7 loop
      received_data(i) := rx;
      wait for bit_length;
    end loop;
    received_byte <= to_integer(unsigned(received_data));
  end process;

  noc_upload_detect_proc : process(state, upload_done)
    variable state_d : state_t := wait_on_address;
  begin

    if uploading and upload_done then
      uploading <= false;
    else
      case state_d is
        when short_message_1 | short_message_2 =>
          if received_byte = (14*16) then  -- x"E0"
            uploading <= true;
          end if;
        when others => null;
      end case;
    end if;

    state_d := state;
  end process;

  noc_upload_proc : process
    file fHandle      : text open read_mode is "../../../tb/main_tb/noc_code.txt";
    variable row      : line;
    variable dbg_line : line;
    variable ch       : character;
    variable ok       : boolean;
    variable done     : boolean := true;
    variable bit_cnt  : integer;
    variable byte_cnt : integer := 0;
    variable octet    : std_ulogic_vector(7 downto 0);
  begin
     
    while true loop
      if uploading and not done then
        if(not endfile(fHandle)) then
          readline(fHandle, row);
          --write( dbg_line, string'("Read line ") );
          --writeline( output, dbg_line );

          for i in row'range loop
            read(row, ch, ok);
            if not ok then
              write( dbg_line, string'("Read NOT OK") );
              writeline( output, dbg_line );
            end if;
            --write( dbg_line, string'("Read #") );
            --write( dbg_line, i );
            --write( dbg_line, string'(" is ") );
            --write( dbg_line, ch );
            --writeline( output, dbg_line );

            if ch = '1' then
              octet(7 - bit_cnt) := '1';
                --assert false report "Char 1" severity note;
            elsif ch /= '0' then
                ok := false;
                --assert false report "Bad char" severity warning;
                --write( dbg_line, ch );
                --writeline( output, dbg_line );
            else
                --assert false report "Char 0" severity note;
            end if;

            if ok then
                bit_cnt := bit_cnt + 1;
            end if;
            if bit_cnt = 8 then
              bit_cnt := 0;

              --assert false report "Wait for tx available" severity note;

              while tx_busy = true loop
                wait on tx_busy;
              end loop;
              tx_data   <= octet;
              tx_enable <= true;

              --assert false report "Wait for tx enable" severity note;

              wait until tx_busy = true;
              tx_enable <= false;
              byte_cnt := byte_cnt + 1;

              write(dbg_line, string'("Sending 0x"));
              hwrite(dbg_line, octet);
              write(dbg_line, string'(", byte "));
              write(dbg_line, byte_cnt);
              writeline(output, dbg_line);

              wait until tx_busy = false;
              octet := x"00";
              --write( dbg_line, string'("tx complete") );
              --writeline( output, dbg_line );
            end if;
          end loop;
        else
          write( dbg_line, string'("EOF") );
          writeline( output, dbg_line );

          done        := true;
          upload_done <= true;
        end if;
      else
        write( dbg_line, string'("Wait for upload") );
        writeline( output, dbg_line );

        upload_done <= true;
        bit_cnt     := 0;
        octet       := x"00";
        
        wait until uploading;
        done := false;
      end if;
    end loop;
  end process;

  transmit_data : process
    variable tx_data_v : std_ulogic_vector(7 downto 0) := (others => '0');
  begin  -- transmit_byte

    tx_int  <= '1';
    tx_busy <= false;

    while true loop
      wait until tx_enable;
      tx_busy <= true;
      wait for start_bit;
      tx_int  <= '0';

      wait for bit_length;
      tx_data_v := tx_data;

      for i in 0 to 7 loop
        tx_int <= tx_data_v(i);
        wait for bit_length;
      end loop;  -- i

      tx_int  <= '1';
      tx_busy <= false;
    end loop;

  end process transmit_data;

  register_update : process (received_byte)
    variable l                : line;
    variable reg_to_block_tmp : reg_to_block_t;
  begin  -- process register

    if now > 30 ns then

      case state is
        when wait_on_address =>
          case received_byte mod 128 is
            when tb_short_message_1 => state <= short_message_1;
            when tb_short_message_2 => state <= short_message_2;
            when tb_write           => state <= write_message;
            when others =>
              reg_to_block_tmp.address := received_byte mod 128;
              reg_to_block_tmp.byte    := 1;
              if received_byte / 128 = tb_write then
                reg_to_block_tmp.read_data := false;
                state                      <= write_data;
              else
                reg_to_block_tmp.read_data := true;
                reg_to_block               <= reg_to_block_tmp;
                state                      <= read_data;
              end if;
          end case;

        when short_message_1 =>
          decode_error_code("core1", received_byte);
          state <= wait_on_address;

        when short_message_2 =>
          decode_error_code("core2", received_byte);
          state <= wait_on_address;

        when write_message =>
          if received_byte = 16#23# then
            writeline(output, l);
            state <= wait_on_address;
          else
            --write(l, character'val(received_byte));
            --write(l, received_byte);
            write(l, string'("0x"));
            hwrite(l, std_logic_vector(to_unsigned(received_byte, 8)));
            write(l, string'(" "));
          end if;

          --when read_address =>

        when others =>
          report "Unknown state in uart_tb" severity note;
      end case;

    end if;
  end process;
end tb;
