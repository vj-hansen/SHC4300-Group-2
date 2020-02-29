LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY key_block_test IS

END key_block_test;

ARCHITECTURE key_block_test_arch OF key_block_test IS

CONSTANT CLK_PERIOD: time :=10 ns;

SIGNAL clk,clr,nxt: std_logic;
signal data_out: std_logic_vector(7 downto 0);
BEGIN
key_component: entity work.key_block(key_block_arch) port map(clk=>clk,clr=>clr,nxt=>nxt,data=>data_out);

clock: PROCESS
BEGIN
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;

END PROCESS;


io_test:PROCESS
BEGIN
    clr <= '0';
    nxt <= '0';
    wait for CLK_PERIOD;

    nxt <= '1';
    wait for CLK_PERIOD;


    nxt <= '0';
    wait for CLK_PERIOD;


    nxt <= '1';
    wait for CLK_PERIOD;


    nxt <= '0';
    wait for CLK_PERIOD;

END PROCESS;
END key_block_test_arch;
