+++
title = "More OOP"
date =  2022-05-09T20:27:00+05:30
weight = 5
+++

## Interface

Just like abstract classes whose sole-purpose is to get inherited and overriden. They differ as the compiler inserts _implicit modifiers_, don't have a constructor, uses `implements` rather than `extends`, and has `default` methods.

- Interface is `abstract` implicitly
- All variables are `public static final` implicitly
- All methods are assumed to be `abstract` implicitly unless they are `default`, `static`, `private`, or `private static`
- All methods are always implicity `public` (and not package default) unless they are `private`
- So, the only methods that can have a body inside an interface are: `default`, `static`, `private`, and `private static`

```java
public interface Demo{
	int a = 5;
	void bar();
	void foo(){ }		// invalid; should've no body
}

public abstract interface Demo{
	public static final int a = 5;
	public abstract void bar();
}
```

- An interface can extend from other interfaces, multiple also. But can't extend classes.
```java
public interface Demo extends Foo, Bar {	}		// Foo and Bar are interfaces
```

- A class or abstract class can implement more than one interface (multiple-inheritance like behavior) and abstract class doesn't need to define all abstract methods of the interface.
```java
public class X implements Y, Z {	} 		// Y and Z are interfaces

public class A extends B implements C, D {	} 		// both inheriting and implementing
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
public class MyClass extends Super implements Test {	// subclass doesn't have a "void foo()" impl
    public static void main(String args[]) {
    new MyClass();
    System.out.println("Test");
    }
}

// compiler error
```

- conflicting explicit modifiers over implicit modifiers are not allowed: we can't make a variable `private` or a method `protected`, etc...

- the 4 methods to override methods still apply to interfaces too

- `this` works in interfaces too despite the fact that they're not classes that have an instance, `super` doesn't work though, we need to specify which parent super to call using `InterfaceName.super`

