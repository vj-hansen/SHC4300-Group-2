----------------------------------
-- Array Sorter - TestBench
----------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------
entity main_top_tb is
end main_top_tb;
----------------------------------
architecture arch of main_top_tb is
    component main_top is    
        port ( clk, rst       : in std_logic;
               to_clr_data_in : in std_logic;
               to_inc_data_in : in std_logic;
               ram_wr         : in std_logic );
    end component;
----------------------------------
    constant clk_period     : time := 10 ns;
    constant data_width     : integer := 8;
    signal clk, rst         : std_logic := '0';
    signal sorted_data      : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal to_clr_data_in, to_inc_data_in : std_logic;
    signal ram_wr, sort_done : std_logic;
----------------------------------
begin
    uut : main_top port map 
            ( clk => clk,
              rst => rst, 
              to_clr_data_in => to_clr_data_in,
              to_inc_data_in => to_inc_data_in,
              ram_wr => ram_wr );

    clk_proc : process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim : process begin
        rst <= '1';
        to_clr_data_in <='1';
        to_inc_data_in <='0';
        wait for clk_period;
        rst <= '0';
        to_clr_data_in <='0';
        to_inc_data_in <='1'; -- 0  
        wait for clk_period;
        to_inc_data_in <='1'; -- 1
        wait for clk_period;
        to_inc_data_in <='1'; -- 2
        wait for clk_period;
        to_inc_data_in <='1'; -- 3
        wait for clk_period;
        to_inc_data_in <='1'; -- 4 
        wait for clk_period;
        to_inc_data_in <='1'; -- 5
        wait for clk_period;
        to_inc_data_in <='1'; -- 6
        wait for clk_period;
        to_inc_data_in <='1'; -- 7
        wait for clk_period;
         to_inc_data_in <='1'; -- 8
        wait for clk_period;
        to_inc_data_in <='1'; -- 9
        wait for clk_period;
        to_inc_data_in <='1'; -- 10
        wait for clk_period;
        to_inc_data_in <='1'; -- 11
        wait for clk_period;
        to_inc_data_in <='1'; -- 12
        wait for clk_period;
        to_inc_data_in <='1'; -- 13
        wait for clk_period;
        to_inc_data_in <='1'; -- 14
        wait for clk_period;
        ram_wr <= '1';
        wait for clk_period; 
        ram_wr <= '1';
        wait for clk_period; 
        ram_wr <= '1';
        wait for clk_period; 
        ram_wr <= '1';
        wait;
    end process;
end;
