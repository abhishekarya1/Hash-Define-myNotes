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