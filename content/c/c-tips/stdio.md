+++
title = "Some <stdio.h> I/O Functions"
date =  2019-02-07T18:27:47+05:30
weight = 4
+++

## Basic `<stdio.h>` I/O Functions 											   
### Formatted I/O
```c
int printf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
int sprintf (char *str, const char *format, ...);
printf() family returns negative value if an output error or an encoding error.    
int scanf (const char *format, ...);
int fscanf (FILE *stream, const char *format, ...);
int sscanf (const char *str, const char *format, ...);
scanf() family returns EOF if input failure occurs before the first receiving argument was assigned.    
```
### Unformatted I/O
```c
char * gets (char *);	//returns NULL pointer if error
char * fgets (char *, int, FILE *); //returns NULL if error
int  puts (const char *);	// returns non-negative no. if success,   else EOF
int  fputs (const char *, FILE *);
int  getc (FILE *);		// returns EOF when end of file or fails
int  fgetc (FILE *);		
int  putc (int, FILE *);
int  fputc (int, FILE *);
int  getchar (void);		// a.k.a fgetchar
int  putchar (int);		// a.k.a fputchar
int  ungetc (int, FILE *);
int  feof(FILE *);  // returns non-zero value on end of file, else 0
int  fflush(FILE *); // returns 0 if success, otherwise EOF
```
### Non-Standard Functions - `<conio.h>` - [Header Native to MS-DOS]

```c
int getch();	// returns character immediately w/o pressing “Enter” 
int getche(void); //same as getch(), returns the character twice 
```