+++
title = "Promise and Async"
date =  2025-01-11T18:10:00+05:30
weight = 8
+++

## Promise
```js
// we can do async processing by supplying a function object (callback) to call inside the function logic
function loadScript(src, callback){
	// load the script,
	// then call the callback function
}

// callback hell - multiple nested callbacks to do things one after the other (or handling errors)
loadScript('/my/script.js', function(script) {
  loadScript('/my/script2.js', function(script) {
    loadScript('/my/script3.js', function(script) {
      // ...continue after all scripts are loaded
    })
  })
})

// Promise - an object that executes a function asynchronously; it executes immediately even though we are using "new" to create an object!
let promise = new Promise(executorFunc)

// pass a function expression instead
let promise = new Promise(function(resolve, reject) {
  // executor logic
})

// runs immediately and asynchronously
let promise = new Promise(function(resolve, reject) {
  alert("Foo")
})
alert('Bar')
// prints 'Foo' and then 'Bar'

// each promise has two internal properties - "state" and "result"
// a promise can either be Settled or Unsettled
// state values - "pending", "fulfilled", or "rejected"
// result values - undefined, errorObj, or doneObj

// "resolve" and "reject" are callbacks provided by JS to call on success and error scenarios respectively
let promise = new Promise(function(resolve, reject) {
	resolve("Done")
})
// the promise returns "Promise { 'Done' }" immediately

let promise = new Promise(function(resolve, reject) {
  reject(new Error("Oops.."))  // throws exception immediately
})

// always pass an Error object to reject() but nothing is really stopping us from passing other objects too

// only one of resolve or reject can exist, whichever is first encountered is considered, others are ignored
let promise = new Promise(function(resolve, reject) {
  resolve("Done")
  reject(new Error("Oops.."))  // ignored
})

// handlers of promise - then, catch, finally
promise.then(
	function(result) { /* handle a successful result (on resolve) */ },
	function(error) { /* handle an error (on reject) */ }
)

// skip passing the second argument to handle only success
// pass the first argument as null to handle only errors (catch)

promise.catch(
	function(error) { /* handle an error */ }
)
promise.finally(
	function() { /* execute logic */ }
)

// note on finally - it is unknown to the state of the promise, and is only used to perform generic cleanup tasks etc and pass the promise to the next suitable handler
new Promise((resolve, reject) => {
  reject(new Error("error"))
})
 .finally(() => alert("Promise ready")) 	// triggers first
 .catch(err => alert(err))  	// catch shows the error

// if a finally handler returns something, its ignored. Exception being an error object, when finally handler throws an error, it is sent forward to the next suitable handler

// we can attach handlers to settled promises, and they run immediately (quite useless though)

// Promise Chaining - if a then (or catch/finally, doesn't matter) handler returns a promise, the rest of the chain waits until it settles. When it does, its result (or error) is passed further.

// Error Handling in Promises

// the code of a promise executor and promise handlers has an "invisible try..catch" around it. If an exception happens, it gets caught and treated as a rejection, so the below is equivalent to an explicit rejection
new Promise((resolve, reject) => {
  throw new Error("Whoops!")
}).catch(alert)	 // Error: Whoops!

// in chaining, no matter where the error happens, it triggers the next error handler skipping every non-rejection handler in between. So the easiest way to catch all errors is to append .catch to the end of chain, and write only success (first param) for thens in between.

// rethrowing with "then" handler
new Promise((resolve, reject) => {
  throw new Error("Whoops!")
}).catch(function(error) {
  if (error instanceof URIError) {
    // handle it
  } else {
    alert("Can't handle such error")
    throw error 	// throwing this or another error jumps to the next catch
  }
}).then(function() {
  // this is skipped
}).catch(error => {
  alert(`The unknown error has occurred: ${error}`)
})

// its ok not to use .catch at all, if there's no way to recover from an error. Let JS throw error and we'll know the details of the error.

// Promise API - static methods from Promise class
Promise.all(promises)	 // waits for all promises to resolve and returns an array of their results. If any of the given promises rejects, it becomes the error of Promise.all, and all other results are ignored
Promise.allSettled(promises) 	// waits for all promises to settle and returns their results as an array of objects with status "fulfilled" or "rejected", value (if fulfilled) or reason (if rejected)
Promise.race(promises)	// waits for the first promise to settle, and its result/error becomes the outcome
Promise.any(promises) 	// waits for the first promise to fulfill, and its result becomes the outcome. If all of the given promises are rejected, AggregateError becomes the error of Promise.any
Promise.resolve(value) 	// makes a resolved promise with the given value
Promise.reject(error) 	// makes a rejected promise with the given error

// usage example
function loadCached(url) {
  if (cache.has(url)) {
    return Promise.resolve(cache.get(url))		// return an already resolved promise
  }
}

// Promisification - the conversion of a function that accepts a callback into a function that returns a promise. Great thing to do many times, but not a total replacement for callbacks
// instead of supplying a callback and calling it later, call existing function in executor and return the promise object, use handlers on the returned promise object
let loadScriptPromise = function(src) {
  return new Promise((resolve, reject) => {
    loadScript(src, (script) => {
      resolve(script)
    })
  })
}

// usage: loadScriptPromise('path/script.js').then(...)

// Microtasks

// Promise executor (body) execution is async, but Promise handlers are ordered and not really async!!!

// All promise handlers pass through the internal "promise jobs" queue, also called "Microtask Queue" (V8 term). So then/catch/finally handlers are always called after the current code is finished.

let promise = Promise.resolve()
promise.then(() => alert("promise done!"))
alert("code finished")    // this alert shows first; even though promise is already resolved

// when a promise is ready, its then/catch/finally handlers are put into the queue; they are not executed yet. When the JS engine becomes free from the current script code, it takes a task from the queue and executes it.

// This behavior is unlike Java's CompletableFuture where handler code executes independently of main code flow as the handlers run asap the async code returns!

// JS single threaded, so it uses Event Loop to execute code out-of-order (async-ly). So think in terms of queues and not threads unlike Java.
```

