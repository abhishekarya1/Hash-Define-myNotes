+++
title = "Book"
date = 2023-11-24T08:02:00+05:30
weight = 3
+++

## Capacity Estimation
Latency numbers every programmer should know with Humanized Scale: https://gist.github.com/hellerbarde/2843375

ByteByteGo YouTube Video: https://youtu.be/FqR5vESuKe0

Traffic, Storage, and Bandwidth Estimation Example: https://youtu.be/-frNQkRz_IU

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