+++
title = "Functional"
date =  2022-05-10T22:42:00+05:30
weight = 6
+++

## Lambdas
Expressions with no name, a parameter list and returns a value immediately. They implement a Functional Interface. 
```java
() -> { }	// no default functional interface provided by Java for this lambda, but we can define "void fun()"

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
x, y -> { return x > y; }		// no parantheses when multiple parameters, also no semicolon to terminate expression
``` 

**What's the return type of Lambdas?** Is it a new "functionType" or something? No, they return (more precisely - implement) a functional interface (interface with a single abstract method). Since a functional interface has a method ready to be overriden, Java associated a lambda expression's return type with that interface type. 

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

**Context**: Lambdas rely a lot on context, so when a lambda is called from a certain place in code, Java has to **infer the returned reference type from the LHS of the assignment (or method signature if lambda is supplied in a method call as argument)** i.e. functional interface the lambda is implementing. 

```java
interface A{
	void foobar(int x);
}

interface B{
	void foobar(int x);
}

A a = (x)->{};		// inferred from LHS
B b = (x)->{};		// inferred from LHS
```

Since `var` also relies on context, we can't use it on LHS of lambda expressions.
```java
var v = a -> 2;		// compiler-error
```

## Functional Interfaces
Interfaces that follow the "SAM" Rule -> They have a Single Abstract Method.

```java
public interface X { 
	public void foobar();
}
```

We can use an optional `@FunctionalInterface` annotation that will give us a compiler error if the interface is not functional.

**An interface maybe empty but if it inherits a single abstract method, it is a functional interface**. Also, remember that `default`, `static`, and `private` methods can't be `abstract` so they don't count when considering SAM rule.

### java.lang.Object Methods
Since every class in Java extends `java.lang.Object` and it has our three well-known public methods - `toString()`, `hashCode()`, and `equals()`. If an interface has these methods and it gets implemented then these methods will be guaranteed availlable to the class since every class inherits from `Object` class. **So these methods don't count in the SAM rule unless there is a conflict with Object class methods**, in that case its a compiler error.

