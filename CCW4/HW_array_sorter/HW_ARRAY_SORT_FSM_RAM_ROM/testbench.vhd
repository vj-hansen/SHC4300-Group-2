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
        port ( clk, rst, enable : in std_logic );
    end component;
----------------------------------
    constant clk_period     : time := 10 ns;
    constant data_width     : integer := 8;
    signal clk, rst, enable : std_logic := '0';
    signal sorted_data      : std_logic_vector(data_width-1 downto 0) := (others => '0');
----------------------------------
begin
    uut : main_top port map 
            ( clk => clk, rst => rst, enable => enable );

    clk_proc : process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim : process begin
        rst <= '1';
        enable <='0';
        wait for clk_period;
        rst <= '0';
        enable <='1';
        wait for clk_period*10000;
    end process;
end;