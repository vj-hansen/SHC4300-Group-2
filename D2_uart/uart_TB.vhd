-- Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_tb is
end UART_tb;

architecture Behavioral of UART_tb is
    -- Internal signals
    signal clk, rst: std_logic := '1';
    --signal rd_uart: std_logic;
    signal rx: std_logic;
    --signal rx_empty: std_logic;
    signal led: std_logic_vector(7 downto 0);
    constant rx_data: std_logic_vector(7 downto 0) := "10110011";
    
begin
    -- Unit under test
    UUT: entity work.top(Behavioral)
    generic map
    (
        -- Default setting:
        -- 19,200 baud, 8 data bis, 1 stop its, 2^2 FIFO
        DBIT => 8,       -- # data bits
        SB_TICK => 16,   -- # ticks for stop bits, 16/24/32 for 1/1.5/2 stop bits
        DVSR => 326,    -- baud rate divisor DVSR = 100M/(16*baud rate)
        DVSR_BIT => 9,   -- # bits of DVSR
        FIFO_W => 2      -- # addr bits of FIFO. # words in FIFO = 2^FIFO_W
    )
    port map
    (
        clk => clk,
        rst => rst,
        rd_uart => '1',
        wr_uart => '0',
        rx => rx,
        w_data => (others => '0'),
        --tx_full => open,
        --rx_empty => open,
        led => led
        --tx => open
    );
    
    -- Stim proc
    clk <= not clk after 5ns;
     
    process begin
        wait for 10ns;
        rst <= '0';
        wait;
    end process;
    
    process begin
        wait for 10ns;
        rx <= '0';
        wait for 52083ns;
        for i in 0 to 7 loop
            rx <= rx_data(i);
            wait for 52083ns;
        end loop;
        rx <= '1';
        wait;
    end process;
end Behavioral;