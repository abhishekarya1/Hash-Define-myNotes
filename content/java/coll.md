+++
title = "Collections"
date =  2022-05-27T15:04:00+05:30
weight = 8
+++

## Java Collection Framework

{{<mermaid>}}
graph TB;
    A[java.util.Collection]
    A --> B(List)
    A --> C(Queue)
    C --> K{PriorityQueue}
    C --> G(Deque)
    B --> E{ArrayList}
    B --> F{LinkedList}
    G --> F
    G --> J{ArrayDeque}
    A --> D(Set)
    D --> H{HashSet}
    D --> I{TreeSet}
{{< /mermaid >}}

{{<mermaid>}}
graph TB;
    A[Map]
    A --> B{HashMap}
    A --> C{TreeMap}
{{< /mermaid >}}


**NOTICE**: `LinkedList` implements both `List` and `Deque`. Diamond boxes are classes, rest are interfaces. Map doesn't from the `Collection` interface.

```java
List<Integer> listArr = new ArrayList<Integer>();
List<Integer> listArr = new ArrayList<>();			// RHS generic type is inferred and is optional
```

## List
`ArrayList` is faster in access (linear time) but slower in writing to List, `LinkedList` is vice-versa.

### Creating Lists with Constructor

When we create a ArrayList without any initial capacity, it allocates 10 to it by default which means that upto 10 elements JVM doesn't need to resize the list dynamically (by creating new array internally and assigning back to same ref). We can specify a diff initial capacity in constructor. **This is different from list's size as size is the number of actual elements stored rather than max allowed capacity value**.
```java
List<Integer> listArr = new ArrayList<>();				//empty list, size = 0; init capacity = 10
List<Integer> listArr2 = new ArrayList<>(anotherList);
List<Integer> listArr3 = new ArrayList<>(20);			//empty list, size = 0; init capacity = 20
```

The ArrayList capacity is resized by 50% of its current size when all elements are filled. So, ArrayList will be resized from 10, to 15, to 22, to 33 and so on.

The `List<>` created with constructor are mutable ofcourse because of this dynamic capacity resizing by Java.

### Creating Lists with Factory Methods
```txt
Arrays.asList(varargs)	 // can only update existing elements, not add or remove additional
                         // changes to the returned list "write through" to the original array

List.of(varargs)		 // purely immutable; error on any modification

List.copyOf(collection)	 // purely immutable; error on any modification
```

### var with List Constructor
```java
var listArr = new ArrayList<>();		// assumes type to be ArrayList<Object>; bad practice because ArrayList<Integer> and ArrayList<String> are both ArrayList<Object> but not convertible with each other
```

### Collection Methods
```java
add(Element)        // add at end
add(index, Element) // add at index and move others towards end
set(index, Element) // replace at index
get(index)

remove(int index)   // remove at a specific index
remove(T Element)   // remove an element having suppied value (overloaded method; smarter)

isEmpty()
size()

clear()
contains(Element)

forEach()
equals()
```

### Array to List
```java
Arrays.asList(nums);

// if nums array is of wrapper-class type Integer[], then above will work
// if nums array is of primitive type int[], then above will NOT work (no autoboxing for arrays, only single element)

// acts as a bridge = changes to the returned list "write through" to the original array!
Integer[] list = {1, 2, 3};
List<Integer> listWrapper = Arrays.asList(list);
listWrapper.set(1, 99);
System.out.println(list[1]);    // 99
```

```java
// primitive int[] has to be converted to List using a loop
List<Integer> listNums = new ArrayList<>();
for(int e : nums){      
    listNums.add(e);    // auto-boxing
}
```

### List to Array
```java
Object[] arr = list.toArray();
String[] arr = list.toArray(new String[0]);

// 1. copy list into a new array; an array of Object type is created by default
// 2. makes a String array; size can be anything it doesn't matter, its just there to specify type
```

### Collection Types and Overriding
Collections define their own type based on the generic `<>` parameter type. `List<String>` is not convertible to `List<Integer>`, neither is it convertible to `List<CharSequence>` even though `String` type can be converted to its superclass type `CharSequence`.

Check both "type of list" and its "contents" when checking for compatibility.

