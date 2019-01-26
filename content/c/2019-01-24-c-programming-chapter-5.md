+++
title = "Pointers and Arrays"
date = 2019-01-24T04:50:21+05:30
weight = 6
pre = "<b>5. </b>"
+++

### Pointers and Addresses
- Address Of Operator `&` can be applied to any memory object such as an array or a variable, not to any expression, constant, or `register` variable. 

```c
p = &c;		//p stores address of c

//remember p is a pointer type variable

int *p;  //pointer to an int, this says that value at *p is an int
```

- **Dereferencing or Indirection** - `*` (value at) is the unary dereferencing operator and is used to access the value stored at a memory location.

```c
*p = 0;	 //value at p = 0
```

- Some Tips
	- `&` and `*` have higher precedence than arithmetic operators.

```c

++*ip;  //increments value at ip

(*ip)++; //increments value at ip, parentheses are required here

iq = ip; //both are pointer variables to the same type, hence contents are copied into iq
```

### Pointers and Function Arguments
- Call by Reference

```c

swap(&a, &b);

void swap(int *x, int *y)
{
	int temp;

	temp = *x;
	*x = *y;
	*y = temp;
}
```

### Pointers and Arrays
- 