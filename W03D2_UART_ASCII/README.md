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

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/W03D2_UART_ASCII/pics/uart.png" alt="drawing" width="450" height="125"/>



The transmission with 8 data bits, no parity, and 1 stop bit is shown in the figure above. The LSB of the data word is transmitted first. Before the transmission starts, the tx and rx must agree on a set of parameters in advance, which include the baud rate (e.g. 19200 bps), the number of data bits and stop bits, and use of the parity bit.

<img src="https://github.com/vjhansen/SHC4300-Group-2/blob/master/W03D2_UART_ASCII/pics/bd.png" alt="drawing" width="550" height="225"/>

>Figure above.

* Baud rate generator (mod-M counter): the circuit to generate the sampling ticks.
* UART receiver: the circuit to obtain the data word via oversampling.
* Interface circuit: the circuit that provides buffer and status between the UART receiver and the system that uses the UART.


---
#### Baud rate generator and oversampling procedure
The most commonly used sampling rate is 16 times the baud rate, which means that each serial bit is sampled 16 times.
The oversampling scheme basically performs the function of a clock signal. Instead of using the rising edge to indicate when the input signal is valid, it utilizes sampling ticks to estimate the middle point of each bit. While the receiver has no information about the exact onset time of the start bit, the estimation can be off by at most 1/16. 

The baud rate generator generates a sampling signal whose frequency is exactly 16 times the UART’s designated baud rate. For the 19200 baud rate, the sampling rate has to be 307200 (19200 * 16) ticks/s. Since the system clock rate is 100 MHz, the baud rate generator needs a mod-326 (100 MHz / 307200) counter, in which the one-clock-cycle tick is asserted once every 326 clock cycles.


```vhdl
----------------------------------------------------------------------------------
-- Listing 4.11 Mod-m counter
-- This baud-rate generator will generate sampling ticks

-- Frequency = 16x the required baud rate (16x oversampling)
-- 19200 bps * 16 = 307200 ticks/s
-- 100 MHz / 307200 = 325.52 = 326
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mod_m is
    generic ( N: integer := 9;     -- number of bits needed to count to M = 326
              M: integer := 326 ); -- mod-326 counter 

    port ( clk, rst:   in std_logic;
           to_s_tick:  out std_logic );
end mod_m;
----------------------------------------------------
architecture arch of mod_m is
    signal r_reg:   unsigned(N-1 downto 0);
    signal r_next:  unsigned(N-1 downto 0);
    signal q:       std_logic_vector(N-1 downto 0);
----------------------------------------------------
begin
    -- register
    process(clk, rst) begin
        if (rst = '1') then
            r_reg <= (others =>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next-state logic
    r_next <= (others => '0') when r_reg=(M-1) else r_reg+1;
    
    -- output logic
    q <= std_logic_vector(r_reg);
    to_s_tick <= '1' when r_reg=(M-1) else '0';
end arch;
```

---

#### UART RX SUBSYSTEM
Since no clock information is conveyed from the transmitted signal, rx can retrieve the data bits only by using the predetermined parameters. We use an oversampling scheme to estimate the middle points of transmitted bits and then retrieve them at these points accordingly.
```vhdl
----------------------------------------------------------------------------------
-- listing 7.1
-- UART receiver
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------
entity uart is
    generic (
        DBIT: integer := 8; -- data bits
        SB_TICK: integer := 16 ); -- ticks needed for 1 stop bit

    Port ( 
        clk, rst, rx, from_s_tick: in std_logic;
        rx_done_tick : out std_logic;
        to_dout : out std_logic_vector(7 downto 0) );
end uart;

architecture arch of uart is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type; -- current and next state
    signal s_reg, s_next : unsigned(3 downto 0); -- keep track of sampling ticks and count to 7 in the 'start' state
    signal n_reg, n_next : unsigned(2 downto 0); -- keep track of data bits received in the 'data' state
    signal b_reg, b_next : std_logic_vector(7 downto 0); -- (deserializes rx) retrieved bits are shifted into and reassembled in the 'b' register

----------------------------------------------------------------------------------
begin

-- State registers
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

-- next-state logic
    process(state_reg, s_reg, n_reg, b_reg, from_s_tick, rx)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= '0';
        case state_reg is 
------------------------------------------------------------                
            when idle =>
                if rx='0' then -- start bit
                    state_next <= start;
                    s_next <= (others=>'0');
                -- else stay idle
                end if;
------------------------------------------------------------                
            when start =>
                if (from_s_tick = '1') then
                    if s_reg=7 then -- incoming signal has reached the middle point of the start bit
                        state_next <= data;
                        s_next <= (others=>'0');
                        n_next <= (others=>'0');
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------                
            when data =>
                if (from_s_tick = '1') then
                    if s_reg=15 then -- incoming signal has reached the middle point of the first data bit
                        s_next <= (others => '0');
                        b_next <= rx & b_reg(7 downto 1); -- shift value of data bit into b-register
                        if n_reg=(DBIT-1) then -- all data bits retrieved
                            state_next <= stop;
                        else
                            n_next <= n_reg+1;
                        end if;
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------
            when stop =>
                if (from_s_tick = '1') then
                    if s_reg=(SB_TICK-1) then -- all stop bits obtained
                        state_next <= idle;
                        rx_done_tick <= '1';
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
        end case;
    end process;
    
    -- Output
    to_dout <= b_reg;
end arch;
```

