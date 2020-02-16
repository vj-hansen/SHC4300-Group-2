----------------------------------------------------------------------------------
-- FSM control path
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_controller is
    port ( 
        clk, rst: in std_logic;
        play: in std_logic;
        from_rx_done_tick: in std_logic;
        from_dout: in std_logic_vector(7 downto 0);
        from_rdbus: in std_logic_vector(7 downto 0);
        from_td_done: in std_logic;
        to_clr_FF: out std_logic;
        to_led: out std_logic_vector(7 downto 0);
        to_abus: out std_logic_vector(7 downto 0);
        to_wr_en: out std_logic;
        to_td_on: out std_logic
        );
end fsm_controller;

architecture arch of fsm_controller is
    -- FSM declaration
    type state_type is (init, check_for_ABC, store_1, store_2, store_3, wait_for_play, play_1, play_2);
    signal state_next, state_reg: state_type;
    signal valid_code: std_logic_vector(7 downto 0);
    signal abus: unsigned(7 downto 0);
    
----------------------------------------------------------------------------------
begin
    -- FSM state register
    process(clk, rst) begin
        if (rst = '1') then
            state_reg <= init;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
    end process;

    -- next state logic
    process(state_reg, from_rx_done_tick, from_dout) begin
        --Initial setup
        state_next <= state_reg;
        to_clr_FF <= '0';
        
        case state_reg is
            ------------------------------------------------------------                
            -- Initial state
            when init =>
                to_clr_FF <= '1';
                if (from_rx_done_tick = '1') then
                    if (from_dout = "01111100") then -- if from_dout = '|' (ascii: vertical bar, bin: 01111100)
                        state_next <= check_for_ABC; -- next state
                    else
                        state_next <= init;
                    end if;
                else
                    state_next <= init;
                end if;
            ------------------------------------------------------------                
            -- Check for ABC
            when check_for_ABC =>
                to_clr_FF <= '1';
                abus <= (others =>'0');
                if (from_rx_done_tick = '1' ) then
                    if (from_dout = valid_code) then -- if valid ASCII code
                        state_next <= store_1; -- next state
                    else
                        state_next <= check_for_ABC;
                    end if;
                else
                    state_next <= check_for_ABC;
                end if;
            ------------------------------------------------------------                
            -- First store state
            when store_1 =>
                to_clr_FF <= '1';
                to_wr_en <= '1';
                state_next <= store_2; -- next state
            ------------------------------------------------------------
            -- Second store state
            when store_2 =>
                to_clr_FF <= '1';
                abus <= abus+1;
                state_next <= store_3; -- next state
            ------------------------------------------------------------                  
            -- Third store stage
            when store_3 =>
                to_clr_FF <= '1'; 
                if (from_rx_done_tick = '1' ) then
                    if (from_dout = "01011101") then -- if from_dout = ']' (ascii: closing bracket, bin: 01011101)
                        to_wr_en <= '1'; -- ABC codes have been received and stored
                        state_next <= wait_for_play; -- next state
                    elsif (from_dout = valid_code) then
                        state_next <= store_1;
                    else
                        state_next <= store_3;
                    end if;
                else
                    state_next <= store_3;
                end if;               
            ------------------------------------------------------------         
            -- Wait for play
            when wait_for_play =>
                to_clr_FF <= '1';
                abus <= (others =>'0');
                if (play = '1') then
                    state_next <= play_1; -- go on to play note
                elsif (from_rx_done_tick = '1') then
                    if (from_dout = "01111100") then --from_dout = '|' (ascii: vertical bar, bin: 01111100)
                        state_next <= check_for_ABC;
                    else
                        state_next <= wait_for_play;
                    end if;
                else
                    state_next <= wait_for_play;
                end if;
            ------------------------------------------------------------         
            -- Play 1
            when play_1 =>
                to_td_on <= '1';
                if (from_rdbus = "01011101") then -- ram_data = ']' (ascii: closing bracket, bin: 01011101)
                    state_next <= wait_for_play;
                elsif (from_td_done = '1') then
                    state_next <= play_2;
                else
                    state_next <= play_1;
                end if;
            ------------------------------------------------------------           
            -- Play 2
            when play_2 =>
                to_td_on <= '1';
                abus <= abus+1;
                state_next <= play_1;
            ------------------------------------------------------------         
            -- Output
            to_abus <= std_logic_vector(abus);
        end case;
    end process;

    -- Display ASCII from UART on Basys3 LEDs
    process(from_rx_done_tick) begin
        if (from_rx_done_tick = '1') then
            to_led <= from_dout;
        end if;
    end process;  
------------------------------------------------------------  
    with from_dout select
        valid_code <=   
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
