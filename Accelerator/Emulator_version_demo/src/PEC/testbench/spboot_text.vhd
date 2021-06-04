
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
--library work;
--use work.io_utils.all;
--use work.mti_pkg.all;

entity spboot_text is


architecture behav of spboot_text is
    type      mpgm_type is array (mpgm_size - 1 downto 0) of integer;
signal mpgm_area_i : mpgm_type
begin  -- behav

  process
    constant  mpgm_size : integer := 2*2048*10; -- Microprogram size in bytes

    variable  mpgm_area : mpgm_type; -- Microprogram data area
    variable  mpgm_ptr  : integer;   -- Microprogram data pointer
    CONSTANT not_digit : integer := -999;
    variable	l					: line;
  FUNCTION digit_value(c : character) RETURN integer IS
      BEGIN
         IF (c >= '0') AND (c <= '9') THEN
             RETURN (character'pos(c) - character'pos('0'));
          ELSIF (c >= 'a') AND (c <= 'f') THEN
              RETURN (character'pos(c) - character'pos('a') + 10);
          ELSIF (c >= 'A') AND (c <= 'F') THEN
              RETURN (character'pos(c) - character'pos('A') + 10);
          ELSE
              RETURN not_digit;
          END IF;
      EN
impure function init_from_file (ram_file_name : in string) return mpgm_type is
	FILE ram_file : text is in ram_file_name;
	variable ram_file_line : line;
	variable RAM : mpgm_type;
	begin
		--for i in rom_type'range loop
		for i in 0 to mpgm_size-1 loop
			readline(ram_file, ram_file_line);
			for j in 0 to ram_file_line'right loop
			RAM(i):=digit_value(ram_file_line(j));
			end loop;
		end loop;
	return RAM;
end function;
procedure load_mpgm_file is
begin
mpgm_area := init_from_file ("RAM0.HEX");
mpgm_area_i <= mpgm_area;
  --end procedure;
  end process;

end behav;
