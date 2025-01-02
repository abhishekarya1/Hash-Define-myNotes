+++
title = "Functions"
date =  2024-12-29T20:53:00+05:30
weight = 4
+++

## Functions

### Rest Parameters and Spread Syntax
```js
// Rest Parameters and Spread Syntax - both look similar (...arr)

function sumAll(...args) { 		// Rest Parameter (aka varargs)
  let sum = 0;
  for (let arg of args) 
  	sum += arg
  return sum
}

alert(sumAll(1)) 		// 1
alert(sumAll(1, 2)) 	// 3
alert(sumAll(1, 2, 3)) 	// 6

// "arguments" variable (old way)
function showName() {
  alert(arguments.length)
  alert(arguments[0])
  alert(arguments[1])

  // it is array-like iterable so we can use for...of loop on it
}

// Spread Syntax: unpacks array or object
let arr = [3, 5, 1]
alert(Math.max(arr))	 // NaN; since max() doesn't accept an array
alert(Math.max(...arr))	 // 5

// deep-copy (clone) array or object with spread syntax
let arrClone = [...arr]
let objClone = { ...obj }

// merge arrays with spread syntax
let arr = [2, 3, 4]
let arr2 = [6, 7, 8]
let merged = [1, ...arr, 5, ...arr2]

/*

Tip to identify: 

When ... is at the end of function parameters, it's "rest parameters" and is used to "pack" multiple values into one array.
When ... occurs in a function call or alike, it's called a "spread syntax" and is used to "unpack" array to multiple values.

*/
```

### Variable Scopes and Closure
```js
// Closure - nested function
function makeCounter() {
  let count = 0

  return function() {		// return a function object
    return count++
  }
}

let counter = makeCounter()

alert( counter() ) 	 // 0
alert( counter() )	 // 1
alert( counter() )	 // 2

// Note that they take outer variables from the context they are written in (and not from where they're called in), in this case, the outer function.

/*

In JavaScript, every running function, code block {...}, and the script as a whole have an internal (hidden) associated object known as the Lexical Environment.

The Lexical Environment object consists of two parts:
1. Environment Record – an object that stores all local variables as its properties (and some other information like the value of "this").
2. A reference to the outer lexical environment, the one associated with the outer code.

All functions remember the Lexical Environment in which they were made. All functions have the hidden property named [[Environment]], that keeps the reference to the Lexical Environment where the function was created (doesn't matter from where it is called).

*/

/*

Note on Garbage Collection of Lexical Environments

A Lexical Environment object dies when it becomes unreachable (just like any other object). In other words, it exists only while there's at least one nested function referencing it.

*/

function f() {
  let value = 123

  return function() {
    alert(value)
  }
}

let g = f() 	// while g function exists, the value stays in memory
g = null 		// now the memory is cleaned up


// V8 optimization - outer function's object properties are garbage collected if they're not used in closure 
function f() {
  let value = Math.random()

  return function() {
    alert('hello')		// "value" isn't used here
  }
}
```

## "var" keyword
```js
// works just like "let" but the diff is the scope where variable is available to use 
var msg = 'hello'

// variables declared with "var" can be accessed outside blocks!
{
  var msg = 'hello'
}
alert(msg)    // foo

// but not outside a function i.e. they stop at only function scope
function getMessage(){
  var msg = 'hello'
}
alert(msg)  // undefined

// SUMMARY - var variables have no block scope, their visibility is scoped to current function, or global, if declared outside function.

// var variables can tolerate redeclarations
let user
let user // SyntaxError: 'user' has already been declared

var user = "Alice"
var user = "Bob"    // does nothing; already declared
alert(user)   // Bob

// Variable Hoisting: var declarations are processed at function start (script start for globals)
function sayHi() {
  phrase = "Hello"    // assignment with no declaration, works fine!
  alert(phrase)
  var phrase
}
sayHi()

// JS "hoists" (moves upward) the variable declarations to the top of the function no matter where it is (even if declaration is inside some level of nested block inside the function), so var variables can be used from the start of the function even when they are declared anywhere down in the function scope!

// only declarations are hoisted, assignments are not
function sayHi() {
  alert(phrase)   // undefined; not error
  var phrase = "Hello"
}
sayHi()
```