### Interface References
We can use interface reference too apart from parent or child (self) reference. We use this all the time in Collections framework and it hides what kinds of object it actually is. All we are concerned with is that it implements our interface and we can only access methods it implements from our interface reference. [Example](/java/more-oop/#object-v-reference)

### Properties of an interface
All are implicitly `public static final` and are accessible in implementing class as well as by interface ref (as is the normal behaviour of properties in class inheritance).

```java
interface Demo{
	int a = 5;		// "public static final" implicitly; must initialize inline
}

class Main implements Demo{
	public static void main(String[] args){
		System.out.println(a);			// 5 (inherited)
		System.out.println(Main.a);		// 5 (same as above)
		System.out.println(Demo.a);		// 5
	}
}
```

### default Interface Method
To have a `default` method inside an interface that is optional to implement by class implementing the interface, available to implementing class to call without any ref.

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

class Demo implements X{
	foobar();		// avaliable to class
}
```

- call a specific version among the two using `InterfaceName.super.methodName()` as `InterfaceName.methodName()` won't work

### static Interface Methods
- must be marked with `static` and must have a method body
- implicitly `public` (just like any other method in interface)
- cannot be `abstract` or `final`
- it is **never inherited by other interfaces or goto implementing class** (unlike normal `static` class methods) and we need to call it with interface name (`InterfaceName.methodName()`) since we can't call it using implementing class ref or name. **We can also have the same method defined in our implementing class since they are never inherited so no overriding can happen**.

```java
interface P{
	static void foobar(){ }
}

class Main implements P{
	foobar();		// invalid
	Main.foobar();	// invalid; same as above
	P.foobar();		// valid
}
```

### Overrding an abstract Method with default or static Method
```java
interface P{
    void foo();
}

interface Q extends P{
    default void foo(){ }		// valid; foo gets impl
}

----------------------------------

interface P{
    void foo();
}

interface Q extends P{
    static void foo(){ }		// compiler-error; static method method cannot override an abstract method; since it won't be going to the implementing class anyways even if we accept its impl here
}
```

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

### Tips
- Variables (`public static final` implicitly) of an interface do get inherited by the implementing class, `static` methods don't!
- All non-static, `default`, `abstract` methods do get inherited and belong to Instance
- `private` methods are accessible only from inside the interface and reduce code redundancy
- `this` works inside interfaces too!
- For super, we need to use `InterfaceName.super` since multiple inheritance is allowed in interfaces and we need to know which parent super to call.

## Enums
Enumerations: Defines a set of **constants having values** that must be known at compile-time. 

Internally represented as `class` only, so we can't have a `public class` and a `public enum` together in the same `.java` file.

```java
enum Days{ MON, TUE, WED, THURS FRI, SAT, SUN; }		// semi-colon is optional for simple enums

Days s = Days.TUE;
System.out.println(Days.TUE);		// TUE
System.out.println(s == Days.TUE);	// true
```

Enum constants get and `int` value stating from `0` and so on but we can't compare and Enum value to an `int` primitive since Enum is an object type
```java
Days.TUE == 1		// error; comparing (TUE == 1) doesn't make any sense
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

Simple enums have: name, ordinal

Complex enums have: name, value, ordinal

```java
// bare-minimum complex enum
enum Alphabet {
    A("Z"), 
    B("Y"),
    C("X");

    Alphabet(String a) { }		// mandatory; can only be private or package-access

    // create an instance field and an optional getter to access - "Z", "Y", "X"
}
```
```java
public enum Season{
	WINTER("Low"), SPRING("Medium"), SUMMER("High");	// constructor calls to initialize
	// ; not optional, values always comes before construtors, methods

	public final String expVis;		// optional field to access "Low"/"Medium"/"High", can be non-final too but bad practice

	private Season(String expVis){		// constructor, always private or pacakge-access, runs only on first access to a constant, never runs again 
		this.expVis = expVis;	// set value to enum instance var
	}

	public void getExpVis(){				// getter method
		System.out.println(expVis);
	}
}

Season s = Season.SUMMER;			// RHS is a constructor call but without "new", LHS is reference variable assignment
System.out.println(Season.SUMMER);	 // SUMMER

System.out.println(Season.SUMMER.ordinal());	// 2	

Season.SUMMER.printExpVis(); 	// enum method call

s.getExpVis();					// "High"; enum method call with reference object
s.expVis;						// "High"; enum instance variable direct access
```

### Methods in Enum
Enum can have a method at last which can be `abstract` or a "normal" method shared by all.
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
- Enums can't be `extend`ed or inherited. We also can't create an Enum object with `new`.
- Enums can `implement` interfaces and they have to define abstract methods of those interfaces.

## Sealed Class (Java 17)
A class that restricts which other classes can **directly** extend from it.

```java
sealed class Demo permits Foo, Bar{ }		// sealed parent
final class Foo extends Demo { }			// final child (no inheritance possible)
non-sealed class Bar extends Demo{ }		// non-sealed child (can be inherited by any other classes)
```

### Rules
1. The subclasses declared in a sealed class must exist in the same package (or in same module, they can be under diff packages in that module)
2. Subclass must extend if it is permitted in a sealed class
3. Every class that extends a sealed class must specify one of the three specifiers `sealed`, `final`, or `non-sealed`

### permits
We can omit the `permits` clause from class definition if:
- Subclass is in the same file as the sealed class
- Subclass is a nested class inside sealed class

### Sealed Interfaces
Same rules as in Sealed Classes. 
- `permits` here applies to classes that implement the interface or other interfaces that extend it.
- since interfaces are always `abstract` implicitly, they can't be marked `final` so only the other two (`non-sealed` and `sealed`) can be applied to interfaces dealing with a sealed interface.

## Records (Java 14)
Records - Auto-generated immutable classes with no setters. (Immutability = Encapsulation). Everything inside of parameter list (instance fields) of a record is implicitly `final` and the record itself is implicitly `final` and cannot be extended.

We can define our own constructors, methods or constants (`static final` only) inside the body.

```java
record Demo(int foo, String bar){ }
```

A lot is created automatically for the above one line:
- Single Constructor with args: In order of appearance of fields - `Demo(int, String)`
- Getters: one for each field with same name as field - `foo()` and `bar()`
- Object class methods overriden to suit this class: `equals()`,`hashCode()`, and `toString()`

Empty records is totally valid (but useless).
```java
record DemoEmpty(){ }
```

Just like enums, **a record can't be extended or inherited but it can implement an interface**, provided it defines all the abstract methods.
```java
public interface Foobar{ }
public record Demo(int foo, String bar) implements Foobar{ }
```

### Constructors

**Long Constructor/Canonical Constructor**: Explicitly defining the implicit one. Since every field is `final` in a record, we have to initialize every field in our explicit constructor.

**Compact Constructor**: Modifies **constructor arguments** only and not instance fields directly. **After compact constructor, the implicit long constructor is always called** with modified params in compact constructor which sets those values to instance fields of record.
```java
public record Demo(int foo, String bar){
	public Demo{									// notice no parentheses ()
		bar = bar.substring(0, 1).toUpperCase();			// modification to constructor argument only
		this.foo = foo;			// compiler-error; foo is final
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
- Methods can exist and method overriding is possible in record body
```java
public record Demo(int foo, String bar){
	public int foo(){ return 10; }
	public String toString(){ return "Testing..."; }
}
```
- Only `static final` fields are allowed in record body, naturally static initializer blocks are allowed too
```java
record Demo(String name, int age){
    static final int marks = 5;
}

--------------------------------------

record Demo(String name, int age){
    static final int marks;

    static { marks = 5; }
}

// access from anywhere using: Demo.marks
```

- Non-static fields (instance fields) aren't allowed inside record body (since they are present in the parameter list), and they have to be `final` for immutability; naturally instance initializer blocks aren't allowed since initializaion is possible only via implicit long constructor, also no instance fields exist so no point of instance initializer blocks

## Nested Classes
Class within another class.

1. **Inner Class**: non-static type defined at member level
2. **Static Nested Class**: static type defined at member level
3. **Local Class**: class defined within a method body
4. **Anonymous Class**: local class with no name

Since nested classes are defined at member level in another class, it can be `public`, package access, `protected` and `private` just like other members and unlike top-level classes.

Inner classes can even access `private` members of its outer class, since it is also a member of it.

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

They don't have any access modifiers except `final` just like local variables.

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
Dog d = new Dog();
Cat c = d;	// error; incompatible types: Dog can't be called a Cat

// Casting
Child c = new Child();

Parent p = c;		 // implicit cast to supertype, storing in ref of Parent

Child c2 = p;		 // error (can't cast from super type to subtype even if object is Child's)

Child c3 = (Child)p; // explicit cast to subtype; p is Child's object only, but stored in ref of Parent, that's why this explicit cast works otherwise compiler error


// a ClassCastException is thrown at runtime if they're NOT COMPATIBLE and explicit cast is used like in the below example
Object i = Integer.valueOf(42);
String s = (String) i;            // ClassCastException thrown here


// compiler throws error on UNRELATED type casts like in the below example
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
public interface FourLegged{ }
public interface Canine{ }

public class Wolf implements Canine{ }

Canine c = new Wolf();					// or Wolf w = new Wolf();
FourLegged dog = (FourLegged)c;			// compiles just fine; even tho both interface are unrelated

// throws ClassCastException at runtime

// in the above case, class Wolf may have a subclass Dog which implements FourLegged interface, in that case above will be valid if "Canine c = new Dog();"
// this is why it is allowed to compile; since that subclass will be both a "Canine" and a "FourLegged" (multiple inheritance using interface)

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