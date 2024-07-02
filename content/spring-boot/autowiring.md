+++
title = "Beans and Autowiring"
date = 2023-05-09T18:18:00+05:30
weight = 7
+++

_Refresher_: [/spring-boot/concepts/#ioc-and-di](/spring-boot/concepts/#ioc-and-di)

Spring always finds Beans and adds them to ApplicationContext/Proxy, the `@ComponentScan` must specify scope to scan for bean definitions otherwise it results in a compile-time error if a bean is autowired somewhere in our application code and not scanned under component scan.

Multiple beans of the same type can exist but each bean in Spring context has a **unique name** (globally, and not only for its type). If multiple bean of the same name exist, one overrides the other. Their unique name also helps us to identify them while autowiring.

The default bean scope in Spring is **Singleton** (only one instance of a Spring bean having a specific name will be created and injected into the proxy). Multiple beans of the same type may exist but singleton property in Spring is based on their name (bean names have to be globally unique).

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
- use `@Primary` on the class which should always be autowired in case of ambiguity (if there are multiple beans of the same type) unless specified otherwise
```java
// 1. specify service name as @Autowired field's name to select which bean to use
class Main{
	@Autowired
	private AutoService serviceA;		// instance of ServiceA is injected
}

// 2. use @Service("") along with @Qualifier("") to select which bean to use
@Service("foo")
class ServiceA implements AutoService { }

@Service("bar")
class ServiceB implements AutoService { }

class Main{

	@Autowired
	@Qualifier("bar")
	private AutoService autoService;	// ServiceB is injected
}

// 3. use @Primary to indicate a preferred impl (if multiple impl are present and there is ambiguity, this bean impl will be used)
@Service
@Primary
class ServiceA implements AutoService { }

@Service
class ServiceB implements AutoService { }

class Main{

	@Autowired
	private AutoService autoService;	// ServiceA is injected
}

// if both @Primary and @Qualifier mechanisms are present and causing ambiguity, then @Qualifier takes precedence (ofc as its more explicit and closer to usage (autowiring location))
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
The usual way we have beans is using annotation like `@Component` and the name of the bean is always taken as lowercase in this case:
```java
@Component
class Foobar{}		// default naming; a bean named "foobar" (notice the lowercase) is created

@Component("Baz")
class Foobar{}		// explicit naming; a bean named "Baz" is created (no case conversion since its explicit)
```

We can create custom beans other than the `@Component` mechanism, with `@Configuration` class and `@Bean` method annotations:

```java
@Configuration
class MyCustomBeans{

	@Bean
	public ServiceA serviceABean(String s, int n){	// notice return type
		return new ServiceA("foo", 99);				// we can call any constructor we want here
	}

	// dependency on the existence of another bean
	@Bean
	public ServiceC serviceCBean(ServiceB s) {		// Spring will automatically init ServiceB Bean before this and use that to init ServiceC here
		return new ServiceC();
	}
}
```

The bean name can be specified in the `@Bean` annotation and by default the method name is taken as the bean name unless explicitly specified, no restriction of lowercase names here since we can specify anything explicitly here:
```java
@Bean
public Demo foo(){		// bean name is "foo" (default is method name)
	return new Demo();
}

@Bean("Bar")			// bean name is "Bar", explicitly specified bean name
public Demo foo(){
	return new Demo();
}
```

The Beans created above will automatically be injected in Spring Proxy since this is a `@Configuration` class.

### Bean Overriding
Remember that all beans have a unique name globally in the Spring context, hence each and every bean can be identified using its name and as a result, they are overridden too using their names be it same type or not.

Points to remember regarding overriding of beans:
- **Explicit Bean Naming**: if two beans of the same type but diff names are defined, they will not override each other. Beans only override when they have the same name.
- **Configuration Class Order**: Spring processes configuration classes in the order they are found. If you have multiple configuration classes defining beans of the same name, the last one processed will override all the previous ones. But the order of processing by Spring isn't predictable. 

```java
// configuration class
@Bean("foobar")
public Foobar getFoobar(){
	return new Foobar();
}

@Bean("foobar")
public Foobar getFoobarBean(){
	return new Foobar();
}

// this doesn't cause any application startup errors but the below bean overrides the above one since they have the same name

@Bean("foobar")
public Test getTestBean(){
	return new Test();
}

// this will still override above beans even if it is of diff type, since it has the same name (no startup errors here too)

// only one bean named "foobar" is created for the above three methods
```

### Bean Selection
We can also completely avoid bean overriding in certain scenarios using bean selection mechanisms provided by Spring.

If multiple beans of the same type are present and even if they have diff names we can use `@Primary` on one of the bean or use `@Qualifier("")` to specify name of bean to use while autowiring (in this we need to modify existing code though) to prefer a particular bean making things more explicit.

```java
// Beans present of type Foobar class are - foobar, foo, bar
class Service{
	@Autowired
	Foobar fb;		// ambiguous; application startup failure: required a single bean, but 2 were found
}

// resolve the above error just like we resolved ambiguity in interface autowiring: Autowired field name, @Primary, @Qualifier annotations
```

**Usage**: it is often used to override classes (beans) imported from a JAR dependency with custom bean implementation. [Interview Question](/spring-boot/interview/#spring)

## Lazy Initialization
All beans are created and injected into the Application Context during startup. To cut down startup time, we can make it so such that beans are only initialized and injected just before they are used in the code.

1. Global setting in properties file (applies to all beans in the app):
```sh
spring.main.lazy-initialization=true
```

2. or, Specify on `@Configuration` class that has bean definitions or on individual `@Bean`
```java
@Lazy						// specify here; applies to all beans in the class
@Configuration
public class MyCustomBeans{

	@Lazy							// or here
	@Bean
	ServiceA serviceBeanCreator(){
		return new ServiceA();
	}
}
```

We can also make all beans lazy using the properties file and do _@Lazy(false)_ on specific beans to make only them load at startup.

Reference: https://www.baeldung.com/spring-boot-lazy-initialization

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


## Bean Scopes in Spring

Specify scopes on classes using `@Scope` annotation on them. Ex - `@Scope("prototype")` or with constant using 	`@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)`.

- **Singleton** (_default_): single bean instance per Spring IoC container
- **Prototype**: a new bean instance is created every time a bean is requested with `ctx.getBean("Foobar")`
- **Request** (`@RequestScope`): only a single instance will be created and available during the complete lifecycle of an HTTP Request
- **Session** (`@SessionScope`): only a single instance will be created and available during the complete lifecycle of an HTTP Session
- **Application** (`@ApplicationScope`): only a single instance will be created and available during the complete lifecycle of `ServletContext`

_Reference_: Bean Scopes - Selenium Express [YouTube](https://www.youtube.com/watch?v=xpKbs8FHUi4)

## Bean Life Cycle in Spring
1. Start application
2. Spring IoC Container started
3. Bean Constructed and all its dependencies injected into it
4. Bean's `init()` method is called
5. Bean's `@PostConstruct` annotated method is called
6. Use the Bean - call its methods
7. Bean's `@PreDestroy` annotated method is called
8. Bean's `destroy()` method is called

_Reference_: https://javatechonline.com/spring-bean-life-cycle-method-examples/