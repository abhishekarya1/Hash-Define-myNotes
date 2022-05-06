+++
title = "Methods"
date =  2022-05-07T01:15:00+05:30
weight = 3
+++

## Method Declaration
- a single underscore (`_`) isn't a valid method name unlike a variable
```java
public static final int foo() throws IOException, SQLException {
	// body
}

// return type must be written with method name followed by exception list; rest's order doesn't matter
```

### Access Modifiers
```txt
private		   --> accessible from within the same class only
package access --> default; when we omit any access modifier; accessible only from a class in same package
protected	   --> same package or subclass 
public	 	   --> everywhere
```

## Argument Passing
```txt
Primitives 			 -->	Pass-by-value
Objects & references -->	Pass-by-reference

Since there are no explicit references in Java unlike C++. We say everything is pass-by-value in Java which means a new reference variable is created in called method and not actual object/array is created in memory again. 
```

## Local and Instance Variables
```java
class Hello{
	int a = 1;			// instance variable
	void foo(){
		int b = 2;		// local variable
	}
}
```

- only one modifier can be applied to local variables - `final`
- remember that `final` on a reference variable won't stop anyone from accessing and changing the value inside; its to stop changing the ref variable itself

## Variable Arguments
```java
void foobar(String... str){
	//use for each loop to iterate over s here
	for(String s : str){
		// print
	}
}

/* Rules:
1. Only 1 vararg can be present
2. vararg must occur at the last of parameter list
*/

// Calling
String[] strArr = {"john", "doe"};
foobar(strArr)
foobar("foo", "bar")
```

## static

- `static` variables and methods are allocated memory once and remain in scope till program end
- `static` variables and methods can be accessed/called without creating an instance of the class they're part of
- even if they're called from an instance, they aren't actaully called using object!
```java
class Hello{
	public static a = 5;
}

Hello obj = new Hello();
System.out.println(obj.a);		 // 5
obj = null;
System.out.println(obj.a);		// still prints 5
```
- `static` fields can be updated from instance. Whenever instance updates, there is only one copy so it gets reflected
```java
Hello obj2 = new Hello();
obj2.a = 9;
Hello obj3 = new Hello();
obj3.a = 7;
System.out.println(Hello.a);		// 7	
```
- `static` methods can't be overriden, since they are resolved using _static binding_ by the compiler at compile time
- **static methods can't access instance methods and instance variables directly**. They must use reference to object. And `static` method can't use `this` keyword as there is no instance for "this" to refer to.

### static Initializer Block
```java
class Hello{
static final int bamboo;	// allowed
static { bamboo = 5;}		// since we can't have constructors for static fields
}
```

### static imports
- only for a static method or field, and not class
```java
import static java.util.Arrays.asList;

// can use without Arays.asList() now

static import java.util.Arrays.asList;		// invalid! order is wrong
```