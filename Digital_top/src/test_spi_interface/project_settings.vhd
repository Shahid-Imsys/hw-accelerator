library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package project_settings is

  constant spi_data_width_c    : integer := 8;
  constant spi_address_width_c : integer := 15;

  subtype register_t is std_ulogic_vector(7 downto 0);

  function str_to_stdUlogicVector (
   constant s : string)
    return std_ulogic_vector;

end package project_settings;

package body project_settings is
 
  function char_to_int (
    constant c : character)
    return integer is
  begin --char_to_int
    case c is
      when '0' => return 0;
      when '1' => return 1;
      when '2' => return 2;
      when '3' => return 3;
      when '4' => return 4;
      when '5' => return 5;
      when '6' => return 6;
      when '7' => return 7;
      when '8' => return 8;
      when '9' => return 9;
      when others => return 0;
    end case;
  end char_to_int;

  function str_to_stdUlogicVector (
    constant s : string)
    return std_ulogic_vector is
    variable ret : integer := 0;
  begin --str_to_int
    for i in s'range loop
      ret := char_to_int(s(i)) + ret * 10;
    end loop;  -- i
    return std_ulogic_vector(to_unsigned(ret, 16));
  end str_to_stdUlogicVector;


end package body project_settings;
