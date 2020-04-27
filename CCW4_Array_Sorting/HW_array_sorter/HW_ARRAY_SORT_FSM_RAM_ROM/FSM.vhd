-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- FSM
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Based on:
    -- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
    -- Sorting Units for FPGA-Based Embedded Systems, R. Marcelino, H. Neto, and J. M. P. Cardoso, 2008
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity FSM is
    generic ( num_cells  : integer := 15;
              data_width : integer := 8;
              ADDR_WIDTH : integer := 12 );
    
    port (  clk, rst, enable    : in std_logic;
            rom_done            : in STD_LOGIC;
            from_ROM            : in std_logic_vector(7 downto 0);
            to_abus             : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            to_clr_data_in      : out std_logic;
            to_inc_data_in      : out std_logic;
            to_wr_en            : out STD_LOGIC;
            to_RAM_bus          : out std_logic_vector(data_width-1 downto 0);
            sort_done           : buffer std_logic );
end FSM;
-------------------------------------------------
architecture arch of FSM is
    component sorting_cell
        generic (data_width : integer := 8);
        
        port ( clk, rst           : in std_logic;
               unsorted_data      : in std_logic_vector(data_width-1 downto 0);
               pre_data           : in std_logic_vector(data_width-1 downto 0);
               pre_full, pre_push : in boolean;
               nxt_data           : out std_logic_vector(data_width-1 downto 0);
               nxt_full, nxt_push : out boolean );
    end component;
 -------------------------------------------------   
    type state_type is (init, ROM_state,  RAM_state_1, RAM_state_2);
    type data_arr is array(0 to num_cells-1) of std_logic_vector(data_width-1 downto 0);
    type full_arr is array(0 to num_cells-1) of boolean;
    type push_arr is array(0 to num_cells-2) of boolean;
-------------------------------------------------
    signal data : data_arr; -- cell data
    signal full : full_arr; -- full/occupied cell
    signal push : push_arr;
    signal clr_data_in, inc_data_in : std_logic; 
    signal state_next, state_reg : state_type;
    signal pcntr_next, pcntr_reg : unsigned (ADDR_WIDTH-1 downto 0); -- program counter (increment abus)
    signal temp_data             : std_logic_vector(data_width-1 downto 0);
-------------------------------------------------
begin
    sorting_data : for n in 0 to num_cells-1 generate
        -- First cell:
        -- pre_data doesn't exist (since this is the first cell)
        first_cell : if n = 0 generate
            begin first_cell : sorting_cell 
                port map ( clk=>clk, rst=>rst, 
                           unsorted_data=>from_ROM,
                           pre_data=>(others=>'0'),
                           pre_full=>true,
                           pre_push=>false,
                           nxt_data=>data(n),
                           nxt_full=>full(n),
                           nxt_push=>push(n) );
        end generate first_cell;
--------------------------------------
        -- Last cell:
        -- Don't connect the `nxt_data` since we're at the last cell
        last_cell : if n = num_cells-1 generate
            begin last_cell : sorting_cell 
                port map ( clk=>clk, rst=>rst, 
                           unsorted_data=>from_ROM,
                           pre_data=>data(n-1),
                           pre_full=>full(n-1),
                           pre_push=>push(n-1),
                           nxt_data=>data(n),
                           nxt_full => full(n) );
        end generate last_cell;
--------------------------------------
        -- Regular cells ( i.e. the cells between the first and last cell):
        -- Connect `pre_` to the previous cell's `nxt_` values
        -- Connect `nxt_` to the next cell's `pre_` values.
        regular_cells : if (n/=0) AND (n/=num_cells-1) generate
            begin regular_cells : sorting_cell 
                port map ( clk=>clk, rst=>rst, 
                           unsorted_data=>from_ROM,
                           pre_data=>data(n-1),
                           pre_full=>full(n-1),
                           pre_push=>push(n-1),
                           nxt_data=>data(n),
                           nxt_full=>full(n),
                           nxt_push=>push(n) );
            end generate regular_cells;
    end generate sorting_data;
 ----------------------------------------------------
 temp_data <= data(num_cells-1);
 
    -- state register
    process(clk, rst) begin
        if (rst = '1') then
            state_reg <= init;
            pcntr_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            pcntr_reg <= pcntr_next;
        end if;
    end process;
----------------------------------------------------
    -- next state and output logic
    process(enable, state_reg, pcntr_reg, sort_done, rom_done) begin
        state_next <= state_reg;
        pcntr_next <= pcntr_reg; -- address counter
        to_wr_en <= '0';
        to_clr_data_in <= '0';
        to_inc_data_in <= '0';
        case state_reg is
    ----------------------------------------------------
        when init =>
            to_clr_data_in <= '1';
            if (enable = '1') then 
                state_next <= ROM_state;
            else 
                state_next <= init;
            end if;
----------------------------------------------------
        when ROM_state =>
            pcntr_next <= (others => '0');
            to_inc_data_in <= '1';
            if (rom_done = '1') then
                to_wr_en <= '1';
                state_next <= RAM_state_1; 
             --   to_inc_data_in <= '0';
            else 
                state_next <= ROM_state;
            end if;
----------------------------------------------------
        when RAM_state_1 =>
            to_wr_en <= '1';
            state_next <= RAM_state_2;
----------------------------------------------------
        when RAM_state_2 =>
            to_wr_en <= '1';
            pcntr_next <= pcntr_reg + 1;
----------------------------------------------------
        end case;
    end process;
    to_RAM_bus <= temp_data;
    to_abus <= std_logic_vector (pcntr_reg);   
end arch;