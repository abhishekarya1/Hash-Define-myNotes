+++
title = "Misc Topics"
date =  2022-11-28T22:02:00+05:30
weight = 14
+++

Shallow Copy, Deep Copy, Cloning

Thread Priority levels in JVM - `MIN_PRIORITY` (1), `NORM_PRIORITY` (5), `MAX_PRIORITY` (10)

**Marker Interfaces**: Interfaces that have no methods and constants defined in them. They are there for helping the compiler and JVM to get run time-related information regarding the objects. Ex - `Serializable`.

`>>` vs `>>>` operator: [_link_](https://www.interviewbit.com/java-interview-questions/#difference-between-and-operators-in-java)


Double-brace initialization: [_link_](https://www.interviewbit.com/java-interview-questions/#explain-double-brace-initialization-in-java)

String's length() isn't accurate - counts code points rather than no. of chars: [_link_](https://www.interviewbit.com/java-interview-questions/#why-is-string-length-not-accurate)

3 GC scenarios: ref null, ref to other object, Island of Isolation

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
       * t1 and t2 objects refer to only each other 
       * and have no references from GC root
       * these 2 objects form an Island of Isolcation and are eligible for GC
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

Double-checked locking in Singleton

Use Object as a Key in HashMap - `equals()` and `hashCode()`

`wait()` and `notify()` mechanism in Thread

`wait()` vs `sleep()`

String being immutable is a:
- security friendly: an SQL query stored as String can't be modified in transit (prevents SQL injections)
- security risk: as the object will remain in heap before it is garbage collected by JVM (we don't control its lifetime).
Use `char[]` to store passwords and manual erasure of each element is possible (as opposed to String as they are immutable) as soon as its work is done.
