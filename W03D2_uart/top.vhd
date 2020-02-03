----------------------------------------------------------------------------------
-- Module Name: top - Behavioral
-- Target Devices: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
---------------------------------------------------------
entity top is
    generic (
        -- 19200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
        DBIT : integer := 8;
        SB_TICK : integer := 16; -- 16 ticks for 1 stop bit
        DVSR : integer := 326;  -- baud rate divisor
                                -- DVSR = 100M/(16*baud rate)
        DVSR_BIT : integer := 9; -- bits of DVSR
        FIFO_W : integer := 2 );   -- address bits of FIFO, words in FIFO = 2^FIFO_W
    
    port ( 
        clk, rst : in std_logic;
        rd_uart, wr_uart, rx : in std_logic;
        w_data : in std_logic_vector(7 downto 0);
        led : out std_logic_vector(7 downto 0) );
end top;
---------------------------------------------------------
architecture Behavioral of top is
    signal tick, rx_done_tick : std_logic;
    signal rx_data_out : std_logic_vector(7 downto 0);
begin
---------------------------------------------------------
    baud_gen_unit: entity work.mod_m(arch)
        generic map (M=>DVSR, N=>DVSR_BIT)
        port map (clk=>clk, rst=>rst, 
            q=>open, max_tick=>tick); -- 'open'-keyword = q is an unused signal
---------------------------------------------------------
    uart_rx_unit: entity work.uart_rx(arch)
        generic map (DBIT=>DBIT, SB_TICK=>SB_TICK)
        port map (clk=>clk, rst=>rst, rx=>rx,
            s_tick=>tick, rx_done_tick=>rx_done_tick,
            dout=>rx_data_out);
---------------------------------------------------------
   -- fifo_rx_unit: entity work.fifo_buf(arch)
      --  generic map (B=>DBIT, W=>FIFO_W)
    --    port map (clk=>clk, rst=>rst, rd=>rd_uart,
  --          wr=>rx_done_tick, w_data=>rx_data_out,
--            empty=>rx_empty, full=>open, r_data=>r_data);
---------------------------------------------------------
    process(rx_done_tick) begin
        if (rx_done_tick='1') then
            led <= rx_data_out;
        end if;
    end process;  
end Behavioral;
