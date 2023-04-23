+++
title = "Security II"
date = 2022-07-07T16:05:00+05:30
weight = 6
+++

## Cryptography Basics
The goal of cryptography is to take an input and produce a difficult to inverse output. In the process, we aim to achieve confidentiality, integrity, non-repudiation, and authentication.

```txt
Confidentiality - only the person for whom the information is intended can read it

Integrity - data is not tampered with during transmission

Non-repudiation - the sender can't deny intention of sending data at a later stage

Authentication - the identity of the sender is confirmed
```

### Terminology
```txt
hash function
hash
key
collision
salt
digest
encryption
decryption
cipher
plaintext
ciphertext
nonce
```

## Keyless Cryptography (Hash Function)
We don't use any keys here, just a collision-resistant **one-way** hash function that takes in a message and produces a single deterministic fixed-size output.

![](https://i.imgur.com/7TUsIlL.png)

Ex - `BLAKE2`, `MD5`, `SHA256`, etc...

Uses - For verifying file integrity and hashing passwords for storage.

## Symmetric Cryptography
Also known as _private-key_ or _secret-key_ cryptography. It uses only one key that is used for both encryption and decryption (so its **two-way**) and the key must be transmitted over a trusted channel.

Ex - `HMAC`, `DES`, `AES`, etc...

Uses - For checking file integrity and hashing passwords for storage.

It can be used both for authentication (HMAC) and encryption.

### Password Hashing
Always hash passwords when storing them in a database so that they can't be read by anyone dealing with the code or the database.

Password hashing hash functions like [bcrpyt](https://en.wikipedia.org/wiki/Bcrypt) and [scrypt](https://en.wikipedia.org/wiki/Scrypt) are **designed to be slow** by deliberately making it use large amount of memory. 

We couldn't have used SHA-2 or SHA-3 family for hashing passwords because they are one-way. And other fast two-way algorithms can't be used because we don't want attackers to be fast in performing a Dictionary attack and guessing our password.

It also uses a random salt for hashing which is a random string that is appended to the password string and then hash function is applied over the composite string. We can have diff salts for diff users.

scrpyt is in theory _faster_ than bcrypt and is used in some cryptocurrencies. bcrypt, on the other hand is realiable.

### SHA Family
 Secure Hash Algorithms (SHA) are a family of heavily standardized cryptographic hash functions.

- `SHA-0`: published in 1993, withdrawn shortly after due to an undisclosed "significant flaw"
- `SHA-1`: considered insecure since 2010
- `SHA-2`: a set of algorithms like SHA-256 and SHA-512. They are is still secure and widely used
- `SHA-3`: a set of algorithms; very secure and fast

### MD5
It has been proven to be highly collision prone long back (in 1996) and it is even possible to [come up with collisions in a few seconds](https://en.wikipedia.org/wiki/MD5#:~:text=A%20collision%20attack%20exists%20that%20can%20find%20collisions%20within%20seconds%20on%20a%20computer%20with%20a%202.6%C2%A0GHz%20Pentium%204%20processor%20(complexity%20of%20224.1)).

It still continues to be used widely today. Don't use it anywhere. Period.

## Asymmetric Cryptography
Also known as _public-key_ cryptography. The sender uses two keys here - one private and one public. The keys are such that the message encrypted by public key can be decoded only by the corresponding private key.

Public key - can be distributed publically

Private key - secret

We can distribute the public key and people can encrypt messages with it and send to us that we decrypt using the private key.

In some systems like RSA, the private key can be used to encrypt and then public key can be used to decrypt. This is often done to check digital signatures (since they're signed by private key).

Ex - `RSA`, `PGP`, etc...

### Shared Secret Key Agreement (Key Exchange)
Public-key cryptography is slower than private-key cryptography. To make it better we can generate a single shared key.

Sender sends their public key to Receiver and vice-versa. They both combine their private key with other's public key and end up with a exactly the same key that they can use to encrypt and decrypt.

![](https://i.imgur.com/QGxQlnq.png)

Both the parties have to agree on a common generator (`g`) beforehand and it is changed for every connection. Also, in the above image, the operation is not exponentiation as the notation implies and it should be theoretically impossible to separate `x` and `g` from `g^x`.  

Ex - `Diffie-Hellman` key exchange. Two variants - DH and ECDH (Elliptic-curve Diffie-Hellman)

[Reference](https://crypto.stackexchange.com/questions/6307/why-is-diffie-hellman-considered-in-the-context-of-public-key-cryptography)

### Digital Signatures
Encrypted using private key, decrypt using public key.

A digital signature is calculated by encrypting a message (often the public key itself) with a private key. Anyone else with a copy of the public key can verify that a particular message was signed by private key. By using that public key to decrypt the digital signature and the output will be a public key, and we can check if they match.

Ex - `EdDSA`

Uses - [TLS Certificates](/web-api/security-3/#certificates-and-ca)

## Encoding & Compression
Often keyless and always designed to be reversible by nature and not cryptographic as the output doesn't need to be hidden from a third party.

Encoding - `Base64`

Compression - `gzip`

Ex - Videos are often encoded and compresssed, but not encrypted.

## References
- [You Wouldn't Base64 a Password - Cryptography Decoded](https://paragonie.com/blog/2015/08/you-wouldnt-base64-a-password-cryptography-decoded#secret-key-encryption)
- [Hashing in Action: Understanding bcrypt - auth0](https://auth0.com/blog/hashing-in-action-understanding-bcrypt/)