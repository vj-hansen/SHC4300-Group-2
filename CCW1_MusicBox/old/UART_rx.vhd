-- UART receiver + baud rate generator component

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
--------------------------------------------
entity uart_rx is
    generic ( DBIT      : integer := 8;
              SB_TICK   : integer := 16;
              DVSR      : integer := 326;
              DVSR_BIT  : integer := 9 );
           
    Port (  rx      : in STD_LOGIC;
            clk     : in STD_LOGIC;
            reset   : in STD_LOGIC;
            dout    : out std_logic_vector(7 downto 0);
            rx_done_tick : out STD_LOGIC );
end uart_rx;
--------------------------------------------
architecture arch of uart_rx is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type;
    signal s_reg, s_next : unsigned(3 downto 0); -- sampling ticks 
    signal n_reg, n_next : unsigned(2 downto 0); -- data bits received
    signal b_reg, b_next : std_logic_vector(7 downto 0); 
    signal s_tick : std_logic;
begin
--------------------------------------------
    baud_gen_unit: entity work.baud_gen(arch)
        generic map ( M=>DVSR, N=>DVSR_BIT )
        port map ( clk=>clk, reset=>reset, 
                   q=>open, max_tick=>s_tick );
--------------------------------------------
-- FSMD state and data registers
    process(clk, reset) begin
        if (reset = '1') then
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
                if (rx = '0') then
                    state_next <= start;
                    s_next <= (others=>'0');
                end if;
------------------------------------------------------------                
            when start =>
                if (s_tick = '1') then
                    if (s_reg = 7) then -- restart counter
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
                    if (s_reg = 15) then -- read RxD, feed its value to deserializer, restart counter
                        s_next <= (others => '0');
                        b_next <= rx & b_reg(7 downto 1); -- b = rx & (b >> 1)
                        if (n_reg = (DBIT-1)) then
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
                    if (s_reg = (SB_TICK-1)) then
                        state_next <= idle;
                        rx_done_tick <= '1';
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
        end case;
    end process;
    dout <= b_reg; -- data out -- rx data out
end arch;
