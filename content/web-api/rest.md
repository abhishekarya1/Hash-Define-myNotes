+++
title = "REST"
date = 2021-05-19T21:15:22+05:30
weight = 2
+++

## REST
Acronym for **Re**presentational **S**tate **T**ransfer. It is architectural **"style"** that was first presented by _Roy Fielding_ in 2000 in his famous [dissertation](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm).

Summary of 6 guiding constraints of REST:
1) **Client-Server:** Separation of concerns, both the client and  the server focus on their respective functionality onlym without caring about the other.

2) **Statelessness:** No context is required for a request to be processed, everything that the server needs to process is contained in the request.

3) **Caching:** Lot of communication overhead due to statelessness and large request size, we may need to cache responses incase we might need them later.

4) **Uniform Interface:** Providing uniform methods, data, reposnses no matter who accesses the API resources. This covers good practices like resource naming, HATEOAS, and self-descriptive messages.

5) **Layered Structure:** layers which cannot see beyond other layers. Ex - repository, service, and controller layer in API.

6) **_(OPTIONAL)_ Code-on-demand:** Client may be able to fetch code and execute it locally e.g. applets. 

[REST API Guide - dev.to](https://dev.to/drminnaar/rest-api-guide-14n2)

[REST - Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer)

### Resource
Restful APIs follow a resource-oriented design, where we have resources and actions that we perform on them (specified by protocol verbs).

Any information that can be named can be a **Resource**[^1]. It can be a **collection** having further nested collection of resources, or a **singleton** resource.

A **resource representation** represents the state of a resource. The response that we get in the form of XML or JSON is this representation.

An **API endpoint** is a location to access a resource. Multiple endpoints can point to a single resource as shown below:
```txt
Collection Resource: api.example.com/v2/users
Singleton Resource: api.example.com/v2/users/312

api.example.com/v2/users/trial
api.example.com/v2/users/premium

Query on endpoints returning a collection: api.example.com/v2/users/premium?sort=name
```

[^1]: [5.2.1.1 Resources and Resource Identifiers - Roy Fielding's Dissertation](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2_1_1:~:text=Any%20information%20that%20can%20be%20named%20can%20be%20a%20resource%3A%20a%20document%20or%20image%2C%20a%20temporal%20service%20(e.g.%20%22today%27s%20weather%20in%20Los%20Angeles%22)%2C%20a%20collection%20of%20other%20resources%2C%20a%20non%2Dvirtual%20object%20(e.g.%20a%20person)%2C%20and%20so%20on.)

### HATEOAS
One of the most overlooked features of REST is Hypermedia (interconnected resources). 

HATEOAS stands for Hypertext As The Engine Of Application State. Changing "states" like an automaton. One state can go (hyperlink) to others depending upon scenarios.

Basically, we provide links to other related resources or actions on the fetched resource in the response and often we put a self-link in the response that contains the URL from where the response was fetched from so that we can know in the future where we got the response from.

[A good example](https://restcookbook.com/Basics/hateoas/).

### Richardson Maturity Model
A heuristic way to grade your API according to the constraints of REST.

![](https://restfulapi.net/wp-content/uploads/Richardson-Maturity-Model.jpg)

[Explanation](https://restfulapi.net/richardson-maturity-model/)

## Desigining REST APIs

### Resource Naming
- name resources as nouns rather than verbs
- resource names must be plural
- use path to represent relationship and hierarchy
```txt
GET https://www.example.com/customers/33245/orders/2

# the above lists order no. 2 for customer no. 33245
```
- never use CRUD function names or any verbs in the URL, specify them with protocol methods
```txt
GET  	https://www.example.com/customers/33245
POST 	https://www.example.com/customers
PUT	 	https://www.example.com/customers/33245
DELETE  https://www.example.com/customers/33245
```
- prefer hyphens (`-`) over underscores (`_`) and camelCase 
```txt
https://www.example.com/device-info/33 		(better)

https://www.example.com/device_info/33
```
- **URIs are case-sensitive!** always use lower-case for them
- use query params to filter a collection
```txt
https://www.example.com/customers?region=USA&brand=XYZ
```

### Versioning
```txt
# using path
/api/v1/article/1234

# using subdomain
apiv1.example.com/article/1234

# using Accept header (best)
GET /api/article/1234 HTTP/1.1
Accept: application/json; version=1.0
```
### API Design Checklist
- identify resources
- define URIs (endpoints) and protocol verbs
- define resource representations
- specify status codes (both +ve and -ve scenarios)

### Other Good Practices
- documenting an API: OAS (OpenAPI Standard) and Swagger
- filtering and ordering on resources
- implementing hypertext in response (HATEOAS)
- pagination
- caching and security considerations

### OpenAPI Specification
The OpenAPI Specification is a specification for machine-readable (and humans too) **interface files** for describing, producing, consuming, and visualizing RESTful web services. It was previously called Swagger specification. 

[Swagger](https://swagger.io/tools/swagger-ui/) and some other tools like [ReDoc](https://github.com/Redocly/redoc) can generate code, documentation, and test cases given an interface file. 

It allows such tools to discover and understand the capabilities of the service without access to source code, documentation, or through network traffic inspection, all with just a single file.

The file can be a `json` or a `yaml`.

[A sample swagger file with UI](https://editor.swagger.io/#/edit?import=http://rackerlabs.github.io/wadl2swagger/openstack/swagger/dbaas.yaml)

### Testing APIs
GUI: Postman, Insomnia, Hoppscotch

Terminal: [cURL](/linux-and-tools/curl/)

## References
- https://www.restapitutorial.com
- https://restfulapi.net
- https://restcookbook.com
- Book: RESTful Web APIs by Leonard Richardson ([O'Reilly](https://www.oreilly.com/library/view/restful-web-apis/9781449359713/))
- https://apisyouwonthate.com/blog/understanding-rpc-rest-and-graphql