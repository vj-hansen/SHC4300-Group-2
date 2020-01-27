### W03 Jan 29 (D2) Receive ASCII codes via RS232 and display them on the Basys-3 leds

>The objective of this assignment is to display in the Basys-3 leds the ASCII codes received via RS232. The same cable that is used to bring power to the board and to program the FPGA, can also be used to receive serial data from the computer (and also to transmit it, if necessary). Since the connection is already there, all that you have to do is to implement an FSMD that comprises a UART and the appropriate interface circuits to drive the leds. Once that circuit is implemented, a terminal emulator program can be used to send to the board the ASCII codes of any key pressed in the keyboard.

You may consider the following building blocks for this purpose:

* mod-M counter (used for building the baud rate generator)
* UART (receiver block, interface circuit)


Tasks:

* Create a Vivado project comprising for the UART and simulate to make sure that everything is correct.
* Program the FPGA, and use HyperTerminal or PuTTY to set up the serial communication channel for 19200 bps, 1 stop bit, no parity, and flow control =  “None”

You should now see the Basys-3 leds displaying the ASCII codes of any keys pressed in your keyboard (compare the binary patterns at the leds with the ASCII table at http://www.asciitable.com/


*Universal asynchronous receiver and transmitter* (UART) is a circuit that sends parallel data through a serial line. 



<img src="https://github.com/vjhansen/SHC4300-W03_D2_D4-group/blob/master/pics/uart.png" alt="drawing" width="450" height="125"/>











<img src="https://github.com/vjhansen/SHC4300-W03_D2_D4-group/blob/master/pics/bd.png" alt="drawing" width="550" height="225"/>
