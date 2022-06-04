+++
title = "OOP"
date =  2022-05-07T21:41:00+05:30
weight = 4
+++

## Concepts
1. Classes - logical entity only, blueprint
2. Object - instance f a class, has a **state, behaviour, and identity**
3. Abstraction - hiding internal details
4. Encapsulation - clubbing data and methods that act on that data together
5. Polymorphism - same name, many forms
6. Inheritance - IS-A relationship

**Why Java isn't a purely OOP language?**: Because a purely OOP language needs to have every data type as an object, and everything we do on those objects must be done via calling methods.

Java fails this criteria because of:
- Primitive types
- Wrapper classes to primitive conversions
- `static` methods and fields as they can be called without an instance

**Smalltalk** is considered the first _purely_ OOP language. While **Simula** is considered the first OOP language.


## Classes & Objects
```java
public class Demo {
    int a = 5; // instance field

    void foo() { // instance method
        return;
    }

    public Demo(int x) {
        a = x;
    }

    public static void main(String[] args) {
        Demo o = new Demo(6);
        System.out.println(o.a); // 6
    }
}
```

## Inheritance
```java
public class Y { }

public class X extends Y { }
```

### Access Modifiers on Members
- when X inherits from Y. Only the `public` and `protected` members (fields and methods) of Y are accessible to X.
- If the two classes are in the same package, then the package (default) members are accessible to X.

### Class Modifiers
- `final` - class can't be extended; leads to compiler error
- `abstract` - may contain absract methods, and requires a concrete subclass to instantiate

