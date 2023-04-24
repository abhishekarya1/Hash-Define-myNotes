+++
title = "Basics"
date =  2022-05-05T20:18:00+05:30
weight = 2
+++

## Class
Everything has to be inside a class in java source file. Filename must match the "entrypoint" classname (incl. case), and it ofcourse can have a `main()` method.

- if all are non-public, the class name with file's name runs
- there can be multiple classes in a java source file but only one can be declared as `public` and it must match the filename
- top-level classes can't be `private` or `protected`, it leads to compiler error
- top-level classes can't be `static`, it leads to compiler error. Nested classes can be `static` though.

### main()

```java
public static final void main()

// only "final" is optional here
```
The argument has to be a `String` array. So all of the below works:
```java
String args[]
String foobar[]
String[] args
String... args
```

- It is `static` because it is called by JVM using class name
- Removing `static` from it will not cause any compile-time exception but cause `NoSuchMethodError` error on runtime
- `main()` can be overloaded just like any other method but only `String[]` one will be called by the JVM

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
- if files have same `package` declarations, then they need not `import` each other explicitly as it's trivial 
- only classes can be imported and not methods or fields unless `import static` is used
- importing a lot of classes doesn't impact compilation or runtimes at all in Java
- an import with wildcard (`import java.nio.*`) only imports classes from the current package and not from children pacakages too
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
- Garbage value concept doesn't exist here so any uninitialized variable's access is error
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
non-final Instance -> default value assigned by compiler
non-final Class/static ->  default value assigned by compiler

final Instance/Class -> no defaults, must be initialized before constructor finishes!
```

Do note that the defaults on non-final instance and class/static variables are not by constructor but by compiler itself. They are assigned default values even before any constructor finishes executing!

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
- type of `var` is known at compile-time and type cannot be changed ever after that
- `var` can be used in Lambda Expression variables though
```java
Foobar foobar = (var a, var b) -> a < b;
```

## Data Types
```java
int short long byte

char

float double

boolean

// there is no explicit "unsigned" specifier for primitives in Java
// char is unsigned; other integral types are not
```

- `int` is 4 Bytes
- `float` is 4 Bytes
- `char` is unsigned UTF-16, so one char can take one or two bytes. Convertible to `int` and vice-versa.
- `boolean` is not convertible to `int` and vice-versa, we cannot even use `==` with `int` and `boolean` values. Takes values `true` or `false`. **Size is undefined** and depends on JVM.

```java
while(1){ }     // not allowed; expected boolean
```

### Literals
```java
55L		// long -- l/L
0123	// octal   
0xFBB	// hex -- x/X (A to F case-insensitive)
0b1011	// binary -- b/B

0.33F	// float -- f/F
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
// underscores are allowed in all numeric types to make them easier to read
int million1 = 1000000;
int million2 = 1_000_000;
int binary_num = 0b0001_0101; 

// underscore can't be at beginnning or end of literal or on either sides of a decimal point (.)
float exp = 1.010_101;

// multiple underscores together is valid; useless though
int eleven = 1__________1;	
```

## Operators
Logical/Bitwise operators:
```java
& | ^   // can be applied to both boolean and integer types; works the same way as conditionals: && ||
~       // only for integer types
```
**Logical operators are not short circuited** whereas Conditional operators are.
```java
boolean a = false;
boolean b = (true) | (a = true);       // logical AND (&)
System.out.println(a);      // true

boolean a = false;
boolean b = (true) || (a = true);       // conditional AND (&&)
System.out.println(a);      // false
```

### Type Casting
```java
double x = 99;      // valid; smaller to larger type cast is implicit
long y = x;         // invalid; larger to smaller cast can lead to loss of data
float z = 9.0;      // invalid; must be 9.0f

double a = 9;           // implicit cast to double from int
int b = (int) a;        // explicit cast from double to int
```

### Numeric Promotion
1. If two values have different types, Java will convert smaller into larger type
2. If integral and decimal are being used, integral is converted to decimal type
3. After the operations, the result value will be of the promoted operands type
4. **If both variables are of integral type and smaller or equal to int, they are promoted to int first**, even if none of them is `int`
```java
short x = 5;
byte y = 5;
x + y;      // int 
```

### Bitwise Complement
`~` operator is same as in C/C++. To find the bitwise complement of a number, multiply it by negative one and then subtract one.
```java
System.out.println(~8);     // -9; use -(n+1) formula

