+++
title = "Patterns"
date = 2023-05-26T04:40:00+05:30
weight = 4
+++

## Microservices Patterns
### Service Discovery & Registry
One component (_service_) called Service Registry in the system, it enables dynamic routing between services. Essential for scaling apps.

The app registers themselves upon startup and sends _Heartbeat_ (or check status using `/health` endpoint) signals peridically to let the registry know they are up and running. Multiple instances of the same service can be registered.

The registry is not a single point of failure though, as there is a local copy of registry cached on every service which can be used for routing incase of outage of registry.

Types:
- **Server-Side Discovery**: `Client -> Load Balancer -> Registry -> Service` (a server component called _Load Balancer_ finds service URL from registry and pings the service on behalf of the client)
- **Client-Side Discovery**: `Client -> Registry -> Service` (client itself fetches the service URL from registry and pings the service themselves)

Ex - Netflix Eureka.

### API Gateway
A single entry point of traffic for all services, a reverse proxy, often registered as a service with the Service Registry. 

We can place this as a Forward Proxy too. One use case for it is API response aggregation i.e. combine responses from User Service and Payment Service and send as a single response back to the user.

Manage traffic before it reaches services:
- routing, load balancing 
- perform filtering and transformation of incoming API requests
- security - verfy API keys
- enforce usage quotas and rate limit (throttling)
- cache API responses (e.g. Varnish Cache)
- metrics, monitoring, reporting

Ex - Spring Cloud API Gateway and Azure APIM.

**Note**: Just like other core services in a good distributed system, API Gateway also has fail-overs to ensure high availability such that there is no SPOF in the system.

