----------------------------------------------------------------------------------
-- Listing 4.11 Mod-m counter
-- This baud-rate generator will generate sampling ticks

-- Frequency = 16x the required baud rate (16x oversampling)
-- 19200 bps * 16 = 307200 ticks/s (UART baud rate * oversampling)
-- 100 MHz / 307200 = 325.52 = 326 (Basys 3 board clock / ticks = mod-counter)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity baud_generator is
    generic (
        N: integer := 9; -- number of bits needed to count to M.
        M: integer := 326 -- mod-326 counter 
        ); 
    port ( 
        clk, rst: in std_logic;
        to_s_tick: out std_logic
        );
end baud_generator;

architecture arch of baud_generator is
    signal r_reg, r_next: unsigned(N-1 downto 0);

----------------------------------------------------------------------------------
begin
    -- register
    process(clk, rst) 
    begin
        if (rst = '1') then
            r_reg <= (others =>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next-state logic
    r_next <= (others => '0') when r_reg=(M-1) 
        else r_reg+1;
    
    -- output logic
    to_s_tick <= '1' when r_reg=(M-1) else '0';
end arch;
