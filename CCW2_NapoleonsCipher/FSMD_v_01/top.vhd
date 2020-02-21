-- top design module

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------
entity top is
    port ( rx, clk, reset, mode : in STD_LOGIC;
            c_i : out std_logic_vector(7 downto 0) );
    end top;
----------------------------------------------------------
architecture Behavioral of top is
    signal tick, rx_done_tick, wr_en : std_logic; 
    signal dout : std_logic_vector(7 downto 0);
    signal k_i : std_logic_vector(7 downto 0);
    signal abus : std_logic_vector(11 downto 0);
    signal ram_data : std_logic_vector(7 downto 0);
begin 
----------------------------------------------------------
    baud_gen_unit : entity work.baud_rate_generator(arch)
        port map ( clk=>clk, reset=>reset, q=>open, max_tick=>tick );
-----------------------------------------------------------
    uart_rx_unit: entity work.uart_rx(arch)
        port map ( clk=>clk, reset=>reset, from_rx=>rx,
                   s_tick=>tick, to_rx_done_tick=>rx_done_tick, 
                   to_dout=>dout ); 	
-------------------------------------------------------------------		
    fsm_unit: entity work.FSM(arch)
        port map ( from_mode=>mode, from_rx_done_tick=>rx_done_tick,
                   from_dout=>dout, to_abus=>abus, to_wr_en=>wr_en, 
                   from_rdbus=>ram_data, reset=>reset, clk=>clk );
-------------------------------------------------------------------
    RAM_unit: entity work.RAM(arch)
        port map ( clk=>clk, we=>wr_en, addr=>abus, wrbus=>dout, rdbus=>ram_data );
-------------------------------------------------------------------	  
    encoder_unit: entity work.encoder(arch)
        port map (msg_in=>ram_data, cipher_out=>c_i);
-------------------------------------------------------------------	
end Behavioral;