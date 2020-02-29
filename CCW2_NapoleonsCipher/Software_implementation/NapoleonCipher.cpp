// C++ code to implement Napoleon Cipher 

// clang++ -std=c++11 -stdlib=libc++ VigenereCipher.cpp

#include <cstdlib> 
#include <string>
#include <iostream>
using namespace std; 
  
// Generate the key in a cyclic manner until it's length is equal to the length of original text 
string generateKey(string msg, string key) { 
    int msg_len = msg.size();
    for (int i = 0; ; i++) { 
        if (msg_len == i) 
            i = 0; 
        if (key.size() == msg.size()) 
            break; 
        key.push_back(key[i]); 
    } 
    return key; 
} 
  
// Return the encrypted text generated with the help of the key 
string cipherText(string msg, string key) { 
    string cipher_text; 
    for (int i = 0; i < msg.size(); i++) { 
        int ciph = ((25-msg[i]) + key[i]) % 26; 
        ciph = ciph + 'A';  // convert into ASCII, A = 65
        cipher_text.push_back(ciph); 
    } 
    return cipher_text; 
} 
  
// Decrypt the encrypted text and return the original text 
string originalText(string cipher_text, string key) { 
    string orig_text; 
    for (int i = 0 ; i < cipher_text.size(); i++) { 
        int msg = (25 + key[i] - cipher_text[i]) % 26; 
        msg = msg + 'A'; // convert into ASCII
        orig_text.push_back(msg); 
    } 
    return orig_text; 
} 
   
int main() { 
    string msg = "MAKEEVERYDAYCOUNT"; 
    string keyword = "JEANJACQUESROUSSE"; 
    string key = generateKey(msg, keyword); 
    string cipher_text = cipherText(msg, key); 
    cout << "Ciphertext : " << cipher_text << "\n"; 
    cout << "Original/Decrypted Text : " << originalText(cipher_text, key) << endl; 
    return 0; 
} 