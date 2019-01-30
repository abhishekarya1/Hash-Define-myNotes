+++
title = "Functions and Program Structure"
date =  2019-01-22T23:16:53+05:30
weight = 5
pre = "<b>4. </b>"
+++

### Some advantages of using functions

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

1. A declaration can be done any number of times but definition only once.
2. `extern` keyword is used to extend the visibility of variables/functions.
3. Since functions are visible throughout the program by default. The use of `extern` is not needed in function declaration/definition. Its use is redundant.
4. When extern is used with a variable, it’s only declared not defined. Ex - In `extern int a;`, a is not assigned any value and using it throws an error in compilation.
5. As an exception, when an `extern` variable is declared with initialization, it is taken as the definition of the variable as well. Ex - `extern int a = 4;`

Program in different files:

```c
file1 - 


int p = 4;		// external variables are defined only once
float q;

file2 - 

extern int p;	// declared wherever required
extern float q;

```

**Command Line command to link both Files together - `gcc file1.c file2.c`**


```c
// filename: 'file1.c'
int a; 
int main(void) 
{ 
	a = 2; 
} 

// filename: file2.c 
// When this file is linked with 'file1.c', functions of this file can access 'a' 
extern int a; 
int myfun() 
{ 
	a = 2; 
} 
```

### Header Files
- After we divide the program into separate source files and using external variables from another file, we can store this file that contains external variables as a **header** file with an extension `.h`.

![Header File](/img/header.PNG)

Each file that needs the `calc.h` header file has `#include "calc.h"` in the beginning as preprocessor directive.

- There is a tradeoff bwetween the desire that each file have access only to the information it needs for its job and the practical reality thaat it is harder to maintain more header files. Upto moderate program size, we should try to keep one header file.

### Static Variables
- Static variables are specified by specifier `static`.
- They are external variables that can only be accessed by the functions inside the same file and not by other functions not in the same file but are of the same program. Hence the names will also not conflict with other variables in differrent files.

```c
static char buf[BUFSIZE];
static int bufp = 0;

int getch(void) { ... }

void ungetch(int c) { ... }
```
- `static` can also be used for functions. the functions declared `static` will be invisible to the functions in the other files of the same program.
- `static` can also be used for local variables and are invisible to other functions but they remain (retain value) there even when we enter and leave functions (they are initialized the first time we enter a function, and never leave that value even if we try to change it) unlike automatic variables which are initialized everytime we call the function.

```c
int main() 
{
	int x = 3;
	while (x > 0) 
    { 
        static int y = 5; 	// ignored after first iteration/initialization
        y++; 
  
        printf("The value of y is %d\n", y); 
        x--; 
    } 
}
```
**OUTPUT: The value of y is 6**
		**The value of y is 7**
		**The value of y is 8**

### How are variables scoped in C – Static or Dynamic?
In C, variables are always [statically (or lexically) scoped](http://en.wikipedia.org/wiki/Scope_%28programming%29#Lexical_scoping) i.e., binding of a variable can be determined by program text and is independent of the run-time function call stack.

For example, output for the below program is `0`, i.e., the value returned by `f()` is not dependent on who is calling it. `f()` always returns the value of global variable `x`.

```c
# include <stdio.h> 

int x = 0; 

int f() 
{ 
	return x; 
}

int g() 
{ 
	int x = 1; 
	return f(); 
} 

int main() 
{ 
	printf("%d", g()); 
	printf("\n"); 
	getchar(); 
} 

```
**OUTPUT: 0**

### Register Variables
- Variables specified using the `register` qualifier are an indication to the compiler that they will be used frequently and it should store them in registers which are only a few.
- Only automatic variables and formal parameters of a function can be made register variables.
- They are specified using `register`.
- Excess declarations with `register` are harmless, beacause it is then ignored. Further specifications vary across compilers.
- It is not possible to take the value of the register variable.

```c

register int x;
register char c;

//functions

f(register unsigned m, register long n)
{
	resigter int i;
	...
}
```

### Block Structure
- Blocks are specified by `{ }`, and variables declared and initialized inside a block remain automatic for only that block and there is no name clash with other variables outside the block.

```c
int x;
int y;

func(int x)
{
	int y;
	...
}
```
In the above code, within the function `func` occurances of `x` refer to the parameter `double x` and all occurances outside `func()` refer to the external `int x`.

### Initialization
- Variables are always initialized. External variables always with 0, and register and automatic variables with garbage values.
- While initializaing an external variable, the value needs to be a constant, which is not always the case with automatic variables.

##### Array Initialization

```c

int arr[] = {1, 2, 3, 4};  //size not specified, decide from the initializers = 4

int arr[4] = {1, 2, 3, 4, 5}  //error

int arr[4] = {1, 2}  //rest will be initialized with 0 weather arr[] is external/automatic, or register

char name[] = "two"  //size = 4
/* OR */
char name[] = {'t', 'w', 'o'}
```

### Recursion
- Automatic variables are initialized in each call again independent of previous set of values.
- No saving in space as stack is maintained for each call.
- Compact code better for recursively defined data structures like trees.

### The C Preprocessor

| Preprocessor Directives 				| Function          
| ---------------						| --------------- 
| #include "..." or #include <...>   		| Header File Inclusion   
| #define  		      					| Macros (#_replacement-text_, _first_ ## _second_)
| #if  		      						| Conditional Preprocessing                 	                 
| #endif  		      					| "
| #elif 		      					| "     
| #else  		      					| "
| #ifdef  		      					| "         
| #ifndef     		  					| "   

- **File Inclusion** - `#inlcude "filename"` or `#include<filename>`. 
	- `#include` is in itself a collection of many `#define` and an included file may contain further `#include`.

- **Macro Substitution** - `#define name replacement-text`. Here, `name` cannot be inside quotes `"..."`.

```c
#define forever for(;;)  //infinite loop

#define max(a, b) ((a > b) ? (a) : (b))
```

- `#undef` undefines macros

```c
#undef func
```
- The preprocessing operator '#' is used to convert a string argument into a string constant.
- Use `#` preceeding a replacement text to and it will be expanded as a quoted string `"..."`.

```c
#define dprint(expr) printf(#expr " = %f\n", expr)

//example -
dprint(x/y);

//expanded as -
printf("x/y" " = /f\n", x/y);

//strings will get concatenated as - 
printf("x/y = %f\n", x/y);
```

- If a macro has `##` adjacent to arguments, in the expansion white spaces will be removed and arguments will be concatenated. Ex - 

```c
#define paste(first, second) first ## second

//call
paste(name, 1);

//result is -
name1
```

### Conditional Inclusion
- Preprocessing can be controlled using these.
- We can check if a header file has been previously added by checking if the macros are defined using `defined(name)` function inside an `#if`-`#endif` block which returns 1 if defined, and 0 otherwise.

```c
#if !defined(HDR)
#define HDR

/* contents og hdr.h go here */

#endif
```

- The `#ifndef` and `#ifdef` are specialized forms that test wheather a name is defined.

Above cde can be alternatively written as - 

```c
#ifndef HDR
#define HDR

/* contents og hdr.h go here */

#endif
```

