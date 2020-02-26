----------------------------------------------------------------------------------
-- FSM Control Path
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    generic(    ADDR_WIDTH: integer := 12;
                DATA_WIDTH: integer := 8 );
        
    port(   clk, reset          : in STD_LOGIC;
            from_mode           : in STD_LOGIC;
            from_rx_done_tick   : in STD_LOGIC;
            from_tx_done_tick   : in STD_LOGIC;
            from_rx_bus         : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
            from_tx_bus         : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
            
            to_clr_key          : out STD_LOGIC;
            to_inc_key          : out STD_LOGIC;
            to_enc              : out STD_LOGIC;
            to_dec              : out STD_LOGIC;
            to_abus             : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
            to_wr               : out STD_LOGIC;
            to_tx_start_tick    : out STD_LOGIC );
end FSM;

architecture arch of FSM is
    type state_type is (check_for_ascii, store_1, store_2, store_3, 
                        wait_transmit, transmit_1, transmit_2);
    signal state_next, state_reg : state_type;
    signal pcntr_next, pcntr_reg : unsigned (ADDR_WIDTH-1 downto 0); -- program counter (increment abus)

----------------------------------------------------------------------------------
begin
    -- state register
    process(clk, reset) begin
        if (reset = '1') then
            state_reg <= check_for_ascii;
            pcntr_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            pcntr_reg <= pcntr_next;
        end if;
    end process;
        
    -- next state and output logic
    process(state_reg, pcntr_reg, from_mode, from_rx_done_tick, from_tx_done_tick, 
            from_rx_bus, from_tx_bus)
    begin
        state_next <= state_reg;
        pcntr_next <= pcntr_reg; -- address counter
        to_clr_key <= '0';
        to_inc_key <= '0';
        to_enc <= '0';
        to_dec <= '0';
        to_wr <= '0';
        to_tx_start_tick <= '0';
        
        case state_reg is
    ----------------------------------------------------
        when check_for_ascii =>
            to_clr_key <= '1';              -- clear key counter
            pcntr_next <= (others => '0');  -- clear adress counter
            if (from_rx_done_tick = '1') then
                if (from_rx_bus>=X"61" or from_rx_bus<=X"7a") then -- go to store_1 if ascii 'a' to 'z'
                    -- shouldn't it be:  (from_rx_bus>=X"61" AND from_rx_bus<=X"7a") ?
                    state_next <= store_1;
                else
                    state_next <= check_for_ascii;    
                end if;
            else
                state_next <= check_for_ascii;
            end if;
    ----------------------------------------------------
        when store_1 =>
            to_wr <= '1';
            if (from_mode = '0') then
                to_enc <= '1';
                state_next <= store_2;
            else
                to_dec <= '1';
                state_next <= store_2;
            end if; 
            
    ----------------------------------------------------
        when store_2 =>
            to_inc_key <= '1';          -- increment rom key
            pcntr_next <= pcntr_reg+1;  -- increment abus
            state_next <= store_3;
    ----------------------------------------------------
        when store_3 =>
            if (from_rx_done_tick = '1') then
                if (from_rx_bus>=X"61" or from_rx_bus<=X"7a" or from_rx_bus = X"0D") then   -- if ascii is valid
                    if (from_rx_bus = X"0D") then                                           -- if enter is pressed and mode is selected to encode
                        to_wr <= '1';
                        state_next <= wait_transmit;
                    elsif (from_rx_bus = X"0D") then                                        -- if enter is pressed and mode is selected to decode
                        to_wr <= '1';
                        state_next <= wait_transmit;
                    else
                        state_next <= store_1;
                    end if;
                else
                    state_next <= store_3;
                end if;
            else
                state_next <= store_3;
            end if;
    ----------------------------------------------------
        when wait_transmit =>
            pcntr_next <= (others => '0');
            state_next <= transmit_1;
    ----------------------------------------------------
        when transmit_1 =>
            to_tx_start_tick <= '1';
            state_next <= transmit_2;
    ----------------------------------------------------
        when transmit_2 =>
            if (from_tx_done_tick = '1') then
                pcntr_next <= pcntr_next +1;
                state_next <= transmit_1;
            else
                state_next <= transmit_2;
            end if;
        end case;
    end process;
    
    -- output
    to_abus <= std_logic_vector(pcntr_reg);
end arch;
