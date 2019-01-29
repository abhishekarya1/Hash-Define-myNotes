+++
title = "Types, Operators, and Expressions "
date =  2019-01-22T23:16:53+05:30
weight = 3
pre = "<b>2. </b>"
+++

### Variables
- The first haracter must be a letter. Underscore(\_) is a letter. Library functions have variable names that start with an underescore.
- Uppercase and lowercase letters are distinct, X is not the same as x.

### Data Type and Sizes

|Data type	| Keyword    | Size (in Bytes)    | Range             |
|----	| ------       | ---------------	| -------           |
| Character	| char         | 1  				|	                |	
| Integer	| int          | 2  				|	-32768 to +32767|
| Single-precision floating point	| float        | 4   				| 	10<sup>-38</sup> to 10<sup>+38</sup>  |	
| Double-precision floating point	| double       | 8   				| 					|

**Qualifiers** can also be applied to these data types.

- `signed` and `unsigned` applies to `int` and `char` data types.

- `int` will be automatically assumed for unspecified.

Examples - 

```c
signed s;
unsigned u;
long l;
long long ll;
```

```c
short int n;

long int m;

//the word int can be omitted -

short n;

long m;
```
**A compiler is free to choose any size for these.**

- **RULE** - `short` and `int` must be atleast 16 bits, `long` must be atleast 32 bits, and `short` must not be larger than `int` whch must not be larger than `long`.

- `unsigned` variables store zero and positive values only. `signed` stores both. Ex - if `char` is 8 bits, `unsigned` will store from 0 to 255 and `signed` from -128 to 127.

### Constants
- **Integer constant** - 1234
- **long** - 123l or 123L or an integer too big to fit into `int` will be taken as `long`
- **unsigned** - 123u or 123U
- **unsigned long** - 123ul or 123UL
- **Floating-point constant** - 1234.0, their type is `double` unless suffixed with f/F (`float`) or l/L (`long double`)
- **Octal** - leading 0 on an integer - 012
- **Hexadecimal** - leading 0x on an integer - 0x12

```c
Octal and Hex constants may be followed by U or L suffix to make them unsigned or long respectively.

0xFUL  // this is a unsigned long hex with value 15 in decimal 
``` 
- **Character constant** - written within single quotes. Ex - 'A', 'b', etc...

```c
'\0' has an ASCII value of 0.
'0' has an ASCII value of 48 which is unrelated to zero.
```

- **Escape Sequences** 

```c
'\013' - Octal Number

'\xAF' - Hex Number
```

| Escape Sequence | Function          
| --------------- | ---------------   
| \n              | Newline character   
| \t  		      | Horizontal tab character
| \v  		      | Vertical tab character                 	                 
| \b  		      | Backspace character          
| \f  		      | Formfeed
| \a  		      | Alert (bell) character
| \r  		      | Carrige return          
| \'     		  | Single quote    
| \"              | Double quotes       
| \\\\     		  | Backslash itself
| \?     		  | Question mark    
| \0oo     		  | Octal number
| \xhh     		  | Hex number    

```c
A character constant 'a' is not the same as "a", the former has an integer value internally and the latter is delimited by a null character ('\0') character.
```

### Constant Expression - 

```c
#define MAX
int p = MAX + 1;

//These are evaluated at the compile-time.
```

- **Enumeration Constant** - An enumeration is a list of constant integer values.

```c
#include<stdio.h>

int main()
{
	enum my {hs, ho};	//By default, first name in an enum has value = 0, second one has value = 1 and so on...
	printf("%d\t", he);
	printf("%d", ho);
	return 0;
}	

OUTPUT: 0	1
```
**If not all values are specified, unspecified values continue the progression from the last specified value.**
```c
#include<stdio.h>

int main()
{
	enum my {JAN = 23, FEB, MAR, APR, MAY};
	printf("%d\t", JAN);
	printf("%d\t", FEB);
	printf("%d\t", MAR);
	printf("%d\t", APR);
	printf("%d\t", MAY);

	return 0;
}

OUTPUT: 23	23	25	26	27
```
**Names in an enumeration must be distinct, values may not be so.**

### Declarations
- Global/External and static variables are initialized to 0 by default. 
- Local/Automatic variables for which there is no initializer have undefined (i.e. garbage) values.
- `const` - It is used to indicate that the variable's value cannot be changed now.

