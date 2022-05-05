+++
title = "Basics"
date =  2022-05-05T20:18:00+05:30
weight = 2
+++

## Comments
No nesting allowed.

```java
// single line

/* block */

/**
 * doc
 * style
*/
```

## Variables

```txt
data_type name = init_value;

OR

var name = init_value;	(type is implicitly decided)
```

## Data Types
```java
int short long byte

char

float double

boolean
```

- `int` is 4 Bytes
- `float` is 4 Bytes
- `char` is UTF-16, so one char can take one or two Bytes. Convertible to `int` and vice-versa.
- `boolean` is not convertible to `int` and takes values `true` or `false`

### Literals
```java
55L		// long
0123	// octal
0xFBB	// hex
0b1011	// binary

0.33F	// float
1e4		// double

'a' '❤️'	// chars
"foobar"	// string
```

### Type Casting
```java
(int) a;
```
## Strings

**Strings are immutable in Java**

All strings literals are cached in an area in Heap memory called "String Constant Pool". Every string literal NOT created with `new` keyword must be checked first and if it already exists in Pool then reference to the already present literal is returned.

Advantages of this include:
- thread safety
- security
- non-redundancy

```java
String a = "foo";					// stored in pool
String b = new String("bar");		// stored in heap only, not in pool

String c = "foo";					// points to b only (b == c is true)
```

### Interning
```java
// Intern a string to bring it to Pool if it doesn't exists there already otherwise old ref from pool is returned
String internedStr = str.intern();
```

### Immutability
```java
String a = new String("foobar");
String a = a.substring(0, 3) + "d";
// Literals created in heap: "foobar", "food" (new literal)

String b = "foo";
String b = b + "bar"; 
// Literals created in heap: "foo", "foobar" (new literal)
```

### Comparing Strings
```java
a.equals(b);
c.equalsIgnoreCase(d);

// Avoid using "==" for string comparison since it compares object references and not actual value
// Naturally, interned strings can be comapred with ==
```

### Building Mutable Strings
```java
import java.lang.*;

new String("foobar");

new StringBuffer("foobar");

new StringBuilder("foobar");
```

- `StringBuffer` is slower but thread-safe since it is synchronized.
- `StringBuilder` is faster but not thread-safe.
- Immutable `String` can be casted to `StringBuffer` or `StringBuilder` using `new`
- `.toString()` can be performed on `StringBuffer` or `StringBuilder` to cast to immutable `String`

```java
import java.util.*;

StringTokenizer();
StringJoiner();
```

### Primitive-String Conversions
```java
Integer.parseInt(str)
Integer.valueOf(str)

String.valueOf(n)
Integer.toString(n)
```

## Control Structures
- `switch` labels supports types othe than integral types unlike C & C++
- `System.exit(0)` can be used to indicate successful termination
- for each loop
```java
int [] arr = new int[]{1, 2, 3, 4, 5};

for(int i : arr){
	System.out.printf("%d ", i);
}

// 1 2 3 4 5 
```

## IO
### Input
```java
import java.util.*;
Scanner in  = new Scanner(System.in);
in.nextInt();		// int
in.nextFloat();		// float
in.next();			// string
in.nextLine();		// full line until '\n'

in.close();
```

- `Scanner` is not thread-safe (no sync) wheareas `BufferedReader` is.
- `Scanner` buffer size is 1 KB wheareas `BufferedReader` buffer size is 8 KB. So `BufferedReader` is good for handling larger inputs.

```java
InputStreamReader r = new InputStreamReader(System.in);    
BufferedReader br = new BufferedReader(r);

System.out.println("Enter your name");
String name = br.readLine();
System.out.println("Welcome " + name);    
```

### Output
```java
System.out.print()
System.out.println()

System.out.printf()		// works mostly like C's printf()
String.format()			// to store in another String, formatting works like printf
```

## Methods
```txt
Primitives 			 - Pass-by-value
Objects & references - Pass-by-reference

Since there are no explicit references in Java unlike C++. We say everything is pass-by-value in Java which means a new reference variable is created in called method and not actual object/array is created in memory again. 
```

### Variable Arguments
```java
foobar(String... str){
	//use for each loop to iterate over s here
	for(String s : str){
		// print
	}
}
```

## Command-Line Arguments
```java
public static void main(String args[]){
	args[0]  // first argument (not program name) = 8
	args[1]	 // second argument = "foobar"
}

/*
$ java Hello 8 foobar
*/
```

## Wrapper Classes
Available for all data types. Advantages include:
- Thread safety (synced)
- More methods available than primitives
- All `java.util` methods take in wrapper objects as arguments
- `Collection` framework deals with wrapper objects
- Classes like `BigInteger` and `BigDecimal` provide huge ranges and utility methods

**Objects of all primitive wrapper classes are immutable!**

### Creating Objects of wrapper class
```java
// 1. new
Integer n = new Integer(33);

// 2. valueOf()
Integer n = Integer.valueOf(33);
// Points to old object if it already exists in constant pool

// 3. Autoboxing
Integer n = 5;
```

## Arrays
- Implements `Cloneable` and `java.io.Serializable` interfaces
- always dynamically allocated unlike C & C++
- values defaults to `0` or `false` or `null`

```java
int arr[];
int [] arr;

int arr[] = new int[5];				//init list not allowed
int arr[] = new int[]{1, 2, 3};

//muti-dimensional arrays
int arr[][];
int[][][] arr;

// Range checking is strict unlie C & C++ and often results in - 
ArrayIndexOutOfBoundsException

// in method parameters
void foobar(int[] arr){ }
```