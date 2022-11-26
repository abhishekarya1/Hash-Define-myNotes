+++
title = "Design"
date =  2022-11-25T12:26:00+05:30
weight = 14
+++

## Design Principles
Helps create extensible, maintainable, and understandable code.

**SOLID**:
1. Single Responsibility
2. Open-Close
3. Liskov Substitution
4. Interface Segregation
5. Dependency Inversion/Injection

_Reference_: https://www.baeldung.com/solid-principles

### Liskov Substitution

A superclass should be substitutable by any of its subclasses, without breaking any existing functionality.

We shouldn't need to introduce behaviors in subclass that make it _significantly_ diff from its parent class.

Ex - _Penguin_ is a technically a _Bird_, but it is flightless. We can't replace Bird object with Penguin object and expect things to not break.

```java
// Violation
class Bird {
	void fly(){ }		// assumption that all birds fly
}

class Sparrow extends Bird {
	@Override
	void fly(){
		System.out.println("Ok!");	// makes sense
	} 
}

class Penguin extends Bird {
	@Override
	void fly(){
		throw new AssertionError("I can't fly!");	// can't fly
	}
}

// can't replace Bird object with Penguin object wherever Bird object is being used, since Penguin object's fly() method will break

// Fix
interface Flight {
	void fly();
}

class Bird { }

class Sparrow extends Bird implements Flight {
	@Override
	void fly(){ } 
	// flight capable; makes sense
}

class Penguin extends Bird {
	// doesn't have fly() method; makes sense
}

// Penguin class can be substituted for Bird class now
```

Another example is Electric cars, they're cars without an engine. A `Car` class can have `MotorCar` and `ElectricCar` subclasses, but `ElectricCar` object can't replace wherever `Car` object is used since it won't have `ignition()` method.

{{% notice tip %}}
Liskov Substitution is more about "making sense" rather than our code breaking if it's violated. A subclass inherits all members from its parent so it is a valid substitute for its parent, but as we saw in the penguin example above, it doesn't make any sense to treat a penguin as a "normal" bird. Or an electric car as a "normal" Car.

Other extreme examples - Hotdog as a Dog, Rubber Duck as a Duck, etc...
{{% /notice %}}

**YAGNI**: You Ain't Gonna Need It

**KISS**: Keep It Simple Stupid

**DRY**: Don't Repeat Yourselves


## GoF Design Patterns
**Design Patterns**: guidelines providing solutions to recurring problems and good practices in software.

Design patterns are often called **GoF** (Gang of Four) design patterns because of [the book](https://g.co/kgs/RzdfZ2) that first outlined these design patterns 20 years ago, named so because of its 4 authors. 

3 types of Design Patterns:
1. **Creational** (_how to create objects or a group of related objects_)
2. **Structural** (_how objects use each other, their composition_)
3. **Behavioral** (_assignment of responsibilities between the objects_)

_Reference_: https://www.programcreek.com/java-design-patterns-in-stories

### Creational
- **Factory**: Class that provides an object we want
- **Abstract Factory**: Class that provides an object of a factory, which in turn can provide the object we want (a factory of factories)
- **Singleton**: Only a single object of this class can exist
- **Builder**: Build objects incrementally; using `builder()` static method and setters that return `this` placed inside the Class
- **Prototype**: Clone an object multiple times and each time we can slightly modify its members

### Anti-Patterns
_Reference_: https://sourcemaking.com/antipatterns