+++
title = "Book 1"
date = 2023-11-24T08:02:00+05:30
weight = 4
+++

## Capacity Estimation
Latency numbers every programmer should know (with Humanized Scale): [Gist](https://gist.github.com/hellerbarde/2843375)

Latency numbers for 2020s: [ByteByteGo Video](https://youtu.be/FqR5vESuKe0)

![](https://i.imgur.com/rHifWwO.png)

**Estimation Parameters**:
- Traffic: read/write requests per sec (DAU, QPS, Read-Write Ratio)
- Storage: depends upon _data retention period_
- Bandwidth: data per sec

Example: [Video](https://youtu.be/-frNQkRz_IU)

**Approximation**:
```txt
1 million req/day = 12 req/sec
```

## Framework for Interviews
1. Understand the problem (functional and non-functional requirements)
2. Capacity Estimation (_optional_; do here on in summary)
3. High Level Design
4. Deep Dive into components
5. Summarize

## Rate Limiting
Also known as **Throttling**. Client-side is susceptible to forging, server-side is preferred with a reverse proxy (rate limiting middleware) before API server.

We need to implement throttling _per API endpoint per User_ depending on the design.

Performed in Networks too as part of _Congestion Control_ (use IPTables on Network Layer to set quota for IP Addresses).

Saves from DOS attack, reduces load, saves costs and bandwidth.

### Algorithms

1. **Token Bucket** - suitable for burst traffic, ideal for real-time applications
2. **Leaky Bucket** - FIFO queue, suitable for fixed rate flow of requests
3. **Fixed window counter** - spikes on the edges of windows ruins this
4. **Sliding window log** - overhead of storing logs for requests which were rejected
5. **Sliding window counter** - combination of above two, best algo

```txt
Token Bucket

- instead of refilling buckets of millions of users (write heavy) acc to refill rate, refill only upon the next request for a single user based on the time diff since last request for that user (smart)

- accumulates tokens only upto the bucket size, then reject requests

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

- create a new counter (having current window start time as ts) upon a request for a user, increment it on every subsequent request in the same window or reject requests if they're more than the window size; remove key-value entries at each window end to ensure that stale ones don't stick around forever

- window duration, window size

- we can entirely skip ts in key but we'll need that in Sliding Window Counter approach below

"user_1_1490868000": 1
```

```txt
Sliding window log

- store a log (in a sorted set) for every incoming request, discard outdated logs (log_ts < current_ts - window_duration), check if log size is less than our window size limit and reject if requests are more than window size

- window duration, window size

"user_1" : {
	1490868000
	1490868010
	1490868020
}
```

**NOTE**: The approach described in most sources including the book has a major caveat. If requests keep coming in, the system won't be able to process any of them after a while since rejected requests will keep filling up log for the rolling window. Store logs only for successful requests to avoid this. [Reference](https://www.reddit.com/r/AskComputerScience/comments/xktn2j/rate_limiting_why_log_rejected_requests/)

```txt
Sliding window counter

- store counter for each fixed-sized window as well as logs

- for an incoming request increment counter for the corresponding fixed-window ts, check by adding all counters in the current log, allow if below limit

- remove all fixed-window counter logs after each window duration

- fixed-window duration (smaller), window duration, window size 

"user_1" : {
	1490868000: 1,
	1490868010: 2
}
```

Reference: https://www.figma.com/blog/an-alternative-approach-to-rate-limiting

### Enhancements
Return HTTP response code `429 - Too Many Requests`. Also, return response headers (like `X-Ratelimit-RetryAfter`) to let the user know they are being throttled, and how much time they need to wait (backoff/cooldown/retry after).

**Hard Limit**: stop exactly after a given number of requests.

**Soft Limit**: less strict enforcement, continues to process some additional requests even after the threshold has been crossed.

### Issues
In a distributed environment, single rate limiter cache (counter, bucket, etc...) can face **Race Condition**. Sorted sets in Redis can resolve this as its operations are atomic.

If we use multiple rate limiters, we need **Synchronization** so that both the rate limiter know the current value of counter for a given user, to use them interchangeably. Use a shared cache used by both the rate limiters.

## Consistent Hashing
Eficiently choosing a server for our request in a distributed and scalable environment. Used wherever we need to choose a server amongst multiple i.e. choosing partitions, load balancing, etc.

Ex - Amazon DynamoDB, Apache Cassandra, Akamai CDN, nearly all Load Balancers, etc.

### Classic Hashing
Use a uniformly distributed hash function (`hash`), hash request keys (`key`), and perform modulo on the output with the server pool size (`N`) to route to a server. 

```
serverIndex = hash(key) % N
```

It can uniformly distribute requests across existing servers but scaling is an issue - if servers are added or removed, all requests need to be remapped with a new `N` and we lose cached data for all requests (_cache miss_) since we reassign servers to all requests.

### Consistent Hashing
In case of addition or removal of servers, we shouldn't need to remap all they keys but only a subset of them - `1/N`th portion of hash space.

**Approach**: Hash requests based on some key and hash servers based on IP using the same hash function (`hash`). Ex - use `SHA-1` for `0` to `(2^160)-1` possible hashes. This ensures equal hash space for both requests and servers. And we don't need to perform modulo operation here. No change in architecture is required here unlike classical hashing which required change to server pool size (`N`) parameter upon removal or addition of servers.

- Connect **Hash space** virtually in a circular fashion to form a **Hash ring** - should be same for both requests and server, use same hash function for both
- **Partition** - hash space between adjacent servers

For each incoming request, if a server is not available for the same hash, probe clockwise (Linear or Binary Search) and use whatever server is encountered first. Each server is now responsible of handling requests of a particular range of hashes from the ring (_partition_).

Addition and removal of servers won't bother us now since probe will take care of finding servers.

Find affected keys - if a server is added/removed, move anti-clockwise from that server and all keys till the first server is encountered will have to be remapped.

[Illustration Video](https://youtu.be/UF9Iqmg94tk)

### Virtual Nodes
**Non-uniform distribution** - some servers may get the majority of the traffic (_hotspots_), while others sit idle based on their position on the hash ring.

If we're probing clockwise, there might be a server that is closer but on the anti-clockwise direction of the hash, we place virtual redundant **Virtual Nodes** or Replicas to resolve this.

Virtual nodes route to an actual server on the ring, and they need not be adjacent servers of the virtual node.

Place as many virtual nodes across hash space such that response time of a request is minimized (directly proportional to the nearest node it can connect to). If multiple servers go down in sequence, then we can jump ahead using Virtual Nodes.

### Drawbacks
**Cascading failures**: subsequent servers crash if one gets swamped with requests.

**Hotspots**: non-uniform distribution of nodes and data.

Memory costs and operational complexity increase in general with Consistent Hashing.

[Comprehensive Article](https://systemdesign.one/consistent-hashing-explained/)

## Key-Value Store
```txt
Data Partition 				- Consistent Hashing (route requests to partitions based on key's hash space they handle)
Data Replication 			- Consistent Hashing (copy data onto the next three unique servers towards the clockwise dir)
Consistency 				- Quorum Concensus
Inconsistency Resolution 	- Versioning (Vector Clock)
Failure Detection 			- Gossip Protocol
Handling Temporary Failures - Sloppy Quorum with Hinted Handoff
Handling Permanent Failures - Anti-Entropy Protocol with Merkle Tree
Fast Lookup 				- Bloom Filter
```

### Quorum Concensus
Ensures data read and write consistency across replicas.

**Approach**: Client sends request to a _coordinator node_, all replicas are connected to a coordinator. We need atleast `W` replicas to perform and acknowledge a write operation, and atleast `R` replicas to perform and acknowledge a read operation for it to be declared successful, where `N` is the number of nodes that store replicas of a particular data (and **not the total number of replica nodes in the system**).

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
We keep a Vector Clock `D([Si, Vi])` for each data item in the database and by comparing two clocks we can identify if a data item's versions precedes, succeeds or in conflict, where `Si` is the server writing data item `D` and updating its version to `Vi` (_always increases with every write_).

```txt
Vector Clock = D([Si, Vi])

Example - D([S1, V1], [S2, V2], ..., [Sn, Vn]) - this represents servers that've acted upon on a data item (D) and version changes it went through
```
```txt
Comparing Clocks: first compare server and then version for both; corresponding servers should be same; versions should be increasing, or decreasing, or constant across all corresponding servers for both versions of the clock to eastablish a chronology, never mixed

D([Sx, 1])		-- parent (happened first chronologically)
D([Sx, 2])		-- child (happened later chronologically, in the next consecutive write)

D([Sx, 1])				-- parent
D([Sx, 1], [Sy, 1])		-- child

D([Sx, 1], [Sy, 2])
D([Sx, 2], [Sy, 1])		-- conflict; how can Sy's version decrease when Sx is clearly indicating succeeding clock (mixed)

D([Sx, 1], [Sy, 2])
D([Sx, 1], [Sy, 1])		-- this happend first (parent)

D([Sx, 1], [Sy, 1])
D([Sx, 1], [Sz, 1])		-- conflict; Sy and Sz both unaware of the other's write (parallel write; siblings)

D([Sx, 1], [Sy, 1], [Sz, 1])	-- after resolving above conflict
```

Storing vector clocks along with data objects is an overhead. If they get too longr, just delete record of old writes (i.e. leftwards clock entries).

### Gossip Protocol
Once a server detects that another server is down, it propagates info to other servers and they check their membership list to confirm that it is indeed down. They mark it as down and propagate the info to other servers.

```txt
node membership list - memberID, heartbeat counter, last received
```

If a server's heartbeat counter has not increased for more than a predefined period, it is considered as offline.

Used in P2P systems like `BitTorrent` protocol.

### Sloppy Quorum w/ Hinted Handoff
Instead of enforcing the quorum requirement of choosing from `N` nodes that store replica of a particular data (and **not the total number of replica nodes in the system**), the system chooses the first `W` healthy nodes for writes and first `R` healthy nodes for reads on the hash ring. Offline servers are ignored.

When the down server goes up, changes will be pushed back to the replicas which are supposed to store that data to achieve data consistency - **Hinted Handoff**.

```txt
Even if W + R > N, strong consistency can't be guaranteed in case of Sloppy Quorums
			  	   since with N = 3 (A, B, C), we wrote to nodes A, C and read from D, E because of down servers
			  	   no overlap even if the condition was satisfied
			  	   hinted handoff will add data to B once its up
```

Enabled by default in DynamoDB and Riak.

[Reference](https://jimdowney.net/2012/03/05/be-careful-with-sloppy-quorums/) ([Wayback Machine](https://web.archive.org/web/20221101141359/https://jimdowney.net/2012/03/05/be-careful-with-sloppy-quorums/))

### Anti-Entropy Protocol w/ Merkle Tree
Keep replicas in sync periodically so that if one of them goes down, others have the data we need.

Anti-entropy involves comparing each piece of data on replicas and updating each replica to the newest version. A Merkle tree is used for inconsistency detection and minimizing the amount of data transferred.

A Hash tree or Merkle tree is a tree in which every non-leaf node contains a hash of its child nodes' hashes and actual replica contents as leaves. Hash trees allow efficient and secure verification of the contents of large data structures by localizing mismatched part of data.

- **Build** the tree in a bottom-up fashion by comparing file integrity hash of every node at a given level.
- **Compare** two Merkle trees by comparing hashes of corresponding nodes in a top-down fashion and find the mismatching part of data.

Used in version control systems like `Git` too.

### Bloom Filter
Bloom filter is a space-efficient probabilistic data structure to check set membership. Often Bit array data structure is used for impl.

Answers the question "Is this item in the set?" with either a **confident "no"** or a **nervous "probably yes"**. False positives are possible, therefore it is probabilistic.

We can check the database (expensive operation though) after bloom filter has answered with a "probably yes".

Can't remove an item from the Bloom Filter, it never forgets. Removal isn't possible since entries to the table for multiple items may overlap.

Choose all hash functions with equal hash space. Or more practically, perform modulo `N` on the resulting hash, where `N` is the filter size (i.e. number of buckets).

- **Add an item**: choose `k` hash functions and perform hashing of item with each, modulo each resultant hash with `N`, and set the corresponding bucket in the filter.
- **Check an item**: perform hashing of item with the same hash functions, modulo each resultant hash with `N`, and check if the corresponding buckets in the filter are set. If they're all set, then item "may exist", otherwise it "definitely doesn't exist".

The larger the Bloom Filter, the lesser false positives it'll give. Memory vs accuracy trade-off.

**Algorithmic Complexity** - `O(k)` TC and `O(1)` SC (_both constants_).

[Illustration Video](https://youtu.be/V3pzxngeLqw?t=207)

[Comprehensive Article](https://systemdesign.one/bloom-filters-explained/)

## Distributed Unique ID
Challenge: generating unique IDs in a distributed environment.

```txt
Multi-Master Replication 		- use SQL auto_increment on two servers
UUID 							- generate UUID anywhere (scales out really well)
Ticket Server 					- a server that can output unique IDs based on SQL auto_increment, uses single row
Twitter Snowflake ID 			- a new format for unique IDs (use generator servers to produce; scales out well)
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
Specify HTTP response code along with a `Location` header. Either send back `301 - Moved Permanently` (browser caches response and all subsequent requests go to new URL) or `302 - Found` (_moved temporarily_, subsequent requests keep going to short URL first, better for analytics). The client will redirect automatically to the URL specified in the location header.

{{% notice info %}}
It redirects automatically since its standard HTTP! The response with the code 301 doesn't even show up in Postman (since it supports redirection by default). Eliminates the need for any redirect logic implementation on the client.
{{% /notice %}}

```txt
API Design
-----------

POST /api/v1/shorten
Send long URL in JSON Body, get short URL back

GET /api/v1/longUrl
Send short URL in body or as query param, get long URL back

GET /{short_code}
Redirects using the HTTP status code and response header
```

**Design Pointers**:
1. Use message digest hashing algorithms like `SHA-1`, long fixed size hash but we take only a fragment of it which increases collision probability.
2. Use `base62` encoding: encodes to `0-9a-zA-Z` (total of 62 character mappings), long variable sized output string but we encode the corresponding unique `id` of the long URL entry in data store, becomes collision-free and meaningless to snoopers. The only caveat is that it can be reverse engg to find next `id` (next URL) since it is an encoding (two-way).
3. Take hash length as 6 or 7 as its enough to store `62^7 ~ 3.5 trillion` URLs.
4. Store in Redis Hash or SQL DB with schema as `URL_table(id, shortURL, longUrl)`.
5. Use a cache if DB is large. Use rate limiter and analytics to limit and track users respectively.

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

## News Feed
For each user, maintain a temporary (_ephemeral_) **News Feed Cache** and we can write to our friend's feed cache, or others can read from our feed cache. Both may use a **Fanout Service** to do so.

Stages:
- Store Feed: Store post in Post DB, send info to Notification Service, then call Fanout Service to write `user_id` and `post_id` KV pair to News Feed Cache. Use user details from User DB to filter (user blocklists, etc) before writing to News Feed Cache.
- Build Feed: On a friend's device when building the feed, primary server contacts News Feed Service to fetch posts, also fetch post and user data corresponding to the `post_id` in the KV pair from respectice DBs.

**Fanout**: one-to-many spread of data

- Fanout on Write: also called _push_ model. Send post to friend's feed caches as soon as its posted. Faster but what if a user isn't that active? we'll be wasting resources. (_pre-compute_ feed)
- Fanout on Read: also called _pull_ model. When a friend loads the feed, fetch posts from the feed cache of all its friends. Slower to fetch posts but practical.

Choose a hybrid model. Celebrity posts are delivered via pull model, for normal accounts implement push model (since posts and followers will be far lesser).

```txt
Post Service
Post Cache + Post DB

Fanout Service 			(and its worker clones for each user) (filters users and content)

Notification Service

User Relation DB 		(graph datastore)

User Cache + UserDB

Message Queues 			(one queue per user)

News Feed Service 		(used only during build feed)
News Feed Cache 		(stores only <user_id> to <post_id> KV pairs)
```

## Chat System
Both users connect to chat servers via WebSocket Protocol, and servers are synced with each other using MQs in between.

Types:
- DM (sortable `message_id`)
- Group Chat (sortable `message_id` and a `channel_id`)

When a new message is to be delivered to client, how can the chat server send us that? Since the connection is initiated by the client and are supposed to be short-lived?
- **Regular Polling**: client polls server at short intervals, inefficient as it wastes bandwidth
- **Long Polling**: client holds the connection open till a message arrives or timeout happens, connection is then closed immediately and process restarts. Client holds the connection hostage even when nothing is actually being shared. 
- **WebSockets Protocol**: layer-7 protocol based on HTTP over port 80/443, starts with a HTTP upgrade handshake and becomes persistent open connection allowing real-time full-duplex communication

Three types of components:
- Stateless: API Server, Auth Server, Service Discovery to find chat servers 
- Real-Time: Chat Server and Presence Server
- Third-Party: Notification Service

Storage:
- use NoSQL stores like Cassandra (Discord) or HBase (FB Messenger) to store non-structured data quickly, offers high scalability, chat lookups aren't that much so we focus on write speed rather than to optimize reads.

```txt
Service Discovery - to find our API Server a nearest chat server (Apache Zookeper)

Message Sync Queues - One MQ per Receiver: WeChat uses this, can be not so scalable for Group Chat

Presence Servers - User sends a heartbeat to PS at regular intervals, if timeout happens and we didn't receive it, then user's status changes, fanout status to other users and store last_seen in datastore

Sync Devices of a Single User - store latest message_id in a datastore on chat server shared between both devices
```

## Search Autocomplete
Ping with GET request multiple times each second as the user is typing.

```txt
search?q=di
search?q=din
search?q=dinn
search?q=dinne
search?q=dinner
```

Get _k_ most searched queries using Trie data structure for fast re**trie**val. Build tries periodically with query data from the Aggregator Service and store in Trie DB.


## YouTube
```txt
CDN - store videos as BLOB (Binary Large OBjects)
API Servers - everything else
```

**Upload**: transcode video and save metadata (use Completion Queue and Completion Handler), replicate to CDN worldwide
```txt
Video must be quickly playable on all kinds of devices, with seek (random access). Trancode it, save diff bitrate (for adaptive bitrate), and save diff resolutions.

Transcoding - video container (.mp4, .webm) and compression codec (H.264, VP9, HEVC), split video in sections (GOP alignment), split video into channels (video, audio, captions, watermark) (use DAG), save diff resolutions of the same video

DAG: we can configure and parallelize steps in transcoding by defining a DAG, combine them all at the end. Use DAG scheduler to put task messages in the queue.
```

Use MQs between every component to make entire pipeline async. Get a "pre-signed" URL from Amazon S3 or Azure Blob Storage using API, and use that URL to upload video files to them.

```txt
DRM - Google Widevine

AES Encryption - encrypt video during upload, decrypt during playback

Long-Tail Distribution - store most popular videos in CDN, videos with very less views in Video Servers
```

**Stream**: download in chunks using streaming protocols like MPEG-DASH (Dynamic Adaptive Streaming over HTTP), Apple HLS (HTTP Live Streaming), or WebRTC. The resolution and bitrate may change frequently based on the client's network bandwidth.

Enhancements - live streaming (real-time video transcoding) and content filtering.

**References**:
- GOP: https://aws.amazon.com/blogs/media/part-1-back-to-basics-gops-explained
- HTTP Video Streaming: https://aws.amazon.com/blogs/media/back-to-basics-http-video-streaming
- Streaming Protocols: https://www.dacast.com/blog/streaming-protocols

## Google Drive
Needs sync so strong consistency is expected, use a relational database (ACID out-of-the-box).

Use third-party large storage service like Amazon Simple Storage Service (S3). Provides automatic cross-region replication, sharding, etc.

Allow resumable uploads `?uploadType=resumable` to recover from network failure during uploads.

```txt
Block Server - split files into blocks before uploading to S3, compress (gzip, bzip2) and encrypt each block, store block metadata (block_id, hash, block_order) in Metadata DB to avoid duplicates, etc.

Delta Sync - on file modification, only modified blocks are synced using a sync algorithm e.g. Differential Synchronization
```

Notification service is used for sync - accessed by other active clients via long polling. If a client is offline, save file changes in cache or offline backup MQ to replay when it becomes active.

**Optimizations**:
- Cold Storage: infrequently accessed data can be moved to another storage service like Amazon S3 Glacier
- Real-time file modification (Google Docs) using DifDifferential Synchronization Strategies

**Links**:
- Differential Synchronization Strategies - https://neil.fraser.name/writing/sync/