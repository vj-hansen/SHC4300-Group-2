----------------------------------------------------------------------------------
-- Toggle flip flop for loudspeaker
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_ff is
    port ( 
        clk, rst: in std_logic;
        from_t_in: in std_logic; --tick in or toggle?
        from_clr_FF: in std_logic;
        to_ldspkr: out std_logic --tick out
        );
end t_ff;

architecture arch of t_ff is
    signal buzz: std_logic := '0'; 
----------------------------------------------------------------------------------
begin
    -- Register
    process(clk, rst) begin
        if (rst = '1') then
            buzz <= '0';
        elsif rising_edge(clk) then
            if (from_clr_FF = '1') then
                buzz <= '0';
            elsif (from_t_in = '1') then
                buzz <= not buzz;
            end if;
        end if;
    end process;
    
    -- Output
    to_ldspkr <= buzz;     
end arch;
