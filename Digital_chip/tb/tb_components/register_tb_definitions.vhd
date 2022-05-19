library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package register_tb_definitions is
 
  type access_mode_t is (rw, r, w, exclude);

  constant name_length_c : integer := 20;
  type register_record_t is record
    name        : string(name_length_c downto 1);
    reset       : std_ulogic_vector(7 downto 0);
    mask        : std_ulogic_vector(7 downto 0);
    address     : integer;
    access_mode : access_mode_t;
  end record register_record_t;
 
  type register_list_t is array (natural range <>) of register_record_t;

  function trim (string_in : string) return string;

  function resize (string_in : string) return string;
  
  function get_all_rw_registers (
    list : register_list_t)
    return register_list_t;

  function int_to_stdUlogicVector (
    l : integer;
    r : integer)
    return std_ulogic_vector;
  
  function to_register (
    constant value : integer;
    constant left_shift : integer)
    return std_ulogic_vector;

end package register_tb_definitions;

package body register_tb_definitions is

  
  function trim (
    string_in : string)
    return string is
  begin  -- function split
    for i in string_in'range loop
      if string_in(i) /= ' ' then
        return string_in(i downto string_in'right);
      end if;
    end loop;  -- i
    return "";
  end function trim;

  function resize (string_in : string) return string is
    variable s : string(name_length_c downto 1) := (others => ' ');
    alias s_in : string(string_in'length downto 1) is string_in;
  begin
    for i in 1 to string_in'length loop
      s(i) := s_in(i);
    end loop;  -- i
    return s;
  end function resize;

  function int_to_stdUlogicVector (
    l : integer;
    r : integer)
    return std_ulogic_vector is
  begin  -- function int_to_stdUlogicVector
    return std_ulogic_vector(to_unsigned(l, r));
  end function int_to_stdUlogicVector;
  
  function count_rw_register (
    list : register_list_t)
    return integer is
    variable count : integer := 0;
  begin  -- function count_rw_register
    for i in list'range loop
      if list(i).access_mode = rw then
        count := count + 1;
      end if;
    end loop;
    return count;
  end function count_rw_register;
  function get_all_rw_registers (
    list : register_list_t)
    return register_list_t is

    constant length   : integer := count_rw_register(list);
    variable ret_list : register_list_t(0 to length-1);
    variable count    : integer := 0;
  begin  -- function get_all_rw_registers 
    for i in list'range loop
      if list(i).access_mode = rw then
        ret_list(count) := list(i);
        count           := count + 1;
      end if;
    end loop;
    return ret_list;
  end function get_all_rw_registers;

  function to_register (
   constant value : integer;
   constant left_shift : integer)
    return std_ulogic_vector is
  begin
    return std_ulogic_vector(to_unsigned(value * 2**left_shift, 8));
  end to_register;

end package body register_tb_definitions;
