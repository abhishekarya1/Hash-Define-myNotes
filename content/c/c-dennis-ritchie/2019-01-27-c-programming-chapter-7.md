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

```c
int scanf(char *format, ...);
```

- `scanf` reads characters from the standard input, interprets them according to the specification in format, and stores the results through the remaining arguments.
- It returns as its value the number of successfully matched and assigned input items. This can be used to decide how many items were found. On the end of file, `EOF` is returned; note that this is different from `0`, which means that the next input character does not match the first specification in the format string.

```c
int sscanf(char *string, char *format, arg1, arg2, ...)
```
 - `sscanf` - It scans the string according to the format in format and stores the resulting values through `arg1`, `arg2`, etc. These arguments must be pointers.

 ```c
int day, year;
char monthname[20];

scanf("%d %s %d", &day, monthname, &year);		//No & is used with monthname, since an array name is a pointer
```

### File Access
```c
FILE *fp;
FILE *fopen(char *name, char *mode);
```

This says that `fp` is a pointer to a `FILE`, and `fopen` returns a pointer to a `FILE`.

```c
fp = fopen(name, mode);
```

The first argument of `fopen` is a character string containing the name of the file. The second argument is the `mode`, also a character string, which indicates how one intends to use the file. Allowable modes include read (`r`), write (`w`), and append (`a`).

If a file that does not exist is opened for writing or appending, it is created if possible. Opening an existing file for writing causes the old contents to be discarded, while opening for appending preserves them. Trying to read a file that does not exist is an error, and there may be other causes of error as well, like trying to read a file when you don't have permission. If there is any error, `fopen` will return `NULL`.

- `getc` returns the next character from the stream referred to by `fp`; it returns `EOF` for end of file or error.

```c 
int getc(FILE *fp)
```

- `putc` is an output function:
- `putc` writes the character `c` to the file `fp` and returns the character written, or `EOF` if an error occurs.

```c 
int putc(int c, FILE *fp)
```
- When a C program is started, the operating system environment is responsible for opening three files and providing pointers for them. These files are the standard input, the standard output, and the standard error; the corresponding file pointers are called `stdin`, `stdout`, and `stderr`, and are declared in `<stdio.h>`. Normally `stdin` is connected to the keyboard and `stdout` and `stderr` are connected to the screen.

- `int fclose(FILE *fp)` is the inverse of `fopen`, it breaks the connection between the file pointer and the external name that was established by `fopen`, freeing the file pointer for another file.

### Error Handling - Stderr and Exit
- The function `ferror` returns non-zero if an error occurred on the stream `fp`.

```c
int ferror(FILE *fp)
```

- The function `feof(FILE *)` is analogous to `ferror`; it returns non-zero if end of file has occurred on the specified file.

```c
int feof(FILE *fp)
```

### Line Input and Output
- `fgets` is similar to the `getline` function.

```c
char *fgets(char *line, int maxline, FILE *fp)
```

- `fgets` reads the next input line (including the newline) from file `fp` into the character array line; at most `maxline-1` characters will be read. The resulting line is terminated with `'\0'`. Normally `fgets` returns line; on end of file or error it returns `NULL`. (Our `getline` returns the line length, which is a more useful value; zero means end of file.)

- `fputs` writes a line to a file.

```c
int fputs(char *line, FILE *fp)
```
It returns `EOF` if an error occurs, and non-negative otherwise.

- The library functions `gets` and `puts` are similar to `fgets` and `fputs`, but operate on `stdin` and `stdout`. Confusingly, `gets` deletes the terminating `'\n'`, and `puts` adds it.

### Miscellaneous Functions

#### String Operations - `<string.h>`

- In the following, `s` and `t` are `char *`, and `c` and `n` are `ints`.

| Function 		| Use
|-------------	| -------------
|strcat(s,t)	|concatenate t to end of s
|strncat(s,t,n)	|concatenate n characters of t to end of s
|strcmp(s,t)	|return negative, zero, or positive for s < t, s == t, s > t
|strncmp(s,t,n)	|same as strcmp but only in first n characters
|strcpy(s,t)	|copy t to s
|strncpy(s,t,n)	|copy at most n characters of t to s
|strlen(s)		|return length of s
|strchr(s,c)	|return pointer to first c in s, or NULL if not present
|strrchr(s,c)	|return pointer to last c in s, or NULL if not present

#### Character Class Testing and Conversion - `<ctype.h>`

- In the following, `c` is an `int` that can be represented as an `unsigned char` or `EOF`. The function returns `int`.

| Function 		| Use
|-------------	| -------------
|isalpha(c)		|non-zero if c is alphabetic, 0 if not
|isupper(c)		|non-zero if c is upper case, 0 if not
|islower(c)		|non-zero if c is lower case, 0 if not
|isdigit(c)		|non-zero if c is digit, 0 if not
|isalnum(c)		|non-zero if isalpha(c) or isdigit(c), 0 if not
|isspace(c)		|non-zero if c is blank, tab, newline, return, formfeed, vertical tab
|toupper(c)		|return c converted to upper case
|tolower(c)		|return c converted to lower case

#### Ungetc

```c
int ungetc(int c, FILE *fp)
```
- `ungetc` pushes the character `c` back onto file `fp`, and returns either `c`, or `EOF` for an error. Only one character of pushback is guaranteed per file. `ungetc` may be used with any of the input functions like `scanf`, `getc`, or `getchar`.

#### Command Execution
- The function `system(char *s)` executes the command contained in the character string `s`, then resumes execution of the current program.

As a trivial example, on UNIX systems, the statement
```c
system("date");
```
causes the program date to be run; it prints the date and time of day on the standard output. system returns a system-dependent integer status from the command executed.

#### Storage Management

- `malloc`

```c
void *malloc(size_t n)
```
returns a pointer to n bytes of uninitialized storage, or NULL if the request cannot be satisfied.

- `calloc`

```c
void *calloc(size_t n, size_t size)
```
returns a pointer to enough free space for an array of n objects of the specified size, or NULL if the request cannot be satisfied. The storage is initialized to zero.

- `free`

```c
free(p)
```
frees the space pointed to by `p`, where `p` was originally obtained by a call to `malloc` or `calloc`.

#### Mathematical Functions - `<math.h>`

| Function 		| Use
|-------------	| -------------
|sin(x)			|sine of x, x in radians
|cos(x)			|cosine of x, x in radians
|atan2(y,x)		|arctangent of y/x, in radians
|exp(x)			|exponential function e<sup>x</sup>
|log(x)			|natural (base e) logarithm of x (x>0)
|log10(x)		|common (base 10) logarithm of x (x>0)
|pow(x,y)		|x<sup>y</sup>
|sqrt(x)		|square root of x (x>0)
|fabs(x)		|absolute value of x

#### Random Number generation
The function `rand()` computes a sequence of pseudo-random integers in the range zero to `RAND_MAX`, which is defined in `<stdlib.h>`.

