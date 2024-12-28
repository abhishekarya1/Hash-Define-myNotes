+++
title = "Data Types"
date =  2024-12-27T14:55:00+05:30
weight = 3
+++

## Number
```js
// we can call methods on primitives! 
// 1. javascript converts them to wrapper objects - Number, String, Boolean, BigInt, Symbol
// 2. calls the method on that object and returns the output
// 3. destroys the wrapper object

let str = "Hello"
str.toUpperCase()	// HELLO

let n = 1.23456
n.toFixed(2)		// 1.23

let num = new Number(123)	// this is possible ofcourse, but never do this!

// null and undefined have no methods since they don't have wrapper objects


// Numbers
let billion = 1000000000
let billion1 = 1_000_000_000
let billion2 = 1e9
let micro = 1e-6

alert(0.1 + 0.2 == 0.3)       // false; its 0.30000000000000004; same issue as in C, C++, Java, etc

let hex = 0xffFF
let binary = 0b101
let octal = 0o127

// base conversions
let num = 255
num.toString(16)  // ff
num.toString(2)   // 11111111

123456..toString(2)		// notice 2 dots to call a method on a number literal

// rounding
Math.round()
Math.floor()
Math.ceil()
Math.trunc()

alert(1e500)	// Infinity

// isNaN() and isFinite()
isNaN(NaN)		// true
isNaN("str") 	// true
isFinite("12")	// true
isFinite(Infinity)	// false
isFinite("str")	// false; its NaN

// Object.is(a, b) is the same as a === b, but it does comparison with NaN as well.

// parseInt(n, radix) and parseFloat() output a number
// they start reading from left and parse until they can't anymore
parseInt('100px')		// 100
parseFloat('12.5em')	// 12.5
parseFloat('12.5.7')	// 12.5 (stops at second point)
parseInt('a123')		// NaN

// other math functions
Math.random()
Math.power(n, power)
Math.min(a, b, c...)
Math.max(a, b, c...)
```

## String
```js
// backticks allow multi-line strings in source code
let str1 = "Hello\nWorld"
let str2 = `Hello
World`
alert(str1 == str2)		// true

// string length property
let str = "my\n"
alert(str.length)	// 3

// access characters
let str = `Hello`
str[0] 		// H
str.at(0) 	// H
str[str.length - 1]	 // o
str.at(-1)	// o
str[-1]		// undefined

// for...of loop 
for (let char of "Hello") {
	alert(char) 	// H,e,l,l,o
}

// strings are immutable in JS
let str = 'Hi'
str[0] = 'h'	// error

// changing case
let strCaps = str.toLowerCase()
let strSmall =str.toUpperCase()
let charCaps = str[1].toUpperCase()

/* string functions

str.indexOf(substr, [pos])
str.lastIndexOf(substr, [pos])

str.includes(substr, [pos])

str.startsWith(substr)
str.endsWith(substr)

str.slice(start, [end])
str.substring(start, [end])
str.substr(start, [length])

str.localeCompare(str1)

str.trim()

*/
```

