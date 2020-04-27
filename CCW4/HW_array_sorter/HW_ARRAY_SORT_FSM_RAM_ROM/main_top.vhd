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
    port ( clk, rst, enable : in std_logic;
           sorted_out : out std_logic_vector(7 downto 0) );
end main_top;
-------------------------------------------------
architecture arch of main_top is
    signal clr_data_in, inc_data_in : std_logic; 
    signal rom_done, sort_done : std_logic;
    signal unsorted_in_bus : std_logic_vector(7 downto 0);
    signal ram_input_bus : std_logic_vector(7 downto 0);
    signal ram_wr : std_logic;
    signal ram_abus : std_logic_vector(11 downto 0);
-------------------------------------------------
begin
----------------------------------------------------------
    ROM : entity work.read_ROM(arch)
        port map (  clk => clk,
                    from_clr_data_in => clr_data_in, 
                    from_inc_data_in => inc_data_in,
                    rom_done => rom_done,
                    to_data_in_bus => unsorted_in_bus ); -- unsorted data out
----------------------------------------------------------
    FSM : entity work.FSM(arch) 
        port map (  clk => clk, 
                    rst => rst,
                    enable => enable,
                    rom_done => rom_done,
                    sort_done => sort_done,
                    to_abus => ram_abus,
                    to_clr_data_in => clr_data_in, 
                    to_inc_data_in => inc_data_in,
                    to_wr_en => ram_wr,
                    from_rom => unsorted_in_bus,
                    to_RAM_bus => ram_input_bus ); -- sorted data out                   
----------------------------------------------------------
    RAM : entity work.RAM(arch)
        port map (  clk => clk,
                    from_wr => ram_wr,
                    from_abus => ram_abus,
                    from_ram_bus => ram_input_bus, -- sorted data in
                    ram_out => sorted_out );  -- data out
----------------------------------------------------------
end arch;