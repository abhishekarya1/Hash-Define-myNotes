+++
title = "Spring Stack"
date = 2024-06-25T13:40:00+05:30
weight = 19
+++

## Spring Security
**Dependency**: `spring-boot-starter-security`

**Enable Annotation**: `@EnableWebSecurity`

As soon as we include the dependency it:
- disallows all POST endpoints (need to disable CSRF to allow them)
- puts all endpoints behind authentication (web login form) and generates password for default user (`user`) on every startup

**Features**:
- enable/disable authentication on certain endpoints (Authorization)
- provides Role-based access control (RBAC) out-of-the-box
- populates database table automatically if we provide correct model and service beans
- customize login and error pages
- implement JWT (using `jjwt` dependency) creation and verification easily

There has been major changes in the things we configure for Spring Security with release of Spring 6 (Spring Boot 3) in 2023 so be mindful of that.

### User Database Auth
After defining a `SecurityFilterChain` bean with matchers for which page must display login screen, we can define the following:
- `UserDetailsService` (calls user repo JpaRepository)
- `UserDetails` model
- `PasswordEncoder` - e.g. `BcryptPasswordEncoder`
- `AuthenticationProvider` (this ) - e.g. `DaoAuthenticationProvider` (mandatory bean to define and pass service and password encoder to it)
- `AuthenticationManager` (bean to trigger authentication)

**References**:
- [Spring Boot 3 - Basics & User Based Auth - YouTube](https://youtu.be/9J-b6OlPy24)

### JWT
We rarely use webpage form based auth. OAuth2.0 is used mostly. But standalone JWT token can be used on API Gateway using a Security Service microsevice.

[JWT notes](/web-api/security/#jwt-json-web-token)

Create a JWT util class that contains all methods related to JWT impl. Also create a filter class for JWT which is always called before username and password auth and checks for "Authentication" HTTP header's presence and conditionally triggers JWT processing or do nothing (i.e. normal login screen username password auth).

- **Decide on a SECRET**: we can use any string but here we use a random SHA512 hash, but keep it the same for all token generation and verification. It is used to generate the symmetric key for signature part of JWT token.
- **Create Token**: call createToken method of the JWT util, set subject claim on token as username from the `UserDetails` object, specify creation time, expiration time, custom claims and sign the token with secret key.
- **Extract Token from HTTP Request**: create a custom filter bean of type `OncePerRequestFilter`, override its `doFilterInternal()` method and in there write logic to extract token from HTTP request ("Authentication" header mostly).
- **Validate Token**: extract the subject claim (i.e. username) from the token and call validateToken method of JWT util. Whenever we extract any claim, it always validates the token with symmetric key (generated using the SECRET) while extracting. The validateToken method _checks expiration time_ of the token and _checks if the username exists_ in the database (uses `UserDetailsService` to do so and fetches its password and roles too).
- After this, set the security context as authenticated to skip the login screen post JWT validation. This makes sure that the username and password auth happens internally for the username for which JWT token was passed and the user isn't prompted for login.

[JWT util methods - GitHub](https://github.com/afsalashyana/Spring-Boot-Tutorials/blob/master/LearnJWT/src/main/java/com/genuinecoder/jwt/webtoken/JwtService.java)

**References**:
- [Spring Boot 3 - JWT Authentication & Authorization](https://youtu.be/HYBRBkYtpeo)

## Spring Batch
**Dependency**: `spring-boot-starter-batch`

**Enable Annotation**: `@EnableBatchProcessing`

![Spring Batch Flow Diagram](https://i.imgur.com/79pktH2.png)

**Terminology**:
- **Job** (runs steps)
- **Step** (runs tasklets)
- **Tasklet** (has `execute()` method which contains custom logic to run)
- Listener - `JobListener` and `StepListener` (implement custom `beforeStep()` and `afterStep()` methods)
- `JobLauncher` (launches job using its `run()` method)
- `JobRepository` (stores execution stats to a database)
- `ItemReader`
- `ItemProcessor`
- `ItemWriter`
- Chunk-oriented processing (Chuck based Tasklet)
- Repeats
- Scheduling

## Spring Integration
**Dependency**: `spring-boot-starter-integration`

**Enable Annotation**: `@EnableIntegration`

Often used with Spring Batch to decouple components within the application.

It is just messaging channels for communication between various components of a service. Not that this is often used for sending messages (e.g. events) not only to other applications but services within an application too can be decoupled. 

It can be used to send messages to external systems like MQ too using Channel Adapters.

This comes from a bunch of concepts called "Enterprise Integration Patterns" from the [book](https://www.enterpriseintegrationpatterns.com/) of the same name.

**Terminology**:
- Message
- Channel - `DirectChannel` (point-to-point), `PublishSubscribeChannel`, etc.
- Router
- ServiceActivator (based on `MessageHandler` as it handles messages)

## Spring Scheduler

**Enable Annotation**: `@EnableScheduling`

Two rules to follow to annotate a method with `@Scheduled` are:
- the method should typically have a `void` return type (if not, the returned value will be ignored)
- the method should not expect any parameters

```java
@Scheduled(fixedDelay = 1000)		// runs after n millisecond of prev execution finish
public void scheduleFixedDelayTask() {
    System.out.println("Fixed delay task");
}

@Scheduled(fixedRate = 1000)	// runs every n milliseconds regardless of prev execution finish

// scheduled tasks don't run in parallel by default. So even if we used fixedRate, the next task won't be invoked until the previous one finishes. So use @Async for parallel behavior.
@Async
@Scheduled(fixedRate = 1000)

@Scheduled(fixedDelay = 1000, initialDelay = 1000)

@Scheduled(cron = "0 15 10 15 * ?")
```

_Reference_: https://www.baeldung.com/spring-scheduled-tasks

## Official Docs
- Spring Security - https://spring.io/projects/spring-security
- Spring Batch - https://spring.io/projects/spring-batch
- Spring Integration - https://spring.io/projects/spring-integration