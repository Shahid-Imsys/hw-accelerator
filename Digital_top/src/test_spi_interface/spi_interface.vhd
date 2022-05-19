library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity spi_interface is

  generic (
    data_width_g           : natural   := 8;
    address_width_g        : natural   := 7;
    start_burst_adresses_g : natural   := 16#40#;
    write_value_g          : std_logic := '0'
    );
  port (
    clk       : in  std_ulogic;         -- Clock from microcontroller spi
    nclk      : in  std_ulogic;         -- Invers clk
    spi_rst_n : in  std_ulogic;
    rst_n     : in  std_ulogic;
    cs_n      : in  std_ulogic;
    mosi      : in  std_ulogic;         -- Master output Slave input
    miso      : out std_ulogic;         -- Master input Slave Output
    miso_oe_n : out std_ulogic;

    write_spi : out std_ulogic;
    enable    : out std_ulogic;
    address   : out unsigned(address_width_g - 1 downto 0);
    data_in   : in  std_ulogic_vector(data_width_g - 1 downto 0);
    data_out  : out std_ulogic_vector(data_width_g - 1 downto 0);

    update_buffer_index : out std_ulogic
    );

end spi_interface;

architecture rtl of spi_interface is

  function max (
    l1 : integer;
    l2 : integer)
    return integer is
  begin  -- function maximim
    if l1 > l2 then
      return l1;
    else
      return l2;
    end if;
  end function max;

  function fix_cc_constant(length : integer)
    return std_ulogic_vector is
    variable ret_value : std_ulogic_vector(length-1 downto 0);
  begin
    for i in ret_value'range loop
      ret_value(i) := not to_unsigned(i, 5)(0);
    end loop;  -- i
    return ret_value;
  end function fix_cc_constant;

  signal miso_temp     : std_ulogic;
  signal in_shift_reg  : std_ulogic_vector(max(data_width_g-1, address_width_g) downto 0);  -- The SPI input_shift register
  signal out_shift_reg : std_ulogic_vector(max(address_width_g - 1, data_width_g-2) downto 0);  -- The SPI outpus_shift register

  signal wr_bit_counter : integer range 0 to max(data_width_g-1, address_width_g);  -- This counter controls in which state the write process are in.

  signal rd_bit_counter : integer range 0 to max(address_width_g, data_width_g-1);  -- This counter controls in which state the read process are in.

  signal read_reg   : std_ulogic;
  signal write_reg  : std_ulogic;
  signal write_prev : std_ulogic;
  signal write_tmp  : std_ulogic;
  signal valid_data : std_ulogic;

  type state_type is (address_part, last);
  signal state : state_type;

  signal address_buffer : unsigned(address_width_g downto 0);

  signal first_byte : boolean;

  constant cc_constant : std_ulogic_vector(out_shift_reg'range) := fix_cc_constant(out_shift_reg'length);

begin  -- rtl

  read_reg <= '1' when valid_data = '1' and state = address_part and in_shift_reg(address_width_g) = not write_value_g else
              '1' when valid_data = '1' and (address_buffer(address_width_g) = not write_value_g) else
              '0';
  write_reg <= '1' when valid_data = '1' and state = last and (address_buffer(address_width_g) = write_value_g) else
               '0';

  update_buffer_index <= '1' when (state = last and (address_buffer(address_width_g) /= write_value_g) and
                                     rd_bit_counter = 1 and address_buffer(address_width_g-1 downto 0) >= start_burst_adresses_g) else
                           '0';

  enable <= read_reg or write_reg;


  write_spi <= write_reg;


  address <= unsigned(in_shift_reg(address_width_g-1 downto 0)) when read_reg = '1' and state = address_part else
             address_buffer(address_width_g-1 downto 0);
  data_out <= in_shift_reg(data_width_g-1 downto 0);

  -----------------------------------------------------------------------------
  -- ASIC miso_tristate                 
  -----------------------------------------------------------------------------
  miso      <= miso_temp;
  miso_oe_n <= cs_n;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Controls wich state the spi interface is in, adress or data.
  -----------------------------------------------------------------------------
  process (clk, spi_rst_n)

  begin  -- process
    if spi_rst_n = '0' then             -- asynchronous reset (active low)
      state          <= address_part;
      address_buffer <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if valid_data = '1' then
        if state = address_part then
          state          <= last;
          if ((in_shift_reg(address_buffer'left) /= write_value_g) and
              (unsigned(in_shift_reg(address_width_g-1 downto 0)) < to_unsigned(start_burst_adresses_g-1, address_width_g)))
          then
            address_buffer <= unsigned(in_shift_reg(address_buffer'range)) + 1;
          else
            address_buffer <= unsigned(in_shift_reg(address_buffer'range));
          end if;
        elsif to_integer(address_buffer(address_width_g-1 downto 0)) < start_burst_adresses_g then
          address_buffer <= address_buffer + 1;
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------
  -- Adress buffer controll. Saves the adress for later use
  ---------------------------------------------------------

  process (clk, spi_rst_n)              -- Read process
  begin  -- process
    if spi_rst_n = '0' then             -- asynchronous reset (active low)
      in_shift_reg   <= (others => '0');
      valid_data     <= '0';
      rd_bit_counter <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ((rd_bit_counter = address_width_g and state = address_part) or
          (rd_bit_counter = data_width_g-1 and state = last))
      then
        valid_data     <= '1';
        rd_bit_counter <= 0;
      else
        valid_data     <= '0';
        rd_bit_counter <= rd_bit_counter + 1;
      end if;
      in_shift_reg <= in_shift_reg(in_shift_reg'left-1 downto 0) & mosi;
    end if;
  end process;


  -- purpose: write shift register
  -- type   : sequential
  -- inputs : clk, rst
  -- outputs: 
  process (nclk, spi_rst_n)
  begin  -- process
    if spi_rst_n = '0' then               -- asynchronous reset (active low)
      out_shift_reg  <= cc_constant;
      wr_bit_counter <= 0;
      first_byte     <= true;
    elsif nclk'event and nclk = '1' then  -- falling clock edge      
      if wr_bit_counter = 0 and first_byte then
        out_shift_reg <= cc_constant;
        first_byte    <= false;
      elsif ((wr_bit_counter = address_width_g and state = address_part) or
             (wr_bit_counter = data_width_g-1 and state /= address_part))
      then
        out_shift_reg(data_width_g-2 downto 0) <= data_in(data_width_g-2 downto 0);
      else
        first_byte                                     <= false;
        out_shift_reg(out_shift_reg'length-1 downto 0) <= out_shift_reg(out_shift_reg'length-2 downto 0)&'0';
      end if;

      if (((wr_bit_counter = address_width_g) and state = address_part) or
          ((wr_bit_counter = data_width_g-1) and state = last))
      then
        wr_bit_counter <= 0;
      else
        wr_bit_counter <= wr_bit_counter + 1;
      end if;

      if first_byte then
        miso_temp <= '0';
      elsif wr_bit_counter = 15 and state = address_part then
        miso_temp <= data_in(data_width_g-1);
      else
        miso_temp <= out_shift_reg(data_width_g-2);
      end if;
    end if;
  end process;

end rtl;
