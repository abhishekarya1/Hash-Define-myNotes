+++
title = "Patterns"
date = 2023-05-26T04:40:00+05:30
weight = 4
+++

## Microservices Patterns
### Service Discovery & Registry
One component (_service_) called Service Registry in the system, it enables dynamic routing between services. Essential for scaling apps.

The app registers themselves upon startup and sent _Heartbeat_ (`/health` endpoint) signals peridically to let the registry know they are up and running. Multiple instances of the same service can be registered.

The registry is not a single point of failure though, as there is a local copy of registry cached on every service which can be used for routing incase of outage of registry.

Types:
- **Server-Side Discovery**: `Client -> Load Balancer -> Registry -> Service` (a server component called _Load Balancer_ finds service URL from registry and pings the service on behalf of the client)
- **Client-Side Discovery**: `Client -> Registry -> Service` (client itself fetches the service URL from registry and pings the service themselves)

Ex - Netflix Eureka.

### API Gateway
A single entry point of traffic for all services, a reverse proxy, often registered as a service with the Service Registry. 

Manage traffic before it reaches services:
- perform filtering, processing, etc.. of incoming requests
- verfy API keys
- enforce usage quotas and rate limit
- cache responses
- monitoring and reporting

Ex - Spring Cloud API Gateway and Azure APIM.

### Load Balancing
Distribute traffic evenly across all service instances, ensuring optimal performance, and preventing service overload.

Uses an algorithm[^1] like Round-Robin to schedule incoming traffic to services.

Levels of Load Balancing:
- **Layer-4**: sticky connection, can't understand application layer level protocol data, faster
- **Layer-7**: dynamic routing, can understand application layer level protocol data (_Content-based routing_), thus slower

Types of Load Balancing:
- **Server-Side Balancing**: load balancer decides which service instance to route request to 
- **Client-Side Balancing**: client itself decides which service instance to send request to

Ex - HAProxy and Nginx. All cloud service providers provide Load Balancers of their own too. We can also implement our own Load Balancing strategy using [Spring Cloud Load Balancer](https://www.baeldung.com/spring-cloud-load-balancer).

### Backend For Frontend (BFF)
A variation of the API Gateway pattern.

A separate API gateway for each kind of client. An API can be used by many clients like a web app, native mobile app, or other third-party services. Often times we may need slightly different responses and security policies for each of them.

![](https://i.imgur.com/9oVQq2B.png)


### Retry
Send request to a service, if we get a _error response_ back, then retry a fixed number of times before falling back to a `fallbackMethod`.

If we get a TimeoutException after a certain duration of time then we can Retry, otherwise if the processing is happening in the callee service then we have no option other than to sit and wait.

Use **Timeout** pattern (`@TimeLimiter` in Resilience4j) if we want to specify timeout time and if we _don't get any response_ back for that duration then we trigger `fallbackMethod`.

Ex - [Spring Retry](https://www.baeldung.com/spring-retry), Resilience4j.

### Circuit Breaker
If one service is down, we shouldn't waste time sending it requests continually. Prevents requests from reaching a failing service, giving it time to recover.

When calls to a service **fail** or are **slow** beyond a certain threshold (a percentage of total calls made to it), we declare the circuit `OPEN` and subseqent calls are rejected, we back-off for sometime and then make the circuit `HALF_OPEN` and send a very limited number of requests to check if the service is up now.

![](https://files.readme.io/39cdd54-state_machine.jpg)

[highlight](https://resilience4j.readme.io/docs/circuitbreaker#failure-rate-and-slow-call-rate-thresholds:~:text=The%20state%20of,back%20to%20CLOSED.) from the official docs

### Bulkhead
Don't let one service's resources be hogged up by another service.

Limits the number of concurrent calls to a service. Keep it below the maximum handling capacity so that not all resources are exhausted.

Consider this scenario, if we have 20 incoming requests to `serviceA` from `serviceB` but our max pool size is 15, then 5 requests have to wait (may timeout) and all resources of `serviceA` are exhausted to serve only `serviceB`. 

If we limit requests to 10 using Bulkhead then while those 10 are processing, other 10 can be returned (error response) after a short wait time, and `serviceA` can also serve requests coming from `serviceC` simultaneously with the 10 pool connections that are unused still.

_Reference_: https://dzone.com/articles/resilient-microservices-pattern-bulkhead-pattern

### Event Sourcing and CQRS
For every state change, store an event so that a record is kept for the future.

**Event Sourcing** - keep an "event store" which logs all the change events in the system, we can rollback, replay, etc...

**CQRS** - separate service layer classes and DTOs (_models_) for reads (_query_) and writes (_command_)

### Sidecar
Extend microservice functionality by attaching a sidecar service _without_ altering code of the core service.

The "sidecar" handles tasks such as logging, monitoring, or security, allowing the main service to focus on its core functionality.

Often implemented in Service Mesh with Envoy Proxies.

Ex - Istio, linkerd.

[/microservices/tools/#sidecar-proxy](/microservices/tools/#sidecar-proxy)

### Strangler Fig
Gradually replace the monolith with microservices. Incremental replacement of portions of monolith, minimizing downtime.

![](https://i.imgur.com/17uo0gY.png)

### Saga
TBD


## References
- https://levelup.gitconnected.com/12-microservices-pattern-i-wish-i-knew-before-the-system-design-interview-5c35919f16a2
- https://www.vinsguru.com/category/design-pattern/architectural-design-pattern
- https://dzone.com/articles/design-patterns-for-microservices
- https://microservices.io/patterns/microservices.html

[^1]: https://www.enjoyalgorithms.com/blog/types-of-load-balancing-algorithms
