library IEEE;
library std;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-----------------------------------------------
entity encoder is  
    Port ( msg_in  : in std_logic_vector(7 downto 0);
           cipher_out : out std_logic_vector(7 downto 0) );
end encoder;
-----------------------------------------------
architecture arch of encoder is
    signal dout : std_logic_vector(7 downto 0);
    signal m_n, c_n : unsigned(7 downto 0);
    constant k_n : std_logic_vector(7 downto 0) := X"6a"; -- key = 'j', used for testing
-----------------------------------------------
begin
    process(msg_in) begin
        if (msg_in>=X"61" or msg_in<=X"7a") then 
                m_n <= unsigned(msg_in);
                c_n <= ((25-m_n+unsigned(k_n)) mod 26)+97;
            end if;
    end process;
    cipher_out <= std_logic_vector(c_n);
end arch;
