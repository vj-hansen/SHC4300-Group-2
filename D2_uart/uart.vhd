----------------------------------------------------------------------------------
-- Engineer: Victor
-- 
-- Design Name: 
-- Module Name: uart - Behavioral
-- Project Name: 
-- Target Devices: Basys 3
-- Description: 
----------------------------------------------------------------------------------
-- listing 7.1, 7.2, 7.4 (top level)
-- UART receiver

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------
entity uart_rx is
    generic (
        DBIT : integer := 8; -- data bits
        SB_TICK : integer := 16 ); -- ticks for stop bits

    Port ( 
        clk, rst : in std_logic;
        rx, s_tick : in std_logic;
        rx_done_tick : out std_logic;
        dout : out std_logic_vector(7 downto 0) );
end uart_rx;
------------------------------------------------------------
architecture Behavioral of uart_rx is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type; -- current and next state
    signal s_reg, s_next : unsigned(3 downto 0); -- keep track of sampling ticks and count to 7 in the 'start' state
    signal n_reg, n_next : unsigned(2 downto 0); -- keep track of data bits received in the 'data' state
    signal b_reg, b_next : std_logic_vector(7 downto 0); -- retrieved bits are shifted into and reassembled in the 'b' register
begin
------------------------------------------------------------
-- FSMD state and data registers
    process(clk, rst) begin
        if rst = '1' then
            state_reg <= idle;
            s_reg <= (others => '0');
            n_reg <= (others => '0');
            b_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;
------------------------------------------------------------    
-- next-state logic and data path functional routing
    process(state_reg, s_reg, n_reg, b_reg, s_tick, rx)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= '0';
        case state_reg is 
            when idle =>
                if rx='0' then
                    state_next <= start;
                    s_next <= (others=>'0');
                end if;
------------------------------------------------------------                
            when start =>
                if (s_tick = '1') then
                    if s_reg=7 then
                        state_next <= data;
                        s_next <= (others=>'0');
                        n_next <= (others=>'0');
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------                
            when data =>
                if (s_tick = '1') then
                    if s_reg=15 then
                        s_next <= (others => '0');
                        b_next <= rx & b_reg(7 downto 1);
                        if n_reg=(DBIT-1) then
                            state_next <= stop;
                        else
                            n_next <= n_reg+1;
                        end if;
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------
            when stop =>
                if (s_tick = '1') then
                    if s_reg=(SB_TICK-1) then
                        state_next <= idle;
                        rx_done_tick <= '1';
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
        end case;
    end process;
    dout <= b_reg;
end Behavioral;