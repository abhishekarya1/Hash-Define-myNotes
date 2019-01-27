+++
title = "Basics"
date =  2019-01-27T22:27:43+05:30
weight = 1
pre = "<b>1. </b>"
+++

### C Standard
The latest C standard is [ISO/IEC 9899:2011](https://en.wikipedia.org/wiki/C11_(C_standard_revision)), also known as [<mark>C11</mark>](https://en.wikipedia.org/wiki/C11_(C_standard_revision)) as the final draft was published in 2011. Before C11, there was C99. The C11 final draft is available [here](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf).

#### Standard main()
It shall be defined with a return type of `int` and with no parameters or with two parameters (referred to here as `int argc` and `char *argv`).

#### Limitations of Standard
C standard leaves some behavior of many C constructs as <mark>undefined</mark> and some as <mark>unspecified</mark> to simplify the specification and allow some flexibility in implementation.

#### Some Examples

```c
void main() { ... }
``` 

Standard says that return type of `main()` should be `int`. It is <mark>implementation-defined</mark>.

```c
#include<stdio.h> 
int main() 
{ 
	int i = 1; 
	printf("%d %d %d\n", i++, i++, i); 
	return 0; 
} 
```

Standard does not specifies the order in which the function designator, arguments, and subexpressions within the arguments are evaluated in a function call (6.5.2.2). It is <mark>unspecified behaviour</mark>.


- `int` has (1 sign bit + 31 data bits), 1 bit is reserved to store sign that can be + (_sign_bit = 0_) or - (_sign_bit = 1_).
- MinGW specifies `int` size as 4 byte (32 bits)
- It can only store numbers till 2147483647

```c
int num=2147483647; 	//binary representation = 1111111111111111111111111111111

### int keyword in C
- If we try to store any number greater than 2147483647 into an `int` type variable then we will lose information.