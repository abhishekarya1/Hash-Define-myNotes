+++
title = "Spring Cloud"
date = 2022-06-20T08:56:00+05:30
weight = 11
+++

Review: [/microservices](/microservices)

## Spring Cloud
Just like Spring Boot is an extension to Spring Framework, Spring Cloud is an extension to Spring Boot which provides tools to build and work with cloud-native applications.

Many tools are provided among which the most popular are from open-source projects like Netflix OSS and HashiCorp's Consul.

[Official Link](https://spring.io/projects/spring-cloud)

### Dependency

```xml
<!-- Add dependency here -->
<dependencies>
	<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
	</dependency>
</dependencies>

<!-- Specify Spring Cloud version -->
<properties>
		<java.version>17</java.version>
		<spring-cloud.version>2021.0.3</spring-cloud.version>
	</properties>

<!-- Add dependecyManagement block -->
<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
</dependencyManagement>
```

## Service Registry and Discovery
We use Netflix Eureka Server for this.

Each service registers itself to the Eureka server. Multiple instances of the same service can also be registered. We can then **refer to services by their name instead of a URL** p.s. use `@LoadBalanced` on method using `restTemplate` for client-side load balancing.

{{% notice note %}}
Even if the discovery server goes down, the services maintain an ephemeral local copy of the service registry. This local registry doesn't let the discovery server become a single point-of-failure.
{{% /notice %}}

### Server
Notice that the `spring-boot-starter-web` dependency is not required to up the Eureka server.

```java
// main application class
@EnableEurekaServer
```
```yaml
# application.yml
server:
  port: 8761

eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
```

### Client
```java
// main application class
@EnableEurekaClient
```
```yaml
# application.yml
spring:
  application:
    name: DEPARTMENT-SERVICE	# service name

eureka:
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://localhost:8761/eureka/	# Eureka server URL
  instance:
    hostname: localhost
```

Run multiple instances of the same client and they will all register themselves in the discovery server as replicas of a single service.

## OpenFeign Client
Call another service in the background when current service's controller endpoints are accessed, fetch results and return to the sender as if we (the current service) is serving the request.
```java
// Service-A
// add feign maven dependency in pom

// add @EnableFeignClients on the main class

// Feign controller class
@FeignClient(value = "feigndemo", url="http://localhost:8081/foobar")   // value = arbitrary name; url = service-B's URL
public interface FeignController{     // notice that its an interface

  @GetMapping("/username")
  public String getUserName();

}

// actual controller class in same service-A
@RestController
public class MyController{

  @Autowired
  private FeignController feignController;

  @GetMapping("/name")
  public String getName(){
    return feignController.getUserName();
  }

}

// Summary: 
// when we access "localhost:8080/name" (this service), it will actually access "localhost:8081/foobar/username" (another rservice)
```

_Reference_: https://youtu.be/tlshVRtbS_c

## API Gateway
We use **Spring Cloud Gateway** here.

It routes requests to correct service so that we are not hitting the service URL directly but via this gateway URL, also helps us to monitor and implement resilience (circuit breaking).

Make this as a Eureka Client too. No need to enable any gateway specific annotation in the main application class.

```yaml
# application.yml
spring:
  application:
    name: GATEWAY-SERVER

  # add routing info below
  cloud:
    gateway:
      routes:
        - id: USER-SERVICE
          uri: lb://USER-SERVICE
          predicates:
            - Path=/users/**
        - id: DEPARTMENT-SERVICE
          uri: lb://DEPARTMENT-SERVICE
          predicates:
              - Path=/departments/**
```

## Circuit Breaker
We use **Resilience4j** here. 

It provides many ways to make the app resilience such as **Circuit Breaker**, **Retry**, **Rate Limiter**, Bulkhead, Time Limiter, and Cache.

- _Circuit breaking_ is a mechanism to avoid making further requests if any resource is unavailable, then making a few requests at regular interval to check the status of availability of that resource. Upon failure on first hit, we can call a fallback method too.
- _Retrying_ is simply retrying for a few times and waiting for specified time between each attempt.
- _Rate limiting_ is limiting the amount of requests allowed to be made in a specified time interval.

Requires `starter-actuator` as we can see the circuit state via `/actuator/health` endpoint of the actuator.

We have to put below annotations on the controller method as it is the starting point of the circuit. The `fallbackMethod` _must_ return same type and take as parameter an `Exception` and _must_ be defined in the same class i.e. Controller.

```java
// in Controller class on the method using restTemplate to make calls to another resource
@CircuitBreaker(name = "testBreaker", fallbackMethod = "fallBackGetUserDept")

@Retry(name = "testBreaker")

@RateLimiter(name = "testBreaker")
```

```yaml
# application.yml

# actuator configs
management:
  health:
    circuitbreakers:
      enabled: true
  endpoints:
    web:
      exposure:
        include: health
  endpoint:
    health:
      show-details: always

# resilience4j configs
resilience4j:
  circuitbreaker:
    instances:
      testBreaker:    # same name as specified in annotation in controller
        registerHealthIndicator: true
        eventConsumerBufferSize: 10
        failureRateThreshold: 50
        minimumNumberOfCalls: 5
        automaticTransitionFromOpenToHalfOpenEnabled: true
        waitDurationInOpenState: 5s
        permittedNumberOfCallsInHalfOpenState: 3
        slidingWindowSize: 10
        slidingWindowType: COUNT_BASED
  retry:
    instances:
      testBreaker:    # same name as specified in annotation in controller
        registerHealthIndicator: true
        maxRetryAttempts: 5
        waitDuration: 10s
  ratelimiter:
    instances:
      testBreaker:    # same name as specified in annotation in controller
        registerHealthIndicator: false
        limitForPeriod: 10
        limitRefreshPeriod: 10s
        timeoutDuration: 3s
```

### Circuit States
**CLOSED** - all calls are going through and to the service

**OPEN** - no calls being made to the service

**HALF_OPEN** - only some calls are being made to check status of service

Based on a **threshold** value that we supply in the config (in percentage), we can expect the circuit breaker to change states.

![Resilience4j state diagram](https://files.readme.io/39cdd54-state_machine.jpg)

We can monitor using **Prometheus** or **Grafana** since there is no integrated dashboard like Hystrix.

## Config Server
Configs that are common to all the services can be placed in a central server having a repository (via GitHub). Each individual service can then point to that server and fetch configs duting **bootstrap** stage of the Spring Boot application run.

The `bootstrap.yml` files are where this "pointing to server" logic is placed in a service and they're usually loaded even before `application.yml` file during the application context load.

We moved the "Eureka Client properties" common to all services to a GitHub repo. The services need no additional dependencies for this.

```java
// in main application class
@EnableConfigServer
```

```yaml
# application.yml (of the Config server)
server:
	port: 9191

cloud:
    config:
      server:
        git:
          uri: https://github.com/abhishekarya1/spring-cloud-config-server
          clone-on-start: true
```

```yaml
# bootstrap.yml (in every service); we can add to application.yml of the service too
spring:
  cloud:
    config:
      enabled: true
      uri: http://localhost:9191
```

## Project Link

[GitHub Link](https://github.com/abhishekarya1/spring-boot-microservices)

## References
- Microservices Tutorial - [Daily Code Buffer - YouTube](https://youtu.be/BnknNTN8icw)
- Resilience4j Tutorial - [Daily Code Buffer - YouTube](https://youtu.be/9AXAUlp3DBw)
- Spring Boot Microservices Full Course - [Programming Techie - YouTube](https://www.youtube.com/playlist?list=PLSVW22jAG8pBnhAdq9S8BpLnZ0_jVBj0c)
- Mastering Spring Boot 2.0 - Dinesh Rajput (PacktPub) [\[Link\]](https://g.co/kgs/Eb8KHc)
