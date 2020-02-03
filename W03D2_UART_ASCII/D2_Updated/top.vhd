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
        -- 19200 baud, 8 data bits, 1 stop bit
        DBIT : integer := 8;
        SB_TICK : integer := 16; -- 16 ticks for 1 stop bit
        DVSR : integer := 326;  -- baud rate divisor, DVSR = 100M/(16*baud rate)
        DVSR_BIT : integer := 9 -- bits of DVSR
        );
    port ( 
        clk, rst, rx : in std_logic;
        led : out std_logic_vector(7 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0)
        );
end top;
---------------------------------------------------------
architecture Behavioral of top is
    signal tick, rx_done_tick : std_logic;
    signal rx_data_out : std_logic_vector(7 downto 0);
begin
---------------------------------------------------------
    mod_m_unit: entity work.mod_m(arch)
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
    ascii2sseg_unit: entity work.ascii2sseg(arch)
        port map (anode=>anode, sseg=>sseg, ascii_code=>rx_data_out);
---------------------------------------------------------
    process(rx_done_tick) begin
        if (rx_done_tick='1') then
            led <= rx_data_out;
        end if;
    end process;  
end Behavioral;
