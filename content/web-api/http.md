+++
title = "API and HTTP"
date = 2022-07-05T08:13:00+05:30
weight = 1
+++

## API

**Application Programming Interface:** Defines interactions between software components. Sort of like a contract or agreement that clearly mentions what kind of requests to expect, what kind of data to return, etc...

A **web API** is an API accessed over the web.

![](https://i.imgur.com/5Up9bKc.png)

**URI vs URL vs URN:** A URI is a string of characters used to identify a resource. 
- Both URL and URN are subset of a broader category _i.e._ URI. 
- URL is a URI in which access info is explicitly defined i.e. `protocol + hostname` makes up a URL. This way, they provide "pinpoint" access info by providing "how" and "where" of a resource.
- URNs are URIs that use a `urn:` scheme. They also need to be unique and often used as a template that a parser may use to find an item.
- There can be other identification that may not be a URL or URN. Ex - Data URI scheme: inline data in an HTML doc (`data:`). Since Data URI doesn't point anywhere but provide data itself, it is not URL (locator). 

```html
# URI (all URL and URN are URI)
# URI but not URN or URL (Data URI)
<img src="data:image/png;base64,iVBORw0KGgoAAA
ANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4
//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU
5ErkJggg==" alt="Red dot" />

# URL (protocol + resource name)
https://example.com/hello
https://example.com/hello#demo
https://example.com/hello?user=john
/hello-world				        	(a relative URL)
ftp://198.168.1.5
mailto:foobar@example.com

# URN (resource specified with urn: scheme)
urn:department:empname:johndoe:42320
```

Don't care much about URNs, they have very specific use cases. Prefer the term URI over more the specific URL as recommended by W3C.

[Reference](https://datatracker.ietf.org/doc/html/rfc3986#section-1.1.3)

## HTTP
Simplest and most popular protocol used to enable communication for web APIs. 

It was created for WWW along with HTML by Tim Berners-Lee at CERN. The first standardized version of HTTP (`HTTP/1.1`) was published in 1997. Current one being `HTTP/2` (2015) and `HTTP/3`  is the proposed successor which instead of using TCP as the transport layer for the session, uses [QUIC](https://developer.mozilla.org/en-US/docs/Glossary/QUIC) protocol, a new Internet transport protocol based on UDP.

- application layer protocol (layer-7)
- stateless; not sessionless (cookies implement sessions)
- communicated over TCP/IP (connection establishment by a 3-way handshake)
- content negotiation
- extensible (custom headers, etc...)

[Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Evolution_of_HTTP)

**HTTP/1**: every request requires a new TCP connection

**HTTP/1.1**: persistent single TCP connection, no streams, Head-Of-Line blocking (a connection can only support a few parellel connections at a time, otherwise we may have to wait)

**HTTP/2**: single connection, multiple streams over TCP (multiplexing) (packet loss detection and retransmission over TCP can block all streams (i.e. HOL blocking over TCP layer still exists))

**HTTP/3**: multiple streams over UDP, runs packet loss detection and retransmission independently for each stream (no blcocking unlike HTTP/2). Combines TLS handshake with QUIC handshake to reduce network latency.

### Messages
![](https://learning.oreilly.com/library/view/http-the-definitive/1565925092/httpatomoreillycomsourceoreillyimages96838.png)

```http
#Request message

GET /hello HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.example.com
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
<CRLF>
#optional body (aka payload)
```

```http
#Response message

HTTP/1.1 200 OK
Date: Mon, 27 Jul 2009 12:28:53 GMT
Server: Apache/2.2.14 (Win32)
Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT
Content-Length: 88
Content-Type: text/html
Connection: Closed
<CRLF>
#optional body (aka payload)
```

The above is applicable to HTTP/1.1 request and responses. In HTTP/2 messages are divided into frames, compressed, and embedded in a stream for transfer. All this is transaparent to the developer though since frames are not human-readable but in binary.

_References_: 
- HTTP Messages - [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Messages)
- Introduction to HTTP/2 - [web.dev](https://web.dev/performance-http2)

### Status Codes
We get a status code in the response message along with a short text (e.g. `OK`, `FORBIDDEN`, etc...)
```txt
1xx : Informational Response

2xx: Success

3xx: Redirection

4xx: Client Error

5xx: Server Error
```
[Status codes cheatsheet](https://www.restapitutorial.com/httpstatuscodes.html)

### Methods/Verbs
They are **just a hint** about the action we will perform for the request on the resource. 

```txt
GET - read

POST - create a new resource

PUT - update (replace an existing resource entirely)

DELETE - delete

PATCH - update (modify only some part of an existing resource)

OPTIONS - list all available methods for target resource

HEAD - send only response headers section back
```

[Response codes for each method](https://restfulapi.net/http-methods/)

Do note that response codes are also just a hint about the response but utmost care should be taken while designing API to make sure responses have self-explanatory status codes.

#### Idempotence and Safety

- [Idempotent](https://developer.mozilla.org/en-US/docs/Glossary/Idempotent): the server back-end state remains the same no matter how many times we call it with the method 

- [Safe](https://developer.mozilla.org/en-US/docs/Glossary/Safe/HTTP): method doesn't modify the server back-end state (all safe methods are idempotent)

Implemented correctly, `POST` is never idempotent. `PATCH` can be made non-idempotent. Rest all are idempotent. 

`PATCH` is mostly idempotent unless we have conditions in place in the code that patch different parts of resource each time we call `PATCH` on it. This is contrary to `PUT`, which overwrites the entire resource each time and is therefore inherently idempotent.

While talking about idempotence and safety, only the actual back-end state of the server matters, for example, A `DELETE` may return a `200 OK` on the first call, but successive calls will return `404 NOT FOUND`. It is idempotent because server state remains the same at all times after the first call.

#### GET vs POST
- GET is for reading, POST is for creating a new resource
- GET carries information directly in the URL (exposed), POST sends it in request body (hidden)
- GET requests can be bookmarked (since its just a URL), POST requests can't be bookmarked since they have a request body
- GET responses can be cached, POST creates a new resource so caching doesn't make sense

The above differences show up in a typical well designed API, we can obviously send payload with GET too (_very bad practice_).

### Headers
Used to exchange meta-information between the client and the server. But, we can send anything in them.

Headers are **case-insensitive**.

Some headers are request only, some are response only and some can be used with both. Headers can have attributes too.
```foobar
header-name: atrrib1=value1; attrib2=value2; ...
```
We can have both user-defined attributes and standard attributes available.

```foobar
# some examples

Content-Type: text/html
Accept: application/xml, application/json
Date: Fri, 22 Jan 2010 04:00:00 GMT
Status: 200 OK
```
A fun [article](https://carluc.ci/http-headers-you-dont-expect/) on custom headers.

### Content Negotiation
We can specify the content type (of payload) and also let the other party know what types we accept.
```sh
# specify type of payload
Content-Type: application/json

# specify client expectation
Accept: application/json

# multiple options with priority (q param)
Accept: application/json,application/xml;q=0.9,*/*;q=0.8
```
**Custom Content-type**: Subject to both client and server underdstanding and knowing how to process them.
```sh
# custom content types
Content-Type: application/vnd+company.category+xml
Content-Type: application/vnd+company.category+html
Content-Type: application/vnd+company.category+json
```

### Encoding Negotiation
Responses are often sent as **compressed** by the server and uncompressed by the client and vice-versa. 

We can let the server know the compression type we accept and it will send us in that format if it could, or directly send the request with a compression type specified and its upto the server to accept or reject it.
```sh
# specify client expectation
Accept-Encoding: gzip,compress
# if server can't send in the format we accept - 406 (Not Acceptable)
# if server doesn't accept the type we've sent - 415 (Unsupported Media Type)

# otherwise, response
Content-Encoding: gzip
```

### Cache Control
[Caching](/rest/caching/)

### Cookies
```sh
# server sets cookies; multiple Set-cookie headers are needed
Set-Cookie: name=foobar
Set-Cookie: city=delhi

# client stores them locally

# with every subsequent request to the server, the browser sends all previously stored cookies!
Cookie: name=foobar; city=delhi
```

**Cookie Lifetime**:
- **Session cookies**: last for session duration after which they are removed from the client. The browser decides the duration and some browsers can restore sessions on restart so they can potentially live indefinitely
- **Permanent cookies**: cookies are deleted at a date specified by the `Expires` attribute, or after a period of time specified by the `Max-Age` attribute

`Expires` date is acc to the client. `Max-Age` is in seconds.
```sh
Set-Cookie: name=foobar; Expires=Mon, 31 Oct 2022 07:28:00 GMT;
Set-Cookie: city=delhi; Max-Age=3600
```

We can also restrict cookie access to only HTTPS, prevent cookie access from javascript, identifying and disabling third-party cookies, define where cookies are sent, and prevent setting cookies from unsecure connections just by adding attributes to the above two cookie headers.

#### Third-party cookies
Any cookie that isn't set by the website you are currently at is a third party cookie. A server can create a profile of a user's browsing history and habits based on cookies sent to it by the same browser and store them on the browser, and later when accessing any other site the browser can send all the cookies to a third-party when we're on that website.

Cookies time and again have been abused by advertising and tracking companies, and there are many regulations and legislations that cover the use of cookies.

[Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies)

### HTTPS
Hypertext Transfer Protocol Secure (HTTPS) is an extension of HTTP. It is encrypted using Transport Layer Security (TLS) or, formerly, Secure Sockets Layer (SSL) in contrast to HTTP which is unencrypted out-of-the-box.

HTTPS = HTTP + TLS

[TLS Notes](/web-api/security-3/#tls)

## Misc

### 3-way handshake
Also called a TCP handshake, is the quintessential part of how TCP/IP works by guranteeing packet delivery (reliability).

Before we get started with sending our `GET` and other HTTP requests, we need to "establish" a connection with the server. TCP does that for us over Transport layer by sending special packets:
1. **SYN** - client sends to the server for synchronization (of seq numbers)
2. **SYN/ACK** - server sends back a new `SYN` (seq no.) and an acknowledgement (`ACK`) in response
3. **ACK** -  client sends the acknowledgement back and the connection is now established

For a SYN (`n`), ACK is `n+1`. **After** connection establishment, seq number will continue from the one that server sent us back. 

[Diagram](https://i.imgur.com/GVu6TxC.png)

TCP connection termination:
1. **FIN** (_client_) - client sends a packet to the server indicating that it wants to close the connection
2. **ACK** - server sends acknowledgement
3. **FIN** (_server_) - server sends FIN packet after a short while
4. **ACK** - client sends ACK and waits for a timed_wait before closing and releasing ports and other resources on the server

[Diagram](https://i.imgur.com/6s53eUC.png)

### HTTP Connection Control
We can control connections by sending `Connection` and `Keep-Alive` (ignored when used alone) request headers in HTTP/1.1

```sh
# keep alive till 5s and allow max 1000 requests 
Connection: keep-alive
Keep-Alive: timeout=5, max=1000

# request closure
Connection: close
``` 

In HTTP/2, **connections are persistent** and connection-specific headers are **prohibited** and they're **ignored** in HTTP/2 reponses in Chrome and Firefox.