### Single v Multiple
- in single inheritance, every class has a single parent (no ambiguity)
- in multiple inheritance, a class can have two or more parents (ambiguous, hence Java doesn't allow it by design with "normal" classes)

### java.lang.Object
All classes in Java inherit from `java.lang.Object` class and it is only class in Java which doesn't have a parent.

The compiler automatically puts the `extends` code that does this inheritance.

### Access Modifiers on Classes
Top-level classes can't be `private` or `protected` (only Nested ones can be). Only one top-level class can be `public` in a .java file.

## this and super References
```java
String name = "John";
//setter
void setFoo(String name){
	name = name;				//set to itself
}
```

In the above case, the name is set to `"John"` since Java thinks we are assigning value to `name` variable itself. Use `this` to solve this issue.

```java
String name = "John";
//setter
void setFoo(String name){
	this.name = name;			// set to instance
}

// we can use this just like a reference variable - pass in method arguments, call methods using it, we can ever use "return this"
```

**super** - just like `this` but used to refer to parent class. 

In inheritance, `this` can access both parent and current (subclass) members, but `super` can only access parent class members. This is trivial as child can access parent data but not the other way round.

## Constructors
- same name as the class
- no return type, not even `void`
- constructors cannot be `abstract`, `final`, or `static`

```java
class Num{
	int n;
	public Num(){
		n = 5;
	}
}
```

- a class can have multiple constructors as long as each constructor's method signature is distinct (**Constructor Overloading**)
- constructor is called during when using `new` and the object is allocated memory after setting the default values acc to constructor
- constructors are not like normal methods in the sense that they can't be called from other constructors and methods without `new`, when we use `new` though, a new object is created in memory

### Default Constructor
Every Java class has a default constructor wheather we code it or not. 

Default constructor has no parameters.

The default constructor is inserted when no explicit constructor is defined.

It is used to provide the default values to the object like `0`, `null`, etc..., depending on the type.

### this()
We can use this to call constructor of current object and not create a new object in memory while doing so.
```java
public Demo(int a, char c){ }	// const 1

public Demo(int b){			// const 2
this(b, 'A');				// calling const 1 here
}
```

**NOTE**: The `this()` call has to be the very first non-comment statement in the constructor body. The side-effect is that there can only be one call to `this()` in any constructor.

**Cyclic constructor calls**: When there is only one constructor and we use `this()` inside it, it is similar to infinite loop but here compiler throws error.
```java
public Demo(int a){
	this(4);		// compiler error
}

public Demo(int a){
	this();			// compiler error
}
```

### super()
Calls direct parent's construtor. Any constructor that matches argument is called if multiple are present.

The first call in any constructor has to be `super()` or `this()`, always. Java compiler inserts an empty `super()` call if they aren't there!

The problem arises when there is no default constructor in parent class and we allow compiler to insert `super()` call in subclass. It doesn't compiler since no matching constructor is found in parent.

```java
class X{
	public X(int a){ }
}

class Y extends X{ }

// in Y, super() is inserted by compiler and called, but X only has a parameterized constructor and no empty constructor (not even default constructor)
// compiler error ensues
```

### Private Constructors

When a constructor is made private, it can't be called from other class, this means that we won't be able to instantiate the class from any other class. And since a constructor is present, the default one won't be generated by Java too.

---

## Instantiation

### Creating objects
```java
// 1. using new
Demo o = new Demo();

// 2. using newInstance()
Demo o = (Demo)Class.forName("com.test.Demo").newInstance();

// 3. using clone()
Demo o1 = new Demo();
// creating clone of above object
Demo o2 = (Demo)o1.clone();

// 4. Deserialization -> reading object from saved state in a file
FileInputStream file = new FileInputStream(filename);
ObjectInputStream in = new ObjectInputStream(file);
Object obj = in.readObject();
```

### Initializing Objects
```java
// 1. By reference variable
Demo o = new Demo();
o.a = 1;
o.b = 2;

// 2. By a non-constructor method
// 3. By a constructor, default or user-defined
```

### Anonymous Objects
```java
foobar(new Demo());		// initialized but not stored in a reference variable
```

### Order of Initialization
1. Class (inline, static block) -> happens only once
2. Local Method Flow 
3. Instance (inline, instance initializer block of super, constructor super(), instance initializer block of this, constructor this()) -> upon object creation using `new`. 

Notice that even if we call constructor of subclass in `new`, still after `super()` finishes, instance initializer block of this runs before `this()` is resumed. Example below.

For same type of blocks, order of apperance is tie-breaker.

```java
class GiraffeFamily {
    static {
        System.out.print("A");
    } {
        System.out.print("B");
    }

    public GiraffeFamily(String name) {
        this(1);
        System.out.print("C");
    }

    public GiraffeFamily() {
        System.out.print("D");
    }

    public GiraffeFamily(int stripes) {
        System.out.print("E");
    }
}
public class Okapi extends GiraffeFamily {
    static {
        System.out.print("F");
    }

    public Okapi(int stripes) {
        super("sugar");
        System.out.print("G");
    } {
        System.out.print("H");
    }

    public static void main(String[] grass) {
        new Okapi(1);
        System.out.println();
        new Okapi(2);
    }
}

//Output: AFBECHG
//		  BECHG
```

### Initializing Classes
- Class initialization - sets default values to all its `static` members
- It is initialized atmost once, and may never get initialized at all if it is not used anywhere in program
- JVM controls when the class is "loaded" (another term for class initialization) during runtime

Rules: 
1. If class X has a parent class Y, then Y is loaded first
2. All `static` member declarations are initialized in order of appearance
3. All `static` blocks are executed in order of appearance

```java
class Y{
	static {System.out.print("A");}
}

class X extends Y{
	public static void main(String args[]){
		System.out.print("C");
		new X();
		new X();
		new X();
	}

	static {System.out.print("B");}
}

// Output: ABC (exactly once)

// if we move main() from class X to another "friend" class Z
class Z{
	public static void main(String args[]){
		System.out.print("D");
		new X();
	}
}

//Output: DAB (exactly once)
```

### final Variables

`final` variables of the three types:
1. Class -> must be initialized exactly once during class initialization
2. Instance ->  must be initialized exactly once before the **first constructor** finishes (example below)
3. Local -> initialization isn't neccessary but accessing without it will be compiler error

If constructor chaining is there, make sure every `final` instance variable is initialized before we exit the chain
```java
class Demo{
	final int a;
	final String b;

	public Demo(String s){		// c1
		this.a = 5;	
	}

	public Demo(){				// c2
		this.b = "John";
	}
}

// c1 fails to set value for b so compiler error
// c2 also fails to set value for a
```

## Inheriting Members

### Overriding Methods
When method is a child class have the same signature as in the parent class. (Signature = name + parameter list)

```txt
Rules:
1. Must be exact same signature (name + parameter list)
2. Must be atleast as accessible or more in child class
3. The method in child doesn't declare a checked exception that is new or broader than one in parent class
4. If method returns a value, it must be same or subtype of method in parent class

If the method in parent is private and thus not accessible, then any of the above rules don't matter since its not overriding.
```

**Covariant return types**: Rule 4 above. `CharSequence` can be overriden by `String` type (narrower) but not the other way round since `CharSequence` is parent interface of `String` class. **NOTE - This is NOT AUTOBOXING or UNBOXING** unlike Overloading.


Overriding a method replaces the parent method on all reference variables except `super`:
```java
public class MyClass {
    int a = 8;
    public static void main(String args[]) {
     C x = new C();
	 P y = x;
	 x.foo();	
	 y.foo();
    }
}
class P{
	 void foo(){
	    System.out.println("A");
	}
}
 class C extends P{
      void foo(){
	    System.out.println("B");
	}
}

//Output: BB
```
### @Override Annotation
we can write a `@Override` on top of methods we are overriding and Java lets us know at compile time if no methods matching it is found in parent class. When everything goes fine, it doesn't impact code in any way.

```java
class X{
	public int foo(char c){
		return 1;
	}
}

class Y extends X{
	public int foo(){
		return 2;
	}
}

// no compiler error unless we place a "@Override" atop Y's foo()
```
### static Method Hiding
`static` methods are never inherited and thus if we try to override them, we will have to follow same 4 rules as overriding, a static method is bound to class so it will depend on the reference we use to call it. **They can't be overriden though**, only hidden.

No compilation if one is marked `static` and the other is not.

```java
public class MyClass {
    int a = 8;
    public static void main(String args[]) {
     C x = new C();
	 P y = x;
	x.foo();	
	y.foo();
    }
}
class P{
	static void foo(){
	    System.out.print("A");
	}
}
 class C extends P{
     static void foo(){
	    System.out.print("B");
	}
}

//Output: BA 
```

### Hiding Variables
Defining a variable with the **same name** as in parent class.

Hiding a variable only replaces the parent variable on child reference and not parent's unlike Overriding.
```java
class P{
	int a = 1;
}

public class C extends P{
	int a = 8;

	public static void main(String[] args){
		C x = new C();
		P y = x;
		System.out.println(x.a);		// 8
		System.out.println(y.a);		// 1
	}
}
```

### final Methods
We cannot override or hide a method declared using `final` in the parent class.

This applies to inherited methods only. Remember how we can mark methods as `private` and no overriding can happen. So a method can be `private final` and then it can exist in both parent and child independently with the exact same signature.


## Abstract Class
A class that cannot be instantiated and may have `abstract` methods to force overriding by subclasses.

```txt
Rules:
1. only instance methods can be abstract, not variables, constructors, or static methods
2. an abstract method can only be declared in an abstract class or an interface
3. the first non-abstract (concrete) class extending from an abstract one must implement ALL the abstract methods it inherits
4. the 4 method overriding rules are followed here too
``` 

```java
public abstract class Demo{
	public abstract void foobar();		// notice that there is no body and semicolon (;) at the end
}
```

An abstract class can extend from other abstract classes and normal classes too.

An abstract class can implement interfaces without the need to define abstract methods of the interface.

An abstract class can have any members of a typical class like constructors, static members, etc...

**Trivial**: An abstract class can exist without any abstract methods, but an abstract method must exist inside an abstract class or interface only.

```java
public abstract class X{ }		// valid
abstract public class X{ }		// valid
public class abstract X{ }		// invalid
```

Constructors behaves the same as in a normal class. But, they are only called via their subclass constructor using `super()` since we can't instantiate abstract classes by using `new`.

If a class is marked `final abstract`, it doesn't make any sense and is a compiler error.

`static` methods aren't overriden but hidden, so using `static abstract` on methods is also compiler error. We can have normal `static` methods though.

### Concrete Class
The **first class** to extend an abstract class. It has to implement all the abstract methods **inherited to it**.

```java
public abstract class X{
	 abstract void foo();
	 abstract void bar();
}

public abstract class Y extends X{
	void foo(){ }
}

public class Z extends Y{
	void bar(){ }
}

// since Z only inherits bar() as abstract, it only needs to provide implementation for it 
```

## Immutable Objects

Make a class immutable to tighten security and not have to deal with concurrency issues.

- Declare the class as `final` or make all constructors `private`
- Declare all methods as `final private`
- No setters
- No getters must return a reference, only primitives or non-mutable types
- avoid initializing mutable references in constructor, create a defensive copy for them

```java
class X{
	private final List<string> foo = new ArrayList<>();

	public List<String> getFoo(){
		return foo;
	}
}

class Y{
	public static void main(String args[]){
		var obj = new X();
		List<String> bar = obj.getFoo();
		bar.clear();
		bar.add("Malicious Data");
	}
}

// solution : add another getter than pinpoints to element in List
public String getFooElement(int index){
	return foo.get(index);
}
```

```java
// defensive copy
class X{
	private final List<string> foo = new ArrayList<>();

	public X(List<String> foo){
		this.foo = foo;
	}
}

class Y{
	public static void main(String args[]){
		List<String> bar = new ArrayList<>();
		var obj = new X(bar);
		bar.add("Malicious Data");
	}
}

// solution: create a defensive copy in constructor
	public X(List<String> foo){
		this.foo = new ArrayList<String>(foo);
	}
```