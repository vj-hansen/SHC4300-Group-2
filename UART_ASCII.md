### W03 Jan 29 (D2) Receive ASCII codes via RS232 and display them on the Basys-3 leds

The objective of this assignment is to display in the Basys-3 leds the ASCII codes received via RS232. The same cable that is used to bring power to the board and to program the FPGA, can also be used to receive serial data from the computer (and also to transmit it, if necessary). Since the connection is already there, all that you have to do is to implement an FSMD that comprises a UART and the appropriate interface circuits to drive the leds. Once that circuit is implemented, a terminal emulator program can be used to send to the board the ASCII codes of any key pressed in the keyboard.



You may consider the following building blocks for this purpose:

* In attachment: The VHDL descriptions of the mod-M counter (listing 4.11, used for building the baud rate generator), and of the UART (listings 7.1 for the receiver block; 7.2 for the interface circuit; and 7.4 for the whole UART integrating the previous blocks).
* Available online: The HyperTerminal terminal emulator or PuTTY.
 

Your tasks are as follows:

* Create a Vivado project comprising the VHDL files indicated above, make the necessary modifications in the original descriptions, and simulate to make sure that everything is correct.
* Generate the *.bit file and program the FPGA.
* Use HyperTerminal or PuTTY to set up the serial communication channel for 19200 bps, 1 stop bit, no parity, and flow control =  “None” (make sure that you’re using the right virtual COM port).

You should now see the Basys-3 leds displaying the ASCII codes of any keys pressed in your keyboard (compare the binary patterns at the leds with the ASCII table at http://www.asciitable.com/
