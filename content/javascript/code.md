+++
title = "Code"
date =  2024-12-24T22:26:00+05:30
weight = 2
+++

```js
// semicolons (;) are optional in JS for the programmer to terminate statements with in source code. It automatically inserts semicolon based on a set of rules called Automatic Semicolon Insertion (ASI). Always pick a side and stick to it, use styling guides such as Prettier or Airbnb Style Guide.


// Variables
var name = "foobar"		// old way (not recommended)
let name = "foobar"
const name = "foobar"	// constant

let name;		// "undefined" is put into this as value until assigned explicitly


// Data Types
let msg = "hello"
msg = 123456		// no error; JS is dynamically typed

// numbers
let num1 = 123
let num2 = 12.34
let num3 = 123n		// BigInt

// special numeric values
Infinity
-Infinity 
NaN

// NaN represents a computational error
// NaN is sticky. If there's a NaN somewhere in a mathematical expression, it propagates to the whole result (there’s only one exception to that: NaN ** 0 is 1)
// It makes maths "safe" in JS. At worst, we get NaN

// strings
let str = "Hello"
let str2 = 'Single quotes are ok too'
let str3 = `can embed another ${str}`

// char type doesn't exist, only string

// boolean
true
false

// special values
null			// empty or value unknown
undefined		// not assigned

// object type for more complex data structures
// symbol type for unique identifiers

// typeof operator
let x = 9
typeof x	// number
x = "foo"
typeof(x)	// string


// Type Casting

// anything to string
let num = 123
let str = String(num)

// anything to number
let str = "123"
let num = Number(str)

// common numeric conversions
undefined 	// NaN
null		// 0
true/false	// 1/0 respectively
string		// either a number or NaN

// anything to boolean
let bit = 1
let isSet = Boolean(num)

// values that are intuitively "empty", like 0, an empty string, null, undefined, and NaN, become false
// other values become true


// Operators

// unary + is often used to convert non-numeric types to numeric
let n = "98"
typeof n 		// string
let num = +n
typeof num 		// number

// binary + converts numeric to string if atleast one operand is a string
'1' + 2 	// "12"
2 + '1' 	// "21"

// the other operators convert string to numeric, after stripping surrounding whitespaces
'1' - 2 	// -1
2 - '1' 	// 1

// chaining assignments are possible
a = b = c = 5

// comma operator
let n = (1 + 2, 3 + 4)		// a is assigned 7; only last is assigned, rest are ignored

// some trick questions
4 + 5 + "px" 	// "9px"
"px" + 4 + 5 	// "px45" (due to associativity)
"4px" - 2 		// NaN
"  -9  " - 2 	// -11
null + 1 		// 1
undefined + 1 	// NaN
" \t \n" - 2 	// -2


// Comparison
5 > 4 			// true
"A" >= "F" 		// false (lexicographical comparison on strings)
'Bee' > 'Be' 	// true
'a' > 'A'		// true (because its Unicode comparison)

// values are converted to numbers for comparison
'2' > 1 	// true
"0" == 0 	// true

// strict equality: check value as well as type
0 == false		// true
0 === false		// false

// null and undefined are only == to each other and nothing else
null == 0 			// false
undefined == 0 		// false
null == undefined	// true
null === undefined	// false

// Conditional Operator (Ternary)
let result = condition ? value1 : value2

// Logical Operators

// they are short-circuited
// || returns the first truthy value or the last one
// && returns the first falsy value or the last one

null || 0 || 1 				// 1 (first truthy)
undefined || null || 0		// 0 (last)

null && 0 && 1 				// null (first falsy)
1 && 'foo' && 0				// 0 (last)

// !! is sometimes used to convert any type to boolean
!!"foo"
// the first ! converts to boolean and inverses it, then second ! flips it again

// Nullish coalescing operator: if first operand is null or undefined, then return the second
let n = value ?? 'foobar'

// programmers used to use || for this but it can't differentiate between 0/"" and null/undefined
let n = 0 || 'foobar'	// 'foobar' (first truthy)


// Loops
for(;;){ } 
while(condition){}
do{} while(condition)

break;
break label;
continue;
continue label;

switch 	// works as expected 


// Functions

function sayHello() {
	alert('Hello World!')
} 

let userName = 'Alice'	// outer variable (shadowing possible in JS)
function sayHello() {
  let userName = "Bob" 	// local variable
  alert(userName)		// Bob
}
sayHello()
alert(userName)		// Alice

// a function can be called with any number of parameters
function sayHello(userName, greeting) {
	alert(greeting + ' ' + userName)
}
sayHello('Hello')	// userName is undefined

// specify default (should be last param, can be expression or method call, evaluated only when argument not passed in caller)
function sayHello(userName, greeting = 'Hello') {
	alert(greeting + ' ' + userName)
}
sayHello('Alice')
sayHello('Alice', 'Hello', 'foo', 'bar')	// extra params are ignored

// old way to handle missing params
function sayHello(userName, greeting) {
	if(greeting === undefined){
		greeting = 'Hello'
	}
	alert(greeting + ' ' + userName)
}

// we can also use the below
greeting = greeting || 'Hello'
greeting = greeting ?? 'Hello'

return 		// a function with an empty return or without it returns undefined

// function expressions: function can be put in variables and called later (callbacks)
let sayHello = function(){
	alert('Hello') 
};
sayHello()
alert(sayHello)		// prints function source code text

function sum(a, b) {
  return a + b
}

let sum = function(a, b) {
  return a + b
};

// arrow functions
let sayHello = () => { alert('Hello') }
let sum = (a, b) => { return a+b }
let sum = (a, b) => a+b 	// much shorter way
```
