+++
title = "OOP"
date =  2025-01-03T16:26:00+05:30
weight = 6
+++

## Prototypes, Prototypal inheritance, Built-in prototypes
```js
// Prototype - objects that have a special hidden property [[Prototype]] (as named in the specification), that is either null or references another object

// Prototypal inheritance - objects inheriting properties from other objects by pointing their [[Prototype]] property to other object (parent)
// multiple inheritance isn't allowed and the property can only store one ref

let animal = {
  eats: true
}

let rabbit = {
  jumps: true
}

rabbit.__proto__ = animal 	// sets rabbit.[[Prototype]] = animal
alert(rabbit.eats)	// true

// methods also get inherited
let animal = {
  eats: true,
  walk() {
    alert("Animal walk")
  }
}

let rabbit = {
  jumps: true,
  __proto__: animal
}

// walk is taken from the prototype
rabbit.walk()	 // Animal walk

// note that the __proto__ is outdated and is just a getter/setter for [[Prototype]] property

// writing doesn't use prototype, only reading does
let animal = {
  eats: true
}

let rabbit = {
  jumps: true,
  __proto__: animal
}

rabbit.eats = false		// writing to rabbit (creates new property in rabbit)
alert(rabbit.eats)	// false
alert(animal.eats)	// true (unaffected)

// Accessor properties are an exception, as assignment is handled by a setter function. So writing to such a property is actually the same as calling a function. Hence the getter/setter function is called from the parent even if we used child object to set the property upon.

// No matter where the method is found: in an object or its prototype. In a method call, this is always the object before the dot.
// animal has methods
let animal = {
  walk() {
    if (!this.isSleeping) {
      alert(`I walk`)
    }
  },
  sleep() {
    this.isSleeping = true
  }
}

let rabbit = {
  name: "White Rabbit",
  __proto__: animal
}

// modifies rabbit.isSleeping
rabbit.sleep()

alert(rabbit.isSleeping) 	// true
alert(animal.isSleeping) 	// undefined (no such property in the prototype)

// the for..in loop iterates over both its own and its inherited properties. 
// all other key/value-getting methods (Object.entities(), Object.keys(), Object.values()) only operate on the object's own properties only.


/*

Built-in prototypes:

Every object in JS eventually inherits from the base prototype - Object.prototype

Arrays inherit from Array.prototype
Functions inherit from Function.prototype
Dates inherit from Date.prototype
Numbers inherit from Number.prototype

*/

let arr = [1, 2, 3]
alert( arr.__proto__ === Array.prototype ) 	// true
alert( arr.__proto__.__proto__ === Object.prototype ) 	// true

let obj = {}
alert(obj) 	// [Object object] <-- result of Object.prototype.toString

let arr = [1, 2, 3]
alert(arr)	// 1,2,3 <-- result of Array.prototype.toString (closer parent of array object)

// Native prototypes - primitives are also converted to Wrapper objects and methods are called on them, these wrapper objects get their methods from Number.prototype, String.prototype, Boolean.prototype

// adding function to native prototype
String.prototype.show = function() {
  alert(this)
}
"BOOM!".show()	 // BOOM!

// not recommended unless we're creating a Polyfill

// borrowing methods from prototypes
let obj = {
  0: "hello",
  1: "world",
  length: 2,
}

obj.join = Array.prototype.join
alert( obj.join(',') ) 	// hello,world

// __proto__ isn't recommended in modern JS, don't get/set it directly rather use prototype methods:
Object.getPrototypeOf(obj) 	// returns the [[Prototype]] of obj
Object.setPrototypeOf(obj, proto) 	// sets the [[Prototype]] of obj to proto

// the only case where __proto__ can be specified manually is when creating the object, and not editing it afterwards
let child = { __proto__: parent }
let child = Object.create(parent)	// JS provided function for this

// "very plain" objects - unless we set __proto__ explicitly to null, until then we can't have a key called "__proto__" in object
let obj = { __proto__: null }
// or Object.create(null)
obj.__proto__ = 'foobar'

alert( obj.__proto__ )		// foobar
```

## Prototypes in Constructors (F.prototype)
```js
// for object created via a contructor, set FuncName.prototype property to parent object

let animal = {
  eats: true
}

function Rabbit(name) {
  this.name = name
}

Rabbit.prototype = animal

let rabbit = new Rabbit("White Rabbit") 	//  rabbit.__proto__ == animal
alert( rabbit.eats ) 	// true

// works only when new is used to create object using constructor - new F() sets [[Prototype]]

// every function has the "prototype" property even if we don't supply it
// the default "prototype" is an object with the only property constructor that points back to the function itself

function Rabbit() {}
/* default prototype
Rabbit.prototype = { constructor: Rabbit }
*/
```