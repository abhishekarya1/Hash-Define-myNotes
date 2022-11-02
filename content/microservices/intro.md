+++
title = "MSA"
date = 2022-06-19T11:41:00+05:30
weight = 1
+++

**What is Service?**

A service is a _well-defined_, _self-contained_ function.

## MSA

**Microservices Architecture (MSA)** - Architectural "style"/pattern, subset of SOA (Service-Oriented Architecture), wherein services are:

- Relatively Smaller (than traditional Monoliths)

- Independent

- Decoupled/Loosly coupled (reduce dependency)

- **Single Responsibility Principle**

- Business Domain/Goal (clearly defined) (DDD (Domain Driven Design))

- **Bounded Context** - All of data and its mutability belongs to a service only.

- Built over tech agnostic protocols like HTTP or messaging protocols like AMQP. ReST is best suited for inter-service messaging.

{{% notice note %}}
Not only multiple modules during development phase but _not_ deployed as a single entity in production.
{{% /notice %}}

## Monoliths vs Microservices

- Smaller team (Two Pizza Rule ~ 8 full-stack developers per service)
- Multiple languages modules are possible as long as they communicate via a single way (e.g. ReST)
- Fault Isolation
- Highly Scalable
- Less Build & Deployment Times
- Agile and DevOps supported
- Data is not centralized but **federated** (each service has responsibility of own data only - see bounded context)
- Allows incremental updates by design

- More complex than monolith since multiple communication protocols, tech stacks are involved
- Communication overhead b/w microservices
- Distributed system so complexity is inevitable
- Network dependent for communication which is slower than intra-monolith calls
- More complexity in developing, testing, and deploying

**Cognitive load** - The complexity of a monolithic application does not disappear if it is re-implemented as a set of microservices.

The complexity that existed inside of the monolith, now exists on the inter-microservice level in form of:
- network latency
- message format design
- Backup/Availability/Consistency (BAC) (see CAP Theorem)
- load balancing
- fault tolerance

## SOA vs MSA

**Scope** - SOA is enterprise scope, MSA is application scope

**Focus** - SOA: Reusability; MSA: Reducing dependency

- Each service is a monolith in SOA

- Common architecture for all services in SOA leads to slowness; MSA trades-off development ease for speed

- Dependence on ESB (Enterprise Service Bus) - common platform to facilitate sharing between monoliths
Central data for all services in SOA (no federation of data)

- Reuse promotes dependency and not suitable in MSA; reusability is a key factor in SOA

- We often have redundancy in MSA to trade-off dependency; this is not the case in SOA. Ex - Exact same class written multiple times in different microservices but not shared from a centralized library/import

In SOA, sharing is quintessential to increase reusability; we don't care about dependency there

_Reference_: https://www.ibm.com/cloud/blog/soa-vs-microservices

## Scaling
Scale cube: A 3-D approach to build apps that can scale infinitely.

**X-Axis** (Cloning services, replication of database)

We take a service and clone it along with database. Each clone has its own replica of the database. (aka _Horizontal scaling_)

![](https://i.imgur.com/AiRvczI.png)

**Y-Axis** (Functional decomposition of services, federated database)

We functionally decompose the service into smaller services. Each smaller service is repsonsible for its own data and its mutation. The data store is often a subset of the original database and stores only the information relevant to its owner service. (aka _Microservices architecture_)

![](https://i.imgur.com/sKF4Acn.png)

**Z-Axis** (Cloning services, federated database)

We take a service and clone it, but each service can access a subset (shard) of the original database. Some component of the system is responsible for routing each request to the appropriate shard. (aka _Sharding_)

![](https://i.imgur.com/JjYsnIr.png)

_Reference_: https://akfpartners.com/growth-blog/scale-cube

---
**Horizontal scaling (Scaling out)** - Adding more machines to existing pool of resources. Ex - Cassandra, MongoDB.

**Vertical scaling** - Adding more power to existing machines. Ex - MySQL, Amazon RDS.