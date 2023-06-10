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

### Consistent Hashing
When choosing a server in Load Balancing or a data partition for our request, we can choose a hash function. It can uniformly distribute requests across servers but scaling is an issue - if servers are added or removed, incoming requests will fail if the result of `H(k) = k % n` isn't available.

Solution - Consistent Hashing. Even if we add or remove servers, keys `k` will still be able to find servers after hashing with the same hash function `H` and number of servers that were previously there i.e. `n`.

[Illustration Video](https://youtu.be/UF9Iqmg94tk)

**Advantages**: no need to replace any existing properties - hash function or no. of servers

**Disadvantages**: if we're hashing clockwise, there might be a server that is closer but on the anti-clockwise of the target value we hashed to, we place virtual redundant **Virtual Nodes** to resolve this

The challenge is how to place nodes across hash space so that response time of a request is minimized (directly proportional to the nearest server it can connect to). That server/shard also needs to have the data we need.

Ex - Amazon DynamoDB, Apache Cassandra, Akamai CDN, Load Balancers, etc...

{{% notice note %}}
Servers are hashed too based on their IP or hostname to map them to the hash space of the request keys `k`, may or may not use the same hash function as the keys. For mapping Virtual Nodes, use another hash function that maps to the same hash space.
{{% /notice %}}

## Databases
### Partitioning
- **Horizontal partitioning**: put different rows into different tables (Sharding)
- **Vertical partitioning**: divide our data to store tables related to a specific feature in their own server (Federation)
- **Directory Based Partitioning**: we query the directory server that holds the mapping between each tuple key to its DB server (which is sharded)

**Partitioning Criteria**: hash-based, list, round robin, composite

**Sharding**: divide database into multiple ones based on criteria (often non-functional such as geographic proximity to user). Limitations: we can't easily add more shards since existing data is already divided and we can't change boundaries, JOINs across shards are very expensive.

**Federation**: divide database into multiple ones based on functional boundaries

**Denormalization**: duplicate columns are often kept in multiple tables to make reads easier, writes suffer though. We often use **Materialized views** which are cached tables stored when we query the database ex. a complex JOIN

### Replication
Two generals problem - the problem with systems that reply on `ACK` for consistency is that the other one doesn't know what is the result if ACK doesnt reach us back, resolution - heierachical replication

- **Active-passive**: only master can handle writes, master propagates writes to slaves, slaves are _read only_ for the client. If master goes down, one of the slaves is promoted to master.
- **Active-active**: both master and slaves can address writes, consistency between them has to be maintained. One of the slaves continue to function if the existing one goes down.

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

## Networking and Protocols
[/networking](/networking/notes)