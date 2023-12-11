+++
title = "Typescript"
date = 2023-12-10T17:00:00+05:30
weight = 3
pre = "<i class=\"devicon-typescript-plain colored\"></i> "
+++

## Static Type-Checker
TypeScript is superset of JavaScript which adds syntax for types. It has a "compiled" in the sense that TS code transpiles to JS when we run the compiler.

Produces JS code which can then be interpreted to run. Introduces types and safety features to JS, but in order to be fully replaceable with JS it [doesn't enforce](https://www.typescriptlang.org/docs/handbook/2/basic-types.html#types-for-tooling:~:text=Why%20should%20converting%20it%20over%20to%20TypeScript%20stop%20you%20from%20running%20it%3F) types. 

**Acts merely as a [static type-checker](https://www.typescriptlang.org/docs/handbook/typescript-from-scratch.html#typescript-a-static-type-checker)**. It flags errors to console and still produces JS code since whatever we maybe writing is valid in JS anyways (since it is dynamically typed).

The Typescript compiler `tsc` produces a `foobar.js` file and prints any errors to console:
```sh
$ tsc foobar.ts
```

## Not only Types
Typescript can prevent us from shooting ourselves in the foot in a lot of other ways:
```js
if ("" == 0) {
  // true! But why??
}

if (1 < x < 3) {
  // true! for *any* value of x!
}

const obj = { foo: 10, bar: 15 };
const area = obj.foo * obj.baz;		// baz is NaN. It doesn't even exist!
```

All of the above unexpected behaviors can be caught if we can "check" before running the JS somehow - Typescript is the answer!

## Types
Specify type to the right of everything separated by a colon `:`

```ts
function foobar(x: number, y: number): number{ return x * y; }

const foobar = (s: any, t: string): string => {	}

class Foo {
	name: string
	age: number
}

// introduces generics too
class Bar<T, U> {	}
let list: Array<number> = [1, 2, 3];
```

**Type Alias**: define new name for an existing type
```ts
type Point = {
  x: number;
  y: number;
};

// ID can be both (union types) (OR)
type ID = number | string
```

## References
- https://www.typescriptlang.org/docs/
- https://learnxinyminutes.com/docs/typescript/
