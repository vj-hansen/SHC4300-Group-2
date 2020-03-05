/****************************************************************************
        Group 2: Biplav, Deivy, Leila, Victor
* @file     NapoleonCipher_zybo.c
*
* This file contains the implementation of the Napoleon Cipher.
*
* Usage:
*   0) Start Xilinx SDK. Connect Zybo to computer via USB.
*   1) Go to Xilinx > Program FPGA > Program
*   2) Open SDK Terminal
*   2.1) Press '+' > Select COM-port > Keep default values under 'Advanced Settings' > ok
*   3) Right-click on 'Napoleon_Cipher'-folder > Run as > 1 Launch on Hardware (system debugger)
*   4) Go to SDK Terminal > encode/decode your message
****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define MAX_TEXT_SIZE 200
#define CIPHER_KEY_2 "jeanjacquesrousseau"
#define cipher_key_len 23

/***************************************************************************
* Return the encrypted text generated with the help of the key
* @param    Original text and Cipher text
* @return   Cipher text
****************************************************************************/
void encode(const char* plainText, char* encryptText) {
    char key[cipher_key_len] = CIPHER_KEY_2;
    int textCounter, keyCounter = 0;
    for (textCounter = 0; plainText[textCounter] != '\0'; textCounter++) {
        int ciph = ( (25-plainText[textCounter]+key[keyCounter]) % 26)+97; // 'a' = 97
        encryptText[textCounter] = (char)ciph;
        keyCounter++;
        keyCounter = (keyCounter > strlen(CIPHER_KEY_2)-1) ? 0 : keyCounter; // keyCounter = 0 if keyCounter > key length, else keyCounter = keyCounter
    }
    encryptText[textCounter] = '\0';
    return;
}

/***************************************************************************
* Decrypt the encrypted text and return the original text
* @param    Cipher text and original text
* @return   Original text
****************************************************************************/
void decode(const char* encryptedText, char* plainText) {
    char key[cipher_key_len] = CIPHER_KEY_2;
    int textCounter, keyCounter = 0;
    for (textCounter = 0; encryptedText[textCounter] != '\0'; textCounter++) {
        int ciph = ( (25 + key[keyCounter] - encryptedText[textCounter]) % 26)+97;
        plainText[textCounter] = (char)ciph;
        keyCounter++;
        keyCounter = (keyCounter > strlen(CIPHER_KEY_2)-1) ? 0: keyCounter;
    }
    plainText[textCounter] = '\0';
    return;
}

/***************************************************************************
* Main function to either decode or encode text
* @param    None
* @return   None
****************************************************************************/
int main() {
    char text[MAX_TEXT_SIZE] = {'\0'};
    char convertedText[MAX_TEXT_SIZE] = {'\0'};
    char selection = '\0';

    while (1) {
        while (selection != 'e' && selection != 'd' && selection != 'q') {
            printf("\n\t\t****Napoleon Cipher****\nEnter 'e' for encrypt | 'd' for decrypt | 'q' for quit: "); // this prints twice after first selection
            scanf("%c", &selection);
        }
        if (selection == 'q') {
            printf("\nFinished...\n");
            return 0;
        }
        if (selection == 'e') { // - Encode
            printf("\r\nEnter the plain text (no space between words):\r\n");
            scanf("%s", text);
            encode(text, convertedText);
            printf("\r\nThe plain text:\r\n");
            printf("\t %s", text);
            printf("\r\nThe encrypted text:\r\n");
            printf("\t %s", convertedText);
            printf("\r\n");
        }
        else if (selection == 'd') { // - Decode
            printf("\r\nEnter the encrypted text:\r\n");
            scanf("%s", text);
            decode(text, convertedText);
            printf("\r\nThe encrypted text:\r\n");
            printf("\t %s", text);
            printf("\r\nThe plain text:\r\n");
            printf("\t %s", convertedText);
            printf("\r\n");
        }
        selection = '\0';
    }
    return 0;
}
