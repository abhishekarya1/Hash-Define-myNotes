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
- **Partition** - indexed log (array) and hence ordering is guaranteed among messages received by a particular partition; replicated for data redundancy

- **Publisher** - writes messages to topics
- **Consumer** and **Consumer Group** - read messages from topics by taking ownership of specified partitions

- **Zookeeper** - central manager: stores cluster metadata, clients information, routes writes exclusively to leader broker and reads to both leader and follower brokers

![kafka components](https://i.imgur.com/BtLuPCj.png)

![topic and partitions](https://i.imgur.com/NX0GAP3.png)

## Features
**Replication**: it exists at every level. Cluster, Broker, Partitions are configured to be data replicated and fail-overs in place in a well configured Kafka system.

**Messages** are just bytes of information to Kafka and its agnostic to their meaning. There is a component **Key** (numeric hash) that can be appended to a message which can then be used to decide the partition the message goes to using modulo operation i.e. `key_hash % N` where `N` is the number of partitions in the topic the message is destined to. The producer tries to uniformly distribute messages among all partitions.

**Schema** is another optional metadata put in the message sometimes. It indicates what kind of data the message contains (i.e. JSON or XML etc) to the consumer. This schema can be stored as Kafka Headers or we can dedicate specific topics for specific message types.

**Offset**: each consumer tracks messages already processed by it using an integral number called _offset_ and it maintain its current count so that it can resume from that point in the future if processing fails. 

**Retention**: there is a temp storage threshold (1GB per partition) or message TTL (7 days) after which they are deleted.

## Both Models
Kafka can do both prod/con (_default_) as well as pub/sub model using consumer groups.

### Consumer Group
Each partition must be consumed by **only a single consumer in one group** but the inverse isn't true! One consumer is free to consume from multiple partitions.

When we put consumers in separate groups, we are able to consume a Partition from multiple consumers (one-to-many mapping). And when we put all consumers in a single group each Partition can only be consumed from a single consumer (one-to-one mapping). 

- act as a queue; put all consumers in one group (_default_) (shown in below image)
- act as a pub/sub; put one consumer in one group

![consumer group](https://i.imgur.com/YogLz0Q.png)


### Message Queue vs Kafka
Messages are deleted from MQ by MQ system after they are consumed in a prod-con model. The message deletion can be turned off in most MQ platforms but the general idea of MQ is remove-on-consume.

This is not the case in Kafka. Notice that Kafka broker itself is ignorant about _offsets_. A separate numeric offset is maintained by each consumer based on which message they are reading. The messages themselves are not deleted from the partition when they are consumed and successfully finish processing. They are deleted after a retention period has passed or disk quota limit is reached, so Kafka acts as a **"Distributed Commit Log"** or more recently as a "Distributing Streaming Platform".

## Zookeeper
We can run multiple brokers having exact same topic in a leader-follower hierarchy.

Zookeper is the manager as it stores cluster metadata and clients information. It runs on a separate server and has fail-overs.

Zookeeper takes care of routing for read-write operations:
- write to leader; change is propagated to all followers
- read from a follower

![zookeeper distributed](https://i.imgur.com/PWMZzwh.png)

Since Kafka 2.8.0, we don't need a Zookeeper and a concensus algorithm (RAFT) is used.

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
// create a topic
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

kafkaTemplate.send(topicName, msg);
```
**Consumer**:
```java
// consumer
@KafkaListener(topics = "foobar", groupId = "fooGroup")
public getMessage(String msg){
	// processing
}
```

## Interview Questions
**ISR** (In-Sync Replicas): they are replicas which are up-to-date with leader's data.

**Consumer Lag**: the diff between the latest offset of the partition and the latest offset which the consumer has consumed.

**Offset Updates**: offset is updated and committed only after successful processing of the message by the consumer, otherwise it will lead to message loss if consumer fails (or goes down) and we already update the offset.

## References
- Apache Kafka Crash Course - Hussein Nasser - [YouTube](https://youtu.be/R873BlNVUB4)
- Spring Boot: Event Driven Architecture using Kafka - Programming Techie - [YouTube](https://youtu.be/-ebTPcHANnI)
- Spring Boot + Apache Kafka Tutorial - Java Guides - [YouTube](https://youtube.com/playlist?list=PLGRDMO4rOGcNLwoack4ZiTyewUcF6y6BU)
- https://learning.oreilly.com/library/view/kafka-the-definitive/9781492043072/