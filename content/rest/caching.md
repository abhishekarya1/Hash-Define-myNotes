+++
title = "Caching"
date = 2021-05-23T11:16:29+05:30
weight = 2
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
Cache eviction

Cache validation
Cache invalidation

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
			   private
			   public


<!-- Expiration -->
Cache-Control: max-age=<seconds>
Cache-Control: max-age=3600
			   s-maxage=<seconds>


<!-- Validation -->
Cache-Control: must-revalidate
			   proxy-revalidate
```

### Freshness
A stale resource is not evicted or ignored but a request with header `If-None-Match` is sent to validate.

Heuristic freshness checking takes place if no age using `Cache-control` is specified.
[Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching#freshness)

### Revving
Name infrequently updated resources with revision numbers such that the older revision will get evicited after sometime if they ever get updated to a newer one.

### Cache Validation
Revalidation is triggered when the user presses the reload button. It is also triggered under normal browsing if the cached response includes the `Cache-Control: must-revalidate` header. In requests, `If-None-Match` and `If-Modified-Since` are used to validate.

#### ETag (strong)
If a resource changes, we send a new `ETag` value in response to indicate to the client that some change has taken place. Client issues `If-None-Match` in the header of future requests – in order to validate the cached resource.
```txt
ETag: "j82j8232ha7sdh0q2882" - Strong Etag
ETag: W/"j82j8232ha7sdh0q2882" - Weak Etag (prefixed with `W/`)
```

#### Last-Modified (weak)
This is weak validator because resolution time is 1-second. The client issues an `If-Modified-Since` request header to validate the cached document.

### Varying Responses
We can specify another header in `Vary` of response header. It determines how to match future request headers (those specified in `Vary`) to decide whether a cached response can be used, or if a fresh one must be requested from the origin server.

## References
- [Hussein Nasser - YouTube](https://www.youtube.com/watch?v=ccemOqDrc2I)
- [Gaurav Sen - YouTube](https://www.youtube.com/watch?v=U3RkDLtS7uY)
- [Caching: CS Notes - eddyerburgh.me](https://notes.eddyerburgh.me/distributed-systems/caching)
- [MDN Docs- Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
- [HTTP Caching - roadmap.sh](https://roadmap.sh/guides/http-caching)