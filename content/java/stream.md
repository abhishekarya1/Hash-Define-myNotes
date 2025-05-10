+++
title = "Streams"
date =  2022-05-28T19:28:00+05:30
weight = 10
+++

## Optional
A container that can be empty or have a value. We can specify type `Optional<type>` for the container too.
```java
//empty box
Optional.empty()
//box with a value
Optional.of(5)

System.out.println(Optional.empty());   // Optional.empty

// Optional<Object> raw ref (not recommended)
Optional i = Optional.of(5);
// Optional ref with formal type parameter
Optional<Integer> i2 = Optional.of(6);

Foobar fb = null;
Optional.of(fb);    // NullPointerException at runtime; use .ofNullable() to prevent

Optional<String> o = Optional.ofNullable(foo);
// if foo is null, then o is assigned by performing Optional.empty() otherwise Optional.of(foo) is performed
```

### Optional Instance Methods
```java
// checking for empty
boolean isPresent()				// boolean
// accessing
T get()					        // returns value inside Optional
// if its empty and we access without check - NoSuchElementException at runtime

void ifPresent(Consumer)		// use lambda, calls it with value if present

T orElse(T value)				// returns value; if Optional is empty
T orElseGet(Supplier)		    // returns result from Supplier; if Optional is empty

T orElseThrow()			        // throws NoSuchElementException at runtime; if Optional is empty
T orElseThrow(Supplier)     	// throws an exception instance supplied by Supplier; if Optional is empty
```

**Examples**
```java
String s = Optional.ofNullable(str).orElse("A");

Optional<Integer> o = Optional.of(88);

if(o.isPresent()){
    Integer i = o.get();
}

o.ifPresent(x -> System.out.println(x));            // prints "88"
o.ifPresent(System.out::println);                   // using method reference

o.orElseGet(() -> 99);                              // returns "88"; "o" isn't empty
o.orElseGet(() -> Math.random());       

o.orElseThrow(() -> new IllegalStateException());
o.orElseThrow(IllegalStateException::new);          // using method reference
```

### Primitive Optionals
```java
OptionalInt i = OptionalInt.of(2);
i.getAsInt();   // 2

// "OptionalDouble" and "OptionalLong" types are also available
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

## Stream vs Loops
**We can't loop on Stream the way we do on other Collections and arrays.**
```java
Stream<Integer> s = Stream.of(1, 2, 3);
for(Integer i : s){ }   // does not compile
```

**Streams perform a lot worse on smaller data, its better to use a simple `for` loop.**
- functional style of programming
- syntactically terse and clean code
- faster on large data
- parallel processing with parallel stream

As a rule-of-thumb, if your list has less than order of a few thousand elements, its better to use a `for` or a `while` loop performance-wise.

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

Optional<T> reduce()
Collection collect()
```

### reduce() and collect()
**reduce()**: reduce entire stream to a single value.
```java
public T reduce(T identity, BinaryOperator accumulator)		// 1, return type is same as that of seed
public Optional<T> reduce(BinaryOperator accumulator)		// 2, no seed so return type is Optional
public U reduce(U identity, BiFunction accumulator, BinaryOperator combiner)	// 3, when dealing with different data types

// identity is the initial value of the reduction
// accumulator is a function that takes two parameters: a partial result of the reduction operation and the next element of the stream
// combiner is only needed when combining partial results in parallel streams or when accumulator params is of diff types (even in serial streams)

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
 TreeSet::addAll);	// combine all objects if parallel reductions

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
Stream<T> map(Function)		// map (replace) stream elements with another element (1:1 mapping)
Stream<T> flatMap(Function)	// map stream elements with multiple elements (1:N mapping) and flatten the results
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

## More on Stream Operations

### Stateful vs Stateless Operations

**Stateless**: elements of the stream are processed one-by-one, and no state info is retained for previously processed elements of the stream. Ex - `filter()`, `map()`, `forEach()` etc.
```txt
first element through entire stream till terminal operation -> 
second element through entire stream till terminal operation -> 
and so on ...
```

**Stateful**: state info is retained for previously processed elements, there maybe some _wait_ or _processing_ involved here when processing elements of the stream (e.g. with `sorted()`). Ex - `sorted()`, `limit()`, `distinct()`, `count()`  etc. 

```txt
first element stops at stateful operation -> 
second element stops at stateful operation ->
and so on ...
all stream elements arrive and sorting happens ->
next operations run... 
```

### Short-circuiting Streams
Some operations on streams can terminate processing early without processing all the elements of the stream. Ex - intermediate operations like `limit()` and terminal operations like `findFirst()`, `anyMatch()`, etc.

These short-circuiting operations are efficient because they can reduce the amount of work done by the stream pipeline by stopping the processing as soon as a conclusive result is found.

## Pipeline Pitfalls

### Pitfalls with Infinite Streams
Stateless methods work fine on both finite and infinite streams. As they're processed one-by-one till terminal operation.

With serial streams, the stateful methods run in a finite amount of time.

**With infinite streams, stateful methods like `sorted()` cause pitfalls** as it waits for all the elements to arrive to continue processing. This fills up the heap memory and causes `OutOfMemoryError` runtime exception. Terminal operations like `count()` can appear hung too since its busy processing all elements which are coming from the infinite stream.

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

// infinitely hangs, OutOfMemoryError runtime exception; sorted keeps storing and waiting for all elements to arrive but its an inf stream

Stream<Integer> s = Stream.generate(() -> 5);
System.out.println(s.count());                  

// infinitely hangs; count keeps counting elements but they never stop coming since its an inf stream

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
### Mutable Collection to Stream
Creating a stream from an existing collection and modifying the underlying collection afterwards:
```java
List<Integer> ls = new ArrayList<>();
ls.add(1);
ls.add(5);
var s = ls.stream();                        // stream isn't created here!
ls.add(10);                                 // adding an element to Collection
System.out.println(s.count());              // stream pipeline actually runs here; terminal operation

