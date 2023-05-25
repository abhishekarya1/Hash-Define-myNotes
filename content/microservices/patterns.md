+++
title = "Patterns"
date = 2023-05-26T04:40:00+05:30
weight = 4
+++

## Microservices Patterns
### Service Discovery & Registry
One component called Service Registry for all services, it enables dynamic routing when scaling.

Types:
- **Server-Side Discovery**: `Client -> Load Balancer -> Service Registry -> Service` (a server component called _Load Balancer_ finds service URL from registry and pings the service on behalf of the client)
- **Client-Side Discovery**: `Client -> Service Registry -> Service` (client itself fetches the service URL from registry and pings the service themselves)

Ex - Netflix Eureka.

### API Gateway
A single ingress point for all traffic, oftenregistered as a service with the Service Registry. 

Manage traffic before it reaches services. Perform filtering, processing, etc.. of incoming requests here.

Ex - Spring Cloud API Gateway and Azure API Gateway.

### Load Balancing
Distribute traffic evenly across all service instances, ensuring optimal performance, and preventing service overload.

Types of Load Balancing:
**Layer-4**: sticky connection, can't understand application layer level protocol data, faster
**Layer-7**: dynamic routing, can understand application layer level protocol data (_Content-based routing_), thus slower

Ex - HAProxy and Nginx. All cloud service providers provide Load Balancers of their own too. We can also implement our own Load Balancing strategy using [Spring Cloud Load Balancer](https://www.baeldung.com/spring-cloud-load-balancer).


## References
- https://levelup.gitconnected.com/12-microservices-pattern-i-wish-i-knew-before-the-system-design-interview-5c35919f16a2
