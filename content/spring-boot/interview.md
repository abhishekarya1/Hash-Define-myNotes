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

**Async processing in Spring Boot**: we can use `@Async` annotation provided in Spring Boot instead of writing our own CompletableFutures everytime. [notes](/spring-boot/async-events/#spring-async)

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

**Override a method on a class imported from JAR dependency**: create a subclass and override the method (overrides on parent class ref too) and declare a custom bean of original type in a config class with the same name `@Bean("")` or use `@Primary`. We should try to avoid changing code too much here since original class maybe autowired at multiple places in the code hence `@Qualifier` isn't a good solution here.
```java
// original class autowired in multiple places in existing code
@Autowired
OriginalClass originalClass;

// original class bean
@Component
public class OriginalClass {
    @Override
    public void methodToOverride() {
        System.out.println("Original implementation");
    }
}

// create a custom class
public class CustomClass extends OriginalClass {
    @Override
    public void methodToOverride() {
        System.out.println("Custom implementation");
    }
}

// config class with bean override
@Configuration
public class CustomConfiguration {

    @Bean("originalClass")  // same name as the original class (bean overriding)
    @Primary        // alternatively we can mark it as primary (better way; bean selection)
    public OriginalClass customClass() {
        return new CustomClass();
    }
}

// ensure proper component scan in Spring so that our custom bean is picked up
// our custom bean will override the original bean from the JAR if it has the same name
// alternatively if we mark it using the @Primary annotation, it ensures that if there are multiple beans of the same type, Spring will prefer the custom bean even if names are diff
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

**Event-driven architecture**: for intra-app event driven communication we can use events API provided in Spring. [notes](/spring-boot/async-events/#spring-events)

**Soft Delete**: mark rows as delted = `true` in a boolean column. On reads, filter out these marked rows from the output.

## Security

- setup login auth
- always salt and hash passwords
- enable HTTPS
- enable CSRF (avoid attacks)