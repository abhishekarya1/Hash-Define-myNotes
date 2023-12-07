+++
title = "Autowiring"
date = 2023-05-09T18:18:00+05:30
weight = 7
+++

_Refresher_: [/spring-boot/concepts/#ioc-and-di](/spring-boot/concepts/#ioc-and-di)

Spring always finds Beans and adds them to ApplicationContext/Proxy, if the Bean is not defined anywhere in our `@ComponentScan` scope then its a compile-time error.

## Autowiring Errors
### No Qualifying bean of type
For dependency to eliglible for autowiring, it needs to have a `@Component` or equivalent annotation on the implementing concrete class (and not `interface`) otherwise autowiring will fail with error `No qualifying bean of type [...] found for dependency...`

### Autowired dependency is null
Don't create objects having `@Autowired` dependencies with `new` keyword, Spring won't know that these object exists and won't be able to Autowire the dependency into it, making its value to be `null` and its a Runtime Exception.

It is a good practice never to use `new` to create beans in Spring.

```java
class MyService{
	@Autowired
	MyRepository repo;
}

class MyController{
	MyService service = new MyService();	// Spring can't inject MyRepository bean in MyService
}
```

_Reference_: https://www.baeldung.com/spring-autowired-field-null

## Autowiring an Interface
Points to remember:
- the `@Component` or equivalent is always placed on the **concrete class**, where the Bean is actually formed; otherwise error
- we can autowire an `interface` but only when **atleast one** of its implementation's Bean is present; otherwise error

**What happens when two Concrete classes exists for a single interface that we autowire?** Error, Spring can't decide which impl to autowire in this case.

```java
interface AutoService { }

@Service
class ServiceA implements AutoService { }

@Service
class ServiceB implements AutoService { }

class Main{
	@Autowired
	private AutoService autoService;		// compile-time error
}
```
### Resolving Ambiguity
- specify service name as `@Autowired` field's name
- use `@Service("")` along with `@Qualifier("")` to specify more explicitly
- use `@Primary` on the class which should always be autowired in case of ambiguity unless specified otherwise
```java
// 1. specify service name as @Autowired field's name
class Main{
	@Autowired
	private AutoService serviceA;		// instance of ServiceA is injected
}

// 2. use @Service("") along with @Qualifier("")
@Service("foo")
class ServiceA implements AutoService { }

@Service("bar")
class ServiceB implements AutoService { }

class Main{

	@Autowired
	@Qualifier("bar")
	private AutoService autoService;	// ServiceB is injected
}

// 3. use @Primary to indicate a default impl
@Service
@Primary
class ServiceA implements AutoService { }

@Service
class ServiceB implements AutoService { }

class Main{

	@Autowired
	private AutoService autoService;	// ServiceA is injected
}

// if both @Primary and @Qualifier mechanisms are ambiguous, then @Qualifier takes precedence (ofc!)
```
_Reference_: https://www.baeldung.com/spring-autowire

### Exceptions to @Component on Interfaces - JPA
`interfaces` can't have `@Component` or equivalent annotations on them, but there is an exception: the JPA Repositories, they can have them on interface, although it is not required at all:

```java
@Repository
public interface UserRepository extends JpaRepository<User,Long> {
    User findByEmail(String email);
}
```

{{% notice info %}}
Actually, `interface` can also have a `@Component` annotation (useless though) if the implementing class also has it, that is what is happening here. **Keeping interfaces free of any such framework specific annotations is a good practice**.
{{% /notice %}}

## Creating custom Beans with @Configuration and @Bean
We can create custom beans other than the `@Component` mechanism, with `@Configuration` class and `@Bean` annotations:

```java
@Configuration
class MyCustomBeans{

	@Bean
	public ServiceA serviceBeanCreator(String s, int n){	// notice return type
		return new ServiceA("foo", 99);						// we can call any constructor we want here
	}


	// dependency on existence of another bean
	@Bean
	public ServiceC myServiceBean(ServiceB s) {		// Spring will automatically init ServiceB Bean before this and use that to init ServiceC here
		return new ServiceC();
	}
}
```

The Bean created above will automatically be injected in Spring Proxy since this is a `@Configuration` class.

## @Autowired on Setters and Constructors

So far, the most popular way is to autowire/inject a Bean to a field. But it is Relection based and slower than the other two ways. We can also do setter and constructor based injections (_recommended_):

```java
class Main{

	@Autowired
	private AutoService autoService;	// field-based injection; injects AutoService bean on the field
}

----------------------------------------------------

class Main{

	private AutoService autoService;

	@Autowired		// Spring calls this setter automatically just after constructor call; also passes AutoService Bean if it exists
	private mySetter(AutoService autoService){	// setter-based injection; injects AutoService bean on the setter's param
		// any custom logic
		this.autoService = autoService;
	}	
}

----------------------------------------------------

class Main{

	private AutoService autoService;

	@Autowired								// Spring will use this constructor by default when creating Bean of Main
	private Main(AutoService autoService){	// constructor-based injection; injects AutoService bean on the constructor's param
		this.autoService = autoService;
	}
}
```

_Reference_: https://stackoverflow.com/a/56089288