// it is supposed to perform 1's complement on the operand
```

## Strings

**Strings are immutable in Java**

Advantages of immutability include:
- thread safety
- security
- non-redundancy

All strings literals (anything within `""`) are cached in an area in Heap memory called "**String Constant Pool**" or "String Intern Pool" for performance optimization.

When we define literal without `new`, we either get old ref or a string pool entry is created and we get it's new ref.

When we create using `new String()`, we force Java to create a new object regardless of any prior pool entry.

The sneaky thing is when we are allocating space using `new`, we end up using literal (`""`) in constructor call and a String literal ALWAYS gets placed in pool. So, its because of the String `""` literal use that we get two objects created in memory and not by virtue of using `new`.

_Reference_: https://stackoverflow.com/a/66866401


```java
// how many string literals does the following statement create internally?

String a = new String("A");

// 1 literal - if "A" exists in pool already
// 2 literal - if "A" doesn't exist in pool already

// compare that to simple literal
String b = "B";
// it can create 0 or 1 depending on existance in pool

// another example
String s = new String(new char[]{'a','b','c'});
// only 1 String literal is created in heap ("abc"), none in pool
```

**String Representation**: Since Java 9, a new representation is provided, called _Compact Strings_. This new format will choose the appropriate encoding between `char[]` and `byte[]` depending on the stored content.

The internal array representation has 65536 elements and **String Pool can go OutOfMemory since it not eligible for Garbage Collection**. The memory is freed only when JVM is restarted.

```java
String a = "foo";					// stored in pool
String c = "foo";					// points to a only (a == c is true)

String b = new String("bar");		// stored in heap and b points to it, literal "bar" is also placed in pool

String d = b.concat("tender");      // d is in string pool (since "new" is not used)


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
// Intern a string to copy it to Pool from String Object in heap if it doesn't exists there already and return it's reference, otherwise old ref from pool is returned
String internedStr = str.intern();
```

### Immutability
Once we have a String literal in pool or heap, we can't "edit" (modify) it in-place.
```java
String a = new String("foobar");
a = a.substring(0, 3) + "d";
// Literals created in pool: "foobar", "food" (new literal)

String b = "foo";
b = b + "bar"; 
// Literals created in pool: "foo", "foobar" (new literal)
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

### Data-String Conversions
```java
Integer.parseInt(str)       // returns int; takes Strings only; slower
Integer.valueOf(str)        // returns Integer; takes both String and intgeral types; faster

String.valueOf(n)     // n is primitive or any other type
x.toString()        // where x is of type Integer
```

## Control Structures
- `switch` supports the following types: 
```java
// all integer literal types: 
int short long char byte enum

// and their wrapper classes: Short Integer Long Byte Char

String

var     // if type is one of the supported types

// variables can be used but they must be "final"
```
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

// switch expressions must handle all cases so default case becomes mandatory
```
- `System.exit(0)` can be used to indicate successful termination

- for-each loop
```java
int [] arr = new int[]{1, 2, 3, 4, 5};

for(int i : arr){
	System.out.printf("%d ", i);
}

// 1 2 3 4 5 
```

### break and continue
```java
break;
break LABEL;

continue;
continue LABEL;
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
- `BufferedReader` is a bit faster than `Scanner`.

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
Integer n = new Integer(33);        // deprecated way

// 2. valueOf()
Integer n = Integer.valueOf(33);    // better way
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

// methods calls; same here
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
int arr[] = new int[]{1, 2, 3};     // anonymous array
int arr[] = {1, 2, 3};              // still allocated in heap

int arr[] = new int[3]{1, 2, 3};     // compiler error; both size and initilizer can't be specified

//muti-dimensional arrays
int arr[][];        // 2D
int[][][] arr;      // 3D
int[] arr[];        // 2D

// Range checking is strict unlike C & C++ and often results in RUNTIME Exceptions - 
ArrayIndexOutOfBoundsException
NegativeArraySizeException

// in method parameters
void foobar(int[] arr){ }

// length of an array
arr.length      // and not arr.length()


// multiple-declarations
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

### Garbage Collection
Frees up memory in heap used by dereferenced objects and objects which has gone out-of-scope. Run by `System.gc()` but nothing is guaranteed. When the garbage collection is triggered by the JVM isn't guaranteed either.

Mark and Sweep algorithm - identify and mark objects to clean, then sweep through and free up space.

Types of garbage collectors in Java:
1. Serial GC - single threaded, stop everything and run GC
2. Parallel GC - multiple threaded, stop everything and run GC (aka Throughput Collector)
3. G1GC (default) - for heap sizes greater thatn 4GB, divide heap into two halves and run GC on each, stop everything and run
4. ZGC - uses multiple threads running parallely, less pauses, cleans more garbage regions first, scalable (https://inside.java/2023/04/23/levelup-zgc/) 

Stopping everything is called stopping-the-world (STW) or pausing (GC Pause). It halts all the program threads.

#### finalize
Called automatically when Garbage Collector is called.

```java
public void finalize() {
    // can do anything here
} 
```
