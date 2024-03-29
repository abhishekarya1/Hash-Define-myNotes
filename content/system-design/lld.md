+++
title = "Low Level Design"
date = 2022-11-28T21:35:00+05:30
weight = 1
+++

## Programming Languages

### Paradigms
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

### Typing
Programming Languages can be put into the following categories:

Based on variable's type:
- **Dynamically Typed** - (aka _Duck Typing_) variables have no fixed type, can assign/reassign at runtime with any value of any type
- **Statically Typed** - variables have a type either inferred (by type inference - `auto` in C++ or `var` in Java, Go, TypeScript) or an explicitly defined type. Type must be known at compile-time.

```py
# python - dynamic typed
a = 5
print(type(a))	# int
a = "five"
print(type(a))	# str
```

```js
// js - dynamic typed
let a = 5;
console.log(typeof a);	// number
a = "five";
console.log(typeof a);	// string
```

```java
// java, c, cpp - static typed
int a = 5;
a = "five";		// invalid; compiler-error
```

```go
// go - static typed, inference can make it look like dynamic typed but its not
var a int = 5
var b = 5
c := "five"
```

Based on variable's value casting at runtime:
- **Strongly Typed** - type casts don't happen implicitly at runtime, any conversion must be explicit
- **Weakly Typed** - (aka _Loosely Typed_) type casts at runtime can happen implicitly, no restrictions (crazy behavior!)

```py
# python - strong typed
a = 5 + "five"		# TypeError
```

```js
// js - weak typed
let a = 5 + "five";		// valid
```

The [lines are blurry](https://en.wikipedia.org/wiki/Strong_and_weak_typing#:~:text=However%2C%20there%20is%20no%20precise%20technical%20definition%20of%20what%20the%20terms%20mean%20and%20different%20authors%20disagree%20about%20the%20implied%20meaning%20of%20the%20terms%20and%20the%20relative%20rankings%20of%20the%20%22strength%22%20of%20the%20type%20systems%20of%20mainstream%20programming%20languages.) with Strong and Weak typing. Examples: 
- while all of the following are strongly typed, in Java `int` to `boolean` cast isn't possible, either explicitly or implicitly. But C, C++, Python allows cast from other types to `bool`
- C and C++ also allow other casts which make them weaker than Java and Python.

Also Java has overloaded `+` operator by default that allows adding other types to a `String`!
```java
// java - strong typed, but one exception
String a = 5 + "five";		// valid
```

**Summary**:
{{% notice note %}}
Dynamic - variables don't have fixed type, we can put literal of any type in it (no type checking at compile-time, often there is no compile-time xD)

Weak - variable values don't have fixed types (can be casted implicitly at runtime)
{{% /notice %}}

```txt
C/C++ 		- static, strong (weaker than Java though)
Java 		- static, strong
Go  		- static, strong
TypeScript  - static, strong

Python 		- dynamic, strong

JavaScript  - dynamic, weak
PHP		    - dynamic, weak
Shell 		- dynamic, weak
```

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

_Reference#1_: https://www.programcreek.com/java-design-patterns-in-stories

_Reference#2_: https://java-design-patterns.com

### Anti-Patterns
_Reference_: https://sourcemaking.com/antipatterns