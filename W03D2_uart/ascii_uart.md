### W03 Jan 29 (D2) Receive ASCII codes via RS232 and display them on the Basys-3 leds

**Tasks:**

* Create a Vivado project for the UART and simulate to make sure that everything is correct.
* Program the FPGA, and use HyperTerminal or PuTTY to set up the serial communication channel for 19200 bps, 1 stop bit, no parity, and flow control = "None"

>You should now see the Basys-3 leds displaying the ASCII codes of any keys pressed on your keyboard.

---

*Universal asynchronous receiver and transmitter* (UART) is a circuit that sends parallel data through a serial line. 
A UART includes a transmitter (tx) and a receiver (rx). The transmitter is a special shift register that loads data in parallel and then shifts it out bit by bit at a specific rate. The receiver shifts in data bit by bit and then reassembles the data. 

* The serial line is '1' when it is idle. 
* The transmission starts with a start bit, which is '0', followed by data bits and an optional parity bit, and ends with stop bits, which are '1'. 
* The number of data bits can be 6, 7, or 8. 
* The optional parity bit is used for error detection. For odd parity, it is set to ’0’ when the data bits have an odd number of 1’s. For even parity, it is set to ’0’ when the data bits have an even number of 1’s.

<img src="https://github.com/vjhansen/SHC4300-W03_D2_D4-group/blob/master/D2_uart/pics/uart.png" alt="drawing" width="450" height="125"/>



The transmission with 8 data bits, no parity, and 1 stop bit is shown in the figure above. The LSB of the data word is transmitted first. Before the transmission starts, the tx and rx must agree on a set of parameters in advance, which include the baud rate (e.g. 19200 bps), the number of data bits and stop bits, and use of the parity bit.

<img src="https://github.com/vjhansen/SHC4300-W03_D2_D4-group/blob/master/D2_uart/pics/bd.png" alt="drawing" width="550" height="225"/>

>Figure above.

* UART receiver: the circuit to obtain the data word via oversampling
* Baud rate generator (mod-M counter): the circuit to generate the sampling ticks
* Interface circuit: the circuit that provides buffer and status between the UART receiver and the system that uses the UART

#### UART RX SUBSYSTEM
Since no clock information is conveyed from the transmitted signal, rx can retrieve the data bits only by using the predetermined parameters. We use an oversampling scheme to estimate the middle points of transmitted bits and then retrieve them at these points accordingly.
```vhdl
-- UART receiver (listing 7.1)
------------------------------------------------------------
entity uart_rx is
    generic (   DBIT: integer := 8; -- data bits
                SB_TICK: integer := 16 ); -- ticks for stop bits

    port (  clk, rst, rx, s_tick: in std_logic;
            rx_done_tick: out std_logic;
            dout: out std_logic_vector(7 downto 0) );
end uart_rx;
------------------------------------------------------------
architecture arch of uart_rx is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next: state_type;      -- current and next state
    signal s_reg, s_next: unsigned(3 downto 0);    -- keep track of sampling ticks and count to 7 in the 'start' state
    signal n_reg, n_next: unsigned(2 downto 0);    -- keep track of data bits received in the 'data' state
    signal b_reg, b_next: std_logic_vector(7 downto 0); -- deserializes rx
    -- retrieved bits are shifted into and reassembled in the 'b' register
begin
------------------------------------------------------------
-- FSMD state and data registers
    process(clk, rst) begin
        if rst = '1' then
            state_reg <= idle;
            s_reg <= (others => '0');
            n_reg <= (others => '0');
            b_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;
------------------------------------------------------------    
-- next-state logic and data path functional routing
    process(state_reg, s_reg, n_reg, b_reg, s_tick, rx)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= '0';
        case state_reg is 
            when idle =>
                if rx='0' then -- start bit
                    state_next <= start;
                    s_next <= (others=>'0');
                -- else stay idle
                end if;
------------------------------------------------------------                
            when start =>
                if (s_tick = '1') then
                    if s_reg=7 then
                        state_next <= data;
                        s_next <= (others=>'0');
                        n_next <= (others=>'0');
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------                
            when data =>
                if (s_tick = '1') then
                    if s_reg=15 then -- read RxD, feed its value to deserializer, restart counter
                        s_next <= (others => '0');
                        b_next <= rx & b_reg(7 downto 1); -- b = rx & (b >> 1)
                        if n_reg=(DBIT-1) then
                            state_next <= stop;
                        else
                            n_next <= n_reg+1;
                        end if;
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------
            when stop => --
                if (s_tick = '1') then
                    if s_reg=(SB_TICK-1) then
                        state_next <= idle;
                        rx_done_tick <= '1';
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
        end case;
    end process;
    dout <= b_reg;
end arch;
```


