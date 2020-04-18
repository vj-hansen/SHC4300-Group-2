-------------------------------------------------
-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Sort Top

-- store cell_data(data_elements-1) in an array to get sorted data.

-- Based on:
-- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
-- https://github.com/Poofjunior/fpga_fast_serial_sort
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity sort_top is
    generic ( data_elements : integer := 10;
              data_width    : integer := 8 ); -- 8-bit data elements
    
    port ( clk, rst     : in std_logic;
           new_data     : in std_logic_vector(data_width-1 downto 0); -- unsorted data
           sorted_array : out std_logic_vector(data_width-1 downto 0) ); 
end sort_top;
-------------------------------------------------
architecture behavioral of sort_top is
    component sorting_cell
        generic (data_width : integer := 8);
        
        port ( clk, rst             : in std_logic;
               new_data             : in std_logic_vector(data_width-1 downto 0);
               prev_cell_data       : in std_logic_vector(data_width-1 downto 0);
               prev_cell_occupied   : in boolean;
               prev_cell_push       : in boolean;
               next_cell_data       : out std_logic_vector(data_width-1 downto 0);
               next_cell_occupied   : out boolean;
               next_cell_push       : out boolean);
    end component;
-------------------------------------------------
    type data_bus       is array(0 to data_elements-1) of std_logic_vector(data_width-1 downto 0);
    type occupied_bus   is array(0 to data_elements-2) of boolean;
    type push_bus       is array(0 to data_elements-2) of boolean;
-------------------------------------------------
    signal cell_data     : data_bus;
    signal cell_occupied : occupied_bus;
    signal cell_push     : push_bus;
-------------------------------------------------
begin
    sorted_data : for cell in 0 to data_elements-1 generate
        -- First cell:
        -- prev_cell_data doesn't exist
        first_cell : if cell = 0 generate
            begin first_cell : sorting_cell 
                port map ( clk=>clk, rst=>rst, new_data=>new_data,
                           prev_cell_data=>(others=>'0'),
                           prev_cell_occupied=>true,
                           prev_cell_push=>false,
                           next_cell_data=>cell_data(cell),
                           next_cell_occupied=>cell_occupied(cell),
                           next_cell_push=>cell_push(cell) );
        end generate first_cell;
--------------------------------------
        -- Last cell:
        -- Don't connect the `next_cell_data` since we're at the last cell
        last_cell : if cell = data_elements-1 generate
            begin last_cell : sorting_cell 
                port map ( clk=>clk, rst=>rst, new_data=>new_data,
                           prev_cell_data=>cell_data(cell-1),
                           prev_cell_occupied=>cell_occupied(cell-1),
                           prev_cell_push=>cell_push(cell-1),
                           next_cell_data=>cell_data(cell) );
        end generate last_cell;
--------------------------------------
        -- Regular cells (not first or last cell):
        -- Connect `prev_cell` to the previous cell's `next_cell` values
        -- Connect `next_cell` to the next cell's `prev_cell` values.
        regular_cells : if (cell/=0) AND (cell/=data_elements-1) generate
            begin regular_cells : sorting_cell 
                port map ( clk=>clk, rst=>rst, new_data=>new_data,
                           prev_cell_data=>cell_data(cell-1),
                           prev_cell_occupied=>cell_occupied(cell-1),
                           prev_cell_push=>cell_push(cell-1),
                           next_cell_data=>cell_data(cell),
                           next_cell_occupied=>cell_occupied(cell),
                           next_cell_push=>cell_push(cell) );
            end generate regular_cells;
    end generate sorted_data;
--------------------------------------
    sorted_array <= cell_data(data_elements-1); -- use RAM for this?
end behavioral;