// count = 3
// a stream is created and pipeline is executed only where a terminal operation is performed (lazy evaluation).
// alt expl: streams don't read the data from the source (the list in this case) until a terminal operation is executed. 
```

### Chaining Pipelines
We can immediately convert to stream after a terminal operation:
```java
long count = Stream.of("goldfish", "finch")
	.filter(s -> s.length() > 5)
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

## Advanced Stream Concepts
- [Spliterator](https://www.baeldung.com/java-spliterator): used to traverse (`tryAdvance()`) and partition streams (`trySplit()`) into two equal halves and process those partitions independently.
- [Java 9 Stream API Improvements](https://www.baeldung.com/java-8-streams#1-takewhile-and-dropwhile): `takeWhile()` and `dropWhile()` intermediate operations useful for ordered streams, both take a `Predicate` as input param.
- [Collectors](https://www.baeldung.com/java-collectors): `groupingBy()` and `partitioningBy()` to store stream elements in a Map.
- [Java 24 Stream Gatherers](https://docs.oracle.com/en/java/javase/22/core/stream-gatherers-01.html)

## Snippets and Practice Excercises 

### Useful Snippets
```java
// convert String to stream
IntStream c = str.chars()

// convert stream to String
Collectors.joining()
Collectors.joining(", ", "PRE-", "-POST")    // optional separator, prefix, or postfix

// convert array to stream
Arrays.stream(arr)

// primitive stream to wrapper class stream
IntStream nums = IntStream.of(1, 2, 3);
Stream<Integer> list = nums.boxed();        // returns a Stream<Integer>
List<Integer> list = nums.boxed().collect(Collectors.toList());     // collect into to list as usual
```

### Excercises
- Array to stream conversion, using indices in stream - [link](https://leetcode.com/problems/find-words-containing-character/solutions/4576478/solution-using-java-8-streams-api/)
- Converting stream to a single `String` - [link](https://leetcode.com/problems/check-if-two-string-arrays-are-equivalent/solutions/4576826/java-8-streams-api-solution/)
- Dynamic `int` value in stream pipeline based on input `String` - [link](https://leetcode.com/problems/count-items-matching-a-rule/solutions/4577017/java-8-stream-api-solution/)
- String Splitting - [link](https://leetcode.com/problems/reverse-words-in-a-string/solutions/4581391/java-8-stream-api-solution/)
- Finding maximum number from a list:
```java
list.stream().max(Comparator.naturalOrder());       // using max() terminal operation

list.stream().collect(maxBy(Comparator.naturalOrder()));    // alt, using Collectors.maxBy()
```
- Find employees with maximum salary from each age group:
```java
Map<Integer, Employee> highestSalaryByAge = employees.stream()
                                            .collect(Collectors.groupingBy(Employee::getAge, Collectors.maxBy(Comparator.comparing(Employee::getSalary))));

// maxBy (downstream) is applied for each collected group from the groupingBy operation (classifier) 
```