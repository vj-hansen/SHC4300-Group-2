-- FSM Control Path

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------
entity FSM is
    generic ( ADDR_WIDTH: integer := 12;
              DATA_WIDTH: integer := 8 );
        
    port ( clk, reset, from_mode : in STD_LOGIC;
           from_rx_done_tick : in STD_LOGIC;
           from_dout, from_rdbus : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           to_abus : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           to_wr_en : out STD_LOGIC );
end FSM;
--------------------------------------------------
architecture arch of FSM is
    type state_type is (init, check_for_ascii, store_1, store_2, store_3, encode);
    signal state_next, state_reg : state_type;
    signal pcntr_next, pcntr_reg : unsigned (ADDR_WIDTH-1 downto 0); -- program counter (increment abus)
begin
------ state register ---------------------------
    process(clk, reset) begin
        if (reset = '1') then
            state_reg <= init;
            pcntr_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            pcntr_reg <= pcntr_next;
        end if;
    end process;
-------------------------------------------------        
    -- next state and output logic
    process(from_mode, state_reg, pcntr_reg, from_rx_done_tick, from_dout, from_rdbus)
    begin
        state_next <= state_reg;
        pcntr_next <= pcntr_reg; -- address counter
        to_wr_en <= '0';
        case state_reg is
    ----------------------------------------------------
        when init =>
            if (from_rx_done_tick = '1') then 
                state_next <= check_for_ascii;
            end if;
    ----------------------------------------------------
        when check_for_ascii =>
            pcntr_next <= (others => '0');
            if (from_rx_done_tick = '1') then
                -- check for lower case ascii if from_dout >= a or from_dout <= z  
                if (from_dout>=X"61" or from_dout<=X"7a") then 
                    state_next <= store_1;
                end if;
            end if;
    ----------------------------------------------------
        when store_1 =>
            to_wr_en <= '1';
            state_next <= store_2;
    ----------------------------------------------------
        when store_2 =>
            pcntr_next <= pcntr_reg+1; -- increment abus
            state_next <= store_3;
    ----------------------------------------------------
        when store_3 =>
            if (from_rx_done_tick = '1') then
                if (from_mode = '1') then
                    to_wr_en <= '1';
                    state_next <= encode;
                elsif (from_dout>=X"61" or from_dout<=X"7a") then 
                        state_next <= store_1;
                end if;
            end if;
----------------------------------------------------
        when encode =>
            pcntr_next <= (others => '0');
            if (from_mode = '1') then
                state_next <= encode;
            end if;
        end case;
    end process;
    to_abus <= std_logic_vector(pcntr_reg);
end arch;