+++
title = "Spring Stack"
date = 2024-06-25T13:40:00+05:30
weight = 19
+++

## Spring Security
**Dependency**: `spring-boot-starter-security`

As soon as we include the dependency it:
- disallows all POST endpoints (need to disable CSRF to allow them)
- puts all endpoints behind authentication (web login form) and generates password for default user (`user`) on every startup

**Features**:
- rnable/disable authentication on certain endpoints (Authorization)
- provides Role-based access control (RBAC) out-of-the-box
- populates database table automatically if we provide correct model and service beans
- customize login and error pages
- implement JWT (using `jjwt` dependency) creation and verification easily

There has been major changes in the things we configure for Spring Security with release of Spring 6 (Spring Boot 3) in 2023 so be mindful of that.

### User Database Auth
After defining a `SecurityFilterChain` bean with matchers for which page must display login screen, we can define the following:
- `UserDetailsService`
- `UserDetails` model
- `PasswordEncoder` - e.g. `BcryptPasswordEncoder`
- `AuthenticationProvider` (this ) - e.g. `DaoAuthenticationProvider` (mandatory bean to define and pass service and password encoder to it)

**References**:
- [Spring Boot 3 - Basics & User Based Auth - YouTube](https://youtu.be/9J-b6OlPy24)

### JWT
We rarely use webpage form based auth. OAuth2.0 is used mostly. But standalone JWT token can be used on API Gateway using a Security Service microsevice.

[JWT notes](/web-api/security/#jwt-json-web-token)

- need a secret (we can use anything but here we use a random SHA512 hash)
- create token - specify creation time, expiration time, custom claims and sign the token with the secret key
- issue toke - if username and password are correct, call create token method in JWT service
- verify token

**References**:
- [Spring Boot 3 - JWT Authentication & Authorization](https://youtu.be/HYBRBkYtpeo)

## Spring Batch
**Dependency**: `spring-boot-starter-batch`

![Spring Batch Flow Diagram](https://i.imgur.com/79pktH2.png)

**Terminology**:
- Job
- Step
- Listener - `JobListener` and `StepListener`
- `JobRepository` (stores execution stats to database)
- `ItemReader`
- `ItemProcessor`
- `ItemWriter`
- Chunk based processing
- Repeats
- Scheduling

## Spring Integration
**Dependency**: `spring-boot-starter-integration`

Often used with Spring Batch to decouple components within the application.

It is just messaging channels for communication between various components of a service. Not that this is often used for sending messages (e.g. events) not only to other applications but services within an application too can be decoupled. 

It can be used to send messages to external systems like MQ too using Channel Adapters.

This comes from a bunch of concepts called "Enterprise Integration Patterns" from the [book](https://www.enterpriseintegrationpatterns.com/) of the same name.

**Terminology**:
- Message
- Channel - `DirectChannel`, `PublishSubscribeChannel`, etc.
- Router
- ServiceActivator (based on `MessageHandler` as it handles messages)