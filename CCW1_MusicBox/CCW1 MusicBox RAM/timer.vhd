----------------------------------------------------------------------------------
-- 0.5 sec Simple counter
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    generic (
        N: integer := 17; -- num of bits from code converter
        M: integer := 50000 -- mod-50k (count 50k pulses)  -- 50,000 = 500 us. 
                -- We need 100 MHz * 0.5 sec = 50 M clock cycles
        ); 
   
    port ( clk, rst:   in std_logic;
           from_td_on: in std_logic;
           to_td_done: out std_logic );
end timer;

architecture arch of timer is
signal r_reg, r_next: unsigned (N-1 downto 0):= (others => '0');
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
    r_next <=   (others => '0') when from_td_on = '0' else
                (others => '0') when r_reg = (M) else
                r_reg+1;
    
    -- output logic
    to_td_done <= '1' when r_reg = (M) else '0';
end arch;
