+++
title = "Misc Topics"
date =  2022-11-28T22:02:00+05:30
weight = 15
+++

## Misc Points

Shallow Copy (_reference variables_), Deep Copy (_copying data to new object manually_), Cloning (_copying data to new object with clone() method_) `newObj = oldObj.clone()`

Cloning can be customized overriding the `clone()` method of the `Object` class, and indicating by implementing `Cloneable` marker interface.

**Marker Interfaces**: Interfaces that have no methods and constants defined in them. They are there for helping the compiler and JVM to get run time-related information regarding the objects. Ex - `Serializable`, `Cloneable` interface.

`>>` vs `>>>` operator: [_link_](https://www.interviewbit.com/java-interview-questions/#difference-between-and-operators-in-java)

**Double-Brace Initialization**:
```java
Set<String> countries = new HashSet<String>() {
        {
           add("India");
           add("USSR");
           add("USA");
        }
};

// define Anonymous Class
// run code inside Instance Initializer Block
```

String's length() isn't accurate - counts code points rather than no. of chars, code points can be more than one for characters like an emoji since its UTF-16. [_link_](https://www.interviewbit.com/java-interview-questions/#why-is-string-length-not-accurate)

3 GC scenarios: reference becomes null, reference points to some other object, Island of Isolation

**Island of Isolation**: The way Mark & Sweep algorithm work is that it starts the scan from the GC root (`main()` method) and follows all references. Everything that is marked (reachable) is not removed, everything else is sweeped (removed).

```java
public class Test {
   Test ib;    
   public static void main(String [] str){
       Test t1 = new Test();
       Test t2 = new Test();
       t1.ib = t2; 	// t1 points to t2
       t2.ib = t1; 	// t2 points to t1
       t1 = null;
       t2 = null;
       
       /* 
       * t1 and t2 objects refer to each other 
       * but have no references from GC root
       * these 2 objects form an Island of Isolation and are eligible for GC
       */
   }
}
```

`wait()` and `notify()` mechanism in Thread: call wait() on a object in multiple threads to make then all wait, we can then call notify() from another class to wake up any 1 arbitrary thread waiting, use `notifyAll()` to wake up all threads. Mandatory condition is that the object on which we are synchronizing must be the same object on which we're calling the wait and notify methods. [_reference_](https://www.oreilly.com/library/view/java-threads-second/1565924185/ch04s02.html)

```java
Mon object = new Mon();

// in waiting class
synchronized(object){ 
    object.wait();
}

// in notifying class
synchronized(object){
    object.notify();
}
```

`wait()` vs `sleep()`: sleep makes thread `TIMED_WAIT` that gets over after timeout (thread doesn't release lock), wait makes thread lose its ownership (releases lock), state as `BLOCKED` and must be notified from outside using notify or notifyAll method using the same object as a monitor for sync block.

String being immutable is a:
- security measure: an SQL query stored as String can't be modified in transit (prevents SQL injections)
- security risk: as the object will remain in heap before it is garbage collected by JVM (we don't control its lifetime).
Use `char[]` to store passwords and manual erasure of each element is possible (as opposed to String as they are immutable) as soon as its work is done.

`Objects` utility class has static methods to check not null etc... Ex - `Objects.nonNull(myObj)`.

**Diamond Operator**: `<>` optional to provide any type information, still need to be used as a placeholder. Ex - `List<String> list = new ArrayList<>()`

**Utility Class**: Java provides many utility classes that are `final`, can't be instantiated (`private` constructor), and contains only `static` methods that often take in an instance. Ex - `Files`, `Executors`, `Objects`, etc...

**Iterator vs ListIterator**: `ListIterator` is a more specific interface of the `Iterator` interface i.e. `public interface ListIterator<E> extends Iterator<E>`. It can traverse in forward (`it.next()`) as well as backward direction (`it.previous()`) and can also add or update elements of the underlying data structure unlike the generic `Iterator`.
```java
List<Integer> list = new ArrayList<>();

ListIterator<Integer> it = list.listIterator();

it.next();
it.previous();
it.add(1);
it.set(2);
```

They are only available to use for `List` interface and its impl classes like `ArrayList`, `LinkedList`, `Vector`, and `Stack` (last two are legacy).

**Fail-fast vs Fail-safe Iterators**: `Iterator` on FF on classic collections, and on thread-safe collections (`CopyOnWriteList`, `ConcurrentHashMap`, etc) they are FS. [notes link](/java/coll/#iterator)

**What is Load Factor?** It is the threshold at which a data structure (collection) is resized to accomodate for future incoming data. Default is `0.75` which means that when 75% of the current size is populated, the collection will be resized to a bigger one.

**Can `null` element be added to a collection?** only one `null` can be added to `HashMap` and `HashSet`. For all the other non-major collections, it depends. Ex - it can't be added to `TreeSet` (as a `Comparator` is required here) but allowed in `LinkedHashSet`.

## Top Interview Questions on Collections Internals

### Importance of hashCode() and equals()
**equals() and hashCode() contract**: Two objects that return true for `equals()` must also have the same `hashCode()` value. Hence if we override one, we must override the other too.

Typically, if they are not overriden with custom impl, `equals()` calc based on the memory address of the instance in the heap, and `hashCode()` calc based on the memory address too. We often need to override and provide custom impl for these methods based entirely on instance members and not its memory address.

In the below code, identical objects are considered diff incorrectly since default `hashCode()` isn't overriden and its inherited from `java.lang.Object` class:

```java
Set<Student> set = new HashSet<>();

set.add(new Student(1, "A"));
set.add(new Student(1, "A"));

System.out.println(set.size());     // 2
```

Override default impl of the `hashCode()` method of `Student` class based on its contents.

```java
// Ex - overriding for Student class
@Override
public boolean equals(Object obj){
    if(this == obj){
        return true;
    }

    Student studentObj = (Student) obj;     // explicit cast (Object to Student)

    if(this.id == studentObj.id && this.name.equals(studentObj.name)){
        return true;
    }

    return false;
}

@Override
public int hashCode(){
    return Objects.hash(this.id, this.name);    // utility class; varargs and handles null implicitly
}
```

`Objects.hash()` utility class static method uses a variant of the well-known hash function called "MurmurHash" and produces variable length integral numbers as output hash.

Do note that they are properly overriden on Wrapper classes as well as core classes like `String` (compare contents rather than memory address).

```java
Set<String> st = new HashSet<>();
st.add("ABC");
st.add("ABC");
System.out.println(st.size());     // 1
```

### HashMap
Underlying data structures are backing array of size `16` (buckets) and a linked list attached to each bucket cell. 

Equivalent of `unordered_map<>` in C++ which also uses hash table (array/buckets) internally.

Methods to manage elements are `hashCode()` and `equals()` that are present in every class (inherited from `java.lang.Object` class) and need to be overwritten for proper functioning of Map.

`HashMap` class's `put(k, v)` method:
```java
V put(K key, V value){
    int hash = hash(key);       // calc hash

    putVal(hash, key, value);   // puts data in linked list
}

int hash(K key){
    key.hashCode() % 16;      // same but using bitwise operation
}
```

A node in the attached backing linked lists of `HashMap`:
```txt
┌────────────────┬──────────────────┬─────────────────┬─────────────────┐
│    key         │       value      │      hash       │       next      │
└────────────────┴──────────────────┴─────────────────┴─────────────────┘
```

**put() operation**: There are bound to be hash collisions since the backing array is only of size `16`, whenever there is a non-zero sized LL present on the bucket we are hashed to, we check (linear search) if the key already exists by comparing `hash` value present in LL nodes and then verify again by comparing the key we're currently searching and `key` value from LL using `equals()` method and replace if they are equal otherwise attach new node to the end of linked list at that bucket. 

{{% notice note %}}
There can only be one `null` key in a HashMap and it is written to bucket indexed as `0`.
{{% /notice %}}

```java
Map<Integer, String> mp = new HashMap<>();
mp.put(null, "ABC");
System.out.println(mp.get(null));   // prints "ABC"
```

**get() operation**: we goto bucket and check for non-zero sized LL, if nodes are present linearly search them for `hash` value match and once found verify with using `equals()` on search key and LL nodes key.

Worst case TC for `get()` and `put()` operations = `O(n)`, considering every key hashes to the same bucket (unequally distributed hash function).

**Performance improvement of HashMap** (since Java 8): buckets are limited (only 16), collisions are more likely to occur with increasing map entries leading to poor performance. When a bucket's LL grows beyond a certain threshold, it switches from using LL (`O(n)` operations) to using a Balanced Tree (specifically, a Red-Black Tree) to maintain performance.

Note that `TreeMap` (ordered Maps) also use Red-Black Trees internally in Java.

### HashSet
It uses `HashMap` internally! Keys are the entities we want to put in the set and value is constant `PRESENT` (random instance of `Object` class) if the entity exists in the set.

`HashSet` class:
```java
static final Object PRESENT = new Object();

public HashSet() {
    map = new HashMap<>();
}

public boolean add(E e) {
    return map.put(e, PRESENT) == null;
}

public boolean remove(Object o) {
    return map.remove(o) == PRESENT;
}
```

**Immutability of Keys**: Keys are nothing but instances but they must be immutable if they're being put into a set. This is to avoid _miss_ (unable to find key) for instances that were added to the set previously and were modifed after the addition.

As a solution, we can add the modified instance again after modification and it will also be put into the set. But beware that if the instance has a `timestamp` member then we end up having a lot of copies of the same instance (_redundancy_) differing only by timestamp. 

### LinkedHashMap
It is just like a normal `HashMap` but **attaches nodes across buckets in a circular doubly-linked list fashion** using `before` and `after` links in LL node so that it can maintain ordering. It is not thread-safe.

There is a dummy `Head` node which is present in the impl of `LinkedHashMap` to ensure addition of Circular DLL nodes relative to it. A newly inserted or accessed node is inserted at the end of the list (`before` link of `Head` node). Conversely, the least recently used (LRU) element is at the beginning of the list, just `after` the `Head` node. This way it follows the fashion `... -> 1 -> 2 -> 3 -> Head -> 1 -> ...`

Ordering is preserved either by - **insertion order** or **access order**. Used to implement LRU cache when access ordering is enabled.

```java
public class LinkedhashMap extends HashMap implements Map { }

// constructors
LinkedhashMap();    // default; capacity = 16, LF = 0.75

LinkedhashMap(int capacity);    // LF = 0.75

LinkedhashMap(int capacity, float loadFactor, boolean accessOrder); // true = accessOrder; false = insertion order
```

If insertion order is followed, access (`get()`) won't lead to any structural modifications. But, on every access in a access ordered map, the links to nodes rearranges (to maintain LRU item's constant time access).

A node in the attached backing linked lists of `LinkedHashMap`:
```txt
┌──────────────┬──────────────┬──────────────┬─────────────┬──────────────┬──────────────┐
│      key     │     value    │     hash     │    next     │    before    │     after    │
└──────────────┴──────────────┴──────────────┴─────────────┴──────────────┴──────────────┘
```

The answer here makes the relatively low-complexity of `LinkedHashMap` over `HashMap` more clear - [link](https://stackoverflow.com/a/31700750).

Performance overhead is more than a normal HashMap due to links rearranging and a slightly more memory footprint because of the bigger DLL nodes.

### ConcurrentHashMap
Part of `java.util.concurrent` package.

Use this when thread-safety is required and changes to the underlying data structure shouldn't throw `ConcurrentModificationException`.

Features:
- **Fine-grained Locking**: only some segments are locked, not the whole map
- **Non-blocking Reads**: only writes acquire a lock, not reads

In a `Collections.syncronizedMap(mp)`, whole map is locked even for reads! It wraps all methods and code in sort-of `synchronized` method/block, but only a single thread can access the code at a given time, no matter which code - read or write.

### IdentityHashMap
It uses reference equality operator (`==`) on key search operations instead of `equals()` and uses the JVM provided identity hashcode of the object instead of generating hascode using the `hashCode()` method of the object. Hence we don't neccessarily need to override the `equals()` method for key objects to be put in the map since it won't be used to compare keys anyways.

Since it doesn't use the `equals()` and `hashCode()` methods, overriding them is optional and hence there is no gurantee that the `hashCode()` and `equals()` contract is satisfied for objects being put as key in an `IdentityHashMap`.

It doesn't face the mutable key problem as a key object's instance members can be modified after adding the object to the Map and it will still have the same memory address. Unlike `equals()` which changes based on object members.

`IdentityHashMap` isn't thread-safe but we can always use `Collections synchronizedMap(identityHashMap)` to make it sync.

```java
Map<String, String> identityHashMap = new IdentityHashMap<>();
identityHashMap.put(new String("foo"), "John");
identityHashMap.put(new String("bar"), "Doe");

identityHashMap.put(new String("foo"), "Alice");     // adding duplicate key

System.out.println(identityHashMap.size());         // 3; would've been 2 if any other HashMap type
```

**Usage**: it is used when we want to cache all objects (base uniqueness on their object reference), takes up a lot of storage but keeps record of all unique objects created in the system.

### CopyOnWriteList
No segment locking unlike `ConcurrentHashMap` but employs a diff strategy to achieve thread-safety. 

A copy of the list is created and modified on writes, it is then used to replace the original copy so that changes get reflected in the original. On a read, just read from the original as no locking is required as no concurrent modification is taking place on the original copy.

This has significant processing overhead and memory footprint compared to normal List implementations.