--- ROM
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------
entity unsort_rom is
   port(  addr: in std_logic_vector(4 downto 0);
          data: out std_logic_vector(7 downto 0) );
end unsort_rom;
-------------------------------------------------------
architecture arch of unsort_rom is
   constant ADDR_WIDTH: integer := 4;
   constant DATA_WIDTH: integer := 8;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   
   -- ROM definition
   -- Generate numbers between 0-255:
   --   https://www.random.org/bytes/
   constant unsorted_ROM: rom_type := ( -- 2^4-by-8
    X"3f", --addr 00 
    X"3b", --addr 01  
    X"3c", --addr 02   
    X"3e", --addr 03  
    X"c6", --addr 04 
    X"90", --addr 05 
    X"38", X"88", X"fc", 
    X"3c", X"69", X"54", 
    X"1b", X"3f",X"b1", X"b6"); --... addr 15
-------------------------------------------------------
begin
   data <= unsorted_ROM(to_integer(unsigned(addr)));
end arch;