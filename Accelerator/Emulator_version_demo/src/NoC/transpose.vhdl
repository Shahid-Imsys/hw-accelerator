library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_types.all;

entity transpose is

  generic (
    no_of_pe : integer := 16);

  port (
    clk              : in std_logic;
    rst              : in std_logic;
    write_enable     : in std_logic;
    noc_write_enable : in std_logic;
    adress           : in std_logic_vector(1 downto 0);
    noc_adress       : in std_logic_vector(3 downto 0);

    data_in      : in  byte_array_t(no_of_pe-1 downto 0);
    data_out     : out byte_array_t(no_of_pe-1 downto 0);
    noc_data_in  : in  byte_array_t(3 downto 0);
    noc_data_out : out byte_array_t(3 downto 0)
    );

end entity transpose;

architecture rtl of transpose is

  type picture_array_t is array (natural range <>) of byte_array_t(no_of_pe-1 downto 0);
  type cluster_array_t is array (natural range <>) of byte_array_t(3 downto 0);
  type state_vector_t is (init, receive_picture, transmitt,
                          receive_cluster_data, transmitt_cluster_data);

  signal state              : state_vector_t;
  signal transposed_picture : cluster_array_t(no_of_pe - 1 downto 0);
  signal picture_array      : picture_array_t(3 downto 0);

  signal read_counter : integer range 0 to 15;
begin  -- architecture rtl

  -- The received picture is transposed to cluster format.
  -- This process is only wires
  transpose_p : process (picture_array) is
  begin  -- process transpose_p
    for i in transposed_picture'range loop
      for j in picture_array'range loop
        transposed_picture(i)(j) <= picture_array(j)(i);
      end loop;  -- j
    end loop;  -- i
  end process transpose_p;

  noc_data_out <= transposed_picture(to_integer(unsigned(noc_adress)));

  data_out <= picture_array(to_integer(unsigned(adress)));

  read_in_data : process (clk, rst) is
    variable v_adress : integer range 0 to 3;
  begin  -- process read_in_data
    if rst = '1' then
      picture_array <= (others => (others => (others => '0')));
    elsif clk'event and clk = '1' then

      -- Data from the ... is written to the internal array
      if write_enable = '1' then
        v_adress                := to_integer(unsigned(adress));
        picture_array(v_adress) <= data_in;
      end if;

      -- Data from the noc is transposed and written the internal array
      if noc_write_enable = '1' then
        for i in picture_array'range loop
          picture_array(i)(to_integer(unsigned(noc_adress))) <= noc_data_in(i);
        end loop;  -- i
      end if;
    end if;
  end process read_in_data;


end architecture rtl;
