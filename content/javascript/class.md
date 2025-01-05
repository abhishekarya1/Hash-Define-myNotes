+++
title = "Classes"
date =  2025-01-05T16:03:00+05:30
weight = 6
+++

```js
class MyClass {
  prop = value 	 // property (class field)

  constructor(...) { } 	// constructor

  method(...) { } 	// method

  get something(...) { }	// getter method
  set something(...) { } 	// setter method

  [name + 'method']() { } 	// method with computed name
}

let obj = new MyClass()
obj.method()

// a class in JS is internally kind of a function!
alert(typeof MyClass)	 // function

/*

When a class is decalred, the following happens:

1. Creates a function named "MyClass", the function code is taken from the constructor method (assumed empty if we don't write such method).
2. Stores class methods, such as "method", in a newly created object "MyClass.prototype" (created by JS for class).
3. After "new MyClass" object is created, when we call its method, it's taken from the "MyClass.prototype". So the object has access to class methods.
4. Class fields are set on individual objects, not "MyClass.prototype", unlike methods.

*/

// functions in classes have special internal properties so classes aren't just syntactic sugar to create objects via constructor functions

// class expressions - as with everything, JS allows storing and passing classes in variables
let user = class {
  sayHi() {
    alert("Hello")
  }
}

// Named Class Expression - the name User is only accessible inside the class body
let user = class MyClass {
  sayHi() {
    alert(MyClass)
  }
}
alert(MyClass)	// Error

// class inheritence
class Animal {
  constructor(name) {
    this.speed = 0
    this.name = name
  }

  run(speed) {
    this.speed = speed
    alert(`${this.name} runs with speed ${this.speed}.`)
  }
}

class Rabbit extends Animal {
  hide() {
    alert(`${this.name} hides!`)
  }
}

let rabbit = new Rabbit("White Rabbit")

rabbit.run(5) 	// White Rabbit runs with speed 5; inherited method accessible in child class
rabbit.hide() 	// White Rabbit hides!

// "extends" meaning - Rabbit.prototype sets [[Prototype]] property to Animal.prototype, this way object created using "new" can access all methods of Rabbit.prototype as well as Animal.prototype

// we must call super(...) the first thing in the custom constructor, it is not implicitly done in JS for explicitly defined constructors
constructor(name, earLength) {
	super()		// otherwise error while creating object with "new" 
	this.speed = 0
    this.name = name
	this.earLength = earLength
}

// overriding methods - method can be overriden by re-defining same named method in the child as well
class Animal {
  showName() {  
    alert('animal')
  }

  print() {
    this.showName()		// this = parent's ref
  }
}

class Rabbit extends Animal {
  showName() {
    alert('rabbit')
  }
}

new Animal().print() 	// animal
new Rabbit().print() 	// rabbit

// remember from prototype notes - No matter where the method is found: in an object or its prototype. In a method call, this is always the object before the dot (.). Same applies here too.

// overriding fields - fields can be overriden just like methods but it won't work properly when accessing them in constructors
class Animal {
  name = 'animal'

  constructor() {
    alert(this.name)
  }
}

class Rabbit extends Animal {
  name = 'rabbit'
}

new Animal() 	// animal
new Rabbit() 	// animal

/* this is beacuse constructor of parent is called then class fields of parent are init, then constructor of child resumes, then class fields of child init. Only parent class field with value as 'animal' is available during super(...) call execution so its used.
*/

// we can also use super.method() in a child method to call parent method 

// arrow functions don't have their own "this" or "super", so they transparently fit into the surrounding context


// static methods and properties belong to the class
class User {
  static staticMethod() {
    alert('Hi')
  }

  static species = 'Human'
}

User.isMammal = true 	// direct assignment to class

User.staticMethod()		// Hi
new User().staticMethod()	// Error (unlike Java)

// static properties and methods are inherited just like instance ones

// protected fields and methods - prefixed with an underscore (_), language doesn't enforce but we do via conditions for values it can take in its setter and getters
// read-only fields - no setter for a property in a class make it read-only
// private fields and methods - prefixed with a hash (#), enforced by the language, can't be accessed outside the class or in inheriting class, only inside the class

// nothing is really stopping us from setting things directly on the instance made using a class, but it's a very bad practice to do so
class User { }

let obj = new User()

obj.name = 'John'
alert(obj.name)		// John


// extending built-in classes like Array, Map and others are extendable also

// when one class extends another, both static and non-static methods are inherited. But built-in classes are an exception. They don't inherit statics from each other.

// For example, both Array and Date inherit from Object, so their instances have methods from Object.prototype. But Array.[[Prototype]] does not reference Object, so there's no, for instance, Array.keys() (or Date.keys()) static method.
```

## Diagrams
**Class inheritance diagram showing prototypal relationship**:
![prototypal_relationship_diagram](https://i.imgur.com/Sf5qKLL.png)

**Class inheritance diagram showing members**:
![class_inheritance_members_diagram](https://i.imgur.com/roRkprJ.png)