[Recall](http://localhost:1313/java/more-oop/#interface) (pt. regarding Concrete Class)

This rules only applies to `Object` class methods and not any superclass our implementing class may have.

```java
// compiler error
public interface Soar {
 abstract void toString();		// compiler-error; Object method has incompatible type
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
```java
(int a, String b)->{}
(a, b)->{}
(var a, var b)->{}		// totally valid!
(var a, String b)->{}	// compiler-error; need to use var for all
```

Local varibles are scoped to lambda block.
```java
(a, b) -> { int c =0; }

(a, b) -> { int a = 4; }	// redeclaration not allowed
```

Lambdas can always access variables (instance and class variables). They can access only the `final` and effectively final local variables.

## Method References
Exactly like lambdas, they can be used when a lambda calls another method inside of it.

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
Converter methodRef = Math::round;
Converter lambda = x -> Math.round(x);
System.out.println(methodRef.roundFunc(100.1)); // 100

// 2. Calling instance methods of an object (str)
var str = "Zoo";
StringStart methodRef = str::startsWith;
StringStart lambda = s -> str.startsWith(s);
System.out.println(methodRef.beginningCheck("A")); // false

// 3. Calling instance methods of a parameter supplied at runtime (don't confuse with 1)
StringParameterChecker methodRef = String::isEmpty;
StringParameterChecker lambda = s -> s.isEmpty();
System.out.println(methodRef.check("Zoo")); 	// false

//with two params
StringTwoParameterChecker methodRef = String::startsWith;
StringTwoParameterChecker lambda = (s, p) -> s.startsWith(p);
System.out.println(methodRef.check("Zoo", "A")); 	// false

// 4. Constructors
EmptyStringCreator methodRef = String::new;
EmptyStringCreator lambda = () -> new String();
var myString = methodRef.create();
// if we're going to call "new String(param)" inside:
EmptyStringCreatorwithParam methodRef = String::new;	// same method ref as above but call (context) will decide what to do
methodRef.myStrCreator("bar");
```

Since lambdas are more explicit, **all method references can be converted to lambdas but not vice-versa**.
```java
// EX 1
() -> { return 4; }  // can't be written as method ref because it returns a fixed value and doesn't call a method inside

// EX 2
(obj) -> { return obj.marks; }	// we can't access fields with :: operator in a method reference, only methods
// if getMarks() getter isn't available, then we can't write it using method ref

// EX 3

interface StringChecker{
	boolean checker();
}

var str = "";
StringChecker lambda = () -> str.startsWith("Zoo");		// call on object + fixed value inside; no input, returns boolean

StringChecker methodReference = str::startsWith; 	// compiler-error; no way to supply a fixed value ("Zoo") as input
StringChecker methodReference = str::startsWith("Zoo"); // compiler-error; invalid syntax
```
## Built-in Functional Interfaces
```java
T Supplier<T> 				// Takes a nothing and returns a T type
void Consumer<T> 			// Takes a T type and returns nothing
void BiConsumer<T, U> 		// Takes two types and returns nothing
boolean Predicate<T> 		// Takes a type and returns true/false
boolean BiPredicate<T, U> 	// Takes two types and returns true/false
R Function<T, R> 			// Takes a type and returns a type
R BiFunction<T, U, R> 		// Takes two types and returns a type
T UnaryOperator<T> 			// special case of Function; takes single parameter; returns same type
T BinaryOperator<T> 		// special case of BiFunction; takes same type parameters
```

```java
// illustrations

Supplier<String> s1 = String::new;
Supplier<String> s2 = () -> new String();
System.out.println(s1.get()); // Empty string
System.out.println(s2.get()); // Empty string

Consumer<String> c1 = System.out::println;
Consumer<String> c2 = x -> System.out.println(x);
c1.accept("Annie"); // Annie
c2.accept("Annie"); // Annie

BiConsumer<String, Integer> b1 = map::put;
BiConsumer<String, Integer> b2 = (k, v) -> map.put(k, v);
b1.accept("chicken", 7);
b2.accept("chick", 1);
System.out.println(map); // {chicken=7, chick=1}

Predicate<String> p1 = String::isEmpty;
Predicate<String> p2 = x -> x.isEmpty();
System.out.println(p1.test("")); // true
System.out.println(p2.test("")); // true

BiPredicate<String, String> b1 = String::startsWith;
BiPredicate<String, String> b2 = (string, prefix) -> string.startsWith(prefix);
System.out.println(b1.test("chicken", "chick")); // true
System.out.println(b2.test("chicken", "chick")); // true

Function<String, Integer> f1 = String::length;
Function<String, Integer> f2 = x -> x.length();
System.out.println(f1.apply("cluck")); // 5
System.out.println(f2.apply("cluck")); // 5

BiFunction<String, String, String> b1 = String::concat;
BiFunction<String, String, String> b2 = (string, toAdd) -> string.concat(toAdd);
System.out.println(b1.apply("baby ", "chick")); // baby chick
System.out.println(b2.apply("baby ", "chick")); // baby chick

UnaryOperator<String> u1 = String::toUpperCase;
UnaryOperator<String> u2 = x -> x.toUpperCase();
System.out.println(u1.apply("chirp")); // CHIRP
System.out.println(u2.apply("chirp")); // CHIRP

BinaryOperator<String> b1 = String::concat;
BinaryOperator<String> b2 = (string, toAdd) -> string.concat(toAdd);
System.out.println(b1.apply("baby ", "chick")); // baby chick
System.out.println(b2.apply("baby ", "chick")); // baby chick
```
### Convenience Methods on Functional Interfaces
Some `default` interface methods are also provided in the built-in interfaces.
```java
// Consumer calls with .andThen()
Consumer<String> c1 = x -> System.out.print("1: " + x);
Consumer<String> c2 = x -> System.out.print(",2: " + x);
Consumer<String> combined = c1.andThen(c2);
combined.accept("Annie"); // 1: Annie,2: Annie
// notice how same string "Annie" is passed to both; independent processing is there

// Predicate and BiPredicate uses .and() .negate() .or()
Predicate<String> egg = s -> s.contains("egg");
Predicate<String> brown = s -> s.contains("brown");
Predicate<String> brownEggs = egg.and(brown);
Predicate<String> otherEggs = egg.and(brown.negate());

// Function can process independently with .andThen() or in sequence with .compose()
Function<Integer, Integer> before = x -> x + 1;
Function<Integer, Integer> after = x -> x * 2;
Function<Integer, Integer> combined = after.compose(before);
System.out.println(combined.apply(3)); // 8
// before runs first, then after runs
```

### Functional Interfaces for Primitives

We have interfaces for `int`, `double`, `long` and `boolean` those return only the primitive types specified by thier name.

```java
BooleanSupplier		getAsBoolean()		// the only available interface for boolean type

IntSupplier			getAsInt()
DoubleSupplier		getAsDouble()
LongSupplier		getAsLong()

// similarly we have: Consumers, Predicates, Functions, UnaryOperator, BinaryOperator for all three types,

// we also have ToPrimitive function interfaces and PrimitiveToPrimitive ones - 
ToDoubleFunction<T>		// takes in any type, returns double; applyAsDouble()
ToIntFunction<T>		// takes in any type, returns int; applyAsInt()
ToLongFunction<T>		// takes in any type, returns long; applyAsLong()

DoubleToIntFunction		// takes in double, returns int; applyAsInt()
DoubleToLongFunction	// takes in double, returns long; applyAsLong()
IntToDoubleFunction		// takes in int, returns double; applyAsDouble()

// and many more...
```

Notice that generic types are not needed for them as types are part of their names itself now so they're able to deal with primitives as a result of this independence from generic classes.
