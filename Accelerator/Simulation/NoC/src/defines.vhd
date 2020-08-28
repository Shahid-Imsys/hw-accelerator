-- NoC simulation for Imsys Accelerator
-- 
-- Design: Harald bergh
-- Implemented: Bengt Andersson
-- Revision 0


package ACC_types is
--constant word_size : positive := 16;
--constant address_size : positive := 24;
--subtype word is bit_vector(word_size – 1 downto 0);
--subtype address is bit_vector(address_size – 1 downto 0);

-- Will this work?, BA

type BYTE is array (7 downto 0) of std_ulogic;
type NoC_bus is array (63 downto 0) of BYTE;

end package ACCss_types;