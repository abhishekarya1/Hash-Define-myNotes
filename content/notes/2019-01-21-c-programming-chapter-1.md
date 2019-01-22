---
title: Preface & Chapter 1 - A Tutorial Introduction
date: 2019-01-21
---

# Preface

## What C gets right.

- C is a general-purpose programming language.
- It is not a very high level language, nor a big one.
- It was originally designed for and implemented on the UNIX operating system.
- Very useful for writing operating system, compilers and system programs and hence it is also called a "systems programming language".
- Many important ideas in C stem from BCPL and B. [BCPL -> B -> C]
- BCPL and B are "typeless" languages, they don't have data types defined. 
- On the other hand, C provides a variety of data types, as well as a hierarchy of derived data types like structure and union.
- Expressions are statements in C.
- Pointers provide machine-independent address arithmetic.
- Control flow constructions - for, while, if-else, etc.
- Functions in C might be in separate source files that can be compiled separately.
- Concept of Local(Automatic) and Global variables.
- Preprocessing to include libraries and to perform macro expansion.

## Some Features of C
- C provides no input/output facilities(READ or WRITE).
- C provides no operation to deal directly with composite objects such as strings and arrays.
- No storage allocation other than static definition and stack discipline provided by local variables of functions.
- There is no heap and garbage collection.
- C offers only straightforward, single-thread control flow: tests, loops, etc., but no parallel operation, multiprogramming, sync, or coroutines.
- C Programming language was standardized by ANSI (American National Standards Institute) in 1988.
- ANSI C also included definition of a library to accompany C. It specifies functions for accessing the operating system (Read/Write), 
formatted input and output, memory allocation, string manipulation, etc. This library is closely modeled on the "standard I/O library" of the UNIX system.

---
# Chapter 1: A Tutorial Introduction

- `main()` - The program begins executing at the beginning of main and there must be atleast one in the program.
- `"Hello, world"` - a sequence of characters in double quotes is called a _string constant_ or _character string_ or _string literal_.


	| Escape Sequence | Function          
	| --------------- | ---------------   
 	| \n              | Newline character   
	| \t  		      | Tab character                 
	| \b  		      | Backspace character          
	| \"              | Double quotes       
	| \\\\     | Backslash itself    


- `/*.....*/` - Multi-line comment.

	| Data type    | Size (in Bytes)    | Range             |
	| ------       | ---------------	| -------           |
 	| int          | 2  				|	-32768 to +32767|
	| float        | 4   				| 	10<sup>-38</sup> to 10<sup>+38</sup>  |	
 	| char         | 1  				|	                |	
	| long integer | atleast 4   		| 					|
	| short integer|            		| 					|
	| double       | 8   				| 					|

**The above sizes are machine-dependent.**

- Storing foating point number in `int` _truncates_ it (i.e. strores only the integer part).

- In the below code, `%` followed by character indicates where the arguments are to be substituted.

```c
printf("%d \n", num);		//integer

printf("%ld \n", num);		//long integer

printf("%f \n", num);		//float, double

printf("%c \n", fname);		//char

printf("%s \n", fname);		//string

printf("%o \n", num);		//octal

printf("%x \n", num);		//hexadecimal

printf("%% \n", num);		//for % itself

```
- A decimal point in a constant indicates that it is a floating point e.g. 5 is integer, 5.0 is float.

```c
printf("%d \n", num);		// integer has 6 digits width

printf("%f \n", num);		// integer has 6 digits width

printf("%6d \n", );		// integer has 6 digits width

printf("%.3f\n", );		// float can have any width integer part but decimal part has a limit of 3 digits
		
printf("%.0f\n", );		//supresses printing of the decimal point and the fractional part 

printf("%3.2f\n", );	// atleast 3 wide, 2 after decimal point

```

The width in the integer part does not actually play a part as evident from below.

```c
#include<stdio.h>

int main()
{
	float n = 656.56789;
	
	int m = 251;

	printf("%2.3f\n", n);

	printf("%2d\n", m);

	printf("%.0f\n", n);

	return 0;
}

Output: 656.568			//rounded off to only 3 decimal places
		251				//no effect
		657				//whole decimal part rounded off with no digit left after decimal
```

- Symbolic Constants

`#define name replacement-text`

```c
#define  LOWER  0
#define  UPPER  300
#define  STEP   20

// We can now proceed to use the above defined constants throughout the program as it is.

// They are written in uppercase to distinguish them from variables.
```

- **Character input and output** - `getchar()` and `putchar()` - Standard library provides them to read/write just one character at a time.

```c
c = getchar();		//reads the next character from text stream and return its value

putchar(c);		//prints a character each time it is called
```

- **End Of File (`EOF`)** - EOF is just a symbolic constant stored in <stdio.h> with some integer value that we don't need to know. Whenever a file ends it returns a value that cannot be confused with any character's integer value, that value is EOF.

- Precedence of `!=` is higher than `=`. 

- Expressions can be evaluated inside the loop condition. 

```c
#include<stdio.h>

main(){

	int c;

	while((c = getchar()) != EOF)		//getchar() call is perfectly fine here
		putchar(c);
}
```

- **Assignment**

```c
nl = nw = nc = 0;

//above expression is evaluated as follows

(nl = (nw = (nc = 0)));

```

- **Functions** - Declaration (Prototype), Definition, Call.

```c

int func(int n, int m);		//Declaration

or

int func(int , int);		//also valid

```

```c
int func(int n, int m)		//formal paramters (parameters)
{

	//function statements

	return expression;		//zero implies normal termination, otherwise unusual or errorneous termination
}

main()
{
	func(x,y);		//actual parameters (arguments)
}
```

- **Functions are always CALLED BY VALUE in C**. We can be assured that the variables are always local to a called routine.

- **Character arrays** are called _Strings_, they are terminated by a `'\0'` character which may not be the part of our actual string but is very much a part of the character array. Besides this they work just like an integer array.

```c
char str[4] = "abhi";	

//this will lead to error that the string is too long beacuse we need one element (last element) of a character array for '\0' character
```
- **External Variables and Scope** - Local variables are called _automatic variables_ because they are used automatically whenever we're inside the scope/function. Global variables are called _external variables_ and they must be defined exactly once outside any functions.

When using external variables before even defining them in the souce file we might have to declare them using - `extern` keyword.

```c
int foo()
{
	extern int num;
	//other statements
}

int num = 2;		//external variable

main()
{
	foo();
}
```
Note that the external variables are also there when we don't need them, so we must avoid using them too much.