```c
const int p = 5;
//OR
int func(const ch[]);	 //ch's values cannot be changed by func()
```
## Operators

### Arithmetic Operators 

| Binary Arithmetic Operators | Unary Arithmetic Operators            
|:--------------------------: | :-------------:
| +         				  |   +  
| -							  |	  -
| *							  |
| /							  |
| % 						  |      

- % operator cannot be applied to `float` or `double`.

### Relational Operators

| Relational Operators             
|:--------------------------:  
| >         				       
| <							  	  
| >=							  
| <=						  
| ==
| !=						  

- Relational operators have lower precendence than arithmetic oprators. So, `i < lim-1` is taken as `i < (lim-1)`.
- Precedence of `!=` is higher than assignment `=`.

### Logical Operators

| Logical Operators             
|:--------------------------:  
| !        				       
| &&							  	  
| \|\|	

- Evaluated from left to right.

```c
if(!valid)		//if not valid

//OR

if(valid == 0)	//if valid is false

```

### Type Conversions
When taking place _implicitly_, "narrower" type to a "wider" type is done. Ex - `float` to `int`.

- Can a char when resolved to an integer be negative?
	- No, C guarantees that any character is not negative. Yet, some arbitrary bit pattern stored in character variables may appear to be negative on some machines, yet positive on others. For portability, specify `signed` or `unsigned` if non-character data is to be stored in `char` variables.
- If tere are no `unsigned` oprands involved, and either oprand is `long`, `float`, `double`, or `long double`, other is converted to the same type. And `short` and `char` are converted to `int`.
- When `unsigned` operands are involved comparison between `signed` and `unsigned` operands is machine-dependent.

```c
Cast Operators -

(type-name) expression

Ex - 

(float) 4/2;

(unsigned int) 4.3 - 2;
```  	 
### Increment and Decrement Operators
- `i++` is equivalent to `i = i + 1`, and `i--` is quivalent to `i = i - 1`.
- **Prefix** - `++i` and **Postfix** - `i++`.
- `++i` increments the value of `i` and then uses it, and `i++` increments the value before using it.
- They can only be applied to variables. An expression like `(i + j)++` is illegal.
- In a context where no value is stored, prefix and postfix are the same. Ex - when used as loop counters.

### Bitwise Operators

| Bitwise Operators             
|:-----------------:  
| &        				       
| \|							  	  
| ^
| <<
| >>
| ~	

- **Left Shifting** 

```c
x << 2 	//shifts left by two positions (equivalent to multiplying by 4)
```

- **Right Shifting**
	- Right shifting an `unsigned` bit fills vacated bits with 0-bits.
	- Right shifting a `signed bit` fills vacated bits with sign bit **"arithmetic shift"**, or with 0-bits **"logical shift"**. 

```c
#include<stdio.h>	
int main()
{
	int p = 3;

	printf("%d\n", ~p); 


	return 0;
}

OUTPUT: -4
```
### Assignment Operators and Expressions

```c
i = i + 2;

//can be written as

i += 2;			//+= is an assignment operator
```
- In assignment operation the type is the same as the _left side_ operand.

```c
#include<stdio.h>	
int main()
{
	char p = 'a';
	int x;
	p += x;
	printf("%d\n", sizeof(p)); 
	return 0;
}

OUTPUT: 1
```
### Conditional Expressions

```c

a > b? max=a : max=b;

//can also be written as - 

max = a > b? a : b;
```

**IMPORTANT NOTE** - The conditional expression is indeed and expression. Type conversion rules apply here.

```c
// assume f is float and n is int

(n > 0)? f : n;

//result will be float no matter if the condition is true or not.
```
### Precedence and Order of Evaluation

![Precedence and Associativity Chart](/img/precedence-associativity.PNG)

- The precedence of Bitwise operators is below `==` and `!=` operators.

```c
//Be careful in -

if((x & MASK) == 0) ...
```

- C does not specify the order in which the operands of an operator are evaluated.

```c
x = f() + g();		//not sure which ammong f() or g() is evaluated first

//AND

printf("%sd %d\n", ++n, power(2, n));	//Different compiler, different results, based on what is evaluated first
```

- Don't write any code that depends upon the order of evaluation. They are not covered in the standard.

```c
a[i] = i++;	 //Subscript is the old value of i or new?

//Ans - Compilers can interpret it in different ways and generate different answers based on the interpretation.
```