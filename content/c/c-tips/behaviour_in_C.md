+++
title = "Undefined, Unspecified, and Implementation-Defined Behavior in C"
date =  2019-02-09T21:13:45+05:30
weight = 7
+++

### Undefined Behavior

**{MOST DANGEROUS -:- BE AWARE -:- NEVER USE}**

- Undefined behavior refers to **a statement made in a standard specification** that a particular behavior is not defined by a standard, i.e, in C. Ex - Dividing by 0.

- Some Other Examples:

```c
int a;	// a's value can be anything (undefined)
```

```c
int arr[10];

arr[22] = 45;	// compiler interprets as okay but undefined
```

```c
int *ptr;	// pointer with a random address (undefined)
```

- In the standard, it is **explicitly** stated that what all things are undefined.
- There are often diagnostic messages or warnings when we try and use undefined things in programs.
- Undefined behavior is mostly apparent during **runtime** when it's the **most dangerous**.
- It often leads to **"Programmer surprises"**.
- The programmer is responsible for using the undefined things and **must avoid them at all costs**.

### Unspecified Behavior

- Unspecified behavior means that a standard has **chosen**, for whatever reason, to not define how a particular behavior "behaves". This is often because different vendors have chosen to implement a behavior in different ways in well-established products.
- A range of all possible behaviors might be documented in the standard.
- Even the vendor is **not required** to always mention it explicitly (document it).

```c
// Order of function parameter evaluation

int func (a++, a--, a + 5, a - 2);
```

### Implementation-defined Behavior

- Dependent upon the vendor and it **will** change on different environments.
- **Portable code** should **not** rely on these.
- Explicit documentation of these features **must** be provided by the vendor.

```c
int a;		sizeof(a);
char a;		sizeof(a);
double a;	sizeof(a);
long a;		sizeof(a);

// int can be 2 Bytes or 4 Bytes depending upon the machine and the environment
```

```c
// NULL pointer value can be implemented at the lower-level as - 

((void *)0)		// in GCC 
```

### TL;DR

The undefined stuff is accepted as **undefined** by the standard, there is no fixed outcome. e.g. Dividing by 0. We may follow all the rules of the language and standard but still stumble upon **unspecified** stuff which does not lead to any specific outcome but many unintended ones are possible. **Implementation-defined** stuff is explicitly mentioned in the documentation of the environment in which we're working, it varies from machine to machine and hamperes the portability of our program.

### References
- Link: https://www.quora.com/What-is-the-difference-between-undefined-unspecified-and-implementation-defined-behavior

- Link: https://stackoverflow.com/questions/2397984/undefined-unspecified-and-implementation-defined-behavior

- Link: https://www.youtube.com/watch?v=Pl88WRJ-6l0