+++
title = "Control Flow"
date =  2019-01-22T23:16:53+05:30
weight = 4
pre = "<b>3. </b>"
+++

### Statements and Blocks
- An expression like `i+2`, `i++`, or `printf(...)` terminated by a `;` becomes a **statement** in C.
- Braces `{ and }` are used to group statements inside a compound statement or a **block**.

### If-Else

- In `if-else` the `else` part is optional.
- `if` checks the numeric value of an expression after evaluating it.

We might do - 

```c
if(x)		//non-zero value implicitly means true 

//instead of

if(x != 0)
```
### Else-if

- Multiple cases can be made using `else-if`.
- Additional case/error catching case can be a last `else` but it is optional.

### Switch

```c
switch(expression)
{
	case const-expr: statements 
	case const-expr: statements 
	default: statements
}
```
- Each case is labeled by **integer-valued constants** or **constant expressions**.
- All cases must be different.
- `default` case is optional.

- **IMPORTANT NOTE** - Switch is _fall through_ i.e. if we do not _break_ the flow after a case, then it goes to the next case until it is stopped explicitly. 

- Several cases can be attached to a single action using this _fall through_ property.

```c
#include<stdio.h>

int main()
{
	char sec;

	scanf("%s", &sec);

	switch (sec)
	{
	case 'a':
	case 'A':

	case 'b':
	case 'B':	

	case 'c':
	case 'C':	printf("Your class has 10 students.");
		break;

	case 'd':
	case 'D':	

	case 'e':
	case 'E':	printf("Your class has 11 students.");
		break;

	default: printf("Section not found.");
		break;

	}

	return 0;
}
```

### Loops - While and For
- `for` and `while` loops are basically the same thing.
- All three - _Initialization_, _Condition_, and _Update_ in a `for` loop are expressions and either of them can be omitted, but the semicolons must remain.
- Without the condition, `for` loop is _infinite_, even if we do not update.
- Multiple expression separated by comma are allowed in `for` loop.

```c

for (int i = 0, j = 1; i < counti, j < countj; i++, j++)
{
	/* code */
}
```

### Do-while
- The condition check is at last so the body is executed atleast once.
- Braces around a _single_ statement inside `do` block is optional but the `while` part can be mistaken for start of a `while` loop.

### Break and Continue
- `break` causes an exit from the _innermost enclosing_ loop or `switch`.
- `continue` causes the next iteration of the loop to begin.
- A `continue` has no meaning in `switch`.
- **IMPORTANT NOTE** - A `continue` inside a `switch` inside a loop will cause the loop to jump to next iteration.

### Goto and Labels
- `goto` can jump to a `label` anywhere inside the **same** function. A label follows same naming conventions as that of variables.
- 