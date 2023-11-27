+++
title = "Book"
date = 2023-11-24T08:02:00+05:30
weight = 3
+++

## Capacity Estimation
Latency numbers every programmer should know with Humanized Scale: https://gist.github.com/hellerbarde/2843375

ByteByteGo YouTube Video: https://youtu.be/FqR5vESuKe0

Traffic (_requests per sec_), Storage, and Bandwidth (_data per sec_) Estimation Example: https://youtu.be/-frNQkRz_IU

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
Data Partition - consistent hashing
Data Replication - consistent hashing (copy data onto the next three unique servers towards the clockwise direction)
Consistency - Quorum Concensus
Inconsistency Resolution - Versioning (Vector Clock)
```

### Quorum Concensus
Ensures data read and write consistency across replicas.

**Approach**: We need atleast `W` replicas to acknowledge a write operation, and atleast `R` replicas to acknowledge a read operation for it to be declared successful, where `N` is the total number of replicas.

**Configuration**:
```
If R = 1 and W = N, the system is optimized for a fast read
If W = 1 and R = N, the system is optimized for fast write
If W + R > N, strong consistency is guaranteed (guranteed that there is always one node with latest write data and its part of read concensus)
If W + R <= N, strong consistency is not guaranteed
```

In case of a read where we get diff values of the same data object from diff replicas, we use versioning to differentiate them. Ex - `(data, timestamp)`, we'll keep the one with the latest timestamp.

[Illustration Video](https://youtu.be/uNxl3BFcKSA)