+++
title = "Book"
date = 2023-11-24T08:02:00+05:30
weight = 3
+++

## Capacity Estimation
Latency numbers every programmer should know with Humanized Scale: https://gist.github.com/hellerbarde/2843375

Latency numbers for 2020s: [ByteByteGo Video](https://youtu.be/FqR5vESuKe0)

Traffic (_requests per sec_), Storage, and Bandwidth (_data per sec_) Estimation Example: https://youtu.be/-frNQkRz_IU

```txt
1 million req/day = 12 req/sec
```

## Framework
1. Understand the problem
2. High Level Design
3. Deep Dive
4. Summary

## Rate Limiting
Also known as **Throttling**.

Performed in Networks too as part of _Congestion Control_ (use IPTables on Network Layer to set quota for IP Addresses).

Saves from DOS attack, reduces load, saves costs and bandwidth.

### Algorithms

1. **Token Bucket** - suitable for burst traffic
2. **Leaky Bucket** - FIFO queue, suitable for fixed rate flow of requests
3. **Fixed window counter** - spikes on the edges of windows ruins this
4. **Sliding window log** - overhead of storing logs for requests which were rejected
5. **Sliding window counter** - combination of above two, best algo

```txt
Token Bucket

- instead of refilling buckets of millions of users (write heavy) acc to refill rate, refill only upon the next request for a single user based on the time diff since last request for that user (smart)

- bucket size, refill rate

"user_1": {"tokens": 1, "ts": 1490868000}
```

```txt
Leaky Bucket

- requests are put into a FIFO queue, and subsequently picked from there based on the outflow rate parameter

- bucket size, outflow rate
```

```txt
Fixed window counter

- instead of resetting counter for millions of users (write heavy) at window start, reset upon the next request for a single user (smart)

- discard window ts and counter (key-value) if it has expired, insert new entry for new window

"user_1_1490868000": 1
```

```txt
Sliding window log

- store a log (in a sorted set) for every incoming request, discard outdated logs, check if log size is less than our window limit (allowed)

"user_1" : {
			 1490868000
			 1490868001
			 1490868002
		   }
```

**NOTE**: The approach described in most sources including the book has a major caveat. If requests keep coming in, the system won't be able to process any of them after a while since rejected requests will keep filling up log for the rolling window. Store logs only for successful requests to avoid this. [Reference](https://www.reddit.com/r/AskComputerScience/comments/xktn2j/rate_limiting_why_log_rejected_requests/)

```txt
Sliding window counter

- store counter as well as logs

- discard expired logs, for an incoming request increment counter for the corresponding timestamp, check by adding all counters in the current log, allow if below limit

"user_1" : {
			 1490868000: 1,
			 1490868001: 2
		   }
```

Reference: https://www.figma.com/blog/an-alternative-approach-to-rate-limiting

### Enhancements
Return HTTP response code `429 - Too Many Requests`. Also, return response headers to let the user know they are being throttled, and how much time they need to wait (backoff/cooldown/retry after).

### Issues
In a distributed environment, single rate limiter cache (counter, bucket, etc...) can face **Race Condition**. Sorted sets in Redis can resolve this as its operations are atomic.

If we use multiple rate limiters, we need **Synchronization** so that both the rate limiter know the current value of counter for a given user, to use them interchangeably. Use a shared cache used by both the rate limiters.

## Consistent Hashing
Eficiently choosing a server for our request in a distributed and scalable environment. Used for Load Balancing.

Ex - Amazon DynamoDB, Apache Cassandra, Akamai CDN, Load Balancers, etc...

### Classic Hashing
Use a uniformly distributed hash function (`hash`), hash request keys (`key`), and perform modulo on the output with the server pool size (`N`) to route to a server. 

```
serverIndex = hash(key) % N
```

It can uniformly distribute requests across existing servers but scaling is an issue - if servers are added or removed, all requests need to be remapped with a new `N` and we lose cached data for all requests (_cache miss_) since we reassign servers to all requests.

### Consistent Hashing
In case of addition or removal of servers, we shouldn't need to remap all they keys but only a subset of them - `1/N`th portion of hash space.

**Approach**: Hash requests based on some key and hash servers based on IP using the same hash function (`hash`). This ensures equal hash space for both requests and servers. We don't need to perform modulo operation here. Ex - `SHA-1`, etc. No change in architecture is required here unlike classical hashing which required change to server pool size (`N`) parameter upon removal or addition of servers.

- Hash space, Hash ring - should be same for both requests and server, use same hash function for both
- Partition - hash space between adjacent servers

For each incoming request, if a server is not available for the same hash, probe clockwise (Linear or Binary Search) and use whatever server is encountered first. Each server is now responsible of handling requests of a particular range of hashes from the ring (_partition_).

Addition and removal of servers won't bother us now since probe will take care of finding servers.

Find affected keys - if a server is added/removed, move anti-clockwise from that server and all keys till the first server is encountered will have to be remapped.

[Illustration Video](https://youtu.be/UF9Iqmg94tk)

### Virtual Nodes
Non-uniform distribution - some servers may get the majority of the traffic, while others sit idle based on their position on the hash ring.

If we're probing clockwise, there might be a server that is closer but on the anti-clockwise direction of the hash, we place virtual redundant **Virtual Nodes** or Replicas to resolve this.

Virtual nodes route to an actual server on the ring.

Place as many virtual nodes across hash space such that response time of a request is minimized (directly proportional to the nearest node it can connect to).

## Key-Value Store
```txt
Data Partition 				- Consistent Hashing
Data Replication 			- Consistent Hashing (copy data onto the next three unique servers towards the clockwise direction)
Consistency 				- Quorum Concensus
Inconsistency Resolution 	- Versioning (Vector Clock)
Failure Detection 			- Gossip Protocol
Handling Temporary Failures - Sloppy Quorum with Hinted Handoff
Handling Permanent Failures - Anti-Entropy Protocol with Merkle Tree
Fast Lookup 				- Bloom Filter
```

### Quorum Concensus
Ensures data read and write consistency across replicas.

**Approach**: Client sends request to a _coordinator node_, all replicas are connected to a coordinator. We need atleast `W` replicas to perform and acknowledge a write operation, and atleast `R` replicas to perform and acknowledge a read operation for it to be declared successful, where `N` is the number of nodes that store replicas of a particular data (and not the total number of replica nodes in the system).

**Configuration**:
```txt
If R = 1 and W = N, the system is optimized for a fast read
If W = 1 and R = N, the system is optimized for fast write
If W + R > N, strong consistency is guaranteed (guranteed that there is always atleast one overlapping node in reads and writes)
If W + R <= N, strong consistency is not guaranteed
```

In case of a read where we get diff values of the same data object from diff replicas, we use versioning to differentiate them. Ex - `(data, timestamp)`, we'll keep the data with the latest timestamp.

[Illustration Video](https://youtu.be/uNxl3BFcKSA)

### Vector Clock
We keep a Vector Clock `D([Si, Vi])` for each data item in the database and by comparing it we can identify if there is a conflict, where `Si` is the server writing data item `D` and updating its version `Vi`.

```txt
Vector Clock = D([Si, Vi])

Example - D([S1, V1], [S2, V2], ..., [Sn, Vn])
```
```txt
Scenarios: first compare server and then version for both; versions should be less or more across all servers of a clock, not mixed

D([Sx, 1])		-- parent
D([Sx, 2])		-- child

D([Sx, 1])				-- parent
D([Sx, 1], [Sy, 1])		-- child

D([Sx, 1], [Sy, 2])
D([Sx, 2], [Sy, 1])		-- conflict; how can Sx or Sy version decrease?

D([Sx, 1], [Sy, 1])
D([Sx, 1], [Sz, 1])		-- conflict; Sy and Sz both unaware of the other's write

D([Sx, 1], [Sy, 1], [Sz, 1])	-- resolving above conflict
```

Storing vector clocks along with data objects is an overhead.

### Gossip Protocol
Once a server detects that another server is down, it propagates info to other servers and they check their membership list to confirm that it is indeed down. They mark it as down and propagate the info to other servers.

```txt
node membership list - memberID, heartbeat counter, last received
```

If a server's heartbeat counter has not increased for more than predefined periods, the member is considered as offline.

Used in P2P systems like BitTorrent.

### Sloppy Quorum w/ Hinted Handoff
Instead of enforcing the quorum requirement of choosing from `N` nodes that store replica of a particular data, the system chooses the first `W` healthy nodes for writes and first `R` healthy nodes for reads on the hash ring. Offline servers are ignored.

When the down server goes up, changes will be pushed back to the replicas which are supposed to store that data to achieve data consistency - **Hinted Handoff**.

```txt
Even if W + R > N, strong consistency can't be guaranteed in case of Sloppy Quorums
			  	   since with N = 3 (A, B, C), we wrote to nodes A, C and read from D, E because of down servers
			  	   no overlap even if the condition was satisfied
			  	   hinted handoff will add data to B once its up
```

Enabled by default in DynamoDB and Riak.

[Reference](https://jimdowney.net/2012/03/05/be-careful-with-sloppy-quorums/)

### Anti-Entropy Protocol w/ Merkle Tree
Keep replicas in sync periodically so that if one of them goes down, others have the data we need.

Anti-entropy involves comparing each piece of data on replicas and updating each replica to the newest version. A Merkle tree is used for inconsistency detection and minimizing the amount of data transferred.

A Hash tree or Merkle tree is a tree in which every non-leaf node is labeled with the hash of the labels or replica contents (in case of leaves) of its child nodes. Hash trees allow efficient and secure verification of the contents of large data structures.

Build the tree in a bottom-up fashion by comparing file integrity hash of every node at a given level, compare hashes in a top-down fashion and find the mismatch replica.

Used in version control systems like `Git` too.

### Bloom Filter
Answers the question "Is this item in the set?" with either a **confident "no"** or a **nervous "probably yes"**. False positives are possible, it is probabilistic.

We can check the database (expensive operation though) after bloom filter has answered with a "probably yes".

Can't remove an item from the Bloom Filter, it never forgets. Removal isn't possible since entries to the table for multiple items overlap most of the times.

Choose all hash functions with equal hash space.

The larger the Bloom Filter, the lesser false positives it will give. Memory and accuracy is a trade-off.

[Illustration Video](https://youtu.be/V3pzxngeLqw?t=207)

## Distributed Unique ID
Challenge: generating unique IDs in a distributed environment.

```txt
Multi-Master Replication 		- use SQL auto_increment on two servers
UUID 							- generate UUID separately on each app server
Ticket Server 					- a server that can output unique IDs based on SQL auto_increment, uses single row
Twitter Snowflake ID 			- a new format for unique IDs
Instagram's Approach 			- snowflake like IDs
```

**Multi-Master Replication**: uses the database `auto_increment` feature. Instead of increasing the next ID by 1, we increase it by `k`, where `k` is the number of database servers in use. This is done to divide generated ID space across servers.

Ex - Keep two servers to generate even and odd ID respectively, and round robin between the two servers to load balance and deal with down time. Not much scalable.

```txt
Server1:
auto-increment-increment = 2
auto-increment-offset = 1

Server2:
auto-increment-increment = 2
auto-increment-offset = 2


Server1 generates ID - 1, 3, 5 ...
Server2 generates ID - 2, 4, 6 ...
```

Cons: not scalable or customizable.

**UUID** (_Universally Unique Identifier_): 128-bit standard unique IDs that require no coordination when generating. Every UUID ever generated anywhere is guranteed to be unique!

> "after generating 1 billion UUIDs every second for approximately 86 years would the probability of creating a single duplicate reach 50%" - Wikipedia

```txt
Standard Representation => lower case Hex groups separated by hyphen = 8-4-4-4-12

Ex - 550e8400-e29b-41d4-a716-446655440000
```

Cons: super scalable, but not customizable (UUID have a fixed standardized format).

**Ticket Server**: ab(using) `auto_increment` feature of MySQL database and `REPLACE INTO` query to generate ID _using a single row_. Keep multiple tables like `Tickets32` and `Tickets64` for varying size IDs. Keep two servers in a multi-master fashion described above to ensure high availability.

Cons: SPOF, not really scalable or customizable.

[Reference](https://code.flickr.net/2010/02/08/ticket-servers-distributed-unique-primary-keys-on-the-cheap/)

**Snowflake ID**: 64-bit binary ID written as decimal. Guaranteed to be unique since it stores timestamp and machine and datacenter info. `sequence_number` is almost always `0` but if we generate multiple IDs in under 1ms, it is incremented to help us differentiate between them.
```txt
snowflake_id = timestamp + datacenter_id + machine_id + sequence_number

Ex - 1541815603606036480
```

Used at Twitter, Discord, Instagram, and Mastodon.

[Reference](https://blog.twitter.com/engineering/en_us/a/2010/announcing-snowflake)

**Instagram's Approach**: uses snowflake like 64-bit ID. Uses Postgres logical shards feature.

```txt
id = ts + logical_shard_id + table_auto_increment_seq_value
```

This Primary ID will be unique across all tables in the application (and as a bonus contains the shard ID).

[Reference](https://instagram-engineering.com/sharding-ids-at-instagram-1cf5a71e5a5c)

## URL Shortener
Specify either `301 - Moved Permanently` (subsequent requests go to new URL) or `302 - Found` (_moved temporarily_, subsequent requests keep going to short URL first, better for analytics) along with a `Location` header. It will redirect you to the URL specified in the location header.

{{% notice info %}}
It redirects directly since its standard HTTP! The response with the code 301 doesn't even show up in Postman. Eliminates the need for any redirect logic implementation.
{{% /notice %}}

1. Use message digest hashing algorithms like `SHA-1`, long fixed size hash but we take only a fragment of it which increases collision probability.
2. Use `base62` encoding: encodes to `0-9a-zA-Z` (total of 62 character mappings), long variable sized output string but we encode the corresponding unique `id` instead, becomes collision-free and short. The only caveat is that it can be reverse engg to find next `id` (next URL) since it is an encoding (two-way).

## Web Crawler
BFS search using queues (FIFO)

![](https://i.imgur.com/dBYR3ge.png)

```txt
	[Prioritizer]
		|
diff queues for diff priority sites (front queues)
		|
	[Queue Router]
		|
diff queues for each domain (back queues)
		|
	[Queue Selector]
    |	   |	   |
worker1  worker2   worker3
```

**Optimizations**:
- use single URL Frontier delegating to multiple worker nodes (distributed architecture), use consistent hashing
- cache DNS queries
- short timeout
- filter spam pages, redundant pages
- freshness: recrawl if too old

## Notification System
We send request to Third party Push Notification, SMS, or Email servers and they send out message to clients.

```txt
Microservices [S1 ... Sn]
	|
Notification Server (auth, rate limit) + Cache + DB
	|
  Queues (one for each - Android, iOS, SMS, Email)
    |
 Workers (pull messages from queue and send to third-party, retry mechanism, maintain log, templating)
 	|
 Third Party Service
 	|
  Client


Analytics Service (receives events from Notif server the client; to track message delivery and actions by user)
```

In a distributed system, it is impossible to ensure _exactly-once delivery_ (**Two Generals Problem**). Since there is no ACK from the Third-Party service that the message has reached the Client or not, it is acceptable to send the same message multiple times. To reduce such duplication, maintain a log (for the Worker) to know if the message has been seen before.