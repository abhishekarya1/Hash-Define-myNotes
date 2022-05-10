+++
title = "Functional"
date =  2022-05-10T22:42:00+05:30
weight = 6
+++

## Lambdas
Expressions with no name, a parameter list and returns a value immediately. 
```java
() -> { }

// Both the parantheses and block braces are optional if there is a single parameter and a single return value
a -> true

// Optional to specify types in parameter list
(int a, int b) -> a.getMax()
(a, b) -> a.getMax()

// If braces block is used, then must use return
a -> { return a.canDrink(); }

// some valid declarations
a -> { }
() -> true
a -> a.canDrink()
a -> !a.canDrink()

// invalid ones
String s -> s.toUpperCase()		// no parantheses when type is specified
x, y -> { return x > y; }		// no parantheses when multiple parameters
``` 

**What's the type that this expression returns?** Is it a new "functionType" or something? No, they return a functional interface (interface with a single abstract method). Since a functional interface has a method ready to be overriden, Java associated a lambda expression's return type with that interface type. 

Usually, we would need a class to implement such interface and our method would be implemented inside the class, to call it we have to create an object or we can use an anonymous class. Lambdas can save us from such code.

```java
public interface Properties{
	public int getNumberOfLegs();
}

public class Number implements Properties{
	public int getNumberOfLegs(){
		return 4;
	} 
}

Number num = new Number();
Properties p = num;
p.getNumberOfLegs();

// or provide implementation using anonymous class
Properties num = new Properties(){
	public int getNumberOfLegs(){
		return 4;
	}
};
num.getNumberOfLegs();

// using lambdas
Properties num = () -> 4;
```

**Context**: Lambdas rely a lot on context, so when a lambda is called from a certain place in code, Java has to infer the returned reference type, functional interface the lambda is implementing. Since `var` also relies on context, we can't use them with lambdas.
```java
var v = a -> 2;
```

## Functional Interfaces
All interfaces that follow the "SAM" Rule -> They have a Single Abstract Method.

```java
public interface X { 
	public void foobar();
}
```

We can use an optional `@FunctionalInterface` annotation that will give us a compiler error if the interface is not functional.

An interface maybe empty but if it inherits a single abstract method, it is a functional interface. Also, remember that `default`, `static`, and `private` methods can't be `abstract`.

### java.lang.Object Methods
Since every class in Java extends `java.lang.Object` and it has our three well-known public methods - `toString`, `hashCode`, and `equals`. If an interface has these methods and it gets implemented then these methods will be availlable to the class since it inherits from `Object` class. **So these methods don't count in the SAM rule unless there is a conflict with Object class methods**, in that case its a compiler error.

[Recall](http://localhost:1313/java/more-oop/#interface) (Concrete Class)

This rules only applies to `Object` class methods and not any superclass our implementing class may have.

```java
// compiler error
public interface Soar {
 abstract void toString();		// will cause bad override in class; Object method has incompatible type
}


// not a functional interface
public interface Soar {
 abstract String toString();		// not counted
}

// functional interface
public interface Dive {
 String toString();
 public boolean equals(Object o);
 public abstract int hashCode();
 public void dive();
}
```
