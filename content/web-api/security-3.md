+++
title = "Security III"
date = 2022-07-07T19:40:00+05:30
weight = 7
+++

## TLS
Transport Layer Security is an cryptographic protocol used to provide security over a network. It is a successor to the now-deprecated Secure Sockets Layer (SSL).

It serves encryption to higher layers, which is normally the function of the _presentation layer_. However, applications generally use TLS as if it were a _transport layer_. It actually runs in the _application layer_ though.

TLS 1.2 is widely used today and TLS 1.3 is newer, faster and better but supported by lesser number of servers.

TLS uses [Diffie-Hellman key exchange](/web-api/security-2/#shared-secret-key-agreement-key-exchange) to generate a shared private key on both the client and the server. This way we can even exchange keys over an untrusted channel. It does so because asymmetric cryptography is slower than symmetric, and by doing so we use only one key. 

Both the client and the server have to agree on: **a generator** to generate public keys and **a cipher** to encrypt data with.

Steps in TLS 1.2 connection establishment:
1. [TCP 3-way Handshake](/web-api/http/#3-way-handshake)
2. Client Hello
3. Server Hello
4. Change cipher spec (Client -> Server)
5. Client starts sending data (GET request)

Steps 2-4 are called **TLS Handshake**. In TLS 1.3, there is no step 4, the server sends the _Change cipher spec_ along with _Server hello_ itself.

**Client Hello**: lists ciphers client supports, and other info

**Server Hello**: lists ciphers server supports, and other info like supported HTTP version ([ALPN](https://en.wikipedia.org/wiki/Application-Layer_Protocol_Negotiation))

There is `ACK` for every step above, and TLS Handshake happens over TLS protocol and not TCP.

The TLS Handshake can fail if client and the server can't agree on a cipher to use for further communication.

### TLS Certificate and CA
The server sends the client a certificate in _Server hello_. 

The server had earlier sent its public key to a third-party called Certificate Authority (CA). The certificate contains a **digital signature** and the **public key of the server**. Digital signature is obtained by encrypting public key of the server with private key of the CA. Also, public keys of all major CAs come pre-installed on all OS generally. 

When the client receives the certificate, it uses public key of the CA to verify the digital signature on the certificate (decrypts digital signature on the certificate and matches it with public key on the certificate and public key of the server it's hoping to talk to).

The trust in the CA should be utmost, since **a certificate is the proof that a server is really who they say they are and not any MITM**.

MITM Attack:
- even if a malicious entity can forge a fake certificate then they need to encrypt it with their own private key, we won't be able to decrypt it with any of the pre-installed CA public keys, we will see an "Untrusted site" warning
- if malicious entity somehow "injects" their public key into the certificate, then the decrpyted signature won't match it

_References_:

- [Transport Layer Security, TLS 1.2 and 1.3 - YouTube](https://youtu.be/AlE5X1NlHgg)
- [Wiresharking TLS - What happens during TLS 1.2 and TLS 1.3 Handshake - YouTube](https://youtu.be/06Kq50P01sI)
- [What are SSL/TLS Certificates? - YouTube](https://youtu.be/r1nJT63BFQ0)

## CORS


[Reference]()

## Content Security Policy


[Reference]()

## OWASP Security Risks


[Reference]()