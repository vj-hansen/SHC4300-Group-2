LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY musicbox_tb IS
END musicbox_tb;
 
ARCHITECTURE behavior OF musicbox_tb IS 
    COMPONENT top 
        port ( rx, clk, reset, play : IN  std_logic;
               loudspeaker : OUT  std_logic;
               leds : OUT  std_logic_vector(7 downto 0) );
    END COMPONENT;
    
   signal rx, clk, reset, play : std_logic := '0';
   signal loudspeaker : std_logic;
   signal leds : std_logic_vector(7 downto 0);
   constant clk_period : time := 10 ns;
 
BEGIN
   uut: top PORT MAP ( rx => rx,
         	      clk => clk,
          	      reset => reset,
          	      loudspeaker => loudspeaker,
		      play => play,
		      leds => leds );

   clk_process: process begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   stim_proc: process begin		
      reset <= '1';
      play <= '0';
      wait for 100 ns;
      reset <= '0';
      rx <= '1';
      wait for clk_period;

    	--send dout = X"28 = 0010 1000" -- start of tune '('
    	rx <= '0';		-- start bit
      wait for 52083 ns;
	rx <= '0';		-- data bit #1 (lsb)
      wait for 52083 ns;
	rx <= '0';		-- data bit #2
      wait for 52083 ns;
	rx <= '0';		-- data bit #3
      wait for 52083 ns;
	rx <= '1';		-- data bit #4
      wait for 52083 ns;
	rx <= '0';		-- data bit #5
      wait for 52083 ns;
	rx <= '1';		-- data bit #6
      wait for 52083 ns;
	rx <= '0';		-- data bit #7
      wait for 52083 ns;
	rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
	rx <= '1';		-- stop bit
      wait for 52083 ns;
	rx <= '1';		-- idle for a while
      wait for clk_period*10;  
    

	-- send data word 01100111 (msb at left): g5: 67H (g) 
	rx <= '0';		-- start bit
      wait for 52083 ns;
	rx <= '1';		-- data bit #1 (lsb)
      wait for 52083 ns;
	rx <= '1';		-- data bit #2
      wait for 52083 ns;
	rx <= '1';		-- data bit #3
      wait for 52083 ns;
	rx <= '0';		-- data bit #4
      wait for 52083 ns;
	rx <= '0';		-- data bit #5
      wait for 52083 ns;
	rx <= '1';		-- data bit #6
      wait for 52083 ns;
	rx <= '1';		-- data bit #7
      wait for 52083 ns;
	rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
	rx <= '1';		-- stop bit
      wait for 52083 ns;
	rx <= '1';		-- idle for a while
      wait for clk_period*10;
		
	-- send data word 01000110 (msb at left): F4: 46H (F) 
	rx <= '0';		-- start bit
      wait for 52083 ns;
	rx <= '0';		-- data bit #1 (lsb)
      wait for 52083 ns;
	rx <= '1';		-- data bit #2
      wait for 52083 ns;
	rx <= '1';		-- data bit #3
      wait for 52083 ns;
	rx <= '0';		-- data bit #4
      wait for 52083 ns;
	rx <= '0';		-- data bit #5
      wait for 52083 ns;
	rx <= '0';		-- data bit #6
      wait for 52083 ns;
	rx <= '1';		-- data bit #7
      wait for 52083 ns;
	rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
	rx <= '1';		-- stop bit
      wait for 52083 ns;
	rx <= '1';		-- idle for a while
      wait for clk_period*10;
		
	-- send data word 01100100 (msb at left): d5: 64H (d)
	rx <= '0';		-- start bit
      wait for 52083 ns;
	rx <= '0';		-- data bit #1 (lsb)
      wait for 52083 ns;
	rx <= '0';		-- data bit #2
      wait for 52083 ns;
	rx <= '1';		-- data bit #3
      wait for 52083 ns;
	rx <= '0';		-- data bit #4
      wait for 52083 ns;
	rx <= '0';		-- data bit #5
      wait for 52083 ns;
	rx <= '1';		-- data bit #6
      wait for 52083 ns;
	rx <= '1';		-- data bit #7
      wait for 52083 ns;
	rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
	rx <= '1';		-- stop bit
      wait for 52083 ns;
	rx <= '1';		-- idle for a while
      wait for clk_period*10;  
   
   
    --send dout = X"29 = 0010 1001" -- end of tune ')'
    	rx <= '0';		-- start bit
      wait for 52083 ns;
	rx <= '1';		-- data bit #1 (lsb)
      wait for 52083 ns;
	rx <= '0';		-- data bit #2
      wait for 52083 ns;
	rx <= '0';		-- data bit #3
      wait for 52083 ns;
	rx <= '1';		-- data bit #4
      wait for 52083 ns;
	rx <= '0';		-- data bit #5
      wait for 52083 ns;
	rx <= '1';		-- data bit #6
      wait for 52083 ns;
	rx <= '0';		-- data bit #7
      wait for 52083 ns;
	rx <= '0';		-- data bit #8 (msb)
      wait for 52083 ns;
	rx <= '1';		-- stop bit
      wait for 52083 ns;
	rx <= '1';		-- idle for a while
      wait for clk_period*10;  

	  play <= '1';
	  wait for clk_period*10;
	  play <= '0';
      	  wait for  clk_period*1000000;
	  play <= '1';
	  wait for clk_period*10000000;
	  play <= '0';
      	  wait for clk_period;		
      	  wait;
   end process;
END;
