----------------------------------------------------------------------------------
-- Listing 11.1
-- Single-port RAM with synchronous read
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram is
    generic(
        ADDR_WIDTH: integer:=8;
        DATA_WIDTH: integer:=8
    );
    
    port ( 
        clk:    in std_logic;
        we:     in std_logic;
        addr:   in std_logic_vector(ADDR_WIDTH-1 downto 0);
        wrbus:  in std_logic_vector(DATA_WIDTH-1 downto 0);
        rdbus:  out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end ram;

architecture arch of ram is
    type ram_type is array (2**ADDR_WIDTH-1 downto 0)
        of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal ram: ram_type;
    signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);

----------------------------------------------------------------------------------
begin
    -- register
    process (clk) begin
        if rising_edge(clk) then
          if (we='1') then
             ram(to_integer(unsigned(addr))) <= wrbus;
             end if;
         addr_reg <= addr;
        end if;
    end process;
    
    -- output
    rdbus <= ram(to_integer(unsigned(addr_reg)));

end arch;
