+++
title = "Concurrency"
date =  2022-06-01T09:38:00+05:30
weight = 12
+++

**Thread**: Smallest unit of execution that can be scheduled to the CPU.

Max number of threads that can run parallely = Number of CPU cores

**Process**: Group of associated threads. It comprises of multiple threads and a shared memory. Single unit of functionality. A program in execution.

**Task**: Single unit of work performed by a thread.

**Concurrency**: Multiple tasks being executed at the same time. The CPU time is divided between each via **Scheduling**. (Not to be confused with Parallel processing)

**Context switch**: Storing state of a thread and later restoring it. Lesser the total context switches, the better.

Analogy - Google Chrome browser is a process, each Tab is a thread and context switching occurs when we switch tabs.

**Thread priority**: It is a number associated with a thread that the scheduler uses to schedule. In Java, it can be either of these three integer values - `MIN_PRIORITY` (1), `NORM_PRIORITY` (5), `MAX_PRIORITY` (10).

## Thread class
Tasks are defined using the `Runnable` functional interface, it takes no arguments and returns nothing. To create a thread use `Thread` class instance. 

```java
Runnable t = () -> System.out.println("Hello");			// any returned value from a Runnable is ignored
new Thread(t).start();
System.out.println("World");

// the order of execution upon creation of a thread on line 1 depends upon the scheduler and can't be predicted beforehand
// can print "HelloWorld" or "WorldHello" because there are two threads - the one we created and one having main()

// start() creates a separate call stack for the thread execution
// calling start() implicitly calls run()
// Also if we use run() on line 2 above, it won't start a new thread and moreover it will just execute task in a non-concurrent synchronous way in main() thread only printing "HelloWorld"

// calling start() twice on same thread throws IllegalStateException, but we can call run() multiple times
```

Threads always proceed **_asynchronously_** with each other. Demonstrated in below example.
```java
new Thread(()->{ for(int i=0;i<5;i++){
		System.out.println(i);
}}).start();
new Thread(()->{
	System.out.println("A");
	System.out.println("B");
	System.out.println("C");
	System.out.println("D");
}).start();

// 3 threads - main() and 2 new threads we created
// output unkown until runtime, one possible outcome is:
/*
1
A
2
3
B
C
4
D
*/
```

```java
// use t.join() to stop the current thread and wait for thread "t" to finish

Runnable task = () -> System.out.println("Hello");
Thread thread = new Thread(task);
thread.start();

thread.join();

System.out.println("World");

// output:
/* 
Hello
World
*/
```

Two ways to create a thread - 
1. provide a `Runnable` reference or lambda to `Thread` class constructor (_common_)
2. create a subclass from `Thread` and override `run()` method (things to do in thread goes in it)

The `Thread` class implements `Runnable` interface.

### Thread Types

**System threads**: Created by JVM. Like garbage collection.

**User-defined threads**: Created by the programmer.

They both can be created as **daemon threads** which doesn't prevent JVM from exiting when the program finishes. Ex - Garbage collection is a daemon thread and JVM can exit even if its running.

```java
var job = new Thread(() -> foobar());
job.setDaemon(true);		// create as daemon thread
job.start();				// we won't wait until foobar() finishes, we will exit once main() finishes
```

