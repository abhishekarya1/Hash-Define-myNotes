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

System.out.println(Optional.empty());   // Optional.empty

// Optional ref
Optional i = Optional.of(5);
// Optional ref with formal type parameter
Optional<Integer> i2 = Optional.of(6);

Foobar fb = null;
Optional.of(fb);    // NullPointerException; use .ofNullable()

Optional o = Optional.ofNullable(foo);
// if foo is null, then o is assigned Optional.empty() otherwise Optional.of(foo) is assigned
```

### Optional Instance Methods
```java
// checking
isPresent()				// boolean
// accessing
get()					// returns value inside Optional
// without check if we access - NoSuchElementException

ifPresent(Consumer)		// use lambda, calls it with value if present

orElse(T value)				// returns other parameter
orElseGet(Supplier)		// returns result from Supplier

orElseThrow()			// throws NoSuchElementException
orElseThrow(Supplier)	// throws exception instance supplied by Supplier
```

**Examples**
```java
String s = Optional.ofNullable(str).orElse("A");

o.ifPresent(System.out::println);
o.ifPresent(x -> System.out.println(x));

o.orElseGet(() -> 99);
o.orElseGet(() -> Math.random());

o.orElseThrow(() -> new IllegalStateException());
```

### Primitive Optionals
```java
OptionalInt i = OptionalInt.of(2);
i.getAsInt();   // 2

// OptionalDouble, OptionalLong are also available
```

## Streams
**Stream** is a sequence of objects. **Stream pipeline** is a sequence of operations we perform on a `Stream`.

`Stream<T>` interface defined in the `java.util.stream` package.

1. **Source**: a `Stream`
2. **Intermediate operations**: Each stage's output is a `Stream`, these don't run unless terminal operation runs (Lazy evaluation)
3. **Terminal operation**: Produces a result (single primitive or object) at last (_reduction_)

```java
// finite Stream
Stream.empty();
Stream.of(1, 2, 3);
Stream.of(1, 2, 3).parallel();

// from collection
coll.stream();
coll.parallelStream();

//infinite Stream
Stream.generate(Supplier);
Stream.iterate(seed, UnaryOperator);
Stream.iterate(seed, Predicate, UnaryOperator);		// maybe finite

// examples
Stream.generate(() -> 4);		// 4 4 4 4 4 ...
Stream.iterate(2, n -> n+2);	// 2 4 6 8 ...
Stream.iterate(1, n -> n < 50, n -> n+2);	// 1 3 5 7 ... 49
```

## Common Terminal Operations
```java
long count()

Optional<T> min(Comparator)
Optional<T> max(Comparator)

Optional<T> findAny()		// terminates inf stream, usually returns first element on finite Stream (undeterministic; may return something else also)
Optional<T> findFirst()		// terminates inf stream (deterministic; always returns first element of Stream)

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
**reduce()**: reduce entire stream to a single value.
```java
public T reduce(T identity, BinaryOperator accumulator)		// 1, return type is same as that of seed
public Optional<T> reduce(BinaryOperator accumulator)		// 2, no seed so return type is Optional
public U reduce(U identity, BiFunction accumulator, BinaryOperator combiner)	// 3, when dealing with different data types

// identity is the initial value of the reduction
// accumulator combines the current result with the current value in the stream

// examples - 1
Stream.of(3, 5, 6);
stream.reduce(1, (a, b) -> a*b);    // 90

Stream.of("a", "b", "c");
stream.reduce("", (a, b) -> a+b);   // "abc"

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
public R collect(Supplier supplier, BiConsumer accumulator, BiConsumer combiner)
public R collect(Collector collector)

// examples
TreeSet<String> set = stream.collect(
 TreeSet::new,		// init
 TreeSet::add,		// accumulate
 TreeSet::addAll);	// combnine all objects if parallel

// much easier syntaxes
stream.toList();    // only available for List since it is most commonly used
stream.collect(Collectors.toList());     // alt for above
stream.collect(Collectors.toSet());		 // for Sets, Maps, etc; remember no guarantee of order since its a Set
stream.collect(Collectors.toCollection(TreeSet::new)); // for very specific Collections like TreeSet, TreeMap, etc..
```

## Common Intermediate Operations
```java
Stream<T> filter(Predicate)
Stream<T> distinct()		// returns only distinct element Stream
Stream<T> limit(long n)		// finite Stream of size n
Stream<T> skip(long n)		// skip first n elements
Stream<T> map(Function)		// map (replace) stream elements with another elements
Stream<T> flatMap(Function)	// map stream elements with another stream's entire elements
Stream<T> sorted()
Stream<T> sorted(Comparator)
Stream<T> peek(Consumer)	// can modify state of stream (be careful!)

// examples
s.filter(x -> x.startsWith("a"));
s.map(String::length);      // do .length() on each element of Stream

// flatMap: map each element but what we are transforming each of them to is another stream, in the end, everything gets "flattened" (all elements)
Stream<String> str = Stream.of("A", "B", "C");
str.flatMap(e -> Stream.of(1, 2, 3)).forEach(System.out::print);   // 123123123

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
Stream.of("Olaf")
 .limit(2)
 .forEach(System.out::print);

// Olaf; limit() is just an upper-bound

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

Stream<String> str = Stream.of("A", "B", "C");
System.out.println(str.count());
System.out.println(str.findFirst());    // runtime error; performing another terminal operation on stream

// java.lang.IllegalStateException: stream has already been operated upon or closed
```

```java
List<String> ls = new ArrayList<>();
ls.add("A");
ls.add("B");
var s = ls.stream();    // stream isn't actually created here
ls.add("C");
s.count();              // stream is craeted in memory here and stream pipeline is run

// count = 3
// a stream is evaluated only when terminal operation is performed (lazy evaluation)
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
Certain streams are available to use which have primitive types inside and also a lot of commonly used type-specific convinience methods.
```java
IntStream - int, short, byte, char
LongStream - long
DoubleStream -  double, float

// usage
IntStream intStream = IntStream.of(1, 2, 3);    // we can use generate() and iterate() too
OptionalDouble avg = intStream.average();		// sum(), min(), max() also available

IntStream.range(1, 6);			// 12345
IntStream.closedRange(1, 6);	// 123456

// The above methods - min(), max(), sum(), average() return an Optional[]
// use getAsInt or getAsDouble methods on Optional[] to get:
s.min().getAsInt();
s.average().getAsDouble(); 

// mapTo<Type>() methods returns <Type>Stream objects
Stream<String> objStream = Stream.of("penguin", "fish");
IntStream intStream = objStream.mapToInt(s -> s.length());

// OptionalDouble and Optional<Double> are diff but mostly the same methods are available
var stream = IntStream.rangeClosed(1,10);
OptionalDouble optional = stream.average();
optional.ifPresent(System.out::println);
System.out.println(optional.getAsDouble());
System.out.println(optional.orElseGet(() -> Double.NaN));
```

### Summary Statistics
Useful if we want to get some stats about a primitive stream like getting min and max in one go.
```java
IntStream ints = IntStream.of(1, 2, 3);
IntSummaryStatistics stats = ints.summaryStatistics();
stats.getCount();
stats.getMin();
stats.getMax();
stats.getSum();
stats.getAverage();
```

## Advanced Stream Pipeline Concepts
TBD