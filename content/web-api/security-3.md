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

The trust in the CA should be utmost, since **a certificate is the proof that a server is really who we are accessing and not any MITM**. Its the job of the CA to make sure they're not handing out certificates to everyone with their sign on it.

One can also self-sign certificates without any CA, but the public key of CA should be stored on computers manually. Be careful with this! 

Nothing is really stopping a malicious person from getting a certificate issued to them if its on their info and not another entity like Amazon or Microsoft. In that case, you'll be establishing a secure connection with the hacker, they can phish you but no MITM. In such cases, the CA must revoke their certificate.


MITM Attack:
- even if a malicious entity can forge a fake certificate then they need to encrypt it with their own private key, we won't be able to decrypt it with any of the pre-installed CA public keys, we will see an "Untrusted site" warning
- if malicious entity somehow "injects" their public key into the certificate, then the decrpyted signature won't match it

_References_:

- [Transport Layer Security, TLS 1.2 and 1.3 - YouTube](https://youtu.be/AlE5X1NlHgg)
- [Wiresharking TLS - What happens during TLS 1.2 and TLS 1.3 Handshake - YouTube](https://youtu.be/06Kq50P01sI)
- [What are SSL/TLS Certificates? - YouTube](https://youtu.be/r1nJT63BFQ0)
- [Public Key Certificate - Wikipedia](https://en.wikipedia.org/wiki/Public_key_certificate)
- [Certificate Authority - Wikipedia](https://en.wikipedia.org/wiki/Certificate_authority)

## CORS
Cross-Origin Resource Sharing (CORS) is an HTTP-header based mechanism that allows **a server to indicate** any origins (domain, scheme, or port) other than its own from which a browser should permit loading resources.

It relies on a mechanism in which browsers make a "preflight" request (`OPTIONS` verb) to the server specifying the headers and methods it wants to send to the server and the server replies back with the allowed origins and methods. After which the actual request can be made by the browser, if allowed. Else, the request is never made.

**If the server doesn't send back CORS headers (_it isn't CORS-aware_), we get a CORS error** and no resource access is allowed in this case too.

**The need for CORS**: Before 2005, with the dawn of AJAX, people were able to request resources with `XMLHttpRequest` object. A servere limitation of `XMLHttpRequest` was that it could only request from services which were on the same domain as the requesting site, else the browser would simply refuse to initiate the request. This is called the **same-origin policy**, and was placed as a security mechanism.

Post 2005, more and more ways to access resources not on the same origin were getting developed (even `XMLHttpRequest` became cross-origin eventually) and a policy was needed to make sure that there is a mechanism that can controls it, otherwise a server could receive tons of modifying requests like `POST` and `DELETE` from all kinds of other sites.

CORS was introduced to give the server a choice (_opt-in_). The client can ask the server and only if the server allows, can we make a request to access (and potentially modify) its resources.

**Preflight**: Its just a request that the browser makes to the server with `OPTIONS` verb and headers like below that is made to ask if the server allows it to make further requests. It is done automatically by the browser and the response can be cached for sometime too, in a separate cache from HTTP general cache.

Also, all major web frameworks enable `OPTIONS` by default to allow preflight and we don't need to explicity declare Option Mapping on every endpoint.


```foobar
OPTIONS https://api.example.com/foobar HTTP/1.1
Host: abhishekarya.com
Access-Control-Request-Headers: content-type, accept
Access-Control-Request-Method: POST
Origin: https://abhishekarya.com
```

Response: The server lists all domains and methods it allows along with max-age for CORS response caching
```foobar
OPTIONS https://api.example.com/foobar HTTP/1.1
Status: 200
Access-Control-Allow-Origin: https://notmydomain.com
Access-Control-Allow-Method: GET, POST, PUT, DELETE
Access-Control-Max-Age: 86400
```

Some Preflight failure scenarios:
```txt
No 'Access-Control-Allow-Origin' header is present on the requested resource 	-> on old/CORS-ignorant servers that don't send back CORS headers

'Access-Control-Allow-Origin' has a value that is not equal to supplied origin 	-> Origin isn't in the allowed origin list of the server

405 Method Not Allowed  -> Method isn't in the allowed method list of the server

Request header field is not allowed by Access-Control-Allow-Headers  -> Header is not allowed in the allowed header list of the server
```

### Simple Requests
Before CORS, the only requests a webpage could send originated from `<form>` elements. So, to make things non-breaking, CORS allow them to be made without a preflight request, just like earlier times.

Conditions for simple requests:
- a `GET`, `HEAD`, or `POST` method and,
- can have **_only these_** headers (apart from `User-Agent` and `Connection`) **_or none at all_**: `Accept`, `Accept-Language`, `Content-Language`, or `Content-Type` 
	- and `Content-Type` can possess any of these 3 values: `application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`

```txt
GET www.abhishekarya.com/me HTTP/1.1 		-- simple

GET www.abhishekarya.com/me HTTP/1.1 		
X-Custom-Header: foobar					    -- not simple

POST www.abhishekarya.com/me HTTP/1.1 		
Content-Type: application/json				-- not simple
```

**NOTE**: For simple requests, no preflight request is made but CORS still applies to them, and they will be stifled if server doesn't send back CORS headers (`Access-Control-Allow-Origin`) at or or if it doesn't allow our origin. Simple requests mean that we can make direct requests to servers without preflight but CORS headers will still need to be set on request and we will also get them back from the server.

#### CORS Headers List
```txt
#CORS Headers Summary

Origin
Access-Control-Request-Headers
Access-Control-Request-Method

Access-Control-Allow-Origin
Access-Control-Request-Method
Access-Control-Max-Age
````

### CORS in APIs
Since CORS is specific to browsers only, if our API isn't accessed by browsers at all, there is no need to deal with CORS.

We have [enable CORS support in Spring](https://spring.io/blog/2015/06/08/cors-support-in-spring-framework) just by adding a `@CrossOrigin` annotation with some properties on the Controller class or its methods.

### Some Clarifications
- CORS shouldn't ever be used for as a primary security measure; it can't prevent requests coming from clients other than a browser
- CORS is also about "not-changing-the-rules"; on old servers (from only the same-origin policy era) who aren't CORS-aware and assumes that requests are coming from same origin only. They don't specify CORS response headers, and we don't want them to expose their resources over the web, so we block access to such from browser
- Preflighting happens for browsers only; services are free to make calls to another service anywhere (_read above point_)
- Preflighting is a sanity-check measure; we could've straightaway rejected or accepted a browser's cross-origin request but a preflight makes sure that the server is CORS-aware

_References_:
- [Demystifying CORS - frontendian.co](https://frontendian.co/cors)
- [CORS - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [A good StackOverflow Thread](https://stackoverflow.com/questions/15381105/what-is-the-motivation-behind-the-introduction-of-preflight-cors-requests)
- [Cross Origin Resource Sharing (Explained by Example) - YouTube](https://youtu.be/Ka8vG5miErk)
- [Cross-Origin Resource Sharing - Baeldung](https://www.baeldung.com/cs/cors-preflight-requests)

## Content Security Policy (CSP)
CSP provides a standard method for website owners to declare approved origins of content that browsers should be allowed to load on that website. It helps in preventing cross-site scripting (XSS) attacks.

Its like a bouncer that prevents fetching of resources from other than allowed locations specified in the policy.

Two ways to specify CSP:
1. In HTML
```html
<!-- less preferred than the header way -->
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self' *.example.com; img-src *;">
```
2. In header (response)
```foobar
Content-Security-Policy: default-src 'self' *.example.com; img-src *
```

A lot of resource types are covered like JavaScript, CSS, HTML frames, web workers, fonts, images, embeddable objects such as Java applets, ActiveX, audio and video files, and other HTML5 features. [Reference here](https://content-security-policy.com/).

### Reporting
All violations of CSP can be reported to a specified URL.

Specify URL in CSP:
```txt
report-to: https://csp.example.com;
```

If a violation of CSP occurs in a user's session, the browser will not load that resource and `POST` to specified URL with an object of the following structure:
```json
{
  "document-uri": "https://example.com",
  "referrer": "",
  "blocked-uri": "http://evil.com/malicious/script.js",
  "violated-directive": "script-src: 'self'",
  "original-policy": "script-src: 'self'; report-to: https://csp.example.com;"
}
```

_References_:
- [Content security policy - web.dev](https://web.dev/csp/)
- [Content Security Policies - frontendian](https://frontendian.co/csp)
- [content-security-policy.com](https://content-security-policy.com/)
- [Content Security Policy (CSP) - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)


## OWASP Security Risks
The Open Web Application Security Project (OWASP) is an online community that produces freely-available articles, methodologies, documentation, tools, and technologies in the field of web application security. It is led by a non-profit called The OWASP Foundation.

They publish a regularly updated top 10 list of some of the most critical risks facing organizations and it is referenced a lot of times in many books, tools, and organizations.

[OWASP Top Ten](https://owasp.org/www-project-top-ten/)

[OWASP Cheat Sheet Website](https://cheatsheetseries.owasp.org/): Documents extensive information on a lot of application security topics.

[OWASP Web Application Security Testing Checklist](https://github.com/0xRadi/OWASP-Web-Checklist): Checklists on everything application security related.


**Veracode** vulnerability scan is an enterprise grade scanning utility that can identify OWASP risks and propose solutions to mitigate them.