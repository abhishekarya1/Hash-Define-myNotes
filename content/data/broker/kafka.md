+++
title = "Kafka"
date =  2022-11-09T14:43:00+05:30
weight = 2
pre = "<i class='devicon-apachekafka-plain'></i> "
+++

## Intro
Apache Kafka is a distributed event streaming platform used to handle large amounts of realtime data.

- extremely **high throughput** but **low on storage** (hence not a replacement of a DB)
- highly **distributed** and therefore extremely **fault-tolerant**

It is used in applications as an async intermediary (events), and for streaming large volumes of data (e.g. analytics).

It is built in Java and Scala so its native to Java environment.

**Usage**: async messaging between services, metrics and logging, commit log (Saga pattern), stream processing (taking action on a series of data in realtime).

## Components
- **Cluster** - group of kafka servers
- **Broker** - a single kafka server (replicated for high-availability)
- **Topic** (aka _Stream_) - logical category; group of partitions, can be spread across multiple brokers; no ordering of incoming messages guaranteed
- **Partition** - indexed log (array) and hence ordering is guaranteed among messages received by a particular partition; data is replicated for redundancy
- **Publisher** - writes messages to topics
- **Consumer** and **Consumer Group** - read messages from topics by taking ownership of specified partitions
- **Zookeeper** - management component; stores cluster metadata, clients information, routes writes exclusively to leader broker and reads to both leader and follower brokers

![kafka components](https://i.imgur.com/BtLuPCj.png)

![topic and partitions](https://i.imgur.com/T9NJwAp.png)

## Features
**Replication**: it exists at every level. Cluster, Broker, Partitions are configured to be data replicated and have fail-overs in place in a well configured Kafka system.

**Assigning Partitions to Consumers**: a consumer is assigned a partition to read from by Kafka. It makes sure all consumers are evenly balanced across partitions. If we want, we can control this assignment directing messages to specific paritions based on the Message Key (see below).

**Messages** are just bytes of information to Kafka and its agnostic to their meaning. There is a component **Key** (numeric hash) that can be appended to a message which can then be used to manually decide the partition the message goes to using modulo operation i.e. `key_hash % N` where `N` is the number of partitions in the topic the message is destined to. The producer tries to uniformly distribute messages among all partitions.

**Schema** is another optional metadata put in the message sometimes. It indicates what kind of data the message contains (i.e. JSON or XML etc) to the consumer. This schema can be stored as Kafka Headers or we can dedicate specific topics for specific message types.

**Offset**: each consumer tracks messages already processed by it using an integral number called _offset_ and it maintain its current count so that it can resume from that point in the future if processing fails. 

**Retention**: there is a temp storage threshold (1GB per partition) or message TTL (7 days) after which they are deleted.

## Both Models
Kafka can do both prod/con (MQ) as well as pub/sub model using consumer groups.

### Consumer Group
Each partition must be consumed by **only a single consumer in one group** but the inverse isn't true! One consumer is free to consume from multiple partitions.

When we put consumers in separate groups, we are able to consume a Partition from multiple consumers (one-to-many mapping). And when we put all consumers in a single group each Partition can only be consumed from a single consumer (one-to-one mapping). 

- a partition acts as a FIFO queue - put all consumers in one group; direct messages to specific partitions based on their key
- a partition acts as a pub/sub - put one consumer in one group; let Kafka populate partitions of a topic

![consumer group](https://i.imgur.com/HXoGjTe.png)

**Avoiding Redundant Message Processing**: a single message in a partition will be consumed multiple times if its consumers happen to be from diff groups, Kafka has no awareness to prevent it as its just a storage. Hence we need to make sure that we designate groups to consumers in a way that doesn't lead to redundant processing.

**Rebalancing**: Kafka ensures that partitions are evenly distributed among consumers in a group. If a consumer joins or leaves the group, Kafka will rebalance the partitions among the available consumers within the same group.

_Reference_: [Kafka Partitions and Consumer Groups - Medium](https://medium.com/javarevisited/kafka-partitions-and-consumer-groups-in-6-mins-9e0e336c6c00)

### Message Queues vs Kafka
Messages are deleted from MQ by MQ system after they are consumed in a prod-con model. The message deletion can be turned off in most MQ platforms but the general idea of MQ is remove-on-consume.

This is not the case in Kafka. Notice that Kafka broker itself is ignorant about _offsets_. A separate numeric offset is maintained by each consumer based on which message they are reading. The messages themselves are not deleted from the partition when they are consumed and successfully finish processing. They are deleted after a retention period has passed or disk quota limit is reached, so Kafka acts as a **"Distributed Commit Log"** or more recently as a "Distributing Streaming Platform".

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
Spring Boot automatically adds `@EnableKafka` when we add `@SpringBootApplication` annotation. So, we needn't add it explicitly.
```txt
configs in properties file:

kafka broker server ip
consumer group (in consumer only)
key-value serializer/deserializer

If we send String to Kafka, we specify "String" serializer/deserializer here
If we send POJO to Kafka, we specify "JSON" serializer/deserializer here
```
**Create a Topic**:
```java
// create a topic (optional ofcourse)
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
_Why do we need retry topics? Didn't we only commit offset when a message is successfully consumed by the consumer? If we don't update the offset then we will process the failed message again right?_ That is true, but we have retry topics to ensure **exactly once semantics** otherwise consumer doesn't have any idea how many retries it has already done and it will go in an infinite loop. So the consumer does retries once from every retry topic created. Kind of verbose 😅.
{{% /notice %}}

## Interview Questions
**ISR** (In-Sync Replicas): they are replicas which are up-to-date with leader's data.

**Consumer Lag**: the diff between the latest offset of the partition and the latest offset which the consumer has consumed.

**Offset Updates**: offset is updated and committed only after successful processing of the message by the consumer, otherwise it will lead to message loss if consumer fails (or goes down) and we already update the offset.

## References
- Apache Kafka Crash Course - Hussein Nasser - [YouTube](https://youtu.be/R873BlNVUB4)
- Spring Boot: Event Driven Architecture using Kafka - Programming Techie - [YouTube](https://youtu.be/-ebTPcHANnI)
- Spring Boot 3 Apache Kafka Tutorial - Java Techie - [YouTube](https://youtu.be/c7LPlWvxZcQ)
- https://learning.oreilly.com/library/view/kafka-the-definitive/9781492043072/