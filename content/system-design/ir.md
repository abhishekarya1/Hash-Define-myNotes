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