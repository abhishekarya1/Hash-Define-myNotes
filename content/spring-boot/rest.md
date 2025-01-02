+++
title = "Spring ReST and Server"
date = 2022-06-07T00:27:00+05:30
weight = 8
+++

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

{{% notice info %}}
Spring Boot is inherently multi-threaded as it works on a **Thread-per-Request model**. The server (Tomcat) creates a new thread for each incoming request and excutes the whole flow's code on it. This is often a bottleneck and needs thread management (configure Tomcat thread max etc).
{{% /notice %}}

## Layers
```txt
Controller layer				--> front side
Service/Business layer 			--> application logic
Repository/Data Access layer 	--> database access queries
```

```txt
Controller --> Service (interface) --> Service (impl class)
		   --> Repository (interface) --> Repository (impl class)

```

## Annotations
```java
@RestController 	// @Controller + @ResponseBody

@Component
@Controller
@Service		// goes on service impl
@Repository		// goes on repo impl

@Configuration      	// config class

@Autowired		// inject bean (autowire an interface only when atleast one impl bean exists)
```

**@RequestMapping**: Specify endpoint methods.
```java
// class level
@RequestMapping("/api/v1")
@RequestMapping(value = "/api/v1")

// method level
@RequestMapping(value = "/all", method = RequestMethod.GET)
@RequestMapping(value = "/all", method = {RequestMethod.GET, RequestMethod.POST})

// @RequestMapping accepts all HTTP methods by default

// newer alternatives
@GetMapping
@PostMapping
@PutMapping
@DeleteMapping
@PatchMapping
```

**@RequestParam**: Reading query parameters.
```java
public void user(@RequestParam("userId") String user){ }

// localhost:8080/user?userId

// alt syntax
@RequestParam(name = "userId") String user
@RequestParam String user 						// query key should be "user"; it is required by default and absence leads to error
@RequestParam(required = false) String user 	// user can be skipped but it will take value as "null"
@RequestParam(required = false, defaultValue = "99") Integer userId 	// we can set a default value too
```

**@PathVariable**: Pickup value from URL path.
```java
@GetMapping("/user/{id}")
public String showUser(@PathVariable String id) { }

@GetMapping("/user/{id}")
public String showUser(@PathVariable("id") String uid) { }

// we can have multiple path variables too
@GetMapping("/user/{id}/demo/{age}")
public String showUser(@PathVariable String id, @PathVariable Integer age) { }
```

**@RequestBody** and **@ResponseBody**: To perform automatic serialization/deserialization of POJO/JSON. **Getters, setters and constructor must be present for Jackson library to work**. 
```java
@PostMapping
public @ResponseBody Course saveCourse(@RequestBody Course course){
	return repository.save(course);
}

// alt syntax
@PostMapping
@ResponseBody
public Course saveCourse(@RequestBody Course course){
	return repository.save(course);
}
```

Remember, `@RestController` = `@Controller` + `@ResponseBody` on every method. So we don't need _@ResponseBody_ on methods if we use _@RestController_ on class.

We can specify `produces` and `consumes` and the HTTP content negotiation uses the values specified:
```java
@PostMapping(produces = "application/json", consumes = "application/xml")
public JSONObj xmlToJsonConverter(@RequestBody XMLObj xmlObj){
	return service.convert(xmlObj);
}
```

The `Content-Type` header should be present on the incoming request and needs to match `consumes` value otherwise error and upon sending the error (415 Unsupported Media Type) response we will attach an `Accept` header with the `consumes` value.

**@RequestHeader**: Get value of request header.
```java
@GetMapping("/double")
public String doubleNumber(@RequestHeader("my-number") int myNumber) { }
```

**@ResponseStatus**: Override response code on a method.
```java
@ResponseStatus(HttpStatus.I_AM_A_TEAPOT)
void teaPot() {}

// whenever teaPot() is called, we get a 418 code in reponse no matter the actual response code
```

**Consider all of the stuff mentioned above as `required = true` unless specified otherwise explicitly by the programmer**.

## Entity<T> Objects
We can also serialize/deserialize to specialized `Entity<>` generic classes that provide methods to extract headers, body, status code, etc... They often use/return other companion classes like `HttpHeaders`, `HttpStatus`, `URI`, etc...

```java
// neither of the entities have setters because they are immutable classes as they represent state i.e. they are value objects (VO).

HttpEntity<POJO> he   // can be used as both request and response
he.getBody();
he.getHeaders();

// use as method return type only, otherwise error; extends HttpEntity<T>
ResponseEntity<POJO> res
return new ResponseEntity<>("Congrats!", HttpStatus.OK);	// build with constructor
return ResponseEntity.ok()
			.header("foo", "bar")
			.body("lorem ipsum");

// use as method argument only, otherwise error; extends HttpEntity<T>
RequestEntity<POJO> req
req.getBody();
req.getMethod();
req.getType();
req.getUrl();
req.getHeaders();

// often used with RestTemplate to form a request to send
var req = RequestEntity.post(new URI("www.example.org"))
					      .header("foo", "bar")
					      .body("lorem ipsum");

// correct usage
ResponseEntity<T> getMethod(RequestEntity<T> req){  }
```

## HTTP Status Codes
```java
// first way with annotation
@ResponseStatus(HttpStatus.OK)

// second way with ResponseEntity<T>
return new ResponseEntity<>(HttpStatus.OK);	// build with constructor
return ResponseEntity.ok();
return ResponseEntity.status(HttpStatus.OK);
```

