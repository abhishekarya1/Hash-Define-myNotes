+++
title = "Kafka"
date =  2022-11-09T14:43:00+05:30
weight = 2
pre = "<i class='devicon-apachekafka-plain'></i> "
+++

## Intro
Apache Kafka is an open-source distributed event streaming platform used to handle large amounts of realtime data.

- extremely **high throughput** but **low on storage** (hence not a replacement of a DB)
- highly **distributed** and therefore extremely **fault-tolerant**

It is used in applications as an async intermediary (events), and for streaming large volumes of data (e.g. analytics).

It is built in Java and Scala so its native to Java environment.

**Usage**: async messaging between services (MQ), metrics and logging, commit log (Saga pattern), stream processing (taking action on a series of data in realtime).

## Components
- **Cluster** - group of kafka servers
- **Broker** - a single kafka server (replicated for high-availability)
- **Topic** (aka _Stream_) - logical entity; group of partitions, can be spread across multiple brokers; no ordered storage of messages is guaranteed on this abstraction level
- **Partition** - append-only indexed log (array); messages are appended at the end and hence ordering is guaranteed among messages received by a particular partition; data is replicated in a Leader-Follower hierarchy across mulitple brokers and producers and consumers often directly interact with the leader partition
- **Producer** - writes messages to topics
- **Consumer** and **Consumer Group** - reads and writes messages from topics by taking ownership of specified partitions
- **Controller** - a broker responsible for cluster-wide management, such as leader election, partition reassignment, detecting broker failures, and storing cluster metadata
- **Group Coordinator** - a broker responsible for managing a specific consumer group (membership, rebalancing, heartbeats, offsets)
- **Zookeeper** - manages Kafka cluster; stores metadata, clients information, routes writes exclusively to leader broker and reads to both leader and follower brokers, etc. (not needed if using Modern Kafka - KRaft mode)

Topics are just a way to organize your data, while partitions are a way to scale your data.

