
Let A-Z be the numbers 0–25

* http://www.satya-weblog.com/tools/find-alphabets.php

Similar cipher: https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher


* Message: Make every day count
* Key: Jean Jacqu esR ousse
* Encryption: wdpi eexyv ars lfxek


| Message (M):     | M | A | K | E | = | 12 | 0 | 10 | 4   |
|---               |---|---|---|---|---|----|---|----|-----|
| Key (K):         | J | E | A | N | = | 9  | 4 | 0  | 13  | 
| Ciphertext (C):  | W | D | P | I | = | 22 | 3 | 15 | 8   |



### Encryption
position of C = ((25 - Position of M) + position of K) mod 26

<img src="https://latex.codecogs.com/svg.latex?\Large&space;C_i=((25-M_i)+K_i)\hspace{2mm}\textup{mod}\hspace{2mm}26" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />

Examples related to table shown above:
* ((25-12) + 9) mod 26 = 22 = 'W'
* ((25-0) + 4) mod 26 = 3 = 'D'
* ((25-10) + 0) mod 26 = 15 = 'P'
* ((25-4) + 13) mod 26 = 8 = 'I'


### Decryption
position of M = ((25 + position of K) - position of C) mod 26
