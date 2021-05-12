+++
title = "Notes.md"
date = 2021-05-12T23:08:21+05:30
weight = 1
pre = "<i class=\"devicon-c-line\"></i> "
+++

**C** - Low level, structured, procedural, and statically typed programming language. [Some more info here](/c/c-dennis-ritchie/2019-01-21-preface/).

Developed at Bell Labs in 1970s by Dennis Ritchie and Ken Thompson.

**Inspirations:** BCPL -> B -> C

**Standards:** K&R C (unofficial), ANSI C (aka C89), C99, C11, C18, C2x (to be reviewed in Dec 2021).

---
## Basics

#### Standard vs Vendors
**Undefined** - Dangerous, often mentioned in standard, causes surprises. Ex - Divide by 0, segment violations. 

**Unspecified** - Not specified by standard. Ex - Order of function parameter evaluation.

**Implementation defined** - Vendors are free to implement and document. Ex - Size of data types.

#### Simple Program structure
```c
#include<stdio.h>

int main(int argc, char*[] argv){	// char** argv

printf("Hello World!");

return 0;
}
```

#### Parameters of main()
```c
main()	// can be called with any number of parameters
main(void)	// no parameters can be present during call
```

#### Stages
```c
										Static Libraries
											|
Preprocessor -> Compiler -> Assembler -> Linker -> Loader
	            .i 			.s 		   .o/.obj    .exe
```
#### Error Signals	
```md
SIGSEGV - Segment Violation (invalid access to valid memory, access to memory we don't have access to)            

SIGBUS - (access to an invalid address)

SIGABRT - an abort() call throws this

SIGFPE - Floating-point exceptions (divide by zero error)  

SIGILL - Illegal statement (CPU tried to execute an instruction it didn't understand)

SIGSYS - invalid argument passed to a system call

SIGTRAP - an exception triggered explicitly by debugger 
```

#### Tokens
There are five types of tokens: **keywords**, **identifiers**, **constants**, **operators**, and **separators**. 

##### Keywords
32 keywords in C

##### Identifiers
Name of variables, functions, etc...
- First letter must be an alphabet, underscore(\_) counts as an alphabet. 
- must contain only alphabets, underscorem and numbers, no special characters.
- no whitespaces
- can't be a keyword
- lenght limit is 31 but not enforced in anyway other than as a good formatting rule (https://stackoverflow.com/questions/2352209/max-identifier-length)

##### Constants or Literals
```c
Integer - int, octal (0), hex (0x) 
Real - float(f or F), double(d or D)
Character - 'a'
String - "abhi"
Escape Sequences - '\0', '\"'. '\xFF'
```

##### Operators
```c
Arithmetic - +, -, *, /, %
Relational - <, >, <=, >=, !=, ==
Logical - &&, ||, !
Bitwise - &, |, ~, ^
Assignment - =, compound assignments
Conditional - ?:
Unary - ++, --
Others - comma (,), dereferencing (*), addressof (&)
```
##### Separators

```c
comma (,) 
{}, (), []
```

#### Line Splicing
```c
// this comment extends to next line \
printf("hello");
printf("world");
```
Also works with macros:
```c
#define REPLACE(a, b) if(a < b) \
						a = b;
```


--- 
## Macros and Preprocessor
They can appear anywhere in program.
- Comment Removal
- File inclusion
- Macro expansion
- Conditional inclusion/compilation
- Debugging

```c
Preprocessor directive : #
#include<stdio.h>	// searches in standard list of dir 
#include "myheader" // searches in the current folder first, then standard list of dir

#define PI 3.1415  // macro as object

#define MUL(a, b) a * b // macro as function

#undef
#ifdef
#ifndef
#endif

#if
#endif
#elif
#else

#line n "filename"	// filename is optional

#error "here is your error description" // throws compile time error

#pragma once 	// not standard
		warn
		startup
		exit
```

#### Standard Macros
Mostly used for debugging.
```c
__LINE__
__TIME__
__DATE__
__FILE__
__FUNC__
```

#### Stringizing

```c
#define string_this(a) #a

printf("%s", string_this(Hello));
```
#### Token Pasting

```c
#define combine_these(a, b) a##b

char* name = "Logan";

printf("%s", combine_these(na, me));
```

#### Data type in Macros
They have no control over data types.

#### Pitfalls and Tips
**1.** [include guard](https://en.wikipedia.org/wiki/Include_guard)
**2.** No nesting 
```c
#define foo (foo + 10)
foo
// foo will be replaced by (foo + 10), not further
```
**3.** No macro definition inside a macro definition
```c
#define DEF #define A 999

DEF // won't work
```
**4.** Redefining macros
```c
#define A 99
printf("%s", A);
#undef  // or #define A 88
printf("%s", A);
```
**5.** Macro default initialization
By default, macros are initialized to Zero (0) is not defined previously.
```c
#if X == 3
printf("Yes");
#else 
printf("No");
#endif
```

**6.** Macros don't get pasted in other macro definitions
```c
#define A define
#A B 99		// compile-time error
```

**7.** Not closing macro ifs is a compilation-error.

**8.** An innovative way to block commnent:
```c
#if 0
printf("%s", "A");
printf("%s", "B");
printf("%s", "C");
#endif
```

**9.** Macro arguments are not evaluated before macro expansion
```c
#include <stdio.h>
#define MULTIPLY(a, b) a*b
int main()
{
    // The macro is expanded as 2 + 3 * 3 + 5, not as 5*8
    printf("%d", MULTIPLY(2+3, 3+5));
    return 0;
}
// Output: 16
```
**10.** An Interesting Case
```c
#include<stdio.h>
#define A -B
#define B -C
#define C 5

int main()
{
  printf("The value of A is %d\n", A); 
  return 0;
} 
```
Preprocessed File -
```c
int main()
{
  printf("The value of A is %d\n", - -5);
  return 0;
}
```

### Variadic Macros
```c
 we want: eprintf ("%s:%d: ", input_file, lineno)
     →  fprintf(stderr, "%s:%d: ", input_file, lineno)

#define eprintf(format, ...) fprintf (stderr, format, __VA_ARGS__)  
```

## Command Line Arguments

## Variables and Scoping








## References
- https://www.geeksforgeeks.org/c-programming-language/
- [The C Reference Manual - GNU](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)
- https://books.goalkicker.com/CBook/
- [The C Preprocessor - GNU](https://gcc.gnu.org/onlinedocs/cpp/index.html)
- [Online C Compiler - Programiz](https://www.programiz.com/c-programming/online-compiler/)
