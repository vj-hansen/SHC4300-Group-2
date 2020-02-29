--- not tested, not connected to top.vhd

library IEEE;
library std;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-----------------------------------------------
entity decoder is  
    Port ( cipher_in : in std_logic_vector(7 downto 0);
           msg_out : out std_logic_vector(7 downto 0) );
end decoder;
-----------------------------------------------
architecture arch of decoder is
    signal dout : std_logic_vector(7 downto 0);
    signal m_n, c_n : unsigned(7 downto 0);
    constant k_n : std_logic_vector(7 downto 0) := X"6a"; -- key = 'j', used for testing
-----------------------------------------------
begin
    process(cipher_in) begin
        if (cipher_in>=X"61" or cipher_in<=X"7a") then 
                c_n <= unsigned(cipher_in);
                m_n <= ((25+unsigned(k_n)-c_n) mod 26)+97;
            end if;
    end process;
    msg_out <= std_logic_vector(m_n); -- decoded message
end arch;
