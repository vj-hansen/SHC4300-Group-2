-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Array MAIN Top-module
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Based on:
    -- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
    -- Sorting Units for FPGA-Based Embedded Systems, R. Marcelino, H. Neto, and J. M. P. Cardoso, 2008
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity main_top is    
    port ( clk, rst       : in std_logic;
           to_clr_data_in : in std_logic;
           to_inc_data_in : in std_logic;
           ram_wr         : in std_logic );
end main_top;
-------------------------------------------------
architecture arch of main_top is
    signal clr_data_in, inc_data_in : std_logic; 
    signal unsorted_in_bus  : std_logic_vector(7 downto 0);
    signal ram_bus          : std_logic_vector(7 downto 0);
    signal ram_input_bus    : std_logic_vector(7 downto 0);
    signal ram_abus         : std_logic_vector(11 downto 0);
-------------------------------------------------
begin
----------------------------------------------------------
    ROM : entity work.read_ROM(arch)
        port map (  clk => clk,
                    from_clr_data_in => to_clr_data_in, 
                    from_inc_data_in => to_inc_data_in,
                    to_data_in_bus => unsorted_in_bus ); -- unsorted data out
----------------------------------------------------------
    SORTER : entity work.sort_top(arch) 
        port map (  clk => clk, 
                    rst => rst,
                    from_rom => unsorted_in_bus,
                    sorted_data => ram_input_bus );
----------------------------------------------------------
    RAM : entity work.RAM(arch)
        port map (  clk => clk,
                    from_wr => ram_wr,
                    from_abus => ram_abus,
                    from_ram_bus => ram_input_bus, -- sorted data in
                    ram_out => ram_bus );  -- data out
----------------------------------------------------------
end arch;
