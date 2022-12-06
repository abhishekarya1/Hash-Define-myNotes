+++
title = "Reactive"
date = 2022-12-06T12:56:00+05:30
weight = 14
+++

**Declarative** way of programming, deals with **data streams** and **propagation of change**.

Not neccessarily async, but its a core feature.

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

### Reactive way
- cleaner syntax
- declarative
- resuable patterns
- extremely faster

Since Java 9 we have a **Flow API** that standardizes the operations on reactive libraries, just like JPA for persistance tools.

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

## Reactive Sources and Methods
Reactive sources/streams:
- `Flux`: can emit `0` to `n` elements (_i.e._ sequence of elements)
- `Mono`: can emit `0` or `1` elements (_i.e._ single element)

### Create reactive streams
```java
// Flux
Flux<String> fStr = Flux.just("A", "B", "C");
Flux<Integer> fNnum = Flux.range(1, 10);

// Mono
Mono<Integer> mono = Mono.just(9);

Flux<Integer> fNnum = Flux.range(1, 10).delayElements(Duration.ofSeconds(1));	// delay of 1 sec between emission of each element

// unresponsive stream: never emit, observer keeps waiting infinitely
Flux.never();
Mono.never();
```

```java
// we can have Collections inside Rx streams, nesting is possible too, etc...
Mono<Integer>
Mono<User>		// custom POJO
Mono<List<Integer>>
Mono<Mono<Integer>>
```

### What is emitted?
```txt
item 					mono terminates, flux doesn't
complete event			mono terminates, flux too
failure event			mono terminates, flux too
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


flux.toStream().toList();	// converting a reactive source to stream to a list
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
.flatMap()	// same as in streams; the target element is a reactive stream
.count()	// returns Mono<Long>; subscribe to it inorder to take out the element
.take(n)	// similar to limit(), sends a cancel() to stream to indicate a stop 
.log()		// logs every step of observer
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

## Project Reactor and Spring Boot
In web apps, [Netty](https://netty.io/) controls the reactive aspects, we just use Flux or Mono everywhere in the app code and perform operations on them only.

Use `Spring Reactive Web` dependency in Spring Initializr to use reactive features in Spring Boot.
```java
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```