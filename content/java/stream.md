+++
title = "Streams"
date =  2022-05-28T19:28:00+05:30
weight = 9
+++

## Optional
A container that can be empty or have a value. We can specify type `Optional<type>` for the container too.
```java
//empty box
Optional.empty()
//box with a value
Optional.of(5)

// Optional ref
Optional i = Optional.of(5);
// Optional ref with formal type parameter
Optional<Integer> i2 = Optional.of(6);

// checking
i.isPresent();
// accessing
i.get();
// without check if we access - NoSuchElementException

Optional o = Optional.ofNullable(foo);
// if foo is null, then o is assigned Optional.empty() otherwise Optional.valueOf(foo) is assigned
```

### Optional Instance Methods
```java
isPresent()				// boolean
get()					// returns value inside Optional

ifPresent(Consumer c)		// use lambda, calls it with value if present

orElse(T other)				// returns other parameter
orElseGet(Supplier s)		// returns result of calling Foobar

orElseThrow()			// throws NoSuchElementException
orElseThrow(Supplier s)	// throws exception created by calling Foobar			
```

**Examples**
```java
o.ifPresent(System.out::println);
o.ifPresent(x -> System.out.println(x));

o.orElseGet(() -> 99;
o.orElseGet(() -> Math.random());
o.orElseThrow(() -> new IllegalStateException());
```


## Streams
**Stream** is a sequence of data. **Stream pipeline** is a sequence of operations we perform on a `Stream`.

`Stream<T>` interface defined in the `java.util.stream` package.

1. **Source**: 
2. **Intermediate operations**: Each stage's output is a `Stream`, these don't run unless terminal operation runs
3. **Terminal operation**: Produces a result (single primitive or object) at last (_reduction_)

```java
// finite Stream
Stream.empty();
Stream.of(1, 2, 3);

coll.stream();
coll.parellelStream();

//infinite Stream
Stream.generate(Supplier);
Stream.iterate(seed, UnaryOperator);
Stream.iterate(seed, Predicate, UnaryOperator);		// maybe finite

// examples
Stream.generate(() -> 4);		// 44444...
Stream.iterate(2, n -> n+2);	// 2468...
Stream.iterate(1, n -> n < 50, n -> n+2);	// 1...50
```

## Common Terminal Operations
```java
long count()

Optional<T> min(Comparator)
Optional<T> max(Comparator)

Optional<T> findAny()		// terminates inf stream, usually returns first element on finite Stream
Optional<T> findFirst()		// terminates inf stream

boolean allMatch(Predicate)			// sometime terminates
boolean anyMatch(Predicate)			// sometime terminates
boolean noneMatch(Predicate)		// sometime terminates

void forEach(Consumer)

reduce()
collect()
```

**We can't loop on Stream the way we do on other Collections and arrays.**
```java
Stream<Integer> s = Stream.of(1, 2, 3);
for(Integer i : s){	}	// does not compile
```
### reduce() and collect()
```java
public T reduce(T identity, BinaryOperator<T> accumulator)		// 1, return type is same as that of seed
public Optional<T> reduce(BinaryOperator<T> accumulator)		// 2, no seed so return type is Optional
public <U> U reduce(U identity, BiFunction<U,? super T,U> accumulator, BinaryOperator<U> combiner)		// 3, when dealing with different data types

// identity is the initial value of the reduction
// accumulator combines the current result with the current value in the stream

// examples - 1
Stream.of(3, 5, 6);
stream.reduce(1, (a, b) -> a*b);

Stream.of("a", "b", "c");
stream.reduce("", (a, b) -> a+b);

// examples - 2
Stream.empty();
stream.reduce((a, b) -> a*b);		// Optional.empty; no seed so Optional return type

// examples - 3
Stream<String> stream = Stream.of("w", "o", "l", "f!");
int length = stream.reduce(0, (i, s) -> i+s.length(), (a, b) -> a+b);
System.out.println(length); 	// 5
```
**collect()**: Mutable reduction since it stores in a mutable object.
```java
public <R> R collect(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner)
public <R,A> R collect(Collector<? super T, A,R> collector)

// examples
TreeSet<String> set = stream.collect(
 TreeSet::new,		// init
 TreeSet::add,		// accumulate
 TreeSet::addAll);	// combnine all objects if parellel

stream.collect(Collectors.toCollection(TreeSet::new));
stream.collect(Collectors.toSet());		// no guarantee of order since its a Set
```

