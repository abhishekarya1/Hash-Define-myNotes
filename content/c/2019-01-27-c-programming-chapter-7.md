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