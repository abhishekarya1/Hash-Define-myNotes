+++
title = "Useful Stuff"
date =  2019-01-27T22:27:43+05:30
weight = 1
+++

- **After the pre-processing is over, all the undefined macros are initialized with default value 0**.

### Inline Functions in C

```c
inline int square(int x) { return x*x; } 
int main() 
{ 
int x = 36/square(6); 
printf("%d", x); 
return 0; 
} 

// OUTPUT: 1 
```
- A `.i` file is generated after pre-processing of a C program.

- What is the use of `#pragma once`?

Used in a header file to avoid its inclusion more than once.

### An Interesting Case

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

**OUTPUT: 5**

-   The translator which performs macro calls expansion is called **Macro pre-processor**.
	- A **Macro-processor** is a program that copies a stream of text from one place to another, making a systematic set of replacements as it does so.
	- A **Dynamic linker** is the part of an operating system that loads and links the shared libraries.

### Line Splicing in C/C++

Lines terminated by a single `/` are spliced together with the next line very early in the process of translation.

```c
// C program to illustrate the concept of Line splicing. 
#include <stdio.h> 
int main() 
{ 
	// Line Splicing\ 
	printf("Hello GFG\n"); 
	printf("welcome"); 
	return (0); 
} 

```
**OUTPUT: welcome**

- Line splicing is used when defining a  macro which contains multiple lines.

```c
#include <stdio.h> 
#define MAX(a, b) \
		if(a>b) \
			printf("%d\n", a);
int main() 
{ 
	MAX(5, 2);
} 
```

**OUTPUT: 5**

### How Linkers Resolve Global Symbols Defined at Multiple Places?

Link: https://www.geeksforgeeks.org/how-linkers-resolve-multiply-defined-global-symbols/

### Scope Question
C uses lexicographic/static scope that can be seen by the programmer as if he is substituting values in place of variables in code. Not determined at the runtime, through runtime stack.

### Octal number starts with a 0

```c
int main()
{
  int x = 032;
  printf("%d", x);
  return 0;
}
```
**OUTPUT: 26**

### Signals in C
Link: https://www.geeksforgeeks.org/program-error-signals/

### Reinitializing Global Variables in C
C allows a global variable to be declared again **only** when the first declaration doesn't initialize the variable.

### Initialization of global and static variables in C
- In C, `static` and `global` variables are initialized by the compiler itself. Therefore, they **must** be initialized with a **constant value**.
- The above mentioned property does not apply to C++.

### Scope vs. Linkage and Internal Linkage and External Linkage in C

Link: https://www.geeksforgeeks.org/internal-linkage-external-linkage-c/

### (9/5) in C is and int
Consider - 

```c
#include <stdio.h>
 
int main()
{
   float c = 5.0;
   printf ("Temperature in Fahrenheit is %.2f", (9/5)*c + 32);
   return 0;
}
```

**OUTPUT: Temperature in Fahrenheit is 37.00**

### Const Qualifier in C with Pointers

Up Qualification / Down Qualification

Link: https://www.geeksforgeeks.org/const-qualifier-in-c/

### Volatile Qualifier in C

Objects declared as `volatile` are omitted from optimization because their values can be changed by code outside the scope of current code at any time. The system always reads the current value of a volatile object from the memory location rather than keeping its value in temporary register at the point it is requested, even if a previous instruction asked for a value from the same object.

### Typedef is a storage-specifier in C. The onlt storage specifier allowed inside a function parameter is `register`.

### sizeof() returns type size_t which is the largest unsigned type on that machine, usually `unsigned long int`

### sizeof() is done at compile time.

### Don't use gets(), Format string vulnerabilities

Link: https://www.geeksforgeeks.org/format-string-vulnerability-and-prevention-with-example/

```c
char buf[8]; /* tiny buffer, easy to overflow */

printf("What is your name?\n");
scanf("%s", buf); /* WRONG */
scanf("%7s", buf); /* RIGHT */
```

If the user enters a string longer than 7 characters (- 1 for the null terminator), memory behind the buffer buf will be overwritten. This results in undefined behavior. Malicious hackers often exploit this in order to overwrite the return address, and change it to the address of the hacker's malicious code.

Check below note from Linux man page.

Never use gets(). Because it is impossible to tell without knowing the data in advance how many characters gets() will read, and because gets() will continue to store characters past the end of the buffer, it is extremely dangerous to use. It has been used to break computer security. Use fgets() instead. Also see this post.

### Implicit type conversions always convert from lower(smaller) data type to higher(bigger) data type. Be careful when comparing signed int and unsigned int as signed will get converted to unisgned (2's complement if overflow) and the sign will be lost.

### 0.1 is non-terminating recurring in binary, 0.5 is not, it is just 0.1 in binary. 
So, 0.5 is same in `float` as well as `double` but 0.1 is `truncated` to 23 bits after decimal in `float` and to 52 bits in `double`.

### Dynamic Scoping Vs Static Scoping
Link: https://stackoverflow.com/questions/19461503/dynamic-and-static-scoping-program-differences/19461570

### MIND BLOWING - Q:4, 5, 6, 10, 19, 20
Link: https://www.geeksforgeeks.org/c-language-2-gq/input-and-output-gq/