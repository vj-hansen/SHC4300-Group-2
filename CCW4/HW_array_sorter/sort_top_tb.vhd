----------------------------------
-- Array Sorter - TestBench
----------------------------------
library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------
entity sort_top_tb is
end sort_top_tb;
----------------------------------
architecture arch of sort_top_tb is
    component sort_top
        generic ( data_width : integer := 8);
                  
        port ( clk, rst    : in std_logic;
               unsrtd_data : in std_logic_vector(data_width-1 downto 0);
               srtd_data   : out std_logic_vector(data_width-1 downto 0));
    end component;
----------------------------------
    constant clk_period : time := 10 ns;
    constant data_width : integer := 8;
    signal clk, rst     : std_logic := '0';
    signal unsrtd_data  : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal srtd_data    : std_logic_vector(data_width-1 downto 0) := (others => '0');
----------------------------------
begin
    uut : sort_top port map 
            ( clk=>clk, rst=>rst, 
              unsrtd_data=>unsrtd_data,
              srtd_data=>srtd_data );

    clk_proc : process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim : process begin
        unsrtd_data <= X"71"; -- 113
        wait for clk_period;
        unsrtd_data <= X"2D"; -- 45
        wait for clk_period;
        unsrtd_data <= X"F9"; -- 249
        wait for clk_period;
        unsrtd_data <= X"13"; -- 19
        wait for clk_period;
        unsrtd_data <= X"48"; -- 72
        wait for clk_period;
        unsrtd_data <= X"B4"; -- 180
        wait for clk_period;
        unsrtd_data <= X"02"; -- 2
        wait for clk_period;
        unsrtd_data <= X"0A"; -- 10
        wait for clk_period;
        unsrtd_data <= X"58"; -- 88
        wait for clk_period;
        unsrtd_data <= X"D2"; -- 210
        wait for clk_period;
        unsrtd_data <= X"AE"; -- 174
        wait for clk_period;
    end process;
end;
