+++
title = "Collection and Generics"
date =  2022-05-27T15:04:00+05:30
weight = 8
+++

## Java Collection Framework

{{<mermaid>}}
graph TB;
    A[java.util.Collection]
    A --> B(List)
    A --> C(Queue)
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


**NOTICE**: `LinkedList` implements both `List` and `Deque`. Diamond boxes are classes, rest are interfaces.

```java
List<Integer> listArr = new ArrayList<Integer>();
List<Integer> listArr = new ArrayList<>();			// RHS generic type is inferred and is optional
```

## List
`ArrayList` is faster in access (linear time) but slower in writing to List, `LinkedList` is vice-versa.

### Creating Lists with Constructor
```java
List<Integer> listArr = new ArrayList<>();				//empty list, size = 0
List<Integer> listArr2 = new ArrayList<>(anotherList);
List<Integer> listArr3 = new ArrayList<>(10);			//empty list, size = 10
```

The `List<>` created with constructor are mutable and do not create another instance in memory on `add()` or `remove()`.

### Creating Lists with Factory Methods
```txt
Arrays.asList(varargs)	 // can only update existing elements, not add or remove additional
List.of(varargs)		 // purely immutable; error on any modification
List.copyOf(collection)	 // purely immutable; error on any modification
```

### var with List Constructor
```java
var listArr = new ArrayList<>();		// counter-intuitive but it works and assumes type to be ArrayList<Object>; bad practice because ArrayList<Integer> and ArrayList<String> are both ArrayList<Object> but not convertible with each other
```

### Collection Methods
```java
add(Element)        // add at end
add(index, Element) // add at index and move others towards end
set(index, Element) // replace at index
get(index)
remove(index)
remove(Element)

isEmpty()
size()

clear()
contains(Element)

forEach()
equals()
```

### List to Array
```java
Object arr = list.toArray();
String arr = list.toArray(new String[0]);

// 1. copy list into a new array; an array of Object type is created by default
// 2. makes a String array; size can be anything it doesn't matter, its just there to specify type
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
```java
Set<Integer> set = new HashSet<>();

// Factory Methods
Set.of(varargs)
Set.copyOf(collection)
```

## Queue and Deque
Use `ArrayDeque` if you don't need List methods. 

Single ended FIFO queue - `Queue<>` (`<- remove <- ... <- add <-`) (`front --- back`)

We often use queues as stacks so we use `Deque<>` which has `push()`/`pop()` and `First`/`Last` methods available extra.

```java
// a Deque<Integer> q -> 1 2 3
// First ---- Last
// Top --- Bottom

q.add(4);       // 1 2 3 4
q.remove();     // 2 3 4
q.element();    // 2

q.push(5);  // 5 2 3 4
q.pop();    // 2 3 4     // same as remove()
q.peek();   // 2

q.addFirst(5);   // 5 2 3 4
q.addLast(6);   // 5 2 3 4 6

q.getFirst();   // 5
q.getLast();   // 6

q.addFirst(7);   // 7 5 2 3 4 6 
q.addLast(8);   // 7 5 2 3 4 6 8
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

If we try and get element in an empty collection, it will throw `NoSuchElementException` at runtime (unchecked).

## Map
Key-value pairs and access time is linear. Unordered. Can only contain duplicate values, not keys.

### Creating Sets with Factory Methods
```java
// Factory Methods
Map.of("key1", "value1", "key2", "value2");

Map.copyOf(collection)

Map.ofEntries(
 Map.entry("key1", "value1"),
 Map.entry("key2", "value2"));
```

### Map Methods
```java
Map<String, String> map = new HashMap<>();

map.put("A", "Apple");
map.get("A");       // Apple; if no such key exists then "null" is returned (caution!)
map.put("A", "Apricot");    // "Apricot" will replace "Apple" (keys form a set; no duplicates)


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

## Sorting Data

### Comparable
A functional interface from `java.lang.Comparable` (no need to `import`). Uses `compareTo()` method, takes 1 argument and returns an `int`.
```java
public class Foo implements Comparable<Foo>{
    private String name;
    public int compareTo(Foo f){
        return name.compareTo(f.name);     // asc sort by name
    }
}

List<Foo> fooList = new ArrayList<>();
// ...
Collection.sort(fooList);
```

### Return values
```txt
negative number (< 0) - current object less than argument object
zero (= 0)            - current object equal to argument object
positive number (< 0) - current object greater than argument object
```

```java
// another way to compare numeric types
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
```

If we don't specify generic type, the argument is `Object o` type. And we can always cast it to proper type inside the method to compare.
```java
public class LegacyWay implements Comparable{   // no generic type specified
public int compareTo(Object obj) {
    LegacyWay d = (LegacyWay) obj;    // cast because no generics
    return name.compareTo(d.name);
}}
```

It is a good programming practice to keep `equals()` and `compareTo()` consistent with each other.

### Comparator
Also, a functional interface from from `java.util.Comparator`. Uses `compare()` method, takes 2 arguments and returns `int`.

```java
Comparator<Duck> byWeight = new Comparator<Duck>() {
public int compare(Duck d1, Duck d2) {      // override and impl
    return d1.getWeight()-d2.getWeight();
}};

Collections.sort(ducks, byWeight);      // use

Comparator<Duck> byWeight = (d1, d2) -> d1.getWeight()-d2.getWeight();  // using lambda

Comparator<Duck> byWeight = Comparator.comparing(Duck::getWeight);  // another way using comparing() static method which generates a lambda
```

### Comparator Chaining

```java
// build a comparator
Comparator.comparing(function);     // compare by results of a function that returns any Object
Comparator.comparingInt();          // compare by results of a function that results an int
Comparator.comparingLong();          // compare by results of a function that results a long
Comparator.comparingDouble();          // compare by results of a function that results a double

