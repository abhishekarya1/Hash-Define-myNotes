+++
title = "Caching"
date = 2021-05-23T11:16:29+05:30
weight = 4
+++

## Caching
Stores data on a _temporary_ basis such that datastore is not accessed on every request and we can send a cached response to repeated requests. This reduces _latency_, prevents unnecessary network calls and increases _responsiveness_. Caches usually store less amount of data than a datastore and access is faster, but reqires expensive hardware to run onto.

### Locality of Reference 
Cache is populated by copying data from datastore in majorly two ways:
- **Spatial Locality**: The data stored nearby to the recently accessed data has higher chances of being accessed next.
- **Temporal Locality**: The data that was most recently accessed has higher chances of being accessed next. 

### Types of Cache
1. **Private Caches**: Broswer caches, only the client maintains and accesses it.

2. **Shared Caches**: Implemented at intermediate web proxy servers. Data stored on them is accessed by multiple clients.
	- **Proxy Caches**: Implemented at proxy servers either in client's network (forward proxy) or sit in between the client and server networks.
	- **Managed Caches**: Implemented in server's network. Examples include reverse proxies, CDNs, and server cache.

![](https://i.imgur.com/eta6W0h.png)

|  Forward Caches | Reverse Caches  |
|:---:|:---:|
|  Client's private cache and shared proxy caches (like ISP caches) |  All caches that reside in server's network (this includes CDNs too) |


**Forward Proxy vs. Reverse Proxy**:
![](https://i.imgur.com/TPIUsxm.jpg)

_References_:
- [HTTP Caching - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
- [Web Cache - Wikipedia](https://en.wikipedia.org/wiki/Web_cache)

### CDN
**Content Delivery Networks** utilize edge servers to cache static content (and in some cases dynamic too). Proxy servers are placed such that they are located closer to end users than origin servers for faster response times.

Components:
1. origin server
2. edge servers (proxy)

For serving content they often take a pull-based approach in which content is pulled from the origin server (if not present in edge server) upon request of the client. Some CDNs like [Netflix's Open Connect](https://openconnect.netflix.com/en/) employ a push-based approach for serving video files.

[Must read notes](https://notes.eddyerburgh.me/distributed-systems/caching#cdns) 

_Reference_: [What is Caching? - Cloudflare](https://www.cloudflare.com/en-in/learning/cdn/what-is-caching/)

### Cache Policy
How to populate data, when to discard, and validation with main datastore.
```txt
Cache eviction (remove data from cache)

Cache validation (validate that same data exists in main datastore)
Cache invalidation (invalidate cache data; datastore data doesn't match cache's)

Thrashing: If the cache is small in size, it may frequently evict useful data. Use a relevantly sized cache.
```

```txt
Terminology:
	Cache hit
	Cache miss

	Cold cache
	Warm cache
	Pre-warming

	Stale Data
	Fresh Data
```

#### Cache Eviction
When to discard cached data.
```txt
LRU (Least Recently Used)
LFU (Least Frequently Used)
------------------------------ the above two require extra storage to store metadata
FIFO (First In First Out)
TTL (Time To Live)
```

#### Caching Patterns
Where to place the cache and how to populate it.
```txt
Cache-aside

Read-through

Write-back (aka Write-behind)
Write-through
Write-around (write to DB directly bypassing the cache)
```

_Cache-aside_ requires a separate expensive operation of storing data from the database to the cache for future reads.

[Reference](https://notes.eddyerburgh.me/distributed-systems/caching#caching-patterns)

## HTTP Caching
HTTP is designed to cache as much as possible, so even if no `Cache-Control` is given, responses will get stored and reused if certain conditions are met. This is called **heuristic caching**. All responses should still explicitly specify a `Cache-Control` header.

A very old `Last-Modified` response will be implicitly cached and used for sometime since HTTP knows that data which hasn't changed in so long will not change now. This is an example of heuristic caching in HTTP.

It also provides stale data in the response in some cases without validation e.g. when the main datastore is unreachable.

### Controlling caching
HTTP/1.1 introduced `Cache-Control` header to control caching. It can be used in request as well as response. And, its a composite header meaning it supports multiple directives separated by a comma (`,`).

```txt
Cache-Control: no-store (no caching anywhere)
			   no-cache (cache everywhere but revalidate from DB everytime)
			   private (only cache on client, not any proxy)
			   public (cache everywhere)


<!-- Expiration (time unit = seconds), data becomes stale after this time is elapsed -->
			   max-age=3600
			   s-maxage=1000


<!-- Force validation; if resource has gone stale, otherwise no effect -->
			   must-revalidate
			   proxy-revalidate


<!-- Specifying multiple directives -->
Cache-Control: no-cache, must-revalidate, max-age=1800
```

Note that if the response has an `Authorization` header, it cannot be stored in the private cache (or a shared cache) unless `public` is specified. Specifying it as `public` comes at its own risks though.

[Cache-Control Header - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)

### Freshness
After the time set by `max-age` or `s-maxage` has elapsed, the data becomes stale and must be revalidated, not evicted or ignored.

Note that `max-age` takes into account the time elapsed since the response was generated, and not when it was received by the client. We can optionally have a `Age` header which specifies the time a response has spent in proxy caches before reaching the client and after its release from the origin server.

```foobar
Cache-Control: max-age=604800
Age: 86400
```
So, for the client this response remains fresh for another 604800-86400 seconds.

Note: HTTP/1.0 uses `Expires` header to specify date and time but it's not preferred in further versions since date and time are difficult to parse.

### Vary
We not only depend upon the URL to cache data but on the content too. 

For example, one URL that accepts both English and Hindi content and client specifying it via `Accept-Language: en` or `Accept-Language: hi` headers will require us to cache contents of both types of responses in two separate key-value stores by forming a composite key from `URL + content language` info. 

We can cause the responses to be cached separately by providing _any_ request header name to `Vary` response header. 
```foobar
Vary: Accept-Language
```

Be careful not to `Vary` on headers that change values frequently.

### Cache Validation
Validation of cache contents can be triggered if the request includes `no-cache` directive or if the resource requested for has gone stale and request has `must-revalidate` directive.

Server can send us `Etag` or `Last-Modified` headers and we can validate with `If-None-Match` and `If-Modified-Since` headers respectively.

#### ETag (strong)
Etag (entity tag) is just a unique identifier that the server attaches with some resource. When data is stale in cache, a request is sent containing `If-None-Match: <etag_value>` for validation.

We can generate ETag via any method as its not specified in HTTP docs. Usually a collision-resistant hash function is used to assign Etags to each version of a resource. We often use [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier).

Upon fetching a resource, server sends an `ETag` value in response to the client. The client can't predict, in any way, the value of the tag. Client issues `If-None-Match` in the header of future validation request – in order to validate the cached resource. Upon receiving the Etag back, the server generates an etag for the current state of the resource in the database and matches the two.

If both etags are matched, server will send back the response of `304 Not Modified` which will tell the client that the copy that it has is still good and it will be **considered fresh for another `max-age` seconds**. If both the etags do not match i.e. the resource has likely changed and client will be sent the new resource which it will use to replace the stale resource that the client has.

```foobar
ETag: "j82j8232ha7sdh0q2882" 	- Strong Etag
ETag: W/"j82j8232ha7sdh0q2882" 	- Weak Etag (prefixed with `W/`)
```
Weak ETag is used for slight changes in resources, often used for dynamic resources.

#### Last-Modified (weak)
This is a weak validator because resolution time (minimum time gap) is 1-second. Server might include the `Last-Modified` header in the response to be cached indicating the date and time at which the resource was last modified on.
```foobar
Last-Modified: Wed, 15 Mar 2017 12:30:26 GMT
```
The client issues an `If-Modified-Since` request header with same date and time to validate the resource. The server can either send a `200 OK` or a `304 Not Modified` (with an empty body) in response.
```foobar
If-Modified-Since: Wed, 15 Mar 2017 12:30:26 GMT
```

We can have both `ETag` and `Last-Modified` present in response lying in the cache, `ETag` takes precedence and the cached data is revalidated using it.

The "client" above, for the purpose of validation refers to the system containing the cache whose data needs to be revalidated. It can be browser (private cache), or a proxy server. When validation is required, request headers like `If-None-Match` are sent by it to the origin server containing the main datastore.

### Avoiding Revalidation
Browsers often send `max-age=0, must-revalidate` on force reloads and that will revalidate every resource. To avoid that we can specify a very long `max-age=999999999` and an `immutable` directive.

```foobar
Cache-Control: max-age=999999999, immutable
```

### Good Practices
```foobar
Cache-Control: no-cache, private
```
Always revalidates and keeps cache only for client for personalized information.

- Be very careful with shared caches. When in doubt, always go for `private` cache visibility to not store sensitive personal data in shared proxy caches.

- Always add a validator (`ETag` or `Last-Modified`) to the request. Prefer `ETag`. 

- `Cache-Control: public` can even cache responses having an `Authorization` header, use it very carefully if at all.

## References
- [Caching: CS Notes - eddyerburgh.me](https://notes.eddyerburgh.me/distributed-systems/caching)
- [HTTP Caching - roadmap.sh](https://roadmap.sh/guides/http-caching)
- [HTTP Caching - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
- [Hussein Nasser - YouTube](https://www.youtube.com/watch?v=ccemOqDrc2I)
- [Gaurav Sen - YouTube](https://www.youtube.com/watch?v=U3RkDLtS7uY)