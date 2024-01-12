+++
title = "IR"
date = 2024-01-04T18:00:00+05:30
weight = 5
+++

## Email Service like Gmail
```txt
register a user 					- Auth service
login (2-factor auth) 				- SMS sevice
create profile 						- Profile service
set preferences (with attachments)	- Preference store (save prefs as JSON blob)
searching emails					- Search engine, ElasticSearch or Postgres Full-Text search on Email store
tagging emails						- Tag store
spam and virus detection			- Spam detection service, Drive service to store files after scan
contacts and group email			- use Contact manager to store on sending to a new email 
send/receive emails 				- Email service: sends to SMTP server, receives in IMAP server
```

Distributed Gateway, Authentication Service, and Service Registry share a common Global Cache that can store current `user_token` as well as Service-Name to URL mappings (SR).

Often in microservices, Spring Cloud Gateway is a Eureka Client too so it knows service to URL mapppings.

On email sent/receive, store email in email store (store metadata separately as inbox front page only shows that, not the mail content) and put an event in the Email Event Queue (MQ) where it can be picked up by Search Engine, Preference Store, and Spam Detector.

The architecture works perfectly fine for receiving emails too because of the MQ decoupling describe above, MQ also prevents causing a fanout. 

## Live Streaming Sports like Hotstar
Store raw data from live video camera feed (8k source) in a DFS (like Amazon S3) using Upload Service (as backup) and send video data and task events (in_MQ) to the Transformation Service which delegates work to Workers.

Transformation into diff video resolution and codecs for each chunk is performed then.

To transfer video at server side, we can use RTMP Protocol (Real-Time Messaging Protocol) used by Facebook Live, YouTube Live, etc. and its based on TCP, we don't want to lose packets here (as with UDP) since video quality ruin can get amplified on the user side.

```txt
Video Ingestion: Camera -> Store Raw Files (Upload Service) and send video data to Transformation Service -> new video task event in_MQ ->

Processing: Job Scheduler + Workers (n) -> Store output in Filesystem (S3) and send task complete event to out_MQ -> Aggregator Server (subscriber) (CDN origin)

Delivery: Streaming Servers (usually CDN Edge servers) read from FS (S3) -> User Devices
```

On server-side we used TCP based RTMP Protocol (old and reliable), and to deliver video from edge servers to client devices we can use DASH or HLS (newer and faster). We can use WebRTC (UDP) at this stage too, but it can cause stream delays in case client faces packet loss.

Cache regional streaming server address (`india.mumbai.01a`) on client device rather than finding nearest servers (using LB) everytime we open the stream. Also we can cache video chunks on streaming servers as well as on user devices.

Transformation service can use something like [ffmpeg](https://ffmpeg.org/) utility to transform video files.

[System Diagram](https://medium.com/@interviewready/designing-a-live-video-streaming-system-like-espn-14c8b3ff16c3#Architecture-Diagram) 

## Real-time Turn-based Game like Chess.com
```txt
Matchmaking Service
Game Engine
Analytics Engine
```

**Matchmaking Service**: initiator user sends game preferences JSON, use in-memory cache with TTL, persist to DB if match begins, otherwise evict

**Game Engine**: enforce rules so that clients don't modify app and cheat. Connect clients to reverse proxy (RP) and RPs connect to Game Engines. For every move we need to validate it. We don't even trust the timestamp that the client is sending to us and we try to approx actual TS based on the avg ping of the user.

This is why its not a good idea to connect client-to-client (P2P) over WebRTC because client can cheat if there is no rule validation.

**Analytics Engine**: stream to this component from GEs via MQs to analyze session data and store stats after match

After matchmaking request is success. Alice connects to RP (RP-India), and first move request is sent to Game Engine (India), but GE-India doesn't know where is Bob (who is connected to RP-Canada). So GE-India asks RP-India where is Bob connected, and since RP have a shared storage (Gateway DB cache) for all connected clients to the worldwide RPs, we can send data to Bob from GE-India -> RP-Canada -> Bob.

Bob doesn't make a direct connection to GE-India server but RP does it for him. This doesn't help latency ofcourse since requests have to be routed to GE-India anyways.

Active game's state is saved to sharded distributed caches (shard by even and odd `match_id`) modified by the Game Engine. Cache KV pairs - `match(match_id, match_state_object)`. Consistent Hashing isn't suitable here since reassignment can cause illegal moves to happen, we want sticky connections here which may lead to downtime if new cache shards are added.

How to update Game Engine avoiding **Thundering Herd Problem** of connections flooding in as soon as clients have updaed their app versions? Add a `Connections Service` between RPs and GEs so RPs never break connection even if RP to GE connection is down (i.e. when GE is down).

