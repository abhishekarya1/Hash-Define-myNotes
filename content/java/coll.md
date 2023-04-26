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
Object[] arr = list.toArray();
String[] arr = list.toArray(new String[0]);

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

We often use queues as stacks so we use `Deque<>` which has `push()`/`pop()` and `First`/`Last` methods available extra.

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
Key-value pairs and access time is linear. Unordered. Can only contain duplicate values, not keys.

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
positive number (< 0) - current object greater than argument object
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
```

---
## Generics
`<T>` is called a **Formal Type Parameter** here.

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


// below works too; type inference via constructor call; not recommended
Foo obj3 = new Foo("test", 99);
```

### Type Erasure
After compilation, both `Foo<Integer>` and `Foo<String>` will become a single class `Foo<Object>`. The compiler takes care of all the object casts to our generic type too.

### Overloading and Overriding Generic Methods
Since all generic types resolve to Object, we have to be careful with overloading and overriding.
```java
void foobar(List<Integer> arr)
void foobar(List<Float> arr)
// they both become List<Object> so compiler error

void foobar(List<Integer> arr)
void foobar(ArrayList<Integer> arr) 
// allowed since its normal overloading

//overriding
// Overriding is allowed with covariant return types; generic type <> is not considered here because of Type Erasure
List<CharSequence> foobar(){ }
// overriding above method:
ArrayList<CharSequence> foobar(){ }     // allowed because ArrayList implements List (covariant); vice-versa not allowed
```

### Generic Interfaces
Interfaces can be generic too.
```java
public interface Foo<T>{
    void foobar(T i);
}

// three ways to implement generic interfaces
class Bar implements Foo<Integer>{
    public void foobar(Integer i){ }
}

class Bar<U> implements Foo<U>{ 
    public void foobar(U i){ }
}


//old way, compiler warning, raw type
class Bar implements Foo{
    public void foobar(Object i){ }
}
```

### Limitations of Generics
1. Can't do `new T()`
2. Can't do `new T[10]`
3. Can't call `instanceof T` because of Type Erasure
4. Can't use primitive type with generics, instead we use wrapper classes
5. Can't use `static` variable as generic type, because the type is linked to the instance of the class

```java
class MyClass<T>{
    static T foobar;     // compiler-error
}
```

### Generic Methods
```java
//if method is not obtaining from its owner class/interface, we can specify in definition using <>
<T> void bar(T n){ }
static <T> void foo(T m){ }
public <T, U> int demo(T a, U b){ }

//invoking a generic method explicitly; compile will figure out otherwise
// static methods
Box.<String>ship("package");
Box.<String[]>ship(args);

// instance methods
new Foo().<String>fun("A");
obj.<Integer>num(8);
```

```java
//if you declare a generic type on a method inside a generic class, it becomes independent of class's
class Foo<T>{
    <T> void bar(T t){  }
}

Foo<String> obj = new Foo<>();      // String
obj.bar(99);                        // Integer
```

### Generic Records
```java
public record Foo<T, U>(T name, U age){ }
```

### Bounding Generic Types
Limiting generic types to allow certain types only **as method parameters**.

```java
public <U extends Number> void inspect(U u){  }

// multpile bounds
<T extends C1 & C2 & C3>
```

**Wildcards**: Used with collections
```java
<?>               // unbounded
<? extends Class> // only those types which are subclasses of Class (upper bound) or Class itself
<? super Class>   // only those types which are superclasses of Class (lower bound) or Class itself
```
The `Class`  above can also refer to a Interface type. Also, `extends` is applicable for interface too here, meaning the same as `implements` in this context.

### Unbounded Wildcard
We can't cast `List<String>` to `List<Object>` since once its made a list of Objects, we can convert it to other subclass types also e.g. `List<Integer>`, `List<Dog>`, etc... So, Java doesn't allow such conversions and we can't use `List<Object>` as a common type.

We need to use `<?>` for all such cases where we need to accept "any" type.
```java
List<?> arr = new ArrayList<String>();
// we specified type as <String> otherwise <Object> would've been assigned by default so now we can only insert String into it
// also arr List will be logically immutable! (see below sections)

// a more practical example would be: 
public static void printList(List<?> list) {        // use with List<> type
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
List<? extends Foobar>      // we can pass any class/interface that extends Foobar, implements Foobar or Foobar ref variable itself
```

### Lower-bounded Wildcard
```java
List<? super Foobar>      // we can pass any class/interface that is parent of Foobar, gets implemented by Foobar, or Foobar ref variable itself
```

Since this gives us mutable lists, tricky things can happen here when inserting superclass and thier subclasses.
```java
3: List<? super IOException> exceptions = new ArrayList<Exception>();
4: exceptions.add(new Exception());    // compiler-error (tricky)
5: exceptions.add(new IOException());
6: exceptions.add(new FileNotFoundException());     // tricky

/*
Line 3 references a List that could be List<IOException> or List<Exception> or List<Object>.
Line 4 does not compile because we could have a List<IOException>, and an Exception object wouldn't fit in there.
Line 5 is fine. IOException can be added to any of those types.
Line 6 is also fine. FileNotFoundException can also be added to any of those three types. This is tricky because FileNotFoundException is a subclass of IOException, and the keyword says "super". Java says, "Well, FileNotFoundException also happens to be an IOException, so everything is fine".
*/
```

### Immutability when Bounding
**Unbounds `<?>` and Upper-bounds `<? extends Foobar>` make the list logically immutable, only removal of elements can be done**. This is applicable even when we call a method that has a bounded type in parameter, the List in called method will be immutable.
```java
List<?> list = new ArrayList<Integer>();
list.add(1);    // error

List<? extends Integer> list = new ArrayList<Integer>();
list.add(1);    // error

List<? super Integer> list = new ArrayList<Integer>();
list.add(1);    // valid; no error

void fooBar(List<?> ls){
    // List ls in immutable here because of unbound <?> type in parameter
}
```

This is a major reason to use Lower-bounds (`<? super Foobar>`) when any other two could've worked just the same, but with the immutability issue.

**Reason**: When we use `<?>` or `<? extends Foobar>`, we don't know the types that can be added to such list, it can literally be any subclass of `Foobar` even the ones which are not yet created. So Java doesn't allow adding more or changing existing elements. 

In contrast, when we use `<? super Foobar>` we can be assured that whatever type is passed to it, it will be one of `Foobar`'s superclasses only, which trivially exists already.


### Some Pitfalls
```java
// use type bounds only with methods, not collections
public <T> void foobar(List<T extends Main> list) {  }
// invalid; generic type bound used for collection's type 


// use wildcards only with collections, not as bound method types
public <T> <? extends Main> foobar(T t) {  }
// invalid; wildcard used as method's return type


// valid examples
public <T extends Main> void foobar(List<T> list) {  }
public void foobar(List<? extends Main> list) {  }
```