+++
title = "Generators & Async Iteration"
date =  2025-01-21T18:10:00+05:30
weight = 9
+++

## Generators
```js
// Generators can return ("yield") multiple values, one after another, on-demand. They work great with iterables, allowing to create data streams with ease

function* generateSequence() {
  yield 1
  yield 2
  return 3
}

// "generator function" creates "generator object"
let generator = generateSequence()
alert(generator) 	// [object Generator]

// generator execution starts on first next() and then pauses instantly, then on next next() call, it resumes execution of generator till the next "yield"
let one = generator.next()
alert(JSON.stringify(one))	 // {value: 1, done: false}

let two = generator.next()
alert(JSON.stringify(two))	 // {value: 2, done: false}

let three = generator.next()
alert(JSON.stringify(three))	// {value: 3, done: true}

// generator object is iterable, but it skips "return" and only considers "yield"
for(let value of generator) {
  	alert(value) 	// 1, then 2
}

// we can also use generators to create iterable objects
let range = {
  from: 1,
  to: 5,

  *[Symbol.iterator]() { // a shorthand for [Symbol.iterator]: function*()
    for(let value = this.from; value <= this.to; value++) {
      yield value
    }
  }
}

alert( [...range] ) 	// 1, 2, 3, 4, 5

// to call a generator inside a generator use "yield*" and it will act as if we inlined the code from another generator (embed)
yield* anotherGenerator()

// "yield" is a two-way street; we can also use it to set yielded value from caller to generator using "generator.next(arg)"
function* gen() {
  // pass a question to the outer code and wait for an answer
  let result = yield "2 + 2 = ?"
  alert(result)
}
let generator = gen()
let question = generator.next().value 	// line 1 - yield returns the value
generator.next(4) 	// line 2 - pass the result into the generator

/*

line 1 - gen() execution pauses after "yield" and stores string in "question" variable

line 2 - on generator.next(4), it resumes and sets "result" value to 4 because of double-sided "yield", then it alerts 4 

*/

// use this to explicitly throw exception at a point in the paused generator
generator.throw(new Error("Oops! Error occured."))

// use this to instantly return from a generator
function* gen() {
  yield 1
  yield 2
  yield 3
}

const generator = gen()

generator.next()		// { value: 1, done: false }
generator.return('foo')	// { value: "foo", done: true }
generator.next()		// { value: undefined, done: true }

```

## Async Iterators and Async Generators
```js
// Asynchronous iteration allow us to iterate over data that comes asynchronously, on-demand. Ex - chunk-by-chuk data of a big file, etc.

/*

To make an object iterable asynchronously:

Use Symbol.asyncIterator instead of Symbol.iterator
The next() method should return a promise (to be fulfilled with the next value) - async next()
To iterate over such an object, we should use a for await (let item of iterable) loop

*/

// Features that require sync iterators won't work with async iterators. So spread syntax and for...of loop won't work with async iterators

// Async Generators - prepend function* with asyn and then use for await (...) to iterate over it
// async generators can also replace async iterators just like their sync counterparts

```