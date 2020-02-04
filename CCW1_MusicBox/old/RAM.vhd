-- Listing 11.4
-- Dual-port RAM with synchronous read

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------
entity dual_port_ram_sync is
   generic (  ADDR_WIDTH: integer := 6;
              DATA_WIDTH: integer := 8 );
   
   port ( clk, we:   in std_logic;
          addr_a:    in std_logic_vector(ADDR_WIDTH-1 downto 0);
          addr_b:    in std_logic_vector(ADDR_WIDTH-1 downto 0);
          din_a:     in std_logic_vector(DATA_WIDTH-1 downto 0);
          dout_a:    out std_logic_vector(DATA_WIDTH-1 downto 0);
          dout_b:    out std_logic_vector(DATA_WIDTH-1 downto 0) );
end dual_port_ram_sync;
--------------------------------------------------
architecture arch of dual_port_ram_sync is
   type ram_type is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal ram: ram_type;
   signal addr_a_reg, addr_b_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
--------------------------------------------------
begin
   process(clk) begin
     if rising_edge(clk) then
        if (we = '1') then
           ram(to_integer(unsigned(addr_a))) <= din_a;
        end if;
        addr_a_reg <= addr_a;
        addr_b_reg <= addr_b;
     end if;
   end process;
   dout_a <= ram(to_integer(unsigned(addr_a_reg)));
   dout_b <= ram(to_integer(unsigned(addr_b_reg)));
end arch;