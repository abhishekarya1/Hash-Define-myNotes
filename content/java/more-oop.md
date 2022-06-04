+++
title = "More OOP"
date =  2022-05-09T20:27:00+05:30
weight = 5
+++

## Interface

Just like abstract classes whose sole-purpose is to get inherited and overriden. They differ as the compiler inserts _implicit modifiers_, don't have a constructor, uses `implements` rather than `extends`

- Interface is `abstract` implicitly
- All variables are `public static final` implicitly
- All methods are `public abstract` implicitly
- Methods without `private` modifier are always implicity `public` (and not package default)

```java
public interface Demo{
	int a = 5;
	void foobar(){
	}
}

public abstract interface Demo{
	public static final int a = 5;
	public abstract void foobar(){
	}
}
```

- An interface can extend from other interfaces, multiple also
```java
public interface Demo extends Foo, Bar {	}		// Foo and Bar are interfaces
```

- A class or abstract class can implement more than one interface (multiple-inheritance like behavior) and abstract class doesn't need to define all abstract methods of the interface.
```java
public class X implements Y, Z {	} 		// Y and Z are interfaces
```

- Concrete class (first to implement interface) must **have all abstract methods definition available to it**. Those definitions can come from any superclass of the class implementing the interface.
```java
interface Test{
    public void foo();
}
class Super{
    public void foo(){ }		// implementation in superclass
}
public class MyClass extends Super implements Test {		// subclass inherits a foo() implementation
    public static void main(String args[]) {
    new MyClass();
    System.out.println("Test");
    }
}

// compiles fine
```

```java
interface Test{
    public void foo();
}
class Super{
    public int foo(){ return 1; }		// incompatible return type
}
public class MyClass extends Super implements Test {	// subclass doesn't have a void foo() impl
    public static void main(String args[]) {
    new MyClass();
    System.out.println("Test");
    }
}

// compiler error
```

- If exact same method exists in both interfaces, our concrete class has to implement it with a equal or covariant type otherwise compiler error

```java
interface X{
	int foobar(){
		return 1;
	}
}

interface Y{
	int foobar(){
		return 2;
	}
}

class Z implements X, Y{
	int foobar(){			// override
		return new Integer(3);
	}
}
```

- conflicting explicit modifiers over implicit modifiers are not allowed: we can't make a variable `private` or a method `protected`, etc...

- the 4 methods to override methods still apply to interfaces too

