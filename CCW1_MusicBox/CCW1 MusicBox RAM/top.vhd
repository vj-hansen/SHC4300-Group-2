----------------------------------------------------------------------------------
-- Top design module
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port ( 
        clk, rst, rx: in std_logic;
        play: in std_logic;
        led: out std_logic_vector(7 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0);
        audio_out: out std_logic
        );
end top;

architecture Behavioral of top is
    signal s_tick, rx_done_tick :   std_logic;                      -- Signals for baud generator and UART
    signal dout, abus, ram_data:    std_logic_vector(7 downto 0);   -- Data signals
    signal wr_en, td_done, td_on:   std_logic;                      -- 
    signal m_in:                    std_logic_vector(17 downto 0);  -- ASCII code converted
    signal t_in, clr_FF:            std_logic;                      -- Signals for loudspeaker

----------------------------------------------------------------------------------
begin

------------------------------------------------------------
-- FSM control unit
    FSM_Controler: entity work.fsm_controller(arch)
        port map (  clk=>clk, rst=>rst, play=>play, from_dout=>dout,
                    from_rx_done_tick=>rx_done_tick, to_abus=>abus, 
                    to_wr_en=>wr_en,from_rdbus=>ram_data, 
                    to_td_on=>td_on, from_td_done=>td_done,
                    to_clr_FF=>clr_FF, to_led=>led);
------------------------------------------------------------
-- Baud rate generator for UART
    Baud_Generator: entity work.baud_generator(arch)
        port map (  clk=>clk, rst=>rst, to_s_tick=>s_tick);
------------------------------------------------------------
-- UART
    UART: entity work.uart(arch)
        port map (  clk=>clk, rst=>rst, rx=>rx,
                    from_s_tick=>s_tick, to_dout=>dout,
                    to_rx_done_tick=>rx_done_tick);
------------------------------------------------------------
-- Single port RAM
    RAM: entity work.ram(arch)
        port map (  clk=>clk, we=>wr_en, addr=>abus,
                    wrbus=>dout, rdbus=>ram_data);
------------------------------------------------------------
-- Dealy timer
    Timer: entity work.timer(arch)
        port map (  clk=>clk, rst=>rst, from_td_on=>td_on,
                    to_td_done=>td_done);
------------------------------------------------------------
-- Code conversion
    Code_Converter: entity work.code_converter(arch)
        port map (  from_dout=>ram_data, to_m_in=>m_in);
------------------------------------------------------------
-- Mod-M counter
    Mod_M_Counter: entity work.mod_m(arch)
        port map (  clk=>clk, rst=>rst, from_m_in=>m_in, 
                    to_t_in=>t_in);
------------------------------------------------------------
-- Loudspeaker
    T_FF: entity work.t_ff(arch)
        port map (  clk=>clk, rst=>rst, from_t_in=>t_in,
                    from_clr_FF=>clr_FF, to_ldspkr=>audio_out);
------------------------------------------------------------
-- ASCII to 7-segment
    ASCII_To_7SEG: entity work.ascii2sseg(arch)
        port map (  anode=>anode, sseg=>sseg, from_dout=>dout);
------------------------------------------------------------
    
end Behavioral;