An old way is to use Immediately Invoked Function Expression (IIFE) to act as code blocks since `var` doesn't have a block scope but only function scope.

## Global Object, Function Objects, NFE, new Function(), setTimeout/setInterval
```js
// every JS environment has a global object - browser has "window", Node.js has "global", spec recommends a "globalThis" object

// this global object stores every function and globla variables declared with "var"

alert("Hello")
window.alert("Hello")   // equivalent to above

var gVar = 5
alert(window.gVar)  // equivalent to above

// used for Polyfills as we can check existence using and set method to add on the global object

// functions are objects in JS, so naturally they have properties too!

function sayHi() {
  alert("Hi")
}
alert(sayHi.name)   // sayHi

// smartly infers the name for function expressions too (contextual name)
let sayHi = function() {
  alert("Hi")
}
alert(sayHi.name)   // sayHi

// the "length" property
function f1(a) {}
function f2(a, b) {}
function many(a, b, ...more) {}

alert(f1.length)    // 1
alert(f2.length)    // 2
alert(many.length)  // 2 (rest params are counted as one)

// custom properties
function sayHi() {
  alert("Hi")
  sayHi.counter++
}
sayHi.counter = 0   // init value
sayHi()   // Hi
sayHi()   // Hi
alert(`Called ${sayHi.counter} times`)  // called 2 times

// we can change this custom property's value from anywhere in the code, not only from closures, so be careful.
```

```js
// Named Function Expression (NFE) - function expression in which function name is specified

let sayHi = function greet(who) {
  alert(`Hello, ${who}`)
}

// benefit is that we can recursively call the function with the name even when it is put into another ref variable
let sayHi = function greet(who) {
  if (who) {
    alert(`Hello, ${who}`)
  } else {
    greet("Guest")   // use greet to re-call itself
  }
}
sayHi()   // Hello, Guest
greet()   // Error, greet is not defined (not visible outside of the function)
```

```js
// functions are objects so they can be called using "new Function()"
let func = new Function ([arg1, arg2, ...argN], functionBody)

// arguments are optional, and functionBody is a string 
let sayHi = new Function('alert("Hello")')
sayHi()   // Hello

// all of the below declarations are equivalent
new Function('a', 'b', 'return a + b')  // basic syntax
new Function('a,b', 'return a + b')     // comma-separated
new Function('a , b', 'return a + b')   // comma-separated with spaces

// functions created with new Function, have [[Environment]] referencing the global Lexical Environment, not the outer one. Hence, they cannot use outer variables. Its good as it doesn't cause any problems with minifiers (which rename local variables to shorter names and won't modify functionBody string to match the new names).
```
```js
// setTimeout allows us to run a function once after the interval of time
let timerId = setTimeout(func|code, [delay], [arg1], [arg2], ...)
// setInterval allows us to run a function repeatedly, starting after the interval of time, then repeating continuously at that interval
let timerId = setInterval(func|code, [delay], [arg1], [arg2], ...)

// remove timeout to abort function invocation
clearTimeout(timerId)

// Trick: nested timeouts, setInterval runs function on fixed intervals, but nested timeouts make the interval more flexible
let delay = 5000
let timerId = setTimeout(function tick() {
  alert('tick')
  delay *= 2
  timerId = setTimeout(tick, delay)
}, 2000)

// Trick: zero timeout, setTimeout with 0 timeout run after the whole script!
setTimeout(() => alert("World"), 0)
alert("Hello")

// alerts "Hello", then "World"
```

