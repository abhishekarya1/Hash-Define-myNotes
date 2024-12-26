+++
title = "Code"
date =  2024-12-24T22:26:00+05:30
weight = 2
+++

## Data Types, Operators, Casting
```js
// semicolons (;) are optional in JS for the programmer to terminate statements with in source code. It automatically inserts semicolon based on a set of rules called Automatic Semicolon Insertion (ASI). Always pick a side and stick to it, use styling guides such as Prettier or Airbnb Style Guide.


// Variables
var name = "foobar"		// old way (not recommended)
let name = "foobar"
const name = "foobar"	// constant

let name;		// "undefined" is put into this as value until assigned explicitly


// Data Types
let msg = "hello"
msg = 123456		// no error; JS is dynamically typed

// numbers
let num1 = 123
let num2 = 12.34
let num3 = 123n		// BigInt

// special numeric values
Infinity
-Infinity 
NaN

// NaN represents a computational error
// NaN is sticky. If there's a NaN somewhere in a mathematical expression, it propagates to the whole result (there’s only one exception to that: NaN ** 0 is 1)
// It makes maths "safe" in JS. At worst, we get NaN

// strings
let str = "Hello"
let str2 = 'Single quotes are ok too'
let str3 = `can embed another ${str}`

// char type doesn't exist, only string

// boolean
true
false

// special values
null			// empty or value unknown
undefined		// not assigned

// object type for more complex data structures
// symbol type for unique identifiers

// typeof operator
let x = 9
typeof x	// number
x = "foo"
typeof(x)	// string


// Type Casting

// anything to string
let num = 123
let str = String(num)

// anything to number
let str = "123"
let num = Number(str)

// common numeric conversions
undefined 	// NaN
null		// 0
true/false	// 1/0 respectively
string		// either a number or NaN

// anything to boolean
let bit = 1
let isSet = Boolean(num)

// values that are intuitively "empty", like 0, an empty string, null, undefined, and NaN, become false
// other values become true


// Operators

// unary + is often used to convert non-numeric types to numeric
let n = "98"
typeof n 		// string
let num = +n
typeof num 		// number

// binary + converts numeric to string if atleast one operand is a string
'1' + 2 	// "12"
2 + '1' 	// "21"

// the other operators convert string to numeric, after stripping surrounding whitespaces
'1' - 2 	// -1
2 - '1' 	// 1

// chaining assignments are possible
a = b = c = 5

// comma operator
let n = (1 + 2, 3 + 4)		// a is assigned 7; only last is assigned, rest are ignored

// some trick questions
4 + 5 + "px" 	// "9px"
"px" + 4 + 5 	// "px45" (due to associativity)
"4px" - 2 		// NaN
"  -9  " - 2 	// -11
null + 1 		// 1
undefined + 1 	// NaN
" \t \n" - 2 	// -2


// Comparison
5 > 4 			// true
"A" >= "F" 		// false (lexicographical comparison on strings)
'Bee' > 'Be' 	// true
'a' > 'A'		// true (because its Unicode comparison)

// values are converted to numbers for comparison
'2' > 1 	// true
"0" == 0 	// true

// strict equality: check value as well as type
0 == false		// true
0 === false		// false

// null and undefined are only == to each other and nothing else
null == 0 			// false
undefined == 0 		// false
null == undefined	// true
null === undefined	// false

// Conditional Operator (Ternary)
let result = condition ? value1 : value2

// Logical Operators

// they are short-circuited
// || returns the first truthy value or the last one
// && returns the first falsy value or the last one

null || 0 || 1 				// 1 (first truthy)
undefined || null || 0		// 0 (last)

null && 0 && 1 				// null (first falsy)
1 && 'foo' && 0				// 0 (last)

// !! is sometimes used to convert any type to boolean
!!"foo"
// the first ! converts to boolean and inverses it, then second ! flips it again

// Nullish coalescing operator: if first operand is null or undefined, then return the second
let n = value ?? 'foobar'

// programmers used to use || for this but it can't differentiate between 0/"" and null/undefined
let n = 0 || 'foobar'	// 'foobar' (first truthy)
```

