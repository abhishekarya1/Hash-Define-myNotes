+++
title = "Kafka"
date =  2022-11-09T14:43:00+05:30
weight = 2
pre = "<i class='devicon-apachekafka-plain'></i> "
+++

## Components
- cluster
- broker
- topic
- partitions (indexed) (multiple partitions is possible)

- publisher
- consumer, consumer groups

- zookeeper

![kafka components](https://i.imgur.com/BtLuPCj.png)

## Both Models
Kafka can do both prod/con as well as pub/sub model using consumer groups.

### Consumer Group
Each partition must be consumed by only a single consumer in one group but the inverse isn't true! One consumer is free to consume from multiple partitions.

So, when we put consumers in separate groups, we are able to consume a Partition from multiple consumers.
- act as a pub/sub; put one consumer in one group
- act as a queue; put all consumers in one group (_default_)

![consumer group](https://i.imgur.com/YogLz0Q.png)

### Distributed
We can run multiple brokers having exact same topic in a leader-follower hierarchy.

Zookeeper takes care of routing for read-write operations:
- write to leader; change is propagated to all followers
- read from a follower

![zookeeper distributed](https://i.imgur.com/PWMZzwh.png)

## Advantages
- distributed
- super fast
- both prod-con and pub-sub supported
- huge data volume

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