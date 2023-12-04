+++
title = "Misc Topics"
date =  2022-11-28T22:02:00+05:30
weight = 15
+++

Shallow Copy (_reference variables_), Deep Copy (_copying data to new object manually_), Cloning (_copying data to new object with clone() method_) `newObj = oldObj.clone()`

**Marker Interfaces**: Interfaces that have no methods and constants defined in them. They are there for helping the compiler and JVM to get run time-related information regarding the objects. Ex - `Serializable` interface.

`>>` vs `>>>` operator: [_link_](https://www.interviewbit.com/java-interview-questions/#difference-between-and-operators-in-java)


Double-brace initialization:
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

**Singleton Class**: Only one instance can exist of this class
```java
class TestSingle{
   private int value = 999;		// private properties
   private Test obj;			// self-reference to the only instance
   private TestSingle(){}		// private constructor
   
   // getter
   public int getValue(){
       return this.value;
   }

   // return the object to the user; since we can't use Constructor
   public static TestSingle getInstance(){
       
       // create a new object if the object is not already created and return the object
       if(obj == null){
           obj = new Test();
       }

       return obj;
   }
}
``` 

Double-checked locking in Singleton: to make sure that only one instance of a class exists across all threads too, put the instance existance checker logic in a `synchronized` block
```java
private static volatile Singleton obj;

public static Singleton getInstance(){ 
    // Single Checked
    if (obj == null) {
        
        // Double Checked
        synchronized (Singleton.class){
            if (obj == null) {
                obj = new Singleton();
            }
        }
    }

    return obj;
}
```

Use Object as a Key in HashMap or HashSet - `equals()` and `hashCode()` should be properly defined for that object

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

**Serializable vs Externalizable Interfaces**: a class extending `Serializable` interface can be serialized/deserialized to/from `ObjectInputStream`/`ObjectOutputStream`. It is a Marker Interface so it doesn't have any methods.

`Externalizable` is a sub-interface of `Serializable` and also used for the same purpose. It has two additional methods where we can specify our custom logic after/before serialization/deserialization.

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Book implements Externalizable {
    private String author;
    private String title;
    private int price;

    @Override
    public void writeExternal(ObjectOutputStream out) throws IOException {
        out.writeObject(author);
        out.writeObject(title);
        out.writeInt(price);
    }

    @Override
    public void readExternal(ObjectInputStream in) throws IOException, ClassNotFoundException {
        this.author = (String) in.readObject();
        this.title = (String) in.readObject();
        this.price = in.readInt();
    }
}
```

Link: https://www.java67.com/2012/10/difference-between-serializable-vs-externalizable-interface.html


`Objects` utility class has static methods to check not null etc... Ex - `Objects.nonNull(myObj)`.

**Diamond Operator**: `<>` optional to provide any type information, still need to be used as a placeholder. Ex - `List<String> list = new ArrayList<>()`

**Utility Class**: Java provides many utility classes that are `final`, can't be instantiated (`private` constructor), and contains only `static` methods that often take in an instance. Ex - `Files`, `Executors`, `Objects`, etc...