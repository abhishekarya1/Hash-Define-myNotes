+++
title = "Notes"
date = 2023-06-01T19:16:00+05:30
weight = 2
+++

Scalability - property of a system to continue to maintain desired performance proportional to the resources added for handling more work

**Tradeoffs**:
- Performance vs Scalability
- Latency vs Throughput
- Consistency vs Availibility (_read CAP Theorem_)

### CAP Theorem 
In a highly distributed system, choose any two amongst - _Consistency_, _Availibility_, and _Partition Tolerance_ (network breaking up). Networks are always unreliable, so the choice comes down to Consistency vs Availablity.
- **CP** - all nodes reads the latest writes; recover in case of network failures. Used in systems which require atomic reads and writes, if system can't verify sync across nodes (consistency) it will respond with error, violating availablity. Ex - Redis, MongoDB.
- **AP** - nodes may not have the latest write data; recover in case of network failures. Used in systems where _eventual consistency_ is allowed, or when the system needs to continue sending data back despite external errors. The node won't wait for sync to happen, it will send whatever data it has. Ex - Cassandra, CouchDB.

Video: [What is CAP Theorem?](https://youtu.be/_RbsFXWRZ10)

**PACELC Theorem**: In case of ("PAC") we need to choose between C or A, (E)lse (even if system is running normally in the absence of partitions), we need to choose between (L)atency and (C)onsistency.

We do have **CA** in non-distributed systems like RDBMS like MySQL, Postgres, etc... its called **ACID** there.

### Databases
**Federation**: divide database into multiple ones based on functional boundaries

**Sharding**: divide database into multiple ones based on criteria (often non-functional such as geographic proximity to user)

**Denormalization**: duplicate columns are often kept in multiple tables to make reads easier, writes suffer though. We often use **Materialized views** which are cached tables stored when we query the database ex. a complex JOIN

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
