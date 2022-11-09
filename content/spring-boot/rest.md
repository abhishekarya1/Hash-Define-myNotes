+++
title = "Spring ReST"
date = 2022-06-07T00:27:00+05:30
weight = 7
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
@RequestParam String user 						// query key should be "user"
@RequestParam(required = false) String user 		// it is required by default and absence leads to error
```


**@PathVariable**: Pickup value from URL path.
```java
@GetMapping("/user/{id}")
public String showUser(@PathVariable String id) { }

@GetMapping("/user/{id}")
public String showUser(@PathVariable("id") String uid) { }

// we can have multiple path variables too
```

**@RequestBody** and **@ResponseBody**: To perform automatic serialization/deserialization of POJO/JSON.
```java
public @ResponseBody Course saveCourse(@RequestBody Course course){
	return repository.save(course);
}

// alt syntax
@ResponseBody
public Course saveCourse(@RequestBody Course course){
	return repository.save(course);
}
```

Remember, `@RestController` = `@Controller` + `@ResponseBody` on every method. So we don't need _@ResponseBody_ on methods if we use _@RestController_ on class.

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

## Entity<>
We can also serialize/deserialize to specialized `Entity<>` generic classes that provide methods to extract headers, body, status code, etc... They often use/return other companion classes like `HttpHeaders`, `HttpStatus`, `URI`, etc...

```java
HttpEntity<POJO> he   // can be used as both request and response
he.getBody();
he.getHeaders();

ResponseEntity<POJO> res  	// use as method return type only; otherwise error
res.getBody();
res.getStatusCode();
res.getStatusCodeValue();
res.getHeaders();

// often used with restTemplate to form request to send
RequestEntity<POJO> req 	// use as method argument only; otherwise error
res.getBody();
res.getMethod();
res.getType();
res.getUrl();
res.getHeaders();


// correct usage
ResponseEntity<String> getMethod(RequestEntity<String> req){  }
```

## Returning Status Code
```java
// first way
@ResponseStatus(HttpStatus.CREATED)

// second way
ResponseEntity<Foobar> res = new ResponseEntity<>();
res.setStatusCode(HttpStatus.CREATED);
return res;
```