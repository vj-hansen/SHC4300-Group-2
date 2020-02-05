-- Timer delay counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimerDelay is
   generic ( --N: integer :=16;
             --M: std_logic_vector := "1100001101010000" );
             N: integer := 26;    -- number of bits (to count M clk cycles @ 100 MHz)
  	     M: std_logic_vector := "10111110101111000010000000" );  -- 100 MHz * 0.5 sec = 50 M clock cycles

   port ( clk, reset: in std_logic;
	  from_td_on: in std_logic;
          to_td_done: out std_logic );
end TimerDelay;

architecture arch of TimerDelay is
signal r_next, r_reg: unsigned(N-1 downto 0);

begin
   -- register
   process(clk,reset) begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif rising_edge(clk) then
         r_reg <= r_next;
      end if;
   end process;
	
   -- next-state logic
	process(r_reg, from_td_on) begin
		r_next <= r_reg;
      		if (from_td_on = '1') then
			if (r_reg /= 0) then -- fix
				r_next <= r_reg - 1; -- count down
			else
				r_next <= unsigned(M);
			end if;
      		end if;
   	end process;
	
	-- fix here
   -- output logic
   to_td_done <= '1' when r_reg=1 else '0';
end arch;