## Array
```js
// arrays need not be homogeneous in JS
let arr = ["foo", 8, true, { name: 'John' }, function(){ alert('hello') }]
let arr2 = new Array('abc', 'def', 'ghi')		// not recommended

// accessing elements
arr[1]
arr.at(1)
arr.at(-1)		// negative indices are only allowed in at() method
arr[4]()		// run function at index 4 and run it

// length property
arr.length

// be careful with it as it returns one more than the last element's index
let arr = []
arr[123] = 'foo'
arr.length 		// 124

// methods
arr.push('foo', 'bar')			// insert at right (faster)
arr.pop()						// remove from right (faster)
arr.unshift('alice', 'bob')		// insert from left
arr.shift()						// remove at left

// arrays get copied by reference
let fruits = ["Banana"]
let arr = fruits
arr === fruits		// true

// Internals - arrays are objects internally, so technically we can add random properties to it, use delete, for...in loops, but its not recommended
arr['foo'] = 5
arr[0] = 1
arr[99999] = 2
delete arr[2]

// Loops - use simple for or for...of loops. Although for...in can be used but not recommended
for(let element of arr){
	alert(element)
}

// arrays only implement toString() and not toValue() or [Symbol.toPrimitive] functions
let arr = [1, 2, 3]
alert(arr) 	// 1,2,3
alert(String(arr) === '1,2,3') 	// true

// as a result they get converted to string with + operator
alert([] + 1) 	 	// "1"
alert([1] + 1)	 	// "11"
alert([1,2] + 1)	// "1,21

// don't compare arrays with == operator, since it will compare reference and not the contents
// use for loop and manually compare each element
alert([] == []) 	// false
alert([0] == [0]) 	// false


/*

splice(pos, deleteCount, ...items)
slice(start, end)
concat(...items)

indexOf/lastIndexOf(item, pos) 
includes(value)
find/filter(func)
findIndex(func)

forEach(func)

map(func)
sort(func) 
reverse()
split/join(str)
reduce/reduceRight(func, initial)

NOTE: sort, reverse and splice modify the array in-place, rest do not.

arr.some(func)
arr.every(func)
arr.fill(value, start, end)

*/

// the func in above functions are of the format
function(item, index, array) {
  	// returns the new value instead of item
}

// most functions like find, filter, map, etc.. have an optional last argument "thisArg", 
// in which object like "this" can passed as the argument to func to pass context, otherwise its undefined
arr.filter(canJoin, this)

function canJoin(user){
	// logic here
}

// check if object is of array
Array.isArray(obj)
```

## Iterables
```js
// array and string are iterables, objects are not by default
// for...of loops only work on iterables

// any object that has [Symbol.iterator] symbol function is an iterable
// the function for symbol returns an object which has a next() function and "current" and "last" properties

// call an iterator explicitly (rarely needed)
let str = "Hello"
let iterator = str[Symbol.iterator]()
while (true) {
  let result = iterator.next()
  if (result.done) break
  alert(result.value) 		// H,e,l,l,o
}

// Iterables and array-likes:
// Iterables - objects that implement the Symbol.iterator method, as described above
// Array-likes - objects that have indexes and length, so they look like arrays

//  make a real Array from an Iterable or Array-like obj, and we can then use array methods on it
let arr = Array.from(obj, [mapFunc, thisArg])
```

## Map and Set
```js
// maps are objects but keys can be anything and not only string or symbols
let mp = new Map()

map.set(1, 'one')	// a numeric key
map.set('two', 2)	// a string key
map.set(user, 'foo')	// an object key

// set can be chained in JS as it returns a map
map.set('1', 'str1')
  .set(1, 'num1')
  .set(true, 'bool1')

map.set(key, value)
map.get(key)
map.has(key)
map.delete(key)
map.clear()
map.size

// don't do map[key] on a Map; don't treat is as a normal object 

// iterabte over map using for..of loop on the following methods that return iterables
// iteration order is insertion order 
map.keys()
map.values()
map.entries()

// convert to/from object
let map = Object.entries(obj)
let obj = Object.fromEntries(map)

// Sets
let set = new Set()
set.add(value)
set.delete(value)
set.has(value)
set.clear()
set.size

set.keys()
set.values()
set.entries() 

// iteration order is insertion order unlike Java's HashSet
// sets are maps internally hence set.keys() and set.values() both return the keys iterable!
```

## WeakMap and WeakSet
```js
// Note on Garbage Collection: if an object is part of an object, array, map, or set, then it won't be deleted by JS engine even if the reference to it is removed
let user = { name: "Alice" }
let arr = [ user ]
user = null 		// reference removed
// object user won't be garbage collected till reference of arr is present

// WeakMap and WeakSet automatically delete the object from Map/Set (and memory) if the object is referenced only inside them

// WeakMap and WeakSet are diff from their normal impl in the way that Weak counterparts can only store objects
let weakMap = new WeakMap()
WeakMap.set(obj, 'ok')
WeakMap.set('foo', 'bar')	// Error

// WeakMap and WeakSet do not support iteration and methods keys(), values(), entries() so there is no way to access all the elements
```