## Decorators, Forwarding and Borrowing with call/apply, bind
```js
// Decorators are wrapper functions that call other functions (Forwarding) adding functionalities such as caching, conditional calls, invocation counter, etc.

let user = { 
  name: "Alice",
  getName() {
    alert(this.name);
  }
}

// object functions (methods) lose context (this) when called from any way other than on object!
user.getName(1)   // this = user

let myFunc = user.getName
myFunc(2)   // this = undefined

// user func.call() to pass context
let admin = { name: "Bob" }

// pass different objects as "this"
user.getName.call( user )  // Alice

// Method Borrowing - use a method from an object and call it by passing another object as context
user.getName.call( admin ) // Bob

// we can also use func.apply(context, args) where args is not spread-syntax and expects an array-like object

// Trick#1 to solve lost "this" - wrap function call in another function
let user = { 
  name: "Alice",
  getName() {
    alert(this.name);
  }
}

let myFunc = function() {
  user.getName()
}
myFunc()  // Alice

// Trick#2 is Binding - bind context with function using func.bind(context) and the bounded variant can be called from anywhere without context too
let myFunc = user.getName.bind(user)
myFunc()    // Alice; context preserved in bounded function ref

// bind functions and methods context and arguments to create Partial/Partially Applied Functions
let boundFunc = func.bind(context, [arg1], [arg2], ...)

function mul(a, b) {
  return a * b
}
let double = mul.bind(null, 2)
alert( double(3) )  // = mul(2, 3) = 6
alert( double(4) )  // = mul(2, 4) = 8
alert( double(5) )  // = mul(2, 5) = 10
```

## Arrow Functions
```js
// they are supposed to be used as short function without a name that are passed as arguments, mostly used for forwarding

/*

Highlights:
1. don't have a "this" of their own, and take it from outer Lexical Environment
2. don't have the "arguments" param
3. can't be called with "new"
4. don't have a "super"

*/
```

## Property flags, descriptors, getters/setters
```js
/*

each object property not only has a value but 3 other attributes (aka flags):

writable – if true, the value can be changed, otherwise it's read-only.
enumerable – if true, then listed in loops, otherwise not listed.
configurable – if true, the property can be deleted and these attributes can be modified, otherwise not.

*/

// get flags for a property
let descriptorObj = Object.getOwnPropertyDescriptor(obj, 'propertyName')

// change flags
let descriptorObj = { writable: false }
Object.defineProperty(obj, 'propertyName', descriptorObj)

let user = {
  name: "Alice"
}

Object.defineProperty(user, "name", {
  writable: false
})

user.name = "Bob"   // Error

// can create new property
Object.defineProperty(user, "age", {
  value: 25
})

// change multiple property flags at once
Object.defineProperties(user, {
  name: { value: "John", writable: false },
  surname: { value: "Doe", writable: false },
})

// get all properties' flags at once
Object.getOwnPropertyDescriptors(obj)

// sealing objects - methods available to change flags based on common usage patterns
Object.preventExtensions(obj)   // forbids the addition of new properties to the object
Object.seal(obj)    // forbids adding/removing of properties. Sets configurable: false for all existing properties
Object.freeze(obj)  // forbids adding/removing/changing of properties. Sets configurable: false, writable: false for all existing properties

Object.isExtensible(obj)  // returns false if adding properties is forbidden, otherwise true
Object.isSealed(obj)    // returns true if adding/removing properties is forbidden, and all existing properties have configurable: false
Object.isFrozen(obj)    // returns true if adding/removing/changing properties is forbidden, and all current properties are configurable: false, writable: false
```

```js
// apart from data properties, we can have "accessor properties" too which don't have a value
let obj = {
  get propName() {
    // getter, the code executed on getting obj.propName
  },

  set propName(value) {
    // setter, the code executed on setting obj.propName = value
  }
}

let user = {
  name: "John",
  surname: "Doe",

  get fullName() {
    return `${this.name} ${this.surname}`
  }
}

alert(user.fullName)  // John Doe

// accessor properties have the following flags - get(), set(value), enumerable, configurable
let user = {
  name: "John",
  surname: "Doe"
}

Object.defineProperty(user, 'fullName', {
  get() {
    return `${this.name} ${this.surname}`
  },

  set(value) {
    [this.name, this.surname] = value.split(" ")
  }
})


// sometimes we create a new internal property (this._name = value) in setter and return access it via getter, so in that way users of the object are unaware of its existence. 
```