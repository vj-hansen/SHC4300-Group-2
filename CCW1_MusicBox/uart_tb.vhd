-- Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_tb is
end UART_tb;

architecture Behavioral of UART_tb is
    signal clk, reset : std_logic := '1';
    signal rx : std_logic;
    signal dout: std_logic_vector(7 downto 0);
    signal rx_done_tick : std_logic;
    
    constant rx_data: std_logic_vector(7 downto 0) := "10110011";
    constant clk_period : time := 10 ns;
    constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    
begin
    UUT: entity work.uart_rx(arch)
    generic map (
        -- 19,200 baud, 8 data bits, 1 stop bit
        DBIT => 8,      -- data bits
        SB_TICK => 16,  -- ticks for 1 stop bit
        DVSR => 326,    -- baud rate divisor DVSR = 100MHz/(16*baud rate)
        DVSR_BIT => 9 )  -- bits of DVSR

    port map ( clk=>clk, reset=>reset, 
               rx=>rx, dout=>dout,
               rx_done_tick=>rx_done_tick);
     
    clk_proc: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process begin
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        rx <= '0'; -- start bit = 0
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_data(i); -- 8 data bits
            wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit = 1
        wait;
    end process;
end Behavioral;