## Control Structures
```js
// Loops
for(;;){ } 
while(condition){}
do{} while(condition)

break;
break label;
continue;
continue label;

switch 	// works as expected 
```

## Functions

```js
// Functions

function sayHello() {
	alert('Hello World!')
} 

let userName = 'Alice'	// outer variable (shadowing possible in JS)
function sayHello() {
  let userName = "Bob" 	// local variable
  alert(userName)		// Bob
}
sayHello()
alert(userName)		// Alice

// a function can be called with any number of parameters
function sayHello(userName, greeting) {
	alert(greeting + ' ' + userName)
}
sayHello('Hello')	// userName is undefined

// specify default (should be last param, can be expression or method call, evaluated only when argument not passed in caller)
function sayHello(userName, greeting = 'Hello') {
	alert(greeting + ' ' + userName)
}
sayHello('Alice')
sayHello('Alice', 'Hello', 'foo', 'bar')	// extra params are ignored

// old way to handle missing params
function sayHello(userName, greeting) {
	if(greeting === undefined){
		greeting = 'Hello'
	}
	alert(greeting + ' ' + userName)
}

// we can also use the below
greeting = greeting || 'Hello'
greeting = greeting ?? 'Hello'

return 		// a function with an empty return or without it returns undefined

// function can be put in variables and called later (callbacks)
let greet = sayHello
greet()

// function expressions
let sayHello = function(){
	alert('Hello') 
};
sayHello()
alert(sayHello)		// prints function source code text

function sum(a, b) {
  return a + b
}

let sum = function(a, b) {
  return a + b
};

// arrow functions
let sayHello = () => { alert('Hello') }
let sum = (a, b) => { return a+b }
let sum = (a, b) => a+b 	// much shorter way
```

