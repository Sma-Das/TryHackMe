# Notes on the cryptography section in THM
### https://tryhackme.com/room/encryptioncrypto101

### Terms:
    - Ciphertext: encrypted plaintext
    - Cipher: Method of decrypting data
        - Modern ciphers are cryptographic, meaning that they satisfy a number of conditions such as:
            - Deterministic, one input, one hash
            - Quick
            - One way, difficult to reverse the hash
            - Butterfly/Avalanche Effect, one small change changes the whole cipher
            - Collion resistant, two messages with the same hash should not be possible
            - Pre-image attack resistant, meaning that it is computationally difficult to find x from H(x) = y 
                - Second image resistant too where x != x' given H(x) == H(x')


### Types of Encryption

* Symmetric: same key for encryption and decryption eg DES and AES
* Asymmetric: different keys for encryption and decryption. eg RSA and Elliptic Curve Cryptography 
    - Asymmetric Encryption is difficult to crack because of the intricate math behind it

* RSA Encryption
    - Based on the fact it is easier to multiply two prime numbers than to factor the product of it
    - Check RSA.md for a full explaination