// chain it
.reversed();
.thenComparing(function);    // if previous comparator retuens 0, run this, oterwise return value from pervious
.thenComparingInt(function);
.thenComparingLong(function);
.thenComparingDouble(function);

// example
Comparator<Foo> c = Comparator.comparing(Foo::getMarks).thenComparing(Foo::getName);
// compare by marks; or by name if marks comparison is a tie
```

### Collection.sort()
It can use both `Comparable` as well as `Comparator`. Returns `void`, modifies the collection supplied to it. 

While `Comparable<T>` is usually implemented within the class being compared uses `compareTo()` override, and `Comparator` is usually implemented using lambda expression in the second argument.

```java
Collection.reverse(collection);

// sorting a list; List's sort() also takes in a Comparator
list.sort((d1, d2) -> d1.compareTo(d2));
```

---
## Generics

```java
class Foo<T>{
    private T foo;
    private T bar;

    public void setFoo(T foo){
        this.foo = foo;
    }
}

Foo<Integer> obj = new Foo<>();
Foo<String> obj2 = new Foo<>();

class Foo<T, U>{
    private T foo;
    private U bar;

    public Foo(T foo, U bar){
        this.foo = foo;
        this.bar = bar;
    }
}

Foo<Integer, String> obj = new Foo<>(5, "foo");
Foo<String, Float> obj2 = new Foo<>("bar", 2.33);
```

### Type Erasure
After compilation, both `Foo<Integer>` and `Foo<String>` will become a single class `Foo<Object>`. The compiler takes care of all the object casts to our generic type too.

### Overloading and Overriding Generic Methods
Since all generic types resolve to Object, we have to be careful with overloading.
```java
void foobar(List<Integer> arr)
void foobar(List<Float> arr)
// they both become List<Object> so compiler error

void foobar(List<Integer> arr)
void foobar(ArrayList<Integer> arr) 
// allowed since its normal overloading

//overriding
// Overriding is allowed with covariant return types; generic type <> is not considered here!
List<CharSequence> foobar(){ }
// overriding above method -
ArrayList<CharSequence> foobar(){ }     // allowed because ArrayList and List are covariant
List<String> foobar(){ }    // not allowed
```

### Generic Interfaces
Interfaces can be generic too.
```java
public interface Foo<T>{
    void foobar(T i);
}

// three ways to implement generic interfaces
class Bar implements Foo<Integer>{
    void foobar(Integer i){ }
}

class Bar<U> implements Foo<U>{ 
    void foobar(U i){ }
}


//old way, compiler warning, raw type
class Bar implements Foo{
    void foobar(Object i){ }
}
```

### Limitations of Generics
1. We can't write `new T()` because it will be `new Object()` during compilation
2. Can't create an array of generic type as it will just be an array of `Object` type
3. Can't call `instanceof` for same reason as above 
4. Can't use primitive type in generic type, instead we use wrapper classes
5. Can't use static variable as generic type, because the type is linked to the instance of the class

### Generic Methods
```java
//if method is not obtaining from its owner class/interface, we can specify in definition using <>
static <T> void foo(T m){ }
<T> void bar(T n){ }
public <T, U> demo(T a, U b){ }

//invoking a generic method explicitly; compile will figure out otherwise
Box.<String>ship("package");
Box.<String[]>ship(args);
```

```java
//if you declare a generic type on a method inside a generic class, it becomes independent of class's
class Foo<T>{
    <T> void bar(T t){

    }
}

Foo<String> obj = new Foo<>();      // String
obj.bar(99);                        // Integer
```

### Generic Records
```java
public record Foo<T, U>(T name, U age){ }
```

### Bounding Generic Types
Limiting generic types to allow certain types only.
```java
List<?>               // unbounded
List<? extends Class> // only those types which are subclasses of Class (upper bound)
List<? super Class>   // only those types which are superclasses of Class (lower bound)
```
### Unbounded Wildcard

We can't cast `List<String>` to `List<Object>` since once its made a list of Objects, we can convert it to other subclass types also e.g. `List<Integer>`, `List<Dog>`, etc... So, Java doesn't allow such conversions and we can't use `List<Object>` as a common type.

We need to use `<?>` for all such cases where we need to accept "any" type.
```java
List<?> arr = new ArrayList<String>();
// we specified type as <String> otherwise <Object> would've been assigned by default so now we can only insert String into it
// also arr List will be immutable! (see below)

// a more practical example would be: 
public static void printList(List<?> list) {        // use
    for (Object elem : list)
        System.out.println(elem + " ");
    System.out.println();
}

// we can pass any kind of list to it, and it prints it
```

### var vs. Unbounded Wildcard
```java
List<?> arr1 = new ArrayList<>();    // a List type reference; List<Object>
var arr2 = new ArrayList<>();        // an ArrayList type reference; ArrayList<Object>
```

### Upper-bounded Wildcard
```java
List<? extends Foobar>      // we can pass any class that extends Foobar or Foobar itself
```


### Lower-bounded Wildcard
```java
List<? super Foobar>      // we can pass any class that is parent of Foobar or Foobar itself
```

### Immutability in Bounds
**Unbounds `<?>` and Upper-bounds `<? extends Foobar>` make the list logically immutable, only removal of elements can be done**.
```java
List<?> list = new ArrayList<Integer>();
list.add(1);    // error

List<? extends Integer> list = new ArrayList<Integer>();
list.add(1);    // error

List<? super Integer> list = new ArrayList<Integer>();
list.add(1);    // valid; now errors
```

This is a major reason to use Lower-bounds when any other two could've worked just the same but with the immutability issue.