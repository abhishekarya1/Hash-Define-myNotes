+++
title = "Modules"
date =  2025-01-02T23:24:00+05:30
weight = 5
+++

## Intro

```js
// modules weren't part of JS language for a long time and people used third party libraries
// now they are present and part of standard since 2015

// a module is simply a .js file (i.e. a script)

/*

Features of modules:
- Can only be used in strict mode.
- Each module has its own top-level scope. So global vars of a module aren't accessible in other modules.
- A module code is evaluated only the first time when its imported. 
- When a variable or object is imported, its reference is imported and a new copy isn't made. Exports are created once and shared between importers.

*/


// 📁 sayHi.js
export function sayHi(user) {
  alert(`Hello, ${user}!`)
}

// 📁 main.js
import {sayHi} from './sayHi.js'

alert(sayHi)	 // function
sayHi('John')	 // Hello, John!

// a module code is evaluated only the first time when its imported

// 📁 alert.js
alert("Module is evaluated!")

// 📁 1.js
import `./alert.js`

// 📁 2.js
import `./alert.js`

// 📁 3.js
import `./alert.js`

// prints "Module is evaluated!" only once, evaluated only on 1.js import


// when a variable or object is imported, its reference is imported and a new copy isn't made

// 📁 admin.js
export let admin = {
  name: "John"
}

// 📁 1.js
import {admin} from './admin.js'
admin.name = "Pete"

// 📁 2.js
import {admin} from './admin.js'
alert(admin.name)	 // Pete

// Both 1.js and 2.js reference the same admin object, changes made in 1.js are visible in 2.js


/*

Build tools like Webpack do the following:
- build a single file with all modules (or fewer files)
- unreachable code removed
- unused exports removed ("tree-shaking")
- evelopment-specific statements like console and debugger removed
- modern, bleeding-edge JavaScript syntax may be transformed to older one with similar functionality using Babel
- the resulting file is minified (spaces removed, variables replaced with shorter names, etc)

So basically they overwrite every module configuration that we do in lieu of performance optimization.

*/
```

## Export/Import

```js
// we can export variables, functions, or classes

// just add a export keyword before normal declarations (named exports)
export let months = ['Jan', 'Feb', 'Mar','Apr', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

export const CURRENT_YEAR = 2025

export function sayHi(user) {
  alert(`Hello, ${user}!`)
}  	// no ; at the end

// export separate from declarations; place this at the bottom of the module
export {months, CURRENT_YEAR, sayHi}

// named imports
import {sayHi, sayBye} from './say.js'
sayHi()
sayBye()

// import all
import * as say from './say.js'
say.sayHi()
say.sayBye()

// rename imports
import {sayHi as hi, sayBye as bye} from './say.js'

// rename exports
export {sayHi as hi, sayBye as bye}

// export default - used to specify default export of a module, hence only one such export per module
export default function sayHi(user) {
  alert(`Hello, ${user}!`)
}

import sayHi from './say.js'		// no curly braces


// technically, we may have both default and named exports in a single module (anti-pattern) (use "default" as name)

// 📁 user.js
export default class User {
  constructor(name) {
    this.name = name
  }
}

export function sayHi(user) {
  alert(`Hello, ${user}!`)
}

// 📁 main.js
import {default as User, sayHi} from './user.js'

new User('John')

// "default" name with import all
import * as user from './user.js'

let User = user.default 	// the default export
new User('John')

// re-export
export {sayHi} from './say.js' 	// re-export sayHi

// re-exporting the default export needs special considerations
```

## Dynamic Import

```js
// we can't dynamically generate any parameters of import
// to do so use import(), it is not a function, just a special syntax with parentheses

// we can use it anywhere in code and it returns a promise that resolves into a module object that contains all its exports 

let {hi, bye} = await import('./say.js')

// or in case of a default export
let obj = await import('./say.js')
```