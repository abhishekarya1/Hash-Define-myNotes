+++
title = "Basics"
date =  2022-05-05T20:18:00+05:30
weight = 2
+++

## Class
Everything has to be inside a class in java source file. Filename must match the "entrypoint" classname (incl. case), and it ofcourse must have a `main()` method.

- if all are non-public, the class name with file's name runs
- there can be multiple classes in a java source file but only one can be declared as `public` 
- top-level classes can't be `private` or `protected`, it leads to compiler error

### main()

```java
public static final void main()

// only "final" is optional
```
The argument has to be a `String` array. So all of the below works:
```java
String args[]
String foobar[]
String[] args
String... args
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

**If we don't pass required number of arguments**: _ArrayIndexOutOfBoundsException_

## Imports and Packages

```java
package foo;
import java.util.*;

class Hello{

}
```
- `java.lang.*` is always implicitly imported regardless
- only classes can be imported and not methods or fields unless `import static` is used
- importing a lot of classes doesn't impact compilation or runtimes at all in Java
- an import with wildcard (`import java.util.*`) only imports on current level and not children too
- if files have same `package` declarations, then they need not `import` each other explicitly as it's trivial 
- Specificity takes precedence. If `java.util.Date` and `java.sql.*` both are imported, then `Date` is fetched from `util` package
- Any ambiguity leads to compilation error:
```java
import java.util.*;
import java.sql.*;		// Date will lead to error

import java.util.Date;
import java.sql.Date;	// ambiguous still

java.util.Date dateVar;
java.sql.Date dbDateVar;	//removes ambiguity
``` 

**Ordering Rules**:
- `package` declaration has to be first non-comment in a source file
- `import` always comes after `package` declaration
- class comes after them

## Comments
No nesting allowed.

```java
// single line

/* block */

/**
 * documentation
 * style
 * @author john doe
*/
```

## Variables

```txt
data_type name = init_value;
```

- identifiers can start with currency symbol like `$`, etc...
- single underscore (`_`) isn't a valid identifier name (unlike C/C++)
- Garbage value concept doesn't exist here so any uninitialized variable's access is erorr
- Since no garbage value is assigned, there is truly a separation between declaration and definition in Java, even for `final` variables
```java
int x;

// no errors unless the variable is accessed without initialization
// all paths leading to access must initialize (Java is smart to detect this) or else error

final int a;        // declaration
a = 5;              // initialization
```

### Types of variables
1. Local (Method) -> Initialization is either (Inline, later in program) 
2. Instance (Object) -> Initialization is either (default, inline, instance initializer block, constructor)
3. Class/static (Class) -> Initialization is either (default, static initializer block)

More on their initialization [here](/java/oop/#order-of-initialization)

**Variable Defaults**:
```txt
Local -> no defaults (no garbage values), declaration only if value not assigned inline
non-final Instance -> defaults value assigned by compiler
non-final Class/static ->  defaults value assigned by compiler
```

### var
```java
var name = init_value;	// type is implicitly inferred
```
- we ofcourse always have to initialize `var` variables inline, and once type is inferred, we can't change it
- can't be initialized with `null` but can be put in later
- `var` isn't a reserved keyword and can be used as an identifier (weird!). We can't have types (classes, enum, interface) with name "var".
- `var` is **ONLY used for local variable** type inference. Anywhere else it is used (method params, instance variables, constructors), it is error
- `var` can't be used in multiple-variable assignments
```java
var a = 3, b = 5;	//invalid
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
- `boolean` is not convertible to `int` and vice-versa. Takes values `true` or `false`. **Size is undefined** and depends on JVM.

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

```java
long n = 9999999999;
// it is compiler error unlike in C++ since literal is int and is overflowed

long n = 9999999999L;	// solves the above issue
```

```java
// underscores are allowed in numeric types to make them easier to read
int million1 = 1000000;
int million2 = 1_000_000;

// underscore can't be at beginnning or end of literal or on either sides of a decimal point (.)
float exp = 1.010_101;

// multiple underscores together is valid; useless though
int eleven = 1__________1;	
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


// text block Strings
String d = """
foobar""";
/*
Rules:
1. Must have a new line after start """
2. \s puts two spaces
3. line splicing using \ is there
4. \" and \""" are available
5. escape characters work inside this
6. spaces at end of a line are ignored
*/
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
- `switch` labels and expressions and case labels can be `String` here too (unlike C/C++) and they have to be compile time constants using `final`
```java
//combining case values
case 1, 2:

case 1:
case 2:		// old way

// switch expressions, notice semi-colon (;) at last
var result = switch(day) {
 case 0 -> "Sunday";
 case 1 -> "Monday";
 case 2 -> "Tuesday";
 case 3 -> "Wednesday";
 case 4 -> "Thursday";
 case 5 -> "Friday";
 case 6 -> "Saturday";
 default -> "Invalid value";
};
```
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
// unboxing
int num = n;

// Wrapper to primitive (explicitly; no unboxing)
int n = num.intValue();
```

### More on Autoboxing
```java
// autoboxing and promotion can't happen in one go
Long l = 8;     // compiler error
// promotion = int literal 8 to long
// autoboxing = long to Long

// autoboxing and unboxing null can lead to surprises
Character c = null;     // valid since c is ref variable and it can store null ref
char ch = c;            // NullPointerException; since we try and call method on c internally to get primitive out of it

// methods calls
void foobar(Long x){ }

foobar(8L);     // valid
foobar(9);      // invalid
```

- **Arrays don't get autoboxed** - they define their actual types.
```java
int[] arr;
Integer[] arrInt;

// both are different
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
int arr[] = {1, 2, 3};              // still allocated in heap

//muti-dimensional arrays
int arr[][];        // 2D
int[][][] arr;      // 3D
int[] arr[];        // 2D

// Range checking is strict unlie C & C++ and often results in - 
ArrayIndexOutOfBoundsException

// in method parameters
void foobar(int[] arr){ }

// length of an array
arr.length      // and not arr.length()


// multiple-declrations
int [] a, b;     // two array ref variables
int a[], b;      // one array ref variable, one primitive int    


//utility methods
Arrays.sort()
Arrays.compare()
//etc...
```

## Math & Date/Time

### java.lang.Math
```java
Math.min()
Math.max()
Math.round()
Math.ceil()
Math.floor()
Math.pow()
Math.random()
// etc...
```

### java.util.*
```java
import java.util.*;

Date d = new Date();                    // 1st way
    
Calendar c = Calendar.getInstance();    // 2nd way
c.get(Calendar.DAY_OF_WEEK)
c.get(Calendar.DAY_OF_YEAR)             // etc...

import java.text.SimpleDateFormat;
import java.util.Date;
SimpleDateFormat ft = new SimpleDateFormat("dd-MM-yyyy");
String str = ft.format(new Date());     // 07-05-2022        
```

## 