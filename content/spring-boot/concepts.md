+++
title = "Concepts"
date = 2022-06-10T02:05:00+05:30
weight = 6
+++

## Java Bean
It is a standard that has a formal [specification](https://download.oracle.com/otndocs/jcp/7224-javabeans-1.01-fr-spec-oth-JSpec/) (114 pages btw!) too.

It is nothing but a regular class with:
1. a `public` no-args constructor
2. all fields are `private`, use getters & setters
3. implements `java.io.Serializable` interface

## IoC and DI

Inversion of Control (IoC) is a **principle** in software engineering which transfers the control of objects or portions of a program to a container or framework.

In contrast with traditional programming, in which our custom code makes calls to a library, IoC enables a framework to take control of the flow of a program and make calls to our custom code. We extend the classes of the framework or plugin our own classes to achieve this.

Dependency injection (DI) is a **pattern we can use to implement** IoC, where the control being inverted is setting an object's dependencies.

```java
public class Store {
    private Item item;		// Store has an item; dependency

    public Store(Item item) {   // set item using constructor
        this.item = item;
    }

    public setItem(Item item){  // or set item using setter
        this.item = item;
    }
}
```

_**@Autowired**_ is the annotation that facilitates DI in Spring. It is placed in the class in which we want to inject beans, either on field, setter, or constructor.

```java
// field-based injection: Spring directly injects an Item bean to item field in Store bean using Java Reflection API (setField - new Item())
@Autowired
private Item item;


// constructor-based injection: Spring finds Item bean and creates the Store bean (by calling this constructor)
private Item item;

@Autowired
public Store(Item item) {
    this.item = item;
}

// optional dependencies can be handled by using the annotation for constructor args
private final Item item;
private Foobar foobar;

@Autowired
public Store(Item item, @Autowired(required = false) foobar) {
    this.item = item;
    this.foobar = foobar;   // sets supplied bean; otherwise null
}


// setter-based injection: Spring finds Item bean and sets the field value in the Store bean (by calling this setter)
private Item item;

@Autowired
public setItem(Item item) {
    this.item = item;
}
```

{{% notice tip %}}
Since Spring 4.3, classes with a single constructor can omit the `@Autowired` annotation on the constructor.
{{% /notice %}}

### Drawbacks of Field-Based Injection
1. **Field-based injection is slower**: it uses Reflection internally which is slower than other ways of injection.

2. **Makes it harder to write tests**: if the class under test has other class dependencies (composition), we often use `@InjectMocks` to inject mocked instances of those dependencies into the instance of class under test. A better way is to create dependency class instances manually and pass them calling the injected class's constructor (or setter) so that there is no `NullPointerException` later on when the dependency's method is called in the test run (no early detection of `null` dependencies).

3. **Circular dependencies issue**: there is no way for early detection of circular dependencies if we use field-based injection. Such circular code leads to application startup error.

Constructor-based and settter-based injection is recommended. They are more natural from the OOP standpoint too since they don't use any Spring Boot "magic" (reflection).

_References_: 
- https://www.baeldung.com/inversion-control-and-dependency-injection-in-spring
- https://www.baeldung.com/constructor-injection-in-spring
- Sivalabs - Avoid using Field Injection - [YouTube](https://www.youtube.com/watch?v=koxu51eqDiQ&t=1137s)

## AOP
Aspect-oriented Programming (AOP) is a programming (meta-programming) paradigm that complements the OOP paradigm.

We have a separate **Aspect** (similar to class) for each of the common features that our app may need like Transaction, Logging, Security, etc... These features are called **cross-cutting concerns** because all of our main logic classes will need them at some point. Aspects have methods.

Traditionally, these common features would usually require a method call to the class containing the feature logic from our main class. But in AOP can "wrap" our main logic with Aspects. We can specify that we want to call aspect methods before or after the main class logic, we can specify all this in **Aspect Configuation**. 

Spring framework can read the aspect configuration file and call a method from Aspect before executing a method from our main class. After the Aspect method is finished with its execution, the main method can resume. This is how "wrapping" of Aspects is achieved on methods in our main logic.

Classes are free of any code calls since all the "triggers" are specified in the aspect configuration. This alleviates the need to change code calls in class when we need to change something in future. Single point of change = Aspect configuration.

_References_: 

[Java Brains - YouTube](https://youtu.be/QdyLsX0nG30)

[A simple example - StackOverflow](https://stackoverflow.com/a/232918)
