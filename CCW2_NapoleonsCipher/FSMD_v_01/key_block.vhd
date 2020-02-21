-- not connected to top.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity key_block is
   port(
      nxt,clk,clr: in std_logic;
      data: out std_logic_vector(7 downto 0)
   );
end key_block;


-- victordeivyleilabiplav
-- 01110110 01101001 01100011 01110100 01101111 01110010 01100100 01100101 01101001 01110110 01111001 01101100 01100101 01101001 01101100 01100001 01100010 01101001 01110000 01101100 01100001 01110110

architecture key_block_arch of key_block is

signal rom_addr: std_logic_vector(4 downto 0);
signal rom_data: std_logic_vector(7 downto 0);
signal rom_addr_cnt: unsigned ( 4 downto 0):= (others => '0');
begin
rom: entity work.key_rom(key_rom_arch) port map( data=>rom_data,addr=>rom_addr);

process (clk) begin
    if ( rising_edge(clk) ) then
        if clr = '1' then
            rom_addr_cnt <= (others => '0');
        elsif nxt = '1' then
            if rom_addr_cnt >= 21 then
                rom_addr_cnt <= (others => '0');
            else
                rom_addr_cnt <= rom_addr_cnt + 1;
            end if;
        end if;
    end if;

end process;
   data <= rom_data;
   rom_addr <=  std_logic_vector(rom_addr_cnt);
end key_block_arch;
