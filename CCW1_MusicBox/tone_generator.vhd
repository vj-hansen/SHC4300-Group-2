library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity tone_gen is
    Port (clk : in std_logic;
          Do, Re, Mi, Fa, Sol, La, Ti : in std_logic;  
          audio_out : out std_logic);
end tone_gen;

architecture Behavioral of tone_gen is
    signal cnt : std_logic_vector(17 downto 0) := (others => '0');
    signal toggle : std_logic := '0';
    signal note : std_logic_vector(2 downto 0);
    
    constant n_Do  : std_logic_vector := "101110101010001001";  -- = 191113 
    constant n_Re  : std_logic_vector := "101001100100010110";  -- = 170262
    constant n_Mi  : std_logic_vector := "100101000010000110";  -- = 151686
    constant n_Fa  : std_logic_vector := "100010111101000101";  -- = 143173
    constant n_Sol : std_logic_vector := "11111001001000001";   -- = 127553
    constant n_La  : std_logic_vector := "11011101111100100";   -- = 113636
    constant n_Ti  : std_logic_vector := "11000101101110111";   -- = 101239

begin
count_process : process(clk, note)
    begin
        if rising_edge(clk) then
            case note is
                when "000" => -- Do
                    if (cnt >= n_Do) then
                        cnt <= (others => '0'); -- clear
                        toggle <= not toggle; -- toggle pulse
                    else
                        cnt <= cnt + 1; -- continue
                    end if;
                --------------------
                when "001" => -- Re
                    if (cnt >= n_Re) then
                        cnt <= (others => '0');
                        toggle <= not toggle;
                    else
                        cnt <= cnt + 1;
                    end if;
               --------------------     
               when "010" => -- Mi
                    if (cnt >= n_Mi) then
                        cnt <= (others => '0');
                        toggle <= not toggle;
                    else
                        cnt <= cnt + 1;
                    end if;
               --------------------     
               when "011" => -- Fa
                    if (cnt >= n_Fa) then
                        cnt <= (others => '0');
                        toggle <= not toggle;
                    else
                        cnt <= cnt + 1;
                    end if;
               --------------------     
               when "100" => -- Sol
                    if (cnt >= n_Sol) then
                        cnt <= (others => '0');
                        toggle <= not toggle;
                    else
                        cnt <= cnt + 1;
                    end if;
               --------------------     
               when "101" => -- La
                    if (cnt >= n_La) then
                        cnt <= (others => '0');
                        toggle <= not toggle;
                    else
                        cnt <= cnt + 1;
                    end if;
               --------------------
               when "110" => -- Ti
                    if (cnt >= n_Ti) then
                        cnt <= (others => '0');
                        toggle <= not toggle;
                    else
                        cnt <= cnt + 1;
                    end if;
               --------------------
               when others =>
                    toggle <= '0';
                    cnt <= (others => '0');
            end case;
        end if;
audio_out <= toggle;
end process count_process;


-- play notes using switches
play : process(Do, Re, Mi, Fa, Sol, La, Ti)
    begin
        if Do = '1' then
            note <= "000"; 
        elsif Re = '1' then
            note <= "001";
        elsif Mi = '1' then
            note <= "010";
        elsif Fa = '1' then
            note <= "011";
        elsif Sol = '1' then
            note <= "100";               
        elsif La = '1' then
            note <= "101";
        elsif Ti = '1' then
            note <= "110";
        else note <= "111"; -- play nothing
        end if;
    end process play;          
end Behavioral;
