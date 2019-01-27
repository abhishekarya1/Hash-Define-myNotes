+++
title = "Input and Output"
date =  2019-01-27T15:02:31+05:30
weight = 8
pre = "<b>7. </b>"
+++

### Introduction
Input and output are not part of the C language itself. They are provided by the standard library.

### Standard Input and Output

- `int getchar(void)` returns the next symbol from the input stream, or `EOF` whose value is typically `-1`.

- The function `int putchar(int)` is used for output: `putchar(c)` puts the character `c` on the standard output, which is by default the screen. `putchar `returns the character written, or `EOF` if an error occurs.

- **Input Redirection** - We can input from a file using the command-line `<`

```bash
prog < infile
```
- **Output Redirection** - Output can be saved to a file using -

```bash
prog > outfile
``` 
- Input can come from another program via a pipe mechanism: on some systems, the command line `otherprog | prog` runs the two programs `otherprog` and `prog`, and pipes the standard output of `otherprog` into the standard input for `prog`.

```bash
otherprog | prog 
```

### Formatted Output - printf 
```c
int printf(char *format, arg1, arg2, ...);
```
- `printf` converts, formats, and prints its arguments on the standard output under control of the format. **It returns the number of characters printed**.

- The format string contains two types of objects: **ordinary characters**, which are copied to the output stream, and **conversion specifications**, each of which causes conversion and printing of the next successive argument to `printf`. Each conversion specification begins with a `%` and ends with a conversion character (`d`, `f`, `c`, `s`, etc..).

![All printf Conversions](/img/printf_conv.png)

- In printing `strings` the following applies -

```c
:%s: 		:hello, world:		// normal
:%10s: 		:hello, world:		// atleast 10 characters to be printed
:%.10s: 	:hello, wor:		// atmost 10 characters to be printed
:%-10s: 	:hello, world:		// left alignment of printed characters
:%.15s: 	:hello, world:		// atmost 15 characters to be printed
:%-15s:		:hello, world   :	// atleast 15 characters to be printed, padding required on the right
:%15.10s: 	:     hello, wor:	// atleast 15 places, and atmost 10 characters 
:%-15.10s: 	:hello, wor     :	// atleast 15 places, and atmost 10 characters, left aligned
```

- The function `sprintf` does the same conversions as `printf` does, but stores the output in a string:

```c
int sprintf(char *string, char *format, arg1, arg2, ...);
```
`sprintf` formats the arguments in `arg1`, `arg2`, etc., according to format as before, but places the result in string instead of the standard output; string must be big enough to receive the result.

### Formatted Input - Scanf
