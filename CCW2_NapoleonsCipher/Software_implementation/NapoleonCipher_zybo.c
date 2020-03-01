/****************************************************************************
		Group 2: Biplav, Deivy, Leila, Victor

* @file     NapoleonCipher_zybo.c
*
* This file contains the implementation of the Napoleon Cipher.
*
* Usage:
* 	0) Connect to Zybo to computer via USB
* 	1) Xilinx > Program FPGA > Program
* 	2) Open the SDK Terminal in Xilinx SDK
* 	2.1) Press '+' > Select COM-port > Keep default values under 'Advanced Settings' > ok
* 	3) Right-click on 'Napoleon_Cipher'-folder > Run as > 1 Launch on Hardware (system debugger)
* 	4) SDK Terminal > encode/decode your message
****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define MAX_TEXT_SIZE 200
#define CIPHER_KEY "victordeivyleilabiplav"
#define CIPHER_KEY_LEN 23   // should find a better solution for this, cant use strlen() though...



/***************************************************************************
* Return the encrypted text generated with the help of the key
*
* @param	Original text and Cipher text
*
* @return	Cipher text
****************************************************************************/
void encode(const char* plainText,char* encryptText) {
    char key[CIPHER_KEY_LEN] = CIPHER_KEY;
    int textCounter, keyCounter = 0;
    for (textCounter = 0; plainText[textCounter] != '\0'; textCounter++) {
	int ciph = ((25-plainText[textCounter]) + key[keyCounter]) % 26;
       	ciph = ciph + 'a';  // convert into ASCII, A = 65, a = '97'
	encryptText[textCounter] = (char)ciph;
	keyCounter++;
	keyCounter = keyCounter >22 ? 0: keyCounter;
    }
    encryptText[textCounter] = '\0';
    return;
}

/***************************************************************************
* Decrypt the encrypted text and return the original text
*
* @param	Cipher text and original text
*
* @return	Original text
****************************************************************************/
void decode(const char* encryptedText, char* plainText) {
    char key[CIPHER_KEY_LEN] = CIPHER_KEY;
    int textCounter, keyCounter = 0;
    for (textCounter = 0; encryptedText[textCounter] != '\0'; textCounter++) {
        int ciph = ((25 + key[keyCounter] - encryptedText[textCounter]) ) % 26;
        ciph = ciph + 'a';  // convert into ASCII, A = 65, a = '97'
	plainText[textCounter] = (char)ciph;
	keyCounter++;
	keyCounter = keyCounter >22 ? 0: keyCounter;
    }
    plainText[textCounter] = '\0';
    return;
}

/***************************************************************************
* Main function to either decode or encode text
*
* @param	None
*
* @return	None
****************************************************************************/
int main() {
    char text[MAX_TEXT_SIZE] = {'\0'};
    char convertedText[MAX_TEXT_SIZE] = {'\0'};
    char selection = '\0';
    while (1) {
	    while (selection != 'e' && selection != 'd' && selection != 'q') {
		printf("\n****Napoleon Cipher****\nPress 'e' for encrypt or 'd' for decrypt , 'q' for quit:");
		scanf("%c", &selection);
	    }
	    if (selection == 'q') {
	    	print("\nFinished...");
		return 0;
	    }
	    if (selection == 'e') { // - Encode
		print("\r\nEnter the plain text:\r\n");
		scanf("%s", text);
		encode(text, convertedText);
		print("\r\nThe plain text:\r\n");
		print(text);
		print("\r\nThe encrypted text:\r\n");
		print(convertedText);
		print("\r\n");
	    }
	    else if (selection == 'd') { // - Decode
		print("\r\nEnter the encrypted text:\r\n");
		scanf("%s", text);
		decode(text, convertedText);
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
