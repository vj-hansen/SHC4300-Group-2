----------------------------------------------------------------------------------
-- Top design module
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port ( 
        clk, rst, rx: in std_logic;
        led: out std_logic_vector(7 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0);
        audio_out: out std_logic
        );
end top;

architecture Behavioral of top is
    signal s_tick, rx_done_tick :   std_logic;                      -- Signals for baud generator and UART
    signal dout :                   std_logic_vector(7 downto 0);   -- data
    signal m_in :                   std_logic_vector(17 downto 0);  -- ASCII code converted
    signal t_in, clr_FF :           std_logic;                      -- Signals for toggle unit

----------------------------------------------------------------------------------
begin
-- FSM control unit
    FSM_Controller: entity work.fsm_control_path(arch)
        port map (clk=>clk, rst=>rst, from_dout=>dout,
                  from_rx_done_tick=>rx_done_tick, 
                  to_clr_FF=>clr_FF, to_led=>led);
------------------------------------------------------------
-- Baud rate generator for UART communication unit
    Baud_Generator: entity work.baud_generator(arch)
        port map (clk=>clk, rst=>rst, to_s_tick=>s_tick);
------------------------------------------------------------
-- UART to Basys3 board communication unit
    UART: entity work.uart_rx(arch)
        port map (clk=>clk, rst=>rst, rx=>rx,
                  from_s_tick=>s_tick, to_rx_done_tick=>rx_done_tick,
                  to_dout=>dout);
------------------------------------------------------------
-- Code conversion unit
    Code_Converter: entity work.code_converter(arch)
        port map (from_dout=>dout, to_m_in=>m_in); -- For RAM: from_dout => ram_data
------------------------------------------------------------
-- Mod-M counter unit
    Mod_M_Counter: entity work.mod_m(arch)
        port map (clk=>clk, rst=>rst, from_m_in=>m_in, 
                  to_t_in=>t_in);
------------------------------------------------------------
-- Loudspeaker unit
    T_FF: entity work.t_ff(arch)
        port map (clk=>clk, rst=>rst, from_t_in=>t_in,
                  from_clr_FF=>clr_FF, to_ldspkr=>audio_out);
------------------------------------------------------------
-- ASCII to 7-segment conversion unit
    ASCII_To_7SEG: entity work.ascii2sseg(arch)
        port map (anode=>anode, sseg=>sseg, from_dout=>dout);
------------------------------------------------------------

end Behavioral;