### Interface References
We can use interface reference too apart from parent or child (self) reference. We use this all the time in Collections framework and it hides what kinds of object it actually is. All we are concerned with is that it implements our interface and we can only access methods it implements from our interface. [Example](/java/more-oop/#object-v-reference)

### default Interface Method
To have a `default` method inside an interface that is optional to implement by class implementing the interface.

- declared only inside an interface
- must be marked with `default` and must have a method body
- implicitly `public` (just like any other method in interface)
- cannot be `abstract`, `final`, `static`
- may be overriden by class implemeting the interface
- if two or more default methods are exact same in both interfaces to be implemented by a class, then it should override (just like abstract methods in interface) otherwise compiler error

```java
interface X{
	default int foobar(){
		return 2;
	}
}
```

- call a specific version among the two using `InterfaceName.super.methodName()` as `InterfaceName.methodName()` won't work

### static Interface Methods
- must be marked with `static` and must have a method body
- implicitly `public` (just like any other method in interface)
- cannot be `abstract` or `final`
- it is never inherited and we need to call it with interface name reference (`InterfaceName.methodName()`)

### private Interface Methods
Reduce code duplcation inside Interface: Interface methods can be `private` or `private static`. In the former case, they can only be accessed by other non-static methods within the interface and reduce code redundancy. The latter ones can only be accessed by other all methods within the interface. Both are hidden from the concrete class implementing the interface and from outside using class reference since they are `private` and can only be accessed from within the interface only.

### abstract Method Calls
We can call them too from inside other non-static interface methods.
```java
interface X{
	String foo();
	String bar();

	void foobar(){
		return foo()+bar();
	}
}

// when we call them, there will be an instance of the class implemeting the interface so it's safe
```

### Tip
- All `static` methods and variables (`public static final` implicitly) belong to Class
- All non-static, `default`, `abstract` methods belong to Instance
- `private` methods are accessible only from inside the interface and reduce code redundancy

## Enums
Enumerations: Defines a set of **constants having values** that must be known at compile-time.

```java
public enum Days{ MON, TUE, WED, THURS FRI, SAT, SUN; }		// semi-colon is optional for simple enums

Days s = Days.TUE;
System.out.println(Days.TUE);		// TUE
System.out.println(s == Days.TUE);	// true
```

Enum constants get and `int` value stating from `0` and so on but we can't compare and Enum value to an `int` primitive since Enum is an object type
```java
Days.TUE == 1		// error
```

### values(), name(), and ordinal()
```java
for(var d: Days.values()){
	System.out.println(d.name() + " " + d.ordinal());
}

/*
MON 0
TUE 1
WED 2
...
*/
```

### valueOf()
```java
Days d = Days.valueOf("TUE");	// TUE
```

### Constructor, Fields, and Methods (Complex Enums)
```java
public enum Season{
	WINTER("Low"), SPRING("Medium"), SUMMER("High"); // ; not optional, values always comes before construtors, methods

	private final String expVis;		// field, can be non-final too but bad practice

	private Season(String expVis){		// constructor, always private, runs only on first access to a constant 
		this.expVis = expVis;
	}

	public void printExpVis(){				// method
		System.out.println(expVis);
	}
}

Seaseon s = Season.SUMMER;		// RHS is a constructor call but without "new", LHS is reference variable assignment
Season.SUMMER.printExpVis(); 	// enum method call
s.printExpVis();				// enum method call with reference object
```

### Methods
Enum can have a method at last which can be `abstract` or a method shared by all.
```java
public enum Seasons{
	WINTER { public int getTemp(){ return 5;  } },		// override
	SPRING { public int getTemp(){ return 25; } };		// override
	public abstract int getTemp();						// abstract method (override is a must)
}

public enum Seasons{
	WINTER { public int getTemp(){ return 5;  } },		// override
	SPRING { public int getTemp(){ return 25; } },		// override
	SUMMER, FALL;										// use shared method for these
	public int getTemp(){ return 30; }					// method shared by all (override is optional)
}
```

### Inheritance
- Enums can't be `extend`ed. We also can't create an Enum object with `new`. Since constructors are always `private`
- Enums can `implement` interfaces and they have to define abstract methods of those interfaces


## Sealed Class (Java 17)
A class that restricts which other classes can **directly** extend from it.

```java
sealed class Demo permits Foo, Bar{ }		// sealed parent
final class Foo extends Demo { }			// final child (no inheritance possible)
non-sealed class Bar extends Demo{ }		// non-sealed child (can be inherited by any other classes)
```

### Rules
1. The subclasses declared in a sealed class must exist in the same package (or same named module in diff packages (more on this later))
2. Subclass must extend if it is permitted in a sealed class
3. Every class that extends a sealed class must specify one of the three specifiers `sealed`, `final`, or `non-sealed`

### permits
We can omit the `permits` clause form class definition if:
- Subclass is in the same file as the sealed class
- Subclass is a nested class inside sealed class

### Sealed Interfaces
Same rules as in Sealed Classes. 
- `permits` here applies to classes that implement the interface or other interfaces that extend it.
- since interfaces are always `abstract` implicitly, they can't be marked `final` so only the other two (`non-sealed` and `sealed`) can be applied to interfaces dealing with a sealed interface.

## Records (Java 14)
Records - Auto-generated immutable classes with no setters. (Immutability = Encapsulation). Everything inside of parameter list (instance fields) of a record is implicitly `final` and the record itself is implicitly `final` and cannot be extended or inherited.

We can define our own constructors, methods or constants (`static` only) inside the body.

```java
public record Demo(int foo, String bar){ }
```

A lot is created automatically for the above one line:
- Constructor: In order of appearance of fields
- Getters: one for each field with same name as field
- Object class methods overriden to suit this class: `equals()`,`hashCode()`, `toString()`

Empty records is totally valid (but useless).
```java
public record DemoEmpty(){ }
```

Just like enums, a record can't be extended or inherited but it can implement an interface, provided it defines all the abstract methods.
```java
public interface Foobar{ }
public record Demo(int foo, String bar) implements Foobar{ }
```

### Constructors

**Long Constructor**: Explicitly defining the implicit one. Since every field is `final` in a record, we have to initialize every field in our explicit constructor.

**Compact Constructor**: Modifies **constructor arguments** only and not instance fields directly. **After compact constructor, the implicit long constructor is always called** which sets those values to instance fields.
```java
public record Demo(int foo, String bar){
	public Demo{									// notice no parentheses ()
		bar = bar.substring(0, 1).toUpperCase();			// modification to constructor argument
		if(foo < 0) throw new IllegalArgumentException();	// validation
	}
}
```

**Constructor Overloading** is possible here too and all rules apply. Only the long constructor (explicit or implicit) has the ability to initilalize all fields and hence whatever overloaded constructor we are writing must call `this()` on the first line and if no other constructor is available, the long constructor is called. Do note that we can't change any instance variables after line 1.
```java
public record Demo(int foo, String bar){
	public Demo(String foo, String bar){		// overloaded constructor; notice types
		this(0, foo+bar);
		foo = "John";			// modifies constructor argument
		this.bar = "Doe";		// compiler error
	}
}
```

### Methods, Fields, and Initializers
- Methods Overriding is possible in body
```java
public record Demo(int foo, String bar){
	public int foo(){ return 10; }
	public String toString(){ return "Testing..."; }
}
```
- Non-static fields (instance fields) aren't allowed inside record body (since record instance is supposed to be immutable)
- Instance Initializers aren't allowed since initializaion is possible only via constructor, also no instance fields exist acc to above rule so no point of instance initializer blocks

## Nested Classes
Class within another class.

1. **Inner Class**: non-static type defined at member level
2. **Static Nested Class**: static type defined at member level
3. **Local Class**: class defined within a method body
4. **Anonymous Class**: local class with no name

Since nested classes are defined at member level in another class, it can be `public`, package access, `protected` and `private` just like other members and unlike top-level classes.

Inner classes can even access `private` members of its outer class.

Java 16 allowed `static` methods inside nested inner class which was not allowed before. Now they can exist in any of the 4 nested class types.


### Instantiation
```java
// from within outer class
class Out{
	class In{	}
	
	void createObj(){
		var obj = new In();
	}
}

// from out of both classes
class Out{
	class In{
		void say(){ }
	}
}
class My{
public static void main(String args[]){
	Out o = new Out();
	In i = o.new In();					// new syntax
	i.say();
	}
}

//we can also use
new Out().new In().say();


// class files for nested classes
Out.class
Out$In.class
```

### static Nested Class
Since nested classes are also considered as members of the outer, we can't initialize non-static inner classes this way:
```java
class Out{
	class In{ }				// non-static member
		public static void main(String args[]){
			new In();		// error; accessing non-static from static context
		}
}

class Out{
	class In{ }
		public static void main(String args[]){
			Out o = new Out();
			o.new In();		// instance reference provided; no errors
		}
}
```

But `static` inner classes can be instantiated without a instance reference:
```java
class Out{
	static class In{ }
		public static void main(String args[]){
			new In();		// no error since we are accessing from static context
		}
}
```

### Local Class
Since they are local to a method, just like local variables, their lifetime is only the scope of the method, i.e. they go out of scope after method scope is over. We can return a reference to object in heap though.

They don't have any access modifiers.

They can access all members of the enclosing class (ofc!).

They can **only access** `final` **and effectively final local** variables.

```java
void foo(){
	final int a = 5;
	int b = 6;
	int c = 7;
	class In{
		void bar(){ System.out.println(a+b+c); }		// error; c isn't final or effectively final
	}

	c = 8;
}
```

Since there are two class files created for each class by compiler, there is no way a class can access another class's method's local variables, so compiler created a copy with same value for local class too but it will not work if the value keeps changing.

### Anonymous Class
Local class but it doesn't have a name. Ends with a semi-colon (`;`) since its a one-liner variable declaration only.
```java
Demo d = new Demo(){
 int getCost(){ return 5; }
};
```

We can't extend and implement at the same time (unlike other nested classes incl. Local class). And when doing either one also, we don't use `extends` or `implements` keywords.

```java
abstract class Demo(){ }
Demo o = new Demo(){ };		// extends

interface Demo(){ }
Demo o = new Demo(){ };		// implements
```

## Polymorphism

### Object v Reference
```java
public class X{
	public char foo(){
		return 'A';
	}
}

public interface Y{
	public abstract char bar(); 
}

public class Z extends X implements Y{
	char n = 'C';
	char bar(){ return 'B'; }
}

Z o = new Z();				// self ref
o.bar();					// B
System.out.println(o.n);	// C

Y p = o;					// interface ref
p.bar();					// B
p.n;						// error

X q = p;					// parent ref
System.out.println(o.n);	// error
q.foo();					// A
q.bar();					// error

// Only one object was created in heap memory, but we see so many access levels depending on ref variable we use to access it
```

### Casting Objects
```java
Parent p = new Parent();
Child c = p;	// error; incompatible types: Parent cannot be converted to Child

// Casting
Child c = new Child();

Parent p = c;		 // implicit cast to supertype, storing in ref of Parent

Child c2 = p;		 // error (can't cast from super type to subtype even if object is Child's)

Child c3 = (Child)p; // explicit cast to subtype; p is Child's object only, but stored in ref of Parent, that's why this explicit cast works otherwise error

// a ClassCastException is thrown at runtime if they're not compatible and explicit cast is used like in the above example

// compiler throws error on unrelated type casts like in the below example
class Foo{ }

class Bar{
	public static void main(String args[]){
		Foo o1 = new Foo();
		Bar o2 = (Bar)o1;			// error; unrelated class objects
	}
}
```

### Casting Interfaces
While holding a reference to a class object its not possible to tell if its compatible with an interface reference since some subclass might be implementing that interface, so identifying bad casts at compile-time isn't possible with interfaces. There is one exception to this, it is listed below the following code.
```java
public interface Dog{ }
public interface Canine{ }

public class Wolf implements Canine{ }

Wolf wolf = new Wolf();
Dog dog = (Dog)wolf;		// compiles just fine

// throws ClassCastException at runtime


// EXCEPTION - if class is marked "final" then the compiler will know that there are no possible subclasses that might implement an interface we are casting to, so in that case it leads to a compile-time error
```

### instanceof
```java
// instanceof operator checks for compatible types and returns boolean; prevents ClassCastException at runtime

if(obj instanceof FoobarClass){ }

// applying it to unrelated types leads to compile-time error

// instanceof on null always returns false
null instanceof String
// false
```