library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------
entity read_ROM is
   port ( clk              : in std_logic;
          from_clr_data_in : in std_logic;
          from_inc_data_in : in std_logic;
          rom_done         : out std_logic;
          to_data_in_bus   : out std_logic_vector(7 downto 0) );
end read_ROM;
------------------------------------------
architecture arch of read_ROM is
    signal rom_addr     : std_logic_vector(4 downto 0);
    signal rom_data     : std_logic_vector(7 downto 0);
    signal rom_addr_cnt : unsigned(4 downto 0):= (others => '0');
begin
------------------------------------------
    rom: entity work.unsort_rom(arch) 
        port map ( data=>rom_data, addr=>rom_addr );
------------------------------------------
    process(clk) begin
        if rising_edge(clk) then
            if from_clr_data_in = '1' then
                rom_addr_cnt <= (others => '0');
            elsif from_inc_data_in = '1' then
                if rom_addr_cnt >= 15 then
                    rom_done <= '1';
                    rom_addr_cnt <= (others => '0');
                else
                    rom_addr_cnt <= rom_addr_cnt + 1;
                end if;
            end if;
        end if;
    end process;
------------------------------------------
    to_data_in_bus <= rom_data;
    rom_addr <= std_logic_vector(rom_addr_cnt);
end arch;