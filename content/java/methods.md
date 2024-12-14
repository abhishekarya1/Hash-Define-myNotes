+++
title = "Methods"
date =  2022-05-07T01:15:00+05:30
weight = 3
+++

## Method Declaration
- a single underscore (`_`) isn't a valid method name (it wasn't a valid identifier in Java till Java 22, but still can't be used as a method name)
```java
public static final int foo() throws IOException, SQLException {
	// body
}

// return type must be written with method name followed by exception list; rest's order doesn't matter
```

### Unreachable Code
```java
public int foobar(){
	return 1;
	System.out.println("foobar");	// unreachable code; compiler error
}

public String getStr(){
		// compiler error if nothing is returned in body  
}
```

### Access Modifiers
```txt
public	 	   --> everywhere

protected	   --> same class, other classes in the same package, and subclasses (even if subclass is in a diff package)

package access --> default; when we omit any access modifier; accessible only from inside the same package (class or subclass in the same package); if we try to access this from a subclass that's in a different package, there will be error (aka "package-private")

private		   --> accessible from within the same class only; not even its subclasses
```

## Argument Passing
```txt
Primitives & references vars  -->	Pass-by-value
Objects  					  -->	Pass-by-reference

Since there are no explicit references in Java unlike C++. We say everything is pass-by-value in Java which means a new reference variable is created in called method and not actual object/array is created in memory again.
```

Passing mutable types like `List<T>` or `Map<K, V>`:
```java
public void addElement(List<String> listStr){	// new ref variable "listStr"; points to same list of string in heap
	listStr.add("B");
}

public void bar(){
	List<String> listStr = new ArrayList<>();	// list of string in heap
	listStr.add("A");
	addElement(listStr);		// method call
	System.out.println(listStr.size());
}

// Output: 2
```

Since wrapper class objects like `String` and `Integer` are immutable, their reference can't be modified but can be re-assigned (re-pointed):
```java
public static void foo() {
	String s = "test";
	change(s);
	System.out.println(s);
}

public static void change(String s){	// new variable created (pass-by-value); ref to old
	s = "eeee";		// re-assignment
}

// Output: test

------------------------------------------

public void foo(){
	Integer n = 5;
	increment(n);
	System.out.println(n);
}

public void increment(Integer n){		// new variable created (pass-by-value); ref to old
	n = n + 2;		// re-assignment
}

// Output: 5
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
- `final` instance variables must be assigned a value before constructor/constructor chain finishes

## Variable Arguments
The vararg syntax `...` only works in method declaration signature, compiler-error otherwise if used as a substitute for `[]` in class or method body.

**Rules**:
1. Only 1 vararg can be present
2. vararg must occur at the last of parameter list

```java
void foobar(String... str){			// or foobar(String ...str)

	for(String s : str){
		// code
	}
}

// Call
String[] strArr = {"john", "doe"};
foobar(strArr)
foobar("foo", "bar")


// compiler-error
String... arr = {"a", "b", "c"};
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
System.out.println(obj.a);		// still prints 5, no NullPointerException
```
- `static` fields can be updated from instance. Whenever instance updates, there is only one copy so it gets reflected
```java
Hello obj2 = new Hello();
obj2.a = 9;
Hello obj3 = new Hello();
obj3.a = 7;
System.out.println(Hello.a);		// 7	
```
- `static` methods can't be overriden, since they are resolved using _static binding_ by the compiler at compile time, they can be "hidden" though
- **static methods can't access instance methods and instance variables directly (from inside the class, without any object created with "new")**. They must use reference to object. And `static` method can't use `this` keyword as there is no instance for "this" to refer to.
- instance initializer blocks can initialize `static` variables but not the other way round. We can't access non-static members from a static context without object reference.
```java
class Foo{
	int a = 5;
	static void foobar(){
		a = 6;				// not allowed
		new Foo().a = 6;	// allowed now since we provided an object ref
	}
}
``` 

{{% notice tip %}}
`static` methods are almost like instance methods - overloaded, inherited, hidden, can have generic type params (unlike static variables). Exception - static `interface` methods aren't inherited to another interface or goto its implementing class.
{{% /notice %}}

### static Initializer Block
```java
class Hello{
static final int bamboo;	// either initialize inline or use initializer block below
static { bamboo = 5;}		// since we can't have constructors for static fields
}
```

### import static
- only for a static method or field, and not class unlike normal `import`
```java
import static java.util.Arrays.asList;

// can use without Arays.asList() now

static import java.util.Arrays.asList;		// invalid! order is wrong
```

## Overloading
- compile-time polymorphism
- Same method names but different signatures (parameter types, order, arity). **We can overload by any change in the parameter list**
- return type or `static`ness cannot be a distinguishing factor for overloading methods (compiler-error; same methods, so no overloading)
- so trivially, `static` methods can be overloaded by any other method since `static`ness doesn't matter in overloading

```java
void foobar() {	}

int foobar() { return 0; }	// compiler-error; method already defined

----------------------------------------------------------------------

void foobar() {	}

static void foobar() {	}	// compiler-error; method already defined
```

### Reference Types
- The more specific class (subclass) is preferred over lesser one. (`String` is matched if available over `Object`)
```java
void foobar(String s){ }	// 1

void foobar(Object o){ }	// 2


foobar("yo");		// calls 1
foobar(88);			// calls 2; autoboxes to Integer, then calls Object
```

### Primitive Types
```java
void foobar(int n){ }		// a
void foobar(Integer i)		// b
void foobar(long l){ }		// c

foobar(123);	// calls a; if a is commented, then it calls b (autoboxing); if b is also commented then it calls c (promotion)
fooabr(123L);	// calls c
```

### Varargs Type
```java
void foo(int[] arr){ }
void foo(int... arr){ }		// compiler error; duplicate method definition

foo(new int[]{1, 2, 3});	// can call either
foo(1, 2, 3);				// calls varargs one only
```