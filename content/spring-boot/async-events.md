+++
title = "Async and Events"
date = 2024-07-04T11:29:00+05:30
weight = 20
+++

No additional dependencies are required for Async or Events functionality in Spring.

## Spring Async
**Async processing in Spring Boot**: use `@Async` annotation on methods and `@EnableAsync` on any one of the configuration classes. Spring Boot will run this method in a separate thread. Also, the method call must come from outside the class (same concept as the Transactional Spring Proxy Bean interception).

An `@Async` method can return `void`, `Future`, or `CompletableFuture` (which is a subtype of Future only).

```java
@Configuration
@EnableAsync
public class AsyncConfig {
    // configuration related to async processing can go here if needed
}

// Service class
@Service
public class AsyncService {

    @Async
    public CompletableFuture<String> performAsyncTask() throws InterruptedException {
        // simulate a long-running task
        Thread.sleep(5000);

        // return an already completed task with given value
        return CompletableFuture.completedFuture("Task Completed");
    }
}

// Controller class
@GetMapping("/async")
    public String executeAsync() throws InterruptedException, ExecutionException {
        CompletableFuture<String> future = asyncService.performAsyncTask();
        // you can do other tasks here
        // wait for the async task to complete and get the result
        return future.get();
    }
```

{{% notice note %}}
Note that there is no `CompletableFuture.supplyAsync()` or any other of its method being called that runs the logic inside it in a separate theread. Here, Spring runs the entire method body in a separate thread because of the `@Async` annotation and we've to return original return type `T` wrapped as `Future<T>` type.
{{% /notice %}}

We can also define our own executors (i.e. thread type and pool) for our Async method or at the class level too.

_Reference_: Spring Async Microservice - [YouTube](https://youtu.be/utMoWx1XcrE)

## Spring Events
For intra-app event driven communniication (sync as well as async) we can use events API provided in Spring.

We can use events to achieve **loose coupling** among service calls in the application:
```java
// pre-condition is that no dependency on task ordering must exist if we want to have async processing (ofc)

// 1. non-event-driven service method
void admitStudent(Student st){
	schoolService.assignAdmissionNumber(st);
	schoolService.assignClass(st);
	accountsService.processFee(st);
	transportService.assignBus(st);
}

// 2. event-driven service method
void admitStudent(Student st){
	applicationEventPublisher.publish(st);
}
```

1. Even if we make the service calls async, it will be faster and better than this, but the code will still be tightly coupled together inside the `admitStudent()` method.
2. But if we can trigger a single event when `admitStudent()` method is called and the rest of the services listen to that event, then we can have parallel processing on multiple threads (just like async if we use `@Async` on listeners (see info box below)) in separate services but the code will be much cleaner (_decoupled_) in that case.

**Steps to create, trigger, and listen to an event**:
- create an event object i.e a POJO class that extends `ApplicationEvent` and has fields that we want to send. Inheriting is optional but its a good practice.
- publish the event from any class using `ApplicationEventPublisher` object autowired inside it and pass field values to send.
- any class can be an event listener provided it has a method annotated with`@EventListener` and it acts as a handler for the event of that type. The method signature must declare the event type it consumes.

```java
// event class
class CreateStudentEvent extends ApplicationEvent{		// optional inheritance; provides additional functionality like source
	String name;
	int age;

	CreateStudentEvent(Object source, String name, int age){	// source is required to identify publisher of event later on
		super(source);
		this.name = name;
		this.age = age;
	}
}

// publisher class
@Autowired
ApplicationEventPublisher applicationEventPublisher; 

void createStudent(){
	applicationEventPublisher.publish(new CreateStudentEvent(this, "John", 20));
}

// listener class
class StudentHandler{

	@EventListener
	void createStudent(CreateStudentEvent event){
		System.out.println("Student " + cse.getName() + " received.");
	}
}
```

{{% notice info %}}
By default, the publisher (`ApplicationEventPublisher`) waits for all its listeners to finish execution before resuming (blocking). To make it truly even-driven async (non-blocking) we must annotate all the listener methods with the `@Async` annotation. So event-driven is multithreaded only when made so by annotating the listeners properly.
{{% /notice %}}

Spring itself publishes many events upon diff stages of IoC container init and shutdown and we can listen and act on them as well.

_Reference_: Spring Boot Application Events - [YouTube](https://youtu.be/imF5ja5OkAo)