library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.register_pack_imsys_demo.all;

package register_record_pack is

    type analog_in_registers_record_t is record
      analog : version_analog_t;
      digital : version_digital_t;
    end record analog_in_registers_record_t;

    type const_registers_record_t is record
      sub_hi_byte : subversion_hi_byte_sub_hi_byte_t;
      sub_lo_byte : subversion_low_byte_sub_lo_byte_t;
    end record const_registers_record_t;

   constant analog_in_registers_scan_c : analog_in_registers_record_t := (
      analog => version_analog_scan_c,
      digital => version_digital_scan_c);

   constant const_registers_scan_c : const_registers_record_t := (
      sub_hi_byte => subversion_hi_byte_sub_hi_byte_scan_c,
      sub_lo_byte => subversion_low_byte_sub_lo_byte_scan_c);

end register_record_pack;
