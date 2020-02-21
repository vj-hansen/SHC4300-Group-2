-- Top Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
    COMPONENT top 
        port ( rx, clk, reset, mode: IN std_logic;
               c_i : OUT std_logic_vector(7 downto 0) );                   
    END COMPONENT;
    
    signal rx, clk, reset, mode : std_logic := '0';
    signal c_i : std_logic_vector(7 downto 0);
    
    constant clk_period : time := 10 ns;
    constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    constant ascii_m: std_logic_vector(7 downto 0) := X"6d"; --  ascii: 'm' (dec=109)
    constant ascii_d: std_logic_vector(7 downto 0) := X"3a"; -- dummy
BEGIN
    uut: top PORT MAP 
          ( rx=>rx, clk=>clk, reset=>reset,
            c_i=>c_i, mode=>mode );
    
    clk_process: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process begin		
        reset <= '1';
        mode <= '0';
        wait for 100 ns;
        reset <= '0';
        mode<='1';
        rx <= '1';
        wait for clk_period;
       
        -- Test dummy
        rx <= '0'; -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= ascii_d(i);
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;       
        rx <= '1'; -- idle
        wait for clk_period*10; 


        -- Test m
        rx <= '0'; -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= ascii_m(i);
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;       
        rx <= '1'; -- idle
        wait for clk_period*10; 	
        wait;
    end process;
END;
