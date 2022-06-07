+++
title = "Spring ReST"
date = 2022-06-07T00:27:00+05:30
weight = 4
+++

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
@RestController 	// = @Controller + @ResponseBody 

@Component
@Controller
@Service			// goes on service impl
@Repository			// goes on repo impl
```

**@RequestMapping**: Specify endpoint methods.
```java
// both class level and methods level annotation
@RequestMapping("/api/v1")
@RequestMapping(value = "/all", method = RequestMethod.GET)
@RequestMapping(value = "/all", method = {RequestMethod.GET, RequestMethod.POST})
@RequestMapping(value = "/all", method = POST)

// it accepts all HTTP methods by default

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
@RequestParam(required = false) String user 		// it is required by default and abscence leads to error
```


**@PathVariable**: Pickup value from URL path.
```java
@GetMapping("/user/{id}")
public String showUser(@PathVariable("id") String id) { }

@GetMapping("/user/{id}")
public String showUser(@PathVariable String id) { }

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

Remember, `@RestController` = `@Controller` + `@ResponseBody`. So we don't need _@ResponseBody_ if we use _@RestController_.

**@RequestHeaders**: Get value of request header.
```java
GetMapping("/double")
public ResponseEntity<String> doubleNumber(@RequestHeader("my-number") int myNumber) { }
```

**@ResponseStatus**: Override response code on a method.
```java
@ResponseStatus(HttpStatus.I_AM_A_TEAPOT)
void teaPot() {}

// whenever teaPot() is called, we get a 418 code in reponse
```


**Consider all of the stuff mentioned above as `required = true` unless specified otherwise explicitly**.