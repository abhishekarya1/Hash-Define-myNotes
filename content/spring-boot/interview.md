+++
title = "Interview Questions"
date = 2024-06-21T10:31:00+05:30
weight = 18
+++

## Spring

**Spring Application Optimizations**:
- Service: async processing `@Async`, use WebFlux's WebClient for inter-service REST API calls
- Database: optimize queries, use proper repository abstraction (e.g. `JpaRepository`, `CrudRepository`), implement caching, connection pooling,
- Security: enable HTTP response compression, configure stateless sessions in Spring Security

If anything goes wrong, debug using Actuator `/metrics` and Prometheus metrics stats.

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

**List all beans in a Spring Boot application**:
```java
@Autowired
private ApplicationContext applicationContext;		// this contains every info about the app

public void listBeans{
	for(String beanName : applicationContext.getBeanDefinitionNames()){
		System.out.println(beanName);
	}
}
```

Alternatively, actuator's `/beans` endpoint can also list all beans, need to expose it first though.

**YAML vs Properties**: YAML is cleaner and structured, properties is simple and verbose. YAML files cannot be loaded by using the `@PropertySource` annotation so that's a negative.

**How to disable a specific Auto-Configuration?**: find out the configuration class that configures the functionality and use `exclude` property in main class annotation.
```java
@SpringBootApplication(exclude = {"DataSourceAutoConfiguration.class"})
public class MyApplication{
    public static void main(String[] args){
        SpringApplication.run(MyApplication.class, args);
    }
}
```

## Microservices

**Scaling for high traffic**:
- break into microservices and scale independently
- horizontal scaling (add more runners/instances)
- load balancer
- API gateway: auth and rate limiting
- caching
- connection pooling
- cloud auto-scale services (Elastic Beanstalk)

**Calling other services**: be async (use WebFlux's WebClient), implement circuit breaker, rate limit with exponential backoff, and cache responses to reduce network requests.

**Event-driven architecture**: for intra-app event driven communniication we can use events API provided in Spring.
- event publisher class should extend `ApplicationEvent` and publish an event using `ApplicationEventPublisher` object autowired inside it
- event listener class should extend `ApplicationListener` and listen using `@EventListener` annotation on a method. The method signature declares the event type it consumes.

**Soft Delete**: mark rows as delted = `true` in a boolean column. On reads, filter out these marked rows from the output.

## Security

- setup login auth
- always salt and hash passwords
- enable HTTPS
- enable CSRF (avoid attacks)