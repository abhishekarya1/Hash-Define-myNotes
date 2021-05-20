+++
title = "Introduction to API and ReST"
date = 2021-05-19T21:15:22+05:30
weight = 1
+++

## API

**Application Programming Interface:** Defines interactions between software components. Sort of like a contract or agreement.

![](https://i.imgur.com/5Up9bKc.png)

**URI vs URL vs URN:** A URI is a string of characters used to identify or name a resource. 
- Both URL and URN are subset of a broad category _i.e._ URI. 
- URL is a URI in which protocol is explicitly defined, `protocol + URN info` makes up a URL.
- URNs do not have a rigid uniqueness constraint and can refer to many resources by a single name.

```txt
#URI
https://myblog.cs/intro.html#title

#URL
https://myblog.cs/intro.html
ftp://198.168.1.5

#URN (no location info, only name)
myblog.cs/intro.html#title
urn:isbn:0451450523
```

- There can be other identification that may _not be name or location_, they fall under URI but none of URL or URN.

- Summary:
![](https://i.imgur.com/2FzDFVE.png)

[Reference](https://stackoverflow.com/questions/176264/what-is-the-difference-between-a-uri-a-url-and-a-urn)

## REST
Acronym for **Re**presentational **S**tate **T**ransfer. It is architectural **_"style"_** that was first presented by _Roy Fielding_ in 2000 in his famous [dissertation](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm).

[REST Quick Tips and Resource Naming](https://www.restapitutorial.com/) - RestAPItutorial.com

[REST Architectural Constraints](https://restfulapi.net/) - Restfulapi.net

[REST - Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer)

### Resource vs Endpoint
Resource represents a datasource. Endpoitnts are URL. Multiple endpoints can use a single resource of the API as shown below:
```txt
Resource: api.foobar.in/v2/users

Endpoint#1: api.foobar.in/v2/users/trial
Endpoint#2: api.foobar.in/v2/users/premium

Queries on endpoints returning a collection: api.foobar.in/v2/users/premium?sort=name_asc
```

### HATEOAS
Hypertext As The Engine Of Application State. Changing "states" like an automata (from ToC). One state can go (hyperlink) to others depending upon scenarios.
[A very good example](https://restcookbook.com/Basics/hateoas/).

## HTTP
Most popular protocol that is used to implement ReSTful principles to system. `HTTP/1` was first documented (as version 1.1) in 1997. Current being `HTTP/2` and `HTTP/3`  is the proposed successor. [Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP).

### Messages: Request/Response
[Reference](https://www.tutorialspoint.com/http/http_requests.htm)

```http
#Sample Request
GET /hello.htm HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.tutorialspoint.com
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

#(optional body, in some methods like POST)
```

```http
#Sample Response
HTTP/1.1 200 OK
Date: Mon, 27 Jul 2009 12:28:53 GMT
Server: Apache/2.2.14 (Win32)
Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT
Content-Length: 88
Content-Type: text/html
Connection: Closed

#(optional body)
```

```txt
1xx : Informational

2xx: Success

3xx: Redirection

4xx: Client Error

5xx: Server Error
```

### Methods/Verbs
[List of methods](https://www.tutorialspoint.com/http/http_methods.htm)

[Response codes for each method](https://restfulapi.net/http-methods/)

[Status codes](https://restfulapi.net/http-status-codes/)

```txt
POST - Create a new resource

GET - Read

PUT - Update (replace existing resource entirely)

PATCH - Update (patch existing resource)

DELETE - Delete


OPTIONS - Send all available methods for target resource
HEAD - send only header back (response code)
```

- GET, HEAD, PUT, and DELETE are idempotent methods, PATCH can be made idempotent


### GET vs POST
- GET is for reading, POST is more general purpose but majorly for create
- GET carries information directly in the URL (exposed), POST sends it in request body (hidden)
- GET can be bookmarked (since its just a URL), POST can't be bookmarked
- GET responses can be cached, POST requests and response have same data so caching doesn't make sense
- GET is idempotent (performed multiple times with same outcome), POST is not idempotent

### Cookies and Cache Control in HTTP
Further Reading and Exploring:
- [MDN Docs - Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [dev.to](https://dev.to/ender_minyard/full-stack-developer-s-roadmap-2k12)

## Desigining an API
- meaningful resource and endpoint names
- proper versioning ([Semantic Versioning](https://semver.org/))
- meaningful methods and verbs
- documenting an API
- caching and secutity considerations

Further Reading:
- [Design Patterns](https://youtube.com/playlist?list=PLF206E906175C7E07)
