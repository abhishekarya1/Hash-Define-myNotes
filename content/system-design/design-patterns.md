+++
title = "Design Patterns"
date = 2024-05-01T18:33:00+05:30
weight = 2
+++

## Introduction
**Design Patterns**: guidelines providing solutions to recurring problems and good practices in software.

Design patterns are often called **GoF** (Gang of Four) design patterns because of [the book](https://g.co/kgs/RzdfZ2) that first outlined these design patterns 20 years ago, named so because of its 4 authors. 

3 types of Design Patterns:
1. **Creational** (_how to create objects or a group of related objects_)
2. **Structural** (_how objects use each other, their composition_)
3. **Behavioral** (_assignment of responsibilities between the objects_)

_Reference#1_: https://www.programcreek.com/java-design-patterns-in-stories

_Reference#2_: https://java-design-patterns.com


## Creational Patterns

### Prototype
Create new object (clone) from an older (prototype) one.

Issues with manually mapping members using getter/setters:
- need to know what members exist in the original object
- any private members (with their getter as `private` too) can't be accessed directly on the object and thus can't be mapped to the new object

```java
interface Prototype {
	Prototype clone();
}

class Student implements Prototype{
	String name;
	int age;

	Student(String name, int age){
		this.name = name;
		this.age = age;
	}

	@Override
	public Prototype clone(){
		return new Student(name, age);
	}
}

// in main()
Student obj = new Student();
Student cloneObj = (Student) obj.clone();
```


### Singleton
Only 1 instance of this class should exist at runtime.

Ways of implementing this pattern:
1. **Eager**: initializing the field inline at class init and returning it everytime in the future
2. **Lazy**: create a new object or returns the existing one depending upon its existence
3. **synchronized method**: only one thread at a time can acess the method; avoids race condition and creation of two objects simultaneously
4. **Double checked locking (synchronized block)**: optimization of the previous approach. Avoid locking everytime with `synchronized` method, instead put `synchronized` block around the object creation code.
	- first check makes sure that if object isn't `null` (already exists) then we don't have to acquire lock
	- second check is there to make sure that object wasn't created by another parallel thread in the duration in which we were waiting to acquire the lock
5. **Enum**: `enum` in Java have only a single object per constant in the entire runtime. Define an `enum` with a single constant and use it as Singleton object.

Make the constructor private (no instance can be made using `new` then).

```java
// 1. Eager
public class DBConnection{
	private static final DBConnection obj = new DBConnection();		// make it final (optional)

	private DBConnection(){ }

	public static DBConnection getInstance(){
		return obj;
	} 
}

// 2. Lazy
public class DBConnection{
	private static DBConnection obj;

	private DBConnection(){ }

	public static DBConnection getInstance(){
		if(obj == null){
			obj = new DBConnection();
		}

		return obj;
	} 
}

// 3. Synchronized Method
public class DBConnection{
	private static DBConnection obj;

	private DBConnection(){ }

	synchronized public static DBConnection getInstance(){
		if(obj == null){
			obj = new DBConnection();
		}

		return obj;
	} 
}

// 4. Double Checked Locking
public class DBConnection{
	private static DBConnection obj;

	private DBConnection(){ }

	public static DBConnection getInstance(){
		// first check
		if(obj == null){
			synchronized(DBConnection.class){
				// second check
				if(obj == null){
					obj = new DBConnection();
				}
			}
		}

		return obj;
	} 
}

// 5. Enum
public enum DBConnection{
	INSTANCE;

	private DBConnection(){ }
}

// in main() create/access the single object
DBConnection obj = DBConnection.INSTANCE;
```

### Factory
Create objects on-the-go by keeping all the object creation logic at one place.

If a change is required in the creation logic in future, then we just need to modify the factory class. Ex - adding a `Rectangle` shape to the below example.

`ShapeFactory` is a concrete class, has a method that returns a `Shape` object - either `Circle` or `Square`.

```java
public class ShapeFactory{
	public static Shape getShape(String name){		// can be non-static too
		if(name.equals("Circle")){
			return new Circle();
		} 
		else if(name.equals("Square")){
			return new Square;
		} 
		else {
			return null;
		}
	}
}

// in main()
Shape obj = Shape.getShape("Square");
```

### Abstract Factory
A factory-of-factory to get factory class instances. It is not merely an _interface_ which factory _class_ implements as the name might suggest.

`AbstractCPUFactory` concrete class gives us the appropriate vendor's factory object (either `IntelFactory` or `AMDFactory`), on which in turn we have to call `getInstance()` to get appropriate `CPU` object. `CPUFactory` is just an interface for both factories.

```java
// Abstract Factory
public class AbstractCPUFactory{
	public CPUFactory getFactoryInstance(String vendor){
		if(vendor.equalsIgnoreCase("Intel")){
			return new IntelFactory();
		}
		else if(vendor.equalsIgnoreCase("AMD")){
			return new AMDFactory();
		}
		else return null;
	}
}

interface CPUFactory{
	public CPU getInstance(int model);
}

class IntelFactory implements CPUFactory{
	@Override
	public CPU getInstance(int model){
		if(model == 5){
			return new corei5();
		}
		else if(model == 7){
			 return new corei7();
		}
		else return null;
	}
}

class AMDFactory implements CPUFactory{
	@Override
	public CPU getInstance(int model){
		if(model == 5){
			return new ryzen5();
		}
		else if(model == 7){
			 return new ryzen7();
		}
		else return null;
	}
}

// in main()
AbstractCPUFactory absFactory = new AbstractCPUFactory();
CPUFactory factory = absFactory.getFactoryInstance("AMD");		// get factory object from abstract factory
CPU obj = factory.getInstance(7);								// get object from factory
```

### Builder
Useful in creating objects in a step-by-step manner. Helps skip initialization of optional fields.

Issues with existing approaches: instead of making a huge constructor with all members as param we can create multiple smaller ones, but now we will face a challenge of constructor redefinitions. Ex - constructor `Foobar(int id, String name)` clashes with overloaded constructor `Foobar(int age, String name)` because of parameter data types and `Foobar` class has all the four members.

A `static` method `builder()` and a non-static method `build()`, every setter method returns `this` object itself.

```java
class Student{
	private int id;
	private String name;
	private int age;

	private Student(){ }		// private constructor; to avoid object creation without builder

	public static Student builder(){
		return new Student();
	}

	public Student setId(int id){
		this.id = id;
		return this;
	}

	public Student setName(String name){
		this.name = name;
		return this;
	}

	public Student setAge(int age){
		this.age = age;
		return this;
	}

	public Student build(){
		return this;
	}

	// define getters to access private members
}

// in main()
Student obj = Student.builder().setId(1).setName("Pinkman").setAge(26).build();
```
## Others
**Adapter** (aka Wrapper) - lets you wrap an otherwise incompatible object in an adapter to make it compatible with another class. 

Create an "adapter" concrete class `AppleAdapter` with the object as property we want to convert from e.g. `Orange` and `extend` this class from `Apple` (target object). The class `AppleAdapter` is of type Apple but has an Orange field such that we can take orange object as input to the constructor and call apple methods on it i.e. treat it as an apple.

Ex - `java.util.Arrays#asList()` adapts `List<>`  to `Array` type.

**Decorator** - much like Adapter Pattern but types we are decorating to-and-from are related (implement a single interface `Troll` or `Girl`). Getter of one calls another's and return values are modified (_decoration_). Ex - `java.util.Collections#synchronizedXXX()` and `java.util.Collections#unmodifiableXXX()`

**Facade** - provide a unified class that initializes a bunch of classes whenever it is initialized. `Computer` class initializes `CPU`, `Memory`, `Display` objects and store it in its properties.

**Observer** - when one object changes state, all its dependents are notified and updated automatically. Ex - `java.util.EventListener` and Project Reactor.

**Strategy** - Situation

## Anti-Patterns
_Reference_: https://sourcemaking.com/antipatterns

## Cheatsheet
**Creational Patterns**: Prototype, Singleton, Factory, AbstractFactory, Builder