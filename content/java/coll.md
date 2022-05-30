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

### Creating Lists with Factory Methods
```txt
Arrays.asList(varargs)	 // can only update existing elements, not add or remove additional
List.of(varargs)		 // purely immutable
List.copyOf(collection)	 // purely immutable
```
### Creating Lists with Constructor
```java
List<Integer> listArr = new ArrayList<>();				//empty list, size = 0
List<Integer> listArr2 = new ArrayList<>(anotherList);
List<Integer> listArr3 = new ArrayList<>(10);			//empty list, size = 10
```

### var with List
```java
var listArr = new ArrayList<>();		// counter-intuitive but it works and assumes type to be Object; bad practice
```

### List Methods
```java
add(Element)        // add at end
add(index, Element) // add at index and move others towards end
set(index, Element) // replace at index
get(index)
remove(index)

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

// 1. automatically detect size and copy list into a new array; an array of Object type is created
// 2. specifies size and type of the array to be made, if List fits then fine, otherwise also fine
```

## Set
Doesn't allow duplicate entries. Unordered.

**HashSet** --> uses Hashtable

**TreeSet** --> uses sorted tree structure (BST)

### Creating Sets
```java
Set<Integer> set = new HashSet<>();

// Factory Methods
Set.of(varargs)
Set.copyOf(collection)
```

## Queue and Deque
Use `ArrayDeque` if you don't need List methods. We often use queues as a stack so we have push/pop methods available too in all implementations of Queue.

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

## Sorting Data

### Comparable
A functional interface from `java.lang.Comparable`. Uses `compareTo()` method, takes 1 argument and returns an `int`.

### Comparator
Also, a functional interface from from `java.util.Comparator`. Uses `compare()` method, takes 2 arguments and returns `int`.

### Collection.sort()
It can use both `Comparable` as well as `Comparator`. 

While `Comparable` is usually implemented within the class being compared, and `Comparator` is usually implemented using lambda expression.

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
// Overriding is allowed with covariant return types
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
5. Can't use static vaiable as generic type, because the type is linked to the instance of the class

### Generic Methods
```java
//if method is not obtaining from its owner class/interface, we can specify in definition using <>
static <T> void foo(T m){ }
<T> void bar(T n){ }

//invoking a generic method explicitly; compile will figure out otherwise
Box.<String>ship("package");
Box.<String[]>ship(args);
```

```java
//if you declare a generic type on a method inside a generic class, it is independent of class's
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
Bounding generic types to certain types only.
```java
List<?> // unbounded
List<? extends Class> // only those types which are subclasses of Class (upper bound)
List<? super Class>   // only those types which are superclasses of Class (lower bound)
```

We can't cast `List<String>` to `List<Object>` since once its made a list of Objects, we can put other also in that list e.g. `Integer`, `Dog`, etc... So that conversion in data structures like List is not allowed.


**var vs. wildcard(?)**:
```java
List<?> arr1 = new ArrayList<>();    // a List type reference
var arr2 = new ArrayList<>();        // an ArrayList type reference
```