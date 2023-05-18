+++
title = "Spring ReST"
date = 2022-06-07T00:27:00+05:30
weight = 8
+++

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

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
@Service			// goes on service impl
@Repository			// goes on repo impl

@Configuration      // config class

@Autowired			// inject bean (autowire an interface only when atleast one impl bean exists)
```

**@RequestMapping**: Specify endpoint methods.
```java
// class level
@RequestMapping("/api/v1")
@RequestMapping(value = "/api/v1")

// method level
@RequestMapping(value = "/all", method = RequestMethod.GET)
@RequestMapping(value = "/all", method = {RequestMethod.GET, RequestMethod.POST})
@RequestMapping(value = "/all", method = POST)

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

**@RequestBody** and **@ResponseBody**: To perform automatic serialization/deserialization of POJO/JSON.
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

The `Content-Type` header should be present on the incoming request and needs to match `produces` value otherwise error and upon sending the error (415 Unsupported Media Type) response we will attach an `Accept` header with the `consumes` value.

**@RequestHeader**: Get value of request header.
```java
GetMapping("/double")
public String doubleNumber(@RequestHeader("my-number") int myNumber) { }
```

**@ResponseStatus**: Override response code on a method.
```java
@ResponseStatus(HttpStatus.I_AM_A_TEAPOT)
void teaPot() {}

// whenever teaPot() is called, we get a 418 code in reponse no matter the actual response code
```

**Consider all of the stuff mentioned above as `required = true` unless specified otherwise explicitly by the programmer**.

## Entity<> Objects
We can also serialize/deserialize to specialized `Entity<>` generic classes that provide methods to extract headers, body, status code, etc... They often use/return other companion classes like `HttpHeaders`, `HttpStatus`, `URI`, etc...

```java
HttpEntity<POJO> he   // can be used as both request and response
he.getBody();
he.getHeaders();

ResponseEntity<POJO> res  	// use as method return type only; otherwise error; extends HttpEntity<>
res.getBody();
res.getStatusCode();
res.getStatusCodeValue();
res.getHeaders();

// often used with restTemplate to form request to send
RequestEntity<POJO> req 	// use as method argument only; otherwise error; extends HttpEntity<>
res.getBody();
res.getMethod();
res.getType();
res.getUrl();
res.getHeaders();


// correct usage
ResponseEntity<String> getMethod(RequestEntity<String> req){  }
```

## HTTP Status Codes
```java
// first way
@ResponseStatus(HttpStatus.CREATED)

// second way
ResponseEntity<Foobar> res = new ResponseEntity<>();
res.setStatusCode(HttpStatus.CREATED);
return res;
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
URL pattern matching was changed in Spring Boot version 3.0. 

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

_Reference_: https://www.baeldung.com/spring-boot-3-url-matching