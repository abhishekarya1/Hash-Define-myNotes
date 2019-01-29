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

### Arrays of Structures
- Each element of array is a structure.

```c
struct key {

	int count;
	char *word;

} keytab[NKEYS];
```

- Initialization - 

![Arrays of Structures](/img/arr_struct.png)

### Pointers to Structures

- A function can return a pointer to a `struct`.

```c
struct key *binsearch(int x, int y);
```

- Don't assume that the size of a structure is the sum of sizes of its members.

```c
struct {

	char c;
	int i;
};			//its size can be 8, not 5
```

`sizeof()` returns the exact value.

### Self-referential Structures
- Used in recursively defined data structures like Trees.

```c
struct node {

	int value;
	struct node *left;
	struct node *right;		//referring to self
}
```

### Table Lookup
- When a line like `#define IN 1` is encountered, the name IN and the replacement text 1 are stored in a table. Later, when the name IN appears in a statement like `state = IN;` it must be replaced by `1`.
- There are two routines that manipulate the names and replacement texts. `install(s,t)` records the name `s` and the replacement text `t` in a table; `s` and `t` are just character strings. `lookup(s)` searches for `s` in the table, and returns a pointer to the place where it was found, or `NULL` if it wasn't there. 

- The algorithm is a hash-search - the incoming name is converted into a small non-negative integer, which is then used to index into an array of pointers. An array element points to the beginning of a linked list of blocks describing names that have that hash value. It is `NULL` if no names have hashed to that value.

![Lookup](/img/lookup.png)

- A block in the list is a structure containing pointers to the name, the replacement text, and the next block in the list. A null next-pointer marks the end of the list. 

```c
struct nlist { 	/* table entry: */

	struct nlist *next;	 /* next entry in chain */
	char *name;	 	/* defined name */
	char *defn; 	/* replacement text */

};
```

### Typedef
- We can create a new name for a data type using `typedef`.

```c
typedef int Length;
```
In the program that follows, we can use `Length` in place of `int` as a new type.

```c
Length x, y;
```

- `typedef` in C basically works as an alias.
	- `typedef` can be used to alias compound data types such as struct and union.
	- `typedef` can be used to alias both compound data types and pointer to these compound types.
	- `typedef` can be used to alias a function pointer.
	- `typedef` can be used to alias an array.

### Unions
- A _union_ is a variable that may hold multiple variables of any type and size.

```c
union u_tag {

	int ival;
	float fval;
	char *sval;
} u;
```

- Accessing of members can be done as - `union-name . member` or `union-pointer -> member`.

- The size of a union is big enough to hold the "widest" number.

- Operations permitted are same as those of structures.

- **A union may only be initialized with a value of the type of its first member; thus union `u` described above can only be initialized with an integer value.**

### Bit-fields
- A _bit-field_, or _field_ for short, is a set of adjacent bits within a single implementation-defined storage unit that we will call a "word".

```c
struct {

	unsigned int is_keyword : 1;
	unsigned int is_extern : 1;
	unsigned int is_static : 1;

} flags;
```

The number following the colon represents the field width in bits.

- Individual fields are referenced in the same way as other structure members: `flags.is_keyword`, `flags.is_extern`, etc.

- Almost everything about fields is implementation-dependent.