/*
 * C code to implement Napoleon Cipher
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 * based on: https://www.thecrazyprogrammer.com/2017/08/vigenere-cipher-c-c.html
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

// add option for mode selection (encode or decode).

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xil_assert.h"
#include "xuartps_hw.h"

#define MAX_LIMIT 20
#define BUFFER_SIZE 16

unsigned char RecByte; //8-bit received from keyboard
u32 running;
u8 data_buffer[] = {};

int main() {
	char msg[MAX_LIMIT];
	char key[] = "JEAN";

	char array[1][20];

    int msglen = strlen(msg);
    int keylen = strlen(key);
    int i,j;

    char newKey[msglen];
    char ciphertext[msglen];
    char decryptedtext[msglen];

    xil_printf("Napoleon Cipher\n");

	//RecByte = XUartPs_RecvByte (XPAR_PS7_UART_1_BASEADDR);

    running = TRUE;
    while(running) { // while not receiving '+'
		// waits for new  to be received
		//RecByte = XUartPs_RecvByte (XPAR_PS7_UART_1_BASEADDR); // this receives bytes
    	while (!XUartPs_IsReceiveData(XPAR_PS7_UART_1_BASEADDR));
    	RecByte = XUartPs_ReadReg(XPAR_PS7_UART_1_BASEADDR, XUARTPS_FIFO_OFFSET);

    	xil_printf("%c",RecByte);

    	if ((RecByte >= 'a') && (RecByte <='z')) {
    			strcpy(msg, RecByte);
    			puts(msg); // not good
    	}

    	if('1' == RecByte) {
    		running = FALSE;
    	}

    	//XUartPs_WriteReg(XPAR_PS7_UART_1_BASEADDR,  XUARTPS_FIFO_OFFSET, RecByte); // write to terminal

    	//xil_printf("%s", msg);
    }

    //printf("Original msg: %s", msg);


    // Generate key in a cyclic manner until it's length is equal to the length of original text
    for(i=0, j=0; i < msglen; ++i, ++j) {
    	if(j=keylen) {
    		j = 0;
    	}
    	newKey[i] = key[j];
    }
    newKey[i] = '\0'; // terminate string with null-char


    // Return the encrypted text generated with the help of the key
    for(i=0; i<msglen; ++i) {
    	ciphertext[i] = ((25-msg[i] + key[i]) % 26) + 'A'; // convert into ASCII, A = 65
    }
    ciphertext[i] = '\0';


    // Decrypt the encrypted text and return the original text
     for(i=0; i<msglen; ++i) {
     	decryptedtext[i] = ((25+key[i]-ciphertext[i]) % 26) + 'A'; // convert into ASCII, A = 65
     }
     decryptedtext[i] = '\0';

    //printf("\nKey: %s", key);
    //printf("\nCiphertext: %s", ciphertext);
    //printf("\nDecrypted msg: %s", decryptedtext);

   return 0;
}
