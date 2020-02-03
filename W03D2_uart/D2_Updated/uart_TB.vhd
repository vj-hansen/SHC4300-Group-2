-- Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_tb is
end UART_tb;

architecture Behavioral of UART_tb is
    signal clk, rst: std_logic := '1';
    signal rx: std_logic;
    signal led: std_logic_vector(7 downto 0);
    
    constant rx_data: std_logic_vector(7 downto 0) := "00110011"; -- send 3
    constant clk_period : time := 10 ns;
    constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    
begin
    UUT: entity work.top(Behavioral)
    generic map (
        -- 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
        DBIT => 8,      -- data bits
        SB_TICK => 16,  -- ticks for 1 stop bit
        DVSR => 326,    -- baud rate divisor DVSR = 100MHz/(16*baud rate)
        DVSR_BIT => 9   -- bits f DVSR
    )
    port map (
        clk => clk, rst => rst,
        rx => rx, led => led);
     
    clk_proc: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process begin
        rst <= '1';
        rx <= '0';
        wait for clk_period*2;
        rst <= '0';
        --rx <= '1';
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_data(i);
            wait for bit_period;
        end loop;
        rx <= '1';
        wait;
    end process;
end Behavioral;