**Collection Overriding Thumb Rule**: generic type `<>` should match exactly when overriding collections, collection type itself must be same or covariant
```java
class X{
    List<CharSequence> foo(){ }
}

class Y extends X{
    @Override
    List<String> foo(){ }       // compiler-error
}
```

```java
class X{
    List<CharSequence> foo(){ }
}

class Y extends X{
    @Override
    ArrayList<String> foo(){ }       // compiler-error; list <> parameter type is causing the issue
}
```

```java
class X{
    List<CharSequence> foo(){ }
}

class Y extends X{
    @Override
    ArrayList<CharSequence> foo(){ }       // valid
}
```

## Set
Doesn't store duplicate entries. 

**HashSet**: uses Hashtable so Constant time access but loses order

Uses `hashCode()` and `equals()` to find corresponding bucket to put item in.

**TreeSet**: uses sorted tree structure (BST); logarithmic time for access but order is numerically sorted

```java
Set<Integer> s = new HashSet<>();
s.add(1);
s.add(2);
s.add(3);
s.add(3);
for(Integer i: s)
    System.out.println(i);      // 2 3 1 (arbitrary)

Set<Integer> s = new TreeSet<>();
s.add(3);
s.add(2);
s.add(1);
s.add(3);
for(Integer i: s)
    System.out.println(i);      // 1 2 3 (numerically sorted)
```

### Creating Sets
All are immutable.
```java
Set<Integer> set = new HashSet<>();

// Factory Methods
Set.of(varargs)
Set.copyOf(collection)
```

## Queue and Deque
Use `ArrayDeque` if you don't need List methods. 

Single ended FIFO queue - `Queue<>` (`<- remove <- ... <- add <-`) (`front --- back`)

We often use queues as stacks (recommended over the legacy `Stack` collection class), use `Deque<>` which has `push()`/`pop()` and `First`/`Last` methods available extra which push and pop at the same side (front).

```java
// a Deque<Integer> q -> 1 2 3
// First ---- Last
// Top --- Bottom

q.add(4);       // 1 2 3 4
q.remove();     // 2 3 4
q.element();    // 2; no removal

q.push(5);  // 5 2 3 4
q.pop();    // 2 3 4     // same as remove()
q.peek();   // 2; no removal

q.addFirst(5);   // 5 2 3 4
q.addLast(6);   // 5 2 3 4 6

q.getFirst();   // 5; no removal
q.getLast();   // 6; no removal

q.removeFirst();   // 2 3 4 6 
q.removeLast();   // 2 3 4
```

Methods are available which throw exceptions when something goes wrong and corresponding methods are available which do the same but don't throw any exceptions.
```java
q.element();    // throws exception if queue is empty
q.peek();       // never throws exception

q.add(Element);     // exception
q.offer(Element);   // no exception

q.remove(); // exception
q.poll();   // no exception
```

If we try and `get` an element from an empty collection, it will throw `NoSuchElementException` at runtime (unchecked exception).

## Map
Key-value pairs and access time is linear. Can only contain duplicate values, not keys.

### Creating Maps with Factory Methods
All are immutable.
```java
// Factory Methods
Map.of("key1", "value1", "key2", "value2");

Map.ofEntries(
 Map.entry("key1", "value1"),
 Map.entry("key2", "value2"));

Map.copyOf(collection)
```

They all create immutable maps, but the differences are:
- `Map.of()` is slightly weird syntax because of the boxing of adjacent values as a KV pair, also it can max have 10 KV pairs, unlike Collection methods like `List.of()`, `Set.of()`, etc...
- `Map.ofEntries()` introduced in Java 9 allows creation of more than 10 KV pairs, that too in a more intuitive syntax.

### Map Methods
```java
Map<String, String> map = new HashMap<>();

map.put("A", "Apple");
map.get("A");       // Apple; if no such key exists then "null" is returned (caution!)
map.put("A", "Apricot");    // "Apricot" will replace "Apple" (keys form a set; no duplicates) (caution!)


map.keySet();   // returns Set of keys, can use in forEach loop
map.values();

map.contains();     // compiler-error; method doesn't exist in Map interface (its a Collection interface method) 
map.containsKey("A");
map.containsValue("Apple");

map.size(); // 1

map.forEach((k, v) -> System.out.println(k));     // print all keys; takes BiFunction

map.values().forEach(System.out::println);  // prints all values

// advance methods
map.getOrDefault("A", "Alpha");
map.putIfAbsent("C", "Cat");    // otherwise ignore
map.replace("B", "Bear");       // replace value for key "B" with "Bear"
map.replaceAll((k, v) -> k+v);  // if key and values are numeric; takes BiFunction
```

