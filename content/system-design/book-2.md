+++
title = "Book 2"
date = 2023-12-26T05:00:00+05:30
weight = 5
+++

## Proximity Service
Two components:
- Location-based service (LBS) (read only)
- Business-related service (write heavy)

Geospatial Databases - Geohash in Redis, Postgres with PostGIS extension

Latitude and Longitude are measured in degrees and represented as a `double` value.

### GeoSearch Algorithms
1. **2-D Search**: naive approach
```sql
SELECT business_id, longitude, latitude
FROM business
WHERE (longitude BETWEEN 77.2090 - radius AND 77.2090 + radius)
AND (latitude BETWEEN 28.6139 - radius AND 28.6139 + radius)

-- radius is a numeric value (5 KM)
```

This approach needs two indices on `longitude` and `latitude` columns to be efficient, but still it will be very slow because of the _intersection_ of the two datasets that SQL will perform.

2. **Fixed Sized Grid**: grid cell will be too large, some will not have businesses at all (Antarctica) and some will have very high density of them (New Delhi). Nearby finding is not at all optimal here.

3. **Geohash**: divide world map into 4 qudrant grid and assign 2-bit binary numbers to them i.e. `00` `01` `11` `10`. Recursively divide the grid and keep building the hash string. A string of length 6 is enough for a resolution distance of 500m, and 5 for 1km.
```txt
1001 10110 01001 10000 11011 11010 - Google HQ's Geohash
9q9hvu (base32) - Representation
```

Boundary issues:
- two locations may've almost identical and long shared prefix but they may fall under a diff grid cell (so we can't just return locations from current grid cell)
- two locations can be neighbours but may've completely unidentical hashes, not even shared prefix (if they fall in adjacent grid cell on diff hemispheres) (corner case to handle)

Increasing search radius is good in this approach as we can just keep removing the last digit of a Geohash to increase radius.

4. **Quadtree**: fast and small in-memory tree, built at kept for reference on server startup

Building: each node holds the number of businesses around a centerpoint, start at root (millions of businesses) and recursively divide node into 4 nodes (based on `NE`, `NW`, `SW`, `SE` regions around the centerpoint) and create nodes until no nodes are left with > 100 businesses i.e. all leaf nodes will have <= 100 businesses on them.

Searching: start at node, traverse until we find leaf node where search origin (query) lies. If it has 100 businesses, return the node otherwise add businesses from its neighbours until 100 are returned.

How to identify search query lies in which node? Store top-left and bottom-right coordinates on each node inside the node.

Order - few minutes to build the tree and few GB to store it for 200 million businesses.

Updation: as we've multiple replicas of quadtree servers, when a new business is added or removed propagate the change incrementally to a subset of replicas at a time.

5. **Google S2**: in-memory store based on Hilbert Curve. It maps a sphere to a 1D index. Any two points that are closer to each other will be close on the 1D space too. This approach doesn't divide space into quadrants but covering arbitrary areas are possible (Geofencing using Region Cover Algorithms).

### Storage
Two levels of storage: 
- Redis cache servers on LBS for faster reads 
- SQL database servers for heavy write volume and bulk storage

```txt
LBS uses - Geohash, Business Info (both are Redis)
Business Service uses - Business DB (Postgres) + replicas
```

Business updates are handled via a nightly job, which syncs the SQL database with the two Redis stores across all LBS replicas.

Sharding isn't recommended since Geohash and Quadtree doesn't take up that much space. We have replicas of LBS servers across all available regions. 

We can shard Business DB's tables on `business_id` as they can become quite large in size.

### Data Model
Business DB relations and schema:
```txt
Table = geospatial_index
Column = geohash
Column = business_id

Table = business_metadata
Column = business_id (PK)
other business related info...
```

For `geospatial_index` relation, the schema options are:
1. Geohash as PK: store list of all businesses in that hash as a JSON list. Slow to update (locking required to prevent concurrent updates to the row) but easy to read.
2. `business_id` as PK: multiple businesses will have the same Geohash. Slow to read (all rows must be read) but easy to write (either insert or delete, no locking required).

Since reads from the SQL database aren't first priority and writes have the leisure to be slow (nightly job), its recommended to use the second approach as its much simpler.

Redis **Cache** servers and KV pairs on them:
- Geohash: `(geohash, list_of_businesses)`
- Business Info: `(business_id, business_info_object)`

Update to these two caches will be nightly, from the SQL Business DB.
