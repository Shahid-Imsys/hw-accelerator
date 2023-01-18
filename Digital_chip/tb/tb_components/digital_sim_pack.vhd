library ieee;
use ieee.std_logic_1164.all;

use std.textio.all;

package digital_top_sim_pack is


  -----------------------------------------------------------------------------
  -- Adresses to register in the TB
  -----------------------------------------------------------------------------

  -- TB controller (UART)
  constant tb_short_message_1 : integer := 0;
  constant tb_short_message_2 : integer := 1;
  constant tb_write           : integer := 2;
  constant tb_noctest         : integer := 3;

  -- constant tb_read            : integer := 0;

  constant tb_debug_command : integer := 8;


  -- Debug commnds for debug interface
  constant tb_debug_command_start_exe : std_ulogic_vector(7 downto 0) := x"01";

  type reg_to_block_t is record
    address   : integer;
    byte      : integer;
    read_data : boolean;
    data      : std_ulogic_vector(7 downto 0);
  end record reg_to_block_t;

  subtype reg_from_block_t is std_logic_vector(7 downto 0);

  procedure decode_error_code (core: string; error_code : in integer);
end digital_top_sim_pack;

package body digital_top_sim_pack is

  procedure write_code (core: string; message : string) is
    variable l : line;
  begin
    write(l, core & " ");
    write(l, message);
    writeline(output, l);
  end procedure write_code;

  procedure decode_error_code (core: string; error_code : in integer) is
  begin  -- procedure decode_error_code
    case error_code is

      when 16#09# => write_code(core, "GPORTS-1");  --Number of General Bidirectional Ports

                     --when 16#01# => write_code(core, "POP_ERR");         --Error code for POP from empty stack
                     --when 16#02# => write_code(core, "PSH_ERR");         --Error code for PUSH onto full stack
                     --when 16#03# => write_code(core, "PLS_ERR");         --Error code for PLUS1 error destination

                     --when 16#01# => write_code(core, "SETALLRAS");

                     --when 16#10#");        MEM_ERR:

      --Dsource error in unit: dsl.vhd
      when 16#11# => write_code(core, "DATA0FZ_ERR");  --DATA0 and Flag_zero error
      when 16#12# => write_code(core, "DCONST_ERR");  --Dsource constant error
      when 16#13# => write_code(core, "LDORET_ERR");  --Do and Return error

      --Clk request errors, not using in current testprogram version
      when 16#15# => write_code(core, "CLKREQ_TIME_ERR");
      --when 16#16..17  CLKREQ_TIME_ERRx");
      when 16#1A# => write_code(core, "CLKREQ_DEC_ERR");
      when 16#1F# => write_code(core, "CLKREQ_ERR");

      --Sequencer error in unit: clc.vhd
      when 16#20# => write_code(core, "ENDDEC_ERR");
      when 16#21# => write_code(core, "SEQ_DORET_ERR");  --CLC Do and Return error
      when 16#22# => write_code(core, "SEQ_CTR_ERR");    --CLC counter error
      when 16#23# => write_code(core, "SEQ_COND_ERR");   --CLC condition error
      when 16#24# => write_code(core, "SEQ_SKIP_ERR");   --CLC skip error
      when 16#25# => write_code(core, "SEQ_YDEC_ERR");

      --ALU errors in unit: alu.vhd
      when 16#30# => write_code(core, "ALU_REG_ERR");   --ALU register error
      when 16#41# => write_code(core, "ALU_SHR_ERR");   --ALU right shift error
      when 16#52# => write_code(core, "ALU_SHL_ERR");   --ALU left shift error
      when 16#63# => write_code(core, "ALU_YREG_ERR");  --ALU Y register error

      --GMEM error in unit: gmem.vhd
      when 16#40# => write_code(core, "GMEM_RW_ERR");  --G memory read/write error

      --MBM errors in unit: mbm.vhd
      when 16#50# => write_code(core, "MBM_MISC_ERR");   --MBM
      when 16#51# => write_code(core, "MBM_MUL_ERR");    --MBM multiplier error
      --when 16#52# => write_code(core, "MBM_SHIFT_ERR");  --MBM shift function error

      --I/O interface and peripherals error: Not using for now
      when 16#60# => write_code(core, "GPORT_ERR");  --General I/O error
      when 16#64# => write_code(core, "IOS_ERR");  --I/O interface controller error
      when 16#65# => write_code(core, "RTC_ERR");  --RTC error
      when 16#66# => write_code(core, "DMA_ERR");  --DMA error
      when 16#67# => write_code(core, "UART_ERR");   --UART error
      when 16#68# => write_code(core, "ETH_ERR");  --Ethernet error


      when 16#70# => write_code(core, "SP_LOAD_ERR");
      when 16#71# => write_code(core, "SELF_LOAD_ERR");

      when 16#81# => write_code(core, "DRAM_TST1");
      when 16#82# => write_code(core, "DRAM_TST2");
      when 16#83# => write_code(core, "DRAM_TST3");
      when 16#84# => write_code(core, "DRAM_TST4");

      --RAM aaddress steping error: mmr.vhd
      when 16#90# => write_code(core, "ADHP_ERR");
      when 16#94# => write_code(core, "ADLSTEP_ERR");

                     --when 16#9#5 => write_code(core, "STP+1_ERR");
                     --when 16#96# => write_code(core, "STP+2_ERR");
                     --when 16#97# => write_code(core, "STP-1_ERR");
                     --when 16#98# => write_code(core, "STP-2_ERR");
                     --when 16#99# => write_code(core, "STP+1GW_ERR");
                     --when 16#9A# => write_code(core, "STP-1GW_ERR");
                     --when 16#XX# => write_code(core, "STP+2GW_ERR");
                     --when 16#XX# => write_code(core, "STP-2GW_ERR");

      --Error of Fast data transfer between memory function: not using in current testprogram
      when 16#A0# => write_code(core, "FASTMEM_ERR");
      when 16#A1# => write_code(core, "FAST_RD_ERR");
      when 16#A2# => write_code(core, "FAST_WR_ERR");

                     --when 16#A3# => write_code(core, "CORE1");

      when 16#A4# => write_code(core, "CORE2_TST_END");  --Core2 test complete code

      when 16#0F# => write_code(core, "DERAILED");  --Microprogram derailed error
                     --
                     --when 16#00# => write_code(core, "ADL+1STEP");
                     --when 16#40# => write_code(core, "ADL-1STEP");
                     --when 16#80# => write_code(core, "ADL+1GWSTEP");
                     --when 16#C0# => write_code(core, "ADL-1GWSTEP");
                     --when 16#20# => write_code(core, "ADL+2STEP");
                     --when 16#60# => write_code(core, "ADL-2STEP");
      --OSPI Memory test error label:
      when 16#A5# => write_code(core, "SET_LATENCY_ERR");
      when 16#A6# => write_code(core, "OSPI_RW_ERR");
      when 16#A7# => write_code(core, "OSPI_AUTO_INC_ERR");
      when 16#A8# => write_code(core, "OSPI_BURST_RW_ERR");

      --Memory test error label:
      when 16#B0# => write_code(core, "GR_ERR");  --G memory GR part read/write error
      when 16#B1# => write_code(core, "SB_ERR "); --G memory SB part read/write error
      when 16#B2# => write_code(core, "MS_ERR");  --G memory MSTACK part read/write error
      when 16#B3# => write_code(core, "PS_ERR");  --G memory PSTACK part read/write error
      when 16#B4# => write_code(core, "GR_ERR_CB ");
      when 16#B5# => write_code(core, "SB_ERR_CB");
      when 16#B6# => write_code(core, "MS_ERR_CB");
      when 16#B7# => write_code(core, "PS_ERR_CB");
      when 16#B8# => write_code(core, "GR_ERR_INC ");
      when 16#B9# => write_code(core, "SB_ERR_INC");
      when 16#BA# => write_code(core, "MS_ERR_INC");
      when 16#BB# => write_code(core, "PS_ERR_INC");

      when 16#BC# => write_code(core, "BMEM_ERR");  --Bettery memory read/write error
      when 16#BD# => write_code(core, "BMEM_ERR_CB");
      when 16#BE# => write_code(core, "BMEM_ERR_INC");

      when 16#BF# => write_code(core, "RAM0_ERR");  --RAM0 read/write error
      when 16#C0# => write_code(core, "RAM_ERR");   --RAM1-4 read/write error
      when 16#C1# => write_code(core, "IOMEM_ERR");  --IO memory read/write error


      --Memory test status code
      when 16#C2# => write_code(core, "GMEM: all test task end");
      when 16#C3# => write_code(core, "BMEM: all test task end");
      when 16#C4# => write_code(core, "RAM0: all test task end");
      when 16#C5# => write_code(core, "RAM: all test task end");
      --when 16#C6# => write_code(core, "IOMEM_TASK_END");   --RAM1-4 read/write error

      when 16#CA# => write_code(core, "GMEM zero-one test begin");
      when 16#CB# => write_code(core, "GMEM checkerboard test begin");
      when 16#CC# => write_code(core, "GMEM increment test begin");
      when 16#CD# => write_code(core, "BMEM zero-one test begin");
      when 16#CE# => write_code(core, "BMEM checkerboard test begin");
      when 16#CF# => write_code(core, "BMEM increment test begin");

      when 16#E0# => write_code(core, "NOC boot code upload request");

      when 16#F0# => write_code(core, "RAM0 test begin");
      when 16#F1# => write_code(core, "RAM test begin");

      when 16#D0# => write_code(core, "Core test done");
      when 16#D1# => write_code(core, "Memory Test done");
      when 16#D2# => write_code(core, "Test 2 done");
      when 16#D3# => write_code(core, "Test 3 done");
      when 16#D4# => write_code(core, "Test 4 done");
      when 16#D5# => write_code(core, "Test 5 done");
      when 16#D6# => write_code(core, "Test 6 done");
      when 16#D7# => write_code(core, "Test 7 done");
      when 16#D8# => write_code(core, "Test 8 done");
      when 16#D9# => write_code(core, "Test 9 done");

      when 16#DE# =>
        write_code(core, "Simulation finshed OK");
        std.env.stop(0);
      when 16#DF# => report "Simulation FAILED" severity failure;

      when others => write_code(core, "Unknown message!" & integer'image(error_code));
    end case;
  end procedure decode_error_code;

end package body digital_top_sim_pack;
