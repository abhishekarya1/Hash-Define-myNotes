+++
title = "High Level Design"
date = 2023-06-01T19:16:00+05:30
weight = 3
+++

RSM (Reliability, Scalability, Maintainability) - tradeoff exists between each

**Scalability** - property of a system to continue to maintain desired performance proportional to the resources added for handling more work

### Fallacies of Distributed Systems
False assumptions that people new to distributed applications make:
- the network is reliable
- latency is zero
- bandwidth is infinite
- the network is secure
- topology doesn't change (_impacts bandwidth and latency negatively_)
- there is one administrator (_existence of conflicting policies_)
- transport cost is zero (_building and maintaining costs_)
- the network is homogeneous (_variations in latency and bandwidth across parts of network_)

## Tradeoffs
- Performance vs Scalability
- Latency vs Throughput
- Consistency vs Availibility (_read CAP Theorem_)
- Latency vs Memory (_caching_)
- Latency vs Accuracy (_cache freshness_)

### CAP Theorem and PACELC
In a highly distributed system, choose any two amongst - _Consistency_, _Availibility_, and _Partition Tolerance_ (network breaking up). Networks are always unreliable, so the choice comes down to Consistency vs Availability in the presence of partitions.
- **CP** - all nodes reads the latest writes. Used in systems which require atomic reads and writes, if system can't verify sync across nodes (consistency) it will respond with error, violating availability. Ex - Redis, MongoDB.
- **AP** - nodes may not have the latest write data. Used in systems where _eventual consistency_ is allowed, or when the system needs to continue sending data back despite external errors. The node won't wait for sync to happen, it will send whatever data it has. Ex - Cassandra, CouchDB.

> "A data store is available if and only if all get and set requests eventually return a response that's part of their specification. This does not permit error responses, since a system could be trivially available by always returning an error."	― CAP FAQ

