+++
title = "Notes"
date = 2023-06-01T19:16:00+05:30
weight = 2
+++

Scalability - property of a system to continue to maintain desired performance proportional to the resources added for handling more work

### Tradeoffs
- Performance vs Scalability
- Latency vs Throughput
- Consistency vs Availibility (_read CAP Theorem_)

### CAP Theorem and PACELC
In a highly distributed system, choose any two amongst - _Consistency_, _Availibility_, and _Partition Tolerance_ (network breaking up). Networks are always unreliable, so the choice comes down to Consistency vs Availablity.
- **CP** - all nodes reads the latest writes; recover in case of network failures. Used in systems which require atomic reads and writes, if system can't verify sync across nodes (consistency) it will respond with error, violating availablity. Ex - Redis, MongoDB.
- **AP** - nodes may not have the latest write data; recover in case of network failures. Used in systems where _eventual consistency_ is allowed, or when the system needs to continue sending data back despite external errors. The node won't wait for sync to happen, it will send whatever data it has. Ex - Cassandra, CouchDB.

> "A data store is available if and only if all get and set requests eventually return a response that's part of their specification. This does not permit error responses, since a system could be trivially available by always returning an error."	― CAP FAQ

Video: [What is CAP Theorem?](https://youtu.be/_RbsFXWRZ10)

**PACELC Theorem**: In case of ("PAC") we need to choose between C or A, (E)lse (even if system is running normally in the absence of partitions), we need to choose between (L)atency and (C)onsistency.

We do have **CA** in non-distributed systems like RDBMS like MySQL, Postgres, etc... it is called **ACID** there.

### Load Balancing
Can be used in between web server and service, service and database, etc... knows which services are up and routes traffic to only them, does health check heartbeats for the same.

**Types**: layer-4 and layer-7 [/networking/notes/#load-balancers](/networking/notes/#load-balancers)

**Balancing Algorithms**:
- Round Robin
- Weighted RR
- Least connection
- Least response time
- Hash source IP, or target IP

https://www.enjoyalgorithms.com/blog/types-of-load-balancing-algorithms

To avoid it being a single-point-of-failure (SPOF), keep another LB as a fail-over (_active-active_ or _active-passive_).

[/microservices/patterns/#load-balancing](/microservices/patterns/#load-balancing)

### Caching
[/web-api/caching](/web-api/caching/)


## Databases
### Partitioning
- Horizontal partitioning: put different rows into different tables (Sharding)
- Vertical partitioning: divide our data to store tables related to a specific feature in their own server (Federation)
- Directory Based Partitioning: we query the directory server that holds the mapping between each tuple key to its DB server (which is sharded)

Partitioning Criteria: key of hash-based, list, round robin, composite

**Sharding**: divide database into multiple ones based on criteria (often non-functional such as geographic proximity to user)

**Federation**: divide database into multiple ones based on functional boundaries

**Denormalization**: duplicate columns are often kept in multiple tables to make reads easier, writes suffer though. We often use **Materialized views** which are cached tables stored when we query the database ex. a complex JOIN

### Indexes
[/data/rdbms/concepts/#indexes](/data/rdbms/concepts/#indexes)

### SQL vs NoSQL
- often no relations (tables) but key-value store, document store, wide column store, or a graph database
- de-normalized, JOINs are often done in the application code
- most NoSQL stores lack true ACID transactions and favor Eventual Consistency

**BASE** is used in NoSQL to describe properties:
- Basically Available - the system guarantees availability
- Soft state - the state of the system may change over time, even without input
- Eventual consistency - the system will become consistent over a period of time, given that the system doesn't receive any input during that period

NoSQL Stores:
- Key-Value stores: Redis, Memcached
- Document stores: key-value store with documents (XML, JSON, Binary, etc...) stored as values. Ex - MongoDB, Elasticsearch
- Wide column store: offer high storage capacity, high availability, and high scalability. Ex - Cassandra
- Graph stores: stores nodes and their relationship. Ex - Neo4j

Types of Databases - [Fireship YT](https://youtu.be/W2Z7fbCLSTw)

NoSQL Patterns: http://horicky.blogspot.com/2009/11/nosql-patterns.html

Scaling up to your first 10 million users: https://www.youtube.com/watch?v=kKjm4ehYiMs

