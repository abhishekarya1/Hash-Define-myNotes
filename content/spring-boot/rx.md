+++
title = "Reactive"
date = 2022-12-06T12:56:00+05:30
weight = 15
+++

**Declarative** way of programming modern services, deals with **data streams** and **propagation of change** (_event-driven_).

Not neccessarily async, but its a core feature; reacting to a change doesn't require async nature of processing, but the way modern reactive system acheive performance is using async processing.

Outline of reactive systems is in [_Reactive Manifesto_](https://www.reactivemanifesto.org/).

Modern languages use Reactive Data Streams which are async and are specified [_here_](https://www.reactive-streams.org/). 

## Async
### with Concurrency API
We can always use `Future` or `CompletableFuture` to make existing methods async, but it makes code long and redundant.

Moreover, it will lead to blocking anyways if we perform a `.join()` to combine output of two futures.

```java
CompletableFuture<String> one = CompletableFuture.supplyAsync(() -> foo());		// make foo() async
CompletableFuture<String> two = CompletableFuture.supplyAsync(() -> bar());		// make bar() async

CompletableFuture<Void> combined = CompletableFuture.allOf(one, two);			// combine the two
combined.join();	//  wait (block) till the results from both arrive

String a = one.join();	// get value
String b = two.join();	// get value

// join() is just like a get() method; used to get value out from streams/futures 
```

### with Reactive Data Streams
- declarative (cleaner syntax)
- resuable patterns
- async data streams (faster response times), uses threads internally
- highly scalable
- backpressure to slow down publisher

Since Java 9 we have a **Flow API** (`java.util.concurrent.Flow`) that standardizes the operations on reactive libraries, just like JPA for persistance tools.

## Iterator vs Observer
Similar design patterns, but the only difference is who controls the data flow.

![diagram](https://i.imgur.com/fyNHj3X.png)

In **iterator**, the calling method "pulls" the data from the source collection.
```java
stream.forEach(System.out::println);	// forEach pulls data from stream
```

In **observer**, we delegate and observer to observe data source change and "react" to it. The data source is the one "pushing" (controlling) the data.
```java
stream.myObserver(System.out::println);	// myObserver merely reacts to the changes in stream
```

{{% notice note %}}
Notice that the way we write both is exactly the same, but they are opposite w.r.t the side that control the data flow.
{{% /notice %}}


## Interfaces and How it Works?

**Publisher** - a reactive datasource; its `subscribe()` method is called passing it a subscriber

**Subscriber** - `onSubscribe()`, `onNext()`, `onError()`, `onComplete()`

**Subscription** - `request(long n)` and `cancel()` 

**Processor** - implements both Publisher and Subscriber; can act as both

```java
providerObj.subscribe(new Subscriber(){
	
	void onSubscribe(Subscription s){
		s.request(3);
	}

	// other methods - onNext(), onComplete(), etc
}
);
```

![pub_sub_method_calls](https://i.imgur.com/aTOLx8q.png)

{{% notice info %}}
As shown above, we need to subscribe to the data source first (_**explicit**_) and request `n` items (_**implicit**_), only then does it sends us the data (_emits_) and the Observer pattern comes into play and we consume the data until a terminal signal (_Error_ or _Complete_) is received.
{{% /notice %}}

## Reactive Sources and Methods
Reactive sources/streams:
- `Flux`: can emit `0` to `n` elements (_i.e._ sequence of elements)
- `Mono`: can emit `0` or `1` elements (_i.e._ single element)

### Creating Reactive Sources
```java
// Flux
Flux<String> fStr = Flux.just("A", "B", "C");
Flux<Integer> fNum = Flux.range(1, 10);

// Mono
Mono<Integer> mono = Mono.just(9);

// delay of 1 sec between emission of each element
Flux<Integer> fNum = Flux.range(1, 10).delayElements(Duration.ofSeconds(1));	

// unresponsive stream: never emit, observer keeps waiting infinitely
Flux.never();
Mono.never();
```

```java
// we can have Collections inside Rx streams, nesting is possible too, etc...
Mono<Integer>
Mono<User>				// custom POJO
Mono<List<Integer>>
Mono<Mono<Integer>>
```

### What is emitted?
```txt
item 					mono terminates, flux doesn't			onNext()
complete event			mono terminates, flux too 				onComplete()
failure event			mono terminates, flux too 				onError()
```

### Operations
We can perform operations on reactive streams - same as streams, we have **intermediate** and **terminal operations**.
```java
// Terminal operations
flux.subscribe(System.out::println);	// equivalent to .forEach()
flux.subscribe(System.out::println,
				err -> System.out.println("Error occurred: " + err.getMessage()),	// if error happens; do this
				() -> System.out.println("Finished.")								// on complete event, do this
);


// converting a reactive source to stream to a list
flux.toStream().toList();	
// it is blocking since we will wait for all the elements from the stream to emit and then form the stream; so it's bad!


Integer i = mono.block();			// subscribe and block indefinitely until element is received; upon receive, return it
mono.block(Duration.ofSeconds(5));	// if element doesn't come in 5s, we throw error; even on complete and failure
mono.blockOptional();				// returns emitted value (if any)
```

```java
// Intermediate operations
.filter()
.distinct()
.map()
.flatMap()				// same as in streams; the target element is a reactive stream
.count()				// returns Mono<Long>; subscribe to it inorder to take out the element
.take(n)				// similar to limit(), sends a cancel() to stream to indicate a stop 
.log()					// logs every implicit method call
.defaultIfEmpty(-1)		// outputs a flux containing -1 if input stream is empty (no elements and we recieve a complete)
```

```java
// Error handling
// remember, one way is to use second param of the subscribe() to handle errors
.doOnError(Consumer)			// do something on error; and then stop and throw error
.onErrorContinue(err, item)		// continue from next element after doing this
.doFinally(Consumer)			// only accepts SignalType as input, no elements, only complete and failure events
```

### Convert Flux to Mono
Several operations like `count()` on a flux return a mono. We then in turn perform operations on that mono.

### Backpressure
We can tell the data source to slow down in case we are taking too long to process data it emits.

## Project Reactor and Spring Boot
In web apps, [Netty](https://netty.io/) server controls the reactive aspects, we just use Flux or Mono everywhere in the app code and perform operations only on them.

Use `Spring Reactive Web` dependency in Spring Initializr to use reactive features in Spring Boot. It also adds Project Reactor dependency too by default.
```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```

### Reactive Data Sources
For Reactive data sources, we can use any conventional database provider (H2, Postgres, etc) but instead of JPA we use [R2DBC](https://r2dbc.io/) (Reactive Relational Database Connectivity). 

Do note that R2DBC doesn't support entity relationships (_@OnetoOne_, etc) as of yet, so it isn't a full replacement for JPA.

The JPA and Driver dependency for the database provider will be slightly different than the normal ones:
```xml
<!-- for ReactiveCrudRepository<> -->
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-data-r2dbc</artifactId>
</dependency>

<!-- normal Postgres driver -->
<dependency>
	<groupId>org.postgresql</groupId>
	<artifactId>postgresql</artifactId>
	<scope>runtime</scope>
</dependency>

<!-- added automatically with Postgres driver once Spring Initializr detects r2dbc JPA and Postgres dependencies -->
<dependency>
	<groupId>org.postgresql</groupId>
	<artifactId>r2dbc-postgresql</artifactId>
	<scope>runtime</scope>
</dependency>
```

```java
// repo
public interface ProductRepository extends ReactiveCrudRepository<Product, Long>{	}

// controller
@GetMapping("/all")
public Flux<Product> listAllProducts(){
	return productRepo.findAll();
}
```

_Reference_: Spring Reactive CRUD Project - [YouTube](https://www.youtube.com/watch?v=x1Dt7K4FrnI)

## WebClient vs RestTemplate
Now deprecated, `RestTemplate` followed a thread-per-request model, serverely limiting as well as it was blocking the flow until result of the external service call was available.

Spring WebFlux introduces a non-blocking way using `WebClient`. It returns a Publisher which the client (browser) subscribes to, without blocking the code flow. As and when the data is available from the "slowservice", the client receives it async-ly.

```java
// create client instance
WebClient client = WebClient.builder().baseUrl("localhost:8081/slowservice").build();

// call service
Flux<Tweet> tweets = client.get().retrieve().bodyToFlux(Tweet.class);

// subscribe to service output
tweets.subscribe(System.out::println);

// method exits asap without blocking
log.info("Exiting NON-BLOCKING Controller ASAP!");

// results are received and printed later
```

[Reference](https://www.baeldung.com/spring-webclient-resttemplate#webclient-example)