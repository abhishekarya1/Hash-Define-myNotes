+++
title = "Concepts"
date = 2022-06-10T02:05:00+05:30
weight = 6
+++

### Java Bean
It is a standard that has a formal [specification](https://download.oracle.com/otndocs/jcp/7224-javabeans-1.01-fr-spec-oth-JSpec/) (114 pages btw!) too.

It is nothing but a regular class with:
1. a `public` no-args constructor
2. all fields are `private`, use getters & setters
3. implements `java.io.Serializable` interface

### IoC and DI

Inversion of Control (IoC) is a **principle** in software engineering which transfers the control of objects or portions of a program to a container or framework.

In contrast with traditional programming, in which our custom code makes calls to a library, IoC enables a framework to take control of the flow of a program and make calls to our custom code. We extend the classes of the framework or plugin our own classes to achieve this.

Dependency injection (DI) is a **pattern we can use to implement** IoC, where the control being inverted is setting an object's dependencies.

```java
public class Store {
    private Item item;		// Store has an item; dependency

    public Store(Item item) {
        this.item = item;
    }
}
```

_**@Autowired**_ is most commonly used dependency injection, it is a form of "field-based dependency injection", it used Reflection internally and is more costlier than "constructor-based DI" and "setter-based DI".

```java
// constructor-based injection: create a store with item included
return new Store(item);

// setter-based injection: set item to a store
store.setIem(item);

// field-based injection: inject an item field in store using Reflection (set field - new Item())
@Autowired
Item item;
```

_References_: https://www.baeldung.com/inversion-control-and-dependency-injection-in-spring

### AOP
Aspect-oriented Programming (AOP) is a programming (meta-programming) paradigm that complements the OOP paradigm.

We have a separate **Aspect** (similar to class) for each of the common features that our app may need like Transaction, Logging, Security, etc... These features are called **cross-cutting concerns** because all of our main logic classes will need them at some point. Aspects have methods.

Traditionally, these common features would usually require a method call to the class containing the feature logic from our main class. But in AOP can "wrap" our main logic with Aspects. We can specify that we want to call aspect methods before or after the main class logic, we can specify all this in **Aspect Configuation**. 

Spring framework can read the aspect configuration file and call a method from Aspect before executing a method from our main class. After the Aspect method is finished with its execution, the main method can resume. This is how "wrapping" of Aspects is achieved on methods in our main logic.

Classes are free of any code calls since all the "triggers" are specified in the aspect configuration. This alleviates the need to change code calls in class when we need to change something in future. Single point of change = Aspect configuration.

_References_: 

[Java Brains - YouTube](https://youtu.be/QdyLsX0nG30)

[A simple example - StackOverflow](https://stackoverflow.com/a/232918)