## Routing

For CORS, `OPTIONS` is always available on all endpoints even if we don't specify it anywhere. 

```java
@GetMapping("foo")
void demo(){ }

@GetMapping("/foo")		// same as above; this is the recommended way
void demo(){ }

@GetMapping({"/foo", "/bar"})		// multiple routes, single handler method
void demo(){ }

@GetMapping()			// only accessible on - "localhost:8080"
void demo(){ }

@GetMapping("")			// same as above
void demo(){ }
```

The methods are statically bound to the routes and two methods can't have an identical route (obviously!):
```java
@GetMapping("/foo")
void demo(){ }

@GetMapping("/foo")			// identical path mapping; error on server startup
void anotherDemo(){ }

// will be allowed if there is another distinguishing factor like "produces" or "consumes" parameter
```

_Reference_: https://www.baeldung.com/spring-requestmapping

### Slash terminated URLs in Spring Boot 3.0
URL pattern matching was slightly changed in Spring Boot version 3.0 (Spring 6). It now treats the slash terminated and non-terminated ones as two distinct endpoints and doesn't redirect automatically.

URLs terminated with slash (`localhost:8080/foo/`) no longer redirect to non-terminating with slash (_"normal"_) ones (`localhost:8080/foo`).
```java
// Spring Boot 2.x
@GetMapping("foo")		// accessible on - "localhost:8080/foo" and "localhost:8080/foo/" (Spring redirects it to the former)
void demo(){ }

// Spring Boot 3.x
@GetMapping("foo")		// accessible only on - "localhost:8080/foo" and NOT "localhost:8080/foo/"
void demo(){ }


// if we specify slash explicitly in the Controller, then its mandatory in the URL (both Spring Boot 2.x and 3.x)
@GetMapping("foo/")		// only accessible on - "localhost:8080/foo/"
void demo(){ }

@GetMapping("/")		// only accessible on - "localhost:8080/" (same concept as above)
void demo(){ }
```

**Reason**: This is done to match behavior with Servlet containers (like Tomcat and Jetty) as they also treat the two paths as distinct, and RESTful API practices also suggest using distinct paths for distinct resources which prevents ambiguity.

This is customizable of course and we can revert to old behavior using the property:
```sh
spring.mvc.trailing-slash-match=true
```

_Reference_: https://www.baeldung.com/spring-boot-3-url-matching

## File Uploads and Downloads
**For upload**: HTTP request type is `form-data` with key as `file` and value as the actual file uploaded from file selector. This ensures header `Content-Type = multipart/form-data` is added automatically in Postman.

```java
// controller method for upload endpoint
String uploadFile(@RequestParam("file") MultipartFile file){ }
```

**For download**: return back a response entity with special headers.
```java
// controller method return statement for download endpoint
return ResponseEntity.ok()
       .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
       .body(resource);
```

We can save to local filesystem (using Java IO), or to SQL database as `BLOB` type (use Data JPA's default `save()` method to save entity):
```java
// in entity class, saves file data as blob
@Lob 		// not a typo
byte[] data;
```

Also, we need to specify the following parameters in `application.properties`:
```sh
# enable file upload/download on servlet
spring.servlet.multipart.enabled=true

# threshold after which files are written to disk
spring.servlet.multipart.file-size-threshold=2KB
# max file size
spring.servlet.multipart.max-file-size=200MB
# max request Size
spring.servlet.multipart.max-request-size=215MB
``` 

## Calling other Rest API in code

**RestTemplate**: synchronous (now deprecated)

**RestClient**: synchronous (`spring-boot-starter-web` dependency)

**WebClient**: asynchronous and reactive (`spring-boot-starter-webflux` dependency) [notes](/spring-boot/reactive/#webclient---async-web-api-calls)


## Embedded Servlet Container
The default web server in Spring Boot is Tomcat provided only if we include the `spring-boot-starter-web` dependency. 

To change it, we can exclude the Tomcat dependency under `starter-web` and add another dependency like `starter-webflux` or `io.netty` to have Netty as the web server.

Tomcat works on a **Thread-per-Request model**. It creates a new thread for each incoming request and that can get very limiting as by default it uses "normal" threads and not Virtual Threads (introduced in Java 21).

The default max number of simultaneous requests that can be accepted by the Tomcat server is 200. This can be changed using the `server.tomcat.threads.max` property. But we will obviously be limited by our CPU cores on the max threads that can execute parallely.

If we're using Spring Boot 3.2.0+ with Java 21+ then we can use the property `spring.threads.virtual.enabled=true` to use Virtual Thread throughout the application. This brings the response times down significantly in applications where there aren't enough threads (i.e. threads with blocking I/O slowing us down).

## Layers before Controller
**Tomcat --> Filter --> Servlet --> Interceptor --> Controller**

We can modify request at any layer before the Controller. From Interceptor onwards we have Spring Context awareness, prior layers are handled by Servlet API and not Spring. 

We commonly modify requests by creating a custom Filter (`Filter`), Servlet (`DispatcherServlet`) or a custom Interceptor (`HandlerInterceptor`) (_best_).

_Reference_: [Using Interceptor in Spring Boot - YouTube](https://youtu.be/DuMf8Nwb-9w)

