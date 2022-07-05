+++
title = "REST"
date = 2021-05-19T21:15:22+05:30
weight = 2
+++

## REST
Acronym for **Re**presentational **S**tate **T**ransfer. It is architectural **_"style"_** that was first presented by _Roy Fielding_ in 2000 in his famous [dissertation](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm).

Summary of 6 guiding constraints of REST:
1) **Client-Server:** Separation of concerns, both the client and  the server focus on respective functionality only without caring about the other.

2) **Statelessness:** No context is required for a request to be processed, everything that the server needs to process is contained in the request.

3) **Caching:** Lot of communication overhead due to statelssness and large request size, we may need to cache responses incase we might need them later.

4) **Uniform Interface:** Providing uniform methods, data, reposnses no matter who accesses the API resources. This covers good practices like resource naming, HATEOAS, and self-descriptive messages.

5) **Layered Structure:** layers which cannot see beyond other layers. Ex - repo, service, controller layers in Java Spring Boot.

6) **_(OPTIONAL)_ Code-on-demand:** Client may be able to fetch code and execute it locally. 

[REST API Guide - dev.to](https://dev.to/drminnaar/rest-api-guide-14n2)

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

### Richardson Maturity Model
A heuristic way to grade your API according to the constraints of REST.
[Explanation](https://restfulapi.net/richardson-maturity-model/).


## Desigining an API
- [5 Steps to designing your REST APIs](https://www.wutsi.com/read/246/5-steps-for-designing-your-rest-apis)
- meaningful resource and endpoint names
- proper versioning
- meaningful methods and verbs

- OAS (Open API Standard) and Swagger
- documenting an API
- Filtering and Ordering on resources
- implementing hypertext in response (HATEOAS)
- pagination
- caching and security considerations

Further Reading:
- [Design Patterns](https://youtube.com/playlist?list=PLF206E906175C7E07)
- [Restfulapi.net](https://restfulapi.net/) - Collection of good articles on REST (see right side menu)

## Testing APIs
GUI: Postman, Insomnia, Hoppscotch

Terminal: [cURL](/linux-and-tools/curl/)



## Alternatives
- [GraphQL](https://www.howtographql.com/basics/1-graphql-is-the-better-rest/)
- [JSON-RPC](https://www.jsonrpc.org/) (used in Ethereum API)
- [SOAP Protocol & SOAP vs. REST](https://stoplight.io/api-types/soap-api/)