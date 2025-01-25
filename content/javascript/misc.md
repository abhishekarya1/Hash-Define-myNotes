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
// Event Loop - There's an endless loop, where the JS engine waits for tasks, executes them and then sleeps, waiting for more tasks. It may happen that a task comes while the engine is busy, then it's enqueued. The queue is called a "Macrotask Queue" (v8 term).

// changes to DOM are painted only after the currently running task is completed
// if a task takes too long, the browser can't do other tasks, such as processing user events. So after some time, it raises an alert like "Page Unresponsive"

// Immediately AFTER EVERY macrotask, the engine executes all tasks from microtask queue, prior to running any other macrotasks or rendering or anything else.

setTimeout(() => alert("timeout"))    // setTimeout creates a Macrotask

Promise.resolve()
  .then(() => alert("promise"))

alert("code")

// code, promise, timeout

/*

Even Loop Flow:
- Macrotask 1: run script (prints "code")
- Microtask 1: promise handler (prints "promise")
- re-paint DOM
- Macrotask 2: setTimeout (prints "timeout")
- microtask queue is empty
- re-paint DOM

*/

// To schedule a new microtask, use queueMicrotask(f), also promise handlers go through the microtask queue.

/*
Detailed Event Loop algorithm:

1. Dequeue and run the oldest task from the macrotask queue (e.g. "script")
2. Execute all microtasks: while the microtask queue is not empty, dequeue and run the oldest microtask
3. Render changes if any (re-paint DOM)
4. If the macrotask queue is empty, wait till a macrotask appears
5. Go to step 1

There's no UI or network event handling between microtasks: they run immediately one after another.

*/
```