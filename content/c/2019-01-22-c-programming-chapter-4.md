+++
title = "Chapter 4 - Functions and Program Structure"
date =  2019-01-22T23:16:53+05:30
weight = 5
+++

- **Advantages of using Functions** -
	- Large computing tasks can be separated into smaller ones, so long as no function is split.
	- Abstraction
	- Easing the pain of making chanfges to code
	- Source program can be stored across multiple files
	- Code reusability

### Basics of Functions

```c

return-type function-name(argument declarations)
{
	declarations and statements //body
}
```
- If the return type is omitted during function declaration, it is assumed to be `int`.
- To return a value to the caller `return` is used.

```c
return expression;		//expression can be converted to the return type of the function if necessary
```
- A function can return a "garbage value" or no value.

### Functions Returning Non-integers

```c

double func(char arr[])			//return type is double
{
	//body

	return sign;
}

//we can declare it in main() which is optional

main()
{
	double func(arr[]);			//same type here, otherwise meaningless answers
}
```

```c
double func(char arr[])			//return type is double
{
	int sign;
	//body

	return sign;			//sign will be converted to double when returning value
}
```
- Statements following a `return` have no significance and are useless.

- If a function uses no arguments, use `void`. Don't leave it blank as parameter checking is turned off then and it is still there just for backwards compatibility.

```c
int func(void) {...}
```

### External Variables
- Variables "external" to _any_ function a.k.a global variables.
- References to them are same no matter from where we're accessing them.
- They have a scope that lasts for the lifetime of the whole program unlike automatic variables.
- No function can be defined inside any other function in C. 

### Scope Rules
- **Automatic variables** have a scope that is limited to the function in which they are declared.
- **External variables** have program scope.
- **Declaration** announces the properties of a variable while a **Definition** also causes storage to be set aside.

Same program in different files:

```c
file1 - 

extern int p;	//declared wherever required
extern float q;

file2 - 

int p;		//external variables are defined only once
float q;

```

### Header Files
- After we divide the program into separate source files and using external variables from another file, we can store this file that contains external variables as a **header** file with an extension `.h`.

![Header File](/img/header.PNG)

Each file that needs the `calc.h` header file has `#include "calc.h"` in the beginning as preprocessor directive.

- There is a tradeoff bwetween the desire that each file have access only to the information it needs for its job and the practical reality thaat it is harder to maintain more header files. Upto moderate program size, we should try to keep one header file.

### Static Variables
- Static variables are specified by specifier `static`
- They are external variables that can only be accessed by the functions inside the same file and not by other functions not in the same file but are of the same program. Hence the names will also not conflict with other variables in differrent files.

```c
static char buf[BUFSIZE];
static int bufp = 0;

int getch(void) { ... }

void ungetch(int c) { ... }
```
- `static` can also be used for functions. the functions declared `static` will be invisible to the functions in the other files of the same program.
- `static` can also be used for local variables and are invisible to other functions but they remain (retain value) there even when we enter and leave functions unlike automatic variables which are initialized everytime we call their parent function.

###