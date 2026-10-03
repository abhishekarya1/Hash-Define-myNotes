+++
title = "Low Level Design"
date = 2022-11-28T21:35:00+05:30
weight = 1
+++

## OOP
Everything is an object and every action must be performed on an object by an object's methods.

**The 4 pillars of OOP**: Abstraction, Encapsulation, Inheritance, and Polymorphism. [notes](/java/oop/#concepts)

**Composition vs Aggregation**: both are types of association, former is a _strong_ one, latter is a _weak_ association.
```java
// Composition: one can't exist without another
class Human {
	final Heart heart; 	// final; because we will now need to init it always
	
	Human(Heart heart){		// constructor; must recieve a heart and puts it into human
		this.heart = heart;
	}
}

// Aggregation: one can exist independently without the other; no need to provide value to water instance var below
class Glass {
	Water water;
}

// can be made bi-directional too (optional)
class Water {
	Glass glass;
}
```

Note that in Composition we can also instantiate the `new Heart()` object inside the class itself (either inline or inside the constructor) such that it gets created automatically when `Human` class is instantiated, but such code need not be present in case of Aggregation.

## Design Principles
Help create clean, extensible, and maintainable code.

### Object-Oriented Design

#### SOLID

Has 5 principles within it:
- Single Responsibility
- Open/Closed (OXCM)
- Liskov Substitution
- Interface Segregation
- Dependency Inversion

1. **Single Responsibility**: a class should have only one reason to change; do one thing and do it well. 

Better framing - a class should be responsible to one, and only one, Actor. A class can do a single thing very well, but if multiple actors (Finance, Business Ops, Platform) are using it, it'll be a pain to cater to each one when they start demanding changes to it that contradict each other.

Ex - `Invoice` class can be split into the following four classes based on reponsibility and who uses it:
- `Invoice` class - primary entity
- `ConsoleService` class - to print invoice details to console
- `DatabaseService` class - to save invoice details to database
- `EmailService` class - to send invoice details via email

```java
class Invoice{
	long id;
	double price;

	Invoice(long id, double price, double discount){
		this.id = id;
		this.price = price - (price * discount / 100.0);
	}

	void printInvoice(){
		System.out.println("Invoice: " + id + ", and price = " + price);
	}

	void saveInvoiceToDB(){ }

	void sendInvoiceToEmail() { }
}
```

**Problem**: the above class can change because of multiple reasons (because multiple actors depend on it) such as changes in database storing logic, or price discount calc (e.g. adding GST taxation).

A better way to write the above class without violating SRP by splitting functionality across multiple classes (one for each Actor) is:

```java
class Invoice{
	long id;
	double price;

	Invoice(long id, double price, double discount){
		this.id = id;
		this.price = price - (price * discount / 100.0);
	}

}

class ConsoleService{
	void print(Invoice invoice){
		System.out.println("Invoice: " + invoice.id + ", and price = " + invoice.price);
	}
}

class DatabaseService{
	void saveToDB(Invoice invoice){ }
}

class EmailService{
	void sendEmail(Invoice invoice) { }
}

// in main()
Invoice invoice = new Invoice(1L, 100.0, 50.0);
InvoicePrinter invoicePrinter = new InvoicePrinter();
invoicePrinter.print(invoice);
```

In the example above, we can also keep `Invoice` as an instance member in service and inject it by supplying with constructor upon instantiation.

2. **Open/Closed**: classes should be open for extension but closed for modification i.e. add new behavior without changing existing code. This usually means using interfaces or abstract classes so you can add new implementations without touching the original code.

Ex - impl new functionality of payment via crypto

```java
class PaymentProcessor {
  void process(String type, double amount) {
    if (type.equals("credit")) {
      // credit card logic
    } else if (type.equals("paypal")) {
      // paypal logic
    }
    // adding crypto means modifying this method (VIOLATION!)
  }
}
```

Instead, we can use interface to allow adding new payment types without modifying existing code:
```java
interface PaymentMethod {
  void process(double amount);
}

class CreditCardPayment implements PaymentMethod {
  public void process(double amount) { /* credit card logic */ }
}

class PayPalPayment implements PaymentMethod {
  public void process(double amount) { /* paypal logic */ }
}

class CryptoPayment implements PaymentMethod {
  public void process(double amount) { /* crypto logic */ }
}

// usage
class PaymentProcessor {
  void process(PaymentMethod method, double amount) {
    method.process(amount);
  }
}
```

{{% notice info %}}
"_open for extension_" doesn't actually mean inheritance with the Java keyword `extend` here. It just means extending the behavior of your system i.e. adding new behaviour.
{{% /notice %}}

3. **Liskov Substitution**: a superclass should be substitutable by any of its subclasses, without breaking any existing functionality. This is possible only if the subclass _adds_ new behaviour on top of its superclass and _not narrows it down_ or _changes it_.

Ex - _Penguin_ is a technically a _Bird_, but its flightless. We can't replace Bird object with Penguin object and expect things to not break in the way the below example is written.

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

// Penguin class can be substituted for Bird class anywhere now
```

Another example is electric car as it doesn't have an engine. A `Car` class can have `MotorCar` and `ElectricCar` subclasses, but `ElectricCar` object can't replace wherever `Car` object is used since it can cause `NullPointerException` when instance member `engine` is accessed as `engine` will be `null` for `ElectricCar` instance.

4. **Interface Segregation**: create a separate `interface` for each distinct functionality and later provide their respective implementation. By such fine-grained splitting, we won't need to provide impl to interface methods which the impl concrete class doesn't even need.

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

5. **Dependency Inversion**: High-level modules should not depend on low-level modules. Both should depend on abstractions. 

In simple words, classes should only depend upon (use) interfaces and not other concrete classes. Interfaces should also use other interfaces only.

The "inversion" refers to who defines the contract. Normally, your business logic conforms to whatever the implementation provides. With DIP, you flip this: define an interface based on what your business logic needs, then have implementations conform to that interface. The implementation adapts to the business logic, not the other way around.

Simply put, when components of our system have dependencies on each other, we don't directly inject a component's dependency (concrete `class`) into another. Instead, we create abstractions (`interface`) based on our needs and use them instead.

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

#### Other Important Principles
**Program against abstractions**: program by keeping interfaces and their relations and interactions in mind. Don't take concrete classes into consideration while designing.

**Prefer Composition over Inheritance**: prefer composition over inheritance, it has none of the issues that come with inheritance: 
- tight coupling betweeen derived and superclass
- locks in relationships at design time (rigid hierarchies)
- the **Fragile base class problem** is a fundamental architectural issue in OOP where seemingly safe modifications to a base class (superclass) can unintentionally alter or break the behavior of its derived classes (subclasses). Avoid long inheritance chains to minimize chances of mishap.
- multiple inheritance isn't allowed in Java with concrete classes (**Diamond problem**).

```java
// an Order can be a StandardOrder, ExpressOrder, or InternationalOrder

// with inheritance
class Order {
	void ship(){
		// shipping logic
	}

	void track(){
		// tracking logic
	}
}

class StandardOrder extends Order { }	// StandardOrder is-a Order object
class ExpressOrder extends Order { }
class InternationalOrder extends Order { }

// if we impl digital orders in the future, ship() and track() methods will be useless (throw exception) and break
class DigitalOrder extends Order {
	@Override
	public void ship(){
		throw new UnsupportedOperationException("No shipment for digital orders.");
	}
}

```

Instead of creating parent-child hierarchy, we can create classes based on separate concerns which are composed of objects they need i.e. `Order`: 
```java
// composition - shipment is a separate concern so we take it out and create separate classes for it composed of Order object
class Order { }

class GroundShipper {
	Order o;		// each shipment has-a order
	
	// constructor injection
	GroundShipper(Order o){
		this.o = o;
	}

	void ship(){
		// call Truck API
	}
}

class FreightShipper {
	Order o;
	void ship(){
		// call Train API
	}
}

class AirShipper {
	Order o;
	void ship(){
		// call Airline API
	}
}

class DigitalDelivery {
	Order o;
	void deliver(){
		// send email with download link
	}
}
```

**Note**: Ideally we should pass order as method argument `void ship(Order o)`, but above code snippet is to show composition so I wrote it using dependency injection via constructor.

{{% notice tip %}}
There is still scope of enhancement here. Inheritance is implicitly a combination of two things: _Code Reuse_ and _Abstraction_. Abstraction because parent class reference can act as a common interface for all the child classes and parent's methods are common no matter what subclass object is passed (shown below). We can lose this capability in composition and therefore use dependency injection with a common `interface` which becomes the common contract here.
{{% /notice %}}

```java
// inheritance: implicit abstraction
class OrderService {
	Order order;

	void onCheckout() {
		order.calculateTotal();		// all Order objects will have these methods in this form (common contract)
		order.generateInvoice();
		order.ship();
	}
}
```

Fully refactored code utilizing composition:
```java
// composition: abstraction using interface, composing with dependency injection
class Order { }

interface DeliveryMethod { 
	void deliver(Order o);
}

class GroundShipper implements DeliveryMethod { }
class FreightShipper implements DeliveryMethod { }
class AirShipper implements DeliveryMethod { }
class DigitalDelivery implements DeliveryMethod { }

class OrderService {
	DeliveryMethod dm;		// dependency injection

	OrderService(DeliveryMethod dm){
		this.dm = dm;
	}

	void onCheckout(Order o){
		delivery.deliver(o);
	}
}
```

**Encapsulate what varies**: identify parts of a system that change with new requirements and isolate them from the parts that stay the same.
```java
// pseudocode
if (pet.type() == dog) {
    pet.bark();
} else if (pet.type() == cat) {
    pet.meow();
} else if (pet.type() == duck) {
    pet.quack();
}

// encapsulate the varying behavior behind a stable interface
pet.speak();

// if we add Cow in the future, the speak() call remains unchanged as its on interface ref var
```

Isolate each animal call's logic in their respective class and create a common stable interface `Pet`. This is how it looks like after refactor in Java:
```java
interface Pet {
    void speak();
}

class Dog implements Pet {
    @Override
    public void speak() { bark(); }
}

class Cat implements Pet {
    @Override
    public void speak() { meow(); }
}

class Duck implements Pet {
    @Override
    public void speak() { quack(); }
}

// usage
Pet pet = new Dog();
pet.speak();

// adding new animal will now require creating its own class and the speak() call remains unchanged
``` 

**Law of Demeter** (Principle of Least Knowledge): Don't talk to strangers. Call methods of only "closely" related objects and not `foo.bar.baz.qux` when `foo` and `qux` aren't [closely related](https://java-design-patterns.com/principles/#law-of-demeter) but rather chained. Any change in the chain can break things for others.

**Tell, don't ask**: reminds that OOP is about bundling data with the functions that operate on that data (encapsulation). Rather than asking an object for data and acting on that data, we should instead tell an object what to do. Ex - instead of fetchng the bank balance, subtracting withdrawal amount and writing back resulting amount to an object, we should just call `withdraw(amount)` on the object.

### General Software Design
**YAGNI** (You Ain't Gonna Need It): avoid implementing features that "may" be required in future; think ahead but don't build ahead.

**KISS** (Keep It Simple Stupid): the simplest solution that works is usually the right one; avoid unnecessary complexity.

**DRY** (Don't Repeat Yourself):  not only code duplication, but each significant piece of functionality should be implemented in just one place in the source code; applies to code comments, docs, API design, etc. as well. Resist the temptation to cut down coincidental duplication like [this](https://youtu.be/KITlTlvQm9E?t=481) though!

**Separation of Concerns**: different parts of your code should handle different responsibilities, and they shouldn't know about each other's internals.

**Minimise Coupling** / **Maximize Cohesion** / **Be Orthogonal**: writing decoupled, independent components where a change in one does not cause side effects or break others.

**Inversion of Control (IoC)** (Hollywood Principle - "_Don't call us, we'll call you_"): an external framework or container controls the flow of execution, rather than your own custom application code. Dependency Injection is the concrete design pattern used to impl IoC. Frameworks like Spring, Angular, ASP.NET are based on this and have components called IoC Containers which perform DI.

## Design Patterns

**Dependency Injection**: an object receives its required services or dependencies from an external source rather than creating them internally.

Benefits:
1. Makes dependencies explicit: a class clearly declares what it needs (typically through its constructor or method parameters), making it easier to understand, test, and maintain.
2. Reduces coupling: the class depends on abstractions (interfaces) instead of creating concrete impl itself, making impl easy to swap, mock, or extend without modifying the class.

```java
// 1. makes dependencies explicit
class CheckoutService {
 	CheckoutService(Database db, PaymentProvider provider, Mailer mailer){ }
}

// 2. reduces coupling
interface PaymentProvider { }

class UPIProvider implements PaymentProvider { }
class StripeProvider implements PaymentProvider { }

class CheckoutService {
 	CheckoutService(Database db, PaymentProvider provider, Mailer mailer){ }		
}
```

{{% notice tip %}}
Dependency Injection is a way to impl the Dependency Inversion principle. The example above with `interface PaymentProvider` should make it clear as the class depends upon a abstraction there.
{{% /notice %}}

The injection is actually performed by a DI framework like Spring, Angular, ASP.NET.

The GoF design patterns are discussed at length [here](/design-patterns).

## References
- https://www.baeldung.com/solid-principles
- CodeAesthetic - https://www.youtube.com/@CodeAesthetic/videos
- CsMadeEz [Playlist](https://www.youtube.com/playlist?list=PLCypAUzup-uM)
- [The Pragmatic Programmer](https://share.google/aagJkpnYIMhtKI2r4) Book

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

### Type Systems
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


#### Duck Typing
> "If it looks like a duck and quacks like a duck, it's a duck"

Duck typing is a programming style where an object's suitability for use is determined by the presence of specific methods and properties rather than its explicit class or inheritance.

Used in Python, Ruby, Objective-C, etc.

```python
class Duck:
    def talk(self):
        print("Quack!")

class Person:
    def talk(self):
        print("Hello!")

def make_it_talk(entity):
    # It does not check if entity is a Duck or Person
    # It just tries to call .talk() because it "quacks" like a duck
    entity.talk()

# Both work because both have a talk() method
make_it_talk(Duck())    # Output: Quack!
make_it_talk(Person())  # Output: Hello!
```