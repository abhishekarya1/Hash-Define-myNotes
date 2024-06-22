+++
title = "Concepts"
date =  2022-11-09T14:41:00+05:30
weight = 1
pre = "<i class='fas fa-pen' style='color: white'></i> "
+++

## The Need
REST APIs are synchronous and follow a client-server model (point-to-point).

**Async API**: put message in a third party (queue) and move on ("fire and forget")

- _deferred processing_: place message in queue and process it later
- _fault-tolerance_: even if a service goes down we still have previously sent messages in MQ
- _decoupling_: services aren't time bound w.r.t each other
- _load balancing_: delegate load to multiple consumers
- _data-streaming_: large volumes of data exchange between services

Not only data messages, but tasks messages can be put in queues too.

**Event-driven Architecture**: put a task in the queue, send it to services and trigger processing in them 

**Streaming Data Pipelines**: huge volume of data (\~100K requests/sec) can be sent between services

### Prod-Con Model (MQ)
Simple MQ - single FIFO pipeline. Ex - IBM WebSphere MQ, Rabbit MQ, Apache Active MQ, etc.

Messages in MQs can be _ordered_ (FIFO order) or _unordered_ (high priority ones are processed first).

- _one-to-one_; one producer, one consumer
- message is _deleted_ from MQ by MQ system after consumption, they can also configured to be deleted on consumer-ack (RabbitMQ has this config)

**Disadvantages**:
- low latency but slower than Kafka
- throughput is not as high as Kafka

### Pub-Sub Model (Kafka)
Publisher puts messages in a central system, subscriber(s) consume them. Broadcasting. Acts as a Distributed Commit Log.

- _one-to-many_; one producer, many consumers
- message is _not deleted_ from Topic after consumption by consumers (see [Kafka notes](/data/broker/kafka/))
- _unordered_ mostly
- _scalability_: add multiple consumers to consume messages faster 

**Disadvantages**:
- not for mission critical synchronous systems where ack is required
- not for non-idempotent tasks like financial transactions

## References
- https://www.gentlydownthe.stream/
- Prod/Con - sudoCODE - [YouTube](https://youtu.be/J6CBdSCB_fY)
- Pub/Sub - sudoCODE - [YouTube](https://youtu.be/EgJ7xts82Mg)
- Message Queues - Gaurav Sen - [YouTube](https://youtu.be/oUJbuFMyBDk)
- Pub/Sub - Gaurav Sen - [YouTube](https://youtu.be/FMhbR_kQeHw)