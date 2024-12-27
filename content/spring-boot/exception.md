+++
title = "Exception Handling"
date = 2022-11-09T13:04:00+05:30
weight = 5
+++

## ExceptionHandler and RestControllerAdvice
We often propagate exceptions till the controller and let it throw them to let the user know what is the issue in their request, etc.

Whatever exception reaches the Controller, if we want we can handle them without wrapping controller code in try-catch blocks.

1. create your custom exception using `extends`, 
2. `catch` expected exceptions and `throw` our custom one instead,  
3. then use `@ExceptionHandler` and `@RestControllerAdvice` to handle on the Controller level

```java
// 1 
class MyCustomException extends Exception{
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
public String myErrorHandler(MyCustomException mce){		// parameter type matters here
		// send error HTTP response here
        return "oops! some error has occured.";
}

// alternatively
@ExceptionHandler(MyCustomException.class)		// cleaner syntax
public String myErrorHandler(){					// notice no params
		// send error HTTP response here
        return "oops! some error has occured.";

}

// 3 - for multiple controllers
// create a separate class and define our handler method in it
@RestControllerAdvice
public class globalErrorHandler{

	@ExceptionHandler(MyCustomException.class)
	public String myErrorHandler(){		
		// send error HTTP response here
        return "oops! some error has occured.";

	}
}
```

The `@ExceptionHandler` present in the same `@RestController` will have more precedence over the global one present in the `@RestControllerAdvice`. So if a handler is present in the controller for an exception type then advice's handler won't be called.

## Validations
Use `starter-validation` dependency to apply validations on fields.

Many annotation based validations can be specified in POJOs directly. When we convert (deserialize) from JSON to POJO, failing a validation will throw `MethodArgumentNotValidException` which is sent as a HTTP status `400 - Bad Request` by Spring. We need to **trigger** these validations (see below section) unless we are using them in JPA entities.
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

**Class-level**: `@Validated` validates all params for all methods of the class on which it is used

```java
@Validated				// notice
@RestController
class MyController{

	@RequestMapping("api/{roll}")
	public String sendName(@PathVariable("roll") @Max(999) int rollNo){		
		return service.fetch(rollNo);
	}

}
```

**Method parameter-level**: `@Valid` validates any type (primitive, simple, or POJO) when placed on a POJO field or method parameter

```java
@RequestMapping
public Course saveCourse(@Valid @RequestBody Course course,			// Course POJO has validation annotations inside it
			 @Valid @PathVariable("courseId") @Max(999) int courseId){	// primitive
	return repository.save(course);
}
```

**Nested validation** (**Field-level**): validating an object that's member of a class (composition)
```java
public class UserAddress {
    @NotBlank
    private String countryCode;
}

public class UserInfo {
    @Valid 					// notice
    @NotNull
    private UserAddress userAddress;
}

// UserInfo is validated as a method argument in its Controller method
```

Triggering validation on `UserInfo` will now trigger it automatically (cascade) for `UserAddress` as well. Otherwise it wouldn't have triggered if we were missing the `@Valid` in `UserInfo` i.e. we've to _explicitly cascade_ for every layer, validations don't cascade! 

[Reference](https://stackoverflow.com/questions/41005850/validation-nested-models-in-spring-boot)

**Validation Groups**: We can also group together fields and trigger validation only for specific group(s) using `@Validated(GroupFooBar.class)` at the field level (or method parameter level).

```java
public class UserAccount {
    @NotNull(groups = BasicInfo.class)
    @Size(min = 4, max = 15, groups = BasicInfo.class)		// creating groups
    private String password;
 
    @NotBlank(groups = BasicInfo.class)
    private String name;
 
    @Min(value = 18, message = "Age should not be less than 18", groups = AdvanceInfo.class)
    private int age;
 
    @NotBlank(groups = AdvanceInfo.class)
    private String phone;  
}

// in Controller class
@PostMapping(value = "/saveBasicInfo")
public void saveBasicInfoStep(
	@Validated(BasicInfo.class) 					// trigger validation only for specific groups
	@RequestBody("useraccount") UserAccount useraccount){ }

```

{{% notice note %}}
`@Validated` can also be used at the method parameter level and it will work the same as `@Valid`, but not vice-versa. Actually, `@Validated` was introduced later to enable implementation of validation groups at method parameter level so it checks out.
{{% /notice %}}

## References
- Exception Handling in SpringBoot Applications - SivaLabs - [YouTube](https://youtu.be/riBHV6ux4nQ)
- Validation with Spring Boot - the Complete Guide - [reflectoring.io](https://reflectoring.io/bean-validation-with-spring-boot/)
- Differences in @Valid and @Validated Annotations in Spring - [Baeldung](https://www.baeldung.com/spring-valid-vs-validated)