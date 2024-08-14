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

**Functional Paradigm**: follows Lambda Calculus, and functions are first-class citizens (function can be an object) which allows for Higher Order Functions (HOF) i.e. functions that take other function objects are arguments.

### Typing
Programming Languages can be put into the following categories:

Based on variable's type:
- **Dynamically Typed** - (aka _Duck Typing_) variables have no fixed type, can assign/reassign at runtime with any value of any type
- **Statically Typed** - variables have a type either inferred (by type inference - `auto` in C++ or `var` in Java, Go, TypeScript) or an explicitly defined type. Variable's type must be known at compile-time.

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
- C and C++ also allow other casts which make them weaker than Java and Python

Also Java has overloaded `+` operator by default that allows adding other types to a `String`! (an exception)
```java
// java - strong typed, but one exception
String a = 5 + "five";		// valid
```

**Summary**:
{{% notice note %}}
**Dynamic** - variables don't have fixed type, we can put literal of any type in it (no type checking at compile-time, often there is no compile-time xD)

**Weak** - assigned literal values to variables don't have fixed type (can be implicitly casted at runtime depending on usage context)
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

[OOP Concepts - Notes](/java/oop/#concepts)

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

Note that in Composition we can also instantiate the `new Heart()` object inside the class itself (either inline or inside the constructor) such that it gets created automatically when `Human` class is initizalized and/or instantiated, but such code need not be present in case of Aggregation.

For cleaner code, functions should be:
- **Pure Functions**: always produce same output for the same input, no side-effects (mutate other resources)
- **Command Query Separation** (CQRS): either perform an action (_command_) on a resource to change its state, or return some data (_query_) back to the caller but not both

## Design Principles
Helps create extensible, maintainable, and understandable code.

### SOLID
1. Single Responsibility
2. Open/Closed (OXCM)
3. Liskov Substitution
4. Interface Segregation
5. Dependency Inversion

_Reference_: https://www.baeldung.com/solid-principles

1. **Single Responsibility**: a class should have only one reason to change; do one thing and do it well.

Ex - `Invoice` class can be split into the following three classes:
- `Invoice` class - main entity
- `InvoicePrinter` class - to print entity values to the console
- `InvoiceDAO` class - to persist entity values into a database

Code:

```java
class Invoice{
	// members
	long id;
	int price;

	// constructor
	Invoice(long id, int price, int discount){
		this.id = id;
		this.price = price - (price * discount / 100);
	}

	// methods
	void printInvoice(){
		System.out.println("Invoice: " + id + ", and price = " + price);
	}

	void saveInvoiceToDB(){
		// save to DB logic
	}
}
```

**Problem**: The above class can change because of multiple reasons such as changes in database storing logic, or price discount calc (e.g. adding GST taxation). 

A better way to write the above class without violating SRP by splitting functionality across multiple classes is:

```java
class Invoice{
	// members
	long id;
	int price;

	// constructor
	Invoice(long id, int price, int discount){
		this.id = id;
		this.price = price - (price * discount / 100);
	}

}

class InvoicePrinter{
	Invoice invoice;

	InvoicePrinter(Invoice invoice){
		this.invoice = invoice;
	}

	void print(){
		System.out.println("Invoice: " + invoice.id + ", and price = " + invoice.price);
	}
}

class InvoiceDao{
	Invoice invoice;

	InvoiceDao(Invoice invoice){
		this.invoice = invoice;
	}

	void saveToDB(){
		// save to DB logic
	}
}

// in main()
Invoice invoiceObj = new Invoice(1L, 100, 50);
InvoicePrinter invoicePrinterObj = new InvoicePrinter(invoiceObj);
invoicePrinterObj.print();
```

In the example above, we can also avoid composition and supply `Invoice` object directly as a method parameter `void print(Invoice invoiceObj){ }` just as we do in Controller, Service, and Repository layers in SpringBoot appication.

2. **Open/Closed**: add functionality by extending and not modifying the code directly.

Ex - implement new functionality so that we can save invoices to a file in a filesystem (FS) as well

```java
class InvoiceDao{
	Invoice invoice;

	InvoiceDao(Invoice invoice){
		this.invoice = invoice;
	}

	void saveToDB(){
		// save to DB logic
	}

	void saveToFile(){				// added new method in existing class (VIOLATION!)
		// save to file logic
	}
}
```

```java
class InvoiceDaoFS extends InvoiceDao{
	Invoice invoice;

	InvoiceDao(Invoice invoice){
		this.invoice = invoice;
	}

	void saveToFile(){				// added new method in new class extending existing DAO
		// save to file logic
	}
}
```

3. **Liskov Substitution**: a superclass should be substitutable by any of its subclasses, without breaking any existing functionality. This is possible only if the subclass _adds_ new behaviour on top of its superclass and _not narrows it down_.

Ex - _Penguin_ is a technically a _Bird_, but it is flightless. We can't replace Bird object with Penguin object and expect things to not break in the way the below example is written.

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
		throw new AssertionError("I can't fly!");	// can't fly; narrows down superclass behaviour
	}
}
```
We can't replace `Bird` object with `Penguin` object wherever `Bird` object is being used, since `Penguin` object's `fly()` method will break, whenever we call it (try to fly). A possible fix is to refactor the code as shown below:
```java
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