### Thread Lifeycle
![thread life cycle diagram](https://i.imgur.com/xLf6N9c.png)

### Sleep and Interrupt
```java
var job = new Thread(() -> taskMethod());

job.getState();			// prints thread state (RUNNABLE, WAITING, etc...)

Thread.sleep(1_000);	// sleeps for 1 sec, resumes thread execution upon timeout
// any other thread can interrupt a sleeping thread, in that case InterruptedException is thrown
// also, an already interrupted thread (isInterrupted() = true) can't sleep (throws InterruptedException)

var t2 = Thread.currentThread();	// get instance of current thread
t2.interrupt();			// used to throw InterruptedException in a sleeping thread

// calling interrupt() on a RUNNABLE thread (either self or from another thread) doesn't change its state (no halts or exceptions) but changes value on:
t2.isInterrupted();     // returns true
```
Interrupting a running (`RUNNABLE`) thread with `interrupt()`:
```java
class Test extends Thread {
    @Override
    public void run() {
        System.out.println("A");
        var t = Thread.currentThread();
        System.out.println(t.isInterrupted());
        t.interrupt();		// self-interruption
        System.out.println("B");
        System.out.println(t.isInterrupted());
        System.out.println("C");
    }
}

public class Main {
    public static void main(String[] args) {
        var t = new Test();
        t.start();
        System.out.println("Z");
        System.out.println("Y");
        System.out.println("X");
    }
}

/*
Z
Y
X
A
false
B
true
C
*/
```

Interrupting a sleeping thread (`TIMED_WAITING`) with `interrupt()`:
```java
class Test extends Thread {
    @Override
    public void run() {
        System.out.println("A");

        var t = Thread.currentThread();
        try {
            Thread.sleep(5000);		// 5 sec
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println("B");
        System.out.println("C");
    }
}

public class Main {
    public static void main(String[] args) {
        var t = new Test();
        t.start();
        t.interrupt();		// called immediately after thread start (< 5 sec)
        System.out.println("Z");
        System.out.println("Y");
        System.out.println("X");
    }
}

// InterruptedException is thrown
```

## Concurrency API
`java.util.concurrent` package is the concurrency API. It provides higher level abstractions, rather than working with threads directly.

We use `ExecutorService` inteface to create and manange threads.

It also provides a `Executors` factory class.

```java
ExecutorService service = Executors.newSingleThreadExecutor();
try{
	service.execute(t1);	// t1, t2, and t3 are Runnable types (tasks)
	service.execute(t2);
	service.execute(t3);
}
finally{
	service.shutdown();
}

// this only creates two threads - one main() and one new thread. The intra-thread tasks are guaranteed to be executed sequentially in the order of submission and won't interfere with each other as was shown in the example at the beginning with Thread class.
``` 

The `shutdown()` method is of significance because `SingleThreadExecutor` is a _non-daemon_ thread so our program will never terminate if it is not closed. After a call to `shutdown()` the service won't accept any new tasks and if added will throw `RejectedExecutionException`. The service is terminated after all existing tasks have finished.

The compiler won't throw any exception when we don't add a `shutdown()`, but in that case our program will never terminate. So, always remember to call `shutdown()`. It is the reason we put it in a `finally` block, so that it always executes.

Do note that the service won't stop executing already added tasks upon a `shutdown()` call. To do so we can call `shutdownNow()` method but nothing is guranteed. 

![executor service life cycle](https://i.imgur.com/3mJJcJb.png)


Also, `ExecutorService` interface doesn't extend `AutoCloseable` so we can't use try-with-resources with it.

We can also await termination after a shutdown call and check on termination status.
```java
try{
	service.execute(t1);
}
finally{
	service.shutdown();
}

service.awaitTermination(1, TimeUnit.MINUTES);
if(service.isTerminated()){
	System.out.println("Done!");
}
else{
	System.out.println("Not completed yet!");
}
```

### Submitting Tasks
The `submit()` is preferred over `execute()` because it is compatile with both `Runnable` and `Callable` and it returns a `Future<?>` reference with which we can track the result.

```java
Future<?> result = service.submit(t1);		// Future ref's formal type is whatever type t1 returns

// instance methods of Future<>
result.isDone()						// returns true if completed, exception or cancelled 
result.isCancelled()				// returns true if cancelled
result.cancel()						// attempts to cancel and returns true if successfully cancelled
result.get()						// get result or wait endlessly
result.get(10, TimeUnit.SECONDS)	// get result or wait for specified time, throw TimeoutException upon timeout
```

### Callable
It is preferred over `Runnable` because its `call()` method can return a value and can throw a checked exception. We often use `Callable` type with `submit()` and this leads to clean code.

The `submit()` method can also take `Runnable` but calling `get()` on it will always return `null` since return type of Runnable's `run()` returns `void`.

```java
Future<Integer> result = service.submit(() -> 30 + 11);
System.out.println(result.get()); 	// 41

// todo the above with Runnable and execute() will be too complex as we will need a common variable and polling with sleep or an interrupt. 
```

### Scheduling Tasks
`ScheduledExecutorService` is a sub-interface of `ExecutorService`. The schedule methods in this return `ScheduledFuture` reference which is similar to `Future` and additionally has a `getDelay()` method to return remaining delay.
```java
ScheduledExecutorService service = Executors.newSingleThreadScheduledExecutor();

Runnable task1 = () -> System.out.println("Hello Zoo");
Callable<String> task2 = () -> "Monkey";
ScheduledFuture<?> r1 = service.schedule(task1, 10, TimeUnit.SECONDS);
ScheduledFuture<?> r2 = service.schedule(task2, 8, TimeUnit.MINUTES);

// The first task is scheduled 10 seconds in the future, whereas the second task is scheduled 8 minutes in the future
// if service is shutdown before they actually get to execute, then they will be discarded

service.scheduleAtFixedRate(task, 5, 1, TimeUnit.MINUTES);	
// submits task after initial delay of 5 mins, and keeps submitting after 1 min intervals regardless of previous task finished
// be careful as the tasks can pile up if period is less than execution time of the task

service.scheduleWithFixedDelay(task1, 0, 2, TimeUnit.MINUTES);
// the 2 min delay is after the finish of the previous task unlike above method
```

### Pools
Pools have pre-instantiated threads ready to run tasks. The difference between single thread executor and pools is that pools can execute multiple threads concurrently and if entire pool threads are occupied, the executor waits for threads to become available.
```java
ExecutorService 
newSingleThreadExecutor()

ScheduledExecutorService 
newSingleThreadScheduledExecutor()

ExecutorService 
newCachedThreadPool()
/* Creates thread pool that creates new threads as 
needed but reuses previously constructed threads 
when they are available. */

ExecutorService 
newFixedThreadPool(int)
/* Creates thread pool that reuses fixed number of 
threads operating off shared unbounded queue. */

ScheduledExecutorService 
newScheduledThreadPool(int)
/* Creates thread pool that can schedule commands 
to run after given delay or execute periodically. */
```

## Thread-safe Code
A lot of times threads may share a common variable that they read from or write to during parallel executions.

Consider a `++variable` operation runnning in multiple threads concurrently and on the same variable.
```java
int x = 0;
public void incrementX(){
	Syste.out.println(++x);
}

ExecutorService service = Executors.newFixedThreadPool(20);
for(int i = 0; i < 10; i++){
	service.submit(() -> incrementX());
}

// can print in any order; even duplicates, because 10 threads will access x and overwrites will happen
```

### Volatile
Declaring the variable as `volatile` indicates not to store the value in that thread's own cache but on a shared cache accessible by all threads. But it won't make the code thread-safe because our individual read/write are a thread-safe, but `++x` is actually two opertions `x = x + 1` (add and assign) and it may happen that thread1 writes to `x` and thread2 reads from `x` and then thread1 writes to `x`.

```java
volatile int x = 0;
```

### Atomic Classes
Atomic classes provided by Java makes sure that an atomic instance is accessed only by a single thread at a given time and all operations are atomic i.e. executed as a single unbreakable unit.

```java
AtomicInteger x = new AtomicInteger(0);
x.incrementAndGet();	// equivalent to ++x

// other methods
x.set(9);	// assignment
x.getAndIncrement();	// x++
```

Now, our code will output numbers from 0 to 10 with no duplicates but they may or may not be in order. Because operations are atomic now but we haven't specified any order of execution (incrementing variable x) among threads. A thread that outputs `9` can print after a thread that prints `10`.

### synchronized Blocks

**Monitor**: also called a **Lock** or **Mutex** is a structure that supports _mutual exclusion_, a property that atmost one thread can be executing a code block at a given time.

Objects can be used as a lock in Java in `synchronized` blocks. All threads must be accessing the same Object and _which object it is doesn't even matter as long its the same Object, preferrably `final` so it doesn't change values as we use it for sync_.

```java
// on an Object - block
synchronized(this) {  }

// on method
synchronized void foobar() {  }

-----------------------------------

// in static method
synchronized(Foobar.class) {  }		 // since we can't use "this" object here

// on static method
static synchronized void foobar() {  }
```

When a thread arives at the block, it checks the lock status. If the lock isn't available, the thread will transition to a `BLOCKED` state and waits in queue otherwise it "acquires the lock" and enters the code block.

This will print numbers from 0 to 10 in order without duplicates.

### Lock Framework & Semaphores
Syncs on a `Lock` interface object instead of any Object. We have to release lock manually with `unlock()` or else other threads keep on waiting forever. A thread can acquire a lock multiple times (re-entry) but it itself must release it the same number of times (_hold count_) as other threads can't release a lock acquired by a thread.

```java
Lock lock = new ReentrantLock();
try{
	lock.lock();		// waits/blocks indefinitely if other thread has lock
	// code
}
finally{
	lock.unlock();
}

// above code in synchronized block
Object obj = new Object();
synchronized(obj){
	// code
}
```
```java
// constructor of ReentrantLock
Lock lock = new ReentrantLock(true);		// fairness property

// true - grant lock in order it was requested
// false - default no-arg call
```

```java
// attempting to unlock a lock which was never acquired leads to
IllegalMonitorStateException
```

If we attempt to `lock()`, but it is already acquired by any other thread, then `lock()` will keep on waiting indefinitely for the lock to become available to it.

`tryLock()` returns a `boolean` indicating the status of lock and `tryLock(long, TimeUnit)` will attempt to lock at specified intervals each time returning a `boolean`. Also, both of them are non-blocking unlike `lock()` and return a `boolean` immediately instead of waiting indefinitely.

```java
// code demo
public static void printHello(Lock lock) {
    try {
 	  lock.lock();
 	  System.out.println("Hello");
    } 
    finally {
 	  lock.unlock();
    } 
}

public static void main(String[] args) {
	Lock lock = new ReentrantLock();
	new Thread(() -> printHello(lock)).start();		// sending lock to be acquired by a thread
	if(lock.tryLock()) {							// tryLock() attempting to lock to Main thread
 		try {
 			System.out.println("Lock obtained, entering protected code");
 		} 
 		finally {
 			lock.unlock();
 		}
	} else {
 		System.out.println("Unable to acquire lock, doing something else");
	}
}
```
**NOTE**: Release a lock the same number of times it is acquired by the same thread. Otherwise, the remaining locks will still hold onto the thread.

**Semaphore**: signaling mechanisms for restricting access to a single resource, maintains a set of permits, they permit fixed number of multiple threads to enter critical section, no thread "owns" a semaphore, only count is tracked in the semaphore and enforced. Not re-entrant.

Semaphore can be released from outside the thread they are acquired by (unlike Lock). They limit the number of concurrent threads accessing a specific resource (like a funnel).

```java
// a counting semaphore
Semaphore smp = new Semaphore(3);       
// permits 3 threads to acquire it simultaneously; others get blocked in a queue

public static void printHello(Semaphore smp) {
    try {
        smp.acquire();
        // code
    } 
    finally {
        smp.release();
    } 
}
```

**Binary Semaphore**: `new Semaphore(1)` is a semaphore that has only two states: `1` permit available or `0` permits available. 

They can be used as mutex in place of Lock, but they are not re-entrant, so the same thread can't re-acquire a critical section, if it tries to then deadlock happens. Deadlock recovery is fast though because semaphore can be released by a thread other than the owner in case of a deadlock.

### CyclicBarrier
Orchestrating tasks, specifies the number of threads to wait for and once the number is reached, execution is resumed on all of the threads that the barrier was "holding".

```java
var c1 = new CyclicBarrier(5);

// in code executed by multiple threads
c1.await()

// keeps waiting until 5 threads are in waiting status, then resumes on all

// throws
InterruptedException
BrokenBarrierException

// if we have 15 threads and barrier size is 5 then -
// await 5 threads and break barrier
// await next 5 and break barrier
// await next 5 and break barrier
// so its called three times, and everytime threads resume in set of 5
```

## Concurrent Collections
Threads must have a consistent view of a collection at all times.

Even if used in a single thread, we can have `ConcurrentModificationException` at runtime when trying to access a non-concurrent collection. So when dealing with threads, always use concurrent collections.

```java
Map<String, String> mp = new HashMap<>();

Map<String, String> cmp = new ConcurrentHashMap<>();

Collections.synchronizedMap(mp);

// or make it immutable
Collections.unmodifiableMap(mp);
```

If we have to create a collection, we use concurrent version of collections available. If we have a non-conurrent collection then we can use synchronized methods from `Collections` class to make them compatible to threads using synchronized methods that exists for most collections.

Immutable collections are immune to memory inconsistency errors trivially.

Any concurrent collection with `Skip` in the name is sorted. `CopyOnWrite` concurrent collections are deeply copied everytime on add/remove/change and assign to original reference.

## Threading Problems
Liveness is the ability of an application to execute in a timely manner. If it becomes unresponsive for long and or keeps entering "stuck" state repeatedly, liveness is affected. Threads can enter `WAITING` or `BLOCKED` state and cause liveness issue.

Majorly 3 kinds of liveness affecting issues arise: **Deadlock**, **Starvation**, and **Livelock**.

1. **Deadlock**: Two or more threads being blocked forever, each one waiting for other to release resources.
2. **Starvation**: One thread perpetually keeps waiting for a resource to become available.
3. **Livelock**: A special kind of deadlock in which threads appear to be live and working actively on their respective tasks, but they are just working while waiting for a resource to become available and are in a deadlock.

**Race condition**: When a resouce is modified by two threads at the exact same time. The application has to decide which modification to keep or discard both. It often leads to invalid data when it occurs.

## Parallel Streams

**Serial streams**: Data is processed in a serial fashion one after the other.

**Parallel streams**: Multiple parallel threads can process data concurrently. The number of threads available are common for all streams in the program and come from a Fork-Join Thread Pool.

As with threads, the order of operations is never guaranteed in parallel streams.

```java
// making a Stream parallel
collection.stream().parallel();
collection.parallelStream();

// checking if a stream is parallel
stream.isParallel();
```

### Unordered Method
When we apply methods which are **order dependent** (`findFirst()`, `limit()`, `skip()`) on parallel stream, we do get what we expect just like in serial stream but performance is hampered since stream is forced by Java to be synchronized-like. 

Solution - use `unordered()` to declare stream as unordered, and avoid force conversion of parallel to serial when such methods are applied.
```java
stream.unordered();
```

Calling `unordered()` (intermediate operation) on serial stream has no effect, but when the stream is made parallel we will have `skip(5)` skipping any 5 random elements and not the first five.


### Parallel Stream is Dangerous
All parallel streams in a program use a common Fork-Join Thread Pool, and if you run a long-running task in the stream, you're effectively blocking multiple threads in the pool. Consequently, you may end up blocking all other tasks in the program that are unrelated but are using parallel streams if all ForkJoinPool threads become busy!

```java
List<StockInfo> getStockInfo(Stream<String> companies) {
    return companies.parallel()
        .map(this::getStockInfo)        // slow operation; calls method on every element
        .collect(Collectors.toList());
}

// this hangs (blocks) every other method in execution using parallel streams if another thread isn't available in the pool
// not only "companies" stream, but any parallel stream part of the code flow!
```

Number of threads in ForkJoinPool = Number of logical CPU cores - 1, it is a fixed sized pool and other tasks have to wait for threads to become available.

### Reductions in Parallel Streams
Make sure accumulator and combiner have the same output on every step regardless of the order in which they are called in. The accumulator and combiner must be associative, non-interfering, and stateless.

## Virtual Threads (Java 21)
Virtual threads are lightweight threads that can be used in high-throughput concurrent applications.

Uptil now a thread was an instance of `java.lang.Thread` and was called a **Platform Thread** in Java. It maps to the underlying OS thread for its whole lifetime and contains information in the order of megabytes. Consequently, the number of available platform threads is limited to the number of OS threads in a _thread-per-request_ style server environment.

A **Virtual Thread** is also an instance of `java.lang.Thread`, but it isn't _tied_ to a specific OS thread. A virtual thread still runs code on an OS thread. However, when code running in a virtual thread calls a blocking I/O operation, the Java runtime suspends the virtual thread until it can be resumed. The OS thread associated with the suspended virtual thread is now free to perform operations for other virtual threads.

When a virtual thread is blocked, its data is stored (_unmounted_) on the heap temporarily, until it goes back into execution on the _carrier thread_.

They have much smaller memory footprint than a platform thread, thus a single JVM might support millions of virtual threads.

```java
Runnable task = () -> System.out.println("Hello");

// using Thread class
Thread virtualThread = Thread.startVirtualThread(task);

// another way
Thread thread = Thread.ofVirtual().unstarted(task);
thread.start();


// using concurreny API
ExecutorService service = Executors.newVirtualThreadPerTaskExecutor();
// creates new virtual thread for each submitted task


thread.isVirtual();      // tells if the thread is virtual
```

Virtual Threads have these _fixed_ properties:
- they have `NORM_PRIORITY` (5)
- they are daemon threads

Virtual threads are useful when the number of concurrent tasks is large, and the tasks mostly block on network I/O. They offer no benefit for CPU-intensive tasks. Since CPU cores will be busy doing the intensive task and will block the core for everyone (other virtual threads can't use it meanwhile) unlike Network I/O blocks.

**Benefit of using Virtual Threads**: Instead of writing non-blocking, asynchronous style code with `CompletableFutures` we can write "normal" synchronous style code that uses blocking I/O. Virtual Threads will make sure that blocking I/O on a thread doesn't hog resources. When a thread is ready to be resumed (wait over) it is resumed instantly without the need of specifying any callbacks.

References:
- https://inside.java/2023/10/30/sip086/
- https://dev.java/learn/new-features/virtual-threads/
- https://docs.oracle.com/en/java/javase/21/core/virtual-threads.html
- https://davidvlijmincx.com/posts/java-virtual-threads/

## Async Processing - CompletableFuture
CompletableFuture is a framework to execute code asynchronously and return a `Future<T>` reference. It also uses `ForkJoinPool` just like streams.

`class CompletableFuture<T> implements Future<T>` so we can store output of function in CompletableFuture too as shown in the examples below:
```java
// perform a computation async - takes in a Supplier
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> "Hello");
// get value from future instance
future.get();


// to process the result of a computation - feed it to a function or consumer - chaining

// feed result of async computation into a Function
CompletableFuture<String> future = completableFuture.thenApply(s -> s + " World");
future.get();

// feed to a Consumer and it returns a Void placeholder type 
CompletableFuture<Void> future = completableFuture.thenAccept(s -> System.out.println("Computation returned: " + s));
future.get();

// nothing to feed, nothing to get back; print a line in the console on future.get() call 
CompletableFuture<Void> future = completableFuture.thenRun(() -> System.out.println("Computation finished."));
future.get();
```

Reference: 
- https://www.baeldung.com/java-completablefuture
- https://davidvlijmincx.com/posts/java-virtual-threads/
