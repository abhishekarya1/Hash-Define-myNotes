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

// Promise - an object that executes a function asynchronously
let promise = new Promise(executorFunc)

// pass a function expression instead
let promise = new Promise(function(resolve, reject) {
  // executor logic
})

// each promise has two internal properties - "state" and "result"
// a promise can either be Settled or Unsettled
// state values - "pending", "fulfilled", or "rejected"
// result values - undefined, errorObj, or doneObj

// "resolve" and "reject" are callbacks provided by JS to call on success and error scenarios respectively
let promise = new Promise(function(resolve, reject) {
	resolve("Done")
	reject(new Error("Oops.."))	// ignored
})

// the promise returns "Promise { 'Done' }" immediately

// always pass an Error object to reject but nothing is really stopping us from passing other objects too

// handlers of promise - then, catch, finally
promise.then(
	function(result) { /* handle a successful result */ },
	function(error) { /* handle an error */ }
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
  throw new Error("error")
})
 .finally(() => alert("Promise ready")) 	// triggers first
 .catch(err => alert(err))  	// catch shows the error

// if a finally handler returns something, its ignored. Exception being an error object, when finally handler throws an error, it is sent forward to the next suitable handler

// we can attach handlers to settled promises, and they run immediately (quite useless though)

// Promise Chaining - if a then (or catch/finally, doesn't matter) handler returns a promise, the rest of the chain waits until it settles. When it does, its result (or error) is passed further.

// Error Handling in Promises
// the code of a promise executor and promise handlers has an "invisible try..catch" around it. If an exception happens, it gets caught and treated as a rejection

new Promise((resolve, reject) => {
  throw new Error("Whoops!")
}).catch(alert)	 // Error: Whoops!

// in chaining, no matter where the error happens, it triggers the next error handler skipping everything in between. So the easiest way to catch all errors is to append .catch to the end of chain, and write only success (first param) for thens in between.

// rethrowing with .then handler
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

// its ok not to use .catch at all, if there's no way to recover from an error. Let JS throw error and we'll know the details of it.

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
```