### Trick Questions on Promise Handler Order (Microtask Queue)
```js
// Question 1
let promise = new Promise(function(resolve, reject) {
  console.log("A")
  resolve('B')
})

promise.then((e) => console.log(e))

console.log('C')

// A C B

// Explanation - promise executor code runs async-ly (but prints 'A' first because there is no wait), handler is put into microtask queue, main script code is executed (prints 'C'), and only then the microtask queue runs handler code (prints 'B')
```

```js
// Question 2
let promise1 = Promise.resolve()
let promise2 = Promise.resolve()

promise1
.then(() => console.log(1))
.then(() => console.log(2))

promise2
.then(() => console.log(3))
.then(() => console.log(4))

console.log(5)

// 5 1 3 2 4

// Explanation - promise1 (1) and promise2 (3) are queued, but current global script code executes first and prints 5, then microtask queue execution happens and 1 and 3 are printed, 1 is executed first and its result is sent to its next handler and 2 is enqueued and printed, similar happens for 3 too and 4 is printed.
```

## async/await
```js
// "async" ensures that the function returns a promise, so it wraps non-promise values in a promise and returns it
async function foobar() {
  return 1
}

// lets test the implicit promise
foobar().then(alert)   // 1

// we can return an explicit promise as well (not required at all)
async function foobar() {
  return Promise.resolve(1)
}

foobar().then(alert)  // 1

// "await" suspends the current function execution until the promise settles, and then resumes it with the promise result, or throws exception
// await keyword works only inside async functions (or top-level in newer JS environments), otherwise error!
let value = await promise

// its just a more elegant syntax of getting the promise result than promise.then handler
let promise = Promise.resolve(1)
let result = await promise    // 1

// there is no CPU resource wastage because JS engine delegates CPU to other tasks and doesn't get blocked

// error handling - if a rejection is there in awaited promise, an exception is generated
async function f() {
  await Promise.reject(new Error("Whoops!"))
}

// below is equivalent to the above
async function f() {
  throw new Error("Whoops!")
}

// we can use try...catch block to handle errors
async function f() {
  try {
    let response = await fetch('http://no-such-url')
  } catch(err) {
    alert(err)  // TypeError: failed to fetch
  }
}
f()

// or we can use catch handler on the returned implicit promise from the function
async function f() {
  let response = await fetch('http://no-such-url')
}

// result of f() call becomes a rejected promise
f().catch(alert)  // TypeError: failed to fetch

```

### Trick Question on await (Async Processing)
```js
console.log("Script start")
async function asyncFunction() {
    console.log("Inside async function")
    await new Promise(resolve => setTimeout(resolve, 1000))  // simulating another async operation
    console.log("After await")
}
asyncFunction()   // don't "await" here
console.log("Script end")

/*

Script start
Inside async function
Script end
After await

*/

// Explanation - await stops the current function's (asyncFunction) execution and puts a handler on the Promise inside it in the microtask queue and continues the execution of main script until the inside Promise resolves
```