_Reference_: API Gateway - [YouTube](https://youtu.be/xtd5GQl4Dxc)

### Load Balancing
Distribute traffic evenly across all service instances, ensuring optimal performance, and preventing service overload.

Uses an algorithm[^1] like Round-Robin to schedule incoming traffic to services.

Levels of Load Balancing:
- **Layer-4**: sticky connection, can't understand application layer level protocol data, faster
- **Layer-7**: dynamic routing, can understand application layer level protocol data (_Content-based routing_), thus slower

Types of Load Balancing:
- **Server-Side Balancing**: load balancer decides which service instance to route request to 
- **Client-Side Balancing**: client itself decides which service instance to send request to (client doesn't send request to LB in this)

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

### Sidecar
Extend microservice functionality by attaching a sidecar service _without_ altering code of the core service.

The "sidecar" handles tasks such as logging, monitoring, or security, allowing the main service to focus on its core functionality.

Often implemented in Service Mesh with Envoy Proxies.

Ex - Istio, linkerd.

[/microservices/tools/#sidecar-proxy](/microservices/tools/#sidecar-proxy)

### Strangler Fig
Gradually replace the monolith with microservices. Incremental replacement of portions of monolith, minimizing downtime.

![](https://i.imgur.com/17uo0gY.png)

### Event Sourcing
Event-driven architecture[^2] allows services to be decoupled from each other. Instead of calling another service directly, we can publish event messages to a centralized Event Bus and other subscribed services receive that event and update their state. Ex - MQs and Kafka Topics.

In Event Sourcing, microservices persist each stage change (_event_) in an event store, which is a datastore of all events in the system. The other services can then "react" to these state changes. 

The event store also behaves like a message broker. It provides an API that enables services to subscribe to events. When a service saves an event in the event store, it is delivered to all interested subscribers, who then replay it to update their respective states.

Use Case: implementing Choreography Saga.

https://microservices.io/patterns/data/event-sourcing.html

https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing

### CQRS
Command and Query Responsibility Segragation

**Problem** - Read and write logic is different. In a highly normalized database, writes are simpler, whereas reads require complex JOINS. One repository doing both read and write can be split into two separating both of these concerns.

Create separate controller, service layer, DTOs inside a singular service to truly separate logic. This way we can also use a custom property and these beans annotated with `@ConditionalOnProperty` and then we can start the application in read-only or write-only mode.

![](https://i.imgur.com/dr6e9qU.png)

To further enhance this, instead of doing reads and writes on a single database, we can use **2 databases** - one for _read_ and one for _write_.

Pros:
- typical traffic has much lesser writes than reads; scale their databases independently: have more databases replicas for read, place write database much farther geographically
- if table gets locked by write query, then read isn't possible; isolation
- we can read from No-SQL and write to SQL or vice-versa

Cons:
- sync of both the write and read databases is additional overhead; consistency has to be handled with Event Sourcing (trigger an event on a write using Kafka as event store to a dedicated write-to-readDB service) or CDC (Change Data Capture) at the database level
- complex application design

![](https://i.imgur.com/UgQVgKI.png)

Further, we can totally have two different microservices too, one for reading and one for writing accessing their corresponding databases, allowing them to scale independently.

https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs

https://www.vinsguru.com/cqrs-pattern

### Saga
**Problem**: How to make sure operations that span multiple services are atomic? Distributed Transactions.

One example of such transaction is when payment is deducted but inventory is out-of-stock, we then have to "rollback" transactions across inventory service as well as the payment service.

A saga is a sequence of local transactions carried out across diff microservices. Each local transaction updates the database (of that service only) and publishes a message/event/call to trigger the next transaction in the saga (in another service).

Every operation that is part of the Saga can be rolled back by a **compensating transaction**. Further, the Saga pattern guarantees that either all operations complete successfully or the corresponding compensation transactions are run to undo the work previously completed. So in a way, compensating transactions in Saga are equivalent of rollback in local transactions.

Two ways to implement Sagas:
- **Orchestration approach**: an orchestrator (can be another microservice) triggers transactions in other services manually by calling their API endpoints. Compensating transactions here run based on the API response. Using Scatter Gather Aggregator pattern - [example](https://www.vinsguru.com/orchestration-saga-pattern-with-spring-boot).
- **Choreography approach**: a service publishes events to a event store on completion of a local transaction that can trigger local transactions in other services. Compensating transactions here run based on the failure event published to event store by another service. Using Event Sourcing Pattern with Kafka - [example](https://www.vinsguru.com/choreography-saga-pattern-with-spring-boot).

Tools used to implement Saga pattern:
- Orchestrators: [Apache Camel](https://camel.apache.org/components/4.4.x/eips/saga-eip.html) and [Camunda](https://camunda.com/)
- Chroreography: [Axon Framework](https://docs.axoniq.io/reference-guide/axon-framework/sagas)

https://www.baeldung.com/cs/saga-pattern-microservices

### Aggregator
Compose a single response by aggregating the responses of multiple independent microservices.

We can make REST calls to other services using WebClient and `.zip` the results together in an `AggregatorService`. It needs to be async otherwise we'll just keep waiting for responses.

https://www.vinsguru.com/spring-webflux-aggregation

Three ways to implement:
- **Scatter Gather** (Parallel): parallelly call services, say `order` and `payment` services from the `AggregatorService`
- **Chain**: if there is a dependency among services, call `order` service first and `payment` later, and then combine in the `AggregatorService`
- **Branch**: a combination of both patterns above, a branch just like in scatter-gather but there is chaining in each branch

https://medium.com/geekculture/design-patterns-for-microservices-aggregation-pattern-1b8994516fa2

### Observability Patterns
**Health Check**: expose a `/health` API enpoint in actuator; it is polled by Service Mesh and Service Registry to check alive status of the microservice

**Performance Metrics**: with _Micrometer_, _Prometheus_, and _Grafana_

**Log Aggregation**: treat logs as streams and don't store them in file like earlier times, aggregate (_Logstash_) and index them (_Elasticsearch_)

**Distributed Tracing**: trace a request across microservices with _Zipkin_ [[link](/spring-boot/log/#sleuth-and-zipkin)]

### Deployment Patterns
**Blue-Green Deployment**: two identical production enviroments, only one is live at a given time, helps in upgrading services to newer version with minimal downtime

![](https://i.imgur.com/nJP0R8D.jpg)

**Canary Deployment**: rollout features to a subset of users (_early adopters_) before making them available to all; redirect a part of traffic coming from users say 10% of the total users to the newer service (`v1.1`), while the majority of traffic still goes to the stable service (`v1.0`).

**Rolling Deployment**: slowly replace the pods containing old version with the pods containing new version of the code (in k8s).

A/B Testing: 50% of users are redirected to `versionA` and the other half to `versionB` to determine which one performs better.

## References
- https://levelup.gitconnected.com/12-microservices-pattern-i-wish-i-knew-before-the-system-design-interview-5c35919f16a2
- https://www.vinsguru.com/category/design-pattern/architectural-design-pattern
- https://dzone.com/articles/design-patterns-for-microservices
- https://microservices.io/patterns/microservices.html

[^1]: https://www.enjoyalgorithms.com/blog/types-of-load-balancing-algorithms
[^2]: https://microservices.io/patterns/data/event-driven-architecture.html (deprecated, replaced by Saga)
