+++
title = "Software Design & Architecture"
date = 2022-11-28T21:35:00+05:30
weight = 1
+++

## Programming Paradigms & OOP

### Programming Paradigms
{{<mermaid>}}
graph LR;
    A[Programming Languages]
    A --> B[Imperative]
    A --> C[Declarative]
    B --> D[Procedural]
    B --> E[Object-oriented]
    C --> F[Logic]
    C --> G[Functional]
{{< /mermaid >}}

**Structural Languages**: structured into blocks that interact with each other. A method, a class, everything is a code block.

### OOP
Everything is an object and every action must be performed on an object by an object's methods.

**Composition vs Aggregation**: both are associations, former is a _strong_ one, the latter is a _weak_ association.
```java
// composition: one can't exist without another
class Human {
	final Heart heart; 	// final; because we will now need to init it always
	
	Human(Heart heart){		// constructor; must recieve a heart and puts it into human
		this.heart = heart;
	}
}

// aggregation: one can exist independently without the other; no need to provide value to water instance var below
class Glass {
	Water water;
}

// can be made bi-directional too (optional)
class Water {
	Glass glass;
}
```

For cleaner code, functions should be:
- **Pure Functions**: always produce same output for the same input, no side-effects (mutate other resources)
- **Command Query Separation** (CQRS): either perform an action (_command_) on a resource to change its state, or return some data (_query_) back to the caller but not both

## Design Principles
Helps create extensible, maintainable, and understandable code.

### SOLID
1. Single Responsibility
2. Open-Close
3. Liskov Substitution
4. Interface Segregation
5. Dependency Inversion/Injection

_Reference_: https://www.baeldung.com/solid-principles

**Liskov Substitution**:

A superclass should be substitutable by any of its subclasses, without breaking any existing functionality.

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

There is nothing really stopping us from inheriting "Burger" from "Metal" class, but it should make sense is all what Liskov Substitution Principle is all about.
{{% /notice %}}

### Other Principles

**YAGNI**: You Ain't Gonna Need It (_avoid implementing features that "may" be required in future_)

**KISS**: Keep It Simple Stupid

**DRY**: Don't Repeat Yourselves

**Hollywood Principle**: "_Don't call us, we'll call you._" (another name for Inversion-of-Control)

**Encapsulate what varies**:
```java
if (pet.type() == dog) {
	pet.bark();
} else if (pet.type() == cat) {
	pet.meow();
} else if (pet.type() == duck) {
	pet.quack()
}

// instead we can just write
pet.speak();
``` 

**Program against abstractions**: program by keeping interfaces and their relations and interactions in mind. Don't take concrete classes into consideration while designing.

**Composition over Inheritance**: prefer composition rather than inheritance; because it is much less rigid and can be changed later, composition also allows multiple inheritance like relation which Java doesn't allow on concrete classes
```java
// an Employee is a Person, and a Manager is both

// with inheritance
class Person { }
class Employee extends Person { }

class Manager extends Person, Employee { } 	// can't do this; multiple-inheritance
class Manager extends Employee { }			// so we do this

// with composition
class Person { }

class Employee {
	Person p;		// Employee has Person object

	Employee(Person p){
		this.p = p;
	}
}

Person p = new Person();
Employee e = new Employee(p);

class Manager {
	Person p;
	Employee e;		// Manager has both Employee and Person objects

	Manager(Person p, Employee e) {		
		this.p = p;
		this.e = e;
	}
}

Manager m = new Manager(p, e);
```

---
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
- **Builder**: Build objects incrementally; using `builder()` static method and setters that return `this`, placed inside the Class
- **Prototype**: Clone an object multiple times and each time we can slightly modify its members

### Structural
- **Adapter**: an additional adapter class can be created to make two incompatible classes compatible with each other  
- **Bridge**: separate abstraction from its implementation (interface and its concrete class), the interface of one contains interface member of another
- **Composite**: a tree structure, all nodes have a common method that can show node description
- **Decorator**: instead of making class for every type of a thing, just create a decorator class by extending the base class, then we can provide a base object to this decorator and it can then act



### Anti-Patterns
_Reference_: https://sourcemaking.com/antipatterns