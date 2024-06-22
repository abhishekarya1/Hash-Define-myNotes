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
- **Topic** (aka _Stream_) - group of partitions, can be spread across multiple brokers; no ordering of incoming messages guaranteed
- **Partition** - indexed log (array) and hence ordering is guaranteed among messages received by a particular partition; replicated for data redundancy

- **Publisher** - writes messages to topics
- **Consumer** and **Consumer Group** - read messages from topics by taking ownership of specified partitions

- **Zookeeper** - central manager: stores cluster metadata, clients information, routes writes exclusively to leader broker and reads to both leader and follower brokers

![kafka components](https://i.imgur.com/BtLuPCj.png)

## Features
**Replication**: it exists at every level. Cluster, Broker, Partitions are configured to be data replicated in a well configured kafka system.

**Messages** are just bytes of information to Kafka and its agnostic to their meaning. There is a component **Key** (numeric hash) that can be appended to a message which can then be used to decide the partition the message goes to using modulo operation i.e. `key_hash % N` where `N` is the number of partitions in the topic the message is destined to.

There is another metadata often part of the message that is **Schema**. It indicates what kind of data the message contains i.e. JSON or XML etc to the consumer. This schema can be stored as Kafka Headers or we can decide specific topics for specific message types.

**Offset**: the consumer tracks messages already processed using an integral number called _offset_ and it maintain its current count so that it can resume from that point in the future. The producer tries to uniformly distribute messages among all partitions.

**Retention**: there is a temp storage threshold (1GB per partition) or message TTL (7 days) after which they are deleted.

## Both Models
Kafka can do both prod/con (_default_) as well as pub/sub model using consumer groups.

### Consumer Group
Each partition must be consumed by only a single consumer in one group but the inverse isn't true! One consumer is free to consume from multiple partitions.

This is because a partition is ordered and we don't want multiple consumers to take messages from it and cause chaos.

When we put consumers in separate groups, we are able to consume a Partition from multiple consumers.
- act as a queue; put all consumers in one group (_default_)
- act as a pub/sub; put one consumer in one group

![consumer group](https://i.imgur.com/YogLz0Q.png)

### Distributed
We can run multiple brokers having exact same topic in a leader-follower hierarchy.

Zookeper is the manager as it stores cluster metadata and clients information. It runs on a separate server and has fail-overs.

Zookeeper takes care of routing for read-write operations:
- write to leader; change is propagated to all followers
- read from a follower

![zookeeper distributed](https://i.imgur.com/PWMZzwh.png)

---
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

## References
- Apache Kafka Crash Course - Hussein Nasser - [YouTube](https://youtu.be/R873BlNVUB4)
- Spring Boot: Event Driven Architecture using Kafka - Programming Techie - [YouTube](https://youtu.be/-ebTPcHANnI)
- Spring Boot + Apache Kafka Tutorial - Java Guides - [YouTube](https://youtube.com/playlist?list=PLGRDMO4rOGcNLwoack4ZiTyewUcF6y6BU)
- https://learning.oreilly.com/library/view/kafka-the-definitive/9781492043072/