+++
title = "CLI, Actuator, Lombok"
date = 2022-06-06T21:45:00+05:30
weight = 3
+++

## Spring Boot CLI
We can write groovy applications and they don't require any conventional Java project structure, imports, or even compilation.
```java
// app.groovy
@RestController
class HelloController{
	@GetMapping("/")
	String hello(){
		return "Hello Groovy!";
	}
}

// run with: $ spring run app.groovy
```

## Actuator
Used to: **Monitor and view internals** of the Spring Boot application in runtime, we can **control** it too (like `/shutdown`).

Use below dependency to use actuator:
```xml
<dependencies>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-actuator</artifactId>
	</dependency>
</dependencies>
```

Endpoints are exposed at: `localhost:8080/actuator/<endpoint_name>`. By default only the `/health` endpoint is exposed. 

You can enable or disable each individual endpoint and expose them (make them remotely accessible) over HTTP or JMX. An endpoint is accessible only when it is **both enabled and exposed**.

### Some Common Endpoints
```txt
/beans			-> shows all beans' dependencies, scope, type  
/autoconfig 	-> all autoconfigs done by Spring Boot
/metrics		-> applications metrics like memory, heap, threads
/health			-> "UP" status and diskSpace

/info
/shutdown
```

### Custom Information (/info)
We can send our own definined information on the `/info` endpoint. Specify info using properties.
```txt
info.name.first=Abhishek
info.name.last=Arya
info.address=India

management.info.env.enabled=true
```

```json
// hit /info with GET and we get the following JSON
{
	"name": {
		"first": "Abhishek",
		"last": "Arya"
	},

	"address": "India"
}
```

### /shutdown
It's disabed by default since it can kill the app. Enable it by property as follows:
```txt
management.endpoint.shutdown.enabled=true
``` 

Hit with POST and it gives response back. This is the only endpoint with POST, all are GET otherwise.
```json
// request - POST http://localhost:8080/shutdown

// response
{
 "message": "Shutting down, bye..."
}

```
## Customize Endpoints 
### Enable/Disable Endpoints
By default, all endpoints except `/shutdown` are enabled. We can often disable all (1) and enable only the ones we need (2).
```txt
management.endpoint.<endpoint_id>.enabled=false

(1)
management.endpoints.enabled-by-default=false
(2)
management.endpoint.info.enabled=true
```

Here `endpoint_id` is nothing but name of the endpoint like `health`, `shutdown`, etc...

### Exposing Endpoints
```txt
expose only health and info:
management.endpoints.web.exposure.include=health,info

expose all:
management.endpoints.web.exposure.include=*

exclude env and beans:
management.endpoints.web.exposure.exclude=env,beans
```

Only the `/health` endpoint is exposed by default.

### More
We can change `/actuator` base path to anything we like `/foobar`. 
```txt
management.endpoints.web.base-path=/foobar
```
We can change endpoint_id, toggle sensitivity, secure endpoints with authentication. 

We can write custom health indicators, or an entire custom endpoint.

**References**:
- https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html
- https://docs.spring.io/spring-boot/docs/current/actuator-api/htmlsingle/

## Lombok
Provides annotations to avoid writing a ton of boilerplate code.

```xml
<dependency>
	<groupId>org.projectlombok</groupId>
	<artifactId>lombok</artifactId>
</dependency>
```

```java
// class level annotations
@Data					// generate getter setters for all fields
@Builder 				// Builder pattern
@AllArgsConstructor	 	// constructor with all args
@NoArgsConstructor		// constructor with no args

@Slf4j					// logs (slf4j log)
@CommonsLog				// same as above (but for Apache commons log)
@Log 					// same as above (but for java.util log)

@Generated 				// to mark the component as generated; excepted from coverage checks
@ToString				// generates toString() for the class 
@EqualsAndHashCode		// generates hashcode() and equals() for fields of class
@Value 					// make immutable class (diff from Spring's @Value used to read properties)
						// all fields are made private and final by default, and setters are not generated
@SneakyThrows			// throw any checked exception without declaring it! (no compiler-error)
```

```java
// field level annotations
@Getter			// generate getter for the field
@Setter 		// generate setter for the field

// specify access modifier
@Getter(AccessLevel.PRIVATE)	// PUBLIC, PROTECTED, PACKAGE, or NONE (disable)
String empName;
```
**Reference**: https://projectlombok.org/features/all