Video: [What is CAP Theorem?](https://youtu.be/_RbsFXWRZ10)

**PACELC Theorem**: In case of ("PAC") we need to choose between C or A, (E)lse (even if system is running normally in the absence of partitions), we need to choose between (L)atency and (C)onsistency.

We do have **CA** in non-distributed systems like RDBMS like MySQL, Postgres, etc... it is called **ACID** there and its a fundamental property of SQL transactions.

### Availability and Consistency
Availability is insured by: 
- **fail-over** (master-master standby and master-slave standby)
- **replication** (maintain multiple copies of the same data to prevent loss in events of catastrophe)

Availability is the percentage of uptime of a system. Overall availability of a system containing multiple components prone to failure depends on:
- **sequence** (this means _exactly_ all components must be functioning for the system to work properly): `A1 * A2`
- **parallel** (this means _atleast one_ component must be functioning for the system to work properly): `1 - ((1 - A1) * (1 - A2))` (so basically the system only goes down only if all the components go down)

Ex - if a system has two components each having 99.00% availability, then in sequence the overall system's availablity goes down (98.01%), but in parallel, it goes up (99.99%).

Consistency is insured by: sharing updates between multiple replicas (one master many slaves, or all masters)

Some techniques for achieving consistency:
- **Full Mesh**: everyone is connected to everyone so data is broadcasted to everyone, not feasible in large clusters
- **Coordination Service**: a third party component chooses a leader node, all nodes send their message to leader and leader acts as their representative. Ex - Zookeeper.
- **Distributed Cache**: a central source of knowledge (a cache) is placed, nodes fetch data periodically from it 
- **Gossip Protocol**: each node selects another node periodically and shares data with it
- **Random Leader Selection**: elect a leader using a simple algorithm. Ex - Leader election in RAFT Concensus Algorithm [_animations_](https://thesecretlivesofdata.com/raft/)

## Levels of Consistency
Max Consistency - all writes are available globally to everyone reading from any part of the system. In simple words, ensures that every node or replica has the same view of data at a given time, irrespective of which client has updated the data.

In a distributed system, we read/write to multiple replicas of a data store from multiple client servers, handling of these incoming queries/updates needs to be performed such that data in all the replicas is in a consistent state.

In decreasing order of consistency, increasing order of efficiency:
- **Linearizable Consistency** (Strong): all read/write operations in the system are strictly ordered, easy to do on a single-threaded single-server architecture but need to use [RAFT Concensus Algorithm](https://raft.github.io/) for global ordering when there are multiple replicas of data store. Lots of HOL blocking to achieve ordering.
- **Causal Consistency** (Weak): updates to the same key are ordered, but it fails when aggregation operations are present (query that updates data corresponding to multiple keys) since aggregation operations like `sum(1,2)` utilize multiple keys `read(1)` and `read(2)` and overall ordering will decide the operation `sum` output
- **Eventual Consistency** (Weak): no ordering of reads/writes, they can be performed as soon as they come in (_highly available_), only guarantee here is that all replicas in the system eventually "converge" to the same state given that no writes come after a point and system remains alive long enough. Conflict resolution (anti-entropy and reconciliation) is often required here since writes are not ordered (which one to write first?). Ex - DNS and YouTube view counter.
	
Weak consistency (Causal & Eventual) levels are too loose, hence we often pair them with some sort of stronger guarantees like:
- **Read-your-writes consistency**: a client that makes a write request will immediately see the updated value when it makes a read request, even if the update has not yet propagated to all servers
- **Monotonic Read**: a client will only see values that are as up-to-date or more up-to-date than the values it has previously seen. A client's reads will always see a fresh value and never see an older value again. (_always read newer_)
- **Monotonic Write**: a client will only see values that are as up-to-date or older than the values it has previously written. A client's writes will always be fresh, it will never see new values updated by another client. (_always write newer_)

**Quorum Consistency** (Flexible): we can configure `R` and `W` nodes to have strong or weak consistency depending on the use case ([notes](/system-design/book-1/#quorum-concensus))

Within a single database node, when we modify a piece of data from multiple transactions, [**isolation levels**](/data/rdbms/concepts/#isolation-levels) come into the picture.

### Diagram & Summary

<img src="https://i.imgur.com/4At8dkV.png" style="max-width: 65%; height: auto;">

From the POV of `Follower 2` replica in the diagram above:
- linearizably consistent system will ensure we write first before read is done (global ordering in the system), to the outside observer (`Servers`) the system acts as if it were a single entity
- if the system is eventually consistent, then read can be done out-of-order from write and value of `x` can be sent immediately without blocking, even though write was the first operation coming into the system. Both the followers and leader will converge to `x=2` eventually.

## Load Balancing
Can be used in between web server and service, service and database, etc... knows which services are up and routes traffic to only them, does health check heartbeats for the same.

**Types**: layer-4 and layer-7 [/networking/notes/#load-balancers](/networking/notes/#load-balancers)

**Balancing Algorithms**: static and dynamic
- Round Robin
- Weighted RR (server with more capacity gets more requests)
- Least Connection
- Least Response Time
- Hash Source IP (deterministic; same source requests always land at the same server)
- Randomized Algorithm

https://www.enjoyalgorithms.com/blog/types-of-load-balancing-algorithms

To avoid it being a single-point-of-failure (SPOF), keep another LB as a fail-over (_active-active_ or _active-passive_).

[/microservices/patterns/#load-balancing](/microservices/patterns/#load-balancing)

## Caching
[/web-api/caching](/web-api/caching/)


## Database
### SQL vs NoSQL
- often no relations (tables) but key-value store, document store, wide column store, or a graph database
- flexible schema and flexible datatypes - use the right data model for the right problem rather than fitting every use case into relations
- de-normalized, `JOIN` are often done in the application code
- highly distributed across clusters without worrying about normalization, store massive amounts of data fast
- write focused because of no worry of ACID constraints during write
- most NoSQL stores lack true ACID transactions and favor Eventual Consistency (and BASE)

Reference: http://highscalability.com/blog/2010/12/6/what-the-heck-are-you-actually-using-nosql-for.html

**BASE** is used in NoSQL to describe properties:
- Basically Available - the system guarantees availability
- Soft state - the state of the system may change over time, even without input
- Eventual consistency - the system will become consistent over a period of time, given that the system doesn't receive any input during that period

Types of NoSQL Stores:
- **Key-Value store**: Redis, Memcached.
- **Document store**: key-value store with documents (XML, JSON, Binary, etc.) stored as values. Ex - MongoDB, Elasticsearch.
- **Wide-column store**: for each key, we store a table, and the tables don't need to follow the same schema across keys. Better suited for massive reads. Offers high availability and high scalability. Ex - Cassandra.
- **Graph store**: stores entities and their relationship. Ex - Neo4j.
- **Object store**: store large amount of files or unstructured data in a single store and access using HTTP APIs. Ex - Amazon S3, Azure Blob Storage.
- **Timeseries store**: optimized for storing time and events data. Ex - InfluxDB.


Types of Databases - [Fireship YT](https://youtu.be/W2Z7fbCLSTw)

NoSQL Patterns: http://horicky.blogspot.com/2009/11/nosql-patterns.html

Scaling up to your first 10 million users: https://www.youtube.com/watch?v=kKjm4ehYiMs

### Indexes
[/data/rdbms/concepts/#indexes](/data/rdbms/concepts/#indexes)

### Partitioning
Partitioning a database can be done for various reasons ranging from functional decomposition or storage considerations associated with a denormalized (i.e. single large) database.
- **Horizontal partitioning**: put different rows into different tables (Sharding)
- **Vertical partitioning**: split columns; divide our data to store tables related to a specific feature in their own server (Federation)
- **Directory Based Partitioning**: we query the directory server that holds the mapping between each tuple key to its DB server (which is sharded)

**Partitioning Criteria**: hash-based, list, round robin, composite

**Sharding**: divide database into multiple ones based on criteria (often non-functional such as geographic proximity to user). 

- Pros: convinient storage scaling, faster access due to parallel processing, low latency due to proximity to end-user
- Cons: we can't easily add more shards since existing data is already divided and we can't change boundaries, `JOIN` across shards are very expensive. Consistent hashing can help in resolving uneven shard access patterns. Needs a layer-7 balancer to read and route read/write requests.

**Federation**: divide database into multiple ones based on functional boundaries

**Denormalization**: duplicate columns are often kept in multiple tables to make reads easier, writes suffer though. We often use **Materialized views** which are cached tables stored when we query across partitioned databases i.e. a complex `JOIN`

Goals: Uniform distribution of data among nodes and minimal rerouting of traffic if nodes are added or removed. Consistent Hashing is used.

### Replication
How to copy data?
- Execute **Write-Ahead-Log** ([WAL](/data/rdbms/postgresql/#write-ahead-logging-wal)) of one replica onto the other
- **Change Data Capture** (CDC): sending events that indicate data changes and allow subscribers to process these events and make necessary transformations (suitable for cross-database replication where two DB are of diff paradigms)

Two generals problem - the problem with systems that reply on `ACK` for consistency is that the other one doesn't know if the update has been performed on the other node if `ACK` doesn't reach us back, resolution - _hierarchical replication_.

- **Single Leader** (_does not scales writes_): only master can handle writes, master propagates writes to slaves, slaves are _read only_ for the client. If master goes down, one of the slaves is promoted to master or we can have a fail-over master ready to take over.
- **Multi-Leader**: multiple nodes are leaders and writes can be done on any of the leader, consistency between them has to be maintained so that no race condition occurs. Eventual consistency is expected here. One of the leader continue to function if one goes down.
- **Leaderless**: all nodes are equal, writes can be addressed by any of the nodes. Eventual consistency is expected here. Use quorum concensus.

Problems in replication:
- **Split-Brain Problem**: happens when there are even number of masters in a system, half of them have a value of `x=1` and the other half has `x=2`, but we need a single unambiguous value of `x`. Auto-reconciliation like timestamp comparisons can be done, sometimes manual-reconciliation too. Better to have an odd number of nodes to avoid this problem, in such a system even if there is a split, a strict quorum is possible.

- **Write Amplification Problem** (WA): when replicating data from a master to a replica, we've to write `n` times if there are `n` replicas in the system. In such a system, what happens when one of the replicas fails to ack the write? should we wait for it (_indefinite_ wait) or move on (_stale_ data on that replica).

### Reducing DB Writes
**Sampling**: only a subset of the collected data should be persisted to the database rather than the entire dataset. This approach is suitable when not all data points are critical, helps reduce storage. Used in Time Series Databases.

**Aggregation**: aggregate multiple events into fewer ones using Services and write those to DB. We can have multi-tier aggregation as well to combine multiple data events into fewer and fewer ones in each layer. Requires additional aggregator services which increases complexity.

We can also have a layer-7 Load Balancer to do partitioning and multi-tier aggregation together:

![](https://i.imgur.com/4ml6NcL.png)

### ETL
It is the copying of data from one or more sources into one destination which represents the data differently from any of the sources.

A typical ETL process is just a ETL _pipeline_ (DAG of tasks), which applies _transformations_ and outputs data that can be queried.

Two types of ETL processings:
- **Batch**: run jobs at scheduled intervals and process data. Slower but provides highly accurate insights into data. Ex - [Airflow](https://airflow.apache.org/).
- **Streaming** (aka ELT): do real-time processing of data. Much faster but accuracy takes a hit. Ex - [Kafka](https://kafka.apache.org/) (_more specialized as a message broker_), [Flink](https://flink.apache.org/) (_more specialized as an analytical engine_).

ETL pipeline architectures:
- **Lambda Architecture**: parallely run a batch layer (batch jobs) and a streaming layer (real-time streaming) and merge results into a "serving" layer which can answer queries on data.
- **Kappa Architecture**

### Migration
Transfer data from an old DB to a new one with minimal downtime.

**Naive Approach**:
```txt
Stop old DB
DB_copy from old
DB_upload to new
Point services to new DB
```

Downside is the downtime of database during migration.

**Simple Approach**:

Utilities like [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) can take backup without stopping the database server so it remains operational buring backup.

Creating a backup (dump) of a large database will take some time. Any inserts or updates that come in during this backup time will've to be populated to new database i.e. entries after timestamp `x` at which the backup started. These new entries will be much smaller in number than entire existing database backup.

```txt
DB_copy to new 									(starts at x)
DB_copy to new with timestamp > x 				(starts at y)
Add trigger on old to send queries to new 		(starts at z)
DB_copy to new with: y < timestamp < z
``` 

If update queries on data yet to be backed up happens with trigger, we can do UPSERT (INSERT if not present, UPDATE otherwise).

If we've less data, we can run backup at `x` and add trigger to old at `y`, skipping step 2 above (second iteration of DB_copy). After that, we only need to copy data from backup start uptil trigger was added i.e `x < timestamp < y`.

Adding Triggers early on isn't a good design in large databases as it will cause a lot of misses if read from new DB and stale data if read old DB. So add triggers only after some data is migrated to new DB.

**Optimized Approach**:

Setup CDC or SQL Triggers first, and then transfer data from old to new using backup.

After the new DB is populated we want to point clients to the new DB instead of old DB, all read/write should happen on new DB. 

Use `VIEW` tables as proxy created from new DB (transformations can be done to mimic old DB) but name them same as in old DB because the code is still expecting connection to the old DB. Rename old DB to "old_DB_obsolete" (_unpoint_).

Once everything is working fine, refactor service code to entirely use new DB (some downtime to restart services). We can delete the proxy `VIEW`s after that.

**Diff Cloud Providers**:

When migrating from Azure to AWS, we can't add a trigger as in simple approach or create a view proxy as in optimized approach.

We use a `DB Proxy` server in such a case. Reads are directed to the old DB, writes to both old and new. Any views needed are present in the proxy server. Rest of the steps remain the same.

It requires two restarts though - one to point services to DB Proxy and other is to point services to AWS when we're done with the migration.

### Alt Data Storage Options
Data can be cached on the client side in the browser. Saves server storage space.

Data can be stored on the client as well. Ex - WhatsApp stores backups on any third-party like Google Drive. Analytics can be a problem though with this approach.

## Networking
[/networking](/networking/notes)

## Observability
It is the ability to understand the internal state or condition of a complex system based solely on knowledge of its external outputs, specifically its telemetry.

The 3 pillars of observability (o11y):
- **Logs** - granular, time-stamped, complete and immutable records
- **Traces** - record the end-to-end “journey” of every user request
- **Metrics** - measures of application and system health over time

**Treat logs as a continuous stream**: centralized logs with trace and gather metrics in a timeseries DB

Other aspects of good o11y:
- **Monitoring**: create context specific dashboards to monitor real-time logs and stats
- **Alerts**: setup alerts to notify various channels upon anomalies and failures

### o11y applications

**Anomaly Detection**: detecting faults
- Confidence Intervals - may flag black friday traffic spikes as anomaly
- Holt-Winters Algorithm - looks at historical seasonal metrics to flag issues (not only spikes)

**Root Cause Analysis**: finding out cause of faults, correlation in metrics
- Manual - "Five Whys" Technique (ask five layers of why questions about the fault)
- Automatic - Principal Component Analysis (PCA) or Spearman's Coefficient (automated, used in large organizations)

## The Inteview

1. list and confirm FR
2. list and confirm NFR
3. Capacity Estimation (_optional_)
4. Design and get buy-in
5. Zoom in on components
6. Security, rate-limiting, o11y and alerts, a11y, analytics
7. Summarize

### Requirements
**Functional Reqiurements** (FR) - features, components and architecture, API spec, data model

**Non-Functional Reqiurements** (NFR) - consistency, availability, performance (latency and throughput), fault-tolerance, security, privacy, maintainability