---
#### Baud rate generator and oversampling procedure
The most commonly used sampling rate is 16 times the baud rate, which means that each serial bit is sampled 16 times.
The oversampling scheme basically performs the function of a clock signal. Instead of using the rising edge to indicate when the input signal is valid, it utilizes sampling ticks to estimate the middle point of each bit. While the receiver has no information about the exact onset time of the start bit, the estimation can be off by at most 1/16. 

The baud rate generator generates a sampling signal whose frequency is exactly 16 times the UART’s designated baud rate. For the 19200 baud rate, the sampling rate has to be 307200 (19200 * 16) ticks/s. Since the system clock rate is 100 MHz, the baud rate generator needs a mod-326 (100 MHz / 307200) counter, in which the one-clock-cycle tick is asserted once every 326 clock cycles.


```vhdl
-- Mod-M counter (listing 4.11)

entity mod_m is
    generic (   N: integer := 9;    -- num of bits
                M: integer := 326 ); -- mod-326 counter 

-- Frequency = 16x the required baud rate (16x oversampling)
-- 19200 bps * 16 = 307200 ticks/s
-- 100 MHz / 307200 = 325.52 = 326

    port (  clk, rst: in std_logic;
            max_tick: out std_logic;
            q: out std_logic_vector(N-1 downto 0) );
end mod_m;
------------------------------------------
architecture arch of mod_m is
    signal r_reg: unsigned(N-1 downto 0);
    signal r_next: unsigned(N-1 downto 0);
begin
    -- register
    process(clk, rst) begin
        if (rst = '1') then
            r_reg <= (others=>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
   
    -- next-state logic
    r_next<=(others=>'0') when r_reg=(M-1) else r_reg+1; --
    
    -- output logic
    q<=std_logic_vector(r_reg); --
    max_tick<='1' when r_reg=(M-1) else '0'; --
end arch;
```

---
#### Top module
```vhdl
---------------------------------------------------------
entity top is
    -- 19200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
    generic (   DBIT : integer := 8;
                SB_TICK : integer := 16; -- 16 ticks for 1 stop bit
                DVSR : integer := 326;  -- baud rate divisor (= 100M/(16*baud rate))
                DVSR_BIT: integer := 9 ); -- bits of DVSR
    
    port (  clk, rst: in std_logic;
            rd_uart, wr_uart, rx: in std_logic;
            w_data: in std_logic_vector(7 downto 0);
            led: out std_logic_vector(7 downto 0) );
end top;
---------------------------------------------------------
architecture Behavioral of top is
    signal tick, rx_done_tick: std_logic;
    signal rx_data_out: std_logic_vector(7 downto 0);
begin
---------------------------------------------------------
    baud_gen_unit: entity work.mod_m(arch)
        generic map ( M=>DVSR, N=>DVSR_BIT )
        port map ( clk=>clk, rst=>rst, q=>open, max_tick=>tick ); -- 'open'-keyword = q is an unused signal
---------------------------------------------------------
    uart_rx_unit: entity work.uart_rx(arch)
        generic map ( DBIT=>DBIT, SB_TICK=>SB_TICK )
        port map (  clk=>clk, rst=>rst, rx=>rx, s_tick=>tick, 
                    rx_done_tick=>rx_done_tick,
                    dout=>rx_data_out );
---------------------------------------------------------
    process(rx_done_tick) begin
        if (rx_done_tick='1') then
            led <= rx_data_out; -- set LEDs when all data bits are received
        end if;
    end process;  
end Behavioral;
```




Source: FPGA Prototyping by VHDL Examples, Pong P. Chu