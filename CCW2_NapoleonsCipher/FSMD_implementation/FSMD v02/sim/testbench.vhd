-- Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
    COMPONENT top 
        port (  rx, clk, reset, mode : in std_logic;
                tx : out std_logic);
    END COMPONENT;
    
    signal clk, reset, mode : std_logic;            --:= '0';
    signal rx, tx           : std_logic;
    
    constant clk_period     : time := 10 ns;
    constant bit_period     : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    constant rx_ascii_f     : std_logic_vector(7 downto 0) := X"66"; -- send ascii f
    constant rx_ascii_a     : std_logic_vector(7 downto 0) := X"61"; -- send ascii a
    constant rx_ascii_m     : std_logic_vector(7 downto 0) := X"6D"; -- send ascii m
    constant rx_ascii_e     : std_logic_vector(7 downto 0) := X"65"; -- send ascii e
    constant enter          : std_logic_vector(7 downto 0) := X"0D"; -- press enter
    
    -- send message:        f a m e
    -- key:                 v i c t
    -- expect Ciphertext:	p h p o
 
BEGIN
    uut: top PORT MAP 
       (rx => rx,
        tx => tx,
        clk => clk,
        reset => reset,
        mode => mode);
        
    
    clk_process: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process begin		
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        mode <= '0';                -- set mode to encode
        rx <= '1';
        wait for clk_period;
        
    -- Send ascii f
        rx <= '0';		             -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_f(i);     -- 8 data bits
                wait for bit_period;
        end loop;
        rx <= '1';                  -- stop bit
        wait for bit_period;
        rx <= '1';                  -- idle
        wait for clk_period*10; 
        
    -- Send ascii a
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_a(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii m
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_m(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii e
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_e(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    ----------------------------------------------------
    -- REPEAT MSG FOR FEW TIMES TO CHECK KEY
    ----------------------------------------------------
    -- Send ascii f
        rx <= '0';		             -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_f(i);     -- 8 data bits
                wait for bit_period;
        end loop;
        rx <= '1';                  -- stop bit
        wait for bit_period;
        rx <= '1';                  -- idle
        wait for clk_period*10; 
        
    -- Send ascii a
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_a(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii m
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_m(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii e
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_e(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    ----------------------------------------------------
    -- REPEAT MSG FOR FEW TIMES TO CHECK KEY
    ----------------------------------------------------
    -- Send ascii f
        rx <= '0';		             -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_f(i);     -- 8 data bits
                wait for bit_period;
        end loop;
        rx <= '1';                  -- stop bit
        wait for bit_period;
        rx <= '1';                  -- idle
        wait for clk_period*10; 
        
    -- Send ascii a
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_a(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii m
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_m(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii e
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_e(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10;         

    ----------------------------------------------------
    -- REPEAT MSG FOR FEW TIMES TO CHECK KEY
    ----------------------------------------------------
    -- Send ascii f
        rx <= '0';		             -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_f(i);     -- 8 data bits
                wait for bit_period;
        end loop;
        rx <= '1';                  -- stop bit
        wait for bit_period;
        rx <= '1';                  -- idle
        wait for clk_period*10; 
        
    -- Send ascii a
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_a(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii m
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_m(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 

    -- Send ascii e
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_ascii_e(i);    
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 
        
    ----------------------------------------------------
    -- send last ascii "enter"
    ----------------------------------------------------
        rx <= '0';		            
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= enter(i);
                wait for bit_period;
        end loop;
        rx <= '1';                  
        wait for bit_period;
        rx <= '1';                  
        wait for clk_period*10; 	
        wait;
    end process;
END;
