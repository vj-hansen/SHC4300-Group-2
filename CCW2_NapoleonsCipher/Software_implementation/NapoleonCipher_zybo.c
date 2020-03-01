/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#define MAX_TEXT_SIZE 200
#define CIPHER_KEY "victordeivyleilabiplav"
#define CIPHER_KEY_LEN 23
// Return the encrypted text generated with the help of the key
void cipherText(const char* plainText,char* encryptText) {
    char key[CIPHER_KEY_LEN] = CIPHER_KEY;
    int textCounter=0;
    int keyCounter=0;
    for (textCounter = 0; plainText[textCounter] != '\0' ; textCounter++) {
        int ciph = ((25-plainText[textCounter]) + key[keyCounter]) % 26;
        ciph = ciph + 'a';  // convert into ASCII, A = 65,a = '97'
	encryptText[textCounter] = (char)ciph;
	keyCounter++;
	keyCounter = keyCounter >22 ? 0: keyCounter;
    }
    encryptText[textCounter] = '\0';
    return;
}

// Decrypt the encrypted text and return the original text
void originalText(const char* encryptedText, char * plainText) {
    char key[CIPHER_KEY_LEN] = CIPHER_KEY;
    int textCounter=0;
    int keyCounter=0;
    for (textCounter = 0; encryptedText[textCounter] != '\0' ; textCounter++) {
        int ciph = ((25 + key[keyCounter] - encryptedText[textCounter]) ) % 26;
        ciph = ciph + 'a';  // convert into ASCII, A = 65,a = '97'
	plainText[textCounter] = (char)ciph;
	keyCounter++;
	keyCounter = keyCounter >22 ? 0: keyCounter;
    }
    plainText[textCounter] = '\0';
    return;
}

int main() {
    char text[MAX_TEXT_SIZE] = {'\0'};
    char convertedText[MAX_TEXT_SIZE] = {'\0'};
    char selection = '\0';
    while (1)
    {
	    while ( selection != 'e' && selection != 'd' && selection != 'q')
	    {
		    print("\r\nPress e for encrypt or d for decrypt , q for quit:");
		    scanf("%c",&selection);
	    }
	    //printf("selection is '%c'\n",selection);
	    if ( selection == 'q' )
	    {
		    return 0;
	    }
	    if (selection == 'e')
	    {
		    print("\r\nEnter the plain text:\r\n");
		    scanf("%s",text);
		    cipherText(text,convertedText);
		    print("\r\nThe plain text:\r\n");
		    print(text);
		    print("\r\nThe encrypted text:\r\n");
		    print(convertedText);
		    print("\r\n");
	    }
	    else if (selection == 'd')
	    {
		    print("\r\nEnter the encrypted text:\r\n");
		    scanf("%s",text);
		    originalText(text,convertedText);
		    print("\r\nThe encrypted text:\r\n");
		    print(text);
		    print("\r\nThe plain text:\r\n");
		    print(convertedText);
		    print("\r\n");
	    }
	    selection = '\0';
    }
    return 0;
    cleanup_platform();
}



