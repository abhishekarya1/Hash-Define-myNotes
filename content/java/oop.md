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