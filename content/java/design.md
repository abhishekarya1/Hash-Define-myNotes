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

A superclass should be replacable by any of its subclasses.

We shouldn't introduce behaviors in subclass that make it significantly diff from its parent class. 

Ex - _Penguin_ is a technically a _Bird_, but it is flightless. Another example is Electric cars, they are the only cars without an engine.

```java
// Violation
class Bird {
	void fly(){ }
}

class Sparrow extends Bird {
	// inherits fly(); makes sense
}

class Penguin extends Bird {
	// inherits fly(); but it can't fly! useless method
}

// can't replace Bird with Penguin since it'll have many other properties and behaviors (overriden too) specific to Penguin that will be unusable/illogical if we replace wherever Bird class is used, with Penguin class

// Fix
interface Flying {
	void fly();
}

class Bird { }

class Sparrow extends Bird implements Flying {
	@Override
	void fly(){ } 
	// flight capable; makes sense
}

class Penguin extends Bird {
	// doesn't have fly() method; makes sense
}
```

Another example is a _Quadrilateral_ and a _Square_, the subclass Square can't be substituted for a Quadrilateral because `@Override double area(double side)` method will be wrong for other quads like Rectangles.

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