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