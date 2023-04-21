+++
title = "Exception Handling"
date = 2022-11-09T13:04:00+05:30
weight = 5
+++

## Basics
Whatever exception reaches the Controller, we can handle them without wrapping controller code in try-catch blocks.

1. create your custom exception using `extends`, 
2. `catch` expected exceptions and `throw` our custom one instead,  
3. then use `@ExceptionHandler` or `@RestControllerAdvice`  to handle on the Controller level

```java
// 1 
class MyCustomException extends RuntimeException{
	public MyCustomException(String message){
		super(message);
	}
}

// 2
public getMethod(){
	try{
		// something
	}
	catch(Exception e){
		throw new MyCustomException("Failure!!!");
	}	
} 

// 3 - for a single controller
// in Controller class
@ExceptionHandler
public String myErrorHandler(MyCustomException mce){		// parameter matters here
        return "Message to be sent in response body.";
}

// alternatively
@ExceptionHandler(MyCustomException.class)		// cleaner syntax
public String myErrorHandler(){					// notice no params
        return "Message to be sent in response body.";
}

// 3 - for multiple controllers
// create a separate class and define our handler method in it
@RestControllerAdvice
public class globalErrorHandler{

	@ExceptionHandler(MyCustomException.class)
	public String myErrorHandler(){		
        return "Message to be sent in response body.";
	}
}
```

The `@ExceptionHandler` present in the same `@RestController` will have more precedence over the global one present in the `@RestControllerAdvice`, so it can override it.

## Validations
Use `starter-validation` dependency to apply validations on fields.

Many annotation based validations can be specified in POJOs directly. When we convert (deserialize) from JSON to POJO, failing a validation will throw `MethodArgumentNotValidException` which is sent as a `BAD_REQUEST` status by Spring. We need to **trigger** these validations (see below section) unless we are using them in JPA entities.
```java
@NotBlank(message="Please provide value for name!")		// optional message
private String name;

@Min(10)
@Max(100)
@Length(min=1, max=5)
@Size(min=0, max=10)
@Temporal(TemporalType.DATE)
@Email
@Positive
@Negative
@PositiveOrZero
@NegativeOrZero
@Past
@Future
@PastOrPresent
@Pattern(regexp = "^.*$")
```

### Triggering Validations

**On simple data types** with `@Validated` class-level annotation:

```java
@RestController
@Validated				// notice
class MyController{

	@RequestMapping("api/{roll}")
	public String sendName(@PathVariable("roll") @Max(999) int rollNo){		// validation on primitives and simple types
		return service.fetch(rollNo);
	}

}
```

**On POJOs** with `@Valid` method-level annotation:

```java
@RequestMapping
public Course saveCourse(@Valid @RequestBody Course course){		// notice; Course POJO has validation annotations inside it
	return repository.save(course);
}
```

Using both annotations when **calling components from each other**:
```java
@Service
@Validated
class ValidatingService{

    void validateInput(@Valid Input input){
      // do something
    }

}
```

## References
- Exception Handling in SpringBoot Applications - SivaLabs - [YouTube](https://youtu.be/riBHV6ux4nQ)
- Validation with Spring Boot - the Complete Guide - [reflectoring.io](https://reflectoring.io/bean-validation-with-spring-boot/)