---
#### Top module
```vhdl
----------------------------------------------------------------------------------
-- Top design module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port ( 
        clk, rst, rx : in std_logic;
        led :   out std_logic_vector(7 downto 0);
        sseg:   out std_logic_vector(6 downto 0);
        anode:  out std_logic_vector(3 downto 0)
        );
end top;
---------------------------------------------------------
architecture arch of top is
    signal s_tick, rx_done_tick:    std_logic;
    signal dout:                    std_logic_vector(7 downto 0);
begin

-- FSM controller
    FSM_Controller: entity work.fsm_controller(arch)
        port map (  from_dout=>dout, from_rx_done_tick=>rx_done_tick, 
                    to_led=>led );
---------------------------------------------------------
-- Baud generator
    Baud_Generator: entity work.mod_m(arch)
        port map (  clk=>clk, rst=>rst, to_s_tick=>s_tick );
---------------------------------------------------------
-- UART 
    UART: entity work.uart(arch)
        port map (  clk=>clk, rst=>rst, rx=>rx, to_dout=>dout,
                    from_s_tick=>s_tick, rx_done_tick=>rx_done_tick );
---------------------------------------------------------
-- ASCII to 7 segment display conversion
    ASCII_To_7SEG: entity work.ascii2sseg(arch)
        port map (  anode=>anode, sseg=>sseg, from_dout=>dout );
---------------------------------------------------------
end arch;
```

#### FSM Controller (just move this code into the top design module)
```vhdl
----------------------------------------------------------------------------------
-- FSM control path
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_controller is
    port ( 
        from_rx_done_tick: in std_logic;
        from_dout : in std_logic_vector(7 downto 0);
        to_led: out std_logic_vector(7 downto 0)
        );
end fsm_controller;
----------------------------------------------------------------------------------
architecture arch of fsm_controller is
begin
    -- Display ASCII from UART on Basys3 LEDs
    process(from_rx_done_tick) begin
        if (from_rx_done_tick = '1') then
            to_led <= from_dout;
        end if;
    end process;  
end arch;
```

#### ASCII to 7 segment display controller
```vhdl
----------------------------------------------------------------------------------
-- Listing 8.4
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ascii2sseg is
   port (
      from_dout: in std_logic_vector(7 downto 0);
      sseg: out std_logic_vector(6 downto 0);
      anode: out std_logic_vector(3 downto 0)
      );
end ascii2sseg;
----------------------------------------------------------------------------------
architecture arch of ascii2sseg is
begin
    anode <= "1110";
    with from_dout select
        sseg <=
        --abcdefg         ascii
        "0000001" when "00110000", -- 0
        "1001111" when "00110001", -- 1
        "0010010" when "00110010", -- 2
        "0000110" when "00110011", -- 3
        "1001100" when "00110100", -- 4
        "0100100" when "00110101", -- 5
        "0100000" when "00110110", -- 6
        "0001111" when "00110111", -- 7
        "0000000" when "00111000", -- 8
        "0001100" when "00111001", -- 9
        "0001000" when "01000001", -- A
        "1100000" when "01100010", -- b
        "0110001" when "01000011", -- C
        "1000010" when "01100100", -- d
        "0110000" when "01000101", -- E
        "0111000" when "01000110", -- F
        "1111111" when others; -- nothing
end arch;
```


**Source: FPGA Prototyping by VHDL Examples, Pong P. Chu**
