----------------------------------------------------------------------------------
-- Listing 4.11 Mod-m counter
-- This counter will generate sampling ticks for tones
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_m is
    generic (
        N: integer := 19; -- num of bits from code converter
        M: integer := 200000 -- mod-200k
        );  
   
    port ( 
        clk, rst: in std_logic;
        from_m_in: in std_logic_vector(17 downto 0);
        to_t_in: out std_logic
        );
end mod_m;

architecture arch of mod_m is
    signal r_reg, r_next: unsigned(N-1 downto 0) := (others => '0');

----------------------------------------------------------------------------------
begin
    -- register
    process(clk, rst) begin
        if (rst = '1') then
            r_reg <= (others =>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;

    -- next-state logic
    r_next <=   (others => '0') when r_reg=(M-1) else 
                r_reg+1;
    
    -- output logic
    to_t_in <= '1' when r_reg = (unsigned(from_m_in)-1) else '0';


end arch;