## Common Intermediate Operations
```java
Stream<T> filter(Predicate)
Stream<T> distinct()		// returns only distinct element Stream
Stream<T> limit(long n)		// finite Stream of size n
Stream<T> skip(long n)		// skip first n elements
Stream<T> map(Function)		// map a Stream to another Stream of diff type
Stream<T> flatMap(Function)	// combine two streams into one
Stream<T> sorted()
Stream<T> sorted(Comparator)
Stream<T> peek(Consumer)	// can modify state of stream (be careful!)

// examples
s.filter(x -> x.startsWith("a"));
s.map(String::length;

List<String> zero = List.of();
var one = List.of("A");
var two = List.of("BC", "DEF");
Stream<List<String>> letters = Stream.of(zero, one, two);
letters.flatMap(m -> m.stream())
		.forEach(System.out::print);	// ABCDEF

s.sorted((a, b) -> a-b);
s.sorted(Comparator.reverseOrder());

s.peek(System.out::println);
s.peek(list -> list.remove(0));		// modifying state with peek is not a good practice
```

### Concatenating Two Streams
```java
var one = Stream.of("A");
var two = Stream.of("B", "C");
Stream.concat(one, two)
 	  .forEach(System.out::println);

/*
A
B
C
*/
```

## Pipeline Pitfalls
The intermediate methods we call are processed on each element one-by-one. There can be some method like `sorted()` which waits for all elements to arrive.

**First element through entire Stream -> second element through entire stream -> ...**

```java
var list = List.of("Toby", "Anna", "Leroy", "Alex");
list.stream()
 .filter(n -> n.length() == 4)
 .sorted()
 .limit(2)
 .forEach(System.out::print);

// AlexAnna

Stream.generate(() -> "Elsa")
 .filter(n -> n.length() == 4)
 .sorted()
 .limit(2)
 .forEach(System.out::print);

// infinitely hangs; sorted keeps waiting for all elements to arrive but its an inf stream

Stream.generate(() -> "Elsa")
 .filter(n -> n.length() == 4)
 .limit(2)
 .sorted()
 .forEach(System.out::print);

// ElsaElsa

Stream.generate(() -> "Olaf")
 .filter(n -> n.length() == 4)
 .limit(2)
 .sorted()
 .forEach(System.out::print);

// infinitely hangs; limit keeps waiting for 2 elements but only one is there  
```

### Chaining Pipelines
```java
long count = Stream.of("goldfish", "finch")
	.filter(s -> s.length()> 5)
	.collect(Collectors.toList())
	.stream()			// chaining
	.count();
	System.out.println(count); // 1
```

## Primitive Streams
Certain streams are available to use which have primitive types inside and also a lot of commonly used convinience methods.
```java
IntStream - int, short, byte, char
LongStream - long
DoubleStream -  double, float

// usage
IntStream intStream = IntStream.of(1, 2, 3);
OptionalDouble avg = intStream.average();		// .sum() etc...

IntStream.range(1, 6);			// 12345
IntStream.closedRange(1, 6);	// 123456

Stream<String> objStream = Stream.of("penguin", "fish");
IntStream intStream = objStream.mapToInt(s -> s.length());

// OptionalDouble and Optional<Double> are diff but mostly the same methods are available
optional.ifPresent(System.out::println);
System.out.println(optional.getAsDouble());
System.out.println(optional.orElseGet(() -> Double.NaN));
```

### Summary Statistics
Useful if we want to get some stats about a primitive stream like getting min and max in one go.
```java
IntStream ints = Stream.of(1, 2, 3);
IntSummaryStatistics stats = ints.summaryStatistics();
stats.getCount();
stats.getMin();
stats.getMax();
stats.getSum();
stats.getAverage();
```

## Advanced Stream Pipeline Concepts
TBD