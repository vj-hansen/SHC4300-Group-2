### W03 Jan 29 (D2) Receive ASCII codes via RS232 and display them on the Basys-3 leds

>The objective of this assignment is to display in the Basys-3 leds the ASCII codes received via RS232. The same cable that is used to bring power to the board and to program the FPGA, can also be used to receive serial data from the computer (and also to transmit it, if necessary). Since the connection is already there, all that you have to do is to implement an FSMD that comprises a UART and the appropriate interface circuits to drive the leds. Once that circuit is implemented, a terminal emulator program can be used to send to the board the ASCII codes of any key pressed in the keyboard.

You may consider the following building blocks for this purpose:

* mod-M counter (used for building the baud rate generator)
* UART (receiver block, interface circuit)


**Tasks:**

* Create a Vivado project comprising for the UART and simulate to make sure that everything is correct.
* Program the FPGA, and use HyperTerminal or PuTTY to set up the serial communication channel for 19200 bps, 1 stop bit, no parity, and flow control =  “None”

You should now see the Basys-3 leds displaying the ASCII codes of any keys pressed in your keyboard (compare the binary patterns at the leds with the ASCII table at http://www.asciitable.com/

---

*Universal asynchronous receiver and transmitter* (UART) is a circuit that sends parallel data through a serial line. 
A UART includes a transmitter and a receiver. The transmitter is essentially a special shift register that loads data in parallel and then shifts it out bit by bit at a specific rate. The receiver, on the other hand, shifts in data bit by bit and then reassembles the data. The serial line is ’1’ when it is idle. The transmission starts with a start bit, which is ’O’, followed by data bits and an optional parity bit, and ends with stop bits, which are ’1’. The number of data bits can be 6,7, or 8. The optional parity bit is used for error detection. For odd parity, it is set to ’0’when the data bits have an odd number of 1’s. For even parity, it is set to ’0’ when the data bits have an even number of 1’s. The number of stop bits can be 1, 1.5, or 2.

The transmission with 8 data bits, no parity, and 1 stop bit is shown in the figure below. Note that the LSB of the data word is transmitted first. No clock information is conveyed through the serial line. Before the transmission starts, the transmitter and receiver must agree on a set of parameters in advance, which include the baud rate (i.e., number of bits per second), the number of data bits and stop bits, and use of the parity bit. The commonly used baud rates are 2400, 4800, 9600, and 19,200 bps.


<img src="https://github.com/vjhansen/SHC4300-W03_D2_D4-group/blob/master/pics/uart.png" alt="drawing" width="450" height="125"/>



<img src="https://github.com/vjhansen/SHC4300-W03_D2_D4-group/blob/master/pics/bd.png" alt="drawing" width="550" height="225"/>


#### UART RECEIVING SUBSYSTEM
Since no clock information is conveyed from the transmitted signal, the receiver can retrieve the data bits only by using the predetermined parameters. We use an oversampling scheme to estimate the middle points of transmitted bits and then retrieve them at these points accordingly.
