+++
title = "Misc"
date =  2025-01-25T11:37:00+05:30
weight = 10
+++

## Currying
Currying is a transformation of functions that translates a function from callable as `func(a, b, c)` into callable as `func(a)(b)(c)`.

```js
function curry(f) { 		// does the currying transform
  return function(a) {
    return function(b) {
      return f(a, b)
    }
  }
}

function sum(a, b) {
  return a + b
}

// usage
let curriedSum = curry(sum)

alert( curriedSum(1)(2) ) 	// 3

// Benefits - currying allows us to easily get partial functions

let addTen = curriedSum(10)

// use partial function to add 10 to any number
alert( addTen(5) )		// 15
```

## Event Loop - Microtasks and Macrotasks
```js




























```