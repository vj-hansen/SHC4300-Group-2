----------------------------------------------------------------------------------
-- FSM control path
-- Group 2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_control_path is
    port ( 
        clk, rst: in std_logic;
        from_rx_done_tick: in std_logic;
        from_dout : in std_logic_vector(7 downto 0);
        to_clr_FF: out std_logic;
        to_led: out std_logic_vector(7 downto 0)
        );
end fsm_control_path;
------------------------------------------------------------------------ 
architecture arch of fsm_control_path is
    -- FSM declaration
    type state_type is (mute, play);
    signal state_next, state_reg: state_type;
    signal valid_value: std_logic_vector(7 downto 0); -- Valid ASCII value
----------------------------------------------------------------------------------
begin
    -- FSM state register
    process(clk, rst) begin
        if (rst = '1') then
            state_reg <= mute;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
    end process;

    -- next state and output logic
    process(state_reg, from_rx_done_tick, from_dout)
        begin
        state_next <= state_reg;
        to_clr_FF <= '0';
        
        case state_reg is
        ------------------------------------------------------------                
            when mute =>
                -- Initial setup
                to_clr_FF <= '1';
                -- Decisions
                if (from_rx_done_tick = '1' ) then       -- All data received from UART
                    if (from_dout = valid_value) then    -- Check if ASCII code is valid
                        state_next <= play;
                    else
                        state_next <= mute;             -- If ASCII is not valid, mute
                    end if;
                else
                    state_next <= mute;
                end if;
            ------------------------------------------------------------                
            when play =>
                -- Initial setup: If ASCII is valid toggle mod-m counter
                -- Decisions
                if (from_rx_done_tick = '1' ) then
                    if (from_dout = valid_value) then    -- Check if ASCII code is valid
                        state_next <= play;
                    else
                        state_next <= mute;             -- If ASCII is not valid, mute
                    end if;
                else
                    state_next <= play;
                end if;
            ------------------------------------------------------------                
        end case;
    end process;
------------------------------------------------------------------------                
    -- Dispaly ASCII from UART on Basys3 LEDs
    process(from_rx_done_tick) begin
        if (from_rx_done_tick = '1') then
            to_led <= from_dout;
        end if;
    end process;  
------------------------------------------------------------------------              
    with from_dout select
        valid_value <=   
            -- Octave 4
            "01000011" when "01000011", -- ascii C
            "01000100" when "01000100", -- ascii D
            "01000101" when "01000101", -- ascii E
            "01000110" when "01000110", -- ascii F
            "01000111" when "01000111", -- ascii G
            "01000001" when "01000001", -- ascii A
            "01000010" when "01000010", -- ascii B
            
            -- Octave 5
            "01100011" when "01100011", -- ascii c
            "01100100" when "01100100", -- ascii d
            "01100101" when "01100101", -- ascii e
            "01100110" when "01100110", -- ascii f
            "01100111" when "01100111", -- ascii g
            "01100001" when "01100001", -- ascii a
            "01100010" when "01100010", -- ascii b
            
            -- No tone
            "00000000"  when others;   -- No tone when invalid ascii character
end arch;