![kafka components](https://i.imgur.com/BtLuPCj.png)

![topic and partitions](https://i.imgur.com/T9NJwAp.png)

## Producing and Consuming

**Writing to a Topic** (producer): When a message is published to a Kafka topic, Kafka first determines the appropriate partition for the message and then broker where that partition lives (given by Kafka cluster metadata maintained by Kafka Controller broker). Kafka tries to uniformly distribute messages from a producer among all partitions of the destination topic using algorithms like round-robin, hash of a key, custom partitioner, or explicitly specifying a specific partition to send the message to. This is called **Partition Strategy**. 

**Reading from a Topic** (consumer): Kafka assigns partitions from a subscribed topic to consumers within the same consumer group. The group coordinator ensures that each partition is assigned to exactly one consumer in the group, aiming for a balanced distribution. Partition assignment strategies such as Range, RoundRobin, Sticky, and Cooperative Sticky determine how partitions are distributed. Assignments remain unchanged until a rebalance occurs (e.g. a consumer joins or leaves the group, or the topic's partition count changes).

Kafka consumers actively poll the broker for new messages at intervals they control i.e. pull-based model. This pull approach was a deliberate design choice that provides several advantages: it lets consumers control their consumption rate, simplifies failure handling, prevents overwhelming slow consumers, and enables efficient batching. A Kafka consumer's poll can return records from multiple partitions in a single call!

{{% notice tip %}}
Producers are not restricted to specific partitions by default - they can publish to any partition in a topic, either by explicitly specifying the partition or by letting the partitioner choose one dynamically. Consumers, however, can only read from the partitions assigned to them within their consumer group; they do not read from partitions assigned to other consumers in the same group.
{{% /notice %}}

Each partition in Kafka functions essentially as an append-only log file. Messages are sequentially added to the end of this log, which is why Kafka is commonly described as a _distributed commit log_. Provides immutability, efficiency, and scalability.

**Partitions' consumption**: if there is 1 producer, 1 consumer, and 1 topic with 3 partitions, and the consumer subscribes to the topic normally, the consumer will be assigned all 3 partitions and will receive every message regardless of which partition the producer writes to.

**No global ordering**: Kafka does not guarantee global ordering across multiple partitions; it only preserves strict message ordering within a single partition. Ex - if a producer writes two messages (`A` then `B`) to the same topic, Kafka guarantees that consumers will read them in order only if both messages are written to the same partition. If they are written to different partitions, Kafka provides no ordering guarantee between them, because the partitions are consumed independently and may be processed at different rates. Thus in this case, even if we've a single consumer it might see either `AB` or `BA` if they both goto and are read from different partitions.

## Features
**Replication**: done at every level. Cluster, Broker, Partitions are configured to be data replicated and have fail-overs in place in a well-configured Kafka cluster. 

Once a message is published to the designated partition, Kafka ensures its durability and availability through a robust replication mechanism. Leader-follower replication is done where each partition has a designated leader replica on a broker which handles all writes and reads (by default), several follower replicas exist for each partition, residing on different brokers (no direct client requests; passive replicas). They sync with leader and when the leader replica fails, the controller reassigns the leader role to one of the in-sync follower replicas to ensure continued availability of the partition, minimizing downtime and data loss.

**Messages** are just raw bytes of information to Kafka and its agnostic to their meaning. A message in Kafka has four components (all optional): a value/payload, a key, a timestamp, and headers (K-V pairs). The **Key** routes messages to partitions and if not specified Kafka uses a default round-robin strategy.

**Schema** is another optional metadata put in the message sometimes. It indicates what kind of data the message contains (i.e.String, JSON, or XML etc). This schema metadata can be stored in Kafka Headers or we can dedicate specific topics for specific message types.

**Offset**: each message in a Kafka partition is assigned a unique offset, which is a sequential identifier indicating the message's position in the partition. This offset is used by consumers to track their progress in reading messages from the topic. As consumers read messages, they maintain their current offset and **periodically commit this offset back to Kafka**. This way, they can resume reading from where they left off in case of failure or restart.

**Retention**: there is a temporary storage threshold (1 GB per partition) or message TTL (7 days) after which they are deleted.

## Both Consumption Modes
Kafka does pub/sub model as its just a log, but we can also do prod/con (MQ) using consumer groups.

**Summary**: 
- when used as a MQ, each message is processed by one consumer in a group and then effectively "consumed" (though Kafka still retains it based on retention policy). 
- when used as a Stream, consumers continuously process messages as they arrive in real-time, and the same data can be read by multiple independent consumer groups or replayed from any point in the log.

### Consumer Group
Each partition must be consumed by **only a single consumer in one group** but the inverse isn't true! One consumer is free to consume from multiple partitions.

When we put consumers in separate groups, we are able to consume a Partition from multiple consumers (one-to-many mapping). And when we put all consumers in a single group each Partition can only be consumed from a single consumer (one-to-one mapping).

- acts as prod/con (MQ) - put all consumers in one group; one partition only maps to one consumer then
- acts as pub/sub - put one consumer in one group; one partition can map to multiple consumers then

![consumer group](https://i.imgur.com/HXoGjTe.png)

Fig. Kafka Consumer Groups and Partitions (pub/sub)

We can also use a single partition as a directly-mapped FIFO queue! We can route a message to a specific partition based on Key, and then map a specific consumer to that partition manually (in the code for consumer config).

{{% notice note %}}
If we don't explicitly specify a consumer group for a Kafka consumer, the consumer acts as a standalone consumer (i.e. it doesn't join any group), and does not trigger group coordination (no rebalancing, etc). If multiple such consumers subscribe to the same topic, each will receive a copy of all the messages — consumer reads all partitions independently.
{{% /notice %}}

**Avoiding Redundant Message Processing**: a single message in a partition will be consumed multiple times if its consumers happen to be from diff groups, Kafka has no awareness to prevent it as its just a storage. Hence we need to make sure that we designate groups to consumers in a way that doesn't lead to redundant processing.

**Rebalancing**: Kafka ensures that partitions are evenly distributed among consumers in a group. If a consumer joins or leaves the group, Kafka will rebalance all the partitions among the available consumers within the same group.

_Reference_: [Kafka Partitions and Consumer Groups - Medium](https://medium.com/javarevisited/kafka-partitions-and-consumer-groups-in-6-mins-9e0e336c6c00)

### Message Queues vs Kafka
Messages are deleted from MQ by MQ system after they are consumed in a prod-con model. The message deletion can be turned off in most MQ platforms but the general idea of MQ is remove-on-consume.

This is not the case in Kafka. A separate numeric _offset_ is maintained by Kafka for each consumer per partition based on which message they are reading and its updated after a successful consumption of a message. The messages themselves are not deleted from the partition when they are consumed and successfully finish processing. They are deleted after a retention period has passed, disk quota limit is reached, or consumer has gone down (rebalancing), so Kafka acts as a **"Distributed Commit Log"** or more recently called a "Distributing Streaming Platform".

## Zookeeper
Zookeper is the coordinator and the manager, it stores the metadata too.

We can run multiple brokers having exact same topic in a leader-follower hierarchy. Zookeeper handles leader election and replica management.

It stores cluster metadata and clients information as well. It runs on a separate server and has fail-over instances running.

It also takes care of routing for read-write operations:
- redirect writes to leader; change is propagated to all followers
- redirect reads from a follower

![zookeeper distributed](https://i.imgur.com/PWMZzwh.png)

{{% notice tip %}}
Since Kafka 2.8.0, we don't necessarily need a Zookeeper and a concensus algorithm (RAFT) can be used, its called KRaft (Kafka RAFT).
{{% /notice %}}

## Spring Boot Kafka
Spring Boot automatically adds `@EnableKafka` when we add `@SpringBootApplication` annotation. So we needn't add it explicitly.

**Create a Topic**:
```java
// create a topic (optional ofcourse if topic already exists)
@Configuration
public class TopicConfig{

	@Bean
	public NewTopic createTopic(){
		return TopicBuilder.name("foobar")
						   .partitions(3)
						   .build();
	}
}
```
**Producer**:
```java
// producer
@Autowired
KafkaTemplate<String, String> kafkaTemplate;

kafkaTemplate.send(topicName, msg);		// this returns a CompletableFuture ref
```
**Consumer**:
```java
// consumer
@KafkaListener(topics = "foobar", groupId = "fooGroup")
public getMessage(String msg){
	// processing
}
```

### Properties Config and Message Schema
```txt
kafka broker server ip
consumer group (in consumer only)
key-value serializer/deserializer
	- if we send String messages to Kafka, we specify "String" serializer/deserializer in producer/consumer value
	- if we send JSON (or POJO) messages to Kafka, we specify "JSON" serializer/deserializer in producer/consumer value
	- producer/consumer key is always "String" serializer/deserializer
```

How does the consumer know what kind of data a message has? Since Kafka stores messages as just raw bytes, we need to provide serialization/deserialization **schema** info in headers of a message to indicate what kind of data the message has.

In Spring Boot, we can specify this in properties file as follows:

```sh
# Kafka bootstrap servers
spring.kafka.bootstrap-servers=localhost:9092

# Producer configuration (for JSON message)
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.springframework.kafka.support.serializer.JsonSerializer

# Consumer configuration (for JSON message)
spring.kafka.consumer.group-id=my-group
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.springframework.kafka.support.serializer.JsonDeserializer

# -------------------------------------------------------------------------------------------------------------

# Producer configuration (for String message)
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.apache.kafka.common.serialization.StringSerializer

# Consumer configuration (for String message)
spring.kafka.consumer.group-id=my-group
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.apache.kafka.common.serialization.StringDeserializer
```

### Error Handling
For handling errors that happen during the consumption of the messages, we can specify the number of retry attempts to perform before sending them over to the Dead Letter Topic (DLT).

Kafka creates `N-1` retry topics (`foobar-retry-0`, `foobar-retry-1`, etc.) and puts failed messages in them if retry is needed. Since default retry attempts are 3 therefore Kafka creates 2 retry topics for each of our main topic.

```java
@RetryableTopic(attempts = "4")
@KafkaListener(topics = "foobar")

// retry atmost 4 times (default is 3 if we don't have this annotation)

@DltHandler
// define a method here to process failed messages (fetched from Dead Letter Topic)
```

{{% notice note %}}
_Why do we need retry topics? Didn't we only commit offset when a message is successfully consumed by the consumer? If we don't update the offset then we will process the failed message again right?_ That is true, but we have retry topics to ensure **exactly-once semantics** otherwise consumer doesn't have any idea how many retries it has already done and it will go in an infinite loop. So the consumer does retries once from every retry topic created. Kind of verbose 😅.
{{% /notice %}}

The `send()` of `KafkaTemplate` is overloaded to specify partition and/or key along with message:
```java
send(String topic, Integer partition, K key, V data) 	// send the data to the provided topic with the provided key and partition
send(String topic, K key, V data)		// send the data to the provided topic with the provided key and no partition
send(String topic, V data)		// send the data to the provided topic with no key or partition
```

## Interview Questions
**ISR** (In-Sync Replicas): they are replicas which are up-to-date with leader's data.

**Consumer Lag**: the diff between the latest offset of the partition and the latest offset which the consumer has consumed.

**Offset Updates**: offset is updated and committed only after successful processing of the message by the consumer, otherwise it will lead to message loss if consumer fails (or goes down) and we already update the offset. This offset has to be commited explicitly by the Consumer to Kafka. Mostly it is set to auto-commit in the consumer app, but it is to be handled by the Consumer itself and not Kafka.

**ACK for Producers**: There is no ack for consumers. But Kafka sends an `ack` to producer to ensure message is written to Kafka!. This is because Kafka is designed to be pull-based so that messages can be consumed at a pace the consumer wants and an ack mechanism would make it sync defeating the purpose and making it slow and decreasing throughput.

## References
- Apache Kafka Crash Course - Hussein Nasser - [YouTube](https://youtu.be/R873BlNVUB4)
- Spring Boot: Event Driven Architecture using Kafka - Programming Techie - [YouTube](https://youtu.be/-ebTPcHANnI)
- Spring Boot 3 Apache Kafka Tutorial - Java Techie - [YouTube](https://youtu.be/c7LPlWvxZcQ)
- https://learning.oreilly.com/library/view/kafka-the-definitive/9781492043072/
- (2026) https://learning.oreilly.com/library/view/designing-data-intensive-applications/9781098119058/ch12.html (Chapter 12: Stream Processing)
- (2026) https://www.hellointerview.com/learn/system-design/deep-dives/kafka