### Ordering of Keys
**HashMap**: unordered keys. Implemented internally using a array of linked lists. [notes](/java/misc/#hashmap)

**TreeMap**: has ordered keys unlike `HashMap`. We've to supply a `Comparator` when creating a `TreeMap` to specify relative ordering of keys. Uses Red-Black Tree internally (self-balancing trees).

```java
Map<Integer, String> mp = new HashMap<>();
mp.put(1, "X");
mp.put(2, "Y");
mp.put(3, "Z");

for (var e : mp.keySet()) {
    System.err.println(e);
}

// Output: 123

Map<Integer, String> mp = new TreeMap<>(Comparator.reverseOrder());     // changed only this
mp.put(1, "X");
mp.put(2, "Y");
mp.put(3, "Z");

for (var e : mp.keySet()) {
    System.err.println(e);
}

// Output: 321
```

## Sorting Data

### Comparable
A functional interface from `java.lang.Comparable` (no need to `import`). Uses `compareTo()` method, takes 1 argument and returns an `int`.
```java
public class Foo implements Comparable<Foo>{
    private String name;
    public int compareTo(Foo f){
        return name.compareTo(f.name);     // asc sort by name; uses String's compareTo()
    }
}

List<Foo> fooList = new ArrayList<>();
// ...
Collections.sort(fooList);
```

### Return values
```txt
negative number (< 0) - current object less than argument object
zero (= 0)            - current object equal to argument object
positive number (> 0) - current object greater than argument object
```

```java
// to compare numeric types
public class Animal implements Comparable<Animal> {
    private int id;
    public int compareTo(Animal a) {
        return id - a.id;   // sorts ascending by id
    }
    
    public static void main(String[] args) {
        var a1 = new Animal();
        var a2 = new Animal();
        a1.id = 5;
        a2.id = 7;
        System.out.println(a1.compareTo(a2)); // -2
        System.out.println(a1.compareTo(a1)); // 0
        System.out.println(a2.compareTo(a1)); // 2
}} 

// now if we create a List<Animal>, we can use below statement to sort since compareTo() has been defined for our Animal class
Collections.sort(animalList);
```

If we don't specify generic type, the argument is `Object o` type. And we can always cast it to proper type inside the method to compare.
```java
public class LegacyWay implements Comparable{   // no generic type specified
public int compareTo(Object obj) {
    LegacyWay d = (LegacyWay) obj;    // cast because no generics
    return name.compareTo(d.name);    // assumes name is String type
}}
```

It is a good programming practice to keep `equals()` and `compareTo()` consistent with each other.

### Comparator
Also, a functional interface from from `java.util.Comparator`. Uses `compare()` method, takes 2 arguments and returns `int`.

```java
Comparator<Duck> byWeight = new Comparator<Duck>() {    // anon class impl
public int compare(Duck d1, Duck d2) {      // override and impl
    return d1.getWeight() - d2.getWeight();
}};

Collections.sort(ducks, byWeight);      // use

Comparator<Duck> byWeight = (d1, d2) -> d1.getWeight() - d2.getWeight();  // using lambda and getter
// same as above but much shorter using direct field access without getter
Collections.sort(list, (d1, d2) -> d1.weight - d2.weight);  

Comparator<Duck> byWeight = Comparator.comparing(Duck::getWeight);  // another way using Comparator.comparing() static method which generates a lambda automatically
```

### Comparator Chaining

```java
// build a comparator; provide getter for field being used to perform comparison; returns a Comparator
Comparator.comparing(Function);                 // compare by results of a Function that returns any Object
Comparator.comparingInt(ToIntFunction);         // compare by results of a Function that returns an int
Comparator.comparingLong(ToLongFunction);       // compare by results of a Function that returns a long
Comparator.comparingDouble(ToDoubleFunction);   // compare by results of a Function that returns a double

Comparator.naturalOrder();  // no need to specify any field/getter; works only on known types like Integer, String, etc..
Comparator.reverseOrder();  // no need to specify any field/getter; works only on known types like Integer, String, etc..

// chaining with more methods
.reversed();
.thenComparing(Function);    // if previous comparator returns 0 (a tie), run this, otherwise return the value from previous
.thenComparingInt(ToIntFunction);
.thenComparingLong(ToLongFunction);
.thenComparingDouble(ToDoubleFunction);

// example
Comparator<Foo> c = Comparator.comparing(Foo::getMarks).thenComparing(Foo::getName);
// compare by marks; or by name if marks comparison is a tie.
```

### Sorting Methods
`Collections.sort()` can use both `Comparable` as well as `Comparator`. Returns `void`, modifies the collection supplied to it. 

- while `Comparable<T>` is usually implemented within the class whose objects are being compared as `int compareTo(T a)` override, called implicitly by `Collections.sort()` 
- and `Comparator`'s `int compare(U a, U b)` method is usually implemented using lambda expression passed as the second argument of `Collections.sort()`

Other ways to sort:
```java
Collections.reverse(collection);   // reverses whatever current order is there

// sorting a list; List's sort() method also takes in a Comparator<T>
listObj.sort((d1, d2) -> d1.marks - d2.marks);
// alternatively
listObj.sort(Comparator.comparing(Student::getMarks));

// use null as parameter for natural ordering
listObj.sort(null);
// alternatively; explicitly specify comparator
listObj.sort(Comparator.naturalOrder());
```

## Iterator
An object used to loop (iterate) through collections (based on Iterator design pattern).

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(12);
numbers.add(8);
numbers.add(2);
numbers.add(23);

Iterator<Integer> it = numbers.iterator();      // alternatively, use var here

while(it.hasNext()) {
    Integer i = it.next();  // get an element
    if(i < 10) {
        it.remove();        // remove numbers with value < 10
    }
}

System.out.println(numbers);
```

### Fail-Fast Iterators (default)
What happens if underlying collection is modified after the iterator has been created? Iterator may throw a `ConcurrentModificationException` (best effort basis).

Collections maintain an internal counter called `modCount`. Each time an item is added or removed from the Collection, this counter gets incremented. When iterating, on each `next()` call, the current value of `modCount` gets compared with the initial value. If there's a mismatch, it throws `ConcurrentModificationException` which aborts the entire operation.

```java
Iterator<Integer> it = numbers.iterator();

while (it.hasNext()) {
    Integer n = it.next();
    numbers.add(50);                    // ConcurrentModificationException
}
```

Removal is fine if done with Iterator's `it.remove()` method and not Collection Impl class `list.remove()` method:
```java
while (it.hasNext()) {
    if (it.next() == 40) {
        it.remove();          // fine; removes 40
    }
}

while (it.hasNext()) {
    if (it.next() == 40) {
        numbers.remove(0);      // ConcurrentModificationException
    }
}
```

{{% notice note %}}
Only structural modifications (add/remove elements) leads to a `ConcurrentModificationException` with FF iterators; and not updation of existing elements. Ex - update to a list using `list.set(2, "X")`.
{{% /notice %}}

### Fail-Safe Iterators
Iterators on Collections from `java.util.concurrent` package such as `ConcurrentHashMap`, `CopyOnWriteArrayList`, etc.. are Fail-Safe in nature.

They are aware of the elements being added to the underlying collection and update `modCount` accordingly concurrently.

```java
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
map.put("First", 10);
map.put("Second", 20);

Iterator<String> it = map.keySet().iterator();

while (it.hasNext()) {
    String key = it.next();
    map.put("Third", 30);       // fine; loop executes 3 times
}
```

## Third-Party Collection Libraries
Offers more collections such as `ImmutableMap`, `BiMap` (map which can be accessed via values and keys as well!), `MultiMap` (map a key to multiple values!), etc...

Most popular are:
- **Google Guava** (simple to use and actively developed)
- Apache Commons Collections (slightly faster and offers much more features)

Comparison: https://www.baeldung.com/apache-commons-collections-vs-guava
Guava Demo: https://www.baeldung.com/guava-collections

## Interview Questions based on Collections Internals
[/java/misc/#top-interview-questions-on-collections-internals](/java/misc/#top-interview-questions-on-collections-internals)