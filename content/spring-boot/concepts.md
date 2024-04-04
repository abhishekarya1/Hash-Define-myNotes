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

_**@Autowired**_ is the annotation that facilitates DI in Spring.

```java
// constructor-based injection: Spring finds Item bean and creates the Store bean using it (by calling this constructor)
private Item item;

@Autowired
public Store(Item item) {
    this.item = item;
}


// setter-based injection: Spring finds Item bean and creates the Store bean using it (by calling this setter)
private Item item;

@Autowired
public setItem(Item item) {
    this.item = item;
}

// field-based injection: inject an item field in Store bean using Reflection API (setField - new Item())
@Autowired
private Item item;
```

{{% notice tip %}}
Since Spring 4.3, classes with a single constructor can omit the `@Autowired` annotation. So we can just use `@RequiredArgsConstructor` (Lombok annotation) and avoid writing a single constructor too.
{{% /notice %}}

### Drawbacks of Field-Based Injection
Field-based injection is slower since it uses Reflection and it can lead to issues like Circular Dependency.

Constructor-based and settter-based injections are recommended. They are more natural from the OOP standpoint too.

_References_: 
- https://www.baeldung.com/inversion-control-and-dependency-injection-in-spring
- https://www.baeldung.com/constructor-injection-in-spring

## AOP
Aspect-oriented Programming (AOP) is a programming (meta-programming) paradigm that complements the OOP paradigm.

We have a separate **Aspect** (similar to class) for each of the common features that our app may need like Transaction, Logging, Security, etc... These features are called **cross-cutting concerns** because all of our main logic classes will need them at some point. Aspects have methods.

Traditionally, these common features would usually require a method call to the class containing the feature logic from our main class. But in AOP can "wrap" our main logic with Aspects. We can specify that we want to call aspect methods before or after the main class logic, we can specify all this in **Aspect Configuation**. 

Spring framework can read the aspect configuration file and call a method from Aspect before executing a method from our main class. After the Aspect method is finished with its execution, the main method can resume. This is how "wrapping" of Aspects is achieved on methods in our main logic.

Classes are free of any code calls since all the "triggers" are specified in the aspect configuration. This alleviates the need to change code calls in class when we need to change something in future. Single point of change = Aspect configuration.

_References_: 

[Java Brains - YouTube](https://youtu.be/QdyLsX0nG30)

[A simple example - StackOverflow](https://stackoverflow.com/a/232918)
