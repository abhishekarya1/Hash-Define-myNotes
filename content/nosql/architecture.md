+++
title = "Architecture"
date =  2020-11-29T12:22:53+05:30
weight = 1
pre = "<i class='fas fa-sitemap'></i> "
+++

## RDMS vs NoSQL
- NoSQL does not store data in tables/relations and is often distributed/sharded.
- A NoSQL database has flexible schema. 
Data is stored in many ways which means it can be document-oriented, column-oriented, graph-based or 
organized as a KeyValue store.
- Sometimes called "Not only SQL" to emphasize the fact that they may support SQL-like query languages.
- Inherent horizontal scaling, as opposed to inherent vertical scaling in RDBMS.
- Complex queries like joins are very hard in NoSQL. 
- SQL databases follow ACID properties (Atomicity, Consistency, Isolation and Durability) 
whereas the NoSQL database follows the Brewer's CAP theorem (Consistency, Availability and Partition tolerance).
- Normalizations are expensive on RDBMS but not so much in NoSQL.
- Best suited for scalibility (bcoz of Sharding) and availability (bcoz of Replication of nodes).

### Disadvantages
- No ACID guarantee
- Poor update (delete, instert) performance
- No fixed standard as of now, only community support
- No robust GUI tools as of now
- Complex queries like joins are not needed usually but they are very tough to do and costly too
- Most NoSQL databases offer a concept of _eventual consistency_ in which database changes are propagated to all nodes 
so queries for data might not return updated data immediately or might result in reading data that is not accurate 
which is a problem known as _stale reads_.

## Architecture (Cassandra Case Study)
Developed by Facebook. It is a column-oriented nosql model.

- Data is sharded in a central Cassandra Cluster, we use hashing to direct queries to particular "slice".
- Load Balancing - To better handle the load, we can create another "layer" of clusters within a node and apply another hash function
for the inner node.
- Replication gurantees availability - Copy data of the target (of hash) node to the adjacent node. Set replication factor = 1, or any other value
between 0 <= RF <= total nodes.
- Distributed Consensus -> Quorum = 2 i.e. 2 nodes have to agree on a value and send back to query. 
Can't have RF = Quorum, as incase of a failure of one node, the query will always fail. 

## References
- Gaurav Sen - [Introduction to NoSQL databases](https://www.youtube.com/watch?v=xQnIN9bW0og)
- GfG - [Introduction to NoSQL](https://www.geeksforgeeks.org/introduction-to-nosql/)
- GfG - [Difference between SQL and NoSQL](https://www.geeksforgeeks.org/difference-between-sql-and-nosql/)
- Toptal - [The Definitive Guide to NoSQL Databases](https://www.toptal.com/database/the-definitive-guide-to-nosql-databases)
- MongoDB - [Understanding the Different Types of NoSQL Databases](https://www.mongodb.com/scale/types-of-nosql-databases)