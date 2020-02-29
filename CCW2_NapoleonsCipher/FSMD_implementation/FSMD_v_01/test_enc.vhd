library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_enc is
end test_enc;

architecture Behavioral of test_enc is
    component encoder
        port (  msg_in : in std_logic_vector(7 downto 0);
                cipher_out : out std_logic_vector(7 downto 0)
              );
    end component;
    signal msg_in, cipher_out : std_logic_vector(7 downto 0);

begin
    uut: encoder port map(msg_in=>msg_in, cipher_out=>cipher_out );
    
    stim_proc: process begin
        msg_in <= X"6e";
        wait for 10 ns;
        msg_in <= X"6d"; -- m=109, key = 106 = j
        wait; -- gi 119 = w
        end process;
end Behavioral;