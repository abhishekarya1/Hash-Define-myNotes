+++
title = "Design Patterns"
date = 2024-05-01T18:33:00+05:30
weight = 2
+++

## Introduction
**Design Patterns**: guidelines providing solutions to recurring problems and good practices in software.

Design patterns are often called **GoF** (Gang of Four) design patterns because of [the book](https://g.co/kgs/RzdfZ2) that first outlined these design patterns 20 years ago, named so because of its 4 authors. 

3 types of Design Patterns:
1. **Creational** (_how to create objects or a group of related objects_) - **5**
2. **Structural** (_how objects use each other, their composition_) - **7**
3. **Behavioral** (_assignment of responsibilities between the objects_)

_Reference#1_: https://www.programcreek.com/java-design-patterns-in-stories

_Reference#2_: https://java-design-patterns.com

_Reference#3_: Concept && Coding - Udemy

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

Issues with existing approaches: 
- make a huge constructor with all members as param; not ideal
- create multiple smaller constructors, but here we will face a challenge of constructor redefinitions. Ex - constructor `Foobar(int id, String name)` clashes with overloaded constructor `Foobar(int age, String name)` because of parameter data types and `Foobar` class has all the four members.

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

A more thread-safe way is to create a separate `abstract class` or an inner `static class` for Builder (some code duplication is present as members are defined again in the Builder class if not inner class).

```java
// Builder Pattern using inner static class
class Student{
	private int id;
	private String name;
	private int age;

	private Student(Builder builder){		// modified constructor
		this.id = builder.id;
		this.name = builder.name;
		this.age = builder.age;
	}

	// define getters here

	// inner class can access private memebers of its containing outer class
	public static class Builder{
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
			return new Student(this);		// modified build method
		}
	}
}

// in main()
Student obj = new Student.Builder().setId(1).setName("Pinkman").setAge(26).build();
```

## Structural Patterns
They all are based on **HAS-A** relationship i.e. aggregation (and composition). Some make use of **IS-A** relationship too.

### Decorator
Add features layer-by-layer on an existing object without modifying the code for it. The modified decorator object is also an object of a common interface and it is thus decoratable recursively any number of times (i.e. both **HAS-A** and **IS-A** relationships).

Ex - used in `Collections.synchronizedXXX()` and `Collections.unmodifiableXXX()`.

```java
interface BasePizza{
	public int cost();
}

class Margherita implements BasePizza{
	@Override
	public int cost(){
		return 100;
	}
}

class Farmhouse implements BasePizza{
	@Override
	public int cost(){
		return 200;
	}
}

// decorator (it IS-A BasePizza too)
interface PizzaDecorator extends BasePizza{
	String getColor();		// introduce new behavior(s) here
}

// concrete decorator class
class JalepenoTopping implements PizzaDecorator{
	BasePizza basePizza;	// object to decorate; HAS-A

	public JalepenoTopping(BasePizza basePizza){
		this.basePizza = basePizza;
	}

	@Override
	public int cost(){
		return this.basePizza.cost() + 10;		// decorate cost() method
	}

	@Override
	public String getColor(){
		return "Green";
	}
}

// in main()
BasePizza pizzaObj = new MushroomTopping(new JalepenoTopping(new Margherita()));		// recursive decoration
pizzaObj.cost();	// return final cost with all the toppings
```

### Composite
Whenever classes' relationship hierarchy is like a Russian Doll (recursive tree), we use this design pattern to model it. Ex - Filesystem.

```java
interface FileSystem{ }		// optionally introduce a common ls() method to list info of file or dir contents

class File implements FileSystem{
	String fileName;
}

class Directory implements FileSystem{
	String directoryName;
	List<FileSystem> fileSystemList;		// recursive composition (one-to-many association)
}

```

### Adapter
Allows objects with incompatible interfaces to work together (aka Wrapper). Involves a single adapter class which is responsible for communication between the two different interfaces.

Ex - `Arrays.asList()` adapts array `T[]` type to `List<T>` type, changes are propagated back to array too.

```java
// existing interface
interface OldInterface {
    void oldMethod();
}

// new interface
interface NewInterface {
    void newMethod();
}

// Adapter class for old interface to make it compatible with new interface
class Adapter implements NewInterface {		// Adapter is of type new
    private OldInterface oldObject;			// HAS-A relation (wraps around old)

    public Adapter(OldInterface oldObject) {
        this.oldObject = oldObject;
    }

    @Override
    public void newMethod() {
        oldObject.oldMethod();		// adaptation
    }
}

// define concrete classes for all interfaces to use them

// in main()
OldInterface oldObj = new OldImplClass();	// old's object
NewInterface newObj = new Adapter(oldObj);	// adapt it to new
newObj.newMethod();		// call on new's object performs old's logic now
```

**Usage**: to make a `Client` call on a `NewInterface` method backward-compatible with `OldInterface` method (shown in the example code above).

Note that if the `Client` would've been calling `OldInterface` and we wanted to provide new behavior (forward-compatibility), we would've just overriden `oldMethod()` in its impl class and not used an adapter at all.

### Facade
Hides the system complexity from the client. Provide a unified class that initializes a bunch of classes and calls complex logic steps on them instead of Client doing it directly on the base objects. 

Ex - `ComputerFacade` class initializes `CPU`, `Memory`, `Display` objects and has a **HAS-A** relation with them (objects as members).

```java
class CPU{
	public void powerUp(){ }
}

class Memory{
	public void start(){ }
}

class Display{
	public void showSplashScreen(){ }
}

class ComputerFacade{
	private CPU cpu;				// HAS-A relation
	private Memory memory;
	private Display display;

	public ComputerFacade(){		// pass objects in constructor params
		this.cpu = new CPU();		// or init member objects here (recommended)
		this.memory = new Memory();
		this.display = new Display();
	}

	public void boot(){				// hiding complexity; Client now needs to call only this method
		cpu.powerUp();
		memory.start();
		display.showSplashScreen();
	}
}

// in main()
ComputerFacade obj = new ComputerFacade();
obj.boot();
```

We can also chain multiple facades i.e. one facade calling another, which in turn calls the complex logic.

**How is it diff from Proxy?** It takes multiple objects whereas a proxy takes only a single one.

**How is it diff from Adapter?** There are no compatibility issues we're solving here. Facade creates a layer over existing interfaces to combine them.

### Proxy
Create another proxy wrapper class around an original class implementing the same common interface, and Client calls the original via the proxy object.

**Why go through a proxy?**
- Access Restrictions (Filtering, Marshalling & Unmarshalling)
- Caching
- Pre & Post Processing

Ex - Spring Application Proxy creates a proxy class for every class (Bean) in the application using Spring AOP and CGLIB.

```java
interface Computer{
	void boot();
}


class Laptop implements Computer{
	@Override
	void boot(){ 
		//boot logic here 
	}
}

class LaptopProxy implements Computer{
	Computer laptop;							// HAS-A relation

	public LaptopProxy(Laptop laptop){
		this.laptop = laptop;
	}

	@Override
	void boot(){
		if(laptop.powerOnSelfTest() == true){		// pre-processing
			laptop.boot();							// call via proxy
		}
		else {
			throw new RuntimeException("Already running!");
		}
	}
}

// all calls intended for Laptop will instead be made on the LaptopProxy object
Computer laptopObj = new Laptop();
Computer laptopProxyObj = new LaptopProxy(laptopObj);
laptopProxyObj.boot();
```

Proxies can be chained too i.e. one proxy calls another, which in turns calls another proxy.

This is similar to the Decorator Pattern but we don't need another interface like `ToppingDecorator` here as we don't need to introduce new behavior (methods) here but only calling the original object's methods via a proxy.

### Bridge
It decouples an abstraction from its implementation so that the two can vary independently.

![bridge_pattern_summary_UML_diagram](https://i.imgur.com/GX0oNC8.png)

```java
interface LivingThings{
	void breatheProcess();
}

class Animal implements LivingThings{
	@Override
	public void breatheProcess(){
		// nose
	}
}

class Fish implements LivingThings{
	@Override
	public void breatheProcess(){
		// gills
	}
}

class Tree implements LivingThings{
	@Override
	public void breatheProcess(){
		// leaves
	}
}

// Problem - we can't have an entirely new breathing mechanism without creating a new concrete class (impl) with new logic for the interface (abstraction) method

// create a Bridge interface - and now we can independently (of class) create many impl of it that define a new kind of breathing mechanism

interface BreatheImplementor{
	void breathe();
}

class AnimalBreatheImplementor implements BreatheImplementor{
	@Override
	void breathe(){
		// nose
	}
}

class FishBreatheImplementor implements BreatheImplementor{
	@Override
	void breathe(){
		// gills
	}
}

class TreeBreatheImplementor implements BreatheImplementor{
	@Override
	void breathe(){
		// leaves
	}
}


// and modify existing classes as follows
class Animal implements LivingThings{
	BreatheImplementor breatheImpl;			// Bridge Link (object HAS-A composition)

	public Animal(BreatheImplementor breatheImpl){
		this.breatheImpl = breatheImpl;
	}

	@Override
	public void breatheProcess(){
		breatheImpl.breathe();				// calls method of implementor impl
	}
}

class Fish implements LivingThings{

	BreatheImplementor breatheImpl;

	public Fish(BreatheImplementor breatheImpl){
		this.breatheImpl = breatheImpl;
	}

	@Override
	public void breatheProcess(){
		breatheImpl.breathe();
	}
}

class Tree implements LivingThings{

	BreatheImplementor breatheImpl;

	public Tree(BreatheImplementor breatheImpl){
		this.breatheImpl = breatheImpl;
	}

	@Override
	public void breatheProcess(){
		breatheImpl.breathe();
	}
}

// in main()
LivingThings fishObj = new Fish(new FishBreatheImplementor());		// supply which implementor to use here
fishObj.breatheProcess();
```

![bridge_design_pattern_UML_diagram](https://i.imgur.com/gbuvIOA.png)

**Advantages of Bridge Pattern**:
- we can now create new breathing mechanisms as concrete Implementor classes without creating an Abstraction concrete class for them. Ex - create a `WormBreatheImplementor` (they breathe through their skin).
- we can supply breathing mechanisms to various Abstraction concrete classes at runtime. Ex - pass `FishBreatheImplementor` to constructor of `Dog` class!

**Abstract class vs Interface for this pattern**: if we use `abstract class` as Abstraction, then we can place `BreatheImplementor` object composition in the abstract class itself, declare `breatheProcess()` method as abstract. In the example above we used `interface` and thus we need to place composition object in the concrete class of the abstraction.

### Flyweight
Reduce the memory usage by sharing data among multiple objects.

There is no aggregation/composition required here as other patterns. 

**Applications of this pattern**:
- Design a Game (display diff types of robots on screen; only co-ordinates differ)
- Design a Word Processor (display diff types of characters on screen; only co-ordinates differ)

**Where to apply this pattern**:
- memory is limited
- multiple objects share data:
	- _Intrinsic_: single constant copy of data shared among all objects
	- _Extrinsic_: changes based on the Client input and differs for each object
- creation of object is expensive

**Implementation steps**:
- from object, remove all extrinsic data and keep only the intrinsic data (this is a "Flyweight" object)
- this object class can be immutable
- extrinsic data can be passed to Flyweight object using method parameters
- once the Flyweight object is created it can be cached and reused wherever required


```java
interface IRobot{
	public void display(int x, int y);
}

// Flyweight class
class HumanRobot implements IRobot{
	private String type;
	private Sprites body;

	public HumanRobot(String type, Sprites body){
		this.type = type;
		this.body = body;
	}

	public String getType(){
		return this.type;
	}

	public Sprites getBody(){
		return this.body;
	}

	@Override
	public void display(int x, int y){
		// render image
	}
}

// Factory (do caching here in a static Map<String, Sprites>)
class RobotFactory{
	private static Map<String, Sprites> robotObjectCache = new HashMap<>();

	public static IRobot createRobot(String type){
		if(robotObjectCache.containsKey(type)){
			return robotObjectCache.get(type);			// cache read
		}
		else{
			if(type.equals("HUMAN")){
				IRobot robotObj =  new HumanRobot(type, new HumanSprite());
				robotObjectCache.put(type, robotObj);		// cache write
				return robotObj;
			}
			else if(type.equals("DOG")){
				IRobot robotObj = new DogRobot(type, new DogSprite());
				robotObjectCache.put(type, robotObj);		// cache write
				return robotObj;
			}
		}
		return null;
	}
}

// in main()
// create multiple human robots (object reused implicitly since its cached) and display them at diff co-ordinates
IRobot humanRobotObj = RobotFactory.createRobot("HUMAN");		// writes object to cache
humanRobotObj.display(1, 0);
IRobot humanRobotObj1 = RobotFactory.createRobot("HUMAN");		// reads cached object
humanRobotObj1.display(2, 0);
IRobot humanRobotObj2 = RobotFactory.createRobot("HUMAN");		// reads cached object
humanRobotObj2.display(3, 0);
```

## Behavioral Patterns

### Strategy

If we have classes `PassengerVehicle`, `SportsVehicle`, and `OffRoadVehicle` that inherit from a base class `Vehicle`, there may be a lot of code duplication in `drive()` method if some of the classes override it with special drive capability and some don't. Its better to provide the capability dynamically (using a Strategy `interface`) rather than letting code get duplicated.

In short, Strategy pattern enables choosing the best-suited algorithm at runtime, and avoid code duplication across sibling classes.

```java
class Vehicle{
	void drive(){
		// normal drive logic
	}
}

class PassengerVehicle extends Vehicle{
	void drive(){
		// normal drive capability
	}
}

class SportsVehicle extends Vehicle{
	@Override
	void drive(){
		// special drive capability
	}
}

class OffRoadVehicle extends Vehicle{
	@Override
	void drive(){
		// special drive capability; duplicated again in sibling class
	}
}

```

```java
// using Strategy Pattern
interface DriveStrategy{
	void drive();
}

class OffRoadDriveStrategy implements DriveStrategy{
	@Override
	void drive(){
		// special drive capability
	}
}

class Vehicle{
	DriveStrategy ds;		// aggregation

	Vehicle(DriveStrategy ds){		// set in constructor
		this.ds = ds;
	}

	void drive(){
		ds.drive();		// calls strategy's drive() method
	}
}

class OffRoadVehicle extends Vehicle{
	OffRoadVehicle(DriveStrategy ds){
		super(ds);
	}

	// drive() method is inherited here and can be called here
}

// usage
DriveStrategy dsOffRoad = new OffRoadDriveStrategy();	// create strategy impl concrete class of interface
Vehicle offRoadObj = new OffRoadVehicle(dsOffRoad);		// supply strategy to vehicle instance
offRoadObj.drive();
```

{{% notice note %}}
Note that the UML diagram and syntax is similar to the **Bridge Pattern** (_structural_), but here it provides implementor (strategy) to a concrete class `Vehicle` rather than an abstraction i.e. no abstraction on LHS (tighter coupling than Bridge Pattern).
{{% /notice %}}

### Observer
When one object (_observable_) changes state, all its dependents (_observers_) are notified and updated automatically. Ex - `java.util.EventListener` and Spring WebFlux Project Reactor.

![observer_uml_diagram](https://i.imgur.com/Bf63MCt.png)

```java
// observable
interface WheatherStation{
	void add(Observer obs);
	void remove(Observer obs);
	void notify();
	void setTemparature(double temp);
	double getTemparature();
}

// observable - concrete class
class WheatherStationImpl implements WheatherStation{
	List<Observer> observerList = new ArrayList<>();		// HAS-A; all observers' list

	int temp = 0;	// data

	@Override
	void add(Observer obs){
		// add obs to observerList
		observerList.add(obs);
	}

	@Override
	void remove(Observer obs){
		// remove obs from observerList
		observerList.remove(obs);
	}

	@Override
	void notify(){
		// update all observers
		for(var e : observerList){
			e.update();
		}
	}

	@Override
	void setTemparature(double temp){
		this.temp = temp;
		this.notify();			// set new val and notify observers
	}

	@Override
	double getTemparature(){
		return temp;
	}

}

// observer
interface Display{
	void update();
}

// observer - concrete classes
class TVDisplay{
	WheatherStation observable; 	// observable aggregation here (HAS-A) (optional)

	public TVDisplay(observable obs){
		this.observable = obs;
	}

	@Override
	void update(){
		observable.getTemparature();
		// trigger Email logic here
	}
}

class PhoneDisplay{
	WheatherStation observable; 	// observable aggregation here (HAS-A) (optional)

	public PhoneDisplay(observable obs){
		this.observable = obs;
	}

	@Override
	void update(){
		observable.getTemparature();
		// trigger SMS logic here
	}
}

// usage
WheatherStation observable = new WheatherStationImpl();
Display tvObj = new TVDisplay(observable);
Display phoneObj = new PhoneDisplay(observable);
observable.add(tvObj);
observable.add(phoneObj);
observable.setTemparature(53.0);

// SMS and email is triggered
```

In short, observable has a ref (`List`) to all its observers and whenever data changes in observable, it calls `notify()` to notify all observers and calls _their_ `update()` method. The data can then be get from the observable's object inside the observer's update method body.

We can supply an object of observable too in this update method call (`update(Object o)`) but in the above example we used aggregation (HAS-A) to place observable object in the observer too which is a cleaner approach and doesn't require `instanceof` pattern matching in the observer update method.

### State
We can model any state machine (_automata_) using this pattern. Ex - Vending Machine.

Keep a `State` ref object (HAS-A) inside the `VendingMachine` object and at any given point its type will give us the state the machine is in. Supply `VendingMachine` object to state transition method in state classes and use setter on it to change state on the machine object.

![state_uml_diagram](https://i.imgur.com/BqNuaX3.png)

```java
class VendingMachine{
	State state;		// HAS-A state object to track vm state
	
	public VendingMachine(){
		this.state = new IdleState();		// constructor; init state
	}

	// define shelf, item codes, and prices, and other logic
}

// abstraction - base state 
interface State{
	// declare all state transition methods here (operations)
}

// concrete - all states
class IdleState implements State{
	// override relevant methods for each state
	// return Exception on the rest

	@Override
	void clickOnInsertCoinButton(VendingMachine vm){	// state transition function
		vm.setVmState(new HasMoneyState());				// use setter to transition state
	}
}

class HasMoneyState implements State{ }
class SelectionState implements State{ }
class DispenseState implements State{ }

// usage
VendingMachine vm = new VendingMachine();		// init VM
State vmState = vm.getVendingMachineState();	// get VM state
vmState.clickOnInsertCoinButton(vm);			// VM state changes internally when we call transition func
vmState.selectProduct(vm);
vmState.dispenseProduct(vm);
```

### Chain Of Responsibility
Provides more than one receiver objects a chance to handle a request. The receiving objects are chained and the request is passed along the chain until an object handles it.

**Applications**:
- Logger Levels
- ATM Withdrawal Denominations
- Vending Machine Change Denominations

To form chain we set `nextLogProcessor` in abstract class (parent) for each instance using `super()` and if current object isn't allowed to handle it, we call `log()` method of its `super` (abstract class). In the `log()` method of abstract class we call the `log()` method of the `nextLogProcessor`.

```java
// Log Processor Abstraction
abstract class LogProcessor{
	LogProcessor nextLogProcessor;		// HAS-A aggregation pointing to next handler in chain

	LogProcessor(LogProcessor logProcessor){
		this.nextLogProcessor = logProcessor;
	}

	void log(int logLevel, String message){
		if(nextLogProcessor != null){
			nextLogProcessor.log(logLevel, message);
		}
	}
}

// Log Processors - Concrete
class ErrorLogProcessor extends LogProcessor{
	ErrorLogProcessor(LogProcessor nextLogProcessor){		// form chain using constructor super() calls
		super(nextLogProcessor);
	}

	@Override
	void log(int logLevel, String message){
		if(logLevel == 1){
			System.out.println("ERROR: " + message);	// handle here
		} else {
			super.log(logLevel, message);				// call log() of super
		}
	}
}

// usage
LogProcessor loggerObj = new InfoLogProcessor(new DebugLogProcessor(new ErrorLogProcessor(null)));
loggerObj.log(1, "exception occured");	// error
loggerObj.log(2, "debug message");		// debug
loggerObj.log(3, "info message");		// info
```

### Command
Stores requests as command objects allowing performing an action or undoing it at a later time.

Divide logic into 3 parts by introducing a layer (_command_) between client (_invoker_) and handler (_receiver_):
- Invoker
- Command
- Receiver

```java
// receiver/handler
class AirConditioner{
	boolean powerOnState;

	AirConditioner(){
		this.powerOnState = false;
	}

	void turnOn(){
		this.powerOnState = true;
		// start display, fans, etc.
	}
}

// base command - abstraction
interface ICommand{
	void execute();
}

// commands - concrete classes
class TurnOnACCommand implements ICommand{
	AirConditioner ac;		// HAS-A aggregation

	TurnOnACCommand(AirConditioner ac){
		this.ac = ac;
	}

	@Override
	void execute(){		// proxy call via command layer
		ac.turnOn();
	}
}

// remote control - client/invoker
class RemoteControl{
	ICommand powerButton;

	void setPowerButtonCommand(ICommand command){
		this.powerButton = command;
	}

	void pressPowerButton(){
		powerButton.execute();
	}
}

// usage in main method (Client)
AirConditioner ac = new AirConditioner();
RemoteControl remote = new RemoteControl();
remote.setPowerButtonCommand(new TurnOnACCommand(ac));	// set command to a button on the remote, and AC to command
remote.pressPowerButton();		// press button
```

This pattern is popularly used to implement Undo/Redo functionality. Each command has a `undo()` method and we maintain command history in a `Stack<ICommand>` in the client (`RemoteControl`):

```java
interface ICommand{
	void execute();
	void undo();		// undo method added to each command
}

class TurnOnACCommand implements ICommand{
	AirConditioner ac;

	TurnOnACCommand(AirConditioner ac){
		this.ac = ac;
	}

	@Override
	void execute(){	
		ac.turnOn();
	}

	@Override
	void undo(){			// undo method added
		ac.turnOff();
	}
} 


class RemoteControl{
	Stack<ICommand> acCommandHistory = new Stack<>();		// maintain history of operations in Client
	
	ICommand command;

	void setPowerButtonCommand(ICommand command){
		this.command = command;
	}

	void pressPowerButton(){
		command.execute();
		acCommandHistory.add(command);
	}

	void undo(){		// undo last operation
		if(!acCommandHistory.isEmpty()){
			ICommand lastCommand = acCommandHistory.pop();
			lastCommand.undo();
		}
	}
}
```

### Template
When multiple classes follow a fixed set of steps and we want to ensure flexibility too such that each step can be customized with their own specific logic.

```java
// template class
abstract class PaymentFlow{
	abstract void validateRequest();
	abstract void calculateFees();
	abstract void debitAmount();
	abstract void creditAmount();

	// un-overridable template method
	final void sendMoney(){
		// step 1
		validateRequest();
		// step 2
		calculateFees();
		// step 3
		debitAmount();
		// step 4
		creditAmount();
	}
}


// create a concrete class using template
class PayToFriend extends PaymentFlow{
	@Override
	void validateRequest(){
		// validate payment request
	}

	@Override
	void calculateFees(){
		// no fees when sending to a friend
	}

	@Override
	void debitAmount(){
		// debit from account
	}

	@Override
	void creditAmount(){
		// credit to friend's account
	}

	// no overriding sendMoney() method
}

// another concrete class from template
class PayToMerchant extends PaymentFlow{ }

// usage
PayToFriend payment = new PayToFriend();
payment.sendMoney();
```

### Memento
This pattern enables us to store the previous states (_snapshots_) of an object. This can be used when we want Undo functionality.

Also known as "Snapshot Pattern". A Memento class object is used as captured snapshot and has the same data members as originator class. 

It does not expose the object's internal implementation since we use `createMemento()` and `restoreMemento()` methods on the originator object.

**Components**:
- Originator - represents object whose state has to be saved
- Memento - intermediary object that stores state of the originator
- Caretaker - stores all mementos (i.e. states) throughout the history in a `List<Memento>`

![memento_java_code](https://i.imgur.com/pqvbmnz.png)

### Iterator
Helps to access the elements sequentially and makes the client agnostic about the internal storage implementation of the underlying data structure.

Ex - `iterator()` method on Java collections:
```java
List list = List.of(1, 2, 3);		// collection; aggregator

Iterator it = list.iterator();		// iterator for collection

while(it.hasNext()){
	Object e = it.next();
	System.out.println(e);
}
```

Custom implementation of the design pattern for a `Library` (as **Aggregator**) and `BookIterator` (as **Iterator**):

![iterator_UML_code](https://i.imgur.com/lwSWHKz.png)

### Null Object
Null Object pattern handles "empty" objects gracefully.

It can do so by avoiding `NullPointerException` at every step but we want to avoid writing `null` checks for every object everywhere in the code.

**Points**:
- a Null Object replaces `null` return type
- no need to put `if` object null checks anywhere
- Null Object reflects _do nothing_ or _default_ behavior
	
```java
interface Vehicle{
	int getTankCapacity();
	int getSeatingCapacity();
}

class Car extends Vehicle{
	@Override
	int getTankCapacity(){
		return 40;
	}

	@Override
	int getSeatingCapacity(){
		return 5;
	}
}

// Null Object (default behavior)
class NullVehicle extends Vehicle{
	@Override
	int getTankCapacity(){
		return 0;
	}
	
	@Override
	int getSeatingCapacity(){
		return 0;
	}
}


// usage in Factory
class VehicleFactory{
	static Vehicle getInstance(String vehicleType){
		if("Car".equals(vehicleType)){
			return new Car();
		} else {
			return new NullVehicle();		// Null Object instead of "null"
		}
	}
}

// in main method (Client)
Vehicle obj = VehicleFactory.getInstance("Foobar");
printDetails(obj);

static void printDetails(Vehicle v){
	System.out.println(v.getTankCapacity());		// no need of "null" check here now
	System.out.println(v.getSeatingCapacity());
}
```


## Anti-Patterns
_Reference_: https://sourcemaking.com/antipatterns
