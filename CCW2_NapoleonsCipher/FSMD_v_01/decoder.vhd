--- not working

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    generic (key_txt : integer:= 2 ); -- key = 'C'
    Port ( clk, reset : in std_logic;
           cipher_in : in integer;
           msg_out : out integer range 0 to 26 );
end decoder;

architecture Behavioral of decoder is
    signal tmp_in : integer; -- cipher in
    signal dout : std_logic_vector(7 downto 0);
    signal decrypt: integer; -- message out

begin
    -- convert ascii to integer
    converter_unit : entity work.converter(Behavioral) 
        port map ( clk=>clk, reset=>reset, from_dout=>dout, msg_out=>tmp_in);
    
    process(tmp_in) begin
        decrypt <= (25+key_txt-tmp_in) mod 26;
    end process;
    msg_out <= decrypt;
end Behavioral;