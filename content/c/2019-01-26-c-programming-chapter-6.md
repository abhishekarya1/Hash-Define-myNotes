+++
title = "Structures"
date =  2019-01-26T23:47:11+05:30
weight = 7
pre = "<b>6. </b>"
+++

### Definition

A structure is a collection of one or more variables, possibly of different types, grouped together under a single name for convenient handling.

### Basics

- A point is nothing but a pair of coordinates and a collection of points makes a rectangle.

- `struct` keyword is used.

```c

struct point {

	int x;		
	int y;		//members
};
```

An optional name called a _structure tag_ may follow the word `struct`.

```c
struct point {

	int x;
	int y;

} x , y, z;
```

- We can also declare `struct` type variables.

```c

struct point pt;	//pt's type is struct point

//initialization can be done by

struct point pt = { 320, 200 };
```

- **Accessing Members of a Structure** - `structure-name . member`

```c
struct point pt;

int a = pt.x;
int b = pt.y;
```

- Structures can be nested as - 

```c
struct rect {

	struct point pt1;
	struct point pt2;
};

//we can declare screen as

struct rect screen;

//then

screen.pt1.x;
```

### Structures and Functions
- The only legal operations on structures are -
	- Copying it
	- Assigning to it
	- Taking its address (&)
	- Accessing its members (.)
 
- Structure parameters are passed by value.

- We can pass a pointer to a structure.

```c
struct point *pp;

struct point origin;

*pp = &origin;
//to access elements

(*pp).x;
```

- Shorthand Notation - If pp is a pointer to a structure, then

```c
// instead of writing this

(*pp).x;

// we can access members like this

pp -> x;
```

- **Precedence of `->` operator is the Highest.**

```c

struct point {

	int x;
	char *str;
} *p;

++ p -> x; // this increments x, not p

* p -> str; // this accesses location popinted to by str
```

- 