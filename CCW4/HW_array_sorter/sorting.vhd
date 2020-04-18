--------------------------------------
-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Sorting Cell
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------
entity sorting_cell is
    generic ( data_width : integer := 8 );
    port ( clk, rst : in std_logic;
           new_data : in std_logic_vector(data_width-1 downto 0); -- unsorted data
           prev_cell_data     : in std_logic_vector(data_width-1 downto 0);
           prev_cell_occupied : in boolean;
           prev_cell_push     : in boolean;
           next_cell_data     : out std_logic_vector(data_width-1 downto 0);
           next_cell_occupied : out boolean;
           next_cell_push     : out boolean);
end sorting_cell;
--------------------------------------
architecture behavioral of sorting_cell is
    signal occupied         : boolean := false;
    signal current_data     : std_logic_vector(data_width-1 downto 0) := (others=>'0');
    signal can_accept_data  : boolean := false;
--------------------------------------
begin
    can_accept_data <= (new_data < current_data) OR NOT occupied;
    next_cell_data <= current_data;
    next_cell_occupied <= true when occupied else false;
    next_cell_push <= true when (can_accept_data and occupied) else false;
--------------------------------------
    process (clk) begin
        if rising_edge(clk) then
            if (rst = '1') then
                occupied <= false;
            else
                case occupied is
                    when false =>
                        if (prev_cell_push) then
                            occupied <= true;
                        elsif (NOT prev_cell_push AND prev_cell_occupied) then
                            occupied <= true;
                        else
                            occupied <= false;
                        end if;
                    when true =>
                        occupied <= true;
                end case;
            end if;
        end if;
    end process;
--------------------------------------
    process (clk) begin
        if rising_edge(clk) then
            if (rst = '1') then
                current_data <= (others=>'0');
            else
                if (prev_cell_push) then
                    current_data <= prev_cell_data;
                elsif (can_accept_data AND NOT prev_cell_push AND occupied) then
                    current_data <= new_data;
                elsif (NOT prev_cell_push AND NOT occupied AND prev_cell_occupied) then
                    current_data <= new_data;
                end if;
            end if;
        end if;
    end process;
end behavioral;