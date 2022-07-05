+++
title = "Caching"
date = 2021-05-23T11:16:29+05:30
weight = 3
+++

## Caching
Stores data on a _temporary_ basis such that datastore is not accessed on every request and we can show a cached response to repeated requests. This reduces _latency_, prevents unnecessary network calls and increases _responsiveness_. Caches usually store less amount of data than a datastore and access is faster, but reqires expensive hardware to run onto.

### Locality of Reference 
Cache is populated by copying data from datastore in majorly two ways:
- **Spatial Locality:** The data stored nearby to the recently accessed data has higher chances of being accessed next.
- **Temporal Locality:** The data that was most recently accessed has higher chances of being accessed next. 

### Types of Cache
**1. Private:** Broswer caches, client keeps this. Implemented at client.

**2. Shared Proxy Cache:** Proxy caches, Intermediate web proxy uses these, they typically store data of multiple clients. Implemented by ISPs.

**3. Reverse Proxy Cache:** Multiple-servers sharing a single cache at server-side near datastore. Implemented at server.

![](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching/http_cache_type.png)

### Cache Policy
How to populate data, when to discard, etc...
```txt
Cache eviction (remove data from cache)

Cache validation
Cache invalidation (invalidate cache data)

Thrashing: If the cache is small in size, it may frequently evict useful data.
```

```txt
Terminology:
	Cache hit
	Cache miss

	Pre-warming
```

#### Cache Eviction
When to dicard cached data.
```txt
LRU (Least Recently Used)
LFU (Least Frequently Used)
FIFO (First In First Out)
TTL (Time To Live)
```

#### Caching Patterns
How to populate cache.
```txt
Cache-aside
Read-through

*Write-through
*Write-back
```
[Reference](https://notes.eddyerburgh.me/distributed-systems/caching#caching-patterns)

## HTTP Caching 
**Targets:** 200, 301, 404, 206, others...

### Controlling caching
```txt
Cache-Control: no-store (no caching)
			   no-cache (cache but revalidate)
			   private (only cache on client, not proxy)
			   public (cache everywhere)


<!-- Expiration -->
			   max-age=<seconds>
			   max-age=3600
			   s-maxage=<seconds>


<!-- Validation -->
			   must-revalidate
			   proxy-revalidate


<!-- Combination can be done -->
Cache-Control: no-cache, must-revalidate, max-age=1800
```

### Freshness
A **stale resource** is not evicted or ignored but it is validated.

Heuristic freshness checking takes place if no age using `Cache-control` is specified.
[Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching#freshness)

### Revving
Name infrequently updated resources with revision numbers such that the older revision will get evicited after sometime if they ever get updated to a newer one.

### Cache Validation
Revalidation is triggered when the user presses the reload button. It is also triggered under normal browsing if the cached response includes the `Cache-Control: must-revalidate` header. In requests, `If-None-Match` and `If-Modified-Since` are used to validate.

#### ETag (strong)
If a resource changes, server sends a new `ETag` value in response to be cached to indicate to the client that some change has taken place. The client can't predict, in any way, the value of the tag. Client issues `If-None-Match` in the header of future requests – in order to validate the cached resource.
```txt
ETag: "j82j8232ha7sdh0q2882" - Strong Etag
ETag: W/"j82j8232ha7sdh0q2882" - Weak Etag (prefixed with `W/`)
```
Weak ETag maybe used for slight changes in resources.

#### Last-Modified (weak)
A response tag, this is weak validator because resolution time is 1-second. Server might include the `Last-Modified` header in the response to be cached indicating the date and time at which some content was last modified on.
```txt
Last-Modified: Wed, 15 Mar 2017 12:30:26 GMT
```
The client issues an `If-Modified-Since` request header to validate the cached document. The server can either send a `200 (OK)` or a `304 (Not Modified)` (with an empty body) in response.

We can have both `ETag` and `Last-Modified` present in response but `AND` operation is done i.e. both the conditions have to be satisfied.

### Varying Responses
We can specify another header in `Vary` of response header. It determines how to match future request headers (those specified in `Vary`) to decide whether a cached response can be used, or if a fresh one must be requested from the origin server.

[References](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching#varying_responses)

## References
- [Hussein Nasser - YouTube](https://www.youtube.com/watch?v=ccemOqDrc2I)
- [Gaurav Sen - YouTube](https://www.youtube.com/watch?v=U3RkDLtS7uY)
- [Caching: CS Notes - eddyerburgh.me](https://notes.eddyerburgh.me/distributed-systems/caching)
- [MDN Docs- Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
- [HTTP Caching - roadmap.sh](https://roadmap.sh/guides/http-caching)