Another example is electric car as it doesn't have an engine. A `Car` class can have `MotorCar` and `ElectricCar` subclasses, but `ElectricCar` object can't replace wherever `Car` object is used since it'll return `NullPointerException` when instance member `engine` is accessed as `engine == null` for `ElectricCar` instance.

{{% notice tip %}}
Liskov Substitution is also about "making sense" rather than our code breaking if it's violated (narrow down superclass). A subclass inherits all members from its parent so it is a valid substitute for its parent, but as we saw in the penguin example above, it doesn't make any sense to treat a penguin as a "normal" bird. Or an electric car as a "normal" Car.

Other extreme examples - Hotdog as a Dog, Rubber Duck as a Duck, etc. We can totally do it if the superclasses are empty, but it doesn't make any sense.

Additionally, there is nothing really stopping us from inheriting "Burger" from "Metal" class even if they both aren't empty, but it should make sense too.
{{% /notice %}}

4. **Interface Segregation**: create a separate `interface` for each distinct functionality and later provide their respective implementation. By such fine-grained splitting, we won't need to provide impl to unrequired interface methods in the impl concrete class.

```java
// so much to do for a Bear Keeper
public interface BearKeeper {
    void washTheBear();
    void feedTheBear();
    void petTheBear();
}
```

Split to diff interfaces acc to functionality: 
```java
public interface BearCleaner {
    void washTheBear();
}

public interface BearFeeder {
    void feedTheBear();
}

public interface BearPetter {
    void petTheBear();
}
```

And then implement each interface as needed:
```java
public class BearCarer implements BearCleaner, BearFeeder {

    public void washTheBear() {
        //I think we missed a spot...
    }

    public void feedTheBear() {
        //Tuna Tuesdays...
    }
}

public class CrazyPerson implements BearPetter {

    public void petTheBear() {
        //Good luck with that!
    }
}
```

5. **Dependency Inversion**: classes should only depend upon (use) interfaces and not other concrete classes. Interfaces should also use other interfaces only.

Simply put, when components of our system have dependencies, we don't want directly inject a component's dependency (concrete `class`) into another. Instead, we should use a level of abstraction (`interface`) between them.

```java
// tight coupling using concrete classes (WiredKeyboard and WiredMouse)
public class PC{
    private final WiredKeyboard keyboard;
    private final WiredMouse mouse;

    public PC(WiredKeyboard keyboard, WiredMouse monitor) {
        this.keyboard = keyboard;
        this.monitor = monitor;
    }
}
```

Instead, we can refactor the above class as:
```java
// loose coupling using interface types
public class PC{
    private final Keyboard keyboard;
    private final Mouse mouse;

    public PC(Keyboard keyboard, Mouse monitor) {
        this.keyboard = keyboard;
        this.monitor = monitor;
    }
}

// then we can pass any kind of object to "PC" class as long as its of type "Keyboard" and "Mouse"
public class WiredKeyboard implements Keyboard { }
public class BluetoothKeyboard implements Keyboard { }
public class WiredMouse implements Mouse { }
public class BluetoothMouse implements Mouse { }
```

### Other Principles

**YAGNI**: You Ain't Gonna Need It (_avoid implementing features that "may" be required in future_)

**KISS**: Keep It Simple Stupid

**DRY**: Don't Repeat Yourselves (_not only line duplication, but each significant piece of functionality should be implemented in
just one place in the source code_)

**Hollywood Principle**: "_Don't call us, we'll call you._" (another name for Inversion-of-Control)

**Minimise Coupling**, **Maximize Cohesion**, **Be Orthogonal** (_independent_)

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

**Law of Demeter** (_Principle of Least Knowledge_) - Don't talk to strangers. Call methods of only "closely" related objects and not `foo.bar.baz.qux` when `foo` and `qux` aren't [closely related](https://java-design-patterns.com/principles/#law-of-demeter) but rather chained.

**Composition over Inheritance**: prefer composition rather than inheritance; because it is much less rigid and can be changed later, composition also allows multiple inheritance like relation which Java doesn't allow with concrete classes (diamond problem).
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