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
str.toLowerCase()
str.toUpperCase()
str[1].toUpperCase()

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