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
a -> { return a.canDrink(); };

// some valid declarations
a -> { }
() -> true
a -> a.canDrink()
a -> !a.canDrink()

// invalid ones
String s -> s.toUpperCase()		// no parantheses when type is specified
x, y -> { return x > y; }		// no parantheses when multiple parameters, also no semicolon to terminate expression
``` 

**What's the return type of Lambdas?** Is it a new "functionType" or something? No, they return a functional interface (interface with a single abstract method). Since a functional interface has a method ready to be overriden, Java associated a lambda expression's return type with that interface type. 

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
Properties num = () -> 4;		// implementation
num.getNumberOfLegs();			// explicit call
```

**Context**: Lambdas rely a lot on context, so when a lambda is called from a certain place in code, Java has to infer the returned reference type from the LHS of the assignment, functional interface the lambda is implementing. Since `var` also relies on context, we can't use them with lambdas.
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

[Recall](http://localhost:1313/java/more-oop/#interface) (pt. regarding Concrete Class)

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

### Variables in Lambdas
Must have the parameter list - with types, without types, all with `var`.

Local varibles are scoped to lambda block.
```java
(a, b) -> { int c =0; }

(a, b) -> { int a = 4; }	// redeclaration not allowed
```

Lambdas can always access variables (instance and class variables). It can access only the `final` and effectively final local variables.

## Methods References
Exactly like lambdas, they can be used when a lambda takes in a single parameter and calls another method inside of it.

```java
interface Test{
	void display(int x);
}

Test t = a -> { System.out.println(a); };		// lambda
t.display(4);

Test t = System.out::println;					// method reference
t.display(6);
```

Uses the same principle of **defferred execution** wherein execution is defferred till runtime. Its safe to think of method references exactly like lambdas.

### Formats
```java
// 1. Calling static methods
Math::round

// 2. Calling instance methods of a object (obj)
obj::myFoo

// 3. Calling instance methods of a parameter supplied at runtime
String::strMethod
// if we provide a String instance to the method calling it, then it will call strMethod on it:
x.anyFunc("foo");

//with two params
StringTwoParameterChecker methodRef = String::startsWith;
StringTwoParameterChecker lambda = (s, p) -> s.startsWith(p);
System.out.println(methodRef.check("Zoo", "A")); 	// false

// 4. Constructors
String::new
// if we're going to call "new String(param)" inside:
x.myStrCreator("bar");
```

Since lambdas are more explicit, all method references can be converted to lambdas but not vice-versa.

## Built-in Functional Interfaces
```java
T Supplier<T> 				// Takes a T type and returns a T type
void Consumer<T> 			// Takes a T type and returns nothing
void BiConsumer<T, U> 		// Takes two types and returns nothing
boolean Predicate<T> 		// Takes a type and returns true/false
boolean BiPredicate<T, U> 	// Takes two types and returns true/false
R Function<T, R> 			// Takes a type and returns same type
R BiFunction<T, U, R> 		// Takes two types and returns a type
T UnaryOperator<T> 			// special case of Function; takes single parameter
T BinaryOperator<T> 		// special case of BiFunction; takes same type parameters
```
### Convenience Methods on Functional Interfaces

### Functional Interfaces for Primitives