## Backwards Compatibility
**Transpilers**: They take modern JS code and convert it to logically equivalent code but using old and widely accepted language contructs only. Ex - [Babel](https://babeljs.io/).

**Polyfills**: It is just code and methods which aren't available in the old language environment being added to support their calls/references. Ex - [core-js](https://github.com/zloirock/core-js).

## Objects
JS is a protoptype-based language, this means that classes are not needed for objects to exist, we can define and modify objects on the fly.

```js
// syntax
let obj = {
	key: value,
	key2: value2
};

// keys can only be of string or symbol type, rest are converted to string

// creating objects
let user = new Object() 	// "object constructor" syntax
let user = {}  						// "object literal" syntax

// defining/adding properties
let user = {
  name: "Bob",
  age: 30
}

user.city = 'New York'

// removing a property
delete user.age

// access a property that doesn't exist
alert(user.address)			// undefined; no errors


// square [] notation
user['key with spaces or-hyphens'] = 123

// dynamic key access is only possible with [] notation
let key = prompt("What do you want to know about the user?", "name");
alert(user[key])

// dynamic property keys (computed keys)
let fruit = prompt("Which fruit to buy?", "apple");
let bag = {
  [fruit]: 5,		// notation
}
alert(bag.apple)	// 5, if "apple" otherwise undefined

// property value shorthand
let user = {
	name, 	// same as name: name
	age: 30
}

// there are no limitations on property names unlike variables and they can be reserved keywords like "for", "let", etc..

// property existance - "in" operator
let user = { name: "John", age: 30 }
alert("age" in user) 		// true
alert("blabla" in user)	// false

// "for..in" loop
for (key in object) {
  // executes the body for each key among object properties
}

// Key Ordering: keys in an object are numerically sorted if they can be parsed as valid numeric, otherwise they are sorted in the insertion order.


// objects are copied by reference by default
let user = { name: "John", age: 30 }
let employee = user
employee.name = 'Bob'
alert(user.name)		// 'Bob'

user == employee		// true
user === employee		// true

// these are diff objects even if contents is same
let a = {}
let b = {}
a == b 		// false

// const objects can be modified
const user = { name: 'Alice' }
user.name = 'Bob'
user = anotherObj		// error

// merging objects
Object.assign(dest, ...sources)

// deep copying (cloning) objects
let clone = Object.assign({}, user)

// be careful with nested cloning: if an object has another object as key, the internal one's reference will be copied, and a new object won't be created for it. Use below to solve that issue:
let clone = structuredClone(user);
// it correctly handles circular references as well

// unreferenced obejcts in the memory are deleted (garbage collected) regularly by JavaScript engine's GC

// functions can be added as object values too
let user = {
  name: "John",
  age: 30
}
function sayHi() {
  alert("Hello")
}
user.sayHi = sayHi
user.sayHi() 			// Hello

// same but with diff syntax
user = {
  sayHi: function() {
    alert("Hello")
  }
}

// shorthand (method)
let user = {
  sayHi() {
    alert("Hello")
  }
}

// "this" in methods refer to the containing object ref
let user = {
  name: "John",
  age: 30,

  sayHi() {
    alert(this.name)  // good practice; safe incase object is accessed from another reference 
  }
}

// this can exist in functions that aren't members of any object, but it will be undefined
// we can't use this in Arrow Functions, it access from outer method

// constructor: a function which creates an empty object {}, adds properties, and returns it implicitly (no need of a return statement)
function User(name) {
  this.name = name
  this.isAdmin = false
}
let user = new User("Jack")
alert(user.name) 		// Jack
alert(user.isAdmin) // false

let user = new User		// parenthese are optional if constructor has no args

// if return is called with an object, then the object is returned instead of "this"
// if return is called with a primitive, it's ignored and "this" is returned
function BigUser() {
  this.name = "John"
  return { name: "Godzilla" }
}
alert( new BigUser().name )  	// Godzilla

// optional chaining (?.) - checks for null and undefined
let user = {}
alert(user.address.street) 	// error; user.address is undefined and we can't use (.) on it
alert(user?.address?.street)	// no error

// it is short-circuited, this means that it stops as soon as it finds a non-existent property

// other variants
obj?.[prop] 		// returns obj[prop] if obj exists, otherwise undefined
obj.method?.() 	// calls obj.method() if obj.method exists, otherwise returns undefined

// Symbol Type
let id = Symbol("id")		// with optional description

// every symbol has a unique id even if desc is identical
let id1 = Symbol("id")
let id2 = Symbol("id")
alert(id1 == id2)			// false

// symbols don't convert to a string implitcitly
let id = Symbol("id")
alert(id) 			// TypeError	
alert(id.toString())

// symbols can't be overwritten from another part of code as they are always unique so they're effectively hidden
let id = Symbol("id")
user[id] = "foobar"			// no one can replace this unless they've access to "id" from above line

// we need [] notation for using symbols in object literals!
let user = {
  name: "John",
  [id]: 123 		// not "id": 123
}

// symbols are skipped in a for…in loop

// there is a Global Symbol Registry from which we can get and use symbols, this allows sharing them across unrelated part of codes
// get symbol by name
let sym = Symbol.for("name")
// get name by symbol
alert(Symbol.keyFor(sym))		// name

// object to primitive conversions: they aren't always possible and JS tries to guess and perform it

// hints: JS has only 3 "hints" when deciding such object to primitive conversions 
date1 - date2   // number hint
alert(obj)      // string hint
obj1 + obj2     // default hint (when confused between number and string)

// uses symbolic key method [Symbol.toPrimitive] to convert 
// or else uses obj.valueOf() or obj.toString() based on whatever exists
let user = {
  name: "John",
  money: 1000,

  [Symbol.toPrimitive](hint) {
    alert(`hint: ${hint}`)
    return hint == "string" ? `{name: "${this.name}"}` : this.money
  }
}
```


