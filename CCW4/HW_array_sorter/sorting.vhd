-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Sorting Cell
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Based on:
    -- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
    -- Sorting Units for FPGA-Based Embedded Systems, R. Marcelino, H. Neto, and J. M. P. Cardoso, 2008
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------
entity sorting_cell is
    generic ( data_width : integer := 8 );
    
    port ( clk, rst           : in std_logic;
           unsrtd_data        : in std_logic_vector(data_width-1 downto 0);
           pre_data           : in std_logic_vector(data_width-1 downto 0);
           pre_full, pre_push : in boolean;
           nxt_data           : out std_logic_vector(data_width-1 downto 0);
           nxt_full, nxt_push : out boolean );
end sorting_cell;
--------------------------------------
architecture arch of sorting_cell is
    signal full        : boolean := false;
    signal crrnt_data  : std_logic_vector(data_width-1 downto 0) := (others=>'0');
    signal accept_data : boolean := false;
--------------------------------------
begin
    accept_data <= (unsrtd_data < crrnt_data) OR NOT full;
    nxt_data    <= crrnt_data;
    nxt_full    <= true when (full) else false;
    nxt_push    <= true when (accept_data AND full) else false;
--------------------------------------
    process (clk) begin
        if rising_edge(clk) then
            if (rst = '1') then
                full <= false;
            else
                case full is
                    when false =>
                        if (pre_push) then
                            full <= true;
                        elsif (NOT pre_push AND pre_full) then
                            full <= true;
                        else
                            full <= false;
                        end if;
                    when true =>
                        full <= true;
                end case;
            end if;
        end if;
    end process;
--------------------------------------
    process (clk) begin
        if rising_edge(clk) then
            if (rst = '1') then
                crrnt_data <= (others=>'0');
            else
                if (pre_push) then
                    crrnt_data <= pre_data;
                elsif (accept_data AND NOT pre_push AND full) then
                    crrnt_data <= unsrtd_data;
                elsif (NOT pre_push AND NOT full AND pre_full) then
                    crrnt_data <= unsrtd_data;
                end if;
            end if;
        end if;
    end process;
end arch;
